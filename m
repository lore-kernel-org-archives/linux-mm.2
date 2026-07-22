Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E067DC531C7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 21:44:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A80D96B00AE; Wed, 22 Jul 2026 17:44:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A31826B00B0; Wed, 22 Jul 2026 17:44:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883DB6B00B1; Wed, 22 Jul 2026 17:44:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE836B00AE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:44:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 486A5120162
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:51 +0000 (UTC)
X-FDA: 85017742782.01.30A4504
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf18.hostedemail.com (Postfix) with ESMTP id 47B4F1C0004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 21:44:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RZb8QqNo;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784756689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmjPr4ajWT+pNjYdNv6NRB3T+nqQJNeM5CFnnbec2W4=;
	b=yKnVolnPEE0QylM7ypyvjqZQ40Ue5TVc36JT035KGTQgCGg0ufjDIwYOirOS9oR68vda+T
	kLryQVbf83m/E3gY2o1wByOSoCt5S6WXeChZ69bQbsB8ufbVr3VF8xcdUsoufKHN+32L4W
	miXJfyc3miD6XSMMOCBMndfjiQYiUGk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784756689;
	b=VVfC0FDBXI7Pk5wnijisQYV160/11Q1jhWxPEMRyNbsIAIeCvTCvpJJo+gZ3ZtCk1OZJ3H
	hZ9GWxiOSEYx8nAEhH4jinL/0HOiM6FQRAcCgMx6o1Vk8t8Ywmcj2F94MvYO4LmiKJQG2X
	4C4tBQotMBgki3dHBMoHpmFRVn5msuI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RZb8QqNo;
	spf=pass (imf18.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8486672f03cso12980952b3a.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784756688; x=1785361488; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JmjPr4ajWT+pNjYdNv6NRB3T+nqQJNeM5CFnnbec2W4=;
        b=RZb8QqNoV698+jxtu7UTQgsT/rC48vVowOHT8cJyolSYT3sqH3kPKl1/+ta64WeEqN
         bf/dqy65KXfOUp5UIcNSVC98kN1d/InT9BB3kPV+7F8ffCezufatvztJL751naAxzk75
         pxwk3kLwLq4gMFt4ewkgvED9NmQbkRvigGjeu7gUoimK9qhpegJjiC1qdja9sKLfYgSk
         WEvW0Mw9j3/Dn+rkSkNPWP9PPi0V78INAOZ2ugtSgN+0Xv+HczfEqKz8VUsiUnwXoInO
         5KfIUmUmKX3wa5RQr4t7oVkqvGWcqLHoM7risS/kdXtjUt4ime1zZBIb1WTP3r9TQe0t
         yA7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784756688; x=1785361488;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JmjPr4ajWT+pNjYdNv6NRB3T+nqQJNeM5CFnnbec2W4=;
        b=NIA89Jjg7PFzbpVjfk4gbhUPwO48YsUz6bTpEt2Imst6ZV6jfsobDvI4HbSUjJrULA
         fa6Fond1yqocEhuma25Wh92qMddH6xAWJy3jyPJ0jSEk0KyIFxu93wD50GH+nmkJtlgA
         G1q0OC1PqxqTjg+iNlBxTtoCxz/qMpIoXJ+YY7fDshgXaVyj7biAWYuwmouElxQKyQBU
         6PhvRYhhxg98FMFdxj1WTctA4HRCN5wzLKrTlh11N+q5pEMZlKBsXDTJ5mbmI5gHxnTx
         x7lkmnuzbSXMm5XoPj/2L9qJw5h0/3e4tRvSJRWQJl8MF3lBdysF/569eLrz02GHs4td
         qHTA==
X-Gm-Message-State: AOJu0YzD9sBgFg3FdCTIhC70LLGhyYxF3wMImgAEYGqoPFG6KWqmjPlz
	mdNUfGUHgB7iGNOimgDM3EW9TlW97sTmUFjpzfcRHMD93Vl1kFNZiQJj
X-Gm-Gg: AR+sD11TQltSHN3uEbE2RHcMDU9XlAVhpBseZZk+DQwZbjVPD5ClVEuNMCXrqVhRin2
	GZUauLQiZWhW7isS8vKdhWy89g25OxAo0q//8ayLp6tAhsA4qD9zgqa/K2wEJajvr3yqohxLaMo
	4c0wL4hiIM4WtAcQaEUqp5wdeQoAHx/wKeTqpqsjOrVwLC/2YVxrc8sl2qyGSvsp/wfJZCG6L+2
	xDditFXSfxQn5IIY2PP8oDUfDqhOFocUKTDeXjI7ZpD+o84vbQLso9vh83cLUKyrpH+sgX8/mBU
	NUAVsSC3mZuf3F1+sDWC1BZSTiUAJZRXpei1KshttuXMWYIutN1b9/lYBz0TZIDZJl11ilLzMQT
	cDdejb6S8CIqKVtezhc0apHDrcGGORGzOHqFf2pimOEFe43+KcPc/f2p8kIFJHtG/JNqUQut2Ee
	+wA62t6RY/RrNcwUNUMzQz6f1ecnedz1HiE4LOhXrFi0CYYx8g
X-Received: by 2002:a05:6a00:174c:b0:848:2f7a:2e5e with SMTP id d2e1a72fcca58-84e2bbdcc09mr629731b3a.77.1784756688050;
        Wed, 22 Jul 2026 14:44:48 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17237c3fsm1946297b3a.9.2026.07.22.14.44.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 14:44:47 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Wed, 22 Jul 2026 14:44:23 -0700
Subject: [PATCH v10 1/8] mm/hmm: move page fault handling out of walk
 callbacks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hmm-v10-v1-1-606464dd601a@gmail.com>
References: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
In-Reply-To: <20260722-hmm-v10-v1-0-606464dd601a@gmail.com>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Shuah Khan <shuah@kernel.org>, 
 "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>, 
 Lyude Paul <lyude@redhat.com>, Danilo Krummrich <dakr@kernel.org>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Min Ma <mamin506@gmail.com>, Lizhi Hou <lizhi.hou@amd.com>, 
 Oded Gabbay <ogabbay@kernel.org>, skinsburskii@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-hyperv@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 nouveau@lists.freedesktop.org, linux-rdma@vger.kernel.org, 
 Jason Gunthorpe <jgg@ziepe.ca>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784756683; l=9376;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=e05SOoAaH6rdxtJDrz7A9LUM75TsCH+ORPFdPnvT+/o=;
 b=6UEcui0Mgdw7SEXvw/fnz0FGAQeRe0lav9XGzNUVUHMiVOsV2b7xmxa+kesWfMdeztUFG7U59
 1Kn/V2daOYUCUD0magnsyOym2mUZFFsnubIphBn1Z2zSdggOddwVTuP
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 47B4F1C0004
X-Stat-Signature: xaemfqeppm51zgdwe88k8hawdzkqkxtf
X-Rspam-User: 
X-HE-Tag: 1784756689-43089
X-HE-Meta: U2FsdGVkX190hSs8RO5j8D6msQAFCq4IdRCPgLdj2J7nMMwIZJtb8E/t4WJIIumDemHdP9Jaf2NResd1Az60QiBPh6BT5o0sY2LIBAPlSrE7BR293LUW42dc8ZBQejBQ6WAxZ5QCWgfT28eqUbkVw+5dWi61+doLxbi6kpfbP8lYx6wcL4YQ4GQS9OI5STw9HVvmGVyDFB2Byk8bjMquLUo+WbbE8PELnNmsXzHkfXkVECT/Y9eo+y+UnB3xSiyGTtMIvQx689i1bzjjUTyR+Dhs/x1t0TNlh/+MJWMgCOwbFFEsrmKCWnLBwn21aBBGJLbLBAJ2TmHp/X7Xlb2IsV2E5eFlY+pEY4XyHRpux3osyRoZjQzpwAcDVW0m3aRO6oRyQ1lXvvu21n0wy5kOE8NITd/xtaP85dxeBzMLhE2DgMHLZMkAjXTi/xAxztZ0diTdesd4pqtN+imiFsqTJP2/LdqumYDQrT0+vJBJYV+0p60mkak3W+rbcs9vYXDDUf5uC8NezEWcjpFaZ2SIV/7esZ1ES2bLuZzJJIXK38fFPmKocofEF1CONckYyUC4eOn432de5TqZJ0BXRPE7GECemjlNk5FX+x7n5NS8Fsgree2w42PLw3jayIW6Qsc6mZQCZwRd9ECDGEWXY50LYmfdpfeq7togLCnuBjgZ4wsth+V1pLXRK8dMbiixRzFQVO2rFhkvUWteVNqpBY/fHoYTmgS9pduZl5iZ+/yV5tfulGxhnn4w+YyWsTWsE1WpmzMCICv53g7KI1Cl74f5k6QR+EUKp2w2LWaC21zOuPoCSDapbjU7GcFKxyT/aebK02I5El2C57H0U6X54zf/HLg3FRk30OgmZlVLkHoeaXg9SegifE1ee+JLn/Wc9xyrOXlAVUY30MTEV6xZ5Xv+k8PqOAU1aDiTuskSEOa5g2n8VD8cbHYJJs80WYCeBbUj2qRBbuMlOgpADmqaLrZ
 by6Vrvwj
 CcqFDPJ/iKaSReRJ8qwHdAd5xac+U7iYa/CpyAEcC6LwmxDRKsZY1CXGSvrnB8xW4CjASH6dNJFUAL/PZhnUX/fj7Nz7NNi8edWf8EMQ2lip/HJ+JvSk27ul4z1U9ysCykbSxH/vok+qru+4QJZldfvh8PmUQfDVJxaSsvo9XEP1piQ35wT1J7qEl8FE1RKvd+gej67KphK5bupj6+D1ROcgbcFtnOoqEYOcYasVRCL2dvmeD6oYd4xmnWRBoEiseJYG1Wuk8moGmcEbYTfcWlaVrWprvzeNwh/ea7IVUQhYHBpnS24HVKX5PNj0gxltUFYcdwro+bXb7YZ/jwa1yPrectUXioZoo00hsT97cURTXJ3dbS5h1xMwQuZdFV1sX9hNJcw9vp/k1TaM6hNsN91g9YlODl5k4gqFi4UkjxsIJv/3IjqN9kCV2GuX1So38R52YkUzWc6RvHaf6ep405RIZ7v4hcSGNKAn2y37kwIy9BqgJ8m0E8LbglDsN4bAG0T1PxjtjWbgn4hNcaomLktvwE9n9TXp6DDwtm4MMY/KkaHTrhs10N7mh5VRHtdKiDsDw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hmm_range_fault() currently triggers page faults from inside the page-table
walk callbacks: hmm_vma_walk_pmd(), hmm_vma_walk_pud(),
hmm_vma_walk_hugetlb_entry() and the pte-level helper all call
hmm_vma_fault(), which in turn calls handle_mm_fault() while the walker
still holds nested locks.  The pte spinlock is dropped explicitly by each
caller, and the hugetlb path manually drops and retakes
hugetlb_vma_lock_read around the fault to dodge a deadlock against the walk
framework's unconditional unlock.

This layering does not extend cleanly to fault handlers that may release
mmap_lock (VM_FAULT_RETRY, VM_FAULT_COMPLETED). If the lock is dropped
while walk_page_range() is mid-traversal, the VMA can be freed before the
walk framework's matching hugetlb_vma_unlock_read(), turning that unlock
into a use-after-free.

Split the responsibilities the way get_user_pages() does. Walk callbacks
become inspect-only: when they detect a range that needs to be faulted in,
they record it in struct hmm_vma_walk and return a private sentinel
(HMM_FAULT_PENDING). The outer loop in hmm_range_fault() then drops out of
walk_page_range(), invokes a new helper hmm_do_fault() that calls
handle_mm_fault() with only mmap_lock held, and restarts the walk so the
now-present entries are collected into hmm_pfns.

No functional change for existing callers. As a side effect the hugetlb
callback no longer needs the hugetlb_vma_{un}lock_read dance, and every
fault-path exit from the callbacks now releases the pte spinlock on a
single, common path. This refactor is also a precursor for adding an
unlockable variant of hmm_range_fault() in a follow-up patch.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
---
 mm/hmm.c | 118 ++++++++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 75 insertions(+), 43 deletions(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index e5c1f4deed24..bc9361a715fa 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -33,8 +33,17 @@
 struct hmm_vma_walk {
 	struct hmm_range	*range;
 	unsigned long		last;
+	unsigned long		end;
+	unsigned int		required_fault;
 };
 
+/*
+ * Internal sentinel returned by walk callbacks when they need a page fault.
+ * The callback stores end/required_fault in hmm_vma_walk; the outer loop
+ * consumes the sentinel and never propagates it to the caller.
+ */
+#define HMM_FAULT_PENDING	-EAGAIN
+
 enum {
 	HMM_NEED_FAULT = 1 << 0,
 	HMM_NEED_WRITE_FAULT = 1 << 1,
@@ -60,37 +69,25 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
 }
 
 /*
- * hmm_vma_fault() - fault in a range lacking valid pmd or pte(s)
- * @addr: range virtual start address (inclusive)
- * @end: range virtual end address (exclusive)
- * @required_fault: HMM_NEED_* flags
- * @walk: mm_walk structure
- * Return: -EBUSY after page fault, or page fault error
+ * hmm_record_fault() - record a range that needs to be faulted in
  *
- * This function will be called whenever pmd_none() or pte_none() returns true,
- * or whenever there is no page directory covering the virtual address range.
+ * Called by the walk callbacks when they discover that part of the range
+ * needs a page fault.  The callback records what to fault and returns
+ * HMM_FAULT_PENDING; the outer loop in hmm_range_fault() drops back out of
+ * walk_page_range() and invokes handle_mm_fault() from a context where no
+ * page-table or hugetlb_vma_lock is held.
  */
-static int hmm_vma_fault(unsigned long addr, unsigned long end,
-			 unsigned int required_fault, struct mm_walk *walk)
+static int hmm_record_fault(unsigned long addr, unsigned long end,
+			    unsigned int required_fault,
+			    struct mm_walk *walk)
 {
 	struct hmm_vma_walk *hmm_vma_walk = walk->private;
-	struct vm_area_struct *vma = walk->vma;
-	unsigned int fault_flags = FAULT_FLAG_REMOTE;
 
 	WARN_ON_ONCE(!required_fault);
 	hmm_vma_walk->last = addr;
-
-	if (required_fault & HMM_NEED_WRITE_FAULT) {
-		if (!(vma->vm_flags & VM_WRITE))
-			return -EPERM;
-		fault_flags |= FAULT_FLAG_WRITE;
-	}
-
-	for (; addr < end; addr += PAGE_SIZE)
-		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
-		    VM_FAULT_ERROR)
-			return -EFAULT;
-	return -EBUSY;
+	hmm_vma_walk->end = end;
+	hmm_vma_walk->required_fault = required_fault;
+	return HMM_FAULT_PENDING;
 }
 
 static unsigned int hmm_pte_need_fault(const struct hmm_vma_walk *hmm_vma_walk,
@@ -174,7 +171,7 @@ static int hmm_vma_walk_hole(unsigned long addr, unsigned long end,
 		return hmm_pfns_fill(addr, end, range, HMM_PFN_ERROR);
 	}
 	if (required_fault)
-		return hmm_vma_fault(addr, end, required_fault, walk);
+		return hmm_record_fault(addr, end, required_fault, walk);
 	return hmm_pfns_fill(addr, end, range, 0);
 }
 
@@ -209,7 +206,7 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, unsigned long addr,
 	required_fault =
 		hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, cpu_flags);
 	if (required_fault)
