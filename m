Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B287DC5CFC1
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 06:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910856B033A; Sat, 15 Aug 2026 02:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C16D6B033D; Sat, 15 Aug 2026 02:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFE86B033F; Sat, 15 Aug 2026 02:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 386796B033A
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 02:15:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFAE81A0312
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:15:45 +0000 (UTC)
X-FDA: 85102492650.03.CBFA911
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id C1D2C180003
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 06:15:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r2HRjIJi;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786774543;
	b=EB1DWxO/gSuBrsv6QfzSpHri18/l9PQItTVjPeWdAkSnZdmwWZZm6Xq4iYDEx9MK4SzCJd
	fBS6ryn6vqkqoFyeUrkWAHxr5Kmm+YObNjypCnsXhBI2gXRaQeQqFICjVoYP+lsk7No6aa
	DChJSlPOL+EACu2biZ3g0WSs0a2TKUU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=r2HRjIJi;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786774543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CeWrvay8OBGyEYR6j0JzJMygxdhU+kGusNMdV7+ciFk=;
	b=njnoo2QfgmVLazc1ju22jZPrNYOZd0ewZqB4HtEOqbu4ntb1WUJo/EYyNfW7tBfJViuqBO
	LzutJPA+tUP2E7viCpZ/mENnkCE7MAhJ8yunrOgDqpMgJSrjJ06Vu3rM4F9ehdEQdOZfb9
	R1JpR4NzMImcxJLbeZ5MM8gkquW3tGE=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c10e86e52so387051cf.1
        for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:15:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786774543; cv=none;
        d=google.com; s=arc-20260327;
        b=qwdE9IMZzxcwbNvNJdc3Q8/4AkIslS4z89a0IV42/qJjqpJbpXn2v9F1n+bFhYA5Ek
         6hR1XhYXk/s2g3InxUiaAoDrJGdoNtxHvETL49Yk2pMoG43CeqjW6JtRSHWJMu3yKFpa
         bnxUubKMXHf0PLqVrQGaqkZfi3f5cZcocLhdD/qZEjwrQBXWxZH2yojk9Q82jF4ybAGR
         UjyTp81d86MLcU19RWHyokAImZxbKYSlw+JIfK1CWE2W3s8Bj2jkZ4q0OPiTSKue6K3+
         tYoRRElNwLZvACH0cCKPlBkJmSKG96Wn46aExMBIGI+ONweeLsY6cfRdF3BvD2eqCIB9
         dvLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CeWrvay8OBGyEYR6j0JzJMygxdhU+kGusNMdV7+ciFk=;
        fh=F4FSHRSMr2Zk4Ddz1BqtkniFNvyjlEm/ELyDnPqGcZw=;
        b=Q5+kfbK+4QWuztYvonW60Uutix8FeOP16UBRAhkbHGEs3u6gB2jpIguRgFrbPG8RCa
         31WZXS0bh4c0mR7zPa2eqAAG0/dKLUoSsl2uUPmqOHfomvXtr5LPB5sMi1plRp4Wh1pF
         sw0NzG/f6D0lbcDKdEQSYdA28lbU23gkjboNEcV4TZv4ib2qmTBiFQ06ca4/5Thl1RUh
         HxK4KSxG5pQ8hxcvXlCNoxPuYxZNmCaSRs7G2UpdqOUZ9qQ3ouEj3nElucZ8a/9sSylU
         uV/YOTUvPns9qAE9GtiRLS8yy3agq4nEgrslqfvE20vI+hdBaimamJAQ8bDY3bhNXxMs
         berw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786774543; x=1787379343; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CeWrvay8OBGyEYR6j0JzJMygxdhU+kGusNMdV7+ciFk=;
        b=r2HRjIJi0XqqGmSJHGdyX5JzydreojmOmUqv/m1SllLEdnmwN53NEF/40ZjTf7QSX0
         uGgTj2o/0/twLRke6blOhzohq9bugSPKzq2PPfuHJDSXDCHgKPW9sv/fMUaYmOpNhKGq
         UkwHrtPZYExdJskd8FrXpABA+Gdq+hfsfoNC4q4D58WKVRm4iM1TF0sTkYHmh8eNLnaB
         O26l2Unt1E2l+D3NDs+/680W6EsjVAeKmfAs/Jziz/A6xoqMlIK3nVWZilUmYldbw98u
         rAAHPRWYAMC0kBox0+MvrCdcwI2nyu8jZ66xGFxyaqbLBmhSmpt79IdbZXLqO68R68bN
         Zp+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786774543; x=1787379343;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CeWrvay8OBGyEYR6j0JzJMygxdhU+kGusNMdV7+ciFk=;
        b=RGHl2lzMvJlfdpmCoYcnVod6BAH6JvFHDirRl1bRO2C0JeezPhPEP2ozNCoMFWJRBc
         byz97tLjR9d3ztuZsh/NBV7qPZQcIlgdJjPJRZOd3txSojMBPcSf6GO0+Ogvpg0FEynV
         5uGw7g231stJbEbbRHJNUP8WkGSbfW9ZiaoHmrDZiIs15m6A073Xffiio6dt3XlIXnke
         avcrdz3As+HCyPwV404FF9wF+s/c1dDz6J4/29CvQXDeh1aeuGNDokZwXTzxWWYQY5Uw
         kPNh2N8y7T5B8FAxGng+28yHaBFiyB9KHJMrMDDmKhFclC6sAdFXa6OVgHi/A2IcF3NW
         PPsQ==
