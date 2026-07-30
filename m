Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F832C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B666B00A9; Thu, 30 Jul 2026 05:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C4E6B00AA; Thu, 30 Jul 2026 05:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80AC16B00AB; Thu, 30 Jul 2026 05:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE3A6B00A9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:34:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 008F7808FB
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:34:03 +0000 (UTC)
X-FDA: 85044931608.17.4BF8F29
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id E10CF1C0011
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:34:01 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qu9IBaes;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OVpjfGtI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wk8gDWRi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JSK5C5rL;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=Gs8b5BNseUqN8wE5iMD2tW0rvzTgR1jRnB3NDSFAIN7zwauUONXfYJDejI/ufnbfrAS3WT
	3VAJ7rDZITiekPW/LBygnRmXBiuzekR9b51L2RUjzQm/lMPxf9tGDCFIBgK/yL3pO3QyuB
	dQP1T03Zu0v+ioZ3rp2U14gdSE/CPfM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404042;
	b=aoPMcFyTWg1PR4YjXwgaBibxc/aTDjib7gN4PmvXSRjKixaPOr2nC/qlVQk3Za/MwFPAU9
	j+ktnFX9CFwUZPj4NRBYv78BkD85SAZBUqpAWo432koKOkdk3pdo5EVFk5grh/mK2/L63D
	XePL9nLEXx1v45xXwB2svGEsrYFy20I=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qu9IBaes;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=OVpjfGtI;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Wk8gDWRi;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JSK5C5rL;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7C1BA3EF6;
	Thu, 30 Jul 2026 09:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785404036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=qu9IBaesPpr06f2cuqhgTKK9UNK91bLXIZjsthmp4zv5oVsq8RNqegWHGKn/emU0t0AfjM
	A2q2dAkWjUpTUd/6FdvD/9i/SnCpyP/z7xqeL5UXqbuRa0j6V94ofWPJu3bc5rmJjlUDD3
	h18OGxJk0MZpaUAkhyy8M0EatIs6t0c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785404036;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=OVpjfGtILz3iZaDzGRsvNn41u3xsZALYlDTs+M2nGzQa77zhqDYjEqAWqfxiTQK/RT/L8N
	ccbVysQLd1LTCTAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785404032; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=Wk8gDWRiAd83zVAa4qco61zp1av1ez7Tc8QcxmYtaKmmzAW4HdH9OlDBxHp31075uj2xH+
	DQX4dM6eMnXZCJ1C46WEA+neiKROCsg6yjwQvFn7c3F1e3LqdDVVFGxM9Z1jcyzR8uSN0U
	L9HoaioXVPo9UFNMx7pA3aEUiWWhIv8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785404032;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gdTDhdgJ8XuoeE6fmfOGZw6wCck/A+h53ETE5D6Rv70=;
	b=JSK5C5rLS50CA5TXAYwb00lHJJaWYj5eQlYuB53VTYmrK/8H2COoLnQcAsTtj2B267b5fj
	KtPHYW6rQlWcRxBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 70E28779CC;
	Thu, 30 Jul 2026 09:33:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EomJG4Aaa2oGegAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 30 Jul 2026 09:33:52 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 18A07A0AAA; Thu, 30 Jul 2026 11:33:52 +0200 (CEST)
Date: Thu, 30 Jul 2026 11:33:52 +0200
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, Dave Chinner <dgc@kernel.org>, 
	Bart Van Assche <bvanassche@acm.org>, Hillf Danton <hdanton@sina.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-erofs@lists.ozlabs.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v7 5/5] block: enable RWF_DONTCACHE for block devices
Message-ID: <enjg4xj3q5mpeegvzfemg3irkowvufw66h6yqo2vcpi434q3vk@cqlba4kwki6t>
References: <20260730-blk-dontcache-v7-0-3e8e6850068d@columbia.edu>
 <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730-blk-dontcache-v7-5-3e8e6850068d@columbia.edu>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E10CF1C0011
