Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04700606A330
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=XdtcMi4m
Received: by kanga.kvack.org (Postfix)
	id 71BBC6B05B5; Tue,  3 Nov 2026 21:36:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC446B05B6; Tue,  3 Nov 2026 21:36:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E30F6B05B7; Tue,  3 Nov 2026 21:36:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26A0B6B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:00 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 79B3E160619
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:59 +0000 (UTC)
X-FDA: 85395871638.11.678E540
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3461E40005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:35:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XdtcMi4m;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6UIfKs58bx4eAIKKxFi5xP86AHmAWfy+F6/2hzKqz4=;
	b=IJja2nGVdCNiqnPKU5nIa2OKxT+Vv5otVlxLVcLZ0Fvdldllietayq1ZIkMmOtEvisvBdk
	zywioOOyHv/8mh9LQCzA3zZr232lgUdHJRicjNyb5ZgWiv/vQ1OoNCZ/DpJWczHIh5QJNU
	FqyQCgJaNPfwFswEt4/LUgqlhAWZXMM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759757;
	b=k62AmW571hp0FoUEKpVj8ryv3yv289KiaASW6OXNuYE+GTGUG6WGZ5LgRCE98S5ARL3sXG
	NnWaWh9X07ijqjUTLDpJEPVmW1KrIWGKgxYzyUgahb/MEVRLQC7XAZmDURw1LKwl+rUFML
	CTPPsITSZawM6kcY4iSO6p2IRH01Nx4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=XdtcMi4m;
	spf=pass (imf01.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-8a05f2d5cd3so113377b3a.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:35:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759756; x=1794364556; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B6UIfKs58bx4eAIKKxFi5xP86AHmAWfy+F6/2hzKqz4=;
        b=XdtcMi4m7+X1W4Id4Ak1/iM+NMwUa8Tt6XeJ9h7/axINA4DEmGBdLNtsRwREzjCuDI
         zaja8tvZ6RH3pnLzNw6DOj1yq624lcPBajoKj9Ccu9u1t2kQF+BQBESubWha4yaT5Xtj
         c9rIZZA6ee6zukcpXRQYyTw1l4QUHN+5dojANvlsE433L1XRHS1cR9IRhpfGg6Q3q5LD
         ZSljwP0bb6W+w7YUP5X0p6sbxli/CDzR3Slgklyn4ay4Oe2jMV/0E/Mak/AJ/SLEksAn
         Kg7pmTU/wgG+fAplJ2dkSfAxfdh8rZGakzxp/ROesHDjbJlym/OtejB8sBnpYCwB/FCk
         qiFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759756; x=1794364556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B6UIfKs58bx4eAIKKxFi5xP86AHmAWfy+F6/2hzKqz4=;
        b=uLvJjnZHbk2Jc/hbnWVv8lPy/T4TB2281pChoxqruWRSIS3hTnxF/32nneqw9sFuS5
         FykIW2SKWZhGtZh2yUnBN8Oep7gyzH98ENlAOXJV48yG2AxxH05PjiIqKnUZ+rg80a8Y
         3yX5NhYEohNkGoykXXktsTNVkC9rB9NJb4jjG0cpDqk5YDf27P2hzVM5Kwu8WlhJIxRN
         T4XgUNemVArLb0hPQILM9NUEyzFN0XGJrQPJbWMMa+V8WYEzeXgXo39Z8OBRGe7GDAUs
         dB26lzW9ckqhpl4d2F5BHMUPspwYylND5rkX1f2u+N2XF3D0tK1gehEMKVkBmj0MdNuK
         qsEA==
X-Forwarded-Encrypted: i=1; AKwUvByIM/aOlw+3JgTGFk/Tq9BTyij52KsZSgndJ08RRbK5iaCyCy0k8nQvjNaAVWULxD3YvFma1u47qw==@kvack.org
X-Gm-Message-State: APuU4Z8xx1abNx1/wyT6EQMIXiUMC1ajE8OEvIrMlSEyKAz3Y9AqSpcI
	RZeDWZV3INT1veAS03TnNrtdfXBF7AfNgFhqPZfXpUsOpemz89Ux4w0cFzzlRcf0Tj/wHWBbiTx
	Tz5fI6LE=
X-Gm-Gg: AYBFou0ihsXcsaxdSPTo92E0vPEkecTzCzfWi5v/EEZ8BT4GPwodiaG64DAPr4EBUFD
	EqNYXZ/R1c/BEDgWE3d42CKkiXDNycj5pnsJtKZUvcdk1BAPhs18ZsLxBY7PjRdC7z1vN1TedRY
	hZBvfXhrUFL5ds0OrDJ9dPd7l9c8hxiuIPnM2sxmauDPM3kvOzp3mkq0hi6Bx0tD8hzpT3kERZ7
	R4Eb/S7VFgM0V0dcppi0ii+A9omI5bXoht3miTKTi3QJcjvdMPJAl0yja0/k3gEtJkhcMyIoHkd
	vabieWU9+KAs3FgqWOHpRiyUR94rorl/EKOpvfnyK1do1jp/eO7EiTKnPN/FHzlm1p0wO3S+gZ1
	kb+HH20v9Qe9bDtfJeJQkPFnmEmVsmg3/ka6qeMOY8fBcQaaeVrWkZXQ44wsUAjzQnFTxmeQ5Kq
	XkEsrTprPJacB5Wvcc4/YEw7VXOJQre/tJtCvc8XmR+TKtyoll0tGsoQBLdb8uM5Wze/ied32r2
	H5nXZDzdkTURYtnwlM7d/D1Qe2WBUZHpF9ISoxdPd4K10LLaqD9+qVzYXDgWf3Y7Svo5oM1nwjz
	GhwEwzGOPi86frbz6FO8frcGr1h8VwFr/3Cbm1OKfuaRgUvAPw==
X-Received: by 2002:a05:6a00:3686:b0:882:6d80:e5ad with SMTP id d2e1a72fcca58-8a9bcff6b2cmr12847979b3a.9.1793759755682;
        Tue, 03 Nov 2026 18:35:55 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.35.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:35:54 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 04/12] mm: hugetlb_vmemmap: generalize vmemmap page allocation
