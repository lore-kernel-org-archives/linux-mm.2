Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 149CAFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 18:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53A466B0088; Sun,  3 May 2026 14:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EAE26B008A; Sun,  3 May 2026 14:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 400E36B008C; Sun,  3 May 2026 14:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33F526B0088
	for <linux-mm@kvack.org>; Sun,  3 May 2026 14:27:06 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB245A038E
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:27:05 +0000 (UTC)
X-FDA: 84726940410.13.BE673FA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F5DB4000D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 18:27:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jXM8b0e6;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777832824; a=rsa-sha256;
	cv=none;
	b=dalQL5Ow5iLpqwhRmFz9LTDvpLq/4NEXk4ABS9nV/B4f0hN471J8f44F7G2xjoLAZxZLLz
	kxeWmAjDfxfTlnFiJTqaz/Ar/A8lKJZrZxVaR3S3Pb0N+XDy49QXq2pMunDdpxmIy7YokY
	PR5KSbKKG7gJIuQOT7bat36PKblaef4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=jXM8b0e6;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777832824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wOgUIYC+8hThKxTaqwfrtEOH6XH3rd7KAjSqpzhRbz0=;
	b=2U6liAsbMnB8xRfAiDfCzhWwzr8pkxdT6+PyjQTc1iOcs8S/GyX6sS8WGMZbHeEC3f6PO+
	UxKPOvxIyBSJCfZ2csIY8L7G7kbHqQW9xB7TrnMhi0MExy1mo/tpLP/1XvJHtFYtGOlQ8q
	HvbORsdu+aC8W3ymzTQwGhICvZZ1PYo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=wOgUIYC+8hThKxTaqwfrtEOH6XH3rd7KAjSqpzhRbz0=; b=jXM8b0e6hGCiJRlJtTnHlYMmuB
	FmoLb65jEvhleudDtlk/ib6gdRBarS8hP5CCGDaXYdLwEDWOn4pTUtAKsTQWrHv7N5Rw3wK7xNsU2
	TK6AD63JEPezD3KqCdmy2qaKFs5O7XgxYZOR0iHJyMgEiJF9qjWU+c8UJOZ98T5kyU8XN3uSyGJzt
	Hyhw70bjGfdkHxWREr6lou+ZXuKqIzhkvHUlqazwNLlp5yX49sxv+qsEIR8dGUKdh5UVJl5qbAvd8
	SHLGZemMenJy+CnnkyX718pzjE673xlhBYXjreWjTY+5tEcsacvNGoEDv9urgIQIWXJH2JqQC8ydR
	602XZI2Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wJbWW-000000002JB-1VTg;
	Sun, 03 May 2026 14:26:36 -0400
Message-ID: <8c729d621f281dd0b1a891f4aaccb0ba4956b219.camel@surriel.com>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping
 [RESEND]
From: Rik van Riel <riel@surriel.com>
To: Lorenzo Stoakes <ljs@kernel.org>, lsf-pc@lists.linux-foundation.org
Cc: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>, "Liam R.
 Howlett"	 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Ryan Roberts <ryan.roberts@arm.com>,  Harry Yoo <harry.yoo@oracle.com>,
 Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>,  Barry Song
 <baohua@kernel.org>
