Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96060C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F756B00A7; Thu, 10 Sep 2026 08:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9666B6B00A9; Thu, 10 Sep 2026 08:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E516B00AA; Thu, 10 Sep 2026 08:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 577546B00A7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:03:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E78411404CF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:11 +0000 (UTC)
X-FDA: 85197716982.23.3453F3C
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf23.hostedemail.com (Postfix) with ESMTP id 03964140019
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="c sNCK16";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=bKrmnTez;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041790;
	b=C0u2/8iWJgm5cSbxCJ9UvwB8ZsbZSPPkWj4dWbjo/b/jB6VlDX3PUn98OLDHCfb0iKy3Sa
	oQwkklfkM3aW5CBwYhpCy1lGOgBIY6gEqsWAzORNg4Q1KCm5GrSV8mV4N+xzPWZdvXl/S/
	VYAKKmIwqwPVhQCSHJL+lpPwTTEx428=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="c sNCK16";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=bKrmnTez;
	spf=pass (imf23.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpOrfAtuUuey4lAYKV0xF7Nvz8qXoEbNkfYNAyopBF4=;
	b=M35ibx1+Q1uK08OU5eEos4ENmANV3aZxFnTZNoSj2+Z8TSKSyLjnrcu0sJGhOfO76ywYCr
	IC9aLFgi7DgfnTtunjvhOxhgMOqcjf66aVzxKTfgCeR0AHAbpULHWiQc5bnWdzo4Z88KBS
	6kVWqDTC7Bslcy2b/NV3S2LOQX+e7h4=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 096237A0063;
	Thu, 10 Sep 2026 08:03:09 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Thu, 10 Sep 2026 08:03:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041788; x=
	1789128188; bh=kpOrfAtuUuey4lAYKV0xF7Nvz8qXoEbNkfYNAyopBF4=; b=c
	sNCK16CKEi2s5emKL1cvcwYx6Sa/NQ5ooLbF4lmvC8MhDw2wisf+1Ungv5cOmvlK
	WYjr3ckTr7NWzAC2gXbDJ6TW8rh3zNh6fd0dFNteb4GJBU0gg142EmvNzCIIUywu
	ROFZfhRDnyIpols8ofo9cTA53xvwdBa0+dCQCK+Fax9kX3R8GZZk5WfMqIsEb93O
	QcRR1HQ8dyEebWOtsudne8zY/uhZlDBWIOPJexQpOHSuKiLSr56sf9echxmGiW4o
	EsLvaBTTKlK77Hqy9sTIv7xhzR6uL7WQ3Ou8y6yIWLeNxugdQnFhGQjOn0D1o4ls
	XJRfcB4HUjK09XF27afww==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041788; x=1789128188; bh=k
	pOrfAtuUuey4lAYKV0xF7Nvz8qXoEbNkfYNAyopBF4=; b=bKrmnTezqC8+vQj/C
	xhJUHZcCchh1J1z3ldAQOj6PeZkDpbz7tSzdFwC2n67vIXCbEhGhJU8gL0NY93tj
	Ootw2wkgHaPYUUT6S0efB0T9QJa7wkcsMzxWVcGaKw/BnT4rbczTbhFnzHug97mH
	eUHiZ9NNL7m14Nja8DBUSGQe8x9zYA7qnVJLWkrkYIQFMLdcpHzivUzd33/F+xnc
	RIE6ocN965IDbRdLLFII/k71BCNgxibPWUmcq39v1gf4wvliVFa8PCHZHSQAmyIt
	5/R6Xdw8B5SRphYaxxs9FNkI8imC1SI/ki3UO0a/ocLso+ejlJJ8HzSgjS+6RQ6V
	UhfDA==
X-ME-Sender: <xms:fJyianPMAdW3GwhW0lg-5a0NGhIn8ThX7j72Kk9j_OR5tMM0PAguyw>
    <xme:fJyiat4dvMzw2M7RoY_ttErSoEHMHaf9pAMJmfMXe2oENe_WnZWjkHKc0c0jg6tA_
    YS_jfzxZvz7-97WU7M_11YFdFLI-kUB40YBtphZNkNpfh71anszqKg>
X-ME-Received: <xmr:fJyiasbHd_69_hsVr-GlMxSe85LoDmFIf0ReSW3RbLvP6GtcHAzYqQur-Hc>
X-ME-Proxy-Cause: dmFkZTGH8GFWwEUBtPxKJ67Rq2x/vdej+Q6nUCGcsDIesBFp0X3hc4jYyZuxmlnDOcFOMj
    pjMT1hhilwwz+XztIrpfsk+jOgPg51Zko9HtX5FOXtwZM/xuJUIPYajGOB/mCLABcXoBUN
    tOK7IZxc0LQBxYWwS3D6Gb3+L6Rzatr9ZhNURjEQibWJdyHQU+pHQvTtQJMa086Ym+yd6R
    IInk1eh8W3seorGmDJU/iV1zGzfJwWvedZT0VKJsUgZ7fACBrQNd9k3L4EzTZNF344phSI
    j6ov0R0Vo2eJRufAS9ocD/WtRYG80u0cUfKpHkiyow/cp96ftI+MA3MvYDL4cDgvN+YPme
    tp92wygh8UvLM6PCYZaDNz8msbrI5zSvPvb1pIQHvDWn9s3+Yn0I14Z4qCm6i2YJ5WJXO9
    Zxa3QdhU5laepvew+dp+2M4dNa1cHgJcn6Yrd+E7A2ncU09Ya/eisbEbE6eBK3l/neISFL
    XLLv1OBTXWjf/tIgacW38eVhc79/2zgtxZUvViJtIzxSKs9jhdd9qk6Qn6N+IfCie094eb
    MrWqU1AWU5364KeQICC4uA8zbhIidrwdWihtI9VdYatJ5LhfCnPTnd2t4RV+8VJuxxyiX9
    IehlICSYK1zeiTMF/ze/yFdZNVBmxEzCIqhYxb5+M1Oui8PZs4C8Z8TX9hSQ
X-ME-Proxy: <xmx:fJyiaiHMqfdgMbBG1H29PH5UnVyhxr8hf9mi1cE6WvotgZUA3WwqWQ>
    <xmx:fJyiatlC3dmZW10b1w_J-O8JT5RZu8ZRRjyoMRaSfuxmexsfH0zNPw>
    <xmx:fJyiahkIefiv1EEaCRzYFScty8FZvlydcCxnopYa_ZlkHcijepCxlQ>
    <xmx:fJyiaiUIevjvjrFKYQPzmdKaGMbcGYs0t0h-8fWOaChIFUrpI7uQ4w>
    <xmx:fJyiaslRzJDAVYGzxiTCcvEu87mSWyoLk11i7LOONedwIlcewRBPylGb>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:03:08 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 09/12] mm/collapse: open-code collapse_single_pmd() in its two callers
