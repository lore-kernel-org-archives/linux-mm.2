Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42363C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 01:09:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A77A6B0092; Thu, 17 Sep 2026 21:09:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 140FC6B0093; Thu, 17 Sep 2026 21:09:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F296B0095; Thu, 17 Sep 2026 21:09:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE2CA6B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:09:17 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ED0BB16051A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:09:16 +0000 (UTC)
X-FDA: 85225099512.09.518F7C4
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 11418180002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 01:09:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tq0qOSPR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Tq0qOSPR;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789693755;
	b=bFKP/T+EmOXUm24mj1azsmd6bVkdX3IDbr751z9LDY4+eeEZykPZOaBCwO1+kF7vnCaZGl
	gX4VPKxgOJ1iY8iu/3NUECyPASWikoBgiH4j2V8PIMvJLzunhUupUgPyTdmb6XO6+wXhZR
	r8TZqnSdY312tLXh5GPU/FhKH9MRbiA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789693755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OH+vRLumsrAn2s1eXS41G1CuSBMFEgYn9wTdjASFyo=;
	b=s4Ls/e3ALZfl+Xn/jRZAakIq/cmf4V7fxk2WtJUVWZH1KlHT4gwU661IDesY7uOs7W3M2B
	Aeh14LylR4VoUjj8x93ReYKoCK91Xd26RdXsbP4Lp7Yt8gvz12NZWoHKnBG9cFLm2ZA2Tc
	y3gAytQcMiEQZsCpNIzXgrqTPhiV2Hk=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-52faa58bff5so157761cf.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 18:09:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789693754; cv=none;
        d=google.com; s=arc-20260327;
        b=IjKxN8zexEHiH+cMG30gTMZSUPIWXNGTwCWn9T0XUjK43GLeUY9On2aHy969Im6YN4
         pZC5otzBRyBxyzT5hJRScUr0pEdnDnrvVq3ehKkR3IRgdusDi5xIBNPsOBrSWXYfB3sJ
         Oov/yqjjgHFhKF9xrPAHvQgWv4xh2vqlEvfZSLpOmYbicTLCO0H0CzmavyQkk1FI0kk5
         dHIvL9xaka1EyeREu41eFevprPxFOo1oCR1ljlJilp80OW4sBYgKS+n9VPAYtMphpk+z
         qkRKXb8LJwvMguWykgwA3+W4BFsBVbA8gNM7v2yb4BEIphRMkByBirv1rPL4Gy1MZiQa
         tLKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9OH+vRLumsrAn2s1eXS41G1CuSBMFEgYn9wTdjASFyo=;
        fh=2fSgCUdf2lnJh536sHXWwZPIuv6OGRC7I6oXBPz2Ezo=;
        b=IBPUNGwkqmpFIe6300my4AuEMd1l2kRjEWctHpzIepWFAeCH8HEPaZ8xv0c4YbtvdR
         /1q6v7YyrVOkGj5bHVGVfqp/93+HGIs0pJmrH8PcTTmROWM806v9YyA2VzIio0NFWmJf
         TTT5LU6B7imdiQ/NwYMGfw3oZIMZ7V+a/VJ0WU6pwLUXYqFtCoiXV0vbplW32ChJ1E+S
         IrcmYx30mwpU0zztrSRDZhcdfSEmQuLTdZHdF4mVCr95QrE6QulA9MkVzdaCBgq85RVr
         5oBUC4N5y5uTAPdQv8N+EvgqLb44yEd4293EyVVTb2NJ68ILn0uj6S4Y5B4Erbib6qiq
         H24Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789693754; x=1790298554; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9OH+vRLumsrAn2s1eXS41G1CuSBMFEgYn9wTdjASFyo=;
        b=Tq0qOSPRDT0h/bmY+ZiIfOB2EnqfZIFLQPq+EhPz1ZjIrJ6toabUKxqarUg2kc4hqE
         0y+C2QujHg+L1aYva5Dre99WUS76Z9Wc0DmV9QkOTH535BTmuWwd01oOLOysu9qhRewN
         mdjL2EVvMtZR5oNmS2uiz0LHKhG8xiO5exPgFjhY+bG5XR7kInUbixhw++HuEzbi8Ti/
         P3xIApsHNZYO5vbpUewaADwn1h973zQ91py0uIgR8l+oRgYnI6BOX4m0FU8jhMrYQfBc
         14KGOC5R0yO0zg7FhXSwPeoQsRhDTRyyneUhYPGh7wS7mW/7bkSVAMr62oEW0GLPeKMV
         +sMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789693754; x=1790298554;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9OH+vRLumsrAn2s1eXS41G1CuSBMFEgYn9wTdjASFyo=;
        b=ht9TfM1JKDoVkBDbJGdS4iI0GXeCJNP2IyfIvfzNs9ncLzHRgCI49N097sww8Kxb+b
         uUeBK8Oo/WNz+QoKo0HyIj3deRY777B+PqJvBts88SoDsSM15W7Baun2l18Nevyt6KII
         r80RO6ql9u7QGL1PMvlyHPySZfMboVVRr3hJtt28UoxHlAscPgInLaaWsr5tSgtMEJkb
         WEhZfDEN3V5y9/Glv3Sj7SBsZQFZCzvDKUocmq2ZXBQDZxbkN3hM/WrVGApPcSAws8Vs
         WqWP9DHrNcrV/h3OMT4y8weMWkXb7ETg0ZcQrXfnIdhkUNMtoXk0OfTzqSFDwYk+DJoZ
         HM9A==
