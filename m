Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDB63C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 14:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FFE6B00A4; Mon,  7 Sep 2026 10:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE85F6B00A5; Mon,  7 Sep 2026 10:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B25D96B00A6; Mon,  7 Sep 2026 10:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90A606B00A4
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:00:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07173A0190
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:00:25 +0000 (UTC)
X-FDA: 85187126010.08.8AF5111
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 271ADA001B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:00:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtOe0lI4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788789623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EgLK3o+julTVE6C/8v3utQVcxVTdU7XWXdzws8YaC20=;
	b=UhP7CTxFMCLHO/kD+IoT3/eGWS4wKDwml0RESwaGgBIdT5HrM96I1uRJneFt/3CYRtAW3y
	DTmzIURs6FaiA11ol6cctrEI2982xs+h3qcLTPbSKjUNFw1iBA5nyJuoCq4wZNuWcSrV8O
	HZSy2OB/jfWbGMVkoTCovh89ucRTAWE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtOe0lI4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of thierry.reding@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=thierry.reding@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788789623;
	b=aBRf9t9D0Acy+iGWK3ZD5dsmpUKz07XuYeWs/n8cIJk6pIQt2FrT30FxmIe2CqQUVDX3Z9
	eksImhNRpuKhZ1U30//6yPftripIDg4U5m/495LMXPIZ1GqYBK+LtdDqlwIQTAAAbyQPfj
	ZIUXqWqAvOUxa4W3sAzjNEav/VKTnkY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 476184086C;
	Mon,  7 Sep 2026 14:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985261F00A3D;
	Mon,  7 Sep 2026 14:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788789622;
	bh=EgLK3o+julTVE6C/8v3utQVcxVTdU7XWXdzws8YaC20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gtOe0lI4tICmFeXO0VXaSZWun1zD97NtGKzB00Fxz4Ka/Zpm56GHzGCFmpkzXvwya
	 IjgdW5ASTJB+qKa5sg3xhHy+2z3Tif4EUzgG6v2G0AqXAMe/0BNO4ao6/A+PGKiEDt
	 LiunuR042Q+3iJ1jf+LikMpBoAosls+iqBo1ld1uAEuNgD3FyixqBGd1NK8XwlELz8
	 0aXr47TpsMtDRS4WsQVvIrdjIekWTZVzwY14LA7ppw9cLIVA/gJznyINUg586mqoJr
	 i4bMWj2QqqCUzgdxYWZPl2+vXlMSa8ApBf/xkklnj7o+nTfBb5pP16MUu53RogA7JW
	 PhrukphYxcyLg==
Date: Mon, 7 Sep 2026 16:00:19 +0200
From: Thierry Reding <thierry.reding@kernel.org>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: Rob Herring <robh@kernel.org>, catalin.marinas@arm.com, 
	will@kernel.org, rppt@kernel.org, akpm@linux-foundation.org, 
	sudeep.holla@kernel.org, jenswi@kernel.org, mark.rutland@arm.com, sumit.garg@kernel.org, 
	ardb@kernel.org, david@kernel.org, danielmentz@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, op-tee@lists.trustedfirmware.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 02/10] of: reserved_mem: Introduce "ll-map" property
Message-ID: <ap7CAowlFTFhSFP9@orome>
References: <20260902104712.2399797-1-vdonnefort@google.com>
 <20260902104712.2399797-3-vdonnefort@google.com>
 <20260902172436.GB1440252-robh@kernel.org>
 <aplF4NaoFk73d-c5@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3ihzba4bzldpza5m"
