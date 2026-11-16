Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41DA4606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 17:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=VG/Kk1/H
Received: by kanga.kvack.org (Postfix)
	id 4FBC66B05B5; Mon, 16 Nov 2026 12:41:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC9F6B05B6; Mon, 16 Nov 2026 12:41:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39C176B05B7; Mon, 16 Nov 2026 12:41:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17F876B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 12:41:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6DAA7C0215
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:41:28 +0000 (UTC)
X-FDA: 85441699056.10.BF1A931
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 51275A0003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 17:41:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="VG/Kk1/H";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794850886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ch/BM/lENfR/J2/TnwIZqowCLj2KAkaLmppsgvcuwmY=;
	b=16XJcu1qhYsajjqpTg4Ke7+MOvwsM01W7lWOjnnwNZ9c3VJuxD1gp4rC9YyaBhukKl3YtB
	vTMazIlU5x1HL32Jci62IbJTBznA3wDIoPXEieeyG4Zacv2LKaagn+1P3ZhUisDrMEv1qK
	NniRqcKcU81t+biAJnGySHL5vh5YT0A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="VG/Kk1/H";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf25.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794850886;
	b=MX4/Wa0WIwm8Ao+Km/ONew+iITuMFXp7gCZRb4jMYXg1zU5ovWzVnOfYpG9G06knKJUNep
	eEmmGKhMkEfSKUXHYdik5BYccd5e7iPvea0Nsl7jPfqfmfGs8A+zO4qYNoMuXEBVTNsAfp
	hTIIuw1vaJcNp/B9/v63Hmslc13VPtc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3260A1684;
	Mon, 16 Nov 2026 09:41:22 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1ECB73F632;
	Mon, 16 Nov 2026 09:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794850885; bh=DJXLQoLiGRbRJ+1smSfQs3/6Lkrk8ODrlYWu8BnlA00=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VG/Kk1/Hm7a1RCkojQzH3TfEGbFCMCdZBSdIQjb7FeNVmUGMUZy58kcZMku6lOZsS
	 y169/1y6JoIbmOKKanzJyn1ciIo6W3230WeN1uCk/y3+S7HCx6aFqY1VgaSiWKEaZ8
	 XMtniXb6xIQr4QvploJN+iUys049C/iJsVz38he8=
Date: Mon, 16 Nov 2026 17:41:20 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Samuel Holland <samuel.holland@sifive.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/9] mm: distinguish HW PTE pointers from SW PTE value
 pointers
Message-ID: <avtAQCkvRr1xkxMF@arm.com>
References: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922-pte0-v3-0-5670b8cb9059@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 51275A0003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4446i6q5dg4dsu4gkxk861n6uybyyahc
X-HE-Tag: 1794850886-890155
X-HE-Meta: U2FsdGVkX1/vIrJszg4A1Zx43hIgI3dzypV84UcvRAqYr7MZ98wfi11xHldNKSZ8v4nNLY6d/VDvMdW9goYBB/+3MN4vj3HbyB/eRqT3sbYqdAyWSuiHdqQMO6oX4woKkM4Tycz91+xxwsE6iq1E1B6ODDHr/IHvUmoR2DYczzG+KNW69bPi0GBpYLz8ybq93KtwVWF6yzi5n/uxnXIFrdfypdl688S967YjAuUPnahNGvDgD9jnLw8+9M2ZzmusqTz4OuseKqZhDfGTBpgcDnZo8oXTA718HFjy24AvOIzpJwtUEwJoKg6PXe1bx8w68fkV0nOPImO5guTt6mpysLbKNwyJHclKsdsd3dwuKSlVPVfTKQOzxDL6WGzvuFTNDkA4a1ZJW6HqF1l8hxlcc3cKwfNAjB1lB58rEi6VlOC6yauXiU76Xx7Z7/4nDRb9e/xLa/tb86NvjMr5fPf2Bmd4iT40k965hzVMtMSJmgKq8cGZbwZR1AcIJxNG4GNQ6x7ygGGeJTl7s9U9WPHsKqpn6UUuJkgVCYpNmYbessfVRRRXZPp+ZtYdAhV5G3iCTeLhMoD+kfRUBsu0+dhN6zfNBG6lGEaeTA/1ImiNHBxUi4Sdm/f9WeePVAOS5uGCNdYBbivDoHg3C+GoFQDj5wcPyk9/B17nF8+9o7br353mipdOZaqNuTrn7RRXiR7EjYKbZHn1TZEXXrGZdWknp5BTBhm9dInj236DF5CRi9BDyWRwiuRE5iilKib0PVwk63bKXAYUf16AIzRmN7AIL7BZ7q6HeWDQ6EQHq4b4yy285D55vG6l4cA8pe6fGPGP4fCfOC10x/xd9hmpfmEJJzpLtLFyGdjBOP6BvXNmkVOYRjLlkA/a86n+xqhySh4b1OpbKTzgfxiF+ZmlXbFf9vnC/v+/QKxLfsS5nB00lLqht9AuiWxO7VY76I6CVlvEYBw9c9U+Er7JBiBuKMO
 Lmzut1Al
 negTOwDqLq6BKJMo0XAwjywh811sRFLmdj/wDH9KwLbwzGj3+49r4ZHMNvmo7wi/xHEbPfYjju2DCrl16+dmuXOKR6c64slanMGgnj6/5daZW6cnBZShzFL46PRD5b/DTxH5qt3TCCTSNZDtTalCgVU9gKiMGtLdrcTuGgz0aswzCXAzJ4n3Kc1hujJ6B/uRwjPYWldGpps3C59hXOljXYZCtv4cLguiWn9anbbwdNd8iqmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Usama,

