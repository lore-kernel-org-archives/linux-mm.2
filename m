Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49C0BC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 07:50:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA806B00A6; Wed,  1 Jul 2026 03:50:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D1A26B00A8; Wed,  1 Jul 2026 03:50:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E7386B00A9; Wed,  1 Jul 2026 03:50:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D10B76B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 03:50:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 493B41C6C31
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:50:24 +0000 (UTC)
X-FDA: 84939435168.24.909FCFF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8EBFCA0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 07:50:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5XgoWqp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782892222;
	b=2EkenfKbrYcAkQNJW5n/59ABxJQzvCcL/ZlskAV4qialvGAcbrzd/sMSnTj0/nS9CH1Aqb
	2lHwKixO4GmdTAE0SsNl343mpUy2BPnu2tmvX73ikW5LElxq9KWYj/27+qcOEFs625tvhr
	O6B9Qsk03DPaMnPtmv4mqD9b5f4dSMA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782892222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACIqJsYxWgXDc37BwygX8M8U+XIaq9Ci+P15yYStBqA=;
	b=al0VqboDmQ8VjDG/EqkEUgXGZZflch1IS3CL/a7S2T1k4fVwrlxyPX7gKw1io6DMxroknr
	B5vQehyO6d8aztYxI/LAax8c5mJJur7k59HNv7xYAFZAuWhVzUN0PNNIyD0lYu+aDF7dlx
	ZUrn+Aww4KwzXhcEntefzMVIiyTE4bs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d5XgoWqp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0AB226001D;
	Wed,  1 Jul 2026 07:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1423F1F000E9;
	Wed,  1 Jul 2026 07:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782892221;
	bh=ACIqJsYxWgXDc37BwygX8M8U+XIaq9Ci+P15yYStBqA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d5XgoWqpOyTOQVH5rwBuq0PHSIVGdmT8b+Y3yUvZV7SGqjXADrPCV4qZ+t0B3Te/G
	 6LDS1Dk9khtR31sBe854tYWT9zhEHXJj4gYJEimA4bfCh+N43cKHhlIwlKmDmU7gho
	 SW80Hty7/snEV0VsTQlAamA1lE725VM2s+JKnx28jM7r4k5wke56wyps3mByV47Mdi
	 +osugshquv3hVB1ys4nVCGLrWAR1WbmQPO6gpgu4oCqIn0OHidEQY1Ljihq0e28YQj
	 mpyiIgQcFZ+gDstNyttbpw0WBPbVQnz3uevEM1nVgY5Dm+KecgNb2I27zOM6rUQpfa
	 IjefxTGNrirjQ==
Message-ID: <0970fd28-3659-40b0-8276-3a1daa3fd712@kernel.org>
Date: Wed, 1 Jul 2026 09:50:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 08/16] perf/x86/intel: Use higher-level allocator API
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 Alexander Shishkin <alexander.shishkin@linux.intel.com>,
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
 Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>
References: <20260629-alloc-trylock-v3-0-57bef0eadbc2@google.com>
 <20260629-alloc-trylock-v3-8-57bef0eadbc2@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260629-alloc-trylock-v3-8-57bef0eadbc2@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8EBFCA0004
