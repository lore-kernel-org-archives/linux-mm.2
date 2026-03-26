Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8626910AB82A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDBAB6B0005; Thu, 26 Mar 2026 19:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C4F6B0089; Thu, 26 Mar 2026 19:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1FC6B0092; Thu, 26 Mar 2026 19:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BB4706B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:06:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D91913C239
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:06:22 +0000 (UTC)
X-FDA: 84589749804.01.6C45799
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id AA1AF2000C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:06:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xbJcYva3;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774566380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHn1kJK+YODkE/CYsDOxyUtITJkveYKHgvR6OOWui1I=;
	b=H4Jn20btuUcZDmWUGEnApoaOUgQYEjLkaT0WSR9ah2eqqnFGeKeAvWP1YpgShziOWcpeTS
	E87ud24wRhigNmb9GRkywT+MZYXRoGDimZVCvXQPUnwTAvo+qMxfipuetyiT+ClabvlgaF
	3cYqIe5c7RA0n51a5dBct1Tf57Gke8o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774566380; a=rsa-sha256;
	cv=none;
	b=mWlPo7SKbygAopKG//G/dmuCwVDsbsofr2aUUR5lQb8jCPxc0rtGC7xNQzsahT+lb4aDBz
	Ncgi08TbPHq9VpGTyNAxQVhIGmRt4razUB9MKYJEwdL+un8r/zcNwp+LXa6PYaKmzISB2p
	E+Nc/YtQc8zgE78EknAuBXocRC5URO4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xbJcYva3;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7192D437F4;
	Thu, 26 Mar 2026 23:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9027C116C6;
	Thu, 26 Mar 2026 23:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774566379;
	bh=TiOzKubtC0x7gm/4SO+ovQWMDQuf7zUlSRKrpYigxp8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xbJcYva3zKWn/jvCOQ8ntfYtZxyKmF1BDjzvRzCuOLUQxJk1HJWv/qnN1gduM4kcE
	 5pThj/pGnC/4rUxXub9eEXfIvnlyN2QA2czGMqfDsDg5/Att3Msob4Fz1riEQ+wxBS
	 vbcPZVtGunBxBoZe06YsmD7oDKvRCVNsKYz55x+8=
Date: Thu, 26 Mar 2026 16:06:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Li Wang <liwang@redhat.com>
Cc: yosry@kernel.org, nphamcs@gmail.com, hannes@cmpxchg.org,
 mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, tj@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, longman@redhat.com,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v5 0/8] selftests/cgroup: improve zswap tests robustness
 and support large page sizes
Message-Id: <20260326160618.18a20227b606bc95f3c3cfa6@linux-foundation.org>
In-Reply-To: <acTSQFxTs4-t7P5t@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
	<acTSQFxTs4-t7P5t@redhat.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AA1AF2000C
X-Stat-Signature: ipn6tosc5g3fdmr7t1fe5qf1396ayu6r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774566380-971055
X-HE-Meta: U2FsdGVkX19Y8cPP5UunoDOfjOQEHKTpO/la1F+H8xd+vSqDzcCS2kMGgfFF8aumDdOxcZj3oRQ3hr9PYqiOJ8IjGZz+poxlULi3ZoVgJmStAklGIb6s6HPZHjKhwpo9AJU6Ri6pDf+gPCL/fYYnGpoum7S3UhssiFI0ugepJ4c4l+KPdKpVhNGt3fBoaEm9ydWWwmuW0tu9w5iIIa1zgBfJ42ZJUOXLHKvd7szRFumk+uE0+gckNaeJg1ltoHYp1urTa/vQGQA5dNrL1NGkF5Fmi5A+dzyoOcRRRUI3sXa4LF0AQUZb0gtbf2YQAZKL9ddEIwa0mBo2hib07/EFcgBn+5xwStUbMe9ptCRFa3XNuiUZgWwBssaZEG/ENXWR0Vy9Jchbd3OvJzQVw4HMIOHceZFmuusCR0aUqd4spQo3FWvpZeDJ77J5pYxSNNckTeMdyI2htp4/6CTF+x5VP4R4pDyeZDyIi8pejqMZtrGAsyr6mykTOLyJI91ImhtB2TnjOuRYKZa20ufDJKJ6PGo1Hf2Ym+oWjKQE3yjKI06rEyz1P5h4ZSEmiudagrboLGOa4etY/wVVGn5qykck9cRLIcOCatAvslWsxrV50cipnS8RumQtvQdNB9vD8LIgg14wgZQR2i0x4MJPkJRc4F71gBAOdgkjzWuA/Ddce6ASqRy8oaUoEcu2J4cDNy1kUw3F58l4Nog1R2CoM6UaHrKBeOuWKQQLKdmJY+13eFVRtKInBi99NfUWtBzOVZNjdL1O5u2LeJB+QEuhGq1e9jDB8QLGFVY+wDRQB1o90wyoe3JknBgqvhoLmXyvTWNK+Pxh1gIAsjobNcauK2etHCacmohZWcNUhqU/kRQZRomA3U5ofTZKDkpZrvywBxxTmBMmByeq2VrRkEj3w81KZQZ23actR5UJgUvVskOl2WnmPQLB2rGbJ3gLH/ETM/HWoGh0tFHvNpI3RV6roAP
 PMY/gnKW
 KkR1RwxdeFKOBLfBhLvF8WpJs7PLGh2rA+ccajLVyakqE4p6TZq1QCXF2EvBaq2sBTctElY+PNEcmnikO7cFUU35sZ9NXJByF9jjk/gghjGKpl1vd9HLzzget37vUhLT8XN2X/3AtLCzxh92avwuZnJJLd6cfJ7zlxgnHDwMxiQ3U3pbJHz4fa719cBgYzgZOdb3CX6bLj59CaJvXAnuR9wfV7gpFFRGl//P/A8KO9f17HEDCe8q+fJwbNio+3YROLv1d6cfEL3iJlCT5rR3v3U4Z60YsHesuBivdrviq1ndYeqs+JJE6nULOxyRKdIVNQjfgszXbiD5nAc4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 14:29:20 +0800 Li Wang <liwang@redhat.com> wrote:

> > Test all passed on:
> >   x86_64(4k), aarch64(4K, 64K), ppc64le(64K).
> 
> Hi Andrew, All,
> 
> I see that Sashiko still points out minor issues in this patchset,
> That seems very tiny in selftest programming.
> 
> I can correct all that in a new version if you'd like a perfect patchset.
> 
> Sashiko comments:
>   https://sashiko.dev/#/patchset/20260326032658.96819-1-liwang%40redhat.com

Ah, OK, you already looked.

If you say they're too minor then I'm OK with that.  If there are any
you feel you'd like to address then go for it.  That's my opinion,
others might differ!

I suggest you leave things as-is for a while (a week?), give the memcg
maintainers time to take a look (please).

Thanks.

