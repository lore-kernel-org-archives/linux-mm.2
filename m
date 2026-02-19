Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4926E9A03B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 02:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F64C6B0089; Wed, 18 Feb 2026 21:48:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36BED6B008A; Wed, 18 Feb 2026 21:48:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28E966B008C; Wed, 18 Feb 2026 21:48:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13CB56B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 21:48:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A873B13AAC7
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:48:38 +0000 (UTC)
X-FDA: 84459673116.16.B526887
Received: from gate.crashing.org (gate.crashing.org [63.228.1.57])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5C570140004
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 02:48:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771469317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0k3MNIhZWKUfaFCNDSigjQEY8EXxK7PHlH1UdGdsEOE=;
	b=ay+ey2PqrcSFI+8I2MugKW4q7ZmbfJ2besaxo3sfqnOSExJLDybPa9Vl1CiQMWWWnWEiXH
	woR22vz1N3kxscnhKfsjBJMZZJZcBYDZgMwmEKDGHn8zllr2HMxIBGZRI4e0XJyR+dT8Mu
	5XODQRfBiyvkUk7uTV1oLIVSQUOTnjs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	spf=pass (imf26.hostedemail.com: domain of benh@kernel.crashing.org designates 63.228.1.57 as permitted sender) smtp.mailfrom=benh@kernel.crashing.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771469317; a=rsa-sha256;
	cv=none;
	b=TWLA38eIYnKI5blyR+iPTmRRzGco8cgxeQKkTbKGW2HQ3O7S/ld7cIFUXgM9cWaIMcSBfE
	JXYKrzJEo/JfMGmJexiNtgmtrXy8Bnpc9NXNp7UFRR5SOxgSak8O8Uqw2V99H9aOF8eRdZ
	tNl8cLsgTMTqOVcMS04oGH6pvhj1cMk=
Received: from [IPv6:::1] (localhost [127.0.0.1])
	by gate.crashing.org (8.18.1/8.18.1/Debian-2) with ESMTP id 61J2mGXC541420;
	Wed, 18 Feb 2026 20:48:23 -0600
Message-ID: <6453da0558ba20d5c87e730bdfedd47966977931.camel@kernel.crashing.org>
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Date: Thu, 19 Feb 2026 13:48:16 +1100
In-Reply-To: <aZVyxKVS8y-rqwrK@kernel.org>
References: 
	<ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
	 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
	 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
	 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
	 <aZVyxKVS8y-rqwrK@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3-0ubuntu1.1 
MIME-Version: 1.0
X-Stat-Signature: ba6r3cufa7rpyxahi6omje6kkrawgmjm
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C570140004
X-HE-Tag: 1771469315-445869
X-HE-Meta: U2FsdGVkX18uxqd7mj4FJy0AAnP4A+KWlIfL0qff3kOKtrvPwCafvCgTFyw6yweycnWm5l6uDbd6BTQivWezDpT8SRYdKKAWKl6qnhOtgYFcsTlnO5rNtpYUrKCVCFUEXVLDcDqZ9/9qwFbjzbiUn26lSN5GptVxwy+smbFJQhuoPOKnpel7jiqiqT724A/vUtyNYVAUNW1WCCd9U+H7+jIZIFpFqZJg6UqMjWhZ9XXYWr0cNwSKjSV373Z7KYc3zF1kzOyaOlRCH5SxBdy9DpaV6x4gwD9dMKCAB2sB0n3NWAMPWdY5fRrSupYY2A7uOzGD9FfHZ9PkhjbmKKW8IxLYqTuLiUteDsl37rW6zVS2q7w5K0Q3H5N6P5sx1k/xV81WkFoHZmSikiJdJuTDstaG52lJ+1OrMJ/wH8iP7wXO4WE1IC/GfYL6RRSfQZMrJAXcwZNh2x7Vy34DXYhWrF/J/0/i0ro6hBVmrWiivcrgILaw65dWeIlHyj282jGxW8JF7kgzD0LevjDSWlGYs6ZxpVUbCrmvdThoEktQcHvr2JykeIGhViR61ljXzNiHFti+nGZXdI0YJE5u+oboeGmW4XJK0b0LWdDYWPmHDub0+7ognxszhie4CYsny/dMVRm+49X/P5FrVgN3PJAPT/LrbMHg6rdAmjXmkGyTw0xF8DcNRXU+L8LD7068PCS4TehJL23Bne4XVcW3jaGSENJal/VGe6s2MfzkKqz6xiMfabJVvyYEB2rSEQtTLeQbB1L482Vkz6HgOqiWpA2e7qZPHU4oy2u2X4Lj8+WdSUaf4F7xz4FRJxIyV68tUuXiNPzWsk71c07WEVVssdvSZtWH0hLkiReKCR5zomdvh27YMtW1bZ83occ6NgucjLTNh1b/3niK89CYVJywc0IH8RcJP46jF2t8Ni2hn3FvDGZYkNRKevQ79l0jNsaarMKUTZRKt400vM/eisQjJFk
 QylePfZW
 h91esQ3iRltab/X47VeQFUolR3L1VCtr9Docm1OiIMMJFDoDxCdlv3zABCVx7JO3Cot5FRgZqjcqEdFX0ko4+GQ6hnFVD0QYM054VKCRlWFMMJIcWsnnDGf2Viw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-02-18 at 10:05 +0200, Mike Rapoport wrote:
> Apparently we do miss some piece of the puzzle, otherwise you'd see no
> crashes :)
>=20
> I think an easy and backportable fix would be to make
> efi_free_boot_services() an initcall, so that it will surely run after
> deferred pages are initialized.
> And since the boot services memory is not memblock_alloc()ed but rather
> memblock_reserve()ed, it should be freed with free_reserved_area().
>=20
> With the symptom fixed, we can audit memblock_free_late() and
> free_reserved_area() callers and see how to make this all less messy and
> more robust.

I will play around. The biggest issue I see with this is that
efi_free_boot_services() also manipulates the efi memmap, and that's
done without any locking whatsoever.

I'm semi tempted to split that part. We can unmap the boot services
from EFI memory in the current spot, and defer the actual freeing.

Cheers,
Ben.


