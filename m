Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAF651099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D4D76B0173; Fri, 20 Mar 2026 15:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485C16B0176; Fri, 20 Mar 2026 15:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379DB6B0173; Fri, 20 Mar 2026 15:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 252586B0173
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:31:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E6FF61A02E2
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:31:35 +0000 (UTC)
X-FDA: 84567435750.19.DC5F4D6
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id DBC8240006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:31:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CMIWftqA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbkRvf8dXHNT8+Z5DFH3rGCT1KNnlucYGb7jKBNIuOI=;
	b=VP6M79oHgxVdttsR8H+jbCmuuObW4LV5xBPyo+MOfVKsz0i30tbLOS8RXTi7XgmLLRLqKI
	IhsvuPOcxsJxcMLkYYf1lbGB7OXSLGXtlDG1t2gB87eUsfG9fViiZOqHFhbQyBASl+QM8N
	eytZf+AEkE+Yxi9N6//UjJANF/24jBM=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CMIWftqA;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774035094; a=rsa-sha256;
	cv=pass;
	b=udaFMRVtLFJNHbAAHx9tnyTyqp/rsXkzDlqugf8dKXM1PmV6M2limGWCtQW0mmHKnf/+v+
	CJjjkD1CWXMVc7j8rFhEzONXzcldc+30WkF31oIRK75oMPfHyZE5onKndvmGW3FAWmkSEd
	fIef+b94X4RXCxiYJC6T2dMWwdpzNF8=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4327790c4e9so1521551f8f.2
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:31:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774035092; cv=none;
        d=google.com; s=arc-20240605;
        b=OGmI4CCay9PbcojRf+Tq8EKA5BGyNuIknVnaKHxY3d4VFugXaBVVgtyCu2SOjlRsUj
         YcOUt8SLy7FX3MgEfp/xPMPBU0n5UAgemye401Nc9djcuipCs4zIMPIwwBrR0xO04l4m
         iYOE0FOyKsEKptqhmiSSG2uk5zp4IgUl9kwE63ZcMse3R0ZimBA+6l43J/OREHA4wh9/
         GvXe8PdnKwfnO7mDWUWDIF3vqPLMZHvFbhKGmWn/EE1PU+4OXycyl4ToNXvI4DEobUFN
         3RDpPtu+K//up8kFOOR+79VCeBEawA6ykQUSUJTGsk5ZwdnHPAxF3ZlwF4kisjRhQ/XC
         VGWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HbkRvf8dXHNT8+Z5DFH3rGCT1KNnlucYGb7jKBNIuOI=;
        fh=6HV5oj6piVhMtlk0GAyhHLd0QWuUjip7EZuXM/71b80=;
        b=b5W7oU0ZCyYj78naGTA+VdJxbD8StBQpCfn6VimKAMtOMonAQVGgTxnTz4XqXUzwFK
         dQqhqX1+P24Ram3WPLXy7yuh64mi5RdeZ7HzgGP2LKZjXc2qK5HjKL+Y0nO4mv//Fu21
         BFMHxcv/ei4AMGdfgUgXiJ/nGw+ZM2384uKZ/Vc4puPwrjfxUzArOYXx+SyXsSfRGm17
         ZiS85ZsyoON7xfmnonDydY+gXTLDPf15WnqDfB+HQaRmpAT5+dFSY5i1HyzoEY9b8YxU
         OIVjAl5gdri5VeetkR0n6YhcyM4HQYg1RUgRj8XDPOB2Pb682BpQNAzES81bHILd6H8x
         ghEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774035092; x=1774639892; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HbkRvf8dXHNT8+Z5DFH3rGCT1KNnlucYGb7jKBNIuOI=;
        b=CMIWftqABg2Fla0BpXs2z0DusAkB+e15955g1y5gx+ltheezVO+yIeW6H5gB06Gmgz
         y95qid8X5v7cnmbyu0+OWqy5Kh6g/ankp9LZNoIO9I9zxqgLew/x1Jy1C8ki8GcbO7t5
         dh9XrPz46gz7Lv44muFLXsXejfzTFVs5tuJzHaj83yCJEsomtbCGWvdB/7kf1IfKIn/s
         eJYRBEAlXouAmEy0AvXMpjevfVgWRgtXKIu+nqnoTmghpHkOnKth0StAONhmnuyYawfh
         s60B0taLAeunuw9Ej3Lw4WopLwzQLBDlxmtv093RFP/NPT4Pj5gey+jWcVnaN4asnkEC
         sAPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774035092; x=1774639892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HbkRvf8dXHNT8+Z5DFH3rGCT1KNnlucYGb7jKBNIuOI=;
        b=RM8StcmRYk/oiLRswfG87/6YNOmO7AThClL05lXQn7VvIrteF53Wv03lmcCjmO4ESH
         aSIwqMSJsjEqkp6QP7FgFNX3ipBp5rEwLhvlyniXt+ZOuC15QnERKxIjUunyE7bQrOCt
         fa7JqREIhiPzBIZ/N3V10iWbTn29STp5LqRCjbOEMxW3C7wxppQZlrFJhmTplMsYeXIs
         mo92f1UPmrYj/YCiYkYF9hJ/igRSrFaXRBA/AP1Lg1Z71wQpEEiWr/j3qvTupHC3Ha/J
         Ws2d0G5prxpIFoZhVnETBXGvSISp8f7MJ4cSQRlVGMQyUh3LyJ9C7XTiFN80GWLn3Wlp
         NtxA==
