Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510DECCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 14:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC51C8E0018; Fri, 10 Oct 2025 10:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D068E0003; Fri, 10 Oct 2025 10:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B20D8E0018; Fri, 10 Oct 2025 10:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87D1D8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:20:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 173A51602FB
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:20:01 +0000 (UTC)
X-FDA: 83982413802.21.1305776
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA40516000E
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:19:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=O2ZANWc1;
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf08.hostedemail.com: domain of emil.renner.berthing@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=emil.renner.berthing@canonical.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760105999; a=rsa-sha256;
	cv=none;
	b=zBArOA0flsslHe/ArWpGK7WLJan9UkVtSB5S0ewHhY+T49luk91kz1GKp5xlYxFLxZD3hE
	I+5LbPeNRkqYj8Jvt7wzdq+eSFqqR3A4huQ4ZLNc/Hx433+69zyYf4G+F//oiQsOLSkvdX
	xV3BrM7GxVNDCBbA3NyKvzAgMMZ25A4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b=O2ZANWc1;
	dmarc=pass (policy=none) header.from=canonical.com;
	spf=pass (imf08.hostedemail.com: domain of emil.renner.berthing@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=emil.renner.berthing@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760105998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZFsc0cqoEjkO7gKnFRYSVcb3ZWZEOVIH/oA4k6SVYM=;
	b=fFQmjGAY3Wyk6+u9cwV5FkTVfEh0ZLDFyVniTpEqi5YDIs4hqdQGB3uePPWWbHBwfj45YV
	O7GMBi62Y4XlgC+jdJgUgR18qzMcvKor7zhgukuN8IDgBr8Rd7jo9ceHTMRO4xZuPbNE1i
	NjTLdmkigxK+BK/X0gm6wrrJfZ+WPRY=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com [209.85.217.69])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id A5CF13F802
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 14:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1760105996;
	bh=wZFsc0cqoEjkO7gKnFRYSVcb3ZWZEOVIH/oA4k6SVYM=;
	h=From:In-Reply-To:References:Mime-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type;
	b=O2ZANWc1aJh9qDm0BsJ17JgUiBclSlvysh3FvJCtYCbKAykqYMx4tt7GvbmqcbuTQ
	 I08kPRRWzquYvVguPF+Ng7X9YKiDMrfyAr4BN6bvnHa1+KJBRelWWTpSOs3/fmpKy3
	 A7oxLH0dbkfuqCKjLJ8RZF17j/a9ZrthjXhgG9g9aYwWYGVfKdTwjQCEkOeKfRuoMH
	 tKgW1bkMy5pXdJRRg4S2nXnfUTEN7nvSgguq/1yhrfel562fI5h0unJxAlHQP4jSox
	 VoE8kGpEcTT0lxfNBEMGoLFccn2xxVm4Ty5LPN7roVeZ+L4E7GAqJRpkaaUQ8Ex343
	 ozd7TRPEUW8QvR/WpzGHOTTCEo6x+piSNb0roDl45KR/Xzxsc1z2CfN128X7ACMctT
	 Olh5pJ8o1QYlfwdz0ECBs3TWPRiydxdDLZYqrbhw9gd9PqIET1o2caVUXQgTFwITXs
	 7ET6tcu8kD4Frlo1ixdDycqAVHYABReaUeQBHFVemA0NaO40ivLXganoRb1T4gBcdm
	 7PC//u4zZmukDHipisZrbf7M6N0a1tOn0NCC4Bt1iV7QBDNyFGky8EwEriNnGevYPY
	 dUxkzcaLhAuShSRpUCRBBQvFvZXqGRahL4r8PJEVrJR+JX71Qq0tySeT8MF3OowdMT
	 OoSR9O3mgrf4NFT9WcKWR3sQ=
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-5d5eb99cf08so5430636137.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 07:19:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760105995; x=1760710795;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZFsc0cqoEjkO7gKnFRYSVcb3ZWZEOVIH/oA4k6SVYM=;
        b=NiKYUOOxtUzXifrLlZmcDmwmPH3AtQAZo85I2JMFw2liYG4epO2T8mtRUGXF+aojRT
         0ch+S7osgF/KFkO/UyVu/yBkuNWw5pYmS5UFLHgHwFnR4bmZafybjtYrWD9QRG98acnn
         Tlm4igvPUaoUdVeTYU2h38wqw+Sq47+663tVcZCFkCeRU3q06R6LFIttLh7eqf8aG8Hx
         vSJSAkySCIcVILcSWkfpN5+lVae1oNp6ZMgBZjo+Oh3vR9jUXT51dgDOXZFUkfG9pO8i
         V1WD+dDGCgYH114PxuEN93qunJ+m0GZnalj+ZCmh1mBlEjoIbJimXQiFGCxEmqzVSaWo
         gcnQ==
