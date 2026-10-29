Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 631CC606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 11:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=digikod.net header.i=@digikod.net header.a=rsa-sha256 header.s=20191114 header.b=qws1AYFs
Received: by kanga.kvack.org (Postfix)
	id 6E3A86B05B4; Thu, 29 Oct 2026 07:37:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693EE6B05B5; Thu, 29 Oct 2026 07:37:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9E86B05B6; Thu, 29 Oct 2026 07:37:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBBF6B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 07:37:29 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C11C51C39F8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:37:28 +0000 (UTC)
X-FDA: 85375463376.11.83551A0
Received: from smtp-8faf.mail.infomaniak.ch (smtp-8faf.mail.infomaniak.ch [83.166.143.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id A074920006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 11:37:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=digikod.net header.s=20191114 header.b=qws1AYFs;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of mic@digikod.net designates 83.166.143.175 as permitted sender) smtp.mailfrom=mic@digikod.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793273847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHfZE4PHAumKVw00FNrKGZ/KoE0eh/vNsiLYomKpEgw=;
	b=YMEUIUsrVzjC+rPh/RVS/aJuw786esBcwZ4e5KzuvarvkaCQ64bq0Q4GbaCwRywijvEfU6
	dPTtb0MoTsGpEQA0aYqYO3RwFBLutS/AKB8iLxEvc/MRQmlcuJ7v2xT6+0xXtEu3oPx3bR
	gXZzDQvny1fLKFa4um4hlRyqWl/NIv8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=digikod.net header.s=20191114 header.b=qws1AYFs;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of mic@digikod.net designates 83.166.143.175 as permitted sender) smtp.mailfrom=mic@digikod.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793273847;
	b=bLpvYE/Z7y3o9LRjSu0KvZPsUxl+OBnTkonW8M6FTkYU0y8cJXi5kXYGPTMhUbkkdPLAnB
	HBo453pIB7WrML+GLw1fp42zgYCfzTMZmZbD6VlTf5Cb/Oihry77DuYLv8ovKbU9wq/ABZ
	BFbaKe9jJu5AvqWxKcZ2kBN7BqjozdE=
Received: from smtp-3-0000.mail.infomaniak.ch (smtp-3-0000.mail.infomaniak.ch [10.4.36.107])
	by smtp-4-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4jFhzR5v8nzt0C;
	Thu, 29 Oct 2026 12:37:23 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1793273843;
	bh=eHfZE4PHAumKVw00FNrKGZ/KoE0eh/vNsiLYomKpEgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qws1AYFsJRAFrEibfRJMw6vRg1RddQFeLYZXo/dFV6qTtr2iUnKM1pIjCmJI4kda4
	 Gha+sg06kqltmryQZ2HwEdjmuONSjezZzJeiopU5f/fR0VmNz8XuWMCnJVE9r6yPtN
	 yqjz5rjdDMl5FG1E3bZQddWAqWSkmZBEuia7KoAE=
Received: from unknown by smtp-3-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4jFhzQ1yLXzGM3;
	Thu, 29 Oct 2026 12:37:22 +0100 (CET)
Date: Thu, 29 Oct 2026 12:37:20 +0100
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jann Horn <jannh@google.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] userns: don't drop the exec securebits
Message-ID: <20261029.Yae2Nohsheun@digikod.net>
References: <20261026-work-securebits-userns-v1-0-b35473fa1a34@kernel.org>
 <20261026-work-securebits-userns-v1-1-b35473fa1a34@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261026-work-securebits-userns-v1-1-b35473fa1a34@kernel.org>
