Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9BCCF45D5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 22:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D271A6B00A0; Mon, 12 Jan 2026 17:18:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD1076B00A1; Mon, 12 Jan 2026 17:18:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9F436B00A2; Mon, 12 Jan 2026 17:18:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A50D86B00A0
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 17:18:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4BEA8BE879
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:18:33 +0000 (UTC)
X-FDA: 84324726906.06.514A135
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf20.hostedemail.com (Postfix) with ESMTP id 616AE1C0008
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:18:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="DY9/m4R/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of avagin@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768256311; a=rsa-sha256;
	cv=pass;
	b=L/M9n9I0vOke8SPWEoHLvp79UCm+SvKuFaG8dfpRZK0FWY1P1GveR8k4bMM3FbvzdmumgU
	JweUHdYwg1ffwujncA876sfGkEiW2a61lVzvzhLvHkAqeORXMlhUDOHEsWJUGbdmMUmuVh
	uFOT0yhjaHoNPvmwvpqIWU6A9AWagR4=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="DY9/m4R/";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf20.hostedemail.com: domain of avagin@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=avagin@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768256311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pqx6ovJNZlQMxRNZ6xtrUrvyplQ/Aq0eWptvKJzLwh4=;
	b=wXqfcefe29d6x03trVbtUzDDXuc3AQ+NC7jU97TkQ02oGpUNdV67qao4YBwXdId4ROKz6A
	dIvKey5DB3uY0gRMnP/2uXoMAkk+nQVsNQR80MmwsZ2hdzf+A/wz+6BG8RDd1IMu6meUKr
	k4ZO9z70LS+zcqLYWhSl+alOk6Rdc/4=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee243b98caso59291cf.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:18:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768256310; cv=none;
        d=google.com; s=arc-20240605;
        b=lv3vJhvAZOXOWIfSeQfsFiqICUpOm1srLrPtzPJxrnCeA4SYkxzN61/q7KJ1yyLGiM
         ldv9PLJR/ED7rD0ftyFaYec3/PW6ARQLfWtpkkxgk0+GroKa39eWNzaXSF3onnPimxzI
         ImS59Begpb7MsvWw6tV34FN2IItIwn8raNkZRVKHa6X/3mleTyQ3DSePAgiQJwaCOK4/
         6mYRwGP7E8TCExvXZKa+EvX778YS7G8GAx9NdSgITzCFXKFRG1Twd0Jy45CrMVVTuuJ2
         iVugaQfV5ms8zDp7yQz5erkykHp3vDia1+TwvoKyfH11bnowJUCRrIQye3uv0ibZC4+U
         AKhA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pqx6ovJNZlQMxRNZ6xtrUrvyplQ/Aq0eWptvKJzLwh4=;
        fh=KnDS4oV1JfftrStTg0ufUGqV873cyIp8o28MSc0UwQA=;
        b=QP8wj3FuupSyfyj414PoonYMFzQD+cC7LO2e9aQzppH39oXYM9AiStvPJoaqTwwPcb
         AhFmsJDOI0Vh63LmLKsyfTQxgZ2T3cbMfhCwhTAMoY80hC8uUnDZOiIKzHuU0hEdlVUU
         z3ffgoTFCLmJGyoZC1/3uH5jbKvCF2tbRjzfLv6nfZHuaxgu70zXpgzOolafrCLr9OlK
         rFm8VS+TxeJsAbIQPFp3K+0wRAZ+5IepuQDh3JVrBeyF96MML7M6h1ye45GCdhaVecDo
         OCS4nt67h+7nJEBHIRPPpZqgAuXguq3D6YBn7ueyTDx+uNcIqpCAblpV0bg2WYKlUFpE
         tcfA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768256310; x=1768861110; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqx6ovJNZlQMxRNZ6xtrUrvyplQ/Aq0eWptvKJzLwh4=;
        b=DY9/m4R/2ee3x3FVy+EHLuip5fkAVU6s/hMfrvlBrOe/oFx+XL3+uVWb0/t500hVde
         6k8sbsEPkkSnEqu3lWUZx6oJcGEtu84+Gl3oo5QOvgbA+28PTKLQ77BsdlMvsYuAdUhe
         JZCwxjXiVC+xkUOTnHY+FXPK/GRKzU8+rYlAnD0xoisUAWPU6dbRt01DZs2bAqZ3x7z0
         8Arp9QNyVLyT2xSKYWtAKFxY2M2Ku4nXQ89Rw4TlIt/wXZgPeBew/N4BbYW4EL+BkBVd
         wZ0TDXdJLCd1jsgKRh7udObw7vcHz5jkVfKBmxfoX1jio32iPMLuEyepcsfTdSrgd7zu
         gM8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768256310; x=1768861110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pqx6ovJNZlQMxRNZ6xtrUrvyplQ/Aq0eWptvKJzLwh4=;
        b=adO7b4pSiFPsYqc5XU5Exs6mJxKFBcsgTooN18B0jYDgKkynYw0s/2Z+ZHc5UL2mPl
         86h+MIc7cuiNiPevWTWSrW8HbKlvYfn0u4GLMwGMKevebfOoY1vATXQVNDp3dOkcICW5
         5PambeJCZxi/Ux26XMOqFbQWEy9dTXGPEAx3evuLQwYfcqV3LqOS7IY24ZdRT41EwZAL
         N4+0GYxfKYDEN8aWqYDkUUxzajjZ217tdP1RErC6/0t6c66bExeZ+V2FaLBroDC9dT9w
         rlV35kfu2X5XUszmP9yKWJYpmJwJSvdK7Sd9Xvp+PlquttMgcYoxaR7cwORw17kpWl8L
         AwIQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlARdJChJsMPdWFwt6nz7VJ4krI71GsxZTsgtZVLL9qZQtCKOuiSPoLx/h7FkhLNzLRcR+4Bnwmw==@kvack.org
