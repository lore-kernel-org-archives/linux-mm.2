Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E8B8606A33B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 03:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=j4wKIRiD
Received: by kanga.kvack.org (Postfix)
	id 3F92F6B05B7; Sun,  1 Nov 2026 22:26:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359416B05B8; Sun,  1 Nov 2026 22:26:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FC726B05B9; Sun,  1 Nov 2026 22:26:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDFDA6B05B7
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 22:26:44 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DF5D40AE7
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:44 +0000 (UTC)
X-FDA: 85388741928.23.DA4D9FA
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf19.hostedemail.com (Postfix) with ESMTP id 34DE11A0002
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:26:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=j4wKIRiD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793590002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfJbCHPkvsGDzoNKnYVR1vPpM/uRL1Mk1pmv5Z8laks=;
	b=ddULj9ummWEVWX1Ha2id7r/roeVtfV5YCh9yWrQK5ZDJXyKOBPNlnvjtrUH7b9ToqcehIg
	Ao30GngFgpHsTsjMa0dn47WvddhBu7LhWApMl3zpsJLFVjluwxtmIjQr+XAbRBfxWGbvX/
	lRONTPbw9z0YTJWvTZkEhbXC2dtgaGk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=j4wKIRiD;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793590002;
	b=PXpWZfn0dqn7GII69H6DI7FxuTV67defAEyF7X4raNmGyinnlZ/ZtYis7VMiLWOUGRK4F9
	dYsiQlEAYaMN5umVpZnhLXokQJANEXhLeUJH+qpopJYe/9I5IK6a4EGmyfVVpOkXKTiSKh
	SuiDfmw2U1Iocl8tPzSzPq45MV0DftA=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-cd6028ff33fso940829a12.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 19:26:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793590001; x=1794194801; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yfJbCHPkvsGDzoNKnYVR1vPpM/uRL1Mk1pmv5Z8laks=;
        b=j4wKIRiDonCN+IYgJgBsMrV3Zy06qcIhsH1IeeqN/jzPQO5wr+qIUBYl5BE0YmNqk/
         z1xpvLeGXubwKlwVAX3V9jSXfHbVkHvDFfxRdC4sAU465DTgKHgTVFSK5Vl+gnMMqqQ3
         hdmuevqVg5QM3F+/RLQJJ5gL4KGPbSJJ3B+HOyz/5LvG0521TIB3WU1UytsFU1RnYK1P
         +RteKMfzeVRbQZ/4RZWvobyuzgSnW9D8cQsXSCGJR9zhjnPMF+oLJ0Y0xfyWXVg4p9ot
         g2NmP98Uoy4UlcqXbeFYHB6yRWtkDNhqSGbM1n3m2X9k7fMYTIJnwqmAJRwyJSPRJgL0
         2ynA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793590001; x=1794194801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=yfJbCHPkvsGDzoNKnYVR1vPpM/uRL1Mk1pmv5Z8laks=;
        b=v3UCX6UVtXK8vsN0lTqUpcwYNYVRa4W0nz67jvk/y0aXMqxfD8zAKMS926ZtJHBScn
         TwssjZRpoj+NfXZt7sAflILGwwLG6sZ1zKLnL2oBJ+mz9NIJuekLEFv7ufqA9zqAD0wQ
         ZwvnvzCgqATTxafYvtUXadZRz/ek3hsNMzM1pRelwXNbrQZwDotCukaWYjaXyqkYfLLl
         b5ZuwsXwGri9x0jn3LpeUzzd1VmfFOzogfYpuenJcqZjeft/LQXye23mgXMMNt8JQmac
         H9pW0b0p6RTNIZLUSEYQec/xFRfQoLsLprlRcM88SZGq/uXusOYXX3563xo9GJTRrPjc
         G8kw==
X-Forwarded-Encrypted: i=1; AKwUvByjXJVFflJK2CQO67czk2Ios6+Jm+4n4fGSRDt5bkHbhOMvAFV0BJG6CIKGFc2LPZtGbYXMbuHg2w==@kvack.org
X-Gm-Message-State: APuU4Z9RWdmJVJuHfwShmqJV5HgSCci7PP5dQTGQDNONHeLECWxW8eHe
	AADjleECw4vEGrjeafwvIi4bdwZfjefgVMSLiSxL1JsCtcHYCXWhmLMs3f1rJ9HjpLE=
