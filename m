Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B94C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 15:09:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7D16B009E; Mon, 20 Jul 2026 11:09:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 090756B009F; Mon, 20 Jul 2026 11:09:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8766B00A0; Mon, 20 Jul 2026 11:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD4096B009E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:09:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0BCB41C016B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:09:03 +0000 (UTC)
X-FDA: 85009487766.06.B735179
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3E94520011
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:09:00 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=fNG3pE53;
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784560141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Kwva7Zy1z1wrcNqc8C7vuOXZAaSl5rSUSt0nXXiyx0=;
	b=F4tTO0xWuWEpJWbYfEHIfOzt35kVE5rrprPZgdwOqdCa2sPtyCGwIjAsj63WzGl97s6sK5
	W6OeveYtx4z0a0n6N/MyfEbxHLULaKVfHx16IpzxejJTgbKXDmwXF22PyIu4K31VwfNvtQ
	euBWYgo9LLMUjdKPCa7po+L+QlnB9pQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784560141;
	b=HV64cm8ZBiM/h1f5aayTMWXBqz1I7nkM/cIxXtpQ3irXEFkZrytxbe4nnDHvmajWf5qlro
	I8bDnMCBdw7A4tTbKQPQZoe5TDDVuDMSSXo1S6E9Y9M8eDc9p6MMiFoGsLlJVFApEL5mDp
	7M28OXbAtzKQ8X7rCdPxxUbWZZhs1TQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=fNG3pE53;
	spf=pass (imf31.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=3Kwva7Zy1z1wrcNqc8C7vuOXZAaSl5rSUSt0nXXiyx0=; b=fNG3pE531FrkzSi/ukWn7R+4zt
	HJOBnGpm49FdsglRvScBkbywX83gyp8V7S5kQSTRP6WYHpX+Mp7RrZ6AkTsKYporq6eqw2avYLlyT
	ToPD3oazGSH059mpSXDrEu86kIcooInZZqHa0hYEU0lAHKOHtGmTFFgte0T81Va5d4beLSR1BbHpt
	04iSypL6lC08QrrdfZfDwcFQGdqmIC/2+q0ZGzkh2kJx4Bf3jClleajAkq1gNnCvSDIdAXIDaHedw
	IPKu879tFoMATr71yu5hOKseko0K+B6XffsCTPI56E+k6uOky4rKAJW2SYpqlKAicaLh6zgfnHoE+
	3FRSXt1Q==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wlpbG-000000001Qs-0nhT;
	Mon, 20 Jul 2026 11:08:10 -0400
Message-ID: <13ec2603d5cbfdc493939f182b71e5133c26af54.camel@surriel.com>
Subject: Re: [PATCH RFC v3 2/6] riscv/mm: add untagged_addr_remote_unlocked()
From: Rik van Riel <riel@surriel.com>
To: Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 	kernel-team@meta.com, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes	 <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka	 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan	 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,  Alexandre Ghiti	
 <alex@ghiti.fr>, linux-riscv@lists.infradead.org
Date: Mon, 20 Jul 2026 11:08:08 -0400
In-Reply-To: <20260720115741.239657-1-usama.arif@linux.dev>
References: <20260720115741.239657-1-usama.arif@linux.dev>
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
X-Rspamd-Queue-Id: 3E94520011
X-Stat-Signature: z6yypr44w9booc4qe8euzwt8e8nmq4mn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784560140-519666
X-HE-Meta: U2FsdGVkX183ajgK6EV7KWlMqFTu6bAedrRZteszK7x/f97bFdXYCwQ2iEApPXBzuU2p2j5tVJGs2MYpv64mWjvpYZghd0+yrrZMC014ZoPFmU2GdyrwZeXy26Gdh9spNSb+FbAqgJqYdLypc0DnMUfdsBG+rpMgPaXNRsOBNYjGFx070acSALwGVahoPo9OypraTz9+E1+NUs1Jd3dTriP6PNtIjFmXWKz47Oj+tyW3IhOh94IyJDZBQeZl8xyC+TclS+OyIlbsNywrFv/3WeTeSVaPTlUWFVvEsy9fAwHCuIzcAX2fuhO+Y57WsSU38raPbzNmOakbI0bFp5T75YmBD8wejcA3UMY4UmJtA9IDrKDBGQoJIzKyG6jNNSeNH9msUWmBoEn1PVsKRRv455NeFXGEAWSAkDbRLuPA+2BuIpewFZmv8MSHfof8Ke6Wy4C867q4gC3SSK2TOHNPEYtV+NX0LuKjJcRZOmbrnAMMBXGv0TcWVE3waE/v0K5KiE0GnJn0ubXbOIBSqCaTY7+5tBD2zMcc0wg24+Rl+qns/5RTUELwwft4txu+5zJVGew5md1HmC51jw0v14cENLVLPZDI/QdXCEvaDzoyvS3WMz2TTA+jJkSlsdxg5uvwz+ASzi0ukumNs5ZMp/QBJCsRjZfuj41RjJWvtrzCz5zIAjFR0203WhlBgqvSEF8qXcjaitvadTy5C1P1xA38Ps9O3r/PhfuVjGwCIFCFZJePKU+h1bcL8qQDAnAlWBUlJoYjeMlc33jvKL3Azh6yE6MG7EXyx/1mM6ORJ1qKIUpkw5xqvZpsew7hQVjKa2MplWwWBsv6NydMUbBWgxvgzmWh3r++/O/lPDPHds1p01oS3Sq0b72EHjwCMjiYDa1OiyVZ28ApZwj2HOlzFd8XTkX6ytxpbGs562JgBhWta1Zd/+5KtLyd2AUK/6JGZJu8SpRiwT0A0pVBlENOOra
 AK7+qJHg
 aw/NpoAoWVkwwdC5tj//s0oihIyBW6A+3mxY+DIKsRd5aW7uzB3RPyXStIgrwaCXOoXGJJI0KW2hJnZY91rLNS1niDK+pUD6Zx4j53E/SaGE3t0Xed6ELnMzJFjR/oC21Xy7lHCMgtsamsDSCbMgG5EB98PWfD1uYL/XuZgk73kUa4r1HzjUHdUiEZRov8E5S1M+t/I2dlopDLg1CG2w8+H53INVkTrhb9UVXVwUFANBmdp3M7j2BPn3l/WgeHaZU/yP9zJ7VOTp3CycYhLFCylvHtXgEXe78g41IEQdWiJB2F9IU0l6MvRDKzADFVMoaMfTf+BSH97q1h4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-07-20 at 04:57 -0700, Usama Arif wrote:
> On Fri, 17 Jul 2026 13:00:32 -0400 Rik van Riel <riel@surriel.com>
> wrote:
>=20
>=20
> >=20
> > mm->context.pmlen is set only through PR_SET_TAGGED_ADDR_CTRL and
> > is stable
> > afterwards, so it can be read without the mmap lock, as it already
> > is from
> > untagged_addr() and mm_untag_mask().
> >=20
>=20
> I think it might not be stable? set_tagged_addr_ctrl() can change it
> repeatedly until a CLONE_VM operation sets MM_CONTEXT_LOCK_PMLEN.

You're right, ARM tagged addresses seem to work a
little differently from x86 LAM.

It looks like on ARM with MTE, the top 8 bits of
the virtual address are available as tags, meaning
that address space cannot be used for VMAs.

For purposes of accessing process memory, this
is a little more stable than LAM, because the
number of bits we need to mask out of the address
is always the same when MTE is in use.

At least, I think so. Am I overlooking anything?

I will clean up the changelog like you suggested.

--=20
All Rights Reversed.

