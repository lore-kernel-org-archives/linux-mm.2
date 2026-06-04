Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50120CD6E68
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 05:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B784C6B0088; Thu,  4 Jun 2026 01:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4FA06B008C; Thu,  4 Jun 2026 01:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C9C6B0092; Thu,  4 Jun 2026 01:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 96D576B0088
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 01:34:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B60012046B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:34:18 +0000 (UTC)
X-FDA: 84841114596.16.1F1A0C0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB1F3C0004
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:34:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCRKarqR;
	spf=pass (imf28.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780551256;
	b=PIGQ+PMUaKy0ME24zWiTMtaPctpQNFnWg838pf985s4kb5wUYDzzQJbFFhXBh5U4AhUh8l
	4Fq+467mcCbZpgFQcdtOkHwuzTtd1sdy31Z6JwVdka+gCmF+nI29UUBs3VHW0zbkimaV8o
	BQLus5Ws1aSmIRU4UsYWY/HvraMMjo0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KCRKarqR;
	spf=pass (imf28.hostedemail.com: domain of mripard@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=mripard@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780551256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j314sgZEJ2BPq8oCCjils0V0pfkJmoyrEoH+1wcS5k4=;
	b=0Ud9tIU3EhaSzypje9Rry64t21jdtGkS7Yih+gKptNeE6/YMBb4UPAYawLQLbJTi9kiHjg
	CiZ/7FiannrX0VzT94rojIorklVc7P5auw6zdhwOzRmSCNndRCklKtVgq4pr9hH51DEseP
	F23adj80pUBDO1w0/Q5K0gafpPvSr8s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 312F3601DD;
	Thu,  4 Jun 2026 05:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F841F00893;
	Thu,  4 Jun 2026 05:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780551255;
	bh=j314sgZEJ2BPq8oCCjils0V0pfkJmoyrEoH+1wcS5k4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KCRKarqRgscWmvkIuazYhE6YgPoRl81f/jSgLnxgHA3jrF5in45VV3I6+00lckijU
	 HZgGkLXbrrcjjmyYGamSXhA8Sh2/s2W1k2XWWNvsDoypK+rxS0d/dHPU1N/4ajHchI
	 FtwstIDZapl/FhrDCWCanJ8qNtw3lGyXIPzDldla2AWkHm/JTx5o5ZqB9vmTTOdZDj
	 6aQViy2MifdZ7pNOJQSRMvoTXFTr9mk4gxu35mAC1jBFdSnVqCwSchxd2elr0ZNBwM
	 jbkiWPK9NnfPMw4COfej82NQjiQp2fePVWvkeKna5SXF3mIDHkKCSgJStb+HwqasCy
	 ptExAnxNIx6kQ==
Date: Thu, 4 Jun 2026 07:34:12 +0200
From: Maxime Ripard <mripard@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@infradead.org>, 
	"T.J. Mercier" <tjmercier@google.com>, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, 
	chleroy@kernel.org, linuxppc-dev@lists.ozlabs.org, sumit.semwal@linaro.org, 
	lkp@intel.com, linux-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	linux-mm@kvack.org, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-s390@vger.kernel.org, Dan Williams <djbw@kernel.org>, 
	Tom Lendacky <thomas.lendacky@amd.com>, x86@kernel.org
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
Message-ID: <20260604-dangerous-tuatara-of-sympathy-28e05e@houat>
References: <20260522225853.878411-1-tjmercier@google.com>
 <ahPqbfH54R3JJyaV@infradead.org>
 <20260527160716.GN2487554@ziepe.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="jqptshhieja74xp6"
Content-Disposition: inline
In-Reply-To: <20260527160716.GN2487554@ziepe.ca>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB1F3C0004
X-Rspam-User: 
X-Stat-Signature: 1qhwmb1uic9m6q3bf6wxbpr6bnwornqb
X-HE-Tag: 1780551256-479961
X-HE-Meta: U2FsdGVkX1+pb75/Gv+kGh0cuFWUM6Q5QZw5knNGp8Xa4Bk3XhByJzo7IHFVnYmdra01oLAaSSaB8fWnqzhuk2oqLOd15uaJ4jl9sdndxalhi5vSb1aLK8MtURBGjoBWd1ePDWwfSiOV01WAJwPKKlr4cHTnkL7Esxo4sLagWksCy7rNFxgLp2LycudvVgmYm17tvqyWnhYujU/6bV32CQJGZbPqqUGj95a/VbbnPtvaj8QqF21QUfchOv0F2xuDjnuhNBbRuFVJl9Jlywr/DJzZkSSEZDXcpu88Lw1EnKHdVkJmjRu+Sp32wWv7jAsqyyyxl7NbHqp9XN1sDagkwRqe9CnW00iU3HFuGh7PAhULRB0gRmK5I2gDw4rGtcKjBZboCMBoE7Jeh8QOj0kChuE2LHzm8Ex33dR1NzJ7Knwt5b/HxIcjNLr2yxVe3pJvPhk8yaLdnBImVcGGsg5d+TzPyplgG4RYh4gaUCryGVbg9hS9/8LMQnRQk575L0Upwt1QuEo8RtkVn844Eq2IaSb6lq+lXtSZFNKQYUiJ7fvpEoCdy2QJx5oupasNrWZdGkukkOs6CnVKz11VIe0N1U/DrGBYlSMTV6mKPCJv6I/NW/4VExqaKE26DRVZPBE4SVZpnMocWqgQ/T+IVe89bVQhxxtvAQ+fYDEcVsdmkXVWW5lcuShbwFkxLiAu8FhIfuKvBHoAtVyLdhERfo1XgJW9MFFYPq+eujh7rXhcTQQsREe3OchmTDlSifkUnO+UfNL95aUpdYPAh5mm3uKRNpmfP7BjToEDkv1QZtenp4vi9xyK2DcQ1KutVvPrfLPB+UkifisEcXDHJbq8N5HhOn555rIlD3hEc18/mjyBXgFeJ5meszL90cSNx0cMFs1FcOU/UlOE6QSSeTG1lABwKVuJSTgMMGmodQHJSMzlHlRYowFvqc4PWngaPxn4SpZenrTCtHcSQ39rGtBPmd0
 TLgv2nBn
 Y4tIin388rXi1DtFl+Ux/oy7WcsfBvxJaTyP76+ASH8ox9pFwc7c0CECBcOhsVtyfftG6b7Vy8tHV0fOhR7aEPluH606aBerjwsCdRle8OHPxuhtymwO4dNmhtcsQTTj67y2b0fexYV+z8YcigRkE2+41A1iv9FHYWZ9+gSKwI29pSvy3KyjMshRcntmJf94lFxRZFEJ0m2/4Yox/WmK1Fj19R/gLfo405I0WGafzlL9Mao+eEmRQrdLGUrgFyhBxvlQI4uw3TZ5ydNMfIemoc5IonyX+JI2vmW/8Fda+iwumF9apgfswgyVtmOXyEkvZfiUUNeQDufWeFmRTJ15ugilgcq5JBuJs33wqr4MTa/hUgEWsEA4Z9GPA+JkpPmENFh5wO1jpdYQPtrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--jqptshhieja74xp6
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] powerpc: Export set_memory_encrypted and
 set_memory_decrypted
MIME-Version: 1.0

On Wed, May 27, 2026 at 01:07:16PM -0300, Jason Gunthorpe wrote:
> On Sun, May 24, 2026 at 11:21:33PM -0700, Christoph Hellwig wrote:
> > On Fri, May 22, 2026 at 03:58:53PM -0700, T.J. Mercier wrote:
> > > After commit fd55edff8a0a ("dma-buf: heaps: system: Turn the heap int=
o a
> > > module") the system dma-buf heaps can be built as a module. The
> > > system_cc_shared heap uses set_memory_encrypted and set_memory_decryp=
ted
> > > but those functions are not exported on powerpc. This can result in a
> > > build error like:
> >=20
> > I'd much rather revert the above commit.  Yes, x86 has exported these
> > since 2017, but that's a really bad idea, and we should fix it instead
> > of spreading the export.
> >=20
> > Setting memory decrypted is a dangerous operations and should only
> > be available to core code.  We should have various allocators for
> > decrypted code, but not export the functionality to random code.
>=20
> At the very least an EXPORT_SYMBOL_NS.
>=20
> Looks like there are about 3 modules using it already..

So, I'm not really sure how to fix this now. Should we revert the patch
making the system heap a module, or should we export the symbols for all
archs?

Maxime

--jqptshhieja74xp6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaiEOSwAKCRAnX84Zoj2+
dsIpAX9h+K6tpCAvZItDUjp18GfV1Lws4Co6p+mCPIcMvXSb9nHyxnRm60dsf2DY
5WaP+wMBf3/f3uHeLbsQL6So6AEsb7aKUbpaAgJo6FK/gDrwlAX+ebBpuWxfClty
yJnTzPlrTw==
=ZFmF
-----END PGP SIGNATURE-----

--jqptshhieja74xp6--

