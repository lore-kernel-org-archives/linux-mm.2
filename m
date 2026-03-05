Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA25BF30959
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 13:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A818D6B009F; Thu,  5 Mar 2026 08:12:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2F136B00A1; Thu,  5 Mar 2026 08:12:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911746B00A2; Thu,  5 Mar 2026 08:12:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 809F26B009F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:12:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20B761A012D
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:12:17 +0000 (UTC)
X-FDA: 84512047914.14.929C354
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id 5E737160012
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:12:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WUWJp36W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772716335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7s7CgYcCdrXdA8sqQRlC4akVtLbsU9NMIRxjWqS22BM=;
	b=cdVHcF8OWzAx9rZzJJMtdGOFv8G4ODA5dINXlUfAkmewI7GqSsJyi5xMJA3DVuIjtVy2aJ
	vS3Tng5vQKxeUKOPJD40CdH4vZYlQMdg25g1j7vFSkN4JezRcIDhd0uKWCvSs0DIoSuyKT
	rrDkTZytf1o25Wn5a0WpdnTDCBtytjU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WUWJp36W;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of zhanxusheng1024@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=zhanxusheng1024@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772716335; a=rsa-sha256;
	cv=none;
	b=Hgi0GNCusgN5x2f7SpqFhWp70CaFl7c2sGhjkXExk2xhKeP+Ws4cg4IrJpo5sHzJAsaIO0
	EaxxyZlbHj9njBHaklaixQ0XgrT1ChKDW6T1IMyXT5dR4CUfWqsWzg/nyawh9CXVfbDObP
	xGxcTlfJYgoHnukN251bOXRHun7x0Uw=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-827546f228aso5886900b3a.0
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 05:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772716334; x=1773321134; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7s7CgYcCdrXdA8sqQRlC4akVtLbsU9NMIRxjWqS22BM=;
        b=WUWJp36W3b9r+iy8+ex3RDuOZBfcxCa9UyhN7Yr4wd+b0Ex2m1dMEsu3XYNdcZsSct
         kSr2ej80Cp2oU15GeXgi/Dxkuxvjrmr2LIPxMn9PYViFT3lzjHqdXsRv9egWkROombCh
         ECVNv9OC3WA4kt5d+gBH+XKwB8tGtVm1ePGA51fi9h/p44oDehShWrhxDYIUL+75ZLSZ
         ZRzMEQXEyU6pRlE8bfXLsJixi/ImsMEvNlI28HVY628nkrC08U18SkoWnRyB+O2ssUnS
         Z3moyFvdMWKRQCt8k/WEiAW5qcrkEIj3cUJS0qbYCFEp4rfx0yUXKOofXIEFpiAGfMX9
         2ZvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772716334; x=1773321134;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7s7CgYcCdrXdA8sqQRlC4akVtLbsU9NMIRxjWqS22BM=;
        b=KwXGubtG+zJeTJLJyal3lb3MxNCR65fH+XsS5ZBHLIJGd3MyUOK/d3pKGi19uCO4A1
         wabK2XIYLr6LaicbpyM5Cl9k9Fshfor9yMvtMsUXTrzXJ57jr+DK1ttzGDl/N5Zyu7rf
         yCUqQ8uwTZLWMtoA8W1fjUbWbFIv5RXDMyHWbk2Xc9V4vUsDXq0+UkElbosKFoNXvshb
         TuxV9GIWLAoOZOfIClAxbzs+dXlI1QkmuEhSSvIupXmUOnLQiK+qVcfLbM180jNj3J2E
         pXVvmSZu6ah2b4LXJmmZHJQFrDsakgFJuWkIQZZuhFur1HEYfMQdwaCEHiSIeBDn6+cU
         Aa5A==
X-Gm-Message-State: AOJu0Yxu9CKMcAXLCmOhXft8A6oJGnXg+LHM9ziyja9JZzKYLWTXMewu
	XhjfnavIrCdkJw40sRv6HEKpflUXBs1rLxSEZNaDEqFvH53Qygnse0VJ
X-Gm-Gg: ATEYQzxDQxTl6x7hrVLhoxabqllUiRKk/2VyIWU9uwfp4OJgKOuG4zuuzMZU3PjzGMZ
	n5f8fp6eI7D2K/ErrWgvbLwH/EN7ryqlJwvbrwKUh7+M8Qy9s7oWnJaoDHYJSvvjiwXq9S/k2iH
	HILd5WOi1E7jF5eeDV8ub0XCEMjL0hrxdaIdyTyQq7emY1gr5XgwvWy1NSN7CwvPemIfrxtchgm
	nG2IkziL5IF3H2smT7uLzFjz1t7F2i0s6SRd0FSe/QriO9WkLRW55hZb0TzKxFd6C+VlQ1OQTVR
	3E2fnKziecmsh299ovR7KUPtF+8VHDQekM8PDYemEp2Q8bEC+JPw/CapLHR/DK1O3SH5PbsD2pF
	Hz55aZ/D0FUQDhhysi0ysL0TksYQ10ywQkBIrWwUbbhOTSPQeBlTzKZlbBRFaUc4ZjYgTlk7FcJ
	M9wxeeD9KrCrwlk2EXSKnEEdTz5ldp84yCHMeUtF/BPOKXu2w=
