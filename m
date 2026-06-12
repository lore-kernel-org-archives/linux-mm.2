Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61147CD98CC
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF706B00AA; Fri, 12 Jun 2026 00:27:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0596B00AC; Fri, 12 Jun 2026 00:27:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C64C6B00AD; Fri, 12 Jun 2026 00:27:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 693026B00AA
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:27:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16B318F634
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:27:56 +0000 (UTC)
X-FDA: 84869977752.06.1E5E329
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id D750918000C
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:27:53 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ouhm2PHh;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781238474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXz0zFjpsEGPITqy3FGqx/I8SNzd+JfjTXLop8dMmx8=;
	b=BYEnNk255f8abwRQN4JFnXpmtq2qWDE9IeIisOQO//+09J0Ynm1WNB6TPQgahlCdD1aS0F
	NzjzrIL+ihZygclFhyfPrpfcaj77Coq0ngBWCtd5ua5PqGvguS5epQTxRXBnX2J7KEN7XQ
	muhkYvOHppfJLOqwaRDh/1CXonMqq3s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781238474;
	b=tXQQsNhQQZUPID66eQIZ8NqnB4hP9YetygHm5vyOek2XKHxRw2kDbmXlIO1iCg7rbIe7XU
	c9PC1MMRvFVkVmL5POO1XWiOYhYcPQM4BqKC/MUKnZNrqjS69oSoI1B3hP8W8UYIFMccxz
	jtMsp9+8+c2eeOcfvnVXa4rQTv6uuZs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ouhm2PHh;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <352cd63b-0936-4723-ac90-f6428a3a1151@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781238471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXz0zFjpsEGPITqy3FGqx/I8SNzd+JfjTXLop8dMmx8=;
	b=Ouhm2PHhrdEY1E3B7QIa38fjSbI+7kD5xWfm1K8C8CpcM+1WdHTP5o8iINqQjIaKQj8TyG
	ilk2AEhZy1QWiDPuv/yWvmMz0PQymnb28Pdqvbr1QavYTPhmzEunrj8HzWO+ap6OZJ0nw+
	aoEZssz5b+qYj+sz0ErHetUXU8lAq8s=
Date: Fri, 12 Jun 2026 12:27:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC] mm/kmemleak: avoid soft lockup when scanning task
 stacks
Content-Language: en-US
To: leitao@debian.org
Cc: catalin.marinas@arm.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com, sj@kernel.org
References: <20260611-kmemleak-stack-resched-v1-1-d6248ade5f4a@debian.org>
 <20260612031605.58235-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260612031605.58235-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D750918000C
X-Stat-Signature: prmd13bghtp57aes7m8iebso7p1n8uwy
X-HE-Tag: 1781238473-965585
X-HE-Meta: U2FsdGVkX1/H5oYNFzQ4vxjEddiiBU/ql0cXYM7dJ9MZTeS1ikqFLARfjjyfX3kAgMSNiDZdsgSOy/jm7g/U67cW+ySuqsBXVIh7VrrDe674uhBsp/Xs7O7SZ3b3umAc7NYz4cPGgKOyEzVIPw+IK+NaG1CPRRsu5Kd0+ndB9ERplX2eIYL0BbjMAvxN8MXeRQUGJE4AGamDX+WqARygbeAPNX2GLnefZOWJNBx/Gb9CU/X3+69zp/9l7IkYfKMvRRgf7YQsLMyY3thi9ngAMEI320Zcgqdb+kqJsY9Cp5mH13uWUbcqZNOJmnnwmsmZLh1jXlZzpOjIy1ZaP4MtfHQvX8ttAbKGqQvDi7pivWHESahDYHqju3HFgqHlHl3KlCjEeGsb2nXcKFo09O+LxDhHgA9zb0A0NsZyj7Yf5wiQmAjdTQUSI3tZqvJH6KuB1Om7DV1lf/C84IW+CqFeZDuyZNHnrjCUrcZ8m+sExiEF3KRluCZAcDv2cgx9X11NMP3NWPp/EboMmg5tShDRzdGySJa5mbXcXB8dwqSu1wfxlKM/aUjiVcpAOZLUnGYZLHpsetoK4wQn1f80lSdIS9+1c3qHkfXrr6ohQ0VobViO+LkFgoB+TvzHc+u2vUYSDwoq7nuQXUJVP0+5Q8kaICVMptVGOB1q3mhSGj94IC/Oj7bo5NWQXcUYVtdcFwLAWGTXF4dJYu11ovyLZhqN2kI1gbmN81p9WO/sTmyiox4Geggf/wcVeJR6WTrfoF1SrXyK0/IewIy1apYSpovjFBo8rAr1dGeaGH5SliswkEta8+TlRXC+Be7z9KAtVph/5duqTKYaDOnHAszuLibmJ8lY+qWAneQhoseiRMjaHgOlAjQOXfGZLZeHJbfB8uYs2JGe+v2rkeq6VmZf8ZokX48hVf+OArkXmiNcnEp7zfhFc5sXzWiosK+kd0JFbdwc3jPGcOwzh3tmGZWjmYI
 iDMykLkl
 dp86M7CYUJwvHh0T7YXJCQvCNdNX2geJSN0xD3gt4b7p34WzatG4tptG7tVBiw/Xqo5Uk3xFvBL/Feb43ZogBEJDTwnbDyHkJRKmWqeIFajiTm6ln7/78+HaOM0kvuDS9dMNB8PNHr71bAgoQk69zsCSG0sK5VnA8lVOIIrKYa5SxKDNfQL0UciyntPMjJbF/buF+IVOJCVfDIB/1GZl7IT0FmJBY0tUparjmJKnyxJSIBzE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/12 11:16, Lance Yang wrote:
> 
> On Thu, Jun 11, 2026 at 05:45:00AM -0700, Breno Leitao wrote:
>> kmemleak_scan() walks every thread and scans its kernel stack under a
>> single rcu_read_lock() with no reschedule point. On a host with very
>> many threads -- amplified by KASAN/lockdep in debug builds -- this loop
>> can hog a CPU long enough to trip the soft lockup watchdog:
>>
>>   watchdog: BUG: soft lockup - CPU#35 stuck for 22s! [kmemleak:537]
>>    scan_block
>>    kmemleak_scan
>>    kmemleak_scan_thread
>>    kthread
> 
> Neat, good catch!
> 
>> A cond_resched() cannot be added directly: the loop runs inside an RCU
>> read-side critical section.
>>
>> Split the scan in two parts:
>>
>> 1) get the list of tasks (with RCU read lock) in an array
>> 2) run scan_block() for the tasks (with cond_reschd()).
>>
>> Is it a sane approach?
> 
> Why not use the kernel/hung_task.c pattern here? Seems simpler, with no
> extra task-array allocation ;)
> 
>> Signed-off-by: Breno Leitao <leitao@debian.org>

Probably wants a Fixes: tag and stable Cc too, no?

>> ---
> 
> Could break RCU only when resched is needed. Pin the current cursors,
> drop RCU, cond_resched(), take RCU again, and continue only if the
> cursors are still alive ;)
> 
> If either cursor died while RCU was droped, stopping this scan round
> should be fine, IMHO.
> 
> ---8<---
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index 7c7ba17ce7af..1062d9545054 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1695,6 +1695,26 @@ static void kmemleak_cond_resched(struct kmemleak_object *object)
>   	put_object(object);
>   }
> 
> +static bool kmemleak_stack_scan_break(struct task_struct *g,
> +				      struct task_struct *p)
> +{
> +	bool can_cont;
> +
> +	get_task_struct(g);
> +	get_task_struct(p);
> +
> +	rcu_read_unlock();
> +	cond_resched();
> +	rcu_read_lock();
> +
> +	can_cont = pid_alive(g) && pid_alive(p);
> +
> +	put_task_struct(p);
> +	put_task_struct(g);
> +
> +	return can_cont;
> +}
> +
>   /*
>    * Print one leak inline. The hex dump is gated on OBJECT_ALLOCATED so it
>    * does not touch user memory that was freed concurrently; the rest of the
> @@ -1894,7 +1914,10 @@ static void kmemleak_scan(void)
>   				scan_block(stack, stack + THREAD_SIZE, NULL);
>   				put_task_stack(p);
>   			}
> +			if (need_resched() && !kmemleak_stack_scan_break(g, p))
> +				goto unlock;
>   		}
> +unlock:
>   		rcu_read_unlock();
>   	}
> ---
> 
> Not tested, though, feel free to grab it if looks sane :)
> 
> [...]
> 
> Cheers, Lance

