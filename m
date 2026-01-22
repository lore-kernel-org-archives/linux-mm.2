Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDE92D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:02:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3E26B02DC; Thu, 22 Jan 2026 13:02:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 367C26B02DE; Thu, 22 Jan 2026 13:02:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266946B02E0; Thu, 22 Jan 2026 13:02:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1254A6B02DC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:02:36 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC3B9B9849
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:02:35 +0000 (UTC)
X-FDA: 84360369870.04.A926B21
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 877D040011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:02:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=e2tYbe7Z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769104953; a=rsa-sha256;
	cv=pass;
	b=GtzDMSRNOLCMmD0o/ScNQU6wypFXLin9ORD1wK+xzoVHohLm8pFUZMc4UHP6UKhEFgjUfM
	uEIT3Og49vtiKWk9a2Inp0uM1lHZSj/R4k9nU1RiRaLWr/DCWNpTgn3dzF3j/2QN8s+vb3
	x5Xs1tR8zQDfNIrgGxVnoZTDFrblVxE=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=e2tYbe7Z;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769104953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otTrg4z9M64+XZj/I9ox/NhkVUpVXgCSZrG4Nuy+n7A=;
	b=UYoB4lc2SV12B+l1ru3a1y9BUWITKVYSlZMrdizNbTKcifpHHwTxoM/pgR91aYouCAoRCy
	raL8cM8HIHn1hR535oXtY5vQR6fp14fXWIPYcqsJzfDavK7I+XRgIYSQkjE3O6pEuQax7u
	id6Q2H4kIZUMv8AyeCJLzFMK1yhxPyU=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-65832eb9723so2452653a12.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:02:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769104952; cv=none;
        d=google.com; s=arc-20240605;
        b=BBflaUdSLENt+Q3wnD7feACjGTdojT7icPArP5LBdcb3Bpgi3J1F+RgaFv+9+WyU5j
         LMFHbn6hUZX56/AenOXfQJeqpXzoyjWb6SMHLH/ExLCOt1bQbaxi2cSImTRL4ENpmMPe
         bNOqcSE+ZKxo+9vkRowRuUg877Tn9oZMluRSp69xFbNgrwSoRTF1nTaaXVBcslw/8vCe
         csPDSZjGJgQAoKljc6Te/onKjSwH67nbsuG7g2L0Pd5XXBIVYbqKnm3Zs4HKxJCj9Q9j
         4REz/gz+tnqxfPM6BN5DUveKgddf4j+MvdnphOQLHbNvmsfzojZ5nugukCFNgzzGSf5e
         Kntg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=otTrg4z9M64+XZj/I9ox/NhkVUpVXgCSZrG4Nuy+n7A=;
        fh=MHb88s07vghw124TNE1WO/rOeyxRHLG/sqjbnDuc64k=;
        b=fwOtsZ984gXU/K5EtJQtYhK5eVHBStMLjl11q4EImD2KqMhDNnHnWQK1EHLpUwKlLN
         +RrfxMwe53rkNk/cCPvpWl7C21SB3niVtK8AseegL/3JqyjTrKss/fKqpJT9FBeTQ33U
         huCdfbnoOBr/Hh54XonAQtN0YKMFuE4hFbRE+z83VFiVK8JA3dZigUjVnvClYWYFjpLW
         5lH2w7ZEI6eqGenmOJLgwY0ZRjPlH5U8s/A7QMFce+EoxQTmZavcc8XMbWvjKYmGQuyR
         4l1qpJLrw2GzhVwKq2NnVhLkhi7zrzFfzcnv5P/XlAmCflD5ANqAhh0SSJzYGyJOwnkL
         h7ww==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1769104952; x=1769709752; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otTrg4z9M64+XZj/I9ox/NhkVUpVXgCSZrG4Nuy+n7A=;
        b=e2tYbe7ZsXPX0IGzFJAV17SO0uTdT3Ulv749oRYq74wvWoYqafAJn+T4+iE8X0Fb1s
         Ibvdgyq0FF2qu2k8xQj5cAFXdFaNwTnkwD3Fk3nCmXxs4hsweB8PndLLpwiBXvWJlwPB
         1SqeCoBlX6aQfpCzWt76bPZkAjuQgtUo1FVmEN0SPbRGPzEo8QS/D5IUCkUzhCI8a4B/
         Vuxl0WWOcttbwAl1bffz8XUD4BZsGOiD4uGXW2RURfIOhn1dCjpYYeSKjVNcPytfbAaD
         ORlzYxTVdg+36CbIyyh+QE6f2FeSt7VGDESOxmV9kX4UqkeSUFpAsNndAMEJOZULgYnP
         vXhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769104952; x=1769709752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=otTrg4z9M64+XZj/I9ox/NhkVUpVXgCSZrG4Nuy+n7A=;
        b=nDXT0gjO2mm93AbiOqp4OnVagN0D/TbX5oN7quv3I59a2CyinFBr+9mxHlnuPLblgV
         XBagkpzr7uK9aAS4kHsmii9sH0L0SS9uoZu0TN52g+VrPgDMxPyOJZOKqWkQSuPulfjn
         Idic150AhoF+eJF1Lqm26FlTqgk7I9m/Igr1YijF/CnjiAxHDcoHozuYuSbdwCXqFVgy
         wiJeh9kWEYgdkRUIG+/PhqV0ch9qPcOxkydxmHs5ccjVEMVxy2wPT8Jc2W4r0ObrO+os
         AESUPptwTPuHIU31FCuVwFbmnNACE4+ifcyD9VZEZr4YmVZLIpl8I69HH5a4tUf80zfl
         JVyA==
