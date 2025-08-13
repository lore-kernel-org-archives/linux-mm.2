Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC026C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 20:54:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C06C9000D3; Wed, 13 Aug 2025 16:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 370C8900088; Wed, 13 Aug 2025 16:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25FD09000D3; Wed, 13 Aug 2025 16:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 125BE900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 16:54:12 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8346682F16
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:54:11 +0000 (UTC)
X-FDA: 83772936702.10.4C7ABCA
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C510100005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:54:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PoBWnEIx;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755118449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BnHjAcE2afHw2ZH4ahTMmzFeMhbV05T1AU89RXbzZLs=;
	b=8bjaBh+aPQPALhf6JMifFk/eAeQa9CEqvshnhtR9aE7gmP0jYHZIRHxZY3JQU3lJnnIZdv
	SXIxVz8eRsVwyrqCJePf6E08A2k2xSj3hUmATECkBSSXewItO98JJAeVoeonmSg1lyM8jh
	jA2sBw1nR4avOn4po2HIkFnip0WJvME=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PoBWnEIx;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755118449; a=rsa-sha256;
	cv=none;
	b=tJcNSS2jRk6NwOxaj+OiDj01Wv+h3dgWDGmtq+CSM5ARC2kpovPW1zZBke8tyJjX0U7SNL
	pHCWReLjtc3IP2a7iS7BhCQvFsq2wZqyEdffeke7jhFxBMhxsW6F2q8m88/WAugGVkCkZ9
	M3vHm8gi78Wlj9eU70SDgNgTOM5wFyM=
Date: Wed, 13 Aug 2025 13:53:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755118445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BnHjAcE2afHw2ZH4ahTMmzFeMhbV05T1AU89RXbzZLs=;
	b=PoBWnEIxIcfMYl/tlSSwqrpgpdkIgUnt+/l5CiIfW4q7tMLS63s9dpu3LCinuWGdf2pZLI
	PFouMpIDd+OtRzFJ0DZjD6mxEhmzKK6mUYtO0jIMBKS2DPJrYVw2hs6FmH7tH0tstH4dSA
	7GSmRfkdmXKgTvsCjyX68rxPSWqhU08=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
Message-ID: <oafk5om7v5vtxjmo5rtwy6ullprfaf6mk2lh4km7alj3dtainn@jql2rih5es4n>
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-13-kuniyu@google.com>
 <w6klr435a4rygmnifuujg6x4k77ch7cwoq6dspmyknqt24cpjz@bbz4wzmxjsfk>
 <CAAVpQUCU=VJxA6NKx+O1_zwzzZOxUEsG9mY+SNK+bzb=dj9s5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUCU=VJxA6NKx+O1_zwzzZOxUEsG9mY+SNK+bzb=dj9s5w@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5C510100005
X-Rspam-User: 
X-Stat-Signature: icyui3yn98ok4j8ery6heb6bb8ddarrk
X-Rspamd-Server: rspam09
X-HE-Tag: 1755118449-273721
X-HE-Meta: U2FsdGVkX19BaNy5SvuSMIKOrpaAVgXfydioRfr2x1R6dwWQkvo/koxcZlE5UYFRlIgShyGUZF+0alY/PeTpvh9XIOr0Q6MgOlqU6a5yfw5+4z/JhD9zyNf0qSMW+roTRXSb90rBBPheiQ9t/vpPpt1HM6tMtdlV50JF978fHXObrD3xokigTHfnt0fJZGyYUuxZNTDKb9UGMiziVbUv/97mjhzZnahXAepWBCwF+yIgeMTR5jNo9peFUw0+tu26z7YHeQzauVRx+K+OS5hCXqFYvGeKS69UT1stQFchwVVUDwu+nF1ds+zqAxDAR5SZtPr1kxOTGGcRv2omyWqr83UFy7BMoc8YUEC0MCkOn06CbMi4uD7IeU4dJK9bSDnXEmSWEXvEb41uE5/C6LKcSmhRj2592UluagEGQ5OAZcVcKPyLMNj1XimYtp3mHVLcx2eAbm1X9B5OVMr4sG3M5VGgtsvr4GFiAFGpmjxlNadbt0EekaH3eEqR0bc7lyLL7MbvulgXnU0K0h1zYtW/nH53YGjFZ/j05f7flvqBt9S2qz91B17azT+FyjH4T9kI7KavTPqRLs3Flkb3VdLql88+Nm63gzK4nlJXejQk07akCzTDWKBK5YVGaBFsRT5WyRSBsEBFq7Ncc+c8kFMR3Im4LQShzhKn1Ez7Pu/VK8vXLbT3RxdRYOUN3lpUMnH980cN78GJpfbHn+/COW9Fx3JC/G0Zip4Jod9FfVfXh6JcmqdYazbcOT5Xf9hnvVadkcmkNADQUrSjuRy/uKydToG7fPW1uTjsVuAuJ5LSwAxYJa9/SvKARGoFTnzNTodXL6ZQQCz2oSVFpNO1Bu3JJg98I+sCHpipXE26mgZ0QFpVBCbqEFvp714a2ixiuGM9UpBejayDDJpMXkUjNcyTTxABA4L5S7cP4MbcNNC+H/gC9xW3h1oSaQ7Rdq2A7zygtd/+yMGoW6xgjB1sUHy
 0L5HpLJS
 KUyufEvC9cR3NLqgmmw+eJeJ8Dimm2lw0UkOMpxcqW5Y8iQXaX9hxgx772hAH0wMLNPg8NxF5SRfTQEtw0CYCPxOlfjGclrXOzvno0yEMU/HFasb4hwHYnsRy//6On3gR09lDHf4x7DRSBLMkE8MP9EdcQm7GrQ8RFXcNFehf1BhlL42J8edo972GYyEf6w4s9j2xabErv8KCOuYC6zAnTnzNs9oUto856Y4cZgtyRytSZp4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 11:19:31AM -0700, Kuniyuki Iwashima wrote:
