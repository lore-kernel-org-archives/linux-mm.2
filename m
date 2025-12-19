Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42506E66882
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 20:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BB796B009F; Fri, 19 Dec 2025 15:20:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6648C6B00A0; Fri, 19 Dec 2025 15:20:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 563F96B00A2; Fri, 19 Dec 2025 15:20:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 45BB26B009F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:20:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E776C1308F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:20:47 +0000 (UTC)
X-FDA: 84237338934.02.7B87F07
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf06.hostedemail.com (Postfix) with ESMTP id BA7F2180016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 20:20:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=Ioywp382;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="o g8IXOL";
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766175645; a=rsa-sha256;
	cv=none;
	b=S/WDE+T41fQuPIUMpnfpBYfbM/6u1zbesS8YPcg/KJOCrqptLG/sid1ftblIGdDDTzjMze
	Xh3nhnL9yGRDw1ZvjPvk+8MdoV3HTFe+2V4VIYnAzFnRhHVESanY4+K4gMvAQQvVxTZ6nc
	w+hxMnMqzn1wYupeerBYDwOJlXPysgA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arndb.de header.s=fm1 header.b=Ioywp382;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="o g8IXOL";
	spf=pass (imf06.hostedemail.com: domain of arnd@arndb.de designates 202.12.124.148 as permitted sender) smtp.mailfrom=arnd@arndb.de;
	dmarc=pass (policy=none) header.from=arndb.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766175645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ajgf0rKRRQ9LFo13Zd/qc7LeQHMbNIDfCQBML/26PZg=;
	b=tTiHNQm+glEcd5gD4PIAE7SXtIkCttcoC3+zeJkAzyFFM/eMXxzisyUVZgwz5kp8yFfzN8
	LiuHOAXkHxx1490HFum8+1D6+9qHygXujql1q8+pQAr1cINtZG+QZR4qNdMXgdZgzsyRIi
	FDU37N/ahcAxQiJZuJ72HfrUEZyk8g8=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 0EDB51D0007A;
	Fri, 19 Dec 2025 15:20:44 -0500 (EST)
Received: from phl-imap-17 ([10.202.2.105])
  by phl-compute-04.internal (MEProxy); Fri, 19 Dec 2025 15:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1766175643;
	 x=1766262043; bh=Ajgf0rKRRQ9LFo13Zd/qc7LeQHMbNIDfCQBML/26PZg=; b=
	Ioywp382GijI9RzuguD4NiwqaDlYPhRLkudTYDqIBQ08GKxMFSBofLiIUD6ko0oU
	a02wVJnanc83P0N1IGm4FdSzAfuaB+r/ffrnqdfID10whA7hq1HwpOKd56dnDYIa
	EdKKs1fUmSWioraACcR3WQUzBxBm5yPJWqSYPOMEYC2Q2rLY2InlpUMqj3PiysVa
	NHC/Oe1I/6N1LJff22F8v4n0nUwc8MmLPBq6G5RPyFyAwBnsFMaZgdY6J7uvsHLX
	J2wb79TXw/rde+5pNU8cSjmru4/JtY2VQwsEJXZDPTCJhk6zvYYhePPGPrgrMqSe
	nOpqFdz9nTJAmF15h19D0A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1766175643; x=
	1766262043; bh=Ajgf0rKRRQ9LFo13Zd/qc7LeQHMbNIDfCQBML/26PZg=; b=o
	g8IXOLtfcHmaPL/0tZhx1BWEKNIJZCEw9DZ5WGPkXcXTrBTD126XAEvsCVNE09wm
	rFBXvkfM8nr/Nqk2egzJZPfL4XpKnJH37cR1NXfCri9sByVXjNgX1TVrFGy8gub6
	uzicqc4TpRKy1jhdKI2q+y4ahDGI5qIvNk/81IlehrMxWg0pSwFuB5sf8rCCzfTh
	gd0tBv8kzKJbkBwiE1MVF7HsVOkDtRRGErcdFd/8A4v8cPHxRTAuFDiCcZaHnla6
	3l+aVuWzvnz37xZu0WxD1kTXeYvKUkiqq4E/15FmeRIBaIvH3kSO6P4uoBogdhP9
	SBdE++ev1wYdh1lmiNEXg==
