Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C3FAF36C5E
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 11:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60D76B0005; Mon, 20 Apr 2026 07:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B396E6B0088; Mon, 20 Apr 2026 07:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A767C6B0089; Mon, 20 Apr 2026 07:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 981476B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:56:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D33DC2FF0
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:56:27 +0000 (UTC)
X-FDA: 84678781614.29.B8A2AA2
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf26.hostedemail.com (Postfix) with ESMTP id D700B14000C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 11:56:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BOO3af0g;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776686185;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uAqAKYkhN6D96c96Mv9PAQs6rNA7+9Ka0YDLN+X5iC4=;
	b=hzah5rPOf0cf+VLMLYK6bq+Qq/tmwidSzPnYLw843e3nEd/E/Fw9kIZEVRiIOn9kDFD6s2
	UtUbMCZpgNi+ZAP0jyb2M0FU88/Frs3cPXjLjpdOVs4EYUsHYIn/XR/FUjfK82vzYXFlhH
	LzZfQwv9fsBS75veekYUJrwHTkgzA3E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BOO3af0g;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of pankaj.raghav@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=pankaj.raghav@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776686185; a=rsa-sha256;
	cv=none;
	b=Ow2U/DC7uMGi798GR8i2otCU77Gm7trIeZQ9o8KzhOIyqpOJVAAfuT0EOt6D+zONUVThBU
	DSQHfUDOxFGYkx2SsdMRMOvLZrAlOk8+FrMh0xFslHL+cOmfHdm1T/WvSaJf8hc4X+VC2A
	0wgUDI83oqrneCMt+upjx2v3J5KXAr4=
Date: Mon, 20 Apr 2026 13:56:02 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776686180;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uAqAKYkhN6D96c96Mv9PAQs6rNA7+9Ka0YDLN+X5iC4=;
	b=BOO3af0gd3cgHZ6BarDqfWQl4LroCnTbHD7ZxIa8ukzF4qfyDvi5w9ObOE+3H9L6f284ws
	MyPfwi3MypvbroQc88CJMHlPh2BxedJNolYfQO4EqQdCoh7AotS0k7bMMjnzBOcD9LXa8j
	GBifeO6xiuzr5WPOIEakFm1d8dj/ljY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de, 
	ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>, 
	dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de, 
	brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 2/5] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <kvxvy26jblhx6sijbhxbpzzwltfoskwkv2suqhop5dq742fn5y@5tlws6pzaol3>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d44171d5a1ec783722019ad7d1a4ede0478cc914.1775658795.git.ojaswin@linux.ibm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D700B14000C
X-Stat-Signature: nb65m6seqyhj6bnxptfbgarq9dga1s9z
X-HE-Tag: 1776686183-956845
X-HE-Meta: U2FsdGVkX18PB0yyrzxJSm7WNk7gGLQCBwspaWj+3wlrUjdr+YOOBPM67sHPi+x2Jb3gux34aGuR7Xzev0t0k83/udIDVl1t22eIyIiTrS36Q3hG/FXyBBh9dwcFgY7TNNPRXtidjUeQ1FoC3bZpkN6mdzbdmd1SdiN3GdST631WZrrblbBNR5un81q+3goIKVKRwr+fDmuOtaSv/NMuF7j8TXyvjNbrOGmrECtbfUZ3/8egzQFbNOdu9kQK8I2nQT/7Aj5/B2DuXV8D5D+Ui9mpRLXiCCIuLlgHtxTY1+rcsokm2rtn5gxTRZMX85cLIxXv0JxfXeZ3getzi5nHPuckPFoqx9kxSzM9pjrfBsnMgGog/7u4lg+2mZAUUu07SDRrEBHk0gRbJS0EazbcjAs0fN4f/c9qrThh+6m9k5GKRgBHYuyXAjUEMdjjTe95iABRya7xbeJlPYvrGMbKU2N2k63ThCnqQQmEa1r7dqs5RMV9AA7O1xCjY1mNK83JMJFI3R86drPuh6DSxJn/0A3lWdKQcNFiOGkkGZYuvqAExFoJrRJ2xjJwY1c1fo5K1Sht0eDFeuOesp8406V7PowgXygsd4qEzT5GXSEr5r06B9t3ZVdFSApoo4yAgb0mrGRmuRKMTRYBTUdP3aUdvPXrDT/tmxr4gikjjEgTyt0NOw+4comOD5FaVmxMOxpHy9mO6jobTdQi9iODLgx9/rVkuQzS9hpFRp3wi5xE6P07e0ri0XxXFaTlOL9z9AjBDJuiNrKEaLvIp3lTj8RjSHIOZQ60Y9mBH4OCwu4Amypln6qmePtjP5Zg1j+/RBQUi3qszWg9N/kJpTqtoeWUsKpiRwLt3p6x22jKrrCFPiIUcSq5FtOOWIJb5d5MRXZIuihFwTq0j5KIDfQTMgKMB1Fw40+dhGrFNtUlSXpjkXdOT3Y4FBAFfGG8wpP/uM9dJDLTyrCZNnOkK0+LzQ7
 dADgC13w
 rXRKng8cUIygJhPkDfMufV+OucHq+zMrEorElVSeQ3zNuljuzyOkf9e6mIle+m6UypxpU5vPkmUlLtdENTH48qRPssxuI7Fa5VRDXjnmdMajxBLpoPShrhGVMIJ5XFT5MPTwYDBBMDSP6h8B6L2E0uaN6hSqXyFKmSNxyfbGPD8l5uSD2wPC9bbfeND1MIMXsq/1Bj+uaamKkMggWBE895qyLdpOm40dgmU/XRpi/EJo40jZYqxkZ6GJShMjun+d7Hf1cs+aNUMv5vm+xr1YPLbE9smPiuoxZzT+x7dghsABcsD9FSM7Cdo5lIqsCR3hGa2hZdns3CjlBJ/U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> +
