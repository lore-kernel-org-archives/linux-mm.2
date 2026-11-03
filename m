Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 165C6606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 20:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RBuMa7bV
Received: by kanga.kvack.org (Postfix)
	id E4EA46B00EF; Tue,  3 Nov 2026 15:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFF796B05B1; Tue,  3 Nov 2026 15:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEEC86B05B4; Tue,  3 Nov 2026 15:27:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E7A26B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:27:20 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4F35C055F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:27:18 +0000 (UTC)
X-FDA: 85394942556.29.01E9790
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 43254C0002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:27:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RBuMa7bV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793737637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oqrcEuwTdfOxKIfYEs/ydcBz2K7swqbaTmtMGonjwTg=;
	b=No1iby2GmPZacdwJi7cwVB/F0yrfEW3uK0JDx9MRlnJQb/HeWnsHmy48Y3wjBvKX2HaICs
	anzKgnY0xHEkqltKuWX5zGF3Ozr8dyAFc3RMp5Zwozf6z9/P4VYrzREIepZyS89TMbi3Ab
	JRIpwa+F3Tls/sAmPwIomi3ligZwElo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RBuMa7bV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793737637;
	b=PcRG7g1Nysj1V1Y1LI3Pi1XPDoW4u5k5Fp2FFqd5GLrRCOqStTRxVVapu/YkYtNcg/0q+6
	EXIN8I7yiOpk1XjLR1IPu7xlx5xfYYlkvD7DfdkUjThuzdXIJDZkRxep0xQ44lOMNfuV+1
	yG2ytRGbMgCC5H2D35tNJ35JzfxEGmM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89451601FF;
	Tue,  3 Nov 2026 20:27:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CEA01F00919;
	Tue,  3 Nov 2026 20:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793737635;
	bh=oqrcEuwTdfOxKIfYEs/ydcBz2K7swqbaTmtMGonjwTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RBuMa7bVjJ0UxmmAC9Gj7sJYqYOOjMltPrVTwC9E2KH9ptZ/cGgtyUnJLhymy5yx0
	 GBnQJ+wJVvrpF/IvMdnRNVX83S2XHSH65MLEwU8kBoyjPBfR3EHEMJABWSJmNLqDEW
	 6t5JSw70LQ9UWkw8C0nucvCTtdmTxPYDzhKEHmSWJuf3dTCgmG6F5rNWXA2k9lUFPZ
	 OV5vJOzvtiH7jplG6HgbMspXjSDSddzx9BMwd04MZ/QDSH/PiYnge49CJrruSIaKju
	 XctTZ6vAqKLPTopE5K/D6CisYvav8teHEc+u/or9bRfiQCqVM9ldyDkBjE91y60cTg
	 8ldWFY/4tLiBw==
Date: Tue, 3 Nov 2026 20:27:09 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v3] mm/memory: use pmdp_get_lockless() for the pmd read
 in do_fault_around()
Message-ID: <aupAdlzeOtc0qSsQ@gremlin>
References: <20261103014749.96764-1-hui.zhu@linux.dev>
 <aumfvNWiemmuyooP@gremlin>
 <61f8a583-5ea5-4fcc-bf30-ea9cafe94d65@kernel.org>
 <auoXIdTpLO60mkEw@gremlin>
 <c0e648e2-aa1f-40f3-84f4-c4ca4123de9f@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0e648e2-aa1f-40f3-84f4-c4ca4123de9f@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43254C0002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: mrun7xan7bensgfiujay4fnbignj1swo
