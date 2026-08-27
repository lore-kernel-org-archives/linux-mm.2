Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 441C5C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6F06B0092; Thu, 27 Aug 2026 07:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EB96B0096; Thu, 27 Aug 2026 07:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2946D6B0098; Thu, 27 Aug 2026 07:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB48A6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:16:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 819C5A3BD5
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:16:44 +0000 (UTC)
X-FDA: 85146796728.15.51CC4FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id CFAA3A0006
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:16:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LdHSYD0k;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787829402;
	b=1nWSdSFibtvV9LUBGcVwUH+yRt2IaX5TS8UfvMFVbhSjw7YZ8vqjcHs18SrUB9bVJRhXah
	eTx26AzZPt2BvW/lo6VLqDeu6m8jSLrtEZtcwfAGOmVsgs4758mqf5I7BRUBejfcGE4oIA
	Ja15rjdSrt9mzRmm6L4mCXpvxmP89rA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LdHSYD0k;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787829402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OD2HSj6vSWSq+UXXHPksJ28C1ZSsSeG6w5veYTpNS18=;
	b=sJ4mgkFSojK2oN2B9V06nB3QnI374NQ8SNldXPqhpSKg4cxseMrVWRSCwjVfOe/tPFw7yi
	yc23QQaV9k4OMbINHje7U2VU1X9x6xmJpdhJZfbm0BV8/5nmK1m8NhPdz8slng1WtQbGR4
	RHZevVGl8hMJFKtsN6gQVrlMei+ZuqU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 45FBA600D3;
	Thu, 27 Aug 2026 11:16:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DB61F00A3A;
	Thu, 27 Aug 2026 11:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787829402;
	bh=OD2HSj6vSWSq+UXXHPksJ28C1ZSsSeG6w5veYTpNS18=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LdHSYD0kBDNO5jSjeAP5qlz/0BJAy71bRRHeVDpmz6bDM2H9ToaTD7w665R3J86o1
	 sBj1P3uJDP6nc0TWxrgZ7TbjEDhAoIQN4wpDTSDqivwRYoY2bPMiFqLsPWTFDdtQdm
	 jooNeordE/vfynvVa87V2zrZQax18UgSmmK2dmqsUdASXua64ehhlQgDgDNGFR+gaz
	 s9MP5kBSr8bNIzTtsWW85ZgkBL7kxTbYnbAhrLT03/bmUJMhPzjnT+/tD4wMeR7tby
	 Sk6g0eVj8jNnCFnRWka/nJutvHqzaaj2G27JKCitEKlvtaCrcEGugJ3tNc7E9s9Ir7
	 dJ+KVBMq3ZbCw==
Date: Thu, 27 Aug 2026 12:16:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
Message-ID: <apAB9GSnHNyNoSc1@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <ao16VxNvaYzlt2WG@gremlin>
 <ao_9R3CbjYFipFu7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ao_9R3CbjYFipFu7@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CFAA3A0006
X-Stat-Signature: js4rg1xboqkpahweu7j1t9ejo5g3c3b9
X-HE-Tag: 1787829402-256747
X-HE-Meta: U2FsdGVkX190ZZ6ejwK+NdAAiaf/dtguBj3CC/cUxUTpKafo8d7yuSd+Fh+HsuSlW5OfxU+fSJC6x6itw5WM4QoRSioyZeOBOzY2HJ2zMPNCNZLAeh8utK39tU2RJyjGR2MqvdBG/1ECbGuNraOyhXFMTGrWzt/85kfj78h8X/dS2MxPUaBx3T6BrPedyd+/MiHq1hU0lV1pw3cyVqZ3vUCnX3NwKiQ2Tdigokmwh7bWHnTBbB3qtJjROMUN9Il9m7DyJ161eFw8PqgKHhIIeYBMBpQJoad0Y9thkqFi4wi8410o2tuy0GvypYZqjx23nxcUqGBLu6yuFBZ5J9ZBvTqkECIrZ2GkkqDKBvOyTnuC2bfiFYLrgAduet97coWh7qER2dcbliwFUvB3VFe3tk8vQbBHnV1EPXMY9/zmOuO57dy7L0gyYsdVcPQGhNEzzRchEYKwm+q+eJHQsFxfqq6+yBUsEAoQzziNACSY3e3Wi2jcHaProJdSepzBGYSnGTaLkuJ+jOJc9YsKb0Fv0OKMGQyuCQqfQ/DTlVXzdGyeevNO9XdSX64ztPReIT5BZcEdszVVn4SpX4D0Rbi1lzeIuXDNZWI9MhjWyftNFGQ1FprNS/WRhy9S43LZpiYsliG5A3SwvIVy5AS8Aryz5qXid9Ay/bMfXTcDJe6yYqV3/2AdArA+70BCwgeEcwu5B684XWmq7osAdGXcUVqkOuPCFwH30i/1W0N0blOQzPvOrdtm9rRehmXNQzOp1be8MbET0KZk9EWuwZdAXZMovGWJr3PG1c3cwZ53QnCL9nMohKc+5htustx7Uhfm5v6XuTKY/TD92DCC0taxGKB4WOWGxBEfYiC2FNdCmspq6TsEKCuiz9C0rG6A3C7UNdw1lt6VbFkH5a/njojxJwf9infliQojklrtgOEh9EX4I6Va7ajhOSi6wiVjCK/2894BQu+xy2LiNALa8+Gsdtx
 X6YOpMKG
 SbRHPh14hBruwVGYVVGlt74ulphA19z8dv+5ujSRnyrGKHg5vGg0xg6dLEniY1irUvSh2S6dOyTALToweFxeX+DFxrWYq/RhLvaQSE5RtvwfeHZKWwijupfmOZcw0CLNRnNYhowJ5tWgp1mFbuHW441NJWzqlUfUk33ueZdt9YuUkfk0JYdiXFFkWly2skEfAMxiD/WmdM3WiYeZDJPwhyiI9AkAW8SCckmEF32M1bbbcWQ7Sjh14xbnUvchu/dLKyOK9RvZ2bFxaEBHl2epDFaNLEfPs3cuXv7FXnxFnuqeE4CXh1Zcz2DVghs1n68QhzvOLgIAAiMrrrXc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 12:03:03PM +0300, Mike Rapoport wrote:
