Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B187CA1012
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 22:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BDE08E0002; Wed,  3 Sep 2025 18:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46EDE8E0001; Wed,  3 Sep 2025 18:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384508E0002; Wed,  3 Sep 2025 18:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 234428E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:50:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 976B21DF1EB
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:50:49 +0000 (UTC)
X-FDA: 83849435418.18.3C018BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1DB4840006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:50:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tj6yAb73;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756939848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mqvjT2vpbD+T3eIFZJ7eNmqCPju62IDUSDrtwQo5C5M=;
	b=dQ/ORG9Lo0kedj2RKz8uxPjKEr5dvje6oz1obyleMkVk0gRlpoQ6YdSu33BD0TMu6uyVkK
	Yzr9IpSTJ5xJEodZcxhofLgMnkwS3dR2ZbS4UVTA9A9EzvR+Xjv25lKuZduTiS3j9OVffn
	OMvr19o7IbXhHXc66QWnOcEhGROHUNU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tj6yAb73;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756939848; a=rsa-sha256;
	cv=none;
	b=aXv8d9s5tntIJZ73c5ttN+dxKZgNfVz50XA+19B9EiXEqtjh7BvPqHV5o3dxKnlzJbh6sX
	lnVbk1Kt11pu4N3jpIB5gDvXWXEJud6p5IMYkLPzmUbJsbbXxyWr+7kO6OwHQ6t91xbMBH
	fPr3pjA6D8KMu3WsHGjNlPu15YLIgCw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 136E660194;
	Wed,  3 Sep 2025 22:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBCFC4CEE7;
	Wed,  3 Sep 2025 22:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756939846;
	bh=pbdquukSnGS+wF5QF8MilgjIYNJenjTo1pFIRO4nz7w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tj6yAb73B0+cXYAia7kJ0XU6KHNEqIRkke4BZtr7R8O3us7SWoXS68AcMqQ5L0hpG
	 BmXM1jzeqpYF1icn0sEmvoQNczqPpgLGcyzhDPUPeLtnMlScyq5/FqV42gRzdDgUrV
	 ENGoguY3Pv2qLi4Nn8AB7DOzFJn1HN7+BvDWtq7o=
Date: Wed, 3 Sep 2025 15:50:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youling Tang <youling.tang@linux.dev>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, chizhiling@163.com, Youling Tang
 <tangyouling@kylinos.cn>, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH] mm/filemap: Align last_index to folio size
Message-Id: <20250903155046.bd82ae87ab9d30fe32ace2a6@linux-foundation.org>
In-Reply-To: <afff8170-eed3-4c5c-8cc7-1595ccd32052@linux.dev>
References: <20250711055509.91587-1-youling.tang@linux.dev>
	<jk3sbqrkfmtvrzgant74jfm2n3yn6hzd7tefjhjys42yt2trnp@avx5stdnkfsc>
	<afff8170-eed3-4c5c-8cc7-1595ccd32052@linux.dev>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1DB4840006
