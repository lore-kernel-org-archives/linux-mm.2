Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3520C5CFDB
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 12:38:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E267B6B069E; Fri, 14 Aug 2026 08:38:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7516B06A1; Fri, 14 Aug 2026 08:38:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC5FC6B06A2; Fri, 14 Aug 2026 08:38:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A44DF6B069E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 08:38:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 278D540437
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:38:00 +0000 (UTC)
X-FDA: 85099827120.21.9D6AE57
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 650FE40009
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 12:37:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dr7Yrv+8;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786711078;
	b=w79aGzAtfeLiY/BkebrjbBfafxI87Dfn/hrtY+NoiFp/mfrpasdVeuIEYEXZI9cCQOnjWp
	T2wCW7zu5AdeYE0VmcEDzvqQiBGINCvXI9oAMeO0/jP+pHOMH6NXA1wVXX6NnUkCOUyeXC
	LhnPD7sOTtOs4LfEwIeYhQA4RfOJ14I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dr7Yrv+8;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786711078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ok+ILBQSUeIltN5l1xpDpnDyA3k7f++vYkrD24qAu/I=;
	b=tyLv6oqREO4uhJS0fFUjHmdBNK9+NIQYynK7HF2EO/nAxV7ZUJBjfL7M8Gwv370W4lNlwj
	HB/r7zZTXPlJuPXnXLO5Vk47TB3n0qJJFm0Sk2qZgege9Ab9nDthjfE/bFSkQBmVra48Vf
	y3h4v08JRwA0sTikwtKl7RVCWOLnmZo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E33C942A1A;
	Fri, 14 Aug 2026 12:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511671F000E9;
	Fri, 14 Aug 2026 12:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786711076;
	bh=Ok+ILBQSUeIltN5l1xpDpnDyA3k7f++vYkrD24qAu/I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dr7Yrv+8EXF7hMDL8QCQvfMzmtcOJaPzVR65QidqD8LC7nWWkWS14eMOZqf5cUpz5
	 nbqRb3RjQ8gAIyz8raAfucAtMihNh7Q6JfLVTM3XKb8kGGHLxVDlGN+vhK/nrovupd
	 7KsHKtCHWM8yXwZVs5QI2VLijf6GKNid2K0CKcFBxVqqSJIXCF42qAA40NTSsLL0HE
	 1sqc/Zz7fLCrzmZ5MN8t562VAa6/SHC4qzayspqOplFyNqJ+M3k9QiQ5OBrLzlsx0L
	 ajrlJ8IC1Pe8xhlQgrJGBIRVDVssxRjTcnmkZiOM0DQm2BwsM8L/1gnX2uyL0bDYHZ
	 IgMHPhZtXDb5Q==
Date: Fri, 14 Aug 2026 13:37:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: linux-mm@kvack.org, geert@linux-m68k.org, daniel@thingy.jp, 
	Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 3/6] mm: nommu: fix an issue on map request to
 /dev/zero
Message-ID: <an8BlTgk7sc5vFJ1@lucifer>
References: <20260813063401.1786548-1-thehajime@gmail.com>
 <20260813063401.1786548-4-thehajime@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813063401.1786548-4-thehajime@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 650FE40009
