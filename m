Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18510CCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 16:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 455198E000A; Thu, 23 Oct 2025 12:33:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D2A8E0008; Thu, 23 Oct 2025 12:33:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36A248E000A; Thu, 23 Oct 2025 12:33:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2502A8E0008
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 12:33:40 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8CDA1A0A2D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:33:39 +0000 (UTC)
X-FDA: 84029924958.06.AB8287D
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id D1BAB1C000D
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 16:33:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZVSz3HHR;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761237217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34KjFJt3ZhAK/mtlYPQJkhdtTyQjAMQbPYFNiYB/dXs=;
	b=YWnmb5Mdnw6JZWLrA+DbllijxKmin8X7jFAP/VmELuP+DXIGe/h192P+V1D7KSutlwEoqR
	pa+QPN3z7XfXu55LyNhJ7ZrqzxD+oBz51bUN7fuqzYYlwdIb2AJQxyV7FIIGSv5bl/NKEj
	BSY6XF/sjsVcmlSH51idMB7QufbQE6o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZVSz3HHR;
	spf=pass (imf18.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761237217; a=rsa-sha256;
	cv=none;
	b=afiehMl+eYbIdNMCPqu1BqkfbYOiWWj36RDluoaR9e/67daTqEoshQ7oXO/VFcRtkR7cqW
	mmLQjcrg0DgbruQmUyhfW2sYv/QVHjf8KqU6oWytP/uRhIXAYMAaTMFrblHs4fU0Kz3lMG
	KwG4vmKMoG6jhV1uJuaWjZHTAcnrwGo=
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4e8baad9aaeso217661cf.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:33:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761237217; x=1761842017; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34KjFJt3ZhAK/mtlYPQJkhdtTyQjAMQbPYFNiYB/dXs=;
        b=ZVSz3HHRkf9kjRbCe3s+fKCD6/+BK7yEe/sra+VUZiq/sazA3yfFGlcO4+rsnfe6ak
         kWPNYtXHAUpRN+PcPMe+rRbqOvhEHgP9bV9SCHiQ2M37+wqkzyF0geNIiEYLATkx88K0
         x9kbJ7OPsUsxinCZ89zmhD/E2CURzZuKWmsEivMUMY+xZynEQlFSccb9ca8ljxvaG/UI
         4Bjue97TOQKSyUZXYWxiOcrswajyLzbjUA6mbnhmRV4oL1aOFpvZHcQ7g1bgPv8ntNNH
         wgTJn7ttCXnV5gzRffxCqoNvljzYRB4sud7PpQoXQp5Zrs+u0aiPm2wB5IWECMT4fD4/
         q+5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761237217; x=1761842017;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=34KjFJt3ZhAK/mtlYPQJkhdtTyQjAMQbPYFNiYB/dXs=;
        b=oONT/SmC3f/MxoFRY95PSsMKm85ZFyNoK9mgR8n/w7mxm4LgXYV9QBDXV+w9+T4fKm
         7UuT1f0B8vPx5hdXYbwwGaTCA+CVz8qlbi/Vpm7ZyXn6t8mA8Mc/OQhY6au9ru4IJlmW
         kAZZdhvPwTkewJA1ukbAbviYQKFUBtIsw2D0syR0fNjPMomOAD8P8egUtFCEwLkW7k//
         zjvmJ8GIXypWD1F0JkY7GEESnaHpDixzUoSZAgMdTVDpj7YsxM0tK2NQL+WYjkldSCCg
         AeOpaYHtcB3FUWJ1AuuUPSBOBmU0RYmuOWXyITseH01/mNN8G/4KlFH4YCmjuiZFymEB
         B4EQ==
X-Forwarded-Encrypted: i=1; AJvYcCX9kC0BDmV03upOB9LmOehcHeyO6P7CJdqWW8R4eIAW8Xm3WFkg2FfvgKxkcKCiz2hO4CLRdfiv+g==@kvack.org
X-Gm-Message-State: AOJu0YyQ9gkubXtgihws33zNqo0L0gtYJgvMBueRLvWuKhVC6MAxwJOV
	qWs4P1xlNBC1vGd32/SvEw4stbDBtqpTvDdag1f75XLElp5udG8HJPWFXjr9pIVugULxd6IeCJr
	POU8xhQAXKIV0jZ05PoDcr6PdmH0kWQkigKXdu8VgFNwGZyN34vK9UOHd
X-Gm-Gg: ASbGncurYH76UJ4wsy4ZuCcqRFnDll+sV2oC5meDPIeh+NtErUx6+UAiAqylvahI0nL
	wk9NJyeOZo7sFOz+TX4SZRPMWuBdSfuIuhKCdSXZV+sSlpQfTC9hpivh6JKehyTjJ+uBctV26w0
	b8x90QuUSDhPnDCTkISTj0QMMjUGPbp3YqjhoDVnx8aogvRK4bekcVaq7mqaMhAJl8RmlGcNJQS
	wZ9ow+cqWQ0scrNNz5J3DaD+SZaEXt5k9kT0yXddV2wfcLDMZwq9vIFk7wTDWgmPxjtfAY=
X-Google-Smtp-Source: AGHT+IEM7mYZ78NXvK+x1sdv/m7JPuTp88A9Qp7hIVuS/TfDEeIRvkB+2+hEPKZ2FPvCDkqrRThCKLON6lZXa4xdsIc=
X-Received: by 2002:a05:622a:1f09:b0:4b7:8de4:52d6 with SMTP id
 d75a77b69052e-4eb8fbd2457mr1131001cf.2.1761237216338; Thu, 23 Oct 2025
 09:33:36 -0700 (PDT)
MIME-Version: 1.0
References: <20251023143313.1327968-1-hao.ge@linux.dev>
In-Reply-To: <20251023143313.1327968-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 23 Oct 2025 09:33:24 -0700
X-Gm-Features: AWmQ_bnMmmrbByZ0lhRBo_wxG12-GwaP-6BXTz9QtXdx3T-vv3b7D4iy4Y7T80w
Message-ID: <CAJuCfpFBmmP5_44mYkae=XDb41Z_PyjSJk5oh3F8urc=fELkgw@mail.gmail.com>
Subject: Re: [PATCH v2] slab: Fix obj_ext is mistakenly considered NULL due to
 race condition
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D1BAB1C000D
X-Stat-Signature: doxcjtf5peeaoz3gkzeqnbrd3keqdm8q
X-Rspam-User: 
X-HE-Tag: 1761237217-98508
X-HE-Meta: U2FsdGVkX189UpvARJ6AlOTadYvGrIzUH9EBiFwOab+W3KI+2f3QF7Vrk47/rbRWQFJsqM+zYnfAqzFhPknI8q66WM8AASR1WOwpQyMloY+TDf4XKVvezQOtcHmZGDkb/0adMsY1KvAUijJNSxwtpZQho2LaFyGIVgnDopnhRoZEfgcmBbMjLwx8mvkRTf+CD70cISdlHTUWnenUbxCVALqW5nGcBA/2KSf3uJVxeInsiadoJw1YZjc0M5hFTV73nzQMW89VqM1vfNxflZQYRQsU+qPU6gn1SlUaINBbwgy2Ex0THAji7ijTtB026NVNRr7rVYUPZLJFNhNT7lBHJ9wvb0Yfd5irY3MDOhAfaTHD9xstRxuxIngl5kQ24C52jHRCzOIiSqDYR4R5ZldFUlfsFygk0xDv1MRCMqtpO5aXiKVki57SyAv8biUkwQc2lLGUcD2FfAUb+Vw2AVo2U1F7vUoSx8YSCDt4hr9w7ZXeXLgyGuc8xPIvP3NRPNmjD//Yq5MN4cQhmq4IN0bHyGtzaedCCZWUHNdEB/Hp6HjboO7fDuR0zcDGpNIvb/gX9VzKMyFgji+Nr2SHuf1r8oUP/Qsgh+SMyYZ60ufZ6T8Sa+P3wq8pzemOUhKnrnPbBgJ3Cq6zuZ5eNSPaku3oMUD9uULETeGHNasHkXePQl/lDiXJmWKC6ff802QLMqWr3TbheO0cawMsYEnIs4130042VKfxCFP29Abdx+uSMPPyNbgKr/z0hxMkeO0mxIP5phlmlIUaPz3RN7Xm/EidEpzYOm9xcWyOMsdo+z6/wq60qcz+CN/q9XWpX8Y+vwuMZGLLXRIltRTMB4e3bHz3GZQg33C/XkqGbKei/m0vw9xdsjUDrpA987EpTyPSACzTglVj1Xr6S0Z/XU5RM393MvibEujukt/drqIi5ZqVJTuUul28fu0lCCnBZ1ixCoK/hIz4cBYzVsAXNwBE+4U
 CZdn+Lxv
 TFBmFBXDRnfha77iY/7kNs4ud+mnIP1W/9p68ZDdnPFvDMQRSHBd3SBMCSacw/9I+ORi2WJDhATK5u9jt0hjTm0sQN1PQRbRDsw6upWhL58DXukZ82kUoDAMUvKzNS9ogG6MbSge7iSHq0i5ex+EFFVI/Pyk506TdoDJvjsNtMqi3o0F3bBi8n6CMaeTycH0tXI55M70cg8746mj8EVrcJw+p0taNtp/q7ARoRXAGVABZObQopow09hEuI+NlM8K4fJ8mGu70kgysLBA35xUbelZLDBKyTiowMa7t6qAUQlKJDmaw60wMIAWpp/W6uWZMo8oK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 7:34=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> From: Hao Ge <gehao@kylinos.cn>
>
> If two competing threads enter alloc_slab_obj_exts(), if the process
> that allocates the vector wins cmpxchg(), and the other thread mistakenly
> assume slab->obj_ext is still empty due to its own allocation failure. Th=
is
> will then trigger warnings enforced by CONFIG_MEM_ALLOC_PROFILING_DEBUG
> checks in the subsequent free path.
>
> Therefore, let's add an additional check when the process that allocates
> the vector loses the cmpxchg()
>
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
> v2: Revise the solution according to Harry's suggestion.
>     Add Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/slub.c | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index d4403341c9df..d7bfec6c0171 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2052,9 +2052,9 @@ static inline void mark_objexts_empty(struct slabob=
j_ext *obj_exts)
>         }
>  }
>
> -static inline void mark_failed_objexts_alloc(struct slab *slab)
> +static inline bool mark_failed_objexts_alloc(struct slab *slab)
>  {
> -       cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL);
> +       return cmpxchg(&slab->obj_exts, 0, OBJEXTS_ALLOC_FAIL) =3D=3D 0;
>  }
>
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
> @@ -2076,7 +2076,7 @@ static inline void handle_failed_objexts_alloc(unsi=
gned long obj_exts,
>  #else /* CONFIG_MEM_ALLOC_PROFILING_DEBUG */
>
>  static inline void mark_objexts_empty(struct slabobj_ext *obj_exts) {}
> -static inline void mark_failed_objexts_alloc(struct slab *slab) {}
> +static inline bool mark_failed_objexts_alloc(struct slab *slab) { return=
 false; }
>  static inline void handle_failed_objexts_alloc(unsigned long obj_exts,
>                         struct slabobj_ext *vec, unsigned int objects) {}
>
> @@ -2124,8 +2124,14 @@ int alloc_slab_obj_exts(struct slab *slab, struct =
kmem_cache *s,
>                                    slab_nid(slab));
>         }
>         if (!vec) {
> -               /* Mark vectors which failed to allocate */
> -               mark_failed_objexts_alloc(slab);
> +               /*
> +                * Try to mark vectors which failed to allocate
> +                * If this operation fails, there may be a racing process
> +                * that has already completed the allocation.
> +                */
> +               if (!mark_failed_objexts_alloc(slab) &&
> +                   slab_obj_exts(slab))
> +                       return 0;
>
>                 return -ENOMEM;
>         }
> --
> 2.25.1
>

