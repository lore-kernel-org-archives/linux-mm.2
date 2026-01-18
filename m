Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D8F0C9830C
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 20:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76DB86B00D0; Sun, 18 Jan 2026 15:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 745616B00D1; Sun, 18 Jan 2026 15:46:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 648A36B00D2; Sun, 18 Jan 2026 15:46:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 431106B00D0
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 15:46:01 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE99713B4B8
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:46:00 +0000 (UTC)
X-FDA: 84346266480.08.0795567
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id C949440006
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 20:45:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P3dLcz5+;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768769159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJvJDVCfQGiQhTyEeyupPbB3kxPlJFu+RnX8pclHBaI=;
	b=u4ilNDHn/RHqIydJD6BUdKCq0kgLGlm6U/1kHis/fB7J6GyN/ybavIyl3UkwUQSpvCG8df
	mwJN790ihI0cweREjsbMcBj3HRKdbUIDIkv1XWMiw7KmcyxoJi0f8jfIW5JLtNfWK3RfXz
	8P/VPuc4BfOwYiXV7k+hFnlVBVxq7ko=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=P3dLcz5+;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768769159; a=rsa-sha256;
	cv=pass;
	b=u4knkvjJsFgFc1OxzLTDk1mGPKJWNTgUcw2KNNFYW5I2m284LIYrQhlnbxuRZTgTSyU5La
	KDjRd4nTGFjThOUiDcAVrH9ZbNs2esANIFWmf1N/DYofq0TWbOtnuS+Kwzd+hdoolXZS0r
	pmgYbVr5GIvv46I0Y1oIqgaY+jb6A6g=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6505d147ce4so6259a12.0
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:45:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768769157; cv=none;
        d=google.com; s=arc-20240605;
        b=KRRHA4jCjK0iP8K4fHGyu9YMUnZ1QU6LaThCliZDyoZnbbzaXHK771ziKo9PPnJ7qm
         87f9flRBe4DU+T8O4OLWjamnuooU5qpZIhyXKPCSTgRa/Trf1MN3ZhOmel85p4WhPmCI
         N5dfh7Kl5WiexCgjkoOHZ/DmRZ0Px3yZF/Wg0U+FlGWT4X3h0eWKTsrzUwZTDMSc/Jfp
         ymf9X+IjLBsi2isqhOHXso+t8/lgBTFiwpnP3Q0lL6zVJUZz7sAWSvGWsu49kF/NLL56
         mjbH63VTl0mtVWwQSqa9JwQwMyX8Dhzgs8gzsu1u7PXGcxlYvBuNMSYkT/kvNgbRq06+
         FToA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IJvJDVCfQGiQhTyEeyupPbB3kxPlJFu+RnX8pclHBaI=;
        fh=cGhc/UE1tT66+VrsX1HkR0Gp1EeKn71+XTgOBgA46WQ=;
        b=gxHVcGLLcO9itVJtkgnnxHpZTZwqxZMo9i02GOcDwAQaTFlcpB3zEYsR1fbv3qYpGG
         w6W5OVfb2K0nrmMThIJXm6cY6zAPfm5FLIVjHKfnQouY/SURtqLo2zvEm06u6F02wA8Y
         rP8b9CwJ4nj5EGfahBZwYVtupWvI8tRUh6WAG9zeP/1h9RA74EoJgoPaG2B0EBLb3Oe5
         ZVhRYh6KNf5/6cswgDgg7dIpzbr5tsDx41EhMQDatwdSHT5JvgPr/hgvhRaM/bjLMzQF
         yel9ygemOOPxagfkU6/+fj5uG+KwrdRi8Lvm4+v9tJ6Gbscbew3nugv09c1Z8V7RgOzd
         CFxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768769157; x=1769373957; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJvJDVCfQGiQhTyEeyupPbB3kxPlJFu+RnX8pclHBaI=;
        b=P3dLcz5+pDhJe19dlDe4XKfSQhM/ufpkJjpsl4Hff+FDJj23AKuWeNV14Z59nDZ8rG
         ni6Lo0RRsI5Tw9afaqxZpPAjsB9uv20Lz6DsXbPgE2QjD/Fn9htxVWS51rny+7abZEEX
         /w1gMaIpLb1N/486wQDWcev8zoR7X33XVxXTU8jtXQoaX1YaGkwJoEKyHkIBYZtt86vW
         lzZveA/sgnfbAvfnpn4OOlVYslzQBTjHWhYifDFbW71nHXsijRP7AJsrDMOsYpnsIpHg
         5mT2SaGU1vKemj12O+0p4jQVT+6g4nKH7KbVsHImFvg1v9+mw8R2wl/Qai5hXjD+QbmJ
         bqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768769157; x=1769373957;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IJvJDVCfQGiQhTyEeyupPbB3kxPlJFu+RnX8pclHBaI=;
        b=WI8HRjr8IHg5X6PA8X8kPEiWGt5oj2WebfDrElks8uuraZaODBNEiGlLwcps39fY0C
         8qBOSlVOwvACzw6UNm8WapdpY/Qt6jOqm6w3jqwYwYSk06L1arz/gHYyOF+teRz2jYqt
         mHrsqk+LqRN+UO4tmICuxoB68hbxDl5PJGjVxIP1POxYiquJZPsZdwZBW07wn3aYXAYf
         shF8S78po/UYq3quOFpox8P/teQNMiQMf1uiMmO7CLzvVOOVEJYcZIpbo4HlHXZv8Ll4
         NAu91Ljh6AhjqvYpxGJ1SOwpGEEMcZ9Ir99ow9F6sNaPXhMmm/tGha74XQco04tCEj4D
         OBTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVlORL5FopKwdZZZO0b+OsBRUW54GtiP42T+W0ay3zaWz/6lX1cUvx9l4MCUCzehzaROMa7/uzNog==@kvack.org
