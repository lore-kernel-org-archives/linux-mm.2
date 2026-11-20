Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB5D60A2611
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JbiqBCMR
Received: by kanga.kvack.org (Postfix)
	id 8BC4E6B05C2; Fri, 20 Nov 2026 13:46:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8943A6B05C8; Fri, 20 Nov 2026 13:46:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AAC66B05C9; Fri, 20 Nov 2026 13:46:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 516D36B05C2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:46:42 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF5511C206C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:46:41 +0000 (UTC)
X-FDA: 85456378602.24.D74C035
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4100E1A0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:46:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JbiqBCMR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795200400;
	b=p1SlR+0VSyQzg7JeovTdH5wtTl75IvuDxGkQPQVp0uu8E7c22gUxoGIXbjy+y9ajv9VKWr
	vuBgR5gsNX3iNkN+osF1nRV+Mh17San86YW39/uPSdMeP8wSlN/+RfKYpfUvNqDHjaBJT4
	a1vikdKNsZQKh+hZNJ5xQn2CObvBE+w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795200400;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ab/tweOrN+MvabFdrOgEaN20+lKttHF+RU7XMxTAZU=;
	b=eS6Zvi1oSmAFx/T4y2cBuSReDQbUp+YOLg9fGrtgpiHSzbgqkWTG4ABOd+xAyT5XFOM9J/
	nQdzjyhTxCgUTc3b4GxenTeO6P1DgiATV2yUwGAdFWxnyjW8Y+r3p3i4SxhQPsns11w9+s
	J86hEM8HLkDdJDaQK1j7jN3DZu8UIyg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JbiqBCMR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 601AD40343;
	Fri, 20 Nov 2026 18:46:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381CA1F000D0;
	Fri, 20 Nov 2026 18:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795200398;
	bh=3ab/tweOrN+MvabFdrOgEaN20+lKttHF+RU7XMxTAZU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JbiqBCMRN70hevS/OOua0fjhZnHdw/pmd7L8Q6ILBCKtNg5dlCJx1IVH+9Xa/33OI
	 4wYMjBzTxWLRN1SsHDQc/cl/OrAslNyOkXXKgRJep4btSzt9WhLpXnvteASXHMyRRH
	 9Aw3PcAcYf78PtDKGVIcfoCbb92Q48CIjnVMfgLFCq+uhW8bnQN/g9jo3yA8WfoinN
	 N6zDarwrL+oB4GTCngFvsxH5C8zv6EXBiELD8Tm2zewp1JXVubelyh4QFkJXxrQINn
	 l+h6q27iUnnM3XgOb4EqaZjq5CdyPVv8PKC0Yp04zoQYj05q4HDhflrr5MsWlR3sEl
	 FlqkzUokUwrCg==
