Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63A2FC531F9
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 16:31:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE5F6B007B; Tue, 28 Jul 2026 12:31:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A60C6B009B; Tue, 28 Jul 2026 12:31:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195C66B009D; Tue, 28 Jul 2026 12:31:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEDBC6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:31:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B45DA15F6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:31:17 +0000 (UTC)
X-FDA: 85038725394.06.47FAC48
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4B8451C000E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:31:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VKzewIKk;
	spf=pass (imf20.hostedemail.com: domain of rgb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=rgb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785256275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qvz+f9qd1XslHKjpkIvG5iZUOK8HWLkYqkSa2lLHUw=;
	b=gIlMmEDRHGi2Y3pRcd/bphVyH3Z4LaRGExhzMEmumPZOoLQtVmtddrzgITso4u9olv9Bqg
	1t0vP8GQvh24wILs+PsNgB0LqLoKBHsNaQpiBy6ZUIZ7fxEchT/Yk9OZq8aj0RIZ5o/s/F
	B+Bnwn4G+UQoN7xbgJmqEp6jcpmWIgc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VKzewIKk;
	spf=pass (imf20.hostedemail.com: domain of rgb@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=rgb@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785256275;
	b=lrPNsFzvb/jxIqJr0/Mngh5153GeeGlMc9y4F2nqlZliXGmXb05tWViks37XVkK4xkLxLW
	D1YyPKwC1mVRocwGFp+Stdzk1EJXVedYOiOD5zFW4sPX9rueKRxefxj4sy2lEFwQ4nTncF
	FR2SchXFWzaK2nEuGWyoQNpAtdLaOBY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785256274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1qvz+f9qd1XslHKjpkIvG5iZUOK8HWLkYqkSa2lLHUw=;
	b=VKzewIKk9jEsZ36bh3u/9yZRbj6oiw39Q0YUVjDcu+OPkWqbh/SB6r1pSAp3RUj35bfTFh
	C0GzTmqlolVp6tTxgGTMH8mBIRu8hcOGh47Nv6LM2iAhzjnG3Shq6u3cW36oXoOq6/in0a
	JO7s4THCe1CmYO0jfLIaElWpa0Zhxhk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-437-UUTgbLUtMwCTt3lPXG5hBw-1; Tue,
 28 Jul 2026 12:31:11 -0400
X-MC-Unique: UUTgbLUtMwCTt3lPXG5hBw-1
X-Mimecast-MFC-AGG-ID: UUTgbLUtMwCTt3lPXG5hBw_1785256269
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB5EC1800562;
	Tue, 28 Jul 2026 16:31:08 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.22.58.2])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB657180044F;
	Tue, 28 Jul 2026 16:31:04 +0000 (UTC)
Date: Tue, 28 Jul 2026 12:31:02 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: audit@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	paul@paul-moore.com, eparis@redhat.com, sgrubb@redhat.com,
	kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org
