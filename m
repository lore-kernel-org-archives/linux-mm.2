Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C740E8B38B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 02:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D1146B0005; Tue,  3 Feb 2026 21:25:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57E916B0088; Tue,  3 Feb 2026 21:25:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D8B6B0089; Tue,  3 Feb 2026 21:25:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 32C7D6B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 21:25:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C9E7C140645
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:25:49 +0000 (UTC)
X-FDA: 84405183618.28.6ADB3FE
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id 37B334000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 02:25:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of yunjeong.mun@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=yunjeong.mun@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770171948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RTAFkAayxmZk0fM9TjC5eT3JeaY4mHLqbu9KWtXFnio=;
	b=KkmCUua1cXrnwhel3aIJZjWiPhT+DaVSkdCAjainjWWhK6iPspD9gcAqQZLIHT7HNN2t2G
	G/ozyuCTBGkhuqRhfhaYt/6+la8E3PGX6SHnI5DkghZ5wAZBAqvUvuNt72kLSBDTkqCHnW
	L2kXYe0CTZVDx6P52lEIAqylPnr7kzw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of yunjeong.mun@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=yunjeong.mun@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770171948; a=rsa-sha256;
	cv=none;
	b=lmqwyyl8k749X+ejUAPDJVHoBei56iGk5AnluTxZM3Cc9Cz/08fDnW3zJx7ibuTYm0zJC+
	WedMwfPgj+RdRGcTNtRBw5xavZnvu76rKpXHiPBnWxRzS+FMZtfsw4x4g3wnLrXdzMO+HD
	TFRephs3gmaR4NCUOSnVdAI0xp42Eho=
X-AuditID: a67dfc5b-c45ff70000001609-89-6982ae246dfa
From: Yunjeong Mun <yunjeong.mun@sk.com>
To: sj@kernel.org
Cc: honggyu.kim@sk.com,
	kernel_team@skhynix.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com
Subject: Re: [RFC PATCH 0/5] mm/damon: Add node_sys_bp quota goal metric for
Date: Wed,  4 Feb 2026 11:25:35 +0900
Message-ID: <20260204022537.814-1-yunjeong.mun@sk.com>
X-Mailer: git-send-email 2.48.1.windows.1
In-Reply-To: <20260124015045.78075-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsXC9ZZnoa7KuqZMgz+7RCxW7G1lt5izfg2b
	RcOPz2wWTw60M1o8+f+b1WJh2xIWi8u75rBZ3Fvzn9Xi5FsHi8Nf3zA5cHnsnHWX3WPTqk42
	j02fJrF7nJjxm8XjxeaZjB6L+yazenxf38Hm8XmTXABHFJdNSmpOZllqkb5dAlfGqyOnGQuO
	CFVMODCdpYHxPV8XIweHhICJxJpTfl2MnGDmxDXP2UBsNgENiYOHTjKD2CICghL9j2ewdjFy
	cTALrGSSuLj4CRNIQljAR+L6udVgNouAqsTrjTfYQWxeATOJ+ZOPMkMM1ZRouHQPrIZTwFhi
	2t9NrCC2kACPxKsN+xkh6gUlTs58wgJiMwvISzRvnc0MskxC4DKbxMvzr1ghBklKHFxxg2UC
	I/8sJD2zkPQsYGRaxSiUmVeWm5iZY6KXUZmXWaGXnJ+7iREY6Mtq/0TvYPx0IfgQowAHoxIP
	b8DHxkwh1sSy4srcQ4wSHMxKIrzp0+szhXhTEiurUovy44tKc1KLDzFKc7AoifMafStPERJI
	TyxJzU5NLUgtgskycXBKNTDaSbhoL+LZedW48e7tpSK/NZdECp/hM7y1NkPEX1VVKJ+N9dkm
	tXO8nuJV4d+vzvhrkyP2Ts/+lZrLBKlXJordIReXr53i5uH3xTm+LWgvo84xz+kfpAr3zONz
	NVOY9ONumYj2kr8+lhaPi1oW68/ZLpvJp+bqq9d3dMXLzUXqtlEprw34lJVYijMSDbWYi4oT
	AVNY2FBwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsXCNUNWR1dlXVOmweE/rBYr9rayW8xZv4bN
	ouHHZzaLJwfaGS2e/P/NavH52Wtmi8NzT7JaLGxbwmJxedccNot7a/6zWpx862Bx+OsbJgce
	j52z7rJ7bFrVyeax6dMkdo8TM36zeLzYPJPRY3HfZFaP7+s72Dy+3fbwWPziA5PH501yAVxR
	XDYpqTmZZalF+nYJXBmvjpxmLDgiVDHhwHSWBsb3fF2MnBwSAiYSE9c8ZwOx2QQ0JA4eOskM
	YosICEr0P57B2sXIxcEssJJJ4uLiJ0wgCWEBH4nr51aD2SwCqhKvN95gB7F5Bcwk5k8+ygwx
	VFOi4dI9sBpOAWOJaX83sYLYQgI8Eq827GeEqBeUODnzCQuIzSwgL9G8dTbzBEaeWUhSs5Ck
	FjAyrWIUycwry03MzDHVK87OqMzLrNBLzs/dxAgM5WW1fybuYPxy2f0QowAHoxIPb8DHxkwh
	1sSy4srcQ4wSHMxKIrzp0+szhXhTEiurUovy44tKc1KLDzFKc7AoifN6hacmCAmkJ5akZqem
	FqQWwWSZODilGhhvufOnTTnH8ndiosISu2RJz/YLzHeuKtyV0Ix8npbhcUrvr57a3X7+5uUG
	QQV91sdqmVZOXSKrH9S3/G+216PHhVMjw65Ed0o9YjJuYTgkkHX25bJPNo36FTy7vnVe+WiT
	aOis1iS80ab6nFccq9jPqdcXete0uMblP9e5kbTwXWzyLcnXN5RYijMSDbWYi4oTAfwAvkph
	AgAA
