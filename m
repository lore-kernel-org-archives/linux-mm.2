Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E84AC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:06:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32F306B008A; Thu, 17 Sep 2026 20:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0486B008C; Thu, 17 Sep 2026 20:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2056B0092; Thu, 17 Sep 2026 20:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27566B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:06:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 822611C275D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:06:04 +0000 (UTC)
X-FDA: 85224940248.01.651A58B
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 98EC61C0008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:06:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fX2mt22B;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789689962;
	b=p7J5LxdnCUhu6d++xKffSvcvWdLHde8ElHCGqQeU4RQzxCVY1TyMO5ihc69w6/ZodV7gcb
	kP9bRklkwFZaLFBFAo83/k+3xlA48yUkn84f93zohgs6mHGiTmC6ulC2mLUGp0prHAJEpQ
	kALtGSxAtEp4VtVO3vLBGkYenway8Sg=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fX2mt22B;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789689962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKIZfh7L/9iy7pYAqHEsnUPc7J9L27b73sdn5xk9SqU=;
	b=BjgErtkSL+UvfvZsZVG4Sb2Lz1IORMbKqhSOfrjM0hO0kJCclrxBdgYhpdRuPQl8+huro9
	3+XV5vmUADgZEwu3FsVJ+5OF/AtABqlpijn74MqIbpk1My25EBHFa9OjG6KTB72Jx+2TUB
	Lg5vq45KLDKpTTWM1butn/aBY4qf1kg=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-53113d72966so93241cf.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:06:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789689962; cv=none;
        d=google.com; s=arc-20260327;
        b=iR4wav0ieE9gsaH7tnoHZSahmRbIjXz5WarOjnsbpnc2JfS+O5BkA+vw0Uzy7g2YXX
         033/grVe3GOfzNgCGUl4QC3B62iARTAZMQkVLNJCNaSxPG6SBI9/IekEtV7MR+qN9zoC
         kDVGtj+GunrZ9IqA1paWGTzZ0ntg+x7KBGQvxSiC1VkkP1zzxM1f1Z5rfMTsqaULlKYA
         G+K2uXM/rjbXTBXhXXIk1YzW9o442468kB6YSvvmesoryJ7djUA0frE/EAFmWAPpDWuj
         vgoteAppbbuFkLbnWD0RQLW9/V1YC+4chkRjMZpOlurYox7dEQcfYXJd3sBUrX7OwN8U
         +tJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nKIZfh7L/9iy7pYAqHEsnUPc7J9L27b73sdn5xk9SqU=;
        fh=OwOpiC7fFiQXpSJv4k5cklR3ZLPe4NooRRMzQY8GVuI=;
        b=rtn6san0178JfjAT/1peomLPip957zNFtX2WapiRpFsrn3zCTD3RcAtg1j2xsfDtlB
         2U6E6QQrHhZckUJv+YaYRiF7lMNzmZn2Ub/1VQddeJsEHvpU+XklEyFq+m/hZDcONI7w
         GJZgTcDMJ+uxVZCf0+qUl08C2BZGsSrD1DiTsDdqXFfF240rJw+kep6iwx2CCBH3pTom
         psmdyb+cdyEzJvyu4nix9MgSCY6tqFYugyCb4npJEx+gpaKCcUaHUVEigAHDNUpOogQm
         /U2g47FO0uXDIHWxWszWqreuJodCJJSKlh/U0i+iE/zwniFB3lrL/fQ9pyynb3aA4FFY
         K6WQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789689962; x=1790294762; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nKIZfh7L/9iy7pYAqHEsnUPc7J9L27b73sdn5xk9SqU=;
        b=fX2mt22BYVPGsValF86By1TPL3nZRnXupf+BY6AJwmALzyZgFiHOHO05meivMqLlIY
         LQLwu/qfQVlf7ZRb9cCc++UmJku8aAQVsTYkkhLAcF/yDjD9QpRj/2PYk2c6V0BfUz8w
         QbR9kSBqL/qLgCDPSOTc9OGJUfQLHwlQV9eIb+eZLmKGqil3OvC2r4EGZDV61oDzMatu
         x/xH2pXTB98Nzaej0K3WLY3hRJG116msSwjkhgyDhxLoqpb++ji657mBVfCeQ8cCdX/X
         4k2lrvwSwPeG7KM6iHmUhiiuCnLMopnXk8rUNiybaHgxBDMEjmO5iF5Obk9WQbnjugx/
         9RVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789689962; x=1790294762;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nKIZfh7L/9iy7pYAqHEsnUPc7J9L27b73sdn5xk9SqU=;
        b=zVam3C5DYBQV05b6rFwTHpAWn9RXYG5hgbnkNrTlM20ac7Q8+gKqTcaWqEnRuCvn0H
         FQiapJNe6DWHSxEHFLtxL2mcSLe9dRHCwf4fVlxRBZ6MCVsp0MwE1UYLZ3S9OwK2AIqo
         oEs+ojQqGyq8fNFSTIApDac/8kJZi0+Tc27XqIbGtgijsxeEkgB6PsBcNhH/taRK1xF4
         itlPEUKtA5IGM0OI5Rw2H6hufm+tV0mOg7Q5C9y744FX2lFibG0XIgqK1iLbZkJFRqlf
         03Jgt7ekrA+nt9g4gzBWqrnKne3M9nB3QG4O6c8ufTRnNx7jBIAivroMmu9ZCSAfpdzE
         WvFQ==
