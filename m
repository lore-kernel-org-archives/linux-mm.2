Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE0FF60A2614
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mZpKbZWp
Received: by kanga.kvack.org (Postfix)
	id DEA286B05C7; Fri, 20 Nov 2026 13:45:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1376B05C8; Fri, 20 Nov 2026 13:45:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD6B46B05C9; Fri, 20 Nov 2026 13:45:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A30D66B05C7
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:45:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A9794017B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:45:06 +0000 (UTC)
X-FDA: 85456374612.25.F0424FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D59EC000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:45:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZpKbZWp;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795200304;
	b=FI1PVO2w9r6G4Stz2+j3D7YQONfq1YUlEWTOj8AkuT7aUEP+iPFo6nKeloFkPjE5iOfRrC
	pIw7QplKybwoZ8LpB91JsykoH+YsNsv5nRCbHG69JK+Pw31G0SFmSUSUdpmdDNGHgHUns/
	OswlT+hLiiqCyR8Q2ggWIJxLz746aEQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200304;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JkD8OAgj2F6n9ADRagW+iRBXIRn65B4wvrkdyDCF1eY=;
	b=FzW4qVNR7xno8p1GnD0C/7v9FtZIGYtpCJmd79F60YCHPZA/tgEH4De5UkMwHzlKp4EGBo
	nf4OB/6d5MrU/6m2u75EIVkzpTJhaDu21hpLE0w3F/QbtnsBIPRvZ6/IgVmZg88MISCjDe
	B3pc4ORu8QPP1RhigvZpxO+jD+mt+tY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mZpKbZWp;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 935AC4562A;
	Fri, 20 Nov 2026 18:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF691F000C4;
	Fri, 20 Nov 2026 18:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200303;
	bh=JkD8OAgj2F6n9ADRagW+iRBXIRn65B4wvrkdyDCF1eY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mZpKbZWpPyYmKD5mdR1NBPflVu5LCjYaDLXFtvUrDi+FUIbI12jRvq8ILCI+72EkV
	 jTZ9Hg2M52sw422CskDZVdQhDmK1+QvKdw96l+79+BAISPonVrmnDe10S/txpNpWHu
	 YEgNNMSr0dz5zrtg6L7fJy4EtlwXwTP+AmpOtjLPqN+zuVRjDNcJtn84Cce2oHc3UX
	 GYgSivawkmiQSWYEdeZJ8gWnxtKIgJbo52OuTMACpRKWNDyfjv+uhPOcwVkSQvjI77
	 0CzNnzTduX2XANH12L0BAmOfsDq7hIcU4fYsuWtA09ac7o9wuJ4fTJ63pRWkgeaFqv
	 BJM3B5d9wrbUQ==
