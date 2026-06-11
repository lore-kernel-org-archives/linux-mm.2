Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276C2CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A7796B009E; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B9D26B009D; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CE786B00A2; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3FB2C6B009D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:14:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBE1916554D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:28 +0000 (UTC)
X-FDA: 84868280616.11.69EEB89
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1689820007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:14:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="RAp/YriU";
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781198067;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXwsc3pUPuy9tdbeh5fqPCJ0B/8K72avIUsW4AewIh8=;
	b=11VgRsx+INYpKsbUHZmDdvO9e7YtidpS8js8idSetx7uQ5ED0hPzwvxDfgGBikcsk/cVZu
	tDeh+0xo9BBoB16lbIA1dZaY4dc1xtv9ksVq9nDH68im7OCnn65gCaaEYo+i7SVkc7jHHt
	zm0GGcKcyAwbZjVbg28WbjmxmBmi2kY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="RAp/YriU";
	spf=none (imf13.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781198067;
	b=ITpn/mHni7IIpznbTTJr94zGehcBSafNmNbQxn+zKVEsawU1HQkSmqxvJHjKX451SM2dG0
	dUxh42Vh3MuB8jlHOOgVXUm5PVcsq8DZD5a0sNO/lHt6p4XrLMPX1rTXO6lPECTcuh4wxk
	JtixwSyvagW0Oc+fBzTKKGhGonuc7+E=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cXwsc3pUPuy9tdbeh5fqPCJ0B/8K72avIUsW4AewIh8=; b=RAp/YriUSB1I3QFnHLYDDA+fPg
	6Jc7Q0OsVpBqgY/CXrTkXpYIicVA7A4Eaz7L6luYvaHeVG1wtoqXswISFNfhnYi4sUXVOZCiJVhAK
	8iuUiLjQuLlEUVStDep2rDsKZq2f6hwgjyK70tB1LcmXOIWe0Y+/Qw1yxj1Hzkb8G3FCEDrKwLGrD
	HWsBtzB83VrqSxfWxfvwgzwe1D0UPqY1AqLpRCfMHVcHBkBrvX4GPYSuyUTh1zj3k7/9JbFRMUhhR
	kK6lPT7WQcYMtu95kbcwXFVUE5I5ySwjOJ9YJQdxvNcvsHNCQpXQaIYsmc8J1n91SBx98sWQMLlfF
	VApM+pfA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXiz3-000000070lt-0M82;
	Thu, 11 Jun 2026 17:14:25 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/9] kmem_cache instances with static storage duration
