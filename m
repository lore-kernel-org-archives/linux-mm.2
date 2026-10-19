Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F897606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 19:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=JRPQ7Wdi
Received: by kanga.kvack.org (Postfix)
	id 830BA6B00F8; Mon, 19 Oct 2026 15:32:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808596B00FA; Mon, 19 Oct 2026 15:32:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71E7D6B00FB; Mon, 19 Oct 2026 15:32:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 983546B00F8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:32:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1D2C31C41B1
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:32:33 +0000 (UTC)
X-FDA: 85340372586.18.D388F94
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf03.hostedemail.com (Postfix) with ESMTP id 319A920009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:32:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JRPQ7Wdi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792438351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UDVr2jRR6Ik9p8PRWRYl4J4mWZgBLdNkTR6eKk/XdxA=;
	b=6hzo53mTMw26Ix5IiG+r7hf/zaZ6Lvk644VljK8i9O9UU65LsfQE7PjUGqCyTaPIEUvIki
	h/X8JQbuiYhgGPCZxTSqF5yiDtwy0gj+/r0H6p5XdbHq9dWoKezrkS5fSUNEGWCI8ZO94x
	WYBasdYuQONjLhA3eaMWVp88d/PAdTY=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JRPQ7Wdi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792438351;
	b=GYjsl1NA/BvQlqzRPQdWo44yDV07CxgG+ts9s02siLufBbs8UPDCZ7Hr8zdz6wxVl2jy8c
	0KVbgABdRYkkx4PpinjTInTfVki7+WU+G35lTvSrB589LemWWrF2vlgL1PqrrerfDR7oYi
	ZgC5rRFOJxBIIhtIxnY/uQYmS4pp890=
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b1aa377c61so2963097a12.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:32:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792438350; cv=none;
        d=google.com; s=arc-20260327;
        b=QPW1JJbh5Oc9kd8XlpZuSQ/fQWL11oTuhEclm6UUbF+TvJJVRvYJqbD8jaIQ9H+tww
         LpnEEcTfmuxjQpFJwlbyMncGSbcWseFk08Mj/NUBsk675s+kQModTGztbhuQIzTzvLps
         fggkmbm0kQ6bbBUqr/rsxersn5ElMz1AJs2OAUU0HT/FIT3cXHaunPGZCrs0SChqZ7GR
         hUBfaqlHHX0H23dPM7BwiHal7Ykb5PR06bhpVsYBkNw8bXNdwdRExrxSNrs+3mx2YJJ1
         ufykkYZcitK6pzUvMxfP4CgyVuPqabIKNNZEpI+QD9m9/qnwHZdcKbXgsu9FcyRrplra
         OKmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UDVr2jRR6Ik9p8PRWRYl4J4mWZgBLdNkTR6eKk/XdxA=;
        fh=qZh2PzJbcOEcpfAVVf9+MiU81XRLkY1No3v8uG1UUnc=;
        b=BEjhRXnPjroo240IQSzTwf1NfvPhhZec/Gd4HX8lbn0trwSYvb1lx172xKFslSxp9m
         z9crJPPtbuobDMlL+bGFM3IGKPyPwJyo3GZ7Npe9xpQsWmo24a07tdOKuN+azzpICQDw
         YmMGm4HsJfnC3bmNVAB8j013e5WGu1R1F9o7bWz7FlE5Mzj0+weKOFZ041z31ZKROqqs
         vt79+Pj6s7loNWuHCTzn6fxLfWayXVhkURvEHYwl3VonFFreHllFmzRd3O3LAufgIiS0
         zFAXWC4wx6hJa1auGuU3+oXA34v41BZCt0CoOFyqVQAEGCJNX4p6nxxp13WVy5mAA4oq
         VLBw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792438350; x=1793043150; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UDVr2jRR6Ik9p8PRWRYl4J4mWZgBLdNkTR6eKk/XdxA=;
        b=JRPQ7Wdiim4Y3XUcEigqYXwibV5p6LWTeFayKMg4qyRmSrmzjqMgztueoufKA+0fV6
         f7M1Uu7AJk+b6cWZtAfD475IbXbZvqofx4pptog76TqjPObQo2BepGEw2wAaGXBVsqKu
         PqgfVQ9dPi52eipiq+AjLAMIEF/sM2X+5fSl3I54gZ0M/jMzffJYqAfX7i7mQ88wqDw+
         8msk8m6pyJFBiZHZkEQGunviUR8pY9z7bwhzej1lJgdk6WQBhRZDAI1ZEKQRwUNcEql/
         Mz4Ye8YHwOxugxEFaQ7lCeJf+HzFtfzJS3OZZ1Q5gKKcTuDNeBl80GrKZxDdOUfqQeLT
         ZXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792438350; x=1793043150;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UDVr2jRR6Ik9p8PRWRYl4J4mWZgBLdNkTR6eKk/XdxA=;
        b=OsJatoHeMVBh1jC5Kr5TiMKpggsBDGhCL0Vu71zwYdKuCaNNGnhkjd2RW4JAw6NZSh
         Z0jFs0cRyuteVLl9JwOtiDPvndpZwTWC9wRieaD1OKHtgTsdNko3dQu6HxM1Bq+Gu+P7
         rqODW5EFilcjMBmabfuhvj1FVi8BVRWVx/qkTiO3V3DMmSN6mSlzhrxnQja45FjQYBDf
         fhz96pQGn5a3WZnd3tv25q5FNb2EWzhHQ4kLIP8tlOH17TIuKsKcAxpn/qTze7V9m/Hl
         nM5ql1NuAg6tkk84Dad9m0nLZZsMdLX7hciw/W42YRnVJvS86vyBSiQqCv9lOU4QgIuJ
         gxXw==
