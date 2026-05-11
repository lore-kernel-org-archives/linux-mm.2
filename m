Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B833CD37B5
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:54:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4D636B00B8; Mon, 11 May 2026 04:54:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E24736B00BA; Mon, 11 May 2026 04:54:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B446B00BB; Mon, 11 May 2026 04:54:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C34376B00B8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:54:40 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B2FF1C0519
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:40 +0000 (UTC)
X-FDA: 84754528320.13.AFBF36C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5DC60140009
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HJ2Rpu6r;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778489678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
	b=kf4B75qHlWIanag3O/69+yZC9qqPgbtXPfIY9CykFStYgwCbVSkgYlZ1WFrKMc51X01cmY
	QxD7snS1LZNouwcF60woWgeM8t6NqstAXslQnZGsgGYm61xBY0DRO3ynsMtMuxX8EKdsXC
	q2G/qXaCKa8J7GzjyVGI1zktBdKGbNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778489678; a=rsa-sha256;
	cv=none;
	b=LbfRyv1yxoMJovs2m1n11TMPWd4XrGf7ohLdVMHsFH9TjkCcZCJyFnQ6PnxKbPgYkrxuc2
	FjL1wfZcGOkXW1NX1KXLi1C148OoYOUJoRDZXmgBvCXf6B4gi6BgMeVR4Ybozz5lY4Ja8o
	B8kVckYeTOfWuAM2KHL83W3uHqKgNv4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HJ2Rpu6r;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf23.hostedemail.com: domain of mst@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mst@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778489677;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
	b=HJ2Rpu6r3kQhgSyeDV3SZmRWyT1J5WKixLm7jMVj0p9FnhAnM/jQ65WNRcNyBJGDPFGzNo
	VjEsLtBptcW9lGpEqnYoGTJMKkMDSgUw6uTRn6a/NBBWQn4cZurR7iGDFoT/QGSfZEO3r4
	bNboCooHnQxfmA6l7idqaJvL2wABvTA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-527-wFDY7OJVO92U2aTnO_zl3g-1; Mon, 11 May 2026 04:54:36 -0400
X-MC-Unique: wFDY7OJVO92U2aTnO_zl3g-1
X-Mimecast-MFC-AGG-ID: wFDY7OJVO92U2aTnO_zl3g_1778489675
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4518f777225so2679752f8f.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:54:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778489675; x=1779094475;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSkauV/IjsYyN3rKw556EWRQycHO+B2Bstj+Uf0KUNg=;
        b=gNEdklQQX4hHEaYiRYT3vhTW3XWKCsyu/L9Fki4AEqo3wB81ULTws2mu5GkGo0yUHI
         Av7gWNYqHhONdlZzAGRNID4lGWdkSSIZgAyVxKNlbMYWq/HtnS0d8glI9lAENDn+vWfb
         nySElyH+uwv24xMtKuy6wjCo9cOZwzwZ4CbJGrlWobecdcFAV5Lk3Jwz4HHq+dsm8Wm2
         Ej5R+mnqxwmny8gqEdIvqsGBV0MgTF3rUEEyTM4umQJ+cjLlCDcQQoLWszzN1pFm+1u7
         GyqpfxGnN2ESzaYYfytpMhGl5igJ1CW8YhvIhI0DjYgopEHqNlgD8a1dEaJH1R7a59f2
         lz6Q==
X-Forwarded-Encrypted: i=1; AFNElJ8oSIfk1yD6tUCa5N7ZY8vFIuMFWd9h8ekPo8BTLP/ZPnc72pJTTSKxROHP5Hff2WHy6XSqp6uYPQ==@kvack.org
X-Gm-Message-State: AOJu0YxomFdpOBhipDAwZ8ExfXbgjiqRor6snqWrD8BMw4IBfcS5aqWE
	PnaMNVdANbCfTRMKH0j3sOPcIZWhfGSwN3zmDmtDBSPLmqeeDwSRz0adjkEJjVaBFU5mpX2UqHW
	eQxfiRbxhiSIh62Hu9YFvhWB2INxjTp3S45ErUPWpbrgaswPvu0zQ
