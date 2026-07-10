Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3239AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10BD16B00BE; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4ED6B00C0; Fri, 10 Jul 2026 17:26:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F16236B00C1; Fri, 10 Jul 2026 17:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C447C6B00BE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:26:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55F9AA0168
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:33 +0000 (UTC)
X-FDA: 84974151066.15.61C22A2
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7FC9C100003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:26:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RlL7/9qA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783718791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8+MHxD8uf0HO8SRBYZIasl4vPo7jNKxT6S73gN/spU8=;
	b=sFffeH29mAOwn0E493TMv/afT9h+Ms7my7ElRnUw2vBSyk8CVjdGnagdPcOtDv1xrUbFIx
	NoKMBQHSDVA1vlP9qq68sEuUK5PLD7ZXmEzkMAo59cO3QvoebOXm6iq+1rkBiAdYVz/mKG
	yBhDjl4LSRYCnF/g98qy3UXeHzUaRsA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RlL7/9qA";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of skinsburskii@gmail.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=skinsburskii@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783718791;
	b=OEwPWk2RIcbILJdzQRZBgsRrKJnwMh1vYfxmmYRQGEKRPfK0U2fZOkXCrgrbgJycGzvitt
	zX45M98peLc4NtYa1Pnqsye7zcKYyBWfWh8ksL/9ZUHh/IPWLBHsPCrGb61Og6XiF3De47
	/CTv1iaCs8spiz45Hta1eVuzFgpQcmI=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-381018b9375so1761444a91.0
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 14:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783718790; x=1784323590; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8+MHxD8uf0HO8SRBYZIasl4vPo7jNKxT6S73gN/spU8=;
        b=RlL7/9qAOPn4Ut1t0ecr97gCaLC1Au5IrO6ScMjpjBFYOd2KATd5wUD0js9+tZCSr6
         zYejOnd1wC92Eoa8ujPkd8DwvaOU1JOsYqRUO9Aai96ebRlbS2WrFjoxNR6StJWPO6hp
         ZilMAq80Aauh7aUdtMfDCdtBVKFK87qzOh4+LpreqAd8MZp1Ws4AQwakO8zXtSmPidqW
         ZsKHfcUaESyScoaRNftE5UGky2PzINqhTWkAOqW1zaiuOXjtP0qlEoVaqLKVowtFkkNO
         TN5qYHNDHrKqE7rbSyV8HyZMS7EZZSEfolKtUwvbM4lfRGHjFxFSJfSbz2O+tCgZNbfY
         KSQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783718790; x=1784323590;
        h=content-transfer-encoding:content-type:mime-version:user-agent
         :references:in-reply-to:message-id:date:cc:to:from:subject:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8+MHxD8uf0HO8SRBYZIasl4vPo7jNKxT6S73gN/spU8=;
        b=DBdXA4XHLK9d+i26RRJp1Ku1VToDPMjZ9Q0OO804fW3uFeyztDDbYDXRkeNn2ejIMM
         Gb/pwz0z9nLL133TqNmsNBLz+0RDFL2YIADbGXeN2HrZdhMjX15l0RU62JHDqcDpypxo
         5b/k2pAAHyauCBdfosQHz+Rma+FYU+ZB48205a7a05Xyrm7+gwafxOUoOjevnEuabaBI
         pOCdnTUeuBRPeTCwwGRpRH+4joLMkei45Evp9NOL2LNN2VtyonIu/NUzx4ELT3NqAbg2
         3daMSZERoJMSa0o7Dr/SAfvqkrSb1xt4JGB5G/Fz3dKWBEDE9ClAcbJsVPEUXvsL6pHY
         m6CQ==
X-Forwarded-Encrypted: i=1; AHgh+RqrHJ2LeHOQ1TXB1fV594u9whdd/D8XcqtQiMgH0Xhu6UEL23LfX89e/rTcPVdR/a66F4tgkEmRDw==@kvack.org
X-Gm-Message-State: AOJu0YzSDszV7T61gwwlsa9WUGokUqMOWC/eqG9PViCPbdSoIR7elb1Z
	g3icTx7z4/AP+bPIy6gs90H3jFCXlOCI99beO4PNYlKBSm1dCC4hN6tK
X-Gm-Gg: AfdE7cmfxhd7vRft0Oh7LOOw0hcbMJJ85zC8EMKuyVJpEKzaeXT67MN71xdC4b0yk0f
	3BlFAQw1I/aYIEcVD1QhvCo4G8hPoKmx9hNOukNcciklBAGCcaXXA9c/zv2o6T9g1IG5Wyr+Jig
	adQIwQMwhHq8/o1BmPuwVXYKMnROtb1QgJOf+UXj0sdngyc8eFK8VDQxHVA1jyZIxKLsVL9oip+
	g21njPv1qtCljVuIvOLnmknx+FLqH8v577Le28CGi1lgmOaPo4bGqHc/OCDjJsrS1Tgqsm8V9xu
	VUMd4MpIRZUKgrTbc2gU0xje64pvvPpjtte/iI3+t0LitnVTU5gufxBaNi8OqzoNd+DfnNSUfUp
	vDQoA5jhfhEazW9tzPqsjsqdnrl6jpLdQ+ei8VIYJx8KuYiR/0Ufzv4wGiUJ4fhLuwuGrbs6r4n
	9k5l3hG/pHpSHZO9wp4DD0gXJV7dxo5lolkXFi8iKaHXpUQZXoS0LVAK+eW+0=
