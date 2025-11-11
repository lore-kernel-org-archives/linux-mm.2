Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7891CCFA18
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 09:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2588E0007; Tue, 11 Nov 2025 04:14:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 053128E0002; Tue, 11 Nov 2025 04:14:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E842B8E0007; Tue, 11 Nov 2025 04:14:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCC5F8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 04:14:37 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D4F41404B9
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:14:37 +0000 (UTC)
X-FDA: 84097765794.07.8B3E618
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf02.hostedemail.com (Postfix) with ESMTP id 831EC80003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:14:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XTZhNvG6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762852475; a=rsa-sha256;
	cv=none;
	b=fotfvNe0lA0Ga6hpr2Ics0VEHWgAEXGXRN6Au1PVxenApyUtRaV3kbegQPg0zmib9hAuuW
	zF9KIkVVxR0cpYjqRkuSufzKCzvq0fdKp192E9RQfgaXcfR1VGoRN1772nNqj/XIpFXyR/
	IxU8gpNIQkH+P8a4ZVwVQbkry05utZc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=XTZhNvG6;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of glider@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=glider@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762852475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZTy2q2TNTCA3OHKdlCs5XdCV4IXpZdhN+lpNGYPqtA=;
	b=KHv/hl8lrPPjILmRWNl0JoSyYqLe1eLM34H4AJpHOURdOaT4fwxV2qz65NihNGJosVee67
	N/FSQDdtB45wLMokhQIwDp/o+AKl7Q/2zF0nBNCteey4gukrlo8A+AdFRcOAl7V3IkoC77
	iHXq+VgL9xegQAAPxGbiHpLHcCjEUEU=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4eda6a8cc12so30684271cf.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 01:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762852474; x=1763457274; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lZTy2q2TNTCA3OHKdlCs5XdCV4IXpZdhN+lpNGYPqtA=;
        b=XTZhNvG68VnFagQZPVUKHDzen+7EaC/cb6BI6goZKTZrpTGYza/WbpPBewxwIWCB0K
         QEkldrQ9x97gjY8e1kR4/Z40OG2gk14KMVf/5JalpEyQb0O015cBXe54HX7HibI3RM6r
         gre/0JAL6IayTByvifeK2FcnwDjHUkvWE5jqdAEyQgUCG0cFj1KFaBA9FrcD9El7kLJV
         zDsoV8dJl36Vn4Y6VI9L3IuQEORsjPvw+O//Bdf2MayPeolAHsR6wnQTP9skbBpOz71m
         fH0RhbcDGVGiH5gp3M0ULRsj8GYbcBdhTx+ZrilR/Z94LtJbXO9jObePEVeRVwTIsD3p
         gkCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762852474; x=1763457274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lZTy2q2TNTCA3OHKdlCs5XdCV4IXpZdhN+lpNGYPqtA=;
        b=AiuwJEeV/QPYmEg8A+N8TWaTV4o6O6tH7gohKVFC/4+kFR6otVr9+ZWA9oNviG1DjL
         HnbePYhD3Nk5zttbn4VNy5Uqgxtcd8zcQOx2zCQmxcrOzLCNDiHg7Z37w28ikDSDz/oe
         U8v4NYruy9fnaGUVuQEQzmhpxbhvJ5PmTlVLEuFESzr6zRDr9G1Iz/tweVan07pBNm4A
         0kznil7j5JXKCKKjxJFiBz0yhlNSmKgR1oFAEmJoSbkhfg4HjnNTypByF/Iw54dA9EsF
         gglfZpHA80eBw+4A2RsmhhjeUTAp373XefiqnP4emCRn2Ihto+C/EZWvYMFae+nfp2Ms
         sq0A==
X-Forwarded-Encrypted: i=1; AJvYcCUOJv1x8XNTni74nStQiO8aSxOwnZ7YPSQBNt/e0me1TMdgJfCA8orgCYymAj4hf7MoqkZ3va5vpg==@kvack.org
X-Gm-Message-State: AOJu0YxG+nK5y4jsNSuoyikIgiNBHi6nX847+VJPnaZq4CiZ4UPwZA94
	r4YzvcBqDFAI7oyQ3jbC0zGKlFvspkiqaHAn3zCtVRdFLKVSnpcYJzXI16xpqN/Wsh12rpE5lyb
	bvE3tRRexcHaSEbfZzaiLlXZh5y3jp2oFj9PmbEH/
