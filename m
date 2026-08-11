Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2B0DC5B569
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 06:50:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D296B007B; Tue, 11 Aug 2026 02:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CDCE6B008A; Tue, 11 Aug 2026 02:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD476B008C; Tue, 11 Aug 2026 02:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 652766B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 02:50:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC7F2140337
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:49:59 +0000 (UTC)
X-FDA: 85088063718.06.CE6E926
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 091BF140008
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 06:49:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786430998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0iZRfAdzYvTsaTTh/J3ab87cNtJMKi7JiQC3Jqumorg=;
	b=d5UbefVMd6VHWDi/FyRkFhW+WVD7l4piu2C4DxWAAuczzs0ZHoB6ovccsRQEyAVGRPwFD+
	QQI+EeDAmCHEsfx4y1TYk8kQvGx4mcmCciCjOz+McUJ3mkN3rfmP82IhxtaD6w+rEGido2
	oEoJpIh4oH+jmDVMTh3dZrVOLvdMk/g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of geert.uytterhoeven@gmail.com designates 209.85.222.49 as permitted sender) smtp.mailfrom=geert.uytterhoeven@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786430998;
	b=yOwgAKxmDzIUMgNFKFLK2HlVge9lPsp+gOijyXoAohpy3gHc7KC5+mzRdkwu4ivFCBUSne
	SBN6idOASJfNuP8HDsT60y2/CR6RB5gLB5WoZjvyjk0Sl6SshcRXMYZaBUjxh4Zh41ON+B
	FKH5XbrGHRW0fyJOFtaetxCuq+JlXIQ=
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-963f63fe025so407793241.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:49:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786430997; x=1787035797;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=0iZRfAdzYvTsaTTh/J3ab87cNtJMKi7JiQC3Jqumorg=;
        b=c71SXoAPbDlAxRxPn9cpbaoypgYZiIjlLaVe3f3fGUusR5esmmYCg4cbUkxANA37Ll
         AldV4+PXPZ2ldBFDk62uXo6keW6BtFShs9Nsd5/c91v3n/5+74vHOlJUA3jNDjbjy1Bb
         x8u/Vxydo4jlPYMUvDBr8TrwdRECQuZWY0BElB2dK8t4mUBSMtNqEWHZBd1HQtOATYlW
         cvMQvzlFRdOGLQhmp+POyR0h7atEXr9xS/lDttvw/yA0fl6S8DtV7dzfvwZsqScUeGyg
         rUjeP6A3/cOXucEHnDvrrrlUproPMvuxuotJV3NmzIC8SqgEaSyQIkOLQT85GcTZOdVS
         gDRg==
X-Gm-Message-State: AOJu0YxzaqYjRQxac9UKe14ADO28e+C6kNHuV6FCYwqIREIcCXFO6/YJ
	7i4DaSNY4KQFFDa9vJHuolJXWImH00y3PchiJi1sFWylFiFsZJC7RFEvOg1Wqg8Y
X-Gm-Gg: AR+sD11pZsJZrZ0Cwv9QMaZ34cpLQ8EicFN2dG7JutNjmOh8aLCjrDpavkfv8uzIfgS
	Kkf1a62lH+wqyhwgjROjKPyo/2zYaygDFnwxTSb8zCoOH5kxGP6bVDJPrW0g4Oscsc34xtZIeMZ
	4WVG1jeEEYNqVJyEJyrNw/Y4OpZVJlwMuIpBYpGQmbWvfISeeZX1z+lfzsaLCUxcQRpUp+3B7g1
	fsDCfyIuziUl/+3xxVCkI11MOG01z2ZUwTG3pz3PKITdYORqSJxnDtewl+IyVCdvQCFXGrxb73y
	yVsJMGt+pZlG1GksH58TGcPUNAnLSVUjhMspnGFAupHiygZ+hmXE2Pir8nPvZcNyzAVkfM9OY5g
	bdPThLYhChSrCfzmDOMXNBaBVGMH3r52wHMyVLtsLenja6IBPh1CxXZWUILvq3+WHIw88ZidDEr
	YPlKE003xS1MsM+QoYL499ARWfWh18sjY1a+pw557HCJa8j4HbvbNTeguRcg0J1RsmVi0QzyOis
	IGf6aA0QU5eGv3Dt8ZjKir1ww==
X-Received: by 2002:a05:6102:1614:b0:737:783d:1916 with SMTP id ada2fe7eead31-76b56bc9ff2mr242388137.11.1786430996969;
        Mon, 10 Aug 2026 23:49:56 -0700 (PDT)
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com. [209.85.217.41])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-97a36630ceasm110746241.5.2026.08.10.23.49.55
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 23:49:56 -0700 (PDT)
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-7466771f1caso824484137.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 23:49:55 -0700 (PDT)
X-Received: by 2002:a05:6102:c4a:b0:738:ecd7:1984 with SMTP id
 ada2fe7eead31-76b54a7a17fmr283026137.3.1786430995503; Mon, 10 Aug 2026
 23:49:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260811042119.3652929-1-anshuman.khandual@arm.com> <20260811042119.3652929-7-anshuman.khandual@arm.com>
