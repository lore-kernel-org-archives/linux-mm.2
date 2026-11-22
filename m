Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC382606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 00:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=njZXaJlP
Received: by kanga.kvack.org (Postfix)
	id BED066B05B9; Sat, 21 Nov 2026 19:11:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9CB16B05BB; Sat, 21 Nov 2026 19:11:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F00F6B05BA; Sat, 21 Nov 2026 19:11:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 67B5F6B05B8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:11:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4863A7039
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:11:01 +0000 (UTC)
X-FDA: 85460824722.18.AE962F4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 119AE20003
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 00:10:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=njZXaJlP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795306260;
	b=b0XdCjWnWy+Hydrn1CfXuiCeLSeVwlq1VddGa8ChHo5tTjxIEikyqz503tVim8t4sqriF3
	WOK0fKU7Jt9H5isrWhcwkbE4QxTz3e+UCdoP76YW/G6IXdF6MdnLgCJdOhXeKTNvsZldHe
	vPBNF9+jEsTLHquUYsqGuH/c1X7l7qk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795306260;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BMccRjjG2ys5i2weNXAJcyIIyGs4aeLhA/js8bhyJM0=;
	b=X9m+g5LsHRF24hyY5C79VXFRwXjqDZGCjBHrX+wrnSvBLRqM0pRwICTSDFO+Frt9hRND1q
	NVEMTpYowbbjQAwlwSJH5nRPeEgl75GI6pp+Z+5iDW/Oy0bItPXYNRy8TVHQJcwxlmCE1H
	ojkAOx8SNI+mj+I76ko391Cir85Y/gE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=njZXaJlP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 04E9545743;
	Sun, 22 Nov 2026 00:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED021F000C0;
	Sun, 22 Nov 2026 00:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795306258;
	bh=BMccRjjG2ys5i2weNXAJcyIIyGs4aeLhA/js8bhyJM0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=njZXaJlPbB+uCzZhGzb/wGsjW0jRUhazaqn2mXXJY0ZxdvzcsE8ypNxPjJzPpM7+3
	 Fs5v/4N57wN3paBQSH0F5xdS9TOyGoP2E7Ed0k8AdNVIQYKzOAl6oEpf//X740eRjR
	 saPF/Vs8WUKcRKcCJli1+SCqPB3RjBs51jIKwi825NI5st62tm2bXzdk/4Td8Qf0m7
	 +C8xsgX/ipIIZsdG2i/293urQ3KvAzpkMXFUsLDIy9xWrh4Vo3rEc0AAbS9qjDfp1k
	 /7ZOXgvu3AwbElCxnhfmrQ2YGLA5tSz27EoCIfD4bceBofMbJ9eHApypawhJPTjCAh
	 I0vMN+P9RqFpQ==
Message-ID: <sashiko-outbox-227551@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v5 16/25] fork: Support CLONE_INTO_ROOTNS in
 clone3()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jarkko Sakkinen" <jarkko@kernel.org>
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, "Alexander
 Mikhalitsyn" <alex@amutable.com>, "Alexander Viro" <viro@zeniv.linux.org.uk>, "Andy
 Lutomirski" <luto@amacapital.net>, "Christian Brauner" <brauner@kernel.org>, "David
 Howells" <dhowells@redhat.com>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet" <corbet@lwn.net>, "Josef
 Bacik" <josef@toxicpanda.com>, "Kees Cook" <kees@kernel.org>, "Neal Gompa" <neal@gompa.dev>, "Paul
 Moore" <paul@paul-moore.com>, "Serge Hallyn" <sergeh@kernel.org>, "Zygmunt
 Krynicki" <zygmunt.krynicki@canonical.com>
