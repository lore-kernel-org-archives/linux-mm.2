Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52DDFD72348
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8474A6B0431; Fri, 23 Jan 2026 03:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81EEE6B0432; Fri, 23 Jan 2026 03:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F636B0433; Fri, 23 Jan 2026 03:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 597FB6B0431
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:14:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F2F8913AD41
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:14:40 +0000 (UTC)
X-FDA: 84362517120.07.0C4EBF6
Received: from mail-dy1-f193.google.com (mail-dy1-f193.google.com [74.125.82.193])
	by imf11.hostedemail.com (Postfix) with ESMTP id 048B940003
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:14:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h0701UNx;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5u/izAHelYbbgOZ0zt1s8Fqw+26uKmcjdJv/FahDsM=;
	b=b6tzj8+D8X3h2GWpN+TpkpaCPtEm4d2iSzr+335b59JhDqpdSHTaT1ptdXs/n80ZqLzoUk
	aoDNSpfcrVFrFWmpKM2T4IEHBmLE91I86X2PgpKpPmCFa8MiMQeBmKk+VFsGyuY2vG/23L
	BQuQsF9hWGacExCDkPvZdQnDKF6qJ0o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h0701UNx;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.193 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156079; a=rsa-sha256;
	cv=none;
	b=yCj1Fn3TLRLLt2bUZJQnxiJIglmynj4P0zR4rZjJMNYl4D5LHbrWvas+cCs+J4HoDcRrcg
	hgJyu6/jhf7x07a0YUU38bJiCzPliwlnhHjI5abgP7sAF1r9RjL5lxcBFQE+wrAdsVRV0x
	UZTYqNz1ZJv+YhUofkfrXqsxZmS3ZLw=
Received: by mail-dy1-f193.google.com with SMTP id 5a478bee46e88-2b740872a01so924303eec.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 00:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769156078; x=1769760878; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w5u/izAHelYbbgOZ0zt1s8Fqw+26uKmcjdJv/FahDsM=;
        b=h0701UNxTbTEdwrWozYnmhu9aPyN2aV4GETJyM4JNJ6uambrE7SP2g5f8hGy8DLe0F
         0GT9K92WYvUBpyo4KNeuZBt05IDYGyCqTHPUJVeGdnqyeyfSV6AFAcFHyArCJMkFlgca
         t7/WAwzNKXa4T7sdH7O5sSry79AyZ1sJ3V/isW0Q5OGM0yDa1LXpXYj+3Fy/CrFAdfaa
         pG7MdpJBmsVl3htCRTAE3zwzGDzbPGU/PHqhVEN1onYlq/A8w5cU2NGJpE5xwpJdaS15
         iXlQUDC74UKmDsvl4TyOIIGyR3vSKv4t7N2v3P5h0aXSxWKH2FYGR4IKjSxZXE6cEB4n
         k7Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769156078; x=1769760878;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w5u/izAHelYbbgOZ0zt1s8Fqw+26uKmcjdJv/FahDsM=;
        b=P6F1Gzq6hIdQ5UqS0HwNaEaH9aJXiXgpnkGFtDxdyifiPZ//yMkps5z0y8gNUBTWqg
         1NN+hgwVrgA3DJ9HZazE5L7xHckGjjhhrY2nLTvdA2A0YbCFJRBlO/+LegKyHwDHvgBL
         Ga97Z/15e7oNy5oWfCt68w5ZQk0sfoiaAxd2pUKP9fUZzhihPU/7aeynZNQC0SU6dBKq
         egO1820Kb98ttFFvnHzypr7SiUWeAqPhDqVU3Mor5TX5Y9CQMzamlux6PQsd79mhR1dh
         kvXzEPEJom5x58FGDS9dqY8jGOHOVThJYnSam36VmsxIHDlq/t3rbpEOF09L1+3jJE4w
         EQlw==
X-Forwarded-Encrypted: i=1; AJvYcCUaTijoOZdLtn1L47+GB16MgezTQ8LNtdU+87PNIkmkbLNwxlc/QXr4OKcMSzLB7BXnKbm0pu/4hw==@kvack.org
X-Gm-Message-State: AOJu0YwMTDgkG2i9x5quxp4RT9PRXR5RiSfQ+X62S/lJA5BPEs9sZ/vk
	327bW2duLE5avOchblQV/w9WnsnfdlQl/5/CFMzRmP9AbhtCov8nm6r6
