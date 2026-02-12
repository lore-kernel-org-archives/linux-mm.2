Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6A4EEA86E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 23:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D04926B0005; Thu, 12 Feb 2026 18:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB2816B0089; Thu, 12 Feb 2026 18:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE596B008A; Thu, 12 Feb 2026 18:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7C186B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 18:53:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 52A3F1A02BE
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 23:53:39 +0000 (UTC)
X-FDA: 84437459358.01.A911698
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id AC817A0006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 23:53:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Htv2usbB;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770940417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYkm/2qOfdAzMN38BYuT71W/aoP8d4GmYJ9iS1lfObk=;
	b=0NcQ6AH8bkMlFzag6AbZ/vvr9HqKOKdvoXdX0aW376tn3zhILG0+HmlJHMwkbdEyJY2nxL
	s6k3daldPs26sWaOTy1JXHFrKidI5e/7uABcraqdlhJBRi+UA5w9yyglmaVYN9Iej3uUfw
	KwEen3o13do7DJ/PQMQP4dnp0nCkETw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Htv2usbB;
	spf=pass (imf15.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770940417; a=rsa-sha256;
	cv=none;
	b=kL7GDSTHvQwHUrjf+Sg/Wt00xEtnOnGuWBA4Y1xUAZR/9QllNI5WP3AAfSA2enrkQvOkqG
	c1yt83yWD0nfFv7E11wBThdjItqdkN65j5HFaQivVq5Rn/yh+fcspA4MULDkFFo3LsnM/o
	oY/xtxNRnGjVBF/bZbBNo6X/kPNvRmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 781E043D6E;
	Thu, 12 Feb 2026 23:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5155BC4CEF7;
	Thu, 12 Feb 2026 23:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770940416;
	bh=7ylnb5ynWTDR1dFA48S7QJY3cFKZlh8+h3w7rMjeS64=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Htv2usbBoStdACDrjbA/zXR9xkocBdtNNcQ5L79lRDrv0Rx3cLQLhmvwOrSSDgAXv
	 4t/aG2Eo0BfncaZBH+xWtd18RRtWSu1/7O+CwAI2J4EspSsgW2pfMIqiqifqpnJDS4
	 oY3zMJHRPHv4WshFj33munWouGyLJbBbsWN2UIZKUCA/drjl1WBW22ZG6d+TfrGuI5
	 IXZlath0Pfl6YI7eJit9ugK6BeicQNe/0e28TyAGjEu0d1G53eZUpm7D4AGd1/yjYL
	 ob+/SFIuqTQgJgNY38IouC+DOVtg6kvD3TZ0X8Co3lgc1cHdaRmI1dk04utFOhvKo7
	 hjYb93vsik1zw==
Date: Thu, 12 Feb 2026 15:53:35 -0800
From: Kees Cook <kees@kernel.org>
To: Andrei Vagin <avagin@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	Mike Rapoport <rppt@kernel.org>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, criu@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Eric Biederman <ebiederm@xmission.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Michal Koutny <mkoutny@suse.com>
Subject: Re: [PATCH 3/4] mm: synchronize saved_auxv access with arg_lock
Message-ID: <202602121552.C2AFE712@keescook>
References: <20260209190605.1564597-1-avagin@google.com>
 <20260209190605.1564597-4-avagin@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209190605.1564597-4-avagin@google.com>
X-Stat-Signature: qxkjocgtubajxgnkg7ezaz8ffgd1fpwf
X-Rspamd-Queue-Id: AC817A0006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770940417-797200
X-HE-Meta: U2FsdGVkX18ZRg+iiPCoq9JelX5MkD/zFLoIazapDP6VvoiiNjVCdC5AK7jCSxdfS43m2Rj0Ubj8q1Syf1KFUBIz7oMV+hslmsAJSFRuqYEvKkpvJ8Tdp6Fk8chP/l3zyk9e5Sed8avqDbocQMOeDWHU7nP8jEa/p1oAd4iQB5o36sJ21UG1WOvP30uXrH4zOLRnHlCEc/4BCDxW+IiWhtEwc7InLjwKJ0HWvcBLzXMtETeh7pkW+B4C0fKirXtYzX1uSeo/cd9UbwRKeATwJ4QFc2ovgNkpYv4h6Z+dV+5NoszUKkdPMONqGF6TmDOGR2Mf3QGbw3feUMjNJ4iNJyn8l/yiKMEKYPWvbv9+rklVe9hNL29jdQPJQ16UaCCbO7e1xmza8jUU/Dc9+pCWZaOyURRSJH4c0nn07vGTtB26U5/4iRjVa7NuQXKjFAY3Pj7A7+/U2rc0bFPNa64AbJ5WqE+HkCaa+akdONJT2zbdNJXlm0bYD9650BRDYr4oJfElKdKVRGw4S1zi+TPGSkH/Kq6tUK2QIK31750b5uqAqrCap7dSWqAb8RIDUjkeb6B17nnEwdpXf7d96EOIbotu9WcAfz2NGZUZ01fC+DFEvbK/161q3IxNajaVkHEGP+ei0omNLtVtyG5flf2f0AyrFfRcfDsHpJIxAnnva15/5/LPDOcf7oAz3kggbkyaf32x6rsVcAIZN96/478YIx88C0VZ4pMu2/wKGLqarSAfueLc+0xwBCjXU6/kBdgpASfBUh+Vj1NuvjvtA57fHI7YcqSPPUibHoRvKvFu6M6FF08YePkx0RlVMRI7HqL4GZlI8m0YysxgfgXcVbWgZ3soGEF5J5WxIlcD3cOdR17dr+imBhdjPluEyUPbq7G0Dc/kuXnxgXokVpk1M9RL0AJwvqquv1P2obnDbIltQS15DBvuQ/ZD+MNDv+fIF2JWIpUPB6dUuv4zlFf9bnC
 3uRdQQ9c
 evZ4IK5djaL18CZ/1qV+e1d0CD/DG4iZJyya1gmRB+rP0HUjT1L7LUrsQ/L85N9F5aosqlPo1DDDnn8vKNxQwhR0U8gAozW9wcCWdS8F0BZSN+5Zcpe5DjD5yuCwLQd91YC574pfFTPgRoriWHosmr8vZzb275wFHTYcDEzj+7e4jv/T3V1jCIRRuK2ku6kvLsDt5FvVpgg4s2rF9XvBwjwrOTvvtbDv038WzKKGu+98Y2Q8RHfGwlqHdw/BArtK4pECknSBYrzc23iCs9Rz5JIdNDtrZPM6NwZQSJoZYimnm5ON1ams5CzFHJVpzwtj34MIlwpXfKYBktn4yGUBmPS8L/VxbKjR007438kcwVBnB4fs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 09, 2026 at 07:06:04PM +0000, Andrei Vagin wrote:
> The mm->saved_auxv array stores the auxiliary vector, which can be
> modified via prctl(PR_SET_MM_AUXV) or prctl(PR_SET_MM_MAP). Previously,
> accesses to saved_auxv were not synchronized. This was a intentional
> trade-off, as the vector was only used to provide information to
> userspace via /proc/PID/auxv or prctl(PR_GET_AUXV), and consistency
> between the auxv values left to userspace.
> 
> With the introduction of hardware capability (HWCAP) inheritance during
> execve, the kernel now relies on the contents of saved_auxv to configure
> the execution environment of new processes.  An unsynchronized read
> during execve could result in a new process inheriting an inconsistent
> set of capabilities if the parent process updates its auxiliary vector
> concurrently.
> 
> While it is still not strictly required to guarantee the consistency of
> auxv values on the kernel side, doing so is relatively straightforward.
> This change implements synchronization using arg_lock.
> 
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---
>  fs/exec.c      |  8 ++++++--
>  fs/proc/base.c | 12 +++++++++---
>  kernel/fork.c  |  7 ++++++-
>  kernel/sys.c   | 29 ++++++++++++++---------------
>  4 files changed, 35 insertions(+), 21 deletions(-)
> 
> diff --git a/fs/exec.c b/fs/exec.c
> index 7401efbe4ba0..d7e3ad8c8051 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -1793,6 +1793,7 @@ static int bprm_execve(struct linux_binprm *bprm)
>  
>  static void inherit_hwcap(struct linux_binprm *bprm)
>  {
> +	struct mm_struct *mm = current->mm;
>  	int i, n;
>  
>  #ifdef ELF_HWCAP4
> @@ -1805,10 +1806,12 @@ static void inherit_hwcap(struct linux_binprm *bprm)
>  	n = 1;
>  #endif
>  
> +	spin_lock(&mm->arg_lock);
>  	for (i = 0; n && i < AT_VECTOR_SIZE; i += 2) {
> -		long val = current->mm->saved_auxv[i + 1];
> +		unsigned long type = mm->saved_auxv[i];
> +		unsigned long val = mm->saved_auxv[i + 1];

Ah, I see the signed/unsigned is fixed here. :)

I don't see anything in here that is fast-path, so the locking seems
fine to me.

-- 
Kees Cook

