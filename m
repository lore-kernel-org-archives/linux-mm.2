Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B44E8C9EC94
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053CC6B0092; Mon, 12 Jan 2026 10:20:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02BCE6B009B; Mon, 12 Jan 2026 10:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50186B00C5; Mon, 12 Jan 2026 10:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3B216B0092
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:20:52 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9D2E5D0DCF
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:20:52 +0000 (UTC)
X-FDA: 84323674344.02.54E8FEA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 417624000E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:20:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ANFGIGqM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WQN8EU13;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mlOykGbL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4HzFOFmH;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n25xYend9nOvPHOgzYEdjuhjORh5tzR0W8gWZOljgv4=;
	b=BED4p6qIzH6lMJIntwM7Ppbds73hhNJO5RoCU3m8xIDkJzZpjFhhSrhYFlVJnkwVkQcpwf
	zqDUFGZd88QYrTq/aNystn6sjyQm+fq0yO7rB1LeHw4P/khL/b4k0da4Gw0Y5ZQE/D+L7X
	4CvagGringq1xKzI+cZhwLbyvg6XBkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231250; a=rsa-sha256;
	cv=none;
	b=xla0r+bUG3iaey4BfVTJV9C3mx4fW7jh2LjpO7/zcbq7ZyFwM0veupt0MyUUvvfZpBJ0MX
	tyVjydY40g9BVn4Yxuljz8Fp1f1HOon84tUjU1MvuN8MiRtQsZBR798UZTaXfRMl+LddAU
	ScpgU+uQC2A+wmmOcG8SezoG5VQ4I0o=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ANFGIGqM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=WQN8EU13;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mlOykGbL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4HzFOFmH;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7348A33686;
	Mon, 12 Jan 2026 15:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231249; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n25xYend9nOvPHOgzYEdjuhjORh5tzR0W8gWZOljgv4=;
	b=ANFGIGqMKZHz5kcqpolbvUF7Uj2hKmxsUUpw/Dx3aiP1QO83Tvv/KI3RH8vFceGbJEQHbj
	3oBusBBln2wG1K58URF1bQ2aLAXBRbd8AjxT3JH5TI8dywo7IVuNpVI6v/YtRjYCoIqSWw
	PiERMCiq4uSnwIooQSrIOGfTLuOqHYw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231249;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n25xYend9nOvPHOgzYEdjuhjORh5tzR0W8gWZOljgv4=;
	b=WQN8EU13EPJiH8sYNXhbLjMgtCmsCzH8BadbmBcTcRqgYjuAxnumnEiLvrO6M3wa6twr7R
	BNAf+hKtBJWqqhBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768231248; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n25xYend9nOvPHOgzYEdjuhjORh5tzR0W8gWZOljgv4=;
	b=mlOykGbLkkFp4qZz+orIWxysK2hjs8nJ4BdcSZ8ECTeeWx9T1DkPfCCBDfgY/DOAcRbpv9
	AGvEhFfX4XrK2Prqi/JzdI3zsQrNnU3qiHfdQzMYBdsd5hPcqegc5//CqoTbgTdFsq0zzH
	bwbey85NZ8+LUOrXoIXyHU85NBgpf/Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768231248;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=n25xYend9nOvPHOgzYEdjuhjORh5tzR0W8gWZOljgv4=;
	b=4HzFOFmH458/lrEJj19sfZJeTI+qne5clMJcEXBH4iN6lL8kzQVHozSMyFmYQkPCpMTlcx
	Ip7FbFCpR2WrhxAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 50A303EA63;
	Mon, 12 Jan 2026 15:20:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ueREE1ARZWndGgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:20:48 +0000
