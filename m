Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D149CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:45:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FC66B0099; Tue, 12 May 2026 12:45:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 866EF6B009F; Tue, 12 May 2026 12:45:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5A96B00A0; Tue, 12 May 2026 12:45:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA9A6B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:45:56 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 131B54016A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:45:56 +0000 (UTC)
X-FDA: 84759344712.27.5EA4FC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D826140007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:45:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTl8SWVy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778604354; a=rsa-sha256;
	cv=none;
	b=4C4EjPOtcFaVUEUBk993jRgwcoqT9otHRh/HImFtCSFPmvIF35DQaNyDEeI0kpJTzr25Dm
	7vECq07eN332gXx0WQcSvjznDRWLrw4b+PlQX1oDWNiHTjK1NJQXe0A2BDJ/1L25hevQ1H
	MdcEqrUVUNFGjepYLFAob8waoRrcBpU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KTl8SWVy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778604354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zU7gZAkNKhb92E+S2d+2ynnLov7xXLjK9tSHVkvMHEo=;
	b=JMx7cD51cwoecV5RJwp8chpvnMPQ9G9JjkmSskdUT8ZCiZoTNCEBVFLiZtWpRsUn/xFanC
	vHstPGAOcYULw2Ro5jDoeAjTeN9u9tHnnRzojg3hMT5kOtPDiw7CsJiMndDl2G2MqJr48Z
	5+PbAkBFtBKcfOG3nIGkROApXwLqR4w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 81E0A43CF3;
	Tue, 12 May 2026 16:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50240C2BCB0;
	Tue, 12 May 2026 16:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778604353;
	bh=AcAe4/elaHVR4qdaARIi+sqWloNOcTI2K7pOyCzPQJo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KTl8SWVyQT9eR0KJRerRA1Am+3qK8dO9BevMUKnMoH23CRP9mM5f3Wu8yquPkjamu
	 iDhJafpxFURM/nRV7YIcdF2vJ6mMlLYTcDMvY4jbNiIkyUsF9ww8yELMptMTkRbEh4
	 oMnRfp5DdCOcFHf+dy1yNxg//l2bSr3pQHtixqa4AlGaNF4Cxj1528N8RUtvReqe3h
	 SBiA5b1rqJP4iqw7iclgX7NmxGE5ZBDhsuApEownA7rjZzSFO99rRbfwmVruqi3YO8
	 sRA83twil/gSQfzUvwWP5wcTf/c5w5ehJsVY7Iboby7AQBhvuZnkU7BEEXnZxHnPWb
	 xain+gAgQ2EFA==
Date: Tue, 12 May 2026 09:45:52 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 07/12] swap,block: limit swap file size to device size
Message-ID: <20260512164552.GH9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-8-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-8-hch@lst.de>
X-Stat-Signature: iaf97hjuwttc5p3mzg6kz4qyhny5j68i
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D826140007
X-Rspamd-Server: rspam07
X-HE-Tag: 1778604354-982442
X-HE-Meta: U2FsdGVkX1+EMP+zliriqDZMCsUKOjvcBzRrN41sLyW011xhsCq2A9PhwnV/H956PBCKVp7w+K1oWxv/rPqkUqm3Am31awePFDsQJz9n2OfMfVh8kmENNBNoAvbSo+YoDGLmNFMdWFYsId97CXjLEE51tf0P7hSYqVw04h9D0ealO7X67TtMiyZAC4Ti6O1jbkkDWqTMtSyGR2gcIDob9SZTXFc8LjvfBOW+CFHawqeplLPyKW1CX4NW878Ak8sNg/L1gbTyf8fIARzFndfDwbN5bfkdwJcsd1pKTzjR6CDJWTFA8H3V+R+BH9gFwxlYKvKR2PC1Lf4xGr0zo7UOW8/+qo3HHB6eF7/9XPlJsiLpnsEiusnEVJx+hW12Hn22zJONMdJeBQh8/iW/rfQ1d284lfifaTgi0fPE0IYOSaxRnUU+MJ1+FgonyfoAheCE+fygQNa/Z1HSso79rc0dWxs0z/4PjEJzrLYEw+z+ViWrp0tviyIK9WRZa51ghzS2CVqZdFgtMDhi5CXmNAOhcnYWfzM1p72v74QKLhEs+JXmg1a6WhJguyuJXA7G/lTWnU4fF2PHeNZ/GjF2Zxu5j9RJApESX2pj1bbqby8x+1PXkTK908bR2vsZTsTEqD00Jx9w21Rrr3qcNbltXsimgPJVLnqddgns6UME91wWlaEskzxSlpaxtOvLUiiDYE9j77h0D+xUIa8+ooMfnugMB2Y+2thWKa0pYbQGa2Os0LiuU1bUdVheO9sqbowvMP/bRa5nLVt29Q6Rm/Z3v0H+JC0eYBd+2AzntewTmm9dPAYStKYdnFUFUmhJ80RrQ2m5MqQTat/ecDT3NM3CraPygQPZQFSVtZhM8ige1BavuVUN3bluxZ1Jhykk0FeDZVDn3Q3tkcEX34y4u9U6Of8A4EMLRUT0DeAIuP9fM3Wjo51CJcJo8XJcmXKEi6ItV1/o5zy1DSjy00vt9oeNqKg
 ki3WH1/f
 wNq6HjjnZmQ/BceTLqvcfvs/5jXX53UsyCUSgtMpbMnYExvKi3ZFXe8UtHzOjIBEe3QBWWa9A2JdjtnYUU2pDl3Gzicm8F7E3toF8uoiCAMzqVrzXn8dE8bfy3kCovSq1dpTvbRZokpj1euW+sZe/C7nYA+JNgojDh8vERWHnzEkbk1gYxGgi/256SuvaCVDRMTD6e5v4AGlAnoRHrsDRPWdJx9rrEbXUvM2OcLSadfS6LG6F2D/018lkNPygE5ojj82jWRqBRN9Vx/kHwJb2kecSDtBYcY9Kn6St9lyeGi3nEZJHPFcNIO4HXzkgezfz5GrGutbKI/ZQa3XadH9JiBk02eo4l33Tfgsb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:23AM +0200, Christoph Hellwig wrote:
> Don't blindly pass the value from the swap header to swap_add_extent,
> but instead the device size rounded down to page granularity.  This
> activated the sanity checking in the core code that catches a too large
> value in the swap header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  block/fops.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/block/fops.c b/block/fops.c
> index 453141801684..067e46299666 100644
> --- a/block/fops.c
> +++ b/block/fops.c
> @@ -951,7 +951,9 @@ static int blkdev_mmap_prepare(struct vm_area_desc *desc)
>  
>  static int blkdev_swap_activate(struct file *file, struct swap_info_struct *sis)
>  {
> -	return add_swap_extent(sis, sis->max, 0);
> +	loff_t isize = i_size_read(bdev_file_inode(file));

Good catch!

Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +
> +	return add_swap_extent(sis, div_u64(isize, PAGE_SIZE), 0);
>  }
>  
>  const struct file_operations def_blk_fops = {
> -- 
> 2.53.0
> 
> 

