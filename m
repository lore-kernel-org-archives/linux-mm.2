Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4F72D0D170
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 20:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455ED6B0095; Wed,  7 Jan 2026 15:39:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 423C86B0096; Wed,  7 Jan 2026 15:39:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 357176B0098; Wed,  7 Jan 2026 15:39:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25BF46B0095
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:39:41 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D29FC1B7DB
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:39:40 +0000 (UTC)
X-FDA: 84306333720.13.E45363D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4AEA310000A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 20:39:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TT3fYyI6;
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767818379; a=rsa-sha256;
	cv=none;
	b=55V310wdfmzUkrsEdLRvkngFcmB7SQIMpUGpvc/Xts9Wh64+Lb5iUJ0PVi1Fdvo6mPbXkM
	4wOX7CrIcJ6fldv7/ME03K5Yn9Q57inL5UX5S+t1rDL6dA8ZP/4cUWs4XS+YIfOeeKGE/6
	uCC+XsxaI3DJaKOneifBMjuS1faCn5U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TT3fYyI6;
	spf=pass (imf05.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767818379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pV+a8j9sisCDD/XEwXMfXMy2Gqogic0cxsTYO/RlQK8=;
	b=WoLMFTfvPFVhaVULLuNEtTON9vS2GMG30yqV7vk517SKw31A4qrxVv8FRuUtA8+lRK8PBf
	ubXhYmhqqPWNYCOJSImWSAzG1+PCpZ72Ta8jjH70epr2Vk4SmUxEhswuy+JJJcCGPisJDZ
	Ct+fuLo0pPDUAjWQ3SszCho4DHFtOoc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 973BF60007;
	Wed,  7 Jan 2026 20:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41064C4CEF1;
	Wed,  7 Jan 2026 20:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767818378;
	bh=vDWYrFckz07hGf4wxpisLiCyQloyljBsPb6Qu5XUQcI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TT3fYyI6dkO0dUgOHl8gZOPfcOgK8aXYhSHBYCPSUpbC7J87sQKARdVKUwsoKT4wN
	 LMpLjXb5zuw0ynV19JzrLUZX3mDhbNJ9kJzmP6c/EHyWZj7ZyTMSuFJIuG144W4hnq
	 ma1BQmt1VUBXFZ2RrVuGt1vY5jp6qKtXgu+0S+EJ5DJsHJ7qao9t6gnaeaqXdSBLfY
	 gXB4MGpm/S/womHmfGrrTOV8lCwoSMQ7b+ION89CwiV51iQX5eS10cmcTf2McLusZl
	 064mZRgU6x0gK/1YuaExKOGzUMedanu97zC6opIwkMiHTZPz2cZk5xuJ25A3KCzvO+
	 os26ohyzPDAqg==
Date: Wed, 7 Jan 2026 12:39:37 -0800
From: Kees Cook <kees@kernel.org>
To: Qing Wang <wangqing7171@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+e0378d4f4fe57aa2bdd0@syzkaller.appspotmail.com
Subject: Re: [PATCH] fork/pid: Fix use-after-free in __task_pid_nr_ns
Message-ID: <202601071238.F86C2B8@keescook>
References: <20260105045609.1764387-1-wangqing7171@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260105045609.1764387-1-wangqing7171@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AEA310000A
X-Rspamd-Server: rspam04
X-Stat-Signature: do74px81hxcxj31b5wo1kontfb4gp7jc
X-HE-Tag: 1767818379-414499
X-HE-Meta: U2FsdGVkX1+Ct7rqmT1EyvJWZpmxHYGgcAqAVLnDixlN8IeWLF0zRXLePTB8TAJvTn1hPaQoQquNFYy6ftMFztWnGMh3QorS6USBaj6pBqjpvU6DNfPGJQOq6O5zKkN9i5f7DURe63/2scP7YXekvA44TT+u7ZT0koAbfska/5YuKDpuDCg5gCOKR31nRSGOieNnB/Dgoeaa1JSH7fFDWvfLrkDlPTfSAPfYDeCHBlQDoAgxhodIe0wH8TLU97YVCpHVvX+XKJDTftE98EDnxTq4+aiI+rIt4jDKsiMEV6iEDjVUdRlAPcWMboQ6swkOdEKW7r0eQ6Q0bBaN1wj8lTg07lagUgeR8iBn+No8hbwNx2raRR4DXFf1iqMTFBfwBw9hF1abyPh2XnjWDz1JzbDvapwI6y0mrG2IggKzwVQJRNweargqSfZ5ygJMnnZVluHtaNBhNbNAbYKjfWAE0Z0M7ZyRQd/dS20NCafcX7/alHWojEiLbIi4L6WKDvjTGqa/sTTnJODYPcX3pw5REq5r+AJlG7TA8+0gFjyJVW77bsDn5K//dS8kZeVjDfEywE1V1h6uCgYszV2UnRFW3MQtMj5j3iY0sADI0HsKdZjhW2DJyWBcRz3pCkFjqJdl1gDWtLMovoImevTWA/Qu1BI02iP/Tk8TuHfTmNt1GUIS3m3S31/g+50V9aWRJbOnsZVzMZBCZJY4oFV9NYUoAXh4U3Q1MsdmPv5+jK8bL1U4IRScAWudgqYRZRLb9PgPko3x3/jkUFEQMsEFN+UdIl9uPznb7aQGbGk34QMoKiMPcGXA9kSB6P+biNGwVWWLLVrhZJ1S7+xg2jWhBVsOWNU2wbmR6gW2Ra/yGaqT8GjSjgWSHBkzhZrsLhWSuuNA7eL6hy8p0Q7NFySS1afwFvtK2nZeRzhkxHZI6f4vT/zz/9w4J4mIows1PwIqgn4RPzj9VuS+y2u2+b6qdov
 vC+Dc/iN
 hL5Ah2ekJHRqiYNNjaBhtfW/63JBqJcZ0ostdBeZ9s9Ug0obZY15aRo1cYXCfnq5etHOnY9KbDpCzwnoNtvp03UZ6eLN3aNxfzvAwAEU7jHr/2ZuMwzZFqnXOb+feD57Jh4TUjTmEEYlQsUFsMFHY7Z0YzXdpCDTq7qbgw87CfRa+e/Pc5RLx69ifOGP0mNEPBJ/MtRS6+A85nz/t0Bz2+n017Vie15pVZstQrMUjLToHIwlKyHN6Vv9IAdmUnopIHzmB8bBqfR2Gjw9Y2qEADWqp5NRo6OvVuh+vhvQF5zPE8nWIk/jlacYPUoTvMqHHo9/ysTtpegVGTdbzV9OcJkfvLedlk/mta5RrrYwCSFgjfWroDzxW+H8dyUOv7kGTEvpBxP0gso3CAmsKko90REmxT7Jh08pgs3Aw+nlUncv46PfmO6UT2w/R4RdNn7MNvAh0I0NNHyYmtkQApbKWkGbIasdqLJUTRfIf53KpUPBecoOrtKLvPCtv4suTjBCmdLmi+C4FX/Vba+gOTQ6k1uTC2vBpR5nz4mAG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 05, 2026 at 12:56:09PM +0800, Qing Wang wrote:
> Syzbot reported a slab-use-after-free issue in __task_pid_nr_ns:
> 
>     BUG: KASAN: slab-use-after-free in __task_pid_nr_ns+0x1e4/0x490...
>     Read of size 8 at addr ffff88807f8058a8 by task syz.1.574/8108
> 
> The race condition occurs between the failure path of copy_process() and
> getting the PIDTYPE_TGID via __task_pid_nr_ns().
> 
> Bug timeline:
>                                     Task B
>                                     perf_event_open()
> Task A <--------------------------- clone()
> copy_process()
>     perf_event_init_task()
>     ...
>     one copy failed
>     free_signal_struct()            close(event_fd)
>                                         perf_child_detach()
>                                             __task_pid_nr_ns()
>                                                 access child task->signal
> 
> This is fixed by:
> 1. Setting task->signal = NULL in the failure cleanup path of copy_process.
> 2. Adding a null check for task->signal before accessing PIDTYPE_TGID from
> task->signal.
> 
> Note: This bug was reported by syzbot without a reproducer.
> The fix is based on code inspection and race condition analysis.

It seems like there is synchronization missing between the task->signal
assignment and its check in task_pid_ptr? Aren't there other ways of
checking if a task is dead? This change doesn't look right to me...

-Kees

> 
> Reported-by: syzbot+e0378d4f4fe57aa2bdd0@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e0378d4f4fe57aa2bdd0
> Signed-off-by: Qing Wang <wangqing7171@gmail.com>
> ---
>  kernel/fork.c | 8 ++++++--
>  kernel/pid.c  | 6 +++---
>  2 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b1f3915d5f8e..72b9b37a96c8 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1975,6 +1975,7 @@ __latent_entropy struct task_struct *copy_process(
>  	struct file *pidfile = NULL;
>  	const u64 clone_flags = args->flags;
>  	struct nsproxy *nsp = current->nsproxy;
> +	struct signal_struct *free_sig = NULL;
>  
>  	/*
>  	 * Don't allow sharing the root directory with processes in a different
> @@ -2501,8 +2502,11 @@ __latent_entropy struct task_struct *copy_process(
>  		mmput(p->mm);
>  	}
>  bad_fork_cleanup_signal:
> -	if (!(clone_flags & CLONE_THREAD))
> -		free_signal_struct(p->signal);
> +	if (!(clone_flags & CLONE_THREAD)) {
> +		free_sig = p->signal;
> +		p->signal = NULL;
> +		free_signal_struct(free_sig);
> +	}
>  bad_fork_cleanup_sighand:
>  	__cleanup_sighand(p->sighand);
>  bad_fork_cleanup_fs:
> diff --git a/kernel/pid.c b/kernel/pid.c
> index a31771bc89c1..1a012e033552 100644
> --- a/kernel/pid.c
> +++ b/kernel/pid.c
> @@ -329,9 +329,9 @@ EXPORT_SYMBOL_GPL(find_vpid);
>  
>  static struct pid **task_pid_ptr(struct task_struct *task, enum pid_type type)
>  {
> -	return (type == PIDTYPE_PID) ?
> -		&task->thread_pid :
> -		&task->signal->pids[type];
> +	if (type == PIDTYPE_PID)
> +		return &task->thread_pid;
> +	return task->signal ? &task->signal->pids[type] : NULL;
>  }
>  
>  /*
> -- 
> 2.34.1
> 

-- 
Kees Cook