X-Forwarded-Encrypted: i=1; AJvYcCVejcdNtlwh50oe063mk0TR3E91L4hGeT8/svksOo5LDF/e0b5FTX8t2B6R1yRoy1MokqQetoBb6g==@kvack.org
X-Gm-Message-State: AOJu0YwJxOuwMUbctwomfZ4SJ9Om5HkY63X6yle3hHKL8DQaNYNZF6sx
	Bx9RBEIjnBeuc76dUtSMeQepJXOrBuSiU2z2AZHQHzhXzbQthNN15qp558WQATtnzJeGVHI059Y
	QqR7UkUkVvi3JkBtnpdFY5EnBEOMyJKnlOnCTVwpg3Q==
X-Gm-Gg: AZuq6aKxz1cMGXQvU8MjoX0cwLMmbw+/gAb98d5vPYxlj77yPsN1rjUzPLbUVlcBOKu
	/w+cLCOv9ORxEZJyB/yMjIeiYCvZ5lO+AuhoqSLB1nmm16oNu8iD4KO/LKUB3lxybmjDCgBMIY6
	l+W+6OTKgfzucfzUkES+moFNs1o8mrcQalAfQHp8jTSR2dTRmpfDih4PpMpoy0Nat2t/+TM9A8h
	ciEiGq0UFBGjxXffIiR7A44LINM40pOO1bJou4MFgZbaXnkd00+l4ZWeIIMLV2xbFMcEyw52yYQ
	NC1/wRJxNerRj1+0KGsjmDWhkg==
X-Received: by 2002:a17:907:3f05:b0:b7a:1bde:a01a with SMTP id
 a640c23a62f3a-b885aecb3e1mr7520266b.62.1769104951975; Thu, 22 Jan 2026
 10:02:31 -0800 (PST)