Message-ID: <sashiko-outbox-225872@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 40/60] mm/page_alloc: let MM callers select the local
 private zonelist
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
In-Reply-To: <20261120-private_nodes_v6-v1-40-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-40-74f5f9a115c2@gourry.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 18:46:33 +0000
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4100E1A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 5cnhbi6hfnf4599dtj6hfmq8bc9954pe
X-HE-Tag: 1795200400-256944
X-HE-Meta: U2FsdGVkX1/rYUa5VIH589uznlXyPZk77snpqBi8Na3VvW4d+pFc5aL7QprpxoQsbgZhDrnlKJhfUyQCCOwGXWTu3klBZNvOy7my1smku298dhWWtx9JUg6Ar8N5EaKM1NNtqhTo3vr0ON7uvEvJdpHVCByoLPpKzbe3LWpCxJY2pv5a2PbaysMdqBKHQO6OV2a8EdohXCHMF422d/15hsny//2gZ76rETQKR+n8GAQyQIwddEWZ481bpaxzkfz0tZ3dcERwjw672nwt1DxsCVye4LCAXHf2lPL5bd4QjQvVqtSMc8WubczBDwSBpUQULOOp6+24ny2iFl6y/5c3c1NPDV3WkXn6Ni4YvhSn/gvkQTNp2jx0AjBxCkdCOlfvX4r3RtF538BUdX5soDd7939NKfI2O7FLX0EVp4Jpn5b5jPmll/AjrRptx2R7QVqF3jFqmZTRnLrH7fg4FFuUt6OD89Upn+83/OZpTKzS3x4mRfXOf+FAZiqtHmd4xnd3f6l2qAbzhgXfhjiz39JxTLUQ5/drsz1dFYPxKMvpWT5dTG93BNTUOzRXw8dGKC7i1kRPB6f+nfal12gdYM+J5DJsfjobNSDaLlFsfnV5VfGqxDlPzjYcgSYOmdtiBi4UmVqtQjAYy9u028G0QC4yAXnRRA3BWOjZ+/Weslwb740LUBqNqXRtQwIBMLC9yotGimzUgRdeUhkP6Gu2SAxFBJdN4/RH6EKkXaUax1sI4tyV3KcaFT1euJs3Q4rh3syWr9lecEO4nsTrAwMwPXaLhnWhk6TWpDp6poIckO6jrMwAbHrH+wbtHc6oZFWHKdzfvxVteX5ujXqkLu9iLlyeXABdRqJtSg697nIsaLUwXlgHzq0dXhPFKHeWwfp6t9elAnB1JpjcTCiEd3MRRRIxREW7Y36sIIQ5i4cUs06DaNNn52d3bG0pX4UzQo4sImjMV5B03GEfLkhiDUeH+DR
 qPbeiSpB
 i3mcpKb3T6H3PASgaoVcUsffM8l1eO4oA3dHqnTBpLfKXUH1E28HPJ0HAbWZlsd8SD7pvta6fijjhlPByjhiao0LnqFOx67+JFqrA9VLFZiQd5w1tfKsH2R0HdWncbvBbbdfxygc6Gf5S+8qvHRzyjWOuOkanORgvBVMVc7C2yuBKshGCPEsS1ruGIbpz84bQ2ZKQYO1czStk+EgBXo/UBIZCrjR++7A0gBZIBB76ApKNvkdR+V2kdb49avuzhNS+IlsfQTDFbc61G91ydtTfmSWECFHu2tmmSUA5NTwcvgL7wzGfVw1Ld5kLt7iKXqkI1uuBkz+HfnEl/W1N6CqIw8puMH+Ue1ru98g3oVHw4v+iTSiq88o4ne/aKpjc/K7oQWG9vWEJi685+6DHkoytNZqyQYsaJwWfxVYakzxtngYEoDcadt6HDzpSRnQS2dmiEzveP9yiUU5oU/EYZFEp5c/D/iX34RRwTbGmDk/+jxPjTqDi5oUrP+QAf+izWlW+NBAP3vPOBXXPDC7kHLxf4Yb8dOAkM/LPFNrR0axjn5/gpvg9Pcu9WEp7XfjKALlWfLOBr4q/+NBuicpUCPb152FZjNvtKfvIViiBHRvZYmstzqzHrtpG9DTwebE9l9ayiq27O9LfvoJwZb/4QInn4D/WL9arA300UwdJftXWQYvloxymfMGbQhiTQkCEMgpJfQOuVmKgLk7zwYTktxYH1ILgqjFGPtLyWluLGDiyfZPBFZaWG5rTt38DxqNqIxFENHwGDeVY+DHLtChBvJUaVERgCmbJIhfIXDxiGgI0jQqJg/dX5BG1VgYOPQGefLbtKygZuoKADOIBA2vtM5govELJTMpiALBXVqdwrlByGooy7Aj6LaVouCqTEHxqttkd//1utzHC9Am/xD2Z5mq0ccosCRxs6LRrBudnsa9jxX9D7R8FCLm9gCLk1SOQqDLKwDckUts4E3MzybEeFdnN8Q9Guw==
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
- [Medium] mm/page_alloc: skipped reserve retry in
  __alloc_pages_slowpath()
