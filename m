Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A6CCD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 12:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A09E6B0361; Mon,  1 Jun 2026 08:13:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8501B6B0363; Mon,  1 Jun 2026 08:13:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78CE76B0364; Mon,  1 Jun 2026 08:13:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE046B0361
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:13:01 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 22FE240671
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:13:01 +0000 (UTC)
X-FDA: 84831232962.12.1681ED8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87A014000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:12:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFLXOi7n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780315979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KQXASZfUusEYAftFy8BR8pLrhMKSi9CEQMMeeezJgJU=;
	b=4kR6oangGQlr2YOu03Gqy09hZYtETTWK/P969MzHRmrmExoKRKVfYe/dJpnbD5cmD+Gdbe
	NUJEP/1bDqV74uMFr4HAL233vyL+tt3c3r+ulpXVm4G467WIqjUqrvUbEqDXoEgk7zhi0/
	NcdC5zoeHv4zj/oG6X2B3KnG486JNG0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cFLXOi7n;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780315979; a=rsa-sha256;
	cv=none;
	b=fATf9l3eAaCqJWZ7HGaq63a8p6xgBSp1VHJVrhpu8440UpcD6v1fo/eeDtEZDRzmZGZg8f
	Z5E54EcXX2UuLmt7x2IXDkdSY0VmN6UAEwEidhzov+SYto8HbpcaouL7alViFoQeoL304T
	VnOs8HGrTPw4AW0jiWmHW0ZddHUs9iY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3C196001A;
	Mon,  1 Jun 2026 12:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DFA1F00893;
	Mon,  1 Jun 2026 12:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780315978;
	bh=KQXASZfUusEYAftFy8BR8pLrhMKSi9CEQMMeeezJgJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cFLXOi7nRfYzrRywx2F0As87A2rvawHElB2xDQKhZd3N0312VlH1jAbPqlTa7THzo
	 pmP+gzufeQzffCn/VzZnAPEG8leEu6XO14UoXXHBEtqqwiv6MhaP2PxmJdWojpiz3z
	 ZB7STxUQGlPWETODA7ZYvNLiZs2mRJObUhojbJuDsLovRxS/+z6Hy0CJP/tiGdcl7o
	 idnbBOBxAghycby2uKbVLG2jlHzVWj59AEoO3eVZhDxNzb5HQRioWG6x0QNpcs5Qb5
	 RyN1NPsQtN10Ec5u+rwHJ7ARQXplIQwPO+w1fm+eJRvec39UsdOwP+NWIPQkhRoCx6
	 QJBC6aCOP4VaA==
Date: Mon, 1 Jun 2026 13:12:54 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Kees Cook <kees@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>
Subject: Re: [PATCH v2] mm_access: simplify the security checks
Message-ID: <ah1qeNkatqx_N93-@lucifer>
References: <ahrsfJE3NkKjShEX@redhat.com>
 <ahrwUGytgulEwujN@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahrwUGytgulEwujN@redhat.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 87A014000C
