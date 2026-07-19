Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05BD8C4451B
	for <linux-mm@archiver.kernel.org>; Sun, 19 Jul 2026 15:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 798466B0088; Sun, 19 Jul 2026 11:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748846B008A; Sun, 19 Jul 2026 11:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 637936B008C; Sun, 19 Jul 2026 11:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA116B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 11:28:15 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 881C8A05FA
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 15:28:14 +0000 (UTC)
X-FDA: 85005907308.11.459A932
Received: from xry111.site (xry111.site [89.208.246.23])
	by imf25.hostedemail.com (Postfix) with ESMTP id D875AA000C
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 15:28:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=xry111.site header.s=default header.b=Y8kU9WkK;
	dmarc=pass (policy=reject) header.from=xry111.site;
	spf=pass (imf25.hostedemail.com: domain of xry111@xry111.site designates 89.208.246.23 as permitted sender) smtp.mailfrom=xry111@xry111.site
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784474893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M9cLc5KCeavLvqvey8T3GJaSSlkbnhyK7B2xSlP36cQ=;
	b=WikOAKtivywtfGy6K6NtctgqSQNCW4Fj5bXrSXZ/hGy0b2/Fye4REI9LsIhG8QkNfqA22G
	uX9aCjp67fqwKfSUh/MS6ZavhVbwpGve71qNUyEgC2/ji0JxfE82xjkgDF8l7ITgtWbbkO
	jnDOAf0iht/ninjgBo2CvzVebSyXhTY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=xry111.site header.s=default header.b=Y8kU9WkK;
	dmarc=pass (policy=reject) header.from=xry111.site;
	spf=pass (imf25.hostedemail.com: domain of xry111@xry111.site designates 89.208.246.23 as permitted sender) smtp.mailfrom=xry111@xry111.site
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784474893;
	b=W0Xn18WJMOGFrLLuWsvMUSpOSiXwJ8qVwMxKfiWzrgw4C6zMXCIXDdeQWe1T9T2vcgWzdv
	+2+9uW8iWSrpsd0f5TQkO/LGjdwdJjTHtd8V/kV9tc5EPLNvU/WLZr94mqj1th0OlQnd2G
	MI5dJoF4sluhMtp5509mYXeeQ1K5DV8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=xry111.site;
	s=default; t=1784474890;
	bh=M9cLc5KCeavLvqvey8T3GJaSSlkbnhyK7B2xSlP36cQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Y8kU9WkK+cdpVa1FWwTNo33TCNLbqs+CtsMBNDUsubka/GMmKe7voYk++QzGXo1L+
	 JnXolGtLv2PvKOgNQ/Mu1ieUXJ0QLNEwPf3JkqXb28VssziLakwknNZRItJrAB7c75
	 hbLVp5xY69RnooxwRJA47xHYIUpzfbP0Djr+5zYQ=
Received: from [127.0.0.1] (2607-8700-5500-e873-0000-0000-0000-1001.16clouds.com [IPv6:2607:8700:5500:e873::1001])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (secp384r1) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id E34CE65982;
	Sun, 19 Jul 2026 11:28:08 -0400 (EDT)
Message-ID: <ba8b2723b563cd290c5c00fb4ec2402626fba06c.camel@xry111.site>
Subject: Re: [PATCH v1 2/2] LoongArch: mm: Expand modules virtual address
 space to 2GB
From: Xi Ruoyao <xry111@xry111.site>
To: Mike Rapoport <rppt@kernel.org>, Tiezhu Yang <yangtiezhu@loongson.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, Huacai Chen
	 <chenhuacai@kernel.org>, linux-mm@kvack.org, loongarch@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Date: Sun, 19 Jul 2026 23:28:06 +0800
In-Reply-To: <alySgaaQen6ZtwSo@kernel.org>
References: <20260717075715.25513-1-yangtiezhu@loongson.cn>
	 <20260717075715.25513-3-yangtiezhu@loongson.cn>
	 <alySgaaQen6ZtwSo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D875AA000C