X-Stat-Signature: qu5ockbr4gw5qgr59zwidc13tt5w1wmn
X-HE-Tag: 1786711078-477688
X-HE-Meta: U2FsdGVkX1+4BCaxvDlf63btXtM1/rLjRi3rSZ+JOTxTdB6rr8VxCGrfL/F0vIgbUstzrfcJW6+uSHFv9+lWqihUK4XCfxA7Cr+xY92ZTS9rVKi0zDMThKCAhNyVU89OTNaLU6tLMP+r0b2TKOVA2LCbNfFkCexbom22R/hldzu9fkBHjyirpeXwL031K4IGr1GwZc7lvvUX5WkSgbl0hQeuPqJm4qDMc5d9T41XHFbspyCdtCEzXRxZFid1iO+ZH0pQUQjayVoIo767oJXYDSlPGPhfSDxh0DjQn2WVBYDbCkk5yD7savQLDTIFwXzW78RZshxfpi588fxfuMQARH0S1Vvz13/tnco2lbK3tJRCcRV4Jd/7ivi6Es1ROx8mXot7Fi8hLwOFx7eWdHZAsGVDK10iHFZHBAWvFQMiC3oK/h0HG6LmB/D9wrCGIF42qRGDmtWrmY00SL2WOEl8CF+P5vXdbSPibNmFQQgg1dCMh3ClBQHNl8bczEoO+LQYMIw0CbRneDBTUiotnJXVs0Twdyy1wuZlwDzrDKNr8v0xdHWjMnjr5SxeVxsZ20+fYSBb0BDq4rQf6y2fcBTc/lsKKOFiFbgeqI0W+Szv4rz0VIJQG6LHfvAiMTk2+tUNNtlLhdYWtzFm5Bduc3To8WWiOcb8NqWCtuvm2a3BrwsoeytbnbPm0OR4Oywce4shUU8iJdKwxqdvcrDsDP12/tOCQxERo6+aNZRy8+EHPxqoNXsls1K7qNJ0lutA/quSLnQf7cb6rCQBFOpz3ALe1tbEJZshUvQG22i5OkHQ1/Z5SjeaRD9FJf14zmPR55Wd6YwCh+dG0QpEUz1dFPE5V5xtKnicDqtyen3gOBo+Nzra6AX9Uzfc/ICKTT3jPCs0o9LW3Wp96ccVgvt82foMeW7XD0mYxD0JsufFIPa6dUo6MYW/2rBLnvWkUz4DiaOFl9M/dGHf3YFxfs2YnEJ
 fraqvTjB
 dYb7ktDkXgPvPApItBaiYCmoQ9NJqefOvulcN9FQirFWvpNRpl30PPwYm+jDZCQ4b7WcFFso3gnPX7YkvgHC2xCprYbvRZKqAZ92bD8kjJKg8f4yB2oyGwaPD4PNvqn+DUcYmcVnIJmj52TwxYidAdo7WCVqk+ESyiE1mp3JI7+wvzUT/VuYKEYxNYNPa9XQ1WUx46TWLg1A12Le7ntmY64z5gdBoCW96naVd4JxAOJeKBa8CpdJ9p9CZsxvsGGJMYzIgz3m+J5tr3xjWITx6UbeF3gsQfGHu5yNEJ/SjVlqId9QbRjItrcn3IyyAL6XMSDYEs3B7f3Y7FqOion3Jf5RgwWVGre6U5dsVUddNVTmN3N7rSZBu7UNiE7PU489Pc8RXwx5EmD7xhR/rEvBldHw9O1aItGiSexQBVWBST0y0Z1oCJ5XFHMHQ7XRr0zGjgcgtoMgQzgwP5qUQf/e7K8Un0B2zM4ukLFzvf4LS8NCvWapnGzmStXNodwhS2K5F11S9Ojeh+OQZIo4SesdGdWP4Ea+q03TfinExbsaySqAUCu4S2xh/HZGiCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The subject isn't great - before you're not allowed to mmap /dev/zero _at
all_ on nommu, here you try to allow it.

I'm kinda against it to be honest, nommu has been functioning... I'll not
say perfectly fine, given it's broken in many ways that nobody ever
reports, but I'd say instead 'the same as it was' with no issue.

And you're not really explaining why you need this.

You're not correctly supporting MAP_SHARED-/dev/zero AFAICT at all, it'll
just... actually I don't know what it'll do


On Thu, Aug 13, 2026 at 03:33:58PM +0900, Hajime Tazaki wrote:
> Upon a private file mapping request to /dev/zero, it calls
> kernel_read() in do_mmap_private(), getting a failure with the message
> like: "kernel reads not supported for file /dev/zero", which is because
> zero_fops defined in drivers/char/mem.c has both .read and .read_iter
> definitions.

Can this be broken out into its own separate fix please.

It's not about /dev/zero at all but rather being able to MAP_PRIVATE-map
literally anything with .read and .read_iter.

>
> Even fixing this issue, the map request to /dev/zero works fine without
> errors but the allocated vma isn't marked with anonymous because
> mmap_zero_prepare() isn't called under nommu platform, resulting
> vma_desc_set_anonymous() isn't called either.

"Resulting _in_ vma_desc_set_anonymous() _not being_ called either" is clearer.

>
> This commit fixes those issues by:

Already 'issues' suggests >1 patch would be a better idea :)

> 1) use vfs_iter_read() instead to avoid failure at kernel_read()
> 2) calls .mmap_prepare on private mapping in do_mmap() so that required
>    preparations are done even in private mapping.
>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Liam R. Howlett" <liam@infradead.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Pedro Falcato <pfalcato@suse.de>
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-mm@kvack.org (open list:PAGE CACHE)
> Fixes: 4d03e3cc5982 ("fs: don't allow kernel reads and writes without iter ops")

Yeah as Greg says, it really suggests nobody is using mainline nommu in any
serious way given this is from 5.10 and would require avoiding /dev/zero in
a way that seems kinda unlikely.

Should be Cc: stable also but not as a combined patch, the mmap_prepare
bits only came in recently.

> Assisted-by: cubic.dev:unspecified

Unspecified? :)

Really the best approach nowadays is:

Assisted-by: LLM # it wrote the whole thing

or:

Assisted-by: LLM # it merely complimented my dress sense

