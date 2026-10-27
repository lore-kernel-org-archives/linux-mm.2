Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0269D606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AYF6Nujr
Received: by kanga.kvack.org (Postfix)
	id C31816B0830; Tue, 27 Oct 2026 12:26:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE2366B0831; Tue, 27 Oct 2026 12:26:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD0D46B0832; Tue, 27 Oct 2026 12:26:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7FEB76B0830
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:26:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 21CEC1A0A50
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:26:56 +0000 (UTC)
X-FDA: 85368935232.17.1FF4946
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87E00C000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:26:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYF6Nujr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVztOefSr6RGv9a+LEvxXW9LNnBlncUZ/0ear6QgNKQ=;
	b=cH7PWFIs4QkIlZSBRlfyZfAg5viL6M4YdshouYal8N0S6u2Ba0ZoOk/MCNGlLixq6fy6bc
	eIiv5jXhboGtvUYCpi/VNiv1z19Dlaadi+c8gwkjMWQA6qv82CxbPIz+j2q7+NUO1gq7AR
	/al7m/JhxeEonayEzGknnu5A5HT+lG8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYF6Nujr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793118414;
	b=R2cy9wD/juyGa7ioXjOO8uWegjmThjzrZH/Nf4aW0DBauZSvtOcUNO501iDtaRlojCRX8W
	Qb0hvzdTgOSOyTAa8ytUkZdWtsZC0X3g4TaHc+TxI1z0ggQrp7YafVOUyQjSfsg2rhxW7i
	USiCMW+a9ZidwRYRkooMtzeOF+t3PuY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE8216022E;
	Tue, 27 Oct 2026 16:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D75B1F01825;
	Tue, 27 Oct 2026 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793118413;
	bh=PVztOefSr6RGv9a+LEvxXW9LNnBlncUZ/0ear6QgNKQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AYF6Nujr9m//y5ikHA4j466AfvrCQx4vNn/XB/n7NEExqqcW6ZpNIEMDq3FFbZmBL
	 o1Hur8PsCuovf3g9AxXHBJrE3r/kKSk4vTe1xjoUHFg4yAzCRq+xer6ywBG0Nd1vSD
	 82Y9oCIPZQbhC3ypd1xjTPpPBsmljLlMoBgoJZnHErRqYEgAGT6XmSjYEOOttGbY6P
	 ULahHSJEshFYy/gm0WSYHeg9Y6lx1PkcRYz+HE8gX+awXWIPCV1JNMaeFr8Jpt6yPs
	 4K8gbzfPgF94BwtUft4WlXRuoSoaIrz5W7sZHkvwN8lZUnsIhvAoZExUL7TtjY1ASP
	 u52r8Xsn29uPA==
Date: Tue, 27 Oct 2026 16:26:39 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Barry Song <baohua@kernel.org>, Hongru Zhang <zhanghongru06@gmail.com>, 
	akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	surenb@google.com, david@kernel.org, liam@infradead.org, mhocko@suse.com, 
	rppt@kernel.org, shakeel.butt@linux.dev, vbabka@kernel.org, zhaonanzhe@xiaomi.com, 
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	linux-arm-kernel@lists.infradead.org, chenhuacai@kernel.org, kernel@xen0n.name, 
	loongarch@lists.linux.dev, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, pjw@kernel.org, 
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	hca@linux.ibm.com, gor@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, linux-s390@vger.kernel.org, dave.hansen@linux.intel.com, 
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org, mingo@redhat.com, 
	bp@alien8.de, x86@kernel.org, hpa@zytor.com, 
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
Message-ID: <auDGPs8jzC-90-_y@gremlin>
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin>
 <arF-E3Nsw9ZliH0t@casper.infradead.org>
 <arI_w2wTfA00Mgy9@gremlin>
 <armexcXDiG8ryZd6@casper.infradead.org>
 <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
 <ar7MsOb6IJLt4eLo@casper.infradead.org>
 <ar-o1TrOMGrrcxLX@gremlin>
 <ataDTEZIKOYtwhUF@casper.infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ataDTEZIKOYtwhUF@casper.infradead.org>
