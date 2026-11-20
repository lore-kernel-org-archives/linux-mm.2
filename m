Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A51A160A2600
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OTxFvX90
Received: by kanga.kvack.org (Postfix)
	id CA3AC6B05B6; Fri, 20 Nov 2026 13:38:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C54836B05B7; Fri, 20 Nov 2026 13:38:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B026B05B8; Fri, 20 Nov 2026 13:38:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F7096B05B6
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:38:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20EA6A6FC2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:38:18 +0000 (UTC)
X-FDA: 85456357476.26.804AAD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7EDDE4000B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:38:16 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OTxFvX90;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795199896;
	b=I3tE/VH/COVgB9Jzqug8u3hi8R9Dy/LmyXm54RiJL9bmY3SOLPUod00XzVcAyrhQ8Z+INb
	YkjsT+DbnsvouAHqLRY5MPzYrnj5rg9Gn4NmOBVJYy/4ENB4Btr+pLtFEBti2W5+o3ZM3g
	ePhCj4iPzD7gpeeay6izODG4sqIbBc8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795199896;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OC6u8FUNDb9skPF8bwHcuWsI0fKZNl0GsKhVj1fKpos=;
	b=dYz2jQmDwBv9WDDqLI8Co0eaPA/lBbbPwY2E53D2w3t60sb1sLxNiS2WrZytF28QXOoKjj
	4mexzWhmlNiPuxU/UyQnKnaBjzS8NUSU66vVrqXMXJ2JHuZkyeuLG2Ds5fxRljwJbadyW3
	mvJiuBwco/rmAtYQ5FIRgsYTHPT//so=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OTxFvX90;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0171F6025A;
	Fri, 20 Nov 2026 18:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 090C31F000C6;
	Fri, 20 Nov 2026 18:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795199895;
	bh=OC6u8FUNDb9skPF8bwHcuWsI0fKZNl0GsKhVj1fKpos=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=OTxFvX905xe7bss35dFIdgPICr+TkeCNLnz1tY7PgOthvCCQdB+9sqcIGTu+Wy5pS
	 HkBpOFfpXoD+HucByiQzVE+aBo7AovBjavAg7/msZ85IMZH4QQDGPXMTyN7Cal2912
	 J7ehcIKITYZLl9JqBdbQLVZRf3drctZ5aDNtav2rqs59lHt7Ll2dnpP061wWLfmvVN
	 wiRz6BgGJ1hun+tk9TsveUnuZ7FSIHPlyo3eAYh+Mqa9BpNcTvBh40sAPRCfEZ1qbY
	 7IEGpQFnS+Wes4yuCAB9nixzU2oz03NmMpBaWI9/UBCGxR0iFWCTxakXrAd4zM9E5Z
	 jvK6Gx+8MChjg==
