Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F35EC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:01:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 399096B008C; Mon, 24 Aug 2026 16:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371526B0096; Mon, 24 Aug 2026 16:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 287C46B0099; Mon, 24 Aug 2026 16:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E85E16B008C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:01:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6A07B1C0FB6
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:01:35 +0000 (UTC)
X-FDA: 85137232950.25.338C3EE
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 80A29C0020
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:01:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MK8xhzOA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787601693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3YYVbHmzYNMo9iR3w7Aron4iVAyXE98ecr/hPSAyXc4=;
	b=JvuPgmZyisVNNlpK/8SO3Dwff0MfMK5siq4NkRWqe7bQU8JQFlku72gG8hcFFv8yez1Eov
	It33f0ccfXon/B/f1qolhj4JJDOoT6CXiYYKB4/djKL5pPJdeA+wC8yn7kAcbHmzRHGYPs
	9nZ2+CyTJ9U3l0T3lHIReoeJdnqJLLw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MK8xhzOA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of andrii.nakryiko@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=andrii.nakryiko@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787601693;
	b=vY7iLqpHXHdbOtPP05m7Zwuw1n0i46gfFth6sHNLx7c68NhHm+ob1rwSruscq8MmmHIJsJ
	X46MmYazZzcAu5MuMppbAGavFWNpMOcMKwQoydb51p2WqNXJamZyWp5NJmY4lqJLiMqXCX
	OJDAcy1XpcPtC/rCfmdo1d4DfxP5R5M=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c9aea40d799so2387100a12.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:01:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787601692; cv=none;
        d=google.com; s=arc-20260327;
        b=QNqLCotRCGtgGDEHtpoeZ5WsGQXA78bfuENZVGGkBjUjIA5CipXOu79vQv83vcft6z
         d+Hjh/rgMGXmZHIV9MX6wt/3g6/Zj7kUBX68IA8bwK3ov0jvYnT3SnedAB16nuSbs62L
         BI6cZ0aWz8v1tieLVIah0FhPrD4cMsyS4WERUIBB5gH6e1fzi2DiLGGchtjcQX6xnrS4
         C5oHzYFdeNqhX2827fuUK8qrArK7GV4WX2Y4otipK5BE1v/ZvWNdUXB9GznNbODpLERN
         CD5ivvaVHXi5JaIYWg1eEVK9l9CGj2hxwXsSf6Oj3DnakWZBd/rxOzV72cztN6O195Gf
         0awA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3YYVbHmzYNMo9iR3w7Aron4iVAyXE98ecr/hPSAyXc4=;
        fh=9K0ZMtNf4rNEUSThq/e5ZfqfHVE59c8A5LS68Dcoe0Y=;
        b=b+nZmHWYaY7gKN6OM2EjPecXgOXT/6oraOWi2fRXkU15jQeEtgq9gQYOmc5b1WebRl
         DyMtPhKZuLGq6lAFELE44YG4vah23UPAMlM+7Z9hyToDqTteRkT4Os5CsoUhwOYlInYf
         9Apb32+IpAJ/QPEW/hWNesjgwbvo63yj+39pdZUbrc5Fqt0SlnZ1cp9n9o+Gb70d8kXD
         3qDQX2Pe1rnwwOB9Oe/YG0yWSu1erBQTqsVUA+tWsROKax9Ll1Jp1UKiQlzwl4Z74RVm
         lOiSaz7/21PKZB6pg22bTtoZJ2iYis+Q6Yd+7+mAslCdqbWsW6ZEvofUfr3/3xMYCfpb
         Z7SQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787601692; x=1788206492; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3YYVbHmzYNMo9iR3w7Aron4iVAyXE98ecr/hPSAyXc4=;
        b=MK8xhzOAkI6Oy3zo+LnTfh9ASfo2sKOOAeiD9HlGq67e3vOMvYUjx0paH2SkjHRunk
         oEkmRO2ktoEoarW31BSs89Q9B8aYgfmL6GV7vnpewY4TWxa4NTUHRF5gWeF28vgpNRcc
         7SCNLL4obiXQPXgIpAXN2Q7ysvrIP3h8VyykfQGx+x6Mg74inM7uR3+f8w8ljSAEGLAz
         AyfI0C6D8nw2TmOYkfzQPGyum7QRL1WaczpEoSAPkpEfCSRal8XmDuuSMGHxuChGK68n
         nfjEqTWEc/RPuP0oosxalL0jsXlU0uk3Ah15UX7xhaDzt8HHI0j3FmWDaI0FQJhyrDpH
         GZgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601692; x=1788206492;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3YYVbHmzYNMo9iR3w7Aron4iVAyXE98ecr/hPSAyXc4=;
        b=SYoq1Tiyo6Vemf2VKkh/UbxmupSFUF/stVo2/pRYSX7vZPCYxs03sj67BV0fxscaUQ
         Dao3qa75eT+aWBy7ehXazoeYicj+Sx1aPRM7VQYCcDSca4Dg/OhQK3tmV2Vym+GEisKC
         fVGwgHGPlcFmh9pdZnYqamx4Hr7zeCQSZ3VHHPDwM8ZsrxPKyHq9KIVpn5DysWm/O8/j
         sGETAs4zb/hj+NzujAMkevcRyquOARlHwsWkvSG/CMXOlhQenLpq+Tb2oyZEfg6ee6ou
         bqKjlLeOKP/OZh2TFSaAw4h3IfYLTmWP2NSB3Lambh/BkNuLFqzKHbNZXLDwsf4piSz9
         op2A==
