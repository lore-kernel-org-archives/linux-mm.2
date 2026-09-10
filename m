Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1CFCC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 16:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB866B008C; Thu, 10 Sep 2026 12:27:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45A76B0092; Thu, 10 Sep 2026 12:27:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 935446B0093; Thu, 10 Sep 2026 12:27:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6D6556B008C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:27:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 07E1A4051B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:27:21 +0000 (UTC)
X-FDA: 85198382682.18.4C01645
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3AFAC160014
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 16:27:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dv3jVlGC;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789057639;
	b=g/RrQR5seWNV5qZqViVk23q4Puzv+mFDZIiTAq3rgAbNjGNEtEnZdyxRHghcT+UgGX5Q7F
	L9PU5vEueqpjOy7Mkvmpbvyj+8Q0dZawL+YLbdmqtlyOFvbmtQDVMGjLom/noQUxquV+8C
	YrHBC3Y7hRUE8JlfyNhG3SPnjgxPaWs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Dv3jVlGC;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789057639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3aTGXI/vDH2A0yENDYRp5mBzUsR6PSfcXx9+o09dZsM=;
	b=o3+XaksPp0SE4PoFvYF0r/BRLEnUp4sUZaYz09uFjXtXe1KLfQ+Nd6JhFRtC7YsFwerK5B
	NvQgZ87VX4DsHsgn/NTGv4APgMhrMCYr8GimaIgpHBLa9qWkds1xfMDDnokHGet+OspJMM
	6+Oua3QYbxLQC+dOTtIDEZeEgQUSZCA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A916C43BC4;
	Thu, 10 Sep 2026 16:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 430AC1F000FF;
	Thu, 10 Sep 2026 16:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789057637;
	bh=3aTGXI/vDH2A0yENDYRp5mBzUsR6PSfcXx9+o09dZsM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Dv3jVlGCtFEukBdJPnDyi0S9viaPBNEJ7EPE5diPLU/5eJtPhZH2flBsSFScJ/Ga8
	 LermgRTeEUvLmypfEdZd1t5Ip1ra2wmjEs71hq82nmsSdf9BYO8einEhPF2lzGqh9P
	 gDrGEfZGe4kLF1qUJEUdenxUtvu/jJ5gCldCFFvxY7kORb8kBtlu4FDs427OdYO8uu
	 1aacUpMWuMmZT5wvcUAkW4WSUlwq6wswm8Rl2cLyqEpcPSSAy+HFhStdQ3LtZxrKjC
	 8pb4PjO03HhHfacjkAvhrtc+RM2F+TPCaiM3Q7LjwBNjCxuA8FtYIQ6WTRg49L2wYY
	 ZOeQb2Uz/OMIA==
Date: Thu, 10 Sep 2026 17:27:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, willy@infradead.org, jannh@google.com, 
	paulmck@kernel.org, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 3/5] proc/task_mmu: remove special-casing of
 smap_gather_stats() start parameter
Message-ID: <aqLUqsoMDfVtjRuN@gremlin>
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-4-surenb@google.com>
 <4825a2fe-f064-45d7-a7c9-e98de7efe86c@kernel.org>
 <CAJuCfpFL_g7tELjT8p8ExM3tX_v2gNDM9rRKwwefPV_KW=fHfA@mail.gmail.com>
 <8e643f51-a47f-428e-9443-678326288fa6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8e643f51-a47f-428e-9443-678326288fa6@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3AFAC160014
