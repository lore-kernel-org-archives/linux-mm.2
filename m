Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBB6ACA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 763E1900116; Thu, 14 Aug 2025 04:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71401900088; Thu, 14 Aug 2025 04:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6029A900116; Thu, 14 Aug 2025 04:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7DF900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:42:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 072F914058F
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:42:38 +0000 (UTC)
X-FDA: 83774721996.03.D2D42D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4945120006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:42:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N9V8L5Lv;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpWycGqfo381MBQ60BIQKvksuCWRVa/RRiJk+UelBwE=;
	b=PbT6WiMCP29ZcesqfcJpkt+0J8CkHu5Odi+s/nEeBb6f6kUepFcui2rNnezeseLBarxP/W
	j/g17T15Fk5uRgizHswY3YJCixiAjW/zevdLMAwV+whHxPGFkXKopu55dNQ/Eq85JnYRNX
	YJ8Ot+rak9aJi1jZTXr6eH/lEMkKYR8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N9V8L5Lv;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160956; a=rsa-sha256;
	cv=none;
	b=Ff/986mLlmJ+iB49cMWngL1n5D2TPIZKjJwKNYlOaEh4N6yJQHKvB/5JDxK4AE62Z/X3rI
	+L+/BHU0dOgoOem1xoTSmFSk+aszlAAxyGzoXOQueMGE2iRx7/tbEe5GoFSK7z9o4JkX8w
	m3mFHNrK9OmVC+2kdzV7M1dov946Om8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D99741B74;
	Thu, 14 Aug 2025 08:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210FEC4CEEF;
	Thu, 14 Aug 2025 08:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160955;
	bh=SUBXHVjiIpc5FK6CF6DFvCj6KZQzp4Joo5u+EpVZoMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N9V8L5LvpCRYDZdnvjdkWNnyF5ilnojdxYc4xR+1jf6USGswyy05H/dqneQYcqivI
	 gtp73vcs9LYpcfm1CcyfJiZoQwm/beqGU14bCsUmSe5pgghsvWXe6VbDZUcWw9XAo5
	 kY+367T2oc3xqTdlDUBzZlXFMP8exkL3rJ9lRlOAliHsBVllf3aHksUgE0xZHDFda2
	 +vQ+rGSh9gS4COKgE6dNKbUjbLkD95PYty5iSv5A4gWzKrMERDRP062Hw+ci/yY92H
	 0IzfPbHGuYVoXyIfOq89jBHH2U88/SHWfZwfukmOCq0i8qM9O5eCNW3peh3aZeoPBu
	 3W1AMRWMsh3Gw==
Date: Thu, 14 Aug 2025 11:42:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	"David S . Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Mateusz Guzik <mjguzik@gmail.com>, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 09/10] mm: convert remaining users to mm_flags_*()
 accessors
Message-ID: <aJ2hYlUGnAPxPFox@kernel.org>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <cc67a56f9a8746a8ec7d9791853dc892c1c33e0b.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc67a56f9a8746a8ec7d9791853dc892c1c33e0b.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspamd-Queue-Id: 4945120006
X-Rspam-User: 
X-Stat-Signature: 783mzex6ozx6mqwy7ey9apbrowwwmygm
X-Rspamd-Server: rspam09
X-HE-Tag: 1755160956-572693
X-HE-Meta: U2FsdGVkX1+DpwIj1NNNBacaQmw/vmVbvwl4s9ExZLlGOW2PnH3ejnVhw9z6tCaeBWR6ZAkx2y2bN59Sns19HjQp/SD83a899MZOBdBpU5ClGDw5l/htxZ8FlTySUET3h1AgLRLQwwKJy026gviP7Q/bg91kNl2esOH9tjEnlGB2MoE2WY6JSFjBs1hdhgUlmkfoBRA0B3MFfw2DYaqIbjUrhIINfnNtXIOFwNeVB6l8ciG9vsyOoYxR9Hqo8zG/UgR6oRIQSBeHHF6mZYKnBxUbK720FVvo6eR3ZnmSlHJEp6EVESXq2MlVaLoGGoJ6zlZrX4JXbeUcp/kaJRauEO7P7xa1EPuVH3errmU+zlzafcwqBTho7zjW34Jo5OBN32m7tQFf7+lXE3RJfwMXIPC8qkVXl7W2JkAkldLbFx/d5QzcpRb9RDqFoSlM3SmcQgY+SQ1m93b9XXnlvj+RkYEvW5iz3zbnZeNl49D5hNTQUPJaFY5BmymCBWeEQk5/4hzAg8rEsVNuITObiVYr1EKgYznEohUugan7CRgd01gZR33fJlNR5RY4kVdcKxabC4F9MiE/ZEy2lVjpoYhkLsBQ06GooaernBzNRlF8K4TEGq4CURiYussnXEfjDCAouhh5VtnpzzbUP0+5ZaokJTO/10k7Qlw4DDN65RaljPHw6FuuvTxD7jMcalbnSRLE30qFd75cqc7nr5+bEXeqWX4RL58eXHRjOKcyeB2f41agb9XN6ppzmOG+PMccc3Hi87i3TN23oaSnTBPJZWRud8zgk54ECjsRpZGAR3+aozz3fjVN6BjDoUAa/io62YtGNtP8z7WqciIgXn/vM9F/ai5/HrRqLRbIGGSr93V1+SxJ+EeOqvBifpnD83al51bMDHVMgkGOzy/FNtRQw8tCD7NARiNQvvRFo0RHNFxs7miWAJmmRVuUVaYkQvqaUy8x3wjtLaIV4G9qE0dSguk
 k3/qkiCc
 ye/4+XYM+UXrY3583VbXaajrnNV8BrWyMrrxz7iRieIYco5bFsJ9nyuFa+FkmOvsT4z5rbCArhYQ7V9utbSptUSOmGuw04PV56Fi6XvhH4Lr8opdeRUCQic7e2eClVYBoGKpD6gG58t/aArgLs/VhWvBiWwHHE3JrOJPhpew0wnCpS+J8er8bPJ0flo7RI0bXOA5dhTY3OYVBwMmQ2/Y6nXqdywI+1eLlGfB6lpBWcx0kcGi/Ng8iNyLm0Qs8ZmeU6zWl6f8yURwh/Q1HGN6PsyhF0xSc2fXQWZIV7ZGqy5QQUbdHGIUh2hIGkRFn19h2aqPZciXUWCNuIZXORg5flEPYZITWkV2Ru8KkossMI9UmsiKAXxIbbbUDDhmMbYJhzMLQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:18PM +0100, Lorenzo Stoakes wrote:
> As part of the effort to move to mm->flags becoming a bitmap field, convert
> existing users to making use of the mm_flags_*() accessors which will, when
> the conversion is complete, be the only means of accessing mm_struct flags.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  fs/proc/array.c    | 2 +-
>  fs/proc/base.c     | 4 ++--
>  fs/proc/task_mmu.c | 2 +-
>  kernel/fork.c      | 2 +-
>  4 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index d6a0369caa93..c286dc12325e 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -422,7 +422,7 @@ static inline void task_thp_status(struct seq_file *m, struct mm_struct *mm)
>  	bool thp_enabled = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE);
>  
>  	if (thp_enabled)
> -		thp_enabled = !test_bit(MMF_DISABLE_THP, &mm->flags);
> +		thp_enabled = !mm_flags_test(MMF_DISABLE_THP, mm);
>  	seq_printf(m, "THP_enabled:\t%d\n", thp_enabled);
>  }
>  
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index f0c093c58aaf..b997ceef9135 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1163,7 +1163,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
>  		struct task_struct *p = find_lock_task_mm(task);
>  
>  		if (p) {
> -			if (test_bit(MMF_MULTIPROCESS, &p->mm->flags)) {
> +			if (mm_flags_test(MMF_MULTIPROCESS, p->mm)) {
>  				mm = p->mm;
>  				mmgrab(mm);
>  			}
> @@ -3276,7 +3276,7 @@ static int proc_pid_ksm_stat(struct seq_file *m, struct pid_namespace *ns,
>  		seq_printf(m, "ksm_merging_pages %lu\n", mm->ksm_merging_pages);
>  		seq_printf(m, "ksm_process_profit %ld\n", ksm_process_profit(mm));
>  		seq_printf(m, "ksm_merge_any: %s\n",
> -				test_bit(MMF_VM_MERGE_ANY, &mm->flags) ? "yes" : "no");
> +				mm_flags_test(MMF_VM_MERGE_ANY, mm) ? "yes" : "no");
>  		ret = mmap_read_lock_killable(mm);
>  		if (ret) {
>  			mmput(mm);
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e64cf40ce9c4..e8e7bef34531 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1592,7 +1592,7 @@ static inline bool pte_is_pinned(struct vm_area_struct *vma, unsigned long addr,
>  		return false;
>  	if (!is_cow_mapping(vma->vm_flags))
>  		return false;
> -	if (likely(!test_bit(MMF_HAS_PINNED, &vma->vm_mm->flags)))
> +	if (likely(!mm_flags_test(MMF_HAS_PINNED, vma->vm_mm)))
>  		return false;
>  	folio = vm_normal_folio(vma, addr, pte);
>  	if (!folio)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b311caec6419..68c81539193d 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1887,7 +1887,7 @@ static void copy_oom_score_adj(u64 clone_flags, struct task_struct *tsk)
>  
>  	/* We need to synchronize with __set_oom_adj */
>  	mutex_lock(&oom_adj_mutex);
> -	set_bit(MMF_MULTIPROCESS, &tsk->mm->flags);
> +	mm_flags_set(MMF_MULTIPROCESS, tsk->mm);
>  	/* Update the values in case they were changed after copy_signal */
>  	tsk->signal->oom_score_adj = current->signal->oom_score_adj;
>  	tsk->signal->oom_score_adj_min = current->signal->oom_score_adj_min;
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

