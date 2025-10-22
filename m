Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE97ECCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 21:11:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23D388E0003; Wed, 22 Oct 2025 17:11:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2145E8E0002; Wed, 22 Oct 2025 17:11:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1515E8E0003; Wed, 22 Oct 2025 17:11:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 016988E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 17:11:21 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A6F6713BF33
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:11:21 +0000 (UTC)
X-FDA: 84026995962.09.35FF320
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F0CED40008
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:11:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WB/NSEOY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761167480; a=rsa-sha256;
	cv=none;
	b=MKXKuymjTAB1GvyAf+2mgDnHzQChSRrrIbMMSqOaxzl7ousRMF3Qp1zQTBpqkEgVoKEvz2
	N0aitoxm0hUTbgMg9QgO9/Vj6XRq6qwYGbxRzCO2cph0IKGqJ95PyhiESGlI8xkW2n5pN2
	oAylTnC+6STgo4bwh3rn3i/5y/L+C+c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="WB/NSEOY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761167480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5v3JRmduY4uSzLf2Pqm6596Of3Jc6oNa3Sp1BFVrPsc=;
	b=J4/2FRsH6ZsfTTUpSC/zxx4A1MR49OyPAXg+rbHl8V1I4CQ+318MsVskGZvEf/eDeA4xSa
	pU+q00Z3Wk4E8YJ53GDPOaoaST+6qE2TZzolj9B+k/xcvSv9+0000By6hNDt86rxpABfVn
	tHEddI+MRX+QfjOXVjtylDkBWfSSMEQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1FDB4024E;
	Wed, 22 Oct 2025 21:11:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578E7C4CEE7;
	Wed, 22 Oct 2025 21:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761167478;
	bh=5v3JRmduY4uSzLf2Pqm6596Of3Jc6oNa3Sp1BFVrPsc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WB/NSEOYaZfqO71RaPt4ZWYdN0blDNxWfW5ICS4fnS9/Stg8tNvDA58HxOwxxfAop
	 6hilG6zy+ngXSW5OHpCRTxNenF9Bk2EaGFRCumPTjrRK/bVON+bnvy/p0jMxSCxSLz
	 Mp+CQpC8F2aarMsxM/M65yF0VX2LxhP4WqDUOqiQqQxpBBwSLDBsOAGAEp/+f54G0J
	 5gfATau19beB423OmBeJDw9m3Jlk4q89eSCMKQ4jChXPVDrj46xZpnq4bMGDdW6jjZ
	 TIcUJFiK3RcYlJnhG+XHlTjtlGrXivlL71exLBuObtDML9tzLkoDNFK+ey2dSEnLdw
	 wIQpY+RrFrnDw==
Date: Wed, 22 Oct 2025 22:11:12 +0100
From: Conor Dooley <conor@kernel.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-cxl@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>, james.morse@arm.com,
	Will Deacon <will@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
	linuxarm@huawei.com, Yushan Wang <wangyushan12@huawei.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>
Subject: Re: [PATCH v4 3/6] lib: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
Message-ID: <20251022-tried-alright-752fa98ff086@spud>
References: <20251022113349.1711388-1-Jonathan.Cameron@huawei.com>
 <20251022113349.1711388-4-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Vn2cL8c0hs3HiHri"
