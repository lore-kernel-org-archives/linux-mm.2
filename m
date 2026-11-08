Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7D9606A323
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 12:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=YR63dAao
Received: by kanga.kvack.org (Postfix)
	id 665446B05B0; Sun,  8 Nov 2026 07:49:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 617646B05B1; Sun,  8 Nov 2026 07:49:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506F06B05B2; Sun,  8 Nov 2026 07:49:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2890C6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:49:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2A1F1C3B5B
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 12:49:42 +0000 (UTC)
X-FDA: 85411933404.29.2394C59
Received: from mta0.migadu.com (out-10.mta0.migadu.com [91.218.175.10])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8D55C40003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 12:49:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YR63dAao;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794142180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lK9pHrkcqJPTuUbe/F2Tx6U2WAl5/AGTU3cpzcdSo4=;
	b=O+6FX4nswK2FQIyFfbuyh7gkSKdxSFaKkgDd+QjBzbCyAwnhwtEROpbwIYuEq6+CLgO/CJ
	suKRl1nG/h8SdqlG+C9ZknC1fwXH/6fhUcqkFVWnfCs+FTOs6jviIJw2fkdy/7M7M+SUlc
	tsXCf4H+zhpTa4PNm784U1GWzJDHxss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794142180;
	b=UeQ9P4M2+khpVvKaCJK6E7W4Rf1HclaUd3ZLE55BU4kqLlWtZGAoc3PKIIBOtVz8hvkueM
	dk0tI/3b75MF9r+VZIvFtvsbdx6561zvuS/OBb21qVKh6XfGfQTNdehrr5gg7NhTfJm8N0
	IzEMDVuJjmxcJmpi08UGafl90GtUXv8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YR63dAao;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.10 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PNfl9BuOnFonm6NGFSqEPPijub+CPM8DqK2sRwQhsVM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794142177; v=1; x=1794746977;
 b=YR63dAao0TX7lAVI8UCmQdazdxE0paNduCorTiHudV98fFq6+xeTi4Z+InjsKESA4NJF0JpQ
 nfW/BJDrJcdUGy5DEmzGwzGuSKBV1XKJyxxMpLt7lfn9YaTOcMdnVV8AbdEl0ajKkza7Z9GpnoM
 5DZnvSPwbRxkocJ1NLG4/2vg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 55ae0acc5f595fe2;
	Sun, 08 Nov 2026 12:49:37 +0000
X-Mizu-Trace-ID: 55ae0acc5f595fe2
X-Migadu-Flow: FLOW_OUT
Message-ID: <bcd19107-b398-4811-ae73-e1e87a551bcb@linux.dev>
Date: Sun, 8 Nov 2026 20:49:23 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/3] mm/mglru: move lrugen atomic stats off the
 read-mostly lines
