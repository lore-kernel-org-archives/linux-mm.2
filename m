Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E9E3D73EAA
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 01:48:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9936B0005; Thu, 29 Jan 2026 20:48:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367976B0089; Thu, 29 Jan 2026 20:48:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294186B008A; Thu, 29 Jan 2026 20:48:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 194336B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 20:48:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BDDAD5897C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:48:11 +0000 (UTC)
X-FDA: 84386944782.26.527C20A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6356DC000C
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 01:48:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HX91BYHK;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769737690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQ77gamuGnsA4t0Fh7OKsUnl08uszJJqAJk/+LqoPCo=;
	b=MFU8JC2woD7bLZ1h+0O/wtsPNe0T3aeRzaYEl2oEEJu14Fu0QdecV2b4PKmrUjwqSFeG/3
	Z4qMfcFQLhD6p2n0qk2o8CBuqDucX6qbmkeL/RNpqRJcsVFSKe8eyyCs31WIqHyFTH6UKd
	BbLyFIeXC0KMCLV/3HNoVp7h3ADL0WQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HX91BYHK;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769737690; a=rsa-sha256;
	cv=none;
	b=baOGGWcoPkjuOd+kkIDcdw3TvlekSJMDCAot6oLFlKewLEXj6p95W8RZisM/Wd++CxITXN
	clpcVwa25cBDu2GoaoLgEfY7T3nbvELpnKwwNE5IpJjX30RLAO6unkFMB809Ml90mIJCnw
	JSYLa3+PfdOt8hfBryRiFuARsiDUs0k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FB936001A;
	Fri, 30 Jan 2026 01:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E24C6C4CEF7;
	Fri, 30 Jan 2026 01:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769737689;
	bh=Qp2XJsJSzR2HivcPBisgAW6pcIdQNbhAEoYuN3tXdWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HX91BYHKqza58LPQh+8Noaz73VeKmnqk7ZH8OWntuzqueow/LiO8XZ2iInOfpOKsu
	 OHtGiYJzEWcLEFTAwLe8bLhETHiRjT3R2R+TqrcBChFR1sFNbnAQeIMJL5QG0cKbWW
	 RoA2gxzsGQbw9ILCTNjK/pl1izyLQ4anOi9CHhvMpUd6lvl7QQVPFOBtgr8YFkmBUx
	 BYHC/n/6bozMuRjn3+vGTXY7XTlojHGQj1+ENJf8l5V96LjWvqlJHJyeulptACeDMu
	 juhneVGupDYOQIG8owouYTQHKquiKdItqHRimW02gbjceL+X/dlOwSNKH21s7ivKri
	 z2Uuq/yNjSgDA==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH v2 0/3] mm/damon: Introduce node_target_mem_bp Quota Goal Metric
Date: Thu, 29 Jan 2026 17:48:06 -0800
Message-ID: <20260130014807.51302-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260129215814.1618-1-ravis.opensrc@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q3jdt845xfrfe3yh3bpw5cfppejcg1p5
X-Rspamd-Queue-Id: 6356DC000C
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769737690-852383
X-HE-Meta: U2FsdGVkX1/rrHzSH9eBW4wjZKkVoAhELIP0YE6uNWOoputKcRcymBz6J6eoGoVqocfWCgoTcAsmQi4mNkgMfbz9Vj926g+0tdGW2adu+zjRFoHYx6TzQNwki7WJ0CC5NNK2ZHmQBBwrRAowwLzlGemyyE+bzu7xBpkDjRKtXuFSsJaEU9XT9wuB5bJPVlQOxldD4tQQeokETbyE6UVjR5xsG2GNP97ifZKdlqVgzMPDQRkKH6Lp6ix0I55pfD8X6oOGtLgYvczCNYFZo01xEl/oUQyj/WWhuYuEQ6GYLrSy2b+RDnHgDNpXW/8QcI4yXA4ooaWtdB9LDQvkkiAEaNLX/RlFFDAgCt3G/nqqM36YEU5Shg8NplJDT+Lr13p7ivjkQA/VPkbqRR2kbX2Jpr2ciM+rVBa8AkpxMHvrRezS4/fkHEq38W7OfqR13wps+0bxFsZuzs2+ri1AYUPgC1R00cqlLXn5WlD9uR3dMhg5ditXEER7lHSD63WZw62KtrPNa+/lssf9Nvz49GoqbzJ+Za6WHJKJInMzm45uiw6Ke1m96VzzumNvhTgM6mzN4GEdbCn/BAC8nE73rTsLwDzyXqJjsuELIUL73AMxWFBJVsF0uI78qhwmoeJs7miL37h29S1OKcFapJ3/yfLG7hU3SGH5k1o9KcfoGpdQz4vLElZ+giLeFGFfLJq22G8fUVEFRaSkPnTgI7vx3xlaFeQGBq77CSdZxU1XHGxT4xEA7MQFSMBVpqOU1YKxZ0RnOgaWVEByaN9a8xXqVy9vPctE/m3VOVzWHdxiai/A4INzv3XKN6jEMNrEC04WcwxUbIgndeDLCA/hWHH+n0hxsDdOB7tCWdaeO4ArPbN1E5UEDcs2vUAJAHpG2c3N7uvR4ll/JTGLdSYwkYc8HZF6F32A0gAC7jraywTOotdfWCLOC8bkKTu6/aTJyl8MvwslrmoMBwMsPY5PB6Y20gM
 AMftETW/
 u9+xEVA73/i8esD20LIEmvpHbJ06YyJueg3DaJG/bp3BwZIQ19S0220GjCDk7M+No9N+9uKflnt5yDMw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 29 Jan 2026 13:58:11 -0800 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> This series introduces a new DAMON quota goal metric, `node_target_mem_bp`,
