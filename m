Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC85CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 20:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1833A6B0279; Fri,  8 May 2026 16:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 134466B027B; Fri,  8 May 2026 16:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023AF6B027C; Fri,  8 May 2026 16:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E38B06B0279
	for <linux-mm@kvack.org>; Fri,  8 May 2026 16:15:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96E1E1C0670
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:15:54 +0000 (UTC)
X-FDA: 84745358628.12.CADF4CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id EB2D1A0004
	for <linux-mm@kvack.org>; Fri,  8 May 2026 20:15:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PB1h90kT;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778271352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aG/dXQg3UVjadeIBVgu37da+XlLukbnIF/NFg++T/1s=;
	b=RtXhHm/aYaZnbOTgJ45FSorQ1hMYSBt0ypt/O0LsaZFgABwJEpkDxBEt1plJGMVjO0zHDz
	DbIwa8Kxy4t5WrCmJ2nMYfu2tcgDYWQ1yTT6m4kGrWLoGjB+QBuobrxMcV41cMK/NFp7Mt
	SKhTdNdp/m8mxoH9MFn99gpV6Za7LhE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PB1h90kT;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778271352; a=rsa-sha256;
	cv=none;
	b=144waKOm7sO4gQ6Z01PDCPD3Uy7FHzekykCKyG6szrRhu4g2ikeGkcEqcqAixpsMEABsKp
	ZuMIOHyOj7TDq3YfEb9XUH8KFmiyavx9QgcUEg9MS1DiarO8O3et/j4Pi729d9klXzOJ+W
	9RAWwALtiZbHjxMAjjmACa7MKNoKC6g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 73DD46024D;
	Fri,  8 May 2026 20:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FC9AC2BCB0;
	Fri,  8 May 2026 20:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778271352;
	bh=xGiqEO6dUYRjURZgOVt3NlrnKCQ+09veWhc+B1Qmc1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PB1h90kTQ8mw9ftt+Je/B0oATn04C39/MAJwFEl1bdSwsejISNIjj1BAkpOsdLhCQ
	 IDn8YDBZzL8pNFMum53/tAqWJZXkeCm6hmWtVHRVDLScbQfQHenEUZiCOFlyhDoKJM
	 65DwL9frz4OrIwIcg7qR65T4EtxBE1rInRqwBiqGzzwrh1qqkw/MkhnJoH2thCptqx
	 omJhxGd/d8Kdcbp2aaVL+w6oSPo5llQMp5f8YzQAFY2RbkchR0rHCsHG+ljHwWCjaI
	 peWENJOAQSdTlckPQR6wFAx41E+qa0bRd9OwyQ5cTu5IoZLca3zz90r3julKwsRTwJ
	 N9jit3OujNGmA==
Message-ID: <d440b00b-6d7b-48cb-b37d-43f6f885ed01@kernel.org>
Date: Fri, 8 May 2026 22:15:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] selftests/mm: add zone->lock tracepoint verification
 test
To: hawk@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@kernel.org>, Steven Rostedt
 <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 kernel-team@cloudflare.com
References: <20260508162207.3315781-1-hawk@kernel.org>
 <20260508162207.3315781-2-hawk@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260508162207.3315781-2-hawk@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB2D1A0004
