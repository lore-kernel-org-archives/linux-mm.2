Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994B2CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 00:54:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D30B99000E2; Wed, 13 Aug 2025 20:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D08BB900088; Wed, 13 Aug 2025 20:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45679000E2; Wed, 13 Aug 2025 20:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B4595900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 20:54:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 516CE1177E2
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:54:55 +0000 (UTC)
X-FDA: 83773543350.30.0A1CCFB
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf27.hostedemail.com (Postfix) with ESMTP id 459F040004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 00:54:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6HQjTqi;
	spf=pass (imf27.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755132893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdHhV4i8i+lWGHS2gl9FLlu2TgUgJbbs4bD/Zxld7c4=;
	b=rkL1s3GNWy/Uhsgo2lgm20d+OEG+wQ1sQQT+z6Jhb8QCw38IGFiwxbah00+eng3AKf4j6b
	q49GYdHqopoxm/Z9iZyczLLiOZwv9bIe2wm7DWGuc0k2IiG1S4zKS168tCE09LXU7En72N
	aRktsGzp7IX2D8plTotv9Q661mAxLjI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=j6HQjTqi;
	spf=pass (imf27.hostedemail.com: domain of martin.lau@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=martin.lau@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755132893; a=rsa-sha256;
	cv=none;
	b=noTN546w4s+AsLgijKjkv2lFglCPJTZdS+FOedRB3y778U2IaUbLyhtTKqh3bVXAiKQLAO
	AP5rOE0VmynZ4ePWstejPBo7XrjPLgRoPnjwKUg63NkovJIwycAhuUYgQnoTyu8OiOyHKL
	iE4UtPEdZm7EGgFUn5qF1hAUJ9jYKjU=
Message-ID: <e6c8fa06-c76c-49e7-a027-0a7b610f1e9c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755132890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WdHhV4i8i+lWGHS2gl9FLlu2TgUgJbbs4bD/Zxld7c4=;
	b=j6HQjTqifsSO2Uppl1+E8juWlz85WB6Puvvo38zR0af1UA37Dw9SimZLmZuB9dm1eOcmBg
	ClajNZt92ETnf/J4hcXbQq43iGyGJsz35Oj+8z3oHgpyWVoPyIp+xlvpV5UK78DWgLMmi1
	7Au6epSZeq1y5zb1TVkFgVNw6Q6r0ZU=
Date: Wed, 13 Aug 2025 17:54:43 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>,
 Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>,
 Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Tejun Heo <tj@kernel.org>,
 Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>,
 Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
 mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 bpf@vger.kernel.org
References: <20250812175848.512446-1-kuniyu@google.com>
 <20250812175848.512446-13-kuniyu@google.com>
 <w6klr435a4rygmnifuujg6x4k77ch7cwoq6dspmyknqt24cpjz@bbz4wzmxjsfk>
 <CAAVpQUCU=VJxA6NKx+O1_zwzzZOxUEsG9mY+SNK+bzb=dj9s5w@mail.gmail.com>
 <oafk5om7v5vtxjmo5rtwy6ullprfaf6mk2lh4km7alj3dtainn@jql2rih5es4n>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <oafk5om7v5vtxjmo5rtwy6ullprfaf6mk2lh4km7alj3dtainn@jql2rih5es4n>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 459F040004
X-Stat-Signature: g11fowhpa58ghheghchis481jqbzs9ne
X-Rspam-User: 
X-HE-Tag: 1755132893-655819
X-HE-Meta: U2FsdGVkX1/EQ0mDDifwc6rgbZL8wlOHbH+B4+9lzUzOMkgeuOQ8t7pN31myTZGNgNjBifrakcISGaQLOn6vtbEnQvFJ0FR5UMPi+0ML0oQhfh1n2SHiII8GGabwdVEvnac/oLaBHBkumJzxsDagd+bRPskXR7cB0Q3VuUzzINa5u1BxCMpT0Tu3FcepgLuLF+V3c+Axq+8+0uv67HaKB4Ymy+I69uAdOCZoA3SyCR3P75ZlqjBLLhDM5F5d9a76JJtIxdpEFPsPzi2jHBJbpNdBx0OnpxqDBGu9nD7ofnjMgDy5jzZg9B0395pq5TtKTHZB3azRVHikPNNkCuvfDrE63XrGatJ1Rox0leL5cX4rCPYZD3k7ErT4mpLw8FulScgL5jPcDbsUHogv+2gN4sDuaWk0LA1HoUtyyoAkh0kyV6DFdUkV/XPqlYv7GtO5f57MOCm2WBfvlcRUI6WQNGa9DrWDwCHTtabjPhOa/s1bsC1SvGUSJK+qrTynR0BNrFBImJ54NiMBNfbXyZHGVC61ZrocHhIXBzCNB+a2McrvZySlebcS00wwGTmO/OJmAOphLKW9DN8l4hz5Ud9MfgeVnsfITvuUAyi95P768D548fA+Ndso54mtWKGrOgALwLy788Kk6EWKmzZ+rGumA7K8vKy1ir1UlsmDNJZAPG5Qcke0R6Ttt97rxuFGqVSKmLqjb1POcCgMf3zXp9RBljEiaR9eo+cDEsHmZntDrYCc4jFY/hsfWJGvPEzvrQJoma7/Fc9vvP81wK7CrC8qnXaztCoJTN/kDm4J+0YFCrTAS6r3KAE75KZ4JTdbn+YRNqmknYJgASKku7FdVqyRmbG7kY0B8VFPMZNqezUcJuY3XL4A51NmirCAQ2Wx/6N81AzV19ikJH7G6ZECZFJvKCOUqnip/QGENRdBcFTlO7lS74KMP//zUti+OVcEnmhyKcQH+Q87eZMNkFPH7Uc
 ME/twbd9
 Gx4kbMDKbjyd7/13XkAk4VKQX9qVeevHgJfWhCehnq42YmVNtVNTbYfJ3+3tRQV/ojgXWz//n8X7Jcj13ehy8Mxeuc8MS4sz9ysFhewIJGuSawyu/jjOlF+qi/dJJ3g6BiTNo8SfR7wcEwS3LiK5m+yWdICfZS5YsLQS3qkt3TxT59BgvaOkumvSagWXBbS56aSvMV2VIuYeAa6cnmXFDxXbdqA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/25 1:53 PM, Shakeel Butt wrote:
> What I think is the right approach is to have BPF struct ops based
> approach with possible callback 'is this socket under pressure' or maybe
> 'is this socket isolated' and then you can do whatever you want in those
> callbacks. In this way your can follow the same approach of caching the
> result in kernel (lower bits of sk->sk_memcg).
> 
> I am CCing bpf list to get some suggestions or concerns on this
> approach.

I have quickly looked at the set. In patch 11, it sets a bit in sk->sk_memcg.

On the bpf side, there are already cgroup bpf progs that can do bpf_setsockopt 
on a sk, so the same can be done here. The bpf_setsockopt does not have to set 
option/knob that is only available in the uapi in case we don't want to expose 
this to the user space.

The cgroup bpf prog (BPF_CGROUP_INET_SOCK_CREATE) can already be run when a 
"inet" sock is created. This hook (i.e. attach_type) does not have access to 
bpf_setsockopt but should be easy to add.

For more comprehensive mem charge policy that needs new bpf hook, that probably 
will need struct_ops instead of another cgroup attach_type but that will be 
implementation details.

