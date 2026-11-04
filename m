Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF3EE606A32D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=RGAG3Cq7
Received: by kanga.kvack.org (Postfix)
	id E70276B05BC; Tue,  3 Nov 2026 21:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFE336B05BD; Tue,  3 Nov 2026 21:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9D86B05BE; Tue,  3 Nov 2026 21:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A85606B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 248654062B
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:21 +0000 (UTC)
X-FDA: 85395872562.18.53BC969
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf15.hostedemail.com (Postfix) with ESMTP id 520EFA0005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RGAG3Cq7;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759779;
	b=CIAfL9kFDkTEvWo88D3bBtKQOXAqkFG6ys21m9JJwnzV0+/1nkbM7+hNgd00e0BGYsF+Qi
	XSnzFx9uqk7XiabElkmZVaIEXc5LF6APD9WvrgYOicA5MFh6SXrJmxWZ29O9uamD3oggan
	Vj/AueZyj3CtZRO+S7Jxh6u3YuVagS4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=RGAG3Cq7;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=okHG2gVXQbR5G/Mx7seqYCkqeBXjomKsQCHd4q6G+sE=;
	b=fOmv63qD9dM5jliA5U70wykGF+RMyAmqL0bjqV/ipBjiAHZirsdyYV8U00BUx0Za+C40i7
	vGWv+VWoSbIZeSOoeoYTpsiDpE8mH1nWFb1GR4aoAFXuRuk8a0HwSIA+HH+kc8JQce3sBz
	7lCh3MTx6z4+elnlbAYk+6jYwgD1EbQ=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cdadf7e248aso111852a12.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759778; x=1794364578; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=okHG2gVXQbR5G/Mx7seqYCkqeBXjomKsQCHd4q6G+sE=;
        b=RGAG3Cq7la0jA6ZvXDpzr7GZ+VyxVL8PsDocIElQC5DA3RdWnjYOFtw504An8ZSrl4
         o7vJqvbPbFfClo+B7u48/GyPhBnEaGMtpJ7ZdUba9nB2L+lBq0kjQeKWXOTun34Z9tze
         03HT/mgu1vzH8BBJvR8xa/UzpdrCB8Ds60+79lVwpBvf1DDSMxU/8z8hrsvM1t6a0P5t
         VBC8DSc8Rj765ueDCGvU+/KLgW0IG38kqb+1E8Q88eUy9ZP18McRjA70BzNxVLXE33j3
         s+0LZVC0p6EDMi14iQZ8LAVC8kKOJLW2lkCCFRtckfIjMetMRYPK+mTuDsZ0qIH0N7rD
         9JGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759778; x=1794364578;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=okHG2gVXQbR5G/Mx7seqYCkqeBXjomKsQCHd4q6G+sE=;
        b=lA16S32aNLmgEnh+QdjVUc+c14Q47i73ShaMm32s0Tmahqwo4g5/2e7tMIW+FIVfyT
         u5eg6AEDyBrG5xx6QJTdsrzd6U0/rmNbSpUAsNrliPYBaUeez6hEwU5bbnLo9dTRQYNM
         XBvi8bCRTGM6dVhd4k5aXVOxHJY81DDZztkO9ECW92rErIeUHmGYcz9UiOLmr8FmBEYw
         P0USzm/N+R7Q9bPh4rSzta/FdLDU/vN4UXid6inpfbnqaWGyCmJ7uoRp7+6NiUicQUsd
         TzgkeqxwLRexpLCKpLfiYCI04MCxOQXs0viKIsjtJHh/WF2lBf9lebKe5adQt/CIBtFW
         LI3Q==
X-Forwarded-Encrypted: i=1; AKwUvByt28yb/cVIw1V70O6HTqAbqxVGyuPRAmzhs66yvHzN09uCYAuuU0DSGSRgM7XO2S5IusTWBknwrg==@kvack.org
X-Gm-Message-State: APuU4Z8/Xh5zI1p5oTPZlXYve3baNoe91Hd/VhRyv8IrJngnAEQ5rCjT
	/NmqebAY4Q5tCzACG5n1366Q1YlComScbzvNIf5zTftJXV5Qi1cNK2havJaJqcBOHg4=
