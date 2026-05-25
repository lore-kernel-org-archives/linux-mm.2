Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F3B0CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 211456B0005; Mon, 25 May 2026 07:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19B586B0088; Mon, 25 May 2026 07:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B1E16B008A; Mon, 25 May 2026 07:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EB1BC6B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:51:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B48F1616AD
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:51:53 +0000 (UTC)
X-FDA: 84805778106.13.31FF9F2
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4132A180003
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:51:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kp8VSFHw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mRIUQCbGsDH0fRnrDCtYh7/ipZrmkoTvcdRHt/l2kgs=;
	b=G34zIQdg18iLa0g177KQR3mHsj+FcXNcltnheBRt2I739d4LVdf40A+3VKy6cZwNVEZ/+q
	ZuzefQcWjU1K1lTGWen+b8dFZ9XYgEXNEuohTG+kh1yLjFjqUtQ7He8VIVWmdw9RhsV3dQ
	qtdpYPDxVHSO9Z/J0E9mqarP1IHdPMk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kp8VSFHw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709912; a=rsa-sha256;
	cv=none;
	b=Sr/Xl7kFwkm+WugI9+52I/JCbb2OfS8/eGbuOKB0XufqZbSDKvAJsdn1tdRB2HK8MiKH4U
	AmWhI4GV8carzF1nE4S3xuj0ogW0/JB3CIBvb1CuRDgeWwox0K+zOdTmsmKQcKtxQneMt6
	X9LSCuz2aNi2153lmfQBsMe+g44f2Iw=
Date: Mon, 25 May 2026 19:51:37 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779709906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mRIUQCbGsDH0fRnrDCtYh7/ipZrmkoTvcdRHt/l2kgs=;
	b=kp8VSFHwpoTdQVY5gHjIP1nOoPOyAs3RBFQABRGieQeB1sTC/eWuYNgXI7ZTLsAg1VvXjR
	GD65u2SAWJdYNrN3oOuYw7G6kaODevz9n7cYXs8VRC8QuAD373Iz1/5AjrfNLBF+fWFgHf
	5XWBG+qA+7ipBw1kjKRIVj3/Agnm9dc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	hu.shengming@zte.com.cn, Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH v3 2/2] mm, slab: simplify returning slab in
 __refill_objects_node()
Message-ID: <ahQ178HGTmdpTMfY@fedora>
References: <20260522-b4-refill-optimistic-return-v3-0-2ba78ec1c6ed@kernel.org>
 <20260522-b4-refill-optimistic-return-v3-2-2ba78ec1c6ed@kernel.org>
 <ahPucZOXNmJc04nZ@fedora>
 <80d69c1c-a779-4402-af89-3be67b7f0e47@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80d69c1c-a779-4402-af89-3be67b7f0e47@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4132A180003
X-Stat-Signature: fcquhg6p8anep5ggixaeuuxm8yeru161
X-Rspam-User: 
X-HE-Tag: 1779709910-395336
X-HE-Meta: U2FsdGVkX18xeWCDWhKz0tNjP/WI3jxgoCtg892N5L+zXJkENkH+BnUrEXHLYObtWkCC03jUKehHGqNNdhJ3NAeB5f3Cqlw/jJzAIhBEcTkArDBT826s50O+aAcKbFdpEuPUVGttptm409CdRG0UtQfwf9fKUXOvuFQEXBLNnZwJPFDjJO1Sz6EWK9O62CAqFk8nwuS5J+E4RdjLuRizX4uzufzu75oIbGELBiWtd1laiCI6e37fzRBDYMFHN1aaGGNqP4xD0AKJUaUJTERExrpDppHGm69WP0/j1+Y8ILnpNJ1wFnTCAsAlPGRiT9pNH+Y8mWE1FZhMfMl04aMlwWm8V777Ja9As6iS/zVqh6p8K6Xrw8eFwCXFC5ta8QaWKirntxPLy6QrsLcWssRNybvxKZDLc22SmMxw9pEyakUVlR88KJaOEUaanFZY4jSOPNPplRk4P8rUB0ZlP2jI3P9S6xLz/m1uzBc6U0msWfXyNJQPTmrHbBXLpZQfGgjtWfYOya0UffWHJRbSzWUsc9qkOW3m0VVtfWBP+zh0LbG7rS685HyObSQmni+tFlxnwEUoYKZqPtPVw2gO5VU8iQhDVWlRiaBnuYmTQFL/eaekz41n/P/YrRtvdDpGHlzM9iFxvO17V5sYRdqi/ZACdfwiPcNk/oAnzclALMaEvFVz/JGhRMMsbloZR3QmFAhKpuWPZWk7PJKZ0HdoYv2TxE42NKasS3EBFoREITKO7lKTt9TGt4nsJRNV3vYHN2aUrb2uN70w7DSnyuBtZJHJF9A0x9avpZjfjm/ycu9VeA6CRIYzf1v9JpuLFbJQhkk/zhXtxmyJvFqrhu+GaLWXd8eSgNEeHce6tneR5bm7o3AQ9NqUYLCyR8sef+I9wETG0ZOQiTKFv7ykgOnsvhRGjy70wojRYcqgfMbOwitJtwe7YIq7EpWZSEOaW/5HmReA3iAhOfyBD1rBcdMq+Ow
 6xuelI2X
 FVjjZgP9hvTN+FMCWazSoh9jF9fSEQ1jAwf9zW40ATSmGgI3GDrzVGsNpaNxRfsQwkTe+RD1zbFezQXX96GTAoPYovelqmV2craX06WGmK8rjCiLRP8Kfj7eg+DpSjzy33jhppjB1iIhmfy97KgVNQTbxJIfUz73ngidC1yfJyrlwOJCPz3BlgHVgzXR49UL3ymNq8Z7fkhlQobdzeG0iKs94+kamEO9fSCSTvlRRZ6ywnirMZZ8zK8NIXnioxVql0Yjt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 09:15:49AM +0200, Vlastimil Babka (SUSE) wrote:
> On 5/25/26 08:47, Hao Li wrote:
> > On Fri, May 22, 2026 at 04:23:21PM +0200, Vlastimil Babka (SUSE) wrote:
> >> When we return slabs to the partial list because we didn't fully refill
> >> from them, we observe the min_partial limit when the returned slab is
> >> empty, and discard it when over the limit. But it's unlikely for the
> >> limit to be reached while we were refilling, and the worst outcome is to
> >> have temporarily more free slabs on the list than necessary.
> > 
> > Just wondering if the empty slabs temporarily exceed the limit and then some
> > objects get allocated from them, would this lead to more fragmented slabs in
> > the node partial list?
> 
> I think since we're adding the slabs to tail and refill from head, it
> shouldn't happen that easily.

This makes sense!

> Fragmenting is possible in general due to bad
> luck, I doubt this change could make it noticeably worse.

I ran a test and even though the data is pretty noisy, the
length of the partial list indeed didn't really grow much.

And after applying both patches, I can see some improvement (1~2%) in overall
performance!

Reviewed-by: Hao Li <hao.li@linux.dev>
Tested-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

