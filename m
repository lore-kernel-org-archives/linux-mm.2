Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1832DC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECE536B008C; Fri, 28 Aug 2026 09:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59716B0092; Fri, 28 Aug 2026 09:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EA56B0095; Fri, 28 Aug 2026 09:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A520C6B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:04:08 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1D1A4A0391
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:04:08 +0000 (UTC)
X-FDA: 85150696176.20.8BD76AD
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CB7818000D
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:04:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sskHer5V;
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787922246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGNsWwS32agEvYOtAgbeI1ZzpY28DdOxNCH4H2BS0Ww=;
	b=o6FN0CYwfH1DusryskDEfVlbclUOCmaNBXonyQHsgfPgYvxIE1XYf2mYzAz+HiYY6Hr4Ok
	pMMyruZ4Y99Q3Jxwe3Ux4paKHXBcu35zjf+3BW9f2+mbVmr7GeqK49XmA6xcha1QIa8los
	JtOPiauYv3M9quHuLpaN/xf8xOTUNfU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787922246;
	b=1+T3j2PCEMOiwh5/hzjlFNYcPpsaSgDycfZOVeuSikgnN0s1ERRtItFzbVYcRxCPMdgS55
	RHMK2Vx3xwNlbOPRRjRwHqaPqkA7DU4/MogCZZG1htYn3MeAlGzQNtXFTMEsve2i1wlk9A
	jJZLZY19qaTCRTuMUOaTihvJP5v0XkA=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sskHer5V;
	spf=pass (imf24.hostedemail.com: domain of jannh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d3b440b97aso105545ad.1
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:04:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787922245; cv=none;
        d=google.com; s=arc-20260327;
        b=NfGO8f0nHaO5MGD6SJDwz9sI5ubZvA8flRsWy8OUAw1OqjBofnDYNWRlUbFPjL1uH8
         KruPGoJNzBTqaWZJk/a56Dc3adhXzS0XLVisj6NmUn0FE4DQJE+FDuyew7Yr2I0pBHQ5
         o6m1TX2U8cqoN9ifRrbOAYSVfSJq1gQd8Hp2MyXcF8asO2ZhY8uaZcaT3RbVCYEbBByy
         wF+zJtmAuHL02iKPtGLb33jv0mBwLuRhOqHasRKMm5vH21sLOv4j+6vxAZvNWnemf21d
         N8n98xQCr7wwg/As/hbq/Xv6pqKubWuhGQnsUVPZF4dqqmPqtX/HJsWAFQ0h7Gxy8s2U
         tMEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AGNsWwS32agEvYOtAgbeI1ZzpY28DdOxNCH4H2BS0Ww=;
        fh=CgthGiqf5lArPxyWN0nylz7+IgJfnM6gbhlnYRzgTrc=;
        b=Mb3TWXXl2TC+WSirCX25rRS40ctIyUyh+2kcXHLXMGTR4G/OaBow7aROkBBQu+rsD8
         f/tFPq/1r46ZQ33mgB6SQtUvA9w5KVnCXWw+/fc2En8wQucZrE/dMaugBEaSbBNiqAgn
         trLevPSzYy4uUav1Fs9HX2Kn/Io6XXPjaahJmc49PptbeCVQ3oYLp3Vpvr21XG/02R9C
         jLoSgwSKwqsIxCtSRqMQ00eLz28iOZ0OgFQbQ2l+YbUdLtFpLP9R64wNrqIYxlCaTMr0
         tV7X82mPPdK9mqDhB7yJWnM2q3JSQKLoli4Q7n7AwVZJGG4jeEpfeDQjkpNrOuNCrLm5
         t9Pg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787922245; x=1788527045; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AGNsWwS32agEvYOtAgbeI1ZzpY28DdOxNCH4H2BS0Ww=;
        b=sskHer5VeriKKxTjfNLnDPcWWVxCikT0ns8v7tVhvkp6zisMarnfD89MXATgeBIcZ3
         3obN1cW99z4ExkjrURQg05aJ22GHz1MwbhgBaPA5u1HSW81wIG1G8oVy7VR5wNCUJXi8
         f0kKZCFRNrvLt/Qc3xSL4EpzuAlr+oNOY3zfYKeEkFbEL3/Zawo4uEjX08HE0rUnPPJq
         GX6sTBWMf/29lj89dDmbM3eBQ/tFw6Dvs/5Nf3mvbxIc2W7NpG3uH6kSAp0xRiLK10wn
         lnOszGUi0NzyaTYJPeKihbvZYtTPY0FD0bS+zdynl2RZSSaPPKPvB/fRDtRtqzKEKjjK
         9pdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787922245; x=1788527045;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AGNsWwS32agEvYOtAgbeI1ZzpY28DdOxNCH4H2BS0Ww=;
        b=r7MKEZwGQmpszU2Nv8K55yAkZNmAyRweLISxE9hBjBK4VBHegTmU9n99t8ShKsBYyJ
         tSWHrpq+OI35NN5D+Am1MWXUseN847SMCf2bbLV/klLSutchwYaR/b7e2MUGfYQadvgQ
         xEQSb5kXNpHmJd8CyVvmVIaon29WXIromb4rqP1ZKyUhAkx4zJ3u16TIxlNfUcGoWXSE
         1viIcOlCMKH2/u0W/yUs2e5um/DooojFClFOJ/0lsgFp/NAB9MEoMJN4MbyHV/cD4wDp
         pGJyYLYeFWBkZw9Bh19Zv1Hu/PqaRiOPPsQWcFcK5lkeRjpYIRi4VXG6Y4UyiV7Ut2f7
         O7SQ==
X-Forwarded-Encrypted: i=1; AHgh+RqiSQG8HNYbIEpsanGo1IbOeWvsXJyxpcbJ+1K8iByhptpNzTpyBhGBbn24Wt1DSTas2dVB2w0DTQ==@kvack.org
X-Gm-Message-State: AFuF++mUbcPdMSkyzlzZ2H8RsK6d2351gFijvICtmnQjwRxzkc005kA6
	VoNcePnDht1Uae77HYqxE9623dMsY2vyf31SkkiP6d19U8RmppD+oWdNXYu7FmA5QEGyccn+K6n
	pdQEZ2XxytZfcz/XyllUcqdutiJvFZXulOuD3ENUG
X-Gm-Gg: AR+sD12vtjw4efR1gen7Cw2yEHoqXSzqvsxjVtNOoa8B32IV3fSnaFfBTxMfahzmypR
	yn0l4LIGDI61ehkoQYKOIq6+9yDp3VonB/3DrD9b2KmO9wFjTyTwuv2IdREvrEfCqskyHq4Z6Nx
	giBbc+aHrYiBJt4anjvXok6B/cq9AkLC0UevNt0C2OnJEgDLF44MI90Eyt6YVaBCGyCA0JWD2i0
	fb6hTVOR3Ei/1lFKaYUceN62Wlj7U3xn0wSK+3xMRypbMYpsPHhBM2OauqF34lN8DVG1Zy8JI7q
	6oIcGL3ooUdTmw9VhZhShDcbCjzNvb31SQh6Sxj5p2j8Ima+iwbpk8MV71z8rxp9NXqpkB5Vq4R
	v5RiJ9peLssvP5YqRQExiEdN3Z3ekSD06z5s19enx
X-Received: by 2002:a17:902:d2c7:b0:2d3:153d:acae with SMTP id
 d9443c01a7336-2d74f1898edmr6942445ad.0.1787922244063; Fri, 28 Aug 2026
 06:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com> <82929c994076d95f99560ecc67f6cfce@paul-moore.com>
In-Reply-To: <82929c994076d95f99560ecc67f6cfce@paul-moore.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 28 Aug 2026 15:03:26 +0200
X-Gm-Features: AcwNN1XrNltc_VuHQhdOWGeareZ_mPOwkDqM-dog-6Ggxhiy2PpwWw0NSSm2Yn8
Message-ID: <CAG48ez1rd3cFhmGn7mWkaVvGqYg+cDiGUhuhH6r51dUm-QBXUA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if PROC_MEM_FORCE_ALWAYS)
To: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0CB7818000D
X-Stat-Signature: wmb661e9nhx1hieyfcmw34m98op6cy3y
X-HE-Tag: 1787922245-23624
X-HE-Meta: U2FsdGVkX18FSo7XlGRqdl+e36RLbYnRy6l47DwdkdTrR7IPZgFJ7ePvZaZ4mQsavw3YRzd+rmG8Svw7Q8kV+dt6YhIZOgaQWjT7//PEJMUxinxEE7pSvsuzNrxn8XStoll487d5q/f+vay6HtlCrCaZlEOOIbTCbip/F0I3AMF/EUg4gk7wOJp7EbT0WlxdRVPaVB6l4Ef5DgIf96liRZ98nhW4LS4kpEHYteMNI3/qcVP+QZFs6Nwhl07O+BL563x8WpvfQKUu/E0ItFtEoM49woBaa1dQziS9RCi9ieYJOUdbYcGeTWl5W7eLeLLLVojr2b2C4PkVdPJ2EU8NdDrZL0diWbBKp8gZzBs0fD0bXEpiuW9wd6nMYsVTTRds+Ascjbntcx/lASpENYa4+9PFpKZAPu/rH85CKU8TgonXYBrPfvr+BR3m3vmm9tWXomY0lcQVInpwrjIEmp5xKF7RB/Ai9i84tuEa5NFcu34TEY8DjxZxLGgVinbhiJ2Zb2SwcUhEbOgMfWZQbILwxggP1Op3MZiCPfO3K+ETJbaYZosH9EF7ZdCN2XeUFZpBGqk87TSrlHp70HpLZ4KeKnu5dIw0loQglii3hrEwf6MqovpzIRWb6Fr3ENNstijIZU+VBst45mFcWbeWy48pvZGyVwFgPyEsDseLA4gn+CX25kTMpUSX9luI2ML7FcO+qzMFjVUVeecZtsPlNHv41UVgD2n2Rx+En4Cbit2WyKXG8XBLzcuskA1hw/ZDEU1aFRO4BvYRBZ5BBG3E6aPuxkJySufK4qHrB+71cAcfSzstshBjD28Y44XZ4i/gVYLB4CsQEdApziEYwIRZRdmwicYMhAAStMDVoHzvvGBoJwNcO3Z+zYQ/sN9tSDhATNIIWXGzS5dh0KLMMSEQUb8CjsE6mAW1NslfmzKy8PyE6r3cDNzd/3S3ZxXQVhiSbHiIkPpvJVVDbX9nOER0u41
 GZRCA/oQ
 KJ3DDabNyATtd5gCXchmgd1kvzVCKRU06OMLY5Oe+x4REfUx0N8vEZGwn8rMO/iVJhqO9bFs/PXJN96x1NQ0K3zXYQM714R0pfVc838+C7CZAqWM/OwBpZEfgMziJkvGqWDwRqREpajb8XrH4ieckZhswEOdvr7Q7TH5n7B8TeSERBu9p2FKk4sLc9Jc7pqhST3RJA7WYwnTT+opoeZVRZZgr0om6UzF820AhnpRujUveh88efZYBe7lEnGihsjJev6tgDTYernD1Aq2mTbfKGMd1UtySu/wQNgOlzjl/9pngQDZg20CsEac9rBMdrY332CgmEv+2c3sxooHVzsB5H0uQvpvj69kYTKx1uZjWmztFDruNOW/uto2MKSUlq8Ap9NKHYJOINe1yiE0Lx5TeE6cvL46iQNxeYl0tco/2u6s6RLW8GUdYWrxlBaqvEpNSRoqfpG8bjggu7fBuGDONKJAGdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 3:10=E2=80=AFAM Paul Moore <paul@paul-moore.com> wr=
