Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52036FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:55:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA89F6B0095; Tue, 28 Apr 2026 09:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32C56B0096; Tue, 28 Apr 2026 09:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB106B0098; Tue, 28 Apr 2026 09:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E7266B0095
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:55:54 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F457401A9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:55:54 +0000 (UTC)
X-FDA: 84708113028.12.BC485BF
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 301FC40007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:55:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rxXV8XkD;
	spf=pass (imf12.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777384552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BbbNkttGRsdp0UF5vHVPSBq8ozj7GYPtZZgWOIuuk20=;
	b=AuXaxFr9qvZptM22GiMVd7gYzJEdK6AFeB0GWk79HFW3tOdfEDpn8JwdwZEodfeKIRWmY6
	u/zyfbqR45fWkLDvbkyZYAYQzJHaadfsEpn1DWR8j6DK20ZKUN8tF92BbnD9W9a4w2oGc8
	n0pgPKrXXRVtcEjVMZGhN6p3UT+kNU8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777384552; a=rsa-sha256;
	cv=pass;
	b=Kk+x5jSgQpsZLRI9GNJepeX/o0VZXln3qkWe1B0qxcxvY+fWSbAcgcHEJKNPR6D4Z58MU8
	3kEeDN6Ek50EQtWhrB4Q3jf/6uGAPGvRajM+nGm9g8id7DOMyfz8Xh1SWLsR2xNwwkwBsE
	tQaTmscBoXYCzZ9j6tTeJNXD+YL/edo=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rxXV8XkD;
	spf=pass (imf12.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7a43424f861so101976857b3.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:55:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777384551; cv=none;
        d=google.com; s=arc-20240605;
        b=OX8riCAqhpShXJuQJlzrYP7osMO+sbRTNQQprpj42fqTpY2MZjSgFKv4MFFesilZZF
         J1t10bGI/nr81eYKLlb9SBkhCP/5q9oaTRhN68x999QzGpBWROD9i961NftIsJmoO6Hv
         ZbNOqwqGNXFku98RONt5JoweJgM2R+tw6lC2eSnnLdV2P8Pd+qIPQYMv1IRObj0i9++b
         hD9Mc4Dmc8mcWxe2r5Q8+QSfWe2WIdhBj5uY1hB6nbI559OzZI+hykHIX6HAjJs/CE8P
         2IE5WmGf1nvbM1Qd0ghztR9Sg2a88PXdxvm06LiHANXDWpkUiefSUS4uBXoA8MVAg5Q9
         xooQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BbbNkttGRsdp0UF5vHVPSBq8ozj7GYPtZZgWOIuuk20=;
        fh=AfRb4SjUnaCWUNs6FGIBZOQSuAZUT9sGLZj/6p5SFU4=;
        b=KmrHNy60d4Rod+7KJKhb5ULXHrmFuefJx1IMLpeCb99+aQVQpc9j6DprL8bv1uMB6Z
         wr5N4KQijrynkDfzkgBUNnV5RZFhSSJbnoEA/aX2pFZOkJpxJ5u4J56IlxIUkD1QXlmQ
         il0JXQ+/x66wg+s1VSfuh6XgzcHD7XFUT2AKjAOUpqo5k2hRfEM48jEjHzANMTnMGeFs
         LHhQF1w/Q0FOwxTvmZ7cBrsF4yJsMyek6IC6wLQVVhEZt6b1rjZ9c3IJ/dKCsi5HAxPX
         WtMQYEA+fqGyYXDWSswN0DIj98iCviqLoNK95lSxHDEuy0xZJvELtyaVat4C2xnepghB
         V89w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777384551; x=1777989351; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BbbNkttGRsdp0UF5vHVPSBq8ozj7GYPtZZgWOIuuk20=;
        b=rxXV8XkDf9iwegPQh9xIHGTMqcUl6tV3msvO1uLmRShOh17rr/BBu5E1tawI1jEISH
         9Lk5wZ4TWvMhfNXrUVhj2XJebyXkT1WtUkGEmoE+1rZFig0lICIWDqQdrdqz9Diq+DdI
         E73sni8fLiZHF9UP6oXS12OKSfYivMv9ZgFLif+gh18KFh99HPzPPFTEgcGI7+Agxoue
         fxHXE5i5hYZne8M8L8i6+KTmNXjd3NnLaZGntRy26idaWdzNLbVuLoCo7x5MlqbrbIX5
         d7vSNHjn6N3w/YaPcx3JbnFVUZrSyxt/yq/MfbwPucEoysgDzlWNNPtCrq1POpks/P07
         47ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777384551; x=1777989351;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BbbNkttGRsdp0UF5vHVPSBq8ozj7GYPtZZgWOIuuk20=;
        b=Vtbki+rIwv3lAQJpNjkRdeJX7uURqvNtklcHChtZNwA7b3ergXTFR4HVsezXHkVu3F
         qUfrYxzYxNahMuw6wD9wey0Fg6lK+hcxfH+ulUAtX7HkavmbPOApAGItLwCKh5mRoc/4
         ULlUyeBF5R1dPzGoAr5a1C6ZsneezHe+IiaU/kTdqMZ5a0BpPQZuRjYQplmxRqiO95Qy
         wgwznkweWoJK+MJiknmZ3k4qht2OXpHM4Tu+CPa19NSFh0QOmVPJjueYUVG9UXr8v1pJ
         5sRRTHojHtZ0cyhZHF8lA/Qr6UwOMy7XY3YcnmnteTaOG/OxJIbqMNt1SO6JGET70Im1
         ASuQ==
X-Forwarded-Encrypted: i=1; AFNElJ8L0UuBgQoGXF09U+fH+Z+kfR4RRTbdxGXl+CKunf5BkoHawNW/O9XuZuLI0ptfE60tok8QM8ik9w==@kvack.org
X-Gm-Message-State: AOJu0YzRV+1k+oje8EjGHnJhqyPXmpceNM8VFbNqarOwYDkla8pbUWuG
	Yhu4FdaPeHKK2coQyw/aw3gA8PNkPdBviqGPMYTsHorq9KvfvjfIUH7ss2Vg+m8+0skn3BL5Ipk
	FPNm4XDtAatoNmWKs0ZCG0jQTZeo1aNw=
X-Gm-Gg: AeBDiev0UBpCywdI+3xDBC2SAW8Om3xzxpHJvkQG8b1ow1RwItSJRUenaN6pvreNbDe
	WFipdxRmQerNmmmkhEIAQO0+lemw1yMtjYopXUC5QwJ30MOWWnOrsKxWVXEEmGw8RKlxIIcht81
	fJDcCnst49ILMEKUCHKvcVh5iLV6XnzoRGwVS2j2WlunuFc15x0okZ14lkaG1vRYBrTlyo9z2ae
	9jdtzHHnQU0bCA8yQl3hE33AUpSojb73JSCWORzjh5hCBB/5ojtDpe5cwdJsCl2xykTvahnKSQM
	LoBNfzfjkSkPNAvfrKg=
X-Received: by 2002:a05:690c:c512:b0:79a:daf7:c4fb with SMTP id
 00721157ae682-7bcf58cde6amr29746407b3.50.1777384551189; Tue, 28 Apr 2026
 06:55:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com> <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
In-Reply-To: <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Tue, 28 Apr 2026 21:55:39 +0800
X-Gm-Features: AVHnY4IdYFVazQhWRf-bCyNur_5HOeGzyx6wM83z8Dkqm_NMzDCTYUO9hSgoPgk
Message-ID: <CAOptpSOO5o4HVUVEX=9D74EjswP0=XRA8aDuZQM8w5UCSoktUA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Yosry Ahmed <yosry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 301FC40007
X-Rspam-User: 
X-Stat-Signature: 5wsigipfh9fqpkbzgz3ngk4igckjgbgs
X-HE-Tag: 1777384551-663879
X-HE-Meta: U2FsdGVkX1/7HCBKMtmPtA4ephp79LAy76CYy+kNFjHAiK9c1dtMT9rr7DhBzXh2g9vBGzwY9thSvmT4vh4zSRsxqdEESkEcG1H9viPfKLqzowhWnzhWRe+hCNUQ5XjZD09sWqmI3zUs04vexkDTOJI6038jZ7J1k01blxAluh6O0LsxkW5jgXB7ppa7bv3cBQsiXKyZ0eDM5yWDC4kh1odkseNmBoZJJIRAniy4IuoECoHxoktz+sIYxD77ev1e9yraYJ7Na4tyezQvKYzdCxAXXjyVMRFYSpv2dzL9a/dI0OHnl2B+M5+IALoWh1tZqaUcGj/3gvSF82PsWhoDtXrdxJZ7W9Ok7F1ORzcCae7rThikXVzIyZYmzAQ66aZ2b4ctVN+hnh1bq9ux3d6d81k6CYRBLyY5uUdC5QaOm/YUWRHDBnJRvleR7bMGm8f4BNcsFE6wRyDq3an+q+vRmORvurduvGDGvQateEmMlKbAAy7SRcxUPLLh4bHi1zVXB4OMFZL415CicmgQcdcmP4nKJ9cyJ6vnOzKTRNbiwghvuxN46i0NSc6s7Rxc7T8txAgf25/uIsm4wfxzY5PXr/oEnQb708ziONVcAaPW+E+NEzRUq2b/kP8xgSYesjUdYU5gI3bSKoeQCu0sjWCFCdamWI3uCXheIj6CNSNECHltsCkIurypEwDT/xAB47+LPu4EEoWgxwNHOkD2Wovp3GO94aj2AOiGfrJ1JXTCHX2RPYf7kXibSgutixvFjzmQUrUGWJHJI+PgTPgd+McBVDfsXK9z+PccZDPw06de5GeVFUVnm1xPt5s0fBaVyz8YMKuDTVCNskZU5hVP08QDHEB9lEXISOx7wNcnfWLSHh0LulCjFB6lVyatGK3jX3EmLQQc/2/xivLtW+aLjOgea3Ll6GP2Uy4EfHU0QQUVN8XXl4mcyrDO2fPw10qBXKelHjIbvIWFmsfZNbRag2z
 XGCHTIz1
 EP4qKp81GiJIGcyQ5F6IeM2eYvsGPzSgOiFpRzbTE0jK9IQxOInSMmr3Ocggbu64MgymbRrZFf556aR9euKH2KnkQt54Th4X9gyiyLS9tAMfcLRG50OkvdhLU4FvHlgVAghO8izyTZYdehwg5KBlCqXlme0oFSo70JarVkc6ZqzW8y+cnSdmvOPmcS6Kghrz9saUgWcaGoOO5JtOM5enfwhp3JnKt2vIQcY083xMkGTPAORASUD6HpTDsVOdo1yIHeDlhqNIilTon8l7ophrVdBgvEHimFT8PGalaCetuO0uBjGbf5Kckx2NeEttCD/F/4QMsjNA0mSeMAyxQDtc/nE9dj0Td6N3lZkFmUoO9UeSyvCgDSedts0utO8ECsic3OchrhYPkOgeAJuFSviYCuAqBeSvR9JX+v7G4+FSwbLMD+CQUWJxzy1EFr0KEVvryI2UxN23s9RUjv0ebCN1E3hSjsoP6gI+rfGo5KPtk+ugqd3n8Pr1OlcmCcnHIHK3hRpY/y+P0bFriddRdhpzbLiFrapiM7eLDma9quR6LEDInc1vIV55+hBJSsuaS4LbQ8XYy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 9:51=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.com=
> wrote:
>
> On Tue, Apr 28, 2026 at 2:17=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Sat, Apr 25, 2026 at 9:13=E2=80=AFPM Wenchao Hao <haowenchao22@gmail=
.com> wrote:
> > >
> > > On Tue, Apr 21, 2026 at 8:16=E2=80=AFPM Wenchao Hao <haowenchao22@gma=
il.com> wrote:
> > > >
> > > > Swap freeing can be expensive when unmapping a VMA containing
> > > > many swap entries. This has been reported to significantly
> > > > delay memory reclamation during Android's low-memory killing,
> > > > especially when multiple processes are terminated to free
> > > > memory, with slot_free() accounting for more than 80% of
> > > > the total cost of freeing swap entries.
> > > >
> > > > Two earlier attempts by Lei and Zhiguo added a new thread in the mm=
 core
> > > > to asynchronously collect and free swap entries [1][2], but the
> > > > design itself is fairly complex.
> > > >
> > > Hi Nhat, Kairui, Barry, Xueyuan,
> > >
> > > Thanks for the review. I agree with the direction and have some ideas=
 for
> > > an alternative approach.
> > >
> > > My approach: first eliminate pool->lock from zs_free() itself, then d=
efer
> > > free to per-cpu buffers with a lockless handoff, and finally reduce
> > > class->lock overhead during drain by exploiting natural class localit=
y.
> > > Achieving both per-cpu and per-class is difficult, so the class->lock
> > > optimization is a compromise =E2=80=94 but one that works well in pra=
ctice.
> > >
> > > 1. Encode class_idx in obj to eliminate pool->lock
> > >
> > > OBJ_INDEX_BITS is over-provisioned on 64-bit. For example on arm64
> > > (chain_size=3D8): OBJ_INDEX_BITS=3D24 but only 10 bits are actually n=
eeded
> > > for obj_idx, leaving 14 spare bits.
> > > We can split OBJ_INDEX into class_idx + obj_idx:
> > >
> > >     obj: [PFN | class_idx (OBJ_CLASS_BITS) | obj_idx (OBJ_IDX_BITS)]
> > >
> > > OBJ_CLASS_BITS is computed dynamically as `ilog2(ZS_SIZE_CLASSES - 1)=
 + 1`
> > > (8 bits for 4K pages, 9 for 64K).
> > > Since class_idx is invariant across migration (only PFN changes), zs_=
free()
> > > can extract class_idx locklessly, then acquire class->lock and re-rea=
d obj for a
> > > stable PFN. No pool->lock needed.
> >
> > How much of the benefit do we get with just these locking improvements
> > without having to defer any of the freeing work?
> >
>
> Hi Yosry,
>
> Thanks for the review. Great question =E2=80=94 we tested exactly this.
>
> With only the class_idx-in-obj encoding (eliminating pool->lock from
> zs_free, no deferred freeing), we measured on two platforms.
>
> Test: each process independently mmap 256MB, write data, madvise
> MADV_PAGEOUT to swap out via zram (lzo-rle), then concurrent munmap.
>
> Raspberry Pi 4B (4-core ARM64 Cortex-A72):
>
>   mode        Base       ClassIdx-only   Speedup
>   single      59.0ms     56.0ms          1.05x
>   multi 2p    94.6ms     66.7ms          1.42x
>   multi 4p    202.9ms    110.6ms         1.83x
>
> x86 physical machine (4-core Intel i7-12700, 2 rounds averaged):
>
>   mode        Base       ClassIdx-only   Speedup
>   single      11.7ms     9.8ms           1.19x
>   multi 2p    24.1ms     17.2ms          1.40x
>   multi 4p    63.0ms     45.3ms          1.39x
>

Correction on the x86 test description: the machine is a 20-core
Intel i7-12700, not 4-core. The test only ran 4 concurrent
processes. The multi 4p result (1.39x) is with 4 out of 20 cores
active =E2=80=94 pool->lock contention would be higher with more
concurrent processes on this machine.