X-Stat-Signature: iad43ywr1m1z8fws6awn6p76tmzkatwi
X-Rspam-User: 
X-HE-Tag: 1756939847-799137
X-HE-Meta: U2FsdGVkX18qecGMFqUxPzJUe618KL1948/DVBBTZ7HJhesKyEgRaEiOwVLp79kOF1blGxg1qUQrSMs2U9lD9uwK39XwO5R4eVo26Pti1yNh3RYPEG0vMN0KQCU7qpJsGMVuakb9HSOj24MpAsrtT4EsIbU2/eN+/okPNi1L3zdElL5dnsOfCHyfdADU+wRb+Wrk7hiZ/kZyayT3US/RuN6JjCOIxxHpHJH0ZFws3cdBJw1zfsm7peK3pxSJI0Rb5L0u1VVXxRx0oAGcX2o7OurxEC1as1b5FcKxDy5plHxz1wKMhtl1ygHw9rmjasVudsy8jLlAb+cXHetyb8ozOpD4w3tLSIflLMCXslLf5BeCCBsrb5Vm/7Vgs8iVVgz+CBjksVlVo55zzyPCWxQ7HPNS6IxBUlA7cpCB3BZE/CJhOHm0imqK6AFA5tUNhkrZidnnBnNIFbi/Nv+uy8oSMtaeV1XWl3MYYFYgUFH353h+bCc41z8rORv7il5C0jIcjM+9Mu1zQWzbij8PFYdDSuWiSZFW+gEufKXy8WOgC2IMVMV+JYx71ZM7yDUEA8SflqEUdtdvRPBHAfXCdF+TLq58/+D/Msz1cHA7kXnSl1U3H2HDygDooJ0AjslbFV65CeU1NjlBsFzORzSP8U8XiwQfhoHRVCbC3dJwFpJQ5QIVndGyn0W20zmSIRfc7u45AhGa55wFeTj6NCyh4VWlgZJd3eRUSblJlHxIKgIjZABcVNGUstp4kB4YZgVsM9rSxC3vYiX2dADaOPJsO2vm1tR6TvIZZdm+btbNafEKzAXbSKJvRaaNnLA5/zLWCbiKFgJ6v/R7mT4HPy12z6JoaH3B6uf134uupnRomq+hbq8L/Hi31mzKoor1Y28xkkFh4VO4CDfbN/tgo3kJGjDc1Krc32oor4SNCMj87wvm78f1B7esXtxxfH4SBpvDf5OGchlDCrUDwkvJq0Zf1OR
 9Ew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 17:08:53 +0800 Youling Tang <youling.tang@linux.dev> wrote:

> Hi, Jan
> On 2025/7/14 17:33, Jan Kara wrote:
> > On Fri 11-07-25 13:55:09, Youling Tang wrote:
> >> From: Youling Tang <tangyouling@kylinos.cn>
>
> ...
>
> >> --- a/mm/filemap.c
> >> +++ b/mm/filemap.c
> >> @@ -2584,8 +2584,9 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
> >>   	unsigned int flags;
> >>   	int err = 0;
> >>   
> >> -	/* "last_index" is the index of the page beyond the end of the read */
> >> -	last_index = DIV_ROUND_UP(iocb->ki_pos + count, PAGE_SIZE);
> >> +	/* "last_index" is the index of the folio beyond the end of the read */
> >> +	last_index = round_up(iocb->ki_pos + count, mapping_min_folio_nrbytes(mapping));
> >> +	last_index >>= PAGE_SHIFT;
> > I think that filemap_get_pages() shouldn't be really trying to guess what
> > readahead code needs and round last_index based on min folio order. After
> > all the situation isn't special for LBS filesystems. It can also happen
> > that the readahead mark ends up in the middle of large folio for other
> > reasons. In fact, we already do have code in page_cache_ra_order() ->
> > ra_alloc_folio() that handles rounding of index where mark should be placed
> > so your changes essentially try to outsmart that code which is not good. I
> > think the solution should really be placed in page_cache_ra_order() +
> > ra_alloc_folio() instead.
> >
> > In fact the problem you are trying to solve was kind of introduced (or at
> > least made more visible) by my commit ab4443fe3ca62 ("readahead: avoid
> > multiple marked readahead pages"). There I've changed the code to round the
> > index down because I've convinced myself it doesn't matter and rounding
> > down is easier to handle in that place. But your example shows there are
> > cases where rounding down has weird consequences and rounding up would have
> > been better. So I think we need to come up with a method how to round up
> > the index of marked folio to fix your case without reintroducing problems
> > mentioned in commit ab4443fe3ca62.
> Yes, I simply replaced round_up() in ra_alloc_folio() with round_down()
> to avoid this phenomenon before submitting this patch.
> 
> But at present, I haven't found a suitable way to solve both of these 
> problems
> simultaneously. Do you have a better solution on your side?
> 

fyi, this patch remains stuck in mm.git awaiting resolution.

Do we have any information regarding its importance?  Which means do we
have any measurement of its effect upon any real-world workload?

Thanks.