--

commit c7c69e6797446cf3c44127e33fd21dc6c24deefe
Author: Gregory Price (Meta) <gourry@gourry.net>

mm/page_alloc: let MM callers select the local private zonelist

This commit adds ALLOC_ZONELIST_PRIVATE to allow internal MM callers to
select the local private zonelist independently of __GFP_THISNODE, while
retaining the nodemask and cpuset filtering during reserve allocations.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0bd21916cea1b..a219057931c3d 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4926,16 +4926,24 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned i=
nt order,
>  		goto got_pg;
> =20
>  	reserve_flags =3D __gfp_pfmemalloc_flags(gfp_mask);
> -	if (reserve_flags)
> +	if (reserve_flags) {
> +		unsigned int keep =3D ALLOC_KSWAPD;
> +
> +		/* The cpuset still grants a private request's node. */
> +		if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)
> +			keep |=3D ALLOC_CPUSET;
>  		alloc_flags =3D alloc_flags_cma(gfp_mask) | reserve_flags |
> -				ac->alloc_flags | (alloc_flags & ALLOC_KSWAPD);
> +				ac->alloc_flags | (alloc_flags & keep);
> +	}
> =20
>  	/*
>  	 * Reset the nodemask and zonelist iterators if memory policies can be
>  	 * ignored. These allocations are high priority and system rather than
> -	 * user oriented.
> +	 * user oriented. A private request keeps its node: private memory has
> +	 * no reserves to grant.
>  	 */
> -	if (!(alloc_flags & ALLOC_CPUSET) || reserve_flags) {
> +	if ((!(alloc_flags & ALLOC_CPUSET) || reserve_flags) &&
> +	    !(ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)) {
>  		ac->nodemask =3D NULL;
>  		ac->preferred_zoneref =3D first_zones_zonelist(ac->zonelist,
>  					ac->highest_zoneidx, ac->nodemask);

[Severity: Medium]
Does gating this entire block on !(ac->alloc_flags & ALLOC_ZONELIST_PRIVATE)
skip the can_retry_reserves retry after reserve_flags updates alloc_flags?

When reserve_flags is non-zero (for example, when current has PF_MEMALLOC
set or is an OOM victim), the preceding block updates alloc_flags with
reserve_flags and clears ALLOC_NOFRAGMENT.  Skipping the block below also
skips the can_retry_reserves goto retry, so PF_MEMALLOC and
!can_direct_reclaim callers jump straight to nopage without ever calling
get_page_from_freelist() with the updated alloc_flags (and
!can_direct_reclaim callers also miss the defrag_mode ALLOC_NOFRAGMENT
retry because ALLOC_NOFRAGMENT was already cleared):

mm/page_alloc.c:__alloc_pages_slowpath() {
	...
		if (can_retry_reserves) {
			can_retry_reserves =3D false;
			goto retry;
		}
	}

	/* Caller is not willing to reclaim, we can't balance anything */
	if (!can_direct_reclaim) {
		if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT) &&
		    !(gfp_mask & __GFP_NORETRY) &&
		    (gfp_mask & __GFP_KSWAPD_RECLAIM)) {
			alloc_flags &=3D ~ALLOC_NOFRAGMENT;
			goto retry;
		}
		goto nopage;
	}

	/* Avoid recursion of direct reclaim */
	if (current->flags & PF_MEMALLOC)
		goto nopage;
	...
}

Only the ac->nodemask and ac->preferred_zoneref reset should be skipped for
ALLOC_ZONELIST_PRIVATE when reserve_flags adjusted alloc_flags, while still
performing the can_retry_reserves retry.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-private_no=
des_v6-v1-0-74f5f9a115c2@gourry.net?part=3D40