Message-ID: <7a0be5a1-17f5-4bba-9d42-a53fbb84abe8@suse.cz>
Date: Mon, 12 Jan 2026 16:20:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/20] slab: replace cpu (partial) slabs with sheaves
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com,
 kernel test robot <oliver.sang@intel.com>, stable@vger.kernel.org
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 417624000E
X-Rspam-User: 
X-Stat-Signature: gxycgg91cfbbdyh9jf15m6gu17hh96f1
X-HE-Tag: 1768231250-818272
X-HE-Meta: U2FsdGVkX184hpSnOdP17eoVtQFnMmE1McahB4i0fhJJN2fZfJh/edHquhQ3z4lz96F5fRIvvWeEe18muF2W0bKLfTM9WKPDXByKP21Jk1j0JjDCFzhfDUDgeEL8kxt/BjgNyHsSqGyH7JLVpMXqZft8G+HDNS97Af9amLe+JX3UE+6x+/+u/SHj7pJrbLsEdwTANt0uaEO2Znin4fpKCiXqW1nGQzpKELhla/2GxCDd8vbyfYBelvBfUFn1tKWYBqr/b/G6bVMH9VOum7leXQaSafcwlAFGPNCFg4NaJg7F4Pi3kkUemCsyRYgmSJ7fH4EdAHtTd4AtVM696/WsHrvM0yDtDGDPOgOWai9laO05UNGZiFp8LQHHj8yIDvXIUsLtGAcWk9KZt6bQ3u2wJXtLm+rfqTNYBXPiLFxHQcfnceQ1tCdjjWtA6zh2qIx6T7vgd7a7/uV0fW4rBUoqIyip7rd3+bh08HywRdNeQetU2m+e6CybeDiEKNRZDB6v0xlJs4vG2wsQfkoa4JhUf8eeIKS16I1R0Tq7wlaGp7HOHLyi4CDXadbb+XqJiVVbsSrUoepTdviXrU0trwPoezRTLz0BYlmXbnjTW/zWcavlYSGiKUHGwRuxkyYK8RZ5KOSHF/L4qS450xgNTDBdkhAQbUYiXxD2J0XDwFgUdX2igHKSS7Dq6ntgdeEZsTwDp73VSvzH+zPdXAGNRS5W7yGwCm7z/6tFQ6jccIvpJ+2JYoAc2kpy6AbZuwzoPk7D9Z0dd03q6rsNePtyFMZEvNa/HNfSqRddJRcbxDmI+aTSPi3oV/XSUTcgjGm0dqer/ewg+DmhWo+lW7XOPkZwmdr4FhkUmdY2BMDc0HPf3dcpp83dSkHF9/mqr7cEQ7xnkcgcX2EA8lZ1DNhgmKabtJEhxRmXy/AR09w8QZq4SOCftFq632VqY6Uso2g0OwPy/XYEDw2FqeiI1HkolLi
 LIhJoVJt
 fcRFoRr7achctJ3bdpaomPj/ziaaxqMOfwC4Kt9ioio4O55mysk/KiMI9xWlRZsWXq7jgFzgvjW6wVcdfOPdYZFs8q0YcM561X9MknDN9pHSHwVOyDVrditC0GRitUpTE7dJGHtwwWXKiWtF6ZJCNOPWY/c4xypfImrW47S1fcylWmGkVwPVmcDI84qZZDUDsxgL3KfUneChSa7kdWxtL6eez76zVr6s0igNdGZ0M9fC6sYMI40PpmISZtbAjRplcB7DWMbKvfGvPy/wQDQL3mZP13m7B26Eh9YJTWeq+VVVQnLc0wlPNxhRUjVe/9n+yoo8b1/Qa/gHV5TSkrbsdnkVl4PKFAMFowpIWmNEDXxCF8pt2Dpb41VBkwE5YhNtyeUxA+Fl9smX+M7uCwNYfKdHesQ9brTBOU2fPIAmyfagEy3FSgOTsm4IQJqGPfZueEFMBx6uQcshRyaoswaDpGZwtnC7pr6ruQDvR
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/12/26 16:16, Vlastimil Babka wrote:
> Percpu sheaves caching was introduced as opt-in but the goal was to
> eventually move all caches to them. This is the next step, enabling
> sheaves for all caches (except the two bootstrap ones) and then removing
> the per cpu (partial) slabs and lots of associated code.
> 
> Besides (hopefully) improved performance, this removes the rather
> complicated code related to the lockless fastpaths (using
> this_cpu_try_cmpxchg128/64) and its complications with PREEMPT_RT or
> kmalloc_nolock().
> 
> The lockless slab freelist+counters update operation using
> try_cmpxchg128/64 remains and is crucial for freeing remote NUMA objects
> without repeating the "alien" array flushing of SLUB, and to allow
> flushing objects from sheaves to slabs mostly without the node
> list_lock.
> 
> This v2 is the first non-RFC. I would consider exposing the series to
> linux-next at this point.

