Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68337CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 18:05:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29B68E013E; Thu, 18 Sep 2025 14:05:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01508E00F6; Thu, 18 Sep 2025 14:05:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DD98E013E; Thu, 18 Sep 2025 14:05:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A56358E00F6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4AA3E1DE4E7
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:05:31 +0000 (UTC)
X-FDA: 83903148462.15.75CFAFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 81AA840012
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 18:05:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TMGdhYSa;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758218729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GRnKUqJQaKQ3qeaLKFBKp0hA9uYit6DuHxmpIDU40sA=;
	b=iE0kdWz1wQuGibyLfQgf9jP38gCslZNg6wbs/xb4fZ1C8te1bHjFM1u9yV6Tku2VPuD1AR
	tw+MYcwDwHzOW8z5DkotqDqEUEjNm3gyCR6TS78Yx9AUKTVMP7EKi+cepjBUx2STeQN7yt
	KZaXO3kbJcA+NY5v3ugs1lpHv1HAuOg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TMGdhYSa;
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758218729; a=rsa-sha256;
	cv=none;
	b=ufHMbqgGDfDbEmao6IcyPvjpLF5r5lw02vfBXTJNTwGYxFUWaXq31hLAONlSo9E7PyFwXU
	BHOx+hDmJAq8I6cqHLQaq8rGSFRZT6xVUrF2E3Q2aOyk6CcKXx4Xnc0uOWrWjgHQby5Arl
	KHyOSSouRz9KVKzX4KsFBucizRW3cHE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 30E0844C9F;
	Thu, 18 Sep 2025 18:05:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897DDC4CEF0;
	Thu, 18 Sep 2025 18:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758218728;
	bh=tsq8/KIMhkwr8aDP5CrNQEAVsPpxQpbwsRK0rJgZrGE=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=TMGdhYSat7emupYTEzFzD7zPjV5zTJsTc13UxGPYN858mMyT+wcChY7q+MHe9BnYe
	 159cXvtfGkpYdTvIngkHDfFUAR1+FCkRMHcnJrgc5EpXlTZEXARn7tIzF0IVCUmo9t
	 oE5ZcASeNwoHJTLochmOaynIvZwKYA9AOaodzf/WRmbHsdBOiWIJZ/QkjYo6zQ2Ppl
	 dkZLTb+Oj45+lvq0lx41gWBqcyfUKY/Tq+bXIxW9Lg9EhYZL+XUNoVmbyKRFQiMQS4
	 XaNq1fxOFSk7fn8ogsxXK9euOnaP6s2fz/cWebWuR7D2neYbom+DxLETv7hglTwMHH
	 8kIodG9lN2gRQ==
Date: Thu, 18 Sep 2025 21:05:18 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Peter Xu <peterx@redhat.com>, David Hildenbrand <david@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@suse.cz>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	James Houghton <jthoughton@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Ujwal Kundur <ujwal.kundur@gmail.com>
Subject: Re: [PATCH v2 1/4] mm: Introduce vm_uffd_ops API
Message-ID: <aMxJ3inEs_RRyqen@kernel.org>
References: <aGbCbW7hUf3a2do2@kernel.org>
 <289eede1-d47d-49a2-b9b6-ff8050d84893@redhat.com>
 <aGfsaIIzHWfjcNFd@x1.local>
 <e7vr62s73dftijeveyg6lfgivctijz4qcar3teswjbuv6gog3k@4sbpuj35nbbh>
 <930d8830-3d5d-496d-80d8-b716ea6446bb@amazon.com>
 <jxekhkhbn7uk23oe24svxrs3vfuhseae57sqagndqgh2e7h33o@kfkygmrvjb5n>
 <aMp-kW3OLqtZs8sh@kernel.org>
 <du5pzxmfk6lile3ykpaloylwz4eni6disj2oe25eq6ipzqemiw@ybcouflfnlev>
 <aMvEu9m7fJLnj862@kernel.org>
 <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4czztpp7emy7gnigoa7aap2expmlnrpvhugko7q4ycfj2ikuck@v6aq7tzr6yeq>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81AA840012
