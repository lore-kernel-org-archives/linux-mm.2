Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BF1606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 18:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nNEgJyzo
Received: by kanga.kvack.org (Postfix)
	id 9CCA76B00EF; Fri, 30 Oct 2026 14:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97D066B05B1; Fri, 30 Oct 2026 14:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6EE6B05B2; Fri, 30 Oct 2026 14:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5581E6B00EF
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:57:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC0071603AA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:57:48 +0000 (UTC)
X-FDA: 85380201816.26.32F6A37
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id D965440002
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:57:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nNEgJyzo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793386666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pRBcY3homIpP5xla9/0NQdaZWVwsVBzqgn0COlmfJcY=;
	b=fpVx3sUHaOCWVwLsDkI3q7Mruof1ToZMz6UOMjYQrAd4/GI1+YEk3QLbdYJQQ94KCsxtPE
	8VjEzKEMKH3wv6UgjVNc8OrZHy2v0h07gFZqiyI/bIL0B8Dr3d97RWXEgPqifmq1/J1TlJ
	iQ3drctsu8Iq0tJqF010ZXmRl5A5htQ=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=nNEgJyzo;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.50 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793386666;
	b=mN+FNEhF1WHn5iAqA9iFQWXTdMiXCMsr7lVTsIMuF6Y4dI5JOveeLmMNXGTGafmQBljRGo
	LHQO0XPVqOptLP4gIo9b6tsNG1FNqMdy5kgCV1AqGHIDouks1A9KUo0f9QyRVi9HLBeHie
	81YOEVe3ZBvhxMKzE4hrc7W6fuY07y4=
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5ba35c0df4fso1169029e87.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 11:57:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793386665; cv=none;
        d=google.com; s=arc-20260327;
        b=VJWL39upopHy3Kf6KcuyV13kEwm5UwZUERgD1SvHdJO3rPT/UFpde1eeKaUbTph3gG
         vhRccODD4BAhLQIYKmzhYVlehlVQOH8D+COlFDjUnLrK7NKMZ5Xt/dlskBVO6pJjiPLM
         klb+9UVO9HHBjE3K7zU2jtNjHp+sgIyx4AAGkPrTCDG8R5se0XyN5XXcDNtqBHEdqagq
         7dRYoj9qrmZwxsyyhlQkjki/Ton7LmQ4uZOyCy9HX4jQbQ5F1JB2bCKhyj2OSPVGDmRj
         Jf66di/aBHhbopaJhJylpSN3COKcYs3oDr05KXn6YRJM5kYKgcn/piYkAMYmcpK7ETB+
         dR0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pRBcY3homIpP5xla9/0NQdaZWVwsVBzqgn0COlmfJcY=;
        fh=ZpzID0xc82vKPCTeUXXXhovt5qq/fQ3/bMHxniMkmGs=;
        b=eu0If887JooDWKtLP1FaUw6G0iXQh6op/C0ADzOZtQEFylEyHpxWnrI3hOn0ubXe2G
         rP7wZN9wNp8sywNkB9Fzw5WyLbCcck6FLo+ULIoua6dunyR4z6kymj0RwXntLbob1Kmv
         D5i8K3Yuq5HUHom7JQS1jp58J6Ql3h9yF2TLnxsakgvuaZSfCEaiCsyNBP9D3zilMDer
         tGO9GcoWuBrcusO66/bcv2yPxBo7eIVXZiEUJfS/W+t5l/MmdhFQXMraeRtNh2/T/dzQ
         CXveOZJEAK3u6BSpYiJ9DAxRNkWyvBKCkldSX+DeoL2YAERrkFYNjPRjP60StSdHk4Ve
         Rr2Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793386665; x=1793991465; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pRBcY3homIpP5xla9/0NQdaZWVwsVBzqgn0COlmfJcY=;
        b=nNEgJyzoB5DXWXu1h0W8D5NCPRgH+e7s84tsEaTIHtagvkXCZDCXng50Q05b5SSH/p
         jXTK0rivnFzvRvBDmASJMtOsxm8pDrur4reJdQAgGrpmMYrIBXB/mIuZYL08pyO0X0C/
         1k1eyVn9Rh/IcddUFU1X9+cmRuxoNdGV+9FgZX3aRz3By1KVg+HylzCR8muKVx58QYzD
         dvtNUKA6BRLd+GYYB06xDaH8SVoVlV/UUU2JT4Ey5dJveSBfvq6osMqUcIi+aAV1FmvM
         4YrMAKdiego4U+wCLcjm1e7bSkJ9ucDF/JljrmzviKWqtaXwiYZ/XsZWGalR1RKtA3IO
         GDQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793386665; x=1793991465;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pRBcY3homIpP5xla9/0NQdaZWVwsVBzqgn0COlmfJcY=;
        b=G//HP/8MFnXQoXJ21Z2+xlcY6RITDeaGiNg+1b2vvMP7/VH+jSAaKsx9XanUDp3tiN
         yK/rsgj1K6WhBTZLPb6QswzeV7RAUgYXzLliddvd+Wcr+jk1y7RyYG1zTZ35gWlCxkLc
         LWjj3j3uu9dbNQyCbUOB4HGhuxZn8u7mWmsl0+FTCmjhGapRtgbcL6cwAWCXpthr8knJ
         nicAHeXkzOYZchMxya3KlpaRdVD1dtl8XzMI/yBTwUWVNSzI7dvCuwPR4dUBYom1/Tk/
         /YYmc884FAJP4bQ5zXcEA5T3cYH6w+gCIZhZ4mIqixlveNYm7sJad6NhWyiKfWvtViz4
         VIlg==
