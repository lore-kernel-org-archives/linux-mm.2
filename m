Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8866EC01DD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:08:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0406D6B0005; Mon, 23 Mar 2026 08:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0BCB6B0088; Mon, 23 Mar 2026 08:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD3C86B0089; Mon, 23 Mar 2026 08:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C55876B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:08:17 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 68E88C358E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:08:17 +0000 (UTC)
X-FDA: 84577205034.02.07F850D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CCC4218000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:08:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ow8F15N3;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774267695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZkq9tvzx54BPQAmuVaJL1qTUOQ7K6UzWhURF3KhLC8=;
	b=S6E1D9sNps/PuramM6eVHf5bgyToGlw2e+SiBdReOUbI4wiltOVvq46Y3SIOpKSs1aseR+
	RmySIJ098SkCd9/UVea397/yjqz8i3TTNvjzR61SoudYKoO1lUpzZ34+YL3dzdaUNryiyh
	h5715sEn7WskIQIS09cFL9ghHFe9O40=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ow8F15N3;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774267695; a=rsa-sha256;
	cv=none;
	b=1PwqT4zYuL9Tsz53VzKkYGRUKAvCnWZmWYKUa88lxxlYf0Ee705lYjQKsYbehxUfVVMp7o
	rbd/Ec4owlHCBQkJqKUhCp2961aPIS6YcYgkQnO1jkm43jQRY343GpkqrwExt4DVUCplwv
	vtO8+FbR3Mx9DIPNxo2WYZ5w0yr1xEo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 42B1D600C4;
	Mon, 23 Mar 2026 12:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D84C4CEF7;
	Mon, 23 Mar 2026 12:08:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774267694;
	bh=HVL2c2XxLWRYOhyFGyoq+JVMfTkgim8bRc2ZQUAxWQc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ow8F15N3NDc02Bx+b1VQ/uGVJLjcb4WW0RLsXBuB22HVDvW8uXWLB0VxESX/3IqCb
	 y/yk3wBlURyp3kbDJiwzuf/52dth+L82t58YEGptlUcDjLkxEVLN2h1jinbTOPLJZ7
	 XHdKJ0XmKKhyg1nI8RWSNmnSbG7F0H3Sqh6jOdbgVU47lrZyK9vLEpslBMHRz2s1nl
	 X7S4hmObgDPHVYlDACueMmPQembLuMjb/g6HOp2pu/DDFCxS7nAQlOhZEdB0v8RiWx
	 r+4DD2rtcHyRiTTseoj+Y+fsvOmwBWD2dSEk12HTWiAMmKx1yxUM8C3x6pNJdJexN0
	 D6sMZex969qJA==
Date: Mon, 23 Mar 2026 12:08:13 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 00/13] mm/huge_memory: refactor zap_huge_pmd()
Message-ID: <1d95d6b1-f9f6-4728-b393-15236dc8c208@lucifer.local>
References: <cover.1774029655.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1774029655.git.ljs@kernel.org>
X-Rspamd-Queue-Id: CCC4218000C
X-Stat-Signature: wtpq547ska98mo3wzjono4f5jenrx7n9
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774267695-625979
X-HE-Meta: U2FsdGVkX1+xB0naXHKsRAbvdAx9oS6wy6UOs95VTTlwA3mwIR/WcBu+qr3clM+22WdG5iMibWU4hANot4PSsFrW4QkCBvOkYZE+Xa4ux28tmSGlLF6hjN8cfGpNMuW9LPewF2TU8Dwp3oYOKGHH8U9qbU91spSKJGOq51pRhtl3ViDg7Nr4aIvzmM1mlP6ruKN8tbcNraW1WYx93votdbtIc/8kBp85tutHgqVMTn4aFcvva0J8BqSRS6yoXp8RjCoTLSG/nxjeW3OiglfJzMK7K8ulZMsZBCghAVPsmwTV5CUCyCj7+I7pt9eb4HHmiWCIPqjcY8/hzOXT7hAhLTpnzdnuyf6fUnwU5lb9MHpBaGNdEdHKq77kW8CGCEiLaaBAwKGcYzdF6Wp5VMU4PQN1d1/ehU0RxpdSMAR0XbEsDj0kOaiNPLlSEA4OoL6J3MJ8iAyC2G2B8OLXoTnlb7w6wic8XdhEzxLVaiujjadzHPat4HZW7ECWqkkm3WFQ7qdITfrZyr0e7+iv70mbP95kNjLQadaFtePAE5f85uNZDz65+DKTIVu6M/mwUbgGZp3E6WFt1bICc8YU4clSXyCDIm71X10EEXACa0H6GAm5ycllBCGuSphc/nkoDpXSe+QGoZxT5pOSim3ybSNYZzkl3Bf386LK99V4xLv3S2lfid4Qwax+GfYi2dobRWJ8Y3tpiJBG/qTaxpB2U+AvmG/hFA4fyj7KvehJa4QZl8dYaMrJfs1AbQAeLpOeO97rUiojWLuL40UBShMarbSBMnJMpujcu/tJ0Ey9C3hWrUpP+LLzFHdE0fsyL4l8otiZ0XhA828XY2IzGJ5NqnJn0IoEfB1owIVFkFeITY2fd7qYG+mBS0xz+o2KYwuAV+VxVeI0o60PvRZg+/Q68xWgZP+eFAKQDb9mV3h4D/5tH/e2UtlIn4NfpPZ0Ut0AO9tcy9+8S7wzmCll4scNzwH
 dwjF8qHv
 rT0E8g9euwaAiTvPZfC7RchOce3HAC2pRQKkp+EUVGRlXn9AgYVamJMZpqYrAgUL3FtMDG965dP+7hQK3SS8nT0S+LLAzixIK20HFME80mWK1HNhcFR+DrZy9eyJ+ftUArTCww/0qwSUC2hU1VGSb85iCpzPh/CuluvnwuNnS4+hKZZBBQD94Ruk4wRt7ka/N7uyZCE462lR2JwHn5Mu1aLDsYb7GGMDLz8gSVOy5Y4HLA2d5nip4RysqeEZhDZzpS9vN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I really don't want to have to reply to every bit of noise generated by
