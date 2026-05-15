Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69BF9CD4F3C
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 04:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CBB06B0095; Fri, 15 May 2026 00:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C8C6B0096; Fri, 15 May 2026 00:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692F36B0098; Fri, 15 May 2026 00:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 570616B0095
	for <linux-mm@kvack.org>; Fri, 15 May 2026 00:39:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5D1E14085D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:39:38 +0000 (UTC)
X-FDA: 84768400836.10.CA6AA7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D61A42000F
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:39:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKfbVcWK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778819977; a=rsa-sha256;
	cv=none;
	b=zsiYvo7vFaudyXAPyYy459Y2Dd83YFErKbObdjSAlfGwgNsQPzUyj5kOgvtXTY1CHAbKUR
	7cqJuGKWq3LpVkzN8CjWJcIVZD5Iqw+e0lI2KofEubjNTVFLEPRaPmJbzUUsgsYUHwzx8n
	5oadArlXAT/8/h4E7DYTEo1WovCrKTY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKfbVcWK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778819977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVwPLHXIRWSy8BTyIDuOIDpLJXJ6iM69vIBmJ8q5G2I=;
	b=ToU74s87qzYWMvUMQ2N1mji3CGw3fExeFXPF5wNazuNMFul/3/gu4JP+ORL6aifQm3gAyP
	QXP0bX31zVUZ5Ty0nDAo1ento7LHr1o+T9yTRzMQiLWcoD8aKyqR7Da+hwy8xTqdIelJcs
	cZGSz0Dm0wER3RlDjCwHOd8hd61L4Ao=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 966D643DE9
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A2BC2BCB0
	for <linux-mm@kvack.org>; Fri, 15 May 2026 04:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778819975;
	bh=HEj+oMD965Qgdd7eiJR8h+HcfN3VBOagAwvGOhZab9Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mKfbVcWKAI0RhOxC1F1tKzulLjgz4Cy0GUPT9Foqu5eOyV8kuph/e9LK24p9jcaD0
	 XYVhV9AwijpnVHxllFZbTYKFGkAEvmDUuow8ZxVd7Gr5gjGv7abPKm414N1sOoiXbn
	 mZp+OBfd9teus7FpW5jEZyJNN4g56rPtGUGnif3gPsQQaEEajkoUwG9Nye9qQ7UnnJ
	 biPfZh6SKt6eCzvejzFmdi9Ya+hr/73EudoalimYWBuu8e8Nq1xl9yQb4FmSuagbGF
	 JGWz3g6RcSWip+gyJ35hSTUF2nTrYGy56dgPRUJq7uZ+cgcltO/I2Va6WYgQwGpb2x
	 DaGVwpXEcf/HA==
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-94de68feaf4so4713810241.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 21:39:35 -0700 (PDT)
X-Gm-Message-State: AOJu0YzhQPuIv2867YljCY7SiSS+SEPIusWJUMy/IsZ61FOq2pedmBn3
	94tWTNwN/p+6T5Q9QlE8z3ipJsz42QVOwQZr5SIaRfIP8VQyulZXxGWcMqmloTc3oi5BNSA617C
	q6938wt5YZUR6448tlgxSwsoLtx6dLS8=
X-Received: by 2002:a05:6102:50a9:b0:633:c6c4:b321 with SMTP id
 ada2fe7eead31-63a3ea7d313mr1124983137.18.1778819974818; Thu, 14 May 2026
 21:39:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260515015737.890994-1-baoquan.he@linux.dev> <20260515015737.890994-4-baoquan.he@linux.dev>
