Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8488FCA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6A88E000B; Wed,  3 Sep 2025 14:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBDB58E0001; Wed,  3 Sep 2025 14:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAD378E000B; Wed,  3 Sep 2025 14:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B7F5C8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:49:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 538C91A082B
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:49:43 +0000 (UTC)
X-FDA: 83848827846.24.5286293
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6D978160015
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:49:41 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ERcPVr2t;
	spf=pass (imf08.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756925381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlsHyD8qFclQgXEjGTKjDJD1rFu3mlPS6ILNfKfG5wA=;
	b=jILb94XWpO8pT6krog/amtFIpM5w/W20JBufCGmvvOXPgGmjeGZWCE9WfB5pXYO/l5C/RP
	WUGN+St4c/l2PlaHiCoHCTQAINpGEpiwNm8Dzv7Po6rw3jZNCsM49HxslepZL4gTbhcdhA
	xyotQv1TirR2MkWipzv2lxmfSHPwIUs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ERcPVr2t;
	spf=pass (imf08.hostedemail.com: domain of bfoster@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bfoster@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756925381; a=rsa-sha256;
	cv=none;
	b=lDTDwcctwxXncPhZuKMD0zFKMFQAE5nWZKdDsfe9tcKS4/JEbXCf3PaTzv1qKIS1xifQ5n
	cvP03xwnIrkpdvCv+duuWH+/LQOi/dSQfiDZcsjbRffXHRfXkot0iqnkwxulhmRjmKRcpP
	ahjhvgO/TuGqO/xsLKAWf/I4IL5LQYQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756925380;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rlsHyD8qFclQgXEjGTKjDJD1rFu3mlPS6ILNfKfG5wA=;
	b=ERcPVr2tvJOD8VGPSZP7A74rXhu2mqeKy3NVYBsmtBXbAEeMBy0CLLcLNR2Xcdhy3sO50H
	kUBQ1w+aOIs1QqYgH50CZZxnrMMVscDwb9sd98cN0/F0398/hH0UPykNqvEz+U1QazhSJP
	Lxot75AK/kmgExfI3AgADddwdreifms=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-171-L0DAT_DfOwa0swGZDg2KjA-1; Wed,
 03 Sep 2025 14:49:35 -0400
X-MC-Unique: L0DAT_DfOwa0swGZDg2KjA-1
X-Mimecast-MFC-AGG-ID: L0DAT_DfOwa0swGZDg2KjA_1756925373
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E60219560B0;
	Wed,  3 Sep 2025 18:49:33 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.143])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1C4901956056;
	Wed,  3 Sep 2025 18:49:30 +0000 (UTC)
Date: Wed, 3 Sep 2025 14:53:33 -0400
From: Brian Foster <bfoster@redhat.com>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, brauner@kernel.org, willy@infradead.org,
	jack@suse.cz, hch@infradead.org, djwong@kernel.org,
	jlayton@kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 10/12] iomap: refactor dirty bitmap iteration