X-Gm-Gg: AZuq6aKmtvpKffx0rPQmFYAlpxtXltYyEYdVDWhNfJbpApk2PZXcQZLpcI99alxZQAN
	3AMoIYyMYs/IVKibz8zbWNDZUBOTnMaY/7XLKv+w684+Rx7uqafiIlJjjot7OwJHixyUVXXZzGn
	w7l86sKjA2dM4lWzjZETwfwyQVtiSjZUBzLCuWP36hxCVWN+ZHRFVELXrX4GqW0uXpl56hzhFD3
	Oj6MfIcEmPdK+nFnrS6nGZNP4+Lh3L12v6p0QK7sHAL8dWepN2gfENbu6Ey0H/ioerZnyqvbAR1
	NN8OCANzot2/IuFNbekvCZN5JtV1rFjVGS7nYRgNdhNuj6FGvhyLO4VnJIopaoV4F0JbrnSNIkw
	phisYObdkvA5tXwczFR78zrgt/xRbOv2RN6XN3w09wcpe+jASNLCAVnMLLhGv272BVxamyeCEZm
	3H7NWwrCVo7GDKE/OExuIsGJcJuswM4tw=
X-Received: by 2002:a05:7300:d50e:b0:2b7:32a6:82d1 with SMTP id 5a478bee46e88-2b73999899amr1006306eec.13.1769156077534;
        Fri, 23 Jan 2026 00:14:37 -0800 (PST)
Received: from [192.168.2.118] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b73aa03ecasm2106333eec.27.2026.01.23.00.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jan 2026 00:14:37 -0800 (PST)
Message-ID: <87ec59f7-2d76-4c7a-a2b0-57bc4e801d1d@gmail.com>
Date: Fri, 23 Jan 2026 00:14:36 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: optimize stat output for 11% sys time reduce
To: Jianyue Wu <wujianyue000@gmail.com>, akpm@linux-foundation.org
Cc: shakeel.butt@linux.dev, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, muchun.song@linux.dev, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260110042249.31960-1-jianyuew@nvidia.com>
 <20260122114242.72139-1-wujianyue000@gmail.com>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <20260122114242.72139-1-wujianyue000@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 048B940003
X-Stat-Signature: zf1z79aqcwrkm19czoju1e3i6juqct1w
X-Rspam-User: 
X-HE-Tag: 1769156078-854802
X-HE-Meta: U2FsdGVkX18dp6RIH7JEyuHqXPzgLnyJP/Pb/OkFQv+HK+212+xUxSqdICnoe9+WNwNPPKuUhRAG1OuUQV9nOiMIA67MKYP6ct6mGZHU51LmFp5fEzLYo63FwjnK4ShFLYJWHWz0gAKc9KZ1a/898N0d8Kl3gl0CjOz7jDCJU7fpQto0sS2UrQlhZ+JKtBhZwrIbQ7cq0Oi39/mKlrA98ncLSk7tjFfT12iqb8RqFEeNUIEpHxF9DtOwG8HNiVNNNw9iqD8fCMV5QytMvoRODN3ot5Joyt6imFxBa2Rv1weXKGa3oTsa8ttlzCd/E2UYgR2Pmg2vlm21RFeQ0URgfj2uEFP2YPzq2Y5vMy7XfOm/AmcR7oaEVozpaWjr8iwP3BbUwU0z0zlYfxZFHp0cLsmYKGZBBz24DoatV2jciVgRPLxKlwuDmnM3o1+5GrE0bpi2hBC3plC4yp0COLwx0zSqbkK8pnP5EjrKGXlbQs8RHyB4Gl6ssMgayQ5JgSF1g1hSEQY/8S0keF8hns+4TmD1l2vjgxr3vthJovlkeXbUKLhkRaiQyb12I+7HtLOHMzcI0ofDayOaVB5/167RW5X+ja7kQfQwLcDyRYBLjSQsLMhpjopgrjvxJ7MWoBBgzksc3Mp9rlF2tsti8iDIx/sNzGFo7pBro0VhtyuwMwqz671+AfvxFzpq/FXv8/2ne6LU7PFpddUt9fD667A52/eP+orssaTnyQbP3NKfE4e8KMXAmns307Kfu5e0CWOXiv1IKrbMgzORgaUZbFDH9kpyWuCVdkf3Fm0yVM8KgyQKlGzYWTOrzeOy/rouG0dvCEhUu0rTdfW5JeoWAzouBNKxEX2erTimrVphF6LLqPS9txh/W9ydSk2X5YBB1nQBntJhbOte0y8WpDgyWaQcify48p5l00IMkktBTCyguUwH9C55e/Ljn6E4MEiU6/JGLzkMfc3zV+F1GlHi7f7
 lUOYh9Ye
 PEIbwIVvnL41LwVC1GoYzPmZMRB8pySNqyOfdZmEVBWr1Eg6avTAkY9P8KFHVawTj31dQwrAPPBteUBVkvxgEpurjEMreueSlyMuLq1TK6dEbyFLByFAU8PdSKERPfq35izZcm9j3YLM33GB44jZK4+SzbCqG+4Q+5zirqnIZCRXNOW+nM+xvrKU1EZ/yppY/0AFFTDoMIgTLx+pR2YMp0A0/n5JrsSs5mxhN+vvPyYwcyihpqBpJ1CS86ZQebPeEy4FfoDyOBmYDahZySB68wspyt/FGjWTDlawt0kZpY4sRIwSvG8vjCKA8q61ueJLA+8c02gxpBELHTTEv+OPB5RBuFaur0OqlCUAogvtezTTUNqReziFTlOB7fj683UPj8EEwS4Yxs9DpkJ76EN1lEdQbnih2qljfe2gdxHzIT77uG+XjcN21MiXMf8q+ex/7lSb2o8noOXf46gIxLmAppoosQASoe7uAK8hELPlndT2XeS+8fLlDwFo7yB9gvBGqpppcJP5tweEgIOI4RJ/utl29PJ1k4ZTXDbyiFn796cZ2Kyc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 3:42 AM, Jianyue Wu wrote:
> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
> printf parsing in memcg stats output.
> 
> Key changes:
> - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
> - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
> - Update __memory_events_show(), swap_events_show(),
>    memory_stat_format(), memory_numa_stat_show(), and related helpers
> - Introduce local variables to improve readability and reduce line length
> 
> Performance:
> - 1M reads of memory.stat+memory.numa_stat
> - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
> - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
> 
> Tests:
> - Script:
>    for ((i=1; i<=1000000; i++)); do
>        : > /dev/null < /sys/fs/cgroup/memory.stat
>        : > /dev/null < /sys/fs/cgroup/memory.numa_stat
>    done
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---

Hi Jianyue,
I gave this patch a run and can confirm the perf gain. I left comments
on reducing the amount of added lines so that it better resembles the
existing code.

Tested-by: JP Kobryn <inwardvessel@gmail.com>

> 
> Hi Shakeel,
> 
> Thanks for the review! I've addressed your comments in v3 by moving the
> helper functions to memcontrol.c and adding kernel-doc documentation.
> 
> Thanks,
> Jianyue
> 
> Changes in v3:
> - Move memcg_seq_put_name_val() and memcg_seq_buf_put_name_val() from
>    header (inline) to memcontrol.c and add kernel-doc documentation
>    (Suggested by Shakeel Butt)
> 
> Changes in v2:
> - Initial version with performance optimization
> 
>   mm/memcontrol-v1.c | 120 +++++++++++++++++++++------------
>   mm/memcontrol-v1.h |   6 ++
>   mm/memcontrol.c    | 162 ++++++++++++++++++++++++++++++++++-----------
>   3 files changed, 205 insertions(+), 83 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 6eed14bff742..482475333876 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -10,7 +10,7 @@
>   #include <linux/poll.h>
>   #include <linux/sort.h>
>   #include <linux/file.h>
> -#include <linux/seq_buf.h>
> +#include <linux/string.h>
>   
>   #include "internal.h"
>   #include "swap.h"
> @@ -1795,25 +1795,36 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
>   	mem_cgroup_flush_stats(memcg);
>   
>   	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
> -		seq_printf(m, "%s=%lu", stat->name,
> -			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
> -						   false));
> -		for_each_node_state(nid, N_MEMORY)
> -			seq_printf(m, " N%d=%lu", nid,
> -				   mem_cgroup_node_nr_lru_pages(memcg, nid,
> -							stat->lru_mask, false));
> +		u64 nr_pages;
> +
> +		seq_puts(m, stat->name);
> +		nr_pages = mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
> +						   false);
> +		seq_put_decimal_ull(m, "=", nr_pages);
> +		for_each_node_state(nid, N_MEMORY) {
> +			nr_pages = mem_cgroup_node_nr_lru_pages(memcg, nid,
> +								stat->lru_mask,
> +								false);
> +			seq_put_decimal_ull(m, " N", nid);
> +			seq_put_decimal_ull(m, "=", nr_pages);
> +		}
>   		seq_putc(m, '\n');

