Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E63CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 19:44:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFA818008E; Mon, 27 Oct 2025 15:44:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2AF8000A; Mon, 27 Oct 2025 15:44:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F018008E; Mon, 27 Oct 2025 15:44:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A09F18000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:44:58 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 315F1140216
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:44:58 +0000 (UTC)
X-FDA: 84044922276.25.6FB15A9
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7A00C180003
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 19:44:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="S+VG/XsA";
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761594296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JptCkBXsHjZlBBzRnLae/mJJEFh3aB9VIqvSzCz+zbA=;
	b=Hr0uz+U867RgIZvueAJltXVwwAxXu7wKNDqpzjHjJvYZRyflaW0gAfPK76zddHoz8R0cV6
	euQgOAHLP56bVFOlB0zL72cpyNtmoQgR2EWhwzGK8dsKgBo3wOrXvJeNrQmpTrymQ1JZD7
	Ob7kqle4tEqwefLqXVdXGwYudHKJ8iA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="S+VG/XsA";
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761594296; a=rsa-sha256;
	cv=none;
	b=6k6qAy3Kqb6QWbaeNwZJNe5dIE/IC1GDyc0a1EwEWp6FoMxL9ccY19EwcXmwUYceizxjAl
	LfD/Komh296vQ8OIBA3M4JBlrhTfOM3akveREwt/n/4hiw/kDPVckxC2sRoCvQRurFY24B
	SjTX2RC+vehgBTgNpEYYQhbVfibM83k=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ea12242d2eso12561cf.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761594295; x=1762199095; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JptCkBXsHjZlBBzRnLae/mJJEFh3aB9VIqvSzCz+zbA=;
        b=S+VG/XsAwPyhbQbAxmGQYouI0P0ViBfOEl0N5p08/1+ZkVA70jub78ODIzqeYiz5Mj
         FOWAkC8iehBFr9elUKEX/vy65Zs94R5+EnOxRgG6j+rUY5T09Bj8GVzQOfho7wJD+3tW
         egqWFdn7pMqBPhcigN7lTojte1qGcYeNtZKlkVYQM8xvENLoY9TISZMwbru4kjgK8HKM
         klUkUaqlSI2wn9BzDkD0TWVJ3gj35qRmF5LXKdMK75mcy8ExkLCaXlh4zB5ZN8kQBhJW
         dlfTE+8jZxteJKwM88aGwn40pdF70WTs+SDpzwrEsQtWRB9VDhBs4WjPHxnxPriJr2/s
         Uskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761594295; x=1762199095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JptCkBXsHjZlBBzRnLae/mJJEFh3aB9VIqvSzCz+zbA=;
        b=NUOrmr8/2igLCfEtmJVMUZKiyok8Rx7gYqJAByLWdccticnGbQHLVG2sQwdxIbkIXH
         Ao4Plw4FKVtn/SUyoeoLzdp3byyjrioHKZRP40uvxJxIBBkdUYsspZKmTGlOLCZGDOpI
         czii3a1JgIPwr2RCUc1WUbneZXmBypbqXEiWw8liY/Sh4+NL9g5i/jN9j4k87GSTByh2
         cPwGJWep+bU8KZTwDZNBAS4Y8JMgRqoRDHo1n1T5vRViQOE3c98dPgV2qXAu/ty3PJXu
         0QtpGt8M4umOyJcAQbde3RtWfqm1pdxxVqKhDyaz9Rm5/AaLPR80uohv0uFAbU09+3SF
         GodQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+Pn1Uy3CFTFSHD6HkZsUidGIeULpgyWvoWHtnxtFQ5Ie85RYJcDlezWX9y7awFtZfhKxGkS+KhA==@kvack.org
X-Gm-Message-State: AOJu0YwKcwFmECzvJRd0vuqLGRLfW7NQ9MzCvS3X5k2WikQ+o/942UW9
	aGPDcMUqFfTiJ1grvqrl+2LBF7plEDd+UFT8NzTNE6sX83LFym2TJIi/xL2VbcIq6yBRTvApC4K
	Ry200krxFsYm+UXclneEGgTMEbyOBW/VAYUWaRLCo
X-Gm-Gg: ASbGncsA7zHRK3V3QpebijBXlPUBM5jXwTJ2YObEFDKta5LKNJKupAjMgijp5EsEZh9
	FelcAoBhx98Yo7S/vAkPccJ50O6mFgJbYHhxL6mjBZKs0XpRN5IJvEnKHQgKHjF1CFw5jvTw+Iw
	dPj5PK8eoZeWejDPY5iH5fvLp//faoheqqbjHzs8CzH0EqPllcnkFPzopAsN6Y5X8ah5CKM8qOr
	INXdQcupdW0dElTwkE6mogfGU6Yz/0dl2dWegdshWNZ7xnJNpEO0XWNP/Q=
X-Google-Smtp-Source: AGHT+IEDRWjZQdkoQn4JOV8IDsTmIW0+zMctax/00G1Ot311AEaKU+dlsGs5ioPlepPWCTlzahP9mAEfzBcRuEnpQFk=
X-Received: by 2002:a05:622a:145:b0:4eb:75cb:a267 with SMTP id
 d75a77b69052e-4ed08f87205mr1488091cf.12.1761594295008; Mon, 27 Oct 2025
 12:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20251027085214.184672-1-hao.ge@linux.dev>