> designed for controlling memory migration in heterogeneous memory systems
> (e.g., DRAM and CXL memory tiering).
> 
> v1: https://lore.kernel.org/linux-mm/20260123045733.6954-1-ravis.opensrc@gmail.com/T/#u
> 
[...]
> Two-Context Setup for Hot Page Distribution
> ===========================================
> 
> For distributing hot pages between two NUMA nodes (e.g., DRAM node 0 and
> CXL node 1), two DAMON contexts work together:
> 
>     Context 0: monitors node 0, migrate_hot -> node 1
>       goal: node_target_mem_bp, nid=0, target=6000
>       "Migrate hot pages out when node 0 exceeds 60% hot"
> 
>     Context 1: monitors node 1, migrate_hot -> node 0
>       goal: node_target_mem_bp, nid=1, target=4000
>       "Migrate hot pages out when node 1 exceeds 40% hot"
> 
> Each context migrates excess hot pages to the other node. The system
> converges when both nodes reach their target hot memory ratios.

Thank you for adding this example use case!  This is very helpful for
understanding how people can use this feature, and if there is a wrong
assumption.

I think the use case idea is nice and making sense to me.  Nonetheless, I find
a DAMON's devil in the detail.

DAMOS quota autotuning assumes applying the given scheme action more
aggressively (increasing quota) will help increasing the quota goal metric.  In
other words, it believes the aggressiveness (tuned quota size) and the metric
value are proportional.  Hence, for the first context, DAMON will migrate hot
pages of node 0 to node 1, when the hot pages in node 0 is less than 60%, and
start gradually decreasing and eventually stop the migration after hot memory
portion on node 0 reaches and exceeds 60%.  A human readable interpretation of
it would be, "Migrate hot pages out when node 0 not exceeds 60% hot", which
makes no sense for your use case.

To make it work as you described, you may implement another metric representing
the ratio of scheme-uneligible memory on the given node.  Say,
'node_ineligible_mem_bp'?  To borrow your above nice notation, it could be
calculated as below:

    (node_capacity - scheme_eligible_bytes_on_node) / node_capacity

Using this, your above use case could implemented like below:

    Context 0: monitors node 0, migrate_hot -> node 1
      goal: node_ineligible_mem_bp, nid=0, target=4000

    Context 1: monitors node 1, migrate_hot -> node 0
      goal: node_ineligible_mem_bp, nid=1, target=6000

And I'm not very sure if that is really what you want.  For example, if node 0
has 30% hot memory and node 1 has 20% hot memory, no migration will happen.

I think you might want node 0 to have more hot memory, but no more than 60% of
the node.  DAMON-based auto-tuned memory tiering [1], for example, use this
kind of approach.  If that's what you want, you could use node_target_mem_bp
together, like below.

    Context 0: monitors node 0, migrate_hot -> node 1
      goal: node_ineligible_mem_bp, nid=0, target=4000

    Context 1: monitors node 1, migrate_hot -> node 0
      goal: node_target_mem_bp, nid=0, target=6000

I'm not still very confident if I understand what you want, because you
mentioned dynamic weighted interleaving was the major motivation of this
project.  In the case, you might want only hot memory be distributed across
NUMA nodes in a specific ratio.  In the case, you may want the denominator be
"scheme-eligible memory of the system" instead of "node capacity".  To borrow
your notation again,

    scheme_eligible_bytes_on_node / scheme_eligible_bytes_on_system

Let's call this just node_target_mem_bp2.  Then, if you want node 0 and 1 to
have 60% and 40% of hot memory, you could setup DAMOS as below:

    Context 0: monitors node 0, migrate_hot -> node 1
      goal: node_target_mem_bp2, nid=1, target=4000

    Context 1: monitors node 1, migrate_hot -> node 0
      goal: node_target_mem_bp2, nid=0, target=6000

[...]
> Status
> ======
> 
> These patches have been compile-tested but have NOT been tested on actual
> hardware.

It will be very helpful!

> Feedback on the design and approach is appreciated.

So you might need to change the definition and name of the metric, and/or add
new metrics.  But the basic theory of the requirements, the design and the
implementation approach of this patch series looks good to me!

> 
> References
> ==========
> 
> [1] mm/damon/vaddr: Allow interleaving in migrate_{hot,cold} actions
>     https://lore.kernel.org/linux-mm/20250709005952.17776-1-bijan311@gmail.com/

[1] https://github.com/damonitor/damo/blob/next/scripts/mem_tier.sh


Thanks,
SJ

[...]

