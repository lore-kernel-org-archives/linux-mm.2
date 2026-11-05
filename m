Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BBC3606A329
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 01:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Bj6MbLCe
Received: by kanga.kvack.org (Postfix)
	id 4A5F86B05B2; Wed,  4 Nov 2026 20:48:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 457C56B05B3; Wed,  4 Nov 2026 20:48:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36EF76B05B4; Wed,  4 Nov 2026 20:48:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 148B66B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:48:38 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BE4E808EF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:48:37 +0000 (UTC)
X-FDA: 85399381074.21.4E0AEF4
Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5EF8420002
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 01:48:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bj6MbLCe;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793843315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sQkjxX3K1joAq68TfOUhRaY9yTvSWkChu+qzeIISQGI=;
	b=vgEPqqAfTk9+wykv8Z+ZNqin8IGkJLIrQsY3J7/mlJ+lZIZFXS1NM2aTd1TWjJfO/nyteB
	ipneXlqsAtmYMxeRgJbHLpy917TIXaEMgwjglxe5imWrj7HRlt/TwUkYtybYC4joRi5awF
	wQf1DZYNgQWGa4WWHm+E9d4zm3IjEaQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bj6MbLCe;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.241 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793843315;
	b=jGq5kI8vCUFbjxfH3iYk3/buNwj/GLyPWQ4e9W5Bg4UxcC9W66JRcpMijZNEL7duXgh2s9
	4RrIDMSwhNzhRhFu1cfKYydRfXGYt/E1ilKPha7DvXcBLbpT4qMCXCljFAFHlfEreoBdg8
	Usf+rj4wBYt0teVp6KX2Att9nQaf4Rg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=E+Tnnknq496cXrkg+nZvAVLx4JY0DVaLftLc8cBxV7o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793843313; v=1; x=1794448113;
 b=Bj6MbLCe42vYTLjGG2GoPahv/cBkkaGFa15VL9LAyQs2zARA+S7dw2BtKaWofKCwoCT3DCB7
 /p32Ia1MzTYptErzDopKP17SIwpt4yRpYYS+9OQQ3G4ifSyh28A+6E5FpaoFrjQLRKFbDgSYY1x
 aV7ReBKBjjc7D9qJmjieIemo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id db3cfca7bcba751d;
	Thu, 05 Nov 2026 01:48:33 +0000
X-Mizu-Trace-ID: db3cfca7bcba751d
X-Migadu-Flow: FLOW_OUT
Message-ID: <4f830c30-f99c-4f75-851b-1a3f6d1342b1@linux.dev>
Date: Thu, 5 Nov 2026 09:48:23 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 7/7] mm/mglru: add tracepoint for aging
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Dave Chinner
 <david@fromorbit.com>, David Hildenbrand <david@kernel.org>,
 Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Kairui Song <kasong@tencent.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261104130817.849089-1-ridong.chen@linux.dev>
 <20261104130817.849089-8-ridong.chen@linux.dev>
 <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4y_Ay0mYO3ic72oepjtW6KYf2sKRXEHb3Ff8uwKrOJZjQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iic79tw6nzihnnft76b9x8oaa55tnke7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5EF8420002
