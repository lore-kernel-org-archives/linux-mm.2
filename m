Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821AB606A327
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OLMBpdxF
Received: by kanga.kvack.org (Postfix)
	id 9D4676B03BE; Fri, 23 Oct 2026 13:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986BE6B03C0; Fri, 23 Oct 2026 13:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BDC6B03C2; Fri, 23 Oct 2026 13:31:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 653236B03BE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 13:31:07 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D03E51C20B1
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:31:06 +0000 (UTC)
X-FDA: 85354581732.03.4EDE4AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1CEBD180004
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 17:31:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLMBpdxF;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792776665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vCuyheP3hRwaXPnVY11qKs5HWYXsCMG1K1Wdmf7PfIM=;
	b=W1+OCdHdONUcArE2eD5NCfGLlE5lVcF8y7Lqxw2FHMZJONR0a2jnL64kuXd1EtncyjTnxT
	yV/Nro+/r9mUQR/50OC6jJ9nCtBWi3CEkQofOK9skia+jCBppJfI6kP6txWwUBUmnKXDvh
	RGxGWNsKP/RxjTh4z3/TDs2qai/aVu8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLMBpdxF;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792776665;
	b=dXs7MvqRschjv9roFTSdnJdn4M4Uf8w6AWuPDjDaXtYtJpCDmZ9YpWV5tcATz03eyB9kK6
	4PlPIrdFhwAJAXbvsqTuIbTj875xm7a7fVJouol02DM3uc2aFowJp0fO1oOqvsbNfg2bt4
	4PaaH7oBau37afsRfoXZQLf9/MaRcMY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 50D14400D1;
	Fri, 23 Oct 2026 17:31:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A1E1F01825;
	Fri, 23 Oct 2026 17:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792776664;
	bh=vCuyheP3hRwaXPnVY11qKs5HWYXsCMG1K1Wdmf7PfIM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OLMBpdxFOpWykEJlNQFOsL+hIYiRkoWdxHGC6hU3w6aU/G93yMFipAiwJkR2JVW3J
	 Z9nkLRTa+kgdaHLTGwrK1URPwqMkcBs+6aGag+eRSf7XqsmFtY7kABsazSKHt1Vo3u
	 B6KrXksB6gg4FJFSfUn81ykSx/YbnJJSmJ1fhCuB9q3Z1BFQEU7T6KPUtvjh0SHi6C
	 e92vTigW79GPVx5PUlt1bTunKrpmngrvfM8eA7DqEVFgX+bh+F/R0MGCaRoQv/gOJ8
	 RG3yZvY+EDZNCjh3i71ASo6pFThoSjcWk0n1DRsrmzMxaSu7fCfau9cYLXKJar3QVD
	 FHG1Nl54mNwUg==
