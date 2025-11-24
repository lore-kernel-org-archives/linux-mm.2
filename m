Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A258CFD313
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 14:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 741BD6B0022; Mon, 24 Nov 2025 09:49:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0E66B002F; Mon, 24 Nov 2025 09:49:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9C56B0032; Mon, 24 Nov 2025 09:49:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 47E416B0022
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:49:56 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6660C0458
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:49:55 +0000 (UTC)
X-FDA: 84145785150.04.5429031
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id EC2EB80012
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:49:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="L/ItU/kR";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=bgeffon@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763995794; a=rsa-sha256;
	cv=none;
	b=316lFtH0JBDZCjO44TxC2+F2s6VAb3P284xbQbJ+oln7DTdzV9bRHOS5YbyR1O0Xp0OBsw
	crFZ6T93pXyiKqeEiwDotbSyRHCqU/HyztN/fR2e4sQSvA6IWxMqH6LmZLCCXn7kMa2fut
	fCRbkaAhfpsjR42SCB3UIS4oEjw4Hzc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="L/ItU/kR";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of bgeffon@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=bgeffon@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763995794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jfjvFTqZVsCNRnOOfiQNCDtSe9mdhB80/mf1pjQQ4eE=;
	b=Z6bFeuBlwnLw89lwXcyDjs7pZVztMRJuwkgbgIMFkIXLv1+gsrtDszd1Q0HHi8Ltj1zmLJ
	TvHpgpOvrupIN3FWVYhQazmWv9L/3dKzPFw08+A87mzFLTdrZu80TwxHzLf+mJU9IHomrh
	sCjPyCVCbtNxXkO/sjJecw7+W4BRvRU=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-297e13bf404so362525ad.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763995793; x=1764600593; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jfjvFTqZVsCNRnOOfiQNCDtSe9mdhB80/mf1pjQQ4eE=;
        b=L/ItU/kRhGCVciu3VXrFoehMba0JQOuJQ++D6a3n4LyeG8tMlFez5w5pAY4D96AFV1
         xPuW/L6XnWsDTXEmMbTYbaY7TnQoF2iUzUWxul+J0qSG74nGtqA2Y8jJK7EM2ALwfuxV
         qDNIy1WL5mIY5+hYg4ke5rOTcnB57HgZwQyrgdXW+U29C4p2A33+Y5TONr0OvHyN/QcA
         Zhjgo94UtPaRBDctb10EL/XE8rIE8H3YpRygkdUWOo5bAotx/S2OubqUkuua/f1rb3HM
         iYvWuvPSXMPhuCniRVXtHUtKv4IkLDO1/G47J7TNZS/2BCUsFV0myg9Z5D+Sh4wKjoWT
         q2zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763995793; x=1764600593;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=jfjvFTqZVsCNRnOOfiQNCDtSe9mdhB80/mf1pjQQ4eE=;
        b=lYGeUNzkdQnUCw3m794p7SVJbxU/VQwvk4w1qo9kViylQGhMCHe8qM2Zx2Asdm9c2s
         qXVlhQdudTXkhrOsgIM0MzcJIOfRT3Q0PQduhe5fIY98irPF/9dTu4fYCHg3EwYKVKLx
         iM7MAWuqd8gxU3V5V1fC3HOCWmuzP9Jb51FTIgzn5aNxrB/th5JHST/Yu2V+XONstl7z
         AgRIHjKLWRDZ3R6LgOHZIdxxhUvpnDit8WFkERSoLg+cS6zXpjyd++CZDE5R8rdiyRsG
         UUk4WsvZWCNwEY1rGkPB8YbdZwkCLg4SgnjB0JrNRM4+eyGXTMLWNhBJq4nrE5Mfl2qU
         bvOA==
X-Forwarded-Encrypted: i=1; AJvYcCXlnlxeVxYc1k7mrFB73IyjOLxpyWCTF/ZvG3zceS8UgUkgezBkzBfsX4CcPkXGmDF9TSN4g2HFyA==@kvack.org
X-Gm-Message-State: AOJu0YwLjZ03q1rEB8Muz92QBic/7pjKHK0zjN5M/dqMye5DeriYe0yC
	zAMEaM0IMr0IZnPa787Op1uh6dbxLOsiSi7PTkIli2tdchqIyf/zWlGQGyvMKsoG1tYF0aAOgZY
	i80Rux/KlMG5rxcNmLyC5GI7mvf132xJGx9r0RPAZ
X-Gm-Gg: ASbGncv3B34GCPjAc6WeBWUMBhixNTFXn+gQx8EaBS5slCHvnD33YMbexzfSfPgJH++
	f2XBoNRf48w8pZm9TCWbszpTuDjyvX0tP2lEBU6LT1NLEwGVf72VBXIkfH9KJ52nM4JRud0ELgO
	A66umHorNfXTOCTQ5pBbFyB6UoxYuipgIb8ju5e43yYQGHO307BaOblVTQ8hXpzy6o6JJJqsm5l
	oaQ4dceVeyfXod2b3eZUDxnOD47xN/kZKun5rhf6V3PX6sNmNs0J3GzDQqasJTecdBqBvxy/CBg
	Jmh6r5Pg5BDie4Odh83xWgJLSovVTmSls6FAkMFjvLg+nOud7b+J3Sg=
X-Google-Smtp-Source: AGHT+IGRulCupwdJmFvYrXnXeObGMVRuegK6S63semZ187VZIMLLUPpXt4Cfo7EegvfgpRWvfboPuLskdmqfhkmc6Nc=
X-Received: by 2002:a17:903:1a83:b0:290:be4a:40d2 with SMTP id
 d9443c01a7336-29b7b3ce4abmr3467985ad.13.1763995792590; Mon, 24 Nov 2025
 06:49:52 -0800 (PST)
