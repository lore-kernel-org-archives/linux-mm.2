Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43DEFC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:22:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61F96B033F; Sat, 15 Aug 2026 02:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D12CD6B0340; Sat, 15 Aug 2026 02:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01806B0341; Sat, 15 Aug 2026 02:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 997686B033F
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:22:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C9C01602E0
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:22:14 +0000 (UTC)
X-FDA: 85102508988.01.E296985
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 24405140003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:22:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iDnsGDm0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786774932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OBKzlS6zgLX7HjDf60a09oLwp2mBkH0MhIIWPg5JjtQ=;
	b=BqWtWrH5u2NylNvXeRCBCp41gWfxNp+dM1vv4HSZ0GlQfHZ+u4kJejNAfg2p62Lze5GBLa
	0xCKUbmeKfssKzEZEGoWVoWCBmugUK3NByH1qiYmI/VDBoJdXj6zFyvLsbp0HH56SQJUMr
	ov+zjp9+oS5nZZkT0pssWv5DMxrmhbE=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iDnsGDm0;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786774932;
	b=mlj62EzmVna7XqdVQVSrRllmPHSK55AdcpaRKTUiGKK97PmNUObQtskq6kiXoaCoLtDWfz
	qSNOusZigKP20FPj2qDtf8LNpKvDz6AIy/RivV5pKt3c7q5+3xbnrOTtqfbVre+jz8JI0j
	/aCv4tQphoDNPN/FeD+iLqAMf2/SWNI=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c15a5b265so418401cf.0
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:22:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786774931; cv=none;
        d=google.com; s=arc-20260327;
        b=J9I2fzUgG4akbOHL1jaNzJPCGS48paq/ALFOloEzf+3JS/GiK5jnxGJZC2CB6pgTiA
         rLdTLo7kAfuVGiU+wgBXJCRq5qfvyCcZDG5vSbhEyXjICUr3zpXsIuZ7UGryyi5S1Z6f
         eDpb8gY3Pe/QLv0ket2n3LUl+61/KbTjRcv4jYIjjogXDD1ASs9sO8Ha1VcIwXRAnIvf
         ycY+9g6C36BIuV3+2wCbe6//CB5OHdfIZBpNNcG513i+GleTwAzemSjutqHWN8k5h1he
         GzIyfF5G1kx5N40BeIlqXh1c9qZ1xoMvO1ow4yrwwSZm3bjFwQSdnsUqT2X00E62JNfL
         GerQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OBKzlS6zgLX7HjDf60a09oLwp2mBkH0MhIIWPg5JjtQ=;
        fh=nsGwMZIFpZskAbQNSWw7pjfA5kY+Olu/a+rPOglkp5E=;
        b=qISSbQGJzhpS5NvBhqARCRVmbbPiJwj+3hFNA4VJOVNphjKWIALcS232GNrDi8fANs
         JPbPSu2fBMdq3e2+R3vl0ZCIOlY4QSk7TQ/bWpjfHJilTpcVNliRj00lRGia0xToEAOb
         pamLvNlIh0D+UKCD7BAwTvDV1ZkRgC1ortYkYyoJHF+P+0ZP/tqcxJL3nmDnkr+OI/xL
         Mli19d4dve9PbbwRCQIuOlCvNv2zHucyqgEos/Zk0PKZ3pmI3DywK939YnUIrOcG5zPE
         wj8crH7fFN/WVDHEekCrtazhGrh8USypE8BgScYNw+PLWj55UuBfBUm4EpmHj/EdVVq/
         Twdw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786774931; x=1787379731; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OBKzlS6zgLX7HjDf60a09oLwp2mBkH0MhIIWPg5JjtQ=;
        b=iDnsGDm0xZ98N4IhjEmXLTQkEP7KoEHI2Gj8GHXKmv8aYMcosaxLVwYpHBhfFsEmhC
         d6eC8UEVi0VmzEO8ttHed9VZgI6RUMlsmPxycFCtNoG99X0i0mpCI3UJX3umXDBZpf2D
         rvizJVd8cIUJ1e8j7Mse9UDpg03rarylT/5zDQ+QZTSsEWewam4wN/+PqT2SkrqxFTkX
         qvDnwxZO8aqhYR6ADNtwCIKBWBZ5Dcg/VEaARyMMkw4z3uWbOdwqb3sdsz3IdJka/t5A
         H4pWATr9pkr9w7A4U5EO/TGxfbCx1jv8j36bKlR8TWFLnte1hEo8wt90brlP1Kx2qovv
         t01g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786774931; x=1787379731;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OBKzlS6zgLX7HjDf60a09oLwp2mBkH0MhIIWPg5JjtQ=;
        b=WcH0YrDpQX+bqG/v5bs9NEITr/OPEaKW2IK89eqJNJ8/gQW6JUIPHXT5HRMWTh8jJH
         J6MZQaWbxnc6o/ho+YNgDalmbtELPmVTYgcDgCd1g6CVfkZeOGTS49gc9o7Rw1M8zWSs
         pifFV4H59Gss7YlCbUPP3x0tfSEBN8TSYY98vgwn+f99VwBrq5nvu8F4cVNCSa9DV7GO
         RYXhfCrKOZIKVP9cclmPFbWT3vYJlmIpfNrkzHoV4/phqe6FkRY7SihDzOfT/j0RlTrK
         8sgU2irQWloWMcSeWPUPhVkjy++iM+K4yfuktrTHnxA0TciPeWG8W602SYSkKMj1acFd
         glKw==
