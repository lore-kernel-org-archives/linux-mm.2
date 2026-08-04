Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16062C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE7A6B00B2; Mon,  3 Aug 2026 23:56:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281A86B00B4; Mon,  3 Aug 2026 23:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 197296B00B5; Mon,  3 Aug 2026 23:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E077A6B00B2
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 855411C1433
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:48 +0000 (UTC)
X-FDA: 85062225696.18.1F61281
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id BF12F140003
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HbFubiPG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xv+zhz7QIxLw7sIiewiDXoEbk5KnAZjoH00yp8HlINA=;
	b=xHq/aUhFhZzFe7rUlF8n6MDSRJjDG4DCd5r6EUOqQTbDoJvBPFYmKERYBysMDjjkF8Owni
	1z58id/Q+xy0Q2maG4Ia381ioWwmULcTchZEx4J9KB7dG479RM8e+W8n1J64HectNCu7Z+
	/Gmy5Ruf2uzakHS3u3NXnwYHhSelCsg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HbFubiPG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815806;
	b=3ijIu6RXgf3Nh7zQ2VjlHPAigjeFEw7DlkYCwkiSkckmbBjfo9TICEOkWVkEYrTdI1P0Sb
	W1DLSFnJ6Gyz7VGSW0jD7Ixwf15y4Ao1R6oozpDGPi5IfkkV8rnQN1Ha6wPTlC9p8xPc1F
	hbm6srSI3MzuodGIFE1npJGAak3PePE=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2caed617615so56033715ad.3
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815806; x=1786420606; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xv+zhz7QIxLw7sIiewiDXoEbk5KnAZjoH00yp8HlINA=;
        b=HbFubiPGEmlSJO94Uhugw7OV2kULn2EZi0Jj3wG6KUCPrYwZYmivb2xRqKeAW0Ojks
         09Ul4BGj27a6bnW4bywQ1GKMbcSlzLRVipm8TxhqDpzf6EldROdc1IkKuihhHb3w9aQg
         WQPkoGGqu6gboQqaOLBRqqLLK6JSM48ZzveXg509rdVJ5mVk/4Hn8CCAviIKgKO3Yt1o
         tA1ONifd78DhPkQDI1dFd96I8K+4LGD/92MXmkOdaaR/MMxFToh5ifoMmXNC8EZXmeZw
         ps+ky+kHhStvIECkRfZg7IX9ipVJY7Qp0um9EL3Wfwm2RJA8naADe6oU+k8y3wwwzqBy
         DqZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815806; x=1786420606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=xv+zhz7QIxLw7sIiewiDXoEbk5KnAZjoH00yp8HlINA=;
        b=VXZtVJlyqZpJhu2GqZ8SeLMF2XcGwqwc3Xnxo8zyZDwUB1Qn766hVFqR1rKFRKsaT1
         7Ut5a2ESTnLEVJ5tGphaqpLdOVCYS2MiObe5QZxuVLVe15iQDU7mjM5vrkrPievc8vTy
         G/9G8YB0LtqyaIQThN4na4Q1ohMiNOXZq2xmVgT9PQ7xt7lYHzNrL1s9LYJxcgAb/ywR
         7Lhhb/o9+KlL1HlnL4D+h82GrQgV4kVrfiRqaws53SDZy3HCZ86EQP1y26KJtY5SxPD9
         albI7bKX7x3x59hyMqtzk2V84MWaDVclEkv6IHNiFnoNiIETK4Dh/c+CUZ/xqRcIJqpn
         Gm3Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp9q4qgcsPV6Km5fpNrvYavcReMw87yhU8kjGONl1s6RfO1llRPo5YOr39/b010Nuhtvm1p3r5Dtg==@kvack.org
X-Gm-Message-State: AOJu0YzswoPhGPCsf/XArAfGkI93X3Wr++X6XEhDiGnemQW577OjxD2M
	+IeDnC2bozxvdm5UxiVpdfIBCpzwJuFSfs3wgFeoPB9qltEIvbOg9RXgP+2mzx6QwSE=
