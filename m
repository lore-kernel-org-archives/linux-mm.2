Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C110BC98317
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 10:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEBCE6B0093; Thu, 24 Sep 2026 06:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75036B0095; Thu, 24 Sep 2026 06:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DFA6B0096; Thu, 24 Sep 2026 06:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5166B6B0093
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:58:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1C38A5C67
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:58:02 +0000 (UTC)
X-FDA: 85248356004.24.31C987E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id CE1DD1C000B
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 10:58:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XK2yhAGH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WWHHdk7E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NdRYl4RN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5ms3zhBK;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790247481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=bCsE/bkHuRvWC1xAsA8c3ZntcP6hk45h2RwF20ylrp5HPBoSUxgCFNX5fR5llcDlwQ/2M+
	G1V6Wzgx7awOCfDDmMy8zNi4YQTaf3PjTQ18Z3M4SQ4MhPIvBkUw4HaG9cVtXJmVE71fXj
	G5dQaXURne5j3499TzkKxy0JCz7LeEo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XK2yhAGH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WWHHdk7E;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=NdRYl4RN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5ms3zhBK;
	spf=pass (imf18.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790247481;
	b=x+CvBoBeyVxewobYanOR5D5K3f2s6NV7Rt15iqQezHCPTO4wlKXsX4v4TdAMEAuglsgC3R
	VKoYVK7fMkA8Xe8idw1r0+88NUKqEnK2w23YqasRMfhTgc5tRC9Ack50jCfvFY9sy9mhD7
	EwZZoEYITP7lZ+tCfMiMGeSAnWOCkOQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1CFC021EFA;
	Thu, 24 Sep 2026 10:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790247475; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=XK2yhAGHuRe7loDBoUcmiUjhc3jq+AXGRrtCd26aJMsjCpTjTc50RShuhwIDHku3jpoWto
	l1fAXLYwqeP2zyTn2oNluiPnUzJEhgh9G8qbngwDg9asFA4FKm693CiJCW5sg7w6Poyklp
	LA82k2G59tmY2/Ikt3DdPOx8V2Vre6A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790247475;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=WWHHdk7EANbYYRDXkfinNben5xPkYcXFY49Uj+pTr9iqE9goZWHi6IH6WmhhRaA72XJ06x
	OxGEK2me0Dcj8dCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790247471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=NdRYl4RNFwYn4+r8u8oUBD2piXAAKS7IlbEEr1LFQzjcq8vhhNJqWmmQ8toqMkym/N8Y3F
	dKxPbGkMRIPxdbM3jUgWAiVErkGA9URGXf0na+WXKgWreLRY1cjwu1/6lACocTgg03ua3R
	A8ImfD5/x7S1kzmp+y6vA5bvGIheXF0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790247471;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbmFn96Dr7Y82qM5io19+Dl7w0OLn9pRCPxXUR9XU3U=;
	b=5ms3zhBK/LwkYNAoYxufp9jcZMjN6u9w+T+22YHBrKfJ08UiDsN9qQi6DxM1ofTTXYk3Ry
	d64Cwu5WvYr3uWBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E926713668;
	Thu, 24 Sep 2026 10:57:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mVg4MC4CtWpeAgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 10:57:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 8B114A132E; Thu, 24 Sep 2026 12:57:46 +0200 (CEST)
Date: Thu, 24 Sep 2026 12:57:46 +0200
From: Jan Kara <jack@suse.cz>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org, jack@suse.cz, 
	tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v8 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <sb2ptqety3wgay5egv4otva2s7hdvztifhsealwqpdnw5nyprc@ceu2bsedj4wy>
References: <20260922125015.3435215-1-sunjunchao@bytedance.com>
 <20260922125015.3435215-2-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922125015.3435215-2-sunjunchao@bytedance.com>
X-Stat-Signature: u333bmtdqr51zyx1icbp3f4kyg1czpfo
X-Rspamd-Queue-Id: CE1DD1C000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790247480-785198
X-HE-Meta: U2FsdGVkX18zNdzqxvO/grgqxmIn3PHFQBz9kruoL0mr6sE7rlNLGHQ6vzjEkNe9LIlD1ZPc+FtLiLevTdPF1CFLekAUfDOQK7WfIEvVJ3X/uDKkZN1NWU+5/hyvMw2H3EINYM3PHcpqdQs6hyCGdh8Wb1c6qQ5pxdcHn/SFHDLpvzLV1KZcWKQrxYtne4mQQJUlcWneLHeiEgy+WEu/Sk0nJHHvSCez1L3Qb/vcjdYQM+BVKRVfvIRc90OuAzyj/jS2EaDmGnqQ9TDgGtveTBMpW1jDASPaW5MTVi6Sjti8ZsWnu3fuLcx5utM0cEQWz809iJ10rMHW/Zm+BiSXykkhY32elRwyiIR8eisDrsAhOjDTDLrBOG5Yxfuy94UoU537U03uavKS4MlybVn8NV1SDs2VSjQX/7Vj0VuTrtPDZYlUd8N1eNQRgF/4lvf4A32nA4E6gt6h18BgkRt+rOtVb5ndfmYrQ8WxIl+yzLtGSELCeGxxewCe2BUH3tp4QZPWbfhUkwLOiEc7sZJcXZJtTm5JjIt0kdT86q2ykMV7Y6vsIGiqvRy/jqeOvMk+fmfzHOuMr6KKRVs6PsFSXU4Y3dlZOmyt+iG6WShWxBcqDVFI+qjijf51kIhUZXkSSQSvGqxquEoCcVlqEnWJqy4UKoI45H+5vDvM9QtcS4UWgt/1Cmr6nPrgsZ5H7w5HeEb1Is5rhtqgeL3TrhylXAGzS4UQ3rEoxyUbfCMb0DesjoT8nmu8Ul8TkODca8wOoF0r3ayFPUM+68mSvK2q9ZEzi45uA7ivrQSDjY//B6SojAMZNWtYKbnYZglEwEKUdxBa8YPl9D0uIRM1AMZg3V15kNQyNOXsrfSYZ+67l5IUd1rFM6qW+mTpWmt42s8hHg5hBRq+u4pS1kLuHIt7iIPI0icsNFcgTO9KnkffvSrwWWj2wGmOjdAyKZ8eZrLWYD1L/ORsNm834UG6wi/
 JaL/qhhI
 3z+Tvrr1EFWcPLzMWj9JoN1kOLI2vGGhusHzPr9snKVN38ocHbO2FiUyeTaXkoN7Q7sqC4QNl8hi0TuCLl++KqwXYhaoYP2Zn6x+mhv+QwF2nkckqR8aG6+JCftf7gwE+2owsjRYc+CiOh5exMSUNmNL/b50cCyp1sqWerI0Rv/tuK5YRQDjGr2IUNvJ2BDad1Xul+NBinp0c2wNjp4uNSX+WjYfbXt7719fu7f/ZN1fZTqLpfAmFl4qHSSNyIK6vZgo8xkz6kXmFD26hA7mkDj+iGvS7q5b3N4/Lce2LOxfp9m5Pblty3xtxDzBR3R0KO5BnmY1J0BT3ddYEVmiNXS0KZJqeXfXsHBgrdm6+nr3BDv8G1/WxYowx+6QyM83b+BDor75llRAW3kKOVvqb7DoT7iw6s6pbroHM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 22-09-26 20:50:13, Julian Sun wrote:
> Add bdev_flush_by_dev() to submit page-cache writeback for a device
> identified by dev_t without requiring callers to hold a persistent
> device reference.
> 
> A subsequent patch will use this helper to flush foreign bdev mappings.
> 
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  block/bdev.c           | 18 ++++++++++++++++++
>  include/linux/blkdev.h |  4 ++++
>  2 files changed, 22 insertions(+)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index cd8323083740..c7c192af6262 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -264,6 +264,24 @@ int sync_blockdev_nowait(struct block_device *bdev)
>  }
>  EXPORT_SYMBOL_GPL(sync_blockdev_nowait);
>  
> +/**
> + * bdev_flush_by_dev - attempt writeback of a block device's page cache
> + * @dev: target block device number
> + *
> + * May sleep while submitting writeback; does not wait for I/O completion.
> + */
> +void bdev_flush_by_dev(dev_t dev)
> +{
> +	struct block_device *bdev;
> +
> +	bdev = blkdev_get_no_open(dev, false);
> +	if (!bdev)
> +		return;
> +
> +	sync_blockdev_nowait(bdev);
> +	blkdev_put_no_open(bdev);
> +}
> +
>  /*
>   * Write out and wait upon all the dirty data associated with a block
>   * device via its mapping.  Does not take the superblock lock.
> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
> index 4f7905c3412b..27afe3ff6fb5 100644
> --- a/include/linux/blkdev.h
> +++ b/include/linux/blkdev.h
> @@ -1710,6 +1710,7 @@ void invalidate_bdev(struct block_device *bdev);
>  int sync_blockdev(struct block_device *bdev);
>  int sync_blockdev_range(struct block_device *bdev, loff_t lstart, loff_t lend);
>  int sync_blockdev_nowait(struct block_device *bdev);
> +void bdev_flush_by_dev(dev_t dev);
>  void sync_bdevs(bool wait);
>  void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask);
>  void printk_all_partitions(void);
> @@ -1726,6 +1727,9 @@ static inline int sync_blockdev_nowait(struct block_device *bdev)
>  {
>  	return 0;
>  }
> +static inline void bdev_flush_by_dev(dev_t dev)
> +{
> +}
>  static inline void sync_bdevs(bool wait)
>  {
>  }
> -- 
> 2.39.5
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