X-Forwarded-Encrypted: i=1; AKwUvBw7Va0OvqrCI8mod3S+sdOIOh2pHVqMyrOF6kiDjnmX4FAjsmDKAE4yVD13t3V3xeXz88goLu5hfg==@kvack.org
X-Gm-Message-State: AFuF++li9Dx94sYgb79SeIAfP5TjI+SrOeKirCU8DAAI+10FbQi6B9Vh
	q9N8uqejVXRaDUt6OS8GhouVbH74/lFeiwZnhIRang9s1aOKPOEFSe7rozFqUqZGS/KcIEEcUST
	jFm0cuGg1OIfev9qXDpKrcPyJRHB8Csvw8JOjBka3
X-Gm-Gg: AYBFou19KU+KCkzeQvlnGpUCLyuxBC8o6AFqbFHDD8j0Z81RACQwq+NgnbryRfK/LsD
	tjPa8cLPPaj6lbPb7qdrMHUJa5eWCzBKJ+d4wVA49zNvNORSTTo8gAEpdlbD/Lp0RSWnbIn7kow
	mXo9XNA+FFOyL1if37+sjcgtj61PquLjlI7LFe5r4DCVquqAhlTLsHMY6ssfAaEtGj5cYEQcu44
	wVRJIg0bFcD3jArfOahWb7BSw/eUjlpQ3hL7zOSe+OvQNKVkGSUYMvA9BOsb/R3xBHUG+rpfSFf
	0R3Kp6WIJGD95/ylN0bOa9GCuQ9/sHZS+n3ZX7MDKZgPAr1/ZmJlcw==
X-Received: by 2002:a05:622a:355:b0:532:9d15:2e5a with SMTP id
 d75a77b69052e-5329f156af3mr3916691cf.1.1789689960917; Thu, 17 Sep 2026
 17:06:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-5-hao.ge@linux.dev>
