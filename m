Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDD67C531FC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 17:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B266B0088; Thu, 23 Jul 2026 13:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EBFD6B008A; Thu, 23 Jul 2026 13:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116A56B008C; Thu, 23 Jul 2026 13:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEF686B0088
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 13:36:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F6CF8010F
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:49 +0000 (UTC)
X-FDA: 85020746538.16.F1DC182
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7E4D4120007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 17:36:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OwX/dgIf";
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784828207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmjPr4ajWT+pNjYdNv6NRB3T+nqQJNeM5CFnnbec2W4=;
	b=yKLLneIMWCwT7lvuu0COEncjODV1S8vkKLguenvlrcWLXEB520cnY8UXmFnN4yPBnSjBcy
	0++yo2PhuCo7H+tTvMkou73OCjVoyDqN+nc+6133683fgeLIy/llbiF9pHx4NHL8gg0r9m
	uS8wt4BIj20bI7BaWlwXti96i84s9eM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784828207;
	b=l7TXsA8T8fviXaF2NzYFk35/euJU9vU/tkOcKXxqYHUsYv/OxFO4lOhdXK4QLvs45y7p/C
	DAqcc7UdORwXE/d4t8lWYV00+y13rjxMTLvFtunV+QRW8E9smHYrTDpX942bqrQT+NwGUU
	+i3sPkpUZSXa9BvYO9F4+KrL4KjHidc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OwX/dgIf";
	spf=pass (imf29.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8484f229529so648779b3a.2
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:36:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784828206; x=1785433006; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JmjPr4ajWT+pNjYdNv6NRB3T+nqQJNeM5CFnnbec2W4=;
        b=OwX/dgIf30EpiZDG5OfJhthSgVVaV1q0v8kz8mU/haMAKFx98RMkwQI2k2wLAeKATQ
         5zb0Slo0BlaIOy2cF+QnFuotAl1kF+MOsAH0dDz6tm//IAEHnAxKymj5lsWQHYSGh3lE
         Q+XH1p7MkBukfEefvWbHl8wAhiTeUeOWsX/e1MDmcSoElsqr5iN1Nj4ETPyKOk0jCFpd
         VM20MW5G47955bROC28WgiQN2e0jZLDQtKl+3Gw0lOmlIuNilBeHYqE0OcvB67a44M34
         Lv/ocGAJuz8FnVQGcyMv1d6vmhInV1U7VjsfiYxC/dAMUW2MrGVDalK9CzDn0veuP+KG
         RNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784828206; x=1785433006;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JmjPr4ajWT+pNjYdNv6NRB3T+nqQJNeM5CFnnbec2W4=;
        b=gYtqq0uPkmUNZ1aTATD6OQO9QnJsum6lziA8enXztNzVn+lMSjuvYklrY6LDwsPj2j
         5M0EoqfxJi/Q/I48mgQCuFZPjpz5NXzhmbgQUoo/9BK9IeTEQAVgv0uwQ5KlzzgI4lv0
         FepnJY8wHXWKZ8DedAy4tFKUcPjztzdVu9ILt6YZu24qHsW+FWBDnGVrrTeSHks+Nl5k
         B26UkQ/AetzYXWVfXmfmWAd+jWYalMIwEad7WuroqJXpogkEPznaSpt0hY5IXt6jrwfT
         xHEXN7/NIyaHHh1JQQSwVoHnBSvf38XVrjpyhDRIMpk/Cq1cepuBrfOov+yJ4NI2LtMs
         vuEw==
X-Gm-Message-State: AOJu0Yx3fKNYBzYCzzKHkcw1FjjLw2xH5Tnq/J21W1iA3YNc+rj8c4E0
	aDkdxvizHw06E8jmnq1heOPYiY5jypUEEJZ4yKQ0rNQdSLLBbSc4Njyh
X-Gm-Gg: AR+sD13MlB4XOvxbwKnFnJKSDYi1pidf2gQjelAKyUlrehJ4DkkdOTdhnBVpxH7vktU
	PqvAxjKt8Iqlzy4bzb8T/GAUtay6HucaLvcDzz7R+mRRFxR7uLY+ELdJ38DUpIV/ZBoDEgofYTl
	8hAo3HUDUkEZK012Bd1ApP/Wn+5UDcA2v2iSKdrTTfyRKSAiu19Kdm7kjBFLVpCv20PITh7gkqb
	2LuJsHprQZODn9dVJ5gq/Q+FjlYdG/6aj7nljG6bAlv+rx6jpjU4dMwJiw4JUidYCz8xnuD1naG
	AI4ycpjeFsW0iCEOdpiMW4MH/jtiSGTtDFQb/ShkUB/wgIwTCRJKCZN5cOVlHUcQ2WNps4f3eLQ
	Gi0a7c2vmmXqOqHggGO7UQP7CjkVZJynVf9Fl+DveDt0Ze2ORl0yAgbkuhiMnD62BVvYov4D+xZ
	2z4IaYTGRmQezATWgeC5h1pOgIGixD8zCUxtD+PXxNFQPxh0w/
X-Received: by 2002:a05:6a00:3cc4:b0:845:e7ee:eae7 with SMTP id d2e1a72fcca58-84e2b7fc1f8mr4822860b3a.5.1784828206217;
        Thu, 23 Jul 2026 10:36:46 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e20622dedsm2691612b3a.11.2026.07.23.10.36.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 10:36:45 -0700 (PDT)
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
Date: Thu, 23 Jul 2026 10:36:33 -0700
Subject: [PATCH v11 1/8] mm/hmm: move page fault handling out of walk
 callbacks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260723-hmm-v10-v11-1-c55b003a4b61@gmail.com>
References: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
In-Reply-To: <20260723-hmm-v10-v11-0-c55b003a4b61@gmail.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784828202; l=9376;
 i=skinsburskii@gmail.com; s=20260722; h=from:subject:message-id;
 bh=e05SOoAaH6rdxtJDrz7A9LUM75TsCH+ORPFdPnvT+/o=;
 b=gwyU/77AJ6dKu0lZRnFlWCTHfMteTC7dUTtNdZcgpayFHK/4UuYZFQAVucZpomng7uyaHw8h7
 T8/k5JdDqvADw77M1tYI9WkF5Vk2uNwAOeuvh4Jkjbevj0cWSnQtBpg
X-Developer-Key: i=skinsburskii@gmail.com; a=ed25519;
 pk=bDpriHBYgeTdkIDweZDCemxsU93neJBOCn3YLIuJpnE=
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7E4D4120007
X-Stat-Signature: jj9wc3jf7u7qo9gguz9m16usifuieaod
X-Rspam-User: 
X-HE-Tag: 1784828207-207056
X-HE-Meta: U2FsdGVkX1+FiTFV529Z48SGGt405+MFnpCG7bB0gkWIC/79vRnzi9G1DpeuIIRRoNuGzG34TvhYjsSBAULub3L5+9rqcgO2yNC+bo2nGFQ0AZEHzzhhmFC4b/QXlwEmiN/YlUTkqVFi68B6ma4mABiKg1tPJz3mza5PFGENoJ/ZzDVJjLuQQIJ544I9CPVDhcWuu9XRnl9OD4b18q/w5wvaFU4PzpiJ9N9vw2JCsD7EsTJ3j2jhu8vLNR2HGTOsxttlXcroeDcbwJH01HT1FlgsHxoykQxEJsLN5sQA0lVFt190XEhwPLk6KhQ3GoQgvseHGZ694Tc91QG4JdKPTl/n+4k67YG/cmgBI8NJCciTvzFG72PpFmkP9w6D0Rue1WUtij3W+Sy0X/W91rsRr+TyJBIK9SbzfBYt51jwW2qsOw4lOGO14rbFXLYuIguAbJgH1yi8YbcOTS+ml3076nLwqkL8lkM7rTpsn0kXBO/um3KUJCZeOssE8nj/3xAICml6iRkJP9aleVbbcd3BDeeUxvQHqbQIpuiKLtONZ/OUAUEr0fbiTrrj9FPxzblLdcmljnejcY2ZQH3kETOUuLSp+q5RTNdibuhJUIryWnK9qGZb7Zg3RN7YZgYZ2h+wrpM2YmNK12jhjiaq1JJJazsoVYl3kf+A/qEAe5FXS53ijuOkz79PquoBlLDVBfWcWQZ+zINCDTMul8pY+vzM0C55rJVg8aYjD1EUT0WpvjucA1R0y53jdf06oZZRIXSHI212tTlmlGe0skRJoqNUp3AJJ8Qvwtn+csAjF+By8dyNh8BxHOkRb8ZtzHCGNeZs0HvDiajWVP/yCGhUM3c3d6D1Stz7AwwM73HSKaFH8OUJ3EzjnFSIjUyxrEEYL2AoqcT4undsDEiA8eoK3NABrBZ6SgF+nHXK1WaRfq+oAAba1sJzd/D65HM0ngRho61JzA3cDo/hAEBfgTGEsOv
 xIO6hrw/
 ibRm9fcc07DD2ALF6Nemgdwvs9sxEXTwKn5DO42PNs4I4y+4YNGk1bK+DiwLtgu6YlxPsokhWbP6ZyYBNrdOG+F/h+YQNQDrikKH9FQv13bn7GMegXnoJS9a/zwBE2InCsECGIuz4+gZZ5e9xXd8h4cBPvBPgyd0ok19j6wBQM3w/SD5urUZO9znF4DgCI/t9GjuVUwiF6ST/En0wDvI+ev0+ItiqnxiGtTvii+mGoy2tw+hVg3pc38JowhVrZ4XVFB1QlyCgfhZliTkOmZ56pORHMsF6Uo2wi4D8Ur57/H7Gq6Rk0P63D4XzADPmlqeY8GDrMnIE1V3qel0BZwR6QY5uZfoYkL+w1iS2tNR+fb2wPAy286isg9vBHQjl0CVrIZ3W2Ubxr2/1RLl5axvDi+zesoUvEvciwEc1vxdDu6GHoNDxQDzDtKtfblqOQDqCWZuHgLTX89FRUdj+1RzsbSJYywkcM0zxpld6Qn4ZIchC+KtggjdSVAlAnvcuLYCiKSW899h4iImSaBBS8TylVbOz+BSVTPbpWFnl0ceZra3sOKskZ712ISNQ0NoH8EqVIzdu
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


