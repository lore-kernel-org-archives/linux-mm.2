Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C785CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 23:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1698E0006; Tue, 11 Nov 2025 18:08:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA9158E0002; Tue, 11 Nov 2025 18:08:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7BE8E0006; Tue, 11 Nov 2025 18:08:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CDE858E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:08:58 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9798139FC2
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:08:56 +0000 (UTC)
X-FDA: 84099868272.20.28DE5C1
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf16.hostedemail.com (Postfix) with ESMTP id 193EC180016
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:08:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CyxMNPcA;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762902535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fz6bHuZsEjx2kw3X2XBGwkXSho2Ygh0BSCqvUOG5fck=;
	b=2JKm9PTB4UPg9vzUwLycpjApYbPskuauC67oH5BJYM4IZIT2avErAyojP2e3qMTCcrJ2sb
	l56LPMWMF6905jWmN3SZ8MJC/pfMDdfvYmSbgwJV04N+kl0PN/Gtj2obXDN7Ae85OqZg5h
	lvhffCqT1qBxPPF/pEohMDwB6SfXb9c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762902535; a=rsa-sha256;
	cv=none;
	b=YFr2pUIjNqG91yTruTjBJ/0FIP98b1BsbxMFPYPExaOZnNPg0HfxGWW7jLrAyam27U3aI8
	27lVF1cosH+NBvf+rJbz1+g01Z4qsRF5mhiAzZDbx6c++WuB4vIvlvqm+tRYi3ohv07Wcc
	uE9OtVCqbAUTCfu26eXMYdnd4uo09eI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CyxMNPcA;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-42b3b0d76fcso107439f8f.3
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 15:08:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762902533; x=1763507333; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fz6bHuZsEjx2kw3X2XBGwkXSho2Ygh0BSCqvUOG5fck=;
        b=CyxMNPcA8ZEOX0W9HLuVvU7E5qL7hdhG5p+/lLSOZHOhRDsSexX/8+hP7zMRn40mil
         Xb392k0vjRFQb2SDG+XnyJhb0hetRBk2bXhwAijWWuBn3XmeE1XtiV56oRX2B6gHkkbB
         0jCEbqE1hSFd3CiiH0sDmQ4n5xKP8TV50TafQOxasrDRgCbzBnB9PO9IyBkB1Tn5VSTz
         QKyY/CKVweczIPeD6VL+MkyI8+sXGRHCIykXx8nsz9HOle1+rib9Bnhnm8ejhKqTGHlq
         W0Spmog3VI0vULqFcgqQxhyPrOzY8WaChQX5HDFQ4D9nb+dVS3pNuYcj1ed00nED5NvQ
         +EKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762902533; x=1763507333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fz6bHuZsEjx2kw3X2XBGwkXSho2Ygh0BSCqvUOG5fck=;
        b=l0liYNma499fBmr2S/1jviglBs76jHnr/OebZZ2zGUJgq9m6uW1zaxRt2+EUw4cXdA
         zhGondPIdsV8piKWLT51c4dhnbK4ianp3A9keNSL+4bZfI54AXZ+XINQFxcfVy2PRMnT
         VaoBHUBelQnnETQ4knOH4AMTpgsPQ5eWapB13bS9aTdufh7aGm4Hx9hdKcBaHWZYvNAr
         m8Tix2HfwztYMve9itWXfLDPb0/DxKE6saM9mzKRe0zVRH/QedCIL6IiWqm8q7R0w4g0
         IAJXlhM3tyP8aQJ+YXwsl0SmEJMS7h9njEjhdKB8xDWj8/aag5eeMKS5gMO3GwOw0vg8
         1ltA==
X-Gm-Message-State: AOJu0YyPxri3lLesGZ5Xku67YdRgVNFdA9dnPeov477MTfCmLtQa2ZFG
	MTyix1757f+ozFH42mOlGCkhamasDfYqDeVe35GNoHZi2bQDbAW6nNZ9OMvQJEbamFidnihyhpi
	uqB7YT61Hdpsn9Fj63IlMjrUfw2ZlVGo=
