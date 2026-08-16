Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0224AC5DF6D
	for <linux-mm@archiver.kernel.org>; Sun, 16 Aug 2026 15:16:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98786B0836; Sun, 16 Aug 2026 11:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49876B0837; Sun, 16 Aug 2026 11:16:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37A76B0838; Sun, 16 Aug 2026 11:16:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 856016B0836
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 11:16:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D608405AE
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:16:49 +0000 (UTC)
X-FDA: 85107484938.21.BE8BF70
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 29A2D1C0008
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 15:16:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fJEcXgon;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786893407;
	b=JMd8WBdeO+X5F2kEq3U3kBcy/p6UAPj7/sVWCGb9zAJz59TdnDGKBIFY4UkkQG7DAqbYnB
	yFS7kPJ4Bz8TXfHA41tYOJ6b1PYAi507FDUUsjicU8Fp+Hq3lMY5B4gjWXpXNRZowgwUot
	KMQOrnV3m3PM49BpDyqoTnYx7EAzmAc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fJEcXgon;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786893407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=paElrpHQlE8g3P6OtIHexotZleQW+QuOt1CzJnnLFjc=;
	b=cPfXivFPZhZntWjnJJsyuhmYqwW0sH2vWvSCGu3mQRzwqoBCYvrgjhcN8/sViZv7e9z+fD
	QTKx9drj5Kcqe1rsEdZIaYrGOOKF8/mlxiLWPco7ZWVeFQ/8O49rkSyNF5Lcm7dj4Myge6
	nldEvq+pzisit+gnadUbq5x8Gu+FX30=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10e86e52so479841cf.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 08:16:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786893406; cv=none;
        d=google.com; s=arc-20260327;
        b=qXxYAZctEpCn8MqFPlopmKhtmCzqLPwcwAkTccTtuAF1Ap81XjBQPDHQp5ea8FV4yS
         ymbqd7DHaT36F9frV+IbCP0OXVyp7gXJpHfD1F7hV5s96YYbCIjhR2Xyz/Nqn3Jg6Y/P
         4/1fxjGAcfAfTFxPQJE7dYM4shZgVul+kWyRQi3E8zt9XsMN0F+EzmqkOzQF+PoSL3SU
         N+Q8tK5k+H51MAI/uVTPS305ifZUSMgAxTeRkbP/A175VwAHKxtCXXukabdua5zIqZzE
         y4kXjVgEVSg3GIr2OhlTkXV44R/y9GBmWDa67HeXn/zBZZ8TOYAr7+bdVxLF86u0ZMc0
         Ad1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=paElrpHQlE8g3P6OtIHexotZleQW+QuOt1CzJnnLFjc=;
        fh=+/gcuS5EqdeKydu+OMgR0GlB1QYh1ohNoveXDMb4NtE=;
        b=S6oSRzkDVJ+vX5T+sRBbga9f6JjBAHTavHso0LiBbS29a8ryhh9wm73DYO8yqVBXjN
         MrPfjFPZG2AD0pWzmsS0hIj7nBc69RXDTESk7U5GEjZMnGmsN6nRWK3W9IGzaALtgXT+
         I4h6w5GVv10BZ/jM7M3TgZIeLnIQaf7JaaTgZlQk4o+KGK5xJyAj7DnOEkHJmNiT9HcH
         n8+6Q5weZdJDuWPyOENO8h9RWFfgnruuf5hLBPyAuyCvkav4w3MWhhM/kS4ZG1bnKrCW
         i6Cww+5fIixbHhJmJDw66oYtR63xuKBuIjOsqHH6wLNHKIqAS3nAGT0aD//E05kiYE6Q
         vllA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786893406; x=1787498206; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=paElrpHQlE8g3P6OtIHexotZleQW+QuOt1CzJnnLFjc=;
        b=fJEcXgonkLB5iL4fTHVSKSJyalN9sqnv0Lc9d5hHXVlEI/YBUkZ/umauu7yEWwa8la
         1NcOsWfaDcPAQ8EoA98tkUD1uL85BJ9bkqEh/ZrjaiGmXsO3VJ0rPI9x7rsVmXxVRoC5
         RDJTnabylhgpyGgeJ3wYNfwDh1iM2hexpV//zsAzURkUqSDk5PJLR2176clDL9S3ReZY
         6EH/2ncXdQlqjP63yEfFZdCClEvzmjoH/MZGoeftuID0F8AO/WabKqCWl9/UYhfspwZd
         JGI9xwCwUuMDaPhJ1/iseVXZWPBvdHXk35c/WQZisYj2al2aCaFr2HKLCKzeSx1FJ/L2
         6fpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786893406; x=1787498206;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=paElrpHQlE8g3P6OtIHexotZleQW+QuOt1CzJnnLFjc=;
        b=C1x36VCDZCEfaqkvCuwYE7GbZ8BNO2doQczuYp150g7d+3Nc6jCtfKhKuuWRVjmLz7
         u9JTex5EcjrsOglzxOPJlMoGz9I1U7oU0ONTjL6lAxF6uumrauY00XkdPnaA2T1mrAzx
         CyUH4XOgOKy8Kk9yk0xDlrK/mhFQs3UR7H/lQOzLKIK9kZ0SE0ZaX97RcBiMQQv1TlJn
         V1qRCzJhekBOyWqaGQYKnkanEtYQT8pX3Fb692J3Y0k/6RdJL/xGmzW+0IHslRXRu/oE
         Ehc4ddjuWiFXhY5cwlPSvaAVXWN69I0JIJUvLFiQ20nDLrVfCEGeLeUnz01vxFjl1TXZ
         89Lg==