> On Tue, Aug 25, 2026 at 01:44:23PM +0100, Lorenzo Stoakes (ARM) wrote:
> > I don't love referring to the legacy flags in the subject but I gues you
> > have limited space...
> >
> > On Sun, Aug 23, 2026 at 03:17:43PM +0300, Mike Rapoport (Microsoft) wrote:
> > > Add 'mode' field to struct vm_uffd_state and define UFFD_MODE_ flags.
> >
> > Can you mention that you're increasing the size of the VMA by 4 bytes
> > please? (8 bytes if __HAVE_PFNMAP_TRACKING I believe too).
>
> With CONFIG_PER_VMA_LOCK I'm decreasing the headroom by 4 bytes, I'll add a
> few sentences in the changelog.

(Note that CONFIG_PER_VMA_LOCK is going away and defaulting on)

No sorry, you're incorrect.

With my anon pgoff series landed (been sent upstream to Linus), and with a
typical distro config (including CONFIG_NUMA_BALANCING on:

$ pahole vm_area_struct
struct vm_area_struct {
	union {
		struct {
			unsigned long vm_start;          /*     0     8 */
			unsigned long vm_end;            /*     8     8 */
		};                                       /*     0    16 */
		freeptr_t          vm_freeptr;           /*     0     8 */
	};                                               /*     0    16 */
	union {
		struct {
			unsigned long      vm_start;             /*     0     8 */
			unsigned long      vm_end;               /*     8     8 */
		};                                               /*     0    16 */
		freeptr_t                  vm_freeptr;           /*     0     8 */
	};

	struct mm_struct *         vm_mm;                /*    16     8 */
	pgprot_t                   vm_page_prot;         /*    24     8 */
	union {
		const vm_flags_t   vm_flags;             /*    32     8 */
		vma_flags_t        flags;                /*    32     8 */
	};                                               /*    32     8 */
	union {
		const vm_flags_t           vm_flags;             /*     0     8 */
		vma_flags_t                flags;                /*     0     8 */
	};

	unsigned int               vm_lock_seq;          /*    40     4 */
	unsigned int               __vm_anon_pgoff_lo;   /*    44     4 */
	struct list_head           anon_vma_chain;       /*    48    16 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct anon_vma *          anon_vma;             /*    64     8 */
	const struct vm_operations_struct  * vm_ops;     /*    72     8 */
	unsigned long              vm_pgoff;             /*    80     8 */
	struct file *              vm_file;              /*    88     8 */
	void *                     vm_private_data;      /*    96     8 */
	atomic_long_t              swap_readahead_info;  /*   104     8 */
	struct mempolicy *         vm_policy;            /*   112     8 */
	struct vma_numab_state *   numab_state;          /*   120     8 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	refcount_t                 vm_refcnt __attribute__((__aligned__(64))); /*   128     4 */
	unsigned int               __vm_anon_pgoff_hi;   /*   132     4 */
	struct {
		struct rb_node     rb __attribute__((__aligned__(8))); /*   136    24 */
		unsigned long      rb_subtree_last;      /*   160     8 */
	} shared;                                        /*   136    32 */
	struct {
		struct rb_node             rb __attribute__((__aligned__(8))); /*     0    24 */
		unsigned long              rb_subtree_last;      /*    24     8 */

		/* size: 32, cachelines: 1, members: 2 */
		/* forced alignments: 1 */
		/* last cacheline: 32 bytes */
	};

	struct anon_vma_name *     anon_name;            /*   168     8 */
	struct vm_userfaultfd_ctx  vm_userfaultfd_ctx;   /*   176     8 */
	struct pfnmap_track_ctx *  pfnmap_track_ctx;     /*   184     8 */

	/* size: 192, cachelines: 3, members: 21 */
	/* forced alignments: 1 */
};

i.e. zero headroom.

Same kernel with your series applied:

$ pahole vm_area_struct
➜  mm git:(mike) pahole vm_area_struct
struct vm_area_struct {
	union {
		struct {
			unsigned long vm_start;          /*     0     8 */
			unsigned long vm_end;            /*     8     8 */
		};                                       /*     0    16 */
		freeptr_t          vm_freeptr;           /*     0     8 */
	};                                               /*     0    16 */
	union {
		struct {
			unsigned long      vm_start;             /*     0     8 */
			unsigned long      vm_end;               /*     8     8 */
		};                                               /*     0    16 */
		freeptr_t                  vm_freeptr;           /*     0     8 */
	};

	struct mm_struct *         vm_mm;                /*    16     8 */
	pgprot_t                   vm_page_prot;         /*    24     8 */
	union {
		const vm_flags_t   vm_flags;             /*    32     8 */
		vma_flags_t        flags;                /*    32     8 */
	};                                               /*    32     8 */
	union {
		const vm_flags_t           vm_flags;             /*     0     8 */
		vma_flags_t                flags;                /*     0     8 */
	};

	unsigned int               vm_lock_seq;          /*    40     4 */
	unsigned int               __vm_anon_pgoff_lo;   /*    44     4 */
	struct list_head           anon_vma_chain;       /*    48    16 */
	/* --- cacheline 1 boundary (64 bytes) --- */
	struct anon_vma *          anon_vma;             /*    64     8 */
	const struct vm_operations_struct  * vm_ops;     /*    72     8 */
	unsigned long              vm_pgoff;             /*    80     8 */
	struct file *              vm_file;              /*    88     8 */
	void *                     vm_private_data;      /*    96     8 */
	atomic_long_t              swap_readahead_info;  /*   104     8 */
	struct mempolicy *         vm_policy;            /*   112     8 */
	struct vma_numab_state *   numab_state;          /*   120     8 */
	/* --- cacheline 2 boundary (128 bytes) --- */
	refcount_t                 vm_refcnt __attribute__((__aligned__(64))); /*   128     4 */
	unsigned int               __vm_anon_pgoff_hi;   /*   132     4 */
	struct {
		struct rb_node     rb __attribute__((__aligned__(8))); /*   136    24 */
		unsigned long      rb_subtree_last;      /*   160     8 */
	} shared;                                        /*   136    32 */
	struct {
		struct rb_node             rb __attribute__((__aligned__(8))); /*     0    24 */
		unsigned long              rb_subtree_last;      /*    24     8 */

		/* size: 32, cachelines: 1, members: 2 */
		/* forced alignments: 1 */
		/* last cacheline: 32 bytes */
	};

	struct anon_vma_name *     anon_name;            /*   168     8 */
	struct vm_uffd_state       vm_uffd_state;        /*   176    16 */

	/* XXX last struct has 4 bytes of padding */

	/* --- cacheline 3 boundary (192 bytes) --- */
	struct pfnmap_track_ctx *  pfnmap_track_ctx;     /*   192     8 */

	/* Force padding: */
	struct pfnmap_track_ctx *  :64;
	struct pfnmap_track_ctx *  :64;
	struct pfnmap_track_ctx *  :64;
	struct pfnmap_track_ctx *  :64;
	struct pfnmap_track_ctx *  :64;
	struct pfnmap_track_ctx *  :64;
	struct pfnmap_track_ctx *  :64;

	/* size: 256, cachelines: 4, members: 21 */
	/* padding: 56 */
	/* paddings: 1, sum paddings: 4 */
	/* forced alignments: 1 */
};

So actually you're increasing by a cacheline and increasing the VMA size by
64 bytes, i.e. 1/3, which is unacceptable obviously.

Maybe there's something that can be done with:

		/* forced alignments: 1 */

Perhaps? But that looks potentially ugly.

>
> > > Use this field to differentiate VMA registration with userfaultfd
> > > instead of relying on VM_UFFD_* flags.
> >
> > Here you should reference non-legacy VMA flag names.
>
> Ok.

Thanks.

>
> > > A VMA registered with userfaultfd will have a single VM_UFFD flag set
> > > and its registration mode (MISSING, MINOR, WP, RWP) is determined by
> > > vm_uffd_state.mode.
> > >
> > > This frees three vm_flags bits (12, 41, 43).
> >
> > Is the primary motivation here to eliminate these flags? We're paying a
> > cost in VMA bloat here so I think you need to argue for it. I wouldn't say
> > freeing up VMA flags justifies adding 4 or 8 bytes per VMA.
>
> The motivation is to first disambiguate fault reason and VMA registration
> mode and second create a per-VMA state for uffd for future use.
> AFAIR Sean mentioned during guest_memfd discussions that a few status bits
> would have been useful there.

Thanks.

I feel this series is not really clarifying things very well at this point,
it's all still very confusing.

It feels more like taking the existing UFFD approach and just putting a
'store the same state elsewhere' overlay on top, which isn't really helping
anything.

I am left a. confused about how all these flags interact (which suggests
the bad design is still in place) and b. wondering what the benefits are.

Which indicates that the design could be much improved and clarified here.

>
> > We've put a lot of effort into reducing VMA size so I think any size
> > increase in standard shipped 64-bit kernels has to be justified.
>
> Standard shipped kernels have CONFIG_PER_VMA_LOCK=y which makes VMAs padded
> to the next cacheline so adding a field there only decreases padding.
>
> I can also move vm_uffd_state after pfnmap_track_ctx to keep it in the end
> so there won't be 4 bytes hole.

There's no hole there see above. I'm not sure if rearranging can fix it?
Maybe there is some other way.

>
> If/when we run out of space, we can allocate uffd state separately, but
> it's more involved so I don't think it's necessary at this point.
>
> > Also there's weirdness around the flag behaviour with WP. As I recall
> > there's strange situations where you have to examine state of the
> > destination VMA when doing a UFFDIO_MOVE or something like that and there's
> > just strange edge cases.
> >
> > I'm guessing the change is just independent of this and in both cases
> > you're checking for state just in different please?
>
> The check is explicit in vma_needs_copy().

Yup one of the inconsistently named checks, userfaultfd_protected().

This was from before but really the majority of vma checks are vma_xxx() so
let's actually clean this up and call it vma_is_uffd_protected() or
something like this, please.

>
> > > Update the relevant code to use UFFD_MODE_* instead of VM_UFFD_* flags.
> >
> > USERFAULT_, UF_, UFFD_... Can we settle on one?
>
> As I replied to David, 'USERFAULT' means the type of the fault.
> For modes, or flags, UFFD_ is the "subsystem" namespace.

I think this naming inconsistency is really horrible and confusing, that
has to change. 'uffd' everywhere please.

>
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index 4daf9cd6ae8e..416de7663951 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -303,7 +303,7 @@ enum {
> > >  	DECLARE_VMA_BIT(MAYSHARE, 7),
> > >  	DECLARE_VMA_BIT(GROWSDOWN, 8),	/* general info on the segment */
> > >  #ifdef CONFIG_MMU
> > > -	DECLARE_VMA_BIT(UFFD_MISSING, 9),/* missing pages tracking */
> > > +	DECLARE_VMA_BIT(UFFD, 9),	/* userfaultfd registered */
> >
> > Since we're getting rid of other flags, can we just have UFFD occupy a flag
> > that isn't conditional on CONFIG_MMU? Maybe bit 12 instead?
>
> Sure, can do.

Thanks!

>
> > Presumably nommu will never set/use VMA_UFFD_BIT (CONFIG_USERFAULTFD won't
> > be set) and it'll make everything easier this way.
> >
> > > -#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
> > > -			 VM_MAYBE_GUARD)
> > > +#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_MAYBE_GUARD)
> >
> > Really this should be converted to the new VMA flags model, but I guess
> > it's outside of the scope of this change.
>
> It is, yes.

Yup that's fine.

>
> > >
> > >  /*
> > >   * mapping from the currently active vm_flags protection bits (the
> > > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > > index d6deb655d82e..8354d1c18b29 100644
> > > --- a/include/linux/mm_types.h
> > > +++ b/include/linux/mm_types.h
> > > @@ -723,6 +723,7 @@ struct vm_region {
> > >  #define NULL_VM_UFFD_STATE ((struct vm_uffd_state) { NULL, })
> > >  struct vm_uffd_state {
> > >  	struct userfaultfd_ctx *ctx;
> > > +	unsigned int mode;
> > >  };
> >
> > Hmm this is adding 4 bytes at least to every VMA is that OK?
>
> See above.

See pahole results above.

>
> > I was going to say this adds a cache line but no it shouldn't as it's right
> > at the end.
> >
> > VMA size scaling is a real issue though and this increases every VMA by 4
> > bytes, can't it be put in userfaultfd_ctx? I guess not as it's a per-VMA
> > thing.
>
> It can't be in userfaultfd_ctx. It's essentially the backpointer to the
> file descriptor context.

Yeah I assumed as much.

I wonder if we can grab the lower bits in the context pointer for this
state actually?

>
> > And does all of the NULL stuff now actually still work?
>
> Yes.

OK good!

>
> > > +/* Per-VMA uffd modes */
> > > +#define UFFD_MODE_MISSING	BIT(0)
> > > +#define UFFD_MODE_MINOR		BIT(1)
> > > +#define UFFD_MODE_RWP		BIT(2)
> > > +#define UFFD_MODE_WP		BIT(3)
> > > +#define UFFD_MODE_ALL		(UFFD_MODE_MISSING | UFFD_MODE_MINOR | \
> > > +				 UFFD_MODE_RWP | UFFD_MODE_WP)
> >
> > An entirely new set of duplicative flags?
>
> I'll make these BIT(31) - BIT(28) ;-)

