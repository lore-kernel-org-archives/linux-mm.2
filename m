Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02181CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 21:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 540B48E00CB; Tue, 14 Oct 2025 17:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0DD8E0090; Tue, 14 Oct 2025 17:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DFA48E00CB; Tue, 14 Oct 2025 17:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFBC8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:50:50 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B909347305
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:50:49 +0000 (UTC)
X-FDA: 83998065018.06.B0A906D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D3E8D180008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:50:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=niPcLAbz;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760478647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtU8AkT6OWUDePBwI2wg9X45fZt+W0VKLWJBRStxxC4=;
	b=FRatpigaNh7UTn2+c2eE6kNsMCH0ilKjnj0E672w3ncRfxZxfoX8yFxwSq4G+fOqWye4se
	VhNRlOQn20eNIJdLpv3+3Df2GWueg+MccFA+exd/TYxWidZBhX55+dyWO0yTRo6iklECN+
	wLCJmC++OVaYpY7OT0Sp/rau/3h9twI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=niPcLAbz;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760478647; a=rsa-sha256;
	cv=none;
	b=EDvri+qXROyeG4wCRsyjZXFlZe0DrnwU76Dr6hE+dsO1281VaQSsCD1wYcIo0pkpdDTwCG
	zVvf1+8hT0GR3yoODzA+kV/AwAvSgf50SvoZKqe298qBgPQiyxOu9m9Hfk7bJ14UNp0fID
	3d7zrdlOKyEaj6rZ9iBLB1pOKL6U2bU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A876601B6
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2EDC4CEE7
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760478646;
	bh=PXJcuzf1m73Bk5rkVfY9avhgsVOfSb8ycf6kEZBcVXQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=niPcLAbzH5aA61w52BKOrOXRv6MDR1p7DW60cK1YRUFghmaCYS2UA9F4uIiSSFB0N
	 l38mKhz75oKLkXgLUd+YVvFh5LlthUYrO7YJQYNRQoGlaWhewojZvzO8TT3inlgVwz
	 8/Fc+XjWlOBHVn3ZO2IH1D966qDw46hcuAcd0GG5KiDCa8QX4YxNpS0T+kYXkZG9Y8
	 CyEaJj1N4wI4SLn9uFefI/gx2zNoQTFAiKEyvBtc+qV0xukNW70XN2wWfu5FQkJXxU
	 dDpyB26kBArj0u4r167OAo8ilk33wAhK5Kgnjd6vEblVIFGRlqeRnfDIlS/LOzW9HA
	 4MX5IPFbSvSnw==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-78113fdfd07so30624187b3.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:50:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVPM2fxpA/s6ErsEAH4UXmedEnVIw8lX7DCfxMaeVkYIxwblHy/SOVNdsUUK0SRAnXspG74shssfQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0jWW9ucrxFjd8YWZrn5Q43dH/qIbnQWyYC9YzJv95PTyh+TbH
	z8psiBvHsBjAC8VDedmvBlgL/qIkzZebA/eN2fbg5kyt/RErVtVFz+IlelaCO0s/WQNr7D01GPS
	v2eLqlzFMvVCTqcXO5gdbPAlUgbpt9lZlkx3psU396g==
X-Google-Smtp-Source: AGHT+IFQIzrChfQF2GXd1cjDQaFa/agCGeXStKiCVEE3siW2OpR6UX+fFb/D5o5rIKwg2NP0xsn2Q+KNDSG9EnsIGts=
X-Received: by 2002:a53:c452:0:b0:604:3ec3:d78 with SMTP id
 956f58d0204a3-63ccb7ea5c2mr16457526d50.11.1760478646081; Tue, 14 Oct 2025
 14:50:46 -0700 (PDT)
MIME-Version: 1.0
References: <20251011081624.224202-1-bhe@redhat.com> <20251011081624.224202-2-bhe@redhat.com>
 <CAGsJ_4zvtdqzvBNmQjMy0L6JAz_XpvR=rGgNC_Xdo36QVW-g4g@mail.gmail.com>
In-Reply-To: <CAGsJ_4zvtdqzvBNmQjMy0L6JAz_XpvR=rGgNC_Xdo36QVW-g4g@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 14 Oct 2025 14:50:35 -0700
X-Gmail-Original-Message-ID: <CACePvbWp0QFk3WLza=-tpEC0yXMJ9g8aDkbtCd=G5LhoR1kjCQ@mail.gmail.com>
X-Gm-Features: AS18NWC2Fn6K5UdEzFZJiY7LPnfXt_t22aJuY5N4dd3VwdFbTs1Z65hOmmGjbl4
Message-ID: <CACePvbWp0QFk3WLza=-tpEC0yXMJ9g8aDkbtCd=G5LhoR1kjCQ@mail.gmail.com>
Subject: Re: [PATCH v4 mm-new 1/2] mm/swap: do not choose swap device
 according to numa node
