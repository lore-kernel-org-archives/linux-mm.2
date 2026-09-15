Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0679C88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B9A6B0088; Tue, 15 Sep 2026 13:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2CBE6B008C; Tue, 15 Sep 2026 13:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3F16B0092; Tue, 15 Sep 2026 13:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 649D66B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:24:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B158D1204F5
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:24:43 +0000 (UTC)
X-FDA: 85216671246.02.D168E22
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id B154240007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:24:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="Lwzv/9/5";
	spf=pass (imf17.hostedemail.com: domain of paul@paul-moore.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789493081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o7oag7tiLT9gQ7HZpXwTqWFezAuLM/E3QUVZxySQWaQ=;
	b=AhBGQ5nr13uCQP+vlnLamvO/yTERR5n9elBWfKBtb46UOwSknNfQ70wCuSVP37Fiv14jP6
	vRcOO+jTcVExJH/7bJhA8IqSS+TbL11uHVgZOqhC/nPOD0dc2lsxR8kZ9wHA68WoiGT7B9
	B1aQjMgXb6Z76RMLIBHm0tHDsIntNms=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b="Lwzv/9/5";
	spf=pass (imf17.hostedemail.com: domain of paul@paul-moore.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789493081;
	b=F/b/lT1Ta1KeHxoDwUIYGjkSE1cpUxhVzQwoq75S9B3/+ruMw0mDKmo2f/FUWnX8Tzb69J
	Jrm/SOnLfmdGqtPxNNlqEGlT4vs5sFsHs3Vyb8ieZffNf4ySx7ZbKyuHa/ucNCVSidyF9t
	sCcgglFZSALLdDQl9XR4Y36RGLrlAjM=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747ed1368so315085ad.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 10:24:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789493080; cv=none;
        d=google.com; s=arc-20260327;
        b=hCzHelL8847ISMSIs7sxOk2scnzCDtBuWRMkJ7g9yY6///SxnynMepPV7J2wsgtwJ3
         maMaZsiX6Y4q0beo8rFD7D8VTRHMheXHRuOlHCZhQ22CwmGWnC6ZfTAKVy3q02F6Ij7y
         uXNaRAaCzE87pW1U6EO+5SA0W9tOVg7/JmUU8qj5q8JnqTOEVqBBjwLLSoaGjiCs2GqV
         tQl+xsFXN0qJoCgOnAY3PLTaSoQenhWLDohM+ajejKU1bwF7FbHkQY9AaX6lISyFafON
         XwCzlVKE9PcYESBW6dZSY945KVj5V1PTtR+KJETp7S1RFKIgcTnDt3dCkI9dH1o7e9G9
         46Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o7oag7tiLT9gQ7HZpXwTqWFezAuLM/E3QUVZxySQWaQ=;
        fh=8BJnK/VvBSz2LOGrU+VzxDkigVB6oY56563j1DPod8Y=;
        b=GqUWsHT4X79Z28MDOpiwLYmvSK0udaLuix+Ey/P6cvx531Qvm1exKHGvSvk3rb1aVG
         15xAwIQKQqcuBGH1AfAZHpmLwLVFmowLjFszQARDUKaURAXyDwdLwcwWfrOncz0TqYMl
         mbk6rQl7Lq5SL5fAePcUH5SsjSvdxM+PSU0UwM+pemxErzZGO22N2Es5mfeRhJPCbuK1
         MAHUviryP/urLDBhES28uMaNXDn+S3PKlZ69/2VDNam5nWaKH0FUUfOqWzfLiouOG9Va
         HExXF6Hr3NzUe+kbTGA2ITFSvTAKM0QA9drukBl06/MvF5a2dXM3HH5wYSbEcNFCXSRV
         OmkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1789493080; x=1790097880; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o7oag7tiLT9gQ7HZpXwTqWFezAuLM/E3QUVZxySQWaQ=;
        b=Lwzv/9/5FUnHlQKPiOTXHj+h1P/0HGhj4XdG81Vixbc+7b2cbgrFnpSwpJNnHA1Bl2
         GlvrD5JbUJOcKHMz/GfEL0QwdQFb0LzXdNazmidbP+tSqtA4vWWYsVY20VCQEInCDiET
         ziLP4wmSYz0Rf0Zq/N1GwLvHLc9SuKn3WrPv5v0PFFuqqJ4tNfyMqWU8OPQ3o6ftNVI9
         EZL1tQrr7VlmNyfFwaFCuDDnyE4vCmSeQg2U4SUTTfti3sjijLqb+MRLhiQh4ae1yhHM
         +YdAwGG4dX/K4XoUDYegwvW8ugtkii3un+CK5DrdDTV1ksjt3txfNXwsP2FIeEM6O5Qp
         SPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789493080; x=1790097880;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o7oag7tiLT9gQ7HZpXwTqWFezAuLM/E3QUVZxySQWaQ=;
        b=2RJHWHo8QY8TLvYrWXmWSczTQAhJCvlWtHAhrpu8VWnNHk4DoRrK6QLRl4x4o4BMGt
         Cj7dvSDxPGzW7GLEDto8CI7wUuN6r4cbYd9ng+Nuoduk9GnTRo3RIyLKnKZhFcx6byHC
         S3zJ5TVpQ7G6/HLxoHd++VWG3YBppMkBu34sSuE6mZSCwXqL0j9WN/1M8c0nR5Y6AAVJ
         fw6mh5Pwlwidzj2Y9UroQdijuJrGenkDUv/TKoV6zVv8O8k9ZHYljN+FGByyY2YTmRQs
         g/5pU9WSE6gQCps+0OcsGypbJQ2qnDGaOtHf2WvhPaO7eBkuhC+YuYOGIApYyYevO/Vk
         vc3Q==
X-Forwarded-Encrypted: i=1; AKwUvBy6u/jIX7hiVT9PA6Txx0K2o8O4j35M+jVUS9jDEWewJZtlDdxXHp6soUpZ32/ebRf2fKMczXBQiA==@kvack.org
X-Gm-Message-State: AFuF++mMP+0QO4oY1WEz9KvBj/NzglVmqsNvx3Y+RELEodVSoUVMlgBr
	Kc7FQq7o8eZcOrxXxWKPdNDOGsOXUHrgJ/IGl4AKKUy/VcQ1PRGl2F5E9Fb/4Qg4Hl+kqE+W9Hr
	GpKcJdfKenDRzfROGixpQq1VV8NI6Yh8JFCp0TC2A
X-Gm-Gg: AYBFou3cHV1WhKDR2y84v10PKUBKOOWFOWw2LwZLnvRmYfr0B8RQt7/1mBtgzd9Mcri
	uA45pxZAtx13hHr28l90X00kcPXzuTWmPfCjroAEAfQcSiHOaHPAQy6QTp7cqyFjZOom8XHiYQg
	6jQiJrgQw0jhTiSNIFrftb23HAZfYQhGyMb52bKySOLeSxHHy/Iy7jObvF/pDfpHb1A2UdpujHa
	la0Gv0vjuyTKxEPJGcTUo1XK2u5pa5F/0Nui/JkHwPa4bJdw/jFMJn6HKzcDSihWmwk1IsojSTC
	5L9EJRe34XMKYw1ZHC8n/iNd86bgd93+TCbUDuU1X294axqUekVBMBDcXKrqNjsfFD4LL+agjDX
	5QKVJOO1TPX7zPxewEppdnw==
X-Received: by 2002:a17:903:17c3:b0:2d8:d4d0:7930 with SMTP id
 d9443c01a7336-2dd6c774465mr154307025ad.20.1789493080252; Tue, 15 Sep 2026
 10:24:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
 <20260907-selinux-pokemem-v3-2-0bafbaeafe50@google.com> <aql6gyQJoxEjx0xY@shallyn-amd>
In-Reply-To: <aql6gyQJoxEjx0xY@shallyn-amd>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 15 Sep 2026 13:24:27 -0400
X-Gm-Features: AcwNN1WSVv7LZW6UVyRb9JR3csRFIsKvXqH5B9SYVb6JqyH17r20MARaxjq7-ak
Message-ID: <CAHC9VhTjo+znkxBmvseCH1K3aJN18ZO7+6QGE-a+Sy6XN=uaMQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: "Serge Hallyn (AMD)" <sergeh@kernel.org>
Cc: Jann Horn <jannh@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B154240007
X-Stat-Signature: q5z98oemgajecfa7bf1qfpuwrpm3okin
X-Rspam-User: 
X-HE-Tag: 1789493081-406457
X-HE-Meta: U2FsdGVkX1+KW36oZ1OluXQ7MF4w2A93YVApAm9oDA72UixMfxMqUydBHskhQy41Db4uiiIowCpPcG3BMv3NCf1U2ByEEcamRrCLoNGoFr2aa4nRrvxSMRZItKNvDO3QKub/t8Q4Z+KChqRZHYHgrUDn4AFiHtG+asMh+wzc0lSIIW78AciCWjM06i5XjACndfhDWdG3bLCop/TXazHl+3EGJOP2KFtW3hB5aPUmK327WzhfiqmekuzF4TFdaVYFfxfbe2jh67bi7rnUzDXIOPGIZHS1VFcSqc9Yd3CR0R8y+B6IFW0MqbyZQcC2Nzeb0SoNrrb6XEgr0Oj4HFQBcxLcbWTHGQPeurqRgxSgnd8kDtbbIFw2FG8Up8gTP0WBDW14NEc4pLFg/zubMvfdUrf77/YCrkQUWxE3ybKcmKaD12yE7aMJ7KfqZFcqfPmD1KvG3+IT5dXSZ8XPIkFi1krhGaJYtHD1hDBiHPgN/2nhpSbKmHA3U6fWWe/y2zfGYz1AVF0CyK80f0jyXgC+7B9tftbSeKIoVhhyvTiMKvH5Jwvm10CcnWq48jz7lsjXfkzZNarE8O1h+zmWLnaAQkIEjcTfioFBHW7qnSnTXl6yxdGL5dPyyi1fPlcrZ3rnBf8z1w5XjYdryrzkk0B04M9abzrkwX9/eREC5/oLvU+s6z5VOON9sT/k5QOxmVy0Ijzkr35IrYlokSmJkDYoFohYAeMK4/s+NpfMO3aS6UXhPwvCcptgedbPzDgd5qrOp/ZbACEGg9VyCzgrI5vS3vsNaOjhYY3YyuOAmgvC/3N13VTUmlIVl92LnaGKJokhsH1hkHyMYyrVRKYMK0ALbXOj0a7PTXA1OpYMgdfsWyFtUxMgWb0UKu6rnG8ny0IgT+jW/r9G7Zb2c+u8HDoM9urjNVTDNqY7lsBXq2q9X/PkIfP1PDLmeFx+vbdU1ozwAfNk9VdsbAeOXdJbXxY
 MDnDcgY3
 i2qU3JIeSIaX0mzixv8idZwrrpJyioDbNpDgbeQ7OTJXlGFMpZBrM1TD1hMR5AKu3yLVsS1ZyWHpIVcWsorpnSJQMAF1EwdGLxWBCLC7lAgXvvzqr5iagc3Pdq993cEZgPrTQ7ubOifzyLE4vAu/V8CAGqgD6mJ4+OYHNZ/HJStk7HSUn7P5t6780Q+bV6YW0LYIidn6c7+P9U8Dx89YyH3B6r5c4RA8Pw7ru6eE5WDIFcxHRZUpa934R3GsXX5FhvQhOJWfAxjSrcI/ONXKv/p/2JrdROtYEh2QW4nNJVU5e1NyHchqNITVSytDebLX1F7ndFhwgQdFzceLcIEEab4qOUuwjjl5wCOizDj9YunIfDEGzMGz/pur8QYLFngqgLpgzpCm5lNxNfLsbHensm9FeG/Rn4sWtBUZBdScK23IQkn4ibP9Sk/ZidTGiSHwhe+H5FEpvtgB5WrRiDhESlrlFSoAW6QW4VtmC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 1:04=E2=80=AFPM Serge Hallyn (AMD) <sergeh@kernel.o=
rg> wrote:
> On Mon, Sep 07, 2026 at 11:00:17PM +0200, Jann Horn wrote:
> > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently hav=
e no
> > good opportunity to block a process from overwriting read-only code in =
its
> > own address space through FOLL_FORCE writes via /proc/self/mem.
> > The security_ptrace_access_check() LSM hook is bypassed when a process
> > opens /proc/self/mem because this is considered "introspection".
> >
> > This causes a hole in SELinux EXECMEM enforcement, which tries to ensur=
e
> > that a process cannot create executable anonymous pages.
> >
> > PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> > accesses are only possible when the LSM allows ptrace() attachment; but=
 it
> > is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> > environments running lots of third-party code, such as Android.
> >
> > So, introduce a new LSM hook that can forbid FOLL_FORCE specifically fo=
r
> > such "introspective" accesses.
> >
> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  fs/proc/base.c                | 14 ++++++++++++--
> >  include/linux/lsm_hook_defs.h |  1 +
> >  include/linux/security.h      |  7 +++++++
> >  security/security.c           | 25 +++++++++++++++++++++++++
> >  4 files changed, 45 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index bec6197329dc..295b21203c7f 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -851,6 +851,11 @@ static int __mem_open(struct inode *inode, struct =
file *file, unsigned int mode)
> >  /* private_data for proc_mem_operations */
> >  struct mem_private {
> >       struct mm_struct *mm;
> > +     /*
> > +      * Was the ptrace access check on open bypassed because the opene=
r used
> > +      * the same MM (introspection)?
> > +      */
> > +     bool opened_by_owner;
> >  };
> >
> >  static int mem_open(struct inode *inode, struct file *file)
> > @@ -864,12 +869,14 @@ static int mem_open(struct inode *inode, struct f=
ile *file)
> >       priv->mm =3D proc_mem_open(inode, PTRACE_MODE_ATTACH);
> >       if (IS_ERR_OR_NULL(priv->mm))
> >               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > +     priv->opened_by_owner =3D priv->mm =3D=3D current->mm;
> >       file->private_data =3D no_free_ptr(priv);
> >       return 0;
> >  }
> >
> >  static bool proc_mem_foll_force(struct file *file, struct mm_struct *m=
m)
> >  {
> > +     struct mem_private *priv =3D file->private_data;
> >       struct task_struct *task;
> >       bool ptrace_active =3D false;
> >
> > @@ -884,10 +891,13 @@ static bool proc_mem_foll_force(struct file *file=
, struct mm_struct *mm)
> >                                       READ_ONCE(task->parent) =3D=3D cu=
rrent;
> >                       put_task_struct(task);
> >               }
> > -             return ptrace_active;
> > +             if (!ptrace_active)
> > +                     return false;
> > +             break;
> >       default:
> > -             return true;
> > +             break;
> >       }
> > +     return security_mem_foll_force(file->f_cred, priv->opened_by_owne=
r) =3D=3D 0;
> >  }
> >
> >  static ssize_t mem_rw(struct file *file, char __user *buf,
> > diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_def=
s.h
> > index 65c9609ec207..12f84a1e6fab 100644
> > --- a/include/linux/lsm_hook_defs.h
> > +++ b/include/linux/lsm_hook_defs.h
> > @@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct c=
red *from,
> >  LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
> >        unsigned int mode)
> >  LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
> > +LSM_HOOK(int, 0, mem_foll_force, const struct cred *subject, bool open=
ed_by_owner)
> >  LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_=
t *effective,
> >        kernel_cap_t *inheritable, kernel_cap_t *permitted)
> >  LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 153e9043058f..e8bc2e644241 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred=
 *from,
