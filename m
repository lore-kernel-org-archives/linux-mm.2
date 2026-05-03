Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B66CD3424
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 15:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6204C6B0005; Sun,  3 May 2026 11:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D0756B008A; Sun,  3 May 2026 11:48:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E6ED6B008C; Sun,  3 May 2026 11:48:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3EF896B0005
	for <linux-mm@kvack.org>; Sun,  3 May 2026 11:48:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BAD0E1A098E
	for <linux-mm@kvack.org>; Sun,  3 May 2026 15:48:09 +0000 (UTC)
X-FDA: 84726539898.01.2A70367
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf28.hostedemail.com (Postfix) with ESMTP id 77C3CC0003
	for <linux-mm@kvack.org>; Sun,  3 May 2026 15:48:07 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=pPCc8QTw;
	spf=pass (imf28.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777823288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoJ22uoHPxO/Fiuqw0BQb106Foyun4Y6/eKPYRUL254=;
	b=YYqI3jnq9onCk5JVPdzgQDQTG5Geo3SGyko2GBYfXuX5klf+Sg4ZbjqHMMkiFIrTgXEEbV
	bivVxSqGbmW9hk1a/1IVOljo2fr7X6liBCCzfw0k24cygu6eC8wTqKTvvchV+eKgAOl080
	qEFrHFcer4m5uplUeZkrbT7BA9SKnG8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=mailbox.org header.s=mail20150812 header.b=pPCc8QTw;
	spf=pass (imf28.hostedemail.com: domain of manuelebner@mailbox.org designates 80.241.56.151 as permitted sender) smtp.mailfrom=manuelebner@mailbox.org;
	dmarc=pass (policy=reject) header.from=mailbox.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777823288; a=rsa-sha256;
	cv=none;
	b=bSKG4FY94S2xetiLgpQzfx1JG1xYPy2zQvdeoAmKw/HQlLV13szrbP3iz06TtTYq802qqB
	/c1+KsV3aXzkQm+5Ut7pA/zOCs70K65XHLRki1VM5FSqK+mHSft+zaIsSFkpvA5gLbfk89
	WcZ7vBZBgvSEuO0rFOcgO0p7vOSg68k=
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4g7q1H3GKpz9tKb;
	Sun,  3 May 2026 17:48:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1777823283;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UoJ22uoHPxO/Fiuqw0BQb106Foyun4Y6/eKPYRUL254=;
	b=pPCc8QTwbHGBtpyOcgiepxODTyt5c03iNTyFiVidzF17rpDgE+prPLl06qbUcWimYLdgov
	p8wRU9+QPhUgz3db/co19ImRiwrtzsxOAmSRhf8T6ixwsI0qjl5NC2q6M/XB8wbZvlca4L
	LGh+cd2NXlbO5g5sPPxONm/p3J0MkZXjdk1xmHl64hKZ5AzRiLOCdhlfK4AooanboFwp5S
	lxtykgi+z5HOGvYM6qzCCgxwPys+uZEczX/QVpCVhL/VhrIBav5WglJ3E2FwZd6uEKo7wD
	BW79SH9nFDPO/1050XrE9EciwVqsyoqHauQwl1eI7MvRlki4gHwN52lh1V9Esg==
Message-ID: <df48beafcb0cc9caff40db78285113f0b1bd9b87.camel@mailbox.org>
Subject: Re: [PATCH v4 0/3] Documentation: adopt new coding style of
 type-aware kmalloc-family
From: Manuel Ebner <manuelebner@mailbox.org>
To: Jonathan Corbet <corbet@lwn.net>, Shuah Khan
 <skhan@linuxfoundation.org>,  linux-doc@vger.kernel.org, Kees Cook
 <kees@kernel.org>
Cc: linux-kernel@vger.kernel.org, workflows@vger.kernel.org, 
 linux-sound@vger.kernel.org, rcu@vger.kernel.org,
 linux-media@vger.kernel.org,  linux-mm@kvack.org
Date: Sun, 03 May 2026 17:47:57 +0200
In-Reply-To: <87o6iwczjm.fsf@trenco.lwn.net>
References: <20260429070759.309110-3-manuelebner@mailbox.org>
	 <87o6iwczjm.fsf@trenco.lwn.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MBO-RS-ID: 795585f96704e0164ab
X-MBO-RS-META: rsbayzutnfjqyda4tz9cmg9m847bfsut
X-Rspam-User: 
X-Rspamd-Queue-Id: 77C3CC0003
X-Rspamd-Server: rspam06
X-Stat-Signature: 1ecn4xryxbenio7q5my3mp91rtjtymbh
X-HE-Tag: 1777823287-6
X-HE-Meta: U2FsdGVkX1+hVil5X7MnaG+/Ig5EPF2sGi6u5R1W1cFq6g73MjNhs1xuX7GALJFExXXudB4ZAK3iOdkmN/+kp+IhIbtZFTu4NCC+DmfML3T2SFxHxmhxbQ4DICGgd6UefmCqD9lAm6khEr93OxHTvOxoIdzB3uTPvM7S6prNoMSzGoibHHKqUdJZL4EhyqVjISjwIuHv2jr+dhrcZoFmRFjhJJE1+r5jQqUHeJJZZfcioubllbv2X/52rew+FLSn3xpfBkVVKCPE8Axchlun+zsUuxjLLirD65C7OWoTHmB6WXinTdPVNVVueM0NwZ8TGKD9Ymz133tV5XJKiK7aBHjApwfQ6LsFSXta4K2mLp+h5rtBEXegczTL9zY+3VFuVsPdp8k6B91wi6+1QJwEFXamY0Wy8qFOZUQdlIXDjksEikxIPnlEW0NwmWp8a+bT9C6BgdTBf1y1/z2yHBGtGRXxRO5thVEE1cKQ0x8gbBpV5c9GGGsd4t7MH1t8I0DMkVuGj3fVU6vNt3zNYoHJ8OFLsBstLDGFxmoDVKhERzeRf7NsJPJ63EZGfGEBKy6/rc1WR9cnVNhfksjowbxsgidLx+5PhycP05fqrO6X5y3JPHPx6gu6zXgLdup8NPt+Y/vTKjrwJS3EXeapQtm0Vyj1779sgrAPi13roE6Khe16W8M9kLw2nBj+PtIHMn+4xoJYJqgnm/32rftSUy3rSwxH8YesYhRTcMnpq84t5+35Ht5Bz93YK/EFYULvxw5WSuJlCbbJ1qAj8bcz1ktyrzpbNJ4eF2NfCyPjAbwyn1uaPw9jb0Ffg0VIfso5kI3+eiiXJKvvVARYfWoWZzjf5UE771ib9FEtPQRlf4VS604/AIMRD6cdK0/MxryD3wYITJjVNcqC4LtXhvGDr/YK7a3Hj9UecJ1sSYIIKNsV+g8AynOFGboJYH76ASu8oApaXry+fapgvK1iwszGQxj
 HSl5vqMm
 lzLcfQW3PYpcmw2d8oQh7aJtwMuGvxufaKSJIm6+rWKMPIOerxqmJWWNswOyVCqQ7qctEQdY20+l43KyMSRbHJjV0rUNN+L0B5C2SEFUPlRoVwlX4PwQRsnvfw75H+1d5BuovlsTZPIhyynCJn8FSn+kYCLrus+bE2XutSwXvlL+ZBBcrdlJBR6BFU1JAzXIoibh59lr1sa3oPWPMLL94oZCu1JK7tPB1IzX6ZUj9qp9OGjVZw7tARHq/25sg1oKfYnswOKKuJvM9ecZTH0/d4ELCf5vrNb7iKp85MFxwumcEmdSv2Bwyxi10IBEaMO21/QiKV2UJSIlzRTRKXeLDJbBaeg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 2026-05-03 at 08:56 -0600, Jonathan Corbet wrote:
> Manuel Ebner <manuelebner@mailbox.org> writes:
>=20
> > Update the documentation to reflect new type-aware kmalloc-family as
> > suggested in commit 2932ba8d9c99 ("slab: Introduce kmalloc_obj()
> > and family")
>=20
> OK, I have applied this series.=C2=A0 While doing so, I restored the "gfp=
"
> parameter in the changelog portion where it had been mistakenly removed.

That's good, thanks.
I had two more changes lined up for v5 of this series:

-	ptr =3D kmalloc(sizeof(struct foo, gfp);
+	ptr =3D kmalloc(sizeof(struct foo), gfp);

and=20

-The argument gfp is optional, the default value is GFP_KERNEL.
+The argument `gfp` is optional, the default value is `GFP_KERNEL`.

I don't know how to go forward with this.
please advice

Thanks
 Manuel

> Thanks,
>=20
> jon