X-Forwarded-Encrypted: i=1; AHgh+Rohmg/sYmDysI+7A4gYLC2qxiJQrhpXr3P7JVIS+iqIWkkfdfwrdEJc6tKu3fAIgjzVFHc1addrgg==@kvack.org
X-Gm-Message-State: AOJu0Yzf4QYETK6fY4YRVRZR1nloaPkTogfeXxmKF6zjxVZ7embxPqPl
	aO45NfhWDXaL7kl4b60oaBEXVf9B5wEiP7MnvbFF94lOUbXxSu3PiYLZRQKOPQGclfT/3Er4yvd
	APcUX/9ytqKoXwaEtFLUDQCGMrmGLE5L7DI7i6pAl
X-Gm-Gg: AR+sD10U1clt+l5kiC/ZV+nKu5ZIgI1lKxYRu+/PWEk416JVyAPgs+xlO6ua4F3M/TW
	JLtqCpH8f39EDOWuyOOk2OAuL1zGbP5afiCdoKUI0UEZiUzKpUGBKiS5IT0SVpPzWNDtqxrfcsX
	Zue9jtOUjF1RFLWw8mK0ePHoUhQi1ssCvYUnYwo1UGzDzNA9YvzSoNu9UbP3VCtvr3pc5tDS5dT
	SfbQwWDQc2I3zZ6syih3TFyjfl1mpMjUUBD7hDgVeGNFYS3vRR/YiijIpDba3AA9UC6L52lhoOW
	TcnIwRlLH0ARPIEmM0ExaT85rM2VW9ffz3yb9eshYyg=
X-Received: by 2002:a05:622a:591:b0:52b:4ec6:52ba with SMTP id
 d75a77b69052e-52d845c0170mr30884361cf.6.1786774930473; Fri, 14 Aug 2026
 23:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260813093421.135230-1-hao.ge@linux.dev> <20260813093421.135230-3-hao.ge@linux.dev>
