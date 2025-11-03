Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97260CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:11:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 020A58E00A0; Mon,  3 Nov 2025 11:11:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A7B8E0057; Mon,  3 Nov 2025 11:11:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77E08E00A0; Mon,  3 Nov 2025 11:11:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D6CA68E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:11:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BC62B62BE
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:11:38 +0000 (UTC)
X-FDA: 84069786276.20.2427DEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 15A71180003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:11:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8p8WP9r;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762186297;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cx3pPhs9okrD8qu0Xa0ceSBi4k1FcUEdAxhIOGYsE0=;
	b=ZxqHBsHKQpA3MqlLpOyPXiW7CjwdNyYDtGmAg600b/EQ1IKEU5Lyrp9Wz1gP734VEslbZe
	yU5jDz86w403nFqSoq0j8oj/35O/hVCS5eKeghcRYPgY++Bwt3t/ixafVchn2I8AjiYQiv
	QSQdqG61pwLuGM3zO0XYjYH1NBdXj4s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762186297; a=rsa-sha256;
	cv=none;
	b=1R9qM2hdOBC1XKCv9Ka2mQ0zzS9vd3t6YzOiJ8QVf/vxQnfyfyyESzxBBnHVGriP8do7ZW
	edUZG9gwQPgNLu+JnJ+4rTixOMHEWM1h/jyOQHqSY0P+RU0ki8rJZ345HVo5GVZPLTcBA/
	q3xOQoiBFhkQ2RoqLz5u9ZYSB9IhwHw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K8p8WP9r;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3DC266013E;
	Mon,  3 Nov 2025 16:11:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0C59C4CEE7;
	Mon,  3 Nov 2025 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762186295;
	bh=t3uCVlNB2xJvfnPV0X/hGGm+4C1tih7qB1AMxkuOk3s=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=K8p8WP9rT5MxIAnfnxfqwVuhJ0DnYjbNVkEk8Ii1JA8elVgIjBSFsM4Iu+x/ZCI3c
	 dPZE5rbVRMx7VmX4a0AsIYVnsWDfyct4kktvU7CFb427nTX8O0RRyhiRliyEFopkDu
	 YrI7hkvPtsHGccYOL/e767fSIzzbElpa38AnXNjt7zajMnbjoJvpZ9Sba67iFWsvLQ
	 0NPj0z66MzqlMSqDio+rPwd7e1TVY1woUkCQ9UEIG2ptPlZ4Lu1UF6dS9eN5MU030c
	 bxiXfGKcu6Q+D+LR8VUj/RYno21OP8zVX8G4ddiIGaL0tL93VlVmynrHqneNaOvMd0
	 cdkYD63GTiyNw==
Date: Mon, 3 Nov 2025 18:11:26 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v4 0/4] mm/userfaultfd: modulize memory types
Message-ID: <aQjULib7JriWnVTq@kernel.org>
References: <20251014231501.2301398-1-peterx@redhat.com>
 <78424672-065c-47fc-ba76-c5a866dcdc98@redhat.com>
 <aPZDVuscFsYSlQjI@x1.local>
 <dtepn7obw5syd47uhyxavytodp7ws2pzr2yuchda32wcwn4bj4@wazn24gijumu>
 <aPe0oWR9-Oj58Asz@x1.local>
 <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nnxhd7zxjza6m4w4lr5qyev2krbkp4yfcgcwq6nkaqrqt6bzpb@iklep2xxp5gv>
X-Stat-Signature: 1yo7ch76mdh7j9j9rh39w16j6k1dtmfz
X-Rspam-User: 
X-Rspamd-Queue-Id: 15A71180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1762186296-88278
X-HE-Meta: U2FsdGVkX18D8HHhGQOkb8ACgztweGHUw7XwGdfT6Q9tj3BxqKeGNI5c2e2tSIzz3R6tY/oMoV3RLD4pxwsM09oMTz2ZZikK0hRD8ZuHJmxqEixUZ2VIi7YrRbS8mjmxSsPOH2EBykiotnyiBGcRjIvdkAqzm7z3Wj0vEO9bvXjbTiPpUQj7FaS3jNADA6j/puuuYM6kzv3vU2DvND/Kbu2YdfdcieCBd+xCZi1tNgxeVXlzCCRw62vqyJ5z5qRBNhVhloED/ujRu6jjizbMA7UCdQkcrwU/rvnrjwyiv80jpMitYmz+gMNBHf0sZXjgR7z6G6PHesKHJYR9XIgZNkJuHlvBSu2P/dQVtnt+Iknnla1XW1nXu8ZT9k2NQSVQ4pM2BFnMy8SAjEJk5jLLGy2qBWBYcr7kY/tNumYKhPiVfAHEh7f1gzG6XclUbw8FYTYLG3HN8eOvnYzh5WVmThOUwUJzEm1ZH+XcY0Tc4qaipbh2xN5j8MrKqwpB+68a6Fb1VeGbf2col4UUL3FyNBYQCDwVkWr5vh9RqLlImrRAX5kCK7Lrt2fiiTdBjZNeVGly808AXn4z2Y1lHdE1//xN0DKv4o8L+dAlPFbaNqUPyCHRSUBGJDGjKYh3oGESfnep6LVKmUPToCNFkzPX4+CZaw6CzxoHjuN5wwpWh9J8qUzR4ixOnQcaIGdggCimxLjph7mc2WyGTwVgEfeihGShb7U9yccB6we7jh6wdU0Z+r5qS5tKbug/mplxtVrTaTfwrLdJjVdk+aNBUC1ggv7n1TsGaJCSNreePcRYMbLGQcCWM8KYLO0Gm9h/dDWpi/F6FAPJQ3elCalxxdl8QCBI6ZD5XCttp24lFbeJkkywyOkU4daUNQ82EjPyOvZJWTLeqptg7c62/o/X2KCOneonqukDvlmpkGygRhC/BXQwln0rC8b70ARpckctQjx9hurOeMY6ftgazFJX8kE
 9Ayuo6WG
 KMWfm5st++ayf9XBiXJrIb+g4wU9aXQAwL6wgU0gtgafC/RwhpfraVsCD1K+R/3QeWL25moCO4P8g1wpnv+9KONx8Sbs+SLE9ve1LLNdmz/y9LI67L4ILVQjPddbm/EyFpHoQ3WNRIFnP9w4PBwALRvrf0rsYiLMZfx9GJnw3fr01IL49FXYOH0StRgQcejc70ZZpYptUbya9RQ2tS/i46eqx3Qeq3Gqc1zCijgC2zrktRNQm2aOYrfFT8jOZHz9MgLa14PuNNHZ3nzNI2FrNLyXRg6vng5NkUmhqgt4zkHC3vpkDnfHEZLJWdTANgyWleV0VHojf/w9z/Rc9In0cFnJlePIN5XWZ/IZwbqeXTQ/uhLEw3TenkE5HwA7GfTvDneJjX4nn/k1Tp4rzRoKpq0ojkfgRkk20hZLv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Liam,

