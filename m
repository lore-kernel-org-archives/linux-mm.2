Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC306C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 18:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9521C6B0092; Wed, 16 Sep 2026 14:58:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902CC6B0093; Wed, 16 Sep 2026 14:58:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F18B6B0095; Wed, 16 Sep 2026 14:58:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 565ED6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:58:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E5AA0407FD
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:58:49 +0000 (UTC)
X-FDA: 85220537178.08.7A95E1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2B705A000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:58:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpKfeOdn;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789585128;
	b=YDJfp0/CGGL5B6GI0kcQtYgRbzmM1sBfN2VejUxcBDq96ypacWchg6b7iFLLHs2ZpzdCaS
	AmIp+wOIYivkpPdV3T8rpqJBvsABkrob4nk5PipldKIEGWfP3FPuhPyDRn6rvLzAqxIDZr
	dTRHGHwWt3B1BnYUSOv6OV8aj0MV3MM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dpKfeOdn;
	spf=pass (imf15.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789585128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lSvr0vCtdCumQova2+QTaGAW1CeluERBIU1FmP9NgV0=;
	b=r5vwF33K2ZLT+uPq/JSfK5sGi06lisiFDR4w1m419/+nGt9TLXi8HW6ZK0Q79Q+hPms9dx
	a9I5yHYsTKDuCDE+Om1MLT8dVdPVG3vSliTQ2+1mGDa9ajJrkgiIlIkoqT4LyQHctkytuz
	Q8DHiUtbgOd38tITSEKChdPDvEs9gJg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D9A1419C5;
	Wed, 16 Sep 2026 18:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 575CF1F000FF;
	Wed, 16 Sep 2026 18:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789585127;
	bh=lSvr0vCtdCumQova2+QTaGAW1CeluERBIU1FmP9NgV0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=dpKfeOdnhJbQOBnw3SyHypTt1bwo3khu9OjlnaFMto0eI+LryvCcytPSjazdhOHUR
	 s4du1cwq3DXECxApHbs7cf/wMeptDnEdlt2Pclae5BtOwLmGVkqOmtMcI0ZzkNUwTL
	 9YWSexTWum8n8WNCqEbnlTR40tO0Qrml0kRiC5M5x+wSbM14AnTazL5yCSRNfjugqy
	 JCXx1cKYMi8Z3Tti0pRbkYFQY0g9nmG5XSSThdECoh5+J5VCB4MTJdVcYvfjECDfap
	 FnkMzxpiuQfqYa0TZAX1sbBJEKIfu8jryKFSikfQZ4dfSWI8Qw0+FhRqLQhSc0p5xy
	 mjrO8itBp9hWg==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Zhu Yanjun
 <yanjun.zhu@linux.dev>,  kexec@lists.infradead.org,
  linux-doc@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  linux-pci@vger.kernel.org,  Adithya Jayachandran
 <ajayachandra@nvidia.com>,  Alexander Graf <graf@amazon.com>,  Alex
 Williamson <alex@shazbot.org>,  Bjorn Helgaas <bhelgaas@google.com>,
  Chris Li <chrisl@kernel.org>,  David Rientjes <rientjes@google.com>,
  Jacob Pan <jacob.pan@linux.microsoft.com>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Jonathan Corbet <corbet@lwn.net>,  Josh Hilke
 <jrhilke@google.com>,  Leon Romanovsky <leonro@nvidia.com>,  Lukas Wunner
 <lukas@wunner.de>,  Mike Rapoport <rppt@kernel.org>,  Parav Pandit
 <parav@nvidia.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pranjal
 Shrivastava <praan@google.com>,  Saeed Mahameed <saeedm@nvidia.com>,
  Samiullah Khawaja <skhawaja@google.com>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Vipin Sharma <vipinsh@google.com>,  William
 Tu <witu@nvidia.com>,  Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
In-Reply-To: <CALzav=eBXsaZKNv1SNtuT9F6aX_2TS3u5kUtko5WMv2NWt3e+A@mail.gmail.com>
	(David Matlack's message of "Wed, 16 Sep 2026 11:31:17 -0700")
References: <20260728221007.2098560-1-dmatlack@google.com>
	<20260728221007.2098560-4-dmatlack@google.com>
	<e099cbaf-3185-4c39-ae36-7f0e074ebff7@linux.dev>
	<CALzav=eX0gVrbWCnYGwfqPHUkoVxqdr2nw3Tx6Aqze0XOcuwzA@mail.gmail.com>
	<2vxzcxud6ol3.fsf@kernel.org>
	<CALzav=eBXsaZKNv1SNtuT9F6aX_2TS3u5kUtko5WMv2NWt3e+A@mail.gmail.com>
Date: Wed, 16 Sep 2026 20:58:40 +0200
Message-ID: <2vxz5x056n1b.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2B705A000C
X-Rspam-User: 
X-Stat-Signature: pwc14j73iymh3xhdbngyr9mstnxpw6fs
X-HE-Tag: 1789585128-165594
X-HE-Meta: U2FsdGVkX19v4wwcJutOHP0bu9YdyAyNsL5QXsnSfmaq8OW18rw6rNceyUvBxboUSUnyRwPWp0SAc8XTEgJS27QuZTmLcy6s2xOn8pnSmu+qgflyTlXuRx1rxv++SEl27YUwugvDQ1D2HHnXU123zU3vEuxlVItftsbqEsukTq+cnhMApw70Cle9fAbOjRknP3WaUq35eNGVf4FgPsKZnrsXcPpZ725co1mifErkDJ98+s6paqYzwvBMz+RpwdYIaQxPw/lTJgw1km2Qcaa3ZSOI4gn9OHh6f2ewBLGG63xl4hivSWwHE5AnkanwhrKr3wzZZcD6W2WltzGZp7wF0cPcxa6OAJmslULqmvcs7765fZ2o0O6GLQNwGlMhnK/n7kKRBNirlX090aKX1hSFWF1iOUbx9L3sSs3SDsDgcK8mw1HB9GtDlqS7wZXRXCcVBhYvrkK5JTs7M6QtQBEzUjcMRUFS2wBlXeSjAVQUDAUGEHbyoJGzvYw32hWdpZSA1qHGcUdoTtqXTuv12mEu4uLzB9Wnd+/x4wFpCjOMuUxaMKGIBG9HBefl1fUXEUzUCNMwp+1bwIK4X+ZLnDF1oPyeNb8XbHydB3Ccleixj3HxOcrgF/opfht7y9HQAzDjN674CxFzRmXJnW1yxxmpXsC3CTzSRhBb1IJOF6ybPE7aNc2xrQ5bnwO9S4pilbpriDBaaBb7VGeXnaLULHG9eB/OOSx8wbQHnMEqXInq66gPwwqdfkoZ4lx0s2CcONoKIdalcvV/1PO8FixTANYDeecFUp23HX1/+Ke52ZX5NiEbyRKjXfp4zS1YGqDiQYHSmdRJhbYP+dmdIl08P2GheHN6YWcyF/e2PCbxg2lL+D5G/CXcf18M/hfXvj+LLFsGfLmSjuTWo1DySApu7ulbqS4MewO8rshEs4/GVb1Zfh1agi5zCuOrJR4sKqWyMHV6yIL715ygAtwp4BaG31G
 kdPHD2sa
 UoZTw0Vo9NWdjYbY6mG+bM/qPxCn2zrrn+KM/5X5ckbVgxTI04Xsw51zX0xGtKJqa850C+mgUyeBPQ0O44V7Wqm36tXVQMgl/gAHIPaGqscVMnilP3Cn/1xI/9nAq8wThm15aol4mB5yXLzUThjSJIXi89S2nwsho+APL3hnf84RfiuRXZlZpg/IhR4IvCca4iICyxzlNLu5opd4OosE60HRP+acThX0s27hzvCDikSkl+x8VEDlRqyCbAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16 2026, David Matlack wrote:

> On Wed, Sep 16, 2026 at 11:25=E2=80=AFAM Pratyush Yadav <pratyush@kernel.=
org> wrote:
>>
>> On Wed, Sep 16 2026, David Matlack wrote:
>>
>> > On Tue, Sep 15, 2026 at 8:31=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.d=
ev> wrote:
>> >> =E5=9C=A8 2026/7/28 15:09, David Matlack =E5=86=99=E9=81=93:
>> >
>> >> > CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so tha=
t the
>> >> > domain and bdf can be guaranteed to fit in an unsigned long and be =
used
>> >> > as the xarray key.
>> >
>> >> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
>> >> > index 3781e2b5f095..8af20f558086 100644
>> >> > --- a/drivers/pci/Kconfig
>> >> > +++ b/drivers/pci/Kconfig
>> >> > @@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
>> >> >
>> >> >   config PCI_LIVEUPDATE
>> >> >       bool "PCI Live Update Support"
>> >> > -     depends on PCI && LIVEUPDATE
>> >> > +     depends on PCI && LIVEUPDATE && 64BIT
>> >>
>> >> One question about adding 64BIT to the dependency:
>> >>
>> >> As I understand it, enabling CONFIG_64BIT essentially means that we a=
re
>> >> building a 64-bit kernel, and a 32-bit architecture cannot normally
>> >> enable CONFIG_64BIT.
>> >>
>> >> If that is the case, would depends on 64BIT be necessary here? Or is =
PCI
>> >> Live Update already inherently restricted to 64-bit architectures by =
the
>> >> existing LIVEUPDATE/architecture configuration, so that this dependen=
cy
>> >> would be redundant?
>> >>
>> >> If this problem has already discussed, I am very sorry about this.
>> >
>> > The necessity is that the PCI core needs to store more than 32-bits in
>> > the unsigned long xarray key (see the snippet above). The dependency
>> > on CONFIG_64BIT ensures that unsigned long is big enough. We could
>> > probably remove the dependency but I would rather wait until someone
>> > with a 32-bit build has a real use-case for using PCI_LIVEUPDATE
>> > before putting any effort into it.
>>
>> KHO or live update themselves don't support 32-bit platforms and there
>> are no plans to do so either. So I don't think you even need to have a
>> dependency on 64BIT in PCI_LIVEUPDATE. Only 64 bit architectures define
>> ARCH_SUPPORTS_KEXEC_HANDOVER, so PCI_LIVEUPDATE and others indirectly
>> inherit the dependency.
>>
>> If you'd like to be extra safe, then probably you should add a
>> dependency to 64BIT in KEXEC_HANDOVER directly. Though I think that can
>> be a separate patch independent from this series.
>
> It should be in both places then. PCI_LIVEUPDATE explicitly requires
> 64BIT for its own use of unsigned long, so it should have an explicit
> dependency. If KEXEC_HANDOVER requires 64-bit for its own specific
> purposes, then it should have an explicit Kconfig dependency as well.
> That way if and when someone wants to add 32-bit support we know
> exactly which configs need to add support.

Well, I don't think we are ever adding 32-bit support. Most 32-bit
support in the kernel is being deprecated or removed, so I really don't
think it makes much sense to extend KHO/live update to 32-bit
architectures.

But anyway, if you'd like to explicitly mark PCI as needing 64-bit, that
sounds fine too in the very very unlikely event we do add 32-bit
support.

--=20
Regards,
Pratyush Yadav

