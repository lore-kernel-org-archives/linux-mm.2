Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D22CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:21:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB466B0005; Mon,  8 Jun 2026 20:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6C226B0088; Mon,  8 Jun 2026 20:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9AA6B008A; Mon,  8 Jun 2026 20:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AFFB36B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:21:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8375C1A0246
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:21:13 +0000 (UTC)
X-FDA: 84858469626.01.5FE337F
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 72A4E40002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:21:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="K+9Wf/hC";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780964471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMxKF71adannrd63C7MsvxGSgfSWBTtH/nWzNGXKxjQ=;
	b=nZulqLMbE4H3b1ZI29zZiRSuQPjBN7MC5uM9lfZIrfhhQsS60OIBglKxfY+4U6RNyoxBX1
	mAx8j5fsdNYTaBUrsBzVP/Rfucxxfcbnt58HOfK7hsNAbuvenfeSr0CWKLNWO9V1bAuFpj
	hCHG4rBINZQbDTpIiVnxCwnAxHaKJos=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="K+9Wf/hC";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780964471;
	b=g/pkAv6r+/TICYG1RLc3FLcYu6zMIkphxTXQaHcJEQF012zVxTVi0z1NxN5fsxfVxfLjdG
	EBTUYhTflEMTbdAvcUZbq+KCT3275ZaIUV/AWAHWezJrdvogxgyarBdGziLBm/3oiTLD5O
	8MGayUmD1dTxcuin1HXF0UzJ6PcOdik=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aa5be9ab1aso4594891e87.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:21:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780964470; cv=none;
        d=google.com; s=arc-20240605;
        b=O1PPffqQkxJ4MMGrJVUFRK45C+Y666Jh3Cyv71F9hIOSoNfNQGdbSc0FS7LU/HTHUx
         l8W4wD/ArSsUkFhgBN3Fm3hcrpncBoZAkX5nMnIsQpLDEbAQPX647GEJBWdURCCunvfm
         SMY+5L8yRK1tiqQBGvmQrF9SNGh3Evs6sXWqpo6T677NEn7H+ms9uEoFUWgfvM/ytgfh
         j8Au40pJ4brIKiYCBj2krLQ00zZ19drj+Ny5g3U/jxbAdnbn/p/KzGw/jIoeXuNnr9zA
         dP1JwS/dVGa+UiAU/wUGTqY0FAIti6lHEw+/WexOjBCuX6m3cX5mYbXVhNYe7eRZN2Fo
         7xhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nMxKF71adannrd63C7MsvxGSgfSWBTtH/nWzNGXKxjQ=;
        fh=BBvyAtA9iICHZVGRvRaeGTciah2mnf18wnDZ0kQOi5o=;
        b=iVVN5ZiwUxQeBD48claOgOlpT70Cet68DSdFGZsY6prw9WUd66w/87ZNGaf5TLEJfi
         rB3akfIx35Ke0XNbZue3RYU+VolEIjHTuzCF2M4fqi5ySCDur6odVwgb8zjf+yTwnH3z
         yRavPMnqTO6skfnBRDdmCGDNhCW7x/+BwrloGIL66bhui/ClvBxje+adPSg40qCBXgi/
         mJT/Jc0tIC7sm/9+Wc5/F3kf1XJ1dTcOKvYAVlFwYtvzCLLD9rxZreoNcFA5yKERTka8
         HpUcT1H+KJ+RyX3Z7TGjio82k5BSYtSQlBTq03pcMgg2prUfWYKp8K9XHiaTTutsfDiD
         dWeA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780964470; x=1781569270; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nMxKF71adannrd63C7MsvxGSgfSWBTtH/nWzNGXKxjQ=;
        b=K+9Wf/hCbuF+hpvT6DsFf5ayozaKgqMFgVUg1Ed/s9qD3jj2f0pfzB5MG3kUwC1VAh
         VGQN+iuKw/JYKP/MMOurmvx/utP4SxUPDy6YSxwlknDLmn66UzP7a+TlURPEdgJUpV9G
         CE/D8MCg+/I1tkdwi6fy+wvA3Q5+ZmyjHeQ0hEBoqPWFqYQl1zMCqjkNtJlx6LZwHdvv
         b3J0+xVqk4ozrmqxzUNxwNbRM7c/YV7yGQHF+5s3R4hh1cfZEVaG+ZE8ARGfVi5BIJMg
         ExRI0AP5J+OfD97wZyh6kFXfMSlfH6JEVAbkHzEpZGLYv3OeV41LP33I2Ae6KiAl/suo
         82Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780964470; x=1781569270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nMxKF71adannrd63C7MsvxGSgfSWBTtH/nWzNGXKxjQ=;
        b=Mhy0tTg0J2DBB3YMJ+3QsBPCelMTUkajmMEfiHxsZhc4uGsUo/t3RGHVMQwWSBqIzK
         GJokCxLGa+q6nByab570DhYdaqf3XrdGARpDI2N0EytugQskX65l34YcZBQLwNAIo4B2
         N4qO146H0hp9YwdQiEWBUuEqldf3ArHHVbeb26KEISGppcwZZUg5/4uGMaqHGgCysIdu
         y2mefRIvBuJ4VjmACvMkudEsunVtkUrvlpn0nrtO5ykQX8Lkwq2hJV6pHeYBG8OzKKA5
         Jo7sRn2aQoxzdt/uKSFNoFYQqdHv3eccUSyKgoMma7vYocTC44TmdTrzWukKFOhOlkzq
         Egmg==
