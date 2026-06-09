Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4A5CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0586B008A; Tue,  9 Jun 2026 06:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9820E6B008C; Tue,  9 Jun 2026 06:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897226B0092; Tue,  9 Jun 2026 06:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7BEE06B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:15:01 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 163EEA04C7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:15:01 +0000 (UTC)
X-FDA: 84859966002.13.8069B97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2091E1A000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:14:58 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e2N/6LAi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781000099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oe68d4vJMX8BTuAelw2E6Iqw/eVTlmlqYKm4lxOkTlw=;
	b=Sp2b3GaL7q73466uHjPNC6dIhxwgKlFK7US4uJRe4i98bEhUa8ZIczGWNtZmRaJd8XMGD7
	haD5ynIMyQQJqjahWRxXVMHCQsggSinJC+VxvF+tqrw+eMSAo5J6JKd0P3euPv7vfimszH
	bo6sr3XKqtovAr3REoZMz9o/izJS9dw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="e2N/6LAi";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781000099;
	b=c9sC8EVi55vNEyspE8XHkFJcKWvGlZgY5bc9qQfWrfLzBwKfJTU6NkX4LpY406YPBd+FmC
	VezhtU+/TO7gkwKKvrDwG3i+YeyQwoW8eg8bcl4XN6vIDCjW/hoSw9bSbhEVjbE5GXcRRm
	dtwm1xlNKn94NbXS8BpDsRbwS4PjgjM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45DC8435A8;
	Tue,  9 Jun 2026 10:14:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C441F00893;
	Tue,  9 Jun 2026 10:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781000098;
	bh=oe68d4vJMX8BTuAelw2E6Iqw/eVTlmlqYKm4lxOkTlw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e2N/6LAiZ3lmiOQCT7v1GbceXrHi0XCDbgiPs+4M/QY/AtQXyUFVQBv6VN4/+wwnR
	 9VQDGaGwK3UVL+oaPqcLFD9l4X4AT7sZrQkpBhgeXSiG8a7K7CAwRz1aUAhoGeQeEm
	 qKHVHInPdCy3tMRm59aXN7qSmn2uwxU58TpKXnJm42TH63tVOFoVa6rYwAZTkc8ZgE
	 bJYkg1sCLmFJRaeOPKqr4+NFM1/pNlgp+4u4sPJRyiAlOnVQ/RoBH2nIxGR3z2TNfG
	 Sf/ronQ3jqRYY4B8PIyoVSPFg7wgqO2T2PASbVCkq7fl4L1w8p96FEMReNNhOZySik
	 7+0vy7xtx5zQA==
Message-ID: <aec090c0-137c-475d-9236-fc581bf1c97b@kernel.org>
Date: Tue, 9 Jun 2026 12:14:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slub: allocate sheaves on local memory nodes
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260601095706.106551-1-hao.li@linux.dev>
 <33506b25-ab2f-4f31-a380-7c0fe65567a3@kernel.org> <ah-naIiz09TTBpXo@fedora>
 <5d8abe93-edd1-4b18-9ea4-7731dc831223@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <5d8abe93-edd1-4b18-9ea4-7731dc831223@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: uqdhwqcwd3kyodkrkz3efzzy6nn5tppb
