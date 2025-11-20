Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79DA5CF8855
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 13:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C389C6B002C; Thu, 20 Nov 2025 08:27:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10016B002E; Thu, 20 Nov 2025 08:27:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFE766B002F; Thu, 20 Nov 2025 08:27:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B88A6B002C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 08:27:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C7CF12C649
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:27:15 +0000 (UTC)
X-FDA: 84131061630.14.47450A0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6CE421C0014
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 13:27:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k1t+HGSp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Lzb6bUQg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="WXkk0i/O";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AR3tzxSe;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763645233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5nYSRDsTSb6EKZ5yCgiUDSza1DT5cehKqpDvcuKfxos=;
	b=LTFTXfPFvEbvb+kIIE5HhLuLa3YeTX5djOLj5BX8yoBqA/Jzyv07wkxXdZNuAgGM6GbsTl
	DNq6+qa2tjaLIHEUhf75zFceOFb+41sx02Zb/1RGybO4mVWtSmdm7SO5MXCW8Zr1B/O3yv
	wmFjwUx5ghxx81ouMlNwr3WzuAXI9u4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763645233; a=rsa-sha256;
	cv=none;
	b=lkOqWkNWGTwOmBi+blyC8Hev+uAq0M/krWSOcy2qQ5YK5jIB1YsuxkO5GBdS4Nyc4z6OFO
	GoTkb3G6nsujSWzWCBmxhormSkB3AQmdWdi990mBUOfzRRzseaG/c5X/tyj/mVvRHTyq8U
	aL+20SjSaEhSV1nGWxxzcM5yNGoYCY8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=k1t+HGSp;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Lzb6bUQg;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="WXkk0i/O";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AR3tzxSe;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A394621291;
	Thu, 20 Nov 2025 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763645230; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5nYSRDsTSb6EKZ5yCgiUDSza1DT5cehKqpDvcuKfxos=;
	b=k1t+HGSpY5oMMeeRoC/cbgDKFFqXzCbVayB1CX4B/NZAElAXJnd33OgbxT+uD6e9KQ6WBZ
	xR2DSeVEp5yBQojhqvTG9lpFiYa2SsJ7VRqh8QZLSVOAISxAY76lZJIx4+QZLtGuA2xwa5
	/MlknTD4WoldZa8soC+FeisbC7nRu4E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763645230;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5nYSRDsTSb6EKZ5yCgiUDSza1DT5cehKqpDvcuKfxos=;
	b=Lzb6bUQgsIlP/fhgXWGPxTwrBBgNvShSVB/1pglR2wjfa7kKcBmHikZ2kxRavOVJn+OMOL
	mc0Td9TF8SDLRAAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763645229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5nYSRDsTSb6EKZ5yCgiUDSza1DT5cehKqpDvcuKfxos=;
	b=WXkk0i/Ob/qF884rMoGuwkWdPAXs3ubRCfWZAsjYTqmxK4df6aEEdsEbmiCZhLl+DD31CZ
	a1xtR73Hf07/pA+b+ofjsk2Y2MOcRBfS2+LE/jzyR1TaaRfqHjcbyUbV0wXwGqLTAQFHWd
	igXFUF6nolqKBDqwzbjL++HZXBC83Kw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763645229;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5nYSRDsTSb6EKZ5yCgiUDSza1DT5cehKqpDvcuKfxos=;
	b=AR3tzxSeldCzZ3MjIYzGx2TNgCCBHa4pVSUzkzIjcO21nI4qKLZv88PWLf5C5fUDAxagK1
	HDWfKh4SLBseqgBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 905463EA61;
	Thu, 20 Nov 2025 13:27:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id j/+0IS0XH2kgDAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 20 Nov 2025 13:27:09 +0000
Message-ID: <c0be63f1-d3f5-46fb-9633-cd860939b34d@suse.cz>
Date: Thu, 20 Nov 2025 14:27:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [linus:master] [slab] ec66e0d599: stress-ng.mmapfiles.ops_per_sec
 51.6% regression
Content-Language: en-US
To: kernel test robot <oliver.sang@intel.com>
Cc: oe-lkp@lists.linux.dev, lkp@intel.com, linux-kernel@vger.kernel.org,
 Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org
References: <202511201550.3efbe5c2-lkp@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <202511201550.3efbe5c2-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wy4nf1ndoy8tzegq51rhsja91scxyeoa
X-Rspam-User: 
X-Rspamd-Queue-Id: 6CE421C0014
X-Rspamd-Server: rspam10
X-HE-Tag: 1763645232-259941
X-HE-Meta: U2FsdGVkX1/n5nC2T+fZKfa+ZdCgQxkDhuVIa6qpjua7JFnKC6bc6kzmImhtKRJx0K1+V7l2/br6fjbrqbNy0IGv4EUTAf+SictfzJbzLQn16gx4idKDZdSnWJaMWfqaVaclcRpgx/wuwECsC0+CCOC8o6vr2xbCGGx49u5hrigDYI++LrKoX3ksq5RifDuqKyG9xnd+bTF2HgwhYFreiihFxMGM5YBTktm/ZiIsVXjEOHRsXZYHSVnzg5h3xJPvor5rQInfUlYnFq9brKmvQ+BpT9it0WTz3K4UhHBqttHZS50IwVEp+3uqlgd+85NiEZVXC8fFylX81yo8qkdDK+aGykx3KxA0wa38v9Sd9wlQBbxMdhFx3icnztRMhbVWSI9DKzXVLGbh7FkEk1ey2XtIkwekTF0fbFrui4kafJWlJXf7OmgcN3zYSWN302Xka+/XhGKvSDwjNJbcLJg4HV6Yp4LxKSswXU0Uzdk9kz4uaTm02Goxf8Cpg/+tFtu7MpjK174B3m1UWZ5iM2vUXviymozkr7wW/5GKnfJOHwbpv+l3hndY6pp0EwiTfMUuk6S9mdT8NG0VCnpe2ISyBJV+GtUq3YspFEhLwL9lmyrHX+TqypHql3w9AofeifggC5fsV+RQbTk9/GqYtUXkERALrvN9rdrvjrfcGwGDjLwV00s5z8LeJsuOXU+upZ/7gCHruMrqhtOcKZgTAXIOE+lpE9h4fBjHto+RugRaGuKdHMZLfbfKgQvyS7sAOKxENboXDWRR/CM41dol4NluGto7YsPWeuz9C0aooHo4V2g3qR+CURnxv7CYGB++uWjpx+JUzDOMAgBdGVkQPxQm0skwXFTGe15lR5eLChSylGpg8p0yVAr1XrV08Rf2upfluKYIKBwkRpIZxif9scHdUtf+ZiGHrBHtdTezg9/4okTuYTDPD3b0y+nJCX7jL8NTjmyuDvHGuxxahCQrzA6
 K7UcxtuL
 Oka/OEOCjF2PNEDM/ySht2asZ+yAOyXw0tr9sDgO/EELuz2A8EFKi7wgu+SqrnwDn1ATNpQwqgJqjekXas+SeVusFTHSsCJy9E4Hm08ID4FxXukbovH8c5TLorc019oRSI/GFBZMSETl1FjhN13f7cYWMOSEuxnxh8uBnAf0KZQvR5Ws/XcetSjXw/xTOEz4D8Z+D27gN6DzhUgceDun4A5ejjupi94ovYKte7T79PqdDPsjkkprrx9fTazaXp8GsO4s9Ac8ruDJ7rgY8MCizZom7sOIxRzL3NvgUoLwIkzZpddL+i79i6YlT4Ms7dLgrjnbUlRs2IOMQEH6eGAGHCFzYBaX4toV/JtdGA8mr2VPgIguh+tYYCaHZpraXqOu3ObCzpMXlZmaRwoWaOKjSw3x+eL7pr4ijZlN1qNPCOAqmBWE8zmvNN/SmuEPKFMr369JA9ZMew4jx/eU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 09:47, kernel test robot wrote:
> 
> 
> Hello,
> 
> kernel test robot noticed a 51.6% regression of stress-ng.mmapfiles.ops_per_sec on:
> 
> 
> commit: ec66e0d599520ab414db745544e25d80d0ac5054 ("slab: add sheaf support for batching kfree_rcu() operations")
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master

This is weird because at that commit, sheaves are not yet enabled for any
cache. So it just adds some cpu overhead (without lock contention or
anything) to kfree_rcu() but that shouldn't regress anything that much and
also wouldn't eplain some of the perf details below (why is there more drm
code visible in profile? etc). Puzzling.

> [still regression on linus/master      23cb64fb76257309e396ea4cec8396d4a1dbae68]
> [still regression on linux-next/master fe4d0dea039f2befb93f27569593ec209843b0f5]
> 
> testcase: stress-ng
> config: x86_64-rhel-9.4
> compiler: gcc-14
> test machine: 64 threads 2 sockets Intel(R) Xeon(R) Gold 6346 CPU @ 3.10GHz (Ice Lake) with 256G memory
> parameters:
> 
> 	nr_threads: 100%
> 	testtime: 60s
> 	test: mmapfiles
> 	cpufreq_governor: performance
> 
> 
> 
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <oliver.sang@intel.com>
> | Closes: https://lore.kernel.org/oe-lkp/202511201550.3efbe5c2-lkp@intel.com
> 
> 
> Details are as below:
> -------------------------------------------------------------------------------------------------->
> 
> 
> The kernel config and materials to reproduce are available at:
> https://download.01.org/0day-ci/archive/20251120/202511201550.3efbe5c2-lkp@intel.com
> 
> =========================================================================================
> compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
>   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-icl-2sp7/mmapfiles/stress-ng/60s
> 
> commit: 
>   2d517aa09b ("slab: add opt-in caching layer of percpu sheaves")
>   ec66e0d599 ("slab: add sheaf support for batching kfree_rcu() operations")
> 
> 2d517aa09bbc4203 ec66e0d599520ab414db745544e 
> ---------------- --------------------------- 
>          %stddev     %change         %stddev
>              \          |                \  
>       5101 ±  3%     +31.9%       6730        uptime.idle
>  1.945e+09 ±  8%     +84.4%  3.587e+09        cpuidle..time
>    1066989 ±  4%     -52.2%     509858 ±  2%  cpuidle..usage
>     111039 ±  8%     -23.1%      85351        meminfo.Mapped
>     117474 ±  9%     -64.3%      41938 ±  5%  meminfo.Shmem
>      20973 ± 52%     -66.9%       6935 ± 51%  numa-meminfo.node0.Shmem
>      96825 ± 14%     -64.2%      34686 ± 12%  numa-meminfo.node1.Shmem
>     805213 ±  6%     -37.8%     500443 ±  8%  numa-numastat.node0.local_node
>     846564 ±  6%     -36.2%     539718 ±  5%  numa-numastat.node0.numa_hit
>     926087 ±  5%     -43.7%     521121 ±  8%  numa-numastat.node1.local_node
>     950918 ±  5%     -42.4%     548005 ±  5%  numa-numastat.node1.numa_hit
>      17592 ± 14%     -86.9%       2310 ± 62%  perf-c2c.DRAM.remote
>      26251 ± 15%     -97.9%     560.50 ± 42%  perf-c2c.HITM.local
>      12343 ± 21%     -98.3%     212.83 ± 33%  perf-c2c.HITM.remote
>      38594 ± 13%     -98.0%     773.33 ± 28%  perf-c2c.HITM.total
>      49.06 ±  8%     +38.2       87.22        mpstat.cpu.all.idle%
>       0.26 ±  4%      -0.2        0.07 ±  2%  mpstat.cpu.all.irq%
>       0.34 ±  5%      -0.2        0.14 ±  2%  mpstat.cpu.all.soft%
>      46.59 ±  8%     -37.0        9.54 ±  2%  mpstat.cpu.all.sys%
>       3.75 ±  3%      -0.7        3.03 ±  2%  mpstat.cpu.all.usr%
>       5301 ± 52%     -67.5%       1725 ± 50%  numa-vmstat.node0.nr_shmem
>     846980 ±  6%     -36.3%     539228 ±  5%  numa-vmstat.node0.numa_hit
>     805629 ±  6%     -37.9%     499953 ±  8%  numa-vmstat.node0.numa_local
>      24340 ± 14%     -64.7%       8598 ± 13%  numa-vmstat.node1.nr_shmem
>     950685 ±  5%     -42.5%     546781 ±  5%  numa-vmstat.node1.numa_hit
>     925853 ±  5%     -43.8%     519898 ±  8%  numa-vmstat.node1.numa_local
>      42.78 ± 20%    +128.7%      97.82 ±  6%  perf-sched.total_wait_and_delay.average.ms
>      27411 ± 17%     -73.7%       7217 ±  7%  perf-sched.total_wait_and_delay.count.ms
>      42.68 ± 20%    +129.2%      97.80 ±  6%  perf-sched.total_wait_time.average.ms
>      42.78 ± 20%    +128.7%      97.82 ±  6%  perf-sched.wait_and_delay.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>      27411 ± 17%     -73.7%       7217 ±  7%  perf-sched.wait_and_delay.count.[unknown].[unknown].[unknown].[unknown].[unknown]
>      42.68 ± 20%    +129.2%      97.80 ±  6%  perf-sched.wait_time.avg.ms.[unknown].[unknown].[unknown].[unknown].[unknown]
>     948660            -2.0%     929444        proc-vmstat.nr_file_pages
>      28101 ±  8%     -23.3%      21556        proc-vmstat.nr_mapped
>      29493 ±  9%     -65.0%      10329 ±  4%  proc-vmstat.nr_shmem
>      37019 ± 36%     -66.8%      12299 ± 70%  proc-vmstat.numa_hint_faults_local
>    1799984 ±  2%     -39.5%    1088731        proc-vmstat.numa_hit
>    1733801 ±  2%     -41.0%    1022572        proc-vmstat.numa_local
>    4027921 ±  2%     -43.2%    2287803        proc-vmstat.pgalloc_normal
>     515117 ±  6%     -14.7%     439270 ±  3%  proc-vmstat.pgfault
>    3875358 ±  2%     -43.8%    2177651        proc-vmstat.pgfree
>     162347 ±  2%      +6.6%     173058        stress-ng.mmapfiles.file_mmaps_per_sec
>     227714 ±  2%     +18.3%     269275        stress-ng.mmapfiles.file_munmap_per_sec
>    6730769 ±  2%      +6.5%    7165751        stress-ng.mmapfiles.file_pages_mmap'd_per_sec
>    9440223 ±  2%     +18.1%   11149909        stress-ng.mmapfiles.file_pages_munmap'd_per_sec
>   14347199 ±  4%     -50.6%    7081102 ±  2%  stress-ng.mmapfiles.ops
>     238147 ±  4%     -51.6%     115229 ±  2%  stress-ng.mmapfiles.ops_per_sec
>      40725 ±  3%     -61.7%      15591 ± 15%  stress-ng.time.involuntary_context_switches
>     130760 ±  5%     -44.6%      72390 ±  9%  stress-ng.time.minor_page_faults
>       3062 ±  8%     -80.1%     609.00 ±  2%  stress-ng.time.percent_of_cpu_this_job_got
>       1822 ±  8%     -79.6%     371.22 ±  2%  stress-ng.time.system_time
>      27.22 ±  7%     -62.5%      10.20 ±  3%  stress-ng.time.user_time
>     128468 ± 14%     -92.6%       9544 ± 13%  stress-ng.time.voluntary_context_switches
>       1582 ±  8%     -74.7%     400.00        turbostat.Avg_MHz
>      51.16 ±  8%     -38.2       12.94        turbostat.Busy%
>       1.84 ±  7%      -1.5        0.32 ±  8%  turbostat.C1E%
>      47.08 ±  8%     +39.7       86.77        turbostat.C6%
>      17.56 ± 14%     +35.8%      23.85        turbostat.CPU%c1
>      10.91 ± 22%    +419.9%      56.73        turbostat.CPU%c6
>      66.50            -9.5%      60.17 ±  2%  turbostat.CoreTmp
>       0.25 ±  8%     +98.0%       0.50        turbostat.IPC
>    6165713 ±  6%     -76.8%    1429713 ±  3%  turbostat.IRQ
>    1607348 ±  8%     -85.6%     231500 ±  8%  turbostat.NMI
>       0.21 ± 64%    +151.2%       0.52 ± 57%  turbostat.Pkg%pc2
>      67.33            -8.9%      61.33 ±  2%  turbostat.PkgTmp
>     193.47           -26.9%     141.49        turbostat.PkgWatt
>      14.64            -2.8%      14.23        turbostat.RAMWatt
>     692012 ± 11%     -95.6%      30567 ±176%  sched_debug.cfs_rq:/.avg_vruntime.avg
>     843998 ± 11%     -87.6%     105070 ± 59%  sched_debug.cfs_rq:/.avg_vruntime.max
>     586404 ± 12%     -96.3%      21456 ±217%  sched_debug.cfs_rq:/.avg_vruntime.min
>      50250 ±  9%     -73.3%      13437 ± 22%  sched_debug.cfs_rq:/.avg_vruntime.stddev
>       0.43 ± 26%     -49.1%       0.22 ± 22%  sched_debug.cfs_rq:/.h_nr_queued.avg
>       0.43 ± 26%     -48.9%       0.22 ± 22%  sched_debug.cfs_rq:/.h_nr_runnable.avg
>     191.51 ± 25%     +49.4%     286.08 ± 21%  sched_debug.cfs_rq:/.load_avg.stddev
>     692012 ± 11%     -95.6%      30567 ±176%  sched_debug.cfs_rq:/.min_vruntime.avg
>     843998 ± 11%     -87.6%     105070 ± 59%  sched_debug.cfs_rq:/.min_vruntime.max
>     586404 ± 12%     -96.3%      21456 ±217%  sched_debug.cfs_rq:/.min_vruntime.min
>      50250 ±  9%     -73.3%      13437 ± 22%  sched_debug.cfs_rq:/.min_vruntime.stddev
>       0.43 ± 25%     -48.9%       0.22 ± 21%  sched_debug.cfs_rq:/.nr_queued.avg
>     125.12 ± 14%    +100.7%     251.12 ± 26%  sched_debug.cfs_rq:/.removed.load_avg.stddev
>     140.75 ± 38%     -63.2%      51.76 ± 18%  sched_debug.cfs_rq:/.util_est.avg
>    1589174 ± 17%     -31.7%    1085437 ± 24%  sched_debug.cpu.avg_idle.avg
>      84100           -30.2%      58725 ± 19%  sched_debug.cpu.clock.avg
>      84105           -30.2%      58729 ± 19%  sched_debug.cpu.clock.max
>      84094           -30.2%      58716 ± 19%  sched_debug.cpu.clock.min
>      83671           -30.1%      58446 ± 19%  sched_debug.cpu.clock_task.avg
>      83965           -30.1%      58706 ± 19%  sched_debug.cpu.clock_task.max
>      75446           -33.2%      50369 ± 22%  sched_debug.cpu.clock_task.min
>       2514 ± 27%     -57.3%       1074 ± 18%  sched_debug.cpu.curr->pid.avg
>    1144485           -19.6%     919879 ±  8%  sched_debug.cpu.max_idle_balance_cost.avg
>     915997 ±  8%     -45.4%     500000        sched_debug.cpu.max_idle_balance_cost.min
>     180422 ±  9%     +95.0%     351823 ±  5%  sched_debug.cpu.max_idle_balance_cost.stddev
>       0.42 ± 25%     -48.3%       0.22 ± 19%  sched_debug.cpu.nr_running.avg
>       7294 ±  4%     -63.9%       2636 ± 24%  sched_debug.cpu.nr_switches.avg
>      16562 ±  7%     -38.9%      10112 ± 13%  sched_debug.cpu.nr_switches.max
>       3591 ± 13%     -89.3%     383.00 ± 35%  sched_debug.cpu.nr_switches.min
>      84094           -30.2%      58721 ± 19%  sched_debug.cpu_clk
>      83382           -30.4%      58008 ± 19%  sched_debug.ktime
>      85326           -29.9%      59776 ± 18%  sched_debug.sched_clk
>       1.30 ±  3%     +12.6%       1.46        perf-stat.i.MPKI
>  5.487e+09           -49.8%  2.754e+09 ±  2%  perf-stat.i.branch-instructions
>       1.62 ±  4%      +1.6        3.26        perf-stat.i.branch-miss-rate%
>   82380569 ±  3%      -9.7%   74393638 ±  2%  perf-stat.i.branch-misses
>      38.92 ±  2%     +21.7       60.64        perf-stat.i.cache-miss-rate%
>   33723559 ±  2%     -42.5%   19401136 ±  2%  perf-stat.i.cache-misses
>   91887377 ±  7%     -64.2%   32858366 ±  2%  perf-stat.i.cache-references
>      10263 ±  6%     -68.9%       3193 ±  5%  perf-stat.i.context-switches
>       4.28 ±  9%     -60.7%       1.68 ±  2%  perf-stat.i.cpi
>  1.026e+11 ±  8%     -74.6%  2.603e+10        perf-stat.i.cpu-cycles
>     271.97 ±  6%     -55.8%     120.25 ±  3%  perf-stat.i.cpu-migrations
>       3718 ± 11%     -66.4%       1248 ±  4%  perf-stat.i.cycles-between-cache-misses
>  2.512e+10           -48.8%  1.286e+10 ±  2%  perf-stat.i.instructions
>       0.28 ±  7%    +158.0%       0.72        perf-stat.i.ipc
>       6900 ±  9%     -18.4%       5628 ±  3%  perf-stat.i.minor-faults
>       6900 ±  9%     -18.4%       5628 ±  3%  perf-stat.i.page-faults
>       1.34 ±  3%     +12.4%       1.51        perf-stat.overall.MPKI
>       1.50 ±  4%      +1.2        2.70        perf-stat.overall.branch-miss-rate%
>      36.77 ±  5%     +22.2       59.01        perf-stat.overall.cache-miss-rate%
>       4.09 ±  7%     -50.5%       2.03        perf-stat.overall.cpi
>       3050 ±  8%     -56.0%       1342        perf-stat.overall.cycles-between-cache-misses
>       0.25 ±  7%    +100.8%       0.49        perf-stat.overall.ipc
>   5.39e+09           -49.7%  2.709e+09 ±  2%  perf-stat.ps.branch-instructions
>   80929629 ±  3%      -9.6%   73166120 ±  2%  perf-stat.ps.branch-misses
>   33114569 ±  2%     -42.4%   19077924 ±  2%  perf-stat.ps.cache-misses
>   90432277 ±  7%     -64.2%   32336218 ±  2%  perf-stat.ps.cache-references
>      10086 ±  6%     -68.8%       3143 ±  5%  perf-stat.ps.context-switches
>  1.009e+11 ±  8%     -74.6%  2.561e+10        perf-stat.ps.cpu-cycles
>     267.93 ±  6%     -55.8%     118.42 ±  3%  perf-stat.ps.cpu-migrations
>  2.468e+10           -48.7%  1.265e+10 ±  2%  perf-stat.ps.instructions
>       6756 ±  9%     -18.1%       5531 ±  3%  perf-stat.ps.minor-faults
>       6756 ±  9%     -18.1%       5531 ±  3%  perf-stat.ps.page-faults
>  1.515e+12           -46.8%  8.056e+11 ±  2%  perf-stat.total.instructions
>      58.02 ± 29%     -49.4        8.66 ± 48%  perf-profile.calltrace.cycles-pp.link_path_walk.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
>      70.23 ± 20%     -48.0       22.23 ± 38%  perf-profile.calltrace.cycles-pp.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64
>      70.28 ± 20%     -47.9       22.34 ± 38%  perf-profile.calltrace.cycles-pp.do_filp_open.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      61.36 ± 19%     -40.7       20.67 ± 37%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      61.38 ± 19%     -40.7       20.71 ± 37%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      64.54 ± 16%     -30.3       34.20 ± 20%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe
>      64.58 ± 16%     -30.3       34.29 ± 20%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe
>      20.45 ± 64%     -16.8        3.69 ± 55%  perf-profile.calltrace.cycles-pp.inode_permission.link_path_walk.path_openat.do_filp_open.do_sys_openat2
>      18.05 ± 69%     -16.1        1.92 ± 54%  perf-profile.calltrace.cycles-pp.kernfs_iop_permission.inode_permission.link_path_walk.path_openat.do_filp_open
>      17.76 ± 67%     -15.6        2.13 ± 42%  perf-profile.calltrace.cycles-pp.lookup_fast.walk_component.link_path_walk.path_openat.do_filp_open
>      17.87 ± 66%     -15.6        2.29 ± 42%  perf-profile.calltrace.cycles-pp.walk_component.link_path_walk.path_openat.do_filp_open.do_sys_openat2
>      15.70 ± 80%     -14.7        1.02 ± 58%  perf-profile.calltrace.cycles-pp.step_into.link_path_walk.path_openat.do_filp_open.do_sys_openat2
>      14.93 ± 86%     -14.5        0.38 ±103%  perf-profile.calltrace.cycles-pp.__d_lookup.lookup_fast.walk_component.link_path_walk.path_openat
>      14.74 ± 87%     -14.5        0.21 ±144%  perf-profile.calltrace.cycles-pp._raw_spin_lock.__d_lookup.lookup_fast.walk_component.link_path_walk
>      14.77 ± 85%     -14.3        0.42 ± 74%  perf-profile.calltrace.cycles-pp.dput.step_into.link_path_walk.path_openat.do_filp_open
>      13.41 ± 96%     -13.4        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.__d_lookup.lookup_fast.walk_component
>      13.02 ± 99%     -13.0        0.00        perf-profile.calltrace.cycles-pp._raw_spin_lock.dput.step_into.link_path_walk.path_openat
>      12.96 ± 99%     -13.0        0.00        perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.dput.step_into.link_path_walk
>       9.36 ± 74%      -8.8        0.55 ± 85%  perf-profile.calltrace.cycles-pp.down_read.kernfs_iop_permission.inode_permission.link_path_walk.path_openat
>       7.71 ± 68%      -7.2        0.53 ±109%  perf-profile.calltrace.cycles-pp.up_read.kernfs_iop_permission.inode_permission.link_path_walk.path_openat
>       9.55 ± 23%      -6.6        2.95 ± 41%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
>       9.55 ± 23%      -6.6        2.95 ± 41%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.__open64_nocancel
>       9.50 ± 23%      -6.6        2.92 ± 42%  perf-profile.calltrace.cycles-pp.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
>       9.49 ± 23%      -6.6        2.91 ± 41%  perf-profile.calltrace.cycles-pp.do_sys_openat2.__x64_sys_openat.do_syscall_64.entry_SYSCALL_64_after_hwframe.__open64_nocancel
>       9.60 ± 22%      -6.5        3.05 ± 42%  perf-profile.calltrace.cycles-pp.__open64_nocancel
>       1.91 ± 78%      -1.5        0.39 ±101%  perf-profile.calltrace.cycles-pp.down_read.kernfs_dop_revalidate.lookup_fast.walk_component.link_path_walk
>       0.38 ±108%      +0.9        1.28 ± 29%  perf-profile.calltrace.cycles-pp.kernfs_fop_open.do_dentry_open.vfs_open.do_open.path_openat
>       0.00            +1.0        0.99 ± 46%  perf-profile.calltrace.cycles-pp.generic_fillattr.kernfs_iop_getattr.vfs_getattr_nosec.vfs_fstat.__do_sys_newfstat
>       0.24 ±150%      +1.1        1.36 ± 33%  perf-profile.calltrace.cycles-pp.intel_idle.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle
>       0.12 ±223%      +1.2        1.37 ± 52%  perf-profile.calltrace.cycles-pp.copy_folio_from_iter_atomic.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write
>       0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel
>       0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.rest_init.start_kernel.x86_64_start_reservations
>       0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.rest_init.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
>       0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.start_kernel.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
>       0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.x86_64_start_kernel.common_startup_64
>       0.00            +1.3        1.34 ± 52%  perf-profile.calltrace.cycles-pp.x86_64_start_reservations.x86_64_start_kernel.common_startup_64
>       0.00            +1.4        1.38 ± 29%  perf-profile.calltrace.cycles-pp.errseq_sample.do_dentry_open.vfs_open.do_open.path_openat
>       0.65 ±100%      +1.5        2.19 ± 40%  perf-profile.calltrace.cycles-pp.record__pushfn.perf_mmap__push.record__mmap_read_evlist.cmd_record.perf_c2c__record
>       0.61 ±100%      +1.6        2.18 ± 40%  perf-profile.calltrace.cycles-pp.entry_SYSCALL_64_after_hwframe.record__pushfn.perf_mmap__push.record__mmap_read_evlist.cmd_record
>       0.60 ±100%      +1.6        2.18 ± 40%  perf-profile.calltrace.cycles-pp.do_syscall_64.entry_SYSCALL_64_after_hwframe.record__pushfn.perf_mmap__push.record__mmap_read_evlist
>       0.58 ±101%      +1.6        2.18 ± 40%  perf-profile.calltrace.cycles-pp.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.record__pushfn.perf_mmap__push
>       0.58 ± 83%      +1.6        2.20 ± 44%  perf-profile.calltrace.cycles-pp.kernfs_fop_readdir.iterate_dir.__x64_sys_getdents64.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.55 ±101%      +1.6        2.17 ± 40%  perf-profile.calltrace.cycles-pp.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe.record__pushfn
>       0.53 ±101%      +1.6        2.16 ± 40%  perf-profile.calltrace.cycles-pp.shmem_file_write_iter.vfs_write.ksys_write.do_syscall_64.entry_SYSCALL_64_after_hwframe
>       0.00            +1.7        1.66 ± 47%  perf-profile.calltrace.cycles-pp.console_flush_all.console_unlock.vprintk_emit._printk.irq_work_run_list
>       0.00            +1.7        1.66 ± 47%  perf-profile.calltrace.cycles-pp.console_unlock.vprintk_emit._printk.irq_work_run_list.irq_work_run
>       0.50 ±102%      +1.7        2.16 ± 40%  perf-profile.calltrace.cycles-pp.generic_perform_write.shmem_file_write_iter.vfs_write.ksys_write.do_syscall_64
>       0.00            +1.7        1.69 ± 44%  perf-profile.calltrace.cycles-pp._printk.irq_work_run_list.irq_work_run.__sysvec_irq_work.sysvec_irq_work
>       0.00            +1.7        1.69 ± 44%  perf-profile.calltrace.cycles-pp.irq_work_run_list.irq_work_run.__sysvec_irq_work.sysvec_irq_work.asm_sysvec_irq_work
>       0.00            +1.7        1.69 ± 44%  perf-profile.calltrace.cycles-pp.vprintk_emit._printk.irq_work_run_list.irq_work_run.__sysvec_irq_work
>       0.70 ± 86%      +1.8        2.53 ± 34%  perf-profile.calltrace.cycles-pp.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary
>       0.74 ± 85%      +2.0        2.70 ± 34%  perf-profile.calltrace.cycles-pp.cpuidle_idle_call.do_idle.cpu_startup_entry.start_secondary.common_startup_64
>       0.85 ± 83%      +2.1        2.99 ± 32%  perf-profile.calltrace.cycles-pp.do_idle.cpu_startup_entry.start_secondary.common_startup_64
>       0.85 ± 83%      +2.1        3.00 ± 32%  perf-profile.calltrace.cycles-pp.cpu_startup_entry.start_secondary.common_startup_64
>       0.85 ± 83%      +2.1        3.00 ± 32%  perf-profile.calltrace.cycles-pp.start_secondary.common_startup_64
>       0.69 ± 85%      +2.2        2.91 ± 39%  perf-profile.calltrace.cycles-pp.cpuidle_enter_state.cpuidle_enter.cpuidle_idle_call.do_idle.cpu_startup_entry
>       0.97 ± 83%      +2.2        3.20 ± 42%  perf-profile.calltrace.cycles-pp.handle_internal_command.main
>       0.97 ± 83%      +2.2        3.20 ± 42%  perf-profile.calltrace.cycles-pp.main
>       0.97 ± 83%      +2.2        3.20 ± 42%  perf-profile.calltrace.cycles-pp.run_builtin.handle_internal_command.main
>       0.32 ±103%      +2.4        2.77 ± 41%  perf-profile.calltrace.cycles-pp.__d_lookup.lookup_fast.open_last_lookups.path_openat.do_filp_open
>       1.10 ± 51%      +3.3        4.36 ± 37%  perf-profile.calltrace.cycles-pp.lookup_fast.open_last_lookups.path_openat.do_filp_open.do_sys_openat2
>       1.30 ± 36%      +3.3        4.58 ± 38%  perf-profile.calltrace.cycles-pp.open_last_lookups.path_openat.do_filp_open.do_sys_openat2.__x64_sys_openat
>       1.04 ± 68%      +3.3        4.33 ± 37%  perf-profile.calltrace.cycles-pp.common_startup_64
>       0.26 ±223%     +11.6       11.89 ±118%  perf-profile.calltrace.cycles-pp.ast_mode_config_helper_atomic_commit_tail.commit_tail.drm_atomic_helper_commit.drm_atomic_commit.drm_atomic_helper_dirtyfb
>       0.26 ±223%     +11.6       11.89 ±118%  perf-profile.calltrace.cycles-pp.drm_atomic_helper_commit_tail.ast_mode_config_helper_atomic_commit_tail.commit_tail.drm_atomic_helper_commit.drm_atomic_commit
>       0.26 ±223%     +11.6       11.89 ±118%  perf-profile.calltrace.cycles-pp.commit_tail.drm_atomic_helper_commit.drm_atomic_commit.drm_atomic_helper_dirtyfb.drm_fbdev_shmem_helper_fb_dirty
>       0.26 ±223%     +11.6       11.89 ±118%  perf-profile.calltrace.cycles-pp.drm_atomic_helper_commit.drm_atomic_commit.drm_atomic_helper_dirtyfb.drm_fbdev_shmem_helper_fb_dirty.drm_fb_helper_damage_work
>       0.26 ±223%     +11.6       11.90 ±118%  perf-profile.calltrace.cycles-pp.drm_atomic_commit.drm_atomic_helper_dirtyfb.drm_fbdev_shmem_helper_fb_dirty.drm_fb_helper_damage_work.process_one_work
>       0.26 ±223%     +11.6       11.91 ±118%  perf-profile.calltrace.cycles-pp.drm_atomic_helper_dirtyfb.drm_fbdev_shmem_helper_fb_dirty.drm_fb_helper_damage_work.process_one_work.worker_thread
>       0.26 ±223%     +11.6       11.91 ±118%  perf-profile.calltrace.cycles-pp.drm_fbdev_shmem_helper_fb_dirty.drm_fb_helper_damage_work.process_one_work.worker_thread.kthread
>       0.26 ±223%     +11.7       11.91 ±118%  perf-profile.calltrace.cycles-pp.drm_fb_helper_damage_work.process_one_work.worker_thread.kthread.ret_from_fork
>       0.47 ±128%     +11.7       12.21 ±115%  perf-profile.calltrace.cycles-pp.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
>       0.67 ± 93%     +11.8       12.44 ±112%  perf-profile.calltrace.cycles-pp.kthread.ret_from_fork.ret_from_fork_asm
>       0.67 ± 93%     +11.8       12.44 ±112%  perf-profile.calltrace.cycles-pp.ret_from_fork.ret_from_fork_asm
>       0.67 ± 93%     +11.8       12.44 ±112%  perf-profile.calltrace.cycles-pp.ret_from_fork_asm
>       0.27 ±223%     +11.9       12.17 ±115%  perf-profile.calltrace.cycles-pp.process_one_work.worker_thread.kthread.ret_from_fork.ret_from_fork_asm
>      58.10 ± 29%     -49.2        8.92 ± 45%  perf-profile.children.cycles-pp.link_path_walk
>      70.25 ± 20%     -48.0       22.27 ± 38%  perf-profile.children.cycles-pp.path_openat
>      70.29 ± 20%     -47.9       22.36 ± 38%  perf-profile.children.cycles-pp.do_filp_open
>      70.86 ± 20%     -47.3       23.61 ± 38%  perf-profile.children.cycles-pp.do_sys_openat2
>      70.88 ± 20%     -47.2       23.65 ± 38%  perf-profile.children.cycles-pp.__x64_sys_openat
>      35.18 ± 65%     -35.1        0.07 ±141%  perf-profile.children.cycles-pp.native_queued_spin_lock_slowpath
>      36.83 ± 63%     -34.8        1.99 ± 37%  perf-profile.children.cycles-pp._raw_spin_lock
>      95.60           -19.4       76.22 ± 15%  perf-profile.children.cycles-pp.do_syscall_64
>      95.71           -19.2       76.47 ± 15%  perf-profile.children.cycles-pp.entry_SYSCALL_64_after_hwframe
>      20.38 ± 69%     -17.8        2.57 ± 49%  perf-profile.children.cycles-pp.kernfs_iop_permission
>      18.81 ± 62%     -17.1        1.71 ± 44%  perf-profile.children.cycles-pp.dput
>      17.89 ± 66%     -15.3        2.55 ± 39%  perf-profile.children.cycles-pp.walk_component
>      15.83 ± 79%     -14.4        1.47 ± 45%  perf-profile.children.cycles-pp.step_into
>      15.19 ± 70%     -13.3        1.84 ± 55%  perf-profile.children.cycles-pp.down_read
>      19.12 ± 60%     -12.2        6.88 ± 35%  perf-profile.children.cycles-pp.lookup_fast
>      15.62 ± 81%     -11.8        3.87 ± 35%  perf-profile.children.cycles-pp.__d_lookup
>       9.24 ± 66%      -7.6        1.61 ± 49%  perf-profile.children.cycles-pp.up_read
>       9.61 ± 22%      -6.5        3.12 ± 42%  perf-profile.children.cycles-pp.__open64_nocancel
>       3.56 ±131%      -3.1        0.43 ± 67%  perf-profile.children.cycles-pp.lockref_get_not_dead
>       3.12 ±132%      -3.1        0.05 ± 73%  perf-profile.children.cycles-pp.__mutex_lock
>       2.68 ± 33%      -1.5        1.15 ± 58%  perf-profile.children.cycles-pp.lockref_put_return
>       0.47 ± 51%      -0.3        0.20 ± 73%  perf-profile.children.cycles-pp.set_nlink
>       0.17 ± 44%      -0.1        0.04 ± 72%  perf-profile.children.cycles-pp.mutex_spin_on_owner
>       0.02 ±144%      +0.1        0.09 ± 26%  perf-profile.children.cycles-pp.schedule_idle
>       0.02 ±145%      +0.1        0.11 ± 40%  perf-profile.children.cycles-pp.__pte_offset_map_lock
>       0.05 ±117%      +0.1        0.14 ± 34%  perf-profile.children.cycles-pp.kfree_rcu_work
>       0.00            +0.1        0.10 ± 49%  perf-profile.children.cycles-pp.__evlist__enable
>       0.00            +0.1        0.10 ± 30%  perf-profile.children.cycles-pp.load_elf_binary
>       0.00            +0.1        0.10 ± 29%  perf-profile.children.cycles-pp.exec_binprm
>       0.00            +0.1        0.11 ± 21%  perf-profile.children.cycles-pp.shmem_add_to_page_cache
>       0.08 ± 23%      +0.1        0.19 ± 26%  perf-profile.children.cycles-pp.native_sched_clock
>       0.10 ± 30%      +0.1        0.21 ± 29%  perf-profile.children.cycles-pp.seq_open
>       0.01 ±223%      +0.1        0.12 ± 36%  perf-profile.children.cycles-pp.__kernfs_iattrs
>       0.11 ± 53%      +0.1        0.23 ± 29%  perf-profile.children.cycles-pp.build_detached_freelist
>       0.00            +0.1        0.12 ± 34%  perf-profile.children.cycles-pp.bprm_execve
>       0.05 ±107%      +0.1        0.17 ± 24%  perf-profile.children.cycles-pp.sched_balance_newidle
>       0.01 ±223%      +0.1        0.14 ± 31%  perf-profile.children.cycles-pp.update_rq_clock_task
>       0.06 ± 55%      +0.1        0.19 ± 48%  perf-profile.children.cycles-pp.strcmp
>       0.00            +0.1        0.13 ± 54%  perf-profile.children.cycles-pp.__x64_sys_exit_group
>       0.00            +0.1        0.13 ± 54%  perf-profile.children.cycles-pp.do_exit
>       0.00            +0.1        0.13 ± 54%  perf-profile.children.cycles-pp.do_group_exit
>       0.08 ± 68%      +0.1        0.22 ± 20%  perf-profile.children.cycles-pp.__pick_next_task
>       0.04 ± 75%      +0.1        0.18 ± 39%  perf-profile.children.cycles-pp.raw_spin_rq_lock_nested
>       0.03 ±103%      +0.1        0.17 ± 32%  perf-profile.children.cycles-pp.__rmqueue_pcplist
>       0.00            +0.1        0.14 ± 40%  perf-profile.children.cycles-pp.read_counters
>       0.00            +0.1        0.14 ± 59%  perf-profile.children.cycles-pp.evlist_cpu_iterator__next
>       0.11 ± 68%      +0.1        0.25 ± 24%  perf-profile.children.cycles-pp.schedule
>       0.02 ±223%      +0.2        0.17 ± 46%  perf-profile.children.cycles-pp.sysvec_call_function_single
>       0.05 ±110%      +0.2        0.20 ± 29%  perf-profile.children.cycles-pp.zap_pte_range
>       0.00            +0.2        0.16 ± 43%  perf-profile.children.cycles-pp.process_interval
>       0.06 ± 55%      +0.2        0.22 ± 55%  perf-profile.children.cycles-pp.get_state_synchronize_rcu_full
>       0.00            +0.2        0.16 ± 41%  perf-profile.children.cycles-pp.cmd_stat
>       0.00            +0.2        0.16 ± 41%  perf-profile.children.cycles-pp.dispatch_events
>       0.08 ± 64%      +0.2        0.24 ± 40%  perf-profile.children.cycles-pp.sched_balance_update_blocked_averages
>       0.00            +0.2        0.16 ± 52%  perf-profile.children.cycles-pp.idle_cpu
>       0.07 ± 72%      +0.2        0.23 ± 37%  perf-profile.children.cycles-pp.kernfs_refresh_inode
>       0.11 ± 38%      +0.2        0.27 ± 35%  perf-profile.children.cycles-pp.obj_cgroup_charge_account
>       0.02 ±223%      +0.2        0.18 ± 46%  perf-profile.children.cycles-pp.asm_sysvec_call_function_single
>       0.07 ± 85%      +0.2        0.25 ± 30%  perf-profile.children.cycles-pp.zap_pmd_range
>       0.00            +0.2        0.18 ± 39%  perf-profile.children.cycles-pp.__x64_sys_execve
>       0.00            +0.2        0.18 ± 39%  perf-profile.children.cycles-pp.do_execveat_common
>       0.00            +0.2        0.18 ± 39%  perf-profile.children.cycles-pp.execve
>       0.06 ± 74%      +0.2        0.26 ± 31%  perf-profile.children.cycles-pp.strlen
>       0.09 ± 52%      +0.2        0.30 ± 50%  perf-profile.children.cycles-pp.x64_sys_call
>       0.15 ± 57%      +0.2        0.37 ± 27%  perf-profile.children.cycles-pp.__schedule
>       0.00            +0.2        0.22 ± 65%  perf-profile.children.cycles-pp.sched_setaffinity
>       0.12 ± 67%      +0.2        0.35 ± 27%  perf-profile.children.cycles-pp.unmap_page_range
>       0.13 ± 41%      +0.2        0.36 ± 48%  perf-profile.children.cycles-pp.kvfree_call_rcu
>       0.17 ± 33%      +0.2        0.41 ± 42%  perf-profile.children.cycles-pp.cp_new_stat
>       0.03 ±103%      +0.3        0.29 ± 43%  perf-profile.children.cycles-pp.__handle_mm_fault
>       0.02 ±141%      +0.3        0.28 ± 44%  perf-profile.children.cycles-pp.vfs_read
>       0.25 ± 25%      +0.3        0.52 ± 31%  perf-profile.children.cycles-pp.native_flush_tlb_one_user
>       0.02 ±141%      +0.3        0.30 ± 47%  perf-profile.children.cycles-pp.ksys_read
>       0.10 ± 37%      +0.3        0.38 ± 27%  perf-profile.children.cycles-pp.shmem_alloc_and_add_folio
>       0.03 ±103%      +0.3        0.31 ± 42%  perf-profile.children.cycles-pp.handle_mm_fault
>       0.20 ± 48%      +0.3        0.48 ± 23%  perf-profile.children.cycles-pp.unmap_region
>       0.03 ±106%      +0.3        0.33 ± 43%  perf-profile.children.cycles-pp.do_user_addr_fault
>       0.03 ±106%      +0.3        0.33 ± 43%  perf-profile.children.cycles-pp.exc_page_fault
>       0.50 ± 26%      +0.3        0.81 ± 22%  perf-profile.children.cycles-pp.tick_nohz_handler
>       0.06 ± 74%      +0.3        0.38 ± 46%  perf-profile.children.cycles-pp.kernfs_dir_pos
>       0.04 ±109%      +0.3        0.35 ± 41%  perf-profile.children.cycles-pp.asm_exc_page_fault
>       0.19 ± 42%      +0.3        0.52 ± 38%  perf-profile.children.cycles-pp.filldir64
>       0.16 ± 35%      +0.3        0.50 ± 31%  perf-profile.children.cycles-pp.__kmalloc_cache_noprof
>       0.52 ± 26%      +0.3        0.86 ± 21%  perf-profile.children.cycles-pp.__hrtimer_run_queues
>       0.30 ± 36%      +0.4        0.65 ± 36%  perf-profile.children.cycles-pp.__memcg_slab_post_alloc_hook
>       0.07 ± 67%      +0.4        0.43 ± 31%  perf-profile.children.cycles-pp.update_sg_lb_stats
>       0.64 ± 25%      +0.4        1.05 ± 24%  perf-profile.children.cycles-pp.hrtimer_interrupt
>       0.64 ± 25%      +0.4        1.06 ± 24%  perf-profile.children.cycles-pp.__sysvec_apic_timer_interrupt
>       0.34 ± 66%      +0.5        0.82 ± 29%  perf-profile.children.cycles-pp.unmap_vmas
>       0.05 ± 76%      +0.5        0.55 ± 88%  perf-profile.children.cycles-pp.do_poll
>       0.07 ± 56%      +0.6        0.62 ± 82%  perf-profile.children.cycles-pp.__x64_sys_poll
>       0.07 ± 56%      +0.6        0.62 ± 82%  perf-profile.children.cycles-pp.do_sys_poll
>       0.08 ± 64%      +0.6        0.64 ± 59%  perf-profile.children.cycles-pp.update_sd_lb_stats
>       0.08 ± 67%      +0.6        0.65 ± 59%  perf-profile.children.cycles-pp.sched_balance_find_src_group
>       0.06 ± 90%      +0.6        0.66 ± 64%  perf-profile.children.cycles-pp.sched_balance_domains
>       0.02 ±223%      +0.6        0.63 ±115%  perf-profile.children.cycles-pp.bit_putcs
>       0.02 ±223%      +0.6        0.64 ±114%  perf-profile.children.cycles-pp.fbcon_putcs
>       0.11 ± 69%      +0.6        0.76 ± 54%  perf-profile.children.cycles-pp.sched_balance_rq
>       0.17 ± 46%      +0.7        0.82 ± 42%  perf-profile.children.cycles-pp.rb_next
>       0.08 ± 59%      +0.7        0.74 ± 71%  perf-profile.children.cycles-pp.do_softirq
>       0.02 ±223%      +0.7        0.69 ±114%  perf-profile.children.cycles-pp.fbcon_redraw
>       0.02 ±223%      +0.7        0.72 ±114%  perf-profile.children.cycles-pp.con_scroll
>       0.02 ±223%      +0.7        0.72 ±114%  perf-profile.children.cycles-pp.fbcon_scroll
>       0.02 ±223%      +0.7        0.72 ±114%  perf-profile.children.cycles-pp.lf
>       0.11 ± 59%      +0.7        0.82 ± 66%  perf-profile.children.cycles-pp.flush_smp_call_function_queue
>       0.02 ±223%      +0.7        0.73 ±113%  perf-profile.children.cycles-pp.vt_console_print
>       0.57 ± 48%      +0.7        1.30 ± 28%  perf-profile.children.cycles-pp.kernfs_fop_open
>       0.55 ± 28%      +0.9        1.40 ± 37%  perf-profile.children.cycles-pp.its_return_thunk
>       0.38 ± 57%      +1.0        1.37 ± 52%  perf-profile.children.cycles-pp.copy_folio_from_iter_atomic
>       0.12 ± 61%      +1.0        1.12 ± 50%  perf-profile.children.cycles-pp._nohz_idle_balance
>       0.43 ± 66%      +1.1        1.49 ± 33%  perf-profile.children.cycles-pp.intel_idle
>       0.11 ± 86%      +1.2        1.34 ± 52%  perf-profile.children.cycles-pp.rest_init
>       0.11 ± 86%      +1.2        1.34 ± 52%  perf-profile.children.cycles-pp.start_kernel
>       0.11 ± 86%      +1.2        1.34 ± 52%  perf-profile.children.cycles-pp.x86_64_start_kernel
>       0.11 ± 86%      +1.2        1.34 ± 52%  perf-profile.children.cycles-pp.x86_64_start_reservations
>       0.87 ± 50%      +1.3        2.17 ± 33%  perf-profile.children.cycles-pp.mas_empty_area_rev
>       0.76 ± 57%      +1.4        2.17 ± 40%  perf-profile.children.cycles-pp.shmem_file_write_iter
>       0.19 ± 63%      +1.4        1.62 ± 30%  perf-profile.children.cycles-pp.errseq_sample
>       0.72 ± 56%      +1.4        2.16 ± 40%  perf-profile.children.cycles-pp.generic_perform_write
>       0.68 ± 56%      +1.5        2.21 ± 44%  perf-profile.children.cycles-pp.kernfs_fop_readdir
>       0.37 ± 61%      +1.6        2.00 ± 38%  perf-profile.children.cycles-pp.generic_fillattr
>       0.18 ± 35%      +1.6        1.82 ± 34%  perf-profile.children.cycles-pp._printk
>       0.19 ± 33%      +1.6        1.84 ± 33%  perf-profile.children.cycles-pp.__sysvec_irq_work
>       0.19 ± 33%      +1.6        1.84 ± 33%  perf-profile.children.cycles-pp.irq_work_run
>       0.19 ± 33%      +1.7        1.84 ± 33%  perf-profile.children.cycles-pp.irq_work_run_list
>       0.19 ± 32%      +1.7        1.84 ± 33%  perf-profile.children.cycles-pp.asm_sysvec_irq_work
>       0.19 ± 33%      +1.7        1.84 ± 33%  perf-profile.children.cycles-pp.sysvec_irq_work
>       1.50 ± 36%      +1.8        3.30 ± 26%  perf-profile.children.cycles-pp.asm_sysvec_apic_timer_interrupt
>       0.96 ± 61%      +2.0        3.00 ± 32%  perf-profile.children.cycles-pp.start_secondary
>       1.10 ± 60%      +2.1        3.20 ± 42%  perf-profile.children.cycles-pp.handle_internal_command
>       1.10 ± 60%      +2.1        3.20 ± 42%  perf-profile.children.cycles-pp.main
>       1.10 ± 60%      +2.1        3.20 ± 42%  perf-profile.children.cycles-pp.run_builtin
>       0.86 ± 64%      +2.2        3.09 ± 33%  perf-profile.children.cycles-pp.cpuidle_enter_state
>       0.86 ± 64%      +2.2        3.10 ± 33%  perf-profile.children.cycles-pp.cpuidle_enter
>       0.91 ± 62%      +2.4        3.32 ± 33%  perf-profile.children.cycles-pp.cpuidle_idle_call
>       1.49 ± 36%      +3.2        4.70 ± 34%  perf-profile.children.cycles-pp.open_last_lookups
>       1.08 ± 61%      +3.3        4.33 ± 37%  perf-profile.children.cycles-pp.do_idle
>       1.08 ± 61%      +3.3        4.33 ± 37%  perf-profile.children.cycles-pp.common_startup_64
>       1.08 ± 61%      +3.3        4.33 ± 37%  perf-profile.children.cycles-pp.cpu_startup_entry
>       0.12 ±137%      +3.7        3.78 ±128%  perf-profile.children.cycles-pp.delay_tsc
>       0.29 ± 87%      +6.2        6.45 ±104%  perf-profile.children.cycles-pp.io_serial_in
>       0.42 ± 96%      +9.9       10.30 ±112%  perf-profile.children.cycles-pp.wait_for_lsr
>       0.46 ± 99%     +11.1       11.60 ±114%  perf-profile.children.cycles-pp.serial8250_console_write
>       0.42 ±118%     +11.4       11.81 ±118%  perf-profile.children.cycles-pp.memcpy_toio
>       0.42 ±119%     +11.4       11.86 ±118%  perf-profile.children.cycles-pp.ast_primary_plane_helper_atomic_update
>       0.42 ±119%     +11.4       11.86 ±118%  perf-profile.children.cycles-pp.drm_fb_memcpy
>       0.42 ±119%     +11.5       11.89 ±118%  perf-profile.children.cycles-pp.ast_mode_config_helper_atomic_commit_tail
>       0.42 ±119%     +11.5       11.89 ±118%  perf-profile.children.cycles-pp.drm_atomic_helper_commit_tail
>       0.42 ±118%     +11.5       11.89 ±118%  perf-profile.children.cycles-pp.drm_atomic_helper_commit
>       0.42 ±119%     +11.5       11.89 ±118%  perf-profile.children.cycles-pp.commit_tail
>       0.42 ±118%     +11.5       11.90 ±118%  perf-profile.children.cycles-pp.drm_atomic_commit
>       0.42 ±119%     +11.5       11.91 ±118%  perf-profile.children.cycles-pp.drm_atomic_helper_dirtyfb
>       0.42 ±119%     +11.5       11.91 ±118%  perf-profile.children.cycles-pp.drm_fbdev_shmem_helper_fb_dirty
>       0.42 ±119%     +11.5       11.91 ±118%  perf-profile.children.cycles-pp.drm_fb_helper_damage_work
>       0.59 ± 86%     +11.6       12.21 ±115%  perf-profile.children.cycles-pp.worker_thread
>       0.54 ± 92%     +11.6       12.17 ±115%  perf-profile.children.cycles-pp.process_one_work
>       0.79 ± 64%     +11.6       12.44 ±112%  perf-profile.children.cycles-pp.kthread
>       0.79 ± 64%     +11.6       12.44 ±112%  perf-profile.children.cycles-pp.ret_from_fork
>       0.79 ± 64%     +11.6       12.44 ±112%  perf-profile.children.cycles-pp.ret_from_fork_asm
>       1.14 ± 71%     +11.7       12.83 ±109%  perf-profile.children.cycles-pp.ksys_write
>       1.10 ± 71%     +11.7       12.83 ±109%  perf-profile.children.cycles-pp.vfs_write
>       0.49 ±100%     +11.9       12.35 ±114%  perf-profile.children.cycles-pp.console_flush_all
>       0.49 ±100%     +11.9       12.35 ±114%  perf-profile.children.cycles-pp.console_unlock
>       0.50 ± 98%     +11.9       12.45 ±114%  perf-profile.children.cycles-pp.vprintk_emit
>      34.91 ± 66%     -34.8        0.06 ±141%  perf-profile.self.cycles-pp.native_queued_spin_lock_slowpath
>      14.53 ± 70%     -13.0        1.57 ± 59%  perf-profile.self.cycles-pp.down_read
>       9.15 ± 66%      -7.6        1.54 ± 51%  perf-profile.self.cycles-pp.up_read
>       2.59 ± 33%      -1.5        1.11 ± 60%  perf-profile.self.cycles-pp.lockref_put_return
>       1.04 ± 27%      -0.6        0.41 ± 70%  perf-profile.self.cycles-pp.lockref_get_not_dead
>       0.16 ± 44%      -0.1        0.04 ± 72%  perf-profile.self.cycles-pp.mutex_spin_on_owner
>       0.02 ±142%      +0.1        0.11 ± 27%  perf-profile.self.cycles-pp.obj_cgroup_charge_account
>       0.01 ±223%      +0.1        0.10 ± 38%  perf-profile.self.cycles-pp.__kernfs_iattrs
>       0.00            +0.1        0.10 ± 43%  perf-profile.self.cycles-pp._nohz_idle_balance
>       0.07 ± 21%      +0.1        0.17 ± 10%  perf-profile.self.cycles-pp.dput
>       0.05 ± 85%      +0.1        0.15 ± 21%  perf-profile.self.cycles-pp.kernfs_iop_permission
>       0.08 ± 23%      +0.1        0.19 ± 25%  perf-profile.self.cycles-pp.native_sched_clock
>       0.06 ± 63%      +0.1        0.17 ± 48%  perf-profile.self.cycles-pp.strcmp
>       0.10 ± 51%      +0.1        0.22 ± 30%  perf-profile.self.cycles-pp.build_detached_freelist
>       0.05 ± 74%      +0.1        0.17 ± 40%  perf-profile.self.cycles-pp.__kmalloc_cache_noprof
>       0.06 ± 74%      +0.1        0.20 ± 50%  perf-profile.self.cycles-pp._copy_to_user
>       0.00            +0.1        0.14 ± 49%  perf-profile.self.cycles-pp.idle_cpu
>       0.01 ±223%      +0.1        0.16 ± 50%  perf-profile.self.cycles-pp.d_same_name
>       0.05 ± 76%      +0.2        0.21 ± 53%  perf-profile.self.cycles-pp.get_state_synchronize_rcu_full
>       0.10 ± 23%      +0.2        0.27 ± 31%  perf-profile.self.cycles-pp.rcu_all_qs
>       0.06 ± 75%      +0.2        0.25 ± 35%  perf-profile.self.cycles-pp.strlen
>       0.04 ±104%      +0.2        0.24 ± 42%  perf-profile.self.cycles-pp.update_sg_lb_stats
>       0.08 ± 53%      +0.2        0.31 ± 30%  perf-profile.self.cycles-pp.mas_empty_area_rev
>       0.05 ±103%      +0.2        0.30 ± 38%  perf-profile.self.cycles-pp.shmem_write_end
>       0.14 ± 26%      +0.3        0.40 ± 42%  perf-profile.self.cycles-pp.step_into
>       0.14 ± 38%      +0.3        0.40 ± 32%  perf-profile.self.cycles-pp.filldir64
>       0.09 ± 47%      +0.3        0.36 ± 30%  perf-profile.self.cycles-pp._raw_spin_lock_irqsave
>       0.25 ± 25%      +0.3        0.52 ± 31%  perf-profile.self.cycles-pp.native_flush_tlb_one_user
>       0.06 ± 74%      +0.3        0.37 ± 46%  perf-profile.self.cycles-pp.kernfs_dir_pos
>       0.16 ± 57%      +0.4        0.56 ± 50%  perf-profile.self.cycles-pp.kernfs_fop_readdir
>       0.14 ± 65%      +0.5        0.62 ± 28%  perf-profile.self.cycles-pp.kernfs_dop_revalidate
>       0.16 ± 44%      +0.6        0.81 ± 43%  perf-profile.self.cycles-pp.rb_next
>       0.36 ± 57%      +0.7        1.02 ± 22%  perf-profile.self.cycles-pp.copy_folio_from_iter_atomic
>       0.15 ± 38%      +0.7        0.82 ± 43%  perf-profile.self.cycles-pp.may_open
>       0.33 ± 37%      +0.9        1.24 ± 36%  perf-profile.self.cycles-pp.do_dentry_open
>       0.43 ± 66%      +1.1        1.49 ± 33%  perf-profile.self.cycles-pp.intel_idle
>       0.19 ± 62%      +1.4        1.58 ± 30%  perf-profile.self.cycles-pp.errseq_sample
>       0.32 ± 65%      +1.6        1.92 ± 37%  perf-profile.self.cycles-pp.generic_fillattr
>       0.40 ± 31%      +2.4        2.82 ± 34%  perf-profile.self.cycles-pp.__d_lookup
>       0.12 ±137%      +3.7        3.78 ±128%  perf-profile.self.cycles-pp.delay_tsc
>       0.29 ± 87%      +6.2        6.45 ±104%  perf-profile.self.cycles-pp.io_serial_in
>       0.39 ±118%     +10.8       11.20 ±120%  perf-profile.self.cycles-pp.memcpy_toio
> 
> 
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> 