In-Reply-To: <20261121000844.1863324-17-jarkko@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-17-jarkko@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 22 Nov 2026 00:10:57 +0000
X-Stat-Signature: c6taeidatft5detjacponjqw415uwrif
X-Rspamd-Queue-Id: 119AE20003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795306259-39033
X-HE-Meta: U2FsdGVkX1/u5wjrg/pgWu/JtRP35peo86cDUvYDhcclo0Qrk4e3hs3FPayN9g8tPdxv4Q1xxDLdWZSkI8mWUSHb2ocVWllQYi7GU8j9ilsMN1SYDDykVimm3mwXwQesfKqdYTmY9arB7Vc27HayWLgRguXHAaCKjBbgoRFIsQNR/S9gkIqZ40Qss8hbKFNxngyEorQM1uhByC9AjofBmjfulTnpDnsMRk1JT4bi0da2seIMHwHcZIBaidS7/HpWV2y3XUwpDzSddAVAPw0ysaq3vABswoXeGMstLHwaCLyqfbkR5fTB6JQwKIH31XbreTSrRAXWNEdB6/Z2T4StNClq+4LU4H9vWJQcO1QTNZ7opi3JiXFkPmeaYADtqYa2webG9+UT6PLtEfWkmVgB6z+M5boJ+Y6YoRKWFA8o0EIhuWlK1WnHdTcun7XOvzWaq4iAL75tLYp3cbpXnMqJbpYb0PAhXp3sdSDxcu9Tp8JYwplG8TZWfTGX9CpYI1Aw2nhURXfjXRBxQDRQzCU2ZBMCIPTZQPoAnTmMYU+b3jdlH2qjKMbcAhvG63et8+yNIJppAACWa2z8E/8EyrrsTRE92OCtQ2Nzz8x7ubS1dr2lT4DQgpMsQA4XllwU6+xN1jhxcr/2beFPHtSoPoT2jD5hNRekVT0RUwCUac28l1gmEqkbGuYJQT7cp9Fn9fqjPuOdw4dLMjTMRqkMvH6fKWyhw6grMQbakfkU1HTbnaoO82QxdbB4yXUsHFUCfwZIowt61ftlOVtJD4R6F/BrGNkBidKejIbJodP10GqdCzFFRfscW+wMYqrF1zsxjgLhwxlAuCWH0nNwnYJnDx5G8yaOdPzcZxlX0uUR2gUQmXCdCxfJs5tm8hMbf2FVJZiJOGMO2rNRqS0ybr1CZ5fUXZNXeAXWFrwChga2YUFN2c6u/TrRQVgHYysQZUXO6SMDziwQMYHsGwda10vE11Q
 bp0hr837
 vFKHFYqjOm7lEPBXSuD5UcJDD+LW4JLdrmI9Qv5QScOiVpBcocYKQosbwYdMNCkm2BVmurpq1yQ9xPsY1JSXDw2fgLXPRggRHBmOikpeaXuoZ1CbqCK/A3+0e0tFQ+Uk6cjFb6YzrX+m3QvSutO0x1CJthVkvBE0REvAoH1OgxsZv5hUKT7kw1cnyURdJkMkjpA+Zu+ANj5x/2PxeLQYne/+BmIpMr0zy4gkb7us3MRiW+2YD/P4Tuitw4iNTApYM4tioSF5/Vzb3MSm72Zp+Wqrq/zjONkiI71BpKzX6ybFP2RCY7F3Qkh3PEMaFgf1OTXTQwY6ZFRzehqFRXKTvNfaRx3UNC+nFAIW6Z9BHR1Sog4NYMQ4pX3uBUfw1nSBg6hTTvnBXvmvCJj/oPNWIdZEEAutFcSL/5++f/WPC2zXdixWq2qfqoQ2ey8uRz6ZVQ6N/x88SYSI0Y4HNNtGLhgn2ZWz5mWjq07ACfg1htUYVKEKr91Cp7esOMUFsODvKJnvb0rw9BP1ztjgl1dXfcIRuv/8WD1jqXsT81L1OhnV34k8SEJJydKuF6WkzIx/ROH71+xPOEwwjtjKFDtR+chKjNoykR7uFDDlTJCz534v7sHAFuifUUOhwP+E4JRFXNwer40sm2VD9chdeRW5YuE+zoR57A8rF8dw8lhWa6O2vsTNvWk0WjMU5j7FEgG8qepGuSEkh7sIAqx3WgLIKzmtEIblQFC32/aUGB1COV3NNSVFHT78cqOS8u/FEqf1A5k67Q4/OGBdnwpyeRRLAqCELYdC66hSoCmmMz6UIQ4hwMStXRj5kKeTMn7y2Y20Q3JbcxpaQbrsi/8sOzcqy5Y1aUi0nfUqEB+PpedjPD7cs0Yk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] rootns: leaf-only PIDNS_ADDING check returns -ENOMEM on dead
  ancestor pid_ns
--

commit 62f2477b1da0630c69ec1a2d1d679d2b7228b9f8
Author: Jarkko Sakkinen <jarkko@kernel.org>

fork: Support CLONE_INTO_ROOTNS in clone3()

This commit adds CLONE_INTO_ROOTNS and struct clone_args.rootns to allow
clone3() to spawn a child process directly into an initialized or running
root namespace.

