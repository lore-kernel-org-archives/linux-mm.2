Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDCBBC5DF8E
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 12:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D38E16B0095; Fri, 21 Aug 2026 08:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D10DC6B009B; Fri, 21 Aug 2026 08:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C263E6B009D; Fri, 21 Aug 2026 08:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AED56B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:27:09 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DD84A0482
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:27:09 +0000 (UTC)
X-FDA: 85125201378.15.552CE5F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9DD4A20006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:27:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R0se3iZW;
	spf=pass (imf13.hostedemail.com: domain of rrobaina@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=rrobaina@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787315227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nQiAnmFR1CPZ/lHsTXoGg00TJNHaMaAN/SMaiIN0sQ=;
	b=t7NlVa/BGBrjdJwy1HaMBa/x91e/JaWj7VcZtNyDEKKdQtp/lf71r/F5ypLxHR0JLno5Qc
	KtHPt+zc1v0UUILtwRbxD/H6dwGfi8hl9rdS7ez+D4af+mEyiN8vOcwxxHit4GvJJpnfmn
	RybkdB+7X6olsTkz2FWGCnGfcdJKIP4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R0se3iZW;
	spf=pass (imf13.hostedemail.com: domain of rrobaina@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=rrobaina@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787315227;
	b=BNnaUuq/XJSTKORH1pZ5srGCQudf+GAj2OXZ/qcjlEoA4xhkURshye1EDTR7r/c5IzzU/k
	4NfrYUkJhA0yUGkBTjomk8HXbi1F5PHqNGcD7uqnaCsPptb1DmmpZcFZd7oOjqYUW+X5mM
	u4VcNifFGtZ07psY9HVLwugJLIlYkWg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787315226;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8nQiAnmFR1CPZ/lHsTXoGg00TJNHaMaAN/SMaiIN0sQ=;
	b=R0se3iZWGZUlQJOjVw0PShY9OO7+5Id41KBT/3ptx/afk9KMa0hHNDO/494AsFbuWT1MkG
	D3KvyAhw534syowR/FhB945tCIXtL9N2b/PcI6ggXpqxiPofSdxN5V4PuKZM+qXMEc7BNY
	wfx8GEadWvBgheFCZjfQPIg/9rcJUsc=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-135-DHM4flnfMdKR9jNZvb4RFA-1; Fri, 21 Aug 2026 08:27:04 -0400
X-MC-Unique: DHM4flnfMdKR9jNZvb4RFA-1
X-Mimecast-MFC-AGG-ID: DHM4flnfMdKR9jNZvb4RFA_1787315223
Received: by mail-ej1-f69.google.com with SMTP id a640c23a62f3a-c16711b9473so77279766b.2
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:27:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787315223; x=1787920023;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8nQiAnmFR1CPZ/lHsTXoGg00TJNHaMaAN/SMaiIN0sQ=;
        b=H2ZT4ysKKnvS2XKn4iRsZjOZQScG5SXvE92U0hXnv8mJxRLHjR1xrBNdRHHT0T++T1
         CPbuI+vt8OdqceM/C2vvhhgmzFqmTmdKvQAu8fspOHPzc2mkmX+7G4Zsw+tRbJaR2opi
         j6ZmYy/cPuvfHB4ArMvwswhrB9UBDWCkKr2I7Jjx7GVvv2b2PnbVW1Qj29MfLOjvRrIV
         AIFQ79gKXXE/+gOJ1FSbghibB88Z0YC0NjqrswSS7SK8tsbdRWx7i8AobKVyG+Q5Ou06
         fsGekqXb+vyDRbW5X7SeHd8ADgXijLb/zhTm1f8e1FhZ2h6q2c4jkrl+hvSW5yaVwSHb
         Hzaw==
X-Forwarded-Encrypted: i=1; AHgh+RrxwlO/TV9UfmMsHRqlleq7RAimippmQmBXsWuf3T/6CLeFH5rh3d3hdkxr0LH6X8LBWvdjB6aXBg==@kvack.org
X-Gm-Message-State: AFuF++kZYLiGJZl2YJhHWaXCd8EzO4vkERkWbNCpXwFpqvrqaug1WCPz
	xR7n3QsfJ2EdCUtQUVaUiv1o5y8WPhgLsalAfhP3fLxIXzZcoUMTZuHfDelwTKtna2Z4AeN0vVv
	2Gl+d5SiZcCufUjhnj/aYOkGijsR1ZPg/xIpBoMQ4jCJCDdHRI3Bl3LX3hCYnBK3d8MKdO6IUyt
	9oZBqZPY3IdTXZUl5EUPG4z2+xgZE=
X-Gm-Gg: AR+sD13NZLXgRcjFBPpyBedhEUqhPCHPpXC4R5jrn3sv2BoahMgSMdm2AK3U/6dWAj7
	ULnZCst1ULwN8D1qa6Yvx6cdc8xFHH07fE1M7Iysjw7J8CgZCSeELf7t1WYJvDSNbQjjotn2CBA
	F/uqJhs00oZupHrvGTtwgzW/PevQWFOQZeSAh7PGvVxh7KTIMn+JOSshIj4N4LzIvOQAx8/4SXl
	of/tYISv1PK2gSk0jHAVCSHD3W1mQKII0cxbJF4iQhI1BbgpJpffosvAYlc1G4f276MihEHHQna
X-Received: by 2002:a17:907:3d56:b0:c1f:e9d6:2a6f with SMTP id a640c23a62f3a-c2469f9991dmr630515866b.0.1787315223462;
        Fri, 21 Aug 2026 05:27:03 -0700 (PDT)
X-Received: by 2002:a17:907:3d56:b0:c1f:e9d6:2a6f with SMTP id
 a640c23a62f3a-c2469f9991dmr630333466b.0.1787315197822; Fri, 21 Aug 2026
 05:26:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260724150258.560396-2-rrobaina@redhat.com> <CAHC9VhSzhyw--ycYMG_RaT5wpRQWDPBSuaNixsVrWrRXKc9hzw@mail.gmail.com>
In-Reply-To: <CAHC9VhSzhyw--ycYMG_RaT5wpRQWDPBSuaNixsVrWrRXKc9hzw@mail.gmail.com>
From: Ricardo Robaina <rrobaina@redhat.com>
Date: Fri, 21 Aug 2026 09:26:26 -0300
X-Gm-Features: AcwNN1WD71ac4WEQSUnfKMe1gRwRLyFnSk3rCPAS384W6Bqs5OsdV3sfC6_UdO4
Message-ID: <CAABTaaA=FupPfFhOdMPi7nPy5wSh7znEdnBquYbTXCN=YbtKiA@mail.gmail.com>
Subject: Re: [PATCH] audit: add CLONE3 auxiliary record to log process cloning
To: Paul Moore <paul@paul-moore.com>
Cc: audit@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	eparis@redhat.com, sgrubb@redhat.com, kees@kernel.org, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nrADp6YDGAYlFLI9Tlw9ZzKBu2PXXBHu2o31vNDSGgs_1787315223
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9DD4A20006
X-Stat-Signature: 13j9ao7nnk4js67n3zeyk6um46bnm9b4
X-Rspam-User: 
X-HE-Tag: 1787315226-672893
X-HE-Meta: U2FsdGVkX19ZkGVvhy4g97+n3eQtnzEiZX1Jr0rZ13xxh1CFu17aeAlLoF7icYYBmu8DqcdxpLp92ochKCvDDTFPWPteZQv+y9Mvd2K8Wu0HCEH5Ci2kJy/kaA1uWxQc6R5Vwaisplj/vItp9qs+2tZA9PfJVWxobUwhlN34syQK95KfDsSyNk6P7Xb3lN4rd2sASQCr4mD3CDR2uVv/XAuEh4FhMtnGSiCXMV5KTelNnD4ZckVH22bdv0JYzBzam5vAuwFkwM16e/EM3JEihYmUDjrD0i7I2llyxf6/+iBEEF3vd3A7dowyfdkmsIaxR8jqdO42g4jR8/Y9MPJsR8ya32XvhWaNw+R65BDIhIaaf+muSGnuMgtETIj4+bd+PhRkAd4/21YZbyHPbRmjTmTiXBBYHlXYQUNCXeDt1yj7CiakOBR3NAn/6jWo2fVMZbWuJR8/r1wvBmYFvsTpHjgpzH5DzRZS1VxMYgBfcysHcwZT/MLLVb1SxAx4WgXl7W5afZ91Y5+89YohFRbOb8yv7DMlVoyBHF2YsGJTNWIB2JqfoPkLfQaFHInegvbDofpEqh3tjg8NpRcodtsKOUQ/j9IGZCa+toVXjqdLmmXlv+k5066kytSJJFh418jX+YqRWb52PW9Lk2LH+3V6dA8FEV0PUUVj+QTmKHelxWYB0+V8UOLV8Qc6U2u3POoU1Z2EFoStM4vDXjCy7v6nj3UAU/U9Lng2j7dK4ApyN24Kcv+4WmZVKKM+Xsk6CT16uBbNcDmupiKQhoiLpoHCJEgTYKhjmAhEwghTGcLnlI1x9bgFvIRD9iOGpaqMyaDgPojhyASW2DaYATiLk6QwfGyZ+OGeYEyR4DtFScIGErN9/oyWVpX13Q1/ry+XoHwpRv93aOWH836TcO2Qm67Xknv8HJeRVCm8gc0CeoIVGlWkFCXkEdy+4UtgWzrXb53W9THuzckOlt680kC+IjM
 BYGkFUqt
 ZTGI1maqqn+KCSADMSWsCKzfuV/9mVKFemupvBlRKb3MPN8ilb26cMPbPRXSRiwmf47TOqnz/4RUvpnFVEO8VUcyU6ZYkS1/JwjYnpDPbYasBZhLMAT8IBLM5tw99RaH9vhntlCrCZIbpXi6/8K7GoGGOIzbP77GEdwFBRjQRalJfpSDgQLx4uG9B8Idob44bj7zXPTQc2/aJyAxj9NBNoVxjs3gy/vh66ZCG7jKWzav1O5lM2WUBovtOHPkrIDF76HKCfnQYIs+I6pxrIPDOPd6tE9mn8HO3YTHWr3Og969oyUtRlzNGqmMa2Rj+1iqB+tOU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 7:03=E2=80=AFPM Paul Moore <paul@paul-moore.com> wr=
ote:
>
> On Fri, Jul 24, 2026 at 11:03=E2=80=AFAM Ricardo Robaina <rrobaina@redhat=
.com> wrote:
> >
> > The clone3(2) syscall moves most parameters to struct clone_args.
> > For this reason, the generic SYSCALL audit record does not capture
> > the structured arguments.
> >
> > Add a CLONE3 auxiliary record that logs: flags, exit_signal, cgroup,
> > and pidfd fields from struct clone_args. When CLONE_PIDFD is set and
> > the syscall succeeds, the resolved pidfd is logged; otherwise
> > pidfd=3D(null).
> >
> >  ----
> >  type=3DSYSCALL : syscall=3Dclone3 a0=3D0x7ffe7f1ec640 a1=3D0x58 a2=3D0=
x0 ...
> >  type=3DCLONE3 : cl3_flags=3D0x1000 exit_signal=3D17 cgroup=3D0 pidfd=
=3D3
> >
> > Link: https://github.com/linux-audit/audit-kernel/issues/151
> > Signed-off-by: Ricardo Robaina <rrobaina@redhat.com>
> > ---
> >  include/linux/audit.h      | 10 ++++++++++
> >  include/uapi/linux/audit.h |  1 +
> >  kernel/auditsc.c           | 20 ++++++++++++++++++++
> >  kernel/fork.c              |  4 +++-
> >  4 files changed, 34 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 45abb3722d30..833f349bf415 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -449,6 +449,7 @@ extern void __audit_tk_injoffset(struct timespec64 =
offset);
> >  extern void __audit_ntp_log(const struct audit_ntp_data *ad);
> >  extern void __audit_log_nfcfg(const char *name, u8 af, unsigned int ne=
ntries,
> >                               enum audit_nfcfgop op, gfp_t gfp);
> > +extern void __audit_log_clone3(struct kernel_clone_args *kargs, int re=
t);
> >
> >  static inline void audit_ipc_obj(struct kern_ipc_perm *ipcp)
> >  {
> > @@ -598,6 +599,12 @@ static inline void audit_log_nfcfg(const char *nam=
e, u8 af,
> >                 __audit_log_nfcfg(name, af, nentries, op, gfp);
> >  }
> >
> > +static inline void audit_log_clone3(struct kernel_clone_args *kargs, i=
nt ret)
> > +{
> > +       if (!audit_dummy_context())
> > +               __audit_log_clone3(kargs, ret);
> > +}
> > +
> >  extern int audit_n_rules;
> >  extern int audit_signals;
> >  #else /* CONFIG_AUDITSYSCALL */
> > @@ -730,6 +737,9 @@ static inline void audit_log_nfcfg(const char *name=
, u8 af,
> >                                    enum audit_nfcfgop op, gfp_t gfp)
> >  { }
> >
> > +static inline void audit_log_clone3(struct kernel_clone_args *kargs, i=
nt ret)
> > +{ }
> > +
> >  #define audit_n_rules 0
> >  #define audit_signals 0
> >  #endif /* CONFIG_AUDITSYSCALL */
> > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > index e8f5ce677df7..37357e17adbf 100644
> > --- a/include/uapi/linux/audit.h
> > +++ b/include/uapi/linux/audit.h
> > @@ -122,6 +122,7 @@
> >  #define AUDIT_OPENAT2          1337    /* Record showing openat2 how a=
rgs */
> >  #define AUDIT_DM_CTRL          1338    /* Device Mapper target control=
 */
> >  #define AUDIT_DM_EVENT         1339    /* Device Mapper events */
> > +#define AUDIT_CLONE3           1343    /* Record showing clone3 args *=
/
> >
> >  #define AUDIT_AVC              1400    /* SE Linux avc denial or grant=
 */
> >  #define AUDIT_SELINUX_ERR      1401    /* Internal SE Linux Errors */
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 6610e667c728..c0106bb71c19 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2882,6 +2882,26 @@ void __audit_log_nfcfg(const char *name, u8 af, =
unsigned int nentries,
> >  }
> >  EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
> >
> > +void __audit_log_clone3(struct kernel_clone_args *kargs, int ret)
> > +{
> > +       struct audit_buffer *ab;
> > +       int pidfd;
> > +
> > +       ab =3D audit_log_start(audit_context(), GFP_KERNEL,
> > +                            AUDIT_CLONE3);
> > +       if (!ab)
> > +               return;
> > +
> > +       audit_log_format(ab, "cl3_flags=3D0x%llx exit_signal=3D%d cgrou=
p=3D%d",
> > +                        kargs->flags, kargs->exit_signal, kargs->cgrou=
p);
> > +       if ((kargs->flags & CLONE_PIDFD) && ret >=3D 0 &&
> > +           !get_user(pidfd, kargs->pidfd))
> > +               audit_log_format(ab, " pidfd=3D%d", pidfd);
>
> Do we care about distinguishing between the combination of CLONE_PIDFD
> and CLONE_THREAD vs CLONE_PIDFD alone?  In other words, do we care if
> the "pidfd" field sometimes represents a pidfd of the child process vs
> a thread in the current process?
>

Hi Paul,

Thanks for reviewing this patch.

The flags field can be use to check if CLONE_THREAD is set, so it's
possible to determine whether the pidfd refers to a child process or a
thread by inspecting the flags. Do you think we should include a
dedicated field for that?

> > +       else
> > +               audit_log_format(ab, " pidfd=3D(null)");
> > +       audit_log_end(ab);
> > +}
> > +
> >  static void audit_log_task(struct audit_buffer *ab)
> >  {
> >         kuid_t auid, uid;
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index f0e2e131a9a5..0f52e8c0e900 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -3047,7 +3047,9 @@ SYSCALL_DEFINE2(clone3, struct clone_args __user =
*, uargs, size_t, size)
> >         if (!clone3_args_valid(&kargs))
> >                 return -EINVAL;
> >
> > -       return kernel_clone(&kargs);
> > +       err =3D kernel_clone(&kargs);
> > +       audit_log_clone3(&kargs, err);
> > +       return err;
> >  }
> >
> >  void walk_process_tree(struct task_struct *top, proc_visitor visitor, =
void *data)
> > --
> > 2.53.0
>
> --
> paul-moore.com
>

-Ricardo