X-Forwarded-Encrypted: i=1; AHgh+Rosy0A1CClVjP/rNXYS9kgeIvXRxqv9bfT1SXfRZtCcK1FcPzut6uSsLtE3LmInDTo1DLtqdV/UoA==@kvack.org
X-Gm-Message-State: AOJu0YyQB4BoBIrfoymC4MuAFGGkVKZOkQ1ixdglr97v55ijHQWMQ7sD
	G/2gCqy1YmiKMVyMNrE8D69JbmKAsV7BUTaHYE3jkX+uNnNVfiOccJxsXUfy9nQjbe+TvQfQ6mR
	CffIO94OPqhRyCCDDUZyLtQrWad4BPd5ltOWVm1W7
X-Gm-Gg: AR+sD124niqeWBnRFTcCwTKf1P0eDHUvWtDZ1mti2YqdW0uP5IYSqicTtVMBLPFWrtr
	iH0iAfp4ZXZ+wNNjf7jNKP0h0ziYJDiHlu8mZV2+FL9oyYMZa+aQqzjOI2xP6QL4aHchJE89JPe
	Cx5UxnaOMYz+cbedAoAuGGrh0j2VFsW3b8DoNLn11jnZzRyT9llFkJZrIvqvqHJQoCopH1C3zlF
	u2ur/3gQ6YZf3TBeIsq3CIn14xdxrv+ahJHL9VkAXkH/O1W31InV2qdAeJP5lVnh2VvwwThw6iV
	eBFuR3p5cGxHKYmQ3GloKxTFLssWMYpFkZZTWw6Is5Ixjg+Ktkdbt47WiTY=
X-Received: by 2002:a05:622a:4c0f:b0:51c:ae6:a57 with SMTP id
 d75a77b69052e-52d862f6fe8mr30547411cf.11.1786774542180; Fri, 14 Aug 2026
 23:15:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260813093421.135230-1-hao.ge@linux.dev> <20260813093421.135230-2-hao.ge@linux.dev>
