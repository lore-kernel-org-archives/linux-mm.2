Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45A3C606A338
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=GG40mtil
Received: by kanga.kvack.org (Postfix)
	id 076DD6B05B6; Sun,  1 Nov 2026 22:26:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0007C6B05B7; Sun,  1 Nov 2026 22:26:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0B5A6B05B8; Sun,  1 Nov 2026 22:26:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFD406B05B6
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:40 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 22E09160B21
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:40 +0000 (UTC)
X-FDA: 85388741760.29.112EF0C
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 212CB120009
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GG40mtil;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793589998;
	b=Bh8CkrvpuPAvhSODYScNb6u7GTrdqpVzr6KSbmokaJCfZXs5X9xWIzd/XSwBFcrNWphzMG
	kPuUIcfYV2Fkw4pRZhwmZkkLmV3aYbAPMS4wcVzc+AkutLATZSqePiFgl5YSi5WNRM2EPW
	iMl0oqr0OJmeoJPq35YWrfW+QXntG9c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GG40mtil;
	spf=pass (imf29.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793589998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rtjzOv93ZQQ1NtevyfPlHmlaYatVtEvSfGfez3JEDoc=;
	b=P526nU0faiz2f+BVXgZ6F7Kp+5Xa+E4ndxkLSLfIXHJ94cUujR35DNaGPuttxpKR/V6NLA
	T1poA5XrTdLX0VSoIDqI2lJw8T8pQerSaAK5bmkUmqNYSmX95a5/E8e8eZdLRGy/KvxziS
	ppkexZKiidkHR6vrTZyQYydKtLIAnjo=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ae702d28c4so1093431a91.3
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793589997; x=1794194797; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rtjzOv93ZQQ1NtevyfPlHmlaYatVtEvSfGfez3JEDoc=;
        b=GG40mtilNo+Lqrm69Tgd4tkuhIf3VAPcMnu+IcYOYD8wgHEVK/TUIpzlNK4K23RXSI
         pw1eah1fcQAOM8geuQEMaBrvg95X6T0Vov2lC/ppbw1TufddT2D2i3Ed6H0hoqGJ/hr/
         irFMBow29AreI1mg4QrguR/WM245TxjLNLt6Oe7lGIN26yCtc+4kNYonm2WDgnPjqgSB
         O7z8Tr8bCq6v2pJzhVtPw0tQPGay3aIkLsvZJJa0J46QhMOLIv61ha7eki2Gul5fc+a4
         0M/AR+eOAU6Kq50mxibsp5kqgXKP7uAIz7dnpZV8UZcZ2V5aDxJ72GWqbRRt9MTjUVAr
         UGMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793589997; x=1794194797;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rtjzOv93ZQQ1NtevyfPlHmlaYatVtEvSfGfez3JEDoc=;
        b=sCCMgqc3xl1jnterv+lsItSdHG8fgmERnjHrcY9/bueAjpM72M1MBTzejVJ0pW5Nhh
         DHdq+6qJdWOtQLI+KmRluJWR2FI47ASheZpuMFqxKwyOdeFbVtuDU2Gx5Z5jcU9Rqi3B
         9+1A+CSWGfXODiC1eIlAcU+1PxIW6SR6azlaFUBybn5i8PKMpzwy/vnEyCtlCm1JVZcW
         ipuPu0ziWpJNr0uHwtxL6TOs29TZziyEn0w/khhZwDyzLY4OfJYILlNEy8U7RK4mFlab
         MhCPhAQ8uOgHWFadengfEG0rC8SJMEMhtgYTHnRhDORanrMxypXpDGvjQw00xzTuXlNa
         gG/w==
X-Forwarded-Encrypted: i=1; AKwUvBx32//aIdzu+sTvp1cIJRDSTGFDZCHZ8h9msMz+SlT2dK5OlhhwZTmT8UTPlGwZgwfQIBOXBrEFPA==@kvack.org
X-Gm-Message-State: APuU4Z9bW9SodaAFJeW5+qxpZ9G5zDpVCtwmbPa7aL3pB5ihWt42PXkI
	YLaH4LleolPYKUPd5QUenmKc5St80z02gTVmdjDs85HarYKMRmemifgTF5hAfun9wEM=
X-Gm-Gg: AYBFou38wGMuWWmtFNMx67FUXVTevv+p5egcLp5S8/7LyvhTl5yQ20Ol5IZSQtSVrIT
	36pQtN6gZcJXZyjwRm1qkp5G4s0it9u3RmUMVPnUUtcH1pWumrlBQteOnXOoBu+MGGNKV7PYRQ9
	aFZgawrIaQ2Dk00lJOx0vf8Ut7bukbGRACRUdBbPSPUUJFsV+rmrBfi9SPupRgEJIrMZuY2fpid
	9A2U1N6nzgLt2gUU9zpju1YHaHYNbCiDXAIU0/w4ynx9CDmNu9kDx11q1YaJ/82pYTo+gzNT2Yh
	OlNnWHlBVYKbBGPNx+x7cFY44lWk0yES5O3Epr8VGDQL7w0Wd/M6aIsR4kdH9HIfq63NlOAqDQC
	iMU9LeU3uIaE7FzfKgdvDWmN20CJluSXgUdDwxKSVnjRo36gpbBBboblSM8rUPegGfLzCdJKys5
	wsIxd/mWNJj9CIfOgQbOK8kDHrEkH5SKcnqQnWJdObiDOdatayPM9uasA+QETOwfb3DEglR7HxN
	BIXVhGjYmvaUOXaS2Xe6Xvw8jFP8g3DvpAomtOlNQLER/qJWfsvoHyzjWoAVMFcC35vmVYIFA0l
	YY6XePtGUhXZtmS+fNZ8S6rIW4FVj+V9Vb6N8G4NfhTVNJwQXw==
X-Received: by 2002:a17:90b:5863:b0:39e:4c80:f67b with SMTP id 98e67ed59e1d1-3ae897f4f9dmr7296008a91.26.1793589996933;
        Sun, 01 Nov 2026 19:26:36 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:36 -0800 (PST)
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
Subject: [PATCH v2 04/12] mm: hugetlb_vmemmap: generalize vmemmap page allocation
Date: Mon,  2 Nov 2026 11:25:17 +0800
Message-ID: <20261102032525.3597743-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 212CB120009
X-Stat-Signature: 5ikec786onhs9isjigo353x6zw7ea3n4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793589998-166707
X-HE-Meta: U2FsdGVkX1/JkMBsdybJ6Gi+MpBnzqKhDap0fgJQqE+Gi9WTQOqx/DzHcRDIbvFKW2F128n218WbTyOYdtDz5eiOwawukpRYDk+ehjTvQpi1ZQA9TyPtyzTOUhvWSMeRRUiOSh9/+wlrhxvmq/p3JZQCiRiY5J12OrF3VXbfJyJ9GoIEgvHmAIB6deQSrpm3oA4MV5jyhN252WhCpcaxveLrTrota6yrI1Bejj97iMkXfT0OoEjGZ8RgCoDRJvQros6I3K8kIR+zslO5sLrgzR+m7xRpM3jDTktOmBu77kSMYyfMmZFAASBM6pP9o3dR2MFMtvISE17JdQphNrrHXR4mkzD9L+BalmQYkt2EYZAzF8adWGjY36+luqZD+7Eqxz9ycFEV4Wb16CW0fEFfCUIbUeQc0Y/I2XuknG/6r3/xI79G2y/VHfO+SoH4GSFv1MGxfrJVFvqlUudztxnVNY9Fdvd0KQDblj/3agfTbkmfNvsPXuOH37QfUxc7Ldus2GjpA2qFLNK2uf5VlJm6GzJocXjCJPCju8wcLC2z8cpWP+9qi156djEGlQojUGce0cVLoJU79qgbo/MfsOvfDJEn56tttg0SIBlKUbm1++u1kKr1NngD5LEAU3Lz4che0ST2p9bq3JmI89ZnxjknvR2+xtfvS7PJ+8BKI9u/Afl3I94Fdl3DK6PL8sZo/U5Iec0No3SJPQtmG+9Yj8eqgAgAolqL/CixoJbu/BjqeFMRZN6uy1nGGi3DY0hnHfxPNdf2mjMZk2nSELjTTlP9NEQivB+ScnsDSkJk5EkcL1fCuswL+WFkr61VmauAPvVabUbsqyEwro7R+h+hC39gRYwLkd/fqAkQZjVQBur76JCdvbMKU34jL/JLA9m4KmfPNX0Xcs62bHmJgx/XbkXOUE7N/NFZle36V1Q1a9g7zFYioBVK2v82zk1xShaDe0j/ey/iyAx4mhiJp23pKrP
 K6dvaKzP
 R2zSho3tYdfxCNX8FeoHoczTg2ogUdPpGxetdDZlytXzmZ8mDpjZjXmW1Ii9bF/hIm0RRMlbgLt/BHP61wHH8vBdfgr9G5jgmrGpB4yBunNOxj576Y+VYn3MI9XuQVFs/XuitJPLR5VeWWUcOi95MT6JK0QGL6mWQSKCrxpGb9YdjSoZCSIxo+DHMQaBoJxHPRMMKHpNKrbUVhl2TBGJNXbdx/RlrB05i1L/gfhtWIVUe4TMSmcJYx/AJH/bSiyAqMHYzZYPAKV1EFf1nwPbVh+n5Z3DUogJtSxx4ZKosRTfwNSog+1+bs+8Rfl+qfuq3JakVWy6b0HAEZlMG6U/I2Zzv0OCsafh5tyWvmRHxAN7M3pKY/I6faQsej3z4n/lheL2Z8XojqY5LFSTdfX+AO8mzw0lm6vPR/Lfj1eltENi3snDVUHmRPegSLXXmQfzoeE2wcRcZbqJLk3s=
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
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 39 ++++++++++++++++++---------------------
 1 file changed, 18 insertions(+), 21 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 0e5b2b182d1b..4b20a8efc067 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -334,28 +334,26 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	return ret;
 }
 