X-Rspamd-Queue-Id: 87E00C000B
X-Stat-Signature: d3sexe4zcgtggrh9jqng8j841i9ruyjk
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793118414-601656
X-HE-Meta: U2FsdGVkX1+E39MZT31SAapVWnPwvR0Gx2SpAsB4Gxi7hKkHvCKLPTDUrAuW+ckCCWvhP69fXOF7PbKTRaFc5ZoxrvKaZFVStNeMWWZ9DpXwNCfPd5TCNxkJ6ICXuVwzSNuS+jC0t/NKjOFLlSoazMIdrP90B04SGNVb1FLYBS3PaYg4Q6G3/u6V3bXFq8J2QbPcXEyfI5BPf+Pl8+0WsAm/rLZPXswRSsq/Mjy7LbBgGlZmxNfP20TNbKDrA8ANMA74Jy3EfQvH6/x+Nj2rL30xSDoWQK7FdCKIU4zWtDg/rhDKWq5UxfLFLweogeSofuVu4u4O88asj9E6QZb1B3vOND25RXglpV3LofbeFc5BWxgZyn+j3WL+lAz5HUIsu6CGjkdXPnhygBFWbxuAfRD/JKBk76n8OePW3v3LfoRCTIBhAPZsw/8FsnCpcU2lpDiAMKQA2mqVzEQxk7JolgvFBH0y/dRX4HDBbH7lwVkPQGAW20hTpwgVEn1pQ/vT1r3QP8+V2NhuKKG0boMWFg+LnezWxGqAM2t+NjNyMiG/yQtrMS6qtypQiVXO22/Hid3HBkPnpxUnIFtdmdeW0l408X2Dgp8wBGJdnjzSetuED9O8ePdunxoIaMgRAs0fBVodRGPr/RgcDOVQitg/CIDJoQ9hzlilKiMWDQ+X1GyGgEMMG5si62YRuehYNGVXbAnjJTk3vrcFKlIs2AFSokcEqvX/fCKw3itkY2eRzam9na/MSPGfUXwGATI2FWJ1U1SptQdp5gwIQtWWx5ScXg/smAKe8JYV1/NqXXpWvDmdLPR/B1yY7PiR+XV4Gq3x6/mL35JMVodeoaPAGRUYs/5llA9aDVPtPrUGPCB4LdS/+BnpDxNQkq/f/Rmg7h46Q5K8qKUUHFab2cUs4/j7qKSgcAjgU1ePO6AxjPKT4KCVy8m/Vwhs6D5zOAwM/70gr83muvjejqgnb8JXwvL
 Q58ftKKo
 d9T081K/IjOzbI2HrxZTztQVyNe9dxMsKZnrtnWkx9FuHZzUbyFALZdyatP1h9G/txtRDD4Ebj+dqbNpBDZXNMR+hGfzX+rgJeNgnDOsxCTgrpmSIG+Ws6EptaSDzSUsSucNcdthBB3Q6a/Ou766CzeFQvJsshaPafZulmzf1ybnZ/TF6ukEemKSn/+SrNmxqNGFJS0/NU3JP0WFM1hc7BmPoaOQkeJ3s8lp/yu3rGpqZGqyCbjuTkyeYg3ZoAD32ddAQz+vcVo+yT4wT2ob+EAdZWlY/tLllX0vpO3w8RUvq0UACaasjpYdHuxt6FqXS9tphMf2BuWmhZxQ96i+HugXh5+WCJ9KR+OVV+7fCOumgV2nSeK7Tf9kS41QM9xxuJRkJ8WvjyhDVzZOVkUWnzMU4CDMPQjH6c+jtJlp14TeAm3cQS1CUwOMPyZ7JNCmh3NsM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(Thanks to Suren for his reply also, Replying to this mail to make it
easier for me to quote :)