X-CFilter-Loop: Reflected
X-Stat-Signature: fjwanzmpq78sg86s7kd94ehwbz8mq6ax
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 37B334000A
X-HE-Tag: 1770171945-486787
X-HE-Meta: U2FsdGVkX1+/skKYXvqmtViIaHs0i3LOiQnylShEFXc+U05UaN/o+/gNsFfcRu2PoFb9GxqG33YfWeZRZt1LrnZB+j/t2iIyultY37MQ8o0K+KuzxqtYFnInO+DpOVryI8NNxCrnHhiDK+ZJ28AVActMaeKQDlwebNcdV0hnuNkFVh/py1GQ4TTT7beFBLjmHuFsqU3cezP8nAW7IGuf4dumfJYuuSDQFuxzsaAlJAN/2f+VUHXHegV3vkminIEnVI83ihttGSfMDHVxAYM5fbxnGL/TLwl3JqLEhwKZZ1Kdkk5wrt/n0rWxvmpXI6OkHDbXxS4Q1MYh6OHgRPim1EtYSJ0rgHi16l3V4sCDGsdIb4s8e0/badySOH7FwsF4O+x0nMOJ8uP67sdraGdtlWpGoq6vZSyxJNsZceHJB5bEprRWybjnpjpZB394p+8HGJxLbU3t3Ok34RKj9EAnD33PlCx6mGNsJQ56wyp8VaeCV0DFTZyr3TSOhGCW5hYGIXXWVJy1bQdrhq4FgRJaKTvvj3OD7M9sr6YOXcGrK8tIcswxycpYlUP0aCGTQJWdbOxPQ4vwKNvLDaDb6xJ4Sowxoucny7wal2p5ssUKyDMUU1REIqTdMYhwDehXsAFdvQTrEg6mxMo05H4l3iE0RcFc36V3rMqSPUCXv+6h6Ri86xeHadMjrwoBculGq67s1Soj2VLwsFOTRufOIpMv5janpwRJQa7jdYInllmutv+meT9bB0REPmBe7jYdtWJ5NB59DSVXMtuePdsgG/e12z2wkLb4/QdXSsCWXhlfF3apPEc3hW+0APd160WG7I5FG4TScw2k+3E4Tpn6eKcd1pKRTP1QEhMr47Q5hMXaFTapoW6ZkXLBrDzSgyf0q2lZ8FtmdI3qpVkfoQTd4ln1WWRrzKOUaufMoxlxKCj6XHy36BNXNZNv3A9CTJ9AZ5rLBi/1kpTmUT5sn5+QYjA
 dw2uRitJ
 EKvPCRR1vRG3QDiD/czCXdV//AgOCRSvEv+MJwYiGywa6sFRY170qKMXWeprQA0pK8lJm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 05:50:43PM -0800, SeongJae Park wrote:
> Cc-ing SK hynix folks (Honggyu and Yunjeong) for quota auto-tuning behavior
> confusion (not stop immediately after satisfying the goal) I discuss below.
> 

Hi Seonjae, thanks for Cc-ing us :)

> 
> Please note that the goal-based quota auto-tuning works in proportional way,
> preferring small steps and "eventual" goal convergence.  As a result, migration
> will occur a few more times until it is completely stopped after the goal is
> satisfied.  Unless there is another scheme that migrates pages into node 0, you
> may end up having node 0 having a bit less than the 40% memory.
> 
> > 
> >     No oscillation - migration stops when target state is reached.
> 
> So, little bit of oscillation could still happen.  Hopefully that shouldn't be
> significant, though.
> 
> IIRC, SK hynix people also confused with the behavior when they experimented
> migrate_{hot,cold} action with NODE_MEM_USED_BP goal based quota auto-tuning,
> but using only a single scheme that does migration in a single direction.
> Because this is at least second time it made confusion, if you need, maybe I
> can try to add a feature for making DAMOS immediately stops after the goal is
> satisfied.  Let me know if such new feature can be useful for you.  Cc-ing SK
> hynix people (Honggyu and Yunjeong) so that they can correct me if my memory is
> broken, or answer if the new feature I described here can be useful for them.
> 

Yes, you're absolutely right. Currently, esz(effective size) starts from 0 and 
esz gradually increases as `current` approaches `target`.
Once `current` reaches `target`,  `esz` then begins to decrease.

However, we observed that even after `current` hits `target`, 
migration still continues relatively aggressively - because `esz`  remains high, 
and it takes time for it to decrease.

To address this, we previously suggested that initializing `esz`  at `target`
(or something suitably large value, rather than 0) and letting it gradually 
decrease as `current` gets closer to  `target`.  
This would allow for stronger migration when `current` is far form `target`, 
and gradually weaken migration as `current` approaches `target`.

Such a feature would be useful for us to experiment with tiered memory system :)

Best Regards,
Yunjeong


