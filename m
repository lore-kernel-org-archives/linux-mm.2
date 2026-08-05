Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B92C55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 17:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C326B007B; Wed,  5 Aug 2026 13:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BCE86B0088; Wed,  5 Aug 2026 13:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AE136B008A; Wed,  5 Aug 2026 13:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C90F96B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 13:47:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 34E1D160556
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:47:56 +0000 (UTC)
X-FDA: 85067948952.02.55AA9F7
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 417D214000F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:47:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T1UKQ9Aa;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785952074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gnWA/DuIIokY8/eXsnQhd+bhj6lSNL2Ukz/5pFHWlTQ=;
	b=q6gGb3OKjEa6ErUR18LEs+zoyT8fVTvtil9BCKErsYk8hhaNUFl6fe/NLBcTf+aNhVGlUy
	PZHCUip5nl3dCCRvsKMAdp9zMXN4PkNyrzcgOUe7/KiLf5Le8qtYG+/ndeN9idOb4/VS+6
	lCK/u2exsNHiuOnbzD0CXwNbo6sz33o=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785952074;
	b=bpyHNC6HaRch6YJo7g8kP5ZzWYVgkcXzN/jcBhmaAEdi4MEwUIMtNt8yMBK0FnTWg2EhIV
	ecUNdKSDy3p9jMM5sJQPWBI7s848OPfbvcWEIJp+6M2C68bxvhfr0W0bA3TtG3+OP8tCDf
	QSwbq2pr5dxNWTxil9x/QCb8n++PLuE=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=T1UKQ9Aa;
	spf=pass (imf23.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c10ed63c0so19271cf.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 10:47:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785952073; cv=none;
        d=google.com; s=arc-20260327;
        b=fr4TIVyrmLGvOVulrwn/U9nYqflr9pj58h3JSeAfQ3awscsw30uYMnTgZggF2J64Ei
         wcrpTxG2F5JBKr1KhT5pjued64JpNdiURo4GP/pWSZHQJCisRpIUBbslA+Mih0m9Nf8p
         ozkKZv6rmuogYgX8q4PNntiJZbnqWN+amxt0J+m/+0U2aEe/IXGXHDzsgxLkVyGO/2uP
         VihkfMGM0uXGuuKRfs0Cs8+gsJhWq5C39Ej93mC+/yu4jD8qAyggFpgDVhwdkEareS8z
         yRHv29GxpJsCmccNHb33uM4YSqAc6ZN2vVp+d3eWaacXl5m0s4C9PCN9cuJWinnWzMir
         HOMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gnWA/DuIIokY8/eXsnQhd+bhj6lSNL2Ukz/5pFHWlTQ=;
        fh=MZ0+p3LOFPkzaBvX8fQpOMoXUcGQJUjcEID5QZrNqCQ=;
        b=heTPaTPRJjo0ZmYrwuqkEJOFSrGfzopTfo4gsXqqvjcEucSPUnYgn6VP+YFDsE7TY6
         pqLUcFdPph1sJkkLQ5p4JfxuFw4SgC7yVWi61DIjSCdaBMSenVQnRqYkbxx2GGMD+UAH
         JlrnnObmkcSrlIsGS8dLjIzuNP7pq8qYTJySW3O0ld4JuOqA1w/Xc+B0J9lTteVvAG8U
         ojYvU4kt9SfOzbNHp5LAFvSe5LiW0dgrw0k3enIGKWQglPV0cXo5sD/D2LJIepwjEakX
         GYU2KTmUPu5CvBh4BVyxt2eRHk9KOv5D/17e+nzQ9Rl06dZuQqSsL7Xdp5EMJs0gMbTW
         WmKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785952073; x=1786556873; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gnWA/DuIIokY8/eXsnQhd+bhj6lSNL2Ukz/5pFHWlTQ=;
        b=T1UKQ9Aa5sYlIQyiUR43IQxtjdStb2dZhyPj9LONEuOpfoirSpCMy+1oHJlPi2ch+t
         6HmLbuMN8Jr1DL6t0ittA0wMpsFxjMF4n6FBdc4i5Yn3mcjbk9GGqV/7IT4fO1xYD/Bw
         z5WoZNJE61x6SpuEpUKIW268PeZTFS2N8xABRJJSdxV8inFg9EJ0fGB0r95xfAbgFB1v
         3N19AfCK64Oy3hmHrqukeXZ48ghPVTQgizE8syjeKskcte/lLniisyw6rjKWtII5yCxV
         93KCxRjqgqssM4h0wmwqmOQ3czUJ50jeBHSOn3DSRYUIyqD1gwj7CRK4Q603/JWa8jL+
         IfPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785952073; x=1786556873;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gnWA/DuIIokY8/eXsnQhd+bhj6lSNL2Ukz/5pFHWlTQ=;
        b=i3p/l/Wufj97iIegjVZXOVL6BJ9/dKA2ZbmdCn1+c9snXammsXakjn6Xq8n84rRDZu
         rFrp/BTfM2FEnY1ovuIngPqCKvEkLy3KjTMKXe0489nXbemEfNrpBM5RaP8Rdi8BqrcY
         aCZ+3SGGpY3soQ2xxu/42Y61lZe09l+NW/IuTzSw8Vxr4/KRuYj0ayNqZX1HrWnK/AKA
         6+J1rl1i2dpW6G09OBAUK+31AuQpvYpezP6rIV3OPWXZfL0eXJhKWqdaYyL58lSKpQPM
         3zHMcoNiS15j3g8zgA6ti7HhbDWRjHXfeoN/IGYVi0Q/GbUu1oJzhaWDG98mEtMA6wpe
         Dalg==
X-Forwarded-Encrypted: i=1; AHgh+RooekKEERzz6Wpnm1p4xqPiEG6fycyDrxTk0Uy/scIg80EryrknLjaMA9IVjyP4AV3N8gVgZjfzbA==@kvack.org
X-Gm-Message-State: AOJu0YyjpUxpnJc9HGyABVA1zmbaWWo/B6qA248jOHG+gdCgBI15q4gd
	bLjNkDmgXSCM+69f+RUak+4hFOpZead594GAt2svQkrfaAgqNx3O/O1cuwBEY78Sf1qAjG44AbR
	YXeRkjwAaJIculx8hOL1OnV2TJAQztFSr6gW952Gy
X-Gm-Gg: AR+sD11ch+JCloSOxJM6PYC05sga0qHGh88CFDkLDfKnhdyO42VZhH3HxYgf9DdSP0J
	BkkrDg+E61re8G/CPZksnfIj57uiHXXz5aeJ2BGbDNjQgscPxKHdjgVplB2bZeiC8269y+SzFNA
	hL6hn6nFB7aFopf/DAdJWBtB0Pec2EUQoGuVcwes2salnq8CVk2MuondMJHWaLcoTNrHAwP4/Ve
	a2qFIxbRF8VN9PB5U3o8DqtuySr/dcUHnEliLxekalGsIv96IUn9Ol2XIQz9oxTht+3XVom+LRl
	7dyGToXArbUP2EbhfGoP2Hi4MATliKFpDxjmfccZNpFX0ogwSZVaExStnGZb1jKsaVZbOL18XVY
	=
X-Received: by 2002:a05:622a:22a3:b0:51c:935d:8d74 with SMTP id
 d75a77b69052e-52cfc109122mr792451cf.9.1785952072535; Wed, 05 Aug 2026
 10:47:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260805090633.141001-1-hao.ge@linux.dev> <20260805095505.1c2cbc150441cb20a74ba9bb@linux-foundation.org>
In-Reply-To: <20260805095505.1c2cbc150441cb20a74ba9bb@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 5 Aug 2026 10:47:41 -0700
X-Gm-Features: AUfX_mxKiYGwyyUljQnBwrH-ct4w_9C4kkNu_d9Bab_VVjkT3TZ1NCyG0rHLGmo
Message-ID: <CAJuCfpG_XX-Hwy=TCrJ+g6yiMxGXLB=LvnPN_WLP3WQktNZMbA@mail.gmail.com>
Subject: Re: [PATCH v3] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Abhishek Bapat <abhishekbapat@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 417D214000F
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: go16kppnphhuu6g8697ptqpbep3mujw4
X-HE-Tag: 1785952074-396625
X-HE-Meta: U2FsdGVkX1907Izzt4qCS5B1rPjDxX84kMZT6h6AbTZXEbGZioPrUiig1ZxsC4vuPHxPyreGzDI0lckzxeCRx8SCvj4SSyOAygwdSp3u7LhLLWASRtAT6apBDEzXAkm0Kxxpf0z28FZ6molPz/BzZwTV2NhEyPDA9Pkfn6uvOxU+eHfaBFn2nMC4dygsnSnlhO3BsXSAhJ/03ZTD3u1RZrjgonaPsqC2SYiwkn4fuLB2CAxFJN4McogdrjlLlgwHTprxlBxn+ziIZNDxeY1H0O4/KD9jYJJqdBe0mk7Oe9WmHVtA5jT3FZN0KvffnwJ3ugh77SMDBjh4zfCQYX7m/EgMBgvyODqDMMXArAhF0AnzPCi6hynuapnGSzATHCjP1VM099R1rCJ3iepGlvcTaFagilryjRAqCS4hQ6dusvOaFBE3DpoyB3108zoXMJJTKSZC0w8+etgZQoseQzduCqwlTCkjUGpwkCXWQ8JrbyVAEs8w5phxU8EOxuR6EzMMjM0e97N2rCJ8Z602UnqOe4oQ2Q1AIZ3d2ZfHsnoQkkzpC2igAsWXlyIwwZ85zYj84hFFFEGQWTgizU8TZFKyk2Pjmu58cnHvH1G1S3sWgzkawq5MyQVqLM9EHjYatoKFg6wa9FsIYurNHbp04tyfHcpD6fykgMkMu/HxPsupa5fKe7ydZMVZEPtq7sCGbf7u3Y39RLFEkbNO906TyPdL/xi24vH/DILfLRW/sggpf2UUg2w1YsAWfD1rxVQzC+N6Z5lUMvyk9cJReP/Je+nzLJ6KhyHd0Hqa3hS0xFfV7AdI4Hh6TZiCFue9f9yDpgETSblUTpK3bOzGZfrOBlTQEga8rtR3t5gG8xlErC/p0B/0ZN6Ir36Gu0OhLXH//MDJQ1X93TRHR+6bAWHswY9AXxrxbCImdbOrhp580ZJwLJveXo8Nk1ujb4p6+8UpLglTYADA+vJi63MbDD/FuUn
 jLvXoJbn
 1I5KweNXqSI6IgvXtvxYtXyV0473M05Dy2cHxItVvJ/0VuZpuOgsvlLKoE7VrsX5U/LeaC7cAXKKQoYolHDeCibp7Yiwe7prKQ2AlOG+cc9sIZ7z15bJt2jCyNja6inpyjU8A42eiH/YN4shfClXQmJMAn1TI4i0/ihevpcD3YiOhHZE9UZclDemvnJ46zGkFFEETk69hfxo2054gJlcOEFDUvxIAxRMaMBmDouQfaEeuBhCY3IpWFdk8VpUmOsUaFOKSO96GzRxF89jIBlcyEV3vv9S9PxzreXf9vy/tTGkq4pKFeCnvLe70XAqIIlgXHBAUqRDP3pXR1YReqJlsJeeakebScpFfQ3SV1m83hLXDo43QZX4c15db86EdVrdkiQAIpkFEnVWjrAX2sFwTUEevg7ASa4KoPNOx77Q+IqAubhnQNIosYikHw1TnC+VhW9GeRxL0h868wAY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 9:55=E2=80=AFAM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Wed,  5 Aug 2026 17:06:33 +0800 Hao Ge <hao.ge@linux.dev> wrote:
>
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
> > Remove the mem_alloc_profiling_enabled() guard. Also return an error
> > after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
> > the mapped pages would never be reused - shutdown_mem_profiling() sets
> > mem_profiling_support to false, so no future module load enters the
> > codetag path.
>
> Thanks.
>
> AI review points at a cpuple of possible things, one pre-existing:
>         https://sashiko.dev/#/patchset/20260805090633.141001-1-hao.ge@lin=
ux.dev

Yes, pre-existing issue can be handled separately, it's not directly
related to this change.

>
> "Does this unintentionally result in a denial of service for module
> loading, preventing critical drivers from loading when they otherwise
> could have just disabled profiling and gracefully continued?" sounds
> pretty obscure and I doubt if we care?

Hmm, I think Hao considered that in his previous version, but now I'm
thinking we might be able to handle this more gracefully and not fail
the module loading. When profiling is disabled
codetag_needs_module_section() returns false here:
https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2822,
so if we had to disable profiling, we could return NULL instead of
ENOMEM and change the condition here:
https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2825
to act as if codetag_needs_module_section() was false from the
beginning. IOW code at
https://elixir.bootlin.com/linux/v7.1.5/source/kernel/module/main.c#L2822
becomes:

if (codetag_needs_module_section(mod, sname, shdr->sh_size) &&
    (dest =3D codetag_alloc_module_section(mod, sname, shdr->sh_size,
      arch_mod_section_prepend(mod, i), shdr->sh_addralign)) !=3D NULL) {
...

I think this would result in a better handling of this situation: if
we can't fit the tags anymore, we issue a warning, disable profiling
but continue loading the module. Hao, WDYT?

