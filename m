Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE7BF532F6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:51:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16DE36B0005; Tue, 24 Mar 2026 04:51:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F8AF6B0088; Tue, 24 Mar 2026 04:51:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F020D6B0089; Tue, 24 Mar 2026 04:51:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D82E66B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:51:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 801D2141859
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:51:43 +0000 (UTC)
X-FDA: 84580338486.08.1C036B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B1AB712000C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:51:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5pA00vr;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774342301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCICq6GziYw2DkMPbM/9imafDghrvczfaD2uxYTB3qw=;
	b=fvBWgUci1jMc/2z6xUnmhATGKEGYmYxujFvZp8+6XovwwW26YZR3MS4rLTwTompPefy62B
	Tp/fkAx18CTB8RMiV7yi2kDnRdZIG4ZZP35Mc/mJLbLj8PYlDtK4bQXjiSq0te131oGmTp
	jluGhBhwD4Z/Ly9qeLetQd9DMQwEAxk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V5pA00vr;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774342301; a=rsa-sha256;
	cv=none;
	b=uWNRC+i2lG2c/D7KRkbjU2twQarJ7iOAzR2zHrvntYLO/rkE9SAhLhP19xRShURb95/Gcd
	k+zqM2yQX34ThwEtMsEv7psdbUtaSYeUhWL+0p1fbFqtFRhoHIJ9YtWZTJNSw/icfMLaDe
	ZD075y1UJeo12gsLMKo3IZSvpwU1h8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AACA643F26;
	Tue, 24 Mar 2026 08:51:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F86DC19424;
	Tue, 24 Mar 2026 08:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774342300;
	bh=MCVEK7Uy7kSgqvx88xO+6jxwJM48WzBfVnlulZ4Y5GU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=V5pA00vrKH1i6oryi7GAHi0gW0eV3NAk1n5gRsgixc4E3kw8aGUwWWIbqmVnYwNl0
	 yqCHvkeu3cdvhJq18BCkmneulFmq4n6EXIWcs/cbp5jVyJ4bn8TLp0S+q59CYf79+5
	 1bxhjAn/+flkbvLD68WAZEa4/P4dm+2tD/ZyMTtZ3xX1P/cdqeu+GenYrQT7lTcSQk
	 XeXzwmRii7IENAyPcRcxW9Lhgj41Lhj4eL82nwKun6N7FbEaa1Hxe1SmEYRrRzdt3t
	 MhSD9/P4q7qSwDwLb6AjALk7kJN3MEB9ynRSLHCYjVK07IyZkBc8/mueVACtsf2EZp
	 za3qldnDkMDOw==
Date: Tue, 24 Mar 2026 09:51:34 +0100
From: Christian Brauner <brauner@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, jack@suse.cz, 
	shuah@kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH 1/2] liveupdate: prevent double management of files
Message-ID: <20260324-langzeitfolgen-altgedienten-ccef17d19349@brauner>
References: <20260321175808.57942-1-pasha.tatashin@soleen.com>
 <20260321175808.57942-2-pasha.tatashin@soleen.com>
 <CA+CK2bD2aNu-NByET4KkBP0n2j8WQE2zjxb4g-1cv2hYfjaRZQ@mail.gmail.com>
 <20260323-leibhaftig-blasinstrument-58ec408b3c40@brauner>
 <CA+CK2bC6S7pFCYR0XS1ZPxw9HKjWgxy=0DkszYNjMUi735o_1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bC6S7pFCYR0XS1ZPxw9HKjWgxy=0DkszYNjMUi735o_1Q@mail.gmail.com>
