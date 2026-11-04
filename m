Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D69B7606A335
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=GlE73w6A
Received: by kanga.kvack.org (Postfix)
	id A30C86B05BD; Tue,  3 Nov 2026 21:36:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01B66B05BE; Tue,  3 Nov 2026 21:36:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B236B05BF; Tue,  3 Nov 2026 21:36:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3A06B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:25 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C7CD840617
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:24 +0000 (UTC)
X-FDA: 85395872688.17.43E3724
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0FFBDC0008
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GlE73w6A;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2cwCbkV6UpQ9L+91R5Pg3Muqi1NLiS2xKQYMtVtHCvc=;
	b=cW5yogORevB8b+s+fhShZsnj4zrE+pP/PWHOLvOEOPt8vIhGQ9JpzOQ/9xUSu5L1jhyKP/
	wIljm9MT00BrjgC5EPGXtd4s6VVsKso5/jUEk3aQ3mCBtOVb+8zBCvR0Ujt7U/0jLoX6iS
	NRhQbW5N8yCa2e+jgfQVSCZ9x0M/2YM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=GlE73w6A;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759783;
	b=WtT1pccrlB4iuLgQCyZuBJxXRQ4MNh2mFbfAV46BfFnOkIViXcnKGIVdgZloMGi7q6CbPi
	tfRiS60f5XGgcH7Jx51RQXMYsLh84kZ+3vm+Aytx2Wco31GXwkNBTBE27KUbjIIDEZiE/Q
	FYWQM5peReY+ZHTNrtWTbjdOu3JLHsk=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8a0880a46e7so54075b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759782; x=1794364582; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2cwCbkV6UpQ9L+91R5Pg3Muqi1NLiS2xKQYMtVtHCvc=;
        b=GlE73w6AjsDK5qEOz0b7J0TUEugn02KSbwxFI8ybofNpfPfGp/uuwqUSrLXHumjGQW
         t9t3066mH5k7SUEsV8u7nGRU+9T5yLZD8+DKSiDJVtA5RZ7Xyii3WeJWKkAOiEvyoB39
         DkdYwdNDJm/A6v6X4ehUGN0MTE0Nxo59PTr7fXy74dUjBlHgylKpEjd8TmCgcGV9QGli
         dA2UXZWTddlmJp5LN7BvYR2RJcrKaFR2a+6/JCF45/yGHLa9KYsplqCJh182ZTM0fhvs
         ql8QT/IfPLmYK9x/gvtQd4CMpETL9Zfd+y417aH0RrSpmQGzJ0IvvxcvHDVwJC1NLmoU
         eQBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759782; x=1794364582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=2cwCbkV6UpQ9L+91R5Pg3Muqi1NLiS2xKQYMtVtHCvc=;
        b=avkniU7IR/GBMfZ6xn+ApCE/2MlJiGBu7qeFjfTIFU6teDuV8lo6ueySqSNG0dhRgt
         vUGI4VOBrGtJied0dW0Lx3SnMYh4NUN3A2ISE1V9CiqIO2Tyt9h2KgT4eiKFhOHzpplF
         ohfMTE99chW8P88onZNashxkVW0rnHEWidkpTK+uvoXB1fwTb8ka0yI6kNLhmdWwSzim
         gcjHOa/Sqe1agO4TZYJbO2PKf9eJrucTgYQIshGxOPMFH96uA+oZI0vUZPVYko3NXnn8
         YytWBcpxWn8jCjcmtBecQJLcHX8IEidbqsSTpmISDRjAmOTrAsItodTxlKTVEs2wNC/W
         WeFw==
X-Forwarded-Encrypted: i=1; AKwUvBzSrKaVLK0UrcClGRt+O3/cVcyD8ZOuTWqkaFGcDLjr3450/UrgL590daPOLjUOACu6J6xkFjY+dA==@kvack.org
X-Gm-Message-State: APuU4Z/SacSX37RUEOuZB6DQILGuO5mnSQcdKDBZOrRJN9YyXaue3Mbd
	gcRP7pmh5koBLstW0Sq9R436dxA/7jw/fNOH+jL3iXtp672bIL9kYBznuUFx2r51Glk=