X-Forwarded-Encrypted: i=1; AKwUvBym6tx7QVijhfBQ1MI+xiLuthAs8qOO1hHd/VjbzaaxQC1319seGlO/Rz3YidM/KQAw/Sloy0FTew==@kvack.org
X-Gm-Message-State: AFq9FYJsuMM3LIHQZ/VzVpNk4tmyA9KwcGrPjjEXEjCPA2bUtDggL7TK
	0JQDIM8f6Rp7lzta7TvUTlS6UpmQ+QMxQ5E4iIrZljHYGLWIVW05PadNfgV9jLMhORO+c4ptqxz
	ZpoqXMO8L1bBD40HhieCrhgi4fHYesKg=
X-Gm-Gg: AYBFou1UpV5YsB1EyRtBKVFc/QPFXWXk9m4EJ62C+6zt/rgMm6WxbikAK5GNhdR0MWv
	E7/y2KS/y8oHyCKmUExTRXNJEFho1/fFWut5uTkSVD9QCuk2+EsSAoRf0KNkCC8BeAf4Z+5xQ0D
	E31dZYcU5qHAxbn9zsMr3HoGR4x9rj8QU0o7zBjZZJu39zYE2oNneah3k8zOqpxOPiYC1HHQvCi
	lzrNmd3VNZPFHo7mlPwfzmuHDki20PUs4Ek7Dxap+p2azse11yYCHHw7Ybf/PO3lnyJaryeWoiC
	AAl1gsIzdwipOv7DMAPhGl4EWVi0Q5aRvV5Uw/DxhPM8FHL0hwoYDtAxdDFaySHF/EYBKniSw91
	veCyzcgYNZXUcR4Zg/NmbOVjBKvrokI58amWnlfk1/lkBxFrpf8ForzoyKg==
X-Received: by 2002:a05:6512:23a5:b0:5bf:ae0d:5c8e with SMTP id
 2adb3069b0e04-5bfd957c5b8mr1213952e87.57.1793386665018; Fri, 30 Oct 2026
 11:57:45 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-7-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188658@kernel.org>
 <auQhULh1VTh6lWoe@gondor.apana.org.au> <CACpmpodWMtmE0yNVN656K-8fPZgTj_DSZ0J7qxou+5Asoht+4A@mail.gmail.com>
 <auQwWgMbBuo0YEBI@gondor.apana.org.au> <CACpmpodxvQCkQgXUU6pF8d7onxHvHF7sEYCbTkv81WXyyrFiEg@mail.gmail.com>
 <CAO9r8zNvy7ftXsmLnj4qbQYJ5nyQo=hrio4UQvNrpMbwj9YbMg@mail.gmail.com>
