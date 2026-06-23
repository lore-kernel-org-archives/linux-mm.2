Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724F6CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 13:49:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 105696B0088; Tue, 23 Jun 2026 09:49:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068116B008A; Tue, 23 Jun 2026 09:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4D416B008C; Tue, 23 Jun 2026 09:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA4D16B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 09:49:03 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4784F1C59BB
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:49:03 +0000 (UTC)
X-FDA: 84911308566.27.86B4BF3
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1BA0B20005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:49:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Gqp/OUp3";
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782222541;
	b=UIUsNaaXCM4tINC4yd6CmDKqoPSe2PRsjf1Oi7jqsn6r1rn7J0J1u/8UEwcBk196x/RVqA
	097Y2Sl5wVlQxBAktoYoQ7JyP9wM/y7XaLjxmvM7vYoXmg2grzSLnmDt+Ire/Pq30pOlZQ
	pnBPGGYUkBz0A5iRn+yW7Kqr4U5BRmY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782222541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UEwlhtuIKP5YrGqIec3n0T3lOyC4o/8ZKXq4ZbpQow=;
	b=AY9c2qb/b06OpsFW1ne74I67mrvZ/mvLJiuiXKSEKuxmB4hEZS1z9lT9vikiq7IxbK7HeE
	4UGO/Fvg/fghdsbjCjgxP8ABTCI7k6YcLrCVhGfOrUqGzGMNHyfj0/rV6U1s0IvESxkdyj
	85pbnJqmMC5P7jQUIxHjBOgKdzbsDi0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Gqp/OUp3";
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.52 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8dc09919aa2so92557706d6.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782222540; x=1782827340; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+UEwlhtuIKP5YrGqIec3n0T3lOyC4o/8ZKXq4ZbpQow=;
        b=Gqp/OUp3LPWKsNTVpK+4dA9dZJ/9QEeYDHlAddqTpolaZbCDeARxFQylielVXjUZkA
         qoWW3+mV8K0cJwwn47VOUM9f8vs4tz2XxPjKcwkB6BIU0MyMY2VFogf9iNFA614hS4ch
         9V/+nezmpZCny22Se1wejtTFpUK8tjmVQWvm6uf+1k05FMUQzZLcnWOUaC4qfqkGfw2L
         8FwGxdWkV8b4mMe4egu1pgh1t3p5k5J2IRKuIdMy7fNcaUcg2Mt7GyHbZl2vmOGHv7Hj
         /N98/wbiBWHL8+0c2bLI/feovbPrn6STzWIPgkFkclPIlfRRnemQ1pDEZ7lLw8avNitg
         aCIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782222540; x=1782827340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+UEwlhtuIKP5YrGqIec3n0T3lOyC4o/8ZKXq4ZbpQow=;
        b=R0/VkeDY9PMQh3CtSLCNJDzCeb4R9N7ZZYau/gZWMmfebZKMuI0eZDereW/jrQdEEJ
         6WKAHCqscHI+GG5SzmtOO0iaDvrxMZDxUCO1jXWjZSg7hUDlnExKy8dyumSwkIGP7GE3
         C7GnOr0tsLzKUC0OJk4TuEeV2od/Z/962U1oaqmkcs90mGhCgppMUI8t5S1QVnWK9NEj
         BGtOvG0+4599N4dm8PJfMTxiET41TWvx51z16yvsXv1R1R+legy31hv4Sr5VTUcNXPWr
         MePYRPLfKfUNTS0lqDZFTvHjndqEPpQ+EaLXglJBO/cJQoSJVpP/t8+aIsBJ8Bjsae3I
         dfgQ==
X-Forwarded-Encrypted: i=1; AHgh+RrkC6SvtHJ5TYdZRehDTYafvkZi1sXr0Kt+aWXJj68cy7QwEJkY0RnbTIWP8doXza2gZ9c13u27oQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4SY+vR8eHVSm1LzmzxJsprnGSvSyNBwxSgUGhvorRpq1ARryK
	gLJDoBAhkpcKdvQ63apKQFNl7fnlWedVhGWQiPAg+oaWGdsJitdTHhFLBQ372IfXJ70=
X-Gm-Gg: AfdE7cl6WfVRAHR4JezlKMtBRxNeNjLDYjDEr5m4f8rwOZYLVyJn4QrcO3aEQFZSAzc
	b46qgSJcMSUx9Lq4/a3SSFGOifQgRA/Qc8+cG+MvQRUBtO6tq4lmzIPk1nniaBNYuEdgnTH5JYm
	BlpiwKZABwuJfxeUGiTdugoKQqUgpTO1cXANWdEQ3Dse3eve5TuyIspioCGGfpK80BBX81AZK3Z
	CA33zM/AlQoQsBz7aG6L5LmCFvkqdXkOdIk8SHqXONLD3DnS10Yg9JwvMkMnzOM2ojcyol1CC8n
	ZpSvN6xpYQkrgk3wMah6YqsLpdEUCj6ChxOQWa0uF7DLGIoRazL4BblJX+09zgj16sQWm28JDDT
	N+YiD5iGfYTSbgnzgCrTWdSOKY2W9+1QfsKiqTBn3Pu6jwHqmAJyhxQh7w72ibaVWVfX0eSFejV
	YbI4kRGowROkw=
X-Received: by 2002:a05:6214:300e:b0:8cf:9bd:744 with SMTP id 6a1803df08f44-8e433ec929amr44182646d6.12.1782222537871;
        Tue, 23 Jun 2026 06:48:57 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df82692405sm125810356d6.39.2026.06.23.06.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 06:48:56 -0700 (PDT)
