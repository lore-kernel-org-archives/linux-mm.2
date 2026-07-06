Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57FA2C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 01:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 423E96B009E; Sun,  5 Jul 2026 21:58:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD246B009F; Sun,  5 Jul 2026 21:58:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E156B00A0; Sun,  5 Jul 2026 21:58:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB4A96B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 21:58:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51A311C1348
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:58:34 +0000 (UTC)
X-FDA: 84956692548.27.1F70D9F
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6866C20006
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 01:58:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lwALSInD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783303112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfeozLc8lfROroWi4fuwydRuWdXvG6VBqX8p8xBH/ZA=;
	b=su3Kw3GmFLq3x31L86H8bQMzO7iWoQ2Si4ZNFfy0kU9TlQu1O37Rc+Z3CbqVwjEHeKEqRH
	IMRSAt3ZqgCZOuJSWnRj463igLCjrckp15xBKx4ScdRpEcFleBxn5hUWjRBLqttAGNdekC
	G8bVmF+gMT/YTBDibcZgAApzxQt3qmU=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lwALSInD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of hyc.lee@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=hyc.lee@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783303112;
	b=CPco//8my7JBEU7djdAzhapLfdfDWq9kKEBsf8CAEurjjoUAILX+h+qavQCqODOXXNoAZd
	oGH1ZINVKnHLLxpmJ7LctRxJO5EQTdozxNFJ6Nm644+R9z/XZGLq+cJ4pv3r1FyFMl2ztP
	ZdDypgIYHmpkvGg6LFPWVWkf1Y1c05c=
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5aeb77b3afbso2290948e87.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 18:58:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783303111; cv=none;
        d=google.com; s=arc-20260327;
        b=VF5P3Ux9RKrVz517ojlIAd2eXPH5f1a+CgSPRGuOoj3C2Xo606g8hhy60ZL6a4l4m/
         +/BTquBoPJoNlg+SYMqVEBLq4qbwJsXJCtQjAG7ZcRTrgy90RODyRvOzPbdm0H5Rbue0
         Ez/GNRggmr475ndA9R8dQ3UcPg5naxOJJ4KqfokHipiRufnz7Myhwz7GIqSi5torluNQ
         0bb8wAKBjYPC26NwKtsz5LLIa4/zkSxU+91/OjKDge92qbUAZKJcViFubtxTml/1jCaz
         iLXy3H1v4kctC/tuevCjJCeHf/FOvU0kwRHgIzyzkjpRLttVmrvfNyY5mvu7YsF1dl+U
         UqTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hfeozLc8lfROroWi4fuwydRuWdXvG6VBqX8p8xBH/ZA=;
        fh=frDq34Zm3O9+oFxr2mpDA7VECfl6pAsogSIsTY3hoRk=;
        b=iKCx7e7FE24NrxS+bYUj4Hs907Hk5rDcpD66a5Omhru3paaVEvxBIZhmPtTHozSTDQ
         dabB9vVfcV3zLOG5TCHb+iLyjRgzcVsnLEC1P8Qp9t6JJFyq2BjdyjkL7POz+xZGJpsv
         3mvDUlCQ112HBkcVs5Qz3RwxE1bH5GPlzwwk3BeqD+4pdyc7ApnFbhJzRqylvvFL7myK
         VLLN/9tEsHdn7cuZWsO2TcmKjqL8d/hmOYmyUJZHSnIwaPa6n8tB2i9/wlHFzb3Ufgw1
         Ec81OmN7n+ENS+fw0hGvQA6tvQP5qPUXHZqogZUNpPB1YtkPXuZ6TGkWsjlL7GzIYGgi
         9tzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783303111; x=1783907911; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfeozLc8lfROroWi4fuwydRuWdXvG6VBqX8p8xBH/ZA=;
        b=lwALSInDZy9THQ+7uYOLyVj7bJi8eKZUKuZE6KidQDCUfbpzJdVdXHZihwXUYFIeU6
         OuEwSG22aERLIPRunIm/W9fII8rqfAym+WZWTPL8nooKU0KsQv+eVUcqDNTHqvbkILdJ
         uuK/dkBahGmvGtpwNzJ9JyaQqH2jBHz0HoMlJNj8qGQB5bdWw6OAkOxjg61kQRyRbYD1
         6/TtweeO6tCJNYNOCevbAdDRptBKzg/OSbfvj4kBj/cZvKx4iQe+yAQr5tT3W3Fj329F
         TT2LPp05X9EamMdDSmbta7iJLMriWjFzzn0/Q1rvSzYKxU1IZ97SFLWs11HfUc6NPKJ1
         8DMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783303111; x=1783907911;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hfeozLc8lfROroWi4fuwydRuWdXvG6VBqX8p8xBH/ZA=;
        b=pROcBLyvBePFgDeOjFS4AHmFsO+J4bWpga+aEhwvQv/T9mQIjYCr8PkIhlL7R4Y6h0
         nb9aCgum3XdcPOpUZimGQhq0tfsKQLQq/qxbiEur8IP83QT/SQ360QnDPvDIJtziO9A2
         4kZwG4IotXI9ngbP/IwltmPnZeJ24DGHpNdsmZfl2Kp2dbNaiKRUuYyDluTI7h2VSpTF
         gb7lGeiuUgJNTvQ38Hg1LKGjEM4EpB097AODTrgIgWyW5EOIAnzW/WHLnFXw2xe7XiI5
         68Nbg65PO/R3c/4qy3hpwq9NZwgZfdpfuWrKX0d6MEWS2FGz0A4LgRDzVo5KqcuECGMC
         rkmg==