X-ME-Sender: <xms:mLNFaYQBdrGx3L_x-6cVNW-PNixpsjzM1Yd6uyWfxNVxe8ZZ6Glwjw>
    <xme:mLNFaQkR2k01XAMccHs0N2kkNp0_rfQILSSqWH3qZKPoKvaf3MHNxi6IeMoobAgA3
    xfhg5jlgoV4uWdv9LOsw-vu7qgVmUKtjQd5QHMViwDFJwKFV_SUqQo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdegledvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefoggffhffvvefkjghfufgtgfesthejredtredttdenucfhrhhomhepfdetrhhnugcu
    uegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrghtthgvrh
    hnpefhtdfhvddtfeehudekteeggffghfejgeegteefgffgvedugeduveelvdekhfdvieen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnug
    esrghrnhgusgdruggvpdhnsggprhgtphhtthhopeeffedpmhhouggvpehsmhhtphhouhht
    pdhrtghpthhtohepsghpsegrlhhivghnkedruggvpdhrtghpthhtoheplhhinhhugiesrg
    hrmhhlihhnuhigrdhorhhgrdhukhdprhgtphhtthhopehmphgvsegvlhhlvghrmhgrnhdr
    ihgurdgruhdprhgtphhtthhopegrnhgurhgvrghssehgrghishhlvghrrdgtohhmpdhrtg
    hpthhtohepnhhpihhgghhinhesghhmrghilhdrtghomhdprhgtphhtthhopehsuhhrvghn
    sgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopegurghvvgdrhhgrnhhsvghnsehinhhtvghlrdgtohhmpdhr
    tghpthhtoheprghrnhgusehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:mLNFaWoje0ZTjN4FWEG307qsoelv8UP7xuwOV-bJDlPneRgqHoxhSQ>
    <xmx:mLNFaY4cHwgKqJc2hMLfk2iQM1BIuaryrhSrPa-TOjP02OcwvFVYmA>
    <xmx:mLNFaYJ0tukoZqhoq8MtrkOcZIcZBCdTfMFUftiVM5EHFLLaD8nt-w>
    <xmx:mLNFaUnow3ag4xv8Fc1BEkx1u7qedoC76aowy9QsDziIR23OT3VabA>
    <xmx:m7NFabOykPl24tgMULroiVZq6vEE9hmNtVVs6Fr7pVsm_3xW_iGmm6Cb>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 99661C40072; Fri, 19 Dec 2025 15:20:40 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AhgucsMdbVXw
Date: Fri, 19 Dec 2025 21:20:20 +0100
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Dave Hansen" <dave.hansen@intel.com>, "Arnd Bergmann" <arnd@kernel.org>,
 linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
 "Andreas Larsson" <andreas@gaisler.com>,
 "Christophe Leroy" <chleroy@kernel.org>,
 "Dave Hansen" <dave.hansen@linux.intel.com>,
 "Jason Gunthorpe" <jgg@nvidia.com>,
 "Linus Walleij" <linus.walleij@linaro.org>,
 "Matthew Wilcox" <willy@infradead.org>,
 "Richard Weinberger" <richard@nod.at>,
 "Russell King" <linux@armlinux.org.uk>,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
 "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
 "Borislav Petkov" <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
 "Madhavan Srinivasan" <maddy@linux.ibm.com>,
 "Michael Ellerman" <mpe@ellerman.id.au>,
 "Nicholas Piggin" <npiggin@gmail.com>, "Michal Simek" <monstr@monstr.eu>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>,
 "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Vlastimil Babka" <vbabka@suse.cz>, "Mike Rapoport" <rppt@kernel.org>,
 "Suren Baghdasaryan" <surenb@google.com>,
 "Michal Hocko" <mhocko@suse.com>, "Nishanth Menon" <nm@ti.com>,
 "Lucas Stach" <l.stach@pengutronix.de>
Message-Id: <bad18ad8-93e8-4150-a85e-a2852e243363@app.fastmail.com>
In-Reply-To: <a3f22579-13ee-4479-a5fd-81c29145c3f3@intel.com>
References: <20251219161559.556737-1-arnd@kernel.org>
 <20251219161559.556737-2-arnd@kernel.org>
 <a3f22579-13ee-4479-a5fd-81c29145c3f3@intel.com>
Subject: Re: [PATCH 1/4] arch/*: increase lowmem size to avoid highmem use
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BA7F2180016
X-Rspamd-Server: rspam04
X-Stat-Signature: 3on9s6ysw9eigjo4daxbbbrss76179ni
X-HE-Tag: 1766175645-710064
X-HE-Meta: U2FsdGVkX1+CkfNbLGjMiC8IcG6KCrnD8UbSW9G3tE7xd2ZC/Mk6IeJZ+bb1Q6f2bs56DbaSANNHNTigUzBPIvdlXbMD6haZRHvNQ5BNeSzXSAYr9PpaLi68z9Mbz3REkgdiLrWrvdxoIgnEVc6bYZ2USuEPxaWQ49QNFEF63xFzi4uRebKWmkmtOb+W4F8skWNOa+5qQd6YsikMzfiSU3iqcs8WYj1aTSr/h9T276eADVg3vBVQjvSnLCXqcms4DY3aLNitMBdDNjf5py/h10WdmACbx3S9qTxuvZKfcAXzE37O19QyNfN7TCSTaR2Y42TPCl+tPyxT/fcMQO9fwv3YiYV5EZnFV3UUDjNsX3SDoJrPw6g5kM8zeJIY6ci+qXzfwuOKeFr1mrD4yohj79DibWwMaroks/d8MIXL4b8Xn8vUkISZgq/nQjM5A0M56B/Diqezl7BRah0f1bb5efWjSJT6PY3ULUAXJqKpsDD8NPn4cvZG5ZlVvxmhlWcCay75YBAGqsm2RLWZCKMwoXLkM7/Qz4HuW/1N/vGd8NNZqxvWN12ZsMi6UGRUiE7I95FelUVg1kEF+DkZdpe5uneZoxyLa9mxv62xaiMNAFu7ZJ+1hPAeiLTBjxOerRF/stc8ME9h/UDh8Oej6PV/Oy231uVKZtaYW2x3AQ/l31xoZB6wg2QEP6bMvEfHr4/kNlPOUiq7Wx3Qlu9FKRDx+HTU4Y9ZpBABMg52gEdaE3Kd+xqLIgGSdznS0FlNSP6n0GdDcRHHIeMUyyOD6UZJoYpFL1gYvKLkEufH4MCyRnfW1lEip5IzKZXVQsiFcU3od98fPMvgdmHzEcpHkJzP7KKK+zDu3z15Z/ryc4TxF/hQJj46ACPDIPgNSXCllHN6Zw/V6t++w9fK9Ly0qEWAXCVA4jp5XHuI1nTrLjdfu6HZJRD6sKINiwpPkH55TbVrG9tnb/DcWFy+iwlSkyX
 ihCfLXJB
 gFU81AsUKQnLrFVI3krQKBbnmzBG0DH0F7r9G+p43iW5TnMsZcmzQWM+ZgTzcvgrMcEz/66U9qxlYJrlume9HTrjRoAZSo+BpU9b5XaJjCwliqPnRAuXXFy2J/HB3LHwkqIkBM9Hr0oBxRcA+NlMRQaCF+AUfHpYLDAjQShgzy8n9SzKiKmDLkRjPvSWGGzNWucLMMhOJtci84b9albGlCysGeFe+Zkj8uFJx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025, at 19:02, Dave Hansen wrote:
> On 12/19/25 08:15, Arnd Bergmann wrote:
>> --- a/arch/x86/Kconfig
>> +++ b/arch/x86/Kconfig
>> @@ -1416,7 +1416,9 @@ config HIGHMEM4G
>>  
>>  choice
>>  	prompt "Memory split" if EXPERT
>> -	default VMSPLIT_3G
>> +	default VMSPLIT_2G_OPT if HIGHMEM && !X86_PAE
>> +	default VMSPLIT_2G if X86_PAE
>> +	default VMSPLIT_3G_OPT
>>  	depends on X86_32
>
> For simplicity, I think this can just be:
>
> -	default VMSPLIT_3G
> +	default VMSPLIT_2G
>
> I doubt the 2G vs. 2G_OPT matters in very many cases. If it does, folks
> can just set it in their config manually.
>
> But, in the end, I don't this this matters all that much. If you think
> having x86 be consistent with ARM, for example, is more important and
> ARM really wants this complexity, I can live with it.

Yes, I think we do want the default of VMSPLIT_3G_OPT for
configs that have neither highmem nor lpae, otherwise the most
common embedded configs go from 3072 MiB to 1792 MiB of virtual
addressing, and that is much more likely to cause regressions
than the 2816 MiB default.

It would be nice to not need the VMSPLIT_2G default for PAE/LPAE,
but that seems like a larger change.

     Arnd

