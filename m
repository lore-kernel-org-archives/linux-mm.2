Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12703C61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:03:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239A76B0098; Thu, 27 Aug 2026 05:03:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EB3E6B0099; Thu, 27 Aug 2026 05:03:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA3F6B009B; Thu, 27 Aug 2026 05:03:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB1AC6B0098
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:03:21 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3D3FD12037C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:03:21 +0000 (UTC)
X-FDA: 85146460602.22.3C567FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9477AC0009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:03:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pp8yzr/u";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787821399;
	b=IH5LNNwNeTAF36Mn8h+m8Df6rtae2338WHrWgj9Sr8ElMtdxUMNc2kTXqghRwizrRMnKMA
	a3JQJHRsnBOxjYyhfWLvdT2zl1oM6FlE0MYPa5fo53A78sMxsgLGkQa7Y6Z0f+v1qYl4xn
	JLgtIT5U5VKo3J3zCSrDHCr2UvlFtVk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pp8yzr/u";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787821399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ifyHjNlMzRF1wYqRSirYEsndPUqHoZ1TXUWfdm0Bmy0=;
	b=vu5JiJjBf3ykyvadhIT5jfu9GP7GpJi2Vit75sHCPj8Py5mftpT307uQPygWrhjMJ3M9+1
	0E5AxEL7tOSkiaSJqf0kQYzrAQ4HQ0hzIhcBSXqrMVIGCv+GUl2kJLPchV5HIkBtoeBipX
	3AkWzHJTakLCqhUyef5qHTiKC4q/SBA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AEE1600D2;
	Thu, 27 Aug 2026 09:03:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6301F000E9;
	Thu, 27 Aug 2026 09:03:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787821398;
	bh=ifyHjNlMzRF1wYqRSirYEsndPUqHoZ1TXUWfdm0Bmy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pp8yzr/ucd0AnkCYUTtxR5jm1AD8TbGvvaPaRgTfQjwHY+77IU89JmlCN/hxAsBY3
	 7hzNCEpjVeu0JllDmVuQSAzrABdbm8IPs+QfyKVQ9RTuSMuBythqqxk1xZwESZwpbw
	 5l+Zy6DS5veTNJ539zR/vhYJNmamnFdNL06akr0wyMX42ikUYkCJ+Xuu/mQ7EqL3aB
	 oVC+R5/NoNuSgPfoAWrKgNwwbucUXE6ZKWxJzygergpOCq2pQ58ubeZbxNH1vrP4v0
	 qJb9thCwqJgdpoDmgf18IB+5fFtgkYVTUePRBsvbiDOpnLI82Td/RnieK0iu+FJi2r
	 lVZpvlwMCICew==
