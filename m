Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA13CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:28:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E4A18E0015; Tue, 19 Aug 2025 21:28:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC418E0011; Tue, 19 Aug 2025 21:28:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9298E0015; Tue, 19 Aug 2025 21:28:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3E28E0011
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:28:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D6018117437
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:28:56 +0000 (UTC)
X-FDA: 83795401872.29.DF307DB
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf15.hostedemail.com (Postfix) with ESMTP id 255A7A000E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:28:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BI/zpu6D";
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755653335; a=rsa-sha256;
	cv=none;
	b=Kt3Cr6ktrIXCMUa2ywJshIhbss6be3tN54O3CjcDs/s67Z2leFAGWNkieMTf7px+fyZxEx
	l4NbLOO9w6Lrzpj87RLLRxp3WZnqghBwlwMTN6Gaoz/U+FRHsWBCa1Ty4F6HPz+ljli1vS
	bDOcgHMBXaPtGHPtIWg6g8XseAUff1M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BI/zpu6D";
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755653335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ddgBw3mCPWmcVg5SkIp/yrU07evHNFdC+LuzP4v9Gc=;
	b=DmD3m4NN+w9gbBnxMHuNwgauNNAVA+PKXTJsqRe38Td/bj5TbvmvkUcKFetgol+lFDzlxV
	bDZl8lIcobJ2nws+8NNIU+O6+Gsi9qrAXl/CsTMVA8KvMe1B6ESV/gXVkSO56llH1qjg9Z
	aPs9XeozFKVyhahWqdWwhBIm4Em7rMw=
Date: Tue, 19 Aug 2025 18:28:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755653333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6ddgBw3mCPWmcVg5SkIp/yrU07evHNFdC+LuzP4v9Gc=;
	b=BI/zpu6DhZSKL3XzZ/VJbPaPs+hvb9svdPgDr5znV2PbyuEuBNzKNER2kvRp/123+Q1Pna
	MDIzeU1CeYqyXkeEanv26zU+d7IrsDT9Mv1E1HDnm+3Q3i3jgem3C7LaBfh1oSE+n/H3Y3
	gWkzqIMzE5KOtXr9pGq8XCn4BsDVUP0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Kuniyuki Iwashima <kuniyu@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v5 net-next 09/10] net-memcg: Pass struct sock to
 mem_cgroup_sk_under_memory_pressure().
Message-ID: <2v2te3knj66aszw6chn6m2u7chtje7r5ayrtufwop5c4vftx7o@kbf2ry2bgo3r>
References: <20250815201712.1745332-1-kuniyu@google.com>
 <20250815201712.1745332-10-kuniyu@google.com>
 <20250819182356.75aa4996@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250819182356.75aa4996@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 255A7A000E
X-Stat-Signature: 6a184ynueij839uerpeoxgrryebeohsa
X-Rspam-User: 
X-HE-Tag: 1755653334-806642
X-HE-Meta: U2FsdGVkX1/M4KddoQz4g/VOMt8tz/jxMKuopWefRm+b97hYXBHYJ5JMxc9vrM83WY2OT3scK8d/2MR5d25J5yjb4Hu2M8Y8ZhY85YIZhrZVwq+rd3QOMn5hO5xH5OsdA3Y1p9pxNxbKY6QhYMWMWk4s8GlEgc1K0Wn2Oywv9NLB2nBvczz4J6uv3rR38+ruBe69/9aB/wiRrnUlWnhLP0Tz//Oq3bB80T2SNsTeEaq2p0a5pSM6fQfH8s9wUIiSSVieE+x4rXFxemY/EOv4XsYZVbU47KfSv1HRYkrpRxMbmrM1LnCEF7WMcURTnJG4YzbWZImxU8PZ+RHoBTk1UUiTLZIjNrApijussG+rVam68DdoiIBRiTiU1WwarUh0aA6kmsUNuqw5e/xksZs2HojGtu8YUmWbKAQ38yyQFpOKKmOyBxzRkK3+R0gZNzB95HLPPEvYp0tMrgmSD9IoUQLmCkJgx9IOjQL1v8BwSuDHvq2Y/WMbWCwVqDwaKu/qaIY5qttlS8P4vvlkLFN7WeoYKtzM8Wn+q/XrKYatEETbTnNsYk/9ePRKl5/7U6q+oWloA3bYMg3WV7zCF4xc2rBUr2huJBVrRy9dfVlNK4/fduEZMkF8jJmYBskcssX5LYmkLw78P90tXATOciVMofdhd7FOTTcGHMMH9f2xrAzY0vFSPiI1zpeMYC/bHdrtIi3Xk9BiP9xRlFXpbq3zuovQMXescXQMQTvlkUKnvbixDC6wdsOszNremg28oWDxse7BcEIMOBGN7fcEWQyJnFE5MRKzgwuG3EoCu7hDAaij01LCmK6i+HxMXGWDAPWZi6wV4HhXwT6j3pnRB75EijnNCNZ2xE+LrElQiiS+Qc+VS3JnHjNs0vghfgKSM6cie1p7vOE6OVwNqycVUmuCzGl4jVnnLm0lRvJXPjwKTNTqrOeNWiyp7cH0BBNZNeO2TJLQSbP3calXW6Iajw6
 pYp0T/ZF
 nyDKT9YKG056RF8jWsO+05w5yLIMg91zFm9VAFi+Z20k2t5660zPL9ZowNB9eK4r5rzb4y64O7lCkek0cLLAL9YgCeqG0uxq3OXODMrpj6LHR5+TT0Faed815kbjDLCfARrgn9aF4WaMMnkR0a4l7UqotopYBNC4crCgCtr20XExWNBxqs9bKNv4esypyffia/oSMTGdHlTV93FoNRZ1V7MU8GqixIfi1qzdIFRKGODjInmVbc8R1iGC6fsCHs9vxGRPt93mvoWPjSuo/x+Yy77oCWAPiaJ6rD9xkvO0UX+iqc77MEyjtGIvHm6Vsr4Sgz2GF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 06:23:56PM -0700, Jakub Kicinski wrote:
> On Fri, 15 Aug 2025 20:16:17 +0000 Kuniyuki Iwashima wrote:
> > We will store a flag in the lowest bit of sk->sk_memcg.
> > 
> > Then, we cannot pass the raw pointer to mem_cgroup_under_socket_pressure().
> > 
> > Let's pass struct sock to it and rename the function to match other
> > functions starting with mem_cgroup_sk_.
> > 
> > Note that the helper is moved to sock.h to use mem_cgroup_from_sk().
> > 
> > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > Reviewed-by: Eric Dumazet <edumazet@google.com>
> > Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> 
> Hi Shakeel, looks like you acked every single patch here but this one.
> Is this intentional? :)

Nopes, sorry I missed it somehow. Please add:

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

