Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C90E9F531DB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6DC76B0088; Mon, 13 Apr 2026 18:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1EB96B008A; Mon, 13 Apr 2026 18:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0DC26B0092; Mon, 13 Apr 2026 18:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C03C96B0088
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:20:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50838583AA
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:20:07 +0000 (UTC)
X-FDA: 84654951654.14.D273461
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 479D280012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:20:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H7QMmAW7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776118805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00dCXJraG3Nz3xP1Zulfjafowes4Ec60LER8Tb820vo=;
	b=AB2bUE7NdEpesyzAsrsIuKLkUpcIYgTocma7ZqwRLqlX6FLICxj/OkduzyN7gJ3narj5J9
	I220B6qFLbrgy5ffKqIGvzQlpHdZnlygsAsYA9lMLcc4nRwK4uHHiA29EQP6Xzeflr0rJ5
	D4EepziNCyPrxr4Tlu2VIicw/C/knj4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776118805; a=rsa-sha256;
	cv=pass;
	b=J4difrpXWW01lCfo7nxvmGZqwIBEOaciarLptwoI+XL/FLyAxBTQcbpK0yb4AAZ4W/ZfLb
	xHJ3tJOb3OCqVNn+PM7zRwd8x3h6lzGeVVm3otos1JyOEYVf3U2uQvU4IopzoeGSlqrRbp
	hOYmM3FvUcPAQj0AFvyEhbW13IMDmhU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H7QMmAW7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-43d01d6b50cso4994287f8f.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776118804; cv=none;
        d=google.com; s=arc-20240605;
        b=EL3KHvOACaqa/oWOCk02lMQLmirO3T2fkJD6swne3PSDHdYLxlzWqtDd+TN7yrixQq
         tGvHw0GzJ2gnFnB8Of24KNDKEagVQEca1MjxBWAkRkzWSDMQImmGtEVoFftz+gB5ycNC
         iMQzVNP1e4gETGF0/h6L5l3fMAcixZeCurUWz85KC0OmpNV0nTgMi3n8+kuok4SS5uvR
         A7eDZEYE3d6mlERqFt48q5Th1kz3XcZIz2u9yo0aWsQOuFnJQLAp6qW6SEf3vP6DgMua
         iMyx6KnvyDfJ4AcuWvC2nsWyCBn3oymKDCY+GYmB5zK9AFE/EAZFAbvE0oWGfZy/sJgJ
         X4DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=00dCXJraG3Nz3xP1Zulfjafowes4Ec60LER8Tb820vo=;
        fh=UlTweRj0iacNAwad8mbt604qVxjqHDvGlEAgHPjOCp0=;
        b=R0FGB/w+ElS7plOP7eO9mJWo3IZAAzEOPStK181g805p1u6wIDSUlnEpMe5BC3GiLi
         jsEvhQ7DNQ2x/eOBqiu0EDdeFmsmQpNiH4k2ypVqQghB5mNiIf3DrHW5wnpte5bDmz8B
         LUfKBa74W5sP4py8rOFOAmw60nl75a/vTJFaH01TiJNvX8dokIKA3Clw+0HOqnl82Bgx
         uZbWvcfXJ+IYdcwL+R02fk/ZzAYTDVTm80kDw3kwQCKVVzHft0brQqgkzEKeb0VgScGi
         k4Cm+Hu/YOARmpO+rGpednGwRdsh2OQ8LC7c1YzMeYylOwAxy/SFdMW0hi4/0ghKbi8O
         ehtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776118804; x=1776723604; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=00dCXJraG3Nz3xP1Zulfjafowes4Ec60LER8Tb820vo=;
        b=H7QMmAW7NjzIZEfuE2/ZXq+ErNVaFcEXCv32BqFGgI4bknz4mOZZRk5zKxp4X3FVGZ
         rBIGtWiqkyGCmJ7E7vVuxKuvV7fMbSCJ0jcbZ65qeVJ8Tc6SVgxB/O+sWEVZo8ZLM5Qn
         YoxeiEOp+tF/8fqHofD1CYL/QPKPlbqoZ9I2fcRrIoXugc8+XzhjDME1ZaW9+NaKh3zS
         7im2nzBCgprxOprlTIkUzum0iRx6ExnVcfkkB97rpNSEQGfzd2oeakWCxkkH3pv5sDJt
         Rr6j84mu6+Ruv+N1R86iV51hyt2WxYuuZbnyk18GOrXN+bVhMh8cEckkwazYVlAgH/65
         hyUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776118804; x=1776723604;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=00dCXJraG3Nz3xP1Zulfjafowes4Ec60LER8Tb820vo=;
        b=hvaRzfKzxxI8Dp5ZSULYz6KyQ6/1m15uw5BAThyQX6XTqlMy1oop+KVMINml6NA9J+
         3P//rfOI40pnbf2qpD+bpsqQa6Sm0nMYmHy2A69fDVe3OWXju709tRDUuzqRD1nutc0m
         vHELfrMt7RhO8qKi5CsRcxZmkLysPhQyaN/9lo3p/lSIudd5dc4JW3eZ+HwvEG3TMW8J
         2Nrp+n1aX/oS5nQ2s79ve1rIwO6NgJMPI1iWtuIo6q5QPTbfYa2MK79A5U8pxT0RJvOe
         h+u3Y9FdummgEaea7YwbvIyZcBoMnKPY76VFoXjJIUzjUtk/vJvW+CCVt1YZfh3JB210
         Nzcw==