X-Stat-Signature: jrxc8zqiore87sya146zrjfrifqzazgd
X-Rspam-User: 
X-HE-Tag: 1780315979-852030
X-HE-Meta: U2FsdGVkX19qHDUntcUGqxqiARTb3sCKr5JXasnec3dQjuGnE5aDdi2csSp7xPQ4wrYxWMI5RhPz+c7H5ltwb+3cdoJr3ettFL86wa7wGLRFYx1IjmmGaijZxsYf6J+cqp/YLliIWJ5NVL/XjsOu27D2gKk0pFbxnaTnNK3pBOpARTssLH+WJKBc01SsPnmsvaOEUUdvmpJTXdNRVgjioEobrRsj0u+UXsVT/kilwMwPcVkPKFGnXSKcW7NdGK6YK8436H2rQh9iWfQ/rrMaBqyUO7Fq7spmviAvtr0XDUg1NJIXvEDUnnFoBPaUWn21iSMMial5vWgZfVhPFuKCueqJvGwd2erOGhtUnuONcRzviyaz9o2+buwEBxWV6dNavhDjq8XW71BIR5r/0KXb6DCJF34bdK0eXdgjWelDVJWpcx/fmXiUEy1tSUVYRC29/8ZwHZeAqW4Ml1fInaIp3DLsU9XhI8GpLn1jTbDt+Gq8Xd1lWQH5jBTeAHMivs3qhXYg5VIKFzphoTRLI2OZXvqNZ8GCE/vgPehGlU/E0mybMsqWvTKo6100+Gupbc8jXrhQ9UBqCU6oLMRq8ohVML01ANQlFlbfKYWP9L/J9eo0F1m13ucSYr3prRTjUjgLKBI+UM055x5DhC35dlQ27p3MWvdctlYOnm1tgQDjsX97KDYvNqVckVV9kzN5a6TNvYvS50j9Gq1p1oxOjCHV8nHVAKYqMIK378FDu1LGBwAeVjeNSt54E9zWwi2hePAop14IxP28X4HxdR1mMQotS5LA9eTaiqFdH1Qbj4Kbs4U1oL6so0wKVrwVFeYptgo54uCryYa89GrrhgcoV+RIbHMDX03V6AOvVHuWDZZLMazb7AC7k3X+/i7zVmiiXk0N55VfoPX6qBMMtiXRM+FIuwp5wkrE82qwzU9uLFtaMCDOKpYZWTgn9TWEZZt+QTtOvIOTMD7XO9XrB4z1rtT
 Qgdy53mK
 M35SfcBQ/JYlbdpEiGmCpwI3nZaaF9jkNmA0WkFMd4g/BMvZZXGMK5htO7l7nIcexcOnDOnrzUyUMd2jum2pnCrDjxORyzVfW9SFgutsp599Fu5/O0lIJ+OhLsQ9C4X/UiQ03xNt7iRQJgmppG1W1namw8z6XKcDyEP0na+77sXqFp49frH+hPbis/A/TEvWpxY2U1FlOdg6LWgv6lyL78CJ2CShq57MXIcESIVgO3KNMpVoxwGjCMwTsDp4I0QHURB1gCS5RemgbGE4MSVNEHqFayA8RitRmnOFMrM3fAwxLuuABLuCuYnTtP2glol0esUVmdwaPRksATQK6V3OkfOJlRMs+pi0J3bYY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Liam for mm lifecycle stuff :)

The subject here seems not quite right - you're adding complexity here in that
now there's a racey fast path.

On Sat, May 30, 2026 at 04:12:32PM +0200, Oleg Nesterov wrote:
> 1. Shift the fast-path "mm == current->mm" check from may_access_mm()
>    to mm_access(), and do it locklessly.
>
>    task->mm is not stable but we do not care. We can race with exec,
>    but in this case we pin/return current->mm. This doesn't differ
>    from the case where the target execs after we drop exec_update_lock.

Well it does differ in that previously we increment a reference counter
on the mm with the exec lock held, and now we don't?

Also how often are we invoking this where mm == current->mm?

I think the reasoning here is more so that current is guaranteed to hold a
reference on current->mm (de_thread() will have issued a fatal signal not
yet processed).

So the commit message should say that I think.

One behavioural change here though is that down_read_killable() was used
previously, so such a situation would return -EINTR, but now would instead
succeed.

>
>    All we need for correctness is READ_ONCE() to ensure the compiler
>    won't reload task->mm. This is not enough for KCSAN, but we already

I'm not sure 'this is not enough for KCSAN' is really reassuring :)

>    have other lockless ->mm LOAD's. We should probably change exec_mmap/
>    exit_mm to use WRITE_ONCE().
>
> 2. With the change above, may_access_mm() doesn't need the "mm" argument,
>    so we do not need to call get_task_mm() beforehand. We can call it
>    only if may_access_mm() succeeds.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

It's useful to put a revision history (ideally with links to prior revisions)
below the --- line to explain how vN differs from v(N-1).

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

This really needs a comment to explain your reasoning for while READ_ONCE()
suffices here.

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
> --
> 2.52.0
>
>

(Side-note - we should really have these functions (and anything else
mm-related) in mm files.)

Overall I'm not really convinced about this patch - this isn't simplifying
things, it's introducing subtle assumptions and I don't really see the
benefit?

So I think it's a no unless you can provide a really solid justification.

And if it's a performance thing - how often are we actually calling
mm_access() for current->mm?

mm lifecycle is a very horrible part of mm and I think we should only make
changes when really necessary.

Thanks, Lorenzo