X-Stat-Signature: qoy9hwgj3hsdynoj5sqikn8ct6ew4dpf
X-HE-Tag: 1758218729-369494
X-HE-Meta: U2FsdGVkX1+al18KWjP6j7e+5njnaQRa99Ox39V9zTqVqvV2YMuh8Ll/9Lmcg8MWwV1y4DFCQDIDFeoBIcJ0irYvGHV8RdT/mJyQFIp007Y6XhRossDrCIsrKLvlL6TqMYxeaNsgOYxnocbEvVA4GwDb8HQCzoYR97+1kwx+froSld05vrybfKJ218Qm/4QCAUaoMiqsIIEUeXM7KwMuRT++TZ0dlRGyLOHib2N2KL4XbAV88z+TAcKy8wKy+5BPplqgXh28cmG9GzjGzrY0a+fxYeGpsdtAsdeBE5+TpbVlDjzhbE6tsDYTO+uzXZRd3484jhEbX3JXEo/guvAsvoAr060XmwUguVfAvLYodThEwnkcjgu4kgJKuMkeWQc9aD7hTiqQ9EzIurSCSI9phCaadZxYwAnbYKJMzhmlMh1TJWnZ/ZYuNSYGmLOIhRpkSSelNnrAKhdgktrEE+8skaSxWjjiC2ijTgTIGpkuyHcQK6CU8Nl5h+3nXJsHWgOYHjRXdzBwz2PJ0dCoFrWQPInK7Vt2mompQAiHarwQhsBhwRjnqW0AT5ccN9Qd43U6GSg+iGVCdL6Yvw8bcWAVZVgvBqEkV8t1DJ4+L28ttw5y7hf+oMT6wfFQKZVvU+O95Jo6Tmfe7wUGfstWqLBZ+LUr7jNYAegNCP+M0ukda+FpAvMjWseYvk946gZMYZBPwH8qpPEvef8sUqjut1funC5xTyuj8ZwcD0b+ZttUWU7WkU/YamUVdUN/a4TLAGUyHKCoLfonR/tI5ZYypMmYvD5uyA/RiT18Z8UEkaue0Icf01IDwOdEn5jmZXa9wEIIB2Q2RY/NSRKTOWv0D6YPvDndF8xb6Dw8O56N2lIEA6KX4nLs+HsSEJ0ZrxA0tEfgCxG30RlS5OwQyewFCtksQELyLc/sQuPmYcyb9jw3saxjQ0/Ne34csWxKxz54x0LTRYJ6M4kxelCFVzluBpg
 Hvu550oB
 SErKR/8lqbxv6BgbZSNSzdhmaYgrC2raKjqJWm5XhqrKGY1uzfpRNTsGVJm8T76NPJgsaNB4krjc6+NRSM3lHZO4MVW4RpdQGAfTgEugsbMCTtfDrGXoXuP83QZ7Kr3Z8QwDpddZFVgIthzUvKFy/j0vA5HxFB4de8ir5lWT7gfFvBZfWTm3iCyEirUynjLRUgcXpxOQoA3Vi1xmr1DTmGCWV+xcrGUpN5MHlpO7SBL8zsBbokdOVJnQuQ7p2y5fmYlpbHsLO9esnbGJJnSItuc7Mv1jbZTcOwIgkoNfL8QefEPmjBGAp+PsS+KVrbrSiJ1LYsnjepNhzE+dn/dXg1GaErBCK5zZDUMNVEBXLd4CFiicgaIJeMBfSkjBjiQiqd3CUAapy0J1fk425/OXv4x9i5Mc3Io38Jd5orDM5ZMDw+6XAZLk4OOxweg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 18, 2025 at 12:47:41PM -0400, Liam R. Howlett wrote:
> * Mike Rapoport <rppt@kernel.org> [250918 04:37]:
> > On Wed, Sep 17, 2025 at 12:53:05PM -0400, Liam R. Howlett wrote:
> > >
> > > I disagree, the filesystem vma_ops->fault() is not a config option like
> > > this one.  So we are on a path to enable uffd by default, and it really
> > > needs work beyond this series.  Setting up a list head and passing in
> > > through every call stack is far from idea.
> > 
> > I don't follow you here. How addition of uffd callbacks guarded by a config
> > option to vma_ops leads to enabling uffd by by default?
> 
> Any new memory type that uses the above interface now needs uffd
> enabled, anyone planning to use guest_memfd needs it enabled, anyone
> able to get a module using this interface needs it enabled (by whoever
> gives them the kernel they use).  Kernel provides now need to enable
> UFFD - which is different than the example provided.

My understanding of Peter's suggestion is that *if* uffd is enabled memory
type *may* implement the API, whatever API we'll come up with.
  
> > Nevertheless, let's step back for a second and instead focus on the problem
> > these patches are trying to solve, which is to allow guest_memfd implement
> > UFFD_CONTINUE (or minor fault in other terminology). 
> 
> Well, this is about modularizing memory types, but the first user is
> supposed to be the guest-memfd support.
> 
> > 
> > This means uffd should be able to map a folio that's already in
> > guest_memfd page cache to the faulted address. Obviously, the page table
> > update happens in uffd. But it still has to find what to map and we need
> > some way to let guest_memfd tell that to uffd.
> > 
> > So we need a hook somewhere that will return a folio matching pgoff in
> > vma->file->inode.
> > 
> > Do you see a way to implement it otherwise?
> 
> I must be missing something.
> 
> UFFDIO_CONTINUE currently enters through an ioctl that calls
> userfaultfd_continue() -> mfill_atomic_continue()... mfill_atomic() gets
> and uses the folio to actually do the work.  Right now, we don't hand
> out the folio, so what is different here?

The ioctl() is the mean of userspace to resolve a page fault and
mfill_atomic() needs something similar to ->fault() to actually get the
folio. And in case of shmem and guest_memfd the folio lives in the page
cache.
 
> I am under the impression that we don't need to return the folio, but
> may need to do work on it.  That is, we can give the mm side what it
> needs to call the related memory type functions to service the request.
> 
> For example, one could pass in the inode, pgoff, and memory type and the
> mm code could then call the fault handler for that memory type?

How calling the fault handler differs conceptually from calling
uffd_get_folio?
If you take a look at UFFD_CONTINUE for shmem, this is pretty much what's
happening. uffd side finds inode and pgoff and calls to a shmem_get_folio()
that's very much similar to shmem->fault().

-- 
Sincerely yours,
Mike.

