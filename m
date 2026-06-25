Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76FCDCDE008
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463566B00F7; Thu, 25 Jun 2026 07:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 438B56B00F8; Thu, 25 Jun 2026 07:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3283F6B00F9; Thu, 25 Jun 2026 07:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 01FD66B00F7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:20:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4F207120666
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:20:42 +0000 (UTC)
X-FDA: 84918192324.13.D433BFA
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf11.hostedemail.com (Postfix) with ESMTP id AF48240002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:20:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=j+fUvyNt;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782386439;
	b=MzIXI6ffPboDcoMl5ck/cBR7upZwf56v2i7eHzA+en/M+S7BfKhI9BDWHHHzVtWOKyKCAX
	DGUTvPHBaj+Ve8Ysu/kMBZt/1ZJW7kOD+Hm1LGoyEoiJahXkvmAgSlR8jgT4hge7pr6CDJ
	ZXmpFPbM4WDS0Uo3NxjwtbjHHHf0EVg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782386439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JFk5c/1jNSMQLdFUSaHagIMvPm2hmWCfIn7xWSUzENg=;
	b=P6AHxGFAGaRVMtGqk6X6ALw/L9wD0vKtH0vYCrw4U3zcTehog8fGlpvGZuYs91qrLRJis6
	Uy4DBkkWeJ03iy8iqRgodhXCwZnnhDj6exlzS7Vd5LXyP2tFmVxpsLb+ElspZj1DJ/66iv
	V7s24uFQR7xvuwRpp+mJhKOpUUz/U0E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=j+fUvyNt;
	spf=pass (imf11.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JFk5c/1jNSMQLdFUSaHagIMvPm2hmWCfIn7xWSUzENg=; b=j+fUvyNtxzAZ/qnLIU0qO9PFEV
	BQxm5FHxb+olPWFNqAoGztRBjQuvVnOpQnKwGyVS7XFKPAlM1uLEnC5mOk1fQ0YZGayJ5Jpek1+Ll
	bAgYlL0PqqZeMDqKlbBmfVht5QHbJ3W2p/cRdK4TNWEiOcztdU8Dmm1M6vTwNLU6vou3stgzFz+C4
	HmfUTPmunViN+bsbWtI2pEtCwM9Taabq4OSy+ujrbz3LXauDgofGfnS6+GA62rT06aumDUbfFaROF
	+8+4ALPbVvAIAwDIyLdlhfqNHTxUAQfXEOMJ+lQjyPqBBw9Y4fpMRBJuVtlFAhMwvjdm4ysoCbGq4
	4UaWS68w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wci86-000000001j0-1X3u;
	Thu, 25 Jun 2026 07:20:22 -0400
Message-ID: <610d1c95a2f9131d5c018304f9a90afb33e8a032.camel@surriel.com>
Subject: Re: [PATCH 2/3] mm/pagewalk: let folio_walk_start() run under the
 per-VMA lock
From: Rik van Riel <riel@surriel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Dmitry Ilvokhin
 <d@ilvokhin.com>,  Borislav Petkov	 <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andrew Morton	 <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan	 <surenb@google.com>, kernel-team@meta.com
Date: Thu, 25 Jun 2026 07:20:22 -0400
In-Reply-To: <ajzUCZSRU3h_UdjR@lucifer>
References: <20260625015053.2445008-1-riel@surriel.com>
	 <20260625015053.2445008-3-riel@surriel.com> <ajzUCZSRU3h_UdjR@lucifer>
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
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF48240002
X-Stat-Signature: bcmwmg1napt3ijtgw9qjoui1zehdrq8s
X-HE-Tag: 1782386439-269855
X-HE-Meta: U2FsdGVkX1+1tQigVWbYBgI/cpxnJN8CV2UQmhl3Sd3JTTaK+Cfj1Vr8jaGPK7U9tNE+TYu/znltYzXlgWrtUusINay3xNBrUBLtWIDDpEg4sWVYqLWCEdwgKSDsLnTD6jNdl+GURxglrQV7IyY7huKBkg4hKMeLZK4CkmIFFOenDcO1GTb3OGeT0hSRoO4draJDsMVFJxLcHw6NzFSHOtDCuixqNWKHWj48NErLYeclISjMKXT5cTjrvNlVWeBwv8HzDgg989wTV46KtkOaEnElrphLRGbT6NMW9bUw+kyZC+6z9zj6MKQmUIjkSYfAgIbR2qFIsxrehnsyV9zm4EO1gfOqkYLB4DcO+hKNoeK7cNd3IrSjj2h/JTb6J08gZ+K5vuiRAbut3zZEkYqD6HZDyRjhPSieG58+wmRWzeikPgmpIJmwjWcpVr9MGcScnjaBw8rwQr/5dyCTd0DII8dbdBEAm/gev5WOt/ZyLedG9TfO9DHOaj/VQqbF/0YXvE154yfWTzWh0U113oWGJueUF+J0/n/suH5cya+uirak9K/F25nSSQZuP0wWBglZdI/rsR+gUHTCNWnlvZGEnIWV+CVmwEWXasRO09dgYY8xXSQsIKSOONQl9GT/M8c3aGH+BI0UeigQZ54bZiIWwOodDRLNxOJWPK7dqfr8tPlXwPNTtGmIjWz9ah4Ln+KvaTS0sL6rCo+bw5c3gXl86qV82jXJQY7BaY+fnAvOL9nq6wL7L78Ockcjk4dTZXBC1b3HcQid1oxCA/00a+pcJSuL7BCourKi47JO5IIeLTzCjXlfb+Z3FaS7/qscxWnxoetV0bDlbTKilLm/AySwY77GpB1yJrv/+EffgvqXdtVNFY67z7TmXGLCcyyTTDE2d/D0FYsSDGEF3e/y6WM2wsbXiGJXFEvqjF86LhsTyyaDFjAcfz+NbhyzOWT9sIFuFg4VL4SXg0nEv/do+4L
 zWwWp2PR
 5VBaPJ+aFUHLCMhzQmJzXIjfp/JbWdJ7lPcGxXo1MYG1qGmj7uHIQtApisXlECiBX5POVFlSmgdpZkTXtr5MXYdesfJJRrBsl0GI/pqfoD5Cg5J1uxqbUh42meRW9YgfRmEcqDLJp5XRyZNVBZ4roAvOXL6rXZxTKVia5SKR/uBJJHtMVp1sfCrACx4lB17KahZLD//sqyDDml0Gpb14sAnMJ4BpIafmu9RlpTxPrFGLv65A53hQBKWQjU6ZEEZflsHvKw601iKT7T88iCFSmMU8ezDSI/BiBiEuKpr4dvX7Da+jzDLhjfT3oG0OvBbT9umO5q1F+lY6Pa/Tu+7FGA0Sx6LIejERLHXMW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-06-25 at 08:34 +0100, Lorenzo Stoakes wrote:
> Rik, it really would have helped if you'd replied to review :)
>=20
> On Wed, Jun 24, 2026 at 09:50:52PM -0400, Rik van Riel wrote:
> > folio_walk_start() asserts the mmap lock is held.=C2=A0 For callers tha=
t
> > only
> > need to read a single, already-present page, the mmap lock is a
> > heavy and
> > often badly contended hammer.=C2=A0 Such a caller can instead hold the
> > per-VMA
> > lock, which keeps the VMA itself stable.
>=20
> <newline>
>=20
> > The per-VMA lock does not, however, keep the page tables walked
> > below that
> > VMA from being freed.=C2=A0 A concurrent munmap() or THP collapse of an
> > adjacent region in the same mm can free a shared upper-level table,
> > and
>=20
> Yeah I need to update the documentation on this at
> https://docs.kernel.org/mm/process_addrs.html=C2=A0it's more subtle than
> written
> there.
>=20
> Firstly you're wrong about munmap() - it acquires the VMA lock of the
> VMAs freed
> in the range and will only remove an upper level table if the entire
> range is
> spanned.
>=20
> And that's the only way higher level tables can be removed.
>=20
> PTE page tables can be removed via MADV_DONTNEED, but that a.
> acquires the VMA
> lock and b. frees the PTE page table under RCU.
>=20
> A THP collapse can happen concurrently, but PTEs are freed under RCU
> so you
> don't need to do this GUP fast imitating stuff.
>=20
> > THP collapse (collapse_huge_page() -> retract_page_tables()) frees
> > page
> > tables of VMAs whose lock it does not hold.=C2=A0 Page table freeing
>=20
> retract_page_tables() -> pte_free_defer() -> RCU
> try_collapse_pte_mapped_thp() -> pte_free_defer() -> RCU

One issue here is that while we can safely read
the old page table under the RCU read lock, in
the middle of a THP collapse there is no guarantee
that the old page table points at the process's=C2=A0
current memory.

Khugepaged could fix this in one of two ways:
- zap all readers with an IPI, and use that as
  synchronization
- make sure the old page table's PTEs point at
  the individual pages inside the new PMD

Right now khugepaged does the first.

Relying only on the RCU read lock to read the
page table could result in us seeing old page
table contents, that no longer point at the
current process memory.

Unless I'm missing something...

--=20
All Rights Reversed.

