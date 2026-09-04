Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F9E9C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 15:11:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5093D6B00A0; Fri,  4 Sep 2026 11:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B6546B00A2; Fri,  4 Sep 2026 11:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CC906B00A3; Fri,  4 Sep 2026 11:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C6AA6B00A0
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:10:53 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1580E160169
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:51 +0000 (UTC)
X-FDA: 85176417102.24.B777DBB
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf27.hostedemail.com (Postfix) with ESMTP id 44A6540010
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 15:10:47 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C dKHiZy";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MqMsJWDE;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788534647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nQCmOK93ZfCpG7MK6pnmh6In4f0JqXwsy1QQOqdTZ8=;
	b=lr7mTPNyaiFP3quNqPAxJ0moI7q6kOkeIPcQyJ8hPZ7ZUbvRclYb8aEjBC1VCQYJpM3XGv
	mkq2lDsaSVJv5iX+OC2Ta5kwPoCxEK157tnXGUgm8laNR7kq2lSamRagWHMvrJThlKx4C2
	JNVclOdxljuMgaMuSWGUEp1jTmHcHzA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="C dKHiZy";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=MqMsJWDE;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788534647;
	b=LL0g4DZff2nYfPY3lW5xV+mMa8XGMoEDTpH6G7B+Cmu5pxyH38r9trScIpKaPSBbE8alS3
	Zo2J+DfVT5VAaF8qC9lWlJkbM8dziviEPNNw4W1951JZ8iEsUMxNB5GEB8IkjRBJfApXLK
	CXLMjeNGFWnfLXlC3OkL5gJ2e/CGfmE=
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CAC651400112;
	Fri,  4 Sep 2026 11:10:46 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-07.internal (MEProxy); Fri, 04 Sep 2026 11:10:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788534646; x=
	1788621046; bh=/nQCmOK93ZfCpG7MK6pnmh6In4f0JqXwsy1QQOqdTZ8=; b=C
	dKHiZyrzPXIps9mN6Qg7ZWt9rYjOQOTeYliRUbwc/M+W+2PHBBYT3l5kxMvvUCK0
	QQp03m5WWb2JbV55xWX7db34PbO1CE7MDVLC1nL6FAe2K99KRj74Xzr4U6zNJPzZ
	YnqaeOzmGMXzLavDe4bpcegdEJ7ai11CC1c/j/IMXLf8dJ1XDH/HSf0Iae2YiCZ/
	cQnxFnqHW+5mEkfcN0x0NaXwX126pthldlLLtBaZwJe7bmWgAQ95daJKYG55PTTK
	fQqLArCJdRXDz39bpIBttkrDK+OUBdGuyItKplKtVxwewPAAc6AsZD831U/D/jBQ
	LDPlKQqNOzA6BQfRMGicQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788534646; x=1788621046; bh=/
	nQCmOK93ZfCpG7MK6pnmh6In4f0JqXwsy1QQOqdTZ8=; b=MqMsJWDE7NQ/l8FT7
	3vWLoZECCXH4g7lgrfDtnIGu7KBYAgrsLaXFoo4e+fHN8JpBi+PNYy6buj/6gq1K
	RH0P7Z+jbr9Q4Kz3IQlchNBZh7dh6X8CVIv81Y/zglLstLJa7cLDljEXdiEITPWM
	TX27VGRWzm740JBj5yOPHiOeE1tt6gqQZjbxuKPZ253NYryXzQMdPJYmTe6itb63
	by2x61iM2so2vdpdvBZxqCZjDQdpQFPlCvCoraUsAJSeSuV7j1h+CS/fJ8nFmpRq
	pKNSN2AFj41RmTyIErk8OCmX9clFnNeOAPAf1kzgXdpOl4yr6oU9povzGmf5LWrN
	Zz+Rw==
