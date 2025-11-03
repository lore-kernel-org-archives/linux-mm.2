Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0B86CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 08:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDEF8E003C; Mon,  3 Nov 2025 03:21:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08E508E002A; Mon,  3 Nov 2025 03:21:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6768E003C; Mon,  3 Nov 2025 03:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC83A8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 03:21:51 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A37BF8937B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:21:51 +0000 (UTC)
X-FDA: 84068602422.19.251679E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 34016A0002
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 08:21:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DMUHCcR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BPloq+ei;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DMUHCcR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BPloq+ei;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762158109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8P+YFfYJ7Oo7a+aU12KSiOjJezUYQkqsHZDirkxMulU=;
	b=RGrIPE39nPMTYRA4WYlIyN/cd/jSRAdJyjYpq6Cj56Zwfa1jDIC3Rpk5qJPvib6aBACtsK
	Ku7WRgdNfafOmQsTkItTeMg28X8SBJOFCs3XxbY141i+bh8kp3rMSn8PxL0GPCTABv7ul9
	CYF88y0vS0wXGZuscnMBNDH9smgsVvI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762158109; a=rsa-sha256;
	cv=none;
	b=POF1+XlPMeoUNmMCJykaeVbmXjSz7t60hEgFi39YQpYx2/3FBLojaqjXCVuuu5JkEMEkMf
	sMsJLGcgrY2X/OARwXhRZwFVbnKTAt0tqDfatWK2wG5dUp+0Lmy4QcfV0YGS2Ap/CDi4Rn
	O8eq5cSCsNQVf3rOEzBg4SJZcyiMTwU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DMUHCcR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BPloq+ei;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=DMUHCcR6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BPloq+ei;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A6EC71F79B;
	Mon,  3 Nov 2025 08:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762158107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8P+YFfYJ7Oo7a+aU12KSiOjJezUYQkqsHZDirkxMulU=;
	b=DMUHCcR6PU0KZo8vatzMfsgP0j82Xe8C7r09DyOUFaX2fjzhrFNR4rapLwyrrJObZsCCyL
	S2AD7kVGZVhnqWppW2VjC196mhrW36sNM3sulFBAB9rNs1ELQQP5XXeKJCHi1OOJGKSlfM
	FJpE7fGndS4So+zhh1IBUipB5HcYsdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762158107;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8P+YFfYJ7Oo7a+aU12KSiOjJezUYQkqsHZDirkxMulU=;
	b=BPloq+eiULzzndArlKxR8wYpEuBzfMap5A+kCKfrJSza775RzS580B3BHrFnZ6E4h4MYut
	fx4ZlIk+1Hxhp/BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762158107; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8P+YFfYJ7Oo7a+aU12KSiOjJezUYQkqsHZDirkxMulU=;
	b=DMUHCcR6PU0KZo8vatzMfsgP0j82Xe8C7r09DyOUFaX2fjzhrFNR4rapLwyrrJObZsCCyL
	S2AD7kVGZVhnqWppW2VjC196mhrW36sNM3sulFBAB9rNs1ELQQP5XXeKJCHi1OOJGKSlfM
	FJpE7fGndS4So+zhh1IBUipB5HcYsdk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762158107;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8P+YFfYJ7Oo7a+aU12KSiOjJezUYQkqsHZDirkxMulU=;
	b=BPloq+eiULzzndArlKxR8wYpEuBzfMap5A+kCKfrJSza775RzS580B3BHrFnZ6E4h4MYut
	fx4ZlIk+1Hxhp/BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 92C1A1364F;
	Mon,  3 Nov 2025 08:21:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wlLQIxtmCGmNaQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Nov 2025 08:21:47 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 00409A2A64; Mon,  3 Nov 2025 09:21:38 +0100 (CET)
Date: Mon, 3 Nov 2025 09:21:38 +0100
From: Jan Kara <jack@suse.cz>
To: libaokun@huaweicloud.com
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, 
	jack@suse.cz, linux-kernel@vger.kernel.org, kernel@pankajraghav.com, 
	mcgrof@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, chengzhihao1@huawei.com, 
	libaokun1@huawei.com
Subject: Re: [PATCH 09/25] ext4: add EXT4_LBLK_TO_B macro for logical block
 to bytes conversion