> +	if (wt_ops->writethrough_submit)
> +		wt_ops->writethrough_submit(wt_ctx->inode, iomap, wt_ctx->bio_pos,
> +					    len);
> +
> +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, REQ_OP_WRITE, GFP_NOFS);

We might want to check if bio_alloc succeeded here.

> +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
> +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
> +	bio->bi_private		= wt_ctx;
> +
> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> +		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
> +				wt_ctx->bvec[i].bv_len,
> +				wt_ctx->bvec[i].bv_offset);
> +
> +	atomic_inc(&wt_ctx->ref);
> +	submit_bio(bio);
> +	wt_ctx->nr_bvecs = 0;
> +}
> +
<snip>
> +
> +/**
> + * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
> + * @wt_ctx: writethrough context
> + * @iter: iomap iter holding mapping information
> + * @i: iov_iter for write
> + * @wt_ops: the fs callbacks needed for writethrough
> + *
> + * This function copies the user buffer to folio similar to usual buffered
> + * IO path, with the difference that we immediately issue the IO. For this we
> + * utilize IO submission and completion mechanism that is inspired by dio.
> + *
> + * Folio handling note: We might be writing through a partial folio so we need
> + * to be careful to not clear the folio dirty bit unless there are no dirty blocks
> + * in the folio after the writethrough.
> + */
> +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> +				   struct iomap_iter *iter, struct iov_iter *i,
> +				   const struct iomap_writethrough_ops *wt_ops)
> +
> +{
> +	ssize_t total_written = 0;
> +	int status = 0;
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	size_t chunk = mapping_max_folio_size(mapping);
> +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> +	unsigned int bs = i_blocksize(iter->inode);
> +
> +	/* copied over based on DIO handles these flags */
> +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> +	if (iter->iomap.flags & IOMAP_F_SHARED)
> +		wt_ctx->flags |= IOMAP_DIO_COW;
> +
> +	if (!(iter->flags & IOMAP_WRITETHROUGH))
> +		return -EINVAL;
> +
> +	do {
> +		struct folio *folio;
> +		size_t offset;		/* Offset into folio */
> +		u64 bytes;		/* Bytes to write to folio */
> +		size_t copied;		/* Bytes copied from user */
> +		u64 written;		/* Bytes have been written */
> +		loff_t pos;
> +		size_t off_aligned, len_aligned;
> +
> +		bytes = iov_iter_count(i);
> +retry:
> +		offset = iter->pos & (chunk - 1);
> +		bytes = min(chunk - offset, bytes);
> +		status = balance_dirty_pages_ratelimited_flags(mapping,
> +							       bdp_flags);
> +		if (unlikely(status))
> +			break;
> +
> +		/*
> +		 * If completions already occurred and reported errors, give up
> +		 * now and don't bother submitting more bios.
> +		 */
> +		if (unlikely(data_race(wt_ctx->error))) {

In the unlikely scenario where we encounter an error, do we have to also
clear the writeback flag on all the folios that is part of this
bvec until now?

Something like explicitly iterate over wt_ctx->bvec[0] through 
wt_ctx->bvec[nr_bvecs - 1], manually call folio_end_writeback(bvec[i].bv_page)
on them, and then discard the bvecs by setting the nr_bvecs = 0;

I am wondering if the folios that were processed until now will be in
PG_WRITEBACK state which can affect reclaim as we never clear the flag.

> +			wt_ctx->nr_bvecs = 0;
> +			break;
> +		}
> +

--
Pankaj

