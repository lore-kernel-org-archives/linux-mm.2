Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8466060A2600
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QEcfJdaB
Received: by kanga.kvack.org (Postfix)
	id 6CE466B05B3; Fri, 20 Nov 2026 13:33:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67F986B05B4; Fri, 20 Nov 2026 13:33:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 570516B05B5; Fri, 20 Nov 2026 13:33:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 197D66B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:33:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 09F5C1C1F8E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:33:24 +0000 (UTC)
X-FDA: 85456345128.02.F99A1A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 66B4C4000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:33:22 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEcfJdaB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795199602;
	b=QNLwixy2Ehx3ZRh5uRhLlRXda5dtShhNkIOa6PBl8fOCnpxMcCi59h+wNOlwBC7N5LXPUw
	moGYtgKfwhcqbuS5BoCc/V0yA4rpfNvCS7e2gI2UZezs9QFwPpjDDSJwgX7ql6yfbtJAws
	VeYu3L7/WtlIe2WgZpgw+Gf0jUA9N8k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795199602;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/QjdGr8du1+0/up5L/FeJ50rChwbRYbU49k9UAYdf/g=;
	b=3K75iAlKVnWCUgxI6XkfYcFN94CU9GeeRvhJhksFwqT/zHGW6RlSdbO2E9hVzSvsjloEst
	ZgAtHF0lkUS16i5Go7UZRoM4MXASSOkrwN1cI0k0fgquXJI5g/YF7DvdIIzKZ1Uysawi/W
	dzc3hIZeu39tymwOpxX+6CQ/1/j02EA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QEcfJdaB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 96650618F1;
	Fri, 20 Nov 2026 18:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46D911F000D2;
	Fri, 20 Nov 2026 18:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199601;
	bh=/QjdGr8du1+0/up5L/FeJ50rChwbRYbU49k9UAYdf/g=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QEcfJdaBXR3W+/1J/7PCuYdI5Ic5+u6GSCUqnnD/ezVDlOQmmQZuhmOsWA1zd/1+y
	 a/VC65utOlVHSk0Ii0AJPHU0b22J+KTgAZDPez8Fq0scTn3qKwWehZwpYuezFS8zDu
	 H8JAdT0jJ9LgLe9KjPQkVKjeAxfKMDbn9yXUFXGLFAWa8zVs86wjv76fFu4gkUrMno
	 l042nFUH9mvNFE8IboO7yL85h2zNRzSZSmNdU+QiO4r+ue3XHFppLHS5gIOwN73Pa9
	 riUpfyMMq5b05pVKNTlrrgUm061QQsYcgZV3GN2LZnnspHqyivw/54SqNZdAZXQ6GH
	 Sx87cnBZQPuvQ==
Message-ID: <sashiko-outbox-225840@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 30/60] mm/memory_hotplug: keep private memory out of the
 auto-movable ratio
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?R3JlZ29yeSBQcmljZSAoTWV0YSk=?= <gourry@gourry.net>, "Yury
 Norov" <yury.norov@gmail.com>, "Rasmus Villemoes" <linux@rasmusvillemoes.dk>, "David
 Hildenbrand" <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Mike Rapoport" <rppt@kernel.org>, "Michal
 Hocko" <mhocko@suse.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Johannes Weiner" <hannes@cmpxchg.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Zi
 Yan" <ziy@nvidia.com>, "Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <skhan@linuxfoundation.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, "Danilo Krummrich" <dakr@kernel.org>, "Johan
 Hovold" <johan@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>, "Matthew
 Brost" <matthew.brost@intel.com>, "Byungchul Park" <byungchul@sk.com>, "Alistair
 Popple" <apopple@nvidia.com>, "SJ Park" <sj@kernel.org>, "Ingo Molnar" <mingo@redhat.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Dietmar Eggemann" <dietmar.eggemann@arm.com>, "Steven
 Rostedt" <rostedt@goodmis.org>, "Ben Segall" <bsegall@google.com>, "Mel
 Gorman" <mgorman@suse.de>, "Valentin Schneider" <vschneid@redhat.com>, "K
 Prateek Nayak" <kprateek.nayak@amd.com>, "Kees Cook" <kees@kernel.org>, "Kairui
 Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, "Axel Rasmussen" <axelrasmussen@google.com>, "Yuanchu
 Xie" <yuanchu@google.com>, "Wei Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Michal Hocko" <mhocko@kernel.org>, "David
 Rientjes" <rientjes@google.com>, "Pavel Machek" <pavel@kernel.org>, "Len
 Brown" <lenb@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Lance Yang" <lance.yang@linux.dev>, "Usama
 Arif" <usama.arif@linux.dev>, "Kiryl Shutsemau" <kas@kernel.org>, "Xu Xin" <xu.xin@linux.dev>, "Chengming
 Zhou" <chengming.zhou@linux.dev>, "Lorenzo Stoakes" <ljs@kernel.org>, "Pedro
 Falcato" <pfalcato@suse.de>, "Jann Horn" <jannh@google.com>, "Chris Li" <chrisl@kernel.org>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Nhat Pham" <nphamcs@gmail.com>, "Youngjun
 Park" <youngjun.park@lge.com>, =?utf-8?b?TWF0dGhldyBXaWxjb3ggKE9yYWNs?=
 =?utf-8?b?ZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Waiman
 Long" <longman@redhat.com>, "Ridong Chen" <ridong.chen@linux.dev>, "Tejun
 Heo" <tj@kernel.org>, =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Dan
 Williams" <djbw@kernel.org>, "Vishal Verma" <vishal.l.verma@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, "Alison Schofield" <alison.schofield@intel.com>, "Shuah
 Khan" <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, damon@lists.linux.dev, nvdimm@lists.linux.dev
In-Reply-To: <20261120-private_nodes_v6-v1-30-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-30-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:33:15 +0000
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 66B4C4000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 4auyursddij4uobx7j4ib5wksap3ok1i
X-HE-Tag: 1795199602-509062
X-HE-Meta: U2FsdGVkX19eRNvR7cVLSZfR3zznvfnTfufXCMIICSWBupsdw3qiZUdxCJ2OWVC8ztxZYcAfJlKtmOf7QJkllTmUR7n+GMg4FTTMFlQ54V4aM4zgvAT/ZD1Q7cHbOcFzd6C4ZHL2COODcoCjGkci7e3Q8HdYu535N67b3pNI5A6y2+AMiLaAutm6XfEQeoM5UbYvVbCDPNdJ+MAqiJhNjEbLUCD/uE3wsRmyz6PnPFPz+SFy/FR8hyVH1hXB11ZXnwm9xOUkXYUybASbW/XcsPi6BQDkKNpx6asm3AXSEr80H6eK1KA+TAOKwENuPJZBfRFU6vsHjgQ8yYw0Mp/KglxE5oLPi1mZEKLccmlux4iYwsslWtLeE22v0ShYl9i41crHJqduqWN28dX6bzhdtIx1/wBOMQWfwqcCyTfkCy+MIYfLR4kYUTlAooWOVS+7jwqIBgHnNDd7kBjG5cEx4Qt4CREMjitVtAUTQXKLSaeqV1De3B8ICc53Mt3yAr4qEaSbRnGNNy/AcebMm2eBHZChqh6PaZvpV8rVkJcohcbPErzpB+tzlgPI7Fve5aOAfhQggKor4VZ9GwVAnuEQNOH4ryZjZHuFOs0XiC+pLxXjLBVZTgyYhZr7u45noewv301BK5K6i8mBDNoWzEeEWSL23MpG7yh7ykIZcesBsvmlim4P6GXogom69e4sjWzNqaSa0XRfNKGVDrlo5foZQKrWDm2gNTZr1y3Myo5HnURcPvPiYzrCBSTRfBaUR5XBQZPSDDkKIYJ8nLSrkkEsL35Uiugl8fAH8AmNS36vcm3E/2FcuWA8dCICm44pIXpzekIsI2fkey7VE+YG9xbAJfPc30gC6cMebrquH9ZWVOkM9etUF8vySc/NxADaJpC0VLfd+B7QuYtKtElFOS3gP4EYyquXDpoj0Hn6MLetHB+FGO0u4AoB6XRRsPtBa17q7qbBUjL5c7D8fiSzG4M
 g8Fx324u
 l+edP2lH8PoWqg8tLtHIvixV1UxnmDvuuee/u+l17KwDRS9sO28eitUd53F1CC5gXDNJr8h9QTjGFWDJTl82Q2aJNQUVp4oqxwwRnvoVfGpq4SKjsEZCrLvzX8R/Jio9bo/cZO+ho9kcNcDk4iHtK5gOjmnRjS0UkOfjvLWNpgDXuRuQN/0Qw43ZoOI5d/NOUcP75TY3oLR3zYoSKMXnURAYiNU2/7vj6eziKahLL1wRxgjk1B5Y628T2euJMlkIYwwGvDkpBtfv/y1CubwR1qaSp3c9P95mF0D063DoTOiFm81l6Ws9MknDmS7Rp6aPgzNQAp4sG5fwmWhMgLR0YiCNFrVwfY+iO/LqfyxcLRcLj1Kj1PyDLqTnBfysQ/KTNP8I9bPcQL6SK3rksPEoXALI8tdzzcpUwJ+KTjs/HTZWYbkQGngL7v+nbS3gV8qUyfxygQDdBG8yDyTo3wC6JDTA6Zts7KGCHL9YU8+VwgnQNebY8aZm9hiJSiDrbgRahGzjtfdkkSAjXhlgJC7EofnUFv3EsUwfRyS2Ww2m+Px/GBHaHiQkt6/qr3ByfoJKhx6IsuWlodeVtAVEVHpxal+9sWsWPSHuHCezccmCqVA+wycbAy4Qe15BiwwhQ7vTACOtO63aRy1KCegpymRWnCaXIRp5asTPJ3oMxpvXs2MY4W7wE2SM06BJn7afObmz9pdznzG+iUit8wEwiCg7AhVgzesl0eDM8awsMaTwXyO+QtJkuD/wKcc1UmwMYGWsX9jvmU9lmDFV8jB6e1TEVerIscTP1zJKbhLZb5YfLTY1ET9zIn12oOPwmjsJhYhHL1bAsqsANhOWs6MmpwmPn9hEMG6DFB+KTBtHF0OhXc/Rivi8HRyPb7DJrVtO+jXj9KzT5dmEg9UsqsWQeBg0kZNnoCfnr0x+vwjupSWh6sEsHMZMbwY6fvlIZNxtAlDCh9tyv2MgeAHda0djCqjJ1AmV5rA==
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
- [Medium] mm/memory_hotplug: broken auto-movable accounting on private
  nodes
