Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10FCDC5AD5A
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 05:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9F36B03B2; Sat, 15 Aug 2026 01:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2EF6B078D; Sat, 15 Aug 2026 01:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1E86B078E; Sat, 15 Aug 2026 01:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9163D6B03B2
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:58:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 854B6140307
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:58:29 +0000 (UTC)
X-FDA: 85102449138.27.92D4A85
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8D1B0C0004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 05:58:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Boc3w1dr;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786773507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSNHZ1rhCWbjDqMjYrewNRXpE7DLnZyqNYRIuv59LLs=;
	b=C/wJ2VBVC00uEsXWk5u3823qWgNMnKWoR3KmTC7efeYlK1zfx6d7CW1kpjlSNg4cxanUU/
	om15nhTbnmMs5AO8MEobUo87oDGGUuf2z3vs6F/QjVh9BYg22ex/W3SNz5yhC7bhhdBif8
	qR/N+fdc3JuQJJn9fgg9PJS7LdzUJb8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786773507;
	b=vapF9ESCXat4eDJI9AtXuuCAwWv2x2ZVwRkEOBr3e5CTwuYskx6WM2vBZzhr/06it3dXNX
	GIjTmeqx6iTZlhHwNnX0NgJ/UyrLsXNKl3VWn+T9wZbhVHh5axkMSyYhasg20vUsopJiPN
	YR/P3+CVWn2CAwTx9ghclOQigIGEs98=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Boc3w1dr;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d3b440b97aso168185ad.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 22:58:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786773506; cv=none;
        d=google.com; s=arc-20260327;
        b=B1gAWPVUPFTX3b/8IXonZ92h6Q/sExQavk89CaDADWpkGy7G6aJtoCpHUeMasHjLuh
         M2O4vtB8OL6ouWIs9P859x7+s5zn4FhVRN6reRi7cpHv+hPqWla4fpJ4COdPTk6aPIFB
         JswIn6Cfb/oCDsaCBgAd5uX+cP36WaBofAQtM2lIhlngPo9hY31kYjT2j2Mmxlmilh+e
         HyZZ7xaNrv8WuRBmuYWRngt2mpCxhc0D+WtLzASwCTMzF3+uuzZj/saxFAHvMsBI+Bgc
         zGbMT7rroOjedoLgrYX3y2t/gecwFG1FYLBJr9WB8/G7nZkY4eDcJ58QNfkVNyNdoYKQ
         zDUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GSNHZ1rhCWbjDqMjYrewNRXpE7DLnZyqNYRIuv59LLs=;
        fh=Q7ksrw61WsOjC7YhNpEEFDMMd3hzeK/2apvAU3cYqr4=;
        b=C+h3J8CnaiTMXlHQouDWH27PtlXNF0+HEDVcP0tCclbSgO6Ixog1MTyjzbY6xseRtl
         /mGzMSTw2+S7NLWPFfJY0SOiptNgQcQb+byCxdz0w4GlYoKs1KWULEkfikWPisr/mQZC
         P580f37tN2eb8Lpmaamfc4MFfNL4bJKwfmHu5a4HlPX8miNEn6JciSZfGxeHD0U9Dak3
         BFuXs4RZm2k+Qtab1Ul4RMNfzPwwOvT27IgruC+wjXXyz3q5KLf7uHUHDfyVlA6aU8NE
         KjI9hXKmQdgjfmC+edGczgNCbqRu4Pie8JQgQhu4tpsCBh9Y37P7HLzFJjZpuh0Hdg81
         Aonw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786773506; x=1787378306; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GSNHZ1rhCWbjDqMjYrewNRXpE7DLnZyqNYRIuv59LLs=;
        b=Boc3w1drB9GYiESOcjj8RylBoUVCDkbgZs1kIoBF2E653D3vpLBijq0sYPfHcb3s/6
         1igTDRuD/cOnUAiQsOA4J/L6VB7pF4X3btL7tUjTKSbuGm6QLvYpJforK9/4DbWuJ4nj
         rDOlsjpE6V7Kc7dIZ2IWID51e2lSRKhcpDhALsuEFcA+ld8Wa06YrTf4IdMLwES5Bz4J
         BeOmQQs9yprOGLQaChIg6YxXsaTBkwhcFMsgbN+TKyWxxmvA5OpBMB84PcU1CQKX9+8I
         80JziSYm5mm5m6K+d2CwIa9jQMhnIQO3KGAEn9SiIAQ9q22eioftqMTUWDXHeaX2epaA
         79RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786773506; x=1787378306;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GSNHZ1rhCWbjDqMjYrewNRXpE7DLnZyqNYRIuv59LLs=;
        b=KI/OEF2wHja4qPcMRSa/v3oAe0SFfkUjm8i44YMAKF8gA3XDkKucG1YDwM0TmI2x6s
         n0wkbjJ+ayxY83meZGyqiQ1bx/TlsY6QGeyO+wBd3Z8jwMKfR61LJ47mFB9vaR5vU/+b
         ddU8tYKVu7Snfenp1xFmATP0Wwco0adK7aNjXzQdmiV3ERNaqejuC47uwdUljyNIf5IR
         bHR2Ru3NY43lLQgkVMJUFLfUauFPKCuTzON6GymJBHLmghXQnc40J9zhoGIS+g7YUVZj
         n5UCC4ETdiRX86B8arQBN8pALVJvmcs37oT3bo3R6yWRHEQYI7Rbz5EsvkOM347TcQG1
         RZTw==
