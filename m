Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1A82FEFB42
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 12:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202016B0089; Fri, 27 Feb 2026 07:11:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B0306B008A; Fri, 27 Feb 2026 07:11:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AF2F6B008C; Fri, 27 Feb 2026 07:11:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E62EB6B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 07:11:55 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 59D52C22FD
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:11:55 +0000 (UTC)
X-FDA: 84490122990.27.EE396DC
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5E08D180004
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:11:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G73YvlTI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772194313; a=rsa-sha256;
	cv=none;
	b=BG3Y3cnbP6dkVik83u3gZze7+kXajS3XTwCdFfFAu6tFdooAT0fCM+vboHhBAnR98NfOqi
	KoWiugg1gy2XoRBko1CmhH/zvqPwaHZoGfRbqQ//fJDT1ruKy2q7d7bE9Bh/DQENQRcCbU
	HVmV5OzQavf3B0SDk414QPrJqVOGI0I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G73YvlTI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772194313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A9VnUUVWt2OivEInnP/5hnH7A1kF+epUMtvXzdzCsRg=;
	b=vBtBP1OHke0V6q5Y+zr3BnrnPznL3UP7qqGu9Ty+O4m9Uvq/C+sF2zJpTHlZd6HgMtELbS
	IEbemB68JjdR2wSx/qSS+4To1+qm3M4r3inAxJlKIULrJrQuJDaS0LvoZv8F55EidOo4nP
	wVt2M/zl1eMcxjoLcQz5dfVonVE+LrM=
Message-ID: <4672053f-c9d9-4694-81ad-9b5fe741013a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772194310;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A9VnUUVWt2OivEInnP/5hnH7A1kF+epUMtvXzdzCsRg=;
	b=G73YvlTItW/u/rHPyW7CK+7PMpVtGhIzMOv1+2p9NrT7k4zRVoaOf2NzDUgdgP0DB933Kw
	FryLANPcbvAUfbuhOq0PAoZA9+6fSEp1UeRgwgS84+HZU3nq7i3sqNUZ2hl1aMgf8gchpW
	Ttxn5+wmgqiIl17kKNPBrc5OfS3bRa0=
Date: Fri, 27 Feb 2026 12:11:46 +0000
MIME-Version: 1.0
Subject: Re: [RFC v2 13/21] mm: huge_mm: Make sure all split_huge_pmd calls
 are checked
Content-Language: en-GB
To: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 lorenzo.stoakes@oracle.com, willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org,
 hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
 borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <20260226113233.3987674-14-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-14-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E08D180004
