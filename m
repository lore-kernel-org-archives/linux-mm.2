Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 634FCCD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:18:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787B56B0005; Mon,  8 Jun 2026 20:18:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738F16B0088; Mon,  8 Jun 2026 20:18:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626E76B008A; Mon,  8 Jun 2026 20:18:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52CC26B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:18:47 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7DDC1C2137
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:18:46 +0000 (UTC)
X-FDA: 84858463452.18.07529EC
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id DDD8C4000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:18:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dZtHxtra;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780964325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pHNfRp0QH0ivmNsCb3p1tkED6tQ7dzWkpJwWEGenuCw=;
	b=ayd7j72LzVdCE6gb81ZE93NbBEEYm7chQGPVSp9eqYFSg6kku7t61dEkCkcFsOg+7TuuEL
	Ph2djPQPuG1NEnYK3t1BTFxZ+ptBdiR0DFdr18OtMk0XaUdH+4HPEBwF8NisWp9nnJR4Tv
	SicYo7FveUvDoiGb5kZmqeB+9vGi7mY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dZtHxtra;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780964325;
	b=m39dGMaf2UkboD78qEeCBfBGXxcrdgZ2RmqzJn6305l26L1xx2rcX/OT9DRJtvWRByFPES
	AYnqxMbGLN0NMsHdjlb4YFZvcNYLEdJaBDVqfWBpxUAbCcVr7XR2rW7ddP89K1VRYi3oAA
	lmOOrPVTaBZcNVQCqSjhcowMBN3Uf4s=
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39677245e15so46810901fa.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:18:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780964323; cv=none;
        d=google.com; s=arc-20240605;
        b=AhuBO7zVlljGKGb7JIyxgl6VcQSSJAmi+b+6nlwoYUv0RKx4ohJqykmsJjbDaNEX6f
         rF7ZB4se8OQMF1bn1PnBlbPPJ0znfrsbW2m1zqIGbVCUkKrjvcdE9qSa44Hk3kZ8Ia4G
         z6gq+QYQcRMTpzlLJVBGgGpXXSXU2J8bsmsUeY9A01eYK1takArsAgmLAr7+j2WHSKUm
         vh97WfH8HSEM2RZOLfG1XP1KjDayUOBUUeywaCD6xb/ljmphBIcEcf5j2Um2sqU3Rn8Q
         97v/9oWRP5mkBzstqc9HOZ+/uKrBq+owJ2oB5re+nFe/2d/hhJnR0fvyMO8Kn2HrztIi
         W4kQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pHNfRp0QH0ivmNsCb3p1tkED6tQ7dzWkpJwWEGenuCw=;
        fh=KcyXcfAFA9dc18eBLB2Ks1hHUr2j15u79P4e03dHhTY=;
        b=WGtH6XuiKsTTpUXcHilFqz3fg97LKaRa9JjUPKtbI+R2NA9za06TuFBwWt57BcefHQ
         yIxdBnDi8YUgpMD7/4AZWD/9D18dIxFwfgLDApW1cfFfdrustS9NQaT6YRKkZd22c471
         gFeO0ey1CWRA0bQ6pceNfWyViNDaTGdwVPoWXlFw7G+qV+Ym5BigxhLs646ti8aOtcMo
         olIjWdI3Sw/ryuyXhY6chAfkSoo5ZySQPsajE00NWSnWykfmXwhZaooKRBaR1psjNqaD
         04EDXPfCo89G1VaiGw/j6+6tSXduHYu2XwIx0k4K1yzeGqT0ChYdIE6fmFrsxjSr/bIt
         H8zg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780964323; x=1781569123; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHNfRp0QH0ivmNsCb3p1tkED6tQ7dzWkpJwWEGenuCw=;
        b=dZtHxtraeH+Xpa1T3tljNpSUfKb3vwbIgbgAYjBU0/6wMQfWrwlPSU9Hv4x7U2Vj+1
         OKHS7xv7pVyT+a8pVA4SNOGlp6mFg/Mo+ZJ1oSJfIA4ieIPyCmW+4FPYdnO7JdG9Bymd
         2pgQOb7I+m8PnjJ0EjUUKCfIjoSZ2b7mun7fHwBDrgeHy/caLXSrXtj9XT3hPpFuAtvy
         LQnby+N/mg8nZjwK3TNpvIBzVTJcWZ6TfwwRhQ+OxZ7metfltfPIq3Sf7+zQtt+250wK
         4lJuL0m9cOv7dOtv81ALMYOCnT6pToKL8YumTtW873/NRmzndJq/sKdeT7mdYGdLPGwh
         sP4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964323; x=1781569123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pHNfRp0QH0ivmNsCb3p1tkED6tQ7dzWkpJwWEGenuCw=;
        b=R57SB7gHCZgn+TRnP9jCYYjSZDzlXTxQ+IIixXvOUaDlFYu4jcBWOvP6y+Mwy6ERjT
         orstNIzFvvUAHELnvfshsS7lPYiHSo0Rtaae4mmUlYLXhPwJpAzE8BbCU1LUbASYOCXj
         vEfhALFPmaRxvmuWYQBFS+2RMWL1BybwoeTxPiPfdL6z+4XNoh7qKrXlud4m8gD9ubBi
         TqcWWHfGAyJUfWR37c9yXfUHzKhJwzgp6IcK+YzCdUfX1Zk0g9t8HF+z6R7oMRJmWb07
         vHGvcoGuqinyFQYFOAwrnxLKeXcBXkyXtV6YnJd1hdOJULgIgE7bSM6jNxmLOdgBDeVs
         ARDw==
