Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0207CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:54:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EF2B6B0005; Tue, 12 May 2026 13:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19FD16B008A; Tue, 12 May 2026 13:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EC56B008C; Tue, 12 May 2026 13:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBA8A6B0005
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:54:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95B16A0571
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:54:09 +0000 (UTC)
X-FDA: 84759516618.18.3A96F04
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9227940013
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:54:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZUbNyuDr;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778608447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMaXuhWRWhgrqoOLYn83vyBzMT43hl1SA7PSJp2Ir5M=;
	b=KYGAPYUEX+QSA8IwwPdUnXzO4oaCLJJE8uU7z7xaPB9qUA4MJNNdp8g7lR1Z64MHMAbQED
	FnTH9kovafnhMROJBAKTm+kTDGbTDXx5YYuBJOt5fnulMCsyNxUN5Uw1ir3GEkcjK//Dsy
	4Awj6s6myAhlafBZ2r4XIUEZQKu7Z20=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZUbNyuDr;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778608447; a=rsa-sha256;
	cv=pass;
	b=OCZez79yW4EfBSkwvL6G2laoYi9DxbMH/s2b2oSUjein2kNxlcCheffVS782nHSqMQaeiQ
	gqZLCZGqbjOR3gIqSFwlD09kPslRotsZ7266KlkgfUFNkEhhXVldIGgYd/PgbKzvJI7KsS
	/WvH3VdHIJLt998DG6X58IZKwByVak8=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67b8d9c26bbso10458223a12.2
        for <linux-mm@kvack.org>; Tue, 12 May 2026 10:54:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778608446; cv=none;
        d=google.com; s=arc-20240605;
        b=K/aQdAISnIvW7vyYWckue23dzs///V4yrcHYLP734RMEd0L+U4v4NAwfiWojIBvZBA
         LJ80/ZT+fkG0yZjKiBxUuW/A3FGLk1crvHIkClLZInUlBG9aqZ+d1ZLq8FJ9txYAmCxI
         xH9x/556YcNxMB5xHt+HJ5GkuQQa23GX8sHqWDdHcvaHmgeYzTDU2eOUNCM6d/rnS498
         ULm8L59BPl8VTP30srIoO5fhOJX726ywsLU00CgRMTdmA7XCWSpI5+UoSgeGkbxYEwiR
         KnF8Z6o0vl1G8ZzCWWBtgAe5lUOavYdGMa+IpVO+Hz1eew/By7jYna1kvCt0UH2erCy+
         jgyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZMaXuhWRWhgrqoOLYn83vyBzMT43hl1SA7PSJp2Ir5M=;
        fh=wtYRkXwhuUYih6j8Crb+Oir25Y5zdXng6A3p5RFNE2Q=;
        b=Rf3onq9vpyBDkZOq/A1xY1xGRGEilsMo3Po8pMd7jgPCvuI4zHpbIAbxXck2ig0z5U
         3pNzwOoDP20xYxpAiDfAvOg4Sb6uvJ4LlR57YJoty+SwrfdMgUM4D1TKM6cwWUZShx1a
         Idg5RvVIEe3hYThQ/UVhs/udV9MNvl/viuARhEAZwD6cKP0IP0qAKz+vWF5B6bYygmRO
         h+BnMmNRZ8bOpwr0s66WiRqiKdsexlMP7SB80sbgd0KZW6mNAUdmDKBfJj/+c3N51d+X
         jgwiVgO5lNx8E34/WO8Z690IDhNfnFD/mNrfspqHm6ZwWvvor41vx2B8XZWIxpNd7ydo
         21Iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778608446; x=1779213246; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZMaXuhWRWhgrqoOLYn83vyBzMT43hl1SA7PSJp2Ir5M=;
        b=ZUbNyuDri6hMDlU7jc0BNGbLwWuX7WBp5AIIV5ueHCgXacnvKj+giYe/23ZkpGugES
         QtmvUAoRIOCwMtMtQ/kfCkHZnZpiScd2hAdtyPEFkZtbpS2AILWC0zlDHFwlcHjFVdTi
         RA13g8Vn4/QBMQiJerLPghEVhuSGWg609Oj8YV5d6iPPQ6rNh9jK6DwTA+PxwAmBtH+1
         br6BlVVLkbvaqWxttB5phrsZME5HSA3Bo4/UDU/ykrBXdVDCD220iaoLW5NQ+qnMbkQo
         H577yJ/FYytY/LpblTfazHS7rHPVv7x8jJ60Qbk0+YhHg2owgsANzbofT77zC71vTZm9
         xX0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778608446; x=1779213246;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZMaXuhWRWhgrqoOLYn83vyBzMT43hl1SA7PSJp2Ir5M=;
        b=GhdgCAiXc/EV6fGq2B/ASM7huT4LB1A9AYXcyMdAzXgzDLw3hoiR+ZcPkLD1SR4oQx
         lEzqQCmtPf0nIZ0kvKzeKuxtqLQ2AZZKOXmKdQW81g3GQQ7khQaoy4rCR/IlROpV6Kew
         YduwnXtortfDbkMU7QOUZZnUeHM2SuioOjyCsLVm7F39COlFbxSz5EYdQj0FjKVMrcxu
         fhdp0oaeSn3FKnAU04EH1RCRoUQUwiHx1ZaFh4PNMGfpgBsW4YRNR2Z/AlFBG70mu+Gn
         uZX3XyoSBmvuB17fog87AHOgixUoBc2StGiSB5SUAx9GoCwJ9RBH7ikRH5x3EejPSceO
         yxxg==
