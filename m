Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B67D4D49C9E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 23:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C12D66B0088; Fri, 30 Jan 2026 18:53:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9C186B0089; Fri, 30 Jan 2026 18:53:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A78936B008A; Fri, 30 Jan 2026 18:53:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97F6D6B0088
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 18:53:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60872585FC
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:53:36 +0000 (UTC)
X-FDA: 84390284832.04.F5B0B1B
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 54076C0006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 23:53:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UjWF0Fh1;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769817214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cpyhaZCJSocKMuUNCmXQ+BzRs5Ft9MPVuo2ivTHAMnE=;
	b=jFJNfhc9TFwojbxBFnTDroEb9uLcPYGcdW7N6hb0M6KaZS4GwnzOBpKwjHi+nh9zamt4fS
	n5RY5B6co5kk1s+E7Hnt3FKT6TdFyaRCXCCO1p/HGJXfJ87Kcf/fObX6OF7T3agP4sEP/L
	11ncneMbJbHUkveihEU318mfZU8l67M=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UjWF0Fh1;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769817214; a=rsa-sha256;
	cv=pass;
	b=jlk4fQ0deIdLlaj/+ja7HyrYE4ctkvzar+TKb0IHGFivDD/grKukJTNK4Ryjto9Z2QMpLa
	5FlqVBJtL7D4XSJkQAt7L3u1+j2ujdL4Ab+xnpxi5SRBFv3fgiiOpp8sNsNJRXk0Kiiu5v
	lQ3SkENVyZDBAmAnj9PoyRDyv0s6Q0k=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4805ef35864so22216955e9.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:53:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769817213; cv=none;
        d=google.com; s=arc-20240605;
        b=M+ZVxDtTI/8uQm2SI856GoJNVcH6nn56VbZD2THx8fodAquiF07VMisA1/rh/MexMs
         IP8wLxBCJb4YsTwk89y7HYXGdm4ZNqaDYc1Ng8Zu5aO4Zj9jf7sir06TSRZcga1H3k+l
         Rv83+IzQgil3o6xkw8y1Yz7HxJhcoq7N/PosyFS4JRHFU1aXo7poKiwBvF4EZsIm47sl
         OjOPeHVAID2HmrkGJw4nUbFUFE2r5vDbQ7j0rUtGN0lESDkB++cG+xuchqqGwER7kH07
         bnMzMkvEEcSYB+ZlZf2yOLBLLthVOwOP2I43KOxA1Iz00vSrhpCjbwrDsh/P1QzrBKBx
         Wumw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cpyhaZCJSocKMuUNCmXQ+BzRs5Ft9MPVuo2ivTHAMnE=;
        fh=El0TSN2MYfPABeW0L2vMQ9W3BeUQa0mm0zruG2OZU6Y=;
        b=GK6yKj/hyuuRoaYAGtUaXnfKNEDEPDS5NeUg6X8tu8RP9QtsPqaCMpRRboJtViKlp9
         8YWvvSBX7TzgqTBOCtwmG0Awo+Nfxs22/aWBhjVKCY8nDrIQ3ZOirUshxCGuiZWGo9iZ
         dLfT2OCtRZgMcPlXrokY3mm8eUN6jCAElpFTphDqGOG20nAG7wVk7HmSc2ADFR5geFb+
         yER2jLVe1KvnaBvYOV7vwNm7vBZOsgVnhgNlEB0WZL1QpkyewiT/KC7NwHXxe7k/lVx9
         n5VWpvyzf3/yOp4ixgtVFl72/wloWtOP9AtEHSjbrFdvLpZSCSiirjlF/6NwM5KSBamA
         cgvg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769817213; x=1770422013; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpyhaZCJSocKMuUNCmXQ+BzRs5Ft9MPVuo2ivTHAMnE=;
        b=UjWF0Fh1phSh7FJFXsSK7j2wDXCOYw576XoZh7qfR0iyWTpvODuWiT0GKKMmHuVkPG
         B5sWTQGv1U5tskb7HlciLfzA3UAPeNZG4KaLsYAzbV0TLTNvuOhdE990ezRwmKmatw+D
         xM72eDYc8iH42At5LcWIA770tYxCW8cTNNOWD0OpzTEMe42mPyaAwHY9JPEd39VubIDY
         pql899yu3uUbbfv9rM9G3e33UdW8GlWWXuIa8oX/w3Y+a4wGGytbHkS9RvMgqKh3iAft
         rOkGJuPWwBItw3J7WhIw0LV46yOhFhi1V904TF8ucxTuewVGZKlSGYYheFnYJj7FpIk2
         rnjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769817213; x=1770422013;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cpyhaZCJSocKMuUNCmXQ+BzRs5Ft9MPVuo2ivTHAMnE=;
        b=OfY7MAwpuvuGFx64x9aGO3TFhbLKPWcet2l7b6u4fthw8yFoaikVPlGgj3Bnb4PWiT
         YBCKRd1dPTu1KQSw0jF0Y53W8QKgOLEkA7UCucdjHZDSYVu6ZwPpUAKEXuXlouEm3Z/D
         T73P63WgyK7YGnfsFkWpHFNd9roQPfwGVopCZDY0Md0ne+9mdsdjq6AMYnuWEweWmPhY
         T0kFMFlivR2FoF2SQpWA7xTBcCgsJL6UVY6zB7X8x2dwTc+bhgb2lkJiVikcoTUAiejI
         /f1k6C4oy+0cCdIN5lj6EDyYWyMDJFG1ABQeDbA7cjjAOniq0aphy2MyH41lTMncvvT1
         Bh1g==