X-Gm-Gg: Acq92OG8BOeDUaNyW3+jPuPFJyY3FvfVf8dMNfFj420Vnuqgfb48GlmkKQAptHJObqb
	ENaTMYvOYwKBk2GzB4wKGYvI7ieH9kaRIydqXgrc5edZPddbjSUrahNHr1ef2LQ+TFje90Bn4jX
	NvoPwZ7/7HfyZbymQvcpUJQAr7If4ASvy4yrMhnNzJAQ2MFZaqNdq0BZslbmIIN6HjSlzW5Jkyj
	HUQRwtgrOMqdB2Cd65db3Rl5TdYRG9PFRW3NlAFeO+c/su6UaxBTNuIUsLy70YZNBSEfgdkbWrh
	hUw9cd4h7BSj1cGTZJ+DcMQFoCmnZ1sjWoCpE4YOK+PNyGjB0OwDJkv5p1sE/ynrvsoHtFJw+4P
	6RfZusabZjblTbdpx4MPLGFSoG7RmLeFp+tXBNVNH
X-Received: by 2002:a05:6000:3107:b0:44a:2cb3:b633 with SMTP id ffacd0b85a97d-4515b5240dbmr36610571f8f.12.1778489674907;
        Mon, 11 May 2026 01:54:34 -0700 (PDT)
X-Received: by 2002:a05:6000:3107:b0:44a:2cb3:b633 with SMTP id ffacd0b85a97d-4515b5240dbmr36610456f8f.12.1778489673788;
        Mon, 11 May 2026 01:54:33 -0700 (PDT)