In-Reply-To: <20260813093421.135230-2-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 14 Aug 2026 23:15:31 -0700
X-Gm-Features: AcwNN1VOSUdc7S9dQw7NoH9eXwXWzpOpXmtX7H1BYFB9QOUwq4hMXPOjuGhLgWM
Message-ID: <CAJuCfpHAzhCC1Sx3uJr7kbhBzc7RFqwLhMyjo04hqZz=HBJH8Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] alloc_tag: skip percpu counter allocation when
 profiling is disabled
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	Petr Pavlu <petr.pavlu@suse.com>, Daniel Gomez <da.gomez@kernel.org>, 
	Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>, 
	linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C1D2C180003
X-Stat-Signature: kze9shpb3fyztguwffsh659i73ioa65g
X-HE-Tag: 1786774543-905183
X-HE-Meta: U2FsdGVkX19P0VD0Zo4F/XwHZcdu2y7/3o9qT3nQ6iGgqnQqVkHGyM30m5hW153cQBmy0QRzEKRiOdzianoOejpsCsO+d3BXHIF4OehFFuSLpcGaSoCyACB8mGEVmNKvFiqdEcC+ujprNfrTMyKjgEocU1g7HWs87PSqhQcn1MDXIhR06nFqI3915JoRNKyoqJPTJ7Vnr/8nSiKpHVGBctTTAla996eG7vgyFdlXI22Q5zTjvHUrjvfb1XxioYFuMNc4dOiFeCE5PjY4kgOXzOmdMg4G/RQmCOxR+hQfx9GLHryoDZN0FmaXIIi04JRlN8yu0ubg2a8wlukqMawDDa7xPhHwS/EAPoZ5JHCblFcLwQcr6gSQ2qipRo2RBxtEtsWtRwM2T9pf1T0odvMZjjMm3Er8IECmzLs33yxpeEDXaHIlaoRfBHIx4OGM4NrDlFd4GWJo7n2scBacSX+LJldpYhrwUHF0upnINRD4jNt4KNckOCDwQ9v/Y6OQqy4gZtjNLLPv/ltwpefGXB8vlZZCrvXpbOzxGzSvjdzeWJhBUxA3uG24/fE2f3TQERDX4ryD9t/io1OYpIbKbEwDr9WRNpbfLb7MdRTm4wXafiFh4X17cKCM1nqH3TIczxx3+ZTf/ERjENtq2P/DGYTgIc/57NBY+IMfQVLxDXX8AWLvc1ooUQFG7hsSE2gY0qD0+uOHiQEbLiAIVM7u1w7XVgglAT0eFNkDAwtAJpOr3F3MDUyX/jcmeO/FJeQ83ETNvzljmWG1io53dVZD8eAsNPmYXsnByEpMSZiSiBX2fQ5zgoPfKxs/xkenXxmQDwXgw2VySl2fKXdOuXdpEp1iUMD9dg/ipOCA8xZnDcL+/WqAWoBE4TZhX4bfia8ljZNmxkdHuY+t05PATGOtlfy+arqbDNcFEgJMhgqOotgvEjon1OFYg1MBQDRqFMsk4OE9p2BUoGX4d9RrA9BE55w
 s5i5A7tj
 q6S3KQkPr0gOyNzFmUDai+1iERAP87XvKClPXJQJkoq5W6ncY9XqJPScyloRCHhY7UzQw/xA1F1WDno6SWi8xK6o/pcci4FgFQIA7rDqZdsVwMaK8ypfcsT8so2hd/RF4kHNRFOinItMjyHOwePMpAjRBtZxoRrib0oqhqKcRZe8//E54mYtYWGXPbjgr6uG2ZbKDhN8Jxn1a8Nh70Fq93wfDYEljpA1AuecQhu17JOjsYu4q2U6+EYe0zEsW//Qib6kX0q6+XihAY3af6ONtKPl8ZxntoRLv8uUc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 2:34=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> After shutdown_mem_profiling() clears mem_profiling_support,
