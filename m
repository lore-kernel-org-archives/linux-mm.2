Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC5A9C44508
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE7AB6B0005; Wed, 15 Jul 2026 12:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABEDD6B0088; Wed, 15 Jul 2026 12:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AEAC6B0093; Wed, 15 Jul 2026 12:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70A896B0005
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:03:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 011F91601F5
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:03:11 +0000 (UTC)
X-FDA: 84991480224.28.859FCCC
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id EF92D18001C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:03:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FCSC8NuH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784131390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2S+ZWXaS5Irs26a/6PxuDhmL7tMg+BK9b3L0EQ5QhKo=;
	b=EMBQXUKgHaOrxVPwvi1schJvaYbBA63E2n/1luLZ3kveS9fUvmvKQd3JdoxZIA7oMSWu4c
	yjYbElqsUTTEtmxZeZ+42dkt0WPOCgnemeADFme3FyqBZoGoGx7PN0uSaEeQOTmy2TQBPs
	ByFWedRpP81Zv5fivIN23Biwe+NkseM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FCSC8NuH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of surenb@google.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784131390;
	b=0fIU+X8/Zxdl9XIZtYEwB54HTioj4VmV+S3BRC7IaArBIwEqn9KHBLSNP4OMLxVTSj+VWK
	p5td8ZreScIiuESFqFnHQM759Wss9c4IVAJ7NJMl5SMKXhBF9nWC+c8Flo5N/XMLYOhKho
	ss8tgS2u58nTShPB2K1qVU1ERzXyURQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c15a5b265so256751cf.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:03:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784131389; cv=none;
        d=google.com; s=arc-20260327;
        b=Ld1xU64Vgvx/BpwK9FhjE/kmNyxtr7KPE/iVNSyfYWRcg0RuI3gHd8Lg8BkDEjZQqy
         IhMbxoNv9Hc3F7iBXr8PDhMVee4Hk8Tcn5WgzbguMUKApuB8tYuP2SoQBxJv0tJct+IB
         whx4G67LDIQo1CrC3SwRn8/a16exO50d6N5U4ggQYRND5D2Fc0/H384WQvdVoW3ZX3uY
         9L33lEw+SUzMHRfOjH8wEYDGU/XHrJXUjcRlvPnOFW0cgSQEhW6Jw+JFc8krhcsVyYsB
         wU1f5p3hZlJrhudzZP3Ci9Fm5bKeuGYqLcyIC7IdTOWfC3umT5IX82cY4dSnbxwB3kVT
         wdsQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2S+ZWXaS5Irs26a/6PxuDhmL7tMg+BK9b3L0EQ5QhKo=;
        fh=Fyd+L9iUCFwrf6+5V9UDgD94RZz8+yPF3CtiRmiUi9o=;
        b=SEkigfBPUO2y90kQMg59JW+6NMO7YlpwjyWHrJfbuLDBoR2mRf0CyvXGG9UnEJmQKr
         Uj6UypVmpUJBenjw7WvDiWu+ODomCLSt8h5Gj2rHrxOhNNxwe7HjuQK2qaXK6UWbY/xQ
         ioOt4hqqRpj41NJAiWqtogsl9qIuNX4npsJPUvcZOr3r0stmvmAjE3TkJC2ztT8ZnVFq
         kZCTUmoEzF8NzWxig/8eVkiS1S91L6N1SUH6HD1ueHZHrSz2Rkx2JnGZ9LltT4s/80Dm
         O/ueEo8jGuQWw3ZmJSTpZdFMaW8Cj1eVJChTyfVDKiw4VHTpwE7SdWED6nWBSmP1gF3Q
         4OzA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784131389; x=1784736189; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2S+ZWXaS5Irs26a/6PxuDhmL7tMg+BK9b3L0EQ5QhKo=;
        b=FCSC8NuH7emK3ltJbXorFJc2tmx5838luB7KjORTfRhQdt5Mu4hmmQOPxf/FGPz4DJ
         +wED9YH5HBzBR5NDPMpFKMnkp0hVIMD+4fC/deKmfAOqQyjM0kkjPZUy3IM9zP8C4rpS
         Mii+z1INCMraTmsgiy6z7OC48kj52Y7kwA2u3mJzWKj6nvUxJIDtLNBlJxHYzULWSCbC
         dtjxXNO8YowRQ3uSobUFLIzT6xJCeyYnGpTcr/bH574Gsz572+0x8mh4atqL5V0Xkw7N
         1yXSViTftjfnHiJZ7y3WnkWtNTVZSSIv53NH30r/dCUeWB5ihY2X0Sug9LP9WUQg1VCJ
         E43g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784131389; x=1784736189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2S+ZWXaS5Irs26a/6PxuDhmL7tMg+BK9b3L0EQ5QhKo=;
        b=jJSWpdipp1f/fKcWqyDiFY8ynM1Ch2LW4h69hPNFCyq0yJJ8QCKTJ2LP03Mputw3yL
         WT/eN4E07OdgFvSuXLC3bTUZvq62LVaYrI7RdO2mj7jddV6BlbulkXsN/rQNbrBmXYkp
         jYW6mOKs5kcFBapZt0rPPHkNN5Bs1pYNsLLPQwVDM4uebrSOknexGxRKJHLYp4lG62f5
         fGTTVMdv8JOA6SvEF0aq6VNhkPMro8dh2ms1FymC+AMYNCFnH2IWJBdyT3Gn6/4xzB7B
         vVrhGM+2nb/8yqHPLXV1+X6H9wO6FgWw5x+NPF/u3FVh0i5Qbvf6WaSgkw3Ph6TkoFJ7
         tNUg==
