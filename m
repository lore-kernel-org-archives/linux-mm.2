Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68FEFF9B617
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 10:49:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D7056B00A7; Wed, 22 Apr 2026 06:49:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 987E46B00A8; Wed, 22 Apr 2026 06:49:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89DFB6B00A9; Wed, 22 Apr 2026 06:49:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6FB6B00A7
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 06:49:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A8E51A1276
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:49:12 +0000 (UTC)
X-FDA: 84685869744.18.918C01E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 64F444000B
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:49:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cFIBUW8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776854950; a=rsa-sha256;
	cv=none;
	b=aEP7ZbetRuKk72KWgNNpzE3IdU7+Fz/hMTVj0BXC2SyeEruWbdB186pK86Tu/QLNxWB+38
	NsQ+E8SndHHeC2HygEGaNyiAxYofudmOIPHpvp2+vdq8paZ7OAw/gMLSUCa++wRZlNWOce
	cOrAqstdRaneZAxl+Or84uz006KGNoY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cFIBUW8W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776854950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NfxVEK4qLlLxDtqlXyTJqo+EFxKhaV8IP6TujFHsdtQ=;
	b=JfFFjZcOXx5TsqLmiBjBB74dKhebYuQHzIHGC2Qf16D/LGJijei6/Lo8U6rpxQTyB2WnSQ
	W0oYkmlriCExGdRv3QwM4J6o3PpNLJknjiWizzS2nsHlo2fuT6hAs+RtqJyCSe8kWNO0B6
	oMm7uxp5ResNYtmnPT9s1f0xGIiO8Do=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 536EC44246;
	Wed, 22 Apr 2026 10:49:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DA2C19425;
	Wed, 22 Apr 2026 10:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776854949;
	bh=6qChCjWiVQTZrkRtgEPhex3vx0I/O/K8QVjVHKvTp9c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cFIBUW8WLZUuEOv/Wn8JMOTYg9Xr9yAc7G3UGl0EZ4yzht39tIyhcLppOK45Y+gHo
	 Ow6XPoNQrGY5JXj1bSps0DzZy9ozWg2n1AmhLlquIRYb/fgeCLUv7XCrmqND3Frv5K
	 gNxOpoFphRMLkSI/CipEwZIGvdIXrB9TMWzQvZyTBWcyUx0uuBwPvpIQ5kozlPN4nA
	 VJErjAg4Tvr9kL9mw2pY4yER6wnfQmmgAybc6p14eVSdC9Cqyhyg7m20sTGygD+jCN
	 Rw9r8ddfwsbKUemKTasCGNWn1/BUE6faSCWIYZ/CqjBRm+Kfg5isZBuBnrXJx406gz
	 KpwUzLUw+Q+LA==
Date: Wed, 22 Apr 2026 11:49:06 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yibin Liu <liuyibin@hygon.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, mjguzik@gmail.com, wujianyong@hygon.cn, 
	huangsj@hygon.cn, zhongyuan@hygon.cn
Subject: Re: [PATCH] mm: Add RWH_RMAP_EXCLUDE flag to exclude files from rmap
 sharing