-		return hmm_vma_fault(addr, end, required_fault, walk);
+		return hmm_record_fault(addr, end, required_fault, walk);
 
 	pfn = pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 	for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
@@ -328,7 +325,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 fault:
 	pte_unmap(ptep);
 	/* Fault any virtual address we were asked to fault */
-	return hmm_vma_fault(addr, end, required_fault, walk);
+	return hmm_record_fault(addr, end, required_fault, walk);
 }
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
@@ -371,7 +368,7 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk *walk, unsigned long start,
 					      npages, 0);
 	if (required_fault) {
 		if (softleaf_is_device_private(entry))
-			return hmm_vma_fault(addr, end, required_fault, walk);
+			return hmm_record_fault(addr, end, required_fault, walk);
 		else
 			return -EFAULT;
 	}
@@ -517,7 +514,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
 						      npages, cpu_flags);
 		if (required_fault) {
 			spin_unlock(ptl);
-			return hmm_vma_fault(addr, end, required_fault, walk);
+			return hmm_record_fault(addr, end, required_fault, walk);
 		}
 
 		pfn = pud_pfn(pud) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
@@ -564,21 +561,8 @@ static int hmm_vma_walk_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	required_fault =
 		hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, cpu_flags);
 	if (required_fault) {
-		int ret;
-
 		spin_unlock(ptl);
-		hugetlb_vma_unlock_read(vma);
-		/*
-		 * Avoid deadlock: drop the vma lock before calling
-		 * hmm_vma_fault(), which will itself potentially take and
-		 * drop the vma lock. This is also correct from a
-		 * protection point of view, because there is no further
-		 * use here of either pte or ptl after dropping the vma
-		 * lock.
-		 */
-		ret = hmm_vma_fault(addr, end, required_fault, walk);
-		hugetlb_vma_lock_read(vma);
-		return ret;
+		return hmm_record_fault(addr, end, required_fault, walk);
 	}
 
 	pfn = pte_pfn(entry) + ((start & ~hmask) >> PAGE_SHIFT);