X-Gm-Message-State: AOJu0YwV+spSXLHMfCT6s25HpCD264qWgnf39O7udOIL5sH1vHohrs0d
	kqpf+XfSSksAtaY8wmufkhTi0I/EAk2Qvtx+wHp8V6bG+V+YgsdsKG98Oiwh0SHlnVP45AEoTny
	H/pwd0W7+h3uBbLOemCCxYxJJrgOwip/x9oUeI4P5
X-Gm-Gg: AY/fxX7szAiAFEKWLn6HIZCqN8tYl9ypVW6Sd+OQ2b1ak4xcd/VPnZCGuZvaK+jP/sE
	O3oZHBGExQnrsBBE/2yn+hnhENfZuziim1SInXAO4ETWAL90cjjBzJeUXhPiMxjQW05O9+1PbyI
	TNLlNPuRYMnDJaOcH4imrFGrAuqcXoJ1Qgzc8kyxqT5fwoaNgMvbvI1UC7Lp7IP/kGcPLfjDI3x
	FAVmvHkGoZYGg880CnO+1Xh1wKZ0RGVWzDBWT6sScdTehJ+m9bqjolZIZHvKgO8RIkm55PY
X-Received: by 2002:a05:622a:1b88:b0:4f4:bb86:504f with SMTP id
 d75a77b69052e-5013a3984bfmr3348061cf.16.1768256310151; Mon, 12 Jan 2026
 14:18:30 -0800 (PST)
MIME-Version: 1.0
References: <20260108050748.520792-1-avagin@google.com> <20260108050748.520792-3-avagin@google.com>
 <wfl47fj3l4xhffrwuqfn5pgtrrn3s64lxxodnz5forx7d4x443@spsi3sx33lnf>