X-Gm-Gg: AYBFou2lK/ZKUHsUEQWzN7nO2vsccvx3gEDcbcX+PU/ecbTmu6tA3LPiOJG1Iz67GPt
	0bPdk0xYFmSey9FqS0qo582L3wwcHSuehR/gtBxIc4upd/EgGzJPUuko3p94gFr5u54GVyINsDP
	KDZ7cp12dYuGoc+tjeKZd7ZSIJ8fBkYNxR8QvKUHP2eAJfXtSr0Z1EO3tGaGvqbMCfY+Dw+ZyFg
	V0w2pT6QNeDSafxj0SUCJmxh11a+vexo8NfdtreYXZ26WKC3tc+/bJyd8Wxczd7bOMUCFtXS2rS
	4qWGYNDLe4eATDIY5l8QXTBIpvV9UfqLgZGix0PdjCFLakMkKCl6E/svBcHdrHakHC7tug8cY66
	oyrLit4ZyCUUa+vIxUGxRymejv4o4oL5iIAKfsCTJZQPEzxMap6CsfSCv/QGMiE6xPRE3ciloDu
	+nWyDTHaPjHOQlWyO5zO2g1JDxmEV1g/ELgq7ibiXYNkMTWNqXbIdPL/Tzneb0PGEb1xHdmrbNK
	zyDnbuzcGegMlD+BUGdSvvACqdrS/enJJmjdAQuZOyz5AlRLIv1EKTnyTHzMJF+KcsjP+G5Ex2b
	rjtJmVH6FA8538pxoW+gBR/BNe00aSoCQipJXfQQYMzWXlVGsA==
X-Received: by 2002:a05:6a00:10d1:b0:89f:2b65:2ad with SMTP id d2e1a72fcca58-8a8323afb88mr11419858b3a.27.1793759781592;
        Tue, 03 Nov 2026 18:36:21 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.36.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:36:21 -0800 (PST)
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
Subject: [PATCH v3 10/12] mm: hugetlb_vmemmap: make vmemmap restoration folio-oriented
Date: Wed,  4 Nov 2026 10:35:08 +0800
Message-ID: <20261104023510.260766-11-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b55wkts1go455o8o3cu4hdbhr6q6dof4
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0FFBDC0008
X-HE-Tag: 1793759782-554649
X-HE-Meta: U2FsdGVkX192NwTNJbvaGYpfLEFSG4mja5vPCGZTOn0YtgSbao/UTQUot+TtNof4zDYWkBvrcMORt579dDyeediCYeu7ZjPbMSIQlrqZbgpIVBWYHsvqbMlzS2CYEOerAdEZdWYeOo9dV02DzCY2xvRKJ8oTjCT3nK2i50qoZf3V6pBc+hAqadSkoDTmOOGr8Kt5SLv87pL/41mYQBQoOC3bsjp4oMmAwoP7BlAThTTZPBMhFbFuYv3ehI6/qU/GVmDzrGPcxCn1WyWCrjlGhkEeSc+3WzQPS/cy9bjCz9n/4agfeIzN9l8bKhlVww0W4ElNQH39phNLIRA/EGaJgjYBWEnFRr6KSWfWx7YgaAbXGDw9oJWOyMXQElRRlael1EocLeILRbiwK/N1Fu3Z/5URZrD/LqPL+xXD1Cd5i9uB7l2bwvjBano12gOoSmpVlMBtK2cpWVXbTMI/QQ16bDXwS4TcL1b1TyE1BFAcS+jftC1dR/Ryl53zp15hPEwlCxm5ueYJOi5+YVxahlIjQiUyCClLmO45C0sk4YhuAilzCMjcSm4V19uBLMPRnQsWXn1mD6qvVb/Ah3K3aElhKr1nwg3m/dLiQfezwVS0LXGW03JFRQjqk5uWEqgydDQI9r6rT+fKyPd70RCStBzgp/GPCDUUTt4aWialUFVY9TtiuwV/DaJ6wyMbObCNNnjlOyhmCqNYfs4AuVEpP+EMprF7zxUtKGl+qsYNXXJTns0m2ioq+jGyHMIQnVDQuRZP2bsV0aPXNQ3TaKK+WTFu8wp6zJ+w4ie8qiO/CiYSgg84pQ1DiyT2lic+jh4uTF5tsIIhUzKvS8DCkzhLZe5H+Q/c9e7sK23FB4yrv06DinZZqhG5yUH26zpsx+BHBYbPfESSZmCQAhyj+yDLp++M635VS4cBe1smPCAG9swV8UxzCMqQdlHzsOEShjX+g1qtoBg66My71JwTw2sYi9R
 2dmFXlGd
 9MknQXvGVM5l1H5O2PBnXwF0o4dN2mE7cG1Ro2mVX6skz0Wh0eZVUBU1j6d4ZuiXIXNXRPVq6aWS3Jmuaw7BW7K4yL9oXJK7yyZmVR1N2/b0zU7z4uzsIXC7J34egiHw4vsVT5A1abjpfERALkgfD4hO5jEHab0LiMiL1vv5ySbfrGPBmuOLGWcOGnPxHyCkol6ZBMzBNVm0H2oZGxD3Ui4J9YOOvdkg1elGjtfCP+e/QTTpfgbR8JflirG7W+nuuknSYs+NI8ob2iypdG2vDutoe0kkHC1pQ+8Y1KvuFIjDzkR4MvldYJPrZaGOx+olMSQ3PJj7h1akUyjDNh9s86noYkGc/AOjjRXpjgbCNe9Gd1J1ZU0LxPns5WTE/TwkKUrQr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Like optimization, vmemmap restoration operates on one folio at a time,
