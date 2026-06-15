Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 909ABCD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 04:49:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBFEC6B0005; Mon, 15 Jun 2026 00:49:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70756B008A; Mon, 15 Jun 2026 00:49:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5FD56B008C; Mon, 15 Jun 2026 00:49:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5B1F6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 00:49:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4CC4E1C302D
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:49:07 +0000 (UTC)
X-FDA: 84880917534.22.D3F4633
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf08.hostedemail.com (Postfix) with ESMTP id 53C28160003
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:49:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="L1G/FnHI";
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781498945;
	b=gWFmbCUPJQbbw0suCjCAGM2SUK8ma+vdiuTdrCaIfoake1/++xrUs98aznlLxhXd0uWox+
	RVNch3WC0Z2g6o1Y0+dEPnUha/5rRY8p+1/8161suqm2zT2znW+g+gRE7Bc/xb4fMDY3If
	4i1FQcFK7zITBmi9yyRxoY1uC3wkQgw=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="L1G/FnHI";
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781498945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5X6KhbPcr6peWO5DbUfE0fIt/7M+wDHETmaVkQi2jY=;
	b=TYhlTQXH5nyDJxMonFYjF11cCvTOjT4kkCpB0AAKSOPLYPWk0Aqv6gK+x9rdn/TqS4R5QQ
	SR1nXLF0QS+lzTtllO4vFdB4Yu+2I3uIffNWhfvIWCu4BkZwe4C4UsSSqUHQ/rMhvAzy9Z
	tEmGxJS0SMNd/ZOocnZAJGQ3tZqISkc=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51765531803so857341cf.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 21:49:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781498944; cv=none;
        d=google.com; s=arc-20240605;
        b=NJNsUHtguiB8gXv7pz6nP5YI4xHlDQTVJiu0Fad5idr5dxhlYSt7yfOwNs9vLEii/U
         CX4kJZKfTW2yUForJ3XjYaR1vBIO4vPNqq2zD/8/bjFquWlDmqRB7PofcDQY8HJNOp+m
         kmb3Z1A9AtfOLA/OgLpqOhql5WD6f6XJVF8txhfd6gw+EH7FwPgz4t1j0oaaK3zHRJcN
         1pXKAzp7sjZgWoPabKHqLMNt6VhOrFdWlaMAtL0d+RDYUZ2Z532+vNdXIeyyIga9Woa6
         WlAVyTEXlFDQJf8CncltwCfsBCAdoqjIfKAe/JMhPZevWnDo8BUPldPO//FLbsFLR2We
         +Mdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a5X6KhbPcr6peWO5DbUfE0fIt/7M+wDHETmaVkQi2jY=;
        fh=Ct0LW7wAnMdWsiVcPJp8CUe1VmsxivViBAO3NaGadbc=;
        b=MRNHl3TPwmxY+VSfoQLok4yMDkOIWJct1cI/bkeq+s9NG1KQI1xWVfICT///0l4Iht
         dSOchYcHAxOJG5MAytk/6Lgkl72X97XRTjbp00/96AB+vGatEpzfZXyUnMc/nVGwpi/4
         7xF1pqqVIfkL+kFMURN6fnvw1Paqa8VK6cEzSDYbcHhYlLrWmqyfysolaF6RB3wkYOpM
         sB4HwcbIcJJpYsJ3N+eS7Y0l7CwaGO/md3WXCBfWjkUolOjJsZmHMY02qVi8qM+CBZFm
         qSZPFVQCBxSeLpqcjWzeVuxCi11wqZz7J+cCHVZDUbYfEpwQaUSdGWmVCydX9YUh0Fi3
         O7xQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781498944; x=1782103744; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5X6KhbPcr6peWO5DbUfE0fIt/7M+wDHETmaVkQi2jY=;
        b=L1G/FnHImorAddwO8xkQAe3Xl81RhpO4MQwRo6QQybU2YAqTrdSnMZR1w5Elvmm8xi
         /IwNOAlMLiTqYyUSOfwqY0dBFmfdIChlwegFYKU7wZj7BD3pngJuqDBY7gcQQOO7CMNZ
         lR9KeER5pjdEepXUV3p87sommKzypyp7npbukV+tVMDGqxY734i1BOLVD2jROqTyyiUa
         jLIEYA5e8ZHcUOgiI6Y1OY4FT7QFW+qt+a4TOh+725PHdmMtEF8ILu82kibzKmbfg+b0
         ns4kx1YOUENgKyl6X/n68AN9e0Xyayk3IQhrYrLAD1pUjjfguJuaQSmjBvz9pP0h7Odm
         W2Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781498944; x=1782103744;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a5X6KhbPcr6peWO5DbUfE0fIt/7M+wDHETmaVkQi2jY=;
        b=FKwTnTMd+6DDQ+0Zfk+RQlC/+zfWDlWGempgSgmkhWMyez9L5nVrhOMRi3L4zDh3Yo
         e+4zldhX+Iu8arO5w0OIKrsOQm8m37mcy/0TMorSi6vWrtyHRHG5dBrk2O+jiF2vNrUJ
         kYbF8E6kw0Rq7AxNDsIX2bmz1yM7IAGGX3Xda2qmWac4Aybh8nOsMyZOqx5u5RSbRt2Q
         Q6IVJIcSfIxBAVKvliUjKijEA2fBJNHc7Rd4/ZbiFWONMkX199MN2KAeqLBNQna1e+sH
         mLqKMOKcXJfndPsw+Uco0Bx92aMGM+tSAYEC8tFkHOJWjqCGf5lUlgbP1/PneVQKNBlH
         C7UQ==