X-Forwarded-Encrypted: i=1; AKwUvBxQqLA51aRTI64t7Qi7HFAGN5JRb43wV2JrN0SN3AwX9rFgl/oiOoJtdq4dArGCPoG5L+DeySoL3g==@kvack.org
X-Gm-Message-State: AFq9FYJcjyT65a+/YqNn+pqzgHXKrm2YEaR1jFmF2VhChDxkiY/YAtYb
	zkPQxkRax8HRVNAW4uUoUXU4tvjuiLC1Z2X8TOvttRRd3MafftvnGtvtIOviyesqUvM0xNEJo/0
	8r3pXS93XmDAtaY7VTldfvy497zH7iiJWW25k+xcIWA==
X-Gm-Gg: AYBFou337KSoQ0YiU+thdW3dwBzPwIzlKmMjw8cqGJIn2RnOkOiKP/LunvgUNlENZ0C
	Pe2GT/QH5Q1tjia7KQeioKHjKn7Z4LSbRJJe+yRtGN69oRy8by1sQqLXDqI9Sl4FL3o3nuqZTWK
	oQc6O7NqFm5PIdMhaXl5SQidgx6pCT1ebGkBsmQImAmt72RDJSDzDG1OngLaGO1PPj8k/yQifTV
	SAdm4kw1a/+YxIT5xMu6QbPgWdhsZUg9cnvB17kIndBnIEOzU/8K6x/Lr+pYFvsWVJ+nV86eMUC
	Ne9NzTSy/uhlGk8tXgwlsPnSdJxAeGlzanWhwnGHBkJ66JK8AvcSN3lEHgruWdLlpiB+t9cQRkK
	6xCQ2gQbz+151Nh5E7oLFmDCvPyJjOs5Ymp/GLr2xm3mDFzONvcGCIY53NRl7K9/Ccxs=
X-Received: by 2002:a05:6402:46ce:b0:6ac:9a44:d404 with SMTP id
 4fb4d7f45d1cf-6b3a80333f9mr4787170a12.0.1792438349280; Mon, 19 Oct 2026
 12:32:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261015093816.2438942-1-pasha.tatashin@soleen.com>
 <20261015093816.2438942-4-pasha.tatashin@soleen.com> <9huzwlrdh4q4.fsf@tarunix.c.googlers.com>
In-Reply-To: <9huzwlrdh4q4.fsf@tarunix.c.googlers.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Mon, 19 Oct 2026 15:31:50 -0400
X-Gm-Features: AclHuK9RhOF8P0_iSDq0R6E-rGot2pIUv8sHnfpDWRrrJfxNdPKGST9db7rmV8M
Message-ID: <CA+CK2bD83qVv54_Wps4GRr9otg32pW2A01WVTo-gTR=oYs95Vw@mail.gmail.com>
Subject: Re: [PATCH v1 3/7] liveupdate: Pass user argument to file preserve
 and retrieve
