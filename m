Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DFC6FF60C8
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 05:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98C756B008C; Tue, 31 Mar 2026 01:02:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 964026B0095; Tue, 31 Mar 2026 01:02:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0E56B0096; Tue, 31 Mar 2026 01:02:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7935D6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 01:02:35 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BB551A0B01
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:02:35 +0000 (UTC)
X-FDA: 84605162670.13.33E08CB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8EA918000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 05:02:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sw09ypaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774933353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eNLqZAK4jJFc0GrnUg/ym/amqe0AlLo48TqlEL5Vta0=;
	b=MmVc0YTnlWGpH2EsO99MZfesuJN0mhY/bZXQ+7gkK6pyREXntKnMnGZ4CksK0DY+KxYE2i
	a+rJvzRkmLNXdyctwQx8QEpH8jYRa9Z89xyRf+Nu8lt1vjzd8xdDx0FzlWw05h/MSBLdCQ
	m6H3JCn8EVCPgOhdADT6bxbBD3/xK98=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774933353; a=rsa-sha256;
	cv=none;
	b=V3/QyxdWNlKqsPhmPShKQ1xxSUz4tIQoi/BzJVjOdtx0u4GPRYq2Lx7+pD92VH1TJe/V0w
	G5uU1e2m0rTgPugTfXbtYzamZqRqrS4EYqiciXMwDgQDKIBWXKx5TJWANf0DKkfQovdQsU
	6x5T3kD7QySaO5l/d4jcAnGm+bOfCcM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sw09ypaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90A4A60103;
	Tue, 31 Mar 2026 05:02:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11309C19423;
	Tue, 31 Mar 2026 05:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774933352;
	bh=KMlHZ1xC3+1qBF97/gsnz/xHHgFxmdj8FYcgvWX2MYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sw09ypaHWUA8uM4PzgO+K/kuvQSK1dnFg+80G3CCrE5s7bN2Z76wdJlQtgHmuHCRS
	 X9p/u2b51sG3KZbmBtlpuV/JL8rJHmxQN9F86ZtaPGOxNugjOAesRAhMCgdq5zAMUQ
	 jO3QBdUBpY/48mUvSRMAoaHliVOwoNSwevRIGiinhm6nuCGonTXuaaolQ8hd9/2Ult
	 Ab+tyCBs5hrrLwQH1wz1RpSlSzRW2946B3quPDRttOWESCtAmTLEYmuEIU2glu4iGe
	 7ekvtKHHadgMz8pOfzPCAc8Oo/VGDScvx8DoPQSAQDgyoOAaXE+NZSd/gLC6LdMh6X
	 lIKg8swQJL0lg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: reset thread status parameters upon kdamond termination
Date: Mon, 30 Mar 2026 22:02:28 -0700
Message-ID: <20260331050229.67637-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330164347.12772-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EA918000E
X-Stat-Signature: pdu4x45qe7w3uxz8ero1p9f3wokq1c4b
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774933353-848844
X-HE-Meta: U2FsdGVkX1+U5ZD9AZby9beXEUcGjeZ2f2+0v4DHR1qAgPyt+V37RR/636DpHGKHmJzYCL/15EsYM3VBn00Jv7xGTdfvMn5TT4UIT43BgM+3zkrL/wf5TFfZLBf393WjD5cQSCxuDEsOz58ixi2AW3w9KA8K+BYpg72olEMriZZ7x5gaPBBRQcW78iXnMf0ihLQlrhyPBpIvf9GNFU93doaRlf7qvrVYLGzjwVjjc6Zpi1i08NNMxyf3LPXbNhgnhfTS0l/iHnBQ+LgW0qwPtUjUQVLp6iE3WYMfkJ2tgkEQ71JHpiT/g9lOLnewWt8TLq3GxgjNAtQkKnwX1Sn8aXo5HnWlUOfasGTfBMmX3sLHHU+yDTrnMJ3qvWViMj4nL9iyHdA4Yy8b7hIn3JbhrEYtV0uoY8vtFX5zVhkIX4Pl7pfhpEJHCUl2QJxdzrQfKFZ9JjH5TKzbz1t7zX64xXndJhUpQhdEbdrKnbmZ2DGNsPhHtZKr+wpRf2YfgNNF/OArJY9amdghte43JvQpJSS7aY1F1RgbMu+YSK2U3cxvuTWY0Uv2pxicvvfZ/3jzFbVrr1xuU9UlejaJ/woMBRdpmRqfyIi3kzwtebp+Tgiuymipr+YEzBF5zGjiwq6TwHt/KhWyNAQVfTSMElz6WjlGLtXNalHHRdwIJWlzvwfc+3hng1xf4cssM9TXY5CN7af5vsOm+gV/1kPYGBV4Rc7SYIX3gXyLDnbDZ3QopO1g7izJRxl6O93fgn3bGIEmPLqoMEZPkjF1to7qYqafh4ddW2E68KhqXb9Lw7RrRxz3nKwSN2pgZQgYJDb21+2kRbePU1RRN68MYtHTWJh6BTSoy5RhORvTRguXC5QnQeMPpc5/Iac+wHrSmvOndJbC584vusdNs+waR8Wmn3PoJ/w2uhS9yqg1jB6Fu+ExrzJazVrqWl9hLa0dHGFberlzfBP1qiIhRIPiFOaBhO0
 BlnwYTTV
 iLqwEO1WX/5fxati6BivRmeAIkHgweHExkoMOhEReT/fbebi9E6yfhyemGSu2jnYXcFiHiRU82hAsPw2hJiFI0vqjDYIrx89ypbPWuEElii6B4DPDkuE1+vhawqAV4bU+JU4m42ZhZ2NujvGmFn2Ze+fv+9KWMm+QdYkFnJin76zWLozYfK9iGGXlYveO+X41CP5dWljc7tRr1owaGa0OT7cq/oFZcZesQZz+e9oOsCvi1M4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 31 Mar 2026 00:43:47 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> kdamond does not actively modify the module's
> (DAMON_LRU_SORT/DAMON_RECLAIM) 'enabled' and 'kdamond_pid' after
> exiting. After an unexpected termination, user will still see 'enabled'
> as 'Y' and 'kdamond_pid' as a value other than -1. Furthermore, user
> cannot restart the unexpectedly terminated kdamond by executing 'echo
> Y/N > enabled' again.

Nice catch!

I guess this can easily reproducible?  Sharing detailed reproduction steps
would be nice.

> 
> Solution
> ========
> Introduce a 'thread_status' structure to link the internal kdamond
> state with module parameters ('enabled' and 'kdamond_pid').
> 
> Specifically:
> 1. Extend 'struct damon_ctx' to include pointers to the module's
>    parameters.
> 2. Initialize these pointers in damon_lru_sort_apply_parameters()
>    and damon_reclaim_apply_parameters() to point the respective
>    module variables.
> 3. Implement damon_update_thread_status() to reset 'enabled' to
>    false and 'kdamond_pid' to -1 when the kdamond thread finishes.

This feels too much extension of core API for a problem that can more simply be
fixed.  Can't we detect the unexpected termination of kdamond from the modules
and update the paramter values accordingly?

If we cannot due to a limitation of the DAMON core API, I'd like to extend the
API for letting the caller detects the unexpected termination.

Because this is an RFC and I already have question for the high level
direction, I will skip code level review.


Thanks,
SJ

[...]

