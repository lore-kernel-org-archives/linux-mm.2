Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11139CC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 20:55:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9028F6B0088; Wed, 14 Oct 2026 16:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9C76B008A; Wed, 14 Oct 2026 16:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1106B008C; Wed, 14 Oct 2026 16:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E59D26B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:55:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D1A2C07DB
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:55:13 +0000 (UTC)
X-FDA: 85322436906.24.1C758B8
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 23192180004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 20:55:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mlsfcT Y";
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792011310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nDxZe5zkbk1pmGSLhA7tLfIExZwUZ0obZcnML/ZunGs=;
	b=cgmyL+RxjC+JHmrYaN56G0X6aDF6x6AWdAZ8LVzcSAh09uS89eGtM7Xmb97bDlE1P6qO53
	OTAtgQlHOhf48m8iasMixCeGaawvq7pwIKXMYJBLsuwiP3l6pc35DcRdcbmyVrFpo4htWO
	J4oK5YlWRMFcrLZ434AFdAS6oAvhOcI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mlsfcT Y";
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792011310;
	b=U5HzRPWNNeXxWnyRtrqp3YnqdBnGwq483fC4Is+RUf+splTCzZHR3ZCH6XJyNuVeXN/hTC
	xtw903YAJl2ZwTxsLrb6aofOtmNHtCI0MLIOnIWME6xCIScsMxz4CViYTkwgxgbcVJISKq
	PbwUKm4xoAykW9EKXL2/BpupLIZWcm8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=nDxZe5zkbk1pmGSLhA7tLfIExZwUZ0obZcnML/ZunGs=; b=mlsfcT
	Y3ePSJP/O8uZJ3sGdAzB8HRGmMsa9DMIwYZe3Wb0uhIyu7BGynAAxMkvzlc8osprofyVObT62geNO
	cUXorem5pPYeNg9q2h4j1ICTEsVU0njVVYiBiD6zwL2SOfcrLoL6YJKtxaW6Umev9EmqrgyAcXS77
	zmOl2Uddms80l5ls6TL6MHAxKEAMCvzQWOWZ9FsRhwXRxfOINABGo2u46O7vhuaz7j5862ZCoKZLR
	C5sHmwxKC2e8W6Ah6EYE1Ggige664IwgZYqVLZhiqHnRAmZ/kq620sT8nnOrJs8CuBGWX4rptQLLS
	xI7iTlkELzdyByW9w9WCkXvJh1bw==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xH5z6-00000007lrR-3Dab;
	Wed, 14 Oct 2026 20:54:00 +0000
Message-ID: <5234543d2c1b44706501d2e079b41e95a6a1d200.camel@surriel.com>
Subject: Re: [RFC PATCH 3/5] mm/page_alloc: convert any movable pageblock on
 a non-movable allocation
From: Rik van Riel <riel@surriel.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
  Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,  Brendan Jackman
 <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Kairui Song
 <kasong@tencent.com>, Qi Zheng	 <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song	 <baohua@kernel.org>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie	 <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>, Baoquan He	 <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Date: Wed, 14 Oct 2026 16:53:59 -0400
