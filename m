Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80329CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:28:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7E5E6B0096; Thu, 21 May 2026 19:28:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E9B6B0098; Thu, 21 May 2026 19:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6AB36B0099; Thu, 21 May 2026 19:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9696D6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:28:37 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5CFA912088F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:28:37 +0000 (UTC)
X-FDA: 84793018674.02.A06301F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 91DAA100005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:28:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N500jdmu;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779406115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXwm4Z+lOKTf5jJnND+DA1ISntGmioZE3tfITHlp0PQ=;
	b=rOVLg9IxvWXk/SQ1AKJVqS3kjLxxwH5L/C9PLbXIx4mFjo3sNnwoC688cpkYUcOWLSFPU0
	pnBXblf40Pypr9pKwrr9m5/MRR/jcxoOVJXeUX3bXFBH7A0vJVV6ZHOwYIiU2s6+yK5HKD
	JnHNRANzLoBGsbY4ciUJIDgRUcFGsr0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=N500jdmu;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779406115; a=rsa-sha256;
	cv=none;
	b=qy/L6kcLbK0j7TuYoA8/LNeDPjFnuc5L0oVcosy8K2yMunz8kuZK6krwORlMk5ETIupi/f
	1qeQLeT2L+CXy0PvGRnl4MCY50SRlUFKpeKdtMGdvzhMmiCz7iR/LQYk1yahIpZzfuRwMM
	+vxrSoFDCjloh5EEIxl6OobwQg2VqtE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 027B260122
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D581F000E9;
	Thu, 21 May 2026 23:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779406114;
	bh=DXwm4Z+lOKTf5jJnND+DA1ISntGmioZE3tfITHlp0PQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=N500jdmuy2l3Yh1vlBN6mN19yeYCQxZGfi40jmvefZyO5xqJP+LzquyrEG+DoEL31
	 8Kqi3SrUGx1gfYXmIEpE3dOA9CH31yE1UDk2BAdrIdQ+6AWkO/f7qmWO8sBXkIm14d
	 WrhZE93/XqBOnaT5m36LnW9Q+bs8pd4h4G9S9UGI=
