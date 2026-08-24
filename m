Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A74E9C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 17:18:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 613436B008C; Mon, 24 Aug 2026 13:18:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4306B0092; Mon, 24 Aug 2026 13:18:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1EA6B0095; Mon, 24 Aug 2026 13:18:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09E1E6B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:18:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C73A1C01C3
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:18:15 +0000 (UTC)
X-FDA: 85136821350.11.F3212B0
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9E9D320006
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:18:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SxgBO/SA";
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787591893;
	b=WoYryFC8bDF3ighZnQV6O+38QyVRiAPD2ggoj6aA2Dz8esfp5+tzH+mqAyPzjc5qkzqSxD
	EL14P6JIeRGwIugZOJintHrmqyNkAp66cjyF37L4qQu8ufbtjHW8QabN3dPOj5jM95mj7l
	i7a4n7WTuIkRUM8YSvwXAFHbaziHFQo=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="SxgBO/SA";
	spf=pass (imf13.hostedemail.com: domain of jannh@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787591893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ohGszV6/vVpjIqIrVyQqtCXHHbkO7EBoByFIi57pbG4=;
	b=1ZUIF6T/2wNajm95h9nRH1tyBZqmK3vsX6L5f2lbsDecns+MNQs73NzKn0Uojm86bcyTM+
	J254YJtQ/byg1pCLQLpFYQyb65WHZZdPap9+rjpZX1fooTSRk5CUxTYvZjJpEMtCGwypMl
	A+vq672rLDZzKeIP+dq3h4ih6/Z9jV8=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ccdf36f63dso8615ad.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 10:18:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787591892; cv=none;
        d=google.com; s=arc-20260327;
        b=mzaEv8pzzd8hASolxikf+29ssTGGHfwEeaAInkItuSz+aZPI7gaP5GONKdaZwpOwJF
         8hvQgu4cVPwLRNQa/17dE4ipZ/3F5hsw+5/ckLpBsEUkbZAAdO2dra+afu9wa67B0Sz0
         OZuSTVQCyszqHtqxrv1yIFctl5pkof9OglhHdyRSlphM67kjWrpg6aA6ezzhCFcxZalP
         S56YY0AWk8aHL7firidudzzuTinnMmQGLYxNJqv1eBlqbDLFzVZyYlU9ukGuN3fcrZus
         6JTJBo9lfzz59fyO65Z7D1WFjp4KlqI2rqh+J0X2u9OGTa92DjdVmYMH8J8lwsqYYs8J
         GpOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ohGszV6/vVpjIqIrVyQqtCXHHbkO7EBoByFIi57pbG4=;
        fh=lg19ogofLhwD02VnU4ALC8i5D8s/lpo53uCfladHEc4=;
        b=etVYvo0XJCYgOuk7wFD9XmIoPiQEiPLhpDudUb5b6i4qOTSws5lD4K0JcqWdMYYFyP
         TfV9GjiyYfu4boSv9BrD5QrDScEx3Mt0tSHvNzAR+r/MVB2KG3NImyDe7ZPC6I6Q2ljJ
         NOzfqTUFj20N2FpHO1jDsVHYE7e4lG97ZNsaUwqA3eCSvLf0MNlrJNEsjFuD31GO9EiG
         1m6Dl0lDsTZCiXryh/I1JJX5LOeNxMoTfi2wVWtbo4BAbz6ALr87sxQS2EDrLjkvQFQM
         VptfEJ5gdNoqMjEi0DcLUsE6R8MvhoNcbP+3FQCiVInWkMTlrWGflBZqNSFGQTBljsCT
         I4DQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787591892; x=1788196692; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ohGszV6/vVpjIqIrVyQqtCXHHbkO7EBoByFIi57pbG4=;
        b=SxgBO/SAngoDNgeqalFhdbm/jyVALpnZ4iCZJcg/jmt4dIa0sEMqtcBmnb8WYApyck
         aQa7MjNeuoKPZz0fPfLqXjmVE+ta0Cnx8Y+vb81z1ZBs9LRhXio+SdOch8SRxXF/Zb5T
         2oBHq/DAUZy7AGeBqj+UyDe9xfNv4DepvCmgwHq7biMTTl6tBUti1tV33BUjoCM6Qap1
         3vOBBAV1p7+o0XD62QsKR3lV4js+zC9/P/3oFblqO+dy07gkGik5p4GV7aVxD0jYA4Xu
         R4LAHipYI8UiY4x/HzdgfXyaqBe0PoOF4JlaIF01ByJ0GnVdNY9+6SdQ4XqIUYY+O8n+
         u0LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787591892; x=1788196692;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ohGszV6/vVpjIqIrVyQqtCXHHbkO7EBoByFIi57pbG4=;
        b=P1nZDA17NUr9Ld2W0qETpTlabL9QXumqrsU6XT2db2IbwetpdRPND3yYSJYHsNHdPT
         WU2CZ6zcO5fArTUn3Oxuz30q4MwUt3oX52LuOBp+jL0v06cbltkGFsZu6YMhXEi9018q
         dUCCTJAuTqAE54DMPahXA3+szDYoxxAPLiWFlztPmtw/gwS0fQmqvq4QsuC1HmFqBMx2
         17/jnHCfQEi8Ns/KH8aPVXbYdL6hnhPr1CMRGr3ua8NO+xLzMeUWFAfxk5E+kul6eR60
         uRNNP7oj5aKLCW/yeIbtjJgnuGV4Ypno7KRG+0zjajhwVKcjJkKUX2L+fxwQ4BVEz3I7
         jJ8g==
X-Forwarded-Encrypted: i=1; AHgh+RoKYT1k3Ok0Xo+VWGQVeA17PpE8uJgt8DwBMIA1NDkwLZ4w7p9vEm4iDLJPJ4j9snLzFQd3PckBnA==@kvack.org
X-Gm-Message-State: AFuF++mTziru1pKFS5rmigi1xG0teA5BSkvsz2wcNIuiWks11UoR6aaC
	gye+bZcEAZr4CueTQwOOEPV22Tth54aqV7PHLozFON2sKclELFesZsN4Iog3lvAcLCgjsulCj15
	9jySCMrfuGH6RAEB4KwaAbWdussr/fzmaCwOgASoa
X-Gm-Gg: AR+sD12YppXt/ClDEvflwPUoAeU3U307tqizt23b81SMCIQfd/J39c7+cQ1RtZWg3ep
	EOwd1UR7/dzZkM+ppOK6Dr91URQaD1toRbio6l7UZjdld7Ngx4RSasWVV9ZRDDaj5NU0X5f1TVS
	BLtrtONLi2K4LOhZxNTLULwf4XQq4x1uE/BU+aP76Vmqw1PNzO7yfWEuLS0efkw/Z/2W337/ToC
	q23HME13hJXMRstwEqD3jOTClzciqV8Zm/shIy36CqxNFbFfwRydlCikEuzOx1MpFIl90PNbfsD
	s2PFNjSAn3sl8v/k2nRYJ5/8AyOg/1k9lVOKht3GGUyAwBNaLLVy0dRMMQrEYM6UYz9yKToWoih
	MVi2foXP7T50KT7TsUqGGle3z/9j8FSs=
X-Received: by 2002:a17:902:ced1:b0:2bf:1000:d3ac with SMTP id
 d9443c01a7336-2d673bdc43fmr10817465ad.11.1787591891683; Mon, 24 Aug 2026
 10:18:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com> <aoie0oyojqdHciKM@gremlin>
In-Reply-To: <aoie0oyojqdHciKM@gremlin>
From: Jann Horn <jannh@google.com>
Date: Mon, 24 Aug 2026 19:17:34 +0200
X-Gm-Features: AcwNN1WIA9RcA5rfP1casTlSYpI1XYrEXxEhaejdTW-7MsqouUyvqUL1sH-5Z8w
Message-ID: <CAG48ez05-BOK_SZCKimPuiP_WRB1dFrzvcL2bHmOR-bChEu+Cw@mail.gmail.com>
Subject: Re: [PATCH 3/3] selinux: require EXECMEM or PTRACE for FOLL_FORCE introspection
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9E9D320006
X-Stat-Signature: epi6a45r8k3jsxjzaiw8k1bkksejrcaq
X-HE-Tag: 1787591893-18647
X-HE-Meta: U2FsdGVkX1/1yFWZch/yIleCCxCOf5d8bTNQrq+C5VWA5Z8EuKpBNPSJQ9NCNXoCOF87fU9bd4u916SGw8J7ya2otrMBFmopTNia9OS+6vU4RVMLFvaV58eh0MPlpwN7RlVx0YoQgw56CtcNSjGpM3pjBBafbCrH8jyl/QoS+Qkr7lk4upX97uaD0vA8m1Ein5vAYtgtL2e1IglZ9dP6khQGORhPxU2VhEgsjuuvliQl4EcOGq/fr+HgJcLQ15o5VTb1RTCU0VqnPWEarPYD3uWxiOmgNJz7/8LkNiDk9at2yiBZy0DLYFP97zIGYK+cO7555KXN4CZ0pyH+cnfiavXQFXkNoLB6PVCpUrUDNIUGh6gTwIWk4yIPFqJSsVpVioeV+2tHOg6YUZxAVD6V7LIXb70ympiKVL8EmxBhiLVaYML9ygvqwS3KJ8hAW3Z1W4dLNmd2BEXUAKfR7UNmU3xRmuS4bxrWx/iFwPODroQZ71T5O8WNlzIAtDFkAD4kYH28sbDciCNaTtzafve761JFrJaVf8HmAvu8TBd4jmxTAu78pae5NhA8q2HQWCk1gNelS+E1C4qR+e0BcRR3G33IPwd5M6p/Jsi2ry7+TwI3g+EDbcKxwmbdPATTfJiu9rvouB+otwX8eQGDKsKDQKAWeM6dGyV5BX3vXVf/il7ef008BiEo4zRg8Z2uyx24Ppy8PmkQ/p1Gskw4mrB5eJEM4Nb7y7ypYG61M4hm54EzAdyippl074tHY5taU/RWTSrCAQncpEQnWlN+y28OrVtexC3LrnHb7v0acQL5Wcj6IEqJR/ultCFAoPBjaUEEjMbt9eASCWe658XtLVGBYDzA84+r5lo/QF4bP2vfRXuI+95Oznxkt2u1Lbsd+KzglDcbXtQwYr3MeuPxTtpyWVYFszGxrcp0WVr48TKZdfTiqs3Gb8J06HTeaicmcghYauqd5Jj9axtIXg2VSgU
 eowny/80
 G/oV5/LEn55f+W6nZ87MVDuOH3tlwp1sNmqiIngUiTSJUpAWAt+dFN/diDv21hgFkxv2gu+1Um560apwvx7L23iuHq5Y5Ziovc2xapRny585QffiRD4j2L/0R1+hgSFqxVrzgUqw6bAzQZ+820h49sZfdjP/xMh9ZxV/sDstVoi+J+szMj36qt0PAVinSx1iq1t0x+sW2BJKNNjhBeTqHsh0F3EzxMwRrTyb7aVHgTXw99tDSJdJBJMT0P6k9jUq9jugNV/v8N2aEo9+G+O9VzxBuBjXOzy/cVhirOolXoaoj4kfKa8t59ihsALzrvBwZB+V3nARYnMlSOaYKmgsrQEM4Kr8iD53EpPNor3v7owMfuS9fUxhw9QnbcaNIZnoEI7ai4HNkEm9RZ1lnfnRtIcv7xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 8:56=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
> On Tue, Aug 18, 2026 at 09:51:07PM +0200, Jann Horn wrote:
> > On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process=
 can
> > only create anonymous executable memory via /proc/self/mem if it has on=
e
> > of:
> >
> >  - EXECMEM (like for other methods of creating anonymous executable pag=
es)
> >  - PTRACE (like when using /proc/$pid/mem of another process)
> >
> > This closes a hole in EXECMEM enforcement that Project Zero has used in=
 a
> > remote Android exploit chain:
> > It was possible to use a memory corruption bug in a service without EXE=
CMEM
> > permission to overwrite executable code via /proc/self/mem, which made =
it
> > possible to load and run shellcode with a kernel exploit.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  security/selinux/hooks.c | 27 +++++++++++++++++++++++++++
> >  1 file changed, 27 insertions(+)
> >
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index 18dd28b2bb13..905137c47321 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -2157,6 +2157,32 @@ static int selinux_ptrace_traceme(struct task_st=
ruct *parent)
> >                           SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
> >  }
> >
> > +/*
> > + * Decide whether it should be possible to read non-readable VMAs and =
write
> > + * non-writable VMAs via /proc/self/mem.
> > + * This only applies to systems configured with PROC_MEM_FORCE_ALWAYS,=
 and only
> > + * triggers on accesses that are not visible to selinux_ptrace_access_=
check().
>
> It might be worth mentioning may_access_mm() here, and obviously propagat=
e the
> suggested name change introspection -> opened_by_owner or fd_from_order m=
aybe
> even?

Ack, makes sense to mention may_access_mm() here.

Ack, I'll rename this to selinux_mem_foll_force_opened_by_owner().

> > + *
> > + * This allows a process to overwrite read-only code in its own addres=
s space.
> > + *
> > + * Creating an audit record on denial doesn't make sense here, since w=
e can't
> > + * tell whether FOLL_FORCE matters for the accessed VMAs.
> > + */
> > +static int selinux_introspect_mem_foll_force(const struct cred *subjec=
t)
> > +{
> > +     struct av_decision avd;
> > +     int rc;
> > +     u32 sid =3D cred_sid(subject);
> > +
> > +     /* Allow if the process is generally allowed to have executable a=
nonymous memory. */
> > +     rc =3D avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__=
EXECMEM, 0, &avd);
>
> But does it make sense for the shared-by-fd case? In that case you're now
> updating execmem for another process's memory right?

Since the existing check for PROCESS__PTRACE happens on open(), I
figured it would make sense to also check against the open()-time
credentials here.

(I will be changing this to check just for PROCESS__PTRACE based on
Stephen's feedback.)

> > +
> > +     /* Also allow if selinux_ptrace_access_check() would allow it. */
> > +     if (rc)
> > +             rc =3D avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, P=
ROCESS__PTRACE, 0, &avd);
> > +     return rc;
> > +}