In-Reply-To: <20260813093421.135230-3-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 14 Aug 2026 23:21:58 -0700
X-Gm-Features: AcwNN1XREKpTOkn7MwudQ1sU-GPxwXHRR1fNjOfp72xmvYqYjGc-85rvjZBIN9o
Message-ID: <CAJuCfpHBWFZh5yHHK01CT1i-z=OP74kzGobfYskkqKgBBLx_EQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] module: move codetag section placement decision
 to layout_sections()
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24405140003
X-Stat-Signature: hwj3zebfahc8kb5dhmyp83scm1kkkmxq
X-Rspam-User: 
X-HE-Tag: 1786774931-250220
X-HE-Meta: U2FsdGVkX18cZxajGiAN5P2u++Dg/A0M86EMAoklLRkR4dBwJNTY3JR9xm+Ju3K+T4cHXos+zEzdNP+KRs0hLkxRvvAPX/MLeb7dg21I8vtxs0dxqTuStGDmMlaNAgxrLkM1C4HfgZ/8ik1seXRtPS48VpOVEoGyI9a0VMoKyaiu7rCXfyY5DImr4LaiE+Uiobc6Jph8q9h4RIlT9MGfuCAspSJmFdDLq/W03OIXjePEe1wEFPY1w41Ss/iysTuFpUNCtkYbJ4xTO0Gg46AX0eXyQFfv6k5t5oX4CNGcPKWI9P8ZdunKypQAy4y83wDGxBBG1quu/jgAyaojQxVRgLqKZaopCZWT/59j7ZzQIt9MS8diAWVewtxK9KVRa1fiOGzaHteK4A024hHNg8PE/IgncuJvqm5GpgjnDo04D+HoeaLS43K7ARg/tZEf2kQA4z6t/1pVUp4yE1qA2Ru7DrPFF3yKD4D05LeLKMM/JHl8UcTVsW8u/b0wii1GKtZl/jq8EBRQyja4MIYmcKQ1G/Il/AqoolAIE+JN7Dqypia5CLrr72nqgm9KPRFMa8pD0da9ORboibuV6YmKHD6ZS8fNlDfGbKcrJ8K/aUUSaariqRVAuglLCMDnsmxxSbt8hI4O/y6o/E2asEuRiDC4F2J2N6IFTFNFYDgFSVS2qesEZBfH784c+6sOyHGoZYPDBE4iDo/1E4iV4+Z2ZsTAplcmmk06P8bYio/hq2Becd7u8uvNXDLAYL/nPOVbLanfIA+SAoXvKqjYA4Q+0Ln9zJucj1YFHciyBlRhzOrq+vFHTpSJ2GouD70Ph5oDvNKfc3tyniNeF38VLWTKW2johgbzvYg1w563aiTbFK6XLliznbBOcGCOqckqG3wzTt4NAbc5oWaOTOkABGzevB7G01hSP7C72VCFAMHbH+njuToXqY9z5Dm3n2Ff1D3RSHf2nuWYnmMXPLT7uWLCzj4
 4/J0JnsD
 ujybw+vEAauY8JIg+BR0tyLG4Ci9Y1wpTc98bv+QXNHwXrMJdPgBXs3sbhATYaqZbrjOV+3QlBRY20D+Z6qALPADGoQ51ZDbWVjS/Mk2MEDiRNi+9/ZYdnjz8OmJ51lmv6eyewh0UfaIvalozZ1cCSROyFcZtw6LKE5L4ZAv5v5uuQOOkb4ll0cAJBI1n0Nxi12aPQIPvhvQUDTH7dNP2lf5niLv6Y6VATBzRYq3YRukpvuLLBRwwUZB+kyCGwjB5VPtM/CdqSoH6LBNSL0t2I6P7nx1irWVyopG4JpXIX29sKHO5svNV1bBL9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 2:34=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> codetag_needs_module_section() is called twice per codetag section, once
> in layout_sections() and once in move_module(), and both depend on
> mem_profiling_support, which changes without a lock. If profiling is
> disabled between the two calls, layout excludes the section (offset 0)
> while move copies it as normal memory to offset 0:
>
>   CPU0 (insmod A)                    CPU1 (insmod B)
>   ----------------                   ----------------
>   layout_sections()
>     needs_section_mem() =3D=3D true
>     sh_entsize: type, offset =3D 0
>                                      reserve_module_tags() overflows
>                                        shutdown_mem_profiling()
>                                        mem_profiling_support =3D false
>   move_module()
>     needs_section_mem() =3D=3D false
>     offset =3D sh_entsize & MASK =3D 0
>     memcpy(mod->mem[type].base + 0, ...)
>        -> overwrites the first section there
>
> Record the decision in layout_sections() in sh_entsize using a
> MOD_MEM_CODETAG type, and have move_module() use that instead of asking
> again.
>
> reserve_module_tags() returns -EAGAIN if profiling was disabled after
> layout, so the loader retries and places the section as normal memory.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  include/linux/module.h | 11 +++++++++++
>  kernel/module/main.c   | 17 ++++++-----------
>  mm/alloc_tag.c         |  8 ++++++++
>  3 files changed, 25 insertions(+), 11 deletions(-)
>
> diff --git a/include/linux/module.h b/include/linux/module.h
> index 7566815fabbe..a02016528e1d 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -328,6 +328,17 @@ enum mod_mem_type {
>         MOD_INVALID =3D -1,
>  };
>
> +/*
> + * If CONFIG_CODE_TAGGING is on, modules get a .codetag section.
> + * codetag_needs_module_section() says where it goes: the usual
> + * mod->mem[], or off to the codetag region.
> + *
> + * Mark the codetag-region ones with MOD_MEM_NUM_TYPES.
> + * It's just past the real types, so it doesn't index into mod->mem[]
> + * and for_each_mod_mem_type() skips it.
> + */
> +#define MOD_MEM_CODETAG        MOD_MEM_NUM_TYPES