X-Gm-Gg: ASbGncvJ4jhWWZNxm1ErwI6Wd+CydMG9ZMnODIe1vU87g+TjXwIekL3lXAM2hlW/d8J
	SGvCQqG2/DEW/4kNyOva4Nzf7K6DC1YNUmimrnBTfqHDL8Uq/GLFctLVhRhsoO0/Dh/2mXnyxNL
	rr6C7r2j3ZZNKvjg1JvIhJDADpdBSyrHiwothyEYmhZ7GfU4N2vAqdTm0di/UqiiQ+Z48cX7nQr
	lubxllQg9jEAbCldD6K5fz4ORiFpXid0iWT8L0P+adTRkmDSU6RtX1gjtcGkd0sfz0Epw==
X-Google-Smtp-Source: AGHT+IHUtdHMv/cqBlF2IZX4Ed0+tDle0TRpoL7aKBRklYRm3SP4w4aEL9nl6pCo50SjADZ45Zk0Nfh2MxZS/Rv9fDI=
X-Received: by 2002:a05:6000:26ce:b0:429:8bfe:d842 with SMTP id
 ffacd0b85a97d-42b4bb8770cmr551863f8f.4.1762902533255; Tue, 11 Nov 2025
 15:08:53 -0800 (PST)
MIME-Version: 1.0
References: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com> <CAKEwX=OuhWBZWAKs0JYG6mLqe=NvyiD9L0dOEb=5ZJB-jfFi1Q@mail.gmail.com>
In-Reply-To: <CAKEwX=OuhWBZWAKs0JYG6mLqe=NvyiD9L0dOEb=5ZJB-jfFi1Q@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 11 Nov 2025 15:08:41 -0800
X-Gm-Features: AWmQ_bmzxwMvKHMB2MWGIM6T7AKaSNIwuKC2a3-Jg9SENE9orxavP6xnPq9AT8M
Message-ID: <CAKEwX=NKyXf=EEwszOm4BGm3WwHRu=38ThE7Wn=jsDUJGe=bKg@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: fix potential UAF issue for VMA readahead
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Huang Ying <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: zdptdcokz7z7r3gq8ts6ucc6tk13tr3y
X-Rspam-User: 
X-Rspamd-Queue-Id: 193EC180016
X-Rspamd-Server: rspam01
X-HE-Tag: 1762902534-257220
X-HE-Meta: U2FsdGVkX19Xy3/A170PTJiO92FPq1OGpp8xP2lc4ot97lIi2ZPY5QQee9dppP2sviq/8/ywEjjzJBb29OzIDSth8WprkFy43Uq/n/4PZDmpSuHvkBAPm5EaBI03ucf14frwAXjLIVeSqtgM6BAK5k6SsVVAS2gnNTngFysB3GpVNAzgwPcv+7Lx5Nj230Xz62pmfhK2FAkl+k0ntcx4FW5MVPZ0v30yJbjpgdnEYWaU4uQ1QIpxDD16k02glpIwKAiKBWVErEeikxumfsBEpZzS7vG8mwCrltytLwNAzvvAUuWauAqPZLp0UC8144CYaL/KRgjw9mQH6ldSYXAceqt4RFvcagHRwrlYKlsScHyRMKjb4O0p6OigutoLU/nGQSkhR00Oin/0gV5442rP6E1JpUwZBhihdOG3QH6+vgc0nWsgcnVXFiuxzVr4GB8JS6LxgjIxe5DLgWZXJB6xU2HzIAHXSWh/aLNDGiaWgpv0voL//LM444Xok3EXQIss47UXV934j/PF6mSz0Tlu18gmiovgFp4GgY0IN6CMDJ2zDQPuNpmbpWduW1meBzGRfuzjDtxvtTgoNJJAtt2e/uWoXlZ19tVQJfqm+ihKm+iMhB1fSehnsffqEd4i/i8zSzctijuJyaTeMlwZmGowVcGMD3g5zw0Q0jCnWb8Be2fKaE2AlDPlWMz+7LhROsXfPgtihtkG6EroBAd7SqWlNaI8a2HYR5kuttwes59VU361yV2vAbOtXCupYy7PA+jwK6wSEAZOXBMb1rR4I+4S8NhM8Zs5OM2I0pPMJo1q5JI2gcdFkzqOkxmjwLwoh1JL0IQH+cjNISVfhc0jCoNENib59wGttY8bA3IGIbsfsvqkYUIaHKIaTgE8Ifb5WPQ/qGaMLf1W4v4yKoLN/l6bOPI9HBJYsIBtgykaoIqIAuWJNCR45fvoB7u9IB/hhZzJWbhNHsA/kLh2tDsaAvp
 76600IvO
 eUQgEuli6MBitMKN1/fZGcZYdM9xfPDuDai/4gqqMKTKDqXH6saWaYKbsMKX1+LnK7zmWQVdzKX4kRlZuhW4TbV0a3lPg8BGbNSLMaXnPZQH22Gdh7AB3G3URDlRX+/wA2g+3mEQ7m+7ftMDHO2WMFIVufLmCXMiC06XzHVk1+cUpN2uqOusRU9CoQUBcLzTrWtl39+m+tW/yMTAUAIHpjRmTClsvgzNLVVQMzlh5TnokcdAUtmToo85yzQ+fqbj2xxfjH0aTIj9YHu497sijZqOnzvKvoxAqyFO1Ao60Irgp8lnvYax4BwOF+b5GJ/6JYrtKxu/LObCa6fKc0B1BR3kMhUEw8+/WLp/kM/CddKgXRBC12tpUFH/UBt/MhSIeX8sxoqlD26632bgOQ8fizizt7Xl32+UKF+xgl2PY1ctGQBrQsMt+J2lHAjOxhB9YjF1I
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 11, 2025 at 11:48=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Nov 11, 2025 at 5:36=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
> > pinning"), the common helper for allocating and preparing a folio in th=
e
> > swap cache layer no longer tries to get a swap device reference
> > internally, because all callers of __read_swap_cache_async are already
> > holding a swap entry reference. The repeated swap device pinning isn't
> > needed on the same swap device.
> >
> > Caller of VMA readahead is also holding a reference to the target
> > entry's swap device, but VMA readahead walks the page table, so it migh=
t
> > encounter swap entries from other devices, and call
> > __read_swap_cache_async on another device without holding a reference t=
o
> > it.
> >
> > So it is possible to cause a UAF when swapoff of device A raced with
> > swapin on device B, and VMA readahead tries to read swap entries from
> > device A. It's not easy to trigger, but in theory, it could cause real
> > issues.
> >
> > Make VMA readahead try to get the device reference first if the swap
> > device is a different one from the target entry.
> >
> > Cc: stable@vger.kernel.org
> > Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
> > Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> > Sending as a new patch instead of V2 because the approach is very
> > different.
> >
> > Previous patch:
> > https://lore.kernel.org/linux-mm/20251110-revert-78524b05f1a3-v1-1-8831=
3f2b9b20@tencent.com/
> > ---
> >  mm/swap_state.c | 12 ++++++++++++
> >  1 file changed, 12 insertions(+)
> >
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 0cf9853a9232..da0481e163a4 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -745,6 +745,7 @@ static struct folio *swap_vma_readahead(swp_entry_t=
 targ_entry, gfp_t gfp_mask,
> >
> >         blk_start_plug(&plug);
> >         for (addr =3D start; addr < end; ilx++, addr +=3D PAGE_SIZE) {
> > +               struct swap_info_struct *si =3D NULL;
> >                 softleaf_t entry;
> >
> >                 if (!pte++) {
> > @@ -759,8 +760,19 @@ static struct folio *swap_vma_readahead(swp_entry_=
t targ_entry, gfp_t gfp_mask,
> >                         continue;
> >                 pte_unmap(pte);
> >                 pte =3D NULL;
> > +               /*
> > +                * Readahead entry may come from a device that we are n=
ot
> > +                * holding a reference to, try to grab a reference, or =
skip.
> > +                */
> > +               if (swp_type(entry) !=3D swp_type(targ_entry)) {
> > +                       si =3D get_swap_device(entry);
> > +                       if (!si)
> > +                               continue;
> > +               }
> >                 folio =3D __read_swap_cache_async(entry, gfp_mask, mpol=
, ilx,
> >                                                 &page_allocated, false)=
;
> > +               if (si)
> > +                       put_swap_device(si);
>
> Shouldn't we reset si to NULL here?
>
> Otherwise, suppose we're swapping in a readahead window. One of the
> swap entries in the window is on a different swapfile from the target
> entry. We look up and get a reference to that different swapfile,
> setting it to si.
>
> We do the swapping in work, then we release the recently acquired referen=
ce.
>
> In the next iteration in the for loop, we will still see si !=3D NULL,
> and we put_swap_device() it again, i.e double releasing reference to
> that swap device.
>
> Or am I missing something?

Nvm - Andrew pointed out to me that si was NULLED at the beginning of
the loop. Looks like I was blind :)

Anyway:
Acked-by: Nhat Pham <nphamcs@gmail.com>

