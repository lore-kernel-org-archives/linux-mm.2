Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51D4F60A2601
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Xuvn2z+x
Received: by kanga.kvack.org (Postfix)
	id 692096B05BD; Sun,  1 Nov 2026 22:27:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669646B05BE; Sun,  1 Nov 2026 22:27:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557DA6B05BF; Sun,  1 Nov 2026 22:27:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 228026B05BD
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:27:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98806C0B70
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:59 +0000 (UTC)
X-FDA: 85388742558.13.FEA181C
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id C496D1A0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Xuvn2z+x;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dzhdjZ4hyQHE1HRM5dLGCKz9meGVOFWIYuM30E0c+fs=;
	b=defl8vnKJWh4dSnJC0TqBAAEE8xZoIxlHvedK2M4eZyFkqizxvoNy0fxTMKd4YdR1PfcDm
	uxsJPo8LBVSESLBvTB0sU3dWEV3ZXTMjQ65BfawdOfkriNjrUTa6kViM5NAKe6SG8KOumm
	nRFlFVN/ea+VLkwLDRnUW34VWykhwtU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Xuvn2z+x;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590017;
	b=A5/7k7ZsNg15Vb+q+824C84CKvATuquUCx5+2Q2x+Nz0serna44XcDddpPhoFGgogkLkEZ
	w/1AYy+y35eq+8VyoGyYhl9bxJh7wpqIy0LmNZYfdnxW6yfGRbSEFr/7kpeW9W9LPUimAY
	FusSYO0eVasKEuZZ12FOvXvvZPbnTCU=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3ae486f8a27so1386159a91.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793590017; x=1794194817; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dzhdjZ4hyQHE1HRM5dLGCKz9meGVOFWIYuM30E0c+fs=;
        b=Xuvn2z+x5BIJH+mPR/5h8N9lY2OOHlx/+a+loED+rrtocYGKSxNB/x7L1O7//e5jtC
         rZ3sAulG3lLaoCuY2bjNxn/huco1La9TbRwfA7E1vu854ffodokW2ZHaVjAN8IJbgwwI
         /P4gMjvyxAIjVgBAkxYNFgobpOZ9F4x8VE+S2XRJk3RKUFjd14Ze4WyBDlHdjym0gq/c
         wy0wea+405sAFvCO/TxJMnAu/tv75exSYAmq2SmL8TDyHLjFgj9Afs2yP0aVJCWZiGAM
         meAetu9AXYFRVRttvaRduJGl4HgTbrUUc17bnT+ceIG1UGWKXlTVHpQhVIM9I6AFv9Ys
         /BIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590017; x=1794194817;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dzhdjZ4hyQHE1HRM5dLGCKz9meGVOFWIYuM30E0c+fs=;
        b=1u58LRI/tU7b/H6+vojpQ7MSdZWHqaPlMewypT9iP/iy7ZELi/KK3VROv1JbGMME/r
         shwuMQWRHng6uPhOIGvcv1g3uGrXwKyN4UkXGEtodLxyLaf/0sZ1KgY79o16OGgqBikb
         dcKjZhDiEWxO9SLzaPe0fbNJDrX28osURJanP+p3jkzRv7bJEHKXMOsvIjlaC4cUvBGN
         /aSRGJv1j/+7kGr6t1zG9V03mw4of8P2SzGjeQtmwWVulsCw78uihtFHF1mKqjSJGkXC
         gXiXG3ynIzhDDTH9nGRjdVJYYdf94P0XOQExAMpJ0HWQbGgsK6Fg9tfI0cfAXIENqPow
         g1KA==
X-Forwarded-Encrypted: i=1; AKwUvBzFPFM0RHs22rO9DpqxFDUd+4hSa2+c7W4vEb8Nk9apBE261keUUvN53g9m+J4kzVQiULcSzd7FBA==@kvack.org
X-Gm-Message-State: APuU4Z8w5qWsV2nhsg8dJ2XGvGBy7uJsOSGHzA2C8gPY0RdSAyAim2IZ
	ZAjHUwWOc2ITIBhC6YpgmEZWsYuJ4dUwiPWKADXGa/tc1b+Bmh74pkVJfZNhBE6qaww=
X-Gm-Gg: AYBFou0qC/jlx3iNDlrdxXaQuYC29N+UXXTMHsRk6o3nGVSD9JtA23vSHx+Io34OmmK
	mBNop1uSOrXBC3ny/EFzn3JeRQ8hKLZs60pGIdq1emCUysNVQwiGzDJpnNlBEuCZxHITzwJrvbB
	uPF/3m7BGxny/PkUlLD60isDPJbePiR9lSkTwelDuLunqJvHpj6kEPylh0WlPAJJ3Jyk6PTr9kM
	87WWeEo0KGfCPrU8KjCGaUQI3UHHrDus4wMEPq5R+fBwQXl7ccs2Mvbe7BfrkvtcGwUpZOz8rIS
	AaIvUSwTuFVfpwW41JCK8obwjzo4D4vSAaYSfAYV+qfIrolcwWWpGsn+HTZP6G24QPp+RVgSKuY
	3DzVbWacdPy8QyoRmiml+M//bGZBnNUNowU5H2nfWPb+IVZYDHwcmWAfPsabN+0aZVz2dv94zg/
	9fGCaefw27i9vy22jfvZwccA7BU8KL4AGMINS4DzZggzCM9Mtx7sqiut+jMJtKgwvoqB3kfntzH
	+Q81t3ir3WpE4mKr9fE4oQ/Wm5HLg72EO1x186zx9Su8VOVjoVxX3krT3mnsdLjZLTDycoOTWt/
	H+0xLfK/B1NMdPXszygUohayKhXrZHji6Qe2PTSaksbiVdyK9g==
