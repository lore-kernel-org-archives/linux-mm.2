Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70370D277D0
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F8576B0093; Fri,  9 Jan 2026 23:01:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 133116B00A4; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCE836B0089; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC6C6B009F
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:01:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3172D13539B
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:02 +0000 (UTC)
X-FDA: 84314703564.23.211A894
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id 52D9C40010
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:01:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=A02pHIap;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768017660; a=rsa-sha256;
	cv=none;
	b=vxdtiuts3Tr9aQJX303SFoI8uFuRJM56oXRqDbAb6B8qNbcwMxBTHSZWZjli/b4TEV4r7u
	SC+pBmbZ8r1cbzj25mCab4HzFchEtxH27yzhxsjmwYpliWLG4ArAel4IaMVV6mKwX2Gvk5
	MWgGGUjOlUUh+avSRvZfsOeco+dmBK4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=A02pHIap;
	spf=none (imf07.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768017660;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SAMItpZq/8UWwpFL77MgX7nTOQ8V2DCdFRU+BfI9C6U=;
	b=hPfsynRduPD+l6HQRXDPJqDjTRx9mzKnw8DSC+oQa1v24hgx2vH8WKAKHVHaLd3NzU1vy8
	abIxr7QOnVmmYN7sx/yqya4mRiM2VWWnJZamwf4eiy8NqD/RUFYs7Dc7wO3btjPehZoL4H
	hRAmdMMto2+dF5rDLFg60KTYL58Re9Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SAMItpZq/8UWwpFL77MgX7nTOQ8V2DCdFRU+BfI9C6U=; b=A02pHIapz+/ZRHrStmehokVOoO
	VrM1ZLnvCP3Q2kmEX3nK3l1OP3VQ1WxkbQGHjtUPpyriiZ7wcoMt1lytyeKMIINPNAiwWGWoTmiWj
	dw4AL7A6B14n03dfwWtkawM8nT6XYOHGgEUfxDhyWg/xrhEpXMZqCsYsNgADDRGtUSKyd7BSm60JY
	Sfq2WNTWQ+il7s9LXlyLT/K5fh8/WDuC2tMPXoVIuO2lZCg6FgGy6FvGvNdPuOSsyLUq4NJM3sJg/
	BHX+G73hbNfZecrdNUSrjMu5/13gf0SPfH5JtUJ4Nbjh4pZ9oaOww9w1e0VzKCAyogDcK5GZPRyVz
	hlbGvAyA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1veQB7-000000085Yf-1opA;
	Sat, 10 Jan 2026 04:02:17 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 00/15] kmem_cache instances with static storage duration
Date: Sat, 10 Jan 2026 04:02:02 +0000
Message-ID: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 52D9C40010
X-Stat-Signature: x998rw3pzyb4ztutbicj3pbka7qsfe1g
X-Rspam-User: 
X-HE-Tag: 1768017660-873184
X-HE-Meta: U2FsdGVkX1/V9n33nNnyZA0dRnlPo2GSOs39SEbpTENwBimyGD4iWA+mKKn3JIIQYKJRYo1mlTRrQNBOOlMS+r7M9+X4hj+MMesCpuOTc4rMBia0x1BlUWl6N+bYy5LWVZZ6MyJ9e/UASwKKdzCn/Ei7L0zBObiiandmgUHwSTqDQCsOxjjCMsZsjPg6v3jBwkkIX/qfo7+L0CHLolTlXRoqCBi1fTVUTEDBU+B9pHPBZ2pRvZ0YO2ZH6CS/6jqnfpe/ZCBiAtiGTodNbIpsr7b6YYQtTsI93ysGJTn5Hzvg6T6fH5rD2CnzxEsOm4tXX/eVjX7rWgeJsEdrxhaLlN69wY/AQB6XBexNyvYhGoUg/6zTSUEuRz+4qv9x/zCpdm73q7bAfzA2b214zIf4wfwz4Pddnv/Xv3LHpdX6yGt/xhHeMEuM5pH6w+1b5WW02CKALr+/lk3juxz1xUA8BeLFks0JiQFd+eIoq8nsvSVK/fzqpJGWdNzBZcuhAJUF5GBrrnFOhOuLYcGkrIDumkekI39l6aPrRJJ5Qqjgsf/gZZiHclQI6a548pKVyc1UnjgqlZrPAI+99YjRU5rj51RGBQ3GkNuAcdcdPBjnWJOOL8Vb/rMDhfMQeArEX5kcoxAVi2ofEwdmSnTLn99sb31620fF1cRb7lqsg4nf/yv7bf3jx+Qx7FR06LlEpWvuwS+CDs3EhfxEe2IxT2ztkM3CBx5LT8jMs6lHIS4bbtMSB4RrPXn8MxeT1K2hiSPYx52kPLtai8cKSw79UQoNB+BNzqq7xkNN/daoaQdvF2znJ1UN/avTYYY4mQ/xq86ZaG5DMqD8JUp3nN6sGQ1sH/mikKR/fSoEMxubgaukt4rs2n4w25m2Y+uIAl7gekgNeTAk7LroHSWElABZ7nr5LDrz6/7/O2QtLllEsnAGjNoRpOTNtKvl6gowxaQlqS0aEYC0QfvF8JghgLCK9PG
 F/mhprVy
 u0vjI78kw1XUdG43tFhSPjOk+FrzO/bHcuhVq9uT5sxCVMfudzmAWcLpJlZNjchWc7nYzhzvq7WxIbZB4B8dstBMdDKbDl3ro3Lgtz73fyGuviIuvvrygPvhRZV4E5MU3PSXVoH4kbNAjv2sce9m587clfmp8tZKaEx9j3K0vccTlzij4cFytnwQo8TXq8ru+KHR4M5pFHGO1MtpRCv0tXaUqeMSoYFKxsKwoeWApsvotSaC2xEXWZgbhDyoUl3D0/SddVo6PH2nM8R3VJLQrW1KKG3TEqFGtmyzl8GcpzNblZwlrZBnm7Fpp+QTljcKPTQEpR61mdwfnghHsACEUVAeAOavak10ennoWXeiVJLKrHMbKa0229OauAbs5HJsUc8RVuPQUQtL3+CmiLX9JsgEv9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
