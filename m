Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E3A2C44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 01:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FC8E6B008C; Wed, 15 Jul 2026 21:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F0D6B0092; Wed, 15 Jul 2026 21:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9876B0093; Wed, 15 Jul 2026 21:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2556B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:03:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7FB312036A
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:03:10 +0000 (UTC)
X-FDA: 84992840940.13.8388519
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id E737D80007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 01:03:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uzox+lE1;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784163788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlVeU2x3lBE1gt1nF2NSCKX8pQ4ytaHE9Eu/3gKO7/k=;
	b=NFv7Rx1cAli7pxO9cRfblH/zlrfyTB3dPVzli3PNIfRAV/GqkbePVns6RJ+1PcqM5DOK7s
	hVJHODESr3mp+obeIC5rZ/uZjthf52iYtZwIz1j0XqzYYZ9TBK0p8D9upPZtBjJkvctmrJ
	BAetq5ZjO+ImCsRXlzCea8COS8cftjA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784163788;
	b=5DnN4bxGEA5PFYPTI/FKFVAS+N23f4+mvF36kydXxX0nXsDo6kFdp4nM4vMQ9Hq/0EEN36
	ePPeTKVKpcL0KNiD90/Wcmindv2UYWFufnLlcnWyJKvZzGADiG5RD/NgTxIT4q2TbSOUYX
	NixyepXVV4cc3lJZ4PlAWcTccF0FFdw=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uzox+lE1;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c01c79467so133361cf.0
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 18:03:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784163788; cv=none;
        d=google.com; s=arc-20260327;
        b=QDKjQvdkSOjUP12rBpHWjs7QTfvZ0SFnkSfsLzfmhSO0/ZjyI/fYbfc6IWFToJAVSj
         PBuYQe0yXRs8YyjSUOMRe/ATJWvoWGgabhkyibLpKHpmWziGXDp5jAQXSaF287+a9uWs
         6nJ5WyBboGsdtFlGY2h7NDCW+f5x6hXR4AmDE/jajSSVP+P6weleXIv4cHouav9l/AEw
         OjxHtjXUe8O13200vfXURRF4f39jTx32vheEtwJR8KbT7YiVVfcvixp2OlmS7J4xUhyn
         WwTSB0lzA0crszAwOMMMjNGEKbb3MyNwdjEAGMGLWOuTF1KD10T7d3VmGJeokUIoGHyG
         133g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BlVeU2x3lBE1gt1nF2NSCKX8pQ4ytaHE9Eu/3gKO7/k=;
        fh=c979CrzAB3cBZiVJewnGF/rQd205aL/SVVq1Z4lSM0Y=;
        b=Ylt1rn+Ku2ZtH49LeP4tmQJN0eamIm/z5Z58YLYNjHLei74H+R3f5LBHivF6mf7QM1
         V1c+ce78flzpHIJdEkxULIZ/RJ+jf81Ss4FPBQxGnjlje3tuBYgMqK1nsNHaHuyNwQTW
         Wlij4fuu9rRlhoGcJX8WCapV5p4P+71xuJMG0fcpxk6klNuQ3o0ueH5+C2zQWM7fj7i0
         5IpYW6KGu63ffWd3Lc5/Tc7cSWxIQ2urzpuj1WgbNMkoMoxWOh7Zx6TDwNB/0wCeInvh
         zTUNRz2/gg+2CqOP2J2nNmC4+LxOPQGqlG+mOFxrnLxAv0gwoNeZNcuBLeQH6oG6hJXa
         kSow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784163788; x=1784768588; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BlVeU2x3lBE1gt1nF2NSCKX8pQ4ytaHE9Eu/3gKO7/k=;
        b=uzox+lE1kPgjBIcwyxwx0ZyNS4L4WoXaXFHaB2su/wk76MGCheOL5ph43e/gJJCT0V
         kRvPtbAKE55vlcvX7uuJm/vJb8PhL8GkKs0Lv+qjjB4OJW9oB1In4ATCYlJoQYvjER39
         P/Tk9wdsY9DBUT2G7Q/5yQvwYcc7xwwWZu6tJCszwyvc2vvXUk2WnvsCmZSGXaqOGB0x
         czXsUomyO161d2PeyiFqz6PFVLCHZMssRuDRKqXkSUvLH5mGpHDRoD4AJv+8P9qAJicH
         6Gmw2H1YllFl5Sap8VjqVt5PBuMCxJkOlFH+9kxgTlM5OU2PKHgfuYkHCgRLP1623SS1
         UpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784163788; x=1784768588;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BlVeU2x3lBE1gt1nF2NSCKX8pQ4ytaHE9Eu/3gKO7/k=;
        b=ZprbaSl127mvJoxKjbGqLeYnsE3EHKkINR1EJtEwU16NasKCkCGHcat/4tttFhg23e
         O3masP2hAQU/Q5f2UXX1r7AUOXiYmlD1TRKK4iJJoeSxQf+QlE5S4qXxM6YaeEXLjhyd
         5x5ggelu+7Q25RcjKiv2rhYgtwjo/ugoiZMDGwjDk4UrQ3ZrQokRkFw7y06PYDUcSnSc
         +otGuIj85t2J0B2+tT+yKCtKCCY4DmTWqnSBEDOlfhehCcWtbdnMow4CjaEeEiW/wkUr
         OqsXMNHdOmw1nQylxjyGHrrcFdBpKNOE57Cc/72k3QjK2YbyXVzlwIySZ9Jf1YLq/9oG
         Gtbg==
