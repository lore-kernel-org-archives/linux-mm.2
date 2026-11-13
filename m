Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9345606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W6dxepis
Received: by kanga.kvack.org (Postfix)
	id DE7DA6B05BA; Fri, 13 Nov 2026 14:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC03F6B05BB; Fri, 13 Nov 2026 14:20:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC916B05C2; Fri, 13 Nov 2026 14:20:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AE3626B05BA
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:20:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED58E1201A2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:20:27 +0000 (UTC)
X-FDA: 85431062094.20.99E5CD0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 4A1DF16000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:20:26 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6dxepis;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794597626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yme8xVrfiJB9JtUWZsCWQb4f6bpQ8C2lB7x46RDJgew=;
	b=K5Z5IRH5pmbrL11hOX1DWkjagsWxplMmnZmErAX/6GEqZoCnmYPlbwVRzdzsfpK1uXgVil
	OPf5qFqYABoeQyMDQPEO1Lx56J0XyE0KFCEvdBKN6Q8PniygOcGH3odlvcGgquhJtW+f/X
	Wo7QSlR3ZFcGfYR69D4JOpqyUMe3pbU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794597626;
	b=Fccyqk4xals0guYfvfQOw8PVxmOBPLvntsES4Jb2D+KNLXKMwiglJyKeGv1eoEvOMFriuZ
	q9p5/wpnImTJ0ptdiKmOxbZ3YKtOiTHVXeVUKM9Uj3C6BH5TgPmazOfuZ2tFoM/njrWFQp
	NXW3Kh1kdX+K1Rc/46jSIK14+MUV4XM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W6dxepis;
	spf=pass (imf08.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0896061D75;
	Fri, 13 Nov 2026 19:20:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A40361F000C4;
	Fri, 13 Nov 2026 19:20:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597624;
	bh=Yme8xVrfiJB9JtUWZsCWQb4f6bpQ8C2lB7x46RDJgew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W6dxepisHpNNsxivi81mY2JUyom8vDvbtSJGZ79fX/VnHuW46WgDlfEp5w7M4L57I
	 LCYDzH5U0zSkM86UX6S5jGE9QpxapZ2vXxyGRwBFCxzwa1hnqIs2B5C1sd9o1Obgcp
	 MFZVnbFcDAFxRX01z+kkFJPV818yQD1kIbDRb8w1KLadEiSWsjM6L69B0/DeYUaKKJ
	 JnHV9Zjv20wthE9X+dPxf1pxS/GCxyevGUDxAU7fMzVkPg2hHRB2S01RE3gZ9BRIKm
	 zBYjPZQY9VUggt4Lrn/MTj4XrA5pKIELlXIqABDX1noeaFuneVjKllspDykcclkRE9
	 OuumQ6HJ3hVhQ==
Date: Fri, 13 Nov 2026 19:20:17 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: linux-mm@kvack.org, Arnd Bergmann <arnd@arndb.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Andreas Larsson <andreas@gaisler.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Linus Walleij <linus.walleij@linaro.org>, Matthew Wilcox <willy@infradead.org>, 
	Malin Jonsson <malin.jonsson@est.tech>, Richard Weinberger <richard@nod.at>, 
	Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, 
	linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Subject: Re: [PATCH v2 6/6] ARM: add CONFIG_VMSPLIT_2G_OPT option
Message-ID: <avdfH-r5kDSrPUI4@gremlin>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-7-arnd@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112112528.1116405-7-arnd@kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4A1DF16000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: 53j75wouczyux8i3qkthzqa7k5pnc4ue
X-Rspam-User: 
X-HE-Tag: 1794597626-913895
X-HE-Meta: U2FsdGVkX1/hmdXFUcYm6+TiKC9g4rzliodqW792AmYY1n+Lrn5FiOcIZXdl0XmDKm5KsAWCNdaG/KmJeceIVPEPieUyya5wFOiXAxORarzF4xa7Fa3sGOqz9Ix0cUw8FWZBPV7WEgvXyVOQ2cR+CbY/XhXhLFGcOoVVxI2SmJZ8YmnW8TCrIzkL6RUYVsbp/ib9TRLZH8T0oqL+eiiSAhYN/K4GVbQ8qji5JEhVQa5sgvRQHt85eFr56OVh88apYBdpdC/2s4I6F5WPA7m7hRmvNnI470uk7sjDmm1pMyk+Pz0p8CCaTjve9ngelyBC4MTaYKCvD8VAsZ/eCXFjLrCwMAFKzoNpMJ/jLQT0HDrnTFfzmRybSIffkUncm2vu3ULfbf8ZJI9Xix/tJxfyiR/SJ4U8ca46ZmKEubKjfDNrUfcEvf9T16S222FpKepnmJoiLxmvrt2wLrXUtfd0UtnVlym/OVDVVUsDYNB3hJ2dYX/W7f/aBDnMAae9AK2KAQ6X3Fkfl9DHPUsky0E7FXFFVaQtnpzKD5eESLRZbkdxiz3N/239bezQXiR2UODU33T9LCoA4NOsSA5jKfaOTZfiIALLUMA73JtoJbuJ3Kh2TiGViJv4VuL4hE6IKJ4JpiGkYuaDbn5ZFj0c7tvV3HtF1A+UAuPm6+Va6+9WEl4VNGsLQgLiNgNzdzfmTHZljHc/82yXJaeP+pxY9FoS8VYpe30du9+RgfguAwu3IyPhGiiGtDhqQFRX6O0JA2c7+SrQEBxJllh/o8Q7oRsT0Q25It6eMNLrVL2+mvlq3rlqEbnh+13OhxIfIcGggWyD8cU8qJXxKX13bjkQPweWhpD+4NnfIb2pvJ6Hhq6IBDIe4AbPAaSxdVf5ykaBPk8Hn/JbpHHv68+Z9p58suIGjGmUlyhbQOp5Zuab+v2j8TBOgllnj4f2tPv1u3HEsW+6GVxBh+id/W6mMNh96SP
 g4QSpc2B
 z0acBJloo1MEPpDkYIHgmahd2YRyjUUQMqRpLSiWIKewtqdanf0hf5lS1BK9MsaGvgYcD4FzVwXDjGOioQI+lMcLdCDBKv8mdHUXlrNHKwMjXiv49AGa+w4eS+nwkvzx93UUb9JIQ5Kt9HKD0u7U+22iiogiKJvth8tn4AdXIWBxSZGiAzZ8Z6xv+w3V4oViQSnN6K03IcE9kVDN8SYUnh3BMl3ewzPKIP1OxTsdr2RKqCJzpaowzjFu/C727HfJJgRG1fRCw4Q9tEKOhw33SikFAc8ayuVG2n0PI1ciZvHw9JM3lNHilLXV4xSrKqQhk3Vty
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 12:25:28PM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>
> Unlike x86 and powerpc, there is currently no option to use exactly 2GiB
> of lowmem on Arm. Since 2GiB is still a relatively common configuration
> on embedded systems, it makes sense to allow this to be used in
> non-highmem builds.
>
> Add the Kconfig option and make this the default for non-LPAE builds
> with highmem enabled instead of CONFIG_VMSPLIT_2G.  LPAE still requires
> the vmsplit to be on a gigabyte boundary, so this is only available for
> classic pagetables at the moment, same as CONFIG_VMSPLIT_3G_OPT.
>
> Tested in qemu -M virt, both with and without HIGHMEM enabled.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

With sashiko fix, LGTM and:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  arch/arm/Kconfig | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 797705a94b28..8992fedfdf37 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1025,7 +1025,8 @@ config BL_SWITCHER_DUMMY_IF
>  choice
>  	prompt "Memory split"
>  	depends on MMU
> -	default VMSPLIT_2G if HIGHMEM || ARM_LPAE
> +	default VMSPLIT_2G if ARM_LPAE
> +	default VMSPLIT_2G_OPT if HIGHMEM
>  	default VMSPLIT_3G_OPT
>  	help
>  	  Select the desired split between kernel and user memory.
> @@ -1042,6 +1043,9 @@ choice
>  		bool "3G/1G user/kernel split (for full 1G low memory)"
>  	config VMSPLIT_2G
>  		bool "2G/2G user/kernel split"
> +	config VMSPLIT_2G_OPT
> +		depends on !ARM_LPAE
> +		bool "2G/2G user/kernel split (for full 2G low memory)"
>  	config VMSPLIT_1G
>  		bool "1G/3G user/kernel split"
>  endchoice
> @@ -1050,6 +1054,7 @@ config PAGE_OFFSET
>  	hex
>  	default PHYS_OFFSET if !MMU
>  	default 0x40000000 if VMSPLIT_1G
> +	default 0x70000000 if VMSPLIT_2G_OPT
>  	default 0x80000000 if VMSPLIT_2G
>  	default 0xB0000000 if VMSPLIT_3G_OPT
>  	default 0xC0000000
> @@ -1058,6 +1063,7 @@ config KASAN_SHADOW_OFFSET
>  	hex
>  	depends on KASAN
>  	default 0x1f000000 if PAGE_OFFSET=0x40000000
> +	default 0x4f000000 if PAGE_OFFSET=0x70000000
>  	default 0x5f000000 if PAGE_OFFSET=0x80000000
>  	default 0x9f000000 if PAGE_OFFSET=0xC0000000
>  	default 0x8f000000 if PAGE_OFFSET=0xB0000000
> --
> 2.53.0
>

--
Cheers, Lorenzo

