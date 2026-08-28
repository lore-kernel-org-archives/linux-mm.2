Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B43BEC61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:07:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9976B0088; Thu, 27 Aug 2026 23:07:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95AB26B008A; Thu, 27 Aug 2026 23:07:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86FF26B008C; Thu, 27 Aug 2026 23:07:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66EAF6B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:07:21 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DFF241402D0
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:07:20 +0000 (UTC)
X-FDA: 85149192240.06.902A397
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 186E2100002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:07:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ogwjESZ5;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gt76UcTPmzHLWuOwKDbCamUsSovytLsnrvRwSJBIAoo=;
	b=o/UNl6H4JjcbqxWpT6wpIsG5Lj5LyyJMpmO+zsqMLBzTTA0I+P5xPWqooOEFv+RC+pjLCy
	Bz5yj/Whai2Vm4u90Cbeklmn+Ks/W/c+m8ovdBKlJENDc4XnOGJRb24UE7d4EmTPbNcp3d
	x/vCY9b8rIuaSgoUpuADIwTwuw6LPcU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ogwjESZ5;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886439;
	b=DYFJhb8onuFOPy3KUlF9zSkcaIwJbHp/UE2OrFk/FA+w8/No6X6MtYV+XWQLkboYt7AyvR
	TcTgd8PROVRyYeCVcRz13UA1mhyhvkA0v548us0tuspL//AbBBGMM2MJCg1WXRJCj0Ny/z
	B25yph6+rEs2uIyqN2FnQNAMYCkXN6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 217594347E;
	Fri, 28 Aug 2026 03:07:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ADF1F000E9;
	Fri, 28 Aug 2026 03:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787886438;
	bh=Gt76UcTPmzHLWuOwKDbCamUsSovytLsnrvRwSJBIAoo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ogwjESZ5/FbCSjjrCLy5uiofj6a3BXR3/ZKpajdm5ZCo9aB8+asfXzXiazHR/vJcs
	 ggzMBp1ivVxgK7aGvpICf/s7db/rIy8wvidccRF4T05SSed7qjdRnmJlI+KxOyFki7
	 2kC+NR2EW8bFE+6fZhpAnLQZXcj8BYnklmn+9FVA=
Date: Thu, 27 Aug 2026 20:07:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: chrisl@kernel.org, kasong@tencent.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 yosry@kernel.org, david@kernel.org, muchun.song@linux.dev,
 shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org,
 youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, riel@surriel.com, gourry@gourry.net,
 haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com,
 baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com,
 skhan@linuxfoundation.org, kunwu.chan@linux.dev, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v4 00/11] Virtual Swap Space (Swap Table Edition)