Content-Disposition: inline
In-Reply-To: <20251022113349.1711388-4-Jonathan.Cameron@huawei.com>
X-Stat-Signature: dweh6z1985re19ip51dj6yf9yxdgfot4
X-Rspamd-Queue-Id: F0CED40008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761167479-25705
X-HE-Meta: U2FsdGVkX19paZynOFZ049WRV0m0t0b9w6E0MYFY2D+f+unhuu/NUkLlbQoRmLzhVrOxC3VN0mtEW0q8cSvnxBJn6dTNnd1kxeuDujNOHNiHW/76U5QXAMnyWg5gt9WicRcfW/5PoLuBW3HbCyAFbo1l2qP0Hj73/R9uOrctf3iHdqAC4VBppeVM7V7N2mSAXsBUnDtsAq7x1getEh4jzfrgJWqveEzN9HfqxEl2jSa40WJseGg0pqYunRGsIDBADG7I/pm6sUV+XD6kvSSQKYmR/NhBIE2qj2Dbvo/r38qS7MI1L68MGFrvhIcf3u+xrG2INmsyqEwZf+P+mCecjvqCpH/AoY3M2FCxJtnfUcUaoVykGPyLukXkb39+MUeTC9S6ZoZKfo1GJXBM7qrqf+XjM6eJ0G0pf0dh6GmRkB7B0xQov+5LswxYCQgwEkEug42dltgFLZZgG4Z3IBz29mlroCK9xtdZ0a/UERCnfKvJIq527WAT4RLudOFzsCJXuRI5xWs1pr9/PLENMJ7xfoHfUFIvVA6Ni5Hq24K8syp7N0XFr2awqdDfKG7WaQ4Bu87FRGmIE8Oq62h30Fg/OY00KgXwx1BQScOGFfCY4X72cgb/1+VtzcVuTD/5rMiGRFTq10+NylIheu3V8SHa2xq+Oj50I2HEESPfKkut4vjda941CdjBJEB4nPdJ2phHq2M55y1TIoHDMp4+c8r/x2IwmYcy7nbJ7IReVKjVpCH6ikAjNBmxN1TxnBOKL8Ww51RbE+jwLX2yMkX6FT7Na5nfYgkrtXI3xL9hQyS3YKKJzqJWQmsRRR4FD2yCPi/Hz0uagTWkbkhoEmDsPABJlT/glKwpznKKHUDLUwAWKhhy3iYqS5gM3hDMxf/NI5ZuSCHlOGkioGnBPhUPbjBmgf37qlDMst40Yqo2EgcK7HkUmrUwgR9tVTvnZ7Oy5yse8ZkX3vilhC+IRie7bYy
 T9zVlyMO
 5JCwDCUBlarDPE0UuN6KALReCpFkjKS7eSvCrk4xEDDUY/6uAesyUSYRhz8fXBFgN3SU2Ui5n1oS7NZoxTXH8SnGZPU5vrpHZEl2nGlXwbCaDRYG/Wi29ZznZNwrxnCxyHzc5SZlR9/xcQwtbYDt819WKbJ1Qfrm8OC+/NVlSYl+SEovE+EpX8f/qcMxNpKV9dR+VCgRu12/PM/vg198ujf65ArsfKOMFcO2kCVUpsODJpMIJpJbom6zYgCON73tzMyCSrl1Js9WJjnX4qAHCCv1UzCm9x308HneY/PAyIqQZy/9t/neLkmOKVgMvH62YMyoVI7Se3omVz4vt+Q9nhrq55pLPgBQGcTSOC7NOnlCVLCt5ZmzwLqG9gfaC+pA+eOkdkN7v4mOsXrU5WM1WxAn2crEoRniQuBwhOicD3mQHrQFeQ+B4xrtc/S/fPWItzDJMqBr9Hkp7hnkYoeuk56xsRXngwwesaFd46CzRBlm4hHXurMTQm971ZaXL0bkfEOHDJL5JlE8QgyzYLJr+h/nZgKKVdFM905J1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Vn2cL8c0hs3HiHri
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2025 at 12:33:46PM +0100, Jonathan Cameron wrote:
> From: Yicong Yang <yangyicong@hisilicon.com>
>=20
> ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION provides the mechanism for
> invalidating certain memory regions in a cache-incoherent manner. Current=
ly
> this is used by NVDIMM and CXL memory drivers in cases where it is
> necessary to flush all data from caches by physical address range.
>=20
> In some architectures these operations are supported by system components
> that may become available only later in boot as they are either present
> on a discoverable bus, or via a firmware description of an MMIO interface
> (e.g. ACPI DSDT). Provide a framework to handle this case.
>=20
> Architectures can opt in for this support via
> CONFIG_GENERIC_CPU_CACHE_MAINTENANCE
>=20
> Add a registration framework. Each driver provides an ops structure and
> the first op is Write Back and Invalidate by PA Range. The driver may
> over invalidate.
>=20
> An optional completion check operation is also provided. If present
> that should be called to ensure that the action has finished.
>=20
> When multiple agents are present in the system each should register with
> this framework and the core code will issue the invalidate to all of them
> before checking for completion on each. This is done to avoid need for
> filtering in the core code which can become complex when interleave,
> potentially across different cache coherency hardware is going on, so it
> is easier to tell everyone and let those who don't care do nothing.
>=20
> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
> Co-developed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Acked-by: Conor Dooley <conor.dooley@microchip.com>

I'm fine with this stuff. I do wonder though, have you actually
encountered systems with the multiple "agents" or is that something
theoretical?

--Vn2cL8c0hs3HiHri
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaPlIcAAKCRB4tDGHoIJi
0ilcAQCnVKkCAStY/FbYOAkfI+W/JVlX+Y1Vm+WSmJKzsDcbvwD/WDlSH0CF9gAy
unvtdkqI/cCeZqx8cis9fpSarDvOjQY=
=Xs5l
-----END PGP SIGNATURE-----

--Vn2cL8c0hs3HiHri--

