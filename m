Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FE5CCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A8C6B008A; Tue, 23 Jun 2026 04:09:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40B9E6B0092; Tue, 23 Jun 2026 04:09:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FADF6B0093; Tue, 23 Jun 2026 04:09:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E03646B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:09:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E3191C57E5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:09:48 +0000 (UTC)
X-FDA: 84910453656.27.E869E6F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D5E3120003
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:09:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUiPILmV;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782202186;
	b=ENuoK/OZ786Kt5/6niCt98+twEtTFvCXZ9G39nl7RXilCiZMG/FwoosCHRWOr4MkiUDRl8
	y+3Gt3DWmrAezhpkSEvn1GVVtQHM/MmwYCQOLIzvzq5KK/bBrxP3E8bhFtPNnfyQaKQ2kV
	zLqW9r6NkwBLFk5SqIzE456PhaD1ZQA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782202186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l6+hcxSmHD+x+2Iij3EYW/GYPqB/Bat6jKxnqJcOT3M=;
	b=OoARDXPfwZAuuh8LSFJtsXRgR8y3A+bJoh1lp8NL9bdeoB6IFx//Hx0MBFJ9mpLV2tuEFc
	3uKMctgfzSk+1cRQIytmcn4Ja9CIjljts8iKvuDu3lb+uslEni9Xmyoe+dKrM0lHwJ7EjM
	/yw2oOVy4w802Aog7pZzfp5OExaS31E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XUiPILmV;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5B51601F5;
	Tue, 23 Jun 2026 08:09:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7016C1F000E9;
	Tue, 23 Jun 2026 08:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782202185;
	bh=l6+hcxSmHD+x+2Iij3EYW/GYPqB/Bat6jKxnqJcOT3M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XUiPILmVm7LgmfMvBEO6XriuWaAs+jsKuXqnY/yk8STR8I7rfyLXhwImyw5sjIgOu
	 jyVGpMZIePQ88xA2V5O6tmUtNqg161khaPd3UZoN7FD85RRCpQ3tD6JuFPUAGYgM6j
	 8IynBXpQ5DNsscGVZB5zyX0jzWBostPktxqx5/oPNn3yo3UO71H0QFW4Kh0jOIBjZW
	 YzpnKU1avILvYzlqcY4YGqqlsCgGxRVKmX1Wpojpm5xOz2rFa6c0zX6N4F/swfNPAi
	 Nku0u7jGPGL689jTX53842vKpfK3lDdTnOrwLRPKyi1KoBnB26olmQuz2Ngwh3k+uv
	 8Fx+3nF+7KE0w==
Message-ID: <151b1c96-0ed5-44ce-b9d5-86a48d8ad592@kernel.org>
Date: Tue, 23 Jun 2026 10:09:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 00/10] kmem_cache instances with static storage
 duration