X-Forwarded-Encrypted: i=1; AFNElJ8g6ukSDvy4jaRgIlJVDxWY8fMaNzfJiXkV3ucSVtJUYEW+nPG3/GWHZdoOHC0EwXibHygBUXSdUQ==@kvack.org
X-Gm-Message-State: AOJu0YyaUSYzir8t3WrAtzES320QD02i1KsKi/tUWeMlyJW1yrrtJMTb
	LKWP76JBituICQSsWiT8rgBtZTER+fdf2brEslnZWVgbwvYRsq9LSdK2U7J8p3L3hTqOcBGB/sp
	7AWE1BjelabhPnt0m0/Bqa/w5wnU8gFw=
X-Gm-Gg: AeBDieuopxIERDkmCyB52+eW9V9QoKG1BqyBtkmj/mxJXooDSZdjh0aoCKiiAxeDQTS
	/rR/3bdVWA7vgH1Y+fFX5jwdjODszn5MBy1d4QaGc7nYxPvGhsMDbJfl2ST4VfWiAlgvmc9isos
	DoQ7GSPRkcVo7OxXULdcXKzbQDQMBhZtfsQem0+nEPdbggPzsQjvpzYyeUedea4pQAqF14Rj7Kh
	beBFbVU2dRYdexRitRV3R5QstITvdu8qjwf6EF6lvWp3rBJsRuEFy3EISDpwSLJ7qUyM3BfIjnq
	WX7mT8GTeklitMLINxWg3auQMwhEdh9ypACLSVij
X-Received: by 2002:a05:6000:2c0a:b0:43d:576e:63 with SMTP id
 ffacd0b85a97d-43d642d363bmr22139849f8f.39.1776118803430; Mon, 13 Apr 2026
 15:20:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-1-1a5831230821@bootlin.com>
In-Reply-To: <20260413-kasan-v1-1-1a5831230821@bootlin.com>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Tue, 14 Apr 2026 00:19:52 +0200
X-Gm-Features: AQROBzDwNCNsQCHGNuFB9CZ_Z628O1o6wbow_4AViz1wzqVpQC382sCN6eDZsJc
Message-ID: <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
To: =?UTF-8?Q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Cc: Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ebpf@linuxfoundation.org, 
	Bastien Curutchet <bastien.curutchet@bootlin.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 479D280012
X-Stat-Signature: ctxfoxa3icimhos4crrh9qmgcbuwciyt
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776118805-553582
X-HE-Meta: U2FsdGVkX19JLBYhRsYs/6KtbGOjlxTgyzzOiBeSxHHWX6dLt45lsIzlX386GTUZNmZxfxROe0hMbSzEuSpUNfc6WMFRJkTlXMrXwhRvW4e/riOdjHt3cwanWHWI1NbC5tdQbB2RkbuuomGXiCliFRhzl67j0Pvo6CBS6pVLWyi2nVOhwiL7Mq/XIYZUv6Ib6jCmM5EV+qkMYZMn7O8LyhQQWoenYrg6iFwO9B1xyW3UPD+OPL3CxoGXeeSeXUeeGjjztQo38E4uffRzQuBW38KCrra/pB1l0MdY69jDNt2rD6ilg55mpyWKlWJ/Vrdkk4W60cVrFGISYGG4GZt9qC0mueLOpnVGHrQ2f9P87vEE9cyo+AOsqqiVNkpcYXGIoZ03zczzEu9i9UgOTjkmpSXyEoQ9+51RSc2Ydy1vyinFB3foeQA+gKIDoI3tp+g0Pk0bR3WQBuYzDqWckju0CnflEfeF17TEJa4hdv36AfBRyxd11VhSnrs63VtxXKkAu+iBcF1N/ynrkqERlU2PsDkEbB8oFPzkpiMXovOZtota6w3NDlWr9BCLh6Oo8MOYd37qWHKhey+gH1JBXZqxmjlh1guUQYn8ePhCiqeSLN7exqGeCA9Vl8pRpbGdH3Z2ss3a7ghJcb9euya1GJIJHByUtmmmo3B27IezCHhvWhlHZmtqRZkgl3Jpi6a8kLrOKA+hFSZhkLmeFbVZx9VRHGWMPoMoCflS06YVjdyX24fPVTfSV6o73vSi0V4JZKc1yGK/ANWHPPfNIxRWPOqjrrmk6XhiENh0ixRgIo5VQQOntOQD7MmdfdfLYTa9Ajh6xZibRlm+tp9yWH2OaxyraREynv43Jis2qMgAGmhEU2qsQAcrLJcWk75TX9JZQhlLhg3ZRcaBh5LY7CQyKzBJemcwRIYPu2ZMKNeKs8pheYJPenA/7x+EvVVaRs7Dh8xaBM1Bmjd4NMx3fslOG01
 scU7HWsx
 FweNmc2QqapHt1ZQxJ87zGDy2AY5TCsFG4ERT9d/aVpbkYiPIyT+nvhdKPTtYvWAbflloESR0Ezsld0cA1YWc4NdvKVtTxWpJFWmeAvvAOsF1HuUWavgzMY4ZKkvXsscP9HGUxqFwfsBSqMdhZwQyyfqFfa0pa/lytN72y5+2EWGP9roz66e8hz6vRu8QXULL7MK+pT9B1dFkQpdRCj1wJc4zIGGucd3xnQCY+eElMluKmYT0qqCxEwA+tdiN49Go7EPfwG+6Dda5xgNMn8mjc1x2tpiJdBDIgswAeZVv+bMnZ1/Flg5d3pWQrVa35ntgTxH3Riqk2fq9DwXhX3jKpBN9ccVJ9zu1RFWdIWpOml6OfMz5sEQty/f0HFL76oXk6Ig9RIrvlTXeWDnp0yTlziLd2aeorLcotuqQNmtngXYDPEWg0w72YkFfhnPiUE5fN2dr5kMHFJ7YypcRMAwefxnj7i0KyD7szcn4AgOiximPJOuAlZKFAsCkAy5pHk6snZEX+ghFU+TBbSDtWEMrF9hj9eEUV72aY4tImOdc5P6raxZJCRL5ZreiPpxFp82uynO2LNGUCzssdyno0SPj1IfxDpImLr8O+OV2AIWKEXY0Yyk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Foundatio=