Received: from redhat.com (IGLD-80-230-48-7.inter.net.il. [80.230.48.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45491ca2fd6sm24946277f8f.30.2026.05.11.01.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 01:54:33 -0700 (PDT)
Date: Mon, 11 May 2026 04:54:28 -0400
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
Subject: [PATCH v6 14/30] mm: hugetlb: use __GFP_ZERO and skip zeroing for
 zeroed pages
Message-ID: <fe1d24d4deafe0f5d1a9c51fcc040d9561c8592a.1778488966.git.mst@redhat.com>
References: <cover.1778488966.git.mst@redhat.com>
MIME-Version: 1.0
In-Reply-To: <cover.1778488966.git.mst@redhat.com>
X-Mailer: git-send-email 2.27.0.106.g8ac3dc51b1
X-Mutt-Fcc: =sent
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: NjDoKRW24J3wKisX8Nk8H2eB_r2Up4nn2TjE9SCJZuA_1778489675
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Queue-Id: 5DC60140009
X-Rspamd-Server: rspam04
X-Stat-Signature: afqr4j44ne6mcqew1wqiz8ugtrzeubmg
X-HE-Tag: 1778489678-414575
X-HE-Meta: U2FsdGVkX1+zPoTClHufOyPs+oVCzUPR+00FCvgFlhIMbZrTePoq+sSCTFMR+T4Rf/mArTFaMYBUaSvz2YgN1f4DX004xKxbOV7KejwY34mWO1s+1DFha2WGVX1c14zRyflvextd+oW9QgFGCp/DKqh8Gd5Azbsw+jFj2vS6w4EJjy8kyzo+mZyESS35zH8C+QrWqpxkdnSawCOITRHGY6Wr+iHMmQ5EvBO8Bd/ANpJxK1kfh8Y+NiqE2MMYxSDhbziBU1gH3utzt4O/cHLLsuB/3zIAegX7xAlvY+iZ9IAcUNLrJZ72Q/gixrkrfc5d7lVuJzf/vvj7rP8m2i62BMylwouIVuLEUco+X8bzVvkzY9GZNAo6qeGyAZO/afNJ2LWScLurPcLQpLugpZKoFM0za5RoGI7KBdttTgYrrLi0HR9889VwsMv8/AeHKCJ9UlvReSPzLtKBoA2mWSIwD/1YFwI6ZMEqLVFr/Vc6yMS9OZRDzNio5DLUKlq9CcBh875JiHmc4bWdbZPv09soxRhx2QnvgixoOY3Nxu2BsVWQ8BMOS8f8NMrk+LtLAk3G5y1jzCGkJlRNNj1QyMl/pnO/bMagKVwjz8FdW43dqsG09D380ZKXuox//IORpfCtdNVG+c2knv9kwBHfRQsJok4JVSCpzccMz6J4NzcoSC/Ha2R3XoiLB5Vo52CVj0SnDSO4Ghezi1kydkFgJUh8Vnrp1UluNcFpQ2HiSyxfi8YNmoONFo0ESAdjxmOSe8MttwLcMLMdQY7lXsXgRxKmPxr7VvOBb6tgfT6+qpvro40dieK5ZKtBwQ1OfgFql2rUxjd/lAHo65r8SbRhEQNLWE7XEHvVGGTYnkbzfHys8Y+bf0pLyKFKFRZA04WCuMA3rp48zgR7TK/rfCXFJf8SdnOPjvTsSNUFDLGi9aD6nP4q174UPv6/HoOo8pD3UYkCcqcWs0Qt15Uvcx5HZ2R
 kqhOORGY
 WZvwovvCDEFrTsXcGPbTwUu/5XYvgZ+GiYJIRRxXEpA7ryI9njGCUt3idRWeNhjpJ+vqSPz0H4XEkVlc1C/mtzF6ach9CfdH9oV+ACZSRAixZtEZCdDS1NXgEBYTo0ajkmkeld8poLOUEVwHIut8Qq2h3pmYXw/zqAGg9hEvHsVJKr1aRpG8Eq8GMoeENsrdyInhEqDNbZCDKomg9Q7ZOwKwmAAkgwH4yMo8VLFLSPTydNzSRafpQbYShGrNBez3Zi6B1RfDE95KWE92GIa+4Kh7Re42obZ+x3MXmiA2Elih7W4nYNsTNBsiUjVDtaZVzxGOMNoL9++S6XOWjpYVIxX0ihqzsfcMoTDgv6xBHmQXXclPNzx+GFpZHquQ206KPOB+jcCDCyMum/ws8AxhJveaEATZ7v8dkzC/q/nAEgeFcPJtmjdRfFzHGVDijVzxUnoAH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the hugetlb fault and fallocate paths to use __GFP_ZERO.
For pages allocated from the buddy allocator, post_alloc_hook()
handles zeroing.

Hugetlb surplus pages need special handling because they can be
pre-allocated into the pool during mmap (by hugetlb_acct_memory)
before any page fault.  Pool pages are kept around and may need
zeroing long after buddy allocation, so a buddy-level zeroed
hint (consumed at allocation time) cannot track their state.

Add a bool *zeroed output parameter to alloc_hugetlb_folio()
so callers know whether the page needs zeroing.  Buddy-allocated
pages are always zeroed (zeroed by post_alloc_hook).  Pool
pages use a new HPG_zeroed flag to track whether the page is
known-zero (freshly buddy-allocated, never mapped to userspace).
The flag is set in alloc_surplus_hugetlb_folio() after buddy
allocation and cleared in free_huge_folio() when a user-mapped
page returns to the pool.

Callers that do not need zeroing (CoW, migration) pass NULL for
zeroed and 0 for gfp.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Assisted-by: Claude:claude-opus-4-6
Assisted-by: cursor-agent:GPT-5.4-xhigh
---
 fs/hugetlbfs/inode.c    | 10 ++++++--
 include/linux/hugetlb.h |  8 +++++--
 mm/hugetlb.c            | 52 ++++++++++++++++++++++++++++++-----------
 3 files changed, 53 insertions(+), 17 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 8b05bec08e04..24e42cb10ade 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -810,14 +810,20 @@ static long hugetlbfs_fallocate(struct file *file, int mode, loff_t offset,
 		 * folios in these areas, we need to consume the reserves
 		 * to keep reservation accounting consistent.
 		 */
-		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false);
+		{
+		bool zeroed;
+
+		folio = alloc_hugetlb_folio(&pseudo_vma, addr, false,
+					   __GFP_ZERO, &zeroed);
 		if (IS_ERR(folio)) {
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 			error = PTR_ERR(folio);
 			goto out;
 		}
-		folio_zero_user(folio, addr);
+		if (!zeroed)
+			folio_zero_user(folio, addr);
 		__folio_mark_uptodate(folio);
+		}
 		error = hugetlb_add_to_page_cache(folio, mapping, index);
 		if (unlikely(error)) {
 			restore_reserve_on_error(h, &pseudo_vma, addr, folio);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 93418625d3c5..950e1702fbd8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -599,6 +599,7 @@ enum hugetlb_page_flags {
 	HPG_vmemmap_optimized,
 	HPG_raw_hwp_unreliable,
 	HPG_cma,
+	HPG_zeroed,
 	__NR_HPAGEFLAGS,
 };
 
@@ -659,6 +660,7 @@ HPAGEFLAG(Freed, freed)
 HPAGEFLAG(VmemmapOptimized, vmemmap_optimized)
 HPAGEFLAG(RawHwpUnreliable, raw_hwp_unreliable)
 HPAGEFLAG(Cma, cma)
+HPAGEFLAG(Zeroed, zeroed)
 
 #ifdef CONFIG_HUGETLB_PAGE
 
@@ -706,7 +708,8 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				unsigned long addr, bool cow_from_owner);
+				unsigned long addr, bool cow_from_owner,
+				gfp_t gfp, bool *zeroed);
 struct folio *alloc_hugetlb_folio_nodemask(struct hstate *h, int preferred_nid,
 				nodemask_t *nmask, gfp_t gfp_mask,
 				bool allow_alloc_fallback);
@@ -1131,7 +1134,8 @@ static inline void wait_for_freed_hugetlb_folios(void)
 
 static inline struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 					   unsigned long addr,
-					   bool cow_from_owner)
+					   bool cow_from_owner,
+					   gfp_t gfp, bool *zeroed)
 {
 	return NULL;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a999f3ead852..8710366d14b7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1708,6 +1708,9 @@ void free_huge_folio(struct folio *folio)
 	int nid = folio_nid(folio);
 	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
 	bool restore_reserve;
+
+	/* Page was mapped to userspace; no longer known-zero */
+	folio_clear_hugetlb_zeroed(folio);
 	unsigned long flags;
 
 	VM_BUG_ON_FOLIO(folio_ref_count(folio), folio);
@@ -2110,6 +2113,10 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (!folio)
 		return NULL;
 
+	/* Mark as known-zero only if __GFP_ZERO was requested */
+	if (gfp_mask & __GFP_ZERO)
+		folio_set_hugetlb_zeroed(folio);
+
 	spin_lock_irq(&hugetlb_lock);
 	/*
 	 * nr_huge_pages needs to be adjusted within the same lock cycle
@@ -2173,11 +2180,11 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
  */
 static
 struct folio *alloc_buddy_hugetlb_folio_with_mpol(struct hstate *h,
-		struct vm_area_struct *vma, unsigned long addr)
+		struct vm_area_struct *vma, unsigned long addr, gfp_t gfp)
 {
 	struct folio *folio = NULL;
 	struct mempolicy *mpol;
-	gfp_t gfp_mask = htlb_alloc_mask(h);
+	gfp_t gfp_mask = htlb_alloc_mask(h) | gfp;
 	int nid;
 	nodemask_t *nodemask;
 
@@ -2874,7 +2881,8 @@ typedef enum {
  * When it's set, the allocation will bypass all vma level reservations.
  */
 struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
-				    unsigned long addr, bool cow_from_owner)
+				    unsigned long addr, bool cow_from_owner,
+				    gfp_t gfp, bool *zeroed)
 {
 	struct hugepage_subpool *spool = subpool_vma(vma);
 	struct hstate *h = hstate_vma(vma);
@@ -2883,7 +2891,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	map_chg_state map_chg;
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
-	gfp_t gfp = htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
+	bool from_pool;
+
+	gfp |= htlb_alloc_mask(h) | __GFP_RETRY_MAYFAIL;
 
 	idx = hstate_index(h);
 
@@ -2951,13 +2961,15 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	folio = dequeue_hugetlb_folio_vma(h, vma, addr, gbl_chg);
 	if (!folio) {
 		spin_unlock_irq(&hugetlb_lock);
-		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr);
+		folio = alloc_buddy_hugetlb_folio_with_mpol(h, vma, addr, gfp);
 		if (!folio)
 			goto out_uncharge_cgroup;
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
-		/* Fall through */
+		from_pool = false;
+	} else {
+		from_pool = true;
 	}
 
 	/*
@@ -2980,6 +2992,14 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_unlock_irq(&hugetlb_lock);
 
+	if (zeroed) {
+		if (from_pool)
+			*zeroed = folio_test_hugetlb_zeroed(folio);
+		else
+			*zeroed = true; /* buddy-allocated, zeroed by post_alloc_hook */
+		folio_clear_hugetlb_zeroed(folio);
+	}
+
 	hugetlb_set_folio_subpool(folio, spool);
 
 	if (map_chg != MAP_CHG_ENFORCED) {
@@ -4988,7 +5008,7 @@ int copy_hugetlb_page_range(struct mm_struct *dst, struct mm_struct *src,
 				spin_unlock(src_ptl);
 				spin_unlock(dst_ptl);
 				/* Do not use reserve as it's private owned */
-				new_folio = alloc_hugetlb_folio(dst_vma, addr, false);
+				new_folio = alloc_hugetlb_folio(dst_vma, addr, false, 0, NULL);
 				if (IS_ERR(new_folio)) {
 					folio_put(pte_folio);
 					ret = PTR_ERR(new_folio);
@@ -5517,7 +5537,7 @@ static vm_fault_t hugetlb_wp(struct vm_fault *vmf)
 	 * be acquired again before returning to the caller, as expected.
 	 */
 	spin_unlock(vmf->ptl);
-	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner);
+	new_folio = alloc_hugetlb_folio(vma, vmf->address, cow_from_owner, 0, NULL);
 
 	if (IS_ERR(new_folio)) {
 		/*
@@ -5711,7 +5731,7 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 			struct vm_fault *vmf)
 {
 	u32 hash = hugetlb_fault_mutex_hash(mapping, vmf->pgoff);
-	bool new_folio, new_anon_folio = false;
+	bool new_folio, new_anon_folio = false, zeroed;
 	struct vm_area_struct *vma = vmf->vma;
 	struct mm_struct *mm = vma->vm_mm;
 	struct hstate *h = hstate_vma(vma);
@@ -5777,7 +5797,8 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				goto out;
 		}
 
-		folio = alloc_hugetlb_folio(vma, vmf->address, false);
+		folio = alloc_hugetlb_folio(vma, vmf->address, false,
+					   __GFP_ZERO, &zeroed);
 		if (IS_ERR(folio)) {
 			/*
 			 * Returning error will result in faulting task being
@@ -5797,7 +5818,12 @@ static vm_fault_t hugetlb_no_page(struct address_space *mapping,
 				ret = 0;
 			goto out;
 		}
-		folio_zero_user(folio, vmf->real_address);
+		/*
+		 * Buddy-allocated pages are zeroed in post_alloc_hook().
+		 * Pool pages bypass the allocator, zero them here.
+		 */
+		if (!zeroed)
+			folio_zero_user(folio, vmf->real_address);
 		__folio_mark_uptodate(folio);
 		new_folio = true;
 
@@ -6236,7 +6262,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0, NULL);
 		if (IS_ERR(folio)) {
 			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
 			if (actual_pte) {
@@ -6283,7 +6309,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
 			goto out;
 		}
 
-		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
+		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false, 0, NULL);
 		if (IS_ERR(folio)) {
 			folio_put(*foliop);
 			ret = -ENOMEM;
-- 
MST


