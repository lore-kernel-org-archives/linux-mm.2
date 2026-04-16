Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57E73F8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 09:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE81F6B0089; Thu, 16 Apr 2026 05:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B728C6B009B; Thu, 16 Apr 2026 05:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61096B00A2; Thu, 16 Apr 2026 05:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB056B0089
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:13:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F7A813B9A4
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:13:43 +0000 (UTC)
X-FDA: 84663856326.22.90D5107
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 51EEA8000D
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 09:13:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a4MZ7sd9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776330821; a=rsa-sha256;
	cv=none;
	b=LcFoNRafJGmMTaIKMuq4o/0XwzOsVR8Uw0YuSNFaoGskyTatp2rFLPM2iHwgqjXPjbzkfN
	s8BWEGBTE2dX5jAqbmD6LBF2Qu10ka6w280eotGX2P6tYjFaYP7YylKYV5Jdw4+2DGieiC
	vdO7gm6aEk/gyZGp5dXAgeEcInop088=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a4MZ7sd9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776330821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QM3fQWW1yc96B8VjlzkMcANmEuU87fI72odEe6PpSfA=;
	b=CrMYwviavHhgEZqoKVD2TnjuDY7grhixTgmapCKjUJF4Tsk9uM8FBGRSAeS4f9Hb3qtyaO
	8f0JTlR28cdPJpqHcgqhzpLQwuZyylclXhi9Ogb7bC2pTC8F5MoAFygf9Spd5adCrgIc7g
	MkWtOiS3TPcafyjeZzVrUZUBDvCb8do=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 516DE4196C;
	Thu, 16 Apr 2026 09:13:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AD52C2BCAF;
	Thu, 16 Apr 2026 09:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776330820;
	bh=cKya0mdHiUet8bLBaGzBfknVjqZnuS4CXZrgMDf/BTE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a4MZ7sd9WMlqkG+TrblJKT7sJnRcjY+oO16xNxrG+UJF+pnKdnMb45X3ULZUegpG7
	 iw7H4+OOVydkO8C3PstboGH7z+sPuxuJsODyZ6N56NfuLxzAqN7iV2rvPsz85m7ZJB
	 9cctZzgA/cTLQYBJ0rfOUl0rLI4hl4HKSa+nrdXp2oELBtwTUChd0e76xeHwu7rQLt
	 QVM4DFMOwGxkgWhitAIZv5zdDyPHuniqj1mp5N0+1LlwDHvaM9ukoxDvyg3nZIaR3W
	 9rj/PYIJpXmeymlgDUD6TUNt4LJ7PUHXqc/XXuQ21Jzlagg27CQpBt57wA/oWT633B
	 a0HEzt2TFi/aQ==
Date: Thu, 16 Apr 2026 11:13:35 +0200
From: Christian Brauner <brauner@kernel.org>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com, 
	timmurray@google.com