X-Forwarded-Encrypted: i=1; AHgh+RotQF1lO/NBcsaq+McyK/pck9X1FG04xh4EBnocmVu+NRqmdPJojkUC2kw8AVqyZ07+6OYLA5+FOw==@kvack.org
X-Gm-Message-State: AOJu0Yy9sxpN5EqyuiiArnOoa/KkDPHTwYepMMyIzde2XYTzkgYdEoKs
	b0814a4QRO98YVYJOn8771eMViGMSV8KlmtK5Xyz3H1TF80EpfIwo0QZAXC8qEHnrVEoJqJlpD4
	3Sq5pHlPGUQU45EN7XN2otm6Vl9Lq//thlivo16CS
X-Gm-Gg: AfdE7clQ4oJwo0UJH1OGpdgaQwji+bcRYXG4P6KOuirNelSblzS+ebL/+s/yGnB4M4h
	bsGaJzq5/dNw19jBAoJuz54PzHWoPemYzBYYbnl6lB/7eOA3B9vbmMwnRkwrgxmprHQS6vAO24W
	c2inEVdkFRGWndNanBoW5AQs9Lt0jXOb2iSwEjoXggbVzU4NrKBhSc5pvpYST0LIgxDhBPJjq0U
	YruR0vHzHjOb4WwTrKJnIiY7XRCP/MUM3Hantgwge6hb+woYfBS6/XWmhj0Y2/HCFO7U9kLhULP
	SIcptqFsh88A3gUIpNwjogBv4EzM0aRYkC1sFg==
X-Received: by 2002:a05:622a:1f13:b0:517:5d71:84e5 with SMTP id
 d75a77b69052e-51d7bc99378mr30368621cf.5.1784131388244; Wed, 15 Jul 2026
 09:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-1-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-1-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 09:02:56 -0700
