Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E07D6CD5BC7
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:19:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B86A8E0003; Thu, 13 Nov 2025 06:19:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FCA8E0002; Thu, 13 Nov 2025 06:19:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A5A08E0003; Thu, 13 Nov 2025 06:19:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC2998E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:19:47 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 944CA5BC87
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:19:47 +0000 (UTC)
X-FDA: 84105338814.04.CE19E33
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E63F40005
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:19:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tEx0PXpS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LOUAPU0D;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TPAANJvU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IMDALd4J;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763032785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lczhD1MzObRMKndPkZG3oPhNpz/T85+A7Y0PvHv3zA4=;
	b=4cBeO/r2dMbVi3M7H1Zx82HAsFnaMiduCcZVW10GEFapkByCtoCwBK7fsu6gHdnEXiuFLJ
	ZuMn1+1cdQnyPQGNys6dW00WLMUu8ZkAlYydBhrCmgksCjKb0RUr/8F1Dn7ohwewdPHzcv
	9bUeq/bEIUMs1sVbTYZGh7RPetjESn4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763032785; a=rsa-sha256;
	cv=none;
	b=SD+y0qzpbTPzBOJJjsvoJlGTuERhtDAq/N4XJWhWBXCzzsFgKnA2gpgT+qgChVVl1rBh1y
	H4g4TOVjnCQB2NoN4+6EQXtabJDEuwztEl46NKELZ26zVj8x/u7HRacz+HRcsTGfXm+SlN
	Smsv/moQKwmhXJrLyZpv9BIkLqLhSRc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tEx0PXpS;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LOUAPU0D;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TPAANJvU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IMDALd4J;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B45DC21281;
	Thu, 13 Nov 2025 11:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763032782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lczhD1MzObRMKndPkZG3oPhNpz/T85+A7Y0PvHv3zA4=;
	b=tEx0PXpSR9fC2UvG0u7MJFp2BSlhdeqm6tfjJPlZS4pzGQmOwabgT+ii7BsgRYsefYOMF3
	VvsJYx6JmgiNnIkc2NCbUzK9WMs4Iesgm99E+qFwo8H8q29+lEmIo9rS5V2MjR+2UAS7Qp
	XFnzrWjacC8RlMPSp7qTqHvuw+qVCws=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763032782;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lczhD1MzObRMKndPkZG3oPhNpz/T85+A7Y0PvHv3zA4=;
	b=LOUAPU0DI5ldL7amV9RP5y5ZRcrOsqlJWe+yGqm+w1F5fGBdUOw3+MjMsiQwLq6RLZlsah
	z1b+3BWuTShjlLBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763032780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lczhD1MzObRMKndPkZG3oPhNpz/T85+A7Y0PvHv3zA4=;
	b=TPAANJvULtvZbKY9kTlFDj3fHaqwcTQ7QSHepORPj1SmGNXAVQl+h4cThVAzOE6Yl7BCLK
	P+mNsKLJnjLZvTwsl3qRAtpBElJ625a6hag5mPaMbQZLS4fmnximef6W0ci53Jrf6gupH/
	2n45l6UZt9TFhva3h8X/wtCXAWukFSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763032780;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lczhD1MzObRMKndPkZG3oPhNpz/T85+A7Y0PvHv3zA4=;
	b=IMDALd4JeMlPI9Mxv0/hWb4imPPdPuOJsIg/iIEqAN8lny7MqpgtZO9x5EjyCnO6vYkjJ5
	0uFVDgatEsam+WBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A65493EA61;
	Thu, 13 Nov 2025 11:19:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2zOKKMy+FWnVYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 13 Nov 2025 11:19:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 63A30A0976; Thu, 13 Nov 2025 12:19:40 +0100 (CET)