Content-Language: en-US
To: Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>,
 linux-fsdevel@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Mateusz Guzik <mjguzik@gmail.com>,
 linux-kernel@vger.kernel.org
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D5E3120003
X-Stat-Signature: cctbj4uw3kwz8hzkajdomw9ng68e3qtp
X-HE-Tag: 1782202186-613749
X-HE-Meta: U2FsdGVkX1+ugqBD1qji/93cV/uucAZMkD3eu7IPRq2uY0hNQRTwCFWIRZEjKFl68+/Xg/Q80gedDI7u3/q6TM03TvWSVI1bQtzEhdyUUYV3u/euth+ta8wOFho0m3jLPK78NnODF0hb+dudHvtxphFfCX2o9WC12UMI2JyE0oJxGHXB4FT9uLPJKM+n6uULKuu4L2/U/Zb38S9RJZDELCna3+9HcXeUDfZGqrMYmyCfdbuw8xi3oz/9ufU1vHscp278VdykNiF584sxHrvmTj7dti0lPSjcK4ClL95QuT2aC3E7hf2Omb6LZ4843/lM0IZ+RoFAWWNaOKmVlq2IvhAqS6uaHrQIXrdDauRyGrxlrmp8Qi3Kn8STEGEXYWpE2gRsC+diNDzvnUnqhLsZ5lcs/oQffBj+dYri12reVBIAkfOpfpmBbVmslN6EKCjNmG3dQUEpSv6+VxRP2KT2oTI6bao3RLrUXx1Ecc34dydjNzBhuG6lLyQmYRuW1FmpL1sguYyRylbMaxzJZ+tA3ZU9wEsMy5A+bXDWMfMGxphGyysunIolE2GG2iwEfwKLqqJ0WpKeebVqIN0e9A5WAaWqP+Bbye4DuStgCApgdbDXsfwQkbI0tdIwGgsmlNSG3RJtmwDdz+1Nt82jR9k6GZivFijtUObOd3JydpyvQTU1mE1VhnPNgLcaEGY29elLkx9Gpb0+7QYLmlJb4A325EhSeQcFkI/STPNf1EW1fzfgzNWpESolqbMYGt1/k0b+SKDFez/TS+rNvaquxuEc4ZzlPM0PhjEguxjjtrB3oXflZk9Onn1JNtqoy8KpXppppAqH48MwYiuGfMDT9gvyxbQvl0Cf4qL0nAi7CUEAeIvJEzxDRtj2U9P+B+R5BvTF6RiD4cYYygJeMr0zPzH2Jt3L97FPX7isWVq0eN+QX58tuOS6EppkB0J+pw8lFnu7UjAKNE90jibetc3I937
 1wZFwLB4
 I/V3AqpmOBz1nYzKf8NbaOG+p1rrZYUjFktqwKSZrQI/hcIQC+kgygIge9tSCOjlgXEl1ktWhfPIo5LnHNaaajERsItp4a7UxhpTpTDDj0DcFrpPyMJVfqqXcGJoR//4lPekeWxW+v2jFbYw1figvKiPjPu4lKQlTDqyitqk3Xt7qXXPXyWuSqZ/dfPXV2ARFIpWjUU19Iwr5VMv5+zQb2QP/ZrA0kPol83joOXWCkDhrT5P0RIMv1KGniiAInu6SfWYvzQIiGfiVmCK69sMw5+3ULepkqvvY1PjAE2yPEL8IB5xOKByLqA7Jm0JJCgTIL7I2MXSoIVaM1KY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/13/26 07:09, Al Viro wrote:
> Changes since v2:
> 	* fixed the braindamage in /sys/kernel/slab (any statically allocated
> caches should just use their name for subdirectory, whether they are mergable
> or not)
> 	* infrastructure bits slightly reordered and carved in hopefully saner
> way.
> 	* rebased to 7.1-rc7.
> 
> Changes since v1:
> 	* milder restrictions on mergability (non-modular static cache
> can be used as alias for later dynamic ones)
> 	* consolidated conversions into fewer commits
> 	* rebased to 7.1-rc6.
> 
> Branch lives in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.kmem_cache_static
> individual patches in followups.
> 
> Please, review.  It appears to work; the impact on merging is very small -
> on the testbox here (251 distinct aliases) mainline gets 140 kmem_cache
> instances and this series gets 142 - fs_cachep and names_cache get split
> from the group of 192-byte caches.  Considering the contents and use patterns
> for those two... we might be better off that way, actually.
> 
>         kmem_cache_create() and friends create new instances of
> struct kmem_cache and return pointers to those.  Quite a few things in
> core kernel are allocated from such caches; each allocation involves
> dereferencing an assign-once pointer and for sufficiently hot ones that
> dereferencing does show in profiles.
> 
>         There had been patches floating around switching some of those
> to runtime_const infrastructure.  Unfortunately, it's arch-specific
> and most of the architectures lack it.

There's only a handful of architectures that would be considered performance
critical enough for us to care, right? So the question is which ones of
those lack it and would the effort to make them support it be smaller than
doing this? Also this covers slab only, but I'd expect runtime_const() would
have use cases also in other subsystems that wouldn't need
subsystem-specific changes?

>         There's an alternative approach applicable at least to the caches
> that are never destroyed, which covers a lot of them.  No matter what,
> runtime_const for pointers is not going to be faster than plain &,
> so if we had struct kmem_cache instances with static storage duration, we
> would be at least no worse off than we are with runtime_const variants.