X-Forwarded-Encrypted: i=1; AFNElJ9/rcMMDWRYEe2thx0e1K5jgWyqoCy6X9S5KzVED3XQbD46hWSY6FDpbpLC2PP3BVzAYRHEsmRHdA==@kvack.org
X-Gm-Message-State: AOJu0YzRBjywpzUyDncF9Xi5KyNttVCv2JNu3aQ+pKM1lN5DOgRMoTRK
	NP0+ZoYADtgc5z138ZOn3ToPBctIWz0OAilYArl/XX10roDmPHrAK0EU4dXnfRIeL+Weutt5yPg
	K+t5csSqiuwbF3KyVohkzOVIheHOycfs=
X-Gm-Gg: Acq92OFIu6P9ZzzD5u1bYnqwMdVUo4ntUsysDRZo5G/ekVC3U94qWMzSacZqAKXq4md
	lG2eaiI86ZK9e5CZE36X5oJzuYNTkkMUgcw7Ze57dlVAs+Pab7jnKNd5WR0sfgyrgF38HC+Tkt5
	nQdJ8AOWv4VTNLCYh2EFo14In4BqmkU8sYI5+I88PXFHYTNaqyO4mmSZnB2G2tW5ceD9LVsT4NP
	sLj3sG0xEoY6vgBgmmCk2XXK6EFkRET+YD8zeJgd87382fPD5GR3hkBNKolqUnwNvfn2MaeYfAD
	koMPbi4HS8mZrHTS2g==
X-Received: by 2002:a2e:be2b:0:b0:396:8d0f:249b with SMTP id
 38308e7fff4ca-396d08d066cmr52060061fa.12.1780964322709; Mon, 08 Jun 2026
 17:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org> <20260608210618.3437216-2-willy@infradead.org>
