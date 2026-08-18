Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDE4C5DF80
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 09:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23BF06B0198; Tue, 18 Aug 2026 05:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2115F6B024B; Tue, 18 Aug 2026 05:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14E876B024C; Tue, 18 Aug 2026 05:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E5F496B0198
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:26:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 869441C193E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:26:40 +0000 (UTC)
X-FDA: 85113860160.21.7B800CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 07169120003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 09:26:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWdtEYnO;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787045199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWecLJvO/FetFb4ebnNXlE1tjrKht5ApopqY9KDaHKs=;
	b=FSBD6NsQyjBw446Gq0nLDJGlxvaDNrKnSura5PnQjrlEkhImkoArvgOK0NcySwxielRNy/
	BMrCFxhL/yX5JrpXNkAQet5/JejPPfBCMsEKMOly+ll888Azb4JtzJV4CUCgY7HvLgIloC
	IcHEjCFOGpcLRtY1qkdQZuWQ3Jq3HzA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jWdtEYnO;
	spf=pass (imf29.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787045199;
	b=r3EqXsX5G3S5w/3ix/l7uVdNb22MtHVk3crcNaHM0X0Ux/c72DMnmPaStXj4+kP11TyTnr
	pZnfURpkMc9hzhkHBYTLcMc4mg6g2v3rQgSAHiaBDT2XlydDLvfouUSWZCdqEiPvoOIZwg
	5Wr4PAQpCewP4zTI1dQSbcWktxuEiEk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 69A21601E0;
	Tue, 18 Aug 2026 09:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC171F00A3A;
	Tue, 18 Aug 2026 09:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787045198;
	bh=fWecLJvO/FetFb4ebnNXlE1tjrKht5ApopqY9KDaHKs=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=jWdtEYnOyj7sUuIkKU4Y4954kyhF1FeeJceoNHWdmBIB/8VEeMnxkT7vzIDwS1OsU
	 9uuoEcZiK9L8rK8iJ1rlLP+y3AOkLaJfzzCchwEqV8jWUUDZH75v1GQDf6IghnezK3
	 QjPRoZdLSKAAJSuMhVKLJvHhWOldNVM6cPorc2tq4U9XWWwc5SA1WzQcT8xiLjqhb4
	 i6Ck99zOY/+fHlVOv5rFDE6ZLECCpf//L50xdNahxHb0XMO7cNHjOx6cu15t0IJ/15
	 7QKr2KT/hDMp79WnlpEhTj+YMhGI/osyrTLJip54uhtD0oBmDB7OBuyvB6ovjviAWr
	 UK05w0AAkfHjw==
Content-Type: multipart/mixed; boundary="===============9099388685773276073=="
MIME-Version: 1.0
Message-Id: <30f7c22f4a1db2da698d46d0834b7b6de07d0eb121f9e5a76cd7b1c892c388f9@mail.kernel.org>
In-Reply-To: <ea02caf3118cfc34cb9845f75ac655abf04b7b9f.1787040082.git.zhuhui@kylinos.cn>
References: <ea02caf3118cfc34cb9845f75ac655abf04b7b9f.1787040082.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v2 1/2] mm/bpf: Add bpf_proactive_reclaim kfuncs
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Tue, 18 Aug 2026 09:26:37 +0000 (UTC)
X-Stat-Signature: mg8arkdje4fm4oqfbi53m8xkcfxq7jpo
X-Rspamd-Queue-Id: 07169120003
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787045198-625909
X-HE-Meta: U2FsdGVkX18Uo3idt+T1gK6UociVLI+2Zt+DFsgEVwXhbq4RiONEZmRJp+DbPYIbEDCtwLGmLS26pSwNL2fEKLuG/I7mGJm4aH5oAQrS5TUDse+ps0kgHVjTg/ts4p3d724uhgXKxe5149JHWox59w5/EM/nYkAT7pr3t37oIpiWswZsvUek19voH9TaGzDtTdLwg/POPks+XA2sdR/I/dqWUJRAKSoWifz5vhjKk2udtg0/Y9Hv0JxBDN/lTZ1owjfxFUWXXKgNKdAAtoVfsNzzyHwLk8VlzL3usxxabv7Jnsy+u3vB7XopdoyLqzDokz3X1tmp3pwhs8pUS7FVUyQdCEbmSAeAOozCszJ2iD5ii6irkPA+5b3G6TfniWa2Hn1GLZo98KkBbdvEpngF4RmfvOiwb5lu1VIpcxedKP6vZ8laOjSC11EBmIyeywfum96WqEgpZG54Rx6I0V9cgeiU4yBbmHwefMQ8rqZtoHvgmekWPQ9rgM7J5xxhPtymZvNFHw62zsvMrOUzyLTY6+FK2QccNjhpPJrV0acYg2nspw14jfPca1+2K17yy5lzINZhHZrUoRRVQdN/f3v+NmcdCIYren805kyT5WuNzxNEzhw/ZfqcvFVFlUISe0Rj7FCrfaqWXnxvWsMt/WRN2TyTWPMES7v5llfl9B2pissVNvCyhlYB/uveSbO+t7wW4hUwGF/FGDzyUft7JsAnzUNtjGaX0wX4TLxqFiR0/3fspN9nlTRiva4OC3XMSjKHUJq7e4Qy0LOfbs6c6hyrAmTzC6Q2UURwDfPITIhpr85GzPo86wmuUcnxr0wQN2WF8ZA3W0qTiikRWb4S2eZhySkVO3YipaPnvDdzBqE/Gj6/CdNfTkqxeZ4k+PYeBvPBsUvGjH7HRpOqXWrfkECaT+TX8dgT5KqURx5BYhx4wIgDyCwHKD3iUHgpZhbHVz9993YDVIAx6f9gPmSRQ6n
 AL0IibxP
 UEBzBZReNmyYMMlJeigDeW9i5Ya8j6zFUMtsky4xdqUGpCsJh7dmfBzxzvxAkN/3hflpyVbL37eAze3fg9t6pzYxG3LSc7rFoc/n/NPMuienY4ahp0G5rjob5OJ2xsK7KvS8Kj6OpPNjZ2L3HhX1okgm+ttCqGg1heP9UCeKjOM3GBMZcNNhXbBONfBLsKXAQ2YgxyZfY0Jzd2YE8xAQ4YSdGHAHfAg9Sw6Fmc6WcjqC0X+3uUf/wgEbeLH6LLHocpXVyBOCg+a9n3kdJm/MhY+2YM/xnEVtWk11Q5/yOm8Dw618MHhaqtN3859RXyi1ixwERpdnqy3Y52JgbqDhCcFK7zVrkM815eADs4ftfw2rbZ2RO0+2Cl5+auyCnTtXukFwDNzojnKnru/IHdiH2psBSYHOYfwL/K8JRsf6FKE1MwYrKKMe9R0sJM+0hPVy47dHh9tLew18WFdjyY3mZ4Zh73uBB7nDDk9v2Y6wAVbJe/oJrcLxTF6UYiq4dJkBxlK/RNzDCQHS+CEcH9JzgE7GEjqrA8fdrEzNm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============9099388685773276073==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..92272f9a5825 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> @@ -159,6 +160,97 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  	mem_cgroup_flush_stats(memcg);
