Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D1D2606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QYtjFkK8
Received: by kanga.kvack.org (Postfix)
	id 8603F6B05B4; Mon,  2 Nov 2026 05:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838246B05B5; Mon,  2 Nov 2026 05:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E9E6B05B7; Mon,  2 Nov 2026 05:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 413A46B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:46:18 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4918FA7EE3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:46:17 +0000 (UTC)
X-FDA: 85389849594.26.4922E13
Received: from mta0.migadu.com (out-60.mta0.migadu.com [91.218.175.60])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1AE008000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:46:14 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QYtjFkK8;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793616375;
	b=jdeamGBKVjEK9Vd36IBjRMgcshYtN9egXMoKJ6fnpkXzj80O0ZfUtb97B4U+D++q+H7jin
	7C8jLJEBVAE9Xc2lTSnbCcp/ENDTJljrwpCb2yDwS5+up6sGm/YwlcIMUpsq/ysJPeoLU+
	GcYb9c8H4696fCJJSvz6eM3BXcYUCnI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QYtjFkK8;
	spf=pass (imf30.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.60 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793616375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lxWH9yX4Vl4mKtXKvGkvQaa05rH5ZKTvpkSa847Tggg=;
	b=Y/2wS7fLuv+wNdthOnaR+HRcJmt2rDUWra11AGIZUKn6vb/uGxoZgSZixcA+GRQDljv9X8
	wLM9u1KVu0T9k2vlyNyDoq+IxluxdPjnzvED4HeqKedBBiiN23bZkzudWezXUYgsTl6XP3
	/FwOfG27auRYobKYwwlOn7pWylGH7FI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JxbpZPWbvfuRPXcn2jrt5kFSz35KdLS4+oLLTN6f2mY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793616373; v=1; x=1794221173;
 b=QYtjFkK8hdk8uOiuA9MT2L7rULzj6PvZ/woEcPBaMxFOK9IyGKXj46if9X4hA8tRUNGFiCjg
 C7HPhZDSQMLBvF21fWEp+ecXXpS1KL5mc/FMg6wEgebAVov0Exmd0UzZGDodA18lK0sjro9d8Eg
 Qor1mDKFyw2GLZhqJ7x4CPwc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 92e7062bea360beb;
	Mon, 02 Nov 2026 10:46:13 +0000
X-Mizu-Trace-ID: 92e7062bea360beb
X-Migadu-Flow: FLOW_OUT
Message-ID: <2f272a9b-ea83-4157-8968-0081990cb709@linux.dev>
Date: Mon, 2 Nov 2026 18:46:00 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 2/6] mm/vmscan: move vmscan tracepoints to a local
 header
