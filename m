Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99358CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76E88E000D; Mon, 20 Oct 2025 05:35:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4EEF8E0002; Mon, 20 Oct 2025 05:35:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B651A8E000D; Mon, 20 Oct 2025 05:35:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4F0A8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:35:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6DF34BB2AC
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:35:45 +0000 (UTC)
X-FDA: 84017985450.14.79E0EEB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 516A7100004
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:35:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="naz/pBVC";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NCIbY9Wp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZGifkmhv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sjDoZJe4;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760952943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=V04kRt9ZHGWVSJABgxsf++nKh/QXv8RLsRC/zCnjuUaJXacWEkeJFidp9ab5vxKynX/Uc1
	j+OHUE8gAUeSg0pG1ATVSPuxZ7HS5EHGjOWlq7K8aYrTcA7ovVdpM1s6fp2Qb+/YzqJvwr
	YaD8XoExzvOg1bSzI/59dM8pYRMYPto=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760952943; a=rsa-sha256;
	cv=none;
	b=6+dFT7H1lxXCVB/uNMJx8xufNLUQtgM31QrURc5nijsf7qKl2Rq0mPBhAziObFkjl34iYT
	eawrb2VYaAbCg/MpfPqPtGUymKoxdybRHNl3rNrUVacGoLZ1l5s8nRgWk1x0O7znX3o0US
	aXLrd40N50Lk7qaSSkSm1BLv2GMYRbY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="naz/pBVC";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NCIbY9Wp;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ZGifkmhv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sjDoZJe4;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D60FC2117C;
	Mon, 20 Oct 2025 09:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760952942; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=naz/pBVCBolZUEOGStsc7lCBMvErrxWjXGjMmEsV2OR062kXGjby6qBpudy+W9gHJSZX0x
	8z85C4kGWEzcpdjICrPn3YmP+gT/cOLnhpKd5nOoQUmYY5w509y9/+kp7CL6MuLu8CQMYM
	pBlbKSCDJsceDFkXsMK+Au6icUmGG4o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760952942;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=NCIbY9WpgefsooUA5NR7Nzsg0P6oHm47auB7ywYqjCeIghDEw7rGKimsNnYc1BrrGbEtNK
	wE7lxxn0YZ497kAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760952937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=ZGifkmhveZ9mqYdEYZVfwMp83DW1YXkiVQHS3a8yVKQdE0zlZrW2OOYNlrg5P4Dn9KBjjo
	ZB0yiptLkXlH+ZQQ5dMn65BRgwR/jnrNfOgR6u9Fykz/PKGsBClnyhnf2K4D9P5zwV4C6/
	mBEJ8NE5fKHNRplsKoara9e1+LbDwKs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760952937;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=sjDoZJe4l7amRxlQwwIi3RTmjbKizeATCFJhLEPENL3N7JawpbKrST/mHsXe0pZ+pa/PnK
	apk8j4qRd+v28dDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C927A13AAC;
	Mon, 20 Oct 2025 09:35:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YjoZMWkC9miNDAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 09:35:37 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8508FA0856; Mon, 20 Oct 2025 11:35:33 +0200 (CEST)
Date: Mon, 20 Oct 2025 11:35:33 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Carlos Maiolino <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <prgzbqq4tx4v6dl6s76nymermntpovaamj63fagyrocwflss22@lzaflwvih4hu>
References: <20251017034611.651385-1-hch@lst.de>
 <20251017034611.651385-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017034611.651385-3-hch@lst.de>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Queue-Id: 516A7100004
X-Rspamd-Server: rspam02
X-Stat-Signature: 196kqf391qh9w94w9u16jk84n1tr9qnh
X-HE-Tag: 1760952943-601545
X-HE-Meta: U2FsdGVkX1/L+4/t1wYOZhkxxJMLCLXsCDLEcwwkNocjT6EWaiWvyvK3hTY6SekrFW574y5xvDW/iNlNsrLzwaKVrdBqtiqUuCSY61n7/Ndqo3DQpQKOEGL5Dgu8VhC+RR1z4GUdkvJ59+ksdEqEaRg+plUmz9xZPZI0VF2AgydJESVMirCgUF7cNbwibDp8dmKlZprXRWlQ0H7kIqovvRCOv5g98SVV4uyFNjsSFCs8As5IPmLdsMRB32AK+OUHff/GoM2CRhjmRABB1pqYQkpVqnVrKYf/spSQ+Ok/ZMgwld0xStHc6RT4veBlvqf/RpGdRmKGUxQ6ZWVsHYdQ700E+M4itnHU0myJ9JBVl/hl9kLIxB/9z+oY3OFA0uQsP290hCb+DXPPdnVomzMFGt9nSzcf+NBdFXvGBOQbKsFFkQoW7L60zrIXn9Kbnf6sRZ9eg7xSjM86+nxABWZN7RoeB2WwAfVCxcfTgZbNr5GFlyn/Ep9eZVh25tuWqMiDV37CdFtksFtzqjeU2VN0oiuqnsTKc1Y3WLct90aifzrvomXOkAW/aZaOoPgmxffj1XyEVDJ5lGZLTocu3ugg1Zd6cfk3b57vXID5/bjAuSVW5vW2Q0hAi8CR/day2ZtLBxbYXG1HFN0poTIYTX76KxzkyaoQLu1ud10leAx1blx7rVbi+nhZDx+MQBwT8D84Xb26k8mozHRsojO2MUy/qbDRhF/Zkihj1RH8hQ8D6/HtTVhXUYUboedDdfe3BMJEtaPnoZv4i9TYtaXGVFbfEmywnKKVgrk1PgGvvLCP0GjTEn52Ux3b+NIewLbj6Iv9uFL3RaH++jXp49A9AqUFatYp1V2eSV2K8Cam4rk0gyxmWYW+hRq+1aQPPG/lbpxdvtNXq/47lSfugwahM3PEFVMapb80+o9kGK7lRMgVNCpVPm7EZIXalBxP9aU2vjcqtyrhp238gZpEvMCrOVO
 sWbqJOy4
 VmvLqnmgMujNbX5VPQ9uLdd9Z7Bk+kxq1Sd7IVmZW/uiD2Ls=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 17-10-25 05:45:48, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB means that written back
> inodes on rotational media are switched a lot.  Besides introducing
> additional seeks, this also can lead to extreme file fragmentation on
> zoned devices when a lot of files are cached relative to the available
> writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c         | 14 +++++---------
>  fs/super.c                |  1 +
>  include/linux/fs.h        |  1 +
>  include/linux/writeback.h |  5 +++++
>  4 files changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 11fd08a0efb8..6d50b02cdab6 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -31,11 +31,6 @@
>  #include <linux/memcontrol.h>
>  #include "internal.h"
>  
> -/*
> - * 4MB minimal write chunk size
> - */
> -#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
> -
>  /*
>   * Passed into wb_writeback(), essentially a subset of writeback_control
>   */
> @@ -1874,8 +1869,8 @@ static int writeback_single_inode(struct inode *inode,
>  	return ret;
>  }
>  
> -static long writeback_chunk_size(struct bdi_writeback *wb,
> -				 struct wb_writeback_work *work)
> +static long writeback_chunk_size(struct super_block *sb,
> +		struct bdi_writeback *wb, struct wb_writeback_work *work)
>  {
>  	long pages;
>  
> @@ -1898,7 +1893,8 @@ static long writeback_chunk_size(struct bdi_writeback *wb,
>  	pages = min(wb->avg_write_bandwidth / 2,
>  		    global_wb_domain.dirty_limit / DIRTY_SCOPE);
>  	pages = min(pages, work->nr_pages);
> -	return round_down(pages + MIN_WRITEBACK_PAGES, MIN_WRITEBACK_PAGES);
> +	return round_down(pages + sb->s_min_writeback_pages,
> +			sb->s_min_writeback_pages);
>  }
>  
>  /*
> @@ -2000,7 +1996,7 @@ static long writeback_sb_inodes(struct super_block *sb,
>  		inode->i_state |= I_SYNC;
>  		wbc_attach_and_unlock_inode(&wbc, inode);
>  
> -		write_chunk = writeback_chunk_size(wb, work);
> +		write_chunk = writeback_chunk_size(inode->i_sb, wb, work);
>  		wbc.nr_to_write = write_chunk;
>  		wbc.pages_skipped = 0;
>  
> diff --git a/fs/super.c b/fs/super.c
> index 5bab94fb7e03..599c1d2641fe 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -389,6 +389,7 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags,
>  		goto fail;
>  	if (list_lru_init_memcg(&s->s_inode_lru, s->s_shrink))
>  		goto fail;
> +	s->s_min_writeback_pages = MIN_WRITEBACK_PAGES;
>  	return s;
>  
>  fail:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..ae6f37c6eaa4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1583,6 +1583,7 @@ struct super_block {
>  
>  	spinlock_t		s_inode_wblist_lock;
>  	struct list_head	s_inodes_wb;	/* writeback inodes */
> +	long			s_min_writeback_pages;
>  } __randomize_layout;
>  
>  static inline struct user_namespace *i_user_ns(const struct inode *inode)
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 22dd4adc5667..49e1dd96f43e 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -374,4 +374,9 @@ bool redirty_page_for_writepage(struct writeback_control *, struct page *);
>  void sb_mark_inode_writeback(struct inode *inode);
>  void sb_clear_inode_writeback(struct inode *inode);
>  
> +/*
> + * 4MB minimal write chunk size
> + */
> +#define MIN_WRITEBACK_PAGES	(4096UL >> (PAGE_SHIFT - 10))
> +
>  #endif		/* WRITEBACK_H */
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

