Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C192FCA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 01:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635A690002B; Tue, 12 Aug 2025 21:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D088E0196; Tue, 12 Aug 2025 21:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552BB90002B; Tue, 12 Aug 2025 21:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 456418E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:50:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED0B61DB185
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:50:32 +0000 (UTC)
X-FDA: 83770054704.17.3F1F1DB
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2F0308000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:50:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SF1rT0tA;
	spf=pass (imf30.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755049831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y8eBs0fHI7CmVwCx02H3JMhe4sR4fjcsdxnZfKRbvCM=;
	b=xZ/4quSsx39jeLi1ot+JWFIpAW/Jcb0w6ERTQBQxoX+YtIhXtwdPgH9vn0hUP9bJhDsmwM
	oJDNDOIM+jdXOTew8PeuVCIBE6cKB0TMSV+09GkvOd8F0quC+zeH1Co6rRk2vsDLB58SmG
	hmVFxb2SxRh4Bl3owCUW3uWiVEFUtWw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SF1rT0tA;
	spf=pass (imf30.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755049831; a=rsa-sha256;
	cv=none;
	b=eN/jDQghGc5EJlMxNG7F/13Jegskr7mEn20/Sa9tmyG9qvD4+vOCOAtNGHGdpusnPTKTh9
	/+wBJ5ljZz78WnvSm7XxK2R4hYmJ8luaGQYavCLvtbXcrIY1eFPsrRMEmKT+2iZMDjcL5s
	EZGUOYiHErgbZAy8npYAG4cmiuaVGrY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755049829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y8eBs0fHI7CmVwCx02H3JMhe4sR4fjcsdxnZfKRbvCM=;
	b=SF1rT0tAM6JS0llX/Cu01eukUONtWr3JXh1MlsvRryqzvc/FfamrPE9KmmQ2GbColMhSuS
	I6wp83nQACLp8cJcVKIMxJwC+2qdTTe51goUYp7nNXjPFs+XhEkthpfgWEnL+wQgornrFK
	3hGMiQHpJklYImJ1u1HTtG4dUoIDHEc=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,  Eric Dumazet
 <edumazet@google.com>,  Jakub Kicinski <kuba@kernel.org>,  Neal Cardwell
 <ncardwell@google.com>,  Paolo Abeni <pabeni@redhat.com>,  Willem de
 Bruijn <willemb@google.com>,  Matthieu Baerts <matttbe@kernel.org>,  Mat
 Martineau <martineau@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,
  Andrew Morton <akpm@linux-foundation.org>,  =?utf-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>,  Tejun Heo <tj@kernel.org>,  Simon Horman
 <horms@kernel.org>,  Geliang Tang <geliang@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Mina Almasry <almasrymina@google.com>,  Kuniyuki
 Iwashima <kuni1840@gmail.com>,  netdev@vger.kernel.org,
  mptcp@lists.linux.dev,  cgroups@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v3 net-next 09/12] net-memcg: Pass struct sock to
 mem_cgroup_sk_under_memory_pressure().
In-Reply-To: <20250812175848.512446-10-kuniyu@google.com> (Kuniyuki Iwashima's
	message of "Tue, 12 Aug 2025 17:58:27 +0000")
References: <20250812175848.512446-1-kuniyu@google.com>
	<20250812175848.512446-10-kuniyu@google.com>
Date: Tue, 12 Aug 2025 18:49:50 -0700
Message-ID: <87jz38q9c1.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nq5qbzk37815ebhpwf1zbereb5c5x85k
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F0308000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755049830-224362
X-HE-Meta: U2FsdGVkX18NVgm7uN0bhexUzt+FU8wHKvMsJGq7hogNaNiPzZ2+bFVE7JXFLUUF/vW0rKXlf2eEW/WBT7l5j0W915a9eDMaEdJoGz4WUUjsm+FAVMTmOy857eU589f/pZ6Ixh+YxMME4GOCmxw6X3qpa5ZJcsqi9/Q9XKgVypLrCGARGzYBs4AksfSYC7iCfXURiZH8Q9NN9zP7GwGTh9Y6lZZUpBO+IxOpSP2BASrRhfvEG7gkAKX0hPMDv5R10D6/TStULmrsIn5RDA5eJjq0zuEK69iOm5TfFZ8Ip8LfqYunBmqdjddvPxtZwSQtYO4Zi0pwbmXzujSMWoMCBvIGcTMu2HevosRCW+XPCeVXRACFNEZgDixAo8XM4i6MfEdE04HJVgNQS4ITZKstRGZyHVyXatwd9eCxgM1d5x3SgSj/PWNJfQNR2m7ASGKWCcLhFlF6tkQSfAQ/mBdSMdkBmEselZ4aII3CFuKkv26uwyljszwdKZ2XkrLKIG/2Jj+W8sb2gfSEpZO7NDX0bo1dvhEqfgAqkWEOPe/yUieR0mb1dpmcfI0xA7yGGp+mgxnb99KPR+P/uWEfsdfLFulCxvZWEIfqLqnd/SxWSXVqf8y5oHH9ifVUyHr8BSGsarLcOl0H+TrRGwyHYw45FKXMrZfAzAK4136UsN0OXfO4MyyK5+tGm3ri0GNg8qP7ypmLZKEkoJOnpIPm2ypu9BwYRvSQv1NQI7K8RvqR3DSHxgUF0xBOoKeF0IcX8bYcp8q+fhByleEqTusuys33KN9E4KGG4n5KL/Vqn/MAos7YvljLyjZKB09g9qCRTewHNtFcWRdXlqx+Q0gTkleswBuA5jyhtDRxDJD2ux7NiTsljGJ+A+2UF+L5q/RGu2TIO5Ca80FK3egv1uXfMuTha6TOMQDtbwmy7IGfZEf4DSHLgmC7onROlyprBeJ2VICK00c/C4vlaLJTDxV4zIl
 74bNSIiU
 ocNe275gB4PnHxMf4wZ/vsWa7dE2+yX1UPgdQTl54EnjIJdboO8WmPJyR0SCBG2jCCuBFlMLWb169kttVPjN557ct6MWZBx+s54SOLnelTJGHnJn3C+dtfKKHjX9r6RQkSv/qWmS2Utrt7Z7ji6PbfmcpDYMJl0n8QKJ6Ll800s99ZX7P7xRJJ1sxRC9icD3THS+Suq3Vmvy2TP73Ixn4DMXKQ/VAsHEb7VBo8rkt2oWmehVeDCOW0KD4TZUx/MAWQyOHNAnQraf8cqc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kuniyuki Iwashima <kuniyu@google.com> writes:

> We will store a flag in the lowest bit of sk->sk_memcg.
>
> Then, we cannot pass the raw pointer to mem_cgroup_under_socket_pressure().
>
> Let's pass struct sock to it and rename the function to match other
> functions starting with mem_cgroup_sk_.
>
> Note that the helper is moved to sock.h to use mem_cgroup_from_sk().
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

