Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67068C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 18:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D5706B008A; Wed, 15 Jul 2026 14:16:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD0E6B00A9; Wed, 15 Jul 2026 14:16:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 475AD6B00B6; Wed, 15 Jul 2026 14:16:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0D5E06B008A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83BC31402A7
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:03 +0000 (UTC)
X-FDA: 84991815006.01.C104426
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf31.hostedemail.com (Postfix) with ESMTP id A46DF20003
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:16:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tDAa15lZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784139361;
	b=E02IS1N067xD1T9FJTH28TTXCC63WIGUAU5fPwQ3nba7LAW7TtMa/pSAqwndhWnzHsK5Gx
	YJa/fAUHfKO766k68Db4dLCvPlj/uQ1TLgwkZz5q6udNzSHXVh45XseJ+IejI+qFbx8DVF
	qdMC1mdrO1Sv1LTZcKBGBdCkc/N06U0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=tDAa15lZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784139361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtG97ghw8TeTsbq/X2mfNjjQ8OBxNKf1PEUnxppKus0=;
	b=PP+Vi7HQAARM5IIWxeT2j2IOyJTs8HmCI6IUoo4s2mocfRu3b2Z1lPrebbTgHGX0cd/aor
	eJoCT1qT5zLE2CwdnjiQ8Aud9FivDvUVMhfcGCTk25Cm0tZ6yKyX3/JSTeBAUuOCu3wsRv
	k8XH6/MGUJ48yesPRk5HEIfWsepcbUY=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38759bcd877so5060239a91.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:16:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784139360; x=1784744160; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=PtG97ghw8TeTsbq/X2mfNjjQ8OBxNKf1PEUnxppKus0=;
        b=tDAa15lZVwVmJtN3t255QV7XN/vrJ3dVyfkRqif6mcT0FqpwexN9t1kNBf6AvTxOHC
         /Jzr8AJYXxxM2gv5qebzYA1BVg7VuPymzs+js9JSA7Sw4J7bAb36Dl0hTPvM7fS2uhy2
         OdqRS4PSS8cOmpEUuvWFlsMRhEfrDVaElaIV3HvYkNo1neh8/vsJa1yrrzQGqpWZyhCZ
         XEq/48NZVy8ocpn+8PMNqq9TyDPvDMagCEuPrrfO6iNdBIjTI/Rzow77s3WzgO3uKsBC
         gWX6SFKAY5W1m3L0Lk2ECKOuPiCDMZ80p3CCj4xOsU7fOYJBltGn4sMKolh1RzvlR/jI
         dwyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784139360; x=1784744160;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PtG97ghw8TeTsbq/X2mfNjjQ8OBxNKf1PEUnxppKus0=;
        b=ORUF4xzCy4BM0bsSjuTjO+3DNkjAx2qKN1KMKDBT2Lo2YJfB+VmdlGMFO3WZSHxnXa
         hCQ9UfRPsVJhvHtNvmMQnwWrgi6HD5ra6e1hFWcgbxL7BqrcVZo+M9ZQnHoRb04PaJg5
         rJM31SEYTp1yZaXhuYSyy6CghunLlD78dcQJV/3ugfXU4iFnizmiK7VFZjnm6AAHy/gM
         xb+7417gvDB9g9nlF4DPeHSCWhmRxzyNHpBozuBPMz0lUaQN/Y5RexZk7AfyvARKc4lI
         skKrF81guJSUBFa7q1fLwhrYwSNfNfdDuZWtooWk35/30RGLnN703iE9ITMKofreGJUK
         XF+A==
X-Forwarded-Encrypted: i=1; AHgh+Rr6Lb36ddr7PpFgW5OiQgibg5cYqf9FuPsnWccEWVY9RLgKYPqTkpjyxcxhClvPQ+gD1Pfy/SIQCA==@kvack.org
X-Gm-Message-State: AOJu0YwPJlW/LyUlbOiOtyHIDNounDVpt/ajdg93PdZO+0eEc/dH1oR4
	s556t9OWq8BT7e5XkwMS4z1Dy4QPhCLH4j+hPEvmab7EBQCoE3FdI7qp
X-Gm-Gg: AfdE7clhpjVPn2cdrcdBiUfK4s9HBHEmOlTzQuetGIiy/l74/pvymv7VAOX1eyq5ceS
	qsz3B6ptJJ6r7nLwJGF7Z4va7VFIM/YEIZ/yUB4K/g/ARThbHZepQvgeuTjXKCU90NKqbF57Wf9
	8yDvqbHyipoRL+eNQNGuRyapjPk6DKzloe6/GWg7kB9393tKffOIHi9Ykg5YIfv2I6d8BAMtYBf
	r1enIM2SppqRP+zZUxD8yUV/8qG4sr8mdPSrNwTYvHQzfEwSZTjxHiNo0zS29HrVkMYX4rRf4Qz
	sOKIHKcn/zFOk7NIdbcgr/bCmqCgUFGDcZwIZVrTxHmTALtp4TbRtQdlKjzdwHcG9OGr5Ac+LJ8
	6Ajk3QjjqyuCFe3LQ1Le+CDlMz8TguLo/5MDLurWFGHwBhsusuzYs1w5doI9Ex2v57BlXfV8dG5
	i0CpAPFLjeaqY/yrxQef2F2p3L9oD2KNTz3Sp58kcVtNOl97+PsQvMcs0syz4=
X-Received: by 2002:a17:90b:2645:b0:37e:1430:769b with SMTP id 98e67ed59e1d1-38e2a0c3c4amr3028190a91.24.1784139360154;
        Wed, 15 Jul 2026 11:16:00 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e39e5e176sm7928a91.13.2026.07.15.11.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 11:15:59 -0700 (PDT)
