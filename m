Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BDE8CD4F35
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 08:59:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5DA6B0088; Tue, 12 May 2026 04:59:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76876B008A; Tue, 12 May 2026 04:59:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66236B008C; Tue, 12 May 2026 04:59:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B76B86B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 04:59:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 80881C1AFF
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:59:03 +0000 (UTC)
X-FDA: 84758168166.18.9DEB9FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9D5521C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 08:59:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HV43c7mj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778576341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/NVcCyinbqI7gO+tlzaH5SSsnhUDbbBVy8rZZsp2DU=;
	b=hr5slYaWBCA7s4V8E8DW2vNN4pVWsQ1WVK/r2ud4d2yUBx/gx5Rgfp75qulEXd7/pPnLaf
	hp2UGoXPgmK0VaksH84DsPic9IFKSYVEf+AaHhDNETfC1V8v8hDiLfN5ogPyvsLcBwQDRv
	Iz6EzjSH7l+Xh0mPFOZGkyjJCb4yae4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778576341; a=rsa-sha256;
	cv=none;
	b=cdB6F0ifa8F6wmhXzLq1DGJSzfcC8hE18yalPlAxZDvlnYIBI0FEy8zsrfuKXuue2Lc8dl
	5L+mRZm5Wjlkqzl5h8GoZT8g2tboWTEqXw9diSEPuGyWUu6FYJxHbY7Ua/KAPEEuTrA+aC
	IsiTSl9ODHa5XsiE9Gg4aPNHd4j482o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HV43c7mj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EAC1660123;
	Tue, 12 May 2026 08:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FC3C2BCB0;
	Tue, 12 May 2026 08:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778576340;
	bh=vKXMIL92Bz/mggL+tirgTW0vX20fb+lO7LT67Ad/KJA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HV43c7mjIDeIbR6rJ6DmEFmebk89gayz4U3b4977zb4IsxkfMKTJnsgb8kOTzbtBH
	 3sRxpVf1NqpYvK+4hsZZdWs+4xUKHJJQDRh/T5IQB0/SZLgARGq6r7X900y7z7L9Bg
	 JhWRBs69MY9kdC4GddcjVRtqJuHjtxOOEJOSek2Rlh/xzpqajmIxKSGIGlocj+Lukc
	 duUV+RdbYvAoemu5+ebwD2iUCYAijKLBRHMDoTpHy+rjBGUfY2V5wizO8J40FMEtEa
	 5IFc5sc2l5Xl645PotbsorN7wdTWKHrKLFUhT+1+IcGmOR2tIVpYTWw+o8D75kON5k
	 tnPjL2LTuDQBg==
Message-ID: <d964c609-cd40-45ae-8e9c-6c6ed28f3e4f@kernel.org>
Date: Tue, 12 May 2026 10:58:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/page_alloc: replace kernel_init_pages() with batch
 page clearing
To: Hrushikesh Salunke <hsalunke@amd.com>, akpm@linux-foundation.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
 ziy@nvidia.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rkodsara@amd.com,
 bharata@amd.com, ankur.a.arora@oracle.com, shivankg@amd.com
