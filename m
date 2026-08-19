Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAE4BC5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 14:54:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910516B0095; Wed, 19 Aug 2026 10:54:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899F56B0098; Wed, 19 Aug 2026 10:54:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B0A6B009B; Wed, 19 Aug 2026 10:54:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35D916B0095
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:54:16 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C01BF40255
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:54:15 +0000 (UTC)
X-FDA: 85118314470.08.0E15374
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id BC75540005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 14:54:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PAjuV8t1;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787151253;
	b=2uUk57Hrg5PCMnbD5wNmIviozLiNoT4yXDdhrDsAyt0POLwhZr/5e5f+/pFabhRUFpSzDj
	CnyOBA5VUl8Xwx/KU+6NPlxkexPokL6cyFH1cAAaVhEIH61qXL5k/A4XSNzMKlZtJNkVly
	4GWp+nSbIgLjWZNtmnaUw3feZfu6Ca0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PAjuV8t1;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787151253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhvw/FgE5+XsocfZbB7wjswP5NddcYAmLYZePhCxoG4=;
	b=VYelvLg7b6qlsaDAyPHBtuMtP3twgYdavmVTXADSa07PffxgMGitD2ifafEN6BxguyXbBz
	AzI7ulKcAq82YI3krsoXAh029zNrP51ly3ezAFL+QKIm8+a+hX6iBpmlLZnNpK/IS7RG4L
	Fzm4JtxehFYZFkYTLx4q6/d8MVyRDwE=
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-456395f4e7bso644823fac.0
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 07:54:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787151253; cv=none;
        d=google.com; s=arc-20260327;
        b=jkVA3F2dAprJvBqJGAbT4iRp04r+OzU5QsIAwEi58FjBxtCcyzvy1tMjzlIlbG41HS
         6VXiEgNuZKnCY4Qfpm2JXmQ/djthYxykfgY+PRJlP00vV18GRn77OnoyfoHxzuA0bSzA
         HqZOri0onWXRu0W7CjULK+a8E/SgZACzyn2jcnMwuzA6kD71fUwkl6eQDDtBdivcTm+C
         DheKW+mvnrb8Hul52NeGImoteX1dPUHJbOdSHyDXc7GVz7VGALxW/GLvagn8hGguK9De
         OmzXX3D9PPXKIiPzo3wNHh9/Tyd7ulyUOHNHQeWJ7TQPbsxNjeFQscWP9N4aPMu63G1a
         2cyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mhvw/FgE5+XsocfZbB7wjswP5NddcYAmLYZePhCxoG4=;
        fh=wZwHeDhF3wlAb87Uyvhj1flPN0Gl3TmoniC8Vqr8ZF8=;
        b=RFXIvG1RpCGKrmAqPTI55Lnvj1+gFtpwt6fXgD1727yNeACB1Cqyhq8ka+SIicLUYM
         zAATPEgGaPfl6qjvjnHbtwkTw3MWFtNhL0eoXipV9uuf2bo9raywNxAr5pXAORpBKP+V
         0Y/g3YOf5A/qMyySSYQwr5k3f19WtVvcu0eRF6ad41Uum8ZH3Es7JO9tKlRRC4Y4TmlK
         z85rQ5p0hePJFKNNF0Z9rWozzxEQZkxTp6hMMP+e32+WUKz0kr/np1KmjhfHWs1p2ieZ
         Q3Qp7lYfTc0qmS9PnlJkHcEOoTu8FEFWk9bvQYOymVRIsgpZ0tvIVrQn5qxqAgPcOc/d
         iaTg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787151253; x=1787756053; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mhvw/FgE5+XsocfZbB7wjswP5NddcYAmLYZePhCxoG4=;
        b=PAjuV8t1DppI9BMebPc5fwri1y8PnCf8zVzLOTpAxVfEIebavijE/z7xiRFXz73spL
         zcN5376aVOmy0Os1Tf/LX0DAIsX+CWRhyYuVf6n4dHSEtHODUS493HKwwAlk2KTp06W1
         H18G81iWmwupFry88mo0t5GZe+YnqGoLDSDJmQN0e/Qefcj5gNHBn7Ovagcmf8FFHNEG
         iqKloINoaTdQCZB52Jd/NVfYWT/hNcEakS/RwYhhR6qNzUZjkU8oL94mWzLx1+VENiFX
         22vB7Xo6P5NRRt84ZmgZpVbMRB4yoqxstEyqZrj1EAx4sOAMJmeiIDNuIFNJc0d44WL0
         Q75w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787151253; x=1787756053;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mhvw/FgE5+XsocfZbB7wjswP5NddcYAmLYZePhCxoG4=;
        b=BC0pqeaPM80e/2phkqAeJyyEFwN///TQYhyl0NKOkjxdG2ema7+XoygyH46HDU1Osn
         1BK+3lC2B6ODXKo8xExcrFNeivVOI15tRyLz8w6TstY5Zjfi64arb0D/m1dMSjDD5m1c
         +ZCkM2FJTV/ZetjPHT47D5qKjC9tBEbfZ6LIql9cjv6aVQYoB4+rX6DpIzEyRud9cjOf
         dPa05mdK7Io9oZs5Mpk1VyhKGTL9nzDcP08dveZ2l3s9P2QGurP2XyE8jOguZ/hwPVFk
         mEvos8VsvJLNzRTV5Sy+ngE4xr8LIvhW4qMdt6t7/DMMr28UFS5efqhMZjpgQd5ijwtt
         hsAw==
