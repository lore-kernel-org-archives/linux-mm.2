Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865E5C4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 21:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DBA6B008A; Tue, 21 Jul 2026 17:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CEC16B008C; Tue, 21 Jul 2026 17:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5B06B0092; Tue, 21 Jul 2026 17:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 370BC6B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:17:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B6728A0A28
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:17:17 +0000 (UTC)
X-FDA: 85014044514.15.0F2638D
Received: from relay.hostedemail.com (unirelay01 [10.200.18.64])
	by imf17.hostedemail.com (Postfix) with ESMTP id E041E4000F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:17:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784668635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yVAxUnO4A137Z2Xfm8wJ22Yu15H+Dm6y+/+D7l+981s=;
	b=AqknJ7uC2oMq67jvfDoe0A2uwXKzWOpL+jNcj4X2F7yMWoAQJ6elmzo/l9Or9dT4PQ67he
	F+7cy5vlZJ+iXkcFqqiWDtdbV6MQyumxgbPAD+4Yny/MaQKN6UMv8iE0NDjP5W46eN3jr7
	rPyVtU9NBK6avs0+E3N8LYyR0CXdkR8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784668635;
	b=0l+w3TGkLYtjgCh98PpepGk8c/MHI1TU3RaXqA6h2i0flkCApJE4oqNdKvi0hDhaOZR4LH
	utVbu4LJdd3zcqQASbH24b6msC6o0lowDGrKnVDY1mun4LzsgQsLwRy5l3mWd6OgyKB6lQ
	T/dWKlDh70lLAxK/vEnB3qRLR7wek+g=
Received: from omf10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 204EA1C03FB;
	Tue, 21 Jul 2026 21:17:13 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id DF8AF35;
	Tue, 21 Jul 2026 21:17:05 +0000 (UTC)
Date: Tue, 21 Jul 2026 17:17:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Aditya Sharma <adi.sharma@zohomail.in>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, David Rientjes <rientjes@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Kees Cook
 <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra
 <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot
 <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Valentin
 Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>,
 linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-kernel@vger.kernel.org,
 imbrenda@linux.ibm.com
Subject: Re: [RFC PATCH 6/7] mm: add tracepoints and vmstat counters for
 async teardown
Message-ID: <20260721171724.56f1aad5@gandalf.local.home>
In-Reply-To: <20260719185409.409685-7-adi.sharma@zohomail.in>
References: <20260719185409.409685-1-adi.sharma@zohomail.in>
	<20260719185409.409685-7-adi.sharma@zohomail.in>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX1+/ste/MyujSSeKSM6VrsZlDhaJTmhqqpE=
