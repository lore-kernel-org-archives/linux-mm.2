Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C59F7D711CE
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:49:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326E36B0088; Thu, 18 Dec 2025 19:49:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D46E6B0089; Thu, 18 Dec 2025 19:49:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6A06B008A; Thu, 18 Dec 2025 19:49:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C46A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:49:52 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B403C160395
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:49:51 +0000 (UTC)
X-FDA: 84234388182.06.E905136
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf20.hostedemail.com (Postfix) with ESMTP id D860A1C0012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:49:49 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cPygPwAk;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766105390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPMTFpj+poxx7/zDrrH8L2s3ujEnA65Czi/amqx2WSc=;
	b=XVGyGmjFo1HcS5XPOabSfEyiU2YoOylmr7svOZdMb9a7RXTuabYbp01r8Cr2UEUPFy7ZjU
	arV56crCiFQb6UtmBDM5fvZ/wlb1sI+kueUCiThQIseIVK3OLXCN0OPXzQQFC/hKZO5VIN
	zF+H8z3AzAU/9mGW5gG5IKWj3lPh5kE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=cPygPwAk;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766105390; a=rsa-sha256;
	cv=none;
	b=RVrDKTJqfl4MJIoathzwl2PFKk6/2vsssDWxcSbjFv/4ulklvSs2PkzZAZCRnsoYgxTBI5
	pAdIE9j5TOtKLBwHkaMPravKcruDJ23mey5vE4ivmr4WN1oNKNWMbvOLblw8vpqFet/sfW
	l+OBmKBHIyJ3W61/IqJR9Zoe6ZJcccs=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7eff205947so161443966b.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 16:49:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1766105388; x=1766710188; darn=kvack.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pPMTFpj+poxx7/zDrrH8L2s3ujEnA65Czi/amqx2WSc=;
        b=cPygPwAkoGiIxhmktyg2Y3smMa1/lQLo9xQBw+RkNeoxfZ5cA6aSTbuMK1+Thvlzrg
         E/JswRBYDgrhZyVz2dEy+KC743h4PY/r13EetnvkXWewYoH3reEsd1hWyDAF9WKvPinj
         /m0nhRDypWmvFT/wRfC0wfdAvsS2Dns9iABFG842WXcUC21xJYUOzIQxgYgY201M+IDH
         RAf9sz5CJn3zp0R0hIqEyMnamIA8PmGAzSFr2f4Pv4/aXp9gTGSr1KRSumfg166023+F
         xp0QJzN6ei3szJ+V1u0riwRtIxz6OoDOM1kpH827+G7MIZIBoQSzLiy25bTn7fEtIYBT
         vBgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766105388; x=1766710188;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pPMTFpj+poxx7/zDrrH8L2s3ujEnA65Czi/amqx2WSc=;
        b=DLeQGJE4palIsqGv+3K6q+M7bvS6HSNE+mQp9wowikgJFb+3nCuJAsLNRwNlFIrN/Z
         otQQl6mnSYsUMamlKwpB32d9AZGI9cgyKVtVwmDG4ide2IT3px02YyhLOS+oI/lUBc/5
         jOM7fd7mhBdher9uxGkdYeeuDZOWzAYYdaOZQzNnwt3sgGCjBs4AxPqqx5WbnkCJUNQQ
         Pvo3zmE2HV452IGTDwtDGC5mz3Jwp9GLseZCcoNjHtgd2b3GGtLvKhciriChcYEXrBav
         qNeSFAlDLvW68QNai8dt2++IpWWMnk8/OhWhN94injCdH8QAMCsElywEKoMsYNmQcUvB
         RCKg==
X-Forwarded-Encrypted: i=1; AJvYcCXL5VlLPiJtu5TrgAS15DtTlUzGaUD2aqyrpOyqECxWrC+Y1MHqbLioXWlmbcZ9Y0sB9hsqSBuScA==@kvack.org
X-Gm-Message-State: AOJu0Yxp6i3ShnYRmlIlpF2eG5A7LgGjZKXtBZ/pxcC112Z5cHXEo9ji
	5gbWQNKUEEwMu1qUMJv44DCWytQ/ANw23GJhL1cnL7R2VsRcSac9B27N2zC0b+1+bPayJpg3Rf5
	AyYdqKBmlt4vmaVp2aBKhG1P4xiLBzyd3Y575/WB4MA==