Date: Thu, 27 Aug 2026 12:03:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
Message-ID: <ao_9R3CbjYFipFu7@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <ao16VxNvaYzlt2WG@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ao16VxNvaYzlt2WG@gremlin>
X-Rspam-User: 
X-Stat-Signature: fj8hoe5pg4gyggq4b47ujpr7wn74gu7t
X-Rspamd-Queue-Id: 9477AC0009
X-Rspamd-Server: rspam06
X-HE-Tag: 1787821399-944371
X-HE-Meta: U2FsdGVkX19GlRy0MkZX+qntF7asRBU+xXIuU9o24acRVdOYVh2j5tG54vmGFgAiJSvnyWatTF0EV3p4I5/RhB1qEQdX7f/kFFgtzQ4ML84uDjt4cpXMUTgd2iwcQQvRV1I9gyC55LtyfDYYZEmHbDHeTAWcEgsutqpPVv0taUdPM0x0h2h4hWZGqYYUMN3amOtXfXYbKKBXUXnJSYN0Qtn5QcMnBPN4OAbyBv45P14ZORyaIyPAv9dELEdW2L5rwux7rc5cPabkYx8fgl1izIzwTsQOg0A/karJWOR/uvs52jDworccKKA0sceSXSdkMG6g8xKxiIbbGohn1IYNBDDpX0slM0rlQ2h8usnjyfWWzpBDnG1jaozwt/McBJZbOVJU4hJ2vTtgjYkEPIyUlIeubXC3OY2JsJn4f/kKjTUyuq9PK1Y68xWi71wrj8ZDS52CvZHPt6ifl2iYEeH3FtSqRbCcl5yyoCivdGhkj2f2spQFSMk8seLfqlcODheJ2Q10sch471c04/aAYDlMQ0SSUca40ywUR/VzOzapp7IxiwogmRkeBL4fpiwvqJ4loGslIWCfq0zk8gYoOA0S7D7BWfwBrbk383dl/eZm+ZzQl2SJ7ekJc6DaK/PCoXxZXNfPNbu3jFJbqfnlUR+rrwwMfqFItu5upYtwGs/l+BOvhDIGJ2YHFUOsNMok2pOg/LaeY+gwtaa1UXQN2DvKE2FlLG6DTvKMVU/q302aKy3Fy/ouPnQs5zkbyEL3n9nIVpQp90f2HgMmTfqdqRaUq282AZsRnmd/diklbA8leRQ7IS+/XM1KfPhqMa+ffmPugeA7GjYuKwj5RcZbPS+l0qGtXRcyS5yQOgGR/BdFz8RCuFcglq2ac7MxWOOP/XZXObqU7g1n2EU3tPMcJr/d2xZ4X1Lg5xJt06CXCu6MnY4S3dRRcTnnIHpUWva6VApRdqxg1NhxnYMpvgYqauN
 f0eIitv2
 TzZf0s3qdft5B5eV//1MqWlfynIcr8c1QxJMVPTOkMXHiM9q+LKiQFZA2ReF3PNWYXulXR+ChfZ45nBpl/G7XagKV//aU7rVKCUUEhL6SWboshm4J+mXSl4uBl173nNN8mjrQKnuf1JuFIb4mGa0CJAgTQIqUn/TBkBzkAejSJOCWeLiE51wAJvghEKdEewOX7FnT46VM9jeNMXlGyku2nltmf+ujr8F6CZOB2LxkgV2gq8Rb1d34vFsltSgr3+mVpvSfjSN6v8M7UITFxy9Mav+UoaAqO2NEV8vs2x1ZZybiNLq/j9NEYQFWbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 01:44:23PM +0100, Lorenzo Stoakes (ARM) wrote:
> I don't love referring to the legacy flags in the subject but I gues you
> have limited space...
> 
> On Sun, Aug 23, 2026 at 03:17:43PM +0300, Mike Rapoport (Microsoft) wrote:
> > Add 'mode' field to struct vm_uffd_state and define UFFD_MODE_ flags.
> 
> Can you mention that you're increasing the size of the VMA by 4 bytes
> please? (8 bytes if __HAVE_PFNMAP_TRACKING I believe too).

With CONFIG_PER_VMA_LOCK I'm decreasing the headroom by 4 bytes, I'll add a
few sentences in the changelog.

> > Use this field to differentiate VMA registration with userfaultfd
> > instead of relying on VM_UFFD_* flags.
> 
> Here you should reference non-legacy VMA flag names.
 
Ok.

> > A VMA registered with userfaultfd will have a single VM_UFFD flag set
> > and its registration mode (MISSING, MINOR, WP, RWP) is determined by
> > vm_uffd_state.mode.
> >
> > This frees three vm_flags bits (12, 41, 43).
> 
> Is the primary motivation here to eliminate these flags? We're paying a
> cost in VMA bloat here so I think you need to argue for it. I wouldn't say
> freeing up VMA flags justifies adding 4 or 8 bytes per VMA.

The motivation is to first disambiguate fault reason and VMA registration
mode and second create a per-VMA state for uffd for future use.
AFAIR Sean mentioned during guest_memfd discussions that a few status bits
would have been useful there.
 
> We've put a lot of effort into reducing VMA size so I think any size
> increase in standard shipped 64-bit kernels has to be justified.

Standard shipped kernels have CONFIG_PER_VMA_LOCK=y which makes VMAs padded
to the next cacheline so adding a field there only decreases padding.

I can also move vm_uffd_state after pfnmap_track_ctx to keep it in the end
so there won't be 4 bytes hole.

