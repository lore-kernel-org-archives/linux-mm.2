Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D2EDCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 18:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17AB6B0005; Tue, 26 May 2026 14:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EEB76B0088; Tue, 26 May 2026 14:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9047C6B008A; Tue, 26 May 2026 14:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7D4046B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 14:55:23 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2104F12044E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:55:23 +0000 (UTC)
X-FDA: 84810474126.22.07069AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2C14A180008
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:55:20 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHnIvnhR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779821721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXgROzGmAJcCsVgExpV6y9lWb3jWbK1tedmMBM0VEbA=;
	b=5lqKMC5D67LuKrqI+LkBZ/pNLbtZjdznE9aIRcw6xVQ/C4fsYX9YLQWF/Il2ThGHf+joA6
	XwCMdu1lE9dVSNiVSJ20R+HRnN+KL9gGAvv9eAW47J+UABVU95piu/Yh3JbcGNLrerC5Jk
	1C7iJnFlBPEKptkfAKI1+e0Jpw6dKwI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RHnIvnhR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779821721; a=rsa-sha256;
	cv=none;
	b=vcLrAHzVBSZO/NNksT738sKx+bjc2uxkYd6jMkWy4bkbDwus8Zweab2mFtPGT9JdDy2+Dq
	+vcGfwQs2FrucO8ubtEf7ZyvuG8VWPOVpXXxDfty8X7MMVJWzWFK745FCurhsp17HqN2Qm
	6I4NbyN1dtel4D07PuM78oMSSqiFM6o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 18A7944590
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0AF91F00ADE
	for <linux-mm@kvack.org>; Tue, 26 May 2026 18:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779821720;
	bh=HXgROzGmAJcCsVgExpV6y9lWb3jWbK1tedmMBM0VEbA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RHnIvnhRM1W6mbTga0AJ2W18mdbHTBIUsfWktHzxkzabHOXx6HhV3bom4Z3JB+sfq
	 H7IoxkMH4PyD2oyO4F8xcw+M1RMdjljhyvX3yT4BrZTbTfAba90x7bur4hZh2Mlsx1
	 ILNMnysvZgiLl+k6WSrNFe72sc7sDMNzKkXdQpWNVbshRLcWbLb+4HrATTQvpOtyFN
	 XdBfoWD6Sr/SSKcDmCzWCw4LYhvPRwbBteT+f97ymjR9TTIsxfdSAByk3K4m7GI2TY
	 rIZ3niXDNm+9n2Cfoex4Nb4cAWTk7+aekvP+4VE4nC1s3f2hFX55Fo9T4cn00HF4JJ
	 TO+9UOCPKu72A==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-687e7edaafeso7152675a12.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 11:55:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+AqMeVIhOv88aACls/RR+vz4Z1A3jM82A8pDNqXNsX1o3RQ3fzhyKouSMRweqvrCmVuDa/Ve+cTg==@kvack.org
X-Gm-Message-State: AOJu0Ywhc1JhNZpeYxh/aU25pekYQxDRRp7CCOwNoHqeKjKq8vMyMQ3H
	a224tgHzg1ymrrOGsCgpVLtGZxE3ikhDPlCW/fqlXvVBCUk/m6XeqslOBvd157ESUnDrXuRnNLo
	1rAlt5qxZiIQL1ENbaLrenNp5Aq/q3kM=
X-Received: by 2002:a17:907:d01:b0:bd4:f3e5:b0f6 with SMTP id
 a640c23a62f3a-bdd26cd21dbmr1255792266b.28.1779821718891; Tue, 26 May 2026
 11:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260525122242.36127-1-jiahao.kernel@gmail.com>
 <20260525122424.3b2818f06832d9d55da8d69b@linux-foundation.org> <9b2ac88c-a67f-2512-d898-3dadd50ec03e@gmail.com>