Date: Thu, 11 Jun 2026 18:14:15 +0100
Message-ID: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171309.GN2636677@ZenIV>
References: <20260611171309.GN2636677@ZenIV>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1689820007
X-Stat-Signature: qbni41mex1ajc94ifg8bkdnyhiz45x7h
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781198066-768193
X-HE-Meta: U2FsdGVkX1+XdfessgGoXJdfM//YlfVGpXzJGcn6LNuH8nrc7yBPc8onTaAtTK1c4t7lkpy2FnVgXXsbjxBPtuRObBOWcEjRU+yf+MC0FqHK56i1bDdtniLfDDgO9pFMY2jhCp9pWrRpEsDZrPOptGLqYZkN39Nc8OAa4qkAUcm/lcsmRlkqNwjJAgiAXlkgnbFzhGxdHyk0vlzKSk8ADjODzA9+4ZNxsKaQ0esd5Sma4FHam2qN0dnLs1vpgSTycoqEIOP3Z6v2ztK2YDOM/DoE9IgNERerHrx6WVVf0KdSCiv0SOehlfGYIZdF8D1wTJwVnY+vLDede1Dkz257PKPYWhQRw5m8BWuul4lKFQwtXK1rYix4c3kiN4uY6lw36ODvEcP/yMUriRMA1FqFPvpOhGa084qIVtjdofOt3l+KKe7Cd0+ueqkQdbGhkMgER4HFFKMOkMkYmHyb5dbmQwZwW0rvfbP1/f9/vwOFuCE3j3072q9Ot8xUoREUZ8/s40x/SoDok7in+4oycaUHqCtfora6WnsWKqJn9NVeVmmBz34suvMCMk0ONz37heciMwEyxzflK6N2WzoVBNqO0Ixi+JrnOupxLIvGJvIxLx8U4j35cVA6Zb+VujgKFlDT9wvXhAglWbGKCt/lWm6bDqwy3Lnskx3IErTkycttCtiJGmqqvN5TTOAJElLADzob6BVqEMbvztC4oG8ow6UUDdlSZITl+V754y5f6tqdl2QAp07T170VTe8r+vX+Tqr0FsB0b2A8WQb4zdCGPHFFFszBmPEwP4GAoaICwMMtl7hPH78XdMYvyuFlCG1BnTzzIXwlscOlKyecoVfrqMHiAX7tmBta3C9ly/bj7EENNQI2sBtDzC7BbGE+spTMjbL1O1DCvQwSzqOUERISKXSJIFM76EKiqbuYdPudTbVbEidKDxmwfgs1dOn9/p6zGTiDr1/jFoYkLDfkeATyvyH
 lapj6uFW
 6WpYQM94XBSlscY9TKFTbAN+nhbZ67xSmmIAKTo/tzeGDQXg4JEOT4E8ZmQlNEKEY8r4jFk9mJZcuyNe3sHFMq0VmVf3LuRfNdc7QJvEdzPFnT8mzldg3M6fDEDLl3d2qVCbibISbVD8MiJzrGCmD3lwnJq+ll5huXIe/C23DGkAAwXB8MNJ4zkQixpnkdANih2rC0U9aCQJKnMcrBhJchYJTkzJ9HnW50cKmCK0EZ5CX0Z3V9fpG1zZg622thrxImJRk5+BeZ/+IX2IWST2hVBweg+K83z5rEYC1qp1uzyku1Bj4K4NnIBrc0KND+634obX0lvwTiI6H04aJZ8HxCpt2Vu1zpMkLDNUnLVbMkeirEvzPr+wc7ORbcU6dz+RnTH1ftJQJmOiamVXu4M0PBQjojSe1TqQN6+ikrzJwRyCUp3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes since v1:
	* milder restrictions on mergability (non-modular static cache
can be used as alias for later dynamic ones)
	* consolidated conversions into fewer commits
	* rebased to 7.1-rc6.
Branch lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.kmem_cache_static
individual patches in followups.

Please, review.

        kmem_cache_create() and friends create new instances of
struct kmem_cache and return pointers to those.  Quite a few things in
core kernel are allocated from such caches; each allocation involves
dereferencing an assign-once pointer and for sufficiently hot ones that
dereferencing does show in profiles.

        There had been patches floating around switching some of those
to runtime_const infrastructure.  Unfortunately, it's arch-specific
and most of the architectures lack it.

        There's an alternative approach applicable at least to the caches
that are never destroyed, which covers a lot of them.  No matter what,
runtime_const for pointers is not going to be faster than plain &,
so if we had struct kmem_cache instances with static storage duration, we
would be at least no worse off than we are with runtime_const variants.

        There are obstacles to doing that, but they turn out to be easy
to deal with.

