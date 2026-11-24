Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15255606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XTfPpunO
Received: by kanga.kvack.org (Postfix)
	id 30A346B07CD; Tue, 24 Nov 2026 11:59:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3436B07CF; Tue, 24 Nov 2026 11:59:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D2966B07D0; Tue, 24 Nov 2026 11:59:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB0AD6B07CD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:59:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6701B40C78
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:59:09 +0000 (UTC)
X-FDA: 85470622818.11.BB1E716
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6804114000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:59:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XTfPpunO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795539547;
	b=IXDtUnCgiWj255MVMeVn273/vJCIYeN3zyTRwyGqGxS1e+6ubQUxlOy9WHiq8c5M5Jcmq1
	bJf3zTyDGXiChac9887IsNJ1b0vPmAeA2MGkdOI1yc7d92qNziEfAcKthx/WlhloW+6tZT
	0HuhBzTw7AVPYJQkBy0Sw7Tf81LtDak=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795539547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Czsesa5ZeOVdF9UZnZPtwINhyqTnZrrNDtc5MtD/hAc=;
	b=sMWNgBMhyjO3JEHc+GTu9FlAW3psQQHR1WYStpTJckfjxAe9Sl/m1EvYO7NTXFY75HVj5J
	EbneGN9bqpKnOv6bY674mrorJLSabmyXHlpj921U9DGqwjcKdpXflis4g1kMofoFAIHDj5
	8pjMlE0r2NebdVsoYnDWATqGKilm3uc=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=XTfPpunO;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.54 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c4cb6834eaaso791864766b.2
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:59:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795539546; cv=none;
        d=google.com; s=arc-20260327;
        b=P57P4If8SQU0qnqbfOnYP4su1TN+kKkIEcqbJFKduHlluHs3pCobspcQsse1hpzGJO
         dgUPg1XP7WsuY6QvS7XSzbUWnmMCot8j+w1fvGlr5mNCIXPFvBFbdIBuJWVJ2/hrWxvw
         SOYCMVHZQAPOh5t0WDr+ivjK+jq/cwMaL6+D7rmFQiipqKCIsTmGK836SCTFVzIqNLNp
         RQT4S0WpWyZd7bND7d+J53kKW1hehC0cobGNMXxvpQQXuvAaslpGdr7cz9/Cv0oRS57H
         4QofjXOChYLIY2tXtQ5Ai5dNiugO4U3GBVdx6sPdU6hTHnDFLJ86wkhBn2PUPfa0UgsA
         K4sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Czsesa5ZeOVdF9UZnZPtwINhyqTnZrrNDtc5MtD/hAc=;
        fh=Sb7YnIoZvgiPNi68haJF32+HJgbF2O4qJOo5GgDXSGw=;
        b=fsbH87VE4/6niM5SfGc/+uAh+gqIoIG9Dm/m+nTS25LWAuK85JLnGZ6iz300sSzHRu
         P6KT52dbXtGHGsA3Akgrn0FPtozuRptL2meeYYm7rXwI5BrnY17NGpsZMw+/Zpipub3/
         IJnN86FqtTcavHvIIOKJuOyTAGNLUVgp34zwbkpttnnnc/tHfmZ1iG+Qx75jFvzBbqh9
         qRwfVqvXj8hTOrEWrz58LZ2UpwY6JqLqEzsaoE1OXItMV/0I56FwycYgmYtGR2Drw/9j
         djJEFUBiTsjh82ldYNANpDdQZgRsp9Sj7yH0PsckK+UTeMMdely3U9l13ne7+/ul7W8V
         mnzg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795539546; x=1796144346; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Czsesa5ZeOVdF9UZnZPtwINhyqTnZrrNDtc5MtD/hAc=;
        b=XTfPpunO0KWg2DlJjlX74EnMPpHj+RwQJIXBVKtxx8XeiBGzsLfE3fp7ARCnzpxvW6
         i7yyd95ANzUCXKL9kGHLD8da2WSnRsqFR56UCY5ETOiVDoS/791ToTHjZWvjHiJ15tcj
         uJQl8DP7L+bWJsGUlVnCrou7i4vaX8K519qofd5fBXImIPtFpyuL1QUaZZRMywKik2mX
         q8s4TBw4higWJl6EqR/nsk6QmBdEI3sbTryqLJ0xORGVVb6rNh1o6iLLH7KQUmPjtY2Q
         QuCBWpKUyphl+5JPOaM4vxkL47Ks3M051R8ZbTWgnf6x+TI6MAiz20+ILhz5ViO6Pp2U
         gDfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795539546; x=1796144346;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Czsesa5ZeOVdF9UZnZPtwINhyqTnZrrNDtc5MtD/hAc=;
        b=QewMcHFnITpoLdhZvf1gBkxnEm5NWlrr+1jpE6fgkKRGkrbNlN7S51R03tRX7rZOCA
         iBJbB+7n/s6UErXq0w4PSf0nz0sHB7Xe0ldoSa3nNBqBoqdGYX5Z2WO2AiW9XNcar9Sh
         d6B56rPdzdQQ5TsavHHc5L+mSh+VPqe3kn3fdL89lylaWWKQeq8gxrEQDeineRAy5r7M
         CoZW3QPlszFo8Hj2+HHpA35+iBL5gzdYtLFtBuR+jQF0kKzLkok+jtgOJIPdK2n7AGm0
         Fjy3o1s+NGxJuFVHNt9KDdcnZbW1uqj2/bNPOEUDV5hxeVDae5fESD6iedJh6J/SH298
         szUA==