On Mon, Oct 19, 2026 at 09:53:32PM +0100, Matthew Wilcox wrote:
> On Fri, Oct 02, 2026 at 02:12:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Oct 01, 2026 at 10:12:16PM +0100, Matthew Wilcox wrote:
> > > So what I didn't realise is that fork() waits for page faults to finish.
> > > I don't think that's necessary, so we can just stop doing that (whitespace
> > > damaged):
> > > I think this is safe.  I've booted a kernel with this change, and
> >
> > I'm afraid it's not safe :)
> >
> > We already actually did this (by mistake I think?) before. See commit
> > fb49c455323f ("fork: lock VMAs of the parent process when forking") - we shipped
> > that in 6.4.0 -> 6.4.2 and it corrupted memory all over the place.
> >
> > Reports + a consistent reproducer:
> >
> > https://bugzilla.kernel.org/show_bug.cgi?id=217624
> > https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kernel.org/
> > https://lore.kernel.org/all/b198d649-f4bf-b971-31d0-e8433ec2a34c@applied-asynchrony.com/
>
> I wonder if we still need this.  The commit message says:
>
>     A concurrent page fault on a page newly marked read-only by the page
>     copy might trigger wp_page_copy() and a anon_vma_prepare(vma) on the
>     source vma, defeating the anon_vma_clone() that wasn't done because the
>     parent vma originally didn't have an anon_vma, but we now might end up
>     copying a pte entry for a page that has one.
>
> But we're holding the mmap_lock for write here, and we need to hold the
> mmap_lock for read in order to change a vma->anon_vma (asserted in
> __anon_vma_prepare() with mmap_assert_locked()).

I don't think that changed anything. Actually that paragraph is probably
just a bad example, since previous to a373baed5a9d lock_vma_under_rcu()
did:

	/*
	 * find_mergeable_anon_vma uses adjacent vmas which are not locked.
	 * This check must happen after vma_start_read(); otherwise, a
	 * concurrent mremap() with MREMAP_DONTUNMAP could dissociate the VMA
	 * from its anon_vma.
	 */
	if (unlikely(vma_is_anonymous(vma) && !vma->anon_vma))
		goto inval_end_read;

So the example cited couldn't happen then either.

I think fundamentally the biggest issue is that, for CoW, we update the
_parent_ as well as the child to do wrprotect.

So you can end up with a stale TLB entry, which can result in data loss:

Thread A (Parent)          | Thread B (Parent)       | Thread C (Parent)
---------------------------|-------------------------|----------------------
< Fork >                   |                         | < has TLB entry >
copy_present_ptes()        | < no TLB entry >        |
  wrprotect parent page X  |                         |
  -> 2 mappings, refs      | *ptr = x                |
                           | < Page fault >          |
                           | do_wp_page()            |
                           |   < shared, so CoW >    |
                           |   wp_page_copy()        |
                           |     copy X -> new pg N  |
                           |                         | *ptr = x;
                           |                         | [ OOPS! stale TLB,
                           |                         |   lands in X not N ]
                           |     ptep_clear_flush()  |
                           |       < TLB flush >     |
                           |     parent PTE -> N     |
                           |     [ X now child-only ]|
                           |                         | ASSERT(*ptr == x);
flush_tlb_mm(oldmm)        |                         | // fails! N lacks x
  < far too late >         |                         |


David raised this at:
https://lore.kernel.org/all/7e3f35cc-59b9-bf12-b8b1-4ed78223844a@redhat.com/

So the real hazard here is doing the copying with concurrent faults.

I don't really think there's a sensible way around that, unfortunately.

The above is also likely what the bugzilla observed.

>
> At the time of this commit, lock_vma_under_rcu() contained:
>
>         /* find_mergeable_anon_vma uses adjacent vmas which are not locked */
>         if (!vma->anon_vma && !vma_is_tcp(vma))
>                 goto inval;
>
> so we really did have to wait for read holders to finish the fault.
> But commit a373baed5a9d deferred the check for a NULL anon VMA until we
> actually needed it, so I think commit fb49c455323f's logic was invalidated
> by a373baed5a9d.
>
> Maybe I'm wrong.  This is all a bit out of my normal area.
>
> > Also we have asserts for this lock in copy_page_range() and
> > copy_hugetlb_page_range() which will now fail (and possibly more further down
> > the stack?)
>
> Possibly we have to adjust some assertions to check that either we have
> the VMA locked or we have the MM write locked.  That doesn't seem
> unreasonable.

