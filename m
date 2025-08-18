Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E6D8CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 23:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4CE8E000C; Mon, 18 Aug 2025 19:01:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD028E0001; Mon, 18 Aug 2025 19:01:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C2F48E000C; Mon, 18 Aug 2025 19:01:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 293F18E0001
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 19:01:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A14621401A5
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 23:01:50 +0000 (UTC)
X-FDA: 83791402380.28.3B89BE9
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0D8662001A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 23:01:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6P9ffV6;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755558109; a=rsa-sha256;
	cv=none;
	b=kCcF5gBGBofBqnPJyqOdz1T0NhhnqXa2VJDJnIkUfzQ+tPliG5WE98sjoUU/EIUmV6wCSk
	yCEDieh5XLRAnvFsXYkYr8HIqD6PqCekcAcwZOVON8b4DuvYO/0RkibsxV0RgzJMX7ZBm0
	JG7/3nbvzFWzRf2hxz4wguG23LY4BmQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q6P9ffV6;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755558109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kowF+KiRc68d5H1kTELK4R7EX0agGAL9Fr7yAq+I3+w=;
	b=yHttgd/aiuKTBrRQC7R/wQYppqtkMbJK3fGCotlMQZuYXsxdW/firCejqeHPoZ7ikFuX1b
	ptYi/SJYZGt5/hjJXKyUPEBVTC4t7QXNvBBoEXKbXJ5U9h+DPGCKfEaYFkknpmGtlJEZv6
	Zxhlva+o8mAuxccrVnGrmzO8kD7xGHE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 0DF5C5C5F4A;
	Mon, 18 Aug 2025 23:01:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8864FC4CEEB;
	Mon, 18 Aug 2025 23:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755558107;
	bh=e3daVw9VGOXj3R/V1W0E5XdXB4FzvZf9+xPmzhbSgJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6P9ffV6a8+xy8VK8inrRcDrU7sh4cLGHJvj3DBzBzEJi/Phxuq4GeIEFYfyLR7eJ
	 EoN/NNte+BRjkWbshztJPm0ed10d0ju1uKqJWadfmwcSUF/oI0TnvNxOioz2qJRHhX
	 1TZ7NcpGWRX4YcKpM8BmgtlMl1qJ1FZkPyivLc0e4ow9zkGYPiF/+VuWDsqr0Dnupo
	 n/23pLs+Be6vFqYX/RZpCzyicUfRbvoqsLokfEXG0704DNcEj6NbPLW1wZDkpGmq18
	 gKVDeGn4aqiVkO+FA9mfz5mB1k/QmpLc1g9Mj365pAWUrIeR5dCGsVpwi5yJo7tBuJ
	 csi7m+gdtGEYA==
From: SeongJae Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	honggyu.kim@sk.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: set initial quota->charged_from to INITIAL_JIFFIES
Date: Mon, 18 Aug 2025 16:01:45 -0700
Message-Id: <20250818230145.4056-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250818183803.1450539-1-ekffu200098@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D8662001A
X-Stat-Signature: aea41rcykmx87y5w9ed573j5zwf8us6t
X-Rspam-User: 
X-HE-Tag: 1755558108-713609
X-HE-Meta: U2FsdGVkX18vfdRAqlclsoB9fqJp8gMu3PrIVVw2F4Fwy2S36SEwqg7TvKNRLHX60WZfDy2QpehlpL8J3LRpbpPJzgksH954uYNqt7X87RKoYzwUlAMO41oxBAC/WwUgZT9H5om2J+xyTqx84pAbMMt19ghGyZG7ac6gHjMlxIPEE5YfTbIF9SpsjZAGIIB6VmV68zyuf/80FQSTrLufLtkMLwiD8FdyUm9IOwEUZd/mVHtSvaVoAZ63szbliCW1F61DjoWfUXC2yID9UEAExQ+hQbRfA22EfVUlq/n2jf/nk/LjKPHmwWIUdcPuOwnrK89GDJTzLBOpo43hroIb8//PnicYqWF0lrTKTtFovpQciLVXV0JgjbUvNQ4dP0SMzN50+RCnBZsbSXXjnZ1EXieyYeSM25QcJBtwV+VGKVT1bj3iZkF87+XayH5OVa3/CkqUXa0+f7L3Gqlt/S/dsZVgOy6GJlam+xVfanNe8W2GgpAycyxltHwFo1PdPcFdlA/r9f5u9SOSwfGtosvab4f/d+pP97cucFmCgaphyZifQ6+uwlQykT9r377MtosEsGjxmvOKg3vqWYDtooh410QSw4jmRy0z4M86Kh2es6Ky3lNMcYmO5c8iMcAMSAAPUObAdpZUxqVmE/A9LYFXTXvQKBWzoRmQ+fq2yw2Ljz99kdw8zIU9NosC/cMfpv3kw7U+dXQOIgUP4zeqKq5pz//PeaMIDivFNnVz2iI26YYVTPwjwIk0NsutPt+mPjMxuejnnsyaLNITuBAeF+EGvlvE9miHNm4vryifmz0ejy3v+4pGsnUF1zZjZRGJVPlv+KAYqxgbRfuy1O6BLWqXeUyxTAQVcTPAifhhDMlKjebG1RSqr855Yo1hhUFmRjJbZNhJZQFl6REtU+U0YSwMDLWy0nOW3NgsX5Dzbiri2Wtmlxnk8SVGvUb6Q6hmmfems6Awv4/R70zd577zIYx
 4bIeF9qi
 SXGCwiA4JE1k4xd0IOe3gEUaL9GNro1lsasXt3TuirZXEJeML3M/XNRkVuQErhpgrSzA7axJWfm71vJxM6igXB5C/Ek3Co8qdz1wLzGgvDjIR/y9WUSwpA7GZNFEchnGoJM4A8zMtqwZ9WQ8kgE4kbnIykrhnrRxzhVr4VGLsNrScmGmS5G2ftcw+hh76EqMD9yrIzpZJhoFFb8VgHwI74Wq6x+mynWLPLqiIjo0Ocht9xh7O8FB/AI9p9lvG5Hdl3rUF7EX1tLz7BV4j7GfJnu0t8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Sang-Heon,

On Tue, 19 Aug 2025 03:38:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Kernel initialize "jiffies" timer as 5 minutes below zero, as shown in
> include/linux/jiffies.h
> 
>  /*
>   * Have the 32 bit jiffies value wrap 5 minutes after boot
>   * so jiffies wrap bugs show up earlier.
>   */
>   #define INITIAL_JIFFIES ((unsigned long)(unsigned int) (-300*HZ))
> 
> In 32bit system, if quota->charged_from is initialized to 0 as it now,
> it will not adjust event if reset_interval_ms passes for the first 5
> minutes.

jiffies is unsigned.  Hence the initial invocation of time_after_eq() in
damos_adjust_quota(), which is the only place reading quota->charged_from, will
return 'true' and the quota adjustment would be done without delay, unless the
scheme apply interval is unrealistically big.

Please let me know if I'm missing something.


Thanks,
SJ

[...]

