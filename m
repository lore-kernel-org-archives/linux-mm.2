Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74187C5DF82
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 07:05:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6E96B008C; Thu, 20 Aug 2026 03:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A9A06B0095; Thu, 20 Aug 2026 03:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8266B008C; Thu, 20 Aug 2026 03:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 110B76B0092
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:05:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B3741406D1
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:05:25 +0000 (UTC)
X-FDA: 85120761810.06.0EA2777
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 02B61140005
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 07:05:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hn/7B948";
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787209524;
	b=zDp63Y4uqZWqUwUYPps1hwz9DHaH/Oexl7Bz6GgpnCRrxyhV8I+TcS/i0pXfHbGe5DqOOT
	zJ93TH6hai4SUlWGsu34jV3roAq+Ryb1kgG74h8W2eao+BxjbLQuKl9ng9pUg+PnKWKJvu
	gcJ2bHqzRjm04UVV5eKjtjwLj6dAsqE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hn/7B948";
	spf=pass (imf09.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787209524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=91sdNajum8+aHRdx8jSsE/sNi3ZgWiCvITJ6xT+pUkY=;
	b=ZLhMEMh4E0eqzIMZX61shWKWmX2n6DMXOL5ejYnWZ92PH2h0sKt0tQhTG4t1L68QKbhGzb
	ZRQdvZhGpBKxLtraoCZ1Hn4LnDGe3cyHCxnDku4gI7WQeNFbl0SnoTfZrk/aO5W3tZyLzw
	xdzh+blin0fzUzlmA2VFiJ6Rt07aULo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 560B743643;
	Thu, 20 Aug 2026 07:05:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB9F1F00A3A;
	Thu, 20 Aug 2026 07:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787209523;
	bh=91sdNajum8+aHRdx8jSsE/sNi3ZgWiCvITJ6xT+pUkY=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=hn/7B9481atS/2m0mGXcx/BMNBtavJOIOI1WMUGEERHgo3PpV5incPH8Adbtl8UhP
	 y39un0XYSFATY8cdJisJqJIs8i18WTNoYRzs7BpwC3Sn+eT7l7c4JpZt9sicUeQ90b
	 WfWv0dhLUne06st/tu4eszRIWk+2Kk79+CLElwnsa5iWyHl0M57fLkRJmNkmbob+fv
	 8Iea5lj34OLvkIj0bK46rqh4I+/ygEXZXc9x3/voreZqM2s4JPbwiy5DCTWsMRZJKt
	 yn+Al6ccbgXE3gc4BX/JQjmS8JbTjsN091NHLimBxBHgnv0lgj4kCVT2LAUxlibg9U
	 /1374apcvbkew==
Content-Type: multipart/mixed; boundary="===============8690568711721681409=="
MIME-Version: 1.0
Message-Id: <a86acfeb2792a1df00f1eb8d1a42a520e8b0b9fc4276ad4bd68d2154a5c8312c@mail.kernel.org>
In-Reply-To: <e9b2a34418919f5c3ee2b80bcb4f9d80ce6ec422.1787205002.git.zhuhui@kylinos.cn>
References: <e9b2a34418919f5c3ee2b80bcb4f9d80ce6ec422.1787205002.git.zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v4 1/2] mm/bpf: Add bpf_proactive_reclaim kfuncs
From: bot+bpf-ci@kernel.org
To: hui.zhu@linux.dev,roman.gushchin@linux.dev,inwardvessel@gmail.com,shakeel.butt@linux.dev,akpm@linux-foundation.org,andrii@kernel.org,eddyz87@gmail.com,ihor.solodrai@linux.dev,ast@kernel.org,daniel@iogearbox.net,memxor@gmail.com,martin.lau@linux.dev,song@kernel.org,yonghong.song@linux.dev,jolsa@kernel.org,emil@etsalapatis.com,shuah@kernel.org,baohua@kernel.org,geliang@kernel.org,linux-kernel@vger.kernel.org,bpf@vger.kernel.org,linux-mm@kvack.org,linux-kselftest@vger.kernel.org
Cc: zhuhui@kylinos.cn,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Thu, 20 Aug 2026 07:05:22 +0000 (UTC)
X-Rspamd-Queue-Id: 02B61140005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hadn5psw3jyohwufxp9b7ti1pxrimbr4
X-HE-Tag: 1787209523-601617
X-HE-Meta: U2FsdGVkX1/oh66PqRWCTXNfb/NJ3VgSO4ptYLugABWgvsyH9cpZfRoeE1OijTNHCV/9nFYp6Sb4hASs46edU7cZkDqvDq01fZpG0NYLFggNnjVIZj2WrJSJo0/pyFaui4n+WYbppapVhk81JGcjY4qzCaczNMw44kqQ82qTdqKIbDeTP8v5mcbpsqQWT2/Vu7sX6v1i1ZEn+J9CfoD1zEJGxmEaUk8e8KJEcDBYaSRrK33OA+wQjqn6b+FSq8q6NCw+ygiw4tHEagmQrRuzu/RB1tYkX6SViUfmg5/32YN175t4pVzOK6IbgPbZ/ddsc4/jkVt8NMGSX++TYdu9WamcjWXWb1g//8JINdzRJ5mKvCXBE4Y6ZD8mYd1ayMIKYN1cji9pj2rfPtFo8vXSZ8Dlv0lK6FspNj9ZvTqtYyqnQt1aVL8G9UYpSj5lzkxDAatdMgY9q1En1/UyRDjm8JocMmtrFGLk1JqWM62wWQz1hR+zVUWAgbLTrWNmhbhoSPP4w+y7a1PRiyYb6bhLG+k5uMHbQPpAS9ywp1K2eg5C9Y5maRNW6G1tJfsufhkGNFXYB/efAnnzABif2cs14K0Vz2SbhVdm1rdIF/h/hjMu/mhrIoDZ19td9rg6mSwCBFa6YmFj55RmRrZ3LU7aeS1t77QH7rsP0vEmnns7ppqAyR0CqLNVp9p3q4+diFalMKQh+xNVEtrIx7CKGmkB+2YR9+QfZwFYGTg9rrjNyOLcDMYn2cNNIqsD7muxFMmKUz9X/KqaU9XHevroxy5YqxjLyFvpt12i5Y5uwLdrRW+dXPstgIr0dz00So08+gG5+WSQtNiK9E2rRSFiJeze9QfEWvQt1Q8RycP6NP9Pgnv5NhhC1+/MuIz0YfnJ3s8j3Nv0VWi3jJYVNipnGs0O4IJ8aa9bfJ5S1+vZmycw1vPp1jMAZJCq2L5pG1O6CrFCjqkTk0P5aN9dj8adXn0
 Gj/BOR7y
 rT7GAdY1bk/kyepPCX5BFNCMteslrFtgvlzSpAdG2YxL62iIygUrOgftP5UZ1Bw8OSLOzLPtsQymUFDMCY3mO+repp9tUob/lAym2zLiB+DDWXxtbJMjiyU9kyJjGaqi/t5ovXRZ7UXWe6XsYStrAJjxLgrlAdDRQ5/RXgWZJhyug6vF8CEzfCWDK9ZvUbSndy3pcgM+R+LMqiZMYCzpJYaUryCm0XmxZFUYsaPJXWIgTVw7oW5ORfZuuBDGDbyyeW/vo3LDCIn1s2tbhR98gN3jws/83OEnDntnhmKm3MZ3q1R5aEyIaur94UK/8DdfEAg8VpaOQOwEpPKuJ6y9GoqRbAjFyqEv8O/fh+NYiDdn226yQ6NXF/Sz5hIi/xhRY18Ft8izXWHw8wMGvY+r8UJ0jjPebZiTasKSE3z4JOida25/8gy/QcjFEo6T27D39hQyFfsM/iDFfTIsQLEgjQdDjwqlFiQAgfAwxMuPDHK3HXBDNTm17XYrAswiz3T6j5kSmYoM0qEus5NoD24d0Q8jt3wmyoqF1Vfgp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============8690568711721681409==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..dc51868b3acf 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c