X-Gm-Gg: AY/fxX6z1dmvPxcMZcDXXkLqkbfJjs7ejJrrjQmjY7qGsB/OQMFSYffUtgTHpbre8OJ
	M1d611pk/sxjpRPPfDyhi/6RT4n0iP1aYVxaaE7aVjknL1loe8tCfCrXgR5im2xLM+HYD+fblFD
	DDvqW2keORGlFoA0Juwt3cWgz3RAcApFhzhGGXqFOXH1afcn70hHP4I+iEzASkaBPNLKKTOp+eS
	vshYeBR0t4FWQGrDUsgI7wCfxTDcAmzS+h8P7X5iAUu8fKz0PTa+ZkFOLrgaCjygEyjwSU87s4U
	gIW0UxCo68+agj4Ip2t92U9r
X-Google-Smtp-Source: AGHT+IFB1lgQ1YjNGIl9apVtHHzkGNQp5uVzCBPF8ZQ5DIWyfhqYrC+pX3LC94u2npkioZEPfhq0exsjKwkY/tYjlsU=
X-Received: by 2002:a17:907:940a:b0:b2d:830a:8c01 with SMTP id
 a640c23a62f3a-b80371df334mr119522866b.61.1766105388247; Thu, 18 Dec 2025
 16:49:48 -0800 (PST)
MIME-Version: 1.0
References: <20251219002355.3323896-1-pasha.tatashin@soleen.com>
In-Reply-To: <20251219002355.3323896-1-pasha.tatashin@soleen.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 18 Dec 2025 19:49:11 -0500
X-Gm-Features: AQt7F2rlxzFwIQ7bazt1PzsJXWfqo6q4ieEctRpffjsnqxEr8sEh2wU5NyY4J00
Message-ID: <CA+CK2bAOMooH+NE5YanRyfK0KraRug2VHT_M59UpbiD5T2qu-w@mail.gmail.com>
Subject: Re: [PATCH] kho: validate preserved memory map during population
To: akpm@linux-foundation.org, pasha.tatashin@soleen.com, rppt@kernel.org, 
	graf@amazon.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, pratyush@kernel.org, 
	ricardo.neri-calderon@linux.intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D860A1C0012
X-Stat-Signature: jzatgxtmdghrjppfxco81bnu7fgh4fdh
X-HE-Tag: 1766105389-511501
X-HE-Meta: U2FsdGVkX18YYJhf2tGjj549fcy9eZevYkkqhMKsILKFP7MFuyJIPOhNPjW3s+1plzr71vEXGt9s8FiW8wVnZVF4afqYsQ4RoOOgXBckhmkBW1lgb7bx5mrWIon2xhEXHum/rSVovY640zqt19SSoduo79CNtp2kqRu3iaQEPqZxdVOajmmFvcVdyFiz2DZzOnQIDMMNDd3zOLaYD1zaBFwa3THAF1DlLjDBc+1YpJx8ZQWCBseHAdPX+JW4ZCKXm3iHDAOFx3epswU5vtdk4vC+z8XqWRh6XdA62OjkCOVtx5/E+heYuzNkenyoSBVd7zr4w76+KGZjhtxh9AvDOS9UPBMvi4j9SqCSaya0jvexbX/sASS1tpNRNu8TrTO36SHLJ35lkbbR0dFMtOe4auuw+X/IxIz6VpUeaToayt6+FpdKCnuNcWkXUe1BxCyIykSqzBS0din1sfwJ6HDVqBMpschDiuAoDxn0HVQcwYPC/1wo6xutTmjjhzUgJUFMG8fOjt/Yg0do4GZc0O27I8i33/bo55F4uS4VexG05ok8ActkaWODNMEYS+ohS+lxJSWDm6lhkzsIVFCkrI2IhAX7R5oVANTbIU6GhROVQx42ISzOESDNIElRVfDOpthEAPCS6YPV6plogRlbtfmDZNZvAHsvhL/Io7XQioQRXOjN9XZV3LtOCaSeITzivhwAZnuq+9dK1UeseIoc4MnGWDA9wRFzEp+yjU9Va273yTreuLTy3a4CwX11aIkUSMcSdDiaZrpp5U/59KiqgMwop+c2laUpoM9CD9r6BfwWszkjxpvxRInKJHlqaWwMsGhoGd1/wP+B7mH6C4ibd4ODU1nxOFQWJrC6xeAAxC/tzWZxw2tbM9UcJfr/0zMlw8HQgJopNbWhfCisWkeHc1NivaESCOWUGFbO+t3mtEXTVY7kmg798WSURNwg7Yz4wGwYxW+24rEkgDuOym7E/H/
 WFW/l1Nj
 tLPa0ZriS8BHCKaRxzvW4jiha+v6DAZvtq0ckgVOBbcsXx7IvzS0utCcSt7fQJMKR4g57BfHy80KMBFhfduXFCUEnymepXb5TDLhpfneIyOGAHl6zlQ7n464/NC/qjpG/ZmDQFIq4YzPTRKeK4+6HKtbFqW0qE3KiCcTCJdyvX5025UN6jdWl+DQR+pnCq/upoQo6KxpGGeIgvD+JXoQVlFs48nVM/qciRSRWi70xl7W7MEm2xsFiHRGlhAgnTJ2/OdfB5vhvh0wjeU5mENirtv6vVi02Y6oSd/BOXUgNPGGRCO9yLVkQcwNZEW27vaGo7euA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 7:23=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> If the previous kernel enabled KHO but did not call kho_finalize()
