Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB734CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 15:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CFFD6B00C5; Fri, 29 May 2026 11:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A81F6B00C6; Fri, 29 May 2026 11:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE086B00C8; Fri, 29 May 2026 11:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB8D6B00C5
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:22:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 038D18C3EC
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:52 +0000 (UTC)
X-FDA: 84820825026.23.EAB130F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id C517D1C0003
	for <linux-mm@kvack.org>; Fri, 29 May 2026 15:22:50 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ErqOQrWV;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780068170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VBSoYVls/goaUOaeb0ArVPkRixJg6uACMT8ZdsicbY4=;
	b=VvnDd7fBwrvo5Co2qnDn82LV/Dm+SGHeW8SjrM9EY/VmnGlGZEzjE8gwhyrG2LNxY+stdg
	P2NKP9IRgswDkVLjHdJN3dYlikAynpkEbEZfALuQjeauxliq4MnKKciF9Txlavt82K2ZpD
	MFcnt+B2+Cnwjwc5nKKIJAWJwtRVSjE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ErqOQrWV;
	spf=pass (imf20.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780068170; a=rsa-sha256;
	cv=none;
	b=e21sMe+/HfRk7hJUsLExPO3jIgDGaaxkzr+6DCW8GXp4ZRyWbNxJHmCEHWytEYKh3EpC3A
	G9/l49lAMHSzD9HP+VKv+vUnNFB0X/1H4YOVow/4+RQMSzRjr/0z8f9IXP6dumg+OjUHec
	pL5CBtU5+cXSN9jd7fHP6wgDhxh40Cc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780068170;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VBSoYVls/goaUOaeb0ArVPkRixJg6uACMT8ZdsicbY4=;
	b=ErqOQrWVLJzuVZwWYDc0q1rLvwdOrOxMrbMMDsuZVy+QMsW0NTjdQ1v+VkV09ffsuEUY3D
	6JqlWmVKzNK5cfUbM8lTtbetDIalQnVFkUoXqMuWdWYncClZGA5af73vuL10GPSP48X53g
	uhgcmVs+EbjbtzgWu6T1rqdLQmKFSKo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-5-OjD1bsRINH6StiC2S03ZVQ-1; Fri, 29 May 2026 11:22:48 -0400
X-MC-Unique: OjD1bsRINH6StiC2S03ZVQ-1
X-Mimecast-MFC-AGG-ID: OjD1bsRINH6StiC2S03ZVQ_1780068168
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490261c79fcso55613935e9.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 08:22:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780068167; x=1780672967;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VBSoYVls/goaUOaeb0ArVPkRixJg6uACMT8ZdsicbY4=;
        b=jKlHo6fNT3Y7xBZh++L919socnkHbHNWIkb07OjWQO5KtTVUPRlhjXRqDj3w3MsjC/
         VZ00BCsXpUAtap3j2VWgxXRcpV7T1LJT9+eON0lkdoSEsHHAm7CEHY9QwvkE8/ryS/WM
         KW7PffFo6VVbbQKEe7Zrddt3ujCgPjs/Digzte27gRkdmfPtQEngW8dZlirsmacmFX6J
         EYVAc9CYj1NVYmvN2EFEYTYJNCPSDMTKlrAqvRfkir37NW03kDBnS8wNnpNkK31kxfBc
         0lXoXXCbL1MT//qfjzuqujVdukg20YZyGk0hIKqzTq/R22fNnj3d6wrFgKGqTmKq9bdh
         FYpQ==
X-Forwarded-Encrypted: i=1; AFNElJ9a/g8/XRrkxwpjkxFLTAXA/Awg2SUmx/0nl4P+CEmClQzO8PV2m2WhGU2R9B6iiefF9Gqpk03XEw==@kvack.org
X-Gm-Message-State: AOJu0YxA6PTQFL/AnTUwumk+JS3Ck5QanbxGdZ66JGjibluhoKXV79dG
	shOLxt26LYhL2etSL/wLvlB1O0RGNOdCag3oeq6J6pYhl+ch8ifZRvDQxXCl0NpvunOqJdOtB5x
	Ou5NDMhuOEGlvQPnJWlCRs/3KJ/GeZOIlLZWgE12ODJczIS4eTnwM
X-Gm-Gg: Acq92OHz32qQPJ5TghsWFjyHNU9CXibK+cLSLHqMqZOBMfwKoFS0kZegtg2xIBhobfP
	CIdrG2tj4o7o0qSZfOoQi3l9nCebjdC3/RI/nt/9Ev/0TwaLTFI2cbk0GIFI5xbpr4IJVt+93iv
	PNIkPaRR5bzUK8/CLGZVuDsc0iy/4QKlBsrBlRmTaxC8as3/dizFu4c5XLS2rwrkLqtFU0Xxoy0
	48dkh+Ma3zBhyPcjB2OCl1/rERunjsYMYb/O76jMhxhnVcj9CLmCwTVf81I1SBG7eiB4qXMljOb
	qF/n42d+Ye+MT8HSHE51iXqjfc9ASsez844UN6bVQnPCZjUmO3omX2FUPnOPuaEmve3dablBDDR
	0z2lI3TTmbyKLOyz3pfsD8u8OVNuNjlmo1sVU2y3e8XyznZJsb0kNkw==
X-Received: by 2002:a05:600c:8207:b0:48f:e044:927d with SMTP id 5b1f17b1804b1-4909c62336fmr43494845e9.10.1780068167448;
        Fri, 29 May 2026 08:22:47 -0700 (PDT)
X-Received: by 2002:a05:600c:8207:b0:48f:e044:927d with SMTP id 5b1f17b1804b1-4909c62336fmr43494295e9.10.1780068166844;
        Fri, 29 May 2026 08:22:46 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-25-45.inter.net.il. [80.230.25.45])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909caa7faasm50679705e9.11.2026.05.29.08.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2026 08:22:46 -0700 (PDT)
