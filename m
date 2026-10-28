Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10887606A335
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 17:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LIVACHG1
Received: by kanga.kvack.org (Postfix)
	id 31F1F6B05B4; Wed, 28 Oct 2026 13:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0356B05B5; Wed, 28 Oct 2026 13:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E67D6B05B6; Wed, 28 Oct 2026 13:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFE686B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 13:17:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D545A1601B3
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:17:11 +0000 (UTC)
X-FDA: 85372690662.01.CF08395
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B25140002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 17:17:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LIVACHG1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793207830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05SG7gAJ008w03i9CCuLSraJDJiyVFmW6Oo7ipBrjbs=;
	b=Hu05T1x+mwo4442BSE0C4IKh5sLU19cRu4Nn0xtHpZmYPaKWVAEQvhiT2yH/AC2MQacgA4
	9QHc4nEYoUjL0eSOoyjGFYlPD3t8tnV2p6aDWBfs851ytqFUYtYKuMfn7zrCOafIS+z1xf
	+iDPmm37FZaanrgnrprfCjhhc9VyhCM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LIVACHG1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793207830;
	b=bE1bJzOqscHmyl7a2YDSv7JBMfefKZlYQc/etRR/Zqi2lOgQK+msyXuo4lmbZUKS3M4cUk
	1K7MQLdmLtoFIzc9e7KxO6xyPvIT4hEfyN2KX6JNcxUhbJjDOQt0p7ZxzzOq35uy0/yddj
	0Imo243N5kur5DDsdlSqB6Vhfe1zoYE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD3F9600DA;
	Wed, 28 Oct 2026 17:17:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A438E1F01828;
	Wed, 28 Oct 2026 17:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793207828;
	bh=05SG7gAJ008w03i9CCuLSraJDJiyVFmW6Oo7ipBrjbs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=LIVACHG1RijgMjCcG/Za6quG10uP/bwvgH9QE8LBE1Ivatgc9Gsxomr3AtpNUFPU0
	 A+6txV+JhFA/FQ9wi7C+7pWYpZ0e+Pc7WqKMe9jkABrVblw1ZFcwlZAztCqgB1P/e3
	 p9b8wN4tDVitUGLc/V+1hQT1NZFTVD7m3WdPU0oqKQlNmHSSGk9l9hK3CeTbNDWqSe
	 VN3sAKFewBC6xe0t5rYtB+sbuiw5e5lDQoKvIRxdjJ0DrtoKis23WnQwx7fOelIVvL
	 Atltab4Pstjrs4D4dYuIJSyaVZnuHq7QWlD07iE6RtqSOvkxEaO4SzTr/vUKZm0prA
	 whzCKqWsehupA==
From: Pratyush Yadav <pratyush@kernel.org>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  tarunsahu@google.com,
  Andrew Morton <akpm@linux-foundation.org>,  joro@8bytes.org,  Mike
 Rapoport <rppt@kernel.org>,  Pratyush Yadav <pratyush@kernel.org>,
  maz@kernel.org,  arnd@arndb.de,  jgg@nvidia.com,  robin.murphy@arm.com,
  loganodell@google.com,  oupton@kernel.org,  kevin.tian@intel.com,
  alex@shazbot.org,  dwmw2@infradead.org,  pbonzini@redhat.com,
  seanjc@google.com,  will@kernel.org,  Alexander Graf <graf@amazon.com>,
  Bjorn Helgaas <bhelgaas@google.com>,  baolu.lu@linux.intel.com,
  linux-arm-kernel@lists.infradead.org,  linux-arch@vger.kernel.org,
  sagis@google.com,  linux-mm@kvack.org,  kvmarm@lists.linux.dev,
  iommu@lists.linux.dev,  linux-pci@vger.kernel.org,
  kexec@lists.infradead.org,  skhawaja@google.com,  kvm@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 3/4] liveupdate: Replace compatibility string
 with a 2-bit pair feature header