X-Forwarded-Encrypted: i=1; AJvYcCWtZf3tDFhWZnsDYLDwlY2uUlDALY78H/bhedzI23xd2dC4O7PiTzDHcZ3YWX5mFzkKQUti8GGXzQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1RAMJ+8uDkACjPnggAK19oh+pWB8vf6EwZmx82Br4iZeH8VuX
	sldPlXaz7WYKfNWjEdXzbDpQ++geq8F/8M7wY7VdK+HSkOYLzfBCgxsJudo+5fDxezzzTfcNNsZ
	CjxXUuCHZCykqIzMTkJf9Q5YIMN+e9X5AljaVH4rpmTRcqdR785qA0pl2M/tlmafMVDeeP6rAoZ
	j1uFmJvHTkZiuEiyM2UfSUSfMhpFflSMKe/SXek793DTU=
X-Gm-Gg: ASbGnctD2oIOo66bNQDBZyFIlmuRPPmcORpeAfaW7qVGM40dRVB74vMGCDhbVo0vT8f
	tejPzmFRZCQjbCdKzmOrUZPKL+PHpx/yhz889DRanGZ4clKNf8LLrlS0q8dz2C4fKoA50lPpBUn
	QfEjJp9GSQ3SOlC629iQs=
X-Received: by 2002:a05:6102:290a:b0:5d5:f8df:8eeb with SMTP id ada2fe7eead31-5d5f8df90b1mr2375363137.24.1760105995656;
        Fri, 10 Oct 2025 07:19:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGtJ5BK2Kci2VugCpCugcyMp0MfaVnQs+KUCQn6J+Waq0JOsbp/jIivsCDhg0pl1qZjDL6SXhAjfxWgLCXGQEQ=
X-Received: by 2002:a05:6102:290a:b0:5d5:f8df:8eeb with SMTP id
 ada2fe7eead31-5d5f8df90b1mr2375335137.24.1760105995272; Fri, 10 Oct 2025
 07:19:55 -0700 (PDT)
Received: from 348282803490 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 10 Oct 2025 09:19:54 -0500
Received: from 348282803490 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 10 Oct 2025 09:19:54 -0500
From: Emil Renner Berthing <emil.renner.berthing@canonical.com>
In-Reply-To: <20251009015839.3460231-18-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com> <20251009015839.3460231-18-samuel.holland@sifive.com>
Mime-Version: 1.0
Date: Fri, 10 Oct 2025 09:19:54 -0500
X-Gm-Features: AS18NWBjDcHrw1s8RwyRjhr8EvaCuZc8XkxMvBfhsZ2PsGnZOM9VUAkh7k1guZY
Message-ID: <CAJM55Z_C_ce6wwCpNyGeozxBKW1krSrdzApvGumLn_p7K0hhYw@mail.gmail.com>
Subject: Re: [PATCH v2 17/18] riscv: dts: starfive: jh7100: Use physical
 memory ranges for DMA
To: Samuel Holland <samuel.holland@sifive.com>, Palmer Dabbelt <palmer@dabbelt.com>, 
	Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Conor Dooley <conor@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>, 
	Emil Renner Berthing <kernel@esmil.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: fhbotf5kdp7mn163b5746t46n5tau9jm