n)
<alexis.lothore@bootlin.com> wrote:
>
> In order to prepare KASAN helpers to be called from the eBPF subsystem
> (to add KASAN instrumentation at runtime when JITing eBPF programs),
> expose the __asan_{load,store}X functions in linux/kasan.h
>
> Signed-off-by: Alexis Lothor=C3=A9 (eBPF Foundation) <alexis.lothore@boot=
lin.com>
> ---
>  include/linux/kasan.h | 13 +++++++++++++
>  mm/kasan/kasan.h      | 10 ----------
>  2 files changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/include/linux/kasan.h b/include/linux/kasan.h
> index 338a1921a50a..6f580d4a39e4 100644
> --- a/include/linux/kasan.h
> +++ b/include/linux/kasan.h
> @@ -710,4 +710,17 @@ void kasan_non_canonical_hook(unsigned long addr);
>  static inline void kasan_non_canonical_hook(unsigned long addr) { }
>  #endif /* CONFIG_KASAN_GENERIC || CONFIG_KASAN_SW_TAGS */
>
> +#ifdef CONFIG_KASAN_GENERIC
> +void __asan_load1(void *p);
> +void __asan_store1(void *p);
> +void __asan_load2(void *p);
> +void __asan_store2(void *p);
> +void __asan_load4(void *p);
> +void __asan_store4(void *p);
> +void __asan_load8(void *p);
> +void __asan_store8(void *p);
> +void __asan_load16(void *p);
> +void __asan_store16(void *p);
> +#endif /* CONFIG_KASAN_GENERIC */

This looks ugly, let's not do this unless it's really required.

You can just use kasan_check_read/write() instead - these are public
wrappers around the same shadow memory checking functions. And they
also work with the SW_TAGS mode, in case the BPF would want to use
that mode at some point. (For HW_TAGS, we only have kasan_check_byte()
that checks a single byte, but it can be extended in the future if
required to be used by BPF.)



> +
>  #endif /* LINUX_KASAN_H */
> diff --git a/mm/kasan/kasan.h b/mm/kasan/kasan.h
> index fc9169a54766..3bfce8eb3135 100644
> --- a/mm/kasan/kasan.h
> +++ b/mm/kasan/kasan.h
> @@ -594,16 +594,6 @@ void __asan_handle_no_return(void);
>  void __asan_alloca_poison(void *, ssize_t size);
>  void __asan_allocas_unpoison(void *stack_top, ssize_t stack_bottom);
>
> -void __asan_load1(void *);
> -void __asan_store1(void *);
> -void __asan_load2(void *);
> -void __asan_store2(void *);
> -void __asan_load4(void *);
> -void __asan_store4(void *);
> -void __asan_load8(void *);
> -void __asan_store8(void *);
> -void __asan_load16(void *);
> -void __asan_store16(void *);
>  void __asan_loadN(void *, ssize_t size);
>  void __asan_storeN(void *, ssize_t size);
>
>
> --
> 2.53.0
>

