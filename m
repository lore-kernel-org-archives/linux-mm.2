Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E692606A8AD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nHaVsf7l
Received: by kanga.kvack.org (Postfix)
	id 90F9C6B05B3; Thu, 12 Nov 2026 02:17:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BF776B05B4; Thu, 12 Nov 2026 02:17:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1366B05B5; Thu, 12 Nov 2026 02:17:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5188F6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:17:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E11D5804F3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:17:47 +0000 (UTC)
X-FDA: 85425612174.11.8025499
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3F12C100007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:17:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHaVsf7l;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794467866;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rLVRPivqG4bmWwuZP7BfGAbSJH7PtH3nBzp3H5OZJAM=;
	b=wQXaDBC5tz7etOOubGQDi+N/MeD98S5TDqEN0+JgQjcv/dk/ykWpt+ISmBmagaObgjcSmd
	M0fGu6lh4YnffqtbmXh6FNGSpA2YtoV/bPHrMkMWzORXJoyDogsPEi06s3i5leLpYPMfH1
	6Hpc3OIReBYe4pNSgkw0pfPmcM+ItIY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nHaVsf7l;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794467866;
	b=fbRxKeC95veT/SmSpMC3Q1VXtlUPmKaEKsj7MqIwsu+NxRf54mBUY/sxJKcq/cBsVjUh15
	ZKCfVGk72kfj1ZYcElbKiFPU78a3rTLXGvMrxYHyZwREAqpRJvtKZOXPtrZ2uAtwwf2vsU
	dsU9kR+jiUaw35tqJDZ/48oDaPchQ0s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D1D644D1C;
	Thu, 12 Nov 2026 07:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AE91F00A05;
	Thu, 12 Nov 2026 07:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794467865;
	bh=rLVRPivqG4bmWwuZP7BfGAbSJH7PtH3nBzp3H5OZJAM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nHaVsf7lR9qpJjZSEXJABHCzgjGCHLQwJbnTIOGo1cyOK6oVUkxAqw891aO+UaH3v
	 n/NVpN9gQYTNst2qxxeoUEfPPxfnPLgoZdSHg83DDNVglPg92QvvOIFWchnENggaLt
	 kmgNb9kT0upZDRc6HMlM0VgSBEp8bOCpM8LcazXyxzRv6xwcjVH0dYS71jxJYZ0OmK
	 X8/7iqbcG0j84AmkR//vsvUwiINOBXwuq9jf5FTbmTY5773paixuZ9zP5wE7v2ut22
	 RmxKLZag39bmOVHYMggu8KtdzDC+EB24sRZUwMW2h1tQVtqkTxKjz+Awa87se8oZj0
	 7p44MxRbeoBig==
Message-ID: <sashiko-outbox-210584@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] mm/bpf: Always flush memcg stats when explicitly
 requested
Reply-To: sashiko-reviews@lists.linux.dev
To: Runli <mingyu.he@shopee.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, linux-mm@kvack.org
Cc: "Muchun Song" <muchun.song@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Yosry
 Ahmed" <yosry@kernel.org>, littleswimmingwhale@gmail.com, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20261111071434.34547-1-mingyu.he@shopee.com>
