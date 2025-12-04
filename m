Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B93A5D206A9
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:16:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22FCB6B008A; Thu,  4 Dec 2025 09:16:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2072A6B008C; Thu,  4 Dec 2025 09:16:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1451F6B0093; Thu,  4 Dec 2025 09:16:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 020A46B008A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:16:30 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A6DC1401DE
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:16:30 +0000 (UTC)
X-FDA: 84181988940.13.C335582
Received: from sender4-of-o55.zoho.com (sender4-of-o55.zoho.com [136.143.188.55])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7738B160020
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:16:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=GsbHQqeQ;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf08.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BbWCE/CpKUDF4JSDA7vlb370W1f2kNu1LZOcbo6yAs=;
	b=j81xFnbXcjo/RljNFmnXIRoIETFMASponMAvQm7JgLtVmd7hPbiC6fIOMmT6uCx7ISggLc
	CPLvyGAQqe07N00sdIbcsuuI/CYJkh1nBSZVoMUO6wYn98LjpMR+8aBzEK6YXkLnm15Iyp
	Kiy5mapA/vB9Dy1I9Vt6xOLAE+0RnF0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764857788; a=rsa-sha256;
	cv=pass;
	b=iBnnnH984TOSAjJZBFWxaqZqn3P/2syS6X7pMg750WpzYl/jTlDLj78npfLzciiWq5OQuE
	srdw5mqKES8uyFxcQSO7gJ5Fsz8s7cln8bPIuKYU4spn0ihiAEoyksSMR9o7lgezbb4NWs
	gbosIw8+3JhkmWBwNLeZqCVllElgolQ=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=mpiricsoftware.com header.s=mpiric header.b=GsbHQqeQ;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf08.hostedemail.com: domain of shardul.b@mpiricsoftware.com designates 136.143.188.55 as permitted sender) smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass (policy=quarantine) header.from=mpiricsoftware.com
ARC-Seal: i=1; a=rsa-sha256; t=1764857770; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=clEw83IrwTeYwspIaLvRmWXRoLG616Phdyy4zW/+jQyQY2jLuwyaOLkoiPDZjXj2tsibCNK+tAofll5S81Ofm/5d/CvkEj9VRjUex7E7n80cjilP1IvItrLtFjuEZ97fFFCPS5KQFeUaSLWkOfSTi+S0H1yMEiPSYRFA858Vwlw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764857770; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0BbWCE/CpKUDF4JSDA7vlb370W1f2kNu1LZOcbo6yAs=; 
	b=B6IMjet3PpN/CTo6sMsVIQGXKPxxRFoZUbLswnlX4djDYZ0vaFNtq9O4Cdfs6nKAwH5amvAWsrRoDgXgqIdHfyWPtn3wcWq4cGLHrmOLSkA7t4CM5PJheV2b6Gwpt5BtnwO1pxiiUMbhxawrLsSWd3KlbOCr6S2CMg81FB+7mNQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=mpiricsoftware.com;
	spf=pass  smtp.mailfrom=shardul.b@mpiricsoftware.com;
	dmarc=pass header.from=<shardul.b@mpiricsoftware.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764857770;
	s=mpiric; d=mpiricsoftware.com; i=shardul.b@mpiricsoftware.com;
	h=Message-ID:Subject:Subject:From:From:To:To:Cc:Cc:Date:Date:In-Reply-To:References:Content-Type:Content-Transfer-Encoding:MIME-Version:Message-Id:Reply-To;
	bh=0BbWCE/CpKUDF4JSDA7vlb370W1f2kNu1LZOcbo6yAs=;
	b=GsbHQqeQYmH9KsWBYutliPZ1R/baj0SsieFOaVSCKgaG8OySw0GWTvdWDYQu1LNQ
	ZDjkGCbDLJ+gktF0M91kr8UgvXqTLlsUyhIv09ggduByoUyYIk1C1aLnOFivFtUXS/Y
	vJhcFfbp9HNrlAT0l0ycotxiCS5sQYa5+lbWBifg=
Received: by mx.zohomail.com with SMTPS id 1764857765694732.1743433635124;
	Thu, 4 Dec 2025 06:16:05 -0800 (PST)
Message-ID: <78c9b5eeb10051dd9791ed3cb0ce7a18eedc5e7f.camel@mpiricsoftware.com>
Subject: Re: [PATCH v3] lib: xarray: free unused spare node in
 xas_create_range()
From: Shardul Bankar <shardul.b@mpiricsoftware.com>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>, willy@infradead.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org
Cc: dev.jain@arm.com, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, janak@mpiricsoftware.com,
 shardulsb08@gmail.com
Date: Thu, 04 Dec 2025 19:45:59 +0530
In-Reply-To: <57d5793d-2343-49b3-a30c-cd12dc40460d@kernel.org>
References: 
	<7a31f01ac0d63788e5fbac15192c35229e1f980a.camel@mpiricsoftware.com>
	 <20251201074540.3576327-1-shardul.b@mpiricsoftware.com>
	 <57d5793d-2343-49b3-a30c-cd12dc40460d@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2.1 