In-Reply-To: <20251027085214.184672-1-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Oct 2025 12:44:44 -0700
X-Gm-Features: AWmQ_blDdOyc-tNIULuWANg5xz4Mu6a22Tyq-1C42xlGGDpEiRSKathUjbCucF4
Message-ID: <CAJuCfpF+0ok85A1ZhbptSzrB-X6CUj=TMj9ZvwzjV1tO5PqFbA@mail.gmail.com>
Subject: Re: [PATCH] codetag: debug: Handle existing CODETAG_EMPTY in
 mark_objexts_empty for slabobj_ext
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hao Ge <gehao@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7A00C180003
X-Stat-Signature: dhrxnfydichdaaspmpot6s6d16nohs1n
X-Rspam-User: 
X-HE-Tag: 1761594296-438152
X-HE-Meta: U2FsdGVkX19E9/+I4xZwGw5dkpA9KLMJmc318BZkYs4ws9IrpKNCYWr0JEdpUVStqZyUXfPIKWf9d/FJq14A/9CqCGxSn//5W19vijgpNWCLbjQuR6PTLb22oLLcylTL2mVaIMRikV+4PTbP2lYRA/x3oqFzgR8aYhAOZyaCIR3eJNnM4V6T/4405s4f9Myr1t1x0vIFawb0vachEp0bWyq7e9fcPAgH5wPWdDaYmodx1J5hZdLUB7dBcDKVjR2Nrh+KJi64o63WJP3QyTmimXoYF2bYEFxBCS11YIFulEC/5IcQjzvEf7dCeDgrGuJfviK/vP9ZNAkSX95TL73DEdIlp1M6eMumJewMJnEfwlLZd58QKqDE3+Tru4FetgdjAsCo4jIkcgu15YMs35/h63UgfVKHA5iJe7iRZZnIQV9RAm/AfoaecNCkCNXdlSXP3wU5laAJOZ+X/y9QCVSG4Iko4t9CsZvwO2BDZXSLw4NmeKzLw7SAyc9BCKCLfmMIlAK/STAssJerZED+5qy9yDnd7ZgMInLBD/MoowGcF2nrGwA39Tgz1ngnvX3fFk2oK2xji4PwhnWq4bgH6VwxiCDJVadO5Y97ONcRUXWEvwXtBvvG32KEAuYimGVPd4BdgPM3w0FL1RUMn2zjFjIbk1k5OFyyTKicOmgkn954NKPwjNjFZDhNWoFibidAqMz0hO7Zpch0YmgMmNZR39sdkmY82txJDN9zRZFS+amJ0ONTwRRYxMJAvtyjATn2Wbg5ua/iNdptAwn4dDa7Rt8wlLXPvN+atjXM0BHPRQhkSL+1kCYPSvF5Le4PJYgLmjooQvFlHtlL6el8uemp1ORtKH+EuYK22Ea1xRT3jo4OITRRyK1mpaZOYVfTv7yTrr9TEgruo2X3qIhLHGNZHu4e4oLOhamlQNwNTuFFeD3lX5MSiC11Utxv2tJyhHnWlrNDLuiDpLuY6JY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 1:53=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> From: Hao Ge <gehao@kylinos.cn>
>
> Even though obj_exts was created with the __GFP_NO_OBJ_EXT flag,
> objects in the same slab may have their extensions allocated via
> alloc_slab_obj_exts, and handle_failed_objexts_alloc may be called
> within alloc_slab_obj_exts to set their codetag to CODETAG_EMPTY.
>
> Therefore, both NULL and CODETAG_EMPTY are valid for the codetag of
> slabobj_ext, as we do not need to re-set it to CODETAG_EMPTY if it
> is already CODETAG_EMPTY. It also resolves the warning triggered when
> the codetag is CODETAG_EMPTY during slab freeing.

I'm not sure what scenario leads to handle_failed_objexts_alloc() and
mark_objexts_empty() being used against the same codetag reference.
Could you please explain the exact scenario you hit?

handle_failed_objexts_alloc() assigns CODETAG_EMPTY to the elements of
the obj_exts vector while mark_objexts_empty() assigns CODETAG_EMPTY
to the obj_ext of the obj_exts vector itself. In what case do these
two calls operate on the same reference?

>
> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mar=
k failed slab_ext allocations")
> Signed-off-by: Hao Ge <gehao@kylinos.cn>
> ---
>  mm/slub.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index d4367f25b20d..cda8f75b72e7 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2046,7 +2046,17 @@ static inline void mark_objexts_empty(struct slabo=
bj_ext *obj_exts)
>         if (slab_exts) {
>                 unsigned int offs =3D obj_to_index(obj_exts_slab->slab_ca=
che,
>                                                  obj_exts_slab, obj_exts)=
;
> -               /* codetag should be NULL */
> +
> +               /*
> +                * codetag should be either NULL or CODETAG_EMPTY.
> +                * When the same slab calls handle_failed_objexts_alloc,
> +                * it will set us to CODETAG_EMPTY.
> +                *
> +                * If codetag is already CODETAG_EMPTY, no action is need=
ed here.
> +                */
> +               if (unlikely(is_codetag_empty(&slab_exts[offs].ref)))
> +                       return;
> +
>                 WARN_ON(slab_exts[offs].ref.ct);
>                 set_codetag_empty(&slab_exts[offs].ref);
>         }
> --
> 2.25.1
>