mm/slab_common.c are very minor - we should treat preallocated caches
as unmergable, use the instance passed to us instead of allocating a
new one and we should not free them.  That's it.

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

	Let setup helpers store the kobjetct to be pinned in
kmem_cache_args->owner (for preallocated; if somebody manually sets it
for non-preallocated case, it'll be ignored).  That would be
&THIS_MODULE->mkobj.kobj for a module and NULL in built-in.

	If sysfs is enabled and we are dealing with preallocated instance,
let create_cache() grab and stash that reference in kmem_cache->owner
and let slab_kmem_cache_release() drop it instead of freeing kmem_cache
instance.


	Costs:
* a bit (SLAB_PREALLOCATED) is stolen from slab_flags_t
* such caches can't be merged.  If you want them mergable, don't use that
technics.
* you can't do kmem_cache_setup()/kmem_cache_destroy()/kmem_cache_setup()
on the same instance.  Just don't do that.

Al Viro (15):
  static kmem_cache instances for core caches
  allow static-duration kmem_cache in modules
  make mnt_cache static-duration
  turn thread_cache static-duration
  turn signal_cache static-duration
  turn bh_cachep static-duration
  turn dentry_cache static-duration
  turn files_cachep static-duration
  make filp and bfilp caches static-duration
  turn sighand_cache static-duration
  turn mm_cachep static-duration
  turn task_struct_cachep static-duration
  turn fs_cachep static-duration
  turn inode_cachep static-duration
  turn ufs_inode_cache static-duration

 Kbuild                            | 13 +++++-
 fs/buffer.c                       |  6 ++-
 fs/dcache.c                       |  8 ++--
 fs/file_table.c                   | 32 +++++++-------
 fs/inode.c                        |  6 ++-
 fs/namespace.c                    |  6 ++-
 fs/ufs/super.c                    |  9 ++--
 include/asm-generic/vmlinux.lds.h |  3 +-
 include/linux/fdtable.h           |  3 +-
 include/linux/fs_struct.h         |  3 +-
 include/linux/signal.h            |  3 +-
 include/linux/slab-static.h       | 69 +++++++++++++++++++++++++++++++
 include/linux/slab.h              | 11 +++++
 kernel/fork.c                     | 37 ++++++++++-------
 mm/kmem_cache_size.c              | 20 +++++++++
 mm/slab.h                         |  1 +
 mm/slab_common.c                  | 44 +++++++++++++-------
 mm/slub.c                         |  7 ++++
 18 files changed, 214 insertions(+), 67 deletions(-)
 create mode 100644 include/linux/slab-static.h
 create mode 100644 mm/kmem_cache_size.c

-- 
2.47.3


