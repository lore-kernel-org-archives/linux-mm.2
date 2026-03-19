Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40CA0109023C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 15:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84D9C6B050E; Thu, 19 Mar 2026 11:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FE636B0510; Thu, 19 Mar 2026 11:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ED116B0511; Thu, 19 Mar 2026 11:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7E06B050E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:35:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A03BBA63B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:35:04 +0000 (UTC)
X-FDA: 84563210928.30.669AC88
Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 28D014000E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 15:35:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="cZPuLL/K";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773934502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIexmnA50knUnYgrI817KjDlfnzcLaeFntWA5d9hg3s=;
	b=5SJYR+vtUMG+RkxsQp+y4Vv0dQKhA8M76oYCDMQRVnxDo6xkVHlzjWeQro3IWUmaF/Z77r
	l+lTNVofcFmM3BwOPOy5YwUzuj6g4fQ2F5JA83WO9H3pBaFy9qW666h1XJuusjAdYrCXAi
	9/zGl9OKEm391tGRhZqhaurcgU7wZWA=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773934502; a=rsa-sha256;
	cv=pass;
	b=WJVzET8LaS9NlU23LAW+K5Cbu4fLnieyzy8q6j2LYzoRiwwnvVThFG+MyceZCRHcd7yDkM
	575OnDIJhXj3NanCDBemLmuxfJ0+h6QB3ma8LbMjTeWPWDEdz2amviOG65IIkIDM1pDZSk
	53SsH3Jtm5u/p8P5U8SNw+7JxXjy8V8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="cZPuLL/K";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-38bd60d7a2cso9128591fa.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 08:35:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773934500; cv=none;
        d=google.com; s=arc-20240605;
        b=ap9K1I2h/aWLvA5yD3PLnH18QE6EUoOYkNloBbMnkI2W5UIpbKmuy8x7lm/2qGgQo+
         EjK6opE2LyI4P6OK8eueJwDUM7djzYnd9kOhpueQEg+WgpjAG+MnbFzCsKXGwlbs0H19
         xSt76acWK3QDFsBNYrIXyUxWLaf5jxgymugYnaHrQvXWiWszYv9nEBnAi7TtbFnJYqPG
         zME1yclCe7VLTquve90qgqIO9awxDg0/emPtS6RAzgcfY0c3WXVamUDHv0VKg5ZI56wo
         f34IgaLjquF3uv3ImIyA0n2vXFp/RL2YTb1ZZC1WXBmZsMlb6YmKMr6AXR6TH7pOkTIN
         0xfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZIexmnA50knUnYgrI817KjDlfnzcLaeFntWA5d9hg3s=;
        fh=6jaPpXSFYW2PLchb4vyRbprOkbYM7N+3rPU4mKwDTtM=;
        b=IkJQwFo8fG+S/eOkzmQmzszmIWyDumifQ1t6zyvmOKJbyJg+5UrD4h/C3Jm57+ugfO
         zuWJS7bp3nIU1gYn1bbR46Wf5D5Q+A3N5yifSkWnFAPGvjr0zCVqwIWDYPxt4k3I8xyB
         M4j2xMmrcj7RQ76dJOQTcemp45qccL7Tt79qajVNrdkwzBMWKwrdb9MbGj0GRG+qAeUR
         CGiX9YJhSh8QHHtgfXX4qLUwyEGTzRpLihose6xXgbscVNGDNnY42Rx+LBvHNnpa/kdd
         oSUrPdAMf59db+a8olSPa7I/bMmPjPcv7pjGnaqEUW1lwncb1wg4nF2XpwGTQ67c4L8G
         ts/g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773934500; x=1774539300; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZIexmnA50knUnYgrI817KjDlfnzcLaeFntWA5d9hg3s=;
        b=cZPuLL/KIYGKekBmBN9Ya3B64BFiL5+sXfVshSIefz/G936F0I2vCu4OyWqIwZrqJ5
         CYmaCQSraSqVPADzF2WBYGFFdgnXC6jloaDASPQZH+oM/5+kP8tNTA7KxVpwrqwormRY
         QuSpZ5T2yf5323o9jF9Q03B/fchHPHrhoT/b2xBAK/1OkQWfoqx3yaN4ax4EQuQenMKQ
         IWs/ojlPqDpB7dl7N6ft/EhgR9E93J4NNtbXUhrETM3VgUQasyruPBCmTt0KPwiuWgka
         cyjC9UoCGr9EpXur75JgocKyJyuEaanxO8SCp3YLmpiUU2X8yvJlnhylwa7DYRV2mgkj
         xlkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773934500; x=1774539300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZIexmnA50knUnYgrI817KjDlfnzcLaeFntWA5d9hg3s=;
        b=tOXtiN7KR/X4Zmqv+32ogsk1NZDoBaFVJ+/sK/TBe2Xs3P1hOhz2Umev2XTIoRd+gi
         hCeJmjI0JD7EDklAS3Pz46+MtSUCprjQiWbkbcgbbVdC+HbdBRzeLloRvs3LfMxPOgFv
         uAn6aiRrfjFevUYyATtrWvE1aq66EOTARdj6eImmX/W+LA5/Sb+/t44bDNDEAyMAxfNV
         AbsAxkK6X6TekzLiqFiWkT6Omg+lWDYrym0/OpqRcz3jxBmbC5IOeJe3XSRMXSnTrwhD
         k0kZgXWgS+FaGOH5pPsrZzXIjkXo7sbKge9SSWNQNkGm6V1OjnPb8m0JLqgygpfc31Ir
         TV8w==
