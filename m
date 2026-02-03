Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53700E7FDCF
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 19:53:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4306B0005; Tue,  3 Feb 2026 14:53:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7821B6B0088; Tue,  3 Feb 2026 14:53:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 681C66B0089; Tue,  3 Feb 2026 14:53:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 53B266B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 14:53:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2F061B2255
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:53:38 +0000 (UTC)
X-FDA: 84404195316.01.C12B1C5
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E4E6180002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 19:53:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770148417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vj2fs/SB3dGY/B0UBSXTKNO7z/avdZ/oXlE1dYI8Wm4=;
	b=raUJXBO0vEZr9x+8ry8g5zxpuyfnI4g+Ty+3cM4YRVUgTPD0UXlyISweuY9HZIIIe8IR6+
	Njn1ICccwX3ONq7qJwJYqg3pEmDJcORAIvP+2gl4E3Alukd3e+nlFkzVcsOnn7UR4o/7FJ
	bZLhgm6AjRW5t7GTG/yhNo0gQCtqIzI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770148417; a=rsa-sha256;
	cv=none;
	b=D+rKOzmOVYMGBJPZpAe0D21wzplzI3q89poJy4Xs81j69Fl9kQ1t4Uqx+691xd5COizS7T
	VrAOWrX2isqe02g3iHM3ADV1cy1nFad2MBxRlO5aeW+WegahAy06Vj2bWCk2MKcUekObcl
	65flfamcBrdZZT3WOaBm2t/4Jw8EeXI=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 613JrT7f3670920;
	Tue, 3 Feb 2026 13:53:30 -0600
Message-ID: <279931074239b7f3812c4cb3969f887303c8cc26.camel@kernel.crashing.org>
Subject: Re: [PATCH] mm: Fix memblock_free_late() when using deferred struct
 page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Wed, 04 Feb 2026 06:53:29 +1100
In-Reply-To: <aYJBBs17B-SQXFqq@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <aYJBBs17B-SQXFqq@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0E4E6180002
X-Stat-Signature: ygjn77q1yi9mcay7q7u74ioipsjicien
X-Rspam-User: 
X-HE-Tag: 1770148415-458001
X-HE-Meta: U2FsdGVkX1+a2micsU7Y4aYkCzkXl6lWD4x5ne/c9eBXTKaXyu9fTaASeDakc1FoGcRXKadthPWNug2Z4qEZzGdasclIeW6TXVvJTKv+TxNNPOYcB62MfTm8Be38BD7RbB1bPUeaxTQ9B9n6uKIxBr86PIwXS5VfA/JW7AGY8CcJfL5YpUjiwEyv3wQuA5qaTkAqif0yt0BQ9pH76BtSqt/FJXyagdAD+OdKZFKkiSJVJIAfg+bv/6YENfgmHwVAuXzpn3jCJp6gAFedXIiu1VCgkxs0WJgaimLpAu2x2Co4h7rcDxZX6KoqtSi6cJGhYOFdSzWwpIxMjvgYYiOcEuC8ve3l86nCGhk0ndjUGO6mvLEDI19yxns95/VXmdxXwkdpZ8fi+Lq/WHH7RSTNsMw2sA0vo4eKGSm/WpMrQjpOHayEzbNYay4KOwXvYAeRulStBVDgz3CYUUwZE+hEnqJAXZc9jqA9ZggPwafcUQ6w2P52/ZFZxU/d6j7HGo3tu2lv/bzPzpS2N8CCh9fIdMxj07krSDqvdEQ6FZvVTsJIldJM2EW/h4vZ/Bdo4burOZ7kl0UtBTc4y53D8U+Z7kgz8ZZ35uc2PJ/nCYyHoZgDy9vC+yAxHxqw8O8Ev0mrW4leuNTffQRSFl/6+gUxUFYpjSuC47TVLFrkrCLT31CwRcynr69fboHJqb5hNpXSSvFAhRcGjDwxT2f9x5/zW0Jh0lRzw3kaco6Z6gDSktNysjP67VBZaS2Q6qhUE3V3FAIc1Me6qnmmxuNkzkMDNFV8aXtFLIwldkmhLcoRKFBEeIhaloj7a/bfoAgGjsIXMi/N9WqLwzwpD5Rr082QEAZD2AhAd1lYu5NEoUyIYRTl1iwrPNra9oyN7AbcGQhgPsU7lMqC0V9p07lAXByUPa7rJM9M+Of0+63gMGrwak80KsD5tSHeJ35tb/yY/gY+gN5g4y0C272fU77xmuT
 FhabK0yp
 77BxvWsEeJXTvYmghVFCfY3O57IK1BXrvZBxegS9pS3aHVMJut4fCoFnQhW/ass/3IeHVanl2JlH9HkQKgZizXklrjLXZfQ3MWvC4JoZ5Wc8iRKZL7gF7cvO72w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-02-03 at 20:40 +0200, Mike Rapoport wrote:
> > =C2=A0void __init memblock_free_pages(struct page *page, unsigned long =
pfn,
> > -							unsigned int
> > order)
> > +				unsigned int order, bool reserved)
>=20
> I've been thinking about after more coffee after our chat on IRC, and I
> believe we don't need the bool reserved here.
>=20
> Since the assumption that memblock_free_late() should be called only afte=
r
> buddy is initialized, all the reserved pages should have their memmap set=
up
> with PG_Reserved set. So we can use PageReserved() instead of passing the
> boolean.

What about free_low_memory_core_early() ->=20
             __free_memory_core() ->
               __free_pages_memory() ->
                 memblock_free_pages() ?

I might be missing something but I don't see what would restrict this
to the early pre-initialized struct pages other than that
early_page_initialised() test, so we can't rely on anything in struct
page inside memblock_free_pages().

Cheers,
Ben.

