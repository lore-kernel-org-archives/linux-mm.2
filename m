Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE52CD4F21
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 21:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 770A36B00AD; Tue, 12 May 2026 17:47:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA046B00AF; Tue, 12 May 2026 17:47:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E89A6B00B1; Tue, 12 May 2026 17:47:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A7436B00AD
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:47:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D748B1605E9
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:47:37 +0000 (UTC)
X-FDA: 84760104954.22.1EB07F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C98C1C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 21:47:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sjpMzdns;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778622456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+7GtulijVZjjZK/1ULlyLUgAtRC1edchizMqqpmu2M=;
	b=W/hAPVHcGTg6PQw+Ppmf0nfoxghn2ayKd5LKyLUlMKfnc2y3KGubRmGhaEu1gZN40NUTPr
	nie3ygHUD9ZNFff9DECBakBPPCkjNdi4/Q1QCno84zcy+hQyuL0x3Wjr4bKrFTnNvOq02T
	k67Ru8DocMJ0JN7GANYvS4vxQ8qsZvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778622456; a=rsa-sha256;
	cv=none;
	b=B87bTF1OoElwQwNKJQ1/Ma5sODSRUIB2Ozja43PqeCnqPJj+vkhcIP4i+ofd4NKowIV3Gh
	HsrVP3ahUHv+oq0uPx2NboEssSeTwrO6I/GJarqWwihOVrjs4Ll+Lqw9cCiqgPHaRecHRg
	/ARdJ7XWnXlOcn47FbcPdHQmIdEDHHk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=sjpMzdns;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E8D9A4430A;
	Tue, 12 May 2026 21:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960DCC2BCB0;
	Tue, 12 May 2026 21:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778622454;
	bh=KvSjEgCXQMoXNf5Sg1l9vwpiFrQ+xO0tKCt6MXsr+34=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sjpMzdnsWpnquJx+uihdS8zzT7vrmx9p1pU+nmnk7aK/7w8/wJ8uUGyYepDfpeXDB
	 oHpPb3TcSsKHlcSEsM9iv6v9NR7XHKzc3of9PeuPmKxw0n3evtPLb71XvaGpHucLuA
	 d6O+5ZTDBUh0AnPl+tjVJO0PpRhtlq9ix0ub59sQ=
Date: Tue, 12 May 2026 14:47:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kartik Nair <contact.kartikn@gmail.com>
Cc: minchan@kernel.org, senozhatsky@chromium.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com, Nhat Pham
 <nphamcs@gmail.com>
Subject: Re: [PATCH] zsmalloc: zero-initialize zspage memory to prevent
 KMSAN uninit reads