Date: Fri, 23 Oct 2026 18:30:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Jakub =?utf-8?Q?Mat=C4=9Bna?= <matenajakub@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Luiz Capitulino <luizcap@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: fix expansion of VMA_MIXEDMAP_BIT VMAs
Message-ID: <atuY-n02IWHY7SOT@gremlin>
References: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023-vma-expansion-fix-v1-1-6142baf1f46b@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1CEBD180004
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: hc45xzf3mzaxsysfw8a8xhxf3aeu8ysx
X-HE-Tag: 1792776664-295492
X-HE-Meta: U2FsdGVkX19NJF29XmFSW4uEP0R5HM2BB6hhfG2STwzZIYxE2O1qOSN//CVqI5KOVwadeTVw7MtcmUk53yE5wQtyoBhuS6GtYxt4nfoGWhDVlJHTPqMEFO6EdLtC9y6zr538AGax4tAttF/dVw8+JV5xqbSRg42ddcQFYsYrgffgCX0mBEZbXS2wrhvqSF4KAgUJSUgY1P5cSg+D6z66iJmPsItmR8xKtE83yBT/gyShMzJby/dsSrj/Vtbz2+E61u1KNTRFTGcL7ABMJVkb9Ydeki6q0REGVKeWgflWKVu26PEe2c1xY3wygyvZuetxNuRpi4TAd3VIGAhn0GqEiDu+32b72w5iJKnyagbMJ1TlGg615V9unisQfN7eaSaucYAA8yF5HXyVAiwSPTe5vOJDp4ai+yZVfikELJkLpcjKDcDjv6UZviqD1+a3eCWXXdDjnKjTohwxb7U6/CYDO5+FVOrOhoBS9fMqnTtedIv8liTvQL7NmujtGdwgHBTCXezKPsgDLXp21E5NfTk8Wh0NNGnll1YnuFpPth3ZViOYjCI5D2jIMqmS+vNqMnOOzNC7qbbNR0k7jsl7iJ+SNnOsqrWE5EMOr+p31/RJj4fuENB4iVXW+kUHBMN4ZetV9aIhJNg/DBTWOjyjiL6TLapQTGOHJWU7IQdt1Z+kPMj3K0DmX18ta5NrxQftLJXf6aWIy/4emiola9YPh3C2+ftazZrjax2i8BjTqbCee4DCLeq/wqrD7h+vB8WT1ClZbxG/fDTM8Akat9hDBOeBjK3kb+4jfBh+GpdMP2sVyTR4SAZ10mZp8jJhxhoIWJ3UO2uQFPmXTVhpm1HW3Gdn35vV7ePMgLEfcPO0k/8Sh/cropbjL3q4LgTGfhAoo5P2VzRvmsJvfW/tD+8XSWMXHgQ4CzqluhB1/ejfu073Iz0SIOa2XnS0wDhz6Zi4y32pn1JnklCja58lENRZ0sq
 dFVtuWdC
 f+RLUJr81/K9bW1i0BYJCCQK9bQW4uK4c2vTaW1lNExM88zeCBMSuZG7xulcypSL68HHEp6dbVR+WeB/3bRsElLxDA4bR1Yc6737jAv+6ZsGQ2+y5w6gRzt7HNlUxCHwtvCELOWdjms/Vi4JiCnigtFdhou0qhQgfA2M3/9VSg+M4YNbFknug50erDTbgAIASngMIFXWItqlyvESepj7xnlC+tiseUXCclrscDyScFqQSOBVV83RXl3wvvtGPgn8QidIlV/AQfcyukaHnIyfZS5jn453EcxuO7V2/UnMJZCCquSkNqxbJHdNt4jYVci6XtTEPsmuv9URCWtmYLok0pYVrzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 04:17:31PM +0100, Lorenzo Stoakes (ARM) wrote:
> Commit ca3d76b0aa80 ("mm: add merging after mremap resize") combined
> merging with expansion of mremap()'d VMAs, however it also unintentionally
> disallowed the expansion of unmergeable VMAs.
>
> Previously it was possible to expand a mixed mapping which mremap() had
> already ensured was a legal expansion.
>
> This is clearly seen in the mremap() logic, as it checks
> vma_is_fixed_mapping() to determine legality of an expansion rather than
> vma_can_merge().
>
> Additionally, copy_vma() allows for a failed merge to result in a new VMA
> being instantiated if MREMAP_MAYMOVE is specified.
>
> However, this is not attempted, as a failure in vma_merge_extend() is
> assumed to be an -ENOMEM failure.

Just to note that VMA_MIXEDMAP_BIT VMAs can _currently_ be expanded if not
attempted to be expanded in-place (e.g. MREMAP_FIXED, or if not enough space to
expand into).

So this patch doesn't re-add the ability to do that per se, it just fixes one
specific means of doing what is already a valid operation.

VMA_MIXEDMAP _expanding_ isn't really a problem - if no fault handler is
installed, faults in the expanded region will SIGBUS, and if one exists it'll be
invoked correctly.

This doesn't work for VMA_PFNMAP_BIT because the page offset might be co-opted
for CoW (!) and thus is unreliable.

And it seems some users do, at least in theory, require it, even if they are
using older kernel revisions :)

> Since vma_merge_extend() is used exclusively by mremap() to perform a merge
> and/or expansion, resolve the issue by invoking vma_expand() for
> unmergeable VMAs there.
>
> Explicitly assert that the VMA is both non-fixed and a mixed mapping.
> This provides double insurance against broken changes in future.
>
> Note that khugepaged_enter_vma() (which vma_merge_new_range() runs) is
> redundant in this case, as a mixed mapping is not subject to khugepaged.
>
> Also update the VMA userland tests to add a required predicate.
>
> Reported-by: Luiz Capitulino <luizcap@redhat.com>
> Closes: https://lore.kernel.org/all/20261023023106.515365-1-luizcap@redhat.com/
> Fixes: ca3d76b0aa80 ("mm: add merging after mremap resize")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
> Confirmed that this fixes the repro and passes mm selftests and the VMA
> userland tests.

--
Cheers, Lorenzo

