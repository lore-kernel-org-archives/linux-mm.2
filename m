Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F03E3CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:47:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038AE6B009F; Tue, 29 Sep 2026 04:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C646B00A1; Tue, 29 Sep 2026 04:47:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1C966B00A2; Tue, 29 Sep 2026 04:47:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE88B6B009F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:47:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 580F112045A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:47:43 +0000 (UTC)
X-FDA: 85266171606.08.A170B27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id ADE41A0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:47:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OKK35Bh8;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iXU9WKYyz2HshOVhT6ETdZXfSguTHd4IIQU9aRF/ioU=;
	b=jJCkhlBYF19kyv7ZCG6AA7wCcR6Zop1LsmiaUporf3Zb3tIGJpPrDT3KnDZ+3Kr3M+oCSA
	1Uajl0no7MyS7P+A+Fe2AYE9gPcSDPv2O400LMJDDCnWaLYOJiYwckfe/7SC5VwFcKTCkv
	4z3vLU3ZXLj501onGpHNDqvdcHhCnYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671661;
	b=u7xrifbxFkKlQbPk21n8+o9u02/DFhd3YWfNViD82S/llmJJ9GdQ35j2LvAeLCe2YYSLx0
	14rPsGzLE5Qa1FIDP1Fl00fVO6s5Gai+tzZcEqO1NU+JUP2TdQ4ZLpJJ7K5JKmqeyE/84j
	AOuDW8/Wayz2GMq1l9+calFwBBpIjX4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OKK35Bh8;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E7ECC43958;
	Tue, 29 Sep 2026 08:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6799F1F00893;
	Tue, 29 Sep 2026 08:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671660;
	bh=iXU9WKYyz2HshOVhT6ETdZXfSguTHd4IIQU9aRF/ioU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OKK35Bh8R/0RgBY8cs1ma82GYgIamBoCqyPdGcJ85FQDOijyspUN8TODjqODl7P9S
	 k0fEZTwTCmITfKXU02h0CS4pQ4YFIknAv1EQ/6TDYsjAOn+jgjdskCVy+O362T6Iby
	 LsSndhImXG4OWhp3hDTUpHc08QPULUA6Hl5zr9mPyjKuvyztTwAcNK/DSeuYQHnRCt
	 TRhV12bFfG7viOh7n7iiH932ibV6sxSAEuu0+xzY1blj9rtexUcgJfccnV+0cSqiF6
	 ASnqmAVMei+FLy5MIDpi7PMPzy2gcZ1ouVS0ihtKUTnCX+fKkHullHXqNFAN1EiGkj
	 p7IlWX4BHFRug==
Date: Tue, 29 Sep 2026 09:47:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Park Tae-sun <ts930@dgu.ac.kr>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
Message-ID: <art6x0XpWcT2aUyy@gremlin>
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
 <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 7eog97fwubd98ny3sf8nii9kad47fdzx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ADE41A0006
X-HE-Tag: 1790671661-956903
X-HE-Meta: U2FsdGVkX18ccqOW2NsuyRLCSYijfjHN7FPN2eVWiC5FrXvcCD+Sacya4GHNQ1fP5OmWlCYOq5Zpf7NGm1jZDfZ+lsGemAb+piWZgrb3gvausTOzgUuU0bAM0NBGpwvLTno12/Y8hnYS1+mb0tMZ6DUV+X8LZYnVOVQhcrIOhT45zaxktmtUrb9YZ3ruKkBO5t8Suzsde1mD4fmOIqb7+cgJFvw2Izx5bhJfsF435ICDbayYt4zg3BqG/bASWSIuED/Laserw/pPaoRCKlN8fi21a5wtXZTETmdfnQMVA6bZKWxJdt0wh1vGjFScGUJ8EdDnpn9WbsNGNy/vommOQFx5Nwo1pnIniVUos4HCLbK/RHBX3PYz3soNawmU172fgGCBR1T1rlrKhJB43alxA8yX+51fN8elC9/914AIdKMTr/NP4abEw3oNhr6opj1amAEgmZtmnJE5ZIERWi10Ldc/amlEex8Vx+2ImHQlUJYsxAcMC4q14UMknb64JYrcBusrJiNfa59s7znnfcS//LV3qA6xbPFs+gV+yuXAqS3fli0dlfcCCKBq7QDWq72eEMDdowoYWDdsZVXDcChOSagnXamMiwJKp/2cv9MdN+dzwz1YgbeDL23OX2Ir4MC4+iuHqvKWBHBOYICOwFetkyVYgFfel9wNhw7FNOrjrLitn+AYrM/TH8PKUNc2dwgEliivq1VTkIQVEKNBSuGKZ/dXujnZTBIt2LDpN94QTM8rEnqRE0yMIFjPjo9ct1SKNMRIEC5ZsFjFomrFmOcI1b9dbno9fZH+hBLOuzrX3Lk+C3A1R/IeCpcQWhxARbfXVXClU+Bvwxd2B53Bov0Dqlua/xOP0BB2Ns9ro8jACafhgCSgTUjcb43uDFO4Qx+JILg9XyW9sxIiqMbJIuDJyqwqxiA2abeOwlI+hR+FXVPVvC466UczWqHXck+C8aHkKtj01GmPJ90WG2DlCNS
 2fhHYoPS
 FbKs/1mgdwZ+Oh0VKrdciM+/3K87Qn0rgwmo4W0trx5LKtkhE+yj1Mm0q9fd1tbCq4z3nYocm6P4tYf8AKHdEKqhEwa/YHrzdm/xB4eSIc0PEsTyD5s7kZEDESB6ueMpUmqCrVDV4kPfk84Tbsrix72fxbNIiCmvjJHNJGBdoYKpWYIad/phFTYUBcbkN9xs/o5dg0Ldd4B4Ae8iWcp0JipGNvYme7BVeb/C38RiCKAzwpdTTDRo5IerSwPs6WAR8j9R8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 29, 2026 at 10:40:13AM +0200, David Hildenbrand (Arm) wrote:
> On 9/29/26 07:56, Park Tae-sun wrote:
> > mlock() and munlock() currently normalize the requested address range
> > using:
> >
> >     len = PAGE_ALIGN(len + offset_in_page(start));
> >     start &= PAGE_MASK;
> >
> > This performs multiple arithmetic operations on user-provided values
> > without validating intermediate overflows.
> >
> > First, a zero-length request with an unaligned address is incorrectly
> > converted into a non-zero page range. Because
> > PAGE_ALIGN(offset_in_page(start)) rounds any non-zero offset up to a
> > full page, a request such as mlock(0x1005, 0) falsely locks an entire
> > 4KB page (or fails with ENOMEM if unmapped), and munlock(0x1005, 0)
> > silently unlocks memory that should remain locked. Conversely, an
> > aligned mlock(0x1000, 0) is a no-op. Zero-length behavior should be a
> > consistent no-op regardless of address alignment.
> >
> > Second, a sufficiently large length wraps around to zero during page
> > alignment (e.g., len = ULONG_MAX). Because PAGE_ALIGN(x) is defined as:
> >
> >     (((x) + PAGE_SIZE - 1) & PAGE_MASK)
> >
> > when len is close to ULONG_MAX, adding (PAGE_SIZE - 1) wraps around:
> > on a 64-bit system with 4KB pages, ULONG_MAX + 4095 wraps to 4094, and
> > masking with PAGE_MASK clears the lower 12 bits, producing 0.
> > When len becomes 0, the subsequent check in apply_vma_lock_flags():
> >
> >     end = start + len;
> >     if (end == start)
> >         return 0;
> >
> > evaluates to true and immediately returns 0 (success) without locking or
> > unlocking the requested memory range. Similar wrap-around issues have
> > previously been addressed in mincore() and madvise() by checking for
> > zero length after PAGE_ALIGN().
> >
> > Finally, address addition overflow (start + len < start) is currently
> > detected only inside apply_vma_lock_flags(), after mmap_write_lock has
> > already been acquired and memlock rlimits checked, improperly returning
> > -ENOMEM instead of -EINVAL. Per POSIX.1-2024 and man 2 mlock, arithmetic
> > overflow of the requested range represents an invalid argument and must
> > fail with -EINVAL before modifying VMAs or acquiring locks. Note that
> > apply_vma_lock_flags() already contains:
> >
> >     if (end < start)
> >         return -EINVAL;
> >
> > but this was obscured because rlimit accounting preceded it.
> >
> > Introduce a common check_mlock_range() helper to:
> > 1. Return 0 immediately for zero-length requests without taking mmap_lock.
> > 2. Validate intermediate and final arithmetic additions using
> >    check_add_overflow().
> > 3. Reject lengths that wrap to zero under PAGE_ALIGN() with -EINVAL.
> > 4. Detect start + len address overflow before taking mmap_write_lock.
> >
> > Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>
> > ---
> >  mm/mlock.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++--------
> >  1 file changed, 47 insertions(+), 8 deletions(-)
>
> You call it "fix" but then I see no Fixes: tag.

Or an Assisted-by tag :)

>
> Which of the problems described above have reproducers (IOW can be triggered)
> and what is the user-visible problem?

Good question!

Also note that the code is just horrible - 2 output parameters into a function
called 'check' but mutates all of its input, deref of the input parameters
throughout the function, useless comments, etc.

This patch is not upstreamable, and if it's LLM-generated I'd rather that
somebody from the core team did the work if we wanted it.

In general, I think it might be helpful to have a general 'check for overflow
stuff' function that various syscalls could use, but I'd want to see that
developed by an experienced mm person.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