Date: Wed,  4 Nov 2026 10:35:02 +0800
Message-ID: <20261104023510.260766-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: d5ka18gnhuj6m4mdgzcr1t4juq7mr9gm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3461E40005
X-Rspam-User: 
X-HE-Tag: 1793759757-20992
X-HE-Meta: U2FsdGVkX1/XBgQhMo/cBJLQIdYI09g2h8fPNOwjBbIkrkOBcfZrFTBiAJ+NGVHga+/SE9vN7LNUxxadMg5vANZMgzyrjZycaF0H1P3uKMXPz09owdtGkUfX7BYLaTt5+kwEAKk5H+b1ttgN9gneQpUWbcS15prv0MSi73c2rzaSuAiHxOtDLYMSWKnlFoKB81iSckaPAn45122CTTlUANUrTx75ynMDKtUHp15F8Pb0ualxtWN5UlaiDShpVcF8gwAsA90tGgztTArRKZ0YX/HFCYo94hHvZtA/blZSbUzgVRxGaWt6qjpRXg4TYBkznMsYKDLFpl15/IUvxC9zxFyuunPtwB04eyKEVsXWLOf9Oe+kNDtOzzfrKRNr1oICTCu+LR4sR6Xw8Ao/dm1uzGaFgbbPa3NneQsRZU5bp7VE+x5fWcipP53LQdzOPh81Jy71JXnIeXpJZHIDfZucJEEQFgbDc3OIGoYWBdYdS12/u7tn/LzP9xjWxTL3JDnxs1KpXQGb+/jBtwm+uhUUmvGluDeY0DloeK5+vduuCWG3oGGjYIJDQAvS9aDqjmO2hwn84WkwSwPtY5fAH/GNmw/RoD+HvFE7IqLH6PWDDhiJhCwIGbjVNvPK+VYy+c4OOzB9zgakdItJJi6LC6HmHcCxhZtOz6dtuyVIGps1vAVfvPzX5aLQ2fGYMU/zzD6EkdyBe76xSn8llHqOKR69uKxj/1cpF9J5wSEswBvx7OkqB6Djo81MeWIqZI6z8F6Bugf0/eRixDkfDasCEHQxijXurk4be6VgNqchcwD8sGNcKGiz60JpPZfYmq3XmeVDzedIRy22MJcF4Y/sZUvRxXxdFquEB3ETHwBNthkz3eRkW1IRSA7o0UYetwbGNVPMNa5ASBsDZkIO7vBQmPKLrCAHaWyNoatQ/De783mPMuF9dNt9ra/uM4TFTi8/VUdlG2F0gqVSMy3ICtq/hph
 0pPa5yag
 boa43Vy4Y6prO1IbSsS65zb3Hp+n8jVurBNDj742K+HgolIRUxtt8NN/iAzsPCQv26H1SSgAssVgO8727GO/19AZ0vuDhFJA21UMGU36vOQ+hilAL0cB/no62Qc9RnGfWdU50i/fGvuisI4U+i+8ep6rHh6AcFtZ1UA8jkAkGjlDRBDgpMnD7JwizrOblWs3M6Gb2GuVLOjhc3NNc70wVGyYGzNxUQgnvBuP4fPG3DlKGBFumlA8qywbcrd7/U2keE3yW8R0YqRtO2cmrsi1eo2p5zxDZIrXCcvLLz08gXeoVy9x0I+vjJ3nuscTDyKtN18rlZVkS+z6t5i/nxsxU3P8wnMf7gE82ffqfMggBZYu0/Kg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap page allocation is currently tied to restoring a virtual range
