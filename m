Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64530606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ANXZTmBq
Received: by kanga.kvack.org (Postfix)
	id 3B0D96B05C4; Tue, 10 Nov 2026 11:02:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 362586B05C5; Tue, 10 Nov 2026 11:02:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29F046B05C6; Tue, 10 Nov 2026 11:02:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 055C06B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:55 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B685A09AC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:55 +0000 (UTC)
X-FDA: 85419677910.21.D09CF90
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CB5E8140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ANXZTmBq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326574;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sllyzwIHkBA4c2sook2ibB5jXq30WTBzzGvzDcn0PCM=;
	b=p6ZyfmolXe1GEAPZQ9pvaizzRcANL7Lrpu0UOC1zDhmvw56ClZ4YA7uqCLFRam0iP+yv5Q
	Jb2bQOqoOyqImYdJHTL2ibr3ig7Xv960LJecOwqh/8cPLJsQ8bSAADof9XxSNZtOB2Bs+t
	Rcx72kfIQBKant3xHyKdfegkBA0GNMg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326574;
	b=vQ+EEk3vWtsWy2jE4t35oZeBOMbwweywp5XdBT6TpB53hN/jaauPOj9WFzqJJFGJdpu542
	pRRHEk4EXiZmATWa21xMKfmhxIBuPIINAm9ZXXYxxHvWO0D8wJRo/n9KObbwcbkj3kXus7
	2gtG1FVZrM/SAFRw7gfc1jSu5afrEHc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ANXZTmBq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B9064239C;
	Tue, 10 Nov 2026 16:02:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83ADC1F0089F;
	Tue, 10 Nov 2026 16:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326573;
	bh=sllyzwIHkBA4c2sook2ibB5jXq30WTBzzGvzDcn0PCM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ANXZTmBqTf8HI/HKF9dMFDX1JKYT9msnV3dPOC3PjhI9N/PKNa22meDy3wy5D0Zwk
	 59tlyPbMOUQWsR6OEexT2W7g34t01O7uEJU1hFniwiWkQLrNduY0UXBRvXoaHz2kfw
	 ETs4QiZD2enhPoPkrdk/djJ9pPUhqcMcAwdtIYrX+GkvJdY2E6ZkAen9iN19RBiz18
	 0hUXfiVOM43fFp0exxlS/brELMrf+O4b0APPpVTB1DNZx6HyfEi5t2A6y3e4FAfbgU
	 g7XSF8TFM2tjrm0Qq4fqkCiZvv5wIncRxnvpZfEOD3Sc4suVXc67xtQcP4ObCtgp0X
	 wGHCQoEoE9JJA==
Message-ID: <sashiko-outbox-207324@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 10/22] arm64: Enable kpkeys
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kevin Brodsky" <kevin.brodsky@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb+git@google.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>, "Jann Horn" <jannh@google.com>, "Jeff
 Xu" <jeffxu@chromium.org>, "Joey Gouly" <joey.gouly@arm.com>, "Kees Cook" <kees@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Linus Walleij" <linusw@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Mark Brown" <broonie@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Maxwell Bland" <mbland@motorola.com>,
 =?utf-8?b?TWlrZSBSYXBvcG9ydCAoSUJNKQ==?= <rppt@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Pierre
 Langlois" <pierre.langlois@arm.com>, =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRv?=
 =?utf-8?b?c2k=?= <ptosi@google.com>, "Quentin Perret" <qperret@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Yeoreum
 Yun" <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org, "Ira Weiny" <iweiny@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>
