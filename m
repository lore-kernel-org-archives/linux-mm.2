Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80585E8B386
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 00:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FD16B0005; Tue,  3 Feb 2026 19:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E186B0088; Tue,  3 Feb 2026 19:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53CFD6B0089; Tue,  3 Feb 2026 19:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F84D6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:29:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A9B2C2527
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:29:10 +0000 (UTC)
X-FDA: 84404889660.30.78153F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id B4B47100008
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 00:29:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IU8Q6VfB;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770164948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCC0bYHCM8u1pPn0ANwYquSmtcOEsUk77yy9AQP6rJg=;
	b=YZBcemiIyZbqnwh8ZLaQdBUV7Rt3Hl4o9zGHGtxsez7fu1AZ91TkkY4yG2lUMKZvHpicgd
	aYVE6zQdzjCRX5iO/YiVMb86xY/QGBJaUguSv20vXB7YXkk9lIMVNAUPunPdwryr20h46o
	XhUqxfkLZmRML5hEXsaQV2bj7vy8mOI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IU8Q6VfB;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770164948; a=rsa-sha256;
	cv=none;
	b=dJc4IU3xBNXwMwfnu4ttyn1NgK/l8R9eILAXsRO+pSKByXPUK0x0VgWu0gFRQN38Gh1OsM
	5bf+RPsAAOh96OZkGKhx1kCwaUWmPxd9+AJxLin8CUgKJ7PCqy3IBPGDZj14erH7lV06BZ
	BxeV68EDmJ/jJmCBBTdQ1JqfNPcHuzw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E2AE76012A;
	Wed,  4 Feb 2026 00:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6442BC2BC86;
	Wed,  4 Feb 2026 00:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770164947;
	bh=qXE3g6jBKd0Y66pW7cPox46N88wlCWyAaIJYLCmu0uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IU8Q6VfBQMpLFZ67aNKfIJIqzkP9TvOhTNtI59fwSZSXV6YqPxKwrWdmpHBv1dwSg
	 0VX5XZAN2rHTJ0fg32vC10Tsf1IkW0dCshjF1o730hypxasYnFn7LYpV9dECkI+2ji
	 ID09hCOwY7aUJJA2j5qoXyaGuhMo+MWELNg3FAYKxAf5zf6fdPhQ/ZaqY5ZxiM/zKn
	 G7+fEneH8mR2fRK4JYehWvbxOT9ag3t7+WbSuwXO99Hwcpf/mqviuc1hWzmw4/IHbz
	 7aGM2i79izcajfS5FS0mr/49sCoZxV1zCtmF82l5Sy08MXY7wRjrxOR27yq85g47gW
	 mtTmJPdG6tunw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v2 0/3] mm/damon: Introduce node_target_mem_bp Quota Goal Metric
