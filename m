Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 929B5CD4F5B
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 06:34:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 854DA6B0093; Fri, 22 May 2026 02:34:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82C716B0095; Fri, 22 May 2026 02:34:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769B96B0096; Fri, 22 May 2026 02:34:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 656506B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:34:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEF04120808
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:34:05 +0000 (UTC)
X-FDA: 84794090850.22.85F2FF5
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0B3B21C0008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 06:34:03 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R3BIP27m;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779431644; a=rsa-sha256;
	cv=none;
	b=PUMFe+Qudh4r/a1VUuXkl6QCnER82de8UYdtuK9Vuc26qb8DfI2bKoFB5jFwXHAsKBGEEX
	UFsf8oSnG+xAO6u/AyYcDbVA6dJ9FqMQThVD1LLWNqHFUYgHhcwTY6h+FL1n88Ojfnnuxb
	y5gMxQbSvivphI13xMkIUr6HlIE/yE0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R3BIP27m;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779431644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TWYdv8Hq6G2AEgBieu9Gbg4GlepaISy61ztZHjyMni4=;
	b=Xzy0wMdUzdYZL4TFg9bltIw3b/VE1uJbSSZWoplcwwceJdtUTao/rAOCBqQxBWq+9lzkP0
	TAb67hnW/X45dXkXbvqy+8K3SLF92y87OQTzLI+ywST0uMJ6FA3+qAPrw5AUdmOqw+bYXb
	eO4puSq3KlXL0iCitxWxxPktjtYt15Y=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779431641;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TWYdv8Hq6G2AEgBieu9Gbg4GlepaISy61ztZHjyMni4=;
	b=R3BIP27mW+JwnrtL7IlLGViBLl+RRlOm7FTyg9F4tpUNBp2eyZAsYpkwE7xjqmj+/CYioM
	72UZzTOPR8+H05RrzFxiOfWAU15R4Ne87ebUd37dHDdCdghdXHFDFiKMGtGK2vMR2RqRvp
	fk3X96YdGpGgG1BbTOe9Fk2dHI+a1Dc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 4/4] memcg: multi objcg charge support
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260522011908.1669332-5-shakeel.butt@linux.dev>
Date: Fri, 22 May 2026 14:33:36 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>,
 Alexandre Ghiti <alex@ghiti.fr>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9D6F8C2F-F3E7-4326-A4F6-D5B1433A6C55@linux.dev>
References: <20260522011908.1669332-1-shakeel.butt@linux.dev>
 <20260522011908.1669332-5-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 0B3B21C0008
X-Rspamd-Server: rspam03
X-Stat-Signature: t6mhrmed75hd3pioqb4opcbk8kxbwhps
X-HE-Tag: 1779431643-45938
X-HE-Meta: U2FsdGVkX19gS72zhhhKxV+5883Bown9yy4Z+oXKZ8q1crOmGTpczzBONTULWN/VKVn6lPB5naFbK6NG+be34a85/ZtUt9852rxRVFEplYGvUiS0ilAplumO/FdlsQjtssUka2zlx+yXOzvdCYaC2WayS1zhBh8Kl5UlWZLRU28fOSFuod8UDjtkQUYjHMEdjHMGbdKMKPeJnBXQq81W4PscvX/x2ttMZdOPLJs0QK7iff9wHjqbh9n1gd17QM/U0PYw8yc5mRJOZf+D3QEYuF5g3Vr9C96lWU0ol77hlwQUNp68GAsTWm6rQbwxV9hkB/9gDKStF5qvh82U/C990pPYZdd8RZwbkqrRmDiwtNDq25MjtdPCprhyektW18WRJ92RSi+asrRL20nnPY4g3i2FSe20qoDeUkI+HEmvUOWQKyodSE2o1BZvlpim3HTUIZnisG8xECOUWq7Zil0z2WfiqAdvv9yJIpCfpKLHQMCEBN3ikrnL49LVAQ2Emw4p5rLtVDqv+WYd0/GW7wXZANxF6a30mUp3qSyYCs+zfqGb/KIVdomdfU0xth7dyz34bIwv+JeqhvcQSBWVQwl1VxWhxbmhWY/flVKRb51dqVtFjnAf+eSygoXXdicch8Dhb0RonC0GjlqLyTVB68lH16aXRsq2QYQkkf8s9TnAIUuiZEbDqDWPMhg6fIZmvlM1X01DTpRDllEs+fmZCYnoSzxvHOwpcR04JUAw/X0aXF9jE67R0ihR4mkfflrPazbL9I88kn+JT0yG1zmedlJYbVCbXt43u1xIwUGVgRGRZe6s2XMJ7mLKdJX0qze9QvX0wLQgWhVh/IsElHsA+ObHjXj1fofi5heVQW+cZ6VcMI8TbWS38AGGEM3C9T/eOOGcxDbwv7b0UKVWsm/HbnBM1Bw5Oxa9+CkBQhQ2jzQE2vnppEeHJWXi1duKNOHYhLbRSdLS2vpeupGEDZPtA80
 2mtV8XQT
 i0qnsfWVVZwXjWhXEFTS9v6B37vyKIaVsw2dBHQ3HTGKFPSwCgeHepO7wqv7+zFUHOQ1JdXzGIX42z6RNF049ecdmNOVuKfqLCpO81uB5FP7Ze/Js+bfVbVRh/uaYnZ1wAz2gQR16JCiCgy0iYXaBTfBAwhgFLPeXOHvcFjg/jmsib1gvLJO0y0xN2UhSWeavAroLkW3f1ja4KKolBoabfN0uFWil/T6KuA8Nj7DM/BsL0Z0KZvRBmw/9xZo3Phw62Zq+6wWjroAzOto/cCtf0opqGOFU/yNIJpT0d47fsP786GuZA6hYQVnPvFq8VQ6R7QX4c6fGsl+Pm9U4jb/BhTaI5Xod6wxW4r9s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 22, 2026, at 09:19, Shakeel Butt <shakeel.butt@linux.dev> =
