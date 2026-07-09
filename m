Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4916C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 00:52:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35986B0088; Wed,  8 Jul 2026 20:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E67D6B008A; Wed,  8 Jul 2026 20:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7FD6B008C; Wed,  8 Jul 2026 20:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 582BD6B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 20:52:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6A9EA0226
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:52:29 +0000 (UTC)
X-FDA: 84967412418.03.5A5B13A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1EC2A80002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 00:52:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIKCAC12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783558348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kW6vnOtpcVYAgeY996D2IQsA70zg+YZWtPz9L5fIac=;
	b=dGBj7CNcFTHXyQGQZ/AIGJi9Bmvhep4ik8rTrZfdBJUqnk1o3N4qAq+RjwreVdakucw9hm
	BGrE7IVHDgw9WLKzrI0BSoglxvtYggqhm0QAm4MiPr2z44pQ3HpPQQCjJXBjYrvbBtxI6i
	fnvoi1Oiui85lahf0QNuluAOFVzjL1E=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIKCAC12;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783558348;
	b=cHYKAA0JPr1yX0HU9IRtNFDyjxRn7K1v7VO/YVt9vNzs7VpTyk7yh/0KGdzkV8pMy3MBfu
	6gWO5GyYad/1l3GslA/YSp5moxoXFDhVnVgN9D6PVa43zcJQsOU0VZjtz4ZoLAYXvj3kWB
	JUF79rfBN5+AOY4cNNxiDrbszB5E4Hc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5653B6001A;
	Thu,  9 Jul 2026 00:52:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ECDE1F000E9;
	Thu,  9 Jul 2026 00:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783558347;
	bh=9kW6vnOtpcVYAgeY996D2IQsA70zg+YZWtPz9L5fIac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIKCAC128TILAgoYJubwyzLEPBOdqLYKQDk038RB1Iic0DPEGQwsGmt3HEZ5YiHAn
	 ML+J5YZBmZXLhUanpeaalSZqMHdFPMDGyvZ/NBbHQcrnKKK5N3lI1ndI2HqWVRcfgx
	 HRvq3vCo54OKOW47duTInzgwQeKa+cA/mPkv8Fmf/LnDMtUil0U9r7PWOQEm4ju5G6
	 +4tqX0D80fkfBE6f0bEJgS4182rkENWLJZcRtoJQEkW6bt2YxHTKXYUX5VVKhkt6kQ
	 4V+9LA9cUAj4OZhDWsgyucQ9nchM/2tMfiCYXkK+xp8+t2vMQ5iKUYXiSnwvc4yYEX
	 6ygNWxhHclFEw==
From: SJ Park <sj@kernel.org>
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: SJ Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] mm/damon: Introduce a huge page collapsing mechanism using auto tuning
Date: Wed,  8 Jul 2026 17:52:23 -0700
Message-ID: <20260709005224.128135-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <8b8cb8b6-41ff-4975-9be2-7256b180fcda@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: maz9pinn1ijxgqs6mbkrh9i3abusygxn
X-Rspamd-Queue-Id: 1EC2A80002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783558347-264333
X-HE-Meta: U2FsdGVkX1+hMqGgkcpf67d/EKjKzZ7/QqVzx8AKjN2cK8WevZRTar8r5wNYZtSS6TEDQ0m9iCRSB4qxiCp8OcuuosnvUZjrFYV5sGEohclpvx5nzpAfUe4XK2n2JCpmcv5NUIbGO8j9E3o3B4junRW4xGBiBdqwSfX3AkbhhQQgauV6uBsISgPyjRiZY1D8x/IFds8U9Eq7YvfrTiieKq6Rfkzxpi+8j1Ej24Y3qh4Wf4CmVheM7pECFyb26hQixQc6gEZGWZ9Q2WwtEKfnsYIVhUzcZxxgROtmtQ3Az1CFSLoxMQacal2hWMuoGwQWvBf4Lmv6dhKVgJ1vwNeITEguo5GYUwREPVxQy5ShAdLAKA/9mLBmreEJYn9z8b+Cqbig1n+6jOxqQrlvpqQU44ucnchRyiSTWtZicqC5Q8nUMuS4qnut39B/q01CxSOnWNC5T2RYmCD/d/xnrcbR7XUbUY8t/gCPSjVQ247Fap+EaZT3qkuPLjEEFGOXH7zeUolFmorXTgs1CqqcEaZ+1+EL5vhhv1MuqUnkr0z6mWkz4QdsIO3IKbwGMf8vxbyuZBltGB02vxjnpTaO4mOIr6RDJeub/YqwrAsLvTS9BzBjeVfJBYWzMARM1VlEC9EpKXcu/M45ZN3epJSX8J5jGi3gdLsVj0ht382wqgae0EFfdCk4Kvm7fQ6j16rdkSzKhN5+VKErF2pJqOji8tIFoQKmRFfR/nfbs91FsiYZl/9kvzB5nhTDOAj3sw3kRmsW66mYwEOi7OqyfvOOxT6pfrg9PQrMegY0S6IQ7JW565b0LmpuiHuMGuiiKklo/cAPQb8I7foWN6qpwou/KEof9NLKisEUy8UQzJtOh4dyboTrna6F8D2Mf33xOBJD8ko9xeFbhtYJ6pGiyxSk/94SBxTVijcJOsz8TmSIWiqS/cOg01zSaWqOCao8FmG34zdCp+oxkYPuFkva8DW5wjB
 7MRrgcUV
 W+nj4T6KsjgcK7n2HGtOtHSSdbnRMTRosANWwt0sW7zCLtCDhuC6479QSspHJM4t1/Tg3oxmSwikmg+UNvXTSd38/sVaHML3xGFTDG5E4UHKzGlAN/TO0EN/gA234y/pSOGmAPvxFwmg0KAhr7J+GL3TGzf+gZMjM19ITsJxVFwg3oFTJlmAnkqACbk7ROR1GRl2+K4nwzvFKI5MIvvgQl0Gx/rA9FBfmIRMD0zGE5uANnZW78diFncEae2KwYkvMDLkmwpfWxVWU60A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 8 Jul 2026 17:50:57 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:

> Hi SJ,
> 
> On 7/8/2026 4:22 AM, SJ Park wrote:
> > On Tue, 7 Jul 2026 17:25:36 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
[...]
> >> I have no idea, to be honest. I will try to test with different databasesizes with temporal and consistent policies. The behaviour was weird to me,
> >> but I don't know if this was a TEMPORAL policy issue or I didn't set the
> >> DAMON parameters correctly.
> > 
> > Thank you for transparently sharing your thought.  And this is little bit
> > concerning me.  It feels like we don't really have a good theory about what
> > change will make what results for what reason.  It rather feels like we just
> > doing random experiments and showing the random results.
> > 
> > I understand having data first and developing the theory driven by data is also
> > a good approach.  But I feel like this is a time to step back and think about
> > what we're doing.
> > 
> > IIRC, your initial experiment results on the very early version of this series
> > looked promising.  But from a point, it looked like just random.  Maybe I gave
> > you wrong change request, or some test environment has unexpectedly changed.
> > 
> > How about summarizing what tests you did so far, what changes in the kernel and
> > the test setup has made for each iteration, and how the results have changed?
> > 
> > If it has been too long since the older tests, just doing the tests again or
> > dive deep into debugging of your current setup with the all mighty printk() on
> > core DAMON internall code can be an option.
> > 
> > Have you also monitored DAMOS stats while the tests are ongoing?  Maybe that
> > could also be a good debugging option for understanding what's going on as
> > expected vs not.
> The problem I've been having is inconsistent results. This may be due to thefact that I'm testing primarily with database, which contains a lot of
> variable data, like indexes that may be hit sometimes, and other times not,
> different data distribution, etc.

Makes sense.  Testing is another challenging area of arts.

If you find it is too difficult to have a stable test setup, I wouldn't mind
using more artificial test setup for test results on this series' cover letter.
I'd request it to be only makes sense and shows a sane and complete story.

It would be really great if you can apply this on more realistic environments
and share the wins.  But that's not necessarily a blocker of this series in my
opinion.

> 
> I've been trying to get a test as consistent as possible, pinning the
> database to a single NUMA node and the tests script to another one, avoid
> network traffic, etc.
> 
> I am almost done getting some consistent data.

Cool.

> 
> Maybe I can use perf to get DAMOS tracing. Would that make it?

Yes, that should work.

'damo' also provides a wrapper of 'perf' for tracing purpose.  If you want to
try it, I'd suggest something like below:

    damo report trace --event damon:damos_esz damon:damos_stat_after_apply_interval

[...]
> Thanks to you. I will keep testing and keep you posted in the coming days.

You're welcome.  No rush.  Take your time and fun :)


Thanks,
SJ

[...]