I think really the point is that it's not clear what each of these distinct
flags are for, I guess I'm repeating myself on that :)

I think the constructive way forward is to make it super clear, whether
through types, commit msg, comments etc.

>
> > And now we're flitting from USERFAULT_ to UFFD_ for some reason...
>
> See above.

Yeah I really think keeping this consistent works best.

>
> > Mode also seems to me to imply a specific setting not a set of flags.
> >
> > So you probably want to put the word 'flag' in there somewhere... Or say
> > 'mode_s_'. Since multiple can be set right?
>
> I'll see how to improve the naming.

Thanks!

>
> > And weird/inconsistent to declare the USERFAULT_xxx as an enum and #define's
> > here as well as the naming?
>
> Since the field lives in mm_types.h it'd require "include userfaultfd_k.h"
> to make this an enum.

I mean or we could just put the damn stuff in mm_types.h :) I really hate
usserfaultfd_k.h as a header honestly. It makes little sense.

>
> > >  static inline bool is_mergeable_vm_uffd_state(struct vm_area_struct *vma,
> > >  					struct vm_uffd_state vm_ctx)
> > >  {
> > > -	return vma->vm_uffd_state.ctx == vm_ctx.ctx;
> > > +	return vma->vm_uffd_state.ctx == vm_ctx.ctx &&
> > > +	       uffd_mode(vma) == vm_ctx.mode;
> >
> > You see it's things like this that make the naming problematic, now it
> > seems that mode (whose very name implies a singular state) is being checked
> > against another which can either be in one mode or another but actually
> > you're doing a flags check...
>
> I see your point, will rename to some *flags*.

Thanks!

>
> > >  }
> > >
> > >  static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
> > >  {
> > > -	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
> > > +	return vma_test(vma, VMA_UFFD_BIT) &&
> > > +	       (uffd_mode(vma) & UFFD_MODE_MISSING);
> >
> > This is broken assuming this can be executed in a context where VMA_UFFD can be
> > VMA_NONE.
>
> No, it isn't. This is under #ifdef CONFIG_USERFAULTFD that depends on
> CONFIG_MMU so VMA_UFFD is defined.

OK but now that means there's a subtle hidden dependency there that is
really easy to break in future.

(I assume this is true of every other case where I've flagged this, I guess
I could ask AI to check :)

In any case using bit 12 eliminates all this so moot.

>
> > You should use vma_test_single_mask(). Or preferably, as above, just always
> > provide VMA_UFFD_BIT.
>
> It's an interesting API engineering, where the most obvious API does not
> always work and one needs to verify the bit definitions to understand what
> exact API variant to use.

Yeah I agree that it's an unfortunate aspect of the VMA flags design,
unfortunately it's kind of inherent - to have a bitmap VMA flags type you
have to define by bit and lose the VM_NONE stuff, and this solution is
really a bit of a hack.

Really the problem only emerges in practice in two cases:

1. A 64-bit value in a 32-bit kernel (not the case here)
2. An if-deffed bit value (the issue here0

Case 2 is pretty rare, so (and I think you agreed elsewhere) avoiding this
is the right solution.

I am thinking of solving case 1 by just switching 32-bit kernels to a
64-bit vma_flags_t :) but still mulling that one!

Moving forwards I think avoiding the pattern is probably the better way,
rather determining whether or not a feature is a thing based on whether a
VMA flag bit is set

>
> > The problem is with bits we can't express a VM_NONE equivalent, which is
> > why VMA_UFFD is defined.
> >
> > It seems the only places that's used are ones where you could, or already
> > do, gate on uffd being enabled:
> >
> > include/linux/mm.h: * vma_flags_t flags = mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR);
> >
> > (This is a comment that needs updating see my comment at the end of review).
>
> See my comment there.