Message-ID: <ejsz6cihhpg2qdxewjgq5j26dihf5m3twingzij3iow2igrilh@hvd5mvqw466d>
References: <20251025032221.2905818-1-libaokun@huaweicloud.com>
 <20251025032221.2905818-10-libaokun@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251025032221.2905818-10-libaokun@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 34016A0002
X-Rspamd-Server: rspam02
X-Stat-Signature: ikn9h4fn5dorzdtxsyse4rkrywnkwyq6
X-HE-Tag: 1762158108-853826
X-HE-Meta: U2FsdGVkX19Teuiw7nhjI7QJu2HrYvnYgWCaTLPHGWEF/vj8vQ1S14tK+CWrX8JGfeRqnef7oH/VwrFpf4Iq+VA6PdZ7gqvZbQNgPVVlvHFk1XHCmVND5NAvs1GaP0iiYbSYE0UPEC+xtmKpTSJBGsZYeLJzY+d/9hPUDPRLVIHLCQLWt0DRfr3XclTZVIBQuuUqCjiblkO38XZgVUgy9tDsiNegQFH008B9ayfOCbiw4V1U+NgH3kN0bLFgBvzsSVV6roQwOzc6CEnyhsjUjR5vvUxyUJ+XgrNxiTUTKfeMtzxf8bqGgbJRiDOyIaZ0TVMBAQLLLabavnDchCmC3xYfLdAyMTTHqdtIvyubSqvLXwC0iHzBJyyDwShOiMhXbon9g4+ZUmHVPMQOfLnKS+2O4pHTZjCiCOwZ1loYgK+cqBjYOV8g9Ui0qJwQc844sTAmviNwJb23jlvdHEjj9x+9DEHdabxF2gBcUDf6dbzvNdc+a8ShmjqBaikSp5qmnMVeshFTQwNTNFxrdiy1gpeaGdz19/+jGzEaCvJz5fjzS4Vbatzc+B2b3ZOHydhxP3PVD/vEY8UUjmswwoOmTqj1+Rfz3j/iF7Amux42yN7C4i5s41ba9hquI0WwzVt1AGZ+VjWa6gAXGah52XEVEVw7qs7RZfINbIdjom7RPkmCHbAxQRwSiQgXQONpQend4PyOGBepRsWQJVaWkP5Ze90qV2oBtlxjJqxNAowfWPRptcBzB3xP6Rq2WLa72Pv4IgKlJLRMFXuAk9fkfkePIzf/HYR7vPl8cH+0DlK3o8baBMXLSRl3hN7sgWq4J01vw/1HQwc1ttxm6Pv0VMeu1ltphp5IHZZF/PQ5RdFr9Sr2JWqMZlDlVPw1ToUB6FMa9FjKMPYFG7jJYNlvw7SYDAEOpGtbmus1jGa8QhKJartZ3UtGaC6my1X+OynPgAvtUcnfBuWjTorsPPeQc3g
 3WnR++CW
 ZW5C2/1hpEMkUdVEFPtlVqMPhv3v75R8kbDVaYFztIN8WQGja7i2vRQ51q/nXeB8u+1ShNYWBONcZ1VBlIncfWp/Q8xq+w+yqWRsaoD25Ky8SYWa2G9CKGEzSTAcdIxWiTc0e6z+Nppo5yfl1LLERnrW3+2IH9Z/PECMsvN8ARsGb5XVVkVOtIyYkkXoVRNQ/4+RNb0VTJYtZGYne0c+oVn4ZHQIUnlRZ8hJN80wlznqnDvl9e7oGfsydWLM6eRqb15QpJsV+WZcRmWB2i3Gg3PvfDSAhN6geSkib66wM8E+ItR+ifl2oqj5NDx6y51/wK9SIwlYujVsoiU98M3uVfwr0ufPDfQGwhwaYXQXc+rseCVEVhsOQZ1cngVP0DegiAjBqTkCFWpiB4bLdxog6yRGaYt8pjZwsDOPcDrSMbD/L54ukckubnebfbc6TIc0c0fT0hvU+0puP6Q3g/9hMx0go2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat 25-10-25 11:22:05, libaokun@huaweicloud.com wrote:
> From: Baokun Li <libaokun1@huawei.com>
> 
> No functional changes.
> 
> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Reviewed-by: Zhang Yi <yi.zhang@huawei.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/ext4/ext4.h    |  1 +
>  fs/ext4/extents.c |  2 +-
>  fs/ext4/inode.c   | 20 +++++++++-----------
>  fs/ext4/namei.c   |  8 +++-----
>  fs/ext4/verity.c  |  2 +-
>  5 files changed, 15 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index bca6c3709673..9b236f620b3a 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -367,6 +367,7 @@ struct ext4_io_submit {
>  								  blkbits))
>  #define EXT4_B_TO_LBLK(inode, offset) \
>  	(round_up((offset), i_blocksize(inode)) >> (inode)->i_blkbits)
> +#define EXT4_LBLK_TO_B(inode, lblk) ((loff_t)(lblk) << (inode)->i_blkbits)
>  
>  /* Translate a block number to a cluster number */
>  #define EXT4_B2C(sbi, blk)	((blk) >> (sbi)->s_cluster_bits)
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index ca5499e9412b..da640c88b863 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -4562,7 +4562,7 @@ static int ext4_alloc_file_blocks(struct file *file, ext4_lblk_t offset,
>  		 * allow a full retry cycle for any remaining allocations
>  		 */
>  		retries = 0;
> -		epos = (loff_t)(map.m_lblk + ret) << blkbits;
> +		epos = EXT4_LBLK_TO_B(inode, map.m_lblk + ret);
>  		inode_set_ctime_current(inode);
>  		if (new_size) {
>  			if (epos > new_size)
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 889761ed51dd..73c1da90b604 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -825,9 +825,8 @@ int ext4_map_blocks(handle_t *handle, struct inode *inode,
>  		    !(flags & EXT4_GET_BLOCKS_ZERO) &&
>  		    !ext4_is_quota_file(inode) &&
>  		    ext4_should_order_data(inode)) {
> -			loff_t start_byte =
> -				(loff_t)map->m_lblk << inode->i_blkbits;
> -			loff_t length = (loff_t)map->m_len << inode->i_blkbits;
> +			loff_t start_byte = EXT4_LBLK_TO_B(inode, map->m_lblk);
> +			loff_t length = EXT4_LBLK_TO_B(inode, map->m_len);
>  
>  			if (flags & EXT4_GET_BLOCKS_IO_SUBMIT)
>  				ret = ext4_jbd2_inode_add_wait(handle, inode,
> @@ -2225,7 +2224,6 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
>  	ext4_lblk_t lblk = *m_lblk;
>  	ext4_fsblk_t pblock = *m_pblk;
>  	int err = 0;
> -	int blkbits = mpd->inode->i_blkbits;
>  	ssize_t io_end_size = 0;
>  	struct ext4_io_end_vec *io_end_vec = ext4_last_io_end_vec(io_end);
>  
> @@ -2251,7 +2249,8 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
>  					err = PTR_ERR(io_end_vec);
>  					goto out;
>  				}
> -				io_end_vec->offset = (loff_t)mpd->map.m_lblk << blkbits;
> +				io_end_vec->offset = EXT4_LBLK_TO_B(mpd->inode,
> +								mpd->map.m_lblk);
>  			}
>  			*map_bh = true;
>  			goto out;
> @@ -2261,7 +2260,7 @@ static int mpage_process_folio(struct mpage_da_data *mpd, struct folio *folio,
>  			bh->b_blocknr = pblock++;
>  		}
>  		clear_buffer_unwritten(bh);
> -		io_end_size += (1 << blkbits);
> +		io_end_size += i_blocksize(mpd->inode);
>  	} while (lblk++, (bh = bh->b_this_page) != head);
>  
>  	io_end_vec->size += io_end_size;
> @@ -2463,7 +2462,7 @@ static int mpage_map_and_submit_extent(handle_t *handle,
>  	io_end_vec = ext4_alloc_io_end_vec(io_end);
>  	if (IS_ERR(io_end_vec))
>  		return PTR_ERR(io_end_vec);
> -	io_end_vec->offset = ((loff_t)map->m_lblk) << inode->i_blkbits;
> +	io_end_vec->offset = EXT4_LBLK_TO_B(inode, map->m_lblk);
>  	do {
>  		err = mpage_map_one_extent(handle, mpd);
>  		if (err < 0) {
> @@ -3503,8 +3502,8 @@ static void ext4_set_iomap(struct inode *inode, struct iomap *iomap,
>  		iomap->dax_dev = EXT4_SB(inode->i_sb)->s_daxdev;
>  	else
>  		iomap->bdev = inode->i_sb->s_bdev;
> -	iomap->offset = (u64) map->m_lblk << blkbits;
> -	iomap->length = (u64) map->m_len << blkbits;
> +	iomap->offset = EXT4_LBLK_TO_B(inode, map->m_lblk);
> +	iomap->length = EXT4_LBLK_TO_B(inode, map->m_len);
>  
>  	if ((map->m_flags & EXT4_MAP_MAPPED) &&
>  	    !ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> @@ -3678,7 +3677,6 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
>  			    unsigned int flags)
>  {
>  	handle_t *handle;
> -	u8 blkbits = inode->i_blkbits;
>  	int ret, dio_credits, m_flags = 0, retries = 0;
>  	bool force_commit = false;
>  
> @@ -3737,7 +3735,7 @@ static int ext4_iomap_alloc(struct inode *inode, struct ext4_map_blocks *map,
>  	 * i_disksize out to i_size. This could be beyond where direct I/O is
>  	 * happening and thus expose allocated blocks to direct I/O reads.
>  	 */
> -	else if (((loff_t)map->m_lblk << blkbits) >= i_size_read(inode))
> +	else if (EXT4_LBLK_TO_B(inode, map->m_lblk) >= i_size_read(inode))
>  		m_flags = EXT4_GET_BLOCKS_CREATE;
>  	else if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
>  		m_flags = EXT4_GET_BLOCKS_IO_CREATE_EXT;
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index 2cd36f59c9e3..78cefb7cc9a7 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1076,7 +1076,7 @@ static int htree_dirblock_to_tree(struct file *dir_file,
>  	for (; de < top; de = ext4_next_entry(de, dir->i_sb->s_blocksize)) {
>  		if (ext4_check_dir_entry(dir, NULL, de, bh,
>  				bh->b_data, bh->b_size,
> -				(block<<EXT4_BLOCK_SIZE_BITS(dir->i_sb))
> +				EXT4_LBLK_TO_B(dir, block)
>  					 + ((char *)de - bh->b_data))) {
>  			/* silently ignore the rest of the block */
>  			break;
> @@ -1630,7 +1630,7 @@ static struct buffer_head *__ext4_find_entry(struct inode *dir,
>  		}
>  		set_buffer_verified(bh);
>  		i = search_dirblock(bh, dir, fname,
> -			    block << EXT4_BLOCK_SIZE_BITS(sb), res_dir);
> +				    EXT4_LBLK_TO_B(dir, block), res_dir);
>  		if (i == 1) {
>  			EXT4_I(dir)->i_dir_start_lookup = block;
>  			ret = bh;
> @@ -1710,7 +1710,6 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
>  			struct ext4_filename *fname,
>  			struct ext4_dir_entry_2 **res_dir)
>  {
> -	struct super_block * sb = dir->i_sb;
>  	struct dx_frame frames[EXT4_HTREE_LEVEL], *frame;
>  	struct buffer_head *bh;
>  	ext4_lblk_t block;
> @@ -1729,8 +1728,7 @@ static struct buffer_head * ext4_dx_find_entry(struct inode *dir,
>  			goto errout;
>  
>  		retval = search_dirblock(bh, dir, fname,
> -					 block << EXT4_BLOCK_SIZE_BITS(sb),
> -					 res_dir);
> +					 EXT4_LBLK_TO_B(dir, block), res_dir);
>  		if (retval == 1)
>  			goto success;
>  		brelse(bh);
> diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
> index d9203228ce97..7a980a8059bd 100644
> --- a/fs/ext4/verity.c
> +++ b/fs/ext4/verity.c
> @@ -302,7 +302,7 @@ static int ext4_get_verity_descriptor_location(struct inode *inode,
>  
>  	end_lblk = le32_to_cpu(last_extent->ee_block) +
>  		   ext4_ext_get_actual_len(last_extent);
> -	desc_size_pos = (u64)end_lblk << inode->i_blkbits;
> +	desc_size_pos = EXT4_LBLK_TO_B(inode, end_lblk);
>  	ext4_free_ext_path(path);
>  
>  	if (desc_size_pos < sizeof(desc_size_disk))
> -- 
> 2.46.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

