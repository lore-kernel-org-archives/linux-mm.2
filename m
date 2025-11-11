Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2046FCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 08:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A60C8E000D; Tue, 11 Nov 2025 03:01:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 756468E0002; Tue, 11 Nov 2025 03:01:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6456F8E000D; Tue, 11 Nov 2025 03:01:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5184F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:01:36 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB21F59122
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:01:35 +0000 (UTC)
X-FDA: 84097581750.10.82FD074
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id DC16D140015
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 08:01:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="g/CU5/uH";
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762848094;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=leW8GA4y7Pxp64vNo8XjzZTbPYZFOmxFXD/3OiiHgBc=;
	b=LHZSDiQKz8tRy2enD0XabQcMLXqo4KuBjy96SACNz9oXX+fB+yY8qJqXQ2VGMuD4S1DhOT
	+z1bhU8zYptCdUNDiT5f83YKlpECuBsYvV/7iTlc3tEj/nXY5k1+ro+ajTbsulvgIE7t5F
	fhCBiR5LyvAE9l2ORYuqOJn7Lp66NE0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b="g/CU5/uH";
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762848094; a=rsa-sha256;
	cv=none;
	b=IQ2U86bcSsZKeHwqLroCNdS7txr1YB2+3DCwfI09ZqMxpAbZgfb9/UWzfOMFfFTJT1vzFd
	kT9EBEU/KpSl93mV08h99ILnbwdqrEl20IH6FaxLtXABMrJRLS4AxjbgcQUyi2nzBqFjJn
	BSgmK4Bi9NbChinOYB+mhV274DMHC5g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=leW8GA4y7Pxp64vNo8XjzZTbPYZFOmxFXD/3OiiHgBc=; b=g/CU5/uH4HMjhxdKjr30ByWuse
	rR0MjDbFLTtzuzJzfLZ6mL3bQtXs39KLmW5eMtB8fy2iJ+Ek/cufD5MhxJm9nmL6JE35GYmhCA0zJ
	MGohTr1R34wWNYPCSJynjsoDjcufcWoEdaxIZ3UR5jUz2YHCTlD/7fJk+wJjbGrMzS/nf2oSco7rb
	nXsNbo1V1rcCz/TKMwiqhPOeGfzkyF9yi5zQ8niVbVkYrZRsjK122F/JpFHx9/AVSZgDLA1/deZ+f
	QYljuYONnRgAnVNuv67jjtz+ZF7RHbe/g8d4Ku2qpM3uvXthA0cXcCWtgxeXvvfintzgotKgCvsIJ
	SEVTFaKw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vIiHg-0000000BwrA-3Mp4;
	Tue, 11 Nov 2025 06:55:21 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: torvalds@linux-foundation.org,
	brauner@kernel.org,
	jack@suse.cz,
	raven@themaw.net,
	miklos@szeredi.hu,
	neil@brown.name,
	a.hindborg@kernel.org,
	linux-mm@kvack.org,
	linux-efi@vger.kernel.org,
	ocfs2-devel@lists.linux.dev,
	kees@kernel.org,
	rostedt@goodmis.org,
	gregkh@linuxfoundation.org,
	linux-usb@vger.kernel.org,
	paul@paul-moore.com,
	casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org,
	john.johansen@canonical.com,
	selinux@vger.kernel.org,
	borntraeger@linux.ibm.com,
	bpf@vger.kernel.org