On Thu, Oct 30, 2025 at 01:13:24PM -0400, Liam R. Howlett wrote:
> * Peter Xu <peterx@redhat.com> [251021 12:28]:
> 
> ...
> 
> > Can you send some patches and show us the code, help everyone to support
> > guest-memfd minor fault, please?
> 
> Patches are here:
> 
> https://git.infradead.org/?p=users/jedix/linux-maple.git;a=shortlog;h=refs/heads/modularized_mem

It's really cool you picked up the gauntlet and invested this effort into
refactoring of uffd!

I agree that userfault code begs for cleanups after the sh^W stuff has been
piling over and over, but ...
 
> This is actually modularized memory types.  That means there is no
> hugetlb.h or shmem.h included in mm/userfaultfd.c code.
> 
> uffd_flag_t has been removed.  This was turning into a middleware and
> it is not necessary.  Neither is supported_ioctls.
> 
> hugetlb now uses the same functions as every other memory type,
> including anon memory.
> 
> Any memory type can change functionality without adding instructions or
> flags or anything to some other code.
> 
> This code passes uffd-unit-test and uffd-wp-mremap (skipped the swap
> tests).
> 
> guest-memfd can implement whatever it needs to (or use others
> implementations), like shmem_uffd_ops here:
> 
> static const struct vm_uffd_ops shmem_uffd_ops = {
>         .copy                   =       shmem_mfill_atomic_pte_copy,
>         .zeropage               =       shmem_mfill_atomic_pte_zeropage,
>         .cont                   =       shmem_mfill_atomic_pte_continue,
>         .poison                 =       mfill_atomic_pte_poison,
>         .writeprotect           =       uffd_writeprotect,
>         .is_dst_valid           =       shmem_is_dst_valid,
>         .increment              =       mfill_size,
>         .failed_do_unlock       =       uffd_failed_do_unlock,
>         .page_shift             =       uffd_page_shift,
>         .complete_register      =       uffd_complete_register,
> };   

... I don't think it's the right level of abstraction to add as uffd_ops to
vmap_ops.
 
As I see it, we have two levels where things are different: hugetlb vs
others at the very core of mfill_atomic() and then how different pte-based
types implement a single page operations, i.e copy/zeropage/continue.

So to separate hugetlb code from userfault we need something like 

	->get_parent_pagetable()
	->pagesize()
	->mfill_atomic_page()

and apparently something like your complete_register() and maybe
is_dst_valid().

But to provide hooks for shmem, anon and potentially guest_memfd() we
should be looking at callbacks to get a folio to populate a PTE, either for
copy or continue, and Peter's ->minor_get_folio() seems to me the right
level of abstraction to expose at vm_uffd_ops.

I believe we can extract ->get_folio() and ->put_folio() from
shmem_mfill_atomic_pte() and call them from mfill_atomic_pte_copy().

> Where guest-memfd needs to write the one function:
> guest_memfd_pte_continue(), from what I understand.
> 
> Obviously some of the shmem_ functions would need to be added to a
> header, or such.
> 
> And most of that can come from shmem_mfill_atomic_pte_continue(), from
> what I understand.  This is about 40 lines of code, but may require
> exposing some shmem functions to keep the code that compact.

This seems to me an overkill to implement MFILL_ATOMIC_CONTINUE for
guest_memfd().
I think it should be able to register a callback to provide a singe folio
at a given file offset if that folio is in the guest_memfd's page cache.
No reason for guest_memfd to start re-implementing locking, acquiring of
PMD and updating the page table, even if it only needs to call functions
from userfaultfd

> So we don't need to expose getting a folio to a module, or decode any
> special flags or whatever.  We just call the function that needs to be
> called on the vma that is found.

Agree about exposing flags to a module and about limiting API to functions
only.
 
> Thanks,
> Liam
> 

-- 
Sincerely yours,
Mike.