@@ -637,6 +621,44 @@ static const struct mm_walk_ops hmm_walk_ops = {
 	.walk_lock	= PGWALK_RDLOCK,
 };
 
+/*
+ * hmm_do_fault - fault in a range recorded by a walk callback
+ *
+ * Called from the outer loop in hmm_range_fault() after a callback
+ * returned HMM_FAULT_PENDING.  At this point we hold only mmap_lock;
+ * the page-table spinlock and any hugetlb_vma_lock acquired by the walk
+ * framework have already been released by the unwind.
+ *
+ * Returns -EBUSY on success (all pages faulted, caller should re-walk).
+ * Returns a negative errno on failure.
+ */
+static int hmm_do_fault(struct mm_struct *mm,
+			struct hmm_vma_walk *hmm_vma_walk)
+{
+	unsigned long addr = hmm_vma_walk->last;
+	unsigned long end = hmm_vma_walk->end;
+	unsigned int required_fault = hmm_vma_walk->required_fault;
+	unsigned int fault_flags = FAULT_FLAG_REMOTE;
+	struct vm_area_struct *vma;
+
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		return -EFAULT;
+
+	if (required_fault & HMM_NEED_WRITE_FAULT) {
+		if (!(vma->vm_flags & VM_WRITE))
+			return -EPERM;
+		fault_flags |= FAULT_FLAG_WRITE;
+	}
+
+	for (; addr < end; addr += PAGE_SIZE)
+		if (handle_mm_fault(vma, addr, fault_flags, NULL) &
+		    VM_FAULT_ERROR)
+			return -EFAULT;
+
+	return -EBUSY;
+}
+
 /**
  * hmm_range_fault - try to fault some address in a virtual address range
  * @range:	argument structure
@@ -674,6 +696,16 @@ int hmm_range_fault(struct hmm_range *range)
 			return -EBUSY;
 		ret = walk_page_range(mm, hmm_vma_walk.last, range->end,
 				      &hmm_walk_ops, &hmm_vma_walk);
+		/*
+		 * When HMM_FAULT_PENDING is returned a walk callback
+		 * recorded a range that needs handle_mm_fault();
+		 * hmm_do_fault() runs the fault outside walk_page_range()
+		 * (so no page-table or hugetlb_vma_lock is held) and
+		 * returns -EBUSY so the loop re-walks and picks up the
+		 * now-present entries.
+		 */
+		if (ret == HMM_FAULT_PENDING)
+			ret = hmm_do_fault(mm, &hmm_vma_walk);
 		/*
 		 * When -EBUSY is returned the loop restarts with
 		 * hmm_vma_walk.last set to an address that has not been stored

-- 
2.43.0


