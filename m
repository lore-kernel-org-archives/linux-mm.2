Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11EC4CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 12:35:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38EE58E0014; Wed, 24 Sep 2025 08:35:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3189C8E0001; Wed, 24 Sep 2025 08:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2074F8E0014; Wed, 24 Sep 2025 08:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 090BA8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:35:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF61813BC5A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:35:34 +0000 (UTC)
X-FDA: 83924089788.30.1D71512
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3A16C1C0008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:35:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758717333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LySa7PtlTpcfiu9tjClKhkHXaYxq88sTnun/1WdWMRM=;
	b=2NiFrsn3fNC7vV7mdOCfF/i5qz4PfYveZo5LrD2a5yPEPVJISX4CAcJkV7drJu9ZZ6o3Xb
	ZppQXR3OWerapBuDrQVqYIyitELcMpyTqYU+Bi504W3BP3jcCV1lzD4zTizPXkFemSja46
	0k+dHvtw4tQ9h/ZpqUG7VcDWYmMYR1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758717333; a=rsa-sha256;
	cv=none;
	b=k5iUJZQfsqK4NMgH4LZgRA1lwTT0SVabPuiqiG1+uE5V8h2orfUNM2MYRH9gMgi2o9ojAT
	VpwkOGHAn+wPN5qBGoJcZ2+Zb4DAhrliXfBONOXA39syDA1RMDeDRK3numUvi8ZdSO4CZa
	4plpVkVjpQSaietTAAmoF1JlvufBCyI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F56D60097;
	Wed, 24 Sep 2025 12:35:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3612C4CEF7;
	Wed, 24 Sep 2025 12:35:30 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	Gergely Kovacs <Gergely.Kovacs2@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH] arm64: mte: Do not flag the zero page as PG_mte_tagged
Date: Wed, 24 Sep 2025 13:31:22 +0100
Message-ID: <20250924123528.1536835-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3A16C1C0008
X-Stat-Signature: zc7398wdjbtpod8487ecw7576fgqbiar
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758717333-896731
X-HE-Meta: U2FsdGVkX197SaePj35agqLEA7aueqEbuzNeMGkKh82quQgZXGhI5IR7P6NEx2Yv04UR3xdAj1t0xqGXG7zIWp4p/22AAi7DlNQKGJTy6fF9WUTWmFfI0TVj6l2/r4UvG8j/yV/pk1fJ+XfB+z5Z/scAesq5DgfOMc6u03x+CNBcVPJaod2beuo0S47q0oxk48ODkpDcsxdc2tXeTALCOLsuJ6KNg5zTt/R4oFXSxzzpywWnRTSJrdFlG7lLLZHDSRta82YShxcsfu5x+14hlCIb2Bx1m1nGkmKqjUC+PI9cEvALZ3QLMBf+4K6KJXN7/39djM8LuqC456l6wfosxi8u1VxD/l3ga+BJPTFSud0LU4vY79AHBSIacAI70rOmcZtzfe59vlnlyzyaZWDJI1g8C8PswZcODrcgPxK2kOi8t2+OufNytAnHGjMsC9BPniUo8Sn95lCLjW8VCuTzQGibpCD7xCgM3IPKImfpY1Ao+l4uAQ4YdyRcltGPZM7HHwsL21yb4sJD90gnvaB9XDFiGYkIMwpkp1oPHkxyZTJKPH85b/LnOkr/OCuwI5xR7fZdv5yf4y9WBsIURv+Ds1DyMBRcrHCvAzjnP2fROo38BFuZcVhUQbyksU2OcxN/6RjK3BF2wS6NnGOpnBX5pCYgjtUPJm9IWCP7+EjBoDhJEMRui3PR4gOaHUKUunrdXzhxb7fOMa/4JVtF0pybYF+rcmkw7w7yAhPhD7pBsRznJdYL1aqAjbzBq8rMnsrHbmEL6PGAKT+fJrH8wOTvCB1vwHBov3AZx/NZDKTGmAx4NDvCGgFXmw4EB/Y8jcXTpAIuVD6oD2T1B8SHkTeOlZisdctiCpV+1i31q0b4GyvmCmyivsq1chklElY22/6tklwzBxISVYIANS8yZ/fOJrKQoiKhMzY4vOePxrxB2lVLUN4//N7HE8nD3XuaYLtuN3wQZl6XVDCUbmCRLIy
 u5ft2Mr/
 uDCzA6xWH87sTKlH3FcPJRcI0zbvuuDkrCC8ZRBCTlaWVz5mRS8e0fbNIoudCYuo/WcV1ube1M+3fNN1zMsjrU43boqQq9Inu4xbcEXbPebKgCilVu9m+uPqq3lsjxyQrf2xAEE1fsbzpz1xT8ZM05JwpjoX4xm8LaFIdxl3dqfkm1FNuS2iDetvkPBPfPWwwoOJtbuFCXaVbsb8IALuJcDXUQOjhv3q0U2OSEPnoojJfZ/2b8i/C/lGyieYQvXKqItRVPNNmQfjMA7rAKxVRW8mqWR3V56CwCtgdFyt54ev+4C9mEXiDs8vlzfSBxYyQM1CrcNlVD7sFiOxuMiXjvoX71a0jGtlxoNbHYljrpGH1jfBZExHFE6xBx2G6WuKOaWz+dZ4VjYAt7wH3gcZmdcYPuQbda5H5jPO+rjjHUDsDqqq+b3tfN/klLmN9BHZISaog
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the
zero page") attempted to fix ptrace() reading of tags from the zero page
by marking it as PG_mte_tagged during cpu_enable_mte(). The same commit
also changed the ptrace() tag access permission check to the VM_MTE vma
flag while turning the page flag test into a WARN_ON_ONCE().