X-Gm-Gg: AYBFou2sbGMOooCdKVTTrkGvHJV8eF0GZkF5MWJHkkj7MMSUd6wGTLHU7wTj1OlLaEF
	d/EQDBQAY5CytEvW1bJpKb2lyfYAmkNJoemu7w2wER4EybUcccn5RlcUw0KkldQko3b6RePyGQr
	Zrp2Y4dIZL8v1mcXP/8r+qiJ4ISjSk7BJVoTboOYb4y3SXriJZD68/PR3C8/cOx+4kfV0VPyFkf
	kED2YUbRRsc/1enlDLg9tLTMkmQ9Nesn3+Unu2ANOm7/Ju6N1LuHvLJqQzl/yo2dF7f3Ao5KToh
	6FZaEHcIPQFLe68e7D4rIHWV1MysZsKg4tkzat+H6X9IKl94YkqyjTAydz3BNVPhP0vD7xK1hjN
	PuUSu+E1vm0qR7+hmA+8XLJh10Tr3B3I7siiRcvj4FlGjS6GrL8tHaVYAHaMzQ/onx8TSn44fl2
	Sg/TCs8p0yW8gtpW+ImVp4afDwIB5Q5uLGOuawJ9lFwjBL7JEYWaAgtbHh9AVQIgLhJnCceF77b
	lhc7YxVF8edgRER3wSbGbeoTV/oW5KSXgcZFxviOwocYeXZKI3Ao8VoDMRFRDUW7GMCK7dsRCHq
	kBklMabqY6GSWrHy7Tc+iGTlVtovWbqBLIdMf9/YfP9X3VrFS5ECTVEAGCPn8UNL7BcVcQg=
X-Received: by 2002:a05:6a00:4b4f:b0:8a0:7c97:52a1 with SMTP id d2e1a72fcca58-8a9bffd5de5mr12523463b3a.48.1793759777952;
        Tue, 03 Nov 2026 18:36:17 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:36:17 -0800 (PST)
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
Subject: [PATCH v3 09/12] mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
Date: Wed,  4 Nov 2026 10:35:07 +0800
Message-ID: <20261104023510.260766-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ffakgaxp14wa67ih7cbjeoxg4xhd1pwy
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 520EFA0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793759779-707489
X-HE-Meta: U2FsdGVkX1+9TyJ6TwpjHlissTiWo4ebppuTciwis+a0dvxgMYvKECSlyHSPQoMn4mCnJ0toU6auX4MQjnFVJkuNlwNphobyg/kj/+dJ7pqorcTmQHltPrkz2QIsndvFxlJ37gciEE7YNhfWD1MdLsomldUndLyCX9zdTB65qhOGXpZMo88e9MNUQvkuLd9qWaw0Q8dv215Y7avwz0rtOeEz7ocseuHWrWgZCrw/etP9w8bNO8GvO8G7lT5N/5raNstNhLPDawwnhMsHZOFFmq5RfxYYUXfA4rQYIwZl/Iw4UMim8X3jI9PVNb33ApErPLP0Nyr5RjxIm+6LWdKFBkiYuz9cihclsHboX1dKSfAZ7y1mYsyvLAVuywhGeOPkluNwDtMG92DIXvFv4722a6sV7fmDwx0hSy1D/gYnzDddJKO4O2L8nfp87YCWErspbpUN6jdza/FpWz0XJiXXB0e5F3ZoZNO5HZCo0Fe707UepaKjZ83+wqwBBfoW34dWoH/zlhb5fE6L68ly/ydZCJixnKu4opzfkfkaLl9ofQF1R4iDdyzXpmmzcMg2Mpovhna+JRk+VHU8JgM7AU5aPnGhAnsB+jdkDRxJe/7sanE1YeXpdFszI7uBcPjaXRq7yI51TllyApzssPKYoZ0ACCKGVB/0STta5AknBFmOHwWxanO5S5knl9HgtH+GkjFUkatLUoZJOuR/+rC0e9UfKhIiLZXSkIKWootz8TomM6dtIRyGSiKeKnXzXHqzH09c14y58iQZ/kwYnZm/sp8Tf4MvQhCzMqlbkxHYPoybPWJBfjlfqLRQpL7NeY/4QcC/5Xy5IgYoAtDoRPTLIrEojo2Z5SlJ6jbrzLoQNGuvyA6icle+x3MC8ppANB1lz/Y7/2kXMi2+NMftKJTZSLbCErGCKcqMafaJqDQd6O27Jt/cUOwtFMkAgzR9veck6IwB+JhgeTu6o9Ew9KU3LHd
 yjw64LxB
 v8nIo2rueL03ZCIpgTIa0HkGEjHC7wbmBKVPlUpzrNyYbekKh4XfZJU4Qyw+jyvM0tUj7HRsWpJoLbOppfK/uo1rCASGFsf34YnyjwFDkXlyK41WfgDsRxYf6DTETS9s/3YaPmnOvFs+rWFiuCh4xOZ6ZwCse7kcT6PdjPKbalaiODjnkkTTCx9SfwimrtNXhLPVq3b27+w5kwymBLd1HeRpOckJbbZNTcq29tMUkOzrbaCHPu5hyK/+01eLWJUrFbyhDCZaoldLO+TWji5LQKVQxAabbEh+sBlL7aRNSA+LTx7ihGJPvxVOCQjLVl2ZW8FKHu8Zxvywfxec13ruy0KvBmnC8JRgqym5VJdI3DVXdSoxf50ldRyRTgE7K71jpeXVt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Vmemmap optimization operates on one folio at a time, but the current