References: <20260504063942.553438-1-hsalunke@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260504063942.553438-1-hsalunke@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9D5521C000B
X-Stat-Signature: 7dq1wjfkek6gghzjohfqzyu8e5qrwmrq
X-Rspam-User: 
X-HE-Tag: 1778576341-18183
X-HE-Meta: U2FsdGVkX18XJP+xYGOmSNVe0Ac1ru7KLIsHiU6thGQ9t3ib1nCBPMmHNFzXMlKLmDo3/YrQc3utf0DgmTuul/c4epGiOXbvkJvpx2v8bSzau8LIGVaady0gUXYIFFu6G6uw6wVxaW3bWXsBxiNgGsRpgaWLpYbSGgftwkCp7WxprVYe/tQLTErH13ZIGSq15fosIzqm/SMIWRrKOkZ9nlK4rax/UvWKpmOP5WBauk1NC5wTCtt2ZDbPV0sAkpl/F7SkrbSTRSroqROJel9rO3yweORtC3w97myhxmIEa9NnNShb/92Oj8VdkLzsP2xjM25GjTj9iFwgTS4d43yXjVMh04zmbi6I/zI0Cl6n+6rRDpT9gnVpIjZbEeg+sjRP49ZFUte3BV3HyKSH2ebmXdt5Dg3OG7xSK6UaNOOsLN9NI4w7UUft4o/L56ttqkOYCvUjEOR21ynTYZhcNmj/EZ5Ri1JkOFBfydS7Mq+YYm5bm641SeXkVa5fcat+ifApu79ai71905pEOAodxqYoxYxyj3Ohe0DYa7g/it7+SDP855AdClAqmW2AdjeVSIS6bsSrHiRL8Ie/qwErU7D8ZAxPs+jQfiKdf+i8NHt6sBFS3B/6vh/zahxm3FR9bqljDb3pqzzC66H8w217G0rj4P7E7Z8G/8ZD6jUjPZJuStwfUjv2TDdFvZ+gDa+JL5oS2sGpEaQRgG9uXShSu3/tCEzmUjXpdHFi6izOITst4nZch4K5+5kXz6JK/ygFAigriNthKifV8StM+OJ1gkH9+agQqkZvj8ggtXn8qbe96mErUTA6IXXcZ/fbVYblq41vb4Cm6t+m/ConVxysqVDSPj5JMlrhTT83+v7dLINZt3MA9LFcmCJGMk1WAE7iNq05YmKETmIUDDWDzn24xgecn9n25xlmxvCZ33ajWDsyA9h5hc4lecvBOHFpBULPTxGy5s3TRjJetowBOG/49jh
 Fb8cLLXm
 Q/RmNf0mDQvTvYaviYXGnQ6ISXdMb9iFukka/jDgqg+hc+JaG4MzuErZ1tyrXu9v1pgC019OIa0UK1C5LIu5KmQu2t/WcDaQ0K5gjqweBkqM9KSv6krDrHlreMELbXTySLKEsTmGZ08NMVam8+log1GcCorNTGZhyh4Lq60Yv9gsQmApg3EXqetV7V3TtqKo/8j6Tk0P3E2apuky3mT67s1Dnfxz1/O0OpXfgVPyiRb2czdbTitP3+iMm2MUre/6uuFBu9Dwv58jYdBPO6Ubi3U/8PZWsMI+C2GSJOm1NAJcfBz6rcK2V4bX1YYZ6QW5YuBC0ls2n8WpLR4/xk0/0mZ0FLiEA9r1Q79IbzlCEYMC8huRZ4D5D13cAVtdPWCuJIpZS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/4/26 08:39, Hrushikesh Salunke wrote:
> When init_on_alloc is enabled, kernel_init_pages() clears every page
> one at a time via clear_highpage_kasan_tagged(), which incurs per-page
> kmap_local_page()/kunmap_local() overhead and prevents the architecture
> clearing primitive from operating on contiguous ranges.
> 
> Introduce clear_highpages_kasan_tagged() as a static batch clearing
> helper in page_alloc.c that calls clear_pages() for the full contiguous
> range on !HIGHMEM systems, bypassing the per-page kmap overhead and
> allowing a single invocation of the arch clearing primitive across the
> entire allocation. The HIGHMEM path falls back to per-page clearing
> since those pages require kmap.
> 
> Replace kernel_init_pages() with direct calls to the new helper, as it
> becomes a trivial wrapper.
> 
> Allocating 8192 x 2MB HugeTLB pages (16GB) with init_on_alloc=1:
> 
>   Before: 0.445s
>   After:  0.166s  (-62.7%, 2.68x faster)
> 
> Kernel time (sys) reduction per workload with init_on_alloc=1:
> 
>   Workload            Before       After       Change
>   Graph500 64C128T    30m 41.8s    15m 14.8s   -50.3%
>   Graph500 16C32T     15m 56.7s     9m 43.7s   -39.0%
>   Pagerank 32T         1m 58.5s     1m 12.8s   -38.5%
>   Pagerank 128T        2m 36.3s     1m 40.4s   -35.7%
> 
> Signed-off-by: Hrushikesh Salunke <hsalunke@amd.com>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Pankaj Gupta <pankaj.gupta@amd.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