There's a recurring pattern of 1) put name, 2) put separator, 3) put
value. Instead of adding so many new lines, I wonder if you could use a
function or macro that accepts: char *name, char sep, u64 val. You could
then use it as a replacement for seq_printf() and avoid the extra added
lines here and throughout this patch.

>   	}
>   
>   	for (stat = stats; stat < stats + ARRAY_SIZE(stats); stat++) {
> -
> -		seq_printf(m, "hierarchical_%s=%lu", stat->name,
> -			   mem_cgroup_nr_lru_pages(memcg, stat->lru_mask,
> -						   true));
> -		for_each_node_state(nid, N_MEMORY)
> -			seq_printf(m, " N%d=%lu", nid,
> -				   mem_cgroup_node_nr_lru_pages(memcg, nid,
> -							stat->lru_mask, true));
> +		u64 nr_pages;
> +
> +		seq_puts(m, "hierarchical_");
> +		seq_puts(m, stat->name);
> +		nr_pages = mem_cgroup_nr_lru_pages(memcg, stat->lru_mask, true);
> +		seq_put_decimal_ull(m, "=", nr_pages);
> +		for_each_node_state(nid, N_MEMORY) {
> +			nr_pages = mem_cgroup_node_nr_lru_pages(memcg, nid,
> +								stat->lru_mask,
> +								true);
> +			seq_put_decimal_ull(m, " N", nid);
> +			seq_put_decimal_ull(m, "=", nr_pages);
> +		}
>   		seq_putc(m, '\n');
>   	}
>   
> @@ -1870,6 +1881,7 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>   	unsigned long memory, memsw;
>   	struct mem_cgroup *mi;
>   	unsigned int i;
> +	u64 memory_limit, memsw_limit;
>   
>   	BUILD_BUG_ON(ARRAY_SIZE(memcg1_stat_names) != ARRAY_SIZE(memcg1_stats));
>   
> @@ -1879,17 +1891,24 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>   		unsigned long nr;
>   
>   		nr = memcg_page_state_local_output(memcg, memcg1_stats[i]);
> -		seq_buf_printf(s, "%s %lu\n", memcg1_stat_names[i], nr);
> +		memcg_seq_buf_put_name_val(s, memcg1_stat_names[i], (u64)nr);
>   	}
>   
> -	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
> -		seq_buf_printf(s, "%s %lu\n", vm_event_name(memcg1_events[i]),
> -			       memcg_events_local(memcg, memcg1_events[i]));
> +	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++) {
> +		u64 events;
>   
> -	for (i = 0; i < NR_LRU_LISTS; i++)
> -		seq_buf_printf(s, "%s %lu\n", lru_list_name(i),
> -			       memcg_page_state_local(memcg, NR_LRU_BASE + i) *
> -			       PAGE_SIZE);
> +		events = memcg_events_local(memcg, memcg1_events[i]);
> +		memcg_seq_buf_put_name_val(s, vm_event_name(memcg1_events[i]),
> +					   events);
> +	}
> +
> +	for (i = 0; i < NR_LRU_LISTS; i++) {
> +		u64 nr_pages;
> +
> +		nr_pages = memcg_page_state_local(memcg, NR_LRU_BASE + i) *
> +			   PAGE_SIZE;
> +		memcg_seq_buf_put_name_val(s, lru_list_name(i), nr_pages);
> +	}
>   
>   	/* Hierarchical information */
>   	memory = memsw = PAGE_COUNTER_MAX;
> @@ -1897,28 +1916,38 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>   		memory = min(memory, READ_ONCE(mi->memory.max));
>   		memsw = min(memsw, READ_ONCE(mi->memsw.max));
>   	}
> -	seq_buf_printf(s, "hierarchical_memory_limit %llu\n",
> -		       (u64)memory * PAGE_SIZE);
> -	seq_buf_printf(s, "hierarchical_memsw_limit %llu\n",
> -		       (u64)memsw * PAGE_SIZE);
> +	memory_limit = (u64)memory * PAGE_SIZE;
> +	memsw_limit = (u64)memsw * PAGE_SIZE;

I don't think in this case these new local variables are improving
readability.

