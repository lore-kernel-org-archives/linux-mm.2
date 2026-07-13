Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FE6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:03:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C82576B0151; Mon, 13 Jul 2026 13:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C323E6B0156; Mon, 13 Jul 2026 13:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD34E6B0160; Mon, 13 Jul 2026 13:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81B3E6B0151
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:03:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06A951C0043
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:03:12 +0000 (UTC)
X-FDA: 84984373824.03.39527F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1516C40013
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:03:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYCp8QaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783962190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1Fet5nEZQV4MMt5es7fTqGCTp56uk9Hiy8cY68X9Rw=;
	b=Jz+zcnuw8JRfl6M0rd6o1AlJ5iL5WNV8qC7ExJ2s6irnvzNsYiGKWxAdby0z+oF6mtqri1
	ov8689JXLS30xl4esW3BEyA5GZ3HTRtNJ9DxdkOd2BLnFsetTP//k39UdSwF6Oi7RnC0h8
	cmeYlXOrXyh3ClfHZVXaYJu5sBVLXdo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AYCp8QaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783962190;
	b=w97WkM+d14vu8Spf0UQ1M4wmmkLGGQhZ4ie0XuBpC77WPS6mZfiS4Gcxvki6iIaOHH09LR
	qziv8M8/SVNvrEl/puWl1AICyLnwOqa8HCX5oJGWRNufMQA8cf5Yy4rhJPmGwM1jEKmlto
	gSiCHPNeGSj9zVLEwEX6Ia8jAUzc+fM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 416934349C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AEC1F00AC4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783962189;
	bh=b1Fet5nEZQV4MMt5es7fTqGCTp56uk9Hiy8cY68X9Rw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=AYCp8QaHGQp4HpDW9tcdGQ/O2AXHYUzGChVx26and5GjAlRRHJZcg7TKm912W7Hwg
	 XNEOhE7YKIq39WGfj2kauuHEKY/8b4XAPz/otPi6rhDCYYzp43BvMArpN1gZUdvhyK
	 xxaktNKL04Do4l4dFitcSfmnHigokjgJ9PO7o1A4piIBMJxUDQ8CDOXcLnbMblBeDS
	 yColU5Sk31bHrN5ewUCpyq43OyEjB9ZP24GONX/q2KXGwO6tqW8LUoSKWUyDnJLm/c
	 zhlRFbm4E2DLmJa39omopyFjhvOEGwQG9qo+zpQr993guhbZiVZifl7e/9P8cuje/u
	 Vu/Ppdyg9ryWw==
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-81e8fa1b8d6so24652067b3.1
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:03:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpWN8I4SL5nFtm45vG58p7UfSuLWCHrZmzRKhh2gq8omIcIy2wVI4/PxwE71f3sg0m4ML/vEwY1Ag==@kvack.org
X-Gm-Message-State: AOJu0Yx9+HMyBo57m7LZQFIzj9/52GBIzMm8A+9asrRs8Y797zmyA6Fc
	yjnwC9ehx0DTneNwbSdctBmybtMowuXAsL6ZzXD30KUZEIV1nXp6jszopfAYX+YdUe1MTJzRD0I
	UrTgZWqaXZcf9Pil1NYyEMnNzhYOQvlfYSKLYGEryEA==
X-Received: by 2002:a05:690e:d48:b0:660:db62:a47e with SMTP id
 956f58d0204a3-667d7c541f7mr6018869d50.65.1783962188491; Mon, 13 Jul 2026
 10:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