Ack

>
> > mm/userfaultfd.c:	vma_flags_clear_mask(&new_vma_flags, VMA_UFFD);
> > mm/userfaultfd.c:		vma_flags_set_mask(&new_vma_flags, VMA_UFFD);
> >
> > >  }
> > >
> > >  static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
> > >  {
> > > -	return vma_test_any_mask(vma, VMA_UFFD_WP);
> > > +	return vma_test(vma, VMA_UFFD_BIT) &&
> > > +	       (uffd_mode(vma) & UFFD_MODE_WP);
> >
> > Same comment as above this seems broken.
>
> See above.
>
> > >  }
> > >
> > >  static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
> > >  {
> > > -	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
> > > +	return vma_test(vma, VMA_UFFD_BIT) &&
> > > +	       (uffd_mode(vma) & UFFD_MODE_MINOR);
> >
> > Same comment as above this seems broken.
>
> See above.
>
> > >  }
> > >
> > >  static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
> > > @@ -203,7 +213,8 @@ static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
> > >  	 */
> > >  	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
> > >  		return false;
> > > -	return vma_test_single_mask(vma, VMA_UFFD_RWP);
> > > +	return vma_test(vma, VMA_UFFD_BIT) &&
> > > +	       (uffd_mode(vma) & UFFD_MODE_RWP);
> >
> > Same comment as above this seems broken.
>
> See above.
>
> > Obviously I don't love the &&, & but that seems a moot point.
>
> We agreed to disagree, didn't we? :)