X-Forwarded-Encrypted: i=1; AHgh+Rr7FKVS9KTMHvBD9AcD+kEgkS7lyHbAG6S++HXi10wXIEzBSTLAfNd9Eie0ZgNOuOYEYmA/H94YFQ==@kvack.org
X-Gm-Message-State: AFuF++mvRd/2gWUdxizI4qPFZqB3WWXcmbmV/1tbofprVkY2540HzBYA
	EfGJjfBu8ErtDJiUG3ROQZaSXccsYITHHvg0Frc/iNpnvDOeHA40MUqjwcEZESf7I6mohP4ZzSk
	CsxzqW+LphwtwBPWhE0piwxeweZAQREw=
X-Gm-Gg: AR+sD10/wkRTaWBzurXrm9gAb2v5QS258oQ0rPmUMn7kgFGnOEfTrNUK4vbjkt2QasA
	yqV6+KG0USNz6OrDap/HX1lw/zyJDmx4miC8/YWpgi9y6AXgE/4dOShCgPkGntOicoE+4VPkl4W
	5MBxb4LJbA7KQ83Vge7BUq7RVTcJfgwiaryzWMnvmTSTXaeCHbAaysFgLzXsEeOFk53mZ8O6yDX
	r/0sSbrn+DvGTx7Aom1vjJpP/kYYW02fGLmtNEx4Wxat22+H8lBQ2RBx3TGUZ6KRk9CLoeUfAjm
	w4EUhZ8vcsz9FOaHmY8abzopwdZpXwoDAgxjzhYmKiz0LOyPIL2bHYguxSq7LeVGEQu5CT4DZzB
	DK6HFUaNUy7OF6X3G2L4T5oe6XTGFiVsI+eLOLUFKWg==
X-Received: by 2002:a05:6a21:3381:b0:3cc:841d:bb26 with SMTP id
 adf61e73a8af0-3cd913240damr2559487637.15.1787601691946; Mon, 24 Aug 2026
 13:01:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAEf4BzZTM5SehNnM83U3Kj0cz=NN=JwUtG-pcvSHdvZBsHdM3g@mail.gmail.com>
 <20260824104930.83453-1-tasos.papagiannnis@gmail.com>
