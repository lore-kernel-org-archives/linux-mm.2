Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0126CC87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 14:27:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 819506B007B; Fri,  1 Aug 2025 10:27:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA1A6B0088; Fri,  1 Aug 2025 10:27:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DFC86B0092; Fri,  1 Aug 2025 10:27:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C05B6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 10:27:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F32E1A013C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:27:55 +0000 (UTC)
X-FDA: 83728417710.30.A7A7E18
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id E97184000A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 14:27:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MovCda1N
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754058473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2niHCOcwq+zbzb20ruruwzEAGjKixH0AspeRyeQ+SA0=;
	b=glAeYN4Ll2JBssYVBaaL4uQzEU+2jzOTJjKepg0viaWzetNz9dUd2e8bO2uEOrZqI3U3gn
	Q3qZrY/o45itrvejfekD6Q+USYpTdwKzE7JK+86B6TivtNXVbCzEj0ad055kEbrx9He9Ws
	UwNYYzGf4dowGbaJT/72Sk0Y7//QS+g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754058473; a=rsa-sha256;
	cv=none;
	b=haJvlnKiy2pcJViI2q6ROhdA61trrAX9GsDI93Rtevs6UQYrQPmNuPvqpYbQBnNX9LAL9C
	+iehobxNc2jVml/DepnlFt5JtduMbuiARGXVFNPcpOdEpkENtYK1a3hIC5ebGGLmoGpg91
	guyh8eLz5H/fKH/1IUd/lewGDIIR+pE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=MovCda1N;
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2niHCOcwq+zbzb20ruruwzEAGjKixH0AspeRyeQ+SA0=; b=MovCda1NfTQ/Q7hzhx5jdF6Sct
	SE6I5qvI6L8PcGigSTEcvQOUdyBsjh6GLIk5/byOmaN6v/EcN8v2ZRzXg5EJMEVd+nNrBswefaAWN
	tSi5a8CPPfz068vi7qoVFfcH8RQtA/ZCXOTbfznHxchFyT0KqtIgkKZoFIG2gMUs3IdJepOS/KKqc
	WVZ+9u2SKZbE6Xsr79AR9RvlOyJI+kOK2ZUpMT5mPQcvVkkJAw7sVcNGLN5dUTN8dSbSzScJrkM4p
	HzgRmJCFBCIGnP8cOw4mu1XLCVipnwmlia+RNh/VOY5VSd1us2uTTPlKFA9PS3OvNLpPBdcbwL3zr
	QWAWuUQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uhqjY-0000000Ff0X-3Tl3;
	Fri, 01 Aug 2025 14:27:44 +0000
Date: Fri, 1 Aug 2025 15:27:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, linux-mm@kvack.org,
	Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 3/4] mm: Support only one page_type per page
Message-ID: <aIzO4OLr1GPK2RMm@casper.infradead.org>
References: <20240821173914.2270383-1-willy@infradead.org>
 <20240821173914.2270383-4-willy@infradead.org>
 <2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com>
 <aIwp48CTft68fssD@casper.infradead.org>
 <6feb2506-aaa6-479f-a7e3-b4503b7d6ffc@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6feb2506-aaa6-479f-a7e3-b4503b7d6ffc@huawei.com>