Date: Fri, 29 May 2026 11:22:42 -0400
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: [PATCH v9 08/37] mm: add alloc_contig_frozen_pages_user for
 cache-friendly zeroing
Message-ID: <ce3658f2d412af44e3e678a901b7f411f49d13bd.1780067977.git.mst@redhat.com>
References: <cover.1780067977.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1780067977.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 6u0ym2vjCeJC9G2h7Txhm1nh58EombOnpkkT1om9IdQ_1780068168
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam12
X-Stat-Signature: 95a3h4kucax6jwhowpxcnj6asqy9soff
X-Rspam-User: 
X-Rspamd-Queue-Id: C517D1C0003
X-HE-Tag: 1780068170-459058
X-HE-Meta: U2FsdGVkX1/0eSWa1zYEqqJqnCL70vYcl7SjPGHiCmV62TxHOrFsAHv6XF60mLUtLCF3mHoiKu/ktKla/bg5sDC+yRCoI4XZcQ2NmJrWNmEYRBpfvFAhitXfsUtFJ3ghifk47P9xjBIwZ+Q+si5is5L0X3ca2KIjd/2rcWad8HEfsKQNhujxfweh7YDDBPUbZeExv8SEQ68jxoRMl4s89pHyqSytJeg7dtBJdekMEFNVdEzQOcgkJ8YonqFeOwxApBHbyYr+pvSEAgI9+CDIdSVmASv1hA3kBZj1rkQ9lok+NEf9S92qVEhhPjF3xa0dPDCxTs1A8jnBdznlEyqhgxIi9wDBc+Daj/eVkR1ElqdfDCvRJuVvQejrz1pcGOSAw0z9Lo6wjosqUvY/j8M9jPvdNXGbKc+/42sa0w3dTpCZ/si/OL67kY8XkxWXDQMkYWPBSjaSLtQXmyJWe6OIt2TxzvTmEn2N+qDZFHAOcrfiZz99mSaEOs5RkkGrHwxv2m9piN3cFL9UOZGGj2M4p4dfBLFgunkAVCtI13IhGFCfCTDzfYBPG+mj+uWuUfBD6AUnbec09n847HfmP0SbxB8Tr4FuQBkP0dlWPKRjnh9K2po7e4KHtekk9UTSaCzYufTVu5caNlMrNZojpcVJZBh3GkVjcusEfbSG5hKytSlVU1oC9fZJHRzuTrOdEAudDcBV5xTOify/bT8s9I/m4FOjEsNnvhkcayEY75x+gheZX9KLVqL+OIrr5/wF7HRxZm4XdL61y2SuXk8z56BU1PFB0uvhfoxhLyAkn5Pwzyewb+JOYDslAXXZKSu9aFf4tEo8zdgR2RudxM/vFqmRcB6yaJU0hMv5rtNwTIqS6o8Aw6XExme+rY95zR6KxjFVaJvWf4fzi+s62cRo5a17Lgo7FZotIapZRJuaGdEl+Byk/TNmJJnTRQCjVe5SYEOs6LhjEFxi1KTakCDwROS
 DJh7biyR
 uUOsOKmhwO8xzr5KRb1kl1KweAQHAwzW9F/phLVjC0cLWj0T+H0me7n6vUlpiI2cMZxOlxHLrdKKxfNOvQ303qs0wYKMFhUpTE064i6+su6RCPi7D/ZfGqQubhl1Gc25lBAVhnG2WaH4DFiw7Q1yKue+pQzd1BqCmBBYdtzEZNnXpzyqw77dV3t8aQi7tDxuORjRRV6Hr3EhPrJXHHYsdrBQAxZc5NMOGRzgOWzfj7AeojuQq7LyE/vdeyHvzRw9j05jqTlvKMjfkKdd2LLMxpSrk3tPNWVjntCnoV6oBEKJXw3b0T+SMsmPq/3zM4wYcfVty50YNhpVjl0aLtVgIVPLAC4VJrVNcBWiw3tzl+7b5kokBLqzoUyyOwyiItK8AdcTudMY3X7rlE+JW9vzesROD/k9LkJpGENIJn8NlWqDD9zhAIH6rk4TV+pi0cggoJkH/OaHsYNwLZAClngJJM6bYaiBmlDVvi0YWyTe7wz7Ic+0kheMPRYggBVoOgOK43aemhLqbxIDOTvv66IrZ93QX7wuKsld+6iFN2lFNF/T+xSYzeGZLR+xfZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a _user variant of alloc_contig_frozen_pages that accepts a user_addr