X-Gm-Gg: ASbGnctYTpKZfdntC3yLWLGVfwgqNS7tcCdAXN3D1tuRh0Ge2BaKXSQPVkxtqwSaEcY
	K3mBkRj2WBb2RC8q8BIK2W2OHsONOotAnvIx0Hhho9FjtFTxQGPLHzm5lkLJVRCSTYKhbf0c0VX
	BUoSbcExBDbb9SZBI7l0IpTmTZOFJ7wG++0Bs1aNFUPxB9znlgCIUjM9Nm9Y/i+XPcIJPHikK4R
	MKN8sWj/6N/fpcpSJCz8aVZXiyzTL8kY/BNW6lxoyHvUrLe2m70J9qlPGB1+JHfRAmeAYzWoak6
	MaaoqtQIb8ArAyAi1myEUmtlhBSVuRe4bGRg
X-Google-Smtp-Source: AGHT+IFHyI5tV3uPkHfzZQDwtLCu1xXfZdNpjQHEIN8gqbseljKndHdCHWJHLu5LbqQguzv8YlVvlOC2YwOH7fkw7n0=
X-Received: by 2002:a05:622a:205:b0:4ec:f151:6559 with SMTP id
 d75a77b69052e-4eda4ec1851mr145606591cf.27.1762852474078; Tue, 11 Nov 2025
 01:14:34 -0800 (PST)
MIME-Version: 1.0
References: <cover.1761763681.git.m.wieczorretman@pm.me> <d6443aca65c3d36903eb9715d37811eed1931cc1.1761763681.git.m.wieczorretman@pm.me>
In-Reply-To: <d6443aca65c3d36903eb9715d37811eed1931cc1.1761763681.git.m.wieczorretman@pm.me>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 11 Nov 2025 10:13:57 +0100
X-Gm-Features: AWmQ_bknFBa8gAhB6UE8n7ZlyUgSKcguUN9eypJruwNRSxK5vCFPizbRNuQ2qaE
Message-ID: <CAG_fn=V4jVyS41MDxJeN-A2zk6WhTnxp7m3FRWmkXMpy5f+haA@mail.gmail.com>
Subject: Re: [PATCH v6 09/18] mm/execmem: Untag addresses in EXECMEM_ROX
 related pointer arithmetic
To: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: xin@zytor.com, peterz@infradead.org, kaleshsingh@google.com, 
	kbingham@kernel.org, akpm@linux-foundation.org, nathan@kernel.org, 
	ryabinin.a.a@gmail.com, dave.hansen@linux.intel.com, bp@alien8.de, 
	morbo@google.com, jeremy.linton@arm.com, smostafa@google.com, kees@kernel.org, 
	baohua@kernel.org, vbabka@suse.cz, justinstitt@google.com, 
	wangkefeng.wang@huawei.com, leitao@debian.org, jan.kiszka@siemens.com, 
	fujita.tomonori@gmail.com, hpa@zytor.com, urezki@gmail.com, ubizjak@gmail.com, 
	ada.coupriediaz@arm.com, nick.desaulniers+lkml@gmail.com, ojeda@kernel.org, 
	brgerst@gmail.com, elver@google.com, pankaj.gupta@amd.com, 
	mark.rutland@arm.com, trintaeoitogc@gmail.com, jpoimboe@kernel.org, 
	thuth@redhat.com, pasha.tatashin@soleen.com, dvyukov@google.com, 
	jhubbard@nvidia.com, catalin.marinas@arm.com, yeoreum.yun@arm.com, 
	mhocko@suse.com, lorenzo.stoakes@oracle.com, samuel.holland@sifive.com, 
	vincenzo.frascino@arm.com, bigeasy@linutronix.de, surenb@google.com, 
	ardb@kernel.org, Liam.Howlett@oracle.com, nicolas.schier@linux.dev, 
	ziy@nvidia.com, kas@kernel.org, tglx@linutronix.de, mingo@redhat.com, 
	broonie@kernel.org, corbet@lwn.net, andreyknvl@gmail.com, 
	maciej.wieczor-retman@intel.com, david@redhat.com, maz@kernel.org, 
	rppt@kernel.org, will@kernel.org, luto@kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	x86@kernel.org, linux-kbuild@vger.kernel.org, linux-mm@kvack.org, 
	llvm@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 831EC80003
