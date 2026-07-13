Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C827EC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3A9D6B013F; Mon, 13 Jul 2026 13:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA986B0142; Mon, 13 Jul 2026 13:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD8876B0153; Mon, 13 Jul 2026 13:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 82CB26B013F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:06:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09A15A0120
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:06:11 +0000 (UTC)
X-FDA: 84984381342.21.4F5FF8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 26591140019
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:06:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kVUJIOBx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783962369;
	b=XI/lXP8Lkh8Qfd9EB21JasVMR7LUEIDxvVvq75ru/USyJ3qaOKF7k9UqMDq1AlFEGre+X6
	xirx0DDgPfcQDLSb8Qz4Ju0K/eR6Byzo2RYM7QUWisoZCQUIoxkV1CPBaFfz6+jtRU5oJr
	TVpige7sJqtIIM1K2pUzSs+QHhKktps=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kVUJIOBx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCg0ezVsWUDFwNJ5eXVgcKlvju87Zi05OO8sX5KoW+E=;
	b=ryYxwjrgRlKD9MfEW/3p6TBZ6T/rlos6WK5E1bEsYzkcLcdgP0W5lN8MO6mVte7jyCGBAU
	mbPJ0LARb+9fRhBky5uLY/m9p9LZB4gb/HSJzhGXVFZhOQ8yooTj6y0bZ/dOcQ6/CwCUhB
	l1mm/fU8sXld6/m1OvY17RciXPYkoZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F3076132C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E391F00ACF
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783962368;
	bh=PCg0ezVsWUDFwNJ5eXVgcKlvju87Zi05OO8sX5KoW+E=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kVUJIOBx8nWiyS5mBoa4y043g2Sakko4l0KdubLWqXmAzxfnju2HXHT9WLNNTnCNE
	 Sq5sBGovGV2/K7lLbq8b+pHs8pC/10PgHp9jQe7/CRR9cXyMwIiBcdAnF8NMHOWAig
	 YTqCQzYPE+nfs28gZTxsf+RlFT/GTHeayK2EN/WDxV1T06roXBvcM5odSImIm2tUoN
	 ZROhTWKr7tCiKuYkmX8DeNQqyCxhec3oJdsrtkzQFlylluLe+GmvjijgjDrigV0SRx
	 OoqsnNt5vnQd4+jJ/OjIJASM7ndPu16pWvkt3l4bxX0XGcWUu9GfDxIvLTQ+jqupge
	 GMcarSagf9WNQ==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6679d88abdcso155277d50.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:06:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpv6JsfA3JYTea5mpZwXTXUE3PgwGQkA24kbx4qhuCZyXp9DpbJKZoWjje07Hl3pW0v8OSC9MzQ/w==@kvack.org
X-Gm-Message-State: AOJu0Yxpi2Ah/F9ZjbMmMPYpm2cwzYclTHmCJxTIRP63APG9trtMn1jo
	ceyyyJNhx1dxeeN8SjnEQAxMsJ2RiAjaF128Dj8yYm3p40UPyoMpojt85cGnEfzTaZVEMbxhwrK
	NDjJu2UsnAb+DGi9R9lLGAgY+WykIu2g8MlfkylBaRg==
X-Received: by 2002:a53:e850:0:b0:667:a303:cd69 with SMTP id
 956f58d0204a3-667d7c2abe8mr4777415d50.76.1783962367515; Mon, 13 Jul 2026
 10:06:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com> <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
