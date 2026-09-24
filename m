Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF5BC9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F786B008C; Thu, 24 Sep 2026 16:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF5F6B0092; Thu, 24 Sep 2026 16:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE6F6B0093; Thu, 24 Sep 2026 16:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 495126B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:28:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BFC031A03D3
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:28:13 +0000 (UTC)
X-FDA: 85249792866.17.22AFE31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38C7010000C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:28:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cq9hMZrf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790281692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=avFjG5EZmFqrwm1p4+gM+ZFckK2JwdC+scZyps23rJs=;
	b=RuqomD9XX1F1CnQdjMQmEz7J4O/olXuQ/BIBjRMRICc3N860KoHQvn00V4bOhqk1P+nOeG
	AVe+p4Hecq0x7an6kDWwsJ/JaCq1p8hnXEDM4j4E+Asb1ZkwispnoNu9gIss9+koCTeTiX
	AzbxH5DF2Km4dBoRblFZNcaTgOixZEU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Cq9hMZrf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790281692;
	b=IM5b/eR0VXj7/1cslVV6QzvrM0OkPH7hmdvPdbCO7puA9dO0ba2HgMpnogM+vASvzNOa6+
	z8ycZAYxUHyZANI3HzBnw+SESxxEuRsSpcIAcf0gsQxqRNbv1nNE012v1jWJmigvBWl8lA
	7DS834SXrcPnCHTr3ggmo5Mj1aoim0M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61B18402D2;
	Thu, 24 Sep 2026 20:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DD91F000FF;
	Thu, 24 Sep 2026 20:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790281691;
	bh=avFjG5EZmFqrwm1p4+gM+ZFckK2JwdC+scZyps23rJs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Cq9hMZrf00s1b6AqZjdi0M+xphvplpO9MfOok1IlGnSwLbZV9ayIds8xD6DUZyNhK
	 ihG3/PzW1VIcrv2SrmJGjylEQZGb5RT8Bn9ZG/E2YWntUfWR1x48dpWb6WKNhcwm78
	 Mt5krRorJPuciXv7L7H9pOUwm/5VqLS37cMpgcD43pK2jNIp4lNqXKpPLK70jy6RSw
	 J5YcktwTTPtFPkjnZrORVx2wzI/krFj7O5JKL/pCzE+5nOaTuBF6jZAO2A8/HkZq4s
	 2mlpsLV3yZqlU05yjHOS68T+DHUwV143/0ez2Sgb7ddfEgajnPjCfBBBsoXYyXv4zf
	 jyF/qq3tPWPJw==
Date: Thu, 24 Sep 2026 10:28:10 -1000
Message-ID: <befc0a9b9998db0292c9998c639a3a9f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Peter Zijlstra <peterz@infradead.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ingo Molnar <mingo@redhat.com>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>,
 Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>,
 Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 David Dai <david.dai@linux.dev>,
 JP Kobryn <jp.kobryn@linux.dev>,
 Frederic Weisbecker <frederic@kernel.org>,
 Aaron Lu <ziqianlu@bytedance.com>,
 Daniel Jordan <daniel.m.jordan@oracle.com>,
 Hao Lee <haolee.swjtu@gmail.com>,
 kernel-team@meta.com,
 cgroups@vger.kernel.org,
 bpf@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/7] cgroup: charge kernel work to the cgroup it
 is done for
