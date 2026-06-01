Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A7FACD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733E86B034F; Mon,  1 Jun 2026 08:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70BBF6B0351; Mon,  1 Jun 2026 08:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620C16B0352; Mon,  1 Jun 2026 08:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FCFC6B034F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:04:49 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CF67516244A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:04:48 +0000 (UTC)
X-FDA: 84831212256.28.A1B2C34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id EFFF31C0010
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:04:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WJqDVD7J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IonyAXTK4z3N68EQaWEo5DEKU7B9ZtHA9Q/mLTloro=;
	b=TZzKuWnRIznu0CvUzI9MSc7VbOng1aTb2yO/XPbOOZ0cvEgqVXKE6WdsuIZRvgqR4NH9qJ
	E+PsclXSYhY5MLvf29ks8C9dbjpcXA2g55W+6HqYYFCw3GMrxrVG1VjbCBtlFZKc4Kkb6O
	VZZZT6Mvimq4LElPXJIdP/1G7MbIflA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WJqDVD7J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315487; a=rsa-sha256;
	cv=none;
	b=LVtb7AQ3QfqOHNqSNGHaCSQ2pCiPNrosKD74pYc2/aewaeuQ/q1+4kYDb/bk8vvsYxOMMx
	OKzKiLsQEP/I1EzBBhb6hkIwCgGlSoDJXuXPU5c19QprvovRM85a1ezFgo410DzQoc4WTX
	9fRB+HKXi/33MH/k8/l1xTnK27a/luQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 47E7D40705;
	Mon,  1 Jun 2026 12:04:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6D51F00893;
	Mon,  1 Jun 2026 12:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315486;
	bh=/IonyAXTK4z3N68EQaWEo5DEKU7B9ZtHA9Q/mLTloro=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WJqDVD7Jm0TsknGaT29e7GQKi5+cL4Mmj+mlFLXfWi8hwdxVUAYSdscOiM+SHx5qV
	 L440LJE+rpRT1xKV09jJnksJqvSsoCoVM/gQFiNBWemrfIe9sqMb70hHY4jlsJwiEW
	 pnJPvDFxv2X3QUuB5Pic5JdbG1eY3Jacc8JPMm1x3+qsdrnPOmgnq1vhfx2AFNIr56
	 o/ncbK9tLTTVHT2jBqWSANG2j8rxZUDBfEIKqB4EEFcvfx2hLFSvhSPjy4X48zQSfc
	 sz0vuQTcfSwKJdthZuRyMrUJtmKbwr14Q9cZ65nM/cK+qkZTfh+SKdGBS9oGxcHHEL
	 qtutPZLnpSCSg==
Message-ID: <a8846033-094d-4e1c-bfba-f7f543944709@kernel.org>
Date: Mon, 1 Jun 2026 14:04:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm_access: simplify the security checks
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, Jann Horn <jannh@google.com>,
 Kees Cook <kees@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <ahrsfJE3NkKjShEX@redhat.com> <ahrwUGytgulEwujN@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ahrwUGytgulEwujN@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: d9yegije6kqjxm1fr69nznubyd3mrihs
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EFFF31C0010
X-Rspam-User: 
X-HE-Tag: 1780315486-877395
X-HE-Meta: U2FsdGVkX1+NzZpfP73+LREsLWUG/M+5JxdMM8qs+Ie+WIzHk0YirM1/D6hMtzExbMSjt1991SOScjSXOo5XsRpnLd3kbxDHU74ysXWtLL9Sh4rBEB/Zhkb8dcU+ECbaY1amHq69QY2lKiqAMNOtHzvUYJ1vmAJt6nWHw1/kuT0JqFA8JisWhKTle969CDJ5iW0oErynKMxMtl5ZlMC688LausHGOphsZgttmEGJ05ajHHlddZoKn7j2XpSCO6DNCGZbs0rOxjB6b8vHeLDlLBmqTnbKaasaGLQcgY3UGQoOTPhK6pJJa1+p42mkuiKVVbUbphKYkwE8BRQpeBUKydXetM39QC6PuJWR1vz2766LfZ8iMQbAfLyONgIKpmiDrvIMMRPIQlwzKeg8hPjXQWyPF72DNHOt2ylTbPV/rRLpbvwk1C4z3OzagETrR7hlfTyAr5o9bMkcpPecJ/lciiVb0PXQIHVUmWnvmBhWu15afSCCSt4cE7ReVktcMVl1X3RtFR4DFOrgTfainw+gaWjAqZbEzCNFh1DrxTBCOYafF2AJtnL/yZqFbGheT8U+o8+ndQwu+8gv/IkyyFrs5aundvnXu1sGUxsqx6I9YwBQszJ922au4KaMFvYPImlq9+tuyVke/EyqZvuO7B46uJSo7701mRklSsZXJYILVEXCzIxEx4ZMwU+E0zNju33B0wLFIjwtCIlWwkLk+MmDP6+hta4Vmhznu7wf/BxTCxdzRl1l8AHYBKmyfmYwzadAsQL6/k7Cgjg/E7QqYQhZFyvDmXzspbUomyLAUkook25XLamnY9a9UPfW0mF8IixzVhSVgvR6RKR54Zsx9px0zZl4B1pQooEkG5qsCk+/upcXKlAyVJYCtJEAxHSKr+pvj1JLf0Hq/Guo2Zah2AxErjc3FNl0GgYdy/WdYpos17TksY4rB+Z9K8CeBLiiUW1JnkZboN88KOkmfnloWrm
 1+01ZCa6
 ynqp6Dj2p7Bvx46zJcMrHyJW7rqrLVaBhtjZawpUcicMfkZyfWTdvBiOidFwUWa7ISL9jI9ysGlBwT+R45NTgjBTUsULqqdVb4ZJ4+f97lRHjgnsvnl+TEVOnWXr6eUZJ50tf2wa10TWiRJs9mG9pgOZYHKmlVFCpJ99h5PhGXLS27Nt95OqUHxLzxsDzRhRNzpYghmwqXlDvXEx/0t7fVy0mRQ9yOvvBTtrVzZ6pxWx6RITxESvfApVNZi/xiILswvvY+Jc5UWDqvaPud0EYJI3oZVp19Ph9V9cqiKMgcTurHT9XxR0kzZ1lKIxne7zIK1HrAeuwbPywwM5v6JfYoTZ83XRI4na+k7fE+JuCCRxozpg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/30/26 16:12, Oleg Nesterov wrote:

I am not sure I spot the "simplification" here?

Looks more like an optimization that makes the code slightly more complicated.

> 1. Shift the fast-path "mm == current->mm" check from may_access_mm()
>    to mm_access(), and do it locklessly.
> 
>    task->mm is not stable but we do not care. We can race with exec,
>    but in this case we pin/return current->mm. This doesn't differ
>    from the case where the target execs after we drop exec_update_lock.
> 
>    All we need for correctness is READ_ONCE() to ensure the compiler
>    won't reload task->mm. This is not enough for KCSAN, but we already
>    have other lockless ->mm LOAD's. We should probably change exec_mmap/
>    exit_mm to use WRITE_ONCE().
> 
> 2. With the change above, may_access_mm() doesn't need the "mm" argument,
>    so we do not need to call get_task_mm() beforehand. We can call it
>    only if may_access_mm() succeeds.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/fork.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b8b651abce8b..3239380ab93b 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1381,10 +1381,8 @@ struct mm_struct *get_task_mm(struct task_struct *task)
>  }
>  EXPORT_SYMBOL_GPL(get_task_mm);
>  
> -static bool may_access_mm(struct mm_struct *mm, struct task_struct *task, unsigned int mode)
> +static bool may_access_mm(struct task_struct *task, unsigned int mode)

We now have a function named "may_access_mm" and not providing an mm struct
pointer ... it now looks more like an extended, mm-independent ptrace check.

So probably we should rename that function.

>  {
> -	if (mm == current->mm)
> -		return true;
>  	if (ptrace_may_access(task, mode))
>  		return true;
>  	if ((mode & PTRACE_MODE_READ) && perfmon_capable())
> @@ -1394,20 +1392,24 @@ static bool may_access_mm(struct mm_struct *mm, struct task_struct *task, unsign
>  
>  struct mm_struct *mm_access(struct task_struct *task, unsigned int mode)
>  {
> -	struct mm_struct *mm;
> -	int err;
> +	struct mm_struct *mm = READ_ONCE(task->mm);
>  
> -	err =  down_read_killable(&task->signal->exec_update_lock);
> -	if (err)
> -		return ERR_PTR(err);
> +	if (!mm || (task->flags & PF_KTHREAD))
> +		return ERR_PTR(-ESRCH);
>  
> -	mm = get_task_mm(task);
> -	if (!mm) {
> -		mm = ERR_PTR(-ESRCH);
> -	} else if (!may_access_mm(mm, task, mode)) {
> -		mmput(mm);
> -		mm = ERR_PTR(-EACCES);
> +	if (mm == current->mm) {
> +		mmget(mm);
> +		return mm;
>  	}
> +
> +	if (down_read_killable(&task->signal->exec_update_lock))
> +		return ERR_PTR(-EINTR);
> +
> +	if (may_access_mm(task, mode))
> +		mm = get_task_mm(task) ?: ERR_PTR(-ESRCH);
> +	else
> +		mm = ERR_PTR(-EACCES);
> +
>  	up_read(&task->signal->exec_update_lock);
>  
>  	return mm;


-- 
Cheers,

David