X-Forwarded-Encrypted: i=1; AHgh+RpKJwjcw16eNmGf+BHXbjhDCGXbkKWa9vlvOXyt+Hz1HzgMjAYOLTStGzwrp8Z/kGHdCuBRl56p7g==@kvack.org
X-Gm-Message-State: AOJu0YxqYCyy90DN1Gx3NoDeTPGJ0MM0fGaql+QREPKHTjZw7qGlm0dn
	rtG7CkQqCSalxdAMQmL/+yM9RghoGq+3PLeM0+Vpr8turzGEeCKMkNSFpbVGp+mqHGfIhjpxEmp
	FwT6pbwsHWJeKMrFniSDYjNnwMLIu5yVxcnuWLDn8
X-Gm-Gg: AR+sD10+H/CspRXTPGkNlKfr0CcmiL+k4aC0VoDW1YVXdnS2zFM8t3nKT8r65x9VH+t
	qaiz+zWd6IIJdyz29Nano0/lMhc1G+fgE+aW8XYpnv820uTlwmYWK8DKHfHnmANHuh4WMIEcZXP
	X6JJIv31XQ4x9GNjBnssOVgLAFI8rOu+ryppmKXOXiIh/tBFW+M6o2rIhjsZsoS0SyCkBZnhlI7
	Iy4GGo/1vFPxSEWgfUGfGlG0j3HLOkiFBK1K5+susAU24++y5UseoDgpr0YpFspvVFL5pLP0x/p
	oV6ZTftUO0toOuQxKLeBsaCoR7+XD6vVb1k5+jTKDfQ=
X-Received: by 2002:a05:622a:291:b0:517:6010:7c71 with SMTP id
 d75a77b69052e-52db07b97ffmr678631cf.4.1786893405340; Sun, 16 Aug 2026
 08:16:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260812054105.102637-1-hao.ge@linux.dev> <20260812054105.102637-3-hao.ge@linux.dev>
 <CAJuCfpFvdNFdsKdK2CdF2fNp8gbNgFpoeAiaqp70mpbNGCvk3g@mail.gmail.com> <143a37b5-93a2-4038-8be9-29e13263e743@suse.com>
