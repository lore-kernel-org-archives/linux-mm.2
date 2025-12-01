Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1603D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A18A46B002F; Mon,  1 Dec 2025 16:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C86F6B0089; Mon,  1 Dec 2025 16:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F3AE6B00AD; Mon,  1 Dec 2025 16:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 704CF6B002F
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:24:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3AB9513202E
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:24:49 +0000 (UTC)
X-FDA: 84172181898.22.9F75052
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 870B4A000C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:24:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qE9nK5rR;
	spf=pass (imf25.hostedemail.com: domain of chao@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764624287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H3j0DhqmJeGYXSrLt4N7eKumGmioLd7IjoZqfyxZBFA=;
	b=bLrfHD5w+SfwqfoUV/QVtvCVfUrER5pZ9LU85AtGMJJawlusc1Rkf/eb0sUZ2hSQ/bvgsN
	HKU9EzRaaKhIbc0iCxoDCCSELAClLMuqylPltmps3J3i4bfIiw5Dul9Pqb7+vCJT/1A88J
	2Vxz/qP3IRvfdtWS5MRn7HaBAHn2IjI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qE9nK5rR;
	spf=pass (imf25.hostedemail.com: domain of chao@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764624287; a=rsa-sha256;
	cv=none;
	b=Mzb2qFWD+/SxX9gHPmF7U4cz+14QbO+CkKBE63AwkpTPmvhMPh2MZiHUaTtMvlY4yxHpT3
	5X8E7yYJOBo0lN4dQw3CTVY46HQGfYoQ8jGZ6rwT+hins8cejrgP/lIbOL8rdnrSkBPsFp
	7MSDG0vaG8rXQcorqPdERY+BzAzcyfw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 029C860152;
	Mon,  1 Dec 2025 21:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E66C4CEF1;
	Mon,  1 Dec 2025 21:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764624286;
	bh=6UGD/fGgHCQcObtOB1ey7uX6RIdFCH249Z9koV5esqo=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=qE9nK5rREhJIhcSRHka2jxPDQ9BNarNv+z77cnRpPOI02NwB8c7W+/kdY0IGO0fn0
	 XKWEuV1b7oZqmFkGmAS6N/AMwGDR6AtkEnfjTlrA8UQ6Hwy5GZGdGzxy9p7g9EWSL3
	 KuJjPB8joNKWUbw+5NBGRS63gzF+Y8JIZSyjQgTi/F2vWLL4qs4MsCMc413zC30Wyo
	 hOEpiUPx6wVp6GfntPhLVJFrp3DVKUo1owE4zlRsRB48e1U3C56UQeaKi7w3u72ImV
	 RRUD6FoHIItFeiYw2ipSQe8cfOffuBTcZrJuYBmblJKwpXOhIi6qb+I8ZsfbIqtH/1
	 p2RaIwsPbXfMg==
Message-ID: <381c2557-a714-41f6-8dd2-e0df1ca65919@kernel.org>
Date: Mon, 1 Dec 2025 13:24:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org
Subject: Re: [f2fs-dev] [PATCH 1/4] mm/readahead: fix the broken readahead for
 POSIX_FADV_WILLNEED
To: Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
 Matthew Wilcox <willy@infradead.org>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
 <20251201210152.909339-2-jaegeuk@kernel.org>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20251201210152.909339-2-jaegeuk@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xy7qxqpp8bfwwf4bo4y753snoadeemge
X-Rspam-User: 
X-Rspamd-Queue-Id: 870B4A000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1764624287-972695
X-HE-Meta: U2FsdGVkX1+0oSjC78dn5lBnbwahiacahgC6MH1kGxmuLJK6ASdZXKRjkD4RRHhNoSUwiwP1x6Duq8hMRaeQqI5SC45uMPeuMnLP/q0IMziJT4Teu34DPZPAmm03rhzonsdWPYFmkYU40Ob2MInrJ3S8b6mzzlD62kFV4R/yPAOYDXDYcM9liau5xmnoi3kjnGasD6iFQZdC6gv1wEru2b5if+/6STDSMVul5snZyM11qAmYhL2m/pc8J1HogwGIjrq5Qj8hFqPuq23edbR30WgDXX16fCV+Cg2gtvxcYM5OI6NCPnwNaCGzJfohvBYb0h5oj1sRQf4Dut5d7aejGrVQMGLi8BmlvUx+BWovFxlbbyaNu1vFItXd13Piws6frJPnqsOqR6bESjCvD/N4Bnoz8QaHqzQu7mcjILX4GBDSsbpD2Dmti2rEczMD8IEmo5ZQ28rqqmNSWZMbIezW7LrhW36TzUBaRAOM71rXwVufl1FeGhpQuUKEj8X0LuIJrrJ1fFy+/ozSTayGDUCTP/6XR3cplDIlKzb5VRYtT9vu7OmFMui2uj3FJDU/NgMR5/ueV0RTy1ME+clZLDGn+UlEwpEVaTraSiodvo3rret2m9dLjiPYtQhZJ5F6OQgMB3plj0In/F6xCknLgpI35ePqs0xXGynMt5YNReedCEoU/r92lLosqCx2uhb0XQE15yj7vTte0l36U7knt4x1wt+gjbC4KDZILGjnALM3oBUfpkPc6cGwOvyf6zXJRBngLsGA98vY010o1pav9X3FhfzXnSYu6Za0/EbcuBiYICekp98vyQU/FugVDW6SJ1j5mr3asTps3wglOKdvxHNHMb3XoVTNG9s+ujWOnPnN3yrxYwp+6wo1G5O2s/QkoDjBOQYi2zC3bXyX967+ZTcqja37z6QqLDZG/Wi/2GfhRdV52VNr5XuHmE+lLSEWT6aQEdTSrmGGXB2XD1FTvCx
 HrnXWkPI
 4W5I2eQ+z/MFDbB2irjvxN6rvisBkxro5bjSViFx+uFyMamDebf6vDAA0l75FocRBDu4WXMykP6d9O4yL2IvWNvaGCWk3+0QiIfRo5R1FmLgAt9Jkbv4oFBMDnWFZX+armR2ZbZ5X2yZz8wdbKUp1ZMBQArdR8DpuxVj2sKBEBx1fH3InV8hFYwXcRlaEli0u9eclWL5woHqqfrOnl7fk1bDwU9geeDTtRql/ckZGt+NonMCg1HkQ080ERvqrpn5Dh3elFDVeR+wb2aG9KcnShVTWlbHYqOhiULjK8wJdusOMLDWHf9EeYP0/V/0RptrIY4f1uW2iHE+dnmtAp4RcqTgW1OFwMjlxAUR4oaVof7746kilYUiVP4W7ZhDBE+YxjdtuagtYhRlNRqr2t69TKUoDyr81Jqi8bL3TQGg80nqdOO8L+8zJjTve3DL0HsMehdlk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/2 05:01, Jaegeuk Kim via Linux-f2fs-devel wrote:
> This patch fixes the broken readahead flow for POSIX_FADV_WILLNEED, where
> the problem is, in force_page_cache_ra(nr_to_read), nr_to_read is cut by
> the below code.
> 
>       max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
>       nr_to_read = min_t(unsigned long, nr_to_read, max_pages);
> 
> IOWs, we are not able to read ahead larger than the above max_pages which
> is most likely the range of 2MB and 16MB. Note, it doesn't make sense
> to set ra->ra_pages to the entire file size. Instead, let's fix this logic.
> 
> Before:
> f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:4294967296, advise:3
> page_cache_ra_unbounded: dev=252:16 ino=e index=0 nr_to_read=512 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=512 nr_to_read=512 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=1024 nr_to_read=512 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=1536 nr_to_read=512 lookahead_size=0
> 
> After:
> f2fs_fadvise: dev = (252,16), ino = 14, i_size = 4294967296 offset:0, len:4294967296, advise:3
> page_cache_ra_unbounded: dev=252:16 ino=e index=0 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=2048 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=4096 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=6144 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=8192 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=10240 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=12288 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=14336 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=16384 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=18432 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=20480 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=22528 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=24576 nr_to_read=2048 lookahead_size=0
> ...
> page_cache_ra_unbounded: dev=252:16 ino=e index=1042432 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=1044480 nr_to_read=2048 lookahead_size=0
> page_cache_ra_unbounded: dev=252:16 ino=e index=1046528 nr_to_read=2048 lookahead_size=0
> 
> Cc: linux-mm@kvack.org
> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> ---
>   mm/readahead.c | 27 ++++++++++++---------------
>   1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index 3a4b5d58eeb6..c0db049a5b7b 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -311,7 +311,7 @@ EXPORT_SYMBOL_GPL(page_cache_ra_unbounded);
>    * behaviour which would occur if page allocations are causing VM writeback.
>    * We really don't want to intermingle reads and writes like that.
>    */
> -static void do_page_cache_ra(struct readahead_control *ractl,
> +static int do_page_cache_ra(struct readahead_control *ractl,
>   		unsigned long nr_to_read, unsigned long lookahead_size)
>   {
>   	struct inode *inode = ractl->mapping->host;
> @@ -320,45 +320,42 @@ static void do_page_cache_ra(struct readahead_control *ractl,
>   	pgoff_t end_index;	/* The last page we want to read */
>   
>   	if (isize == 0)
> -		return;
> +		return -EINVAL;
>   
>   	end_index = (isize - 1) >> PAGE_SHIFT;
>   	if (index > end_index)
> -		return;
> +		return -EINVAL;
>   	/* Don't read past the page containing the last byte of the file */
>   	if (nr_to_read > end_index - index)
>   		nr_to_read = end_index - index + 1;
>   
>   	page_cache_ra_unbounded(ractl, nr_to_read, lookahead_size);
> +	return 0;
>   }
>   
>   /*
> - * Chunk the readahead into 2 megabyte units, so that we don't pin too much
> - * memory at once.
> + * Chunk the readahead per the block device capacity, and read all nr_to_read.
>    */
>   void force_page_cache_ra(struct readahead_control *ractl,
>   		unsigned long nr_to_read)
>   {
>   	struct address_space *mapping = ractl->mapping;
> -	struct file_ra_state *ra = ractl->ra;
>   	struct backing_dev_info *bdi = inode_to_bdi(mapping->host);
> -	unsigned long max_pages;
> +	unsigned long this_chunk;
>   
>   	if (unlikely(!mapping->a_ops->read_folio && !mapping->a_ops->readahead))
>   		return;
>   
>   	/*
> -	 * If the request exceeds the readahead window, allow the read to
> -	 * be up to the optimal hardware IO size
> +	 * Consier the optimal hardware IO size for readahead chunk.

s/Consier/Consider

Thanks,

>   	 */
> -	max_pages = max_t(unsigned long, bdi->io_pages, ra->ra_pages);
> -	nr_to_read = min_t(unsigned long, nr_to_read, max_pages);
> +	this_chunk = max_t(unsigned long, bdi->io_pages, ractl->ra->ra_pages);
> +
>   	while (nr_to_read) {
> -		unsigned long this_chunk = (2 * 1024 * 1024) / PAGE_SIZE;
> +		this_chunk = min_t(unsigned long, this_chunk, nr_to_read);
>   
> -		if (this_chunk > nr_to_read)
> -			this_chunk = nr_to_read;
> -		do_page_cache_ra(ractl, this_chunk, 0);
> +		if (do_page_cache_ra(ractl, this_chunk, 0))
> +			break;
>   
>   		nr_to_read -= this_chunk;
>   	}


