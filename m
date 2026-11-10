Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5396A60A2633
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gzvLDpAn
Received: by kanga.kvack.org (Postfix)
	id 4747A6B05C8; Tue, 10 Nov 2026 11:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44C586B05CA; Tue, 10 Nov 2026 11:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38E106B05C8; Tue, 10 Nov 2026 11:03:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F2B0A6B05C8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:03:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 816451206C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:03:01 +0000 (UTC)
X-FDA: 85419678162.08.5DD81B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id C66DD40006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzvLDpAn;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326579;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTzeWNwlBTUA3lRT6EanNeBOdseQbnbeg2md+jYWsZ8=;
	b=rB2buFbZ1qC5AmxAvphjjR94mVvSjc4sIndACwvbs23A8TSFFDOgHSu22LE6wDzW1Q9opZ
	GOxkiB2/rZAM6+v0LyTkS/MrYabmaQB2DUCD8SQE37V6fNMnJWHAT2qrvPv7UE8RtSaLxc
	6wgczMd9Lu3eWXvrHZN8iyWefdUdw3Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326579;
	b=QrbVBVm9yJJpIcADGuszaTfYiZyteFEaRl+GllC2miX/o3jBezBJJtfSJKpv3qBVPWpjlq
	L0vSwBdmnyhKvtEeDp2EV/jmN8qSOODljZxD7c/phqsEpAr+sBUlp7cV53mGWRAIbdDRMZ
	KBZtBvedaQcwx8Pjbg/7ayaNUC5bHF0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gzvLDpAn;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4C13363A57;
	Tue, 10 Nov 2026 16:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78AD81F0089F;
	Tue, 10 Nov 2026 16:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326579;
	bh=oTzeWNwlBTUA3lRT6EanNeBOdseQbnbeg2md+jYWsZ8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gzvLDpAnBpjn0n9vNUDHcZ+dogtUFFcvWODxsMFmVD9t6feYlYsg716Q6/gdP010j
	 UsuAQqotmmYOpnLwORVjRvXHfxpO+leW+40XdrcRWBP9vVIrXC9o0iIjZA/BfI9SdB
	 YTTXxDacHnYWqjZ0YY0YrpMQdzyTeVwkuHw9XzSmb9O1BnXFxAWaU2TtEVxLV5xzE6
	 21noKNNkv7CQNx+Nz0n9OX4WMM9dE5yiom+oWtMheHunILoj4Np4i4u9PrYNYhBzGc
	 pBp6pESN5YBmHQj11cAaLv+67Rci6rxpoQyF4fSKic959blS41vX4GgzbUK2hhkFSX
	 FxaPOlwEtR97w==
Message-ID: <sashiko-outbox-207334@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 20/22] arm64: kpkeys: Enable
 kpkeys_hardened_pgtables support
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
In-Reply-To: <20261109-kpkeys-v10-20-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-20-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:02:57 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: ty3jx8hk9ymjg6xm8cn7unosy5p3pj8a
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: C66DD40006
X-Rspam-User: 
X-HE-Tag: 1794326579-459233
X-HE-Meta: U2FsdGVkX1+3l5rEA7RZvw3IP8Qvx/JJA/oe469V/aWe4yI9ACiwW/p/QQ90OTalQckK3eMZ6yxWcqg6v69jqU3AxAVVWpvT4FienIfTFHgiza0/wEIoQA2owOgGM5GW43LMbuLwLwcS3hAMWlpbOY7ssGCSXL+sv8HbVjOkE1bdoSC/sD1PMHVHrSOqfho4sNZM0J9BiAksfSZACp0ayYXNWgvKJSk1Vg6BhGZOJu65N9LlQMsHe0/7bRc59vwvQdSlCYb8SgFYtT0guIq7A8BC4m2Po4o/b41/0Tg+6z0vXIevKPxzNs4dtN4HaSSsV8IZIgCJbgkDQbpUuKRsdA8t3uFeTFCfZvUHPCiGhDVIX6w0pN9yttxA4yzv/2J69Kzge8R4bislbddsDvVl8Uc+4lpYlow6+7ArctIgEUA3EIXhkrGU/2k+J+jsghE7PbJmxRh2BYqRvPjjeFVxpKgyNrR7TRj5NHJRb2ketplfwRL05KtLPtXlDLlFv4FKMEzbFcBA+VCvMhD7olTldYcf0s/cxsrLTnHnbtwsGN4tqMUB6sWR0dGHZyC3qOZ4hh/alYYo8CrXuE5apXFxdBKcyntR14Io88ZgkcyPHTSpUQfbRDLqtTIMG2BG+wLOTXHLCHp+ehNkkEtn/vWfwz9k5NmwbsJdtAjgWDgdCmEAelcasFE5LATIn6Nez9F2o6Mmkt1oNz5wSeB15deolang3AHzcf+078ldKjFklPc42CE5j3rCK9eEHVHTbMH7Fn58dK2UB266X3jsTTcp8OFNSqmm/6BJS7XXsZpAPOFtfh6VM1SmUUY1Zmgnu3ikGSXVo58x4upDPrbagKeSGRtm/4XXLneMAgtuy0ZOV9pXW+Jb2nDQZzUM2obWyyn8EJaaUQNUCZCb3veV0sc+JN27cN13509KMZbZITv9FntOL+L0yOhpfRp2HKoyF398HlDJwjjuvtRqXt+TL05
 LVaTsh4V
 XBI63sNN1cIPWQdAiRJF3e9b8J/TArRnavLkEBTvnkjsteQS78twF0Ust3LOGAKp2ctMfqRgsjFtFlth+az1s1IgbOXBCGtyJ5DamYv1C8LV2oXata7lre/OzXyfo7We4MQj9Qj763F/8qjVKXq91B+3OsyhJFEHdTaK4NYm9bUOmQ+Jhagc4tDsjR0mi+YtJag7SkcoGXypdYn1BM8LbEpbuRkV8Elnr2tPrNF+sleNlIEqcjya/e3txIsJfVkyoBI5XtfmV+6sfi5tC0n9UHhEX9AKj87okDEjDgV5RirLMgT6phIhX+cC4x00Y3mNkD81b+VVxvMcXuhDBlo+UlzU88ylBeSosXhdvkbe01qdAY9zMdArmQtw/Idzm01osHSZ6EMPPe3brzuhNvxTasPlk5X+kno/8tDhYDsi/1azdPwUF5YnA/Nq5E6X6+GupCdP4SFr1t73vaV/gXtr9EPMbDWQuDGdaLO4iI/Aev98/c8eBVRssu4o9Kkve1imqOP3v0BvXNJi4hYkejrmc65wc5yqcXyixWY1ThhI3hR0AUl7F2UQ9yKC0Bmb9ebC8lGtfRtxrty6yFuSpbasOnmMNpIVpTIUjh8puRrNMOGG1XsWj0YpOibeqBFL60pTP/8U63r6/19Ou2ldDepjFhJojERr0RzxgJAWJ4tnG6pY0TV9Ks7X8nOenOzfrQCmsp8Ks5Pljo0jr0wW3NrorWuWv35i/Wb3cOvPbvwn6NFtrAD6hpk6nlx2DioRfPwq6e1g7dL9Oazm6yBGzqVal4vEqTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] arm64: mm: preserved pkey in trans_pgd_create_copy() faults on
  kexec/hibernate
