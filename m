Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7880AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 11:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 788896B0005; Mon, 13 Jul 2026 07:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 760AF6B0088; Mon, 13 Jul 2026 07:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6765C6B008A; Mon, 13 Jul 2026 07:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4951D6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:11:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CCF3816A175
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:11:41 +0000 (UTC)
X-FDA: 84983488002.28.151B242
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1703F40005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:11:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uirGvzJa;
	spf=pass (imf12.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783941100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+vXYTjP4H8eRjjP/emOufHi0JWx5TVft1dc44xReZw=;
	b=n8SicNd6I4x9uoQanKlVvqkUc7+RHaHJgGp64fRgbAtOFBTMkIHpp5Ip+AbXj710u9Wlnt
	g09aqLPnfK/Bph3cUH0JFWMkXn1kEjgWE9ypBIBqDqoFjOmZlEm+tdWqFgTwhs0rDvm00n
	8lgz/IoAunLv4xf6P1Is8hF5wXcAfDY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uirGvzJa;
	spf=pass (imf12.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783941100;
	b=O5oaKoLjxJawnJB2DWwSOlfDp743OFZPHGoumulwJu2gTjR3k+BNAtRNsLhErGRYb97KZ/
	QleatLICPJk1PbuG2VoPpama918K9AHGl92y685O4/63ABecf9PREuObgjHmWBMDElKrZ4
	Q3NeD4e2cwz1FjYwOXkVAnscwpy/s/M=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783941094; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=W+vXYTjP4H8eRjjP/emOufHi0JWx5TVft1dc44xReZw=;
	b=uirGvzJayhPLcHRXlYccCU6wzrqEY6h6h+rLCUJd1hTM+mzQCbaMsao09DqEHf6D4PzEcyNl+8hG9e0K4oOR5x1LpRVYjzj/o0gA6cm+N04wkWzJXbT7XstDvo+40y3QlR7/aPq+iSUdBUAOc5VIjntbXVynKNadnDpQrPi3haU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X6ygMa9_1783941063;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X6ygMa9_1783941063 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Jul 2026 19:11:32 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  kernel-team@meta.com,
  willy@infradead.org,  jack@suse.cz,  akpm@linux-foundation.org,
  david@kernel.org,  ziy@nvidia.com,  matthew.brost@intel.com,
  joshua.hahnjy@gmail.com,  rakie.kim@sk.com,  byungchul@sk.com,
  apopple@nvidia.com,  Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/2] mm: don't apply task mempolicy to unmovable kernel
 allocations
In-Reply-To: <ak_bIlYWJsEWx1P1@gourry-fedora-PF4VCD3F> (Gregory Price's
	message of "Thu, 9 Jul 2026 13:32:18 -0400")
References: <20260701222112.2820098-1-gourry@gourry.net>
	<87echco1w6.fsf@DESKTOP-5N7EMDA>
	<ak_bIlYWJsEWx1P1@gourry-fedora-PF4VCD3F>
Date: Mon, 13 Jul 2026 19:11:02 +0800
Message-ID: <874ii36t6h.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1703F40005
X-Stat-Signature: 1wbe4aefmgw8wmusqxyes1x7w576kqcp
X-HE-Tag: 1783941097-199926
X-HE-Meta: U2FsdGVkX18XeD3e0a0jr+ybGHIaD1wRQwaaqzjGGEvrJ+yAEOSGyS9D+XeKMdKlXGCmbstKbGP2NrSuMv1dW4GDaWgFpzfB6gk7KvvVFnDLlTao7J1vvVMQ6guOR50xem+t77HdQB0uSYezeLiDHRty26DasSdmihCWuvLmuwfm2qsWyChtF1kh4FjMpkSpRguSpaHyF9uWRqWwbHgWkZ5/Nxl/7lT8o67nGG/G3iJIsAlokS1COvNRR0jXY664wIOLYwGpF2oU7hVhCRUhcYYRf4oq0B3HveW5GTt70n3OrAhZAvmAii9FOLA+XpXQfiWQuG0HHAoiU7hsqCYuMJfq62TvnrFHJonwqheH1pluxGUzLJCtcCTGH9pqC7Mu2JJB7HzUMrBSXlpoQHlEcwuMvhRZwx1DyE938LcApBfobTnNfCIbXHJXIvsuNmGw85HJXHZe+bybsm2wmasKHeUUn/pm7BGbOtdx3Krmt3T0hokIy6MA+SJ8XGnYupxS9kLfXP55g++t3ngcUQwiHeLMa3gAx4DWUzsJto4tOq4OlF3n/koVbu1uTIh1g7dt3tj79JCHExt3HOdzcDuWC/5FPbTULlTLKjKNVkbCkO5k4rFafQh+OYhhynPBuJoABH4yLCaTS2hE0XTymanQNH+TeQFTX8VWd1hTzFNU1Lh1scvUGVrMkZeWOWtvfbnaSEPPvUy4rM0vvTgCcfEUGnQUH6Ihv+8L2TSndrvAuSViU6yk7jOQnJoO5Bm18MpgzeY3AWUasOgILze8MKwNflcvgnLoVDdLS/exs1qXSEu8227ioUZ4WoMA4QqYBzIXl+Aqlm+XMzZ4OoLPqHdbsi5n/lHRAKaGuQhFE97kAi3hLcMtrURXHl/A+6oSCJxc6h+bYTJGzA2zJyTSAa21qqVRBGFAvDqnl2+xeBNKhY7FPPo28GZld08Smd3m17r6Cunj2Ji9pmWKUTd2hx7
 ds8MC6eQ
 X1kVfJttIE8VAJToXnRKhTQQlLwVARW/DE4U5olS14AoLUZQTysNNjMnnOWiz+WZMLpfdLtgMVk7yznrwJXa8EHMoq7N2afNlORqrolcMpdPkE0EEQmRtIr8wOUbunnXVdGQ56nbDsVNV9aNaaMdpBCl90lrxiwl9ssppkyVWAIbEd9U8jrUvr93bzRhhh6317Trk7gi2FBD+dK1v2jjSaarfEdK8FdwG4gyvPHd9sKlCHcpTT3EjmjOyoxWAMcVeKMUTZqOnL/YrWuoGYsoF1b6Nd8C8i60dBMT1A3Rfjx3JtM6K1wqaroQjOoo5AiKyqM9A0m/xFKD6leMA4jJ7jTpR2jAKlmJPvTobZe/rrhFq+0kQVeZV5BXPkba5Ycb0TsBjSdSkd505WE2WzmJKQs7iHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gregory Price <gourry@gourry.net> writes:

> On Thu, Jul 09, 2026 at 07:09:29PM +0800, Huang, Ying wrote:
>> Gregory Price <gourry@gourry.net> writes:
>> 
>> > The unmovable unaccounted kernel allocations stop following the
>> > task policy and place node-local. With no policy set, both place
>> > node-local as before.
>> 
>> Personally, I think this should be the right thing to do theoretically.
>> However, you may need to find some practical issues that this resolves.
>> 
>
> I don't entirely disagree, but there is at least one scenario where this
> is an obvious improvement:
>
>   BIOS-configured CXL memory brought up in ZONE_NORMAL. 

Per my understanding, kernel configured CXL memory can be in ZONE_NORMAL
and BIOS-configured one can be in ZONE_MOVABLE.  Right?

> An task interleave policy on such a system will end up with unaccounted
> kernel allocations landing on the remote node, which is just not
> preferable at all (and uncorrectable).

Anyway, some number will be good IMHO.

> It's not a complete fix (fallbacks can still occur under pressure), but
> it's one piece of the puzzle.
>
> Forward looking:  This patch makes private-node's with ZONE_NORMAL
> reliably hot-un-pluggable.  But that improvement is obviously predicated
> on work that isn't upstream (yet :] ).
>
> I need to send a v2 of this with SLAB_ACCOUNT fixed up, and some numbers
> to justify dropping the pagecache fix.  But I will probably sandbag this
> a bit until i finally send out v5 of private nodes.

---
Best Regards,
Huang, Ying