X-Forwarded-Encrypted: i=1; AHgh+RqIjnX+2cOZ8jrYiwPddYb308iw2Sw9eaa8G4UrSuZw3xgpNNjqRFgbCFTZ76g82FFrFhGuIXNGXA==@kvack.org
X-Gm-Message-State: AOJu0YwGZsUEi0UmwKiMw6adAaXymNRAYUV0uEyUhiD+jwif69Tu85FC
	msvM+BtNfVDrAlOEpdYT56l2PHw7W1CKqN3oX1ZDzTJxVaRcvlxVF+IZUjvn7a5yq66HIO5SX4P
	lPgikdBmRUCSJ54SjJnC+O5vlvVJ9n9V02LtpkFrT
X-Gm-Gg: AfdE7cmExG/EXI70zSGAC/YfAzL2FRYPhG+0POx6TrrPwQELYnMixjGfc8iuBt2dhE9
	FdNMkf5DNhvAjghO1Y5OP9YwEYJjH1ZPVgoROHUAJXxkCXfGGHWwCfjZ7idAP1pxcBs2sLX7lEp
	DrYarG506nxgg4aLXdYEzp5711LsGDVPY6mihRdL+doli83bPAtOKrNRhNvRHaMLYUw6ooUyWQ+
	xBAeBAJJtaQ6saCsM5yuU7HfEBKPgK0+4mwFMEzU5sZhCLnza3xATy71Dt/
X-Received: by 2002:ac8:57cd:0:b0:51e:af63:e831 with SMTP id
 d75a77b69052e-51fa2e44190mr2311931cf.1.1784163787260; Wed, 15 Jul 2026
 18:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org> <20260715-b4-objext_split-v1-4-9a49c4ccf4c3@kernel.org>
