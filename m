Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646E1C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 17:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AA9D6B008A; Thu, 17 Sep 2026 13:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BDD6B008C; Thu, 17 Sep 2026 13:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249666B0092; Thu, 17 Sep 2026 13:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00AA66B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:25:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FA378043D
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:25:52 +0000 (UTC)
X-FDA: 85223931744.17.55FBADC
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9252BA0007
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:25:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mRsX5erM;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789665950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsTRDsiQkb6uPtn9uEZQZ4pGk/1dXT9fj39UbJRrdLw=;
	b=KSUG7gxNXoAL3UngAP/zCNjCIbq61PIQZFh6lDlMTJLlBLCe4yhC70XSjBtaqGsm9SBj/o
	Usu6lCJilxUfDEosvMG2s4qCWDctzH4AF98qWHcREI34jpfc93ZyMGd+2mqIOfBJQrE53q
	mvUmoSd0n+WkVXdEXFt6dlclhYX2K5Y=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mRsX5erM;
	spf=pass (imf25.hostedemail.com: domain of surenb@google.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789665950;
	b=r+l3zARHqui1AAJY5KmdnEv+lx6BF1//cSQp+VD/4smll8pPaMb75+b9hEqvj2yNikE5yX
	lhM7pwCV5NXwmyRVQoOLCYXEkjB9JvgKRBLXI6bRcFVABzCbb6xsvoQPerlKwyeMm+d3Uu
	RuI926QjM5SatnIATJjZ7pj+MnRy5kY=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a5f9b036f9so422a12.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 10:25:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789665949; cv=none;
        d=google.com; s=arc-20260327;
        b=M7jpRrbnq2GrSc/DxBRe3KVPq/vwSvjePW/9IJOaobjv84XVHsAeLzX3g2eiu/VatE
         cstScbfJgajwEErCUZwwTIJ3YXkoOGW1KXviOs6Bu33EPLwePs4QSbT7XuNlq42qEHKW
         xvMCp0DwHhEIC5Gq6kCnAnb1JrfPJq3GSJGrJqGKHEivNZg76m7YYnTOv8K3j3a5WS9P
         YLUiZrOfkNJLGP7jWFSIpfYwJFxtuEFLcuvHBAe5kjH+Kj3uk1m2wrlN4zVDunlB5knx
         eqsxgTV/dRu8Trhv+4HVMcRbwSaskw6GNs9S1cb+cG46WGoqBOMsqepvOkE3q70ZL0AD
         15rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KsTRDsiQkb6uPtn9uEZQZ4pGk/1dXT9fj39UbJRrdLw=;
        fh=PFoeIicEL4YNffuRVWSl4oqMyh1POyKArP+k3AB52Dw=;
        b=dVLd9Y+UBQCZn/7feSVh5mzGNy381GtKf74M7FT5yies3meyLllGW0DoPZOv+GRZLm
         +SgszyKwuzviZa0IsHpiNuXax/cFZg+GfwGHEqoB6aH6OqKNgnjq6X7QoL6XAf46s2eL
         DwzxTrgedm/QYQIXwH1d6SG3VBMUuwzpVnPXiedmdUevW7hyDf1NM+xCCcueufoAt6BQ
         E6Q7es7gRmgGIPugIDBhgdAA3i01/7GAQ4CL1wR/k8nvqO7nWDEO5nKdBv7L9wMv+w43
         rGoz1De2VWGR7g9C6r8tsF2K3wDh1jTnmEhpYbmzUUmNTxja9A5fEbR2j1Bz0CpS24kr
         QKDA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789665949; x=1790270749; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KsTRDsiQkb6uPtn9uEZQZ4pGk/1dXT9fj39UbJRrdLw=;
        b=mRsX5erMSrkcuVeyH/jh60TvBvqQh978hMp08KHhPzRJqppWUnDV14y1IFyeLH+owF
         fCdat/V6gAy5Zk5eyRo/ZDo1WEcXkNUnZPc1GYv85CDNH0bttQ6yfCUok6+kQ7zqhtkM
         G3n6WUJjyfNxtM6/WEjjhcruydo8NCKd7kplJmOaVf8x3d1+qYXV6/VstZ2PVgAmq+EY
         JMtwt37XpLLilR/grCq7ykHSC7QHNHk0SNpxId0nzzQC2jJ0kZyRfRWSajVyzUa87rLL
         mspYgYJiYD3XZ6MPjhbhzIFeV6bRHGyrgL/a+DeJq3og+aXWSlzb3DSvUFX1+58wgQCG
         85Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789665949; x=1790270749;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KsTRDsiQkb6uPtn9uEZQZ4pGk/1dXT9fj39UbJRrdLw=;
        b=eRHPYoaFdYnBsm2ZL3fjz0Bo/JUhbTNNDV3blwDDKphDLlZQliIfrkSdgxre1DX9ph
         e0IzWbpuinqnHQrMqc4A3QMHUp3/tawl3pS2b4dnj+pdXjT1jCWZTbsv1k6cz0Sd2GIj
         S1kx4i0ZmWDqop8wFXrGgziuHWruhsxjZShRwpIRPpy+xO03Pb5J55rSjUWWVjnZke2c
         qOBT2GRLa0wDZGsvbLKxHT9KNqEnYTQ0uO+NXvP4wk28wDgjj6OPwuIaj/95H7DkaM1/
         yd261l6A6p7dWpagvNpl4beVeYQRyGK2QrCIDX3QO9YCDozG228b2louFdPz3IWNfJ6Y
         fj+g==
X-Forwarded-Encrypted: i=1; AKwUvByr60mu0LfXYFqZEccOwoPdCQ3EHle8Cj/44QJybCRO1pfwUAsc30760JDS3BIT4UwZpUtbxV+6EQ==@kvack.org
X-Gm-Message-State: AFuF++kHvgV1/7R+tyoKEHRsL7VUJ5B2iO+5efZi2+MyuAz4yEQeA+1z
	UGWrvEV5eXde/E2UdTmrRSyJuACAasSmy1K8/LwjC9QyuEsBpJi7WxUH4sIbZ55Jef3j6ZfDTvN
	on47IDoF2nP/n2ISv/lLH8jNl7pAyaYBfYnGfqGo9
X-Gm-Gg: AYBFou0Ep9mDSdzy0nnyMrG+OisnakVg7reCl1nQ1ywKs+zTjmcD9ulMziNSjegaARb
	gYF/jCloSMWpxwV37oGy4ikAZX+Ow8WuPrkSHt2HONLqUolcNNiD+DzSIklbRw9FWLNiCJxIpwE
	fQifyH7Z3fvlsaylyfAMDLDRLk+7eEd8UnkefFVKkKeRGOSMD331xaXS9xyt2uosBQHQOqCONKG
	QxRXv0zUOsYsfan243RSEc8impT6LllkauMk7hUJsLEO40QHKiEPut7+7xtxyLG+UMfALkj0q+J
	45KM1wqGtkSX8tQt1SpBuSE4CjuhTdqkOzv8YFkU62/u6Sh08B7A0wkU6VOwaKh51ZzSq+a8vLM
	fDZSCp6A=
X-Received: by 2002:a05:6402:c318:b0:6a7:ef71:28e0 with SMTP id
 4fb4d7f45d1cf-6aa4de2f154mr1263a12.0.1789665948368; Thu, 17 Sep 2026 10:25:48
 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-4-hao.ge@linux.dev>
In-Reply-To: <20260915070001.113559-4-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 17 Sep 2026 10:25:34 -0700
X-Gm-Features: AcwNN1XYvpWm4JKrRXV9ykFLQYiWSqvvLPav3S2pb3RC8LMV6NkXRBZ6FuHBL-c
Message-ID: <CAJuCfpHz6V0zT5+QkYdQsBzG9kWCFhP+gris2XRrvSu4hHD6Hw@mail.gmail.com>
Subject: Re: [PATCH v10 3/6] module: introduce SH_ENTSIZE_STANDALONE for
 separately allocated sections
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9252BA0007
X-Stat-Signature: cai3y5zd9uxw17c7x75bojog6ew61a3h
X-Rspam-User: 
X-HE-Tag: 1789665950-757928
X-HE-Meta: U2FsdGVkX1+MqlPeO4OQQjEtoiwaAcaYJlUMJ4IOiu/0ydBOiffWQlwMMy8Io2W6HAQ8SzcCYVS7o4WrfXPZ2eNMPbtFFgg1rCaUC7i5jwWWzvICLux8O0LKk+5aY8T/fMThNzDPqs1sKo6SthyMNV4E+ocpxJZ+607YxTcST9P0O6hhHV2HHJ/sD372nBTJ1TmNtnMn4NZ+W4JBLfkQCOEEcM31vfwu4v+2Pf+7PCcRCR8lF7w1BR0jDBuFnhn8y6z2iANfYd46119q1+VVObmcwTLgE9nHFkKNzzdIGLKSRzBOuaWyyicdJ7OY74QhtEgn682/pJypYVd7M43uansftoRsQHRKXClowG1j6suWKm9LcvNdj6JSRkCqszEIv3TUZAFMAnPx0d03LqkxGT/1gT2pIlOtw33mxDhjdGkJjIm/sueYf7J0X1kdL1MG6QPhYbnPtJ0Ou/w1XXOFdb2ncPs+lVLWMZANN+LMCeQwQmnBUgQw5hVPSL3mJ/XP1CWG+a/Pswcb7UczkgXk9aJMJEGFtVCTbXzca04pTQFNNFEmy6C1mjtPbO9zKhxoXWoNIIjNCX4AMounnwk4AIcsbhVfy3JsdKJr0APlA//xJySnYHdZt9VvDscBPHTPUhDyZjH9VEbrezkF6rBqSfiSHCNwe46y97vCm3lZQQV8vbKlZwQox/IeoavIytj4FOV3Wfh7eZguH8cJFj7EQdu2xQ+AKFQ6l16L/QpKMY9S3YectkT52yEaeXZlAJekzXVY+eY3utDGAoHj2w0cJvkqsFnL9HV9WDhv62cr6NDBE999zNsIZ/vZSeNoFxiBe/GpLhb9BLbm77vN8zMoz6ioCvLenTFFiFG3Kv7GpuY+pVG/mcsK0jbgYwDUmclaX3ooT2lEs7535XOLNIA3S1D9q1fbQVSAh+QytS0UfrvG8BZGRjxtcnIO4zoj5e8y1WjzCjIZyrr/JtccLWH
 7X1O76th
 miqd4CKp0hnLC93m6zD4ZmqEVSG/1vHknHi46jXsUIdEzxqZXwtO58DTlN2klLmP8BPjuWcoz6XYduYe87+eJkp95UKC8EyrztH6plzAAO2odsVNe/NN/TJZztpRjXaneeZDq6zU533FJBVM4jAGbDJSUjxvhgS0kv58B1f+/MqGf1mpiTp4v14AcFOh3J5KGOM+hKamSQtHbRpWrRz4gb77A3lR4keRvbN0cMxwbs+yRmpjYmLyRI3svwYxllZUqn+I9uy0dtXK0+j7BOmIuXfO03ulD0m5Qn9CF9HyxVjjparBL9Z9NkHr1HEalRHakICBwd8HGoUzpIkCJJaX3OKHhegCo4D/s9tNUJy1c0Pypq6IN9vQakIrBQsHkIN6OemuyzW4QrR235y8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> SHF_ALLOC means, per the ELF spec, that a section occupies memory
> during process execution. Some module sections occupy memory
> outside the regular module layout, for example the percpu section
> with its per-CPU allocations. The loader currently excludes such
> a section from the layout by clearing its SHF_ALLOC, which
> overloads the flag with a loader-internal meaning.
> apply_relocations() needs a special case for the section, and
> find_sec(".data..percpu") returns different results before and
> after layout_and_allocate().
>
> Introduce SH_ENTSIZE_STANDALONE to mark sections with a separate
> allocation. The percpu section is its first user. layout_sections()
> and move_module() skip marked sections, and apply_relocations() goes
> back to testing only SHF_ALLOC. Based on a patch by Petr Pavlu [1].
>
> .data..percpu keeps SHF_ALLOC, so it would now show up under
> /sys/module/*/sections/. The section has one instance per CPU and no
> single address to report, and the entry never existed before, so
> skip it in add_sect_attrs(). add_notes_attrs() indexes its attrs[]
> array and skips it too. No functional change otherwise.

And IIUC no userspace-visible changes too, right?

>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@su=
se.com/ [1]
> Suggested-by: Petr Pavlu <petr.pavlu@suse.com>
> Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/module.h   |  2 ++
>  kernel/module/internal.h |  8 ++++++++
>  kernel/module/kallsyms.c | 13 +++----------
>  kernel/module/main.c     | 32 +++++++++++++++++---------------
>  kernel/module/sysfs.c    | 17 +++++++++++++----
>  5 files changed, 43 insertions(+), 29 deletions(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 96cc98568eea..0c6f32ddcbf2 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -325,6 +325,8 @@ enum mod_mem_type {
>         MOD_INIT_RODATA,
>
>         MOD_MEM_NUM_TYPES,
> +
> +       MOD_STANDALONE =3D -2,
>         MOD_INVALID =3D -1,
>  };
>
> diff --git a/kernel/module/internal.h b/kernel/module/internal.h
> index 061161cc79d9..4c738074a27b 100644
> --- a/kernel/module/internal.h
> +++ b/kernel/module/internal.h
> @@ -29,6 +29,14 @@
>  #define SH_ENTSIZE_TYPE_MASK   ((1UL << SH_ENTSIZE_TYPE_BITS) - 1)
>  #define SH_ENTSIZE_OFFSET_MASK ((1UL << (BITS_PER_LONG - SH_ENTSIZE_TYPE=
_BITS)) - 1)
>
> +/*
> + * Marker for sections with a separate allocation, which are not placed
> + * into mod->mem[].
> + */
> +#define SH_ENTSIZE_STANDALONE                                  \
> +       (((unsigned long)MOD_STANDALONE & SH_ENTSIZE_TYPE_MASK) \
> +        << SH_ENTSIZE_TYPE_SHIFT)
> +
>  /* Maximum number of characters written by module_flags() */
>  #define MODULE_FLAGS_BUF_SIZE (TAINT_FLAGS_COUNT + 4)
>
> diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> index f23126d804b2..0dca6d40160e 100644
> --- a/kernel/module/kallsyms.c
> +++ b/kernel/module/kallsyms.c
> @@ -76,7 +76,7 @@ static char elf_type(const Elf_Sym *sym, const struct l=
oad_info *info)
>  }
>
>  static bool is_core_symbol(const Elf_Sym *src, const Elf_Shdr *sechdrs,
> -                          unsigned int shnum, unsigned int pcpundx)
> +                          unsigned int shnum)
>  {
>         const Elf_Shdr *sec;
>         enum mod_mem_type type;
> @@ -86,11 +86,6 @@ static bool is_core_symbol(const Elf_Sym *src, const E=
lf_Shdr *sechdrs,
>             !src->st_name)
>                 return false;
>
> -#ifdef CONFIG_KALLSYMS_ALL
> -       if (src->st_shndx =3D=3D pcpundx)
> -               return true;
> -#endif
> -
>         sec =3D sechdrs + src->st_shndx;
>         type =3D sec->sh_entsize >> SH_ENTSIZE_TYPE_SHIFT;
>         if (!(sec->sh_flags & SHF_ALLOC)
> @@ -131,8 +126,7 @@ void layout_symtab(struct module *mod, struct load_in=
fo *info)
>         /* Compute total space required for the core symbols' strtab. */
>         for (ndst =3D i =3D 0; i < nsrc; i++) {
>                 if (i =3D=3D 0 || is_livepatch_module(mod) ||
> -                   is_core_symbol(src + i, info->sechdrs, info->hdr->e_s=
hnum,
> -                                  info->index.pcpu)) {
> +                   is_core_symbol(src + i, info->sechdrs, info->hdr->e_s=
hnum)) {
>                         strtab_size +=3D strlen(&info->strtab[src[i].st_n=
ame]) + 1;
>                         ndst++;
>                 }
> @@ -199,8 +193,7 @@ void add_kallsyms(struct module *mod, const struct lo=
ad_info *info)
>         for (ndst =3D i =3D 0; i < kallsyms->num_symtab; i++) {
>                 kallsyms->typetab[i] =3D elf_type(src + i, info);
>                 if (i =3D=3D 0 || is_livepatch_module(mod) ||
> -                   is_core_symbol(src + i, info->sechdrs, info->hdr->e_s=
hnum,
> -                                  info->index.pcpu)) {
> +                   is_core_symbol(src + i, info->sechdrs, info->hdr->e_s=
hnum)) {
>                         ssize_t ret;
>
>                         mod->core_kallsyms.typetab[ndst] =3D
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index c1b34dc1e89a..ae2678ac7840 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -1619,12 +1619,13 @@ static int apply_relocations(struct module *mod, =
const struct load_info *info)
>
>                 /*
>                  * Don't bother with non-allocated sections.
> -                * An exception is the percpu section, which has separate=
 allocations
> -                * for individual CPUs. We relocate the percpu section in=
 the initial
> -                * ELF template and subsequently copy it to the per-CPU d=
estinations.
> +                *
> +                * Note that .data..percpu has separate allocations for
> +                * individual CPUs. We relocate the section in the
> +                * initial ELF template and subsequently copy it to the
> +                * per-CPU destinations.
>                  */
> -               if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC) &&
> -                   (!infosec || infosec !=3D info->index.pcpu))
> +               if (!(info->sechdrs[infosec].sh_flags & SHF_ALLOC))
>                         continue;
>
>                 if (info->sechdrs[i].sh_flags & SHF_RELA_LIVEPATCH)
> @@ -1715,7 +1716,7 @@ static void __layout_sections(struct module *mod, s=
truct load_info *info, bool i
>
>                         if ((s->sh_flags & masks[m][0]) !=3D masks[m][0]
>                             || (s->sh_flags & masks[m][1])
> -                           || s->sh_entsize !=3D ~0UL
> +                           || s->sh_entsize !=3D ~0UL /* offset or stand=
alone */
>                             || is_init !=3D module_init_layout_section(sn=
ame))
>                                 continue;
>
> @@ -1745,16 +1746,10 @@ static void __layout_sections(struct module *mod,=
 struct load_info *info, bool i
>  /*
>   * Lay out the SHF_ALLOC sections in a way not dissimilar to how ld
>   * might -- code, read-only data, read-write data, small data.  Tally
> - * sizes, and place the offsets into sh_entsize fields: high bit means i=
t
> - * belongs in init.
> + * sizes, and place the offsets into sh_entsize fields.
>   */
>  static void layout_sections(struct module *mod, struct load_info *info)
>  {
> -       unsigned int i;
> -
> -       for (i =3D 0; i < info->hdr->e_shnum; i++)
> -               info->sechdrs[i].sh_entsize =3D ~0UL;
> -
>         pr_debug("Core section allocation order for %s:\n", mod->name);
>         __layout_sections(mod, info, false);
>
> @@ -2822,7 +2817,8 @@ static int move_module(struct module *mod, struct l=
oad_info *info)
>                 Elf_Shdr *shdr =3D &info->sechdrs[i];
>                 const char *sname;
>
> -               if (!(shdr->sh_flags & SHF_ALLOC))
> +               if (!(shdr->sh_flags & SHF_ALLOC)
> +                   || shdr->sh_entsize =3D=3D SH_ENTSIZE_STANDALONE)
>                         continue;
>
>                 sname =3D info->secstrings + shdr->sh_name;
> @@ -2954,6 +2950,7 @@ core_param(module_blacklist, module_blacklist, char=
p, 0400);
>  static struct module *layout_and_allocate(struct load_info *info, int fl=
ags)
>  {
>         struct module *mod;
> +       unsigned int i;
>         int err;
>
>         /* Allow arches to frob section contents and sizes.  */
> @@ -2967,8 +2964,13 @@ static struct module *layout_and_allocate(struct l=
oad_info *info, int flags)
>         if (err < 0)
>                 return ERR_PTR(err);
>
> +       /* Repurpose sh_entsize to track where each section is allocated.=
 */
> +       for (i =3D 0; i < info->hdr->e_shnum; i++)
> +               info->sechdrs[i].sh_entsize =3D ~0UL;
> +
>         /* We will do a special allocation for per-cpu sections later. */
> -       info->sechdrs[info->index.pcpu].sh_flags &=3D ~(unsigned long)SHF=
_ALLOC;
> +       if (info->index.pcpu)
> +               info->sechdrs[info->index.pcpu].sh_entsize =3D SH_ENTSIZE=
_STANDALONE;
>
>         /*
>          * Mark relevant sections as SHF_RO_AFTER_INIT so layout_sections=
() can
> diff --git a/kernel/module/sysfs.c b/kernel/module/sysfs.c
> index 01c65d608873..15c6baeb39c4 100644
> --- a/kernel/module/sysfs.c
> +++ b/kernel/module/sysfs.c
> @@ -62,6 +62,15 @@ static void free_sect_attrs(struct module_sect_attrs *=
sect_attrs)
>         kfree(sect_attrs);
>  }
>
> +/*
> + * .data..percpu has a separate allocation per CPU and no single
> + * address to report.
> + */
> +static bool sect_visible(const struct load_info *info, unsigned int i)
> +{
> +       return !sect_empty(&info->sechdrs[i]) && i !=3D info->index.pcpu;
> +}
> +
>  static int add_sect_attrs(struct module *mod, const struct load_info *in=
fo)
>  {
>         struct module_sect_attrs *sect_attrs;
> @@ -72,7 +81,7 @@ static int add_sect_attrs(struct module *mod, const str=
uct load_info *info)
>
>         /* Count loaded sections and allocate structures */
>         for (i =3D 0; i < info->hdr->e_shnum; i++)
> -               if (!sect_empty(&info->sechdrs[i]))
> +               if (sect_visible(info, i))
>                         nloaded++;
>         sect_attrs =3D kzalloc_flex(*sect_attrs, attrs, nloaded);
>         if (!sect_attrs)
> @@ -92,7 +101,7 @@ static int add_sect_attrs(struct module *mod, const st=
ruct load_info *info)
>         for (i =3D 0; i < info->hdr->e_shnum; i++) {
>                 Elf_Shdr *sec =3D &info->sechdrs[i];
>
> -               if (sect_empty(sec))
> +               if (!sect_visible(info, i))
>                         continue;
>                 sysfs_bin_attr_init(sattr);
>                 sattr->attr.name =3D
> @@ -159,7 +168,7 @@ static int add_notes_attrs(struct module *mod, const =
struct load_info *info)
>         /* Count notes sections and allocate structures.  */
>         notes =3D 0;
>         for (i =3D 0; i < info->hdr->e_shnum; i++)
> -               if (!sect_empty(&info->sechdrs[i]) &&
> +               if (sect_visible(info, i) &&
>                     info->sechdrs[i].sh_type =3D=3D SHT_NOTE)
>                         ++notes;
>
> @@ -181,7 +190,7 @@ static int add_notes_attrs(struct module *mod, const =
struct load_info *info)
>
>         nattr =3D &notes_attrs->attrs[0];
>         for (loaded =3D i =3D 0; i < info->hdr->e_shnum; ++i) {
> -               if (sect_empty(&info->sechdrs[i]))
> +               if (!sect_visible(info, i))
>                         continue;
>                 if (info->sechdrs[i].sh_type =3D=3D SHT_NOTE) {
>                         sysfs_bin_attr_init(nattr);
> --
> 2.25.1
>

