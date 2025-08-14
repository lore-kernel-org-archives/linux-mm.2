Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 169B1CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 20:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7579001DB; Thu, 14 Aug 2025 16:21:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A51A59001D5; Thu, 14 Aug 2025 16:21:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 967969001DB; Thu, 14 Aug 2025 16:21:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 828CA9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 16:21:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2FEC51DDDDF
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:21:51 +0000 (UTC)
X-FDA: 83776484022.28.105B80F
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 448B0120019
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 20:21:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AYlpvdK7;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755202909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=889VYTRIrbL3AsWcOiJZXGuYshjOG6r3nV8h7mnZeGo=;
	b=NHpTvSGQDT9Uh3+0chSjLj3kNmSywB3kJpq+EEQaaHX/PLcPDIQ0MH8BwAB/ljzVKXGLXe
	zbMQe2rrRhhb02XncRsvTZAxIBViOYYsyJs/78khfl/8rSMnHBj1TQ5Si3dhZMhn02VNv7
	jhrUFRJ98TPzNlpXWQp2qLiK3pyUDwg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AYlpvdK7;
	spf=pass (imf29.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755202909; a=rsa-sha256;
	cv=none;
	b=UpaGnn1Itre3+4s56ienXoqx33yKqLmX4Nt/8Z62h3uHiSOttyAe2+a0ZJF86ouhqZMEXB
	uMgiuIg82U0+OaXImi9fCGk9VtM08ow085b9FrJymvrzu/dkUl4wRfoshcLDE1ax8r4pcE
	hKS5DoPWNinqSlrzcoOJjQiFgdb6BHI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755202906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=889VYTRIrbL3AsWcOiJZXGuYshjOG6r3nV8h7mnZeGo=;
	b=AYlpvdK7DjpVAS/UM1NYteoAytadnZdoVApEVlZwGSQBgzH6J+vMAPj4+JWjquYjK8X0z5
	eG9bgeus6GC4N1okdQkTVZW+gfU+jn+Mi/hNMgxrTijT6YWoZhufcdP1T+WSlKD36RdA3f
	XjhOHHO0bZbB9SDh0THNG9EOWeH6KEw=
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
Subject: Re: [PATCH v4 net-next 10/10] net: Define sk_memcg under CONFIG_MEMCG.
In-Reply-To: <20250814200912.1040628-11-kuniyu@google.com> (Kuniyuki
	Iwashima's message of "Thu, 14 Aug 2025 20:08:42 +0000")
References: <20250814200912.1040628-1-kuniyu@google.com>
	<20250814200912.1040628-11-kuniyu@google.com>
Date: Thu, 14 Aug 2025 13:21:24 -0700
Message-ID: <877bz5lkmz.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 448B0120019
X-Rspam-User: 
X-Stat-Signature: k6b5fo7uhkhhtbcqetefddsy9j7kzaqn
X-Rspamd-Server: rspam09
X-HE-Tag: 1755202909-678075
X-HE-Meta: U2FsdGVkX18iJoQVA6k8XrZDjb4w+oMqUdeOObnyN5T62t4PSOSHEgJH8GRWCoYJlf5IAI4kM/YETIqda1dPNt1m7GtP6rCXO1ft4ziDif3Q9t9i8H2FUin8KSs9fYns6rVeRWVxT5Aa702Q6Kuvz1lPDfyMyjnSin1p+TvrdNrqcY+7tb5YqIXhngy09Ho1OsISoBihMB9394n0TPBew2xIcE4hLG08CDpS7NAlTR9lbs7ayapPXQw05WpQslc3uq5fLESVQIjhoR5H/duaImzVW7/RqB27tLHiKAJuVCHTjoeRE6TG/03BJtJiwOeA7xUbAVBw+DfupSnayf3sW8u0WtZ9ltTHzLvct1ea4vr6F4waVjNJDGwXIy/n3MtP/RsyOM/lhKuBAhxGB5hHsm1ojjgvvhaeuUSK6xDFZVgCo8f5JUSO/yMGiPUvxwtuepNEGDFVUAGvK4YVTKfIyVjIsVD5mJLgSXF97XHqzVFyasDSP50T/M6yxUxCsF+jv7ZJ0V+p0V5u4z0op8qbDxGnjoSScO9oKkhfq4OAZcnhiu9BBVyO3hmx3mNxi5UmeMd1zkEzsqjcXqHJZhjiImcacvuTfuK1OB5mW/0Tdf5pZFPBv86ZnBU6jK6feX167mnffIONx1EpaIJiTWk5ZgLqOUOCoqGOEq0e96OZOr/4il3bbi+XxctGLPOCh7jXTE08cTg0OfQ6+9wznOq4644nMdWBR1R7X1UO3WjcwQncxOM45BHwvNfKu7WSCRVD1q6KTbqa0eSqsCNnCHMd33iJgU7P9s66eFq8dUMncw+iYc/1HXZD47vUpxsiQu57TZu87YvILYgNZgwPmyOOS+An9jOWsNQQgoYN0RmQSTNIUD2ge2s3k/Lp6I6anQAwjHyiwkvZLBKRDzwLkqD2c7pCQtSzfqQ12gtU02MdmjEqrcoysqPcqrpljMWEhUIOW2tpmaqAxTVzEset0E/
 Vr+AZcM9
 wcHoYlwXk/Y521tl7BfdWmN+QdqNRxTAoC1NQlDmAt7ZMuKEnlxZDto3higrX2NWS6irYoypE+nHbV+Lt8NLFElv6EnHOgK8PjMnm1GoD4hXoqkB7Ya0Jx8X6UG1jDn+7GKefSfbWrl+54+lc7XKs+GZopIKWM5g6TUsXfDeHrKNpYWBZpBK+YUO1wP5nxcetkqPVBKWT0Ww/Xm/Cm4fkpdkjF8TVKKmxB2bMniyRofFrfTdkDOUTzSMg5MmR6/KtXkGKRaptGHxRbhw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kuniyuki Iwashima <kuniyu@google.com> writes:

> Except for sk_clone_lock(), all accesses to sk->sk_memcg
> is done under CONFIG_MEMCG.
>
> As a bonus, let's define sk->sk_memcg under CONFIG_MEMCG.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