To: tarunsahu@google.com
Cc: linux-kselftest@vger.kernel.org, rppt@kernel.org, shuah@kernel.org, 
	akpm@linux-foundation.org, linux-mm@kvack.org, vipinsh@google.com, 
	linux-kernel@vger.kernel.org, dmatlack@google.com, kexec@lists.infradead.org, 
	pratyush@kernel.org, graf@amazon.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 319A920009
X-Stat-Signature: jwh5i3r1su8ihp781wqpu5cbqdqu31ix
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1792438351-257625
X-HE-Meta: U2FsdGVkX19p+5TMmI7jQ9KBNTrKakru5SY1yePWq0jPoZNHiLz5RVlPWG0St/0G5AIUStUVLIKFDXz6P9oZY0AvVDkiR8LKNDTY10TgsKqQOrlupEtt/Uyuh3dHCpZZJ9ev2D7FKnh99qNxe0Ep4bkVy5W10VqxIqVS0dMpBGRR/kI0593CkvTyHfePQMh/TjTYSpaV/z3y2VQfKasuE2CYIKR95TKY77gGxIpIvzPZYLao1YiJaAi8WzjUBh7I5sCwSVWndr8fyMWhlKp8EPVM4xRJdY8gWaDqelVpNEnGOejPAMr1VdkdgM9XIOWRT9TAZITYUgt/89t328B+unbrFMKhkzxN0SdXPpeTmcS+gXJfwKic0JpMdDFMXopM0uaBqpL6ACxGCaemyGRI3wJ5fmRREDoB49KFkGFOWXMq8LPx85x8JRVrIHsN79r8ZxepZXgIg6MZQys56ptTd0e11xSvNpvs0po+lpPxb4w1l+zK16hqpr5hk0kna3WxzQvjwinF0mv0F67az5VLE/HrOXJoWWYKhZY383vKaVHW26Fsj8ki5Z12/9sTpCHaJvp/gx1b/D5cZt4FX/NtboYKKqHhQyN0uDqLRiFixagXm2voQ2pBGGKCCgfR5IwGzCbi+Cfwg4VZLWhwuNRqzxMCyGaJ3OXySQi2RrYNrI4Ytu2DlPH4L+NxExVX16p4NaD8hB6RGar4fEdDFDM3IAt2bQ1X0oB/tGTj7BHTTeCJ3KI9n6PLCyPyEgLhaTgldtOQrX93tITDNUR3rs2WY/i1mWQJk8MLxV+Jv761+0kQPT/StuHc2bZ7HaJAum2kICdRu58cotqEaAGDP3j8SSWe4YKEGtGYVo8AVEFeuDr+cMW2rAwg7YynNY6U2p2K0s88db5UbcgXrRa1gURnoSfUxP+DFEv4CgR8h3sqb1oVVHTvl+ljcht/e1qTmbJ+dIN5vrhS47x5kQIIiWA
 RSXQ2spP
 WMIYoSKQrhn8jOjKqJxteVfoGcsEifeEmlv2dOBoYeCob8nydQYJr6VCNZo8KSxxwgrXhZTiJuP5wSuUKGcyjE9qMbbBMFOMI8zqTXnAWrA0SQgur/AMkZLfubI33ufHw9g4ehjK8mgaL9JTeiLTjULz/4GHv0TPrwPHumZUxwJMSaB/eiKRYQhERw+GUi1hhGqFeIbbcBA4/IpBZ+ighdQ4Z2jejfRBU5kXxxfo5Wq/hhHHJS22AcOUFskcz16vCIL5PFEUcPo33OyS5GvFZ1q22sKVANiUdd9GrKKhJBokcY6U6nFqXhiECv4bn7wjo/Osw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 3:26=E2=80=AFPM <tarunsahu@google.com> wrote:
>
>
> As Per Today's Hypervisor liveupdate meeting, This patch will be picked
> by @dmatlack@google.com for latest tmpfs preservation series.
>
> I have a suggestion to make here.
>
> Let's send this patch as a saperate patch so that I can also use this in
> my guest_memfd preservation work. This will help landing this feature
> sooner and unblock other subsystem who needs it.
>
> Let me know what you think?

Hi Tarun,

You can include this patch the next time you send your guest_memfd
patches. Whichever series lands first will pull in this change.

We are trying not to merge new features without an actual user,
especially ones as important as those changing the uapi. I think tmpfs
preservation may actually make it easier to land, as it only changes
the code that we maintain.

Thanks,
Pasha