Subject: Re: [PATCH] audit: add CLONE3 auxiliary record to log process cloning
Message-ID: <amjZRgbKg7svHU7r@madcap2.tricolour.ca>
References: <20260724150258.560396-2-rrobaina@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20260724150258.560396-2-rrobaina@redhat.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: Nm8nlGUVqb4eC8_6VUsP8VD_x5weuROt6X1YP0T0h-8_1785256269
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4B8451C000E
X-Stat-Signature: 9cj5oz1yqogukk9gzkqbocqnqhx8yazu
X-HE-Tag: 1785256275-331207
X-HE-Meta: U2FsdGVkX1/BKiEYcap2CWox1BF8E0FMgh2LAatxFUMrRl+oYZaJ4TQZypsYtxbbytSHrpX5n0grY2dB7tchkkfKbw6Gl833xMXaKVclU8RIRBbqJUB24syLH8R6JOxC3MuR/U9GlOUKeV0Dr7BeTq+9OZ6y9XmPslQ5l3GTiumLQuZo0SoYBlrHOhaCqPwxmoWjgzjELKO9UW6wpohvIKr0QQZ5104EpLXvnEscqlLU3r11bDHmacrDDkp2iJuYyUttW9+EzjB6nYfRm6ni44HY1JZWOpBRyZI+AQz9VdGssC4Yww5TF6g8lZ1wTqfxfeHpq/e+3K8vJ29pMXboLGGpKtHrCVm94rx5p33TslgMIWaCBCig7xbr+q7WWDXOPwXIHsYGMxsqTXt6mr8eaR/gylLd6+QMzuJ7srHC2lMJwQ/IFmxFim4+cFrv1w8kgcwRATL5+Z6TacTu03Xch4+9Qc4NycT5VYmXT3bpZgGTODwnV44eW6zwQY4q/Fy0K505zK3nWRH5SkmYKai/RoZRSV/dh8v0rc28ZtZiz3a+zz+zD++KkiQec7zd1SypHkiE71DHC0X9AUeL3A82ZjGRi2viL3A7ZQt+nKGdsFN14vMnlPGD7U+6IA9l9e5miUYGx6LY/TRDSOgTvZ0XtUQcaAegSAW+vU4NMnITzu7GGlP7hhrUbotJmD4PtIE/VuCeF8CVONGofYTQOwJ4tOw3LSVyT+KOSRdIaCkv4AZF+TSLLKhvXYgN6p751BDSrJ5Rj3TQe6J9UaEgN6fjBhpHVJUfV0Y8IVCPAHjnbOFIQ0xboUuNh/zFcIRWNTSIg3+SzyMBLEShk8o5zIHwox+sUxrRdfCRFseeWZ+3U2b5SIgoU7lIA50X02cly8IanlQusEYpIgBqwHDExzfi/p9qNqXa27VNYWBh3S1OdkKQVNP+3ufiUY/8ZN7Xeqx+Z0EuyDAlLnP2ZGFgBPJ
 +TC6ukWp
 HkXdjR6vmTNzn0skzcQqHUorTpjvAQn9c1Pzwy8h4+o/U33pqyHjTa1+iSwUD/ZTRNW8Hu6iNp0fn1XtTcAg8VlU0UvXr1HFnToPvRiSsc3MCyxUZvuatjszX0EjhsgaItGObOO4DquVUzK++BrJwaHIhdNx6BNZP4iDLTiTpZjKLQdRIjHWmkn8B+bR8o280Q1+s/0SFM2GfQZfMxBBNRrndtE2vRvk6vbNJkzeZuULiMSMHvzk4kQBjCoGDGpzXfAMV4y/UV70Y7mADlLnR2Nc4jY6y1UqnCmbT7cBvaajYbmogx7pVmY/d/540xGENoxuwUbjzThtrj4qWGqfW46n9zwYHEIX+6/BmHZUjdSjlDdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-24 12:02, Ricardo Robaina wrote:
> The clone3(2) syscall moves most parameters to struct clone_args.
> For this reason, the generic SYSCALL audit record does not capture
> the structured arguments.
> 
> Add a CLONE3 auxiliary record that logs: flags, exit_signal, cgroup,
> and pidfd fields from struct clone_args. When CLONE_PIDFD is set and
> the syscall succeeds, the resolved pidfd is logged; otherwise
> pidfd=(null).
> 
>  ----
>  type=SYSCALL : syscall=clone3 a0=0x7ffe7f1ec640 a1=0x58 a2=0x0 ...
>  type=CLONE3 : cl3_flags=0x1000 exit_signal=17 cgroup=0 pidfd=3
> 
> Link: https://github.com/linux-audit/audit-kernel/issues/151
> Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
> ---
>  include/linux/audit.h      | 10 ++++++++++
>  include/uapi/linux/audit.h |  1 +
>  kernel/auditsc.c           | 20 ++++++++++++++++++++
>  kernel/fork.c              |  4 +++-
>  4 files changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 45abb3722d30..833f349bf415 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -449,6 +449,7 @@ extern void __audit_tk_injoffset(struct timespec64 offset);
>  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
>  extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
>  			      enum audit_nfcfgop op, gfp_t gfp);
> +extern void __audit_log_clone3(struct kernel_clone_args *kargs, int ret);
>  
>  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
>  {
> @@ -598,6 +599,12 @@ static inline void audit_log_nfcfg(const char *name, u8 af,
>  		__audit_log_nfcfg(name, af, nentries, op, gfp);
>  }
>  
> +static inline void audit_log_clone3(struct kernel_clone_args *kargs, int ret)
> +{
> +	if (!audit_dummy_context())
> +		__audit_log_clone3(kargs, ret);
> +}
> +
>  extern int audit_n_rules;
>  extern int audit_signals;
>  #else /* CONFIG_AUDITSYSCALL */
> @@ -730,6 +737,9 @@ static inline void audit_log_nfcfg(const char *name, u8 af,
>  				   enum audit_nfcfgop op, gfp_t gfp)
>  { }
>  
> +static inline void audit_log_clone3(struct kernel_clone_args *kargs, int ret)
> +{ }
> +
>  #define audit_n_rules 0
>  #define audit_signals 0
>  #endif /* CONFIG_AUDITSYSCALL */
> diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> index e8f5ce677df7..37357e17adbf 100644
> --- a/include/uapi/linux/audit.h
> +++ b/include/uapi/linux/audit.h
> @@ -122,6 +122,7 @@
>  #define AUDIT_OPENAT2		1337	/* Record showing openat2 how args */
>  #define AUDIT_DM_CTRL		1338	/* Device Mapper target control */
>  #define AUDIT_DM_EVENT		1339	/* Device Mapper events */
> +#define AUDIT_CLONE3		1343	/* Record showing clone3 args */
>  
>  #define AUDIT_AVC		1400	/* SE Linux avc denial or grant */
>  #define AUDIT_SELINUX_ERR	1401	/* Internal SE Linux Errors */
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 6610e667c728..c0106bb71c19 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2882,6 +2882,26 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
>  }
>  EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
>  
> +void __audit_log_clone3(struct kernel_clone_args *kargs, int ret)
> +{
> +	struct audit_buffer *ab;
> +	int pidfd;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL,
> +			     AUDIT_CLONE3);
> +	if (!ab)
> +		return;
> +
> +	audit_log_format(ab, "cl3_flags=0x%llx exit_signal=%d cgroup=%d",
> +			 kargs->flags, kargs->exit_signal, kargs->cgroup);

Would there be any confusion if this were simply "flags=..." since it is
already a record type AUDIT_CLONE3?

> +	if ((kargs->flags & CLONE_PIDFD) && ret >= 0 &&
> +	    !get_user(pidfd, kargs->pidfd))
> +		audit_log_format(ab, " pidfd=%d", pidfd);
> +	else
> +		audit_log_format(ab, " pidfd=(null)");

Is there any interest in:
	child_tid (was captured by generic audit syscall arg 4)
	parent_tid (was captured by generic audit syscall arg 3 or 4)
	tls (was captured by generic audit syscall arg 4)
	set_tid

Is there a situation where a valid pid is returned without CLONE_PIDFD set?

Otherwise, looks reasonable to me.

> +	audit_log_end(ab);
> +}
> +
>  static void audit_log_task(struct audit_buffer *ab)
>  {
>  	kuid_t auid, uid;
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f0e2e131a9a5..0f52e8c0e900 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -3047,7 +3047,9 @@ SYSCALL_DEFINE2(clone3, struct clone_args __user *, uargs, size_t, size)
>  	if (!clone3_args_valid(&kargs))
>  		return -EINVAL;
>  
> -	return kernel_clone(&kargs);
> +	err = kernel_clone(&kargs);
> +	audit_log_clone3(&kargs, err);
> +	return err;
>  }
>  
>  void walk_process_tree(struct task_struct *top, proc_visitor visitor, void *data)
> -- 
> 2.53.0

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
Upstream IRC: SunRaycer
Voice: +1.613.860 2354 SMS: +1.613.518.6570


