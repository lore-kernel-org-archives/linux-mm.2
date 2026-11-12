Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CED87606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 13:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=arndb.de header.i=@arndb.de header.a=rsa-sha256 header.s=fm2 header.b=ZFg7XYud;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=1uQLCPUh
Received: by kanga.kvack.org (Postfix)
	id D71BD6B05B0; Thu, 12 Nov 2026 08:48:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D22F16B05B1; Thu, 12 Nov 2026 08:48:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11C66B05B2; Thu, 12 Nov 2026 08:48:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96B9C6B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:48:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 20F801205C9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:48:26 +0000 (UTC)
X-FDA: 85426596612.14.10E9F91
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf01.hostedemail.com (Postfix) with ESMTP id D3E9C4000E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 13:48:23 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=ZFg7XYud;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="1 uQLCPU";
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794491304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRT7mJ1HJtli90asQUPZL0I86WWZMiU/wK7Ix1+t7eg=;
	b=u3tD3t1oA6u7KUbjtT343kZq2OF3XKyNxq79mEL9VUWUbhFExr1qIc4tFQeafqhp+X6/c4
	DOt4rKgAx/KRSD08z7l9gvq/PmYrwhJEfRV9PFzI12t434BIZSnypr/RA8yeWyCKSu0cZo
	piA7iVuqWvEznCSWGrTNP7aNUrLoqhw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm2 header.b=ZFg7XYud;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="1 uQLCPU";
	spf=pass (imf01.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.144 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794491304;
	b=z23oVkyvBAwfMYu/VBdlWzE0pWBCbNHlLC7XzMBNHabaQNnf7ZIdjGF/m+gCycOif6LDLn
	Dxy+UFjghOz2UTpRoI9e548o5ieYywFvJdlPUOB981gPhJznnypBS2v1fVat0RANmvWeKN
	l5O1O/znCsA285/dQ0swRSZoejzsnpU=
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 0A0161D0011E
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:48:22 -0500 (EST)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Thu, 12 Nov 2026 08:48:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1794491296;
	 x=1794577696; bh=VRT7mJ1HJtli90asQUPZL0I86WWZMiU/wK7Ix1+t7eg=; b=
	ZFg7XYud8u3ZU3Vkr/1+eIliGEe+kQpH74nnhHWI7Eqc+HTavuuK9CUC1l9eKjDl
	jxu0OB8wXxkeLLbJv/9cSzU6GZc5Ct1v5d2nKsqHPbE2eB7l1wEap3sBTnrNH9fd
	tHE/oZj3+liNdFO1FR9C/XEbBMz1bm3QTqTsv9uWf9GEn4OB+UsPYx+LzAu+UJJO
	kRuyewpUP8qR94gZ5U+ZiVkd7Y8gPbDaB1GcbLOwO/p6es1saLOgeIvtTtKfXkxI
	VUfs+tVFBkTtn2Hro2xBsdP2fIs8DZ3ubGeDC4d+RPucAlx2znFsP1S5Gpq2O/wS
	nD0UZ6mz4iqcRJlx1HrjTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794491296; x=
	1794577696; bh=VRT7mJ1HJtli90asQUPZL0I86WWZMiU/wK7Ix1+t7eg=; b=1
	uQLCPUhfpBkq2Q22QgeuW9H5rrij5v+JMSy5FM2Wn+bVtVQBLeosNDVadLXZzukT
	3ouV7DnyvuyiCjMHoXchkZDUIAQ5TNEOLM8fzzVTzUmtwfczTeK2Z9KzWhjwH51f
	yDnw4gyc+K0fXZmrcuW80+VEyvEIDtNjgrjgvRYEjyryAv/MZzVXs4TEY03/oaGO
	0ZFAdG+NCCE6y9SCvV2bOMdPwpuvyjJJWHehPsHJjVpsttWDo2kiTwmWwwreEe5S
	85mDPA3PfONLF0QXnmwQletEi95k4tT3wPna+QS8PYV+oeL/9yPHQJP+K4xyjoxj
	ibh6+VdtoW1xNp2Vd7e3A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=arndb.de a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794491296; d=arndb.de;
	mf=PGFybmRAYXJuZGIuZGU+; rt=PGxpbnV4LW1tQGt2YWNrLm9yZz4=;
	s=fm2:rsa-sha256:MB6WJcvn/Kk1VuDBf9A7reiQauBZGJRGkUG2+KGC1hlRHnl
	KlkLb3wZYMUtb1GpH8JWzldjV2mwjkkDy98pgRlIoSiLBbCBLkrl36efmBLc53Gw
	/T4Ey6+QukcUBqQI5ot6TC7RZd6onm682hbH6m+dbUISLRVgMlWE5L8DnjOmcd21
	oGnTsTF2II2BQb5d6FOqI9BIRI6M+z8sHCiisZ0qWEFv2G0iBnMY8tH4EQYaeSIk
	clZm2MQXgzYg6xPAA+aiCDGLd8GRt/bxQo43vLGnfY88XrRG2yrsqMr4Kn9Bsf6P
	x/hQanmtf1XsyoBXc/nAw94urjra2RZj5PB9F/A==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=12;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:cDV/QukbB05DRWJQW1ny9Aplo0b9qlgUV7WG7RUjw10=:QpFJvCcS58Sd3l/liFWB5KOxe2KSj2H6oM6J00vPM5M=;
X-ME-Sender: <xms:mMP1aiXThfwsuTrckyvDNGaYKe-apvviZAyhg0Ae8AMVYARi_onkow>
    <xme:mMP1apb4WFgdoJcRw59RSXVmyyuJBI2enov0nwdM4Ezb_w-TOtmg7uEroPc3LUZ3H
    ayaSunT543I9lWRFx4LIM8LWal-iabylMdGB5cCQE1D66Elz8C01tE>
X-ME-Proxy-Cause: dmFkZTFSmrUQX6bVW+lydj2wLsCuvaSKIx7UJ4HZRXOwisKCAL64G7eTFeLIwxo2T5imjf
    E1T6qbM/BpAj3rqGX7z/WvswXxFcRdzeCXGFLaUKXMMCfRQjNd1u0uFGorpgeWiaCcwvut
    z3Yv2eiVJdW58Aeq1cotcHaZ52EAnYL87aE6+8qn7JtG48eGsTjG5u4OA3wp7Sfct0hPl6
    SJDUdXRl9Cp8oPKmtjGBmtHsBuFdoplTXhuvisAGQwC1Vl4MnT6XIgyth+NfI4Td55nldD
    Gyc31cN9GH9jT3czwpKGByIajJOn4jOEuqZDft6XCP0PJ1RDN5ohH/x11Qe4XbGdlpD9Bi
    D56KnFCMSvcirQwaOYWvKT3yEGTRCa2GXjvhrXOyUbOtNJhcYJmv/mZdKsc0omGFwtHoL1
    ZkKG/RRWMfHUFxSWX1ntYPunZlC++v21L/7td61gFdlBMiQIgffRJiD4V6POoDLDEgTFUQ
    qLkBCOWSAKbdoishupBjm/gVDsjPbYVtEFSRUCDHEOb1xpXvwmyd1YcBXdVJHQO5JfUhsl
    HbYFkwCvwU7fLtFehoAetiILiInkyZX35SSJZx3I+2ihzpc1jP5mRs09gVazpURvT131hO
    5MSiT4pcVHLXcLK6h8mKLFX/3Z8vTZd+SuwiYcvj5SIZIjvgFSDgssRisahw
X-ME-Proxy: <xmx:nMP1ak-egndCZ57bWUj3sKD_G9xgJaCR7wv7-Th42nK5bwH2bvZN8Q>
    <xmx:nMP1akoYo7PrCKZAkPmeWaoUQZXQtHTMUgGLRbP4QtbRmof8uDNWrQ>
    <xmx:nMP1ahPdIaqFM8xIN7rde2bXAYz3_nLjAgCk8jEliTPnIkGGn51udg>
    <xmx:nMP1aq6QcTmNrtWmoW4WwRUC7OR_XhZlbvh63W9H89hpDWjtKomLVg>
    <xmx:oMP1aiZgXBRRtMTvaCTvs1d8MGU9Z8LHyeZ9oDKxj_7O-wQc2k1st61T>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 6C4DC32A0099; Thu, 12 Nov 2026 08:48:08 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-ThreadId: An903QizF2Ds
Date: Thu, 12 Nov 2026 14:47:28 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Arnd Bergmann" <arnd@kernel.org>, linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Jason Gunthorpe" <jgg@nvidia.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Lorenzo Stoakes" <ljs@kernel.org>, "Matthew Wilcox" <willy@infradead.org>,
 "Malin Jonsson" <malin.jonsson@est.tech>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, x86@kernel.org
Message-Id: <ae1a379b-89be-4284-b65e-4a6cf6aeaabe@app.fastmail.com>
In-Reply-To: <20261112112528.1116405-2-arnd@kernel.org>
References: <20261112112528.1116405-1-arnd@kernel.org>
 <20261112112528.1116405-2-arnd@kernel.org>
Subject: Re: [PATCH v2 1/6] ARM: remove support for highmem on VIVT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Stat-Signature: przo7hkidzrbhu7ugmezfsmxi11k6t7b
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: D3E9C4000E
X-HE-Tag: 1794491303-154434
X-HE-Meta: U2FsdGVkX197gAPWTJzLga26eethvGN8HwyBKjYK7CmRt5j3fXlmWSjPmsao38XKnHtjKx2M3DNcUW04Fck3hxe0EAC6OOm3LVCM6iQ/OmFQL6THxNThzDdlG7sHHzxmtGhDSaNNobtl6rqSZJ3JswoLbd3oVsSJm/FC7YezWW4HJcyFmgr/uGxS9BkE1+CqJ2F/NMXRIYwH1Gy8UTcu9q1MtG21Ci9Nk9NXDFj3pG598VimmbGy3RNYoWleue3ljfHExm2oQKfTNaz1sshDZUKVaylirQXzlrRy3W6KQbFpHqSk4V687mQGM144szsMMIsqFfgCN0zI6bpuiLUfZSBZ8Eb2vd+2I6W44hh4UHROOXCi1O1PyCiwXgUvVuFgUy83WOuAlW009YrX1QP7pbdPAFoalInBtynlTxABRmgsNk+DUIZBmUasZY4zJRM+2CxOiXz7Bfq6PKAMxT2i1qrD5I2Pu6ipSoHt2Ny2BzAgnSVehq4slfouSKUaIOoS9Jc9ECtoxlfMb9SLGQ5vNjLLcHLjuO8rFNyg2n9I2Q9JjRuSXYoHNnlHohVa2kShY2FkqLKllbN854SqmYcf4f4y2+uWft+CzcOUGl8Ub4zJXv1rhdeQewNDAHeFz2AXcRRGGHbkprar0rpY73boryWwXcYJyf56bu4by2mSlT/l3g6U0Mt4iFQCYRRKrtbxUH+dNL9oaT74JXrvlw3/b503LJPElTbQb0O/MUubNvXfbNOTpJmgM3BhJv6RnVlQoVhnE6FdLX+B2F9yGg9fEbn1KM7me5c44OFL9lf/hqnlAKHHByLnYiPbBiGgPNZU/DunoPNbBu6MzSKusPblnDD6ubaNZf9NT9A0XB50dVB4lKRNhXt1VwXPruKzxGzrfeiPYqKgKdP1Z7IS3WklQs+5P/LCA9lnVJ629lRbSZJiFpR51VuSsPRQbWpjOsCvTPJ6Y5RNhZ+DSDZwW2S
 L0m//1a+
 UmKw/KN+JNV5NwadYVAiKdp2tNHy8NfJRT1ZYxrUSy7qOyroctOEQwbA1GmXmx+39cCv/xAiyQcN609zH41a1NqedULzLt/qIiNYzP8AM36hb5HyWzrtjs6LIo1z81FD70By3Cnf0W67FKhPkvj1J7k39bC/dQd+zbM3t2ARzN26j74Njp+ctDCu8OZsgwYavJAXazF8wkhelFdcdsRNEHTfV1ppqdIqEgL5P1UMOihvquQWBkQr2PRSNOQqfWeFQG0tADkBgc88YBA3LZ3RUrdxYDPX9+lu35aNt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026, at 12:25, Arnd Bergmann wrote:
> --- a/arch/arm/mach-omap2/Kconfig
> +++ b/arch/arm/mach-omap2/Kconfig
> @@ -135,7 +135,7 @@ config ARCH_OMAP2PLUS_TYPICAL
>  	bool "Typical OMAP configuration"
>  	default y
>  	select AEABI
> -	select HIGHMEM
> +	select HIGHMEM if !CPU_CACHE_VIVT
>  	select I2C
>  	select I2C_OMAP
>  	select MENELAUS if ARCH_OMAP2

I'm not sure where this comes from, it was probably a mistake during
rebasing. None of the V6/V7 CPUs can be built with CPU_CACHE_VIVT, so
I've dropped this part.

     Arnd