X-Gm-Gg: AR+sD12WIrMi8ijG5ecX188RljQV10xFtUmRUGjpFX8hlHtHGr6unG5kM8qjEHab/XS
	YLrYT+jOyTbMak5dzx+VKM+UyIK1/EIvETA2H2NWnAooJ5nFPcPQYduDgeykYk8jqDud7nUcUDa
	bRolUK/NVNvjCuxyy2pRXGOYX6BZeLi0SZjUSY5hnB3Eh7ZTFj66ry0k0N6DNcQXBQAvhddaU4/
	PNiCdQ2BiGmi/95I0OBETYBGT4OlxUzCClp+Avc+s9aSWrdkgl2QO2vi6PZU/TnZ2QFqpxglMzJ
	DJSXEUd/QbbTZBBS2G21c3lpP+ONFnKkucnz/yYVJw16P8EyQl/CbDKCvW+bDaI5dGgZbOd14ap
	MQ9zRyrqq7jCuMEXAU7MZB9mxyNwenXLK+MtYJVVJ3urnhAY4YgyOP5pOydqLML1dmzxt7a0e4k
	thmZdvE8A+6xCXZijRpMiZxLt9Whg9+v8tEs1WltNwXayFpWdb4TM5wFW/uOPSj1SV9iM1RZIlS
	c9Grhlu
X-Received: by 2002:a17:902:e543:b0:2ca:329:3da1 with SMTP id d9443c01a7336-2d052215bb2mr125290605ad.16.1785815805645;
        Mon, 03 Aug 2026 20:56:45 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:45 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 14/17] mm/hugetlb: remove HUGE_BOOTMEM_HVO
Date: Tue,  4 Aug 2026 11:55:32 +0800
Message-ID: <20260804035535.2846016-15-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qddmnqsqxf1pju4hfi4u96pekgrs8s5r
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BF12F140003
X-Rspam-User: 
X-HE-Tag: 1785815806-222913
X-HE-Meta: U2FsdGVkX19tN8qj4GCWZjvbi3TAA2V9+mbJpWhwHzBN7pXv+G2cuwCK2xWpCaGOC8Y6lY4hgEaOUxscTAbcsx2+HqNbl3qK8GUJFViwjgp9qUKf9eJZ2DZfzU8cthHsOy6VweGlh7hLekX0NRVngmhfI1HJW5+BNJjJ5UJMHhGxrtSqEAYahEyPocgKDSS1hmVko7JAWjhdvlc1+8zgL5pKXeKjNsBrSb3eiiMby+/ZpTB2i3/P3prvS30UmYbvIbhKFVIgkeNdZ4f+2bj7s5eUNLPE4tyLYK38CZPY9z5g2KbzMSMEAbLTxxV3B0ATVRoV0S/oQrtn3t1tJuPQY2JuoWvmE23ueuqMpspyv9C30Gw+HexA7WPUzRmc4rBIh8YKsyj+asM3eDRWPg/6fX8V96RcIt/wnCxOJouUr/kB2C8NhfwlUxOA+egiYx89dQMJUTHDx27y4KRW98By3h0DKV1KCHX563SucDtTTeKrrDvw3sCz7CK79Jin36DAvNDFY3TATMKfyQQ0rwd7721bQ2Mluz9MstXzhPcTmVkRLQWMniZyn73Vg/We86XZ3DDxlopzfXOvZ8M8wc/OjoXcMxKsDBPfC9luTHlcNKM3TwkKbUw1OwKSY83dQXoVrBIj0PlaJzY/BZMQjuohFqujBFbrKMWep6ImEUHFtY9LTv70lDKO5JgV42etegODO3+jX+X/Ax8nW93WhXvUkO0tFT2rJTUHv7fY2A2iH66pav9zwjO7gGJAQ1gh/Fuh1tBQ/0T5uXuMLbY+TLlohlpQxYf46YzoS8OcMBireeejMvH4KiA1HpEKoFTms7fTL3+R4Xz6IwWTuYnn5fVFsIpXSArr6xusBs0KJmEMniNyORWV+u5eOk1RYyHipp078B5kU+m8oNo4xrPF6EwQiITGDCsUPD2oPSaa2EuWF3d5jYvpXuBBo5RWpjDvHJOhshkscXurNEuk3XOWmzR
 2/Q46/Oj
 F7Cw+ybp2FcqrvrRs/vvq0TWkkMrx9JleMfHI4sTC5ncKikKek9GPrGcAXj/N420TU7ulF7YMhg/lmJBmvfjOW8+pauOqvPZbQc0KCzgUg5gBsp4KOHITgBx07qw8IGDZ6nL76wiIqBPtvEL+U8RWHKQZLpxwmKLctPQVIFLFrOm/kNoNpH1QzOgbyJq8Nq9PplF0N1+gnDl1O9xLaeZiQNhG1RIwFKjxppLYg5tZmC18Ev0Mc+8qm1Zc6QTm8aW1IAbq1rgZsOn9VHsukLDaK0/Ua/qYCgMvaKEHHaBQVMPCKmFW1venXOe6uvshVM0SRFy8uiY2Ub6zHmGmC/rrUWLRYb7d6Mekkxa7bSN9VzYAlBVMFxTo//8HqrNHP5hrMQFjWBrdgLCosGlVC29UK6+l4Och02nCKeXN6joJCAGz8+Py0ayDX4JFo4OJxZMkY2DRvZSnyadju+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HUGE_BOOTMEM_HVO flag tracked whether a bootmem huge page had