-static int alloc_vmemmap_page_list(unsigned long start, unsigned long end,
-				   struct list_head *list)
+static int alloc_vmemmap_page_list(struct list_head *head, unsigned int nr_pages,
+				   int nid)
 {
-	gfp_t gfp_mask = GFP_KERNEL | __GFP_RETRY_MAYFAIL;
-	unsigned long nr_pages = (end - start) >> PAGE_SHIFT;
-	int nid = page_to_nid((struct page *)start);
-	struct page *page, *next;
-	int i;
+	LIST_HEAD(local);
 
-	for (i = 0; i < nr_pages; i++) {
-		page = alloc_pages_node(nid, gfp_mask, 0);
-		if (!page)
-			goto out;
-		list_add(&page->lru, list);
+	for (unsigned int i = 0; i < nr_pages; i++) {
+		struct page *page;
+
+		page = alloc_pages_node(nid, GFP_KERNEL | __GFP_RETRY_MAYFAIL, 0);
+		if (!page) {
+			memmap_pages_add(i);
+			free_vmemmap_page_list(&local);
+			return -ENOMEM;
+		}
+		list_add(&page->lru, &local);
 	}
+	list_splice(&local, head);
 	memmap_pages_add(nr_pages);
 
 	return 0;
-out:
-	list_for_each_entry_safe(page, next, list, lru)
-		__free_page(page);
-	return -ENOMEM;
 }
 
 /**
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


