Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD59CD6E4D
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 13:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 828058E000D; Thu, 13 Nov 2025 08:05:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9398E0002; Thu, 13 Nov 2025 08:05:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EDDE8E000D; Thu, 13 Nov 2025 08:05:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 595968E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 08:05:13 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBBCCC09C0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:05:12 +0000 (UTC)
X-FDA: 84105604464.12.57FA9E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A0C912000D
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:05:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=il4RnQGw;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763039111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=++x3bjjJ62kiW8M3U1eSEapOUVOB15wrXm/99HJbuok=;
	b=VOUf8nsvByox8dzX2yFrh/tfcAt+ri4rGLi3iluVvX83JpHL6PjZSGmcSN8qHpzi/P9gIf
	CF9FEXnIRQCBiN6PMhWOiBDjxdyQfT1AG/nc8XTCSFtWmw8PI9Y6JaZLJdy9JqH5zik7v7
	s62JfrKdgBIFMW4q/swP7IQI8cUYB7U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=il4RnQGw;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763039111; a=rsa-sha256;
	cv=none;
	b=EZ2ouEgHlJ+TDjANPKBZInGor3ywaX92lEEkdo75MbvadFUIVK46VWI9pnkLWeXj6bYKCt
	M8IPwPq8ncWozMExWOnK32cdFuvk3Uu9qKnJjxScK6Z1hIk/Ni26Wj4ilbdtLJWEK3+6m7
	qKblAV8LerxbKfR88UzUeDoOC4TXhIs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80C42601E7;
	Thu, 13 Nov 2025 13:05:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BE2C19424;
	Thu, 13 Nov 2025 13:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763039110;
	bh=cL2KGa3EDoiRCfsg89NVRAFAk4L8Qg34jvE72zfEDh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=il4RnQGwDvnxHfZSmsds+I8y6BNCBtXGaG87YpVWivDQ6OAMNU0aN73RxVc/phLZp
	 nBq004ZZQJS15y4wwdPHMDYVfZFw1GqSq0ccJZHaK8lshhGWY+D087BtQFu7STDswl
	 0f4U2LLDBzAeXxgA8NNesftI2ujyTAH/Q+34taTN9qHIf/4Av7bOWViiL9C30AbxFB
	 ZVc/hpC66wTR50h6hAG6T+YZxtu2rbrGMPL6Euk/wbanQv/8V2P2u8KRm8ueL80UmY
	 KP+bFEo0u5ZavG6L0bP2T+AG5kOtlGFMkzvJFBTaeofM7P7ml4cPa5RH0aKykI8WdV
	 Lhpe1TlFi9zWA==
Date: Thu, 13 Nov 2025 14:05:00 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: syzbot <syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com>, 
	akpm@linux-foundation.org, bpf@vger.kernel.org, bsegall@google.com, david@redhat.com, 
	dietmar.eggemann@arm.com, jsavitz@redhat.com, juri.lelli@redhat.com, kartikey406@gmail.com, 
	kees@kernel.org, liam.howlett@oracle.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	lorenzo.stoakes@oracle.com, mgorman@suse.de, mhocko@suse.com, mingo@redhat.com, 
	mjguzik@gmail.com, oleg@redhat.com, paul@paul-moore.com, peterz@infradead.org, 
	rostedt@goodmis.org, rppt@kernel.org, sergeh@kernel.org, surenb@google.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz, vincent.guittot@linaro.org, 
	viro@zeniv.linux.org.uk, vschneid@redhat.com, 
	syzbot+0a8655a80e189278487e@syzkaller.appspotmail.com
Subject: Re: [PATCH] nsproxy: fix free_nsproxy() and simplify
 create_new_namespaces()