In-Reply-To: <at-8vkVpN2SF3XgB@google.com> (David Matlack's message of "Mon,
	26 Oct 2026 20:49:02 +0000")
References: <atlKsD-aJB3mJr2j@google.com>
	<CA+CK2bABt4OZO31TenVF2+uBUWVwViWbvfE00=0xbAw=f7K9SA@mail.gmail.com>
	<atl7peoVHdP5hz7z@google.com>
	<CA+CK2bBFXnJA1kddbLKGq0DAHDgjYhsTSQQay-xeX7jJC1V_UQ@mail.gmail.com>
	<CALzav=e=ho2gVrn+7KpZ3ZyasvH2u15-pC-RSRSS7KcMfKqUJQ@mail.gmail.com>
	<CA+CK2bAJo8dnTOyKMgnnMnk-SCXbTsv+JCLEOWkjyj-wqtEkHg@mail.gmail.com>
	<atpNFEFIlqAoYIwH@google.com>
	<CA+CK2bB2C3Am5ssRuzYpfiU7_vB81vxMGc19HQLq7N=_7YrbTg@mail.gmail.com>
	<attmFVIFU_mS0Y7p@google.com>
	<CA+CK2bDXDWbww_d3sD6OZqpo37V1a3t76_ubbrXLQS=9DB3dWA@mail.gmail.com>
	<at-8vkVpN2SF3XgB@google.com>
Date: Wed, 28 Oct 2026 18:17:02 +0100
Message-ID: <2vxz8q3hoicx.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B25140002
X-Stat-Signature: 4utx3un5arer5h737qo4hopeoq1phedp
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793207830-849341
X-HE-Meta: U2FsdGVkX1/6hmZi6yw4LXpEbjcUvFlILTWNetUtDh580hZUMl4ieDqRBxCp5Q2vgHGPGjBz7bvITYVJZibRoryHXJKF9T3gPTwwDxkaZ1luCVv9jdLPLK0Ve6L+wL1Cydg99buIwmKy2cPhdrhZvNE3HCzYEEGxgeFrZZrv9N9lWhzZA+GKSJYCoR7jl8R7tr3hXDwj+oRnDuyt0ssFi5CThm0ov8TUPVgzJ3yn0pEbfqhl7IieEQMJI40psezn6QwLfa0IQehcDTBPRFS9QmDLpT9AbR1TftYAmtUO4IKOpPLAhchS9Y1hwaKSCRUTXce1hbkZ1XmI1cffjhnbaKG7vVqv4OWV6opX/n2xxr56CerDNjUSc6WBlZi2Le97omVNLfzLSVgETre5XIwLH14eSkWBNPLvm0hVHYEQAETjH5cwJwqfw8fVbrXzfJuo2fCPKiueB5KWypYJxMQzDckr6uhnZTiuHC7l0JvzhMsj3dZUukJ7ebM6oZOgu79P61zkMR/395G3e0yeHXb6aNRp74j6NqqZDm010xfDKG+BSQhFCI8ouc7/KOqlqoNXv5no2JAxAyIbMNA+dhMImhya+4LrX2Leh0wr2PA7iGMc37eJXGirLd6CbJmRZHXp3M/eayK0MwpozYdCDw+Lhg7VbD4NXhJtOgHwP2GOFo8oufwoGDeeE32we9m/SaD9DzSSSWfVUv4bYq+Td38E0szAptTmsqItVLs9bi4sd2MrQlpgfoZyk1kNOQDrhlgQ8hlZmNVfYj6EZNQZoXsueUhbGPJR91P8iCFkTPkE4UXN0RICuBWjtBS7Y3pGU8fWQgDNhDol+JXvlIfxNA0XOKcr5k9M3DlJTVbvgroUi92XhxLWW5KcJkp4gDGqpsQJYocWgbOONW2HPc1ylHVl0VVYJpnpAJbEAnKMOlKYH5qoRKTbKiuZI+8UPKXKIJOrj3zwRAaxPVSH2zP7uAY
 7cj1MJBn
 +xAcBkJAt5qIE+nIM4gP8H+go0MauPuXy3VEp6C2foXHPskQdvxajSjZMSSp3/JVJ+/5ExKHlaZpKYKs0VgtxSib0UrJ6h22vRsKsKMxnEOHyN3i2gMAUUBiYX6dAQ8L7yN77uBdzWwTvJRCjVecz8+qLQqcq/GQdYk2MJncaB3+zyM8iioHxzHvQlmCF7X84xWzRFvgIC/R0VDAo8IsnZp51BTXDYiftzPstjeD2fg9zoPMYP5lK2cEmVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26 2026, David Matlack wrote:

> On 2026-10-25 04:38 PM, Pasha Tatashin wrote:
>> On Fri, Oct 23, 2026 at 9:50=E2=80=AFAM David Matlack <dmatlack@google.c=
om> wrote:
>
[...]
>> The reason I care about keeping the header compact is that we are
>> defining a foundational kernel ABI and want to use this header across
>> almost every serialized data structure so we can evolve them later
>> without breaking compatibility. While some top-level structs are on
>> sparse folios today, other serialized structs are tightly packed, and
>> we are looking to add KHO slab support in the future where tightly
>> packed allocations will be common.
>
> My intuition is we will have a small number of headers per preserved
> file and per preserved FLB. One for the top-level struct and then
> optionally a few more for sub-structs like arch-specific data. That is
> why I am less worried 8 bytes per header, even if we fix the folio
> problem.
>
> Maybe where our visions differ is when there are collections of
> serialized structs, like KHO blocks. For collections I don't think the
> elements will each have their own headers. Otherwise the elements could
> be different sizes.

kho_block today doesn't store entry_size in the serialized payload. It
relies on its caller to do so. With extensible structures, this can get
messy. Sure, the owner of the kho_block_set can track the size somewhere
in its payload, but perhaps we should store the size in
kho_block_header_ser to begin with?

Anyway, not a problem this series needs to solve, but something we
should eventually do.

[...]

--=20
Regards,
Pratyush Yadav

