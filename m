Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB23CCD1BF
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 03:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A8968E0030; Tue, 28 Oct 2025 23:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880618E0015; Tue, 28 Oct 2025 23:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797238E0030; Tue, 28 Oct 2025 23:23:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 66A528E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 23:23:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DF5991406A0
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:23:05 +0000 (UTC)
X-FDA: 84049705530.07.9E26FAD
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1457EC0006
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 03:23:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MNwwIhly;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761708184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RZF5fZYNByvvmd5+XtP+S5jRgK5TgXHSEBZH9+I4nwY=;
	b=Pyq4A8N+IPvn826HroLRuWdoiqsLkuOvsTvRT1AF6aivwxS22AXJxVY9ANLuiPe1YhNW1t
	f0rBClpofqNEgHyv9SS3V3VrkFSPfiQ2WWVnxC2U2ccpgQmyhy3apkvOMpZdxhR0G2ioNx
	n0+1Kgo8oZ/pKA/Yg5PfCoMHsGIhvVI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MNwwIhly;
	spf=pass (imf22.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761708184; a=rsa-sha256;
	cv=none;
	b=inVsOjSFGA/XzLZmf8vAsnpCBVtHMdO1th+yqmy/0Etaz8nzfVuML/q4B9FzhYydhbaOgf
	7bA2MTDBRMFi0u9idhVt6s74su7iynoICnHETl2CdsuaBstN7hsMm51dW1+SEHg7lmU+Kn
	ddX++rVBdQ1oxrDSoXs7ZZRFBMj+sI4=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4eccff716f4so192921cf.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 20:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761708183; x=1762312983; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RZF5fZYNByvvmd5+XtP+S5jRgK5TgXHSEBZH9+I4nwY=;
        b=MNwwIhlyrPiHB45l1Dsl2uAzyjt+mIz/2LumTOTejg0p5S0BnZWyGukX4iCc3xYwqr
         O0oJw3Xz6dN04yofCpHXZhbD6I0p2sXi9J+N1Mn1X2psNSlsjJKLsRANAAlILDy2DBNW
         lgpy4w7sykSFNhHEC561375HPvaIZOTZuN50az9LZGhvudZPdk7sa7FcNSNfJH30+VyU
         eT4ZCrzsRMPbhJNxymWqtYdGR+fpfC8sCSrxG7j6RibpMLkFaswsxdZ889mHc6mP/RMQ
         tQpM+4w4dMtAezfHt80nQ9TJi1g6xU0Hp28UWZnMJJ6BZPAEe5uo1ktOEMlif1q9lMx4
         zDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761708183; x=1762312983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RZF5fZYNByvvmd5+XtP+S5jRgK5TgXHSEBZH9+I4nwY=;
        b=B6h7ZROE6QHB1vVNPJWeQZNvIxqNE2pSMg/mHYEbe4nS38aBDu7La+3un5vJDGqjSD
         IrJ1ibqsoSvfabhMEbPBAA/M4NVghnR/u+wkHTETukpNjSYE5+O2Hha+HbiMUaE3UKfr
         kKFG7rS3F4hZ8WbRFIRjZDIGOTES1S8ABNE2VZhjvXOGTF/LwUqvwC7rADfcKFR0PesI
         C+ZpB7c8jBj6u+ThV9eAMTalCMb5ueAfsdXxzRMyD7HmYKuvr7sHILPssfS7UiuaOn6H
         XQVpYAt/kNPr6LyiaM6QCnQ/iKHeYFGuJlOzDJWZQXwA8/uli4bzUbxOqzEh4UU7iE/U
         SvEA==
X-Forwarded-Encrypted: i=1; AJvYcCV0frSfBKS49aQ/BRqS9r/HdItRQtgC3Lw+NGTPud20fzLiQMzara+xDWKuKitRaGpmiOv2Is6bzA==@kvack.org
X-Gm-Message-State: AOJu0YxwyAxdd6hIHFtUuW4CSp5BAXNXvswwLFWVxjyW4NHPnCj5Hyw1
	cvkl7ycm8P7Aj9dBTX2mL8LS2S0SL52NbgtbSYQNzd4ho6au8J2x2Vuh3lDnicrolvyyvaDcf5y
	hF9JuOT5PIISLe/oPQBHgRWdqGZDR5M6E2GqgOG4Q
X-Gm-Gg: ASbGncv/b0Q3L+pYLBcHd+05Dsmf65z4/q9dRXbCzD0nzf8mkBxfASd6lcupD18Lap+
	SbD4Hwp8nB9Fcd89lnKsTb23Kol7zKPcoKsbBjx2+gz4q1Qhc5yZzjIEB6AJO8Q108VYaqFg51c
	5hL642n8lNz/bLoiQCw6aLUXG60iJsB1lWBZrDxtxbJYq1/+Wtit8ndi57JJa0eFKY+33vXQZqo
	5c1pfDK5IBauzRXjSzAcu94UkShEjTrX0jJkGWctZHmNpggaDjWh03UnIgInw/bDvkR3FapBoXf
	dPzX
X-Google-Smtp-Source: AGHT+IFt0fdOZNflVxQJh5GQqXSyDE6yhX4j0HA2jB4qnG67bFoJTwJaZpXpVeBGRX36ahJHPN1YN0/KOLD2ewkP1+w=
X-Received: by 2002:a05:622a:53c4:b0:4b0:f1f3:db94 with SMTP id
 d75a77b69052e-4ed16580052mr2297051cf.5.1761708182803; Tue, 28 Oct 2025
 20:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251029014317.1533488-1-hao.ge@linux.dev>
In-Reply-To: <20251029014317.1533488-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 28 Oct 2025 20:22:51 -0700
X-Gm-Features: AWmQ_bnWQlp_hgmAQPXCvvIDSyvF6h29V3Rm7M2r8OKX5bFOVKkcR6boUbLHCuw
Message-ID: <CAJuCfpG+bgLj6-GKNs7K0vRi7PsQvayTvwfyd+tFSnDY3muDGw@mail.gmail.com>
Subject: Re: [PATCH v2] codetag: debug: handle existing CODETAG_EMPTY in
 mark_objexts_empty for slabobj_ext
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hao Ge <gehao@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x5cch8oun3xes9gi5u9ahy6j91dcp1at
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1457EC0006
X-HE-Tag: 1761708183-727133
X-HE-Meta: U2FsdGVkX1/227j1h2kz9kSM8hKs4YFzvK/mmlTdJVgzhbhIIrFvCW0X+oMcOQ8ZVK2VninVmLeBzzKHcNfRZs6Vt9LDQgZELQweYYIDofK6sRsVQeq3djkRLnU71KdlJI6+LxRVdMKOuhenUXYAn7MpZFTutvNxRk4A0rCsjbYAwnuOttm+/PV1tIIh4beYM/NcfRgfc6auKOWlEyshBN+jEpKAppyDW+yhmsc8P3hDVjy9Jl7QE6/aOwH1Msjit++lrQa8Sn8/Krp0UbPwXJiTDORLwhaBrqIB1NaYl6oxHNLmXsrELJ+t8ny38EuSkgzaoav7MFkdkFFtoHfdNuh/WBtLD7eX9yrTlmcgKhTZluK0o4EYo9LUNBKX6W+uWQ78bCbpvR1ApNGkCgacNJBDBCDCtiMrbXoL7uTG3x2oTnNRbXTiDqehLc3jDEjFTfS9CMGuVfrBXuhRcPL0CBNxgVmqRGeH3ARqWICeVpwjSgReQLVhWQNbp4Sge55sdNzBEWOF4CfHRNn0jqCNVuO+bt2X9cskQ9SM1l55yy8XMsbk1f2NgwYkLLzQ6LPeC8IGxm3KjgoJtMqq6pTttANs7QwTiX1fzbfG9s3qgUW/1D9MrgWAXJRauF04Q6aZgcr2/XzXTIxe3T+FBEIJjaKJnUK0aO9YKvrSx5x4a31vzIEPxlcK2F91t9+xAodGWbs4fIEBxX5gCs4JearSkjywynjqghH5Ow3lFAkr68l5UXhu3EzR6lVN84cqU8v8qX1heOkDQd/P07SXOk6Z8VU115yEm3B7fneTfBroDrG0yyRmv0Jdo4NrDYx+m/H4tXm3m13t/QRkOdzjl4yMSrGusAHOQSODpIQVcsxkrujwgr9QH2RducQn1pSlk9uAGF0g8ROoS/69kLagBtVZ0Pcf4T4TRqcqlu0ULTUPuGywtCQvwo94uXCJpafQwDbGWoQ75xKHC/pAZZmXflk
 fTWQM7/s
 hAy12G0IL1NnnvzAFdwvLtpgzBPH3JX8KUJ7CowT78t5rUCaQcu9qhX+woHejNWl1PO9DqTV/7qhxK2z/aFIuzpW5P7ibIV1llu5Tcz/DxbOw1C+hEfd24WdkTRethRPuspp+7tZyHfrSWFhxAUXHSp2bPr4NXu8sHbirgRFeIvIYqqaPEmTOUoldA8/SlZX87viJmfEKbuTTaqCBqthb+rALQBIH76X+ZcWsBhX8Uc9JG/MSUKSviu4wjXEX2RvEuJlbxH4nXB1OLniszSguTQiT+ka7Tnl5ntqb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 6:44=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
> From: Hao Ge <gehao@kylinos.cn>
>
> When alloc_slab_obj_exts() fails and then later succeeds in allocating
> a slab extension vector, it calls handle_failed_objexts_alloc() to
> mark all objects in the vector as empty. As a result all objects in
> this slab (slabA) will have their extensions set to CODETAG_EMPTY.
> Later on if this slabA is used to allocate a slabobj_ext vector for
> another slab (slabB), we end up with the slabB->obj_exts pointing to a
> slabobj_ext vector that itself has a non-NULL slabobj_ext equal to
> CODETAG_EMPTY. When slabB gets freed, free_slab_obj_exts() is called
> to free slabB->obj_exts vector. free_slab_obj_exts() calls
> mark_objexts_empty(slabB->obj_exts) which will generate a warning
> because it expects slabobj_ext vectors to have a NULL obj_ext, not
> CODETAG_EMPTY.
>
> Modify mark_objexts_empty() to skip the warning and setting the
> obj_ext value if it's already set to CODETAG_EMPTY.
>
> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mar=
k failed slab_ext allocations")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Hao Ge <gehao@kylinos.cn>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
> v2: Update the commit message and code comments for greater accuracy,
>     incorporating Suren's suggestions.
>     Thanks for Suren's help.
> ---
>  mm/slub.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index d4367f25b20d..589c596163c4 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2046,7 +2046,11 @@ static inline void mark_objexts_empty(struct slabo=
bj_ext *obj_exts)
>         if (slab_exts) {
>                 unsigned int offs =3D obj_to_index(obj_exts_slab->slab_ca=
che,
>                                                  obj_exts_slab, obj_exts)=
;
> -               /* codetag should be NULL */
> +
> +               if (unlikely(is_codetag_empty(&slab_exts[offs].ref)))
> +                       return;
> +
> +               /* codetag should be NULL here */
>                 WARN_ON(slab_exts[offs].ref.ct);
>                 set_codetag_empty(&slab_exts[offs].ref);
>         }
> --
> 2.25.1
>
>

