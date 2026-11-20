Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 188D860A2618
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P431dF/g
Received: by kanga.kvack.org (Postfix)
	id 2C2AB6B05C5; Fri, 20 Nov 2026 13:43:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2732C6B05C6; Fri, 20 Nov 2026 13:43:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 162D36B05C7; Fri, 20 Nov 2026 13:43:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DC5686B05C5
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:43:23 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 54AE7120170
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:43:23 +0000 (UTC)
X-FDA: 85456370286.28.2291153
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 934B840005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:43:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P431dF/g";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795200201;
	b=GY85sZ591wmpjzstI+WrGCy8cIgMjmvVxaBwq8wfRxsIgONWYFK7R1EYcTdGRkkRjo6RIb
	8pbmojJ+OxUPgbxI6bqO0Z+4q8ICtHF/3wKbf+mnpNej2HudGk7QBRnKvSh6UvapwPoNuO
	/TV6U3hM/46tRRhXOJPFxhMT1SiE0CM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200201;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ma7DY6hP0RTDlPx1qLll5//wsGyPi+yFvpPbcWX/bJQ=;
	b=RIT6nOrskRye4bJcjZ5OA49RxBfFSBbjvrZ74tJIFb0p7HRETMsHbK6i4A/3bb5TWp432D
	S6LFeo81awILqVxHaqyZwaa4bvfCPg5vY5At7BMXjmUIcKPNRiYBLJS0EdEeeE263zQ6Sg
	gkoVE4IYu/IX5FHs1SDQ3YJzK8ZVQxI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P431dF/g";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CE9B741AB5;
	Fri, 20 Nov 2026 18:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FD61F000CF;
	Fri, 20 Nov 2026 18:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200200;
	bh=Ma7DY6hP0RTDlPx1qLll5//wsGyPi+yFvpPbcWX/bJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P431dF/g9aF994R3Rk3du20W0kJQtM8y0AiqkByuWrIa6nn7OdhDBTMdiM6tSVitM
	 bA7V3TIWopIndYe4TIFVJd6QTLzAD+no6Rs+mkinFe/2BgqQE8ee7X9umqH3wV9qgo
	 P84wxhyEMs9MAqcXWRG0QzbefNnxk3tNoV/iQNNBXjsRUPynOx15S1nD0YaV3GSwT9
	 AkZjL+nOiwX3xNMx43cBWa3+8WluRqVh0AMzhGrLPMK4Y6JF68TdEfhLZNxKQsPlaB
	 sOB+SWJhQTTdtn0CvFKLlInviHGTZ7c+qwWR3NGfsYpsSdThK29l5Ep6cKVDSvyGrr
	 dzgTYMUC8017g==
Message-ID: <sashiko-outbox-225864@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 31/60] cgroup/cpuset: inherit common memory when a
 nodemask is private only
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
In-Reply-To: <20261120-private_nodes_v6-v1-31-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-31-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:43:14 +0000
X-Stat-Signature: qct4rqpt19ahpbzpah5a3ydfpa4zfj8m
X-Rspamd-Queue-Id: 934B840005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795200201-295848
X-HE-Meta: U2FsdGVkX18k4m5E3+ao7s0DOHdKHN3EViZ8zazV5K3RXXVuea4ocpSZWjNT2vmU23SHX6E1CHmqYx768Ukp6zhhoHDa5vMXJ33DZOWuNqG2OFJJ0ci2CaT5yWQ+I1ChBYtBdQvHRyDTq93iQKlu2Wx+TjvVMEmnfHTW7bw39xK4jc/VB4i/1TXIEgfraoFreZJUYM2q7Mld7v4fXt6wg6wCsRWttn/1f8rZ2cI4Ky8Rs9N3s7t7POHSmu+nhnZOLNgPgy8IBqGrbpenpF5Wq/YLBr7a7bRkcVGlC9w0jKz3Dwdqo01ivvxKh2SUDCFxkOK1pThhJO4dVZbJyEdxEWzJUWRLUxrpb5SumxH63DlKU6Gzk/9hjAZy3nnXaNBtPp2SGtTa+qerRg5OlwWuNbWXNxk217lQx2ab10OvxOZJvWGWm7e02YoRxzpfJxYCvEvt+QjKJqAKoperFpTohl8ByJ5i+GfS3SqmUET/Dtev77nUercfdi5z5awzwhf/4e7XpRvP2y8/KqemNCX3jXNlVQaYA9lIvf9dYlT2w4eIxZvYv79I/9KJhpt+g7lZQX1tVPmSyLvCma0eR+hKxUVt6G3eQ/7hxncEYC8ReV6D9+2S+RY5k3kqsqnDVLds6yHDYMI1Ar8ig77Xft9vBQO7AEyH8T/ekykD9gad8iZj05z68B04AV2JY25s0qrQzkdn+D+ZKhdowJv5e90PIkDeQX3brDnUA9BSwjwUv9Yc8e6buuUlyuflNd1NUT4CJW4NvNd634uSPI68Fjf9VNnshBcBoz6KKdtWlRySpBQrZvmo4LpuowEHtmWcyz2bnwyDaXzfvLOlBG5pejfvV2PAWFn4thd9oRPm97kPqVjGRJ3YwmObNQ0uu89J1thbuk7YO+vGeKSnMXdSqHPZe0iw3Xe4LJoFuPULrvNJ2WcZCmrNkxbw3HPrd8y/JjRCuBnpNzDh5ROcZA+970V
 fdVJAOrV
 x4bMWtBblM7D0+QXXeUl9B7ciq5ofgVa0s8z+cjrbm/v0pjBpyD2nIi4GreQMK3Kr1wXEs6s61QOshkx9N15K5nR/VkiHzT5F46XmdnYmIDG8LLVVDOXj0HnvOdbzJM1RyxBA1k+3jojd/RhNHmM6uz03IBNjQinzTLn/N6m7j6CW5rxFjz6CwtL1B4rjY8Wcs9S924Xs30nWr7wBEE6Nthe8Sze5wBAlrfh4PVs3VXZim8udI/ZoFxjGOyKdBK1hkTXJeRPNGJRYzyFg5nlYoi/YhjeS5nrno8ASj1eEmYJ8w8SR556Rz5qjl/q0DmIa/zGzlNgqhdSVjZL517YAI0eVS82qcs23jZCEJgCha8sHLb4C78QwEzR9sJIHOAOEpYFePZZ6OTMD0iOmvZbfnN8PalUQ8M/Z/5L5mQ/gQjmOAVWC89hKDAL9L8NHZnbcPkDRvG4wOv1x8/+ciEwA4D5gSQa31wLfdDThq1v+bptfonm0tAoV86FQnlfrWxCdTNWSsGeULmtmcLNZ3OvthM8g6m/B5LziQdwMrPCiOP4xTugFHTGodbQkR8wl1fZjD4R8Abv7CAflbYqFf1lu2b1L7JzpmhLJSOxtJk50eg5fCZxkT2diDY0pmNzJsND6ybp5muqJ/7Knj9+U6lni58P5e9e0MsBxkDuQDPuHBduYsb5mnBiyaMLctCXyCYLPfnPrUaorj2BgR95vw5VBmY7Zl8TBc+Bd4mawNmpBq6/Yby5N60CqfR1geKah2g/rpj7F/xZ+0hSShj+fPSAoVKfmM2mwePcVvJ5Pv6xZvIFqjNbIGxTOx0yiaAf1nZwpKJvEf0dJIqUg+tdyakbvfrSjuaprYVytbZt/3MJjVUikuXs0KueKoLqIEXUAF2JS7gWlGA1Gq5/C1Fp234Z9NrNTd6us1iDv0Yh+1sjKg1bbbCM=
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
- [Medium] cgroup/cpuset: private nodes in mwork->from skew
  do_migrate_pages() remap