X-Stat-Signature: nnypoj8wihqzhdg6uanf53h9gri9e51t
X-Rspam-User: 
X-HE-Tag: 1772194313-696172
X-HE-Meta: U2FsdGVkX18lKDrPw80LlMMU8qxO9CmAEBjPzc6ZnB3OG0kvXdGmRW95gEg0X34a+mmJOnpIY4CHqV6jgQ4BFHq0lRaSVcnylYyqAkwSCGJBM1tO7ewnkHLIQzwccI6jMFidAzLNCbgVRlifgpuSbmcbJFbuy2ukNBoKnRYz9oD8AeVeyRO+v5EcvJaRaZlcZaUxaVHkT3DHRETXDvLtmMzbPndtG4wepfDAcuUwIzRL4mALs1WmZiKmNU8s7N+pCwK0Ho0pzf7Ng4yk1W7BxjpGxIvzG4Eppo/Uxf0AKIIfB9RsAdHrWvGRakUzTqEVw8NoqiTpC200riD8sPwxhPCNRaW633kt/TmAeQSu35Xqrwl0s9DnBLzlncxOkO0betRGi68xSpL+jHiM56G4Y2XWBAW+QvmfeadTfRhpo5jm9VZRyp39uzEdHdzKvEXRPbPE/McotK/Vwh5YYES0iKcoX2HbuHeK3Ub2ZBep7yYIt7uOQWy6m/qH7qGgassx2KDlr+uXbltU2KYjjYxli7HIBxCu41HdFJvLyekgqCQy/nDOqyv6F7YoU3Ipom+DIzVXbP2fEY+vTVtpx7AEmr977V7ZR2aoKUj3kzXqhqk6rOPaxE/WUhuNlIU4JqKEf80FpprTtm/JGn/UsDxoRwwUgi2+zEPOZ9w4H7y6H+WV4mo+QACHSexSWBdx+ipwcSTI+E1gXZpiNnlKrGA6+M4H0p9fBg74XA5RhaIrROCMCQE37/SsoAXgQmSq85JcHmGeCAMODX9WoLGqcPi6ck/b0fw73SaMNPXsyTJ61GsBVfV2q2y2tDJW86vb8Ak7XN+3WE3XIo9GOHKq85a6PuXfhZY2GyKptTufGswnMusks9XbPi3T0SaH4cFZH1UjtQzI/Ykzo9hqgjkTUMN1SCRDqEzS8y1DabLGpJQVG6oPnr9D6NWCO9PCmsQWSk3xMlNugzs7pMnhEBiLlqM
 UMtCnng0
 UAItmEjEET0is31c9b1gjcsWL5c8PqaetCO4KMscPiz+pVslWNOtm8wHYxNP9pm8uONPVMsjVbBWD1ZvaWfexaGo/hlA97IdKC/z3ngZxfxMu4G01lygVAldQHUE6wD+c4WBPLnGpkonZSV8Ip/Zb/lNkiI22Tlnwy8TUHwJDuPr4K3Znw63lmGHUW/C69EjZHfRXBtXugFJOw/OhV1hf8WL/8Qq0oPn+5QJ7GeiSBDf6yJ142cQb/zBn9Br1qzbhlZdqUAbryqak/gZKPLMEz8JXBpharV7zMgCM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/02/2026 11:23, Usama Arif wrote:
> Mark __split_huge_pmd(), split_huge_pmd() and split_huge_pmd_address()
> with __must_check so the compiler warns if any caller ignores the return
> value. Not checking return value and operating on the basis that the pmd
> is split could result in a kernel bug. The possibility of an order-0
> allocation failing for page table allocation is very low, but it should
> be handled correctly.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>


Kernel test bot reported that I missed one split_huge_pmd call. I will include
the below patch in the next revision.


commit 9e1bb250ea8ef0a39c738cd4137ed6c98131ebb0 (HEAD)
Author: Usama Arif <usama.arif@linux.dev>
Date:   Thu Feb 26 10:45:35 2026 -0800

    mm: proc: handle split_huge_pmd failure in pagemap_scan
    
    pagemap_scan_thp_entry() splits a huge PMD when the PAGEMAP_SCAN ioctl
    needs to write-protect only a portion of a THP. It then returns -ENOENT
    so pagemap_scan_pmd_entry() falls through to PTE-level handling.
    
    Check the split_huge_pmd() return value and propagate the error on
    failure. Returning -ENOMEM instead of -ENOENT prevents the fallthrough
    to PTE handling, and the error propagates through walk_page_range() to
    do_pagemap_scan() where it becomes the ioctl return value.
    pagemap_scan_backout_range() already undoes the buffered output, and
    walk_end is written back to userspace so the caller knows where the
    scan stopped.
    
    If the split fails, the PMD remains huge. An alternative to the approach
    in the patch is to return -ENOENT, causing the caller to proceed to
    pte_offset_map_lock(). ___pte_offset_map() detects the trans_huge PMD
    and returns NULL, which sets ACTION_AGAIN — restarting the walker on the
    same PMD by which time the system might have enough memory to satisfy
    the split from succeeding.
    
    Signed-off-by: Usama Arif <usama.arif@linux.dev>

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca19..f5f459140b5c0 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2714,9 +2714,13 @@ static int pagemap_scan_thp_entry(pmd_t *pmd, unsigned long start,
         * needs to be performed on a portion of the huge page.
         */
        if (end != start + HPAGE_SIZE) {
+               int err;
+
                spin_unlock(ptl);
-               split_huge_pmd(vma, pmd, start);
+               err = split_huge_pmd(vma, pmd, start);
                pagemap_scan_backout_range(p, start, end);
+               if (err)
+                       return err;
                /* Report as if there was no THP */
                return -ENOENT;
        }

