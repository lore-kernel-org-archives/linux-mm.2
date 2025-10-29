Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93FB0CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 13:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71D3C8E006B; Wed, 29 Oct 2025 09:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4E08E0045; Wed, 29 Oct 2025 09:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A828E006B; Wed, 29 Oct 2025 09:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4763C8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 09:31:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C61B15B9CC
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:31:20 +0000 (UTC)
X-FDA: 84051238320.09.5E5BE64
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B1A3620004
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:31:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k/YUzPJY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761744678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WDUG/s4EjZYeVdQIE1yVjRVbkn/7pxO/ptoAc6ox15o=;
	b=G47aQ5I+oKGVRnfSCKy9n7RK3ulGYdK+8o22XgqJcAlvFIgc7pAMgAxHVi70btY+v/VxSN
	IrxpjEPaz5satLsEPM6hVSiOavS9IcJPsEOS/Z5PWrAN2obCMoyWcWqJrDOHD1CGqrqBZP
	blcEgiuUvL8e6gIFrS1ss614JEN0IQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761744678; a=rsa-sha256;
	cv=none;
	b=rUdOiLVeRdyzHlQ/QnPYNez/ippXlQaI4uoL8Mk9pnos6rKuNvoRsN1i8gmnD/Sa7H3CEz
	yuImOvhOZjNK2k2zR2sly5392KJcg42hqRNNWFv1EPpTG+Fydr8dirb/GuL0SkqL9h9FLT
	iGufnEJ4SlbAYXcRX+0iHI3VB8CZbOQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="k/YUzPJY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of rafael@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rafael@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8992E49BEE
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:31:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66137C4AF0B
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 13:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761744677;
	bh=H4STyYQkAuprklyTlY2BjwuSs1iXn17miHrAUSvF+TM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=k/YUzPJYNKtOchZEqmQ2MNC4VR8TnxopP0fpnEkTWlWsfz9tx8ThePcktS069B0t4
	 fmcgrYYMrzyXGrbyzar22eouO9Ja3+s8CSZZsdNrDEGINsJysImL8I38EzDlt8mQKs
	 kGJvCzZje3ZdtNXHUnKVBnXd5esJ+BfuAnzsuRoVkCrsxJMkJ9vqHst9Fve9f9trsm
	 oLr8pwHCar8rp567vTcxlFJjsQN5QzBt06MZnNFU9uUOzjlAMY3qQrwDt5YhIfog7b
	 eMvlTyVyC/KzAFBM5H6gHZS6w+lQLG56w53bfIXPd1o3RWZ29qIKSBnB/2IzmVVhRk
	 uFejWm6Tr2+xQ==
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c5338b1d10so2915465a34.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 06:31:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVeh2M8z/YhQY3IHE2J1lDEiOeaTqXTo9X260NUKo11qS+tUZnjaFX+G3R6RvwdERgfnpJBJae87A==@kvack.org
X-Gm-Message-State: AOJu0Yx0TtNm9YTKArEeTpjTWmuRB8M8roOdSC5VqY1DpP8RTQZxQ4t3
	ta8T3ZD9EuDN39eoiFWtIO/2KZlJzC2jycl/bKhbkoJjyxId1Hc3P0pJow3xix5gY1T8Azxq8/3
	jigKPAoRIS262fL0NufpXgZSjz/XyvGs=
X-Google-Smtp-Source: AGHT+IEi0R7W8u+k9kuQ+Q/TOuonlY+thu2InbF4UTFVllbZ//+bkXdFiNu5AHmFd0ihQtxuffxUIcoyOHNos6JMUKo=
X-Received: by 2002:a05:6830:82e9:b0:7c5:3afb:79db with SMTP id
 46e09a7af769-7c6831898admr1590559a34.35.1761744676587; Wed, 29 Oct 2025
 06:31:16 -0700 (PDT)
MIME-Version: 1.0
References: <20251023112920.133897-1-safinaskar@gmail.com> <4cd2d217-f97d-4923-b852-4f8746456704@mazyland.cz>
 <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com>
In-Reply-To: <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com>
From: "Rafael J. Wysocki" <rafael@kernel.org>
Date: Wed, 29 Oct 2025 14:31:05 +0100
X-Gmail-Original-Message-ID: <CAJZ5v0gcEjZPVtKrysS=ek7kHpH3afinwY-apKm3Yd4PmKDHdA@mail.gmail.com>
X-Gm-Features: AWmQ_bnfFqqg5xNQkg3Ut6H7tX7EttVRgAcRKjLdiyhAs_brzIkV0t-kTKujKfc
Message-ID: <CAJZ5v0gcEjZPVtKrysS=ek7kHpH3afinwY-apKm3Yd4PmKDHdA@mail.gmail.com>
Subject: Re: [PATCH] pm-hibernate: flush block device cache when hibernating
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Askar Safin <safinaskar@gmail.com>, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-lvm@lists.linux.dev, lvm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, DellClientKernel <Dell.Client.Kernel@dell.com>, 
	dm-devel@lists.linux.dev, linux-btrfs@vger.kernel.org, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <ryncsn@gmail.com>, Pavel Machek <pavel@ucw.cz>, 
	=?UTF-8?Q?Rodolfo_Garc=C3=ADa_Pe=C3=B1as?= <kix@kix.es>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Eric Biggers <ebiggers@kernel.org>, 
	Lennart Poettering <mzxreary@0pointer.de>, Christian Brauner <brauner@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Milan Broz <milan@mazyland.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: fpdfxxoowu5xk7ehcxh7hfxhbeqcofrh
