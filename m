Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2EAA606A32C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 20:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JOsJo58g
Received: by kanga.kvack.org (Postfix)
	id B0F8C6B05B0; Sun, 22 Nov 2026 15:01:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2306B05B1; Sun, 22 Nov 2026 15:01:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1B66B05B2; Sun, 22 Nov 2026 15:01:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69B9C6B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:01:34 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7CF4D40583
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:01:33 +0000 (UTC)
X-FDA: 85463824866.16.0127039
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id D2A2020002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 20:01:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOsJo58g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795377692;
	b=zoZU6XGDr6Yl6O2hZsj5AAWNWp9P5dCQamdDz1Wvw4pVu+W7NPzAXiADxF2aYOSuPSfsdP
	GdcjfBtce996pP6iT7GA84/8kkH6JZNisnP8xx1zr2KdH6yMWGvmnPUQ4W0Nek/11WsM6k
	aEpwOSFiFKjlxGYWkCqz6YUnttd0r6I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795377692;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=653PgcMOq11akoYkQNWGGNWj0TBZZyN6dIDLqLNtxLg=;
	b=Xuc8h5O/wJn4L30bmynwkOYg09DVvVUTWP8gcxRx7g1AbbB6G133NRC/TC1udcu4SFHLBS
	YPVLDIAyKf0wMZ9w8MlsQTJ4/Zr3J2GSmsxqSbdpv9wSqdakbC/H/7m/a+ZEHvtrdctJnb
	c3Wpg3gl4Bf4Gw5n4Feqq1VMAm6D4xU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOsJo58g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4336861198;
	Sun, 22 Nov 2026 20:01:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B6E1F0093E;
	Sun, 22 Nov 2026 20:01:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795377690;
	bh=653PgcMOq11akoYkQNWGGNWj0TBZZyN6dIDLqLNtxLg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JOsJo58g4H5gt9XjvzClwUehikkeB8FjdCZIQopsbOcBgwSu4+hQmfj2hQcojnPzO
	 264QbBR8HdcbwwcZto8MTlRe+BhweKs74ToV03SBSLwU4t+WwRIiNEsAPMnBbG9lcY
	 ku9dSzTXbLAM0CfH/A2cezjfmVgoEtEO5nM5fxooplqAuft9VsIZV+4d5PZa7M5DgD
	 A1y5jFuWRR2HUAVdxlAEKORyMW9A0eLODHQxwmuExYX32nxPcMbNhYAibwRqKlvwJi
	 DkUUA23rcyklIcErrG5RX0LjbzLt6QIeGjPF/KnBT5fHGdnXW3hpKNzzJ41mGsMe0e
	 p1iXb8VbzAIaw==
Message-ID: <sashiko-outbox-228304@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v7 17/26] fork: Support CLONE_INTO_USERLAND in
 clone3()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Aleksa
 Sarai" <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski" <luto@amacapital.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Eric Biggers" <ebiggers@kernel.org>, "Giuseppe
 Scrivano" <giuseppe@scrivano.org>, "Hugh Dickins" <hughd@google.com>, "Jan
 Kara" <jack@suse.cz>, "Jeff Layton" <jlayton@kernel.org>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP Singh" <kpsingh@kernel.org>, "Lennart
 Poettering" <lennart@poettering.net>, "Neal Gompa" <neal@gompa.dev>, "Oleg
 Nesterov" <oleg@redhat.com>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Zygmunt Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261122193539.3334213-18-jarkko@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <20261122193539.3334213-18-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 20:01:29 +0000