X-Stat-Signature: 9hx5cquz4559gunsi85swrrsdkkoxuof
X-HE-Tag: 1778271352-597395
X-HE-Meta: U2FsdGVkX18EbfxwA2Nn+PnfQDNgPyXVKB+YaPvEVMoe9r68rk/Gs7QW3W5lKTmVDn6BxhRWkmC7cHrZ2GEuNGCxsHU07CNzQsbTSGpv/XHHRyglduiO+prmsx0jaG0Mb6ueN00sdwQJ8zryV6pOGbnsQ5GyrXq+KoBqXMaMtHyHMRhZW+SADYyTZZ7ERxMRhScGIih+7ijrIuwbEotmMXQynTOWyu0TNrqkaWjJlAYQd+FeGjmXlE0UDuiYhwlX77uqMlyw7QCW+n4/WdpKZl0MWfEAS1Fhz4H85DA25kDaFshAMtxFm+2Q3OFOHtMDmDu3ukrHquE84A5/nU/TSgs4kBRYRT4jZ40uqEECrpyKEzSBVucKposYx1IOeO5yeKVc+t++x4MM92XV2GdGgv3MQTLbjixUEjiu3ZhRlpkm7niTPAP7YiInPD3MvctNyYadR2PB6lY/zSQ9JDVnYydOzCI39cJHqpcNazHtdniv5ms2gLlVssTX1HyqHBboLX+dgiJVqpz60aLDC7xm73BXVYRkVeP5JiXXaZ2hDSAsj+jL1LigoeVr/Tsy40o4Pc/evmwtRqVRywENGFwrYiU61ScLZWstfjfyPY2Ko4cFVRZmlB75dwrjFMLoFfxoV8JUhrL0zj5lpbl7TcV2Ny6H6TJbBuV1pfjCfJpBETJJPwBuYQhcpvT8vUbUHbdi2j/I3OdxUyrhjIn3MS/dR10X+0R6810sneuT+Q1jQ3sHnbnJOOaqz75u6wxj4Ktlew5GbwUALoUYKuBYhxOEQYaPOKqRRdvvlDufLg62vadN6q7/RMUNCiQZBix1XpZkeSU7Wyk7/BNSQS6nZNQvGubQC1kGaFPb6RYvJfPT6OfbIn8/KiCFGvkWHKNcCITBTMvS3kr+CaNh+ahtJ1q50i4mKgjxTV1JYG7lQ/sa3CVS/VY6ZLwxe2rvq0Ayha4KDM/7ZLqiJ9cAiF3luEJ
 iAFm7gC5
 ILXzrhshzJAT6AdqtSodXslyoB26kjUiV9F9qxhLK7HPNSWCWNfhcvLP3JwAVD+1mgCWRhAsNRXaTaJZRjrlcUnyPtL8kLUWMF1OhwIjlkFa8anCchvEx12alN7E46g0osQ17xBQ+fvtcxIF8mXEPG7eQRjRfHurc9MKvBrGcg6yzHZJA+Uwa6TJuPUJuB0olyPgwyvyPORyP0/g/ck0cuo7Nc71bo8FpNQJHFjcdxWIXa9QXR7fZvGVX1zNm/B1xHeGAzrIr5EpZrzRTuJLN3q+/dg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/8/26 18:22, hawk@kernel.org wrote:
> From: Jesper Dangaard Brouer <hawk@kernel.org>
> 
> Add a selftest to verify the kmem:mm_zone_lock_contended,
> kmem:mm_zone_locked, and kmem:mm_zone_lock_unlock tracepoints.
> 
> The test has two components:
> 
> zone_lock_contention.c - a workload that spawns threads doing rapid
> page allocation and freeing to generate zone->lock contention. It
> shrinks PCP lists via percpu_pagelist_high_fraction to force frequent
> free_pcppages_bulk() and rmqueue_bulk() calls.
> 
> test_zone_lock_tracepoints.sh - uses bpftrace to verify tracepoints
> exist, have the expected fields, fire under load, and that wait_ns
> is populated when contention occurs.
> 
> Signed-off-by: Jesper Dangaard Brouer <hawk@kernel.org>
> ---
>  tools/testing/selftests/mm/Makefile           |   2 +
>  .../mm/test_zone_lock_tracepoints.sh          | 212 ++++++++++++++++++
>  .../selftests/mm/zone_lock_contention.c       | 166 ++++++++++++++

This really looks excessive and ... not really how we usually treat tracepoints?

I don't know about others, but I don't think this is really what we want as a MM
selftest.

-- 
Cheers,

David