X-Forwarded-Encrypted: i=1; AHgh+Rp5FNIgbsPn9LFgmUsUtPWvmvgv13lKga7XZRQPnCUwhst4iBvvN9kctVff2AEfAoi19QRDfl3O4g==@kvack.org
X-Gm-Message-State: AOJu0YzvvVYhgDBwlmXB3tDm4ppjfp9N+1eRz82gZ+gedt8nY1AKsw7Q
	bpkPuDmdMsw7PmvakKAvgY+3UKMmvzp1hr8q7KCZTy8j1HZSneb5CvZYoCM2zTZfSCyositoihK
	GGQsIOOS3AVpnFCaxoT6a/mLdVLakBvc=
X-Gm-Gg: AfdE7clcJ2AfZPOYB4ua6xG80BdIqH+322QFhHPGPZFjku89xQyXU9pg2Wf037wPF9I
	XfAuMo/8QDPiUkHL/Hh1EDOug4u1YWsjf5KTF++ljMwN9cM5YpHjFDI8G8ZML+DmE/DatwplieM
	eQslskcGR9jtl1ekbwZvBVjUpJoki9lW+GmELX3uPdXORHmtS/nBadDMpppIUW8WEgb2C8ou6JR
	i8DDj4MYd7xvRMMoTFuXcIWwq7hT4xEG/7PksBrB9y1u1OBv8DCn7S3JJgk3wAFsRxG6YXI
X-Received: by 2002:a05:6512:8358:b0:5ae:bd5b:c68b with SMTP id
 2adb3069b0e04-5aed50b80b8mr920536e87.37.1783303110567; Sun, 05 Jul 2026
 18:58:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260608210618.3437216-1-willy@infradead.org> <20260608210618.3437216-3-willy@infradead.org>
In-Reply-To: <20260608210618.3437216-3-willy@infradead.org>
From: Hyunchul Lee <hyc.lee@gmail.com>
Date: Mon, 6 Jul 2026 10:58:18 +0900
X-Gm-Features: AVVi8CeDqc8BYSLiYYk2lLX6apbCk_RkRARPEBX1R5X1hq38Hbtq6M6jPVakieI
Message-ID: <CANFS6bYc5uSSYWvwJZ4BgjzF0_bO9rkcFNvX2vVHnzWDi3kpuw@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ntfs: Remove use of __folio_index in handle_bounds_compressed_page()
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Namjae Jeon <linkinjeon@kernel.org>, usama.arif@linux.dev, 
	lance.yang@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6866C20006