In-Reply-To: <20260715-b4-objext_split-v1-4-9a49c4ccf4c3@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 15 Jul 2026 18:02:55 -0700
X-Gm-Features: AUfX_mz4DPdQxxMzskTuOwtGaxTssBW96TnyywdO6bKuhvHoACEpqUhCrL0t3Cg
Message-ID: <CAJuCfpGBPkg=OFTX4iMMSu--YDK2yDtNcQXeO0Ktupc1uUqQgg@mail.gmail.com>
Subject: Re: [PATCH RFC 04/12] mm/slab: make slab_obj_ext() determine object index
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E737D80007
X-Stat-Signature: npz5j1chpwfoqtsyxtqhenmu4fbkbn7c
X-HE-Tag: 1784163788-159572
X-HE-Meta: U2FsdGVkX19tSYFrVYUp0JxXu5aKR692SRjpIplr1m54Ba1bUXwD900eLKTMUezHDzyS+/cFsLov3hRkbtHjgpyMLXC2MsnkHzL1i9t5WI8XpcsGWA8vvujpWhiqQnmwjE8NbvgqYRqfLSjRAkTg3usVGFilTLA4cCi1rzAyrjs4QiqdEU7nBo83nh6AqcjLU0rinP3gt1g7WI4gx/sNeSkp/Y53iAwHA1GndLNrKmmYMRbpZI2vZB0gEVvq+aoiyzJNOQA9eequQ18FBBTOFB2lz47YhPxLaSPX+lyg4qb1eJoEH6yiB0JzMP+9x3LklnSMccn6MM8zYKI0uBONYoTHnxhXBZ4EOhe8ibiT86bFzewQ/FWmtxLCelLPhEIoeREbuiejdohttX+8IKlRipHKGIAv1koY29QLfaj1H3/LIKnia5rqe7chirxMf7WKbHeb01IFqFABRgHwUdB/0yT4tvu7hwLS4ySuZDEKMJKJaARA+IjMAb4JEFeAdIPcahg3W9ZV66E9jN8ijqVLEQilnElm3AFhUy+3Nj/K6VDx5avO1G6EWc999nLev+giymvwFrx5bJ1SNajpHHYIEy8sVXv1Df8xfQKAqQW9BgXqRO8mGgTovvJ50O+4uZZIctw/Pmv/GT0+50uwJACdTZLo6ASABbEUpcbE09OpATN3IgXcTP1z2aQQLOPCKhW6SC1d/fJojKM1ZIp8MfYNfQgrmQw2EK0XQlemwYt2rXxHTNyvQBqTeOkJG9tNO/OL6yTNXlgUq6BEuyz5ldR22TEdLC4vBExMvQ37U+xd/OxP86hMYyQnR+f9lMAT/YZofPAE6LyRAcT/HUD+5nR4pev4fqEH1I0Z3OgoxH2R4h4tzrC1WXT2vWIcC/mkEFAPxnc/HqWbbgKD3qBWeiCbFc/QAYczvtK2LILzihcczN2nhmcqAUF+hCgwGlPcUni86iXWXC8pzanZC/19is8
 9ukt3gPb
 hZsmCvT8EJKkGa7uZGAfridEpiqu7iv+m55rzuq+MyTrKpPP+MI/UY5ed1jEyAGUNpsstUyIi7PjkbRy1tbr8/8bgCf39cQ0gNZ+jrzqjJQ8JOLJeNPdJ/4FWhlFDBCWYxRlDaKppgiEjZ+Ynp7876XgGF8p+q+/22JipRVojZ/z/62nOIsSm5Afjy55BRJWhCux/ojk68WZflvk67xwC1eDFyrR64s5BwH4A5QmngER4U44i0i4L3ams0piKBU8yR8AvMqwRSJOkAk8zqrjAopYuQrXfD0UoIXktcHaGebJ3eYM8tuIKzIrWcl+kfUJd6ArL1Y8XlcoOhzQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 3:11=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> All callers perform the same obj_to_index() calculation to pass the
