Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56E06CD98CF
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 643AE6B0095; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DBC06B0005; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21A2F6B0005; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 613566B0099
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4B8A1C0D94
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.05.6A7AC6A
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id 16C6D160007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Mx/VYsiz";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=16tryG9ii6otrCnorqqyLXIII5NusEZOUuEVM/2B3qo=;
	b=EK1uBvCOUYmmvNtgde55+VoS9ocgMeYgaGrFXXAk7IijPXQNsIt+Wk1iYzxfIOcEdbjf3h
	+lBVqALL5TVcW7ELMKjwdjRWL5oQxKzGXTN0m0mOpe8EMP+cYr7U9iH3ZSrYxatgVaTEj5
	iUVU4eo/Um0fa05z3SCI+hA5Tow34gI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="Mx/VYsiz";
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=dXFJ6+afxhUC3n9tVjZODRl672U8Pj8ED/vTgxcfkI2bbwtAAmB7Vb/Rhq1CP6VjKRgv5N
	1KpYm7N9YdLugne9/K1A8R2/9SJS/rgTsozIg60IKgUI9vWA7ZjXWZlb0z8R50SRq8z6MU
	wMt612R53j4zAAJnzq6vtMfdMM2qyCs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=16tryG9ii6otrCnorqqyLXIII5NusEZOUuEVM/2B3qo=; b=Mx/VYsizZOBxAhu+W6fuzUDGL4
	yo1etp0yiWzeNWO9NiQk+eIpPad0cnIvrblmvFenNOY1LHQT8GT/rCOg7yfCBcgPrv1BkAOWHr8/W
	DqTDQArWMTlemVBlQMUPdgN/zzsnXkCTWaijV9vOXmTyV5UHYtWny2HAd9otNRp6h1n/qwnZ9ME/d
	N5lxtvlzFr6mcstkCTlIhpA9I8tlSTsQQNO9m7YobSKFG6WMdhw0OxS+vhVuUt4qs2Aq98iV/KIPd
	bSAShEthWeJPQjLHzEhNWf2dne9lGTLcEe+yiNk44DSXiXSg/HYllPROr1CpXqgLhRmbmdh3S8hcw
	NGfC+AQg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcx-00000003aSl-1oe3;
	Sat, 13 Jun 2026 05:09:51 +0000
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
Subject: [RFC PATCH v3 00/10] kmem_cache instances with static storage duration
Date: Sat, 13 Jun 2026 06:09:41 +0100
Message-ID: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 16C6D160007
X-Stat-Signature: kq8bthgkcceshhm8g8w1yqtu351bohet
X-HE-Tag: 1781327396-739495
X-HE-Meta: U2FsdGVkX18zEuJyXBs7AaaCepZzfpb9ZhzNuLSB7RZjUqOPQruSLKT8Q8x/uV+yVuux7NYvL1qDcRX5DGBhUdcEu4pNkyIjJgzT6tzrz0nUlxftIqq4mVeWmfJ9EiIanQJlxxexr7U5ZV+oUkolhbKGNJ98RTkmiR2buY4QMigh0zsoxZ595ZE4zZoceWk0ePP0Dtkx72nTAFJhskK5MkzavyRi7gA2ZtBERJZLz9Rg1bZilYXf0RGIfJXx6g9dtD8jBt6DuKhR4gCQyu2VrhtBK9Qa9yit2z3c7KxtXG9LIc26jrLs54uFG+d8lnvxPGCS65AtdXQnOsuWGyuA0qH++U8Zr8kOFF1ilD89mBPi1uVSVFswFCEsaVm7thJWZjNd6PwUW6Fok8VI92ioznEaUBs++XJ4jXyLQYls0fpQfPrGXsp46t2Qrs4u094D6ifxH2BsckzZw4N5ZVri6OXsrAAkZcDI3kovSOFVSc7egjTckB9aRWo4h83GDg0PiiulUgfqh/D3Gu9JL5akGnVa2csTzaj5ta4Ib99iY+WmB6geBhLh2IBK6TM/RVMwKQfZbs9dROGKXqzxtWJxp3i31tqd7VlmNfWJC4G23yLrgOOzs7g90poj7Zuw2pqU189SwyYR9sR5KrjqyySIRLGOmd0TRc8HjUz9v8F2HhH1fhosgoE8NELGRbcIeuDLp0OsXPlhyzTtxdKx0pij1oLhkDsH67DEYL6G2bAbc/M+M7+zA7zqJ/xUBcL1EfSP0QmGQI8zBDt37iDLPkcKMEXh+i7YHcZ6cqfDitcNSHpunuvuy6w+C+aM2gK1oP6uzKkQ19SMj9imLZTd4Zzs/VP1ij9DcNo+LqioHnrPCvUGARJ0hAcwzCH1jkeTj2cTt7HReWpByP9ZXJ19FQMQUTSODie0E3sG6X/jLuM1HOKdHBvcfg38FfiZxLd8ZD4Kxiv5VIsftqCva/ucOvx
 AugL20kc
 Px0d1Hxd1P5Zr7EVfE7mAO2E8M/qK9PfKCjrsvWuFnt7Jylqn5ubWRIeH7Rp3OMP5kgbGn+XQBbLDIao2Dc9RmoIJ4XO5A+yVlutojzBOBwVqLJYmKFga2SleewW53j0EMMfeaMfKbclqQk3Y7TAQ0NsbA1VfFIhFP4onyIjp0UGkXkgHyhPDY3+p050O34DHE7RgUiAbkLiv2351/2okNd9aAQSwEo7mTrm5BIW5AIb7qVqh/fMBALDkSym8TXh8U7fa5OZzwgu+w7azrLD+1Uv5gxFqzyOKLuNqpQATmi5GyGqjKjQ7CJv1eFzgk7VtwIZLu8hEOvEy4lMKb9s0H3+J+lHqArsh01rn9K0EP2HHKjHKgc/siv+HofGwGwLdCA3JAZcIsO90B0luXndTTHPn/PQ7zad++16kKQtMAV7MpcU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes since v2:
	* fixed the braindamage in /sys/kernel/slab (any statically allocated
caches should just use their name for subdirectory, whether they are mergable
or not)
	* infrastructure bits slightly reordered and carved in hopefully saner
way.
	* rebased to 7.1-rc7.

Changes since v1:
	* milder restrictions on mergability (non-modular static cache
can be used as alias for later dynamic ones)
	* consolidated conversions into fewer commits
	* rebased to 7.1-rc6.

Branch lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.kmem_cache_static
individual patches in followups.

Please, review.  It appears to work; the impact on merging is very small -
on the testbox here (251 distinct aliases) mainline gets 140 kmem_cache
instances and this series gets 142 - fs_cachep and names_cache get split
from the group of 192-byte caches.  Considering the contents and use patterns
for those two... we might be better off that way, actually.

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



Al Viro (10):
  static kmem_cache instances for core caches: infrastructure
  static kmem_cache instances for core caches: setup primitives
  allow preallocated kmem_cache instances in modules
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
 mm/slab_common.c                  | 50 +++++++++++++++-------
 mm/slub.c                         | 27 +++++++-----
 20 files changed, 242 insertions(+), 99 deletions(-)
 create mode 100644 include/linux/slab-static.h
 create mode 100644 mm/kmem_cache_size.c

-- 
2.47.3