If/when we run out of space, we can allocate uffd state separately, but
it's more involved so I don't think it's necessary at this point.
 
> Also there's weirdness around the flag behaviour with WP. As I recall
> there's strange situations where you have to examine state of the
> destination VMA when doing a UFFDIO_MOVE or something like that and there's
> just strange edge cases.
> 
> I'm guessing the change is just independent of this and in both cases
> you're checking for state just in different please?

The check is explicit in vma_needs_copy().  

> > Update the relevant code to use UFFD_MODE_* instead of VM_UFFD_* flags.
> 
> USERFAULT_, UF_, UFFD_... Can we settle on one?

As I replied to David, 'USERFAULT' means the type of the fault.
For modes, or flags, UFFD_ is the "subsystem" namespace.

> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index 4daf9cd6ae8e..416de7663951 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -303,7 +303,7 @@ enum {
> >  	DECLARE_VMA_BIT(MAYSHARE, 7),
> >  	DECLARE_VMA_BIT(GROWSDOWN, 8),	/* general info on the segment */
> >  #ifdef CONFIG_MMU
> > -	DECLARE_VMA_BIT(UFFD_MISSING, 9),/* missing pages tracking */
> > +	DECLARE_VMA_BIT(UFFD, 9),	/* userfaultfd registered */
> 
> Since we're getting rid of other flags, can we just have UFFD occupy a flag
> that isn't conditional on CONFIG_MMU? Maybe bit 12 instead?

Sure, can do.
 
> Presumably nommu will never set/use VMA_UFFD_BIT (CONFIG_USERFAULTFD won't
> be set) and it'll make everything easier this way.
> 
> > -#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_UFFD_WP | VM_UFFD_RWP | \
> > -			 VM_MAYBE_GUARD)
> > +#define VM_COPY_ON_FORK (VM_PFNMAP | VM_MIXEDMAP | VM_MAYBE_GUARD)
> 
> Really this should be converted to the new VMA flags model, but I guess
> it's outside of the scope of this change.

It is, yes.
 
> >
> >  /*
> >   * mapping from the currently active vm_flags protection bits (the
> > diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> > index d6deb655d82e..8354d1c18b29 100644
> > --- a/include/linux/mm_types.h
> > +++ b/include/linux/mm_types.h
> > @@ -723,6 +723,7 @@ struct vm_region {
> >  #define NULL_VM_UFFD_STATE ((struct vm_uffd_state) { NULL, })
> >  struct vm_uffd_state {
> >  	struct userfaultfd_ctx *ctx;
> > +	unsigned int mode;
> >  };
> 
> Hmm this is adding 4 bytes at least to every VMA is that OK?

See above.
 
> I was going to say this adds a cache line but no it shouldn't as it's right
> at the end.
> 
> VMA size scaling is a real issue though and this increases every VMA by 4
> bytes, can't it be put in userfaultfd_ctx? I guess not as it's a per-VMA
> thing.

It can't be in userfaultfd_ctx. It's essentially the backpointer to the
file descriptor context.
 
> And does all of the NULL stuff now actually still work?

Yes.
 
> > +/* Per-VMA uffd modes */
> > +#define UFFD_MODE_MISSING	BIT(0)
> > +#define UFFD_MODE_MINOR		BIT(1)
> > +#define UFFD_MODE_RWP		BIT(2)
> > +#define UFFD_MODE_WP		BIT(3)
> > +#define UFFD_MODE_ALL		(UFFD_MODE_MISSING | UFFD_MODE_MINOR | \
> > +				 UFFD_MODE_RWP | UFFD_MODE_WP)
> 
> An entirely new set of duplicative flags?

I'll make these BIT(31) - BIT(28) ;-)
 
> And now we're flitting from USERFAULT_ to UFFD_ for some reason...

See above.
 
> Mode also seems to me to imply a specific setting not a set of flags.
> 
> So you probably want to put the word 'flag' in there somewhere... Or say
> 'mode_s_'. Since multiple can be set right?

I'll see how to improve the naming.
 
> And weird/inconsistent to declare the USERFAULT_xxx as an enum and #define's
> here as well as the naming?