X-Forwarded-Encrypted: i=1; AJvYcCXWCbmiDbNZXOtV6OA2imt3mJZF/5liZFSHC6jZxXhMIy0BN71Sep4w9gDIl1209wWiSvp1AU0i/Q==@kvack.org
X-Gm-Message-State: AOJu0Yy62Sme+Y+tgzbrPEKuNsG/zo65cNyTNsLKEIzy+URGHUofzzUw
	fcINZrsKbx6ft7WIkXhuqyCnrfwtHWm91TOrxcsBaxQGlaMG9MXiMuIG5mY852n1Lj3JegG3tq5
	yN2fOx+3SkQMFyuYuEH2jEcw4w3xvyak=
X-Gm-Gg: ATEYQzyr/bND/HP3nTw/mDWtlaC9kONjFjW0FVbGeIlQOC60KMnWmZ8Mn81TMTOZtfv
	niZOHfbvt9TssmIXO9vB3yu4eK7GJYUrPMldWgmF/VwruqPOsc+nZPV0ndGFqP1UgSBejsRA4l2
	349mkRaitgSBIC2dORmOcT0w6cvwAm4Vh3VxcI8EyMEaCJlDS24kcCpzI/VO5Qbu44vljgcD1aJ
	UxClixcXKka1gsWhF0/Fmn9YCSPVuvsWLhlree+a1LJG9Oi5BVkG0PG9G4oxtxWxI59ifw0xqwZ
	a4xSsq8hvUSgOhpTJ+rTV5N8A13K6JZfaae9tmI=
X-Received: by 2002:a05:6000:4381:b0:439:c550:d920 with SMTP id
 ffacd0b85a97d-43b642895a0mr7408635f8f.47.1774035091977; Fri, 20 Mar 2026
 12:31:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260320050601.1833108-1-alex@ghiti.fr>
