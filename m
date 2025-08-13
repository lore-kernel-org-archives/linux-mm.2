Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 866B6C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 21:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256AE9000D7; Wed, 13 Aug 2025 17:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22EA2900088; Wed, 13 Aug 2025 17:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16BBB9000D7; Wed, 13 Aug 2025 17:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 057E6900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:41:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92B9359139
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:41:49 +0000 (UTC)
X-FDA: 83773056738.28.07C3017
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D03421C0006
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 21:41:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mE8Qar99;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755121308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PqveZGpJ5FPH8olNM1RByHkAXkThox8vmgZBxmuqo0=;
	b=Pt9f9BB7YJL30M9TKzs3SjKo2mAuO8yRX2PSsmnjS1VhxGi114+NYO7Zr4pTP9tRSqoXQY
	4LDco/09XCPfXrCC2aMlEvorEi5swOa+x5vvLTyTWjTQEQv1k3p/8OA2OIiB5t0+0onfdE
	mIGTvDYv97JmegQ16F0HVPjP0WURibU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755121308; a=rsa-sha256;
	cv=none;
	b=lG1cWF7noZUPjb+XsTz0/pN8X+pumouwWCwkMCBMpbv4fyZoJG9D7UwyQr80e39R+eZYl2
	v0+zW7Pur1pet+rRjvePyZXA9QdUqdkAtBtlA5vv9tsdxrbHeeTU6x2ehHqIYFWKgFJHLP
	YBJTwUk9buzkBsNS3OJUCUoFXEGTXRA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mE8Qar99;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E53545BE8;
	Wed, 13 Aug 2025 21:41:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E828FC4CEEB;
	Wed, 13 Aug 2025 21:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755121306;
	bh=6KOUN/JH6HdNhm0YMe6IlrFj5wMZhwJdq0fhZ9DLOn8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mE8Qar99IrxUWq0u7Xc04KPMLhXRmMS3yOfUzDG2vmP5OhSPvC6Ow5+tsaYKxZlY6
	 wqMhh5RKzkAxv7b3qTD2p38mkewvPZNyyioxp8RLvfChxoJpNL5l1irPMZiZX3Cht3
	 470BetnhywGXvAWECOSx7CWn7S5A9hbaFE2xNjPc=
Date: Wed, 13 Aug 2025 14:41:45 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: David Hildenbrand <david@redhat.com>, Qingshuang Fu <fffsqian@163.com>,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qingshuang Fu <fuqingshuang@kylinos.cn>,
 Yuanchu Xie <yuanchu@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH] Fix the data type inconsistency issue of min (tier,
 MAX_CR_TIERS-1) in read_ctrl_pos
Message-Id: <20250813144145.cf6eece4d1d746568c39bd86@linux-foundation.org>
In-Reply-To: <CAJHvVchDq-p77VbzO53nNxMTZ-5okMp1SUSQfw_VD3f75fFgAQ@mail.gmail.com>
References: <20250808072106.153449-1-fffsqian@163.com>
	<91d72c49-22df-43ed-aeeb-0b93a9da3bfa@redhat.com>
	<20250811214053.857168fd35e70e73dee1583d@linux-foundation.org>
	<CAJHvVchDq-p77VbzO53nNxMTZ-5okMp1SUSQfw_VD3f75fFgAQ@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D03421C0006
X-Stat-Signature: etkotn5wjoic7jpiku99odorup53w5c4
X-HE-Tag: 1755121307-100417
X-HE-Meta: U2FsdGVkX1+dkYIGJjC99iovhQgP1Y+9ScWm4/uNMn1wc1elqKCRTrTdGchB3hFGW3b9/yLFHUAHuE3G6/r8Ahssc4bMbNOaQMsZjbqwWnvBEpMvwhQ3AdenZyYdydYQJB/yEBSC0HckROqBQ/pfhd90JPxR8ZqYQDI0UMcQZTLA6cuIH4rBcsAwAoNNEru55Vkb2w6Afkx8P3YKkcjyHNUcFSiL4n/DjMf4xYMqgsubfZvl3lFQ7tqG4oCNRy7m1KZVtmqa+BtrkWfbzTV6I7pf/I2YSnGKS6oeTF7KnBHKt4iTVJVSFM7Fuh7+VKF+lnsqUs0P0c6UBeCLvn/mSm8WTIO934VWcOn7pl5o5o/ZNk+E5Lu+09FgZqFLi9zQhPldOCvQcYNt+TI1xl9+wmGTVnRpAi0yfeJHQzQbTD7OSJM7jJFdSPKnh695F/eIqKGn2xXBjgb9LXLrYIoURBnLi12KEGSYkQX43ox0Em/bSIOve04vJqMTUhnM2g22ovx193K4qoxlGa0QPX/f5cxsX1xb12wBgr0atEGc75Hh+jr4ICv5sf6tjI+ptfpNKSTU8YeukXFDN+S5JC4rR9zy3YN2D/xySeRTTW9rhLmna4HnrE06cgTUj0EtSGgwMsLpDn54H4NHV3NJvyjLsTF0GoJwus+eYicfQNShCJTSNW0hD/qVLnj9E447i2lXnddmekcSxsMf22N17uaNHfxL7Khllt0anNxL3gxg6P1tp4Me9rC0npHDfz9otKKByYpnM1QM1IuHwEK9e7uFnfRjJCVeXuRo3jjKh69SR+pACtZwsF3CLHk+deazN928R36QwzkgK7NXAHtkTPh6Ay8R6jxV9zSFGtZ2DQ3A3i7+xOas+CsYLexjquWtUghMHChE71TKmmTNTnjc2UL4zboDnlMv19mLDeyVVuh22NbMBHyW3qVCsXG21jH3bNVDNuwn4JL+S1jK//bBmqa
 +c57EeE1
 cYRUeYjQMk5mzs+ZhJImnZRjHlgRPb3ll89O9fRatY4Zz0i9Gx1P+IZS9UA3/TokNmxDvAc2DnD6hB7gSwJdQS3ZfXGAf3YNYgN+Z7i9thdHnBU9YmW4+HuuXiLBgKBPBYEyafiVcKXnpfrw0jfrzsaKjQLO1cgrYxRNT9qUIU3U/GxAGUVDegjp5ArJY6wXiun+F8MDimepDUTTM5MHVaoOYrW3KecwFlAiiE83Gu3xLdB9Ux4u8N4djZ0KDdHi/F3S0IYfjatQKGQ/3YP2BS7picmmUSJn/VJp0dbEyqhzrxUsYLaLBHbm/2qW2RaxX/pg2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 Aug 2025 13:03:42 -0700 Axel Rasmussen <axelrasmussen@google.com> wrote:

> >
> >
> > (cc mglru maintainers, who have yet to reveal themselves in MAINTAINERS)
> 
> Sorry for that, I took a look at adding myself and Yuanchu, but it
> wasn't clear how to represent MGLRU in MAINTAINERS, because there
> isn't a mglru.c, it's bolted on to several existing files with
> existing maintainers. Should us two just be appended to the list of
> folks for vmscan.c, or?

I think a separate MGLRU section which mentions mm/vmscan.c is
appropriate.  kernel/fork.c gets a mention in three sections.


