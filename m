Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 695B8CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 15:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39B58E0002; Mon, 15 Sep 2025 11:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0FC58E0001; Mon, 15 Sep 2025 11:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25A48E0002; Mon, 15 Sep 2025 11:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8EFF38E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:55:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40E6959C87
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:55:07 +0000 (UTC)
X-FDA: 83891933454.28.2B5CAFF
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2573E140011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 15:55:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=BErcVIUL;
	spf=pass (imf09.hostedemail.com: domain of "prvs=5353faf606=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5353faf606=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757951705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4HsEdErpHybfhXWy+tJAsZuMRVLTSOg/mwZq3x+RPLY=;
	b=tDQ1GTpCKTM5vz8+AJXfJkBwAups3B/3LqGS/ZI5I+EwxQn33AuOFoCDN9DFt9/Ogp1JNY
	Ka91QdX/lLrCJsYDjfQOwMJ42LcuHN/Lxtoz/+hbkvAy58gUdhXFugmtCx/B86Ux5YZsf9
	goCMMDsC5nZDi8JtdO4NVoqFgxgpLmE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=BErcVIUL;
	spf=pass (imf09.hostedemail.com: domain of "prvs=5353faf606=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=5353faf606=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757951705; a=rsa-sha256;
	cv=none;
	b=wkQN9Fxt0U/OQh/EYlah5jjrXJFu2LAuIruCOUWG7Gj57y/vWYWH4bdFpqqmOh6TF8e6Ov
	RBzZ85XDe/2Teq/l7FwXFxo0s1UKIovM/iXcuTtnhKaQH4YFH3KyUGUEOzgUntv9yjtPP6
	8QdAIiSAB0opWoYXtPxK5A4jM8uDrqw=
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 58FBa6A11938139
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:55:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=4HsEdErpHybfhXWy+tJAsZuMRVLTSOg/mwZq3x+RPLY=; b=BErcVIULombT
	uIKbPTsrFAiJDhXFWkbD5XPsxuOQpaNISeJ7hnhILjKZKq0dUDvBt3es190Fjy+G
	cHcCL23/mzmnZH5i/sz8I4mJQ9Z+MSLEDFQICMugpQyO35hA3r4wY48a44ogToss
	sZ+jggMMRHkG0S5+2tfC6nBxjpBATNs4cvGNxkWRDgTKpVE9tSduY4J3e7CnlO0I
	9Nfgf9j7Udyft/swCaeGxVptuHh9MeX6P74KxiiwD/quAhk1NJuY+YQ+qw6nEaO1
	8gjR2pn/Scf4v20VluRSCIxQB3/fhUS/XpTfs0EyRKVKOVYzzk1zh224w3bZnF4h
	xSzP2lxGSA==
Received: from maileast.thefacebook.com ([163.114.135.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 496j2s1y8u-6
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 08:55:03 -0700 (PDT)
Received: from twshared25257.02.ash9.facebook.com (2620:10d:c0a8:1b::8e35) by
 mail.thefacebook.com (2620:10d:c0a9:6f::237c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Mon, 15 Sep 2025 15:55:00 +0000
Received: by devbig091.ldc1.facebook.com (Postfix, from userid 8731)
	id D01C025CCA63; Mon, 15 Sep 2025 08:07:22 -0700 (PDT)
From: Chris Mason <clm@meta.com>
To: Kairui Song <ryncsn@gmail.com>
CC: Chris Mason <clm@meta.com>, <linux-mm@kvack.org>,
        Andrew Morton
	<akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>, Hugh
 Dickins <hughd@google.com>,
        Chris Li <chrisl@kernel.org>, Barry Song
	<baohua@kernel.org>,
        Baoquan He <bhe@redhat.com>, Nhat Pham
	<nphamcs@gmail.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>,
        Baolin Wang
	<baolin.wang@linux.alibaba.com>,
        Ying Huang <ying.huang@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        David Hildenbrand <david@redhat.com>,
        Yosry Ahmed <yosryahmed@google.com>,
        Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
        <linux-kernel@vger.kernel.org>, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3 14/15] mm, swap: implement dynamic allocation of swap table
Date: Mon, 15 Sep 2025 08:05:57 -0700
Message-ID: <20250915150719.3446727-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250910160833.3464-15-ryncsn@gmail.com>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE1MDE1MSBTYWx0ZWRfX8bbs7J1pUNzn
 kdBP8hEtXIzzpa2wHy9Ilk3cG+FhhFxXK2CfEW/YclkbknN1eEtOte6KwCAtaJbKhfXIg5BSdVl
 BfVQB1xyhZOSd3rHgCUFwnKab/f4OKmRbYv1+iGN8JwYYqzs5GcrPqmBJ1eQiNk5wxdXkEF+9Aw
 sdEH9+yoIom4bEko0tCmTh/sRdOUOsm8UWke/h8DQd9QplwIX7Dkh5lCau0J6jLZ1sZa6poRapu
 fKeqWSwGx7v6eDPx684VGJOMJcKOEv44xAV1Ur1bQXP6Brr2vqdr5TZqLbjr/aCIzxXAB+2iCSH
 98F2aQyE6At9t6mgIAVcNb8ro8+O3vSY1YcIqLll082CzYKjQVW7akgu5zUImQ=
X-Proofpoint-ORIG-GUID: W3lwQZsJyvOgNs9xFO0GR4Nj1nSCsTij
X-Proofpoint-GUID: W3lwQZsJyvOgNs9xFO0GR4Nj1nSCsTij
X-Authority-Analysis: v=2.4 cv=J5Wq7BnS c=1 sm=1 tr=0 ts=68c836d7 cx=c_pps
 a=MfjaFnPeirRr97d5FC5oHw==:117 a=MfjaFnPeirRr97d5FC5oHw==:17
 a=yJojWOMRYYMA:10 a=pGLkceISAAAA:8 a=GvQkQWPkAAAA:8 a=VwQbUJbxAAAA:8
 a=iKxxSpktlHM9fi6nY4MA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-15_06,2025-09-12_01,2025-03-28_01
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2573E140011
X-Stat-Signature: hxciwdecynw4qdhgiuy7r9gb7m8667ie
X-HE-Tag: 1757951704-120997
X-HE-Meta: U2FsdGVkX18JasF058AsxhGtH+pVd7aQBIlyR7ozXdlra3jqd12d3h7SW5dg+CZxbg8IXSGhS8fUw6H02KQGPk6CBt/ej/kSLIWlEfDuPSdCZk4tPPwSMebXbNUSTCASawN8IxYoxvGgCstR9c8YMj9roC3XA+wdJQA90X+AJ8C3PlL2oAMkQ4JpBfJ/u/GPX8V3Kcsx2h0p1pRxtLcf7M1QqGdLtElKzkl2GtC+YM45iVjxdrzH6XZKliz31hoF8G+PGimOTOrk5IWu+MPMh/CKLtFemdA6XafZXWTEkySui3AgB4CuWpBCMNXQ58Z8Cq6hGsTfmvkGFt+vHe5q213rhzHoWbkLwRn3Hgf/Ki93+ziLGQk2sKLQRrffojO5qnTWgoOJiSHdge6QYr3/wMb4DWewazzqZkZtJHoCK1lLc0wYGmavvARlGQPxzTnRMIjXm4qJkGSnmWH3OR5A4SY+PcgOxvKBvdnXp0oRNrVcKDO0nWgB8BrunyJECtdfnOLFZMy7vM7nP4eOcSaf/joS8kMD24kFEEMbTRbskzLrdFkiiJm3SAbrxmpPK4QDq5ke7YOVzNQz7pqiE7F0JlPhHDd6WyxnZrvjs5xC+FZWwF7VRX9ddSCBeJCqkN6jdeUh5j7V2G/2xmL7+qrz49rbYNM6YaQLn87vxyguThLG0f3Qfj+TD4+mR7uFUhz4vMG/lwd7m2HGdA7E02G/CmdT3LiDMSILt/UpNTST9gndYet/K+484dV9G5KDqpCOCU5GHH4ceh+O094cFYpxDZvHU5qxDm7BJZwHDz6op2MwXM5ecVSCA4xAD5XgNvAKQnmS83wCHIZjqeKOo50IzbRsdGtHxGqW5KNn9uqRcz2CRhSc67iCARX2SsoLFwwj0VajRPTIX5qlYQMLslnplehcms2JacYSVpOJ2DcjEgSlVN3LNf0ISgE323sDQg17vY4C2MyFOkoSUU0UZY7
 X+uJdoft
 aavjTq+18JrRTrPFUK5vcbZybYTEpG18fObTC9oHaLtJhkB0pyxsB6yg41ygcQehNsNUh5ULt4IdtHwbIONr2weToArBvRYtCMDWs5oCH7IkCSSSbdeZunTV9IA7Ph7TDdeGgE09wwingmIr7D0Kjp9GdEEghDFH/upBhP03uy6ZqCwBzMlg3hx3I7+rnBFx9P4EdHn/rIIJIPS4CWsMAytMNC6lvHSK++zxvHmewqZfRyuVX8raEFCVGwAEsCGpz02slbPEEmZVk3nPFlo06TFHhindT6N+U5lmDFeY/qW3onga5n8TNsnMJ32uGyadtPsrnbP/CzrF4LKcTvBNXqNmqyXrN2wIHeayfArusRk9ILP5amoZXygZn8/mlbTgRmA5MfOVBdCZL2LCmo+DT1VBSPopOcDGMH0M8FNNdaEuxSDQG3prOXbbB/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Sep 2025 00:08:32 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> From: Kairui Song <kasong@tencent.com>
>=20
> Now swap table is cluster based, which means free clusters can free its
> table since no one should modify it.
>=20
> There could be speculative readers, like swap cache look up, protect
> them by making them RCU protected. All swap table should be filled with
> null entries before free, so such readers will either see a NULL pointe=
r
> or a null filled table being lazy freed.
>=20
> On allocation, allocate the table when a cluster is used by any order.
>=20
> This way, we can reduce the memory usage of large swap device
> significantly.
>=20
> This idea to dynamically release unused swap cluster data was initially
> suggested by Chris Li while proposing the cluster swap allocator and
> it suits the swap table idea very well.
>=20
> Co-developed-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Acked-by: Chris Li <chrisl@kernel.org>
> ---
>  mm/swap.h       |   2 +-
>  mm/swap_state.c |   9 +--
>  mm/swap_table.h |  37 ++++++++-
>  mm/swapfile.c   | 202 ++++++++++++++++++++++++++++++++++++++----------
>  4 files changed, 199 insertions(+), 51 deletions(-)
>=20

[ ... ]

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 89659928465e..faf867a6c5c1 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> =20

[ ... ]

> +/*
> + * Allocate a swap table may need to sleep, which leads to migration,
> + * so attempt an atomic allocation first then fallback and handle
> + * potential race.
> + */
> +static struct swap_cluster_info *
> +swap_cluster_alloc_table(struct swap_info_struct *si,
> +			 struct swap_cluster_info *ci,
> +			 int order)
>  {
> -	unsigned int ci_off;
> -	unsigned long swp_tb;
> +	struct swap_cluster_info *pcp_ci;
> +	struct swap_table *table;
> +	unsigned long offset;
> =20
> -	if (!ci->table)
> -		return;
> +	/*
> +	 * Only cluster isolation from the allocator does table allocation.
> +	 * Swap allocator uses a percpu cluster and holds the local lock.
> +	 */
> +	lockdep_assert_held(&ci->lock);
> +	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +
> +	table =3D kmem_cache_zalloc(swap_table_cachep,
> +				  __GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
> +	if (table) {
> +		rcu_assign_pointer(ci->table, table);
> +		return ci;
> +	}
> +
> +	/*
> +	 * Try a sleep allocation. Each isolated free cluster may cause
> +	 * a sleep allocation, but there is a limited number of them, so
> +	 * the potential recursive allocation should be limited.
> +	 */
> +	spin_unlock(&ci->lock);
> +	if (!(si->flags & SWP_SOLIDSTATE))
> +		spin_unlock(&si->global_cluster_lock);
> +	local_unlock(&percpu_swap_cluster.lock);
> +	table =3D kmem_cache_zalloc(swap_table_cachep, __GFP_HIGH | GFP_KERNE=
L);
> =20
> -	for (ci_off =3D 0; ci_off < SWAPFILE_CLUSTER; ci_off++) {
> -		swp_tb =3D __swap_table_get(ci, ci_off);
> -		if (!swp_tb_is_null(swp_tb))
> -			pr_err_once("swap: unclean swap space on swapoff: 0x%lx",
> -				    swp_tb);
> +	local_lock(&percpu_swap_cluster.lock);
> +	if (!(si->flags & SWP_SOLIDSTATE))
> +		spin_lock(&si->global_cluster_lock);
> +	/*
> +	 * Back to atomic context. First, check if we migrated to a new
> +	 * CPU with a usable percpu cluster. If so, try using that instead.
> +	 * No need to check it for the spinning device, as swap is
> +	 * serialized by the global lock on them.
> +	 *
> +	 * The is_usable check is a bit rough, but ensures order 0 success.
> +	 */
> +	offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> +	if ((si->flags & SWP_SOLIDSTATE) && offset) {
> +		pcp_ci =3D swap_cluster_lock(si, offset);
> +		if (cluster_is_usable(pcp_ci, order) &&
> +		    pcp_ci->count < SWAPFILE_CLUSTER) {
> +			ci =3D pcp_ci;
                       ^^^^^^^^^^^^^
ci came from the caller, and in the case of isolate_lock_cluster() they
had just removed it from a list.  We overwrite ci and return something
different.

> +			goto free_table;
> +		}
> +		swap_cluster_unlock(pcp_ci);
>  	}
> =20
> -	kfree(ci->table);
> -	ci->table =3D NULL;
> +	if (!table)
> +		return NULL;
> +
> +	spin_lock(&ci->lock);
> +	/* Nothing should have touched the dangling empty cluster. */
> +	if (WARN_ON_ONCE(cluster_table_is_alloced(ci)))
> +		goto free_table;
> +
> +	rcu_assign_pointer(ci->table, table);
> +	return ci;
> +
> +free_table:
> +	if (table)
> +		kmem_cache_free(swap_table_cachep, table);
> +	return ci;
>  }
> =20
>  static void move_cluster(struct swap_info_struct *si,

[ ... ]

> @@ -513,13 +584,19 @@ static struct swap_cluster_info *isolate_lock_clu=
ster(
> =20
>  		list_del(&ci->list);
>  		ci->flags =3D CLUSTER_FLAG_NONE;
> -		ret =3D ci;
> +		found =3D ci;

We've pulled ci off the list here.

>  		break;
>  	}
> -out:
>  	spin_unlock(&si->lock);
> =20
> -	return ret;
> +	if (found && !cluster_table_is_alloced(found)) {
> +		/* Only an empty free cluster's swap table can be freed. */
> +		VM_WARN_ON_ONCE(list !=3D &si->free_clusters);
> +		VM_WARN_ON_ONCE(!cluster_is_empty(found));
> +		return swap_cluster_alloc_table(si, found, order);

swap_cluster_alloc_table() may have switched for a different ci? What
happens to the one we pulled off the list?

-chris


