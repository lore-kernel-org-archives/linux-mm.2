Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2E0ECD6FC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 00:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE986B008C; Wed, 11 Feb 2026 19:37:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 958EC6B0092; Wed, 11 Feb 2026 19:37:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 844BA6B0093; Wed, 11 Feb 2026 19:37:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75C566B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 19:37:34 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24BBAD6E0D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:34 +0000 (UTC)
X-FDA: 84433941228.09.5E4904A
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F21D14000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 00:37:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ivmliXvB;
	spf=pass (imf09.hostedemail.com: domain of 3yyCNaQsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3yyCNaQsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770856652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TcMLX2Xy1jOIpMds+I1gs4yK1mnZMXU9mzbbwG+o564=;
	b=dn6XaTR2yc2yNi30F3FsjAfcLLo3nI+fh4SO/uyHDZhevDHLMsUoqNwnwy+Bv/ekQRW2LU
	9IGhJi8L77/ES60PWJ/Hisl0kvWPE8J4tZUbQBUhRsf7huQjQWREsH03GbTotVfpuSDJqt
	h43SZF0TxG+OSVA3CVyd0PKi+cCEY3I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ivmliXvB;
	spf=pass (imf09.hostedemail.com: domain of 3yyCNaQsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3yyCNaQsKCJQy082F92MHB44CC492.0CA96BIL-AA8Jy08.CF4@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770856652; a=rsa-sha256;
	cv=none;
	b=jmxb2MDeGtvLGS+VJqqPvoeSE6+cxFXi0zB7/ju1uP3siawF8c7Z5HFVsJr/IhylVTz6uK
	FI/UMjaoaXbtLtrNKM/UlBt29VbyyX3KH0UxOhsPyZAgxSJHW7whwPdv195z4fmQxa7uHy
	wYOSBcgaHWyt2Rva7tPMNlvMqDQswAI=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c6df833e1efso6374010a12.2
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 16:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770856651; x=1771461451; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TcMLX2Xy1jOIpMds+I1gs4yK1mnZMXU9mzbbwG+o564=;
        b=ivmliXvBP97mylHOs84WHXM8iReezQFVqnziG7bFgsvL21SFi5GQABIvGnnVMFenDk
         0EFWY/SpOUd8cBL0QS9TYxw2WGlhKwIB4iq+/k6onnYhe4Ka5imVGNucPrW7DpUaGs+S
         W0MmnSwDjl91R45nAsLb9ZCDFe37vHKHU1JNBGLeriH3ON4MJY+yP5udPuHCaIyxRsZv
         iPc6Kw8VtkHgsi4ZXYkHF5dGPvGcnPKRYoLlDzt2FX77ay8ViGHXMlq/GZH1P8tISWIv
         xzj3OkoNotpCzaendoNVlC3aawi6lQgqNEJ+bkQBU4IUkYu7KNDw1M1yVmqXBPJ26o1Y
         ytkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770856651; x=1771461451;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TcMLX2Xy1jOIpMds+I1gs4yK1mnZMXU9mzbbwG+o564=;
        b=J/i6WWdS5EyqE6vCPCzcmh8IoIZsj8GEI84tnOgO+VI8zuW1zpeg/rbVnkOdyTxvKo
         vFRRz/Ic1YkehcGC9V3pPXC93y8ipLJASpIQM9qbi4vcxqQv/2QS3ef/G/YbnEXyEzwK
         eINCoy+Gd/mxSQQpv04W+0IGXmqYvlfdTaWjForA4URLUjJcXrhj5S5Ji10F8BLvfa6B
         bXbsp97U3VRBCyTiIAfmn1+YRcB1CzDHEpIgGL13m9zg9hwzFjNRBQoHmQvqNrNBTC9r
         LNTBDpv0Quty4A2VthXVfYRsA0OA8xwVVdSea7lBQY1F5hri9PjuCgswMj+dYwDdRVyT
         ZsYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrLiQ2j+OqPO3v9DdseUQ8Uiqd9SCGD4IzDrFtcT/DCF+pWlXQSCNiW1j/IRAXlPzYlWmp1K3fWg==@kvack.org
X-Gm-Message-State: AOJu0YzpenYU0MKSIrEdS44cGct5UaLngQun3yGuis1mVtWsC+q8SBqk
	Iw8CdhBsjtrWAPsYbq9Hg/a3WbKseMrIhWlWWYOW5dYtsXu4b2OmiCDXOCxrudY/m3Se72lRlqd
	u14rosAzw5SNnCmADdmsdfgmajg==
X-Received: from pfnz7.prod.google.com ([2002:aa7:85c7:0:b0:824:9b2f:783])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:4fc3:b0:81f:4d18:65c4 with SMTP id d2e1a72fcca58-824b05ce226mr768557b3a.59.1770856651067;
 Wed, 11 Feb 2026 16:37:31 -0800 (PST)
Date: Wed, 11 Feb 2026 16:37:14 -0800
In-Reply-To: <cover.1770854662.git.ackerleytng@google.com>
Mime-Version: 1.0
References: <cover.1770854662.git.ackerleytng@google.com>
X-Mailer: git-send-email 2.53.0.310.g728cabbaf7-goog
Message-ID: <67a62716952c806c2a512e98bcac1f5224ada324.1770854662.git.ackerleytng@google.com>
Subject: [RFC PATCH v1 3/7] mm: hugetlb: Move mpol interpretation out of dequeue_hugetlb_folio_vma()
From: Ackerley Tng <ackerleytng@google.com>
To: akpm@linux-foundation.org, dan.j.williams@intel.com, david@kernel.org, 
	fvdl@google.com, hannes@cmpxchg.org, jgg@nvidia.com, jiaqiyan@google.com, 
	jthoughton@google.com, kalyazin@amazon.com, mhocko@kernel.org, 
	michael.roth@amd.com, muchun.song@linux.dev, osalvador@suse.de, 
	pasha.tatashin@soleen.com, pbonzini@redhat.com, peterx@redhat.com, 
	pratyush@kernel.org, rick.p.edgecombe@intel.com, rientjes@google.com, 
	roman.gushchin@linux.dev, seanjc@google.com, shakeel.butt@linux.dev, 
	shivankg@amd.com, vannapurve@google.com, yan.y.zhao@intel.com
Cc: ackerleytng@google.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F21D14000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 8wumatsh34uhw7e5qtcfne3rbsth6ib3
X-HE-Tag: 1770856652-718786
X-HE-Meta: U2FsdGVkX193BQOGdBr0TzBA881aLJrfb9kIogk7Hb5J590XVL7/mf7GtEIZYLEQ7vdzbKT1aMvr8LgaCzmzzySFhCoHqKEn+SUwnBhemqdKIeSAX3Gjv4aotUJSy/haGPUgITe+0qqKcssqsWAP6qWBfKIsZX2DcT3BiLwLpNtTDyCgi30feEaN8sYDSzJCqu+M8IYSHVkvdL9exEXCWQayo3RVrAYbMbgxZ9RbV5/zvVOU412vySr3/3eoa7RrpfbCsjrZl9CJu97WqvKB2YL+c1w+aKoo/0NyUBQv2Tj1M/rQPkN94F6IZL4EmWpob630mcnbX5qAdJJdbBq1W8W/u9rhGT98xQhujyRXNUxSmL4HW35gyUrFgtmKMEu2rxcNmuC+XfguMvZ7WP1SeLIp9xX72e0znFmeXbCSTItxAlKLnGhg7SMOr12WHwFHxn7cUcIERCkyuQ5VmyZbZ3PSn/CtFKRKJCXQltQDk0no2NR+LjjYzu+L1XxCPrt37qY1AE+H4KMJR2s1+6s6ikQRZiLLKbnL/JunaiMWPYgPEtzO7DRU6wZAEnh/nHOqX6xQa37Liy5UzI9+3fKDBbDNFOiJZCHUiu3J/UZaMKIL+qsHW9QudHIlGNB+o9COak5WIbyTVZ1TM4YIxyGMxP3T1gEIMkAlCyCppP9RqToPMdQZt34iXw5WqZ0LtdyXm30Uf+pWRjKnUf3BSCb48Wp/K98mvT2TZLQx0Vp4ntnrswRk25QT1qw4KUpADMf4PAsSnjO3o9ilKaCNdkEc45tkEIi9m6emQFjaFIFRj5VN3ulY08PJTsSQ2US+KgaSrDOYNoo5wfeR0RX6bxpYy2lTR1nSHQdRLEBwON+Naa9AasIoLniITtXWDyvEuOA/0hxSxmu+hV9vMkDidvmkFRtuy2Kqrts7Ux16FcJtQXZlncBHPqda/KJiMOg71DQM6vgFun0qHk6kbxMjHI+
 LAXG3zQE
 RpQFUNgD+E3DxpioOR+PTd+mc6FAXE/kePhUNBx6OEOXB3yh9WwNJzQi6C0GFGAtsGzcjBHBMwnNdGM7y2mnQjc0/KlwB7FfEkrwBHfz3ksA5JL7NtGLjDEddjetbv1mmSRyjlUFjWu/odNmkKlvkdNTC0CJyBmcqm32ITcC7ZLgyIOdfmd4rqZVnoawWp3p7R0IwXDDnDL3LSc7oPwjkwqnRriG+DtpNYDB6jq85UjeW28iiQTW54egzVa9UQHBWNTu3dJSfhXbA07/lEwKCrH0pv/+M0zOpkPkSTbp6jVkLaFhGi0i5r0JCH+qvY/Xi1HPJVNmfUvG7jkc3Wp9FY+0wvY3l+V5QK2vlD5v7AJxry02HBCLsIZ6hodhn9slwyHN8+E2sPTUXjga0abmVYtkwtv5Dt7agCV0AjEArWSvw07DJ7oqrCOYamfjjDq5Cb+cnu0l0/3zzT0XEK+vZ1OWJOAayX9Pzho9HlCgxFxdgepqeHf5rh8GkMB68dQYoD42MRFiYvWZqVcsxsZryKQgpCqmg7n95Cn3gbcM+0kcml94HJ+26hr6b7xBmXPaluHcfeI789Hs3g0MdxyLvaHzN6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move memory policy interpretation out of dequeue_hugetlb_folio_vma() and
into alloc_hugetlb_folio() to separate reading and interpretation of memory
policy from actual allocation.

Also rename dequeue_hugetlb_folio_vma() to
dequeue_hugetlb_folio_with_mpol() to remove association with vma and to
align with alloc_buddy_hugetlb_folio_with_mpol().

This will later allow memory policy to be interpreted outside of the
process of allocating a hugetlb folio entirely. This opens doors for other
callers of the HugeTLB folio allocation function, such as guest_memfd,
where memory may not always be mapped and hence may not have an associated
vma.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index aaa23d995b65c..74b5136fdeb54 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1378,18 +1378,11 @@ static unsigned long available_huge_pages(struct hstate *h)
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
-static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
-				struct vm_area_struct *vma,
-				unsigned long address)
+static struct folio *dequeue_hugetlb_folio_with_mpol(struct hstate *h,
+		struct mempolicy *mpol, int nid, nodemask_t *nodemask)
 {
 	struct folio *folio = NULL;
-	struct mempolicy *mpol;
-	gfp_t gfp_mask;
-	nodemask_t *nodemask;
-	int nid;
-
-	gfp_mask = htlb_alloc_mask(h);
-	nid = huge_node(vma, address, gfp_mask, &mpol, &nodemask);
+	gfp_t gfp_mask = htlb_alloc_mask(h);
 
 	if (mpol_is_preferred_many(mpol)) {
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
@@ -1403,7 +1396,6 @@ static struct folio *dequeue_hugetlb_folio_vma(struct hstate *h,
 		folio = dequeue_hugetlb_folio_nodemask(h, gfp_mask,
 							nid, nodemask);
 
-	mpol_cond_put(mpol);
 	return folio;
 }
 
@@ -2889,6 +2881,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	int ret, idx;
 	struct hugetlb_cgroup *h_cg = NULL;
 	gfp_t gfp = htlb_alloc_mask(h);
+	struct mempolicy *mpol;
+	nodemask_t *nodemask;
+	int nid;
 
 	idx = hstate_index(h);
 
@@ -2949,6 +2944,9 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 
 	spin_lock_irq(&hugetlb_lock);
 
+	/* Takes reference on mpol. */
+	nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
+
 	/*
 	 * gbl_chg == 0 indicates a reservation exists for the allocation - so
 	 * try dequeuing a page. If there are available_huge_pages(), try using
@@ -2956,25 +2954,23 @@ struct folio *alloc_hugetlb_folio(struct vm_area_struct *vma,
 	 */
 	folio = NULL;
 	if (!gbl_chg || available_huge_pages(h))
-		folio = dequeue_hugetlb_folio_vma(h, vma, addr);
+		folio = dequeue_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
 
 	if (!folio) {
-		struct mempolicy *mpol;
-		nodemask_t *nodemask;
-		int nid;
-
 		spin_unlock_irq(&hugetlb_lock);
-		nid = huge_node(vma, addr, gfp, &mpol, &nodemask);
 		folio = alloc_buddy_hugetlb_folio_with_mpol(h, mpol, nid, nodemask);
-		mpol_cond_put(mpol);
-		if (!folio)
+		if (!folio) {
+			mpol_cond_put(mpol);
 			goto out_uncharge_cgroup;
+		}
 		spin_lock_irq(&hugetlb_lock);
 		list_add(&folio->lru, &h->hugepage_activelist);
 		folio_ref_unfreeze(folio, 1);
 		/* Fall through */
 	}
 
+	mpol_cond_put(mpol);
+
 	/*
 	 * Either dequeued or buddy-allocated folio needs to add special
 	 * mark to the folio when it consumes a global reservation.
-- 
2.53.0.310.g728cabbaf7-goog