interface exposes a raw address range and requires the HugeTLB caller to
prepare part of the operation.  This splits the common mechanism across
layers and obscures its natural unit of work.

Make the folio the unit of vmemmap optimization and move the common
mechanics behind a folio-oriented interface.  This keeps HugeTLB-specific
eligibility and state in the caller while making the remapping code
applicable to any eligible folio.

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
 mm/hugetlb_vmemmap.c | 64 +++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 34 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 7d51df1cb78b..64967f18e3c3 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -233,6 +233,11 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
+static inline unsigned long folio_vmemmap_size(const struct folio *folio)
+{
+	return folio_nr_pages(folio) * sizeof(struct page);
+}
+
 static inline struct page *folio_vmemmap_shared_tail_page(const struct folio *folio)
 {
 	return vmemmap_shared_tail_page(folio_order(folio), folio_zone(folio));
@@ -302,28 +307,39 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
 }
 
 /**
- * vmemmap_remap_free - remap a vmemmap range and collect old backing pages
- * @start:	start address of the vmemmap virtual address range that we want
- *		to remap.
- * @end:	end address of the vmemmap virtual address range that we want to
- *		remap.
- * @vmemmap_pages: input/output list whose first entry supplies the new backing
- *		page for @start; replaced backing pages are added to the list for
- *		the caller to free.
- * @flags:	modifications to vmemmap_remap_walk flags
+ * vmemmap_optimize_folio - optimize the vmemmap backing of a folio
+ * @folio:	folio whose vmemmap pages should be optimized.
+ * @vmemmap_pages: list holding replacement pages for the remap and displaced
+ *		backing pages for the caller to free.
+ * @flags:	vmemmap remap control flags passed to vmemmap_remap_walk.
+ *
+ * Remap @folio's vmemmap so optimizable entries point at the shared tail page
+ * while non-optimizable entries are copied into replacement pages. Caller is
+ * responsible for freeing the pages left on the @vmemmap_pages list, even on
+ * failure.
  *
  * Return: %0 on success, negative error code otherwise.
  */
-static int vmemmap_remap_free(unsigned long start, unsigned long end,
+static int vmemmap_optimize_folio(const struct folio *folio,
 		struct list_head *vmemmap_pages, unsigned long flags)
 {
-	int ret;
+	int ret, nid = folio_nid(folio);
+	unsigned long start = (unsigned long)folio_page(folio, 0);
+	unsigned long end = start + folio_vmemmap_size(folio);
 	struct vmemmap_remap_walk walk = {
 		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
 	};
 
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
+
+	if (!vmemmap_optimizable_order(folio_order(folio)))
+		return -EOPNOTSUPP;
+
+	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid))
+		return -ENOMEM;
+
 	ret = vmemmap_remap_range(start, end, &walk);
 	if (!ret || !walk.nr_walked)
 		return ret;
@@ -488,16 +504,12 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    struct list_head *vmemmap_pages,
 					    unsigned long flags)
 {
-	unsigned long vmemmap_start, vmemmap_end;
-	int nid, ret = 0;
+	int ret;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
-	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio), folio);
 
 	if (!vmemmap_should_optimize_folio(h, folio))
-		return ret;
-
-	nid = folio_nid(folio);
+		return 0;
 
 	/*
 	 * Very Subtle
@@ -511,23 +523,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 	 * the TLB and clear the flag below.
 	 */
 	folio_set_hugetlb_vmemmap_optimized(folio);
-
-	if (alloc_vmemmap_page_list(vmemmap_pages, VMEMMAP_OPTIMIZATION_PAGES, nid)) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	vmemmap_start	= (unsigned long)&folio->page;
-	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
-
-	/*
-	 * Remap the vmemmap virtual address range [@vmemmap_start, @vmemmap_end).
-	 * Add pages previously mapping the range to vmemmap_pages list so that
-	 * they can be freed by the caller.
-	 */
-	ret = vmemmap_remap_free(vmemmap_start, vmemmap_end,
-				 vmemmap_pages, flags);
-out:
+	ret = vmemmap_optimize_folio(folio, vmemmap_pages, flags);
 	if (ret)
 		folio_clear_hugetlb_vmemmap_optimized(folio);
 
-- 
2.54.0


