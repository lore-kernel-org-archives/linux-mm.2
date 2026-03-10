Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F773FCC9AF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 04:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6F26B0088; Tue, 10 Mar 2026 00:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 464906B0089; Tue, 10 Mar 2026 00:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3701B6B008A; Tue, 10 Mar 2026 00:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 241076B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 00:18:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5CFA160440
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:17:59 +0000 (UTC)
X-FDA: 84528845478.17.00BE15B
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf22.hostedemail.com (Postfix) with ESMTP id C146DC0003
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:17:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iuDSOn1y;
	spf=pass (imf22.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773116278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yt6x+E9G8bhHLBAbORSNHeQ7FRJQ5mKhDBf43c4KJEA=;
	b=D8xNFdCpUIdHzLnLQM7q98DH+pfmpsY409AzVFfcfIp3eoZwlHmxywRhQbcJAgrcIfkC5H
	bc6OuTuJdJ4OwoQipojxTDWJcKAirKUROtbS5nuzaZWiwhrajqLZrX2fyy8PIwzPG0pbZm
	aRGNPQQZPJENBF5E0+G7OwhkKlEvr5M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773116278; a=rsa-sha256;
	cv=none;
	b=wlbrT4Y7Jdjn0e716UWyoLDelzFzfVpqPwJ0kx6or51B0An1mBW9uXJ/TRvscRY3aUGAxs
	7kqAozGIlfxg8G3fwkFeRFCFD1XL2Zo/by1BJURGNHDp39EbK7O6t85VMV35MVLFiq4IO3
	W/6BwnI3/F+qdxdUE9qF5tLBa9pLsnk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iuDSOn1y;
	spf=pass (imf22.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <dcf2e654-ad2f-4390-9b62-078e664158de@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773116274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yt6x+E9G8bhHLBAbORSNHeQ7FRJQ5mKhDBf43c4KJEA=;
	b=iuDSOn1y6V1DqIsON7tHkFy5Nf6ZsyQnerFcze7MRHwWzGLSBLAtvA3+rhb7NBNX/FrEBH
	xJO2vvJRVh8zuVZ3005BQ9IZ80iwWYC+IphE4MgFYEZdsFDyZGxWu4fXAhG7RORtkV4/OG
	JR3oBF9lm1h1HGlqIu4kV0DLpC5Gr3w=
Date: Mon, 9 Mar 2026 21:17:43 -0700
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com,
 vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com,
 byungchul@sk.com, cgroups@vger.kernel.org, david@kernel.org,
 eperezma@redhat.com, gourry@gourry.net, jasowang@redhat.com,
 hannes@cmpxchg.org, joshua.hahnjy@gmail.com, Liam.Howlett@oracle.com,
 linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
 matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org,
 muchun.song@linux.dev, zhengqi.arch@bytedance.com, rakie.kim@sk.com,
 roman.gushchin@linux.dev, surenb@google.com, virtualization@lists.linux.dev,
 weixugc@google.com, xuanzhuo@linux.alibaba.com,
 ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com,
 kernel-team@meta.com
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
 <aa9aDGwk8YteaEob@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <aa9aDGwk8YteaEob@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C146DC0003
X-Stat-Signature: o5ekx6kk9cjqrb3cb8exipdizp5z7ime
X-Rspam-User: 
X-HE-Tag: 1773116277-508530
X-HE-Meta: U2FsdGVkX183w8pXs8iSzprUN7G3Zx0jH/Q+vLmHCI4QqrgjH1jYmclWzGzWKv+3Lp2tKPbc0K3ugzAAhi0/yDPloveMN9A2mmUQByBSQLCSJSl5SbXdOD3aPZCPwhOKzYdZRPCcA7GhF+yiKgdy3Pbu4FXKz7VKJ5pbbMy6Q/OWXREbqe/Q9HPAaMg+iOFT0sRs2Fc7HUuZRLumfUrXT0iyHJF2l6xpWMIQ2geTMnDuok+ugjoZuIUg1Gl25A7S3fk4nLfBvKWNnrD9ce1TKVR4WExzcH7LinmG40mc2ei0RTxTsrszqJ7cYZdVG1MfM+hHFgNUPJ8rX3qN9odTH33VsiI4/cmq0vpHXp9W0JFT80LaAf0PrQKvkMNRk4saOd+uatyuiStEMqsNUfPYFrX93X16BbliF55N+6UYQ1m1gGWB+gEdfHA6ghBqgD6xWtMcdwrsI6IuB8N3ZML2IRk/qs4iUJw5MuC7nFeN4jKCP4zSBX6Ntf/KWZuryS6ivFxP6DX+K/Y1xLivIxaBI8TgQ8IaCCMwH55tngkeQzcfjA3hNnQHewOmF4yzizTo2cIr15PJnxOPcBSeP026tPJ0Zf5LiedyfSkKz505Gue2lY79TPHmIAKnyY6ys+k58ixjZ+E0JvWp3oJcruDEbcaXn7/1gb/t0iaikFpiIKstU4fejTA4vELb3W7lAbRwnZHO/BhuJh2PNAT+gNTTwr2alpKRpncmHWoFWupNRDSehLu8oVdojW1JUtXv6cRb/JkzezESMKz6T1N1IQdf+RtkXK6ytJe29kzUJ8hr/malF50j8+H8kXszszYb+oVR+CwGw/Kq/etyr44BqObezaLfHKTbyrc8EL4YPs+W1wZRXl6/Rh9jwtv3ljzpYhDYw3DGYgFSyoPEXiR5AFoemttZnCWD96sUmpNhlWAFxEzta3et56JSS4GCxvLrr9Jl7XCyF9oSW2wzp6YKdio
 H3cEUyB3
 SApc5smVwkMbacGSzyHxZMyThuCsQ366VqGeofP6gFom/xSzcYO84EsfhPFybDGNABdlK+YPWH0SizzqtVha11ri1bv1LPRtXwoOjTcfqFrppD1TuOp7dvsZfpl2RGOgSO5SxiWlwyotJcz6bCAaaxqXEDHwofvSNZwpTnQlsE9Cy39Xtjw3T6qeG4fYuVoCaO9qsUbHwCcdE3UxjJ3QQ45ZFzcIJl5TcH11vMzR/No18JtiiDaq+xNFzWLkXntJgAs3918hnNxhSA6AmdFyupRW7A3eL9oTYBQUw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 4:43 PM, Shakeel Butt wrote:
> On Fri, Mar 06, 2026 at 08:55:20PM -0800, JP Kobryn (Meta) wrote:
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
>>
>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
> 
> [...]
> 
>> +
>> +	rcu_read_lock();
>> +	memcg = mem_cgroup_from_task(current);
>> +
>> +	if (is_hit) {
>> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
>> +		mod_lruvec_state(lruvec, hit_idx, nr_pages);
>> +	} else {
>> +		/* account for miss on the fallback node */
>> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
>> +		mod_lruvec_state(lruvec, hit_idx + 1, nr_pages);
>> +
>> +		/* account for foreign on the intended node */
>> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(intended_nid));
>> +		mod_lruvec_state(lruvec, hit_idx + 2, nr_pages);
>> +	}
> 
> This seems like monotonic increasing metrics and I think you don't care about
> their absolute value but rather rate of change. Any reason this can not be
> achieved through tracepoints and BPF combination?

We have the per-node reclaim stats (pg{steal,scan,refill}) in
nodeN/vmstat and memory.numa_stat now. The new stats in this patch would
be collected from the same source. They were meant to be used together,
so it seemed like a reasonable location. I think the advantage over
tracepoints is we get the observability on from the start and it would
be simple to extend existing programs that already read stats from the
cgroup dir files.