Message-ID: <sashiko-outbox-225854@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 47/60] mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM
 instead of N_MEMORY_COMMON
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
In-Reply-To: <20261120-private_nodes_v6-v1-47-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-47-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:38:11 +0000
X-Rspam-User:
X-Rspamd-Queue-Id: 7EDDE4000B
X-Stat-Signature: gh9ypoikt5wmq6nferzaprcqg5fah9ui
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795199896-186862
X-HE-Meta: U2FsdGVkX19NC7aOXcdlXqadX2z7US/lwnp4gap3inNB/UGQpn4NHWtwsVOL+lU2r/l4LrdQbs4rNiXfb2J91Xl5PYMTX5/dJVXmDHTklc0MJurzorIB3aOWldGMjFD9yiSio1wMiJtL07YI/d2jMgbMDBtrJ0Bzb22v0rUFSruV4LE5q+IwhUOXhveFK9ZIclTcIS2sRGiCY6ICPcIGkBLunLMtlARiFmKHDfWA7gkXhM7ugb150dLb+Jtl7QTYOheztceCZm8x0k5JUNR/wLQNBWhAOUUvTSyvapXCPXdcTrpeAqjZJKDtVtF5GrkVRjYoJOtYJVktud7VtE5h9E9GCHanVzrpkKb1l1JKTCNi2WaGpk2833pYrmQQSyz5HPiDI6Eky8WwmVRIMUM9SoJwKJS0taWtXmjk5Wv++f3YRAjQQfq21QNLdHOUtBnRhEHZKhi4ppZmvz5F6CQYNSs08Tdu2taJ7G/CBBUpThJ0+E5H4sJizWPerJlONBqHr/8SN3KyWKH0nUyMUMuYyyGNhLl4Mbev+rO10lD6+B9ApqnYlXjQ+kyj8kSsvwlovvxYWQNTB6wZ1luNuA1y5QM4KXbp5wrvRk11d4R5dzD2bdLuFnfyyTPEV7Q5N+H71VWgb6aDovrAjmct0TlMJcyY5FGdNzyzWR2Na1A7NIKsLkft8+YwWoEOOr6DLYuPIeL5EhTGLQHLTSpuxhMkJT3Kh91ovSNgRVxBoVY7EtonGXkP2Mqn42W7JSAa/uNjyjz0hrZcE8uWbMqUvAMw8VlA85ylRRGQ3QLvAPoBsB8g0vxJrdyXVHLvduEn1xJRzT/dO4WoFl2tintCimjD99mfec/MMoQpFhd9zb/jDog0BZpIOqjW/IewV1GKbD9oc3ARbUnDepC+hsUdo1lM0+wd+fHRUuQ3C3zAXdq3lhS8Tv5SDmPbUX6I3W0RvkeNLkwrM9pklwhgDHWWZX2
 EnnHj2b7
 K4xvx4PPEnm/twpI8YpktILY5Pw7G8dm9/9duDF9YPGfTvGLIboh0++S7vjeZY7LtE5qNHvs/38byNP/q9glA4b7EbJRs2wjmlR7jAVChiGPf5dLTHOrVgfsXZB4DEs1ihc0aKJUsMs8sdIIeUFmyt+Stnxmp8Zlw1LCZX60DOX9zrk0mAYD1DzNvlnZdhrQlF0UU3W2/FnlIYj04KRtGEwwLQK2ALcM/uSGRa7fvUiaCLU0BxOm3x0YWQ6e0kNSuYxNYCqpuM64vaGblh6dnu9b2EmammbLS8/AMohbMJi5YPFeLdzWPks+6ajMuYxsHJVDc9q7N02yKmVxmRyqTji7tWMbvd+tvn7pOiZOd8SRKYgWshl7gKhp158rv37rbDKG+TTtfDuR6zUQN/RGq8Vr0u91sAuOXSu92FDNTtUVaBvB8CGAOJw0rIKWSdvwp1WKtRQ81DC5kiw/+dW8ZZRuuQEpkT+Azy19v+YYCZ6yn0MXetJ5i7J4bbaexjwI4NCQuwC9NxDuBg6/hDHb4t4B7uOeWhr7sKu85w2vyM2pGWeZFQOj3ckPuHGhiv4OG/coPiUdQ3h+EL3GUg7UlJ42RrD+8kqqk5U3ZF5gsBT0k/96V4puMRCcZsTxJn7IkB6i1doi6tJeA4nrOqhwgTr88sCbH36nb6Twav6KPRjX5athngcHpOxhk+VY5ctPGw4O1jcV9Gltjpwx7yEeL/ke1MuPJyiV8za1Nm7X9ZJYIsTsIi5mcAQG9G5JDc1V5cmXjOchyVoj0CFcitk8NkkB67FkRHloS/0ZxMFMm5FKc6EGT/OiBi8a6SSrfU4QO6xUpV9Hwqo2G+TPZH4RpDu9Y7Ca3kBPIU/ilGtJxn7KJeHFS7Cc5ZuvLcAPuLEa0c6vQCTWRFkXL3lTZq0eQ56hKU4PAfS7gvRNi78nNXhjGAVEB/pQNPex1KydnPOmkzluaj27G7udfQwcozc1BCzIfcQ==
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
- [High] mm/vmscan: lru_gen_age_node() triggers global OOM kill from
  private kswapd
--

commit 5d53d0a1dd37bac1ef5e22f989ac592e04dac809
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/vmscan: restrict reclaim to N_MEMORY_RECLAIM instead of N_MEMORY_COMMON

This commit updates kswapd startup, zone watermark setup, MGLRU debugfs
iteration, and proactive reclaim to check N_MEMORY_RECLAIM instead of
N_MEMORY_COMMON so private nodes that opt into reclaim are served by
reclaim and kswapd.

[ ... ]

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3e934135e8052..03d0919d11bee 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c

[ ... ]

> @@ -7907,7 +7907,7 @@ static int __init kswapd_init(void)
>  {
>  	int nid;
> =20
> -	for_each_node_state(nid, N_MEMORY_COMMON)
> +	for_each_node_state(nid, N_MEMORY_RECLAIM)
>   		kswapd_run(nid);
>  	register_sysctl_init("vm", vmscan_sysctl_table);
>  	return 0;

[Severity: High]
Can starting kswapd on a private N_MEMORY_RECLAIM node trigger a global
OOM kill when MGLRU min_ttl_ms is set?

When kswapd runs balance_pgdat() -> kswapd_age_node() ->
lru_gen_age_node() and every generation on the private node is younger
than lru_gen_min_ttl (or all lruvecs on the node are too small or below
memory.min), lru_gen_age_node() invokes out_of_memory() with an
unconstrained oom_control:

mm/vmscan.c:lru_gen_age_node() {
	...
	if (!reclaimable && mutex_trylock(&oom_lock)) {
		struct oom_control oc =3D {
			.gfp_mask =3D sc->gfp_mask,
		};

		out_of_memory(&oc);

		mutex_unlock(&oom_lock);
	}
}

Because oc.zonelist and oc.nodemask are NULL, out_of_memory() selects the
highest-scoring process across the entire system, even if that process
only uses common memory and holds no pages on the private node.  Should
the out_of_memory() block in lru_gen_age_node() be restricted to
N_MEMORY_COMMON nodes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D47

