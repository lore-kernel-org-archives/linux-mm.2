Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41D05CA101F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Sep 2025 01:17:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C778E0009; Fri, 12 Sep 2025 21:17:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5A38E0001; Fri, 12 Sep 2025 21:17:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DB598E0009; Fri, 12 Sep 2025 21:17:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 601B58E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:17:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 312D3C09A7
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 01:17:07 +0000 (UTC)
X-FDA: 83882463294.11.E43A3B0
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 32F00140005
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 01:17:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wVar9OQb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757726225; a=rsa-sha256;
	cv=none;
	b=mTdx5xKewBovnYVneFUUBm1gzmIV2yg3lvlwLrxIvUQk0iBc6MDfwUoV8uChCIXzxydheD
	JDQiulk7UnAPiCZbtXWoCqw6whHsoPCO8sFZP4ofwGKWixPsXovpiwbHczAU6xL/tLvZGt
	AJnutxOMEX2CR51J2vQ5WejOXauh1zU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wVar9OQb;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757726225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqlLAeYWdZwvoK0DYA0jAex2CBIzpCMdqLmlmnesYyY=;
	b=6ajkdYlHyy6i3yjqzI0F9JU+V8+23g0YFIqESFvRwQP6xF7L6sHWiigKutWcge8w0pd2Ef
	TxCykZBcXmJG71E4HTrS3VHliX1kb8Zl+F0utXfPQ0Kt9KzzgdU9ZJlYG0NdEejKCrsxDE
	Ry9dHTZE97c9LwtpEfv5sdSxVXbwHrU=
Date: Fri, 12 Sep 2025 18:16:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757726222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gqlLAeYWdZwvoK0DYA0jAex2CBIzpCMdqLmlmnesYyY=;
	b=wVar9OQbAnp05C49WbC/5f+y2yNP8Pia2055lnzcpJTO/1VRo1pbgOgkt0+Ycshor2vWJw
	z0YRZE6ftkwSburpBcpUmh7bp5ZoFQFF4XvlJl7rbfkhiqLm6cYQtDfAP97Bj+E3ZwE2yX
	6/zMs1w9LPIjuVdLrA3ZcqZ8RF/v9JQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, 
	harry.yoo@oracle.com, mhocko@suse.com, bigeasy@linutronix.de, andrii@kernel.org, 
	memxor@gmail.com, akpm@linux-foundation.org, peterz@infradead.org, 
	rostedt@goodmis.org, hannes@cmpxchg.org
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Message-ID: <6xghjvydfxp3m23oddzzbkm6o6j35w343njoediubtxcfxc6ye@lj2uhqrks3wk>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909010007.1660-6-alexei.starovoitov@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 32F00140005
X-Stat-Signature: zjh5esa18snqthsg16661ez64r7eb4wm
X-Rspam-User: 
X-HE-Tag: 1757726224-766711
X-HE-Meta: U2FsdGVkX1+vD5BypzLhaW+UrQrFzk+3V5IvfipPgaQ+hb2cWuFApEJK0Vk5X8prLtoKAIaKtoxyqwMZ5mNNWqO5Pv6tu5xbxPypbFOo8EkH5R+9TzXiKxDAk3lxTZjNlwCD09b90ND+or5L/f1Fvjzp1IU56A9+Dv11fQP9jyAcTYHDf7x7VjKmmzE9JpRjribhXUWuZH4NoYdHmEI4ggNacjutlRxh4D4eWZ9cVFxHTexkHhahR8qQX91J7v+GMfBJ7ntKYjKoVccU0+Sx0vBRmPWD6h5CIyeiGzwRnm5W12gIEqHpkeIhdmVb5zztCXH1d4asSiJlsJhZiSrHB+Y1lAxdqkZW/GN6oF7T1G+w+jp8OCOfaGNcoksLPCWrdmhY7aMciE2TMrTtDXi/VwN+szuD6cUH7vSxXnxLlRVqNOTJSZDn/KingvRawnDyAXO+CgxEr+ZYeznuFcwDgm+uC9FQfmLEfxHo+B/yuTWbiXbVUpIMs2hG2PLq53XJ6qmkGs/aYL9DzG3PItrf9hibM1JRgl9/gGyZNzUknzfOlq0K8T7L/T/OpLblP6vqqKu5abn96sRVJriXzwmT3t5OgU572TIFs6FyVdk1+Y7MV3Dfd2GT9HvbEeDxSXCS8r/6deEvSbM65QH8ZF0MUvxxNB+3obS9SIU7nANFk2Mk8CVML7ibNuUy0odAVUlraOyvX587rEJwc5os0Sf2UgZU0+inkSBQ/dEV5GM2/064pSxaf2DG2n3eUikOOwYtLLwUEfAQfVPCMX95hAQ/HNQWkg9xZ74wFvbDF6/Bw58FmJlz600lW5cIdgVQBTSdErxYY5KmmrmtWG6QmqprwkZB5YzUgl63lOcoTZUYkfnasCCYOKcx3f5eOV3w9wAj5vYKkmPZQ011JGMNN6AH7/+JDgo3kAdgsfkdXg8hKb2dGjQXvYRz+n4f1tWi5hXToTL3puhwL6vLN3kaf10
 ml2mDpJr
 ihC7XsWYYkdLXq6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> From: Alexei Starovoitov <ast@kernel.org>
> 
> Since the combination of valid upper bits in slab->obj_exts with
> OBJEXTS_ALLOC_FAIL bit can never happen,
> use OBJEXTS_ALLOC_FAIL == (1ull << 0) as a magic sentinel
> instead of (1ull << 2) to free up bit 2.
> 
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


