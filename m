Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77F25CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 11:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 570CD6B008C; Mon, 12 Oct 2026 07:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FADC6B0095; Mon, 12 Oct 2026 07:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9B56B0096; Mon, 12 Oct 2026 07:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A7006B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:08:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B486A8A34
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:08:20 +0000 (UTC)
X-FDA: 85313700360.15.F3438AA
Received: from mta1.migadu.com (out-221.mta1.migadu.com [95.215.58.221])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7A6E1C0006
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 11:08:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s6+84idP;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791803298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2djdwnhVoocSdIQ6qzyT8zW0jyj1z8c8AqxxkoJcaKo=;
	b=zqTbDi8KACUH0xLPm0MUTqQPlViY0yv+xH+OyCPtUOWNheL36vNtrPkazA36WcCqQizA3v
	LexctJ5tbZfuyuU+n7Z41wnfBsvxcbwMK/DgBgxeZDEewUHakgKbEklNangUm5m313QIuE
	YNZcmxoD0jLKrMP3M0yecXufK6BVH8Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s6+84idP;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.221 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791803298;
	b=tnoy1rUAPUQID8PnIBdURji4kAE8wQEIMlgPAopTt6304/MhHYeEgkQFBHcdaMb4ZpcUgM
	JCl0rBEiA2Yjxaz+qTBxdPH4DNJWmc60EwzYfSbUEv3s29PKpQByaHTQZecCV3MURnSxl1
	Gofx3peHejuxb0KDYPpAp3moiDl1CuM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GSrdr7mS12mhAPcQhPWfCq5PW4kV/MXU8Gl0USYX69k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791803296; v=1; x=1792408096;
 b=s6+84idPgY/Ya5g/Yba+NB5TW+mTwe7u66sYYprc0iHt6luMdY5ewIdGH3CZwILrKK2qzH/Q
 Qmr6SyOBaFMvQiEb7NFyITg99qXoPH1mkyQUbmjCCLgk+aSbCmsi+U7hXdzU9qFMGTJYRsKOiOo
 INBAi6YloKFqesZs1VMZD5xc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0d2ca05d90e48ec5;
	Mon, 12 Oct 2026 11:08:16 +0000
X-Mizu-Trace-ID: 0d2ca05d90e48ec5
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 04:08:11 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Mingyu He <mingyu.he@shopee.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, littleswimmingwhale@gmail.com
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
Message-ID: <asy_L2s1TNcN7bOK@linux.dev>
References: <20260911032905.63683-1-mingyu.he@shopee.com>
 <aqRXqcynCx88D2QK@linux.dev>
 <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7A6E1C0006
X-Stat-Signature: komfgr7p7a1kex8c81ppjah5dhdfz55k
X-HE-Tag: 1791803298-753226
X-HE-Meta: U2FsdGVkX18HwUG1RTIWP+qklUrzJiVUM/WK8uFPSal5mTZfhiIc+zlSrpNDqxGh40CroLd1Iddrl+GutvYlbiP7CbtcFUZ1qZ33ViY3Re/oXZMVoDxcP5DGh4T3oGlJ/5BI0YDQkl9bJlJB5QfoKKdyuNr65rJIu8QDZYM3E2Jguw3zluCgtXnYki8+zUYIi6WJq9koSAOK3U/wWxVNJwSJBPv6w+gbwlqrSj3nRQ3Zgn7kkHD3eJDwgyAzGL6ZbCAGyaomXz5fnWyOzGGrsxgM8Xds8JvcOTOtFDS10qFjOmPJVWJMGNgkKh4XSVxkhTNU/kpx7osmLNM7O722Dl0Qr/fhPgyDePGUy8eSwmWDQyiMn66uU9O2TpYr4dYBl2X3m9mQrNBjGTJenoYtxG/ws6lU1Dr7s9JzzDVnMvrjqtd/6f7fgKeupWCmcwyygkVJHCDfKWXbOukpcuIGpOSRoB5Wbtg+zEvS4FgJzU+vRGDwiHSjJbhOSkTPFoHaBSE2KWsTcEvDmIPrXf18JG7Ee9zwf96LEWPDEIA8mil6u0lxmmkBLdVr2TM5Jhu/piAmNYq0575MkjOaLt5G3kLcBWWfcuC/K827QEx17kah38iafumwJ9f+eRDL1/Nf4Ygk3+lY1qR6iIcV+s6ckHiwLpeQoymBBl4yDtCrR20Pkg9y4kBvJknmh9i6WCNQmfm4yw1UWmZ9p5ihEb99h9Gt3aq7MyQW65sVGu5wqQTaSGzC9NT9mHods7C3RPcVJHQBRxTruJKxxCppHDJu+BvBshB51iP18jAieGHO+swouw/tIcm5TkkfU5ZFLHopwaI3nI1yIlNdUTooG6yjxlsBznNb1W1Qb4dO/P6y19ix+wWbug+bsLBB/elVeZNjOeaSZhHdXkVwwFDRkl5lwuGNao9Y6upjNOkRMMTfl4BDPSAmHtriqM6o0OpMvAiX6/td9epW1I4tfzf75qb
 1l7VHP8s
 EBgD4rlrrCzFBAODu046GLx6ocNi+OAgClDfNer2ZDvAqtAhxOMO8mmHfjcfTtPwWRwR4hWp6qoxkTEHfvp/5U06wU09qJJy9NAuYboDKS5FGz+/3I2cTNEh4CaRnIrXQakpANB3Yi5JXHvui1BA+RRmBViNVPW2SWJW2J3O1h6BSN6d49xwx7sRoA9uVnaIDXgYUJzMb/8Dcpf0j7pWCQayD6slOFZkMa3YkGkLWTfJL+Z2BqgRYjrOgYu5lCAFTTtP4p0zFieSoXk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 04:17:46PM +0800, Mingyu He wrote:
> Hi Shakeel,
> 
>   This came from a reproducible workload with a custom in-kernel consumer,

Please share your custom in-kernel consumer. Let's not make changes in the
kernel for things which are not in upstreame kernel.

[...]
> 
>   Regarding the BPF interface, the implementation in the tree I found is:
> 
>   __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>   {
>           mem_cgroup_flush_stats(memcg);

Let's make this force flush.