X-Forwarded-Encrypted: i=1; AKwUvByn2zPFhZ2tZbnIsG28LU4ZZyCdlbv1XgzqlMwyzhYyUHKKhDMsq6AyPm6YZdZndc80KMibEsPZVA==@kvack.org
X-Gm-Message-State: AFuF++k015mQqYxwGBN2XpEfh5O+/1MLSzDnV1RnksNBhzjpvLliKuJW
	ao9piCcn0HdJiAW2pfze5WlItfRgWW4iBj0E0dk0M6vxmXRLuh3WCoasoNtLDw4weS7vtG7/+bM
	cWoVxxUQXzknAvYfbYhyn9u/WaqMZ9jZWWdgM9IkZ
X-Gm-Gg: AYBFou2rAF34mLrsti9hh/lav3w3RW8PMC1ngDsH7mKt7hKebCZcqwKjF1alHXKlB8N
	FXOat7h4emR8Wt8SFRRQIzpOWR+QFEaPRvO8vhZPBjkixOorjqbxeeZmEQ1NAXRMioydx0dmzdO
	VxXAmSILPEDMHDoRhjCDiLjpHEzdM0QBRo/Ehur4YoKcQ9ODB2g3iFzDHm594grsvjtYnmFIBL2
	6ESIRdEqpy1to+hTRbZ/imPYck+ZDJCttQbsZOhcREyswnVyV7woqnFJXlQly7tZpqYwJaG1LXe
	NXamrffdV92Wdi0SsqwJCd0447mevW5MHFNpa3z5On+G1IqxdNOflA==
X-Received: by 2002:a05:622a:2d0:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-5329d7a87a3mr7686831cf.12.1789693753565; Thu, 17 Sep 2026
 18:09:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260915070001.113559-1-hao.ge@linux.dev> <20260915070001.113559-7-hao.ge@linux.dev>
In-Reply-To: <20260915070001.113559-7-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 17 Sep 2026 18:09:02 -0700
X-Gm-Features: AcwNN1WpdwzfsuEi7atSbmPcBeuY9CTLz0TyEvuZKGkV5swWnf0AU7r2YB5LThc
Message-ID: <CAJuCfpGMQqjHsAvW=XUA1Q3AyaVJKM2bKYVja_fgn0wa1tk7DA@mail.gmail.com>
Subject: Re: [PATCH v10 6/6] alloc_tag: Defer /proc/allocinfo removal to a workqueue
To: Hao Ge <hao.ge@linux.dev>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 11418180002
X-Stat-Signature: 6tokk7aib7k5p499b995w8rjm7zwjdab
X-Rspamd-Server: rspam01
X-HE-Tag: 1789693754-45828
X-HE-Meta: U2FsdGVkX18wtAtes3LYF+feJ7CR4cmS+8BYowD2vT8jBB5rJ7bj/00IgZoAgsgBt4pq9sNyY5XmCwHWayz9bbMCKmoZgiia4wIiZAmkbVBNAR8FyBcKA1emQhrvw+4614fr+FnJ8y686Xs8VUb4+EqEDjPILZvW5I1T7RAMGQoHHG+1/KhOa+qKXiONgopbX7ajpDFqfgvTA/Kt0qW8GRPv4ItCvDrW13xft85bE2zYYwpP4NUhX/KOxnhyGEFe7zPgAIjdGj+k88eg6zDHz4nqflX7LI1meFVwz+/0xIS/msWpqZgoolCp6nMpJxCy0jQtGg2+iQaeHV/xTDHkecogJbSWs68dwHrCKDCyGmooR8OiSiEzR/hMpjCJVg17/ixBH917d1MBF3cgP0YNCzc4jT2fJMcxwJPsp+bJQyN15nZY3G9Gh3NEqur6pcXNPm0MLClq7ZCzNs/FIOcwHi160bI7Smgy5UY1aebA/lakc+Jm/s52wrgoNW1PZLSdLxcF9Dm/8zUT9kqItHZJ22zgW+aJhf/144k/aDkghfdi+zYUj3fYWEfIIEMXHIkogMLpaBfhQXZjQM7SZmkqCyQymT29kHw3g5CunlNkrx+KfVJCHdMPP+j0VvbQwNFEdWIv3Ccgg4usj8FmwEw2kQVX1RVPQMLxkHDiPyT7GsdDkce29sYCUw3Ocxfq/7Xy0r3J0E6fWhCazIlLzRaaEq56g5mPj7DAlUQdJjpXnXmY7P/m4RgkzSG+34Y6BXBr+z9/Cr7SJgf9MJ51sJnGQEVCDKZLyrqxs/sFgh5yI3Z6pWfS3/aXcP5xgjggJllqoUCJOpFPvuWUWTQ2YVYhp0ugsyWaV2kBOJDsay5UcqJguzM+WbrPKQqimG3Sz971i5961H476ulX8JBNbqFSPjizEcc0CjQSzwbvbhQNuG3WK3Qbb7PTReFG9oF5Mz3gYAcPBvYDwV7DfTjaqJ5
 lHYLVNW/
 +UcJTCeXS3e1RqXUquRPPrTXODvA5BnD26ffZr8Y5wkQzNcvtIBx3M67FyScsqDapgF/r/bCQ4xibkOYIzkUAv78ne2ybQ3TT27S8oRuFbnz9UceEvP1jL+EH5ptayedAA8qchLDrKcgehLs5gIcMyYDwmz6igZYUq9Akvx1dZdtR39wHzxILKl3s91/Kuqtv0lVs2PYgRy22vH5rgAwLmBKNI9gF0s95Q/9klelRYX2COaiYoguJfhdqXKTsGj11lkQACyIe3y0PXGBaQguUOtTkTmrSmLWi6nU1h8AJtpnRFiCQ0M0ZmHl8EU0UDYMa6ZNKZuQAKwvyDhvFDyKVhOqC/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 11:59=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> shutdown_mem_profiling() calls remove_proc_entry() from