> (e.g., CONFIG_LIVEUPDATE=3Dn or userspace skipped the finalization step),
> the 'preserved-memory-map' property in the FDT remains empty/zero.
>
> Previously, kho_populate() would succeed regardless of the memory map's
> state, reserving the incoming scratch regions in memblock. However,
> kho_memory_init() would later fail to deserialize the empty map. By that
> time, the scratch regions were already registered, leading to partial
> initialization and subsequent list corruption (double-free) during
> kho_init().
>
> Move the validation of the preserved memory map earlier into
> kho_populate(). If the memory map is empty/NULL:
> 1. Abort kho_populate() immediately with -ENOENT.
> 2. Do not register or reserve the incoming scratch memory, allowing the n=
ew
>    kernel to reclaim those pages as standard free memory.
> 3. Leave the global 'kho_in' state uninitialized.
>
> Consequently, kho_memory_init() sees no active KHO context
> (kho_in.mem_chunks is NULL) and falls back to kho_reserve_scratch(),
> allocating fresh scratch memory as if it were a standard cold boot.
>
> Fixes: de51999e687c ("kho: allow memory preservation state updates after =
finalization")
> Reported-by: Ricardo <ricardo@example.com>
> Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.s=
c.intel.com
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 36 +++++++++++++++++-------------
>  1 file changed, 21 insertions(+), 15 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec=
_handover.c
> index 9dc51fab604f..96c708f753d4 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -460,10 +460,9 @@ static void __init deserialize_bitmap(unsigned int o=
rder,
>         }
>  }
>
> -/* Return true if memory was deserizlied */
> -static bool __init kho_mem_deserialize(const void *fdt)
> +/* Returns head of preserved physical memory chunks pointer from FDT */
> +static struct khoser_mem_chunk * __init kho_get_mem_chunks(const void *f=
dt)
>  {
> -       struct khoser_mem_chunk *chunk;
>         const void *mem_ptr;
>         u64 mem;
>         int len;
> @@ -471,16 +470,16 @@ static bool __init kho_mem_deserialize(const void *=
fdt)
>         mem_ptr =3D fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
>         if (!mem_ptr || len !=3D sizeof(u64)) {
>                 pr_err("failed to get preserved memory bitmaps\n");
> -               return false;
> +               return NULL;
>         }
>
>         mem =3D get_unaligned((const u64 *)mem_ptr);
> -       chunk =3D mem ? phys_to_virt(mem) : NULL;
>
> -       /* No preserved physical pages were passed, no deserialization */
> -       if (!chunk)
> -               return false;
> +       return mem ? phys_to_virt(mem) : NULL;

I need to update this patch, phys_to_virt() should not be called from
kho_populate() before KASLR is initialized. This causes a problem with
my live update test. I will send a new version soon.

Pasha