In-Reply-To: <20260608210618.3437216-2-willy@infradead.org>
From: Hyunchul Lee <hyc.lee@gmail.com>
Date: Tue, 9 Jun 2026 09:18:31 +0900
X-Gm-Features: AVVi8CdkX_aLXqBlaPzMju4XHc5nOcO271OPhrU-2TGGmnU5WyxBdf1WFLomVi4
Message-ID: <CANFS6bb=5JJ0-bBusAugG_EaLW4ws8Z9zvJJJjv2eyWXqRpJpg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] ntfs: Inline zero_partial_compressed_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DDD8C4000B
X-Stat-Signature: 3c6ftrhwakqb7zn7tiun4yj7o7asupj4
X-Rspam-User: 
X-HE-Tag: 1780964324-950955
X-HE-Meta: U2FsdGVkX1/iuSzvwwpXKKV12ruwOh7r2rXcaF3XQ33LjD5Cg1Tix1SOp+sS6mrNy1zN4jpug+oWIF7Go3M1WzOViLiR6LQSQbj75+wvXCQdnCodUrpcGTSW4VI/bBVDNnaTPDAXJpnUBU1bP77v4CPkOqkibhKLTZFU9EQAWcfPlygFgPWO9c/LqSVC0OZLtkbWHuNTg5HFwc7V/ITdrSlCeud3HXBqgC3rGdISHFpmV46/KDsaBzpi0Cw6KnqGAk6QKSPUVPN3VZw+WiRSFYcWu4q8yghO7NQBMTqT/0jRmBbuoZL/YDm5tO99aIBir4OdsS+hdLxY3sKfq71ajvbWGk1CucK2WhCiOp0idRfjITWxN/RdddIde+z0CuvNconDBLb+Qi6vtvHMlX7pj1mxbZuKZl8lHsswOqaXmHCC30KTI+jBpp0IjjGkqJOOQ+6lKJrMDzQXL8r0Z66gtIIpu5irBKV2sZYqS4pGJ4UJw/nJdnnIVGpeCZd1qhfUub4Y5jvJdVMZa7cL2GhIcQRVwkOmhbMRmu8u5kr+ivgMgUK0Mi6lDet8h+9vXcBeggplJEYfdOUplvmjsWi573hNUdz6by5P63Ljg08IClgD+g2T81PRh4AU7yY2hHN15HjAnL3vMxqbypRlyNcJ2TftkmSKi+/Wk31JSSDzWTA4IvK/sYIB+y3RM8l5UrHBt6PWA43RQsE4zXDKWqnYhez7pKBzByeOL6c6zDqILgVozLk0BOOUz5BBlIsgjd9fTOzOrhXAQcZjWeYeR53QhAxtrY0P9CffzzOuGE2HNVFzAhdbdIGsVUcMREOIw5tBWTNrBl0cUx/uhGIqfC4r3LPIUo74YjuKhxvYGfQjTqu6VxRkoOB9vnJByq57Qjk7isjaVPnwevY0Q5QHDny8d6okY2YTOe8dVSxknGSzlD95/78SwnXRjp6Au7jMV7wTDq07RLon7JMswQjXED+
 vDtZJOcE
 OcA1unW5zy6yDD6vv3cx4LT3JAczbp/76nfFs+firYw1G1Z45zfwBlenXeden327XDihkJryUUPZD5wGKF8d22G5hguUSK730FHQRemSVHd92MMDEoskvbpDuZOPWUtqHADu/ebD3YxUuGpnTDXAoTPeOfSOEwe1yd285UyEUfEMjBL/Sm3pB/JvYnucXZ1fP/4HPq8I/eo5pCmgik9K/TuvoPv6C8pESDlSa1QmKzmOM6R+S/m4dsPou7+f6pe6EeJto77B8nE9aJ0IeGMG7UHKSV0ad8bzTuqa0HnHr4JS4su2mQACZfDrflfPXQ4FT1qnd3AmW5vG3uc41Hyvv8RCmFSx8CPGl11yS0RXrgJWNNLYbrJ7pf0xJlt6wQNPQjuPp9HVLJelEhfAzl0I5cRQOkNFmnW3XZJXTiUWbwVWtil3flFjkc60VTtYOE557oeuBqdGbvaZIu+qcVzsRNPnpMBN+6UHPZ+9IFK4f+swfnponQ6uU42vVSaZE602KU5R/+b/AfVeVG3xdDRNB15cq5xJbK/gaL21zFntgb6Ml472XfVcFQSXUgbvjj18KHr37KJT04wzuU2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=EB=85=84 6=EC=9B=94 9=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 6:07, Ma=
tthew Wilcox (Oracle) <willy@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> zero_partial_compressed_page() has one caller and the next commit
> will make changes to it that make it inelegant to split across two
> functions.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Acked-by: Namjae Jeon <linkinjeon@kernel.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ntfs/compress.c | 34 ++++++++++++----------------------
>  1 file changed, 12 insertions(+), 22 deletions(-)
>
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index 76bd806b41ed..c904858dff3d 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -96,26 +96,6 @@ void free_compression_buffers(void)
>         mutex_unlock(&ntfs_cb_lock);
>  }
>
> -/*
> - * zero_partial_compressed_page - zero out of bounds compressed page reg=
ion
> - * @page: page to zero
> - * @initialized_size: initialized size of the attribute
> - */
> -static void zero_partial_compressed_page(struct page *page,
> -               const s64 initialized_size)
> -{
> -       u8 *kp =3D page_address(page);
> -       unsigned int kp_ofs;
> -
> -       ntfs_debug("Zeroing page region outside initialized size.");
> -       if (((s64)page->__folio_index << PAGE_SHIFT) >=3D initialized_siz=
e) {
> -               clear_page(kp);
> -               return;
> -       }
> -       kp_ofs =3D initialized_size & ~PAGE_MASK;
> -       memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
> -}
> -
>  /*
>   * handle_bounds_compressed_page - test for&handle out of bounds compres=
sed page
>   * @page: page to check and handle
> @@ -126,8 +106,18 @@ static inline void handle_bounds_compressed_page(str=
uct page *page,
>                 const loff_t i_size, const s64 initialized_size)
>  {
>         if ((page->__folio_index >=3D (initialized_size >> PAGE_SHIFT)) &=
&
> -                       (initialized_size < i_size))
> -               zero_partial_compressed_page(page, initialized_size);
> +                       (initialized_size < i_size)) {
> +               u8 *kp =3D page_address(page);
> +               unsigned int kp_ofs;
> +
> +               ntfs_debug("Zeroing page region outside initialized size.=
");
> +               if (((s64)page->__folio_index << PAGE_SHIFT) >=3D initial=
ized_size) {
> +                       clear_page(kp);
> +                       return;
> +               }
> +               kp_ofs =3D initialized_size & ~PAGE_MASK;
> +               memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
> +       }
>  }
>
>  /*
> --
> 2.47.3
>
>


--=20
Thanks,
Hyunchul

