Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50A82CAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 12:54:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B608E0018; Wed, 17 Sep 2025 08:54:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941798E0013; Wed, 17 Sep 2025 08:54:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87EBA8E0018; Wed, 17 Sep 2025 08:54:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76FE98E0013
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:54:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 212DE85A90
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:54:18 +0000 (UTC)
X-FDA: 83898735396.25.176EE48
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4C219A0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 12:54:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=AxZ+gCyV;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758113656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e37plFiUUr9y0+z9ZrhF1YSuWJZoWqH7Ks9RgK/emZU=;
	b=3lP8Zku7GhP2W/711zLembkDKhb2xjy1KwtHigtlHtyOMF08pyESbgc1uAS51aEfmWit/S
	K9Dgv86jFfNn/thrg8kH7luTWig+qn3v2Z4yjok8XVqLvm4bgb8QYFkodidqyOJiSxiEDy
	OUDHxrQagfcONWW+Jwa7ocF6zTVkknU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=AxZ+gCyV;
	spf=pass (imf25.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758113656; a=rsa-sha256;
	cv=none;
	b=JEEdy8nP48Ij9YUOVuxBQUT/5+FdbrgR9IFVSqyt586EXyE/ZxsaGkDD6OMLouHYW1owPK
	8Op8kYo6E1qg9UaHQzmlGRookUDOdcfJIoCkeEvP8XhmlguoG1ftwQUd217XT8p2vZMl9t
	0onImKUzQT+3Hh7EJhdQtHpPc+LOAGE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=e37plFiUUr9y0+z9ZrhF1YSuWJZoWqH7Ks9RgK/emZU=; b=AxZ+gCyVD8uNgvFs85iP1B6vWC
	94RFaEgtyEbVYSf8e8SN5KlnrftU4FOgKUT83YpbH+yG0vBx+OaBxko4KR3cRqdM2q39q039lYFy+
	Ad9fWDImnmIvmsUSasxWwRLCbwbFp53K+a1cOKIIe//bcs7FYe36iYccVWFL99yzfqn0+812vC4UU
	em0VfzxCSU/qL9CNjiClrnJKDyuEa8jAtXe5kZJdAqsOF58fCFCxNRs9hA0DFY07Wof2JWjDxTtY0
	vD2s0keWqf/9jIyhI/M5biSXfAfsmYn86uFxlh6B1VVNRolmRKIwd4o7lk3iMJdP4j8S06f2XJp8v
	H/suobPw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1uyrfQ-000000001we-1V4D;
	Wed, 17 Sep 2025 08:53:48 -0400
Message-ID: <3cd6df1b7d202206507b53bdec7a352b766c1ae6.camel@surriel.com>
Subject: Re: [RFC PATCH 07/12] mm/compaction: optionally use a different
 isolate function
From: Rik van Riel <riel@surriel.com>
To: Frank van der Linden <fvdl@google.com>, akpm@linux-foundation.org, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: hannes@cmpxchg.org, david@redhat.com, roman.gushchin@linux.dev
Date: Wed, 17 Sep 2025 08:53:48 -0400
In-Reply-To: <20250915195153.462039-8-fvdl@google.com>
References: <20250915195153.462039-1-fvdl@google.com>
	 <20250915195153.462039-8-fvdl@google.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Stat-Signature: 5rndq4fphuhxspfu1d8be1us9xbswasr
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C219A0003
X-Rspamd-Server: rspam04
X-HE-Tag: 1758113655-967233
X-HE-Meta: U2FsdGVkX18RRQ21C56gU415vCqditLXd+43qickGAe64jfQu3bFR9bqy1VEkwL3QA7A+j2n20gBoMoMZ/bKnmif7Wq0hv7JwP9r5YooldHIMkeFeKBqKG+eGAurVtL6B/UxRUDLsp0nE0/BC/Qxyvietwej/JWis8NAc7kMeL4ftACMC+WCBymlbmsub+f8kYGvZDfTnsbQ0LXgbQeGE5u3OHswwB6WYrIr9VGhJx8VALZEvJtRz9/AzukrsfoVN9koItAAeR4ZY+SZ9BCv/EgBFa6XFABOOyTD3T3iJc/2lLFuiGlzrHFwEhT8Ph2UBWwyJLY01O6c3dSE/z5EffbhyqRY3kQm+0OXxyU/o3i2xo/8lt4kWcK1lC8GU/0oqfu6A9WW0oFSbpD2A1OYzokUDG196ajMXNBSedqt/E2CrCmkQER31QaX7GHn91zcgRHjpsTs5r50HFTJkFpcPAWr+hRPz5XM3khyqjph4DyCwMjseKlkE8RW8nGSUNowHi77gy0GLNlfy2Sjoywp9l5TA7+17hGetK2NO0Cc+xD8H9/FnR9JYSRPWhoSpESkShKl4x74ECZETd/39fY1enNi52PYm0U36BaFCw8dTBtTOnVjG24QNgN99p7Iez8c3hCX3F95dFGswXEPU9K3sQJLZkRKPsqHLiSH+Hvr3b+DwlG4vmAf1+xBmOGA7Nt7761JlrtLFGYsbFiwWy6B50haV0XzJM8Kadp1f7fCMXr7M0PVhR1jzId1dS7kF+NQL8k0c+u0H6YZENHQLtVlpXqY3g/Xx9Xtd/zgugc8qCfYnl/1bMywF9xE87BJU/hg16L6AVquRac/uNwrzdb+lHelKdByJn6sMPRREtNKx1/3VxM6LK6UOZIMgDO6d0+lQzNyzLOh4/m3B30aQjlS7ORWNMTem196xm4CPLed3FMXxlbafoVtBlfCjDyJv+z7EdprICDj1U06tsbtMpf
 V6wtMZbs
 7VJD4dSNa5x9iaff5WKie3E2P2JRoW849+zAoqzMQT0wS44MC0aputFqAB6rgE6ywKcGLEWr8Hi2lfiGoHmdwCaqODIx6D0T+kjOeeoGfwBKp8Wh5hrwl2nXv589QsCwEm4G0KDD1RARUBR3YMhbAhaAzG/iMiq2USIOxniN/dxIsRPg9ZDhfCtZOHJ1LAfqKIBObygaZrioWFldX56QVKjw+WMJ3qZa/WlLbjmRpZ7LC5CkMFrmvnK6CNZN8ZTS4Cwa3Yoq62enNmzE0YRMuzAckToD7b+8iGAbWiGWcj64bn7TgPuXCL9dsHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-15 at 19:51 +0000, Frank van der Linden wrote:
> For CMA balancing, the compaction migration hooks can largely
> be reused, except a different function to isolate free pages
> is needed.
>=20
> So, add a pointer to the isolation function in the compact_control
> structure. If it's not NULL, use it, else use isolate_freepages as
> usual.
>=20
> No functional change.
>=20
> Signed-off-by: Frank van der Linden <fvdl@google.com>
>=20

A custom isolation function can certainly solve some
of the issues!

Acked-by: Rik van Riel <riel@surriel.com>

--=20
All Rights Reversed.

