Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE91A606A8A9
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=WCOu+cj6
Received: by kanga.kvack.org (Postfix)
	id 153B86B05C6; Mon,  2 Nov 2026 06:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DE3E6B05C7; Mon,  2 Nov 2026 06:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8366B05C8; Mon,  2 Nov 2026 06:22:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C94A66B05C6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:22:47 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 688AE1C4712
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:47 +0000 (UTC)
X-FDA: 85389941574.25.A2CC758
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6EF6514000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:22:45 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WCOu+cj6;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618565;
	b=u/1FBQbDQqZUqrM428PGweA+F8KFSGlOXU2+vD47rh0CwrNFvEIycuEef67tXf9mabkf0A
	SRgWidfE3lDvM+Cl/au605Us46F7/GQLlA+8zf152x6VBfLsrT+AfEOP2UbYVs4vsjk/j0
	eVEINMii5qvseqr8GmyzcH5rgmvR94c=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WCOu+cj6;
	spf=pass (imf23.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X7loASgn+yxCJuZyuGOGYaVSPjNHXEWeXeKmMCLTikE=;
	b=yxFg8aC9C7YGnQDVH6dTb45dVGXL6NjRIPHXm76vh2vxt0cqlL4fb3ysVacGnC3bEjkpky
	ziPZk71zcm6ugviQKt0qvj+mj4CA407kEJZrPBezUyq2XEbRS20Hc4Aq8et2XNHbqcsvzh
	20remtxNZHCYiVxZ0pYLnF6xiieT99A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=72Z50eGsX0yBdCzUdD2DRF1kVAo5WdsTx+d6WyLQP4A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793618564; v=1; x=1794223364;
 b=WCOu+cj6kNM/m98bWxhFmENNuPadN6C2HuhsVN5hVy9dukRiBKNa8k/8PLbFdbj/DXlRF5kM
 IhFFkIS71wTN8YJ4rJr7SHL38vMi1MqQuSvb6+c8wYtyI1xkIsAstcsyHjJeTILcKR6C0ek4Wsf
 CQM217qhkiW4oWusR+yozJyQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aa70f3ab710337ec;
	Mon, 02 Nov 2026 11:22:43 +0000
X-Mizu-Trace-ID: aa70f3ab710337ec
X-Migadu-Flow: FLOW_OUT
Message-ID: <65edd0da-008a-4c1d-bfd1-7f0b892a76bf@linux.dev>
Date: Mon, 2 Nov 2026 19:22:28 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/6] mm/mglru: add tracepoint for inc_max_seq()
To: Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-7-ridong.chen@linux.dev>
 <CAGsJ_4zUbkFXBhAesVV74-Ndga5f6xEbestK7Qinqddip8xBrw@mail.gmail.com>
 <aufxuOaKZWMYqEQi@bogon>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aufxuOaKZWMYqEQi@bogon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6EF6514000B
X-Stat-Signature: qnznndubyyq3h71syxegr3katfafd5rn
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793618565-947990
X-HE-Meta: U2FsdGVkX18W67FplvQfghRAF3s7oUR5/u8/4gWF2hqw7EPCgTQ3P/AtBGDkEYNLXVRFTEHBeCmv/3zj5MwfMjsBH/Hgm9cprMtSuvsMLegNPICkdi5EsSAHt9uQwMBLIMQq4vFMyJItVbIknNC6WayM4rWK00M/ca8ApyBVk6DFoEtFk1jgrgf4apRqqs0IaphJvWXmdS40a/7kiTVrbIRO8JJ9NJ2SddyHhlWpYDpgifOyKnvKvFxCduf8gDArx/iFfHRS1uvR5QYW/ykI1ix2G+YNxev2n12kL9JCzBZbo0Ll9pI1h26SDDDewifEz0nHOGWs+VXU52cI8XFa2W8iVgnZqikZcP61/ckik2GvBoGTZ+fuh/dIY2swrqQuXlFADVb/Rd1dz9SWNsi04v8cJ2WHXDFK1fOAujb2Ksijbg04hm2PS7ClOdKTSynC7nOzgholQXdp5uvZsYxza05IDK4+l/FORkf3V5hPZnmCOkbqlYrjPeiYzpX2dv2XVB8QBmJNH+wxaah418E1p9JDDaDKjHlSJyWqodofjKF9l+PTbBISvGsXC9/UotX6U1TvX+UcmLfmZm+wM0RLCsg9GipDmjTzYlrku1JIyy6FU8mEwjq1twThldeZjGN4VvQl88Nw1TY+ah3DDBTMp/Nr7cAaAOWICfy8+97HLhDY5Efb721SN6yPSMI1R2Gb7HO3EDsLpo2CgG8Epj4xndl4jgscwAy9Cc/9zsYnFxWfNMUc4td1MG3EKKBP3v2DkJQHPeYmpL3MZBlayCAETQnV1Oatgct7SEAn+AO+dGDrMR7v9iQwnXiu0A7YN7252SGTYuY27pIG9dhPJNDI2ds22gMLLs7V3sxOyQ8cZIB5WVL0kX7ENoR5XAvlh1pdJt3NpwtOYJiwIQy+x3gwijVJqBuG9E+TkXu/b7WvLTGx4eDEF3V3/KgtnjIJOT2Go+FubHo7vJgGbFWrV65
 2chcrncY
 UVKWrVwDOI4WlU6c+Fz+cVcBbC80abmM8raZwJtILmsjJ3uo29extK5OBQllXds6Zx/x8oIkXlqhXxMfH3gWyqd0lq5L5F1zomS7xzpu211+tZL+C8XDpyieXyxl1G3YfymPbUbV0yB8BlgcOqbGukTynM24TErNSpPXRlm5egYVmngJ8YXZxhIxqoW6fjNGI/mye4p1ft1TK/RqWlCjIGDy/5XKyUhPSN+UDHC0SwNR6JrnfK86kfTaewED2M82JssFOIvzZK5XNNDwlKIM1+Z2j96gHV+fl1fjHYMrNP0ZEwwE0pil89mslQYC2FEc5lvb8669sAj+8Ii8heeNcjveDTNTY+G3S58CIPZfhq+5mNGoktFTGFBNuHjBIJRtR+MEEyUvDTMe0K2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/2/2026 10:13 AM, Baoquan He wrote:
> On 11/01/26 at 05:21am, Barry Song wrote:
>> On Sat, Oct 31, 2026 at 5:02 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>
>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>
>>> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
>>> youngest generation. There is currently no tracepoint on this path, so
>>> the moment a new generation is created, and how the min_seq of each type
>>> trails behind it, cannot be observed as it happens.
>>>
>>> Add mm_mglru_inc_max_seq, emitted right after max_seq is bumped while
>>> the lruvec lock is still held, with the node id, memcg id, the new
>>> max_seq, the anon and file min_seq, and the number of pages in each
>>> generation for both types, summed over zones and clamped to >= 0 the
>>> same way the debugfs lru_gen file reports them. The nr_anon/nr_file
>>> arrays are indexed by generation slot, so the emitted max_seq/min_seq
>>> say which slot holds which seq. They are printed with __print_array(),
>>> so the output is hex and its length follows MAX_NR_GENS automatically.
>>>
>>> Only the lruvec is passed in; all of the above is collected in
>>> TP_fast_assign(), so inc_max_seq() does no extra work when the event is
>>> disabled. Paired with mm_mglru_scan_folios it makes the full
>>> aging-to-eviction window observable per memcg.
>>>
>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>> ---
>>>   mm/trace_vmscan.h | 47 +++++++++++++++++++++++++++++++++++++++++++++++
>>>   mm/vmscan.c       |  2 ++
>>>   2 files changed, 49 insertions(+)
>>>
>>> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
>>> index 8148b8224422..cddf42b5849a 100644
>>> --- a/mm/trace_vmscan.h
>>> +++ b/mm/trace_vmscan.h
>>> @@ -456,6 +456,53 @@ TRACE_EVENT(mm_mglru_scan_folios,
>>>                  __entry->min_seq)
>>>   );
>>>
>>> +TRACE_EVENT(mm_mglru_inc_max_seq,
>>> +
>>> +       TP_PROTO(struct lruvec *lruvec),
>>> +
>>> +       TP_ARGS(lruvec),
>>> +
>>> +       TP_STRUCT__entry(
>>> +               __field(u64, memcg_id)
>>> +               __field(unsigned long, max_seq)
>>> +               __field(unsigned long, anon_min_seq)
>>> +               __field(unsigned long, file_min_seq)
>>> +               __array(unsigned long, nr_anon, MAX_NR_GENS)
>>> +               __array(unsigned long, nr_file, MAX_NR_GENS)
>>> +               __field(int, nid)
>>> +       ),
>>> +
>>> +       TP_fast_assign(
>>> +               struct lru_gen_folio *lrugen = &lruvec->lrugen;
>>> +               int gen, zone;
>>> +
>>> +               __entry->memcg_id = mem_cgroup_id(lruvec_memcg(lruvec));
>>> +               __entry->max_seq = lrugen->max_seq;
>>> +               __entry->anon_min_seq = lrugen->min_seq[LRU_GEN_ANON];
>>> +               __entry->file_min_seq = lrugen->min_seq[LRU_GEN_FILE];
>>> +               /* summed over zones and clamped to >= 0, as debugfs lru_gen does */
>>> +               for (gen = 0; gen < MAX_NR_GENS; gen++) {
>>> +                       __entry->nr_anon[gen] = 0;
>>> +                       __entry->nr_file[gen] = 0;
>>> +                       for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>>> +                               __entry->nr_anon[gen] +=
>>> +                                       max(lrugen->nr_pages[gen][LRU_GEN_ANON][zone], 0L);
>>> +                               __entry->nr_file[gen] +=
>>> +                                       max(lrugen->nr_pages[gen][LRU_GEN_FILE][zone], 0L);
>>> +                       }
>>> +               }
>>
>> I feel this is wrong. Can we calculate the newest and
>> oldest generations from seq, then print them in order
>> from newest to oldest?
> 
> Agree, from newest to oldest or oldest to newest makes it clearer.
> 
> Printing from lrugen->max_seq - MAX_NR_GENS + 1, or from MAX_NR_GENS,
> both looks good.
> 

Hi Barry, Baoquan,

You are right, thanks. In v6 the arrays are ordered by seq, from the
oldest to the newest, i.e. the same order in which the debugfs lru_gen
file lists the generations from top to bottom.

>>
>> The nr_pages[] array isn't ordered from newest to
>> oldest or vice versa, as we have:
>>
>> static inline int lru_gen_from_seq(unsigned long seq)
>> {
>>          return seq % MAX_NR_GENS;
>> }
>>
>> And I added a helper here:
>> https://lore.kernel.org/linux-mm/20261022220203.91911-11-baohua@kernel.org/
>>
>> +static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
>> + int type, unsigned long seq)
>> +{
>> +     int gen = lru_gen_from_seq(seq);
>> +     unsigned long size = 0;
>> +
>> +     for (int zone = 0; zone < MAX_NR_ZONES; zone++)
>> +          size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
>> +     return size;
>> +}
>>
>> Maybe you could port it here as a separate patch so it
>> can land earlier as part of your tracepoints series. We
>> could then use it in the next version of the swappiness
>> series.
>>
Sure. I will port lruvec_gen_size() as a separate patch with your Suggested-by, 
and put it in mm/vmscan.h so the tracepoint can use it.

-- 
Best regards
Ridong