Subject: Re: [RFC 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <20260416-planktont-abwinken-b9499483b939@brauner>
References: <20260413223948.556351-1-minchan@kernel.org>
 <20260413223948.556351-4-minchan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260413223948.556351-4-minchan@kernel.org>
X-Rspamd-Server: rspam10
X-Stat-Signature: j84a6j98imd8y4dt1ez1sm7q7aes6zze
X-Rspam-User: 
X-Rspamd-Queue-Id: 51EEA8000D
X-HE-Tag: 1776330821-60066
X-HE-Meta: U2FsdGVkX1/OszHtFLUp5uJoE1az+c2Jky/Ufhf8VLmLMfJ6T32RG+10dJKOo0OHzozuayvMQxtMpPC+h1t4OrjmlRtYhOiYPrFvh7HZyOeNBv2dt6Vr3//0+yVq+wBeQzPupcuPK9fIjv0KrgjrNOL69Hohr/W+eNNK6PeIaXrGZW/RrV6E1396Yy2n2NUibqfkgA7DDQ25JkPCCBuW5iVbxdHeg3uTbXupRpI0pOPqcmJPn4PYMURmBVZcW3cpAcLEVhy44XCGz8A85Jl6DwEUK6h38y44J4G7ofdg5Wa0pQdzFw66J8+/tw3Uazcmf7MyVUrhA3U/9G824c0KQKkkUPPWto4t4oGtRHTAuXRbiM4+FshOGpX4PeOdqveicLp+QcI3B0oaYHY9CMlQ6a4xyJ6n7V5uWu9f7hgiDoEROyUV6HRi+iwA604bD0PeCrQOJsT789PWCivPpmcooatVQlpRl/qLmEW1Z2ROwo1G/IIIITaTFOSD9FDjWaV+JD+VAZmsnQi6LOE5UnRj2PLXdc6OQc6D3E0MjO3emNDVUYHUqk2BOZXas5Dj5qlp4l4te9Vu2cS7zwyw+GG5jcinjzXlzR7ENRoQ27QuRLXRB0Uq0QCVoLFv8eLMuXSIegEq/J5iarukQBp5ezUgW2gLqzMVE0bLpnAcipcbiNVWJafOZsnEGP0evlKRXszQIgZdudayMIlXp04CtNaFcMCDHJZ6oJzq9+HtXj9SKmsLHersiKRcwHbIcazm+7nqnvEYzTUQMwLV3HDpK9pFmvaCbtRWmoP8p/cWZGbuAlONW/AidCoMMggHWrO5fVSMEBW+k3Kl88+vOy9YZsgDb4BB07g+NpjhnWT5+ruARYzsaUetbm371vIONCcU8O3Ljf1Hgri3p81xplv6ih4XKrKXGBX9LloZwrzHec2sDAhMh+ejeAuTBRZvHmY47xg3BoC0rYkj2iS0gx5QwTr
 LhUP7cnX
 BS2+Ycq0wUFwmvfkqdag3231kkt31/Sq5TkXSb9BTIu8afqYMPVGynT2cqmSQro34ccVYhjK/axx8kitoJ6PpAligzPxdMZaSPb7113lIjhsP5laULBrSWFiHuwCMX+X9A/xMKaLTT/MxWRcV8yeGE8fTdzLW+D8thGVeJN84F1nlxpMbdOArZGnZZv0hQtDXnZP9qXzqoBY1MkYdzTAxyHUALzSOf9o/oPtCDU41Ut6Y6B6K3sqb/MsmuUnWAMNSXtP4+kpxa97e5RmFAv/f/ZNGe9m7Mg12EWCO/96SFfsTldxp9pc8b7dOu4XYRmVr90vw00JNCIPLDZe1HDm2PVo/yXO1jAKvI3TyohBLBMBKQ8j4GviKthegEQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:39:48PM -0700, Minchan Kim wrote:
> Currently, process_mrelease() requires userspace to send a SIGKILL signal
> prior to invocation. This separation introduces a race window where the
> victim task may receive the signal and enter the exit path before the
> reaper can invoke process_mrelease().
> 
> In this case, the victim task frees its memory via the standard, unoptimized
> exit path, bypassing the expedited clean file folio reclamation optimization
> introduced in the previous patch (which relies on the MMF_UNSTABLE flag).
> 
> This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> an integrated auto-kill mode. When specified, process_mrelease() directly
> injects a SIGKILL into the target task.
> 
> Crucially, this patch utilizes a dedicated signal code (KILL_MRELEASE)
> during signal injection, belonging to a new SIGKILL si_codes section.
> This special code ensures that the kernel's signal delivery path reliably
> intercepts the request and marks the target address space as unstable
> (MMF_UNSTABLE). This mechanism guarantees that the MMF_UNSTABLE flag is set
> before either the victim task or the reaper proceeds, ensuring that the
> expedited reclamation optimization is utilized regardless of scheduling
> order.
> 
> Signed-off-by: Minchan Kim <minchan@kernel.org>
> ---
>  include/uapi/asm-generic/siginfo.h |  6 ++++++
>  include/uapi/linux/mman.h          |  4 ++++
>  kernel/signal.c                    |  4 ++++
>  mm/oom_kill.c                      | 20 +++++++++++++++++++-
>  4 files changed, 33 insertions(+), 1 deletion(-)
> 
> diff --git a/include/uapi/asm-generic/siginfo.h b/include/uapi/asm-generic/siginfo.h
> index 5a1ca43b5fc6..0f59b791dab4 100644
> --- a/include/uapi/asm-generic/siginfo.h
> +++ b/include/uapi/asm-generic/siginfo.h
> @@ -252,6 +252,12 @@ typedef struct siginfo {
>  #define BUS_MCEERR_AO	5
>  #define NSIGBUS		5
>  
> +/*
> + * SIGKILL si_codes
> + */
> +#define KILL_MRELEASE	1	/* sent by process_mrelease */
> +#define NSIGKILL	1
> +
>  /*
>   * SIGTRAP si_codes
>   */
> diff --git a/include/uapi/linux/mman.h b/include/uapi/linux/mman.h
> index e89d00528f2f..4266976b45ad 100644
> --- a/include/uapi/linux/mman.h
> +++ b/include/uapi/linux/mman.h
> @@ -56,4 +56,8 @@ struct cachestat {
>  	__u64 nr_recently_evicted;
>  };
>  
> +/* Flags for process_mrelease */
> +#define PROCESS_MRELEASE_REAP_KILL	(1 << 0)
> +#define PROCESS_MRELEASE_VALID_FLAGS	(PROCESS_MRELEASE_REAP_KILL)
> +
>  #endif /* _UAPI_LINUX_MMAN_H */
> diff --git a/kernel/signal.c b/kernel/signal.c
> index d65d0fe24bfb..c21b2176dc5e 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1134,6 +1134,10 @@ static int __send_signal_locked(int sig, struct kernel_siginfo *info,
>  
>  out_set:
>  	signalfd_notify(t, sig);
> +
> +	if (sig == SIGKILL && !is_si_special(info) &&
> +	    info->si_code == KILL_MRELEASE && t->mm)
> +		mm_flags_set(MMF_UNSTABLE, t->mm);
>  	sigaddset(&pending->signal, sig);
>  
>  	/* Let multiprocess signals appear after on-going forks */
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 5c6c95c169ee..0b5da5208707 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -20,6 +20,8 @@
>  
>  #include <linux/oom.h>
>  #include <linux/mm.h>
> +#include <uapi/linux/mman.h>
> +#include <linux/capability.h>
>  #include <linux/err.h>
>  #include <linux/gfp.h>
>  #include <linux/sched.h>
> @@ -1218,13 +1220,29 @@ SYSCALL_DEFINE2(process_mrelease, int, pidfd, unsigned int, flags)
>  	bool reap = false;
>  	long ret = 0;
>  
> -	if (flags)
> +	if (flags & ~PROCESS_MRELEASE_VALID_FLAGS)
>  		return -EINVAL;
>  
>  	task = pidfd_get_task(pidfd, &f_flags);
>  	if (IS_ERR(task))
>  		return PTR_ERR(task);
>  
> +	if (flags & PROCESS_MRELEASE_REAP_KILL) {
> +		struct kernel_siginfo info;
> +
> +		if (!capable(CAP_KILL)) {

Why? Just call a function that uses check_kill_permission() before
firing the signal? What's the rational for doing it this way?

Tbh, I really hate that process_mrelease() now has a kill side effect
with non-standard permission handling as well.

Seems like bad api design. Why can't you just raise the MMF_UNSTABLE bit
before the SIGKILL as that's the problem you're trying to solve.

> +			ret = -EPERM;
> +			goto put_task;
> +		}
> +		clear_siginfo(&info);
> +		info.si_signo = SIGKILL;
> +		info.si_code = KILL_MRELEASE;
> +		info.si_pid = task_tgid_vnr(current);
> +		info.si_uid = from_kuid_munged(current_user_ns(), current_uid());

This should not be open-coded like this.

> +
> +		do_send_sig_info(SIGKILL, &info, task, PIDTYPE_TGID);
> +	}
> +
>  	/*
>  	 * Make sure to choose a thread which still has a reference to mm
>  	 * during the group exit
> -- 
> 2.54.0.rc0.605.g598a273b03-goog
> 