Since the field lives in mm_types.h it'd require "include userfaultfd_k.h"
to make this an enum.

> >  static inline bool is_mergeable_vm_uffd_state(struct vm_area_struct *vma,
> >  					struct vm_uffd_state vm_ctx)
> >  {
> > -	return vma->vm_uffd_state.ctx == vm_ctx.ctx;
> > +	return vma->vm_uffd_state.ctx == vm_ctx.ctx &&
> > +	       uffd_mode(vma) == vm_ctx.mode;
> 
> You see it's things like this that make the naming problematic, now it
> seems that mode (whose very name implies a singular state) is being checked
> against another which can either be in one mode or another but actually
> you're doing a flags check...
 
I see your point, will rename to some *flags*.

> >  }
> >
> >  static inline bool userfaultfd_missing(const struct vm_area_struct *vma)
> >  {
> > -	return vma_test_any_mask(vma, VMA_UFFD_MISSING);
> > +	return vma_test(vma, VMA_UFFD_BIT) &&
> > +	       (uffd_mode(vma) & UFFD_MODE_MISSING);
> 
> This is broken assuming this can be executed in a context where VMA_UFFD can be
> VMA_NONE.

No, it isn't. This is under #ifdef CONFIG_USERFAULTFD that depends on
CONFIG_MMU so VMA_UFFD is defined.
 
> You should use vma_test_single_mask(). Or preferably, as above, just always
> provide VMA_UFFD_BIT.

It's an interesting API engineering, where the most obvious API does not
always work and one needs to verify the bit definitions to understand what
exact API variant to use.
 
> The problem is with bits we can't express a VM_NONE equivalent, which is
> why VMA_UFFD is defined.
> 
> It seems the only places that's used are ones where you could, or already
> do, gate on uffd being enabled:
> 
> include/linux/mm.h: * vma_flags_t flags = mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR);
> 
> (This is a comment that needs updating see my comment at the end of review).
 
See my comment there.

> mm/userfaultfd.c:	vma_flags_clear_mask(&new_vma_flags, VMA_UFFD);
> mm/userfaultfd.c:		vma_flags_set_mask(&new_vma_flags, VMA_UFFD);
> 
> >  }
> >
> >  static inline bool userfaultfd_wp(const struct vm_area_struct *vma)
> >  {
> > -	return vma_test_any_mask(vma, VMA_UFFD_WP);
> > +	return vma_test(vma, VMA_UFFD_BIT) &&
> > +	       (uffd_mode(vma) & UFFD_MODE_WP);
> 
> Same comment as above this seems broken.

See above.
 
> >  }
> >
> >  static inline bool userfaultfd_minor(const struct vm_area_struct *vma)
> >  {
> > -	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
> > +	return vma_test(vma, VMA_UFFD_BIT) &&
> > +	       (uffd_mode(vma) & UFFD_MODE_MINOR);
> 
> Same comment as above this seems broken.

See above.
 
> >  }
> >
> >  static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
> > @@ -203,7 +213,8 @@ static inline bool userfaultfd_rwp(const struct vm_area_struct *vma)
> >  	 */
> >  	if (!IS_ENABLED(CONFIG_ARCH_HAS_PTE_PROTNONE))
> >  		return false;
> > -	return vma_test_single_mask(vma, VMA_UFFD_RWP);
> > +	return vma_test(vma, VMA_UFFD_BIT) &&
> > +	       (uffd_mode(vma) & UFFD_MODE_RWP);
> 
> Same comment as above this seems broken.

See above.
 
> Obviously I don't love the &&, & but that seems a moot point.

We agreed to disagree, didn't we? :)

