Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F318606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 01:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VLWTIuAh
Received: by kanga.kvack.org (Postfix)
	id 655AD6B05B1; Sat, 21 Nov 2026 20:43:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606676B05B2; Sat, 21 Nov 2026 20:43:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E206B05B3; Sat, 21 Nov 2026 20:43:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2C81A6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 20:43:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADBEEA068F
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:43:49 +0000 (UTC)
X-FDA: 85461058578.08.1096D55
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0D1A7A000A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 01:43:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VLWTIuAh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795311828;
	b=o3yVj4UDIOipe2TbIZpCPGfRipG97nNUNmycuMW6+ozUSxjtxceQAwGCiQUIelaRxlV9KK
	gwWvvbBaObAwIFNaKJhFhCQYlNfthFfNe6+pexHor4Ou3rI61We5ZITvKlOasZrlDmV8L9
	7TifIS++miUPaTEW67x100ouqaP19kY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795311828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xcFuD9TGh+7BMax0WCH9B1L1wKwMb5cO3D0UHkJWHqQ=;
	b=ThW48sgyi7cuQVE09FMTBgBrof8C4j7hEoXbWYA/xlY2cyvEa79+7w73RaptH0N4ZDqZWX
	uzxrav6vUlleZPV+Sy+QFpUWvwmfQEO0vSNhv5knUZqa2HvFvuSfd9d6f81CaY8p+KKCLG
	7OdCmBiggUEdjiCHBn1uRz79eUSbYZg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VLWTIuAh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39C6343D15;
	Sun, 22 Nov 2026 01:43:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E012D1F000C0;
	Sun, 22 Nov 2026 01:43:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795311827;
	bh=xcFuD9TGh+7BMax0WCH9B1L1wKwMb5cO3D0UHkJWHqQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=VLWTIuAhQt1tfpWhTGgW1y5jlgcDPw6b7NhvZCIJ4LOL8s++76W2WziW1Q5WPwu50
	 NdinTg0Mwu24toCH2Uph1RpQdf2aK+JRJ/3yPJXDxFI0EiOBaKhX6NIT8wJq0XXSS7
	 C8glbI7Efo/3v2t9ZjFlR2HPKxb0PtJgH6arVy5NPW47dDkLcJuIzGKukmeb0/SYBC
	 9S8lKmVEU00v8Vb0Bf/t2dGOnrcb+3e+ZTheievcuR+Jq7mfDCSblXACon9Z/yHToJ
	 Z7KPFfIlGLtVKWv9DpibvbokRjif2y0tXyTDLa+T+gZWFCut2S00zW3suMzVS5xExf
	 FmudS+V0Qsr9A==
Message-ID: <sashiko-outbox-227629@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v6 17/26] fork: Support CLONE_INTO_USERLAND in
 clone3()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Aleksa
 Sarai" <aleksa@amutable.com>, "Alexander Mikhalitsyn" <alex@amutable.com>, "Alexander
 Viro" <viro@zeniv.linux.org.uk>, "Andy Lutomirski" <luto@amacapital.net>, "Arnd
 Bergmann" <arnd@arndb.de>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Giuseppe Scrivano" <giuseppe@scrivano.org>, "Hugh
 Dickins" <hughd@google.com>, "Jan Kara" <jack@suse.cz>, "Jeff Layton" <jlayton@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Josef Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "KP
 Singh" <kpsingh@kernel.org>, "Lennart Poettering" <lennart@poettering.net>, "Neal
 Gompa" <neal@gompa.dev>, "Oleg Nesterov" <oleg@redhat.com>, "Paul Moore" <paul@paul-moore.com>, "Pavel
 Tikhomirov" <ptikhomirov@virtuozzo.com>, "Serge Hallyn" <sergeh@kernel.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Zygmunt Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261122011809.2667684-18-jarkko@kernel.org>