X-Gm-Message-State: AOJu0YzdjKJGN4cAWw1I6UJDVcSsYXt3LpQvl6VHLlQw8P0nP9GTB1GJ
	/CmGZvTuitImd1tgYYThbBbydsrBABmc5QNhlAVxjrr1drWDpG0MKXCxOItcVBoQW8SF/ll7TPS
	GmooAacyx3UthPePdBG/AYdR7nSKqLo0=
X-Gm-Gg: Acq92OGyFsqa/K3bNz4TYp++8l9DvdjRhwfY7Nn5G2siqy5ZZx2GgN7QBt61bdeSfKP
	+CrkOnBxcUb8Ec5jnRNomCr9CEeBrZVQUHAyZzj2pogzAGn6gYgvVG1giY8Y6HXQ67RbIs8anIV
	hRvfjBHs1CiLZ19hoA59CnFUWdz52+8PvplwACcLTm5mW3U3FHz/N51IW2yECjtzGYgaJLyAGtx
	SvQh0keyb7ITIPE8AAZmqFHQmReSsyzBeP0hkERtln6vRtKGDYqB2tPWjDUixFHPjIu1LeERaMT
	kFCS6eoI/tedBBAh7axbiuYEQnrBZx64YC6NVTY0
X-Received: by 2002:a05:6402:2483:b0:67e:2624:b8ab with SMTP id
 4fb4d7f45d1cf-67e2624b90fmr13076001a12.24.1778608445732; Tue, 12 May 2026
 10:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260512104201.716213-1-baoquan.he@linux.dev> <20260512104201.716213-3-baoquan.he@linux.dev>
In-Reply-To: <20260512104201.716213-3-baoquan.he@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 13 May 2026 01:53:29 +0800
X-Gm-Features: AVHnY4KietO0uXyNbNqXj2QfV4iXQWZZ0KvAQyS5YHBqBsdNVevm3zs3dwz8mhA
Message-ID: <CAMgjq7Ap=hEmHg+5Da=NdOQS1JK1FY+WepmW=3HEC4XHfsUmuw@mail.gmail.com>
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org, 
	usama.arif@linux.dev, baohua@kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9227940013
X-Rspam-User: 
X-Stat-Signature: h6auqwk85q6amjmjwkgnwpexeh8cj357
X-HE-Tag: 1778608447-2340
X-HE-Meta: U2FsdGVkX1/vSwFjWJGQV04ZscNjqbn3PRNFc2esbCp7YAh/ubuwwTAwkxKbHEyo7kViambVZ4YyRZbCVl4G2RRhB1smqk5M95FlFPz9Aa0d4ZDmxenX2TO0Nip3A5DXuqnCNFBxCuv8QLathbcojx/G0vfwjygcEy9r3iFTYhXekO1PEDhPtC5AnnQLN3D2864C+i786tzAwP5bzqGi1ulMQeQC88axVFGrJljztnMTKdMNzSORJRhxWiN88roJyGOQYiDriLN/xEn5RwwZOI4sNpJKtZxSLN3BslQiUZNBaPVy2uolaEcBvBQ6fj5qAsiTqNVLhrxn+ODwF4Zl/n9eq44zgFdkV5NzfpqXKmvLCJgu1ZknNA9ZEt5F3KqE579L+VdnNcrhBACaQtfbzzo1zz85SwaDTRV9Rrr5Z3oezzfcKf7Mu7iLVzqV8/kbDEIbnMMeem5NfeK763iL0vzA+LO/mw9uGigGvIs5nXIaHnMu8RSSjQQL3nPfearBqG2BUhNE092J8In4keDVZK8TwnVPhzgIqbbbRdiaphqlL0c4sPLux1zM2dH+OCuNYhZysDc9Qn2qRem//3eGtpSZ1WQ/OjpcQMxTUbtj8A3+1sjRF5b+3ouPxcYkL/IRTF2QqsV1Nd0u9xcU8vSmV4UDdOqr5jxcKEejvUORKMz5WjlOXoUAgLjMfTyvyoEqVnTGfudssusLyK4owdokqq6PlWJMNdhHS+PyH0Vyo0VG/X52deNtDcm7phnaLQf9CeHbADFlteUin5+sBE3hT/P+OX51npUCkHIiYqwQXhAB2vOUg6wkOC3ruVquAehAq3YnnGyymG7hWNrUeCIMWfxsRTuWkuhCFC8GGtuneHhkQkdjKk6L1wpZgSzUogcuvPSiaFFOQhgVgYEE3hoxiZx1Yz35/B25P/ZPXHoiKjfBk8VD0OYZlefBtF9YGAkxkEvpyFHvkX1WHDYaXNl
 ZcvYB1xW
 W+tGly0iYW96DWmlmy/eczYMKT3ebRg8Xdi5MXue8og2bHLMgowfP+GEiT74JwT9MjK8XyG5OmIeEmmHkeMrI/U72BvyhUiAJO7dbReD7ONHZxMXfmXHAyRATxnuUYE7MhmvRoCVHaaiz1+BpYjvPU1jOSzRlKsXAV/sAGf7n2WXeDXZmMEJ87sWEU2Be8hH6mACjDeEEz/OB6/mScDsimvtaPxTQcXNEkbXqiqFpuHNXv9XJtbyOsFotZfoY9yUBexIcIQfwRnxJaMYYMkfiQLBArwmg2IVQRaFE3xIlNDb6oIm75q0Mc0b2P32UVjhpsx+HmJYOUHTmIfRi544yrEiC6MKDOTFKxnYXbcPLksU1JdK5/ZT87uInEhRPk1xqnITBxN07t59Lb9jBs0NzRJgZu5F1agDRBOvaRJ7F5NAznRN2bCHuYMPo32jIFsZdm5afbQ7+LoHdG63v5yl+1j9P86c1fQpV9Hw+0RVQpkkY8bRLxJZr0DuKbscbzURXGCy0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 6:50=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