Well if only I didn't forget to remove the RFC prefix before sending...

> Git branch for the v2:
>   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=sheaves-for-all-v2
> 
> Based on:
>   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=slab/for-7.0/sheaves
>   - includes a sheaves optimization that seemed minor but there was lkp
>     test robot result with significant improvements:
>     https://lore.kernel.org/all/202512291555.56ce2e53-lkp@intel.com/
>     (could be an uncommon corner case workload though)
> 
> Significant (but not critical) remaining TODOs:
> - Integration of rcu sheaves handling with kfree_rcu batching.
>   - Currently the kfree_rcu batching is almost completely bypassed. I'm
>     thinking it could be adjusted to handle rcu sheaves in addition to
>     individual objects, to get the best of both.
> - Performance evaluation. Petr Tesarik has been doing that on the RFC
>   with some promising results (thanks!) and also found a memory leak.
> 
> Note that as many things, this caching scheme change is a tradeoff, as
> summarized by Christoph:
> 
>   https://lore.kernel.org/all/f7c33974-e520-387e-9e2f-1e523bfe1545@gentwo.org/
> 
> - Objects allocated from sheaves should have better temporal locality
>   (likely recently freed, thus cache hot) but worse spatial locality
>   (likely from many different slabs, increasing memory usage and
>   possibly TLB pressure on kernel's direct map).
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
> Changes in v2:
> - Rebased to v6.19-rc1+slab.git slab/for-7.0/sheaves
>   - Some of the preliminary patches from the RFC went in there.
> - Incorporate feedback/reports from many people (thanks!), including:
>   - Make caches with sheaves mergeable.
>   - Fix a major memory leak.
> - Cleanup of stat items.
> - Link to v1: https://patch.msgid.link/20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz
> 
> ---
> Vlastimil Babka (20):
>       mm/slab: add rcu_barrier() to kvfree_rcu_barrier_on_cache()
>       mm/slab: move and refactor __kmem_cache_alias()
>       mm/slab: make caches with sheaves mergeable
>       slab: add sheaves to most caches
>       slab: introduce percpu sheaves bootstrap
>       slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
>       slab: handle kmalloc sheaves bootstrap
>       slab: add optimized sheaf refill from partial list
>       slab: remove cpu (partial) slabs usage from allocation paths
>       slab: remove SLUB_CPU_PARTIAL
>       slab: remove the do_slab_free() fastpath
>       slab: remove defer_deactivate_slab()
>       slab: simplify kmalloc_nolock()
>       slab: remove struct kmem_cache_cpu
>       slab: remove unused PREEMPT_RT specific macros
>       slab: refill sheaves from all nodes
>       slab: update overview comments
>       slab: remove frozen slab checks from __slab_free()
>       mm/slub: remove DEACTIVATE_TO_* stat items
>       mm/slub: cleanup and repurpose some stat items
> 
>  include/linux/slab.h |    6 -
>  mm/Kconfig           |   11 -
>  mm/internal.h        |    1 +
>  mm/page_alloc.c      |    5 +
>  mm/slab.h            |   53 +-
>  mm/slab_common.c     |   56 +-
>  mm/slub.c            | 2591 +++++++++++++++++---------------------------------
>  7 files changed, 950 insertions(+), 1773 deletions(-)
> ---
> base-commit: aff9fb2fffa1175bd5ae3b4630f3d4ae53af450b
> change-id: 20251002-sheaves-for-all-86ac13dc47a5
> 
> Best regards,


