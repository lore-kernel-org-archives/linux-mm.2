Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4829DCD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13046B008C; Wed, 13 May 2026 11:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE9DA6B0098; Wed, 13 May 2026 11:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26646B009B; Wed, 13 May 2026 11:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9327A6B008C
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:32:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38C7014019A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:32:49 +0000 (UTC)
X-FDA: 84762789258.15.2427909
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7B2DCA000F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:32:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JRTu9XDX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OGf/i9COKYOKhD+woDVz5jN9BzTuJiAgE2Q+LUMyIE4=;
	b=IsuQ+s5/tgwEFr8x/+usT/kAAsQid0aPFWxnm7AtcpS2bTX+hU4X5fWVRHj1Sgy6YiU2m2
	fLj7lilPV+k0/LikzIrRTolPZXvx8YGmWopbrb2QRECblpx7mVKA7cZA5V256K25Bgg+eo
	ZD/gMU0SSab3UWk3aFVPAGQ59q+n75Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686367; a=rsa-sha256;
	cv=none;
	b=nuZGPhJ9S4dEpgi4ONw9Hp9GRY7OuZ7I9bpjPhLfwpQE4d536IF3Lc8UN3JrWGhZW1C3mF
	emRcCoDtSYIOy/kR+OIGI/+FBWTXOje07CqeQp7DX4Q4XFhfPeTyi4/kJqkrmW7ZAtU4BZ
	EbaPiwRmBbrLre7X07UCuMFSRw6w6y4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JRTu9XDX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of hawk@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=hawk@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BB2D560121;
	Wed, 13 May 2026 15:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A925C19425;
	Wed, 13 May 2026 15:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778686366;
	bh=0ci+iek60SmkhVTT/zsTtlI1fmuGknW5HfienBWjnFM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JRTu9XDXhzehWq8qRyftamEAEiC2Q020LlHtCb8ip9vhqdfOOIyj4jK7UPjULtzhI
	 zZuZM5tkxjuJs4A3fyl2dsEpZeU52xFGEfrhndTWEGcg7JrRto/QW/+YloP8U/4Y00
	 8mGcx1WfnBEux7LgwoEw/Pyyum2fyzPcmHddAruShjQzhEOQOePuv/pQNOizNGhXhc
	 vhCaeRPmjpXIwyFkd8lEJzBfYA2LTFPMb2uWzkr90owubbZxB/KJlM8P7PhiFDpUtp
	 zZvtrZNVeiUNOYiRitoQCLBsE3i3C3DsmRRfUlEOHBPicHRbc3ceG6xJgVKLVuweLD
	 OXBiwUtPeWVqA==
Message-ID: <fab7d27a-6c2b-47aa-abe8-a327f05fb5cd@kernel.org>
Date: Wed, 13 May 2026 17:32:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/page_alloc: add tracepoints for zone->lock
 acquisitions
To: Dmitry Ilvokhin <d@ilvokhin.com>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
 Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Zi Yan
 <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@cloudflare.com
References: <20260508162207.3315781-1-hawk@kernel.org>
 <20260508102948.b1c687e623fabec65580f258@linux-foundation.org>
 <832e4333-4079-4865-8ad8-3dd8868fb964@kernel.org>
 <4f61457e-deff-430f-8a1e-d3c33c925db3@kernel.org>
 <af4mbDB3-ohO5DCp@shell.ilvokhin.com>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <af4mbDB3-ohO5DCp@shell.ilvokhin.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7B2DCA000F
