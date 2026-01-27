Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2C9CD2595A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 07:42:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FCE76B0088; Tue, 27 Jan 2026 02:42:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB186B0089; Tue, 27 Jan 2026 02:42:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECED76B008A; Tue, 27 Jan 2026 02:42:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D90BA6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 02:42:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F921D4047
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:42:56 +0000 (UTC)
X-FDA: 84376952352.11.3C10584
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id A12B880006
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 07:42:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=gD2FZ48F;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769499774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLvDpIJpiTbYuOeN/1CV6jFHqGVNaZBLf9/cHhTYJFs=;
	b=VpqJT5CuwOV7G06KjcwedpYc88AXEVMLyi3wfwx8qxMynAHNhLHgsLF0JaBvlWIsAdC1/N
	Ihf/QbML8BBgxCzmbtGvdrF+S/pqCU3WyJ6kVitwK/WmQavGHCNldeDMrpbtK77HdXdkDZ
	Y/sDCd/UJazUJ7QLSqwYir4JzB5W5+Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=gD2FZ48F;
	spf=pass (imf02.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769499774; a=rsa-sha256;
	cv=none;
	b=vEQDwGGTWyrqoVVs6ppF+CsF6mC+KunFvNBs2VK/yp2P8+DoHE6D6Un2Nq8tdT6JjFztoq
	0XAt+3o6BSyppFlqjYErwEfqb4duFyrdWkFPRetdWG5BqATbgLrhljuCif1OTXlrZewer2
	i/J5Hj/U/kW+MFtfaMTflTZ1JyPPZuE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8815143D98;
	Tue, 27 Jan 2026 07:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC89C116C6;
	Tue, 27 Jan 2026 07:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769499773;
	bh=ikQcR87yl+GoM9FcMFnkrg0jZI4+AeTioVcdiBeKjEo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gD2FZ48FJPvi7t/psx/HALGN/uZFOf3AhJtiZANeDXFi2C/lZm/CgH20rka87o0fd
	 5vDMhti0sCNGoMz1k/ShZSdEFYf1yEk0SvAsfjXTH7FmmbBK+p8vrnCzcNkHYSxz2O
	 DYQ3Lr8e1TJKhviH1CIRD5w5GuZv0R6SCjkw3mAI=
Date: Tue, 27 Jan 2026 08:42:50 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Samuel Wu <wusamuel@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
	torvalds@linux-foundation.org, brauner@kernel.org, jack@suse.cz,
	raven@themaw.net, miklos@szeredi.hu, neil@brown.name,
	a.hindborg@kernel.org, linux-mm@kvack.org,
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	kees@kernel.org, rostedt@goodmis.org, linux-usb@vger.kernel.org,
	paul@paul-moore.com, casey@schaufler-ca.com,
	linuxppc-dev@lists.ozlabs.org, john.johansen@canonical.com,
	selinux@vger.kernel.org, borntraeger@linux.ibm.com,
	bpf@vger.kernel.org, clm@meta.com,
	android-kernel-team <android-kernel-team@google.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
Message-ID: <2026012715-mantra-pope-9431@gregkh>
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
 <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Stat-Signature: equiukpnniretdds9f5x99tcf8q3s4ui
X-Rspam-User: 
X-Rspamd-Queue-Id: A12B880006
X-HE-Tag: 1769499774-547707
X-HE-Meta: U2FsdGVkX19+LGKPSXoeqqZvAT4SCDb9TdfctvCjapkCxUffDnVLu7OGHMUU4dDWDNnn4KcgmpBt7TKByCE5rsIXxNuEeJqa1op15Pe52qiS2yA818KM4JkRHqpqLcZ8/wV9gh8LZ/oHCy1+Pkka/5akR4cefpWq/yKtTpUYioOSE80jOoDk+WNxeLmht+nii9dTcN2a/hBPxo37GKiAhte2MQJVlWhXQ7bXuplpwuHI2ycZu8ewrfOUmPF35GdgrV+ZeagqnPOqFEKinlpZznxuPpR4rGhqTU8P+K/iYTop8XE7wQ6DqWqr6wjzmXYZt4CdFywMSOZvcR8Yf8+SB0xoE7zpYPvjhKRunPFKjxZ8tyuh8vdWM1rV2TX+GBUOgjYVZffZJ1DkIcFIS0ELH/q8RHt4gsroLMIbbTSxhqG1DqRe/4qJ+7b1s6P+DXlui8sz0B1Uv1HudpwoEw+45xgrtVKMXfs9GF77pOG9xO9eTs6vYe6z6Qn/XMw0vnumI28ZZiyvoa9o+b4H5nvP12nB92beibEbRC3isM+p5FI2WnUWDhL+WIB5k/uYKxg5CgpKfRrFJZx7vB912xRVWUi4SVV7bysO/nO+JUAg7nqSFkf+8+uQ/7ckmmu5Vf3FZmeLZuPt1oYRfhEwAjj+mzhcHcLZa/DSND76N1wValpmX2rPF9BJSmg8uPGeVKRunM6cAHw5yaWZ6vh3UJkUPiFFvyeRvIhppfNR6Bqkub0ylVoVtt9kbBtTnbOlG/bL8M6EiX3rC2KAj4HOH4IxJksrwgfMbr4OssFoP/dp3bbD7iDzgtL5XzxUpcxdGdEf3gW0U6xJU8Jv8Z7P38awthNFRHtd/KV67DJNlynW9JL6i8Wk4Ppqj6mxbaoXiYkm39I4pZg1DRP4h/GwiDtc75+8EvCCaFpz5QHsn3dDCLn1r1fxuFJVTb2URgqR3DUTlCDdrcIHPr9hr2D0C+e
 qHw2RxIH
 WMPe/qv3Pya5LgbvBuE81TzKPuAHaJ3XDZSRwQUkE9dSQF0ozZ153jjtAb7RxJuMh6HQ4/6oiLEf74/0Ak0GyFOxECwBcCFPkYd8gDOQ/KeGrvYWLRLBAMoRSIBZ0r1ZtPr7WrVzEDlm7EzjQJsy22g4ybrzyk5kNb6P8jKxrrymzeseUmMzWkh/b8721MZaV3vyQDk3MiBxDFatYvQrYrgo16ibhF58T9RB5LA5ecunnfHhxxFufh72OoMaM041xflUMKzmy5l44vDr6zRWEZP7S3FK4uqDwC3ZH/Wm9tfnue+Hf8wp+bnEzrjyKQyh6ozCha64uuv9pG7/mSXI9+nL4osiKFAMAMXxZNC+Dt/QkR1P4Ot7iBaZgNSlKtfAUMuX9vHEME0Eg0B0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 26, 2026 at 04:56:42PM -0800, Samuel Wu wrote:
> On Mon, Nov 17, 2025 at 9:15 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Some filesystems use a kinda-sorta controlled dentry refcount leak to pin
> > dentries of created objects in dcache (and undo it when removing those).
> > Reference is grabbed and not released, but it's not actually _stored_
> > anywhere.  That works, but it's hard to follow and verify; among other
> > things, we have no way to tell _which_ of the increments is intended
> > to be an unpaired one.  Worse, on removal we need to decide whether
> > the reference had already been dropped, which can be non-trivial if
> > that removal is on umount and we need to figure out if this dentry is
> > pinned due to e.g. unlink() not done.  Usually that is handled by using
> > kill_litter_super() as ->kill_sb(), but there are open-coded special
> > cases of the same (consider e.g. /proc/self).
> >
> > Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTENT)
> > marking those "leaked" dentries.  Having it set claims responsibility
> > for +1 in refcount.
> >
> > The end result this series is aiming for:
> >
> > * get these unbalanced dget() and dput() replaced with new primitives that
> >   would, in addition to adjusting refcount, set and clear persistency flag.
> > * instead of having kill_litter_super() mess with removing the remaining
> >   "leaked" references (e.g. for all tmpfs files that hadn't been removed
> >   prior to umount), have the regular shrink_dcache_for_umount() strip
> >   DCACHE_PERSISTENT of all dentries, dropping the corresponding
> >   reference if it had been set.  After that kill_litter_super() becomes
> >   an equivalent of kill_anon_super().
> >
> > Doing that in a single step is not feasible - it would affect too many places
> > in too many filesystems.  It has to be split into a series.
> >
> > This work has really started early in 2024; quite a few preliminary pieces
> > have already gone into mainline.  This chunk is finally getting to the
> > meat of that stuff - infrastructure and most of the conversions to it.
> >
> > Some pieces are still sitting in the local branches, but the bulk of
> > that stuff is here.
> >
> > Compared to v3:
> >         * fixed a functionfs braino around ffs_epfiles_destroy() (in #40/54,
> > used to be #36/50).
> >         * added fixes for a couple of UAF in functionfs (##36--39); that
> > does *NOT* include any fixes for dmabuf bugs Chris posted last week, though.
> >
> > The branch is -rc5-based; it lives in
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.persistency
> > individual patches in followups.
> >
> > Please, help with review and testing.  If nobody objects, in a few days it
> > goes into #for-next.
> >
> > Shortlog:
> >       fuse_ctl_add_conn(): fix nlink breakage in case of early failure
> >       tracefs: fix a leak in eventfs_create_events_dir()
> >       new helper: simple_remove_by_name()
> >       new helper: simple_done_creating()
> >       introduce a flag for explicitly marking persistently pinned dentries
> >       primitives for maintaining persisitency
> >       convert simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
> >       convert ramfs and tmpfs
> >       procfs: make /self and /thread_self dentries persistent
> >       configfs, securityfs: kill_litter_super() not needed
> >       convert xenfs
> >       convert smackfs
> >       convert hugetlbfs
> >       convert mqueue
> >       convert bpf
> >       convert dlmfs
> >       convert fuse_ctl
> >       convert pstore
> >       convert tracefs
> >       convert debugfs
> >       debugfs: remove duplicate checks in callers of start_creating()
> >       convert efivarfs
> >       convert spufs
> >       convert ibmasmfs
> >       ibmasmfs: get rid of ibmasmfs_dir_ops
> >       convert devpts
> >       binderfs: use simple_start_creating()
> >       binderfs_binder_ctl_create(): kill a bogus check
> >       convert binderfs
> >       autofs_{rmdir,unlink}: dentry->d_fsdata->dentry == dentry there
> >       convert autofs
> >       convert binfmt_misc
> >       selinuxfs: don't stash the dentry of /policy_capabilities
> >       selinuxfs: new helper for attaching files to tree
> >       convert selinuxfs
> >       functionfs: don't abuse ffs_data_closed() on fs shutdown
> >       functionfs: don't bother with ffs->ref in ffs_data_{opened,closed}()
> >       functionfs: need to cancel ->reset_work in ->kill_sb()
> >       functionfs: fix the open/removal races
> >       functionfs: switch to simple_remove_by_name()
> >       convert functionfs
> >       gadgetfs: switch to simple_remove_by_name()
> >       convert gadgetfs
> >       hypfs: don't pin dentries twice
> >       hypfs: switch hypfs_create_str() to returning int
> >       hypfs: swich hypfs_create_u64() to returning int
> >       convert hypfs
> >       convert rpc_pipefs
> >       convert nfsctl
> >       convert rust_binderfs
> >       get rid of kill_litter_super()
> >       convert securityfs
> >       kill securityfs_recursive_remove()
> >       d_make_discardable(): warn if given a non-persistent dentry
> >
> > Diffstat:
> >  Documentation/filesystems/porting.rst     |   7 ++
> >  arch/powerpc/platforms/cell/spufs/inode.c |  17 ++-
> >  arch/s390/hypfs/hypfs.h                   |   6 +-
> >  arch/s390/hypfs/hypfs_diag_fs.c           |  60 ++++------
> >  arch/s390/hypfs/hypfs_vm_fs.c             |  21 ++--
> >  arch/s390/hypfs/inode.c                   |  82 +++++--------
> >  drivers/android/binder/rust_binderfs.c    | 121 ++++++-------------
> >  drivers/android/binderfs.c                |  82 +++----------
> >  drivers/base/devtmpfs.c                   |   2 +-
> >  drivers/misc/ibmasm/ibmasmfs.c            |  24 ++--
> >  drivers/usb/gadget/function/f_fs.c        | 144 +++++++++++++----------
> >  drivers/usb/gadget/legacy/inode.c         |  49 ++++----
> >  drivers/xen/xenfs/super.c                 |   2 +-
> >  fs/autofs/inode.c                         |   2 +-
> >  fs/autofs/root.c                          |  11 +-
> >  fs/binfmt_misc.c                          |  69 ++++++-----
> >  fs/configfs/dir.c                         |  10 +-
> >  fs/configfs/inode.c                       |   3 +-
> >  fs/configfs/mount.c                       |   2 +-
> >  fs/dcache.c                               | 111 +++++++++++-------
> >  fs/debugfs/inode.c                        |  32 ++----
> >  fs/devpts/inode.c                         |  57 ++++-----
> >  fs/efivarfs/inode.c                       |   7 +-
> >  fs/efivarfs/super.c                       |   5 +-
> >  fs/fuse/control.c                         |  38 +++---
> >  fs/hugetlbfs/inode.c                      |  12 +-
> >  fs/internal.h                             |   1 -
> >  fs/libfs.c                                |  52 +++++++--
> >  fs/nfsd/nfsctl.c                          |  18 +--
> >  fs/ocfs2/dlmfs/dlmfs.c                    |   8 +-
> >  fs/proc/base.c                            |   6 +-
> >  fs/proc/internal.h                        |   1 +
> >  fs/proc/root.c                            |  14 +--
> >  fs/proc/self.c                            |  10 +-
> >  fs/proc/thread_self.c                     |  11 +-
> >  fs/pstore/inode.c                         |   7 +-
> >  fs/ramfs/inode.c                          |   8 +-
> >  fs/super.c                                |   8 --
> >  fs/tracefs/event_inode.c                  |   7 +-
> >  fs/tracefs/inode.c                        |  13 +--
> >  include/linux/dcache.h                    |   4 +-
> >  include/linux/fs.h                        |   6 +-
> >  include/linux/proc_fs.h                   |   2 -
> >  include/linux/security.h                  |   2 -
> >  init/do_mounts.c                          |   2 +-
> >  ipc/mqueue.c                              |  12 +-
> >  kernel/bpf/inode.c                        |  15 +--
> >  mm/shmem.c                                |  38 ++----
> >  net/sunrpc/rpc_pipe.c                     |  27 ++---
> >  security/apparmor/apparmorfs.c            |  13 ++-
> >  security/inode.c                          |  35 +++---
> >  security/selinux/selinuxfs.c              | 185 +++++++++++++-----------------
> >  security/smack/smackfs.c                  |   2 +-
> >  53 files changed, 649 insertions(+), 834 deletions(-)
> >
> >         Overview:
> >
> > First two commits are bugfixes (fusectl and tracefs resp.)
> >
> > [1/54] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
> > [2/54] tracefs: fix a leak in eventfs_create_events_dir()
> >
> > Next, two commits adding a couple of useful helpers, the next three adding
> > the infrastructure and the rest consists of per-filesystem conversions.
> >
> > [3/54] new helper: simple_remove_by_name()
> > [4/54] new helper: simple_done_creating()
> >         end_creating_path() analogue for internal object creation; unlike
> > end_creating_path() no mount is passed to it (or guaranteed to exist, for
> > that matter - it might be used during the filesystem setup, before the
> > superblock gets attached to any mounts).
> >
> > Infrastructure:
> > [5/54] introduce a flag for explicitly marking persistently pinned dentries
> >         * introduce the new flag
> >         * teach shrink_dcache_for_umount() to handle it (i.e. remove
> > and drop refcount on anything that survives to umount with that flag
> > still set)
> >         * teach kill_litter_super() that anything with that flag does
> > *not* need to be unpinned.
> > [6/54] primitives for maintaining persisitency
> >         * d_make_persistent(dentry, inode) - bump refcount, mark persistent
> > and make hashed positive.  Return value is a borrowed reference to dentry;
> > it can be used until something removes persistency (at the very least,
> > until the parent gets unlocked, but some filesystems may have stronger
> > exclusion).
> >         * d_make_discardable() - remove persistency mark and drop reference.
> >
> > NOTE: at that stage d_make_discardable() does not reject dentries not
> > marked persistent - it acts as if the mark been set.
> >
> > Rationale: less noise in series splitup that way.  We want (and on the
> > next commit will get) simple_unlink() to do the right thing - remove
> > persistency, if it's there.  However, it's used by many filesystems.
> > We would have either to convert them all at once or split simple_unlink()
> > into "want persistent" and "don't want persistent" versions, the latter
> > being the old one.  In the course of the series almost all callers
> > would migrate to the replacement, leaving only two pathological cases
> > with the old one.  The same goes for simple_rmdir() (two callers left in
> > the end), simple_recursive_removal() (all callers gone in the end), etc.
> > That's a lot of noise and it's easier to start with d_make_discardable()
> > quietly accepting non-persistent dentries, then, in the end, add private
> > copies of simple_unlink() and simple_rmdir() for two weird users (configfs
> > and apparmorfs) and have those use dput() instead of d_make_discardable().
> > At that point we'd be left with all callers of d_make_discardable()
> > always passing persistent dentries, allowing to add a warning in it.
> >
> > [7/54] convert simple_{link,unlink,rmdir,rename,fill_super}() to new primitives
> >         See above re quietly accepting non-peristent dentries in
> > simple_unlink(), simple_rmdir(), etc.
> >
> >         Converting filesystems:
> > [8/54] convert ramfs and tmpfs
> > [9/54] procfs: make /self and /thread_self dentries persistent
> > [10/54] configfs, securityfs: kill_litter_super() not needed
> > [11/54] convert xenfs
> > [12/54] convert smackfs
> > [13/54] convert hugetlbfs
> > [14/54] convert mqueue
> > [15/54] convert bpf
> > [16/54] convert dlmfs
> > [17/54] convert fuse_ctl
> > [18/54] convert pstore
> > [19/54] convert tracefs
> > [20/54] convert debugfs
> > [21/54] debugfs: remove duplicate checks in callers of start_creating()
> > [22/54] convert efivarfs
> > [23/54] convert spufs
> > [24/54] convert ibmasmfs
> > [25/54] ibmasmfs: get rid of ibmasmfs_dir_ops
> > [26/54] convert devpts
> > [27/54] binderfs: use simple_start_creating()
> > [28/54] binderfs_binder_ctl_create(): kill a bogus check
> > [29/54] convert binderfs
> > [30/54] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry == dentry there
> > [31/54] convert autofs
> > [32/54] convert binfmt_misc
> > [33/54] selinuxfs: don't stash the dentry of /policy_capabilities
> > [34/54] selinuxfs: new helper for attaching files to tree
> > [35/54] convert selinuxfs
> >
> >         Several functionfs fixes, before converting it, to make life
> > simpler for backporting:
> > [36/54] functionfs: don't abuse ffs_data_closed() on fs shutdown
> > [37/54] functionfs: don't bother with ffs->ref in ffs_data_{opened,closed}()
> > [38/54] functionfs: need to cancel ->reset_work in ->kill_sb()
> > [39/54] functionfs: fix the open/removal races
> >
> >         ... and back to filesystems conversions:
> >
> > [40/54] functionfs: switch to simple_remove_by_name()
> > [41/54] convert functionfs
> > [42/54] gadgetfs: switch to simple_remove_by_name()
> > [43/54] convert gadgetfs
> > [44/54] hypfs: don't pin dentries twice
> > [45/54] hypfs: switch hypfs_create_str() to returning int
> > [46/54] hypfs: swich hypfs_create_u64() to returning int
> > [47/54] convert hypfs
> > [48/54] convert rpc_pipefs
> > [49/54] convert nfsctl
> > [50/54] convert rust_binderfs
> >
> >         ... and no kill_litter_super() callers remain, so we
> > can take it out:
> > [51/54] get rid of kill_litter_super()
> >
> >         Followups:
> > [52/54] convert securityfs
> >         That was the last remaining user of simple_recursive_removal()
> > that did *not* mark things persistent.  Now the only places where
> > d_make_discardable() is still called for dentries that are not marked
> > persistent are the calls of simple_{unlink,rmdir}() in configfs and
> > apparmorfs.
> >
> > [53/54] kill securityfs_recursive_remove()
> >         Unused macro...
> >
> > [54/54] d_make_discardable(): warn if given a non-persistent dentry
> >
> > At this point there are very few call chains that might lead to
> > d_make_discardable() on a dentry that hadn't been made persistent:
> > calls of simple_unlink() and simple_rmdir() in configfs and
> > apparmorfs.
> >
> > Both filesystems do pin (part of) their contents in dcache, but
> > they are currently playing very unusual games with that.  Converting
> > them to more usual patterns might be possible, but it's definitely
> > going to be a long series of changes in both cases.
> >
> > For now the easiest solution is to have both stop using simple_unlink()
> > and simple_rmdir() - that allows to make d_make_discardable() warn
> > when given a non-persistent dentry.
> >
> > Rather than giving them full-blown private copies (with calls of
> > d_make_discardable() replaced with dput()), let's pull the parts of
> > simple_unlink() and simple_rmdir() that deal with timestamps and link
> > counts into separate helpers (__simple_unlink() and __simple_rmdir()
> > resp.) and have those used by configfs and apparmorfs.
> >
> 
> Hi Al, when I apply this patchset my Pixel 6 no longer enumerates on
> lsusb or ADB. It was quite hard to bisect to this point, as this is
> non-deterministic and seems to be setup specific. Note, I am using
> android-mainline, but my understanding is that this build does not
> have any out-of-tree USB patches, and that there are no vendor hooks
> in the build.
> 
> My apologies as I can't offer any other clues; there are no obviously
> bad dmesg logs and I'm still working on narrowing down the exact
> commit(s) that started this, but just wanted to send a FYI in case
> something stands out as obvious.

Note that I had to revert commit e5bf5ee26663 ("functionfs: fix the
open/removal races") from the stable backports, as it was causing issues
on the pixel devices it got backported to.  So perhaps look there?

thanks,

greg k-h

