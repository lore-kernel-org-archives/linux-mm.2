Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA74CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B26F6B008A; Thu, 28 May 2026 09:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3630C6B0093; Thu, 28 May 2026 09:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29FE06B0096; Thu, 28 May 2026 09:03:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 18F4A6B008A
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:03:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE6431C203F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:03:01 +0000 (UTC)
X-FDA: 84816843762.07.97F0C3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 09C5920008
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:02:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPwCWdO5;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779973380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIAUg/ZVKNqvTA8OMB2jX9V/vIvoB2IFv0g+QQaqho8=;
	b=R49dkr19GiTh+QWX7mGUpnw2AE+4HCOQISyd/vU6OsdgYcv7tHrFEF50EQOK8QaPeVUQum
	SZLHU9Q0k++MWd5TASI8D0m4JejChuvwfu3QmIaX+D+LahESu1gaR9j+0tfNygoTPaAVbG
	LNQdJ3cplfwldgpCW/9n3l4P4QYkX2U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779973380; a=rsa-sha256;
	cv=none;
	b=1C9b9ad6sUlxGi3xEUNbRGnvwuufmHAbtNkwEp/prDRLLZ1697n1YHKVjcC+Q5ZGrlaT6i
	+5eRgmYCWDj4PiBeR/pumshKV3YW2qU31YJSDCIJ15Bl62Ua0iCuC1MinuoU1NNLA0R5np
	s+QNMHtcXjWz5YH/KrF7/TeKuHtOcDk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPwCWdO5;
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F7D740E35;
	Thu, 28 May 2026 13:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564341F00A3A;
	Thu, 28 May 2026 13:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779973378;
	bh=TIAUg/ZVKNqvTA8OMB2jX9V/vIvoB2IFv0g+QQaqho8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OPwCWdO5JiTusiyHJ5/gGhmCfAS/U+AbZ9hPU3j9riiMXkSChnWQco0zNOuvpoB5k
	 YZEjwHBmMScYY45vzZgHOtKjb6qlCMnascrpq4ymIXjxCRPT5a/j7n9vab1KkukjvH
	 aly2lokpEZh9ujZn/Mtvq8MWq8F3rXg0VLf9e58l/Lw4zjpCUt6QEIByJDJmtTZn7K
	 GfX2jwDfJ6FcTcEMGj0kQJU1raQIRvxtmp3O3Dysb1sIE/xI1g9T5KHvl/XRRMiYkf
	 kfhhFyTVJ4z3viR8UUYlfrr1rwQu3NnkrcmIlhWrYp4naJwIn1G7Yynx8ROuRgN4Pz
	 D3veNFhZ8lp4A==