Message-Id: <20260512144733.9132c83e392a109743e92f71@linux-foundation.org>
In-Reply-To: <20260511213658.25273-1-contact.kartikn@gmail.com>
References: <20260511213658.25273-1-contact.kartikn@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C98C1C000B
X-Stat-Signature: jxwjn8askrqfocsiyhp51fqo1yto3s43
X-Rspam-User: 
X-HE-Tag: 1778622455-782130
X-HE-Meta: U2FsdGVkX18a+grruha+PjrVEWcEDQfbLvhHk7Gd92ZZGQlgAkDwPs1CTiWZ+A7/0tcpU4TnyyTQ+/VinBglpuduPpxL33uGwaSwsWP9NXheE/0LZ+2hFnFwVNUUBI3/UicrP/jt+4M1Qbgc5X3iGtbdKq5P2KxUr4ecIid08tt/gi7NcRtq9lsOKAdMESgZB/2Pg0Uj1RwoSgbH/meCQduWv9hLlEzaFxZlEW6//mV6nzLDcftML7+fXOks5JQ1yr3CQ2Oll1LfcnNvX9hZ240Ljvj6TTGcWPqn7Y7CPwGZSBAKEufBZSKMpdlA63KguJ7KdmPJtoN5fkQrn8AgcdyrTXi306va7UQ6pZGZLlaD8o+44V+vw/i5/fxVWXpLz11FqZ2n9sbPHl3T4gU3s9j5B6ErBVhEoQ7mzPotxSIPL3JFCsuqDGDAMiBkhX8u2r+yOiLlR8agSYvKDtKkx0vr9BAvd+wzkqKA6pmpzIuDjwF3sCDcQfZFlfTHFtV7DWJiJWqLg8YesTzHx1w6V87cM6jYD+KOwvh6l7qKmhklKca/HEVZXq2XukHBedOnxUHCANBFxHGBKraAMhXubz9cWMBW5cnMt14mgKVgF6Voy+0q3HSfmw01eGveYdf4JSzud9pOwY2tdtSsyiEYBvRcLnq8VnsMJRzMvqoHHuCzfq742vWviaiad0FlZIpw8019Er+PI+kDCJhL3XS5G6N12zOIMvSELvFyZNOV9bwa/MXjNRulJ24nm958qyN0k9la3M05SSazM1TTY/F5rf7zWeTuRvzVBJHYwY2qdG59gmGM9nEkF0dMIAUPnAUS7rROYEedl+4Wnma6TuS11wfG7PNciLbKBZN+WVOAoesOGDPctr+9Pm5YxNQUrHx9VJLin4nbMjNS8wqpii7JyhDyZNHaBVj2Yvfvc8ElTEOeukWK3v7+mOnnhzQq3SM7ApfoA9Tt4IB5xHv//yX
 340j636I
 J4tyFW24GnNiMjyT7VL+BMtMNmTjXadh1BgdzDpY1unFdUgjP4MqphD1J92pTm+BiOEXu4NWv9fab2hRLEO45+QUTeJJJkH45jjJQIRi/FJthE80yQPs3D6y9UbMGS9Qi70n8pZ15AhxzGT8D6nNJk9wfUvuRdd2kkDEeMoHHqFuIzaaHZjsTe3th08oD1sbSqpeMVtLsnRIjQO+6Kc8D3Ap+OyixhVcsPIPFp0RR5w4XZTqwrwAWG33/u2gxbWQWax3vFAcP7UQcamhRrUDrh8c2vAY9Y/B62Cyrmm7qOh+ZiNOz8JfggzYazmVdcsGSlwY+0kfMah2qul+zGd9JN6L3yllYbq5/Z0Yk4/r2cjTJ/ntYzLeuN2F0mkYheZrbGpCsKn/DDDeJ2IaqMy54jyFKeNBykC+EO0NNGjbjHEithidjHPrNfF+sRdAYKx196h9jFVrct0hcZD81HZe/sqZtcemx28mZCXUQZ7eAgm6W2cI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 May 2026 03:06:58 +0530 Kartik Nair <contact.kartikn@gmail.com> wrote:

> Pages allocated via alloc_zpdesc() use alloc_pages_node() without
> __GFP_ZERO, leaving physical memory uninitialized. When a compressed
> object spans two physical pages in a zspage, zs_obj_read_sg_begin()
> sets up a scatterlist pointing directly at the raw second page. If the
> second page was freshly allocated and never written beyond the object
> boundary, KMSAN detects reads of uninitialized memory downstream in
> the decompressor (e.g. sw842_decompress reading the CRC trailer).
> 
> Fix this by passing __GFP_ZERO to alloc_zpdesc() in alloc_zspage() so
> all pages backing a zspage are zero-initialized at allocation time.
> 
> Reported-by: syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=8f77ff6144a73f0cf71b
> Signed-off-by: Kartik Nair <contact.kartikn@gmail.com>

Thanks.

> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -951,7 +951,7 @@ static struct zspage *alloc_zspage(struct zs_pool *pool,
>  	for (i = 0; i < class->pages_per_zspage; i++) {
>  		struct zpdesc *zpdesc;
>  
> -		zpdesc = alloc_zpdesc(gfp, nid);
> +		zpdesc = alloc_zpdesc(gfp | __GFP_ZERO, nid);
>  		if (!zpdesc) {
>  			while (--i >= 0) {
>  				zpdesc_dec_zone_page_state(zpdescs[i]);

Decompressing uninitialized memory sounds rather bad, so I'll add a
cc:stable to this.

I think the Fixes: target is 56e5a103a721 ("zsmalloc: prefer the the
original page's node for compressed data").  Can people please check
this when reviewing?

