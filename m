Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5786C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 17:09:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C87196B009D; Tue,  7 Jul 2026 13:09:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5EA66B009E; Tue,  7 Jul 2026 13:09:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75E86B00A0; Tue,  7 Jul 2026 13:09:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 874346B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:09:06 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0B28AA0506
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:09:06 +0000 (UTC)
X-FDA: 84962615892.27.FFE9C4C
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1B90B20004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:09:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aGzMQDkB;
	spf=pass (imf31.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783444144;
	b=37X9zEizSGP0IuaNmfVUzcjPkZpImZoiziIKYGprIbeGH0/tuHnGEjoZKUHAZ+coslO1vA
	W+m2kDcrYNszod/usIT4RyJe42xmYs8pf88lTKoV8oO5jpiC3g7/iV56Kj3B8Wb2vWoFqa
	offrX2j9gxjAlWUB5L4Q7+S5HujNR/U=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=aGzMQDkB;
	spf=pass (imf31.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.49 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783444144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O9lfVufk5V6ONvrwxd5qwRqQ5dHF658hNKhamzFjYII=;
	b=nwB70QcKAmSHtcHIiLaPHsJXWHN3ztQQDw1CmUN5wQOYNrMqUVSqL8bdjQofDJQ3ZsCUjw
	vuhRBMCmpI/tw7sY0LkAaqtIjbr9Cmt4nseK14227RsEiVksdrOK9XuTHuEwfxLpvyeg94
	wHgaMrC1CD+hwG2evpRklNIZS7GCaGU=
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-43bf9548df4so2598530fac.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 10:09:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783444143; cv=none;
        d=google.com; s=arc-20260327;
        b=I18MnxPrzwRUwDxLPBWhX6U3dubhzFh4Celxs/Oi//tVfsre6SdfWvXjRuDn5rfGBb
         ywGkA+MfRSMDJOQpdaEQ6k8G7Gy94agW8nxqbG/+Gipe6cF/xVHqUNBM6IfnyxcUF+M/
         AdtVPJYBJJWEV2greRhWCMlW5Sy1k7HlhrgDguNXYJOotSsV0yg8nMIjM0E8lIDpqaut
         aj2GN62+JVCHPMkdsFpD28dXGjoTgT1sh64ygLtQJnmyyurBYlrmZYCpR7+xJHQUxm3Q
         P3JT8p9aLKa/05P9eAD8RPrzH8mwXdCYhRfnqlM9oBJyguZKdX32lwKXjQwiqRRaJ8oe
         jyLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=O9lfVufk5V6ONvrwxd5qwRqQ5dHF658hNKhamzFjYII=;
        fh=Aa7nyvYz3+BTawWQwQud016qcQARC0zm5TQ7T85CPvo=;
        b=hONJtrT8fxDqq6fzY23oy9hpkiVeydK2FpAiutTPiaVMIA6GiNXEfPFw4RTZpcBvX6
         db1glmG+pffNauOgr5E6x7QKMS/z8MEPCpo81srzY0lHXp33zDfEVr2Ct0P1uAMbJxUB
         8DKj2Wz8zbqKKjMI1TWcHTXKXUj4QCjouIqsK8UI7VLGVjHxcCMSr7heFfIicfk0eh1j
         oiyUctDu97Ik890xb8hifG4+Vt2iK9EYAtIVKR9HfuO9nRLC+5gvQEuEMhuFBnKOGl1f
         rV6+/Ia4jTQ3+qDbktlA93YEElGbxGkQGkHNRykgzkQo5f9aximy7NMnFP9kCFV73mA3
         vjXg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783444143; x=1784048943; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O9lfVufk5V6ONvrwxd5qwRqQ5dHF658hNKhamzFjYII=;
        b=aGzMQDkByp6AGcYmPfwGIPSj56lrp9J6vOeIUsu6cfUtROe33ht1N95Y1I4hJYwOps
         TXC7YVDGBH8cgYpWublgRXQvKJxv7y1Om+RLa01fyVLJ/Hm6cG7WWZkHhASXPV5qj8jo
         BKu8QE3Ht++yvzZjd7qbSsPelI0/0Rk2bFhpwYEGmXqx3X7IpFsi9qVXah1xI1lkaCll
         fZ24G/+dufR8Q1C/LU5bWalstCuy3HIW1OXh8JBumOmxL71NVLGLDZk+3GnZX+fTsY7r
         OX+o6Mq6d/RJjMsgjnbmHS50oyalIFjzECC6C6GjfVaAIvucw8ugQD1x334FCzvcO9N5
         mb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783444143; x=1784048943;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O9lfVufk5V6ONvrwxd5qwRqQ5dHF658hNKhamzFjYII=;
        b=Ztd/jcY/rL5SIciICDSdh/tS57nDbIlXBe7i5eEmT2xQ7SVMVaBlpRL91X2Ifrdvk8
         k1Yr2DeCqbtTHk5CAsnlvAdc+1b/w97TuOYL+OC7tFQwC35R2cXkS5z4fTl0FNfPG1yk
         +D3lpG0y1GWUVgUZK1BMGU9PtkkcxyI1c7vkq9sgy7mpE+JOYgnZQFiihe+6mzEE87MP
         pVYq+2KrRHiPs/nXzxkxcftqRrMmgmpghByzSW3UaPk8ixHYSLB9SmpjVKU/s/pEmZRz
         KoQyXMfn9tFyToy/q2KgSSwg/I5EHQLgYVrvio0GnzFUWPHaJhdb4Whcu6HpPhWzMAfr
         ylFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/V9lqoOWEPhgCHJ2yEC6NeeuTyYQ0S0JSlvdDFa7b8bWwLPU3wmA8/WEqduCNoqHUTsZLec2lRWQ==@kvack.org
X-Gm-Message-State: AOJu0Yx5lQKTLplmL3cUfI6MTblKKX8Z3f8t1qom9uKvoJm/vFwjm51g
	cDMoIMIkIebrZ93NDzXWhFJM9y3yeDoCmsjU/aNmswUBxPCK2Rgi4eC1My/miafbfKgt4iPg8zP
	YdLbGicH+CEOk2YTyaqVry3DUaRgkC7U=
X-Gm-Gg: AfdE7clVmzkl3bp0O50syBM6oIIUuimoM9RF0JOkTNng+rVaRMCmiels05cXSI6R8+5
	9zLSQXgAU0z/lrSyTozuTgQjQBHA2gxRo7bq7IQZOyX41wCi3Kqt8ZEiMWLXYKdfdKtQPBN4HdP
	h0xJAZOgt8KIo8zr8WpChzXXqTtd83S9gXJWjNMny7QF55OFRmOwKIqyz1zUizxYEsUCB6la/zC
	s8iJ+yGq6tfTreaovdDS5t3ydKcKiOBipI8fetXIq2tcjlC+ACO70wzYvyso1e2DDLeJ1U4Gwbx
	GL1PYgv5bYp/pD6cDVHVbLr30B4=
X-Received: by 2002:a05:687c:1d0:10b0:451:25f2:da63 with SMTP id
 586e51a60fabf-45125f37d48mr1081836fac.6.1783444142894; Tue, 07 Jul 2026
 10:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260706203128.162335-1-devnexen@gmail.com> <ak0YI9KjSstnj9rJ@lucifer>
In-Reply-To: <ak0YI9KjSstnj9rJ@lucifer>
From: David CARLIER <devnexen@gmail.com>
Date: Tue, 7 Jul 2026 18:08:49 +0100
X-Gm-Features: AVVi8CeAguKb-2D6-6uZGOkqLgTNCfKzyhQ0b9NrJMamMVdmP0NqOcPU8DLT3gM
Message-ID: <CA+XhMqzvFtLq1OT-qh207aJhSf+okdE8o8Joe8e_KBvdCjcQfQ@mail.gmail.com>
Subject: Re: [PATCH v8] mm: pgtable: free kernel page tables via RCU to fix
 ptdump UAF
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dev Jain <dev.jain@arm.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani <ritesh.list@gmail.com>, 
	syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1B90B20004
X-Stat-Signature: f65t6mbcqeyomfb17u1686u3acrkqghp
X-HE-Tag: 1783444143-196568
X-HE-Meta: U2FsdGVkX19n6J4k2Q04GfON1GeZq/vs2YME6ojs4McmOwR09b0L9OSPSal3Eq0KdjMKjUEQ/G9vkW3myQHtxP6MHqQiVDwMlgcMs6cnHntYAq6K/i+cY3qKIvORGA20rXCl/XZjnlDqZoV+pPRcO/h3W8Ipn+Fasvzfq/8ObkZ2hs1Q97mDS0yj3EGyW0hc98SXzsKB0pSOaF9TLfC6nIhV6cNTZtubdAZLAgxTsvqjf1UjNt23N6zJV1wc0rMPQaMTe+ltqqYUIq9Om61k+kK59HxwBvWZroUP6tCnYlMkdoUwTSB1nb1pecy1UlDuk55W1B/f66biHl1+395LGog099ZjMpCibj5GPfKauqallp/nFW9pkOuOkILXFwfkLgvCBXAwnenitE6GoY2oUQSB2N69ltJ0KH5dIQIIqDEKlpwgzkdpOfFsJIpiifaVfvw16X10BHRnqft3/eHHiJ3voEynMV3U32G+tEPg6zYgFW39eOT45N0M6+4/Bz0dJp8KEf+wKGAbM6NotfFTdEYGcI0vT3S0R7+uFQHXKV9HbcEuKfZciWRP25X4hIHGl1sRaDJx42eSIgX1uOjfmGLOG67YwOTqqC2G/As1gG3RA6LJMvgMB69lQ9WRLflu7NFnarLOFCM5PMGwZ3eV3wKgi1GlBMUmvlwKXboCFUMCjLLNwrMnJOIVeo4lg7fZD/VFunfZyLloIo9f2dTGHYqLxRMFQEPRNp8YX9mE8dwqjdaCqrylbaO6fk7VmkUQWqjVWHy+Wk3YjAQgCI9QEFWSb/C8ql8Jjy2rBoF79uDNF9R6FVmR507nm7O4/RVdcLiv7BKvoDzVWKTOKpEKLOx96VvSvCwuz4JN4bKWIZWxG16xqf2kGddOhAjN/73DODhjE1o3wgR4B98AfabYAEIZikJTJEAneGLG5L23xK/+Dm/Q4RE/Wzpcdf3jJ+Fg9A4XpAlH1bYOAUQyDRh
 AxVCOwXw
 EbI4C31NN2wWdexgAajoDk0TtCsWo/Cl4JGvd3RUv1P6X55r4D6B5uoY0rlZT+M8T1HlAeSxTX4I0RhrG5+ts5wGDlGA/SZVAUksQiEWA5xomTVm6584cM/eih2DmwoUuz9e4WUdAT/jpym7HC/f6weR80ql2onXNKf483uZX8n8sse1Jx5QMiXpkZUlmL9OfI1xu9UozUIxGawpCfCarur0RfsclTmT3wIU0FsbSCpKyJ6hMIlu8zUeHlJ2sOH3yCEVf8IRz6BV9d0S5AbE+QUu9pwimKifopcSz9qgJO5REtrjbrYSrUvV0PwnQ7iTFfR+UmwUEC3AXDFQW13HvlxhIMX4EkJldNjfPXLhHgv9zzYb6u1/vUZvUHRvn0CePfTHdVEljtZnea5karrF9rEpM1L3ZV6gnZnRTmjwz9tETKHkXC1/US8pqpcEa1gbe4v76p0GWs2j1Pz04K/tOXvoFNKx2n8PDVeMgyNpkpFF7hvcNiGaI7EpqVbaRep/NouUaA32Rk8+sxIptYBC7VVgKaTVkPHzb0Xa/iLaCQqEt1mtKzwXxiFILPOMMqx9Ty+3lSjkHjOJSaiFBMTafvpTQ4AEDWkzCLSNcu0X4+XuLUl9/nnEkiZ0kRXHirpJ7yvXZYACGhljtWyo5kJ/HWP32oueaQqWJC5lh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sure thing :)

On Tue, 7 Jul 2026 at 16:19, Lorenzo Stoakes <ljs@kernel.org> wrote:
>
> Hi David C,
>
> This has been through a lot of revisions so I think for the sake of expediency
> the best solution here is for me to grab this and fiddle with it a bit then post
> it out myself.
>
> TO BE VERY CLEAR - I will keep your authorship and attribution :), and simply
> stick my name on a Co-developed-by tag.
>
> So this will remain your patch.
>
> Cheers, Lorenzo
>
> On Mon, Jul 06, 2026 at 09:31:27PM +0100, David Carlier wrote:
> > ptdump_walk_pgd() walks the kernel page tables under get_online_mems().
> > That does not stop vmalloc from freeing a kernel PTE page underneath the
> > walk.
> >
> > When vmap_try_huge_pmd() promotes a range to a huge PMD it collapses the
> > existing PTE table and frees it via pmd_free_pte_page(). On x86, riscv and
> > powerpc this runs without the init_mm mmap lock; only arm64 takes it, and
> > not on the block-split path. So ptdump can dereference a just-freed PTE
> > page, which is the use after free syzbot hit in ptdump_pte_entry().
> >
> > The race is not new. ptdump walks the whole kernel address space, including
> > ranges other code is actively mapping, so it reads page tables it does not
> > own. Commit 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page
> > tables") only widened the window; the Fixes tag points there for that
> > reason.
> >
> > Every other walker works on a range it owns and is the only one mutating
> > it: set_memory() on arm64/riscv/loongarch, the arm64 block-split path, the
> > openrisc DMA path and the hugetlb_vmemmap remap. Nothing frees those ranges
> > concurrently, so they cannot race and do not need RCU. ptdump is the only
> > walker that traverses ranges it does not own.
> >
> > Defer the free by an RCU grace period. pagetable_free_kernel() now frees
> > via call_rcu() in both the async and non-async configs. The async path
> > still flushes the TLB first, then queues the per-page RCU free. The page
> > stays valid until any walk that may have observed it drops its RCU read
> > lock.
> >
> > x86, arm64 and riscv reach pagetable_free_kernel() for the collapsed PTE
> > page (the ptdesc carries PT_kernel), so the deferral covers them. powerpc
> > uses its own fragment allocator: pte_free_kernel() there frees the page
> > synchronously via pte_fragment_free() and the ptdesc is not flagged kernel,
> > so defer the kernel case in pte_fragment_free() as well. arm64 also takes
> > init_mm.mmap_lock around the free under a static key; that is now redundant
> > with the RCU deferral but left in place.
> >
> > On the read side walk_page_range_debug() walks the init_mm range in bounded
> > chunks, taking rcu_read_lock() around each chunk and calling cond_resched()
> > between them. It uses the lockless walker as the mmap lock is no longer
> > held, and pgd_addr_end() to bound each chunk without overflowing at the top
> > of the address space. A walker either sees the cleared PMD and skips, or
> > keeps the page alive until it drops the lock. The owned-range walkers are
> > unchanged.
> >
> > Stop taking mmap_write_lock() in ptdump_walk_pgd() for init_mm. It never
> > guarded against this free -- most architectures free the collapsed PTE
> > table without it -- and RCU now provides the synchronisation. efi_mm and
> > current->mm page tables are not RCU-freed, so they keep the mmap write
> > lock.
> >
> > ptdump callbacks run under RCU within a chunk, so they must not sleep. The
> > arch note_page() and effective_prot() callbacks only format into the
> > preallocated seq_file buffer; the only GFP_KERNEL marker setup runs before
> > the walk, and cond_resched() happens between chunks, outside the read lock.
> >
> > Fixes: 5ba2f0a15564 ("mm: introduce deferred freeing for kernel page tables")
> > Reported-by: syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
> > Closes: https://lore.kernel.org/all/6a287988.39669fcc.33b062.00a0.GAE@google.com/T/
> > Assisted-by: Claude:claude-opus-4-8
> > Signed-off-by: David Carlier <devnexen@gmail.com>
> > ---
> > v8: fix four issues raised by the Gemini review of v7 (relayed by Andrew).
> >     - the init_mm walk called walk_kernel_page_table_range(), which
> >       asserts init_mm.mmap_lock -- but that lock is now dropped; use the
> >       lockless walker instead.
> >     - only stop taking mmap_write_lock() for init_mm; efi_mm and
> >       current->mm are not RCU-freed and keep it.
> >     - bound each chunk with pgd_addr_end() so the last chunk does not
> >       overflow at the top of the address space.
> >     - powerpc frees kernel PTE pages synchronously via pte_fragment_free()
> >       and never sets PT_kernel, so it bypassed the RCU deferral; defer the
> >       kernel case there too.
> > v7: no code change; add version tag and per-revision changelog (Dev).
> > v6: chunk the init_mm walk in walk_page_range_debug() and take
> >     rcu_read_lock() per chunk (reverting v5's caller-side lock + assert)
> >     so the read section stays bounded on large kernel address spaces and
> >     can cond_resched() between chunks; drop the now-redundant
> >     mmap_write_lock() in ptdump_walk_pgd().
> > v5: reframe changelog around the pre-existing race and range ownership;
> >     correct the mmap-lock description (arm64 is the exception, not x86);
> >     move rcu_read_lock() into ptdump_walk_pgd() and assert it in
> >     walk_page_range_debug(); drop walk_kernel_page_table_range_rcu(); fix
> >     the pgtable-generic.c comment; document the no-sleep audit of the
> >     callbacks.
> > v4: defer the free in both the async and non-async configs, not just the
> >     async one; add a walk_kernel_page_table_range_rcu() helper.
> > v3: take rcu_read_lock() in the init_mm branch of walk_page_range_debug().
> > v2: use call_rcu() instead of synchronize_rcu().
> >  arch/powerpc/mm/pgtable-frag.c |  7 ++++++-
> >  include/linux/mm.h             |  7 -------
> >  mm/pagewalk.c                  | 36 +++++++++++++++++++++++++++++-----
> >  mm/pgtable-generic.c           | 22 ++++++++++++++++++++-
> >  mm/ptdump.c                    | 11 +++++++++--
> >  5 files changed, 67 insertions(+), 16 deletions(-)
> >
> > diff --git a/arch/powerpc/mm/pgtable-frag.c b/arch/powerpc/mm/pgtable-frag.c
> > index ae742564a3d5..1e1e88f831f7 100644
> > --- a/arch/powerpc/mm/pgtable-frag.c
> > +++ b/arch/powerpc/mm/pgtable-frag.c
> > @@ -123,7 +123,12 @@ void pte_fragment_free(unsigned long *table, int kernel)
> >
> >       BUG_ON(atomic_read(&ptdesc->pt_frag_refcount) <= 0);
> >       if (atomic_dec_and_test(&ptdesc->pt_frag_refcount)) {
> > -             if (kernel || !folio_test_clear_active(ptdesc_folio(ptdesc)))
> > +             /*
> > +              * Kernel page tables may be walked locklessly under RCU by
> > +              * ptdump, so defer their free by a grace period too, like the
> > +              * lockless-GUP case below for user tables.
> > +              */
> > +             if (!kernel && !folio_test_clear_active(ptdesc_folio(ptdesc)))
> >                       pte_free_now(&ptdesc->pt_rcu_head);
> >               else
> >                       call_rcu(&ptdesc->pt_rcu_head, pte_free_now);
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 485df9c2dbdd..79408a17a1b0 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -3695,14 +3695,7 @@ static inline void __pagetable_free(struct ptdesc *pt)
> >       __free_pages(page, compound_order(page));
> >  }
> >
> > -#ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> >  void pagetable_free_kernel(struct ptdesc *pt);
> > -#else
> > -static inline void pagetable_free_kernel(struct ptdesc *pt)
> > -{
> > -     __pagetable_free(pt);
> > -}
> > -#endif
> >  /**
> >   * pagetable_free - Free pagetables
> >   * @pt:      The page table descriptor
> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
> > index 3ae2586ff45b..fc2fe014ac8c 100644
> > --- a/mm/pagewalk.c
> > +++ b/mm/pagewalk.c
> > @@ -620,7 +620,7 @@ int walk_page_range(struct mm_struct *mm, unsigned long start,
> >   * Note: Be careful to walk the kernel pages tables, the caller may be need to
> >   * take other effective approaches (mmap lock may be insufficient) to prevent
> >   * the intermediate kernel page tables belonging to the specified address range
> > - * from being freed (e.g. memory hot-remove).
> > + * from being freed (e.g. memory hot-remove, vmap huge page promotion).
> >   */
> >  int walk_kernel_page_table_range(unsigned long start, unsigned long end,
> >               const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
> > @@ -643,7 +643,7 @@ int walk_kernel_page_table_range(unsigned long start, unsigned long end,
> >   * Use this function to walk the kernel page tables locklessly. It should be
> >   * guaranteed that the caller has exclusive access over the range they are
> >   * operating on - that there should be no concurrent access, for example,
> > - * changing permissions for vmalloc objects.
> > + * changing permissions for vmalloc objects, or vmap huge page promotion.
> >   */
> >  int walk_kernel_page_table_range_lockless(unsigned long start, unsigned long end,
> >               const struct mm_walk_ops *ops, pgd_t *pgd, void *private)
> > @@ -692,9 +692,35 @@ int walk_page_range_debug(struct mm_struct *mm, unsigned long start,
> >       };
> >
> >       /* For convenience, we allow traversal of kernel mappings. */
> > -     if (mm == &init_mm)
> > -             return walk_kernel_page_table_range(start, end, ops,
> > -                                                 pgd, private);
> > +     if (mm == &init_mm) {
> > +             unsigned long addr = start;
> > +
> > +             /*
> > +              * Walk in bounded chunks so the RCU read lock is never held
> > +              * across the whole kernel address space.  A kernel page table
> > +              * freed via pagetable_free_kernel() stays valid until the walk
> > +              * that may have observed it drops the lock; releasing the lock
> > +              * between chunks is safe as no page table pointer is held
> > +              * across the gap. The mmap lock is not held, so use the
> > +              * lockless walker; RCU, not the lock, keeps the table alive.
> > +              */
> > +             while (addr < end) {
> > +                     unsigned long next = pgd_addr_end(addr, end);
> > +                     int err;
> > +
> > +                     rcu_read_lock();
> > +                     err = walk_kernel_page_table_range_lockless(addr, next, ops,
> > +                                                                 pgd, private);
> > +                     rcu_read_unlock();
> > +                     if (err)
> > +                             return err;
> > +
> > +                     addr = next;
> > +                     cond_resched();
> > +             }
> > +             return 0;
> > +     }
> > +
> >       if (start >= end || !walk.mm)
> >               return -EINVAL;
> >       if (!check_ops_safe(ops))
> > diff --git a/mm/pgtable-generic.c b/mm/pgtable-generic.c
> > index b91b1a98029c..7a32e4821957 100644
> > --- a/mm/pgtable-generic.c
> > +++ b/mm/pgtable-generic.c
> > @@ -410,6 +410,13 @@ pte_t *pte_offset_map_lock(struct mm_struct *mm, pmd_t *pmd,
> >       goto again;
> >  }
> >
> > +static void kernel_pgtable_free_rcu(struct rcu_head *head)
> > +{
> > +     struct ptdesc *pt = container_of(head, struct ptdesc, pt_rcu_head);
> > +
> > +     __pagetable_free(pt);
> > +}
> > +
> >  #ifdef CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> >  static void kernel_pgtable_work_func(struct work_struct *work);
> >
> > @@ -434,8 +441,15 @@ static void kernel_pgtable_work_func(struct work_struct *work)
> >       spin_unlock(&kernel_pgtable_work.lock);
> >
> >       iommu_sva_invalidate_kva_range(PAGE_OFFSET, TLB_FLUSH_ALL);
> > +
> > +     /*
> > +      * Debug walkers (ptdump) may walk ranges they do not own and race this
> > +      * free, so they walk under rcu_read_lock(). Free after a grace period:
> > +      * a walker either already saw the cleared PMD, or keeps the page alive
> > +      * until it drops the RCU lock.
> > +      */
> >       list_for_each_entry_safe(pt, next, &page_list, pt_list)
> > -             __pagetable_free(pt);
> > +             call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
> >  }
> >
> >  void pagetable_free_kernel(struct ptdesc *pt)
> > @@ -446,4 +460,10 @@ void pagetable_free_kernel(struct ptdesc *pt)
> >
> >       schedule_work(&kernel_pgtable_work.work);
> >  }
> > +#else
> > +void pagetable_free_kernel(struct ptdesc *pt)
> > +{
> > +     /* Defer the free by a grace period; see kernel_pgtable_work_func(). */
> > +     call_rcu(&pt->pt_rcu_head, kernel_pgtable_free_rcu);
> > +}
> >  #endif
> > diff --git a/mm/ptdump.c b/mm/ptdump.c
> > index 973020000096..537be9995e1a 100644
> > --- a/mm/ptdump.c
> > +++ b/mm/ptdump.c
> > @@ -177,13 +177,20 @@ void ptdump_walk_pgd(struct ptdump_state *st, struct mm_struct *mm, pgd_t *pgd)
> >       const struct ptdump_range *range = st->range;
> >
> >       get_online_mems();
> > -     mmap_write_lock(mm);
> > +     /*
> > +      * init_mm is walked locklessly under RCU by walk_page_range_debug().
> > +      * efi_mm / current->mm page tables are not RCU-freed, so hold the
> > +      * mmap write lock to keep them stable against concurrent teardown.
> > +      */
> > +     if (mm != &init_mm)
> > +             mmap_write_lock(mm);
> >       while (range->start != range->end) {
> >               walk_page_range_debug(mm, range->start, range->end,
> >                                     &ptdump_ops, pgd, st);
> >               range++;
> >       }
> > -     mmap_write_unlock(mm);
> > +     if (mm != &init_mm)
> > +             mmap_write_unlock(mm);
> >       put_online_mems();
> >
> >       /* Flush out the last page */
> > --
> > 2.53.0
> >