>  }
>
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
> + *                         cgroup
> + * @memcg: the target memory cgroup to reclaim from
> + * @size:  the amount of memory to reclaim, in bytes
> + *
> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
> + * the memory.reclaim cgroup file: pages are reclaimed according to the
> + * cgroup's own swappiness setting and swap is allowed. Note that,
> + * unlike memory.reclaim, this does not retry until @size is reached;
> + * callers can invoke it again if needed.
> + *
> + * Return:
> + *   The number of pages actually reclaimed, or 0 if @size is smaller
> + *   than a page or the calling task is already in a reclaim/freeing
> + *   context (PF_MEMALLOC).
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> +						unsigned long size)
> +{
> +	unsigned long nr_pages = size / PAGE_SIZE;
> +
> +	if (!nr_pages || unlikely(bpf_in_reclaim_context()))
> +		return 0;
> +
> +	return try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
> +					    MEMCG_RECLAIM_MAY_SWAP |
> +					    MEMCG_RECLAIM_PROACTIVE, NULL);
> +}
> +
> +/**
> + * bpf_proactive_reclaim_swappiness - proactively reclaim memory from a
> + *                                    memory cgroup with an explicit
> + *                                    swappiness
> + * @memcg:      the target memory cgroup to reclaim from
> + * @size:       the amount of memory to reclaim, in bytes
> + * @swappiness: swappiness override for this reclaim pass
> + *
> + * Same as bpf_proactive_reclaim(), except that the anon/file reclaim
> + * balance is controlled by @swappiness instead of the cgroup's
> + * swappiness setting. Valid values are [MIN_SWAPPINESS, MAX_SWAPPINESS]
> + * and SWAPPINESS_ANON_ONLY, which restricts reclaim to anon folios.
> + *
> + * Return:
> + *   The number of pages actually reclaimed, or 0 if @size is smaller
> + *   than a page, @swappiness is out of range, or the calling task is
> + *   already in a reclaim/freeing context (PF_MEMALLOC).
> + */
> +__bpf_kfunc unsigned long
> +bpf_proactive_reclaim_swappiness(struct mem_cgroup *memcg, unsigned long size,
> +				 int swappiness)
> +{
> +	unsigned long nr_pages = size / PAGE_SIZE;
> +
> +	if (!nr_pages || swappiness < MIN_SWAPPINESS ||
> +	    swappiness > SWAPPINESS_ANON_ONLY ||
> +	    unlikely(bpf_in_reclaim_context()))
> +		return 0;
> +
> +	return try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
> +					    MEMCG_RECLAIM_MAY_SWAP |
> +					    MEMCG_RECLAIM_PROACTIVE,
> +					    &swappiness);
> +}

This isn't a bug, but these two kfuncs are nearly identical apart from the
swappiness range check and passing '&swappiness' vs 'NULL' to
try_to_free_mem_cgroup_pages(). Both compute 'nr_pages = size /
PAGE_SIZE', both apply the same '!nr_pages ||
unlikely(bpf_in_reclaim_context())' guard, and both use identical
'GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP | MEMCG_RECLAIM_PROACTIVE' arguments.

Would a shared static helper taking an 'int *swappiness' parameter (the
shape try_to_free_mem_cgroup_pages() already accepts) keep the guard logic
and reclaim flags in one place?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32118218829
--===============9099388685773276073==--

