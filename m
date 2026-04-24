Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D8FFF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 22:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FA86B0005; Fri, 24 Apr 2026 18:49:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350DC6B008A; Fri, 24 Apr 2026 18:49:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267166B008C; Fri, 24 Apr 2026 18:49:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 131F26B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 18:49:24 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9AE8B1B595D
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:49:23 +0000 (UTC)
X-FDA: 84694942206.16.03AFDC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id F22ED20005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 22:49:21 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZKfSCGh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777070962; a=rsa-sha256;
	cv=none;
	b=Hqmr8vsY5xMmpOIyWPl0I2DFuiCw3ku8aIGguhubHtXGzhn4xmPFGFL53pfga5FLCW2nDb
	iTfuuir8Ct/Sb1T9c0xE758cdPilQ1eb8o39eqIw3IgDmYYIR6Xw0lb86XgoKrPgYQzPpu
	NSV/mY+qgcJwXdM9mzbaiOMBxVprJFQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HZKfSCGh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of minchan@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=minchan@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777070962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qs+yQJxzGY4H6ro9FpRp6lusVJgt1cGy7IUTVtirfSw=;
	b=nZRmMLgmZoK6oG6xz/Zen8D4p7kAaaPBp9KOIBig2vcgAH/NV7REhpo2oaOUmHAp7fhM2X
	GnZODexCGeGvPa9m09trFTCcOYUPh9h2tWnohpmq9HViDwlzRJaV4ottgT10ea7uDMOrXs
	5lG3Vwp3g3anWipv7MsIt9lfC0UQHcw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 59EC4600AE;
	Fri, 24 Apr 2026 22:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB4F0C19425;
	Fri, 24 Apr 2026 22:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777070961;
	bh=1l62ftx9rkfVGFVp1ptfxZUhOlbilrk3qypY8gQ/oic=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HZKfSCGhqeT/Hgx9B3tULabhTtRaySMTyinTdk2FdWIyDC7t40ZprQtYh7JCySR8K
	 2wPYbEpNGkMwi7xDLMFjRV7dLQE7LLJwIlddQVn2FECNPdx1ldPqq5AgkzujbivYJ8
	 Mmz7sYngCWxENghv4T3MuDiar1qocWgKK31hWtO8PRYdepJ5+PP6Vc6AvP+Ahpwe+A
	 810t9AQCNij/dDbk0PuUYbz+cz8ob4pqtii8uFpeeHB1S0PuoufEX743NNQ0PxGGZs
	 FzoOxw1GEO+PMV0eWGhlJ3prsncgxpRP4l3wgVbN8c7DOAFK7o5HiCWEyGgn+z0QSk
	 tJuZiIi557lmA==
Date: Fri, 24 Apr 2026 15:49:19 -0700
From: Minchan Kim <minchan@kernel.org>
To: Michal Hocko <mhocko@suse.com>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com,
	linux-s390@vger.kernel.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [PATCH v1 3/3] mm: process_mrelease: introduce
 PROCESS_MRELEASE_REAP_KILL flag
Message-ID: <aevzbx_Pk5Cu5exa@google.com>
References: <20260421230239.172582-1-minchan@kernel.org>
 <20260421230239.172582-4-minchan@kernel.org>
 <aesiYAumkLCyedf0@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aesiYAumkLCyedf0@tiehlicka>