Date: Thu, 28 May 2026 14:02:55 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Daniel Palmer <daniel@thingy.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH] tmpfs/ramfs: Let memfd_create() work on nommu
Message-ID: <ahg6FiMo7cEQxod_@lucifer>
References: <20260523130445.1101818-1-daniel@thingy.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260523130445.1101818-1-daniel@thingy.jp>
X-Rspamd-Server: rspam11
X-Stat-Signature: qfd14dyffsdynxutsxo3j8a9s95dfsar
X-Rspamd-Queue-Id: 09C5920008
X-Rspam-User: 
X-HE-Tag: 1779973379-569898
X-HE-Meta: U2FsdGVkX18+5+p6j8FC5t67oX7Ybx74ImF+jS9Fqzt0xw3+1EnknwjS8N2X2XIWt+Lg3DO0aj8SwddP65Mh7E+RXYfpbgn6q0DRZSgkNV/svwu4nb+zBdnAFd+kMqeNeulCxYU8QY6iTPS79tAl0R/12EO7K3Qh1lDCejXvt6VeIaYJNqSfXVgJ8AU9xa7pm3+QQwisQ3N3+4uNHb72/PdXqm40fNq3HXtDkYMP3meMu0wMOQZqo6CyqqK1hXTBNVu8TpVv/vQzw+Y2cWhzRMyRrSmM0NikXtpT2Me2qyr0vOqHkX3nszVa8NFYPYe0GaSiIrudcL/L0XxTy5cce+k5n5YvzxIWrC8QXJ5b1zQdtQF+EZ3cgIg8JKYVXk5zZnFevV79w3suMLSMOxQhthuZzdZ2crZ3SjdnwfcNXpre7qn6S7iQPY504tVa5ODAdBo7Tzjef4E05oLBVaFp52x+vbkQXd547j4WRkxGAv7GUdmQX+VLipQc7pV0eef0BWGQB22/YKqa/SizX41HZB672KJMSb/kQQsg2Abvl5dXtUs+DiI3OmavvcGw67ZXPA9u/9DE20XjcgJGR84brd5PhaPnHRny8hu2Bhrx70kOi+pgeZZ/UYD8MyFDa9i0XlNao6wk9HvytUvnAiWWL8nvYQTsOCs4jmBOI9lSWpPQNQgb07Twkm8Jd5guKMo75aEDAv+DXKzxUFm9206W1qQoqh0c1db7JUGaJ8UnMMVuHGBROcJp+SzNMfL80LyFzddtVJWvzKQ6u0YWDKTRaAfOXirGeWQpjRJQNcD6dui5s23jtNMNBrHqHELwTLG1WWtrjZVL4nd1gPT81BmYAPhwh8hIxb02FwFhrQDNVoeKhPzrDEtBPZfrXCJgESBOkp0tW3T60f5TEXfK7RYORZjYBYirQCsTfXKy8oD2G+F0HU4NqnCkzApg2Hny/oNTWotWFaZbUEadc3VYGFT
 Ea+k7DCP
 1+Hr6vMhC7h8XxtHwb/s7ZNjIV7xRHsUdgY6SttMzE5SCQHXGCBafkjuC17SruoYTE/CXcdzP6bQqLnECU6sydEa1STFvyNaMeDQT8bF1eWY6eXKiK78I2XvXWikWf8vfJ5/nZT5qsyIFyQe/7oJ2BKUljy7WrOLl72vacwRTh/o8XxcbryOdrvU7vuVAFFjTaKJZxxSf8PT1SdjQAZQu6byCnVGCB4cI1sPyGeaxiLXgxPIl0oDPw/9mjQCaj4K2x8DKb2pnBKiRYp3QlZj350BgM52zk3wUBv8ngC8zgs4uYz/0TJ16OA9bcx58drWlZUg3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Liam

On Sat, May 23, 2026 at 10:04:45PM +0900, Daniel Palmer wrote:
> Currently trying to use memfd_create() on nommu returns
> an error with errno set to EFBIG. The manpage memfd_create()
> doesn't have EFBIG as a possible error value.
>
> Doing some digging this is coming from 0 getting passed as
> newsize to ramfs_nommu_expand_for_mapping() and that getting
> into get_order() and there "The result is undefined if the size is 0".
>
> Whatever comes out of get_order() is then used in the following
> logic and that results in the EFBIG that causes the syscall
> to fail and the errno in userspace.
>
> If newsize is 0 there is nothing to do so just return.
>
> Roughly tested on m68k nommu by creating a process, creating
> an memfd, forking another process, mmap()ing the memfd in the
> child, writing into the mapping, then mmap()ing in the parent
> and checking that the right data is there.
>
> Signed-off-by: Daniel Palmer <daniel@thingy.jp>

I don't really have the setup to check it, but I don't see a problem with
this so:

Acked-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>
> Really not sure if this is correct. It works for me but on
> nommu a lot of things just work because there is no MMU to
> shout about badness.

:)

>
> Maybe shashiko will say this is a dumb patch and explain
> the proper fix. :)

No see below I think this is correct.

>
> Also I had almost no idea who to send this to from the output
> of get_maintainer.pl.

Yeah this file doesn't really belong anywhere... the mm bits of nommu are
(ostensibly :P) maintained by me and Liam though.

>
>  fs/ramfs/file-nommu.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
> index 2f79bcb89d2e..fb471bf88ab7 100644
> --- a/fs/ramfs/file-nommu.c
> +++ b/fs/ramfs/file-nommu.c
> @@ -69,6 +69,9 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
>  	gfp_t gfp = mapping_gfp_mask(inode->i_mapping);
>
>  	/* make various checks */
> +	if (!newsize)
> +		return 0;
> +

Hmm yeah get_order() literally says the result is undefined if you input 0,
and it bizarrely returns BITS_PER_LONG - PAGE_SHIFT in that case.

So this isn't correctly handling 0 size at all.

Also in the case of a mmu, this function collapses to a stub that just
returns 0 and the rest of __shmem_file_setup() runs fine if size == 0.

So yeah this is probably right!

>  	order = get_order(newsize);
>  	if (unlikely(order > MAX_PAGE_ORDER))
>  		return -EFBIG;
> --
> 2.53.0
>
>
>

Cheers, Lorenzo