ote:
> On Aug 25, 2026 Jann Horn <jannh@google.com> wrote:
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
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  fs/proc/base.c                |  9 +++++++++
> >  include/linux/lsm_hook_defs.h |  1 +
> >  include/linux/security.h      |  6 ++++++
> >  security/security.c           | 20 ++++++++++++++++++++
> >  4 files changed, 36 insertions(+)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index bec6197329dc..dc6fdcb47b79 100644
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
> > @@ -886,6 +893,8 @@ static bool proc_mem_foll_force(struct file *file, =
struct mm_struct *mm)
> >               }
> >               return ptrace_active;
> >       default:
> > +             if (priv->opened_by_owner)
> > +                     return security_mem_foll_force_opened_by_owner(fi=
le->f_cred) =3D=3D 0;
> >               return true;
> >       }
> >  }
>
> First things first, we've got to shorten that hook name :)  What do you
> think of security_proc_mem_foll_force()?

If we move the "opened_by_owner" part into a flag then I guess that
works... will do.

> Beyond that, we really try to avoid making LSM hook calls conditional.  I=
t
> can limit what an LSM can enforce, it tends to be a bit more fragile, and
> it adds some unnecessary work in the case where CONFIG_SECURITY is
> disabled.  I would suggest passing 'opened_by_owner' flag as a second
> parameter to the LSM hook and calling the hook unconditionally in the
> default switch case as a replacement for the 'return true;' statement.  I
> understand it may seem a bit odd, but we try to make the LSM interface as
> generic as possible with respect to different models and this is one way