X-Forwarded-Encrypted: i=1; AFNElJ/G82GXBIlOL70WuLixitMxpkvfmDeQNRtW5fPkQZ3t4XKRLlh4djY9obfvZy+mMMK9iWhXZGMWNw==@kvack.org
X-Gm-Message-State: AOJu0YwJqEoNHoiLHiK+26mNQzTLbosGSRU5eeW7NhNhL9QMbTG7gOw2
	9uneLab5KEKBFsrNuCyfxlTKhz6Kjr71pG5vc7yQomYrxQEgiWdEK7qfXszDL7iFnlVTX4F5zPV
	//oqpp8eFrr0DiTLMsq3bf/VfMswnifewhayOIrM4
X-Gm-Gg: Acq92OH1BX54ivkmFaiFVLw4QC7HwG5eFK3zPrg/BGq4ITaVxtYPUjqI0hjLMkQOsjb
	X0usPN1ntrQDYOBtY2c7AKnCqVGk+7qtz7yO2sY6H8IbKxOY34jPb7PQOk4OOIBRYCydOujqJrh
	CQxR7wpyv7bUqjPcMspUn75uFJYoOgEdiqDz0dsv8D+FB42j9l/bvqV6hoT10BnDmRZIwpLHVou
	jUKs7ibQJSzVCq9NKKjSs4olAsx9o/EepUh01MoQGcORxwgtpejHma9Gsv4e3Av48JSIWp0f1Y9
	AkKjSw==
X-Received: by 2002:a05:622a:4c12:b0:516:4f62:85e7 with SMTP id
 d75a77b69052e-51954a8ed36mr13872781cf.18.1781498943745; Sun, 14 Jun 2026
 21:49:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-11-7190909db118@kernel.org> <ait6ojueVi38-s85@fedora>
 <3f53fc18-838f-44ab-acad-4323daa0fbcc@kernel.org>
