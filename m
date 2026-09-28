Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42AC8CA5FA5
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 22:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1FF16B0088; Mon, 28 Sep 2026 18:39:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACFE26B008A; Mon, 28 Sep 2026 18:39:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E5DA6B008C; Mon, 28 Sep 2026 18:39:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 765636B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 18:39:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EA45C16038A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:39:20 +0000 (UTC)
X-FDA: 85264638480.30.1B003DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 72E83140003
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:39:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nvC1M3Ic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790635159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=0DcTnoia+4xLSrCsg5TVEUmSrD1P5AixIs8yunT2mbo=;
	b=YDuvctRUAoNEe0uQ0npdeSHsvfUIrVvWG/RiKFiNFcFhLeCb2pRSv/1LuoAuL4VuJ4d7gX
	sYaXPUFaXjajMPR2aHcp9xgrpbLv8kY31d2YuKRgaiL2wZdHhTWjvolUGW3pMJy32pjHwV
	ANw7SSk8jdZGgTblGc/Cp4O+SY+fB+c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nvC1M3Ic;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790635159;
	b=Yk8ysvqDudB06LKS4RW2+CJxGLaHAJqy0PtBkI1BLrR8kXgbYzfHB2YCWHw3gZtRFR/hVC
	sndgNCe/rM95vr1t8qyOQ2WqwyRKzo9RuegBbdeyF/xsB3RaQQpaz0Aw9KLeTXcOaFXfkc
	iNYpuLF/2H318e+Kg+xFxN4Rgz9pS24=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5F0C60216;
	Mon, 28 Sep 2026 22:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771F01F000FF;
	Mon, 28 Sep 2026 22:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790635158;
	bh=0DcTnoia+4xLSrCsg5TVEUmSrD1P5AixIs8yunT2mbo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nvC1M3IcvbjGKpuIeoOXjwdt4kNlIDUq7OoP/yr+feT3CCiUuC8a1GV8p+mbtQFYO
	 uou5WRLU8eKJeRWvKfNvBVnhh9l9YHewiwmKYE9hO+wemXQwqTckvZL7vavzqysKiR
	 hAXz/2Ae/xHx1xeUh2G7b4XmEAznKdHly1jHEJsIfbEXFjyldks0Gb4T5PTXtuyl7s
	 ODG0CcrT1DXPcLfxo9c49uEJwD6X4E+KApLeD6JPvydwH/xbAYjbCdpRD87SnR/UC5
	 l+Qi24UmRyohYuc7M2fxjf6gGbfQ4mFBtWVlOVSrOcNWupOfEigalg1zsY2rtg7XhH
	 Fguwz6dSvzcPw==
Date: Mon, 28 Sep 2026 12:39:17 -1000
Message-ID: <e2ede7c4172c421c0894f1962fbe8517@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	David Dai <david.dai@linux.dev>, JP Kobryn <jp.kobryn@linux.dev>,
	Frederic Weisbecker <frederic@kernel.org>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Hao Lee <haolee.swjtu@gmail.com>, kernel-team@meta.com,
	cgroups@vger.kernel.org, bpf@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it is
 done for
In-Reply-To: <arWLq4p488JPhuZ1@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
 <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
 <arWLq4p488JPhuZ1@linux.dev>