In-Reply-To: <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 13 Jul 2026 10:05:55 -0700
X-Gmail-Original-Message-ID: <CACePvbUC60sOEwAV6bbBowYe4J8Z9fDc8M=aRXSsXfKNJ5CYBw@mail.gmail.com>
X-Gm-Features: AVVi8Cea804-R-wCPM6hsanlgOS7u2XI_gmRPvx4pPBWwkOlZ6UvNGiEZK7yGZE
Message-ID: <CACePvbUC60sOEwAV6bbBowYe4J8Z9fDc8M=aRXSsXfKNJ5CYBw@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 26591140019
X-Rspam-User: 
X-Stat-Signature: 8x8qf4c6pq6qbqo9w9w6y6zcp47fi9af
X-Rspamd-Server: rspam03
X-HE-Tag: 1783962368-953949
X-HE-Meta: U2FsdGVkX18BoVh0k1TMnWKjd/yTCryW6BcTMLt78DVp8o6b93kET9Bzj1vPd7xqNAaqpZoXFeIQmYBhZZoej0x/FbAFwXi7TwG+jK4a6IEVNKW225vW/P2AvWmne/V+JnObBnqbTt2s3MIt6ER+GsAG5CPZ5F154zvnZ6ccguU/w/9Y813iDrTaVk3HouVUIAQPd+QX7jtVVg6UIxFd4G/Vxuoo6q2+Qbd9+wdZf5DEHEdrKvuo7D2MDAXK/SOeMgEnyzCWaLTWDxFj0MRjHS7EQj3ydU9BidiQCvkTWz0w8DCttJ1Kv0NrbQRfKchUCa24XjEIfNrVMpRyQ26+FYdrxXYdp4sQuhuhHqm5IpwXnTdBrOYqQ6unxNy/7cxbYT9S9l3CYIY210Irh486ijHF0wHU1aQIkpjje7VDa1xXpI05m/u5ph5JvAljAMNVo6CRqDeOJbfTvCpgLmt+jIKUeEDbHb4OtaBLjk1pVbybVWmF2cTC9TMhZPMHHEF6Vj4lkVXCDTskO2+qKGNXMIY/xIjVLrMloKEeQh9cbZPLc1zCg/jkY4eB38jJNqc3pRpRtHGI7Oxo3gVJYb+qg5/dFRl/2oU6Fe4vXt5Z0Ke+tP543tmx8R3j3xxsNUGZmtIvgXk4L3P4O/wHx4pb5A+4B5DBTUxnmC1hsoQYet37Zan1FVdxSNn3eKxs01tO76/wUbZNUUZZDpkYDCUGVXSvzNx5OhhZ1XzNrroDDPDDbGwW6x1tRacAypd/1nWWMl+LZPlxS3H8WElc88AXR+ZofqUftW1/shUJJul3+gmdYq1treVlyDWMNFQZ29GkFBRfQY/RLfr1qaIHeiB36vDyJSsbRetMg5dTzUn5urWcpYTKltNowap1iFRHSDC/BQA0+0wfhgPGAdV5pI3OX+SB4317OvH1gTd919Mh7BT3TnIeIkIFHETm4Z6qjOw6YJwdHND4qsCz+7zULwK
 h0dX1T0Z
 nAQIxLqC/Snwg/37wF+LSgCs8eEWi3cF9glljA1dUYIw1Lp2spzkFG+6rUO+5Hdeb0ebdb19jPkAxAfPubtEbXBe4dNwOptL9buigkSGum0qK0IcY0jObUpq9XaXUtRmnJweGaNdKaxOmGKJthUrckUo9NnEOjtD4PtG2L0CuJCs7kdgGh61PuOWvA0w5t1GM78OhRerjLgVAxK4chCkDoSEAWdgdSe2tOlt6aMSquqcomU7H4WAgLVcGNCjK7ULAZ76GClvYDmSJvoOKL3Q6qiGr9Lni66CgExC1+H3T/UcqVpvXogFkCgHH1PaAAFf27X7tp6gKfizcT69VRZkQr3QYvvXRx+j+zvWTBZLktaDbTIfOeEijv+IE1J9E/AUHl/4D9NqynQvksjnVLXkCSRXJAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 8:50=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Sun, Jul 12, 2026 at 7:57=E2=80=AFPM Youngjun Park <youngjun.park@lge.=
com> wrote:
> >
> > This is the v10 series of the swap tier patchset.
> >
> > v10 folds in the Sashiko review fixes for the selftests added in v9 and
> > rebases onto the current mm-new. There are no functional changes to the
> > core swap or memcg code since v9; see the changelog for details.
> >
> > For context, the bulk of the series is unchanged since v8, with great t=
hanks
> > to Shakeel Butt and Yosry for the reviews and discussions [1] that shap=
ed it.
> > The main change in v8 was the interface change to use memory.swap.tiers=
.max
> > with '0' (disable) and 'max' (enable) values. This mechanism was sugges=
ted
> > by Shakeel and Yosry.
> >
> > This change allows for future extensions to control swap between tiers =
and
> > aligns better with existing memcg interfaces. It is confined to patch #=
3's
> > user-facing interface; internally, patch #3 still uses the existing mas=
k
> > processing method, which is implementation-efficient.
> >
> > We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel fo=
r their
> > valuable feedback.
> >
> > Here is a brief summary of our tentative conclusions. Please correct me
> > if anything is misrepresented (details in references):
> >
> > * Zswap tiering [2]:
> >   Zswap can itself be a tier (typically the fastest one). But, until vs=
wap lands,
> >   zswap cannot be the only allowed tier,
> >   since it still needs a physical device for allocation;
> >   that restriction can be lifted once vswap is supported.
>
> Does this series support zswap being a tier? I cannot find any mention
> of zswap in the patches.

In case I wasn't clear. As it is, zswap is not part of the tier and will no=
t be.

Chris