Yup but the pattern repeats all over the place and in each case you're
checking _both_ VMA_UFFD_BIT _and_ a uffd mode.

So that's open-coded and duplicated, it'd therefore be nice to separate it
out.

E.g.:

	static inline bool vma_test_uffd_flags(const struct vm_area_struct *vma,
			unsigned int uffd_flags)
	{
		return vma_test(vma, VMA_UFFD_BIT) &&
			(vma_uffd_flags(vma) & uffd_flags);
	}

Then this kind of pattern simply becomes:

	return vma_test_uffd_flags(vma, UFFD_FLAG_RWP);

Nicer right?

[If I didn't say elsewhere also it'd be nice to rename uffd_mode() to
vma_uffd_flags() or something so the vma_xxx() pattern is kept consistent.]

>
> > >  }
> > >
> > >  static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
> > > @@ -271,7 +282,7 @@ static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
> > >
> > >  static inline bool userfaultfd_armed(struct vm_area_struct *vma)
> > >  {
> > > -	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
> > > +	return vma_test(vma, VMA_UFFD_BIT);
> >
> > Same comment as above.
>
> See above.
>
> > >  }
> > >
> > > -IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
> > >  	{VM_LOCKED,			"locked"	},		\
> > >  	{VM_IO,				"io"		},		\
> > >  	{VM_SEQ_READ,			"seqread"	},		\
> >
> > Shouldn't you update the tracing logic to obtain these from uffd
> > modes/flags?
>
> Yep, will do.