In-Reply-To: <20260915070001.113559-5-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 17 Sep 2026 17:05:49 -0700
X-Gm-Features: AcwNN1XAOT_17fQE5yjXnFf9eEwp8M54bYI5rVj3bt4gohWMRB35SlFkGCcgPLA
Message-ID: <CAJuCfpFQ8v8poeYNcuLd6azkR4O6wyHOv7+C=RfQGVWx4o935w@mail.gmail.com>
Subject: Re: [PATCH v10 4/6] module: allocate codetag sections before the
 regular module layout
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 98EC61C0008
X-Rspam-User: 
X-Stat-Signature: 1373hzdrnaqfn7ao4qnt3nu8ktojqyrn
X-HE-Tag: 1789689962-814920
X-HE-Meta: U2FsdGVkX19DEh1VbyuXYJbP6gZavhb2DupgfkSWbdbnuiGyrCk6JsERnH4hqRmT+v5FK3shvrZohReiFUl/9mvj3RAHmPyrP+2R1j8xVg19HMVSEjcW81mT6drAvTj1EUG7Z1W4DnaYlzJ2HHwJRSyAgZ1XPnbKpVCxElBpvHScvzSr/nv7hTk7Dp2jx50NsJ7pimpj8L+U9lTVin2jUI8svLU6iCJkAYrHYDd6nVaXpoZZGaMp4ZriOqTQOd2qRfZxk1fA1/6jp/rJAGVFkvuiXP3Z7bzpvltP5DSEYdatnxM0IRrAbQbHL6+IL5u9K8UbgmPOXWEsnaMTBnn3xPG2q3fcgEx9ED7LhbLfJ1lmOJaop2sG7wpa1rIVb+McuzR1NFaX7ByNBrcRGQA6OUFk+wO3GWpZzZIcdnijOfj328/ky7woiF5m5rGvH4UB7R16KHdNKOEwczQstkS1/xyWbQ47mJeD2UWpXjVKCc4nKib1qwjMzJy4snfP5iDwUZ9K6Pyb2vuGE4RLQ94jngXmw/yRh7rsQzXhLn7MUbXElsIecG+Lj/6HGGhWBtp8kyYwf7lWWXUsTwj1phBZAqEWOmIlibynLi1lv5N0dnLhP4666k9gBciziZbGuL2faDCdXZduldTQoZQUVckokYSFQd+teMLj1HtDzNtfJ+KQoQb0xRLR09X0PL8ByQTZgqQDKODnXDD+NHkP8/XGSf/aIe6L8/l0aAEyNFA4f2nYo7HZMS3cmmGcvmLDToxSmLOmTWuaOOtZyRkSQEqR5JLmDPXKwccqij7fW2Nn7rZwLOefOT0RgxfthkAu5Amns4ZtiYDcdMO5gNcj8MiiCuuvvxttdNK2uLPm8DuuEtgVvg3Tk3JbSzZ82rBUArs88TwTFsVUWzZOMyxn+UgUJnDVefNEZtqces38mZC6C6rmG8DK88Vxwu7qRsX5D3N3KWHCev55kzfe4VoEupd
 j8gYYFcS
 aTHX6un4Eb8AcdgiJyLCyrt1nUc3KPod9eP6WOhHekFIVm5ebNMmX8VZAYOWzJRAXSLGzBAgrng03jtuKR4fKaGLa1ngkxBfU1/2oot+ycqQjwaWb48q7ePIhcI+lQBGeDKD9ldYacIZu+gWd9DxTVu1tKPLtIyZXRbn3Jk2FsEeJDvg1hXjZ/odp/zwDfFpqV+zJQ0uB64DIUqn/U1qdYqa32ZfoayifZOt+tbISBhbx/8i7I9fkzrPJOiv2l6HutbnqCvZnIAgQ/JG/U6m5rEghJZbca/w/58J/uG7MR7qE/TjWrn5m42vMGCjRMHsKJG/BgyIMYf+GCpIqbSsAXHJ/gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> Whether a codetag section goes to the codetag region is decided by