Date: Thu, 10 Sep 2026 13:02:29 +0100
Message-ID: <20260910120238.2529819-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03964140019
X-Stat-Signature: 85kce8ykrzm475sju8qj585mnhsspsyq
X-Rspam-User: 
X-HE-Tag: 1789041789-444473
X-HE-Meta: U2FsdGVkX1/Q0KEpuBId6KLEQWG816si7aHkhyNNdR3z+RQknALjptuzfhxyjDNAZpc17W2JUraNW5r+aICx+5WG3yY/vvEiQEQhYbWhS5oHYYnG2mBoV+qgWtzpKWYoYIR4N8jkqb9zGszDNUV8zwFw4rDFS/+Sre+R+3ehDHpv0RRPgm9x9DDZrh9+HkqMJLIQAMTy2CvHqu7hzJ+nqUpfqEhcySnEyY0G1Zo0CVl7bdHu9ch6MDdwVSqz8zrsBpOcC8dkVvnRF+1F/kaQzTmMaMlThV0pXJxk7DUy8PNX7qIRIBKBqRMQqK5v0ndGHWZnjpVnVzoHJ6tBkXvvlg2JHmxx4+ztgfEvhc6jhZVE4RrbZjGJP8EzNaJWmN67ggz29+aZ3f4wd9drrumfftXDeBAHIw9s7kVDceeKVl6UEAUEwlnvQuY8UEoVRZCIzAxmovhhC9lp21a4yaO2rIv1bElEbdrfpa2KAy/gUGMOA1RTebZRVXmc5mwNznK6HM6sqHn+2sLrhNGZFzObT9SVao5xfr/NCEyexbnvbCcM7toFAUnkNBB0Ix8C4NP/pEup+pVCbCRU11MtW/cMcu6s0+Flzs7G5GUN8W0XD666y1OXjKvZUUMyxkoHOk8EXUbQS8ngG3cmsTklzwmr6WvPwGMXVFWde5XqV/Q9dLeom8lq7qPmtW0/JivsZH4T1jCqoEn3jtwB1ayNiIgvPRzxTHtdjtXQ3Jv0mDPMplM++PCN8pweYDlyB714Twt8V5L3SpyOpH7gR/Hp+ru/VA+8HqHfsO5E/tcIJUZBrZJrCHcSVKTj9uwwgS0oC1h8ZTi5Ayfg/NWZCGTZLMvAgJgavLZjb3uGaSGXi/A3x4dtY1WuAyGMQ/1iiA9Db9aNt4wtc0hTD+3d0lSaX7bfPut5HKGHjR+wscsdlK8wMmGPsMjWxDe19ce5lFI6MJezFfrdUbzeNpErSAGWdjh
 iEHsLLf6
 o3gJgfcAPlHGjOXMIJKRTpbAeJ1GVWRI0++FI+azw+fMl+r3CGCMlaQ6Sda3T5KJSi9YMoLNWldFjTe+jceMnnB3+eID1R7neABeIneH2+K6IWghk02HmSVQZaYh5eI8wZ63ELa2u8+AJ6MTEXxxglBAzsI3phRpRbyXcxWmhoGB0mXuuerRoQhpFzQl/5EvEU/2gGycaNewVADsvicO7GR9OgXb9t4Mpw2Rscu6nt6Ic5yz65uiGmgY6Ow+eV0lsiEK8t3vYP5Y9whIOkckCvKvzkdZIYq6SvEqAXch0r7EV13tekz68DlenhPCa0c0yS47tVvlDXoYSm6nlxWHo1m/Ik76M7Gx9EUSNPlc6lrF1ZPrdbV7IzwB58nb5obf5B1Zj2x/kvTs7bdHGw1Vj5HvvpjnhFaOwXmAdxbX9iNh7VAm4AVDwaHzUIEkYafLK+rogVDrjlnfQuBj7isdgU8HC/1eP2jgzZ1bjokqku2bzbKk0Vja/0T+FWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_scan_pmd() and collapse_run_pmd() each have a clear locking
contract.  The scan is called with mmap_lock held for reading and returns
with it still held.  The collapse is called without it.

collapse_single_pmd() kept that boundary inside itself.  It dropped the
lock on some paths and not others, and reported which by way of a bool its
callers had to carry along and then act on.

Open-code it in the two callers.  Each scans under the lock it already
holds and, on SCAN_SUCCEED, gives the lock up before running the collapse.
khugepaged's lock_dropped and madvise_collapse()'s mmap_unlocked both go:
the code dropping the lock is now the code that wanted to know.

khugepaged's walk carries on to the next table while the scan keeps
refusing, and ends once a collapse has taken the lock from under it.
madvise_collapse() re-finds its VMA after a collapse, which it did before,
and now uses a NULL vma to say that it has to.  It still reports the drop
to its own caller, from the line that does it.

The lock is given up and taken again at the same points as before.  No
functional change.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 102 +++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 53 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c26907300c23..9bdf12128357 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2857,28 +2857,6 @@ static enum scan_result collapse_run_pmd(struct mm_struct *mm,
 	return result;
 }
 
-/*
- * Try to collapse a single PMD starting at a PMD aligned addr, and return
- * the results.
- */
-static enum scan_result collapse_single_pmd(unsigned long addr,
-		struct vm_area_struct *vma, bool *lock_dropped,
-		struct collapse_control *cc)
-{
-	struct mm_struct *mm = vma->vm_mm;
-	enum scan_result result;
-
-	result = collapse_scan_pmd(vma, addr, cc);
-	if (result != SCAN_SUCCEED)
-		return result;
-
-	/* The collapse takes its own locks, so give this up */
-	mmap_read_unlock(mm);
-	*lock_dropped = true;
-
-	return collapse_run_pmd(mm, addr, cc);
-}
-
 static void collapse_scan_mm_slot(unsigned int progress_max,
 		enum scan_result *result, struct collapse_control *cc)
 	__releases(&khugepaged_mm_lock)
