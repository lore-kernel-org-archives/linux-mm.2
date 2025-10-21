Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA40BCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 11:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2EC8E0027; Tue, 21 Oct 2025 07:58:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093238E0002; Tue, 21 Oct 2025 07:58:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9CC18E0027; Tue, 21 Oct 2025 07:58:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4E508E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:58:40 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 565D1160473
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:58:40 +0000 (UTC)
X-FDA: 84021974400.08.5D1247B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id E508A1C000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:58:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="p/+neJoD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sMxtdMZz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Yu86RcU8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8ibScNkF;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761047918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tEww2G9x0lKOM7ivqmlX5OtWAigQPdROrOD7TaZz5TA=;
	b=s2MoJlS39jgKCxEPYrsPkDEyIIIl3GY+Rm8/jbDkHupGa3qR8qYzsMIjyXKdlZR1yLEHlO
	1jKxHYq82yyG9fFzM2GbILtzgp5A9hE3Q3nquevAtYyT5mXkUJJ9rzt+SAjZ0HL9r95Yfx
	xYKaOE1qcSjiZ3TKbgAv9ES5NuMq3/Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="p/+neJoD";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sMxtdMZz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Yu86RcU8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=8ibScNkF;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761047918; a=rsa-sha256;
	cv=none;
	b=YB0cQE7fISFcVO/Etv02wriIU9zttvRkmC5N6pN/jvlol0ZFBYRO17qbLE9S7iTf2+uVlH
	f4kC2wiuyCchpDuc6yRLMtiKafEB0JWAUccbwJcD9jBAcvmmG7ASdB2PvwQejlRBUD9EsX
	wrBCYW9xm9fQofb9UJ+n1yTLxBl88TE=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BE0231F80A;
	Tue, 21 Oct 2025 11:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761047911; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tEww2G9x0lKOM7ivqmlX5OtWAigQPdROrOD7TaZz5TA=;
	b=p/+neJoD7KoCtxs8pIRmXmFUD1fj6h56bLZid3spXVpwharkjHE+pbTk1OwZrd7H1EW5dO
	caNqMovRzswwIvdTut8ufB6+iRH5TV8hSWrk6frIlaJBzabC5Z6vh8bF5+wB8smCdy89LH
	DI6St98SPttCmxVqLiGVORnyjvOJhew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761047911;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tEww2G9x0lKOM7ivqmlX5OtWAigQPdROrOD7TaZz5TA=;
	b=sMxtdMZzRSuyEWY7c33DhYcPpK5f+LhGESlgz9TLbEe4F7dsF47dTrOaC3SijrcIZtpIRO
	Jb0MrFRBEe3VmKBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761047907; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tEww2G9x0lKOM7ivqmlX5OtWAigQPdROrOD7TaZz5TA=;
	b=Yu86RcU8X3HgjkfWtFKr+9wbl0XnSkqSIwowKYNi9zWWz/Dmk35DsVgpt1p3/2jvse1ovF
	Sy5fvFh1ln/L27ybVy///25Q17Zd8RIzm2F7+G5ereBrb21oERr5W28EC5XjX4FPUTykwT
	xQl1UEd2aKwIHIm5HQv6OkBogkdUkSg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761047907;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tEww2G9x0lKOM7ivqmlX5OtWAigQPdROrOD7TaZz5TA=;
	b=8ibScNkF0lHsQyxTRT2H/t+/PKopVVGOYY12f/SBRnQqcNPipm4uHYTTd76Pohde/Pwjv0
	CwDAzU4drECX3wBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AF61F139B1;
	Tue, 21 Oct 2025 11:58:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TQ7PKmN192ihWwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 21 Oct 2025 11:58:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 6368FA0990; Tue, 21 Oct 2025 13:58:19 +0200 (CEST)
Date: Tue, 21 Oct 2025 13:58:19 +0200
From: Jan Kara <jack@suse.cz>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk, 
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu, agruenba@redhat.com, 
	trondmy@kernel.org, anna@kernel.org, akpm@linux-foundation.org, willy@infradead.org, 
	mcgrof@kernel.org, clm@meta.com, david@fromorbit.com, amir73il@gmail.com, 
	axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com, djwong@kernel.org, 
	dave@stgolabs.net, wangyufei@vivo.com, linux-f2fs-devel@lists.sourceforge.net, 
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev, linux-nfs@vger.kernel.org, 
	linux-mm@kvack.org, gost.dev@samsung.com, anuj20.g@samsung.com, vishak.g@samsung.com, 
	joshi.k@samsung.com
Subject: Re: [PATCH v2 04/16] writeback: affine inode to a writeback ctx
 within a bdi
