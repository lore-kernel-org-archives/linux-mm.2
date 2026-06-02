Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD5C2CD6E55
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE526B04A3; Mon,  1 Jun 2026 23:17:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A67C96B04A7; Mon,  1 Jun 2026 23:17:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92F416B04AA; Mon,  1 Jun 2026 23:17:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79EB16B04A3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 302BB1405DC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:23 +0000 (UTC)
X-FDA: 84833511966.07.67281E8
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf08.hostedemail.com (Postfix) with ESMTP id 60E2E16000D
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yj3S1Rvf;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57XHE07VPesg/638uO62i0q1esIWZpU9ZAzOqv5wFOw=;
	b=s+kM8LBEYDsM4WAZ66xperpkpnx/+MnOqDyDONzvJK/IRVj1bkL11Vtfxu/9K90fl7QdBj
	s6B/SqoP60nBGsWkBeY56pzX/MFf+vbYrTiMznRbsEZ6BDWwM8ksPcj2mAYCt/+VHlnKMB
	CWAwjM+YxJxG+wqhwdura8KxGe6HhiY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Yj3S1Rvf;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370241;
	b=0zKPE7I/lgw+wRU/4VWuOzea8r7lkG0ZuqR2gucFwma6kXi703+J76ecMqo9KhowHJuWjA
	XvTZAyX9tBWpeFjdl/Ojze5ZINLywGjctQVnbApwI/GtXEWo6Ndu0LUqSG4w+D+ug3I0Vv
	Dlf8RPXv4t4FnK3dJFpXCfd1GZ4sm3o=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5176b9c476aso1447281cf.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370240; x=1780975040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=57XHE07VPesg/638uO62i0q1esIWZpU9ZAzOqv5wFOw=;
        b=Yj3S1RvfaZvdCLaM38pCoNTVl/ryFj8d1YZnVZ7aIOtTcZG7uFK3jPIEmoucVXmC82
         b/OhyQhvH9imfJ7F2Y7UxpfOgu4GyoqM9xSgg4OTdiE8Sf9FNPqsFeKOvzHu0P8CNqwS
         LCF9P67lJBP80Dot1CKdK4de+3YhxSTEWahYy/73isKYtKONAcKX69FR2cjmMFS616e/
         AMmaQAjtBhQq7yqiZJPialIGU790BX5yIB2iWwBZ/Z8suonh5pOsJnKQ2O3Img93thg9
         9WZx61YL0wgZmMZqEFUIGRll9krTpM5RCqhKMRgjspmI++Jz20rwuo6V6BGaAue3G5p4
         dY0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370240; x=1780975040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=57XHE07VPesg/638uO62i0q1esIWZpU9ZAzOqv5wFOw=;
        b=DlLGGdr5pCZhPVqFIxZt0ajjsitAA+Rk7tHGztAf2ycHUiXJXMX9hFx+Xp9LfYpGWj
         dKt/1Om2Ht/g1JcGUAW3oQLxCIvMbl0bx2DHWemOZk/ZVNDJGipTGkqKrpbEAJ9ABsjs
         k/9BZI/aSPSd0d4w8j3IL9EnJv1OuYriv/BDH/MLXoS++yQpxcmApvAlI2CDJ1rin9B3
         0clGfkiocPgVVkOo0WhgmXlql1bJL9eZ66SgN1a0QcvxqVZ+G0pbTgsaRRcakAG/+DYm
         d03l03eBalpBM3PH8eCOwFwWVV6ES5VtsHneSQBA4nlUTKSg8RGPCJLignr9oSDL7arD
         9ZtA==
X-Forwarded-Encrypted: i=1; AFNElJ/pd1KJEcooxy7y1OvvoQTMi2oLk9rkQ0V8wSDGklRkOEYOMBprYojYpxiSlw0dxvr0U1kJ60wcKA==@kvack.org
X-Gm-Message-State: AOJu0YxOsUsyn55t+flRkJEP1QksB/nTzh7DrnoOfEyOfWENB9k1NVOP
	YPxhaWn5rEt+lCTy134t9K8SPRn0ceeVxHGVPxSBJ4N+zJrVqsEJOXEcUqhFn5ck7ps=
X-Gm-Gg: Acq92OEH1EKGvcKgNxGNOaq5MJJDf+THqXqmajUL/CnR3JG4IFD1eELU15OVqW6yJz+
	l1Z2pKv/INSGM8w8RKQoilWR3JDv9k+TbT0+b3DDziheKVX1oQarCLw8f+tYc0Mx9xzLS0vPtPk
	U/vBo/+lMtW5IqnoeG2nj8+exSSwa9GiURr6XIq4YDNW172u21tdYAlqkYn9zucoF3D28gMSUvO
	g6nnV0WZOIKki0ZyIosaI9X1h0eF1DseUpAwnqSffwdEd2A0igvZPevXI8q2XEK9OBWfdoDYDzK
	pyPf9YLgJJ0zdIn+NKpZY8ku1LAopRpRc7MuszIlXCq/tARIPFSNjvtPzsG4h/87Wmh3KDAOSnh
	+mZaOUsSBw/kERlWvVIIlDMfehkXjT8NWAaKISXoal7lVvR//ESXvxrpWftUGFD2eYkQ/WEvyAb
	kRDUEX2B50bBiwvd8drwmne7QY8tU8jZ01x1krixv0T0QgKm2WR4dpmFXhkJXriw==
