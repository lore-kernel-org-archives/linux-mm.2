Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F859E94626
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 01:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25756B0005; Mon,  9 Feb 2026 20:04:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A87C6B0088; Mon,  9 Feb 2026 20:04:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A7E46B0089; Mon,  9 Feb 2026 20:04:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 77D226B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:04:58 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06ECCB852A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:04:58 +0000 (UTC)
X-FDA: 84426752676.26.F7A1663
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1BE39140014
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 01:04:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770685496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZORl5srHVvzh4OECl5i9R9gCKfuurinWz95/Qxt39Q0=;
	b=oXp8pp4GR2wwNFHLCkPcukhH2aRoTucuOxSJqsnyFs8jzwVkyYuKKXNb/h6bQKYslCx3bH
	pMB1U8X4mKfvdjMlMMSmHyjVYJIXHBYGPHXgfhii9iMtjJeJiVedlrDiON2WRiFSEB1Oa+
	vgSq9KaQmVD/ggEUIb7nlvHA+2Z2Tsw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770685496; a=rsa-sha256;
	cv=none;
	b=jB97IlDFT5z1jnFavr5CfFAk+O7gy6AUDJ6MGZYsHgjgDDU/3lofGJHnZ+Aa9zHeU1qD++
	zGpqRPvZlo16e0NQYGXkIeE9cNi5c250a+G60lfy0AX0vOid1xsaRfibz88+k81D31FTJ0
	gChkYyDmzTQ+8Nw3gHma+Qf0Gxp7ey8=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61A14XcN4119147;
	Mon, 9 Feb 2026 19:04:34 -0600
Message-ID: <bf0231accb89709968efb4d8e1be9970aeb716f8.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Alexander Potapenko <glider@google.com>,
        Marco Elver
	 <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>
Date: Tue, 10 Feb 2026 12:04:33 +1100
In-Reply-To: <aYXDeN0WGQG8-cxe@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
	 <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
	 <aYL3zxuTLT8N7C8-@kernel.org>
	 <c3769af482913dd7ee9d5302c8afa990255691a5.camel@kernel.crashing.org>
	 <aYXDeN0WGQG8-cxe@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam11
X-Stat-Signature: mb6o19wuh4g8kb977sp9hk9za8ddy6jx
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BE39140014
X-HE-Tag: 1770685495-205321
X-HE-Meta: U2FsdGVkX1+4OnvOM+uLKx5xHYL9689yoz4/LqPdzDAVGH3KW/YY9VFJM1PeKfTpqHcCksAT7mS7848UvJ19h7p3WytjBYBusSpASMFAmg6MMHmpy/bf9mZLza/ox9F44kW9rwhbMWFiLpf12tAGzmDc+9VHjJOBUj/uYSXaVF9epLBCtGhiIGwkchJWJKkxdTIqBpAeCeeIa4ei1iZ+hmJBHTC6ma1ACUS7PUqQhNzKmXDThW/2IUxiIJQks/HBsqbsPkwLrKyf7Jw6B6l+XwY5xaknRtbfRBPXw+oY2Gcp4RBZ1F7IUV+SOMP8XScBuarjuu9MuRwQz+LX2T5nLUUbUiEvij/8K1g2evoDzgsGZsw17rYiKgBITgCiTKWz/YSAnQQt99IrRx3vBWdfA8FOck9g/EpLIZoW1u5uh191oKFoorNFwent4Mge7pjSR0Yi8JF94lkYLmqQoLeCwiQY2rMD4ISPbLTphJeMOAgOOJaDVtv6uLneShQGnJIdD3WOIbLLe2RTZ6f29Veok3coRSoRnV8ESEYzYC1paeEp+VcoN+Ufp/+DSXWgN0+TWHBu8SSRJ4VWdbkzV9ATZDZXOPCZlnEovf+P8CUgmLnU+xpFIyc4d4P7lxfzuBH311hvTHBM2h+M+bGl/1DLZzd+9vCFrcNlagyQ31zhPJ5FQ5X+hBxVeGGG25yXgyj0uRg+aBT2aCGxr6qRHpbNQuMd/llHljfcgMEgvnPOyub1pOdCJ0wFcV9+pePPJHs4VRUitwTCYSuI53HsHIH3gF2wRKkGYk5Fsb+5oklcTnR8V+x+i4TTx1JQne163reAfr7OWiM5FSalu0pevTVMgepRKCPwsYg38y8ZME4L2iTj4CYL8q1L/Mc4ef4v6xACuZ0ipZDZw7d1dbyGsVO2aEiGHrrwihwTX8TQOVqkk/cGsW3KnQ7Mzf7b/2jtUJnSIRtBkdZpB52YNhSBfEL
 oORWl3B0
 IGYu9W1FbjXk8IofzhKy6r3c4R+7wceBxGLMc+B6UJW0onK5/R0I20rIs4LlOawtHV3skKhgYKU7gKEfVH36gZYUlEObBKvLLO+Tk77uI2XTWXiPC3EihuFW0FA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 2026-02-06 at 12:33 +0200, Mike Rapoport wrote:
>=20
> So it essentially becomes "oneliner" :)
>=20
> diff --git a/mm/memblock.c b/mm/memblock.c
> index e76255e4ff36..6e984bcdf6cd 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -1770,10 +1770,8 @@ void __init memblock_free_late(phys_addr_t
> base, phys_addr_t size)
> =C2=A0	cursor =3D PFN_UP(base);
> =C2=A0	end =3D PFN_DOWN(base + size);
> =C2=A0
> -	for (; cursor < end; cursor++) {
> -		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
> -		totalram_pages_inc();
> -	}
> +	for (; cursor < end; cursor++)
> +		free_reserved_page(pfn_to_page(cursor));
> =C2=A0}

Nice and sweet :-)

I'll spin that & test it and send a v2. Thanks !

Cheers,
Ben.