--

commit a812b8d4e921d8df891074bca9a3aa4014ffe723
Author: Gregory Price (Meta) <gourry@gourry.net>

cgroup/cpuset: inherit common memory when a nodemask is private only

This commit updates cpuset nodemask calculation and validation so that a
cpuset.mems mask containing only private memory nodes inherits common
memory nodes from its parent in v2 or is rejected in v1, and excludes
private memory nodes from automatic page migration destinations.

> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index db32d330cfbc2..6802ca13c46b7 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c

[ ... ]

> @@ -2667,6 +2687,8 @@ static void cpuset_migrate_mm_workfn(struct work_st=
ruct *work)
>  	struct cpuset_migrate_mm_work *mwork =3D
>  		container_of(work, struct cpuset_migrate_mm_work, work);
> =20
> +	/* Private nodes are never migration destinations. */
> +	nodes_andnot(mwork->to, mwork->to, node_states[N_MEMORY_PRIVATE]);
>  	/* on a wq worker, no need to worry about %current's mems_allowed */
>  	do_migrate_pages(mwork->mm, &mwork->from, &mwork->to, MPOL_MF_MOVE_ALL);
>  	mmput(mwork->mm);

[Severity: Medium]
Does stripping N_MEMORY_PRIVATE only from mwork->to while leaving private
nodes in mwork->from skew the node remapping in do_migrate_pages()?

mm/mempolicy.c:do_migrate_pages() {
    ...
			if ((nodes_weight(*from) !=3D nodes_weight(*to)) &&
						(node_isset(s, *to)))
				continue;

			d =3D node_remap(s, *from, *to);
    ...
}

Both mwork->from (from cs->old_mems_allowed) and mwork->to come from
guarantee_online_mems(), which includes all N_MEMORY nodes.  For example,
with common nodes C0 and C1 and private node P2, if effective_mems changes
from {C1, P2} to {C0, C1, P2} (or {C0, C1}), mwork->from is {C1, P2} and
mwork->to becomes {C0, C1}.  Because both masks have weight 2,
do_migrate_pages() does not skip C1 even though it is still set in
mwork->to, and node_remap() maps ordinal 0 of mwork->from (C1) to ordinal
0 of mwork->to (C0), migrating pages off C1 onto C0 even though C1
remained allowed.

Also, because cpuset_migrate_mm() checks nodes_equal(*from, *to) before
private nodes are stripped, adding or removing only a private node (e.g.
{C0} -> {C0, P2}) still queues migration work and runs
do_migrate_pages() -> lru_cache_disable() when the common node masks are
unchanged.  Later in this series, commit "mm: restrict explicit migration
to N_MEMORY_MEMPOLICY" strips retained private nodes (mwork->to &
node_states[N_MEMORY_PRIVATE]) from mwork->from, but private nodes present
only in mwork->from remain set and still skew nodes_weight(*from) and
node_remap() when common nodes change at the same time.  Filtering
N_MEMORY_PRIVATE from both *from and *to in cpuset_migrate_mm() before the
nodes_equal() check would avoid both issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D31