X-Gm-Gg: AYBFou2arheSxaVinEz5GJvxKD4lijIRr5QZxT2rptFdUdilr8uWM9OBqKd2tgkflBk
	MepeeKeEcWfmIu0PgW73ox4cGrG2u0FhdJd7LLcf7xgxXZJO0PZBsHTHd9LpHHPEWK6AoqB4lx5
	s84//4puo24vdRMq8RRVnaLPy2NZDgFrOSyZ8DPU1X4kEdIUwJzXA4eyX4ZOixnK2EgzsMCklRv
	nDPiJye6YTTkpWh+Fn4bJ2KANSyrncUKQJg/UjAMeAO1WCFaxmyFoVPvwhkH9hOjF7CH0DbCYWH
	paLZBRiolsJqY91c7zuY8/Tl+2qxpaE8+9Eu9pbEJ2qSHt1a37bEuJCVxUzs/EjC6ESuNtPPa4F
	nS81oFESF5N0mYBee4+V1er3z+AxKF+2Ahr7yyHfJkgU5RB3M0m7H0y+ZY3fHQ+/Ue9JxxTmie7
	g/9ZhSyg5k8CQalxFB7NhSmZECWN4DTeg+gINcxmRUl8STj1M2wGB+gGaDSrWTYXKbKhtQl/jau
	vaN1RfIbhBWpG0mC6hI/YhThr2a2wtkF+s+mciR024MtIGyeITn4tSyuKvTD5WVwYRVaP9Y3hX3
	VMshfQm4LBHeY1ySaoeotzkUy0x2bpI7z2zD0BCIqN67RVKj/dg=
X-Received: by 2002:a17:90b:264c:b0:3a7:d2b5:2e99 with SMTP id 98e67ed59e1d1-3ae8970fd76mr6501604a91.20.1793590000904;
        Sun, 01 Nov 2026 19:26:40 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae845984absm12303317a91.10.2026.11.01.19.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 19:26:40 -0800 (PST)
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
Subject: [PATCH v2 05/12] mm: hugetlb_vmemmap: unify writable vmemmap page preparation
Date: Mon,  2 Nov 2026 11:25:18 +0800
Message-ID: <20261102032525.3597743-6-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261102032525.3597743-1-songmuchun@bytedance.com>
References: <20261102032525.3597743-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34DE11A0002
X-Stat-Signature: 9iqp9ig98pgqhhkog3hztikajdi18etn
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793590002-22712
X-HE-Meta: U2FsdGVkX1+w5UkojesgisI+gPQIs2ASafeuLqFJcmy+HqupyJrAqZZQAUQM31CHScGUGwz8n2nVzmfSzhlXu2mfxFI7uD5/EHms44eTDO7BRbe1jtyQIIdnm8i2QMjOrNEB5mF78mdLZC/Z91nEeeR+8useybU2viJpVkzE6lhqnK217yzgXPOHxsauZtStjsEHaP4zZUt5y62tBBoMkc8vZApF2LVUJlIT29gP/6nF7PX4nSNPlrDCPlnDKFIP10Q/1QI7xlUVGwAYaTu0I+kf3has17X835Pox1BzfYO6bKf1a0dQn3KEWrUXFw6VuGlFNcyJ018Ul3kMgEUVGI8DT88XP+06D0zJDDUUWRvVSyAVOl8YiqjjATV9oBOzAyYmJ+H1GGSLpnCTm1L0nrMDghLWAnxK3OfjvRkvlgGwwx+MohI/zTj9oVYtQgn+w0hQIAuGxzEUwxDtsDbGLsHEVWjASXgzzsqg/EHtN8b2Uk4SOemsyuIqUiSp2Rb36wdSz/rTE9czU1jx7i6kNSYpN6DygbIIng7uMadU3+jAMDixQsGZMZQPy4L949g6QnzxG2awRyTSm/JvrhUHPP2fNkNX1lrCusxWiT/oDqOAuqY9YZbjIAvtCtX7rOh7lq+HrGWPPi3v4sOjpyVf7kyjUx2ZOY/ydnWm6EgRiTId1LRlw8IKemU+Y5fOXPk0bBS0sd9BF3tzoO+sGpQnDHmmgqBEMXpBOPSNrklxQs2MRLJ+jGyuElAj5trWf46lhNV54nNQFIE0q+ay3/WyfxTkk0uJ8WdHZNuz2FKNMIrscNKPHKvczgCIWQk33SFw0RePFQZNDfgTCLv1ysIVOK55oFi990nM73zPCVJHGBjFCeSYWHYfFACpJnpIi3QRqxCesexGr/us4SQpXRu0ZJIzonznlUTeu8+bN4BT25IGbRE81hbignYCIviJZsw+wztPFV/qL4udWJi4p4Z
 63HBasMS
 gA/bwt8t9O+K0PTZZmpm24iKvmZRO7AMtUArDGSkcH5ezVNd38c8wENw8Mu8x2Ks+GHlkoAiRuJQA8T1EbrvIXc/LalbrAznQF8UDK99adGsRXhfLc0uJaNr+b6vJ1WspexTKOPFX4lueYS869trDHgbUHkWF7ZJrprSzff59Dw+2NtFP1H8C/vl5BQXxHSbSEfPsW2cVA4Hj3qElsfRxtg2hbXST5zY20bt0PDvalkU7L8zkfVmF39W76JI7wh4OA0u+0sIOTEpZ9opYZ5mcnwQLo4uPUfu0zFD0v+6FNxeNvT7TbNgO93kN/xnAKTDqoYp9puXRx9rkyqpRN5Bm23NKdfOz+AWVWgNx6RKj35a/bPAt+Lyq04ai1Bd2sxWaFn37vIBnRTG3YnWXtSHY8EfyvlCsnhDCWJINbjsD87oRU+964SzavRa2oxrwqb06rbhZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Installing a writable vmemmap page requires consuming a replacement page,