wrote:
>=20
> Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
> per-node type") split a memcg's single obj_cgroup into one per NUMA
> node so that reparenting LRU folios can take per-node lru locks. As a
> side effect, the per-CPU obj_stock_pcp -- which caches exactly one
> cached_objcg -- thrashes on workloads where threads of the same memcg
> run on different NUMA nodes. The kernel test robot reported a 67.7%
> regression on stress-ng.switch.ops_per_sec from this pattern.
>=20
> Mirror the multi-slot pattern already used by memcg_stock_pcp: turn
> nr_bytes and cached_objcg into NR_OBJ_STOCK-element arrays, scan all
> slots on consume/refill/account, prefer empty slots when inserting,
> and evict a random slot only when full. With multiple slots a CPU can
> hold the per-node objcg variants of one memcg plus a few siblings
> without ever forcing a drain.
>=20
> A single int8_t index records which slot the cached slab stats belong
> to; the stats are flushed on slot or pgdat change. With NR_OBJ_STOCK
> =3D 5 the layout (verified with pahole) is:
>=20
>  offset 0  : lock(1) + index(1) + node_id(2) + slab stats(4) =3D 8B
>  offset 8  : nr_bytes[5]                                     =3D 10B
>  offset 18 : padding                                         =3D 6B
>  offset 24 : cached[5]                                       =3D 40B
>  offset 64 : (line 2) work_struct + flags (cold)
>=20
> so consume_obj_stock, refill_obj_stock and the slab account path each
> touch exactly one 64-byte cache line on non-debug 64-bit builds.
>=20
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Closes: =
https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
> Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg =
per-node type")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Tested-by: kernel test robot <oliver.sang@intel.com>
> ---
>=20
> Changes since v1:
> - Use round robin for drain
>=20
> mm/memcontrol.c | 188 ++++++++++++++++++++++++++++++++++--------------
> 1 file changed, 136 insertions(+), 52 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 78c02451312b..ba17633b0bd0 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -150,14 +150,14 @@ static void obj_cgroup_release(struct percpu_ref =
*ref)
> 	* However, it can be PAGE_SIZE or (x * PAGE_SIZE).
> 	*
> 	* The following sequence can lead to it:
> - 	* 1) CPU0: objcg =3D=3D stock->cached_objcg
> + 	* 1) CPU0: objcg cached in one of stock->cached[i]
> 	* 2) CPU1: we do a small allocation (e.g. 92 bytes),
> 	*          PAGE_SIZE bytes are charged
> 	* 3) CPU1: a process from another memcg is allocating something,
> 	*          the stock if flushed,
> 	*          objcg->nr_charged_bytes =3D PAGE_SIZE - 92
> 	* 5) CPU0: we do release this object,
           ^
           4

Since you're already modifying the comments in this section,
would you mind fixing the numbering as well? I noticed that the
sequence was wrong a while back :)

> - 	*          92 bytes are added to stock->nr_bytes
> + 	*          92 bytes are added to stock->nr_bytes[i]
> 	* 6) CPU0: stock is flushed,
           ^
           5

Thanks,
Muchun

> 	*          92 bytes are added to objcg->nr_charged_bytes