Well, no, because the VMA locks are designed such that an mmap write lock
doesn't exclude them, so that would be undermining their intent.

The thing is that we allow VMA read locks without an mmap read lock lock, so if
I hold an mmap write lock, I can have parallel reads of any VMA that is
not explicitly VMA write locked.

>
> > > My argument for why it's safe is that a thread which takes a page
> > > fault during fork() might have taken the page fault either before or
> > > after fork().  The faults will definitely happen in the parent process.
> > > They may or may not have happened in the child process, which can't
> > > possibly care whether or not they've happened.
> >
> > The problem isn't the child it's the parent - copy_page_range() _modifies_ the
> > _parent_'s page tables in-place, on assumption that nothing else can access
> > them (for CoW).
>
> I was perhaps unclear.  What I mean is that the child may or may not
> observe them as having happened.

Sure, but the issue is in the parent. CoW really scuppers things here :)

>
> > And actually nowadays things are _even_ worse, you could also have concurrent
> > page faults, MADV_DONTNEED, MADV_FREE, MADV_GUARD_INSTALL/REMOVE, UFFDIO_COPY +
> > UFFDIO_MOVE (yikes) all of which might introduce new issues + would have to be
> > audited too.
>
> Yup.
>
> > So - it turns out a lot of stuff implicitly assumes VMA write lock now:
> >
> > 1. CoW - deferred TLB flush race
> >
> > (The issue above)
> >
> > https://lore.kernel.org/all/20230705171213.2843068-2-surenb@google.com/
> >
> > This happens because __copy_present_ptes() does wrprotect_ptes() on the parent
> > without a TLB flush (that's deferred until the end of the fork).
> >
> > But unfortunately without a VMA write lock something can then replace the page
> > table entry in the meantime and you can end up with data loss as a result.
>
> Is it that fb49c455323f commit message is insufficient and we need to
> prevent simultaneous fork/page fault for other reasons, then?

Yeah, as above, the example given isn't great.

>
> > Same issue exists with hugetlb wp too. And god only knows with uffd wp :)
> >
> > 2. THP - can destroy parent THP mappings
> >
> > copy_pmd_range() does:
> >
> > 	if (pmd_is_huge(*src_pmd)) { copy_huge_pmd(); ... }
> > 	if (pmd_none_or_clear_bad(src_pmd))
> > 		continue;
> >
> > Without the write lock, a concurrent fault can install a huge PMD via
> > do_huge_pmd_anonymous_page() or filemap_map_pmd()/do_set_pmd().
> >
> > The issue is that pmd_bad() fires for leaf PMD (ugh) on at least x86 and arm64,
> > meaning that'll clear the page table entry.
> >
> > I think Hugh left a comment alluding to this before:
> >
> > 	 * copy_pmd_range()'s prior pmd_none_or_clear_bad(src_pmd), and the
> > 	 * error handling here, assume that exclusive mmap_lock on dst and src
> > 	 * protects anon from unexpected THP transitions; ...
> >
> > It's like the mess around pmd_trans_unstable() :(
>
> ... could we fix this by taking the ptlock during the copy operation?

Well, that's a long time to hold that lock, and while it might address the
pmd_none_or_clear_bad() thing, the CoW issue remains the same, since really
the issue there is TLB invalidation.

And the only way to address that is to just now allow faults to happen
during fork.

(I also fear there are other subtle bugs that might emerge from all this,
we do like to make _implicit_ assumptions about things).

Actually there's a pleasing thing you came up with at the time:

	Calling fork() from a multi-threaded program is fraught with
	danger.  It's a rare thing to do, and we don't need to optimise for
	it.  It does, of course, need to not crash.  But we can slow it
	down as much as we want to.  Slowing down single-threaded programs
	calling fork is much less acceptable.

https://lore.kernel.org/all/ZKQZnAfLRPVqnxiO@casper.infradead.org/

:))

It does feel a bit like we're bending over backwards for a broken use-case.

And anyway, even if we did somehow find a way to make all this work, I fear
we'd just move the contention somewhere else.

Perhaps the 'genius' hack of mine isn't so bad after all? :P

--
Cheers, Lorenzo