> layout_sections() and asked again in move_module(). A concurrent
> load can shut profiling down in between, and move_module() then
> copies the section to offset 0 of its regular destination,
> overwriting whatever is there.
>
> Decide and allocate in one pass, before the layout. Allocation
> errors fail the load. On a tag area overflow profiling is already
> disabled, so -EAGAIN makes the section fall back to regular module
> data and the module still loads. The reservation is released and
> module_tags.size rolled back, so a concurrent load which already
> passed needs_section_mem() does not skip vm_module_tags_populate().
>
> An SHT_NOBITS codetag section is zeroed explicitly, the tag area
> pages are not zeroed on allocation.
>
> When profiling was toggled off the overflow check did not run, a
> module could load with more tags than the page flags can address,
> and re-enabling profiling then silently corrupted /proc/allocinfo.
> The check no longer depends on mem_alloc_profiling_enabled().
>
> Based on a patch by Petr Pavlu [1].
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Link: https://lore.kernel.org/all/499bb60c-c6e3-43a3-bd92-95a0567ece5e@su=
se.com/ [1]
> Reviewed-by: Petr Pavlu <petr.pavlu@suse.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Makes the logic much simpler. Thanks!

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  kernel/module/main.c | 101 +++++++++++++++++++++++--------------------
>  mm/alloc_tag.c       |   9 ++--
>  2 files changed, 60 insertions(+), 50 deletions(-)
>
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index ae2678ac7840..b7ebcc40bdda 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -1723,20 +1723,6 @@ static void __layout_sections(struct module *mod, =
struct load_info *info, bool i
>                         if (WARN_ON_ONCE(type =3D=3D MOD_INVALID))
>                                 continue;
>
> -                       /*
> -                        * Do not allocate codetag memory as we load it i=
nto
> -                        * preallocated contiguous memory.
> -                        */
> -                       if (codetag_needs_module_section(mod, sname, s->s=
h_size)) {
> -                               /*
> -                                * s->sh_entsize won't be used but popula=
te the
> -                                * type field to avoid confusion.
> -                                */
> -                               s->sh_entsize =3D ((unsigned long)(type) =
& SH_ENTSIZE_TYPE_MASK)
> -                                               << SH_ENTSIZE_TYPE_SHIFT;
> -                               continue;
> -                       }
> -
>                         s->sh_entsize =3D module_get_offset_and_type(mod,=
 type, s, i);
>                         pr_debug("\t%s\n", sname);
>                 }
> @@ -2795,7 +2781,6 @@ static int move_module(struct module *mod, struct l=
oad_info *info)
>  {
>         int i, ret;
>         enum mod_mem_type t =3D MOD_MEM_NUM_TYPES;
> -       bool codetag_section_found =3D false;
>
>         for_each_mod_mem_type(type) {
>                 if (!mod->mem[type].size) {
> @@ -2815,35 +2800,13 @@ static int move_module(struct module *mod, struct=
 load_info *info)
>         for (i =3D 0; i < info->hdr->e_shnum; i++) {
>                 void *dest;
>                 Elf_Shdr *shdr =3D &info->sechdrs[i];
> -               const char *sname;
>
>                 if (!(shdr->sh_flags & SHF_ALLOC)
>                     || shdr->sh_entsize =3D=3D SH_ENTSIZE_STANDALONE)
>                         continue;
>
> -               sname =3D info->secstrings + shdr->sh_name;
> -               /*
> -                * Load codetag sections separately as they might still b=
e used
> -                * after module unload.
> -                */
> -               if (codetag_needs_module_section(mod, sname, shdr->sh_siz=
e)) {
> -                       dest =3D codetag_alloc_module_section(mod, sname,=
 shdr->sh_size,
> -                                       arch_mod_section_prepend(mod, i),=
 shdr->sh_addralign);
> -                       if (WARN_ON(!dest)) {
> -                               ret =3D -EINVAL;
> -                               goto out_err;
> -                       }
> -                       if (IS_ERR(dest)) {
> -                               ret =3D PTR_ERR(dest);
> -                               goto out_err;
> -                       }
> -                       codetag_section_found =3D true;
> -               } else {
> -                       enum mod_mem_type type =3D shdr->sh_entsize >> SH=
_ENTSIZE_TYPE_SHIFT;
> -                       unsigned long offset =3D shdr->sh_entsize & SH_EN=
TSIZE_OFFSET_MASK;
> -
> -                       dest =3D mod->mem[type].base + offset;
> -               }
> +               dest =3D mod->mem[shdr->sh_entsize >> SH_ENTSIZE_TYPE_SHI=
FT].base +
> +                      (shdr->sh_entsize & SH_ENTSIZE_OFFSET_MASK);
>
>                 if (shdr->sh_type !=3D SHT_NOBITS) {
>                         /*
> @@ -2875,8 +2838,6 @@ static int move_module(struct module *mod, struct l=
oad_info *info)
>         module_memory_restore_rox(mod);
>         while (t--)
>                 module_memory_free(mod, t);
> -       if (codetag_section_found)
> -               codetag_free_module_sections(mod);
>
>         return ret;
>  }
> @@ -2947,6 +2908,49 @@ static bool blacklisted(const char *module_name)
>  }
>  core_param(module_blacklist, module_blacklist, charp, 0400);
>
> +/*
> + * Allocate codetag sections separately. They are loaded into preallocat=
ed
> + * contiguous memory because they may still be used after the module is
> + * unloaded.
> + *
> + * If the separate allocation overflows, allocate the section normally
> + * so that the module can still be loaded.
> + */
> +static int allocate_codetag_sections(struct load_info *info)
> +{
> +       for (unsigned int i =3D 1; i < info->hdr->e_shnum; i++) {
> +               Elf_Shdr *shdr =3D &info->sechdrs[i];
> +               const char *sname =3D info->secstrings + shdr->sh_name;
> +               void *dest;
> +
> +               if (!codetag_needs_module_section(info->mod, sname, shdr-=
>sh_size))
> +                       continue;
> +
> +               dest =3D codetag_alloc_module_section(info->mod, sname, s=
hdr->sh_size,
> +                               arch_mod_section_prepend(info->mod, i), s=
hdr->sh_addralign);
> +               if (WARN_ON(!dest)) {
> +                       codetag_free_module_sections(info->mod);
> +                       return -EINVAL;
> +               }
> +               if (dest =3D=3D ERR_PTR(-EAGAIN))
> +                       /* Allocate the section as a regular section. */
> +                       continue;
> +               if (IS_ERR(dest)) {
> +                       codetag_free_module_sections(info->mod);
> +                       return PTR_ERR(dest);
> +               }
> +
> +               if (shdr->sh_type !=3D SHT_NOBITS)
> +                       memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size=
);
> +               else
> +                       memset(dest, 0, shdr->sh_size);
> +               shdr->sh_addr =3D (unsigned long)dest;
> +               shdr->sh_entsize =3D SH_ENTSIZE_STANDALONE;
> +       }
> +
> +       return 0;
> +}
> +
>  static struct module *layout_and_allocate(struct load_info *info, int fl=
ags)
>  {
>         struct module *mod;
> @@ -2979,18 +2983,21 @@ static struct module *layout_and_allocate(struct =
load_info *info, int flags)
>          */
>         module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstri=
ngs);
>
> -       /*
> -        * Determine total sizes, and put offsets in sh_entsize.  For now
> -        * this is done generically; there doesn't appear to be any
> -        * special cases for the architectures.
> -        */
> +       /* Allow codetag sections to be allocated separately first. */
> +       err =3D allocate_codetag_sections(info);
> +       if (err)
> +               return ERR_PTR(err);
> +
> +       /* Determine total sizes and put offsets in sh_entsize. */
>         layout_sections(info->mod, info);
>         layout_symtab(info->mod, info);
>
>         /* Allocate and move to the final place */
>         err =3D move_module(info->mod, info);
> -       if (err)
> +       if (err) {
> +               codetag_free_module_sections(info->mod);
>                 return ERR_PTR(err);
> +       }
>
>         /* Module has been copied to its final place now: return it. */
>         mod =3D (void *)info->sechdrs[info->index.mod].sh_addr;
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 95ddf5b743d0..5836803898ad 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -958,10 +958,13 @@ static void *reserve_module_tags(struct module *mod=
, unsigned long size,
>                 int grow_res;
>
>                 module_tags.size =3D offset + size;
> -               if (mem_alloc_profiling_enabled() && !tags_addressable())=
 {
> +               if (!tags_addressable()) {
>                         shutdown_mem_profiling(true);
> -                       pr_warn("With module %s there are too many tags t=
o fit in %d page flag bits. Memory allocation profiling is disabled!\n",
> -                               mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +                       pr_warn_once("With module %s there are too many t=
ags to fit in %d page flag bits. Memory allocation profiling is disabled!\n=
",
> +                                    mod->name, NR_UNUSED_PAGEFLAG_BITS);
> +                       release_module_tags(mod, false);
> +                       module_tags.size =3D prev_size;
> +                       return ERR_PTR(-EAGAIN);
>                 }
>
>                 grow_res =3D vm_module_tags_populate();
> --
> 2.25.1
>