X-Forwarded-Encrypted: i=1; AJvYcCUNtDlTeIiq1Au5n0RNgJ1ipk5S6s1z9QUV+8Ishzl7JtsIOSNyfK8iXxSg3HBHfj1NXNowdr2Ung==@kvack.org
X-Gm-Message-State: AOJu0YybfkJIsz4Mxu/Nlugynb4zXnePleBThkppJgXexSDmOjfEN7Gl
	Z3YXxadbsssCuYHY3xwAoG5dKlkU62dD6PxQgfxl3NWBAMys4NPFN7GyWQ3pE5dXGrxYVwL95Nj
	4OEojVQkDswL455cPfOCCDYndF0WL8LU0FjPHfGCLDx/wK7qtS+8m
X-Gm-Gg: ATEYQzypFdQgvww2gQjdnEZ/0uZ4EYPe/BMroTA5hTbv1D39BBu8nUFdwq0Ua6LMzVT
	YO53d02m5qT1tJVjaCrGniD6J7cMobi4xys+RVesVn8OxNmAiwgJhdhgRPxFNA376nr9dyomTt8
	ItojmaiGIfcOMPALbbbULHY4dHzx3XQwaxTbZRv/rtctmz2zUwcA33CM+V4waqFDyJDvJjc23au
	R+JrDhvDDaJiOFXo+WYwoSwk7sxTOU/G9NzZ2xbWlqUVyYRO8vjCpD3HIx3PdyX66SWNIH1xlxE
	sIWveRYCr+aU/HwmDp+tvDr73kGCAcceHVxXsA==
X-Received: by 2002:a17:907:60d5:b0:b97:cc05:61a7 with SMTP id
 a640c23a62f3a-b97f4aad93cmr533804066b.51.1773934122484; Thu, 19 Mar 2026
 08:28:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260319012845.29570-1-duanchenghao@kylinos.cn> <20260319012845.29570-2-duanchenghao@kylinos.cn>