References: <20261122011809.2667684-1-jarkko@kernel.org>
 <20261122011809.2667684-18-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 01:43:45 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0D1A7A000A
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: g8ztibf5sibk6i3azjs6nqj63dezzcex
X-Rspam-User:
X-HE-Tag: 1795311827-826102
X-HE-Meta: U2FsdGVkX18bGcEi3qWCk2VMNL1hYXRIZoLEHJb8ElUEB7eBGmyJpdmcE3SPgS1ApwL6HXFAAT3Fub0OdY8kYvohsFEyTA0fvO8gCUHq2tMWUsO1dEsaYBWuPovMKNkfzUyVcSHOAJnSgUrl25j/pEagVOOWv78F2fmTBnKSJIdo2bnnMhC3+VMoKMM1nk7gdoJOvNuFtNh+2tgBdfM7/RpV0NCoBNOGGybJLE5SBNX4MWnNESg6mw5QwSpsFNMODA0jF6qpVn/JFj4fzGJQr9/XjeMHDOlz4uR7jfzfOjJ7Kpnrib+jWNlZ2vWBjX4QaolKcTC+K6C6x+4dYFTx0M3bt2bPOXmgY04KD8mfwKoq5ZXU1ootBfg864ceXtfW7ny7Xi4pEp6zdM6PWIU6mW87yFJiklcAlUa8qUKT8S4n8X9mLIhpV+Hkna5pKYJAgTA6g2aMQ8v785CtJv3ub+gWoNDcsNqPZVrZemLAQL20xmJGR7Ag46lR92gCjqKkuQGimlqB1WUxETRtNDj/tEsOXgYIeLkhD5/P6qXRupqhIcfH5+NoCoesVrwIXGZ2hdbn5UCYS3MLwQIMiu3hmMEjAqoo21ex1PvdE3240RE1H3t6ypVV7JKD/BGpD2LyNKQVvQncM/kWrStkUOrMeXcqoAmVL44xrW0lVTA/0sVaMKHLNDMNxqGOAEJb2GGBANlRSMB548xbeRX/NQhTvCvWrG4d4AZffUau3CmykUyG4jYNhU+q7BOTOMYPm/zkGeLc6D6IiumlsYI96eViS3ryUg6bwjazCnx+WbfJllIwPrF1ZFhJ0vBk7UUNEuZGUq9tFmmtRmCIcJOKiz9kwHwkD7fL6ejGtW8jboJi4D/is13FO+yLVIQY7A9goQcDKJTv4tThgzuEPGZ7uRg6vtCaFsyx0hD4tBQvV0MS4WKvIYtykTOSiS7fkMTxUwWM+APsH8bZJqIE33TiAkM
 T5B4fWBi
 xXlhFpQENU0AGCwu9gyaPc295p8tL6OFbqzm6IEYOSsuU8yUfUxbSeZ+y1RAFYT940dPHSLb9QUlocPqH6v/477lAwSglfmefnYp5oeaQEl14B8oTNzX3KbNd+59RExRBiVSGjGDHRmc/0yXvf3p5J8W6usWbeuTWxExwQs0XyVX6IzWcO37eFnTcM6aZ/+yqpebwnv4KvSQNBUCft2YJRKwa2opFFUhJQlnUS4JuRkYaWZTKUm0c34lhOzWNeeaOUxhIdD19TC4PLs4mnMTxRm1sQqKNX6h7IV6+KgUl0VDjFOXiWcKhV8VsFV83Bv2kwDyaFp280Th4EjWBp7N1k8p/YzVXT8E6SGuHI3vf0pRJaaFiEykL4EPVCtP8sqKqKJNIs+SkYbhReFVUwUYNCBqmgoEF4YBIGGQryHjg9ez6YmPmBCf9ThTUsy4t9P/0TsWMs7C9ZxUb+Esx0qkBC+hXeWB6rpKl96s83/qnGPwj+wPGQTbfD8WPIG/BjjuWq2JAGN+xE+mrZENS2rEwUDsFtPR21KIPCbmFs7OQzfSh0ApvsjUedFBuo1TYBiUMr7WBiHKeMsdZ3XpO/SR+xmjy3c3/TntzIKSaUz0Xhdmm9MOc7ukAc4pfsVutIe7919gbZQ7EbOHOX58wQxEk2dami/HciVt2rwZxADA4y1Ay1Als/gyTv8qrx1P0RrTa7e5DENSlY7rCHhZe5Hz8GYEiWdeKIxuz11BN9XQVIuoOBiVIh2fNkd6R6fhJypEzL4rR3G84Dd9rFpQQgFdSHiYinTPyk8pPEaEhEGGh6scXTn3a1T1ajlskFi/+a2opwEOm8qt3mDeCGfMNa4b2oFAymfdqxgqrz9CPYx8Xpp6U7N4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] userland: missing namespace owner permission check in
  userland_prepare_fork()