Date: Sun, 03 May 2026 14:26:36 -0400
In-Reply-To: <afWcMyc5M4vViLJd@lucifer>
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
	 <afWcMyc5M4vViLJd@lucifer>
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
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Stat-Signature: qtrqq1etdfrubt86shzdc67zmrw8xmgi
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F5DB4000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1777832822-128300
X-HE-Meta: U2FsdGVkX1+6jhioYhxgL32OvU8IgccHiJXSGNnjE92RatnwgvdBaAJTXYr6JTYyhEQdqbxm6SGWvUUwyLXcZzXsbJkbPcCkRFprwOW5fUGvw7EX29Ri1mlecto39pYdc+39Vdz+AnZDBze2Kbk5zOGwXQh6prdr6x71XtKPYf+zwBPnhoiSkdpDHgXQDNYbGWh4ay47mgBbBoxoevYJGS+K0TQqa9bR89L1zXNIUQUtFV0CgPfPfrbI21f8zRDRxNXeMUx9TRK9UxAufsZp8Vy+8iQ5ADp1vDpuGXFuGIrHL1JvGgSMcjaYPMUBA1R8ohL34n8JZWLWNVTi7PhZlc6v3lXvkzMDkKHU85UhQjlW5XqHnXwEfb/wDVlr2DDOu7kA18uzgYDNakya0U57M/UQU8Fb70WCAAPuHYprV4c3SmuDjv2t9m01RJxrP+vZhPjKLfFihfpPj6HA+89lshwK8NtfJ1UIs8LNPKv8LZuJkx3uEO68FazCZ02gIj1lSNCYRhyMNcyUMtcSrWB3UmlKhWgIoC79c3GU/pLPTBga/eVLOKhpsWerDklovieIoiYS25rNxj/JWdwmICWEEbaYLCxC5kiiOlAP8Tf2bU6dGZgY5xJ/qePVoO/R0o5vr1lNM5WuA0JFIaZJvR1sODYA8X9YsVy0CBMRkV8SbhNjZ9z47HR2Adv2VLcOTmD3Q0vOkVE4Qpg78NIa7XtJ4WrVgG4z5X6rGiOOTq/gbJMLn2Ciu6oBhRutXmB1ncXkhoOz6Ap5GcN5ObeJ5Oz2s1m8DDGVvWhe2y1Vk89gSqQlAK/IycDtt1zov0kpW2FhT+sy5j6cnpEIdi+mJfmJb1SgZq+texk47GglTXD2MYcRGLh/diWDpHJtQko3Ivw425f71HAK5Hb+XIn1rU8nT3eTebB4mieDFmAObaP5A1y+sdRyyiQNgahxmnpMf543RXdf/sGLrbYqDU3iPT1
 28pcELNb
 5I/KBSqdQGyCMAughmOw4hXrUveLW6qyZOmxo++kBA0+dEGJwDGD1yyEZwIdmn4SQdr3kSbhz1zrT4YrmmYRbxSRH4z2euxXm40UvQMjzEWIUAhOATf0ay5pY5szd8VEInYmOTYojaAXC217+dsf2OF/rhwCYa1Se1Z/sfO2E53xSxj2iHPBHUZIXgh3ES/KHuIiEf3YLgSAh+P15SoJKKtfYJjeQ1x4Hwjbqy7n+G6LwomHeJOT7P83zhw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-05-02 at 07:53 +0100, Lorenzo Stoakes wrote:
> As is time-honoured LSF tradition, I am sharing code for my proposal.
>=20
> I worked a very long day yesterday and got the _very_ rough PoC code
> into
> some kind of vaguely shareable state.
>=20
> https://git.kernel.org/pub/scm/linux/kernel/git/ljs/linux.git/log/?h=3Dpr=
oject/cow-context
>=20
> CAVEATS:
>=20
> * The code is not great, it's 'experimental, wave your arms, hope for
> the
> =C2=A0 best' stuff used for experimentation.

First, some refcounting that confuses me.

The changelog, and the code in dup_cow_context
shows that only the parent's cow context gets
an increased refcount.

However, the code in __put_cow_context seems
to unconditionally decrement refcounts all up
the hierarchy, instead of bailing out once it
encounters a parent that still has a non-zero
refcount.

How is that supposed to work?

Now, having the remaps array cloned at fork
time does make the refcounting on that side
a lot simpler. I like that.

However, it does raise another question.

Say we have process A, with child process B.

Process A has memory mapped at address X.

Process B munmaps memory at address X, and
then maps new memory at address X.

If I haven't missed something important,=C2=A0the
remap table does not need to get used, because=C2=A0
the offset and the virtual address match.

How does the COW walk handle that situation?

Overall, I like that you are trying to tackle
the problems associated with anon_vma, but
have to wonder if this implementation will
be able to avoid some of the complexity=20
inherent in the problem space.

--=20
All Rights Reversed.

