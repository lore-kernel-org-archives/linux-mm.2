Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BFBCCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 12:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 594D88E0084; Fri, 24 Oct 2025 08:13:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544148E0042; Fri, 24 Oct 2025 08:13:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C9F8E0084; Fri, 24 Oct 2025 08:13:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F8778E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 08:13:24 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4059BE55B
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:13:23 +0000 (UTC)
X-FDA: 84032897886.02.794C10E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id AE7AE1A000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 12:13:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CjojHoYq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1acUFfy3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CjojHoYq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1acUFfy3;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761308002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AkVO73khQEXexPsxQT0RVGnJrziAwGHpdDpx2ltyfZ0=;
	b=s6S9HPV4fQ5/+USpvijrFVjaiMR1X3zJogHqbPyYylDJyvca5za8obZpXefJO1nZ80dhUt
	hM5YNerdTQ4YFngnRCyeLKucyJJ7P8jh302z47T23+66d/czabQ1p5AHXd4YGayUt0Holv
	0z/WSdpYTo5FxSHCZ7+aW4gMPD700LM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761308002; a=rsa-sha256;
	cv=none;
	b=5VP1YObT+QnFr2fc2ZiDoDg726SErMnS+oDSjcOw572qhICmx3f4PpyJ1/BaAD5HyfK0MI
	uq+wqql36cLlA298hlhtuHnYNoaPOaONH4AozKqGdU096yDTZq5JmZZlUjX8AsrV+vvpVw
	NGPFkjqxGgAF0Ki43s3HKY7d7ltpkwY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CjojHoYq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1acUFfy3;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CjojHoYq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1acUFfy3;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 46D6C2120A;
	Fri, 24 Oct 2025 12:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761308000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AkVO73khQEXexPsxQT0RVGnJrziAwGHpdDpx2ltyfZ0=;
	b=CjojHoYqaGMzfr5XqNusQqu1GyDxPy0hnR6Ldj+jMf2eYrTAdI2alMTnKoUSmrXoHvFzyY
	UToaifYK+aQl8TtK32yOMGz7StJr1kY/XFCLmL8yl3rGsIxvYxpuaYXr9RvWQe45kcVwON
	5/tuFmNtP0/OwY0IBwV80drSEDaabHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761308000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AkVO73khQEXexPsxQT0RVGnJrziAwGHpdDpx2ltyfZ0=;
	b=1acUFfy3hGwnqk5XZUYklOyZE7Yzi46EVBZ/g+PJSSiLxPnydp7ewriPn0sf5iaWyR9gF9
	M2aK7AndCIkzA5Cg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761308000; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AkVO73khQEXexPsxQT0RVGnJrziAwGHpdDpx2ltyfZ0=;
	b=CjojHoYqaGMzfr5XqNusQqu1GyDxPy0hnR6Ldj+jMf2eYrTAdI2alMTnKoUSmrXoHvFzyY
	UToaifYK+aQl8TtK32yOMGz7StJr1kY/XFCLmL8yl3rGsIxvYxpuaYXr9RvWQe45kcVwON
	5/tuFmNtP0/OwY0IBwV80drSEDaabHk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761308000;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AkVO73khQEXexPsxQT0RVGnJrziAwGHpdDpx2ltyfZ0=;
	b=1acUFfy3hGwnqk5XZUYklOyZE7Yzi46EVBZ/g+PJSSiLxPnydp7ewriPn0sf5iaWyR9gF9
	M2aK7AndCIkzA5Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 301D713693;
	Fri, 24 Oct 2025 12:13:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Mwu+C2Bt+2jXOQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 24 Oct 2025 12:13:20 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3BF23A28AB; Fri, 24 Oct 2025 14:13:19 +0200 (CEST)
Date: Fri, 24 Oct 2025 14:13:19 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@lst.de>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>, 
	Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, 
	v9fs@lists.linux.dev, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net, 
	ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/10] mm: rename filemap_fdatawrite_range_kick to
 filemap_flush_range
