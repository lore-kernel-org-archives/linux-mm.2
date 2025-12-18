Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5683FD6D22C
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 14:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADAE36B0088; Thu, 18 Dec 2025 09:43:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88CA6B0089; Thu, 18 Dec 2025 09:43:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995976B008A; Thu, 18 Dec 2025 09:43:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8488E6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:43:00 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D43E01A01FA
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:42:59 +0000 (UTC)
X-FDA: 84232858878.13.2A73539
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CD99480008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:42:57 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6ZVfUie;
	spf=pass (imf02.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766068978; a=rsa-sha256;
	cv=none;
	b=pTAQ9sw/AIVN49npoV93zKVs9aF/18h8VFWxLLTIYTvTUZXxefoKagAxLKvygZTDD69mFR
	846JX4yMtCdsL07N9RQh6Hvsb2iWxAyZaLAac7TmS2ykfb2yrWtTH5YTuS9ypqV2xvx20V
	3D1IX12hICxDgbgaQcPtvSKo92aZ/wg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U6ZVfUie;
	spf=pass (imf02.hostedemail.com: domain of robh@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=robh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766068978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slw+BosK1PsNPJpyi2TmKbuGD4RpEMMPJVH/OAf+NQM=;
	b=X3++OgIcmaz04Wrh00qEXnXTzi2pkyJ/lDtHWt6NahBM3zkcqHy6fIxUIbQI2EFuZsgU5x
	maH7VwiKC8gvNN/sRpxk0LSON72WCL7WUHrIo5wAyf7HjWI9+LD3W+sAMeGrSvbMt2q8oQ
	KkT1njk6rvkLeeIjg1msvjo4nh6H4hg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F65D43CD7
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:42:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD39C4CEFB
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 14:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766068976;
	bh=slw+BosK1PsNPJpyi2TmKbuGD4RpEMMPJVH/OAf+NQM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=U6ZVfUieX3cwLufZBD02xIoNZ17rXxDRXramTk93AHyzo1NPQg7z6Q0hLw8P/gi6Z
	 FCVrFTH+pOVUHA8Wo2PrWamlh3y+Y5X61fJUqZfH7ViE1errdTruUqz+Z54R+GWf5b
	 tePNBLtUMVvTHtn0YMyY0XIjdO+mxqBINTyVbq3rpxMeMw1pL2dfPqDHWXS2c8QaY4
	 zfrviEkK2w/qsVmMrcx5aGKnbdcgkh+ItpnwUsJJhkR8H4HSe2bTr2sNZIEZM7ywYk
	 vpMIrNG/Ek+/kdlcv6gLxyqY79tv23Qx4R46sdFB89clfYcw9QBUoSgWw6lbBtCUCh
	 pR+06ue4QX9+g==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b7eff205947so95031866b.1
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:42:56 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXOZK2KnHYH5U713s/2nO5TiatqyfBT7MaMr4xon5+9o8SR4mGo/q6eJOMECPduYQywFBhMS45XOA==@kvack.org
X-Gm-Message-State: AOJu0YwzUOeSc1MqHFeRbqHugye9gf2QeVvvAAkN4uoHNu3JYFCEeYT0
	ny9CoS6dkp3x/MHAikXbq9EsSMxCZh4A3uMzzXo0MRWmo8CIY4fzIFbjSGY+CMXCTPAuWLUYsxc
	yz5CrDMDGFrNDQGq5ZPWk46Pni9xjnw==
X-Google-Smtp-Source: AGHT+IFdmyojuTTgaWiolIibwsAa/0a3X7FzgZ+D2f7PWKjB9jlhVbGo9VOiZ0gBgTNEAMMazdnjwp3dHTDr86SBEs4=
X-Received: by 2002:a17:907:2da0:b0:b4f:e12e:aa24 with SMTP id
 a640c23a62f3a-b7d23667b5bmr2457256466b.22.1766068974880; Thu, 18 Dec 2025
 06:42:54 -0800 (PST)
MIME-Version: 1.0
References: <CGME20251210002053eucas1p1d1408ad0fb49a49bf4371687f8df7395@eucas1p1.samsung.com>
 <20251210002027.1171519-1-oreoluwa.babatunde@oss.qualcomm.com>
 <X-TH#1.CAL_JsqL6VVQ7K_ZAbHJ8Gb7ei_jusLx6wRn=AdOVgV50dX0ejQ@mail.gmail.com> <99dc91c9-59fd-47c5-b1d9-157bda86ad59@samsung.com>
In-Reply-To: <99dc91c9-59fd-47c5-b1d9-157bda86ad59@samsung.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 18 Dec 2025 08:42:43 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK5QEZfyRTDY4z88mX_eYENibea1ZM8H_bEfCCsOOwY4A@mail.gmail.com>
X-Gm-Features: AQt7F2oHd8w0_YjnIgYXfiCaa1Lm7dC6NF9JlmrJ9TE4Ra2le7vZL1e4sdVufPM
Message-ID: <CAL_JsqK5QEZfyRTDY4z88mX_eYENibea1ZM8H_bEfCCsOOwY4A@mail.gmail.com>
Subject: Re: [PATCH] of: reserved_mem: Allow reserved_mem framework detect
 "cma=" kernel param
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Oreoluwa Babatunde <oreoluwa.babatunde@oss.qualcomm.com>, ye.li@oss.nxp.com, 
	kernel@oss.qualcomm.com, saravanak@google.com, akpm@linux-foundation.org, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	robin.murphy@arm.com, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux.dev, 
	quic_c_gdjako@quicinc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: CD99480008
X-Rspamd-Server: rspam04
X-Stat-Signature: kkwapw69f36pmut5frpk3yn6zqrbp8se
X-HE-Tag: 1766068977-37364
X-HE-Meta: U2FsdGVkX18G9U3JxNCpioEaooiC8A5gvX2ctczNNmxkRE9ULaXdRwZq+NHm6XodnorK7HU0aa8YMKuzCQfb5g8HaeGQsA55jaqdddYbNtLD1MB8Lyx2U7s2Nk8ceg1SIzHjeM+sRG5psPAka4TbEoujKdUoN1Ts+RcpysZ3PpcArQrF3faMG4A8V6/MLYDkepy0rRyCSMVJI19Q7TEJgZgjW+rXscSxUTIl/eVJFitDYUEgUyFpTDRXmrx2t6vsfhiZ8IFMlYgtL1WSyycYwsajtQ+Y2T/6GlyzIv+TXt0mp8kIdTpjKSqQ4ofV0oQXqgM2/OVRCD522sRemmRPm4wjizKg0tEOU3Xd7yUKwadGtLu3i9kf0Bsuks9so5eDwgJz8EBfYWAa0Klhuo0iSokruDaWZFnb9PRjBnzykjbDmqtrnVw4Nj/nhPt9znjVTazkcHYcfB9P2BwommNxqPGBqI5dV5tWs+Zk+yTng7IZtAOsP/Wb0jEeHEgGQQX7v7o9kEF4gxfz6tuX0qkO8aTaCyZTHuH3qyz+PhNOOYK4hgqWbwlLSN3NPDP1QyaPAcuboQMkqzSFao/yw/r1jc5e+Ymlr1UcLHS0aH5urovM+b4ZI+s7Jr4HUn2Ce6ddIdfMWP8ZCQl0PxSQdjogoHGb+KmOACVT7RQkxcGHj9F8TPEx0lhX9zE8PAlf1m/5yicPrDEKiXLlwFfqDLZUHazwCe09m0ck3BhvIAHqVOsObsrEPnTI6SIz2bNzx+FF3FJzhln8lFP4xQvn+YwddQworS3Fu6Gw6W8AFQhNdf0GYElyUpxR8wJj8V/kV651giTlxGFVEIu3DnhMg/FRpLxIr2Ay4b3EYD1t+cASg9zFMlrPvYgyT2x/HpwI2LwUdakHK16LHn+fA0mT+YmgYQRm3j75ou/9Z4lkIyNWNOes4ZioVVL4ok4i2qmO44PbF7te3w1OAEQKQQft1yw
 ZBoXd9Ny
 vlsHNSOkPGHJkFPluyADzl5GKY8Z2bbK93tu6QwHgfmSu6FGVUbByy0CS2LWoAkOokJEFy/Mi0+MqWCZ4UoWSCDkR9dxYx9te7u7O0SWSfjc51QiysnqWIcb/0Mq8p0hrpzqekLM5Vi/WgUl3lv3cPD1wfoGHnl6Kiq5D55W/N/U/9z6MSlS+3VReNT1Ozlg1KKG2Ki6x2tS8OyD9P4YLMmB4E9mKIi0Ylm1ikxIZhRnZrM8yRKPNa34JcwbiIVTllcAH3LN5QShwLaHmsPg2fCfP6BIRgfgHP+PL1J6PeMeo/hM3DddLM5Og0PRju2lxBPur30k1s/OGZUZMF8JW1Uiq8k979h09qhphD//sWi2u4bIjDNEqEunRHS5L3fXhv6MqT6TYePXH0h+FjCtbQyRnFf8R26o07LXYjk+68fwVfzR3dDTuUOtBZTY3Xjl0hApvZfjxIzBo9Jg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 3:55=E2=80=AFAM Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
>
> On 10.12.2025 15:07, Rob Herring wrote:
> > On Tue, Dec 9, 2025 at 6:20=E2=80=AFPM Oreoluwa Babatunde
> > <oreoluwa.babatunde@oss.qualcomm.com> wrote:
> >> When initializing the default cma region, the "cma=3D" kernel paramete=
r
> >> takes priority over a DT defined linux,cma-default region. Hence, give
> >> the reserved_mem framework the ability to detect this so that the DT
> >> defined cma region can skip initialization accordingly.
> > Please explain here why this is a new problem. Presumably the
> > RESERVEDMEM_OF_DECLARE hook after commit xxxx gets called before the
> > early_param hook. And why is it now earlier?
> >
> > I don't really like the state/ordering having to be worried about in 2 =
places.
>
> I also don't like this spaghetti, but it originates from
> commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
> memory regions are processed") and the first fixup for it: 2c223f7239f3
> ("of: reserved_mem: Restructure call site for
> dma_contiguous_early_fixup()").

Honestly, this code wasn't great before. Every time it is touched it
breaks someone.

> It looks that it is really hard to make reserved memory
> initialization fully dynamic assuming that the cma related fixups have
> to be known before populating kernel memory pages tables. I also advised
> in
> https://lore.kernel.org/all/be70bdc4-bddd-4afe-8574-7e0889fd381c@samsung.=
com/
> to simply increase the size of the static table to make it large enough f=
or the sane use cases, but
> it turned out that this approach was already discussed and rejected:
> https://lore.kernel.org/all/1650488954-26662-1-git-send-email-quic_pdaly@=
quicinc.com/

I guess the question is what's a sane limit? After 128, are we going
to accept 256? I really suspect we are just enabling some further
abuse of /reserved-memory downstream. For example, I could imagine
there's micromanaging the location of media/graphics buffers so they
end up in specific DRAM banks to optimize accesses. No one ever wants
to detail why they want/need more regions.

> Maybe it would make sense to revert the mentioned changes and get back
> to such simple approach - to make the size of the static table
> configurable in the Kconfig?

I'd rather not resort to a kconfig option.

We could go back to processing all the regions at the beginning
(growing the static size), and then just shrinking allocation. Or
maybe it could just be freed entirely. I don't think we really need to
keep the state around forever.

Rob

