Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D6D4C79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 12:23:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3B16B008A; Tue,  8 Sep 2026 08:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74A56B008C; Tue,  8 Sep 2026 08:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B632D6B0096; Tue,  8 Sep 2026 08:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6986B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:23:13 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CA1340561
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:23:13 +0000 (UTC)
X-FDA: 85190509866.28.0569D32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id EEBF2C000E
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 12:23:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7wCTODR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7wCTODR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788870191;
	b=ae8pW9Gjepro7hBLGE5okK+MeBBCfek6kE5xHQtN5jNLBdf/j6vyoDWLRBKvXx+16rud27
	5VB7F5xTSNLnvQmhzMzoEMESWUZKDyEXjWliwXPMyzmLEolszChTDIg2LQ00P0uIW5ZvBy
	5VntcJl89pjA6eJChJ4pfmRD7wXdwu0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788870191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aKO8anCYGcnb/OXRQiI4kbt2lCHpmv4RnbnceUHiCXM=;
	b=g4bj+PLedoNN/h3Yob2PFapM0Nmja1ynPoxCnGhpywFuSZ+FdHBBy8DqXRn2+gdFg7JXiy
	ARZljcdO9z4geaPjOVwEnszpxMV3cyUzgta6JRtclINZtqBYcAx6Zv4Chrt1KYlEpHk7N7
	a2f5hiS20FIHqq+lNgSebuDlgaZGjs0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D32A43B0F;
	Tue,  8 Sep 2026 12:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039841F00A3D;
	Tue,  8 Sep 2026 12:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788870189;
	bh=aKO8anCYGcnb/OXRQiI4kbt2lCHpmv4RnbnceUHiCXM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=i7wCTODR9DtNGScr/lOgV/jBLSlWm9MCexe584RmY2Bdk58wqA5SI6qz7SA3Xs1oo
	 TLu3+4EoYw10BCwJWk61BYzhyMMeclLerXeJg33JIn9DJuNnaJZUBr3Xv6w2VvC3GZ
	 +hklwu3+UWB9ydzVS8uwukIuLiFiLkVRyBZ7GL0r0/jsgLs4pRkwAEjA+OQySkLuWn
	 3upXGIdpCgJxtj40DyjL2fHq5X+rkNNbU9CyLJ98L5+7kIHxNLlORxaRPqThNJ2EnQ
	 u0E0Bwy5CsmfLhj2wpaGKJORlZev+LybSh1KTY8FJ+aCUdv7bO22mCB/lN0PulT3Ud
	 70PzNBCejvYQA==
Message-ID: <9d614e4b-2ee0-46ca-9de2-b07539f3af22@kernel.org>
Date: Tue, 8 Sep 2026 14:23:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm: page_alloc: add missing hooks to bulk allocation
 path
Content-Language: en-US
To: Qiqi Liu <liuqiqi@kylinos.cn>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, gourry@gourry.net
References: <20260907120949.418450-1-liuqiqi@kylinos.cn>
 <20260908102356.344075-1-liuqiqi@kylinos.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260908102356.344075-1-liuqiqi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EEBF2C000E
X-Stat-Signature: dq3fshrir8wpb53m6xx3gs7ybcbh96fk
X-Rspamd-Server: rspam01
X-HE-Tag: 1788870190-460897
X-HE-Meta: U2FsdGVkX19GpfwPOjsBhrAgCTpH5Pi4jClXQrTkGauRp1p+DVpfDht+NGp9L5whvlRedCxd+/DbQB1irFQOw/Tq5W8LX0BJ+9YcqnN+9D6zMDiFvGXavWfsO/UF6iEt4cdTXMF+MTwtRJxXv1RihX8wfcS49hmw6WOfCdDZjYwnaFmYoA+e/LPuf85kaGAs/ga+tlVxrMUusyuA1iAJd4uFwJ/p9MBIg/g0UAYZfEhaPHnJgGxnowWH1QD4Wd3FepIUuuA0R5PL7U3zOJXHVmMjmayyMu2sbHnx1L5wmP6hOJ9BpNP8FH7JfgyfQlDpFFWfABYWHsREM9qmHSXA8aH6YrrUS0uZtiX1hloG483ufG9QBqYbH1APlptMKjEE1tME9dFeteDQAH3q64swY8yzIuXLJJVeISRKnBMyV2NGZkalnzH3AvUY++6zV4ZkbHZHDNQDgZzmNSZl653t6n5f5FxDa4npIXIsxGvFFHy99F1LzC4gNnCWp9MHc8qjpwE56WwmjP88o5OhipwGSqMnv4084ysCr50OaoXKwCn1f6TPAzaQilxetc69pUCOc5OAVF1BZKaHnHQJZ6BqDQk83EbjdsXxbxi46n9ArvYcrfONVtfc7uAx2ArzYr6+yEsOMFbY8cv4gjau7FM+eKmgv6NFd7AXDLxAiJa4kxyxd8WCp/xLaf1YC81QUlH4hIo0tAc/pEIW9vAvv+wiuT5wmN9pUCcySQiIKswz6FE6c5DWjsWnIDun4RHZfXMzNWyIvrgO53yDaYEMw1+7B4XFPCCrF6HA8iZUw0a8DyOqVk9THtKjLWhvazfqJkmezxrI7I5JuzgbAZj4+X43myMy/aMSKofx8H2WGPYsVwcy5MS2p8grCGZ0uD1MSNU1AJZFHS8/xVOnIT/WyMPip4AqajqLi4JBbDEYZLjHv9E+WIGILVt8iiO214AckbgRYlUUwVZ9pzCI48auffK
 UAXKrCQw
 /XGKIErLVRzc1QrwMtlvp+jPDouah4u9DTk2r++1PjbmKJmMWDS9qQlQMKORqwHioyMr+gtBPv9Aw9NzfgcIVMen8XfIcweSNXXmQKV81orFfVlX0l8PvPsYGyl3bU3/htok7QhciwdxqhdfVgiQOpvy/hXuVQIwRG8VDypA5UoA/PSMUXCpQGfWByr8CS9GC7J4/2tXZI7cGju4b5l+y8Yy+c6jICJtCm9ybpvLRyDHpRWf7uAm7nPZ9ufjrP4EybflKRDV0taSB1vxJwBA0Qld8RN6V3qzLXnOxC7Pqj4hyjLVRgSe+bPXFWGi4XmBX6eibwknVt0GBEJK4MRfmc8QW/wjvv6Wgr9Wx5JlnsbSKMaNa4yTjnJi35ee0ng2RZuXDKjR2HIjXY+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 12:23, Qiqi Liu wrote:
> The bulk allocation path in alloc_pages_bulk_noprof() currently misses
> trace_mm_page_alloc() and kmsan_alloc_page() calls, leaving bulk-allocated
> pages invisible to ftrace/BPF/perf and leaving KMSAN shadow memory stale.
> 
> Add both calls in the bulk loop to match the standard allocation path,
> placing them before set_page_refcounted() for consistency. The gfp mask
> passed to kmsan_alloc_page() is stripped of __GFP_RECLAIM because the
> bulk loop runs under the PCP spinlock, and KMSAN's stack depot allocation
> must not sleep.
> 
> Both are no-ops when their respective features are disabled, so there
> is no overhead in production kernels.
> 
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..eac419eef697 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5279,6 +5279,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  		nr_account++;
>  
>  		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
> +		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
> +		kmsan_alloc_page(page, 0, gfp & ~__GFP_RECLAIM);
>  		set_page_refcounted(page);
>  		page_array[nr_populated++] = page;
>  	}