Thanks!

>
> > >  	/*
> > >  	 * If WP is the only mode enabled and context is wp async, allow any
> > >  	 * memory type.
> > >  	 */
> > > -	if (wp_async && (vm_flags == VM_UFFD_WP))
> > > +	if (wp_async && (mode == UFFD_MODE_WP))
> >
> > Yeah again this is so so confusing and the naming really doesn't help.
> >
> > I wonder if helpers similar to the vma flag helpers could come in handly.
> >
> > I know you claim that kind of thing is overengineering but you're
> > open-coding checks all over the place, then doing a subtle variation like
> > this which is really really easy to miss.
> >
> > Something like userfault_test() would be nice.
>
> I don't see how it'll be clearer. How
>
> 	userfault_test_single_mask(mode, UFFD_MODE_WP_BIT)
>
> is better than a plain == comparison?

Because you are testing for something very distinct from every other
instance where you are checking for a 'mode'.

In every other case it's 'is this flag set'. In this case it's 'is this
flag distinctly set'.

Renaming this from mode to flags obviously helps make things clearer.

But given there's a comment there and you're renaming mode -> flags anyway
that should be fine.

>
> > At any rate 'modes' or 'flags' or something would be clearer here.
>
> I'll rethink the naming.

Thanks.

>
> > >  		new_vma_flags = vma->flags;
> > > -		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
> > > -		vma_flags_set_mask(&new_vma_flags, vma_flags);
> > > +		vma_flags_set_mask(&new_vma_flags, VMA_UFFD);
> >
> > This is oddly arbitrarily using VMA_UFFD inconsistent from all uses of
> > VMA_UFFD_BIT.
>
> Can't say I follow you here.