Date: Thu, 13 Nov 2025 12:19:40 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, bpf@vger.kernel.org, bsegall@google.com, david@redhat.com, 
	dietmar.eggemann@arm.com, jack@suse.cz, jsavitz@redhat.com, juri.lelli@redhat.com, 
	kartikey406@gmail.com, kees@kernel.org, liam.howlett@oracle.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, 
	mingo@redhat.com, mjguzik@gmail.com, oleg@redhat.com, paul@paul-moore.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	vincent.guittot@linaro.org, viro@zeniv.linux.org.uk, vschneid@redhat.com, 
	syzbot+0a8655a80e189278487e@syzkaller.appspotmail.com
Subject: Re: [PATCH] nsproxy: fix free_nsproxy() and simplify
 create_new_namespaces()
Message-ID: <3yjawi3c72ieiss7ivefckuua55e2yvo55z4m4ykp2pzw2snpa@ym34e3d7cnoi>
References: <691360cc.a70a0220.22f260.013e.GAE@google.com>
 <20251111-sakralbau-guthaben-7dcc277d337f@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251111-sakralbau-guthaben-7dcc277d337f@brauner>
X-Rspamd-Action: no action
X-Stat-Signature: zw4rrj3y15o7wyfz5j7q1s6c71bnmndj
X-Rspam-User: 
X-Rspamd-Queue-Id: 3E63F40005
X-Rspamd-Server: rspam10
X-HE-Tag: 1763032784-16013
X-HE-Meta: U2FsdGVkX18v7NCOaMSwtVNk2eGPL+oxqBYzPSY+XMWKyxkuP9+Zxs1AP6j8Yn5K15Cl04nUx2Km0iw5w5FcOv6XHkSGUOxHRKdrIh1wsEUqMGVl8ZXVf94bA4vSh3YiDzn76KuwMPoqxm3278t5Pol6xhwN0ZIbqm1vvRx70Lzh9zWy/+8Y+/qExIFA0krs2deH2s45qETxMTQhLdG/OyuJ028Rd9L486dApgt0rCNKsBQo2Z+ezoqBxVYmVVZf0FLUCKcb1T0vgUBW24/TsRYPBdmsbfYBafaDZNCH26uaH7AiyzpD7/lTeHfN4V3elZXbIp6NqwJzZFAp7vnhM2eEn1Xs0BOXoWZsYsR6EtWtP5YnVayJWs0yIUDAu4N52o8f1cOdyCGiB/EtHnV9Ir4Qo7R9EdFH1YWOvWR+35sKzYYUdlMorD69t4L+U8GDDHm/RduFJia0TsFxzy6SmL/sMQonNQzQ7igc1hwH6fFrn2Lw0csuE8IRCPWoRH9whC4/WcScZtd+q91vYOK/szPHaJBftC2X1+K9Hjc2NaFJ65LFjmmlXiqOa6McbEIZ3SoOXXdN2dwCgTiiuTKwlMES5DCdRPq8049GMRyUz3r1TAJr9TJxHoQzPkTP3PgpRji5L3tczNvqG005N47S814dzbe5YoAY0wlq0X7kPEe5cHwBnvVZu+z3Ib2h12ZPCh8aIOp610rc4jEvcGokF/2/TFOOvVMbzecQzvs1eSqzI55DxCMji0kjwKETVZvRow3QHfHmSamLrIA7pnOagC1CB7MZv/YKaABMV2Dw2VwaekycWvuS0i28I21LsP4kDhZHkOVrAVgm7RwHXH4ExR0YFFa1XZaPs4fqmipVvwjGQgjjaQRns0wuKs1p4pfSKqYRPFsCHrwVWzF2EFzwy4Q9jWuW+LdzRJgXmMeXsIMNfC2EB/G/hIlefbUqLnoU+syiWKsFT7mJ2T3lVDn
 +pwEkeAk
 5OKrI5x8DAxgcYHK/1cs9bKrWgX5av49fN90QuzuLkS+egNljvQlCV4hS4vg6eJ/+rTju5XDQUnUc7esyZCZekpiOGbYx6q5i25mqBs1iB0Rh6QOhmcQpBs3QFqXa9G72ps540jd9itJUnJ+sRoPp1Tt/+ypJZ+cgdGyVO5WV6IeWfzeS9shRx+pSn8upIIgVFaVaspCYlIzNuuZ1qspHEECXc2FS7heLp4naGgz2j54K57H0WdLjXWKfSA3FL9aWq6CATx+UV+Nz2YqxNPqNx0M3DQBnFvQjE1ZkgDuQs48Kg93E2TH2/0lcTLa8UnbnenzWjtAOXCWR4tt4QaVmDVQUGHqtqrxnr+eYQIdb26ThZ5g3iPx3VI3Rbhy2IrSjXYV+QuQ+jLj/e6NEz+kIP5B45xdqghHlB1bBaYpzCElhl4EExjfu0TMFB3Ekepe8ujOdbiRkP0VVHuxdwmH1P2HnsnustNZqLQHwrhbo9DcrAAGRGd9gNht57tUGKdYNKGXrk6TdH6Y+G53q8zlqZot2j+bELcMSzG2Z0JAE5lGvSpD8KfxA0N7kkeER+YRZakGjBv5VBH7NX6Kx2nV8zE17S09+z5GpmqbmQ+qVhAvkkor1ipUD6ZJ8YonKWIZI08N6OlFLOpcrWQ4a7Gq7Zj73OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 11-11-25 22:29:44, Christian Brauner wrote:
> Make it possible to handle NULL being passed to the reference count
> helpers instead of forcing the caller to handle this. Afterwards we can
> nicely allow a cleanup guard to handle nsproxy freeing.
> 
> Active reference count handling is not done in nsproxy_free() but rather
> in free_nsproxy() as nsproxy_free() is also called from setns() failure
> paths where a new nsproxy has been prepared but has not been marked as
> active via switch_task_namespaces().
> 
> Fixes: 3c9820d5c64a ("ns: add active reference count")
> Reported-by: syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com
> Reported-by: syzbot+0a8655a80e189278487e@syzkaller.appspotmail.com
> Link: https://lore.kernel.org/690bfb9e.050a0220.2e3c35.0013.GAE@google.com
> Signed-off-by: Christian Brauner <brauner@kernel.org>

I believe having free_nsproxy() and nsproxy_free() functions with
the same signature and slightly different semantics is making things too
easy to get wrong. Maybe call free_nsproxy() say deactivate_nsproxy()?

Otherwise the patch looks correct to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/ns_common.h |  11 ++--
>  kernel/nsproxy.c          | 107 +++++++++++++++-----------------------
>  2 files changed, 48 insertions(+), 70 deletions(-)
> 
> diff --git a/include/linux/ns_common.h b/include/linux/ns_common.h
> index 136f6a322e53..825f5865bfc5 100644
> --- a/include/linux/ns_common.h
> +++ b/include/linux/ns_common.h
> @@ -114,11 +114,14 @@ static __always_inline __must_check bool __ns_ref_dec_and_lock(struct ns_common
>  }
>  
>  #define ns_ref_read(__ns) __ns_ref_read(to_ns_common((__ns)))
> -#define ns_ref_inc(__ns) __ns_ref_inc(to_ns_common((__ns)))
> -#define ns_ref_get(__ns) __ns_ref_get(to_ns_common((__ns)))
> -#define ns_ref_put(__ns) __ns_ref_put(to_ns_common((__ns)))
> +#define ns_ref_inc(__ns) \
> +	do { if (__ns) __ns_ref_inc(to_ns_common((__ns))); } while (0)
> +#define ns_ref_get(__ns) \
> +	((__ns) ? __ns_ref_get(to_ns_common((__ns))) : false)
> +#define ns_ref_put(__ns) \
> +	((__ns) ? __ns_ref_put(to_ns_common((__ns))) : false)
>  #define ns_ref_put_and_lock(__ns, __ns_lock) \
> -	__ns_ref_dec_and_lock(to_ns_common((__ns)), __ns_lock)
> +	((__ns) ? __ns_ref_dec_and_lock(to_ns_common((__ns)), __ns_lock) : false)
>  
>  #define ns_ref_active_read(__ns) \
>  	((__ns) ? __ns_ref_active_read(to_ns_common(__ns)) : 0)
> diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> index 94c2cfe0afa1..2c94452dc793 100644
> --- a/kernel/nsproxy.c
> +++ b/kernel/nsproxy.c
> @@ -60,6 +60,27 @@ static inline struct nsproxy *create_nsproxy(void)
>  	return nsproxy;
>  }
>  
> +static inline void nsproxy_free(struct nsproxy *ns)
> +{
> +	put_mnt_ns(ns->mnt_ns);
> +	put_uts_ns(ns->uts_ns);
> +	put_ipc_ns(ns->ipc_ns);
> +	put_pid_ns(ns->pid_ns_for_children);
> +	put_time_ns(ns->time_ns);
> +	put_time_ns(ns->time_ns_for_children);
> +	put_cgroup_ns(ns->cgroup_ns);
> +	put_net(ns->net_ns);
> +	kmem_cache_free(nsproxy_cachep, ns);
> +}
> +
> +DEFINE_FREE(nsproxy_free, struct nsproxy *, if (_T) nsproxy_free(_T))
> +
> +void free_nsproxy(struct nsproxy *ns)
> +{
> +	nsproxy_ns_active_put(ns);
> +	nsproxy_free(ns);
> +}
> +
>  /*
>   * Create new nsproxy and all of its the associated namespaces.
>   * Return the newly created nsproxy.  Do not attach this to the task,
> @@ -69,76 +90,45 @@ static struct nsproxy *create_new_namespaces(u64 flags,
>  	struct task_struct *tsk, struct user_namespace *user_ns,
>  	struct fs_struct *new_fs)
>  {
> -	struct nsproxy *new_nsp;
> -	int err;
> +	struct nsproxy *new_nsp __free(nsproxy_free) = NULL;
>  
>  	new_nsp = create_nsproxy();
>  	if (!new_nsp)
>  		return ERR_PTR(-ENOMEM);
>  
>  	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, user_ns, new_fs);
> -	if (IS_ERR(new_nsp->mnt_ns)) {
> -		err = PTR_ERR(new_nsp->mnt_ns);
> -		goto out_ns;
> -	}
> +	if (IS_ERR(new_nsp->mnt_ns))
> +		return ERR_CAST(new_nsp->mnt_ns);
>  
>  	new_nsp->uts_ns = copy_utsname(flags, user_ns, tsk->nsproxy->uts_ns);
> -	if (IS_ERR(new_nsp->uts_ns)) {
> -		err = PTR_ERR(new_nsp->uts_ns);
> -		goto out_uts;
> -	}
> +	if (IS_ERR(new_nsp->uts_ns))
> +		return ERR_CAST(new_nsp->uts_ns);
>  
>  	new_nsp->ipc_ns = copy_ipcs(flags, user_ns, tsk->nsproxy->ipc_ns);
> -	if (IS_ERR(new_nsp->ipc_ns)) {
> -		err = PTR_ERR(new_nsp->ipc_ns);
> -		goto out_ipc;
> -	}
> +	if (IS_ERR(new_nsp->ipc_ns))
> +		return ERR_CAST(new_nsp->ipc_ns);
>  
> -	new_nsp->pid_ns_for_children =
> -		copy_pid_ns(flags, user_ns, tsk->nsproxy->pid_ns_for_children);
> -	if (IS_ERR(new_nsp->pid_ns_for_children)) {
> -		err = PTR_ERR(new_nsp->pid_ns_for_children);
> -		goto out_pid;
> -	}
> +	new_nsp->pid_ns_for_children = copy_pid_ns(flags, user_ns,
> +						   tsk->nsproxy->pid_ns_for_children);
> +	if (IS_ERR(new_nsp->pid_ns_for_children))
> +		return ERR_CAST(new_nsp->pid_ns_for_children);
>  
>  	new_nsp->cgroup_ns = copy_cgroup_ns(flags, user_ns,
>  					    tsk->nsproxy->cgroup_ns);
> -	if (IS_ERR(new_nsp->cgroup_ns)) {
> -		err = PTR_ERR(new_nsp->cgroup_ns);
> -		goto out_cgroup;
> -	}
> +	if (IS_ERR(new_nsp->cgroup_ns))
> +		return ERR_CAST(new_nsp->cgroup_ns);
>  
>  	new_nsp->net_ns = copy_net_ns(flags, user_ns, tsk->nsproxy->net_ns);
> -	if (IS_ERR(new_nsp->net_ns)) {
> -		err = PTR_ERR(new_nsp->net_ns);
> -		goto out_net;
> -	}
> +	if (IS_ERR(new_nsp->net_ns))
> +		return ERR_CAST(new_nsp->net_ns);
>  
>  	new_nsp->time_ns_for_children = copy_time_ns(flags, user_ns,
> -					tsk->nsproxy->time_ns_for_children);
> -	if (IS_ERR(new_nsp->time_ns_for_children)) {
> -		err = PTR_ERR(new_nsp->time_ns_for_children);
> -		goto out_time;
> -	}
> +						     tsk->nsproxy->time_ns_for_children);
> +	if (IS_ERR(new_nsp->time_ns_for_children))
> +		return ERR_CAST(new_nsp->time_ns_for_children);
>  	new_nsp->time_ns = get_time_ns(tsk->nsproxy->time_ns);
>  
> -	return new_nsp;
> -
> -out_time:
> -	put_net(new_nsp->net_ns);
> -out_net:
> -	put_cgroup_ns(new_nsp->cgroup_ns);
> -out_cgroup:
> -	put_pid_ns(new_nsp->pid_ns_for_children);
> -out_pid:
> -	put_ipc_ns(new_nsp->ipc_ns);
> -out_ipc:
> -	put_uts_ns(new_nsp->uts_ns);
> -out_uts:
> -	put_mnt_ns(new_nsp->mnt_ns);
> -out_ns:
> -	kmem_cache_free(nsproxy_cachep, new_nsp);
> -	return ERR_PTR(err);
> +	return no_free_ptr(new_nsp);
>  }
>  
>  /*
> @@ -185,21 +175,6 @@ int copy_namespaces(u64 flags, struct task_struct *tsk)
>  	return 0;
>  }
>  
> -void free_nsproxy(struct nsproxy *ns)
> -{
> -	nsproxy_ns_active_put(ns);
> -
> -	put_mnt_ns(ns->mnt_ns);
> -	put_uts_ns(ns->uts_ns);
> -	put_ipc_ns(ns->ipc_ns);
> -	put_pid_ns(ns->pid_ns_for_children);
> -	put_time_ns(ns->time_ns);
> -	put_time_ns(ns->time_ns_for_children);
> -	put_cgroup_ns(ns->cgroup_ns);
> -	put_net(ns->net_ns);
> -	kmem_cache_free(nsproxy_cachep, ns);
> -}
> -
>  /*
>   * Called from unshare. Unshare all the namespaces part of nsproxy.
>   * On success, returns the new nsproxy.
> @@ -338,7 +313,7 @@ static void put_nsset(struct nsset *nsset)
>  	if (nsset->fs && (flags & CLONE_NEWNS) && (flags & ~CLONE_NEWNS))
>  		free_fs_struct(nsset->fs);
>  	if (nsset->nsproxy)
> -		free_nsproxy(nsset->nsproxy);
> +		nsproxy_free(nsset->nsproxy);
>  }
>  
>  static int prepare_nsset(unsigned flags, struct nsset *nsset)
> -- 
> 2.47.3
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

