Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36903D116F5
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 09:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74C266B002F; Fri, 28 Nov 2025 04:24:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63B2E6B0030; Fri, 28 Nov 2025 04:24:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503E36B0032; Fri, 28 Nov 2025 04:24:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40C4E6B002F
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:24:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10E341A03F4
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:24:21 +0000 (UTC)
X-FDA: 84159479922.05.ADC3F8E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8B9C480018
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:24:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S2w6lfbc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3K9erMtU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S2w6lfbc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3K9erMtU;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764321859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dc76lV58qkt2iF/zVmhifyzJVJKFwXAsZ5Z93sGYr64=;
	b=PiBvqfOMhS38bw0RhDVW3ZC7hqObgmsiLgVXCG22DS1ix/8Cz4Yd0A+fF3Uolx8TR2XyTo
	haOGlGWcMh6UfZuGlZ4db6YUqIReFI5fA7Q/7nIS16G4kjZ6t/Ori+iSIG+yFlPbokEVnp
	HGqpKtQkl6+2ed4OOkHQo2GvpEyRoyw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S2w6lfbc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3K9erMtU;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=S2w6lfbc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3K9erMtU;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764321859; a=rsa-sha256;
	cv=none;
	b=wXg/vwZS58qC2kwnzmr1kxYBzh58xfLEi+wPE3ES4VQAE/UwuGD3gZ4rCExKkZWSTfFWQI
	rJr4PrbKFG7gQEAQAdwa8cqzZDFMpFvvAhmsXeJpg7Oy3MkTgNegFsbQ7hj1IwrCJ8clpg
	BcIRpA6lJ4vhGLxo/3r9KtjjGnMPdpU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A78AF22962;
	Fri, 28 Nov 2025 09:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764321856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dc76lV58qkt2iF/zVmhifyzJVJKFwXAsZ5Z93sGYr64=;
	b=S2w6lfbc1qQfJSJSeEVz0ThCduLHQwnaN61jklLCiOe8jipT0SLBLap+V+sstSHlwQ912o
	D1MtXoIUwPpetRwyH61TADsEWs4mFq8cmUv5gGgOx7MIYxp3LNmpvfrdygFldXOZKm1JaJ
	o4Mz8FX0l5OvVr8ZYOdJ7QuFVU+bxP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764321856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dc76lV58qkt2iF/zVmhifyzJVJKFwXAsZ5Z93sGYr64=;
	b=3K9erMtU49ekKuGo2Bdqtco6mdp7QapHr5t5VX8kgBVCpWeW3hrV/wYzSRjD8dGOUGWcmI
	cKemhMz1l1vDptAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764321856; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dc76lV58qkt2iF/zVmhifyzJVJKFwXAsZ5Z93sGYr64=;
	b=S2w6lfbc1qQfJSJSeEVz0ThCduLHQwnaN61jklLCiOe8jipT0SLBLap+V+sstSHlwQ912o
	D1MtXoIUwPpetRwyH61TADsEWs4mFq8cmUv5gGgOx7MIYxp3LNmpvfrdygFldXOZKm1JaJ
	o4Mz8FX0l5OvVr8ZYOdJ7QuFVU+bxP0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764321856;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=dc76lV58qkt2iF/zVmhifyzJVJKFwXAsZ5Z93sGYr64=;
	b=3K9erMtU49ekKuGo2Bdqtco6mdp7QapHr5t5VX8kgBVCpWeW3hrV/wYzSRjD8dGOUGWcmI
	cKemhMz1l1vDptAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B53F3EA63;
	Fri, 28 Nov 2025 09:24:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w4DKHUBqKWmoOgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 28 Nov 2025 09:24:16 +0000
Message-ID: <97a9e695-487a-4428-87b7-cb8a505c9966@suse.cz>
Date: Fri, 28 Nov 2025 10:24:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: add per-migratetype counts to buddy allocator and
 optimize pagetypeinfo access