MIME-Version: 1.0
X-ZohoMailClient: External
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 7738B160020
X-Stat-Signature: 8z1p7xj5xqpn5d8dxuyjgxysqqwtnorf
X-HE-Tag: 1764857788-995018
X-HE-Meta: U2FsdGVkX1+vMLsRE49FahtexqHGGVGPsmO3Czvf+UXh79YAkE9kDPXMTBRbu0QLTlLHkiAz6PB7VwJPKFwCFJCUmQBbjieBbBpwFhL6k3wRli8p+MLF0QdnYORaqkKYfaPym+sZvdqq84TIdYF9+tpWPAxprp8WMF6P2kHv7le+NduLN+hVfi/9AaOVXbNgkRfiAeste1TJxCAilk1ztcR6wtOXpIurBkeWV98KXOeq1zKmsS0xaM7spssFVZjZjZ+f5Ak9R15/ZMNtxSL6hawbiKahgP4YgzVF7r00M5+9VKCcY7hbHFEwOqJy5ErSFP5ZeOhe9zDVAULJIySr99ZwGJV6jpJEJ4nDgmFg9nwYVNcR+7VFBu4bu7UTrb1zS4psSQ1OjULSygzPLaCV9HG+hqsXZRKqtIOpxd/QQ8yUhGXw/VtEH7oLo4vR2bnzLTkYK2RXC9fw5OtxeAa5Ad9B7EcLbvn/sfaxaBYFoA5gOpiN0AQgjDZ4gXeT33g0BXraiZU5hPLsx2F7q2DqdKiZ+3zeumbRnN15cE11m4tgDCq1HPawDLKIWi+EOgMMZOZcshj449wwzB2yMTpQviNiqCg4/5AUFODzrweLHL6HKojDfsxpFo/Zad3p7jNAJU8iG5FHDa5okADxxAX/7cb2obBXMIxklHfExreteXVcFy07F+y/k9DUfV2XQh4YnlHnGlrFmJuqKfeBkPT+Kg5O1JeermyWSGdkSqYV7spi0El2yN2X4jTxeA3z6cSmOeDEtI3x0YHFhcUImGN5R53B2ZPp9mf7C2N+6hGhwcxDTDU8TLQknPCZMXcSk1eiOVPxZADjGpyxkF2AZyi52h5SaL7tmGx/KUE2xhwj3/AdICEo0OEVdFTEu38t0wZxY18/KGhgFHPRgGqf/TEDyOKLSdoqQR3oU6cPfF3tS/C+S0b7MeRTW8X5UtPIDNeRcQMR3rIFikYl68220YA
 MHROrttF
 SXnqPr2jBgbaJTdszl9LIyuyQt7FBwiuKN95dZ89daYdTJEvT6ZYP5GNmZtgWxZ/JV57w4LvYG6JaC+Aou9mAjY+5SZzDBl1mBLvVUsgKfD7Mn9YXGZ+M4NC92OJpmidZhAbx+uoiwPKlQK52NXd3xmTv0C6uo7LgQlLlTW6ZgDfddk1nKgImoUHrlDpXiCTJ+xBuyjsl9FuKHWv2bszrNV3kPc2zyRRWUKeHf3CQDf7DHZgcPxzIm+8JDsYmsMSiH1Cv/khpJM4rV9yDeOytI+fLCnU2fnXiD0xy+cwlHVVfJDP/1wMlMBSyBvjJEY16yrRMOi2MkQxv3dMmSpyNufhZp0ToG+7bHgSMDffVYOKa3CJsZ1ydyDA0XknlIGFVt84ARhWvaA83ndYy6ZDhG7S8z3tl3LJ2DzoQrkVQoBeo9WxAeFUskMhMMg9fR06dg/KT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-12-01 at 09:39 +0100, David Hildenbrand (Red Hat) wrote:
> Please don't post new versions as reply to old versions.
> ...
>=20
> ...
> The first thing xas_destroy() does is check whether xa_alloc is set.
>=20
> I'd assume that the compiler is smart enough to inline xas_destroy()=20
> completely here, so likely the xa_alloc check here can just be
> dropped.

Got it, will share a v4 of the patch on a new chain with redundant
xas_destroy() removed.

> Staring at xas_destroy() callers, we only have a single one outside
> of=20
> lib: mm/huge_memory.c:__folio_split()
>=20
> Is that one still required?

I checked the callers of xas_destroy(). Apart from the internal uses in
lib/xarray.c and the unit tests in lib/test_xarray.c, the only external
user is indeed mm/huge_memory.c:__folio_split().

That path is slightly different from the xas_nomem() retry loop I fixed
in xas_create_range():

	__folio_split() goes through xas_split_alloc() and then
xas_split() / xas_try_split(), which allocate and consume nodes via
xas->xa_alloc.

	The final xas_destroy(&xas) in __folio_split() is there to
drop any leftover split-allocation nodes, not the xas_nomem() spare
node I handled in xas_create_range().

So with the current code I don=E2=80=99t think I can safely declare that
xas_destroy() in __folio_split() is redundant- it still acts as the
last cleanup for the split helpers.

For v4 I=E2=80=99d therefore like to keep the scope focused on the syzkalle=
r
leak and just drop the redundant "if (xa_alloc)" around xas_destroy()
in xas_create_range() as you suggested.

Separately, I agree it would be cleaner if the split helpers guaranteed
that xa_alloc is always cleared on return, so callers never have to
think about xas_destroy(). I can take a closer look at xas_split() /
xas_try_split() and, if it looks sound, propose a small follow-up
series that makes their cleanup behaviour explicit and then removes the
xas_destroy() from __folio_split().

Thanks,
Shardul

