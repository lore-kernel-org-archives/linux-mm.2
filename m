Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8EF9C5B568
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 22:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FFFE6B0005; Fri, 20 Feb 2026 17:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C806B0089; Fri, 20 Feb 2026 17:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C3696B008A; Fri, 20 Feb 2026 17:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7EA56B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 17:19:05 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68BC88B340
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:19:05 +0000 (UTC)
X-FDA: 84466251450.26.30E4020
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97C2EC0012
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 22:19:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fNrlUOzZ;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771625943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XfObkIhOT0Ua1/RMBtrT9Uid8uwfbK9pIchG0yozPAo=;
	b=QJl4ysoVoegO5ip93vzIufJGqm1b+wlCdtO6Tdv20ck56mO1bkQDn3KawzMSOvUG5Bn2k9
	TAAhzpo4G4RqY0iri0tKvPn8DP8xkZUT1TYa/3PfQAxjAGTQkHaKVA+M6sh6KEyZM+uY3V
	gcrmaCsVqsokNEDeCYry+SFCGGKVJVc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fNrlUOzZ;
	spf=pass (imf22.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771625943; a=rsa-sha256;
	cv=none;
	b=MR+aVjW1FMXByZW9hJmLC9CkNi6Yx6zlqksoDxXu5vGR69IcGQApzSB/UojcY4HtxVj4ug
	JzcEKJSOr2iXpojUDHexR0KoV88Mc/KG4FqMPbPXnec51aw4ZsGTv2Pz09sRx+fTboLtqi
	W0dmh8v2iS6M7Lbnhl8zmin2X5abe+I=
Date: Fri, 20 Feb 2026 14:18:54 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771625941;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XfObkIhOT0Ua1/RMBtrT9Uid8uwfbK9pIchG0yozPAo=;
	b=fNrlUOzZf8XHzHoiMAE7mfXGUjLekaDwrSQDCDbWFxlptq8b9gy3v41LnM/pUY8SonBkuW
	t+4GkA2socG0NHU/j7lfAandXGjH+RrzghxlmLtMiGyHlLxr3a5SU8j9AX4dS1edcUm6w5
	TJUbfA2LxA6RdiC0qYQiox3K0XH8vC8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, mst@redhat.com, mhocko@suse.com, vbabka@suse.cz, 
	apopple@nvidia.com, akpm@linux-foundation.org, axelrasmussen@google.com, 
	byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com, 
	gourry@gourry.net, jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com, 
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, rppt@kernel.org, muchun.song@linux.dev, 
	zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev, surenb@google.com, 
	virtualization@lists.linux.dev, weixugc@google.com, xuanzhuo@linux.alibaba.com, 
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH v5] mm: move pgscan, pgsteal, pgrefill to node stats
Message-ID: <aZjdZv1eJc4HanML@linux.dev>
References: <20260219235846.161910-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219235846.161910-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 8xbxpc4qktx6z6o59fzdfxbmez1e7zuw
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 97C2EC0012
X-HE-Tag: 1771625943-426196
X-HE-Meta: U2FsdGVkX18acAI2OgLAYjLaXQDDVl9wAMK7A/Tl/gKAtaoTOTDYx0U3L9F4+7iotSc5bL2hn2mmhCl3Iu2sA0khBjFzhhL+b5YeBRm417pczLnrVKOeG1vyJgogVTakIhQCWu2gAzv0OOJCvxwf/8LsJO8P/9/ypexHfrQKxm6k586W3AXSAx4KoIsUHOL3xko1jgvtxjofRg0gCdLXVodFh+ek/f/9fCxEGv1bOQ2BozF+tzHSNqmWOhaIcg3w1W8cQaA10DBndSR7XYb7j0bgXyqoKfYxs0/eNbNvdRIq0vXrjffv7N3fnmgza22Qw7Em8mRG0zSa02eErjGu/8u6YpJH9Nm+diTaJy51Xv+s+ZLWniH2Awp6ISHMATjvHxgmrluzd8t1EPMe23ycA/LeonJDnidhRC777OMkuT38naxLHZwPN/OVQP/C7K9eWhTuXkTsouK/iKcCiJoDQLDo2woXriSst0o2dTJBVuw/lZPZky7eARYHelhGu3vppQJL0oGMrse4/+bbOkSQk5Z9pHtC3YdhjAN5pOcztnv8rtizIctgMmghYJ2Zs6Tr/4pbnm0rfDip5K8+wA6KErmSpv47IzH/2ZLXcLuLvguucKiRz7qpCD9Xu/zp1G56rRaiYwa4XtYg1GgdRjryc4WtWeGf0b3F4mCFUxpzv4XzFBXHhP51w6E+k0DcTkGRhofCRi2F506KqQGWG+1/WT4NyEaW4aghix89dPmfZG2I51qrLSE2e7yYI2l6Kj+dY6czYNwSqiWC4sbYyEP4sDx7TRppp3BOrr8NQ70MwOACbCUKSEKuejwNyrBcKkWPe+y96N+vSnGjxansWXFX6eRyO5onUQWalRWGam1S0zkRWY1t3UxBpfoLQO3+FvPn5Dp7jt0WWXqbK59b7aHgjzp7RsNpXhy5mwzWByL5H7a/KseVJeVb52zTMV2UVyCM5bjr0CYLNqXycJGS6Qs
 SEzf6Ss+
 wv896FsJdp+HlLhhjTNAMaE5I9ihHNoJZlK53HwdsFlYVUX1Gul6TH7Y22u55Z5x3I8g7PAJJ10u3ytiJIl89QftLiTQz2EyWrA1TApzloKDl4HyqylQJ0HkHGnypGrqilgrdCqMqQazxS6MX2oBK6jbJ29U/h0cXJwoB9ut8LeRC/AMUdcLOYVsw51nUmjv1y4RAbsk//KWSS+U6nGG1sWSh9meyGd3C60kThEH6NnbJuU4awiHxuMdkzMIyvZ5CZJA6y2JNbiCKHNHx/1c+rfpTzs4XgJ12Q33E57PW5odnc/hiS93bzAxO+AxEDCR5aMLoZL641w6CM3qM31ofTmLOg0WssqICVwynnvXIt6zX7oIJu++LCrPOs/7vnLlEURW0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 19, 2026 at 03:58:46PM -0800, JP Kobryn (Meta) wrote:
> There are situations where reclaim kicks in on a system with free memory.
> One possible cause is a NUMA imbalance scenario where one or more nodes are
> under pressure. It would help if we could easily identify such nodes.
> 
> Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
> node_stat_item to provide per-node reclaim visibility. With these counters
> as node stats, the values are now displayed in the per-node section of
> /proc/zoneinfo, which allows for quick identification of the affected
> nodes.
> 
> /proc/vmstat continues to report the same counters, aggregated across all
> nodes. But the ordering of these items within the readout changes as they
> move from the vm events section to the node stats section.
> 
> Memcg accounting of these counters is preserved. The relocated counters
> remain visible in memory.stat alongside the existing aggregate pgscan and
> pgsteal counters.
> 
> However, this change affects how the global counters are accumulated.
> Previously, the global event count update was gated on !cgroup_reclaim(),
> excluding memcg-based reclaim from /proc/vmstat. Now that
> mod_lruvec_state() is being used to update the counters, the global
> counters will include all reclaim. This is consistent with how pgdemote
> counters are already tracked.

Yeah this difference always confused me.

> 
> Finally, the virtio_balloon driver is updated to use
> global_node_page_state() to fetch the counters, as they are no longer
> accessible through the vm_events array.
> 
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

