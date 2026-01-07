Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE1F4D0D167
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 19:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCC76B0092; Wed,  7 Jan 2026 14:04:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260A26B0093; Wed,  7 Jan 2026 14:04:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162BC6B0095; Wed,  7 Jan 2026 14:04:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0787F6B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:04:01 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A23971604C6
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:04:00 +0000 (UTC)
X-FDA: 84306092640.14.190E1BF
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id D9F2140015
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 19:03:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xhN2N6vG;
	spf=pass (imf01.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767812639; a=rsa-sha256;
	cv=none;
	b=0ALNhZJehaVRE8pfmICinIkFzEfgSMXQTYfSTnfNS1/ldXFjAJCYb+YjtopBQbZGH4QuCj
	U5jCPFobLPo3bOlr3T1uCTolUcJbkmEPiV/PUGBO8BhLqm1pn/I3Bp8yj+h3IrF5S+Ax9U
	8hsGH3UMHYqo0rU87FSMY/nT63mwzRo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xhN2N6vG;
	spf=pass (imf01.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767812639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTti71TefD1o85qPpK4aAoODgyk6fvNwjRLBxcoRZW4=;
	b=l3hT33pLp1Ekp4lzju5/jEoqRRnWL2hT7gyOBeVNkP5zHBtgY44oQIl8UjsCzc6Diju1ZD
	4bjq7cx8xEBKXNCo8hAOGrmeRad/XThBIconOEqoSJeSzp4Lex503o0j2L72JWi7Gy/G+f
	4nznuM2FSY+I1NLfRccXUr8HqIRhmX0=
Date: Wed, 7 Jan 2026 19:03:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767812636;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lTti71TefD1o85qPpK4aAoODgyk6fvNwjRLBxcoRZW4=;
	b=xhN2N6vGKss+YT9Q8qnsBTdK4oC3+55lmjJYAAlwFx5lp02uZ3Nsk10WHm/C+Y2n9/yTVJ
	CQGgYMpe5+jZ5X737tCfX+Gk+IHlhzlLeGYOZo6oLaAQ04sIamcb2F5M/XRdxb5EbLZLpR
	9bfzgkepX9iyS725CZKF/vbW3zMg7hQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCHv2 2/2] zsmalloc: simplify read begin/end logic
Message-ID: <gl54caplknnljganmswspw3cggoyjxe2n7szvnwhhiyl5y7ynh@tzl2yz7bw725>
References: <20260107052145.3586917-1-senozhatsky@chromium.org>
 <20260107052145.3586917-2-senozhatsky@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107052145.3586917-2-senozhatsky@chromium.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D9F2140015
X-Rspam-User: 
X-Stat-Signature: jj55pu8n5ey45mra7dgkjg5tzkokdz1e
X-Rspamd-Server: rspam07
X-HE-Tag: 1767812638-187634
X-HE-Meta: U2FsdGVkX18wkLg/jowJ7QvEWukr6dZDQKgcmN12q2DGZuslmDddk2pim6SPHIL72qnHNPAh9bbnfKO4izLi+l+yJ7RjrLQIVELiBuAuGFNqg4bl73QN9iIZbqW/o7zU6e8pupxmAenY6s+SD6n/3HSH4BGalvjqpDMtTWo3IT9XscT/wXcaYKbeunsVR7EhybUG1qnldICo3Q1bUEuZJtBTFKUc5QNexXVNhwws6isJUX4lNcTgPq7QLGBMIqoGFcjbVVGW4R53JftRhV5+r5FX9+BGZweCWbL3LCRSaK/QvOTIcCjYGA9djkDvGwDwA/iQ4MLzAV/NVkSZHGIWhgwHy/Zge4Mc0I26ZLopX5eLxzy9RSghZt59I9TSePzqJGycttdblRjxKTc3bzEcI0GBmXKHUJFgy3j8beE0ptjDhO7FK1mHZafwGtiXRIaLM5limDo7qG76gh8C+3O4lD/MNZumhnynPkwbyvZCfpiniNIIyAe4VfmZo0L7orS7Jx7vYKYdONv1yQglKptNxEoR11Idqy6EE4Mm9X4f7tasviUso7fnm/JElC1F5qj/JbUk+CS8L9IP1wu6F/0kg+qVsKhWOSJXchbusqD8he0qLq0KL0v64894wrKc17QxbzxC14aD0uMRoEnhwubHymVA29Mf/+AjM6UOUc3GJ+Bfplmk9jIBF/2rNj1BVhh0S1OB3bmg/KEZT5XuIxaCHxinubUeHotnxTx6X9QAeoReP+YCR4qaUw/NkAYGtOnla6AaKseMGThyIV6LfHkGGH8zjFnVhwBOSnqF8CZOj7G0T0bhpOKRceOFeB2/MA5zibwqnG8oCTHO1JIh7N3nY3nVapDl2d8SeUYjjvQ6vTI/DZOkpfpiGOJDMiZdw4+ySVJdFrJcKfxQ/v8JAdRW4WXTrR3wMfW+ZkyhPiLeUQccrk8XICFaqhgtvy8OZ2KxCwj8nAfTauSUYnuS6cq
 3RoGiIx4
 OrfyLvlcByRa+lO3HprpUC0eMavBSwQ2yIWe/gqk43ehkybjN3dBGCrvFd0DUpW/OT2OMI2m/AuybcYL+w/KLmWXymrgQaWg+mj34u+NVvGRjNV6loDLjnxzhc0CAxe1TujS5LJa06CLxyYeqZXJ72MNAHHueHBa7jBG98x2S4lNqgsGm+kBAAMez4+ZmAOaVyYwjtH+68TjMXzg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:21:45PM +0900, Sergey Senozhatsky wrote:
> From: Yosry Ahmed <yosry.ahmed@linux.dev>

While I appreciate this, I think for all intents and purposes this patch
should be credited to you, it's different from the diff I said as it
applies on top of your change.

If you're feeling really generous, I think Suggested-by or
Co-developed-by + Signed-off-by is sufficient :)

