Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069ADCA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 01:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CE32900027; Tue, 12 Aug 2025 21:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A6A58E0196; Tue, 12 Aug 2025 21:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BC87900027; Tue, 12 Aug 2025 21:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC238E0196
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 21:46:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB49E1D93B5
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:46:43 +0000 (UTC)
X-FDA: 83770045086.08.184CB51
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id F3C0840005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 01:46:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=evfVPnTg;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755049602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8cimGdearmvYVQCy5FWmG8x9rA0b5/NI1ufddvwaDAw=;
	b=i9i8t3UZD2QKgwe27lh01c9NCiaSXiqBQHDQ4/HwrZkSmO/vlx6PvF0hPDSLBJtc/+buSv
	08mTpvQFARAM4rADfAl8rpuYv7tNgtbFlUQNQghhdDiwdTe099LHJCG7QH8ftS66OvxZST
	cNFWSLb9ZGpRs9ZvqZLZnEXszq9/Erg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=evfVPnTg;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755049602; a=rsa-sha256;
	cv=none;
	b=J3TKNv38Ep1QeAaJ5ky6VLqiI7gTp+iey5mRspfMaaQ9VXLealKasDOBMNJ/UEOgtE4jIv
	uh3pdti9OC/wd4rxukeXJdEZ/cA78b4OvfmhQzbncYu4YJpa0yZ2ECfDvkZkrziyoxpHJ/
	1YCSrrvS9AT3amlTKhcMqMKCV9+pxEc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755049599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8cimGdearmvYVQCy5FWmG8x9rA0b5/NI1ufddvwaDAw=;
	b=evfVPnTgHBhA7AgQGRCHcwiqrgOLYAmg6DPpQQtrxVPp8a6y8pvPbiBeqN3gS8rxKUoiLV
	TCqpB+VncP3f1jKieCNBCXbddW8YQuRWO/bJfrbxAr50x0SFMoB9a8FCZZSnKP+UM+hKI+
	Jyy1cHE3qlMr1nyxI89fKAUrUQM6YGE=
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
Subject: Re: [PATCH v3 net-next 07/12] net-memcg: Introduce
 mem_cgroup_sk_enabled().
In-Reply-To: <20250812175848.512446-8-kuniyu@google.com> (Kuniyuki Iwashima's
	message of "Tue, 12 Aug 2025 17:58:25 +0000")
References: <20250812175848.512446-1-kuniyu@google.com>
	<20250812175848.512446-8-kuniyu@google.com>
Date: Tue, 12 Aug 2025 18:46:29 -0700
Message-ID: <87y0roq9hm.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: F3C0840005
X-Rspamd-Server: rspam06
X-Stat-Signature: 69cqo7e43ce8hfso9k7sggz1qf5m7qyc
X-HE-Tag: 1755049601-761367
X-HE-Meta: U2FsdGVkX19KfMT3NW+kK7VddHqBTk7aqUewJ57n5N5uayYzLiV4PXhaoMw2gErdPLTtVIodE6tYkAyWdWWrwxbh8FcTjjh8ru3DMdhXnGnZPmlNAQS83cKDpilHxyYPkUyHiCimar5cDx3aeV71pHBGW4sP8nI1r+CI7197NoCa4HX1LdAWVLcdHbbfZ9+3tHms6fGCr8ZvFs77vOAttYnMz5XqrF+A3r2ha7jhSvQQwuNzd+2mU4G4V7xW4MOQBpEJZcpzQ8sXjQAM76nUjQk9c3q0rwXVT6hvYV0758jhkGpEfn17AqRTSOGUf2HYImiVW3QTA/MZTJV2+wROTecD9qXJMSwCMzQLsMmIeaQPcPbK3ljc0kj2HdcFXDYL1tj3aC0PCDH2ZOrfIJwWuTv6scFNBfBbLvrFicXPJiandt0Z+HAqNhLL6WeyfzSp4OxS7+zZeN9Myw3ISxPTWU+QmcNnGgkZ11rm/DDpuA+j+g9DlPSTAFnsQzSxQj82W9cEMFrvVYOBTsjwPFab5rQYy/7L5Q+kUuKElgrO6cbXfHg2VMWK8hEuTcWezN1O4wpf4EcdQxep1qycLYl3isicj3DZRQx6XFdHIgQ4gFuWHl+7AAHjPTAbaHzcE7qFa+f8mXRvwFn7D26a20j0NELrFNM7n1PHg4FTqNHqvrrkEV6bNcP7KsvK62asFZg8QKCm0O5nvLiejWkYBEmMPjVXYv+M6smhDcRU4BzVc6m+QnLjhOsz22ELlLiyZ0SRfhLihrW2ZUZThyVL5LHGiBVX5hOl75360ZV7yyvelgtK8n7kCQlPZy6rksZUPDTDOtY4m8w4KJqicyLZdh8+85tQZQ18Bgx8+EgM4sJW58KrVNglYH8qsyx0M8ZBjLzdSOy8FZ6z+EwH24i8+FRk97HPoAP/i4f7GXKrVmujLoEnj4QRW3rf5Rt6KfIfzU5W90hx+do05Wwav1P16PX
 hfexzhXn
 DxFbUQGQ3PYJcKvRVsjI6q7t6AcHzi7NLfQSIc7PE5/b5NEJ4xPMdiuvlOJNrwbXY8vLHkSqMynYfLrc0wdD8JI8Js80ZVRaBQVfoB/G+qIkJnumSv6fbdwrbrerNoETHhZMokRpdVBOmUvPKxbucoUo3+8MIoc39Dxskn2CIPzW98E3e+8v+lM+kw+FF849R6Dkmdeh5vGYwj11vGXnIT/RRiotnx3rX7OhAiPJoxVUAM5BT+cyN14GlLe/CyDcs7CcrEGJt1ivkSVw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kuniyuki Iwashima <kuniyu@google.com> writes:

> The socket memcg feature is enabled by a static key and
> only works for non-root cgroup.
>
> We check both conditions in many places.
>
> Let's factorise it as a helper function.
>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

