Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B8C2CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 22:10:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 182279001E8; Thu, 14 Aug 2025 18:10:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10CDC9001D5; Thu, 14 Aug 2025 18:10:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022CC9001E8; Thu, 14 Aug 2025 18:10:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DDE839001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 18:10:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AB25FBB387
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:10:24 +0000 (UTC)
X-FDA: 83776757568.24.EB82DEB
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id C602240004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:10:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VhdoxPU0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755209423; a=rsa-sha256;
	cv=none;
	b=jxjm0CX/EoIdmok0R3tDT8WMnuNKUytTIekLU/BqeuqMeJsqry+VhZ0OZ10tACTNVbO8+b
	6ZwPesmkmDCc/ynp8WwIA4E/xDd1IpH13Kh09f5Z/D6eTiWhQBrGbIPimU9q3ZdJdXWfik
	qT8bjQhrvVxOlS00f08aojZ1CKLWcso=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VhdoxPU0;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755209423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7tFtXLy/+hhaWIDVXL9aY1SXSecuce2Q61K8VuI8ts=;
	b=we1PZ+F40IpHxI7Z391NxCWKaC7y6YsB8rjQK43dPiu/sv2Ab8uaYqmn01zFnmgTuL9rWj
	5ZGc4Eq0fmXT78IwwL1Jqh6dUodVAIGrojHazbcUCGGsIHcvtFuuQkVWpMcVCCs4c5iBh0
	5e/b07B+MicgeeGzzFXD1hbgmx7q70c=
Date: Thu, 14 Aug 2025 15:10:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755209420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=z7tFtXLy/+hhaWIDVXL9aY1SXSecuce2Q61K8VuI8ts=;
	b=VhdoxPU0shDMzUuoEFJUozEMykYZnj/jMFq56KuQnofRodUyq7TJLbUc4zeDCCEXieJfcr
	0G8fbwWPp012WugCEUb3Hx3RzB6Ktl920jhFG7T87bVom+4MbHGkDKTWokB08Hbc9IQs/P
	ol0QxVXY9OiS6yM4O7MxX70nS3cc5Hc=
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
Subject: Re: [PATCH v4 net-next 09/10] net-memcg: Pass struct sock to
 mem_cgroup_sk_under_memory_pressure().
Message-ID: <7pbqwjm4yl3oxebibihbdqkdusamnnui5ypzhfh32pxfkcordq@o3hottcdlavs>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-10-kuniyu@google.com>
 <pl47mmcmxu53ptfa5ubd7dhzsmpxhsz2qxpscquih4773iykjf@3uhfasbornxc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <pl47mmcmxu53ptfa5ubd7dhzsmpxhsz2qxpscquih4773iykjf@3uhfasbornxc>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: C602240004
X-Stat-Signature: 1ib8jmamzgrqbiat6j5h1w36etqueu7h
X-HE-Tag: 1755209422-12268
X-HE-Meta: U2FsdGVkX1+VjfrXKkNnJXwlPa9ElPZnhCCegMl3/8hLtvWLDPZYiEv5qIw+EJPHFzsxyy5L8K4CVL0g1g15GhmNJGBNZbeButjWaTJDYftArwC8bteYezLVb0rE5vg3SgexpM6LAYQZgnA/oaUwSK/lqO5dzb79MAN7SbifqZJm5DSEkRGeA8bMcnw85Ovdsq3rf5WcIwlaMtRL09GahZ+to+uE1JDst728i5qaxTBRktPiz6iJuDYvGEwqyui3j93Wq82ot/DiCWZn/HmzvJ3FZ2FhUoCxvZ00YBpwmCGtXq6+HftTnafoSp+NiMs+OdzuGy2lTS15inyjFwejNm/6g2/kcLqOYgssO03hrnKttiC7DUmDuboT+d0nIIBUllA3qeZzPVW8aJA4f8DoHRgVKJCIEVufLl6gVK7L5u9l0F3lAZNVupCj47R5+hGhNfK+7IozlRr7OBFg4qjxrrdHi9hwB5HQ1Krlao7vLSWOyjcsWQy7+RxccKJhAOxrYyP+8qSx0rfe9MLz+UPAQ4C9P/0qNKZNQbj7Od9kJz7XbheZFQYw3RrkUJZToTzY5y5/LyJGXRmCDg+wKBurbtIBv1tY5jjuAsyMawIwu/F8qqXWgJhZrNALKpbSdeU8pxtbwfiD8rmPdbk0eoOiAs7583RrnA5WoLYZgKPQn2F0cEhsyoo7mNJOB/xiQOlulVMJGRdMXYZe4qD1rRhVGNkkO9jbfZMwNoQAbtBEfq3d26eacdt6cB4uhToGAwlhwpncgvF1KIavddZ6Psv2/sNvIZgfxY8Gr64jlNlE/xsb0JCAMfmahJcPGOMDiZchPH6rK3bGC583ze09RVqg3Ms/FlFsZRGhz3QsawKhLsL3xNWJxbvcQvSrfJYDnjfpVzOrgfb4TtfhRMZu1zERFXXa8ie7kdD4vJT/cojGHPVqRkvuFf5a0BLuU0HxpvFXUmqJ821Z9q3fuuOCovn
 5IpU0LQe
 NxXVPPHvV/kZNJyCZV4OpLaNpbX0teIzbrtrHHYle1bZtPfBtMLEmpaOO/uILaV/WxZKr8M4ncBVbfcImPV9bHbEAamuOix+y//V3oPpWaTNSbIT7dq4Lbl1RX0FZZugldTj8dT6udiRnsmuU5rlyraRE6K/z/5YZh1WytNUnVznMfkJuc+QV/XBH+IA3ICkhXu9bv3LRIBmXvSrtRqcnI9/eysDP+BroZNdZU8m/TIBHZBLKg45aXUFx/PpoR1fJzh10
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 03:00:05PM -0700, Shakeel Butt wrote:
> On Thu, Aug 14, 2025 at 08:08:41PM +0000, Kuniyuki Iwashima wrote:
> > We will store a flag in the lowest bit of sk->sk_memcg.
> > 
> > Then, we cannot pass the raw pointer to mem_cgroup_under_socket_pressure().
> > 
> > Let's pass struct sock to it and rename the function to match other
> > functions starting with mem_cgroup_sk_.
> > 
> > Note that the helper is moved to sock.h to use mem_cgroup_from_sk().
> 
> Please keep it in the memcontrol.h.
> 

Oh is this due to struct sock is not yet defined and thus sk->sk_memcg
will build fail?