X-Rspamd-Queue-Id: AA40516000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760105998-456121
X-HE-Meta: U2FsdGVkX197KZ/a4oj186LEft5Khmf8IjjaDeHYnFAJ3lrU+IZ9yDKtOfdRwuMcMvBYKD/e1fpMEEwpp2KcLX2wou3QVsdtUuX32gk+KOsbZftGobc8PmkqgCY2bRsaTwuLzy7FcZcWctGvCkL4LDbdPRsohBsBk1FXFqUPdH89u57z2TezAnSskK3RQ0+jiPhJpBSY3HvO+h/EBbnqXKYDQAFGFWQf1ANZADHw4TXTagKoMeUDl2h4Vimq5/H6PcxPegPlNZ8z+MrnlLh45PWU1g7oyuRU9/w53q24rrRhdwd0a+tqb/WFCQPMoeMedeIfUkuOr+nnS8lG6vQTePpSsRgv3Tf+6rZeBWiTQeHb/dJH1bVQrLTUowKivJv2FEf+Qx0eqPMPZWiggk+O1FLvGmgydmX34izTo2SxCdHQS1M785O/gcDf3f2f4U34A9yROxQWyNEdHtqrFW1pq3rW/4plsJPRqVIz+pShUWK35b0Dqd3sWFa8ac5O/9nP9jLFzBWm3YUFEgx7PE0KsvP9TpZc5nRr78ox+j1GMOuGhTsd4IAAvi6FpmkXkaZi+vI4X+N/lNOdlwH75S+QQfsLTgCAIVvdYev3Lalr7msAJz048LQFG9Mvx2lYoW62IyGxshm5N2k+QLrS/tmhod8Pssj8LY7gWTZ67tVTnK8HIxZNJBuEarFzswJYacsrmoJ9LWtsZtRGUexmLeDwcH3oha7ZRn69ORgQQUpwFZUfx+5ArFE8wwd2qpYfHaFTBytx59w3d1hp46h0fT51ASJUYXmC+EkDqBQMBrv2x5fJyCc5w62k/Yw16YH2HSe4aaUxyNl+BKTVqEB8JeGYzYQWvBRuxKM5EjKM/6YiAXLfL4uBO2r/YH0snBEa5QIPxAStJ6bkadqPrAx0xr58vWimw7BRGKU/dM6S+92n2jPWMEPFqfWyj0hTquUHYNe1AYANF+gHbrWsPPb57Nv
 CI5EU01O
 f6GDSSrWmEX86eyPgVFOoDVXf4N6LrnoeFqyOFF1seyUsVvD0tgZUDSAJLOchwELu2Iq+kGm7Ib/ZiTHQWD43Vze1mN1HtIbDfQouUghVzq6+fxkLnRqbBftQKuv7LaEKF8qoXOMcrvmt+ntbNh4WbJmRiLpomg32atpEUZ7oQA727FBmCt2/ybSQEaATfAAMyn8Pz+/Jdcl2V9E333cO1/7W2fod7/8Cj5Hch/o3XmgI6+oZPtZjCuln1RmEkHa+qgO1ilYHeZDbFJtKo1fl3o4l6inBWqReKMfhS3i6kGzG5YOfpeykiBXoPPqINQkcOfN8iWx7D63NPvLCfpRj/MWEW+eRuL2bxcH5VtQ6Rp2AQz0oTz5Hn5qUh/4CkFj/gw+YaZ4NW7vEsVbpNeppPGIhdUpWTXkDY+QqtI2YPDtG5h7EKqgxOdZkIKtWbYATB+VokkG0vBBULDS93OssP+iwxzMARuHUVCI77vAVuh+C1MT2OKrEJuAU10KCo3CXfDwiCQLWs3vY+yOKSMdytkpXM+RaZ7oTe+0Y3o7xUXtMggXoPV3dXBCRHLXwcXP2g01zgaIHqm5nWfVq4JF+Oxh+7O5EpKqND1nbUOHAY1S63+cEv2aM/J0JjgUKtpoG5ZcxrYIReu2/17zCh/o6fJA8JQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Samuel Holland wrote:
> JH7100 provides a physical memory region which is a noncached alias of
> normal cacheable DRAM. Now that Linux can apply PMAs by selecting
> between aliases of a physical memory region, any page of DRAM can be
> marked as noncached for use with DMA, and the preallocated DMA pool is
> no longer needed. This allows portable kernels to boot on JH7100 boards.
>
> Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
> ---
>
> Changes in v2:
>  - Move the JH7100 DT changes from jh7100-common.dtsi to jh7100.dtsi
>  - Keep RISCV_DMA_NONCOHERENT and RISCV_NONSTANDARD_CACHE_OPS selected
>
>  arch/riscv/Kconfig.errata                     | 19 ---------------
>  arch/riscv/Kconfig.socs                       |  2 ++
>  .../boot/dts/starfive/jh7100-common.dtsi      | 24 -------------------
>  arch/riscv/boot/dts/starfive/jh7100.dtsi      |  4 ++++
>  4 files changed, 6 insertions(+), 43 deletions(-)
>
> diff --git a/arch/riscv/Kconfig.errata b/arch/riscv/Kconfig.errata
> index e318119d570de..62700631a5c5d 100644
> --- a/arch/riscv/Kconfig.errata
> +++ b/arch/riscv/Kconfig.errata
> @@ -53,25 +53,6 @@ config ERRATA_SIFIVE_CIP_1200
>
>  	  If you don't know what to do here, say "Y".
>
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

Hi Samuel,

Thanks for working on this! I think you also need to select DMA_DIRECT_REMAP
here, otherwise devices complain that they can't allocate coherent memory at
all.

But even with that added it still doesn't work for me with 6.17 on the JH7100,
the sdcard isn't initialized properly, and I haven't figured out why yet. I
seem to remember your previous version did work though.

Plain 6.17:          https://esmil.dk/pma/upstream.txt
6.17 + this series:  https://esmil.dk/pma/test.txt

The kernel config I'm using is available here:
https://esmil.dk/pma/config.txt

/Emil

>  	select ARM_AMBA
>  	help
>  	  This enables support for StarFive SoC platform hardware.
> diff --git a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
> index ae1a6aeb0aeaa..47d0cf55bfc02 100644
> --- a/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7100-common.dtsi
> @@ -42,30 +42,6 @@ led-ack {
>  		};
>  	};
>
> -	reserved-memory {
> -		#address-cells = <2>;
> -		#size-cells = <2>;
> -		ranges;
> -
> -		dma-reserved@fa000000 {
> -			reg = <0x0 0xfa000000 0x0 0x1000000>;
> -			no-map;
> -		};
> -
> -		linux,dma@107a000000 {
> -			compatible = "shared-dma-pool";
> -			reg = <0x10 0x7a000000 0x0 0x1000000>;
> -			no-map;
> -			linux,dma-default;
> -		};
> -	};
> -
> -	soc {
> -		dma-ranges = <0x00 0x80000000 0x00 0x80000000 0x00 0x7a000000>,
> -			     <0x00 0xfa000000 0x10 0x7a000000 0x00 0x01000000>,
> -			     <0x00 0xfb000000 0x00 0xfb000000 0x07 0x85000000>;
> -	};
> -
>  	wifi_pwrseq: wifi-pwrseq {
>  		compatible = "mmc-pwrseq-simple";
>  		reset-gpios = <&gpio 37 GPIO_ACTIVE_LOW>;
> diff --git a/arch/riscv/boot/dts/starfive/jh7100.dtsi b/arch/riscv/boot/dts/starfive/jh7100.dtsi
> index 7de0732b8eabe..34ff65d65ac7e 100644
> --- a/arch/riscv/boot/dts/starfive/jh7100.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7100.dtsi
> @@ -7,11 +7,15 @@
>  /dts-v1/;
>  #include <dt-bindings/clock/starfive-jh7100.h>
>  #include <dt-bindings/reset/starfive-jh7100.h>
> +#include <dt-bindings/riscv/physical-memory.h>
>
>  / {
>  	compatible = "starfive,jh7100";
>  	#address-cells = <2>;
>  	#size-cells = <2>;
> +	riscv,physical-memory-regions =
> +		<0x00 0x80000000 0x08 0x00000000 (PMA_RWXA | PMA_NONCOHERENT_MEMORY) 0x0>,
> +		<0x10 0x00000000 0x08 0x00000000 (PMA_RWX | PMA_NONCACHEABLE_MEMORY | PMR_ALIAS(1)) 0x0>;
>
>  	cpus: cpus {
>  		#address-cells = <1>;
> --
> 2.47.2
>