In-Reply-To: <3f53fc18-838f-44ab-acad-4323daa0fbcc@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 21:48:52 -0700
X-Gm-Features: AVVi8Cenjgv4vhVicxVOeHvw2PJU_Jy9c064pi49GikljHiOJMDuYR0H3JQF4wI
Message-ID: <CAJuCfpFcqtHjoE9yVOr2KeEK2+hRdHsgBLTSdr_DcVJpBu-KKg@mail.gmail.com>
Subject: Re: [PATCH v2 11/16] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 53C28160003
X-Stat-Signature: xp66b8chnrd4zncxs9jignqytsdekrop
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781498945-880757
X-HE-Meta: U2FsdGVkX18pk834H5SLV6EiZ98665Mq2ybshwZVtayVm2fm/w32Jjq676SJhXD/15fMyndhd5MAIlM5WeMUH1PDGZ4qrjtuIBYh+vi97KA+wKTMNt8yz/fBbKxulTZ+Y2dRTfmPir7lne8pU1TgCUen3larbcvx/GOmgQaa7qDPSJdtJQIzjs9JXvBD3Aw5/q7H5d96CR+gOWzZZXInFFfjOdDmMLiIwmFp4IJeBfk/TIatYT4Lmo41XcAHTZMu8qRYAfSSG+LUgGqiyvpV4FoljTQo4FK2t57dxI8ebQceF+geMmF/zMDMc5tKRD5jQppcJxF1j3FNuBYY1djmdSfi5J382hfJVtaDiLQD46B6tSFmXS8e+YC1j9BOoE5hAI6DL6nOLBGMoKLx120gshuOL0iaaHRfg8t1/FcvgW9/J1K46cYjFdRlzx8TEHHgSm7rw5EeppFh5jiGcX8DE51+7LX6vUKxM3iLM+0d0eJq5OK3fVHzZUgWLsZRT+FfRz3e3oPAbMRpIKWQ3cP1vPuMr8/5KdFQ7m3KoXUuRFGj9gA/7G1hCW/i5koqRn1zGfQz+jMFON+tZfV1DrzPXeimlftBLQx3BGnWJvGlyCDwW5wcykpWrUXygFcu7e/7SJhJKBhFOKC8ll+z4qrYXMSvddIWHZEMyDvlFDzeaTvjDFX6AvbpoGLnr7pNK9qQq1fdt17i+pt74gvuYrfFAZsjkj3ipgevtV8VgTc6/v5ocy+7Z2K2bAI0X3mCn7Ezw63P6Vo5wmiOhcCWLQh7fV+CWYeTbciJDMxGbw5v481kt4JWDdSwHFYAqmILGjAWP86hiQ0U3lGGxoB/wca4JbzaDsp9YmpxPtXjAdf0h5VkW8BeiFtNPUmGt9v1++nAvxzF4ZEF5aQsevZB31gyO0HSgOBRKzWGDYCRDHodRu9N9o3zmBw06AIfo5CiTT8LtY8fbNY8RUyKrM1ZmPd
 0lk4udaO
 AqLT2ZTZoiDnc8FitnDlqqqLpMyfWEx0R0VJmKTTqHqEhIZU1vXP4fig0NDyMsHVN0Y1GRtL7MPgW91hoZLOOIMWCuNrG9+EsEGOXz20iw/LyaD8uVYJ6eVMe24Tn8S4qhtKmZNZyC+J4K/IyL4AyTM3QMXr5/NEVWF8g/50j4h4qWX5f6O01CaN20qSg7AZOjUWRQ/l38V3kShk4E8pSezuBk9LMRdcSiL9WpLTYGr4Jk9USz8uhaAxCndGm/tIGjj4bz4Vfz0YmAQvb+IMKTGm4jXkQHZDVzFQ1Sbe6tprzd3xycpr1+lQGlRnnpwpWLJDez5EiCgklDXg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 3:05=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/12/26 05:21, Hao Li wrote:
> > On Wed, Jun 10, 2026 at 05:40:13PM +0200, Vlastimil Babka (SUSE) wrote:
> >> The last user of gfpflags_allow_spinning() in slab is
> >> alloc_from_pcs_bulk(), which is only called from
> >> kmem_cache_alloc_bulk().
> >>
> >> It turns out that gfpflags_allow_spinning() is not necessary, because
> >> kmem_cache_alloc_bulk() is only expected to be called from context tha=
t
> >> does allow spinning, so simply replace it with 'true'.
> >>
> >> With that, we can remove the "@flags must allow spinning" part of the
> >> kernel doc, as there is no more connection to the gfp flags in the sla=
b
> >> implementation.
> >>
> >> Also remove a comment in alloc_slab_obj_exts() because there should be
> >> no more false positives possible due to gfp_allowed_mask during early
> >> boot.
> >>
> >> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> >> ---
> >>  mm/slub.c | 11 ++---------
> >>  1 file changed, 2 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/mm/slub.c b/mm/slub.c
> >> index 0b9974bfcb24..ef457e07db83 100644
> >> --- a/mm/slub.c
> >> +++ b/mm/slub.c
> >> @@ -2171,12 +2171,6 @@ int alloc_slab_obj_exts(struct slab *slab, stru=
ct kmem_cache *s,
> >>
> >>      sz =3D obj_exts_alloc_size(s, slab, gfp);
> >>
> >> -    /*
> >> -     * Note that allow_spin may be false during early boot and its
> >> -     * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only support=
ing
> >> -     * architectures with cmpxchg16b, early obj_exts will be missing =
for
> >> -     * very early allocations on those.
> >> -     */
> >>      if (unlikely(!allow_spin))
> >>              vec =3D kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
> >>                                   slab_nid(slab));
> >> @@ -4867,7 +4861,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cac=
he *s, gfp_t gfp, size_t size,
> >>              }
> >>
> >>              full =3D barn_replace_empty_sheaf(barn, pcs->main,
> >> -                                            gfpflags_allow_spinning(g=
fp));
> >> +                                            /* allow_spin =3D */ true=
);
> >
> > we can remove the `gfp` arg as this function no longer use it.
>
> True, done!

I see it fixed in
https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git/log/?h=3Dsl=
ab/for-next,
so

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>