Message-ID: <p7mc3a7upsebbipxrredqhtazwt3tvyn4qt5jtsn3wb43orew2@6jzeodvk4tli>
References: <20251014120845.2361-1-kundan.kumar@samsung.com>
 <CGME20251014121031epcas5p37b0c4e23a7ad2d623ba776498f795fb0@epcas5p3.samsung.com>
 <20251014120845.2361-5-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014120845.2361-5-kundan.kumar@samsung.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: E508A1C000B
X-Rspamd-Server: rspam03
X-Stat-Signature: bnhmcwh48dp6t5ffwky5hbm7czsdj9qo
X-HE-Tag: 1761047917-745210
X-HE-Meta: U2FsdGVkX18mmlcqxEBkgY/MhaA9/wmxTs+3kcItldt+7gku8gfP03/PXGsIQc/7JJdWX3lNvNpO+L2lbv5FA3xRlfl7Ff8tSNFI/xlwlSQuMyKYcZnf4w945/agM0G2I7cprlx43Nahm5EGArbHUUwi0+cJY5W0tAWEo+/WZ0HGloBELdwaY2PcD1/xiX7hfnF5HwqiF+xVjbOwe1N2cWb/zYKx4r/z0Fv2JjFH6Z47NB93V55BuDC5tFcp0xJfQIiQvtgVsHc0sXqVWtBQUrXqx1vNyZfHn54gfQHUZB6kOpg73WNFIv+x2PvO++0DoozEx+qbdL9CpJBtxkADRWe/JrtjpvVTxpYvbnVx3htvONu9SEeABS+6DFbcbzZAVRj14i7yrpepwcZPW0Espb1ccYMR1w6CU71lV8icbikgU6j3W5I4UyOvjaPPRA57kEAjkDRZhE90ld4pZPLSnzfMoc2UFcdBVfBPaIGDBVpR8ZjE1zYDuPwdHHH4ZC2LNTjujq6j4vp6O0i/3nsS7kjHp0VCQ0Zz9b5Gmi/Ps0S9TV7v+tniKiQn7noMg2Gd0IhLDg6GKAVQkv10nuwmPyl5coBgQJJabH4ipa+S4x7HK8GbUbJhYiQMA+yv7WGqHQI4qFZKbrMmN9nltkfBSTqRM4b9shuELtDHHsD+rnALMysdmiO6iU4ky2g1tUWaq4TneUtHKAQHIecJ0LsnpOWH9d0qMpbkBM2zSzBSES4y7OVpDhOcm47gVmuh0bYbRybpWMEyYlW3/OyCHnm/dR+YWozRO+YGtcPcstBpmZsweJkgDkfmmo1f5Hxl7yxJSpJrPgK3xHVFU2rEW+xwAloUpu0wFwNym9DyKhdPRdCtiY8ZN8lIqNC7GgW0aDhKmv9mMU+wf1YkXF++0yPVm014GPzJwzQZRHCsfD1rKhQH7kGrcdA6ITE90DF6CCBw69Xjwwqy0rFMRBeOxAB
 woCXlWv0
 HR4ovCW4wVi03eEqj6zKWU7kffhtIvNx9QYeRbEKG76lEiph231nxGddqODuPuu8TzQDt6UcgMk05YasGYkd+4FTiwlleNTT772eERbGQ+jMBhdCBr/gdGDKH8CsPrGW8JOiP8dIxcqYhPDF6vl9Q+aImbdjGrcCRwLzi1UnyFisbBZav1olZmzF7+kPu5kJXwJmhOKtAeYQQvDZWUfUwffuJYb+2roFYTvFxYTeNUC+u/mQyLxQJ8IY0iamMIa7UoipdrXQ4xoXa6ATFtyqlLZcif2AzdQn6d1p9vsyHQBi71iRXJy73CWLv349vHnrnve71b1378WeEvt7qjbHDF6KOZ8Gx+KrrwfB8Hxr3gj6/RzP7KJVniyUvujwTCvzZR2jZ1p9LvPIwc/+NQUGuOCVgLb4vRzpT6btMJIDhv1wDXJs2cAdfBxN8k+Qyt+0wmgGDiyPN6fWxvHQAjghCdOm+Ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 14-10-25 17:38:33, Kundan Kumar wrote:
