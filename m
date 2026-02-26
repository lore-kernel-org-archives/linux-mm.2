Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1C48FD45F1
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 00:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB24C6B0089; Wed, 25 Feb 2026 19:25:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05AB6B008A; Wed, 25 Feb 2026 19:25:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80D4D6B008C; Wed, 25 Feb 2026 19:25:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70CFA6B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:25:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EF591A0292
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:25:45 +0000 (UTC)
X-FDA: 84484714650.10.59AD347
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf01.hostedemail.com (Postfix) with ESMTP id CA69F40004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 00:25:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lhjlr5lN;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772065543; a=rsa-sha256;
	cv=none;
	b=XJEsgfO13nkM7GXLs4G6A8M05r8uxPxNywGM1mALZXpP78Tm5Hr6c4v6bMISNroFX6BL4e
	1Ris05fo+Jklpo96qWPpIeUNqNYd33xtLw20fnAFciWpfelPsg+xNoWxDOuThbFfKZFswO
	jPIf1WnFLxdIVCjua33zp2AOxBiB1ZM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lhjlr5lN;
	spf=pass (imf01.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772065543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmXVL4P1e5YTwQCoJlcBCe7K7mA9E+OOkZZvyk9qLts=;
	b=lIcyDRiKqIWPbD2hlisH9DdYGWH/O7gsL6GTLPmApK8IvqzaXwN1mv9f3PKXxvUU4IozGa
	qU2iIJ3Npn1cvH2lWlGm6/ttWU5J5Z00ErAx2GdpceUFyCoRxaB/TpOhjhnqq4iy/NWA+A
	q5eHIWFLtT5RhgE7woRK9mZ/s0BtYI0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772065540;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JmXVL4P1e5YTwQCoJlcBCe7K7mA9E+OOkZZvyk9qLts=;
	b=Lhjlr5lNIb1WKzputRiZytKzU9MeQHWSk4q1xw1k5qiL896YfGek2Sdzhqho2coh5zYVwK
	RnxLJhH32L0wMqK9OxLzr06DaYUQX0wC8LuLdxStMCyRXI/R/9diYjyztOSbe7Vtfz0jBa
	IaqPerrY9fRNnappxWNh4jYDE7ocEoM=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Dave Chinner
 <david@fromorbit.com>,  Qi Zheng <zhengqi.arch@bytedance.com>,  Muchun
 Song <muchun.song@linux.dev>,  Jan Kara <jack@suse.cz>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Do not allocate shrinker info with
 cgroup.memory=nokmem
In-Reply-To: <20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com>
	("Michal =?utf-8?Q?Koutn=C3=BD=22's?= message of "Wed, 25 Feb 2026 19:38:44
 +0100")
References: <20260225-cgroup-ml-nokmem-shrinker-v1-1-d703899bdda4@suse.com>
Date: Thu, 26 Feb 2026 00:25:17 +0000
Message-ID: <7ia4ikbknyfm.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CA69F40004
X-Stat-Signature: koeezc3hx8da4qdcoqpthmycxru9sy4m
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772065541-901332
X-HE-Meta: U2FsdGVkX19vmCkNdwwnT0wewJ2eJ2wOZqT0Hjz6IQvqZorTE9SKaJm4McxbMMzDAKVVD7POwVp7v13ZBospFEw6lk0t3laRYUpO0ow5x7D6YoStgaiRULkKcTvqpJlE/O/KfWkAqZSjsVLvnSkyQHQdWuJ6M0AxRtbvTzSDvnXvexGHsvHyPfZVj1acMuqimj4Zu77UV5xixr7onRVLqu0RZkf7zYIyXkzwB4/Z685qJR8CeD3BsQJyFBNOUhDK+lpd8y7wTJ2uIXcRyX0SlTdWJzKsD88JLdab+GBAD/Hn3VIlsqFn5GBd52gmM4ClRWOi3ZlsBVjIIhGuhuy4SXWfv9JTBMQErt3AclPY/Fe/dy85FYaWvOHx/HvaGlUKN5edyqOz82Lm5I4wT8QJoEhgjclqpoTwSNTK87K2fAKCi8LB8loM4WheLWqGNCLmK3pZM1wYcDw/BDLQp5uopN6nMWWb4g46H8EaOEWRF1XpZ4sxPVJ/y0hbB6koEJEbARPLepgtvQVciXAsmpMEHshisxSioycovbFLxvUAhGvADZ8mvyUqfIOnTVldEQEOZF3s8dnkXkzbsoGMRfA3eodEDc8ikz0o/MZD9WzTId92zNG2xPrbCPAmvpoNiOTMhsX2a+8iuBc4RgZSiFhMPrQ6NMVHuDZxLyxP9Zwf56xau5znH5wWvl2/P5fEiDHZgoq0Tf9pGj2FxGn0Tc/sxVOe2tJij42tp9VTspsuTSqnFd3KmjEFP3RBLokPncIMtOgqYHL8KQoQ5lslTrxWrZyAT+T4eSw/KHjIJGQuiAElgnd6o7LAtwFGPKIxh72VRmOnaccliVZX9lcAKHfWInQQ4zmisYDz5iODj0w6xEqAObcwHGdo3etec+OBQAIlGzOtOeA+3YcnMdCgadaFAvfPmPxzyzDkZg4b7hAtqkJ5WV27kLnn6PmuPLyK8sVF/TU84tsY2jyrsaKqaCX
 irqQwae+
 W17mtxb+SMUK8/tjQZNp3lHeyVtqffpiEOtAmHvEGRONat+z2zBwSfpGZ65w7v8t2ahL6qn8amif6+AOyrqXmFxsZueS3bk6HI/3qiL34DHuy5ywvYhzExUplxxqUBSMngMeR8P8GONgfOSbf1zlvQu9547J4tZjPwULaIqdc/7RB1UVrhboQb2IZXDPkvNwz4+nO4S0DoxMzLqHAGAglAt7isGYrLbEGSM3F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Michal Koutn=C3=BD <mkoutny@suse.com> writes:

> There'd be no work for memcg-aware shrinkers when kernel memory is not
> accounted per cgroup, so we can skip allocating per memcg shrinker data.
> This saves some memory, avoids holding shrinker_mutex with O(nr_memcgs)
> and saves work in shrink_slab_memcg().
>
> Then there are SHRINKER_NONSLAB shrinkers which handle non-kernel memory
> so nokmem should not disable their per-memcg behavior. Such shrinkers
> (e.g.  deferred_split_shrinker) still need access to per-memcg data (see
> also commit 0a432dcbeb32e ("mm: shrinker: make shrinker not depend on
> memcg kmem")).
>
> The savings with this patch come on container hosts that create many
> superblocks (each with own shrinker) but tracking and processing
> per-memcg data is pointless with nokmem (shrink_slab_memcg() is
> partially guarded with !memcg_kmem_online already).
>
> The patch uses "boottime" predicate mem_cgroup_kmem_disabled() (not
> memcg_kmem_online()) to avoid mistakenly un-MEMCG_AWARE-ing shrinkers
> registered before first non-root memcg is mkdir'd.
>
> Signed-off-by: Michal Koutn=C3=BD <mkoutny@suse.com>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

