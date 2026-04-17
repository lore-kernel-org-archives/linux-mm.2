Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45D60F8E4A7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 06:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4D16B0098; Fri, 17 Apr 2026 02:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CD86B0099; Fri, 17 Apr 2026 02:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B97C6B009B; Fri, 17 Apr 2026 02:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9676B0098
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:30:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C82FB13C01A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:30:14 +0000 (UTC)
X-FDA: 84667073148.16.468E7DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id F362C1A0011
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:30:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HWOzSIyY;
	spf=pass (imf19.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776407413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rJQHRY3zhOrSXZ5n3rZl2TXgBt5ljdhzDOpEkWpYj1I=;
	b=DZlRBMiD77tXK2U9kqPVG76Nv0ecUOxkkS9KN/uWSg9FIGVrBXcawVdk0uHHsEgC46mrTz
	p++8qHowMrfg6nNj3d0YhlXPr0EK4ex0gtkGu2C4mDTzWqfEd+MdYKYOBQs455e7VVddCh
	6lstkXMN3LJdfuayRwxtSREidJ2Eanw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HWOzSIyY;
	spf=pass (imf19.hostedemail.com: domain of minchan@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=minchan@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776407413; a=rsa-sha256;
	cv=none;
	b=6/4GGILGenGXVf0wps85IvFTmj6BQKDWdwo7HUiUA6jp3xZOhFxa4Kp9L75qYSyDp7PVeH
	oR3jFQWuDXQ28EOnKns+GUtNCq466kArrN05RaHHuRkf1xPwz5UaEUhtr0H+odPwxFlJil
	cTZi75DnQQ3wt6vfccur+mSCb+e571E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EF5FC436DF;
	Fri, 17 Apr 2026 06:30:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87124C19425;
	Fri, 17 Apr 2026 06:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776407411;
	bh=gDuRI9gS/dVQ6Jf3ZoMT0FRKjSgGqPUbWj0jrgE778o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HWOzSIyYOi0b/xR3tIGZaNAg6s4efvGhxD6MfRFrd4qOb3N2L4DQTENKFsl8C77Tr
	 w/UC1xpxI1upPul5yW75k8A4bijhSUMD7vPl/CFr++fbrI8yyb9i3D7gwz7V3A377m
	 P8UkOqnBh02Uz+4jZvFejO1q7iUNvRm+4Oy6ORXrGoegrTbxRKT7Czn3W6S8MtUT/i
	 Q9X/NZ2CqGxNXq+amxGDD8TS3m1IacNHOKsFXCBg3NKtAcoKSBG9rgnx0WzD2rOTxq
	 09wpKlvU/VaMrLL4k9L7qtfGOc/aUP2FyvVvH1PlG5eQ1W8DyVnv4oZBUhCvolnrlk
	 KZGAnSfsBYkag==
Date: Thu, 16 Apr 2026 23:30:09 -0700
From: Minchan Kim <minchan@kernel.org>
To: Christian Brauner <brauner@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aeHTcXfCyCED4WSl@google.com>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-4-minchan@kernel.org>
 <20260416-planktont-abwinken-b9499483b939@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416-planktont-abwinken-b9499483b939@brauner>
X-Stat-Signature: 8ycdtjdedsk6nk4ufpujq36ydzrmbzcx
X-Rspamd-Queue-Id: F362C1A0011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776407412-125749
X-HE-Meta: U2FsdGVkX1/LHNVb5RC5qbWJDUaG07gSyZ/BWwEvYBc2MoV9A1WeFNZQIMwp16pH7A7EXxCtjJDZlm4x3NbB0rYnJUzvqtPcADXewsncxRC1DHSxs3DUSv/C/SssyEQPDnoGvCd2V39Bz0K8m6NPLYLEzQANOGsVvT5WeOntJDtlPlNq5nBqsRoOMfXOaWr/LAIzow4DsMVTGkoTQs57BuWE/lZzisn7bQBwp7CWABAefGfAekpyn9PpDsRrnDRNwrseRqZp9HYy5tn2dhh8758rmw/Wjm3rgLYMb83f4UvaAYmYOLq9SKzNzGAhgS/Ig75TXqjAq+A91InIIMIZRNET9Mi7fhQBt6u4KVRhNgCLuHv268Gucc8nq5BFQw3NpqUXtkaFqndj7wlgaoJsDz0C3xxXhi0NjN9nS3Ik4ejwNFahXua763KL/zoTYO1suwzNLiXt78oJ8uHCbJJY4CzzEJMk6EqWB31UU+pEYQRzrGusTA1i+yCMtRH5py/PMrDBZ33AIEI4spPfvUa+0r+FMZQlwUGiKcVYoZsXMMW7Jk7vgV3DSs8Kfcra6hd3suQa+2K42s2nkfVns+vLcrIIKB9ok8aAxtun727AMHHY9/FC58rv4KVl16Qz8NlA3gRP1Hv7iK7BdkFarC5dlgfVsafyy3S0SrZjFSrXhTEmgA35oceEHk3AxeEHAImnGgKmlXzcxwli4qAFuMTfVXhR+Hc8NtXCQc3gO0F5/ckRX54CcZz+48kwhA41ccGrBTVnE+qbt8tOOCu4Ajv9kYXSeHUGNvY/kqv5hI3RIa+SwdDQh7I8yHzbCIWTKmletS/iaZEqBGnOeINCU+d0wC8ZIL+DboKoRSltoO25l2/ym/bAWAjtfNlkWWpxfey1josgeEIWFl/Rh6BpcIPS0gP2MQ03itmqjrErGpuBMyon1RE2EYNx7lfVzdPJIugrLeLWoOYoB5tAPlD+oV7
 mT9qNu0t
 ida+Asdu3U9z9I38ZJTct/py8CTlSP4OHNhDU7j1xD/FePpPHXdzwTSPmU0j4PHZRPJ/K8yAT351GNHnyI3cQAslKs20TvWzTzPpHYSYVK1FjQiwhNR0UYXBLjy0eh2J3qxbVYRQsNy5JV26zfpl+g/Mp7bvX5J5go7olQDnv4S0N0aQCOf10r12OajmyMadD8RoSaMLoRgWX9zozyg4Vr/l6Yqw/OFxDkpV69hgDz7eqhQyTWwnLOeomi/f8w+mt4EutVc7j8LqaDJa5kCiCVNKISFVcd8sVZqVTFjtxy9NNJp5XndIaWw9USoFXlP09G+HJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 11:13:35AM +0200, Christian Brauner wrote:
> On Mon, Apr 13, 2026 at 03:39:48PM -0700, Minchan Kim wrote:
> > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > prior to invocation. This separation introduces a race window where the
> > victim task may receive the signal and enter the exit path before the
> > reaper can invoke process_mrelease().
> > 
> > In this case, the victim task frees its memory via the standard, unoptimized
> > exit path, bypassing the expedited clean file folio reclamation optimization
> > introduced in the previous patch (which relies on the MMF_UNSTABLE flag).
> > 
> > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > an integrated auto-kill mode. When specified, process_mrelease() directly
> > injects a SIGKILL into the target task.
> > 
> > Crucially, this patch utilizes a dedicated signal code (KILL_MRELEASE)
> > during signal injection, belonging to a new SIGKILL si_codes section.
> > This special code ensures that the kernel's signal delivery path reliably
> > intercepts the request and marks the target address space as unstable
> > (MMF_UNSTABLE). This mechanism guarantees that the MMF_UNSTABLE flag is set
> > before either the victim task or the reaper proceeds, ensuring that the
> > expedited reclamation optimization is utilized regardless of scheduling
> > order.
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> >  include/uapi/asm-generic/siginfo.h |  6 ++++++
> >  include/uapi/linux/mman.h          |  4 ++++
> >  kernel/signal.c                    |  4 ++++
> >  mm/oom_kill.c                      | 20 +++++++++++++++++++-
> >  4 files changed, 33 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
> > index 5a1ca43b5fc6..0f59b791dab4 100644
> > --- a/include/uapi/asm-generic/siginfo.h
> > +++ b/include/uapi/asm-generic/siginfo.h
> > @@ -252,6 +252,12 @@ typedef struct siginfo {
> >  #define BUS_MCEERR_AO	5
> >  #define NSIGBUS		5
> >  
> > +/*
> > + * SIGKILL si_codes
> > + */
> > +#define KILL_MRELEASE	1	/* sent by process_mrelease */
> > +#define NSIGKILL	1
> > +
> >  /*
> >   * SIGTRAP si_codes
> >   */
> > diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
> > index e89d00528f2f..4266976b45ad 100644
> > --- a/include/uapi/linux/mman.h
> > +++ b/include/uapi/linux/mman.h
> > @@ -56,4 +56,8 @@ struct cachestat {
> >  	__u64 nr_recently_evicted;
> >  };
> >  
> > +/* Flags for process_mrelease */
> > +#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
> > +#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
> > +
> >  #endif /* _UAPI_LINUX_MMAN_H */
> > diff --git a/kernel/signal.c b/kernel/signal.c
> > index d65d0fe24bfb..c21b2176dc5e 100644
> > --- a/kernel/signal.c
> > +++ b/kernel/signal.c
> > @@ -1134,6 +1134,10 @@ static int __send_signal_locked(int sig, struct kernel_siginfo *info,
> >  
> >  out_set:
> >  	signalfd_notify(t, sig);
> > +
> > +	if (sig == SIGKILL && !is_si_special(info) &&
> > +	    info->si_code == KILL_MRELEASE && t->mm)
> > +		mm_flags_set(MMF_UNSTABLE, t->mm);
> >  	sigaddset(&pending->signal, sig);
> >  
> >  	/* Let multiprocess signals appear after on-going forks */
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index 5c6c95c169ee..0b5da5208707 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -20,6 +20,8 @@
> >  
> >  #include <linux/oom.h>
> >  #include <linux/mm.h>
> > +#include <uapi/linux/mman.h>
> > +#include <linux/capability.h>
> >  #include <linux/err.h>
> >  #include <linux/gfp.h>
> >  #include <linux/sched.h>
> > @@ -1218,13 +1220,29 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
> >  	bool reap = false;
> >  	long ret = 0;
> >  
> > -	if (flags)
> > +	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
> >  		return -EINVAL;
> >  
> >  	task = pidfd_get_task(pidfd, &f_flags);
> >  	if (IS_ERR(task))
> >  		return PTR_ERR(task);
> >  
> > +	if (flags & PROCESS_MRELEASE_REAP_KILL) {
> > +		struct kernel_siginfo info;
> > +
> > +		if (!capable(CAP_KILL)) {
> 
> Why? Just call a function that uses check_kill_permission() before
> firing the signal? What's the rational for doing it this way?

Thanks for pointing that out. I wasn't aware of check_kill_permission().

I took a look at it, and it seems check_kill_permission() handles permissions
primarily for signals sent from userspace. Since we are injecting the signal
from the kernel side using a positive si_code (KILL_MRELEASE),
check_kill_permission() would just return 0 and skip the permission checks
entirely.

I am open to better ideas if there is a more standard way to handle permission
checks for kernel-injected signals.

> 
> Tbh, I really hate that process_mrelease() now has a kill side effect
> with non-standard permission handling as well.
> 
> Seems like bad api design. Why can't you just raise the MMF_UNSTABLE bit
> before the SIGKILL as that's the problem you're trying to solve.

The problem is that process_mrelease() strictly requires the target process
to already have a pending fatal signal or be in the exit path before it allows
any operation.

Therefore, we cannot invoke process_mrelease() to just set the MMF_UNSTABLE
flag *before* the SIGKILL is sent.

If I send the SIGKILL first to satisfy the process_mrelease() requirement,
we immediately run into the scheduling race condition where the victim can
enter the exit path before the reaper can set the flag.

This circular dependency is exactly why I had to integrate the kill operation
into process_mrelease() to make it atomic.

> 
> > +			ret = -EPERM;
> > +			goto put_task;
> > +		}
> > +		clear_siginfo(&info);
> > +		info.si_signo = SIGKILL;
> > +		info.si_code = KILL_MRELEASE;
> > +		info.si_pid = task_tgid_vnr(current);
> > +		info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
> 
> This should not be open-coded like this.

Good point.
Maybe, I can reuse prepare_kill_siginfo.

> 
> > +
> > +		do_send_sig_info(SIGKILL, &info, task, PIDTYPE_TGID);
> > +	}
> > +
> >  	/*
> >  	 * Make sure to choose a thread which still has a reference to mm
> >  	 * during the group exit
> > -- 
> > 2.54.0.rc0.605.g598a273b03-goog
> > 