X-ME-Sender: <xms:dt-aat-WyIPFId85m8Uk8AhSyRuOvaOnhRaB23BxRQJ6WWZqLHAQXw>
    <xme:dt-aatpVzRSt4OHv2N7BYgoY-BHuqyuIRbeYFIauDGth-_CLttNNsgfRe-21f6HE_
    3BLETbEBwcrqy-a2xH-Cfmbc7deHCNF1QBYUQgMry3Wla7ZIVzD2dPv>
X-ME-Received: <xmr:dt-aahIGaUqslpzjJA-vYYd_hfVh1gkf7wvfegzh20uu9FxfBeLXxd7Dk6w>
X-ME-Proxy-Cause: dmFkZTFdOocfRN4jOpcQf0AqfSai/YCGo+xlO94MLvzn7lqitof50EENUNEgJzLPt2H+RQ
    DWgrwJL5dg2BaLkWQfjz0w8mX09EzID7A24sM1R0CcrzJ0aCsxP+pgO1accdG5RnvXKoNP
    Qi2+ranCgsFBQlrx3RUM64Xgm9l9zr2TPWbzFNtan3mUwkVlJ/gBEGXolzLuuMZ3CJ6e8L
    gmzum6oDDF3av5ecJE/wINba64+XlYa/U9oL8c0Dkr16eu3wp8w8wOsHTRTsCgO4oV0meO
    0fb7rtZliPO8XPlA3k/rGcTv+01JWMnSe6fG3OACTE4UctUjoP9cM2YnBbUckeF0hhckhT
    mcMOmV1mEg5NTO+Vk1Ef1mEuAvCQJhoLl/JdUrkcZSNk4dRWNiyxq5mrUlNNzYFkA21dlA
    0jFgqxhYxnVwlrsjm3rpTztYN+kKkNf4CIO61J2MJ1HoVSooKtsQ3znJA2hOepZl/kxg5Y
    JbljyLOXRzfOX0SZkLijl6kXPnOt637ny3/enMKBFaaTEsPYvoUAwkZPUNQs5DPbf1UcQM
    yndtfQTRsA+XhGFed8nRmDe7Au45EKl11FbNdjzZZo4CukdX5gtqcd11A05vO/uH6754sb
    Zd5k5cbMDa7FhGGCuFwsZ6NHb65p0kdvShdZHdsDtfNA39yXh1fCoVgBSxbQ
X-ME-Proxy: <xmx:dt-aan2aaWEkT5R_TbVzNHJLKdt3Qc_mRyeTfhijWKXhmseJKxnGQQ>
    <xmx:dt-aagXIvjgsM5GiEyI6yJs8mHmHIaYTzB1iNW5EYL9W_pbi77QxcA>
    <xmx:dt-aatVDtOgqNM5wn6XsBkOr549iGuzhlniukYXe7_Oubc9JCQR-0A>
    <xmx:dt-aajFfrZIJmuqxNIuxAXgskMlFT1sRFye3kZJVa9e3hj2QyJ-1Hw>
    <xmx:dt-aahUUwfELkbwPn4-F18i_dppVy1FkCwhZ_hX5JGKpAb2O8OVVm5Nz>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 4 Sep 2026 11:10:45 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 09/12] mm/collapse: open-code collapse_single_pmd() in its two callers
