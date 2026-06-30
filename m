Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63035C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57F46B00BF; Tue, 30 Jun 2026 11:05:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C087D6B00C3; Tue, 30 Jun 2026 11:05:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45766B00C6; Tue, 30 Jun 2026 11:05:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 850AD6B00BF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:05:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E227E167BD0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:05:04 +0000 (UTC)
X-FDA: 84936901728.11.5AE3FF2
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 03CB816000A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:05:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L06JZ85q;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831903;
	b=62IjaZipr/P6J1wHklWEGHQwbI+FUiNdVCO8LbG+uv8fQSHwCeFHHQq0C78rQUMJrehgVb
	FI5pw/y5a66L8OhWZsD4SmTZDLy+RTf01Rf5h47I/2lF8ChhijW0hylsfcMSJx45Nk5IJI
	l739RwYGsDXFVURwqPAd6UEo8P3l3CU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rOFTBMMTbyd+uFN7Y0FcTh5M4MANHeKRdkzp7z4esAc=;
	b=5xu/MXbJ+mgo/+P2ygWvix2KHj2iPn9TLlbAu5YCL3Zg744SsQdu1ULJj0kv2SKGQBlwVN
	YaTP67ZLoe8OY37WO1VwCyC1ip0/UbcPbD83f4SHGBtv2E9WQVpDiSQjtVYAky59JRgzhU
	ILKF+yScm78WrJFp41HNQA2S748Y7WE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=L06JZ85q;
	spf=pass (imf08.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2c7ebfb63c6so29592495ad.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831902; x=1783436702; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rOFTBMMTbyd+uFN7Y0FcTh5M4MANHeKRdkzp7z4esAc=;
        b=L06JZ85qwAF/Ujd4ai0fs/pWXu1U3U1h9kCd1hcMDogtth02iG/2UoRUUSlxnAhn/h
         2B+qUEnjMIKq/TTZXHEoVFBGU2XOneah21wPMp0YvbRPC5cI0+c/8Hnh0+elnGKHrTKi
         LwvthgMdkW1GZn2PuZW1EbX2WtoMVmWFi5X2qIXf2qCBDxIocKarqFZjBrVaPNex2g+m
         OQ5rEhCzKKI4F1pHRO4GMG7IiiBAFXj0HI5is29v2gHUuaVeis2OndIoH+AeHYI72Lr7
         TS3OhbFokJkGyUPRTMIcuNuuqdjiT4ldWhPU0aSuPUTHhtDOBlWLZKoCrszaFiXJAbo6
         E3qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831902; x=1783436702;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rOFTBMMTbyd+uFN7Y0FcTh5M4MANHeKRdkzp7z4esAc=;
        b=kMnlf0s2mxZG+UjQ2zVQdKLeV0ABo/dK+MBRrpoGPdFRaIaK9MXTrTsOd4jVvAe0Eu
         wZdTXC4UDmairSMCZfORO3qL/xDzO1VIdLXWyvtGVnurY9j6ckO0+3Lvkj7hZZPQADgI
         dZEvtOxitCoBSnv0VEqq82dPlmQGeGhuJBlbZD6ipBYE62HgswueAyyGtHFUOGfAFbB8
         WwGqw66J/lAqobELh0jr8OS7D4Cfo3eKQFxgo+Evtk9/ygJTJCvgSrEB4vDmnG/z9UbX
         7a7ar8fNDQbp/+fAWMx8Q8Gxt6W0yRJpneaDpcYZEU0pa9I6yL9RC7Uq+32Kj6coURTD
         XnVQ==
X-Gm-Message-State: AOJu0Yxj+GuTdbM2uklSJUPcF559j1NufQBpnkjSj7WT3xWMZBRE++EA
	/etJ1gB+txImHli3h09JUlFKk91AyfZnD4JA3eSIR/SGJnhjQ+jtWNkQJBKDTA==
X-Gm-Gg: AfdE7ckldkHdmja5nSs3SNv4W/z9BUGLnrJ1ZdY8F0ViifS9hVf04LKgjCqLSupBr8N
	WMh4zTx2QJqY0wYCaO20FMz53l517rFWDdqhND322fNw4M3ttwXBF0DEooYj33fb7cPIgfi0v8c
	ju4LaAbmC+UFrDT07kcNkLl7E9oJHT7c01hyHoyADZq9zEktB3FzDiO9Ykpbftt2ud0nbVmKZRi
	/xd052e74tXEK7YAbvzw1JjnkrqF/p57W6yYvFMIZmoZTC0dmm9vxyWd0z6HQaEiajqxDbxDVav
	OwbCLP5GNL45m+/6CKJJhIYBpN3vc26vdjV9GYebA06Dz5OcV/GVX9qjUiAtLZg3IiaE/icxSS6
	WqPjEa4JO5WOO1+awsPMVtsPtJbS3HVMXmxYneVfzUH0eJdlxEQiVVWjrxz5p8+sC8JfStXq6ht
	CDtE5wLt0=
X-Received: by 2002:a17:902:e5c8:b0:2c9:ed16:8d8d with SMTP id d9443c01a7336-2ca2ea2276dmr34277865ad.38.1782831901637;
        Tue, 30 Jun 2026 08:05:01 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:05:01 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 7/8] mm: remove unnecessary empty range check in early_calculate_totalpages()