parameter for cache-friendly zeroing of contiguous allocations.

No functional change; all existing callers continue to pass
USER_ADDR_NONE.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/gfp.h |  6 ++++++
 mm/page_alloc.c     | 32 +++++++++++++++++++++++++-------
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index ee35c5367abc..73109d4e31a4 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -453,6 +453,12 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 #define alloc_contig_frozen_pages(...) \
 	alloc_hooks(alloc_contig_frozen_pages_noprof(__VA_ARGS__))
 
+struct page *alloc_contig_frozen_pages_user_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask,
+		unsigned long user_addr);
+#define alloc_contig_frozen_pages_user(...) \
+	alloc_hooks(alloc_contig_frozen_pages_user_noprof(__VA_ARGS__))
+
 struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
 		int nid, nodemask_t *nodemask);
 #define alloc_contig_pages(...)	\
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b96c9892f6c6..b725a3b59835 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6999,8 +6999,9 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
  *
  * Return: zero on success or negative error code.
  */
-int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
-		acr_flags_t alloc_flags, gfp_t gfp_mask)
+static int __alloc_contig_frozen_range(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask,
+		unsigned long user_addr)
 {
 	const unsigned int order = ilog2(end - start);
 	unsigned long outer_start, outer_end;
@@ -7127,7 +7128,7 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		struct page *head = pfn_to_page(start);
 
 		check_new_pages(head, order);
-		prep_new_page(head, order, gfp_mask, 0, USER_ADDR_NONE);
+		prep_new_page(head, order, gfp_mask, 0, user_addr);
 	} else {
 		ret = -EINVAL;
 		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
@@ -7137,6 +7138,13 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	undo_isolate_page_range(start, end);
 	return ret;
 }
+
+int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
+		acr_flags_t alloc_flags, gfp_t gfp_mask)
+{
+	return __alloc_contig_frozen_range(start, end, alloc_flags, gfp_mask,
+					   USER_ADDR_NONE);
+}
 EXPORT_SYMBOL(alloc_contig_frozen_range_noprof);
 
 /**
@@ -7255,8 +7263,9 @@ static bool zone_spans_last_pfn(const struct zone *zone,
  *
  * Return: pointer to contiguous frozen pages on success, or NULL if not successful.
  */
-struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
-		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+struct page *alloc_contig_frozen_pages_user_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask,
+		unsigned long user_addr)
 {
 	unsigned long ret, pfn, flags;
 	struct zonelist *zonelist;
@@ -7284,10 +7293,11 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 				 * win the race and cause allocation to fail.
 				 */
 				spin_unlock_irqrestore(&zone->lock, flags);
-				ret = alloc_contig_frozen_range_noprof(pfn,
+				ret = __alloc_contig_frozen_range(pfn,
 							pfn + nr_pages,
 							ACR_FLAGS_NONE,
-							gfp_mask);
+							gfp_mask,
+							user_addr);
 				if (!ret)
 					return pfn_to_page(pfn);
 				spin_lock_irqsave(&zone->lock, flags);
@@ -7309,6 +7319,14 @@ struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
 	}
 	return NULL;
 }
+EXPORT_SYMBOL(alloc_contig_frozen_pages_user_noprof);
+
+struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
+		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
+{
+	return alloc_contig_frozen_pages_user_noprof(nr_pages, gfp_mask, nid,
+						     nodemask, USER_ADDR_NONE);
+}
 EXPORT_SYMBOL(alloc_contig_frozen_pages_noprof);
 
 /**
-- 
MST