> +
> +	memcg_seq_buf_put_name_val(s, "hierarchical_memory_limit",
> +				   memory_limit);
> +	memcg_seq_buf_put_name_val(s, "hierarchical_memsw_limit",
> +				   memsw_limit);
>   
>   	for (i = 0; i < ARRAY_SIZE(memcg1_stats); i++) {
>   		unsigned long nr;
>   
>   		nr = memcg_page_state_output(memcg, memcg1_stats[i]);
> -		seq_buf_printf(s, "total_%s %llu\n", memcg1_stat_names[i],
> -			       (u64)nr);
> +		seq_buf_puts(s, "total_");
> +		memcg_seq_buf_put_name_val(s, memcg1_stat_names[i], (u64)nr);

I would try and combine these 2 calls into 1 if possible. If the diff
has close to a -1:+1 line change in places where seq_buf_printf() is
replaced with some helper, it would reduce the noisiness. This applies
to other areas where a prefix is put before calling a new helper.

> +	}
> +
> +	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++) {
> +		u64 events;
> +
> +		events = memcg_events(memcg, memcg1_events[i]);
> +		seq_buf_puts(s, "total_");
> +		memcg_seq_buf_put_name_val(s, vm_event_name(memcg1_events[i]),
> +					   events);
>   	}
>   
> -	for (i = 0; i < ARRAY_SIZE(memcg1_events); i++)
> -		seq_buf_printf(s, "total_%s %llu\n",
> -			       vm_event_name(memcg1_events[i]),
> -			       (u64)memcg_events(memcg, memcg1_events[i]));
> +	for (i = 0; i < NR_LRU_LISTS; i++) {
> +		u64 nr_pages;
>   
> -	for (i = 0; i < NR_LRU_LISTS; i++)
> -		seq_buf_printf(s, "total_%s %llu\n", lru_list_name(i),
> -			       (u64)memcg_page_state(memcg, NR_LRU_BASE + i) *
> -			       PAGE_SIZE);
> +		nr_pages = memcg_page_state(memcg, NR_LRU_BASE + i) * PAGE_SIZE;
> +		seq_buf_puts(s, "total_");
> +		memcg_seq_buf_put_name_val(s, lru_list_name(i), nr_pages);
> +	}
>   
>   #ifdef CONFIG_DEBUG_VM
>   	{
> @@ -1933,8 +1962,8 @@ void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>   			anon_cost += mz->lruvec.anon_cost;
>   			file_cost += mz->lruvec.file_cost;
>   		}
> -		seq_buf_printf(s, "anon_cost %lu\n", anon_cost);
> -		seq_buf_printf(s, "file_cost %lu\n", file_cost);
> +		memcg_seq_buf_put_name_val(s, "anon_cost", (u64)anon_cost);
> +		memcg_seq_buf_put_name_val(s, "file_cost", (u64)file_cost);
>   	}
>   #endif
>   }
> @@ -1968,11 +1997,14 @@ static int mem_cgroup_swappiness_write(struct cgroup_subsys_state *css,
>   static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
>   {
>   	struct mem_cgroup *memcg = mem_cgroup_from_seq(sf);
> +	u64 oom_kill;
> +
> +	memcg_seq_put_name_val(sf, "oom_kill_disable",
> +			       READ_ONCE(memcg->oom_kill_disable));
> +	memcg_seq_put_name_val(sf, "under_oom", (bool)memcg->under_oom);
>   
> -	seq_printf(sf, "oom_kill_disable %d\n", READ_ONCE(memcg->oom_kill_disable));
> -	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
> -	seq_printf(sf, "oom_kill %lu\n",
> -		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
> +	oom_kill = atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]);
> +	memcg_seq_put_name_val(sf, "oom_kill", oom_kill);

New local variable just adding extra lines.

>   	return 0;
>   }
>   
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 6358464bb416..46f198a81761 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -4,6 +4,9 @@
>   #define __MM_MEMCONTROL_V1_H
>   
>   #include <linux/cgroup-defs.h>
> +#include <linux/seq_buf.h>
> +#include <linux/seq_file.h>
> +#include <linux/sprintf.h>
>   
>   /* Cgroup v1 and v2 common declarations */
>   
> @@ -33,6 +36,9 @@ int memory_stat_show(struct seq_file *m, void *v);
>   void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n);
>   struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg);
>   
> +void memcg_seq_put_name_val(struct seq_file *m, const char *name, u64 val);
> +void memcg_seq_buf_put_name_val(struct seq_buf *s, const char *name, u64 val);
> +
>   /* Cgroup v1-specific declarations */
>   #ifdef CONFIG_MEMCG_V1
>   
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 86f43b7e5f71..0bc244c5a570 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -42,6 +42,7 @@
>   #include <linux/bit_spinlock.h>
>   #include <linux/rcupdate.h>
>   #include <linux/limits.h>
> +#include <linux/sprintf.h>
>   #include <linux/export.h>
>   #include <linux/list.h>
>   #include <linux/mutex.h>
> @@ -1460,9 +1461,70 @@ static bool memcg_accounts_hugetlb(void)
>   }
>   #endif /* CONFIG_HUGETLB_PAGE */
>   
> +/* Max 2^64 - 1 = 18446744073709551615 (20 digits) */
> +#define MEMCG_DEC_U64_MAX_LEN 20
> +
> +/**
> + * memcg_seq_put_name_val - Write a name-value pair to a seq_file
> + * @m: The seq_file to write to
> + * @name: The name string (not null-terminated required, uses seq_puts)
> + * @val: The u64 value to write
> + *
> + * This helper formats and writes a "name value\n" line to a seq_file,
> + * commonly used for cgroup statistics output. The value is efficiently
> + * converted to decimal using seq_put_decimal_ull.
> + *
> + * Output format: "<name> <value>\n"
> + * Example: "anon 1048576\n"
> + */
> +void memcg_seq_put_name_val(struct seq_file *m, const char *name, u64 val)
> +{
> +	seq_puts(m, name);
> +	/* need a space between name and value */
> +	seq_put_decimal_ull(m, " ", val);
> +	seq_putc(m, '\n');

I think seq_put* calls normally don't imply a newline. Maybe change the
name to reflect, like something with "print"? Also, it's not really
memcg specific.

This function has a space as a separator. Earlier in your diff you were
using '='. A separator parameter could allow this func to be used
elsewhere, but you'd have to manage the newline somehow. Maybe a newline
wrapper?

> +}
> +
> +/**
> + * memcg_seq_buf_put_name_val - Write a name-value pair to a seq_buf
> + * @s: The seq_buf to write to
> + * @name: The name string to write
> + * @val: The u64 value to write
> + *
> + * This helper formats and writes a "name value\n" line to a seq_buf.
> + * Unlike memcg_seq_put_name_val which uses seq_file's built-in formatting,
> + * this function manually converts the value to a string using num_to_str
> + * and writes it using seq_buf primitives for better performance when
> + * batching multiple writes to a seq_buf.
> + *
> + * The function checks for overflow at each step and returns early if
> + * any operation would cause the buffer to overflow.
> + *
> + * Output format: "<name> <value>\n"
> + * Example: "file 2097152\n"
> + */
> +void memcg_seq_buf_put_name_val(struct seq_buf *s, const char *name, u64 val)
> +{
> +	char num_buf[MEMCG_DEC_U64_MAX_LEN];
> +	int num_len;
> +
> +	num_len = num_to_str(num_buf, sizeof(num_buf), val, 0);
> +	if (num_len <= 0)
> +		return;
> +
> +	if (seq_buf_puts(s, name))
> +		return;
> +	if (seq_buf_putc(s, ' '))
> +		return;

Can num_buf[0] just be ' '? The length would have to be extended though.
Not sure if saving a few seq_buf_putc() calls make a difference.

> +	if (seq_buf_putmem(s, num_buf, num_len))
> +		return;
> +	seq_buf_putc(s, '\n');

Similary, though I'm not sure if it even performs better, this call
could be removed and can do num_buf[num_len+1] = '\n' (extend buf
again).

If you make the two changes above you can call seq_buf_putmem() last.

> +}
> +
>   static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>   {
>   	int i;
> +	u64 pgscan, pgsteal;
>   
>   	/*
>   	 * Provide statistics on the state of the memory subsystem as
> @@ -1485,36 +1547,40 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
>   			continue;
>   #endif
>   		size = memcg_page_state_output(memcg, memory_stats[i].idx);
> -		seq_buf_printf(s, "%s %llu\n", memory_stats[i].name, size);
> +		memcg_seq_buf_put_name_val(s, memory_stats[i].name, size);
>   
>   		if (unlikely(memory_stats[i].idx == NR_SLAB_UNRECLAIMABLE_B)) {
>   			size += memcg_page_state_output(memcg,
>   							NR_SLAB_RECLAIMABLE_B);
> -			seq_buf_printf(s, "slab %llu\n", size);
> +			memcg_seq_buf_put_name_val(s, "slab", size);
>   		}
>   	}
>   
>   	/* Accumulated memory events */
> -	seq_buf_printf(s, "pgscan %lu\n",
> -		       memcg_events(memcg, PGSCAN_KSWAPD) +
> -		       memcg_events(memcg, PGSCAN_DIRECT) +
> -		       memcg_events(memcg, PGSCAN_PROACTIVE) +
> -		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
> -	seq_buf_printf(s, "pgsteal %lu\n",
> -		       memcg_events(memcg, PGSTEAL_KSWAPD) +
> -		       memcg_events(memcg, PGSTEAL_DIRECT) +
> -		       memcg_events(memcg, PGSTEAL_PROACTIVE) +
> -		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
> +	pgscan = memcg_events(memcg, PGSCAN_KSWAPD) +
> +		 memcg_events(memcg, PGSCAN_DIRECT) +
> +		 memcg_events(memcg, PGSCAN_PROACTIVE) +
> +		 memcg_events(memcg, PGSCAN_KHUGEPAGED);
> +	pgsteal = memcg_events(memcg, PGSTEAL_KSWAPD) +
> +		  memcg_events(memcg, PGSTEAL_DIRECT) +
> +		  memcg_events(memcg, PGSTEAL_PROACTIVE) +
> +		  memcg_events(memcg, PGSTEAL_KHUGEPAGED);

More extra local variables. You can save the lines instead.

> +
> +	memcg_seq_buf_put_name_val(s, "pgscan", pgscan);
> +	memcg_seq_buf_put_name_val(s, "pgsteal", pgsteal);
>   
>   	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
> +		u64 events;
> +
>   #ifdef CONFIG_MEMCG_V1
>   		if (memcg_vm_event_stat[i] == PGPGIN ||
>   		    memcg_vm_event_stat[i] == PGPGOUT)
>   			continue;
>   #endif
> -		seq_buf_printf(s, "%s %lu\n",
> -			       vm_event_name(memcg_vm_event_stat[i]),
> -			       memcg_events(memcg, memcg_vm_event_stat[i]));
> +		events = memcg_events(memcg, memcg_vm_event_stat[i]);
> +		memcg_seq_buf_put_name_val(s,
> +					   vm_event_name(memcg_vm_event_stat[i]),
> +					   events);
>   	}
>   }
>   
> @@ -4218,10 +4284,12 @@ static void mem_cgroup_attach(struct cgroup_taskset *tset)
>   
>   static int seq_puts_memcg_tunable(struct seq_file *m, unsigned long value)
>   {
> -	if (value == PAGE_COUNTER_MAX)
> +	if (value == PAGE_COUNTER_MAX) {
>   		seq_puts(m, "max\n");
> -	else
> -		seq_printf(m, "%llu\n", (u64)value * PAGE_SIZE);
> +	} else {
> +		seq_put_decimal_ull(m, "", (u64)value * PAGE_SIZE);
> +		seq_putc(m, '\n');
> +	}
>   
>   	return 0;
>   }
> @@ -4247,7 +4315,8 @@ static int peak_show(struct seq_file *sf, void *v, struct page_counter *pc)
>   	else
>   		peak = max(fd_peak, READ_ONCE(pc->local_watermark));
>   
> -	seq_printf(sf, "%llu\n", peak * PAGE_SIZE);
> +	seq_put_decimal_ull(sf, "", peak * PAGE_SIZE);
> +	seq_putc(sf, '\n');

Your benchmark mentions reading memory and numa stat files, but this
function is not reached in those cases. Is this a hot path for you? If
not, maybe just leave this and any others like it alone.

>   	return 0;
>   }
>   
> @@ -4480,16 +4549,24 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
>    */
>   static void __memory_events_show(struct seq_file *m, atomic_long_t *events)
>   {
> -	seq_printf(m, "low %lu\n", atomic_long_read(&events[MEMCG_LOW]));
> -	seq_printf(m, "high %lu\n", atomic_long_read(&events[MEMCG_HIGH]));
> -	seq_printf(m, "max %lu\n", atomic_long_read(&events[MEMCG_MAX]));
> -	seq_printf(m, "oom %lu\n", atomic_long_read(&events[MEMCG_OOM]));
> -	seq_printf(m, "oom_kill %lu\n",
> -		   atomic_long_read(&events[MEMCG_OOM_KILL]));
> -	seq_printf(m, "oom_group_kill %lu\n",
> -		   atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
> -	seq_printf(m, "sock_throttled %lu\n",
> -		   atomic_long_read(&events[MEMCG_SOCK_THROTTLED]));
> +	u64 low, high, max, oom, oom_kill;
> +	u64 oom_group_kill, sock_throttled;
> +
> +	low = atomic_long_read(&events[MEMCG_LOW]);
> +	high = atomic_long_read(&events[MEMCG_HIGH]);
> +	max = atomic_long_read(&events[MEMCG_MAX]);
> +	oom = atomic_long_read(&events[MEMCG_OOM]);
> +	oom_kill = atomic_long_read(&events[MEMCG_OOM_KILL]);
> +	oom_group_kill = atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]);
> +	sock_throttled = atomic_long_read(&events[MEMCG_SOCK_THROTTLED]);

