Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85E9CC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:21:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9118C6B00D0; Mon, 13 Jul 2026 12:21:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8B26B00D1; Mon, 13 Jul 2026 12:21:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FF726B00D2; Mon, 13 Jul 2026 12:21:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52C556B00D0
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:21:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D43D8C7AD
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:43:54 +0000 (UTC)
X-FDA: 84984173988.14.11CEDC1
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf30.hostedemail.com (Postfix) with ESMTP id 77D3080005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:43:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fcBkaZw+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783957432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QtnS5j73Md2b+CYCqhf1RAJWb4uYUtGnxE+42jWpObQ=;
	b=cTqdEPVRwtlZ09UjFOFSzad5onlJNWpTSyoXaFld7CTIUz8VDqHotYBiQj2/5cHk+jTKQQ
	I8IZ5XuIgM4NK8F0p887XqPXzmHgnzEUSKnIa37y7JSDx+Ti9mpmNmMOatoBf7HIgD9Y/D
	IPj3b/aRMb3Ldbx5E0OWkg3zDM8905M=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fcBkaZw+;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of surenb@google.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783957432;
	b=gkV3xoUzKMZLqfyEWSW7qMny+Cylswq1I5SD83y2ok23AjnjRci9fs/ZTS+m3o47IREzvk
	5QuTF6Wcjuq2ywMg8XIQBdmy5Kmwl4rJzPbEpClJhy31vOGlBIEMVm6PokRfjV6jfXtQYE
	3BWH8QlAw8tcvuIHQEdo/SW3mWf88Eg=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-51c01c79467so540501cf.0
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:43:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783957431; cv=none;
        d=google.com; s=arc-20260327;
        b=gACnSNLjDMpfiiuyStAFSU6yB0r7dzql/QnIGddmylQlEAKNM8arjGxVk4crKNWHKE
         0sliwxudxxdz7iDeTUXv5QXP5ZzoOpHR6OwJTEjBheKXnw5sPkz2/kQaY8/RgcAsRlIQ
         BFwQ1vXWWb84yJsDmIIRVwjk4bo5Uy3gyGgIWx3Bwl3m/zzr5ZUwC7KASXUwTVmJ/U0E
         JLtFyQm/Fz8YomJLko2VbVLgAnlOWLXa25fIFFOSasJs9b5UbxoDTwapSST5+o/kkEnD
         Fk1OR/hk1RWMLm70IC6V+RN4n9q2mp+/7/vnpVnGR1RNYDsZv0lmfP6Uuz3WoN1fp4Io
         0J7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QtnS5j73Md2b+CYCqhf1RAJWb4uYUtGnxE+42jWpObQ=;
        fh=CTHWJLhoLEJE2B7xEfYYmnQ5jvu3KXcbBAmG5kQQKDI=;
        b=NTwd18anM7hsxHOUMbLeOl2nqIAxyYMPD6fUBZCnGJidbML8bQCzHh4Pzbc/VY3fXE
         zZ6M8q3mKdcEgNSJhmMwQ1HR1dNUiUJsnCVHq+2ASc61e9DfHB4TxzX0FhOCyTP+sBQs
         RB0MCbpRWWD4R5ANK+FhMfVdXSBJjUBTM+idmGxim6jlh+sMJ7+km8EWqvocdpGVX63Q
         to56EiuHKln7L4iiBkzGdRvzgis3OkQgjR8nlQ0FIq36rZ91JjTC0LFdvT2/ip1wA4Hb
         lb0d1nETm9jATKhIUALzcW/bDa2HfF16Q+pQIWZbC1IYILY7dVA3wzKr9nEc41ACn/OT
         jYYg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783957431; x=1784562231; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QtnS5j73Md2b+CYCqhf1RAJWb4uYUtGnxE+42jWpObQ=;
        b=fcBkaZw+rRA22WOSu5Bk9JC2m3/ZX7Jd2gQCwldxNKKB0DyBwZevXXSiq7rbxWDxWn
         xflwKaNp+ntb+SavgsdrjD+UMtp6Uhcxd7CjGBGHdtGdiyhaEGtBNxw6U16K3HFmjX06
         lJjaWbeZZ1/9qegdyeevzswo6Jw0YpzLeev40OUMTzK3UwdpV+9o1HV1KLHCeJVF1wc9
         IN5ZoOmMbdB+yVhnhwBnM7k5Q7OaNjC/VJQteuQWFawo7Abl1B0GvjvqBQIl/WB6qErU
         LzRlzff3RiSnPMaCvqMhMSZqVkqFRmX7QN56zjfUimMdH2/czep7eBBNkYZRGAVWCvZp
         dJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783957431; x=1784562231;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QtnS5j73Md2b+CYCqhf1RAJWb4uYUtGnxE+42jWpObQ=;
        b=fQ6WY6fHlUSDHMgX/qG3B4ebCLQBKowRQv0N2sVj09Qv1Ctz1NQKI7xHg7oJj2tvD3
         csUOr41RXhRLCok+A3YtIZQ18+Fij5gt1p4f5wbPPnAwWaej7IU+UHU/kae1Gui86Of7
         LTkmGoHr0LqqVbtJeZSug+QPFZ2i53/LyJM/vPtBh1g8/WrujbxRr3w1Llns0YbnZnx4
         XbD8opdBPIErsMpwadqV4CLyvEKvg+QDlsqDfng4uE/3PnTOaSTUYv9vF3dClHP8F/Io
         EvRwYevWhMtCFTKdAF9fItTe49q/klQNHJKozmhWKNJDIRTtK78ChdItRNiapF5izcWX
         Pwfw==
