Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29377C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 14:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F2896B0088; Tue, 25 Aug 2026 10:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2846B008C; Tue, 25 Aug 2026 10:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 144106B0092; Tue, 25 Aug 2026 10:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4B436B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 10:01:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 85D031C1A99
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:01:23 +0000 (UTC)
X-FDA: 85139954046.25.C65EFEF
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6D59C100015
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:01:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EZc4Z2Y/";
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787666481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XkjZxCxJdfT2LMn1D0Amm2coBqwtgPaPywf77Df6Gqc=;
	b=xC9weM4Y7Q0S/ODuaD/a2dghfd3hAej3cpY9/YyIdUCfloN6UIKVoORRNTflHjcDn/XPf2
	9z1JbclG9MrEn1WzHokmIKgFYmkRa4fhnJdfOSJbgPuCZTzT5r5uOOIDgadHkz8a3g+GkX
	WsfFIJF62YDY6hBXtmlSJzPB7N5ey+o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787666481;
	b=PPDVYAvrdl7h6qJNqmfZz8K/wbETxy9MBtXJC+hGzTXJDfyj8QetMAcHWidsJvScO4zIWo
	kRWdCuR3mXlTV9n4a54mZ9eZkQvOKtaqJh9VYg1eFJOUHpwhP6nadmIX0duLltubNgMWZ6
	SA46/Yz3RUsXgr64BfKv1pLdwkQL99g=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="EZc4Z2Y/";
	spf=pass (imf14.hostedemail.com: domain of jannh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2d3b445a84fso94425ad.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 07:01:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787666480; cv=none;
        d=google.com; s=arc-20260327;
        b=CXM6AeAGwqJQ4vJN+gRdwanz6IHFj9/s9r/B1UH1Cpfq38vFgtp/BoHWzKVDO3TgDy
         iXx1U8jUGrkBhH0EG9fXhoPaYTVMGdYeuO4nNBEVWbmf5EAJnhe4J9QcIhaONHK1suCL
         OszRfcXhKwI/RtumrpzKP3gj64g9UyngZBLt0gw6jTKg3qt3InaS7nc2WOY3J319ICyK
         AxMTUj9qmZjVgiDOqKH2f/X7Vw0yEN2b4afqy2IBS5CxOH5E/0++7xqEH8ncdwwKe+jX
         ZZ79kbrU/9GpAI3VbyaYQohzrKlKZXkpHdVcYScVH5IyybFHuNSsF8HernNMrOQdurd3
         vKzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XkjZxCxJdfT2LMn1D0Amm2coBqwtgPaPywf77Df6Gqc=;
        fh=BoIKiuyslMSlQSTLwpLyakTMg10XSNPkYDus07jUsBs=;
        b=KoVLXunTOesvs1zhCvlDbhoqDANYuLcsRF55wo9MmA8xme5KEMZj55koc5Vt7YE5Fg
         cC5LZyfoVVm7FkSg00/88HhIANcnzSnP0qjCBYL3ziIi9nbB2DbffT9NZhilFhPAvnSh
         0cL+6JT2rWJNtb0rS9Vn/LA/lJwzgS0/FylclU7wYR7adMjCo7amL2bIN/Q8e3l0vHN0
         Jc8tUdXsfTI39+cPcDdPFnl2C5FMWdGKJcotx5Lx3Vkcty/xGSauf//A65RCorzD9U91
         epiibbEy2tk2n5MbXCubkCdXZZKzkp14x51+UilQmBJbpZ1/HpupNpBOfTEq3L0HxNoj
         Y5HA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787666480; x=1788271280; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XkjZxCxJdfT2LMn1D0Amm2coBqwtgPaPywf77Df6Gqc=;
        b=EZc4Z2Y/nKph7xh75HF/bWbs1PdU6IZ51tPndDmjE7XiekcjdKAeRMl9x7S2QWqMCB
         8MIBtDommF+6sq4mS6ZKeNkc2Kb6L9HL9kp1QLLLLCDodE4pHsDHAZ+vWgVettr/nfs5
         Tfs3h6QNG4xb/RtSV0cQc/cYmzMbfr1kvYEoKohkERe+0bfvG0eR3Frm8BuKXFqVTpj9
         Pr2dahm82q2zKVMC4WzPjjj6/NxDv5WYzr+5wQROTwhGyii3w/UdfX50iIettIrJidXH
         LvmGMOg0dXjH+nXIg1zaIXrEJJrK8AaA9SDkGIAKRbjgjJ9W+pw1VJS58u+DGUJtCr1X
         Pixg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787666480; x=1788271280;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XkjZxCxJdfT2LMn1D0Amm2coBqwtgPaPywf77Df6Gqc=;
        b=CF6729tOO1bSX/c7KQg5dM0fOwG2WLXRRMHcLegrpQLAQQiFg8+MCmnq+8PRD7Tjxf
         isBBXFIMcKQwZPYmJybiBNfsF4Zh18luJgcwrowVBKArWBtDumRCbLOB2AC/PWO8kDFW
         1EmfmqqcuuteaYq1Kg+xaPYkx32/PSzn81NzfbdqyL5Mwb0FovpOmCtJGtH1+XuoKVzM
         xOFmte0XnqmxakKdA1Zn09Pj5kdVvLWIXM2FAbolN9VNFH2ppLZzLZ7DtV9HHkq9nQVB
         u7+BHjziM3+9l+r/60tBqPz6BBhwGRPPSmeFNdW6NjppWtYV2NG/J97/9l6U8Relv7Um
         rbpA==
X-Forwarded-Encrypted: i=1; AHgh+Ro57P7FkA05Tx7xXkqC3SoihcfhhdaoXeWqrOVmKWbr092JToXT7yKJAKEtTwXEVqd13Rx+xp62zQ==@kvack.org
X-Gm-Message-State: AFuF++mz8kQK73hjvjSlWq90fwEfWg9h2uC6vPUTbYKTH11T5vo4F25T
	fjYNnq2p5u13x/lDcEijIyKL0U2HsHxcJ0a18DIHV259UmRKNUfUeKKAPtr1I16mNxgKdQ59ofo
	eI6UoLUJn1NewwC67pLXA26JGG3I83I/oOS7yQwqI
X-Gm-Gg: AR+sD13OAdh32ErrrfVJBAhgnaignPM3lgaLVlk/0pnzO32REoCm+pAG2bmJdWF94lt
	iypPZu5pGvRJVSnwGoRIXiYl+UPJSbzCGPhcQSNgn7kA2Xmq11t/HnYbh+UK30E69jTStHVnvP1
	ya5m1AHvYpiznYrwwxi517nVaWGtuT9kjJBjhS4x1oMCLCfWm5juE+FbfgNePTJ95HIc/qbbOfl
	tC9DO1i/l6XHVCCMIjS197u82x0pwJIeduw7dZenekaFiL48HbD4OKXqETgrF+n0DWnD02VjDsp
	SAeqr4leE0lXfMHczF1hojOrY32SD+61hia6zou1yV8HFiHeemo2hgCloMmrVV6su0+tgxuiCFk
	/yCqPQQs2Lj53YFeKlZrlqWnpBLV05g==
X-Received: by 2002:a17:903:98b:b0:2ce:b436:272a with SMTP id
 d9443c01a7336-2d6e07f16dfmr936545ad.3.1787666479395; Tue, 25 Aug 2026
 07:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com> <20260825-unweigerlich-biotechnologie-abnormal-accff844337f@brauner>
In-Reply-To: <20260825-unweigerlich-biotechnologie-abnormal-accff844337f@brauner>
From: Jann Horn <jannh@google.com>
Date: Tue, 25 Aug 2026 16:00:40 +0200
X-Gm-Features: AcwNN1Vfg8wgAQZTxYtddPbSXEdmTL4JLXmxKeMr_IG98S_z91XZ1jHBOrg8fJk
Message-ID: <CAG48ez14F42BgHm5dKeP4g8D_6CNhnAfF7BXdcBwa4NdtFiaiw@mail.gmail.com>
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: Christian Brauner <brauner@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, 
	selinux@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 3bmd1q7keuttw519ybem3dmkxzp3damd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6D59C100015
X-HE-Tag: 1787666481-936031
X-HE-Meta: U2FsdGVkX1+1PKKlPAu5w60cs4D9iP5SXEDdn5aHcXcAbY7p4yojNiX8BFg7cBr/NB2sM+3OH1yW1oxncUkAHoaH+3SOhWh/oOpdGLYz1ULGaDZ95PBAryKGdit7INuFgg0j5y2X/KBLIgtrTFfmpMuvDlxv/rNb9ty0Irr0e4gRlMnhMswEdweMAckkR3VMd6NoKJvM2HUcFF+7nKbT9G8EqrEsKFkrYE3A3DiJMx5pZhxgboKlvqYPsJH2G28pDmO7TKq4yKgUC1SchCAkZO/PjdSWOaS8GSQeoLZwpF/mhv1euLMz4+Mi4NukVNvTLGylQWCseeJ0pt2Fw7brP/0ZvgG/JxIaAK/Ewq/M74Kpp5yhpW0bkRR2CfYVkhOfnYjVyGoFnB9hknR7UATtzUknz3Y6M/Qrx2wGo9uXrilz7r/QYKv2CQFPru2Gc/D/aJUdfXHoFj3slCSQ2aYWcgBPBBk0wp4wR7DtY+dZ+YOrkiDOJjWU63TiH7p5Gi5hgAq1kPSXVdTCQ9McwAIsKuW9+qnLUf6+XbhF5cpp+zsWiUoDBpXipo6DXAu6D444vfedRJt+PD1bRb3IH8RlRYhNbfxSi1IQraPLIo2i619Ni4b/Dz5LsGIMu0HysFTBh2JH96XW7Q7pcPytsXt1oNJJdUVZqXm2QXwznN5Z6HxhDzxQXBPLZtAqSPjEtftxLrwYcUK7SofM6RTqFpOPkP++gqit/vQUWfih3YHTZX7CochZ9pPDvENANOWXAQZmOXSKVxb2vv4nVc8mXPldyu2u4PIt/Uo5pQp4kJLzBWmEbBFOxz0HkjNu/FwGMRP2X1AqKXhDxWihaUt3N9tXU324hEfRnf+HM8k2XSEit6D8r5vdNkWblYgzPYbTYAu97QIwAvtjbX4PIg4XiIZoGOwZX2p7yUHWGnBsy2Wxgb18+5Wnw7mkRLH82n8lBdVlT395NYdKmluoHzed/GB
 xuRJZcj0
 7P1rIVvK47wQ1VJz7JSWKidefX+brGWkL2wHRBcnMtUsXWTdhLokB56ZfCmfQCVR1qMFwaTleRhsPxrw3EIpWgf+dRETpIe+lZUMpc0UFXmnCL4upJeslLyZ4gba3EWfLEYPYpJ1lCpF10dIIzcdEm+fcKVJm+Mnd2U28OeWhy8HJI+licE5c48Q5UypaRWR5Fgj49ZHxm4pWyYGbU/O5dZB9hjOjbnIpBtXKACDd4nGCFAYYyz0vj5UmK6Udk5LmwEcd0klpdQLlcjQy8y9FKh4OEYKWLIxbGwrS85kILygC1o93KhEL1o5SONDpSJdtgFiXG29DqKWUWp7X8eu+jP3Ltl9FZfqf8N/lPdqM7SF8k45kRAKTP+14nhF1b/jfwr1MF2SEY1ZFYrfTwFZa3/6yrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 3:19=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
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
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  fs/proc/base.c                |  6 ++++++
> >  include/linux/lsm_hook_defs.h |  1 +
> >  include/linux/security.h      |  6 ++++++
> >  security/security.c           | 15 +++++++++++++++
> >  4 files changed, 28 insertions(+)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index bec6197329dc..3dfaef49bb70 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct f=
ile *file, unsigned int mode)
> >  /* private_data for proc_mem_operations */
> >  struct mem_private {
> >       struct mm_struct *mm;
> > +     /* Was the ptrace access check bypassed due to introspection? */
> > +     bool introspection;
> >  };
> >
> >  static int mem_open(struct inode *inode, struct file *file)
> > @@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct f=
ile *file)
> >       priv->mm =3D proc_mem_open(inode, PTRACE_MODE_ATTACH);
> >       if (IS_ERR_OR_NULL(priv->mm))
> >               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > +     priv->introspection =3D priv->mm =3D=3D current->mm;
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
> > @@ -886,6 +890,8 @@ static bool proc_mem_foll_force(struct file *file, =
struct mm_struct *mm)
> >               }
> >               return ptrace_active;
> >       default:
> > +             if (priv->introspection)
> > +                     return security_introspect_mem_foll_force(file->f=
_cred) =3D=3D 0;
>
> Hm. Why not pass the reason to security_introspect_mem_foll_force() and
> call it unconditionally? Similarly it could also be called for the
> active ptracer case. Then you'd just need to pass a flag to the security
> hook and the LSM can decide based on that.

A process which is attached as a ptracer can modify memory with (for
example) PTRACE_POKETEXT and registers with (for example)
PTRACE_SETREGS. LSMs that want to prevent such debugging operations
are supposed to prevent ptrace attachment with the ptrace_access_check
hook.

I am just trying to plug the enforcement hole where ptrace-style
modification of process state is possible without going through
ptrace_access_check - which means just looking at these
"introspection" cases.

If I wanted to provide LSMs with a more granular ability to do some
PTRACE_MODE_ATTACH operations (like attaching via ptrace) while
blocking other operations (like PTRACE_POKETEXT or changing register
values), that would require more plumbing, so I'm not trying to do
that here.