already gone through the old early vmemmap optimization path.

Now that HugeTLB uses section-based vmemmap optimization, that state is
already reflected in the section order.

Remove HUGE_BOOTMEM_HVO and its helper, and use the section state
directly when deciding whether to mark a folio as vmemmap-optimized.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Use the order-based helper for the bootmem vmemmap-optimized check

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h |  5 ++---
 mm/hugetlb.c            | 12 +-----------
 mm/hugetlb_vmemmap.c    |  2 --
 3 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fe28f98e1b22..3559041a5a57 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,9 +675,8 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_HVO		0x0001
-#define HUGE_BOOTMEM_ZONES_VALID	0x0002
-#define HUGE_BOOTMEM_CMA		0x0004
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+#define HUGE_BOOTMEM_CMA		BIT(1)
 
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7d8507aa4c5b..7e2f186fa224 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3196,11 +3196,6 @@ static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
 	prep_compound_head(&folio->page, huge_page_order(h));
 }
 
-static bool __init hugetlb_bootmem_page_prehvo(struct huge_bootmem_page *m)
-{
-	return m->flags & HUGE_BOOTMEM_HVO;
-}
-
 static bool __init hugetlb_bootmem_page_earlycma(struct huge_bootmem_page *m)
 {
 	return m->flags & HUGE_BOOTMEM_CMA;
@@ -3292,12 +3287,7 @@ static void __init gather_bootmem_prealloc_node(unsigned long nid)
 					   HUGETLB_VMEMMAP_RESERVE_PAGES);
 		init_new_hugetlb_folio(folio);
 
-		if (hugetlb_bootmem_page_prehvo(m))
-			/*
-			 * If pre-HVO was done, just set the
-			 * flag, the HVO code will then skip
-			 * this folio.
-			 */
+		if (vmemmap_optimizable_order(pfn_to_section_order(folio_pfn(folio))))
 			folio_set_hugetlb_vmemmap_optimized(folio);
 		section_set_order_range(folio_pfn(folio), folio_nr_pages(folio), 0);
 
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 7293706b532f..a25adc474351 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -714,8 +714,6 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(struct huge_bootmem_page *m)
 		return;
 
 	section_set_order_range(pfn, pages_per_huge_page(h), huge_page_order(h));
-	if (vmemmap_optimizable_order(pfn_to_section_order(pfn)))
-		m->flags |= HUGE_BOOTMEM_HVO;
 }
 
 static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
-- 
2.54.0