In-Reply-To: <20260824104930.83453-1-tasos.papagiannnis@gmail.com>
From: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date: Mon, 24 Aug 2026 13:01:15 -0700
X-Gm-Features: AcwNN1VRJvQsJzFSZeK4Dv3vlANYJItg-44_okx_VAvveMLZt9tyHGMAHD-LhsE
Message-ID: <CAEf4Bzb9szFTDo5uUxLgUVD3qA1XF-5A7GZGxJjX6d1MYLhbFQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] bpf: Add user memory access kfuncs for linux_binprm
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
Cc: akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, 
	bpf@vger.kernel.org, brauner@kernel.org, daniel@iogearbox.net, 
	david@kernel.org, eddyz87@gmail.com, kpsingh@kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, matt@bobrowski.net, memxor@gmail.com, song@kernel.org, 
	utilityemal77@gmail.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: otr7qg8uh7jct5kjkt5857tg7anuiq6q
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 80A29C0020
X-HE-Tag: 1787601693-338285
X-HE-Meta: U2FsdGVkX1/9yYtluhiEkKm49h4yrTZUjQHuVKyjkElwtcghYst4jTN9t9VojIMBxjxG3NLZtjyiKfx+ylH30HV30tIkooGFUexHGYEFhBEY3u48oiLRoaI5Z5n6W1pbLJEsyMLranOc1NEWST7LHFO53Xdeo1aa/Rz4vsx+p/hJcgAwAKzpkWmbD3nIJ+U3fBVqlr7X+sRMeHAqVoxIGimhQlU/ZwaGR0EQnidSotiO1hiwQA1EId37JWMaGR3XFj9A4oucx0QLC4Srlp5Ll4Ls55oyCILkNcv6lBZA29nPMJP3bZXSS4b+wIzykvT8ULXlN4leurXzDNyTSHcDLQEpjDwr99zzLxhiWZzXOOXnaQXLCn3MWAusN0HMVX3RDNJvVAyxPXit58bMN9g+G5igD11gAYmGEkGfgANHTk6KCq/RubkUHnUCp05aAWVvL9T6RacuUxZN4A9djl4WDAkxGRspLI8IUKNm6NU4cE4Bmgpi8DTdFazpbMw5+abkI+ZmsV/8VVBbAb7nMdjFeWKyeN0yY+LBmkCDr4mVi36Nw+SQbRBusahu2SyVX4x5OOYw5WyW0O349wM4RYqlR9DrF6qJuQzhP1fRqcYwdffOyxxQt/hKZBi4P6FdW/u/9Ugr+/sY1Ln7WcNelzl+eZZMe1ZPIlpitZCrR9OkoWAMgfJBhPcFsncWDp0HXcE8Pn8+tAYZY43awj6Yw/7tc5CoTymF31fqGRh55MNnvUVrl54qm1BMNHCYVVQKkztxOBXCnGWfEzGU3mUllhnHg337V+2gY8aWGZy3mqTWncMqIvqYAdjgqAQZXIkbDmPsLGbJq28LJCK8ARKiDj4+deSavHasxBX93TRk1lhigEQVAYEZd5t3OxumP9oC240mP7zH5fsp4mXtdFOLyG3I5cYDpNksmMDLmGVGeJ86cuZXrcslDiaejZRUexDLbylZKzRHO4VnBQanc8g5pZr
 CH4yddnC
 t8RD2t7jpSQKkDeOdupQVSDzFZqe15petorr48ie2cis5ghz3IBXOdkKG3iLqr0sAc+RM84uPsXUoNDkCS9bQDH4KUjMkqu+k+v+vqu1pnVQXrROOxa5wCq137XkwHNFhZqQpxyiQ0gC8o0x19pj+VNM7dCOTpA09pFg1qOCpV2e1IrtFqRoUNHlKJANhzh86ioSEx3488CGi+KMAbrXAG1qqMXY9aNDTbaBEi9eS/iv/8wvEMgSiLdMnOuov6wDn22QQzci10Xu/5G1BhhWDYTLMTnVOJ71MiIQ1o5CZ9C66uK7WklcSuj3jT1RaKdz8TSw2Q3DJNPFbFPbX4V1HdzSJok2NLHruCpD+1WUffFflRMAaXxFV1Tg7DkraIa7oJYrMdF39Wv50iyBRD4smUFeqy2hhMNFPMr4sRX5k+yneBix8oEi1U1DqP9qKY8GKCf1LTUlAxpeFxZy7VlOtn+y2EvRw3l3bSsxZCXBdWD/qlYCLGmOH3flifkGkN2kiydMWXnoqIS4YsEERT7bQTWAPuGUfjckkVJKLyeCRG4/gVlyiWIdVFvcNmMyn0hm6jxCtRXVsIVTl51YU6SU4K7gXDdj7GkAx9Z5GpWbbrmf92H4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 3:49=E2=80=AFAM Anastasios Papagiannis
<tasos.papagiannnis@gmail.com> wrote:
>
> Thanks for the review!
>
> > making this linux_binprm-specific seems short-sighted and overly
> > specialized, why not pass `const struct mm *` and call new kfuncs
> > bpf_copy_from_user_mm[_str] ?
>
> > and this seems to belong right next to bpf_copy_from_user_task_str()
> > and others in kernel/bpf/helpers.c (and bpf_copy_from_user_task
> > variants should just delegate to this mm-based APIs and minimize code
> > duplication)
>
> This is exactly what I did in my previous set of patches:
> https://lore.kernel.org/bpf/20260811112154.94053-1-tasos.papagiannnis@gma=
il.com/T/
> https://patchwork.kernel.org/project/netdevbpf/list/?series=3D1144046&sta=
te=3D*
> https://sashiko.dev/#/patchset/20260811112154.94053-1-tasos.papagiannnis%=
40gmail.com
> https://github.com/kernel-patches/bpf/pull/13211
>
> where I got AI reviews with 2 main issues:
>
> 1.  Does marking bprm->mm as trusted-or-null here create a use-after-free
>     vulnerability on the execve error path?
>     Looking at free_bprm() in fs/exec.c, when an error occurs:
>     fs/exec.c:free_bprm() {
>         ...
>         if (bprm->mm) {
>             acct_arg_size(bprm, 0);
>             mmput(bprm->mm);
>         }
>         ...
>     }
>     The object is freed via mmput(), but the bprm->mm pointer is not set =
to NULL.
>     Could subsequent traceable cleanup functions (such as free_arg_pages)=
 expose