Message-ID: <20251113-hochphase-sprossen-2ff6e1f23b5b@brauner>
References: <691360cc.a70a0220.22f260.013e.GAE@google.com>
 <20251111-sakralbau-guthaben-7dcc277d337f@brauner>
 <3yjawi3c72ieiss7ivefckuua55e2yvo55z4m4ykp2pzw2snpa@ym34e3d7cnoi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3yjawi3c72ieiss7ivefckuua55e2yvo55z4m4ykp2pzw2snpa@ym34e3d7cnoi>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A0C912000D
X-Stat-Signature: 3yjgzsgcm43wxwy9y87ndzxxtxkb3t3n
X-Rspam-User: 
X-HE-Tag: 1763039111-546176
X-HE-Meta: U2FsdGVkX1+q3Wj/CzV0Multf3lq7O1eSNO0NX+4gWXMqnJ5eKTLtZDDwpAUXQnoatOgfd6u2fXWnQYEP21BHmVr81ERLKyCCT0Iz0ON0DeKgjedSj4LJ8psqXw8p4GDFflRN0q4GMm29hPPH8VZzxdDuZvwU6DYWvfyiitz/PjSVq0dw6qIpIPcvU1N+oJrljA8G5xo7m9Vx+g+32VWGiOZiNzmuQMRhdLb8pANOUIU8hFCxOrcu8nW5dCdnuEBbrPlJtZA1fTuogjAJjg7omtvSPgEVO1oe77J1t/itUTUl7p6Dnj3C1wPJ67ahauvFMpuB0JLeJQR+Hy+k3DN+wW7vpv7PKBMLTw8MZFdLUe8Q2l4arCQq0gns67vbd0ZoHF+E0zhBNtK/FdZm1lHfptS/16msq/h8WmSWcs7Y5D0SX0Mg1dEBCZ8PIkvbLRUX+Ed7gZ4CVsnsSbQ68Tor73ioSohfZeXsxJVzRxxMpxIql7ahNO6Wtbj0TcoEVme1ygUKJJTLdj53agchxFzQmm2qtJEqG7Ic6Mv/sk7J8U3T9eLyrMoeUQQxndN/XUBBJ04a6H2b7boZ49Yi2ZzKFTx8M6H5ZSpqG6xfTwvnHmPbIeYN2H/f0rPRjh80XW/wsXCLgUhPHWfJWvJFovey8jKOaVJ+YHAb7CA8z4Hw7aDzcjgHEzQyiDO+/dWb6FoDfHOcZBm0+yrrOBkKhPY2dCz5avArMIUqWJOKDAc+TdLwGD2yLe/WCyKp1Q+NrBEsKvgXRdWa4GEhaXSiGkgMonCUJDRXA0UNFtezL1ZgaSxt2rCpycgYDbIUcm3z8WL0fO0kV7dG9g4rwYW/l3WYnpqGnbAbMMBAW/jN3+zTF4t7pshJkUFl9JWQCnaFVJjxCgN1Ss+VUWG7DHORawi9CCbI7c0hbYluv88eVvJnSDB72SqSd2re6QOq5N7Qs48fknemxj+eVQsHFs7ClJ
 beu7y18c
 EdPXGgnhwVXeyF6BaOLiA9/ywyTTfxVeC9KTmkq9uvIPcKdDPtRz1vlfiw5H2Tk6CtUwefMkn2t5EL8rWJA0r/oyPV8Lu3CLbsarhNleuJMEIZ+qCK9PprTccT8rT1LM69Pi0CEi+8Dt3b8zyNbmn/dnqf+kbUx9AxBqdi66hPxXVT3h1jQWGVMihhYrgRKo23h5aqXqfV2iEanqXzqtA9lx4nP7MDyDLxu8wRXXOdhe4zqcRrV0RlA0QpH4PhMqPdncxqsmdfT0nyW2eBd/C2DzguEdFMZv2QdlPh/0OPkVfhaznDiPtaIhPPIw4TK5AxNbaErGgC7tX77l8tss/fb+FDAHEh/QADh6omQYFZBh5obOAib7Gv7nXFa0Wtoq/ki3r5f9WFGLHYH7r6g1jWl7Hcu97FzN7H0b3C2ZZTHXCGpPeXqSS5MwopPONmfZZjowEuVOeVoU8adgsnfOOchd9SLJszIARajyMzVUCFAz1029AVSL4tMFljpLstupcDdm8bKXWxeZwdlZNeelHX6dteNMBmoj3ZpJI4dG+tNy/qZq6Q6MU9QQOfSsw4ThVDfwqOn6KoSY+Mxc1jSyEzwTT3LyrK81Qi0Lg5qE/7ReZuekNxPz4s4/ac9Vv8WPapbxHdBUCcdLasd7Y6Bb03LxTP6SZqsZ5RDFq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 12:19:40PM +0100, Jan Kara wrote:
> On Tue 11-11-25 22:29:44, Christian Brauner wrote:
> > Make it possible to handle NULL being passed to the reference count
> > helpers instead of forcing the caller to handle this. Afterwards we can
> > nicely allow a cleanup guard to handle nsproxy freeing.
> > 
> > Active reference count handling is not done in nsproxy_free() but rather
> > in free_nsproxy() as nsproxy_free() is also called from setns() failure
> > paths where a new nsproxy has been prepared but has not been marked as
> > active via switch_task_namespaces().
> > 
> > Fixes: 3c9820d5c64a ("ns: add active reference count")
> > Reported-by: syzbot+0b2e79f91ff6579bfa5b@syzkaller.appspotmail.com
> > Reported-by: syzbot+0a8655a80e189278487e@syzkaller.appspotmail.com
> > Link: https://lore.kernel.org/690bfb9e.050a0220.2e3c35.0013.GAE@google.com
> > Signed-off-by: Christian Brauner <brauner@kernel.org>
> 
> I believe having free_nsproxy() and nsproxy_free() functions with
> the same signature and slightly different semantics is making things too
> easy to get wrong. Maybe call free_nsproxy() say deactivate_nsproxy()?

Good idea, I'll rename to that!

> 
> Otherwise the patch looks correct to me. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> 								Honza
> 
> > ---
> >  include/linux/ns_common.h |  11 ++--
> >  kernel/nsproxy.c          | 107 +++++++++++++++-----------------------
> >  2 files changed, 48 insertions(+), 70 deletions(-)
> > 
> > diff --git a/include/linux/ns_common.h b/include/linux/ns_common.h
> > index 136f6a322e53..825f5865bfc5 100644
> > --- a/include/linux/ns_common.h
> > +++ b/include/linux/ns_common.h
> > @@ -114,11 +114,14 @@ static __always_inline __must_check bool __ns_ref_dec_and_lock(struct ns_common
> >  }
> >  
> >  #define ns_ref_read(__ns) __ns_ref_read(to_ns_common((__ns)))
> > -#define ns_ref_inc(__ns) __ns_ref_inc(to_ns_common((__ns)))
> > -#define ns_ref_get(__ns) __ns_ref_get(to_ns_common((__ns)))
> > -#define ns_ref_put(__ns) __ns_ref_put(to_ns_common((__ns)))
> > +#define ns_ref_inc(__ns) \
> > +	do { if (__ns) __ns_ref_inc(to_ns_common((__ns))); } while (0)
> > +#define ns_ref_get(__ns) \
> > +	((__ns) ? __ns_ref_get(to_ns_common((__ns))) : false)
> > +#define ns_ref_put(__ns) \
> > +	((__ns) ? __ns_ref_put(to_ns_common((__ns))) : false)
> >  #define ns_ref_put_and_lock(__ns, __ns_lock) \
> > -	__ns_ref_dec_and_lock(to_ns_common((__ns)), __ns_lock)
> > +	((__ns) ? __ns_ref_dec_and_lock(to_ns_common((__ns)), __ns_lock) : false)
> >  
> >  #define ns_ref_active_read(__ns) \
> >  	((__ns) ? __ns_ref_active_read(to_ns_common(__ns)) : 0)
> > diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
> > index 94c2cfe0afa1..2c94452dc793 100644
> > --- a/kernel/nsproxy.c
> > +++ b/kernel/nsproxy.c
> > @@ -60,6 +60,27 @@ static inline struct nsproxy *create_nsproxy(void)
> >  	return nsproxy;
> >  }
> >  
> > +static inline void nsproxy_free(struct nsproxy *ns)
> > +{
> > +	put_mnt_ns(ns->mnt_ns);
> > +	put_uts_ns(ns->uts_ns);
> > +	put_ipc_ns(ns->ipc_ns);
> > +	put_pid_ns(ns->pid_ns_for_children);
> > +	put_time_ns(ns->time_ns);
> > +	put_time_ns(ns->time_ns_for_children);
> > +	put_cgroup_ns(ns->cgroup_ns);
> > +	put_net(ns->net_ns);
> > +	kmem_cache_free(nsproxy_cachep, ns);
> > +}
> > +
> > +DEFINE_FREE(nsproxy_free, struct nsproxy *, if (_T) nsproxy_free(_T))
> > +
> > +void free_nsproxy(struct nsproxy *ns)
> > +{
> > +	nsproxy_ns_active_put(ns);
> > +	nsproxy_free(ns);
> > +}
> > +
> >  /*
> >   * Create new nsproxy and all of its the associated namespaces.
> >   * Return the newly created nsproxy.  Do not attach this to the task,
> > @@ -69,76 +90,45 @@ static struct nsproxy *create_new_namespaces(u64 flags,
> >  	struct task_struct *tsk, struct user_namespace *user_ns,
> >  	struct fs_struct *new_fs)
> >  {
> > -	struct nsproxy *new_nsp;
> > -	int err;
> > +	struct nsproxy *new_nsp __free(nsproxy_free) = NULL;
> >  
> >  	new_nsp = create_nsproxy();
> >  	if (!new_nsp)
> >  		return ERR_PTR(-ENOMEM);
> >  
> >  	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, user_ns, new_fs);
> > -	if (IS_ERR(new_nsp->mnt_ns)) {
> > -		err = PTR_ERR(new_nsp->mnt_ns);
> > -		goto out_ns;
> > -	}
> > +	if (IS_ERR(new_nsp->mnt_ns))
> > +		return ERR_CAST(new_nsp->mnt_ns);
> >  
> >  	new_nsp->uts_ns = copy_utsname(flags, user_ns, tsk->nsproxy->uts_ns);
> > -	if (IS_ERR(new_nsp->uts_ns)) {
> > -		err = PTR_ERR(new_nsp->uts_ns);
> > -		goto out_uts;
> > -	}
> > +	if (IS_ERR(new_nsp->uts_ns))
> > +		return ERR_CAST(new_nsp->uts_ns);
> >  
> >  	new_nsp->ipc_ns = copy_ipcs(flags, user_ns, tsk->nsproxy->ipc_ns);
> > -	if (IS_ERR(new_nsp->ipc_ns)) {
> > -		err = PTR_ERR(new_nsp->ipc_ns);
> > -		goto out_ipc;
> > -	}
> > +	if (IS_ERR(new_nsp->ipc_ns))
> > +		return ERR_CAST(new_nsp->ipc_ns);
> >  
> > -	new_nsp->pid_ns_for_children =
> > -		copy_pid_ns(flags, user_ns, tsk->nsproxy->pid_ns_for_children);
> > -	if (IS_ERR(new_nsp->pid_ns_for_children)) {
> > -		err = PTR_ERR(new_nsp->pid_ns_for_children);
> > -		goto out_pid;
> > -	}
> > +	new_nsp->pid_ns_for_children = copy_pid_ns(flags, user_ns,
> > +						   tsk->nsproxy->pid_ns_for_children);
> > +	if (IS_ERR(new_nsp->pid_ns_for_children))
> > +		return ERR_CAST(new_nsp->pid_ns_for_children);
> >  
> >  	new_nsp->cgroup_ns = copy_cgroup_ns(flags, user_ns,
> >  					    tsk->nsproxy->cgroup_ns);
> > -	if (IS_ERR(new_nsp->cgroup_ns)) {
> > -		err = PTR_ERR(new_nsp->cgroup_ns);
> > -		goto out_cgroup;
> > -	}
> > +	if (IS_ERR(new_nsp->cgroup_ns))
> > +		return ERR_CAST(new_nsp->cgroup_ns);
> >  
> >  	new_nsp->net_ns = copy_net_ns(flags, user_ns, tsk->nsproxy->net_ns);
> > -	if (IS_ERR(new_nsp->net_ns)) {
> > -		err = PTR_ERR(new_nsp->net_ns);
> > -		goto out_net;
> > -	}
> > +	if (IS_ERR(new_nsp->net_ns))
> > +		return ERR_CAST(new_nsp->net_ns);
> >  
> >  	new_nsp->time_ns_for_children = copy_time_ns(flags, user_ns,
> > -					tsk->nsproxy->time_ns_for_children);
> > -	if (IS_ERR(new_nsp->time_ns_for_children)) {
> > -		err = PTR_ERR(new_nsp->time_ns_for_children);
> > -		goto out_time;
> > -	}
> > +						     tsk->nsproxy->time_ns_for_children);
> > +	if (IS_ERR(new_nsp->time_ns_for_children))
> > +		return ERR_CAST(new_nsp->time_ns_for_children);
> >  	new_nsp->time_ns = get_time_ns(tsk->nsproxy->time_ns);
> >  
> > -	return new_nsp;
> > -
> > -out_time:
> > -	put_net(new_nsp->net_ns);
> > -out_net:
> > -	put_cgroup_ns(new_nsp->cgroup_ns);
> > -out_cgroup:
> > -	put_pid_ns(new_nsp->pid_ns_for_children);
> > -out_pid:
> > -	put_ipc_ns(new_nsp->ipc_ns);
> > -out_ipc:
> > -	put_uts_ns(new_nsp->uts_ns);
> > -out_uts:
> > -	put_mnt_ns(new_nsp->mnt_ns);
> > -out_ns:
> > -	kmem_cache_free(nsproxy_cachep, new_nsp);
> > -	return ERR_PTR(err);
> > +	return no_free_ptr(new_nsp);
> >  }
> >  
> >  /*
> > @@ -185,21 +175,6 @@ int copy_namespaces(u64 flags, struct task_struct *tsk)
> >  	return 0;
> >  }
> >  
> > -void free_nsproxy(struct nsproxy *ns)
> > -{
> > -	nsproxy_ns_active_put(ns);
> > -
> > -	put_mnt_ns(ns->mnt_ns);
> > -	put_uts_ns(ns->uts_ns);
> > -	put_ipc_ns(ns->ipc_ns);
> > -	put_pid_ns(ns->pid_ns_for_children);
> > -	put_time_ns(ns->time_ns);
> > -	put_time_ns(ns->time_ns_for_children);
> > -	put_cgroup_ns(ns->cgroup_ns);
> > -	put_net(ns->net_ns);
> > -	kmem_cache_free(nsproxy_cachep, ns);
> > -}
> > -
> >  /*
> >   * Called from unshare. Unshare all the namespaces part of nsproxy.
> >   * On success, returns the new nsproxy.
> > @@ -338,7 +313,7 @@ static void put_nsset(struct nsset *nsset)
> >  	if (nsset->fs && (flags & CLONE_NEWNS) && (flags & ~CLONE_NEWNS))
> >  		free_fs_struct(nsset->fs);
> >  	if (nsset->nsproxy)
> > -		free_nsproxy(nsset->nsproxy);
> > +		nsproxy_free(nsset->nsproxy);
> >  }
> >  
> >  static int prepare_nsset(unsigned flags, struct nsset *nsset)
> > -- 
> > 2.47.3
> > 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

