Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8185EC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:51:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776186B00A0; Tue,  8 Sep 2026 08:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF536B00A1; Tue,  8 Sep 2026 08:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B076B00A2; Tue,  8 Sep 2026 08:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F6DD6B00A0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:51:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3D0CA065F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:23 +0000 (UTC)
X-FDA: 85190580846.18.EE25411
Received: from fhigh-a5-smtp.messagingengine.com (fhigh-a5-smtp.messagingengine.com [103.168.172.156])
	by imf08.hostedemail.com (Postfix) with ESMTP id DE5AA160006
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:51:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a iqeN73";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nMNQkBF1;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788871881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h96xKtx2qZMCWy32X4fzhVdoH1fDHGv4dS65yGYxxtY=;
	b=Wg6oF3Ddk5mFxB1c6HsWhriGbuwuGzuSYTlcZWt39mMqJdNvSWzv0gPdw5YH2FGI/6ZIm4
	AkfRyYYEhgHcBFv7xilo/vuUd1xkib6je8t64OSV5P5cqeLQsowFtfFR2sq5VtlrJsS/f5
	cVbu57m1skViIPW5AXcqEYBkmMDHUsM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788871881;
	b=BI6ebsRg4XdeJCdCDQG9aYoava0TPwBaSiKnkeIu4mW7CoLAs11VnLoY5SXA1EcdB6x14G
	ZHgqp1GfzdgUdV5fOS8fhgMMcXFO5s9beErFTWpclO6y3twGX0dYOk00C81chS4mo436oV
	oS2DA0qU1WsQ8p/ENAwPOolD1Y/HGJM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="a iqeN73";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=nMNQkBF1;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 741F91400094;
	Tue,  8 Sep 2026 08:51:21 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 08 Sep 2026 08:51:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1788871881; x=
	1788958281; bh=h96xKtx2qZMCWy32X4fzhVdoH1fDHGv4dS65yGYxxtY=; b=a
	iqeN73Q3dKFSnie6qlz9jWFOHG9/GFU3uqZz2jSA0DCs5kOK4d9KahljyVFG5tWa
	+9VtOPCTg7OBEE6eQlTtXY3+rIHGWdUbQXRnMJxnjVx+vHHfvMiWBpqHsb9ipiDR
	i+oFXrFOHEo1XDC8cgtFMdvxYg553WRP758fVzhZh7Q02TaHgm3iXug+IobbmNxz
	DpgsfoIawkN5x0IRb0sk/K5gCfzqMuRRmpkSF+AhqEHd4dOdT9Ep6K+zRI4gKtNr
	qn9K1tx4b2Jw4S8RQx9bPZwVelhsa2eLwDzMy7kRy2RYmw46H6piGQyfpd5T2pD5
	pJtiEL+7BIL+BhyZc+jdA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1788871881; x=1788958281; bh=h
	96xKtx2qZMCWy32X4fzhVdoH1fDHGv4dS65yGYxxtY=; b=nMNQkBF1KFhBqwPO5
	518Oshc+gkbjplnBAH/GmQddVYugrFDzFQNycNX3yvmHQADqlhm1N8K+vPiADFNe
	yqyk6y0TXVpA6VcTBnf8QLd3oq2cLM6x5ibOKUqAXQTK1CBHEV3TSKf+KG2GZ8qr
	/jnCEQ/cOBqKiBf3M8gZt4e1lAU1FdtXDkKCnsy/kQRAfnnGCz4lu4pbibc3Obta
	Ey4RDECzP4jhDc/1AhjhGh9hEj83dGG8xeRB+LgQonvpmbBJ687bvcTWq/hmzEbp
	NRFvgqOuF33nuFIx0ihHdLdhX7dLfmI9EzgsAlY2GMAXnX/BrXSVEzXd5RJG7Mu6
	Ubv1A==
X-ME-Sender: <xms:yQSgarfc-ozD7KTx8fSgNrE8Ye_xF1AUoSp780fJlvQy219Iq0d9AQ>
    <xme:yQSgapn8FP44oVGdJuvOeV2BUT6VO6SD91g3wUmrSqCNnI6lUcTYkhoJY6u_mbKl9
    c8weqomT7d3mitIE26_804uCxoyZlfXoy4P0AnXi-ft-Gd-5ABrabnx>