X-Rspamd-Queue-Id: B1AB712000C
X-Stat-Signature: u9hydaf673mqd9metstgs114didzubfd
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774342301-700401
X-HE-Meta: U2FsdGVkX19/VBxukzIQzz5xCjTOywDlSDmxlSJ4EkwTABHQ3O9ypceU9ousSLFCYhhztLQEeAOa7Nk65w82iFwsy9U01MvfMlPjs8mRo1BAe9X43hWCmAUAnQoRFgnaxrf9VhUd7bWp/+DnNOKO5EXH5CjkmnfiQA9aMffJdVR1rCiXQL7OBrJwCVloaoe05h6iF6w/JgrW0eHcvTjaW6MtbmcXD2zUFrmat+svJ4eqMHYweKGzzvOigaTMAvwWdB3BuSgU6gZVHOqOlLABdO0ZeMkI5KY2uHmTzXog66kL+S4lkkINbTls1zqhZzjlBhHvrSVTjRE9SpqR9RVDT6cDotBa6eIZBS0ZTnUy0gFDi7yyZBsmPA4niLiMfB4gkQ1tr9/s4Xl92sgw+NNH0AE4OpxMgUG8WtjFW6l2isBzASgAy93bXURntIXa0XV/ktRFUOCG41hYPg/R6jgbxDeeXRIM9jpX/MXblMuv+Rpn24LSfeV2chNlHWBhIpt2Ovp5RbGpB3juMXL+xFumxOob7tlXz7g/h+3ZJ8RCBSW/wVwoI+vZHBm+qVcQwDCJtGgEQqphpIUGSI+/RuLwvU5Tom2RI3eA/QtWOR1Qgr5bWYoVdCNwBwqY7dzsRjn52r0atCUpai600rNVx/ZwYmU+28X4U/2o7WXKrSxB5s+krVRewp2WYMdR908N+p+6E+Pnehp4Ed+AAlyI83NW4pmdoea+7L5mUeeUqLOkS1vQUP7FtW0wrqoShaTSsNxONOt4lcxAAXQCloHAE2Lr9sSSebR84pVoZVPEZoGlP9acRRaO8+EHPdqLyqi0IkKNa9wdSl/GVpgLWtbD3YfYJvSHKcL3KNOtgiSci6k88an1iFz/ock071dWwFXnGwh0ZtgR7EvQuNw0Dnm4C4s4k0a9r+beSYMOZbVfp9NIuc3dUr2Vsc1gggiQHEW+q7YjKNMm0aU0byzoBduUyiA
 K6aveJU6
 ud478+Mqop5gTYW2erO91C9/pfkV+tps9GDtRmmCyE6lp9JFdAnw62rx5CZ05kAY/x0twcTv7TTgSlqoDs9HiXutrM5a8HpRzgPl6a6ZgE2juIVlvELhEHvhbhK1z/LYuPWXRtDBcrDDAmruyNu1IZJoRqclY1BreuP6Tq/pd6di6e7OtmUOj+4agI01FQD+xpYgWb/4EbWLkmUJcmudsiJqXsC2OBh+zKnDUemmNUVUuSvvOQZaUimm2qqwku18NvrIX4gYmBCo5yg/JuKqBeoZqJjft17+Xx/zh3QLJa8ZrjS7S9S3cMeWjlCROSl7W5ZV3bep4s6RtNE+wR06c6cvnd4jmFKS6CAswYUGycrUM/Gh7k0L5xVlK8IhWa+lVUf3vTK6QZyK/siheH1JfXLkZmnMe8mEZ4kXuUxTFvPBsu5BL6xoQXhn+t7D1+rTIhzRs1+7SE84UppeSYxSdJD1ZyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 23, 2026 at 09:18:03AM -0400, Pasha Tatashin wrote:
> On Mon, Mar 23, 2026 at 7:55 AM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Sat, Mar 21, 2026 at 09:04:53PM -0400, Pasha Tatashin wrote:
> > > On Sat, Mar 21, 2026 at 1:58 PM Pasha Tatashin
> > > <pasha.tatashin@soleen.com> wrote:
> > > >
> > > > Currently, LUO does not prevent the same file from being managed twice
> > > > across different active sessions.
> > > >
> > > > Add a new i_state flag I_LUO_MANAGED and update luo_preserve_file()
> > > > to check and set this flag when a file is preserved, and clear it in
> > > > luo_file_unpreserve_files() when it is released.
> > > >
> > > > Additionally, set this flag in luo_retrieve_file() after a file is
> > > > successfully restored in the new kernel, and clear it in
> > > > luo_file_finish() when the LUO session is finalized.
> > > >
> > > > This ensures that the same file (inode) cannot be managed by multiple
> > > > sessions. If another session attempts to preserve an already managed
> > > > file, it will now fail with -EBUSY.
> > > >
> > > > Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> > > > Acked-by: Jan Kara <jack@suse.cz>
> > > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > > ---
> > > >  include/linux/fs.h           |  5 ++++-
> > > >  kernel/liveupdate/luo_file.c | 27 ++++++++++++++++++++++++---
> > > >  2 files changed, 28 insertions(+), 4 deletions(-)
> > > >
> > > > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > > > index 23f36a2613a3..692a8be56f3c 100644
> > > > --- a/include/linux/fs.h
> > > > +++ b/include/linux/fs.h
> > > > @@ -712,6 +712,8 @@ is_uncached_acl(struct posix_acl *acl)
> > > >   * I_LRU_ISOLATING     Inode is pinned being isolated from LRU without holding
> > > >   *                     i_count.
> > > >   *
> > > > + * I_LUO_MANAGED       Inode is being managed by a live update session.
> > > > + *
> > > >   * Q: What is the difference between I_WILL_FREE and I_FREEING?
> > > >   *
> > > >   * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
> > > > @@ -744,7 +746,8 @@ enum inode_state_flags_enum {
> > > >         I_CREATING              = (1U << 15),
> > > >         I_DONTCACHE             = (1U << 16),
> > > >         I_SYNC_QUEUED           = (1U << 17),
> > > > -       I_PINNING_NETFS_WB      = (1U << 18)
> > > > +       I_PINNING_NETFS_WB      = (1U << 18),
> > > > +       I_LUO_MANAGED           = (1U << 19),
> > > >  };
> > > >
> > > >  #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
> > > > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> > > > index 5acee4174bf0..86911beeff71 100644
> > > > --- a/kernel/liveupdate/luo_file.c
> > > > +++ b/kernel/liveupdate/luo_file.c
> > > > @@ -248,6 +248,7 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
> > > >   * Context: Can be called from an ioctl handler during normal system operation.
> > > >   * Return: 0 on success. Returns a negative errno on failure:
> > > >   *         -EEXIST if the token is already used.
> > > > + *         -EBUSY if the file descriptor is already preserved by another session.
> > > >   *         -EBADF if the file descriptor is invalid.
> > > >   *         -ENOSPC if the file_set is full.
> > > >   *         -ENOENT if no compatible handler is found.
> > > > @@ -276,6 +277,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> > > >         if (err)
> > > >                 goto  err_fput;
> > > >
> > > > +       scoped_guard(spinlock, &file_inode(file)->i_lock) {
> > > > +               if (inode_state_read(file_inode(file)) & I_LUO_MANAGED) {
> > > > +                       err = -EBUSY;
> > > > +                       goto err_free_files_mem;
> > > > +               }
> > > > +               inode_state_set(file_inode(file), I_LUO_MANAGED);
> > > > +       }
> > > > +
> > > >         err = -ENOENT;
> > > >         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> > > >                 if (fh->ops->can_preserve(fh, file)) {
> > > > @@ -286,11 +295,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> > > >
> > > >         /* err is still -ENOENT if no handler was found */
> > > >         if (err)
> > > > -               goto err_free_files_mem;
> > > > +               goto err_unpreserve_inode;
> > > >
> > > >         err = luo_flb_file_preserve(fh);
> > > >         if (err)
> > > > -               goto err_free_files_mem;
> > > > +               goto err_unpreserve_inode;
> > > >
> > > >         luo_file = kzalloc_obj(*luo_file);
> > > >         if (!luo_file) {
> > > > @@ -320,6 +329,9 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> > > >         kfree(luo_file);
> > > >  err_flb_unpreserve:
> > > >         luo_flb_file_unpreserve(fh);
> > > > +err_unpreserve_inode:
> > > > +       scoped_guard(spinlock, &file_inode(file)->i_lock)
> > > > +               inode_state_clear(file_inode(file), I_LUO_MANAGED);
> > > >  err_free_files_mem:
> > > >         luo_free_files_mem(file_set);
> > > >  err_fput:
> > > > @@ -363,6 +375,9 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
> > > >                 luo_file->fh->ops->unpreserve(&args);
> > > >                 luo_flb_file_unpreserve(luo_file->fh);
> > > >
> > > > +               scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
> > > > +                       inode_state_clear(file_inode(luo_file->file), I_LUO_MANAGED);
> > > > +
> > > >                 list_del(&luo_file->list);
> > > >                 file_set->count--;
> > > >
> > > > @@ -609,6 +624,9 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
> > > >         *filep = luo_file->file;
> > > >         luo_file->retrieve_status = 1;
> > > >
> > > > +       scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
> > > > +               inode_state_set(file_inode(luo_file->file), I_LUO_MANAGED);
> > > > +
> > > >         return 0;
> > > >  }
> > > >
> > > > @@ -701,8 +719,11 @@ int luo_file_finish(struct luo_file_set *file_set)
> > > >
> > > >                 luo_file_finish_one(file_set, luo_file);
> > > >
> > > > -               if (luo_file->file)
> > > > +               if (luo_file->file) {
> > > > +                       scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
> > > > +                               inode_state_clear(file_inode(luo_file->file), I_LUO_MANAGED);
> > > >                         fput(luo_file->file);
> > > > +               }
> > > >                 list_del(&luo_file->list);
> > > >                 file_set->count--;
> > > >                 mutex_destroy(&luo_file->mutex);
> > > > --
> > > > 2.43.0
> > > >
> > >
> > > > Sashiko: https://sashiko.dev/#/patchset/20260321175808.57942-1-pasha.tatashin@soleen.com
> > >
> > > Sashiko reported two problems:
> > >
> > > 1. Are there any issues with mixing goto-based error handling and scope-based
> > > cleanups like scoped_guard() in the same function?
> > >
> > > Initially, I thought that there should not be any problems, however,
> > > after looking this up  I found in include/linux/cleanup.h the
> > > following comment:
> > >
> > >  * Lastly, given that the benefit of cleanup helpers is removal of
> > >  * "goto", and that the "goto" statement can jump between scopes, the
> > >  * expectation is that usage of "goto" and cleanup helpers is never
> > >  * mixed in the same function.
> >
> > There's a compile-time switch you might want to turn on when
> > test-compiling code like this. I forget exactly what it is. Something
> > like jump-over-uninit or something.
> >
> > >
> > > Well, good to know, will not use goto inside scoped_guards.
> > >
> > > 2. Additionally, does setting I_LUO_MANAGED on the inode break the preservation
> > > of anonymous inodes? Many file types (like eventfd, epoll, timerfd,
> > > signalfd)
> > >
> > > This is actually a very good point. It looks like everyone who uses
> > > anon_inode_getfd() has one shared inode. This is not a problem for the
> > > existing LUO user memfd, or for the upcoming vfiofd and memfd, but
> > > kvm-vmfd and kvm-cpufd also use it, and that might be a problem in the
> > > future once we add support for Orphaned VMs.
> > >
> > > Therefore, we have two choices: either use a hash table, which adds
> > > performance and memory overhead, or delegate this double-check to the
> > > LUO file handlers, as they can use a private context to know if the FD
> > > is already preserved.
> >
> > So, I'm not happy about I_LUO_MANAGED. I don't think we need driver
> > specific stuff in struct inode and not in i_state. Track this in the
> > driver please. I don't want this precedent and I'd rather have you get
> 
> I am planning to use an xarray in the next version.
> 
> > used to implementing such things in the driver right away rather than
> > offloading this on general infrastructure. If we let this slide struct
> > inode will be 2MB 1 in year.
> 
> Claiming that a single flag bit precedent would cause the overall
> struct to grow by 2MB in a year is a slight exaggeration. :-)

Hm, you say that. But then you don't get ~5-10 patches a year that "just
add a new member into struct inode with 4-8 bytes"... I'm just making an
exaggerated point ofc. :)

But struct inode is used everywhere and I want it contained and small
and whatever lands in it - even flags - better be VFS generic stuff.

We sometimes do carve out exceptions for _filesystem drivers_ where no
other way is possible ofc. But I don't think this should extend to
drivers/.