> reserve_module_tags(), which runs under mod_lock held for write.
> remove_proc_entry() waits for readers, and a reader takes mod_lock for
> read in allocinfo_start():
>
>   CPU0 (insmod)                      CPU1 (read /proc/allocinfo)
>   ----------------                   ----------------------------
>   reserve_module_tags()
>     down_write(&mod_lock)  [held]
>                                      use_pde()            [in_use++]
>                                      allocinfo_start()
>                                        down_read(&mod_lock)  <- blocks
>     shutdown_mem_profiling()
>       remove_proc_entry()
>         wait for in_use =3D=3D 0         <- blocks
>
> Move remove_proc_entry() to a workqueue.
>
> The file creation is moved to the end of alloc_tag_init() as well.
> If alloc_tag_init() fails with alloc_tag_cttype still NULL or an
> error pointer, a concurrent reader of the leftover file would
> dereference it in allocinfo_start() and panic.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compress=
ion")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/alloc_tag.c | 26 +++++++++++++++++---------
>  1 file changed, 17 insertions(+), 9 deletions(-)
>
> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> index 1ca0409b492b..cfa0fc84b68f 100644
> --- a/mm/alloc_tag.c
> +++ b/mm/alloc_tag.c
> @@ -15,6 +15,7 @@
>  #include <linux/seq_file.h>
>  #include <linux/string_choices.h>
>  #include <linux/vmalloc.h>
> +#include <linux/workqueue.h>
>  #include <linux/kmemleak.h>
>  #include <uapi/linux/alloc_tag.h>
>
> @@ -591,6 +592,13 @@ void pgalloc_tag_swap(struct folio *new, struct foli=
o *old)
>         put_page_tag_ref(handle_new);
>  }
>
> +static void remove_allocinfo_file(struct work_struct *work)
> +{
> +       remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +}
> +
> +static DECLARE_WORK(remove_allocinfo_work, remove_allocinfo_file);
> +
>  static void shutdown_mem_profiling(bool remove_file)
>  {
>         if (mem_alloc_profiling_enabled())
> @@ -600,7 +608,7 @@ static void shutdown_mem_profiling(bool remove_file)
>                 return;
>
>         if (remove_file)
> -               remove_proc_entry(ALLOCINFO_FILE_NAME, NULL);
> +               schedule_work(&remove_allocinfo_work);
>         mem_profiling_support =3D false;
>  }
>
> @@ -1358,16 +1366,10 @@ static int __init alloc_tag_init(void)
>                 return 0;
>         }
>
> -       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc=
_ops)) {
> -               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME)=
;
> -               shutdown_mem_profiling(false);
> -               return -ENOMEM;
> -       }
> -
>         res =3D alloc_mod_tags_mem();
>         if (res) {
>                 pr_err("Failed to reserve address space for module tags, =
errno =3D %d\n", res);
> -               shutdown_mem_profiling(true);
> +               shutdown_mem_profiling(false);
>                 return res;
>         }
>
> @@ -1375,10 +1377,16 @@ static int __init alloc_tag_init(void)
>         if (IS_ERR(alloc_tag_cttype)) {
>                 pr_err("Allocation tags registration failed, errno =3D %p=
e\n", alloc_tag_cttype);
>                 free_mod_tags_mem();
> -               shutdown_mem_profiling(true);
> +               shutdown_mem_profiling(false);
>                 return PTR_ERR(alloc_tag_cttype);
>         }
>
> +       if (!proc_create(ALLOCINFO_FILE_NAME, 0400, NULL, &allocinfo_proc=
_ops)) {
> +               pr_err("Failed to create %s file\n", ALLOCINFO_FILE_NAME)=
;
> +               shutdown_mem_profiling(false);

You need free_mod_tags_mem() here.

> +               return -ENOMEM;
> +       }
> +
>         return 0;
>  }
>  module_init(alloc_tag_init);
> --
> 2.25.1
>