>
> ~Tarun
>
>
> Pasha Tatashin <pasha.tatashin@soleen.com> writes:
>
> > Allow userspace to pass a file-handler-specific argument structure when
> > preserving or retrieving an FD via LUO. File handlers may need
> > additional context during preservation or retrieval, such as a target
> > FD, device location, or handler-specific parameters, without introducin=
g
> > separate ioctls for each file type. Whether the argument is required,
> > optional, or unused is defined by the file handler.
> >
> > Extend struct liveupdate_session_preserve_fd and
> > struct liveupdate_session_retrieve_fd with a 64-bit arg field pointing
> > to a handler-defined argument structure that begins with a 32-bit size
> > field. Because IOCTL_OP validates a minimum size up to the token field,
> > existing callers passing the 16-byte struct remain compatible and have
> > arg zero-filled by copy_struct_from_user().
> >
> > Add parg and rarg (struct liveupdate_arg_spec) to
> > struct liveupdate_file_ops, initialized via LIVEUPDATE_ARG(_struct,
> > _min_last), which records the full struct size and minimum required siz=
e
> > while enforcing at compile time that handler argument structures begin
> > with a 32-bit size field. When arg is non-zero, LUO validates the
> > minimum size and copies the user argument via copy_struct_from_user() u=
p
> > to the handler's expected size and passes the kernel copy in
> > struct liveupdate_file_op_args, or returns -EOPNOTSUPP if the handler
> > does not accept an argument.
> >
> > Also provide liveupdate_claim_file() and liveupdate_unclaim_file() so
> > handlers whose .retrieve() callback restores state into an existing
> > user-supplied file descriptor can claim it in luo_preserved_files befor=
e
> > modifying the file.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  include/linux/liveupdate.h       | 60 +++++++++++++++++++
> >  include/uapi/linux/liveupdate.h  |  6 ++
> >  kernel/liveupdate/luo_file.c     | 99 +++++++++++++++++++++++++++++---
> >  kernel/liveupdate/luo_internal.h |  5 +-
> >  kernel/liveupdate/luo_session.c  |  6 +-
> >  5 files changed, 164 insertions(+), 12 deletions(-)
> >
> > diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> > index 885ec0bbc4b8c..52d3f453ae011 100644
> > --- a/include/linux/liveupdate.h
> > +++ b/include/linux/liveupdate.h
> > @@ -22,6 +22,36 @@ struct liveupdate_flb;
> >  struct liveupdate_session;
> >  struct file;
> >
> > +/**
> > + * struct liveupdate_arg_spec - Specification of a file handler user a=
rgument.
> > + * @size:     Full size of the argument structure in the current kerne=
l.
> > + * @min_size: Minimum valid user-supplied size (offsetofend of the las=
t
> > + *            required field).
> > + */
> > +struct liveupdate_arg_spec {
> > +     size_t size;
> > +     size_t min_size;
> > +};
> > +
> > +/**
> > + * LIVEUPDATE_ARG - Validated specification of a file handler argument=
 struct.
> > + * @_struct:   The argument structure type.
> > + * @_min_last: The last required member in @_struct.
> > + *
> > + * All file handler argument structures passed via
> > + * &liveupdate_session_preserve_fd.arg or &liveupdate_session_retrieve=
_fd.arg
> > + * must begin with a 32-bit @size field so they can be extended compat=
ibly.
> > + * Use this macro to initialize &liveupdate_file_ops.parg and
> > + * &liveupdate_file_ops.rarg.
> > + */
> > +#define LIVEUPDATE_ARG(_struct, _min_last)                           \
> > +     {                                                               \
> > +             .size =3D sizeof(_struct) +                              =
 \
> > +                     BUILD_BUG_ON_ZERO(offsetof(_struct, size) !=3D 0)=
 + \
> > +                     BUILD_BUG_ON_ZERO(sizeof_field(_struct, size) !=
=3D sizeof(u32)), \
> > +             .min_size =3D offsetofend(_struct, _min_last),           =
 \
> > +     }
> > +
> >  /**
> >   * struct liveupdate_file_op_args - Arguments for file operation callb=
acks.
> >   * @handler:          The file handler being called.
> > @@ -39,6 +69,11 @@ struct file;
> >   *                    is not preserved. Set by the handler's .preserve=
()
> >   *                    callback, and must be freed in the handler's
> >   *                    .unpreserve() callback.
> > + * @arg:              Kernel copy of the user-provided argument for .p=
reserve()
> > + *                    and .retrieve(), or %NULL if none was provided. =
Allocated
> > + *                    to the handler's expected argument size with any=
 trailing
> > + *                    bytes beyond the user-supplied size zero-filled.=
 Valid
> > + *                    only for the duration of the callback.
> >   *
> >   * This structure bundles all parameters for the file operation callba=
cks.
> >   * The 'data' and 'file' fields are used for both input and output.
> > @@ -49,6 +84,7 @@ struct liveupdate_file_op_args {
> >       struct file *file;
> >       u64 serialized_data;
> >       void *private_data;
> > +     const void *arg;
> >  };
> >
> >  /**
> > @@ -67,6 +103,12 @@ struct liveupdate_file_op_args {
> >   *                resources in the session.
> >   * @finish:       Required. Final cleanup in the new kernel.
> >   * @get_id:       Optional. Returns a unique identifier for the file.
> > + * @parg:         Optional. Specification of the user argument structu=
re
> > + *                accepted by @preserve, initialized via LIVEUPDATE_AR=
G(). If
> > + *                unset, non-zero user arguments are rejected with -EO=
PNOTSUPP.
> > + * @rarg:         Optional. Specification of the user argument structu=
re
> > + *                accepted by @retrieve, initialized via LIVEUPDATE_AR=
G(). If
> > + *                unset, non-zero user arguments are rejected with -EO=
PNOTSUPP.
> >   * @owner:        Module reference
> >   *
> >   * All operations (except can_preserve) receive a pointer to a
> > @@ -83,6 +125,8 @@ struct liveupdate_file_ops {
> >       bool (*can_finish)(struct liveupdate_file_op_args *args);
> >       void (*finish)(struct liveupdate_file_op_args *args);
> >       unsigned long (*get_id)(struct file *file);
> > +     struct liveupdate_arg_spec parg;
> > +     struct liveupdate_arg_spec rarg;
> >       struct module *owner;
> >  };
> >
> > @@ -237,6 +281,11 @@ int liveupdate_reboot(void);
> >  int liveupdate_register_file_handler(struct liveupdate_file_handler *f=
h);
> >  void liveupdate_unregister_file_handler(struct liveupdate_file_handler=
 *fh);
> >
> > +int liveupdate_claim_file(struct liveupdate_file_handler *fh,
> > +                       struct file *file);
> > +void liveupdate_unclaim_file(struct liveupdate_file_handler *fh,
> > +                          struct file *file);
> > +
> >  int liveupdate_register_flb(struct liveupdate_file_handler *fh,
> >                           struct liveupdate_flb *flb);
> >  void liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
> > @@ -269,6 +318,17 @@ static inline void liveupdate_unregister_file_hand=
ler(struct liveupdate_file_han
> >  {
> >  }
> >
> > +static inline int liveupdate_claim_file(struct liveupdate_file_handler=
 *fh,
> > +                                     struct file *file)
> > +{
> > +     return -EOPNOTSUPP;
> > +}
> > +
> > +static inline void liveupdate_unclaim_file(struct liveupdate_file_hand=
ler *fh,
> > +                                        struct file *file)
> > +{
> > +}
> > +
> >  static inline int liveupdate_register_flb(struct liveupdate_file_handl=
er *fh,
> >                                         struct liveupdate_flb *flb)
> >  {
> > diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveu=
pdate.h
> > index 1644c502521e0..57a3c129d5a9d 100644
> > --- a/include/uapi/linux/liveupdate.h
> > +++ b/include/uapi/linux/liveupdate.h
> > @@ -127,6 +127,8 @@ struct liveupdate_ioctl_retrieve_session {
> >   * @size:  Input; sizeof(struct liveupdate_session_preserve_fd)
> >   * @fd:    Input; The user-space file descriptor to be preserved.
> >   * @token: Input; An opaque, unique token for preserved resource.
> > + * @arg:   Input; User-space pointer to a file-handler-specific argume=
nt
> > + *         structure starting with a 32-bit size field, or 0 if unused=
.
> >   *
> >   * Holds parameters for preserving a file descriptor.
> >   *
> > @@ -150,6 +152,7 @@ struct liveupdate_session_preserve_fd {
> >       __u32           size;
> >       __s32           fd;
> >       __aligned_u64   token;
> > +     __aligned_u64   arg;
> >  };
> >
> >  #define LIVEUPDATE_SESSION_PRESERVE_FD                                =
       \
> > @@ -161,6 +164,8 @@ struct liveupdate_session_preserve_fd {
> >   * @fd:    Output; The new file descriptor representing the fully rest=
ored
> >   *         kernel resource.
> >   * @token: Input; An opaque, token that was used to preserve the resou=
rce.
> > + * @arg:   Input; User-space pointer to a file-handler-specific argume=
nt
> > + *         structure starting with a 32-bit size field, or 0 if unused=
.
> >   *
> >   * Retrieve a previously preserved file descriptor.
> >   *
> > @@ -180,6 +185,7 @@ struct liveupdate_session_retrieve_fd {
> >       __u32           size;
> >       __s32           fd;
> >       __aligned_u64   token;
> > +     __aligned_u64   arg;
> >  };
> >
> >  #define LIVEUPDATE_SESSION_RETRIEVE_FD                                =
       \
> > diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.=
c
> > index 3c1c86ff14d69..e3bfdbc6baedc 100644
> > --- a/kernel/liveupdate/luo_file.c
> > +++ b/kernel/liveupdate/luo_file.c
> > @@ -112,6 +112,7 @@
> >  #include <linux/xarray.h>
> >  #include <linux/slab.h>
> >  #include <linux/string.h>
> > +#include <linux/uaccess.h>
> >  #include "luo_internal.h"
> >
> >  static LIST_HEAD(luo_file_handler_list);
> > @@ -176,6 +177,36 @@ static unsigned long luo_get_id(struct liveupdate_=
file_handler *fh,
> >       return fh->ops->get_id ? fh->ops->get_id(file) : (unsigned long)f=
ile;
> >  }
> >
> > +/**
> > + * liveupdate_claim_file - Claim a file in the LUO preserved files tab=
le.
> > + * @fh:   The file handler claiming @file.
> > + * @file: The file to claim.
> > + *
> > + * File handlers whose .retrieve() callback restores state into an exi=
sting
> > + * user-supplied &struct file (rather than allocating a new one) shoul=
d call
> > + * this before modifying @file to ensure @file is not already managed =
by LUO.
> > + *
> > + * Return: 0 on success, -EBUSY if @file is already managed by LUO, or=
 a
> > + *         negative errno on allocation failure.
> > + */
> > +int liveupdate_claim_file(struct liveupdate_file_handler *fh,
> > +                       struct file *file)
> > +{
> > +     return xa_insert(&luo_preserved_files, luo_get_id(fh, file),
> > +                      file, GFP_KERNEL);
> > +}
> > +
> > +/**
> > + * liveupdate_unclaim_file - Release a claimed file from the LUO prese=
rved files table.
> > + * @fh:   The file handler that claimed @file.
> > + * @file: The file to release.
> > + */
> > +void liveupdate_unclaim_file(struct liveupdate_file_handler *fh,
> > +                          struct file *file)
> > +{
> > +     xa_erase(&luo_preserved_files, luo_get_id(fh, file));
> > +}
> > +
> >  static bool luo_token_is_used(struct luo_file_set *file_set, u64 token=
)
> >  {
> >       struct luo_file *iter;
> > @@ -188,11 +219,45 @@ static bool luo_token_is_used(struct luo_file_set=
 *file_set, u64 token)
> >       return false;
> >  }
> >
> > +static int luo_copy_user_arg(u64 user_arg, const void **argp,
> > +                          const struct liveupdate_arg_spec *spec)
> > +{
> > +     void *karg __free(kfree) =3D NULL;
> > +     void __user *uptr;
> > +     u32 user_size;
> > +     int err;
> > +
> > +     if (!user_arg)
> > +             return 0;
> > +     if (!spec->size)
> > +             return -EOPNOTSUPP;
> > +
> > +     uptr =3D u64_to_user_ptr(user_arg);
> > +     if (get_user(user_size, (u32 __user *)uptr))
> > +             return -EFAULT;
> > +     if (user_size < spec->min_size)
> > +             return -EINVAL;
> > +     if (user_size > PAGE_SIZE)
> > +             return -E2BIG;
> > +
> > +     karg =3D kmalloc(spec->size, GFP_KERNEL);
> > +     if (!karg)
> > +             return -ENOMEM;
> > +
> > +     err =3D copy_struct_from_user(karg, spec->size, uptr, user_size);
> > +     if (err)
> > +             return err;
> > +
> > +     *argp =3D no_free_ptr(karg);
> > +     return 0;
> > +}
> > +
> >  /**
> >   * luo_preserve_file - Initiate the preservation of a file descriptor.
> >   * @file_set: The file_set to which the preserved file will be added.
> >   * @token:    A unique, user-provided identifier for the file.
> >   * @fd:       The file descriptor to be preserved.
> > + * @arg:      User-space pointer to the handler argument structure, or=
 0.
> >   *
> >   * This function orchestrates the first phase of preserving a file. Up=
on entry,
> >   * it takes a reference to the 'struct file' via fget(), effectively m=
aking LUO
> > @@ -208,9 +273,11 @@ static bool luo_token_is_used(struct luo_file_set =
*file_set, u64 token)
> >   *    (allocates if needed).
> >   * 3. Iterates through registered handlers, calling can_preserve() to =
find one
> >   *    compatible with the given @fd.
> > - * 4. Calls the handler's .preserve() operation, which saves the file'=
s state
> > + * 4. Copies the user argument structure (if @arg is non-zero) accordi=
ng to the
> > + *    handler's parg specification.
> > + * 5. Calls the handler's .preserve() operation, which saves the file'=
s state
> >   *    and returns an opaque private data handle.
> > - * 5. Adds the new instance to the file_set's internal list.
> > + * 6. Adds the new instance to the file_set's internal list.
> >   *
> >   * On success, LUO takes a reference to the 'struct file' and consider=
s it
> >   * under its management until it is unpreserved or finished.
> > @@ -225,10 +292,12 @@ static bool luo_token_is_used(struct luo_file_set=
 *file_set, u64 token)
> >   *         -EBADF if the file descriptor is invalid.
> >   *         -ENOSPC if the file_set is full.
> >   *         -ENOENT if no compatible handler is found.
> > + *         -EOPNOTSUPP if @arg is non-zero and the handler does not ac=
cept an arg.
> >   *         -ENOMEM on memory allocation failure.
> >   *         Other erros might be returned by .preserve().
> >   */
> > -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd=
)
> > +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd=
,
> > +                   u64 arg)
> >  {
> >       struct liveupdate_file_op_args args =3D {0};
> >       struct liveupdate_file_handler *fh;
> > @@ -264,10 +333,14 @@ int luo_preserve_file(struct luo_file_set *file_s=
et, u64 token, int fd)
> >       if (err)
> >               goto err_fput;
> >
> > +     err =3D luo_copy_user_arg(arg, &args.arg, &fh->ops->parg);
> > +     if (err)
> > +             goto err_module_put;
> > +
> >       err =3D xa_insert(&luo_preserved_files, luo_get_id(fh, file),
> >                       file, GFP_KERNEL);
> >       if (err)
> > -             goto err_module_put;
> > +             goto err_free_arg;
> >
> >       err =3D luo_flb_file_preserve(fh);
> >       if (err)
> > @@ -290,6 +363,7 @@ int luo_preserve_file(struct luo_file_set *file_set=
, u64 token, int fd)
> >       if (err)
> >               goto err_kfree;
> >
> > +     kfree(args.arg);
> >       luo_file->serialized_data =3D args.serialized_data;
> >       luo_file->private_data =3D args.private_data;
> >       list_add_tail(&luo_file->list, &file_set->files_list);
> > @@ -303,6 +377,8 @@ int luo_preserve_file(struct luo_file_set *file_set=
, u64 token, int fd)
> >       luo_flb_file_unpreserve(fh);
> >  err_erase_xa:
> >       xa_erase(&luo_preserved_files, luo_get_id(fh, file));
> > +err_free_arg:
> > +     kfree(args.arg);
> >  err_module_put:
> >       module_put(fh->ops->owner);
> >  err_fput:
> > @@ -533,6 +609,7 @@ void luo_file_unfreeze(struct luo_file_set *file_se=
t,
> >   * luo_retrieve_file - Restores a preserved file from a file_set by it=
s token.
> >   * @file_set: The file_set from which to retrieve the file.
> >   * @token:    The unique token identifying the file to be restored.
> > + * @arg:      User-space pointer to the handler argument structure, or=
 0.
> >   * @filep:    Output parameter; on success, this is populated with a p=
ointer
> >   *            to the newly retrieved 'struct file'.
> >   *
> > @@ -552,9 +629,10 @@ void luo_file_unfreeze(struct luo_file_set *file_s=
et,
> >   *          kernel.
> >   * Return: 0 on success. Returns a negative errno on failure:
> >   *         -ENOENT if no file with the matching token is found.
> > + *         -EOPNOTSUPP if @arg is non-zero and the handler does not ac=
cept an arg.
> >   *         Any error code returned by the handler's .retrieve() op.
> >   */
> > -int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
> > +int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 ar=
g,
> >                     struct file **filep)
> >  {
> >       struct liveupdate_file_op_args args =3D {0};
> > @@ -591,9 +669,14 @@ int luo_retrieve_file(struct luo_file_set *file_se=
t, u64 token,
> >               return 0;
> >       }
> >
> > +     err =3D luo_copy_user_arg(arg, &args.arg, &luo_file->fh->ops->rar=
g);
> > +     if (err)
> > +             return err;
> > +
> >       args.handler =3D luo_file->fh;
> >       args.serialized_data =3D luo_file->serialized_data;
> >       err =3D luo_file->fh->ops->retrieve(&args);
> > +     kfree(args.arg);
> >       if (err) {
> >               /* Keep the error code for later use. */
> >               luo_file->retrieve_status =3D err;
> > @@ -604,9 +687,9 @@ int luo_retrieve_file(struct luo_file_set *file_set=
, u64 token,
> >       /* Get reference so we can keep this file in LUO until finish */
> >       get_file(luo_file->file);
> >
> > -     WARN_ON(xa_insert(&luo_preserved_files,
> > -                       luo_get_id(luo_file->fh, luo_file->file),
> > -                       luo_file->file, GFP_KERNEL));
> > +     if (xa_load(&luo_preserved_files,
> > +                 luo_get_id(luo_file->fh, luo_file->file)) !=3D luo_fi=
le->file)
> > +             WARN_ON(liveupdate_claim_file(luo_file->fh, luo_file->fil=
e));
> >
> >       *filep =3D luo_file->file;
> >       luo_file->retrieve_status =3D 1;
> > diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_i=
nternal.h
> > index b42369c3b1f30..3bd9ef442934e 100644
> > --- a/kernel/liveupdate/luo_internal.h
> > +++ b/kernel/liveupdate/luo_internal.h
> > @@ -87,13 +87,14 @@ int __init luo_session_setup_incoming(u64 sessions_=
pa);
> >  int luo_session_serialize(void);
> >  int luo_session_deserialize(void);
> >
> > -int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd=
);
> > +int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd=
,
> > +                   u64 arg);
> >  void luo_file_unpreserve_files(struct luo_file_set *file_set);
> >  int luo_file_freeze(struct luo_file_set *file_set,
> >                   struct luo_file_set_ser *file_set_ser);
> >  void luo_file_unfreeze(struct luo_file_set *file_set,
> >                      struct luo_file_set_ser *file_set_ser);
> > -int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
> > +int luo_retrieve_file(struct luo_file_set *file_set, u64 token, u64 ar=
g,
> >                     struct file **filep);
> >  int luo_file_finish(struct luo_file_set *file_set);
> >  int luo_file_deserialize(struct luo_file_set *file_set,
> > diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_se=
ssion.c
> > index 403906937bc0f..74f8a1bf1da8c 100644
> > --- a/kernel/liveupdate/luo_session.c
> > +++ b/kernel/liveupdate/luo_session.c
> > @@ -284,7 +284,8 @@ static int luo_session_preserve_fd(struct luo_sessi=
on *session,
> >       if (session->frozen)
> >               return -EBUSY;
> >
> > -     err =3D luo_preserve_file(&session->file_set, argp->token, argp->=
fd);
> > +     err =3D luo_preserve_file(&session->file_set, argp->token, argp->=
fd,
> > +                             argp->arg);
> >       if (err)
> >               return err;
> >
> > @@ -307,7 +308,8 @@ static int luo_session_retrieve_fd(struct luo_sessi=
on *session,
> >               return argp->fd;
> >
> >       mutex_lock(&session->mutex);
> > -     err =3D luo_retrieve_file(&session->file_set, argp->token, &file)=
;
> > +     err =3D luo_retrieve_file(&session->file_set, argp->token, argp->=
arg,
> > +                             &file);
> >       mutex_unlock(&session->mutex);
> >       if (err < 0)
> >               goto err_put_fd;
> > --
> > 2.56.0.385.gd3acb90ef8-goog