In-Reply-To: <20261109-kpkeys-v10-10-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-10-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:02:51 +0000
X-Stat-Signature: iiug43yekzutzx6s1iyad4hi1rgsww74
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CB5E8140007
X-HE-Tag: 1794326573-140027
X-HE-Meta: U2FsdGVkX18yih9+q69F0NzPuOuZ0mCJdZGjSEgm0ouap5yfOcUT+UQE9kuPStEwY4BDU02vjLrXhG7Ld8xtRNaMWmoIPrqP1rfnq8oCAc1Iab2V2QCposu/1t1iHBOwAv/75t/2rDQER9HpT+jppZldp+co7rJuQRGBDwAGpMKna8XTP8HqwdXbR2mXjaxWyfwI5UCZG1fO5FdBV9PMBmNk9DONkgNgei+KYeHG18xyuawa900QqfLVZltePo3ABINcF9gJ7p/5G7IkQXJ+sc9Ch7giHehNWmJyIzPSUu08bFCInHCRQwFXrPDuGzdHoeshXVJg3dU/P+DBQHjxMx5z3+wWdvnFvBTmGq0QqUngWBUtFXRBT3zTGFJ6I/LSHCkK88J53sga47IW7ny+lY9cFophR5CsKGYZwkinznu3zPTJavM626JsnSo8r6xgO1RG2VEYqfbESb3wI41eDiFHguIvu8dQJkr3XcwIc0VLsUaiuYAuavXShq/Uer9JrUKzBTs2WudfVigHNWpxQaX9OftSR2pvTL1OoRrDZJ9ANWzmXhS+WCe4qzGwHNYq7jXgWukrDs30Gj3MU2s27+WnDtxglBVSzmY7O+sZdwmT8BQXnXDvjuIMwVYYxh6dckecmp7lpwR8buJLHC+WoaoDA7t9y2elcx0VTRVBztDC/gWUmmBkMWKH0Qt3su/YZcPcF9V0HqWOPLfcKov1TGEvVvZHJIXbfVr4b4mFwjUDqGbtlRTfaoU4I8m0h7jLVHSoeHJZ4qc7zqOw85hog0BF98WCxAJq9pA1AP9tXO5LArGgTbrserOhLu21299I+y9b1GHSe3cUXFWSaxcwEwgjIYVIqEG59Tvu12cehe3L5vvIilyIeCuqH9qHFSTi/xidr2XPkQWuTxWtAG0hvokYp5nkayBLElQjpWza2SWjBjwhWQOUR15eq9eDAgS4GtT5JygcS5M0ljQO8Sb
 n8+FtK2m
 n1RKdwl5hepu/+skq8pS1G+FkFU//bByBpxGSvF5Iv1GHH9hIpBOrZDBJFtP3Vhcopr1onVfqIFxJ8pDDVCxDdDreZTqmWUws7SGJYa05zKFvhG9+61UT4eqzWwbDKUMaflS5C1KQag3AJ06K3SahBO4xjhLaxvxSkrLGcS3/bSLKBESbCE1DZ9a2whIoTag+PQY5oRx+xCikLKEm/W7L93/r3cDbbYPtWrR7BLY7RPtDJZBTzUSXmqzcVH3EBJZEu7vVvaCGiAiIF1F0E0zzqhy6YOzCcVZk5gCU5FNdZG5Ou/aBc/t2R1i0jkBZVJXL2O1ao9HR2y8LKHEtXinAGJk/GE/tSKGtTgWUvlUFgT7Cs/r9jKTIfcGWTCrvm9jguGA3cGYeBlHq6mLfY5nOTu/hs5hYi8zdZaDkxejqG/JfxPywVoykvGK4L1oEGaAg/2j7AIn/fHawj3BSsAfW7EXT/METeJRJndbtQ+aTDLfQ5jBiWf6tSmRZAoZl7EUT0mwaTGMvXkVr1y+G9odPFyeDla/KTG1zUjDZYGarRF2NU83WYPw7Wq16cw8eZv7ojx0OejrSX8NGSwk2d9qWE2XtBprX97dxueceW002L2TakKuPoxsilE2HsYU53GBaeEcF1Y82ee1RNHa3AqLL9MsB/774lyhYayaJ2x8nzgnT8EiRpq2CtQt6OtnHnk6qDv5mv5F5/7rNTuiwaFEFlT5JeUah98IlHKMrACoO0mMT1DM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] arm64: cpufeature: cpu_enable_poe() enables TCR2_EL1_POE
  without S1PIE
--

commit 916b4efd6b8494c5d63fd0effff9032def1dba2d
Author: Kevin Brodsky <kevin.brodsky@arm.com>

arm64: Enable kpkeys

This commit enables POE at EL1 by initializing POR_EL1, setting
TCR2_EL1.POE in cpu_enable_poe(), and selecting ARCH_HAS_KPKEYS under
CONFIG_ARM64_POE.

> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeatur=
e.c
> index 34c5c03c0c9b4..42d693197739c 100644
> --- a/arch/arm64/kernel/cpufeature.c
> +++ b/arch/arm64/kernel/cpufeature.c

[ ... ]

> @@ -2334,8 +2335,10 @@ static void cpu_enable_mops(const struct arm64_cpu=
_capabilities *__unused)
>  #ifdef CONFIG_ARM64_POE
>  static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
>  {
> -	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE);
> +	write_sysreg_s(POR_EL1_INIT, SYS_POR_EL1);
> +	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE | TCR2_EL1_POE);
>  	sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_E0POE);
> +	isb();
>  }
>  #endif

[Severity: Medium]
Does enabling TCR2_EL1_POE here break privileged EL1 accesses to user
memory when S1POE is present without S1PIE (for example, in a KVM guest
configured with FEAT_S1POE=3D1 and FEAT_S1PIE=3D0)?

Commit "arm64: mm: Enable overlays for all EL1 indirect permissions" relies
on PIR_EL1 (PIE_E1) leaving user memory types without overlay (_O) so that
privileged EL1 accesses to user pages (such as futex_atomic_op_inuser()
using uaccess_enable_privileged() when FEAT_LSUI is absent) are not checked
against POR_EL1.  When S1PIE is absent, stage-1 translations use direct
permissions and TCR2_EL1_POE applies POR_EL1 to all privileged accesses,
including TTBR0 user mappings.

Because POR_EL1_INIT only permits pkey 0, a user mapping with pkey 1..7
causes futex_atomic_op_inuser() to fault against POR_EL1 while
fault_in_user_writeable() succeeds with unprivileged sttr against POR_EL0,
resulting in an unbounded retry loop in futex_wake_op().

Should TCR2_EL1_POE and arch_supports_kpkeys() (or ARM64_HAS_S1POE itself)
require S1PIE to be supported and enabled?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D10