X-HE-Tag: 1793737637-768594
X-HE-Meta: U2FsdGVkX18qOw1iTSl0tz9X0JIUC6+eZLnEAwYrBLa5YZKE8qevszOAx22+3z5N/g/uaMHDpIfH9b0UPee4rM84QS7Gb0xu9/3VSjbKCku28CDhvnHSZ1LSbjR3ct87U4/UYHFXHO6yOYBtSH9vUzs3nckL0D4dW2e1CcVpitJiJ735CJs04ubq4njZTc2blsELQBKVmI4fWwJE/2702T5fesoAVT01VdfJHVVqQ5jRGVwWt+mRYEFNoOyskYN9zeDSBC283CUjwBo23ZnONWLAg1NEBCTu03tTQ86mxTUN03uDw73LGPMMk9AsBfatMebDWV0EcvGw58fk3hhdhp3FFTVyi8u1NDxmmiCrOxm1v1NSuWTYs031P08lqYuYiV9OiDSsHZ4ohcC97vIqlniZFqX/oezYjD9cNwE4UVXUemgFdsF0osHu6QZE/5QiB9wS/qdOyd1O81EnKf30t+4SAYmZoB4vBJsJmg9yUOui0xzGQ3CY9vDgMt2YjDC6alw5njeC1Jvj7PM/NJXdEpC8sh/Q4p99XvQMKtcqKsZB4D0rM2OHZnUnOMD+qN3Un3my+AaCrG1BC3qIXyLZ/Ch3tky5bqcRb1dyKDj1vpLG100UFFDkK0y41B8ozVXQdcP4tU6clhGpEFY6hcTGPw1k9zNLw+OYLFmT4x/sU+0MnC17mHIg26bxWqwgnODl8UB/3VD0RXz3JaPOsSdBJEAD6w5NiBGuZExPegH7Z00EfI9pBTNZ97WUuOlIyl2SWiq7z27BPjV0CUOZaaMVPjIMvT9u9RyP2w0WZL2v7ymnhvnXETERz7FxtDyzGXyORgcooxlDh7ZcP66ZLT/Fb4cxIjFaLFaifAiYOO/dOVaPErs5O8WM8O4wqoipOU33X9YWu2Sg9AAW9Oq4O9PbWPn9wV4F+xjLu0ZIfFMFmUOTJzPfxECK5Hrm0l4fRGfs2B+f+ynMn9el3rV5Ot9
 O65wIzuq
 qd7E8NvaUE33TU+VmSyXDJutsCYh3Nzod9a6LMtCjvIzFJb4IZW0IYc2ELF0RK/WzFdpOFS1P00rMyzNyZPyvitOKLPi4VVP+2oRET2nQaHwI8Lu6Tstyl2HKa7gl8FHCE2f9hqBE8AS7K+7Nv9HJ7+QIwN1fq2DI8tz5Yie3SAMdw+OjxF9b2oAQI607h5/IO1FXI3/hgJgWfg1sR+WQC8nsZfOyxODaJFFRd+FgeCWFFoXzL3v4RXCeQQnuJ2c3zbg4x5e3DxgpeQZJYEcuHhjPHrSaYlUq9CSYHzgtCK1GJbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 03, 2026 at 08:51:38PM +0100, David Hildenbrand (Arm) wrote:
> On 11/3/26 19:24, Lorenzo Stoakes (ARM) wrote:
> > It turns out we're as wildly inconsistent on pmdp_get_lockless() as we are on
> > pmdp_get(), so TL;DR my main concern is moot so:
>
> Yeah, I know that we use it in some core places already properly, like in
> GUP-fast, __handle_mm_fault() or our complicated __pte_offset_map().

Yup, but also inconsistently, basically mostly interchangeably with
pmdp_get(). Rarely is this value actually used.

> > * But it turns out it's all a giant mess (of course)... for
> >   CONFIG_GUP_GET_PXX_LOW_HIGH arches you really actually need to also do:
> >
> > pmdp_get_lockless_start();
> > pmd = pmdp_get_lockless(...);
> > pmdp_get_lockless_end();
> >
> > And that's because, as Hugh points out in commit 146b42e07494 ("mm/pgtable: add
> > PAE safety to __pte_offset_map()")), you need IRQs disabled for these arches for
> > it to be safe.
>
> Yes, there is this pmdp_get_lockless_start() magic ....

One of those things that, the more you look into it, the more stuff you find...

> It's really a mess. I wonder if we can remove that somehow completely ...
>
> arch/mips/Kconfig:      select GUP_GET_PXX_LOW_HIGH if CPU_MIPS32 &&
> PHYS_ADDR_T_64BIT
> arch/sh/Kconfig:        select GUP_GET_PXX_LOW_HIGH if X2TLB
> arch/x86/Kconfig:       select GUP_GET_PXX_LOW_HIGH             if X86_PAE

Yeah that'd be ideal.

But actually could we not just simplify and allow these arches to be a little
bit slower (who cares for museum pieces)?

The only user of the start/end magic is __pte_offset_map(). And it does:

	irqflags = pmdp_get_lockless_start();
	pmdval = pmdp_get_lockless(pmd);
	pmdp_get_lockless_end(irqflags);

So that could just get folded into pmdp_get_lockless() for these arches.

That would mean the places that don't require IRQs to be disabled (optimstic
checks) would now be needlessly enabling/disabling, but hey - use a system that
doesn't live in a museum :)

That way we could safely convert every non-PMD lock holding caller to
pmdp_get_lockless() without needing another pmdp_get*() variant + fix confusion
about whether the start/end magic is required.

And this would work even in places where the IRQs are already disabled as it's
fine with nesting.

So you'd just update thusly:

static inline pmd_t pmdp_get_lockless(pmd_t *pmdp)
{
	pmd_t pmd;
+	unsigned long flags;

+	local_irq_save(flags);
	do {
		pmd.pmd_low = pmdp->pmd_low;
		smp_rmb();
		pmd.pmd_high = pmdp->pmd_high;
		smp_rmb();
	} while (unlikely(pmd.pmd_low != pmdp->pmd_low));
-
+	local_irq_restore(flags);
	return pmd;
}

...

pte_t *__pte_offset_map(pmd_t *pmd, unsigned long addr, pmd_t *pmdvalp)
{
-	unsigned long irqflags;
	pmd_t pmdval;

	rcu_read_lock();
-	irqflags = pmdp_get_lockless_start();
	pmdval = pmdp_get_lockless(pmd);
-	pmdp_get_lockless_end(irqflags);

	...
}

What do you think?

--
Cheers, Lorenzo

