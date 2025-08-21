Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5256BCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 19:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CFA28E0021; Thu, 21 Aug 2025 15:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459988E0001; Thu, 21 Aug 2025 15:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321848E0021; Thu, 21 Aug 2025 15:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C1638E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 15:01:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8C4D5C0539
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:01:13 +0000 (UTC)
X-FDA: 83801682426.05.3F412CF
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf09.hostedemail.com (Postfix) with ESMTP id E79A4140017
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 19:01:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QES3rEDO;
	spf=pass (imf09.hostedemail.com: domain of tj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755802872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hMEj1y30VqR6gy4MeuNGkeQJfZHN7kYokSYdxlKk/cM=;
	b=v3qhbc83iVKYHC+WDMXlewl+mEwj1s3OOxuLGiL/7Oq24zeb7lVm0L7y9Wf70T8j62Nleg
	l5vIlVKw0FsBTJGhZy3iu6BLOFZwSErL5A6Px6iYKVf7ZLPzenZyhvE39vNRoNcDnbJSLe
	TdFIq7P/6QQED0J9dxl30zjxP2Za0v8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QES3rEDO;
	spf=pass (imf09.hostedemail.com: domain of tj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755802872; a=rsa-sha256;
	cv=none;
	b=LlBLqDZ79mMcdjud+nKB12X4AqTXZPjyfLTb+JRcqbYhq1m1we26anCAIcUyd9WmagUZ4w
	HMEeFzRnD8/9Hu189cDwl5+O2WjswlNUcjVBMzmWUEqv6tp6Yh6Ej4ovgShujDThXDKayg
	BiGMsc9YcizJRVoc64AEYJP6b9GmmG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 3AADDA547A1;
	Thu, 21 Aug 2025 19:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC5FEC4CEF4;
	Thu, 21 Aug 2025 19:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755802870;
	bh=kiYzv+ykBbvja6WLcNzMdnPOi5+QDzOSzNFg2/Lw1p0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QES3rEDO+3c6yUOGupyuUJfdk9b9h8kSq4WuOBkqfPA4BaiOsmfR8Di3TEGSaB3is
	 5jZNJ9pdIJuvkIsdP1nVmGpEmLIaFF49HRMYA7/2zkSaClt2uQgjhRLXxG4x1n/41Z
	 XmBmoIYH+75mRIDahJJqXCm2LXtC9EsNlANX/hdtFtOcaCt2b73FSXPqjuCHJ3KX/U
	 +3ZDjyUAQ1Qw3Um63jwSYF01wvTuT8tT84bIkWhylMzZ332AsbB7lEG5ro6jn/8aTD
	 /G9Dn92fZhTyait9Az/66sK1pBh8vJh6gJaK+irYmREzLUOzB8Rn5ba5sVWtMANotE
	 bOSvoUkC4CJFg==
Date: Thu, 21 Aug 2025 09:01:09 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, axboe@kernel.dk
Subject: Re: [External] Re: [PATCH] memcg: Don't wait writeback completion
 when release memcg.
Message-ID: <aKds9ZMUTC8VztEt@slm.duckdns.org>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
 <aKY2-sTc5qQmdea4@slm.duckdns.org>
 <CAHSKhtf--qn3TH3LFMrwqb-Nng2ABwV2gOX0PyAerd7h612X5Q@mail.gmail.com>
 <aKdQgIvZcVCJWMXl@slm.duckdns.org>
 <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHSKhtdhj-AuApc8yw+wDNNHMRH-XNMVD=8G7Mk_=1o2FQASQg@mail.gmail.com>
X-Stat-Signature: tx9ytx3r5bcp9mbk83dfizrqkiiwnkg8
X-Rspam-User: 
X-Rspamd-Queue-Id: E79A4140017
X-Rspamd-Server: rspam01
X-HE-Tag: 1755802871-730032
X-HE-Meta: U2FsdGVkX1/Abw2GeC+4dHvfExbKpUZft2ryXwqKBGRzt74lhyHVG4RJiUMGOTc4qWUG4cMZ6Q3/eAkJDYt5yfkPHgMLbiz4RQpdFs4cJ8MCb1r/lcFTAKNFFb1rHiSiqthkZIGVtaeJKtzvsrr24ktxKjj4i/DhpqztXiAsyQSp2KWIAoMXLhS7mEApq68Qb0HEwKWNuz0StzjPElznGXucuvb6cU+SP0Fi7lJpmE+tYyVo5dM/X4H2GH2esT5ySnu7IEGKKZR+UYbmQw7/9bCQBdJ2tGSf11IJmC4Rv6zhPK43ECW06vY5YthYh0Ks/6OqA28KxB66AzJdJcXo0gUV2AUjHPRTmgpVY1YnqJv9FsCmd2G+KiQBg/UlEhPnBkK7BQO1sMObL4e4GkLANNCzpn+5FjRgfB69d2R86RJXN6VcGnQR7ObJ32u1+wvJrzU+Z0xVRxl34Ee7tp8T5Gcf6u3kj8uhp6zJCaOtxhVsyw9yrqitHtiVvZ7TPkf/P6ZMyYnyyG3nOID8T7ZYADU5vo4AgS4wGRTBqlbHXVjXOSHBRUxSzwr1q/Mp0TqjOUqeWa2VGT2i2QTjvNum3cHdob5c8lk/VXBxXZFjByFgqBZOVGANGNyrANhUjLe4ZlNcjwP6MA5dGmYV/R4p8hqYJe9Ootx6CUqcAZHpFy7iaNUrA1seZqLHp6Zi0LkzD2iFi3UnemBRiVKjIQRVZWDN0vBRatDal8FOh+CC/ClqFElAvDAZj3X+c+WUVSulON9SZRyL3dm9XKncClAuXuGg9XOqSVyZoNBBwgix4SwgYuwleueDnaeWaDIW9lmflCEVbLTjGQ04s67C4JxnkA6nMNTyVAKdi61PQCuaEG8G/S9vH/5P60VzHQeLx++OHwE7QmUYFzeNUihlKVvxAc1pomD8e1uRLo7DEGpd3hT3LAn1DHQQ9//qmfbigt5z5PRuQK1MOaiKxbuQmVZ
 CCUT0L4+
 RYbHNZzrVCEykWr2TxVYJHP22raLEL2D3gu293+NBUlbQv82uG4O2yPBbCyVnSzorZRr77CHFKsXIpKx335NA5jjTtGOXb8/JebnNY00lW+VaIiPcKitxzp3XpcqCBxnmYzEiizfRpdWH/AMzE1w/Nr1L89EApK4lMq2VVBlLloVQLnd16CDuy1LxMlwfwqo729hYaQXmCbOmTBchyH8djfYA4w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Fri, Aug 22, 2025 at 02:00:10AM +0800, Julian Sun wrote:
...
> Do you mean logic like this?
> 
>     for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
>         wb_wait_for_completion(&memcg->cgwb_frn[i].done);
>     kfree(memcg);
> 
> But there still exist task hang issues as long as
> wb_wait_for_completion() exists.

Ah, right. I was just thinking about the workqueue being stalled. The
problem is that the wait itself is too long.

> I think the scope of impact of the current changes should be
> manageable. I have checked all the other places where wb_queue_work()
> is called, and their free_done values are all 0, and I also tested
> this patch with the reproducer in [1] with kasan and kmemleak enabled.
> The test result looks fine, so this should not have a significant
> impact.
> What do you think?

My source of reluctance is that it's a peculiar situation where flushing of
a cgroup takes that long due to hard throttling and the self-freeing
mechanism isn't the prettiest thing. Do you think you can do the same thing
through custom waitq wakeup function?

Thanks.

-- 
tejun

