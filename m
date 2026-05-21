Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79DCCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 01:01:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E94AB6B008A; Wed, 20 May 2026 21:01:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6ABB6B008C; Wed, 20 May 2026 21:01:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7C46B0092; Wed, 20 May 2026 21:01:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CB0A26B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:01:47 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63CCAA04AE
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:01:47 +0000 (UTC)
X-FDA: 84789624654.10.6710437
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7D03940011
	for <linux-mm@kvack.org>; Thu, 21 May 2026 01:01:45 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LE8g0B/v";
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779325305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6+eCAO9BUhXRuKgK/q3rPe94yeakgzBDRKqgv0P63E=;
	b=l3xEqKdDaeYGiHsLYsFtBbSfin+zHCH2K9cmq2SxSq7PdkL+QD9F+MHltPkx7GKh3CXrly
	t9j10pOzV4KP4yxPpAqQoMSyNuFD55mW5Oc3uWDERrTurT8tbXz83yau0RXmjAf4b6Nne5
	8+eW07tg5iWQrSsWLo5Xto8oos0K2vI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779325305; a=rsa-sha256;
	cv=none;
	b=7oxnaAhLam54rNs8v75gV6cZoruGTnQBop5WGJipVUj9JVIrUx93ZZHJ33WSlBy6+5u1C8
	yheUyGemx9vpSgA/sbtUyTGRORcbCGnQ3oW568hXm7s+3Bxuvtw38DiFj+F+My18khAOwy
	hOV3KaYIWXaFlU3Uq/xuRB3sAPgtyfU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="LE8g0B/v";
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 20 May 2026 18:01:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779325303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N6+eCAO9BUhXRuKgK/q3rPe94yeakgzBDRKqgv0P63E=;
	b=LE8g0B/vDcnIlCW6Tn+CdVICwGSpp0kHWRyiIVzSfJQxgHaUVCsj+vP7wxYFU0CeHTovPV
	ueE2l0yfH5UUOw9Rchqd8mw6i5zjC7QrXobCW2RrPImRrwnzf9B0blMA5ZH95XQWs9mPnL
	6x2ORFtbESwq8Jv717LlEr5fepfUea8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Alexandre Ghiti <alex@ghiti.fr>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH 2/4] memcg: uint16_t for nr_bytes in obj_stock_pcp
Message-ID: <ag5ZXSKgUz3tt4mV@linux.dev>
References: <20260520053123.2709959-1-shakeel.butt@linux.dev>
 <20260520053123.2709959-3-shakeel.butt@linux.dev>
 <55d36f91-fcae-4506-9b76-4a7cad3d256d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55d36f91-fcae-4506-9b76-4a7cad3d256d@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7D03940011
X-Stat-Signature: s5i7kbj5m711agwwxj8qsoxbm4y9swrf
X-Rspamd-Server: rspam06
X-HE-Tag: 1779325305-503609
X-HE-Meta: U2FsdGVkX19txU6qoTntRWJDl2FTSg1Y5oaW3cR3dC5srHkEgE2qAZ1z2ABgQhTkjBueAhMAZ+trFZ96zJov/t15eNjpU6GzL34+G6kEhrSbGI0deiGves2k6JaSxWWjcQ17ovpsNC/QpugzILt6Npb0z6fzVRVqvUYbpYH6rH+duxeFuEhPq/VohXkL4JTDUef8ePugKTX+UvCVSOJjbPM8nRHasBhVYB8Ee4paujyvzVOKCKyjo18NWYdr5585TDS4A2Z7WRcyzzBGTC0J+ifwUT2MsD0D26rhW4BN9mkaVWTqEcTT/MLHj6pAnKFZPywYmO3zLb6cPdQPqYWFghbVnJqfm7LO4e+V06bPMDYr2okWi6nnIyXNSQ6V//Vo/1A5/oqzKmk43Yybq6Ini2EDzNnIL3C1oorJNOwiU6mQDHKqceJHyKTLqYp5z856Bh6UG6F+ueWByw38Lcjm81f7PZ9U54YHxa6ig4q/8HpGM/Z9lLGekJxDik6zeQiS4bGCSSKBfITnwiH9vzj6DlxsQO52kGfGhZSp2VxsNTwzp67FMYVfj7jfUHjpdOr4K0QpQa6dsQhmQSYKDoGTFpmiXR4xHDKjIIp8yvUNOyZMaCldNhJy3tDEeTeHJ6MSIa3QpYALN/8TcUts4bmd/0sBWVMQzgRQYrV20fZGTod3T8eR8jwUqf4gVBG3RBMIEoKfqQs9XBlH37jWUo9ol7bpnm58Weqhwg2PQyRBUN3AfzO9JluHEKBDxQJktxqu0O6n1FirqE727SamOJVDyyJPGWJQ9+vCpayQCZqEtkjnxgI3fnFzLqsoZE6Uw30QMOq8lZWvw8TniydiT9BkRAYijZaeIXzFO3hQpNq1H/4MJGiU0j7s6KVEFzGg64geEJCPhAW8nZtMa+KCcIZnVf6BJo3o+JLUzxbguDvB+B4Mgle10eH+KApN1yrgGhg+1YJuYmpCBpPOBpVumAX
 B0veKY86
 iMLys/WQ1RuaNZv+kMrHqHmiaK/oIHg1HKirwJL93bScfu18YwqqMJGFH26VZiI+uxv9l9ZWPWg2OX7xV9+84d4mxeJvfH91WHhUeTmQ4ueFp5t/GfHYqRM2X7z+o10sPepGWjFuN54wOz/RhC9uGpxz58d3/8VHTPt7dIS+vXmNuHe10WQXIqnLeQVcZxhAoyOb6nDjQh4nP+ROqwCxT7z1TZ3GkyfP1JhrKFYZM2HQ2b3kmLPZUOnYmpQO4cXF4oRU+kYLDDvfj+xr6VSjAKWlk2Tld3XgJFiZQ/X31z+KtP4nSR9G8G75LptTT7+CGVUB6Sgg8v11Lp0LeMOVkIHnREE+QOaKJwf7D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 04:01:45PM +0900, Harry Yoo wrote:
> 
> 
> On 5/20/26 2:31 PM, Shakeel Butt wrote:
> > Currently struct obj_stock_pcp stores nr_bytes in an 'unsigned int'
> > which is 4 bytes on 64-bit machines. Switch the field to uint16_t to
> > shrink the per-CPU cache.
> > 
> > The kernel supports PAGE_SIZE_4KB, _8KB, _16KB, _32KB, _64KB and
> > _256KB (see HAVE_PAGE_SIZE_* in arch/Kconfig). After the
> > PAGE_SIZE-aligned flush in __refill_obj_stock(), the sub-page
> > remainder fits in uint16_t up through 64KiB pages where PAGE_SIZE - 1
> > == U16_MAX, but on 256KiB pages PAGE_SIZE - 1 == 0x3FFFF exceeds
> > U16_MAX. The accumulator also needs to stay within uint16_t between
> > page-aligned flushes on 64KiB pages where PAGE_SIZE itself is
> > U16_MAX + 1.
> > 
> > Accumulate the new total in an 'unsigned int' local, then:
> > 
> >    1. Flush whenever the accumulator would hit U16_MAX. Together with
> >       the existing allow_uncharge flush at PAGE_SIZE, this keeps the
> >       uint16_t safe on PAGE_SIZE <= 64KiB.
> > 
> >    2. On configs with PAGE_SHIFT > 16 (PAGE_SIZE_256KB on hexagon and
> >       powerpc 44x), push any sub-page remainder above U16_MAX into
> >       objcg->nr_charged_bytes via atomic_add before storing back, so
> >       the store cannot silently truncate. The PAGE_SHIFT > 16 guard
> >       folds the branch out at compile time on smaller page sizes.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> > Tested-by: kernel test robot <oliver.sang@intel.com>
> > ---
> >   mm/memcontrol.c | 33 +++++++++++++++++++++++++++------
> >   1 file changed, 27 insertions(+), 6 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d7c162946719..b3d63d9f267c 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3339,21 +3340,41 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
> >   		goto out;
> >   	}
> > +	stock_nr_bytes = stock->nr_bytes;
> >   	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
> >   		drain_obj_stock(stock);
> >   		obj_cgroup_get(objcg);
> > -		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> > +		stock_nr_bytes = atomic_read(&objcg->nr_charged_bytes)
> >   				? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
> >   		WRITE_ONCE(stock->cached_objcg, objcg);
> >   		allow_uncharge = true;	/* Allow uncharge when objcg changes */
> >   	}
> > -	stock->nr_bytes += nr_bytes;
> > +	stock_nr_bytes += nr_bytes;
> > +
> > +	/* Since stock->nr_bytes is uint16_t, don't refill >= U16_MAX */
> > +	if ((allow_uncharge && (stock_nr_bytes > PAGE_SIZE)) ||
> > +	    stock_nr_bytes >= U16_MAX) {
> 
> nit: This should be > U16_MAX?

Ack.


