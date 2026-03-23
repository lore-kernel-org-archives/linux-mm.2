Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B6DFEC01D4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:55:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFB96B0005; Mon, 23 Mar 2026 07:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C7306B0088; Mon, 23 Mar 2026 07:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004026B0089; Mon, 23 Mar 2026 07:55:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E25566B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:55:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A52D1A0B21
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:55:27 +0000 (UTC)
X-FDA: 84577172694.29.9E2D9FC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id EC9A680004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:55:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P2CHj8I3;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774266926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJzBMjJqwFqyDS3ZJtM5S1HaRpX29szPufOdpa9GTxg=;
	b=c2bh4yaW3ea1b5sc4hgEqd21CTIDo3QhSEYMYBPyzv5W1rYFjHHVt5Dr3ZtSL1tEUIMnk3
	vcdoP6DxRUvpeKQcOAmJGBtdy5FWqQSvYfnd1Hngtp1c2eEP5f7Nq7BSUrN0Mo43hhQURJ
	bQetZpwFeAvBAC8rP7YLtpeKASXLdpc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P2CHj8I3;
	spf=pass (imf30.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774266926; a=rsa-sha256;
	cv=none;
	b=VSeElZb6+Dif6F89gVSILVXZUgnoHtT4yNWPnJROcLNt4ZKqvyY+8ao8xO8glnouxEsbyI
	/7UKQ4NZOPgNUlrQnR3DD0DUIcdKxY5WkxmTZLwzi1nCKY2BI9LILtMVk6TXOjMo0b2i33
	MtJk6zQ5NG2UG1rSeISioo6G4lRT1Io=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA9D34349E;
	Mon, 23 Mar 2026 11:55:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A836EC2BC87;
	Mon, 23 Mar 2026 11:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774266924;
	bh=bahApTubTticio0sVoZJb/hsbDwoUtqdY4Hts04ODXU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P2CHj8I3muInS7y71I3yS3gwqHMY0uIqERIm59nw/er97JTRza3uuynKvKtF+r5n5
	 VeGTzHoWdLBnhGtbi9efO9UV9ybgiBKN/AAk1Vp6lMmaRSEq/ZL2D9MTLH4g2gQ2hh
	 u+F0glNrLepJJI2DxEHhbSGb7FxJUsxXqrGgpygPv+TrbKGhyX2q1T13l3a6zTWC0i
	 GTuiU4JXVmwTjYKPz2ZONnAPZ+i2mWvxhiAIaDWKA/02eCcuD5k7MPvXPQw587uTG3
	 WxMrKveh4d37l48vppTcTSgJseXXSnvOFc+Vn7rQu+sRHekx5M43mQOPnX1fDandM7
	 sL5WLjVHl6uxg==
Date: Mon, 23 Mar 2026 12:55:18 +0100
From: Christian Brauner <brauner@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, jack@suse.cz, 
	shuah@kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org, 
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org, 
	dmatlack@google.com, pratyush@kernel.org, skhawaja@google.com
Subject: Re: [PATCH 1/2] liveupdate: prevent double management of files
Message-ID: <20260323-leibhaftig-blasinstrument-58ec408b3c40@brauner>
References: <20260321175808.57942-1-pasha.tatashin@soleen.com>
 <20260321175808.57942-2-pasha.tatashin@soleen.com>
 <CA+CK2bD2aNu-NByET4KkBP0n2j8WQE2zjxb4g-1cv2hYfjaRZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bD2aNu-NByET4KkBP0n2j8WQE2zjxb4g-1cv2hYfjaRZQ@mail.gmail.com>
X-Rspamd-Queue-Id: EC9A680004
X-Stat-Signature: 7ucyinrnj7wukmfhi58mbwzpgjsu5e53
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774266925-905254
X-HE-Meta: U2FsdGVkX1/rWvOp3V6zQZmpi66OIne1BnnYD8HTLuvVau/Hq1dokB5VsA+iGwYKFOI+Tlb0iGkWmTEeEE9YbCfPKV/XJwwOTmTuHrOnBF3lLuGtg+o4kDxdaaSUWvHRDmHfhHLs9Co2z4y6gVCw+sQhRoy+QImTUj84Xr1A/qnI235443lYjmdliM/3dewcRbP3xx8ypReX0u2cK0+RsHlrd0oKVInUEJk4Y/Zu3aSlWrev856hXavXYzfFRG4h23nScUVRigEINdHHYJyU9PwUhw6cmBbAKAwTe7T7L/G3CUMEHDpkPm4IaxWvdsnsZy77MW2sLpCHL1fIiT1WxDafuo7e5hO5690+++UFFkAQdTqnGl5ZpM6VrMyPlzB5aEi1wIYb9CV7aU4OP3YvJRS6sCisxXAf73G9Ma1KURP0YrHtVDr7X6S9YEXh64wpi8C9RdEZAUVrpAExRZCcT3VBJjVnkCflaJxfa0atp6l8gy1MGYwyEU4l8zSlVv6/+wy8gPccjycW3uTwbuVhs8BEdKef1GzlZl2MieWlxYjmxBTVOvW6KqUdS9iBX452Kbihcd03SuD94P6/OvNMBMEwKhTYZSM3mh6xBaK41C868DEEBX/9rzvszha6cuIrue76oq0hloSBqKI6Ao/wwaBeZqc/p0yGMah+cWdJlMw8oA1PcyO6VopOwir3VdvvkT/o/izoY1o7CXa6jxGNAXaDIv0sg80hbbfEL+jSNvNSKwJNi/8e2Kv9UcSkt9lL9/1wL3nfl3oBqLSDycNMyi2ZNmZK1bBdCkyk5Mcgq0gReH39juxeck5S9gchRixoLUJGXWf5zB6DqVvt3eDtkCwEc8cYZ5SGwl5mI34xHyEJ0JdCcK9QFrRXJGEgBQm8ndj6kMX9eRrkrE1YSpWNlaA9n293P1wVmk7cA19o5KcUYf6dcWVe7NTbAJhenCV5CRQ5oU59Mx9XcRa8nDf
 WMizmHBX
 nSQtz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 21, 2026 at 09:04:53PM -0400, Pasha Tatashin wrote:
> On Sat, Mar 21, 2026 at 1:58 PM Pasha Tatashin
> <pasha.tatashin@soleen.com> wrote:
> >
> > Currently, LUO does not prevent the same file from being managed twice
> > across different active sessions.
> >
> > Add a new i_state flag I_LUO_MANAGED and update luo_preserve_file()
> > to check and set this flag when a file is preserved, and clear it in
> > luo_file_unpreserve_files() when it is released.
> >
> > Additionally, set this flag in luo_retrieve_file() after a file is
> > successfully restored in the new kernel, and clear it in
> > luo_file_finish() when the LUO session is finalized.
> >
> > This ensures that the same file (inode) cannot be managed by multiple
> > sessions. If another session attempts to preserve an already managed
> > file, it will now fail with -EBUSY.
> >
> > Acked-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> > Acked-by: Jan Kara <jack@suse.cz>
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/fs.h           |  5 ++++-
> >  kernel/liveupdate/luo_file.c | 27 ++++++++++++++++++++++++---
> >  2 files changed, 28 insertions(+), 4 deletions(-)
> >
> > diff --git a/include/linux/fs.h b/include/linux/fs.h
> > index 23f36a2613a3..692a8be56f3c 100644
> > --- a/include/linux/fs.h
> > +++ b/include/linux/fs.h
> > @@ -712,6 +712,8 @@ is_uncached_acl(struct posix_acl *acl)
> >   * I_LRU_ISOLATING     Inode is pinned being isolated from LRU without holding
> >   *                     i_count.
> >   *
> > + * I_LUO_MANAGED       Inode is being managed by a live update session.
> > + *
> >   * Q: What is the difference between I_WILL_FREE and I_FREEING?
> >   *
> >   * __I_{SYNC,NEW,LRU_ISOLATING} are used to derive unique addresses to wait
> > @@ -744,7 +746,8 @@ enum inode_state_flags_enum {
> >         I_CREATING              = (1U << 15),
> >         I_DONTCACHE             = (1U << 16),
> >         I_SYNC_QUEUED           = (1U << 17),
> > -       I_PINNING_NETFS_WB      = (1U << 18)
> > +       I_PINNING_NETFS_WB      = (1U << 18),
> > +       I_LUO_MANAGED           = (1U << 19),
> >  };
> >
> >  #define I_DIRTY_INODE (I_DIRTY_SYNC | I_DIRTY_DATASYNC)
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> > index 5acee4174bf0..86911beeff71 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -248,6 +248,7 @@ static bool luo_token_is_used(struct luo_file_set *file_set, u64 token)
> >   * Context: Can be called from an ioctl handler during normal system operation.
> >   * Return: 0 on success. Returns a negative errno on failure:
> >   *         -EEXIST if the token is already used.
> > + *         -EBUSY if the file descriptor is already preserved by another session.
> >   *         -EBADF if the file descriptor is invalid.
> >   *         -ENOSPC if the file_set is full.
> >   *         -ENOENT if no compatible handler is found.
> > @@ -276,6 +277,14 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >         if (err)
> >                 goto  err_fput;
> >
> > +       scoped_guard(spinlock, &file_inode(file)->i_lock) {
> > +               if (inode_state_read(file_inode(file)) & I_LUO_MANAGED) {
> > +                       err = -EBUSY;
> > +                       goto err_free_files_mem;
> > +               }
> > +               inode_state_set(file_inode(file), I_LUO_MANAGED);
> > +       }
> > +
> >         err = -ENOENT;
> >         list_private_for_each_entry(fh, &luo_file_handler_list, list) {
> >                 if (fh->ops->can_preserve(fh, file)) {
> > @@ -286,11 +295,11 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >
> >         /* err is still -ENOENT if no handler was found */
> >         if (err)
> > -               goto err_free_files_mem;
> > +               goto err_unpreserve_inode;
> >
> >         err = luo_flb_file_preserve(fh);
> >         if (err)
> > -               goto err_free_files_mem;
> > +               goto err_unpreserve_inode;
> >
> >         luo_file = kzalloc_obj(*luo_file);
> >         if (!luo_file) {
> > @@ -320,6 +329,9 @@ int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd)
> >         kfree(luo_file);
> >  err_flb_unpreserve:
> >         luo_flb_file_unpreserve(fh);
> > +err_unpreserve_inode:
> > +       scoped_guard(spinlock, &file_inode(file)->i_lock)
> > +               inode_state_clear(file_inode(file), I_LUO_MANAGED);
> >  err_free_files_mem:
> >         luo_free_files_mem(file_set);
> >  err_fput:
> > @@ -363,6 +375,9 @@ void luo_file_unpreserve_files(struct luo_file_set *file_set)
> >                 luo_file->fh->ops->unpreserve(&args);
> >                 luo_flb_file_unpreserve(luo_file->fh);
> >
> > +               scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
> > +                       inode_state_clear(file_inode(luo_file->file), I_LUO_MANAGED);
> > +
> >                 list_del(&luo_file->list);
> >                 file_set->count--;
> >
> > @@ -609,6 +624,9 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
> >         *filep = luo_file->file;
> >         luo_file->retrieve_status = 1;
> >
> > +       scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
> > +               inode_state_set(file_inode(luo_file->file), I_LUO_MANAGED);
> > +
> >         return 0;
> >  }
> >
> > @@ -701,8 +719,11 @@ int luo_file_finish(struct luo_file_set *file_set)
> >
> >                 luo_file_finish_one(file_set, luo_file);
> >
> > -               if (luo_file->file)
> > +               if (luo_file->file) {
> > +                       scoped_guard(spinlock, &file_inode(luo_file->file)->i_lock)
> > +                               inode_state_clear(file_inode(luo_file->file), I_LUO_MANAGED);
> >                         fput(luo_file->file);
> > +               }
> >                 list_del(&luo_file->list);
> >                 file_set->count--;
> >                 mutex_destroy(&luo_file->mutex);
> > --
> > 2.43.0
> >
> 
> > Sashiko: https://sashiko.dev/#/patchset/20260321175808.57942-1-pasha.tatashin@soleen.com
> 
> Sashiko reported two problems:
> 
> 1. Are there any issues with mixing goto-based error handling and scope-based
> cleanups like scoped_guard() in the same function?
> 
> Initially, I thought that there should not be any problems, however,
> after looking this up  I found in include/linux/cleanup.h the
> following comment:
> 
>  * Lastly, given that the benefit of cleanup helpers is removal of
>  * "goto", and that the "goto" statement can jump between scopes, the
>  * expectation is that usage of "goto" and cleanup helpers is never
>  * mixed in the same function.

There's a compile-time switch you might want to turn on when
test-compiling code like this. I forget exactly what it is. Something
like jump-over-uninit or something.

> 
> Well, good to know, will not use goto inside scoped_guards.
> 
> 2. Additionally, does setting I_LUO_MANAGED on the inode break the preservation
> of anonymous inodes? Many file types (like eventfd, epoll, timerfd,
> signalfd)
> 
> This is actually a very good point. It looks like everyone who uses
> anon_inode_getfd() has one shared inode. This is not a problem for the
> existing LUO user memfd, or for the upcoming vfiofd and memfd, but
> kvm-vmfd and kvm-cpufd also use it, and that might be a problem in the
> future once we add support for Orphaned VMs.
> 
> Therefore, we have two choices: either use a hash table, which adds
> performance and memory overhead, or delegate this double-check to the
> LUO file handlers, as they can use a private context to know if the FD
> is already preserved.

So, I'm not happy about I_LUO_MANAGED. I don't think we need driver
specific stuff in struct inode and not in i_state. Track this in the
driver please. I don't want this precedent and I'd rather have you get
used to implementing such things in the driver right away rather than
offloading this on general infrastructure. If we let this slide struct
inode will be 2MB 1 in year.

