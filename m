Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B3ED31A02
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 03:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B481E6B0089; Tue, 13 Jan 2026 22:18:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB736B008C; Tue, 13 Jan 2026 22:18:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2B406B0092; Tue, 13 Jan 2026 22:18:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8E34C6B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 22:18:55 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F4ED8B543
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:18:55 +0000 (UTC)
X-FDA: 84329112630.12.15BCA50
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2BBA7140007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 03:18:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MvYrejet;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768360733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WGeHR91DnaFjXcFfiXwgbC4LRrRNSlt1d1O4e0c5nlk=;
	b=41D5IZp0vmx+eCwPiZ/VlpmO7iuPlREA2YQt4b5WT9C4eLolqmk/FhBXf8kePSVQdNHTGP
	1yDP5m+KcNeiuAcLn1dFTCgX0DxHgnJhEhXfQtyUu4ZvrB9wub7fI+3twDnx+ZkvVJBaaG
	jaXsiqn0SDqrBmr265/I+I4B+nYA7Pg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=MvYrejet;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768360733; a=rsa-sha256;
	cv=none;
	b=mf7rf0DdGgAKFvUGXnIQXLf1k/Renj3AQeN7O4hx6k+Y47JRqQEAJKspZD6KOCchZbx/mO
	V+it+epYnvoxSpQ7cvQminzYt7rMwDpGKBptAqsIwJriGVxMwmFGwcU87jUl5Q+jafmIaS
	Rp1ivttaAuc1QCM1YSh3FzcJvS7gs6g=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1768360728; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=WGeHR91DnaFjXcFfiXwgbC4LRrRNSlt1d1O4e0c5nlk=;
	b=MvYrejetuKh0S/yxpbp7nf0Njm6how9FRINmGN1hleAHWCw+3Uj1ZpHOaN4vwsu4v68R3kgyMFTaBGToHFrhde8IN7Wfj4MInYZehxh6VVhzAg7qkcyBeCTwMousZOexGdrbsIj8cuU+3G2DcE9NLnBSRD8uYRHxpXX5K6RttmI=
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wx0hUXu_1768360725 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 14 Jan 2026 11:18:46 +0800
Message-ID: <b5621fc0-5fe0-4ba8-a6f1-84f09f54d186@linux.alibaba.com>
Date: Wed, 14 Jan 2026 11:18:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] mm: Fix OOM killer and proc stats inaccuracy on
 large many-core systems
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>,
 Martin Liu <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>,
 SeongJae Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <liam.howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Christian Brauner <brauner@kernel.org>,
 Wei Yang <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>,
 Miaohe Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, stable@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Mateusz Guzik
 <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