In-Reply-To: <20260515015737.890994-4-baoquan.he@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 15 May 2026 12:39:23 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wNtLaq1e=8YUTMtro+4oxSrue1OdpuyzyiNWt=RZC+dA@mail.gmail.com>
X-Gm-Features: AVHnY4I6kZlcNfChcgBn5nKYD8zIDP1nd9y0bSF51lCNy1O99qFM-0LJJ5d4XXU
Message-ID: <CAGsJ_4wNtLaq1e=8YUTMtro+4oxSrue1OdpuyzyiNWt=RZC+dA@mail.gmail.com>
Subject: Re: [PATCH v7 3/3] mm/swap: add unplug callback to swap_ops to fix
 leaky abstraction
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, hch@infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hzi4jn53xp3qsn75k95bxo4rjg9gpyj7
X-Rspam-User: 
X-Rspamd-Queue-Id: D61A42000F
X-Rspamd-Server: rspam07
X-HE-Tag: 1778819976-65045
X-HE-Meta: U2FsdGVkX18ztcvOu2v0WfWOr78GX8qT57SFgT3nYUrs4n6WyNIdvTjcXzR4IbL1i4Odid1rif8XOw56PLFsxuJRwrYGqD3ebY1NZ5MpGnMYDg1ocEbdP+qqNyj2kuR/5lU2LD7qJpkp47Ug8gviQN/m/y9micT3E/G2aCvpmIEzrkT7GY+znLJWONeWHxqn+ROHxvqAxHznG7CekmmkrIWEKisimyFAkiqtlQcFOD+lGBbHe54S4idFGynkwBkYlIfXwI1jmP7VMtd9s8IQtsd6DlVf8ie2hZMmpUtxSZCXyxKvg40yIBqFcgOfkJ15kmKsTPUlSbyiLhGkayRraUSgyaeQbEK106ktoD45V0HKIPK+XOhN/Fv8EWg0pWxjSfUUNwxmqkQQgoo+F952tTR8Q/Vk6BzhYbUu6nsl50X2sRqqslyRI+ZJ+5z2b68tIFtweS6Un9c0/b1gAEsIRNV+q5Pg7TVNafy6PITFqAK4f8ooBwmfXfZMN5P3kBbHUGgV0Jw7ueJCH3RQKgGdmXG70j8wxrt1qq+qYJpmz1ZGOwm0Q41LAoDTnFfYm5h1oUtU/gktCV3I/nGq987N+zzDSCMgfUgtEO+p9R+yq1FiLG7NFUEBqNf997TJbVfN2q1XtECCzsrRsEr4ckTgDPXw87Hi7fq20aczQ8CRzLg9EteObMSn/RILK3upupjy2VaqtGBDXD4nhuxDGVwMn0540wkPPtBHe34WuvV8PmA8B+JsBSf+fcl4JhNIrWdbIubbRzPXMTPiGiKuZdKK5/IW1uMnV7eXLq7qXz/1LcOzpmoTkop+BNPMJBjSWL/0+0VvujjlV9EzYzQwKaf+O78VkrskxwKDnmQ/LQCaIYWw98xNl+i6GAeeHPFp99XOa1iQqAplbNdp2hiTBZrb7b/MIk0iKQcCAy1aPF3tWLLfdmwLBGiijergimQnMTUz9Tp7Q7WfxoACj1eV9PA
 bIBz102J
 bzXotIGYk80yhzazZf+/wTZF63Dnn1y89/oqfOwjpKMEqco0qBbLTvOAkhzgj4+gNkqMZ5QKfJO57om1x06BrDHvijY4QzXCuyVu88V7DmKoiF5jVfdue0aV8nMV1GctE2jbmZ3ZA6jBBrpSKMM4uII5iYMY11i5Nt1lyiKGd4SzigvkY4E6je6aGNlse7qZKCGfevajZ0QQ6o5yhfhml3pkt41FWnEvkDy1s7DYkVd+Co1hJmeLEGDq1C/nPb4QUKAJImKuRUe8fNbmnsx0zS7DLEEVR46XpNTs4RzbAKYNgkgmBQ5ZJ6Xj78uInd983EAT4u5fPWt5dLLg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 15, 2026 at 9:58=E2=80=AFAM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> When swap_ops was introduced, the FS-swap batch submission remained
> as a standalone swap_write_unplug() that directly called
> mapping->a_ops->swap_rw(). This meant callers still had implicit
> knowledge of filesystem internals rather than going through the
> swap_ops abstraction.
>
> Fix this by adding an unplug callback to struct swap_ops.
> Each ops table provides its own implementation:
>  - bdev_fs_swap_ops uses the existing FS batch-submission logic
>  - bdev_sync/bdev_async_swap_ops leave it NULL since block-layer
>    plugging handles their I/O
>
> The swap_iocb now carries a pointer to its ops table so that
> swap_write_unplug() can dispatch through the callback without
> the caller needing to know the swap device type.
>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
> ---
>  mm/page_io.c | 11 ++++++++++-
>  mm/swap.h    |  1 +
>  2 files changed, 11 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 38b94c560c37..2c36d261ad98 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -329,6 +329,7 @@ static void bio_associate_blkg_from_page(struct bio *=
bio, struct folio *folio)
>
>  struct swap_iocb {
>         struct kiocb            iocb;
> +       const struct swap_ops   *ops;
>         struct bio_vec          bvec[SWAP_CLUSTER_MAX];
>         int                     pages;
>         int                     len;
> @@ -401,6 +402,7 @@ static void swap_fs_write_folio(struct swap_info_stru=
ct *sis,
>                 init_sync_kiocb(&sio->iocb, swap_file);
>                 sio->iocb.ki_complete =3D sio_write_complete;
>                 sio->iocb.ki_pos =3D pos;
> +               sio->ops =3D sis->ops;
>                 sio->pages =3D 0;
>                 sio->len =3D 0;
>         }
> @@ -454,7 +456,7 @@ static void swap_bdev_async_write_folio(struct swap_i=
nfo_struct *sis,
>         submit_bio(bio);
>  }
>
> -void swap_write_unplug(struct swap_iocb *sio)
> +static void swap_fs_write_folio_unplug(struct swap_iocb *sio)
>  {
>         struct iov_iter from;
>         struct address_space *mapping =3D sio->iocb.ki_filp->f_mapping;
> @@ -466,6 +468,12 @@ void swap_write_unplug(struct swap_iocb *sio)
>                 sio_write_complete(&sio->iocb, ret);
>  }
>
> +void swap_write_unplug(struct swap_iocb *sio)
> +{
> +       if (sio->ops && sio->ops->unplug)
> +               sio->ops->unplug(sio);
> +}
> +

Hi Baoquan,

we have already "sis->ops" check in init_swap_ops, do we need !sis->ops
again?

+int init_swap_ops(struct swap_info_struct *sis)
+{
+ ...
+
+ if (!sis->ops || !sis->ops->read_folio || !sis->ops->write_folio)
+ return -EINVAL;
+
+ return 0;
+}