X-Gm-Features: AUfX_mycrnHJ859GMB84BD6ws8uva6PPMJW56YPeFhhPhkZ4LCFIUAMmQPY6LoU
Message-ID: <CAJuCfpHgMwM7SK-sanGpEyCxCi-T+gDqFJHnV_AMt=S-x5oynw@mail.gmail.com>
Subject: Re: [PATCH RFC 01/12] mm/slab: skip kfence objects in allocation profiling
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4ydth6aoas959stm9an586sctcaq3ujr
X-Rspamd-Queue-Id: EF92D18001C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784131389-773947
X-HE-Meta: U2FsdGVkX1/Mmf2O2ixbcXbQMH8DuXJx8827lzRPC4ZojE8+Be6WNMVrFQLagsoKos+fz4Y9BzIPW4l7q1I37ihb4aJG5LfgMxrSEqLAgdrzCEP3Yv+2MiXm/VAdc3n75ZPTn/eLgVWEXKqK7efSo4JL5XDjoyfj21NKvLLnTvt2B7IMLIUNWnNby4PXuFo/A8/MtTKOd4ts2UvulbYmnw0XoBvKqlpt9T84BLkjTgegV9GGFzEz9U5myH6N/Bz/BvXWpNzOj+rLv1BpSikig0Rt/V0OuqSPuTGTaBCuxCoeBaNlBq+oNP591ggUntFniOZrYvS9PIjlPf9GYQaF0PolCZehLzgHWmOIhK9d/rK/z8aOohGB4WP6qPmmwq0a+SMPz2pephJS2J8a2Um7Q9VgNV3Oo1odE2Q9kkIcTbAdj8kT/THrhnu6iDFPT3bnFTPJbItW08/2ykoTxPo05JcgeMOwizYnL2isnmTDVPWF8PzMtMRyTPaiMPmvqBs1H0R76P4qLdhrmz4EwiRMVYUMfLpKv+8og0C+DGg0UyRzylmmPASFh3PMuIUNKe0aZ+SsWBFMybWLKM1fVkOwrJoJfy3MgxFfyBGJJayISceXlkx9M7Q9vwsfG0E5BN74gu98soSEqjy+ucn+2VZzJW6XiAyx0WdpvOYM0PI7jR50sx0sVt9stlHdpyMBq1l1Cw1BbR0QvPwUzQg2W++lOj6SaUq1EyR9Q3vlb0SL3OjjLjZlXyrUtkjYdvMEL6dEHrEaToVWiYQeatsjd7/WlpijbLFDfS72a/RllAJ6auejTsvk7SOZoKfm8BSKkvJN4hMHMegaXoOUlmm/ve3bY5IDlUZR3/93cn4xZcjti18SMozP0Iu9UqTgJtRZ0coRpA6xwKtZJWYsZpwyeJLFxL3f9+X7iA2OtG0lD40rO8Sgn+f5vwrNIdA0Zma6y+MVgF+xZN9jLZS+zNus3Ho
 dBDRZdF2
 5wINQN1KTmXZ5xjJkMxoJwGUyg7hCB2XVDlxJekW2tAV9NfN3PqamH8E0XveDtckhfOJNRpdtoGoy0HgaUqOHIaw/3SO4aUt90TP7AEfOStJKIuCwwK9J2G9rYxVsXlA8TlUJ/80s1owteXrXNMhzVAH5lSUpY0G9yjsLxCx8307rzsvgW7Hxny3uGMTB2aovKzLPE1+JwEfq9a5KhA3gjbiLeJH1pYF1irEdtta6WnCGi/aZLb3HOorZ1aRFe+A69vXpQggeKIbpRHw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:10=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> struct kfence_metadata only has obj_exts with CONFIG_MEMCG.

I don't quite understand this statement. obj_exts are allocated when
either CONFIG_MEMCG or CONFIG_MEM_ALLOC_PROFILING is enabled.

> If it's
> enabled, it does also work for allocation profiling, but there's little
> value recording tags for KFENCE objects.

Unless we are leaking them, right?

> Furthermore it would complicate
> the upcoming changes, so just skip them in the slab hooks.

Ok, I can understand that. If we do this, we should document that
kfence objects are no longer tracked.

>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
>  mm/slub.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 0337e60db5ac..a4be70d080fb 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2352,6 +2352,9 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *=
s, void *object, gfp_t flags,
>         if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
>                 return;
>
> +       if (is_kfence_address(object))
> +               return;
> +
>         slab =3D virt_to_slab(object);
>         obj_exts =3D prepare_slab_obj_exts_hook(s, slab, flags, alloc_fla=
gs, object);
>         /*
> @@ -2399,6 +2402,9 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s=
, struct slab *slab, void **p
>         for (i =3D 0; i < objects; i++) {
>                 unsigned int off =3D obj_to_index(s, slab, p[i]);
>
> +               if (is_kfence_address(p[i]))
> +                       continue;
> +
>                 alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s-=
>size);
>         }
>         put_slab_obj_exts(obj_exts);
>
> --
> 2.55.0
>