In-Reply-To: <wfl47fj3l4xhffrwuqfn5pgtrrn3s64lxxodnz5forx7d4x443@spsi3sx33lnf>
From: Andrei Vagin <avagin@google.com>
Date: Mon, 12 Jan 2026 14:18:18 -0800
X-Gm-Features: AZwV_QgFDLRZ2CO39u42hYQfjphtOd--py_KaLDidq3C2V9cruvBn8uqBMP31xw
Message-ID: <CAEWA0a4s+Uhm405CnvNsE61ed5_xJ8PUZqL74zfeZnivw1BChA@mail.gmail.com>
Subject: Re: [PATCH 2/3] exec: inherit HWCAPs from the parent process
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 616AE1C0008
X-Stat-Signature: z44adunb19czmirzkqis6odsmo9xmpyb
X-Rspam-User: 
X-HE-Tag: 1768256311-174388
X-HE-Meta: U2FsdGVkX19ymzIHI3X8lvUV78xCQjLyAaXiSDVxJ0RjIbHguKTxWIGsGEooP0p97WCPR2RrrfWYFo6VjxDj2UeQGfJBa4nCLm9JaOCYhhEmeFzZ+EEF8fGWgko7TxeRJBpOmaWPubgvN1bC4Vt1vpuDtniKaKr/416ZHjinsCrF87OzTTyBZKi0oVcDSJBBS5652sXgwgqJTY+L4niIxC+VKtTGIWKFk+w1yHbOzlv4RNlwg8qtw8bWOfuT6FzEbD1ZQIBTI3Wog+U8OAZ9yzQp52Wf5MwCiwiCY5hJUOeDqq7sLZt2PmQir391TId2qkUTzpkfNpuxLthJxHjudJu6sXKcs6OQ2SPj4dESsnzErEh/2d3KldZZ/l2se6QdqHgaTIkk6KLHsW1DaFQN8gzUC9lAx1r3dlHDavCmURL1Ck1J8JH+DgZbpp/B12f9XbmZ7vaAbSygI4yQHQfR1yHV0FLUtZe1+t7xby2rGgikTbu3olH5avYJRvE+f4EQwSjYC0S/9N5D2ofyVdG0ZyqUNSBrJHi1igpEr4czEST91bD/uw57Sjl+aTozm7m6B1o9jJ1FLzWNo/Je06krSeCmzP+aqYSDrQtNexVyY+dVnqzHJijyL2xNOQB2MGHF2dd79LCUgT/QEEJ9WCgmsffCI6Jh7nTwDQ1L2ya/9RQx1wMhsJ5vONnSgyEvZdtVINqO+S2vQcBmWJIhKEwwtLdbVn723tDnhXxozJoUGR3FC8bKv7k5zM7tqcJDFwzxGXxaiVnHJheyTWlAxCJEHO210CYU8IaDY9/8+DNsmctkeQyh8TiqrG/R5/aml37fQs76g6GDGMw7vv8e/imNo+UVA9ahWCpELqn6df2SJUCemSfw3WnyHDXj8VwDgcIuge7aanCrmB6lWCC/RhVvbW/B+C5UX2HUWB+gXE1wjbh2mbymfDSOd+NBe+KUNQFGe2CD9NaWRHVF7fVcK92
 nN/OqfCU
 W0aqzEDXAP1CjxqqILDpWFexRfCm2W+7mGJj2hKxNddxcXV7bmJsWWhhv4YLshI459iv5osANliOO+cyPT2eQNmxmC/Xtzf0dHlpR2EIGZ/muigRAPe8iRnomFJC4QADVsInd04BrfD+AFGagxtllPnGeuJHG/QgcRuLKise34mWzSfwJ0hOij0DIvjn8crUyDx0IhDx8+pKbk7Ca/Fd+REi2nDxDWHszgOB1x75vyf7I0ZHnYB71ISk4gbsyZuVS04fhe3ToCjvnKllDPQmQrltz2T2ptv9nHfgVQQBIgUGmRRWnzEJnxVv77nfxeg+d2Y45
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 4:46=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Thu, Jan 08, 2026 at 05:07:47AM +0000, Andrei Vagin <avagin@google.com=
> wrote:
> > @@ -1780,6 +1791,50 @@ static int bprm_execve(struct linux_binprm *bprm=
)
> >       return retval;
> >  }
> >
> > +static void inherit_hwcap(struct linux_binprm *bprm)
> > +{
> > +     int i, n;
> > +
> > +#ifdef ELF_HWCAP4
> > +     n =3D 4;
> > +#elif defined(ELF_HWCAP3)
> > +     n =3D 3;
> > +#elif defined(ELF_HWCAP2)
> > +     n =3D 2;
> > +#else
> > +     n =3D 1;
> > +#endif
>
> Is it guaranteed that HWCAP n+1 exists only when n does?
> (To make this work.)
>

It is true for all existing arch-es. I can't imagine why we would want to
define ELF_HWCAP{n+1} without having ELF_HWCAP{n}. If you think we need
to handle this case, I can address it in the next version.

It is just a small optimization to stop iterating after handling all
entries. The code will work correctly even when HWCAP n+1 exists but n
doesn't.

>
> > +
> > +     for (i =3D 0; n && i < AT_VECTOR_SIZE; i +=3D 2) {
> > +             long val =3D current->mm->saved_auxv[i + 1];
> > +
> > +             switch (current->mm->saved_auxv[i]) {
> > +             case AT_HWCAP:
> > +                     bprm->hwcap =3D val & ELF_HWCAP;
> > +                     break;
> > +#ifdef ELF_HWCAP2
> > +             case AT_HWCAP2:
> > +                     bprm->hwcap2 =3D val & ELF_HWCAP2;
> > +                     break;
> > +#endif
> > +#ifdef ELF_HWCAP3
> > +             case AT_HWCAP3:
> > +                     bprm->hwcap3 =3D val & ELF_HWCAP3;
> > +                     break;
> > +#endif
> > +#ifdef ELF_HWCAP4
> > +             case AT_HWCAP4:
> > +                     bprm->hwcap4 =3D val & ELF_HWCAP4;
> > +                     break;
> > +#endif
> > +             default:
> > +                     continue;
> > +             }
> > +             n--;
> > +     }
> > +     mm_flags_set(MMF_USER_HWCAP, bprm->mm);
>
> Will this work when mm->saved_auxv isn't set by the prctl (it is
> zeroes?)?

The inherit_hwcap function is only called if MMF_USER_HWCAP is set (auxv wa=
s
modified via prctl). However, even if mm->saved_auxv hasn't been
modified, it still
contains valid values.

Thanks,
Andrei

ps: Please ignore the html version I mistakenly sent.