To: Barry Song <21cnbao@gmail.com>
Cc: Baoquan He <bhe@redhat.com>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	kasong@tencent.com, youngjun.park@lge.com, aaron.lu@intel.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D3E8D180008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: u9kuk6zyza6d59qbc7s94dxoaimrk78i
X-HE-Tag: 1760478647-196865
X-HE-Meta: U2FsdGVkX1/sWeysu6L40tjjeN1fUupUEefM5BVLo6YBuAF+ub4PbFwsnQOJNBHDgleTKLpaO/KXgasQU6x5fuLsNHjzJGWA75Q3fynYggGS1mjX4HlHOX8Z73LhXkAHgW+qHUja/3mwfHfPERFiP3Uwy4lTQWqh5fAcGW+zTyBByt5hlFzs4YHmMQv8HOU0LWMuYTZMOvXqntUwC6NOSxjmA3HMel/X04oBwB53pbWv+NPqcpUfw5QxYrt2xLTLMT57F6btoeaq27thJ14uTpudCemPYD7tGM5LO37crFe8tGLnHEuQiOejgJjO4HQsmr8tfIwAMcZW/iFpA7h4P6BynytX1usB7A6nBy372cqBJjV2PKtB3YPM9S19seelXCsC3woHriFQVC8eJTZzdJarrrz7LwGLnhWEqYO0IMt9MraB8O+3RG9c180QqybZl9UrJ+tnvtViae8tKPomjTIqCWhifmHEAVxdkijkHeklEPbpdQBjtndLkaxaR67RnxkheVqcLkDcRtBwhDB7QDuyTl02hSZfcNhiRFMNbSp0ZIiEKwpb0rQLwteKBlEl/666BxUpoS8qWtQTuFhb8rk1+orbXT18pYV4LoPMmya7OCrCOwmH6zj1KPyxJKOeU5QCsUP9exTUImSkiosDvKiNpARjTQ/22CBwBzVs0s09FNeMMUKCW74XEHdXS1COswzeKITE8bxSrdn1nDbG8rGz/lWn2Pbsp5f9eoiyTYn+I0TyextpsbNpBsI3MyaW7bwGDXP2+yehCcb1zZc6lTsyJjqRSAtZsKuHvFfaVmkIysxBEKTeIWaHyXMsqNJJe8X2vbXd/KYQq0us00Otr0yTdmqw9Xj9ReZNxtqtFvQWV8oQBfVqqDrJV+FfGg4Wok7/RCV3qxiQe8/Myz2rW7n6G0Imyrj7YQs58ofKlQDsN7UXW93i473tLC2jMkqLnH9V72bXNyxEhojyGEs
 576kBNpk
 WMX8eFEs6Kil2VjKjCJzUj0EONX6xE9IkfEFsqCivJcL8r5Cg6FEuYIziEFqURw56VrND5HV/0tMn5tcXS5yBMUdBsIVACVSYDETOo+NOQXbUc9+pYlbmLX8u4dBagCx75PVvFLMdeYZ6xAkoM9GP9lBEdYUftKJJnDBJljMfMCfZsvjfUnTEjQ8F3kxILBDLMvkDQEN+6DIfmJAeVA31276AaDoKV/QSDaF9M8HokQaO/NIRirLn87m8+BAhxvP//6oUOWwVZjtCyj8nZYOTElMIVnHxKcUv9kHJLPxCwIDOF6EY19ySGAR5QQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 12, 2025 at 11:09=E2=80=AFPM Barry Song <21cnbao@gmail.com> wro=
te:
>
> > -static int swap_node(struct swap_info_struct *si)
> > -{
> > -       struct block_device *bdev;
> > -
> > -       if (si->bdev)
> > -               bdev =3D si->bdev;
> > -       else
> > -               bdev =3D si->swap_file->f_inode->i_sb->s_bdev;
> > -
> > -       return bdev ? bdev->bd_disk->node_id : NUMA_NO_NODE;
> > -}
> > -
>
> Looking at the code, it seems to have some hardware affinity awareness,
> as it uses the swapfile=E2=80=99s bdev=E2=80=99s node_id. Are we regressi=
ng cases where
> each node has a closer block device?

Hi Barry,

I don't believe there is a valid usage case of the hardware affinity
block device driver using node_id inside the swapfile usage case in
the current upstream kernel. If you know any, please point it out and
I am very interested in knowing. As such, it is basically a moot point
to have the default swapfile using those negative priority by default.

I am happy to be proven wrong, anyone who wants to make that claim
that the node_id swapfile usage case is doing something useful in the
current upstream kernel please provide a repeatable test case to
justify it. I am curious to learn about it. That is why Aaron is CC on
the list and his email did not bounce for me.

If the hardware exists, just the hardware doesn't have an upstream
kernel driver. There are some vendor specific drivers maintaining
those node_id awarded swap devices in the vendor specific kernel.
Then maybe the node_id swapfile logic can move to those vendor
specific kernels as well. The upstream kernel shouldn't be burdened
with this extra complexity on the node_id in swap core without a valid
upstream driver to test and validate its usage case.

It is part of the spring cleaning effort of the swap core. It happens
with the other aspect of the swap code cleaning effort right now.

Chris