In-Reply-To: <9b2ac88c-a67f-2512-d898-3dadd50ec03e@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 26 May 2026 11:55:06 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO1+brQroYufMZ2K=ZH_PBBpzYPsdYm-DT3K2GxoKJs9A@mail.gmail.com>
X-Gm-Features: AVHnY4LLc2VbUgRMQJCSwM_5Avx8xJ-cNYKTtyXz3u-0Ot15a8J2I4eMGnrIBmI
Message-ID: <CAO9r8zO1+brQroYufMZ2K=ZH_PBBpzYPsdYm-DT3K2GxoKJs9A@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] mm/zswap: Implement per-cgroup proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C14A180008
X-Stat-Signature: ahibxf5emxkqsy81sznqetn51w6k8nbk
X-Rspam-User: 
X-HE-Tag: 1779821720-437396
X-HE-Meta: U2FsdGVkX18vzURLleR/mdygTq08EtYGPCjX8YmTD5NnEO67EbMjIrFYIl8pSOE5bSxUvZukniqUSjQhGgxIdkwbECSi7tl9r82czBz7QzMTfqRRTG15I8OJQpW4n9zLnLdlNyfvQoFp4cf9SWFa0ntoFYsITeQ6b4Xz5gPAolAoFtFeZzQI0fXd+As4+0Of3GfUtWitHLIliRaMw6DXa0U5PSIrx8oWhfHTPq3hdy1Rz/rn07wdMUwbKMzMU2PX6LPkiRhdlNWEFzqNDP/WkUgVnJbXgTLgPvSta9P3j+lcEJ7A5WtCy2vAg2Adq+itpbpPfC73/SIyxKEnaYsNDI8L/KK+CQeAdThcdnByai/eosenH9MQj9eVLLm4BK2s2FNN6+b+fDMHRmDwoeR4MQsgWU8UpBxKzyWOv1BiFu5a3yDAao/eSpcU1Z9E4ZXIBg7Cxor5GeKrmjKg07tGbqpEExBAuTSlNmfEh+t2/PnXlZUqC0i1YBEKKiErDSt/4aTDmPzHkYtvn+/r3G46KnL9X0UC/zvAX31A5Zmyyv7RIL9Xwq3BiojTYx4JM8uq2DQpuWxJrzmaCdYCGKPk9uGLr6bFApsP1mPX67WxeHsa/ptuCdKzj2u9j8I4wW7Y32Lf21Y9tWIJ3fI/jHIqb63NrG+8TtpUzYoDwp+VZIe4tltzMTUTEh78/mlipkd9oNj0yUWbpevYD8zODszuDzze18p8qXiEdwc5Kst1hrrIC8+bN0e1FdF2sCVw4kKq0TsGyRtV+lY8MB3DyehFj3W2FUcVVJRYlOcZg0BTAbKse5cIrnxAhMjsyhAOcdtzaKb1Vmhb0hN026KRmmRolxqipMTrUc97r8x5RneM9Uj9LBH21IRlajsVKb8AjI60JJIUWZakA+TFX5S4OOy6ymzjVKJGzk2pfGgfoCExAVH0NAd0gxpmWviV/KMdtPnBD8Gj4bCs4rICtrPcmuU
 G6CCvCbn
 bHSMxpwj0MmsapHH4u+JjpcPZsaeSjzTW8xDTZoSHBDkt1eOdPOYL9HJ/tE4owWlPc/JYQ5/QfEXWFdR6bVB6o9Ud/OF7PLxWcED5m+86JbCJ2kl2eKmvsm5h7SO/YI8zUmlaywhiuwdijc+t48moxOq8GJwgmEkw9MZbjnyUdxmuXG8CIkEGdTXdndNhG4ZwaRmlvw8Vfhd5h+igzgT/A1k+iq3lZFjtCb4wUUpk9Zw6qugbnBRyhWytp0Hj0DzXrQRVR2/nUBnx4QxLy4Esnj0rQJrTaqe945vBDsxOF8E+bsf3eTCNKeDCzp/Sbt3nYirCHo7EA7vp0nyObhH1sXlypTILuFPsqRaLhTs5rlDd8RmxH7Z+WO0piaun0a2AhOHTXIeq7JByRxOtt9QjYS/0gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 4:56=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/5/26 03:24, Andrew Morton wrote:
> > On Mon, 25 May 2026 20:22:38 +0800 Hao Jia <jiahao.kernel@gmail.com> wr=
ote:
> >
> >> Zswap currently writes back pages to backing swap reactively, triggere=
d
> >> either by the shrinker or by the pool reaching its size limit. Althoug=
h
> >> proactive memory reclaim can automatically write back a portion of zsw=
ap
> >> pages via the shrinker, it cannot explicitly control the amount of
> >> writeback for a specific memory cgroup. Moreover, proactive memory rec=
laim
> >> may not always be triggered during a steady state.
> >>
> >> In certain scenarios, it is desirable to trigger writeback in advance =
to
> >> free up memory. For example, users may want to prepare for an upcoming
> >> memory-intensive workload by flushing cold memory to the backing stora=
ge
> >> when the system is relatively idle.
> >>
> >> This patch series introduces a "zswap_writeback_only" key to memory.re=
claim
> >> cgroup interface, allowing users to proactively write back cold compre=
ssed
> >> pages from zswap to the backing swap device. When specified, this key
> >> bypasses standard memory reclaim and exclusively performs proactive zs=
wap
> >> writeback up to the requested budget. If omitted, the default reclaim
> >> behavior remains unchanged.
> >
> > Thanks.  AI review found a few things to complain about, one of them
> > described as "preexisting".
> >
>
> Thanks Andrew.  I have replied to the AI's review comments in a separate
> email and posted v3.
> https://lore.kernel.org/all/20260526114601.67041-1-jiahao.kernel@gmail.co=
m

Generally speaking, please give time for reviewers to take a look
before sending a new version. Less than a day is usually too fast
(unless you're iterating super fast with the reviewers). Review
feedback does not have to be addressed immediately, usually wait for a
bit to collect as much feedback as possible before spinning a new
version.

I will take a look at v3 soon, thank you.