In every other instance of referencing the flag you are using VMA_UFFD_BIT,
here you are arbitrarily using the VMA_UFFD value.

Given we agreed on bit 12 anyway, let's drop VMA_UFFD altogether and use:

	vma_flags_set(&new_vma_flags, VMA_UFFD_BIT);

Here please!

>
> > > @@ -3814,11 +3817,11 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> > >  		cond_resched();
> > >
> > >  		VM_WARN_ON_ONCE(!!cur->vm_uffd_state.ctx ^
> > > -				!!(cur->vm_flags & __VM_UFFD_FLAGS));
> > > +				vma_test(cur, VMA_UFFD_BIT));
> >
> > Same comments as elsewhere re vma_test() on VMA_UFFD_BIT.
>
> See above.
>
> > > @@ -3857,7 +3860,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> > >  			if (end & (vma_hpagesize - 1))
> > >  				goto out_unlock;
> > >  		}
> > > -		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
> > > +		if ((mode & UFFD_MODE_WP) &&
> > > +		    !vma_test(cur, VMA_MAYWRITE_BIT))
> >
> > Really weird indentation and I think on one line it's 80 chars anyway?
>
> Indeed.
>
> > Thanks for switching to new VMA flags model though!
>
> Welcome :)

:)

>
> > >  			goto out_unlock;
> > >
> > >  		/*
> > > @@ -3872,13 +3876,13 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> > >  			goto out_unlock;
> > >
> > >  		/*
> > > -		 * Mode switches that drop VM_UFFD_WP or VM_UFFD_RWP would
> > > -		 * leave PTE markers without the flag that describes them;
> > > +		 * Mode switches that drop WP or RWP would leave PTE markers
> > > +		 * without the mode that describes them;
> > >  		 * subsequent mprotect() would then promote stale markers
> > >  		 * into the other mode. Require an unregister first.
> > >  		 */
> > >  		if (cur->vm_uffd_state.ctx == ctx &&
> > > -		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags)
> > > +		    uffd_mode(cur) & (UFFD_MODE_WP | UFFD_MODE_RWP) & ~mode)
> >
> > I mean this is just horrible beyond words aesthetically (and was before
> > tbf). But you've already rejected this kind of feedback so I guess, yeah I
> > object. Using bits or wrappers would make this potentially nicer.
>
> Very much doubt it.

Oh something I didn't notice before also:

	uffd_mode(cur) & (UFFD_MODE_WP | UFFD_MODE_RWP) & ~mode

Is pretty ambiguous no? Is ~mode applied to the result of (uffd_mode(cur) &
(UFFD_MODE_WP | UFFD_MODE_RWP)) or just to (UFFD_MODE_WP | UFFD_MODE_RWP)?

Probably should be e.g.:

	((uffd_mode(cur) & (UFFD_MODE_WP | UFFD_MODE_RWP)) & ~mode)

Or:

	uffd_mode(cur) & ((UFFD_MODE_WP | UFFD_MODE_RWP) & ~mode)

I guess it ultimately doesn't matter either way since you're checking for
either flag being set but then that leads on to how confusing this pattern
is:

You're checking for either flag only if those flags were not set in mode?

So in English, it's 'check to see if UFFD_MODE_WP or UFFD_MODE_RWP are
set if and only if those modes were not already set in mode'.

So you have to decode this to 'are the WP flags dropped?'

So I'm sorry that is pretty confusing I would say, especially kept all in
one line!

(I personally confused myself by looking at this, not sure what kind of
barometer that is :)

I disagree that we can't improve it, something like:

	static inline bool vma_is_uffd_ctx(const struct vm_area_struct *vma,
			const struct userfaultfd_ctx *ctx)
	{
		return vma->vm_uffd_state.ctx == ctx;
	}

	...

	const unsigned int old_wp_flags =
		uffd_mode(cur) & (UFFD_MODE_WP | UFFD_MODE_RWP);
	const unsigned int new_wp_flags =
		mode & (UFFD_MODE_WP | UFFD_MODE_RWP);
	const bool drops_wp_flags = old_wp_flags & ~new_wp_flags;

	...

	if (vma_is_uffd_ctx(cur, ctx) && drops_wp_flags)
		goto out_unlock;

Would be clearer I think right?

