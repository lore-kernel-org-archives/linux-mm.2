Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87790CA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 01:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285E7900028; Tue, 12 Aug 2025 21:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D9C8E0196; Tue, 12 Aug 2025 21:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 173FA900028; Tue, 12 Aug 2025 21:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08BAA8E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:47:50 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9445581EF6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:47:49 +0000 (UTC)
X-FDA: 83770047858.15.DA7201A
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id D14C5A0007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:47:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FTYQkOUv;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755049668; a=rsa-sha256;
	cv=none;
	b=vLb7OGU4qkg09G/XWgawxXHdEV96dAchY/YdJT03VQ90pRBFI+DnjMDSRDkk7ZZv+lkKXE
	K9ccsNHK3a1MMhRA+6AbZOJUTu7h3hsdugl6EFhedSQQcYM+SaK/Qb0nYWC2o3ankjec33
	KZZLktbVCD7BrnzW+G6zcL2fDOaeT4o=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FTYQkOUv;
	spf=pass (imf15.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755049668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zMF9GFXJ6Qj3YiII9M3bcvYpqiCjR5wzUFfq8z/K6XI=;
	b=vDxJtG1ekM/SUtEf6uOwC0eAP58jFRHCUFkm7vFws/lbRTUrqHg/gwVPH7OaJ8K2fNpWlc
	3pN0Uuuvo5kA3RxL5+PZ9Cfojm1v9ooUgfYn3GxOjgRHIRocAZ5ct2zyVw3x5csQOy/65T
	K5mYXM+fpM++GR6pCl7wgoWVaWO5hRk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755049666;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zMF9GFXJ6Qj3YiII9M3bcvYpqiCjR5wzUFfq8z/K6XI=;
	b=FTYQkOUvj+t/XYrp4P59mJ9IAnMlXI/vjuCXT/xnTdWOvZYRD6kb6A4LK6bymUccbHK/bj
	0RWM80egWzvTKhb2lAJ6vtM6tCh9v8LwUgu+kRILBruyR9dKc9+q+UErTnzZrEFFb1tqYk
	Lv9ceKaVO01aJ+JpG804qpDDA6xiocQ=
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
Subject: Re: [PATCH v3 net-next 08/12] net-memcg: Pass struct sock to
 mem_cgroup_sk_(un)?charge().
In-Reply-To: <20250812175848.512446-9-kuniyu@google.com> (Kuniyuki Iwashima's
	message of "Tue, 12 Aug 2025 17:58:26 +0000")
References: <20250812175848.512446-1-kuniyu@google.com>
	<20250812175848.512446-9-kuniyu@google.com>
Date: Tue, 12 Aug 2025 18:47:36 -0700
Message-ID: <87sehwq9fr.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D14C5A0007
X-Stat-Signature: zs5s9bo6ex7mzejyums6marfrfpn6q4t
X-Rspam-User: 
X-HE-Tag: 1755049667-473047
X-HE-Meta: U2FsdGVkX1/2kCsN23pJX0ChRezLNP7qTliUa0Mo/BF9s1x0NcWL2orkkOx8+mvhujPk5N6ExfY5ijARB5BtTlh743uUUyTbCv4iJjXMGc1tD8wpKrQrUtt3Ep+4R9jf0E4B7TTCYCMPCeDQ5vk3Tsu/RttIirNo/q5Vs9UeJG406lRqRFS/Z4YtSSiOWsiCRtUzu0bdOeDGE+200SDyXdXwzq3qKVLFu2Nkwc1qLtfc4voR7jdXianBjvhgyFHcQ2dzuJ1q4CUnvjvjeO93GsoayKNFWI5sB632YltNLEttPnhLg4GthzrsfDgZqYRHT2geOyj6Plv7xx5iTmmZy3vFAWzQhDUoOU4dHSkgLE/S/Wy/ThjR2QFTGj+GnvT5fd5E7jb+JT55e4tlOqQo0WljxYk7Ybwq6mrMtzZRtHJ7923kG5A526mvmXcOeTTB0bqqoYzWHXg7qyGaZ5OoiyPtU83t0cVLB+PR4bube82Ik0wwMfjk4BS17cuitSFJqxaqgoZ0HPcqAJ7dAQN2EMnLEUeyOPKIpH2BNTAhW8bDSMX66qDIMcq82bXilvUeUwJEWqYoqH0hnwyxl1G3KB8EnBxS1waaEtFSYY+OSpkc16EJCMyyZthl6wmHYH1jTqsgl3AyVckANzmk/aY1y0UW09CutW0Z43/dPpeDsjcsBuRLu8hjTuOsJv/x/rgtTCkaYQ6peGxS9qVXSKq1sGdv2BhFTe0nmHu5mY3SZXuAB7WnGRZ6i7eIuuyHiIAHJsFecL39mnI/aUiu9EMig/2J903md6063VOoxUnr3wLMzQv0jvGsMULzCuyqDLPw8IPbf5ZXOgUMfkDNlrkJ3ZT7IbH1PSG0blssqA2fHBbopPnv1ShxO6Qa9rlnqWDGTaPWxIN98xVrO2zHFstCHjEIwM8gKvv8VDxjnHH7SIxWV+UT/YUhMoe2yY2k9Wiwylzdl9bpKhqVnuYevas
 5IiNIvT/
 D6azxQRZmFVtqW1S+IF7c89oCwcT/Y6b5jLdLa7alyCMwYKvyE5GEC+NUWbtXTKQrN3JxClNm8dXRJFQVL4FV00+WcrePx98sSYZEAGbvhsAHeRp9iEd1TUKrfuF+8Fo656V07anma3pipWndK6ZbkTi9D6WYouU2B+V5S8dlcOwngFmelTttI/iulCE1Yawv7vqaqnVUaXd7iR6vmB5zL6LmS86vIX/DgVS9mjL2zRTjE/YkPI/oI6W0ssQ8FZqvZ1XY+ACgZx5DQzS5CAumhbdZjO9hZCUoSQAafKc95APThlV8QiLcRUr3eg==
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
> Then, we cannot pass the raw pointer to mem_cgroup_charge_skmem()
> and mem_cgroup_uncharge_skmem().
>
> Let's pass struct sock to the functions.
>
> While at it, they are renamed to match other functions starting
> with mem_cgroup_sk_.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