X-Stat-Signature: xtnc3q89nykcrme1pgqw6w1f67h848is
X-Rspam-User: 
X-Rspamd-Queue-Id: F22ED20005
X-Rspamd-Server: rspam07
X-HE-Tag: 1777070961-869414
X-HE-Meta: U2FsdGVkX1+CfzdaApYEAqUZVnL8b3vE+BcFJIpPRjclNY3hRY5D8uaNB0BLZDR6iPrkP/Nr0kr4cnKgolsg9zLFjAaESNzBNudy9jU861m1adfzagmktsVd9ix5l+bWjO3zh2OxntwNyqWnQQgcefgzia+6X97z6VcwYu/pYB3TNHTf88JXKdziGrIEvC7fGmSOJym+QsFbIAXyxeiiYGLKEx+aHuUScR1odkxOxJeknNvKsPSDXT+j2F1Riz2S7W+fZx79Xfeb9uWjT7zDCYhoS+aaHoOHpm6FtOzk+GwBa9FqAL5RTcuV8NIj+kK0pJbdcSo2N2Tgbd91I5dMgcq+yX4chq+dFO4aXJY8b88P0k1D7N822m4tx/Zwv4nGcpMWSoTSp7v2LohEa9c8mqQIyhWav+xJ0FkZCX1lHLjGOnIsgmAt6TT89z/GxiWez4+nLD6AguwTQvRo/6H6mozzN/1ChoKLRXs042rmEKG3tJ7Jkue6bEV2euzMEwglQTI1f0ucWcFkNDdR8j/KGXylojrvySzfqB16Dn/hbffJHLLC0cLQDBn6Lbc5nUBOOL5zVTOfc8xrNjzff+08+lS96J2BT6KoRkPho1xktHkxQXlwLuxpWqoWpX5N53HaoV27EoBwEth/VnB0MTknWSdnQa6oG9a95l3kyO/+LC0GOvoYtoudtE+tDFGsLASYbIqklHudstto1kXjHOyveIPtQPQpn6MpCZJFdXiLe8Fj33Fx8To94ieuti5+cqpl3dELT70CmxKzih8s3GXW9WPaOLMH0m9CJ598ULjxekPUo4KaEq3fN5idgz0ROmNLYO9SMciPMlxIiSDnA/zrGfRlNfI1bO+yM/3PeY4weq1HF2RnUPf1r0F3593sDySbJbB2ijS8TbfroX/gnNBiR12LasQ4UKnqahkbEyAlu2+KXHO+pehI/axzOSWejR2hdVxe7AY2FDmppNYhtsO
 MUUA5xEt
 G063xtb1bG2n2BdY7Aj71VTJSLsmI3TAw6fbxxjuzBxDPUQSKfSirTVDtY70p0DUnAHZUKIPozgl6WTatRywqu2VrQmIO7FdXE2160NCTbnII7S9idWZsbWUydAdjetj8hlkrdBv6Mmni6IZvh+nzUzXQOOss5luqRd3LPmSOjcFuk5yUgYgec8HkvsJ0sxACuF33gInCXPDe7bBuOQSBRr4XG/LHUNE+U15q5dKQ8gxqTKTTkldGPafMHpCZGi9AbI0a2JY7LuqiaDo31RCGnQRt5J5QFNEmQ5SekUceYu9WVFDMAPmI94F3yQzrCcv67AmEWJlVayMPY/eKSs1LYKhxzHo+Tj/0qg859ik1Q7yzZE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 09:57:20AM +0200, Michal Hocko wrote:
> On Tue 21-04-26 16:02:39, Minchan Kim wrote:
> > Currently, process_mrelease() requires userspace to send a SIGKILL signal
> > prior to the call. This separation introduces a scheduling race window
> > where the victim task may receive the signal and enter the exit path
> > before the reaper can invoke process_mrelease().
> > 
> > When the victim enters the exit path (do_exit -> exit_mm), it clears its
> > task->mm immediately. This causes process_mrelease() to fail with -ESRCH,
> > leaving the actual address space teardown (exit_mmap) to be deferred until
> > the mm's reference count drops to zero. In Android, arbitrary reference counts
> > (e.g., async I/O, reading /proc/<pid>/cmdline, or various other remote
> > VM accesses) frequently delay this teardown indefinitely, defeating the
> > purpose of expedited reclamation.
> > 
> > This delay keeps memory pressure high, forcing the system to unnecessarily
> > kill additional innocent background apps before the memory from the first
> > victim is recovered.
> 
> Thanks, this makes the motivation much more clear and usecase very
> sound.
> 
> > This patch introduces the PROCESS_MRELEASE_REAP_KILL UAPI flag to support
> > an integrated auto-kill mode. When specified, process_mrelease() directly
> > injects a SIGKILL into the target task.
> > 
> > To solve the race condition deterministically, we grab the mm reference
> > via mmget() and set the MMF_UNSTABLE flag *before* sending the SIGKILL.
> > Using mmget() instead of mmgrab() keeps mm_users > 0, preventing the
> > victim from calling exit_mmap() in its own exit path.
> 
> Why is this needed? Address space tear down is an operation that can run
> from several execution contexts.

Agreed.

> 
> > This ensures that
> > the memory is reclaimed synchronously and deterministically by the reaper
> > in the context of process_mrelease(), avoiding delays caused by
> > non-deterministic scheduling of the victim task.
> 
> The memory is still reclaimed synchronously from the mrelease context.
> This is really confusing.
> 
> Please also explain why do you need to do all that ugly
> task_will_free_mem hoops. Why cannot you simply kill the task if
> task_will_free_mem fails (if PROCESS_MRELEASE_REAP_KILL is used).

I wanted to handle shared address spaces.
Even though we are okay with the target task not being in a SIGKILL
state yet (since we are about to kill it), we must ensure that all
*other* processes sharing the same mm are also dying.

If we simply bypass the check and force a kill when there are living sharers,
the memory will NOT be freed even after the target task dies because
the other processes still pin the mm.

So, to address this, I think we need to modify task_will_free_mem() slightly
to ignore the exit state of the *target* task only, while still checking that
all *other* sharing processes are dying:

static bool task_will_free_mem(struct task_struct *task, bool ignore_exit)
{
...
/* ignore tarket task's signal state */
if (!__task_will_free_mem(task, ignore_exit))
    return false;

/*
 * but other processes sharing the mm with target must be exit
 * state
 */
for_each_process(p) {
    ...
    if (!__task_will_free_mem(p, false))
	return false;
}
...
}

