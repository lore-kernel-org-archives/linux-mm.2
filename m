Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F234C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 23:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545D26B0092; Fri, 28 Aug 2026 19:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F63F6B0095; Fri, 28 Aug 2026 19:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433D76B0096; Fri, 28 Aug 2026 19:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 213B96B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 19:19:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 953D4A05CC
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:19:45 +0000 (UTC)
X-FDA: 85152247530.12.4963423
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC59B4000A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:19:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OyaMlNeG;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787959184;
	b=EhqdZRF2a4nzitoxx/LZSUT2Zb09l8D8ue1pvJEcS2+aHBtCIwfYu8nZmoXbbj1JmJe45p
	0Y+og+zN2BvfF6RVpqGbW5AXXF0FD7XrMNu31ctPajj3pN9Pj9ycP2NsJUBNPTrgD8Sglt
	h46Al5DLxtLuKNFXaGb2mMTHmLAwiqo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OyaMlNeG;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787959184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGTIcEOa8Bl/ys+CrMwubJJ+e1El5YPJ5H0B806NNM0=;
	b=v4qBV/luzciK7ULuHawqLfsvg1WtM9YcVMal9tBHa1/g64D15MDILJQxZzsZ0IY76mcmxT
	V4WEHQQzcXH8jM4Ta6o+ZVXwq2SB96e6xXR4k6Hd+bQ8zFms6wO0JPpNCfIt3z/3OGxGgm
	MJad5QNPAcXxZ+BoS57otgpUpN518UI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B397D433E7;
	Fri, 28 Aug 2026 23:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBBB51F000E9;
	Fri, 28 Aug 2026 23:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787959182;
	bh=wGTIcEOa8Bl/ys+CrMwubJJ+e1El5YPJ5H0B806NNM0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=OyaMlNeGv29cOVIgzSDrI3H6wGxTi2yI9Obbhxt+DwrreAxbryAnDVJORfl8SFd3V
	 /kAvbZsPefzV20UYas1yLsr3mJHRbaImT/12+z7SvKQSH7GdrkVb9G0PyZUJRENAD9
	 XlkjMAd/hkCHTzcXNNDeZc4WDw1ZedHHBXDsana8=
Date: Fri, 28 Aug 2026 16:19:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Barry Song <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Michal
 Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Ridong Chen <ridong.chen@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
Subject: Re: [PATCH v3 0/6] mm/mglru: clean up folio counters and flag usage
Message-Id: <20260828161941.def8f7a319f6b435aad62d69@linux-foundation.org>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CC59B4000A
X-Stat-Signature: wu5ww7xpyt1gao8fkrt879gqgosmocpj
X-Rspam-User: 
X-HE-Tag: 1787959183-498931
X-HE-Meta: U2FsdGVkX19yiuhhFvG5Ogp1fMZF3IEk88kzfQBtdHUOHImptF/gMX+xVas52Dn6AlItLL7Of8MGakV9D2jtAyn0a6UhE1RsEpRJV/lGlo67RLXb8RWppGCT4j9VgZSupHeal39GjO+wvINXqGhoVFfZZW2qeFW2aOh3tXyoCJewwFvFFpI/uO+kZYoZOLu2oTPGbzPZRenKmVukQku+5BhGbAhbRHx2oGYf/b9pnP1702F2lgQEnMrYI20/BtNLbk8PpL2BBkQz1JwKVrPQDrrejwO9MwfbH9aosxFUR+ECaUk/Q5NtcIC95xj31dEG1CoXikf5GIcfIKGO3AN96lKoxtptJ7R/nh7FPv9spLzliZlB4uvpY3JGjYL5DwOdagJHuqeYy6UsvhgNg/8ztrifXfy2CtFw+OYN+/ZFbwO0pSJc18Jmfg/xLNSIBHqkz13JYpvJEhlSpFs7mavfhR1umAjklqT+Irck677M/vL2SsoNm4g7xqIRlOOLq9XiZPoqJJ28oUwcSKkytyb/SSSqkhP2fBW1IMT2W90GPe9xjf5Io0UYnKi5OtAiWs2EBhF5zS70l1a0vuNHrOTxU82RRokmAcu8/D3Y2V+PB0Lamc/xH80JGRKtcE99zSdkX9AawLng+U329dOGC5ea/0ZeBEK4xkpRJnk7AYs5gH4LF4Mz8ndiIbyo8I0KmD0QkphyZLfz8Nlz5dJVjxEhDuOCL3QQDvkpunL270hJQUh3KdJKxeOxWqBeq27mI+EQPOXJkOpl4ebtrZwjsqVL//CvAad8ZocwWLTnN+Mp+c28T1fY8sSjZitNQ4aZnyTEFL4X9YkTjSXJzPcZccHlzVJyX/ZmjXNWa+QCIVGQk6SWsgi92yGiOBItt5ZcrTrIJXIPslpVe1WS69FqE0VId3L+pUmEilGv/wlPlKiC4YDBCmhpaIjAbjb1o4MO0adUsqXEEOnLr9NRGrW4Bva
 uMG/1qY/
 3gRVXg9ULhxSQ233WijVgIGPUM9X/kGrf3YAxhwclWi8E92Q7o1SXxZulBv+iYswvwE+utcBR2K6uonRWRzVkQXdEWJ60SRMJPb3BsFTsuO35n/uwjWxAuXrhGJFaS7Dga6dMW1QIyF8cop+ySlQqGqhkaAe+/dqD4h+4wurfLaEJ2PGaQ0MKaaT/A+ECXp5KddS6AYGDPSQE6tX4bhMe+HEOCHNTe+yO6HqCTpSyTXD4pA5TmcdwzNV1Wo+Cr4zArWXbWo+2CdsfJZ24hW0TDsX/f6CjQjWMuBvFAtb3HJMJskZvNpP6igFA5oXDL2YFwDs8wAXhGFgjegtiZgIh/OzsDkqnhGyA8oFsQAS7qL3iVeI1S6yzBV6w2tph2VjwcODq7qUoYCqXX5CXIBk9fNScAv+h3EhbandSQgyZwO5drdv6ftXYEoKLm6jAd8hXueRL8/RjD+LM/yU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 26 Aug 2026 01:53:33 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> This is a cleanup series separated out from the MGLRU-FG series [1]. As
> that series is getting too long in following updates, seperate out the
> clean up part for easier review and merge.
> 
> No feature change is intended, except one bugfix. It mostly replaces
> the open-coded bit operations scattered throughout the MGLRU code with
> new helpers, with proper kdocs, sanity debug checks, and hardens a few
> MGLRU functions.
> 
> A subtle generation counter leak is also found during the refactoring
> and the fix is included.
> 
> Also collected review feedbacks on the cleanup part from the posted
> series.

Thanks, I queued this for testing and further review.


I included a few notes-to-self:

- Unaddressed review comments:
	https://lore.kernel.org/fbb40ab7-6942-4983-9621-ab8d5d50474f@linux.alibaba.com
	https://lore.kernel.org/20260828052949.52874-1-lianux.mm@gmail.com

- [6/6] is pending review