and assumes an empty destination list.  These constraints prevent it from
being reused when pages are requested independently of a vmemmap range or
appended to an existing list.

Generalize the allocator and give it an all-or-nothing list contract so
the restore and optimization paths can share the same allocation policy.
This also allows HVO head-page allocation to fail gracefully under memory
pressure without triggering the OOM killer.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v3:
- Use two tabs for continued function parameters (suggested by Mike
  Rapoport)
- Rename the local allocation list to new_pages (suggested by Mike
  Rapoport)
- Use a goto cleanup path for allocation failures (suggested by Mike
  Rapoport)
- Free failed allocations directly and retain batched accounting (suggested
  by Mike Rapoport)

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0e5b2b182d1b..d3058e106795 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -334,26 +334,24 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
-				   struct list_head *list)
+static int alloc_vmemmap_page_list(struct list_head *head,
+		unsigned int nr_pages, int nid)
 {
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
-	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
-	int nid = page_to_nid((struct page *)start);
+	LIST_HEAD(new_pages);
 	struct page *page, *next;
-	int i;
 
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, gfp_mask, 0);
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
 		if (!page)
-			goto out;
-		list_add(&page->lru, list);
+			goto free_pages;
+		list_add(&page->lru, &new_pages);
 	}
+	list_splice(&new_pages, head);
 	memmap_pages_add(nr_pages);
 
 	return 0;
-out:
-	list_for_each_entry_safe(page, next, list, lru)
+free_pages:
+	list_for_each_entry_safe(page, next, &new_pages, lru)
 		__free_page(page);
 	return -ENOMEM;
 }
@@ -374,13 +372,14 @@ static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
 			       unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
+	int nid = page_to_nid((struct page *)start);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
-	if (alloc_vmemmap_page_list(start, end, &vmemmap_pages))
+	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
 	return vmemmap_remap_range(start, end, &walk);
@@ -527,15 +526,13 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
 
-	vmemmap_head = alloc_pages_node(nid, GFP_KERNEL, 0);
-	if (!vmemmap_head) {
+	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid)) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
+	vmemmap_head = list_first_entry(vmemmap_pages, struct page, lru);
 	copy_page(page_to_virt(vmemmap_head), folio);
-	list_add(&vmemmap_head->lru, vmemmap_pages);
-	memmap_pages_add(1);
 
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-- 
2.54.0