X-Gm-Message-State: AOJu0YxZsYvlo3lKS58+A6iPveDoBw04qhiUDmEnXAOyGS+A3yUbjRE8
	YZXCDJn74ubrr9uZrz4HrrP3uZFaF/7mjb8O825pzt9a2U/+zVeUSgsz1IQ4zkKIIKjE7enh+Pd
	MvS3RKLZdJNfmuAlwh8dBd8b6WyCBiII1VHj/Pwgg
X-Gm-Gg: AY/fxX4YPjCSR68xMQEe2aCZujU8lUJWbHaS/C9JFyyTOsKNHCtYV7DIpbGe0vYqzG1
	YomD/tHA1i6X/p88IrPNtqt44swY7kUzHO8SGFZNBNMkG6wonnYPsYBHIQ+3367c4BAWJJo69+m
	AyDJTU0ZQJC+Kyq0XgeWdAjqEMpzoFuwvLjTHNj77sCEIepedAOBD7UdkRRarz1YcsWlEt1WAu2
	OHzgfRj3osjhmc6iqjQVrjOhyriiq5hmsE7mH+w9+cMklJVVJOtid2Y+T6FXWBP1fNOI048xz/Z
	lGalkrJX4NCEjX95yLMCO0c=
X-Received: by 2002:a05:6402:b79:b0:650:5d5c:711c with SMTP id
 4fb4d7f45d1cf-6561ee75634mr22230a12.17.1768769156751; Sun, 18 Jan 2026
 12:45:56 -0800 (PST)
MIME-Version: 1.0
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz> <20260116-sheaves-for-all-v3-7-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-7-5595cb000772@suse.cz>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 18 Jan 2026 20:45:43 +0000
X-Gm-Features: AZwV_QiwVzd1b1HBHsztjRZ_PLBdReYsBX8Ibd28htOveyCZqKIEsBm2-CrYcsc
Message-ID: <CAJuCfpELoHBKSq=DyLPPtQwqL=nPaQ1cBD-sthJd64MbW40Bxw@mail.gmail.com>
Subject: Re: [PATCH v3 07/21] slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, 
	kasan-dev@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C949440006