In-Reply-To: <CAO9r8zNvy7ftXsmLnj4qbQYJ5nyQo=hrio4UQvNrpMbwj9YbMg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 30 Oct 2026 11:57:32 -0700
X-Gm-Features: AclHuK9yf0museVZzj5aEtQylAllkhugfekxs2Uqb3nStINOr4M3_o9XKSMDYxk
Message-ID: <CACpmpodboNxOLAKRxOL75HtPawJ_rhOXUh1_UW1aDtA8NA5sxg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm: zswap: Store large folios in batches.
To: Yosry Ahmed <yosry@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, sashiko-reviews@lists.linux.dev, 
	hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D965440002
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: ot8qix9shxj5xtmof6zek3xe8e6dbg6w
X-HE-Tag: 1793386666-848947
X-HE-Meta: U2FsdGVkX1+a/dDo5APFvH8qwlb778gYciiyf7v7n5Pt3zmTgfjZnkK2fSe/vKpqvlErT0/n+USQvTytK/Cm37/zqO+CG6xH87RttnSIRjJf1+f0naLfFMN95oQHMByq2H+P1NSNmYepxuBL5NfbofK2wLV5CifpX2Fh4JqVwE9eK+U+LG+9SU6D+P9V7bCeQO/11JfksIw3jWau1OwQntGeVDNT3ItHsu6pZr/AFYAdGDG7fxIPHv6GZo0WqAinYzNsMgjmf9Ss+8FduNbCbUJ9sLACovUYJWRLZZ7hpwN+6FOcc0fsDKvRAI2AqEi/BpUBK+it2cfjJUR+/1sMjbbdOfivJiGXVjK979EzuFTZiZ/m7epo01xTqgnwExQDjVuzmH85n3jtVJMGVyMde0gBRdR8PlTo1GFv50KGtlgLiIXJJZABLBCO29BfXRHKKB2Emj9352VjKyTgeggW4CmwV/UjAF5/QVXBM9Ozt2UVoytKX/jRFVKNxU9l1Ji0Q/XmKkP/BU/REQXTVDb9YydIbXFhVI4nCFqZzGiCg+Lq/E/rhgnQmPjS5cFvAwMaA3gaEw5352S70dNmEDcpAXO8DKm+yqK5ryhJkZ5b5udzeqsYaqMPRMt2F8MZI6/aO2Hevo24wj9rV7wA9kSBM2LBQCYPHNwNko7+TziJp5xTsUSU8DvXYgWMJ/0sTfGHwm8c4fzkSwrDnUcThCywqL0Yl49EV4WOU6Mg4/NB9LJuOoeLBSGxH4++UUkFx8c1mKMl9WUE4qsKussvaExzqMqtV7E+vvVI4fePsGEJNvabP5uBNpHiTbvwxZw+INuqpcqrgKx2p8ihub0voGbOw68HGC7/0fQt1enT6m0JH57ZK2VhK76+1P0FqF8ORMVTM1BM01VnwsZf3fggHjs1bloqjJgyxQwRbcCB4j30eyPwOQFop0nMDHrBxv9qZcSZPVpybq6fQFxb86xCSRw
 UfplmMl4
 v9047RDftLcsVxBfOFOYqGNe2J5mtfmBIsY6n1D9uBP2iUD3rr4Pyj6X65hxgeo/xBRNsSmEtGsD+eH/w08BpGZjGAsIvigvZmrc7lCbbhAt/xZnlY2wHQGjAnQeX8O0dHBlpD7mvflLBdYFNfQTRWytWfY9Pl+EnCuT/+TJr0Jk2GqrDFSq/PdSGrzgpBm+dNlHi2sxRQS1N0i77Crag0TXTFEsL4uS60bEg0G3o2TTOUwBB667435L1yoUX5OTm8FCFlgM480zWCTXADFCrcpxpoY0i2mdTGRICjgHKGiyLsq70F3Sxlt9lRF4REeR8NXBMl3DzLsemXjK8th60a+Dekq9QGYuSJcI/J+DMVLJpa1+SvJYnTsM/k2aL3yz5o9upUYqDkX1d3NicKjp7ZsalFzJOas7b/7vT+PXaUbUNRwAGSQyPfOBIPjGviCXbT/SrhoUYrGC3BUG3j5Rraxd1zgJc3PcwFGtZ1nK4AM6AglHKXF/SEqPIpPjJmbUpNuvI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 7:49=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 29, 2026 at 11:19=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Thu, Oct 29, 2026 at 10:51=E2=80=AFPM Herbert Xu <herbert@gondor.apa=
na.org.au> wrote:
> > >
> > > On Thu, Oct 29, 2026 at 10:15:15PM -0700, Kanchana P. Sridhar wrote:
> > > >
> > > > This is how it is in the current mainline, and has been for as long=
 as
> > > > I can remember.. I assumed it was because we need a per-CPU acomp_r=
eq
> > > > to be allocated for the tfm. Can this be done with a single
> > > > crypto_acomp for a given algorithm?
> > >
> > > The request needs to be per-cpu, but the tfm does not.
> >
> > Great.. we can save a lot of memory this way.
> >
> > Yosry, should I go ahead and include this fix in this patch series? I
> > am Ok if you want to take this up.
>
> Feel free to send a patch, but I think it doesn't have to be part of the =
series.

Sure.