X-Received: by 2002:a17:90b:2741:b0:3a0:e4ce:31fd with SMTP id 98e67ed59e1d1-3ae896f8304mr7617976a91.10.1793590016392;
        Sun, 01 Nov 2026 19:26:56 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:55 -0800 (PST)
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
Subject: [PATCH v2 09/12] mm: hugetlb_vmemmap: make vmemmap optimization folio-oriented
Date: Mon,  2 Nov 2026 11:25:22 +0800
Message-ID: <20261102032525.3597743-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C496D1A0002
X-Stat-Signature: k4q4bhr1m7jjaa85m4r5phpr8mbiznu4
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793590017-144439
X-HE-Meta: U2FsdGVkX19sryON3OAn2NqWp9GHsH7VwDfWVq5le3TOfZbdEf7n3rWQkh+VIDvld60XNsU1iElC0MKUdUcglbtAB531O+KdQi6JUVrcBwrw1jiZdB+Er99TmpVGIjN53h7vfcKCrmOeP0hrMQgIb2CPYua78q9NTjb7Qt3XGcX/nlEcqQ88gvX1tdwKLcm5V2iULdYwbYqkCk3tp632H0VjRHxW3GrZ1ksQy0rJkDpaJI+rBn0yD6ioH1wVsQNnXqfeUDkFgjmQ7rBirzPcoABbh4ksQRNLIxR9l536pibfk/8BQWmnoOTQsJMK/PpIUoO/56aYIXBB/Jo+F8mhH885skoiu3plEgL1p8f2OufYRJwr623ftcI2MNiElP3zynuVtVv5CArG/VGhvAiY4CDwdUda+mT78CiuiAloadtlSl1rrr8awNF2I2vDjvp+P7+rby8UF+EET9ENlwchBxErtj/SGUa+oWvRgC3lESH3XwMLufjdzHXbFflOwY3qMesJEOFM7K3t1wkEy1ScFh+wITuUMJqg2+zXjybBVxtmCvOTe2j/7fmAkFuWHjkNGxs9ioClkobe3J92dZGAMF/ioU4X6FTfyPVjWO1PchLpN77R4S8b5l36zcJBe5RhMsjmllpA+j/uoVf5huBs1P26D/69lNPLg+/T/Kp+XxNJihFDx028E4BniSfj+36+CQSLiHzkFApCwtkPv1gqWFRNbjyuYipL/kxBwn0Oz5ZgdR7Vsqxbk3Kv3gGcHvs5GVZJC/9LEnFbitJWx2Gk6l1IWBZ2fwCQbjgoSssQsO9NYsUy+qRn5ZAq5qGYymHZTtuM9A5c7nHAEgM9IUVU+3j/qKns6aVczXfJH16hJ5escqwQZGYTHDWhWLbO5w5fcD+XfKA6oBEbbh/LDbNrXJ0Q2R11SVxgyfBEYEjWq8CgnMwY8ame5FcTpbTgB0oFjc5oIctQ9anCVHErnwI
 vTk+mxt+
 o2bFHuKNpKn0B33CO2LT2+QwgvbAy7JIB0KRDiJSFKkyWaOiZ+DJrDf4PVXg/VxtgvpyYv+nnp9q9RYA8xRP06mMk/egwLO0lKAohmto5huBnq6LYphFOjDPTpwPCaUItm3Ttn/HY5UwhgqYJ5T0Xs0Wt1VLAztAyyuGB0FHlKPTIT0Xz4Vc1RViKFXkfjMHWttC1RMYvT0wxKFPd9kR+OQJrZv0/dhTGrDUN6gtYPYz2WfKBbt48BSzzYAFgreJ7/+GJRvwGkYApats0Q21nZIt8JhvEOu5CZ8Aud1//h7jmZJM96ceWAQk/RPbAnOvplkg6U29s9mbWnaOBlwNHc/oXV7qzAclp3ZgzndEUO1fEDXLHBJwVWPQzE6Mf0t45Weh1LV5wCL21/DAbO2uOwHjakDfMJGZ9bsMBkHzZlDbFwjxB+7Yzan+KTBeomVGRXezdLGcm45aRbtI=
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
---
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 67 ++++++++++++++++++++------------------------
 1 file changed, 31 insertions(+), 36 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 244cd8a0c78a..14390ee59ba2 100644
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
@@ -302,29 +307,39 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
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
-			      struct list_head *vmemmap_pages,
-			      unsigned long flags)
+static int vmemmap_optimize_folio(const struct folio *folio,
+		struct list_head *vmemmap_pages, unsigned long flags)
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
@@ -489,16 +504,12 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
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
@@ -512,23 +523,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
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


