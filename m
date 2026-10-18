Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E49D9CCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 12:25:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 745686B0088; Sun, 18 Oct 2026 08:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F4F46B008C; Sun, 18 Oct 2026 08:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A356B0092; Sun, 18 Oct 2026 08:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 398726B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:25:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BFF6AC04E1
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:25:45 +0000 (UTC)
X-FDA: 85335668250.23.71D4E60
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf10.hostedemail.com (Postfix) with ESMTP id F01BFC0005
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:25:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=AopFY58F;
	dmarc=pass (policy=reject) header.from=itx.no;
	spf=pass (imf10.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792326344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4BlqkGfZ2/HXZLwDXoPKmXK3T/sLYv/XhbWLmIDCV+k=;
	b=FLta+jHqouwX8jjwa+xweu5vzmGdJslskLik+vUW4ZMcyvFufxbaMo/rKnfBp4l566Bw/D
	xuUfkDlin1aO02panCLkmLAdsAXnWxhe5ZR35XfVQ5Gnold09bjjqgHhWZEqV+Adn1N6pX
	x2gLvJMXtg/Nk55UujAQmDTCBrmPyx4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=AopFY58F;
	dmarc=pass (policy=reject) header.from=itx.no;
	spf=pass (imf10.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792326344;
	b=EhYqRdjLNeo5ImRdEfZyr1sZ7T5YHLurCwDNT4y/48dz9FlCdI+FA/TPlPjnh2ypYWRXAk
	aq/e0SN0H+oYr6NlCXPuJo1EvA7aS1q1+O9NHZmRmL096bQczTiemDLzGsHXbZBCXHg3Cb
	vHQSnVFnJG5n23dKkq1FQR6Td3ntsXQ=
Message-ID: <13e574b8ae33eb113aa5c2b944960f9001cbe7ac.camel@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792326341;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4BlqkGfZ2/HXZLwDXoPKmXK3T/sLYv/XhbWLmIDCV+k=;
	b=AopFY58FFAqOmgICzJzYRWChXUqz6vrfXr3fwCA1oTAKl2WuagM6cEODhiLMUzuWdSlloo
	ZGEzNjxvOYSYuSXj2APCBHIwP2PQpIMCukB4M4NLF7jKVwAJdjNeVTovVZ60j1vyBMnNG3
	0colmgoiEIjxmg5Z3ytCXCb9bk9hCLk=
Subject: Re: [PATCH 2/2] sparc64: Randomize the load address of PIE
 executables
From: Stian Halseth <stian@itx.no>
To: sashiko-reviews@lists.linux.dev, Andreas Larsson <andreas@gaisler.com>, 
 "David S . Miller"
	 <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>, Michel Lespinasse <michel@lespinasse.org>, 
	linux-mm@kvack.org
Date: Sun, 18 Oct 2026 14:25:40 +0200
In-Reply-To: <sashiko-outbox-176036@kernel.org>
References: <20261017100451.2266781-1-stian@itx.no>
	 <20261017100451.2266781-3-stian@itx.no> <sashiko-outbox-176036@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Rf6o3YE7c8xlHDeF/lt4"
MIME-Version: 1.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F01BFC0005
X-Stat-Signature: f6zm6yrfnb1gyxbaogg9ownzy31xmea8
X-Rspam-User: 
X-HE-Tag: 1792326343-391562
X-HE-Meta: U2FsdGVkX18tZU27+xDOAdmRtkDjJr8O172pN/h1AU4xIbekf99qsF0gHN/c6rWuZOeU8Y5dEb9oFFmox8mtCQaRnVvXNcixl4I046Ep66YcOss/o4/MxP9zm3Z6Wux7PJ0ODMwp9TFacsjXpnc4cLKe6+BkZjn1Q4Ly/gdzC0M13MN6QAz1EkQz+orJ8y4eRMz9zpaF9OMGQ2mR8WIoI1hkxb7SpcGloCo9t+B9vCnJdmQ4jwXcdymcFIiuiK2DURZAdyHuPM+GIIvCZAUe7vKTNSir4MOIuPLjTqsaWHYlyXOUJhCGx+v9d3xktlwAdEhbt7m03TLu9FNUg8R5B8twCdNfjkKsJndK/uMOVVKeruPr/qtfy/slH9u8hovQlXhm7B4KmeGobKkAgIi1zfhD+A3HYhMHNfE3CiaItHRAhz6qB+dbUuYuI2sYnS30Oms3nR5aH7PJE/Qk9OSjNKBUTqpxUlecWmOygg7CAO6OePPuUSDkeNZt0PXXBoXemH/HVEz72PFldwYjuJ3wjLvqf0SA6OV8IfLF8xvmuzsKoiyII7gXN4dlobFscN817GRTeplbZrKDH50pEzyWL8oY3b5FSL7eH+8XLWM+w6k/lABoyImHPuxhZQfBbBiK1AgxkeRhexibEZiyJ0yBVJ+ueay7JmTiw2hVvDVCdxiqBWOHy6/FKdnuHsl9SRvBuo125SprYoTcp2XAKwGBcXdfJBmhizdfVce9r+aM6jIg91+DGK4QDR0UrP78/b3I8/NOzscCIM3n7rwfTQ0uxMv44kbnHS8pAZzVL4xN1wqIWMUvvRtmkP/Kys+JudKTx0JChPHAEoC7a4+8Egy5s8ORUBh2T8WUqH4C+cSaQWB6OzvTp9E9j6533xkMGWjqpFgStYDVhytoGHoHSM5ETocdKeLdAiKlOzZsouQgbxcWknZoyCGFbEMe6SQq7huap6/W1xLawAdGcZRI6k5
 /OznvqDG
 rhaoSl/q7Vm6ulQMPBBTRuSQaodW/2zPafnsk63SbsW2Jlx++oYDktT3fX9G/SaitUBxDSM57URxxWTaQ27P2fNtYDUVI4+FhZbMu9EYWtMR8u0+hQN9wqtyMIRSIq1nB78PaP88anBKNCtBF5fmV11cbbLUw+rJo0KT4NYgrjOrM+3N3HOl7U6AoJ4eH1edPl/tlzgrzWOYRJl9YshU4akz1Ri/3BDRFQZPZw1Oua5EHjjvlpHSGE/TpKLg67NQJRNnV9Ta9Bmcp/UI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--=-Rf6o3YE7c8xlHDeF/lt4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable


On Sun, 2026-10-18 at 10:05 +0000, sashiko-bot@kernel.org wrote:
>=20
> Should COMPAT_ELF_ET_DYN_BASE be separated from 32-bit
> TASK_UNMAPPED_BASE (similar to powerpc, x86, and arm64, which place
> 32-bit COMPAT_ELF_ET_DYN_BASE at 0x000400000UL or offset from
> TASK_UNMAPPED_BASE) so that 32-bit PIE and brk do not collide with
> the bottom-up mmap base?
>=20

Confirmed for 32-bit tasks in the legacy bottom-up layout.

The dynamic PIE case was actually broken already, brk could not grow at
all in that layout.

The explicitly executed loader case is a real regression from this
series though.

v2 will add a patch that moves COMPAT_ELF_ET_DYN_BASE below the legacy
mmap base.

I can't use the 4MB that x86, arm64 and powerpc use, though. binfmt_elf
rounds the load address down to the PIE's p_align, and from 4MB a 32-
bit PIE with 8MB or larger alignment ends up at 0 and fails to exec.
1GB keeps every alignment the old base allowed.

/Stian

--=-Rf6o3YE7c8xlHDeF/lt4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTK1ph9OaYoND1R57zoeAEuJe36VgUCatS6xAAKCRDoeAEuJe36
Vl5tAQDQggcjL5ML/FWoUiTbxxgW/UqRAeDJyGaCMgFt7Mo0lQEA5F88Gv4mTwLp
uugn7+gKYcyRz9XrRYEly4NzUPpTPQw=
=4Drl
-----END PGP SIGNATURE-----

--=-Rf6o3YE7c8xlHDeF/lt4--

