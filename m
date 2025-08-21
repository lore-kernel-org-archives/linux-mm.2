Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9541CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 21:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FED08E0061; Thu, 21 Aug 2025 17:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0208E0056; Thu, 21 Aug 2025 17:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F08BF8E0061; Thu, 21 Aug 2025 17:36:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DEB028E0056
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:36:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A37A259804
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:36:34 +0000 (UTC)
X-FDA: 83802073908.07.C76A777
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf23.hostedemail.com (Postfix) with ESMTP id 129DC140004
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 21:36:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OA5Y7U67;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755812193; a=rsa-sha256;
	cv=none;
	b=j/ZUD4ZuwOetdiksDnZPUvgwUw0e17OR8jxfceigg+STltjwNi20/H6Ws3pnEHyYCC96z/
	0AyctSu4cplWNoajFgAVfQY4nvSCP+6NkQf5berQhw9GiPiFDfxWpzihvQ/Ed4eHHctPJ2
	xnIXSp8LCUvRVab1eOWt6CllaFwvanc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OA5Y7U67;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755812193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfq/5ouYbA21qNaiw/W7Tt+5iH0N1vba96yvvBQvgQ8=;
	b=Vs5GUoNaxpMZdNVFTqCD12vxUvPit7YW/yRg2KyHXlj8xYlc6pOdCD+mQuoc/+ghPkcxDf
	SGd2FfJdqossnP1jz5W9EGHyAlBiHVU4ysSAO0fJ/uGiPaOoDXRsLrZxIoCZgsDA2YH6xZ
	xE/YqeW6qt2mf9b+nYug5c23/CSznPw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 6132AA56031;
	Thu, 21 Aug 2025 21:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2174C4CEEB;
	Thu, 21 Aug 2025 21:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755812192;
	bh=0ZrNqJZT2DaYZRgAJFFOa0xEYOpeRsDeFYBL6NuqxbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OA5Y7U673iMYZhUvNnMwFvQkUXKn9V2phc6Jy4na7rPmNy5W3Cb2nWXmb48SIC4/R
	 58wj17tMqHDq8VqLwvpKsRy940cBsvi96EJ+Z0VV8m9eiykR/GEkkbVXNgSRhhDgjf
	 esn/3gfCBl+giswZXHMhbrsiqEykeIdeLApqKrysRKVEBspeqtWcl3m19sqw+f9VZm
	 zDW8xM76bYQgSwop1GDGxe0VZRpOeZM6xO7ZBUY8RUuBFti0WPTgr4aPz5ik2TM4gS
	 Qakin0sXw1RQISlrvvR1RQiDME2JWDB2CvkXdF49ZbtSEfLQBg/j1yiId9nPVEetyI
	 fjIUeT8fWu7Hw==