To: Hongru Zhang <zhanghongru06@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 Hongru Zhang <zhanghongru@xiaomi.com>
References: <cover.1764297987.git.zhanghongru@xiaomi.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <cover.1764297987.git.zhanghongru@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8B9C480018
X-Rspamd-Server: rspam02
X-Stat-Signature: sfd89kmt95kdp4uwbhcp4aeyk6ps36he
X-Rspam-User: 
X-HE-Tag: 1764321858-850903
X-HE-Meta: U2FsdGVkX1/4rWhf84yl/nymmBqvTGurqvL9mgCKzbsEA8AURdo/tDYIUba9UDjKNwxcxtHYVwHdPlbo5Ax6n6rd2QW+xKCLHuFbEpE5UuQkaZUAB9CtXSujUpZTkx+/Cx6Kcz47nDkvAP/vR03+gAVCJvNiCj3vJjPQALtUz7Kmp0W/fPMWCRYxUOI4XPVzFPjBA2LK9XMDmXmLYWFImgR2sRzAb9efm96v3KpxmjRE6J/2ve2K1lOIswm7GAyyhMtzlIQrMH3bPFZticZG+nhLJdCAewuu4l5wl1hmx9m2m8yDeZNhBvaxZpEz12z7G7NQYmOKtQ3vAlLcJbJC00mPeTWfjdNdt601I15RkphWnfOsdetP537rXk2bLXfkabww1+3ELVIaU6KXAPoohlQu/xHsRXzxkgzAq+p4r4oFgGPMEO8Lw6/ykRZe3ZZYV8godQ93YW730g6gzsiHy1ZwzcBVxRHeJ7tjdkjZK7+O+7quC9b5dVe3ps6nHQ8dDmScBTX9QcBuYHrTdJLqkCIddGbLIPNEx1kF1hqD3qNDs/zKpqIh/bzF77mTrXEX0fTh/NIKVnXLVlrYqjDqeH848No+ViuhBw5dzLkRCxznRGFsVkey6/vEorghXJiS+gdvfU/ygUdhZnCFYqGvQv0wEVdf/sTObcn60y3q/RDgxl8YkezMtDiuyKt2NVOWrQTwyKx7uRbN10y/03cHZZWaX7xC0wPVC1tzVrzSRAexiXd1BuYLU+aEZdhZewZqi/8tbw532IsBINzYVINPEOPXuI17boOhDw6/5CYnHNBwPe3QNJmHUzq1YoUeINA9Td9Nl3I4ljCUHIhu98oqnxhnQv6yVFO9Ll2dd8VRqL2SOWpzoSBmTJGNAw28Q1+7vuklN9GjVmafyNzoEsPLcEAjG83sihzIcymYJRgTmYK+yKr5LM19vyrV43stOpLL0znx1SneDaj5p7ZiS4Z
 aAmGUZ7I
 vupVcUd3uR5RXkbTwrOgaooJ0Y7yvhsP8lnLwgdoP0S1nLmkOws3XWIYlZGOq2+Nv6UUH7fATazHWWNZqN8mpN7eBd1S+Gh5kPVzqyHsG2atm7iWXHkIwwwGC6dOWFTe1LK86YO5VqqQ+q9d4rCeOecwlKoeuDO1ca7IX0g4QXsxw4AqYic/0i03XAuhqx4K0FcpmxnGr6nJWnThqhNY4tlEQnKSH9ktduRSAP8YipPtYPjb+5wmJDUGn1YjU3Hzh+3WqZu+z9tw85hPK/Swh38N8+/9pkrFVeo0K
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 04:10, Hongru Zhang wrote:
> On mobile devices, some user-space memory management components check
> memory pressure and fragmentation status periodically or via PSI, and
> take actions such as killing processes or performing memory compaction
> based on this information.

Hm /proc/buddyinfo could be enough to determine fragmentation? Also we have
in-kernel proactive compaction these days.

