Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F5DEFEE4EE
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 18:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A9EA6B0005; Sat, 28 Feb 2026 13:58:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E116B0088; Sat, 28 Feb 2026 13:58:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339CF6B0089; Sat, 28 Feb 2026 13:58:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6C76B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 13:58:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C0DDA51986
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 18:58:32 +0000 (UTC)
X-FDA: 84494776464.06.DCF9258
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19882100002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 18:58:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oruM4hTc;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772305111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qY5po8ot3Fjch9UYQBxDVJzfu//ttgsiwJAO7SayQoM=;
	b=tEMeQ/ipWFqLhTJWCToz1+0DfuXJpznmy/XF2fZ+8KJ0OvoffXTJe7/xhIvLAP/JiN/5Kj
	yzTli2Z8FJ1KgXvrt3tkDLDHjCdQm+xGAE3i+yeO9Z6bsn19cMZa2S3+EhTsDgWaLj2mLH
	VkYwha+9WDQ+dfwJAADISE79qRTCX/I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=oruM4hTc;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772305111; a=rsa-sha256;
	cv=none;
	b=8NzUgOSEu5X83teECc7R8669PZyPseCVduGa5QmGCtBI+VYquNvB5C4NMsA+6j6sGm2C2t
	vD5Y15JMeiN1xlZ38IRNOZs9rxgwzirAGoDVOAzaUUHCx8H0Q/OMQpcXsc6M9hsTerAhJi
	JqLZl/2JXfrQp7AlJqBF68mz3UJd0+k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6215F61344;
	Sat, 28 Feb 2026 18:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED08C116D0;
	Sat, 28 Feb 2026 18:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772305110;
	bh=PVJ8xGUP0hvJcBF/VoFPVYjM25XHcE1Qvl6tuLGWU14=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=oruM4hTcXifAYrBU7Zr+gWGR2kYzQ3H3DYeRPfO+p3EJvtjhhfiO7nkywQxMgB/bE
	 Ec9ZjWbZK9B5mBOxRvtrij4608SEswjLURkzt2FxIcClBU+xVQo1cIyvznzDKssxan
	 zT6Or8B/F+NEvJf7alPOEpZ6QxpiZpOWwGsA8Uwo=
Date: Sat, 28 Feb 2026 10:58:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Leno Hou <lenohou@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Barry Song <21cnbao@gmail.com>, Jialing Wang
 <wjl.linux@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao
 <yuzhao@google.com>
Subject: Re: [PATCH] mm/mglru: fix cgroup OOM during MGLRU state switching
Message-Id: <20260228105829.984f06aeaf701487036ac992@linux-foundation.org>
In-Reply-To: <20260228161008.707-1-lenohou@gmail.com>
References: <20260228161008.707-1-lenohou@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19882100002
X-Stat-Signature: 9x5wt8tkhwjjb3y5ap18po71xhh663io
X-Rspam-User: 
X-HE-Tag: 1772305110-590190
X-HE-Meta: U2FsdGVkX1+BpLVf5jxAqESBh0+A006sfgiMu2YFJ7H5BEHNiabjQSAdJojgYHfbW30BrhQI6Dnk3CPFqx0oz1GVVy4iVbpL9+rLSGD6zjCCzd8l4eoX/wf0jFmtv4pkQSQzuM0xnFFxS9ag5k81Ky9fZLQBBWielKBR7TjnI8NEkq4DRiCr8FgQhCig8qKckoMkhc/INLFCI5uerHsGOgUeooTARAlbIJUvCwbAtWZFdZc2kaYOr6srUgvT14fzEK0NNqVQK4Syhv1nYacuLXmDA5zCZ074/zuc4GCAqaq16a/ALk0ytTUfqwkFxh+2L5FCLz46BNpcYLFZZgGDKWmlqAQgZx3m+E8FRwDkewGVr0pw5PeQl7+qqriGDRDDdayHf5j3V5kbEgDU+6k918IlnWQfZEfpMWp7/e3InD7QwzoyCfQXIdYV2Yt+OH7xqh3DvpxdrxROaJU0++1gA3ktUBBz2rNySG4ZhgakWiETyZhBEHodZqzBBubKQ2ssc+/mJ0VLsJ/w/rWqK2aaFyGN3sfJoVFfb8TjqENp9BaY8dI9O/tyAbCG3DNGHSPXy0NBmfZdxtng+cIdkkt08VAbPmFGMZahKOnmQVxMC550DTozbeETZemuYISS2ZAbz/HHgKXbSnPMtfxBYLsISn+MVZIz+vEDBJrdabYHbQZxFi9umMkbq18df+RuxL0FRSSWODaHhAPSDoortBOVOJgbJONOSaUoiLzgoLxuHQy7HW1B6wheUZmHWsXrHORhZ/VfouLogZQeWAWOqReBvHh0Zwk8WgOOlsBalFq4Dng/TOCyLpwPjvtvGdD8AkLB2X+jiakieGGNPI5wAmhCPxVxkia3OOnP+n2acHegNepX3gLaFGAv0jjGaP7ByGKLUVmGeATQXUH9Q2zUtLsMw0LrsdkRwfVwl9fyokYcjy8D2Xh65kGLIvsEX8aabQVK32gl2L4wnDK9TNYa3n2
 BBd2fPPs
 285lbdRc5wmErDIJnJnXaMU7Qrid4vbs5wiv43PwML2nZKf4aIvuuspoXAOG3nr4l/4HurDJUtA23RBp2QjcTvuVegpYpwdW9UxVSS9qb2D4xhhRhgm+DTQklx2RrFf8eG2VyLugCZcqRqUW1yYYbiMnJPedtdQRX+5nojHIj6g3Mmii2C1jebtOR48DtLvHfkh8FVgjFkCjbyFkY8YbvTqUfqvD8fD5iR7jlqg9LrBCTAgtiSWsyCD02aZBnGQsOF8oyh3z5UXZ3LvEh7Warnv6yrY5bXZfkaqWezyBd7p7g1fr6vjy4g4snHVdpmOulz5+SuB6m+6qBFJqQ2tSPXhVmfgb+gTmm0Gz3LWKdOmGNur0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun,  1 Mar 2026 00:10:08 +0800 Leno Hou <lenohou@gmail.com> wrote:

> When the Multi-Gen LRU (MGLRU) state is toggled dynamically, a race
> condition exists between the state switching and the memory reclaim
> path. This can lead to unexpected cgroup OOM kills, even when plenty of
> reclaimable memory is available.
> 
> ...
>

Nice description, thanks.  I'll queue this for testing while we await
comments.

> 
> Reproduction script:
> ---

Please avoid using the ^---$ separator in changelogs - it means "end of
changelog text"!

> Signed-off-by: Leno Hou <lenohou@gmail.com>
> 
> ---

Ditto.



