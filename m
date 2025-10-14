Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE004CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B2E38E010B; Tue, 14 Oct 2025 08:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063AE8E000D; Tue, 14 Oct 2025 08:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E948B8E010B; Tue, 14 Oct 2025 08:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D23558E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:56:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C9581A08D0
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:56:12 +0000 (UTC)
X-FDA: 83996717784.21.09A12F0
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id A87DB100009
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:56:10 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z0uuohsq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760446571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d80O38LxInO3RE5E1ZtL0vaLg4kbXe5845oQ64nU2Mk=;
	b=FvPgsRW0L2O6+LMd9Io0spX8IPo+EuzaQkzDSoqRZwEUJs/mlA9w9VlUY7NM+ZAFoysTaP
	SDjJoo/A5SllM1ei/oz/SYdpCnzlqh0q6OovYwriqpZRvj1Ogij96DWbYING/8DGjZlGPW
	k01Fxgj/pXZU6OwuIYOB5siw1KJoyEA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z0uuohsq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760446571; a=rsa-sha256;
	cv=none;
	b=HoJvzAEgqQS/RxTdm8H1RIuoZx6FR5drMr9/IjfA59YVHvvi7vHkZZgPqfZn2vUw0G+hz4
	RS3Y2ljKe7WropsZih1uuDjcP+Bs6zdxDqde+k+SBg6dI79yc/y5L5hXUUfNKEp19fiNVB
	rZ5OOLSIHzjYtEGiZZdvqoPHAWFoGqY=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760446568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d80O38LxInO3RE5E1ZtL0vaLg4kbXe5845oQ64nU2Mk=;
	b=Z0uuohsqURAnC3fKaPtMPA0vpiJv2cHrLOxynTW3IZoeUJyY+B+AodkQaQnfoTUgyr+N7u
	2ixWgc8HImPK1lufV2uAGEHawfoiL9fEZnhqclg1HxQZzdarnXIMJaIgqv5eWRPxjk9KtE
	vpbNivyB2EgkuZ9ENyUF223yRwONiFE=
Date: Tue, 14 Oct 2025 12:56:06 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <a6cd4eb712f3b9f8898e9a2e511b397e8dc397fc@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v1] mm/vmscan: Add retry logic for cgroups with
 memory.low in kswapd
To: "Michal Hocko" <mhocko@suse.com>
Cc: linux-mm@kvack.org, "Andrew Morton" <akpm@linux-foundation.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie"
 <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "David Hildenbrand" <david@redhat.com>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, "Shakeel Butt" <shakeel.butt@linux.dev>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 linux-kernel@vger.kernel.org
In-Reply-To: <aO4Y35l12Cav-xr4@tiehlicka>
References: <20251014081850.65379-1-jiayuan.chen@linux.dev>
 <aO4Y35l12Cav-xr4@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: A87DB100009