X-Stat-Signature: zpgo171cfcybxt3tctwdrae5s1wb5jib
X-HE-Tag: 1783303112-663073
X-HE-Meta: U2FsdGVkX18MGGch+y5g6SI7CcuQM5YSFVzab5KGL+OTCibgjGm2/d/+mN1GGZAiZAbl9W/eJRWl5lCTdOVgM60VFv1H8kjNsgWZLnWVUoLjMznBSvPLtIcY2R+v/TP1iREJil5uL3/HS6SAn3QDempvBRM24DpX3eNDpDin23oCYue8o6K65124ram/bx0mf1VIix7H+8IDW06ZTdnN5/+EgyaxKK+EbWW6UexY/RvzI6Liqwm8dt0Iej8JNkpJWXf8T6CKArzVhnvCnIWIo0tIF87oCUPxyE+ASLumzcMoWxe3LJdmOPHNu1hdSIfpMOyQmcJ7D53i8w6/TbFBd5pxmo3Ebd5mpZwnCWBfbjF1lY/ZJhrdoOkkBPSKdCwwU5xAdMS6TqjhT+8Ci051fltPyMZAvtAiE810ebV5Y7PsGvPvd+KT5OpmJvqbAXXTPHqjnF7NhaX2uv4pjPE4ISP+U6e3736Zt78wXvfjStYvLIJ1zvlRwHqVwD7+8ENZCL40Y7Rqdi878q7QiEsnoyA7C8BfM3EOjZMPwDR2YSRLFKecAYcOh8Cqr2lZKExzWiBPYh6pgFSl7R9yI1A6aTauXKiJvZPHrjN3m0/TiJNje6veTdE976fZVw9Mw51YN0OocdQAbGi6Or0dNK7abA2/dyImoF1gtrwbLRQb4aj0CSTey91liAkuy+liC8PQEeo1cY/ReyjGMy3kb3Mr9FqkBV+ftjS32sgdpwzvSFzqnLBeUdlTFIzPAeOrev+rE1gs9xaeJo6zclm5ptzcyLk0O6eMf/5c8hiEygJ0rfFMbJFs6UCa1Pyh0dpdjqt1A0X418k3OtGie+o3PnZ5VnBp8VUrr2ioN2fpusDY1z+B9+i9oS/J1kdvxujuwIJ2SdiFxmRc8XuMdSUVP4Bv+Xj4nse6CCIlKkCAQx6NLWM1d7s7dkC+AvaPc6CiDpUOzYke6o61cF5U+cOYWEj
 p/beiC+y
 uHEw/HyC6Tv4JgvIjtQ0ZILlqEff6pFA6O2bhV5pfG+PweLal2N+2JDgRWeqK32mlN1EcVThowhv9QsW1OS/PGfxRp+hIzb8v6Ihx6VAFJw5eTcvwplZ6Tyt+ZFI8VNAFVcHrW0VCzM0mMIVU0z7yTKteQJxpwi+gtjhwxnd6O+MxSon/Eg7spp/roP5bKwyYfwmYgclQSTgig8zY32SxErF8+n/TXxdHcp3LUUFuqYtHkorirHPfnOGH//lx3HFh0bsfdqCMQSuVcpXapDTyj7tjJ7xGsAzB5s6sKf5OKD72Pj3puZeusACI/ueAdYJSyb22hmeW2A98HG9E13enQMgkg/jkG/iE0ovbHet5/SzdhtyOOe+35FkAMpP+rcQdmX9SOGkxqi+lORSBSmcFtFtdDyIiQTgTM30uUBxbJ3d3IzjMyIOpt1ciMfz/tKdCreBzTFRiTqH5Yh/61lH8a1HF4i4OgY6H3YidvdhSPFE+JHdZTSu3/Osi2BMLCJkXESSc/xMaxFijTh0iyHTYmKqxP2El4XPrqEu9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

2026=EB=85=84 6=EC=9B=94 9=EC=9D=BC (=ED=99=94) =EC=98=A4=EC=A0=84 6:06, Ma=
tthew Wilcox (Oracle) <willy@infradead.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=
=84=B1:
>
> Nobody is supposed to use page->__folio_index.  Use page_offset()
> instead, and simplify by working exclusively in loff_t instead of mixing
> up loff_t and pgoff_t.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  fs/ntfs/compress.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ntfs/compress.c b/fs/ntfs/compress.c
> index c904858dff3d..b279f38636d6 100644
> --- a/fs/ntfs/compress.c
> +++ b/fs/ntfs/compress.c
> @@ -105,13 +105,14 @@ void free_compression_buffers(void)
>  static inline void handle_bounds_compressed_page(struct page *page,
>                 const loff_t i_size, const s64 initialized_size)
>  {
> -       if ((page->__folio_index >=3D (initialized_size >> PAGE_SHIFT)) &=
&
> -                       (initialized_size < i_size)) {
> +       loff_t pos =3D page_offset(page);
> +
> +       if ((pos >=3D initialized_size) && (initialized_size < i_size)) {

I think the following change would address the review comments for
this patch and patch 3/6.

if ((pos + PAGE_SIZE > initialized_size) && (initialized_size < i_size)) {

>                 u8 *kp =3D page_address(page);
>                 unsigned int kp_ofs;
>
>                 ntfs_debug("Zeroing page region outside initialized size.=
");
> -               if (((s64)page->__folio_index << PAGE_SHIFT) >=3D initial=
ized_size) {
> +               if (pos >=3D initialized_size) {
>                         clear_page(kp);
>                         return;
>                 }
> --
> 2.47.3
>
>


--=20
Thanks,
Hyunchul

