Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E655C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 18:25:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E947F6B0088; Wed, 16 Sep 2026 14:25:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E45FF6B008C; Wed, 16 Sep 2026 14:25:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0E846B0092; Wed, 16 Sep 2026 14:25:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD6D6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:25:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F325C1604A8
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:25:22 +0000 (UTC)
X-FDA: 85220452884.29.29435A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 44B3020002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 18:25:21 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2xA7D7z;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789583121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Va42xDUxw3Ha13QgHOlSJnNxTf47U1kOlLIt+P89At4=;
	b=rVIHHrLxE1lqP86yhwY+aBNhuR0QZo9BLeqnqvM4/aPQso5bI8M6oR+rSTVmnC7scfFomD
	MflzBV6eT/frILhRo8z2/RcN0Q5vbPPgF4HJ8HpYTApWaJvmSsPI8IO+Fo+ZkoAZda7jYG
	dkTSHWjMRTKhsHWbThj8X0uQXJy11ik=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=P2xA7D7z;
	spf=pass (imf03.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789583121;
	b=TXkaJCwfpaTg0dv4H+aZVfkoYuC3voNA4RL+4jXY4xYz5lkj82xeHR6LfgEwpg6g0On660
	VTwBaHDidrX3hHUbNSNNrKxLw4Sy1DxR/KuR595rSeOvW0Pir+kAc90CDcZps28lCCltek
	wbl8GfshNr72ikZJc/R6ZQBjVXzqa3w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C4B4F43E53;
	Wed, 16 Sep 2026 18:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE651F000FF;
	Wed, 16 Sep 2026 18:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789583119;
	bh=Va42xDUxw3Ha13QgHOlSJnNxTf47U1kOlLIt+P89At4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=P2xA7D7zGPKwhboQgFoFmwpysEtGxI+V2h2GSj6IA/YgBa85bMaQLxzaFxULINGed
	 AEtc+voU6gqXMDlIskNI09FqisQhKRMmOWkHdE/pPbS4SJuP5YF0zkGANb07pGkKVP
	 qqfO/yR7DeItPjTJiYP+hYLH9jbp4YLqDtxavkvkfhVzgCWjsJYlV5//6kBpAC+Imm
	 BzUA36PrUrZwSPeHUiUOhw4Tvq9qAJ+G0AstgyZKggDzIiowzZ/GoYjNGP6iEhFzM4
	 4g4Q2Mc5YTibk/b+yFZDTdx+Uz5RgNDkfi244moTiPV8DsAQ1jLin/jFLYmuX5gUz8
	 OQPGZJUyOVkPg==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>,  kexec@lists.infradead.org,
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
 Shrivastava <praan@google.com>,  Pratyush Yadav <pratyush@kernel.org>,
  Saeed Mahameed <saeedm@nvidia.com>,  Samiullah Khawaja
 <skhawaja@google.com>,  Shuah Khan <skhan@linuxfoundation.org>,  Vipin
 Sharma <vipinsh@google.com>,  William Tu <witu@nvidia.com>,  Yi Liu
 <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
In-Reply-To: <CALzav=eX0gVrbWCnYGwfqPHUkoVxqdr2nw3Tx6Aqze0XOcuwzA@mail.gmail.com>
	(David Matlack's message of "Wed, 16 Sep 2026 10:28:52 -0700")
References: <20260728221007.2098560-1-dmatlack@google.com>
	<20260728221007.2098560-4-dmatlack@google.com>
	<e099cbaf-3185-4c39-ae36-7f0e074ebff7@linux.dev>
	<CALzav=eX0gVrbWCnYGwfqPHUkoVxqdr2nw3Tx6Aqze0XOcuwzA@mail.gmail.com>
Date: Wed, 16 Sep 2026 20:25:12 +0200
Message-ID: <2vxzcxud6ol3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 44B3020002
X-Stat-Signature: 345n6x5knjrs6bnrutz1f39j4nmcgqiw
X-Rspam-User: 
X-HE-Tag: 1789583121-545281
X-HE-Meta: U2FsdGVkX18y3BYBdqZY2LqvY10SuhSG84FCSdDJgPf/K+m88oK3uwzfyHetz27cjNTD8csL7+oxuvaCJOwCdWLPJkePT6ZcPnF2Ol2JnkAB4bsKYxs+Yca5uzQjXZIzdDf9McpIzezYksO/oHCKY18sV1qUwSp1gLcLVwaE+xSq3Q0FQn9JafxlkouPCdrcj+T/e85jAVzg8qQOHnSPVUzJf47Y5bPqnfZlSfochx6b0IlhWEMx6Y4kSGMCHK6J6RxiRCUdShCpTDgHSZ7ELZEY/QHiXSt6YJpOPVzIz/XaGIuZNdrX26IW4uAEKusp1GVB1u34uTlLfNOQBxqoN82+CdbzbfS8ISH8AIKr04soQRQALup2GGyear8qWxF/7UGE0gfwI0PJ2jQp7RKdMBA4XwycpkRZAFcW794DXawFwi4cBAEvtpQHyhB9ZU3uHSO3aH11bm6QWN8D8IN4mULOGyv6Y1zzbtvcZbWfCF09oialrz6bIx1AI2Bpz0ZKrnK7E722ZienPv8QtoDbMiRPKowYdZzRf/GTi3VcZvYRECDKO2+LtSu7zsn3Q1HFLr5U3PmV2Bi/r6Kc+RCVRe+NryLxyJRWMFGrNvkJxYmmnNHCDglaMV5faVA8YGRUW8y8KS2+4JDIzAWxbxLDT8sB9/VZ8N1UX7/TlOeD42lGS7tHa6frD8i+wXtXwHU1Z0SUki34/3JC+w0LdjPGrrdS8mOHOil3urYA2li0r03xiun4CzEPWmgpTn56PjobTlRxmhEfizkVjNZMcGEg6QiTTJ3KTg9CyTWM2tkjoE9iN/b7hS0bRdhvf9sxHYPpWP3Y4wD35DsySzufxFgSO2uflgaZbqoBQKy/mFjtgVXHYPuBqgD+guGRnJ5Koy7llaung8zgNOyT3sWBBVzD5DidV1cFI5jH/8ZhwRSiAB5ani8dMkPX/lz9Sn9A+JmBYuNsxP7AaAVzj3gAUN7
 /Eac4mfd
 f7LzYEF820xKORCu4vNof2YNwFIzyJ6Mj62o/amWsm/X8sSc/f6NQ8GmT+GvShlE/fPMxYbjlu9e0SnuxBSX3v3u7R8RYYK3ZRGto8IW0yg5DTRh2O/WsylksSxuJCxgKPJ1IwjZRYX2Q63Iw4trXUcOVf+oxxWzzJDyTYK4OKW7bwr6XDqKwKzJpkoKJ7LCsVD0HcPdYaNt0/25zh7g+Ldx4iPr6hTHFwu8b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16 2026, David Matlack wrote:

> On Tue, Sep 15, 2026 at 8:31=E2=80=AFPM Zhu Yanjun <yanjun.zhu@linux.dev>=
 wrote:
>> =E5=9C=A8 2026/7/28 15:09, David Matlack =E5=86=99=E9=81=93:
>
>> > CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that t=
he
>> > domain and bdf can be guaranteed to fit in an unsigned long and be used
>> > as the xarray key.
>
>> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
>> > index 3781e2b5f095..8af20f558086 100644
>> > --- a/drivers/pci/Kconfig
>> > +++ b/drivers/pci/Kconfig
>> > @@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
>> >
>> >   config PCI_LIVEUPDATE
>> >       bool "PCI Live Update Support"
>> > -     depends on PCI && LIVEUPDATE
>> > +     depends on PCI && LIVEUPDATE && 64BIT
>>
>> One question about adding 64BIT to the dependency:
>>
>> As I understand it, enabling CONFIG_64BIT essentially means that we are
>> building a 64-bit kernel, and a 32-bit architecture cannot normally
>> enable CONFIG_64BIT.
>>
>> If that is the case, would depends on 64BIT be necessary here? Or is PCI
>> Live Update already inherently restricted to 64-bit architectures by the
>> existing LIVEUPDATE/architecture configuration, so that this dependency
>> would be redundant?
>>
>> If this problem has already discussed, I am very sorry about this.
>
> The necessity is that the PCI core needs to store more than 32-bits in
> the unsigned long xarray key (see the snippet above). The dependency
> on CONFIG_64BIT ensures that unsigned long is big enough. We could
> probably remove the dependency but I would rather wait until someone
> with a 32-bit build has a real use-case for using PCI_LIVEUPDATE
> before putting any effort into it.

KHO or live update themselves don't support 32-bit platforms and there
are no plans to do so either. So I don't think you even need to have a
dependency on 64BIT in PCI_LIVEUPDATE. Only 64 bit architectures define
ARCH_SUPPORTS_KEXEC_HANDOVER, so PCI_LIVEUPDATE and others indirectly
inherit the dependency.

If you'd like to be extra safe, then probably you should add a
dependency to 64BIT in KEXEC_HANDOVER directly. Though I think that can
be a separate patch independent from this series.

--=20
Regards,
Pratyush Yadav

