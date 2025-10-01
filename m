Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1865BCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 23:31:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1305F8E0005; Wed,  1 Oct 2025 19:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107C38E0002; Wed,  1 Oct 2025 19:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 044DF8E0005; Wed,  1 Oct 2025 19:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E75FA8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 19:31:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8BD65584F1
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:31:44 +0000 (UTC)
X-FDA: 83951144928.02.E90C72C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F3D3940003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 23:31:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5OrcNnJ;
	spf=pass (imf04.hostedemail.com: domain of conor@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759361503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MTRNgFb/uXFYWdnXboNRWVcBZmcEx1q5hKN0lJrIGBI=;
	b=CMNxJf1WaRDnDE3Bps1rsG0xb2tFuEsBGuUr3YhyyWcmOnul2F374zZg5O1DxPN13fZRvF
	aeKNS5LgEu8AwTBEbqxADXSxzSWiYLW7I1VAMBZuyRhohLA7/GX5876/3vdaREfVpm4qra
	vHvKZKIDKs89VY850yWm08tc/WMCLg4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t5OrcNnJ;
	spf=pass (imf04.hostedemail.com: domain of conor@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759361503; a=rsa-sha256;
	cv=none;
	b=JX5h+MMEdznr7P+zne4ErHrMGefM95vg7uzV+P/E1S5ruxupMAK1e2a2NJvOXZLr+dvLGx
	fuYRZIVge9MaS1atknf6xQS7jrK8APvBGmPYi8hrzeHhcFXw9RswWnJF4dHpeRK/MBS3KR
	+9LJ3YwFZ9+PVCgEnMTwzPo+ooQaf7w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D9CB161D70;
	Wed,  1 Oct 2025 23:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44208C4CEF1;
	Wed,  1 Oct 2025 23:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759361501;
	bh=OGlK5L3ggNTJFXop7r3keERa3EKrM29ZMElxPIYJMHQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=t5OrcNnJRZl6gflPLlO7LLBZEmOdJ3NXgYQ6CdBf0v3BaHJ2P+n2N3PvXwMTW9gUr
	 6EtiPCgl/JHF1O/UqUSAQpR+II3zPB4XAACMoDGzV1U309o90SzIVHUZyZGJePz0NZ
	 thzUy7XLC2KYkrjk+yhbYcz06jFv01RJjA8bbjrhyofxtjg2PQP/vFv7ik+PoVR6ci
	 fpouJohZ0OdV1MOe1uKinrV/n96glTjZou5zhNpgdGw8ha02geNWO/KBnM+N3U4xZp
	 3xYqSDeuesYjm5rRBIRiY3w5+R5FiESXDdUAxJO61jjztSAgyVQ291xNYtqdYvWHex
	 1kcqbBWu67kog==
Date: Thu, 2 Oct 2025 00:31:34 +0100
From: Conor Dooley <conor@kernel.org>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com,
	linux-cxl@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, Will Deacon <will@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Yicong Yang <yangyicong@huawei.com>, linuxarm@huawei.com,
	Yushan Wang <wangyushan12@huawei.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	x86@kernel.org, Andy Lutomirski <luto@kernel.org>
Subject: Re: [PATCH v3 4/8] MAINTAINERS: Add Jonathan Cameron to drivers/cache
Message-ID: <20251002-strainer-kindly-8e654868337a@spud>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
 <20250820102950.175065-5-Jonathan.Cameron@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="O121PAwtnwfexBg5"
Content-Disposition: inline
In-Reply-To: <20250820102950.175065-5-Jonathan.Cameron@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F3D3940003
X-Stat-Signature: nzi7hrf58ut9rk15txoypkjmebbo849i
X-HE-Tag: 1759361502-278218
X-HE-Meta: U2FsdGVkX1+tV/OEGjeFMsAmt4FWFE+l12cs/dfuKgAPod2HiXWDIiboe90L4zmd8jfp7tleLIxeyHJX5YByEEACWMdKD4jvGujaEcKDYeuiA03Lil82z9ORUiIqlU4wEJlxDtcaBgdLkVHQ8Atb4Q11dTl7MDFGVVQhmZ3wkuze1SUPBGSz5FNi3fWJmPbF7S9RBQTQJcbMu/zC2ANVNT/44J341TZLHK4ad0pMn0kkxz5K3iOX1dXpfuLb5JU8vgswdiRUiVxpaJNnrGxfDlXPyNYw1tWBBSj1HHfyPSjrK7iDCt/K/rQoZX6gWpzDgVWs9z1R3uTx7npQRp4hz/O6wV3guoADGtDPCXsBzgkUv26eeNzFw9rgBkVXSCTjvpF3k08t4+phJNLS1Nn0BCB+VcQtbaOFTjHtfIlGe6SsXjFcjV/NIQMQdjZwPqTYuNtyNMOXPcsOIZQaIEzYR9yoYDb5abHvmZ36dVc7UduKAzrNh3D5xuWgkRJQTUK5TzrXcK2fkAMPGoN/BoSf0DH26QvfDKYU7JAdMHgKtqOsyi0U6ULntqHThEosJvcteSkNhaXWoGXusDKkcF4WkfPUNJ8GdXSZilOFIedmjIf4NnychGOdvnXdxQ5gkPlukWvLc6KnBmnjQdN4tsyOWmZgMWXTKrheJB6K0Wd3pImijTQP0Perjio2VpDjsNE00p+fjPiko5+UOUjOQTNN6XVWAwrNCLJCKXb+LEZwKRIMa//N86vWfEkoHiiNZePY8IZKkXIHsisU3BTTBtAOoI+nl3GYCQdVgBsE0aatWOIxrElDtS7DnasXsiWBUwjNCTNM8X4+rt0adNSUxwg3TUFg0vGnsglaEWVySg7y1jfwrUkHbBvTi6g00rYPQkQ9OFDeAxmN0TO8G8kHCtQxnNDAvHIg1/JxjBQBy41QRb8EGu78S0gE92CCWp7iuYch9OfOxpMZPyxYstq0fkA
 PxR7FDvy
 BJ9AMPlH+zpKwjLkvjlG7V5Fkgb/qSpxFwrQXBCOw0QHpS7YvC/J6UcaQFo596hYFMQX1sLjwQ4XxpKDlgituxipEVngGOgozY/sZK+r58lWf834n+zjscnlKV1jVo+o2FN7L7X6Jmhgoi/cLKBdjZF2bbkdvWeVvDPyQwWFGCQ8NLA1/x0rpSD95Hzbb0b1k/9T8QR1A6dtyQOsicEdnOoJk2lEeBhXLjbojuAwD+4dBEKS27+Sh0muYeBQQtlk0gQxLW/J9x7fH7iIp/7IMtHE5/DIbYAeuFcm1jT6Y9F5Bw1FX+PMpX+YXi9CMD4bhtZVMyxhPYj4su9rpwhDTV6VZcJoEX3poFpZn+zjgaBDqnSGEbwcmDipGQorHEh69vvJSJp/jZpWLwjlzEwrHNZgbEB/o4fVBpXccrLBq96I12g8isGHlTOovs1EflsoGRxH6gvMKuy6TZ1ScuvxleBBBoTTNxXRYqc1n+ysKH+ZhN4UheKkREEysHXNpohO/AxZa612LbgO3pug=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--O121PAwtnwfexBg5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2025 at 11:29:46AM +0100, Jonathan Cameron wrote:
> Seems unfair to inflict the cache-coherency drivers on Conor with out
> also stepping up as a second maintainer for drivers/cache.
>=20
> Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> ---
> v3: Add lib/cache_maint.c and include/cache_coherency.h
>     Conor, do you mind those two being in this entry? Seems silly to spin
>     another MAINTAINERS entry for a few 10s of lines of simple code.

Oh damn, I just found this randomly while wondering if this series was
going ahead - you forgot to CC me here! I don't mind the extra bits, I
think this makes sense, splitting it out would imply a different path
for merging.
Acked-by: Conor Dooley <conor.dooley@microchip.com>

FWIW, I don't mind using some non-personal tree location for this, but
that's something that can be done independently if it's needed.

> ---
>  MAINTAINERS | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index fe168477caa4..039d10ded9e9 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -23967,10 +23967,13 @@ F:	drivers/staging/
> =20
>  STANDALONE CACHE CONTROLLER DRIVERS
>  M:	Conor Dooley <conor@kernel.org>
> +M:	Jonathan Cameron <jonathan.cameron@huawei.com>
>  S:	Maintained
>  T:	git https://git.kernel.org/pub/scm/linux/kernel/git/conor/linux.git/
>  F:	Documentation/devicetree/bindings/cache/
>  F:	drivers/cache
> +F:	include/cache_coherency.h
> +F:	lib/cache_maint.c
> =20
>  STARFIRE/DURALAN NETWORK DRIVER
>  M:	Ion Badulescu <ionut@badula.org>
> --=20
> 2.48.1
>=20

--O121PAwtnwfexBg5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaN251gAKCRB4tDGHoIJi
0toUAP0dOcmtbXnxZnNoXXCM7kD2Nsf3MpJIf+ZHnwEDwUNU6wEAvn+n1seE9hkC
hVZLo8CCugs4ulT80RBNTP9Auu7ODw8=
=p30I
-----END PGP SIGNATURE-----

--O121PAwtnwfexBg5--

