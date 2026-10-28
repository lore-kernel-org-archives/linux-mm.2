Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50CD0606A322
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=nwIqSann
Received: by kanga.kvack.org (Postfix)
	id 5ED2C6B05B0; Wed, 28 Oct 2026 13:24:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 576FF6B05B1; Wed, 28 Oct 2026 13:24:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A476B05B2; Wed, 28 Oct 2026 13:24:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 18D596B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:24:46 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0EF4980188
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:24:45 +0000 (UTC)
X-FDA: 85372709730.28.1E2C735
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E439180005
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:24:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nwIqSann;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793208283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyXQkDiJLA3YYqZszI0OfYQ8KLsTyrFUAC1H8iKGZm8=;
	b=AAxm4Bc5DHSlC4Fuf/YwxmzHIGi5I7Wgh1o6Zl0y3hzRTqBn0aqmF6v6jkL7sa0ZMv4BCQ
	3H/+g2Jkit0ntpBI/JkJG9D3nLUWHxHmdGNkKkViQos14flA4bz8vp0gg244NCKyMojV3e
	XfUbvFh3j4Fy+dwdygF1nE+JYwlG4YA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793208283;
	b=NCItpg00zKzVECBwWSwTPT6KyOiSfQpbtLQ8yBvFwVALpu8sUJ9oqgFWt4uaMK5bsQ2+hq
	ZlgaqM7/3Log8WBgVfQd5OqvDDWkP/vM8wT6EyPYa+lye2Zo0+EFBxtNFq2sTOAwnSO8Da
	56VQd2GRSZZ4DDMiMbEoYARAjitxBI8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=nwIqSann;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-14fc585291cso1102405c88.1
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:24:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793208282; cv=none;
        d=google.com; s=arc-20260327;
        b=AOwdTBSFYYHFjl42BnfyC5p5uwKr2kZwfpvziM7Zsu/cH++23ZkQWjVz6h4oruiCYW
         tDJKpV2/8doUabpms/rlBrHOqSuz0TgCppvo/YSTaAAH+4tsR+7kV87hEV/aYlIn8GE0
         GbdbxN/rxgaryJI16kZc6+jkUV/AlZTklqeEPOudKt9DMzKWSNXoIhJn3ngzkSrNmHx0
         nsrw4MMR4phxNXJclyaBBw3VnsIS1Zd/0vGBPHcwSlsuBkLBUmCTgAokRsvLUzOZYUBi
         mQ0pFpcV5iDErpvWCf2sZblH7Bh21ThdTFETGx0T0/o0PHciSKgsklZYw8lAswe6e2kk
         rvDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xyXQkDiJLA3YYqZszI0OfYQ8KLsTyrFUAC1H8iKGZm8=;
        fh=HZWdKCZPmvrXy1myKd+Z5xmKNl9dMPLdDeg05mtgCn8=;
        b=jzlPV6+DzBYarHCOgLzJToApR+AEqUkh6T5MagguTWrEB51sPFallYKxFLVSX5YLkb
         01RoWQnief1/Bi6ND8L44+N0pMVk4QV3NxTR0YfHBRxCFqUD74mmfhKxoALadZ5dCqQe
         FL7h3wi2QPKWMoWDpWi2kF0TLoklnD6OeinEgbpbrntmD6nSMO2GGR9utbexb+k225Rc
         WAlTkGOl9yLZoYjH0zFJuF5X0RRsIlySX+wouwNZS0+t7aWGHL4lB6nxebvx+Jjftvdc
         yTFR1Xo5rOW3mYWU2Dht7SoD22IG45MrScf+rp42JoPFO/oXOg982HEpMFWU8CtwDB9F
         ZyKQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793208282; x=1793813082; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xyXQkDiJLA3YYqZszI0OfYQ8KLsTyrFUAC1H8iKGZm8=;
        b=nwIqSann/wGQkJo2vMbgoetfZGKp7Q/Nk2HoAq/k4GEIp/CaHo8vUNdzO2QS4OjRMP
         yCRI1pLenERRG9401jEE6hHN7qya9pZ0gTwPNwNzTicVFz/VniyN1szfZWsJWg+Dwva4
         WfkhAOpAExJcPxJfrePU78pBhYdOztamNvw2terKZjoeeVi/djVg4OYfOoMlzms8WDEb
         b3a/WKdISTZQxnxNJCf/JgNh6gEzW3ZDVGXaHMH9n53g6k1Y09UKFDe6n9icFA7F5wvZ
         SPdnGwTBkrS+SvA4aBkcbwb95cWPrNQ+4Uufe4wPnLY/gmdFan5G7vACoIPKItTi2QM2
         nx3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793208282; x=1793813082;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyXQkDiJLA3YYqZszI0OfYQ8KLsTyrFUAC1H8iKGZm8=;
        b=GFtvRey+mmitULrI61hkdznPffeoQBwqL5jyxZcsdNBdv+QeTbtI0XwrhQ09nMX1yz
         sKlS43K5V6Tj7mAPwyJFI3lumpmpnvPTB4fAu9I1DgbSzOennaR26yBSjZWmBHRJflKc
         FKHh0108nxbhGInBEbT+5dZc9KoZ789B5+VFpLuI988VJcPAKWu68FFv6C854sg6Su+C
         mMQgzbPxBZIUnVoEhy8FWA3pXi/Yf5cOeEb+0RAn8uB4VqcZrovPJuLJzPgaV0Ac4SiK
         foXK/bnWhi5LRg0Qw5iCPcQX1RqVvBtkqeTPaAk75mLv++gqFil/smil7PMUssH6f4aa
         52yA==