Subject: [PATCH v9 1/8] mm/hmm: move page fault handling out of walk callbacks
From: Stanislav Kinsburskii <skinsburskii@gmail.com>
To: airlied@gmail.com, akhilesh@ee.iitb.ac.in, akpm@linux-foundation.org,
 corbet@lwn.net, dakr@kernel.org, david@kernel.org, decui@microsoft.com,
 haiyangz@microsoft.com, jgg@ziepe.ca, kees@kernel.org, kys@microsoft.com,
 leon@kernel.org, liam@infradead.org, lizhi.hou@amd.com, ljs@kernel.org,
 longli@microsoft.com, lyude@redhat.com, maarten.lankhorst@linux.intel.com,
 mamin506@gmail.com, mhocko@suse.com, mripard@kernel.org,
 nouveau@lists.freedesktop.org, ogabbay@kernel.org, oleg@redhat.com,
 rppt@kernel.org, shuah@kernel.org, simona@ffwll.ch,
 skhan@linuxfoundation.org, skinsburskii@gmail.com, surenb@google.com,
 tzimmermann@suse.de, vbabka@kernel.org, wei.liu@kernel.org,
 skinsburskii@gmail.com
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Wed, 15 Jul 2026 11:15:58 -0700
Message-ID: <178413935809.1155966.6398279131483632373.stgit@skinsburskii>
In-Reply-To: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
References: <178413903133.1155966.3904063656020521607.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A46DF20003
X-Rspam-User: 
X-Stat-Signature: ajcm6bzq9hi9mmrbi5ejw6emng4sfmht
X-Rspamd-Server: rspam03
X-HE-Tag: 1784139361-370531
X-HE-Meta: U2FsdGVkX1+nXaf6nGdbV8XIDIrncAdwOl8ZoCVuKEBV9o1cNRmCpk/MfacRlhcQZNg83towJAntKCZWRvcZCVuXZvKDLBB3H4icBA3TAjct/ltOFoSHm6vGvXG7FtY4gr0I2zvBOxjuk+EqoACuB7u6rnL86hJU+hAFtIhWHD3IamTCyfJDArmmIPVUP/4oLH1AB+cpF93gVz+Rqr1NFCbVbNFkHOXyGv1L7A4N7my6+oljUxiB4UHvgw35PwAW/mLiF9aUP4inlk8Kx8nZwX7d7nHJIPBOBXbRDH4LUoh3MRmC+C59h16OCSCt3oGXXiSuSv5UWjl8RBzc4/8XaQ1P1vcxYJMpEyAJXS47qTvycun3ac8lxUkg9KKTZz9bgIPW8ESR3h1sIAYWZa6Nrt15p1tj/mCxgXEiKunadhFhuu5tz6iATOqYR78TGk6O23LCcTqPkcDL9x8X5K15ZNV8M7Ce/rNzNe6pANQ+R3570V0cyZZTLcUYyH6P2Rqelqsb69mlDwmLTqGf1p5Hg52KHchrdjVFnP+jg5bDURRZfaueeNE6b+o3vCgh0YOxOI6buN66n6CdHU6VH+fGT92m+bub7AXTxuoO2bBjOES4P5XTlTaBX2ap11ya2VSQXJjM79WBf/F0YTDOkoDwzw869WP2+5tPYIOVlT2bFju9AGGeakcX6JHw9n313bfd4k7IdIMOeLe+3EE2T7m93SCEHKi4V8oFoFgko4JKmC2/oCE6GQhtZ/qvBV5EtJ9BJDYL5O4eMoAuwX7HnbjXmWXZ8S7yog2xFdCo+c2O4/cH5ygr2e6z296mXlzvzBCoA+pKAXpx7+MMGygpFYh/1ZScjqrEknL9GEQMVBTU7lWr2xlvupTSnfKHbLbIk0qYTTTnVmriJ221PuWh1AKDZh5H+EQ3Alcpetb0N4KLjXiWRtI9vBDLem2EA8MTP0c475H+3OEF6WIMngfF2D8
 QwLJZWj2
 0RUCnS2bMqsq8wn5ujxtT3VEhKwapu58SWgPo2R8BhQjBbrqUjfyGqLEPR/bNfu3kB+YN1olXhykOb84b3L7+W4GrBJkDSu9Lt5H4dFtf9B2HgCruvAYCyBHsEDyZbnErcmXkxA7S7X3in+QkqK6YOsnD2O4oFlesoyqlSlNy8cTuIUaBwjKfCZBpGFSgwS8C/iFZzdsFuXtESaBBUJRRfLhVN2MjP4SSZZLtqbuukoUDPNjGeIInEM77vkTCD+2rowUw+RqqQn6LjpMMOK021Ubwo7e9AxRzTnf7mCgHtVUeBWD+txQe1zpo99/yXN0zSm2ZNuaUz8v5NfyLc/tJNbLKFR/C/MUWnJDVzbRPzFKdF/8v8unlJiQRIZshvVmnvzPiCrSOhCDXYv/MVgkUjyj5Zch4zLdfthPoZcb0WdluRILFRWRmNW0zsOLi8m2hLQqIWy1jE4rBf1GAAVk70DOkleQLHzN8DgU+0r7CaUhisWVeWF9v8bnXFoceP/hkgOsxqZu3FW1/9jtL5gzp8hdlD8K0ACYxjYnnYr4U5/Vk6qwf7YS03P8hCwOwst2PcIxRWyw/t9nlkFb81VJYxbxxjM3ucmpu4nVUNnat4URIWr8Oa+LyEf93w/hRs2WXOICtG0RTRii9JiMp4hmbmIcG/g==
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
 mm/hmm.c |  118 +++++++++++++++++++++++++++++++++++++++-----------------------
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