X-Stat-Signature: xdad9oyxtgzrws38yjfatyc68fnris7p
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768769158-791166
X-HE-Meta: U2FsdGVkX19omzILIBQsiFU3fLlPlFxWzXDzVOkxBxNH4AgPXHugmP8ybgmzqlQ32Er78NO7Zpbe9Q/rrW99dPOq51ZZ7STOn6IlC5ILGeVz/IqfGVwN3Doz6Fe/9aJRrR8TArmSDlnbBlbSye5sknDa7pQcxpE1xLr5zLzoE7QR1biCC73w1dOKHPUwc9U2J6NfT6TKzG1OqjAZB9NZhAhO65YcTEYIMTdv+qkrqxtiX79R1txVQUFupascQq4mrBudZYUbllFhrtceNCTQxj0Vpe+1Ggu2Pe8E086/ykKQV8NhS2XTahRuLh1ymp2zfgZviQKYERphy2JWA4K5pGQzBSaCNNjjEMSkJwxCXCg9WVwfHs+B2CKTa8HU0va15lSEJ8LwGlmvfpwdvea7ybMFckqBld3pakOV6w/UBg0hewMgkEgUUz3uE1cdZWlBT/Ajdw9YzueQeLSZTMsLPVYauI4iCaQgVWoe6oQNG2E16PO1/BhqkIzljXzQfRfuFfuQ96aW+PZy3Mcuk3DRTIHMGRBXFXouDlQ6z07SSLXo+F4VBXDxcLReO7lh2HMKBBV95ufrfU7cFTyyFeTZPtSO15ng8tbzVkHaLScGVXOrPltpDR5MwYvGinPCx+mfDqefkWrjagXzv9tK1Y+smpi0x35Dwqsa00UrYhH04EWqRJ1380yHS7YS8y1daqJXQXnCYl1eR7yleZZw06klvokYI4SFeaEBEwAAi3GkvTL4IS0YjKQuHPiLf9vDXMK7iFnBj7YnPtabsA3Wx1w0gA5WOQCP4DhaEGBCOztoYnrnxKQ+b9MXokDJ5y9FdTVDYR2IJCelZXqCFI0FUU895Cx98Pj00ow9F+02moZB3e4GGxTSLnF/BJMvyCFYD0GYksBYRYCNsci6KMDW9KkpwYSKvbs/cEYiaDPkH1yfa5TpJRWKelPrCPKWdTKL3lQIz4zn98cw3uEOSPljNPu
 Mu7eqvPy
 oG9+4OIq2AokX88eUd+UeYOWPXvUS5ElIwWdAo0z9AghSyCSTsiNKIx/Jj51xjw9AxH9IYOo3sN93he3ro0JiHLmoJwaqxhbKW60EoIB0VZmqFc0CHVldyY//Xe9eR942TKGM4akr3UQNVUjICeIXgmqZsjHDqbrWjjJ0E341n48dR6TCV67b2/tTYvsV33RB9bI1jmxfkcSXHwVFN7qPhQzpJj7CT0aKHxwECA5XPGJf1gqz8RDH/x8LtJ4AbR7+XE7Equ2KGjl/iko2osrfwdW6xP2ZZ9hKLI+aiANi0koS9rO8FKEw/dsqYho0nAN1+3Lhs4Ufv1gTOpNyRd2q+HwnVweo/+Xv4ltDYStgqGLtmQQE9VnI6Wa4exa0NFow1kgAPsPAWhmO5dE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 2:40=E2=80=AFPM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