In-Reply-To: <143a37b5-93a2-4038-8be9-29e13263e743@suse.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 16 Aug 2026 08:16:33 -0700
X-Gm-Features: AcwNN1X1kkHyn9OSKgwwnu-af8eWVC7nq_5zQzZp6a8dGSxkkhZX0C7kT05sApM
Message-ID: <CAJuCfpF1pWqhc+P9zPg8FT_CcdQxRuEpJ2DtYja1BeMXhW7-8Q@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
To: Petr Pavlu <petr.pavlu@suse.com>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 29A2D1C0008
X-Rspam-User: 
X-Stat-Signature: briek5ymbetijqwsn1atscgyo15d4ydd
X-Rspamd-Server: rspam06
X-HE-Tag: 1786893407-861969
X-HE-Meta: U2FsdGVkX1/NZ2N/ROcaKa2u92KbXtvvuI0Jny0zOxCwzbTTSjiIb0IyJUVMbTdHLlwNVwsWo6b03cCncYMH4L5ro/QA2xiqKWSTgZcQAKb6uZKN4WXeArONb8vdv4e/Zlx3vdxGN8ozPRyV8CDDYm2m1Yi/0x1yve7fqf1xIeXmG/Ih593zk7YEpRA3LNaZw2U6IN4T6EzOUqtPGZmFNLijASXSHRT74scpJcgFilyTUQU/xffRH5Pt7liG3hTdpId7DELEEeTZmCL/n9wyX5JOUQpbT9eytkmoWDvZ70PIdFXgv/dnXqADMvFTTAIntua7GQXHes/LzG5vBEDm8VJ0dV4mmkvh1+unzq6uJ33PrfuRbZaNsaPPskGnu3MA3Qr08pt4/frWvnS5730FIfle/EWaWxXGn31MXFI6bZ/UZGsTNsEjrwn/c/pt+og/eCgoQxbceFENWHputeHgeZheYsSLHi0e2eR8+iOXFdeyUqAMeDQJLTEHzPBUPS+bgYCZ4m/5hbMKfeBBA07H7PgwUQ0RxGMXuoxLc39xwSxTJ/HNKuPKRE6T4a0lvZqiH8TZQGbxy86ug9JvzixBuUUfPxuEgf/u/t2tUwgRCjJc5U1aPigML4d790gHjnQX1ysZKPDSp6NbDKpqDdKELOYzw+5/8AK8stuk/sf3TNoNnN9DngPa+Qg6BANXgH5z0RBXQqF4mNI07978V1bUhhFNvLkte2q2NcsaavQLKbMwnpOmgAWE2QigfEgYRhvg6u5PETnidWcVi1gQyNQmTFdMewmEkm94xQhBsN8C7Ubp7yJ4G5oqMW0xnyEtw3jDgn2JrVIO7VPkLwhSGZ3XAcyYbXcDOKcsbRdBfAZuICrNVSv/NLI+cSUlp4ZnEqZMHOFSG0N+ipNFTgKIwXu0kH41trugTgkdWtHjqLrydpJDOyfwg7Dh7cE2vLndNy1nr2VPS4ODVR+wrm51Xh/
 tBwzCMR4
 wrG527q3FJGMcOpLe2D8NoC71JvPiKhPtFbL+XjPlg1WcQjEd6VcsZLWaiLHJsBwg6mrlLoPV/I9slsQfSfUIBAuSWj1pUQJjzoBHcRTx+ai3dPeRPppBACzHw4c+n8e/8CXVdsGkqK3WzFSEXvi9vmp8CIi2SkhQlpPGPN1RFt4Xv/lJ68whKP1WMrGfTEU8M6l8XwtOenRhjhkwIMUfNWXKlqgHXraQrAn4kd/MYjrntzT5tmBSgICVceb8HDmbHVNOp+MSYwsazVQ66axzOCrg0YHNV6q2Nz9rsCcp8kWf8vxCjr2kTE25gUoYVwCXpgys2qqx5HByB7B/gq5IHBEb0jzMDXgdMTxc5crJ8PDTEYjKNs0pTo3Ai9n/96t2YDJ+PGArweGTOtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 3:45=E2=80=AFAM Petr Pavlu <petr.pavlu@suse.com> wr=
ote:
>
> On 8/12/26 7:41 AM, Hao Ge wrote:
> > In reserve_module_tags(), the tag overflow check is gated on
> > mem_alloc_profiling_enabled():
> >
> >     if (mem_alloc_profiling_enabled() && !tags_addressable())
> >
> > If profiling is toggled off at runtime and a module is loaded whose
> > tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> > skipped. vm_module_tags_populate() still maps memory for the tags and
> > the module loads successfully, but the total tag count now exceeds what
> > NR_UNUSED_PAGEFLAG_BITS can address.
> >
> > Once profiling is re-enabled, ref_to_idx() computes each tag's index
> > as its position in the alloc_tag array. update_page_tag_ref() masks
> > it to alloc_tag_ref_mask before storing in page->flags. Indices
> > beyond the mask are truncated and idx_to_ref() resolves them to wrong
> > tags.
> >
> > This silently corrupts /proc/allocinfo: allocated pages get attributed
> > to the wrong call sites, so the statistics it reports are wrong.
> >
> > mem_alloc_profiling_enabled() and mem_profiling_compressed are
> > independent. Once compressed mode is established at boot, it stays
> > active regardless of runtime toggles of mem_profiling.
> >
> > Remove the mem_alloc_profiling_enabled() guard. On overflow, shut down
> > profiling, release the reservation, and return -EAGAIN so that
> > layout_and_allocate() retries with profiling disabled: codetag sections
> > are then placed as regular module data and the module loads without
> > profiling rather than being rejected entirely.
>
> When the described overflow occurs, why should codetag sections be
> placed as regular module data? Will the codetag support use them in any
> way, or do they simply waste space? Is the issue that alloc_hooks()
> creates relocations pointing into .codetag.alloc_tags?