but the current interface exposes a raw address range and requires the
HugeTLB caller to prepare part of the operation.  This splits the common
mechanism across layers and obscures its natural unit of work.

Make the folio the unit of vmemmap restoration and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller and gives both directions of HVO
consistent folio-level interfaces.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 64967f18e3c3..e424cb0b1a78 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -363,28 +363,29 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 }
 
 /**
- * vmemmap_remap_alloc - remap the vmemmap virtual address range [@start, end)
- *			 to the page which is from the @vmemmap_pages
- *			 respectively.
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_restore_folio - restore the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be restored.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries are restored from the shared
+ * tail page back to distinct backing pages allocated for @folio, while
+ * non-optimizable entries remain unchanged.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_alloc(unsigned long start, unsigned long end,
-			       unsigned long flags)
+static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 {
 	LIST_HEAD(vmemmap_pages);
-	int nid = page_to_nid((struct page *)start);
+	int nid = folio_nid(folio);
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_restore_pte,
 		.vmemmap_pages	= &vmemmap_pages,
 		.flags		= flags,
 	};
 
+	start += VMEMMAP_OPTIMIZATION_SIZE;
 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
@@ -402,7 +403,6 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 					   struct folio *folio, unsigned long flags)
 {
 	int ret;
-	unsigned long vmemmap_start, vmemmap_end;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
@@ -410,18 +410,7 @@ static int __hugetlb_vmemmap_restore_folio(const struct hstate *h,
 	if (!folio_test_hugetlb_vmemmap_optimized(folio))
 		return 0;
 
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	vmemmap_start	+= VMEMMAP_OPTIMIZATION_SIZE;
-
-	/*
-	 * The pages which the vmemmap virtual address range [@vmemmap_start,
-	 * @vmemmap_end) are mapped to are freed to the buddy allocator.
-	 * When a HugeTLB page is freed to the buddy allocator, previously
-	 * discarded vmemmap pages must be allocated and remapping.
-	 */
-	ret = vmemmap_remap_alloc(vmemmap_start, vmemmap_end, flags);
+	ret = vmemmap_restore_folio(folio, flags);
 	if (!ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
-- 
2.54.0


