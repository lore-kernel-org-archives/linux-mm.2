Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0DC2CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 04:09:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 626F76B00EA; Tue, 19 Aug 2025 00:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FEE56B00EB; Tue, 19 Aug 2025 00:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 514EF6B00EC; Tue, 19 Aug 2025 00:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF3A6B00EA
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:09:39 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B2BC1C0251
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:09:38 +0000 (UTC)
X-FDA: 83792178036.02.697EB30
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id E78F716000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:09:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IBX+3utF;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755576576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ztcBg5RDRX7GPPZYTkfZrwxVUlSNU2Y6uUSU4mWhmOo=;
	b=3aWgdeuV22jx4iQ3Yx4UHmAlBWoig/LZuzWyrwiH3mbgXqNFL5QD/3aJWxFW+TSyojlmHV
	GxMO3dvjQUVFsajCIzfxWa7zfwDKiUCdGVEbDISQyIqAO3lFgEaVR+EWRQeenkXr/QdjmY
	ORuiB7QIT2+vmoPDKcc+cd7lN2T6mnw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IBX+3utF;
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755576576; a=rsa-sha256;
	cv=none;
	b=SB4/XweQKxNvL6FZx1jwa8IgwqlHBhgA7vUhKGZliNQ5Tumj1ShkCXoHFwXVvRURvUJvc8
	FjpB6JxLIlLBV0XKIfqXerIvw+TgB71rpTAQfiBdl4NI39FbZCB3Nrn0b+xxs/hIJS/A7b
	/LuG6NSn09Bh6i3MfD+1FXcspPc//BA=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b0bd88ab8fso145541cf.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 21:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755576576; x=1756181376; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ztcBg5RDRX7GPPZYTkfZrwxVUlSNU2Y6uUSU4mWhmOo=;
        b=IBX+3utFHaPJzMG0kBbG1HaXmJrSOEZRHhwp6mYRHr8QMtfzySU3o3I+9NkMmjVJGq
         1n52GCagiafabJUUCv/mjtTYlBpN6HozNcaHzLPNiJF3D6duep+hpYPsg1Apyx8ocxrk
         XsZq1BScRmb5CH+ti72jbF/8ia0HkrT6f86HaWt3Lf8L4sh1I/Kv/l72m6F/7ek839WD
         Sc4DAqJ78T0b+otIClZrEG0bS/U4dSguGg0HUfSyDYCeZV0zjBCIwXsD6PLFk8QaQbxB
         0D69FaUD9PAvsVzIRevkDmLPAnNhRMdGOeb61NlieVp4/s/h45yb49ZbusIFaaurg1/x
         Fi1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755576576; x=1756181376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ztcBg5RDRX7GPPZYTkfZrwxVUlSNU2Y6uUSU4mWhmOo=;
        b=qm2jpkoOdlZW/Gh9yzdRPdkvbIum4UnmIOEc+eUv/T3bb8xK8q7Q4hUra7DjNjizsG
         e+PqSzTa5HxGcpKqEHjYq/l1P2cEEUWayWXFCZYWgsR8+lZjsvMveGrar+e2NVQL9uUa
         W4GxUM3/Q4k6ZjJVcG/sJRfvsBZdG3sSKuchcXHeLuNHrnv/1VuqQr02xXJL9l5a7xIm
         HcCU2W2ob/Rwkayhyx8K8mO+OwkTUqIj3RZ2Cee5GM7ieYwNvWh6WwzK9dpxxtJw66pe
         9GTnCwkJ7hGJTjzLKTA2wbYJpcv/t3qIWuMy3WI8icCORKwiLm2AnampQW/5wzz5ALwZ
         Bh9Q==
X-Gm-Message-State: AOJu0YzI1vs1NNtTpw3x4osTGkxEU2y/WYP4PmqYPjvdAoshc0sgV/Pn
	Ryl+7XdH5CTCuMdNOSMthe3rhQMQcBepHEUftPRPsmR5hKfuBVW0ZCFVBbt89uokGjDB6BTwd/R
	UC3VKwAAtXRJu77uvz/lXO71ullhn2phsFF9zFvU9
X-Gm-Gg: ASbGnct9TUPa5OCSsZz6AkfJjC6yR1+ti63oX9lr2rd+hsEEPbS1BrgDp10EWgtYtrG
	PZvF6OVblBq98cy46VqdG+UEi644AUzo1pM9joA14Ir09b9/Oqi70MBgr551BMAaUaqPYoSjRsT
	FvjwEIy7fWSG28QDJtUK/atPWhC+wpjt9vcnEPrWTujV+zJ73yY+UOLeMB/dBWgCH6ZCPNk1I3z
	WR7v8YaN+W0hlvfoGjaED8=
