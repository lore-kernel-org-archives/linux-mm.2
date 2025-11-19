Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666F3CEE35E
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 02:10:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03866B00A5; Tue, 18 Nov 2025 21:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3306B00A6; Tue, 18 Nov 2025 21:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A3146B00A8; Tue, 18 Nov 2025 21:10:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83FC56B00A5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:10:15 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DDCA12EB9D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:10:11 +0000 (UTC)
X-FDA: 84125726622.28.F4CEC9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id F0AFC4000F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 02:10:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gQxDJ5mp;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763518210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+C28i6QhxJM8UNZS2+nU7JycDllFDPvl66ZHmXo2z8=;
	b=8WiwheAFAczVvd+YDyJgF8l5mkT/DQhsWtZFYxEMnn/z3xyYM9yQv3EOLuqZRbdSMBkVES
	0MsUbIEM9nF8Julrc+xwEniwXYnDxq9usyMeWc2aY+kQ9uIYpEfJLsIX0/BbgFPeyRJzM2
	zR60OmZPIrt6ZSzODWp08bXHDP2WiGA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gQxDJ5mp;
	spf=pass (imf11.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763518210; a=rsa-sha256;
	cv=none;
	b=k2L7v2HzvGSOCDndJMCbuGnuCt+9kQkM7r7uYU7NfyrcebkaMMWpeQYEfBnbxwVdH5HQ0R
	u84DfZoi5Aj4uLidbCkkDdshWJtBhCupcPVupNpy46Luz/HALPiwsZsOvEJtmgOQznhDH3
	xwi8KdSBreRuPx67CattA5KA8/GDsEg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D0DA6001A;
	Wed, 19 Nov 2025 02:10:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3917C2BC87;
	Wed, 19 Nov 2025 02:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763518209;
	bh=k7vmW/RUqWPlVO5giK/cK6TaEpCgB4w4DRmfGMjrWnE=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=gQxDJ5mpzXpk0ZRIUGBkibfec1sYzpwu0Uuwz8kdw+LLnuMhZ97V4YAIFdA+WlE/v
	 rrkjeKeJs9JNHGJE3yCKsQUQngi0xEnRcOrzCBunHBLMmFqXWkVuWK0xnK2rexsYPR
	 UsKxn+hQHUkRqtwPM9yBlqI6UuyhhIUr80lsmRZVk84KvCjFIvdjzBwE26OJl/gsNu
	 3Gj6HS67WYR3XmND8jP355bJxUMg71T6oKhWvItQFQYELHAhpIKkHeWhwYYSZPtcoh
	 7t5eW19iFqlmpArq94nwOZtTVWxCWhqS6FrqRCcOvYXQbd51t/FXBnw/bczoZS2gff
	 p2NCRuaugVlnQ==
Content-Type: multipart/mixed; boundary="===============6882105097318953948=="
MIME-Version: 1.0
Message-Id: <bb24c9ee360a4538d3aa5f00091586fe0d7ae4b7277ea8efe866457954a75696@mail.kernel.org>
In-Reply-To: <15f95166c6c516f303f3092e74c88ace5164bdf0.1763457705.git.zhuhui@kylinos.cn>
References: <15f95166c6c516f303f3092e74c88ace5164bdf0.1763457705.git.zhuhui@kylinos.cn>
Subject: Re: [RFC PATCH 1/3] memcg: add eBPF struct ops support for memory charging
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,akpm@linux-foundation.org,hannes@cmpxchg.org,mhocko@kernel.org,roman.gushchin@linux.dev,shakeel.butt@linux.dev,muchun.song@linux.dev,ast@kernel.org,daniel@iogearbox.net,andrii@kernel.org,martin.lau@linux.dev,eddyz87@gmail.com,song@kernel.org,yonghong.song@linux.dev,john.fastabend@gmail.com,kpsingh@kernel.org,sdf@fomichev.me,haoluo@google.com,jolsa@kernel.org,shuah@kernel.org,peterz@infradead.org,ojeda@kernel.org,nathan@kernel.org,kees@kernel.org,tj@kernel.org,jeffxu@chromium.org,mkoutny@suse.com,kernel@jfarr.cc,brauner@kernel.org,rdunlap@infradead.org,brgerst@gmail.com,masahiroy@kernel.org,linux-kernel@vger.kernel.org,linux-mm@kvack.org,cgroups@vger.kernel.org,bpf@vger.kernel.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,geliang@kernel.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Wed, 19 Nov 2025 02:10:05 +0000 (UTC)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0AFC4000F
X-Stat-Signature: jcziqatby85e7ghexpnhyzzznctxw4dh
X-Rspam-User: 
X-HE-Tag: 1763518209-753548
X-HE-Meta: U2FsdGVkX1/Ya8K+0QvBItH9SgkejDgCym32eU13jwPk85gU63Z6ClmypB/KZI9iXmHcXTrhlCA82lKYxfPU7ayGFj4P0Q8qNe4Rcwog5oo6lqb+cywiT0dfs+yA6+I+PD3qgFbMbXglXXfeVmBjgohDJtYUOSXBrrRKK/sdwy1zoMSm3oOqkze8tsUy4dTy8G9UizloVqU4UtvkZbOIRw+Xh9o1GZ0j87fY3TLdNBtmMUnTJP8lZZSkr+me7tSdkkHRmfZwMu7OlN3UoRuUBjnjzGizsLF9FJyutzv+3/PBG1gn6BvZX4han3CPsYFq62Ht5R422B/WhW9jVaBVUkVceN8BhYShGklsUBHGdsFIaHMaUEUSrgCLWvu8Yz1R8sIDYIH4FLRglO2BnmM6YM3Ew/U6pwDbDK8YC/geYKBvaH/Kjm5JajkqnyUplIiGvUC8eTDUS/9v3wd1/SrnFTIH+YHLH+VWKnRFx/LcquglNBYXXgYHfLUy1p8CQTnh7CZfV6abI7HX3KUhNqwFcYjHwjuJULi7uXn9EJWJ5WzXTahPCOrWvW+HzDwpdAtosVJ3vWL+LJT6oo9iNmxeFXyXShzT3BZWQnWSWxESGtNWD47yUxExw8JXYSwq6OuGqrO2WpWoGGieSuK6SOZtCrb0iIQypl0DqEerdpAyYD5lQbu7BvKAbAGox2HkmxVAXfXGg2DGHExhDw+rfVnezLLhRby4kolQbOwWPaNR32hFjGqgc2rrwMPHK5j37vtUMv2mdo/PrJ5IS7oHcFjiuMy4G5v4e7eN5T6DFPzcQSbOT6wIyvIAZHQy1NGrmxTgfPEKk3NJS9Ey8KgSXs2B2o3TgGbVb6fvztUJR2/OFOBfY0GOXvvmvsCkzShUCHDjT53GKQ5LodWOGv7sOfPYr10MPkUFqx7r6TICE6KZ6QATVDgBpulJNj9vovnQd2ZorWBN8oskz8ItnTlA6MQ
 MFs/g9qi
 4n12VlscIZ5vKoLCNEp+lCvWt/Xs7Mg9+nE833/aIzalt5+dNmki6sAW1QXuJ8jNL/V7miwU6/p6y7FivaNq55aXyOxHYMnITUIhhtm16ug2zkwU8nH7POhZ4yJXLTi/JoFaU3Rzeu6pwzQ6M/plRMpK+qQBsHLLgjuBIz8LliC+dTF/s72UOOIKbN6xkD5fgvbPLLKK0ywfBxvANaPO3OmRQvK6D7gTcYqgyb7jKdKTrCwCS/smP/58NglbsrGZ47Kq3IL9GtjhiPwDOQt0IZyaxifyPiY/58JLjUTnfWAnk0850BXFOWq90k7Gs//zNvfnWaonn1m8mNfbgLQ0CRZZ51+kJO3Og7XRwnE7eI9JkdrgzQ8IOQM7Jaw/IQ/TPZS7pKvv/AHN9oE9dPiioHpmfK2hfQPzNAkRfSDJNX1KCUR3TOK9oy0Nbdf13maYcATqnqc4XByP0w6FLPJqm0di9DZbqOytHIe3kh5dyH8JELn4ZntYX7oUHzgEMDZbSDlujrqbtDuAB+XA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============6882105097318953948==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4deda3362..104c9e930 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -68,6 +68,7 @@
>  #include <net/ip.h>
>  #include "slab.h"
>  #include "memcontrol-v1.h"
> +#include "memcontrol_bpf.h"
>
>  #include <linux/uaccess.h>
>
> @@ -2301,13 +2302,14 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	int nr_retries = MAX_RECLAIM_RETRIES;
>  	struct mem_cgroup *mem_over_limit;
>  	struct page_counter *counter;
> -	unsigned long nr_reclaimed;
> +	unsigned long nr_reclaime, nr_reclaimed;
>  	bool passed_oom = false;
>  	unsigned int reclaim_options = MEMCG_RECLAIM_MAY_SWAP;
>  	bool drained = false;
>  	bool raised_max_event = false;
>  	unsigned long pflags;
>  	bool allow_spinning = gfpflags_allow_spinning(gfp_mask);
> +	bool charge_done = false;
>
>  retry:
>  	if (consume_stock(memcg, nr_pages))
> @@ -2320,20 +2322,30 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
>  	if (!do_memsw_account() ||
>  	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
>  		if (page_counter_try_charge(&memcg->memory, batch, &counter))
> -			goto done_restock;
> -		if (do_memsw_account())
> -			page_counter_uncharge(&memcg->memsw, batch);
> -		mem_over_limit = mem_cgroup_from_counter(counter, memory);
> +			charge_done = true;
> +		else {
> +			if (do_memsw_account())
> +				page_counter_uncharge(&memcg->memsw, batch);
> +			mem_over_limit = mem_cgroup_from_counter(counter, memory);
> +		}
>  	} else {
>  		mem_over_limit = mem_cgroup_from_counter(counter, memsw);
>  		reclaim_options &= ~MEMCG_RECLAIM_MAY_SWAP;
>  	}
>
> -	if (batch > nr_pages) {
> +	if (!charge_done && batch > nr_pages) {
>  		batch = nr_pages;
>  		goto retry;
>  	}
>
> +	nr_reclaime = bpf_try_charge_memcg(memcg, gfp_mask, nr_pages,
> +					   mem_over_limit,
> +					   reclaim_options,
> +					   charge_done);
                                           ^^^^^^^^^^^^

When charge succeeds (charge_done = true), mem_over_limit is never
initialized but gets passed to bpf_try_charge_memcg(). Looking at
memcontrol_bpf.h, the BPF verifier allows read access to all fields
in struct try_charge_memcg via bpf_tracing_btf_ctx_access() (only
write access to nr_pages is restricted by memcg_ops_btf_struct_access).

Can the BPF program read this uninitialized pointer value? This would
leak kernel stack data to the BPF program.

> +
> +	if (charge_done)
> +		goto done_restock;

[ ... ]

> diff --git a/mm/memcontrol_bpf.h b/mm/memcontrol_bpf.h
> new file mode 100644
> index 000000000..ee2815fc3
> --- /dev/null
> +++ b/mm/memcontrol_bpf.h

[ ... ]

> +static inline unsigned long
> +bpf_try_charge_memcg(struct mem_cgroup *memcg,
> +		     gfp_t gfp_mask,
> +		     unsigned int nr_pages,
> +		     struct mem_cgroup *mem_over_limit,
> +		     unsigned int reclaim_options,
> +		     bool charge_done)
> +{
> +	struct memcg_ops *ops;
> +	struct try_charge_memcg tcm;
> +	int update_nr_pages;
> +
> +	if (likely(!static_branch_unlikely(&memcg_bpf_enable)))
> +		goto out;
> +
> +	ops = memcg_ops_get();
> +	if (unlikely(!ops))
> +		goto out;
> +
> +	tcm.memcg = memcg;
> +	tcm.gfp_mask = gfp_mask;
> +	tcm.nr_pages = nr_pages;
> +	tcm.mem_over_limit = mem_over_limit;
                              ^^^^^^^^^^^^^^^
Here mem_over_limit gets copied into the tcm struct, which is then
passed to the BPF program at the line below.

> +	tcm.reclaim_options = reclaim_options;
> +	tcm.charge_done = charge_done;
> +
> +	update_nr_pages = ops->try_charge_memcg(&tcm);

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/19486904708

--===============6882105097318953948==--