X-Stat-Signature: n6sof77b71mcjh8oe5uffcggxem539w1
X-Rspamd-Queue-Id: E97184000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754058472-2528
X-HE-Meta: U2FsdGVkX1+bd/Y7+b1LtEtHCcUsagkJ2NdfE0Skqsz7G0jLmk97mUKZ+N2b4A2a84I3BuGwN8sTzvqJCYAnERmX+vZuTMgHfols837mMiTn8/j0JNX39MkyXZNXW5w36f40fPuKUmqw88zd/OUQaNVW13MbN+pEfKn+MtAd03EcaY4VS/4iff0SlpCnpLVhQH9MooHwmXASiTYvTh8bEo1JMQWA3OwmHUN0lqI5cMXsAWFF0BzOZbbiAK2N7k2mmZNDz/8qN+Pi+Qyci1MTcRheqcG4vApgbHxiCoiI4pFvBdzUtKwzRKY22DUw78E4IjH6nXSEpjsKhVxu0RbutLHeg6cw1r9VsW4Uy5RW2jflLXl/v76kvaZHZ7wsE5zbJmX2HEuN84zOU66mbdjxyKA0snUioF/VBG3E/dzxcE4z0wImGo8V2gz202SR04AKJ8lBLAKDiXtYusIrdiUyxQRk8vuFfigTRZXF5bsbzz56C4njhBfZX1BNAkFO3bFWyt9QuhtV0nNDnqGbg1XVia3DQatpeOLHl7jSGyV+VDEfqD5TsoGtVccWR9c8lX8kIpfU/K7qBG1h7rEgWJtcaL83baU86+lNymb2FP6+83PnY5k/WteP8OuNfNn7ejHyKrd1E/OZ/S0jG1wLL4SzjBFxV6c2Ypea7LUEgQI7mHUPvgNV20my6O5syBvbK3ILngWg3iVbOD3d9rH7sFt7MOqa4UW9rdhcmkit6pdyLRJaTDqP8jVvG51K3kg3MeCkBl3T+NufK2268N/8sxewxjSvcfpKtvYPWWR9gYMksSuoCaTNVSbehgSHElLM0Y3dLpagAR0mDfwkZvbUPdspRirZnVxS22tx+aPGT9HlnLnh3XAJwTZ79hpouO1039dBlBPWSMgxB2MIlytYlyoedj/2n2g2CbnIiShD7UPY5YYn8Pp4v2r2tSysdw64KVBTHgWJsu0mrkujUzCmzB0
 AG7bv+hN
 h8RLJVH0ac2ja8izoYyUHo5igf9ne+cXU/qSSVVxpWZZbJZ3QbxNAjVTj2MXDJ0qrP7PxjCHO+EEYSBPgRtptcwH6G3M+UHKO1YJoX4hHlDmuVSkTyZb1bua19Lxcsqy/mgcSmCAOR5svydALLsNaUYnCUtPR2vbDghKkYSSmy7pS+pBKVB1HaieTROqyUnm8mU1cudqSEIcZ1HjToJlwgMn6atN7lf2S2xMHUmTAv8ptDCUz+RP6p95OYHhZVq6SmvmL1l/g5a2iUu+fONIWCslrf4c+UzzhpvfO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 01, 2025 at 04:13:33PM +0800, Kefeng Wang wrote:
> On 2025/8/1 10:43, Matthew Wilcox wrote:
> > On Wed, Aug 28, 2024 at 11:35:28AM +0800, Kefeng Wang wrote:
> > > There are some UBSAN warning about  __folio_set_##fname/__SetPage##uname,
> > > 
> > > UBSAN: shift-out-of-bounds in ../include/linux/page-flags.h:998:1
> > > left shift of 240 by 24 places cannot be represented in type 'int'
> > 
> > I can't reproduce this.  I know Andrew merged this patch in, but I
> > tried backing it out and enabling UBSAN and it doesn't show up for me.
> > Relevant part of .config:
> > 
> > CONFIG_ARCH_HAS_UBSAN=y
> > CONFIG_UBSAN=y
> > CONFIG_UBSAN_TRAP=y
> > CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
> > CONFIG_UBSAN_BOUNDS=y
> > CONFIG_UBSAN_BOUNDS_STRICT=y
> > CONFIG_UBSAN_SHIFT=y
> > # CONFIG_UBSAN_DIV_ZERO is not set
> > CONFIG_UBSAN_BOOL=y
> > CONFIG_UBSAN_ENUM=y
> > # CONFIG_TEST_UBSAN is not set
> > 
> > (I tried CONFIG_UBSAN_TRAP both on and off)
> 
> Hi Matthrew, I work on arm64, so the above OOB should occur on arm64,
> I remember the OOB appears on linux-next, but I tried last kernel and
> some old kernel version, but can't reproduce this too, it was too long ago,
> maybe gcc version related or some other changes...

Yes, I can't reproduce it either with an arm64 build.  I'll ignore this
issue in my refactoring, and if it pops up again, we'll deal with it.