- [Medium] userland: missing namespace_install LSM check in
  userland_prepare_fork()
--

commit 705db8da85300ec68db1d2ce6e9711aa2f376bb1
Author: Jarkko Sakkinen <jarkko@kernel.org>

fork: Support CLONE_INTO_USERLAND in clone3()

This commit adds CLONE_INTO_USERLAND and struct clone_args.userland to
allow clone3() to spawn a child process directly into an initialized
userland's namespaces and root mount.

> diff --git a/kernel/userland.c b/kernel/userland.c
> index 739f6b98c1035..283b90869d2c6 100644
> --- a/kernel/userland.c
> +++ b/kernel/userland.c
> @@ -541,3 +542,135 @@ SYSCALL_DEFINE1(userland_open, unsigned int, flags)
> =20
>  	return fd;
>  }
> +

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

[Severity: Medium]
Should userland_prepare_fork() also invoke security_namespace_install() or
a matching LSM check for the target namespaces in userland->user_ns and
userland->ns?

Landlock enforces LANDLOCK_PERMISSION_NAMESPACE_USE via its
namespace_install hook when entering pre-opened namespaces with setns(),
and commit "security: Add userland LSM hooks" later in this series does
not wire Landlock up to security_userland_clone().  Without an LSM check
on those namespaces, a Landlock-sandboxed task holding a pre-opened
userland fd can use clone3(CLONE_INTO_USERLAND) to enter namespaces that
its Landlock domain denies.

> +	if (current_chrooted() && !ns_capable(current_user_ns(), CAP_SYS_CHROOT=
))
> +		return -EPERM;
> +
> +	pid_ns =3D userland->ns->pid_ns_for_children;
> +	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
> +		return -EXDEV;

[Severity: High]
Does userland_prepare_fork() need to verify that current either already
belongs to each namespace in userland->ns or holds CAP_SYS_ADMIN in that
namespace's owning user namespace?

In userland_share_nsfd(), a cgroup, IPC, UTS, network, or time namespace
owned by a more privileged user namespace (such as init_user_ns) can be
attached to userland->ns without CAP_SYS_ADMIN in ns->ops->owner(ns) as
long as the caller is currently in that namespace:

kernel/userland.c:userland_share_nsfd() {
    ...
	if (!ns_capable(c->user_ns, CAP_SYS_ADMIN))
		return -EPERM;
	if (!is_current_namespace(ns) &&
	    !ns_capable(ns->ops->owner(ns), CAP_SYS_ADMIN))
		return -EPERM;
    ...
}

Because userland_prepare_fork() only checks capabilities against
userland->user_ns and current_user_ns() before copy_namespaces() installs
userland->ns on the child, a process that shares a parent or host
namespace into a userland and later isolates itself with unshare() (for
example, unshare(CLONE_NEWNET)) can call clone3(CLONE_INTO_USERLAND) to
spawn a child back into the unisolated namespace without holding
CAP_SYS_ADMIN in its owning user namespace.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261122011809.2667=
684-1-jarkko@kernel.org?part=3D17

