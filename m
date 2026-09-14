Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0490BC88E77
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 15:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13B036B00C9; Mon, 14 Sep 2026 11:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112B76B00CA; Mon, 14 Sep 2026 11:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0035B6B00CB; Mon, 14 Sep 2026 11:09:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD7786B00C9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:09:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 52F55160173
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:09:40 +0000 (UTC)
X-FDA: 85212702120.22.64CD0CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id BEB64180012
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:09:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcXlyuz1;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789398578;
	b=c5GQEMr0tyotkjPNFNL5OdkFouUlPNx2rJWZonXFF6mm3TqTXlKMb4mE/bXyJQynOVbe4G
	rCRleLhZRIBG2UFz4w4EpCffW88uDPtcjHgaBLQhdnLEXMe86PxhyPcXsnVa1eJONIsEPZ
	6ulLRum1hcPvDCxCmazKUD0pwoAGlVc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WcXlyuz1;
	spf=pass (imf06.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789398578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqGx/g9iA8NHnrHaYC5eHMoZQvuNCtTEzYjoeYtI/wc=;
	b=gBxreFovNnD/Se5kccIrw5rnO9egHAnjg2xBz3S8qF480he6qKT6FQg3HLGlfwmyLAfb5Z
	rQKBn6zfrGVUtTP++DwY4io4aqEHHDA5NSkyMxUmaocputzVvdU4Ac7V7fHyWJsc7ULGWH
	Ady3Ifb/NjLxD1OaFw2Zilc578emYdg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A71B60142;
	Mon, 14 Sep 2026 15:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977821F00893;
	Mon, 14 Sep 2026 15:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789398578;
	bh=lqGx/g9iA8NHnrHaYC5eHMoZQvuNCtTEzYjoeYtI/wc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WcXlyuz11wuqXhEOE712pccfVCodWo1JsYcoBXEU8WVlNcItPfa55fFiROejw8tRc
	 lnRyISQ+aGw/9Eu1iMx9m5Sz0OBNXExpG1C5jO4S7y9zwOZdc7/HTjiUQFuzxlCaOi
	 TjrBvGod2FRnfM5IPUQnh7vGEVUM0PZz9IfEAst+SEn3L+E3E+OseVETV7mzFUEz0s
	 PK0MKuMS7TkGj69J3pvFrRn044ZLSeww4P3RP2RtP7+iTHFGyKTkyb9OzU4Vsj4kDu
	 fUKabYFlTOaXP3yQ6jW7qe20XnUpy8gLuWo6PiffhTiPTbtvvQaW7wVUKEHL/PY5Bo
	 I5rCdMRmTRguQ==
Date: Mon, 14 Sep 2026 16:09:27 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jann Horn <jannh@google.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
Subject: Re: [PATCH v2] mm: implement and use vma_anon_tracked(), silence
 KCSAN
Message-ID: <aqgMFnz6Y5rs_jig@gremlin>
References: <20260910-vma-is-faulted-v2-1-e81ebc7d146b@kernel.org>
 <aqgC9iVHtB1fMWS2@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqgC9iVHtB1fMWS2@pedro-suse.tail5790ac.ts.net>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BEB64180012
X-Stat-Signature: 9oruizp3p4uyirxgbg6k8cqc3chapkr4
X-Rspam-User: 
X-HE-Tag: 1789398578-621956
X-HE-Meta: U2FsdGVkX1/ygxCz2yxn06KIGjwgZ9tzi9G66L3UQlDqHyqKSdhA7sDjSRFZl/jJr73STIjpdesV3K7JfiMQbHp/YEs9wqhR5zxqj/hEHJ2Ua1y2KOMrELllEtg9YzdEqYKLNvhizVzt1tHJKPfI5baL35q4CqBYOEkhyOFpZoepbdo4tzGVFq1KFd99vKYM3UAUzW8OC9vuUmSRJucVGdtnkAJEHOsdFJqXiHH0bP+1rDVUG2YItwMA70dZPqX//FnzoE/o55DVS2vCBenH7TZn/Ww5C8GScLVZRYmeoH0kef061fQqSYqw2jfZqhJQI6QzuJUNdn9Cm97Jzz6KZcGLjxN7Y5cq9zzVpW+rcx0GEb/phlD0QKm/EkqkRBmco2eYSpzTcXhfeDplAj97GCgkiwLjTm7GG5HAlnILHkedxlOOSJyGdcZC5RG7ZNwdEJN0XUrH/rVYKeoWMuuYkuhC4oMNRg0++i1kZOEJQckaHXy6p/p1z1FTJFuCE5FTJRRl5391trKx4P2QYkdc+CDAfYcWeC56XxNqXKVmZ9WEHmz580+XtBa50KrVCKjeM2Uvio4VAf+BKRDA+zcHLz/FC45BN8PFRJ9UJ8qDj31fnYNaOjHw1B0Af1hgDTdgXrmbIGbFSbGAozvkFaZGgSonhsf4qXdLnbumzfFeYLB2N/ZNsdr/fY7Unp2VHHQXafWjeu4D4+namtsjhYLxEsw8APfj7TaKl6tju98DKSX1c7lOJL81vjSkiqf3bdvvjFAKeRHtkEzNYIWX/IepidtZ8A1EfMFPFCo7qf+nCzsXQ+BxOuE5nRjug361DjG3nIMoOXfitu8fcEqihuv0NXmQ50xzF24qTCju5rZ7sZMU/0fjvIHDkptsVbTED+24vlJPhzwn6DhsAkIXnkrgOMuqtwcdUSBkLzk4vdOAN1lsjwPq2LdBU90NzLXzbIRdJBB7DbO2swrryW/Zefz
 +HhRI0RJ
 hTtAdjZElOizpz2IzzQbx5So30We/BG2T6xD4NygVZlnrxT+Ajg9JI8jj5Ua+aej+j3x53O7WM9Dc2ZQyx6VDcJ7APwwYoEpuewSxylQ+O5owJrqBEDoFp6bc/A/ddR72KRiIJ1bw/RgH4fdy+2aVdBftG+OUXvVLyZE9EQNaPAQqJM2ONM8mOj+jBjSYgY+LUhCs/9vhIZZkWRAHE2dlnTyeZyysJxWon3jZPNk7DyVAWC8lWk+7bLyPoP8dQpKDwzXs/mxKNdFllFupR1vvucT0xDJD8DgC91Z8sfLmrGmNlYDVYxZNKGgimUEulvuOqrKAXLfml3Y/FSNMui92cyhpdfaPWf5Ljy0a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 03:24:47PM +0100, Pedro Falcato wrote:
> On Thu, Sep 10, 2026 at 02:18:35PM +0100, Lorenzo Stoakes (ARM) wrote:
> > Provide a function to abstract the common task of checking whether
> > a VMA is faulted in or not.
> >
> > A VMA or mmap lock must be held when calling this function. For an attached
> > VMA the transitions between unfaulted/faulted state are:
> >
> >        Transition        |              VMA/mmap Lock state
> >  ------------------------|-----------------------------------------------
> >    unfaulted to faulted  | write lock OR read lock + mm->page_table_lock
> >    faulted to unfaulted  | write lock
> >
> > So vma_anon_tracked() never provides a false positive (the lock precludes
> > it), but if only a read lock is held, a negative result must be re-checked
> > with mm->page_table_lock held.
> >
> > Detached VMAs cannot be concurrently manipulated as they are removed from
> > the maple tree so require no guarantees.
> >
> > Use data_race() to silence KCSAN about non-existent data races between
> > concurrent vma->anon_vma read/write on optimistic fault tests.
> >
> > Also while here, const-ify vma_is_attached(), vma_assert_stabilised() and
> > dependants.
> >
> > Finally, update the core VMA merge/split, rmap, mremap, KSM and fault
> > preparation callers which test vma->anon_vma directly to use
> > vma_anon_tracked() instead.
> >
> > Note that the lockless read in reusable_anon_vma() is doing more than
> > checking whether the VMA is faulted - it is returning the anon_vma to be
> > used on fault, so this check is not altered.
> >
> > There is one odd one out - file_backed_vma_is_retractable() - which holds
> > neither a VMA nor mmap lock and is stabilised by the file rmap lock only.
> >
> > Therefore just add a comment to explain why the direct vma->anon_vma check
> > is required.
> >
> > Reported-by: Guilherme Giacomo Simoes <trintaeoitogc@gmail.com>
> > Closes: https://lore.kernel.org/all/20260829100034.423064-1-trintaeoitogc@gmail.com/
> > Closes: https://lore.kernel.org/all/20260909115723.528501-1-trintaeoitogc@gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> > v2:
> > - Renamed vma_is_faulted() to vma_anon_tracked() as per David.
> >
> > v1:
> > https://lore.kernel.org/r/20260909-vma-is-faulted-v1-1-3a701f48984a@kernel.org
> > ---
> >  include/linux/mmap_lock.h         | 12 ++++++------
> >  mm/huge_memory.c                  |  4 ++--
> >  mm/internal.h                     |  2 +-
> >  mm/khugepaged.c                   |  3 +++
> >  mm/ksm.c                          | 10 +++++-----
> >  mm/madvise.c                      |  4 ++--
> >  mm/memory.c                       |  2 +-
> >  mm/mprotect.c                     |  2 +-
> >  mm/mremap.c                       |  4 ++--
> >  mm/rmap.c                         | 22 +++++++++++-----------
> >  mm/swapfile.c                     |  2 +-
> >  mm/userfaultfd.c                  |  2 +-
> >  mm/vma.c                          | 29 +++++++++++++++--------------
> >  mm/vma.h                          | 22 +++++++++++++++++++++-
> >  tools/testing/vma/include/dup.h   |  2 +-
> >  tools/testing/vma/include/stubs.h |  4 ++++
> >  16 files changed, 77 insertions(+), 49 deletions(-)
> >
> > diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
> > index 00eae65b74bd..03e1eb136111 100644
> > --- a/include/linux/mmap_lock.h
> > +++ b/include/linux/mmap_lock.h
> > @@ -273,7 +273,7 @@ static inline void vma_end_read(struct vm_area_struct *vma)
> >  	vma_refcount_put(vma);
> >  }
> >
> > -static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
> > +static inline unsigned int __vma_raw_mm_seqnum(const struct vm_area_struct *vma)
> >  {
> >  	const struct mm_struct *mm = vma->vm_mm;
> >
> > @@ -288,7 +288,7 @@ static inline unsigned int __vma_raw_mm_seqnum(struct vm_area_struct *vma)
> >   *
> >   * Returns true if write-locked, otherwise false.
> >   */
> > -static inline bool __is_vma_write_locked(struct vm_area_struct *vma)
> > +static inline bool __is_vma_write_locked(const struct vm_area_struct *vma)
> >  {
> >  	/*
> >  	 * current task is holding mmap_write_lock, both vma->vm_lock_seq and
> > @@ -344,7 +344,7 @@ int vma_start_write_killable(struct vm_area_struct *vma)
> >   * vma_assert_write_locked() - assert that @vma holds a VMA write lock.
> >   * @vma: The VMA to assert.
> >   */
> > -static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> > +static inline void vma_assert_write_locked(const struct vm_area_struct *vma)
> >  {
> >  	if (!IS_ENABLED(CONFIG_MMU)) {
> >  		mmap_assert_write_locked(vma->vm_mm);
> > @@ -359,7 +359,7 @@ static inline void vma_assert_write_locked(struct vm_area_struct *vma)
> >   * lock and is not detached.
> >   * @vma: The VMA to assert.
> >   */
> > -static inline void vma_assert_locked(struct vm_area_struct *vma)
> > +static inline void vma_assert_locked(const struct vm_area_struct *vma)
> >  {
> >  	unsigned int refcnt;
> >
> > @@ -410,7 +410,7 @@ static inline void vma_assert_locked(struct vm_area_struct *vma)
> >   * With lockdep disabled we may sometimes race with other threads acquiring the
> >   * mmap read lock simultaneous with our VMA read lock.
> >   */
> > -static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> > +static inline void vma_assert_stabilised(const struct vm_area_struct *vma)
> >  {
> >  	/*
> >  	 * If another thread owns an mmap lock, it may go away at any time, and
> > @@ -445,7 +445,7 @@ static inline void vma_assert_stabilised(struct vm_area_struct *vma)
> >  	vma_assert_locked(vma);
> >  }
> >
> > -static inline bool vma_is_attached(struct vm_area_struct *vma)
> > +static inline bool vma_is_attached(const struct vm_area_struct *vma)
> >  {
> >  	return refcount_read(&vma->vm_refcnt);
> >  }
>
> nit: I would suggest you do all of this constification in a separate patch,
> otherwise it can become tricky for backports. Things can naturally start depending
> on const correctness, and you either need to manually adjust those future patches,
> or try to backport this one.

Ok will break out.

>
> The rest looks vaguely good to me. I admit I'm not a gigantic fan of the name,
> but I suspect it fits better with your future anon rmap ideas :)

Naming's hard and it's hard to make everybody happy, unfortunately :(

vma_has_anon_rmap() better?

>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

>
>
> --
> Pedro

--
Cheers, Lorenzo

