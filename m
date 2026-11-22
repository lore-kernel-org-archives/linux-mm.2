Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95047606A32A
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 02:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kjKtmid+
Received: by kanga.kvack.org (Postfix)
	id A5DCF6B05BB; Sat, 21 Nov 2026 21:14:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0EA46B05BC; Sat, 21 Nov 2026 21:14:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FE1A6B05BD; Sat, 21 Nov 2026 21:14:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66DD06B05BB
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:14:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9C8816061D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:05 +0000 (UTC)
X-FDA: 85461134850.18.3C81D4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4ED031C0004
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 02:14:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjKtmid+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795313644;
	b=j+LqmyCiMC5GZE7AQgPJSMKKfhm5WzZ30tyufMHTQ+snrpir25frhREkoqbIXdppEaJJCZ
	FKWpL0Z82dErR2CgcSYaPYuLL8NAm5nUWUTg1Ky9N/KMhM3jp18aYnlma3Zu4GPI1YrGY6
	72BeJKKqATYHByRaOrH3qceH1qrSX5M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795313644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDB1yuO+g70nypwHDdydP9Ie+9yV7h/g1apo66kxJw8=;
	b=l9Javm+iqng2Si+105wduglJL9E1S0Dm+N31QBw5HZZE2FnXDCwrtIaxDafZHYtfppH0eL
	rN/MjS6aVbZ96GCatG6gzxZQ8KxjmiPn5kuNbRlqMrSpORiddqRS7vUpRG+3CqnoNeVGHv
	u17ZWSI1xEeTnnX+ZD0eIVotOt+7Ad0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kjKtmid+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE9656189B;
	Sun, 22 Nov 2026 02:14:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FAC1F000C6;
	Sun, 22 Nov 2026 02:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795313643;
	bh=YDB1yuO+g70nypwHDdydP9Ie+9yV7h/g1apo66kxJw8=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=kjKtmid+tgBBfQEZ5DMw+UnpV1e7mQ8R6y3MnkUVkjR/LrEQY+y0NkkYdYSM6D4k9
	 uFKZk7MWvBM16LOMVi72HP3JZCuZTAUV4KhIaDeVYv6BbL1q1WmlSEm/iMO7wKzDDd
	 rWdepeysG4QnnTjfkfF6yVoS7GOhL6+m2aWP12KNP3fpmk+FQekI/VY2eJDsp521ZN
	 RzVka1oDb+iFY/TgEnrBU9aFG8Pqdpkg7WpCSosqMYsQJ7QBH3sKdZ4Vd3ZgX+muds
	 fSrG3BbLpjmgMR8vBtAM+67/W7IkN33Ia23qrDyM9LwYue7dDnoFoGYPZFf9rypGHl
	 m1+IuLrc4WC5Q==