copying the current contents into it and making the copy visible before
publishing the new mapping.  HVO currently splits this sequence between
the page-table walker and its caller depending on the remap path.

Centralize the sequence in the walker so all writable replacements follow
the same copy-and-publish protocol.  This keeps page preparation with the
mapping update and removes path-specific handling from higher-level HVO
code.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
---
v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
- Replace page_to_virt() with page_address()
---
 mm/hugetlb_vmemmap.c | 40 +++++++++++++++++-----------------------
 1 file changed, 17 insertions(+), 23 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 4b20a8efc067..c9635679a36d 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -199,6 +199,20 @@ static void free_vmemmap_page_list(struct list_head *list)
 		free_vmemmap_page(page);
 }
 
+static struct page *vmemmap_dup_page_from_list(const struct page *src,
+					       struct list_head *vmemmap_pages)
+{
+	struct page *dst = list_first_entry(vmemmap_pages, struct page, lru);
+
+	list_del(&dst->lru);
+	copy_page(page_address(dst), page_address(src));
+
+	/* Ensure updates to @dst page are visible before set_pte_at(). */
+	smp_wmb();
+
+	return dst;
+}
+
 static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 			      struct vmemmap_remap_walk *walk)
 {
@@ -211,16 +225,7 @@ static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
 
 		VM_WARN_ON_ONCE(!PageHead((const struct page *)addr));
 
-		head = list_first_entry(walk->vmemmap_pages, struct page, lru);
-		list_del(&head->lru);
-
-		/*
-		 * Makes sure that preceding stores to the page contents from
-		 * vmemmap_remap_free() become visible before the set_pte_at()
-		 * write.
-		 */
-		smp_wmb();
-
+		head = vmemmap_dup_page_from_list(page, walk->vmemmap_pages);
 		entry = mk_pte(head, PAGE_KERNEL);
 	} else {
 		VM_WARN_ON_ONCE(!PageTail((const struct page *)addr));
@@ -253,15 +258,7 @@ static void vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 
 	VM_WARN_ON_ONCE(PageHead((const struct page *)addr));
 
-	dst = list_first_entry(walk->vmemmap_pages, struct page, lru);
-	list_del(&dst->lru);
-	copy_page(page_to_virt(dst), page_to_virt(src));
-
-	/*
-	 * Makes sure that preceding stores to the page contents become visible
-	 * before the set_pte_at() write.
-	 */
-	smp_wmb();
+	dst = vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
 	set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
 }
 
@@ -499,7 +496,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 					    unsigned long flags)
 {
 	unsigned long vmemmap_start, vmemmap_end;
-	struct page *vmemmap_head, *vmemmap_tail;
+	struct page *vmemmap_tail;
 	int nid, ret = 0;
 
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_hugetlb(folio), folio);
@@ -531,9 +528,6 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
 		goto out;
 	}
 
-	vmemmap_head = list_first_entry(vmemmap_pages, struct page, lru);
-	copy_page(page_to_virt(vmemmap_head), folio);
-
 	vmemmap_start	= (unsigned long)&folio->page;
 	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
 
-- 
2.54.0