X-Forwarded-Encrypted: i=1; AJvYcCX4IrXGlPstLQjr6N2Vq65kqSAEmv3ARySk5VlNjNf562Zul4D2fTuBPmeS2ffANsniCEZiUMdA7w==@kvack.org
X-Gm-Message-State: AOJu0YwAkzmVecMAw7tKa1oCm8lFELK/zrO9Gnr3YSSG0boMVCyG5YFz
	iHR048JBGCKdPb09g0n4W+v5Q6bmOq0IJZPUAnX6F9W9LuSJ/gjcOo0tR9f2avzruiuKaxHgYlt
	LYRraaZQaWFDnWE7cC9GGPhGHpAs5mY4=
X-Gm-Gg: AZuq6aIzpO7o6iu442CgE7ajNlAaq+vVtUJkL0Pm/QtgEudBhPxjVjqE2ZHQfIsdVVX
	E9ST8ROBs7KUZhyd3r6sfNP8MCwB8Uk5yfxP0FBFAz0M4dDkbTIhAIY6z23pYJPKftLE5Uu6gG+
	pgRwbSk6WUVBANfOReUeC4LCWwwX5AYRVmBpc+ugrPoyWnhsCkx1k/J2kwgCx7lxSViNh1X4C41
	C+CYUmM9B3OPBGgcj3Lw6BktsaakwydA0jnewxySFX6mWxmh3jOSwMRmADd2JYZEX7LwO8sEfwV
	HoaDZhoclC0=
X-Received: by 2002:a05:600c:34c1:b0:47e:e2ec:9947 with SMTP id
 5b1f17b1804b1-482db491eecmr58235085e9.33.1769817212473; Fri, 30 Jan 2026
 15:53:32 -0800 (PST)