In-Reply-To: <20260811042119.3652929-7-anshuman.khandual@arm.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 11 Aug 2026 08:49:43 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXfpkpYzZWGVb0fQrdn3uYHU3pyCkyAX9o2ux_Jj=2ByA@mail.gmail.com>
X-Gm-Features: AUfX_mwgji-OqM2d70As4nCfmG84npBMa5IuhuEcV5XEKzcXYS3fe_Pqx16lD20
Message-ID: <CAMuHMdXfpkpYzZWGVb0fQrdn3uYHU3pyCkyAX9o2ux_Jj=2ByA@mail.gmail.com>
Subject: Re: [RFC V2 6/6] mm: Drop pxd_ERROR()
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@kernel.org, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, Helge Deller <deller@gmx.de>, 
	Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, linux-alpha@vger.kernel.org, 
	linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
	linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
	loongarch@lists.linux.dev, linux-m68k@lists.linux-m68k.org, 
	linux-mips@vger.kernel.org, linux-openrisc@vger.kernel.org, 
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-arch@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 091BF140008
X-Stat-Signature: yu8uorctwnm1c595hjre3h36p9ei1qzi
X-Rspam-User: 
X-HE-Tag: 1786430997-129259
X-HE-Meta: U2FsdGVkX1+31abWDxkB/tVsZCibPz8gGZAdNdcbEw3eGNF1EyXyZW+QUfjeERYZDBRmAzpRsnJC5xvy+sub5oOXQe7r4y0yezsH4tK7Xp/QKS3n4oM0P7Ww5ThaC29FhE2ob+Sd9fxcQnLwH16fnv6WrnYY3Sesh+y45E/9fajnBxUpOi1Fa18Gzx+mI1PY7m0zsXdqkI43vtXDT9h5sU1t7QClhvSPChQiaX2qb5lD8H1lbRVa+baWTPx8wDnSRMwNdMzcHcwTnM6wL0Cb2J+b+IK0IDm52zOPsKwChNt6vQl04WzwWqeIKThGELGqALP2s1t6d3FgPOD/6FbjaWceRkPuY/6KqpHNOV0ilCzV/tPMOK2sU0ioIJoPr3WnbGGDzcyDtN29cOsZrrjgi/TUwA4yUlol1QmCRQcmGOaIYDKIuRTdzdsUc9P0JSj+t/9aF/xlQmLbNDA35Li9C0ytBiFhlv2q+rqLd+RounzGCT6dtkhxwngjH6yCHBTRFB/9dMjRycxtKbdO+Ht9UY0+Z5/W24DJfjd5wmWBJZ020QdE33jdocmwhK84rwPnYpnA+ud4GnDMhQIM5AUBg92c7lTldSbXKorTYoYPgzk8wg6oetvRMoU+AVS5FlbcvpToFHPcFHf1DTRzlDeYkDZq8QNhHn1SBeL+evRVH7JDDWPg81TQkHTK4IxzfbLkNxDXRcdn87cBJx4ObPtxNYF9MlCWHCDxQyopHkIdW9L9fdqL7vfjGJ2dc0olUsEIyCTjhVW+kKNRI9X+1cdBFLk1l47GjGJ7ThCnEDWURHRUkSinjiRq3IQhVWjb1VrRsEEkAGoCNTavcuGw8bjeYblNePEH/rOwhULI8pbr04grXg/j82Rw4ygQm7FkRLBOgB48ABamPAFtDjqL5XqdPNLTEzNjtsgL5ydI+yPdDwLN4oWWXPQE5oJocmUmPGFLfF181RkVLCGD6kPWLs4
 j7jLEb42
 YWRvnhP1UurqgpzL8nEJYJWVpo1C5Ucknkr0iHXSKZqN43de8ciuYoalds3Tto3QNrrPnyF/K26RtRBSpgqHbDxVv0li/N3sVK6ApCeJ2pMvj+SjcAofHzJGMA8jwY3SIOooUAdkQ32p5PhZt0ifoIhlzVX8bwIuYUa2l+oLHMV1D2qe0bCfmDcydY197TEHZ8Dvlupl2pyd9eS1G/+dbbEWN1R4BgcxKZrlT9lXmP2eGd74QWr9cfWog4kUMKUesKd6l+J4xFBhbhYcPNFs2EwT+c1CIHxEfGVqym3/6BwahEHPt8Z9HVdxmVzN8lKBqMzSpm0fWR+yV3JNfLbifazgioNnFOT/moITpQJzvYl5LC5YGD3TVOFCNJwFOC7N097kqxGeCcS3SgDVKlAN9XImitF4vvPKzG0Kl/kkZ34b4227aLS5VvUOzTBS+4f7jvruA1s63pAiLg62JxhTE4Cm/3OfHH/uQw74RkmfkrAbcgUcJIXFZTQtq1W8IOn6dN2uwsPh5BWrn9MiwaiV0eM3Td17rPAOr1wB/9TfEVH2wRPs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Anshuman,

Thanks for your patch!

On Tue, 11 Aug 2026 at 06:22, Anshuman Khandual
<anshuman.khandual@arm.com> wrote:
> pxd_ERROR() has been used in generic mm just to print the page table entry
> in pxd_clear_bad() before clearing those out with pxd_clear() later. These
> pxd_ERROR() macros have been provided by all platforms which basically did
> the same thing.
>
> Make pxd_clear_bad() use recently added ptval_to_str() instead for printing
> page table entries thus completely dropping dependency on platform provided
> pxd_ERROR() macros which can then be dropped off. First move all required
> helpers in core MM into a header file which could then be used else where.

Oh, the "x" in "pxd" is a wildcard?
Except that is not, as it does not match "pte" ;-)

> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>

>  arch/m68k/include/asm/mcf_pgtable.h           |  6 ---
>  arch/m68k/include/asm/motorola_pgtable.h      |  8 ----
>  arch/m68k/include/asm/sun3_pgtable.h          |  7 ----

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org> # m68k

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds

