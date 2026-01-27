Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65340D1951B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 00:56:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60136B0092; Mon, 26 Jan 2026 19:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E096B0093; Mon, 26 Jan 2026 19:56:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7A36B0095; Mon, 26 Jan 2026 19:56:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 958A16B0092
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 19:56:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 000951A0923
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:56:57 +0000 (UTC)
X-FDA: 84375929274.28.7FB074D
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 04A4E40009
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 00:56:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wjVjyx7g;
	spf=pass (imf11.hostedemail.com: domain of wusamuel@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769475416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3zLfNFu5Ej89ae2FOVFTz6sNNJ0wH6QKfxg5HAX5ASo=;
	b=yF6fp43Oy8v/GlArRulhmIMxhGeOAD4tUUi6tqQV6qZR55hbZmH+LrBOFkPc0DZpe0WXiC
	y0tfoQUi5yzYhHEdMv4qjuO657qmuBzCTEs+VYWdpYZ8Lyyw9v5p3I631AoeFaCqioVdZI
	cEZ84hfV8qGLRvLMBmPAkw2zHzPmylY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wjVjyx7g;
	spf=pass (imf11.hostedemail.com: domain of wusamuel@google.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=wusamuel@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769475416; a=rsa-sha256;
	cv=pass;
	b=2AJdvMzkL3oPxiJPX6cg5PkkD85/l1V8SRzbAYo0aPPahyF/+3WOt8djLWUJAsm9NzorTL
	pGBpcXdY95iLa/CCWsOwh1cCAbKbanjSS0t3NTIJvrQhXw7uUQU9BraRAhmL/1ueyHJ1ic
	SOtsuMRFv4dTuQ50DphAfTDrQl48Sc4=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-65812261842so9902908a12.1
        for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:56:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769475414; cv=none;
        d=google.com; s=arc-20240605;
        b=clJ8VoFwr+UAMbuHNQl4/C5cYbZgy/cSEZZ/YlCSH2HZzXztOX/8CHRENih6pde1Zb
         jmMfEY29ee680woR1Lwrwmqkc1FOZfpt1eDk9EhOQvFKf244wrc6NOD5PjbJFoJ2MjZ+
         Xb1NMiD6RIsmcnk2Q89a27nH8fxzYX0I0mFESSXG+yKJIQQlnx+O2JlNxMtwSVlqaMic
         nk32u9kG1kzAS0uZVIzHY4aWM+bHMkj42x6R4Z7vaXZS/lybEDTNz9woN8nylzCegvrr
         zTKDrMR4mXV+1Gc/Bua2xdc0ZHtLH+KeyFhwICm9D7m3xtFFmLsQC9kF5pNEH/JXi57u
         3RTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3zLfNFu5Ej89ae2FOVFTz6sNNJ0wH6QKfxg5HAX5ASo=;
        fh=rKc+i24UTW717wsBvzQgsNipedXyiUCkwCRBKnhLMhI=;
        b=e3Uf3hjQeRu42zTHFyCNHKlfkNLBpfgVIEctNRKj2DDqldnI4FS33uQymFCAr54vHi
         nNSFds2DUKt3XcgppSNiPeHbx9XX8ZOdWEDmo8nvZ2S3V9gdpyR3W5G+T92ig8bFYGzC
         zWbYg3JRNaJ1I83PgqOC244DcaRzvBwRCCk5fc66rDpp57glML3QRMYGgwMgOypqiYce
         n8VWVNaAG1PipRYcbFumKl0IhyJkt15zha6m9TiNHkB4KqwZx7N6oB4Ea+639J1V6L+H
         qJ2Oca+j5RkI3rfDBwvCZkrhMv8GCiuq1kQ1b8v1/mbnClU+tYy2q2GrASBL3dHDRWow
         STBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769475414; x=1770080214; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3zLfNFu5Ej89ae2FOVFTz6sNNJ0wH6QKfxg5HAX5ASo=;
        b=wjVjyx7gTfvoYpouNFkau4fDJAwXLPSqBpURQJe2M4c5zMh78oxClYl0UVWGmINeJU
         gXIb1xPCo51smZut23YVFRoHXGS+N2lNb70axBxvOc6U0L0nZEi/9TVlMN2RTekGQlhx
         L5I134MXGHcmX/1iXdziyoyawQOiWjGShIUnlP89zd36PJd5Tg8B98UHMYI017RAmvg1
         qN3l8HNuOjnvGda/spbHFybKVvl+uH/2jk4juq+vuFwkQY/UhzXVrux77F/HBZeiaVjz
         CCuOj/kk8z3Wbb8UWCIyHcU/G+/dvO3XMaopTNh7mkXTsXfLjqXP4c1vjJITj62DZWpb
         3SKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769475414; x=1770080214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3zLfNFu5Ej89ae2FOVFTz6sNNJ0wH6QKfxg5HAX5ASo=;
        b=F365ERrQaiLiF49/rLEDGBjujEMN9lZBIxUb0PXvuJsayg3fFklcKTNDGzbPv4FV6H
         lubTpScSI8qbdQV8NZIPo4Sr9y/LtcsehdhBkuqTw5kLsClYYGnbjRAnlk0UMd4aBY2w
         Bh6U8fp/rT5MNSCZb+4/NcD0KMRDNYzKznxW7BRGTDjxTIyUPpFHDf9mYEb10dHe1Os+
         Twd3QCxpFKX8SC98P+tPC5LPTlJFscbpEAIZqbUBSbeAlXkYsU6/nDc+dlpKkB1IL3tk
         kmd7x3SJeJG9cIrsi2/4M599+kNaHNJ3XFE26q0iB22Hh+GRvbrjz+QQ6WUyWDp9JoaB
         JxTA==
X-Forwarded-Encrypted: i=1; AJvYcCUjftVmXscj/bx4n50gT7lhtCR74CG5f4lyuN3YhMJlwdA+8a2Q3xUqt0Zw3sSQ8Yxq5unpHMozog==@kvack.org
X-Gm-Message-State: AOJu0YwLDOPp3gbqmT4A0j7C/+112P2SuUSeujF3GDl/JyAz1GkqVkEz
	/oIrZyO+N9v1uytJgY4fYPLSLRIr1EJtUnaHydyybeqo+YCWexj/wc1TD26Dh3na/3f7BRnfLGB
	KaSuuV9KDdZIU8VKpYH2gamUmbEeUq7Cmj2KJpT35
X-Gm-Gg: AZuq6aLuYmZX5CvpT+FLSXbTE5WVy9GFuu4x/PuaRWvtO08tX5XTev5UOAeJyTW4ywS
	khJk2NQSytUiiYamYyI+zk+WFv6um87uDPJ3yC04kjUEpcsd6/nKBr0jmaMV8y1uOpqCqu6w3/q
	H//BiFh8YvPATarGUyWZGNTpHf1l7BpcExREh4crUre3hKQC0sy7R5LtCpbSkzED2ZzJ0yBjYzs
	9onjI3hAz1c1zXRfJI4sYcv3GTQWz9hDvH6UjGa3bRNdd1DK9FQ6ahaHC9weTEI42NOC+De0V2T
	Q92qgw9+HgnFDFLhtzLArOUKOcXehA==
X-Received: by 2002:a17:907:3e1f:b0:b70:4f7d:24f8 with SMTP id
 a640c23a62f3a-b8ceef90390mr472102366b.22.1769475414121; Mon, 26 Jan 2026
 16:56:54 -0800 (PST)
MIME-Version: 1.0
References: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
In-Reply-To: <20251118051604.3868588-1-viro@zeniv.linux.org.uk>
From: Samuel Wu <wusamuel@google.com>
Date: Mon, 26 Jan 2026 16:56:42 -0800
X-Gm-Features: AZwV_QiBMrJYd91OXm8P7lUFLNbyvK6EaRwh_3htJKxjg87yoCQ5TeewXmGGNPs
Message-ID: <CAG2KctrjSP+XyBiOB7hGA2DWtdpg3diRHpQLKGsVYxExuTZazA@mail.gmail.com>
Subject: Re: [PATCH v4 00/54] tree-in-dcache stuff
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, raven@themaw.net, miklos@szeredi.hu, 
	neil@brown.name, a.hindborg@kernel.org, linux-mm@kvack.org, 
	linux-efi@vger.kernel.org, ocfs2-devel@lists.linux.dev, kees@kernel.org, 
	rostedt@goodmis.org, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org, 
	paul@paul-moore.com, casey@schaufler-ca.com, linuxppc-dev@lists.ozlabs.org, 
	john.johansen@canonical.com, selinux@vger.kernel.org, 
	borntraeger@linux.ibm.com, bpf@vger.kernel.org, clm@meta.com, 
	android-kernel-team <android-kernel-team@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 4fyoz7x98pbi9bstywnsz1i4kdk397wq
X-Rspam-User: 
X-Rspamd-Queue-Id: 04A4E40009
X-HE-Tag: 1769475415-717229
X-HE-Meta: U2FsdGVkX1/NCGhH2wGoRKgKNmdbg2gN4wmPtdti47QRpvwZRWswgmM/AsPFMGYu2t8ndijpI0ZcD72RDIpLwSvgvR5uOmuIix8hPU6LZoOcVk1XF+gN5IwP/WJH9Cnu6knzdQYJNQR9r49qW7W/izE8H5yqrzMvEs8AdsfRMwsFe4JTZbtnyaqKDfjiAR3qbmX+r+DTPjkFTyli8aotv8WRK7bM9UHGwx+fKSK3vU1WapqLq/MNuQXru3odhrYOZDRIVUYxur+szEb80ad0tTJP7LTNXllgQ8wSVLpQZyySwx94Z/EHDDo+FGhMid8jDGtExcP0iHJKvcGdoplOJds9llgCjHE1amDw18lQJPp+UkMnhwG99dWUoNJOl9Im0uyf7Eq5OnZPYN0zRKqYK4qsHOweTExDpHYvHXHOO66T+Bi76vKe0xL7NghJi54vxDprePdYe+cBWxj70A3gFui+1zb3EuKaoXTM+ToTIn4hPBRFpl8P0j46/voh6127zlieMhkTAEnXlpf16DFzB0Dh2aSe2rJE3XzdFyYaziayQhuAauWIrEdzF/l/2nFeYz438y84eI66CHFOeKuzSgF5uGya3YcFP9b3BK0z5yvE0i7i8pXFp02BlaWBOCf4ddUJ870RXNyJF2y3wqyBoLqDd6lj4ojcv5lcxX6J0MldP5SP61GhmP351aaXCAM6mlgsrtQvt6fVdcNKBezSHIcv3fsqpM6YzqAXQeslttmd7vjNTqqnMexCySprG/VMHiLHEeoBXTnDcmWFZbaohV+urPVFQ7gmcGdLlht5i+ZlwOsb/rkO9mVnakObPCREd1IYmS03PVs9Fyl1LH6ohQRec6x1DeGlCwdiL+8c+QhsRMrQIP+wGsGnPuUy0O/5a/6lKGEeBpXhd6ndhKXMmLI8KJHKvZMkoK7FK2cYDtaiNoEF9zyQggx6jr8fM31nAIUtgFlKVBz7t1OiH5o
 5rpQwRBh
 l1hI4CYAftcXcKr97Vzn4Abq3bWiHOqEI8L+sEddYs8xpVOaONTQMq5cmAjuaMeoTxYoW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 9:15=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> Some filesystems use a kinda-sorta controlled dentry refcount leak to pin
> dentries of created objects in dcache (and undo it when removing those).
> Reference is grabbed and not released, but it's not actually _stored_
> anywhere.  That works, but it's hard to follow and verify; among other
> things, we have no way to tell _which_ of the increments is intended
> to be an unpaired one.  Worse, on removal we need to decide whether
> the reference had already been dropped, which can be non-trivial if
> that removal is on umount and we need to figure out if this dentry is
> pinned due to e.g. unlink() not done.  Usually that is handled by using
> kill_litter_super() as ->kill_sb(), but there are open-coded special
> cases of the same (consider e.g. /proc/self).
>
> Things get simpler if we introduce a new dentry flag (DCACHE_PERSISTENT)
> marking those "leaked" dentries.  Having it set claims responsibility
> for +1 in refcount.
>
> The end result this series is aiming for:
>
> * get these unbalanced dget() and dput() replaced with new primitives tha=
t
>   would, in addition to adjusting refcount, set and clear persistency fla=
g.
> * instead of having kill_litter_super() mess with removing the remaining
>   "leaked" references (e.g. for all tmpfs files that hadn't been removed
>   prior to umount), have the regular shrink_dcache_for_umount() strip
>   DCACHE_PERSISTENT of all dentries, dropping the corresponding
>   reference if it had been set.  After that kill_litter_super() becomes
>   an equivalent of kill_anon_super().
>
> Doing that in a single step is not feasible - it would affect too many pl=
aces
> in too many filesystems.  It has to be split into a series.
>
> This work has really started early in 2024; quite a few preliminary piece=
s
> have already gone into mainline.  This chunk is finally getting to the
> meat of that stuff - infrastructure and most of the conversions to it.
>
> Some pieces are still sitting in the local branches, but the bulk of
> that stuff is here.
>
> Compared to v3:
>         * fixed a functionfs braino around ffs_epfiles_destroy() (in #40/=
54,
> used to be #36/50).
>         * added fixes for a couple of UAF in functionfs (##36--39); that
> does *NOT* include any fixes for dmabuf bugs Chris posted last week, thou=
gh.
>
> The branch is -rc5-based; it lives in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git #work.persiste=
ncy
> individual patches in followups.
>
> Please, help with review and testing.  If nobody objects, in a few days i=
t
> goes into #for-next.
>
> Shortlog:
>       fuse_ctl_add_conn(): fix nlink breakage in case of early failure
>       tracefs: fix a leak in eventfs_create_events_dir()
>       new helper: simple_remove_by_name()
>       new helper: simple_done_creating()
>       introduce a flag for explicitly marking persistently pinned dentrie=
s
>       primitives for maintaining persisitency
>       convert simple_{link,unlink,rmdir,rename,fill_super}() to new primi=
tives
>       convert ramfs and tmpfs
>       procfs: make /self and /thread_self dentries persistent
>       configfs, securityfs: kill_litter_super() not needed
>       convert xenfs
>       convert smackfs
>       convert hugetlbfs
>       convert mqueue
>       convert bpf
>       convert dlmfs
>       convert fuse_ctl
>       convert pstore
>       convert tracefs
>       convert debugfs
>       debugfs: remove duplicate checks in callers of start_creating()
>       convert efivarfs
>       convert spufs
>       convert ibmasmfs
>       ibmasmfs: get rid of ibmasmfs_dir_ops
>       convert devpts
>       binderfs: use simple_start_creating()
>       binderfs_binder_ctl_create(): kill a bogus check
>       convert binderfs
>       autofs_{rmdir,unlink}: dentry->d_fsdata->dentry =3D=3D dentry there
>       convert autofs
>       convert binfmt_misc
>       selinuxfs: don't stash the dentry of /policy_capabilities
>       selinuxfs: new helper for attaching files to tree
>       convert selinuxfs
>       functionfs: don't abuse ffs_data_closed() on fs shutdown
>       functionfs: don't bother with ffs->ref in ffs_data_{opened,closed}(=
)
>       functionfs: need to cancel ->reset_work in ->kill_sb()
>       functionfs: fix the open/removal races
>       functionfs: switch to simple_remove_by_name()
>       convert functionfs
>       gadgetfs: switch to simple_remove_by_name()
>       convert gadgetfs
>       hypfs: don't pin dentries twice
>       hypfs: switch hypfs_create_str() to returning int
>       hypfs: swich hypfs_create_u64() to returning int
>       convert hypfs
>       convert rpc_pipefs
>       convert nfsctl
>       convert rust_binderfs
>       get rid of kill_litter_super()
>       convert securityfs
>       kill securityfs_recursive_remove()
>       d_make_discardable(): warn if given a non-persistent dentry
>
> Diffstat:
>  Documentation/filesystems/porting.rst     |   7 ++
>  arch/powerpc/platforms/cell/spufs/inode.c |  17 ++-
>  arch/s390/hypfs/hypfs.h                   |   6 +-
>  arch/s390/hypfs/hypfs_diag_fs.c           |  60 ++++------
>  arch/s390/hypfs/hypfs_vm_fs.c             |  21 ++--
>  arch/s390/hypfs/inode.c                   |  82 +++++--------
>  drivers/android/binder/rust_binderfs.c    | 121 ++++++-------------
>  drivers/android/binderfs.c                |  82 +++----------
>  drivers/base/devtmpfs.c                   |   2 +-
>  drivers/misc/ibmasm/ibmasmfs.c            |  24 ++--
>  drivers/usb/gadget/function/f_fs.c        | 144 +++++++++++++----------
>  drivers/usb/gadget/legacy/inode.c         |  49 ++++----
>  drivers/xen/xenfs/super.c                 |   2 +-
>  fs/autofs/inode.c                         |   2 +-
>  fs/autofs/root.c                          |  11 +-
>  fs/binfmt_misc.c                          |  69 ++++++-----
>  fs/configfs/dir.c                         |  10 +-
>  fs/configfs/inode.c                       |   3 +-
>  fs/configfs/mount.c                       |   2 +-
>  fs/dcache.c                               | 111 +++++++++++-------
>  fs/debugfs/inode.c                        |  32 ++----
>  fs/devpts/inode.c                         |  57 ++++-----
>  fs/efivarfs/inode.c                       |   7 +-
>  fs/efivarfs/super.c                       |   5 +-
>  fs/fuse/control.c                         |  38 +++---
>  fs/hugetlbfs/inode.c                      |  12 +-
>  fs/internal.h                             |   1 -
>  fs/libfs.c                                |  52 +++++++--
>  fs/nfsd/nfsctl.c                          |  18 +--
>  fs/ocfs2/dlmfs/dlmfs.c                    |   8 +-
>  fs/proc/base.c                            |   6 +-
>  fs/proc/internal.h                        |   1 +
>  fs/proc/root.c                            |  14 +--
>  fs/proc/self.c                            |  10 +-
>  fs/proc/thread_self.c                     |  11 +-
>  fs/pstore/inode.c                         |   7 +-
>  fs/ramfs/inode.c                          |   8 +-
>  fs/super.c                                |   8 --
>  fs/tracefs/event_inode.c                  |   7 +-
>  fs/tracefs/inode.c                        |  13 +--
>  include/linux/dcache.h                    |   4 +-
>  include/linux/fs.h                        |   6 +-
>  include/linux/proc_fs.h                   |   2 -
>  include/linux/security.h                  |   2 -
>  init/do_mounts.c                          |   2 +-
>  ipc/mqueue.c                              |  12 +-
>  kernel/bpf/inode.c                        |  15 +--
>  mm/shmem.c                                |  38 ++----
>  net/sunrpc/rpc_pipe.c                     |  27 ++---
>  security/apparmor/apparmorfs.c            |  13 ++-
>  security/inode.c                          |  35 +++---
>  security/selinux/selinuxfs.c              | 185 +++++++++++++-----------=
------
>  security/smack/smackfs.c                  |   2 +-
>  53 files changed, 649 insertions(+), 834 deletions(-)
>
>         Overview:
>
> First two commits are bugfixes (fusectl and tracefs resp.)
>
> [1/54] fuse_ctl_add_conn(): fix nlink breakage in case of early failure
> [2/54] tracefs: fix a leak in eventfs_create_events_dir()
>
> Next, two commits adding a couple of useful helpers, the next three addin=
g
> the infrastructure and the rest consists of per-filesystem conversions.
>
> [3/54] new helper: simple_remove_by_name()
> [4/54] new helper: simple_done_creating()
>         end_creating_path() analogue for internal object creation; unlike
> end_creating_path() no mount is passed to it (or guaranteed to exist, for
> that matter - it might be used during the filesystem setup, before the
> superblock gets attached to any mounts).
>
> Infrastructure:
> [5/54] introduce a flag for explicitly marking persistently pinned dentri=
es
>         * introduce the new flag
>         * teach shrink_dcache_for_umount() to handle it (i.e. remove
> and drop refcount on anything that survives to umount with that flag
> still set)
>         * teach kill_litter_super() that anything with that flag does
> *not* need to be unpinned.
> [6/54] primitives for maintaining persisitency
>         * d_make_persistent(dentry, inode) - bump refcount, mark persiste=
nt
> and make hashed positive.  Return value is a borrowed reference to dentry=
;
> it can be used until something removes persistency (at the very least,
> until the parent gets unlocked, but some filesystems may have stronger
> exclusion).
>         * d_make_discardable() - remove persistency mark and drop referen=
ce.
>
> NOTE: at that stage d_make_discardable() does not reject dentries not
> marked persistent - it acts as if the mark been set.
>
> Rationale: less noise in series splitup that way.  We want (and on the
> next commit will get) simple_unlink() to do the right thing - remove
> persistency, if it's there.  However, it's used by many filesystems.
> We would have either to convert them all at once or split simple_unlink()
> into "want persistent" and "don't want persistent" versions, the latter
> being the old one.  In the course of the series almost all callers
> would migrate to the replacement, leaving only two pathological cases
> with the old one.  The same goes for simple_rmdir() (two callers left in
> the end), simple_recursive_removal() (all callers gone in the end), etc.
> That's a lot of noise and it's easier to start with d_make_discardable()
> quietly accepting non-persistent dentries, then, in the end, add private
> copies of simple_unlink() and simple_rmdir() for two weird users (configf=
s
> and apparmorfs) and have those use dput() instead of d_make_discardable()=
.
> At that point we'd be left with all callers of d_make_discardable()
> always passing persistent dentries, allowing to add a warning in it.
>
> [7/54] convert simple_{link,unlink,rmdir,rename,fill_super}() to new prim=
itives
>         See above re quietly accepting non-peristent dentries in
> simple_unlink(), simple_rmdir(), etc.
>
>         Converting filesystems:
> [8/54] convert ramfs and tmpfs
> [9/54] procfs: make /self and /thread_self dentries persistent
> [10/54] configfs, securityfs: kill_litter_super() not needed
> [11/54] convert xenfs
> [12/54] convert smackfs
> [13/54] convert hugetlbfs
> [14/54] convert mqueue
> [15/54] convert bpf
> [16/54] convert dlmfs
> [17/54] convert fuse_ctl
> [18/54] convert pstore
> [19/54] convert tracefs
> [20/54] convert debugfs
> [21/54] debugfs: remove duplicate checks in callers of start_creating()
> [22/54] convert efivarfs
> [23/54] convert spufs
> [24/54] convert ibmasmfs
> [25/54] ibmasmfs: get rid of ibmasmfs_dir_ops
> [26/54] convert devpts
> [27/54] binderfs: use simple_start_creating()
> [28/54] binderfs_binder_ctl_create(): kill a bogus check
> [29/54] convert binderfs
> [30/54] autofs_{rmdir,unlink}: dentry->d_fsdata->dentry =3D=3D dentry the=
re
> [31/54] convert autofs
> [32/54] convert binfmt_misc
> [33/54] selinuxfs: don't stash the dentry of /policy_capabilities
> [34/54] selinuxfs: new helper for attaching files to tree
> [35/54] convert selinuxfs
>
>         Several functionfs fixes, before converting it, to make life
> simpler for backporting:
> [36/54] functionfs: don't abuse ffs_data_closed() on fs shutdown
> [37/54] functionfs: don't bother with ffs->ref in ffs_data_{opened,closed=
}()
> [38/54] functionfs: need to cancel ->reset_work in ->kill_sb()
> [39/54] functionfs: fix the open/removal races
>
>         ... and back to filesystems conversions:
>
> [40/54] functionfs: switch to simple_remove_by_name()
> [41/54] convert functionfs
> [42/54] gadgetfs: switch to simple_remove_by_name()
> [43/54] convert gadgetfs
> [44/54] hypfs: don't pin dentries twice
> [45/54] hypfs: switch hypfs_create_str() to returning int
> [46/54] hypfs: swich hypfs_create_u64() to returning int
> [47/54] convert hypfs
> [48/54] convert rpc_pipefs
> [49/54] convert nfsctl
> [50/54] convert rust_binderfs
>
>         ... and no kill_litter_super() callers remain, so we
> can take it out:
> [51/54] get rid of kill_litter_super()
>
>         Followups:
> [52/54] convert securityfs
>         That was the last remaining user of simple_recursive_removal()
> that did *not* mark things persistent.  Now the only places where
> d_make_discardable() is still called for dentries that are not marked
> persistent are the calls of simple_{unlink,rmdir}() in configfs and
> apparmorfs.
>
> [53/54] kill securityfs_recursive_remove()
>         Unused macro...
>
> [54/54] d_make_discardable(): warn if given a non-persistent dentry
>
> At this point there are very few call chains that might lead to
> d_make_discardable() on a dentry that hadn't been made persistent:
> calls of simple_unlink() and simple_rmdir() in configfs and
> apparmorfs.
>
> Both filesystems do pin (part of) their contents in dcache, but
> they are currently playing very unusual games with that.  Converting
> them to more usual patterns might be possible, but it's definitely
> going to be a long series of changes in both cases.
>
> For now the easiest solution is to have both stop using simple_unlink()
> and simple_rmdir() - that allows to make d_make_discardable() warn
> when given a non-persistent dentry.
>
> Rather than giving them full-blown private copies (with calls of
> d_make_discardable() replaced with dput()), let's pull the parts of
> simple_unlink() and simple_rmdir() that deal with timestamps and link
> counts into separate helpers (__simple_unlink() and __simple_rmdir()
> resp.) and have those used by configfs and apparmorfs.
>

Hi Al, when I apply this patchset my Pixel 6 no longer enumerates on
lsusb or ADB. It was quite hard to bisect to this point, as this is
non-deterministic and seems to be setup specific. Note, I am using
android-mainline, but my understanding is that this build does not
have any out-of-tree USB patches, and that there are no vendor hooks
in the build.

My apologies as I can't offer any other clues; there are no obviously
bad dmesg logs and I'm still working on narrowing down the exact
commit(s) that started this, but just wanted to send a FYI in case
something stands out as obvious.

Thanks!
Sam