X-Stat-Signature: kmoqfng9fjex9to9jqkimgckmo5mxnif
X-HE-Tag: 1762852475-268634
X-HE-Meta: U2FsdGVkX1/s3UTqwCA6OSqMeaFWHNS0RpnGCV4wmAeNbFfkqiQLSz6CKu3RWIxX4PAKiSPQ7E20iDYCnG3ZhOs9jES8rYP0kFCA/hDRVTUAqZxhbNSl65KBv05+7+GlRPjyxZWjuQ4QqHuBa8N6QbBNsGL1CH9Gknz/iNU+Yzs0YE9nbXMLJYJO2w6bkugBD+aUte3D43o+KuDE3MSD18ZWRAiwOUch7nvkf8vVr0ENLUvX9fhZ65Dfqh+EWnAerQKmUFDvk/1Kn9juM9/nRBPqMsDY3YI240LZ8YZOp+ZWJHKfyN0M426G10UJSfhsF8plQI49rv2g9I4wGbB7Cp6mad1ep85FuNK6wyqh7KfDR8lOYl2HuGcrlrAoUsO2Mva0xWaWbW4yF/YUYlxDIqvEmkxTPDtJu3vx/lL/apew2AAP2LPp6fefvSjRBbBU4Gcu5TJ8NRHOAHccp4ku8oz15j/eVTyd9Hx4HSx3SS9TmRz8Q7obIFybt4midWJWMAG6tpjXceA7iGNj4Nz0Xlp064kOqRNsJd3PriINTg2UM4xmnBRMUeLe9gAHuP6Ay06qNCXKleYtfHEKompuUx2cNJK2XjPMDQoUPaFjBlnKIoISqlgZ7V7TKUOKM65r+muiYO8sisjKDfR5/5FmIAk9BhI5dmM9ckO9JdfDwMZxLKaK/nkxH7ry6igjOv0kfdQCwpYRwUy6uchX0Qw/BIOrzep1sT27jcYh008SuGeCSrFxJmpYiI/HAdny/J1XulRNKY21BR/oJKaySASL4QQHktvtBr7Mmm46EdQkA+DhhGFnOlXsUcac/EdeZYcWwuijVFXhiBVPPNiAY0/yeIjweNTsn5KJlN/TYDLJ5wEcb8YiwRC1Ai8Aj2U47WVt60Q1oi88kzklQ8kSD8f6VrcCJC7PJeN3YDu/ZKDF7/6U0rEt1KwbOiihJysZ8WZIGZenDB5W9XnW64quzX9
 zqx995/R
 ABmFv0hmPJW7xDwk9VQCDARRVmMvcTqGSf8yl8HisZP/XFosFJvpyz+JWDKUFXB7wzc2jCtn9Gdiaa9rr0uaQ8Xeq0TNbQKuQFYGbYvzLnUV1BxRSbcBjqAA8ZUYSOiViCr7576GvgAk7pDYlxYV3dkvlan1BHC53dsDzCG85xCZN6oG1SOeGniftDC4RoF9ZgT+QxrBo8kt3EN0AYg93C+SfRRPqZDcecs34qdil3fBO8pnMZfEob6serjMN4stkAfZtTw8u/HOA9PnY5b0n1fILoJsb0MxaizLz/K4VA9oAo0m6FIW2CukEQaJknfClnaBQ5xcsguSJLX9sdLCrQsMEcyARgO3O0nrGmFzDJe3W4u4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 8:08=E2=80=AFPM Maciej Wieczor-Retman
<m.wieczorretman@pm.me> wrote:
>
> From: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
>
> ARCH_HAS_EXECMEM_ROX was re-enabled in x86 at Linux 6.14 release.
> vm_reset_perms() calculates range's start and end addresses using min()
> and max() functions. To do that it compares pointers but, with KASAN
> software tags mode enabled, some are tagged - addr variable is, while
> start and end variables aren't. This can cause the wrong address to be
> chosen and result in various errors in different places.
>
> Reset tags in the address used as function argument in min(), max().
>
> execmem_cache_add() adds tagged pointers to a maple tree structure,
> which then are incorrectly compared when walking the tree. That results
> in different pointers being returned later and page permission violation
> errors panicking the kernel.
>
> Reset tag of the address range inserted into the maple tree inside
> execmem_vmalloc() which then gets propagated to execmem_cache_add().
>
> Signed-off-by: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Acked-by: Alexander Potapenko <glider@google.com>

> diff --git a/mm/execmem.c b/mm/execmem.c
> index 810a4ba9c924..fd11409a6217 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -59,7 +59,7 @@ static void *execmem_vmalloc(struct execmem_range *rang=
e, size_t size,
>                 return NULL;
>         }
>
> -       return p;
> +       return kasan_reset_tag(p);

I think a comment would be nice here.


> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3328,7 +3328,7 @@ static void vm_reset_perms(struct vm_struct *area)
>          * the vm_unmap_aliases() flush includes the direct map.
>          */
>         for (i =3D 0; i < area->nr_pages; i +=3D 1U << page_order) {
> -               unsigned long addr =3D (unsigned long)page_address(area->=
pages[i]);
> +               unsigned long addr =3D (unsigned long)kasan_reset_tag(pag=
e_address(area->pages[i]));

Ditto

