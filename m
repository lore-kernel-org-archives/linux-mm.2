Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC42CA5FAB
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 01:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2B06B0088; Mon, 28 Sep 2026 21:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04BFE6B008A; Mon, 28 Sep 2026 21:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E55846B008C; Mon, 28 Sep 2026 21:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BEEA56B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:23:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C1D61C2759
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:23:17 +0000 (UTC)
X-FDA: 85265051634.09.429D36C
Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	by imf10.hostedemail.com (Postfix) with ESMTP id BEE76C0003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 01:23:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lpzghxEc;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790644994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAxOJgV7Rk0/sZ6MzI9C0hZBqmWGghw9scp2VQ+xGjQ=;
	b=X9Y1ogG0HNQ1e/9UnJYohal+0wejadDJ/LIQb6OMCS3g1aqHXcUFk2B7lOW7vm6oUON1Ad
	Q4xu/SYkEjVyDDfUKDoYe/+sx97WlDAXivGialuEI38MEu/VudIPVj+J7/WQeo0peFdnv4
	gU/IhertX2see+Vkujs89qE4OfwPa1A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lpzghxEc;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790644994;
	b=47zn1o/Hlqoh2FrY8Q7jA2sYJdlHpwkoZM8dI1st7qs7IenHPa4oFpdHNW6M+cfqxJi+5y
	a7a0ePN9Ixgfe1Fe1wV/T8k06kjuVYM1AHZ0EZQbWz0QSgtHJ+J++BH1EqrfMh/2CvwTAX
	t0fDENOV7bUwslLiBSWRvqgWV5hreaI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XyITaakx/9RJUoMK2YKO6mwBOUANECL8e5bCzpNLG+Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790644992; v=1; x=1791249792;
 b=lpzghxEcAc61Mq0M3jbMVIPTQLZI/unrfekJIP1XM+D4PdhLn0PEdgyN0JpBos9yMQYWnz4I
 mrJr1QSSVt3lSwTHUrVmC9Tpj0RCiYBdG3n6ocN6tb2LMiUFeDr+LjyBP+5r54Kyp+zERK0/yEo
 52sGTKUqR5tsaoDHJJlL3OSk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 20ec7aca34141e9c;
	Tue, 29 Sep 2026 01:23:11 +0000
X-Mizu-Trace-ID: 20ec7aca34141e9c
X-Migadu-Flow: FLOW_OUT
Message-ID: <9bd4bf8e-c159-400d-abd1-d6084bf94148@linux.dev>
Date: Tue, 29 Sep 2026 09:23:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 1/7] mm/memcontrol: drop unused vmscan tracepoint
 include
To: Muchun Song <muchun.song@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>, Ridong Chen <chenridong@xiaomi.com>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
 <20260928114625.3609130-2-ridong.chen@linux.dev>
 <FFCBD11C-B723-441A-B6ED-6AD6E59648E7@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <FFCBD11C-B723-441A-B6ED-6AD6E59648E7@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BEE76C0003
X-Stat-Signature: 5g4pc4ipgc7t7xt6a5utpco993zxmbbo
X-HE-Tag: 1790644993-450182
X-HE-Meta: U2FsdGVkX1+bkvGW2U+0S4nAl4IR2UMnxeP+KJLGwhlbpg4q7YlCnCc5+5RnBjh3fqSUKapHzO3onUG7dWME6K3n9CwlxI4qFIOpmSQdGqDqso2Gcul9mI0OsRqHRZMwiwRitREb07WJ5K1YquPGYo/2IGvH4kg/oSHnVxTx583XPqoui80uLl6kiTCoUB1BSkpQiuFu6BEtJWgRkkI999kPnzjaOAieT6uHcSmgF9PXWBa+ZeKRYcVTcoaBWvlqE8reokVrvC2sEsyTQ+8HAmVl7zWYv5prADCVkv7bvoLZnzhnKLn4a7uxA6eqG+/eREeCKb2IYtzXL2ylGBliiUfcizqVEc8AW/+Duf8tDKTLC9vnicRi06vCp1vXqU36mTZEk5HZqkjF5G9hSml03FvRHjZTNkUTfMJwEr+C24LIartqvT/rBuMHauKzQeO9fiHCVjZJE9zgXfVuBg5rW5z9+aasmDfn4AnYYPVt9U6OBZ27fDfcxK3quWAsrs788SD+jodt+yuGU1B7OjZKZsDocg2eEHEXCret3s0WROMKTUxgub46idAZwA1b5r/uGW8Jsm9Rk+ozfve0sGfTJjDOt0/5AyQuPnmy5vyMCk2VoqUP85mgwFn1r5hEE6RUSGw8KcDJEHpm9PjI2/y/vagouKzQ69mF2/nBiz28CEFs9Q8K9Hsyk3b+LQqVuMeXlxGsRhsYa6BWRLi6po1XFz0eX5z9uIFKdoMJBlgTzKFrjcU/s9lxTDAL/WarrJLnVVVk+FwzsPcUwhOIgkL0SKuZu+8phoF4wPH1t6thtvdRl5GXU1WNldpRM1htywOgCMRLqJMAIR0sBp4K20MvuhFTVVVE6O4fePehUdxpArkSJPd0CWGePiFUjP79vIbyocz1eS7l7xemdUlJv07zz9UYJL3Mx1GBjXhVbcnSjQwUZIe1XwsW3bHLSDpZEp31ZTWV47t0IQPntpLPgZv
 7m1zcGqO
 AYWrtQN9S38wMhZCz2Hjj0yHC9a7DCF6+iGwOBE8VJMlr9gczZ6sA4Hqz+kF7I4mX0151vkY7uicErhczx1oqZo5A4KzAri4XJZSSpmpMit5OyC8JVAEgkIVTMqVceFSJmEAlk8Yj/KlgVPmTiUmIfphcCnI+Tgit250pp03XVt34KLig5nF+4RXreP4qIg8STcjgUdH3jqxkeDCws3A3DleV3+PTzN8zo5+gYmoq1fFCufCdb8pV8L2UTQQ93lUpAi0SdJFX9XrMfxy0yjcnMh5xxbMakWwFzlmHhRfvHr+de0Hh0YAH0G6yvhKAXUqaYEUt8xRhOLX0SurvWNrDgTceOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/28/2026 8:08 PM, Muchun Song wrote:
> 
> 
>> On Sep 28, 2026, at 19:46, Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> memcontrol.c includes <trace/events/vmscan.h> but does not use any of
>> the tracepoints or macros it defines: all tracepoints invoked here come
>> from memcg.h and writeback.h.  Removing the include still compiles
>> cleanly.
>>
>> Assisted-by: Claude:claude-opus-4-8
> 
> Since commit 816d9992d9ed, the label we recommend is Assisted-by: LLM.
> 

Thank you for the reminder; I will update it in the next version.


>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>> mm/memcontrol.c | 2 --
>> 1 file changed, 2 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index aad0498a7bd6..95c2322d4a6f 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -77,8 +77,6 @@
>> #include <trace/events/memcg.h>
>> #undef CREATE_TRACE_POINTS
>>
>> -#include <trace/events/vmscan.h>
>> -
>> struct cgroup_subsys memory_cgrp_subsys __read_mostly;
>> EXPORT_SYMBOL(memory_cgrp_subsys);
> 
> Acked-by: Muchun Song <muchun.song@linux.dev>
> 
> Thanks.

-- 
Best regards
Ridong


