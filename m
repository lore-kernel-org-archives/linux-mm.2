Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E6F606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ethP/+I0
Received: by kanga.kvack.org (Postfix)
	id 17F2D6B05BB; Mon, 16 Nov 2026 11:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1565A6B05BC; Mon, 16 Nov 2026 11:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06D396B05BD; Mon, 16 Nov 2026 11:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D5C626B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:01:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5E7CD120173
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:33 +0000 (UTC)
X-FDA: 85441447266.07.72ED85A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2A75740028
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ethP/+I0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794844891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jgg5EKN99U8VWXl+ylwhKyqraBlgCj53d3cDuGHQiY4=;
	b=o4VFyX0HtLgsqXuMjAxiYcUH7Iw5x9pwnf7RFFaTmUyf+fB0C4AtmcqYwxxtAtT0KGCEvU
	DK3jCrC0gvEM1GPOuhjf+074c55jEfOf2VmKeLho4eJks9nmvBpX+RfJfk7Y+IWOQV6R8R
	k1q2QeIJLLcxm7KRrXeeULFKw1SXv3U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ethP/+I0";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794844891;
	b=eCqpUUaSpJo3vasV68Q1A7tBZPnmcLchpGCmaVjnnOafcHm0Dh1xvj9tTabEMiFLqM/yKl
	9/yKnHlicU3MFT7KL7C6OrigQ1BnpUEESCOTNL401v6qHmyWX2m0gmcpKKZmk+gFL94EPR
	YkUkojcTE9FlChdqcEXSdpAoFElNGCY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 235B31684;
	Mon, 16 Nov 2026 08:01:27 -0800 (PST)
Received: from [10.57.62.118] (unknown [10.57.62.118])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F40773F763;
	Mon, 16 Nov 2026 08:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794844890; bh=FbZg7NHHCz6rr+xeyl8Jzirm2hXhzTWlvIqCbcztP+o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ethP/+I0Wt5Q7NXiFSu2kgNONXgJK6hDf8j0f5OQz/5k64NfduehJGmItzqrqLBds
	 lrNV8tE12J8Ci7T8dcM74qRk/uBu1OZSmLhvZif4We4Gh55Xul48FXbGFwMl6G+c5C
	 gf6IUWWMZAdXqScLocJkvtdyQHmulLn3N+yfKYGg=
Message-ID: <21e5ddae-c115-4d30-ab5b-ea669a66c9d4@arm.com>
Date: Mon, 16 Nov 2026 17:01:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v10 10/22] arm64: Enable kpkeys
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>,
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 =?UTF-8?Q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org,
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-10-aa6c4d9603bc@arm.com>
 <sashiko-outbox-207324@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <sashiko-outbox-207324@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A75740028
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: jkxo58z3m4878hg8shaykf365nafaoca
X-Rspam-User: 
X-HE-Tag: 1794844891-18834
X-HE-Meta: U2FsdGVkX1+xYkBKw/QhfnEmNKWCUApH6D1P9j4kQ9qukCJ9W6MCGFM7hXbNTyV+Nmfw7hXKxiWNkdfibTHF5krkM1paGp2N57HAZ+IY4ckduNr2UbKWtRh9dbF4MAD/EzC/eLLv9COkiDDgGbSn2+hzkEuVVx01PY6Kx5aCiFWQdij6/3cHodz3Cw1VGrtSzEczQUTctS/gl64cJc0P3iTrtz/o0yurBAJqCk8dTzfkmAoOposGQz9XLDWbSbeyUMlehhHas/7FjBYCoYXkFhFhE4JFXTc7ZoEBAMCRxL+jASFxSm5tGTNB/Wt5LSXyAw6VjxsVmzHPCvvSekvZLG43rs0nnKsrwXAT/1b1+/upTwqRl1cAjma2ap8mBvVqN53BrSo7imCab7REJu5h9V6BEsCP5VHKKTErq4JWI83i6VG8R8nJAraFz/6/VwN62x5CLC0Od7LJdHsVpEAisI6WsHeigKQdb+cKwrRWHfn1Wzqc6RPa4TKofUYAkUJ8jbjxdX62O3ZIU5F/H+f8LVvpTnxXtM+F+6mu1DxIoVBJTb/K2lNeEmWc9+I3VhHtvb6wxh/2x4HAR9XykrFGUV8vGleKCbWOXc37rTyB/Buc0/xKL4QPAVTV8Tljsp2XEfXMttugpJDc0pAXeHYqxMcN7vmWqDHf41F+88PSgz7mW7iOQWP2KtKgYku8QzzZRmYjDxY55nXoT9cuv6kEGRmLhlIJmnW2gt/MbxncVzFc7h6M9h5+eg7cjBTI887o0xXRIyL/A4y9X15i0xgDP+Sx0DGDtkyMvAOuezzByFnV2xty/CCUqztgdksgxm67RCcaq/3wKD3smdNPkG+pjfmqVQocRunCmUpvjgBfJdltbUj/n7Kox3LUbvU/NFKV+NgijPRt8wsriVSOk0mhdb5v88G0Wv3R+x6ZCm3nckhF4xQlgekjgfPgIzwmfGyEDN4cxjouv/AEkvDO85K
 mllIWhed
 2fAzAIKa45GoQE0lIV9ho/CqHkip6me3RgGJ7gzmcUChETxlNAsxVRx+6DZgV8IW5Wm54SVjYGIziBOpIHffUJEO6kJOuowDG//HkjVmS16PBH5RtthLN2eIyfbxtnhJ0bqyYiAba7lR/kz0Yeo5oMM+/xwpSiyh4yLTXJFGRbeZiiaHU0aTAM7jAOsrhczt5cyNtJMYoMprqmAqDAwdpyhohPjSM2lTRywHNrpxh7PSyePMCGkD082u/ErKtjqE1n2PR7pZOEDA/eV/U5vGQPTBlWyjxD3J6jj6vej2OYhNU27YUktWo5SB/pN9LrKqLWB+Q4CKIuuqqyGJxx6iBZfWx5l8EdDSVRRpDpEied/rNHMFkNAEsNrMOBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/11/2026 17:02, sashiko-bot@kernel.org wrote:
>> @@ -2334,8 +2335,10 @@ static void cpu_enable_mops(const struct arm64_cpu_capabilities *__unused)
>>  #ifdef CONFIG_ARM64_POE
>>  static void cpu_enable_poe(const struct arm64_cpu_capabilities *__unused)
>>  {
>> -	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE);
>> +	write_sysreg_s(POR_EL1_INIT, SYS_POR_EL1);
>> +	sysreg_clear_set(REG_TCR2_EL1, 0, TCR2_EL1_E0POE | TCR2_EL1_POE);
>>  	sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_E0POE);
>> +	isb();
>>  }
>>  #endif
> [Severity: Medium]
> Does enabling TCR2_EL1_POE here break privileged EL1 accesses to user
> memory when S1POE is present without S1PIE (for example, in a KVM guest
> configured with FEAT_S1POE=1 and FEAT_S1PIE=0)?

That one is a very good point. FEAT_S1POE does not require FEAT_S1PIE,
so it is technically possible that an implementation has POE but not
PIE, and in that case things will go wrong as described below (confirmed
on FVP).

There are ways we could deal with this, but they are more invasive as,
without PIE, POR_EL1 restricts all accesses via TTBR1. Without evidence
that POE would ever be implemented without PIE, I think it is reasonable
to remove this possibility by requiring PIE when detecting POE.

- Kevin

> Commit "arm64: mm: Enable overlays for all EL1 indirect permissions" relies
> on PIR_EL1 (PIE_E1) leaving user memory types without overlay (_O) so that
> privileged EL1 accesses to user pages (such as futex_atomic_op_inuser()
> using uaccess_enable_privileged() when FEAT_LSUI is absent) are not checked
> against POR_EL1.  When S1PIE is absent, stage-1 translations use direct
> permissions and TCR2_EL1_POE applies POR_EL1 to all privileged accesses,
> including TTBR0 user mappings.
>
> Because POR_EL1_INIT only permits pkey 0, a user mapping with pkey 1..7
> causes futex_atomic_op_inuser() to fault against POR_EL1 while
> fault_in_user_writeable() succeeds with unprivileged sttr against POR_EL0,
> resulting in an unbounded retry loop in futex_wake_op().
>
> Should TCR2_EL1_POE and arch_supports_kpkeys() (or ARM64_HAS_S1POE itself)
> require S1PIE to be supported and enabled?