Message-ID: <aeikm2e5Gh5reJ30@lucifer>
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421020932.3212532-1-liuyibin@hygon.cn>
X-Rspamd-Queue-Id: 64F444000B
X-Rspamd-Server: rspam12
X-Stat-Signature: wo68m7qioj5yedm5z66fnfmcjn563spj
X-Rspam-User: 
X-HE-Tag: 1776854950-18100
X-HE-Meta: U2FsdGVkX1+RTIHCCfAHniLZ2WIkT3/6pXyc1zBuHVjAP3UCw6dQC9nrNBLHdPV/KGWu/4/KuCt8BaNI0XqGn4ThFQ42Xedm1th0HR94SgbXqJ/J61YBmdJbNtgbD20HR2j06BfrK4d/F3mLUpQjGcL3s3SOq8osk0bNEbwz/CJl3pjDUXHn6b0j4o2bcl2cSWgZpBem9NhDEI/GHujOlpQF2tyLiCy3q9yepozZlUWMsgCsCYzBL7Te7uU3On0Unm9yMXVJ0CFsGhzvau8fSmvhJ7g5SrkRcKzi8DtZSEIkpinIWtJydQmCI6W/3I23HTPgkI2aNhGWrxpiKq9PSWuxtFHU6M9zV5GV5CoWxmIIIR1VCXDDoqQj968C9hd5bw1qTG6iYSo4YicNHNRzngUEEzu8PuJQqP/Arn3eJ4k86fXDjaiVcQnhom3UsABFhlf9LrSQgAVLsX7AshjNt+8MqogAIgaT1550otWIdtJr0fhu/EZZ8/uUNnK/Q79YW+RdyUPjX6vVvx2TMJJqwkK3DSLoj8JjgQ/1Po5BXiROzHmMj1ctCZQ1viNMg+bfRw7ohUbz1KOwALY3NV61L5+5fEPRzh5jzQ094In1u9jVCejuzkf+um/cadrTO892AIjygydI8Xjg9qatSkKsviw63WVpclhMWTb1lzjKI9cyRArIyRn/3Gd9Stf/c/KpA4Hi+rHKblyhOeAJ4dtZOj50KTDsQCO/qZrdGQF/nrYEMk0VRUI59RDxJVMcWCRtsAOQck+Sn5F96AzkeNbXVJAMYFJO/Qz9xEHeSr6vSfhBRQxaiX1M+xKW9OMuwLjhoTJq5Ozy1dTIlQY9yeI2rP8sKEOz1fbFru+NHSfU6Bj1M5gmDzTZIIwyuxoQawZ/qDB6GM8b+1BLFFF5sFIiRYI57si5Si0TAQhL1z+EKZDcjtdzPEC5Fdosm+C2Q9HWCg0IvJjvQNcwY6rojL4
 pG0n1ewq
 yHlfWBVsu1y2ayyUVcvIBgrHd309WwoTnwKeaxFzFnX7f60Xj4BdFZyHBXawgJ2jibF4BkYwME2/WHd6CpH/M+9aJzZxFpg9eqTSpNqH1S+nDPkb5w6VSB8o9Ef2B74QLwkGYVsvhJRmfl+f6yUzRNE5pwy+pwxoOfj8DakseS2H6Mx57dUY7uHXn19b1bacuuGuE1/XE9y0x+oUKFEo6LotuPVvR5OhfT+JFhVaqjmWs5Ldun8zNDPwBjwE2ya+dRg2NCufLbcSYWqO7j6sqGHxcykxhTaUree4eHEtwROPZY/8JyRF22Z3jT+kr2Iizf5PklQAQTfXjbDZeVDZnF0ZlqMLpsQQDwodQtCEOd4GRe4633R2VyBlZS5BiRk2LQbh61M9EQopLbi781DyJwZzWd3W5uIcxH4pAw3e717Uku5Hp4DdsHt+cvRM+Ho0JivCbmGbBDNoegvfUvPvOHJLQc7bVhSgDbPW4ZrhzQuKA5FcCBr5oRX0TFQ78GxyzqWs/EZaQJ1aheT+MDMfm8xfF1Hpww3oqOB2mRXdEpHE5hBveEzEu1TYYnOBPSEyZLaw2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK obviously.

I hate to keep saying this to people, but you've got no excuse at this stage
it's been a year or so since we added mm maintainers/reviewers and you're not
sending this to the right people.

How hard is doing:

$ scripts/get_maintainer.pl --no-git fs/fcntl.c fs/open.c include/linux/fs.h \
	include/uapi/linux/fcntl.h mm/mmap.c mm/vma.c
