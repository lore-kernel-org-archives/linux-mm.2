Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D1BCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:38:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471F76B0088; Mon, 11 May 2026 04:38:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC386B008A; Mon, 11 May 2026 04:38:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C4026B008C; Mon, 11 May 2026 04:38:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16B466B0088
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:38:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A53938D7AA
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:38:38 +0000 (UTC)
X-FDA: 84754487916.23.2C45975
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	by imf24.hostedemail.com (Postfix) with ESMTP id 76C27180005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:38:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZelYcpQD;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778488716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d6RPdBgm4gSs1t8MNW0p4MiMSn+QNX7lI73DDdGcAWs=;
	b=IHs+9VtEkhL9ZpIw7evtTblkqILbVjYvikh1xvFegE1zj6FHkS4LiPpGiGSORDZj3uDWcs
	6tW+beY8WWAb5UOYfIOxIS917sXOcmyDt4ig4ZGIVpzZZHVbHJFTUyPFd+jgOWSs2cU4SQ
	lJYC0Tc5yBozDOqHUNdD5PvEhO4BztM=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZelYcpQD;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778488716; a=rsa-sha256;
	cv=pass;
	b=GZKVNi8JPpt62dejOZ/kxdh5Gw1tNY00DrvRXT4MJc0i2OpTJenyyYqzft5Ch5pVI6RZS0
	KhvWDicZHc7bdwyF0zgnCJd7ClSYOhB3095HXqJgsjIyoDRC4BMftUvaEiKGkF+eBp2l7K
	cNrg9C5qtcxL/pYpeIndRbWn4/Rza5w=
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-676a89de629so6519119a12.1
        for <linux-mm@kvack.org>; Mon, 11 May 2026 01:38:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778488715; cv=none;
        d=google.com; s=arc-20240605;
        b=KIRkalco/b1coYDqIOcbW0idvJIWlXu4isG8jgtyIMeitMWBdkSy3zdfqD0MFc4zBE
         IY2fATOZ8XiE+iWOAMLIBYhsXqGoZjIkvNL/3MXNwHFQkctpCZmGEkcstS3RXDwQrjeQ
         WB7p8QhZJf1l1yaEMMs4m1R10EaHCKtdrVx1htkcdBl62TUwuCrxHmESImwb31xQnWdF
         ODxClAy4jz+gwXy7IFwhj3+YB9Vt9y5FriXhAEfgVkxvxo4YB2jFgenFOfkYCsGV+FTJ
         ZsJGpqM80hQu66RNmyEqBnd50B6+5xiz+r+hgsQHxvhqfuMdqBxPDoAQnALNJBfektV7
         bDpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d6RPdBgm4gSs1t8MNW0p4MiMSn+QNX7lI73DDdGcAWs=;
        fh=YETrPt8XR3oHlUlnSXkPtCN072oz0e9BDfXU7IGYq1U=;
        b=lnzgENJkGexSjNXZEXab9IIW1F9U+J7PyQhJgKAY5LrZZVvXkEVlsPDXhJLq+l5uf3
         zVex72rYo4BFT+hwzk1bVwFF70uzl0rymqZRXekXZO3m9nEQwIrpgMWwcCYmu/AzjaeT
         iOdSUOnKL88xv40ZiSnyIQs3OT0sdNGrHzzQ9eoWlMEX3S3pMrGLcy4tgSl4Vl4ed23O
         f8IDO49wOCb3c6OrxaAi2FrKQe6306EAbXULVjIo+I7SwZ4T7zs+6uya3Co/JL45Wr3S
         Fzf3cyRjvKgQ6iZWGMCYhik+B+NW6qxJyrSzOO+wJDlqNy0vfg3jdUYecvpXnBUWSExY
         6ibA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778488715; x=1779093515; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d6RPdBgm4gSs1t8MNW0p4MiMSn+QNX7lI73DDdGcAWs=;
        b=ZelYcpQDMIzJWNT10mRB2M9wZ4V+lL5UZhJKzKLhe6MxDY3m26we3wmq9T1+Xv9y8K
         XXqr7UKq4Yn2ZOOZ7rHj6YKCofpvwhNRApdLAGpg30REO26nznXKSLIYIKS4PrAhrbwr
         lFng82zq/+829s+Qo1ffxadd4Tbxinjp/LoFCYNnF0fjdMZzP+YhoymuVsyjun57LSiH
         6dekaWfpemzU0PnwHGqRipbTwdSzLEPuN9djtSVwwCNjkAzaRbyzEJpI4qFRTn1jS6rX
         uxV5MCh36Sjc+MSjedSyS/aoIFBvwv5rg/bw978VUWz4Yvpu6sLQx+LNOxGGv9A0OCiG
         r50w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778488715; x=1779093515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d6RPdBgm4gSs1t8MNW0p4MiMSn+QNX7lI73DDdGcAWs=;
        b=aXpuEriViWN9NSvZh/BK6ZlKT2yaIea9LTlVnxnvsVp2o3BLeYFQBa5fYbM2v1+vcN
         sfnZAfZibPQkpXGegqWAfnslgWilFrD7TBnxjcfSRgyuGWpKN19y2CR/EwP/tGBpRrwy
         Ei1KhUZ3GZMB9OlpqwljCbyobvJuAf+0QtydSS1LZ0u8Qlis4QWrr73rF7v2qMIUSAd2
         BdMzqGLJJmniwPr4bPcxmSs1v0Vb0hgCPMWxH7UHTi2Q754oeZQslUea/Ft6lhUbJtYR
         wG+ySMQlIaos193pvgo1Tt/F9PxzIHnSZQmSXOwWP0RMcB0fOSsXa3uVTzPR0NOF4ALw
         Ih3A==