References: <20261111071434.34547-1-mingyu.he@shopee.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 07:17:44 +0000
X-Stat-Signature: rwq7fajp5pwkw1wcj7da6o9nfhqzx3a6
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3F12C100007
X-HE-Tag: 1794467866-732207
X-HE-Meta: U2FsdGVkX192/q/sMp3+HvrT2qnai7Sogm9CO9VpEug2D40hz9lFbxJZ4H1ayM8aHzbOHLjtePsi7OWkC0JIkKV+TuEmIHmSMX1QlKqXy5LKRS3lYyZJs9+wKtXpTto/sbhehss40EwE70dKehn37eOq7QEfqG9kCBhcwSk3v1OJjN7m8CeHXzcrtBa1I86nD1oiaed9OJqvf3KuX14Z8Cliy+ogb51QWdvDAwBEwVl+Y482x5p5W1m4V7A9WaTlkwOG1s+jA9BBjt2bNoFYg8Hlcr2zWu40HHyH7RpcDgPaw6aucsv96tZwHREvCduVuZc9B7rpoJ7hMqg7ue3JEC1npvzt+hvgvWdbUN+bLWGULqLdii4R8+QQLGsOMUsEK/isYY16UHp/EW6HcRIuqV87osb87nwbgPXLoRgK4YWhtL8S/J4YeA0OK6HeMLnF0+fo5njuPBkVfAmbd1eLMWQExnjTpRN0+X7AOzjSMVX/bZL/rSTJv3n8tLsdOYEyFgXcwLVmNSnK24n02+eAAPWuX+fjXt3y7DQdyd9TREPzlc246T8KxPR01he6DkhB1E2DjaM1jDGXiF14NhWXIAw7D3nhfawsOb6zs1PfzlDEX9jVkeXS9eWvr9nNi/ZnEdl2QGGgqJabU7DHcRUGsxOteKb/Y2WOaczXZL3PGhYyQ37AeBQiA7dibNzIkHl66DE0L0lXAfDsbI1498N7sN/7OKOE7ECuzua4gqX8jPriS217lT42huEaT6S1a6o80w1tN4ZYyFslpC22b9WlszZ2QT+Gs3EDHAgOhvGDs2h9sqla21qNkJafNc8xaT7kf8JrWyxf15ONobYZPNDCAhftV4uvABs1mo+CX3yhZs8rqv5yuGVabPLKOBIAXrKCsxwglhasyyJL+eiNxXM7XeoR6ZQzzruSg8ZGtAwQEiJ+yV/xjGpmEVkwN7DSlMCFoWLgkTIJvGSeTPPwlvN
 Ime73eoy
 IKMpPZPD5OvQ4iu9ePwLTp6CzhbhexVBaCaiUo4YNbWYbESPAItQd+yatvMUrmzRHeaXEItAGMbbZ20qIdbrvsEcQUEZieOm+Z9P3M+A2N9Ol/hk+KswU5S/fYf9EwPLIE52byISdGqVJKJ+Fb7m7aY505wGwOacdurKEGVBLVXLXrZNQ1HTrO4WYfRE5bzY8AfpMmTD0Dm8hb0bS4WdVeZU8xaKziFWZeJMUVCy8LYToaw5QEDUmWxY0kxplWXo8WRV2bTqgcLwcBotFn4Iw3WH1d4AxplrQ9jawt+P5OhNB/lliaUSBXRRaVgYI+sSyKBO0l7A0rgTUQpLcQ135iUB0B+SOmtoPUlJLSMHJ1MXx7PysQFN0MQKYhu/jnAHWm8aJNhZPYksJuJef+mqs2CY1wW7n3EwcG6xCfey45ALwgUIdheNOJQqJB4wIoGocMhPQS8nyUmcrNTFrp/Sfjtuqc1xmMx9r/uZMJyJFl5lUmOv+p4Okl4Tm+pr9CpfondSUyrVzdIZb0xLMeyDEECjIqwv/pAOFiWWrnqT4BAhqSd04Q87UZCV2beBBpSik+bbU7T0g4YKZBxbN5oiF4N79H1/FuO4m/60MEeQgfHML/WXeMCsTlOmKXXZe/XYRgw3QM+BYIrQiQrc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/bpf: single-word nickname in Author and Signed-off-by
  trailer
--

commit 3c9ed7d86a7651dc5165f429c9bbe20623688c8e
Author: Runli <mingyu.he@shopee.com>

> mm/bpf: Always flush memcg stats when explicitly requested
>
> memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
> the flush threshold. A concurrent flush can leave an ancestor below the
> threshold, so the early exit prevents it from receiving further updates.
>
> Consider root and leaf on a 4-CPU system, with a threshold of 256.
> CPU 0 is flushing another CPU's stats after CPU 1's stats have already
> been flushed. The counts below are shared stats_updates counters:
>
>   CPU 0 (root flush)                CPU 1 (leaf updates)
>   ------------------               --------------------
>   clear leaf->stats_updates
>                                    add 64 to leaf and root
>   clear root->stats_updates
>   finish flush
>                                    leaf =3D 64, root =3D 0
>                                    4 more batches of 64:
>                                      leaf =3D 320, root =3D 256
>                                    next update:
>                                      leaf > threshold
>                                      break; root is not updated
>
> Root remains at the threshold, which is insufficient to trigger a flush,
> while further leaf updates keep taking the early exit. The periodic
> forced flush restores progress, but until then the root's aggregated
> statistics can fall far behind. For example, page cache grows at rate of
> 1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
> the actual usage.
>
> Make bpf_mem_cgroup_flush_stats() bypass the update threshold so BPF
> callers can explicitly flush stale statistics without waiting for the
> periodic flush.
>
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
> Signed-off-by: Runli <mingyu.he@shopee.com>

[Severity: High]
Documentation/process/submitting-patches.rst requires a real full name in
the Author header and Signed-off-by trailer rather than a single-word
nickname or handle.  Based on the email address, should both lines use
Mingyu He <mingyu.he@shopee.com>?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111071434.3454=
7-1-mingyu.he@shopee.com?part=3D1