X-ME-Received: <xmr:yQSgamtbsb_PKkOsc-VARtP32Ru5cYhjwocxEvgd7jLBpDVh5HRam1dqKDg>
X-ME-Proxy-Cause: dmFkZTGuvEMc9jYu2f0uyTmUF7l0J7NybVdULRlrJFmokmmiolg4yH1+7h97U05D2w+OYm
    AZhWoHmMPT2EsIB4AC7PxRFoqN+CF4x8etMK41ayTMd5Tw55ZxqvSYpb69cNUy0p/dfOGv
    05P0JRk7g5kt5eTL1k2cO9e1oUb7lrROdNyUSbigYjG7Zs/tNKx+L8+9HHw+CSw5cJpWIQ
    j2DrX13NeCZvnLN36sWkEk/U0EX1Q1izKAtzdjMuXhus4PGMhEw3kJKafKZkgCRsnWRxXR
    Wv8osDa5aTh9mnjCTFnYcP83hQ8y7tmPYrDENim+Q79mFJR5sJUGN5QsCu80CUB5y6e4LS
    xzIxbC5h6FEB304ULXKH+UdNg/3/VZNGLdFKJEhyuZ37YXfrIEJqhw4AEPtVdO1Fsq1uD1
    ybowd4oDyqQgqXRwPMW9eRnmSHMA5yacNRdVo9Cg+0k5RhhScDbTnEfdtCCCT4sPsV5Kdt
    IEhRb1h68Nq4GbavNPr1vAL7gBeS/fUaJk5zyiN4layUtJDyU1apTBVeK2gcc2cG7LDEqm
    0iuRDQfs/yUtPTbZbEXO5bjMbJRF0NRK8EU1Ps86KKLZXej3EcZncXDp5EMY7pW1vuKomO
    oE2dMwQmIg7E4HnI81C21OYaUO9ajEDCuvdfB4BmTco//t9BZQCTmPbVLGzA
X-ME-Proxy: <xmx:yQSgakxAqPiSG9qJhf0_dHlkxq7Y4lP-VhbphB37QSWZoXIGQRLLvg>
    <xmx:yQSgapwRSYF77CLdU9VVeTu10a0cv7edsVI_ocsfBabg193Kw68kKw>
    <xmx:yQSgaq4GznkQT-QzdgS3dKsrXXZOJDI7YTMlt66lY14lU1WzkKtOUQ>
    <xmx:yQSgaiDWEqdTrkiRfTiu127zgN0QBHz8oS4P-4DJuMFAzP__KHjC2g>
    <xmx:yQSganOZ2b8BwNwKeofkESaOZZl97kO-3EJhqddm9Wjdak0gtWfCoQNU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Sep 2026 08:51:20 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	rppt@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	usama.anjum@arm.com,
	usama.arif@linux.dev,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ziy@nvidia.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	agordeev@linux.ibm.com,
	jgg@ziepe.ca,
	leon@kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 05/19] selftests/mm: make the swap cases' swapout reliable
Date: Tue,  8 Sep 2026 13:50:51 +0100
Message-ID: <20260908125105.1510704-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908125105.1510704-1-kirill@shutemov.name>
References: <20260908125105.1510704-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: si8j7hpnjoegcgew4bkqzsirp8rpc4am
X-Rspam-User: 
X-Rspamd-Queue-Id: DE5AA160006
X-Rspamd-Server: rspam03
X-HE-Tag: 1788871881-335966
X-HE-Meta: U2FsdGVkX18w/2R5EUm1XBKIUBocRHN1G1PsDnPzZLzQUO0n2UIQV/CgJxhI3WOYLeBoHW98UveyD6vShci5WYuhpcpR7qpW2OvEMfNvp971vHjWBycZTOPDhMaEjLFuWlAJcAc0LKgFTKeuGqd6TgHJGvNM0kMikbcTS/dCvN+AGA0mr2OJ5DGhZWJWGgU1cnElsQUa3+Ck7votrHdJmlmF2a3N+wm/rqSP60hJkf3/sIWQuR6BuVAOP0RspTp5VnnHX9SFigByCt7GakAIEx1MXmjtUOTdxtNMCOkltd1rUF7FZeL4e4K6rADpRz7vkhbRF8wgaSNo62koFUsB+UuU58c3YOi59E+pAKZlnZdtg0DKv7HPbsn0o8SFyDwYGYtacQXWT4EHQdb04vlkFXoTQWl1cUzFgHrZZiS/GTL27vY9nhR2eC9DYngVXMAPT6veQ6a2DQB1ARm0kNlJmVSopEaZVS99PsOvzoKfKmF0dclUFC1oUcz0VJnnvWS+b+BrROHbeKCMPos0ij+9HE09pZawo0+MVaQn3ubj6c4FMUzqSU+z7LED8R15XcuDjAYQc4K5pxy3YlLV94/8yo82rCJmxwG0q3vkKOKN5caSSWsrzymtl+AGKAOS0s+C98Oi2Zp0aVu3y3tO1OUWLS2Pq4GUIH9pM/0VuRsfVae+15ENBEU0EOLmQKC/mms+EZnxP90i9HROEqa/p3AdIgPLTdWdLj41UuFskOkSxFTCxKzIRIYxSNguBiGc06VfknZiZNJ1uVnMJ/2VoMGyk+9Olhv2/GdkmGWL2FMApt+xP6xhf1xCdAX1aRgs+FXQJnt7Jsoz6I2VPjY/ocN9NIFrUrFVFLaOqy+NGSvF8CQBoqGMgLcbk5iWinKumZn/rGEbUPqRbECzaCyXvB4N6VXLCm0B4VLmbR0k6tz9TEcWN17oi6plOjakKoBLmlXBLtCeiEq2QYQBbryHHe4
 zyTeCLwG
 6t4pKFAguAr3ATo90wAzOgRfCj9SJ0Q8KkfVisAarjqEYqidlAIuEiQFHPBGq3s76CltseJ3I3Y5ok3zBkFBr1a+QefXvXURc18Ylat+AuzN7sXEi2cg10KlWsdSuwb0Ezftqb5gUSTgtcSc6Eze0cQ2CVa3XjHqGTAoj5sC0jUBGWO2dP8fzW5cupB9ne+eDHFrTyGvPsTuYBS83J1S1V0SqI+EDCqsER4Qs8K6PcJXIZhgxhytWvSqZg237ScAzgCzUv1THN6PdsxQT9++H5Lncg5UPOm84/Lw+hOWGwr4DvY5Q9NKA/u8sY4YyxyUTK4pYM2uDSm3UGJlq9bZbYavVzeYaFMLSgmbaAC1DWFGRH+Hr+Snw3BMTj7NNrytwzOVEn7EjfTBle97h1fndhXHXT/s8ZRRcaO6/ce4Mp9mHAsVxOEwcrxrmTMKDomlhXN/ckD5KvVLJ+DcxHmN7qln4WnmrIfSFmzDeeYRTSnwbQEXGiVzYGQovMx1FpnB+JFrT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_swapin_single_pte() and collapse_max_ptes_swap() swap a range out
