Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 076EFCD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 18:30:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30FFB6B0005; Mon,  8 Jun 2026 14:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C0846B0088; Mon,  8 Jun 2026 14:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D64B6B008A; Mon,  8 Jun 2026 14:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE6B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 14:30:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1519A0239
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:30:41 +0000 (UTC)
X-FDA: 84857586282.27.0B60B4B
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id 84A9E80014
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 18:30:39 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RQ4Z9Jmt;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780943440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmLJLwbACmSpy0OGKa5SysPCZAKs+2N+AqhTk3vlywA=;
	b=qgA3zZf0TByBiZANg9Vkdw3DCu0rT47ajcL0F+09ZMXZJmvEQIw+OYV+OPv2yeJeE0tgXe
	v3JPr9UBdG0JWbPmHexXEt8v8MQ4wORXw8jwOtCnum226JndeTlvPUkz0BXIQ2jp9Wd/3F
	Yr1bEBSRqB7ZjtV6X9ZAD4M7FM5E2lE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RQ4Z9Jmt;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780943440;
	b=8dYLwwXhstaigOSglRxMYsmHZjMDU+t/9ISH56uoPdO+yivD7xeP7RAE8HWs8qAuRNVvkP
	nP2meKbz17RXa2Mj/FLJo+4rLMwl4Ij3QFLdO7adMONEiZSzecQnf2mZTqMtsV7bB4ROnl
	FCtGuV4gtEPfB3GMyYaIIvaRPVtCnWE=
Date: Mon, 8 Jun 2026 11:30:30 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780943437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=PmLJLwbACmSpy0OGKa5SysPCZAKs+2N+AqhTk3vlywA=;
	b=RQ4Z9JmtTMCyeeCpVsedvqzD/00GplaWZelxpPu7MKe0hgH/D4oq26BfXkKgbAsc8aVISx
	0dVOaVhOg8P/GOPke6vFPYnbnj3hglW6W/RYv8cGOgz68ReHBb9gD2cscXKE0rVhqsM94E
	cClwVTCnUo4rVdQ9Xs9yHCXOJuV3R0U=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 2/4] mm/zswap: Implement proactive writeback
Message-ID: <aicJBVT4pBvmyooT@linux.dev>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-3-jiahao.kernel@gmail.com>
 <CAKEwX=MQe_KFZe2vBXQYh0aa-x+E8AzNwmyjJGJk4tDoS9ML3A@mail.gmail.com>
 <aho_VtLCmIRsNyvO@google.com>
 <6deeaea7-3cd1-4403-29fc-d2dc55c297f8@gmail.com>
 <aiBqzOtEv5iAC_qC@google.com>
 <CAKEwX=OhxUxRCEfvZMnWzXy=Fa4jgzL3DuP-RmaVzdK65m4bew@mail.gmail.com>
 <6db27a22-cc7a-9a94-db3f-c912fd39aa32@gmail.com>
 <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zM4SDdTgz9L2s1VfXL8K2VBjMD9ej2BTDxaGge1t2+quA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 84A9E80014
