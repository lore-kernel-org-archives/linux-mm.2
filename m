Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAC02606A32D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ROPqMjXI
Received: by kanga.kvack.org (Postfix)
	id BCC2C6B05C4; Tue,  3 Nov 2026 03:38:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CDE6B05CC; Tue,  3 Nov 2026 03:38:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC8E6B05CD; Tue,  3 Nov 2026 03:38:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7ED6B05C4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:38:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E5BBC036A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:38:56 +0000 (UTC)
X-FDA: 85393157472.10.F5BCB23
Received: from mta1.migadu.com (out-75.mta1.migadu.com [95.215.58.75])
	by imf13.hostedemail.com (Postfix) with ESMTP id D1C8220004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:38:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ROPqMjXI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793695134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qeqwFlyJpg/hyC5+cDpsscxjxixuGz6INW/VspMuWu8=;
	b=cJl8TF5JsVE3kyuE5sDjneBOqB5ojxYHMfCfX8eTcM4N6re+Fd1lh4gq1z5iZQCEVTjwl6
	M11jDANQeDCuppPF0Oj0HK189mUhEyQy1ng0dCQGUj193lBAY54jiSNE5dt1pSJSs3IH9W
	femNNm0hllR3b25ZLE/ldP6ivwKE0t4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ROPqMjXI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.75 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793695134;
	b=zwkiXFl22yPfeYM42MTYzSMSqbeEx/QF054XqHjkuPNQ+JNcx4cEm0gNYlzVDrUcm/Btv+
	3r8ARuBHPoalBTA4OGIUwXCS3VGaSWZWet01wHUaM5mqg/38Ltk/TfH8HCyO5zfz6yGoqU
	w4OXvBnbJhJPdhEKFnhSrMNiMKg+zm8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OSN5qGHgqiHVh7/05xFfowZL4pMsF7I9FTtrXt2Dh7Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793695132; v=1; x=1794299932;
 b=ROPqMjXI5XlPI4j2+AMYhgpbz8V4jO1vsprSWBij54GaljEpun6cdUgvud1esw4g1ip9qwvg
 fsTAQ9gdAlNWK7zqvCd/jneT7dLIbvPehxzOCbiFFcMIHZx1ClxtmYq+gcr3R7jTmQ9V53IVzlH
 yyMf7sjmzypXX+cjR/BV8gP0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c2bade759b0e2b73;
	Tue, 03 Nov 2026 08:38:51 +0000
X-Mizu-Trace-ID: c2bade759b0e2b73
X-Migadu-Flow: FLOW_OUT
Message-ID: <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
Date: Tue, 3 Nov 2026 16:38:39 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev>
 <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D1C8220004
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: crjbdxdwu3hb7hkm5xtm7zz1e98pgp13
X-HE-Tag: 1793695133-331113
X-HE-Meta: U2FsdGVkX19QcS/QvBBt5y4ViMIeJoWSn/6QtJxXNA4vcXUFrszuIrBElT6d7Hq5ZmRj2jO/GAia4o4oJfP9MYOBtP5gctf77IfNCRP3h8Hh3RVh/CUbcyC8uzGk4G+vslDjs1Jl0nssEHWWOtY3uWauSt23U64u1L3JSpy3L9S1c2PBNGlM8W8xwBUoiY6jYMxcBrrbABxqKe+QtcOqj0e8VJcXe7QSYHm23TNHvz8plwoEtSQv/CRr8Y7cy0ULnSqf/PBPaBy26owjuMoPFt9dlwK+d2DoKlDklvlvXlzw12+KMVdzM1wTi2Df2aFlt3MfwUY1PNcfY5hg7YeLPtKwTXp5Ldrj5SxN6Z+qtnVZfl9vXfSYiYLvjaZn8j3YhHvKshTn8se/fkVTQ8fNvmZ9fbtZObnJcAOypGh/WZKC0Bie8/wsTmjrid1IVEIw54EW/mdvIfWbj0AGC935sUH5KVXTHP0Wy1ihalojERsenzkYIofs19OnF1HrQIZ3ZKjVk5gXGMlpreTp3aZAiP+elxKyQc5BjoN8J6BQaWmVpDCk+fsFY1BK+6/TbNyfR/fodl0SMEKxJ3kYXWP2g1SzlmxV2yvarAuvohOcrmLfVa2/Dk/aWil5QXndWq7poETD40KvmKT6zdhnn0egajCYmKTzIFi+0Xn317CqRV7lDhNYi2ALc+5M9OvKatKwtAiRLSFncPOeYH6PDInE/Hsgq35hjX4jTfEJMqM4fkAv4RLbUK/WBhlm51pLlj+gtKsKCRj58mV0RQuh/UozHzd7ddBVLP0wC0uvKJa0VtE2kmuLWOZvwoviwFF1MgGxgxnb2E7BKpHMmQx7Xjyf4ZTRmQt5y180ULTJ3cY70YfCisOZCfUWaJr5kIh8A8Xx5IUECx9dm/xWhnHoosevXSog1zB0InV1IhbO1FSWU4EtRI17eKcsTCElEdKfho6j/YD/ztbwTlXNG56m1PW
 Pyf2PIN5
 QUGCJtrQo1YZroyj3NeGjqEeX4G2+TLr0BvQcUmB6dtE+cv1hvRLqvld3PnXaA9i0iaUdRtPfsEdPSi1U4wx5IeZRXGPHhVJL9e2Gwk+t3TYVxzOIXE8NbIOr6l61GD/9DuAOhIkUF2H12XlFxcYwoyS+UMXAAj+91O9YDYkQWlaz1Bv4ddAqds1nEdDcxwYSuABxf9x4ZXvLpzoqa67kd4kBRPQCn2w7dAYO675klZmzFM4DQQF/yUoFoyLi+4T+Y18jzPrSIbKEI5PmDoduh8gPGfV/a8OsTH2b1niKV+zW5JUJV15E+It1MrwhimQSUyZ67gnQNdkZ0bVpk9zP7F2Hirl95zKyj66MvuuoxO6Qdm1LrB3XS0V+5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/3/2026 2:48 PM, Barry Song wrote:
> On Tue, Nov 3, 2026 at 10:58 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Aging in MGLRU advances max_seq via inc_max_seq(), creating a new
>> youngest generation. There is currently no tracepoint on this path, so
>> the moment a new generation is created, and how the min_seq of each type
>> trails behind it, cannot be observed as it happens.
> 
> We might be more interested in why aging is triggered rather
> than the exact moment when max_seq is advanced.
> 
> With your patch, we get:
> 
> ~ # cat /sys/kernel/tracing/trace | grep mglru_inc_max_seq
>             a.out-93      [001] d..1.   278.276539:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=4 anon_min_seq=2
> file_min_seq=1 nr_anon={0x0,0xf016,0x12,0x0}
> nr_file={0x1886,0xb,0x4c,0x0}
>           kswapd0-50      [000] d..1.   278.422400:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=5 anon_min_seq=2
> file_min_seq=2 nr_anon={0x5,0xccb6,0x3439,0x0}
> nr_file={0x4ae,0x4f,0x55,0x0}
>           kswapd0-50      [000] d..1.   278.508003:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=6 anon_min_seq=3
> file_min_seq=4 nr_anon={0xccb6,0x3d29,0x1,0x0}
> nr_file={0x0,0x59,0x7,0x0}
>           kswapd0-50      [000] d..1.   280.046056:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=7 anon_min_seq=4
> file_min_seq=5 nr_anon={0x3bf3,0xcbbd,0x23e,0x0}
> nr_file={0x0,0xb,0x1,0x0}
>           kswapd0-50      [000] d..1.   280.124876:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=8 anon_min_seq=5
> file_min_seq=6 nr_anon={0xcafd,0x3e31,0x0,0x0}
> nr_file={0x0,0x5,0x7,0x0}
>             a.out-96      [001] d..1.   290.629014:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=9 anon_min_seq=7
> file_min_seq=6 nr_anon={0x0,0x10615,0xb,0x0}
> nr_file={0x331,0xb,0x9a,0x0}
>           kswapd0-50      [000] d..1.   290.653098:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=10 anon_min_seq=7
> file_min_seq=7 nr_anon={0x15,0xef23,0x18c4,0x0}
> nr_file={0xb,0xb8,0x55,0x0}
>             a.out-96      [001] d..1.   290.684875:
> mm_mglru_inc_max_seq: nid=0 memcg_id=1 max_seq=11 anon_min_seq=8
> file_min_seq=9 nr_anon={0xeee3,0x1afb,0x2,0x0}
> nr_file={0x0,0x76,0x4,0x0}
> 
> You can see that the youngest generation is always zero,
> because you're just getting the newly added youngest
> generation :-)
> 

Hi Barry,

Thank you very much for testing and reviewing.

> This somehow suggests that the information is redundant, as
> there is always a zero there.
> 
> I suspect we'll need an additional tracepoint to show why
> aging is triggered and at what sc->priority it happens.
> 
> But do you know why you trace the moment just after aging
> is completed, rather than the reason why aging is needed?
> 
My original goal was to pair it with mm_mglru_scan_folios, to see how
the aging window of each memcg moves. The per-generation anon/file
nr_pages were added following your suggestion on v1. I put it at the
end of inc_max_seq() because of the restart there, as max_seq and
min_seq are only final after that.

You make a very good point that the reason for aging is also
important. So I'd like to discuss which way is better:

1) Keep mm_mglru_inc_max_seq, and add another tracepoint at the aging
  decision in try_to_shrink_lruvec(), reporting why aging is needed
  and at what sc->priority.

2) Replace mm_mglru_inc_max_seq with a single tracepoint in
  try_to_shrink_lruvec(), right before try_to_inc_max_seq(), reporting
  the reason, sc->priority, swappiness, max_seq/min_seq and the
  per-generation nr_pages before aging. The youngest generation is
  not empty at that point, and the new window after aging can still
  be seen from the following mm_mglru_scan_folios.

Which one do you prefer?
-- 
Best regards
Ridong