X-Rspamd-Server: rspam04
X-Stat-Signature: fs8o195jr6zzf4k39yju799c7csygpbk
X-HE-Tag: 1778686367-253137
X-HE-Meta: U2FsdGVkX19ZeH8x6Te17ePO61832hexuF9eiuHEYqaKgF6nbtMLWjBq0Ii86qDTejHm48wUUnxQYQH6bETbV+bJkdbMAO8K2JXV/4ZxqQVFhT9N1HTGIq/tq7xxTq6NhYlzXttpCT6NW2j8hIWXFZRuzn4kiClmYS23cEYetcNEnvniupZewaA35k/lL/kyT+0kSiNVynEHK0v0rfc+HJbnxYnO22PMft5EUEmc7DxGZtFd22shvnLwrwRdNMpiMd1xSjUHH8CtJvVRfsPXk3kw5ZDE4lXQO5z0HnlJxPc1+bJhbQXozO5FF12AiKB9wAb24qXXxjJYMB/HYWMTv/PGQPhRHdrMdq1M80aE1w08qbbffDLkd2Gzn9uqbvCIwRTjVMmdp89NeKPjnPCiQzikyWRb0N6Lyf2ijeo64k8hG/gn/G/8Ltv7atZCfyMcQxIJKY2IYJSCtOxl7FHwqxYLrqzFZqvgxHkoNGwhz1EsABJcqMmBXx2xSvU+lB1GuUsw1xpDKFbK7umStlZOBzZhjUcU8rG7xLIllTjCnG+bE+zKwJG3tsS4COh/ANyVml2g45Jn1k1S+39Zpji+xlAqm0gPmHp/8BtMumXUDISDlkRHrcENxOOOwAnQ1KJeK8YZTNF0HG+A+yYOOQWIIv/8FOoF0HPK3gUM69KPiGIbzHhI2YbImZRHZmW79ktVieoYuZSPj6oWK1X5M3zmRZo7BwNhjvUciw7o8ujjlWXEiuLxOChf4eIreBkKIIi2UDc9sFiLi2gXZi9Z7sa5qnVB2i5ArVJo/pDWaiAKOwpLmPDupOZXX6QUcOJ1tD+cLJqsp4H6lHc0ft0rvrCGwCRuVSBEwms779GULYzbx+XOlILj/PFkUX+HDBQnm8SJw8slGtSNLA6NvdFPYMkNZ1Or5v/K4mKjm0OEDfSxG7Lzuy03awc/XR17bRD87mHn2eF0bFb3Z0vchDQj5Oh
 jz1hOc2c
 851B0l4UxrWysQSa3WPWONJXJyGU9RNTa3I5okT9GI7z22W/J+8B91ytAjWIw/ReOi4rN9yK8H4jXodPCAvc8yVO6/Xe0G1QyfsLJsJVZrwPLdlJWfV96ylVcbhsoGU50BEAUj4GRGZyu97M1aU5yntD0TBjE+SF13WkaqEWGnZG8LMxTKm3TfGweyTLMuEiYD/gV79/HNMH7v0mVQvYx66HrHlglO4mLoR1UGNOzOEZaP9DMZeM3qbxis7peGo4mrWnR0OFc6fxUVJScbi/s6knSf/Mn5lenEYBwho4Iy1md2FvJszbHrCmqlu/WqZMdnNJyzcFZdQEL4W84dmT4L6qunZlkf9kQTRqwo50edoYlx+IgwEHo5iXq/DArD4LXcCjMfYnpBcC399E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/05/2026 20.07, Dmitry Ilvokhin wrote:
> On Fri, May 08, 2026 at 07:40:51PM +0200, Vlastimil Babka (SUSE) wrote:
>> On 5/8/26 7:38 PM, Vlastimil Babka (SUSE) wrote:
>>> On 5/8/26 7:29 PM, Andrew Morton wrote:
>>>> e .configOn Fri,  8 May 2026 18:22:06 +0200 hawk@kernel.org wrote:
>>>>
>>>>> Add tracepoints to the page allocator fast paths that acquire
>>>>> zone->lock, allowing diagnosis of lock contention in production.
>>>>
>>>> Thanks, I'm surprised we haven't done this yet.
>>>
>>> There was a recent attempt [1]. Not being a generic solution wasn't welcome.
>>>
>>> [1] https://lore.kernel.org/all/cover.1772206930.git.d@ilvokhin.com/
>>
>> And this is the generic solution I think?
>>
>> https://lore.kernel.org/all/cover.1777999826.git.d@ilvokhin.com/
> 
> Thanks for cc'ing me, Vlastimil.
> 
> Yes, this is an attempt at a generic solution for tracing contended
> locks, including spinlocks, so it should also cover the use case
> proposed in this patchset.
>

I'm aware of the generic solution and often use `perf lock contention`.
And the tool libbpf-tools/klockstat. My experience is unfortunately that
enabling these tracepoint is prohibitive expensive on production server,
and production suffers when I run these tools.

I'm very happy to see a patchset adding a contended case. But I worry
that tracing all contented locks in the system is also too much to have
enabled continuously for production.

This patch is carefully constructed to minimize overhead, such that I
can enable this continuously on production to catch issues.  If I
identify issue I will use the generic tracpoints for further debugging.


> In fact, zone->lock contention was one of the primary motivations for
> this work.

In the generic solution I'm loosing the "zone" and pages "count".  I
need this information to get the answers I'm looking for.  Specifically
I'm looking at reducing CONFIG_PCP_BATCH_SCALE_MAX, but I want to this
to be a data-driven decision (my first principle is: if you cannot
measure it you cannot improve it).

I'm likely going to apply this patch to our production system, such that
I can get my data-driven decision.  I need to deploy it widely enough to
get enough server experiencing direct-reclaim.  I'll report back if
people are interested in these learning?

--Jesper