To: Baoquan He <baoquan.he@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-3-ridong.chen@linux.dev> <aufpQS0XL-CD9YW_@bogon>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aufpQS0XL-CD9YW_@bogon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AE008000A
X-Stat-Signature: pwt63btfeng7z9r639y7exh4ype5nuo9
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793616374-434806
X-HE-Meta: U2FsdGVkX19Q0yunC6CfDR8EpAd+naqzMofjn9W9Qs9YbnJEDUeqah+nn5c7aT3PnxZVO50AM/Ln5Cp8G7Ub/U0q2dxZkRed01hxjfgPfeMDhTu9v+utuFe2k14OyX6tFeejWyfOXKgSdg6DV9/gh1L6XSPpCoF7OafTKPOQJ2RLqdcUcHLO+9sjfP1i8n9kFU4WPDi2RvgYw3IM7IFJg4AjjtmQfCdjmijJHv5WU4cjb1Iy/iwOXL4q/DncXQ0aP626TgopM63TeU1OxZ9Ac+v3zAWtFP45xiEMZ7JZyJAlMyYvt4ooOtiqwRP9DvvfPuVQgf41Tr6lCk9Wz4CVDVpWMU0UoF4IYtGng6HDSunNDk/Dh2WfyJ2wCWClRf8xQOrVKgKdT9oTnn2cRjYbTEXqR4w+89KQa9eTpZ6f+r03U7Bo+Y7banXTQZuX3Fz3Z0uN6W4W2AmtqCM/yNG0c/17oHHuip5IBUf8XDWWSzrDk5dAMyjVW6aOoOQpJVoaIMqwnPpVJ7FUUHgwBNMMGomHnyq1bh5VVj84U9tiUefZoVvafIXRawwEG4dNg2pBj1RZGp46KikCYa1Mtzs4VsDrSYbI8jScBAxlbJjkIWp5D2Srl7wXv22hnkZatMnVJN/rgaCAO87qk9FdLUc+r1tUcqmPZs5LFkgao73elMnVAx+bZHRHwkLD0xv6mWOPz/yALNxPuROLlw34Y3ofUrObM018uGx4ySRFFf/mAJLdXGqi2Fp4BCNFd7/VgFelRygqa+Q1JxYIGzXYtQnkyWbRZILZ8gTRJM0Uoj2d7GJhsmo/ZGTUPhrkb+mlDXUQ9W4FGn4P9VvXZcDTgzxGeHKh8LpyA8KM94QpDjKpf+U14vUXmCsqBdEA/ikRE/mBh7rV/+og0XG1yoaLH35I2c1jX+4ihx4kTVRobwhL59fUWmrN1WFc+KlbwBaWJhd0QS1lYQwgCySYPn7oTNx
 dpU1iJSB
 WrqmuHmGHX3M+IEcsK3QRrx8N8FJNKalrFnxkd44t/XeMJVYKKhTMtR7tLjBubEH41od9qHUv1x8aKFByLrgqUUQAqp1C3Onh0YoTteyOSAZP0JDKGXTDX1u/tCVLtUtWHQK+mpA6z3i8Z/prxy5eRdPQMvNubSTrDze/DpUhou2M/Rd4NebpuqKfeREj9rZxzlpg88//l/hqaJlyNd30eubTKziua2zZ2cVdYrTDif0eD8poFv6kIyMnuIn0YwQ5r+UttuQxfeFUxrVKeWlT/Wjb2rLYSngiDs/8Fx+oXJyEWxr7B9VxCX9jA0tcRrmBwtbmrMAemqMYgCyUi4hMXx1l99K/X8DJzCybsMJ8MxBmpYXEyER218YBQJVEPAveD/bG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/2/2026 9:37 AM, Baoquan He wrote:
> On 10/31/26 at 05:00pm, Ridong Chen wrote:
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
>> tracepoints can be extended to reference vmscan-internal structures such
>> as struct scan_control, which is not visible outside mm/.  This mirrors
>> what several other subsystems already do with their trace headers (e.g.
>> fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
>> do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
>> vmscan.o, the only user that defines CREATE_TRACE_POINTS.
>>
>> No functional change.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> Reviewed-by: Barry Song <baohua@kernel.org>
>> ---
>>   MAINTAINERS                                        | 2 ++
>>   mm/Makefile                                        | 1 +
>>   mm/shrinker.c                                      | 2 +-
>>   include/trace/events/vmscan.h => mm/trace_vmscan.h | 4 ++++
>>   mm/vmscan.c                                        | 2 +-
>>   5 files changed, 9 insertions(+), 2 deletions(-)
>>   rename include/trace/events/vmscan.h => mm/trace_vmscan.h (99%)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index aaf2825ac945..2ad01107fa05 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17653,6 +17653,7 @@ F:	Documentation/admin-guide/mm/multigen_lru.rst
>>   F:	Documentation/mm/multigen_lru.rst
>>   F:	include/linux/mm_inline.h
>>   F:	include/linux/mmzone.h
>> +F:	mm/trace_vmscan.h
>>   F:	mm/vmscan.c
>>   F:	mm/workingset.c
>>   
>> @@ -17802,6 +17803,7 @@ R:	Shakeel Butt <shakeel.butt@linux.dev>
>>   R:	Lorenzo Stoakes <ljs@kernel.org>
>>   L:	linux-mm@kvack.org
>>   S:	Maintained
>> +F:	mm/trace_vmscan.h
>>   F:	mm/vmscan.c
>>   F:	mm/workingset.c
>>   
>> diff --git a/mm/Makefile b/mm/Makefile
>> index 2a3ec53d62ee..277b97f7f8d7 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -32,6 +32,7 @@ KCOV_INSTRUMENT_vmstat.o := n
>>   KCOV_INSTRUMENT_failslab.o := n
>>   
>>   CFLAGS_init-mm.o += -Wno-override-init
>> +CFLAGS_vmscan.o += -I$(src)
> 
> One nit:
> 
> Does it really need the above line? It affects mm/shrinker.c too, did your
> shrinker.o building fail?
> 
> Seems it's redundant because kbuild adds -I$(src) -I$(obj) for every object
> in the directory since commit cdd750bfb1f7 ("kbuild: remove 'addtree' and
> 'flags' magic for header search paths"). Please correct me if I am
> wrong.
> 

Hi Baoquan,

Thanks for the review.

The line is needed for vmscan.o, and mm/shrinker.c is fine without it,
because the two files include trace_vmscan.h in different ways.

mm/shrinker.c only does a plain #include "trace_vmscan.h". The lookup
starts from mm/, where the header lives, so no -I is needed.

mm/vmscan.c defines CREATE_TRACE_POINTS before including the header.
In that case <trace/define_trace.h>, included at the end of
trace_vmscan.h, includes the header again to generate the tracepoint
definitions:

#include TRACE_INCLUDE(TRACE_INCLUDE_FILE)  /* -> "./trace_vmscan.h" */

This #include is in include/trace/define_trace.h, so the lookup starts
from include/trace/ and only finds the header through -I. Without the
flag, vmscan.o fails to build:

./include/trace/define_trace.h:118:42: fatal error: ./trace_vmscan.h: No such 
file or directory

As for cdd750bfb1f7, it doesn't add -I$(src) for every build. kbuild
only adds -I$(src) -I$(obj) automatically when building with O=
(see "ifdef building_out_of_srctree" in scripts/Makefile.lib). So
with O= the line is indeed redundant and vmscan.o builds fine without
it, but a plain in-tree "make" fails with the error above. The
explicit flag keeps both working.

To be honest, I had the same worry at first: I thought every .c file
that includes the header would need a Makefile change. That's why v3
used a relative TRACE_INCLUDE_PATH (../../mm) instead. Steven corrected
me and pointed out that the proper way is TRACE_INCLUDE_PATH "." plus
-I$(src) for the one object that defines CREATE_TRACE_POINTS [1]. That
turned out to need only this one line. Thanks again to Steven for
that.

[1] https://lore.kernel.org/all/20261014124914.21c21559@gandalf.local.home/


> Other than the nit, this patch looks good to me,
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> 
> Thanks.
>>   
>>   mmu-y			:= nommu.o
>>   mmu-$(CONFIG_MMU)	:= highmem.o memory.o mincore.o \
>> diff --git a/mm/shrinker.c b/mm/shrinker.c
>> index 4fb424e721bc..4fbdade6d2f6 100644
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
>> index 8a872990b4be..ad90f0e9bf2e 100644
>> --- a/include/trace/events/vmscan.h
>> +++ b/mm/trace_vmscan.h
>> @@ -648,4 +648,8 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>>   #endif /* _TRACE_VMSCAN_H */
>>   
>>   /* This part must be outside protection */
>> +#undef TRACE_INCLUDE_FILE
>> +#undef TRACE_INCLUDE_PATH
>> +#define TRACE_INCLUDE_PATH .
>> +#define TRACE_INCLUDE_FILE trace_vmscan
>>   #include <trace/define_trace.h>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 9959ca158ce8..79d2d614afd0 100644
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
>> -- 
>> 2.43.0
>>

-- 
Best regards
Ridong