But the argument for doing the static duration support is that it should be
faster, not just "not slower"? So is runtime_const equivalent or for some
fundamental reason it's slower than plain &?

Or is the advantage that static caches can support modules and runtime_const
can't?

>         There are obstacles to doing that, but they turn out to be easy
> to deal with.
> 
> 1) as it is, struct kmem_cache is opaque for anything outside of a few
> files in mm/*; that avoids serious headache with header dependencies,
> etc., and it's not something we want to lose.  Solution: struct
> kmem_cache_opaque, with the size and alignment identical to struct
> kmem_cache.  Calculation of size and alignment can be done via the same
> mechanism we use for asm-offsets.h and rq-offsets.h, with build-time
> check for mismatches.  With that done, we get an opaque type defined in
> linux/slab-static.h that can be used for declaring those caches.
> In linux/slab.h we add a forward declaration of kmem_cache_opaque +
> helper (to_kmem_cache()) converting a pointer to kmem_cache_opaque
> into pointer to kmem_cache.
> 
> 2) real constructor of kmem_cache needs to be taught to deal with
> preallocated instances.  That turns out to be easy - we already pass an
> obscene amount of optional arguments via struct kmem_cache_args, so we
> can stash the pointer to preallocated instance in there.  Changes in
> mm/slab_common.c are very minor - we should not merge preallocated caches
> with anything already created, use the instance passed to us instead of
> allocating a new one and we should not free them.  That's it.
> 
> 	A set of helpers parallel to kmem_cache_create() and friends
> (kmem_cache_setup(), etc.) is provided in the same linux/slab-static.h;
> generally, conversion affects only a few lines.
> 
> 	Note that slab-static.h is needed only in places that create
> such instances; all users need only slab.h (and they can be modular,
> unlike runtime_const-based approach).
> 
> 
> 	That covers the instances that never get destroyed.  Quite a few
> fall into that category, but there's a major exception - anything in
> modules must be destroyed before the module gets removed.  Note that
> unlike runtime_constant-based approach, cache _uses_ in a module are
> fine - if kmem_cache_opaque instance is exported, its address is available
> to modules without any problems.  It's caches _created_ in a module

So are there uses in modules of caches created in built-in code, which
therefore could not be changed to runtime_const?

> that offer an extra twist.
> 
> 	Teaching kmem_cache_destroy() to skip actual freeing of given
> kmem_cache instance is trivial; the problem is that kmem_cache_destroy()
> may overlap with sysfs access to attributes of that cache.  In that
> case kmem_cache_destroy() may return before the instance gets freed -
> freeing (from slab_kmem_cache_release()) happens when the refcount of
> embedded kobject drops to zero.  That's fine, since all references
> to data structures in module's memory are already gone by the time
> kmem_cache_destroy() returns.  That, however, relies upon the struct
> kmem_cache itself not being in module's memory; getting it unmapped
> before slab_kmem_cache_release() has run needs to be avoided.
> 
> 	It's not hard to deal with, though.  We need to make sure that
> instance in a module will get to slab_kmem_cache_release() before the
> module data gets freed.  That's only a problem on sysfs setups -
> otherwise it'll definitely be finished before kmem_cache_destroy()
> returns.
> 
> 	Note that modules themselves have sysfs-exposed attributes,
> so a similar problem already exists there.  That's dealt with by
> having mod_sysfs_teardown() wait for refcount of module->mkobj.kobj
> reaching zero.  Let's make use of that - have static-duration-in-module
> kmem_cache instances grab a reference to that kobject upon setup and
> drop it in the end of slab_kmem_cache_release().
> 
> 	Let setup helpers store the kobject to be pinned in
> kmem_cache_args->owner (for preallocated; if somebody manually sets it
> for non-preallocated case, it'll be ignored).  That would be
> &THIS_MODULE->mkobj.kobj for a module and NULL in built-in.
> 
> 	If sysfs is enabled and we are dealing with preallocated instance,
> let create_cache() grab and stash that reference in kmem_cache->owner
> and let slab_kmem_cache_release() drop it instead of freeing kmem_cache
> instance.
> 
> 
> 	Costs:
> * a bit (SLAB_PREALLOCATED) is stolen from slab_flags_t
> * such caches can't be merged with anything preexisting (obviously)
> and subsequent cache creations can't merge with static-in-module
> ones.  If you want them more mergable, don't use that technics.
> * you can't do kmem_cache_setup()/kmem_cache_destroy()/kmem_cache_setup()
> on the same instance.  Just don't do that.
> 
> Al Viro (9):
>   static kmem_cache instances for core caches
>   allow static-duration kmem_cache in modules
>   VFS caches: switch from runtime_const() machinery to slab-static.h
>   make inode_cache statically allocated
>   make mnt_cache statically allocated
>   make bh_cachep statically allocated
>   make seq_file_cache statically allocated
>   make thread component caches (fs_cachep, files_cachep, etc.)
>     statically allocated
>   make ufs_inode_cache statically allocated
> 
>  Kbuild                            | 14 ++++++-
>  fs/buffer.c                       |  6 ++-
>  fs/dcache.c                       |  8 ++--
>  fs/file_table.c                   | 40 ++++++++----------
>  fs/inode.c                        |  6 ++-
>  fs/namei.c                        | 16 +++----
>  fs/namespace.c                    |  6 ++-
>  fs/seq_file.c                     |  6 ++-
>  fs/ufs/super.c                    |  9 ++--
>  include/asm-generic/vmlinux.lds.h |  6 +--
>  include/linux/fdtable.h           |  3 +-
>  include/linux/fs_struct.h         |  3 +-
>  include/linux/signal.h            |  3 +-
>  include/linux/slab-static.h       | 69 +++++++++++++++++++++++++++++++
>  include/linux/slab.h              | 11 +++++
>  kernel/fork.c                     | 37 ++++++++++-------
>  mm/kmem_cache_size.c              | 20 +++++++++
>  mm/slab.h                         |  1 +
>  mm/slab_common.c                  | 49 ++++++++++++++--------
>  mm/slub.c                         |  7 ++++
>  20 files changed, 231 insertions(+), 89 deletions(-)
>  create mode 100644 include/linux/slab-static.h
>  create mode 100644 mm/kmem_cache_size.c
> 
> --
> 2.47.3
> 
> 
> 
> Al Viro (10):
>   static kmem_cache instances for core caches: infrastructure
>   static kmem_cache instances for core caches: setup primitives
>   allow preallocated kmem_cache instances in modules
>   VFS caches: switch from runtime_const() machinery to slab-static.h
>   make inode_cache statically allocated
>   make mnt_cache statically allocated
>   make bh_cachep statically allocated
>   make seq_file_cache statically allocated
>   make thread component caches (fs_cachep, files_cachep, etc.)
>     statically allocated
>   make ufs_inode_cache statically allocated
> 
>  Kbuild                            | 14 ++++++-
>  fs/buffer.c                       |  6 ++-
>  fs/dcache.c                       |  8 ++--
>  fs/file_table.c                   | 40 ++++++++----------
>  fs/inode.c                        |  6 ++-
>  fs/namei.c                        | 16 +++----
>  fs/namespace.c                    |  6 ++-
>  fs/seq_file.c                     |  6 ++-
>  fs/ufs/super.c                    |  9 ++--
>  include/asm-generic/vmlinux.lds.h |  6 +--
>  include/linux/fdtable.h           |  3 +-
>  include/linux/fs_struct.h         |  3 +-
>  include/linux/signal.h            |  3 +-
>  include/linux/slab-static.h       | 69 +++++++++++++++++++++++++++++++
>  include/linux/slab.h              | 11 +++++
>  kernel/fork.c                     | 37 ++++++++++-------
>  mm/kmem_cache_size.c              | 20 +++++++++
>  mm/slab.h                         |  1 +
>  mm/slab_common.c                  | 50 +++++++++++++++-------
>  mm/slub.c                         | 27 +++++++-----
>  20 files changed, 242 insertions(+), 99 deletions(-)
>  create mode 100644 include/linux/slab-static.h
>  create mode 100644 mm/kmem_cache_size.c
> 