X-HE-Tag: 1793843315-994949
X-HE-Meta: U2FsdGVkX1/17s0JDZ7BJpTtFZf0UNgrZObFnUJyelnFVjkH7YO9dWZmvehlwhXWYKwluZxQcas6GGjIV3ZX2kJNp0BYbPYJ41xvs5+meEzXu1ah/ParR0nmSGUaTIy9f5YTdEF8nH09n3qQ6c4W4vmbmyRcMWr6DuWenEMlVvzmnOgVn50XU7u8zpR9tZoMWUrpFBXQu0rcL4QRvug6KCaFtqjnHCsh+d8WlvUjHqqz6ZW6Yg8cVHv5jBKXMBGKiftMjSaxfyPW2b8P8QkHOqw+bVEWy9uUtQdsm6uOhalSJQhz3aBPKnFWPIrEJNq0+Q/oLoyyYjhI1xRc0Uq27ozcoGbM3YI5d/POFsAGQj7Nn+VAuY9JIFuVKn7nje264F3Z8KoFGuslC6zbRJSN5WYzqxgOExrIaGylE2gTFC/CJEtF9viOY1C5nLKx+jd0LKyh71K9AOwSP3RePIZq4uyOviY9PAxVZxZPKFSd14XVpvSydEb3iDyzclxI9x9UO+/gOAhr8H7TLAJ7V/tAbfKR8m39oqEM8xvewL2mBaeoWYHF4B+T5tFO1BFTKsIaEczpr04OUYKXpKSg0A03MpvI8yKFaNJf6qNE6hqDQqHUan3pDBYI7eQ71kwcKQZ3f6297o/ZxqrkuvTbVXTu1fmnWOuysfsYSvwaHkdzJ6HQj8vvyvvhfcpPyt+UVn+3YrYyfLfjnULkYWLQ5qccVtiIZKDVPLzrH7mn+0+k5lB1NZrsfKt6exXLPLaxVYqeEjuOIPfA3Q8elV+FkiOU5MmKi4fW3Z9xByTCMx39JmDJWk16J0YEXC1wSOBO626WsXiDO8B5bvqHVul2PBHwT2hsY69jX7+ubrfAUKG/uZ67rds9onBa3XYh/cMHzMEMw58udFSTtnirr4jwcwO61WOSbBZ5+mI9QnXcRB2LeS0YZp2ME1deYvuMj2S9pbyDfrxZb4lili8OrKSYPNy
 VRDDg4e5
 4xPUHKRXHjZ6CuE47HFNorn2kSWLi67wYpbskijkmTSCcFaizX3nISpmxvBvPNf2IWMGDz47+/9OTnBb0a4hY7XavcS8k9/rgcUUvLCzY8ZWqSjrEbqTRH8BcKtKCryz67XTNYtZtRWhYIGBXZ+juIrobOhzmyh/yVdhuPyLbU4OVXl184vyLTLKI/Jrx9/kgvMluNHg+aleoGsToP/qWKl38Aef3rXrbOWus/TvXi7wp/PYO5SOgIWexf12iTkGfcq1ahtvTU/34NCnLohP6PP0qm3V8pLBC3jEx0BTFWDXopuuKGKsq7apoNHYyUZU0UBMkG/XIy91NAZ/kL2QZ+JgiuPTrOrCGKHw8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/5/2026 4:56 AM, Barry Song wrote:
> On Wed, Nov 4, 2026 at 9:10 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Aging in MGLRU advances max_seq to create a new youngest generation.
>> It is triggered from try_to_shrink_lruvec() when should_run_aging()
>> finds that eviction is no longer possible, or that it would be better
>> to age first at the current priority. There is currently no tracepoint
>> on this path, so it cannot be observed when and why aging is needed.
>>
>> Add mm_mglru_aging, emitted in try_to_shrink_lruvec() right before
>> try_to_inc_max_seq(), with the node id, memcg id, sc->priority,
>> swappiness, max_seq, the anon and file min_seq, and the number of pages
>> in each generation for both types, as computed by lruvec_gen_size().
>>
>> The reason for aging is not reported explicitly, as the logic in
>> should_run_aging() may change, e.g. for imbalance-based aging. It can
>> be derived from the generation window and the per-generation sizes,
>> which are taken before aging, so the youngest generation is populated
>> as well.
>>
>> The nr_anon/nr_file arrays are ordered by seq rather than by generation
>> slot: entry i holds the generation max_seq - MAX_NR_GENS + 1 + i, i.e.
>> they go from the oldest generation to the newest, the same order as the
>> debugfs lru_gen file, so the output can be read directly without mapping
>> slots back to seqs. The arrays are printed with __print_array(), so the
>> output is hex and its length follows MAX_NR_GENS automatically.
>>
>> Only the lruvec, sc and swappiness are passed in; everything else,
>> including max_seq, is read in TP_fast_assign(), so try_to_shrink_lruvec()
>> does no extra work when the event is disabled. Reading max_seq there
>> rather than using the caller's copy keeps the window consistent with
>> the per-generation sizes read right after it, should another reclaimer
>> age the lruvec in between.
>>
>> The event marks the aging decision, not its result: the following
>> try_to_inc_max_seq() may find that aging is already in progress or
>> done by another reclaimer, so concurrent reclaimers can each emit it
>> for the same max_seq. Whether max_seq was advanced can be seen from the
>> following mm_mglru_scan_folios.
>>
>> Suggested-by: Barry Song <baohua@kernel.org>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
> 
> Much better now:
> 
> ~ # echo 1 > /sys/kernel/tracing/events/vmscan/mm_mglru_aging/enable
> ~ # ./a.out
> Mapped 400 MB at 0xffff98a00000
> ^C
> ~ # cat /sys/kernel/tracing/trace | grep mglru_aging
>           kswapd0-49      [001] .....   104.277689: mm_mglru_aging:
> nid=0 memcg_id=1 priority=6 swappiness=60 max_seq=3 anon_min_seq=2
> file_min_seq=1 nr_anon={0x0,0x0,0xd360,0x0}
> nr_file={0x0,0x23e2,0x0,0x0}
>           kswapd0-49      [001] .....   104.536448: mm_mglru_aging:
> nid=0 memcg_id=1 priority=3 swappiness=60 max_seq=4 anon_min_seq=2
> file_min_seq=2 nr_anon={0x0,0x20,0xf8bc,0x0}
> nr_file={0x0,0x91a,0xbd,0x0}
>             a.out-79      [000] .....   104.689518: mm_mglru_aging:
> nid=0 memcg_id=1 priority=4 swappiness=60 max_seq=5 anon_min_seq=3
> file_min_seq=4 nr_anon={0x0,0xf8a0,0x1188,0x0}
> nr_file={0x0,0x0,0x2,0x7}
>           kswapd0-49      [001] .....   107.282038: mm_mglru_aging:
> nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=6 anon_min_seq=4
> file_min_seq=5 nr_anon={0x0,0x6c50,0xa168,0x605}
> nr_file={0x0,0x0,0x98,0x18}
>           kswapd0-49      [001] .....   107.812598: mm_mglru_aging:
> nid=0 memcg_id=1 priority=1 swappiness=60 max_seq=7 anon_min_seq=5
> file_min_seq=6 nr_anon={0x0,0xfe10,0x1721,0x54}
> nr_file={0x0,0x0,0x1a,0x3}
>             a.out-79      [000] .....   108.936872: mm_mglru_aging:
> nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=8 anon_min_seq=6
> file_min_seq=7 nr_anon={0x8,0x7d29,0x8c54,0xc90}
> nr_file={0x0,0x0,0x4,0x2}
>           kswapd0-49      [001] .....   108.937115: mm_mglru_aging:
> nid=0 memcg_id=1 priority=2 swappiness=60 max_seq=8 anon_min_seq=6
> file_min_seq=7 nr_anon={0x0,0x7d15,0x8c94,0xcac}
> nr_file={0x0,0x0,0x4,0x2}
>           kswapd0-49      [001] .....   109.425258: mm_mglru_aging:
> nid=0 memcg_id=1 priority=1 swappiness=60 max_seq=9 anon_min_seq=7
> file_min_seq=8 nr_anon={0x0,0xed69,0x24bc,0x488}
> nr_file={0x0,0x0,0x3,0x3}
> 
> One thing that looks a bit weird, though. For example:
> 
> max_seq=3 anon_min_seq=2
> 
> We have only two generations for anon, but we print four:
> 
> nr_anon={0x0,0x0,0xd360,0x0}
> 
> The two oldest generations don't actually exist. Ideally,
> we would print only the two existing generations:
> 
> nr_anon={0xd360,0x0}
> 
> you should be able to fix it by:
> 
> __print_array(__entry->nr_anon, __entry->max_seq -
> __entry->anon_min_seq + 1 , sizeof(unsigned long)),
> __print_array(__entry->nr_file, __entry->max_seq -
> __entry->file_min_seq + 1, sizeof(unsigned long)))
> 
> But I guess it's fine, since the two extra entries are both
> zero.
> 
> And, I personally prefer the youngest-to-oldest order,
> as we usually have:
> 
> head ---------- tail
> 
> where head is young and tail is old.
> 
> Your output uses:
> 
> tail ---------- head
> 
> But anyway, I guess this is just a matter of whether we
> read it from left to right or right to left. Personally, I
> find it more natural to read from youngest to oldest.
> 
> If you're not tired of working on this and would like to make
> a few more improvements, you could address the two issues
> above. But it is up to you.
> 
> For the patch,
> 
> Reviewed-by: Barry Song <baohua@kernel.org>

Hi, Barry,

Thanks a lot for testing and the Reviewed-by.

Updating it would be fine with me, but I'd slightly prefer the current
output, to keep it consistent with the debugfs lru_gen_full file. It
also prints a fixed window of MAX_NR_GENS generations from the oldest
to the newest, marking the ones below min_seq with 'x'. The event
reports anon_min_seq and file_min_seq in place of the 'x', so the
generations that don't exist can still be told apart, and they always
read 0. Keeping the same window and order makes it easy to compare the
event with debugfs, e.g. when looking at both while debugging.

That said, if others such as Baolin, Baoquan or Kairui also prefer
printing only the existing generations from the youngest to the
oldest, I'm happy to send another version with that change.

-- 
Best regards
Ridong