X-Stat-Signature: ugucnpb1e856aq1iitrabrkqxa6wwxs4
X-HE-Tag: 1782892222-942990
X-HE-Meta: U2FsdGVkX19N2jiWn/9A2nMzuUWOUYbCLVEs32aip02J46lUQhvI4pUsrIxH1GZTZX20CcgouX/a/iZRTAcX3F6uf4QQwBUgYt5AlXkPS4zxoVVnVckcA3uOURmxpmZ2GsF5PeEdY3quX+CQaouUejvmetUBpDrgNQCGuonCExz4M9YFxtT/zwPK2cZB/g31QQbrQJHzAN/Fs4a3EwSbMjnnDwn67DgvljREC8JM4hAyv4+pvNuMRKJ5VPVMcNORrqeR6YJffd8lOA4X+uIKd3pRgJ8w89Tqs8hrW6KEw4sNDz/KXCXup6uPF+RLZ4nE434KhvPLHldNyjHGXXp1MGaJeIj+p67p4INFw6vlN8t3H2Wl8LE0FOZS9EyS1k1IpNwS1Dbk+/KuYbn7t2P4XZoRZ3fhB3LSRNU/SmF+yESiZedabvyuhG4sUu5irBnIpTW4bi5Ucocp9a/jtfz5pWrIv7SYe63TPIgzIlxRy5c9wd3yy9TtqL6piAtOolbRZmrznL8n39B4ozwSBvxHk6qereDVOki4VfokHPBlctUO4GlrjeZCXhcmY7ELsdi5Mw+MX1qt6EfxxVAOcJCP0P/nnyaRBlnvGyTzQKi37JXYRz27HY3IzBqSC9Z837eJ9sGjvGbcuhTfIY3n6rY6EwFJHJ4qqdNHZcHaBY4IA15dwSxKT9wimeMOmSeqpnTYCusKoRULeVWTp3PgPVsKBbVA2gKH+3E7a1oDDCeT4TEuf0mHVbLp+SjfaEmzqILxwsBAo7D+sV2ChLBZn1VEI4DVcAMrWxRGIqs/fxrIGDlh6BjRyZzL/NaXmBaKgxwib3qEThlS7YLnt6/u4tzwOQo9APzbuCmBe3VBrezfoPFW5Lyb1TIPycKqeMRgx0QOmlA6vhHR+gFy8ocQD6YiLYH5oRU6OmuBBqA/6cXz3m5abLE/J7TzSPzgENacVuhGF2g+Y9AlIUR6ZZQQ0AM
 twxqMRfA
 O50UP/jXLu50Iq3oarn1fcZkmNEa5p93tF18LgXRXS6nKGne3GTkMrkQF0P3jXwBjWdNJiy6PJIKssCPC1F5KlG+/agfWST7qagF+44wq+knGDhKjmukbt9eoqTnp9LDaAN9Eb60EqeA/XiBnO6/cuD3WieKVFVzmcMgiC/iu7DjxdI7InE1E4g+3d4MLQ80MxthPqWlPbsisFmuG6D3Ht6dTzG1WsRJ2XZXIOGMZaOJd+Rh7OwrmBzXv/9i/Hx+VGp3gB/SnB9oS8SrGEn5QttWULtLPVrs6KQ2ESaj9jJGtE5uLGY7haxY9Nekp8eT8s0b5tax7kVxEak0igxOV5tkSEWNhuURgORAHlCDztV6lqjpRb/F+D3AWgevJCHRutWqPiqHR6VXYifhFyGSKg7XHePgCqkPOu6JQpSQCBX9wUjyYU/GSfx8GQo7/AXEVlkEwKg8YfrFnWl/S+INyMz1ftF9uVZ8/gY+vwmhbYhGiWWshzp+SDhDIIjlQo6X7epR9hG8rZJNUUWcn9CU1utxHi7fGqWl01VKFJqEvUkdQHpPat/Laq5fhBYn0+976jsEFNdUHJSJAyS4a5b0VJKUaPF1vRToxZyBg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 15:11, Brendan Jackman wrote:
> The difference between __alloc_pages_node() and alloc_pages_node() is
> that the latter allows you to pass NUMA_NO_NODE.
> 
> The former is going away and the latter works fine here so switch over.
> 
> No functional change intended.
> 
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> Cc: Ian Rogers <irogers@google.com>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: James Clark <james.clark@linaro.org>
> Assisted-by: Gemini:unknown-version
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  arch/x86/events/intel/ds.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
> index 91a093d8cf2e7..70be80211d823 100644
> --- a/arch/x86/events/intel/ds.c
> +++ b/arch/x86/events/intel/ds.c
> @@ -832,7 +832,7 @@ static void *dsalloc_pages(size_t size, gfp_t flags, int cpu)
>  	int node = cpu_to_node(cpu);
>  	struct page *page;
>  
> -	page = __alloc_pages_node(node, flags | __GFP_ZERO, order);
> +	page = alloc_pages_node(node, flags | __GFP_ZERO, order);
>  	return page ? page_address(page) : NULL;
>  }
>  
> @@ -1088,9 +1088,9 @@ void init_arch_pebs_on_cpu(int cpu)
>  
>  	/*
>  	 * 4KB-aligned pointer of the output buffer
> -	 * (__alloc_pages_node() return page aligned address)
> +	 * (alloc_pages_node() returns page aligned address)
>  	 * Buffer Size = 4KB * 2^SIZE
> -	 * contiguous physical buffer (__alloc_pages_node() with order)
> +	 * contiguous physical buffer (alloc_pages_node() with order)
>  	 */
>  	arch_pebs_base = virt_to_phys(cpuc->pebs_vaddr) | PEBS_BUFFER_SHIFT;
>  	wrmsrq_on_cpu(cpu, MSR_IA32_PEBS_BASE, arch_pebs_base);
> 