MIME-Version: 1.0
References: <20260122151842.4069702-1-pratyush@kernel.org> <20260122151842.4069702-3-pratyush@kernel.org>
In-Reply-To: <20260122151842.4069702-3-pratyush@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 22 Jan 2026 13:01:54 -0500
X-Gm-Features: AZwV_Qg5XreMG7dwNWQ-MFIKK0qTchgxKM2qV59FoSM3HBQMpghysXs5DLe9KBE
Message-ID: <CA+CK2bBA8=NHx0KtjsrOdFRCdQAo7ooDaw4OBj1HWr4doZh0PA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mm: memfd_luo: use memfd_alloc_file() instead of shmem_file_setup()
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 877D040011
X-Stat-Signature: sekn339jo9uez8wow7qpxw3y89w5t4m5
X-HE-Tag: 1769104953-278862
X-HE-Meta: U2FsdGVkX1+9w5l7Ov8GF4rS2jvt0jDs9TJ/+gPUBQWm+GxVGA+V0nyB6mOZvdRlusec/sR36rnuz3miQInfRnMHrmUWq1mQYBwlqUTVF2N8LO1iAlLDETi76fwhLr7/Q33JcAqG7uc+Xlv+1APIR2rHpwf75Y3zqNewgXmbfU6OSpdSTRWgfdiZQ2d9VK4Vvv9/FCId2+mm1mchsahlhrfjNeAvL4X/6fjrV0+GqrXC57KMnHb4PFv+q1K+gZE79NegaO+UUZuFo0pdRCchpx0apqwWs2wmLZ9DiKvxUotzYC1i+U7OVlsyyB17AIekNRM6yIfZQJMj0Pf0zaObzqJbvYLTHmxaTEhwygPNP0hxxd5ljegKpxBlRd19TACHbga1ycYVeNIBIF/wWwq0D12h3MzqZdkb67JJ+ms8FOY6lNPCLV2+sMdxNHwimXdYDfPJljz3NLmTI8snrM5xGT8qnjGQNmkzRL3gAAhYMyjV7V27VTF6IkTTOJDNbjW6S31+Yu/QMghW9YaiNeJOdhmDzg9MGbNFHZD9gyQJsCw1X/gDUSJ+DELgpdXEWjJUQrNLvu1ui9984+st/Dwodzt1vV1gQ+UFzRUJESIsmgwuf0s/z9EZm+dcTCmO2ZDCDj6KXy7pCN9GrXgpqhJvU1kbID81O8TXE4ObmTosd1WPr7ShYuKymQBzaGIq/Uqryg6V/auo7za4PXq8Lf4NP1GHg7B/dWLjMQo64wlVHQDrO4M9nV+L1VEMHposP58YESNt0sX/yAwx0xkeLXMva12rw7pQ7RG9obGTqF5ts4mIM6F9GklOHRx4Q3swN9ChIW84h6WIEsZhcMMldgcIToYZQb1f5cFUiqdzY6v8ezQW0FOIKYyyvp+k6+tBYn58iE+xPgmcZ7h+HJaRYk0zgP5naIqZIbYqDrBhc6F/TTSYoHbB0IGRXk3sLq6BtHKDIyUPPAhs/cumNEA7auc
 /Tc+7H+F
 sgcFa4RMhFWWYwBH+N9pz2/ilIJ/MIZXhDw6HYp14ODX+mT8yq9Th/9KHU+KZuJIZ67lY1o7gQl3iiRR+9NZsWW2EvlwkTow158O7EvNC6oJe5wJctMRmA2GXtm76xC+munPf8U4HomO7+eo9YiwTJj2LTmIZFynwQ+wqRWntSSs8QR/bI9weXPy0SWu2i1w4c6FJhUhQeQePpvzHU8pOVpM/GfZ3P3sjAwG6AFs7hmkh5UuSoN2tnNB7gRUodktj11qN8WD1Rn80Dcf0KX+fJos+fQW8JjyP0o9s2z//kH7o4B3dDz0ZOzQ/8nfaxRuo3REucLHIqaaYSZU4GDf2/fju3WjlKFdaUJUIM9yfTYPIdSkdc9elYEcQcjgHYUc0CATcdVAnsSCSghqqjhWebxVESQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 10:19=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>
> When restoring a memfd, the file is created using shmem_file_setup().
> While memfd creation also calls this function to get the file, it also
> does other things:
>
>   1. The O_LARGEFILE flag is set on the file. If this is not done,
>   writes on the memfd exceeding 2 GiB fail.
>
>   2. FMODE_LSEEK, FMODE_PREAD, and FMODE_PWRITE are set on the file.
>   This makes sure the file is seekable and can be used with pread() and
>   pwrite().
>
>   3. Initializes the security field for the inode and makes sure that
>   inode creation is permitted by the security module.
>
> Currently, none of those things are done. This means writes above 2 GiB
> fail, pread(), and pwrite() fail, and so on. lseek() happens to work
> because file_init_path() sets it because shmem defines fop->llseek.
>
> Fix this by using memfd_alloc_file() to get the file to make sure the
> initialization sequence for normal and preserved memfd is the same.
>
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  mm/memfd_luo.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 4f6ba63b4310..01a72e4d3ef6 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -78,6 +78,7 @@
>  #include <linux/liveupdate.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/vmalloc.h>
> +#include <linux/memfd.h>
>  #include "internal.h"
>
>  static int memfd_luo_preserve_folios(struct file *file,
> @@ -443,8 +444,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_=
op_args *args)
>         if (!ser)
>                 return -EINVAL;
>
> -       file =3D shmem_file_setup("", 0, VM_NORESERVE);
> -
> +       file =3D memfd_alloc_file("", 0);


Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