X-Forwarded-Encrypted: i=1; AHgh+Rr9D3bGh168+R8qRMeZ7AGjq3uTmr4MnOpp+8SDOh/UEyxKFe6+ansqi44WXkcPm7RrlioHUoKDzg==@kvack.org
X-Gm-Message-State: AOJu0Yw7KgaaZaBZ/EEwN9DAiNgu9B0X2/XPdqqkRAt3XH3o+2sZKFM5
	+6c4G1ni4FLqaiZFSLumlTae9zR1Z3NN2g5Yl2QExL2YvjYB54BF6JnILPAXWf3KWqC0MquVco0
	LaqbVkD9MA+j0XixA1RdkpoMm+0hex7E=
X-Gm-Gg: AR+sD11BL5cndrqJQbJInq6Aj4fiZilcJVglQxkzufLAHeJlQKClxIUJsquq8FeOCZs
	/V946igv53mEpm/Vr8zRuWL2O09X1bws/1Q5W83nFlhr8eZHRyT6gBxGDojtvkn9gr90OfexVcu
	s6lAzjFZYQF1TYAFgX22ooviTuah2n4UcCNbiAiz+IGRM90W6zoJjnyReqXat1jQn7DiEqK96mj
	xkRSex7222SRA8SpIf3RR3BbqZ9WWYb9TsVaq1Tm0OMCNIuGOvHMM+s3TGQ4atvr1kYs+4HulI2
	Wv0aZpT7NO8wwgfPnnweDCghpY7hDP4P//GUKdlG7VZ3
X-Received: by 2002:a05:6871:287:b0:447:a201:4a5a with SMTP id
 586e51a60fabf-462f64be287mr5194131fac.8.1787151252623; Wed, 19 Aug 2026
 07:54:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com> <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com>
In-Reply-To: <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Wed, 19 Aug 2026 10:54:01 -0400
X-Gm-Features: AcwNN1Vv0YORuTgO6puZkVyho68XY6ndF-y47mMS-AkDlVErDtFxI6gIHPST0Qw
Message-ID: <CAEjxPJ714iCMiQRVAN6MQoOyNx998MS5Xfhbhmugcwz+gWYAuQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] selinux: require EXECMEM or PTRACE for FOLL_FORCE introspection
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: BC75540005
X-Rspam-User: 
X-Stat-Signature: mqioc7pjp1gfqo86cgcjdsfwspepd5qw
X-Rspamd-Server: rspam06
X-HE-Tag: 1787151253-823180
X-HE-Meta: U2FsdGVkX18EBqZjHbLQTGF1ClTcT/UoHw9UOK5zqaW1RHtp57efWZWM3Mny59fHTIR2m82XHxJ5AYyFOzARBIVhhRp8VxY8Et2WsTDo9xQ1NqVXCGzLW15z1rpZ+q0ebj2Y4z0l0EImS5NxgGWsmIlml0YHZqc0OJL7RgDuiIIinPJICsQ4oy0tZO7krm/gdCeCgxTsJ/uahTIL3JOzGkCiK8Lvlghn9ybpgMW2x3qZ8r8EkERzQvyJy24oX9Csw+rgpbhG8mnwB1BXN/wkzSxua6DMkhz/HIDdlPBfG8MU477lwNUYReaP+yZNpV1XwsxliO7ymH6KD3et1V6YJz2KwGhx+acdwnLFc+f8pGkhKXAmofnqmQZZepQVKjoNM05bjvv0QEGA7Eto+gYWmY9i8MjxAbKVZw+Etc1h//J7MBXD1VRg5CGbCrf3/lozR/S5GasYw8Fr7Ch3GJ2tKp3IjT3vRk/YiLCtCDp5pBNYtXGDtXBlEnRfVZG/Bc1o0z7YyF60FABdkL/IaoQB23hgE5ZN3byYmZNvmACnNlituGe1imc3VgjB7xnyLtK0KpY5Nuhj2ISaTaGfylAXXC6jAjhKg+IzBkK3dj1pggSazjfY5v6GKQX+bAFF1H54PRuE/iq9I7GaIxSzJd9VOmx1fKNSSOoPwKHtbz/QXWeLA1AmBd3CiGPJXce1oPSmcW+otARZv3Ao+8oe6D2DjGAxYLiOj0pCH0K4fWNxhP1Q4c0hUKH8np6ylI1LxELzgkK0FJJOs3I1byfCUTPVzVXqni/ipRdDiA1OvLPkyDc4roQ9fFvVdbL58d26kGKK13JQ6rV+SAX5lXyiXEX+qUsPM+AEvPke1OXh7hYPl16+qHMHW0sbUqeh3bxDPaIO+TPFETuoeNW4gHtcDY20v8Ko8cVYquUwS6oggA8mpNhGPgxTuQ0bZMHVZBK8Em9E6hZeAaeXlteA0AlwyFr
 t0JSt2VB
 XfU+2bjdS2ea63gdjqnkhtB6fo+e/J1+PsGwmwrKHTS89pZCAMGWNFeCLc0TyXp2cO+yMG7otzeHsvf+HkzVqK33n6kl9Hms/Z7Sf/EOclsTgAMQ4o3O6I8VjEIsEohWwy93sltyv9+EgBCqH02qGdLrZEqwFbtsY61lhJxddZ6ho9/HUYqLpiz1lecWUKEiGCTpDLWB8+xJi4Qu/cqp7oo6pKbxm2qmljkWxb49dY0xVxZATPZlm4CNKcQBadyYJkWDe9NzKqPlde/vWFcszzu1OWUNrmJnYMQt+cdPrbmT5Dieaa326HLyYIWg6A8Rlxe43ceK3C6xTW1VqNiBqU+a3uI8RUdhtcOFZHkSIcu4Z0ohX91D7tITBaoJ5nBCEiScuuVONuXjgELkNgLjw4IaCkBrN4Ht9EphHwRY5gzgINqKLGJpr1IR2b83QOJ2v2EznNWXVJ9fF3dfWnXwf867h7fqHGuivW5lQL+DhtcwwEfNYVhyhjCfFMsPkf77YYhbx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 3:51=E2=80=AFPM Jann Horn <jannh@google.com> wrote:
>
> On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process c=
an
> only create anonymous executable memory via /proc/self/mem if it has one
> of:
>
>  - EXECMEM (like for other methods of creating anonymous executable pages=
)
>  - PTRACE (like when using /proc/$pid/mem of another process)

Allowing it if _either_ permission is allowed is unusual in SELinux
and seems prone to errors.
Is there a reason to not just require PTRACE always?

>
> This closes a hole in EXECMEM enforcement that Project Zero has used in a
> remote Android exploit chain:
> It was possible to use a memory corruption bug in a service without EXECM=
EM
> permission to overwrite executable code via /proc/self/mem, which made it
> possible to load and run shellcode with a kernel exploit.
>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  security/selinux/hooks.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 18dd28b2bb13..905137c47321 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2157,6 +2157,32 @@ static int selinux_ptrace_traceme(struct task_stru=
ct *parent)
>                             SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
>  }
>
> +/*
> + * Decide whether it should be possible to read non-readable VMAs and wr=
ite
> + * non-writable VMAs via /proc/self/mem.
> + * This only applies to systems configured with PROC_MEM_FORCE_ALWAYS, a=
nd only
> + * triggers on accesses that are not visible to selinux_ptrace_access_ch=
eck().
> + *
> + * This allows a process to overwrite read-only code in its own address =
space.
> + *
> + * Creating an audit record on denial doesn't make sense here, since we =
can't
> + * tell whether FOLL_FORCE matters for the accessed VMAs.
> + */
> +static int selinux_introspect_mem_foll_force(const struct cred *subject)
> +{
> +       struct av_decision avd;
> +       int rc;
> +       u32 sid =3D cred_sid(subject);
> +
> +       /* Allow if the process is generally allowed to have executable a=
nonymous memory. */
> +       rc =3D avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__=
EXECMEM, 0, &avd);
> +
> +       /* Also allow if selinux_ptrace_access_check() would allow it. */
> +       if (rc)
> +               rc =3D avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, P=
ROCESS__PTRACE, 0, &avd);
> +       return rc;
> +}
> +
>  static int selinux_capget(const struct task_struct *target, kernel_cap_t=
 *effective,
>                           kernel_cap_t *inheritable, kernel_cap_t *permit=
ted)
>  {
> @@ -7558,6 +7584,7 @@ static struct security_hook_list selinux_hooks[] __=
ro_after_init =3D {
>
>         LSM_HOOK_INIT(ptrace_access_check, selinux_ptrace_access_check),
>         LSM_HOOK_INIT(ptrace_traceme, selinux_ptrace_traceme),
> +       LSM_HOOK_INIT(introspect_mem_foll_force, selinux_introspect_mem_f=
oll_force),
>         LSM_HOOK_INIT(capget, selinux_capget),
>         LSM_HOOK_INIT(capset, selinux_capset),
>         LSM_HOOK_INIT(capable, selinux_capable),
>
> --
> 2.55.0.737.g08866a6d13-goog
>

