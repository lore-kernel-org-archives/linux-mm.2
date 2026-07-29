Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2069C54FCD
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 22:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D12D96B008A; Wed, 29 Jul 2026 18:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8176B008C; Wed, 29 Jul 2026 18:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8926B0092; Wed, 29 Jul 2026 18:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A76C6B008A
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 18:03:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0892340720
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:03:12 +0000 (UTC)
X-FDA: 85043190624.03.FB3A45E
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0FEE1C0002
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:03:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=NPoVyODs;
	spf=pass (imf22.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785362590;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tf+R8andN/8C1l9MVMV+XEC/VXhqnJMJYXGT9VY4exY=;
	b=RV7jn2NL8PvvOKXARkDb8mmQ1mJjJcwdjbFTjoA+IgvqD2r7gFMTyIPLK3FCPkFOaod0Ea
	pCT/fmJnfkHP6h1ga+DQQxv7Ho/sEzejAHO7nxJDR+rs1a1y43SyS2sewImpRD+Iq9TePz
	eKzP5Y+acFzdcuYf1mdzAL3tmDFD+UE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785362590;
	b=IQ/u3DV7r9jBDT4Z8ginzkQBKAOmifFNDwEyOqsxr489NN9GOkAX8W/uylWikfdk0AOpyT
	Gs9xamatERYbBiDc9qd6yUTmxv21OcomyjTVgXkqmBX1NQLFks9Tim9/9uwwHdk5HqEavI
	CHxWQBLerKmPG84iN4QN8lM5VyPXfag=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=NPoVyODs;
	spf=pass (imf22.hostedemail.com: domain of paul@paul-moore.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso1426831a91.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:03:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785362589; cv=none;
        d=google.com; s=arc-20260327;
        b=IKzNa1cuI5oTiq9v3h86KlRg0RJP174cQyE2aNa+IJdAAuANq/zduJCGR3PnQIS1Ow
         diPvl8nn6sxADedUww/7PzzsxXSSW4QD1rYta/sS7dpwR2A47efPV3ZExy6bXx3RS4gt
         KKNFs3iAwHrgIA6xzCQzpGkyhH02hyNWIVdoBhIHh29j5tTUJ/tOPDjew6+nUkn0MeLD
         buR8jjbzJyo2z9zLNA1tw4ExxOnsibBMhio7SStyTHHDlrWILorV98f1K1J2c/QRFU5h
         gHm6p2X/nFRMHTY1XGkzcu0OygiUmSnK8I+DZxgLm5TpJRuK+mNySr/eTQfaJlAt9fmN
         xKuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tf+R8andN/8C1l9MVMV+XEC/VXhqnJMJYXGT9VY4exY=;
        fh=c97EhY1IIQW6+HSoXE0NtU3tlrWaKdpt4tqoULC1i8k=;
        b=oojgDSZCG0YybTXhPi/WZA0p+DEl+0y9iufe86a4p+TaL8bcYVQfhxeNFxPAQwW1Hk
         gqpyfM4VrsYV5WreU3ilGz1+hVRsYNIE+jZ28EX6i4uYjCV3nYu95kFM9UFYpRxINpxl
         iLMkpnY9R4BCBpEhXOWXUWlHFII9ACe7XgPA8OzdJO4XGHqAg59CUyGc40rJ/4M2b+q1
         xahKDuazuF5+zpcOKcSAX33ceoTk0m8Q7xdT4StvEIo0S5Yl55xgpdwcKa+ZH6YcK6Gn
         yzI55pnVqfzFJUR7RiM7Y4w3v+1U4T4LVu7P+DcrZV9y597rIy38gB/r6P89ksBlAXAa
         8TBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1785362589; x=1785967389; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tf+R8andN/8C1l9MVMV+XEC/VXhqnJMJYXGT9VY4exY=;
        b=NPoVyODsTj0aWsZFPLhhWw7qZh47g/r1iF/MfMxILr3K3utqB8LsoSeQeBh3EMbHmT
         wEwCpFfN/u1osG2d+3XGNCWew7JKsNU0wkhG7ld4ixnq+fUlkqfrtHPWlWymdspkRJG8
         7cXdQBOGzFyyzm0HT5ALfGppYcdd1IDN1Nqd1XKp9AO/3ICINA61oFLt+StDdp9hKhjY
         OZRsaztTPnWIyEZXdqqkAGBIsSJEkkLL0c2qPs6mz0n3Cb/hqnbYcw1sTrP1kXaHi2en
         RPeA07QgtMr2NKXKYCu/sitSCkClsUA3ygkbrqrOlVN933XNvHaqiLRt5vfC517nVy+C
         p7FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785362589; x=1785967389;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tf+R8andN/8C1l9MVMV+XEC/VXhqnJMJYXGT9VY4exY=;
        b=Qh7kNn5pleWlBzgP/cDfrTQEkBNwgNdkLXUUNePlDF5C8NshSd8Uh6pgEn/Wylw7W9
         2qw84wYr1hSPQJousi1n9v3Yt6/4bY54aHQjKcmnR93aj4XqC3SpvNTzYojjcxLn2l+X
         ZHv6PCHVrKoxDAzpgHwEXko3FTSUqtgGB/W9MtJsYDMc+HV78xTko1MfbpoydtSoEnFB
         CVlBZuDWLSclBZ+oNsJdv24Vrv1yxOEW2h1tNs04sLwSv946sKkUfqan7vHieFIzHFTQ
         XtyXicsdRn67gbevA+HCUP5rcBT+xJ75yLPxPx+6j/xnsMtAvcEUE04b2GPIF/MOFdS1
         XnWw==
X-Forwarded-Encrypted: i=1; AHgh+RoDBJtcbM6f6j8rigcyRmwyVgvq7HHKMf0J0QOD6ICWb0CcaTOVDCZr28ZwldprChPnzJdYwMGG5w==@kvack.org
X-Gm-Message-State: AOJu0Yzf89GJpb0aJqLg/h4mxU2fi5V02F0JnaRZo8bySDNqIxMVQC1i
	vRr7NY4CmcWyXqfkMROcvmFHBAOLST2pM6rdpHYfxvft2naauYdtnF9Y+qH9edRaYAeGBpwK+4F
	7QZ1Pld60Fzb+kJYtIr1RY83HVDrnGxRuOQpyZtj9
X-Gm-Gg: AR+sD104wYkcSWzxpp5XzYxg1zPt6OcgYMN2vPgSl3Avx9EHwzy3HZ60iT7nZPZUDA4
	TOslI1HwHolvrpQxzDKu2txRQm9WCjUeLx3zK5rDPdmcHF5fI/EWL3JU+/dXUwb70MJF/2heXAv
	JScMGoNVeu9cHDkjNjNShGtDpxDmgezCpWKHJV5b0buV9nrnD8M5M0nfjKfPjzgUKe656Qvpr5J
	dPZOJb8ioahsM8N08BNE7Fm69ghZoQpNrsvByLpd3uQCDRQKhg0FJr6/l3YIr8ciqxUmg6jtSFi
	69WN6t9hH6IrXW9RoLHhjHxVSp16+QyfJpBePxoNp9JXSFAa8qZtB8P6
X-Received: by 2002:a17:90b:4c8b:b0:384:5b5b:3465 with SMTP id
 98e67ed59e1d1-38f9c03f3f8mr16712a91.29.1785362588743; Wed, 29 Jul 2026
 15:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260724150258.560396-2-rrobaina@redhat.com>
In-Reply-To: <20260724150258.560396-2-rrobaina@redhat.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 29 Jul 2026 18:02:56 -0400
X-Gm-Features: AUfX_mzcntZ6VC8RqxPzHKxTitoDJtU_-OrjKrjMj_YpWSH2DybA-fWhadZG5cM
Message-ID: <CAHC9VhSzhyw--ycYMG_RaT5wpRQWDPBSuaNixsVrWrRXKc9hzw@mail.gmail.com>
Subject: Re: [PATCH] audit: add CLONE3 auxiliary record to log process cloning
To: Ricardo Robaina <rrobaina@redhat.com>
Cc: audit@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	eparis@redhat.com, sgrubb@redhat.com, kees@kernel.org, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: gfh3n49wzbss1y7yr3mh819as3izctm1
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0FEE1C0002
X-HE-Tag: 1785362589-952257
X-HE-Meta: U2FsdGVkX19NbvWUyVn+eNhF6eu434abOKU0baZBS+ZWhKRVqlx+zhN0FPdmZ7z8k9YAqMbzhoHBs0ec+U+t2RmiPCl0Iau3wWNRt1ihx7yoKjkbpbMjh4E37T4Ix+67A5szjZnKR57Wm6C98DTP0/TckRzTgvCAiNoiliKNM5xlixpycx2d9eON3vP2q3vKwRE06ToJrGJYZSBUU/9xEA8U5nh/zXwtsLVCLOXBULr8x+bL9O4IagDg95boV3N3QWwysjMSIuuRd40uvYR++UmgKh4I5d8uFK3qLW5/VHUJ90R6Dpbhj2DSENT8I6JZDvVO39JrUXRewzKdqRuQZWDmp8yCsq3GuYl9hxF3D1wTUiBis4whlHow/A88F5SM5dhuBszUh8kiJvBlPdJtWReAPf5f+d57fxGQI2nHEjZ1PkC2+ZEV8PEY3CxUSwSmfU5y/PaEczNsUcsXANGekOADdEV1HSd94amc7111r4AR1nUF5vU+XgaDKo/Yp//m/XIRBDaq1Q921VytbqmPN/ZmHUmL3DWh4Khr7WUl2rOlBbiXR8a+5GsVwEDokaE8BuKG7/vBp8+pKzNrichXnX3lHfZjhOnsekzxSPuT/ed6jLVwsylCNnwSI+5AmM3gbbtCXPpfYUmHGTrlUWzuTbNBYsbDgXQcUDc3t8BOgibA2Uk7MrwUh0M9iWj7IMlMp7xoqrPOJ0M5xA8E0vDKWBZaEM/gmGW+qHY1nhJC/rBtseFBS5g6bT6nW2W6/nXPevwZs09Q6QCOpgMMPqltjXTWDJIVfTlmwqXUVpYKv9TZd4VnjCI3Xfald2YIy2de/UJp98miToFzdRXTRBcW/4LcgWFAQzvzGA/+68XOv3CvgtPqn3oiTDPGk1qjq21iJ4FKFh9MCoez+yJpWNUoKFoPfGZqnAOJwXQD0F4pE4uSO2NnYfcAmAs1TeDWh9WCNX5kPHxeF7vhqGIVoJ/
 d4+ni2K7
 Vevcuq/7O3l9yN5lHFoH5JWLt/aAPouJKVoHWSG+EwZUEq/t2pyEgOudxlfWKo98KSOQ4Xvyl+SoSC0taoG0pvCU5wgKvxfmsg5u6dSSpP67rL3pXfuUuAo/iB4J8beY16ODEn4ixkQc7eXbW8UaYYItAjBPkk6TckizQB6j9hXeUGieadloWr/55yZdxWINFoVPaaEgXZpJ4h+Pgv59uDVwvqqFQQxcHkadVyhaZ5G0LwmL27nhvDLqSaAUuIwDcpUu2HdOfVK58ttqm9Wim9Jra6MIBPI4R715yUk3gFhk7sYUqEtjQdJ3mbdWy1SkxToKtzChWlygBsr0iqrQIb2MhsXydsfqPniPe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 11:03=E2=80=AFAM Ricardo Robaina <rrobaina@redhat.c=
om> wrote:
>
> The clone3(2) syscall moves most parameters to struct clone_args.
> For this reason, the generic SYSCALL audit record does not capture
> the structured arguments.
>
> Add a CLONE3 auxiliary record that logs: flags, exit_signal, cgroup,
> and pidfd fields from struct clone_args. When CLONE_PIDFD is set and
> the syscall succeeds, the resolved pidfd is logged; otherwise
> pidfd=3D(null).
>
>  ----
>  type=3DSYSCALL : syscall=3Dclone3 a0=3D0x7ffe7f1ec640 a1=3D0x58 a2=3D0x0=
 ...
>  type=3DCLONE3 : cl3_flags=3D0x1000 exit_signal=3D17 cgroup=3D0 pidfd=3D3
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
> @@ -449,6 +449,7 @@ extern void __audit_tk_injoffset(struct timespec64 of=
fset);
>  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
>  extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int nent=
ries,
>                               enum audit_nfcfgop op, gfp_t gfp);
> +extern void __audit_log_clone3(struct kernel_clone_args *kargs, int ret)=
;
>
>  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
>  {
> @@ -598,6 +599,12 @@ static inline void audit_log_nfcfg(const char *name,=
 u8 af,
>                 __audit_log_nfcfg(name, af, nentries, op, gfp);
>  }
>
> +static inline void audit_log_clone3(struct kernel_clone_args *kargs, int=
 ret)
> +{
> +       if (!audit_dummy_context())
> +               __audit_log_clone3(kargs, ret);
> +}
> +
>  extern int audit_n_rules;
>  extern int audit_signals;
>  #else /* CONFIG_AUDITSYSCALL */
> @@ -730,6 +737,9 @@ static inline void audit_log_nfcfg(const char *name, =
u8 af,
>                                    enum audit_nfcfgop op, gfp_t gfp)
>  { }
>
> +static inline void audit_log_clone3(struct kernel_clone_args *kargs, int=
 ret)
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
>  #define AUDIT_OPENAT2          1337    /* Record showing openat2 how arg=
s */
>  #define AUDIT_DM_CTRL          1338    /* Device Mapper target control *=
/
>  #define AUDIT_DM_EVENT         1339    /* Device Mapper events */
> +#define AUDIT_CLONE3           1343    /* Record showing clone3 args */
>
>  #define AUDIT_AVC              1400    /* SE Linux avc denial or grant *=
/
>  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors */
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index 6610e667c728..c0106bb71c19 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2882,6 +2882,26 @@ void __audit_log_nfcfg(const char *name, u8 af, un=
signed int nentries,
>  }
>  EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
>
> +void __audit_log_clone3(struct kernel_clone_args *kargs, int ret)
> +{
> +       struct audit_buffer *ab;
> +       int pidfd;
> +
> +       ab =3D audit_log_start(audit_context(), GFP_KERNEL,
> +                            AUDIT_CLONE3);
> +       if (!ab)
> +               return;
> +
> +       audit_log_format(ab, "cl3_flags=3D0x%llx exit_signal=3D%d cgroup=
=3D%d",
> +                        kargs->flags, kargs->exit_signal, kargs->cgroup)=
;
> +       if ((kargs->flags & CLONE_PIDFD) && ret >=3D 0 &&
> +           !get_user(pidfd, kargs->pidfd))
> +               audit_log_format(ab, " pidfd=3D%d", pidfd);

Do we care about distinguishing between the combination of CLONE_PIDFD
and CLONE_THREAD vs CLONE_PIDFD alone?  In other words, do we care if
the "pidfd" field sometimes represents a pidfd of the child process vs
a thread in the current process?

> +       else
> +               audit_log_format(ab, " pidfd=3D(null)");
> +       audit_log_end(ab);
> +}
> +
>  static void audit_log_task(struct audit_buffer *ab)
>  {
>         kuid_t auid, uid;
> diff --git a/kernel/fork.c b/kernel/fork.c
> index f0e2e131a9a5..0f52e8c0e900 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -3047,7 +3047,9 @@ SYSCALL_DEFINE2(clone3, struct clone_args __user *,=
 uargs, size_t, size)
>         if (!clone3_args_valid(&kargs))
>                 return -EINVAL;
>
> -       return kernel_clone(&kargs);
> +       err =3D kernel_clone(&kargs);
> +       audit_log_clone3(&kargs, err);
> +       return err;
>  }
>
>  void walk_process_tree(struct task_struct *top, proc_visitor visitor, vo=
id *data)
> --
> 2.53.0

--=20
paul-moore.com

