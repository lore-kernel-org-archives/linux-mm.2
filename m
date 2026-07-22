Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AE38C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8151F6B00A2; Wed, 22 Jul 2026 12:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EC6C6B00A3; Wed, 22 Jul 2026 12:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CAC6B00A4; Wed, 22 Jul 2026 12:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4116B00A2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:36:17 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C732F4016F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:36:16 +0000 (UTC)
X-FDA: 85016965152.08.CF23D8F
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id EB38640007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:36:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RuTQ2dXC;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784738175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkKbSDToe7oNwQvcp8YwOTva5uUO6i2CXklEvla485M=;
	b=JJ55O/WCo9s6dHtmHdVymAIOBghThE1t6PSjNn1IcoGv+ZQ7VKXPDNJUFvejGOQl9CytSA
	m9WYd1qs/M++IRigVdsT659vXdAtemtIoiHPBmP6p75H38YDMQMFsAuNtVrOSSqYl61MQF
	iVelLVeyzNZHsvoJeXboBSZZjTi9LmE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784738175;
	b=POoiKTdYsyeRn8PeQ1Nh7prLjtucGYVRnwjahNeztY65q4G6sFrChu9zF1ov/a+F2KoQHx
	zq+v8ukX+SEsSlSlxn4uYYHr3kbn7EvEhuAOfuRWOtIa1bRl1njBjUKgx3RI5IN0ldAkhU
	8bwsVOQF6DrdR6tIPC7uRptb1IjWuHs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RuTQ2dXC;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784738171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bkKbSDToe7oNwQvcp8YwOTva5uUO6i2CXklEvla485M=;
	b=RuTQ2dXCRsKcy1/kVacuK79/2l9Sxb195ZTSUvuelQx2WQefKsjkPfpci1ZEDmJjdyfExO
	emo9F9G1tT5sV9WtqueZ6HGevrY/k82dYd8vEzxboVD9OBTDuou0yd4nO8I5vMtuNUqmqZ
	hnONdAbmlv36HARWV7BoN92iBYteSEI=
From: Usama Arif <usama.arif@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: Usama Arif <usama.arif@linux.dev>,
	baoquan.he@linux.dev,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	youngjun.park@lge.com,
	ryncsn@gmail.com,
	trondmy@kernel.org,
	anna@kernel.org,
	sfrench@samba.org,
	linux-mm@kvack.org,
	linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/swap: revert to single-folio writes for synchronous swap devices
Date: Wed, 22 Jul 2026 09:36:00 -0700
Message-ID: <20260722163601.1421253-1-usama.arif@linux.dev>
In-Reply-To: <20260722130615.3163560-2-hch@lst.de>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB38640007
X-Stat-Signature: aashmspkhyckazoeae3o7pz6k5ydmpw9
X-Rspam-User: 
X-HE-Tag: 1784738174-857111
X-HE-Meta: U2FsdGVkX1/eJXbnNXwAT7WP9+qV5ZEK1eAf0u4eRV4wZHTBNE1bRNnQ9EVj3Ya4o4PjwB+OxCEeJdJaDi4wnoSrh4W/q/lrIQmx2l2KOpofVEjbpS0NjQQxMsLvrSEhk3RcEUawKOCXrADLA2MrR31xd9uZg14DAAgJFwJMtzN5nMC0fE1eyj0zPrweAWF1HOn0wRxc/IpyLpW1lxX1r4z3jjm9UAurdCS7+I1R/VQPRQb0EeOhVKJAf3pb3NcU30GW9yRkw71ryLcJT/xS0LVDngXrvRUA3dfrh7M6Zi2GdkAwIrK4JvsRVJ3nXDmvMCyVU/o6GJ65zQdASys+6T+/KTCKTPnurYV9d32hD59afn14S+3zf278x0tuFQGwBKQKQZ3W21ggdBE9yxae/+XLog87dN3mEiA5sDbYyFoBMAWObz+Y4SR2JV9Z9HqVl2JTQuQmzG4TIwbanrJcOpuI2Mm34FDZ+t+76Edn3gaefhiRRppatZ5LuU3V9I/VAYrT6bYK0meCilfWnVtguHsCSJiqgAb3aRRUpxSubpGeYqCW7uU4jldybwp5IQFMCWO+NZ8sLHlkCHTVpJ8I3bSp3BatYtLRXDbcPkdcWTAyh8ikHr9qWyfwnXCACKm0mNMJhyWlKCVKkc8G0l9WsBrT65yYxFwTIq7vA3e7Yx0o4uA0uWwd93HYiTtRaS/aUFw3xKmneqjiOuHDZhkQ75c/mAIcXDjLT8BzdBCskSBQ0d4HhOrc3BFA4ttP8Zefv5E3myv+PIk49ZNQttwX8Ly5IKVs9lbMrhKoFj7XvHhYk0g9Yts9Zdb5tFjp8l5AewENLKwwr1wL3M/H0Bie0ZQ5VIdUh/4oiESezL8WJwiZmlvnYWOaG3lS7jPMk47LsC5ZVBC4c1+Nx4kD1cbV301KDJs45xsHZfxUJnyh13A+aqpTj7i3pPUdwDgVa/7naVTjdpqC5UgCEQJ3ctB
 i8hcI4DO
 OCufAPY3VdUU6qMs1wYbLwQp3famLzLcZYLx5WjfeAd3R54oEcSCstWYiVVtPo+wIbmtJ1WpMcRJPiC5CNTZhi1IzDHlml3ohs3eJ2obPSLdGMMGybY7JA2We9KJcLe5Ma602t5rLZnl2dXhr8PA6sKTboh2WWFKERYVEM3QPxe0SZ0LcUWG+QEyY8RTof027J6GY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026 15:06:07 +0200 Christoph Hellwig <hch@lst.de> wrote:

> Kairui Song reported that zram benefits from submitting each folio
> directly instead of batching up I/O because the classic LRU scanning
> benefits from clearing the folio writeback bit in the scan loop.
> 
> Accommodate that by kicking off reads for synchronous devices for

s/reads/writes/ ?

> each iteration.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 


Change makes sense.

After the commit message fix above, feel free to add

Acked-by: Usama Arif <usama.arif@linux.dev>


> diff --git a/mm/page_io.c b/mm/page_io.c
> index e4fa7ffffe8b..c984a4023a65 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_io_ctx *ctx, struct folio *folio, int rw)
>  	}
>  	bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(folio), 0);
>  	sio->len += folio_size(folio);
> -	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs)) {
> +
> +	/*
> +	 * Write out the iocb if we filled it, or if the device is synchronous.
> +	 *
> +	 * The latter is to work around expectations in the classic LRU code
> +	 * which make synchronous clearing of the folio writeback flag in the
> +	 * reclaim path beneficial.
> +	 */
> +	if (++sio->nr_bvecs == ARRAY_SIZE(sio->bvecs) ||
> +	    (rw == WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
>  		if (rw == WRITE)
>  			swap_write_submit(ctx);
>  		else
> -- 
> 2.53.0
> 
> 