>
> Before we enable percpu sheaves for kmalloc caches, we need to make sure
> kmalloc_nolock() and kfree_nolock() will continue working properly and
> not spin when not allowed to.
>
> Percpu sheaves themselves use local_trylock() so they are already
> compatible. We just need to be careful with the barn->lock spin_lock.
> Pass a new allow_spin parameter where necessary to use
> spin_trylock_irqsave().
>
> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
> for now it will always fail until we enable sheaves for kmalloc caches
> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  mm/slub.c | 79 ++++++++++++++++++++++++++++++++++++++++++++-------------=
------
>  1 file changed, 56 insertions(+), 23 deletions(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 706cb6398f05..b385247c219f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2893,7 +2893,8 @@ static void pcs_destroy(struct kmem_cache *s)
>         s->cpu_sheaves =3D NULL;
>  }
>
> -static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn)
> +static struct slab_sheaf *barn_get_empty_sheaf(struct node_barn *barn,
> +                                              bool allow_spin)
>  {
>         struct slab_sheaf *empty =3D NULL;
>         unsigned long flags;
> @@ -2901,7 +2902,10 @@ static struct slab_sheaf *barn_get_empty_sheaf(str=
uct node_barn *barn)
>         if (!data_race(barn->nr_empty))
>                 return NULL;
>
> -       spin_lock_irqsave(&barn->lock, flags);
> +       if (likely(allow_spin))
> +               spin_lock_irqsave(&barn->lock, flags);
> +       else if (!spin_trylock_irqsave(&barn->lock, flags))
> +               return NULL;
>
>         if (likely(barn->nr_empty)) {
>                 empty =3D list_first_entry(&barn->sheaves_empty,
> @@ -2978,7 +2982,8 @@ static struct slab_sheaf *barn_get_full_or_empty_sh=
eaf(struct node_barn *barn)
>   * change.
>   */
>  static struct slab_sheaf *
> -barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empt=
y)
> +barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empt=
y,
> +                        bool allow_spin)
>  {
>         struct slab_sheaf *full =3D NULL;
>         unsigned long flags;
> @@ -2986,7 +2991,10 @@ barn_replace_empty_sheaf(struct node_barn *barn, s=
truct slab_sheaf *empty)
>         if (!data_race(barn->nr_full))
>                 return NULL;
>
> -       spin_lock_irqsave(&barn->lock, flags);
> +       if (likely(allow_spin))
> +               spin_lock_irqsave(&barn->lock, flags);
> +       else if (!spin_trylock_irqsave(&barn->lock, flags))
> +               return NULL;
>
>         if (likely(barn->nr_full)) {
>                 full =3D list_first_entry(&barn->sheaves_full, struct sla=
b_sheaf,
> @@ -3007,7 +3015,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, st=
ruct slab_sheaf *empty)
>   * barn. But if there are too many full sheaves, reject this with -E2BIG=
.
>   */
>  static struct slab_sheaf *
> -barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
> +barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
> +                       bool allow_spin)
>  {
>         struct slab_sheaf *empty;
>         unsigned long flags;
> @@ -3018,7 +3027,10 @@ barn_replace_full_sheaf(struct node_barn *barn, st=
ruct slab_sheaf *full)
>         if (!data_race(barn->nr_empty))
>                 return ERR_PTR(-ENOMEM);
>
> -       spin_lock_irqsave(&barn->lock, flags);
> +       if (likely(allow_spin))
> +               spin_lock_irqsave(&barn->lock, flags);
> +       else if (!spin_trylock_irqsave(&barn->lock, flags))
> +               return ERR_PTR(-EBUSY);
>
>         if (likely(barn->nr_empty)) {
>                 empty =3D list_first_entry(&barn->sheaves_empty, struct s=
lab_sheaf,
> @@ -5012,7 +5024,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, stru=
ct slub_percpu_sheaves *pcs,
>                 return NULL;
>         }
>
> -       full =3D barn_replace_empty_sheaf(barn, pcs->main);
> +       full =3D barn_replace_empty_sheaf(barn, pcs->main,
> +                                       gfpflags_allow_spinning(gfp));
>
>         if (full) {
>                 stat(s, BARN_GET);
> @@ -5029,7 +5042,7 @@ __pcs_replace_empty_main(struct kmem_cache *s, stru=
ct slub_percpu_sheaves *pcs,
>                         empty =3D pcs->spare;
>                         pcs->spare =3D NULL;
>                 } else {
> -                       empty =3D barn_get_empty_sheaf(barn);
> +                       empty =3D barn_get_empty_sheaf(barn, true);
>                 }
>         }
>
> @@ -5169,7 +5182,8 @@ void *alloc_from_pcs(struct kmem_cache *s, gfp_t gf=
p, int node)
>  }
>
>  static __fastpath_inline
> -unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, size_t size, void=
 **p)
> +unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t=
 size,
> +                                void **p)
>  {
>         struct slub_percpu_sheaves *pcs;
>         struct slab_sheaf *main;
> @@ -5203,7 +5217,8 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache =
*s, size_t size, void **p)
>                         return allocated;
>                 }
>
> -               full =3D barn_replace_empty_sheaf(barn, pcs->main);
> +               full =3D barn_replace_empty_sheaf(barn, pcs->main,
> +                                               gfpflags_allow_spinning(g=
fp));
>
>                 if (full) {
>                         stat(s, BARN_GET);
> @@ -5701,7 +5716,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_=
flags, int node)
>         gfp_t alloc_gfp =3D __GFP_NOWARN | __GFP_NOMEMALLOC | gfp_flags;
>         struct kmem_cache *s;
>         bool can_retry =3D true;
> -       void *ret =3D ERR_PTR(-EBUSY);
> +       void *ret;
>
>         VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
>                                       __GFP_NO_OBJ_EXT));
> @@ -5732,6 +5747,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp=
_flags, int node)
>                  */
>                 return NULL;
>
> +       ret =3D alloc_from_pcs(s, alloc_gfp, node);
> +       if (ret)
> +               goto success;
> +
> +       ret =3D ERR_PTR(-EBUSY);
> +
>         /*
>          * Do not call slab_alloc_node(), since trylock mode isn't
>          * compatible with slab_pre_alloc_hook/should_failslab and
> @@ -5768,6 +5789,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_=
flags, int node)
>                 ret =3D NULL;
>         }
>
> +success:
>         maybe_wipe_obj_freeptr(s, ret);
>         slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret,
>                              slab_want_init_on_alloc(alloc_gfp, s), size)=
;
> @@ -6088,7 +6110,8 @@ static void __pcs_install_empty_sheaf(struct kmem_c=
ache *s,
>   * unlocked.
>   */
>  static struct slub_percpu_sheaves *
> -__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves=
 *pcs)