> index. Simplify by passing object pointer instead and determining the
> index by slab_obj_ext().
>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/memcontrol.c | 12 +++---------
>  mm/slab.h       | 14 ++++++++------
>  mm/slub.c       | 22 +++++++---------------
>  3 files changed, 18 insertions(+), 30 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6dc4888a90f3..4e427286a88a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2865,15 +2865,13 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struc=
t slab *slab, void *p)
>          */
>         unsigned long obj_exts;
>         struct slabobj_ext *obj_ext;
> -       unsigned int off;
>
>         obj_exts =3D slab_obj_exts(slab);
>         if (!obj_exts)
>                 return NULL;
>
>         get_slab_obj_exts(obj_exts);
> -       off =3D obj_to_index(slab->slab_cache, slab, p);
> -       obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +       obj_ext =3D slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
>         if (obj_ext->objcg) {
>                 struct obj_cgroup *objcg =3D obj_ext->objcg;
>
> @@ -3541,7 +3539,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>         size_t obj_size =3D obj_full_size(s);
>         struct obj_cgroup *objcg;
>         struct slab *slab;
> -       unsigned long off;
>         size_t i;
>
>         /*
> @@ -3616,8 +3613,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache=
 *s, struct list_lru *lru,
>
>                 obj_exts =3D slab_obj_exts(slab);
>                 get_slab_obj_exts(obj_exts);
> -               off =3D obj_to_index(s, slab, p[i]);
> -               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               obj_ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
>                 obj_cgroup_get(objcg);
>                 obj_ext->objcg =3D objcg;
>                 put_slab_obj_exts(obj_exts);
> @@ -3635,10 +3631,8 @@ void __memcg_slab_free_hook(struct kmem_cache *s, =
struct slab *slab,
>                 struct obj_cgroup *objcg;
>                 struct slabobj_ext *obj_ext;
>                 struct obj_stock_pcp *stock;
> -               unsigned int off;
>
> -               off =3D obj_to_index(s, slab, p[i]);
> -               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               obj_ext =3D slab_obj_ext(s, slab, obj_exts, p[i]);
>                 objcg =3D obj_ext->objcg;
>                 if (!objcg)
>                         continue;
> diff --git a/mm/slab.h b/mm/slab.h
> index 7bd361447c54..36d067d6e7c0 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -646,14 +646,16 @@ static inline unsigned int slab_get_stride(struct s=
lab *slab)
>   * Returns a pointer to the object extension associated with the object.
>   * Must be called within a section covered by get/put_slab_obj_exts().
>   */
> -static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
> -                                              unsigned long obj_exts,
> -                                              unsigned int index)
> +static inline struct slabobj_ext *
> +slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_=
exts,
> +            const void *obj)
>  {
>         struct slabobj_ext *obj_ext;
> +       unsigned int index;
>
>         VM_WARN_ON_ONCE(obj_exts !=3D slab_obj_exts(slab));
>
> +       index =3D obj_to_index(s, slab, obj);
>         obj_ext =3D (struct slabobj_ext *)(obj_exts +
>                                          slab_get_stride(slab) * index);
>         return kasan_reset_tag(obj_ext);
> @@ -669,9 +671,9 @@ static inline unsigned long slab_obj_exts(struct slab=
 *slab)
>         return 0;
>  }
>
> -static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
> -                                              unsigned long obj_exts,
> -                                              unsigned int index)
> +static inline struct slabobj_ext *
> +slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_=
exts,
> +            const void *obj)
>  {
>         return NULL;
>  }
> diff --git a/mm/slub.c b/mm/slub.c
> index 9e25f2dce7a6..5e3f53bcd0d3 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2070,11 +2070,10 @@ static inline void mark_obj_codetag_empty(const v=
oid *obj)
>         obj_slab =3D virt_to_slab(obj);
>         slab_exts =3D slab_obj_exts(obj_slab);
>         if (slab_exts) {
> +               struct slabobj_ext *ext;
> +
>                 get_slab_obj_exts(slab_exts);
> -               unsigned int offs =3D obj_to_index(obj_slab->slab_cache,
> -                                                obj_slab, obj);
> -               struct slabobj_ext *ext =3D slab_obj_ext(obj_slab,
> -                                                      slab_exts, offs);
> +               ext =3D slab_obj_ext(obj_slab->slab_cache, obj_slab, slab=
_exts, obj);
>
>                 if (unlikely(is_codetag_empty(&ext->ref))) {
>                         put_slab_obj_exts(slab_exts);
> @@ -2362,10 +2361,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache =
*s, void *object, gfp_t flags,
>          * check should be added before alloc_tag_add().
>          */
>         if (obj_exts) {
> -               unsigned int obj_idx =3D obj_to_index(s, slab, object);
> -
>                 get_slab_obj_exts(obj_exts);
> -               obj_ext =3D slab_obj_ext(slab, obj_exts, obj_idx);
> +               obj_ext =3D slab_obj_ext(s, slab, obj_exts, object);
>                 alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size)=
;
>                 put_slab_obj_exts(obj_exts);
>         } else {
> @@ -2386,7 +2383,6 @@ static noinline void
>  __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, =
void **p,
>                                int objects)
>  {
> -       int i;
>         unsigned long obj_exts;
>
>         /* slab->obj_exts might not be NULL if it was created for MEMCG a=
ccounting. */
> @@ -2398,13 +2394,11 @@ __alloc_tagging_slab_free_hook(struct kmem_cache =
*s, struct slab *slab, void **p
>                 return;
>
>         get_slab_obj_exts(obj_exts);
> -       for (i =3D 0; i < objects; i++) {
> -               unsigned int off =3D obj_to_index(s, slab, p[i]);
> -
> +       for (int i =3D 0; i < objects; i++) {
>                 if (is_kfence_address(p[i]))
>                         continue;
>
> -               alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s-=
>size);
> +               alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref=
, s->size);
>         }
>         put_slab_obj_exts(obj_exts);
>  }
> @@ -2489,7 +2483,6 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>         struct kmem_cache *s;
>         struct page *page;
>         struct slab *slab;
> -       unsigned long off;
>
>         page =3D virt_to_page(p);
>         if (PageLargeKmalloc(page)) {
> @@ -2529,8 +2522,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
>         obj_exts =3D slab_obj_exts(slab);
>         if (obj_exts) {
>                 get_slab_obj_exts(obj_exts);
> -               off =3D obj_to_index(s, slab, p);
> -               obj_ext =3D slab_obj_ext(slab, obj_exts, off);
> +               obj_ext =3D slab_obj_ext(s, slab, obj_exts, p);
>                 if (unlikely(obj_ext->objcg)) {
>                         put_slab_obj_exts(obj_exts);
>                         return true;
>
> --
> 2.55.0
>