X-Rspamd-Queue-Id: 2091E1A000D
X-HE-Tag: 1781000098-451157
X-HE-Meta: U2FsdGVkX1+GkaY5dCdeMa0KqIPSgF8MEbhGCl7M7pq+hSgAKE9/cuTxjxmetVFiInL696aB725nPYUmbs+2+Tic27z5y498wu5hcp0kX972mlB3mdWfTZj7GSSgpZR056WXwF7CQCHdxr264kBgwqVBtEG7yS5fQs6sr0dg5zzXzbmX280cA6lR78ZecEepWKCSvA1EH4QrgigGThsI2bwcouNu8PATm3/rgVjWhHobeitSL6DwbMSK0pFEj0Ztge2u/X4kcG8h0mxJnWOMjF6IGcvzIBB8b+xZY0ImJ0tpv7WcJIz2b2x2MnpGQRoYaGBDYkPOLAQ3fkekPjXn+8DGspSWVDQT7YdfQ52ORr2LCNoWnWx66CPmMSUJh87d+4ku9OdxRAAw0ioCA57HfrIISAirjdIoLjfycznhGgcSFykr0J1Rwv54BBatFcQybw4bWvE0TtRXvqQO4Yt48OIYjVGQVxXKoirZWVxOHgJkrDDDEQpxeVgw3/ZNSLHnXbHMDhYVs2hFnwjtxhQQrCBw1Clzv+/QbUvsN3p79way5XtMgJNqyi73fHnJXBp5boBfcBlOS704pICCxj11FgA0TE5fGxbaL922T72mBADbLYMdN5Ud2iihXZ/qe+kWeVxayVrTCQ56kT4GFc5CTdp0tFyYDi3T8gikUxYa5n4iKEqLsyRSImhzVY+92V6RKVQjtOC45k27zBKMnw+AiMo2vIlcnrwlAuWI5ycf7FvMZdfY+J2aMVFINYvdqotVlDAQzVD/1DNv1HThC/6bOZNcLjUkG9mnGflS9oahICpttdTKRqIr61Lt83tT05KTr7sP/OiOWn8bGz+xuSgogow193tYHox8WHKbjiB992k0BTQBhJHAZCkcQgDlrPyelm4ruJdcLHiKN9UEmHdZ7zlh3OZjuGalv4tkcXVdf7L1Ms4ubT7IPFHw7/mDdxPtj65R/uUi9jNm8j5zkUI
 xndTorb4
 jNVD54LzT4XvWx4islckT3+y7TeNg/KxzsDy4MKq7efKBLqDC2WpHARWI6FAj3MQtn8lZ27Wt2ja4J32FOwDCtLl2jakxUlSXshi3GPd0QFJSYfCmikfRQrtt74HJV90PGVatvio0a90fU0wqkU5bO36i3prTa/LO+XcZzCA/58yZvUnQel/PMqSYTHXFKAyLH17b1jR8mVRdGqEs/GAwK7/Zv+0dDd2Qnk44HtZXJuNC1jz1x4VHlChMzSgtzurekCwG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 05:41, Harry Yoo wrote:
> 
> 
> On 6/3/26 1:26 PM, Hao Li wrote:
>> On Mon, Jun 01, 2026 at 08:28:16PM +0900, Harry Yoo wrote:
>>> On 6/1/26 6:56 PM, Hao Li wrote:
>>>> Sheaf structs are exchanged through node-local barns. Since barn structs
>>>> are already allocated from their local NUMA node, this patch aims to
>>>> allocate sheaf structs from their local memory nodes as well.
>>>>
>>>> To achieve this, the obvious choice would be using cpu_to_mem().
>>>> However, init_percpu_sheaves() and bootstrap_cache_sheaves() iterate
>>>> through possible CPUs, whereas cpu_to_mem() is only initialized for
>>>> online CPUs. Therefore, we cannot use cpu_to_mem() and instead need to
>>>> use local_memory_node(cpu_to_node(cpu)), similar to what
>>>> __build_all_zonelists() does.
>>>>
>>>> The primary goal of this patch is to improve NUMA node locality.
>>>> Although the actual performance impact is minor, it still yields a ~1%
>>>> improvement on a 192-core, 8-NUMA-node system when testing with the
>>>> will-it-scale mmap test case.
>>>
>>> Oh, nice :)
>>>
>>> I have a question though...
>>>
>>> I wonder if would be better to handle this by e.g.) not returning empty
>>> sheaves back to barn and freeing them if the node id doesn't match and
>>> it's not a memoryless node.
>>>
>>> init_percpu_sheaves() and bootstrap_cache_sheaves() are not the only
>>> places that can allocate sheaves from remote nodes; sheaves allocation
>>> could fall back to other nodes and then SLUB could keep reusing those
>>> sheaves from remote nodes even after memory is reclaimed.
>> 
>> This is a good catch. In addition to the fallback mechanism, task migration
>> between CPUs in __pcs_replace_empty_main() and __pcs_replace_full_main() can
>> also mix up sheaf structs across different barns. So yeah, changing allocation
>> locality is not a silver bullet.
>> 
>>> If this works well, we probably don't need to handle it in
>>> init_percpu_sheaves() and bootstrap_cache_sheaves() at all as they will
>>> eventually be freed, while covering the other case too?
>> 
>> freeing the empty sheaf if the NUMA node mismatches instead of putting it back
>> into the barn is indeed a good idea. I like it. But unfortunately, my testing
>> didn't show a clear performance improvement, though there was no noticeable
>> degradation either. :-(
> 
> Hmm... the idea still makes sense to me, but yeah, it's not late to fix
> it when we have data to back up.

I think if that approach doesn't complicate things unreasonably, it makes
sense to do it even if there are no clear wins (as long as there are no
regressions).



