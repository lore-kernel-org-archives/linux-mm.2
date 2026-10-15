Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83A41CC6B2D
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 01:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C7E6B0088; Wed, 14 Oct 2026 21:33:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD466B008A; Wed, 14 Oct 2026 21:33:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C933B6B008C; Wed, 14 Oct 2026 21:33:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC106B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:33:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DBA4414067B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:33:02 +0000 (UTC)
X-FDA: 85323137004.16.0C864D1
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	by imf08.hostedemail.com (Postfix) with ESMTP id 70F82160007
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 01:33:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cJ3Pb5tu;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792027981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnis5jNLZbLgZcPVBpQLAFLcI+g705E/HEdpuX+hKA8=;
	b=42v+6xZrJIXyITRQMHpAjH6cholw9cQb75eNY9tND6SN7X8jWImamgVFV3My0dK6YdNQ8N
	rdAbeCosq8ABsDh59TGhvrYE/KMUu25St25VE0wLuJzsPeq9w4j/KTtwJNCOhDlyh9piGd
	w46gZE9xj6NZZedDidJE+RW5sQXcYiQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792027981;
	b=RubnTs8e+FPF0g3TY2C9SlUVsAzOuq/D3sWuQE4pJKbUJPalGn7pJn+JWoruGrYoMEwgfa
	fP65pj45D2l3HnbJGvdXEx+rgpE2Cx2y6/ECuG0KV17syDmSgezo29YfPvICXELj3lZ7ml
	WIw6TOwDjq9W64Y5pi4G8yx7LynXGQQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cJ3Pb5tu;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aW+P9ILvvwCYvBPUVsnfAHf8hxxKF2YQhD2wzjI4WXo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792027978; v=1; x=1792632778;
 b=cJ3Pb5tu41CIIhRAY13mF6/INV/hL3Wj0neqjAYUEubQVdIh1Mwm5kIbhcpyr8ofHeGLIcT2
 khBEvI/v9g/1tXZ04usB+fqOQ2ECFEupMpaEG8EcfIPpQMzQt5D0ts2a0mYTlZpY1lEji4UkuIZ
 crCfBEpxnb+1hj2tsWAuP3SM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1c569dc00d61bffa;
	Thu, 15 Oct 2026 01:32:58 +0000
X-Mizu-Trace-ID: 1c569dc00d61bffa
X-Migadu-Flow: FLOW_OUT
Message-ID: <e51c14e9-5559-4ff7-8a38-de815a8f8230@linux.dev>
Date: Thu, 15 Oct 2026 09:32:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] proc: Move OOM-related procfs code to fs/proc/oom.c
To: Michal Hocko <mhocko@suse.com>
Cc: David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Ye Liu <liuye@kylinos.cn>
References: <20261014-oom_procfs-v1-1-f2d75e73571e@linux.dev>
 <as9MG_BtepLV6DsC@tiehlicka>