> Affine inode to a writeback context. This helps in minimizing the
> filesytem fragmentation due to inode being processed by different
> threads.
> 
> To support parallel writeback, wire up a new superblock operation
> get_inode_wb_ctx(). Filesystems can override this callback and select
> desired writeback context for a inode. FS can use the wb context based
> on its geometry and also use 64 bit inode numbers.
> 
> If a filesystem doesn't implement this callback, it defaults to
> DEFALT_WB_CTX = 0, maintaining its original behavior.
> 
> An example implementation for XFS is provided, where XFS selects the
> writeback context based on its Allocation Group number.
> 
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> Signed-off-by: Kundan Kumar <kundan.kumar@samsung.com>

As Christoph asked in other patch. Please introduce generic writeback
changes in one patch and then provide xfs implementation of
xfs_get_inode_wb_ctx() in another patch. Thanks.

								Honza

> ---
>  fs/fs-writeback.c           |  3 ++-
>  fs/xfs/xfs_super.c          | 13 +++++++++++++
>  include/linux/backing-dev.h |  5 ++++-
>  include/linux/fs.h          |  1 +
>  4 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 0715a7617391..56c048e22f72 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -265,7 +265,8 @@ void __inode_attach_wb(struct inode *inode, struct folio *folio)
>  {
>  	struct backing_dev_info *bdi = inode_to_bdi(inode);
>  	struct bdi_writeback *wb = NULL;
> -	struct bdi_writeback_ctx *bdi_writeback_ctx = bdi->wb_ctx[0];
> +	struct bdi_writeback_ctx *bdi_writeback_ctx =
> +						fetch_bdi_writeback_ctx(inode);
>  
>  	if (inode_cgwb_enabled(inode)) {
>  		struct cgroup_subsys_state *memcg_css;
> diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> index bb0a82635a77..b3ec9141d902 100644
> --- a/fs/xfs/xfs_super.c
> +++ b/fs/xfs/xfs_super.c
> @@ -53,6 +53,7 @@
>  #include <linux/magic.h>
>  #include <linux/fs_context.h>
>  #include <linux/fs_parser.h>
> +#include <linux/backing-dev.h>
>  
>  static const struct super_operations xfs_super_operations;
>  
> @@ -1294,6 +1295,17 @@ xfs_fs_show_stats(
>  	return 0;
>  }
>  
> +static struct bdi_writeback_ctx *
> +xfs_get_inode_wb_ctx(
> +	struct inode		*inode)
> +{
> +	struct xfs_inode *ip = XFS_I(inode);
> +	struct backing_dev_info *bdi = inode_to_bdi(inode);
> +	xfs_agino_t agno = XFS_INO_TO_AGNO(ip->i_mount, ip->i_ino);
> +
> +	return bdi->wb_ctx[agno % bdi->nr_wb_ctx];
> +}
> +
>  static const struct super_operations xfs_super_operations = {
>  	.alloc_inode		= xfs_fs_alloc_inode,
>  	.destroy_inode		= xfs_fs_destroy_inode,
> @@ -1310,6 +1322,7 @@ static const struct super_operations xfs_super_operations = {
>  	.free_cached_objects	= xfs_fs_free_cached_objects,
>  	.shutdown		= xfs_fs_shutdown,
>  	.show_stats		= xfs_fs_show_stats,
> +	.get_inode_wb_ctx       = xfs_get_inode_wb_ctx,
>  };
>  
>  static int
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 951ab5497500..59bbb69d300c 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -148,6 +148,7 @@ static inline bool mapping_can_writeback(struct address_space *mapping)
>  	return inode_to_bdi(mapping->host)->capabilities & BDI_CAP_WRITEBACK;
>  }
>  
> +#define DEFAULT_WB_CTX 0
>  #define for_each_bdi_wb_ctx(bdi, wbctx) \
>  	for (int __i = 0; __i < (bdi)->nr_wb_ctx \
>  		&& ((wbctx) = (bdi)->wb_ctx[__i]) != NULL; __i++)
> @@ -157,7 +158,9 @@ fetch_bdi_writeback_ctx(struct inode *inode)
>  {
>  	struct backing_dev_info *bdi = inode_to_bdi(inode);
>  
> -	return bdi->wb_ctx[0];
> +	if (inode->i_sb->s_op->get_inode_wb_ctx)
> +		return inode->i_sb->s_op->get_inode_wb_ctx(inode);
> +	return bdi->wb_ctx[DEFAULT_WB_CTX];
>  }
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 754fec84f350..5199b0d49fa5 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2379,6 +2379,7 @@ struct super_operations {
>  	 */
>  	int (*remove_bdev)(struct super_block *sb, struct block_device *bdev);
>  	void (*shutdown)(struct super_block *sb);
> +	struct bdi_writeback_ctx *(*get_inode_wb_ctx)(struct inode *inode);
>  };
>  
>  /*
> -- 
> 2.25.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

