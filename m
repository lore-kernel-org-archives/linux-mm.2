Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 904ACCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 01:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C922C900026; Tue, 12 Aug 2025 21:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C423F8E0196; Tue, 12 Aug 2025 21:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F23900026; Tue, 12 Aug 2025 21:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A55BF8E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:44:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 305BC1DAAB7
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:44:53 +0000 (UTC)
X-FDA: 83770040466.01.4FA7594
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 489DA1C0002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:44:51 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TwZO/Qjo";
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755049491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ju3IzyV+nwWw8q+CMiCFqvNpGRTMi3k8lIo6iD9B+wU=;
	b=nS9IVVKU2S/S9Bon9CTp/G0d6ejkRDDY00IaE7XLVW2cVkAFNhODtaey9Q/1MffX4vM84L
	+sQTuvBqgQYSX5EMQwwsaskE5j1ohYb1F0rO4dQ+AH5xgofM558znogKcr/HXXflSkCzgb
	T2RmfoY6+YsHsw2iv8KYftUT7BR/doI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="TwZO/Qjo";
	spf=pass (imf18.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755049491; a=rsa-sha256;
	cv=none;
	b=5+DrsZSJUzCiV5EUj3RRhYts/2zXM2RG2oTVU2IpxD+iqMjEjT63o8B2UhdD8lwgU3XbhS
	6eaT1YcHTEoYgAUQU/+moNPyKVax4kVs8pOW/9kUYwfKZDqDMEWjRLtRglxtf5MzslsVus
	GFD7JNy/caPYM0aZGjPi4RJfxEcDiiM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755049488;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ju3IzyV+nwWw8q+CMiCFqvNpGRTMi3k8lIo6iD9B+wU=;
	b=TwZO/Qjoduloapf+VZQpI0rUDmTFkgAESYLuJYnaWNHEEM+EQaaOnbYY8PGxarfopE7Y94
	EINdZ9pz8+M8c8wqcwMip29gm8stLwLlpcMaZrd2kJerqmJakkQlaHXsLDHYMaC3b0XvRr
	aUiFD+0ONOTF7aFJex9Mmqj+Cgk2SpE=
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
Subject: Re: [PATCH v3 net-next 06/12] net-memcg: Introduce
 mem_cgroup_from_sk().
In-Reply-To: <20250812175848.512446-7-kuniyu@google.com> (Kuniyuki Iwashima's
	message of "Tue, 12 Aug 2025 17:58:24 +0000")
References: <20250812175848.512446-1-kuniyu@google.com>
	<20250812175848.512446-7-kuniyu@google.com>
Date: Tue, 12 Aug 2025 18:44:36 -0700
Message-ID: <874iucro57.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 489DA1C0002
X-Rspam-User: 
X-Stat-Signature: 7mzegytpe98b78ood78ho5trczacst87
X-Rspamd-Server: rspam09
X-HE-Tag: 1755049491-906151
X-HE-Meta: U2FsdGVkX1+5nQ40/qbLlS6pgiD2mxMSQ9KFg7OJfOxNp7QDwFqhkuPM0d6DhlLWhw/vxy1vRi6i5cUIJd3BAjl2U6iHS1FfNEg+1zefcfFyv3qL0bQYJiZDLlj+VvWFBy2Nfc0Z0JeED8OpnNIoQiofxPK5vWIo+NF/fElycAvtGo1BYGD6A+V1TZpRn6hjg1y1ADyq5N6m5UrC+m9lOcc9jwx6ICkZu8GxClNjLvuzKYMvGUmBQBB1Jj9k70394T1Y8Ud52FKvGck+OmjM7YTmgAFd8/0RffD409Z7IiipxcYqw0uCHF0WjWZ8xYGrnyI5GGkRbtCKU8GFyvKE5FgMER0g79WwOPg01tOELh/UlaimyD3Z8Cm+ARgbSobRjkSYvvx+/MC7qay+SChwkM7GB5d4rBcXkWI/5bSW6Or4EXEXTs0D8PUj6dQKAlJb69zEO5X9Tp2Jmbk2EZop65YvSwEsExvB/hhyVvmxnxRW/tyLbN+OvyeLlIdj7JgqDLg5j14IlZWEecEyfdlVxqOLUr196HqcJv68kaGC1kwfIl0db18o04kdZVstIu1c8uUPjO9mLqNfUqS+KTp3LQbbtae6QrXe0INL1E2wHhFrBLoFwZExfo+tg9z5nrS7lF6wOTQpGwkx+NjMLZoYqftORvRhjrTq3wW3vTZEm0fumeXOiPNXNbl7UgUtsvqYiTN1zmJCg0hPh/LsbJXESFGiALi0FA+i4xUi/3rY6YPUgSolI0+TZZzKtD/Pgs0dctw5Kq9k9uHq5Tdprsbj0dTnCHaMtv0jMp/rRO5SKr/sB2sT5haO34lo6uQNCzwbbCmzkeEPJndRIx9MowllXz1ARFnXD7DnR27jrHgclzl3wUiY90ODR9yyV46tbDyUGr6Wv5qgSy8jgVFCwLN5tMSdtxS2/ZqGzQRDO/qBvtBreAxCvZ9ZFJRR5k+/T2teOrfHCAM2F8YxVTaY8kG
 6zl/8uHD
 E5dV/Sq/C1pTDiGKby5yl1ZCESIy3FomzA96KsN2bQlikCmlnXYE/3RWJQyIlrcLtHqPbRxc6oq4z6jkM/w+o8Y28iXrAt2xnqfgbL1zEdFSAV7jT4kSiqJ07s8qU0o3qGC9AsDTWi/UA7TWYhGRuGu6BRv/pA+vHW+kF6yKKPe+llLAqfTm+gF0EWQLDgbTQN5CNoGwh4CDNk0iZgoH5xkSIk2WikqFbOiQafzwSzbAlJ0twBTd7dHfKGdFBxJYBJSR0okS0dhas7sHPM3FSaUOuD74ZhE1qLsJI
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
> Then, directly dereferencing sk->sk_memcg will be illegal, and we
> do not want to allow touching the raw sk->sk_memcg in many places.
>
> Let's introduce mem_cgroup_from_sk().
>
> Other places accessing the raw sk->sk_memcg will be converted later.
>
> Note that we cannot define the helper as an inline function in
> memcontrol.h as we cannot access any fields of struct sock there
> due to circular dependency, so it is placed in sock.h.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