X-Forwarded-Encrypted: i=1; AKwUvByS3XiRtfz9T7M1vxlH+uZWi6KOgLSPJmjueSEaWHhcEsUvq9tV1XZB6w4hKej0Fk/hUHlT7twIiA==@kvack.org
X-Gm-Message-State: AFq9FYLucqFIfu5V0ciFDnQBdBrs5d7Egu+B1FPdtWSG21XueK5hSJlf
	9sEFRIwefm3vPvn+nNWjdgwPrfGz/k3oeYvS6tw3RmEkgY5hd1DVTGbWb+vLMBfaNGbnKQBQvKE
	MfVy5fo9Tzup3uLerY9GvKWgZ4c0tnmcsFNoITPM4
X-Gm-Gg: AYBFou3g/QvKJKTgME0SQ+SmKiJ6WGdhMq6vTyeERDu6oHsYakD1KXlfYE4XYWofxaT
	/cWXXqUE/oRnSOZDvlX9UsYT0qtfQ6ZBFOt8cwTB2Uzmp0P4z27DTqqV5saW0Ld/R+Bz1myUJfJ
	usip9m9eJZsYaz8ijZp3HiznB8/Uw+4ltH88ZIMSTWywBrBwKeUbGgVkXC7BgWw2IzXHGo3CRBX
	LMDy5f1npjeqNVgeDdmcybF6m2cBXWvdNIi5+JEXGKqHkUB4bRjFVQ/BYhk5vTFRUT6xeWleGDt
	NeuBSMUoI93swmmEFjknuXwBJ5MYckQQfssNEtKcaQy1UY3BFOnlSnbD5R/Z5vhEcLqZtnGfcUh
	+Y+AR5I6spUenQ6HKFZZdOoO+vlAT+2eN8iLRtw==
X-Received: by 2002:a05:701b:2813:b0:143:6525:f9f6 with SMTP id
 a92af1059eb24-1a6cd3a1575mr3454907c88.13.1793208280541; Wed, 28 Oct 2026
 10:24:40 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <atlKsD-aJB3mJr2j@google.com> <CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
 <atl7peoVHdP5hz7z@google.com> <CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
 <CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
 <CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
 <atpNFEFIlqAoYIwH@google.com> <CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
 <attmFVIFU_mS0Y7p@google.com> <CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
 <at-8vkVpN2SF3XgB@google.com> <2vxz8q3hoicx.fsf@kernel.org>
In-Reply-To: <2vxz8q3hoicx.fsf@kernel.org>
From: David Matlack <dmatlack@google.com>
Date: Wed, 28 Oct 2026 10:24:10 -0700
X-Gm-Features: AclHuK8mtDBrFSk6j3m-QjfmBC0Hg3WdAbJ_jeR4OTytlWOkEsZuDbAniPHpdm0
Message-ID: <CALzav=eG5j2n5omO2Mxqw8xA4sZLduxdbBYFcnHpPn0PDpt9Hg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string with
 a 2-bit pair feature header
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, tarunsahu@google.com, 
	Andrew Morton <akpm@linux-foundation.org>, joro@8bytes.org, 
	Mike Rapoport <rppt@kernel.org>, maz@kernel.org, arnd@arndb.de, jgg@nvidia.com, 
	robin.murphy@arm.com, loganodell@google.com, oupton@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, dwmw2@infradead.org, 
	pbonzini@redhat.com, seanjc@google.com, will@kernel.org, 
	Alexander Graf <graf@amazon.com>, Bjorn Helgaas <bhelgaas@google.com>, baolu.lu@linux.intel.com, 
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org, 
	sagis@google.com, linux-mm@kvack.org, kvmarm@lists.linux.dev, 
	iommu@lists.linux.dev, linux-pci@vger.kernel.org, kexec@lists.infradead.org, 
	skhawaja@google.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E439180005