Message-Id: <20260827200716.97881447f243c4afd275144e@linux-foundation.org>
In-Reply-To: <20260825153238.2695446-1-nphamcs@gmail.com>
References: <20260825153238.2695446-1-nphamcs@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nyauy6m4yjjsyzza3tgy4y9gue9a9qbm
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 186E2100002
X-Rspam-User: 
X-HE-Tag: 1787886438-788237
X-HE-Meta: U2FsdGVkX198jvOrBatyN+lychrefw5XZoFuZGBBBDuBAkZ3+CMAd9bXt6eaDV/c6gPhaAm/172c5uPKMrj04eBqU7CVhZ6murqprnHGHvJfxas169w+F76di8khiToCfXe+N3goVR03XXnCamdGCpn8CiThJkrzr8uaZQriCXBuam517KGoqCEI46Ua3g2Q2Sk4Vr4gH8DP6+OEHuaqdEdfY9c1ypVuzqvnDNz9KCpmh70znIgpfnVx93cw32yg6xlO8D0zZCF3tIEQMcX+tqh50hIuvW8FfoP4jdXnH1qH7q4eAH2y7dGElS1PMbcSEjCYty/c6CqEv42PCEa1vgPaChJ8sVdYtaFLYLiL9uA3EIP+nKWBeKlKT9eQq1dKa0w8y2mQbsyRybJfBv+GLE8x1m1gGIB0yFbFxh5Q3xAuDSUoeb5tlMOdxsHqw+8KKgzbPiOyGSEkWsV7QiqXcYRKDr3sRAf9GTLuuIXyuWPihRSnG7Gh6Y9/Vl4vDhbCfGo7VW9yTWXV68Ao6oC8VanlnQbqdPSut8H78hFDHIziO/jQgGzVTtT6hdvWoGUGdbsawiCrAXI42wjTU9WF3yKkMj6UOwABCqvd5zFRBwQvQ8hRj8MTgwNiSk1xwE6MbP2Rk8uuTQD4+jNxVsA3xCXYvwNb1tTzUUS55G3CKciJ4i+4BZnb7UewZYgV3hxOdyL/6OEW/VANuSj4g91jD7lgYEpsBnVq98QrIYA1lRvXQGVD6F0MgGMDRwTzisvxldWS0cw7BlUDidU7i5pYA3M3bLkjb0aWsrxYNitMgNzFAfmH8mbnePhKjYeBGqja4nBSwwlGPyzHL1GNPDdX8rLrIF73KYBUdVRdoGwIjU7abqgSzfEa0JpA+yI5b+5kXHtM1jgP/zBIGpwZ+1diVs42pFWdaaAke3/mb1jMtvfTBXPXshrrzmk9IyIqijOyrboYup7JDUmHFNlMb4i
 YxdaRkAo
 XERGmoiGB0PHzd3s+CsDI+FDsYRnH+oCpIhXo++x4porD493CuNte0o6fEW5kQvhXmi3yQCnwhI9IwVtLpBgQswisgplzVQjlsQPh2RB0H//5un9j+tLWaQwZswGQwZzMMc5IcXwsSH/455RG2MSNLybyEJe5weHSdhnhF17B9Z4AAHGArWvAfHMhyrLhpM7NbQhWka7bNWZv5THh7Oeb14P9OBk2VHH9K0jyJpzTjghcmdiRHFg5IOjN7IFJCZM0uOizi5z3a+zZWeioNr4HJCq23CkXqR2nGKISqbiwWmHd5Z1Fg8hs37EnKVb7GkUVjwdjPQDBb+fbyEpHmQIJBOYAuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 08:32:26 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> Currently, when an anon page is swapped out, a slot in a backing swap
> device is allocated and stored in the page table entries that refer to
> the original page. This slot is also used as the "key" to find the
> swapped out content, as well as the index to swap data structures, such
> as the swap cache, or the swap cgroup mapping. Tying a swap entry to its
> backing slot in this way is performant and efficient when swap is purely
> just disk space, and swapoff is rare.
> 
> However, the advent of many swap optimizations has exposed major
> drawbacks of this design. The first problem is that we occupy a physical
> slot in the swap space, even for pages that are NEVER expected to hit
> the disk: pages compressed and stored in the zswap pool, zero-filled
> pages, or pages rejected by both of these optimizations when zswap
> writeback is disabled. This is arguably the central shortcoming of
> zswap:

Thanks.

I asked Gemini for a tl;dr and was told

: Introduce Virtual Swap Space (vswap) to decouple swap entry management
: from physical disk slots by using dynamically allocated virtual
: clusters that back swap entries on demand via zswap, zero-filled pages,
: or physical disk.  Eliminate wasted storage space, remove the need for
: static swapfile provisioning, and enable in-memory swap features on
: diskless systems without degrading performance.

I'll take no action at this time - let's see what the other swap
developers make of this.

Sashiko was talkative, as usual:
	https://sashiko.dev/#/patchset/20260825153238.2695446-1-nphamcs@gmail.com

There are a few pre-existing things in among this, They look legit to
me, from a quick read.  SWAP_USAGE_OFFLIST_BIT should use
BITS_PER_TYPE(atomic_long_t)?


