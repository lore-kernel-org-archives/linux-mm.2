Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0582C606A328
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=U0pFtW0S
Received: by kanga.kvack.org (Postfix)
	id 21A906B0630; Wed, 21 Oct 2026 02:16:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D02E6B0632; Wed, 21 Oct 2026 02:16:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D0816B0633; Wed, 21 Oct 2026 02:16:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DED176B0630
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:16:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D494780451
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:16:05 +0000 (UTC)
X-FDA: 85345623090.02.4698E42
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf31.hostedemail.com (Postfix) with ESMTP id F0E1120005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:16:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U0pFtW0S;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563364;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwxXxk3IG/0jN67Jp1dQn6a0zeAIazOAnBJBfQ5pj78=;
	b=CggG7uw6XA27YY3rWpW/yiJo5H9fMpG/FngKaJsKixTT9wtipTkmcSMttAMbAoNUinMHvu
	39QHhjslV37z1xO3ar/Iv6dje75tUw3GqYivYpMvLqFNeoZQvE2xZtAxH0HydnLE1wJlUs
	5FjTRooD31KYazfN+32sAb0o0JLnJoQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563364;
	b=ulw+nzmOlJKEJ1bzDOkgmaY8DvezHB0i/MGkrjUzddIXZQL6ogQow7a6bKTdvUDBepdh/7
	x7b7o7AfW/AeFPH4mAZFczudoXt29VM5+gT5sGU5vNnzthGZJX+iLE1UuJq0+X0/4rDNq2
	07LXjOit4n85T/+wLIb/6jXaejW3Q0w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U0pFtW0S;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792563358; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=NwxXxk3IG/0jN67Jp1dQn6a0zeAIazOAnBJBfQ5pj78=;
	b=U0pFtW0Sui7thy/yL1k4jld9obWiQV8yq9WmIOr0c7wpIYrKNDSRLNFBO+lekbvaaJWu7xq/gfpwb/e63M4AHod7OecW5+8SeVcfnJkFqAlj4iwUXEdTs/q2UH8g7WyxpjFOrVa8rq/AAOzvaFUdSLd40elDYUWJxr/mWCcuHQU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XDFS7Kq_1792563356;
