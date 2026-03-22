Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9202EFC72C4
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:38:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B5486B0005; Sun, 22 Mar 2026 11:38:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53EF76B0088; Sun, 22 Mar 2026 11:38:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406996B0089; Sun, 22 Mar 2026 11:38:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 286F76B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:38:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D415EBB6F3
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:38:05 +0000 (UTC)
X-FDA: 84574104930.13.80DC5EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 311DA40008
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:38:03 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Af1Q4QHA;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774193884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qah9pJ7yuDr102dx8ir6VKbn5gY7OTWI9Ei3cnM1xLQ=;
	b=cbpaQis7Q7pw0QgWHjlurZHvkIKFxMCXmJLJ83doV/i4RPqwlutKh0bG0IrfVZBWZj7JCS
	R6BtQLW6hrNKZpkksEf1MhXANnmCPjewQo/u6ShmMUo4NcTHzX1OFjCn6Rycym1V4gcUVU
	35b/5dXY9GhZTfbWFbPNMGuBlFpX+PI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774193884; a=rsa-sha256;
	cv=none;
	b=srrMUqqaoZSmKpEp88fCoRBOfRmoL4wwiX7PN9aZ4Kq6k1siLxgw+cgQ93g+ReZCmTonwj
	aoKjUaN73oUrnGPFhEVhhisPQaynvG0swyInU/FU5bwbyVRlV/TKapQrNUE/DCkIVorGJy
	d8CxJj36z2cUFuK5dXi4OsxBvXJQHBg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Af1Q4QHA;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A54A4346C;
	Sun, 22 Mar 2026 15:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE6DC19424;
	Sun, 22 Mar 2026 15:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774193883;
	bh=y0hPXErnp0jJB1YGd3VZBlcKEKQOUYHh4D+PsxChcZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Af1Q4QHASgml94Q0H8OhreMtj3xwkmCcgbERL32oSJvQ3kRglseHUs1I4hp/fE6Gl
	 szwmpxDh4y8vdSQhLWXrZ9R6jJoq+u3Hz6Tc+Z8Tda5jTZ0Q19Fc+VgH+7keguD4As
	 upagkf+rPILehHqSG1p57jr2gPXpVJPWONI8+A5Kryqe/dW9ZDzIsDw35+568dWh36
	 sgdy6O6/1iMRaQS2LYUQdyFMiUpyMVMH35LqeGw8UeZzENriVDV0C1rcG63HmFWzlt
	 YYre51qPEIshFDf6ePVEiFxBkv/bDemG3fe55shOQK/z+iwQxU5ppJu4DIed4OKXI9
	 EYPwxjTCDK4gA==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v2] mm/damon: add synchronous validation for commit_inputs
