Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1E03C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 06:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC16D6B0095; Tue, 21 Jul 2026 02:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99F66B0096; Tue, 21 Jul 2026 02:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0226B0098; Tue, 21 Jul 2026 02:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1EE6B0095
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 02:11:02 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2629C1A03E1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:11:02 +0000 (UTC)
X-FDA: 85011760764.09.112C2F5
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf06.hostedemail.com (Postfix) with ESMTP id F32BC180003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 06:10:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wY5ZZ1zv;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784614260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dcuZrfp5xVpGEBorCEbOVhI4KnWfZ/XuKtgqVJ7Ilgw=;
	b=McBRAZHn1evkgSNbMX4ANi9l9L9nQNy7sLq6+bMCF6JSVE4qG/f2CjiRZ5klKxRlIVPa+x
	VIdi/7XZ/AfkFRHzgt+vNqy62KHUrxWuLGQm7XzWPQRlrTZlh9amiIrUJ7Fa0OEbRLHe4y
	AwnmE2mv9Im3qTUNVVOlqt+IXVxrK8g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784614260;
	b=FZ0GgNFmJzNwX5m5iIPVTobOB/qEZ5vzPUbWk7JckMDcX3897Sp7Qm7HpTzraiS6MH6dzE
	QcoX1qQnOqVR19FE55rlb085Xn3IL6Jn1bgsgAVbsPJ8TqmuPdADJU9PoIhuoYtr6WWr6f
	Cdk8/jdRG6U+BlXgSW85b1kwsAN2bKw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wY5ZZ1zv;
	spf=pass (imf06.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 21 Jul 2026 14:10:46 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784614255;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dcuZrfp5xVpGEBorCEbOVhI4KnWfZ/XuKtgqVJ7Ilgw=;
	b=wY5ZZ1zveKLkGNMuM67V5CDJqeAK3mHmhTaiLB3Vo+PyUMy/Imojc79igwO/Iz1nqa1vvN
	7uDLJKtev6Rcng0Gg9KGGkf7mhGZ6ZbXn5ImZXdjhQH0dUCsNRAD5cV39f4zyFwqjC9dni
	Bb+XfrhaoNzZ+8NyzCWeS9r1P/etXQg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: hu.shengming@zte.com.cn
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, 
	cai.qu@zte.com.cn
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
Message-ID: <al8NRfz6XbmXLtUO@fedora>
References: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260721084522552ZPa16p1SRj3PYat3sqxuN@zte.com.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F32BC180003
X-Stat-Signature: uqn475peqb9rkpoprocp34dhkngn1mfb
X-HE-Tag: 1784614258-813064
X-HE-Meta: U2FsdGVkX1+Hmfshor75q75/2dEkTs7tv66PTHUDFB9t5SLLbgQ9aB4OZqogVkkHiFY7Fhwjo+ONFSs16kSEpwRchm4g+Z7iG/7bxmBHFgpIj3cWowIPgiib8blFmj3CD5ItGMIxO5zt3sjO1u3+1xk37S1Mq8/zBKz5kX6Rx1ciL7CKiadudWOaIt6RA4QBDB0a/GOgy1+1xXFwKYhfOur912XeXvs9TMNXJvrMVX+ltgcmudl/YP1AwQ0rPb3CXma3xOcwLi2f2QPOu7ZNcndfUaEPfn1IyHqK5b8wFiFQLDSaRJSYLS5PXs/Gfn7ntLCib62xDGxEjR6GecspP28iqn/Q1+DrADjViya5Ii+SBFQP1NTo6PcrkF5VYHcy+mcae7MRlQWlztf1hqsCy9AEJfKg/rw6Ogn6AxynK4sHYWlBJPaJsUUtOmNGjQWEP+qgUL0+/Icv5XwJ1TDossl4N8l6iuuxV/exlV9bH9BRapHmr9jHHgKpA5iUwR7WMQ3k7v0g9YUngXO92Ou43OHuJ43atP5e4ccyYxjjmnXuKAsCxt7dtgRFiRp4qJqK03+ha5P77GapByYJ5iAged+OEKH3J8DS1VX6QOvvhh3Do2QX/OZJ38pSddvwSWcRZBcuwodmBEQCH3pdJGVf+q52C3e9tetwSygWgddpCm89CdRb4iWaEk2vPK1G98WbL4odHaFqji1W4LTg762HIxFSgbof1RK2gCyUwtHe/o51GNgpSSC6HTYl9PENLCz/tuGcOGI8JDF2uCj3YMNfBpgHWxey8ED5bAMDvAJI3JTnriUhYKX5wmATqpMLH8KTb27bHFT6otkgLZOrAXQLIuDdmE6TtSNHlAG5u3i7868ZTfAcNkOVkCFWCpr383KcgcBRb/Oocg82vwoQUycxpDm2RS9tSRcnozcMpAFaWD8FIGnSM0ZDeqpxAFVr+Wr79LIPhab/zhJyuWBaCTJ
 4BI7Q+FR
 qWcpXPnuEnxyFJzfK2UWAbrXTvP0iCA7nAVRTSGWDBoep0o7268mWpghCuHu7WQCT86dfnMinV1VmjfS7H3E3YN2KiSqgpQ/2MlLpndPp8fqxq05jWODHeRFa0asInUVi3ltVb1+KT+31/A2mBEXoVGZuCxxnL/g2A0E9mQVH+vX84oiFhBcK6lernK2ZgL4yPNVsKOfzdM2EHTFlV7m1JCH1f0iSC8BiEk2ZDsZuMCK+JIky2kTmFVXbvLYwx1Cdk+cRAxHMAb2ftYwpkewmIeEgymAw9AyohFVzVj6oXFvq3PN7lKYvddl/D1eeWLAyxFDO84aY+sJw6uTh9toby+r/Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 08:45:22AM +0800, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
> 
> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
> placing it in the barn. Without an explicit restriction, this refill may
> draw objects from pfmemalloc slabs and consume emergency reserves.
> 
> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
> non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
> because this refill is a best-effort attempt and failure is acceptable.
> If the refill fails, flush and free the sheaf instead.
> 
> Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocations")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>

LGTM
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

