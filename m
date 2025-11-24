Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C1C3CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 16:22:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C5376B000A; Mon, 24 Nov 2025 11:22:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5759C6B002D; Mon, 24 Nov 2025 11:22:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C266B002E; Mon, 24 Nov 2025 11:22:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 367886B000A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:22:06 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DEDE12D9AB
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:22:03 +0000 (UTC)
X-FDA: 84146017326.05.AB452CE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 40B1140003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:21:59 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="CYd/G4C9";
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764001321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WX90pJ5tXKEJjUZci6+pSEheLnjdAzO/pRFmPh4C/M=;
	b=evZRp9Ybz83AGwm+yHSY1InSi6pO1te83vsJTqVl+95EUAU3YD/NNMrs7SWsEPwK3MFRUn
	KdWUlDet1Fu/zuL38vXbbt/lZ1G8huF+ulKJVizBOLLAzUdkQ+ZXniufG0UcLeqlOzu5WZ
	u8B8SOHCGt5Tn9iAlmsteXpV6frRDYo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764001321; a=rsa-sha256;
	cv=none;
	b=LKZZ/aLY74dYjo2AdRJdPOF669BcTUKCfUPz6JJ9Mn8LJHFbEWlyQ22X30eK/vS3vUGNA3
	cgZ2reSjcx8L7dC68Zfh4dPEfqn8VA8F8JwStfU29+xknUxzsDVzX6Px2jtyiXVrcV0H7n
	6nN6NQJvO+5PLCYDcIOBOMYWv2O/+Zg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="CYd/G4C9";
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7WX90pJ5tXKEJjUZci6+pSEheLnjdAzO/pRFmPh4C/M=; b=CYd/G4C9W9UeNAzrhTfgnXJ7YO
	VOPKxJQJaMbZ55ev+OV74Ppn7hX9MSC9cBIxRm3Nqokzq4ptw4omqFhnFJKkjhf4VapV++OjIYUO+
	3eG2URmbIu9fLo/iB6Cmy7zQfy2I3C0iHUYlNsRI8dE/wsjVba2WzxYCNSC4bQDWAHIgsXEtKYaU6
	+Q+4ibDzfBLu+7MAiWIEJEy81cAFLuRuMFdEpN2FdJwZbThpClRpWsccaLIWENNf5r61qSPeuTd7N
	dYAVRq8ksK4DGBuAthJhcbw7mhrfN78R8gBkJ1VO/7OONBlf5t6HDB/s0EPsLJggaC3I9XMwZLF04
	nkA/+TsA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vNZK3-00000007Dpa-3piz;
	Mon, 24 Nov 2025 16:21:51 +0000
Date: Mon, 24 Nov 2025 16:21:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shardul Bankar <shardul.b@mpiricsoftware.com>
Cc: linux-mm@kvack.org, dev.jain@arm.com, david@kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+a785d07959bc94837d51@syzkaller.appspotmail.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	baohua@kernel.org, lance.yang@linux.dev, janak@mpiricsoftware.com,
	shardulsb08@gmail.com
Subject: Re: [PATCH v2] mm: khugepaged: fix memory leak in collapse_file xas
 retry loop
Message-ID: <aSSGH6IBIuK64EUX@casper.infradead.org>
References: <703387c8908a609c3de966574dfcf481c5a97216.camel@mpiricsoftware.com>
 <20251124161149.1302507-1-shardul.b@mpiricsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251124161149.1302507-1-shardul.b@mpiricsoftware.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40B1140003