X-HE-Meta: U2FsdGVkX1+37sIM9lG4/zgdYQ9Eq4DMj9ICc9L+iKjZogAd1/mA/GA6amAuJMJbN3PsQ0qohHAMZGj7vbCevm3bBwwvOmY6AED/Ow+q6CVegC+1eRe/+akgpMaHk8PjPnmNUoI4uuFKKl0KtKxmQjpsEY2ZI6It5d4pD4hjUp32ge0UDoqIeflNRvXHurGfgaR7L3E2gvANNnVQHz9S7/W2oVTnBzRtJ9VSIWGY1MNdPtUYoVNOAdFVxrRfp1tBRzlUFFpGImYwryMsrmMRQ17caaZHPwu2aKixNJIhwzWZe+NLXb/GcPA6ab5mtk+t
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E041E4000F
X-Stat-Signature: hajr163uj95yroneduzq5thctc1speyw
X-HE-Tag-Orig: 1784668625-226901
X-HE-Tag: 1784668635-7007
X-HE-Meta: U2FsdGVkX1/FFbndWMv/Gh0VYlLkJ+2MeD7l2w6lYp7O67U3Np3PNhgw8Xl1cOjEIBUeVoBEQ4O6bc8ynRBLug99SpQ3Zn3dP3/c0hJy9g0OZ85avlSHLvttl91HekO0vTX7IDLqNykoV5wp9rT2lWmSQONAmbaHW+8b3lY9zAUVPFmHd+jn8KgYIRMCWTMOhErraqvh7eqTUAixXazER1OhQVwa9wzUntuTn1xO5XfWAqnxse68Qgp/H5r9PC05Q6UiekdzHVzLj2WqjEOonzhD3Ctrspvwy5XAkV0haOUKHT9hmRSXo7iLpoZ7mADTXSu6HzfF4+8I8L4f4Tsyqmmd0Wld0zE7kAiP20o5jhut4yi3J3IXw+4Ez7zOJ+yCWIGGDP422m0Emuz9FwQeVayPuB/qsLN2wmy9gn2RhJa4Qk30pkNUITUkaVD0Y5Rc4rbYoi5sPKzHSkvzLnGHkyrVqoPsymcVV1+4kTig5RzbmbUEajYmi8EL04sP27CzEvnS3zd2RpS0Wy/kftaGKOy9c7agPcxrNwQE5/54vGtXW8yIvLBWFKeECc5IqOM6/1adh6ldwtQ3v0sg38RYYgkX9x+qrGqQASOBzTrxymv3f/DFFXJ1ozMlmKAmmZXwZ9NllVzd2Cl8kTtrPTkDJLY5+nYAZ8VmIOCRyCu3zAhhs1VE1ypq9nEMfDEiZeSm/L+fkG9h0nRGpObKVeubSDEgACxKn7D0TIKEHNpRAxikJgggGbrzZ5Jpem3H16JFys7tY6X6RYd0Hi5Ez8XrBm8zS7dRrGNX9ATdgLAmImyH7nn4NXTPmIY+evnkocAHeY7j3Iuln3lSJG3OB7IaTHuzatWhggm7qubHt7Btd2uONdBp+KSm91NSoGTE83kfqIZdYD8+9BS2Xa+mD1g7U5KbQyE1t4l6kiV/qfat3lIQ9MtkIeqU1ROliVygCQQe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 00:24:08 +0530
Aditya Sharma <adi.sharma@zohomail.in> wrote:

> diff --git a/include/trace/events/mm_reaper.h b/include/trace/events/mm_reaper.h
> new file mode 100644
> index 000000000..315bced7c
> --- /dev/null
> +++ b/include/trace/events/mm_reaper.h
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#undef TRACE_SYSTEM
> +#define TRACE_SYSTEM mm_reaper
> +
> +#if !defined(_TRACE_MM_REAPER_H) || defined(TRACE_HEADER_MULTI_READ)
> +#define _TRACE_MM_REAPER_H
> +
> +#include <linux/tracepoint.h>
> +#include <linux/sched.h>
> +#include <linux/topology.h>
> +
> +TRACE_EVENT(mm_async_teardown_queue,
> +
> +	TP_PROTO(struct mm_struct *mm, unsigned long rss),
> +
> +	TP_ARGS(mm, rss),
> +
> +	TP_STRUCT__entry(
> +		__field(struct mm_struct *, mm)
> +		__field(int, pid)
> +		__array(char, comm, TASK_COMM_LEN)

There's an effort to make comm size more dynamic and we want to prevent more
memcpy of the comm based on TASK_COMM_LEN. Please change the above to:

		__string(comm, comm);


> +		__field(unsigned long, rss)
> +		__field(int, node)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->mm = mm;
> +		__entry->pid = current->pid;
> +		memcpy(__entry->comm, current->comm, TASK_COMM_LEN);

And this to:

		__assign_str(comm);

> +		__entry->rss = rss;
> +		__entry->node = numa_node_id();
> +	),
> +
> +	TP_printk("mm=%p pid=%d comm=%s rss=%lukB node=%d",
> +		__entry->mm,
> +		__entry->pid,
> +		__entry->comm,

and this to:

		__get_str(comm),

Thanks,

-- Steve

> +		__entry->rss << (PAGE_SHIFT - 10),
> +		__entry->node
> +	)
> +);
> +

