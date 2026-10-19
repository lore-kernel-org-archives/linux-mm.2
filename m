Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 174FF606A32D
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 20:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=bQ0FX6HN
Received: by kanga.kvack.org (Postfix)
	id 2120B6B037E; Mon, 19 Oct 2026 16:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EAF16B0380; Mon, 19 Oct 2026 16:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126A16B0381; Mon, 19 Oct 2026 16:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CE5956B037E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 16:53:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2CDA5120294
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:53:43 +0000 (UTC)
X-FDA: 85340577126.13.3981D1E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id D0FFB80009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:53:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bQ0FX6HN;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792443221;
	b=IwdKxarNdM43TnpfaHkYvnMgi+rkbCqxiXGeDsVFIP3ZlL5A65j5Pv/BItjJJCR/mqnD/3
	BJ6du6vMS+B10VUhgNZQ1lJRhtNP5aStxKrJ4nbCwBBaZ6XX86LCI3+rTtzYHl0G9tsqD7
	eQceiAVeVwYfkvlqYoomjDTZK4qw/Js=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=bQ0FX6HN;
	spf=pass (imf02.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792443221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccM+tB35AWZe4vsxbl8ZkFdtD87yJwwquhmHcKeVI9Q=;
	b=CB6vu8dfwyjzDFKqVbka0lWZm3BN9skRAHzgEpYzahDzWT1HvjZBkdPM4g/nqpkjRwipGU
	Oxi66otVtwFGQcvipyETd/TmOznSFn8IcrTnQ+1TtTHyTcEOd+AmYonILLB0+pL1OQ1gfz
	r6D29Dwy6Rbcy8Jdf4RJKvTJapbuzxg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ccM+tB35AWZe4vsxbl8ZkFdtD87yJwwquhmHcKeVI9Q=; b=bQ0FX6HNdwX6jQVJyiY2V8qoHk
	qEKvQn56Rz+5qUg+/xuZ5c5AHOqLGgFPgYRkABo2a8WSA0LF32w8pgJeEhf5P7Jz61DsECOxY/MxF
	m+hCkw9dp8jp2awnLdTlDFXwypE4jU3MuOmm/9LNoFA0ob6txwVFmC8m3BsUKsLxwCHuIiapFDMp1
	XcKLe/CDAX4zBGQYBBKUAOWM+r7fza84Fn3dcCYlngrtRLEQBAawai8+8qzMJ8ud799ZBU4krm5eN
	Qn6T5a240aAOGNuJ9FgPwruEv5DudjjPVlz2LeJxFgBQGdB2w+e9u5+wep7Oyt4Xt1uzRao0DjETO
	WtIyCGvA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xIuMO-0000000B396-13ug;
	Mon, 19 Oct 2026 20:53:32 +0000
Date: Mon, 19 Oct 2026 21:53:32 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Barry Song <baohua@kernel.org>, Hongru Zhang <zhanghongru06@gmail.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, surenb@google.com, david@kernel.org,
	liam@infradead.org, mhocko@suse.com, rppt@kernel.org,
	shakeel.butt@linux.dev, vbabka@kernel.org, zhaonanzhe@xiaomi.com,
	linux@armlinux.org.uk, catalin.marinas@arm.com, will@kernel.org,
	mark.rutland@arm.com, linux-arm-kernel@lists.infradead.org,
	chenhuacai@kernel.org, kernel@xen0n.name, loongarch@lists.linux.dev,
	maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com,
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, pjw@kernel.org,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr,
	linux-riscv@lists.infradead.org, agordeev@linux.ibm.com,
	gerald.schaefer@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
	borntraeger@linux.ibm.com, svens@linux.ibm.com,
	linux-s390@vger.kernel.org, dave.hansen@linux.intel.com,
	luto@kernel.org, peterz@infradead.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: Re: [PATCH v6] mm: retry page faults once under the per-VMA lock
Message-ID: <ataDTEZIKOYtwhUF@casper.infradead.org>
References: <20260911025613.1220845-1-zhanghongru@xiaomi.com>
 <arFYRAa-i7CIwmHL@gremlin>
 <arF-E3Nsw9ZliH0t@casper.infradead.org>
 <arI_w2wTfA00Mgy9@gremlin>
 <armexcXDiG8ryZd6@casper.infradead.org>
 <CAGsJ_4xuFi7K+crAcFQ998SxXS0xPM6QeA34JV+6+Sy005rXLg@mail.gmail.com>
 <ar7MsOb6IJLt4eLo@casper.infradead.org>
 <ar-o1TrOMGrrcxLX@gremlin>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar-o1TrOMGrrcxLX@gremlin>
X-Rspam-User: 
X-Rspamd-Queue-Id: D0FFB80009
X-Stat-Signature: gedknn3opga1ags39qog3rqx1h3u4hk5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792443219-422001
X-HE-Meta: U2FsdGVkX181x4uSIXeK0OwIZj2h6tSWtbGUNnQy8NttlpggbuIsApSdCZV/sdp2pmyRFPnUNT9cwM47zMXeMcrOBnoxdrBSte9x22WqEoGmah7m7c5kPwZ2rC4EvN7Y7cvZYd5b8mdNCjmDTZGJU5PkZ4wJxemHPhsj1f9Dle6ZMuAEJkPCC1OSHOCwMQWuLg0ZUy3YuBgBt00LeoSSmg6887hhv16sgiwc/go+4pJ09qlgQUt1xBDyOeSoyCj6YX6Rg9kaKjrHmPJV5mQxPnyGlo9C8dmheopKM7Rq9YYQp4NVKS4Lcm8V6K5H0tw7exfWsZlxxEXea1GxTqwmA+Wl9vQlSsoqU1wQoWKVf5QT4qeyJf9xTvZxBSz0zWMKf1l6M6XDZgw4ZPzO06wnoKyR+Y/vSbxxi7Hs8b6GQKKhTFJr1R3onB5BiSpw4K0jSH4FF2TXAr8G72aq5aVgnHPXFQeM2zmiLBnn8mD5vZtRU0a752DUEj29PdOBLU9FhohHYeOSGz/J5YpD3sdu18O09cZau1DAaJjJxVrrp9iatk1VIfOuxrMv4hZ9UUA17tkCMo0Xt0h08gkJCFYPhG4UUQL37uZFhhdOx+379FsNEedDbk2pDfNPWmdo36RLZBe2C9ttAxTwugI94tuSjb+L19gQ0uyLn63xwMCUYjBbjTDMXQrexa8jE9vLwypIccVeK4dwL81XAolBJzdWi07ldodmNVB4lwMOfnGjIjL98SxDT6gXPj0tsametLXGn6pyKsMyTpG4wrYIP7IVnfO0YgB7L1YLRXW+buNW355AThTuP9waGATTgfaprm6mYnCN0Xb/CQZ79nbuB4dNDmOwiHTnIvT3FH55AXo5eO46tO4GiRyK+PaP2T+UQGVZxeGEhx+YGhXp517YovCLKwY9cpQukswpLM+EUXVC23jee3NXsq4TzWat+3p02lLXQJJzn0jI6qgTCes1ztU
 4LhIQhw2
 pTlzQTugJizmS9aevZTX28wYh5qBeK2sLFEzK4wWkrcS5VE0yRSukF5KQuwDhiFhdBIJn/8Pct7JmwHShJa6qhSjUcXo6r3V8k6K3hAOKQc006U5MHn9FQPulGGWKjWpy9eTOrpauJ+HrxsI/d0L3C/ffveytyXOiFyia3cnMY50Y0sxfTEu+BlVpNARaX3vQY2pvwOC1ggMLuMo07p1REjvljZshH7bIsP/4b/27eaoVabJn7/+MIFgaOPMUg4QCtSDZSx26YYpUfNXmn3r/1Cbg2ny28ntP9uBVoLN71aNpLSLs5CoC1j9i1EdueLlWY67zoXwxu5BeRBjrLv/k8tbjjTGYWU2+63km
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 02, 2026 at 02:12:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Thu, Oct 01, 2026 at 10:12:16PM +0100, Matthew Wilcox wrote:
> > So what I didn't realise is that fork() waits for page faults to finish.
> > I don't think that's necessary, so we can just stop doing that (whitespace
> > damaged):
> > I think this is safe.  I've booted a kernel with this change, and
> 
> I'm afraid it's not safe :)
> 
> We already actually did this (by mistake I think?) before. See commit
> fb49c455323f ("fork: lock VMAs of the parent process when forking") - we shipped
> that in 6.4.0 -> 6.4.2 and it corrupted memory all over the place.
> 
> Reports + a consistent reproducer:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=217624
> https://lore.kernel.org/all/dbdef34c-3a07-5951-e1ae-e9c6e3cdf51b@kernel.org/
> https://lore.kernel.org/all/b198d649-f4bf-b971-31d0-e8433ec2a34c@applied-asynchrony.com/

I wonder if we still need this.  The commit message says:

    A concurrent page fault on a page newly marked read-only by the page
    copy might trigger wp_page_copy() and a anon_vma_prepare(vma) on the
    source vma, defeating the anon_vma_clone() that wasn't done because the
    parent vma originally didn't have an anon_vma, but we now might end up
    copying a pte entry for a page that has one.

But we're holding the mmap_lock for write here, and we need to hold the
mmap_lock for read in order to change a vma->anon_vma (asserted in
__anon_vma_prepare() with mmap_assert_locked()).

At the time of this commit, lock_vma_under_rcu() contained:

        /* find_mergeable_anon_vma uses adjacent vmas which are not locked */
        if (!vma->anon_vma && !vma_is_tcp(vma))
                goto inval;

so we really did have to wait for read holders to finish the fault.
But commit a373baed5a9d deferred the check for a NULL anon VMA until we
actually needed it, so I think commit fb49c455323f's logic was invalidated
by a373baed5a9d.

Maybe I'm wrong.  This is all a bit out of my normal area.

> Also we have asserts for this lock in copy_page_range() and
> copy_hugetlb_page_range() which will now fail (and possibly more further down
> the stack?)

Possibly we have to adjust some assertions to check that either we have
the VMA locked or we have the MM write locked.  That doesn't seem
unreasonable.