X-Stat-Signature: iwouq3t7q8zftj9mbttkyqo3jndcaasq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780943439-582097
X-HE-Meta: U2FsdGVkX19+0dlAKP9fCN+gF1pumpxTFgQPYm3qOsbYnd2z0fiHNDBZxOuDWjoL3KZyQaTcqFkjjLeoVopdtPSpG6Jg7RGzhpD+6b6Z0vwVoK+pdcfacmAK9uS+H22w0f5/idi/3NLaDOHlY37917y0g+l+q0M8MZRpYzOkjVKGhqNUAuuqbTcQV7ub3h8oJ3ZDg6iWWROQxRPOxBc/CTQknRr4oMkgkb6MAK7iuMyc50ANzUZCqHRoc7eNFeMawajrZKrSei+riBmUDhdRxTtmp70lDEKV9VaF4VOhq1nCYwdDX6Qi+WwbMG123+pToVzgpO7aiS0xGgL0noaxOtPC0XOH2jNPoGdr1O8mB0zUM8u2U0GYUjgIqJJFtTscfoHOk2LAZTdti4DfCprZTqwgfhmaUfC+THCDe6NGoC+8pdI/BwNDrsHoPub+3icE/+p4d55vfOFhP8wmCmep1mLxG+lx1fFL+rW+GTX40m6+MXqWO2i/klxKq9uc573F/Qbh0xjpH1G7VlQYoddKJGQ3Lv9QZR374TXHuZQPFqlH9Y8KMkYuFXLDPuLKg4X40+EACYce484x83HhoWbeDNlsVTVVWvvJ0f3erxwWsLUVwYOyQlui+0gPeENBqgRR2BzjgS5smMYBifC5AJT7FLxp+qXre8PfikMwzIVeSXyXihp4erQ0lNZ8yEl2ie1JHKlPZjAD5IZ62+eLEi8fNos7B/uo08wmU9Op0S54TQkRi4fNfrZiRhG8gIrLqp47OwiqgsZAtFkMmnEJ6164pLe0erx1Fbf0KApHfw3bFYoXWplI4RlWWnWWISWgY/ohf5RcY6tPS6wPTduFY/YIbp32yGdjxOPN+C0sBXFSwAx1t0gULnkeQW2SaJlS1NzQ62VbXDDiOuLu2CXLayi2SNpTHTL4hxGGmLqom3ImDv0TnNzjQL+mg0xkBxly2h8gg3YPnIO4LoXqP27SHeE
 BKa7yTwA
 0iyBksOseyIE0Nj3EoJB7AGfDlakNdIhzGZW01ljybU8TsQ/93DamKF8POyL5RhhMy76QKqARSlXluCJRd48JkKCBl+gBBGmCKsjNrnTSZjJl3oqO5PU3cuAgEHgqS9W5Nj3zgecMSEZKBr4XSgfe1xrSPF1VXeaIJYUSKlJfgLWBhY6X5ETZraC6jd1d9nsogDJHd/hbk7XJIA9v2vfG/1p//W+Lgg4mbyIpR1XsFfBnw+9BSaz4TWnO2u6kL0hlajjCmb+oB0Vlif+zMgfNuTes7VoV1SQKYpeV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:36:07PM -0700, Yosry Ahmed wrote:
> > >> But doesn't it make more sense to specify the compressed size, which is
> > >> ultimately the amount of memory you actually want to reclaim.
> > >>
> > >
> > > I personally prefer compressed size to pre-compressed size. That's
> > > kinda what user cares about, no?
> > >
> > > One thing we can do is let users prescribe a compressed size, but
> > > internally, we can multiply that by the average compression ratio.
> > > That gives us a guesstimate of how many pages we need to reclaim, and
> > > you can follow the rest of your implementation as is (perhaps with
> > > short-circuit when we reach the goal with fewer pages reclaimed).
> >
> > Got it. I will change it to use the compressed size in the next version.
> >
> > Yosry, Nhat, should we continue using the zswap_writeback_only key to
> > trigger proactive writeback?
> 
> I *really* want the memcg maintainers to chime in here, it's
> ultimately their call.
> 
> Michal? Johannes? Shakeel? Roman? Anyone? :D

Between the options of having an explicit interface (i.e.
memory.zswap.writeback*) or a key (i.e. zswap_writeback_only) to memory.reclaim
interface, I prefer the key option. I have not looked into how much proactively
reclaiming zswap memory or proactively triggering zswap writeback makes sense
but from the perspective of memcg interface, I think the key option would give a
more clean solution if we decide in the future that this whole thing was a bad
idea.

Next regarding future proofing zswap writeback trigger, do we expect any
potential additions/changes/new-features for this interface? For example do we
expect in future we may want to trigger the zswap writeback only from a specific
node or lowest memory tier?