X-Forwarded-Encrypted: i=1; AL+hErHOBnVZ+frB/Cp6VodIeZ1kIFD6Wm7K4rco0tVs/fgH93F3ve3tkz2ixRy4+NOm6pZr5p7WxrWa0A==@kvack.org
X-Gm-Message-State: APuU4Z8fnjhXGCmGalxh08sjYTAEZo19WDtenHq6Al9VVWoaoOHKEevj
	Y9TeFFJT8+ipRCbAXggeULpx1sSqiW34Ti2kfAXbHhA6tG/1WQCUSZ67A3M7dFEEJ8Qu8O8zQQD
	DzGeIQ5mHvqNs+RFVYGxm4KEji42dGhhbqedTIMsx
X-Gm-Gg: AZFdTZclaVGH4uTAT2VTbLsE41cBBQqpewWW8jxzRss3V+RZvdgNAXeSYCq3fiJj/7P
	5zSpkj+6POBQitI2FI58Nbailhe0YUJq5l95IJpEZh8VkbswBNpMM7PhGGht941ErXzRA+JZcE3
	MFdeLaoKQFQj4d0OaLpMFLNdZPd1eW8LMZLARmFdkSzI10OOkkIjHva0T74Ft40kYF10JhPRuFS
	bqdSuoe/ELPFVoHPB0f4aIcGl80rmKeWEo17JPOVCvuvWtJpGed0pTyeuZQxmIG++e7A0vxMJdu
	3e5NG5PgQVls8gKmcQTk5TYB5QD60Q3Hz0SVNIOEoF7hpjhcKNcYc5UYm8DAh4qCOtnKF0Rwi8i
	Pu+t5ew1+E6bd/zoNUf4iNoMU3yrsfwILHRRmay5hTxSCC4XHdLyjEUC91/9mX1Z9DImPm5lsJc
	+dw2Lwu+HPaec6Xta3DPY3ClErF8TAv9e3HnurRWCDge0h64mScxia
X-Received: by 2002:a17:907:9d1a:b0:c51:3b58:b99b with SMTP id
 a640c23a62f3a-c513b58bc59mr1253328666b.19.1795539545161; Tue, 24 Nov 2026
 08:59:05 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-7-jthoughton@google.com> <CF94E7D7-87D2-4523-9343-512EE00094FA@linux.dev>