I guess I can do that, but then the question becomes, what other modes
of using the LSM hook that don't currently exist in the kernel should
I be supporting with this? I can make this a parameter, but any LSM
policy that actually uses the parameter in a different way would
probably be buggy/inconsistent, unless other new LSM hooks are added.

If your intent is to make the hook work for any /proc/$pid/mem access,
including when the caller is ptrace-attached, then I guess I have to
move around the security hook call in proc_mem_foll_force() a little
bit. I guess I'll do that in v3, though I really don't like trying to
come up with a reasonable in-kernel API contract for a scenario that
currently has zero users.

> we do that.  It also ensures we don't have to process the 'opened_by_owne=
r'
> check in that case where the LSM is disabled.

(I don't think that's an improvement - we have to do the comparison
either way, but in the current version, we then use it to
conditionally branch to a security hook, while the v3 patch will
instead unconditionally call into the security hook.)

> >  LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_=
t *effective,
> >        kernel_cap_t *inheritable, kernel_cap_t *permitted)
> >  LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
> > diff --git a/include/linux/security.h b/include/linux/security.h
> > index 153e9043058f..74eb876054b0 100644
> > --- a/include/linux/security.h
> > +++ b/include/linux/security.h
> > @@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred=
 *from,
> >                                 const struct cred *to, const struct fil=
e *file);
> >  int security_ptrace_access_check(struct task_struct *child, unsigned i=
nt mode);
> >  int security_ptrace_traceme(struct task_struct *parent);
> > +int security_mem_foll_force_opened_by_owner(const struct cred *subject=
);
> >  int security_capget(const struct task_struct *target,
> >                   kernel_cap_t *effective,
> >                   kernel_cap_t *inheritable,
> > @@ -676,6 +677,11 @@ static inline int security_ptrace_traceme(struct t=
ask_struct *parent)
> >       return cap_ptrace_traceme(parent);
> >  }
> >
> > +static inline int security_mem_foll_force_opened_by_owner(const struct=
 cred *subject)
> > +{
> > +     return 0;
> > +}
>
> With proc_mem_foll_force() currently returning true/1 in this case,
> shouldn't the LSM hook return true/1 when disabled?

No, I have proc_mem_foll_force() doing:
"return security_mem_foll_force_opened_by_owner(file->f_cred) =3D=3D 0;"

So returning 0 means "allowed", returning an error code means "denied".