(trimmed the Cc list, some lists reject it as too many recipients)

On Tue, Sep 22, 2026 at 06:12:28PM +0100, Muhammad Usama Anjum wrote:
> pte_t currently describes both a software PTE value and an element stored
> in a PTE table. Consequently, pte_t * can point either to a software PTE
> value, often a stack copy, or to a PTE-table slot. The compiler cannot
> distinguish these cases. A value pointer can therefore be passed to an
> interface that expects table storage, while table storage can be read by
> direct dereference instead of the architecture accessor.
> 
> This series begins a staged conversion at the PTE level. It introduces
> hw_pte_t as the element type for PTE-table storage and converts generic
> MM to use hw_pte_t *. Software PTE values remain pte_t. Interfaces that
> intentionally return a value through pte_t *, such as install_pte,
> remain value interfaces; the relevant parameters are named ptentp to
> make that distinction explicit.

[...]

> PMD, PUD, P4D and PGD storage are deliberately out of scope. They can be
> converted in later series after the PTE boundary is agreed, avoiding the
> PMD-specific cases that made an all-level conversion difficult to
> review.

I looked at this (and the arm64 counterpart) and I'm not fully convinced
it's worth the effort (but I won't oppose it if the mm folk decide to go
this route).

First, I'd like to see all such on-stack p*d pointers addressed as a
prerequisite (e.g. fix pmd_populate() in __split_huge_zero_page_pmd()).
If for some reason we deem pmd not fixable, I don't like half (or
quarter) baked solutions just addressing the pte.

Second, we could add a run-time page table check, at least for pmd/pte.
Something like below, gated by CONFIG_PAGE_TABLE_CHECK or
CONFIG_DEBUG_VM (untested and not entirely sure about using
PageTable()):

static inline void pgtable_ptr_check(struct mm_struct *mm, const void *p)
{
	if (object_is_on_stack(p)) {
		WARN_ON_ONCE(1);
		return;
	}
	if (mm != &init_mm && virt_addr_valid(p))
		WARN_ON_ONCE(!PageTable(virt_to_page(p)));
}

You already have some coccinelle patches to make the conversion. Could
we turn them into a coccicheck to detect new uses? With LLM reviews like
Sashiko, we can probably catch new uses violating the requirement (we
need to document it).

LLMs and coccicheck won't catch all abuses nor does this series prevent
one from declaring hw_pte_t on the stack.

Once the above are in place, I'd look again at these patches and see
whether they improve code clarity and are worth the churn.

Maybe an argument in favour of these patchsets is future dynamic support
for FEAT_D128, we'd need to separate the software representation of a
pte from the hardware one but we've done this before (arm32 non-LPAE has
different representations).

That said, patch 2 (naming the software PTE value pointers ptentp) could
go in independently. Same for David's suggestion on patch 5 to replace
the huge_ptep_clear_flush() stub with a plain declaration.

Thanks.

-- 
Catalin

