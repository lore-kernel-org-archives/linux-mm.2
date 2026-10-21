Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76502606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 17:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=Pejk428l
Received: by kanga.kvack.org (Postfix)
	id 62C236B024C; Wed, 21 Oct 2026 13:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 604666B0255; Wed, 21 Oct 2026 13:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F34D6B0256; Wed, 21 Oct 2026 13:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 269546B024C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 13:56:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D1D6C0653
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:56:33 +0000 (UTC)
X-FDA: 85347388266.12.C6A238C
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id 289E814000D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 17:56:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Pejk428l;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792605391;
	b=G0KZyJyZelMfIrOd7r3FYlsDAatcWtmrrS8ywPf7e9e1BC6xX/RB8Rfr8dLUkLec9prP6E
	hopheWFT6DBd0SFcWRL20ut+W2HFHY2VSJX9Yp7ouM09n1UzEkWwaefI/Nzl1qeAaQrfGd
	DLNdbLWMxvBNynYZeJCyCps+2dsEgSY=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Pejk428l;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792605391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/9Q6vwSpHzLOuQcu+iZE9ek6ulZ0fAfcC9lHWm1vuA=;
	b=Phfp/iqx8QtRMtV1AQLekW+cc2CSt5NOS6YgFAHoECSY5810S5L8MJpTRpYXng2bPicz9U
	ZPhEC2/Nouityu8/MnAUGUuT3Xbk1VJMgx1yJGl860ilwJZlaAdPwQgSzoUg92sQxSZO3l
	VhRjifM5mZ40Zy3enfuVW95ZMMNGBdM=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so1709158a12.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 10:56:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792605389; cv=none;
        d=google.com; s=arc-20260327;
        b=YI5+Ffyh7SYSCV/ABG/i7A7nhynOcPh0LRcwQJKB7BcSit7yOPfHEaK5rJA4g8z1Gu
         z/VXxp7r/Z59m03XSjl/BhPBNq3q7vNEXkW6S0wpmPpJFVqrdk1Z6wsuw+72LwXCKRN6
         iw0mf0FDXJkHg3cJLs3k1E1gYelpk3udfNGF35ky+qb4+7/7LL15YTrIFF0GosLihRjy
         QelPdJQNJiVPad7TcCQvnPCaK0Ll+w58O17iBpXDzY+hWcjy8jos9v2rupVug8bYMYaC
         BU7NYNQbqJF0HakSSm7cwYgr0FoCtntY+EZ146Jv7fZ/qAWA9/FzvkZRY7kHa8aIl1yv
         dx+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=l/9Q6vwSpHzLOuQcu+iZE9ek6ulZ0fAfcC9lHWm1vuA=;
        fh=EOrXB3BTBHiK03CylFBXaysXgO4LjZji9uCCf8x3ZaQ=;
        b=O5KPdx9Qok+RkKl0pPhrCHwnJTbpf62hV2RzYkqQ6H74oDmVR/nA/YRmt8bGRH9qLr
         AWgXzrcWDJ6qFFIxEWafm8vk950HV7xGRN67lXqneBU8yMcZU2LFFenLcpWIupzNozQb
         ZlMlk6mHyKvgqoWJalht4dgXLBBpI3AgUuR9lUCFKkrxz1B0vPca7ZmUNSa6iouy+0KV
         xtbqKHfnIxTUDHWJGTaYJZB9m0dHoRB9lQ4jF+xJ5TrTMzM/sMxOoUxGP/xSwRLLydDT
         QOCojQTpn2+q8FZln3kZJ1UE8n4b+MFjlU5WIV1tebsfGXN5KzKZ0sVJAdDnuXZzmMpa
         pUGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792605389; x=1793210189; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=l/9Q6vwSpHzLOuQcu+iZE9ek6ulZ0fAfcC9lHWm1vuA=;
        b=Pejk428l93mBWx1LWDvc2zldkTRcaro0aS7qdfQHUMcdVYuvx0F1aBErOxl4eZjgQl
         LTk+GSVoIJm7YeQJbJ2y0Fw7JHWJhDsa8O0NNWxCXPeR/mXUptnS/CK5NgZ4dwytrake
         XSsaXmnhss2E+PaiY+BxdSch5TaNwaJSCqkgFIgBxkIdD1S15Uyn1XPGHqKUAWZ0wvCx
         HDr3GGHPeHV9E5MDP4Y2s1V51TMa93oyDRGZeHlzQnu4PKRpbkCdniqnOGWttTo6/Ete
         EdDfxyPpnZigyIumKnEDOttUv9v9Be1xe1SEFQV3X1spafi1FtLVyrNO3Hp55ALPzg/Y
         LQgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792605389; x=1793210189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l/9Q6vwSpHzLOuQcu+iZE9ek6ulZ0fAfcC9lHWm1vuA=;
        b=hWJ9HqIG7bTjBFO6DgYj22uqAywDIP6g7ejAZY9uEFcTNXIgX/D0viKjVTuEKJR8EX
         fOA2+yHiU4TgiwDoAaDZDA9eIIevGRFQMN+8f/MBgAKn1XgY4qJlLHiYSoxuGW/zjWxX
         5Ylw/Yprd2+icaYqOwLQEV05FJbq+ijQfjZ+cNBcvBS9iXYMY3L4LgNGM2W+qlGlG4d4
         ckXaiI1l4lgvejO109x4MKYK5WujdKHxrqI4/y25Vwr3xs4czG/6PSEfjAPRWsBMUzdW
         R9htjf9XlegIe6uSw9S76gemBnjWAz9QVy+ZUheHn9FPNMq2N0JchwqhiqG424vHFtEq
         rzeA==