X-Rspamd-Server: rspam03
X-Stat-Signature: deuzdqtuyh36treqp4p34qbf16qp3u4t
X-HE-Tag: 1760446570-578829
X-HE-Meta: U2FsdGVkX18rQCCjCJydik5SYMvdnPlQ7KqcK0XPP9UTWy71hwOIju6cPguyTILg/vlf8rRpac/uJHOdlUPjvr6PD4rHKzFTIc/TUXxV1so1ESiGlcDW+Y8S85sp8V29BaGX4hXoSZBm5Z0TmKfZKaPQUXQLYndT3mqPb6F2u+tc1XCPH5vPauDd6PgeNoaMaaTK1vqVPmZjLQC3Q+MbMzWHeD0SEHGqqGxe+NCo/WPD/hdCrLCji1TONNkqm15NoWEimBEiKNsu3Zou6bq5zrCH2KeIP5VWm+fqNxtgltkZS6XL2LVFecq7Fkw5JbK5v3sTMkfggojlQPBuWP4F2RFhKngmGoptJlCbifthr4xjefsZH+As+XUjHLNKY5UTCwkHe4Gt1rxmDCxm7Cyz45H8I2kmK3QIAKD5MngsakqcKiH9SQ3D4P3Dfxy00z7cFQSeZRnv0VQXVvXqnl+0tL/S7VXn/pgCBotCG3kNcYcpbl0XPyWPYdhnr+s9g3AMr7TcxqJOGj56zZOyb/7ouTRbnEEGHUoVnJ/AS85nOnBhNWoo85JyVgBAWbqAWll1AWQFQpiWxzE0nU8ztdPnpofNI5GHyKGbpzr49Xr37KZKXJPLbeajHsfolWTNeDz8u11HB2LGTTG6C1ejbA6W2Bq5WkG5jmc9TwlxvJ1+7xj6C7HRVW453LfQBOreNBLPTN60/bXeHtlV7iEMK/T6Y7mG3tQ28xho6teTvKnaCNn4/Wdb1+cxI4zc3F61apSXDEfvpGFEZNXjQHpxIq/4rpiX0SleoXnZqJFxU6YjvsrqXhZSTSsDZld8OfCNBbDP+MH6hyexFvNW3At2wiMF5DlI5d+5IaC5yLseogkHPc0R5n/ZQJpm/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

October 14, 2025 at 17:33, "Michal Hocko" <mhocko@suse.com mailto:mhocko@=
suse.com?to=3D%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > wrote:


>=20
>=20On Tue 14-10-25 16:18:49, Jiayuan Chen wrote:
>=20
>=20>=20
>=20> We can set memory.low for cgroups as a soft protection limit. When =
the
> >  kernel cannot reclaim any pages from other cgroups, it retries recla=
im
> >  while ignoring the memory.low protection of the skipped cgroups.
> >=20=20
>=20>  Currently, this retry logic only works in direct reclaim path, but=
 is
> >  missing in the kswapd asynchronous reclaim. Typically, a cgroup may
> >  contain some cold pages that could be reclaimed even when memory.low=
 is
> >  set.
> >=20=20
>=20>  This change adds retry logic to kswapd: if the first reclaim attem=
pt fails
> >  to reclaim any pages and some cgroups were skipped due to memory.low
> >  protection, kswapd will perform a second reclaim pass ignoring memor=
y.low
> >  restrictions.
> >=20=20
>=20>  This ensures more consistent reclaim behavior between direct recla=
im and
> >  kswapd. By allowing kswapd to reclaim more proactively from protecte=
d
> >  cgroups under global memory pressure, this optimization can help red=
uce
> >  the occurrence of direct reclaim, which is more disruptive to applic=
ation
> >  performance.
> >=20
>=20Could you describe the problem you are trying to address in more deta=
ils
> please? Because your patch is significantly changing the behavior of th=
e
> low limit. I would even go as far as say it breaks its expecations
> because low limit should provide a certain level of protection and
> your patch would allow kswapd to reclaim from those cgroups much sooner
> now. If this is really needed then we need much more detailed
> justification and also evaluation how that influences existing users.
>=20


Thanks=20Michal, let me explain the issue I encountered:

1. When kswapd is triggered and there's no reclaimable memory (sc.nr_recl=
aimed =3D=3D 0),
this causes kswapd_failures counter to continuously accumulate until it r=
eaches
MAX_RECLAIM_RETRIES. This makes the kswapd thread stop running until a di=
rect memory
reclaim is triggered.

2. We observed a phenomenon where kswapd is triggered by watermark_boost =
rather
than by actual memory watermarks being insufficient. For boost-triggered
reclamation, the maximum priority can only be DEF_PRIORITY - 2, making me=
mory
reclamation more difficult compared to when priority is 1.

3. When we find that kswapd has no reclaimable memory, I think we could t=
ry to
reclaim some memory from pods protected by memory.low, similar to how dir=
ect memory
reclaim also has logic to reclaim memory protected by memory.low.

