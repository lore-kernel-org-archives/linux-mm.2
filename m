Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F19BCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:22:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08248E0007; Fri, 26 Sep 2025 11:22:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8948E0001; Fri, 26 Sep 2025 11:22:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7DF8E0007; Fri, 26 Sep 2025 11:22:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C25018E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:22:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83DFAC070D
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:22:00 +0000 (UTC)
X-FDA: 83931766800.06.FD83279
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf03.hostedemail.com (Postfix) with ESMTP id 121C520012
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:21:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3CruHusi;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=b6etWZQZ;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758900118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2hT8KVPsa5RdyiLGO57N+TwGOktseVB2WsDCUc2zYvM=;
	b=WD1TXbD4+9KsMZwMLOfWq37yxyqIRUAJl9TVBrU/7qX7gIi05+Wb3jfTlksya5yXnh5GpN
	FKR8rK8heHIJQBlJmqmMw/U3Hd3+JqZWvq8lazQXPAo/G0XDb0sRlwsCe64xLO65GFNOlF
	epykQwCugv04+N2ea4/Ng7vT1FB/44g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=3CruHusi;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=b6etWZQZ;
	spf=pass (imf03.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758900118; a=rsa-sha256;
	cv=none;
	b=7bLoTdfuyDhfXU8DAnTpSZmEZzEF1Vf3Dc+tcfVfq/Ylv8D2RGuukKk+cVwszLrsfxdYX0
	3aw5Bm8f/eUbOfEfXa1N5yj/NnMbnGQX/J/OjWBXG6yK1HFpKsFJ01UmYv0/VP0R2wL8Nq
	Zhwe7JLk09uHzyJshdXj+vszhBQoc2w=
Date: Fri, 26 Sep 2025 17:21:54 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1758900115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2hT8KVPsa5RdyiLGO57N+TwGOktseVB2WsDCUc2zYvM=;
	b=3CruHusiyg2EWDv/yyHV+xL4uFZcsh4h/eNehOGPH+F6oi1D2lNfRT08nJnTw2b4O+y6dF
	UDbv/uFp8c+ENIV3MpoQPp2G2gcbLizhPBmWuFawOmoXCU6HQPx2TZFzBJJBgxPw0I6A5b
	flTTBflg8kh92/rKPKtX13AWUhVRuVl/nHMyBGwrhFhapvdx0+tN9P43J6ubXf/q3/VeaF
	CPwqNcdh9BgW14C5LV2NQULF5XwKyT6jIVpOX6SU2roS/2/cdn2ljTW1eys+q+xMiyL2Vv
	c0fIMNKPNhvMd6vJPg+95auXtVqsw4AVii8g9kJkupMd/OYwwBgTs07hxo0MVg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1758900115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2hT8KVPsa5RdyiLGO57N+TwGOktseVB2WsDCUc2zYvM=;
	b=b6etWZQZE0mgEcqodZ+mRMiw+zt/etkTESdj45IN8C72/j2AFv6hU5rLJ+r7G6uUbAY7Kb
	Xg+pO3X486C/BUCw==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Edward Adam Davis <eadavis@qq.com>, kees@kernel.org,
	akpm@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, david@redhat.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH Next] copy_process(): Fixed jump logic error
Message-ID: <20250926152154.MYtjJh-Q@linutronix.de>
References: <tencent_5E4F978D9525A58D97925ADDBADDB2193107@qq.com>
 <f6777d66-a55d-46ef-b972-951eb48337b7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f6777d66-a55d-46ef-b972-951eb48337b7@suse.cz>
X-Rspamd-Queue-Id: 121C520012
X-Stat-Signature: jd3bhjjgua3m194beoqtosoibedxcsgm
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758900117-517817
X-HE-Meta: U2FsdGVkX1+xf+SOfqsdYJoZz8IjZk9Ccnl17j2WChJAJbZLmBSV/poXpE4kiv7DHh1MBElRe3rohzmr47nQYuvgElcAIHA9pKq8XSAMnSLcxZkCj+8wioL+fZ/91ix6C/TiwjCWjmN3BcHOLtuJzU+gMTPJU8QKwjs/YE/rye8M7acr3TIDfSW7T+uM38uL16hdZ6OkzMkYottqXf3ijYgyWmXgAgQ51Q9on+khyQOzgVOYUihkm5ILsVFDm5Smzdrx5ANHlNi1yXtpnWgcZr8vs6+4Hng1j0SC+/3iR/vYmxJ7slfmj6y0VvEFc9Ky05I8nqNi/p1Cf9NW9hA2hvbHdpjuUeknJXPo0cBEVk+e+XF5hpGu6c5DLXzC+Do/YMHGUivxd34TD28QmgMVPxqcGcU6f6tlgcLtoQyscwOKJXbtkIPtTP00FGPFsfWHqM0KsyRFypqw3i5iMkb9qonZ+ZS2uN/K5nAjhPgmw3WYmXotOs8JnL7YB+2HKqVDHD7Y4dhL8FPevlAmCuOsHx0AHzJcLDLSXzcj8XXepg5F9hn38kx6Xl7hCd/THmiHi6Es43BtG6ZVo8UN4CbIr5cJyaY25j7wWXryEVN0mPUpjXM2vEWpKO1c985HFN9DtDOdyjZRO7+x748LO5D7R/MCLciAmGX1WgZrxtMQHF8IaJJ+5PksJ3K6m04O/pD532j7xR1YmBbmWiCaLxIIr2Vk2azEUhUjBcxrApjvnm5zEDeVveRj2YdKMEi5WcJ+UXc/9unRJ4ePRPvwTe02W0oYEjGI889Q7vJ3A4S75SFoZZKh7Ozr++VYbfVzEHA57w+p6qOyNqtX4iGNwHWhXhxft9wAWD6TZXBacVRBOg3aE0Y29x0q966tx2RJ+PGP4leFwPCkPWRLEl5pdcVvCe5loRUw9300VkEz47kJzyFOOoy9I76fB7S2coACj9MtgCwkyqcGj/oAhTXUXRb
 Tm/xdaQp
 /SsT+Nle5j/bdfbV04QI1BoW2hXQ32fH6Z5U2Dc7Yj3ZXy1Jlk5OFaF8CoN40Bxm7v5eOWctFAkFGbU1W4x4iqFQNi+qhUXslVvONWBywuEzdugVhYiGStUPUOHNzOAdridNW0rpSx4Ji9OEW6nEGsqvQsaYfHlkYwQedEtZ+Aojy9z/xtlk1NoiH3NZLDFfZ3B0PUYN/CRtia5CXmEDMoCT7MmZrvjzUpsRcAq1nxeA/WkmHkOQw96yTIeImIQI/zCoLwmaNBmeMZFc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-09-26 17:11:12 [+0200], Vlastimil Babka wrote:
> On 9/24/25 14:06, Edward Adam Davis wrote:
> > After futex_hash_allocate_default() fails, the logic should jump to
> > bad_fork_cancel_cgroup, not bad_fork_core_free.
> > 
> > Jumping to bad_fork_core_free would cause a siglock imbalance.
> > 
> > Signed-off-by: Edward Adam Davis <eadavis@qq.com>
> 
> Sebastian already fixed this and it's in tip: locking/urgent

A pull request has been sent to Linus earlier today.

Sebastian

