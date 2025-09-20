Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B86BCAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 07:42:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BEB08E0005; Sat, 20 Sep 2025 03:42:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7963E8E0001; Sat, 20 Sep 2025 03:42:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D2AD8E0005; Sat, 20 Sep 2025 03:42:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 551298E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:42:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D83115BC94
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:42:08 +0000 (UTC)
X-FDA: 83908835136.30.203E96C
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf29.hostedemail.com (Postfix) with ESMTP id ECC34120008
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 07:42:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=VdNrb6s7;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758354127;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oOCcbpCsT+zvuGsYMYIhlU7EGFEAzg77GcV6TXrg+wI=;
	b=F3JFuN66AU3OT6nrgM0R1hATsNpQRQnNzUk5D1v/DWkrHn/htcGgVdfGQC93DdCA3hq7ne
	qj/toDhdSEayEOhrcju+eJhmvi9/sudV3qtXKqVb1DmSBs0vovMAfZJwhiJft51lfwuFYJ
	pmf9rKDmsyFFT1He0Pv6U0jgmTOIZzU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758354127; a=rsa-sha256;
	cv=none;
	b=w3c8Qz7ks/rtYIRdSkKvizaKJeo4Bgn5M3KOC0AMY3+ibPdufMjhvFRriWZYkluWv8rXr/
	LhTdkr/wdRZ4/O26S2psG56GYSGdb4KC2PAsh2CGq1TAt6Yw9fOEZM8zVOIbKW6vyF2Sr4
	v2QP0wR63RZoZxt1RvgyYKQOkT9vqmw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=VdNrb6s7;
	spf=none (imf29.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Description:Content-Type:
	MIME-Version:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:In-Reply-To:References;
	bh=oOCcbpCsT+zvuGsYMYIhlU7EGFEAzg77GcV6TXrg+wI=; b=VdNrb6s7Ppzquet+fhlCfW7h+O
	U02VJRZD01jqmmWq8luID9ZxhvGVspUTY4nW/p8P6sydj6Fh/zdOxwlaySXBB2o8ahurxu8m3/ZBq
	bg/bnm5KYL9Pe7gXJDeBPNWwS6t00mVZfB9upTq6q1l9AAEuvMS/3se6NUNTC2v1b96pRaz32ogAB
	IZjAmCZrj2r2JFuJznwECCDmp7ubClVul7WeFcbIJOo983wNLuGkwdTeAIPXqQWnQwLvqtlx4O/sb
	AVqVl+vJtVbzTxrgkAWWDpl7EQYGAK9TNIGABimVcXzMRVynmmmX5N9Gzbv0/5Y1DH2CzzML2Cfvk
	fzPQ7s5A==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzsEG-0000000Euuv-3pwa;
	Sat, 20 Sep 2025 07:41:57 +0000
Date: Sat, 20 Sep 2025 08:41:56 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	Kees Cook <kees@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linuxppc-dev@lists.ozlabs.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: [PATCHES][RFC] the meat of tree-in-dcache series
Message-ID: <20250920074156.GK39973@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Description: reas Hindborg <a.hindborg@kernel.org>, linux-mm@kvack.org, linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, Kees Cook <kees@
Content-Disposition: inline
X-Stat-Signature: qxz38h456ozzua5ry7ze4yfg9xqwiu8o
X-Rspam-User: 
X-Rspamd-Queue-Id: ECC34120008
X-Rspamd-Server: rspam10
X-HE-Tag: 1758354126-206015
X-HE-Meta: U2FsdGVkX1+7qbeZ80yE/sKcp5/gzHPDiKT6Qv03DxkAAzuq7JXzJWQybgWDgS4UWQlK6qR/Snjr+vsGuGhFAmsvXNdu4jia/V5FXO3UYMQTCNJMa0Bn7p9V2BE/2B8b4w3vry/yQnlIBJiFwdRJMBapG25fxSYIgBigvl/gnh+DhQFltkmxq606dMN9NrdoVcJxnGdtDnSNGzgzqSidPsXL1lwkJtUEdw6tygSS3Xwp+Q6nTYwT+DiIiOlRJB5wYL9xm+gMho5IoUlvJbMR0kGnD0IZYdfaKP53fOGlE9zaFqSBACg7B+U7fCYDqT07a4QoWrUgXHWTULTKlquFOzSlqrw3S84e8knXSqlcoqwlZWdorgWi4xXKVx7Xgxp0zjyZo7Ss0el93N/rKJcbpk/0SAmoSRnRBKMRmLMPtf8KtD8c4Ht/wLcwCtAs8n0boEWg7uPiOCLUpm37Ce9XPjalZ3EwaxouuUPCXlXyk439RNMGQEG7LFQuEp8JfwIXVDSUDLdbNprmh3yoa4GMZU6y7oH7U8r1uE+jdyJANnG/DNb2JQF+kzda7lz0j/BUvmoHH05TnMHrxXZ2qXP47vaKbp872lQnVFVVwxHpUdi39hbwPHShF5B9vOA8XkoHjdwEsvLJbztwG7rGn6rcr0htiXM7zninLCDrzCVQWSj8x9FLQsfuKpoiPmTsivM3NXD9n3iPrqgMe/rLGYNM+20tyA7H6lpmp8Dmcf1p8NxYmgV5euRQnccT0lUdMY7ycaLCSa6v1w1IWL31aKQDuzPURGCB2ZNSl4b+BHtzxYvbNmTJxivUetOttCb4TGxJwKcpshWH/uTqVj0ScroveD+L2jGJr9G2EL2WwnNDJkEuD/JnXAmcqgBOJrjHVYPaRjgaqsxepU1HgRZwD7wWglyp6lbWqz/ihlLN3TK67XeaRNA/+vV9CvDza9jCqGgOc+PpIoXEtYq5xbf/xnm
 lfsFLYhy
 ZglCXrQ0rnruxSz5joIG5QKAGJb6yTXLDGNJEexeI0BV9YngfrxRW+baMXnAll0j5+lVwvJLWwXjEs2zWbtHOto0epSaor6BU+lRqAKuwmM0ITlXknM5t8+TGdUf8jyMQh89YbUh9UEUt0v54IrMiokXBUe5SUNjXjPccBXKc0kf3hS9hXCarZAjfDgq984d+u6HN8AFwfALB4unnodEwNw6ASDLZtUUrTJvXMuu4Xj8UWsCcKwRuVRySJ4+5xku7QnOdDYR9vjMVyXCngOZy628ov/DtnxOInFLJgdBdNYIV2G9UXs3WTNCsb917uR91bXq+KeLPeR/I4ohihrtKRTvXoaHrvMFXlfYbd0YCza3M3qoV90trYU6xdubevSVcnH0Ip5pcUStYraZqbLvl2UdtQUOxXZwnvBdnO+81391WxTkqoIapdceMVuRSIR1uwrmMtpe7MiDlnqw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[my apologies for the size of patchbomb and the size of Cc; this series
really affects a lot of places, if lightly]

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

The branch is -rc5-based; it lives in
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.persistency
individual patches in followups.

Please, help with review and testing; it does appear to survive the local beating,
but extra eyes on it would be very welcome.

First two commits add a couple of useful helpers, the next three add the
infrastructure and the rest consists of per-filesystem conversions.

Shortlog:
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
      convert selinuxfs
      functionfs: switch to simple_remove_by_name()
      convert functionfs
      gadgetfs: switch to simple_remove_by_name()
      convert gadgetfs
      hypfs: don't pin dentries twice
      hypfs: switch hypfs_create_str() to returning int
      hypfs: swich hypfs_create_u64() to returning int
      convert hypfs

Diffstat:
 arch/powerpc/platforms/cell/spufs/inode.c | 15 ++---
 arch/s390/hypfs/hypfs.h                   |  6 +-
 arch/s390/hypfs/hypfs_diag_fs.c           | 60 +++++++-------------
 arch/s390/hypfs/hypfs_vm_fs.c             | 21 +++----
 arch/s390/hypfs/inode.c                   | 82 +++++++++------------------
 drivers/android/binderfs.c                | 82 +++++++--------------------
 drivers/base/devtmpfs.c                   |  2 +-
 drivers/misc/ibmasm/ibmasmfs.c            | 24 ++++----
 drivers/usb/gadget/function/f_fs.c        | 54 ++++++++----------
 drivers/usb/gadget/legacy/inode.c         | 49 ++++++++--------
 drivers/xen/xenfs/super.c                 |  2 +-
 fs/autofs/inode.c                         |  2 +-
 fs/autofs/root.c                          | 11 ++--
 fs/binfmt_misc.c                          | 69 +++++++++++------------
 fs/configfs/mount.c                       |  2 +-
 fs/dcache.c                               | 93 ++++++++++++++++++++++++-------
 fs/debugfs/inode.c                        | 32 +++--------
 fs/devpts/inode.c                         | 57 +++++++------------
 fs/efivarfs/inode.c                       |  7 +--
 fs/efivarfs/super.c                       |  5 +-
 fs/fuse/control.c                         | 19 ++++---
 fs/hugetlbfs/inode.c                      | 12 ++--
 fs/libfs.c                                | 31 +++++++++--
 fs/ocfs2/dlmfs/dlmfs.c                    |  8 +--
 fs/proc/base.c                            |  6 +-
 fs/proc/internal.h                        |  1 +
 fs/proc/root.c                            | 14 ++---
 fs/proc/self.c                            | 10 +---
 fs/proc/thread_self.c                     | 11 +---
 fs/pstore/inode.c                         |  7 ++-
 fs/ramfs/inode.c                          |  8 +--
 fs/tracefs/event_inode.c                  |  4 +-
 fs/tracefs/inode.c                        | 13 ++---
 include/linux/dcache.h                    |  3 +
 include/linux/fs.h                        |  3 +
 include/linux/proc_fs.h                   |  2 -
 init/do_mounts.c                          |  2 +-
 ipc/mqueue.c                              | 12 +---
 kernel/bpf/inode.c                        | 15 ++---
 mm/shmem.c                                | 23 ++------
 security/inode.c                          |  2 +-
 security/selinux/selinuxfs.c              | 52 +++++++++--------
 security/smack/smackfs.c                  |  2 +-
 43 files changed, 412 insertions(+), 523 deletions(-)

