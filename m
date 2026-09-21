Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53802C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 06:45:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03AFE6B0099; Mon, 21 Sep 2026 02:45:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2D6D6B00D5; Mon, 21 Sep 2026 02:45:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43856B00DD; Mon, 21 Sep 2026 02:45:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BFB846B0099
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 02:45:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51D4AA058F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:45:19 +0000 (UTC)
X-FDA: 85236832758.25.4AA1E9D
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 20935100013
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 06:45:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gsApuN5X;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789973117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jX6sVQRHNCOva38SLpuRbLYnjEXCSh622qrdMubF2Q=;
	b=rIcvq7afq/FNTYgE8JH+p/bTebLXEkFgAf8B3+Dh1lixM3EJzHnan3Ej1nsyHVO1KJ7a/I
	pPik9ql80q3Xun26oqCTgVjFQtFrjfhupzXHACay0Az0lJ9PQLrbADASDGpWZrElKEixIL
	eSzE/A9kDe5kw6PWG7R6oPrQ4cCT3NI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789973117;
	b=F3B/0xlCsjThDVo4yIV2bEM/ByHoAI8Cn5DA5c8D+HduyfNdSEJvWY9xvfsQsViHS94sLi
	sMLIQtqKc72973IO9Ob5yQ7DN1EK8z1/mUZTdrEgU2Y/aO7KgzGhjc5saEkNTa3B6MCy6H
	HLnum3zU46L0R6R6lSWDd4NTkHECYEw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gsApuN5X;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+CtmSrDeMQxTmoIXkXwfUTofjVqxOZqb3/0Dtxr5+Cs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789973115; v=1; x=1790577915;
 b=gsApuN5X9tDFsVN3PfM0EhVnzDFXn8cc5e7EWYq3q8f1pcv0LtveCVdhyIDfl4wEWMErY59G
 783yYGZ/x102DDjta6oUxf+wksQ8E5dwIB5vXKG5cfvMC5jtAyAm5M9XSmF5EZk54pzgBAzMlDL
 UCKoqryOkYYFBCL/aRo2QY2M=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8a4228e43e0fc90c;
	Mon, 21 Sep 2026 06:45:14 +0000
X-Mizu-Trace-ID: 8a4228e43e0fc90c
X-Migadu-Flow: FLOW_OUT
Date: Mon, 21 Sep 2026 14:45:09 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	baohua@kernel.org, youngjun.park@lge.com, hannes@cmpxchg.org,
	yosry@kernel.org, shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev, david@kernel.org,
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Subject: Re: [PATCH v3 00/14] mm, swap: extendable swap devices (xswap)
Message-ID: <arDSdRDF9CnHjkE0@fedora>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
 <CAKEwX=PEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62VMTzedg1oYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKEwX=PEEkYiNRaVhCuM4E6mxB9huPKfkDa4m62VMTzedg1oYw@mail.gmail.com>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ymp6kiygg1txq14tt3ggezr3d8wftodi