X-Gm-Message-State: AOJu0Yy4gdvCXW2FMYmPrZmPDNHNpITPcAmuLuwDvtZBZY2o2Jhcx5pZ
	oP8tOX6BEusbKrzYvQMx0gQ7+JiR3Jm7uDHX5B/ja0qVlQmPDgpWCwaCGoNAVwPN8VcA98WzzE4
	AEBZudlN/RMVnnI9uJehulbNKQNfK130=
X-Gm-Gg: Acq92OEMJaaALhZ9AvwlxjYcpikD1MY7rt+JFVhPINTSy4uxu4y1PH0oF721lflJAtP
	LvV08eUuv14DQ7RXpDDFUot4Gc8/fsrOFHn+OJis72GEUlc2mkTi3YNKFMFWXkDLjiz/fDTL54f
	mF9KySruwlNMcIgTe99e0+4a1K7gj/QXYVQfjeNkJASOjWKITZaJrsj3QJtCJ9QI/Bf9bNkBYFe
	pK8aoa3Zn5suq5ps3ymNM2u1bR1pR1hxmi1UiEDFMWAQFyjKDdzFjyEuk86uaOlMD+iWsb7zkmh
	PeBbf3xMj0JMAQB3JVbu/Kz0E76t23ClYwaErtsL
X-Received: by 2002:a05:6402:518c:b0:66f:93cb:a277 with SMTP id
 4fb4d7f45d1cf-67d642b9559mr11849588a12.14.1778488714531; Mon, 11 May 2026
 01:38:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260511073334.635682-1-baoquan.he@linux.dev> <20260511073334.635682-3-baoquan.he@linux.dev>
In-Reply-To: <20260511073334.635682-3-baoquan.he@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 11 May 2026 16:37:56 +0800
X-Gm-Features: AVHnY4KB97R2zNUviawiAlxM0wS7FtFsLpfm1WxARQWcOpm9tcyD4qywPUhbB7I
Message-ID: <CAMgjq7Bts08uH8Bvnhx-dbJiwPtRvXov3q-d5VtmJyEQOXqVcw@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm/swap: use swap_ops to register swap device's methods
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, usama.arif@linux.dev, 
	chrisl@kernel.org, baohua@kernel.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, youngjun.park@lge.com, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 76C27180005