X-Received: by 2002:ac8:5dd1:0:b0:50f:6415:1eb4 with SMTP id d75a77b69052e-5173a97fdd5mr181349891cf.49.1780370240533;
        Mon, 01 Jun 2026 20:17:20 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:20 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v5 01/13] liveupdate: change file_set->count type to u64 for type safety
Date: Tue,  2 Jun 2026 03:17:05 +0000
Message-ID: <20260602031717.197696-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 60E2E16000D
X-Stat-Signature: 3k185nbuk94rj3989j7dhcrsgmscjpzz
X-Rspam-User: 
X-HE-Tag: 1780370241-628037
X-HE-Meta: U2FsdGVkX19TNQlM3mT+H99Li7+0c9qAmxUaYP1e+9H1oakyCzGmPITejry90nCHwU8aw8rdXRdO4BqXOlySFH97WJ3e0ZCU++cD/5oYsChaDITuL/dI+oeG6/vtLp1XZdnLwU0pfBML67AqEXJXj5aKYCclFcGo+u0ByEvEJQi2qWJXx6ox007r2vdlaG6PuP5/6KwB6O/pljRCq5tKVS5wseOn0x6LZRW1HDoPVkizlOnyCSNWJUtdFbe4KtxCcvQlQQOXctgRdRxuR2Y1fgQwz6W38N4frbCTY7kLkRrY3ZI2TgBSjCqD5QgJGn55Sg9EROxS3JvhNF01PFZXMK9LuINUYoOxeIrBu+npeep5/DvKLZ2Y01JGaDDjI4QwtFaZMJYnn15GO7aoj0OhYiYfSlcIhhE8nl785xvcxs/DwiL+59/uIQsm6nIy9jZCI0uVdyOncNcyPPQjm1OMvozQBQBVCexl8LicSBHrlWSQ8gDO8fmNjVUKKb6TYFLZ2m2vY2QmIgQhzt75KvLms+uFcVrOfDls/zKSxiuJBhjKIhLJddLNSOrX+95R6B1USIHgn6mah1jvhS50L/5DzmoOuaohucOgT+qTeT6vFl2nMCWGO/0VNgGEp7nFYU4qrgvZsyG6HIlkSAD27F+yzcF4vnScOyRcRCNgWEdiAxpCZlLGWUpQxqCZHFWfao3qkDEqgjWawJHz0YAHFjTMd7t7JHaLMjAO1bheuBKsMHC+bkbN7hNjOjFqbh1JZW+a2PHLlRiJ7ScIL7bvyBNgS8BYcS/dnEFnZAM6B2ty/n+YEIsHXtNqpY4XELyYMDTVMQFqhBY/kv/zFDzG4BFBTqgRcLCOVG6BbozXojSNcstY/jDfY/MjePsVlU8jMeObTn8D/5Z/EYIkuHkHG1jt9AfTCGJoXHmngq16RmV4FSF5GtuULydLNe6k4yUntaICIsRJDznTmJFnhbwcpOW
 ogWwDlPq
 vDtG6t4CvE2/DuFZrMYDKR4/e+B8dG5UyZIkZ3XSsd5jsaQykTty+eGbVhp+LL2JLb+ashRn0VOk5xA0sVmYfFY4kljSYBuNtVtzEcjCwT8A6bOws4QCiYTiT+ErMbX/EWKTuXy7ZSWpOuc27PQcknxPZrC2M0HiH5pPOmFPWCyd67x3xl7SXt3K2Uzeu5gmWyqILb394jepIekWf1oZ5OUcbDBcY1BbSkaZnTlHEGRSmAi0yuPUvdKSWGnH6VhZV5xtjrg3m0hOTDtBDu9AWZO2w9PF7H/LXSbfusqIqDYGg9VFlCSaLwm2Fiyfn31fxY/GLPmgbVb76z57BKn4XR7v+HVkEV/ucbgkl/kE7hRuAOC641R2hWPhrOilzkDQHwwQPYd04aCOv7bg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This improves type safety and aligns the in-memory file_set->count with
the serialized count type. It avoids potential truncation or sign
conversion mismatch issues.

Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dd53d4a7277e..ae58206f14ac 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -52,7 +52,7 @@ static inline int luo_ucmd_respond(struct luo_ucmd *ucmd,
 struct luo_file_set {
 	struct list_head files_list;
 	struct luo_file_ser *files;
-	long count;
+	u64 count;
 };
 
 /**
-- 
2.53.0


