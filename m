Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8967CCCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 02:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9D06B00F7; Sun, 18 Oct 2026 22:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AE66B00F8; Sun, 18 Oct 2026 22:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A1B6B00F9; Sun, 18 Oct 2026 22:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D13E46B00F7
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:48:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3D8441A062B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:48:19 +0000 (UTC)
X-FDA: 85337841918.18.B0B5AA9
Received: from mta0.migadu.com (out-119.mta0.migadu.com [91.218.175.119])
	by imf18.hostedemail.com (Postfix) with ESMTP id EC8A01C0007
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:48:16 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DpsqdlHq;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792378097;
	b=8GXYaizfx0+j9u81pPgOxjOnX6/+urhrY0fc2f0IYXMT9KQ0Y7hqgvoBdkL2QtwH2dnI/G
	/Bl2qS3yaghz9/xe91cBmS8XVzW3TZIrGkhQnu8qfX3IwlK1jusX7VNRomwgU40BH+8dmd
	1NyTygXEeBBl0aulREgsLQvuO0RH9mU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DpsqdlHq;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.119 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792378097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F94GC2EM79JGnFLc/zYMRjn4UgshZUxBQvdHxlGvCU0=;
	b=o8NNiwTtl0R1SPxYVBiARoUURSr1cvrBB31NIXlgkDwzTuyOU7WYZDCMoV2euD/BF7Y4Nj
	hUq44hUk2USpCKko3RyWhT5KQNaWOtFnCg7xW3mRR7gCXrs4Ah50sKXQnuIOKQhTDkQLQD
	1Z7oSzyup6c3l3arZVUFyI/u6NexhpU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uJd85rqKa3hx2YcUCQnwN6zrGg8MtC8mCup4hf7dmx0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792378094; v=1; x=1792982894;
 b=DpsqdlHqh57TOQVudIzSXAdrXDkcT/txgvanrBVID2zfgCU4OWXnyxk1y3aNrelR/Wrvmsrt
 YXipXfJW1yjA6HnuJrTeFY2F7ODIBeX51BsDaXpt3frFu7HM+oF+FZzA6AN6MubNUJSCjtHNVXG
 hSnaGDRs5SLRcBpOu+0R2tH0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id b000c8b95270aa37;
	Mon, 19 Oct 2026 02:48:13 +0000
X-Mizu-Trace-ID: b000c8b95270aa37
X-Migadu-Flow: FLOW_OUT
Message-ID: <ff8c13d1-371d-4da6-95fc-9fd13adddb56@linux.dev>
Date: Mon, 19 Oct 2026 10:48:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/7] mm/vmscan: move vmscan tracepoints to a local
 header
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>,
 "open list:BPF [MISC] :Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261013131309.2790253-1-ridong.chen@linux.dev>
 <20261013131309.2790253-3-ridong.chen@linux.dev>
 <20261014124914.21c21559@gandalf.local.home>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261014124914.21c21559@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: EC8A01C0007
X-Stat-Signature: ezih95piq1xhboay6w4x8oo5nk3iwuwc
X-HE-Tag: 1792378096-211809
X-HE-Meta: U2FsdGVkX19cyqlTUe+bmmdp3xWqJs7lz1pq1gpawL0I4MfWown/QCYWyAEmrx7suGjuDLCoDCrkitFivhW2UjlYKayCPF5ws6GiSO0yVMgmuZzQCwNBJ7W+Z4TG49W22eJBKMA1hCgGAURsaeuCWqWv3WrAYSJbTEG9T39RwPj36W2lu9pHPLeGgeSORZI1A+1m48pjeStFwfv8zu4VeKbP7GHAozc0Cjj3VKig/chQA+XCtPhdp42DOrvkGiKxP6M93jBLSBFXCXVAHd+4w1ZW5wKvrdXfTWATViLf/JkEKrALG25WKNJW4Nk9MFO/qfhmlApf+RPM+7csh/j6hKo2DmldGKhpVui1i4scfPQGX1Vpe3EiVUUxf6R1+4bsYA4dCcRABRP751wmwQSr7ODoQ2zPRMgQxrLKkaXcGVsBsoCfi61O1APye0Ad+aZDCY7h1J/oZxWNcRhs9sIdhS27geBfI+itKzpoD+BrFzfHqOx52KRSljWHYTNgNuCThvR5QLUA/RxXNYVKLiX8+xPcd3SyLvC1geJFfRMoTqmsmG7/ICgoG90LyLVc/xexBQypdpys5sN7hdzTStsmwsGfrtpJtEUy3yGCUBcI5oIt57LhF/MwTFR+gTnBMFS0WS4J55h+tuAv6lN1vpBzc9hrr60ADPbsxVXqIHEO4/lzReOUs8QXTyI+iZLJ+GXx/qo+VB3dfn07uPChXhh8Zy5BdpUEk7EkGS0ErVWcMKtVOBZueyZVj7+09xDeu53Ue5/WKdKpzbz5XPWowauLbodn5q4AelNqXXQRSqy3Upxri896zmepwE9yNJyzM+UkPNuf4fqprsYi7n5lFk4Xg7K+RY8lclHQsJ5HylnZvjEYuoSJ1S//H7MF/7Po11pOHFqdUanAn6O3/azsLcAYJStXI6CLC0LieVwwVSmPSNVZ3WC17zggazu0a2toVqxQ5u0HhwllivBuhLrdYag
 yiMASlH8
 xpRjaiqaccvBv7NdrdwZnnOn6Mr0bXfeuDEmjTRm8ycK3DlUy4HYbLgO/Z5dJclLxI67pyHXb5y+9/+7S+PWFKbI/missDbkHK8UYXsmuJFREg9lNyyisM0hMbUmQz050YiZBcDrNdUWuyNJtXXoKZn1q1Vd7bEzm2bIzllzJsbk9uR3ZPYFX61fHgcFcJL9fuh8TAYf5p/a2ayvaiO9tFqIJ0DVkpNlQXJSupd4/sy1CiMOmV+4F30u+V7Cw1L9tas36Q9dKw1DhKiiNv7diKBxt1yAnJIDk7kFNCesGDQYiUHXcQyEfx1S7+FbQ2+0pYQj7hNnhPRMsZlJY8j3/e/yMq7E0auVJuhK3+UV1dkBeQccI7+AY90u5wws1Iz3a0L0t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/15/2026 12:49 AM, Steven Rostedt wrote:
