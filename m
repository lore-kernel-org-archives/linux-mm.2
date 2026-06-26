Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 889EAC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 14:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C8496B0005; Fri, 26 Jun 2026 10:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A1846B008A; Fri, 26 Jun 2026 10:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F956B0095; Fri, 26 Jun 2026 10:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E83936B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 10:19:22 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70FB1A04B3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:19:22 +0000 (UTC)
X-FDA: 84922271364.30.4A4462D
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id 362A14000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:19:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LcApiVHn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8plrHN/0";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LcApiVHn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8plrHN/0";
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782483560;
	b=whWyOgtK1FTrsxTM96yXigv/iY4zL4NOH36Z5SaOX9cwj3VEkZyZKSMKOWa0qFAq2vuyLH
	uAk/jzddAyl4RTDF6dA/iYlwAXVlDZEB5LtZLr+huFWWirJCW3EFFv28Lx75EV92MpVd2v
	L2i8kYS2V4bPLiB4MVfruirhwiEbR9Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782483560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gbMQKiXqfVe8vOZqxCfOqjk0hfDyKNE4OsiYCQtUcUU=;
	b=FhuAudoW23LJ3Sf0TyOxHJ4jzzk8vk5LBWpqjN9b1IHm+8IZkOmcsvdyiYawLhl2IQ07/1
	UhnS9rN5HL9zgOupdsbL3jxFFYoyL+Dnqu8jBQJoD2Q5fF2QdzkuwZw9cNGtTVQYnXVgMD
	61o21tWadSYvgVEEGCX6L5wHXxc55ho=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LcApiVHn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8plrHN/0";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LcApiVHn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="8plrHN/0";
	spf=pass (imf04.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 79A0D758FC;
	Fri, 26 Jun 2026 14:19:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782483558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gbMQKiXqfVe8vOZqxCfOqjk0hfDyKNE4OsiYCQtUcUU=;
	b=LcApiVHn+gVKrWoqaEhQVbIz0Zfyo9dpkPuQ2Ozgyd1CvHJZQZLhznn3W40lcJJoYhKPXX
	XnHWM4Qwp5gLQLgo/Hi0uuS1ajli0CTyL3T2nBab5PzLOt9od2TNrqR7SjtURvkWXfbBuw
	RR7H1bO7aGjqzCtHLiubmx/BIuzvmZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782483558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gbMQKiXqfVe8vOZqxCfOqjk0hfDyKNE4OsiYCQtUcUU=;
	b=8plrHN/0jw3WpXlvF0EUMNASD/VGjmuOTWNRc3Kr8LRxujHnTLSnos7h0ZzEbzHLDC5zRy
	x/Nl5gth52RcGPCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1782483558; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gbMQKiXqfVe8vOZqxCfOqjk0hfDyKNE4OsiYCQtUcUU=;
	b=LcApiVHn+gVKrWoqaEhQVbIz0Zfyo9dpkPuQ2Ozgyd1CvHJZQZLhznn3W40lcJJoYhKPXX
	XnHWM4Qwp5gLQLgo/Hi0uuS1ajli0CTyL3T2nBab5PzLOt9od2TNrqR7SjtURvkWXfbBuw
	RR7H1bO7aGjqzCtHLiubmx/BIuzvmZM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1782483558;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gbMQKiXqfVe8vOZqxCfOqjk0hfDyKNE4OsiYCQtUcUU=;
	b=8plrHN/0jw3WpXlvF0EUMNASD/VGjmuOTWNRc3Kr8LRxujHnTLSnos7h0ZzEbzHLDC5zRy
	x/Nl5gth52RcGPCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6BDD4779A8;
	Fri, 26 Jun 2026 14:19:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YBxNGmaKPmr3XgAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 26 Jun 2026 14:19:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0FFBCA10A3; Fri, 26 Jun 2026 16:19:18 +0200 (CEST)
Date: Fri, 26 Jun 2026 16:19:18 +0200
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm: do file ownership checks with the proper mount idmap
Message-ID: <s6mr3j7gew2cgerzrvqzenjctctrtnhvlynmcccxb24uszcauz@5iapd6wnbfxg>
References: <20260625153853.913949-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260625153853.913949-1-pfalcato@suse.de>
X-Rspamd-Action: no action
X-Stat-Signature: r3c9sb7dbmrkppn7qbxyqfsreyyxj7yi
X-Rspam-User: 
X-Rspamd-Queue-Id: 362A14000B
X-Rspamd-Server: rspam02
X-HE-Tag: 1782483560-14173
X-HE-Meta: U2FsdGVkX1/zAwhvl9L6YV2Yz3/hFV5CuC4LdHiWWgXX3GVzoRS7WOe0/d66U1sK/N8VOwnyH0V7bn0c4PSouaNppaIAi9IbgjYZ0JYeOnLA6nQvEsN99kMgV75R/qBYpwdK+QncLQc1ZPKxtEc9wIwrDGQepH6T9xqE5hZaE3jtegnoRMPgG60Yokr9FweqoDXTj2JSN2yhjyRQXwUlToH2WeXwaQ3akKeI21vW2em/BVlxGCBzDqnSPzYJRLJojSSuSUsmNrwxGgN8FobIx3tDMXy3ZAmjiZaSjf56444VeyAl7Bf0MV38wphXlMNspqTtBr5nHnI5HgGnV+eXj9OEXmWgiLOFGGN/lGuenaxzzkhqamBwE0kuqRqTNfz02b7sZlWvCEMkz1Izc4kuBGcUYGl7xkgFWl6mraKLcpmI/m8ByX6GBgZtOmpGosS8zQk5NN65XMfKPnChMPQXxxIi5467ruwm5OQCpif927rsvjsonDWPU7M2q1v9iyM/K5ZrdiAPSMk17KZCRFRTYf+kvGV2mQESR3obpndsKH/b2xXcVOmuZ0lyWgbGrUG7AGXFnCnNoZ8C1HcgMZGIjkm58J6AkldijrA60K2cHGBPVtHQzL/O8bVPJcPIJiJE+sSICw+AEhkV0IYSHQ0vQn8ySb4L7FJJ971i8jXojKFxTTq4Sc+apcpy0PLF4n1/NZtfgO0T5tlQzQFHNhjdOL0hOFCDJqk6Kc3te0yW2+kMtg1QY/9KHbz2bJoZfe/Nr379bj+rvEIRftPNbh84o3rTypvdZv4jtcirau3gkbOaf7khbMcLgdwXgx/wlfphhbeVI3XqwjmMeW2873Q/VGLbr9vzJA+WKgyTy8lRKf/o3BRjLnY5X1eAW61cumeVJJyIbHhrXeYgSOCaBXYkJJDAu+F15x+WudvwLbQ2InIrfLe4zVg6pQEWkxSr7yw7puJtfYOFFw3R47bi1D1
 FNZ1Zwi8
 NCRq0O4lya/qGwa8Sx9LUDBvzh3D6FiGAMp+WOF3fedqgytH/elzZubqLwXKY+fuB+b5Dgf6IkmjsUzZhjVsfVNAvQo2BL53qmE20a+0MM1ylNZxEvzj0xXqtO/Of2HLua2pH9AhogCmPKmjNT9jwNGsCBn0B4ZO9iw5F21iG9SubpGwzBOCxy2vOj3uMIAHsls/aK42pzhCE1L99gcZp0aotnlX8cU5NRau9C9KsP0I1aoORVgZWTMlfFvGPVxCie9tFgYJAxzjP2i4j2UYHQO3mUO2p/5A7MFlBM8g2xQYoOb8mtITBR0Ge//aELW1U3pGLGMj0PxvUXEe1J2k3QzeOXteYJMZ5L75uqEnpfKunkko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 25-06-26 16:38:53, Pedro Falcato wrote:
> Ever since idmapped mounts were introduced, inode ownership checks
> (for side-channel protection) in mincore() and madvise(MADV_PAGEOUT) were
> done against the nop_mnt_idmap, which completely ignores the file's mount's
> idmap. This results in odd edgecases like:
> 
> 1) mount/bind-mount with an idmap userA:userB:1
> 2) userB runs an owner_or_capable() check on file that is owned by userA
> on-disk/in-memory, but owned by userB after idmap translation
> 3) owner_or_capable() mysteriously fails as the correct idmap wasn't supplied
> 
> In the case of mincore/madvise MADV_PAGEOUT, this is usually benign, because
> file_permission(file, MAY_WRITE) will probably succeed, as it uses the proper
> idmap internally, but it does not need to be the case on e.g a 0444 file
> where even the owner itself doesn't have permissions to write to it.
> 
> Since this is clearly not trivial to get right, introduce a
> file_owner_or_capable() that can carry the correct semantics, and switch
> the various users in mm to it.
> 
> The issue was found by manual code inspection & an off-list discussion with
> Jan Kara.
> 
> Fixes: 9caccd41541a ("fs: introduce MOUNT_ATTR_IDMAP")
> Cc: stable@vger.kernel.org
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>