Sashiko, but for the sake of it, the stuff I'm not changing:

4/13

>Are other PMD handlers vulnerable to this same userfaultfd bug?

That's completely out of scope for the series. It's not a regression, it's
a suggestion for future work and so shouldn't be labelled as such by it,
instead of listing a 'high' priority regression.

7/13

>Is it possible for the error path immediately preceding this block to trigger
>a NULL pointer dereference?

You're already at the point where something has gone horribly wrong and a
bug in the kernel renders it unstable. It's not really worth trying to
avoid every possible bad outcome here in case of kernel bugs, that's not
practical and not worth the maintenance load to put such things in.

Also if I add this, it breaks further refactorings for the sake of
defending against a specific class of kernel bug - that's not worthwhile.

10/13

>Could evaluating folio_is_device_private(folio) cause issues if the PMD
>contains a migration entry rather than a device private entry?

If this is even possible (I don't think so), that was an existing
issue. This is a refactoring, it'd not be appropriate for me to
fundamentally change behaviour at the same time.

>This isn't a bug, but the comment still refers to flush_needed, which was
> renamed to is_present in this patch.

Baolin already raised, and I don't think it really matters to leave that
comment in there as it's removed in a later commit, and a comment isn't a
bisection hazard :)

11/13

>This isn't a bug, but the kernel-doc for pmd_is_valid_softleaf() states
>that it asserts the validity of the entry, while the function strictly

This is a turn of phrase...! Anybody wondering can go read the function.

>returns a boolean without triggering any warnings or bugs.
>Would it be better to update this comment to reflect the actual behavior,
>especially now that an actual assertion has been added to the neighboring
>pmd_to_softleaf_folio() function?

I think the CONFIG_DEBUG_VM assert itself is pretty good documentation of
there being a CONFIG_DEBUG_VM assert honestly. Should the kdoc comments
list the code too?

>Could this warning be written to evaluate the condition directly?
>if (VM_WARN_ON_ONCE(!softleaf_is_valid_pmd_entry(entry))) {
>        return NULL;
>}
>When VM_WARN_ON_ONCE(true) is placed inside an if block, the kernel's
>warning machinery stringifies and prints "true" as the failing condition
>in the backtrace, which makes debugging more difficult. Wrapping the actual
>condition inside the warning macro ensures the specific violated constraint
>is visible in the console output.

This is a silly comment anyway, you can figure out why the thing failed
very easily and this is a common pattern in the kernel.

But this is also a hallucination, VM_WARN_ON_ONCE() is defined as:

#define VM_WARN_ON_ONCE(cond) (void)WARN_ON_ONCE(cond)

So you know, that won't work, and even if I did it's a silly and pedantic
comment. Plus you don't use {} for single line branches...

12/13:

While the comment about deposit was valid, the comment:

>For non-DAX special VMAs, this also forces has_deposit to true even if
>the architecture does not need a deposit, potentially attempting to free a
>non-existent deposit.

Is another hallucination.:

	else if (is_huge_zero_pmd(orig_pmd))
		has_deposit = !vma_is_dax(vma);

This is the line it's discussing. So we're explicitly gating on
is_huge_zero_pmd(). It's not any 'special' VMA.

And in the original code:

	} else if (is_huge_zero_pmd(orig_pmd)) {
		if (!vma_is_dax(vma) || arch_needs_pgtable_deposit())
			zap_deposited_table(tlb->mm, pmd);
		...
	}

With the fix-patch applied this is 'has_deposit = has_deposit ||
!vma_is_dax()' where has_deposit is initialised with
arch_needs_pgtable_deposit(), so the logic matches.

--

Dealing with the above has taken a lot of time that I would rather spend
doing other things.

AI can asymmetrically drown us with this kind of stuff, radically
increasing workload.

This continues to be my primary concern with the application of AI, and the
only acceptable use of it will be in cases where we are able to filter
things well enough to avoid wasting people's time like this.

As I've said before, burnout continues to be a major hazard that is simply
being ignored in mm, and I don't think that's a healthy or good thing.

Let's please be considerate as to the opinions of those actually doing the
work.

Thanks, Lorenzo