> Under high load scenarios, reading /proc/pagetypeinfo causes memory
> management components or memory allocation/free paths to be blocked
> for extended periods waiting for the zone lock, leading to the following
> issues:
> 1. Long interrupt-disabled spinlocks - occasionally exceeding 10ms on Qcom
>    8750 platforms, reducing system real-time performance
> 2. Memory management components being blocked for extended periods,
>    preventing rapid acquisition of memory fragmentation information for
>    critical memory management decisions and actions
> 3. Increased latency in memory allocation and free paths due to prolonged
>    zone lock contention

It could be argued that not capturing /proc/pagetypeinfo (often) would help.
I wonder if we can find also other benefits from the counters in the kernel
itself.

Adding these migratetype counters is something that wouldn't be even
possible in the past, until the freelist migratetype hygiene was merged.
So now it should be AFAIK possible, but it's still some overhead in
relatively hot paths. I wonder if we even considered this before in the
context of migratetype hygiene? Couldn't find anything quickly.

> Changes:
> 1. Add per-migratetype counts to the buddy allocator to track free page
>    block counts for each migratetype and order
> 2. Optimize /proc/pagetypeinfo access by utilizing these per-migratetype
>    counts instead of iterating through free lists under zone lock
> 
> Performance testing shows following improvements:
> 1. /proc/pagetypeinfo access latency reduced
> 
>     +-----------------------+----------+------------+
>     |                       | no-patch | with-patch |
>     +-----------------------+----------+------------+
>     |    Just after boot    | 700.9 us |  268.6 us  |
>     +-----------------------+----------+------------+
>     | After building kernel |  28.7 ms |  269.8 us  |
>     +-----------------------+----------+------------+
> 
> 2. When /proc/pagetypeinfo is accessed concurrently, memory allocation and
>    free performance degradation is reduced compared to the previous
>    implementation
> 
> Test setup:
> - Using config-pagealloc-micro
> - Monitor set to proc-pagetypeinfo, update frequency set to 10ms
> - PAGEALLOC_ORDER_MIN=4, PAGEALLOC_ORDER_MAX=4
> 
> Without patch test results:
>                                          vanilla                vanilla
>                                        no-monitor               monitor
> Min       alloc-odr4-1        8539.00 (   0.00%)     8762.00 (  -2.61%)
> Min       alloc-odr4-2        6501.00 (   0.00%)     6683.00 (  -2.80%)
> Min       alloc-odr4-4        5537.00 (   0.00%)     5873.00 (  -6.07%)
> Min       alloc-odr4-8        5030.00 (   0.00%)     5361.00 (  -6.58%)
> Min       alloc-odr4-16       4782.00 (   0.00%)     5162.00 (  -7.95%)
> Min       alloc-odr4-32       5838.00 (   0.00%)     6499.00 ( -11.32%)
> Min       alloc-odr4-64       6565.00 (   0.00%)     7413.00 ( -12.92%)
> Min       alloc-odr4-128      6896.00 (   0.00%)     7898.00 ( -14.53%)
> Min       alloc-odr4-256      7303.00 (   0.00%)     8163.00 ( -11.78%)
> Min       alloc-odr4-512     10179.00 (   0.00%)    11985.00 ( -17.74%)
> Min       alloc-odr4-1024    11000.00 (   0.00%)    12165.00 ( -10.59%)
> Min       free-odr4-1          820.00 (   0.00%)     1230.00 ( -50.00%)
> Min       free-odr4-2          511.00 (   0.00%)      952.00 ( -86.30%)
> Min       free-odr4-4          347.00 (   0.00%)      434.00 ( -25.07%)
> Min       free-odr4-8          286.00 (   0.00%)      399.00 ( -39.51%)
> Min       free-odr4-16         250.00 (   0.00%)      405.00 ( -62.00%)
> Min       free-odr4-32         294.00 (   0.00%)      405.00 ( -37.76%)
> Min       free-odr4-64         333.00 (   0.00%)      363.00 (  -9.01%)
> Min       free-odr4-128        340.00 (   0.00%)      412.00 ( -21.18%)
> Min       free-odr4-256        339.00 (   0.00%)      329.00 (   2.95%)
> Min       free-odr4-512        361.00 (   0.00%)      409.00 ( -13.30%)
> Min       free-odr4-1024       300.00 (   0.00%)      361.00 ( -20.33%)
> Stddev    alloc-odr4-1           7.29 (   0.00%)       90.78 (-1146.00%)
> Stddev    alloc-odr4-2           3.87 (   0.00%)       51.30 (-1225.75%)
> Stddev    alloc-odr4-4           3.20 (   0.00%)       50.90 (-1491.24%)
> Stddev    alloc-odr4-8           4.67 (   0.00%)       52.23 (-1019.35%)
> Stddev    alloc-odr4-16          5.72 (   0.00%)       27.53 (-381.04%)
> Stddev    alloc-odr4-32          6.25 (   0.00%)      641.23 (-10154.46%)
> Stddev    alloc-odr4-64          2.06 (   0.00%)      386.99 (-18714.22%)
> Stddev    alloc-odr4-128        14.36 (   0.00%)       52.39 (-264.77%)
> Stddev    alloc-odr4-256        32.42 (   0.00%)      326.19 (-906.05%)
> Stddev    alloc-odr4-512        65.58 (   0.00%)      184.49 (-181.31%)
> Stddev    alloc-odr4-1024        8.88 (   0.00%)      153.01 (-1622.67%)
> Stddev    free-odr4-1            2.29 (   0.00%)      152.27 (-6549.85%)
> Stddev    free-odr4-2           10.99 (   0.00%)       73.10 (-564.89%)
> Stddev    free-odr4-4            1.99 (   0.00%)       28.40 (-1324.45%)
> Stddev    free-odr4-8            2.51 (   0.00%)       52.93 (-2007.64%)
> Stddev    free-odr4-16           2.85 (   0.00%)       26.04 (-814.88%)
> Stddev    free-odr4-32           4.04 (   0.00%)       27.05 (-569.79%)
> Stddev    free-odr4-64           2.10 (   0.00%)       48.07 (-2185.66%)
> Stddev    free-odr4-128          2.63 (   0.00%)       26.23 (-897.86%)
> Stddev    free-odr4-256          6.29 (   0.00%)       37.04 (-488.71%)
> Stddev    free-odr4-512          2.56 (   0.00%)       10.65 (-315.28%)
> Stddev    free-odr4-1024         0.95 (   0.00%)        6.46 (-582.22%)
> Max       alloc-odr4-1        8564.00 (   0.00%)     9099.00 (  -6.25%)
> Max       alloc-odr4-2        6511.00 (   0.00%)     6844.00 (  -5.11%)
> Max       alloc-odr4-4        5549.00 (   0.00%)     6038.00 (  -8.81%)
> Max       alloc-odr4-8        5045.00 (   0.00%)     5551.00 ( -10.03%)
> Max       alloc-odr4-16       4800.00 (   0.00%)     5257.00 (  -9.52%)
> Max       alloc-odr4-32       5861.00 (   0.00%)     8115.00 ( -38.46%)
> Max       alloc-odr4-64       6571.00 (   0.00%)     8292.00 ( -26.19%)
> Max       alloc-odr4-128      6930.00 (   0.00%)     8081.00 ( -16.61%)
> Max       alloc-odr4-256      7372.00 (   0.00%)     9150.00 ( -24.12%)
> Max       alloc-odr4-512     10333.00 (   0.00%)    12636.00 ( -22.29%)
> Max       alloc-odr4-1024    11035.00 (   0.00%)    12590.00 ( -14.09%)
> Max       free-odr4-1          828.00 (   0.00%)     1724.00 (-108.21%)
> Max       free-odr4-2          543.00 (   0.00%)     1192.00 (-119.52%)
> Max       free-odr4-4          354.00 (   0.00%)      519.00 ( -46.61%)
> Max       free-odr4-8          293.00 (   0.00%)      617.00 (-110.58%)
> Max       free-odr4-16         260.00 (   0.00%)      483.00 ( -85.77%)
> Max       free-odr4-32         308.00 (   0.00%)      488.00 ( -58.44%)
> Max       free-odr4-64         341.00 (   0.00%)      505.00 ( -48.09%)
> Max       free-odr4-128        346.00 (   0.00%)      497.00 ( -43.64%)
> Max       free-odr4-256        353.00 (   0.00%)      463.00 ( -31.16%)
> Max       free-odr4-512        367.00 (   0.00%)      442.00 ( -20.44%)
> Max       free-odr4-1024       303.00 (   0.00%)      381.00 ( -25.74%)
> 
> With patch test results:
>                                          patched                patched
>                                       no-monitor                monitor
> Min       alloc-odr4-1        8488.00 (   0.00%)     8514.00 (  -0.31%)
> Min       alloc-odr4-2        6551.00 (   0.00%)     6527.00 (   0.37%)
> Min       alloc-odr4-4        5536.00 (   0.00%)     5591.00 (  -0.99%)
> Min       alloc-odr4-8        5008.00 (   0.00%)     5098.00 (  -1.80%)
> Min       alloc-odr4-16       4760.00 (   0.00%)     4857.00 (  -2.04%)
> Min       alloc-odr4-32       5827.00 (   0.00%)     5919.00 (  -1.58%)
> Min       alloc-odr4-64       6561.00 (   0.00%)     6680.00 (  -1.81%)
> Min       alloc-odr4-128      6898.00 (   0.00%)     7014.00 (  -1.68%)
> Min       alloc-odr4-256      7311.00 (   0.00%)     7464.00 (  -2.09%)
> Min       alloc-odr4-512     10181.00 (   0.00%)    10286.00 (  -1.03%)
> Min       alloc-odr4-1024    11205.00 (   0.00%)    11725.00 (  -4.64%)
> Min       free-odr4-1          789.00 (   0.00%)      867.00 (  -9.89%)
> Min       free-odr4-2          490.00 (   0.00%)      526.00 (  -7.35%)
> Min       free-odr4-4          350.00 (   0.00%)      360.00 (  -2.86%)
> Min       free-odr4-8          272.00 (   0.00%)      287.00 (  -5.51%)
> Min       free-odr4-16         247.00 (   0.00%)      254.00 (  -2.83%)
> Min       free-odr4-32         298.00 (   0.00%)      304.00 (  -2.01%)
> Min       free-odr4-64         334.00 (   0.00%)      325.00 (   2.69%)
> Min       free-odr4-128        334.00 (   0.00%)      329.00 (   1.50%)
> Min       free-odr4-256        336.00 (   0.00%)      336.00 (   0.00%)
> Min       free-odr4-512        360.00 (   0.00%)      342.00 (   5.00%)
> Min       free-odr4-1024       327.00 (   0.00%)      355.00 (  -8.56%)
> Stddev    alloc-odr4-1           5.19 (   0.00%)       45.38 (-775.09%)
> Stddev    alloc-odr4-2           6.99 (   0.00%)       37.63 (-437.98%)
> Stddev    alloc-odr4-4           3.91 (   0.00%)       17.85 (-356.28%)
> Stddev    alloc-odr4-8           5.15 (   0.00%)        9.34 ( -81.47%)
> Stddev    alloc-odr4-16          3.83 (   0.00%)        5.34 ( -39.34%)
> Stddev    alloc-odr4-32          1.96 (   0.00%)       10.28 (-425.09%)
> Stddev    alloc-odr4-64          1.32 (   0.00%)      333.30 (-25141.39%)
> Stddev    alloc-odr4-128         2.06 (   0.00%)        7.37 (-258.28%)
> Stddev    alloc-odr4-256        15.56 (   0.00%)      113.48 (-629.25%)
> Stddev    alloc-odr4-512        61.25 (   0.00%)      165.09 (-169.53%)
> Stddev    alloc-odr4-1024       18.89 (   0.00%)        2.93 (  84.51%)
> Stddev    free-odr4-1            4.45 (   0.00%)       40.12 (-800.98%)
> Stddev    free-odr4-2            1.50 (   0.00%)       29.30 (-1850.31%)
> Stddev    free-odr4-4            1.27 (   0.00%)       19.49 (-1439.40%)
> Stddev    free-odr4-8            0.97 (   0.00%)        8.93 (-823.07%)
> Stddev    free-odr4-16           8.38 (   0.00%)        4.51 (  46.21%)
> Stddev    free-odr4-32           3.18 (   0.00%)        6.59 (-107.42%)
> Stddev    free-odr4-64           2.40 (   0.00%)        3.09 ( -28.50%)
> Stddev    free-odr4-128          1.55 (   0.00%)        2.53 ( -62.92%)
> Stddev    free-odr4-256          0.41 (   0.00%)        2.80 (-585.57%)
> Stddev    free-odr4-512          1.60 (   0.00%)        4.84 (-202.08%)
> Stddev    free-odr4-1024         0.66 (   0.00%)        1.19 ( -80.68%)
> Max       alloc-odr4-1        8505.00 (   0.00%)     8676.00 (  -2.01%)
> Max       alloc-odr4-2        6572.00 (   0.00%)     6651.00 (  -1.20%)
> Max       alloc-odr4-4        5552.00 (   0.00%)     5646.00 (  -1.69%)
> Max       alloc-odr4-8        5024.00 (   0.00%)     5131.00 (  -2.13%)
> Max       alloc-odr4-16       4774.00 (   0.00%)     4875.00 (  -2.12%)
> Max       alloc-odr4-32       5834.00 (   0.00%)     5950.00 (  -1.99%)
> Max       alloc-odr4-64       6565.00 (   0.00%)     7434.00 ( -13.24%)
> Max       alloc-odr4-128      6907.00 (   0.00%)     7034.00 (  -1.84%)
> Max       alloc-odr4-256      7347.00 (   0.00%)     7843.00 (  -6.75%)
> Max       alloc-odr4-512     10315.00 (   0.00%)    10866.00 (  -5.34%)
> Max       alloc-odr4-1024    11278.00 (   0.00%)    11733.00 (  -4.03%)
> Max       free-odr4-1          803.00 (   0.00%)     1009.00 ( -25.65%)
> Max       free-odr4-2          495.00 (   0.00%)      607.00 ( -22.63%)
> Max       free-odr4-4          354.00 (   0.00%)      417.00 ( -17.80%)
> Max       free-odr4-8          275.00 (   0.00%)      313.00 ( -13.82%)
> Max       free-odr4-16         273.00 (   0.00%)      272.00 (   0.37%)
> Max       free-odr4-32         309.00 (   0.00%)      324.00 (  -4.85%)
> Max       free-odr4-64         340.00 (   0.00%)      335.00 (   1.47%)
> Max       free-odr4-128        340.00 (   0.00%)      338.00 (   0.59%)
> Max       free-odr4-256        338.00 (   0.00%)      346.00 (  -2.37%)
> Max       free-odr4-512        364.00 (   0.00%)      359.00 (   1.37%)
> Max       free-odr4-1024       329.00 (   0.00%)      359.00 (  -9.12%)
> 
> The main overhead is a slight increase in latency on the memory allocation
> and free paths due to additional per-migratetype counting, with
> theoretically minimal impact on overall performance.
> 
> This patch series is based on v6.18-rc7
> 
> Hongru Zhang (3):
>   mm/page_alloc: add per-migratetype counts to buddy allocator
>   mm/vmstat: get fragmentation statistics from per-migragetype count
>   mm: optimize free_area_empty() check using per-migratetype counts
> 
>  include/linux/mmzone.h |  1 +
>  mm/internal.h          |  2 +-
>  mm/mm_init.c           |  1 +
>  mm/page_alloc.c        |  9 ++++++++-
>  mm/vmstat.c            | 30 +++++++-----------------------
>  5 files changed, 18 insertions(+), 25 deletions(-)
> 