Message-ID: <sashiko-outbox-225868@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 53/60] mm/mempolicy: add MPOL_F_PRIVATE_NODES for
 private node bindings
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
In-Reply-To: <20261120-private_nodes_v6-v1-53-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-53-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:44:59 +0000
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6D59EC000A
X-Stat-Signature: pynk7en94ong97kuxqfc871yfmfdazjx
X-Rspam-User:
X-HE-Tag: 1795200304-67395
X-HE-Meta: U2FsdGVkX19YN93nW4WU5fxl2mbpadklhj8z3AyCaOhnfHKVWhrtGNV+3jLrW45iUXqBmY4vwJUUXOYK91825O3Pw6NLfnPmSjq6tKymNQObvsYKbT7mXhOqNMEaAHa+76cbNkOtKhqQcYW1oXFSs+q08pJ8a/TQ2us1AXISLIAkWJbF5PW162eDu9zAg9lMorwPgTWQb5qxq58ZD1SqfRz/rhG3/O5zVdHeBJGrZWhAxzs+S+gxAW4RIBAyt26LjJ0Q/Go4Fz4+ZXC+5u5KJawylwHvtfjinRwbPV9P9nzQ2ki+DY3cvULBk+/QCoWXks7qGlMUXlbnkFpY3EdJ/LVj4gA7rG+/pbj5Ffi4lH6eFmGSTU30Fpa0hXTaY1Rd787K03rKlRGnScxqqvf/lWJkzQodJFv1qoRfmt0B5zY4QhT24EJJK7t0W6PALNgGFXpiNwf0isIw7QjDhFahEf5hpX8Yh8NJjDtXCRsNxqshWgcH7J/UGpoJ3cj59zOlk7M6KUVHif+c0mzvZLBl4fPNufGPyun3S1xMeX/DHy14yM6TKSlwt5WduJXm6xuC2gB9eRsMl8iBOxcwp0x8VQDgeKTxaFIPl3M4yVKzTojLa4WwrE3H16U0L4YCXzVJQilugOf7Ft1WROM8SyXKXj65Jd/xawKiiMU72EX8aRLIKPylOG1wmHMIreBL11fcZ46N1P/hrj1b+Trwj+rj6cJPWHdJxyp/Tl5R7KyPV8bPZMXte2paEqUQHaUNUqWWPT0OWZZZ+SK+j15j2fjTQLsarvViutwCn9OygSx19TaDjRBiWyR8oYu82px+ZnDFXoLfxp+3olzFeFFnPaBgGW8WZ6E1YaAHbaLFvmZ7weEbYK8/okrpmdpb2f5MULwaI4ShxwWw6hod5W20vozQjNvd7qLBtNQtWyL2U8gvIVZGczsJWr7csQjYnqpJFLNbK+7P6JsSrfWNDXwWGGW
 IRUO0wTb
 iB4pZ9qizueBTVqLJNxqMyCVFrJikNySt4ZVouACSNnwzkQZJV+4SqoHP3gddBUq7dqiK2jP4xU+k5I1/RohtBdezYp0ElAICuv70edfPiJhUvmjmqyeiktgDYGNSJZxirfesbVXZ8KsEFlhGEiUDVfSXbB/MMxlSFh9VrpSE3fLsbpXU0Wsbr3BOAmGltCxOCVSxi4SH4dziwOQo2BtL4wqh4/GTE3h04Twg4OdAOL4JalVaV1qJdl30hX7cgcU1IgobzUlea+nxY8IQKwalZFij6q56qDZvwmsuIpiWJ3pQn4yVxtz4ULRwz6bjV1lQ5dmWCKbUSMu2YDx74QXi9vjTZqyETehSiMeryIk0qKGBCIctuLbJERKUJdE1GqFN3p57uQlORBHkZSceVoAqJZG4Dm0cNlfcUdkccwKsQmTcTz1NaIYRz/BmT1deJJ9QINcm0LdJqy9fK8VA/4MEqahfG3rRGDn7GD6d7o35jQ8WVxFyjV2E19b9Ju1bXV4m1jeyDLc1G8J9SlMnQZGo/g867pi3Alt+fdZiAKuh3bO3Xnweu2Txg87fxR/DWoTVog3jU1omPBnomJ7xhEan7r7zYx15gext+NcLDCZnbZ2/WXakMN6gbnih1/totvduQuUJsmWM0CVV9ALOPn/gNlsxVno0L0UtPGQMmvN+lJhmvaXxKKWE69yckCIpp3RYuJrA7AnUmJ8ib1//LFmFJ1JxXYMjkguSBIKQYcCAs/CVOU3gVyb5CyvYLPmNT+/Cqp4QXdQvQjEswZ/OBdYyNouuMSTBqOO0tMaJUTZZHi7f+9mr6T18EHt1HEcwWPDJptx6HbY7jpOoMhRTbXMQctcX/epz2bWj8GBgG65SweoWh9fSmL66ZrYjj9BLsx9Ntj+ndAH73Irzq/PTug2LSy3m1tboo3krhI2nHzywxctZ46S2NBcmN/N0UZ7tIutbO6hfLL6bSNNRkJDsvVKd/VcZdg==
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
- [High] mm/mempolicy: incomplete suspension of private bindings in
  alloc_pages_mpol()
--

commit ca3f7c695f126ea25e293faadb9871a86c3c7899
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/mempolicy: add MPOL_F_PRIVATE_NODES for private node bindings