>
> > Same objection to the use of the word 'mode'. You really need to say flags
> > here somehow.
> >
> > >  			goto out_unlock;
> > >
> > >  		/*
> > > @@ -3891,7 +3895,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> > >  	} for_each_vma_range(vmi, cur, end);
> > >  	VM_WARN_ON_ONCE(!found);
> > >
> > > -	ret = userfaultfd_register_range(ctx, vma, vm_flags, start, end,
> > > +	ret = userfaultfd_register_range(ctx, vma, mode, start, end,
> > >  					 wp_async);
> > >
> > >  out_unlock:
> > > @@ -3986,7 +3990,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> > >  		cond_resched();
> > >
> > >  		VM_WARN_ON_ONCE(!!cur->vm_uffd_state.ctx ^
> > > -				!!(cur->vm_flags & __VM_UFFD_FLAGS));
> > > +				vma_test(cur, VMA_UFFD_BIT));
> >
> > Again you should use vma_test_single_mask(). I'm not sure why you dropped
> > one for the other unless provably all of these paths are CONFIG_MMU.
>
> This one as well inside #ifdef CONFIG_USERFAULTFD

Yup bit 12 resolves.

>
> > But it'd make life a lot easier to just use a bit number that isn't
> > predicated on CONFIG_MMU.
>
> It would have been easier if vma_test() could deal with that ;-P

Explained above why it's challenging. It does suck yes!

>
> > >
> > >  		/*
> > >  		 * Prevent unregistering through a different userfaultfd than
> > > @@ -4003,7 +4007,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> > >  		 * provides for more strict behavior to notice
> > >  		 * unregistration errors.
> > >  		 */
> > > -		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
> > > +		if (!vma_can_userfault(cur, uffd_mode(cur), wp_async))
> > >  			goto out_unlock;
> > >
> > >  		found = true;
> > > @@ -4024,7 +4028,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> > >  			goto skip;
> > >
> > >  		VM_WARN_ON_ONCE(vma->vm_uffd_state.ctx != ctx);
> > > -		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vma->vm_flags, wp_async));
> > > +		VM_WARN_ON_ONCE(!vma_can_userfault(vma, uffd_mode(vma),
> > > +						   wp_async));
> >
> > Nit but pretty horrible alignment. Gues it can 't be helped
>
> Would run out of 80 chars :(

Yup not a big deal obviously!

>
> But I'm thinking now to add one more patch to get rid from passing wp_async
> to vma_can_userfault().
>
> > Also, in the mk_vma_flags_from_masks() macro, there's a comment that
> > explicitly references VMA_UFFD_MINOR:
> >
> > /*
> >  * Combine pre-computed vma_flags_t masks into one value, e.g.:
> >  *
> >  * vma_flags_t flags = mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR);
> >  *
> >  * Unlike mk_vma_flags(), which takes bit numbers, this takes whole masks --
> >  * each of which may be EMPTY_VMA_FLAGS when its feature is unavailable -- so a
> >  * bit that does not exist on the current build is never materialised.
> >  */
> > #define mk_vma_flags_from_masks(...)					\
> >
> > You should change that...
>
> That was used only by uffd, do you want to keep the macro still?

Let's drop it altogether if it's not used anywhere thanks!

>
> > Could even be with placeholder flag names potentially.
>
> Like VMA_FLAG_A, VMA_FLAG_B?
>
> > On the engineering of this - this is one quite big, fiddly patch, if you
> > abstracted some of the tests into another you could do the change and the
> > abstraction separately.
> >
> > Overall I like what you're doing _in general_ but we have to:
> >
> > a. Figure out whether we want to pay the memory price for this (and the
> >    case has to be made in the commit message.
>
> I'll update the commit message.
>
> > b. Fix the VMA_UFFD_BIT stuff ideally with a bit that's just always set not
> >    predicated on CONFIG_MMU.
>
> Yeah, I'll make it bit 12. Really curious why that one wasn't #ifdefed on
> something.

Yeah it's odd that, but the bits themselves being #ifdef'd is itself a
strange thing, I think in this case was bit stuffing for nommu (ugh).

>
> > c. Improve the engineering so this stuff actually makes the code clearer
> >    rather than just reimplementing the same old confusing uffd mess.
>
> I don't agree that replacing plain bit operations with long multiword
> predicates makes the code clearer.
>
> Userfault is a complex beast and using, say,
> userfault_test_mode_bit_set(mode, UFFD_MODE_MISSING_BIT) instead of
> mode & UFFD_MODE_MISSING won't make it any less complex.
>
> > d. Fix the naming... modes, flags, uffd, userfault, uf, etc. let's stick
> >    with one and be consistent.
>
> flags could work, yes.
>
> uffd and userfault have different semantic meaning in the context of this
> series, userfault is a type of the page fault forwarded to user space, uffd
> is the namespace of userfault subsystem.

Right, I think we keep coming around to this as being unclear.

I think having those flags that must be distinct define in mm_types.h or
mm.h together with some explanation would resolve this, rather than
slinging state around in different files just for the sake of maintaining
userfaultfd_k.h as a thing.

>
> > IMO before it can move forwards.
> >
> > --
> > Cheers, Lorenzo
>
> --
> Sincerely yours,
> Mike.

--
Cheers, Lorenzo