MIME-Version: 1.0
References: <20251120152126.3126298-1-senozhatsky@chromium.org> <20251120152126.3126298-7-senozhatsky@chromium.org>
In-Reply-To: <20251120152126.3126298-7-senozhatsky@chromium.org>
From: Brian Geffon <bgeffon@google.com>
Date: Mon, 24 Nov 2025 09:49:15 -0500
X-Gm-Features: AWmQ_blpQ0OcMlCrWbn5wsAoRlcnctjr4RkBtD0LFzY37dS1vA_aR_W8k-0e0sw
Message-ID: <CADyq12xiQT+B4rUnWAgCVs1ULeJyYduOu0JVzNPuguu=5RmVpA@mail.gmail.com>
Subject: Re: [RFC PATCHv5 6/6] zram: read slot block idx under slot lock
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EC2EB80012
X-Rspamd-Server: rspam07
X-Stat-Signature: cusgifd5m6657jry7py4zmixzcsau4ua
X-Rspam-User: 
X-HE-Tag: 1763995793-412964
X-HE-Meta: U2FsdGVkX18wh/4A+tNyE/AsWIEdm49bJt8iT29eaBWeoappD3S7wdsHHanKhUIrZkCeY2hGziMdRt0hnk587UUE3BageF7bxdNuwOfJDo59OkunUYBBUVb0BAAvbL9WtH4hMa+n5SySgwpezQYsX5kpC0dys8vOibtSUXUUFeU6OmdvSAI+ZAU09d0KvKsAdJbKzqMyHqP5ESqz3ETrT/loYhfy2zFmIl65E5OIa3E+bGkVKtWlSduzdwFSQcrca4TJ2qyDYrMYnynEFvEpIp0XTUtUmfgNFg+f4PPyhkgdyBeSWK7GFcFDDGY8nmv5U2p9B1gcYfOp5PbxDnhjvAY2eVicwi8sGkJ0m633rQRcRs7y50Hsu36leEiDUDXKVdCHYnk/boBn55wQ+YtOkOJA1bBDk2PDTHI8ZJ8/SAtjNZ4r80sdX7N+Q607G4GBALA0I98Vok6fvMjqhJC4WG6REi30c+GrJcLDzWtIoHRnbGoi+jKrn/MFnN7+vSEx6DvFQIEBc54bl9WJUA/AcEdJvF3Ss5j7GbCIGMKP7pw2D4twDJTY3eC6ofEwJc2GVfMYzIigQk7GIZW5LAtOzW0jPYtPJeK/nfWLFDYS2wVua1pnFjw8PmOIrFBrUCw4jIWmGiFvsCYl4Q5+8/GZtvbjsXDWEFKpEpEhD8g/Jrwjw8JJ1dq417+JXmJrFdSoENJTieKYI5hmTXjPn/p90bc5zeM4ez8ZtMg6LlkUXDXgRapLvZfEu5OVd7LJtFJjElsIMoFD1Mj03wWxqer95Wditam9ztaUWI1zyOKW1R0mJONGGFYvw1a0fCnOJ0VPGGd6Kz6QtDsqmvbAAe9AzAJu2taIUZxrTID28Q7p49yrtekUqnA5IwOtK3mMQNCKF1xgoUni01RIDUmuWQ2+wCcPeRb5g1AqrYeBXrksH/w3/32rmZA4e0p4izowSh/ZECCMB/CabiEtu+CoUZ9
 2GJxeJ6N
 uzotwcKyM+vD9KKQP1YDHQRaWXRjthgxVarMQqcbRRFicnHf8/VTZTr/gPf8LHA51bZ8649qi2Q92XTpzMUk7aPmShYQriWh6bFL2cBZHcMS01YJ0CFVmFOzTiiK5gzuv9nojI2CIZSsJ1rPS5wx7w/eqbVyOT/1BcLMuyn2/rtHdk3GnQvnV6yxe98LnNuKjRSFosPlaSn9gUB2MYhXDU81ni4rl2vSrkHZ8GR94vQlPEfo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025 at 10:22=E2=80=AFAM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Read slot's block id under slot-lock.  We release the
> slot-lock for bdev read so, technically, slot still can
> get freed in the meantime, but at least we will read
> bdev block (page) that holds previous know slot data,
> not from slot->handle bdev block, which can be anything
> at that point.
>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

After taking another look I think this is a worthwhile improvement.

Reviewed-by: Brian Geffon <bgeffon@google.com>

> ---
>  drivers/block/zram/zram_drv.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.=
c
> index ecbd9b25dfed..1f2867cd587e 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -1994,14 +1994,14 @@ static int zram_read_page(struct zram *zram, stru=
ct page *page, u32 index,
>                 ret =3D zram_read_from_zspool(zram, page, index);
>                 zram_slot_unlock(zram, index);
>         } else {
> +               unsigned long blk_idx =3D zram_get_handle(zram, index);
> +
>                 /*
>                  * The slot should be unlocked before reading from the ba=
cking
>                  * device.
>                  */
>                 zram_slot_unlock(zram, index);
> -
> -               ret =3D read_from_bdev(zram, page, zram_get_handle(zram, =
index),
> -                                    parent);
> +               ret =3D read_from_bdev(zram, page, blk_idx, parent);
>         }
>
>         /* Should NEVER happen. Return bio error if it does. */
> --
> 2.52.0.rc1.455.g30608eb744-goog
>

