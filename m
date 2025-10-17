Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2758CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 08:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19AA68E0009; Mon, 20 Oct 2025 04:56:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FD128E0002; Mon, 20 Oct 2025 04:56:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2F068E0009; Mon, 20 Oct 2025 04:56:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DB1D88E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 04:56:55 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 82C5713BAE8
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:56:55 +0000 (UTC)
X-FDA: 84017887590.18.47033CB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 51EE310000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:56:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DdYKApdD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n4Wy5xVw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GHKE85tk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3qhiJutp;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760950613; a=rsa-sha256;
	cv=none;
	b=00MI3ZGaX34v0NIz8TRyImdG+nfoOt9wbaWDKVdT9scL/XqMqbGBQlDgYYvdkax0WYraEI
	NzN2sMTGEwjF7nkkm79C7RIkDLGwheiOHqlHrR4ONg2dTeixwKVVWjAqU0USaP4QTXhJqB
	i4STXcZNIu58khO/cgNZrJeqIrm4kvw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DdYKApdD;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=n4Wy5xVw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GHKE85tk;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3qhiJutp;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760950613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=O0iUJrxeysFJdpGHveLXmFTl3iUWpjgT3zMmjymyf+Kj33zoJjx2nbp1abybRZ/D0NulKf
	JBVKwwQ3lzi/leyJYL4AHnS6XbREmb1Coe2ubr5iVn+5M+Jdljj/33G0bTbLgBgmITN+9V
	YkCWCmKffooGHAJ4HbKAKVkVPx73yhM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 86FB71F444;
	Mon, 20 Oct 2025 08:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760950607; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=DdYKApdDfIpRBsXSqpzR28p/+DQUgUl3yu851Qs7/8Z4wcGyp2HwG2iKgzlXoStKMh4ryJ
	K5RVfJdjEo/Vj7EcPVSQUmQ5nWVqqfWbsP3Jtpj0p/VW0jtbpuhdNrGJK2Bbm/iHN2hmLa
	98S4sY0L4n4g2lqmFoE2NUx0jcNoQmA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760950607;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=n4Wy5xVw9WIz/qKbAzcQfJ+qcHXVOg/zyt38h9GYR1j4XrT5obg+111FTeo5Ap/PfpdAZW
	v8TSAn8NELhE4/DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760950605; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=GHKE85tkGuIDq6RbXCkKZDCD4WC9qR4U2YzfJ216q6A9gV80TkDNGXiFuFOFXct5vRI8g4
	ytmgG08qKExpm5T8YZonTMGEt8e7THiDV9azeNM1gNc/ol730BEuZTzDNebgafD68L7iAR
	xOgnOar3ffsVvIkvK5xElf1iR2oBHI0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760950605;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L9AZMaKK0rdk8fT5XwsO7G/zuw8BvSzFoOAnxBhJsTQ=;
	b=3qhiJutp1ZB2ObiDRSjK0xA5dJ2lc0JyuG50HsVg3sDIXjgt8+J53+9Q0wSgg/7ejCGwbW
	zeW7YRwqtHC5IJAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6C0AD13B12;
	Mon, 20 Oct 2025 08:56:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CKFhGkH59Wh3ZQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 20 Oct 2025 08:56:33 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 37DBAA28E6; Fri, 17 Oct 2025 14:32:01 +0200 (CEST)
Date: Fri, 17 Oct 2025 14:32:01 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Carlos Maiolino <cem@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org, 
	dlemoal@kernel.org, hans.holmberg@wdc.com, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
Message-ID: <4gadspfntp6jzjbxlb65jv5o2ilyj7kl2pe3qy75g4yoxo7dua@safke3mbqhk4>
References: <20251017034611.651385-1-hch@lst.de>
 <20251017034611.651385-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017034611.651385-3-hch@lst.de>
X-Rspam-User: 
X-Stat-Signature: 4uhydm1f5hmge3ikp4o6b661grs8ijn7
X-Rspamd-Queue-Id: 51EE310000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1760950613-435749
X-HE-Meta: U2FsdGVkX18VkE9IvOtizw4tQsLQhk6CheLiEca0DX9pDG+dtGjQVoghCEL55f4RJ4lJ+lfCLz0mVrgV3A43oi8Go3t1BvbWPdRYhTduAZ2BgzOGOdFEz8/YfA92OI5JMOH/iVf+P0UpgZEqcdp/nTryeYUK3dZXnfb7v/LwvA8RCQUz18pnrS85X8K6Vp15NrJgrOYnd87R9UJE9tNmfrrDvOXbEGLlcpB5ZNhYLIeXEvOj+9riI3pOia+U+dcypVhfs+Yi8Z39S/pLJdocw76S9qc84PmKZOkPnOVPA6/gSZh9XC3oNCeoc3Y5iXUiDJOd/HqmUJQxnEh9qKstCB/dtBEA6VwdEDPTjPEMMDiwoRN8VRqkFfsFCvgph99epgSOp3tTqDlDi+Ql0arQR3DAD9sjvz6HUcq6mEfGKX+x+8aLUTNoi8GfSTY/bbhWCDwfwo37+3/06of0Zid7L3RjcooYDhgcuvU21xWmlrH3ya0PtnP1R1fp7fUb4qaH5wNyc2Wa/mMigcXOwAB+oVRwXXI76KTWEFC5ZzroztYav1LbWVU12f+XA519OkcHUJmXRIRBN2d237iSSWSs7IvLsk+/hVqLNs3UNfZlp8kgPxeT4MGxL1DLISyDbCJJH7WXBta1cQ5nGjVO4yakz986adFzLGpjve7dTvIAzd/vNuFyDwlpbAou39A7jY99h7lR951L8L6BvKUWGL9uT2tvjxytRIR3Etz/nr66oQa9tVRHR5po7dZs56yYZEd9n4JYTAqJSM8TYPlI1bkbT2EyYWpbvoozM+uPKI2zV5/HnUxEXI9kwMU/EL6auBf6VtRtas5UqD/ZMSIcaS+jN0Z3MpKLGdztzegsp9WD6pQuvhXdraIIRzlyDWFiGetFnrYfzjwP/peUfUjw7p7MG5OtKCqzLX1HpkYEeGOhSWA2gi0YEZfeoVFgICxBPfLbkBMQMOOVtkDL9CkISHy
 yJnkfVGe
 ASXznyHZyBN687r1SBIoDnnOA0XiolYqay0lerQfwb/0V2SOxuFF2IfdkSWJxadEMVSBS1mzmzpLgK2nJCMhKif0p8eTHNHDjGupoeq8+JRqNGIuDXdEPaD4ykwNeaK70YrC8QHRLEiRKXZbxSwfiDm/ajlZQIVcGgEayTPmG6U6KOj5DbVE9v/73BWCeLZWuIjGUcTeWd+rVkGqQ8TGYvzHsLfLq+q1PLmDI4hoQpTICoyUuyeCbKpwQMm9FqQxF3LY72PKOztgj+3RZzL/0jHvYdEbyEzFF9XQiz3gdVy4KHEaAfObTtOSb4UyXgGHRszFQlFG/tYpsd6EHgRIhH6w26Y9aYDc/YIJpmnA/okJf1taY4h3EW9ZxQU5k9KXJ8/ubS/sQQU/3/9KNOz/4ADTfR7Baj+w2S1IWk5ci7C5yMD4yBk9xYLzET3WaIkINxnJo2dPZQvdv9/E=
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