> 
> When we switched from using class->size (for spans detection)
> to actual compressed object size, we had to compensate for
> the fact that class->size implicitly took inlined handle
> into consideration.  In fact, instead of adjusting the size
> of compressed object (adding handle offset for non-huge size
> classes), we can move some lines around and simplify the
> code: there are already paths in read_begin/end that compensate
> for inlined object handle offset.

I think the commit log is not clear in isolation.

How about something like this:

zs_obj_read_begin() currently maps or copies the the compressed object
with the prefix handle for !ZsHugePage case.  Make the logic clearer and
more officient by moving the offset of the object in the page after the
prefix handle instead, only copying the actual object and avoiding the
need to adjust the returned address to account for the prefix.

Adjust the logic to detect spanning objects in zs_obj_read_end()
accordingly, slightly simplifying it by avoiding the need to account for
the handle in both the offset and the object size.

> 
> Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> ---
>  mm/zsmalloc.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 119c196a287a..cc3d9501ae21 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -1088,7 +1088,7 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  	off = offset_in_page(class->size * obj_idx);
>  
>  	if (!ZsHugePage(zspage))
> -		mem_len += ZS_HANDLE_SIZE;
> +		off += ZS_HANDLE_SIZE;
>  
>  	if (off + mem_len <= PAGE_SIZE) {
>  		/* this object is contained entirely within a page */
> @@ -1110,9 +1110,6 @@ void *zs_obj_read_begin(struct zs_pool *pool, unsigned long handle,
>  				 0, sizes[1]);
>  	}
>  
> -	if (!ZsHugePage(zspage))
> -		addr += ZS_HANDLE_SIZE;
> -
>  	return addr;
>  }
>  EXPORT_SYMBOL_GPL(zs_obj_read_begin);
> @@ -1133,11 +1130,9 @@ void zs_obj_read_end(struct zs_pool *pool, unsigned long handle,
>  	off = offset_in_page(class->size * obj_idx);
>  
>  	if (!ZsHugePage(zspage))
> -		mem_len += ZS_HANDLE_SIZE;
> +		off += ZS_HANDLE_SIZE;
>  
>  	if (off + mem_len <= PAGE_SIZE) {
> -		if (!ZsHugePage(zspage))
> -			off += ZS_HANDLE_SIZE;
>  		handle_mem -= off;
>  		kunmap_local(handle_mem);
>  	}
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 