X-Stat-Signature: ghdu771d7ohoytiextfic599pup6w46a
X-Rspam-User:
X-Rspamd-Queue-Id: D2A2020002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795377691-682692
X-HE-Meta: U2FsdGVkX19+2UJ6WyDSUqzM42a0Ljz8V2Idh22ZG6rHv0910JYmyDrbqItmneUiQhUADhNspUjpWlrhV2SuEtStHpClqWfx1+GNsSgWjoO+bDv35Xa7vkN3DE5mPzfvzVmqsrUL2hi0VgmRubYJLdVUR29ymcdhvQnWg44LZ3OtxwB0KBXWPI0ksBdc7M7IrvhPZeiJigF4YRqnDiJmjTLHf8dvpYyQ1S3ti6qmgcwsVxcuFLLsJqmpq11swZegbiXvKZici0K+8S2+ZoUJO8ZtFFQminjvBJKJdaEh3015axRqKmSj5ZiHyRdFIXkXe18qNiALqX1s/jFdUoRtrlyMvcLLMnZUKOpanuuabGrprt6EFZVUwtdG53A2CJuKPjGf32KSEqpLJNG91gpxbrOEn7mL5hTv7ri5aDIWpvYYXKS4l2xEdIa358LI99/XSWzlNvGmxgklFfoqj/6D19JaG8DZxv1iU1HNaqtweRFf0SMIi44kEJNogyoVeAvtNz7SACTUSZKAJL0266E5xwWWu4O5eQevcHWPVHEQDZWOw8IuWDycTAxxlCOGxfc2PHQecBcjgP4LI3wezmh83Cb0cIMj/F2yoShXLfiffrSVYUM1hRuktvidSP/fkD+zk4yUndws/Ma3Nq5vAGvt1ZN5rkwqlwUFsPpEyf3fJr/F2Ugf6ZrmWH1tyXoXn1iuhmVJpEjXbNr3crO3BBmTdKZdDGxylvWsD4MvUXheidy4c8coKPsUYpqjRsVkrtlfkE6Gg6I9vR3O82zfUIR9wjy/zJTb5rK89cci885jsxdMcH0hnUiuGDT1NSOPxrZ01w6ilFLxzfxQOTeWpl5olxcHBJjaa4UIVkx9U1DI2TuQWhi2M/ien//cHFwhb0dRaYi8wZZJvW6/IKNijVS4pF2VfuTBGyzsRJ+U1A//Y7qFFoiUXRJcd7i9xH8sL0tB2I2Cr+z/TH/sZszxnC0
 TIyDvTyC
 TCmhbAuswASvHLhTnGokHFKlltAqaI3b4pOh9Q6nngXbEg91CB++BTklVOcyA+r6fHUb2UATXPDKY5tV2xTr7+4Yrt9f5Y8UPRqAU6Z/zilxnHsDifB/i1VzclLAm6Tclz/R87OC2MDZqbINV6BmUhdhD4JM/ibjfVLSb7ZwBCasizEy0rmFAckcVRQvH+D+njM7g9uIAhqtSm2rH5u8L+wkYr/9XU3v4xJSgOEqiMyhOd+J/E2jMpuR9E8MeFjmyQ7D6xKm1E/OScrxaibviMuLRz9GeS/3U4sPvJrgODVSJGXlgx1cbhfYBwfoodk/jSdlsMOKh+YEXAZpZEf8McLNdeCHxAWmIo6JhDYZTQnWOIOR9KwWp3ya9ZFsi99GnmAm1UAc4ITOU7RCGL43lEKDiP/GhXg+cYQAbmZ98JG4OmSX67CG7UqwJY2fuD3V0abgmiYh00NkzonGIrN7oKT8zd8q9kfIas2Oz7SAuO3HqJbU+WM+8xCOwl2jMtyzT26eJSIZ0o0iCUmqQu4HpjsdSxbvcXBSFUkFBRwVWbYPqRnyfCCWWe32GARD14xOTEylSMTiLweDe+2OHj8bBBjMTv+Gs1CjChVkflTvvhvaDi+ygDjYFf2t5KSCS9xCvkJ811JtWTI4CrLQKjzzASgIu+Kb7XF3LfmAIJVVJcU+n9bRBAo5fcEoygsR990JkhIR4XK2yfysfCjejsdH58XlRJgxamHYGAV41LwCTA0feNVpzEkYrs1PdYkKssZn2O6i9KNJEahjlBuDX0VzNvjTWSAXAyfpLXeSkdwKc+ZVDb0sDLAWA1aUCOo/vEXac0HoqF36AwT/UZFddDzmwDHuJtqgHdM02WAoDXZQjzQTjFgY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] userland: missing namespace owner permission check in
  userland_prepare_fork()
- [Medium] fork: missing ancestor PID namespace liveness check in
  copy_process()
- [Medium] userland: missing Landlock namespace-use check in
  userland_prepare_fork()
--

commit ae368fbd705dc27859acdfc3d94bc11f009bc3b0
Author: Jarkko Sakkinen <jarkko@kernel.org>

fork: Support CLONE_INTO_USERLAND in clone3()

This patch adds CLONE_INTO_USERLAND and struct clone_args.userland to
allow clone3() to spawn a child process directly into an initialized
userland's namespaces and root mount.

[ ... ]

> diff --git a/kernel/fork.c b/kernel/fork.c
> index d87ab7cbad5e9..d8fc18a9af220 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c

[ ... ]