Received: from 30.74.144.135(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDFS7Kq_1792563356 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 21 Oct 2026 14:15:57 +0800
Message-ID: <214aa9dd-33c2-4877-8a2d-18bf677d1426@linux.alibaba.com>
Date: Wed, 21 Oct 2026 14:15:55 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref
 with memcg disabled on cmdline
To: Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
 akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: david@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, ljs@kernel.org, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, yuzhao@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apais@microsoft.com,
 rlmenge@gmail.com, stable@vger.kernel.org,
 Hardik Garg <hargar@linux.microsoft.com>
References: <20261017050928.128582-1-sidchintamaneni@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261017050928.128582-1-sidchintamaneni@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F0E1120005
X-Stat-Signature: ri3teszpr65ntny41rgmdky5pcf3rmba
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792563361-813455
X-HE-Meta: U2FsdGVkX1+EFSDo+2k2pkiHHCTnJKHHC7yu+oVjZVmsxtB4mmLlr8LIz5WVxLheCypfy512bNGgblMGW1JxUIDjYSBM97GmBz4iz8eEM8QwTSJWZFCNJLbnIfuwmUfO27PqNPPlXliYlc1nclbtxA0/wi1/VDsVuLRAMlMdwzd0yRAnEOsx+ONR/RO+YYGSIrSHCBGi6qminRMLAdpwi/FwsdTC28GM54Pv0r2Hvge8iucjQ3NJivCTnannRiR5J8B+BCoi2x1uK88EpkgQs5iI057i9LSGf723zxJ42hCLk6xYKXDhkrZDlVFVXcIGUn9xQnGiDqsRl2B9s1oT2lpciKB88oB40oLSAlL5nx0Q0kcelhlQSF3v4kYaexjpJnqhl6F1+TwZLnxzKE1ZBhQ71xJ/ItdP2vjiW00qAysqUKpq7qql6uy09Dq9Xtq6Kw0V1ToH013SvQhvN3Cfy6ipOPprj3fdWfUl0TYbzTypx1bpaJzwtwOir6sN67uGkpeyVt7SMXzUMefgDi2W72O95pKuOBllNAEuQ/NR4dBQQJ0ZveZClmoajRx7sKoEdw5TJXcHO6S/RCld6UHqiebyBpICISQuQpSVltTGBfvyvC2IG6Hi09S8DdlnjJKV5H/CxOkhd1eNMVY4rLyjSbuk0v+j6IvD/I0O/mUK3vcHUvl+CM2nvhtYKXVglJerE9+1yk3FgGOwBQuyOIIzZyYrdkDUA3skVEdsp46d1zTqWZP+6Zi/0MAduThmjdXAzkne8Gh3OQKdPqRGk/aNGNSTozaHRgFi53CIeQOhFx5Rix6KBxDCOX59szDgvt+g5jrP47jT/4rQwI1q7RLi0s5mp8zeLkVyHJSlXNSnv1XVBTHv/UKIXs5ZEq2If2F99/E3/iBsyz/f153bLpiitT8Bqx/eqU7GkyB5L6sKKBUtMf3Ui1NsLyZX0j4K2CzgzgDS4cGhTATxxUW5361
 xVXuvNoo
 WianZzV3Q1eDGx2CWFPDkFA5bTQqA85JPOdwTPDdDD34efKMYb6WVgwZSjYP08LLnhFsNKdf+xVa3CUwYn3MQzLPRVSagSBVNMs40TJxYOhnZfBzc7v2nLW04ZJGj0nh1DuSwr2vB7LyJRVmhnpOioHxdzEOesLdcmvqcSp6Pfe63e15cXttEb9J0o5luRuZNNHxP4U/05XAhNYLjywQTB+qoT1lr6XM7+ijreW1vGl56smcgGXQM2ctHnceG4QexCFBA4JLzUeu5pmVczHoHiAMUh612YQrFzPM43HxMl2m42/S7z3VELdXUHnASEvCeRcKuBGl7mWTmM4MTT0m00R7cLGcoEr2jaDaa+EPlD9SI5AVNfTSMVdTKqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/17/26 1:09 PM, Siddharth Chintamaneni wrote:
> When CONFIG_MEMCG=y, lruvec_pgdat() returns lruvec->pgdat, which for the
> per-node pgdat->__lruvec is left NULL by lruvec_init() and only filled in
> lazily by mem_cgroup_lruvec(). Normally that happens early, e.g. on the
> first folio_add_lru().
> 
> With cgroup_disable=memory, lru_gen_shrink_node() passes &pgdat->__lruvec
> directly to shrink_one(). If direct reclaim runs before anything has
> called mem_cgroup_lruvec() for the node, which can happen during early
> boot under memory pressure (e.g. a kdump kernel), get_swappiness() ends
> up dereferencing a NULL pgdat:
> 
>    Unable to handle kernel NULL pointer dereference at virtual address 0000000000005040
>    pc : get_swappiness+0x68/0xb0
>    lr : try_to_shrink_lruvec+0x54/0x2c0
>    Call trace:
>     get_swappiness+0x68/0xb0 (P)
>     try_to_shrink_lruvec+0x54/0x2c0
>     shrink_one+0x8c/0x240
>     shrink_node+0xc6c/0xe08
>     do_try_to_free_pages+0xdc/0x570
>     try_to_free_pages+0x124/0x278
>     __alloc_frozen_pages_noprof+0x6e8/0xf78
>     alloc_pages_mpol+0xc4/0x1c0
>     alloc_frozen_pages_noprof+0x54/0xe8
>     alloc_pages_noprof+0x1c/0x40
>     atomic_pool_expand+0x98/0x300
>     __dma_atomic_pool_init+0x58/0xd8
>     dma_atomic_pool_init+0x154/0x170
>     do_one_initcall+0x64/0x350
>     kernel_init_freeable+0x214/0x430
>     kernel_init+0x2c/0x208
>     ret_from_fork+0x10/0x20
> 
> The classic LRU path and MGLRU before per-node lru_gen_folio lists
> obtained the lruvec through mem_cgroup_lruvec(), which sets
> lruvec->pgdat.
> 
> The above was hit on an arm64 kdump kernel (6.18-based) booted with
> cgroup_disable=memory nr_cpus=4. It also reproduces on mainline on an
> arm64 VM with CONFIG_ARM64_64K_PAGES=y, CONFIG_MEMCG=y,
> CONFIG_LRU_GEN_ENABLED=y and:
> 
>    mem=160M nr_cpus=4 coherent_pool=512M cgroup_disable=memory
> 
> These options only serve to force direct reclaim early in boot; with
> 160M the boot eventually ends in OOM regardless. On mainline the first
> LRU reclaim happens while unpacking the initramfs, and faults the same
> way:
> 
>    Unable to handle kernel NULL pointer dereference at virtual address 0000000000005040
>    pc : get_swappiness+0xd4/0x150
>    Call trace:
>     get_swappiness+0xd4/0x150 (P)
>     try_to_shrink_lruvec+0x44/0x2b8
>     shrink_one+0x80/0x1a0
>     shrink_node+0xd98/0xea8
>     do_try_to_free_pages+0xf4/0x4b0
>     try_to_free_pages+0x110/0x360
>     __alloc_frozen_pages_noprof+0x8b0/0x1718
>     ...
>     __filemap_get_folio_mpol+0x2ac/0x548
>     simple_write_begin+0x44/0xf8
>     page_symlink+0x178/0x198
>     ...
>     do_populate_rootfs+0x13c/0x200
> 
> Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
> Cc: stable@vger.kernel.org # 6.3+
> Assisted-by: LLM
> Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
> Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
> ---

Good catch. LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

