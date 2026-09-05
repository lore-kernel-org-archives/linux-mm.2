Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72D47C79F99
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 18:32:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63A0B6B008A; Sat,  5 Sep 2026 14:32:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB1D6B008C; Sat,  5 Sep 2026 14:32:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 501296B0092; Sat,  5 Sep 2026 14:32:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BBD46B008A
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 14:32:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B1A15140384
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:31:59 +0000 (UTC)
X-FDA: 85180552758.10.A7EDE1D
Received: from mail-wm2-f2.google.com (mail-wm2-f2.google.com [74.125.225.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id DE55E180003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 18:31:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZaE91U51;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.130 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788633117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OcD2qnbZrk6xfsMXTNlMY/8/zgvFTRRcKt+3bM1RQW4=;
	b=HBtmS012LATkGyfxIbvG4X8y6sC6z7sL8gPFHpMiVuZm7d0m38HTk4Opb+qp+dfXNKKwLP
	eL7oSg2J5/z2J+9VhzZNLTKLdkQoEYvj5wT+K9LxPyBcdNOCIL3Bi9shYcHtyFKA0rD5NF
	bu5M9JKr/qMfmlPSbPxYAFub1SQniWs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZaE91U51;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of christosskarlos.kernel@gmail.com designates 74.125.225.130 as permitted sender) smtp.mailfrom=christosskarlos.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788633117;
	b=LXH/gnIJEXNkYfx+ecgafJGarbh5UU83GQ1T8rT1WGp9Kb6HCj+QbDqaBhDLGZca81XCRV
	ku7UMJC8IKGZIH5cxwyscWdo79zAL9i4hQsN3ZOTPB8d4Nqf78iDaLd62Gk/ExuC+3puxj
	7exKYYD8XuryeAw/gKOvwAJwTbQtKiw=
Received: by mail-wm2-f2.google.com with SMTP id 5b1f17b1804b1-4926d058720so6082355e9.0
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 11:31:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788633116; x=1789237916; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OcD2qnbZrk6xfsMXTNlMY/8/zgvFTRRcKt+3bM1RQW4=;
        b=ZaE91U51Ejw5crWKvBKf6591gE27fSZllfI6amZzFQBtUCa2V27QzusomH5sGoqT39
         zkfAcGugb9WdP+jtY12cYLD7qNsaivN2ov6Tn6pT0lbw+26LNY+YUoF/b14Lb1DT22Us
         yLCjb29Bv8A2j9SGbFXVA/RD9JMUYVCXsM5HN43jeu26QzqaKRK4IfD8SN8croBjHl6V
         aSFIHaVNLL2xJohDhBkqiEJq54JJ4VSpZjEDN+mC32DLLmvi4ChbhD5/D668JLQ4bOAn
         FjAE0BOMqfxjD7rioPaZrRsQLWrd9xQCp1U48UuHzKtJvO4/ES2K3bjnVcdEpy/Z/QhY
         h1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788633116; x=1789237916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OcD2qnbZrk6xfsMXTNlMY/8/zgvFTRRcKt+3bM1RQW4=;
        b=TPcE5j1fKMqV5+rkcuIX/t8nQpFVf+yNr36feZH6r8KMgxG6gFDciMCYgcefEiOADK
         n4IbqaEGpIhezFosFtE+h0z7tp2oiNT+XHaeLHAy3Dbdpj+4Fi7hSHvIVNi3b+XUypDz
         zcoB7gabrKu2dzbK+PGYdOWWn9RZw3oedjmteBFbK0gIrd9Hc5JZvSrK7gPeN0n4yVZI
         PgpAuul8YfPgHe5Y2yGCzhCxLfnPTc6vQa+NGI/sUyxO+5w7w5EXABZQUV9LKJ0CTpqz
         QbmtAO/Ej19ZeBsWrrC1AdZJ4BSAaCB8Vk4p7xVWhz7n/zmdGd1M4h4pYoptGJyKuwwl
         0BDA==
X-Forwarded-Encrypted: i=1; AKwUvBw2swwPvx6GUtbDxAAAMbH7yLXZhnPghCDAtoHUzEVS8xV9bB7/K6rdZiDonOU+Se8KaGMXN2AM1g==@kvack.org
X-Gm-Message-State: AFuF++m+IYmGJrooRVB1/OT6tCRXnp7g6Zi5ly4Yi/73mczpJeq3mANo
	EkV6elo3AjAhstvKiKZpT6xTH2l5O1XrjRhakIsZIK0p9zNR4ib0XGxH
X-Gm-Gg: AYBFou3fhucxu6L6/+mJhh3IRZITpm40VIJDpjtNvnYcyNFi7S6z/A5s5BDHeeOKI40
	TBV/ih/NdAXHPdgSkRYoR5lm6N4qnBoAndRtJDVliPZwPWsPDG+0rpx4A6gvrFnxuYzZW1HKmvs
	BCqGbMm7oNkM7MVemJXShqeWR/vShUooivYP2Wfab9uk1pr+BHiHCamrI25nkIxaEzLab/ji0y0
	epNJr1I3fau0uaAwXefpN1tgDGHI/YNu+rNkVCOTbpNHMvhS332D3N1Oij8esfSVAYNWnLF1xuN
	RL5Ku28sOyTqa08RiRixKNqH2GUpNXoaVra1a72J2mH8yj6wu+OjFzQY5vvnlxNkmrf1MZW+waT
	CjW/CvsOrwZlP7id3Td6HvP+9w0YrNkXDToVGWPfobybKuvi6NKNWU1DZy7BuSabV3wOODCVNXH
	0iGRQspOtRR5jfQU6Ck6kCKe4Ra96zgSje2ORPIU1+ZdAOHoVydC85Asouv1/U+4VAI1F7G/O/0
	7b3G4R+ug50/iNCSc9zgPx7QcRaHA==
X-Received: by 2002:a5d:4c8a:0:b0:484:338b:3bc1 with SMTP id ffacd0b85a97d-485872edfb5mr14248775f8f.27.1788633116296;
        Sat, 05 Sep 2026 11:31:56 -0700 (PDT)
Received: from outlook.com ([2a02:587:6022:4b00:84ac:4417:9f37:a496])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858d2693e8sm13066670f8f.3.2026.09.05.11.31.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 05 Sep 2026 11:31:55 -0700 (PDT)
From: Christos Skarlos <christosskarlos.kernel@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	ljs@kernel.org,
	hannes@cmpxchg.org
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	mhocko@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Christos Skarlos <christosskarlos.kernel@gmail.com>
Subject: [PATCH v2 1/3] mm/mmap: fix various coding style warnings
Date: Sat,  5 Sep 2026 21:31:33 +0300
Message-ID: <20260905183135.20993-2-christosskarlos.kernel@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
References: <20260905183135.20993-1-christosskarlos.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 38t5j1mhhsf7f6kyiy9wfwhtg3ooasr7
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DE55E180003
X-Rspam-User: 
X-HE-Tag: 1788633117-71018
X-HE-Meta: U2FsdGVkX1++getvLGYQ10Sv54NXgm1hRSpyTFm8Uxhzvwlm60Rc/X/7eexm+yz/6t8bpoctnrLGiOh7WQo2NQhSIbfQ83wvENOH4ihUrwf6XiWlVTrrgHDBcUw3Q8ict0X2xDT0JsitEZMfolpiANU6gWs+N1leDL8oMTSf5DeDs7dKjZ0lwGziuTXNSyt3QROF9HcpVHBtfnScon046C8qGEXn5BYZ5HakkLoQmpDDU7EFtldB5w3tGYYSWif9qcByDSiYGEtkPAYrFzrk1yhHR1knbQnKwODVK8gNmkm9KQfJ1fQm4msIAKhRUbBiR4STgzbixQsQL1xjzh/+0i6m0cybS/1N2Z7lMHgzWDnXMXGpQPwneIB7vKsMKLwh7q6G06Q7KHnBiDvCsc9k0mY3cpsAudKX3TRxOs/qls78DZwS5nyRA0LEwKKyTG5+DwYXM+PMMXN8mqs4vOreyaP2TFVA8fVEhSMgvLeZmqs3kFnV7uSRWgEEQKODaU7zewSiOnAvWUgOmADXCu20ESV2+AiTNjxtB2sj8s1MOgj9eiMsS+gnXK8WNymRz/Fd1zObAkKqkf9ueSMI+xVnAo5qso/JfIQo+E7Koaz1/lBlMrimYSzFzjYq+L/NBu2CNsmEirBH1kPGc150IEfQNI4kf/YwML4YtShqgzmfEOgsqL2wM8gOIpLnhV8aMD3me3W1pTvQqd7440Qj1Tz07SQ7LzawBBR9Ou2BFHSEEa+aHBimqQ3sRyN2qm75tQtzoBeCR4y0uGAxpcPekE1MYUL8H88luvIJAkVh2JPfpwSECGqrfB1wF4fp7W/VWJcTk6o9qO8oTMGcp0iCG4keQHu9/EFraWS6SZ7l00MlZzPgDA2s1WTdV73SazlM9/rZE0VZV08TKqxhT0edXotOlcfOnP0QfdheMa00HfwWvsEQAPoZ1V36u1/PkPPeRSnS/PDmuPpwwa5QcjGtnPl
 y/9B1plX
 dw2rBpssE1C9r5oLAitHhO9C92QjKMVom8YbN9uwnZJ1nVJwRSsZ7g06gVdJSGHu701AIpBGVb++pokiSnrNnBwC21xL90eQ3/HG2dYjyXX3MY30dr40ceSizaPfkP9W3efb6QcCJrFYu31Xumki7hAfxnY5VHaoSuky9Ufrm/Z61I7r8Rj5uigH2OcYscmLpQlTJr9prlq3/Gu+laMsrGOMPwMMw4frENwSj451z3tJQXiWc96fHHsmWe63jnhLVth1TSNJ1EQksrw1ANTP8c9uSVN/6aFXYPufTs9lEwOI1gfu0iyQzUjeM6aM+SuLifsUdSKVzBYJTTvQeD6/EClLNyS/oPukVMli2rjtrOO/MefZ/J9rDMSDeq3s3NwlRVdT4bLUfTp9vZi0Ggn5quzrX/fLfUOISzl34E46qGKA+/PckVu3/QBGfDOc2+boR7ichgaITFClmwb3NUrRL0fZojuB93ddHZl79P4aIn5pJHxdA+c7r1jgtTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Resolve coding style warnings and errors flagged by checkpatch.pl script. Specifically:
- Add missing blank lines after variable declarations and replace spaces with tabs where needed.

No functional changes are introduced.

Signed-off-by: Christos Skarlos <christosskarlos.kernel@gmail.com>
---
 mm/mmap.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index 4bf26b0f1e6e..6016a43d3c37 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * mm/mmap.c
+ *mm/mmap.c
  *
  * Written by obz.
  *
@@ -526,9 +526,9 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			 * And don't attempt to combine with hugetlb for now.
 			 */
 			if (flags & (MAP_LOCKED | MAP_HUGETLB))
-			        return -EINVAL;
+				return -EINVAL;
 			if (vma_flags_can_grow(&vma_flags))
-			        return -EINVAL;
+				return -EINVAL;
 
 			/*
 			 * If the pages can be dropped, then it doesn't make
@@ -832,6 +832,7 @@ __get_unmapped_area(struct file *file, unsigned long addr, unsigned long len,
 				  = NULL;
 
 	unsigned long error = arch_mmap_check(addr, len, flags);
+
 	if (error)
 		return error;
 
@@ -1017,12 +1018,12 @@ struct vm_area_struct *find_extend_vma_locked(struct mm_struct *mm, unsigned lon
 
 #if defined(CONFIG_STACK_GROWSUP)
 
-#define vma_expand_up(vma,addr) expand_upwards(vma, addr)
+#define vma_expand_up(vma, addr) expand_upwards(vma, addr)
 #define vma_expand_down(vma, addr) (-EFAULT)
 
 #else
 
-#define vma_expand_up(vma,addr) (-EFAULT)
+#define vma_expand_up(vma, addr) (-EFAULT)
 #define vma_expand_down(vma, addr) expand_downwards(vma, addr)
 
 #endif
@@ -1454,6 +1455,7 @@ static vm_fault_t special_mapping_fault(struct vm_fault *vmf)
 
 	if (*pages) {
 		struct page *page = *pages;
+
 		get_page(page);
 		vmf->page = page;
 		return 0;
-- 
2.55.0