>
> Currently there are three types of swap devices: bdev_fs, bdev_sync
> and bdev_async, and only operations read_folio and write_folio are
> included. In the future, there could be more swap device types added
> and more appropriate opeations adapted into swap_ops.

opeations -> operations

>
> Suggested-by: Chris Li <chrisl@kernel.org>
> Acked-by: Chris Li <chrisl@kernel.org>
> Co-developed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baoquan He <baoquan.he@linux.dev>

A few nitpicks below:

> -void __swap_writepage(struct folio *folio, struct swap_iocb **swap_plug)
> -{
> -       struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> -
> -       VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);

This sanify check is dropped and not added back in anywhere. This is
fine, but it might be better to have a similar VM_WARN_ON_FOLIO in
swap_writeout?

>  void swap_read_folio(struct folio *folio, struct swap_iocb **plug)
>  {
>         struct swap_info_struct *sis =3D __swap_entry_to_info(folio->swap=
);
> @@ -642,13 +664,7 @@ void swap_read_folio(struct folio *folio, struct swa=
p_iocb **plug)
>         /* We have to read from slower devices. Increase zswap protection=
. */
>         zswap_folio_swapin(folio);
>
> -       if (data_race(sis->flags & SWP_FS_OPS)) {
> -               swap_read_folio_fs(folio, plug);
> -       } else if (synchronous) {
> -               swap_read_folio_bdev_sync(folio, sis);
> -       } else {
> -               swap_read_folio_bdev_async(folio, sis);
> -       }
> +       sis->ops->read_folio(sis, folio, plug);
>
>  finish:
>         if (workingset) {
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4840fd40f36f..8c42632e6765 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3780,6 +3780,15 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 goto free_swap_zswap;
>         }
>
> +       /*
> +        * init_swap_ops() sets si->ops based on flags. It does not need
> +        * swapon_mutex, and must complete before enable_swap_info()
> +        * exposes the device.
> +        */
> +       error =3D init_swap_ops(si);
> +       if (error)
> +               goto bad_swap_unlock_inode;

I checked the comment above previously and it looked good. But the
error label seems not that correct after double check. inode->i_flags
will keep the S_SWAPFILE flag. Maybe something like add a
inode->i_flags &=3D ~S_SWAPFILE here and goto free_swap_zswap. Sorry I
didn't check this part carefully last time.

But fortunately, init_swap_ops will never fail at this moment so the
issue never triggers.

> +
>         mutex_lock(&swapon_mutex);
>         prio =3D DEF_SWAP_PRIO;
>         if (swap_flags & SWAP_FLAG_PREFER)
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 4b5149173b0e..192401f46de4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1054,7 +1054,7 @@ static int zswap_writeback_entry(struct zswap_entry=
 *entry,
>         folio_set_reclaim(folio);
>
>         /* start writeback */
> -       __swap_writepage(folio, NULL);
> +       si->ops->write_folio(si, folio, NULL);
>
>  out:
>         if (ret && ret !=3D -EEXIST) {
> --
> 2.52.0
>

Rest looks good to me!

