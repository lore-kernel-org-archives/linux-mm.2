Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BAD4C61DCB
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 08:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F3D46B0088; Sat, 29 Aug 2026 04:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB226B008A; Sat, 29 Aug 2026 04:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0BE6B008C; Sat, 29 Aug 2026 04:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5D06B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 04:49:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B6A8A40B9
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:49:26 +0000 (UTC)
X-FDA: 85153683132.20.C7FFEAF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4813D1A0003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:49:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VupjAuyC;
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787993365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcZd5qV9VBribsCJdVCEf9+lpTwexMZzlTrNX//b62A=;
	b=CUWcUPmadDVG2F/eo/VKffZ3Uh0VOUEg7A5liIo1Mnlu/TFJx2m/+lkTaMpfA28KS4VcF2
	kANOQa9c383InuMR+CpSUMKQ/f66l6Rcr8t+QHQ08tH/iqCfOktFyCQuxc/USkSLuBMb/V
	S+VWXbeM4T6s1+xSrcVZK1CJ2W2UiMY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787993365;
	b=wZjAwYjnLlKctbb64eIx09M4g8nIqERdiLenakbnBE62D7TkdDLw71IdND3bZtcv9BehO+
	SZZLegTHCvgkYKbIu33qeLxqlO4JtDl3jC8hg5OgozHnBVG/L6q6ExX1BIrXXxsDCI/tim
	5AM2Gd7TWOA1tY2fWaSnaL2wYWkfWhk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=VupjAuyC;
	spf=pass (imf19.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pcZd5qV9VBribsCJdVCEf9+lpTwexMZzlTrNX//b62A=; b=VupjAuyCvQhU3mbZf/BnGX6m2k
	VT1HVO1wyzdj8Xzv4lMNi8LnM6i3Up8WWM5CIgsDIOvMrhkuY02BLOGHTJvpEzChU0TT5DmwduTGX
	TfRA9u60b2spcFTxEI2vUr/erSyxfF6oBDiv27r0yLWz0AhNb5uZphuqZXr7rLX8ja1/nbYzjaEDf
	3V5RZCp8WRo6f4Yu1m9QybYjgref+K9HR4wP52/F8BfO3M25/wdh1omen9ZOjSAdE3+rqJzrjGNaW
	4i6bGcI/PkNjzTz0vZIkgzJXEJm6qXq2Rxl72Zpa26SHx6v/7Bu1hjGupGztYq6J9m2NVwZUVz5gf
	Z5n0oCiQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0EkI-0000000GDbC-1Te9;
	Sat, 29 Aug 2026 08:49:02 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id CABCD300382; Sat, 29 Aug 2026 10:49:01 +0200 (CEST)
Date: Sat, 29 Aug 2026 10:49:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Stevens <stevensd@google.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Clark Williams <clrkwllms@kernel.org>, suleiman@google.com,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org, linux-rt-devel@lists.linux.dev
Subject: Re: [RFC 06/10] Reclaim memory from blocked kernel stacks
Message-ID: <20260829084901.GA776954@noisy.programming.kicks-ass.net>
References: <20260827232948.2520558-1-stevensd@google.com>
 <20260827232948.2520558-7-stevensd@google.com>
 <20260828133620._x2XfJR_@linutronix.de>
 <20260828135947.GU776954@noisy.programming.kicks-ass.net>
 <CAOiLmNHrbXeTY7zoNodmaZUoMWf+NgvGvZ_LjfWD-1sKAoiLeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiLmNHrbXeTY7zoNodmaZUoMWf+NgvGvZ_LjfWD-1sKAoiLeQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4813D1A0003
X-Stat-Signature: g9wyoh8sbu131ybzwmfreeu7hz4d6k6i
X-HE-Tag: 1787993364-174741
X-HE-Meta: U2FsdGVkX1/m5k1P5NFVbEmII0EoSqmza0a8iX/bBh/xmapxIk6xnkxY9hWITCuRTWsLuVO72mZgov9KgRfUiwg75IWdWjK/RinMmjLV5dbirOsn2xFrCyZKlXKqRbgJSBKpHlesCKgkojtL6d7+XZ4XIo9r3SdL80Gt5zLx7WTXO7BcJfdN3BhKSDkUnm3neTfvmzWmKBB6YP77dO/Apz5AFh4yjlbgGxGUWE60wNiA9BhMUOmazus5vrWF99akVhfO1QkNeCcgwx+d50wyCGfuXh0ll1Z3GPUKf0iFvmTAzQc30Ta9PaixMLPkPbeV2DatPBAomVLg7emHBh/SAQeOx0ngQOBIGzIB1hAmlQldKCrEQJ/6XRghgDnRJSfDqDpqhtgtvQpaj4TN/qNx/QvAJoH4eNyQeQKq481wfyjqIumlxk/jSXtaHnt1AX5e3WWjiQoqREoAkK/oS/tcyocFTYZKAndFJ5bddZWCT4rsCgCyXuDLqfd9becGqN01xJRGQfFIsIo7YQolbjiEJleaR3JsRDFpLOSoii4WO7vA+cq5jdIMbu4OfuRKNbVhvWDcMrIN4lwXKdTtkkH15AUMIl1uWgI+z7lPMx8/cNupehVShcNKCG1vbCxohRwn2MfwEHJosjHo5Mrgr1hnyW93/oG7iy5n7ImeWW53v/pI3+oAoJp8R0fUUmVVjynLyyoaCNJef9U4QY9c9pTxyL8K9vclfk60gkjTTv7VbYOu1AvwQVzT5fh3Lw9X+fgoL55zk0k/TWLCZ7xCMq+xcvm4U9AGigzdj+WNYZufM8WuoRd2DsfIN1Mx90bWKdZEAo16dZYmF7l648DEa7uIvO7fTS+TzGQtKa8NzVZKxHwTPIv2EE6MxQbnJkm1R2hINf6ll1QvMT7Env1khYtOpVsXHUJO1Y+sOuSBDBGIk2CjUpEcz9CONUiidqn8lGYhS5W32Z1AWNrKh9Np3Tm
 l72D2maU
 8BpnBOIFg9q+yw1M6ss89nQ8pDHSWi4lAyFQGRaHJ+9LVAGYMKF7XlBXmJIe2u3R+MqeWOqo228Tq1AVPlvVJZkPybifLCzjwdKV4ATDvbUilqPNlOYmdQIbM3cX7aWiK30FFgHJnY3isfXckRPRCGcCmCewBSq671Z08fA+mfyrOEE91G+FFeDDzEhhymbQ2qdQB/9iErBPl8Vc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 01:50:05PM -0700, David Stevens wrote:

> > It should have. They're taking spinlock inside raw_spinlock and lockdep
> > should very much warn about that by default.
> 
> It does trylocks on spinlocks and local locks, inside of
> alloc_pages_nolock_noprof(). Lockdep considers that safe.

Argh, that alloc_pages_nolock thing is a horror show.

> On PREEMPT_RT, it is necessary to skip the call to
> alloc_pages_nolock_noprof() from under pi_lock, since with that
> configuration spin_trylock can end up needing to take pi_lock. But at
> least on !PREEMPT_RT, there is no risk of deadlock.

Yeah, which puts the lie to that horrific hack Alexei did. We should
probably teach lockdep about spin_trylock() not being safe and see the
house of cards crumble.