Content-Type: multipart/mixed; boundary="===============7190256002040251777=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <e49d1c291f255be48f078b39982b5f2f1b28ad1f0398715c157cff4846a4aa49@mail.kernel.org>
In-Reply-To: <20261122011809.2667684-19-jarkko@kernel.org>
References: <20261122011809.2667684-19-jarkko@kernel.org>
Subject: Re: [RFC PATCH v6 18/26] fs: Support FSCONFIG_SET_USERLAND in fsconfig()
From: bot+bpf-ci@kernel.org
To: jarkko@kernel.org,linux-fsdevel@vger.kernel.org
Cc: jarkko@kernel.org,bpf@vger.kernel.org,containers@lists.linux.dev,linux-api@vger.kernel.org,linux-arch@vger.kernel.org,linux-doc@vger.kernel.org,linux-kernel@vger.kernel.org,linux-kselftest@vger.kernel.org,linux-mm@kvack.org,linux-security-module@vger.kernel.org,aleksa@amutable.com,alex@amutable.com,viro@zeniv.linux.org.uk,luto@amacapital.net,arnd@arndb.de,brauner@kernel.org,dhowells@redhat.com,giuseppe@scrivano.org,hughd@google.com,jack@suse.cz,jlayton@kernel.org,corbet@lwn.net,josef@toxicpanda.com,kees@kernel.org,kpsingh@kernel.org,lennart@poettering.net,neal@gompa.dev,oleg@redhat.com,paul@paul-moore.com,ptikhomirov@virtuozzo.com,sergeh@kernel.org,skhan@linuxfoundation.org,zygmunt.krynicki@canonical.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason@kernel.org,ihor.solodrai@linux.dev
Date: Sun, 22 Nov 2026 02:13:59 +0000 (UTC)
X-Stat-Signature: ps3zatz67rq3nhyg3hr6nsi7iwz3xhqe
X-Rspam-User:
X-Rspamd-Queue-Id: 4ED031C0004
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795313644-835168
X-HE-Meta: U2FsdGVkX1/lAgd/oCR9MYqAZZAKa/9t/wA2gSQkXiW7bvDDagMNntXkwFIZn5SJwBbmwqp3RKR1rTMonTDEJsgNfto7U5fBi6Rv7hyjnrkzLbM6LzufMwAJO1E3xnkKN/b0kAOvQdO7vbPsQsZGavN858j69waZB7YS1FC+kHrQw52YkiE4KkbFM3M4orx4riVHXUy4Ga+OsDwsWwRkwGIiroalf++AMHBjKpRGmulmf4HmQtRpDjfpDfFIIZka9oVUornZTXHAiidsL4+Ub3rhGUwi+p29WI02y8DadHM7VF4y+x/I3+Tuc7NJ7Nw4O2UaIKk8J/g42w7r1copJCbrvSf/2zbkWMf5B+r2mqlF7OPimiR6LB+rGVY81TfOLOJ57cpO+TIQfIdioQxrDMYt3app9ukhhultHe0jL7XPolaZ669em2Jke/nmMLQSUiHm7wS0V/huNVLCxoLT2qXdSRQg5dFnTxdoUMZ50K0X0BxhZfbJjze07XC8HyxNXV4F9swk+Tp31+1X8SXFmZFW26ru1/noj4tZsGAc8jmJ5kxdKDs+NNdv3wvCIDr4uOELt+36FERodpw/WKwJoGm8ycZCzjK3GNBvLgSdkHMsZg04TdQiZEcboOnH3V7XZuY5W274QUpdAqPuj3gmh5gUWf4KWtVDv5ssvuT2KEhTOaKvR5VaBAjSk3fT9CVkl5u7ZwDmK2Em3tt4NyW/XSJdNpHDA1AGtk4TNFRTSah+ipszKVk6bPTjsZGDJcXKWh2hebWLI0MrcCVlxeQvFLG9400hTEjCsuL3KlBSjd0ssvyMituig46dz/ZIsJpuKjcmf9HKDeFSOsAYAkek5Ljl7s7HeVwBmaDSqJkrjp6aYVRm+nztOy6mbiQAPdoDbqEt0z/YCJK2wE0R5w4npwXIc6qrHpVYw59K2kNWLPyf2E0o0P2eCmYtPvvNeUzImZ7hNEIGHT1AOtdPJzB
 rT9tUX2q
 BLaj7n+CJuO0VjuKP+a9AbESunkm4868mm5E+lbAngMFsgnpXPZmbpCbMCi5BMFq4zHY+R7jkyPIK1btB9tLZM3x5LZp4BDoZokPpQaW+WxaEcIkGoSPQNypZNVEQBVtG6wAsjj4c66gIQ4AL1Du1OLkK4H7DQvpHvSOHjtyizL9wdjuiGkrh+5ZkEJdWxBZvkK28G2InaQTjNdeTjcxOtQT9Wh1TZczTJ7ZfUSUWsB7jL0Tl8/J1za5OTwTNZKSCUH7KLq+j7ldyo2x6W9ykzqlrWRycNoKoaenJCB/ZkOJ0tvqxisrm301us8nmVejjwN1ooYVHvHcDWilBm9bOMKaCovp63dTF7j8OtWECHpN4rM4B9G66hNJyEdceWEmFfoeFiuqLTJJRPvaiVfYtSzrj0V5xWUsVfEhWzFmnB827LHkyR8SqQC4ym8ltiCh8gXcbortm/fabM+PcgMnNku1Wy/X/uiNjNiTHPUDVw7SXFONB/2Uiscx9HHjALJ5067GdbHrZtQDcBLBwJNZKeMyM+EmIivS6mjazm+3yobdULWe5MjO+dSLPuehKzmjTnVuVFADauQ9iCdKARkhhU7FXo/gD1m8SC+XBqxxHzjzvFm5SaMC7emsICyMwHRMOWN+najM3GImnRxfNs1gVcNJdsOzsjljuSqy6haUiXtNZESTFjV6iJaSxg4zL7gFvEJTd2+XpLwNrvH6RlQgGefILLgzyxBCJrjZ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7190256002040251777==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> fs: Support FSCONFIG_SET_USERLAND in fsconfig()

TL;DR:
- fsmount() may call may_mount() needlessly for userland-bound contexts,
  possibly causing spurious LSM denial logs and BPF-LSM hooks
- mount_api.rst may need updating for ->set_userland()

> diff --git a/fs/namespace.c b/fs/namespace.c
> --- a/fs/namespace.c
> +++ b/fs/namespace.c

[ ... ]

> @@ -4705,16 +4705,19 @@ SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags,
>  	struct vfsmount *new_mnt;
>  	struct mount *mnt;
>  	unsigned int mnt_flags = 0;
> +	bool priv;
>  	long ret;
>  
>  	if ((flags & ~(FSMOUNT_CLOEXEC | FSMOUNT_NAMESPACE)) != 0)
>  		return -EINVAL;
>  
> +	priv = may_mount();
>  	if ((flags & FSMOUNT_NAMESPACE) &&
>  	    !ns_capable(current_user_ns(), CAP_SYS_ADMIN))
>  		return -EPERM;

Previously may_mount() was only called when FSMOUNT_NAMESPACE was clear.
Now it runs on every fsmount() call, but priv is only read later in:

    } else if (!(flags & FSMOUNT_NAMESPACE) && !priv) {

so the result is discarded for FSMOUNT_NAMESPACE callers and for every
userland-bound context.

may_mount() is an audited ns_capable() that goes through security_capable()
and sets PF_SUPERPRIV on success.  Can an external manager under an LSM
policy that denies capability sys_admin but allows the user namespace check
now trigger an LSM denial log entry and BPF-LSM capable programs on each
userland-bound fsmount(), for a privilege the call does not need?

The other conditional callers in this file only evaluate it when the result
matters:

    if ((flags & OPEN_TREE_CLONE) && !may_mount())
    if (!(flags & MOVE_MOUNT_T_MNTNS) && !may_mount())

Could may_mount() be called only on the unbound, non-FSMOUNT_NAMESPACE path
once fc->userland_bound is known?

[ ... ]

> diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
> --- a/include/linux/fs_context.h
> +++ b/include/linux/fs_context.h

[ ... ]

>  struct fs_context_operations {
> @@ -117,6 +122,7 @@ struct fs_context_operations {
>  	int (*dup)(struct fs_context *fc, struct fs_context *src_fc);
>  	int (*parse_param)(struct fs_context *fc, struct fs_parameter *param);
>  	int (*parse_monolithic)(struct fs_context *fc, void *data);
> +	int (*set_userland)(struct fs_context *fc, struct userland *userland);
>  	int (*get_tree)(struct fs_context *fc);
>  	int (*reconfigure)(struct fs_context *fc);
>  };

Documentation/filesystems/mount_api.rst keeps its own copy of struct
fs_context_operations and documents each method.  Should it be updated for
->set_userland(), the new userland_bound and userland_mnt_id fields and the
new fs_context_phase states?

Filesystem implementers currently have to read fsconfig_set_userland() in
fs/fsopen.c to learn the contract:

- it is called after ->init_fs_context() has run with fc->user_ns,
  fc->net_ns and fc->cred already rebound;
- it may rebind fc->user_ns, but must leave it equal to the userland's user
  namespace, or the bind fails with -EOPNOTSUPP;
- the context moves to FS_CONTEXT_FAILED on error.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/44972669664
--===============7190256002040251777==--