X-Google-Smtp-Source: AGHT+IHaJMVY8MOM/c5j+pR0p6Xkf0AbhVTTukYaslfi1GxFjKp1eTRircaiD6qar1Gbvqm5iBV2XhAexicJk+859VM=
X-Received: by 2002:ac8:5ac2:0:b0:4b0:8318:a95 with SMTP id
 d75a77b69052e-4b28644b11dmr2365431cf.8.1755576575653; Mon, 18 Aug 2025
 21:09:35 -0700 (PDT)
MIME-Version: 1.0
References: <20250818170136.209169-1-roman.gushchin@linux.dev> <20250818170136.209169-7-roman.gushchin@linux.dev>
In-Reply-To: <20250818170136.209169-7-roman.gushchin@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 18 Aug 2025 21:09:24 -0700
X-Gm-Features: Ac12FXzLbPuoxnMNoJu89p8-KDZbGkP1Vhh2K8HYHSwD3YgxmIxXxlNBFUSNhXg
Message-ID: <CAJuCfpHTtLQR0NpsbFytaOdEc0KqNv6PxVpxNetYD6Ce4sY9UQ@mail.gmail.com>
Subject: Re: [PATCH v1 06/14] mm: introduce bpf_out_of_memory() bpf kfunc
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, bpf@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Song Liu <song@kernel.org>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 5174s68uxrm8pc84sqpkeymup6sfqs44
X-Rspam-User: 
X-Rspamd-Queue-Id: E78F716000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1755576576-883330
X-HE-Meta: U2FsdGVkX1+Rbzex/HupCqyOILwT8ReCOmRea2/O5dpXHSDlSVomVTImrLrbBl2bzE0C4auYTkFnwvSRktVbpQAbJZmxaW3U8wpWzwK3MGa4VOSXe8q5wSWZsAP3JIqevoMkr06FhokjYhZTRc1MzBGJmqPkUsE9sQzgHtB57b7DWdfTTUQKQzr6cTC1BcZfY/d1BlGivGu/uCFpaoO4muvdJNdUvGcC6M1HmbVYsN4LnpzrBkKg6Hj1o6YZ9XfHKMJtmUw3Wat3RPMpp+mZnR1Y82MZQmIro3K9nGkCCWT9VIybFqodWzFtJOBokytDziW8gFESzvRwOKARqwUkTu25L1WukuZnahy7BAAh8ha3BaJBXFXnmjHwh/J8VmtKiFZjETgkC2CR4EnxVHtDcBQ4jwuWGJWVKpqPcFnT/tp4oQb4/b4H+SxIb8VyE9BiGiB5XBPezObkAdW/WF8KAYUKDgv9KXrPxTZbYydxOt57iEiUtDmtj0TKnaHIMTT5t03ZF3xrF14aM4FztEcyNxs1gyd4nQ56UzJeyWg/+hBDfzdNaXGBnXBpA+WTzUjgftY89XAeWtkuo8HRUifSzL7qHn5QaTaZtSkMSIJNtJZ38xWQe0BHwgugJnuf+3bbV52f1lhikSJxyRn0V0lHeVv41Hr9DlvijXFcFEru2PSf/2cQXRIzZhODtXRyo8Z/MN6hd41utxrflWj5dy7ORbcXM87M26BS5z3+WYeMmbJqvPp2gxgKehSEYzNuoodhx3RiROrVGtZkSM3GOYfV/2eGswMGnyb9TiJq9ztsPE9ZGnABVbyYcHVtqJEV+mOVylpKzI8DWGLhB6FXCUqj98ut0OocQSNnraUmIl4227TkGLDuHfSR/K325egUsog4FMUVG9vyPfDivZL9IRjrWqbX/yjZ6m3abKNCvdE98KOyrjUFFL5fTFiXR4j9+1QrtVYAoFLRiNynN2cmZ4s
 XsDmYxtb
 srKc3xLnzEQhBcTZ7UncLQvjvsOaQOXYLPfoPObaz5X84CfA8M89Lsnw5ETC0XytRPcoXTIO6wIcms70qpeZHxNs7SgbqmBM81eXrPgmG1A24UD7/pxXGEG10msymQYRWtR8hEp5TuBTM3sW8cn6yAzdjDfhtlwpPiaHVlNoqjCX5nTqnKWZ3AL3W6bMMtv+G2PU8M1jYp+BbqqGwSMIan34Y7h0913aYJmCKqFJ8ceFa/B/KL6Vd0r9pyg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 10:02=E2=80=AFAM Roman Gushchin
