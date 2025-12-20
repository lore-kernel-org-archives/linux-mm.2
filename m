Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEAC6E668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5636B00B1; Fri, 19 Dec 2025 23:29:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16BA86B00B2; Fri, 19 Dec 2025 23:29:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F32876B00B3; Fri, 19 Dec 2025 23:29:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E38526B00B1
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:29:47 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A947B8AEC6
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:29:47 +0000 (UTC)
X-FDA: 84238571214.18.B788F7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 14F1B8000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:29:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B46/qmCG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766204986; a=rsa-sha256;
	cv=none;
	b=0YmugmiOL79VmNEBNaO33y8lr/l1NjKGABfvAovsPUGthTAtfKSdF1qwol8HHLt+osxn21
	9a9buDSUNFummbeNuZlVwc9BLGMDeK4/b5D2Bdi9iSNa2LJdrLVib67zMEfpGsc6ung2BG
	pTZHMaMSwgwuhThR7GJnilOdh35xDak=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="B46/qmCG";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766204986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4XDhgwwbC3cRnJIjcX/AntjoNCuEa2MpX3QyJCF5Vk=;
	b=Q+KGcPUZkUTPwbQgd7FVpSyNwEqc0o+0a/38s/6E1XTG+HqJI9op0L/byp9z8sr6A6uF41
	UCvA1cavk0W9i4EPIcM1bxZNptx9JfDMpxEvrL3Xtg+Hv8rf7to2ekVbBvMRSiIOQS2Eao
	Dfcb139wnk4Yi3nOqYyucLcrQoqyKOA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12F33444B9;
	Sat, 20 Dec 2025 04:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA7B5C116C6;
	Sat, 20 Dec 2025 04:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766204984;
	bh=Z9JOLErhQJXlltHr9P9A8oYRxRDSKmJ1+qQX8KwZG7Y=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
	b=B46/qmCGfQTJUTcuLEOwXHSbfxWtorMZkB6aFjFPVkPs++W+Iya8ZoagzJPWtLTf+
	 prRuo7ju/Y0Z7ikQYxRUWPOgig2YWrhuYvWyFSqJbJ9BtLcju/eXCEe5h02ptMa9MY
	 cuP1MRFUZho0vUSt0Jc0HgQZ9T6bklJUjutOPpxqQ32bZ8mliCtSDWmKQSCtjag/aO
	 7N0GY6kfq55xqf19DJHXByTe9ePh1KamaXNZdcdFQFhzJsLg3NA0DhDjbSb7nba0FR
	 0ENAkZZoz3RQuhEJKu/37q7hspwR8rHcNqkt91uo8miODiJULioX/OiRzzPZrskT/2
	 7t7zDGZMh23lA==