X-Forwarded-Encrypted: i=1; AHgh+RqVyU2M9m26avY6TrGCLR0zGQ6Oq7cCIvWiFS32PteQj8oj573uv9R00wnrhz+A0VHUK9bLK4dQgA==@kvack.org
X-Gm-Message-State: AOJu0Yz+RW750Z3Wv32a4ztlUWM/55jQyr0XXzYLb8BzpHnRfrQD70bn
	wFHaRzTEHlMQZFYvp41nBUqqdfKOxl1FbqpBE4PMEeZbJLRCDldarh1Ex9WaGmQP04r2ccaBt+p
	qKcemyzJhwSSRT0xxn5kd1bPSv3+dC0izeN1f8hWD
X-Gm-Gg: AR+sD12Bl+PBsA9tZZ3CQJr1fAEEm2XZFla+ysHiJ18bVmeV9GhrGYT59QArCx0ywDT
	qE2tqiHqRVzLOGCpwh0r1xJ6E2xIwxLSJ72VuCUMeFy9gOdGIi0HRZL8nTmxWghEztdLSOGoJ61
	LKvPVtJTU3fO94iy85QDyi0FHJWMzAnXg7nqiCs0fl6NjRSFGqlWwPDrxBbNFyW1dJp2x6oE0ns
	ud9+ILoDpqE0cqEeInpgimCwnwquFv4uuLmz2HGph/biPDyGg/KBqq4AdBxOFUZu4baEB07uQPX
	X9qQwXDmGW0Wy/McWC83zQE/yNnKZZP2Xv9vFDVtHrFWOXa9TIgnb2g=
X-Received: by 2002:a17:903:3246:b0:2ca:bf8e:360b with SMTP id
 d9443c01a7336-2d3b49010f5mr13153455ad.9.1786773505668; Fri, 14 Aug 2026
 22:58:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260812054105.102637-1-hao.ge@linux.dev> <20260812054105.102637-3-hao.ge@linux.dev>