[ ... ]

> @@ -159,6 +160,120 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>  	mem_cgroup_flush_stats(memcg);
>  }
>
> +/*
> + * Shared implementation of the proactive reclaim kfuncs: performs one
> + * reclaim pass on @memcg with @nr_pages as the goal, allowing swap, and
> + * @swappiness as the anon/file balance override (NULL to follow the
> + * cgroup's own swappiness setting). Returns the reclaimed amount in
> + * bytes, keeping the byte-based unit of the kfuncs' @size argument.
> + */
> +static unsigned long
> +bpf_proactive_reclaim_pages(struct mem_cgroup *memcg, unsigned long nr_pages,
> +			    int *swappiness)

This isn't a bug, but would it be worth trimming the comment above
bpf_proactive_reclaim_pages() and de-duplicating the identical 'Return:'
paragraph that now appears in both kfunc kernel-docs, so the byte/page
unit conversion is documented in exactly one place?

> +{
> +	unsigned long nr_reclaimed;
> +
> +	if (!nr_pages || unlikely(bpf_in_reclaim_context()))
> +		return 0;
> +
> +	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
> +						    MEMCG_RECLAIM_MAY_SWAP |
> +						    MEMCG_RECLAIM_PROACTIVE,
> +						    swappiness);
> +
> +	return nr_reclaimed * PAGE_SIZE;
> +}
> +
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
> + * The reclaim runs with GFP_KERNEL, so this function must not be called
> + * from a context that holds a filesystem lock (e.g. an LSM hook invoked
> + * with inode_lock held): the reclaim path may enter filesystem shrinkers
> + * and deadlock trying to reacquire the lock. Contexts that set
> + * PF_MEMALLOC_NOFS/NOIO are handled by the gfp context inheritance.
> + *
> + * Return:
> + *   The amount of memory actually reclaimed, in bytes (rounded to full
> + *   pages), or 0 if @size is smaller than a page or the calling task is
> + *   already in a reclaim/freeing context (PF_MEMALLOC).
> + */
> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> +						unsigned long size)
> +{
> +	return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE, NULL);
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
> + *   The amount of memory actually reclaimed, in bytes (rounded to full
> + *   pages), (unsigned long)-1 if @swappiness is out of range, or 0 if
> + *   @size is smaller than a page or the calling task is already in a
> + *   reclaim/freeing context (PF_MEMALLOC).
> + */
> +__bpf_kfunc unsigned long
> +bpf_proactive_reclaim_swappiness(struct mem_cgroup *memcg, unsigned long size,
> +				 int swappiness)
> +{
> +	if (swappiness < MIN_SWAPPINESS || swappiness > SWAPPINESS_ANON_ONLY)
> +		return (unsigned long)-1;
> +
> +	return bpf_proactive_reclaim_pages(memcg, size / PAGE_SIZE,
> +					   &swappiness);
> +}

[ ... ]


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/32339450346
--===============8690568711721681409==--