Message-ID: <yybiur2jmv6s4n2sjlubwimmfbsrb3gx6tk67ki23jnqncaeba@wayirnpbaum3>
References: <20251024080431.324236-1-hch@lst.de>
 <20251024080431.324236-11-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024080431.324236-11-hch@lst.de>
X-Rspamd-Server: rspam01
X-Stat-Signature: b6q9g3o77ryq83z1bskro1icatc3enup
X-Rspam-User: 
X-Rspamd-Queue-Id: AE7AE1A000A
X-HE-Tag: 1761308001-18102
X-HE-Meta: U2FsdGVkX19L3zJiNY1Np930LlcTzyp2gn0XMPdHg8DszX6YXx0YpmUTREtbHfibmgsVbgqX/3akmz4z3aNhtkbSegZVGQ649r/HsZPGIq7b3Ydxu+6sy5TSzqLKSf7dxiBRLoDe8/9rXU48cPi9T6+JYP1kjh60NvaVXh8Az4gX5IXTYfhFvSNHKjrDPISnT61HNr448xxpgmcZFU8AtE9vBD/CALLmEp0lh+02HQoiX0UA6LYYMmY8QLOOqPH3pNjsmxj7gWdPOMFb7kUcUonBbHTAOcJwNq3xmRPPlHHVyFsIf5GNCzB3X60PqqGMRqS0i6v0hUfMkt2SoWr9UGxSbWCy6l9lkfeocOpbWNeUBr7+nqVvyG6ZvutCUNuo+4W/ovaF4Io6PPFOc4O/uLenxrIV++Tk5jKSuVLpfs/rJNJL7EjJtTNA1y43QHacN0nQTOL9dNJgNpYSCTr9bQ8oxPt6UWwjNpet0ILEtAEVL6i+Pz2m4OKdjzM5mSlXvmXSwTY1Uh4kFUKaQWvZA7mu/QAUnBwRycLd9+G84BcARlEisJIsW2W0hQLrSt4H2hL+iH4pSaZkiH73lGWGUBjJvw7Syn0D+KtyQzflNf41ivIXyphI3GTFdsJyhhxkUJTtb/2QpNCS7MZMM05XJsxlLI2UOsMnEMgIwFz+EhjAekxqP5j5ZhlZcRa3qPbdTg9/Bou7v89p/eBOPpz5inNgNRf0+ov14pWA86MIANW+CS+h+PzGqr9q9EnbuYNhhYhKeu5sBKslJprnV0HLvaDAQSB/Lz9AnW5lDNaagJkuh+hNU1sCzLIcAsrBgjbUOpYOzcPNv781aJl0RxG4pWigw0R3RldEVLWrgoRNFpPQan6B8YvX9RzaL8BxoHe1Mtz1/uoYMT7oLCEMVOSPFYJJ5UFtKincWw9e5xSuOAwBQi8Z2UnK/XMLft9zmu4HXBbvbpjPdXHQpO28cE/
 UdgApRn8
 M/KOtPnurrv+5dltdPb50MOsvkQ11bYYTFYPzkqlsQTJZV/li+OVIotwrCVjw/NImXH5Wb5dcBagaQVkoUXTWdqWVH0Jdt0Osb2sGPNV/glxv9g83cmhxtz4Xhvmgjs7X6OdvC7o9xSRHLvVGPrsp/gjlNX66+mC5/I9YINlW2OtxZCoOr8Dx8nAhO77vKHNHOP+58eARRi6rtI53kr/2JwVtsoOUzpGLHou9rSM8YXKLMUrh0BJB8I7Uj3UG2XMAR1aKfcUZKIXS7ooClRNfsnpg5h7Hvti0B93ZqBfk5HwxSn8WXURw7blfSjK/d/l1sjHNIJhRmFWaaJk3UDzvk7qM+nVADX65TrzBq/Mn5cnxnuw1lZfSHG5bVUCfWYbtRQEA6KE68xkEmSzPCZn8QF/KYB9HS6NRV31dM8OXLcl5v/4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 24-10-25 10:04:21, Christoph Hellwig wrote:
> Rename filemap_fdatawrite_range_kick to filemap_flush_range because it
> is the ranged version of filemap_flush.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/sync.c          | 3 +--
>  include/linux/fs.h | 6 +++---
>  mm/fadvise.c       | 2 +-
>  mm/filemap.c       | 8 ++++----
>  4 files changed, 9 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/sync.c b/fs/sync.c
> index 6d8b04e04c3c..1759f6ba36cd 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -285,8 +285,7 @@ int sync_file_range(struct file *file, loff_t offset, loff_t nbytes,
>  			ret = filemap_fdatawrite_range(mapping, offset,
>  					endbyte);
>  		else
> -			ret = filemap_fdatawrite_range_kick(mapping, offset,
> -					endbyte);
> +			ret = filemap_flush_range(mapping, offset, endbyte);
>  		if (ret < 0)
>  			goto out;
>  	}
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..a5dbfa20f8d7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3014,7 +3014,7 @@ extern int __must_check file_fdatawait_range(struct file *file, loff_t lstart,
>  extern int __must_check file_check_and_advance_wb_err(struct file *file);
>  extern int __must_check file_write_and_wait_range(struct file *file,
>  						loff_t start, loff_t end);
> -int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
> +int filemap_flush_range(struct address_space *mapping, loff_t start,
>  		loff_t end);
>  
>  static inline int file_write_and_wait(struct file *file)
> @@ -3051,8 +3051,8 @@ static inline ssize_t generic_write_sync(struct kiocb *iocb, ssize_t count)
>  	} else if (iocb->ki_flags & IOCB_DONTCACHE) {
>  		struct address_space *mapping = iocb->ki_filp->f_mapping;
>  
> -		filemap_fdatawrite_range_kick(mapping, iocb->ki_pos - count,
> -					      iocb->ki_pos - 1);
> +		filemap_flush_range(mapping, iocb->ki_pos - count,
> +				iocb->ki_pos - 1);
>  	}
>  
>  	return count;
> diff --git a/mm/fadvise.c b/mm/fadvise.c
> index f1be619f0e58..67028e30aa91 100644
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -111,7 +111,7 @@ int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>  		spin_unlock(&file->f_lock);
>  		break;
>  	case POSIX_FADV_DONTNEED:
> -		filemap_fdatawrite_range_kick(mapping, offset, endbyte);
> +		filemap_flush_range(mapping, offset, endbyte);
>  
>  		/*
>  		 * First and last FULL page! Partial pages are deliberately
> diff --git a/mm/filemap.c b/mm/filemap.c
> index f90f5bb2b825..fa770768ea3a 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -419,7 +419,7 @@ int filemap_fdatawrite(struct address_space *mapping)
>  EXPORT_SYMBOL(filemap_fdatawrite);
>  
>  /**
> - * filemap_fdatawrite_range_kick - start writeback on a range
> + * filemap_flush_range - start writeback on a range
>   * @mapping:	target address_space
>   * @start:	index to start writeback on
>   * @end:	last (inclusive) index for writeback
> @@ -429,12 +429,12 @@ EXPORT_SYMBOL(filemap_fdatawrite);
>   *
>   * Return: %0 on success, negative error code otherwise.
>   */
> -int filemap_fdatawrite_range_kick(struct address_space *mapping, loff_t start,
> +int filemap_flush_range(struct address_space *mapping, loff_t start,
>  				  loff_t end)
>  {
>  	return filemap_writeback(mapping, start, end, WB_SYNC_NONE, NULL);
>  }
> -EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
> +EXPORT_SYMBOL_GPL(filemap_flush_range);
>  
>  /**
>   * filemap_flush - mostly a non-blocking flush
> @@ -447,7 +447,7 @@ EXPORT_SYMBOL_GPL(filemap_fdatawrite_range_kick);
>   */
>  int filemap_flush(struct address_space *mapping)
>  {
> -	return filemap_fdatawrite_range_kick(mapping, 0, LLONG_MAX);
> +	return filemap_flush_range(mapping, 0, LLONG_MAX);
>  }
>  EXPORT_SYMBOL(filemap_flush);
>  
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

