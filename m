Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FABEA8554
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 04:31:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68A4B6B0088; Mon,  9 Mar 2026 00:31:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 637D16B0089; Mon,  9 Mar 2026 00:31:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543766B008A; Mon,  9 Mar 2026 00:31:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 407F66B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 00:31:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B30D5140CEE
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:31:41 +0000 (UTC)
X-FDA: 84525251202.29.6DB7C2C
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id C1A64A0007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:31:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w60laVuz;
	spf=pass (imf25.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773030700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Z8d6If/2x6c+shmsp818rCRLczc7yj9JjP94B94wZo=;
	b=bMxqlcfRga6VtRK2cDNc7IMQJsDlTrFttzXc8+md/tR/UggGVFSL6pZ4Gm1FGR8mYIHrzW
	6dJ+r9TWJz55kTM0zs8zeSdUsmwwAOVxDdn/JTiRNPrBLjSsvXTdtwAm/a3sG4H0lEXc8Y
	Xc54HnnesvNReoU6mojSKoo62G/nrP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773030700; a=rsa-sha256;
	cv=none;
	b=cTMymJ42zAZTqqhhhLNMX/M4ksnCRLl8SJQITttxebinOmx0pYRakp0CLLMDdIh5RBJ5PP
	S5z+ZpU5pofVzgoHTE7b7yARt057DW+YEEoAviAOcThIP0av4m7JKBYinVBfEM3AUywe2j
	LYQBqMZVwW5OnX8XnHnRoWcCGlKwDkk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w60laVuz;
	spf=pass (imf25.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <977dc43d-622c-411d-99a6-4204fa26c21e@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773030697;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Z8d6If/2x6c+shmsp818rCRLczc7yj9JjP94B94wZo=;
	b=w60laVuzxMfgneDLmcGSncQulMv7DiH5dqJoxdCsYWpE8iCxDAKH3XOJqzZ7BYKbjXuC2f
	m4PBC5/9rxWlIn2qNOv8r1XoZe5H5UmUNQfyXAVyZOmENLXvznBURl2nQXLeLnwls+R7pC
	mrytVteNtBzEZcTlotUaosuQ0AJ53N8=
Date: Sun, 8 Mar 2026 21:31:27 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, surenb@google.com,
 virtualization@lists.linux.dev, weixugc@google.com,
 xuanzhuo@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <87seabu8np.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <87seabu8np.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C1A64A0007
X-Stat-Signature: r1kdm6a77neh84ij7d9u18871kr63mz1
X-Rspam-User: 
X-HE-Tag: 1773030699-309101
X-HE-Meta: U2FsdGVkX1/tI48seCwr2n7ybv+Qd631/GxwzTLngz3m1HEFkmdIoFWyqx9FdXW5jaE80FKie9b3PW4LfqWm9gAE6aWUSsu8FZ6l4noYbz6dm+qrO4DdzjXscDE8yoKfC2avmRy8rVaOflWZLZwa8nGvp5CPzr7J+bb9RP5Y8lydKt3i5AZeuuxfRqlRJ/8tJdEH6SsjfSiQCGav16G4U1Aknxa/9JS1+KEpqUWDGJSO6JXi9E7jxUd/1GZWYBsdY8uQc9Lpaj5mEQuagQ6XRdpXlgq3jaUCO26alhLIQdAC4I/0rF7ouV+B5unyc5R4CYlre540QYOLJ8wfF4mNwS1R4riRz0cGbP3b7J/FTYf6jag4vmsE+8t4ZPaIDfHnBaM643C1d6YaTV1wCHSm08vGVBIE9ZiczAI2dklRCiWtI6iVaKITPakyupuadQatFwZpo7OvM+A82t2fCzsWb7tf8jTq0369ZJFtEtRcQL//X1jwqNZXZfad8TKpXHJQWY6EifJ+/yjlbYB9/NsIA/FaDpx4rgrwWhjpWwcM9NYl+HXxGTjosKqFyiTWbXfN+0iZysBxR7ZskEVX9X5KhMS5rWe+MlQaYd1bCpiCXgt4tgDpInn36OpsGTz5M8wry6GQ6qI8Uau3XzCq+IiOd36StfL07xkAZC8qqAxZakFEdr5jPjNKbYjHeNKK/Zd+VCsTy/7sGg65eSjSiyiwKWySw+g4Hi8BGFM8dholz/ho6sH8m956rNU+/xGE1Ibcz3wZ61U8wBju2s14+Z6ia14Uj3Dq7UC3Mn+QCPDufLNinGRBqsscuO6blCtD/HsLdGtKcYT53eaEUoHdalE1UyRVMwptrUNOZCOQUIpI7gzBCYvE8mx5bqh6daFZ/fwbEby5l8qsesNF9+7vu+LXNi7iTHIs93TMvn8tAQWOjV1Qf6k/muWmK7GULrxUWMWpqZNgp9tOmbT8w7YzneC
 KxiyvH4L
 3j70eixsGduQGgrBLkwHCCG9V2zqwHW32OSkqzFraTWoLOXHF8LrqxHgHOhgnY6T3QscAWJUKMKXz57HdApktQK2F7BgJY5q4nGbAgsRVHpbcxBUWsQgBkl3BaBnPOMfSONmAPEjNf5oNAhIW8TJNyBHIoVv8kEb1njknoM1apDINOdz3Zoki4CG5Jziu7f8Vu2ONr2QPfr0thEchTYCiX17uMUslZJW9jZLVZH53C/x8zwmtLOg/LqutlsOGUSg8UtAPgvhDl8RgxvvsQ5JckSN32O0Ud9USNoQltXfwXo/6rmLXkkIBnVnoRo4Jw44sHfSgwj5M+LVpHwE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/7/26 4:27 AM, Huang, Ying wrote:
> "JP Kobryn (Meta)" <jp.kobryn@linux.dev> writes:
> 
>> When investigating pressure on a NUMA node, there is no straightforward way
>> to determine which policies are driving allocations to it.
>>
>> Add per-policy page allocation counters as new node stat items. These
>> counters track allocations to nodes and also whether the allocations were
>> intentional or fallbacks.
>>
>> The new stats follow the existing numa hit/miss/foreign style and have the
>> following meanings:
>>
>>    hit
>>      - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>>      - for other policies, allocation succeeded on intended node
>>      - counted on the node of the allocation
>>    miss
>>      - allocation intended for other node, but happened on this one
>>      - counted on other node
>>    foreign
>>      - allocation intended on this node, but happened on other node
>>      - counted on this node
>>
>> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
>> in /proc/vmstat.
> 
> IMHO, it may be better to describe your workflow as an example to use
> the newly added statistics.  That can describe why we need them.  For
> example, what you have described in
> 
> https://lore.kernel.org/linux-mm/9ae80317-f005-474c-9da1-95462138f3c6@gmail.com/
> 
>> 1) Pressure/OOMs reported while system-wide memory is free.
>> 2) Check per-node pgscan/pgsteal stats (provided by patch 2) to narrow
>> down node(s) under pressure. They become available in
>> /sys/devices/system/node/nodeN/vmstat.
>> 3) Check per-policy allocation counters (this patch) on that node to
>> find what policy was driving it. Same readout at nodeN/vmstat.
>> 4) Now use /proc/*/numa_maps to identify tasks using the policy.
> 

Good call. I'll add a workflow adapted for the current approach in
the next revision. I included it in another response in this thread, but
I'll repeat here because it will make it easier to answer your question
below.

1) Pressure/OOMs reported while system-wide memory is free.
2) Check /proc/zoneinfo or per-node stats in .../nodeN/vmstat to narrow
    down node(s) under pressure.
3) Check per-policy hit/miss/foreign counters (added by this patch) on
    node(s) to see what policy is driving allocations there (intentional
    vs fallback).
4) Use /proc/*/numa_maps to identify tasks using the policy.

> One question.  If we have to search /proc/*/numa_maps, why can't we
> find all necessary information via /proc/*/numa_maps?  For example,
> which VMA uses the most pages on the node?  Which policy is used in the
> VMA? ...
> 

There's a gap in the flow of information if we go straight from a node
in question to numa_maps. Without step 3 above, we can't distinguish
whether pages landed there intentionally, as a fallback, or were
migrated sometime after the allocation. These new counters track the
results of allocations at the time they happen, preserving that
information regardless of what may happen later on.