To: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261105132220.2233677-1-ridong.chen@linux.dev>
 <20261105132220.2233677-4-ridong.chen@linux.dev>
 <CAGsJ_4zLN1gXtDhhe1cvmerjOS=SAm1v2nnQm8u9ha9JADN+1A@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4zLN1gXtDhhe1cvmerjOS=SAm1v2nnQm8u9ha9JADN+1A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nzobuwres555i8saj3gjcms6yua1ebj1
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D55C40003
X-HE-Tag: 1794142179-53114
X-HE-Meta: U2FsdGVkX19Tt2yC3oRjx72Xp3jtOS68KPkAJMn7REB5fdO5ZKkALl9pavNSD/tWf5IK0ywgoAlv0SBfUvmEPp0WTQIcA9rq5XRedqfel8t/lIlYtB77+k1c7NGXogl09dzI12pcShRDTSNjRBQpVyCconH1+FIudKUd0a08P2ccPCks1hJxTRqZijPETn7lbLb30O9YTYUp/pRx0jlMjomfnkk2OOxR+L2vshovaME2r2zdSJVDjx0RoDyNsyvzbUE25vhOAx10XLZiXASm7PQOSAOzCR3dLSu+Njz69aaD804pB4jnQOOOpPlYGxRvntf/TUFrt4rq79yJC5R/1UyI7WzkVwEOcJXBkAtaWNvCYsL9qrLWSuRYhGrTskcFBbpYNcNJtGy6jIgWPziRVdqATFCJWaAVxRKE2B5+puJO7Kb02tH/AJ49iCwi8ZUbGzULqSvMimLW2OyLg9Lekn+qDBJNLSdmRh4f9rHz87Tml1gls9ZpeBpn0n67S6ScKWcNQqv6cYvLZPoMVXvB+33+oz+cJf26QyiHCQLcqjWOcr3JMHSEnxkQu5CEOEE1mKoIr7FLf44Vk6nkF9qpZBjaQeh2ox7YSD4WQnuF1TTsJsFAs7luCKT8XhCiAIfqODG2ELwaXLZ+EMppaka4lX2rKxH29kl+u0Ws4YDlCebTMbkXJz0SIHh6nX77Y7K2R5UVKebSOh+GuL4ZSVpwFIppfZkRBlhCzxQU9pKZJoYG9FG3WzKLZr8S47I7SZGvEoDrxG2IBWgwYetlPcEs5ePuZtNGByXi1F15CTtVpXW720HUbtni5KPZVavcMOe1VK5Iyzl20R74q+K1t61Wmr+LIqin3GlqLfDqyVn1iyI43LkpDaR6mFQNAVweZUbAEYY+Y0AQoBCiDwEhkTqNcc6ar6ZG8/LU5fxMtNYjrbY+Vt5DcMM8qL7/uO/vsyVbQeu5oec7OZug2ywEE8j
 LkCVlvca
 9YYtTWtDdt7pHEiYwTaoHcNlXVxthTFPomnXEXYVFiG+Q2g3610EqlufGB/glHz6bmJ8VdpRWrzrSsMXgSnNcUohr8xEW+FWOzrM74BHocUQtWHIulAbJ3vR4tfTMB3uDjEpgH/n6wU8qFzMlqmEaOx74cKbuz5REkFVg5151Dut6crZgC4I6Ubcmb2jSnYDQfP2vRqd4SN1DgR5ObzhsjhRIc2f0hSrZvCYHmQZnbNnYoyOUcIjdpmeuI65jf/rxfFVrLLn8dgq+enE+HYc8bqgAqpksYfvXZN9yAHG6VZ0iFT7uWwuYTAAmWKQi5g/UQb/NyBTQarWAOc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/8/2026 5:14 PM, Barry Song wrote:
> On Thu, Nov 5, 2026 at 9:23 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> lru_gen_eviction() and lru_gen_refault() update lrugen->evicted[] and
>> lrugen->refaulted[] locklessly with atomic_long_add(). The arrays sit at
>> the tail of struct lru_gen_folio, right before enabled/gen/seg/list:
>> with LRU_GEN_STATS=n the file type counters share a cacheline with them.
> 

Hi Barry,

Thanks for the review. Note that the sizes in the changelog were
measured with lockdep enabled.

Offsets below are from pahole on x86_64, LRU_GEN_STATS=n, counted
from the start of struct mem_cgroup_per_node (cacheline aligned), so
line N = bytes N*64 .. N*64+63.

The nesting is:
     mem_cgroup_per_node
       lruvec                at 128
         lrugen              at 128 + 176 = 304  (before the patch)
                             at 128 + 192 = 320  (after the patch)

> So basically, this is causing false sharing, right?
> 

Yes. Before the patch:

field                    offset       line
refaulted[0][file][*]    1608-1639    25    atomic, no lru_lock
enabled/gen/seg          1640-1642    25    read on every LRU add
list                     1648-1663    25    read by shrink_many()

line 25 (1600-1663)
+------------------------+-----------------+------+------------+
| refaulted[0][file][*]  | enabled,gen,seg | pad  | list       |
| 1608-1639              | 1640-1642       |      | 1648-1663  |
+------------------------+-----------------+------+------------+

CPU A (file refault)		CPU B (LRU add)
atomic_long_add(&refaulted[..])
				read lrugen->enabled -> miss
atomic_long_add(&refaulted[..])
				read lrugen->enabled -> miss