In-Reply-To: <20260812054105.102637-3-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 14 Aug 2026 22:58:14 -0700
X-Gm-Features: AcwNN1Vv8e8AYIsvCRMSKDbhePjWJ2ljICkt_7vSL2FAbtl9G2kesUL9ji3umuM
Message-ID: <CAJuCfpFvdNFdsKdK2CdF2fNp8gbNgFpoeAiaqp70mpbNGCvk3g@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] alloc_tag: fix undetected compressed tag overflow
 when profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: p1ppjhkr8wyssdxsmkn4tqkhb5xgrmn6
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8D1B0C0004
X-HE-Tag: 1786773507-22392
X-HE-Meta: U2FsdGVkX18CIK4c76C8568O694Vxx/CiduQ8bWXtNteqYtPKqaq+RY/B9nbEPMYICJOFL6uVe6tDxU6pGOofWqkXafZnXDq2tOmGi8peNwzZwSfFVYZ/pWYUW+hPd3HhbiqoWl0ihvY+CKkm3VPmwSCGy/BnXC0eS2AkQENNTCoStKWJx9p45WBxhPXpo3ikZkefGG0ZLFAbaaTNrSUCkbQ3+OyCn1WGi2onWyKVp2DxwrEiAvzER14kKBY8xxm2eoT1HRy9fyyuy9SJicm5fxZKhTBxoRXtr8MsAVE9QY/ywuoTsp1Xz52vaMG9spPxxsgmv84BqAWgHDIWTOph2i4cQG5hQPRn25R5RRl1FkloWyh46XybNGL++FC1e8su+uJYC1NZMLGvcTXvbJ/oBF0hNbupJjOZsiQuG58EUkQ5hdH1QYf9ly3MMZeIyWJKp55za0VBQuf/7aWtcycqkTkRy4Hdxnrz2ulxpk8krZD8tD5MPJvmQkADZDtMxQgIMpiIJ3Q/C5EbozU0bszxBcT16CSb2hGppcyHywRTX9wLaO8df6LYdRXxa5WNcY5oC/FIecUdyWX+NWowuOyYwhg7FQDu/sYy3wOgsK4L3JMWHzC2GfYmdLJySZ1R3IrT0xsRyaIkpO0ES/kgXezHxnlGhFZidZHwkDmj01Q9GJFAZ/3iTfLdEsIFGp1o0SSk1hQVeHnUtp03wQgW1osczSHWfliSEb/o/er3VoDuTgqF+vs92hlc3kCVtaH0M2OAHdIfQPZrAIuqdmwc1GtYfrLKcqeiIrET4TK2cat44HoJ5L8hwv1qVXjtidUVUf+m437ilMRUUaP4AnjZb6ePURqzuXUMY3o765VaOvnKkgkpnaaWcFOkTb8Ps2Ba71ohQ3miD2thaIoOyDLSr1pPDOQYjmQe+i/lqQ1X8GNZvkV6o1INkO7xg7mVrLydv0/sCJEdT1tGTJx3jgyAu0
 epqWr6oj
 87AxJn+26sZGb9L9gA/D0xL2hf/Sm3wJwjbZtlSEWlwSEiiTV49hoO/NUHQRX0pPny/9L1fbCoJt4Elm+r4m8t1PZlGZ73yPwLwM1apQv+nhxphTIkVu3oFqgAC1jKMbVEupNutaLcoFO+yxgqiypCdUjnv3QvyDdd8V/rwuuEo5Fwvu9bVDkUsrs3bMVMYMzTXOGiQxiwznpnw8XL8HtToF51+3IdgmUvJ2nx0LZNTHQzavAVk4SZlgAltjSHNOrviW/3ggj3aoA+xVyXSvVFp+8e1sz398zOTEFN7W6Zi2pXahSsUVpO87yjWFvw/StYmYs4ygUFbImunM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 10:41=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> In reserve_module_tags(), the tag overflow check is gated on