and then require smaps to report exactly the count they asked for.  Two
things keep that count from arriving.

MADV_PAGEOUT is best effort, so the count often turns up a moment late.

And wait_for_scan() leaves the range eligible for collapsing, so
khugepaged is still working on it.  Collapsing reads the swapped-out pages
back in, so the daemon empties the swap as fast as the case fills it.  On
arm64 with 64K pages max_ptes_swap is 1024 pages, which is 64M a step, and
the case loses the race:

    # Swapout 1024 of 8192 pages... Fail
    not ok 10 collapse_max_ptes_swap

Retry for up to two seconds, holding the range out of khugepaged's reach
meanwhile.  The collapse each case runs next restores MADV_HUGEPAGE, so
only the setup is affected.

If the pages still won't swap out, skip: no swap, swap too small or full,
a memcg cap or busy writeback. None of that is a kernel bug.

Assisted-by: LLM
Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 41 +++++++++++++++++--------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 73bf07c39145..398430c33872 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -220,6 +220,29 @@ static bool check_swap(void *addr, unsigned long size)
 	return swap;
 }
 
+static bool swapout_range(void *p, unsigned long size)
+{
+	int i;
+
+	/* keep khugepaged from collapsing the range and swapping it back in */
+	if (madvise(p, size, MADV_NOHUGEPAGE))
+		ksft_exit_fail_perror("madvise(MADV_NOHUGEPAGE)");
+
+	/*
+	 * Retry several times because MADV_PAGEOUT is best effort.  Sleep
+	 * between the retries to give outstanding writeback a chance to
+	 * finish.
+	 */
+	for (i = 0; i < 40; i++) {
+		if (madvise(p, size, MADV_PAGEOUT))
+			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
+		if (check_swap(p, size))
+			return true;
+		usleep(50 * 1000);
+	}
+	return false;
+}
+
 static void *alloc_mapping(int nr)
 {
 	void *p;
@@ -823,12 +846,10 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
 	ops->fault(p, 0, hpage_pmd_size);
 
 	ksft_print_msg("Swapout one page...");
-	if (madvise(p, page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, page_size)) {
+	if (swapout_range(p, page_size)) {
 		success("OK");
 	} else {
-		fail("Fail");
+		skip("Could not swap out");
 		goto out;
 	}
 
@@ -849,12 +870,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 	ops->fault(p, 0, hpage_pmd_size);
 
 	ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap + 1, hpage_pmd_nr);
-	if (madvise(p, (max_ptes_swap + 1) * page_size, MADV_PAGEOUT))
-		ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-	if (check_swap(p, (max_ptes_swap + 1) * page_size)) {
+	if (swapout_range(p, (max_ptes_swap + 1) * page_size)) {
 		success("OK");
 	} else {
-		fail("Fail");
+		skip("Could not swap out");
 		goto out;
 	}
 
@@ -866,12 +885,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
 		ops->fault(p, 0, hpage_pmd_size);
 		ksft_print_msg("Swapout %d of %d pages...", max_ptes_swap,
 		       hpage_pmd_nr);
-		if (madvise(p, max_ptes_swap * page_size, MADV_PAGEOUT))
-			ksft_exit_fail_perror("madvise(MADV_PAGEOUT)");
-		if (check_swap(p, max_ptes_swap * page_size)) {
+		if (swapout_range(p, max_ptes_swap * page_size)) {
 			success("OK");
 		} else {
-			fail("Fail");
+			skip("Could not swap out");
 			goto out;
 		}
 
-- 
2.54.0