Correct, alloc_hooks() will have references into .codetag.alloc_tags.
With mem_profiling_support=3Dfalse they should technically never be used
but I don't think it's a good idea to skip .codetag.alloc_tags section
allocation and to leave dangling pointers. Also the case described
here is an outlier, so optimizing it would not yield much benefit.

>
> >
> > Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compre=
ssion")
> > Cc: stable@vger.kernel.org
> > Suggested-by: Suren Baghdasaryan <surenb@google.com>
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  kernel/module/main.c | 25 +++++++++++++++++++++++--
> >  mm/alloc_tag.c       |  8 +++++---
> >  2 files changed, 28 insertions(+), 5 deletions(-)
> >
> > diff --git a/kernel/module/main.c b/kernel/module/main.c
> > index 46dd8d25a605..ed26f167be84 100644
> > --- a/kernel/module/main.c
> > +++ b/kernel/module/main.c
> > @@ -2944,6 +2944,7 @@ static struct module *layout_and_allocate(struct =
load_info *info, int flags)
> >  {
> >       struct module *mod;
> >       int err;
> > +     unsigned long frob_size[MOD_MEM_NUM_TYPES];
>
> frob_size is used to store values of module_memory::size, which has type
> `unsigned int`. The types should match.
>
> >
> >       /* Allow arches to frob section contents and sizes.  */
> >       err =3D module_frob_arch_sections(info->hdr, info->sechdrs,
> > @@ -2966,18 +2967,38 @@ static struct module *layout_and_allocate(struc=
t load_info *info, int flags)
> >        */
> >       module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstri=
ngs);
> >
> > +     /*
> > +      * Save the sizes reserved by module_frob_arch_sections() so they=
 can
> > +      * be restored if we retry below.
> > +      */
> > +     for_each_mod_mem_type(type)
> > +             frob_size[type] =3D info->mod->mem[type].size;
> > +
> >       /*
> >        * Determine total sizes, and put offsets in sh_entsize.  For now
> >        * this is done generically; there doesn't appear to be any
> >        * special cases for the architectures.
> >        */
> > +retry:
> >       layout_sections(info->mod, info);
> >       layout_symtab(info->mod, info);
> >
> >       /* Allocate and move to the final place */
> >       err =3D move_module(info->mod, info);
> > -     if (err)
> > -             return ERR_PTR(err);
> > +     if (err) {
> > +             if (err !=3D -EAGAIN)
> > +                     return ERR_PTR(err);
>
> The move_module() logic is non-trivial. -EAGAIN could be returned by
> other code, now or in the future.

That's a good point.

>
> > +             /*
> > +              * -EAGAIN means profiling was disabled but the module
> > +              * can still load without it. Reset state and retry.
> > +              */
> > +             rewrite_section_headers(info, flags);
> > +             for_each_mod_mem_type(type)
> > +                     info->mod->mem[type].size =3D frob_size[type];
> > +             info->sechdrs[info->index.sym].sh_flags &=3D ~(unsigned l=
ong)SHF_ALLOC;
> > +             info->sechdrs[info->index.str].sh_flags &=3D ~(unsigned l=
ong)SHF_ALLOC;
>
> Why is it necessary to reset SHF_ALLOC for .symtab and .strtab here?

I believe layout_symtab() sets that bit and to retry we need to reset
it. But I might be wrong here.

>
> > +             goto retry;
> > +     }
> >
> >       /* Module has been copied to its final place now: return it. */
> >       mod =3D (void *)info->sechdrs[info->index.mod].sh_addr;
>
> I'm not sure this is the best approach. It's complex logic for what
> appears to be an edge case related to a debugging facility. It will have
> the usual problem of error paths not getting enough testing and breaking
> subtly over time.
>
> An alternative could be to reset SHF_ALLOC on the codetag section to
> remove it from further processing and have relocations that point to
> this section resolve to something else. It seems that alloc_hooks_tag()
> could tolerate this, since it only needs to reference the associated
> alloc_tag when mem_alloc_profiling_enabled() is true and that gets
> disabled by reserve_module_tags() on the overflow.

Hmm, yeah if we redirect the references into .codetag.alloc_tags, that
would be much better.

>
> It is also not an ideal approach, but I feel it could be less intrusive
> to the module loader. I can put together a prototype if needed.

If your approach does not cause module loading to fail when we disable
profiling, then that sounds like a good idea. If it's not too much
trouble, could you please send an RFC?

>
> --
> Thanks,
> Petr