In-Reply-To: <20260319012845.29570-2-duanchenghao@kylinos.cn>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 19 Mar 2026 11:28:05 -0400
X-Gm-Features: AaiRm511V7I-Q5uA03FpbpwgeuYBRLuYMReYfvE5ob7xjGQJ6AA0Hp8l7JlaFFY
Message-ID: <CA+CK2bA8+s_4Ue6NUkRPwi4yDzka6H02SbcYwZF1ODyTLDRhNQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] mm/memfd_luo: optimize shmem_recalc_inode calls in
 retrieve path
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: rppt@kernel.org, pratyush@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28D014000E
X-Stat-Signature: 7pe1g96cxi7b43fkrer9675b5f11manb
X-Rspam-User: 
X-HE-Tag: 1773934501-815620
X-HE-Meta: U2FsdGVkX18aL5ZAVYm1F3M5/ghQ5UVzF5XsNi7Ka1Ghz+hAtbvLUSyOyjhk1TRvZAk3DpkQ2oYbdT2gkgIv5OL1uTc891I/mee3wJoRdIW2ReTGNWvDCHrqRCnutrmZGdR7vtb1ZJNyRn/Gp9ijuW7v1ir2DuS4HhudggHF7YQAFsgxC5TqPaqcX5I0bbDlltTALB9+9VzfykTTJCB6f1JHLAUN6L6629/Zlk8zLBamY2f3RPXoKtjH42Wz1w3dHBLAO+AtzoFMEHirLqCBBPLGCxDbPpMwjo2cuCExO4PHpFxx7297oVJQHKQQwkYJDoEeeqOiGOL5rFOkgp9MOXlVY+MKc35W/9F5Cz0liCw1Ar/16qYE4TqRRLbXiVlth9YN1YR9KqLNvh4sMxFqLGsMRb62NMu4kYscJa10WgHSdLK6ku8iC69Czl6zjtszdtpbVYT8XBIDlQh3gf89mOm4FxGenEWRTiG+Yt97eLiI4wcfy1SY26xzA0LxLMF7+1EzGoS18zg+qxER+Bf60oU8Iiy7yvz1jnGLD4IfoMVMffkWWJ82z5WpUpnDcN9zfF4rQj5/uqNNKhSNhez2WAlIWubXOm63NmHOW6U+UsJ3NtH0OeHgBMVHmNIf264JeYkcY2bo50Pw+sWCt/gBvRlF6c9lfeSmGQ38wW2HKqaHc8NI4d/limaznWY8Q8jlr1Xi8Zm/ttTMSYt9202VgEzjtRNLx2fBQCKwilDF8/WIc0QgcFBsMzeQUt9UFCqKgqzcsw1JLPiTx9KVbm9znX+JdamrV+umsMgaun8SIh5KOLQ00BP3oiY8bTK3AAxCMzRcpxrvPyKVniWPmdnj+b3VRJaSQblNN+Vz5wdIxgXTJPX3m/8pmhrASD9R5n38PYaUyRS3wuv5q1442NH6PbNSbuMejrC1vsV2REBB6iN+0RGg2w2aJM3itS3EcOyc0158sSB0ooFImAbDnqR
 GIABMSFK
 AYux8lCmzem75jwlYvFLpuOfLig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 9:29=E2=80=AFPM Chenghao Duan <duanchenghao@kylinos=
.cn> wrote:
>
> Move shmem_recalc_inode() out of the loop in memfd_luo_retrieve_folios()
> to improve performance when restoring large memfds.
>
> Currently, shmem_recalc_inode() is called for each folio during restore,
> which is O(n) expensive operations. This patch collects the number of
> successfully added folios and calls shmem_recalc_inode() once after the
> loop completes, reducing complexity to O(1).
>
> Additionally, fix the error path to also call shmem_recalc_inode() for
> the folios that were successfully added before the error occurred.
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>  mm/memfd_luo.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index b8edb9f981d7..5ddd3657d8be 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -397,6 +397,7 @@ static int memfd_luo_retrieve_folios(struct file *fil=
e,
>         struct folio *folio;
>         int err =3D -EIO;
>         long i;
> +       u64 nr_added =3D 0;

nit: I perfer RCT for local variables order, but it is not followed in
this file anyway.

>
>         for (i =3D 0; i < nr_folios; i++) {
>                 const struct memfd_luo_folio_ser *pfolio =3D &folios_ser[=
i];
> @@ -448,12 +449,15 @@ static int memfd_luo_retrieve_folios(struct file *f=
ile,
>                         goto unlock_folio;
>                 }
>
> -               shmem_recalc_inode(inode, 1, 0);
> +               nr_added++;
>                 folio_add_lru(folio);
>                 folio_unlock(folio);
>                 folio_put(folio);
>         }
>
> +       if (nr_added)
> +               shmem_recalc_inode(inode, nr_added, 0);
> +
>         return 0;
>
>  unlock_folio:
> @@ -472,6 +476,9 @@ static int memfd_luo_retrieve_folios(struct file *fil=
e,
>                         folio_put(folio);
>         }
>
> +       if (nr_added)
> +               shmem_recalc_inode(inode, nr_added, 0);
> +

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