In-Reply-To: <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 13 Jul 2026 10:02:56 -0700
X-Gmail-Original-Message-ID: <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
X-Gm-Features: AVVi8Ccfpc_dSAJTfLvWvMA3EJHfo11-b7EEEJwmjvmTr2Ua17H4FE4meVFn4TE
Message-ID: <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
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
X-Rspamd-Queue-Id: 1516C40013
X-Stat-Signature: h73jnb3xe5nji98t6i8h4oy96xqzmx68
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783962189-959810
X-HE-Meta: U2FsdGVkX184Arv7hFNNoO/wevPPLbkFLi8t1hpK18QNW7txjgnzsCNdV30BkPfX7pHC7nFk2rsX6VcN2/r/F1397XYM+TQiajRloREjXwYutfuEQuqmHQHdlH0XvGZfR70trMJPq5Pe0vh2R+FnVJzxkEuyxzc+DTgjsBK0KdLTdrFZMuurO0Cbr3zmyPc95PdmaxVfFvI4JQaa776WKPQiUyErPnY2FH5S4P0tZvODHk20bjXFXn7mSPWzaPLm4p9yIwLxe3Wa4CYrf+KcnBDNKDaMNysVh7zDBsB9MuXsw2vGXP1cldGUspjC56/9V89Vxx0SJ2WrSQv0MH5sZEg88baghx2OhD7VcmBsIoINFyiEHYUKOehLg3l07Rw6drR1wieZKw1pMmfGmP80oL1zGpaN9QGjD6R/FTRVNJfutLY/MM6LVIK7R7U7h9FuJkXCq4UzJNCKlZFOm581TVW5g7rcAhy8u7er4BWv1GZ2VXJNb9gihhSeNC5NGt90phDUNwi86rvv0SJ4i08s9BFDxgTEB6mpcBHXlEuPMMWGuvpGir9NBk1dMYe4TruXyJUY7CFcRMTxlnzg19UN9Za1KJQht7TkBWODYU7T8HYv0/fFRcqrYgMCRB59ugG1QuEWve8SOvj/5z3zNdL5J/qw40ocNfCq93yvMNAmkF06u02k1KK4lZ3xPw2uM2XIhmkxqSZmLRxPyrLsyaxpce4AxRDEntQMx8uy9YFmwjRhTafRa2lDJ1Ezt3/Mhgz6EWGX06ckUkum4f7nRa3lBGeddcl6MUhUNXIJLYLIuCOzyAWmMLsgKRC74WE3gua437MRsfiUclkltUvUtdt3xpJ8750z2NifY7xfgnxfUFFaJusdI8FaQLmZqZOaMyMtcmGOQnnpxw3n6QpYdFpPHC2SAu2S6db2w7jrUcyoE+rv0BTYhR3nzXLYjsXF1ARcXuwscFsr8JAsIhXd6Xr
 40N6wgic
 PZ45VEto4SyJOzkfTGBlZn9bxlk90UXO8q4U7lWeOdxnuzjGQQanlCaM4U7rUgLRyt302KpkDYOnelfHVlVUSR7gxmtDpkwH/lO6APYPphi/Z3nLjrx1ps9MxpYlcSLTOFKb4y6V2fy52LpCY94eP8ap8d349RTPhTtB3vg1Bms8vBbS6vwM3GyTzZz9xSyQZSfz/cVMm5Fm7ff1GfeOWSxaddjezyuQrhLrP2RwjkRa+RcSAJarEZOs3soNXi0Ft6rzOFLdlNoW1U0o0DAysnA+33ubo0wl0j6xmES5BGHJRt0tkPeiN12jUemSXxinm68HbIrDlxcWUuhjMYz8klL33iXvZHRKmmtDxx67BYCqtvZ991dHsSG3O8vVB+HjIWeNZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 9:01=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
> > My plan is to land the swap tier infrastructure together with the
> > first use case (cgroup-based swap control) first, and then follow
> > up with zswap tier support in a subsequent series, continuing the
> > discussions we've had above.
> > (I mentioned on cover letter, right above the overview section)
> >
> > Does that approach sound reasonable to you?
>
> How does swap tiering work with zswap in the current series? I assume
> zswap is just enabled for all devices in all tiers? I wonder if

Zswap is not part of the tiers exactly because it sits in front of all
swap devices (tiers) and uses a different control to enable or disable
it.
Let's not combine these two; let zswap use its own existing cgroup
control interface.

> introducing zswap as a tier after the fact changes user-visible
> behavior. I guess if zswap will be introduced with a default "max"
> value it will more-or-less be the same behavior, but I would check all
> user-visible behaviors related to zswap (e.g. interaction with other
> zswap interfaces) to make sure nothing breaks or changes in a
> meaningful way when zswap is introduced as a tier later.

Zswap will not be introduced as a tier. The existing user interface
makes zswap not exactly compatible with the tier ordering because it
sits in front of every swapfile. If we change that, we break the user
interface. I suggest we keep zswap working as it is now.

Chris