Ok, it feels a bit hacky but it's probably the simplest way to mark
codetag regions.

> +
>  #define mod_mem_type_is_init(type)     \
>         ((type) =3D=3D MOD_INIT_TEXT ||     \
>          (type) =3D=3D MOD_INIT_DATA ||     \
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index ed26f167be84..2337bf604f58 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -1728,11 +1728,8 @@ static void __layout_sections(struct module *mod, =
struct load_info *info, bool i
>                          * preallocated contiguous memory.
>                          */
>                         if (codetag_needs_module_section(mod, sname, s->s=
h_size)) {
> -                               /*
> -                                * s->sh_entsize won't be used but popula=
te the
> -                                * type field to avoid confusion.
> -                                */
> -                               s->sh_entsize =3D ((unsigned long)(type) =
& SH_ENTSIZE_TYPE_MASK)
> +                               s->sh_entsize =3D ((unsigned long)MOD_MEM=
_CODETAG
> +                                                & SH_ENTSIZE_TYPE_MASK)
>                                                 << SH_ENTSIZE_TYPE_SHIFT;
>                                 continue;
>                         }
> @@ -2815,11 +2812,10 @@ static int move_module(struct module *mod, struct=
 load_info *info)
>                         continue;
>
>                 sname =3D info->secstrings + shdr->sh_name;
> -               /*
> -                * Load codetag sections separately as they might still b=
e used
> -                * after module unload.
> -                */
> -               if (codetag_needs_module_section(mod, sname, shdr->sh_siz=
e)) {
> +
> +               enum mod_mem_type type =3D shdr->sh_entsize >> SH_ENTSIZE=
_TYPE_SHIFT;
> +
> +               if (type =3D=3D MOD_MEM_CODETAG) {
>                         dest =3D codetag_alloc_module_section(mod, sname,=
 shdr->sh_size,
>                                         arch_mod_section_prepend(mod, i),=
 shdr->sh_addralign);
>                         if (WARN_ON(!dest)) {
> @@ -2832,7 +2828,6 @@ static int move_module(struct module *mod, struct l=
oad_info *info)
>                         }
>                         codetag_section_found =3D true;
>                 } else {
> -                       enum mod_mem_type type =3D shdr->sh_entsize >> SH=
_ENTSIZE_TYPE_SHIFT;
>                         unsigned long offset =3D shdr->sh_entsize & SH_EN=
TSIZE_OFFSET_MASK;
>
>                         dest =3D mod->mem[type].base + offset;
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 461fa87fbb0b..7481180dadd2 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -893,6 +893,14 @@ static void *reserve_module_tags(struct module *mod,=
 unsigned long size,
>         if (size < sizeof(struct alloc_tag))
>                 return ERR_PTR(-EINVAL);
>
> +       /*
> +        * Profiling may have been disabled by a concurrent module load.
> +        * Return -EAGAIN so the loader retries with profiling off, layin=
g
> +        * the section out as ordinary module memory.
> +        */
> +       if (!mem_profiling_support)
> +               return ERR_PTR(-EAGAIN);

I think this requires your patch [1] from another patchset to work
correctly, correct? If so, I would suggest sending this patch as part
of that patchset since there is a dependency.

[1] https://lore.kernel.org/all/20260812054105.102637-3-hao.ge@linux.dev/


> +
>         /*
>          * align is always power of 2, so we can use IS_ALIGNED and ALIGN=
.
>          * align 0 or 1 means no alignment, to simplify set to 1.
> --
> 2.25.1
>