> >  }
> >
> >  static inline bool userfaultfd_protected(const struct vm_area_struct *vma)
> > @@ -271,7 +282,7 @@ static inline bool userfaultfd_huge_pmd_rwp(struct vm_area_struct *vma,
> >
> >  static inline bool userfaultfd_armed(struct vm_area_struct *vma)
> >  {
> > -	return vma_test_any_mask(vma, __VMA_UFFD_FLAGS);
> > +	return vma_test(vma, VMA_UFFD_BIT);
> 
> Same comment as above.

See above.
 
> >  }
> >
> > -IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
> >  	{VM_LOCKED,			"locked"	},		\
> >  	{VM_IO,				"io"		},		\
> >  	{VM_SEQ_READ,			"seqread"	},		\
> 
> Shouldn't you update the tracing logic to obtain these from uffd
> modes/flags?

Yep, will do.
 
> >  	/*
> >  	 * If WP is the only mode enabled and context is wp async, allow any
> >  	 * memory type.
> >  	 */
> > -	if (wp_async && (vm_flags == VM_UFFD_WP))
> > +	if (wp_async && (mode == UFFD_MODE_WP))
> 
> Yeah again this is so so confusing and the naming really doesn't help.
> 
> I wonder if helpers similar to the vma flag helpers could come in handly.
> 
> I know you claim that kind of thing is overengineering but you're
> open-coding checks all over the place, then doing a subtle variation like
> this which is really really easy to miss.
> 
> Something like userfault_test() would be nice.

I don't see how it'll be clearer. How

	userfault_test_single_mask(mode, UFFD_MODE_WP_BIT)

is better than a plain == comparison?
 
> At any rate 'modes' or 'flags' or something would be clearer here.

I'll rethink the naming.
 
> >  		new_vma_flags = vma->flags;
> > -		vma_flags_clear_mask(&new_vma_flags, __VMA_UFFD_FLAGS);
> > -		vma_flags_set_mask(&new_vma_flags, vma_flags);
> > +		vma_flags_set_mask(&new_vma_flags, VMA_UFFD);
> 
> This is oddly arbitrarily using VMA_UFFD inconsistent from all uses of
> VMA_UFFD_BIT.

Can't say I follow you here.
 
> > @@ -3814,11 +3817,11 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> >  		cond_resched();
> >
> >  		VM_WARN_ON_ONCE(!!cur->vm_uffd_state.ctx ^
> > -				!!(cur->vm_flags & __VM_UFFD_FLAGS));
> > +				vma_test(cur, VMA_UFFD_BIT));
> 
> Same comments as elsewhere re vma_test() on VMA_UFFD_BIT.

See above.
 
> > @@ -3857,7 +3860,8 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> >  			if (end & (vma_hpagesize - 1))
> >  				goto out_unlock;
> >  		}
> > -		if ((vm_flags & VM_UFFD_WP) && !(cur->vm_flags & VM_MAYWRITE))
> > +		if ((mode & UFFD_MODE_WP) &&
> > +		    !vma_test(cur, VMA_MAYWRITE_BIT))
> 
> Really weird indentation and I think on one line it's 80 chars anyway?

Indeed.
 
> Thanks for switching to new VMA flags model though!
 
Welcome :)

> >  			goto out_unlock;
> >
> >  		/*
> > @@ -3872,13 +3876,13 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> >  			goto out_unlock;
> >
> >  		/*
> > -		 * Mode switches that drop VM_UFFD_WP or VM_UFFD_RWP would
> > -		 * leave PTE markers without the flag that describes them;
> > +		 * Mode switches that drop WP or RWP would leave PTE markers
> > +		 * without the mode that describes them;
> >  		 * subsequent mprotect() would then promote stale markers
> >  		 * into the other mode. Require an unregister first.
> >  		 */
> >  		if (cur->vm_uffd_state.ctx == ctx &&
> > -		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags)
> > +		    uffd_mode(cur) & (UFFD_MODE_WP | UFFD_MODE_RWP) & ~mode)
> 
> I mean this is just horrible beyond words aesthetically (and was before
> tbf). But you've already rejected this kind of feedback so I guess, yeah I
> object. Using bits or wrappers would make this potentially nicer.

Very much doubt it.
 
