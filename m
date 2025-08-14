Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3024CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 22:11:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F1F9001EA; Thu, 14 Aug 2025 18:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616E39001D5; Thu, 14 Aug 2025 18:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D449001EA; Thu, 14 Aug 2025 18:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 40AF19001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 18:11:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8DBCC07F7
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:11:11 +0000 (UTC)
X-FDA: 83776759542.09.5C9BFFD
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C2744000D
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:11:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPZK4k5e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755209470; a=rsa-sha256;
	cv=none;
	b=WBiiTs4IHP2RvMukTNWLM8d8fm/J5knDapAICQZ8/SoBH/4tMA5YMnH0WHCDieig9YACuM
	Zk2neRyeBEaykv2R1B+/ieOpcejvldNzA/QKc2qoJ4DB6YCnb0qLnytX0Q5uS1Ge8A5t0G
	9iarwPg/b4tjpvLCM2BmVPbG/+Lspxg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BPZK4k5e;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755209470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0BHr2ukl5jwbJzHutWmcqnBqCEqI3BR/SekxqoJVhI=;
	b=KfyilMuEAadxmuyra95LjBs3YQVk4GBzmeOngr7iSJCzXjJb7PDe6vDtuNBWPWzTd3eFS2
	Xncsevabs5y45h3D7LMWl24YSl+NjKGHdk/OImXs0nn6I2lmd87x+fJZ8fqfXV0Ac3VxFf
	i7v+2CPhk6Edp6y0bxpKXpBOFPEAiRY=
Date: Thu, 14 Aug 2025 15:10:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755209468;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i0BHr2ukl5jwbJzHutWmcqnBqCEqI3BR/SekxqoJVhI=;
	b=BPZK4k5e0zVdboI4PKyMCDpBMB7Y4efDzF01CdZWcizL2hxM9rYEH+VFigNROxHVY0x1Zk
	RRX8fKL290fEoMu3B5pmJzoJPVs00nhmbr9Ha9JqqWXuNB8dh5ayXPvGT+aSvIRBw2v5n6
	HfpQafRwhFcbM8ccDvmdOJbXYX3xYo0=
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
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 net-next 10/10] net: Define sk_memcg under
 CONFIG_MEMCG.
Message-ID: <nrtnpl53gxzwkhgntgdd2cxzf33fdsqh2hzwd6soidvf5mjeki@ck63r3n5maev>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-11-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814200912.1040628-11-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3C2744000D
X-Stat-Signature: 4r3wui37k3rbqanpj89dzwopbb75aoxr
X-HE-Tag: 1755209470-557391
X-HE-Meta: U2FsdGVkX1/jtOwOhlttBJK83egFerQNrvCVg1O5FO+sMgWU4SmuxMU3/ABnLCOYfJqajlYG52ZLBRkeH9cQbn4MIiaa07jYGN6N16quh9NQiP0yce7z9opZF/fi0zSFINKxIp3OgzMKxfkXRac4SlQFKiWmeM8ILW4X8+eKU7r9KmrAtAVraFRSchUeqF676p7YugPZn/qmb5rJE/dSq5cyqMcENJA2xd1zEfX/zyanXFlQvyndiZEU5CBTHzy3DMChCORFW8+SUjOGruwe9+kwwAPPFX4rCa2PlJPlDXSLing22UsIGgJKL+7BWK62S/BYC05er5e3V+7B8MCV/foI/2crk10QTHZmbizYTGZGZpwQB1Wzn8e9m6qWcqqj5KyWVm9ImTDQA5ZKO0ZGNSbPFm4xLCUe//7NS0K5jK5qnph/rrHWSp01KF4RNvKWQU21iN0jZNmr3sP7k0POJrU6q9UGJgmIznpH2YLSCvIF5ySofcqYV2TWIij0hO7mtV9W96I6rFpefaNiCwtaHFp262FzOVSZ/8lPlhOflysedz9uClL6SSOB2L1NLnZ3YqG/++W4xqMON79q+2tv85BjXY6St3/0wOb5CUknOtY5x+W5pAjkS5LlmBRn0owI373HSaYEjzgtcfC0mDFJFOBux83OvHzRW1DLEA4S5bI2a3rwpzQclFOfcdNHPwDY2936iQxio9LJ0FiuErgTZpOybPvGX1YHXR/JCqajnqbuvd/ongrmmX9Q8Q15cb+/T5iXNP9Q+e8BC7w9HzdyM9zwAyLrKSCGgYZa6vkqw1sC587av4Ob2g5yJfNarhsCflQDNJA+jP0IUHFO4pz+IS7gLpaMUosu1HU57rN0vdn71JpeydxMJUgWqGfnMv+wYpoP7XALDupXJXW4P1KnbhqQsWufNG3Ytu/T3HsCJf6iLEFlRKKNchrkfCIb8AZbMKYwlCoUFMQfVM1k8UJ
 ms+/rAvc
 kXu8NFKMauLiTLvRu5WAlLkBY6WZ9ljFca9gS4DH1/93SMHxR5TVMIpPdJsV7hcPFMaqYFtYxaY21nW68kjZLtk+oX+B0EPZJQ/h84DhHT/hlS8U7WC4qNmtFKSqx89KurH6gnyCi/+fs8fsQDo5AypExXwsiiA2tnQo30zqI7Zll9E88quuVLh8EpuBfQ/KUvDDcLkr9bdHgmtcjE+0Qr1f8Z1HVVCb2sVl6pCDXuwq9QrdxWK5Kqh9xl7/OHO1l+1fsMbsPu8MnplY8wA1kFyO+nA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 08:08:42PM +0000, Kuniyuki Iwashima wrote:
> Except for sk_clone_lock(), all accesses to sk->sk_memcg
> is done under CONFIG_MEMCG.
> 
> As a bonus, let's define sk->sk_memcg under CONFIG_MEMCG.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