X-Infomaniak-Routing: alpha
X-Rspamd-Queue-Id: A074920006
X-Rspam-User: 
X-Stat-Signature: 96cp4m9gshia6botthye46cqr18so4fn
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793273846-193059
X-HE-Meta: U2FsdGVkX18eJit3xZdgMMnkjAheCLbIzBXf4vDmegErBwZP51oy7WO3gsuf97AS1n+PqL3clbckPWQBzbpjINVVlT/0X+/KkoIwq08Qe7xlqdVSwwjuNdOGIBqJ0AR06LkKqdCuiEMHrE/M9maT3ROcnQylH19HtYZR+uLpHB7SK8HEWdRFkcLqBR+g9yN8tZy50raa/rUwiB7paN+2pNRCU0HXNPtuMGK1FLluJMgdFDVHMLD14SGf3JYbpqsg8oLDSbMjIr1FEHyeeapACdqepCXnI2CYS/uYFtJ9ASrBYttTIM61vOeWXib3lqiGfR8ZiAfBBozvMOyEzN5mP4G66zMmwwAxx8FlVMZSS2JkQki1V+/CIA3CqjOJO47uGGYmlFsqk99DSlyELgsDJi36I5WL4gQQk34LXSXgfKrjuoxPw+Sbg43lmDXy6QzZYh27Wxb9wtzBFcgG8xeOh/Gws5poYtLCiEZftyvNeTYRDgZpHtXUvt/G0VIYiGJthX02u6Rbb20jMMu1xVro+i6Ix7B0yo+Eifl5NELNA3VroGjmCqslDq/Z2tPLpHFnXl6c+mZF9t+PlcJk4NCm6VXGqflU/S++gGdANuPxUv5AKjPaExMmyRUcdaHPbQAxQKYwfRkXILU2VButcbxrakSIi1OLz0l0FWkYMSRUCsIJro0d4gLR9Dptzq7QV3tjyMA8bTcL/CUiUwkrdQcUFSFdOL+uel3cX+NYKH4MMXUKha2gMA3EK9ib3KuhkLykxthrnsilx/px4o5/aW+U+TPsYqPEBQpzNKcOUQqvrYOzLke43ZZOZKl+NJ5i6nFNBSzrK+STumzNUrQICWrHJorh2nbFliXi8raiPqEoXo1bccRXT0K7UlryffeLElPJnj4ytJFZt+aFQwdOV8IKz0v+sMaUYylquq2TS6Vxpf+4iBbYVQXkUTgUgneg8hnMtj2WadiuMa6MmBgZES5
 1QnKKgh7
 7PO7RYh+suDFIpOcKp3OfszGmOwtavsfHQxKw+kK5akIwbL0f0P2onT4VKWa/H/9lyP4sysbdJ3alXYiUFtosa+jqwHFy6uAAUA7FkTC6zdbftg4vLohA/TYbx3Tqob2JuFYngYmzpRGlDRKfRfnU8JFzUoxz0sNF4mIPW2yILG4ZywMciWwsawdgMbxFT+yiljNmqbwYEMIb+A9XPNJnnY0hyW89Zw7c+Cp5XKqlFBR3YX9cT3Qd16MqNt08N0kpuxrx94NW1PvhfA9uydIUrpAYfDB5dYRKZp8ha3EPLWjztNrQMN8nvaJCHCh7EXaRiascj3HVUydhH20wg7sx037d7eXa6cH0F/gVjbAfVLBa1nyYSHf/LL65Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 09:53:29PM +0100, Christian Brauner wrote:
> SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE tell script
> interpreters to only run what AT_EXECVE_CHECK allows and to refuse
> interactive input. A service manager sets them together with their lock
> bits so that nothing below it can turn them off again.
> 
> But set_cred_user_ns() resets all securebits to SECUREBITS_DEFAULT. So
> any task that can create a user namespace sheds the locked exec bits
> with a single unshare(CLONE_NEWUSER) and joining one with setns() does
> the same. The lock is pointless if anyone who may create a user
> namespace can drop it, and that is pretty much everyone.
> 
> Resetting the other bits is fine. They are about how capabilities are
> computed and a new user namespace starts out with a full set of
> capabilities anyway. The exec bits grant nothing though. They are
> restrictions a task placed on itself, just like no_new_privs which a
> user namespace doesn't touch either. So keep them and their locks.
> 
> Reproducer:
> 
>   // SPDX-License-Identifier: GPL-2.0
>   /* Lock the exec securebits, then create a user namespace and look at them again. */
>   #define _GNU_SOURCE
>   #include <sched.h>
>   #include <stdio.h>
>   #include <sys/prctl.h>
> 
>   #define SECBIT_EXEC_RESTRICT_FILE		(1 << 8)
>   #define SECBIT_EXEC_RESTRICT_FILE_LOCKED	(1 << 9)
>   #define SECBIT_EXEC_DENY_INTERACTIVE		(1 << 10)
>   #define SECBIT_EXEC_DENY_INTERACTIVE_LOCKED	(1 << 11)
> 
>   int main(void)
>   {
>   	int bits = SECBIT_EXEC_RESTRICT_FILE | SECBIT_EXEC_RESTRICT_FILE_LOCKED |
>   		   SECBIT_EXEC_DENY_INTERACTIVE | SECBIT_EXEC_DENY_INTERACTIVE_LOCKED;
> 
>   	if (prctl(PR_SET_SECUREBITS, bits, 0, 0, 0)) {
>   		perror("PR_SET_SECUREBITS");
>   		return 1;
>   	}
>   	printf("before: 0x%x\n", prctl(PR_GET_SECUREBITS, 0, 0, 0, 0));
>   	printf("clear locked bits: %s\n", prctl(PR_SET_SECUREBITS, 0, 0, 0, 0) ? "refused" : "ALLOWED");
> 
>   	if (unshare(CLONE_NEWUSER)) {
>   		perror("unshare(CLONE_NEWUSER)");
>   		return 1;
>   	}
>   	printf("after unshare(CLONE_NEWUSER): 0x%x\n", prctl(PR_GET_SECUREBITS, 0, 0, 0, 0));
>   	return 0;
>   }
> 
> On v7.1 this prints "before: 0xf00", "clear locked bits: refused" and
> "after unshare(CLONE_NEWUSER): 0x0". With this patch the last line
> reads 0xf00 as well.
> 
> Fixes: a0623b2a1d59 ("security: Add EXEC_RESTRICT_FILE and EXEC_DENY_INTERACTIVE securebits")
> Cc: stable@vger.kernel.org # v6.14+
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Thanks!

Reviewed-by: Mickaël Salaün <mic@digikod.net>

> ---
>  Documentation/userspace-api/check_exec.rst | 4 ++++
>  kernel/user_namespace.c                    | 5 ++++-
>  2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/userspace-api/check_exec.rst b/Documentation/userspace-api/check_exec.rst
> index 05dfe3b56f71..0904810e1d8d 100644
> --- a/Documentation/userspace-api/check_exec.rst
> +++ b/Documentation/userspace-api/check_exec.rst
> @@ -99,6 +99,10 @@ This secure bit may be set by user session managers, service managers,
>  container runtimes, sandboxer tools...  Except for test environments, the
>  related ``SECBIT_EXEC_DENY_INTERACTIVE_LOCKED`` bit should also be set.
>  
> +Both secure bits and their locks are inherited across :manpage:`fork(2)` and
> +:manpage:`execve(2)`, and they are kept when a task creates or joins a user
> +namespace.
> +
>  Here is the expected behavior for a script interpreter according to combination
>  of any exec securebits:
>  
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index 50c374ed4687..cd748e1cbace 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -46,8 +46,11 @@ static void set_cred_user_ns(struct cred *cred, struct user_namespace *user_ns)
>  {
>  	/* Start with the same capabilities as init but useless for doing
>  	 * anything as the capabilities are bound to the new user namespace.
> +	 * The exec securebits grant nothing, they are restrictions the task
> +	 * placed on itself. Keep them and their locks.
>  	 */
> -	cred->securebits = SECUREBITS_DEFAULT;
> +	cred->securebits = SECUREBITS_DEFAULT |
> +		(cred->securebits & (SECURE_ALL_UNPRIVILEGED | SECURE_ALL_UNPRIVILEGED << 1));
>  	cred->cap_inheritable = CAP_EMPTY_SET;
>  	cred->cap_permitted = CAP_FULL_SET;
>  	cred->cap_effective = CAP_FULL_SET;
> 
> -- 
> 2.53.0
> 