Content-Disposition: inline
In-Reply-To: <aplF4NaoFk73d-c5@google.com>
X-Stat-Signature: qe58cn1daz13xw3w3x56fz3z8qfxs45d
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 271ADA001B
X-Rspam-User: 
X-HE-Tag: 1788789622-154867
X-HE-Meta: U2FsdGVkX18FDnYZ7sOEHaW7g1sozmykJokKTa4yOCR3X6RhqMvT7aPEv9pihI3RcLWI38LxJYydvNrWs+1NJtO25yunkTyODgjIa4n0QWnXC8IrD/r4HutI3vAWcHuXp5L1OEDLvj7Zv1NEnMslFhHgSyJ2UAgYcEFm/ssXjZMOaaFZDXfLn2PGC6L6Y+XW1ILjQlktQxQt9H2VyMRi2QvjH4BdNrBfxkdPf9L00U4/1d090cMP5Agi1Sj5detrSCDYYNf/0yRVoKus+Vn1dkcUe5Ap67Z/rnB1lS5ZPBr2FVdIWlJ88/Rie29meyVutsEPKjwPtGnsVfXRplCfjy7YikQccUh4Ky7APjLHD3z1IEA+O5YhhCEApcLrtavi4znsZPOUifm+7bNLUKGQtcIHLbuXuPZRbB7Vr5CO4H4JsJPR8fSDMpd3h1B95fNtSdRHxxnNszFGjU8rPPtzvAJcaf7W337aYhh/p5diLOeR279LazYce/oLlQU947wv7AtizOHtGHaK9xGdLO1oThnN2VaL7QXiYJ5G/AgdRhjZXx3AIJhAIsRhT+ceyWdrAMaRyYFJ2cnJGgsbfvmtc5xNhBwUxtVgsDrmaOm2YFwHGaR+/JZaWzRl8eVu8roo74SaB2yrcj03znPYhohfB+1+4Tq5Cbv1YzXaIELO5ROuCwkW8aRVP2xPOIeiM3ov3UgCuboKnUexn+dyYIvJtWcgcN4axaoixdx0au7VMxNe/bdPPEI04M7xasI8UWq/Z1xdvM+cF/CNIQIPR+8Axf5MpJW5ol/JyxA/e3u6PQoqUJN/82NRYIRc2fwfjxNptBkzzG+QpsY9RbNqWOVfIyhU4iWOlM956sCGJax/k9syL1Ur3jWwpFWoz4lTrndpXaiNUhTk8YsNfRAilMpXkCnpGSc03p9fnXCIiokDKqCr1dWtC1CqQwQ8jIItVYhLbr/R41y9GB3u7o+QOv2
 YTNPA+zG
 VxrKp9LrsMWANS8sfY/7sUR+7nQ8qtTHGR8VFh2Gk7ZuGlwhB8JD92DM8pXFVbEg+p4mupJYuQtnA0mXDqJRX/enAuN4DYRohriMSePeMoCB+/zL8BVs2P9q9hmfl3/cDdZSx9y5F0jEpIyOMSa3E8lYSD0M2z3CLBFGTvSd4sD6t4l3E+sA4kvkk7lc3/mnY19P22XnWfc+KUWvY1rb82S30cDUXphECRyDLvVykoAac9LL5XqtaLBkCS8ua7Bo5EBIUvZXPXpXtR8asP7VyRgPWlDhlKhnORo5aT9lcMy4pblKboFpzNbxKWTUs6smAbggotBPr0iHPdqoQBjSZQWBpcuyKW0Qx/+L0YOh0ddpqNl1z3veDsACpDsC99B4D+Q+bwHAUOkG+/Mfk6zI2NTgiOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--3ihzba4bzldpza5m
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v9 02/10] of: reserved_mem: Introduce "ll-map" property
MIME-Version: 1.0

On Thu, Sep 03, 2026 at 11:03:12AM +0100, Vincent Donnefort wrote:
> On Wed, Sep 02, 2026 at 12:24:36PM -0500, Rob Herring wrote:
> > On Wed, Sep 02, 2026 at 11:47:04AM +0100, Vincent Donnefort wrote:
> > > Keeping last-level mappings is interesting on some architectures as it
> > > allows mapping/unmapping pages from the kernel direct map without the
> > > risk of splitting blocks which, under the break-before-make rule, may
> > > trigger page-faults the kernel can't handle.
> > >=20
> > > Add an "ll-map" property for reserved-memory regions. When set, it
> > > splits the underlying memblock and sets the MEMBLOCK_LLMAP flag.
> >=20
> > Where is this documented? Any DT property must have a schema.
>=20
> Ack.
>=20
> >=20
> > Though I'm not thrilled about more flag properties. Handling all the=20
> > combinations of properties has proven to be painful. Can this be implie=
d=20
> > from the compatible string instead?
> >=20
> > Rob
>=20
> We need this before the kernel direct map has been created (paging_init()=
).
>=20
> I would have moved that directly into the driver lend_pool.c, but then it=
 is
> probed too late (unflatten_device_tree()).

Any of the node_*() callbacks from struct reserved_mem_ops get called
prior to paging_init(), so these could be used to manually set the
memblock flags in the corresponding drivers.

Thierry

--3ihzba4bzldpza5m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmqew3AACgkQ3SOs138+
s6EXOg/9GV2dPaIR220HG9xlVLIy2HRX3X54lD7NjYUcMI5dH74ozC8XZ0/nWFsD
64xYzCwkpDDlOUBftQPPgM44IfYfqHh4kLJjur9/fq03owom1beg4m9zIVIw4dBw
ejIByjlSLI0Jy0xt5eQhc9VfpkfrO5/Oq44bkGKeBtuPRefpomIIcSV5C/aU8QDa
cQv6aVjg6ZR2XncJrS3BA53s5Zc9Khwv7/O/Lb85rppj7aEHj7newBIEakVNB4pU
lmOAY1Q3ckSBZ4xZkjGPGOc9eSMxdpXx7JLHPERWIXTz9qdumMHpXKT+WXUpRtgv
cYT/O3KlrdSOC8K8t/2/lXVQ3J4HKSxP3T+cxvoWmkPHSeE4w17I9+62IhX0V0n2
E3mxg820SetJTFz5VJAXV8QeheO/ZGqieBraWwvQcyDmQnqKddmQdFd8EuqKusC6
M4vCBNFLt2/XEDoir9Q+3zqiDVJW32wMboSGe4P6VPhW8ojvOs43jE1owQRXCuOS
Z3gqcw1c0fcxuvHYTEV77UI0la6H5DeWQJWJiolfJs74swqdx9Rp9sMNlqvGcHdS
dRb5ltaA1WoYYMBhatF1gLHeFoZDvcOfmzF0dSNNEUXgR6g26s3Y5bbTVkB6+7cx
hSybBcQOnVt7rYODTdksd+66a8PcOeXTzpy33pFoG9LaH9wWFbs=
=iMEe
-----END PGP SIGNATURE-----

--3ihzba4bzldpza5m--