Date: Fri,  4 Sep 2026 16:10:23 +0100
Message-ID: <94aed028401ac48759eb7d056e451dbe50c1ea32.1788533997.git.kas@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1788533997.git.kas@kernel.org>
References: <cover.1788533997.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: cjt1pkpxifw3dnqzgh5nbaktaue94sza
X-Rspamd-Queue-Id: 44A6540010
X-HE-Tag: 1788534647-841734
X-HE-Meta: U2FsdGVkX1/M3rbYb6mh7jw85QwJiX047ehpcy+g4l1pGIn24O7nJu1SLN/ZEhgGmbindNQqsSRiyDWWi4L6cYWz43wxT38qXPJDbhpq4WsO6mPcCziDyrtujmWt5URfKqLXww4HLmgHbXgdNGDxunjUFaVpgwwqTwieSRloD+tCKYw+i41FVZaceB2kmcymqgiK2OydV+Vr9fhGclaE+PWtCvx4W47QMMD4zt87+I8R081TvAFoVHpZgov/tozL1CINoaAV0PBi1WZxClHu/0nNofw9fpJhwi0+Wp7Js1uJqDP12pKJuaQY3k8eKxH6D1A1hFGFYBeMrvgB72tJ7ytvXJ8y0sWovkiC5IE8bB7VvBi0yCz9b4to/UGQV02bqgn2Tw/a0Rb7oKupAds50TMy082mhAJ74ETM3ZLQ+HU0OcalAayqIKy532SD2f0vYsT2Apk1YxxzsANtHLxXuyudnUb63ugbRnSsqs2tF0P7zQxDPCKl+1KpXwWue5DK63ni+YGZ4pXMWCzoAgEzj1728Feisvz483X7lF6BPbNIb1VNHwzjyfBTkKZWJL6p6Oijon0kAMfpHSbuAJY+VyxL4OZ0NCiTr8mHWtuRJGZaY7Xk32VHRqgJARyNO3Pawjd3SV6X0mA39B2E5xiepLVscGleTXPUzoFXN3HBTvTE/Yzjo9bmIvakFuhzpNSUUbYfsTENFFtuK7B6ycM5QHpvUheoCUKIX2CU+ydCz878VOPoMlm/feFz1wRMqkT3iU5JDTZe7WL+uvuniLECGcjflYo4i+BSBK+MkU6zxhCIzotsMf2vTi3PAQ/yL7WC10Sq2w+XYDDUM8KcajOEZ4Ewj4Sk0U7c1JkrMBV961njzoZD2NbGSm+QtVYdlBUbcZQX3M1ukDWF31gjOKMMzLna/GM4IeOXwKxiCURTeiGN/GZSqlnq+vfQ1v5PZNrqeX1QyIYMwMFRY7FFZkJ
 5W6AGDBW
 CxM4jhqpWpW4tUywwuRTClmN346BBve4kl2LxUshItanB8JJPjfx6rgj0riY6+PO1aADi2zJbTSP4IUoXudTYmTXR0HsAYaDWIGxhicMe4ALjXnOoDrNHr/95kEuh2HBpNNoi4HtkyjiRSAJP4wLIwza/ejOSnf16dShlJx6ec1TzKBC5q1j6+TFt/HmtlM5MFKJKg9h3RAJqNIWWmfEVzE5/fuXCcP5VPg4Wj5AWYmeZtoolRTExXSDEYPrsCjqMqXkF4/11A0Gi54g3q2kFCSxZRmYPIqIYCgXujRnCAfYsufgQQpOS27hh72GJAq9rtxgBa80c/MpsTWtqNvP2WLqBSAd88TpKOgeLtREOPwGqWP8h5gbsGn2zuQigV/3/T+Lbkg/cneM1GI6YBMRMY/qPYiyDMnUy3hS2OB/4tBcdJQ8vVhtqwPuF6w==
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

Assisted-by: Claude-Code:claude-opus-5
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 102 +++++++++++++++++++++++-------------------------
 1 file changed, 49 insertions(+), 53 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 120af57540df..40fcdd4f2712 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2838,28 +2838,6 @@ static enum scan_result collapse_run_pmd(struct mm_struct *mm,
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
@@ -2922,7 +2900,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
 
 		while (khugepaged_scan.address < hend) {
-			bool lock_dropped = false;
+			unsigned long addr;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
@@ -2932,23 +2910,29 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
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
@@ -3217,7 +3201,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	unsigned long hstart, hend, addr;
 	enum scan_result last_fail = SCAN_FAIL;
 	int thps = 0;
-	bool mmap_unlocked = false;
 
 	BUG_ON(vma->vm_start > start);
 	BUG_ON(vma->vm_end < end);
@@ -3240,25 +3223,40 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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
@@ -3280,17 +3278,15 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
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


