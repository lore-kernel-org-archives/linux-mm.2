Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 784F7606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 12:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dletiwOF
Received: by kanga.kvack.org (Postfix)
	id 4C0216B05B0; Mon, 26 Oct 2026 08:47:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498BA6B05B1; Mon, 26 Oct 2026 08:47:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D5376B05B7; Mon, 26 Oct 2026 08:47:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 196826B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:47:15 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96022406FC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:47:14 +0000 (UTC)
X-FDA: 85364752788.15.79A8294
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E7B13140006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 12:47:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dletiwOF;
	spf=pass (imf23.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793018833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MY2/oE50ls4sLwiugB1GPOFn3VQZXmVjO2YcQdI0xoI=;
	b=SwU47ksWng2vojC4Qp2j/IZL9mhKSTPIWBFR7UFJNrDyw9RYwpUoNRj67ANAp98PY5vy6o
	aw+RpnbJOdcBizwPV1sQjZZzYNukVQTVdfsHJXj/P3QzDZsfuGZOQEafFdRJpG9Ietis/i
	S+Qrea6OqQ+fgG/awmxGhv/zZuo9iR0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dletiwOF;
	spf=pass (imf23.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793018833;
	b=RA5UOA6n8SAJ+tcOiFYKm6vO/NG1uisARydC7Pv/i8r7GXo/e8p61u8mj6RUs7HKo3odGG
	ATsqUGHmRTJSLRwSFI44Gi7VwR7M9WjJZHDngCGbjD2ImJNuUSFolF3xcREoOqZqIcF6ng
	U1fa5zOf6tQjR0z8Y7GaJTH6zHJ6wlA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B979402BC;
	Mon, 26 Oct 2026 12:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 827C71F01825;
	Mon, 26 Oct 2026 12:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793018832;
	bh=MY2/oE50ls4sLwiugB1GPOFn3VQZXmVjO2YcQdI0xoI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dletiwOFnOAhUfZUv/7sYjo6kF9eaUxqjsksJHXSMeKqcpQWaT0h1QOTA0PmDAcWo
	 AvMFrGqvq0Dj0apCyec6s3Ke0TvPipmjBslg3NkwHFrqXqOnY0poDJ1Irs51nNWRPn
	 H6Ep82aiaisWDf1WCH9j2UyTBkD28NJxUDvvkJ9oYn0cCTQD9v2T0/EZUTYWTSgNuz
	 JeCWEW//Jfl5osw6NZssDeV9zDDCpYXpMvL1YORr01lHhsdjsR1OcyQKXhox4us3XP
	 xbPAQ5qS87JrgMvFMZ+/Clu1YRDV3mcYpkiUZghMK9W9bAeGEFzZ+vYqDDcdE6mKM5
	 4L5HTBHkBWNNw==
Date: Mon, 26 Oct 2026 13:47:04 +0100
From: Gao Xiang <xiang@kernel.org>
To: "Gupta, Pankaj" <pankaj.gupta@amd.com>
Cc: Gao Xiang <xiang@kernel.org>, Muchun Song <muchun.song@linux.dev>,
	Jialiang Huang <huang-jl@deepseek.com>, lance.yang@linux.dev,
	baohua@kernel.org, damon@lists.linux.dev, david@kernel.org,
	kunwu.chan@gmail.com, lianux.mm@gmail.com, linux-mm@kvack.org,
	mst@redhat.com, ryncsn@gmail.com, sj@kernel.org,
	virtualization@lists.linux.dev, xueyuan.chen21@gmail.com,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [FYI] DAMON and virtio-balloon in DeepSeek's DSec paper
Message-ID: <at9LyF8xIIPKcLSD@MacBookPro>
References: <20260925054408.10431-1-lance.yang@linux.dev>
 <20260929123241.1408414-1-huang-jl@deepseek.com>
 <aruyFPzEe3pS_Qzx@XiangdeMacBook-Pro.local>
 <AA71E56E-F29A-44B2-B5A0-7806CD684B21@linux.dev>
 <ary5Nn9le4xG7_-N@MacBookPro>
 <CEE47F27-874B-486A-995F-E223249659FE@linux.dev>
 <arzlfSOgtC-CLoZt@MacBookPro>
 <8839b7e4-a830-4c88-9e7d-dd35757c5167@amd.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8839b7e4-a830-4c88-9e7d-dd35757c5167@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E7B13140006
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: q7kthhzp41gwk7wxb8zkfogddku5gsfo
X-HE-Tag: 1793018832-765322
X-HE-Meta: U2FsdGVkX1/8LLqW3UhxjiEH8pnhqv6hGRfrcoF+ZsOttkMfHUb/rFxRHpgbw0aTN3tachMKW7a7My92y3GU2L248nkDwLrVo//TGCxFa0tE9IMOcXss5ukjB5uS7iEG0NPdbHAgm3u4bqfaP8W73ceQq7Omk8PXkd/xO2bYbZIbmRICUlEcS9VFnYV4wpehxjQCkJlwmnPmSXNxenwJuldr4jxatZ6ImMQCUiPwLAlj2EpVfgCs7OOH3mdmHFJjAFf96C+2yZC6ROvXJpfSg9BFx2Z0pb+7MKGojdLGcIWxk9KFO+NhhKDDizy9rcRV/1KeXphewlQhGFyHlMa5e7k1HlImv8QJtDI1Pt0LRzp7LbbPpAXC/LYd7GHA4E+KuiFo0Sv4izg5cWIPMdmpgzs0wtaFnI/AoizrjW3vw61Sk6IMNjwDVfo2oj7kqiJbtg+jplS13iBo5xqEWwqbLK3ggX5wGr4zo3ufO4d5sv+vjcwmCKwtUuEOTcRqFc4nkTDBLXYH/OfhXxdf4T5lKc90a5IDPqVJHnKoxvegFzz3dp2RV0qL7ZEunQfeQhq0ZIMb9dNTJolgvseeQyN7Y3hdmk43+1T9LusYG0aUpxTaWZO1wzVTTPaScL7RrbUuwAY9mytlB71XvDtWfRwOPVzMaDC06gjcaHx6FoD0diU3jJY1cD6Vy+u/eJFL5BcsVKfARB2llc/gSJ2grHAWsscQTSFMfnQNaVif2kxhom2eIXG51YSkGratv8Cvs7oo6o58U1auilseeQOARfCA3BsG8HlMxwt+GEYV/TOnu4Ue0ih2L8Cgq2Z5GxiXo+OJ3BwPSwFYP7Gig4XK38/eYd5gxKUFc2EwGF5QAUYQtByRSY+StBoxBWLZXJIfmIxlKOnVa7ApPnn/8OcZf6AFl2gOKao2PrZQjStC3pIhXq+VVWRzlByWTGidKv88ruEqJfgR5OgUSvXDEg8cOdX
 MMJq5Q5j
 /OuDxgZ9sRz8asWiCLiIuLJe6oVpBtck/0pizc3iSbwMJt22M0uk0PxHYGvKfe5UppXMpUtwlt9WRtPgFUqfF9+nl86ENB6Ipf3kiYiiLnf7HGVRjmdIpn40uEQcctIifGcbHzG5+ZA0n+seDp0awpOvNUV1zyqnXGdLeDwTzI+5gXI8YaBNvYP84F4boETHCzPcUAOls3HymUBDXQwTTEDbJQOHkpIpbNCDwIhepHPkvcU8zCjWNm5nUJt+MJx54wVGLv0MRp2bI8o1lXfhUnIVe7YryeNgcZmCnNiFhbfZzC2E9eqhvs24GRQOxEDZ/+BYsDwuMYaZt1OEkcmU3p2lZelu2vQRuNi+EyTDuhcyELlDVsT2Xb+0sAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 01:35:44PM +0100, Gupta, Pankaj wrote:
> 
> > > > Anyway, it'd be better to get some numbers with RL or agent workloads
> > > > (especially the host memory is under reasonable pressure) before
> > > > landing all these new infras upstream if proceeding in this way.
> > > At least for now, as far as I'm concerned, I don't intend to land all the
> > > features mentioned here. The first thing I want to address is on-demand
> > > allocation of struct page.
> >  From my point of view, on-demend allocation of `struct page` for FSDAX
> > is indeed useful and can be landed upstream, mainly because `struct page`
> > initialization takes much long time for large FSDAX devices even a small
> > range is used, that impacts the guest startup time a lot.
> 
> Would on-demand allocation of 'struct page' from the device itself (a
> variant of the altmap case) solve this problem?
> 
> For virtio-pmem, since device memory is backed by host page cache. So, in
> the worst case host will provide memory for all the 'struct pages', but the
> guest itself won't OOM.
> 
> Just sharing this idea. Anything I am missing? It could be another
> optimization on top of Muchun's work.

I know virtio-pmem struct page can be allocated from the device itself.

But I don't think it changes too much, since guest kernel implementation
shouldn't imply anything of the host. So that the pmem and struct page
can be backed by anonymous memory or other types of memory, and it can
still cause unexpected large amount of memory on the host instead. But
allocating on the device is sightly better than allocate struct page in
the guest.

The problem is it's hard to make sure the on-demand allocation is always
successful since the guest knows nothing from the host, so that it
exposes security risks like denial-of-service or more.

If this security concern is not resolved (e.g. implement a reclaim path),
my thought is I think we shouldn't overcommit the struct page since it's
a functional defect if virtio-pmem is reasonably large.

Thanks,
Gao Xiang


> 
> Thanks,
> 
> Pankaj
> 
> > 
> > But in order to make it safe for production, I suggest reserve the
> > guest memory in advance for the worst cases of `struct page` at the first
> > stage, otherwise it could cause unexpected issues for many guest workloads:
> > it's hard to perdict if the guest memory is still enough, it's unfriendly
> > to system designers as well (that would completely based on their
> > experience and hard to ensure the service quality beforehand.)
> > 
> > Since the guest memory for `struct page` is touched on-demand, the memory
> > over-committing on the host is still workable, the memory reservation
> > can be removed after the reclaim path is done.
> 