Subject: [PATCH v3 00/50] tree-in-dcache stuff
Date: Tue, 11 Nov 2025 06:54:29 +0000
Message-ID: <20251111065520.2847791-1-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DC16D140015
X-Stat-Signature: xuk68ebnn84caaaetujbh5kfdwmw7wz1
X-Rspam-User: 
X-HE-Tag: 1762848093-457778
X-HE-Meta: U2FsdGVkX1/1ID2EbCTB8Iw7ex4YOv3HNytJ79fWw0cHlBc10JmMQSyo6IaITmucW56E5/qDxtt0Cs5395gD5GX+wtXTW+AZU3Oa9IQaUxjewYChkmQeggvfNQW/bK5MSzejpCdMdXFepqofP5eoahh9ZebQ8JtV199IMhvtAm1FnChNMZYdXwxNlHY/whFWH42HWdP5fcn27Q2Y8nQX/EGHohdm6sSkHUJAADigG+bnsWdKrcc3x0Sdgd0DaNIjwnXB3GTiyZExA0TqOn7AalAI8Rp8HArg4Y8ZOf4NMWoZ1r1Dr88j85OSK0u3YbRr1vNZVlgqE627ljHgcLX9S7bR9W1Xe/5B4/0klCMxvPTib5Z3WdPKzE0p04HRTQ/4Zw8GetWX9yLxL254YPJ3o/N5gG3rR7/6OqGDoRUVjNHTSRZPU9/FMqj/AHn+51RHsfIMY/uxl9PRENR6UwrXhN2imeO7RNu4dxY7rdnIWp5+3Jyx4e4QjKURSwCqXN3/II+mdTkPk1d3muSIQ1YApUOwl0ZK5ylsaxzeLrfWoH9+ooVJHd37+zw8+clIO7seDWpre/5OV9VyopAOTzfjIC96UJGoAT8FZbjpOeJpIbAnBazN3hKU4YfGp3eJrRAJb+gnTH87H/sOSbTaBcVrf98E83a3f2+pYHm7e6JJaoPsC7N9+MsizbB1Wt9rMbmB0NKZMnnFDA02CREMWBfNMLJa7xYVOcoD7xXkTcMzkKTqERf+o5mZbHThwBJZ6dJZcksf6VteSXyMZ1cICXMnp9ybiVQl1uGO6DOk94Tu4WzgIxGFCCBGKzPEXzOSJ90AkAv8Iun/E0wNbmSaoj322Xf2kkICSVbGgfdKeBmRefjdFkn/o7b64n0LsDXZLaiDGGX6OCxBAOCcKo4xi2Hv306a95kpmoWVsF4BHiLKtHgwRBuU70lsid0uqmtmXB9jO8O0/9GwfTv0trPjaQb
 sJkFobZ7
 W3f/n40OAdeDQJn1NWqpLENeBb9gV2Vrx3ggl6g4gLnTOclQxaFmY1EqSjOYAdhU6aaynFYs2z+ghWyRdX2vPY97fIpznfTGNiMZNs7sPlIzVE4msThBBuhRV+7EaJdvgZDmX1WK6lMC94tWSGAMniqisnDrX6QdrplNjJI8stHEJW3GN3NFlQ1pPtX3k2VzdJmYC9RH3UbnnWcNlU7jh6mAL2JOkf+YI4lsCDjx8DNdpykBJY+IyOE++lJCRQ/aYzS7N7pG23XqOVl9S+FdqQuCG5fcZjPf5vyxHtO9cj5RhOFNePY4flcrySAtiObaputqjuf5LM129KnhLyWvR3rYYiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some filesystems use a kinda-sorta controlled dentry refcount leak to pin
dentries of created objects in dcache (and undo it when removing those).
Reference is grabbed and not released, but it's not actually _stored_
anywhere.  That works, but it's hard to follow and verify; among other
things, we have no way to tell _which_ of the increments is intended
to be an unpaired one.  Worse, on removal we need to decide whether
the reference had already been dropped, which can be non-trivial if
that removal is on umount and we need to figure out if this dentry is
pinned due to e.g. unlink() not done.  Usually that is handled by using
kill_litter_super() as ->kill_sb(), but there are open-coded special
cases of the same (consider e.g. /proc/self).

Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTENT)
marking those "leaked" dentries.  Having it set claims responsibility
for +1 in refcount.

The end result this series is aiming for:

* get these unbalanced dget() and dput() replaced with new primitives that
  would, in addition to adjusting refcount, set and clear persistency flag.