1) as it is, struct kmem_cache is opaque for anything outside of a few
files in mm/*; that avoids serious headache with header dependencies,
etc., and it's not something we want to lose.  Solution: struct
kmem_cache_opaque, with the size and alignment identical to struct
kmem_cache.  Calculation of size and alignment can be done via the same
mechanism we use for asm-offsets.h and rq-offsets.h, with build-time
check for mismatches.  With that done, we get an opaque type defined in
linux/slab-static.h that can be used for declaring those caches.
In linux/slab.h we add a forward declaration of kmem_cache_opaque +
helper (to_kmem_cache()) converting a pointer to kmem_cache_opaque
into pointer to kmem_cache.

2) real constructor of kmem_cache needs to be taught to deal with
preallocated instances.  That turns out to be easy - we already pass an
obscene amount of optional arguments via struct kmem_cache_args, so we
can stash the pointer to preallocated instance in there.  Changes in
mm/slab_common.c are very minor - we should not merge preallocated caches
with anything already created, use the instance passed to us instead of
allocating a new one and we should not free them.  That's it.

	A set of helpers parallel to kmem_cache_create() and friends
(kmem_cache_setup(), etc.) is provided in the same linux/slab-static.h;
generally, conversion affects only a few lines.

	Note that slab-static.h is needed only in places that create
such instances; all users need only slab.h (and they can be modular,
unlike runtime_const-based approach).


	That covers the instances that never get destroyed.  Quite a few
fall into that category, but there's a major exception - anything in
modules must be destroyed before the module gets removed.  Note that
unlike runtime_constant-based approach, cache _uses_ in a module are
fine - if kmem_cache_opaque instance is exported, its address is available
to modules without any problems.  It's caches _created_ in a module
that offer an extra twist.

	Teaching kmem_cache_destroy() to skip actual freeing of given
kmem_cache instance is trivial; the problem is that kmem_cache_destroy()
may overlap with sysfs access to attributes of that cache.  In that
case kmem_cache_destroy() may return before the instance gets freed -
freeing (from slab_kmem_cache_release()) happens when the refcount of
embedded kobject drops to zero.  That's fine, since all references
to data structures in module's memory are already gone by the time
kmem_cache_destroy() returns.  That, however, relies upon the struct
kmem_cache itself not being in module's memory; getting it unmapped
before slab_kmem_cache_release() has run needs to be avoided.

	It's not hard to deal with, though.  We need to make sure that
instance in a module will get to slab_kmem_cache_release() before the
module data gets freed.  That's only a problem on sysfs setups -
otherwise it'll definitely be finished before kmem_cache_destroy()
returns.

	Note that modules themselves have sysfs-exposed attributes,
so a similar problem already exists there.  That's dealt with by
having mod_sysfs_teardown() wait for refcount of module->mkobj.kobj
reaching zero.  Let's make use of that - have static-duration-in-module
kmem_cache instances grab a reference to that kobject upon setup and
drop it in the end of slab_kmem_cache_release().

	Let setup helpers store the kobject to be pinned in
kmem_cache_args->owner (for preallocated; if somebody manually sets it
for non-preallocated case, it'll be ignored).  That would be
&THIS_MODULE->mkobj.kobj for a module and NULL in built-in.

	If sysfs is enabled and we are dealing with preallocated instance,
let create_cache() grab and stash that reference in kmem_cache->owner
and let slab_kmem_cache_release() drop it instead of freeing kmem_cache
instance.


	Costs:
* a bit (SLAB_PREALLOCATED) is stolen from slab_flags_t
* such caches can't be merged with anything preexisting (obviously)
and subsequent cache creations can't merge with static-in-module
ones.  If you want them more mergable, don't use that technics.
* you can't do kmem_cache_setup()/kmem_cache_destroy()/kmem_cache_setup()
on the same instance.  Just don't do that.

Al Viro (9):
  static kmem_cache instances for core caches
  allow static-duration kmem_cache in modules
  VFS caches: switch from runtime_const() machinery to slab-static.h
  make inode_cache statically allocated
  make mnt_cache statically allocated
  make bh_cachep statically allocated
  make seq_file_cache statically allocated
  make thread component caches (fs_cachep, files_cachep, etc.)
    statically allocated
  make ufs_inode_cache statically allocated

 Kbuild                            | 14 ++++++-
 fs/buffer.c                       |  6 ++-
 fs/dcache.c                       |  8 ++--
 fs/file_table.c                   | 40 ++++++++----------
 fs/inode.c                        |  6 ++-
 fs/namei.c                        | 16 +++----
 fs/namespace.c                    |  6 ++-
 fs/seq_file.c                     |  6 ++-
 fs/ufs/super.c                    |  9 ++--
 include/asm-generic/vmlinux.lds.h |  6 +--
 include/linux/fdtable.h           |  3 +-
 include/linux/fs_struct.h         |  3 +-
 include/linux/signal.h            |  3 +-
 include/linux/slab-static.h       | 69 +++++++++++++++++++++++++++++++
 include/linux/slab.h              | 11 +++++
 kernel/fork.c                     | 37 ++++++++++-------
 mm/kmem_cache_size.c              | 20 +++++++++
 mm/slab.h                         |  1 +
 mm/slab_common.c                  | 49 ++++++++++++++--------
 mm/slub.c                         |  7 ++++
 20 files changed, 231 insertions(+), 89 deletions(-)
 create mode 100644 include/linux/slab-static.h
 create mode 100644 mm/kmem_cache_size.c

-- 
2.47.3


