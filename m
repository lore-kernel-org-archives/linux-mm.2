Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12694C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:57:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ADF16B00BD; Wed, 22 Jul 2026 12:57:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1854F6B00BE; Wed, 22 Jul 2026 12:57:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FFB6B00BF; Wed, 22 Jul 2026 12:57:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCE1E6B00BD
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:57:49 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74C0F140253
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:57:49 +0000 (UTC)
X-FDA: 85017019458.20.1EB0248
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8E59240004
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:57:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3JrSeJv;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784739467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LPcOdVZMMcgm6b/T5m22MfHqQlIHIR7KE5HKHozKnrE=;
	b=ydn/003uK6IalevAoJItFSlP/ztPuVulDdw8KF9KOAbIzl/Yh5rvtm9bvFCtAVTiQEDoIA
	JgK/dD8pP2OSJLBkexmt5/NZjiA6DlGOadKIA3oqh4GsnzpUd+JfT/X7vHXVyDvc4TsL7x
	4SPNTocCKMEooAwSr2lZXmBraap9uoQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784739467;
	b=Bbqe5VD2lj3XW1D+Ozdr3y+kaGw1OTJgw220ujXzODk5UCZA4HMyQu5NyzCjx/Bt4sA32v
	oSH37wo6RCFptJDZpPOyoi75pbiQyX8dF6fPTxEz35sGbYlrB4wQA8151BSqLCfeGfxHVq
	ZCwCwtFzqKSgcY1HNjNtQySixIXH9gQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m3JrSeJv;
	spf=pass (imf17.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A16BC43F42
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8545A1F00AC4
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784739466;
	bh=LPcOdVZMMcgm6b/T5m22MfHqQlIHIR7KE5HKHozKnrE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=m3JrSeJvvdk8Fm0c9Bts9j6plhi1hxFMHFAWKUI9fog81r6tnrufpwpRHW91Tyu3n
	 neIp6ut7S8hK6DkHU9cS7uqqWIKX0dhGW/U2YDL7IvcAYPk++GVmM8Ywd6kQD020nU
	 8Kv62SQhHcbi22QEK0uem5TFwpHC1yamO58EVQTkg6l1Nsq3DYDb7GTUkBJoi7Qb+/
	 wCXimisEeffKUZqoNEz8os5MA5MdfJmF/7e4q3Ou19NJxs3T/4YpTGO4ICJfjPJGWc
	 mPZFvK/uYk6vfgekY28H3t6jmnyiAIFM89stl/CXomJDEW/PMtKZu6yPwPv/QyiHFe
	 d9nLTgKstq9uA==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-80cebd41372so117970117b3.3
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:57:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rql3iBAyo1zeDyRb78LI8wDv1dWzMlfRRXTPxGFVY70/QUK6xly9w86+yg+7AMJ9a5K0/XPeUbC0w==@kvack.org
X-Gm-Message-State: AOJu0YyzMuLiFtuHLij48s18/r7hnCNciyyiDpZJcQpH2MYMsbVxkseK
	R4jkgE/eeG3n/nGGvE6s0PU4Tr7R0Qf5PCMxry4lHBDfBg/JRE8dj0GRsbKXtfY8inCEMRBO3GP
	/LfhvmmV+3tJPRD3ilQ/bE1HCjZus7rIxtqSgeDU8yA==
X-Received: by 2002:a05:690c:e3e4:b0:80e:1ad2:afc3 with SMTP id
 00721157ae682-81ef22ef457mr71652027b3.15.1784739464993; Wed, 22 Jul 2026
 09:57:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260722130615.3163560-1-hch@lst.de> <20260722130615.3163560-2-hch@lst.de>
In-Reply-To: <20260722130615.3163560-2-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 22 Jul 2026 09:57:34 -0700
X-Gmail-Original-Message-ID: <CACePvbWpxJ-5kzvkFwNRcpxqxsKNowsKkWLC6BtzuabyNZv4oA@mail.gmail.com>
X-Gm-Features: AUfX_mxaUX8OlbXL4sZ1zJoB_AVHbNO17lVhNRIYu9y_lmljMjecn4zlQmCtqew
Message-ID: <CACePvbWpxJ-5kzvkFwNRcpxqxsKNowsKkWLC6BtzuabyNZv4oA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm/swap: revert to single-folio writes for
 synchronous swap devices
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, usama.arif@linux.dev, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, ryncsn@gmail.com, trondmy@kernel.org, anna@kernel.org, 
	sfrench@samba.org, linux-mm@kvack.org, linux-cifs@vger.kernel.org, 
	linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 8E59240004
X-Stat-Signature: jkmwht7q1e4ga3xoadrukk6ppzr4o39c
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784739467-985327
X-HE-Meta: U2FsdGVkX18M2f9l5L6JTTNlShUgnuhv5QVVhWqrXYmdV24NiFZRvTvPhINQ6Pf8+EX5KTkIhXCyad5/9OrzyCFcOMAiHrE/wSpZMa+jU4s8Tzr2EPRK1qTxT+ANuoNP5wQhWlyJ53uDr5pUUR/BoBlyYjXTNpskfPZKNaWLQ4YUtNVX1WNamMQSfNUln7oIJSju5zG61dt3TCQtrkeHJ5jdk6H3+hvsfX5tX6tPn6W/H9JKzI+6bNQizi4upyVXrvehufUfbhkV58R3wWzSqc6XMEpDGqsKSLRfs4IzkQ5OzuP/MTRcuG3uV42QTTEkFgvQwAcBk/NvY1kLh/B1/ZmFAnQ9jn4/KSzJ1J4BjS3XZoLAZ7g5FekmVjkUWcNKkfe8fOV2nVoh7/l3WRpi7p9XsygWRhwhwGq3G7UIAUoMPWigcz0P3Yosla0P551rB2ShOC+2dXl98ji3MVM7BV8GJo3gDkP2DdJZ2GutNRCwcnBOtn9b320yUdSQp3JNbg6sd5IXCW/VClcIFB0ZW92s5HN3SQX7Nwyl4OTFLRK0r7brTcFDeLBXmMgYSnP8HCIKHXsYxSxGhk7RWpCnsYFGFZfIRh1e/kMsjCbpSD5vqTKNUiBx2FHU9WvU1CPN+BP16lwJsTmfXymsTtlu+BCCDAxKHIMxwuafAKTIcykn9ytyt0tM0P6HjLvvG2axEfbVnxNt7hVcOMr1P8EwMve12U7KJnprYPHds3mZ8HefSLbbFRIaGmSlsVcDAsRpS1k59q6EezNTErNVFGx4Z9nESMN5VjqDgWkPNhzP0MvXSkX5vE6c7vVQEgclzG2IcYXGicjNGPPtY684+6L/KdUblM81bzCfsrNtrVhSNbdwS/wO8bW8z+lSVRqcK/mLpifW1HhXLxHD2R9UUuQcvLh0l4BQKd01IzHarjdmS2rAACE4fLvhyOAFnFl3ge23GxugPkGs4fgwl7+xQcE
 J4fMEHCB
 +R9YQMSEzXcGE3ic79BFdkzJa1C6RzUABrAahFwsTSiukv32A9mPnGsVAdeZn5q8Kj+hBDN2mfGcX6JUJij+w/YI2MHaT3chdmxTCtmykKbEocPET80S8WskdFqsxZX6xguMsx71PRRy5oSjc4DkiWou/e7xxm44TijATx1/kCSxMD9Crf/EviAA27NFuZ0KgVZM8kt5bFDauYwh/aB1EyQAsFPKK/xyX2n7znAG5oLwebGFiC8xiPlIbzR6DoMKUSnDeoakk9YoM1CR32SG3EUGsBY/4v1CCfkcGfceXJaX0p1t+Ad/kI0Gatw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 6:06=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Kairui Song reported that zram benefits from submitting each folio
> directly instead of batching up I/O because the classic LRU scanning
> benefits from clearing the folio writeback bit in the scan loop.
>
> Accommodate that by kicking off reads for synchronous devices for
> each iteration.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  mm/page_io.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index e4fa7ffffe8b..c984a4023a65 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -358,7 +358,16 @@ static void swap_add_folio(struct swap_io_ctx *ctx, =
struct folio *folio, int rw)
>         }
>         bvec_set_folio(&sio->bvecs[sio->nr_bvecs], folio, folio_size(foli=
o), 0);
>         sio->len +=3D folio_size(folio);
> -       if (++sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs)) {
> +
> +       /*
> +        * Write out the iocb if we filled it, or if the device is synchr=
onous.
> +        *
> +        * The latter is to work around expectations in the classic LRU c=
ode
> +        * which make synchronous clearing of the folio writeback flag in=
 the
> +        * reclaim path beneficial.
> +        */
> +       if (++sio->nr_bvecs =3D=3D ARRAY_SIZE(sio->bvecs) ||
> +           (rw =3D=3D WRITE && (sis->flags & SWP_SYNCHRONOUS_IO))) {
>                 if (rw =3D=3D WRITE)
>                         swap_write_submit(ctx);
>                 else
> --
> 2.53.0
>