- [Medium] mm: kpkeys: redundant KASAN shadow walks in
  protect_early_kernel_pgtables()
--

commit 974504a027662a7ee9def760c6976edfcfbc634c
Author: Kevin Brodsky <kevin.brodsky@arm.com>

arm64: kpkeys: Enable kpkeys_hardened_pgtables support

This commit selects ARCH_HAS_KPKEYS_HARDENED_PGTABLES under ARM64_POE to
enable kpkeys_hardened_pgtables support on arm64.

> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index f7e4ffbc07ac2..28023dd0fd4b0 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -2301,6 +2301,7 @@ config ARM64_POE
>  	select ARCH_USES_HIGH_VMA_FLAGS
>  	select ARCH_HAS_PKEYS
>  	select ARCH_HAS_KPKEYS
> +	select ARCH_HAS_KPKEYS_HARDENED_PGTABLES

[Severity: High]
Does enabling CONFIG_KPKEYS_HARDENED_PGTABLES cause hibernation resume and
kexec relocation to fault when writing through the transitional linear map?

When kpkeys_hardened_pgtables is active, linear-map PTEs for page table
pages carry KPKEYS_PKEY_PGTABLES, which is read-only under POR_EL1_INIT.
Both swsusp_arch_resume() and machine_kexec_post_load() call
trans_pgd_create_copy() to build a writable copy of the linear map so
swsusp_arch_suspend_exit() and arm64_relocate_new_kernel() can overwrite
existing kernel memory, including page tables:

arch/arm64/mm/trans_pgd.c:copy_pte() {
	...
		__set_pte(dst_ptep, pte_mkvalid_k(pte_mkwrite_novma(pte)));
	...
}

Neither pte_mkwrite_novma() nor pte_mkvalid_k() clears PTE_PO_IDX_MASK, and
POR_EL1 remains set to POR_EL1_INIT during the copy.  Any store in
swsusp_arch_suspend_exit() or arm64_relocate_new_kernel() to a destination
page that was a page table when trans_pgd_create_copy() ran will trigger a
fatal synchronous EL1 Permission Overlay fault with DAIF masked.  Clearing
PTE_PO_IDX_MASK (or setting the default pkey) in copy_pte() would avoid
preserving the read-only overlay in the transitional page tables.

[Severity: Medium]
Can protect_early_kernel_pgtables() hang or trigger a soft lockup at boot
when KASAN or runtime-folded LPA2 is enabled?

On arm64 with CONFIG_KASAN_GENERIC or CONFIG_KASAN_SW_TAGS,
kasan_init_shadow() populates multi-terabyte shadow regions before
mm_core_init() using the shared kasan_early_shadow_{p4d,pud,pmd,pte} tables.
When kpkeys_hardened_pgtables_init() calls protect_early_kernel_pgtables(),
walk_kernel_page_table_range(PAGE_OFFSET, ULONG_MAX, ...) does not skip
these shared KASAN tables, so protect_pte_table() calls
set_direct_map_pkey() and broadcasts a TLB invalidation on the same
kasan_early_shadow_pte page for every 2 MiB PMD slot across the shadow
range.

In addition, when CONFIG_ARM64_VA_BITS_52 is enabled on hardware that falls
back to 48-bit or 47-bit VA at runtime, PAGE_OFFSET is _PAGE_OFFSET(52)
rather than _PAGE_OFFSET(vabits_actual).  Because pgd_none() returns false
when folded and pgd_to_folded_p4d() / p4d_to_folded_pud() aligns down to the
start of swapper_pg_dir, walking from PAGE_OFFSET re-walks and flushes the
entire swapper_pg_dir 16 times on 4K pages or 32 times on 16K pages.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D20