In-Reply-To: <20260320050601.1833108-1-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 20 Mar 2026 12:31:20 -0700
X-Gm-Features: AaiRm52Nm004h9UQyctY7ABlU7eHf9ez0b8p5YwoYZiopvxwmKPoSZKZK3G1Ubc
Message-ID: <CAKEwX=PPHT-KuvjuALx6bjtTXRbJKR=KSOEJqjudUt__wv5rYA@mail.gmail.com>
Subject: Re: [PATCH] mm/swap: fix swap cache memcg accounting
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, hannes@cmpxchg.org, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DBC8240006
X-Stat-Signature: gzepjjtky8b597padesqhca3j5t6btmp
X-Rspam-User: 
X-HE-Tag: 1774035093-712937
X-HE-Meta: U2FsdGVkX19f+6GX2p+MYLWKJnRv56wunVV+1qT/qtkHT0HSNpnr2iyfSr3IzpT7ASeHlfFQxJTsj7H41Jd3IiTpFGEnUQqQKr3zo38AbOsYrbnsvMQ22APIdUZTBIYVwOhvWOrOO81TZmbuHy1W8LB0+2lKUn4QoOiJ2aHzx7Mc4k1f8TfJIeVSKuqJj8azCInhThCFD3Cmv15CWHD5U6AJmD+zHptU2YzBtySwO59hAZQBdkHblX4FBgvAi788YlO1jND5zbgwHnahfi/79wdGJUT2hsmzRyYcKaFdwQZUUvSUUU1Yb2NrFJh62vpUe0gtJhShuJq3vBANfPjtTQbwVLVJTug0gxAViLErFsyEqo3dGRy9fMUtOV+fLPVQ7WpJSjLBEre+pLzXeXwRxRzVEWqfAuxGWMJUW1EpGZcZoJkVl0SNTRelwvg3gVpoQIHoLSTqfJ3/802breM1FZlAYpTewUCUoyT75NkMYNnOy2PpPbojlZg97Ag9+7/jFgjkPeH8bWJ7TwXxf8AlGxXWTVaAf8r5yZS85aAZLKyYoY0HzUeF95Ab84HvfwfM7bPZaHB6ECeID4/4tNtIMyiUs/Tw0WZGGMfrTvqEWDIKDDRPi/hKLwjSHGdDxwVfgxWAH4G6auIBYeXaQiwXOEUdIrcgY9D8UWiJh5T/20QvBq5BVrDVBAQGuI6WfYhE0zEcY5CRhtdm4LyJaAe0QlFaOhvEZR7XLMOPISicw8UA+EEBie01DjE4WiI8XETCpItu1p0fxo9IqOyS0sfOV3/SoKIm92ZEtYzNyiXP/+loYdqHfx2eWHLmvTBiACTAZTR0PCnZG4Ddo1eQZAemLxb8ngWKj3KUY/WYSNgCqzHxKTiDoKK8TKaXQH+9vBhz0MxML6coxH5EnLDX9GCdykOWZVq055LqK456tbgIntyinDInHOauH5jWlZAR+G+ucLseFWuyISJsHANM6Qg
 /D3ro2K+
 7xtroBJMpJItw5qFyBXnUVDGZKujiUevcE1c1L/V6ndzDwlLSmHWCsnjlIo+O5wETCn0klwBcF0dtvpEUw4O5h4XRiVe37G2fqKPYjVspJP0rn8nvzjiO22GmRg9IBXDV/NZyZSfvSleFCmTwG4dA6YO1heDKKU/YEb8N9KPPvCUIOB+6o+QlxTNM4aKoGYmKtDkSVpWD75/6LuJB46GQH6Ao+FaUdnj5QnIkTsRAB6hLixoTmj/uxeeoLL1aIWr5DJiwrgonSO0rs+/BVDyfta7vwRXiWA4GflZVYszKEJ1yKkbI5x1xUEzPCyekJjaoTxwSG0pIaBblaZmZkhU7CroK/1VgZ0535oODxHVfMsDkBTcdJyoPZLBsmWaCzE52Q1+6wxcpRXTqdEyuHry7Uzm2L7NClnY8tRM4VYlztuss8jo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 10:06=E2=80=AFPM Alexandre Ghiti <alex@ghiti.fr> wr=
ote:
>
> The swap readahead path was recently refactored and while doing this,
> the order between the charging of the folio in the memcg and the addition
> of the folio in the swap cache was inverted.
>
> Since the accounting of the folio is done while adding the folio to the
> swap cache and the folio is not charged in the memcg yet, the accounting
> is then done at the node level, which is wrong.
>
> Fix this by charging the folio in the memcg before adding it to the swap =
cache.
>
> Fixes: 2732acda82c9 ("mm, swap: use swap cache as the swap in synchronize=
 layer")
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
>  mm/swap_state.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 6d0eef7470be..48aff2c917c0 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -494,6 +494,10 @@ static struct folio *__swap_cache_prepare_and_add(sw=
p_entry_t entry,
>
>         __folio_set_locked(folio);
>         __folio_set_swapbacked(folio);
> +
> +       if (!charged && mem_cgroup_swapin_charge_folio(folio, NULL, gfp, =
entry))
> +               goto failed;
> +
>         for (;;) {
>                 ret =3D swap_cache_add_folio(folio, entry, &shadow);
>                 if (!ret)
> @@ -514,11 +518,6 @@ static struct folio *__swap_cache_prepare_and_add(sw=
p_entry_t entry,
>                         goto failed;
>         }
>

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