X-Stat-Signature: oqisfrbybft1o4djfr51qqo7pusbs4kz
X-HE-Tag: 1778488716-959089
X-HE-Meta: U2FsdGVkX1+TZcaYrveUrhMjrJT2R4Cyz2kRq8v2856+TD2eGsv8oh5EOw5zIkKYhERYmeNHi72/8IfgrQ3dyeNauk6xWNGNLkDH5M7mKL2wD6V0JSJJI2x9ICFZXA8wc9jvhNVft/rX/9RE+dB8NYjxcKeuVUjOsql7rpUBlhtUaRjapkAZ1E8QBl6PXtA75kUDgeTW8F1Xp4X0Tty+0pUVum0l+FBla1YnyxjGSrt6K0Xl/4r+QgpWLDQsu/ZAnGtVERfkz1yTjIsp5o5fPok78eW36DTgtiied6ahonMSTdfdb0nde5q1/YfhcqL44uq8Ux5WHaZJdrHkd0aXWZmuShjjQ2FCjAAJ9xwT9r49n0hZELl7UPci4rXymhV1NjmaZWuhgJqFd9Ws/MV+EyJFc9r4TIDkt9An1x3uRQwT+1QsJTHMWuMrQUKc1ORUyjeW1CaLpwRtNPeD48guy6ENIB3jNX/aagBAafsCJahcKtQQ3ZNPgHQXq29RkNnMSPWM2UuSbmxNfVz/873xRW/I6A/yzF+Syzn1MI8d3k82Eoi5tjaAN9gXUmo7yBJdw0d2N2NSVNXvIU2LCJlSELO2YdGxgm7xGhh2XIEYxcIndGrbXJWCpMI4ov8Z8xcm+gs9qMETzbs/rtx+cIL2w0RD0qOnDrFsqmt9KaeZoLJf7DRjKPNbg5A7GW1nMy3/v6Nzdg25S58dKmx3im14W8QLUlAOuhUG23EzUO8fsNshJoQk9mCrwezogcpYqEAFg4R5FuZ+NIHgVrHBhHpPD8bNuSdVnol2Km1Dr1unuglWqIey3f8+fOCSnfNb6vjAMrP7I9zYxKm1W8k7z610rG63r2ozzyfl5sPfv9gpPlXwE4ULte2p0Y8bl0Kx6ZBFRSN7UIix6orOArJVwiyd+fVwRnTLCW2jg9Cmpnp5d7g2cE7U7zjS9Ql+r8TAGYub2DFwxyGx6I8OuHJucga
 2cJmaznL
 Y21ojBtsAI1Y7blj/J2BU4Lx8MVUv9Zo2Wx6P0Suv108WrhaDoFwHQ4/ZsLnH9unzOtl46yO5GUuAOhwnQJ301iXgnZf9bkHTi+6GCbENKaKS4UKlEU3RpWME8/r91qFoeXf2HyBWy7NDe9IV6kPCoAisHyJo+ZAZVNDJ4AlVeGdxPL1IwUKKw3D8WSR93uk+u4KzqDIgJLjpTn5dZG6DPUktBsSE4a/gx9T7Zt5/tctuyBYWUpQmsw3j45oJgJGNtBXVLXmfjjzJeaMHDkE089IvTg7fNIfqWJyzzIgKkCHLExfBjHybwYsWjidO3dCm1TE1NMKKw0S6reTaOPmuMOst42NQDhMrAnkrAaI+pap+AkD10nRhcCf6Zu5ogEHUPPFWcsFG5TQwM4quWI9Nqbg9aLnrMEuEX2anw2t7l4M6HH0Lv/it5SPAg9Vjhwg29UnY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 3:43=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> This simplifies codes and makes logic clearer. And also makes later any
> new swap device type being added easier to handle.
>
> Currently there are three types of swap devices: bdev_fs, bdev_sync
> and bdev_async, and only operations read_folio and write_folio are
> included. In the future, there could be more swap device types added
> and more appropriate opeations adapted into swap_ops.

Hi Baoquan,

Thanks for the patch. Sorry I was busy with travel and a few other
series and didn't got a chance to look at a few previous versions.

> +struct swap_ops {
> +       void (*read_folio)(struct swap_info_struct *sis,
> +                       struct folio *folio,
> +                       struct swap_iocb **plug);
> +       void (*write_folio)(struct swap_info_struct *sis,
> +                       struct folio *folio,
> +                       struct swap_iocb **plug);
> +};

Overall, I really like this idea, we can have a cleaner interface
starting there.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 9174f1eeffb0..82d2c9b35b11 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -3518,6 +3518,10 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>                 goto bad_swap_unlock_inode;
>         }
>
> +       error =3D init_swap_ops(si);
> +       if (error)
> +               goto bad_swap_unlock_inode;
> +

But this part seems wrong? init_swap_ops is called before
setup_swap_extents -> swap_activate sets SWP_FS_OPS, or
SWP_SYNCHRONOUS_IO is set below, so the branches in init_swap_ops
never take effect, am I right? You need to move this someplace after
these flags are set. Maybe right before swapon_mutex so the mutex is a
clean barrier that the swap device will be used and all things before
that will be seen by users, with some comments.