> Same objection to the use of the word 'mode'. You really need to say flags
> here somehow.
> 
> >  			goto out_unlock;
> >
> >  		/*
> > @@ -3891,7 +3895,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
> >  	} for_each_vma_range(vmi, cur, end);
> >  	VM_WARN_ON_ONCE(!found);
> >
> > -	ret = userfaultfd_register_range(ctx, vma, vm_flags, start, end,
> > +	ret = userfaultfd_register_range(ctx, vma, mode, start, end,
> >  					 wp_async);
> >
> >  out_unlock:
> > @@ -3986,7 +3990,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> >  		cond_resched();
> >
> >  		VM_WARN_ON_ONCE(!!cur->vm_uffd_state.ctx ^
> > -				!!(cur->vm_flags & __VM_UFFD_FLAGS));
> > +				vma_test(cur, VMA_UFFD_BIT));
> 
> Again you should use vma_test_single_mask(). I'm not sure why you dropped
> one for the other unless provably all of these paths are CONFIG_MMU.

This one as well inside #ifdef CONFIG_USERFAULTFD
 
> But it'd make life a lot easier to just use a bit number that isn't
> predicated on CONFIG_MMU.

It would have been easier if vma_test() could deal with that ;-P
 
> >
> >  		/*
> >  		 * Prevent unregistering through a different userfaultfd than
> > @@ -4003,7 +4007,7 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> >  		 * provides for more strict behavior to notice
> >  		 * unregistration errors.
> >  		 */
> > -		if (!vma_can_userfault(cur, cur->vm_flags, wp_async))
> > +		if (!vma_can_userfault(cur, uffd_mode(cur), wp_async))
> >  			goto out_unlock;
> >
> >  		found = true;
> > @@ -4024,7 +4028,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
> >  			goto skip;
> >
> >  		VM_WARN_ON_ONCE(vma->vm_uffd_state.ctx != ctx);
> > -		VM_WARN_ON_ONCE(!vma_can_userfault(vma, vma->vm_flags, wp_async));
> > +		VM_WARN_ON_ONCE(!vma_can_userfault(vma, uffd_mode(vma),
> > +						   wp_async));
> 
> Nit but pretty horrible alignment. Gues it can 't be helped

Would run out of 80 chars :(

But I'm thinking now to add one more patch to get rid from passing wp_async
to vma_can_userfault().
 
> Also, in the mk_vma_flags_from_masks() macro, there's a comment that
> explicitly references VMA_UFFD_MINOR:
> 
> /*
>  * Combine pre-computed vma_flags_t masks into one value, e.g.:
>  *
>  * vma_flags_t flags = mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR);
>  *
>  * Unlike mk_vma_flags(), which takes bit numbers, this takes whole masks --
>  * each of which may be EMPTY_VMA_FLAGS when its feature is unavailable -- so a
>  * bit that does not exist on the current build is never materialised.
>  */
> #define mk_vma_flags_from_masks(...)					\
> 
> You should change that... 

That was used only by uffd, do you want to keep the macro still?

> Could even be with placeholder flag names potentially.

Like VMA_FLAG_A, VMA_FLAG_B?
 
> On the engineering of this - this is one quite big, fiddly patch, if you
> abstracted some of the tests into another you could do the change and the
> abstraction separately.
> 
> Overall I like what you're doing _in general_ but we have to:
> 
> a. Figure out whether we want to pay the memory price for this (and the
>    case has to be made in the commit message.

I'll update the commit message.
 
> b. Fix the VMA_UFFD_BIT stuff ideally with a bit that's just always set not
>    predicated on CONFIG_MMU.

Yeah, I'll make it bit 12. Really curious why that one wasn't #ifdefed on
something.
 
> c. Improve the engineering so this stuff actually makes the code clearer
>    rather than just reimplementing the same old confusing uffd mess.

I don't agree that replacing plain bit operations with long multiword
predicates makes the code clearer.

Userfault is a complex beast and using, say,
userfault_test_mode_bit_set(mode, UFFD_MODE_MISSING_BIT) instead of 
mode & UFFD_MODE_MISSING won't make it any less complex.
 
> d. Fix the naming... modes, flags, uffd, userfault, uf, etc. let's stick
>    with one and be consistent.

flags could work, yes.
 
uffd and userfault have different semantic meaning in the context of this
series, userfault is a type of the page fault forwarded to user space, uffd
is the namespace of userfault subsystem. 

> IMO before it can move forwards.
> 
> --
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