MIME-Version: 1.0
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com> <20260125033537.334628-25-kanchana.p.sridhar@intel.com>
In-Reply-To: <20260125033537.334628-25-kanchana.p.sridhar@intel.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 30 Jan 2026 15:53:20 -0800
X-Gm-Features: AZwV_QhoRCJFgeduCa2tipPOIslOoLlL1iXAkLMz0pxK4ueLAQLeijerNFt9390
Message-ID: <CAKEwX=OL1Lt88tToA7pxDAJ4QkxV=PpGZ0zAVD=oexQbEArEZA@mail.gmail.com>
Subject: Re: [PATCH v14 24/26] mm: zswap: Consistently use IS_ERR_OR_NULL() to
 check acomp_ctx resources.
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	yosry.ahmed@linux.dev, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, 
	kasong@tencent.com, linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org, 
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com, 
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com, 
	wajdi.k.feghali@intel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 36jahs67zkngqip5mf33gkrfocp1s9b1
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 54076C0006
X-HE-Tag: 1769817214-246809
X-HE-Meta: U2FsdGVkX19uy3Yc9iADPS0at07fTgIK3xOAUzG0OHLh8Q+FpWuGpUx9QullClffjOTMtzeu8/wdtWxoSZdD6Y0Q0JnkkBPcyuyP2l1KncXWaqnJ//2TZlrpujaHmxCCtnY3a9BP5gFxWbxWtY1W3fUGYnc1QOEFyfssU+rTOdogJaMbfhK73ciEalYg8RiA7XzDebKeMM8rrpsR+t69UPH00L21GrMhv27JRXQRHEU1YdmZa4oq2l+/mX2GLf8P/J+xddFwtBNZRzTHLcx/2h4tI0cxL3al9fk2mvzgkzuDq7htD40v9H+pDui7ln84MZVkb2xpeKDpuhBkOTgOPsh0f+uca4KzLyOSr1+CDjaXpvVGwtr4csKgjba126gjCSwyVGsOAwOa/7oAuOnAzyAm71Ur8VJhSrc3oCUZIL9/iusaEL9zLsYdHg68nmZ6L6a8lGuQGOABLV04OHsIEeuM0CICXwiGK0we/TrFzRXW0PKAzsgNcTGVEaMukfHh1CBhPyPd4LTv+hQ6Cp0rDMkscXoQUiDXp2hbsfgwG2qtNXW0xsMCmG9LZNYbp/qA4G1t0AybMoCa3g4C4dDsVadNMMSnjqV9QS6qPtt+PNUCBXvwNR3RI28puZOWZwCriu3olH9bI8xmLZPYKGHBdPRNH4uIYjGUxDcwrdFw/pMu/LtmVJx+35X9t+teRVsEQMJzHM5Px/2GpweLkfrnH8Q4xfB6SzFXXpJrEZrQr/B+5rGF/BK3BvH2xx4PYBnPrOGNrsqfLQUOu4NHb7fwiwL/ng2q1C5MSBuo4bb58NktuL855FWC2kNwGIz+WMxC7JQx+B1Dmm0+8OTsjBS6IfdQl+eGJmS00+Q6uTviBWWpDtS2pp/mtQnCjReFpnBBrU4uk0hbjdLsNvkUV9j8++7bT5eVRE3pjQMtsHZsDoL8y7Lk7uxRraywIUBXavgtzeD2WX4nALxvm8wYEV2
 RBkjfcNF
 s/9F07RpmG2SGbzFoJo8XYm17swapw8K0XyFJWbzqmg0YxBxSSvocO3GvRYiJMU7CtjUxOs0dvWe5/hreLWJazKA0wAVcLHaLHfT89oEDUFWNv8TTBnzHDx/uCDbIM1zuK0EnprVizBDjhjmNrd7K3aQlSmm+i8ucZkWnRaND3PVYibV0mbmzhyURYbQoTRP0gFA6pcyy24QcCe4pz8YaFoh+Puq2QvhrKsJgjqjiDGjbzpk3EJVks6spC38d286E9JejPqoTtptnXCn2lfcs92tKUQor0xszKuHM3XIs31O2c472mf8mKkHv6msl+UGNijifVHKgmpazJ4bq5AACrEzpNbf/IUrgpFfcSDS+0pz2EIxB6fbhyef4AkhNGt8OuMvgo20QI02a1dBt19n19VIHG40P76ADtwzF2yqFzMhvvLiRhtby7Lxl4uQYFNRYkghcRxyZ9b2AGk5ipH7T6xYRljkgO55vZgxDtXPoo9vCSqjT3OqXqKvtAA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 7:36=E2=80=AFPM Kanchana P Sridhar
<kanchana.p.sridhar@intel.com> wrote:
>
> Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
> acomp/req, making it consistent with acomp_ctx_dealloc().
>
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

LGTM. I wonder if this is technically a fix?

Also, considering submitting this separately if the patch series stall
- so that you don't have to carry one extra patch around every time :)

Anyway:
Acked-by: Nhat Pham <nphamcs@gmail.com>