This looks good to me. I'm a bit curious why Christian initially (in 2021)
used init_user_ns here instead of the file namespace... Anyway feel free to
add:

Reviewed-by: Jan Kara <jack@suse.cz>

I'll also note that there are quite some places in fs/ that could be
simplified with this helper but I'd leave them for later.

								Honza

> ---
> 
> I noticed there are a couple of call sites in fs/ that could perhaps be
> cleaned up with the added helper, but I'm skipping that for now for brevity's
> sake.
> 
>  include/linux/fs.h | 5 +++++
>  mm/filemap.c       | 2 +-
>  mm/madvise.c       | 3 +--
>  mm/mincore.c       | 3 +--
>  4 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index d10897b3a1e3..50ce731a2b78 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2444,6 +2444,11 @@ static inline struct mnt_idmap *file_mnt_idmap(const struct file *file)
>  	return mnt_idmap(file->f_path.mnt);
>  }
>  
> +static inline bool file_owner_or_capable(const struct file *file)
> +{
> +	return inode_owner_or_capable(file_mnt_idmap(file), file_inode(file));
> +}
> +
>  /**
>   * is_idmapped_mnt - check whether a mount is mapped
>   * @mnt: the mount to check
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 5af62e6abca5..58eb9d240643 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4704,7 +4704,7 @@ static inline bool can_do_cachestat(struct file *f)
>  {
>  	if (f->f_mode & FMODE_WRITE)
>  		return true;
> -	if (inode_owner_or_capable(file_mnt_idmap(f), file_inode(f)))
> +	if (file_owner_or_capable(f))
>  		return true;
>  	return file_permission(f, MAY_WRITE) == 0;
>  }
> diff --git a/mm/madvise.c b/mm/madvise.c
> index cd9bb077072c..77552b03d318 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -336,8 +336,7 @@ static inline bool can_do_file_pageout(struct vm_area_struct *vma)
>  	 * otherwise we'd be including shared non-exclusive mappings, which
>  	 * opens a side channel.
>  	 */
> -	return inode_owner_or_capable(&nop_mnt_idmap,
> -				      file_inode(vma->vm_file)) ||
> +	return file_owner_or_capable(vma->vm_file) ||
>  	       file_permission(vma->vm_file, MAY_WRITE) == 0;
>  }
>  
> diff --git a/mm/mincore.c b/mm/mincore.c
> index 296f2e3922b5..c8757c5085bf 100644
> --- a/mm/mincore.c
> +++ b/mm/mincore.c
> @@ -227,8 +227,7 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
>  	 * for writing; otherwise we'd be including shared non-exclusive
>  	 * mappings, which opens a side channel.
>  	 */
> -	return inode_owner_or_capable(&nop_mnt_idmap,
> -				      file_inode(vma->vm_file)) ||
> +	return file_owner_or_capable(vma->vm_file) ||
>  	       file_permission(vma->vm_file, MAY_WRITE) == 0;
>  }
>  
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

