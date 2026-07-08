Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1CAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 00:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 989836B0098; Tue,  7 Jul 2026 20:39:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961756B009B; Tue,  7 Jul 2026 20:39:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876CF6B009D; Tue,  7 Jul 2026 20:39:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD606B0098
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 20:39:15 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFE6A8F9EA
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:39:14 +0000 (UTC)
X-FDA: 84963750228.01.AE816FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1F65D20002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 00:39:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PMLYnBck;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783471153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4CgDDH0T+lc2+cqqsojHNN2donJ8E/B1iuCKi3ersE=;
	b=5a7gVsfhTlDgWq/sUHi+7jgiRIlxy0frIkVuhW04GFyoXmNXDT1Fo7PbLZ3+DpcbxgItU4
	TelLFPffK45VduqZ2YRWpo3AZ1r3PnCfLC5spo10g1ji0G8gPHVTyhjS59CYRmVHqZuzoS
	To0tlpWb2quQ3U0AGMZPzDeAqFTu2XE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=PMLYnBck;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783471153;
	b=FJDgAyB1ethynG//G2eYLu2popt9QtRiQziB3P0rivCkltJyKvQr51378BjsvXFbiNJLuG
	YnYywJtifM/Ki2A9S1n9mL8wpOaWmrlR2TcYFNqzXlHhFmYsXuZLCTMA3eneiSQKUhVCUy
	qoRE9Y+CqDDPygcCvyAo7jSZcS3invM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 078B140837;
	Wed,  8 Jul 2026 00:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F711F000E9;
	Wed,  8 Jul 2026 00:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783471150;
	bh=c4CgDDH0T+lc2+cqqsojHNN2donJ8E/B1iuCKi3ersE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PMLYnBckOyOxWyHnorntM5OPjF0Y69PuWAmCxrTZVexXDDCsFkOsO/pL85IfE6iNG
	 8/5kvbI/7keXx0Wb/7jE4w+1BCOJGLBotSAoDtfAMboRg+6E4IjL/MlknKQKebHYug
	 swD/3codZcOlkiCXdoFUL9TpQ/inL6o0IZmsZgks=
Date: Tue, 7 Jul 2026 17:39:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hajime Tazaki <thehajime@gmail.com>
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, jannh@google.com,
 pfalcato@suse.de, linux-mm@kvack.org, geert@linux-m68k.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mm: nommu: fix the error path when
 vma_iter_prealloc() fails
Message-Id: <20260707173910.928c74a7e4dc8a1fdfddae3d@linux-foundation.org>
In-Reply-To: <20260707235137.498738-1-thehajime@gmail.com>
References: <20260707235137.498738-1-thehajime@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1F65D20002
X-Stat-Signature: yrxq4zzqm9crnyxfon4ymregomke6rwi
X-HE-Tag: 1783471151-260038
X-HE-Meta: U2FsdGVkX1/elkN4E/MJkgdvUWo9N89Ib5u2sQiTlB3xnwWJkn2JEOd9Eo5qwnjnIQc0736OHiDDZFxMDXqg4vNVBdsArlZ8oMFu4AvcZfH8sD/FMkmOv9VfK43/hgfs0qRtu8U32/mDJLYA16BOD1tqDI2acpwA06DHZcs1j8WIUO1/Z+vvlppfDVEtv64XhvtjU+qeelfFZcSm1+DY17IgDvuaL/qnter6PVgRCR1ExIsVRwO1MIoJ9hYYKfHGEzISMtMGetHt4h+ATzh7sR8SX0XTSioKWNU4xT92SEqJSCl/kyUxfBag6qGoI+Nj4EyMd8zq9N47mUWM6lHykZAIaNOcn2Z0COJlQa5mPrjmB/VCKD3fqbzsRnFPWWw8uHniMSFvyg1X+FynU28ZXH5XqoV/GJM+ya8w8AJiwdGY3Jr18R0072UVfybgRlAiGXnC0CgNal0wQHSFEilm5R8w+KeW4GYoSbFMwhowCzwkFs2VHleA8JF+g6svwOQuBdt8Z4wd7NWKXD+nt8WLJj7e1zfP+DSJmEwneVd/E0arxQZd/C7ZxJ7DqZbyZZDLRYmNsACxBrGkd0PCTraei4JhcJyM6UeT6STYYvgleUoyoiKnM2dQKefH07/muZtDRxrt4s8tossqNhj3v6U12fBbRp2Hs9zhGhpp92RKze5ZBU0ckXUb2aicwPQN2jgAgoj8oFl5RdU02iXDQPn6SBaGIBTj6t/AgnaYXZBr69OdByMfDbEJQPdwepGwK6RYrfJ9E0NPaC4MJdgYvx0HdfcAjuXC+ivj/7gIwXP8/zwY3qUn+/Z01SqPMMw088HwM6nNmzoevVTWviypT1D5201yrHaVewG8jyC5aJSQFbgMQUmmg/7MpJJoC6lX9KBrL2pgcZ+UPVb5cRGazryVStbxY1hwzF9pOafAggVVYTNZIAT9P6Eu4q0bkOUksSuoPnQhztB6KSYYvuDx0Es
 2cqom4JB
 l9jvbtUpO8c7CV2uvreJGhiM5VKkCCRkUTLnIb0UjI+jl9DLDOS9LSk116lG3kkjXITSkUUuYH/8tBDZJRNgb2P8pUZ9upp095FnugyzxQPWfx/yt9K2vWg9s+WlLPzEMIkty625LEVtlbTDGiVTqqx9xKxSthhj0YfmK8Kwc7GRXTZK9B+pBDbIeHtFcWi/8M9clPggftWl+i0PHroPTLaDET+nOHR7t333lKDVU9M4SX56czti9cwvK59f+EBvDegfZLXc9hL9yh4mginPvv0sIirkKj3nMY8X4FzwTeL0MQMrMank7EmKDDUy7SC4CREpNr8qopJQ+3oekrC1Fgv0e5P2RkM/2BTA1zmp7HPDPtjwbYDyxY4y4vBWXmqCviiJe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  8 Jul 2026 08:51:36 +0900 Hajime Tazaki <thehajime@gmail.com> wrote:

> When vma_iter_prealloc() fails in do_mmap(), it jumps to error_just_free
> without updating ret to -ENOMEM, meaning do_mmap() will return 0 on
> failure.
> 
> Additionally, this error path unconditionally frees the region struct.
> Since the region was already added to the global nommu_region_tree via
> add_nommu_region(), leaving it makes a potential dangling pointer in
> the tree and may cause a use-after-free on the next tree walk.
> 
> This commit fixes those issues by introducing new jump
> label, error_vma_iter_prealloc, to correctly handle the error case of
> vma_iter_prealloc(), and move the region updates after the place that
> the allocation is finished.
> 
> Those issues are discovered by Sashiko, linked below.

Thanks.  Now I'm wondering if you regret opening this can of worms ;)

	https://sashiko.dev/#/patchset/20260707235137.498738-1-thehajime@gmail.com

afaict, all these issues pertain to failures from vma_iter_prealloc().

