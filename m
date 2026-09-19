Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9055C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 00:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD12A6B00B0; Fri, 18 Sep 2026 20:25:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C811F6B00B1; Fri, 18 Sep 2026 20:25:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B513F6B00B2; Fri, 18 Sep 2026 20:25:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4586B00B0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:25:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0787BC015F
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:12 +0000 (UTC)
X-FDA: 85228617264.07.ED319A2
Received: from fout-a1-smtp.messagingengine.com (fout-a1-smtp.messagingengine.com [103.168.172.144])
	by imf18.hostedemail.com (Postfix) with ESMTP id 12E8E1C0004
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:25:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Q K6trjx";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="okjo/XZx";
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789777509;
	b=YBndlmjTr0et5FWQvniGjEc3BpScddIXI95xHqzx/z2T4JcQUkxkTdU+1OOkhkvmiSRv2W
	fTfaokP9IJVxnmI/2T85EDw1bWeuxnWIP0NE6Ea/OrhquffNHOV3qyXtFuYu3ZwgPXc3Vx
	3ch8oWetfMypT6P/DJII+fT8PP29+cE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Q K6trjx";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="okjo/XZx";
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789777509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0jxXZ932RTloRPkXJ26iTQ69+3zOv0gA9f87bGPUF1Y=;
	b=dhDle8d6HSickvQ2u2TMBX8RoT4yu6iEf9Voa+FqdxtujD4wJi4B6KaosIX5siFBH1fjs+
	Zw6yhflJtE4DMME5OCKI1BtHerQDLGZf0cGfXwkVFe5PmldIeHGHLtjX/J7znCYUHCzSiL
	/JwtmLIpxPbTtHkavHxrbTDe1pmxImY=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 8DF9BEC01A0;
	Fri, 18 Sep 2026 20:25:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 18 Sep 2026 20:25:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789777508; x=
	1789863908; bh=0jxXZ932RTloRPkXJ26iTQ69+3zOv0gA9f87bGPUF1Y=; b=Q
	K6trjxA1vG1JZ/W8coRdqkfpWyM7J20BUChzzZo376iEalMb1/yBRYFSfm3J2MgA
	aKDB6+vRsZljeBE0T43fZBzaHRNG5W+HtZmx+fkJ7Fgjqka9klZPcBWAJRGUkpMN
	PeQbOt3Ypu/xl4uwhAMeUACvoWY5AbHzJjeNpVkEylYN1ibl/siIBK2p+7dV4OPk
	1/zkUaR87Pw+ILjEK+CGAAbHfxrVJebmtBWowP7WK4zQCbdIblYHBkvVFdsLqV8i
	NzgQJuhLED39AR1vG8gOyOAD43cLavsqpq7HljSGwfjvzfzi7znubjoEWrjiC35t
	2RN21e0qGVwglFoIJ6dHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789777508; x=1789863908; bh=0
	jxXZ932RTloRPkXJ26iTQ69+3zOv0gA9f87bGPUF1Y=; b=okjo/XZxMMeDR5lHq
	JfCHFY+gIsfdka8yKm6PiF+WLXMeE19SdTPTAi3zxsVGH3E8EaEfzIe+8DtOpUbl
	qi3DUkIzZLn4ynGlpKoVRLiH/xuAOFxFVemms/k1vUZGdk26hKmk5w/nM7AhlZKU
	2zSy0cgCPOpmTy7DxYg3a+dG2uYMa+fGkRq72sJ6PkJWwcLL5BCxmsyLv6oyZJcQ
	+LH4CXmjV6R6px7RGAYnrqRtFSxmKmmDn14cp1vflO8NVgYEzLAIOPoFoLnvnpa6
	byXNIdGcV1M2VdxQaA8v4y2WG7r/RPinfRvVGhJs7jA7IIrXnhiXMhZg32uA2j/k
	L0bmw==