Same, more new locals.

> +
> +	memcg_seq_put_name_val(m, "low", low);
> +	memcg_seq_put_name_val(m, "high", high);
> +	memcg_seq_put_name_val(m, "max", max);
> +	memcg_seq_put_name_val(m, "oom", oom);
> +	memcg_seq_put_name_val(m, "oom_kill", oom_kill);
> +	memcg_seq_put_name_val(m, "oom_group_kill", oom_group_kill);
> +	memcg_seq_put_name_val(m, "sock_throttled", sock_throttled);
>   }
>   
>   static int memory_events_show(struct seq_file *m, void *v)
> @@ -4544,7 +4621,7 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
>   		if (memory_stats[i].idx >= NR_VM_NODE_STAT_ITEMS)
>   			continue;
>   
> -		seq_printf(m, "%s", memory_stats[i].name);
> +		seq_puts(m, memory_stats[i].name);
>   		for_each_node_state(nid, N_MEMORY) {
>   			u64 size;
>   			struct lruvec *lruvec;
> @@ -4552,7 +4629,10 @@ static int memory_numa_stat_show(struct seq_file *m, void *v)
>   			lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(nid));
>   			size = lruvec_page_state_output(lruvec,
>   							memory_stats[i].idx);
> -			seq_printf(m, " N%d=%llu", nid, size);
> +
> +			seq_put_decimal_ull(m, " N", nid);
> +			seq_putc(m, '=');
> +			seq_put_decimal_ull(m, "", size);
>   		}
>   		seq_putc(m, '\n');
>   	}
> @@ -4565,7 +4645,8 @@ static int memory_oom_group_show(struct seq_file *m, void *v)
>   {
>   	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
>   
> -	seq_printf(m, "%d\n", READ_ONCE(memcg->oom_group));
> +	seq_put_decimal_ll(m, "", READ_ONCE(memcg->oom_group));
> +	seq_putc(m, '\n');
>   
>   	return 0;
>   }
> @@ -5372,13 +5453,15 @@ static ssize_t swap_max_write(struct kernfs_open_file *of,
>   static int swap_events_show(struct seq_file *m, void *v)
>   {
>   	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
> +	u64 swap_high, swap_max, swap_fail;
> +
> +	swap_high = atomic_long_read(&memcg->memory_events[MEMCG_SWAP_HIGH]);
> +	swap_max = atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MAX]);
> +	swap_fail = atomic_long_read(&memcg->memory_events[MEMCG_SWAP_FAIL]);

Same, new local variables.

>   
> -	seq_printf(m, "high %lu\n",
> -		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_HIGH]));
> -	seq_printf(m, "max %lu\n",
> -		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_MAX]));
> -	seq_printf(m, "fail %lu\n",
> -		   atomic_long_read(&memcg->memory_events[MEMCG_SWAP_FAIL]));
> +	memcg_seq_put_name_val(m, "high", swap_high);
> +	memcg_seq_put_name_val(m, "max", swap_max);
> +	memcg_seq_put_name_val(m, "fail", swap_fail);
>   
>   	return 0;
>   }
> @@ -5564,7 +5647,8 @@ static int zswap_writeback_show(struct seq_file *m, void *v)
>   {
>   	struct mem_cgroup *memcg = mem_cgroup_from_seq(m);
>   
> -	seq_printf(m, "%d\n", READ_ONCE(memcg->zswap_writeback));
> +	seq_put_decimal_ll(m, "", READ_ONCE(memcg->zswap_writeback));
> +	seq_putc(m, '\n');
>   	return 0;
>   }
>   


