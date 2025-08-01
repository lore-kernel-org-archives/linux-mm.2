Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 164AAC87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 02:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924066B009B; Thu, 31 Jul 2025 22:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4A36B009C; Thu, 31 Jul 2025 22:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8117A6B009D; Thu, 31 Jul 2025 22:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70D396B009B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 22:49:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2C5B25DAC4
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:49:50 +0000 (UTC)
X-FDA: 83726658540.20.ECA79E1
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4B59E40002
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 02:49:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYvkeQ9w;
	spf=pass (imf07.hostedemail.com: domain of kent.overstreet@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754016588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ny660EXzKCrBrfnr0TTiNnnWPF0elQFuRxvRa+dD5M=;
	b=Kbym3GM0c9u2PE/ZSIaQ/PuaDuZc9aCynWb5xQBuLrtbA0b7ZZAzYgqmfp0jTVfrNgWVS5
	5Wbb6afWIrVgEtx4uSOc9cCh5eVagO5LqbDF/opYF1D+Y+7sx4aFGCBLB7QUW19MZjfi5r
	fKI5pDaySkz8Tg4aTWTr9dF2JbR6Kpw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CYvkeQ9w;
	spf=pass (imf07.hostedemail.com: domain of kent.overstreet@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754016588; a=rsa-sha256;
	cv=none;
	b=TgTIBxVBQ94M88JlGJ6Dna1/pt+BF5P6Y2aXuvaqM40Rggub6+sKxLThaBTeJIh+eeskuU
	fGZxxNLxV/s266n0AC04BSALOnv3BjFHh3w1LDe52Cx9uBs7DYe9mBdsUUHFeMZYruCw+v
	gXbYRjvNPqzDQNDOW/u0NTYo1gvtxqw=
Date: Thu, 31 Jul 2025 22:49:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754016585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+ny660EXzKCrBrfnr0TTiNnnWPF0elQFuRxvRa+dD5M=;
	b=CYvkeQ9w8+05T93nN4LQEKKPx3OZrfdIfwPFRQS2wuytivx8p0K7i6BNB16OO0jDaG25gF
	3qofxMxw0b0Pzyqn8MJh5LD6gfUlFUNkTjBm2Ls/r2xNz2SWsOE2ErZCK2gic9QTYV+aL/
	aciO/gvI5H1Np0pq7QE5nUVJEhicISU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm: Support only one page_type per page
Message-ID: <orcefjrm3azqa4fs6fjrxhowiwtzqz3bfts7urlnzc3xs5oa3o@ukgpz6lwhebn>
References: <20240821173914.2270383-1-willy@infradead.org>
 <20240821173914.2270383-4-willy@infradead.org>
 <2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com>
 <aIwp48CTft68fssD@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aIwp48CTft68fssD@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 199nk4zrhknq8kih5txng7gcbyctoe9x
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4B59E40002
X-Rspam-User: 
X-HE-Tag: 1754016588-436718
X-HE-Meta: U2FsdGVkX1/wqYnA7FT8Uv34xoxYqs9+n6RfIqEpiZ/LIsx99MTrZFhcFQxM7psxfrzr5nXE5FABpNY0C4OCMof9KVjKh0Bf1lSOY8ZYHHJ+sjJ2g47pkq/hbSZNmb8mj5FVXDEwR86PeYYe6V/mjrTuGyYMKEbWrcigG3h2/08WPR0K7A71o9C8gWqTwAd9ItD4QwqF8BVs28qSAoEFdQQkyLbo/WlSmDaQBE8RBbrem+9bysVR/MnbTHXNQ5pyzYXy7d8ph0IOINt/NwsDI+veDH43EQw8LKUcdAMc/HKHmm7+2SdCn3z8iASlpMi3yVl+BglhuLnBqyjEXgEEN25LLzCHqcNTZoqXM6sVXO9MF6KKWR13JK10V947/RtPyLiHKAoujAEMtsW8MnfAoN2QWSaSKZeYfDnDKQpHmWZVJLIx8y2TSaQLTMjWxvDYNdzYAhUEbge+dzvR96nXIHK3Mqqr8jFXJBnUdJ1xnsZNjJ2dkL8plT7st0uxWUWZ3mZg3SjaT62qR4AbpeqQDlM8ecX8cmaHzJa1HmBGKiNme+XwEhpgn23Dm0Sogk8EG/lbO7p32AobujLUAGOTydtuHjRKobSEOf6Nlakm5wMBV5b6Sf8BhcgAIHznZTqrbYEQI0rnW9BNpzMCJZz2w3H13aZxAv7PtcbiEjPCOagN1gCEoDcv5idv0+fKIE6d9Sl5+mW+j6z1IDUHFkUUQPKHnaGz83WJM9hs1DN5Rkx+35wEBa8V2C+D6rJ6L9PbPNoUpMkILzWps0ceAUtWfguzL3xIbYgy5+k+YNKq5UAf96T+jY9k2RjyW4YKyeCRAklPOFmGZKEoE2uT1mgo7SCBDPDuJw/uXJDIZPAX+y/0STHK3fr4T1x8YicdF7Fa47J9CdQZucfO4jSSimAEyoT0ayybRSHvTcQlUa/q5Z4gtJfrRwJy5kxk79UycbEvels8aq0ygYOnqLp3AE6
 m5sUDbEU
 emwdZrX0tNK2XPgiAqO2yEmXgAWos22MnQTJzjkfR3chbgrUxmiAX0NibAewDtLy0yhKvDaeNS+2Wa01qJp6tabuo3lcZIRWn9/UJC1sO+Mh6CgGNZB4Z815flskfjL7+8xpAwe/CjY0Il0jw4llRsRVUdPGgSrYRCcy2FfcKEh9hR4l769zmSYE201PzzctEggRRYtoLv7IIJ09/zv0EXlU7pN+tPMvNCSYLF5txI/QcewZJcoFD6f3Pf4bodYmN6kwIRPbxbdH7HJVSiraROfMJ3v+ekLVyAmx+G3oUgelnwJelzN8SZyeaOSFmlZyDwm7l
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 03:43:47AM +0100, Matthew Wilcox wrote:
> On Wed, Aug 28, 2024 at 11:35:28AM +0800, Kefeng Wang wrote:
> > There are some UBSAN warning about  __folio_set_##fname/__SetPage##uname,
> > 
> > UBSAN: shift-out-of-bounds in ../include/linux/page-flags.h:998:1
> > left shift of 240 by 24 places cannot be represented in type 'int'
> 
> I can't reproduce this.  I know Andrew merged this patch in, but I
> tried backing it out and enabling UBSAN and it doesn't show up for me.
> Relevant part of .config:
> 
> CONFIG_ARCH_HAS_UBSAN=y
> CONFIG_UBSAN=y
> CONFIG_UBSAN_TRAP=y
> CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
> CONFIG_UBSAN_BOUNDS=y
> CONFIG_UBSAN_BOUNDS_STRICT=y
> CONFIG_UBSAN_SHIFT=y
> # CONFIG_UBSAN_DIV_ZERO is not set
> CONFIG_UBSAN_BOOL=y
> CONFIG_UBSAN_ENUM=y
> # CONFIG_TEST_UBSAN is not set
> 
> (I tried CONFIG_UBSAN_TRAP both on and off)

It's an integer promotion bug, so arch dependent?