X-Stat-Signature: dy5kmpg3nmmnw7ypz5t67d9qin95kfak
X-HE-Tag: 1789057639-606806
X-HE-Meta: U2FsdGVkX1+tzcyfAb+sAeYDy7Aj8o2vjFJEfim+isj7NC30t4EC7bhLVC/V1PjDn3IUcvw4PfvV0Y/LQqKixIwTFSJcCluLff/VbI6cjsLqVLDRx8J4SktoXEnxyfCWzlnndivK9t433gu2Icu5M3aYOSVF/dbiX4NKbGzVDkX7F38P39kMUbXgBt7473J7oE58qU9trSvBiCJAoapUzj37fj19q64CsEf3v4rDubHmmaK1yX6Gqj7hi+GiXQBADpg2ZAM2rXuTs/elRihJ0LCsibOJSkYBUXedN88DJgBI0KM+h9TYpBZC6XOvaSQexI+xq9SV9zSBbzY8J7jpoJIKuYqg7hPoVcpRbe5telNxJp5pjYJsHYhGCtL7bAWHBUGEOEnSCxkT0yO1f+rnuJni69zvkh0D3VdjL7oE0Rpv3OmHS5UpcfMjefDGnEPdjk7lv1lELMVkaqqesbEPCRopjzQrEXSLzRvBzZIn808y94bJk/lS5mWUs40a/Att8A3L3UoMUdolncfUX6UqPWs6W+30/Vw0Yr4hcvhcNMwIlDAWJP/wh9JSH4gJBpjxXLw/s5/Tn3h1VziDx5M/+AltOhhl9DwHrutQWXJtjdkFWo6NTaxBuln5OxNbIUKR6HDF2Z8Kp0xSZZWomoPBj2AnqmHs4M9KJZ6gwsJnUNeuDvLHh+g/mVJ+ZoSG6fdZ1PNF82Pxb7J0GTPKGtqBMQ+2lR0m0a2Z98Erwsav00mfrZohipOFAMnHt4b+vumu7/qntceQzplnuhsdLCwizkdbzwWCmMyHLTkPnAH0Zw8SUpxTm7rd7s2Yd4hwke8E9P7H56CyCHKYAHRwv0bMEvhZBRIQzNyaXXDcaWcZzLfWkXoX8q2MGNlRltGLeQRzwTY051GM6aiuUtYTNhukIVFAVQay3zzyt/O+UR/R3coKr3JTuF8Wd3e9WmxsTPhjnHsgGWa3wkw+s5+v5wd
 wFp/taII
 4XhvCAepK/FSA7wqXQAEe+yo5KBBrjNIdg+K29N6X1MvFbbrutQzma6Yyv11UqA6mJDSkMdrqxzJjypTXOw+sySQUqiU8BhW9G0jmU0IcensDzptiR6coZ8jq4n06scxn7u5V3G8oSauf++EyRUTB5BFK8g2Tde0HRdhTDpaETZUzRUTEG9cCFjhOC1jX5wCF378JhZo03WtaAttp/f1QRkNwdQwK4nLIq36a1UZXwts2nEo0XmGCrlg55K11P2yV0gqFpUWMhhU/iR2jw9HdDb4w9z3h/FATHevDsmWYU8dT+sK/m8G4CQSp7/ImYKXWUG59WbuNVg8G7BbRPHDGE3k2dH1dbX4sv6V1Up0MvgYsoF0r0eyaXWCc5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 09:16:23PM +0200, David Hildenbrand (Arm) wrote:
> On 9/9/26 20:28, Suren Baghdasaryan wrote:
> > On Wed, Sep 9, 2026 at 10:16 AM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >>
> >> On 9/7/26 08:39, Suren Baghdasaryan wrote:
> >>> smap_gather_stats() interprets its start parameter to mean vma->vm_start
> >>> when it's set to 0. Eliminate this special interpretation and pass
> >>> vma->vm_start explicitly when needed.
> >>>
> >>> Since smap_gather_stats() operates within a single VMA, we can replace
> >>> walk_page_vma()/walk_page_range() calls with walk_page_range_vma()
> >>> which is simpler and also can be called while holding per-VMA lock.
> >>>
> >>> No functional change intended.
> >>>
> >>> Suggested by: Lorenzo Stoakes <ljs@kernel.org>
> >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>> ---
> >>>  fs/proc/task_mmu.c | 40 ++++++++++++++++++++++------------------
> >>>  1 file changed, 22 insertions(+), 18 deletions(-)
> >>>
> >>> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> >>> index 9908ba32f180..3351decd1172 100644
> >>> --- a/fs/proc/task_mmu.c
> >>> +++ b/fs/proc/task_mmu.c
> >>> @@ -1246,20 +1246,27 @@ get_smaps_shmem_walk_ops(struct proc_maps_private *priv)
> >>>       return &smaps_shmem_walk_vma_lock_ops;
> >>>  }
> >>>
> >>> -/*
> >>> - * Gather mem stats from @vma with the indicated beginning
> >>> - * address @start, and keep them in @mss.
> >>> +/**
> >>> + * smap_gather_stats() - Gather mem stats from @vma.
> >>> + * @priv: proc maps private state.
> >>> + * @vma: The VMA to gather stats for.
> >>> + * @mss: The accumulated stats.
> >>> + * @start: The address from which to start.
> >>>   *
> >>> - * Use vm_start of @vma as the beginning address if @start is 0.
> >>> + * This gathers stats for the whole of the VMA unless the lock was dropped
> >>> + * and VMA grew or got merged and we found it again, in which case we only
> >>> + * gather stats for the remainder of the VMA range.
> >>>   */
> >>>  static void smap_gather_stats(struct proc_maps_private *priv,
> >>>                             struct vm_area_struct *vma,
> >>> -                           struct mem_size_stats *mss, unsigned long start)
> >>> +                           struct mem_size_stats *mss,
> >>> +                           unsigned long start)
> >>>  {
> >>>       const struct mm_walk_ops *ops = get_smaps_walk_ops(priv);
> >>> +     const bool is_partial = start > vma->vm_start;
> >>>
> >>>       /* Invalid start */
> >>> -     if (start >= vma->vm_end)
> >>> +     if (start < vma->vm_start || start >= vma->vm_end)
> >>>               return;
> >>>
> >>>       if (vma == get_gate_vma(priv->lock_ctx.mm))
> >>> @@ -1279,20 +1286,17 @@ static void smap_gather_stats(struct proc_maps_private *priv,
> >>>                * Unless we know that the shmem object (or the part mapped by
> >>>                * our VMA) has no swapped out pages at all.
> >>>                */
> >>> -             unsigned long shmem_swapped = shmem_swap_usage(vma);
> >>> +             const unsigned long shmem_swapped = shmem_swap_usage(vma);
> >>> +             const bool shared_or_ro = vma_test(vma, VMA_SHARED_BIT) ||
> >>> +                                       !vma_test(vma, VMA_WRITE_BIT);
> >>>
> >>> -             if (!start && (!shmem_swapped || (vma->vm_flags & VM_SHARED) ||
> >>> -                                     !(vma->vm_flags & VM_WRITE))) {
> >>> +             if (!is_partial && (!shmem_swapped || shared_or_ro))
> >>>                       mss->swap += shmem_swapped;
> >>> -             } else {
> >>> +             else
> >>>                       ops = get_smaps_shmem_walk_ops(priv);
> >>> -             }
> >>
> >> Horrible, horrible code, really. But not your fault :)
> >>
> >> I think we can just make the shared_or_ro less odd by just checking for cow
> >> mappings (as described in the comment).
> >>
> >>         const bool is_cow = vma_is_cow_mapping(vma);
> >>
> >> ...
> >>
> >>         if (is_partial || (shmem_swapped && is_cow))
> >>                 ops = get_smaps_shmem_walk_ops(priv);
> >>         else
> >>                 mss->swap += shmem_swapped;
> >>
> >> That's almost in a form that I could understand what's happening.
> >
> > Hmm. So, are you saying that !is_cow always implies shared_or_ro? Or
> > maybe you are stating that vma_is_cow_mapping() was the actual intent
> > here?
>
> So the comment says:
>
> "For private writable mappings, we might have COW pages that  .."
>
> Which translates to:
>
> 	private writable == vma_is_cow_mapping()
>
> >
> > shared_or_ro = VMA_SHARED_BIT || !VMA_WRITE_BIT
> >
> > is_cow = !VMA_SHARED_BIT && VMA_MAYWRITE_BIT
> > !is_cow = VMA_SHARED_BIT || !VMA_MAYWRITE_BIT
> >
> > so, !is_cow would impy shared_or_ro only if !VMA_MAYWRITE_BIT always
> > implies !VMA_WRITE_BIT. But I think it's possible to have a VMA that
> > has VMA_WRITE_BIT but not VMA_MAYWRITE_BIT, right?
>
> VMA_WRITE should imply VMA_MAYWRITE

Yup it's illegal to set VMA_WRITE_BIT without VMA_MAYWRITE_BIT.

>
> (in sanitize_fault_flags() we even disallow write faults entirely if VM_MAYWRITE
> is missing)
>
> For example, a
> > driver can create such a VMA to allow writing to the VMA but to lock
> > its content once mprotect(PROT_READ) gets called.

I'm not even sure how a driver would achieve that but drivers in general are not
permitted to alter VMA flags after map time.

>
> I don't think that would be valid for a driver to do. But it wouldn't matter
> here because
>
> 	shmem_mapping(vma->vm_file->f_mapping)

Yup :)

>
>
> I think we could simplify the comment as well to:
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e671b4fd8dedd..4b7e7089cafa7 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1303,12 +1303,10 @@ static void smap_gather_stats(struct proc_maps_private
> *priv,
>
>         if (vma->vm_file && shmem_mapping(vma->vm_file->f_mapping)) {
>                 /*
> -                * For shared or readonly shmem mappings we know that all
> -                * swapped out pages belong to the shmem object, and we can
> -                * obtain the swap value much more efficiently. For private
> -                * writable mappings, we might have COW pages that are
> -                * not affected by the parent swapped out pages of the shmem
> -                * object, so we have to distinguish them during the page walk.
> +                * In CoW mappings, we might have anon folios that are
> +                * independent of the shmem object. So fallback to the less
> +                * efficient mechanism in such mappings.
> +                *

Maybe tweak to 'CoW mappings might map anon folios that do not belong to shmem,
so perform a less efficient page table walk in this situation' or something like
that?


>                  * Unless we know that the shmem object (or the part mapped by
>                  * our VMA) has no swapped out pages at all.
>                  */



>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