Date: Tue, 23 Jun 2026 09:48:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>, Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
Message-ID: <ajqOyIA8tPQsxfz6@cmpxchg.org>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1BA0B20005
X-Stat-Signature: ww1drf3o9cudrgyw67dt5tnw91dk3sq5
X-HE-Tag: 1782222540-766651
X-HE-Meta: U2FsdGVkX1/elQZ8x0en5Hv5hqdpMVb+ZHxEhFQ/8iqs6b/156iMv/CaYHPfj+MAFLR1bRUmE2DJp91Q0hHbM95oQx72VrD+WzTtN7wY3T6iUOQIJR2CkLdfxf42W85QIfEFMrtmVYMVn/3LgC3y6KdSsHJ5GXwRRLHQunpIoVqPHj9j+YJekG0zaktaZdx2sOpO7QrYy09Hl3Fn9aIf0xdjus55R3+p50r5YMAZHwQUCtxvsbY1tbXlOzEnkijGOFFxtoG8H9lIKIDnFVuiviuQVngj0Exc9N4aAQYxwHPZQIpDKDp4r9yIW1o6iYwl8HoMdE1NvLac+ONonSkJ8P1/das4Xe4vO9Tk3NCYejlgX96nh6Onh8MyGlTLws41W3kXbFlTcj5EfUSuZpy0OhjHk88oreLkE5l3Vlt+H/uNnzKXdzZ42q7F4Fw6Kq8a1oHaHPYqd/gsYJ9K/+Ez+9al4RLsqaeYJVJRSS2cJfFWk11UrnKV6ZObQw2nIUlIe7pPBeIexOYaP3CUB1WBGf4T0q6G/drAN4fmJWjK0awtQb7CcSjeILUM932EiCuhI3/65lThT824w7stPjb90iR7AQ+i5hoCSyybKvLZ5PkeUWTi0WL/cBTrrem8W7I8mSHk+4GbXbaJ0hEs5I5F9JzJ6J+Uqbhcz4CdbE66M2Gba7+DYVtYYVVhtExsBpH2KOU2g0dsFXPtRAWiKaOBXDtWMcRZpyiLbqBk6l1H3IQKezCAd62t2G+ibpyTElsqSjW407IioPe0POBFon+qVZxmGakUjVwcGoE6M06GFlQEIfBAQJ5bgK6M+IvXMVZbs+IaQiim3rpJjr5wrryYTTmKGPbzS3nOBFUYdbeHiOo8uYWRHayTzL+HkgkkJ794VqNV1C+lIMBXNNLjXBiJuVlOFhW9E1G5DF426WnA4rW3Nuhl+ndzX/eaolXHkTGq40pIg7Az5BJt8fK11H+
 HUo474dm
 iqLXi6YwlrA3JNpd7b4PYFNhPiIKcQ4ljV+wQ1tkcsRgptrIzP+NjD61UtJe9WomVKPyrYLcuCLDJgQf+rsZpOUqtLmQa2acFIyT/z/9pe15wk/nsP/PrF/zgzsZxrwYGlLiAeBs+HSKoIy2aDTVHwCX7P0rqtq+57ZRQieFcbAxHa+0xbFfBjUWFuGqdmyPkXfrquk9exdA6ASes8gV2Tnwz7Z/hKvTd/j82vtSrXgWTrvOf2Vr7AHu+ND49b8meh0qstcNM/OCdiJ91Bd0NnExjKzIpjsYOlBFg9rHBd1hb2L3qmFsvW0/z2qKra1GOVcwaLYrh8TemsU5K9ejQGDzsDxybA/hwUtqeKDLLjwsZe0vozpDzKrHSsIMLZk0kX/T592jSXoy3u0I6f0KFy7umUAwFKYHIBTPLd/LsijBVdDHfDhQONHcX7t8+skT0EDkgd+mYK71G4CYXVTIXUl8usM9ZjIu6d7Tpl5IAzkOzpWM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 01:14:48PM +0200, Pavel Tikhomirov wrote:
> The cachestat() syscall reads page cache statistics straight from the
> file's f_mapping. Stackable filesystems such as overlayfs keep the data
> pages in an underlying inode's mapping rather than in the overlay
> inode's, so cachestat() reports all zeroes for them.
> 
> Add a ->cachestat() file operation and route the syscall through a new
> vfs_cachestat() helper that calls it when present, falling back to
> file's f_mapping otherwise. This lets stackable filesystems forward the
> query to the file that actually owns the page cache. No behaviour change
> for regular files.
> 
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
> Note: Memset change might be a bit tricky, I moved it to no
> ->cachestat() path to avoid multiple memset on nested overlayfs, that
> means that ->cachestat() is expected to be able to handle unitialized
> cs.
> ---
>  include/linux/fs.h | 10 ++++++++++
>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
>  2 files changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6da44573ce450..966b6564707e4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -53,6 +53,8 @@
>  
>  struct bdi_writeback;
>  struct bio;
> +struct cachestat_range;
> +struct cachestat;
>  struct io_comp_batch;
>  struct fiemap_extent_info;
>  struct kiocb;
> @@ -1963,6 +1965,8 @@ struct file_operations {
>  				   struct file *file_out, loff_t pos_out,
>  				   loff_t len, unsigned int remap_flags);
>  	int (*fadvise)(struct file *, loff_t, loff_t, int);
> +	int (*cachestat)(struct file *file, struct cachestat_range *csr,
> +			 struct cachestat *cs);

I suppose you can't just have it return the real file because of the
with_ovl_creds() scope you need during access? That would make things
a bit easier. But short of that, this looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