Date: Wed,  1 Jul 2026 00:04:12 +0900
Message-ID: <20260630150413.1718632-8-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03CB816000A
X-Stat-Signature: w47j7o7pocqx8j6833a6ze4ptqqagrag
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782831902-551466
X-HE-Meta: U2FsdGVkX1+0uQxcYdoZtFt3nUwwtwgGlNy5Op9hCPz8tX0k1edmiWKQb7WqFKPMEKSczrJbNCNLeftOWOkXoPnzTVqjebET9qlqL11ywNh1OuNAg02lqAJUu33YwX69kR9zYmDM3uCqfVNr7L7+0fcjTW2vK4QgwU2aJK2OTtaF7VsUQv2n4XfhQRD/jt39z+wUwELo/kgFMywA/AhBtjXF5Hs6vjf0jSRdC8ZpaQiUt4IxCBuvWL8FeIAyJTpenBqjl+eC+udv4k2Meh8V5f0t8PAa7iGgNtzwMyj8FLajbUocte6VRkRd62XnkJcsjOfVvxTNTK6yzwaTEh+hcU7ULRjwdaee83+5xaaCk31luO4+Bd+9JxYHM1CqF9rgodvHn+BWDabNDgpVDdM87bL3bWVj1X/JTxKHg8mN9ucly4CYOMBgxFQQVe7J8BFbAQo5938Wh21ticEcbKCAaaufizukLdJdy805GtwR2nlwRB7ImD+QdBI/VQ4FePfIecVmvakuWZi9kVhrnApJXlIOxisgj81rGJy5jX3savm4aI1nyChdaYv3t5Vptu2iu+J7YCR355yvxqjpILf4KkFCL+8thTv0tbYZ1NYbV+3dBS+qhIIMJKj/mstGyPXD0x5Fqz9bWYlKmdMHi73gXE//dAvj1xTr2GreGl5ibRFErsmc7a2swr8AI3LxjhfWKjpmpJ6/c6bR0z4APMHeRtGEwLjPyQE6pi01MW45FQzmocI0fllK+gcr1bCCGQ9YoqM8FdgPo0BWCRXx1PRL7cKtbFR+bQ1KmEtSzYkCHcue7oHSy3XkiFpjbkOMKwpezZ9SLpnRz9dXzi3eruqgikfmFjQViQIWjzp8ML9XBV7bellv++6zswpXXrG71Tcct1QyPmRoQ9cVeSS5TFr/NhvX1LMz3MmxfWHBA9msiAgsWXf0mX9LQvdLRMs6Nd/W3LufJfcMyT9E407Iyol
 piIOX6IY
 rp4mYavtUnq7izmYJLzhGxLHf8iqEKC5OficSITNiV71nOERqkHhoEP1cP0QSP8MQNgX20og5STqng+ba5xkGi5qGealajBcK+sj+DPQqn2p8FvKJwjzqAc7+rWnwayWo80t0RqWnsghb2vJSUPwvY2hRqRib3tTmojbjheTRPJZVKa+VJn3bQPl/X+ZFyoSWYWPRewC8vBS8sCmW/FBmHw9/C4mM/xeNFLzp1Map+zB2cgi9PpAKRGOV2b6Ur9MfHfnloJF9+KLH3uXHGCLfKYEnFiNprBB6MGdm5RZ7X8boxxoI5EPlvIJVmAJKAdLUELXE0UjPxTnrQeMOc52yIsKfeUyA5kpw1F+d76NW0HwPhWpmnOgnifXoNcTrevsjOlyg6ksu9xIzbVdRqYayAjOOQZ+6w5np/pA2eH3PlvYlQmR6EBB3Fw0qMf9UF6cfVzuxFNIEKZ+Lea+9zVXe97dWVcislSjAxNPn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

early_calculate_totalpages() iterates the memory ranges with
for_each_mem_pfn_range() and calls node_set_state(nid, N_MEMORY) only when
end_pfn - start_pfn is non-zero. for_each_mem_pfn_range() never returns an
empty range, so start_pfn < end_pfn always.

Therefore the check is unnecessary, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 0f64909e8d20..17498a13eb99 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -332,8 +332,7 @@ static unsigned long __init early_calculate_totalpages(void)
 		unsigned long pages = end_pfn - start_pfn;
 
 		totalpages += pages;
-		if (pages)
-			node_set_state(nid, N_MEMORY);
+		node_set_state(nid, N_MEMORY);
 	}
 	return totalpages;
 }
-- 
2.43.0