CPU B doesn't need refaulted[], but it keeps missing on line 25.

After the patch:

field                    offset       line
max_seq/min_seq/ts       320-375      5
enabled/gen/seg          376-378      5     read-mostly
list                     384-399      6
nr_pages[]               1040-1359    16-21 under lru_lock
evicted[]                1600-1663    25    own line
refaulted[]              1664-1727    26    own line

> I'd prefer a text diagram showing how the false sharing
> occurs, specifically how freq read and freq write end up
> in the same cacheline.
> 
> This will help clarify why rearranging the struct is the
> right approach and how to rearrange it properly.
> 
>>
>> Those fields are read far more often than they are written:
>> lru_gen_add_folio() reads ->enabled on every LRU add, and shrink_many()
>> walks ->list and reads ->gen/->seg under RCU. With frequent file refaults
>> from several CPUs, every refault invalidates that line on the CPUs doing
>> LRU adds.
>>
>> Move enabled/gen/seg/list next to max_seq/min_seq/timestamps, which are
>> also mostly read, and put evicted[]/refaulted[] in their own cacheline
>> group at the end of the struct. This grows struct lru_gen_folio from
>> 1360 to 1408 bytes and struct mem_cgroup_per_node from 2176 to 2240
> 
> Why is the difference exactly 2240 - 2176 = 64 bytes,
> which is one cacheline? I was expecting a value smaller
> than one cacheline :-)
> 

The aligned group makes lru_gen_folio cacheline aligned, and the
padding adds up on the way out:

lru_gen_folio         1360 -> 1408  (+48, hole before evicted[])
lruvec                1624 -> 1728  (+104, lrugen moves from offset
				     176 to 192, plus tail padding to 64)
mem_cgroup_per_node   2048 -> 2112  (+64)

mem_cgroup_per_node is cacheline aligned, so its size only changes
in whole lines. It had 40 bytes of padding after lruvec, which
absorbs part of the 104 bytes, and the rest takes one more line.


> What I'm not convinced about is that nr_pages should be
> updated even more frequently than evicted and refaulted.
> Why aren't they causing a false sharing?
> 

nr_pages[] (lines 16-21) is read and written only under lru_lock.
Its lines move between CPUs only when the lock does, and the new
lock holder needs the updated values anyway, so that is true
sharing. refaulted[] is written by CPUs that don't hold the lock,
so it can steal the line from the lock holder at any time, and the
lock holder doesn't even need it.

> long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];
> 
> It would be better to have a text diagram showing the
> potential false sharing, so we can consider the issue
> more comprehensively.
> 
>> bytes on x86_64 (one more cacheline per memcg per node).
>>
>> Tested on an i7-13700HX (24 threads) with turbo disabled and the
>> performance governor. 24 files of 128MiB on ext4 on brd, read with
>> fio (psync, randread, bs=4k, fadvise_hint=random, buffered), all jobs
>> in one memcg with memory.max=1G, so nearly every read refaults.
>> IOPS, median of 5 runs:
>>
>>    jobs      base   patched
>>       1    270537    274303   +1.4%  (sd 3.7%)
>>       8   1461025   1466293   +0.4%
>>      16   2455629   2508001   +2.1%
>>      24   2707720   2823776   +4.3%
>>
>> A custom random pread() test of the same setup, with this patch alone
>> against base over two boots of each kernel, shows +2.4% at 16 threads
>> and +5.9% at 24 threads, and no change at 8 threads or fewer. With
>> anonymous memory on zram, the refaults mostly hit the tier 0 counters
>> on a different line, and there is no measurable change.
>>
>> The gain grows with the number of CPUs refaulting into the same lruvec
>> and needs a fast backing store; with real IO it is likely to be lost in
>> the noise. The patch is mostly meant to keep the lockless counters away
>> from the read-mostly fields regardless of where they end up.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/linux/mmzone.h | 18 ++++++++++--------
>>   1 file changed, 10 insertions(+), 8 deletions(-)
>>
> 
> Thanks,
> Barry

-- 
Best regards
Ridong


