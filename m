Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18ED8606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 17:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=TvIwMg+3
Received: by kanga.kvack.org (Postfix)
	id 7F82B6B05B0; Thu, 26 Nov 2026 12:38:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9436B05B1; Thu, 26 Nov 2026 12:38:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BE8D6B05B3; Thu, 26 Nov 2026 12:38:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 426BE6B05B1
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 12:38:42 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AB4A780459
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:38:41 +0000 (UTC)
X-FDA: 85477980042.15.A1E5A67
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2F9FF16001A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 17:38:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=4teLVqdxHTIzeHzEWuOEGSiE2+RDD7y3+MbgjsgCQhI=; b=TvIwMg
	+3sFwNPvLhoFzrimboVdCHWGmjGzP3mjH/aJwAcQ9ZNQb90BAkG9GHRaeOppEMN4+0sC+EImeFNev
	aODfe95REu1AP2SHRRIQC6kzDXSZ6zSSdUCjywSUgdDQ+ITZukxheaoSOnDvnbkP+Wb/5Xqc9TnSL
	wzQbXWQ9CjHXkC1g3ODtZIortRdF6u9MHAHlrss9N3xTTNrlH5KCgVnR1JmtnHM1/U18BQZ8qWksA
	njO3/qIkKahO4yNGr1+QyPNyYsLefcLjeRZgbrl0S0QUUHBRM8tJ3MJgNq/YAcXXO5z9THXi3DhKJ
	CI6T1MWBxeNT7+JGCyDpmWMK7Tig==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xWdPy-000000001Yi-0BK6;
	Thu, 26 Nov 2026 17:37:58 +0000
Message-ID: <577d25b6aa80bcfc216eda5bb4311ffe796be49e.camel@surriel.com>
Subject: Re: [PATCH 9/9] mm/gup: unshare-check every page of a pte batch
From: Rik van Riel <riel@surriel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Suren
 Baghdasaryan <surenb@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Christoph Hellwig <hch@infradead.org>,  Yuan-Hao Hsu
 <aa9736195201@gmail.com>, John Hubbard <jhubbard@nvidia.com>, Jason
 Gunthorpe <jgg@ziepe.ca>,  Peter Xu <peterx@redhat.com>
Date: Thu, 26 Nov 2026 12:37:57 -0500
In-Reply-To: <05de9fe1-9a3f-432d-9ce6-9f497852d1d6@kernel.org>
References: <20261123195609.4115244-1-riel@surriel.com>
	 <20261123195609.4115244-10-riel@surriel.com>
	 <05de9fe1-9a3f-432d-9ce6-9f497852d1d6@kernel.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Rspam-User: nil
X-Stat-Signature: ju7gakm5fmyhu64mihyxuzr8wd7drq3s
X-Rspamd-Queue-Id: 2F9FF16001A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795714702-445875
X-HE-Meta: U2FsdGVkX18QUwCswc8ZGaCBshGcagZqdUglJVNv9TFHjw4GGuxq1+GXDhTtLEVEifRx1B+eqgnBheHvw4lo+SVlUzhSyT6XihvYA7nXk0vfhncGsvmrmbcNFy7RKxMAcyRNN3wXLiLF3XAVY20n5d5tX0X+hpQrR7hwiM1ZAj5JtoIyboKr17Sxo9/uZ1Y0PzEJbUpfw5dgY4cJQSALramDZVU+wtrMkg3AfHGn1N3I2RIb7OTyT3BUYtaMfj2UBe3cGfI48uBliTd+Y+xeWCwjGQ8WoEO/Tfs5UbCoV4n8Uhsq46huBtOquInTK9PtOgTYQeuD8XS7NwGGPMH6WguQNCtF22Frtl1ZoZ2jmmLq1Orh9TT+hR5cqSofDirtVx5ftJiEcOIy8mH3xWQ67e99Tv71jV2y+uARwwghHw8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 2026-11-26 at 14:50 +0100, David Hildenbrand (Arm) wrote:
> On 11/23/26 20:56, Rik van Riel wrote:
> > A slow GUP write pin over a PTE batch can hand back pages that a
> > later
> > write fault replaces under the pin holder: the process writes to
> > the copy, the holder keeps the old page:
> >=20
> > =C2=A0=C2=A0=C2=A0 pin holder=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 process (mm owner)
> > =C2=A0=C2=A0=C2=A0 pin all 16 for write
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 batch passes unchecked
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 write to a page
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0 fault copies it elsewhere
> > =C2=A0=C2=A0=C2=A0 read pinned page -> stale
> >=20
> > With GUP-fast, FOLL_WRITE | FOLL_PIN can never reach
> > gup_pages_not_requiring_unshare, but slow GUP can reach it
> > with a read-only head PTE.
>=20
> I assume you mean FOLL_FORCE?
>=20
Indeede, it is FOLL_FORCE. I need to rewrite that.

> I don't quite understand the problem you are trying to solve reading
> this.
>=20
> So can you walk me through the exact sequence of events + flags that
> are being
> passed?

The sequence seems somewhat contrived, but it
looks like it can happen, and some runtimes
(maybe Java?) might actually do stuff like this.

1) mmap 64K private anon, touch it (one mTHP folio, 16 pages).

2) fork, child exits/execs

3) Parent holds 16 pages, all PTEs read-only

4) Parent writes first page, COW makes it exclusive.=C2=A0
   This is now the only PageAnonExclusive page in the mTHP,
   while the other pages in the folio are not.

5) mprotect the range read-only. Now all PTEs are read-only,
   but the head is exclusive, while the 15 tails not.

6) Slow GUP pin_user_pages(FOLL_FORCE|FOLL_WRITE), which
   pins all 16 pages without COW faults, since all the
   PTEs have the same permissions, they all map the
   same folio, and the first page is PageAnonExclusive.

7) mprotect the range read-write again, this changes the
   first PTE (on an exclusive page) back to read-write,
   but GUP already did its thing

8) A write by the program to page 5 now causes a
   COW fault, since that page is not PageAnonExclusive,
   and the refcount is raised
=20
9) A write to page 5 by the GUP buffer holder
   goes to the old page, and becomes invisible
   to the program

The fix is to simply do the same checks for
FOLL_WRITE that we already have in place for
FOLL_PIN.

Want me to put the above explanation in the
changelog, or tweak it some more?

--=20
All Rights Reversed.