* instead of having kill_litter_super() mess with removing the remaining
  "leaked" references (e.g. for all tmpfs files that hadn't been removed
  prior to umount), have the regular shrink_dcache_for_umount() strip
  DCACHE_PERSISTENT of all dentries, dropping the corresponding
  reference if it had been set.  After that kill_litter_super() becomes
  an equivalent of kill_anon_super().

Doing that in a single step is not feasible - it would affect too many places
in too many filesystems.  It has to be split into a series.

This work has really started early in 2024; quite a few preliminary pieces
have already gone into mainline.  This chunk is finally getting to the
meat of that stuff - infrastructure and most of the conversions to it.

Some pieces are still sitting in the local branches, but the bulk of
that stuff is here.

Compared to v2:
	* 23/50: fixed a braino in spufs conversion
	* 6/50: added a placeholder comment in d_make_discardable() at
the point where it's introduced, promising a WARN_ON() in its place
in the final, along with explanations of the reasons for delay.
Comment goes away in 50/50, once WARN_ON() gets there.

The branch is -rc5-based; it lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.persistency
individual patches in followups.

Please, help with review and testing.  If nobody objects, in a few days it
goes into #for-next.

Shortlog:
      fuse_ctl_add_conn(): fix nlink breakage in case of early failure
      tracefs: fix a leak in eventfs_create_events_dir()
      new helper: simple_remove_by_name()
      new helper: simple_done_creating()
      introduce a flag for explicitly marking persistently pinned dentries
      primitives for maintaining persisitency
      convert simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
      convert ramfs and tmpfs
      procfs: make /self and /thread_self dentries persistent
      configfs, securityfs: kill_litter_super() not needed
      convert xenfs
      convert smackfs
      convert hugetlbfs
      convert mqueue
      convert bpf
      convert dlmfs
      convert fuse_ctl
      convert pstore
      convert tracefs
      convert debugfs
      debugfs: remove duplicate checks in callers of start_creating()
      convert efivarfs
      convert spufs
      convert ibmasmfs
      ibmasmfs: get rid of ibmasmfs_dir_ops
      convert devpts
      binderfs: use simple_start_creating()
      binderfs_binder_ctl_create(): kill a bogus check
      convert binderfs
      autofs_{rmdir,unlink}: dentry->d_fsdata->dentry == dentry there
      convert autofs
      convert binfmt_misc
      selinuxfs: don't stash the dentry of /policy_capabilities
      selinuxfs: new helper for attaching files to tree
      convert selinuxfs
      functionfs: switch to simple_remove_by_name()
      convert functionfs
      gadgetfs: switch to simple_remove_by_name()
      convert gadgetfs
      hypfs: don't pin dentries twice
      hypfs: switch hypfs_create_str() to returning int
      hypfs: swich hypfs_create_u64() to returning int
      convert hypfs
      convert rpc_pipefs
      convert nfsctl
      convert rust_binderfs
      get rid of kill_litter_super()
      convert securityfs
      kill securityfs_recursive_remove()
      d_make_discardable(): warn if given a non-persistent dentry

