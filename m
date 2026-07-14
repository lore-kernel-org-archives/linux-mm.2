Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27718C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 23:09:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D96CA6B0005; Tue, 14 Jul 2026 19:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D479D6B0088; Tue, 14 Jul 2026 19:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C37CA6B008C; Tue, 14 Jul 2026 19:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9CE536B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 19:09:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B4D6804EE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:09:30 +0000 (UTC)
X-FDA: 84988925700.09.DCE2436
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19A0E100008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:09:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkF3lJ4I;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784070568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zTCP9dQLXcTz9IAYWhPFQkdJa9zlY0cv+/0cwPrfvbM=;
	b=W7nP/Xjfx9nTwGaqQ9gq7mKasipAvEegOlAtEMCfaNx5VMC1cQibYOaWk+rfzGIZmnQlqK
	jh9BtpkG3X5p9rBQqEcW5bSxGGzsCuEbY4e7O5q/5nYxoQ1QFZEBNryWiLWP8uqAHZuvFl
	JVi6fIKFrr0Aeaq5pz/zfjNaZfLz010=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784070568;
	b=zUqyk9BcXegvg7FWFOZq+l6cpPWwS2q2PDXopx7nGQuozjEwdtY3w5mwMZvLjO8CUAayCT
	briV62Rrq22OQbplj6i2HkrJc0zXSGybASRP21Jizz084SQdKiz4FatWHpZpX7wRIjYjM6
	/lcXeLgHmouiHPADQV3QRO7LcYr/dIw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hkF3lJ4I;
	spf=pass (imf05.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01D5D43CC3
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDE421F00ADF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784070566;
	bh=zTCP9dQLXcTz9IAYWhPFQkdJa9zlY0cv+/0cwPrfvbM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hkF3lJ4I5+sD2Um3EnhTbYuA1XyIn6jlp2vBMdkj0JuLhaKwlAWYlMQDYWAQXcUr6
	 u6Jc6KglvgMK3wbEmm3zh1OFyngLNjgowaoMLr2qcfbTRQwWy5tmd9hsBUwCc+PsdW
	 FfRE+88yHXmZ1TxKVFgfnw35Tu9XNIQg4fnmdyBxzvglYAf7yi/d/oPrxaOaD7rv77
	 dMSEA30Dy24W6vNnQfkgbw3X9TL5Atd5kvhvYiz3fHNR4muYN265WU+3Qrr7yqRucn
	 zYIUzG1ZW1OPiAGGsN2PS2zDbNJU5loU96l4LZ70WGWeN2rLiRRwefJITYt4fX+7W9
	 N6JfjtsqObceQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15f6d667bcso608872366b.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:09:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RoU8+M4nl4LxNy6Wrmmrh79TbuQIGjyQZo63tO5VwjK10DOIbc1jcfdxETsE3VttbMN2cFMkCR29g==@kvack.org
X-Gm-Message-State: AOJu0YyV3tpMumluildzXHhFeIDBolAf6SlWYU5nV1oXQqUy8z+3o6XZ
	YteMnUzun/ov143WOFNenu9AN1wsGPtA0YJp8D8DuQdM5nlDumJAShZKi0fubUzuqTKnStyURBR
	DUHF4H7enEXLNyOm/G4O492Rf8bw0J5k=
X-Received: by 2002:a17:906:99d0:b0:c12:80f5:d841 with SMTP id
 a640c23a62f3a-c16794eaa6bmr42313866b.56.1784070565492; Tue, 14 Jul 2026
 16:09:25 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com> <alawYov0c7a0Q6_l@linux.dev>
In-Reply-To: <alawYov0c7a0Q6_l@linux.dev>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 14 Jul 2026 16:09:13 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO-jzWQhuhU2EW9i4XdXHJOb2O41d4Z78PVFpcOJrNVHw@mail.gmail.com>
X-Gm-Features: AUfX_mzvOgW9mqEBogtkiMVNyhRKUN_n3YFXsr1GXqZoCQ_8H3HQwA8JlG7e9w0
Message-ID: <CAO9r8zO-jzWQhuhU2EW9i4XdXHJOb2O41d4Z78PVFpcOJrNVHw@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, chrisl@kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 19A0E100008
X-Stat-Signature: 89uzwyjj9mz8qazrb4e35mp5wdg7iga5
X-HE-Tag: 1784070567-796696
X-HE-Meta: U2FsdGVkX18Ebbnm7JZRGlu14mpuA+quUd/aaR/7PWWHyqC3hzWFBfAnCMb1zK3OSVrLVh7lLnk4QqdvAM2gez6fD8q5a04QkLRElXrOuX7THUvQjvxNjRcWIVQyEScKIcTgFjfKuxYhNpfq/EtKOXUsR4we1rS3zrzATdSHFl2CM9z2szbrVCXlq3Xt0fxF/yt8ic38ImicuwA11lRd5c5X4i1byqFnfGklKNdNAoubc0U/fgufnqZ3sH8os/p44yEYV0a6cgIhqD5SK/vSQ3h2LieI8OAAkIO/Gfup5zefo6IhQ5QjsKU4SmRb4u09AXX/Hbx9vS/AHJrTm/W+GPXFfWAtL3U6RbTCNDu3BnGBwvlEIji8MdrAhWyRpEiHBwAkrhAUEmWA8bXRYTVIQPhHlJ19lsk+Bx8Gi+I8R9nbjcNkQrQsHQojv9PhbMoFLv26/vH5mQcu/9d9ue+8mnKvZFd9Z5sbtEsRSMmATyjUJ1Wkzo2A0YWzyXIuwfJd4nGDeRCU/5A8BRlh8jBE09+oxp7oIcA+yfeaQPZMCjDQ8LO6yys+A5AtOEMznDUk7kYBM1qtie9Ocl6cDm5P7tYVn/u3EKqWg7Oc4ib0bNEiUn9C5k0v70PosoEI8jovvnKbWSXdYdpRAa43wcf9IkCpKrIm/ja/FrQHqncu+DU2pc5iYk/M5LCJJ6yJ/o4d9FRWIkMURYkstYAX+LCoK1Algd5UDBaU/gjHY90aDA0xxyVCzZ/ZZY5rmBSDMkLLa/Yvu4psw1QrKonzN3cF3FNT1JfXicv/p+8Ca6mThKhTOb7jIL3ZH/n7xAI/Vy8mYxE9GWVYCqmQhO4P103AdhflcV1besHv6nxdaaFZ+Jw6ee/vKI8qNBkYw4B4sLsWZ3Zu+sefzltdgX5WrNfJD1Ll2Hjfzfi3ylcL7OyC/YJnjdG8f4pRwy+nxncygMsc+Eu1o1vW9UQ9dQ54Sl1
 GubXxRj+
 js6E4MpiDrlch791/XfzjUL5ZE66QldkiU2qvFPbb0EnbcKpIomfBFvZ08NeAU7TkqgkVTTx1Ar5XTQYRyN4w2cMtPJJs0KfC2atS0DHznpKQoDozwdp6DZk4UiI3OSaU9Y5xq1oC+TYEGsZ776YFdm/lR5/RqNLcCDulHMgCMf2Z4ZpCkCbjw/z5BEfqAGjiORYJAc/zQX5RzRPANAAglqH9Wg8KzxDTWoo44Y+eg5pHNgQbKBRj6QjARPfIDGAdTyV1elYda2bElQYFOjULrRkpc2gFNwq5dADxOrgEo7XfekkyJ5eiOGEWoSRmtrSHf+9O2tATpk+JdC0th5KxZl8P0zCDFysNz88MO1l3uOF2aVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 3:26=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> [...]
> > >
> > > Yosry, what is needed to enable zswap as a swap tier? What will be th=
e minimum
> > > requirements for that?
> >
> > From zswap's perspective, we just need to skip zswap is zswap as a
> > tier is disallowed. Could just be a check in zswap_store() similar to
> > the check if zswap is enabled. I am assuming that if a swap tier is
> > disabled, nothing happens to the existing swapped out pages in this
> > tier, but new pages do not get swapped out to it. This is the same
> > behavior that happens if zswap is disabled at runtime.
> >
> > From the tiering perspective, we need to accept "zswap" as a possible
> > tier, or maybe creating it as a tier by default if zswap is configured
> > would be better to avoid handling the case where the user doesn't
> > create a tier for zswap.
>
> Default tier if zswap is configured makes sense. Should zswap be treated =
as
> having 32767 (or maybe 32768) as priority as it sits infront of all swap
> devices today? Also whichever swap tier has priority range containing 327=
67,
> will have zswap in it.
>
> > We also need to disallow zswap being the only
> > tier as that combination cannot work without vswap.
>
> Do we need to do anything explicitly for this? I am assuming in a kernel =
with
> swap tier support, there always exist a swap tier if there is even a sing=
le swap
> device configured i.e. a tier with the full priority range.

At least on the memcg side we need to disallow writing 0 for all tiers
except zswap. Not sure about the global tier configurations.