Attempting to set the PG_mte_tagged flag early with
CONFIG_DEFERRED_STRUCT_PAGE_INIT enabled may either hang (after commit
d77e59a8fccd "arm64: mte: Lock a page for MTE tag initialisation") or
have the flags cleared later during page_alloc_init_late(). In addition,
pages_identical() -> memcmp_pages() will reject any comparison with the
zero page as it is marked as tagged.

Partially revert the above commit to avoid setting PG_mte_tagged on the
zero page. Update the __access_remote_tags() warning on untagged pages
to ignore the zero page since it is known to have the tags initialised.

Note that all user mapping of the zero page are marked as pte_special().
The arm64 set_pte_at() will not call mte_sync_tags() on such pages, so
PG_mte_tagged will remain cleared.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 68d54ceeec0e ("arm64: mte: Allow PTRACE_PEEKMTETAGS access to the zero page")
Reported-by: Gergely Kovacs <Gergely.Kovacs2@arm.com>
Cc: <stable@vger.kernel.org> # 5.10.x
Cc: Will Deacon <will@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
---

For reference, discussion on page merging here:

https://lore.kernel.org/r/aNKJ5glToE4hMhWA@arm.com

The deferred struct page init problem was reported by Gergely offline.

Given that we've had this bug for over four years and it was only
recently noticed, I think we should merge it at -rc1, give it a bit more
time in -next in case it breaks anything (not likely but you never know,
MTE interaction with the mm code is always surprising ;)).

 arch/arm64/kernel/cpufeature.c | 10 +++++++---
 arch/arm64/kernel/mte.c        |  2 +-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ef269a5a37e1..3e9d1aa37bbf 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2408,17 +2408,21 @@ static void bti_enable(const struct arm64_cpu_capabilities *__unused)
 #ifdef CONFIG_ARM64_MTE
 static void cpu_enable_mte(struct arm64_cpu_capabilities const *cap)
 {
+	static bool cleared_zero_page = false;
+
 	sysreg_clear_set(sctlr_el1, 0, SCTLR_ELx_ATA | SCTLR_EL1_ATA0);
 
 	mte_cpu_setup();
 
 	/*
 	 * Clear the tags in the zero page. This needs to be done via the
-	 * linear map which has the Tagged attribute.
+	 * linear map which has the Tagged attribute. Since this page is
+	 * always mapped as pte_special(), set_pte_at() will not attempt to
+	 * clear the tags or set PG_mte_tagged.
 	 */
-	if (try_page_mte_tagging(ZERO_PAGE(0))) {
+	if (!cleared_zero_page) {
+		cleared_zero_page = true;
 		mte_clear_page_tags(lm_alias(empty_zero_page));
-		set_page_mte_tagged(ZERO_PAGE(0));
 	}
 
 	kasan_init_hw_tags_cpu();
diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index e5e773844889..63aed49ac181 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -460,7 +460,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 		if (folio_test_hugetlb(folio))
 			WARN_ON_ONCE(!folio_test_hugetlb_mte_tagged(folio));
 		else
-			WARN_ON_ONCE(!page_mte_tagged(page));
+			WARN_ON_ONCE(!page_mte_tagged(page) && !is_zero_page(page));
 
 		/* limit access to the end of the page */
 		offset = offset_in_page(addr);