X-Forwarded-Encrypted: i=1; AKwUvBxpYuQ0ch47MjuTaelbAKcGtu3SP7TtyJ2o0PHt9T8bvNIe8tG2YQfbcYOC3vw9IyJaer/KmQ2+bQ==@kvack.org
X-Gm-Message-State: AFq9FYLLidEz3yR7RR7epPNwwB72F/ZbnrGO7FFZvm033OlGqPEm7dRu
	ki3aKrOaCBKNOF29hBP3vFtSrlbSRbfUbc9Xu/0AqXIQHtx/kJ8AOn68ndBf7HgYD2w2xsl6Q1k
	r6eDNpmhx+W8ufwIdODSZywwWGJHnojfOuWDb//SSQQ==
X-Gm-Gg: AYBFou1DP+0qRl+KIW4rbTwYBzQgQf7ZPFlLRE0Zitnx+P0lGULcQIQGUwIRZ7j6nNp
	ProkN9jR/7l3+0hFHjhKzGVxGGhQr0cgjg0md8/D7Xkmi+YFw4v1V01EHYXqrs0X2/KdJ+Zl+Z3
	4GX0DhDShpA4duPUHbtdB3oCmo/I2tBreUAE5ZxDOTD3qyTnqyashHXwDKBlB2mLK+sxQkC5Uo7
	O97Bsbz2h7zOhTdltMG/VkCbMUsmppFA/yXDVjjFd3WBdop70H8jG2n7PttKjNzd7LLNd0FZPJi
	X/tkzAu6M5p5kwWdXl1WKAM29ccF5tKPTOIll1LbKd/VlmIO5SPrZs5lYY64O0cM1oG0/cMYK/A
	e/H9dQ9huwc4ZlmkNOJa0cdn5TQnlqjpg8c0W5HkPYe1pbnQA7Da5X9uhLSIpBnwTQms=
X-Received: by 2002:a05:6402:458e:b0:6ac:686f:91db with SMTP id
 4fb4d7f45d1cf-6b408e9f045mr1964734a12.11.1792605389455; Wed, 21 Oct 2026
 10:56:29 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261021152527.375070-1-tarunsahu@google.com> <20261021152527.375070-4-tarunsahu@google.com>
 <CA+CK2bAQbmq3ArP3XMErF_8RC2CUwvgpLY0H83D0nCJTaVKYyA@mail.gmail.com> <20261021174006.GU3008132@nvidia.com>
In-Reply-To: <20261021174006.GU3008132@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Wed, 21 Oct 2026 13:55:52 -0400
X-Gm-Features: AclHuK-Q6MQhxMIMUURzzci_OOwzGik9EFivN3YqqlGA_5OHu0xT6GsF67-BzDw
Message-ID: <CA+CK2bDJzo44K0X-+5F77E9g2dmqKdwZvrUf-1SkC7ewrgEgzA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Tarun Sahu <tarunsahu@google.com>, Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, maz@kernel.org, arnd@arndb.de, 
	David Matlack <dmatlack@google.com>, robin.murphy@arm.com, loganodell@google.com, 
	oupton@kernel.org, kevin.tian@intel.com, alex@shazbot.org, 
	dwmw2@infradead.org, pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 289E814000D
