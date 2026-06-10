Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04453CD8CA8
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 03:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 373586B0088; Tue,  9 Jun 2026 23:18:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324696B008A; Tue,  9 Jun 2026 23:18:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 213B16B008C; Tue,  9 Jun 2026 23:18:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10A996B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 23:18:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFB7FC2A36
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:18:56 +0000 (UTC)
X-FDA: 84862546272.25.DA0F022
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id B079C14000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:18:54 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UJISTEs/";
	spf=pass (imf09.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781061534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dfYAPciVtr9jey6/6t11PRjkoNLDGMtubbOtNmZP7ME=;
	b=IgJK6VRGRDmqbXd6yzt84NgQzBS0Cnz4Tu21h2ghBh/d36CBFi8Em0pPNsobRxn/GYqdch
	cwP9/q9CoOGnOr83OfO8hmMLUeQ+V4QuFK+/RSfaBDbBdcrRrJywAB8YImo5RUZR0SQgo6
	1pHhg8/7eid9aBQ/z5hZfvMAmKVKAzM=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781061534;
	b=oufc+KINGdHCUEWY7g5Eb+p4hZva9ZDjM7i/gsDTqoA5EEA4ECQ26cu2CFKdD3iphioeCi
	4DStki01O2BrWvjEnaKTHpksqZlFrK8pCDaKeq2ikpxL5TNzGCwTYCd61waVk+chPrR/QL
	Hz1/4RJKa2SBuknGd1qhUQStarbv5L4=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UJISTEs/";
	spf=pass (imf09.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7e2f3646c10so74549747b3.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 20:18:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781061534; cv=none;
        d=google.com; s=arc-20240605;
        b=e7cdgupigTGnc1swpKFPtwgeoD+OCFiBqseT9VqKDd9oGgEDUtTdq/1oLeZKYLmkcY
         FcgupPkvTqcZrURpF2FM0UqdWtDbt14b5fGctA62w13r2N4VCM/7A5dalelLKyVe5NEK
         iUeXQPKzt6nUw26fCG1XCOtt5M1UFFeU1XUWbv47zCZ7BnWXk+Dlcm1ytMy7EXZfV/nG
         nZAoIm2qnGaZC1XQ+I7gSpzGqrgiwvb0OTmmAonTwrr0BFg0HmKVc0HWhJf95dQyAfB6
         Ubnfgq5xYYoZAmI57c+rg/62bimObsciUXdyQ+VvaaezZtiy0SWrV2TKUy4SNDfSEWm0
         QzWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dfYAPciVtr9jey6/6t11PRjkoNLDGMtubbOtNmZP7ME=;
        fh=v7GoWj+s/vgPr/rcHe8NSlMTOXFm1xGMuKCwUiveJrw=;
        b=Z5A70zsVUoqhWQGZu2vA1uyUBMAhk0CZRx2ME9KXPwsZZvU9wdgAMpKc7+4LZizlZ4
         auz8803xHxmE6DisTJD2+Lv9nbrox7nwKHbRNHmdTae3rJnfVLa6zZqrKwCPjHqfcoKZ
         J69RY+8r+BwEl5EDflitCOGt8RlvTpujebQP7tVgS8Y4sOf8TBoSfkeHhcIddr2dMs79
         3Yq7q2O3K5V9QyGpfN17psFqGFJGtNs5MfLruYSUFzn/V9Exz6Y8D20QjuwVq1HVAUqn
         Sspc+TZjQCqNI2RlWaDcuqfd3agAqFKMcC21/7LSCGwM/IoTLc5YIDBphgaHw38qBOLC
         T27Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781061534; x=1781666334; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dfYAPciVtr9jey6/6t11PRjkoNLDGMtubbOtNmZP7ME=;
        b=UJISTEs/iTLtSHpd63x3QLXdVZlZIN2g8blwQ1bq9707f6zMemLCTiTJPe2mtZ+rey
         WdzkVGV6+LBts/5IvIjuNyWH+dsRs81fl5CuqJlXjIflWga1z1JdNvXnbEU8IBc7bHKS
         dsGqCTB4oxgeCwMZysf97xW2MNK3mqsO8RoqzBQsGpTMpo3beiIumGgimvvVDaOdaHK5
         pwHBkRsmif+0o8K3bzqEVhi/NQBh2MT33pvj+8l8843IO8y2kHEXuqTfF5IPf3Bydo8f
         yMv/AriHQhniXcBXAXT7WL/UMThXAEboRePSsKUiJpLQpJfRvQtDI20xOBs/cqWKwd5n
         EtjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781061534; x=1781666334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dfYAPciVtr9jey6/6t11PRjkoNLDGMtubbOtNmZP7ME=;
        b=kgGr7yJrEohZ524DYBOm6/5QgJHwaSkbpUC9Wtrn95ccWlgCp70noiRyRQH8SSxJK/
         leK3GYD3vmqO0d2lT+fq+snekSycVP1ajD2Ljrslekr+3aJT+LzEZRh6jJn7XwnqTCHf
         CSCuxW2SZKYXvW5W/Hr/D7ibqpKaRm+a4tqD/uxHh/Uvb0d9GAu/M1W5EV1w+JcN15xf
         ol/cy0xHwaWRX1ig0/fM1jR+En1VCYLCsZUqC7RsDf6FYPCKwAw/OojY1Bv5s94NZ39g
         qNIlRYecYPyg+wxlG+oUS7uCxM00Uuc5ICBzBRfXZEDXFFnjyHfAeTUVcKqgjEq025ya
         eiTQ==
X-Forwarded-Encrypted: i=1; AFNElJ/SP736heMnmnnNo4akAtOqGadzyw8hMsZOqNrsN8c49QipLa7sbnEA2NQEthpKlz11KjSmavSSyQ==@kvack.org
X-Gm-Message-State: AOJu0YwSAZoFezi1UCu8fnlXb1CPXH+HvI2LD68PPcMynoAS3P74HSTb
	6WbG75RKgAWkY8MRelRLNo3NpkcWhixx3jd2LyCyQQVu2zpHvbTdplPM6go88zlpvPdte9KxSyA
	t//TfidICArA1pxUUQy7ODiqs8qVxUWs=
X-Gm-Gg: Acq92OF6d+TovGW8ngr/Dlbvy4dvSz2i1qEiMBedm9KIrWK8SfWkOlUAMYlkUc+Iakr
	I3Tue3hxgyIy9NiLkZqOZ7qEGxY+juUCfmTFnIEmBbi2hostuijN4hbzjh/QaE6nUzsC4/36/p5
	kR8ExiGMD+gpKO0hpJ10ujwQPGjUWLwTmRvgPnKOB5evFCj/NN2OWdtpo+Oarlm8cTY1Gzs8mDM
	4VE0p+/ynX/k/Xzg3hSXUpG0jfnUmMft56e4VhwBmOcZ9WvqCHGlIRuZhbr1GpZTZFzihxhsoNM
	4uLaO8FS/pca3cDrLb0=
X-Received: by 2002:a05:690c:6f0b:b0:7b3:f33:35e5 with SMTP id
 00721157ae682-7ed0c3320a8mr242844787b3.16.1781061533681; Tue, 09 Jun 2026
 20:18:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260609113520.3507783-1-haowenchao22@gmail.com>
 <20260609113520.3507783-2-haowenchao22@gmail.com> <CAKEwX=NoNXqk6koBYMSjaQaiMfq-dRaBxuFpYdrZyByxs1g0xw@mail.gmail.com>
In-Reply-To: <CAKEwX=NoNXqk6koBYMSjaQaiMfq-dRaBxuFpYdrZyByxs1g0xw@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Wed, 10 Jun 2026 11:18:42 +0800
X-Gm-Features: AVVi8CfXGl12JGLLa0__X02C6d4WEnfT4F8qhR9gLMfqYgvQ-ml1oMVmAFxtFtM
Message-ID: <CAOptpSOHcbOrukxx_u73jhNyHcFNAg+BYKNqWxDcHqTM+k55_g@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] mm/zsmalloc: encode class index in obj value for
 lockless class lookup
To: Nhat Pham <nphamcs@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Barry Song <baohua@kernel.org>, Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B079C14000A
X-Rspam-User: 
X-Stat-Signature: w3gid3i53t38thopdprynhm9x7cw58am
X-Rspamd-Server: rspam08
X-HE-Tag: 1781061534-998272
X-HE-Meta: U2FsdGVkX18jmFvecCeObHVE1+9itCIx9Nmu+lKVNb/h8QmTisoSxduWou/MxUltf4kxDUoKFzf3rdoCTJ6zaF4s/nSr2vv+anGxwcvw7tyFHbe2MYMy+O10n0lUMy7lJSliGE1sG/ICCheHCxhp/KyIQc6VDutIDsJVrsG6tbL8SqNuoIDj+U3USlLa41CDGOT8E9TMDtBDBzobMxjEClOxaVgBNY/IFDZSI8lEn1Af2Y1rlm9ySfIM3AHrpPdJ0n0bC0E+X4WZlkWir2ycZ9OntWfh+lCRDjKWdEPt/zr2uFOr7boFmG8e5TCNI3Ap9cCZF2pDi+RGpz6O9hyDfXcJYPzwBoDOEkpcf4h2cHhmXOpqXjv1Wl5Ngryj9Bfhv9wqqv6MMOXP/d6/FCUjZLUVjzdjpI1kYHGt2fi/Tb7he+R7MU6kjqmGPdWxwbSOqPxSqauMpgQMDw0kQjSZGLpQgIM54jcKgChybEP1a8KjMdyMpNjLSvdmuJjYebPiTNHsVbBuEau47Rj6iyAlN/y5WGdHSBIzAxhDkmN8BIkCm5u2F0rJPR/wjzLsktcrZ/hmon0k+kzPY842NcRmzs6UsqNo9k6ngM7wK+VSJxsKDL7b/t9rhYkkNxq5mBXXBeDo9hd++0gUqfluNj8UeHPDsZCm0vRBpkijqSu8CoPj0bC3UHZ6KVt5btX4nH5znZrt01YyS+/t4KkBiqoq8OIoKmYECItf0zZu+SSaymcQSDIM8bOl/rEmkVOyPRx257kDfbiyheEm+xwiwtTRYIWE9YOhmlYJi6He8l2ROa3y8HIa9t+/ifixnrWNOV0b0UfINrKKLPvDfQKQrW8Us4PCLk/20iHkWxJ67oWIwuCu2w/PaFtx1pvXS4+q5NDzou7zoNuiR4PHG6B5J0zBvCxRjQhkqrTUJf5EFZBQ7tBVBC6H34BdVgn9PtJ0dvrzmoJ1rIbqiug+E527Mi0
 1ah6tpjF
 xU38vIqVaJ0fVyN2W+jEuAS2GZcR5nu7j+m4vErlUiXBcNQcpPdEe0M8LqRR5cw+WsmGNI/6TtAYB4r5Fub/HGHsCklcQqJlKR+AFJtYkzD5EPXODxJUb2JEqa4GJMyhnGvS0mN2T+QDlvDOlvhh93XJnrpzRnogbNSkUEpFEFyBvR1TegV63wYOXedW8Ag353ytA51S1P+jAxzASgP3RdkTY98O5pDf2VUJAn/BFP8yiMZ+VX9JSeIkeyf1mnhQet56YdHb0phji0oSYUevuvekbo+AiCfEzBVoaT70F5pC2qvNLEJPEkQM/tr6tblZvfnyusqyMkeS5EeJCqJflhgaU/OVcTKMjCstRcmK1IYovlb74xCiHcZJxVlE9iofpoXaM/4MLOGp55WFIydXvvQpIrZ6qIDlYIpUqtxpIUzGLL6eCy+VuCgu8jyAljuZcU+knayRwjkkDckR2PeiYUaDt73oBpQkc9gvZENke25GCWZ0VhpRkHKFFWqTtJi9KSko26PcMsPExYTE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 1:56=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Jun 9, 2026 at 4:35=E2=80=AFAM Wenchao Hao <haowenchao22@gmail.co=
m> wrote:
> >
> > From: Wenchao Hao <haowenchao@xiaomi.com>
> >
> > + * ceil(log2(ZS_MAX_PAGES_PER_ZSPAGE)) at preprocessor time, for use
> > + * in #if below.  Kconfig restricts ZSMALLOC_CHAIN_SIZE to [4, 16].
> > + */
> > +#if ZS_MAX_PAGES_PER_ZSPAGE <=3D 4
> > +#define ZS_CHAIN_LOG2          2
> > +#elif ZS_MAX_PAGES_PER_ZSPAGE <=3D 8
> > +#define ZS_CHAIN_LOG2          3
> > +#elif ZS_MAX_PAGES_PER_ZSPAGE <=3D 16
> > +#define ZS_CHAIN_LOG2          4
>
> Do we not have log2 macro to use here?

const_ilog2() in <linux/log2.h> wraps everything in __builtin_constant_p(),
which is not a preprocessor expression and so cannot be used in an
#if condition.  Since we need this value at the preprocessor stage
(to decide ZS_OBJ_CLASS_BITS in the next #if), the manual cascade
seems unavoidable.

>
> > +#else
> > +#error "ZSMALLOC_CHAIN_SIZE out of expected range [4,16]"
> > +#endif
> > +
> > +/* PAGE_SHIFT - 5 =3D log2(PAGE_SIZE / 32); 32 =3D ZS_MIN_ALLOC_SIZE f=
loor. */
> > +#define ZS_MAX_OBJ_PER_PAGE_LOG2       (PAGE_SHIFT - 5)
> > +
> > +/*
> > + * obj_idx width that keeps ZS_MIN_ALLOC_SIZE at its 32-byte floor.
> > + * Below this, ZS_MIN_ALLOC_SIZE is auto-raised by the MAX(32, ...)
> > + * formula -- still correct, but objects are coarser.
> > + */
> > +#define ZS_OBJ_IDX_DENSE_BITS  (ZS_CHAIN_LOG2 + ZS_MAX_OBJ_PER_PAGE_LO=
G2)
>
> ZS_CHAIN_LOG2 is (roughly) number of bits to represent the zpage index
> in the zspage, and ZS_MAX_OBJ_PER_PAGE_LOG2 is roughly the number of
> bits to represent the object index within the zpage, correct?
>

Exactly.  Both are really "how many bits are needed to represent X",
just expressed as log2(X):

  ZS_CHAIN_LOG2
    =3D ceil(log2(ZS_MAX_PAGES_PER_ZSPAGE))
    =3D bits to index a page within a zspage.

  ZS_MAX_OBJ_PER_PAGE_LOG2
    =3D log2(PAGE_SIZE / 32)
    =3D bits to index an object within a single page, at the smallest
      possible object size (32 bytes).

The "_LOG2" suffix names the math but hides the intent.  How about
renaming them as:

  ZS_CHAIN_LOG2            -> ZS_MAX_BITS_PAGES_PER_ZSPAGE
  ZS_MAX_OBJ_PER_PAGE_LOG2 -> ZS_MAX_BITS_OBJS_PER_PAGE
  ZS_OBJ_IDX_DENSE_BITS    -> ZS_MAX_BITS_OBJS_PER_ZSPAGE

Then the third one reads as the sum of the first two: "bits to index
any object in the densest zspage", and the ZS_OBJ_CLASS_BITS predicate
gets easier to follow.

Does that work for you?

Wenchao