In-Reply-To: <20260924184714.912181-1-shakeel.butt@linux.dev>
References: <20260924184714.912181-1-shakeel.butt@linux.dev>
X-Stat-Signature: 5s4kemruuk5rh343yqo3fbtya9bm4wd4
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 38C7010000C
X-HE-Tag: 1790281692-710646
X-HE-Meta: U2FsdGVkX1+SPLlIxBKOuAU6iNz8r0l8hcUuhdzjcQJA5ll65KKwdb7jxhvqZoR0iYh1Fm8zy1dLMQCxa6d4MW+GdKaH4ByfOIL2Nux7TTIA5llyqkpI2cD0yGGO0Ka9l7buL1Bbk6Y5ig6BZxcU6iu6TU9BDX6o4ddsAjlcfRKoRaavQBzOpPWHQDaqa+kxGVndIbI4XmRTOmiUI3Viu0JeHayJ9QKAJArZIjtWExXigWVK8GMtKj3Vi5IRE9n+cMp5Qug9xsPv8YiFKQPWjiyBv30C3iHy7T1lIqk++ti7WBMnLEwrsTssS1glnDOctKZ8bJ8UarPyUpMgepGt0EXL54VUyU5AtlH+1I7aJbJTT0QOcThXPLJ8KnHc9cVY4c0wVKHeI5fFmTDLP9TuA652DVY3XL1uT7wFnEiU1Bh5rcngTPO+BhWKbVA17DbLPnOzqcT/KM/kB1IdVq4AUp4RUKlw77G5bJ1Ivp3MCtBXaxLq8jLW2lH9zHdLrmsz6W3qGMegXX/39ZsF1/HoqkfozPuMuYlezCwRUM1uO0kABYLX8aFKNPuh7vF017qpTUSE+kvC6owHyHtb4hdMqDkjf922tjGU+ddssSAl8mfAx0h6NJ1CRLH2l74CpoEWzDHW7eGJAXdj+IrC18/FnrLZh5lKl63H2UjTktLAL/1VnWz1xrisJsQlPhZ+4z+cJQ3ERpS0wK83v3h9/5hyuaxGbG4g9D3lRpBtbCNTmfz37ZlnZBtULOsdgrGCUsPXn96k5ldakof8vmgnJb2q1Yud4SHpnOLPk8nRY485ZphncScNV16J9dO0J2B5s8MspitCF3m25E/i7q1qr5Z4cZ1oSTLTKSIb8KJL4bW4SUuaXwj1nX4jICSe8AlGHYIKTBu7KCAjfQuXMxgqBhBslvFs0TbhumgQ9DIkqhN0dTv2PY6hTa5/OzgtEzOk1z95VTgoe4HRtWiZloK157u
 D0Zt0YXn
 /mRaVvngMmnvs+0TX8cR8EoV7svo1HPPuCNxvoxYMkK3giObjMKSzC0Q5M/skHdbhOiRjqeEu23dyz11L8LP7OUMgEQlpUQheXTvz2bVtjPdvipM4FGNNnBGLJViTYm9Zs5ycNvxdcIZjKNKr0VQOy2GmbeDzi665XkR780ENqRIycogjNLTXFItExMXzkONYa7Si93/2uiQeAInk1w7GUd8J14zDcVxF93ZvfdJkXJjGPQYBDWVWVhBeqOnKTYOGNy+R8bWqw1Q8pwjxJts4YOUsZQZsRQAS/rSI9KR3W4uRoic5gGGRegI8wVDz9/DQB/rybDT+bsMc6jysPEoiSNsmJjCV4pDIVEEl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, Shakeel.

On Thu, Sep 24, 2026 at 11:47:04AM -0700, Shakeel Butt wrote:
> This series lets a kernel thread say which cgroup it is working for.
> That cgroup then sees the CPU time in its cpu.stat and the stalls in
> its memory.pressure, and the CPU time comes out of its cpu.max quota.
> The first user is the memcg reclaim that runs from high_work.

This doesn't translate to net rx, which is another major source of
displaced CPU usage. Switching membership on each packet isn't going to
work there. Attribution can't happen that way. We'd much rather count
per-cgroup received packets and prorate the CPU consumption. If at all
possible, I think it'd be better to adopt an approach which can cover
both use cases.

>  - The debt is capped at one period's quota, so one long piece of
>    work cannot starve the cgroup for long. Time over the cap still
>    shows up in cpu.stat. Writing cpu.max or cpu.max.burst clears the
>    debt.

I don't like the debt capping. Having debt doesn't have to mean that
the cgroup doesn't get any bandwidth at all. The cgroup just needs to
be slowed down enough that the generation of new work is throttled and
the whole thing doesn't go out of control. IO control already does
this: when IO debt is accumulated, userspace is heavily throttled, but
not completely stalled, until the whole cgroup's consumption comes
under control. I don't see why the debts would need to be forgiven
unconditionally. The cgroup can keep paying them while running at a
minimal rate to avoid triggering stall failures, and if the situation
doesn't resolve quickly, that will most likely trigger pressure based
kills in any reasonable setup anyway.

Thanks.

--
tejun

