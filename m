Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 612FAFB44BB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C60296B0005; Fri, 24 Apr 2026 03:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE3166B008A; Fri, 24 Apr 2026 03:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A841B6B008C; Fri, 24 Apr 2026 03:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2FC6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:17:00 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2B864C337A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:17:00 +0000 (UTC)
X-FDA: 84692592600.04.A602DBC
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 277D040010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:16:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fiTHbBck;
	spf=pass (imf11.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777015018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uv1ap7wfpWSK/rjkumTWgHiVOSnLQXCSFDMADgPR1Y=;
	b=45N+7XNAYlwH4YomNP360/FKD6z2/q+KfIFj5FyZDgzQdxRf6Ensesh5LdrY3kLx+Vrv4Q
	LYa0OIeCm3fpnloFYZ90D3t71UT21VK27p+po8lWviI4dfkSOGpojOLzJHwF3Xf03OBXIN
	ZT7uz2tVNmAm20JErzpk5mHTUmwRaFQ=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fiTHbBck;
	spf=pass (imf11.hostedemail.com: domain of linmag7@gmail.com designates 209.85.208.41 as permitted sender) smtp.mailfrom=linmag7@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777015018; a=rsa-sha256;
	cv=pass;
	b=eWoCXgKqodfYb2F1JnMocVylTC9ikzAy8lIlBMBobjG5vCJkBSTxrRWlSlFWziPX/6loJh
	BQGd0SXhzOFyhx2VQB09EcrczMG7rTQfOYPpggcDMUYEUA4Bs+B/QGu/uLs7cWYi6/b/xO
	IFbLkkemUjMRkB3SzUZMsbz4vnv3arY=
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-67893fba9c3so2357675a12.2
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 00:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777015016; cv=none;
        d=google.com; s=arc-20240605;
        b=M6eP5FHuvx3bdxu/ctWr78PNTCEmokLpyxe6o16NPAwzxHiBN1RcqtbNt/bJYscx3m
         Ge3ZCrmZC/x66TpdWlQRmOaSoXEFkm67yFAjB2QHJMJyUNdmFTICG81d54BjspFDEU6K
         X1H3LEc5cBmgXZbYl/rh1rNh9CAWo1AxbHBUyuahHQdfdmwKv0xij9McNY2VPEKDR+KE
         IUuf9zEFIVBGwyolJa88qgpSVV5RlgRBleCrhwprUKf1W2dw49z7KkkuSw8NyJhS0hOG
         l4M06PpXHEFgbMwTzHGe6ouivmMroqhp/GbHIcfKFASlln75LHiNRgpmxZYwlE5UJ1Oe
         kIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8uv1ap7wfpWSK/rjkumTWgHiVOSnLQXCSFDMADgPR1Y=;
        fh=k3qoXzU77fxnhtfnELQh2Qnhvn4pv/McHxJSjsQ8hpM=;
        b=ZXkoK6OSwiw8BMtdq7V0qDXwY/d3HH+DzMk65zERe7UDc4LyB2dl0ad2BDEoGkbH1u
         QtmO/wgF3T+LOggj8Q8baswzR8Swf0eoqoYTCe7xwHakogzuhkvXtO48gTtORzg3lR2o
         gvxbA+8RiB1B56mANdZdA6rdqXhy1QZCqkStvT8iJqt9PHxW6G8bVSQNZcuybCFzFbCT
         5Qvj41K4h/1kNwMCWTgulrxRPbhqg21YsSndnfjgofb5uieHSo9Ttl94B84SRGCjWDSy
         bfYBVtXFuwy7bEZeRtmT8kCPyz4IFAMUh7xqRNBiR+7m8K+q8G6Y0koFN1x6V9fmRilS
         Wo8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777015016; x=1777619816; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8uv1ap7wfpWSK/rjkumTWgHiVOSnLQXCSFDMADgPR1Y=;
        b=fiTHbBckyO9XiQABbLXPsOLhKqRWsnKiKm7Q5hRGdDkOLzQD/f6dhujWo2J+dBeG+A
         J/oaGS+mu2A9NtrRpIY3nn6H+MZRQrRkzziZeDm1as8CARnXdQMRmXpSmu0BnPKr6yAs
         fuaPf9V4As3BFQrLKJ47oda8sKRRhi5+GMVS0rM/ProVx6oY0+HG8dQdI/AjLSc6YoFR
         6hF6oVvTobXzoyzI2+sHpjtWqGPey4+xTBcGCHLz0/l2CJ6M4CUJC5UzyNivZUxpkAwy
         s4XRjAsZj7AWbuTi3xJaTOYM6FprSB3dDZ54rLFXlllyyjFzSsiJF65xAlC3MLDlarXg
         97dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777015016; x=1777619816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8uv1ap7wfpWSK/rjkumTWgHiVOSnLQXCSFDMADgPR1Y=;
        b=hi4Tl0+ez6690SmKq/4NRJrCRnQJhmYLNEh+446aA3w9ZjWR4GJmPua/+TE7fkeZ/D
         yhYtHuVCm0eErznNxlUzjLrUMfENdvE5n+BgPnOFuIVEE9LotR4fSBp1KPzMG4lsjkGp
         0X4HEWwOfRwWSx0MpvtQdGifvmqju61umup6cuAKbj8L7g23BdPQmt2bC+OgC82E2Iln
         LJ6rDiTx0z0Kwbe3elB0snoqwBwdg9IATcR6wlpHyyFcLv1MENcZVl3V4rKML4a0iLH3
         B78yzFt2X+cJEOIXYH3XzoaitVOsrSTGbhhVzLB9lFBHnwVhoz46K3kreJ9rN42r3U9w
         EmSw==
X-Forwarded-Encrypted: i=1; AFNElJ+h0w2HfGgQLF/DsIvysc13o0wDa3pMpkRYAX4ZcdczelyiVFGzlzEAppvMWuwcUmUoe0pQmFcl7A==@kvack.org
X-Gm-Message-State: AOJu0YwbdKr2P0sfDE1gMat4sAMedCYekKhRc/K09I2fjzTBIKepHLNy
	rTN/WvieH4scS8KLykBJyZ5FnpeQD+08k6Sx4Tjp0rBeI+nl5iY3RLBy/olptMNLRc3Bt7RfNxM
	AXPYN6EZzbLoLLswvxEtexKsnyubkR0U=
X-Gm-Gg: AeBDietgNCF7wiLY3UGba0BhCz/wa3Au2jEST8tuf7whM71M4rdpda3Xs7la7Ssg0Pk
	CJQdVHGX4rjVWGfPqZtfamYc9q8lSCw9K/13ea6M+bQpC+QjDctJ/B6MxaOo/+j8ECYBDYbJJ0l
	Z98hkQ9yyaHyDAMvE3Y2mOMaTK9F5bIPXZICrDpraRS7nO9xpVrZjIH6FCrgb6aWn7FWBoPqpyq
	cI/9+yXbwkSB6rtkWk7xBNKa6udFYZE+Wp5Pd0Q3H/b8ZZgSjZjMSKaVCF0wMRTExbVK9pZo1qb
	Mum07R7pfEGwF83oGye7JxpeuyZ8e3H5nCXFjALu5gwhyZubfxA=
X-Received: by 2002:a17:907:1ca1:b0:bad:dfe1:6a56 with SMTP id
 a640c23a62f3a-baddfe16c2dmr60367766b.30.1777015016077; Fri, 24 Apr 2026
 00:16:56 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1776808209.git.mst@redhat.com> <006f9142e591ba8c340c3b354aee76aec5c285b9.1776808210.git.mst@redhat.com>
In-Reply-To: <006f9142e591ba8c340c3b354aee76aec5c285b9.1776808210.git.mst@redhat.com>
From: Magnus Lindholm <linmag7@gmail.com>
Date: Fri, 24 Apr 2026 09:16:43 +0200
X-Gm-Features: AQROBzARFJV36R4zYM7xbfHPyy5Ua1V3EjGjDIipUn9qIBzgKGxem5ahIafz8os
Message-ID: <CA+=Fv5T83qH-c0U4eXO84HQmG=225SepaxVYzrpQh_CWMhG5hg@mail.gmail.com>
Subject: Re: [PATCH RFC v3 10/19] mm: remove arch vma_alloc_zeroed_movable_folio
 overrides
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Jason Wang <jasowang@redhat.com>, 
	Andrea Arcangeli <aarcange@redhat.com>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	virtualization@lists.linux.dev, 
	Richard Henderson <richard.henderson@linaro.org>, Matt Turner <mattst88@gmail.com>, 
	Greg Ungerer <gerg@linux-m68k.org>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	Alexander Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>, 
	Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, linux-alpha@vger.kernel.org, 
	linux-m68k@lists.linux-m68k.org, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 277D040010
X-Stat-Signature: eix618bn3yfajr1dkq5nepi1hxwtcom7
X-Rspam-User: 
X-HE-Tag: 1777015017-373699
X-HE-Meta: U2FsdGVkX18Y5en8Soir3Vea0E6fUxA9hsBLK1OYhf8VH43NL3annuWDv0HQRz7aoTtGsUejS/d0bm+2BCzVSIKfrcA2RhxQe57UUevA6+NpGZJzzSyu5nGQjbbY4rfFTct5hOS3WxYf5JlJLZgKBAH0FLKtND4TR87KHXR3Hc1ZpUlOALuZ20o02e9okhF7sOrkcposRR1tco3aUtNSjttqZ+rH9DBakYFr4fEPjd+gS+r17vD9jGXLJOsM/dx5asccLQ3O4KaYo2yl6MJRn3HE5YYWMuqukcyOW3vXyTWs1PSMVo6j64TOZcmWvgWe4UyVNbvKHGFTH9e5K6ZttkJwSZvBv+JnLW+ss/4NDeDR+CHSF+nQxFrb4hyda8D8H4lNGZKv3rNB+wSmNoRm0gwl5Wos5FmNwUDjxvt4+ewOdrhxFJHvXbp4wJxkt3oghl6jJzYOLEeybJ1SJPJ2484jGfpmewi6RyRzCESkms2ps6PbQRrBqocIPpLyUqEF4YGLix9wikSL4o1XPEXHyPqcM1mhzgPnxO96GOo6GlT6gwgnvi74kgl2i4y5wTiuEmJe40NGQNdgZdFiEhCh6/7kzoOriLdPW37FJUoF3ZcTstiJywFTJLDQAlOpqNxXiWV9UxW7KXMVPoUkwc1aMPjbt6ZFYrFZCLOlZKEFLMBTJHCms/DgSE/o94n4EyranwzNN9eaFlH3xCXYZzHavN+ZsLBg8aH/zhQpP77MSBQ+9MZb4v/lYfgLh2yh+KZn/V+6NatgRUrZzi0P4eYGmZg4bavS9rELvEB0VaLrncGVKs7BW0onPMJ1N7lTBVc2aLopgsnVkR0QPdsmQxH/O2LMvsuxco3ex0DSl9w9A1gdAnelU5dVnelUFQNh5en1MJumY8Ed9pUSbYEPPrEzK2Vh09QdreGcs25oI7d2tdMs1rWz5MXHjeQgw/klRB8Qq5viQWrWxzo1lryYZyO
 v31iZJy1
 2vYS2DDcyKeUOx4y+I33vB7dM6PowGvbLpkS7dXihrEoaabyUgASO3EZ4kbyilydm6m/L6YwqjooN33Mc+ZNz41ca/qM9+NI9Ec8wwuRLQgdTqpNxCVwqqHIW7wvTNxWKLLktHiB6G3+hn4F5HHawGY2DGC/GkGF/b6ZW/UffI3Swfw7fgYduhUtp15GGGkdfhcMA4o2GEoMBmql7ixfPeaktvO6oD64CVV20br7516ePrci0VEHtTxK36O4RTdlbZohgEOZvctTih5cWaKC698mhvGIRSB5lz1/cCGn4lKusY9RNDcQao38H5PoEgX6UDHf58wGuSjLPovpVVEt4mP6toefCUWt97zBVw2PY0TnHwRgzwYl7NLxH3PxBTkXU5V5szFjMxDXxVfKtBfBCiYPwkEA4GycVa55EaVT7Hh5r3XjFprjhUhwVcB5Ji6p+wDv0p94DSvc1cbd1VrVABZwFkvgTY1LuMVOspIamnFO1vdOEU2dSeQHojL/oJzzavQF88WZWF/qFJg3LbR48vPGZQgrCpJjZqbHklXOFu0ph45b6o/blkdpDVM4WeWjr4Dlb7dBt8Z157yHsquKtrkMYLgt/QKDOCsBe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 12:01=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com=
> wrote:
>
> Now that the generic vma_alloc_zeroed_movable_folio() uses
> __GFP_ZERO, the arch-specific macros on alpha, m68k, s390, and
> x86 that did the same thing are redundant.  Remove them.
>
> arm64 is not affected: it has a real function override that
> handles MTE tag zeroing, not just __GFP_ZERO.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  arch/alpha/include/asm/page.h   | 3 ---
>  arch/m68k/include/asm/page_no.h | 3 ---
>  arch/s390/include/asm/page.h    | 3 ---
>  arch/x86/include/asm/page.h     | 3 ---
>  4 files changed, 12 deletions(-)
>
> diff --git a/arch/alpha/include/asm/page.h b/arch/alpha/include/asm/page.=
h
> index 59d01f9b77f6..4327029cd660 100644
> --- a/arch/alpha/include/asm/page.h
> +++ b/arch/alpha/include/asm/page.h
> @@ -12,9 +12,6 @@
>
>  extern void clear_page(void *page);
>
> -#define vma_alloc_zeroed_movable_folio(vma, vaddr) \
> -       vma_alloc_folio(GFP_HIGHUSER_MOVABLE | __GFP_ZERO, 0, vma, vaddr)
> -
>  extern void copy_page(void * _to, void * _from);
>  #define copy_user_page(to, from, vaddr, pg)    copy_page(to, from)
>

From an alpha perspective, this looks good to me.

Acked-by: Magnus Lindholm <linmag7@gmail.com>