> On Wed, Aug 13, 2025 at 12:11 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Tue, Aug 12, 2025 at 05:58:30PM +0000, Kuniyuki Iwashima wrote:
> > > Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> > > buffers and charge memory to per-protocol global counters pointed to by
> > > sk->sk_proto->memory_allocated.
> > >
> > > When running under a non-root cgroup, this memory is also charged to the
> > > memcg as "sock" in memory.stat.
> > >
> > > Even when a memcg controls memory usage, sockets of such protocols are
> > > still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> > >
> > > This makes it difficult to accurately estimate and configure appropriate
> > > global limits, especially in multi-tenant environments.
> > >
> > > If all workloads were guaranteed to be controlled under memcg, the issue
> > > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> > >
> > > In reality, this assumption does not always hold, and processes that
> > > belong to the root cgroup or opt out of memcg can consume memory up to
> > > the global limit, becoming a noisy neighbour.
> >
> > Processes running in root memcg (I am not sure what does 'opt out of
> > memcg means')
> 
> Sorry, I should've clarified memory.max==max (and same
> up to all ancestors as you pointed out below) as opt-out,
> where memcg works but has no effect.
> 
> 
> > means admin has intentionally allowed scenarios where
> 
> Not really intentionally, but rather reluctantly because the admin
> cannot guarantee memory.max solely without tcp_mem=UINT_MAX.
> We should not disregard the cause that the two mem accounting are
> coupled now.
> 
> 
> > noisy neighbour situation can happen, so I am not really following your
> > argument here.
> 
> So basically here I meant with tcp_mem=UINT_MAX any process
> can be noisy neighbour unnecessarily.

Only if there are processes in cgroups with unlimited memory limits.

I think you are still missing the point. So, let me be very clear:

Please stop using the "processes in cgroup with memory.max==max can be
source of isolation issues" argument. Having unlimited limit means you
don't want isolation. More importantly you don't really need this
argument for your work. It is clear (to me at least) that we want global
TCP memory accounting to be decoupled from memcg accounting. Using the
flawed argument is just making your series controversial.

[...]
> > Why not start with just two global options (maybe start with boot
> > parameter)?
> >
> > Option 1: Existing behavior where memcg and global TCP accounting are
> > coupled.
> >
> > Option 2: Completely decouple memcg and global TCP accounting i.e. use
> > mem_cgroup_sockets_enabled to either do global TCP accounting or memcg
> > accounting.
> >
> > Keep the option 1 default.
> >
> > I assume you want third option where a mix of these options can happen
> > i.e. some sockets are only accounted to a memcg and some are accounted
> > to both memcg and global TCP.
> 
> Yes because usually not all memcg have memory.max configured
> and we do not want to allow unlimited TCP memory for them.
> 
> Option 2 works for processes in the root cgroup but doesn't for
> processes in non-root cgroup with memory.max == max.
> 
> A good example is system processes managed by systemd where
> we do not want to specify memory.max but want a global seatbelt.
> 
> Note this is how it works _now_, and we want to _preserve_ the case.
> Does this make sense  ? > why decouple only for some
> 

I hope I am very clear to stop using the memory.max == max argument.

> 
> > I would recommend to make that a followup
> > patch series. Keep this series simple and non-controversial.
> 
> I can separate the series, but I'd like to make sure the
> Option 2 is a must for you or Meta configured memory.max
> for all cgroups ?  I didn't think it's likely but if there's a real
> use case, I'm happy to add a boot param.
> 
> The only diff would be boot param addition and the condition
> change in patch 11 so simplicity won't change.

I am not sure if option 2 will be used by Meta or someone else, so no
objection from me to not pursue it. However I don't want some possibly
userspace policy to opt-in in one or the other accounting mechanism in
the kernel.

What I think is the right approach is to have BPF struct ops based
approach with possible callback 'is this socket under pressure' or maybe
'is this socket isolated' and then you can do whatever you want in those
callbacks. In this way your can follow the same approach of caching the
result in kernel (lower bits of sk->sk_memcg).

I am CCing bpf list to get some suggestions or concerns on this
approach.


