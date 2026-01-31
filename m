Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5801E7C6E2
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 19:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2602C6B0005; Sat, 31 Jan 2026 14:54:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E3CB6B0088; Sat, 31 Jan 2026 14:54:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F03C6B008A; Sat, 31 Jan 2026 14:54:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F34FF6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:54:21 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 938B28BA12
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:54:21 +0000 (UTC)
X-FDA: 84393310722.26.2394E7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D7A3F180006
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:54:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pmUnRFIC;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769889260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBQ1MrImHCg1PThp7hd1qGQ8qJRDOrGBXwa3bWOP7Ik=;
	b=Im+Zujs8JV+NIQVkM6TnPwO2JICdC4MRhcV4+RB1YnQVSSVQ8g7ipFp9345CNiUlYzBZWA
	NmQ2VXAu33L2cuMGEH5bkeN5V9a6iRb+TMRcC4u91N86jHuBpCnseBFlp8wlxRGXUt0AHU
	eIqp9n9p6h40xYQQugKoOtwdL77Byc0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pmUnRFIC;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769889260; a=rsa-sha256;
	cv=none;
	b=fBpOfAi9N+gbzpNqGWQb0J4zeW/Ju0Y8padzWWDt0hlJEcRs0lWg+YkSsao3+xecSz/TNj
	q59g0w6FEqYHIL3GXLiK0SczUhzszeo+/Plr63yWciWoVXK7NyQr+AJCCiVFrpDNhH7s/p
	bmW8lEyViojo7fJdwR8QGbb9s9yBL/k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E5D8A43CB1;
	Sat, 31 Jan 2026 19:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E10C4CEF1;
	Sat, 31 Jan 2026 19:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769889258;
	bh=N8vKGMyccUxrYrqp4qY0jWMxA5NCQ/73rs9xDcCS5Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmUnRFIChWDWwhJxLVO7VzYaEr21cBFNt5vFZXdhn4hObmhuEZeGNgIE2xBQtHO7Y
	 d5ZZJ7TXwa7VPq234F5zPHdhKgUlTj0F+0IB6tVM5myIW687yeM9UYiF/m32ANpAEP
	 i+RYt6T6RcWdWDvIexlbj83YEY+wcLLYzL3yzOtv+U3B0xbla+LlXYGAaZmdpplDyS
	 z3qmrmg1fjO0e5X3z3s4NyZEP6dff+b6jLa6wJBKD1rm5QpzIqap+czcoXm6ESQXFa
	 k1SFj6BWJjtYmzDUEuDMdL2RlDRBGJxjVAB8h1wYuR/HiksHxVR0twjwIrzLcIrIcj
	 L2J4bDpA4UaYw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
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
Date: Sat, 31 Jan 2026 11:54:07 -0800
Message-ID: <20260131195408.66514-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260130014807.51302-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e3hgq1sfzhyj4gqah1w4c5yaaystrw7x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D7A3F180006
X-HE-Tag: 1769889259-723205
X-HE-Meta: U2FsdGVkX19J7RH7htic2cMptPhYkxKLKZVsdt/Uk471WZIEqtDnPnZDA7NnU72+mt71JA0ww65scKhcy9LmRxCUXf/GxbKExgPl1SXSeo6rTOAWHbO0VFID9dJ/nQURBwQGc0mlNMiBYfV6/6awX+LqYSLcMKGwx3TRQqhskNgZ5tjxWvrkfLvYQ/g+BY6noGDZR4IbsTwMyfZLn84u/ykKvDtw9yDHSjgSFR9zJ6jxrLMRm5unLY+9EKy4Gyt67TC06SK69aotiOam1zgB66ZgK/SxYvbBsu+8JHI094gD0yvhxuxx+r9YqS63CLOs+NPeQQQ4Yzs9KU3tT6g3X86eO7h/RbLxo35DwBgBm5GmDcQtrWL3vYBqUiem+Ws5+B21UkfVJUibmLQfxP1FvoOtDnPDONYx1Zd/Dsd6n91W4bq9BzuIO5foU+pOSIMTO7TTsdUyqYi2wKSCq1baFW4hRSp2TwgrwyTTqxOWDGJaPhb1GhrqoUl0RxpEy2zADOrvsmZp84O+rEJTkm0i7D1JvMAqrPWp2eH0LEldIUPqCYmJkp/SP3S4+5wBHU4mWzsum5J7X3vgm3b33u9QcG8xdpzE/aK/B1jzVs7CjHpSewrYpAZKNoQ0da6S7e7dDeAcCiAsLCpRzGCsKunB2ugFmFXs4Pdf751h/nfREtbl1MId02IjYXXLJ74LL8VoZ6JCLWS5JG0+FBPQlk7a5PSd+FfJsjHxvpaTyIFd0F/ZmHI8St8zf28ELxar38C7BR6w6pxKw16hLKuMAsMrQnn7HOGPESYI3naKkJmnX6Dcts/X1yYeDFmx+rVlqYPneVuaYpAxai6st2GFWA5mrxNMfSn7j5RTsYgEttRwJBBKvtB7XnhJe2I78erD9I5V0QsZMyhpOI7gJf2+201MXz1qaiKCvGMIO053mcPF5Lo3bLQkV8YO59rFqNrSrvFRRirYBokp2GahQfScEv6
 tqrqpxn2
 dIAUu9xjWaiENu+ycBX2rZnMiP6t1/nBRiJQlI7gBQy7xv96GwvLWHzvucatdOHMY1i4wkJxpfMB6amMCQeoQHvBOSVr81m8oO/jeXe1B0ohbT+xg53MOfpiidSWwmKTypWsmXdp1Tw3oapOD9JtCyot86Y4HPqSEF/s1V5vTJ3RZjI5s9Mepg46CQoS3UHqN8oIP4zB3oOt5dAE/6WXvQQuyN9aOOD2GGVVAnR4z0PvcZ/WmPEBzpLUUmLLGoCchCR+Q36cRthu8rGjITz/TC9FenpkaU+L0w3siXYe46vQbNuTngpeOD9ZTanF5TzfFklzSk/X0Txk1qXusLzxAzz7DNmvuKy9kuT/CuRdZ7SdAL6hZmhGWXrFBMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 17:48:06 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 29 Jan 2026 13:58:11 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> 