Content-Language: en-US
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <as9MG_BtepLV6DsC@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 70F82160007
X-Stat-Signature: 44potktd6xht8akbgg7ix3eqcqiegpuy
X-HE-Tag: 1792027980-320965
X-HE-Meta: U2FsdGVkX1/MHOqhmgiNLIlLBTN+kb42tOTfNI4dwvZ+nNsy7PQ444mhFMooHyqtWviVh9T5gL4cfeSJyKMDiYHVu0LxgB1NW9NbyT7AM+Ob4e8YgA+TifwsMATeUYgtkCmAmy5DH2o/tqh8s9VsomR+DK7vCUQ/kylDOmXN8L2BTQBlYM6L+ND0+xZ6qXn1SqPoj9yfY7ny5eoV2y2tRS9XR0necb3+HtinWGQDVRSVutwN/p8olEoYeytUDsl+DGLpat/xvDp5Y4Mhavg9KTeia8D8MfE9vvTJAjdnMyY5EJgUWuPPJ4kyiSk/AJWi2aBCsulaMp4uvuNskpG0kENIuuE/joq2+80fC+InQZfZBI8sM3SNbkgOUjmW7TS1T/nbG0/oQ8DuHEi0yJY/m6iWepZGZT9M6q7ugL0mH5NjBY5BWI8D1S869ZOnU9+ZRIt0nLDZI2QvGGwtLBykTYaHNiuos6vLkDgpOPV47uOW/YuueDgGOKQ0hhCIRwgODlr9rhLn7J9V1ShooBIVDKjOLyi2tB4MuZB+wLb+PYuhIcaqvCQZVlViHKX0vF5+8Vp6IRpo1aLbB/xlRsbEa1pLx0nbAh9KhGhZjVLqODd9XO5FNWnZNoNQSgYfqJ2cAu/UAT9fUSZJLAuEpkDgK58xUnOSCRqMeC5I7i1lpyXlAfqnxXgZbiL3ttumPR6ic1fsTjfbhDbYM3EHzcOBhLXQ5c1IIWVAieJVPNJ7vDamiLyY8KMlhr5F0uLHRQcxtp1gV2qAgGnatlh5LOFBuorLIeXcZrXNAtUOtJAh3CWx2O8+utePD2gg42VyO7i6BBPZJ81JmJKM+tm1MEEJkyuAPn0Qk9JkjfRl8IlHPkNH0q332LNsJ5wEqqEmbQjXeRKHLW0qXDtvYr2wsTB/zRrXcsAi80DpDz6z5EzQ0l1Dv/rIkFUZVGh0/z5PKGCDZIw99sE+3O/A3qV4vxE
 z3MuKhII
 BVnQYwa3kUOcSA8I+DZ7iTQlw69P2ezUuMu4vma6G05ForRl9BkV2IkF3lrCjnc9hf6iiJz8oS4RRHIXHgysoacNQVbC2r1CK4ugLhUALP37BxIK4VdSqkrG1H9yPU++Z/qblrb/0ofsnTTPzEwcw/xvcuvSeQe2OajtZhN5JyrqcqRswQzxa/ZcfDcT3RYMmuBTtY9qa+JZcw9ZNIf5kyuO9N6kDRkfDSev+1v+Z0BsY3K4QaJcxVS9bBE4FoQ6ZXuzfPcuzm16xKWGdekvE2mMPPgQ4ORJbTo5kh4a+vdIlo25xGMNF1gEvNJguao0zk1uAI3b3a/nXILH+XGRwptLj8Y9brnHvUm1sGzQGiv6YJs8rGv/KMemvLn5VWwLDU1rXQj4lBRHAThMdlnNOuOWBxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/10/14 17:32, Michal Hocko 写道:
> On Wed 14-10-26 16:54:12, Ye Liu wrote:
>> From: Ye Liu <liuye@kylinos.cn>
>>
>> fs/proc/base.c is a large file (~3700 lines) handling all per-process
>> procfs entries. The OOM score, oom_adj, and oom_score_adj interface
>> code is self-contained and has no dependencies on other parts of
>> base.c, so move it into a dedicated fs/proc/oom.c following the same
>> pattern as fs/proc/fd.c and fs/proc/task_mmu.c.
>>
>> This makes both files easier to read and keeps OOM-related procfs
>> entries together in one place.
> 
> Are there plans to separate other functionality or is this one off
> thing?
> In general I am not against of moving stuff to more specialized files.
> An obvious downside is a review as it is quite easy to overlook a subtle
> change when moving so much code. Something worth undertaking if there
> is a bigger goal. Not so sure if this is just a one of and fs/proc/base.c
> still keeps other random stuff in.
> 

Hi Michal,

This is a one-off move specifically for the OOM-related procfs code.
I don't have a broader plan to split up fs/proc/base.c at this time.

I understand the concern about subtle changes during code moves.
To address that, the patch is a pure relocation with no functional
modifications — all function bodies are moved verbatim. The only
non-mechanical changes are:

  - Three symbols (proc_oom_score, proc_oom_adj_operations,
    proc_oom_score_adj_operations) are made non-static and declared
    in fs/proc/internal.h, since base.c still references them via
    the proc_dir_entry table.

  - The oom_adj_mutex static local is moved along with its users.

I have tested the patch and observed no functional issues.

