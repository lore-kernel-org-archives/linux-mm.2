Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9665AC98315
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 03:04:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB4686B00E9; Sun, 18 Jan 2026 22:04:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8BB76B00EB; Sun, 18 Jan 2026 22:04:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF466B00EC; Sun, 18 Jan 2026 22:04:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C92996B00E9
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 22:04:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E8CA1AEE46
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:04:24 +0000 (UTC)
X-FDA: 84347220048.28.676683D
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 67C9D40006
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 03:04:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rq/ykZcg";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768791862; a=rsa-sha256;
	cv=none;
	b=2GbHdE89PqqHCVifVmv9EfXc9bxnmPN4MCjou3AmmId+xq//OrJnn6vyMX2DYfZwj2c5Mz
	hWe5jvYvQyDyuO7b+XmAJKON9kD0AA7x2x5DeW94tBzHhp6V+bE+WGm0gA6Kk59JklCz5t
	oLpSCFekKaucACbTCcRljT0lNMAlUL8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="rq/ykZcg";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768791862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nD9B2kYFWIUGWewoKq7H29ys6yJUvy9QvdM6wh6FK64=;
	b=e3LaTUoK++iRNlw98G1Rq64EnemIR2/PuqLZKccTcHmUGMqj6UKGvlT0fxXs2b0ldFkQxo
	mkNSnB6xcZJz2ocMDqX+49dfOVla3J0jCbvwNd5eUqGOMB4ht5hiu+a+/b+2U6TctPPFaF
	nutDhQZ1p7/igLxLbBS8DItxynxApaI=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768791860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nD9B2kYFWIUGWewoKq7H29ys6yJUvy9QvdM6wh6FK64=;
	b=rq/ykZcgTNXXpeCZNRhMD97B1NzxYWBX7+pY5JhDMpfhrm7H/C/BL/Rpf6ZhczarhbX+HL
	2ja55dd2CLPC3GtqFevZ2gSfKbMNzj7HNIR0+tMRjGoCEqcjk4lF3Q2hMEO7OB/Tq+zoS+
	0yy1L6URaPr39QXYqBSrhjXA8bRL6TE=
Date: Mon, 19 Jan 2026 03:04:16 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Jiayuan Chen" <jiayuan.chen@linux.dev>
Message-ID: <562a3b0db8bed7a1f13c3e1b8ccc846181226b5b@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 1/2] mm/vmscan: mitigate spurious kswapd_failures
 reset from direct reclaim
To: "Johannes Weiner" <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, shakeel.butt@linux.dev, "Jiayuan Chen"
 <jiayuan.chen@shopee.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Axel Rasmussen"
 <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei Xu"
 <weixugc@google.com>, "Steven Rostedt" <rostedt@goodmis.org>, "Masami
 Hiramatsu" <mhiramat@kernel.org>, "Mathieu Desnoyers"
 <mathieu.desnoyers@efficios.com>, "Brendan Jackman"
 <jackmanb@google.com>, "Zi Yan" <ziy@nvidia.com>, "Qi Zheng"
 <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