Jeff Layton <jlayton@kernel.org> (maintainer:FILE LOCKING (flock() and fcntl()/lockf()))
Chuck Lever <chuck.lever@oracle.com> (maintainer:FILE LOCKING (flock() and fcntl()/lockf()))
Alexander Aring <alex.aring@gmail.com> (reviewer:FILE LOCKING (flock() and fcntl()/lockf()))
Alexander Viro <viro@zeniv.linux.org.uk> (maintainer:FILESYSTEMS (VFS and infrastructure))
Christian Brauner <brauner@kernel.org> (maintainer:FILESYSTEMS (VFS and infrastructure))
Jan Kara <jack@suse.cz> (reviewer:FILESYSTEMS (VFS and infrastructure))
Andrew Morton <akpm@linux-foundation.org> (maintainer:MEMORY MAPPING)
"Liam R. Howlett" <Liam.Howlett@oracle.com> (maintainer:MEMORY MAPPING)
Lorenzo Stoakes <ljs@kernel.org> (maintainer:MEMORY MAPPING)
Vlastimil Babka <vbabka@kernel.org> (reviewer:MEMORY MAPPING)
Jann Horn <jannh@google.com> (reviewer:MEMORY MAPPING)
Pedro Falcato <pfalcato@suse.de> (reviewer:MEMORY MAPPING)
linux-fsdevel@vger.kernel.org (open list:FILE LOCKING (flock() and fcntl()/lockf()))
linux-kernel@vger.kernel.org (open list)
linux-mm@kvack.org (open list:MEMORY MAPPING)

?

You're sending an insane patch that breaks core mm and you can't even send it to
the right people...

(And yet Mateusz is somehow cc'd (he loves that :))

This kind of craziness should be an RFC also as David said.

Both of these things are just rude and not helpful wrt upstream.

On Tue, Apr 21, 2026 at 10:09:32AM +0800, Yibin Liu wrote:
> UnixBench execl/shellscript (dynamically linked binaries) at 64+ cores are
> bottlenecked on the i_mmap_rwsem semaphore due to heavy vma insert/remove
> operations on the i_mmap tree, where libc.so.6 is the most frequent,
> followed by ld-linux-x86-64.so.2 and the test executable itself.

OK that's good to know, but please provide _actual data_. Hand waving isn't ok.

>
> This patch marks such files to skip rmap operations, avoiding frequent
> interval tree insert/remove that cause i_mmap_rwsem lock contention.

OK that's totally insane.

This is a classic example of 'I have problem X, therefore <do something insane
that happens to addess X>'.

> The downside is these files can no longer be reclaimed (along with compact
> and ksm), but since they are small and resident anyway, it's acceptable.
> When all mapping processes exit, files can still be reclaimed normally.
>

Yeah, that's quite the bloody downside. And 'they're small and resident
anyway'... err what on earth makes that a thing?

Also as Matthew points out, you're impacting _everybody else_, you're giving
avenues for unprivileged users to trigger total kernel lockups, you're breaking
migration, you're breaking reclaim, you're breaking basically all of rmap to fix
a performance issue.

> Performance testing shows ~80% improvement in UnixBench execl/shellscript
> scores on Hygon 7490, AMD zen4 9754 and Intel emerald rapids platform.

Yeah ok, I'm sure if I remove rmap altogether I'll get even better numbers :)

I can also take the oxygen system out of a plane and make it way more fuel
efficient!

>
> Signed-off-by: Yibin Liu <liuyibin@hygon.cn>
> ---
>  fs/fcntl.c                 | 1 +
>  fs/open.c                  | 6 ++++++
>  include/linux/fs.h         | 3 +++
>  include/uapi/linux/fcntl.h | 1 +
>  mm/mmap.c                  | 3 ++-
>  mm/vma.c                   | 8 +++++---
>  6 files changed, 18 insertions(+), 4 deletions(-)
>
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index beab8080badf..9b7cc1544735 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -349,6 +349,7 @@ static bool rw_hint_valid(u64 hint)
>  	case RWH_WRITE_LIFE_MEDIUM:
>  	case RWH_WRITE_LIFE_LONG:
>  	case RWH_WRITE_LIFE_EXTREME:
> +	case RWH_RMAP_EXCLUDE:
>  		return true;
>  	default:
>  		return false;
> diff --git a/fs/open.c b/fs/open.c
> index 681d405bc61e..643ab7c6b461 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -46,6 +46,10 @@ int do_truncate(struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (length < 0)
>  		return -EINVAL;
>
> +	/* Prevent truncate on files marked as RMAP_EXCLUDE (e.g., libc, ld.so) */

Prevent truncation :)

RMAP_EXCLUDE :)))

Seriously no.

