Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A604ECA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B18C76B00A9; Mon, 28 Sep 2026 08:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC8836B00AA; Mon, 28 Sep 2026 08:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BA026B00AB; Mon, 28 Sep 2026 08:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ACF86B00A9
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:08:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17272A50E1
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:08:41 +0000 (UTC)
X-FDA: 85263049242.13.354CFA9
Received: from mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf03.hostedemail.com (Postfix) with ESMTP id 13E8A2000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:08:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=exO8AcIo;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTzhnof+9ELm8OhD/fW7FoBrz2Ks2vqeWWay9tpIHkM=;
	b=NU221yGFvfOcUfr5iul1n/PCqHk0AzN95j5SZHQxF/6gssMJbhXq3S3OF4ufynjIyWjqAl
	3RCjjhHrsMH30fjQQsY26pP5q0ZrucpmWHr9GR+yLguwvof+psUmCuidIJZNA/Tu73PCMd
	lpI3VzdwUqyIQdm9QMoqxXkhsIIqSwQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597319;
	b=HKvPwFQ/CJQqAprOZIH4pf6MqwUwp33tAiQnGT+n6WDnxFLLrrHt0LnAewS13PziBUKpFy
	avPXpEI+fAVKogNe/+3sNR1La35HmmZP2hYicqhziF2KulFbcVEkvbrN01wBZYUf6524Gp
	7n+gS/dTKPNTqeyhA1Y3AlwRY0uwpkw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=exO8AcIo;
	spf=pass (imf03.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ngTtFusTfZr+Of7JLZyU1CxmNJum730Dky6yyjZX8hM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790597317; v=1; x=1791202117;
 b=exO8AcIopGtVEY45vqBpq1JN4Temm8AG2wOgr+XOdedY/hhBYnHRN9wRIFREBNxwQt/MQzyP
 +Dn6cSne7XZbaXI8ORzFEqIBZU2bNnvn0jdWYJMU9QsSydJD9ipLPi8jeY3NxG2JzlN4pLlvbGv
 QUm9aXmEP7ljh7C0pXZCjNMo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 17011efc67c7e6a9;
	Mon, 28 Sep 2026 12:08:37 +0000
X-Mizu-Trace-ID: 17011efc67c7e6a9
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH RFC v2 1/7] mm/memcontrol: drop unused vmscan tracepoint
 include
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260928114625.3609130-2-ridong.chen@linux.dev>
Date: Mon, 28 Sep 2026 20:08:16 +0800
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
Content-Transfer-Encoding: 7bit
Message-Id: <FFCBD11C-B723-441A-B6ED-6AD6E59648E7@linux.dev>
References: <20260928114625.3609130-1-ridong.chen@linux.dev>
 <20260928114625.3609130-2-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13E8A2000B
X-Stat-Signature: c4jgn3zccgnsgmthmjgwskuwxrfkazwd
X-HE-Tag: 1790597318-112394
X-HE-Meta: U2FsdGVkX19yL0MmBbe+T0RFhr/UuDhCkfU6dOZiC5zc+tPgOakuCsDdM1sUy/dd+29laXAZRr6uFFfit/KqSScO26F5Wu7x/+sUNXEUdE4HL+ATxO0wPsbKN3mi/kjzcZR+lrNgjyPmXWqptXYJLyNkDzekmxXf8tXvb1zOGoifx/VbOjzxsbleDbb+dLpJSeLtbrkvngLQTQLkjoGad41KKHXb/Aeh8qvhm1fKskRwoudqhYAqhDMceTja+oLo5qenNkLpUEzQjZpNANOUBqb0XVxMjOd4yHl+FocAF2FGcW8cn0qLjExZjTFMkecgetsIGEIOPYT07zF7VgQl5mJXM/SKhKFIhEe2/5trIVjjEN5911YolTzB/EGzjZRK9htELXR/3BOpb2P86JfPsHbjL1oPKybwF6q+DbQNieX8GUVmdXtC9SzLd4X8Jmo2BBJ1rv3ARK5wXE1vDB6Gv26O4CWcLSQ3wW1/mpfK0u/UtHFBfePxL+i1Yb1Vu7xdJlG8BCtxYPHh1RQM4KrZaN6+RC/viMV9+AtYPgDVUEbUSzpU9FZF0O58QMxJWdK5r4F5Kz05BBqUTb7ITA0CiN6DBvGdGvvgsEOOSd4p2HV7/ElqI4JHBzNN64FoIe0LsanvD02UJJAOFcK0PdWJNA4Nz9NGDnWSkKtU7dgSWLQ5dLPsPZ2gd5eewAXS5q3vcbtUQooTMz6wc/0VXcW47pvViWj0ac94YIZzQXyzLgpz/KiZOYGvWY1MhwabQT/LUNICD5rOSku8IpTCTRKcFKauux7CP+6I2Os8gHfuBaCCJabMIWKkNA2cFMIG1PpaOI7FhlBqQsqUCbroNHWDaRhyUFooAdq3oVqHtC/69LIZidBMVt2HeJnQd1GMUWvKXcYF/Ve6Nl2LnViKGCeBbE4z18ELFdCpyu6/6nF2P5AWgchods34VkimVjnoXMP3DK6+Ylig/RyEdUbZqb0
 bjruBBsq
 Fh1AHPHa7ZaiWlSGjGHhIr0RF48V3cl23c7SXuwW+rN35KkW6p0qp5Ay6C1ffKWtxHOi3U4Jy687SKqpAXbFGvTFEvUF5ktWyR6dQa67MoeflzsWL8SVA4IGegN5nZLs51Hwb7ZyyZpl0C2SSHlhsuv2bupefjNXX5H2ixYmK6CM5DZvxAz1/lSTfdaNlu4QCPNWuvPfeLNyKFEH1QC8krPyqAn8OWj9q+V/9IsqnkfdzqbjbferAXF4OBf3n+itaufwjQ2nMsSiQBQTfNVBYzo1lLbBP1b2EXSABA/ImPq1hVurnIMjl38OOWQX4KV40b1B3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 28, 2026, at 19:46, Ridong Chen <ridong.chen@linux.dev> wrote:
> 
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> memcontrol.c includes <trace/events/vmscan.h> but does not use any of
> the tracepoints or macros it defines: all tracepoints invoked here come
> from memcg.h and writeback.h.  Removing the include still compiles
> cleanly.
> 
> Assisted-by: Claude:claude-opus-4-8

Since commit 816d9992d9ed, the label we recommend is Assisted-by: LLM.

> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
> mm/memcontrol.c | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index aad0498a7bd6..95c2322d4a6f 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -77,8 +77,6 @@
> #include <trace/events/memcg.h>
> #undef CREATE_TRACE_POINTS
> 
> -#include <trace/events/vmscan.h>
> -
> struct cgroup_subsys memory_cgrp_subsys __read_mostly;
> EXPORT_SYMBOL(memory_cgrp_subsys);

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.