> > My argument for why it's safe is that a thread which takes a page
> > fault during fork() might have taken the page fault either before or
> > after fork().  The faults will definitely happen in the parent process.
> > They may or may not have happened in the child process, which can't
> > possibly care whether or not they've happened.
> 
> The problem isn't the child it's the parent - copy_page_range() _modifies_ the
> _parent_'s page tables in-place, on assumption that nothing else can access
> them (for CoW).

I was perhaps unclear.  What I mean is that the child may or may not
observe them as having happened.

> And actually nowadays things are _even_ worse, you could also have concurrent
> page faults, MADV_DONTNEED, MADV_FREE, MADV_GUARD_INSTALL/REMOVE, UFFDIO_COPY +
> UFFDIO_MOVE (yikes) all of which might introduce new issues + would have to be
> audited too.

Yup.

> So - it turns out a lot of stuff implicitly assumes VMA write lock now:
> 
> 1. CoW - deferred TLB flush race
> 
> (The issue above)
> 
> https://lore.kernel.org/all/20230705171213.2843068-2-surenb@google.com/
> 
> This happens because __copy_present_ptes() does wrprotect_ptes() on the parent
> without a TLB flush (that's deferred until the end of the fork).
> 
> But unfortunately without a VMA write lock something can then replace the page
> table entry in the meantime and you can end up with data loss as a result.

Is it that fb49c455323f commit message is insufficient and we need to
prevent simultaneous fork/page fault for other reasons, then?

> Same issue exists with hugetlb wp too. And god only knows with uffd wp :)
> 
> 2. THP - can destroy parent THP mappings
> 
> copy_pmd_range() does:
> 
> 	if (pmd_is_huge(*src_pmd)) { copy_huge_pmd(); ... }
> 	if (pmd_none_or_clear_bad(src_pmd))
> 		continue;
> 
> Without the write lock, a concurrent fault can install a huge PMD via
> do_huge_pmd_anonymous_page() or filemap_map_pmd()/do_set_pmd().
> 
> The issue is that pmd_bad() fires for leaf PMD (ugh) on at least x86 and arm64,
> meaning that'll clear the page table entry.
> 
> I think Hugh left a comment alluding to this before:
> 
> 	 * copy_pmd_range()'s prior pmd_none_or_clear_bad(src_pmd), and the
> 	 * error handling here, assume that exclusive mmap_lock on dst and src
> 	 * protects anon from unexpected THP transitions; ...
> 
> It's like the mess around pmd_trans_unstable() :(

... could we fix this by taking the ptlock during the copy operation?

> 3. copy_pte_range() skips the required pmd_same() recheck assuming write lock
> 
> It uses pte_offset_map_rw_nolock() with a dummy pmdval and:
> 
> 	 * We already hold the exclusive mmap_lock, the copy_pte_range() and
> 	 * retract_page_tables() are using vma->anon_vma to be exclusive, so
> 	 * the PTE page is stable, and there is no need to get pmdval and do
> 	 * pmd_same() check.
> 
> (Probably needs updating for VMA write lock...)
> 
> 4. The asserts
> 
> Mentioned above!
> 
> I suspect there's more as well.
> 
> Some of it could be changed, but it'd all be at the cost of behaving very
> strangely (no VMA lock but mmap write lock) while manipulating things.
> 
> And I am not really happy with changing page table entries in the parent VMA
> (for CoW) without a VMA write lock held.
> 
> I also wonder whether it would achieve all that much really - the issue is with
> holding the VMA lock across I/O, anything else that tries to grab a write lock
> is going to end up being the new thing that's blocked (mprotect, munmap, mremap,
> mlock etc.)
> 
> I think doing something like this would need a very significant redesign and I'm
> not convinced it's one that really achieves what we want given all the other
> cases that'd get blocked by the VMA lock being held still.
> 
> --
> Cheers, Lorenzo

