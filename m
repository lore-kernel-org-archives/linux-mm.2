Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 361E2CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 09:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612188E00D2; Tue, 14 Oct 2025 05:14:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59BF88E00AB; Tue, 14 Oct 2025 05:14:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463848E00D2; Tue, 14 Oct 2025 05:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2852D8E00AB
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:14:50 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DADBF160737
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:14:49 +0000 (UTC)
X-FDA: 83996159898.10.5A0E13D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 232741C0014
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:14:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKZxf22Q;
	spf=pass (imf21.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760433288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGiZFnk1kQu1g0GPXcyRBT2RNyD9AEcg7RMuh8iWiIE=;
	b=8eY/ynpNvPum5OCmZqCCXRjFHvYUMtWNi9Mwym5/ixQ24D/Xl5hkixuU/4sHMT+lojxD3M
	CxDReQQldszX+WAu6bcMyM+cHZ4+oJ50lHmA6HWzbYlPU7oGQrbJCR/2GzSsR9tJYYd9zv
	f1bh7mow+/KmdwZaIP3a9m7EhWbFaaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760433288; a=rsa-sha256;
	cv=none;
	b=PV5qVrxJKJ+xnDs8z8abkpvFHuFeq9qeYUaktrAgHvalupKyOVdZXbuGaTQUYzMX90nAEv
	xggIRWcugKKU4HZYZz3mLj7oBu5sRxgSryZ/gN+meV+43F/OqAfemrozgFIhwq0Zf0o0BW
	KPQqmVivbqzzG8eo4qbG8Psj95OKrPc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKZxf22Q;
	spf=pass (imf21.hostedemail.com: domain of conor@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=conor@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CD13D45086;
	Tue, 14 Oct 2025 09:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD61C4CEE7;
	Tue, 14 Oct 2025 09:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760433286;
	bh=IBkCqz1KQ1uX83QuJ3HllJmulH8qpC3R2cWzYAaQB/g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mKZxf22Qjtehf9Ju4hs4d1ZMls1QVC7xp1pg19tXZDUQGb2nMv21rX7z/REtSlZnn
	 wdhZGctfOsCWA9ciC70TZNp9kr+a2rqxnEMKifOapN7x5EA3zolq/NQnJkZAJppQRs
	 vN+2MI68O+Z6k7v8gSxVxBKjmzOynSflXzuDdH+Tp/pMAWfSXRKg9ML0HHI9XoLDo0
	 gLZ+wE46cDHUuqsOuymef9yyVINznxtQIgzfjCc7kwee4kkI9zQ7A4k7a9BqOfRAKZ
	 1KUsGf4Pkc3K2Bf7aET6QtHfXzDY8krzRLjehgxV2AakTlYjkVjMWbmoVDXqpa6YtG
	 I1P5+AKe9VnHg==
Date: Tue, 14 Oct 2025 10:14:41 +0100
From: Conor Dooley <conor@kernel.org>
To: Samuel Holland <samuel.holland@sifive.com>
Cc: Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>
Subject: Re: [PATCH v2 17/18] riscv: dts: starfive: jh7100: Use physical
 memory ranges for DMA
Message-ID: <20251014-unsocial-composer-880ea10cc1d1@spud>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
 <20251009015839.3460231-18-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="kExO0No+kM/nXpTw"
Content-Disposition: inline
In-Reply-To: <20251009015839.3460231-18-samuel.holland@sifive.com>
X-Rspamd-Server: rspam05
X-Stat-Signature: dqo4qd1mnbbnwxy54medy6ca8akoe3ew
X-Rspam-User: 
X-Rspamd-Queue-Id: 232741C0014
X-HE-Tag: 1760433287-771447
X-HE-Meta: U2FsdGVkX18JIzwotUKx80/JfXYM9Zcav8a6fW9qmrU3+khalNvjf7IhrQ46rkYsiDHbRX+pkzzEAE+VlfgzWcW0SDEIMKfsK4Uw5BKXLB7hcX4wHrL5pcDttmlqMSVn9ZcWBT3SATY0AeiDTJA+Kbar23wxxtIfrAz7ZQ1/Igplqm4lPiDBKEi91p4taRAiZjaf+rE4jWTo942TnbRODyPrnTuD+Sbti7AZQGV2I6UgYdcojIHgxslP4brP1KH2UjvZ18rIHPb1NXL5DCUnzsIudBqN0A3Gme4uHDhyBw2+Pa/5OBNxzs2iupIslSokKJ/ZuNiPsixxXSE911WU21HNS2gq5w18G9x1PsPbYYeEZqI0I0TTt6PGPEfBD82kIG081DBgSkEqUYSdM6SheuaCgd1Iu74bvYgl0Y5Vda7Hr151X+SS1B5cw8ahspfSytIw4uts72XorxrWlp61LGsGV47PZwDj+wr8avaq8IUfU+mDWApJgrVjFnl8Mo1cg/yADXPNupmHAvIIKQf12GVf+8Q4ZIubIzK/c9Q+Ao4x+ouka+LxRUcG2HuVZnegJyzfC6gI/Ez7ksBwz+rEllRJwt1ToOXhb8/Xdfj5yq0MB+vzBQiFSa7tFOgsnnxVSbWsLYYeTHVcdCAjaYVqUcr3cAgEcVelFRcZh4ETavUPz5/U+zMhF1XPaPOr87rbdVGA3LxUMJUeOi4MZgTnOuF+BNVBnZNYRu2efEjxgWcAHVoUyWAsbtIA/ihNJzTrTQ5bFgXxomD9fNjZARFUYK2qnYjp0xQtUUOXPARtjJIyVuarif1dD292cb6o+6QQLFYIo05PN3RU3ZT9dzBgASSPAedZFkZNU2sdWwMHwNRc5HADqefXTvdrerNV1fp0VviA5Vi7kcwUscY9+PcMJ24okonSuYoH3qykh0a8ICiQU+XiRUFmM1zgW2XtJwnDBEmwjo0eHTRtv+aiTPV
 ck8q24a0
 RgSA4aVZS9hg3vTpcjdTyg7S3nBFTrKcVXIOOax1hGMBC6P4FBEUAUXvaiseZVro/UfV76jzHfic+ZYE/XBrrCGsiluxZY3hmbLs3DM5mYOpA5npyY5I8vEdG/jRSQcp3/YbDdCbP07IgK17gxPlKkskIXIuiX7DqmELnOnSb6peWc/Wu9QwFpbBY/zemDwOjdSctiYdEVqsKZxxYiAYCNJzWpju1YM2ENuSBPsmHraskEd9QBPTcXh2uicAjE/J9fH8WO+zg/RfvqRR48VQNmC/Ja8qF/CzZMRd5pIDgqeZLWelmUeA+lUE9kMc03u1ncazi0WXRpv9Y7R21Wv68QGzMTCMXvzgZrOgpR7cLtmGynG/payVCzn6ve4Bfx84Ub9LQ5g1yfUqbMTSa7Hx3g2RZPCBT8iz2kVQsvbpoIYIiIpKSNMv2JiRjpG0vIOPyGV6439DxZg+3jwWGEwkshQkEmtiG8LLuGk91t7JXH6DqpqM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--kExO0No+kM/nXpTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 08, 2025 at 06:57:53PM -0700, Samuel Holland wrote:
> JH7100 provides a physical memory region which is a noncached alias of
> normal cacheable DRAM. Now that Linux can apply PMAs by selecting
> between aliases of a physical memory region, any page of DRAM can be
> marked as noncached for use with DMA, and the preallocated DMA pool is
> no longer needed. This allows portable kernels to boot on JH7100 boards.
>=20
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
>=20
> Changes in v2:
>  - Move the JH7100 DT changes from jh7100-common.dtsi to jh7100.dtsi
>  - Keep RISCV_DMA_NONCOHERENT and RISCV_NONSTANDARD_CACHE_OPS selected
>=20
>  arch/riscv/Kconfig.errata                     | 19 ---------------
>  arch/riscv/Kconfig.socs                       |  2 ++
>  .../boot/dts/starfive/jh7100-common.dtsi      | 24 -------------------
>  arch/riscv/boot/dts/starfive/jh7100.dtsi      |  4 ++++
>  4 files changed, 6 insertions(+), 43 deletions(-)
>=20
> diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
> index e318119d570de..62700631a5c5d 100644
> --- a/arch/riscv/Kconfig.errata
> +++ b/arch/riscv/Kconfig.errata
> @@ -53,25 +53,6 @@ config ERRATA_SIFIVE_CIP_1200
> =20
>  	  If you don't know what to do here, say "Y".
> =20
> -config ERRATA_STARFIVE_JH7100
> -	bool "StarFive JH7100 support"
> -	depends on ARCH_STARFIVE
> -	depends on !DMA_DIRECT_REMAP
> -	depends on NONPORTABLE
> -	select DMA_GLOBAL_POOL
> -	select RISCV_DMA_NONCOHERENT
> -	select RISCV_NONSTANDARD_CACHE_OPS
> -	select SIFIVE_CCACHE
> -	default n
> -	help
> -	  The StarFive JH7100 was a test chip for the JH7110 and has
> -	  caches that are non-coherent with respect to peripheral DMAs.
> -	  It was designed before the Zicbom extension so needs non-standard
> -	  cache operations through the SiFive cache controller.
> -
> -	  Say "Y" if you want to support the BeagleV Starlight and/or
> -	  StarFive VisionFive V1 boards.

Hmm, removing this is going to break old devicetrees, right? Shouldn't we
just keep this with a wording change stating that it has been replaced,
rather than removing it right away?

Cheers,
Conor.

> -
>  config ERRATA_THEAD
>  	bool "T-HEAD errata"
>  	depends on RISCV_ALTERNATIVE
> diff --git a/arch/riscv/Kconfig.socs b/arch/riscv/Kconfig.socs
> index 848e7149e4435..a8950206fb750 100644
> --- a/arch/riscv/Kconfig.socs
> +++ b/arch/riscv/Kconfig.socs
> @@ -50,6 +50,8 @@ config SOC_STARFIVE
>  	bool "StarFive SoCs"
>  	select PINCTRL
>  	select RESET_CONTROLLER
> +	select RISCV_DMA_NONCOHERENT
> +	select RISCV_NONSTANDARD_CACHE_OPS
>  	select ARM_AMBA
>  	help
>  	  This enables support for StarFive SoC platform hardware.
> diff --git a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi b/arch/riscv=
/boot/dts/starfive/jh7100-common.dtsi
> index ae1a6aeb0aeaa..47d0cf55bfc02 100644
> --- a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
> @@ -42,30 +42,6 @@ led-ack {
>  		};
>  	};
> =20
> -	reserved-memory {
> -		#address-cells =3D <2>;
> -		#size-cells =3D <2>;
> -		ranges;
> -
> -		dma-reserved@fa000000 {
> -			reg =3D <0x0 0xfa000000 0x0 0x1000000>;
> -			no-map;
> -		};
> -
> -		linux,dma@107a000000 {
> -			compatible =3D "shared-dma-pool";
> -			reg =3D <0x10 0x7a000000 0x0 0x1000000>;
> -			no-map;
> -			linux,dma-default;
> -		};
> -	};
> -
> -	soc {
> -		dma-ranges =3D <0x00 0x80000000 0x00 0x80000000 0x00 0x7a000000>,
> -			     <0x00 0xfa000000 0x10 0x7a000000 0x00 0x01000000>,
> -			     <0x00 0xfb000000 0x00 0xfb000000 0x07 0x85000000>;
> -	};
> -
>  	wifi_pwrseq: wifi-pwrseq {
>  		compatible =3D "mmc-pwrseq-simple";
>  		reset-gpios =3D <&gpio 37 GPIO_ACTIVE_LOW>;
> diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/d=
ts/starfive/jh7100.dtsi
> index 7de0732b8eabe..34ff65d65ac7e 100644
> --- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
> @@ -7,11 +7,15 @@
>  /dts-v1/;
>  #include <dt-bindings/clock/starfive-jh7100.h>
>  #include <dt-bindings/reset/starfive-jh7100.h>
> +#include <dt-bindings/riscv/physical-memory.h>
> =20
>  / {
>  	compatible =3D "starfive,jh7100";
>  	#address-cells =3D <2>;
>  	#size-cells =3D <2>;
> +	riscv,physical-memory-regions =3D
> +		<0x00 0x80000000 0x08 0x00000000 (PMA_RWXA | PMA_NONCOHERENT_MEMORY) 0=
x0>,
> +		<0x10 0x00000000 0x08 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY | =
PMR_ALIAS(1)) 0x0>;
> =20
>  	cpus: cpus {
>  		#address-cells =3D <1>;
> --=20
> 2.47.2
>=20

--kExO0No+kM/nXpTw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaO4UgQAKCRB4tDGHoIJi
0uKUAQD80+kPIuFiDo0jFL5AOngNkEUr28ECrOoIkr5OlYN8UgEAh9hDrsZWp8fb
oE38JjdP0xJl6Q+HfnlMtSej1XDlZws=
=jxde
-----END PGP SIGNATURE-----

--kExO0No+kM/nXpTw--

