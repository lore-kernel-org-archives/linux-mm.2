Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AB07E6689D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 21:51:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDCBE6B0092; Fri, 19 Dec 2025 16:51:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E937A6B0099; Fri, 19 Dec 2025 16:51:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEA2F6B009B; Fri, 19 Dec 2025 16:51:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CC0986B0092
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:51:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 961B5C0306
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:51:30 +0000 (UTC)
X-FDA: 84237567540.16.3A62DFC
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9F8732000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:51:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y0QuSSH7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766181089; a=rsa-sha256;
	cv=none;
	b=wozUupbZIPaJy/wtD2WBA9KoEsYkA0/ryyoTxVCURk+eWSPSZLQ7zRnZ3mboTnrdTYfwjZ
	W6k6MnF4z4TKZmZJhnWbu11Kjp1pOxNiucOAVSPSUSTcvcvh+IlkMnNn63erGDAlE4SIc9
	O46UIUtu4rq/TOHyciAS07QEd5NqYQc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y0QuSSH7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766181089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rNFoqlgDQA56uiitPv8yysa4KehXudJlPS9PbYyd1Kc=;
	b=vixnjwADfL27Y8kQxIxHExAZTUG0BJdPEsDCYlbyKrDrSPn2zwoVisoqHuL5q+LeRIzTBZ
	GHGLOi3O5FlKqwQ1JO/KT90krY4b/6rm1XBN+fbnj4yTn3n7aDyKFxF0G4db1wqVEy4yV8
	HdxQLuf/0sYgEAWRz1COd326596fXpY=
Date: Fri, 19 Dec 2025 13:51:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766181081;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rNFoqlgDQA56uiitPv8yysa4KehXudJlPS9PbYyd1Kc=;
	b=Y0QuSSH7VEdDKnqC3BN09CEAzELOAU5UZEqNyfoLH1EHX8dL8l3w+tC3wraX8bHG/iMFQL
	M1Qcok/2BD9DS+UtTWn38wNsv3juS6UJgxxsedqBFcyCXK0hbwQTU/5M6RmcL1H2MMKq/0
	9E9EX/Gm045hLhbEI4uDGNV/6vrrBkM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	JP Kobryn <inwardvessel@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Michal Hocko <mhocko@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v1 2/6] mm: introduce BPF kfuncs to deal with
 memcg pointers
Message-ID: <nicnfk2rfemgjvrlp2wyztymyunfxgd4ixqfnkivzjckwn4x2v@fzxj6prn3c4b>
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
 <20251219015750.23732-3-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219015750.23732-3-roman.gushchin@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9F8732000E
X-Rspamd-Server: rspam03
X-Stat-Signature: etr4cj8m9fydnaympzprkg9qfeqx681s
X-Rspam-User: 
X-HE-Tag: 1766181088-286617
X-HE-Meta: U2FsdGVkX186ifK0+ATQpBieMGgizNfV0aGG6DgNfgN8gwnCrrnmY/ijTkmHuaYQvHtLAK1LyNfP/GZKNnbsAOH8ABJ2ilRHMPMmS5xpcUkVxpbgi2Z0FYs166YVqfeU4tcBb34+xmKZlq0ogGNKHcOoTEA/PazN02RMmBxwJ9U2F+awADqmjcq74vkIna31Y5mA6IhJfg9fk8BdiVSpOIZC/ZV0CAMpUfx1SgsG+L1eMaS5FW5F0gi35Oh8qbhIo7ujTJjdGk8evdy1Jrop6pCR8MWf8zhAoxvGa+14xIU2oT0kHv5ZiAYMkloZ83rUQPRAOH4LIAfCAdQ+tczJa1DbdGlkWvBLa4gR4H7sJlJToCe64L38IFtjiLXdLKiqfSVojc7JxP76mVzrY8jrAXXsnuSPI53HgAr9Clit17DKG6tW19qxyyUQ2CdStkmJncS7f7tsiLMXxnFRDbKMWsZVibtc6+pRfrpldvvIiSKClKeIvf5GeNVe7VuE/6ZP319AuKEKpAdepTa9HhzQfh1Ufji26NDSfp+9K3G/fJN9fMx3CvLQphBaRMltZTP+o0UQKUcDo1XlEU5hWsDqfp+P+TW1GWWvBT+/yRjivcU/7BhCJd6IPQwqNaYiRp6Jr4ZE1+AuXvx7kLRfqvSoDuifSqJDO+yAHVlfRiDALXCpEUpfrIVyt+59LuX+rDuLNZ2Nm3A+v2Lq7n2R57riThDWUzNta1INJ6dPEV8y8DZtAtATqjYr0GRgn7CblkXPuf8kjMs8VV6SkUvxrR5LYIfKaItP8z2zNdnet1cNvPCqwPyhDxXlLWYZ/zzn8O7Fz/w3JyygIUX2XR7qI1ae/FhRz1IOOGnu7HHcDcxhp5WueJ/RKrEGnVfbeAC+r3m7ZULG9K4SC1N2W2uFdqWe0fgTVQf51fE8CNLqT6ozSySnvieaeh504eY7Xg04oJi8i07cM8JqHXCeOA1VUIW
 zaLkmCq2
 7gH+InkzGtqpaI4W8hoG44B7dFfEj89+O1toYFu3Ffr7lzBWji7BJ2y3Ppbm8ijBTSWzuPUIGfXI7AhSwdKrCOjKPFmwtsQ7SirZyENvx0IIfxDXLMOyUz/c0nbBuy6MavJMnBoLWzQAnX8Mdtf7Aiw0qmLavtT5Gbp72ggU+eKhvBXaKN3lLmsY5i+Oh0r9sXaUM7KJAYrMlLTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 05:57:46PM -0800, Roman Gushchin wrote:
> To effectively operate with memory cgroups in BPF there is a need
> to convert css pointers to memcg pointers. A simple container_of
> cast which is used in the kernel code can't be used in BPF because
> from the verifier's point of view that's a out-of-bounds memory access.
> 
> Introduce helper get/put kfuncs which can be used to get
> a refcounted memcg pointer from the css pointer:
>   - bpf_get_mem_cgroup,
>   - bpf_put_mem_cgroup.
> 
> bpf_get_mem_cgroup() can take both memcg's css and the corresponding
> cgroup's "self" css. It allows it to be used with the existing cgroup
> iterator which iterates over cgroup tree, not memcg tree.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/Makefile         |  3 ++
>  mm/bpf_memcontrol.c | 88 +++++++++++++++++++++++++++++++++++++++++++++

Let's add this file to MAINTAINERS file.

>  2 files changed, 91 insertions(+)
>  create mode 100644 mm/bpf_memcontrol.c
> 
> diff --git a/mm/Makefile b/mm/Makefile
> index 9175f8cc6565..79c39a98ff83 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -106,6 +106,9 @@ obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
>  ifdef CONFIG_SWAP
>  obj-$(CONFIG_MEMCG) += swap_cgroup.o
>  endif
> +ifdef CONFIG_BPF_SYSCALL
> +obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
> +endif
>  obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>  obj-$(CONFIG_GUP_TEST) += gup_test.o
>  obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> new file mode 100644
> index 000000000000..8aa842b56817
> --- /dev/null
> +++ b/mm/bpf_memcontrol.c
> @@ -0,0 +1,88 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Memory Controller-related BPF kfuncs and auxiliary code
> + *
> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
> + */
> +
> +#include <linux/memcontrol.h>
> +#include <linux/bpf.h>
> +
> +__bpf_kfunc_start_defs();
> +
> +/**
> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
> + * @css: pointer to the css structure
> + *
> + * Returns a pointer to a mem_cgroup structure after bumping
> + * the corresponding css's reference counter.
> + *
> + * It's fine to pass a css which belongs to any cgroup controller,
> + * e.g. unified hierarchy's main css.
> + *
> + * Implements KF_ACQUIRE semantics.
> + */
> +__bpf_kfunc struct mem_cgroup *
> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
> +{
> +	struct mem_cgroup *memcg = NULL;
> +	bool rcu_unlock = false;
> +
> +	if (!root_mem_cgroup)
> +		return NULL;

Should we also handle mem_cgroup_disabled() here?

> +
> +	if (root_mem_cgroup->css.ss != css->ss) {
> +		struct cgroup *cgroup = css->cgroup;
> +		int ssid = root_mem_cgroup->css.ss->id;
> +
> +		rcu_read_lock();
> +		rcu_unlock = true;
> +		css = rcu_dereference_raw(cgroup->subsys[ssid]);
> +	}
> +
> +	if (css && css_tryget(css))
> +		memcg = container_of(css, struct mem_cgroup, css);
> +
> +	if (rcu_unlock)
> +		rcu_read_unlock();

Any reason to handle rcu lock like this? Why not just take the rcu read
lock irrespective? It is cheap.

> +
> +	return memcg;
> +}
> +
> +/**
> + * bpf_put_mem_cgroup - Put a reference to a memory cgroup
> + * @memcg: memory cgroup to release
> + *
> + * Releases a previously acquired memcg reference.
> + * Implements KF_RELEASE semantics.
> + */
> +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
> +{
> +	css_put(&memcg->css);

Should we NULL check memcg here? bpf_get_mem_cgroup() can return NULL.

> +}
> +
> +__bpf_kfunc_end_defs();
> +
> +BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
> +BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL | KF_RCU)
> +BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)

Will the verifier enforce that bpf_put_mem_cgroup() can not be called
with NULL?

> +
> +BTF_KFUNCS_END(bpf_memcontrol_kfuncs)
> +
> +static const struct btf_kfunc_id_set bpf_memcontrol_kfunc_set = {
> +	.owner          = THIS_MODULE,
> +	.set            = &bpf_memcontrol_kfuncs,
> +};
> +
> +static int __init bpf_memcontrol_init(void)
> +{
> +	int err;
> +
> +	err = register_btf_kfunc_id_set(BPF_PROG_TYPE_UNSPEC,
> +					&bpf_memcontrol_kfunc_set);
> +	if (err)
> +		pr_warn("error while registering bpf memcontrol kfuncs: %d", err);
> +
> +	return err;
> +}
> +late_initcall(bpf_memcontrol_init);
> -- 
> 2.52.0
> 

