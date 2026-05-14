Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2BDCD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1867C6B0088; Thu, 14 May 2026 04:40:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 136D56B0092; Thu, 14 May 2026 04:40:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0744B6B0093; Thu, 14 May 2026 04:40:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E810D6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:40:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8DFD8C0110
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:40:28 +0000 (UTC)
X-FDA: 84765378936.15.6593798
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F2FF4000A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:40:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r0otTCZv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778748026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/pH5uEoZQwt6RlFP9VMsKY2dxNsBMCy8toEtQrZFkg8=;
	b=v3RT674xPWW5ayjBt87N5nWxqEWV4oGiQAjdPra+vCGu72R1ep8O4/hzbCVqCguqEpaoue
	W/o2gieWGopLyjOpiVm/1HtQsDIPXQSZWNODoyva90CnFoLIl1x6ElX4wzPi+L91/bjdoo
	cvmVcAD3q2fJSwID+qT7nlNR0xefs9s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778748026; a=rsa-sha256;
	cv=none;
	b=r/mwhdYBsEtp9lyExga15jSlUm8vqDmhmNuPG8H5wWTsmKb2LIEeye+OZev3zPz5WGnueP
	XSO1Yq1ZJKLip+8f6oEeEggkxYk5a/d96G/XjAVOxg8G72h2ClMEUGlBzxlAZjURg+R1Oz
	wO0v/oBsBUXZWYh9GSZSCCTLlVbOKiE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r0otTCZv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
Date: Thu, 14 May 2026 16:40:18 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778748024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/pH5uEoZQwt6RlFP9VMsKY2dxNsBMCy8toEtQrZFkg8=;
	b=r0otTCZv+ToFCTCTHd6z/r69gvYJ2V6m4G5thhCGZaQuM1ZKBI4oszFw5XZDj4xBXcH4Au
	Rl7NJZl0B6KSa44ZSlftZ28VPeLLi4lz8qfPmrbf1x3AG2K2fNYQO+aJnsJNnFDYrkxghk
	LYa+BMi432Uf2KJr2B7amtXeZWyw5jk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <agWKchF7FVvv_FYO@MiWiFi-R3L-srv>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-3-baoquan.he@linux.dev>
 <CAMgjq7Ap=hEmHg+5Da=NdOQS1JK1FY+WepmW=3HEC4XHfsUmuw@mail.gmail.com>
 <agUuEizORebR3A0O@MiWiFi-R3L-srv>
 <CAMgjq7BsajR=cBqZWyMovjAWgV9-WDq-ubzXUHO1Puvug6n9=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7BsajR=cBqZWyMovjAWgV9-WDq-ubzXUHO1Puvug6n9=g@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9F2FF4000A
X-Stat-Signature: 4kkqjapjxhwz57jndgo3qteq8jqetgon
X-Rspam-User: 
X-HE-Tag: 1778748026-914297
X-HE-Meta: U2FsdGVkX18d8+jP4Zu1aH3D8dqWIZO/9aJV2unejtvthRV3cB/7KGa0Rm55uWWAb8sboSQqTbHCfLw85bbsFMRE9s0u65es4gGC16Bv472R8qJ2IPQmQm7L8dQqr08WbYK18/FwSzbqGY3OxaW0o7crfA13CGvsG8mtUXtgmtmWRhsT66ldqZstl6+7jQQEc2PYZg2/QBogrdUyRlz9rDA9ct9aP+umaHdWrjO4evnUWZNhT6TXHJ1uT84UbKdj/12csifaHlCUqNnUi/ucmUwcUauJcGHEbOmvHzsFfKEXiRIcgShn2WHQDRO0wMjASq1SiScmRD1Vo8BR+81P4f3yiSyiJhSpt2A07ogtMy4T3dZ5PwnjEAJfIKz0ud6AsbmUNGcCwpgMaZS5wrKfLkvAUFkbuMEIBOusC5TIXb70QIbgXf6oqTx13jeXPjehWEuBpMkVg41Av5C7ksr4+hNYvcAO97hGfcEVZX8NeB3bRIbVAhng4GCgwX/+fm1Lds6sIgwou0RIUy1OvHltIjuGUdQnyH4BBXr+RoXllwkBLKNafplg6ULMmBZFAR255pE49MraeXhyBh9W2cVqRCl4ynIYwe+zp3COB3QtalIBU3m1cckgsJ+wn5vGUctAjqAqn40nX9+mEZ5/qmrHSNq+G1yCnjbEpWYVwlhLh0Xe7q7xX5cRG4minmxKkfraiDc/CQ5iQ213j3jakExEqGe0dSHdCbeDlpzSDhoK6MLvuc6k+nSo9mPgytAkirpfD1gidUBtu927ANnKhbQiihdGWCYiComAQ+4FSdW5SwbRUGj+4AQq3/mQQ4jzPOmID0A34s5B6cEBI4+vsC7izSoYmNiqBxM2AHaoE3NDAJSYVxPlGfYtlo7aralW+Ljh8wkCJiXWcozwJinfSUNmaD6lzXtFtaM/VPJUtDM4z/PjilUI8tBmiyHiRINIh7XDBvuLRTdR/RxcqQvX2Sj
 O+A6jbqK
 76S0orHv5lIGlGfb3OfMVF6M9wwMqwMEIJFBwTGyMRy9PRws21tYvBtFNjT0fiZXFsvC3/Ix9/DhAlnPawpXpo4IHKUE/R3PuVnJqLM3DGbe/ab44iq68mxj8qBfCYy62lJmMH3TTEqB+UYvo0ifG+2sZuPuFPHYYQJOoMw241AodmG/WmbPR4k+xuUyG9ArrqfQ1WfNiEDw8XZHO6pZhIC//4Hhlf/JyHmpuCF8B8/dpf2/QtqZhodN2cw9YQNPmgTsKz7VJhQcB0a5bdTSZk8kKNj7JBIo3rkyhvr/kUMt0uz7Ti9iIm01Ta09Y5kvSjz6f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/14/26 at 02:41pm, Kairui Song wrote:
> On Thu, May 14, 2026 at 10:06 AM Baoquan He <baoquan.he@linux.dev> wrote:
> >
> > On 05/13/26 at 01:53am, Kairui Song wrote:
> > > On Tue, May 12, 2026 at 6:50 PM Baoquan He <baoquan.he@linux.dev> wrote:
......snip...
> > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > index 4840fd40f36f..8c42632e6765 100644
> > > > --- a/mm/swapfile.c
> > > > +++ b/mm/swapfile.c
> > > > @@ -3780,6 +3780,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
> > > >                 goto free_swap_zswap;
> > > >         }
> > > >
> > > > +       /*
> > > > +        * init_swap_ops() sets si->ops based on flags. It does not need
> > > > +        * swapon_mutex, and must complete before enable_swap_info()
> > > > +        * exposes the device.
> > > > +        */
> > > > +       error = init_swap_ops(si);
> > > > +       if (error)
> > > > +               goto bad_swap_unlock_inode;
> > >
> > > I checked the comment above previously and it looked good. But the
> > > error label seems not that correct after double check. inode->i_flags
> > > will keep the S_SWAPFILE flag. Maybe something like add a
> > > inode->i_flags &= ~S_SWAPFILE here and goto free_swap_zswap. Sorry I
> > > didn't check this part carefully last time.
> >
> > Right. How about moving it zswap_swapon() because it only relies on
> > si->flags setting currently?
> 
> You mean before zswap_swapon()? Then that sounds good to me.

Yeah, just before zswap_swapon(). I missed a word.


