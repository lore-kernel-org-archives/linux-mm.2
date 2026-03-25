Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7B1FEA803
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 04:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F098D6B0089; Wed, 25 Mar 2026 00:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8C36B008A; Wed, 25 Mar 2026 00:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCEE26B008C; Wed, 25 Mar 2026 00:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB2B26B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 00:02:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63F22E02D9
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:02:44 +0000 (UTC)
X-FDA: 84583239048.04.F98158B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id ACB9640008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:02:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mUgovg8O;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774411362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZ31552Jf56EyGf+Azy9UhDPa0IxRsolKRX24gshYl8=;
	b=b9OmmqTEYuVpS2rB8FSqSRxZvPTI7U53FcB0svfqR6BefxYZLAPc3fraVjB5M/AiVNcoDZ
	bAzujPNyHa+8FrrQ1KiHwYLDzDlyMKVwQdaTZ6Af7yoolhSdt45Ojp2vSjNWYgrrTZff6Y
	hKEelstvbhQORt6eJ40FUPKcpre5ZXU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=mUgovg8O;
	spf=pass (imf12.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774411362; a=rsa-sha256;
	cv=none;
	b=IYQgp0RRUvOmFkBa7F6X8vVo5hQNYYzQTD2J2ZEKYY+oiCrtsem1sWWC/nnerCJ2MVWSWZ
	UJxOpC92ZiN/9d7p5t4FpxuWf4BtZSLjQfDVxiss92GCX11eynITDuC+lhOaP4eOk8l88b
	OOU0HJj/aJsBEFmCHAccoT39ZIXlqxg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0C658600AC;
	Wed, 25 Mar 2026 04:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB3FC4CEF7;
	Wed, 25 Mar 2026 04:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774411361;
	bh=UAftIg0iP2CTL4GG/cYK3JPqeZRxazTdlKZPm4R/BjY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=mUgovg8OO4pY+wWN5GhLHYSuthRryo4Vg5p5G/q/Zzzm2h2i4H6F6brO17xhMnGul
	 zpB6+wcWXGLeJr3/UxJVYxl5Cekya4sXNHgB8+z8UiOhR9zmXnhupb2nhyGCBdvSd2
	 PpiGwT32uVKZ7pf9RW98JjbN2uxq0ceVlJbYoSCY=
Date: Tue, 24 Mar 2026 21:02:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Ard Biesheuvel" <ardb@kernel.org>
Cc: "Andy Shevchenko" <andriy.shevchenko@intel.com>, "kernel test robot"
 <lkp@intel.com>, "Kees Cook" <kees@kernel.org>, "Paul Walmsley"
 <pjw@kernel.org>, "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou"
 <aou@eecs.berkeley.edu>, "Geert Uytterhoeven" <geert+renesas@glider.be>,
 "Dmitry Antipov" <dmantipov@yandex.ru>, oe-kbuild-all@lists.linux.dev,
 "David Hildenbrand" <david@kernel.org>, "Linux Memory Management List"
 <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-nonmm-unstable 49/110]
 __efistub_cmdline.c:undefined reference to `__efistub___lshrdi3'
Message-Id: <20260324210240.ec7ebca1b16a8fe6ed610f62@linux-foundation.org>
In-Reply-To: <529d4fa6-e163-4b4b-9c51-f9f880492b76@app.fastmail.com>
References: <202603041925.KLKqpK6N-lkp@intel.com>
	<aag95SSwClx4IzJU@ashevche-desk.local>
	<aahAgJ0G1uYSCFnF@ashevche-desk.local>
	<529d4fa6-e163-4b4b-9c51-f9f880492b76@app.fastmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ACB9640008
X-Stat-Signature: tw5fkctat1fhn5x1cjjeamodmoya7s7t
X-Rspam-User: 
X-HE-Tag: 1774411362-652399
X-HE-Meta: U2FsdGVkX1/kRffaDfZ1afGrgVZDKbzbdDk1GJ5F8OWf/c5SUNfaqqwP9GFgOW5iUazL9vq08XXxsE6kQPzrp7LCkGjJSHk07rOL8ebmlVbn/ZxAE6hGbWEEjgUSJwtajK0qwg++V8+Uaw/7Wi6u5jCq5P5Yp8uwBDeI6vIrYZOYA/atQyGtOncQF9cGpt51MeBR/YVn0wxNZbw8xL8yG5gIDOKHg9Tzo31Ulw0UgI6eMp746WwsOzG9DUfQwYAtBZJZZnnStBIZB+76Q4RO3VwPZAYAuqBvSDj2E5sZFXsHAXc9bTGoMuKwlyh5yCjaRtUyZFrzUldkgJg8PLip4gz/S/lVQ6Ugz3phR+dwAIV7fQFH28VVjf2b7I2P8P0kCwcQstiac+0cpEC5hb2PEMsEel58ed2kaby7haZBByXmxF+JN+yS/yr73pmR55Qs4Fj43XC5bw/D5guMjLt1hjIEFI7zgrvyfg5xMoSsNccuCfejZRAq4wrx8IOiMyIqsr0EsvVrroTmZFUElHP+ExCYbuNkh+VfAw6uPs0R2UsrOz3DtHy1Ckzfx9CMu7k6Ju702rtWBW31InOoIattxHY8p/RKawL13Y3tIb2xqvIBFvEY+ulpI/Dly//flToZ60RUzyOFjPSie9w10jVcF+xmkk3vXTDryBJwzll+cAokKxXledfXfs0/HJz6TtVbmm4lhx/aJJAw85knPS5ZJ8JOYP5SMq/QObwUK7ZgohUV0oh1ErGhDR/reCzVRgQhDUzjGz1X2fXp9k7MFckf2m1NUhDO24SCt9lEgQatjP8uOIBFmbNfIYCNPJE8yqmBk4250slMXDXcLI6NFXO+4iR2eFmyBFdlUj8MdazxTrM36MCFBpkmxXJpLwwb/qzIiVodcnbKE96TQz7vZWWq14+uwC9s1aI/Ng+XFgQed6N4v8CPplPVXjxfGLkRtwMu7Y0PA0BHD25ivwoWEMV
 y4ZRham/
 iIlWWNTQVxxR0nV9qGZkuiZ3UAp6CFg0+3LwmUzA/EuXsVpsxPDa6aIQU5N9hiui29rcT5gqBXGa8uiHumj3DgvutdC0k8qgN6WcDGTqUmY0ssv88nz1RqgGjwF2/5nihOeaSU90lF+Mi9fS6LqyDKAibbyAlTRIWBdaTVkASmx9X7zZu0hEtBIf1LPCzUx1sLNQ5LhT6E/erR3OQGw3mgrXmr1W92dTWdXUnE31YkPfQ53dNXf4r7LDAw+Kgll5dncc4EnAP7iVLiU7kvHJ7jUjLIvtwrFGbng0thPFrYEijVaJqcNGjDONDT6Pv1f8ncsiBnBxyCCIRRtQ4eSVMd8/702TuqkpuKQ3t0nje+O9ovJoVX54jNuyu+9r9etZYk9oqp5FU3+im1+F2vNykCVd0Tg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 04 Mar 2026 16:35:01 +0100 "Ard Biesheuvel" <ardb@kernel.org> wrote:

> Hi Andy,
> 
> On Wed, 4 Mar 2026, at 15:24, Andy Shevchenko wrote:
> > And since it's riscv, adding people from there.
> >
> > It might be that they simply need to include the corresponding library to their
> > architecture builds (we have lib/lshrdi3.c)
> >
> 
> I didn't manage to reproduce this, but if EFI boot on 32-bit RISC-V is really a thing, then doing the below should be sufficient. Alternatively, we might just disable EFI boot on 32-bit RISC-V, as I don't think it is likely to be used by anyone in practice.
> 
> --- a/arch/riscv/kernel/image-vars.h
> +++ b/arch/riscv/kernel/image-vars.h
> @@ -31,6 +31,7 @@ __efistub___init_text_end     = __init_text_end;
>  #if defined(CONFIG_EFI_EARLYCON) || defined(CONFIG_SYSFB)
>  __efistub_sysfb_primary_display        = sysfb_primary_display;
>  #endif
> +PROVIDE(__efistub___lshrdi3    = __lshrdi3);
>  

I haven't incorporated this, so the series will still break the build.

Dmitry, can you please test, review and ack this?  Or should I drop the
series and we revisit for the next cycle?