In-Reply-To: <20261014204836.GI371161@cmpxchg.org>
References: <20261007021250.1665929-1-riel@surriel.com>
	 <20261007021250.1665929-4-riel@surriel.com>
	 <20261014204836.GI371161@cmpxchg.org>
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
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 23192180004
X-Rspam-User: 
X-Stat-Signature: guow7zyu5jnx3srkoomdxqj35ye1311x
X-HE-Tag: 1792011310-294704
X-HE-Meta: U2FsdGVkX18OrLeQ4Wz5iSxBAy2rENs5A6IAnvlNAxOoveDkqUP+gvDAajS8fJOuU+5PKi6Ft6tepmgDtYhmZC48JMpuNsPZEAR+U2MnSAXcdHWeM41LWeKXer4gznGEVEzkmBToBUYm7YHbqTGr/BL3ZZPZx/y/RItLcFzIw9lP5rASJi64BnFMCA2+aOK2ugnlYi1U0wREgAuGo1r53j9Sgay7FoNA/AEtB6LcocccImH9PS/S6ERFfsQcJY1Xm1pZpEa9RsAtk4DWWLfW2t49yO3xErEDqvjTuPb38LtOUVVquPRq1aEFNUyjy9MsRj/phu7HVPyZnAgntFy9gHlv+RDwSajL8m4DObtRyd/BqSQ/q2yBJ6GPfMU5G6Elr2qMbRl1KyCBBbDwAn7RZs1rqJIyzitYLVSUJlhtYKnYmGiSNW2Z5v+IQNXEzuL3rxBR7k615JTQDsjjIZqHzzQzSPQeJ3C4LfdvbyzBXOVVU9Yfd1ftenVszyD4IBBTiPSw83HdkTmAfNCNW3uK8+i1twG/PYK0QpKKbGEFzC/gbHujAh+5Iqtru45mYbZ1+MlSeMlZqHSGgP/HgPIkGweAIf0no+V3AvIvOGUQhli5WoqFuR3f3vdaL8Gg2qkBBFLMxYup4jHdVdaTz/8CJXKAicyVJyCU/+ouf3NgCAYeZCZe5OSKm7ZTVrrAw47nBx0GqjQaUpPAWZ/rob7DqpmKCggpdqog2IxkX35aZoHlzALXONnXU7saZ8a8Yj425GJaRpAfFZijYXF/p93o21PvW8u4CPN1f9+Fm3GbS3FDfApqdapICe68zR3plwPS2Mqy3ieA9Bv1+CY7nrZznM5cvu1lS2FAIT6fTJGVwOqHn8fKSG4Z5vWj1auxsyu4VO4VUWY2OhzZ90HPN2SZlUZv6iVOG2Cm+KYjdxmjBNchq70VMeTS6op63Iy3pzZRg7BcosY5V9ClKQp73Ub
 Du8DXuWr
 bflasVcNDK3kW4kXvnqY1GT6xOLwrQY+V+lKVX5E8vXLo8G6jgdx5/lXTh3Pn9PhFwScbdOxQ1daZDUp0iVOc74q1+Tsn2vjw65/P4VnBDCI4MZijLc40LIqgk2bCjqQsDwdHqgCL4vunJ1dLXjcsIanipSNdoJaC/kTEoH9jo+/O2HnuJXJ+VB0gD668pq8UZfl8oXAEW2cFUdmI+HeCHSlAJqOhWUa0Z+qrK7P88LQbD/uc8OdVF8csQzLwPVAPl9SCrW+NOyzl+y2jVxRL6/NS1L+j6/ot7BLcob2IFbnOr77GTeNB0rFLLonp2mD2jwQtKBvojlg1gX1d7QW4mAO0EBMPNPssVAt3c+y/yg0AuGgGomk25XwH2OoQEr39eN+M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-10-14 at 22:48 +0200, Johannes Weiner wrote:
> On Tue, Oct 06, 2026 at 10:12:48PM -0400, Rik van Riel wrote:
> > try_to_claim_block() converts a movable pageblock for a non-movable
> > allocation only when half its pages are free or compatible.
> > Otherwise the steal path takes pages without converting, and
> > non-movable content sits in a block still typed movable.
> >=20
> > Convert a movable block on any non-movable claim, however few of
> > its pages are free, so the block's type matches the allocation it
> > serves.
> >=20
> > When other pages in the block are freed later, they end up on the
> > non-movable free lists, directing more non-movable allocations to
> > the already non-movable page blocks.
> >=20
> > Converting a non-movable pageblock to movable is made stricter:
> > a movable claim takes a non-movable block only when every page
> > is free or movable.
> >=20
> > Blocks straddling a zone edge are never claimed;
> > zone_spans_pageblock() tests for a block wholly inside its zone.
> >=20
> > Assisted-by: LLM
> > Signed-off-by: Rik van Riel <riel@surriel.com>
>=20
> I like this in theory, but wonder how this behaves in practice.
>=20
> The block is claimed, but the movable constituents aren't proactively
> kicked out.

I have code for that, too, but it seems like
it's a lot easier to get things reviewed in
small portions.

If you want I can resend this as a larger
series, with:
1) the pageblock claiming
2) per migrate type free lists
3) evacuation of movable pages from unmovable=C2=A0
   pageblocks, when the kernel free lists fall=C2=A0
   below a watermark

That would be the full extent of the 2MB granularity
fragmentation avoidance stuff I have here.

Just let me know your preference.

--=20
All Rights Reversed.

