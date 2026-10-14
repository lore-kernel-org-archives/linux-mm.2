Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A474ECC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041036B0099; Wed, 14 Oct 2026 05:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33246B009B; Wed, 14 Oct 2026 05:32:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB416B009D; Wed, 14 Oct 2026 05:32:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF016B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:32:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C4900401F1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:32:16 +0000 (UTC)
X-FDA: 85320715872.23.1E03B9E
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id C735540003
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:32:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pe3uPyiB;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970335;
	b=VcRYOR1e27C1+b1tn0OAVqNcLaHjI+pMKduPHNyWwWMkfNrD0DNdb2Xq1G/2L0GD+0YWPG
	zthwaEkbwgrjJFqWrO9Ad3pR8k2Y+GATam/eD60Qrcy958AoZjaKJMvmzB1NTedFPpiBsR
	vWnf2+tBk6hLEC9UfsXOLcwBtT6Jw04=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Pe3uPyiB;
	spf=pass (imf27.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbp1OaXo+QOhXfEK2yTqfOOSMPB/aU27i+I9ooebTqo=;
	b=tz7aneyRNa4raNxQs076NFIElxqwJlwjq8n/0h9SXFVbZushyvsUT7rZgiwwZFQnGkjZVJ
	jrO3aEjzlpClPF/9HYnGUTxBCmTYx/KMiR6xNR032RwfuulGsXNCSw7J5CV5ijyXGkgEfI
	OkvZuBuKUIu5QMdP6QwT3o3jIGvuWss=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a16c1608faso50434135e9.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:32:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791970333; x=1792575133; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qbp1OaXo+QOhXfEK2yTqfOOSMPB/aU27i+I9ooebTqo=;
        b=Pe3uPyiBrlDCukuJPWXBHi6fzG+a5utrO/hCvdJ76gU/Dm8Snwf3cGagYX5jv1ZDdG
         1J8NC5O3V5qjrYZiJ9DLC62V9FYCUAUyCD+Fk/iDEMnx0fjN0EQz5ySgRb4RRGkAXp9e
         hpBS/h/3UHymJHFaUH06gH6orDL7NX+4pQcEmS3L2Jq6byafi/0EXfjwHd69bgu3O+lj
         3Jx0/IBSksiArA9LTkIfvwGMRvgxO0AJrL8C09651b7WP46+ThxxUB+b2MaDOBiIx1XD
         PnpJUUTezOAOkXqacOxpGJDzlm8dcoXifOer4IQ+ZLT401brm6/67c/BtCtSB98BP7RX
         isrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791970333; x=1792575133;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qbp1OaXo+QOhXfEK2yTqfOOSMPB/aU27i+I9ooebTqo=;
        b=AZ7ENL7P8yqKHBm4qFTAHikMFqcKsLvt0KoqpmfhlkXycQl9k0AabPzXeUvIHIAoNd
         EYPRIDN+Il8EboMIdBOpLuOIdmy9Y58v+ecKMQb7OmDIDfTurPvKygOWLzyETBxFIdle
         TO3iAcU8us2/UN1oTdjZyn5bzW25aK/u5K7BL/rNc2kYYBHw3BZp3jFv/leDobUDKL6a
         C95SXzGzs6MkIe6CM1rLv/PUqRgcX1VRY7h58WsxdBLRBCMi7NMGbTyjZ5eANzLW8iUF
         f4eKE516s+R2vDpMW36QhPm3ejWYCm9nkJKToPW/sT0x9QQJt8eTnZCbqOag3taz2r79
         O4bQ==
X-Forwarded-Encrypted: i=1; AKwUvBwrftMpwBrtrCQUQqSfvROxN+f6c4i2rvZnZbazET86I3qi75t1uV2PxL0IX9Aj7n3UGIcJNZELkw==@kvack.org
X-Gm-Message-State: AFq9FYL/3Ik2BEgDqMzakBu2tr5fP/izjjPvF+VyGL1qy0Q9Nmye29iW
	dSMzwOf+g4Lg1rldN3gl9C3RJM841lY48oXWZwYLlz1TEXJA9FA1ZQi5MRHVZELEWONAt7rEdvd
	K0QN7n1E=
X-Gm-Gg: AYBFou27JJG7O2mONXVro4LBP/piMemHkqczrryZGYyi1Bw0jWVwKgpuGcoSCKMBd4a
	scV11xl9jcV1W61QCiS0Jq9cXb/mQpgxuRUU2aHbdQWr7hes8rloRtfQXrm8PpH95+U2yq2pk1+
	qSahfvmEikOaGEZlMsUGJcG6zZ5r1lJcXr+hd37a3AM+EFKSq64/OnX4DhfBKNtb7csnM0NaypL
	qrOfdW0VUbPr3fyrjxspPkBZvloI74oM+9QCNC+ElRk3RAfvlga3Ty47DjQ9MUOsjdr67yXrR7Y
	lYrPGQDoLjbrZL9utKwpclkmrsRmAt/cPei0OzyyX3iYFUxLKQMLyVDPW6W8M9Yf7gWGOQQ+kZp
	kwDF4WAvougdY0gre6BDe0wM+g+zWsV/FicqvuQttldrlVhj7eo51QUhFhlRqhE0e5t20CRgZ8c
	1rXw66oHSbdgqUrWreRyqz/Vl+nQJhtlS59CY0zT0W0CU8zoGbKhAjmTro7s/vIKZSGWT14Obdl
	/6Z4gwK/8+3
X-Received: by 2002:a05:600c:8a09:20b0:4a1:9c98:b9b8 with SMTP id 5b1f17b1804b1-4a19c98c153mr160639475e9.11.1791970333205;
        Wed, 14 Oct 2026 02:32:13 -0700 (PDT)
Received: from localhost (109-81-25-183.rct.o2.cz. [109.81.25.183])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48de0aaaaebsm10999272f8f.14.2026.10.14.02.32.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 02:32:12 -0700 (PDT)
Date: Wed, 14 Oct 2026 11:32:11 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ye Liu <ye.liu@linux.dev>
Cc: David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Ye Liu <liuye@kylinos.cn>
Subject: Re: [PATCH] proc: Move OOM-related procfs code to fs/proc/oom.c
Message-ID: <as9MG_BtepLV6DsC@tiehlicka>
References: <20261014-oom_procfs-v1-1-f2d75e73571e@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261014-oom_procfs-v1-1-f2d75e73571e@linux.dev>
X-Stat-Signature: 1zgnw8fa6cruzckxoabjf195r7nrzsm3
X-Rspamd-Queue-Id: C735540003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791970334-314048
X-HE-Meta: U2FsdGVkX18Lt5yW6O6Vwq2n7RqG6A9LNRxVFR7cT7desmUtGTa6V42z+HqES5abEATt3ddo9jSNxL+37cf0/fEvs1IKZ4w/cIp47Z4ifucIhpFSQ8wV9FTEwkRAcL7KuAJoj41K5WinLHTH77CvRmvrcpfWubhw7/JiOh+TTz93QH4yJ7KfsL4Qz+nuZt9f7oESLXXX+ZJQt3vRrYqe5eS0M8/F0kth9W07h7jG7cYZMcI4UmiW+Pp1ZkqQytU1cA9x4dn6hDhkFGMj9BYACIma/LtWnQwQIvWeGwYFS3ZVGqUsh6u+NURwiKPyEMfY2KixkDg6jFL8Z6JQBXwqNEiuD3889rnOe/dBviinVbcjbjarnw/IFcC2HW3U27e+OkWBkM43mKR7ZdrH5xDsJWRhQ6QSrLuTmLajUILD0B9uyA67rKDLSx89O9C2Hszg7UourO7iJ5Dr0/o6XQ84eiqzl7UnptrtqztYI4Hz822/JYNh0voqPPm0N4taKiJrznb2QpqeFIfYKPUNWHpoczEzss6pISlqewjC7dKFtk45ZWDzx9kblrVkjo7j1j1MdvtSucWQdGq1Fa4f+iLu09LUX+c1Dr0l1stVq/46HRFREx2eYe+pKpTLhYN/nQsYYqhS5t9zIPCYYxrvlaRW/dCHEdovxYOXp80JMrewWfx6Qm6Kd0yd6CXwvMaqlGqevgKRYxXj1ef7+iR+Rwt8S/Vdz2vuKvh8x2CojLrk3wKvuY8O2IiwaVLSV+02/d86l50SfejQY8vcQNAuhJ+9OqX6YaaTBwCO1yO8X5ph8y1jrV0erefBuZAhjfU8/4HqMQ86G8ABfrgq8X2z6hNAfpxC0dkdV3B3Ea90QFXXQLAeJF2pwYZ9qOqAvmAm8k2zfx0T1yFswLF8bAGuFrseZ5G5z856BtpTL+jzBx0nYKAsheCSy+OFtaoFmWzlalCt7sXN2wZu7fgv+bjqGGQ
 7XcN8Ct2
 WeMUYuUSzrPPPbC5NKiaiHDx2uIR3Jh8ui9v+qN1QumUDQJn6zgEqe5P0Wn2faD0ABCkL0t0FU+FmmG7TrL5JBNYHvMUcjff0vMBfHsxTeQopnuiJL/KU3UqRVQnz3PDYF8BqCSNW5zu4IDT7iPKXRhH+U8IOBaW/6S+3Z2U0t5WniJ+joGdnGgQoND2Bhv37OTh8zlL3fxV7cl9HQNi6vpnzJIsOAaWpSjrT2z+FeJWa0SGvmI5bt5SvmugpjOQc8jU+YhTcnuffSXLhuE6Jsbu21SDdDdflbTfAJARKxHT+LtiO/tKk/OxQYdfJZqBk72b6qB2GWtQ8NGfW0JKORiiTuqLMheGGiTLgME8ZZaQ6gvShDTeCSB2pz8YDDUvz1KD111nV5GGj26h73Lm6EFVuyHM5IbeX8jP5cBOmibHDF1PS2I76E09GPmrz2qyF+Jy+sukYhR+JlJkJlIty4K0auQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 14-10-26 16:54:12, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> fs/proc/base.c is a large file (~3700 lines) handling all per-process
> procfs entries. The OOM score, oom_adj, and oom_score_adj interface
> code is self-contained and has no dependencies on other parts of
> base.c, so move it into a dedicated fs/proc/oom.c following the same
> pattern as fs/proc/fd.c and fs/proc/task_mmu.c.
> 
> This makes both files easier to read and keeps OOM-related procfs
> entries together in one place.

Are there plans to separate other functionality or is this one off
thing?
In general I am not against of moving stuff to more specialized files.
An obvious downside is a review as it is quite easy to overlook a subtle
change when moving so much code. Something worth undertaking if there
is a bigger goal. Not so sure if this is just a one of and fs/proc/base.c
still keeps other random stuff in.

> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  MAINTAINERS        |   1 +
>  fs/proc/Makefile   |   1 +
>  fs/proc/base.c     | 232 -------------------------------------------------
>  fs/proc/internal.h |   8 ++
>  fs/proc/oom.c      | 249 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 259 insertions(+), 232 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1da3623e77ce..4b1c13a65136 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17676,6 +17676,7 @@ R:	David Rientjes <rientjes@google.com>
>  R:	Shakeel Butt <shakeel.butt@linux.dev>
>  L:	linux-mm@kvack.org
>  S:	Maintained
> +F:	fs/proc/oom.c
>  F:	include/linux/oom.h
>  F:	include/trace/events/oom.h
>  F:	include/uapi/linux/oom.h
> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
> index 27e2b26b2d42..68e65866b5df 100644
> --- a/fs/proc/Makefile
> +++ b/fs/proc/Makefile
> @@ -21,6 +21,7 @@ proc-y += interrupts.o
>  endif
>  proc-y	+= loadavg.o
>  proc-y	+= meminfo.o
> +proc-y	+= oom.o
>  proc-y	+= stat.o
>  proc-y	+= uptime.o
>  proc-y	+= util.o
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 8c04fcd436d2..26ccc05a50ff 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -80,7 +80,6 @@
>  #include <linux/audit.h>
>  #include <linux/poll.h>
>  #include <linux/nsproxy.h>
> -#include <linux/oom.h>
>  #include <linux/elf.h>
>  #include <linux/pid_namespace.h>
>  #include <linux/user_namespace.h>
> @@ -99,7 +98,6 @@
>  #include <linux/cn_proc.h>
>  #include <linux/ksm.h>
>  #include <uapi/linux/lsm.h>
> -#include <trace/events/oom.h>
>  #include "internal.h"
>  #include "fd.h"
>  
> @@ -580,28 +578,6 @@ static const struct file_operations proc_lstats_operations = {
>  
>  #endif
>  
> -static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
> -			  struct pid *pid, struct task_struct *task)
> -{
> -	unsigned long totalpages = totalram_pages() + total_swap_pages;
> -	unsigned long points = 0;
> -	long badness;
> -
> -	badness = oom_badness(task, totalpages);
> -	/*
> -	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
> -	 * badness value into [0, 2000] range which we have been
> -	 * exporting for a long time so userspace might depend on it.
> -	 */
> -	if (badness != LONG_MIN)
> -		points = (OOM_SCORE_ADJ_MAX +
> -			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
> -
> -	seq_printf(m, "%lu\n", points);
> -
> -	return 0;
> -}
> -
>  struct limit_names {
>  	const char *name;
>  	const char *unit;
> @@ -1115,214 +1091,6 @@ static const struct file_operations proc_auxv_operations = {
>  	.release	= mem_release,
>  };
>  
> -static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
> -			    loff_t *ppos)
> -{
> -	struct task_struct *task = get_proc_task(file_inode(file));
> -	char buffer[PROC_NUMBUF];
> -	int oom_adj = OOM_ADJUST_MIN;
> -	size_t len;
> -
> -	if (!task)
> -		return -ESRCH;
> -	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
> -		oom_adj = OOM_ADJUST_MAX;
> -	else
> -		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
> -			  OOM_SCORE_ADJ_MAX;
> -	put_task_struct(task);
> -	if (oom_adj > OOM_ADJUST_MAX)
> -		oom_adj = OOM_ADJUST_MAX;
> -	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
> -	return simple_read_from_buffer(buf, count, ppos, buffer, len);
> -}
> -
> -static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
> -{
> -	struct mm_struct *mm = NULL;
> -	struct task_struct *task;
> -	int err = 0;
> -
> -	task = get_proc_task(file_inode(file));
> -	if (!task)
> -		return -ESRCH;
> -
> -	mutex_lock(&oom_adj_mutex);
> -	if (legacy) {
> -		if (oom_adj < task->signal->oom_score_adj &&
> -				!capable(CAP_SYS_RESOURCE)) {
> -			err = -EACCES;
> -			goto err_unlock;
> -		}
> -		/*
> -		 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
> -		 * /proc/pid/oom_score_adj instead.
> -		 */
> -		pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
> -			  current->comm, task_pid_nr(current), task_pid_nr(task),
> -			  task_pid_nr(task));
> -	} else {
> -		if ((short)oom_adj < task->signal->oom_score_adj_min &&
> -				!capable(CAP_SYS_RESOURCE)) {
> -			err = -EACCES;
> -			goto err_unlock;
> -		}
> -	}
> -
> -	/*
> -	 * Make sure we will check other processes sharing the mm if this is
> -	 * not vfrok which wants its own oom_score_adj.
> -	 * pin the mm so it doesn't go away and get reused after task_unlock
> -	 */
> -	if (!task->vfork_done) {
> -		struct task_struct *p = find_lock_task_mm(task);
> -
> -		if (p) {
> -			if (mm_flags_test(MMF_MULTIPROCESS, p->mm)) {
> -				mm = p->mm;
> -				mmgrab(mm);
> -			}
> -			task_unlock(p);
> -		}
> -	}
> -
> -	task->signal->oom_score_adj = oom_adj;
> -	if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
> -		task->signal->oom_score_adj_min = (short)oom_adj;
> -	trace_oom_score_adj_update(task);
> -
> -	if (mm) {
> -		struct task_struct *p;
> -
> -		rcu_read_lock();
> -		for_each_process(p) {
> -			if (same_thread_group(task, p))
> -				continue;
> -
> -			/* do not touch kernel threads or the global init */
> -			if (p->flags & PF_KTHREAD || is_global_init(p))
> -				continue;
> -
> -			task_lock(p);
> -			if (!p->vfork_done && process_shares_mm(p, mm)) {
> -				p->signal->oom_score_adj = oom_adj;
> -				if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
> -					p->signal->oom_score_adj_min = (short)oom_adj;
> -			}
> -			task_unlock(p);
> -		}
> -		rcu_read_unlock();
> -		mmdrop(mm);
> -	}
> -err_unlock:
> -	mutex_unlock(&oom_adj_mutex);
> -	put_task_struct(task);
> -	return err;
> -}
> -
> -/*
> - * /proc/pid/oom_adj exists solely for backwards compatibility with previous
> - * kernels.  The effective policy is defined by oom_score_adj, which has a
> - * different scale: oom_adj grew exponentially and oom_score_adj grows linearly.
> - * Values written to oom_adj are simply mapped linearly to oom_score_adj.
> - * Processes that become oom disabled via oom_adj will still be oom disabled
> - * with this implementation.
> - *
> - * oom_adj cannot be removed since existing userspace binaries use it.
> - */
> -static ssize_t oom_adj_write(struct file *file, const char __user *buf,
> -			     size_t count, loff_t *ppos)
> -{
> -	char buffer[PROC_NUMBUF] = {};
> -	int oom_adj;
> -	int err;
> -
> -	if (count > sizeof(buffer) - 1)
> -		count = sizeof(buffer) - 1;
> -	if (copy_from_user(buffer, buf, count)) {
> -		err = -EFAULT;
> -		goto out;
> -	}
> -
> -	err = kstrtoint(strstrip(buffer), 0, &oom_adj);
> -	if (err)
> -		goto out;
> -	if ((oom_adj < OOM_ADJUST_MIN || oom_adj > OOM_ADJUST_MAX) &&
> -	     oom_adj != OOM_DISABLE) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> -
> -	/*
> -	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
> -	 * value is always attainable.
> -	 */
> -	if (oom_adj == OOM_ADJUST_MAX)
> -		oom_adj = OOM_SCORE_ADJ_MAX;
> -	else
> -		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
> -
> -	err = __set_oom_adj(file, oom_adj, true);
> -out:
> -	return err < 0 ? err : count;
> -}
> -
> -static const struct file_operations proc_oom_adj_operations = {
> -	.read		= oom_adj_read,
> -	.write		= oom_adj_write,
> -	.llseek		= generic_file_llseek,
> -};
> -
> -static ssize_t oom_score_adj_read(struct file *file, char __user *buf,
> -					size_t count, loff_t *ppos)
> -{
> -	struct task_struct *task = get_proc_task(file_inode(file));
> -	char buffer[PROC_NUMBUF];
> -	short oom_score_adj = OOM_SCORE_ADJ_MIN;
> -	size_t len;
> -
> -	if (!task)
> -		return -ESRCH;
> -	oom_score_adj = task->signal->oom_score_adj;
> -	put_task_struct(task);
> -	len = snprintf(buffer, sizeof(buffer), "%hd\n", oom_score_adj);
> -	return simple_read_from_buffer(buf, count, ppos, buffer, len);
> -}
> -
> -static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
> -					size_t count, loff_t *ppos)
> -{
> -	char buffer[PROC_NUMBUF] = {};
> -	int oom_score_adj;
> -	int err;
> -
> -	if (count > sizeof(buffer) - 1)
> -		count = sizeof(buffer) - 1;
> -	if (copy_from_user(buffer, buf, count)) {
> -		err = -EFAULT;
> -		goto out;
> -	}
> -
> -	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
> -	if (err)
> -		goto out;
> -	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
> -			oom_score_adj > OOM_SCORE_ADJ_MAX) {
> -		err = -EINVAL;
> -		goto out;
> -	}
> -
> -	err = __set_oom_adj(file, oom_score_adj, false);
> -out:
> -	return err < 0 ? err : count;
> -}
> -
> -static const struct file_operations proc_oom_score_adj_operations = {
> -	.read		= oom_score_adj_read,
> -	.write		= oom_score_adj_write,
> -	.llseek		= default_llseek,
> -};
> -
>  #ifdef CONFIG_AUDIT
>  #define TMPBUFLEN 11
>  static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index df873df9afc5..b72a2bd604ed 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -238,6 +238,14 @@ static inline int folio_average_page_mapcount(struct folio *folio)
>  	/* ... but return at least 1. */
>  	return max_t(int, avg + entire_mapcount, 1);
>  }
> +/*
> + * oom.c
> + */
> +int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
> +		   struct pid *pid, struct task_struct *task);
> +extern const struct file_operations proc_oom_adj_operations;
> +extern const struct file_operations proc_oom_score_adj_operations;
> +
>  /*
>   * array.c
>   */
> diff --git a/fs/proc/oom.c b/fs/proc/oom.c
> new file mode 100644
> index 000000000000..5f22ec4a4a6e
> --- /dev/null
> +++ b/fs/proc/oom.c
> @@ -0,0 +1,249 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * OOM-related procfs entries
> + *
> + * This file handles the OOM score, oom_adj, and oom_score_adj interfaces
> + * in /proc/<pid>/.
> + */
> +
> +#include <linux/proc_fs.h>
> +#include <linux/oom.h>
> +#include <linux/seq_file.h>
> +#include <linux/capability.h>
> +#include <linux/mm.h>
> +#include <linux/swap.h>
> +#include <linux/sched/signal.h>
> +#include <linux/pid_namespace.h>
> +#include <trace/events/oom.h>
> +
> +#include "internal.h"
> +
> +int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
> +		   struct pid *pid, struct task_struct *task)
> +{
> +	unsigned long totalpages = totalram_pages() + total_swap_pages;
> +	unsigned long points = 0;
> +	long badness;
> +
> +	badness = oom_badness(task, totalpages);
> +	/*
> +	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
> +	 * badness value into [0, 2000] range which we have been
> +	 * exporting for a long time so userspace might depend on it.
> +	 */
> +	if (badness != LONG_MIN)
> +		points = (OOM_SCORE_ADJ_MAX +
> +			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
> +
> +	seq_printf(m, "%lu\n", points);
> +
> +	return 0;
> +}
> +
> +static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
> +			    loff_t *ppos)
> +{
> +	struct task_struct *task = get_proc_task(file_inode(file));
> +	char buffer[PROC_NUMBUF];
> +	int oom_adj = OOM_ADJUST_MIN;
> +	size_t len;
> +
> +	if (!task)
> +		return -ESRCH;
> +	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
> +		oom_adj = OOM_ADJUST_MAX;
> +	else
> +		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
> +			  OOM_SCORE_ADJ_MAX;
> +	put_task_struct(task);
> +	if (oom_adj > OOM_ADJUST_MAX)
> +		oom_adj = OOM_ADJUST_MAX;
> +	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
> +	return simple_read_from_buffer(buf, count, ppos, buffer, len);
> +}
> +
> +static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
> +{
> +	struct mm_struct *mm = NULL;
> +	struct task_struct *task;
> +	int err = 0;
> +
> +	task = get_proc_task(file_inode(file));
> +	if (!task)
> +		return -ESRCH;
> +
> +	mutex_lock(&oom_adj_mutex);
> +	if (legacy) {
> +		if (oom_adj < task->signal->oom_score_adj &&
> +				!capable(CAP_SYS_RESOURCE)) {
> +			err = -EACCES;
> +			goto err_unlock;
> +		}
> +		/*
> +		 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
> +		 * /proc/pid/oom_score_adj instead.
> +		 */
> +		pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
> +			  current->comm, task_pid_nr(current), task_pid_nr(task),
> +			  task_pid_nr(task));
> +	} else {
> +		if ((short)oom_adj < task->signal->oom_score_adj_min &&
> +				!capable(CAP_SYS_RESOURCE)) {
> +			err = -EACCES;
> +			goto err_unlock;
> +		}
> +	}
> +
> +	/*
> +	 * Make sure we will check other processes sharing the mm if this is
> +	 * not vfrok which wants its own oom_score_adj.
> +	 * pin the mm so it doesn't go away and get reused after task_unlock
> +	 */
> +	if (!task->vfork_done) {
> +		struct task_struct *p = find_lock_task_mm(task);
> +
> +		if (p) {
> +			if (mm_flags_test(MMF_MULTIPROCESS, p->mm)) {
> +				mm = p->mm;
> +				mmgrab(mm);
> +			}
> +			task_unlock(p);
> +		}
> +	}
> +
> +	task->signal->oom_score_adj = oom_adj;
> +	if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
> +		task->signal->oom_score_adj_min = (short)oom_adj;
> +	trace_oom_score_adj_update(task);
> +
> +	if (mm) {
> +		struct task_struct *p;
> +
> +		rcu_read_lock();
> +		for_each_process(p) {
> +			if (same_thread_group(task, p))
> +				continue;
> +
> +			/* do not touch kernel threads or the global init */
> +			if (p->flags & PF_KTHREAD || is_global_init(p))
> +				continue;
> +
> +			task_lock(p);
> +			if (!p->vfork_done && process_shares_mm(p, mm)) {
> +				p->signal->oom_score_adj = oom_adj;
> +				if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
> +					p->signal->oom_score_adj_min = (short)oom_adj;
> +			}
> +			task_unlock(p);
> +		}
> +		rcu_read_unlock();
> +		mmdrop(mm);
> +	}
> +err_unlock:
> +	mutex_unlock(&oom_adj_mutex);
> +	put_task_struct(task);
> +	return err;
> +}
> +
> +/*
> + * /proc/pid/oom_adj exists solely for backwards compatibility with previous
> + * kernels.  The effective policy is defined by oom_score_adj, which has a
> + * different scale: oom_adj grew exponentially and oom_score_adj grows linearly.
> + * Values written to oom_adj are simply mapped linearly to oom_score_adj.
> + * Processes that become oom disabled via oom_adj will still be oom disabled
> + * with this implementation.
> + *
> + * oom_adj cannot be removed since existing userspace binaries use it.
> + */
> +static ssize_t oom_adj_write(struct file *file, const char __user *buf,
> +			     size_t count, loff_t *ppos)
> +{
> +	char buffer[PROC_NUMBUF] = {};
> +	int oom_adj;
> +	int err;
> +
> +	if (count > sizeof(buffer) - 1)
> +		count = sizeof(buffer) - 1;
> +	if (copy_from_user(buffer, buf, count)) {
> +		err = -EFAULT;
> +		goto out;
> +	}
> +
> +	err = kstrtoint(strstrip(buffer), 0, &oom_adj);
> +	if (err)
> +		goto out;
> +	if ((oom_adj < OOM_ADJUST_MIN || oom_adj > OOM_ADJUST_MAX) &&
> +	     oom_adj != OOM_DISABLE) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
> +	 * value is always attainable.
> +	 */
> +	if (oom_adj == OOM_ADJUST_MAX)
> +		oom_adj = OOM_SCORE_ADJ_MAX;
> +	else
> +		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
> +
> +	err = __set_oom_adj(file, oom_adj, true);
> +out:
> +	return err < 0 ? err : count;
> +}
> +
> +const struct file_operations proc_oom_adj_operations = {
> +	.read		= oom_adj_read,
> +	.write		= oom_adj_write,
> +	.llseek		= generic_file_llseek,
> +};
> +
> +static ssize_t oom_score_adj_read(struct file *file, char __user *buf,
> +					size_t count, loff_t *ppos)
> +{
> +	struct task_struct *task = get_proc_task(file_inode(file));
> +	char buffer[PROC_NUMBUF];
> +	short oom_score_adj = OOM_SCORE_ADJ_MIN;
> +	size_t len;
> +
> +	if (!task)
> +		return -ESRCH;
> +	oom_score_adj = task->signal->oom_score_adj;
> +	put_task_struct(task);
> +	len = snprintf(buffer, sizeof(buffer), "%hd\n", oom_score_adj);
> +	return simple_read_from_buffer(buf, count, ppos, buffer, len);
> +}
> +
> +static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
> +					size_t count, loff_t *ppos)
> +{
> +	char buffer[PROC_NUMBUF] = {};
> +	int oom_score_adj;
> +	int err;
> +
> +	if (count > sizeof(buffer) - 1)
> +		count = sizeof(buffer) - 1;
> +	if (copy_from_user(buffer, buf, count)) {
> +		err = -EFAULT;
> +		goto out;
> +	}
> +
> +	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
> +	if (err)
> +		goto out;
> +	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
> +			oom_score_adj > OOM_SCORE_ADJ_MAX) {
> +		err = -EINVAL;
> +		goto out;
> +	}
> +
> +	err = __set_oom_adj(file, oom_score_adj, false);
> +out:
> +	return err < 0 ? err : count;
> +}
> +
> +const struct file_operations proc_oom_score_adj_operations = {
> +	.read		= oom_score_adj_read,
> +	.write		= oom_score_adj_write,
> +	.llseek		= default_llseek,
> +};
> 
> ---
> base-commit: 1fffefb00cc0b0da1f2ae24e3d33364530ea6515
> base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> change-id: 20261014-oom_procfs-f74a922f73f1
> 
> Best regards,
> --  
> Ye Liu <ye.liu@linux.dev>

-- 
Michal Hocko
SUSE Labs

