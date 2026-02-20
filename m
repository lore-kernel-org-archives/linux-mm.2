Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AC88C53209
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 04:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6226B0088; Thu, 19 Feb 2026 23:58:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254376B0089; Thu, 19 Feb 2026 23:58:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1605B6B008A; Thu, 19 Feb 2026 23:58:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F05C96B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:58:18 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 818AB1B61DB
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:58:18 +0000 (UTC)
X-FDA: 84463628676.23.A9D6CDE
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf19.hostedemail.com (Postfix) with ESMTP id 584C81A0002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:58:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771563495; a=rsa-sha256;
	cv=none;
	b=T8i+E+TVnE0PyA60eaMOFHGEsfEdHaE11D/i3K6jQxL6ICh0S0ePgdTDnqXLnXUWfOD6LL
	46NPaWDaNkfF+d2+GipK8ANYFHuI1C4LgkHHMNPmGdp2DYtZbi2/tA/rjwdAdQ+Br5UqDm
	Pj5qla7rJ2k8eB5i1L3uqIrrmKUaHng=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771563495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QiSa/khls9Crm3bVnShFyzCPFlxULwh7hpyan7F8PE=;
	b=H78sAMo0bFt8jdJKGcm5xNcIYQmrjQkKQC3sJe17cIFA+nhXtyPdr2iNcFrBSsI9QeEr4K
	m80BJK+KK3aLva15VCKU3mkX/2285ZdgROSa9phhgn06zRITXOXHcPo07+saAB8JdUGd42
	S8GEb3eToTTuKS6Cs7Qh+ahurp3ZQXc=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61K4vw98645632;
	Thu, 19 Feb 2026 22:58:03 -0600
Message-ID: <1ef0f899dd03928651d2e07cff14e062be25d5cd.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Fri, 20 Feb 2026 15:57:58 +1100
In-Reply-To: <39289588fddb4844264546cd103ba4595430f313.camel@kernel.crashing.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
	 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
	 <aZVyxKVS8y-rqwrK@kernel.org>
	 <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
	 <aZbjCFqlqdFwKSHR@kernel.org>
	 <39289588fddb4844264546cd103ba4595430f313.camel@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 584C81A0002
X-Stat-Signature: e38nezngfb6n1pnksqzazww5yfce69cf
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771563495-467443
X-HE-Meta: U2FsdGVkX1/E2r2fN/ne8iom9oBr/nTUxd4/RuwA2x4qHbvPzo3tvYOzQAJPmCFfKGmzk0nXIxI2VuAXkAPJtYbOtdj3iO3SynbFqT3koHV37x8qQ/3Y86oal4K21Uf/WhLY5bND4Qq8QwkieSnDeabfZNuyOCRO6278/urFapw7lVeW9rLijys3JULlxZaDNePK+eCwzH3v2Ie3lQQNHYjIq+JIaRRqua29HKJ0xiD6S4iXowDZpczavspcVcU+DXpKWdj33M7wZnEJ597eDBa0PaC2cGD5hGG8oFN09Ilot9U0eLC+s0rbyQ+nTPXOAEKlgpgQu9d5O3EwtoMa6r79jA4T5DIfJJAKJSp44ICkopT7QDQaAK5m26B39yNi6uhycC0FltP4LcFU9irobHo7tyfYP/iPayiRVik/ZoPkTBUM2nrCaEHpt12+BE9Z5AOR60yWyYuzBGr+p7ixcUPvktlK5SZPzvZT+xLzCTOy+ABI8TRVNWedzPcxnlTmmhBgNPCxRiQcZJhfsk+aL5aTjwEojWNvzQ1AVxA2j5vQ3ymHjQ3qasykgrOIwo649eXTHsSqKJdA5ZJJxy7Y1G8VQUCNUBQCoBriaLtls7e/NDeRsGOETVpFOLFRei9fsTGCA7cB3fnuZ5Aeo0Ggiaxv6+AzulWdTQdiw/ymRYFjftA9BblG7BeCEhY+L071t6LIzuoR2+D2TFdz2hljxAYvLgfT/Go58rf3dU2usVx7wFVr0SEkIjNsghzO56+m1nwOx7cdPZ4keMJxi1/y5cmLKVSbDVxOasDaTawnrAjI4wNOHWYX+xO0bFYNIE1scdYocErTnGpnWo1zaUcpbVYefw1GMetkAO9jIVAKllAF72F0b4520pCzAoT7cDOMj2WF08+224XTqqb2a4id0Wz9LuHG28Eu7z+cVyqLNnaRC3iN2zvBOGp03mRywc2ZSwfwXPvfXOZZoWbDMJ4
 6fHYSFIv
 eT0GRAEPorzRmHm4VIzcxpWiXqnS0AAaiZzZtoAXkdW8R+tjWgYWfauYoGo2LNzdHf2rRyKlAF+YZfqqKFUjekqfFqpwnaaouCWt2oj+Ex2J2xZhmI75eWEUoag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > +late_initcall(efi_free_boot_services_memory);

Why late btw ? Any particular reason ?

One very minor nit (but it kind of is annoying when you gather logs at
scale and some people do look at this :-) ) is that the memory isn't
accounted in the boot message:

Memory: 224440K/483372K available (16384K kernel code, 9440K rwdata,
11344K rodata, 3732K init, 6480K bss, 254088K reserved, 0K cma-
reserved)

I'm not going to cry about this, but it might be nice to have the
__initcall display how much extra if freed so it's just a log grep
away.

Cheers,
Ben.


> > =C2=A0/*
> > =C2=A0 * A number of config table entries get remapped to virtual
> > addresses
> > =C2=A0 * after entering EFI virtual mode. However, the kexec kernel
> > requires
> >=20
> > base-commit: 05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
> > --=20
> > 2.51.0
> >=20
> > =C2=A0
> > > Cheers,
> > > Ben.
> > >=20
> >=20
>=20