> On Tue, 13 Oct 2026 21:13:04 +0800
> Ridong Chen <ridong.chen@linux.dev> wrote:
> 
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
>> tracepoints can be extended to reference vmscan-internal structures such
>> as struct scan_control, which is not visible outside mm/.  This mirrors
>> what several other subsystems already do with their trace headers (e.g.
>> arch/x86/kvm/trace.h, drivers/gpu/drm/drm_trace.h, net/xfrm/trace_iptfs.h).
>> As they do, use a relative TRACE_INCLUDE_PATH so that no Makefile change
>> is needed.
>>
>> No functional change.
>>
>> Assisted-by: LLM
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   MAINTAINERS                                        | 2 ++
>>   mm/shrinker.c                                      | 2 +-
>>   include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
>>   mm/vmscan.c                                        | 2 +-
>>   4 files changed, 8 insertions(+), 2 deletions(-)
>>   rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index c5519d67b6f4..80d2a9dd0525 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17575,6 +17575,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>>   F:	Documentation/mm/multigen_lru.rst
>>   F:	include/linux/mm_inline.h
>>   F:	include/linux/mmzone.h
>> +F:	mm/trace_vmscan.h
>>   F:	mm/vmscan.c
>>   F:	mm/workingset.c
>>   
>> @@ -17722,6 +17723,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>>   R:	Lorenzo Stoakes <ljs@kernel.org>
>>   L:	linux-mm@kvack.org
>>   S:	Maintained
>> +F:	mm/trace_vmscan.h
>>   F:	mm/vmscan.c
>>   F:	mm/workingset.c
>>   
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 7ec2a9704f6f..3c3e87c4b61c 100644
>> --- a/mm/shrinker.c
>> +++ b/mm/shrinker.c
>> @@ -3,7 +3,7 @@
>>   #include <linux/rwsem.h>
>>   #include <linux/shrinker.h>
>>   #include <linux/rculist.h>
>> -#include <trace/events/vmscan.h>
>> +#include "trace_vmscan.h"
>>   
>>   #include "internal.h"
>>   
>> diff --git a/include/trace/events/vmscan.h b/mm/trace_vmscan.h
>> similarity index 99%
>> rename from include/trace/events/vmscan.h
>> rename to mm/trace_vmscan.h
>> index 8a872990b4be..c5d824fef554 100644
>> --- a/include/trace/events/vmscan.h
>> +++ b/mm/trace_vmscan.h
>> @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>>   #endif /* _TRACE_VMSCAN_H */
>>   
>>   /* This part must be outside protection */
>> +#undef TRACE_INCLUDE_FILE
>> +#undef TRACE_INCLUDE_PATH
>> +#define TRACE_INCLUDE_PATH ../../mm
> 
> The proper way to do this is to have:
> 
> #define TRACE_INCLUDE_PATH .
> 
> And update the Makefile with:
> 
> CFLAGS_vmscan.o := -I$(src)
> 
> -- Steve
> 

Thank you. Will update.

> 
> 
>> +#define TRACE_INCLUDE_FILE trace_vmscan
>>   #include <trace/define_trace.h>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 29b31446fc11..6207dad9e644 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -71,7 +71,7 @@
>>   #include "swap.h"
>>   
>>   #define CREATE_TRACE_POINTS
>> -#include <trace/events/vmscan.h>
>> +#include "trace_vmscan.h"
>>   
>>   struct scan_control {
>>   	/* How many pages shrink_list() should reclaim */
> 

-- 
Best regards
Ridong