From: SeongJae Park <sj@kernel.org>
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	Barry Song <21cnbao@gmail.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu, 21 Aug 2025 14:36:30 -0700
Message-Id: <20250821213630.1771-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAF8kJuM++mc5PjcN_bxjZjbByT7QpVdOqRQte=vGJnuQxSTVfw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 129DC140004
X-Stat-Signature: 5s4bzdzdxpjzz9fukaybm5t51oqsoc1a
X-Rspam-User: 
X-HE-Tag: 1755812192-3406
X-HE-Meta: U2FsdGVkX19v5Bv7Oe6kTBfmvmkg8yGAMTO8kCVcbuaTrBYfrz3exaENnrn6Sf1xEH0njLa4OvaMX111KQX3dm+K5ud6GZh9XoRRdBfEyAZlcgaJhjdePFE4fn9D5tzM5IlMp0PbS2j/cuZLKklhlTYE1NnhiRTh3eW/NzWmuUaFfq1snT9Atx/bnT3zmdWRaGFGzBPoP8tYLS5gIuM0I9cT727J6qkXNPhJFSoIAg63zYh5IjiW+xo0dp+se4rTFA49gMjJVvq2MjbCab0+7JF5LPxhpOcr1OWmSRaeEotTarp1oQ+ISi+AINMY49POVfV9v/JkKJvaNn4o559G6ePlf92/B4VBTVO+AGIXMczZFMok72vDkPCxMX8rQY+C68o+aj+MzkfumieFlxBiCilsf2O39k25TZphjn4KqUFImr7NYz2NeYx9aIaNEkf4gPxcLC4huQyfkNSIZYUfTG2O3sTM3Lr7S4PzKJtZkInyBDs7V0wlFpLq9ojzghHEh2hzCBRY2Zp2OEgpYPdbwzaiqUulXQw9C0LBnxWyMcExBEeUAO9oLFav+9QRGGVyUOsmJo+8Kvwpk6Jutzewskhh37G8LfQ5edomaUkEcuGLmpCdQML+nMi4Nec/2LbvmJEuXHifODd5b8HhpMLKqKsvIuTE9YameMo4FyLn6qr+Tkc9iiJV1TaGRBdLsBGcRM/hCHqE3d1ctAY16MuW2l5M6Cd1sInp7Po/COP+EU/wxx8B5rEB0a+Y71YwStOdYP9Pw/8g27rIzFQXRp7rzFKlG9YmICxdMI2B0cLXt30SL0e4cJzW6J4fluz2z8ChGnQ7ydSzzyeJ+/+K/V3Bxg1R80DdXhDJKLvHYKTgn3jj71/GxPQ/oE17CFWCkIVC/kgMCLFTxCe9ZUs7Tfbg2XzGNXhRO0R19MCA8X00NCJ7nxWX1nYII+u4adNi/SXF2qlm/EjWphQleRos3Pd
 CjZ7YWi5
 ajwTLgZQrQgCx57gZhOyfGxC7N8BeMQ6wBtpOo8qgjodzO/VKxw+LTXZzURAmsny0DmTBPBsSMF5LNjylffrbCF8zF72nfkZjRDAbcC9WjkXMFtyf5m2vQXS8apvF2hQkS4Yc795ivQ3zadX/mjzov8qZxMoyJ9l8U50/7sSfh13NTa/ET8aYab1qRpSOXZz5ceogHUoKjDpxo5nGhoydXAqjtUVctH6fre+Qes18eKlt1GX1xKO7KQGYDviGMXZuoGvuHBDG7jJoPwL+HqtebklMPCQ9V0YMR5MMfc1OYY+5p8DUwfCNLd/eAogiOWDBVx8DRmylyKdx0LWp1U95ocT9/mYj4mtd2NtrFFSikjPSbxUmqFU5cB2AGxkCbKl+boXRn6JNiKbqvbM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 13:49:31 -0700 Chris Li <chrisl@kernel.org> wrote:

> On Thu, Aug 21, 2025 at 9:43 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Thu, 21 Aug 2025 18:27:52 +0800 Barry Song <21cnbao@gmail.com> wrote:
> >
> > > On Thu, Aug 21, 2025 at 1:33 AM Nhat Pham <nphamcs@gmail.com> wrote:
> > > >
> > > > On Tue, Aug 19, 2025 at 6:37 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > > > >
> > > > > On Wed, Aug 20, 2025 at 01:34:01PM +1200, Barry Song wrote:
> > > > > >
> > > > > > We might want to revisit the old thread to check whether it is now safe for us
> > > > > > to move to PAGE_SIZE in zswap now.
> > > > >
> > > > > It's perfectly safe as LZO was fixed months ago.
> > > >
> > > > Perfect. Then I'll revive Chengming's patch (see [1]) to reduce the
> > > > compression buffer :)
> > >
> > > Nice!
> > >
> > > But perhaps we should wait until SeongJae sends a new version that
> > > addresses the counter issue?
> >
> > Is there a reason to wait?  I was thinking those are orthogonal problems?
> >
> > Anyway, for the counter (crypto_compress_fail), I don't have a strong opinion.
> > To my understanding, the options for path forward are...
> >
> > 1. remove it,
> > 2. keep it as is, or
> > 3. keep it, but account only -EINPROGRESS[1]
> >
> > If I'm not missing other options, I'm tempted to the first option (remove it)
> > since it doesn't change any existing things, and we can revisit later.
> 
> I am fine with 1) removing it. Maybe add a log once print error on the
> error code if -EINPROGRESS, just to know such extreme error has been
> triggered.
> >
> > Please let me know if I'm missing other options or if you have other preferences.
> 
> I just don't want to hide the extreme error case but I am also fine
> with just removing it. It is your call.

Thank you for your opinion, Chris!  Unless others have different opinions, I
will only remove the counter (option 1), since it is simplest and we can
consider adding another counter or error logs on top of it.


Thanks,
SJ

[...]