Date: Tue,  3 Feb 2026 16:28:58 -0800
Message-ID: <20260204002900.49291-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y1475VSnrNTn-AQtTTnye+sdAGu9sVO0YMEtLidNW53_=A@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B4B47100008
X-Rspamd-Server: rspam07
X-Stat-Signature: upqhmya4pmofsyx49fdqe934t8bfypgf
X-HE-Tag: 1770164948-282296
X-HE-Meta: U2FsdGVkX19OuRj9j19NAza8ISEUU9UBoH2FAF9pMpj7cBe9cKoPPxLKP9vFru6kZocLZPYDBHbFJRGeW5UZ4L5u2/TNnbkNx3tcY0gG0BQSuTfxrDjQZ02/uE48dMmNhueJJ3gwnMAZtjyi58osq9EUOuAGSOmylJRP+ZMV5BS2csHJjv3NIf5IUWSPnrJhb1pF8/Ygr+PZhAleNmqdzc64p7YYTh+NnDQgxx/WoJAkYXlQw+UdCo2jw3ckCkzFb0Yk7+xxn86YGOm746Lonbgv1lovaWNfQgz4n2RWubKr13XK/BwPVyYNSV/Aqte9VtGOIjUlnK5SB366hXZ8cXnLKg+X10LOeonheMGa5VSsk4lMB8F6jwvyZzyJAnp+9LxduonzpGWmy99LcXBphjQifCZ/NN+wcME4FfQf6vhFa/J2aMvF4O7iZ4bp1UjcfX9NyFWk+MUg11JXj4IeWYEWm7fh5m61UNKsEzVd/QhiOuRAECOZ/QOCMsSGFG4E0uvtwk+kvsbV7Z2vH8nVXOckhSEWBWtFrYiWaXCWvCLiO4JphxhJvEEiisX4pS7uzbFIbJk6URhdNdkNXcMpenEtFZ1/HXaxZA9uAg5xTv91JqmMdrhP66Iuqg8SSj0RZIICWsA8jW+TeW4eQBW5ne/ZAJ7CNm1CB48eX4/BWrF46D/Vgk4w0xq/9uqjz205o+1v2tCRZHEaJf/LJEgYV/a0n500yq4Gi3N64v9Lnd2hgcbfEC1mn8P1nC2ZYuAe+04PEh4y0b4ZFPSE4vMSoA4K47SJDdfJKtQKxne+XqPqlJR6OkPwzZScchev71bY2DUxnNsG7X9WAMjfAYoEMZTziZujAO33YKDJ0yNkmurNwCSAxhu/7hvDqrKwidGZoISKh1vkpA1EYXevxZTE/frkAKGSgeqO1a3UJ1KMwiC63+VWzt8TeI7ZlOfI/1aFtS8QNKr2RtXl3tb6DsS
 dY7zImmy
 QCeK6+WBeDfCVqtKOHDqT/JzbfgcHWqmas5x/Ug+Rn4nkvM7zzfAurGwd7c5YKZvT0Yp+QOsQUP/hH1YKRY1szs142sLUQ2FQSu3eSIinRUPILwRFY8h0nKYPajgCxFe5aAoiKcIGDKrA/tldMpvqd2Pd70Bohm6VFDbV6PAi53XHK22oFhmXgjRwoyRZB3egYDj4KnXZgpW7MQl4+q7yVQpW4kvEUVZd7LAibpKLsSIUiJMcBXDR4HdlKiS1fMN2MGg8mBpM9cKSmra5uDoRGa3Vb+CIYapE0pVc0mOQxToQlwz0ZmUa22U2WvwWlsbgaYGuBlVJDghusxU+B6Xhn19hYxOcsdWB7NH1Fw8nCGv8d2UYl0bCLA+BWzqeXz5fxakBjqmGmioJ2L7z+bAZeatizIiGtc/4ERgR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 3 Feb 2026 11:48:06 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Sat, Jan 31, 2026 at 11:54 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > On Thu, 29 Jan 2026 17:48:06 -0800 SeongJae Park <sj@kernel.org> wrote:
> >
> > > On Thu, 29 Jan 2026 13:58:11 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> > >
> > > > This series introduces a new DAMON quota goal metric, `node_target_mem_bp`,
> > > > designed for controlling memory migration in heterogeneous memory systems
> > > > (e.g., DRAM and CXL memory tiering).
> > > >
> > > > v1: https://lore.kernel.org/linux-mm/20260123045733.6954-1-ravis.opensrc@gmail.com/T/#u
> > [...]
> > >     Context 0: monitors node 0, migrate_hot -> node 1
> > >       goal: node_ineligible_mem_bp, nid=0, target=4000
> > >
> > >     Context 1: monitors node 1, migrate_hot -> node 0
> > >       goal: node_target_mem_bp, nid=0, target=6000
> >
> > In offline, Ravi enlightened me that using a single context with two schemes
> > instead of the above two contexts setup can be more efficienct and useful.  I
> > agree that.  It will be able to only single kdamond, and there could be more
> > flexible use cases that can use the whole-memory access pattern.
> >
> > That is, we can use single context with the two schemes, but adding a core
> > layer DAMOS filters for applying the schemes to only memory of node 0 and node
> > 1, respectively.  Similar for memory tiering use cases.
> >
> > But I was recommending the multi contexts approach to people because the
> > current implementation of DAMOS is not efficient when both quota and core layer
> > filters are used.  I was actually working on making it improved, and just
> > posted an RFC patch series [1].  After the patches are merged, hopefully the
> > single context approach will be useful and effcient enough for varying use
> > cases including the memory tiering.
> >
> > [1] https://lore.kernel.org/20260131194145.66286-1-sj@kernel.org
> >
> Thanks for providing the DAMOS_FILTER patch update SJ.
> 
> For v3, I plan to introduce two complementary metrics:
> DAMOS_QUOTA_NODE_ELIGIBLE_MEM_BP
> and DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP.
> 
> This will support the following approaches for hot memory migration:
> 1. Single context with two schemes using both metrics.
> (along with DAMOS_FILTER_TYPE_ADDR)
> 2. Two DAMON contexts each using
> DAMOS_QUOTA_NODE_INELIGIBLE_MEM_BP.

Sounds good!

> 
> Will provide more details on the implementation and usage in the v3 series.

Looking forward to it!


Thanks,
SJ

[...]