Date: Thu, 21 May 2026 16:28:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 17 . x" <stable@vger.kernel.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: trace esz at first setup
Message-Id: <20260521162834.d119e280e3f9c20cd596d197@linux-foundation.org>
In-Reply-To: <20260520150311.80925-1-sj@kernel.org>
References: <20260520150311.80925-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 91DAA100005
X-Stat-Signature: s4okqt7tczo1bbdq6wocykcmn7b4dk4d
X-Rspam-User: 
X-HE-Tag: 1779406115-83694
X-HE-Meta: U2FsdGVkX1/R4iVZoFsK/pZfMGxCI0NDQsiMMMZcg4PFe6NXyQtsWOuabDUwepWtvjtYCkdSCpT4/gFJAx6OH8KJ/gVfsJmRwl69cJXLeDqoSe6if/9xlaDuNi88ghjX32V5bTeYjrqbA5JMqmgBvmKsXDMRRh+RdHORRxsnB8ymd1s2I43peO2RyK0miCXooSQ5fqXXgI0yibEH1ELnWAAnMeU9YhwOpMyQGdmp956PaegwDhuk4NUDKA9PPtBuDwUL/KpCJ7DCy1S3DzJZZ5SGeCtTGRIhtuflIJtYQaTGqua2pHCdY0wldvUCYhUu54pGcvbDlQckrQkmCT4j+VsD82VB8vebi5TOYpY3i1ekyEIBESvvrn93Xo1NnuGzGnkGw5JZiBlf0KThlor8CxjETIGQ4dQ7W8MCebVQDMjgdn5ltHmN+clZMDSR+WOQdq9eXI09CtWAuJzPqJAOsJIc531s2yDV7kGk5XdQf/2NWxd17vmj6nMId6aMF8x+sBQP6OW8EqSg2m072HWlrlW35vZKBxU7T3jLwW3UysmVP6gH0oxFq01svBR8Hcm6IHKbQ6SwAap3DrspJd4VURxSAmrRHXSWVu+9f/k1IjIs5OWyUMSYFltOjVjEYTOgm6ayKOx5F3Me1jj0drGbCisMiLIgkoE+FOtZ1RlrIOEfbMg35G2PzK2V1n2M3XgVM/WB39jci3CCJpXCGGkuLQsKHj2wgnpY4pSvIq9s0yDnbvF4UmUEVY71L/wulifM8yTWsf66IIz+Oh2gki8KVnzerA11Z77dY4TKsqLaQJoKZVT+4IBWK4pg+KJixxew69MTOuSSSbbtsU1FC5oBV1HP4HtcTalxQahgbCMKd/U6IMH3AqCRBXw+3eNOKVSuQiCFvf1+QzaqLX7tpUoIgLUsYfmWfRjc46jiP3MMlAukBqNUkN3Fb5m5+ZKJzjkhzv54amrIghRbZAo3+VL
 /OnZlY5Y
 GNAYwkyvbUs870vJgyLAlja4NWuEvUO98GiUk4xk5E1vgokVVnnPQ0gGtCHwXhLUK93UuucRQWwbhFVarwbvnApqOC8cnQZ6Dvzyf+ivlHfpwICevQgPHI95aZCj2UxAnd+evoqiIN841knp+8seCCGOWYCFISC7KuILB63QpnIitt4Qzh2m7mzxzTalwGkTDxNYx4WWrnrEVwjW+a+Qt+QNmfVNRdXQ14zCxzkWjPiUfnjf/BUK/gX5NmpVnn5OskoP67vE6tXpCJuvmWXlNVz1Va2Pc1mQRnpAa/JIvXiPnIH6Lju5xueHx9CzvrSzKGfDJUfUUxWUMU2d5/gzf9nWfag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 May 2026 08:03:10 -0700 SeongJae Park <sj@kernel.org> wrote:

> DAMON traces effective size quota from the second update, only if a
> change has been made by the update.  Tracing only changed updates was an
> intentional decision to avoid unnecessary same value tracing.  Always
> skipping the first value is just an unintended mistake.
> 
> The mistake makes the tracepoint based investigation incomplete, because
> the first effective size quota is never traced.  It is not a big issue
> when the 'consist' quota tuner is used, because it keeps changing the
> quota in the usual setup.
> 
> However, when the 'temporal' tuner is used, the quota value is not
> changed before the goal achievement status is completely changed.  For
> example, if the DAMOS scheme is started with an under-achieved goal, the
> quota is set to the maximum value, and kept the same value until the
> goal is achieved.  Because DAMON skips the first value, the user cannot
> know what effective quota the current scheme is using.  Only after the
> goal is achieved, the effective quota is changed to zero, and traced.
> 
> Unconditionally trace the initial quota value to fix this problem.
> 
> Note that the 'temporal' quota tuner was introduced by commit
> af738a6a00c1 ("mm/damon/core: introduce
> DAMOS_QUOTA_GOAL_TUNER_TEMPORAL"), which was added to 7.1-rc1.  But even
> with the 'consist' quota tuner, the tracing is unintentionally
> incomplete. Hence this commit marks the introduction of the trace event
> as the broken commit.

OK, but...

> Fixes: a86d695193bf ("mm/damon: add trace event for effective size quota")
> Cc: <stable@vger.kernel.org> # 6.17.x
> Signed-off-by: SeongJae Park <sj@kernel.org>

The patch is marked for backporting but it assumes the presence of
"mm/damon/core: make charge_addr_from aware of end-address
exclusivity", which is queued for 7.2-rc1.

We can either redo this against current -linus and fix up mm.git's
"mm/damon/core: make charge_addr_from aware of end-address exclusivity"
or we can queue this for 7.2-rc1 and you get to deal with fallout when
-stable maintainers hit issues backporting this.

Preferences?