References: <20260113194734.28983-1-mathieu.desnoyers@efficios.com>
 <20260113194734.28983-2-mathieu.desnoyers@efficios.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260113194734.28983-2-mathieu.desnoyers@efficios.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7yicpn15ajtzrsnkip88z6gip1d15maz
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BBA7140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768360731-898216
X-HE-Meta: U2FsdGVkX1+6QEanS6+ZGCEkfUT3zrVEYevc2ymZswJPKvvFFMIijYN06NOeM9sXfVmwz8yXQDt7H+c4Tbv3Wj4Rt7oQkNIeCKmoXMMdZg6Ax5E7CRxGHuqW9jnUgvoknk9QREsj8NuPSlLKzQEoIMbE368zrv1uzFrIOqXkrCoB+r+VRXj+m+Blm66t8UYyJwS90TxCHQs/8B19QrbXHlxMcn4xyRW917fwgQDaK4tY1ozjBFKtE78edbLR3SQukH+KS2tMSZ47L+SZWmO3olti3IZryLLc8raH8GieJzGwfDTuzCtR+p90xdCMDpk33H7sGC/Cb+S2ZYfDR+DOwUfasX0z/vxiMT9NuTWXfpB7gB63wwMVvbOzYNilMZFaX0INFJ309gZ4aBm0uGFEZKf9TKQtdfzbiDKzCjNA/enYFT4vdsqn/wKpEueOisHDv+7L3BPxA/xt21StttaRErWBJNqFC1H2xpLzkIFFtFKMd5IC+zpMh0JHa51GzBYijV8jJWg1mkjkeMcoK+ZL9K9dQtZ80EzNuR913Hpt5P4yT3Lnrgz5/pCOaQKLBTloDLXcWwg3W2aAqQWNRZ+VirAGp/X/s+IXX0AIu1VRfCYLVS9Zoib51arlGnOjHPd88PI8/aKB11d7dG8Z9zdm1k9Iy8yAUdfCHxRrDHDrQETayuJXXlBlli6/Jnad4uw8VSqmBzpd7JbXEhV5s/nPkUC/mbsIJvYIu3ab6pLn7jelejbFatze/kcBnsOFwKQ1F0riCpEO2Tb0bp/aK/zYdxiJ8QC4g//vSPt9N4WVTOr1Ekkp7ldLb6kDTdDaDm1lkFn+Py1VqXCbPYrYFIZhTEACeev5nIg2+TQNQn6YGX1deXphE7kPCH6yMloLVKAFNxuP287yenxQLZfBFuM1gzGeSkO0DGH7ifUqgrM/AFlrDoMNt9zy/9bkFbQH86JJqeAWB1C+F6iwv0WJ1Mr
 yfM2hTKI
 vHykmZJbgdZOuPqbfbsijn6+zoP7rl8BJ6zjpP8OL0xkZhv8ZSQh61d0XmyT2KD85Bf9FXmUVR2zD27N03duBxDr2wuhUqu+2SBQu71XvRMD5lqkNGY2S8H9AAqcQZTKIfVFAm6p8I8KOOyI7jA8SbX2NkP1TlUO6esOFpDEdRTm7uPPio7lg+cuTHPAjKY5KRlDdW8y/y6mv9kNAqBl22fhpk6iSDTuEeqgF51TIH+JzmCEM7wjRZVflVOxYxd/mvNsDuVnJPeaUTIPT5Fcms9QTmjmmlC3AJoo45OlrYMAH6dg3Uy7JKUJAqvAfuVUZy8WG4j3/0qXoWqq1poyMT5knyW1Sg1ZRsZGj+4KKnx0dqHtelXEP0Ov4kSQFu42iowBNzQoKr/emxgsJHbJG3xsA2f/SuQ+1pZ5oGWm4TgyLwR4kVgHoGdh7ATb/ca4Ci7kEwHq/2bd6gr6nxbdURTicvBA3Vk9pMnYF9GMT2BZ6pi6Ffwu+QWgQpTtIwmk6zfimuAoj/5eeV8T3RvMdfnBPd6xtypEXTfBK1nKers9YNZDvMzeq/LFA0V0aONpxhHtSjkMd5Q2NFN1GYrDvfJD3FTjlGoVk6p4WIakoYViFnXmdln23ulkpZ5boNoxbVKT3B2B3ElM1igdA6Sr8Qg2Wk6ayLQTEuAXoHeMbZ/eIwSpbmfNPxqSLzLR1xjbvUc4HecS1ADSljtrezxQuSz2MQSlWgvjvGQCRo7YM5LUV+LNK5MWdccf6lFpfDqVlyXSki8LAJXTagkGeT1pL82+Mns+Bj+qvHveV/nkc7kuYUqtinOMwrZlZbXgXqxZQagYd2EFTiN4yblBHzfy+DIzreZCJ6KtdADsTFuJ6hXWj7xZWMzfXhE8wPPr6xeuN8HJe4415EBDHxAwYKChpYrIlGiospFPiL184Qzl7hO4TkI6iDxbGmUTsNjiiMX0gjg+HmBd7VTwpgSZFrdwaISzUwkjc
 ys2DQGKY
 PKlz+cqrFjspLK8a1nhgVAG/1jvpBwxX5raDHL98MXjqm2Maj5kGRMhmSgOv0DTlGyqfBgFLd+KZAUYNYMpF6xFe20Vc2uqUwO0+sgSEVuyRnVsFjox3JgtmcNNPEqubIxVLHsSW8so=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 1/14/26 3:47 AM, Mathieu Desnoyers wrote:
> Use the precise, albeit slower, precise RSS counter sums for the OOM
> killer task selection and proc statistics. The approximated value is
> too imprecise on large many-core systems.
> 
> The following rss tracking issues were noted by Sweet Tea Dorminy [1],
> which lead to picking wrong tasks as OOM kill target:
> 
>    Recently, several internal services had an RSS usage regression as part of a
>    kernel upgrade. Previously, they were on a pre-6.2 kernel and were able to
>    read RSS statistics in a backup watchdog process to monitor and decide if
>    they'd overrun their memory budget. Now, however, a representative service
>    with five threads, expected to use about a hundred MB of memory, on a 250-cpu
>    machine had memory usage tens of megabytes different from the expected amount
>    -- this constituted a significant percentage of inaccuracy, causing the
>    watchdog to act.
> 
>    This was a result of commit f1a7941243c1 ("mm: convert mm's rss stats
>    into percpu_counter") [1].  Previously, the memory error was bounded by
>    64*nr_threads pages, a very livable megabyte. Now, however, as a result of
>    scheduler decisions moving the threads around the CPUs, the memory error could
>    be as large as a gigabyte.
> 
>    This is a really tremendous inaccuracy for any few-threaded program on a
>    large machine and impedes monitoring significantly. These stat counters are
>    also used to make OOM killing decisions, so this additional inaccuracy could
>    make a big difference in OOM situations -- either resulting in the wrong
>    process being killed, or in less memory being returned from an OOM-kill than
>    expected.
> 
> Here is a (possibly incomplete) list of the prior approaches that were
> used or proposed, along with their downside:
> 
> 1) Per-thread rss tracking: large error on many-thread processes.
> 
> 2) Per-CPU counters: up to 12% slower for short-lived processes and 9%
>     increased system time in make test workloads [1]. Moreover, the
>     inaccuracy increases with O(n^2) with the number of CPUs.
> 
> 3) Per-NUMA-node counters: requires atomics on fast-path (overhead),
>     error is high with systems that have lots of NUMA nodes (32 times
>     the number of NUMA nodes).
> 
> The simple fix proposed here is to do the precise per-cpu counters sum
> every time a counter value needs to be read. This applies to the OOM
> killer task selection, to the /proc statistics, and to the oom mark_victim
> trace event.
> 
> Note that commit 82241a83cd15 ("mm: fix the inaccurate memory statistics
> issue for users") introduced get_mm_counter_sum() for precise proc
> memory status queries for _some_ proc files. This change renames
> get_mm_counter_sum() to get_mm_counter(), thus moving the rest of the
> proc files to the precise sum.

I'm not against this patch. However, I’m concerned that it may affect 
not only the rest of the proc files, but also fork(), which calls 
get_mm_rss(). At least we should evaluate its impact on fork()?

> This change effectively increases the latency introduced when the OOM
> killer executes in favor of doing a more precise OOM target task
> selection. Effectively, the OOM killer iterates on all tasks, for all
> relevant page types, for which the precise sum iterates on all possible
> CPUs.
> 
> As a reference, here is the execution time of the OOM killer
> before/after the change:
> 
> AMD EPYC 9654 96-Core (2 sockets)
> Within a KVM, configured with 256 logical cpus.
> 
>                                    |  before  |  after   |
> ----------------------------------|----------|----------|
> nr_processes=40                   |  0.3 ms  |   0.5 ms |
> nr_processes=10000                |  3.0 ms  |  80.0 ms |
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
> Link: https://lore.kernel.org/lkml/20250331223516.7810-2-sweettea-kernel@dorminy.me/ # [1]
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "Paul E. McKenney" <paulmck@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Masami Hiramatsu <mhiramat@kernel.org>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Christoph Lameter <cl@linux.com>
> Cc: Martin Liu <liumartin@google.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: christian.koenig@amd.com
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Miaohe Lin <linmiaohe@huawei.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: linux-mm@kvack.org
> Cc: stable@vger.kernel.org
> Cc: linux-trace-kernel@vger.kernel.org
> Cc: Yu Zhao <yuzhao@google.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Mateusz Guzik <mjguzik@gmail.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
> ---
>   fs/proc/task_mmu.c | 14 +++++++-------
>   include/linux/mm.h |  5 -----
>   2 files changed, 7 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 81dfc26bfae8..8ca4fbf53fc5 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -39,9 +39,9 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
>   	unsigned long text, lib, swap, anon, file, shmem;
>   	unsigned long hiwater_vm, total_vm, hiwater_rss, total_rss;
>   
> -	anon = get_mm_counter_sum(mm, MM_ANONPAGES);
> -	file = get_mm_counter_sum(mm, MM_FILEPAGES);
> -	shmem = get_mm_counter_sum(mm, MM_SHMEMPAGES);
> +	anon = get_mm_counter(mm, MM_ANONPAGES);
> +	file = get_mm_counter(mm, MM_FILEPAGES);
> +	shmem = get_mm_counter(mm, MM_SHMEMPAGES);
>   
>   	/*
>   	 * Note: to minimize their overhead, mm maintains hiwater_vm and
> @@ -62,7 +62,7 @@ void task_mem(struct seq_file *m, struct mm_struct *mm)
>   	text = min(text, mm->exec_vm << PAGE_SHIFT);
>   	lib = (mm->exec_vm << PAGE_SHIFT) - text;
>   
> -	swap = get_mm_counter_sum(mm, MM_SWAPENTS);
> +	swap = get_mm_counter(mm, MM_SWAPENTS);
>   	SEQ_PUT_DEC("VmPeak:\t", hiwater_vm);
>   	SEQ_PUT_DEC(" kB\nVmSize:\t", total_vm);
>   	SEQ_PUT_DEC(" kB\nVmLck:\t", mm->locked_vm);
> @@ -95,12 +95,12 @@ unsigned long task_statm(struct mm_struct *mm,
>   			 unsigned long *shared, unsigned long *text,
>   			 unsigned long *data, unsigned long *resident)
>   {
> -	*shared = get_mm_counter_sum(mm, MM_FILEPAGES) +
> -			get_mm_counter_sum(mm, MM_SHMEMPAGES);
> +	*shared = get_mm_counter(mm, MM_FILEPAGES) +
> +			get_mm_counter(mm, MM_SHMEMPAGES);
>   	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
>   								>> PAGE_SHIFT;
>   	*data = mm->data_vm + mm->stack_vm;
> -	*resident = *shared + get_mm_counter_sum(mm, MM_ANONPAGES);
> +	*resident = *shared + get_mm_counter(mm, MM_ANONPAGES);
>   	return mm->total_vm;
>   }
>   
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 6f959d8ca4b4..d096bb3593ba 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2847,11 +2847,6 @@ static inline bool get_user_page_fast_only(unsigned long addr,
>    * per-process(per-mm_struct) statistics.
>    */
>   static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
> -{
> -	return percpu_counter_read_positive(&mm->rss_stat[member]);
> -}
> -
> -static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
>   {
>   	return percpu_counter_sum_positive(&mm->rss_stat[member]);
>   }