X-Stat-Signature: 87tqrb94h7ozjgdfmsr8wwc38xjdzh8j
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792605390-837572
X-HE-Meta: U2FsdGVkX1+/v4kWtJ0sm/dZHK1GWieqUJiuVoD8rxXHLiiViXVanFMmu+PEmYGf/C5QKgnrdfZWCm74MPRADhZhEjePGd8euk4k9/z9kRQ0EqLndC/6SQh88nEg9dP28Vu9YK6YH1RsQ05Fy+98AddD7YO7BL668PrnT7lOSgQYUs8gjny9taVWOjvYo7LLpMbb1FkxM95QcOHxhixtWgpdmwF3ULwwnyT8LVyfEXmgy60zBX0ivi+/2snR54lA+217hKn0hPTlSWP4d3kxG4t6gkAJy87ESfaMzmU2ibskWHbOWgstxXn/5j546kgYBRluy4dy0emDa3J76/dtiTTBGISgXh79qqpELL+1BIwM3j1+QTd7j7LbmWjxGPwuEHIc6CUoiM6YQtGNHLHqttUFiGJBkig1lFF0fVIZXOhNbA5t/5r09DqaKwfFpU2PRGxuQFZGo44KexkGz67A5Yr3aRkRMuxrvBCXGNc9/L6Dkuw5xsnCVXDKIUX2scmFnRA+Hfa+Iz6oSf93Lm+C8OpLw6+kzIthHgaNzlx3syEFdaTB5y4RiMWmIZQUhzukEppdxIQtOUjzMvt4zJiqY1tZG+eT1sF0umSZvubJVBEzz8Vx84OO2+5u5eChArPMG6U9/b42B4ebCa3q+ZDsClVIOpqgazfCmRF1WeBdK4YfgQ0kpg7AMH8tCIdZfwapQiP+1gFZw0I6pOpuyh2nXmKE/ceT8mKkobB07rYNdSFTz8rYCbfm++DHhd8FRD21yLGl0V6zgr3HvRiUFSP3WLrw4K7yXy02uRU+XRiPJ9gaTYOU93Sl2Fu+oTu/5Y8ilTB3+eCn4KbyYkhBype7lAnZafArmH+dzJik+6aHwYk71dp0f8qHITfv2RflG3TZSV6AOqdR6WsMRAwrSE315wnt2Iyh+3l6ZyRiQd1H//i6IFgk7/GN2awkSCZqaTpftRd2XWQeX4iiBpHBJtw
 gzGbmI7k
 FqYmJBXXZEZhiO7wQxYeVJsX1Ahlnpcal+/VKLixJDMFndP9id/0habp0ktstavs/GrtOzBxNnGoOFQk8jcnFOZCa0n6BoMIM96YKf5/DLhmjaRMOnPzDKNZ/mwf32ZAvUk8AC2YJQ21F6eey59hpNyQDG1walfyFz9wndGoKIf4TM5ea5BR3UTsB0mnPJmsgU2jg/tXO77CTDhDHTvTZU3SvpiggBr0mJabSCZFa/UEOCFFNPGfxv5Ds+4t+3GRA8ArXnMgj+OjxzVKTUO5vbebRtARX8dq5ZG7F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 21, 2026 at 1:40=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Wed, Oct 21, 2026 at 01:27:22PM -0400, Pasha Tatashin wrote:
> > On Wed, Oct 21, 2026 at 11:25=E2=80=AFAM Tarun Sahu <tarunsahu@google.c=
om> wrote:
> > >
> > > LUO and its file handlers validate handed-over state with monolithic
> > > compatibility strings ("luo-v5", "memfd-v2"). Any change to a seriali=
zed
> > > structure, even an optional additive one, must bump the string, which
> > > breaks live update between adjacent kernels. Replace the string in
> > > struct luo_ser with a feature header, so that the target kernel can
> > > accept or reject the source kernel state per feature.
> > >
> > > struct luo_feature_hdr is a fixed 128-byte header: the serialized
> >
> > This patch is all wrong; 128 bytes is far too large. For every _ser
> > struct, we only need 8 bytes instead.
> >
> > The first 4 bytes are the size, and the next 4 bytes are flags (i.e.,
> > 30 feature flags + 2 reserved bits for flags extension). The last two
> > bits of the flags indicate whether an extended flags field is present.
> > Each extended flags field is 8 bytes, and its last two bits indicate
> > that yet another extended flags field follows.
>
> I thought we agreed not to loose the string too, it was a tree
>  string -> feature flags -> individual values
>
> The string is the emergency if we really badly mess it up.

Yes, we'll still have the file-handlers/flbs compatibility strings.

>
> Jason