X-Stat-Signature: prnwpfwctqdmjhh14tepzufxr8sexduu
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 72E83140003
X-HE-Tag: 1790635159-723363
X-HE-Meta: U2FsdGVkX19946bZjhK4Gd9EuKwOdmacbk8TGkBNRBHImMRek5e4psghomKmfL62fXyWImL7kQSEi38KbShrhyeOBVXaCXfflwL1hj4GIeCd+KIoncvU1CqCfxWHtzxprv4yIx2P34DHmzR17Qb2IsOi9wNe9LvK9+lrqrsxHS8sFsqmLpwi4AxqSSGigmKMuHqGYu7jzkYUoTHuqmAi/LFmCeafmpinV5DGONrka2YCOwzGv51bMuzcte74By4ZRrtXQi+zUD4C92a/d0Xd0x9rehDyHmjhzhbkGiinC2plYP2mF+4167ASZuCe+QfnuhnDBXvWMwkQj0/jHQsU2DEZvdkhjQ17YpGalvVWij7nvBSjLzmp8T54LiawTtbNFDFt1qggI0/GAKJEJEpamdM9UGTB3AjXdjhRBVNHGZVscu80mlUG1JR4N97wRgVA3x+zoKEC0RRGEXTMyiLqTplTP55cLw24a7cN+vatGj/Nh9BeW2LfRh7UokXAC+nLVxhKpfYJIDoHZCcOV9MTvxSlCYBdOehc1zs6oQ/sZ1K1kVLnKVqMhMO8u2EwH3/b/YmyyN8v0HmZdKSmKbAhRO5JqyiuxyQgAf+9HkLk+Xq4juEkW+8aG9hwvF+ia0iYLwv42apQRZyDlETQ9Ds/Dn6OQP4p4qkgSI8orfPSW+dYqSluZSM4Tx+JMgFauGM70s1eNOEGcpQ08LPaGoIZm8RTZfySk1QkqXB8T8wsSlX3y8jxSjXvU4b1cnbpQmC2eUXf2uqsVlKkp/X8ovwovnl+FD3Rdhngks9tLh7fOZ8Lu7uASaHIjbaj6atLPqniiSYZ6hVVx90EPSFtZoSpsPGQEzqPgW7TAjgEbXBU+/jmaYKXi6OtzSh/sLe/D88BoKLfFp3CYmszBimOFVNckH+N4vQjmyZqw68is0dF2CQpWxuj6okRnsqhlYfJoV9VrWtXz7nBzJNBN0PBu+5
 yWWMxQqT
 G2IP5yRTPeu9aQ2PWy7FOR/+es7wIKJPxKD8f30QUimSfk7vaSDSvP5M37a5kH9WjmzwZRuNVk3Cf4CcaMZsRbLQ6G5+FBPa45ZeDdnzvX7bnIlXPNTRhunsxke+RznNFOdw4WPmentQFDF4xu5ws8BDtb6hp/4lVIVxTSIIughfdWZcTpAd0u9elNsvRSArJGVfeyF1NhJzOKWUn5DgL5Q9/EmnglfTLsjRdHoPHmA9LZSiakdpsdeduKju+xTRMl+g1hjBdrr+ew6THFov8KZzng9hYVcEOvT+EDH/v8m2YgVuUhd2esi841wu5SXzI5U9Ecf/0MxviXxanNqKbvMlZ2+PCLGwxcvXG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Shakeel.

On Thu, Sep 24, 2026 at 02:11:00PM -0700, Shakeel Butt wrote:
> On the modern NICs where the workloads get their own rx queues, I think the
> proposed mechanism can help to do the accurate accounting (I have to extend this
> to softirqs as it is limited to kthreads atm) very easily.

Rx steering is useful for partitioning the whole machine, but it doesn't
seem like the right tool for attributing CPU cycles to each cgroup. It's
cumbersome to set up and the granularity doesn't match. We aren't going
to be steering net rx processing per cgroup.

> If you don't mind, I think having solution for modern NICs i.e. dedicated rx
> queues, should suffice for now (unless you want the solution for old NICs as
> well). Let me know what you think.

This doesn't have to be exact or completely synchronous. I don't see why
net rx charging and reclaim CPU charging can't share the same mechanism,
where the cycles are force charged to the cgroup after the fact.

I don't think PSI needs to be involved either. Shared execution in
itself shouldn't create pressure. The forced charge changes the cgroup's
usage, and that usage then creates pressure in the cgroup. IO works the
same way.

Thanks.

--
tejun