X-ME-Sender: <xms:ZNatamJupdE8vMTCc9UXdPO-FPJNgk3fRhcdPxHZXT2wkywMkG3yow>
    <xme:ZNatamikOA3AXUoDz9WiPHKgupdtZLL0qtSz075bm1jHmH9Unvwxh6H5omhbXjJA8
    m-PxaK4eDEPUMAKu9-hR7z1jVba5ghG9sO5iqqPJSJIXH-TCEZUEV8>
X-ME-Received: <xmr:ZNatao7Id28xLDR6HRvCrzlqomqV7EnKx6ZTJnR5rZkSa8r0POCFNc1jT-c>
X-ME-Proxy-Cause: dmFkZTFyC+XeKYnZ766rqTYe4SsoatN0doBd7ADemiperjFlmE10ggdkgYpZeWmNOU4aBc
    lm02WEvCO2QGG+A0SGXMzCjVWjDSVCQ5WJ/xmSMbLZJLqVjt5aEnrGd0hUbHPJ/ejcqjFa
    xrmYY/YNxh9EpvRrTjNMqslNp6oZ1XKAjj0b9YUD/U+Umt4HJhNRFStrIx7jR3Gf+CAD8k
    /TwEvtSve0+WgA7utVqBt9LeXDUSIUkf7dn/1M9JWIyORT8Kp2cNKrwYutOzK/Z35sBm5S
    qWNICJAq9yYROUOkEgx1cQSYtjkPP2DMZwKGXS3JxTiE+xMdBmJUepOSBHs3/DvnVTIMFK
    gChYU2BEFFB9NOF1vNFE7k40lrB57q5k5i69CWvfmdsQKgad4bHeO3w/G34aFpcNwxvZGe
    ufJ1PCPrsJvoR2vup6W1g+fn0IkEMfRA6RUqWDjWoOW6hqdvB3U+zwIUdoYlJhLK5arfDX
    LJiqlHH+P0e7oXO8WGzpoqUmdA5LXT4pc5sWKdCjE8FpUjM8z0X7M1nYUIpQEI59TyEN+D
    esLRpRcwcZdpOu8A47+q8O+pQykY29kuTM456oHHusrDmTikzbG9Tfbid2g5c4noHAsuOT
    gy89aAeKZdFV6BEEx2YfQuDRFo67aWXGhOpI0SeNlPJV9a7GzSWOMqN4rEgQ
X-ME-Proxy: <xmx:ZNatajMqdgy9i24lfJKwANyHtLHHNSfr-ghLsF5FVs7wVBDscvZuCw>
    <xmx:ZNatavcyD-NRDZjkOIl71zkKnp6ta9HSpFA26AAxUIHepPVMZoA79A>
    <xmx:ZNatam38BcfJtmeWqFZHm1dJ0hofwYzhl-cBU2Y9IL_uGewtqTXlpA>
    <xmx:ZNatanMSxPyGvEyDDGETfCdDoOMDSjzT_wSRogMm1WvrKrfLxeknOw>
    <xmx:ZNataunTqQCeC25dD9HYralZp2xMeyvAR9ngW_lJhYxKmiWTY_pfkbc4>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 18 Sep 2026 20:25:07 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	Usama Arif <usama.arif@linux.dev>,
	"Nico Pache (Red Hat)" <nico.pache@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Michal Hocko <mhocko@suse.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	kernel-team@meta.com