Or whatever :)

> Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

In general this is opening up whole new areas of code to nommu and given
nobody seems to be testing anything I'm not sure I'm ok with it.

Since forever /dev/zero's been disabled for mmap in nommu. So I don't
really see the point in making it work at quite a lot of risk here +
necessitating doing some more nommu stuff in unrelated areas.

In any case, it's probably worth waiting for me to do my follow up series
on /dev/zero next cycle, which will inform how it will look for real
arches.

It's worth breaking the read_iter fixup out of it though probably, and the
mmap_prepare support.

> ---
>  drivers/char/mem.c |  5 ++-
>  mm/filemap.c       |  6 ++--
>  mm/nommu.c         | 84 ++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 87 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index 63253d1de5d7..dba24d0a7b33 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -500,11 +500,10 @@ static ssize_t read_zero(struct file *file, char __user *buf,
>
>  static int mmap_zero_prepare(struct vm_area_desc *desc)
>  {
> -#ifndef CONFIG_MMU
> -	return -ENOSYS;
> -#endif

> +#ifdef CONFIG_MMU
>  	if (vma_desc_test(desc, VMA_SHARED_BIT))
>  		return shmem_zero_setup_desc(desc);
> +#endif

This is pretty horrible already :(

You're also letting VMA_SHARED_BIT be a return 0 noop, that
seems... unwise?

You can use IS_ENABLED(CONFIG_MMU) to make things vastly less terrible,
e.g.:

	static int mmap_zero_prepare(struct vm_area_desc *desc)
	{
		if (!vma_desc_is_cow_mapping(desc)) {
			if (!IS_ENABLED(CONFIG_MMU))
				return -ENOSYS;
			return shmem_zero_setup_desc(desc);
		}
		...
	}

But again, I don't really feel that nommu should be enabling this and I'm
changing the /dev/zero stuff anyway.

>
>  	/*
>  	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
> diff --git a/mm/filemap.c b/mm/filemap.c
> index d721986d5f46..cf02faad86aa 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4077,7 +4077,7 @@ int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
>  }
>  int generic_file_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	return -ENOSYS;
> +	return 0;

Err, no, making this a noop breaks it?

I'm not really hugely fine with you making this be the same as CONFIG_MMU
either as I am not confident in the change being correctly audited given
the until-recently total lack of testing of nommu, and now very limited, as
well intentioned as it might be testing.

I would prefer anything that currently doesn't function with nommu to
remain so.

>  }
>  int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> @@ -4085,7 +4085,9 @@ int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
>  }
>  int generic_file_readonly_mmap_prepare(struct vm_area_desc *desc)
>  {
> -	return -ENOSYS;
> +	if (is_shared_maywrite(&desc->vma_flags))
> +		return -EINVAL;
> +	return generic_file_mmap_prepare(desc);

Again same objections as above re: doing real-arch stuff in nommu.

>  }
>  #endif /* CONFIG_MMU */
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index e40990e15831..a29a53c1c80a 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -37,6 +37,7 @@
>
>  #include <linux/uaccess.h>
>  #include <linux/uio.h>
> +#include <linux/major.h>
>  #include <asm/tlb.h>
>  #include <asm/tlbflush.h>
>  #include <asm/mmu_context.h>
> @@ -856,6 +857,22 @@ static int validate_mmap_request(struct file *file,
>  	return 0;
>  }
>
> +static int is_file_anonymous(struct file *file)
> +{

As stated on the cover, I don't adore this and that's all changing soon
anyway.


> +	if (!file)
> +		return 1;

It's 2026 use a bool please.

> +
> +	if (file->f_path.dentry && file->f_path.dentry->d_inode) {
> +		struct inode *inode = file->f_path.dentry->d_inode;
> +		/* if the device is /dev/zero */
> +		if (S_ISCHR(inode->i_mode) &&
> +		    imajor(inode) == MEM_MAJOR && iminor(inode) == 5)
> +			return 1;

This is horrible really. The /dev/zero stuff I'm doing kinda had to do
_something_ this this (in a roundabout way) - well I thought so - anyway :)

But yeah again wait for me to do /dev/zero follow up.

> +	}
> +
> +	return 0;
> +}
> +
>  /*
>   * we've determined that we can make the mapping, now translate what we
>   * now know into VMA flags
> @@ -869,7 +886,11 @@ static vm_flags_t determine_vm_flags(struct file *file,
>
>  	vm_flags = calc_vm_prot_bits(prot, 0) | calc_vm_flag_bits(file, flags);
>
> -	if (!file) {
> +	/* private and file mapping will be marked anonymous later (do_mmap_private()).
> +	 * and /dev/zero is marked by them at .mmap_prepare,
> +	 * which should be _before_ this point.
> +	 */
> +	if (is_file_anonymous(file)) {

You're kinda throwing in a bunch of random stuff in 1 patch you really need
to break things out more.

>  		/*
>  		 * MAP_ANONYMOUS. MAP_SHARED is mapped to MAP_PRIVATE, because
>  		 * there is no fork().
> @@ -923,6 +944,29 @@ static int do_mmap_shared_file(struct vm_area_struct *vma)
>  	return -ENODEV;
>  }
>
> +static ssize_t nommu_read_iter(struct file *file, void *buf,
> +			       size_t count, loff_t *pos)
> +{
> +	struct iov_iter iter;
> +	ssize_t ret;
> +	size_t done = 0;
> +
> +	while (done < count) {
> +		struct kvec iov = {
> +			.iov_base = buf + done,
> +			.iov_len = min_t(size_t, count - done, MAX_RW_COUNT),
> +		};
> +
> +		iov_iter_kvec(&iter, ITER_DEST, &iov, 1, iov.iov_len);
> +		ret = vfs_iter_read(file, &iter, pos, 0);
> +		if (ret <= 0)
> +			return done ? done : ret;
> +		done += ret;
> +	}
> +
> +	return done;
> +}
> +
>  /*
>   * set up a private mapping or an anonymous shared mapping
>   */
> @@ -993,7 +1037,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
>  		fpos = vma->vm_pgoff;
>  		fpos <<= PAGE_SHIFT;
>
> -		ret = kernel_read(vma->vm_file, base, len, &fpos);
> +		ret = nommu_read_iter(vma->vm_file, base, len, &fpos);

Hmm so now you just assume there's always a .read_iter and error out if
there isn't one?

Seems questionable.

>  		if (ret < 0)
>  			goto error_free;
>
> @@ -1080,6 +1124,28 @@ unsigned long do_mmap(struct file *file,
>  		vma->vm_file = get_file(file);
>  	}
>
> +	/* call mmap_prepare function if any */
> +	if (!(flags & MAP_SHARED) && !(capabilities & NOMMU_MAP_DIRECT) &&
> +	    (vma->vm_file && vma->vm_file->f_op->mmap_prepare)) {

> +		struct vm_area_desc desc;
> +
> +		vma->vm_start = addr;
> +		vma->vm_end = addr + len;
> +
> +		compat_set_desc_from_vma(&desc, vma->vm_file, vma);
> +		ret = vma->vm_file->f_op->mmap_prepare(&desc);
> +		/* private ramfs/romfs mappings fails with -ENOSYS so,
> +		 * fall back to copied mapping.
> +		 */
> +		if (ret && ret != -ENOSYS)
> +			goto error_mmap_prepare;
> +
> +		ret = __compat_vma_mmap(&desc, vma);
> +		if (ret)
> +			goto error_mmap_prepare;
> +	}

Again break out code into separate functions please!

I invented this compat mmap_prepare stuff to handle stacked file system
mounts, and I intend to remove it once the mmap_prepare conversion is
complete.

But I suppose... maybe stuff could be migrated to nommu.c at that point as
a local fixup just for it.

Probably worth breaking this out as a separate patch too then so
mmap_prepare is properly supported in nommu otherwise stuff will break
there, eventually (with X year lag possibly inf on reporting of course ;)

> +
> +
>  	down_write(&nommu_region_sem);
>
>  	/* if we want to share, we need to check for regions created by other
> @@ -1196,7 +1262,7 @@ unsigned long do_mmap(struct file *file,
>  	add_nommu_region(region);
>
>  	/* clear anonymous mappings that don't ask for uninitialized data */
> -	if (vma_is_anonymous(vma) &&
> +	if (is_file_anonymous(vma->vm_file) &&

As above re: this function.

>  	    (!IS_ENABLED(CONFIG_MMAP_ALLOW_UNINITIALIZED) ||
>  	     !(flags & MAP_UNINITIALIZED)))
>  		memset((void *)region->vm_start, 0,
> @@ -1247,6 +1313,18 @@ unsigned long do_mmap(struct file *file,
>  	ret = -EINVAL;
>  	goto error;
>
> +error_mmap_prepare:
> +	if (region->vm_file)
> +		fput(region->vm_file);
> +	kmem_cache_free(vm_region_jar, region);
> +	if (vma->vm_file)
> +		fput(vma->vm_file);
> +	vm_area_free(vma);
> +
> +	pr_warn("mmap_prepare failed for %lu byte allocation from process %d\n",
> +			len, current->pid);
> +	return ret;
> +
>  error_getting_vma:
>  	kmem_cache_free(vm_region_jar, region);
>  	pr_warn("Allocation of vma for %lu byte allocation from process %d failed\n",
> --
> 2.43.0
>

--
Cheers, Lorenzo