> @@ -2510,6 +2526,11 @@ __latent_entropy struct task_struct *copy_process(
>  		goto bad_fork_core_free;
>  	}
> =20
> +	if (unlikely(args->userland_bootstrapping && !is_child_reaper(pid))) {
> +		retval =3D -EBUSY;
> +		goto bad_fork_core_free;
> +	}
> +
>  	/* Let kill terminate clone/fork in the middle */
>  	if (fatal_signal_pending(current)) {
>  		retval =3D -EINTR;

[Severity: Medium]
Can copy_process() attach a child into a dying ancestor PID namespace when
cloning into a nested userland?

Immediately above this check, copy_process() only tests PIDNS_ADDING on
the leaf ns_of_pid(pid).  When current is in an outer PID namespace A and
spawns into a nested userland C whose parent PID namespace is B, B can
enter zap_pid_ns_processes() after alloc_pid() succeeds:

CPU0 (in pid_ns A)                CPU1 (init of pid_ns B)
copy_process()
  alloc_pid(C)
                                  zap_pid_ns_processes(B)
                                    disable_pid_allocation(B)
                                    read_lock(&tasklist_lock)
                                    /* sends SIGKILL to tasks in B */
                                    read_unlock(&tasklist_lock)
  write_lock_irq(&tasklist_lock)
  !(C->pid_allocated & PIDNS_ADDING)
    -> false (C still has PIDNS_ADDING)
  attach_pid(p, PIDTYPE_PID)      <-- attached into dying B after SIGKILL

Because current is in A, fatal_signal_pending(current) does not trigger,
and if C is bootstrapping it has no tasks in B->idr to trigger C's
teardown.  The new child (with SIGNAL_UNKILLABLE if PID 1 in C) then runs
inside dying namespace B, blocking B's child_reaper in
zap_pid_ns_processes() until the child exits.

[ ... ]

> diff --git a/kernel/userland.c b/kernel/userland.c
> index f449e2ff91522..2375442733b66 100644
> --- a/kernel/userland.c
> +++ b/kernel/userland.c

[ ... ]

> +int userland_prepare_fork(struct kernel_clone_args *args)
> +{
> +	struct file *file __free(fput) =3D fget(args->userland_fd);
> +	struct path root __free(path_put) =3D {};
> +	struct pid_namespace *pid_ns;
> +	bool bootstrapping =3D false;
> +	struct userland *userland;
> +	int ret;
> +
> +	if (!file)
> +		return -EBADF;
> +	if (!userland_is_file(file))
> +		return -EINVAL;
> +
> +	userland =3D file->private_data;
> +	if (!ns_capable(userland->user_ns, CAP_SYS_ADMIN) ||
> +	    !ns_capable(userland->user_ns, CAP_SYS_CHROOT))
> +		return -EPERM;
> +	if (current_chrooted() && !ns_capable(current_user_ns(), CAP_SYS_CHROOT=
))
> +		return -EPERM;

[Severity: High]
Does userland_prepare_fork() allow a process to join shared namespaces in
userland->ns without being a member of those namespaces or holding
CAP_SYS_ADMIN in their owning user namespaces?

userland_share_nsfd() allows binding a cgroup, IPC, UTS, network, or time
namespace owned by a more privileged user namespace (such as init_user_ns)
into userland->ns without CAP_SYS_ADMIN in ns->ops->owner(ns) whenever
is_current_namespace(ns) is true at ioctl time:

kernel/userland.c:userland_share_nsfd() {
    ...
	if (!ns_capable(c->user_ns, CAP_SYS_ADMIN))
		return -EPERM;
	if (!is_current_namespace(ns) &&
	    !ns_capable(ns->ops->owner(ns), CAP_SYS_ADMIN))
		return -EPERM;
    ...
}

If the caller (or another process holding the userland fd) later enters a
separate network, IPC, UTS, cgroup, or time namespace,
clone3(CLONE_INTO_USERLAND) only checks capabilities in userland->user_ns
and installs userland->ns directly in copy_namespaces(), letting the
caller escape its namespace isolation into the previously bound namespace.

[Severity: Medium]
Does spawning into a userland also bypass Landlock's
LANDLOCK_PERMISSION_NAMESPACE_USE check?

Landlock mediates entering existing namespaces through the
namespace_install LSM hook (called from validate_ns() during setns()), and
does not implement a userland_clone hook in commit "security: Add userland
LSM hooks".  Because userland_prepare_fork(), copy_creds(), and
copy_namespaces() install userland->user_ns and userland->ns without
calling security_namespace_install(), a Landlock-sandboxed task holding a
pre-opened userland fd can enter its namespaces even when
LANDLOCK_PERMISSION_NAMESPACE_USE denies them.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122193539.3334=
213-1-jarkko@kernel.org?part=3D17