Diffstat:
 Documentation/filesystems/porting.rst     |   7 ++
 arch/powerpc/platforms/cell/spufs/inode.c |  17 ++-
 arch/s390/hypfs/hypfs.h                   |   6 +-
 arch/s390/hypfs/hypfs_diag_fs.c           |  60 ++++------
 arch/s390/hypfs/hypfs_vm_fs.c             |  21 ++--
 arch/s390/hypfs/inode.c                   |  82 +++++--------
 drivers/android/binder/rust_binderfs.c    | 121 ++++++-------------
 drivers/android/binderfs.c                |  82 +++----------
 drivers/base/devtmpfs.c                   |   2 +-
 drivers/misc/ibmasm/ibmasmfs.c            |  24 ++--
 drivers/usb/gadget/function/f_fs.c        |  54 ++++-----
 drivers/usb/gadget/legacy/inode.c         |  49 ++++----
 drivers/xen/xenfs/super.c                 |   2 +-
 fs/autofs/inode.c                         |   2 +-
 fs/autofs/root.c                          |  11 +-
 fs/binfmt_misc.c                          |  69 ++++++-----
 fs/configfs/dir.c                         |  10 +-
 fs/configfs/inode.c                       |   3 +-
 fs/configfs/mount.c                       |   2 +-
 fs/dcache.c                               | 111 +++++++++++-------
 fs/debugfs/inode.c                        |  32 ++----
 fs/devpts/inode.c                         |  57 ++++-----
 fs/efivarfs/inode.c                       |   7 +-
 fs/efivarfs/super.c                       |   5 +-
 fs/fuse/control.c                         |  38 +++---
 fs/hugetlbfs/inode.c                      |  12 +-
 fs/internal.h                             |   1 -
 fs/libfs.c                                |  52 +++++++--
 fs/nfsd/nfsctl.c                          |  18 +--
 fs/ocfs2/dlmfs/dlmfs.c                    |   8 +-
 fs/proc/base.c                            |   6 +-
 fs/proc/internal.h                        |   1 +
 fs/proc/root.c                            |  14 +--
 fs/proc/self.c                            |  10 +-
 fs/proc/thread_self.c                     |  11 +-
 fs/pstore/inode.c                         |   7 +-
 fs/ramfs/inode.c                          |   8 +-
 fs/super.c                                |   8 --
 fs/tracefs/event_inode.c                  |   7 +-
 fs/tracefs/inode.c                        |  13 +--
 include/linux/dcache.h                    |   4 +-
 include/linux/fs.h                        |   6 +-
 include/linux/proc_fs.h                   |   2 -
 include/linux/security.h                  |   2 -
 init/do_mounts.c                          |   2 +-
 ipc/mqueue.c                              |  12 +-
 kernel/bpf/inode.c                        |  15 +--
 mm/shmem.c                                |  38 ++----
 net/sunrpc/rpc_pipe.c                     |  27 ++---
 security/apparmor/apparmorfs.c            |  13 ++-
 security/inode.c                          |  35 +++---
 security/selinux/selinuxfs.c              | 185 +++++++++++++-----------------
 security/smack/smackfs.c                  |   2 +-
 53 files changed, 586 insertions(+), 807 deletions(-)

	Overview:

First two commits are bugfixes (fusectl and tracefs resp.)

[1/50] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
[2/50] tracefs: fix a leak in eventfs_create_events_dir()

Next, two commits adding a couple of useful helpers, the next three adding
the infrastructure and the rest consists of per-filesystem conversions.

[3/50] new helper: simple_remove_by_name()
[4/50] new helper: simple_done_creating()
	end_creating_path() analogue for internal object creation; unlike
end_creating_path() no mount is passed to it (or guaranteed to exist, for
that matter - it might be used during the filesystem setup, before the
superblock gets attached to any mounts).

Infrastructure:
[5/50] introduce a flag for explicitly marking persistently pinned dentries
	* introduce the new flag
	* teach shrink_dcache_for_umount() to handle it (i.e. remove
and drop refcount on anything that survives to umount with that flag
still set)
	* teach kill_litter_super() that anything with that flag does
*not* need to be unpinned.
[6/50] primitives for maintaining persisitency
	* d_make_persistent(dentry, inode) - bump refcount, mark persistent
and make hashed positive.  Return value is a borrowed reference to dentry;
it can be used until something removes persistency (at the very least,
until the parent gets unlocked, but some filesystems may have stronger
exclusion).
	* d_make_discardable() - remove persistency mark and drop reference.

NOTE: at that stage d_make_discardable() does not reject dentries not
marked persistent - it acts as if the mark been set.