Subject: [PATCH v6 05/19] selftests/mm: make the swap cases' swapout reliable
Date: Sat, 19 Sep 2026 01:24:35 +0100
Message-ID: <20260919002451.496763-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260919002451.496763-1-kirill@shutemov.name>
References: <20260919002451.496763-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 12E8E1C0004
X-Rspam-User: 
X-Stat-Signature: nbyozkbe6f3ph5w9hmm1qti9hcypasa9
X-HE-Tag: 1789777508-350269
X-HE-Meta: U2FsdGVkX18IiKeAeMpRSxtGYK9e3+AOmyrrkNLbTPQE+lJHE9h/6CWF0sfmewIXambRnbIN5IRprm36mzafzWlwLrMlrokuk9bb6YrXHhDEVE4nfJOUKAuNfkRZ6/78L7AWcEzFzOYehtpjQ1Z+bH/nC4XHhg1OlYrWylLzCbvkuJX+4HfFUIanLGvZdbg3LcEDrdfMloPN0WA6v+NuZ/bsGUY1GXXqNrvgjckQWTPNFRAtfSYCjOeoehPNwgVmXGrOUuPpL0qLoWhbr9M3MKKcuj/Eo1CYKsKDc9PKwM+yhjZ3+kQiz0LAKaBS0phHd6C2v7d06nHC7aF6U33LyC3GU3mHD84LC1g0QuJcpVbhjPoGILoPgenv8SGR7UNnmzTRBTALB6KX1+vhIi7JoKPpLtkwLlsaUMfwnoHW4T405+R8ZbDGzDkcer/2UssDZ6Lg3mush0s7h1U+6WdRTY0Z8qOaYtaOZ+q3+kHICaR6FjDmBFRoHn7ln+oDVwLFd+p8H22ytSNp3+KV/8Rff7c+3Fnofrbl3tD7+q7m9NvtRV6PECP+2vkaQM0/C5+PeIboRb9D0ZS0xvJBDJKx+C9sXf3ofipz2Lf6CYrVYP3MJj2u3Zd2A2aCh6vp4C5K2KTQWRBCZYHn5aV9Xmg4ttZFsTRHM2kTnGN/0eHULJKR/APDw3I34jTbX0hDfrQjntf4+fyEwbpqcE3jhRX/s8TwLoGNMfMNb5v4C1FpnzMQhZSgehrqWbjIzU1L8AFLVRx4n0Pw1VclBZx5th22PZubHp8UaK/ZZAAVFrQTN6ATGRjGM5tLw2ukoPRMOw14BQxUr3mAAsr07rYIsG8UsVsuGzjF8x7WzlbmxPcxsV9/0ZZ1+So5Hhlu0k76Yt3BlVkB46Rrfz39b/l3xMBQfJFBEYYwZ2uixF4yqXDzbigasL8MV2KSF9QUfOwY5MypxGNsJ7/8ycqtuPEa1Px
 FKOTLUx2
 9BS+aKPjRAfjeIXQoZRA9jfexsVi5RyL8lt0RYfPgP/216dSLE9e3cyoHT9bpebq80eNAVaN14wpmeVoh4qxS3ib4s6xMBbBsLqSIDnj7lVt6T3ZVqXnweLTRclPoxpKlEwnyVPEAcKw9koILk3lqT0CcgTXCPGZmk4LXZTWBO7ZM/3KZ3+MtJoqcxIUmnUAWpM9xfxz53BX2JpA2V6uhXmZcPhQxCnSl++bdsGNLrW3QTfCbO6ndVpytQ+GN94iK2wmDXglPYv2b36fYywu4Zx/gXw+cEFzwcOfqWySq1BDkhQBqh6wZ0dvt6bKmkIHV0BifPeXJfprMsM1o/0yac2S+i9NMAhzurAchY6ThfFSiZIVijQskTqoEk7VHEEpyN0giJlI8bMu1jjHKJY+h8qAklGcc3NkmeLGnxhUQorzRRDnOVrSsFGprBbdh8OMN0xI8P3C7TjSvFc7H+lQuXZWAN+a1StAtIPCflFrVQknwtTnJ/gZsACb8vPD2BQakQm/iQ/NOZNGcy9XNbKDulD9Hng==
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
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 41 +++++++++++++++++--------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index 5318f3cfc0d0..13a2a47ab110 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -221,6 +221,29 @@ static bool check_swap(void *addr, unsigned long size)
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
@@ -828,12 +851,10 @@ static void collapse_swapin_single_pte(struct collapse_context *c, struct mem_op
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
 
@@ -854,12 +875,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
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
 
@@ -871,12 +890,10 @@ static void collapse_max_ptes_swap(struct collapse_context *c, struct mem_ops *o
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