>     this dangling reference to BPF programs, bypassing the verifier's saf=
ety
>     guarantees?
>
> This is something that I believe is easy to fix.
>
> 2.  Does this break the BPF load-compatibility guarantee documented in
>     Documentation/bpf/bpf_design_QA.rst?
>
>     Before this patch, walking bprm->mm produced a dereferenceable regist=
er
>     in every program type. In sleepable programs, in_rcu_cs() is false, s=
o
>     check_ptr_to_btf_access() sets flag =3D PTR_UNTRUSTED. In non-sleepab=
le
>     programs, in_rcu_cs() is true but mm is not in any __safe_rcu* list, =
so
>     clear_trusted_flags() produces a plain PTR_TO_BTF_ID.
>
>     Both PTR_TO_BTF_ID and PTR_TO_BTF_ID|PTR_UNTRUSTED satisfy the guard =
in
>     check_mem_access():
>
>     } else if (base_type(reg->type) =3D=3D PTR_TO_BTF_ID &&
>                 !type_may_be_null(reg->type)) {
>             err =3D check_ptr_to_btf_access(env, regs, reg, argno, off, s=
ize, t,
>                                             value_regno);
>
>     so bprm->mm->arg_start loads with no NULL check.
>
>     After this patch, btf_nested_type_is_trusted() matches
>     linux_binprm__safe_trusted_or_null.mm, so check_ptr_to_btf_access() s=
ets
>     flag |=3D PTR_TRUSTED | PTR_MAYBE_NULL. Now type_may_be_null() is tru=
e, the
>     arm above is skipped, and control falls to the final else:
>
>     } else {
>             verbose(env, "%s invalid mem access '%s'\n", reg_arg_name(env=
, argno),
>                     reg_type_str(env, reg->type));
>             return -EACCES;
>     }
>
>     Any existing program that reads through bprm->mm without an explicit =
NULL
>     check now fails bpf_prog_load() with -EACCES.
>
> This sounds to me a bit more complicated. In a prog attached to lsm/secur=
ity_bprm_check,
> bprm is trusted but bprm->mm is not trusted. So we need a way to have bpr=
m->mm trusted
> to pass it as an argument to the helpers. In that series, I marked linux_=
binprm->mm as
> trusted-or-null, which breaks all existing programs that use
> linux_binprm->mm->something.

this is probably ok, but also we might want to look into having
verifier still allow to dereference trusted ptr-or-null into untrusted
ptr_to_btf_id to help with smooth transitions like this.

Not sure how complicated that would be in the verifier, but that would
be a nice backwards compat preserving behavior.

But to keep things simple today, I'd just mark that bprm->mm pointer
as TRUSTED_OR_NULL.

>
> Another approach would be to add one more kfunc (i.e. bpf_get_bprm_mm) to=
 get
> the mm from bprm and have it trusted.

sound quite specialized, but I don't have a strong opinion

>
> The reason that I didn't push that further was that mm in general is
> bound to either linux_binprm or task_struct during its lifetime. We alrea=
dy
> have helpers for task_struct, and I thought that adding helpers for linux=
_binprm
> would be enough. Other than that, there is only one security_*() function=
 that
> takes mm_struct as an argument (i.e. security_vm_enough_memory_mm), and p=
ossibly
> in that case we do not need to read the memory contents, but only metadat=
a
> (possibly I am oversimplifying here, but this is to show my thinking).
>
> Unless I am missing something obvious, I can see two possible approaches =
here:
>   1. Keep the bprm-specific kfuncs as they are now.

no, I think that's a bad idea

>   2. Rework this around the mm variants that you proposed and add one
>      more kfunc (i.e. bpf_get_bprm_mm) to make that work.
>
> Does the second approach sound reasonable to you?

yes

>
> Thanks,
> Anastasios