--

commit 6d04c084f583deb362f04abc899f0521e026dbfc
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/memory_hotplug: keep private memory out of the auto-movable ratio

This commit skips nodes with N_MEMORY_PRIVATE set in
auto_movable_stats_account_zone() and auto_movable_stats_account_group()
when computing statistics for the auto-movable online policy.

> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index b4d94021d46ef..d7ce60c6815f8 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -782,6 +782,10 @@ struct auto_movable_stats {
>  static void auto_movable_stats_account_zone(struct auto_movable_stats *s=
tats,
>  					    struct zone *zone)
>  {
> +	/* Private memory is outside the movable:kernel balance. */
> +	if (node_state(zone_to_nid(zone), N_MEMORY_PRIVATE))
> +		return;
> +
>  	if (zone_idx(zone) =3D=3D ZONE_MOVABLE) {
>  		stats->movable_pages +=3D zone->present_pages;
>  	} else {
> @@ -808,6 +812,10 @@ static int auto_movable_stats_account_group(struct m=
emory_group *group,
>  	struct auto_movable_group_stats *stats =3D arg;
>  	long pages;
> =20
> +	/* private memory is outside the movable:kernel balance. */
> +	if (node_state(group->nid, N_MEMORY_PRIVATE))
> +		return 0;
> +
>  	/*
>  	 * We don't support modifying the config while the auto-movable online
>  	 * policy is already enabled. Just avoid the division by zero below.

[Severity: Medium]
Does skipping N_MEMORY_PRIVATE here without updating
auto_movable_can_online_movable() and auto_movable_zone_for_pfn() break
auto-movable accounting when onlining memory on private nodes?

In auto_movable_can_online_movable(), walk_dynamic_memory_groups() excludes
the target group being onlined, so auto_movable_stats_account_group() only
runs for other groups.  For the target group itself,
auto_movable_can_online_movable() relies on
auto_movable_stats_account_zone() having counted its present_movable_pages
in stats.movable_pages, and then directly adds group->present_kernel_pages:

mm/memory_hotplug.c:auto_movable_can_online_movable() {
	...
	walk_dynamic_memory_groups(nid, auto_movable_stats_account_group,
				   group, &group_stats);
	if (kernel_early_pages <=3D group_stats.req_kernel_early_pages)
		return false;
	kernel_early_pages -=3D group_stats.req_kernel_early_pages;
	movable_pages -=3D group_stats.movable_pages;

	if (group && group->is_dynamic)
		kernel_early_pages +=3D group->present_kernel_pages;
	...
}

Because auto_movable_stats_account_zone() now skips N_MEMORY_PRIVATE nodes,
a dynamic memory group on a private node still adds its
present_kernel_pages to kernel_early_pages in the NUMA_NO_NODE check while
its present_movable_pages are omitted from movable_pages.

In addition, auto_movable_zone_for_pfn() computes
nr_pages =3D max_pages - online_pages assuming online_pages were already
counted in stats.movable_pages by auto_movable_stats_account_zone(), which
no longer holds once the first block on a private node is onlined and sets
N_MEMORY_PRIVATE.  When auto_movable_numa_aware is disabled, skipping
ZONE_MOVABLE on private nodes also allows unbounded ZONE_MOVABLE memory to
be onlined on private nodes without counting against the movable budget,
whereas when auto_movable_numa_aware is enabled, the per-node
auto_movable_can_online_movable(nid, ...) check sees kernel_early_pages =3D=
=3D 0
and group_stats.req_kernel_early_pages =3D=3D 0 and always returns false.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D30