Date: Sun, 22 Mar 2026 08:37:57 -0700
Message-ID: <20260322153758.80748-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322060630.82964-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w1ouqbxpb9qmr8zpduw8zri8ztfchtte
X-Rspam-User: 
X-Rspamd-Queue-Id: 311DA40008
X-Rspamd-Server: rspam12
X-HE-Tag: 1774193883-413448
X-HE-Meta: U2FsdGVkX1+D8hQwFsQp0i41QtsYGxMCRp4sgpOXPe/jLb3KHeiVIYCXkh1NPkwYURNk/GzBdwIs5eNh/x+NsCr7PqX67sfJs84w6qNvchfX52WrSQWx9H8b07fP2Qqa0FnT3d8nbuXA+sm2IW3h7Mt78Cc6rM7j434ScOzEcqAI9LM2iPiTAgnDp1iNYv2CITd/716jk7+KuJ4oEp7A+M8zjh34BpSZQUkjodcvnBEY9KF1XRxcAQPCp7ZxeSx8WrnHEA7zR/Jdrus4G/zFJ4IzxVMhJlRjVpLUN/frefJNoocpEFRI6LEmuseNsE+FZkxwihbxDepShf/GLpx2QG3Oc8CH3btI1AqFJ8QIc+tC+wX7d56KRQd0E54apS1gdcvFY26N6zZPWz6iwJDvWqUAZRCbwZfspviDxdkkODgFyCjUWZBsb1D7nikNDEBF800R08Qwwtb2NJpJ1pIDmqOyYYvlF6dXb+bu1bXzGai+7XJz0VxDUkdpSwxd0PFalYvupoPlB6CJ9xeA553mTlx3zOlkaE2G2odvGtOp6lZjpUVR0LBbNmhY8ntq50erLwJOEfv0xmOwpoyIETKp+HA6vW6FqRjTrmIm01/7sVAyssXzCItc6hDmiA92pEV7aICCR3gvR4+83PwIs/ZrkYRAjKLAh1dibHbLQo9fQvpcT8wpwfcvTR8AthjPXgge/nrMTom9bH/D6HIOBZk5b4wVAsu0G+Pid5FUx4BTa7LH8KcNH4xbB57FGN1f/owvhRFCDrt+dBTgfYoZMMeF0Iu7If2onXczVPOEodEH4NkqQScNKIjj2WDrAB+UbBr0WbqAeYgxEjCGT9xMhGtmknmrFGvmhFG1+7jzzmAks6gG0XvpmEdgBN4V0VCteNy8e0vXzlfdyLqHj9sXYxhtlh5ZM3b4oQYAgzk//vvg+38QFgnZBHwLGZSJBP++oOQFSqjk2WGhyS6Oj7LxHbY
 wyMAuPHC
 cRKmLzx89oCJIT6WNPfWt1xjyQE5DXhPoEzC/bi7Ko9xAEBJu0a/4++Lt0ZXPyu4AFq9llSfqKcRsy9TENPVZO3dFG0iJ+r9IdLC+XBWO+14qcDSZxSyKEpwBZB7n+B77gX9LlUjSM52aPQ48FaBHGH74gPVvX0Kc8CPZdmsMwQvDHIwIfdHn4QZb0sI+iFWfFZc/HO8jttfI2GBSgHNbgW0WAG8oQ0w8bNy22DbX9XEGZvxEQhjuXr3DpLpBixIMbHHNEApuY2TFpWnjpcr0Ci8mMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 14:06:30 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Hi SeongJae,
> 
> I tried implementing the synchronous commit using damon_call() as
> suggested, similar to how damon_sysfs_commit_input() works. This
> successfully returns errors to userspace immediately instead of failing
> silently.

Nice.

> 
> However, I observed a side effect during testing:
> Since damon_call() waits for the kdamond thread to process the request,
> the latency of writing to 'commit_inputs' depends on the kdamond's
> wake-up interval (controlled by damos_watermarks.interval).
> 
> In my test with DAMON_LRU_SORT:
> - With '.interval=5s', the write latency can be up to ~5 seconds.
> - When I temporarily increase '.interval=50s' for testing, the latency
>   increased proportionally.
> 
> I understand this is expected behavior for synchronous communication
> with a sleeping kernel thread. However, since 'commit_inputs' is a
> control interface rather than a hot path, I wanted to comfirm:
> 
> Is this level of latency acceptable for the 'commit_inputs' parameter?
> Or should we consider waking up the kdamond thread immediately upon
> receiving a damon_call() request to reduce the worst-case latency?

I believe this level of latency is acceptable.  The special-purpose DAMON
modules are designed for long term use with minimum control.  So I expect
commit_inputs to be used only occasionally in real use case.

Of course, making it faster would be nice, as long as the required change is
very simple.  I have no good ideea about making it really simple, though.
Nonetheless, I think it is not too late to do that after someone starts
complaining, or we find a really good idea.

> 
> For reference, DAMON_SYSFS seems to have similar latency
> charactheristics when using damon_call().

You are right.  And we got no complain about it so far, so I believe that
latency for DAMON_RECLAIM and DAMON_LRU_SORT should be fine.

> 
> Thank you for you high-level comments and the suggestion! :>

My pleasure :)


Thanks,
SJ

[...]