In-Reply-To: <CF94E7D7-87D2-4523-9343-512EE00094FA@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 11:58:27 -0500
X-Gm-Features: Aa3M54ohYXliwBIhyvf_be5zFFZBRmz0PsOJzrNeOCUHJCfDe6sQjb1ES_TJZKg
Message-ID: <CADrL8HW8+eFt5f1VBQ0zt-ioiU3X150W4ROaKf2Nzw4j9+0i_Q@mail.gmail.com>
Subject: Re: [PATCH v3 06/19] hugetlb: Optimize bootmem folios that were not pre-HVOed
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6804114000B
X-Stat-Signature: uwqwf1t4w9a53rq3agu77rk6tzc96zz1
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795539547-713185
X-HE-Meta: U2FsdGVkX1/oF32f06CTBOBsCQszEfCEWfdd/Dw1OGOk92nTCn/pZ3j3CmEkAcjP4yfLN1098WJdalBAEiwpq3M+jRYnzhbuf+JxN3z5skcMM1sZVy9tEW2/VYOHNxuuc9NGv6gud54ypPnaTbYRilu8H2fGBiE78bKw4gN1y2xf7aro/14WwRZeTXGKgvzYUOmzt9ES5IUjEGUw9NFdwMop/H0qfPZEUoJEt79ksN/dQV/6CTMRJsOhx4fqfvFyL75WaFcimO3nMc2NXXBG/H+Mt06e1G9ErL84aSF8x1hmQjFLQwh1T7tPrIUk32oT4mXor6LKsU3JMxFvrELLPaTyBZNiZu/LeFqxQplVINfmEtZTYgG+ZS/UtuSUYkJ3ezkuBAKvZPZ2FDfzxD/F/6AqotJb3Q1Y4CrYUxWh4O0m4YUOb1dV6taNjkffmzatopA8lArBH4VBW63Npuwj81Y00YKzTdXW6P1/b+HoBCKWzRy3wFsmxKeNODoZW2ZTozjSesFM9SLdIQbGtf8YsIk0SX1eL1RF7f5X3h2Bg4/FC0w6X8nmpUjf1MsZYdp2MHb8uKxhpTlWEF2JLbXjCF4dz6q/POAmWGufRUYcLBPVyg97h2IMrYTdGH3bVSnyYoZEBsiIf23GVOi4QTtUI7LzI8Y54Xrc8yze9MnbtuojtT2mCQA5C1t3qU4A/MqI6zOKj18t80LEWuox4xdrUbS5FngyLovwyyhR63FBpGax7vM6QCUZ7Oqc30IbPnmxoouARsItBI7IzUvBhbJAgo0Gzm6Le41+AoisNMPfrGaOG7LQnpmwGlfk9VRPT51NTwbjFBk9rS0OJqVy6jRGKkipUOmE1p6Gp0nF+RdpjLh3Qc4X0QmWQprMmpFky5RxEzRMLuHGtvTknhX6zXfJRcXx9QwgBNgTYCfzRfxCwZjp4tiSjqomSEmliR/P6DABd2op2cghr4bz8NzRbZq
 nSiokodl
 7afUBzuBj3jxfosbQjRhxSWMpROKpvgMbToSOQDzZbVgsz3JzLv8/RpjZ6NoA0Ofhn1tjif0kTXwa5ob2/O2Pv8Omnq0K1IHPzTToBykkaLOa/Fc6nllq9fi1gcJoybkaR6rEHRLqksJnaA4IWGNHYHqdcJ/lES9+F5o9+0tCuRPitxD3a9zEy/Okq5F/G33eX4l3g4zq8ruU6WNV2xdTXFXH81xIcApqC6JUqF19klpHTznEhudFJ3Qc2lznE93YfMDTyQJv1NchbHSJ45s/wVFnTjH7ecMi5JSDLgSw2YXpL586SVsWwDPTvoKfjkIMnJvMkPK6AvDjfAMiyZNzPFZoufjRTIn/MpPiL1Nd/RWUthDRbrpa3YtdLpE1xXbOSlJkAZZpPBP8/TCA40jc820tu6n2LR5C5ex4CZc6a3PcgSlyUa6FEuXjfLHBbhli1Qz8GOx8HF+JsPx6Z6I14kguBfpWShWoacFVhRu0/mB9G8oOC8xltdDpeEVGQG5uTOX+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 10:11=E2=80=AFPM Muchun Song <muchun.song@linux.dev=
> wrote:
>
>
>
> > On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> wrote=
:
> >
> > Boot-time gigantic folios are expected to be pre-HVOed through the
> > section-based vmemmap optimization, so the bulk optimization pass for
> > bootmem folios was dropped.
> >
> > However, arch_support_vmemmap_remap() may not yet
> > return true when bootmem folios are allocated (e.g. on arm64, where
> > support depends on a system-wide CPU capability), while it does return
> > true by the time the bootmem folios are gathered. Such architectures
> > disable the section-based vmemmap optimization in their vmemmap
> > population path (see section_vmemmap_optimization_disable()), so the
> > folios are not pre-HVOed and would never be optimized.
>
> Yeah, when I removed support for this part of the code, I figured you
> might add a new patch in the future to add support back. It is fine.
>
> >
> > Optimize such folios when gathering bootmem folios. Their tail struct
> > pages have all been initialized by memmap_init_compound_page(),
> > as they were not pre-HVOed. Pre-HVOed folios are skipped by
> > vmemmap_should_optimize_folio().
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > mm/hugetlb.c | 11 +++++++++++
> > 1 file changed, 11 insertions(+)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 72839e98f998..8756c0206922 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -3325,6 +3325,17 @@ static void __init prep_and_add_bootmem_folios(s=
truct hstate *h,
> >       unsigned long flags;
> >       struct folio *folio, *tmp_f;
> >
> > +     /*
> > +      * Bootmem folios are normally pre-HVOed through the section-base=
d
> > +      * vmemmap optimization. However, an architecture that can only
> > +      * determine whether it supports HVO after bootmem allocation dis=
ables
> > +      * the section-based optimization (see
> > +      * section_vmemmap_optimization_disable()), in which case the fol=
ios
> > +      * were not pre-HVOed and must be optimized now. Pre-HVOed folios=
 are
> > +      * skipped.
> > +      */
>
> I'd like to condense these comments to something like:
>
> /*
>  * Some architectures do not support section-based vmemmap optimization,
>  * so their bootmem folios should be optimized here with folio-based
>  * optimization.
>  */

Applied in v4, thanks!

Also just so you don't miss it, would appreciate your thoughts on my
reply to Sashiko's comments on this patch[1]. Let me know if you would
like me to do something different.

[1] https://lore.kernel.org/linux-mm/20261124165516.1182390-1-jthoughton@go=
ogle.com/