X-Rspamd-Queue-Id: 20935100013
X-HE-Tag: 1789973116-690530
X-HE-Meta: U2FsdGVkX191pxFL6XO1r9szUtZP9sfAuWQoPUBGQP8EjzygD3H5Yk5tSddACwwm019rBgSWYeuB5rDIobdGtVLrI73SGLbSDF7tRAwo0K5tccHf9MqiBNWzx0PeGAU92b814pVmL+rhdfc8DPXI8vy4LJ05myE0xZckMhwTPK4sV/YUPOYeAqc5HDDxPAOda3mda6YpRB5uF4hRYW8vt8bDfb2keVzMrYl98cci6AuezXILZ6LpRrgpI9oLaZUF7KZkmbYf+YZB61TDdudcGRhtdc7cF8SGGQbj6MaRGK9l6zaSJnzXQ8d76rEghb972DGvTmRkaQ+WoxbFEdE42ROz3emrZKcQ2DsBhqY2kFza4vRiI+p5Oj2FnBjJz0OzDPIGrEeMmL2ns0dG22CEU9eJ/5ZyNPb7FZa8rkSV5KHprdbSMlz3ityiL2s4A5YgUmAAVZsNQxOQpzzCBmArPVuQ7aL1JgqPdcN8Wu8miFaMxkR51q2tnwpSu8NHhdyO2sDctgij5IfGmpPiqKlzS4Ubo5tKCMdkx5PABJcL9dMEeTVyFZg799RkIvsyWOxeqXWQ+wSFCu7ZdpmZOj4UIFijBDWtONAG+z0491X6hB6KsMtSKXAV2YaUxxgqLSsSRTx6etHd9WjYQ8pLrn1QJP/duIJp4uEXG2Fkq3UafUWYhk6KpuX3ewUHSAY6ulhOAN3Pt772kt5NTEBYePUB4ZZwCnt1XXyU8ZfJF3poC/NrBSTPh/guvm8FhywB3BySlAlVa7LbrEFb82cqgf8Vz9+yBfyj6VXJw/qFnm06yG7o2GHMuXOOGdPquB/GfVXTZPBOWd8fgF61bJ1w5wOHcRCYgj+r/pzyrXuIyNneStMCKKGtwpgrPdTdDGhS+RONYHibcW/XQwkawClLofvBcGJqsbDIzkeqlRgZ0GJSjXOEERilo1TOTfdyHMXZEr/TCQjphiPjJ915Bgm7Erb
 IsEfDG3f
 T2LdJ/WX9Wf7wnwPOaqhKyn/AhJBm0jo1K4iV8UGE+gwlaQL0EnMGgpDoWWac/Q5w3wkgbhsrzBDLi67FRgP9WuxHJkA3MC61xCRXJk5ommUrx787OuOOt0AzvTeuK+EdJ6el+3vEHgAPYNDPMBeFwXWPzLKlrev2BFE19jxcIco8HldxZohgVAl1BvqkNE/lehacxrGgFRjGIs/ORyk+1YLWiXUbiJksCNmdVFSwZS+eCkAVOzKAX5tfTtsUuXmKi1h74cO3Ifo+PQnwfvSMGgTTs3HFvFD4bvIAy3JMZ16QSXr7czsySwvP4lTkLGurGbtaH5bURCNzk9ID3e1Y10WOqbBr0YEcUAupHwX31zkhzquqmBDSEMtH/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/17/26 at 05:13pm, Nhat Pham wrote:
> On Wed, Sep 16, 2026 at 3:19 AM Baoquan He <hebaoquan@kylinos.cn> wrote:
> >
> > xswap is a swap device with no backing storage. Swapped-out pages live
> > in zswap. Its cluster_info[] array lives in a VM_SPARSE vmalloc area,
> > and the area is grown and shrunk on demand as swap usage changes.
> >
> > The problem being solved is the static size of compressed swap. Both
> > zram and zswap need the size fixed in advance, and neither gives memory
> > back when the workload shrinks. The solution should be a device whose
> > size can scale up/down as per usage. xswap does that by mapping the
> > metadata lazily instead of reserving it for the whole range.
> >
> > Design
> > ------
> > - si->cluster_info[] stays a plain array. Access is still
> >   &si->cluster_info[offset / SWAPFILE_CLUSTER]: no per-access branch, no
> >   RCU discipline, no tear-down state machine, no NULL return.
> > - Only an initial chunk is mapped at creation. The rest of the address
> >   space is reserved, not allocated, so an idle device costs nothing.
> > - Growth is driven by allocation. When no free cluster is left and the
> >   address space has room, the next chunk is mapped and added to the free
> >   list. No userspace involvement.
> > - Shrink is driven by frees. The free tail is scanned, and whole chunks
> >   are unmapped once the mapped range is at most half in use and several
> >   chunks can go. One chunk is left mapped as slack, so the next
> >   allocation does not map it straight back. A ceiling lowered below the
> >   mapped range skips the half-in-use rule and is enforced at once.
> >
> > Size
> > ----
> > A device starts at 1xRAM, rounded down to the cluster. That costs
> > nothing, because the mapping is lazy. The underlying address space is
> > 2xRAM. An optional per-device cap,
> > /sys/kernel/mm/xswap/type<N>/limit, lets an admin lower the ceiling;
> > the excess is unmapped right away. Grow and shrink both work without
> > it. Creating a device requires zswap.
> >
> > Interface
> > ---------
> >   /sys/kernel/mm/xswap/create           write an optional priority
> >   /sys/kernel/mm/xswap/destroy          write a swap type
> >   /sys/kernel/mm/xswap/type<N>/limit    read/write, in pages
> > The device shows up in /proc/swaps as xswap<N>.
> >
> > Note
> > ----
> > Writeback, rmap lookup, etc. are consumers of this base. I have a
> > writeback prototype on top of this base and will post it as a reference.
> 
> Thanks for posting v3.
> 
> I spent a while building the other half of what I want out of this on
> top of your series, to see how much work is needed if we are to expand
> from xswap to cover the vswap use case.
> 
> It is actually way more work than I anticipated. And a lot of it is
> because of the way you indiscriminately apply the full swap device
> model to xswap, without careful consideration of actual use cases.

Don't worry, I have made a RFC to support xswap writeback, rmap, thp,
charging, etc. You can take it over and make it formal to post if you
decide to join to work together.