@@ -2941,7 +2919,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
-			bool lock_dropped = false;
+			unsigned long addr;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
@@ -2951,23 +2929,29 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 				  khugepaged_scan.address + HPAGE_PMD_SIZE >
 				  hend);
 
-			*result = collapse_single_pmd(khugepaged_scan.address,
-						      vma, &lock_dropped, cc);
-			if (*result == SCAN_SUCCEED)
-				khugepaged_pages_collapsed++;
+			addr = khugepaged_scan.address;
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
-			if (lock_dropped)
-				/*
-				 * We released mmap_lock so break loop.  Note
-				 * that we drop mmap_lock before all hugepage
-				 * allocations, so if allocation fails, we are
-				 * guaranteed to break here and report the
-				 * correct result back to caller.
-				 */
-				goto breakouterloop_mmap_lock;
-			if (cc->progress >= progress_max)
-				goto breakouterloop;
+
+			*result = collapse_scan_pmd(vma, addr, cc);
+			/* Nothing to collapse here, and the lock is still ours */
+			if (*result != SCAN_SUCCEED) {
+				if (cc->progress >= progress_max)
+					goto breakouterloop;
+				continue;
+			}
+
+			/*
+			 * A collapse takes its own locks and is slow enough
+			 * that a writer should not wait behind it, so give the
+			 * lock up.  That ends this walk: vma and the mm are
+			 * whatever the collapse leaves them.
+			 */
+			mmap_read_unlock(mm);
+			*result = collapse_run_pmd(mm, addr, cc);
+			if (*result == SCAN_SUCCEED)
+				khugepaged_pages_collapsed++;
+			goto breakouterloop_mmap_lock;
 		}
 	}
 breakouterloop:
@@ -3236,7 +3220,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
-	bool mmap_unlocked = false;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -3259,25 +3242,40 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
-		enum scan_result result = SCAN_FAIL;
+		struct vm_area_struct *found;
+		enum scan_result result;
 
-		if (mmap_unlocked) {
+		/*
+		 * A collapse gives the lock up, so the VMA has to be found
+		 * again after one: it can shrink while nothing is held.  A scan
+		 * that finds nothing to collapse leaves the lock alone, so a
+		 * range that is already collapsed walks on without relocking.
+		 */
+		if (!vma) {
 			cond_resched();
 			mmap_read_lock(mm);
-			mmap_unlocked = false;
-			*lock_dropped = true;
-			result = hugepage_vma_revalidate(mm, addr, false, &vma,
+			result = hugepage_vma_revalidate(mm, addr, false, &found,
 							 cc, HPAGE_PMD_ORDER);
 			if (result != SCAN_SUCCEED) {
 				last_fail = result;
-				goto out_nolock;
+				goto out_locked;
 			}
-
+			vma = found;
 			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
 		}
 
-		result = collapse_single_pmd(addr, vma, &mmap_unlocked, cc);
+		result = collapse_scan_pmd(vma, addr, cc);
+		/* Nothing to collapse here, and the lock is still ours */
+		if (result != SCAN_SUCCEED)
+			goto tally;
 
+		/* The collapse takes its own locks, so give this up */
+		mmap_read_unlock(mm);
+		*lock_dropped = true;
+		vma = NULL;
+
+		result = collapse_run_pmd(mm, addr, cc);
+tally:
 		switch (result) {
 		case SCAN_SUCCEED:
 		case SCAN_PMD_MAPPED:
@@ -3299,17 +3297,15 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		default:
 			last_fail = result;
 			/* Other error, exit */
-			goto out_maybelock;
+			goto out;
 		}
 	}
 
-out_maybelock:
+out:
 	/* Caller expects us to hold mmap_lock on return */
-	if (mmap_unlocked) {
-		*lock_dropped = true;
+	if (!vma)
 		mmap_read_lock(mm);
-	}
-out_nolock:
+out_locked:
 	mmap_assert_locked(mm);
 	collapse_control_release(cc);
 	kfree(cc);
-- 
2.54.0