X-Received: by 2002:a17:90a:e705:b0:38c:e9e9:e7ce with SMTP id 98e67ed59e1d1-38dc74c5007mr567748a91.3.1783718790283;
        Fri, 10 Jul 2026 14:26:30 -0700 (PDT)
Received: from [192.168.0.160] (c-98-225-44-182.hsd1.wa.comcast.net. [98.225.44.182])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38a55557f39sm3404785a91.6.2026.07.10.14.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2026 14:26:29 -0700 (PDT)
Subject: [PATCH v8 1/8] mm/hmm: move page fault handling out of walk callbacks
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
Cc: dri-devel@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-rdma@vger.kernel.org
Date: Fri, 10 Jul 2026 14:26:27 -0700
Message-ID: <178371878774.900500.3975008123082170472.stgit@skinsburskii>
In-Reply-To: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
References: <178371866223.900500.12312667138651735591.stgit@skinsburskii>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FC9C100003
X-Stat-Signature: uftamah7r9fmf4oinjw1anrhd5fzieyq
X-HE-Tag: 1783718791-563141
X-HE-Meta: U2FsdGVkX1+zNx+l6i05xbJi+AK1VKU1nRCQMSdlKR6lVydWQ27c9x2e9/hC5iZEgNfqgy6KRjcDV1nHZHhfGS0CQGKIyptx78pxlf1xVQ4d9owgJu0cFwCsdt23mtL1KdOoBivUs1WEQTLUJ5yX0xJ3M6prniGQRzNieE74gE8vKpRB0ujSVtuPeFBZVkzf7rcNKcNyyfnmd+xBvaUrg8MZR1On9xfp9eVXrnGxbvjZZZKrwcGPu5Dsk09AGNhEMV5attygyqTPnX9HK6zzEfoAX1yCf9hJAYHHoSS1UtjI4e3d5jNNAaUZ2emRg86MrzSM6vT/IYmK1tO/WEKb/iw3tYm5ugiXFlGOMwfzX1YdhRjs1RoJ0SI5ff5L4O1Uc/558RTG1ZUQRx25gWxfctfMer6HsjZd6dRFmWTsYRh9aeOGPmVnJxfUamhaE75b3AYEhCj42ueDOg2WZRgwhHWIkNxICZF74Oi8r4ocm1VcpdleAwENon4VSD+YKrq1RJNm2H6/lnFpKuQ6EviNwIQgYwR9+4mWg7uYLRel1zrx74wLCMHtcrGmHZ0gEsGlQM4x9whoq6IdssOrj0RetSHbGUa2j6qkGcfpJZaCWU/k9c+Te3ZnyBgwmiN2zAlod3eD7wGAwOwzZoD8TfNu3myI54O2al9g387AEAJI7KA3sKNtRTliLKfiPZaKudab4YzJMtJ7eOKk9GkE9ObHQR3XvF51ah1np28TSMJ7a7p4hEykZbwK9uXK/tq+iKSBgjL63/8Tbqi0hQfuOAWeZy5dPSMNE/2FDrpVXZIy4RxleDfpomV7O3dQgJ5ejwQ7cEjybdXNJI2RG3IWvYaelmQ+WrhVOi3YGUAQRYhjNCbdMkijU6NyPq0YZWseyrCcOcEKVryzfgelREeXiH3iqbOgm5IXKWmfK2bBvFHILxSS/+ELmDK+j7NuwL7Z+ixxVNY6qKTGazlQSiOZWmH
 5W2gLgk3
 4Q6YDKCoKwuLrQQkHB9Y8upKgkmQmqA0df5RRsTvvP/pi/bqzLM7bdFp5IjX8y2oUh9uOamiYNBtuuhWVet4JomDSwsrJp3aCYjDA71VTlAg8VKXz9DARdp+960N/3hNrgSQdLHbKpB9FYOL1arGOSsGs/u2nEP3tGBdbTEFRQofRimEyGtySktD/n+cAU6rWUYL8iV+KyKcJLQuRKMWIe5/WkC2+ILNqbiiqhNHdRBUlB/lEvHg5/wyEISphYFzF1LJLJ2JqBNqKZqnuxeptxnixbatu8TsehUdLkw013attcuj/SneZ41I8ggwwysShuYQuFiYhjWI8/OZAOUsAJREt5UUkd+JroF0yuV3CeAPS0zj9FdFemIA4eWuiRsaZBllpGWrVqhPRVpDTycy/ZunnHB2H1r+F86UrySV0eWb7cz2xHF/SN51mfEBaN+ut0GsSnng/WeDfyeGnLyp8BdUf3wtyGxQdu0ZsYakoHK8m/uJXb0yp3MBgVO7cclRzkM97LzEf/IkqkM8UcZblNbMyuA==
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

Signed-off-by: Stanislav Kinsburskii <skinsburskii@gmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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