X-Stat-Signature: 1zpdkohd5tx9dgbnbpsaqorwriptpouf
X-Rspam-User: 
X-HE-Tag: 1764001319-10581
X-HE-Meta: U2FsdGVkX19TQk/wgEpr7OY3ZZtribS0zw21eE9qMMab+KwQEVh9lS7S+IcDrG6diQoS47oSq8C8hd3yVBkPDftOwfz+kwgGbf4KwR2XEpetmfyOjhDfAy5qIUC8r64cfO25wEfyJusoY1OjIQeSDEFvCEM4SWPu4FBUE6p768TQtUVL7vSch0vJXo/O56YWSMRy/KX5r0IM9E/v+yDogv7q/oXOztuIMPoDz2+4dDTEeYbFQGOYfWy/lu+MtJtclEZBLQHyl1QkG5TjpTesKb3HKMrZ1d8jaTA3SsAgV/VuJe0KHIAxvMjdzA4vlG9sUPWkIhKPTM7PHekA0/KEzlDOf/CODnEP7DS05dGyz+9oeJ/0Y7SyIvgHsWb/VI3B/rZcj4HFH8YWeeoFMndm8lr2uVpAvEYK2AyjQGeOmRkN4fVZ7zC/6f2YoNbOdc3GA7XMLS+6zRj4zPHXXr5ctgl1Awbwv/VbRb/Vp+Cp4kqnwCN7c8HWB2lUlqmI/vUGyDU9BQFmNFgoH9xMB45pgIdkpTWoD8fuXl/1fUwoCxs3HT+HuKxkYsJw5GyXdo6FXP9qSULl+PZVMAT9TItTvMGAHbRXkOLTRvjsv6U1SkO1GxhDA5RYANK0p47UyRyjx1GWylDkgqzk9uxr0TwDjdlUfT50LuJAJKKD+LnrGlkldxO8RTVW0Xqg+zZhHF+Iqhel9sJPgUMdCol6QghvkZeQ5erNJgZ1D5NodzIGe4VKxJe1d2ktJp5zkxUt+7v5UEJtDykE9iLJFNRnOzGyO+U1yF1Hpe8n1Zs3DHBiJWMzUOL109C7M6uRi/oI42qUZvwp8DpkTe4xT0dZ0DtsGHgVOQuhhepATNdv09fdS9EgLnQrfWMfq6eLAtcibLMfWNTi57xa7pS3bL8TZCcu0mWZyp+9P5RUCBIpEgiNg6MojC2pzsjellcMA/Dk3M1htkYaphHyAZvVjv6uikP
 Dji9oAnN
 xEZ9s3+OTik+XV9yeKRqAfqQY/oJ+A7mRVTyoxehdpYVuHFtb2fAmAEmXzrd0h+5MGWx1l/ctHzbtBjHjPhAJzvp+3oS7NeBPGGQ0ufHOB3N5VIMt+VsP/EucXERORNJtEJ8mGrELjH3JjG5Dmgl6mgI7RsSrC2gjuS98WqmmS8qInx9rJIojQQsyf57QlqDmrIp08ePMHXucr65nWqTBGEVd/4Q+sBnAhZPWKYEURV45WsYWlPxSspwuoEW3Caw/iZ/CEAPuHWmmYno2GV8YxTtMceF4nkyS3Db+GaPXja865Rr4fBh6u6DQICkUCECc9Ea5nPppLFx5Ts+YRaU83KI+47ymTVPeAtttHEDjo2+4/VRpcBe3TjaCIk1bjpBWcBT1Lv6xmZYJQWTvVgKrOXIZPlqrHeL99dUErg6BkC4+xViL1HISnqI3WYKEjd3bTy8XA0InV5DR1TGOoCl6iE+l4ASu5sx31uxXIV1f7hFc5PhJE9RBzEdKkF7veXcHWgiC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 24, 2025 at 09:41:49PM +0530, Shardul Bankar wrote:
> collapse_file() uses xas_create_range() in a retry loop that calls
> xas_nomem() on -ENOMEM and then retries. xas_nomem() may allocate a
> spare xa_node and store it in xas->xa_alloc.
> 
> If the lock is dropped after xas_nomem(), another thread can expand
> the xarray tree in the meantime. On the next retry, xas_create_range()
> can then succeed trivially without consuming the node stored in
> xas->xa_alloc. If we then either succeed or give up and go to the
> rollback path without calling xas_destroy(), that spare node leaks.

Then wouldn't freeing the excess node in xas_create_range() be the
correct fix, instead of requiring the caller to think about this?

> Fix this by calling xas_destroy(&xas) in both the success case
> (!xas_error(&xas)) and the failure case where xas_nomem() returns
> false and we abort. xas_destroy() will free any unused spare node in
> xas->xa_alloc and is a no-op if there is nothing left to free.
> 
> Link: https://syzkaller.appspot.com/bug?id=a274d65fc733448ed518ad15481ed575669dd98c
> Fixes: cae106dd67b9 ("mm/khugepaged: refactor collapse_file control flow")
> Signed-off-by: Shardul Bankar <shardul.b@mpiricsoftware.com>
> ---
>  v2:
>  - Call xas_destroy() on both success and failure
>  - Explained retry semantics and xa_alloc / concurrency risk
>  - Dropped cleanup_empty_nodes from previous proposal
> 
>  mm/khugepaged.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index abe54f0043c7..0794a99c807f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1872,11 +1872,14 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
>  	do {
>  		xas_lock_irq(&xas);
>  		xas_create_range(&xas);
> -		if (!xas_error(&xas))
> +		if (!xas_error(&xas)) {
> +			xas_destroy(&xas);
>  			break;
> +		}
>  		xas_unlock_irq(&xas);
>  		if (!xas_nomem(&xas, GFP_KERNEL)) {
>  			result = SCAN_FAIL;
> +			xas_destroy(&xas);
>  			goto rollback;
>  		}
>  	} while (1);
> -- 
> 2.34.1
> 
> 