X-Received: by 2002:a05:6a21:898c:b0:398:4a1f:8a54 with SMTP id adf61e73a8af0-3984a208097mr1222643637.2.1772716334123;
        Thu, 05 Mar 2026 05:12:14 -0800 (PST)
Received: from DESKTOP-MOQC9AF.mioffice.cn ([43.224.245.226])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c738b11a5fesm2171038a12.29.2026.03.05.05.12.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 05:12:12 -0800 (PST)
From: Zhan Xusheng <zhanxusheng1024@gmail.com>
X-Google-Original-From: Zhan Xusheng <zhanxusheng@xiaomi.com>
To: Alexander Graf <graf@amazon.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhan Xusheng <zhanxusheng@xiaomi.com>
Subject: [PATCH] kho: Fix NULL pointer dereference in kho_update_memory_map()
Date: Thu,  5 Mar 2026 21:12:07 +0800
Message-ID: <20260305131207.5584-1-zhanxusheng@xiaomi.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5E737160012
X-Stat-Signature: drgibntaky4cmziwt3w4rm3krseys9qr
X-Rspam-User: 
X-HE-Tag: 1772716335-322243
X-HE-Meta: U2FsdGVkX1+eVbjRVTu+fPWEugH4alm5qTBgEHznunIv1Fp9XghPr3H26sg/uE3pP2LkusXlpgb1ix0MaNN0PTLvPMxlRZOce/i7aRnytylSRZ7OHfTTwkMEDBwIuY8cubV0AprOPFN4+LHwMbJTcaF7YYK24uliZFLM2dzrgHNnJ3aUcSm6KwRVNWMMyJmzwHm+awNRZ6Tv2rxdQHDMbmN+OeVRCEw8Pomm49/EUOUZqWuhyQK5GxkVABfzuBEXW75Sy0Py0KkvzKvd8/pcZqjg2xuZALFNU9wyJqpxrjA8/gQE1xvVePE5AgEjJcD11ju/VNSt+E2bC6MH+d5uMI6+rhnX7/6KrwlB/cB6CWRGv+gOAZK9WKlgFdErjtFXdRjJT38YQNU+at8gJAaQ/EM1OfqII67nZ8CY5vmPcYkWKkRvodkp4Q8iyKsJz5Rcjgejy4lCe3r6WmlEPJmxM1VScMvcHpe4nStZW1LIXg5bF5fGmlFvYBlqkX00PKPy5H1mnHp25DbxLaZu1hReNAep5mAqmRylnml/eq6wXFo1goNI8Axv+mFFcZTSLHy2DcRTeicpe684KqvVqXZqeKp8YQuSmpIvGt+svZ0SbeKQf8x4NkuS8hvGQ3tHRB7XQYL47Rk0VaoUuDIYV2uE6iPb6eUXxasNlLLCn0aE9mB0aCRwTsfjRFyuXiBiaJmDoEib9xRMyuO9CcS4Y1p+8waBZejtyDS5wzazV+fW4xCdwNy7sW48QyRPEwCBc89fv3l+BXbYTv1OqNtM6GY/jjw1nol6J7JCQEJHPlDdiCWtoN5O9ztQw2OoAzwMXJgGMZqt5FAZY7OfxF+QxItPe0Z73NKxXcWmLcbPN8PAEnBkQXhhQgc4LI9dEgytiT6vToaCSfLf+joE/yP/ShAqYUwFeoc3tqgpOfhfzTKt2947zTJda0GxQc6IsjIEjSfKhwHKoNEBgUviEUuhITP
 uq3beQKU
 bLcF4laxAm2A8NIJnEXQ6/Tn7BDVZXxS7YgrzTGVrdvuj5xktwLG4ZevSqnLGx9CjVo0pNQ879gIQOqXncq+m4R80+Kmg1Qa4riw6RUl8j9xc7cxHJkAlC8RvD9BsK6aOJ2tQ70ACeMlG5O+CNNBwnaq8nyBOEeiMEX7ZqD+lAPXoQnaz0B5mzrE3bbIDsiUPrum7TkXd4h7QAn5/kd0SFbYyFUoR9OkvFEJQpEUhC1+BXWU+sW6xwNzvzlW3+Cvlp44qRN/qXlfpgbWNtVjTV3HGSa5TylEpcCohGeOSZ+/nB5vS/ndiYdN7Q5fYqI10/w3dNsvI0IQkxu5d9ZYOWyZIZRQwF3p2vUTFvizkHs0ULPxZtcKur8CSb6jKOgnk0BcRu8HUG05H8nPZ+7amPV8QcB52S4fxuZM3GpCzSOLF4NABIz8ao7cqxvgVNDaIVP/Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function kho_update_memory_map currently does not check if the
pointer returned by fdt_getprop_w is NULL. If the pointer is NULL,
subsequent operations such as dereferencing the pointer or using it
in unaligned access functions could cause undefined behavior or
crashes. Prevent that.

Signed-off-by: Zhan Xusheng <zhanxusheng@xiaomi.com>
---
 kernel/liveupdate/kexec_handover.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cc68a3692905..f6ad87930003 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -397,6 +397,8 @@ static void kho_update_memory_map(struct khoser_mem_chunk *first_chunk)
 	u64 phys;
 
 	ptr = fdt_getprop_w(kho_out.fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, NULL);
+	if (!ptr)
+		return;
 
 	/* Check and discard previous memory map */
 	phys = get_unaligned((u64 *)ptr);
-- 
2.43.0