>> Signed-off-by: Ye Liu <liuye@kylinos.cn>
>> ---
>>  MAINTAINERS        |   1 +
>>  fs/proc/Makefile   |   1 +
>>  fs/proc/base.c     | 232 -------------------------------------------------
>>  fs/proc/internal.h |   8 ++
>>  fs/proc/oom.c      | 249 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  5 files changed, 259 insertions(+), 232 deletions(-)
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 1da3623e77ce..4b1c13a65136 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -17676,6 +17676,7 @@ R:	David Rientjes <rientjes@google.com>
>>  R:	Shakeel Butt <shakeel.butt@linux.dev>
>>  L:	linux-mm@kvack.org
>>  S:	Maintained
>> +F:	fs/proc/oom.c
>>  F:	include/linux/oom.h
>>  F:	include/trace/events/oom.h
>>  F:	include/uapi/linux/oom.h
>> diff --git a/fs/proc/Makefile b/fs/proc/Makefile
>> index 27e2b26b2d42..68e65866b5df 100644
>> --- a/fs/proc/Makefile
>> +++ b/fs/proc/Makefile
>> @@ -21,6 +21,7 @@ proc-y += interrupts.o
>>  endif
>>  proc-y	+= loadavg.o
>>  proc-y	+= meminfo.o
>> +proc-y	+= oom.o
>>  proc-y	+= stat.o
>>  proc-y	+= uptime.o
>>  proc-y	+= util.o
>> diff --git a/fs/proc/base.c b/fs/proc/base.c
>> index 8c04fcd436d2..26ccc05a50ff 100644
>> --- a/fs/proc/base.c
>> +++ b/fs/proc/base.c
>> @@ -80,7 +80,6 @@
>>  #include <linux/audit.h>
>>  #include <linux/poll.h>
>>  #include <linux/nsproxy.h>
>> -#include <linux/oom.h>
>>  #include <linux/elf.h>
>>  #include <linux/pid_namespace.h>
>>  #include <linux/user_namespace.h>
>> @@ -99,7 +98,6 @@
>>  #include <linux/cn_proc.h>
>>  #include <linux/ksm.h>
>>  #include <uapi/linux/lsm.h>
>> -#include <trace/events/oom.h>
>>  #include "internal.h"
>>  #include "fd.h"
>>  
>> @@ -580,28 +578,6 @@ static const struct file_operations proc_lstats_operations = {
>>  
>>  #endif
>>  
>> -static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
>> -			  struct pid *pid, struct task_struct *task)
>> -{
>> -	unsigned long totalpages = totalram_pages() + total_swap_pages;
>> -	unsigned long points = 0;
>> -	long badness;
>> -
>> -	badness = oom_badness(task, totalpages);
>> -	/*
>> -	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
>> -	 * badness value into [0, 2000] range which we have been
>> -	 * exporting for a long time so userspace might depend on it.
>> -	 */
>> -	if (badness != LONG_MIN)
>> -		points = (OOM_SCORE_ADJ_MAX +
>> -			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
>> -
>> -	seq_printf(m, "%lu\n", points);
>> -
>> -	return 0;
>> -}
>> -
>>  struct limit_names {
>>  	const char *name;
>>  	const char *unit;
>> @@ -1115,214 +1091,6 @@ static const struct file_operations proc_auxv_operations = {
>>  	.release	= mem_release,
>>  };
>>  
>> -static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
>> -			    loff_t *ppos)
>> -{
>> -	struct task_struct *task = get_proc_task(file_inode(file));
>> -	char buffer[PROC_NUMBUF];
>> -	int oom_adj = OOM_ADJUST_MIN;
>> -	size_t len;
>> -
>> -	if (!task)
>> -		return -ESRCH;
>> -	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
>> -		oom_adj = OOM_ADJUST_MAX;
>> -	else
>> -		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
>> -			  OOM_SCORE_ADJ_MAX;
>> -	put_task_struct(task);
>> -	if (oom_adj > OOM_ADJUST_MAX)
>> -		oom_adj = OOM_ADJUST_MAX;
>> -	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
>> -	return simple_read_from_buffer(buf, count, ppos, buffer, len);
>> -}
>> -
>> -static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
>> -{
>> -	struct mm_struct *mm = NULL;
>> -	struct task_struct *task;
>> -	int err = 0;
>> -
>> -	task = get_proc_task(file_inode(file));
>> -	if (!task)
>> -		return -ESRCH;
>> -
>> -	mutex_lock(&oom_adj_mutex);
>> -	if (legacy) {
>> -		if (oom_adj < task->signal->oom_score_adj &&
>> -				!capable(CAP_SYS_RESOURCE)) {
>> -			err = -EACCES;
>> -			goto err_unlock;
>> -		}
>> -		/*
>> -		 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
>> -		 * /proc/pid/oom_score_adj instead.
>> -		 */
>> -		pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
>> -			  current->comm, task_pid_nr(current), task_pid_nr(task),
>> -			  task_pid_nr(task));
>> -	} else {
>> -		if ((short)oom_adj < task->signal->oom_score_adj_min &&
>> -				!capable(CAP_SYS_RESOURCE)) {
>> -			err = -EACCES;
>> -			goto err_unlock;
>> -		}
>> -	}
>> -
>> -	/*
>> -	 * Make sure we will check other processes sharing the mm if this is
>> -	 * not vfrok which wants its own oom_score_adj.
>> -	 * pin the mm so it doesn't go away and get reused after task_unlock
>> -	 */
>> -	if (!task->vfork_done) {
>> -		struct task_struct *p = find_lock_task_mm(task);
>> -
>> -		if (p) {
>> -			if (mm_flags_test(MMF_MULTIPROCESS, p->mm)) {
>> -				mm = p->mm;
>> -				mmgrab(mm);
>> -			}
>> -			task_unlock(p);
>> -		}
>> -	}
>> -
>> -	task->signal->oom_score_adj = oom_adj;
>> -	if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
>> -		task->signal->oom_score_adj_min = (short)oom_adj;
>> -	trace_oom_score_adj_update(task);
>> -
>> -	if (mm) {
>> -		struct task_struct *p;
>> -
>> -		rcu_read_lock();
>> -		for_each_process(p) {
>> -			if (same_thread_group(task, p))
>> -				continue;
>> -
>> -			/* do not touch kernel threads or the global init */
>> -			if (p->flags & PF_KTHREAD || is_global_init(p))
>> -				continue;
>> -
>> -			task_lock(p);
>> -			if (!p->vfork_done && process_shares_mm(p, mm)) {
>> -				p->signal->oom_score_adj = oom_adj;
>> -				if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
>> -					p->signal->oom_score_adj_min = (short)oom_adj;
>> -			}
>> -			task_unlock(p);
>> -		}
>> -		rcu_read_unlock();
>> -		mmdrop(mm);
>> -	}
>> -err_unlock:
>> -	mutex_unlock(&oom_adj_mutex);
>> -	put_task_struct(task);
>> -	return err;
>> -}
>> -
>> -/*
>> - * /proc/pid/oom_adj exists solely for backwards compatibility with previous
>> - * kernels.  The effective policy is defined by oom_score_adj, which has a
>> - * different scale: oom_adj grew exponentially and oom_score_adj grows linearly.
>> - * Values written to oom_adj are simply mapped linearly to oom_score_adj.
>> - * Processes that become oom disabled via oom_adj will still be oom disabled
>> - * with this implementation.
>> - *
>> - * oom_adj cannot be removed since existing userspace binaries use it.
>> - */
>> -static ssize_t oom_adj_write(struct file *file, const char __user *buf,
>> -			     size_t count, loff_t *ppos)
>> -{
>> -	char buffer[PROC_NUMBUF] = {};
>> -	int oom_adj;
>> -	int err;
>> -
>> -	if (count > sizeof(buffer) - 1)
>> -		count = sizeof(buffer) - 1;
>> -	if (copy_from_user(buffer, buf, count)) {
>> -		err = -EFAULT;
>> -		goto out;
>> -	}
>> -
>> -	err = kstrtoint(strstrip(buffer), 0, &oom_adj);
>> -	if (err)
>> -		goto out;
>> -	if ((oom_adj < OOM_ADJUST_MIN || oom_adj > OOM_ADJUST_MAX) &&
>> -	     oom_adj != OOM_DISABLE) {
>> -		err = -EINVAL;
>> -		goto out;
>> -	}
>> -
>> -	/*
>> -	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
>> -	 * value is always attainable.
>> -	 */
>> -	if (oom_adj == OOM_ADJUST_MAX)
>> -		oom_adj = OOM_SCORE_ADJ_MAX;
>> -	else
>> -		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
>> -
>> -	err = __set_oom_adj(file, oom_adj, true);
>> -out:
>> -	return err < 0 ? err : count;
>> -}
>> -
>> -static const struct file_operations proc_oom_adj_operations = {
>> -	.read		= oom_adj_read,
>> -	.write		= oom_adj_write,
>> -	.llseek		= generic_file_llseek,
>> -};
>> -
>> -static ssize_t oom_score_adj_read(struct file *file, char __user *buf,
>> -					size_t count, loff_t *ppos)
>> -{
>> -	struct task_struct *task = get_proc_task(file_inode(file));
>> -	char buffer[PROC_NUMBUF];
>> -	short oom_score_adj = OOM_SCORE_ADJ_MIN;
>> -	size_t len;
>> -
>> -	if (!task)
>> -		return -ESRCH;
>> -	oom_score_adj = task->signal->oom_score_adj;
>> -	put_task_struct(task);
>> -	len = snprintf(buffer, sizeof(buffer), "%hd\n", oom_score_adj);
>> -	return simple_read_from_buffer(buf, count, ppos, buffer, len);
>> -}
>> -
>> -static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
>> -					size_t count, loff_t *ppos)
>> -{
>> -	char buffer[PROC_NUMBUF] = {};
>> -	int oom_score_adj;
>> -	int err;
>> -
>> -	if (count > sizeof(buffer) - 1)
>> -		count = sizeof(buffer) - 1;
>> -	if (copy_from_user(buffer, buf, count)) {
>> -		err = -EFAULT;
>> -		goto out;
>> -	}
>> -
>> -	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
>> -	if (err)
>> -		goto out;
>> -	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
>> -			oom_score_adj > OOM_SCORE_ADJ_MAX) {
>> -		err = -EINVAL;
>> -		goto out;
>> -	}
>> -
>> -	err = __set_oom_adj(file, oom_score_adj, false);
>> -out:
>> -	return err < 0 ? err : count;
>> -}
>> -
>> -static const struct file_operations proc_oom_score_adj_operations = {
>> -	.read		= oom_score_adj_read,
>> -	.write		= oom_score_adj_write,
>> -	.llseek		= default_llseek,
>> -};
>> -
>>  #ifdef CONFIG_AUDIT
>>  #define TMPBUFLEN 11
>>  static ssize_t proc_loginuid_read(struct file * file, char __user * buf,
>> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
>> index df873df9afc5..b72a2bd604ed 100644
>> --- a/fs/proc/internal.h
>> +++ b/fs/proc/internal.h
>> @@ -238,6 +238,14 @@ static inline int folio_average_page_mapcount(struct folio *folio)
>>  	/* ... but return at least 1. */
>>  	return max_t(int, avg + entire_mapcount, 1);
>>  }
>> +/*
>> + * oom.c
>> + */
>> +int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
>> +		   struct pid *pid, struct task_struct *task);
>> +extern const struct file_operations proc_oom_adj_operations;
>> +extern const struct file_operations proc_oom_score_adj_operations;
>> +
>>  /*
>>   * array.c
>>   */
>> diff --git a/fs/proc/oom.c b/fs/proc/oom.c
>> new file mode 100644
>> index 000000000000..5f22ec4a4a6e
>> --- /dev/null
>> +++ b/fs/proc/oom.c
>> @@ -0,0 +1,249 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * OOM-related procfs entries
>> + *
>> + * This file handles the OOM score, oom_adj, and oom_score_adj interfaces
>> + * in /proc/<pid>/.
>> + */
>> +
>> +#include <linux/proc_fs.h>
>> +#include <linux/oom.h>
>> +#include <linux/seq_file.h>
>> +#include <linux/capability.h>
>> +#include <linux/mm.h>
>> +#include <linux/swap.h>
>> +#include <linux/sched/signal.h>
>> +#include <linux/pid_namespace.h>
>> +#include <trace/events/oom.h>
>> +
>> +#include "internal.h"
>> +
>> +int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
>> +		   struct pid *pid, struct task_struct *task)
>> +{
>> +	unsigned long totalpages = totalram_pages() + total_swap_pages;
>> +	unsigned long points = 0;
>> +	long badness;
>> +
>> +	badness = oom_badness(task, totalpages);
>> +	/*
>> +	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
>> +	 * badness value into [0, 2000] range which we have been
>> +	 * exporting for a long time so userspace might depend on it.
>> +	 */
>> +	if (badness != LONG_MIN)
>> +		points = (OOM_SCORE_ADJ_MAX +
>> +			  badness * OOM_SCORE_ADJ_MAX / (long)totalpages) * 2 / 3;
>> +
>> +	seq_printf(m, "%lu\n", points);
>> +
>> +	return 0;
>> +}
>> +
>> +static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
>> +			    loff_t *ppos)
>> +{
>> +	struct task_struct *task = get_proc_task(file_inode(file));
>> +	char buffer[PROC_NUMBUF];
>> +	int oom_adj = OOM_ADJUST_MIN;
>> +	size_t len;
>> +
>> +	if (!task)
>> +		return -ESRCH;
>> +	if (task->signal->oom_score_adj == OOM_SCORE_ADJ_MAX)
>> +		oom_adj = OOM_ADJUST_MAX;
>> +	else
>> +		oom_adj = (task->signal->oom_score_adj * -OOM_DISABLE) /
>> +			  OOM_SCORE_ADJ_MAX;
>> +	put_task_struct(task);
>> +	if (oom_adj > OOM_ADJUST_MAX)
>> +		oom_adj = OOM_ADJUST_MAX;
>> +	len = snprintf(buffer, sizeof(buffer), "%d\n", oom_adj);
>> +	return simple_read_from_buffer(buf, count, ppos, buffer, len);
>> +}
>> +
>> +static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
>> +{
>> +	struct mm_struct *mm = NULL;
>> +	struct task_struct *task;
>> +	int err = 0;
>> +
>> +	task = get_proc_task(file_inode(file));
>> +	if (!task)
>> +		return -ESRCH;
>> +
>> +	mutex_lock(&oom_adj_mutex);
>> +	if (legacy) {
>> +		if (oom_adj < task->signal->oom_score_adj &&
>> +				!capable(CAP_SYS_RESOURCE)) {
>> +			err = -EACCES;
>> +			goto err_unlock;
>> +		}
>> +		/*
>> +		 * /proc/pid/oom_adj is provided for legacy purposes, ask users to use
>> +		 * /proc/pid/oom_score_adj instead.
>> +		 */
>> +		pr_warn_once("%s (%d): /proc/%d/oom_adj is deprecated, please use /proc/%d/oom_score_adj instead.\n",
>> +			  current->comm, task_pid_nr(current), task_pid_nr(task),
>> +			  task_pid_nr(task));
>> +	} else {
>> +		if ((short)oom_adj < task->signal->oom_score_adj_min &&
>> +				!capable(CAP_SYS_RESOURCE)) {
>> +			err = -EACCES;
>> +			goto err_unlock;
>> +		}
>> +	}
>> +
>> +	/*
>> +	 * Make sure we will check other processes sharing the mm if this is
>> +	 * not vfrok which wants its own oom_score_adj.
>> +	 * pin the mm so it doesn't go away and get reused after task_unlock
>> +	 */
>> +	if (!task->vfork_done) {
>> +		struct task_struct *p = find_lock_task_mm(task);
>> +
>> +		if (p) {
>> +			if (mm_flags_test(MMF_MULTIPROCESS, p->mm)) {
>> +				mm = p->mm;
>> +				mmgrab(mm);
>> +			}
>> +			task_unlock(p);
>> +		}
>> +	}
>> +
>> +	task->signal->oom_score_adj = oom_adj;
>> +	if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
>> +		task->signal->oom_score_adj_min = (short)oom_adj;
>> +	trace_oom_score_adj_update(task);
>> +
>> +	if (mm) {
>> +		struct task_struct *p;
>> +
>> +		rcu_read_lock();
>> +		for_each_process(p) {
>> +			if (same_thread_group(task, p))
>> +				continue;
>> +
>> +			/* do not touch kernel threads or the global init */
>> +			if (p->flags & PF_KTHREAD || is_global_init(p))
>> +				continue;
>> +
>> +			task_lock(p);
>> +			if (!p->vfork_done && process_shares_mm(p, mm)) {
>> +				p->signal->oom_score_adj = oom_adj;
>> +				if (!legacy && has_capability_noaudit(current, CAP_SYS_RESOURCE))
>> +					p->signal->oom_score_adj_min = (short)oom_adj;
>> +			}
>> +			task_unlock(p);
>> +		}
>> +		rcu_read_unlock();
>> +		mmdrop(mm);
>> +	}
>> +err_unlock:
>> +	mutex_unlock(&oom_adj_mutex);
>> +	put_task_struct(task);
>> +	return err;
>> +}
>> +
>> +/*
>> + * /proc/pid/oom_adj exists solely for backwards compatibility with previous
>> + * kernels.  The effective policy is defined by oom_score_adj, which has a
>> + * different scale: oom_adj grew exponentially and oom_score_adj grows linearly.
>> + * Values written to oom_adj are simply mapped linearly to oom_score_adj.
>> + * Processes that become oom disabled via oom_adj will still be oom disabled
>> + * with this implementation.
>> + *
>> + * oom_adj cannot be removed since existing userspace binaries use it.
>> + */
>> +static ssize_t oom_adj_write(struct file *file, const char __user *buf,
>> +			     size_t count, loff_t *ppos)
>> +{
>> +	char buffer[PROC_NUMBUF] = {};
>> +	int oom_adj;
>> +	int err;
>> +
>> +	if (count > sizeof(buffer) - 1)
>> +		count = sizeof(buffer) - 1;
>> +	if (copy_from_user(buffer, buf, count)) {
>> +		err = -EFAULT;
>> +		goto out;
>> +	}
>> +
>> +	err = kstrtoint(strstrip(buffer), 0, &oom_adj);
>> +	if (err)
>> +		goto out;
>> +	if ((oom_adj < OOM_ADJUST_MIN || oom_adj > OOM_ADJUST_MAX) &&
>> +	     oom_adj != OOM_DISABLE) {
>> +		err = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	/*
>> +	 * Scale /proc/pid/oom_score_adj appropriately ensuring that a maximum
>> +	 * value is always attainable.
>> +	 */
>> +	if (oom_adj == OOM_ADJUST_MAX)
>> +		oom_adj = OOM_SCORE_ADJ_MAX;
>> +	else
>> +		oom_adj = (oom_adj * OOM_SCORE_ADJ_MAX) / -OOM_DISABLE;
>> +
>> +	err = __set_oom_adj(file, oom_adj, true);
>> +out:
>> +	return err < 0 ? err : count;
>> +}
>> +
>> +const struct file_operations proc_oom_adj_operations = {
>> +	.read		= oom_adj_read,
>> +	.write		= oom_adj_write,
>> +	.llseek		= generic_file_llseek,
>> +};
>> +
>> +static ssize_t oom_score_adj_read(struct file *file, char __user *buf,
>> +					size_t count, loff_t *ppos)
>> +{
>> +	struct task_struct *task = get_proc_task(file_inode(file));
>> +	char buffer[PROC_NUMBUF];
>> +	short oom_score_adj = OOM_SCORE_ADJ_MIN;
>> +	size_t len;
>> +
>> +	if (!task)
>> +		return -ESRCH;
>> +	oom_score_adj = task->signal->oom_score_adj;
>> +	put_task_struct(task);
>> +	len = snprintf(buffer, sizeof(buffer), "%hd\n", oom_score_adj);
>> +	return simple_read_from_buffer(buf, count, ppos, buffer, len);
>> +}
>> +
>> +static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
>> +					size_t count, loff_t *ppos)
>> +{
>> +	char buffer[PROC_NUMBUF] = {};
>> +	int oom_score_adj;
>> +	int err;
>> +
>> +	if (count > sizeof(buffer) - 1)
>> +		count = sizeof(buffer) - 1;
>> +	if (copy_from_user(buffer, buf, count)) {
>> +		err = -EFAULT;
>> +		goto out;
>> +	}
>> +
>> +	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
>> +	if (err)
>> +		goto out;
>> +	if (oom_score_adj < OOM_SCORE_ADJ_MIN ||
>> +			oom_score_adj > OOM_SCORE_ADJ_MAX) {
>> +		err = -EINVAL;
>> +		goto out;
>> +	}
>> +
>> +	err = __set_oom_adj(file, oom_score_adj, false);
>> +out:
>> +	return err < 0 ? err : count;
>> +}
>> +
>> +const struct file_operations proc_oom_score_adj_operations = {
>> +	.read		= oom_score_adj_read,
>> +	.write		= oom_score_adj_write,
>> +	.llseek		= default_llseek,
>> +};
>>
>> ---
>> base-commit: 1fffefb00cc0b0da1f2ae24e3d33364530ea6515
>> base-tree: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
>> change-id: 20261014-oom_procfs-f74a922f73f1
>>
>> Best regards,
>> --  
>> Ye Liu <ye.liu@linux.dev>
> 

-- 
Thanks,
Ye Liu