Content-Type: multipart/mixed; boundary="===============8958172171642077659=="
MIME-Version: 1.0
Message-Id: <8f23848b8ac657b4b4a2da04da242039c59e9ad9826a8d5fa0f5aee55acfecc9@mail.kernel.org>
In-Reply-To: <20251220041250.372179-6-roman.gushchin@linux.dev>
References: <20251220041250.372179-6-roman.gushchin@linux.dev>
Subject: Re: [PATCH bpf-next v2 5/7] mm: introduce BPF kfunc to access memory events
From: bot+bpf-ci@kernel.org
To: roman.gushchin@linux.dev,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kernel@vger.kernel.org
Cc: inwardvessel@gmail.com,ast@kernel.org,daniel@iogearbox.net,shakeel.butt@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,roman.gushchin@linux.dev,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sat, 20 Dec 2025 04:29:44 +0000 (UTC)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 14F1B8000B
X-Stat-Signature: o146j67k7oonub88gbmpugiu3koxgua4
X-Rspam-User: 
X-HE-Tag: 1766204985-64791
X-HE-Meta: U2FsdGVkX18UAHOud9uGkzNBl9kZ/ao+sTScs22CveaPW46JpaY+U7o24Bx9Uc9db8zQp0OCPrJarDxSddDqQDyvE9YsOunmusYXOamz+39y1dL7peAVzeOs5YearC338/TSH9wPEQ9FuA0tRe2Ql6gqyVAz7uafIREMNvETTBk/a5FHZ2xL+xnXFCfpcYgdPaGtDcCAfSQSldm3Z0wIOrzwopUArZaovLG48vBRgTtzqfLWX9MtnWJsMg63ZbsU3YuFQ0DHIBToU0MEvi+jtO+MA9hETms516yXQ8VCEH+FeGLaYnmb5uv2J7mzAEHiDWrsJ5ZWMKlD1vS4i15hzMxYb/yzXbIufzgo1xTBQjYFcA0sHcSrfRYOLwfr9UHUN57VeCaOpSZGaqwkp6rxYmNNeu9I/N5TzZ5RybFzFrIsZiJtcCxPI4Juw9rm7LHAW1yNDimSaRFp6Us2qWkYQ5gLr2nK48aHUcIzUC1s0xurroMhcCi6uLvCpzccghfw0xXqlbqcgsPSTwaaK5VPcLmcnTWQKRBBR8JERYLbsmL5S+jdCw9LkXsI4cXgKFvZjjge+MccVD3nZ0ZD4ReGK13mqHv+sX6Air8Ku2Uv0mMEbflKjaGSwNBBIe7P8LLtF7JoAmA/v9BPvNsE9iAgicdyQDEwI5lda634UnC0x32jqElWIXRLjlo9zlr2qhdgk/PhvmvqJpmHA7jxae9GfiJmw2Qx5QvJIsD8C2W5PrsE/zR+qmlWbU7LNB3/4i8Zvt64RHxIgFhoMWmct4qBJNdYD6ZvwJjvveFRCXsQyZpbIqY8fYU5gYp1RYSCb9OLX0+cdcdk7W+LcllFOB5l3BKU/+YCzaelbOPHLvGpgjsD5SxdmQ5HL5wVkunxH9XDlBTK5rreVQUd5rVX7nVvhfGcq/kTatqjW0V0Hl5/TJuQBbIVbRls11kKX/OVfs+j7YEH4pffEvk/r6eacW8
 vhfbT+6v
 HrKsqUVjLn1O4g1herJUlv+gBqtmnAQKUxV3Hnm/zG/wEta9zT0e+zG01l/nF1CFkjjznMf37jrxN/2X+gzV63WshZ4X39vfQmK/TyEsIHUVGJ5zo+7LZBKaJtH2LhrNbmvIlrVIFek5zQwU1DZb/zotehFTog83HkpW+/9DvB3FzNBlMlmdEQ9/TbL/6RnQoa7/FNYq43ae9y/lTz5ArleP0ANMghHkFAb6PXgTkwrxnrIVAA41IcSXJ62iwkj0s36YNkWqgEgS/AVznC+YzQQ7i9O6J1CTxJRkOXIz7Ktan4jdq237nMNNHeO+O2bx0ldAFfGNvH9SPVmcAIarCabqlLjGxtt+T+JZcxNls8+oJs9RxzxrhCWD/21mNHLY0vRz2cOxZCyuvKOqAYbv+h8QNwpvb+2Oky65CYkRc813KbNE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8958172171642077659==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index d84fe6f3ed43..858eb43766ce 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -103,6 +103,22 @@ __bpf_kfunc unsigned long bpf_mem_cgroup_usage(struct mem_cgroup *memcg)
>  	return mem_cgroup_usage(memcg, false) * PAGE_SIZE;
>  }
>
> +/**
> + * bpf_mem_cgroup_memory_events - Read memory cgroup's memory event value
> + * @memcg: memory cgroup
> + * @event: memory event id
> + *
> + * Returns current memory event count.
> + */
> +__bpf_kfunc unsigned long bpf_mem_cgroup_memory_events(struct mem_cgroup *memcg,
> +						enum memcg_memory_event event)
> +{
> +	if (event >= MEMCG_NR_MEMORY_EVENTS)
> +		return (unsigned long)-1;

Should this also check for negative values?  The enum type is typically
signed, so a BPF program passing a negative event value would pass this
check but cause an out-of-bounds read from memcg->memory_events[].

The similar bpf_mem_cgroup_page_state() in this same file uses:

    if (idx < 0 || idx >= MEMCG_NR_STAT)

which checks both bounds.  Could the check here be changed to:

    if (event < 0 || event >= MEMCG_NR_MEMORY_EVENTS)

to match that pattern?

> +
> +	return atomic_long_read(&memcg->memory_events[event]);
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/20389033088

--===============8958172171642077659==--