<roman.gushchin@linux.dev> wrote:
>
> Introduce bpf_out_of_memory() bpf kfunc, which allows to declare
> an out of memory events and trigger the corresponding kernel OOM
> handling mechanism.
>
> It takes a trusted memcg pointer (or NULL for system-wide OOMs)
> as an argument, as well as the page order.
>
> If the wait_on_oom_lock argument is not set, only one OOM can be
> declared and handled in the system at once, so if the function is
> called in parallel to another OOM handling, it bails out with -EBUSY.
> This mode is suited for global OOM's: any concurrent OOMs will likely
> do the job and release some memory. In a blocking mode (which is
> suited for memcg OOMs) the execution will wait on the oom_lock mutex.
>
> The function is declared as sleepable. It guarantees that it won't
> be called from an atomic context. It's required by the OOM handling
> code, which is not guaranteed to work in a non-blocking context.
>
> Handling of a memcg OOM almost always requires taking of the
> css_set_lock spinlock. The fact that bpf_out_of_memory() is sleepable
> also guarantees that it can't be called with acquired css_set_lock,
> so the kernel can't deadlock on it.
>
> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
> ---
>  mm/oom_kill.c | 45 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 45 insertions(+)
>
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index 25fc5e744e27..df409f0fac45 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -1324,10 +1324,55 @@ __bpf_kfunc int bpf_oom_kill_process(struct oom_c=
ontrol *oc,
>         return 0;
>  }
>
> +/**
> + * bpf_out_of_memory - declare Out Of Memory state and invoke OOM killer
> + * @memcg__nullable: memcg or NULL for system-wide OOMs
> + * @order: order of page which wasn't allocated
> + * @wait_on_oom_lock: if true, block on oom_lock
> + * @constraint_text__nullable: custom constraint description for the OOM=
 report
> + *
> + * Declares the Out Of Memory state and invokes the OOM killer.
> + *
> + * OOM handlers are synchronized using the oom_lock mutex. If wait_on_oo=
m_lock
> + * is true, the function will wait on it. Otherwise it bails out with -E=
BUSY
> + * if oom_lock is contended.
> + *
> + * Generally it's advised to pass wait_on_oom_lock=3Dtrue for global OOM=
s
> + * and wait_on_oom_lock=3Dfalse for memcg-scoped OOMs.

From the changelog description I was under impression that it's vice
versa, for global OOMs you would not block (wait_on_oom_lock=3Dfalse),
for memcg ones you would (wait_on_oom_lock=3Dtrue).

> + *
> + * Returns 1 if the forward progress was achieved and some memory was fr=
eed.
> + * Returns a negative value if an error has been occurred.

s/has been occurred/has occurred or occured


> + */
> +__bpf_kfunc int bpf_out_of_memory(struct mem_cgroup *memcg__nullable,
> +                                 int order, bool wait_on_oom_lock)
> +{
> +       struct oom_control oc =3D {
> +               .memcg =3D memcg__nullable,
> +               .order =3D order,
> +       };
> +       int ret;
> +
> +       if (oc.order < 0 || oc.order > MAX_PAGE_ORDER)
> +               return -EINVAL;
> +
> +       if (wait_on_oom_lock) {
> +               ret =3D mutex_lock_killable(&oom_lock);
> +               if (ret)
> +                       return ret;
> +       } else if (!mutex_trylock(&oom_lock))
> +               return -EBUSY;
> +
> +       ret =3D out_of_memory(&oc);
> +
> +       mutex_unlock(&oom_lock);
> +       return ret;
> +}
> +
>  __bpf_kfunc_end_defs();
>
>  BTF_KFUNCS_START(bpf_oom_kfuncs)
>  BTF_ID_FLAGS(func, bpf_oom_kill_process, KF_SLEEPABLE | KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_out_of_memory, KF_SLEEPABLE | KF_TRUSTED_ARGS)
>  BTF_KFUNCS_END(bpf_oom_kfuncs)
>
>  static const struct btf_kfunc_id_set bpf_oom_kfunc_set =3D {
> --
> 2.50.1
>