X-Stat-Signature: 3r4f7ecittfg459ay73cxk3uhcbctg1d
X-HE-Tag: 1784474892-697449
X-HE-Meta: U2FsdGVkX1+U/gbHYr8QwGw4zEqPcWs38V0N6ZxT2e8sY5qCIflFhqbjVquG74z42gU0Ix+8iFIykClnWcnG5RJdlyhj7iHjrB271MXuoXA6rUApuTmfbHvBu7KB+3JZvIvn8i8TWSM451VJtyR3ilHEsKgKeraYjHfTyHW8Qd+V5eA6JDgqiPEqJ3AWT8S7wdGaPNPnhmiMQLqkkLh+SiCblKFg30QLHfXsHrr/D5CQvjeY2ChwhP73YLLgFxJhk3GQpdVclp9nWNTW9HStiAbBpkWV9Lrog0bAqvVvQFj9qJRaoT0XGv6Zba4TGX5Q6T0fDNcrGBd2jGtbqT+jI3J1QZOvX6T7r2tWzdxdrW7weB5ZspasK6yA7Ud46/ZBKK3+aZ6a7Sm6eJwTmxHDDoEG0qGGJcpk/oRQabq5PydOlgO40praSJCeD5p0YW3cEidGyLvS0DUBQoGkZ9rEAdvNERO8pLI//nttPsqOaA+VmUHhoGzAX15Di/IwIq43nJKUqrb/hAtiQPSImk8UT8LDEWn/lSwlEaxWlQ57iGOts/I99DObO8qzSvv/aJVFDniYhG5m3KruQ9agI26exc+IuKIJmrsMgS7HS8ZeVZ3I/RHhOE82RtrkT1W/IbugaU7rA98jdzAjfXzXWS9eixdWGA0gjVDI4AJab/sJnBu2qWvfq0Hib0iQtt9vyjKP1w/wJvzS9SuR0SxbPMH/TnkHRHnNbill9KqVkJdEKgOU0/s5JLQrPoWmO+QGo8BLeC0jg8g1he207PGqYITAR02VgFlH1z0fFgpTBFAFow8VHU8u/ZJrd1GwnvG2GMTSlu1dtZPlJFwXxW6d3iZZkrAuNw540Q8/wHfaoctG1GhbHcFyTloGcIlIgoRS1Fti1n3LurW9bYWTEvpBlK0iFEMf3aPJO+CDFe/PTvsG7Oz7wh1QuEQLMGeATgeEDIxd0RIDJIs+HPELTBKYral
 sFvrBOEH
 ZPudAC7LdOTErC5MR4rmLWq6F0lOZNZ1omUdijGiPMLw6bG2zdboSadjhdYCRr93HVGUAvJNzAfBREDTjf1U34BosFYODM6dte13N1d05f9w6ANcmFX8ga+gooiUhzN6qVT/lpslgJI6npnYsiICUIKwrkJjlpCEGl3i+ObYUqrPrnk/3ztydFMb7JE5jJ+MffJTwBTJdZdJfMd6mqlNPiriXbXlXqh8b3CQekOIi6f8YqVrkBc+UOlcjPYrPr7JSDlRAfT5TQFQY9DV1qUKC+dtOggwZ/loxJiKntuJQnuNiJ1DTL+oe5jfj99l2rWq7Mjhl48OJ+8JH7tjWi6X6ZgoNUHZ4i9wMgi6gvXx3iArTBDFo+OkyhfDpgTnqglxBNI4BA6CtOcZmqNl8xM/jHF10apdrJT04+kK+EuvpgQMp/PJy5QHKtv4Y8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-07-19 at 12:01 +0300, Mike Rapoport wrote:
> On Fri, Jul 17, 2026 at 03:57:15PM +0800, Tiezhu Yang wrote:
> > Frequent "execmem: unable to allocate memory" warnings are observed
> > during kernel module loading when updating the latest kernel.
> >=20
> > This is because the modules virtual address region on LoongArch is
> > tightly constrained to 256MB, while ARM64 and RISC-V are natively
> > configured with a spacious 2GB region.
>=20
> The constraint follows architecture ability to address kernel instruction=
s
> and data from modules code.
>=20
> I don't know what are loongarch requirements, but I remember that arm64
> added a layer of relocation support to allow 2G module address space.

IIUC on LoongArch the size of one module is limited to 256MB, but the
total size of modules can be up to 2GB, as the module loader creates PLT
entries for calls across the module boundary.

I'd seen the "execmem: unable to allocate memory" error loading the
large amdgpu module.  But after I stripped the amdgpu module those
warnings gone away.  To me this is very strange: shouldn't the module
loader just ignore the debug info even if it's not stripped instead of
requesting execmem for it???

--=20
Xi Ruoyao <xry111@xry111.site>

