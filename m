Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB49CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 08:37:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5158B900112; Thu, 14 Aug 2025 04:37:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 470BF900088; Thu, 14 Aug 2025 04:37:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3602F900112; Thu, 14 Aug 2025 04:37:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 25038900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:37:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E11651DD909
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:37:39 +0000 (UTC)
X-FDA: 83774709438.02.A6DB5F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2C351160008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 08:37:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j6oXdcgV;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755160658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpcplE9GK+U01o+94FQbXtHCnB3QDoQF4QT+tsJzRxc=;
	b=FHihV+jOkjN3SSB33rzKn4SBFwLjX5xNfKhoOF8BLBBw2RLVxZI9cfXImAFtVJNrBZuKgF
	kWI7FosP44Px1Ro7mBuuroiTxtVe5LDVvNXqrAV1Iu1ndRhmJFStJvbB3af/pOniezE4fI
	EfKNhkIDui5PmZoPVqL/C6WKgSTGlJ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755160658; a=rsa-sha256;
	cv=none;
	b=DibeTb8ey/RFrdyGmB/tKUyEdy8+UELX3KL8ioYreKXsvC0VGpC31aVjeEWP83XnoJSM8+
	iIR+tuXD2D/t9keRnQA+zRO7dir9UAYzkIVmvr2AvcvZ1HATq0nSBGNui6FeozzHAzK/3S
	ZodDYLfeVHR/RLnjqaRVqd4UkF7zs7A=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j6oXdcgV;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CDF3945BD2;
	Thu, 14 Aug 2025 08:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35236C4CEEF;
	Thu, 14 Aug 2025 08:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755160656;
	bh=ySpcFEqW6mx248pQaNRvOQVwo6ykQE7J6nfU5QTBWiE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j6oXdcgVciv/6BykGif5185QIWWX9Vff7Gxpuxu1c1XK1or/K4wIhNhT+pes02G9K
	 zNvEs9K7QoOxvFG6Fw6noFJ20aHFitgr//ZwU3ghWpn8hW+AZTT8MPYTZwBmVsq1BP
	 LtAHwk+FdENWA+tnwN91riEqFzg7OMFUoCJOD8tWN/cLUZAp5E/TlJ4I9v8XQTwYoA
	 +hgzErxjxvLrVN6Sg/aAGfeSYznXOQeiDmqdUmH9KK7FNbXA0BzTgKv7hIbx3uYcaC
	 1Q2vqEreet9nlLsh5+8IyBPu0V3x30wCUzSOutTeO/X0ojmjwMiGayPIX3+Z7mxNOI
	 OH9otFL1/ZPiQ==
Date: Thu, 14 Aug 2025 11:37:14 +0300
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
Subject: Re: [PATCH 06/10] mm: update coredump logic to correctly use bitmap
 mm flags
Message-ID: <aJ2gOkevzkXazfvv@kernel.org>
References: <cover.1755012943.git.lorenzo.stoakes@oracle.com>
 <2a5075f7e3c5b367d988178c79a3063d12ee53a9.1755012943.git.lorenzo.stoakes@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5075f7e3c5b367d988178c79a3063d12ee53a9.1755012943.git.lorenzo.stoakes@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2C351160008
