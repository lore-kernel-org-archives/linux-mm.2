Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3498C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:49:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9126A6B0098; Tue, 28 Jul 2026 16:49:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B9E76B009F; Tue, 28 Jul 2026 16:49:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A9336B00B7; Tue, 28 Jul 2026 16:49:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 454476B0098
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:49:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A747CC04A7
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:49:56 +0000 (UTC)
X-FDA: 85039377192.29.FD9BA38
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf22.hostedemail.com (Postfix) with ESMTP id 03285C0003
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:49:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LV484WKa;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkQ4XkjcAKn8Afp/MQTA/Kyck9EcWtucG4G19yGBUvI=;
	b=N6nBfMc/+oW+qdd/w5C7PDi2G+b9yesxKwQWzz04OkibTdypd4tiYh1qe1iNzy1ap5KoN8
	hlb7LxyGZsMO1EmbT3A7WXpV9mJlgHHev5qqWpfSGfxGhFmWQvjbmdHVVFVaktGJdZZcMM
	RJtowl9Q25Jq5jq89Xl5zlS3wLik/tM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271795;
	b=d6zUf07epYGQNGGftZk/o1H9LNom8eRvuWFUC2iPmVhBue8HXJ4kWCmeqZmHft5KG7nIB1
	Kk4NgvJq+mXZbhDSkID9fF3B+f5PHE87HjZ2tPRPtMAYkpZAe8kK0zVXmX0YwnOaq4W4JG
	qDlCS2fmBy6XLrBFHrGYWtKem0TTufQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=LV484WKa;
	spf=pass (imf22.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=UkQ4XkjcAKn8Afp/MQTA/Kyck9EcWtucG4G19yGBUvI=; b=LV484WKaTl8ZyE9nOCG8Y+cPnw
	KACPsrtTbHh/vMxSpu/G7fuilxR8WelJ3hSVD2S9SJnroBXA8GrHjS73QqVp7W2N53PGGuYo7MbE0
	GVOwcUPiZkDpPPVsR07g+L5szrpq57wqTGgv3/QWfiUCk4neOfrsOmfpGSpCSmUFe2BxKtpCmXhYf
	H+df/lwNXKEw2S+swbV9ROBLeKGHho3Tu7KQEFQ/OdhUpwEacL07xt4Yn1z4jsoHgseWEbdGF/8z6
	WkJMJ3skbpaHex3jTDQIQCLl6h4lU7Ouj3nrlwu5WOaTWKe7zAjgyvlch4mzCa1Q0I6lx3fQeE4d5
	ibAk+kEA==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1woojv-000000000ft-1j7X;
	Tue, 28 Jul 2026 16:49:27 -0400
Message-ID: <8953b9172e8e2c6f418b40f464392d4e498c82db.camel@surriel.com>
Subject: Re: [PATCH RFC v4 11/12] mm/gup: batch contiguous PTE-mapped large
 folios in follow_page_mask()
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	 <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com, 
 Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra
 <peterz@infradead.org>, Suren Baghdasaryan	 <surenb@google.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka	 <vbabka@kernel.org>, "Liam R.
 Howlett" <liam@infradead.org>, Mike Rapoport	 <rppt@kernel.org>, Michal
 Hocko <mhocko@suse.com>, Jason Gunthorpe <jgg@ziepe.ca>,  John Hubbard
 <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Matthew Wilcox
 <willy@infradead.org>,  Usama Arif <usamaarif642@gmail.com>
Date: Tue, 28 Jul 2026 16:49:27 -0400
In-Reply-To: <7fbdb447-3d6c-4071-bc6d-1af4e44cbd7f@kernel.org>
References: <20260724222934.1463812-1-riel@surriel.com>
	 <20260724222934.1463812-12-riel@surriel.com>
	 <5490f8b1-d611-4e4d-bd8b-19c0e05698a3@kernel.org>
	 <a086dbb3cc9ee8faa638c70bd282ca31c58d402d.camel@surriel.com>
	 <7fbdb447-3d6c-4071-bc6d-1af4e44cbd7f@kernel.org>
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
X-Rspamd-Queue-Id: 03285C0003
X-Stat-Signature: 8mgw8hxeqthxuxex69154rfzcuh9ygms
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785271794-329843
X-HE-Meta: U2FsdGVkX18d+C3CKkJHoCtB/LqW9vvQWRcb8T/WHd/0eqhklu8OD7A//Z8vCd5sLIbFuWbuZslynATV1CXGkADRNKLgnxWsz4oadS569vi5jNbPfldXhWX0nGjnfLpTnvFAVk/4nlM/eRaQaBVK3QBbmsGMzvjHwgLt8A6Y+jUPmbK7XZ1KCXc4MsSRi60FgIBXbkUsxJXMouSfo1484520VWP4Im2XTe/hk/iRSjwg9joHwx4on07q6OJ1ZhLUQx6JC/9LcryF3NN/JBZhKUuxumSx7eY/F8M+LF5k+BA+dJsRtkxBiVhBOLu9PRdT/CFNQ4u4zGLTFcDsXSI0IXXuhvIzKEszjRaIZYaez+ljF3nqjskhbZEpoeQJAUTH5p93xRQwXE04fYaiUa5+gA2bQ5VgUG+QUXv8McfiwF9mPgUjtnPvEupXHTh2MvqIkzqnO/ICzEFBFjR36fUamEXyPksr/1DXdOtZY4bWz+BSLgphj1dANbIkXE+wSTT+N9lyUqNzJQGIJQxiL6OgBMjQwvFeyAK51PpYiuIHz5/cztMqNGAYiVyhNYkEIcAiAlUGYgBW+Be2RzjpG7KY9qUnzb7mltmbKg4WmHuBbMno9EZ+J9R+dEnEHoSAQZrRQc4ikONUa6i203oOHSY0MeoWro+3FjHafTUQcR4Ufszy5yuy4sIywjCw00NMJKcAIHgJEThqb1E0K7VjGR0CZWa07iDNl12lunDIWOlWLyFNpkqPJDVvrhI7m9HeSHa8m8UPTEFQl5FpZi87tJL2EgNgPGwqpqAWFL39Dpp4K/dnHHRp36KCtKJYSzUm7+DMZBZRqkR9MlNIOErVeyqx6MKEEm4y9VjB4MDqqVTm+fNp/T1McNW3eILIyb9StAUF3S7oULmShC9RrMq7HMC7NKu56rOKBSrFdYeI5qMjygw0iD1xS1cLB8VnuNW0N0PMmDGjx4c4fFvt4SZfN3W
 ewxifGVj
 BJwVNHfsUPyZeOlUkx+o/7dqfzDqJ5+Q1ZeSBgO9Eaa5oOkrAoNoV2Rrmn45s/aBHqNBNScoxt5m7WXU+SGLM0InkyOnOMgTofSTO1GP5bjpOLbAGOU4NPdt9pTrTk0/yO38OrdwBPeauBYRUIO72cj0yYKfCIGDsE5S5vHD1QdoUlU/Rbkv3vEAIi3WvOXdYHjKzXAw8Xu2JELPv38yBvUKNgVt2tkOlq55nle5Sb5z49XM7lr64+3kbZjJ6yCKLBbWs1Z/Ck8MnabeGMzG25n6LoAm8xoHnT9XsNOZhRSOYX4O8xondhxSm/yTgGBrIJoxphKtT52vPcBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2026-07-28 at 21:05 +0200, David Hildenbrand (Arm) wrote:
> On 7/28/26 02:37, Rik van Riel wrote:
> > On Mon, 2026-07-27 at 15:54 +0200, David Hildenbrand (Arm) wrote:
> > > On 7/25/26 00:29, Rik van Riel wrote:
> > > >=20
> > > > =C2=A0 gup_test -L -m 256 -n 65536 -r 16 -t
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 be=
fore=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 after
> > > > =C2=A0 64 kB mTHP=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 3140 us=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 412 us=C2=A0=C2=A0=
 (7.6x)
> > > > =C2=A0 2 MB THP (control)=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 78 us=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 76 us
> > > > =C2=A0 4 kB base (control)=C2=A0=C2=A0 3010 us=C2=A0=C2=A0=C2=A0=C2=
=A0 3042 us
> > > >=20
> > > > The PMD-mapped 2 MB THP already returns the whole mapping in
> > > > one
> > > > step, so
> > > > it stays fast and unchanged. The 4 kB baseline shows the per-
> > > > page
> > > > walk cost
> > > > that the 64 kB case paid before this change; only the PTE-
> > > > mapped
> > > > large
> > > > folio case improves.
> > > >=20
> > > > Assisted-by: Claude:claude-opus-4.8
> > > > Signed-off-by: Rik van Riel <riel@surriel.com>
> > >=20
> > > Why is this patch part of this patch set?
> > >=20
> > > This makes perfect sense independently, no?
> >=20
> > I'm happy to drop this for now. I think it would
> > fit in better with another optimization to only
> > take one refcount per continuously mapped extent
> > of pages from the same folio.
> >=20
> > I can't really untangle it because it modifies
> > some of the same code as other patches in the
> > series, but I'm happy to save it for a follow-up.
>=20
> Given this series here is RFC, can't we have that optimization
> upfront? I'd
> assume it will benefit quite some use cases that pin multiple
> consecutive pages.
>=20
> IIUC, it'd be mostly patch 10+11. No need to worry about the test
> case right
> now, we can do that later.

I'm happy to send patches 10-11 by themselves.

We can save a self test for after the future
optimization of only taking a single refcount
for an entire extent of pages from the same
folio mapped in the same process, at which
point we'll have something more serious to
test.

I'll get these to you soon.

--=20
All Rights Reversed.