X-Forwarded-Encrypted: i=1; AFNElJ/MrBQFWYqgqQE7NAqug3NJ15Fd5LOcUNsti/RaVikIdzVtkCN+PsT4hLPTQzaFLHuv8AvIRdOj9g==@kvack.org
X-Gm-Message-State: AOJu0YzOmqs5gMjTNV8ItHrhl4tBmCUp1Ope8Chwo59oSPfWObo3gKXR
	EIRe9ocufCYdRmVNUXqen3Q7cpyinyWP+ZyPZqVgwYxE38kc3kdFQWHfr+dLQgaRgRWSAUvqMe6
	tp2VB5O/kPJ572+IRkTnPAlAf9ktZOpE=
X-Gm-Gg: Acq92OFEWpWMMI37nP1zAUBOgq+cEhifzKuwt+DF4Fkz6HZ+EqiUVM4uupZztSSXgLu
	pmBEurheIhIcR2PR0H9B8PRqbtqYlMG7EeTRhINPrMyFvcAEvncDxxqkqvIKHlP11JEBXQOF8S2
	bz6hep5Z3NkYzAuvpRTStrdRbV9+B3DYUVlJKOlmZcgXCG1eXCmrjLqejUDYCqFj1WqrLgUszl8
	jIDLUPubz2hJsMWgD2bwQK/23mY+HuGIjjxaIhhY1AhbX9HBEYYcZtQ0wrEoiugeDFer6HYEnf8
	zK0Ax5QJPpaRcQ/omg==
X-Received: by 2002:a05:6512:1596:b0:5aa:8824:156a with SMTP id
 2adb3069b0e04-5aa88241616mr4463116e87.46.1780964469559; Mon, 08 Jun 2026
 17:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org> <20260608210618.3437216-4-willy@infradead.org>
