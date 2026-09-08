Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2AF4C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 08:38:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 700496B008C; Tue,  8 Sep 2026 04:38:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B1376B0093; Tue,  8 Sep 2026 04:38:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59FC16B0095; Tue,  8 Sep 2026 04:38:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 37E2F6B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:38:54 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B937E160461
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:38:53 +0000 (UTC)
X-FDA: 85189944546.24.267ACA1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EC5D1140012
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 08:38:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAD9imPX;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788856732;
	b=VDZLRXnZtuRXRkc5Gn9gC24l+KmIRsY8QjkMOLLetyjBNQZC1L+4+d2fByoPw88ZWYVPmA
	tf6TaGBXqXaHalIdCYLS5GQGf/2CRF8eUMQCaqCmue3ExLzEdKl5gNo02MBpeKdrHfYIXB
	cRyJEnkzzrza1+cY5iYzWSCXvTwLIHA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EAD9imPX;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788856732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x0TeNxa7WKy6H83W3YykrnYwLHUqj47zG0dTNGkPR8M=;
	b=2BqUyHPDJOUEauyew8kPAx5mccE1a/R5Ap3JQx5npoiHNU7Wt0T2M87COWKh1GRYOKaE1x
	5SchtEx06IAowhh89pVZtS4GNfFgZK8RUwsWpjhNBoygn0ZY17c/8Itx9YkDXUqMjjzO0e
	HHP18ojrG2IOMrDr3fr/xwm1UvCep3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 125A940346;
	Tue,  8 Sep 2026 08:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CAE1F00A3A;
	Tue,  8 Sep 2026 08:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788856731;
	bh=x0TeNxa7WKy6H83W3YykrnYwLHUqj47zG0dTNGkPR8M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=EAD9imPX7j1sj3xlERKzxrMcNSF79EWjH2FLPP6UrAVWmhWhEWEnrWkns+aGFfiQr
	 9alkBgbZZm/6zgZmJdDlXjxMxAQOSLPJWPdZ9ULWoM3IsibLmHhRi4uKW3S1gVTEo/
	 BJpwqWqcVYIYiaLaBT2c8WbpYTPhCyRl5AVcrkUoHeZk79BA1/+lqzgbf2P1sfK/ys
	 L1ocK5IDCzNvvX9jUboF2L+9Z+3FvuqELM5cDGUR1IxHepvRp0iCcMuJIajweeGgND
	 PlxxQki4lTRXyG4O1Gy9yxvgZcNogU0vuTQZTvK4Q/70DnPx+Z/rfNZ8HyYGRP7AOi
	 b0QRKSftBReRg==
Message-ID: <c4c29830-ad49-4ca1-b4d5-6f40d30cdcdc@kernel.org>
Date: Tue, 8 Sep 2026 10:38:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_alloc: add missing hooks to bulk allocation
 path
Content-Language: en-US
To: Qiqi Liu <liuqiqi@kylinos.cn>, akpm@linux-foundation.org
Cc: surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev,
 hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rostedt@goodmis.org, gourry@gourry.net
References: <20260907120949.418450-1-liuqiqi@kylinos.cn>
 <20260908065043.217569-1-liuqiqi@kylinos.cn>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260908065043.217569-1-liuqiqi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC5D1140012