> diff --git a/kernel/rootns.c b/kernel/rootns.c
> index 5ae975604571f..6fb49c20cc2df 100644
> --- a/kernel/rootns.c
> +++ b/kernel/rootns.c
> @@ -36,6 +36,7 @@
>  #include <uapi/linux/wait.h>
>  #include <linux/file.h>
>  #include <linux/fs.h>
> +#include <linux/fs_struct.h>
>  #include <linux/anon_inodes.h>
>  #include <linux/rootns.h>
>  #include <linux/sched/signal.h>
> @@ -426,3 +427,142 @@ SYSCALL_DEFINE1(rootns, unsigned int, flags)
>  	return fd;
>  }
> =20
[ ... ]
> +int rootns_prepare_fork(struct kernel_clone_args *args)
> +{
> +	struct file *file __free(fput) =3D fget(args->rootns_fd);
> +	struct path root __free(path_put) =3D {};
> +	struct pid_namespace *pid_ns;
> +	bool bootstrapping =3D false;
> +	struct rootns *rootns;
> +	int ret;
> +
> +	if (!file)
> +		return -EBADF;
> +	if (!is_rootns_file(file))
> +		return -EINVAL;
> +
> +	rootns =3D file->private_data;
> +	if (!ns_capable(rootns->user_ns, CAP_SYS_ADMIN) ||
> +	    !ns_capable(rootns->user_ns, CAP_SYS_CHROOT))
> +		return -EPERM;
> +	if (current_chrooted() && !ns_capable(current_user_ns(), CAP_SYS_CHROOT=
))
> +		return -EPERM;
> +
> +	pid_ns =3D rootns->ns->pid_ns_for_children;
> +	if (!pidns_is_ancestor(pid_ns, task_active_pid_ns(current)))
> +		return -EXDEV;
> +
> +	ret =3D mnt_ns_get_root(rootns->ns->mnt_ns, &root);
> +	if (ret)
> +		return ret;
> +
> +	for (;;) {
> +		bool wait =3D false;
> +
> +		scoped_guard(spinlock, &rootns->lock) {
> +			switch (rootns->state) {
> +			case ROOTNS_INIT:
> +				if (!(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
> +					return -ESRCH;
> +				if (READ_ONCE(pid_ns->child_reaper))
> +					return -EBUSY;
> +				WRITE_ONCE(rootns->state, ROOTNS_FORKING);
> +				bootstrapping =3D true;
> +				break;
> +			case ROOTNS_FORKING:
> +				wait =3D true;
> +				break;
> +			case ROOTNS_RUNNING:
> +				if (!(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
> +					return -ESRCH;
> +				break;
> +			case ROOTNS_DEAD:
> +				return -ESRCH;
> +			}
> +		}
> +		if (!wait)
> +			break;
> +
> +		ret =3D wait_event_killable(rootns->waitq,
> +					  READ_ONCE(rootns->state) !=3D ROOTNS_FORKING);
> +		if (ret)
> +			return ret;
> +	}
> +
> +	args->rootns_file =3D no_free_ptr(file);
> +	args->rootns =3D rootns;
> +	args->rootns_bootstrapping =3D bootstrapping;
> +	return 0;
> +}
> +
> +int rootns_finish_fork(struct kernel_clone_args *args, struct task_struc=
t *p)
> +{
> +	struct file *file __free(fput) =3D args->rootns_file;
> +	struct rootns *rootns =3D args->rootns;
> +	struct pid_namespace *pid_ns =3D rootns->ns->pid_ns_for_children;
> +	int ret;
> +
> +	args->rootns_file =3D NULL;
> +	args->rootns =3D NULL;
> +	if (!IS_ERR(p)) {
> +		if (args->rootns_bootstrapping)
> +			wake_up_all(&rootns->waitq);
> +		if (current->nsproxy->time_ns !=3D rootns->ns->time_ns)
> +			timens_commit(p, rootns->ns->time_ns);
> +		return 0;
> +	}
> +
> +	ret =3D PTR_ERR(p);
> +	if (args->rootns_bootstrapping) {
> +		scoped_guard(spinlock, &rootns->lock) {
> +			if (rootns->state =3D=3D ROOTNS_FORKING)
> +				WRITE_ONCE(rootns->state, ROOTNS_INIT);
> +		}
> +		wake_up_all(&rootns->waitq);
> +		if (ret =3D=3D -EINVAL && !args->set_tid_size &&
> +		    (READ_ONCE(pid_ns->child_reaper) ||
> +		     (READ_ONCE(pid_ns->pid_allocated) & ~PIDNS_ADDING)))
> +			ret =3D -EBUSY;
> +	}
> +	if ((ret =3D=3D -ENOMEM || ret =3D=3D -EBUSY) &&
> +	    !(READ_ONCE(pid_ns->pid_allocated) & PIDNS_ADDING))
> +		return -ESRCH;
> +
> +	return ret;
> +}

[Severity: Medium]
Can clone3(CLONE_INTO_ROOTNS) return -ENOMEM instead of -ESRCH when an
intermediate ancestor PID namespace is tearing down?

rootns_prepare_fork() allows callers in any ancestor active PID namespace,
but both rootns_prepare_fork() and rootns_finish_fork() only check
PIDNS_ADDING on the leaf pid_ns.  If the target rootns was created inside
an intermediate PID namespace whose init exits while the leaf pid_ns still
has PIDNS_ADDING set (for example, when the nested rootns has not been
bootstrapped yet), rootns_prepare_fork() proceeds into copy_process(),
alloc_pid() fails with -ENOMEM when it walks the ancestor PID namespaces,
and rootns_finish_fork() leaves the error as -ENOMEM.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121000844.1863=
324-1-jarkko@kernel.org?part=3D16

