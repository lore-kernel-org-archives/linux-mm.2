Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37C69D1D86F
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 06:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CCF56B000E; Thu,  4 Dec 2025 01:47:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A4876B0012; Thu,  4 Dec 2025 01:47:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E19F6B0023; Thu,  4 Dec 2025 01:47:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 29CEB6B000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 01:47:02 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7893913374E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:46:59 +0000 (UTC)
X-FDA: 84180856158.22.C712469
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA084160008
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 06:46:57 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=DMfKoLH0;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764830818;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6V+oBcK/j52G6lsVveD6nE1Y0DSxEoZWG7pTjATtvx0=;
	b=wg6FufWyD5FPv12Oi1ZN5m+1vn2/viLhXdOzfwtp+e0tt36AxQnjRQU2JekociZHoLhTcX
	KmzUx6Eo8i1pDap0ueY5DgF72sJi1gHxrFPEDBjUilyYM9apUIHJmz5r+SSnifA6bz65lD
	E3QEaJiESFK1vh9OjxjKj3muRkB4iaQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764830818; a=rsa-sha256;
	cv=none;
	b=y/l9PH8KoSKGsK0t4K396kHP7FgGBFoqH+Hep0QibHUvPQ0ehVqr/Jm1QsFJKscvPsHVoT
	sTZCyt/7GvEdAavwsulElLGpry1JF7II0MIflEi//8WQia8t5qIDUnYNiake7Oq+qH85HX
	vw38D99+hqwKMnBKUxXESOBwHFyXS3g=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=DMfKoLH0;
	spf=none (imf08.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=6V+oBcK/j52G6lsVveD6nE1Y0DSxEoZWG7pTjATtvx0=; b=DMfKoLH0UioN2bZkTLYha18j63
	teVEXM2GOEXu0WVLPSffJuq1oNWr3Y8E4BvLx/NQpTGLhn/A7nraB5izgk5B/up/rep0ox91kQqvc
	iFuyRCUTDTMjVojmT48vkXvYqwxDtvyQ3mzCTBAQwg1vOYto/f6IOmX8yscxV8lJEkrK+XvEf8qK9
	hzvOhwPJZe8gEGdrzwrq4S+j9OQRnxivkeQXc6xVa8UID5cW6BeKT63HYouXuMiSyHuSo5/fWbbtR
	nXID9o4oSOQd75OJkYQreZuMnJhLfbAPgK+N7TIK/toyLJjf29/y6kqHAuKzcdo8lUfesJy3aC6T9
	hLfqJadg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vR37K-0000000A4eR-3hi7;
	Thu, 04 Dec 2025 06:47:07 +0000
Date: Thu, 4 Dec 2025 06:47:06 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Ian Kent <raven@themaw.net>, Miklos Szeredi <miklos@szeredi.hu>,
	NeilBrown <neil@brown.name>,
	Andreas Hindborg <a.hindborg@kernel.org>, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	Kees Cook <kees@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linuxppc-dev@lists.ozlabs.org,
	John Johansen <john.johansen@canonical.com>,
	selinux@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	bpf@vger.kernel.org, Chris Mason <clm@meta.com>
Subject: [git pull][vfs] tree-in-dcache stuff
Message-ID: <20251204064706.GJ1712166@ZenIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AA084160008
X-Stat-Signature: gcwkujhocdxonrtmqcobcgpx43e7as5u
X-HE-Tag: 1764830817-447166
X-HE-Meta: U2FsdGVkX1/hIWS4pQ7aMXZam2/Y8bgXY3d7s1raTwZZb8DIlhZia0fFwu2pF1HAntUVSbkpxRRuJRd10TqWU8X+Wlwbe7Gr0zmSlgSTq5w4H504kzJ/IKI8+t5F7Fwhpb/qyVw7nv1NkO+yeU6ryslaqpNgoSd4u1CuCqVHEueUpLiDl2qt5nTH6A58bSspN1ADwSWy+kaS9NrFe4op7HDTv/OwatbftnlVh/Rzby0qK3qJ79x89KGk36pEXhbkH9AYTQkmIH/tisdEQZULLiwpWnt7X7yffyk1M9DI2j+E/VqCfbmz8+ZHCyV5t0CNHpqEVFhP2PWQmr736rZvwfrEsyLG374hCYVk2R00CVXBKW7JVYExxfQR42mcKglOzQryixy5SQsuqSaQ55uIHxyU0Qc2cx0uWjZpm4pgQq7WMpdi63+2DGIr9chWQ1aW7CSCeLm2DCPntsmpdg/SB7MBhfNR32gtDKWXEp9VuAxdhdElh0zbLxyZ8hkToeRHN51fuS1JEgo4AIW+zy3HbHu/1672okW0AYwGy4++TvCtmaPUuE1kC93CVxPrFjNMGxNb2nl8gDTC88amREhhbT1kTzBfV/0lgZLY/qpjRLXECFWTXzSjbVG1TUxVPe5YaDrPvpdVRMrISmR9oqmRBBK/Lfjq337kzwiq4RmFph2vS8fpvlyw4pJ6pHKGzWVlOY8XOtVCteEcS7bB+lEMNoVKyNmz0hydDYTafIncceTAWtuSRmTJqNGbd+R2jW0IZuoDlqZhU0S4XSsR/bQASREdWXMmmdNtfNqjmWAgLp0SPmhiZUnmdgtAZCw66u6mKZ5hQ6wpnHq6kT8FY2AhF5y3tqxe3VFM5b9xbtsOIEWYMBUyPaSWSEQG3DZVyjJab9TD5WC8/eyWoLOeCfhe1yWh284JWEUDRMnl1uIyb0nC73YdP8R2Iw8IGuXHXxVKxg8ieHVWOK/+XAWlK0+
 zv/XRf9P
 gw7hHGlOrZOPHDyAAcXUefN2sU/qhwxuHt/42RGif2sTyNkEUp3pTwANvGtu0ZJCqM0RQM44mRGLSV318+q3xxPIhjA0kG2O3z/o/KK/ATLUXiDbT3aUA2qsAxzRhYsXtS0p+Ig69V/69zJOMjTSPXUfFjYa5ic5tmav56hmf3yhDxVjdiMk5GEJzR5390IyqIAXf3ZeT11AE4T0SvTXuLPUBW1GNtxY0vcNBTfv9gs3xHxxW2VRcpd2i1I5qo8ihdRYvaNlXf3TEgKKeealgPXQ0YqdilDe/YEdZS76POZR63bcpLsAecN8pq8wQAkhAFIxQST12diUbqqOsooCpyVWnkpMVPgJWixsULEiArYzTV2zvzysL0NVTdxX7O56T7gf1+c2tqpRfvrVSyD/JptViD1g5ZIPaGPO0p0FqRmKk5e0qUfC7xw5Ix/2EBV73+riGwfPaAB7UhmmVbTydgrNyfr2Km8o8i7rNOpVe/YHnRuUId26iCqUcszO1frKOa8q5z4f7NlBhDDUI+UtRJqGksQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following changes since commit e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c:

  Linux 6.18-rc5 (2025-11-09 15:10:19 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git tags/pull-persistency

for you to fetch changes up to eb028c33451af08bb34f45c6be6967ef1c98cbd1:

  d_make_discardable(): warn if given a non-persistent dentry (2025-11-17 23:59:27 -0500)

	Conflicts in Documentation/filesystems/porting.rst, fs/dcache.c,
fs/debugfs/inode.c and security/apparmor/apparmorfs.c; proposed resolution
in #proposed-merge (same as in -next).  Details of conflicts:
Documentation/filesystems/porting.rst:
	usual trivial append/append conflict
fs/dcache.c in d_instantiate_new():
	pulling spin_unlock(&entry->d_lock) from __d_instantiate() into
	callers in this branch vs. changes of the lines immediately
	following the call of __d_instantiate() in mainline.  Obvious
	resolution.
fs/debugfs/inode.c in __debugfs_create_file(), debugfs_create_dir()
	and debugfs_create_automount():
	removal of pointless check in this branch vs. changes of
	(unreachable) failure handling in mainline.
	Resolution: remove it, it's still a dead code.
fs/debugfs/inode.c in debugfs_create_symlink():
	d_instantiate() -> d_make_persistent() in this branch,
	end_creating() -> debugfs_end_creating() in mainline.
	Obvious resolution...
security/apparmor/apparmorfs.c in aafs_remove():
	switch of simple_rmdir() and simple_unlink() to
	__simple_{rmdir,unlink}() in this branch vs. switch to
	start_removing_dentry()/end_removing() around those calls
	in mainline.  Resolution: switch simple_{rmdir,unlink}() as in
	this branch.  TBH, I rather doubt that mainline change there was
	worthwhile - aafs interaction with VFS locking is...  special,
	and _ANY_ changes of locking protocol on our end will have to
	consider that location very carefully anyway; making it look
	like a regular removal is at that stage is asking for trouble.

----------------------------------------------------------------
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

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

----------------------------------------------------------------
Al Viro (54):
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
      functionfs: don't abuse ffs_data_closed() on fs shutdown
      functionfs: don't bother with ffs->ref in ffs_data_{opened,closed}()
      functionfs: need to cancel ->reset_work in ->kill_sb()
      functionfs: fix the open/removal races
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
 drivers/usb/gadget/function/f_fs.c        | 144 +++++++++++++----------
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
 53 files changed, 649 insertions(+), 834 deletions(-)