X-Forwarded-Encrypted: i=1; AHgh+RonSjXznrikXqk7R6gGU3pQE2vNXsle4EGth1qhe8VZ8QDPSoz5CpA0YqvkKSJf8l8LM36ShXYY+w==@kvack.org
X-Gm-Message-State: AOJu0YwUzZIqsj4IRUxXnIOwCH75O50LQJOLnq/It5BLURhR2HdcDAR8
	mBAROsFgbF+h1Q7OHK8wxf3PfoaVgpTfMT6N+b6qs2X+OT0exazPloXYul2ZKhScitoTzsoAEwQ
	I5YRtil0daMu2dxczJ/kkYiNtsCu0RJdhBijxkYuI
X-Gm-Gg: AfdE7cm/C7fyEfxNUMR859xpNP6owli0taoaH7s7hLdNZ9R+7NdQse7gcgPfOyh6Pt1
	D/1uSVuLlc4qRKWQFdL/bkHeHV9kX31jCS6+a3IszEIDgdftNEMv1In9id6DYArBLc0Uc6q/x+R
	2AMue1A3okBneyDRuvH8OiHOoiMX158fuCBMtAu2iE5c50rDNz+mUem0RwQuAmLVHdqnFvig244
	GcPAGSxxNeqRXZCnEFUM9bKoYZFSfqDCJdAUzk0y8TPBp7S+PSImsLM3o2GeWQA5Fi16ok=
X-Received: by 2002:ac8:7d03:0:b0:51c:104c:100c with SMTP id
 d75a77b69052e-51d71546a1cmr3911151cf.2.1783957430248; Mon, 13 Jul 2026
 08:43:50 -0700 (PDT)
MIME-Version: 1.0
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org> <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org>
In-Reply-To: <20260713-kmalloc-no-objext-v3-3-47c7bd138de7@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 13 Jul 2026 08:43:39 -0700
X-Gm-Features: AUfX_mzLEB8NfNv7Xm4uLeWvdWRunvEZ_3v9jckuPa5s8f10ZJE04qNWAFqK6Gw
Message-ID: <CAJuCfpG=Dk6PRWy-8wR4j0UreSsa=fdiFWvBYpOkSZE0zV2Z4A@mail.gmail.com>
Subject: Re: [PATCH slab/for-next-fixes v3 3/4] lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, Hao Ge <hao.ge@linux.dev>, 
	Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Danielle Constantino <dcostantino@meta.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 77D3080005