X-Stat-Signature: t89tucnambbrujwttdycy891ofgncmz6
X-Rspam-User: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793208282-763248
X-HE-Meta: U2FsdGVkX19kPsdc0Uc0bPrWoWP5isrsWDPmxdG5Y1md1UX3LfZNcyYaXognPnevRtJKSE2Nph5TBpAu59l6xytarZfAw+yha/KzPHPykOmHqpvKtyp3k/cufDWip1OKp6CeFGoHeiIi+ktPuS9FVvIHm5nnMknbfMLi6HNV/NjOrDnYVeVVeeZYSePKkwz8usxTdxr+uVwu1krPvtZPeYjfEhOI1dJYUkJyBniTF6BhHWkONvjWs0y/OI9cK9su0gPc1hUhHZtDAmvac4y7TQc9GsVHDJOHXrcozxBjCn8aCwqK6pzVQi6w5Zz8l5pdvmbmq/9GfLaZd8RuOfTJ4gXjSh3lfkdrmyLWC/POkNkj/hgHThpLKqSgVa31tuCuUU1GSvQTn2RyaLzTc4ZwSg+HHruUm2cdZgQYCwQwnU2S1GZRfGirXIPo95u09Tx2Qvxudw1dnsLFiUcvDgaIszKPGNI7tVHcB96nwc7wn37Wb/CkAHtiXnP27qracgDcoS2gXHbg8ff/bg3s/1FPlNrfhrTc9jl3I03Xy0fNSNI72tjGjQyz6iAe5uDq0K6KIhjB6VgFHWA0q6b7DdT3oqNu3Fr/f9C87IUgRBNNqp+f/4Q2XR9RhyE79+x6esgUw+SkWTfpWZDVn8wrEudG1TCSOw2VvJaz7PPtOU8+E5FLy1KfmM7203qlHrVI6i9uN/9K6sRcj8FhV1uBk7GJaUZGby2TiIQ3deqZen/9SDVfXeH3cbaJSuoh+4tLm/vhUX+PpKLvmp2fmjVfswlSsnMzDs0gVMICbfnu8vTKFoTpTEFjjZvQMeOjy4LVeYF5nr10tElt+KVdkNtAkE9Vo8tFWxHcnl56vcHVfC9l6HZRnqf+ToXL/Em70Smp69r7rEl5m3y7x+ZJ+EPK6E7K3t8STwzOWxcVggh8JaiB0s+IvLiFSp/+f3ek0z3Afo4yYq0Ul46sBVSYlLAgaRA
 CRzD7hI6
 ZCIzEwbgUzW7k4MdGoeNnOqx1fTNl0aCP92FGrVy3PfPin2adXIUkAxtXsnLyyfgqomoi8C8xWOiZXOu/j+I2+qLT3wc4f+kbYdqvqGpbB9rHsQGBpw8Xw9blEqjQjGF0zD9kvvg4jKZZqUWDzZiUTFyI+5g0H8c8p3Ir+ATblyzVLvRYcSSRpHd4I4ctqGf3PlPzS91FnxnVlz7t9n1uMjaK/+FtfnPaVeq3AB60beVshVw1ALsKNcSG16dGk3vWTtxH/6ROQNQ8gSnICR011Gx8cLGs3+zawYIS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 10:17=E2=80=AFAM Pratyush Yadav <pratyush@kernel.or=
g> wrote:
>
> On Mon, Oct 26 2026, David Matlack wrote:
>
> > On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
> >> On Fri, Oct 23, 2026 at 9:50=E2=80=AFAM David Matlack <dmatlack@google=
.com> wrote:
> >
> [...]
> >> The reason I care about keeping the header compact is that we are
> >> defining a foundational kernel ABI and want to use this header across
> >> almost every serialized data structure so we can evolve them later
> >> without breaking compatibility. While some top-level structs are on
> >> sparse folios today, other serialized structs are tightly packed, and
> >> we are looking to add KHO slab support in the future where tightly
> >> packed allocations will be common.
> >
> > My intuition is we will have a small number of headers per preserved
> > file and per preserved FLB. One for the top-level struct and then
> > optionally a few more for sub-structs like arch-specific data. That is
> > why I am less worried 8 bytes per header, even if we fix the folio
> > problem.
> >
> > Maybe where our visions differ is when there are collections of
> > serialized structs, like KHO blocks. For collections I don't think the
> > elements will each have their own headers. Otherwise the elements could
> > be different sizes.
>
> kho_block today doesn't store entry_size in the serialized payload. It
> relies on its caller to do so. With extensible structures, this can get
> messy. Sure, the owner of the kho_block_set can track the size somewhere
> in its payload, but perhaps we should store the size in
> kho_block_header_ser to begin with?

+1000

KHO block should track the entry size automatically and not rely on
the caller. Otherwise every caller is going to have to store the entry
size in the struct that owns the KHO block, like I had to do in the
PCI v10 series :(

> Anyway, not a problem this series needs to solve, but something we
> should eventually do.