Rationale: less noise in series splitup that way.  We want (and on the
next commit will get) simple_unlink() to do the right thing - remove
persistency, if it's there.  However, it's used by many filesystems.
We would have either to convert them all at once or split simple_unlink()
into "want persistent" and "don't want persistent" versions, the latter
being the old one.  In the course of the series almost all callers
would migrate to the replacement, leaving only two pathological cases
with the old one.  The same goes for simple_rmdir() (two callers left in
the end), simple_recursive_removal() (all callers gone in the end), etc.
That's a lot of noise and it's easier to start with d_make_discardable()
quietly accepting non-persistent dentries, then, in the end, add private
copies of simple_unlink() and simple_rmdir() for two weird users (configfs
and apparmorfs) and have those use dput() instead of d_make_discardable().
At that point we'd be left with all callers of d_make_discardable()
always passing persistent dentries, allowing to add a warning in it.

[7/50] convert simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
	See above re quietly accepting non-peristent dentries in
simple_unlink(), simple_rmdir(), etc.

	Converting filesystems:
[8/50] convert ramfs and tmpfs
[9/50] procfs: make /self and /thread_self dentries persistent
[10/50] configfs, securityfs: kill_litter_super() not needed
[11/50] convert xenfs
[12/50] convert smackfs
[13/50] convert hugetlbfs
[14/50] convert mqueue
[15/50] convert bpf
[16/50] convert dlmfs
[17/50] convert fuse_ctl
[18/50] convert pstore
[19/50] convert tracefs
[20/50] convert debugfs
[21/50] debugfs: remove duplicate checks in callers of start_creating()
[22/50] convert efivarfs
[23/50] convert spufs
[24/50] convert ibmasmfs
[25/50] ibmasmfs: get rid of ibmasmfs_dir_ops
[26/50] convert devpts
[27/50] binderfs: use simple_start_creating()
[28/50] binderfs_binder_ctl_create(): kill a bogus check
[29/50] convert binderfs
[30/50] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry == dentry there
[31/50] convert autofs
[32/50] convert binfmt_misc
[33/50] selinuxfs: don't stash the dentry of /policy_capabilities
[34/50] selinuxfs: new helper for attaching files to tree
[35/50] convert selinuxfs
[36/50] functionfs: switch to simple_remove_by_name()
[37/50] convert functionfs
[38/50] gadgetfs: switch to simple_remove_by_name()
[39/50] convert gadgetfs
[40/50] hypfs: don't pin dentries twice
[41/50] hypfs: switch hypfs_create_str() to returning int
[42/50] hypfs: swich hypfs_create_u64() to returning int
[43/50] convert hypfs
[44/50] convert rpc_pipefs
[45/50] convert nfsctl
[46/50] convert rust_binderfs

	... and no kill_litter_super() callers remain, so we
can take it out:
[47/50] get rid of kill_litter_super()
	
	Followups:
[48/50] convert securityfs
	That was the last remaining user of simple_recursive_removal()
that did *not* mark things persistent.  Now the only places where
d_make_discardable() is still called for dentries that are not marked
persistent are the calls of simple_{unlink,rmdir}() in configfs and
apparmorfs.

[49/50] kill securityfs_recursive_remove()
	Unused macro...

[50/50] d_make_discardable(): warn if given a non-persistent dentry

At this point there are very few call chains that might lead to
d_make_discardable() on a dentry that hadn't been made persistent:
calls of simple_unlink() and simple_rmdir() in configfs and
apparmorfs.

Both filesystems do pin (part of) their contents in dcache, but
they are currently playing very unusual games with that.  Converting
them to more usual patterns might be possible, but it's definitely
going to be a long series of changes in both cases.

For now the easiest solution is to have both stop using simple_unlink()
and simple_rmdir() - that allows to make d_make_discardable() warn
when given a non-persistent dentry.

Rather than giving them full-blown private copies (with calls of
d_make_discardable() replaced with dput()), let's pull the parts of
simple_unlink() and simple_rmdir() that deal with timestamps and link
counts into separate helpers (__simple_unlink() and __simple_rmdir()
resp.) and have those used by configfs and apparmorfs.