> mem_alloc_profiling_enabled():
>
>     if (mem_alloc_profiling_enabled() && !tags_addressable())
>
> If profiling is toggled off at runtime and a module is loaded whose
> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
> skipped. vm_module_tags_populate() still maps memory for the tags and
> the module loads successfully, but the total tag count now exceeds what
> NR_UNUSED_PAGEFLAG_BITS can address.
>
> Once profiling is re-enabled, ref_to_idx() computes each tag's index
> as its position in the alloc_tag array. update_page_tag_ref() masks
> it to alloc_tag_ref_mask before storing in page->flags. Indices
> beyond the mask are truncated and idx_to_ref() resolves them to wrong
> tags.
>
> This silently corrupts /proc/allocinfo: allocated pages get attributed
> to the wrong call sites, so the statistics it reports are wrong.
>
> mem_alloc_profiling_enabled() and mem_profiling_compressed are
> independent. Once compressed mode is established at boot, it stays
> active regardless of runtime toggles of mem_profiling.
>
> Remove the mem_alloc_profiling_enabled() guard. On overflow, shut down
> profiling, release the reservation, and return -EAGAIN so that
> layout_and_allocate() retries with profiling disabled: codetag sections
> are then placed as regular module data and the module loads without
> profiling rather than being rejected entirely.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Suggested-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

I'm looking at your fixes for pre-existing issues reported by Sashiko
but this patch looks correct to me.

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  kernel/module/main.c | 25 +++++++++++++++++++++++--
>  mm/alloc_tag.c       |  8 +++++---
>  2 files changed, 28 insertions(+), 5 deletions(-)
>
> diff --git a/kernel/module/main.c b/kernel/module/main.c
> index 46dd8d25a605..ed26f167be84 100644
> --- a/kernel/module/main.c
> +++ b/kernel/module/main.c
> @@ -2944,6 +2944,7 @@ static struct module *layout_and_allocate(struct lo=
ad_info *info, int flags)
>  {
>         struct module *mod;
>         int err;
> +       unsigned long frob_size[MOD_MEM_NUM_TYPES];
>
>         /* Allow arches to frob section contents and sizes.  */
>         err =3D module_frob_arch_sections(info->hdr, info->sechdrs,
> @@ -2966,18 +2967,38 @@ static struct module *layout_and_allocate(struct =
load_info *info, int flags)
>          */
>         module_mark_ro_after_init(info->hdr, info->sechdrs, info->secstri=
ngs);
>
> +       /*
> +        * Save the sizes reserved by module_frob_arch_sections() so they=
 can
> +        * be restored if we retry below.
> +        */
> +       for_each_mod_mem_type(type)
> +               frob_size[type] =3D info->mod->mem[type].size;
> +
>         /*
>          * Determine total sizes, and put offsets in sh_entsize.  For now
>          * this is done generically; there doesn't appear to be any
>          * special cases for the architectures.
>          */
> +retry:
>         layout_sections(info->mod, info);
>         layout_symtab(info->mod, info);
>
>         /* Allocate and move to the final place */
>         err =3D move_module(info->mod, info);
> -       if (err)
> -               return ERR_PTR(err);
> +       if (err) {
> +               if (err !=3D -EAGAIN)
> +                       return ERR_PTR(err);
> +               /*
> +                * -EAGAIN means profiling was disabled but the module
> +                * can still load without it. Reset state and retry.
> +                */
> +               rewrite_section_headers(info, flags);
> +               for_each_mod_mem_type(type)
> +                       info->mod->mem[type].size =3D frob_size[type];
> +               info->sechdrs[info->index.sym].sh_flags &=3D ~(unsigned l=
ong)SHF_ALLOC;
> +               info->sechdrs[info->index.str].sh_flags &=3D ~(unsigned l=
ong)SHF_ALLOC;
> +               goto retry;
> +       }
>
>         /* Module has been copied to its final place now: return it. */
>         mod =3D (void *)info->sechdrs[info->index.mod].sh_addr;
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index af44f90379f2..0a7b657fe2de 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -950,10 +950,12 @@ static void *reserve_module_tags(struct module *mod=
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
> +                       return ERR_PTR(-EAGAIN);
>                 }
>
>                 grow_res =3D vm_module_tags_populate();
> --
> 2.25.1
>