X-Stat-Signature: n88pu7kw1qkhuyyq1xdntiizaekopf4o
X-HE-Tag: 1785404041-658323
X-HE-Meta: U2FsdGVkX1/sieJO5i5aDmR6HL8UsUxYaF62jBXP58UJPILXRji/A1oeXS79YpUa2gO6H4xOMkWBdL+i0zztt5sEwgYz9W3kAa/lucyrbdjh2KI4FuyjFDUzZSlI6Y2auNmlcYjzk5A+BdL54m2wXp7yTbK4wSA7gONdmfeaVL4pe0ue1obZKlyLbxn3rk+UPa78t9XBXev0npOutR9wnZ088YddcU/NsfAUGm2GE7V44U0n6/FpQyeS2ewHk71sz0tgp1YYHLVaRTwa0HuER+gXZ3v3LfBi7LKBMFE3Z5dKhGpMA3YhlqBmu0dWpLbzagtOcwNn0chn8L7ryGAoyTmmIr3zu7EPczQZdlO1lYyZ1tN8F90OXwn0vyHhTcZtLW4bKth47kdRRH9dT6LTtGwh9zW3wXTB2/S9PE9abbP+VS6SBu00MDKeD66gQJGtXnaMgC0Tv4E4UWKMjPM3PnAwq5liH7KzziUP4w7ytXqmA13wK2izsRlpevEO4MMBUD0pnogV41cSw9Oc3WpSCdxdFZY6iuUNdnO4i2895AaHd8HoiLZTBInbjSCQ6JY0+HJMEu019w1mkTbY9ICjTFRJnawU3O855r6BeQNOsqXakfn6MzfvMIMw3X1qNIFHoasODVNMYRsQIwBuHbZBiYBBZKsk70xbli070TD2t/WF9hZURrnXPVK+TOXpWRHt+sDbxfEg5oH5mHk6vhqXLGN0UBcMK6iU3hvp7JzO+EiRj1Jkkpyi/LbxII27Y0BSSrSkMrS15MMa+QczvpFb3hg/V+C/gX6RCIUS9IsDvPHlfpKR3k3pHwHzRu3OQRrW2jw/SxISc58BBVAkmIT1lkHkHoVm7XCxXufQ73v/iNCFETl5mgIlAHaJq0ckJ9SUHqeK0ZXJmmqeQ6bTybRyIamlBaTKZ2bCjUQfKmUQPPpV9k5VikQAbd/IkN89or6J78JUq6GZAnN5Yngkoe3
 XvQmGB8g
 Ioga0oHNbPITYKUHGNtJenH4j8wDww/Qzh19xGIu0HpeEHiIT5NvSm3Ioep73Uljd2bU559SY5MhY7keFTWVrUKNV0eOz9XEc1izf4ZKDg2EcHmmWSCG1rxU+fUMaY9Qj7X03rhRfhNN3cQUD0OAzt98JkQhHOJBheo9lSEkCCr8oWlI1vQnyTQrPJ3bnwNWqUw3eZsz1YTDGLzsNp09NHXu6cQRvLKUAANnohnhzLl0ZznIYc4R3g2Jz19czRBT/Pj7gLraEThO2+0wiLYPnEzu+d8I1kO6vPRCLgSRDhxjsErE5xM/rQAQlCLFIZDB0WEGBtoLnYEtlmUNED9RSKhjN0wIgWGWgv5B4VJQHJYlNmUVu5fr+E1/ZnmLlm6sZ7c8VVp4IKKKve2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 30-07-26 02:57:55, Tal Zussman wrote:
> Block device buffered reads and writes already pass through
> filemap_read() and iomap_file_buffered_write() respectively, both of
> which handle IOCB_DONTCACHE. Enable RWF_DONTCACHE for block device files
> by setting FOP_DONTCACHE in def_blk_fops.
> 
> For CONFIG_BUFFER_HEAD=y, writeback goes through buffer_head's
> __bh_submit() which sets BIO_COMPLETE_IN_TASK on dropbehind folios. For
> CONFIG_BUFFER_HEAD=n, writeback goes through iomap which handles it via
> BIO_COMPLETE_IN_TASK on the ioend bio.
> 
> This support is useful for databases that operate on raw block devices,
> among other userspace applications.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/fops.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 15783a6180de..8b39c53b6393 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -941,7 +941,7 @@ const struct file_operations def_blk_fops = {
>  	.splice_write	= iter_file_splice_write,
>  	.fallocate	= blkdev_fallocate,
>  	.uring_cmd	= blkdev_uring_cmd,
> -	.fop_flags	= FOP_BUFFER_RASYNC,
> +	.fop_flags	= FOP_BUFFER_RASYNC | FOP_DONTCACHE,
>  };
>  
>  static __init int blkdev_init(void)
> 
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