X-Stat-Signature: esys9twqtzf75cdfft3nmerdpmrjbnix
X-HE-Tag: 1755160657-693806
X-HE-Meta: U2FsdGVkX1+Czyc1hqAmKWCW3au11P/thhsGilnlkNJmy+3b/PHFIjT5d8ZL+vxq2DbLrVK4UCh6s+qWIkLJXifdlRVdRm5EmyokRnkOL7j+ftLEhH314IuXq8KVxPCdto85CoRk344aKrnjBNVuOZjZzrDiHTg7Jrcy6g/1Yvj1GJUCFni1t4lWH+z79ABdxSZt8aZKr1L50PgHRlWpDPkiccjxbWlk2phKlIvgkuxWBUVkmNrAoTAUfSRocrcrzpZ5WgN8lqF25q/P3/ItQJUBh6VXP2Tdy60fSU3VtrYJkA+6nsV/3THQAOjYeh7QeMHgTO78WvuIVzs5cuoyh6GYkn4mInyJLIFZQVFnw/MTB8kIg2IOLF20rGmN++a//E3qpJJK++j8fGLYwLQ25jJJgyGfdHTzt7shjoHVVE0d0pV74JzXBZfGtutTQh1QwqjnecZ+uBcXm+KIYBrP5TyrABQmY6TdrLxTugAfZLeQw6ldKbs9IIYQqofQpo/QD3YWmDUBqiZxYgK6TlfPDCF/+IB/pVdnZ40B5OfcWMzCGmcwgZXm/9nvSm8XiMNiIfScIG9eOvz/TDdOgSCrw9KJGKykxdeEXrMYBUU4ReCEpuZqmRDyTLMnuS1SIM0dRzBmQroik8aGHhaHc6YGCK7tadLTbaRURC9dDuAi9Uiw/PO/P/t+Ih4Qkmu0nvzPo7nb0r8vWDqPuR8rqS6Gvhxaz6STL7IBCyvGwG1FYxLnanj/Xas7GCbJ2v9zYHhVE2KNb3ZMUaLkxoFVvxnBkADUNrQZp5Qb3H0WqdGXWJMpS6AupoD8fp1BXcG8Z9QAk6+pSShsL5vb7TYgDbBIOvoSnjsA5gHTuzhiJTCBZAIjArNo0ghpCZN+e9e8TFriGcJE79egHBo4wMaCp60Nh/t4IaUa78q1ujvRnkCQKENXGK5Nb+GY+g2ffxRC/BK4rHfSOr2UeZkaPUrra4L
 Lto6Jc5V
 Z3ZjS0vuExhMTsKR6yhddPipKOLQ/SpI9lLGImAh1Ie4CLDSKqnpLMWmKupZHf5Nol82jMvMKD/LCgf4G284w3pV1pFkV5gVAhdn4CwzWihgHoLmuJxj8PjYqWZ6jCr3DlWoba9x893B2ZEJJJ8BZ33ZpIrM7tMHiOXULlfWKDK5gEE4kQk0BKpStW6ny5B4reGLLGR2naRP1q09ia3tTReXd/Fc9VCErhwgIRc2urRP3D0vwA0CKH84RgsFm7osknZcdvmDu0LxxQPXrhvOG2hXTAls6/LIz/wM6YYiuH/Y4aZfrDk6ttyE3iqhbn+S6hlYfL+f0bdFWkmY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 04:44:15PM +0100, Lorenzo Stoakes wrote:
> The coredump logic is slightly different from other users in that it both
> stores mm flags and additionally sets and gets using masks.
> 
> Since the MMF_DUMPABLE_* flags must remain as they are for uABI reasons,
> and of course these are within the first 32-bits of the flags, it is
> reasonable to provide access to these in the same fashion so this logic can
> all still keep working as it has been.
> 
> Therefore, introduce coredump-specific helpers __mm_flags_get_dumpable()
> and __mm_flags_set_mask_dumpable() for this purpose, and update all core
> dump users of mm flags to use these.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  fs/coredump.c                  |  4 +++-
>  fs/exec.c                      |  2 +-
>  fs/pidfs.c                     |  7 +++++--
>  fs/proc/base.c                 |  8 +++++---
>  include/linux/sched/coredump.h | 21 ++++++++++++++++++++-
>  5 files changed, 34 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/coredump.c b/fs/coredump.c
> index fedbead956ed..e5d9d6276990 100644
> --- a/fs/coredump.c
> +++ b/fs/coredump.c
> @@ -1103,8 +1103,10 @@ void vfs_coredump(const kernel_siginfo_t *siginfo)
>  		 * We must use the same mm->flags while dumping core to avoid
>  		 * inconsistency of bit flags, since this flag is not protected
>  		 * by any locks.
> +		 *
> +		 * Note that we only care about MMF_DUMP* flags.
>  		 */
> -		.mm_flags = mm->flags,
> +		.mm_flags = __mm_flags_get_dumpable(mm),
>  		.vma_meta = NULL,
>  		.cpu = raw_smp_processor_id(),
>  	};
> diff --git a/fs/exec.c b/fs/exec.c
> index 2a1e5e4042a1..dbac0e84cc3e 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1999,7 +1999,7 @@ void set_dumpable(struct mm_struct *mm, int value)
>  	if (WARN_ON((unsigned)value > SUID_DUMP_ROOT))
>  		return;
>  
> -	set_mask_bits(&mm->flags, MMF_DUMPABLE_MASK, value);
> +	__mm_flags_set_mask_dumpable(mm, value);
>  }
>  
>  SYSCALL_DEFINE3(execve,
> diff --git a/fs/pidfs.c b/fs/pidfs.c
> index edc35522d75c..5148b7646b7f 100644
> --- a/fs/pidfs.c
> +++ b/fs/pidfs.c
> @@ -357,8 +357,11 @@ static long pidfd_info(struct file *file, unsigned int cmd, unsigned long arg)
>  
>  	if ((kinfo.mask & PIDFD_INFO_COREDUMP) && !(kinfo.coredump_mask)) {
>  		task_lock(task);
> -		if (task->mm)
> -			kinfo.coredump_mask = pidfs_coredump_mask(task->mm->flags);
> +		if (task->mm) {
> +			unsigned long flags = __mm_flags_get_dumpable(task->mm);
> +
> +			kinfo.coredump_mask = pidfs_coredump_mask(flags);
> +		}
>  		task_unlock(task);
>  	}
>  
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 62d35631ba8c..f0c093c58aaf 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2962,8 +2962,10 @@ static ssize_t proc_coredump_filter_read(struct file *file, char __user *buf,
>  	ret = 0;
>  	mm = get_task_mm(task);
>  	if (mm) {
> +		unsigned long flags = __mm_flags_get_dumpable(mm);
> +
>  		len = snprintf(buffer, sizeof(buffer), "%08lx\n",
> -			       ((mm->flags & MMF_DUMP_FILTER_MASK) >>
> +			       ((flags & MMF_DUMP_FILTER_MASK) >>
>  				MMF_DUMP_FILTER_SHIFT));
>  		mmput(mm);
>  		ret = simple_read_from_buffer(buf, count, ppos, buffer, len);
> @@ -3002,9 +3004,9 @@ static ssize_t proc_coredump_filter_write(struct file *file,
>  
>  	for (i = 0, mask = 1; i < MMF_DUMP_FILTER_BITS; i++, mask <<= 1) {
>  		if (val & mask)
> -			set_bit(i + MMF_DUMP_FILTER_SHIFT, &mm->flags);
> +			mm_flags_set(i + MMF_DUMP_FILTER_SHIFT, mm);
>  		else
> -			clear_bit(i + MMF_DUMP_FILTER_SHIFT, &mm->flags);
> +			mm_flags_clear(i + MMF_DUMP_FILTER_SHIFT, mm);
>  	}
>  
>  	mmput(mm);
> diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
> index 6eb65ceed213..19ecfcceb27a 100644
> --- a/include/linux/sched/coredump.h
> +++ b/include/linux/sched/coredump.h
> @@ -2,12 +2,29 @@
>  #ifndef _LINUX_SCHED_COREDUMP_H
>  #define _LINUX_SCHED_COREDUMP_H
>  
> +#include <linux/compiler_types.h>
>  #include <linux/mm_types.h>
>  
>  #define SUID_DUMP_DISABLE	0	/* No setuid dumping */
>  #define SUID_DUMP_USER		1	/* Dump as user of process */
>  #define SUID_DUMP_ROOT		2	/* Dump as root */
>  
> +static inline unsigned long __mm_flags_get_dumpable(struct mm_struct *mm)
> +{
> +	/*
> +	 * By convention, dumpable bits are contained in first 32 bits of the
> +	 * bitmap, so we can simply access this first unsigned long directly.
> +	 */
> +	return __mm_flags_get_word(mm);
> +}
> +
> +static inline void __mm_flags_set_mask_dumpable(struct mm_struct *mm, int value)
> +{
> +	unsigned long *bitmap = ACCESS_PRIVATE(&mm->_flags, __mm_flags);
> +
> +	set_mask_bits(bitmap, MMF_DUMPABLE_MASK, value);
> +}
> +
>  extern void set_dumpable(struct mm_struct *mm, int value);
>  /*
>   * This returns the actual value of the suid_dumpable flag. For things
> @@ -22,7 +39,9 @@ static inline int __get_dumpable(unsigned long mm_flags)
>  
>  static inline int get_dumpable(struct mm_struct *mm)
>  {
> -	return __get_dumpable(mm->flags);
> +	unsigned long flags = __mm_flags_get_dumpable(mm);
> +
> +	return __get_dumpable(flags);
>  }
>  
>  #endif /* _LINUX_SCHED_COREDUMP_H */
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