This commit adds the MPOL_F_PRIVATE_NODES mode flag for mbind() to explicit=
ly
bind a VMA with MPOL_BIND to a single private memory node in
N_MEMORY_MEMPOLICY.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 9d2e56017ebe5..cb5419cb7ee84 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
[ ... ]
> @@ -2495,10 +2539,20 @@ static struct page *alloc_pages_preferred_many(gf=
p_t gfp, unsigned int order,
>  static struct page *alloc_pages_mpol(gfp_t gfp, unsigned int order,
>  		struct mempolicy *pol, pgoff_t ilx, int nid)
>  {
> +	unsigned int alloc_flags =3D ALLOC_DEFAULT;
>  	nodemask_t *nodemask;
>  	struct page *page;
> =20
>  	nodemask =3D policy_nodemask(gfp, pol, ilx, &nid);
> +	if (nodemask && (pol->flags & MPOL_F_PRIVATE_NODES)) {
> +		int private_nid =3D first_node(*nodemask);
> +
> +		if (node_state(private_nid, N_MEMORY_MEMPOLICY) &&
> +		    node_state(private_nid, N_MEMORY_PRIVATE)) {
> +			nid =3D private_nid;
> +			alloc_flags =3D ALLOC_ZONELIST_PRIVATE;
> +		}
> +	}
> =20
>  	if (pol->mode =3D=3D MPOL_PREFERRED_MANY)
>  		return alloc_pages_preferred_many(gfp, order, nid, nodemask);
> @@ -2520,24 +2574,26 @@ static struct page *alloc_pages_mpol(gfp_t gfp, u=
nsigned int order,
>  		    pol->mode !=3D MPOL_WEIGHTED_INTERLEAVE &&
>  		    (!nodemask || node_isset(nid, *nodemask))) {
>  			/*
> -			 * First, try to allocate THP only on local node, but
> +			 * First, try to allocate THP only on the selected node, but
>  			 * don't reclaim unnecessarily, just compact.
>  			 */
>  			page =3D __alloc_frozen_pages_noprof(
>  				gfp | __GFP_THISNODE | __GFP_NORETRY, order,
> -				nid, NULL, ALLOC_DEFAULT);
> +				nid, (alloc_flags & ALLOC_ZONELIST_PRIVATE) ?
> +					 nodemask : NULL, alloc_flags);
>  			if (page || !(gfp & __GFP_DIRECT_RECLAIM))
>  				return page;
>  			/*
>  			 * If hugepage allocations are configured to always
>  			 * synchronous compact or the vma has been madvised
>  			 * to prefer hugepage backing, retry allowing remote
> -			 * memory with both reclaim and compact as well.
> +			 * memory with both reclaim and compact as well. A
> +			 * private binding stays on its local zonelist.
>  			 */
>  		}
>  	}
> =20
> -	page =3D __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, ALLOC_D=
EFAULT);
> +	page =3D __alloc_frozen_pages_noprof(gfp, order, nid, nodemask, alloc_f=
lags);

[Severity: High]
Does alloc_pages_mpol() fail to suspend a private binding to common memory
when private_nid becomes ineligible without returning as N_MEMORY_COMMON?

When private_nid is not in both N_MEMORY_MEMPOLICY and N_MEMORY_PRIVATE,
alloc_pages_mpol() leaves nodemask set to &pol->nodes with alloc_flags =3D
ALLOC_DEFAULT instead of clearing nodemask to NULL when
!node_state(private_nid, N_MEMORY_COMMON).

If private_nid is offlined, node_clear_memory_state() clears N_MEMORY_PRIVA=
TE
and N_HIGH_MEMORY, so apply_policy_zone() still accepts ZONE_MOVABLE faults.
When CONFIG_CPUSETS=3Dn (or before cpuset hotplug work updates
current->mems_allowed), policy_nodemask() still returns &pol->nodes. Passing
nodemask =3D &pol->nodes with ALLOC_DEFAULT finds no zones in ZONELIST_FALL=
BACK,
and in __alloc_pages_slowpath() alloc_is_private() returns false because
ALLOC_ZONELIST_PRIVATE is not set and N_MEMORY_PRIVATE was already cleared:

mm/page_alloc.c:alloc_is_private() {
	if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)
		return true;
	return ac->nodemask &&
	       nodes_intersects(*ac->nodemask, node_states[N_MEMORY_PRIVATE]);
}

As a result, relax_private_alloc() does not relax ac->nodemask, the fault
fails without setting current->private_alloc_failed, and handle_mm_fault()
returns VM_FAULT_OOM and invokes the global OOM killer instead of falling
back to common memory. Likewise, if private_nid stays online in
N_MEMORY_PRIVATE without N_MEMORY_MEMPOLICY, leaving nodemask =3D &pol->nod=
es
with ALLOC_DEFAULT misses the fastpath on every fault and forces every
allocation through __alloc_pages_slowpath() and relax_private_alloc().

In addition, if set_mempolicy_home_node() was used to set pol->home_node to
private_nid, policy_nodemask() unconditionally sets *nid =3D pol->home_node
even when the private binding is suspended:

mm/mempolicy.c:policy_nodemask() {
    ...
	case MPOL_BIND:
		if (apply_policy_zone(pol, gfp_zone(current_gfp_context(gfp))) &&
		    cpuset_nodemask_valid_mems_allowed(&pol->nodes))
			nodemask =3D &pol->nodes;
		if (pol->home_node !=3D NUMA_NO_NODE)
			*nid =3D pol->home_node;
		break;
    ...
}

On the PMD THP branch in alloc_pages_mpol(), __alloc_frozen_pages_noprof() =
is
then called with __GFP_THISNODE, nid =3D private_nid, and ALLOC_DEFAULT, wh=
ich
selects private_nid's empty ZONELIST_NOFALLBACK and causes
GFP_TRANSHUGE_LIGHT allocations (!(gfp & __GFP_DIRECT_RECLAIM)) to return
NULL instead of allocating from common memory.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D53