Message-ID: <aLiOrcetNAvjvjtk@bfoster>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
 <20250829233942.3607248-11-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250829233942.3607248-11-joannelkoong@gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Queue-Id: 6D978160015
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: eo7zqnis8o93tqcwsed7xp78g5ckwgzf
X-HE-Tag: 1756925381-859182
X-HE-Meta: U2FsdGVkX1/qAbjKiY8b/a6l6H56VZT2gkc0/0ypmjKipC7i6F6kj17XFxbOGafYBBiSf/5i2h7/wa43K7zT+27DfZYyPEt+xcKCUG61qSwCzRQiBxdSjjSVb5hvb2UD7ZukvfxpK8pBAVTSDTqz1WViIABJklsq9hjVxCcJvT+aT5etbQOsvWvHoPdeq/eDWV+LpNceH7cHDm9E6jjLGJW7fG4/WyLt8ZC2GePHiI1s2Ufo7h4Kit4rKW2uwm6GKtlELJogyEZY4ZYN5wPf9RlXbBNq3RnmuWENRzGW/1ye2LA2BmE6Pn2D5BLf1rmr0QOaYERjMo0N5KA8Oe60pX1Tf1oJejXMJg9dE+WFsMYv8YbcxsYloTl+a762uQKvVxMJVOfUbC8Zkx9l/gix0UX1Zao5ohE9eRSu9tClAi8qSgu9cjZX0ykqH6Otmr6f4ghI/oB7NvOk56CQGcXLwI+xcY2ZNchT0AQf+HLDgPxhrTNtemgqU/DBK1VAX2tV4LKPeZji12Y8LswCFKJRnWTsRzTbJfkVxH2rmYFQsiwKmJ+QJ3ooY3lj0yIh4/oOvjElVanJGGPbFwqWeABVAIOHYKjMkrjJqfSLnEQM24d1zHgnAKLkzz6O8NECTj9hhsHMEoAjEtvYSTbRoyEzdMAEmZIuG5cnOVy30xRO1x72aF/kJ/UDJNpTzL0Mm+9IsEIx1F7ZZ1gp08uD4Nx4fwGmA0Vg1ItFhlPlbTYPrYUx5o+6A2xFs+ORKMngJQRE+1sTWVwFnEORXU39407ZC+ac73KtsPa/n126BmPiUeuG3uSqebNNGAU9NDqdk810NvRYF8hCMVklPr9rjkGQyawIu3r3eC6C1lWyMolHV1eHrHS7jvyj8fos7UzNtn4FHYJd9GW46YZKl15DqgbQWF/cO44Gh023X3AL06RNz3j+kruHvXGW3cIORYBfFcQzUCN8Bkmj1dHT+LZnvuy
 fshLk8Sb
 xecwZ9MqnhAXJF2Rd3+8EzqjsamKQ3Nsch64Z98j5++pu0ximzk17dOcpxBpMLKAl8gN6nOZFIZmcrNCZuLeE+znvbQBfOwAPnidmuOM/y64UsKR11q6Nlct/GyfmQEWgQQYYRJ/JPQV6dcL1CXMt3Bqlwmq6dcX5WUOOcCYl0QviNzZB+1DXG+ej/zQdvPaioSWbW8rlb9reLklPBrFqgL3aZGFdhf3qZebnWwWzWY5HEhXXYmpTvrD9AK+bzDmSrG6JjV3uUTR2Ub83guBMhqMP9raF9yJ7/1dS3yO5scWY4Hd4fnSAGJMd8/r2lK00e/g1tsr2YGfq7GeIhihq5PQ8iCZt9+zDUYW893COH8Vd7rQAqXIFbce2O7sYzmiljk2541rTGB8UT6gc3DRMS6piIgp7tDH992B7N4g1KpeV41f5M5pygphJysTvfS0TEDtw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 29, 2025 at 04:39:40PM -0700, Joanne Koong wrote:
> Use find_next_bit()/find_next_zero_bit() for iomap dirty bitmap
> iteration. This uses __ffs() internally and is more efficient for
> finding the next dirty or clean bit than manually iterating through the
> bitmap range testing every bit.
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> ---
>  fs/iomap/buffered-io.c | 67 ++++++++++++++++++++++++++++++------------
>  1 file changed, 48 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index fd827398afd2..dc1a1f371412 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -75,13 +75,42 @@ static void iomap_set_range_uptodate(struct folio *folio, size_t off,
>  		folio_mark_uptodate(folio);
>  }
>  
> -static inline bool ifs_block_is_dirty(struct folio *folio,
> -		struct iomap_folio_state *ifs, int block)
> +/**
> + * ifs_next_dirty_block - find the next dirty block in the folio
> + * @folio: The folio
> + * @start_blk: Block number to begin searching at
> + * @end_blk: Last block number (inclusive) to search
> + *
> + * If no dirty block is found, this will return end_blk + 1.
> + */
> +static unsigned ifs_next_dirty_block(struct folio *folio,
> +		unsigned start_blk, unsigned end_blk)
>  {
> +	struct iomap_folio_state *ifs = folio->private;
>  	struct inode *inode = folio->mapping->host;
> -	unsigned int blks_per_folio = i_blocks_per_folio(inode, folio);
> +	unsigned int blks = i_blocks_per_folio(inode, folio);
> +
> +	return find_next_bit(ifs->state, blks + end_blk + 1,
> +		blks + start_blk) - blks;
> +}
> +
> +/**
> + * ifs_next_clean_block - find the next clean block in the folio
> + * @folio: The folio
> + * @start_blk: Block number to begin searching at
> + * @end_blk: Last block number (inclusive) to search
> + *
> + * If no clean block is found, this will return end_blk + 1.
> + */
> +static unsigned ifs_next_clean_block(struct folio *folio,
> +		unsigned start_blk, unsigned end_blk)
> +{
> +	struct iomap_folio_state *ifs = folio->private;
> +	struct inode *inode = folio->mapping->host;
> +	unsigned int blks = i_blocks_per_folio(inode, folio);
>  
> -	return test_bit(block + blks_per_folio, ifs->state);
> +	return find_next_zero_bit(ifs->state, blks + end_blk + 1,
> +		blks + start_blk) - blks;
>  }
>  
>  static unsigned ifs_find_dirty_range(struct folio *folio,
> @@ -92,18 +121,15 @@ static unsigned ifs_find_dirty_range(struct folio *folio,
>  		offset_in_folio(folio, *range_start) >> inode->i_blkbits;
>  	unsigned end_blk = min_not_zero(
>  		offset_in_folio(folio, range_end) >> inode->i_blkbits,
> -		i_blocks_per_folio(inode, folio));
> -	unsigned nblks = 1;
> +		i_blocks_per_folio(inode, folio)) - 1;
> +	unsigned nblks;
>  
> -	while (!ifs_block_is_dirty(folio, ifs, start_blk))
> -		if (++start_blk == end_blk)
> -			return 0;
> +	start_blk = ifs_next_dirty_block(folio, start_blk, end_blk);
> +	if (start_blk > end_blk)
> +		return 0;
>  
> -	while (start_blk + nblks < end_blk) {
> -		if (!ifs_block_is_dirty(folio, ifs, start_blk + nblks))
> -			break;
> -		nblks++;
> -	}
> +	nblks = ifs_next_clean_block(folio, start_blk + 1, end_blk)
> +		- start_blk;

Not a critical problem since it looks like the helper bumps end_blk, but
something that stands out to me here as mildly annoying is that we check
for (start > end) just above, clearly implying that start == end is
possible, then go and pass start + 1 and end to the next call. It's not
clear to me if that's worth changing to make end exclusive, but may be
worth thinking about if you haven't already..

Brian

>  
>  	*range_start = folio_pos(folio) + (start_blk << inode->i_blkbits);
>  	return nblks << inode->i_blkbits;
> @@ -1077,7 +1103,7 @@ static void iomap_write_delalloc_ifs_punch(struct inode *inode,
>  		struct folio *folio, loff_t start_byte, loff_t end_byte,
>  		struct iomap *iomap, iomap_punch_t punch)
>  {
> -	unsigned int first_blk, last_blk, i;
> +	unsigned int first_blk, last_blk;
>  	loff_t last_byte;
>  	u8 blkbits = inode->i_blkbits;
>  	struct iomap_folio_state *ifs;
> @@ -1096,10 +1122,13 @@ static void iomap_write_delalloc_ifs_punch(struct inode *inode,
>  			folio_pos(folio) + folio_size(folio) - 1);
>  	first_blk = offset_in_folio(folio, start_byte) >> blkbits;
>  	last_blk = offset_in_folio(folio, last_byte) >> blkbits;
> -	for (i = first_blk; i <= last_blk; i++) {
> -		if (!ifs_block_is_dirty(folio, ifs, i))
> -			punch(inode, folio_pos(folio) + (i << blkbits),
> -				    1 << blkbits, iomap);
> +	while (first_blk <= last_blk) {
> +		first_blk = ifs_next_clean_block(folio, first_blk, last_blk);
> +		if (first_blk > last_blk)
> +			break;
> +		punch(inode, folio_pos(folio) + (first_blk << blkbits),
> +			1 << blkbits, iomap);
> +		first_blk++;
>  	}
>  }
>  
> -- 
> 2.47.3
> 
> 