X-Rspam-User: 
X-Rspamd-Queue-Id: B1A3620004
X-HE-Tag: 1761744678-179181
X-HE-Meta: U2FsdGVkX1+eRyINbu3fsSv/AIFUGpNh9SKNfhtlcCbREB0vifdKT/99Sx1Bj5jGZ8SXY/UAX5JhCJ9/6AcB3SeNwXf5FD8whL9Pnlmn2fgVIrF+pmg4kJ64RdDJpZpLX85cRUZwKc2X79NY6TJznrRxqegOpQWu3ftbl4IAf9UMSYq7Yoyj6fIATPPebGQG4TiFNGEf3ITh975ETnfO/tZm9d6u3Wf2tKbIo5hYWGG6Z5IIuHfY9UqySUAZliYekahcKE5C+L8xa+mlIKMBIgYpajfUsFqtTFTW1iYcLzEnd24iKUEjY4JaWZSyFIuVdAJ//pS/Qx3bLnTfqg6EG4+E7VYrlWIkmbfLdzEVKafh2/+mZwwOoejTmYu0PG0IBxN3bcvpRdIrvvRKj7ate8mt/Sh685y/6/EzwrjhvXAQAeTKgttI61SNbF7Gawd/Q0SQA3vo5Z3RhO9dkABZBwhIMTUCA67NxNkzFXxAYgUz23fPltSU5PuT3Ll2T1pcI202mwJd8QXCEk0csusIqaibZM+d7GJb/oNSfBbDDY/Xl3+JmCV73CSKScQERtQWQhh0ulY+RAdGxMBrkja30NW7vcas7lusazSDp+qi626lV/i3BGkqpRJbFtpBmq7jCWC41LiPb+wJYLrBqmUS+mgq9U1FNXlAlOZbfwP3pDXKG9wMVtNaYsTl7MgkBDxzEb9zMZC3MEwlDCQ7Zk6TxOl3Kg88s9rF950SJ73htWI0ynj7tHbtXq261HVi9RGmkN/c2hC/Sx1d//wRbvh5MR45fs9FF4sbcK0ohf0RLuOtsfZNT+CSfGsK4QJGLcb9hEtrwL+xD7kAuaW+I1sNDyoe8vgXip1gr0q4tVwJjMBeomsRo8enkJToaM1/x3/861rJf7eW2NGPuzV0kQ42HTy2t993oXG/dRkmi650rLsR92uuuiCxQEsLdGVPvG/dB+MWkMIckPCTYlABdty
 LVjbx9Zp
 NiGrFqk68Bqix6/PAxLFv9nrUgZzN8ViJxmgh2/wBED1eLS8Pj8FrGZAgbDxsjkatk0JOPCsrSqmk3p9wmY4NlQn67y5VYKXOPB/OjWDz3FHhLjJkp8i8vfOTIZd+aYLQLIOpLLc9yXu8UzRHpP6T63NGxA1e4/M/eQA2GKtUI9ZJWoP9nWXhl/aJfQKyXkEi0R+YALuLBUebHlckK5d4REXrjhYeJCA8aL0Zivo0nqWfY7OMyRFlbYo0vj0OJ7P3pvuYsaQP6P47sNG+tUP8JtPo065T6b1/b6x+yUfY6453yeLJ397a9yyfxiOHINaaiiGc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 12:23=E2=80=AFPM Mikulas Patocka <mpatocka@redhat.c=
om> wrote:
>
>
>
> On Fri, 24 Oct 2025, Askar Safin wrote:
>
> > Hi.
> >
> > Hibernate to swap located on dm-integrity doesn't work.
> > Let me first describe why I need this, then I will describe a bug with =
steps
> > to reproduce
> > (and some speculation on cause of the bug).
>
> Hi
>
> Does this patch fix it?
>
> Mikulas
>
>
> From: Mikulas Patocka <mpatocka@redhat.com>
>
> There was reported failure that hibernation doesn't work with
> dm-integrity. The reason for the failure is that the hibernation code
> doesn't issue the FLUSH bio - the data still sits in the dm-integrity
> cache and they are lost when poweroff happens.
>
> This commit fixes the suspend code so that it issues flushes before
> writing the header and after writing the header.

Hmm, shouldn't it flush every time it does a sync write, and not just
in these two cases?

>
> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> Reported-by: Askar Safin <safinaskar@gmail.com>
> Link: https://lore.kernel.org/dm-devel/a48a37e3-2c22-44fb-97a4-0e57dc2042=
1a@gmail.com/T/
> Cc: stable@vger.kernel.org
>
> ---
>  kernel/power/swap.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> Index: linux-2.6/kernel/power/swap.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/kernel/power/swap.c  2025-10-13 21:42:48.000000000 +02=
00
> +++ linux-2.6/kernel/power/swap.c       2025-10-24 12:01:32.000000000 +02=
00
> @@ -320,8 +320,10 @@ static int mark_swapfiles(struct swap_ma
>                 swsusp_header->flags =3D flags;
>                 if (flags & SF_CRC32_MODE)
>                         swsusp_header->crc32 =3D handle->crc32;
> -               error =3D hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC,
> +               error =3D hib_submit_io_sync(REQ_OP_WRITE | REQ_SYNC | RE=
Q_PREFLUSH,
>                                       swsusp_resume_block, swsusp_header)=
;
> +               if (!error)
> +                       error =3D blkdev_issue_flush(file_bdev(hib_resume=
_bdev_file));
>         } else {
>                 pr_err("Swap header not found!\n");
>                 error =3D -ENODEV;
>