> > This series introduces a new DAMON quota goal metric, `node_target_mem_bp`,
> > designed for controlling memory migration in heterogeneous memory systems
> > (e.g., DRAM and CXL memory tiering).
> > 
> > v1: https://lore.kernel.org/linux-mm/20260123045733.6954-1-ravis.opensrc@gmail.com/T/#u
[...]
>     Context 0: monitors node 0, migrate_hot -> node 1
>       goal: node_ineligible_mem_bp, nid=0, target=4000
> 
>     Context 1: monitors node 1, migrate_hot -> node 0
>       goal: node_target_mem_bp, nid=0, target=6000

In offline, Ravi enlightened me that using a single context with two schemes
instead of the above two contexts setup can be more efficienct and useful.  I
agree that.  It will be able to only single kdamond, and there could be more
flexible use cases that can use the whole-memory access pattern.

That is, we can use single context with the two schemes, but adding a core
layer DAMOS filters for applying the schemes to only memory of node 0 and node
1, respectively.  Similar for memory tiering use cases.

But I was recommending the multi contexts approach to people because the
current implementation of DAMOS is not efficient when both quota and core layer
filters are used.  I was actually working on making it improved, and just
posted an RFC patch series [1].  After the patches are merged, hopefully the
single context approach will be useful and effcient enough for varying use
cases including the memory tiering.

[1] https://lore.kernel.org/20260131194145.66286-1-sj@kernel.org


Thanks,
SJ

[...]