> +	if (filp && (filp->f_mode & FMODE_RMAP_EXCLUDE))
> +		return -EPERM;
> +
>  	newattrs.ia_size = length;
>  	newattrs.ia_valid = ATTR_SIZE | time_attrs;
>  	if (filp) {
> @@ -892,6 +896,8 @@ static int do_dentry_open(struct file *f,
>  	path_get(&f->f_path);
>  	f->f_inode = inode;
>  	f->f_mapping = inode->i_mapping;
> +	if (inode->i_write_hint == RWH_RMAP_EXCLUDE)
> +		f->f_mode |= FMODE_RMAP_EXCLUDE;
>  	f->f_wb_err = filemap_sample_wb_err(f->f_mapping);
>  	f->f_sb_err = file_sample_sb_err(f);
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 11559c513dfb..d5c9e5a4c2b9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -189,6 +189,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
>  /* File does not contribute to nr_files count */
>  #define FMODE_NOACCOUNT		((__force fmode_t)(1 << 29))
>
> +/* File should exclude vma from rmap interval tree */
> +#define FMODE_RMAP_EXCLUDE	((__force fmode_t)(1 << 30))
> +
>  /*
>   * The two FMODE_NONOTIFY* define which fsnotify events should not be generated
>   * for an open file. These are the possible values of
> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index aadfbf6e0cb3..4969b4762071 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -72,6 +72,7 @@
>  #define RWH_WRITE_LIFE_MEDIUM	3
>  #define RWH_WRITE_LIFE_LONG	4
>  #define RWH_WRITE_LIFE_EXTREME	5
> +#define RWH_RMAP_EXCLUDE	6

As others have pointed out, rmap is not a user API, and it will NEVER be.

>
>  /*
>   * The originally introduced spelling is remained from the first
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 2311ae7c2ff4..3eb00997e86a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1830,7 +1830,8 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
>  				mapping_allow_writable(mapping);
>  			flush_dcache_mmap_lock(mapping);
>  			/* insert tmp into the share list, just after mpnt */
> -			vma_interval_tree_insert_after(tmp, mpnt,
> +			if (!(file->f_mode & FMODE_RMAP_EXCLUDE))
> +				vma_interval_tree_insert_after(tmp, mpnt,

Yeah this is just... this seems completely broken?

I'd be curious to see what sashiko finds for this lord :)

>  					&mapping->i_mmap);
>  			flush_dcache_mmap_unlock(mapping);
>  			i_mmap_unlock_write(mapping);
> diff --git a/mm/vma.c b/mm/vma.c
> index 377321b48734..f1e36e6a8702 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -234,7 +234,8 @@ static void __vma_link_file(struct vm_area_struct *vma,
>  		mapping_allow_writable(mapping);
>
>  	flush_dcache_mmap_lock(mapping);
> -	vma_interval_tree_insert(vma, &mapping->i_mmap);
> +	if (!(vma->vm_file->f_mode & FMODE_RMAP_EXCLUDE))
> +		vma_interval_tree_insert(vma, &mapping->i_mmap);
>  	flush_dcache_mmap_unlock(mapping);
>  }
>
> @@ -339,10 +340,11 @@ static void vma_complete(struct vma_prepare *vp, struct vma_iterator *vmi,
>  			 struct mm_struct *mm)
>  {
>  	if (vp->file) {
> -		if (vp->adj_next)
> +		if (vp->adj_next && !(vp->adj_next->vm_file->f_mode & FMODE_RMAP_EXCLUDE))
>  			vma_interval_tree_insert(vp->adj_next,
>  						 &vp->mapping->i_mmap);
> -		vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);
> +		if (!(vp->vma->vm_file->f_mode & FMODE_RMAP_EXCLUDE))
> +			vma_interval_tree_insert(vp->vma, &vp->mapping->i_mmap);

Hang on, this is struct file * state that impacts folio-granularity behaviour?

I mean ugh anyway.

>  		flush_dcache_mmap_unlock(vp->mapping);
>  	}
>
> --
> 2.34.1
>
>
>

This idea is totally broken.

If you want to contribute usefully, PLEASE drop this silly idea, come back with
some NUMBERS about the contention you see, and let's have a sensible discussion
about what we can do to address that?

Also follow standard upstream kernel procedures - figure out who to email
properly, RFC insane ideas, etc.

Thanks, Lorenzo