In-Reply-To: <20260608210618.3437216-4-willy@infradead.org>
From: Hyunchul Lee <hyc.lee@gmail.com>
Date: Tue, 9 Jun 2026 09:20:58 +0900
X-Gm-Features: AVVi8CcEVGKC8OwDulcWh78ICZQdlZ03a8-9zWvTs7VbPspvNDE-uJyVOZ8fkyo
Message-ID: <CANFS6bbCV7L2spgNPNQTn+uMNaT1259yhbVvH75+5bzt77LKxg@mail.gmail.com>
Subject: Re: [PATCH v2 3/6] ntfs: Use zero_user_segment() in handle_bounds_compressed_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: znk4hud49wobb3eszzyq9z41npizig9t
X-Rspamd-Queue-Id: 72A4E40002
X-HE-Tag: 1780964471-265128
X-HE-Meta: U2FsdGVkX1/JUENMulBLVwMtHGiY22uWXd1jYG3mcyNmbS/YsFBaDy3svWeAF4+AF1hkXGHX0wn9g1UrRraqMGR0J4jAZ0DIxkq1iaA+TU1XXpY/e6s1CFNRcFKiwmrPQ2hqyAcL8v1I/LtRGU3KQNsV12SiDTSTEKtL0yQ4+q+rBTT9rlH6U4HQuFfOgyQnodpWmg43wBNi7JomiJjEIRrinQi0Wq5jzeZWZo9UO6c58Q6VmWWKviOfVUSE2pW81TMieFWICMKeDpJm3bWPXxWNRLdUmIqXW7P/xylFY/dzXc/DjoU6FbXvQXJVuvN5vkJqsNyLrTSwccaB9EtsjHU2Uu3iD5yYn8fg87tUA2/qHwCisKbDLvwTrB9V6x3s23kWfD6Ji70RXyw7wVCKoxPvqt5U6l2IriLixtVXIhg300UFSXpzbBJj2J0xHmHnH/aivx9TaO183Ork30Ui1MTcxuvvzdqY5lo8VZtZifMrvZC5NQXlfrmnvt1nzNZMRCQ0rXYEmFQ2HCim+i+dbrlkiVWlkY+1px2UaU55utPpR/ZOVJBfC2dulA1KsRMVrACL3BEYI1AaUC9VLRsLvTTIuOGX+egQwxwuPomDW/N96aCsp0Vmbn2yk3kY3/tAw5NydxoOVwSGxpC9mxogijqiXEk53CZ9LuGtrHK8oI3RUSbNqNNcntSuVlJcYXmCYmvxqYz8hixY23gRV0JxxNC5NGgq4lGsvHzXG9/YJLxvILIYnREkXcC/3wU0iuARVtQTtPiGvToyicuPXDRuVDZZmo9VYJvRZS/zZS3pFw3QVSzTPV4sZL/JAdj2SGm8izHtSbx8A3B1OJvu7Cb2TPzV9UGC5LzuY0Ff7pR8wut4jTDilcGdrmRgW3zc+ZTVUbF3cTK6Gem+HQNG2HmqeK8XGUJA8XoDIXIoGc9qLAtM+QIBATjcLmmXvhVXZgg82kbwJ5nEKe/rEYljoc2
 34nUDHWj
 IrfGNGGbl8lR5ogyXYZ12tNEtJ4wkzlgj7Iw/NXK+AWjUHps8g5vgnw+EVsqiQSXGrOlP+Wj0Y3QfjQyVVgVtWCjBjg5wlA7dOaXMLUJUz+cAl3F30qbgQdO7drv0pQPxQ+wONP2dchRX7aQQ1ZLqbGkPxz3ojRQEXTDP9XGpj2O5jzMh2NI2ASPGRON29YXoHJtLmIKUzxmSNOQkh7Ey+9t6brWWSp/RmqL2Ns4QzWLgzfRHOff1Sp5a9ZpgZGR7aSJO8qAaS+KHvHHsQ0ipI3pH8Pkx/wW1YQGPzdBprGGWsFlw75gUuxRI8SXyM4JqCdvDvW9BOTI6r4ErI3dpbso7UQ8/AUbcLS93gzy51lphX4b2/Guy8fA5nsujYtc3NyBzgp2eDmLMmHqseDa9q/b8sRIjrSG6DKS0r+/DmKy/PH1O/CS/RODHl3Mb2esBw0mM4RAzCU5jQZtfknYnoCZwWtUj5JJsWdtk0H2kRInnPVM34Bvnu1ytOQk3Zg2LyFBnL/JAzLgAOR7BspXiZO2D4T1xWEdW6Fu1ihVugeish7wPv/Hr3SM9Qg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=EB=85=84 6=EC=9B=94 9=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 6:06, Ma=
tthew Wilcox (Oracle) <willy@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> This fixes handle_bounds_compressed_page() on highmem memory
> as page_address() does not work on memory which has been kmap_local(),
> only on kmap() memory.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Looks good to me.

Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>

> ---
>  fs/ntfs/compress.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
>
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index b279f38636d6..89067fecf5a0 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -108,16 +108,16 @@ static inline void handle_bounds_compressed_page(st=
ruct page *page,
>         loff_t pos =3D page_offset(page);
>
>         if ((pos >=3D initialized_size) && (initialized_size < i_size)) {
> -               u8 *kp =3D page_address(page);
> -               unsigned int kp_ofs;
> +               size_t offset;
>
>                 ntfs_debug("Zeroing page region outside initialized size.=
");
> -               if (pos >=3D initialized_size) {
> -                       clear_page(kp);
> -                       return;
> -               }
> -               kp_ofs =3D initialized_size & ~PAGE_MASK;
> -               memset(kp + kp_ofs, 0, PAGE_SIZE - kp_ofs);
> +               if (pos >=3D initialized_size)
> +                       offset =3D 0;
> +               else
> +                       offset =3D offset_in_page(initialized_size);
> +               zero_user_segment(page, offset, PAGE_SIZE);
> +       } else {
> +               flush_dcache_page(page);
>         }
>  }
>
> @@ -222,7 +222,6 @@ static int ntfs_decompress(struct page *dest_pages[],=
 int completed_pages[],
>                                  */
>                                 handle_bounds_compressed_page(dp, i_size,
>                                                 initialized_size);
> -                               flush_dcache_page(dp);
>                                 kunmap_local(page_address(dp));
>                                 SetPageUptodate(dp);
>                                 unlock_page(dp);
> @@ -758,7 +757,6 @@ int ntfs_read_compressed_block(struct folio *folio)
>                                  */
>                                 handle_bounds_compressed_page(page, i_siz=
e,
>                                                 initialized_size);
> -                               flush_dcache_page(page);
>                                 kunmap_local(page_address(page));
>                                 SetPageUptodate(page);
>                                 unlock_page(page);
> --
> 2.47.3
>
>


--=20
Thanks,
Hyunchul