> +__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves=
 *pcs,
> +                       bool allow_spin)
>  {
>         struct slab_sheaf *empty;
>         struct node_barn *barn;
> @@ -6112,7 +6135,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struc=
t slub_percpu_sheaves *pcs)
>         put_fail =3D false;
>
>         if (!pcs->spare) {
> -               empty =3D barn_get_empty_sheaf(barn);
> +               empty =3D barn_get_empty_sheaf(barn, allow_spin);
>                 if (empty) {
>                         pcs->spare =3D pcs->main;
>                         pcs->main =3D empty;
> @@ -6126,7 +6149,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struc=
t slub_percpu_sheaves *pcs)
>                 return pcs;
>         }
>
> -       empty =3D barn_replace_full_sheaf(barn, pcs->main);
> +       empty =3D barn_replace_full_sheaf(barn, pcs->main, allow_spin);
>
>         if (!IS_ERR(empty)) {
>                 stat(s, BARN_PUT);
> @@ -6134,7 +6157,8 @@ __pcs_replace_full_main(struct kmem_cache *s, struc=
t slub_percpu_sheaves *pcs)
>                 return pcs;
>         }
>
> -       if (PTR_ERR(empty) =3D=3D -E2BIG) {
> +       /* sheaf_flush_unused() doesn't support !allow_spin */
> +       if (PTR_ERR(empty) =3D=3D -E2BIG && allow_spin) {
>                 /* Since we got here, spare exists and is full */
>                 struct slab_sheaf *to_flush =3D pcs->spare;
>
> @@ -6159,6 +6183,14 @@ __pcs_replace_full_main(struct kmem_cache *s, stru=
ct slub_percpu_sheaves *pcs)
>  alloc_empty:
>         local_unlock(&s->cpu_sheaves->lock);
>
> +       /*
> +        * alloc_empty_sheaf() doesn't support !allow_spin and it's
> +        * easier to fall back to freeing directly without sheaves
> +        * than add the support (and to sheaf_flush_unused() above)
> +        */
> +       if (!allow_spin)
> +               return NULL;
> +
>         empty =3D alloc_empty_sheaf(s, GFP_NOWAIT);
>         if (empty)
>                 goto got_empty;
> @@ -6201,7 +6233,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struc=
t slub_percpu_sheaves *pcs)
>   * The object is expected to have passed slab_free_hook() already.
>   */
>  static __fastpath_inline
> -bool free_to_pcs(struct kmem_cache *s, void *object)
> +bool free_to_pcs(struct kmem_cache *s, void *object, bool allow_spin)
>  {
>         struct slub_percpu_sheaves *pcs;
>
> @@ -6212,7 +6244,7 @@ bool free_to_pcs(struct kmem_cache *s, void *object=
)
>
>         if (unlikely(pcs->main->size =3D=3D s->sheaf_capacity)) {
>
> -               pcs =3D __pcs_replace_full_main(s, pcs);
> +               pcs =3D __pcs_replace_full_main(s, pcs, allow_spin);
>                 if (unlikely(!pcs))
>                         return false;
>         }
> @@ -6319,7 +6351,7 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *=
obj)
>                         goto fail;
>                 }
>
> -               empty =3D barn_get_empty_sheaf(barn);
> +               empty =3D barn_get_empty_sheaf(barn, true);
>
>                 if (empty) {
>                         pcs->rcu_free =3D empty;
> @@ -6437,7 +6469,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, =
size_t size, void **p)
>                 goto no_empty;
>
>         if (!pcs->spare) {
> -               empty =3D barn_get_empty_sheaf(barn);
> +               empty =3D barn_get_empty_sheaf(barn, true);
>                 if (!empty)
>                         goto no_empty;
>
> @@ -6451,7 +6483,7 @@ static void free_to_pcs_bulk(struct kmem_cache *s, =
size_t size, void **p)
>                 goto do_free;
>         }
>
> -       empty =3D barn_replace_full_sheaf(barn, pcs->main);
> +       empty =3D barn_replace_full_sheaf(barn, pcs->main, true);
>         if (IS_ERR(empty)) {
>                 stat(s, BARN_PUT_FAIL);
>                 goto no_empty;
> @@ -6703,7 +6735,7 @@ void slab_free(struct kmem_cache *s, struct slab *s=
lab, void *object,
>
>         if (likely(!IS_ENABLED(CONFIG_NUMA) || slab_nid(slab) =3D=3D numa=
_mem_id())
>             && likely(!slab_test_pfmemalloc(slab))) {
> -               if (likely(free_to_pcs(s, object)))
> +               if (likely(free_to_pcs(s, object, true)))
>                         return;
>         }
>
> @@ -6964,7 +6996,8 @@ void kfree_nolock(const void *object)
>          * since kasan quarantine takes locks and not supported from NMI.
>          */
>         kasan_slab_free(s, x, false, false, /* skip quarantine */true);
> -       do_slab_free(s, slab, x, x, 0, _RET_IP_);
> +       if (!free_to_pcs(s, x, false))
> +               do_slab_free(s, slab, x, x, 0, _RET_IP_);
>  }
>  EXPORT_SYMBOL_GPL(kfree_nolock);
>
> @@ -7516,7 +7549,7 @@ int kmem_cache_alloc_bulk_noprof(struct kmem_cache =
*s, gfp_t flags, size_t size,
>                 size--;
>         }
>
> -       i =3D alloc_from_pcs_bulk(s, size, p);
> +       i =3D alloc_from_pcs_bulk(s, flags, size, p);
>
>         if (i < size) {
>                 /*
>
> --
> 2.52.0
>