X-Stat-Signature: 3yxmq6cgphzx7zbw6o5jpsb7i4jgiope
X-HE-Tag: 1788856731-797546
X-HE-Meta: U2FsdGVkX190+guPwC4rfc7ra+zEDtAcq7EJ9avW7njKmejnIp91lRK8OmCiVl68WaPkndgqmOsmNOoiJlE4FOzayPKancyc8m6uWOQaqvVADNAz2RC3/paKmMRUSvhaGVa5/nx5f2u/pODaAYMU1PSQcSVEh+dpidD8trxmYNkBy6pddCvpUNHp5LI8Vj+FVgCKl5xCvpWT7rj9L88e5jkjrxNFKRrne54WPr0Ck7GXuL+26bVRhJMANEAVl/5RdvT7RCJ/ABub7f7peluaXS4y3UN2hb06fG0uvaILwmwgVcRGH3FW2hDjMs0+rhuv1dEZ44fxwSvARqIUTkZ7rtsakhhWNQrSpy1t+CP/HLDaS6mmaQErsPtSTfRMeF7H4QeXYOhj24iDA8nj+Lmmh44lO3fspK4d7cYvVJS8dlD210EuzEadJupec4PIWs/SUkS6xCZPU8lhLLPWtB++9P+5Be4lFjPLPc87zU81IBcyK26Ie4o3xXfCjUND+9tQuD/H6SYwF5UDzMsWoayGtxzh1D9M2OoYCh7Yrph8aJV2SF3+hzoCv3Ba72lNFfjS8WERpqKjZAGXsDFqrO1NtW9wv8NPkwQZjg1mJ5BRsKWReGrYm2h8DBnJAqslIdmeJ1UokgSOuO7IsMvIlPgD4lcd6JJGV3DMiRSYWRAf68g9/2CS1oZmt1Vda0ynEjKOGdPko8OP/gNWNqA/3tLLCCuH45w//1CYOVZ/L9OlBoLj19e/SzHYDxJs9k0weyfpbvkEc4LDHx4+AlLS0TYXFB74F8XtUqgk/WWc0cX+n8eIGRtdOwOAb4ZB9qI52VFFfGv9KsWo5fapKj6ludMQLAsb47LqIYIc64PYsaz56/6kbJ5LHkevWxXIBG+4JsrNNsFP9D4rqCFq/pmXM1SlQhQeiefpaJFgwfOba5d9hRAMOLjm+P52XBw8aoC3m3EgvjOW3aj4L5GWGtuZaqF
 LapYLAUf
 DhSdel2UeoulVLc572JZAipPFn/4/prZXlnacRy8GNuc8Qi4Qh3WUK3xBoXUxZMDZSrq9U6Xb6QQMAl52l+QtXrrRT92XC/Ly/HmARVRtfMKAfvjXNIOxmyvvE7EdZcptlJmcPy+x28XeSmBlXjBtUXtaDQAy7p1l7Sr3dshJRGUj7IArLtzlyypo/j51SfvkRJByPXZIJ1FgpLiRFyTz7EcMDxf8kIhCIefzRbnTaNWC96/jXTUCCfcB7D4zX3tJmrLyvdVa55yMRD74Wr5yPCF+95jSpT8fy/2jNcVWqcJkeKRd+QiNK+Qt5sU/+UoMvC5tw4EckjdRlL+wpjtKUHqxzPnP7DMwQftK1uq3Lk5BLs8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 08:50, Qiqi Liu wrote:
> The bulk allocation path in alloc_pages_bulk_noprof() currently misses
> trace_mm_page_alloc() and kmsan_alloc_page() calls, leaving bulk-allocated
> pages invisible to ftrace/BPF/perf and leaving KMSAN shadow memory stale.
> 
> Add both calls after set_page_refcounted() in the bulk loop to match
> the standard allocation path. The gfp mask passed to kmsan_alloc_page()
> is stripped of __GFP_RECLAIM because the bulk loop runs under the PCP
> spinlock, and KMSAN's stack depot allocation must not sleep.
> 
> Both are no-ops when their respective features are disabled, so there
> is no overhead in production kernels.
> 
> Suggested-by: Gregory Price <gourry@gourry.net>
> Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
> ---
>  mm/page_alloc.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 12fac9084c48..73c73499a051 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5280,6 +5280,8 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
>  
>  		prep_new_page(page, 0, gfp, ALLOC_DEFAULT);
>  		set_page_refcounted(page);
> +		trace_mm_page_alloc(page, 0, gfp, ac.migratetype);
> +		kmsan_alloc_page(page, 0, gfp & ~__GFP_RECLAIM);

With normal page allocation the set_page_refcounted() happens after
trace+kmsan. While it currently shouldn't matter, it could be more future
proof to keep the same order.

>  		page_array[nr_populated++] = page;
>  	}
>  