X-Stat-Signature: fz5weh75i8if8uyhw386nzaqho49ia4o
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783957432-834920
X-HE-Meta: U2FsdGVkX1+6pGHZYRDX/ZloK95g/d8h5n4dku1zr5e++FokAETrm1A2akryGW/nmCRbKj6lloskMuCwjAw79RZnF2h+osDMuovwmg9cbb+JHYY9265zmxpjY2R3zE+CvJy5k5zhGpliLSpWa8ro2VyDmv/+bGGM1s5V/oPQMtDmzICvh7gj8JnaDUE7rAIQu+n8KWpg8afZ/GPzdwrAuhcuCxlMddCm21aO886naM7gPwxOzTA3P+/50+FOLzmU5Oq/uwPlFaOpW7jIRvOyF1JMlhQWljB+CvsMT7UM1J139rM1e6YRHT2G0qgPqOPDaNS4iTMNmIygMbIzlk0YCvR6KcmIvYyzlBsAT9THoV5Ym54NJv7xACtQfRvm5uDGAzNyObNse5cybtCiz3JEraeBkG+ymy3aP68/4AQkxxTGXfs95SbKKTcYay78dwd6gEBitw9QQVW+xtdZd+cPIcO7ZIuwBaDHvmDtYuXxYv1LhXekfaT05PSR389MrP+lTewbtpSlBes2Qg1mm/++rjVoYSjUHVvXNhfXWRZtgpm9tnFq6hSo16SgdVhIZRM+x1hOWxso3ZiSu3z3G8KUTgF0OteyU6xpVpyDcP6hm/vCu02rXLLC00hfvOTcjWKu0BjEbI9NcDxRSckL3HuWFJg93zJu00cj8lRctFHcuwKlp/K8/ikCl+xoPgHtPRMA2M7CIYmO/PCWBVHiw6Qlb35Vla1Lrnwbvp5tL5Tk6ewaK9xDNc47v9Zk2kAwp6JhWhaN13K4qjgSHgplZN4demnIY0iJxzwOkRd4zMYDkaSxhmqEeEuoJHo7zbD3s6QSs4UfD2SpX45qPx68dt4X6KPr8ic6SdIzC4YRkFbWZt1BnOsxLV95d2fZsCjSt0eHgiFlvMsB5aiowyAVMNSH2xP9FZ35YHR3kO856Iyl+VQbAYvoTjDC8/l2kGScabVTVgYxjZ5qF9rqLDbeyIx
 JsIUwyHY
 cqyyOEvjj28RoiBF0Hb6jCmfsgXgB0r1uWwszUWGgtUirXoZNhLLpWIQCGgVNsSE6ASZ38h0S+BR5bgXdyXiNRe56thgb0HQlPUIO/kTJtjk0UKvA/af2eUWVhTaqOOR/DBS3e8QV+NlExg/4IzLdFzbwC4uiyaIerGmoGNlmX7DUzYgokIQWVkwnc8dEJou5MaLWoevqMji8TDR2y+FpfD/QGfsIylz1Dt7VQekMz96j5ue8QtJAuQgYyYL8L9knKjhmX626+Uq39OzXyAs3zBl2/Bzz0zQbX8IhfGm3GwYMxCmGKPJOBoOf5hJy172zAS3diAabc/A8bEo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 7:29=E2=80=AFAM Harry Yoo (Oracle) <harry@kernel.or=
g> wrote:
>
> mem_alloc_profiling_enabled() tells whether memalloc profiling is
> currently enabled. However, even when this function returns false,
> it can be enabled later.
>
> However, this is not enough. Some optimizations can be applied only when
> memalloc profiling is permanently disabled. For example, to skip the
> creation of KMALLOC_NO_OBJ_EXT caches at boot time, mem_profiling must
> be set to "never", "0" w/ debugging on, or have been shutdown so that
> it can no longer be enabled.
>
> Introduce mem_alloc_profiling_permanently_disabled() for this purpose.

nit: I would call it mem_alloc_profiling_supported() but this name would do=
.

>
> Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab alloca=
tion and free paths")
> Cc: stable@vger.kernel.org
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>

Acked-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  include/linux/alloc_tag.h | 3 +++
>  lib/alloc_tag.c           | 9 +++++++++
>  2 files changed, 12 insertions(+)
>
> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> index 068ba2e77c5d..6ed9f82e639f 100644
> --- a/include/linux/alloc_tag.h
> +++ b/include/linux/alloc_tag.h
> @@ -134,6 +134,8 @@ static inline bool mem_alloc_profiling_enabled(void)
>                                    &mem_alloc_profiling_key);
>  }
>
> +bool mem_alloc_profiling_permanently_disabled(void);
> +
>  static inline struct alloc_tag_counters alloc_tag_read(struct alloc_tag =
*tag)
>  {
>         struct alloc_tag_counters v =3D { 0, 0 };
> @@ -239,6 +241,7 @@ static inline bool alloc_tag_is_inaccurate(struct all=
oc_tag *tag)
>
>  #define DEFINE_ALLOC_TAG(_alloc_tag)
>  static inline bool mem_alloc_profiling_enabled(void) { return false; }
> +static inline bool mem_alloc_profiling_permanently_disabled(void) { retu=
rn true; }
>  static inline void alloc_tag_add(union codetag_ref *ref, struct alloc_ta=
g *tag,
>                                  size_t bytes) {}
>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t bytes) {=
}
> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> index d9be1cf5187d..e5b218176c5a 100644
> --- a/lib/alloc_tag.c
> +++ b/lib/alloc_tag.c
> @@ -26,6 +26,15 @@ static bool mem_profiling_support =3D true;
>  static bool mem_profiling_support;
>  #endif
>
> +/*
> + * Memory allocation profiling is permanently disabled and cannot be ena=
bled.
> + * Must be called after setup_early_mem_profiling().
> + */
> +bool mem_alloc_profiling_permanently_disabled(void)
> +{
> +       return !mem_profiling_support;
> +}
> +
>  static struct codetag_type *alloc_tag_cttype;
>
>  #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
>
> --
> 2.53.0
>