In-Reply-To: <aWpukFnKRoeSrcEZ@cmpxchg.org>
References: <20260114074049.229935-1-jiayuan.chen@linux.dev>
 <20260114074049.229935-2-jiayuan.chen@linux.dev>
 <aWpukFnKRoeSrcEZ@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 6wcg66w5tfw133rykbbhtg45cd8eicsa
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 67C9D40006
X-HE-Tag: 1768791862-721953
X-HE-Meta: U2FsdGVkX19z9MHwreJNxIHySi++b12FmEPtvdDefUfllE2GL6GKO6yJfCUY+/YtrcsHz9gEn221Ljdp/IJ18H2YfCeahK18Aty4d1ohM75xgpyT7X6kp7f65hxQq+6tj5GlaEtL0iCCefJJIOnWJx/jYoN1BqshniD/N230YLFiKZQDhoX0N//l/10NrkxEbQIkr1XpqOXU/AklelPlLeKqMcWI6kdhSNIKHVHwhbB8mRngiJaGM3EzGc3MhUDol8RceJ2xZnDagWPXGBXtyGQ/K4UZUbySozUO75kuYUiwQcElDaOSQIL31+pUhGcLcAw52mIGo1GzVnx/ruXeQgBGZX14ebFIXmwA8zJLbfarSWvX8J7ZSl3hFowKi+iYuTN9qP9UNAQbEQIfP2leuo/Vl4GvwOvw/ztQhc6rXaW4cZ2x9G1TwAQlun9+OKNHlmAI01roO6un74BtNOpqfehmJsB7hzOj6UwL7kYltqLVNEaPE4zCuwzg4fLYltiPdzPfbDzfjplwSOcjJ/ohseb8gs6vUFoiagkAdC+ovH8Yb5FYUfJiefQSBfk5viskqpxaF06ocInhopbQ2AUyFeKxdJ1btxwMWtO/BTHHes7sfZQpmVMwfEw64pxII1V/ONEcztvVg9qop+9/075izQXSpJA+WqOu9vpY0tpwq/5jb2uoUfp0NPzYj1CWJKImzXFaSvr6A81Yl4cLOZafo7pzk/Z+gg6ZLKHQpDFVq4qHVvPdKSughTMQEjxUH4kjGwwFzsjTSQtRvSYaPGbfkLSauExIbjPvBkdU8A4C4AQ0LXpa3ojMoxQb3WujD7rbJ5S1dds/QM4eG1D0wDFYZidAd7qFcWcLub5VbkCO88pVNwzp60lCeD4aK/6xZ0QxIBKDp2RdjyjfPV+ZwOZVAQT2a6FlK1EZ46Wlu7mTXTu5xuejqfgnYLROSpxVxkDOyQtYOfxqrgIhJTBwCL4
 gXNAxrpE
 fXukzqyIGETCZndLeZm6HHZ2Yb2sRldWi0S/O1q1AzKKmEGVV+FxJ+VUM8JcoOiNry2zpFDx3ZZc9AAxyG7FiYAMHQ5ESS1xSNaJ8i2jTPt2IBbdacBUKb+jBNWR2p4bcvDGabG40n9PQ4U/nfrEVo8WFjsHe9qyMednf4vx/Syoa6zBQ4ITppbM4FviyfFecKGdmFaucxVaL+/jesmn/EKg0MeUVxtp/2ZiaxZ24xzeZYZGe64X+ukrZktOvRKC0khugGknXGvQmclvZd6TzW6oq3xYIvlr3aaXPJX3vzI4lj9W0+fQE97us0U5wMbxW2v+J+bvQVsxHOElT0Zi+DKjqbiAi+TUgj5sj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026/1/17 01:00, "Johannes Weiner" <hannes@cmpxchg.org mailto:hannes@cmpx=
chg.org?to=3D%22Johannes%20Weiner%22%20%3Channes%40cmpxchg.org%3E > wrote=
:

[...]
> >=20
>=20Great analysis, and I agree with both the fix and adding tracepoints.
>=20
>=20Two minor nits:
>=20
>=20>=20
>=20> @@ -2650,6 +2650,25 @@ static bool can_age_anon_pages(struct lruvec=
 *lruvec,
> >  lruvec_memcg(lruvec));
> >  }
> >=20=20
>=20>  +static void pgdat_reset_kswapd_failures(pg_data_t *pgdat)
> >  +{
> >  + atomic_set(&pgdat->kswapd_failures, 0);
> >  +/*
> >  + * Reset kswapd_failures only when the node is balanced. Without th=
is
> >  + * check, successful direct reclaim (e.g., from cgroup memory.high
> >  + * throttling) can keep resetting kswapd_failures even when the nod=
e
> >  + * cannot be balanced, causing kswapd to run endlessly.
> >  + */
> >  +static bool pgdat_balanced(pg_data_t *pgdat, int order, int highest=
_zoneidx);
> >  +static inline void pgdat_try_reset_kswapd_failures(struct pglist_da=
ta *pgdat,
> >=20
>=20Please remove the inline, the compiler will figure it out.
>=20
>=20>=20
>=20> + struct scan_control *sc)
> >  +{
> >  + if (pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
> >  + pgdat_reset_kswapd_failures(pgdat);
> >  +}
> >=20
>=20As this is kswapd API, please move these down to after wakeup_kswapd(=
).
>=20
>=20I think we can streamline the names a bit. We already use "hopeless"
> for that state in the comments; can you please rename the functions
> kswapd_clear_hopeless() and kswapd_try_clear_hopeless()?
>=20
>=20We should then also replace the open-coded kswapd_failure checks with
> kswapd_test_hopeless(). But I can send a follow-up patch if you don't
> want to, just let me know.
>

Thanks, Johannes and Shakeel. I'll send an updated version with these fix=
es.