> >                                 const struct cred *to, const struct fil=
e *file);
> >  int security_ptrace_access_check(struct task_struct *child, unsigned i=
nt mode);
> >  int security_ptrace_traceme(struct task_struct *parent);
> > +int security_mem_foll_force(const struct cred *subject, bool opened_by=
_owner);
> >  int security_capget(const struct task_struct *target,
> >                   kernel_cap_t *effective,
> >                   kernel_cap_t *inheritable,
> > @@ -676,6 +677,12 @@ static inline int security_ptrace_traceme(struct t=
ask_struct *parent)
> >       return cap_ptrace_traceme(parent);
> >  }
> >
> > +static inline int security_mem_foll_force(const struct cred *subject,
> > +                                       bool opened_by_owner)
> > +{
> > +     return 0;
> > +}
> > +
> >  static inline int security_capget(const struct task_struct *target,
> >                                  kernel_cap_t *effective,
> >                                  kernel_cap_t *inheritable,
> > diff --git a/security/security.c b/security/security.c
> > index 71aea8fdf014..2cde1efdb7a6 100644
> > --- a/security/security.c
> > +++ b/security/security.c
> > @@ -595,6 +595,31 @@ int security_ptrace_traceme(struct task_struct *pa=
rent)
> >       return call_int_hook(ptrace_traceme, parent);
> >  }
> >
> > +/**
> > + * security_mem_foll_force() - Check if FOLL_FORCE is allowed
> > + * @subject: credentials using which /proc/$pid/mem was opened
> > + * @opened_by_owner: whether checks on open() were bypassed because th=
e opener
> > + *                   has the same MM as the target
> > + *
> > + * Check if FOLL_FORCE is allowed for accessing process memory through
> > + * /proc/$pid/mem. opened_by_owner signals whether the opener's MM was=
 the same
> > + * as the target MM, meaning the security_ptrace_access_check() hook w=
as
> > + * bypassed on open().
> > + * (Current current->mm does not matter for this; for example, if writ=
e() is
> > + * called on an FD that was received from another process which obtain=
ed it with
> > + * open("/proc/self/mem"), @opened_by_owner is still true.)
> > + *
> > + * Note that this hook is only designed to be useful in the opened_by_=
owner
> > + * case, where the subject credentials effectively also describe the o=
bject.
>
> Given this, would it make more sense to call the hook something
> like `security_mem_foll_force_self()` and only call it in the
> opened_by_owner=3D=3Dtrue case?

Sometimes we can't avoid it, but in general I'd like to see us avoid
calling LSM hooks conditionally, I'd much prefer the hook
implementation (either at the LSM framework level or the individual
LSM) do the conditional check.  See my comments on the previous
revision.

> I only suggest it because it seems to lower the cognitive load
> when looking at this code, so it might make it easier to maintain.

--=20
paul-moore.com