> needs_section_mem() returns false, so later modules have their codetag
> section placed as regular data and never enter the alloc_tag maple tree.
> codetag_load_module() still called load_module(), which allocated a percp=
u
> counter for every tag; release_module_tags() could not find these modules
> on unload, so the counters leaked.
>
> Return CODETAG_MODULE_EXCLUDED from load_module() when profiling is off:
> codetag_module_init() drops the module's cmod and no counters are
> allocated. codetag_unload_module() now always calls free_section_mem(),
> since an excluded module may still hold a reserved section.
>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Signed-off-by: Hao Ge <hao.ge@linux.dev>

Thanks for the fix. I think it could be done simpler, see below.

> ---
>  include/linux/codetag.h | 4 ++++
>  lib/codetag.c           | 8 +++++---
>  mm/alloc_tag.c          | 8 ++++++--
>  3 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> index a25a085c2df1..88081c618673 100644
> --- a/include/linux/codetag.h
> +++ b/include/linux/codetag.h
> @@ -52,6 +52,10 @@ struct codetag_type_desc {
>  #endif
>  };
>
> +/* module_load() return values */
> +#define CODETAG_MODULE_LOAD    0       /* module loads with its tags */
> +#define CODETAG_MODULE_EXCLUDED        1       /* module loads without i=
ts tags */

I see no reason for adding these special values. You could simply
return -ENOTSUP when profiling is disabled.

> +
>  struct codetag_iterator {
>         struct codetag_type *cttype;
>         struct codetag_module *cmod;
> diff --git a/lib/codetag.c b/lib/codetag.c
> index a9cda4c962a3..8506ecab9ea7 100644
> --- a/lib/codetag.c
> +++ b/lib/codetag.c
> @@ -238,9 +238,10 @@ static int codetag_module_init(struct codetag_type *=
cttype, struct module *mod)
>         }
>         up_write(&cttype->mod_lock);
>
> -       if (err < 0) {
> +       if (err) {
> +               /* Error or excluded: cmod is dropped, free it. */

IIUC here you want to call kfree() if profiling got disabled. If you
return -ENOTSUP instead of CODETAG_MODULE_EXCLUDED then this condition
does not need to change.

>                 kfree(cmod);
> -               return err;
> +               return err < 0 ? err : 0;

Here you can do:
                    if (err && err !=3D -ENOTSUP)
                            return err;
                   return 0;

>         }
>
>         return 0;
> @@ -388,7 +389,8 @@ void codetag_unload_module(struct module *mod)
>                         ++cttype->content_id;
>                 }
>                 up_write(&cttype->mod_lock);
> -               if (found && cttype->desc.free_section_mem)
> +               /* an excluded module may still hold section memory */
> +               if (cttype->desc.free_section_mem)
>                         cttype->desc.free_section_mem(mod, true);
>         }
>         mutex_unlock(&codetag_lock);
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 0a7b657fe2de..461fa87fbb0b 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -977,9 +977,13 @@ static int load_module(struct module *mod, struct co=
detag *start, struct codetag
>         struct alloc_tag *stop_tag;
>         struct alloc_tag *tag;
>
> +       /* Profiling disabled: load the module but exclude its tags. */
> +       if (!mem_profiling_support)
> +               return CODETAG_MODULE_EXCLUDED;

Return -ENOTSUP here.



> +
>         /* percpu counters for core allocations are already statically al=
located */
>         if (!mod)
> -               return 0;
> +               return CODETAG_MODULE_LOAD;
>
>         start_tag =3D ct_to_alloc_tag(start);
>         stop_tag =3D ct_to_alloc_tag(stop);
> @@ -1002,7 +1006,7 @@ static int load_module(struct module *mod, struct c=
odetag *start, struct codetag
>                  */
>                 kmemleak_ignore_percpu(tag->counters);
>         }
> -       return 0;
> +       return CODETAG_MODULE_LOAD;
>  }
>
>  static void replace_module(struct module *mod, struct module *new_mod)
> --
> 2.25.1
>

