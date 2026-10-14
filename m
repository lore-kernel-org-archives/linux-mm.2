Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78FECCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D2F36B008C; Wed, 14 Oct 2026 10:29:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484056B0092; Wed, 14 Oct 2026 10:29:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 372CB6B0095; Wed, 14 Oct 2026 10:29:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2766B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:29:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B39CA03CC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:29:33 +0000 (UTC)
X-FDA: 85321465026.25.98DF05E
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id 590231C0006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:29:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nHaT7s c";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791988170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rsATh2NvdfjYssyKDxNkJtZ2YWaOMp/Hif/9TBiSHDk=;
	b=J5kip6ZUQunIG0eNCFIF+85w2H6BE7Mb1LbQGG2z5nbWqMwBQ9cn3pk1fQZgiCQ2fVuMMd
	mPddnm3k7Ru7FdACnYe73MmwATjwQkABBxi99UKL/lA1/35EnPSwOdIZcmNEXEb6A2T5ty
	BTXXK4aVFrLxoAvnMDepf5G1OmqXkkQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791988170;
	b=yf2VmGgtL818FZj5Y5dqkV8sWliCZVOfUtew7Xk+Q2MuY4MGBfsrsYTdImKH/Vcdlf2ozn
	+fpLBF2R+T7Uks7F/2wy0bwiEvMzRui9HubOlhTAKEDV9Nx/8Knwt83LlmVLEPj546HThx
	dli+Vsjz8v0F+Dtyak5oTAeeKug7AWo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="nHaT7s c";
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=rsATh2NvdfjYssyKDxNkJtZ2YWaOMp/Hif/9TBiSHDk=; b=nHaT7s
	cXU1WXU6CO3hd6w6vappdCuPeAFBZCKamSkG2eanWhFG5ef7XFK4lpomusUIbqBABgVlsT+XlXteg
	2mMFrQwqUTSZ9kP3F3MsFx2A46M9MTDc0ndj67/y9ni7/JAghqLwhiddCULH6Q1yu9ZYtETTjkeNO
	WqIwl2/gjC7jTKra5m8FJ7seZU+T8PpPCqCVXYaxUZb9Vueaa3fHz56WJjILh7DU5BUqAW2ypWDkV
	gdUF9yM1Esri2XdhHpZmMBTMs/xp+eYfN2JpZuGXTwufa6A/eDVi17XuSoPr8uVW145eIVfTcsiq4
	ANwzrdEJzrUvdGynMUHv6rgUtkSg==;
Received: from [2601:18c:8100:a0e0:2541:b86e:2586:d219]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xGzxS-00000007OmE-0fd6;
	Wed, 14 Oct 2026 14:27:54 +0000
Message-ID: <038db2e68469e74077264a490e104391bdffe35e.camel@surriel.com>
Subject: Re: [RFC PATCH 2/5] mm/page_alloc: count a merged buddy's pages
 under the merged type
From: Rik van Riel <riel@surriel.com>
To: Dev Jain <dev.jain@arm.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka	
 <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko	
 <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, Johannes
 Weiner	 <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Kairui Song
 <kasong@tencent.com>,  Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,  Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu
 <weixugc@google.com>,  Baoquan He <baoquan.he@linux.dev>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Hildenbrand	 <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett"	 <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Date: Wed, 14 Oct 2026 10:27:54 -0400
In-Reply-To: <55f51fb8-9777-424a-b45f-a6a5bd9a4693@arm.com>
References: <20261007021250.1665929-1-riel@surriel.com>
	 <20261007021250.1665929-3-riel@surriel.com>
	 <55f51fb8-9777-424a-b45f-a6a5bd9a4693@arm.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 590231C0006
X-Rspam-User: 
X-Stat-Signature: nhw6nbwsf6do3kc4g86kz84j386jgnb5
X-HE-Tag: 1791988170-681061
X-HE-Meta: U2FsdGVkX1/ymf7ORQ1YDCqVvEzhRRgPDMha3hLJkwk8ieXA/UFGH4jYcoxd15sHCoQiibRc/AyFAGEfbH9zvcwMHnRgzTts7J+w2RJln/5lN4hrZYHqon9KoBGsrEnx4Hn1Hxp7b6iMP2or5Yd72xMGvlFdpjwd4QlUbmUBhE7f9tipQVfFkhF9K3RypG7Y42ArmRjgd0mtKdlFVtbAzCEQmXo4odVIDvlU/Y6rHGUHzenE9gF7RQBfWMPYu2PVNJwzsQ9Oso2fS0VoXCSgE86YINZqS9nrJ4OE9E102CYcLl1gVEOzMoI8fJfngAMz8K6xpcKiPQs5Rfvf9rIOxtM6tuCdqwrxh4S3kH0BOLWrC5PejxWlpYrdhnTM85RsH4evtxSDW50xcwp9YAoFxhHJ2YXWjNJlGdUcYTA2YwbWGS6ZAtCUn9VDwAIuVRErRAXEjQ+u7Pg+Sta0fkw7uuWLZYYC4ik8Zvp02Lj9PIAXy7ISik7KpF0ccTQ4OtQEdQK0R5zQYXuqHVEWwb2b+159l5qGqmJaM6cjWUvrc140HpFXF60S42fW/m/0RgZ2kPa5/IDQ/Wa60CV8fvMB3JwBxT76E64cDqNqaNEQyUi7dYqv5tqjbmR+dP3MrR8inu/mlO1NhLiIJ+F/kpW5jmCw+ORoxRhxRzLFZz5Kgrg9o8diJFp9hkKMvbJfE+erjhTggIsgmrhT4ara2uglXPB7vC5O0M3Bj06WiSwWO3+9s/2BaeiR4ZRsQQBBjKRL1C4zeRoBB774irm8e0xWUVl6kBP7PilJ68CIq92f3s12dOlBkWiw3usq3s0ZKc/BHJE/vGrJHfxvYD6Hgm/XZhWNt17IDCzAnt04ZXrFP3uYnzoekX1SAmEWkRvlMvU6qD/6mT12lMToOF6UUKJnIabojUzndPnG5yzdSAQJ/QyGWrgr/pekM/nsNq7WxMizDOUwLx97HjCO/VJIais
 2EH0LMlS
 slDJldAu4vNzqv6fkJuToGOWWC9R778xi7gI+/SxaKe6LPZj+p0l4IBB8fXDe7E/APF3pPNn2p/f4I3FSg6hDdSyVdk20cH46HBCKr6Iccay7fOIik1qafJqtW/wolfJCeYHx7IpGuPbHgDerUpvPGf3kfHNljeyp+Etp0cKfxQD6hpWwEKYElilr/DPM1M0leyKtxixZa9qttEyhR+M9ihdB/Asz3uD45+rQYVWZs2fmR5yXYFRobo5LaXwX1xilp2E3BTwDj4NabzQWr1o1QqjM+TA+PVsdrIZXTizmrAsbTzyDFkW5HpXjku9kGMET53uEFMxwHj9BP2mMEVlisfN377vkjVKPoBbzYnBr6wVjW3OpPV6R1K6G70vKjx3tD2b2JJrAlq5zQrQNDLJrjRILnrh7axsWb9ez2MvghqiXu5Wnw6HRJfFCgG+SQm3NcDPU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-10-14 at 19:46 +0530, Dev Jain wrote:
>=20
>=20
> > +++ b/mm/page_alloc.c
> > @@ -993,6 +993,11 @@ static inline void __free_one_page(struct page
> > *page,
> > =C2=A0			account_freepages(zone, 1 << order,
> > migratetype);
> > =C2=A0		} else {
> > =C2=A0			__del_page_from_free_list(buddy, zone,
> > order, buddy_mt);
> > +			/* The buddy's free pages join the merged
> > block's type. */
> > +			if (unlikely(buddy_mt !=3D migratetype)) {
> > +				account_freepages(zone, -(1 <<
> > order), buddy_mt);
> > +				account_freepages(zone, 1 <<
> > order, migratetype);
> > +			}
> > =C2=A0		}
> > =C2=A0
>=20
> MAX_PAGE_ORDER > pageblock_order confuses things so much : (

I'm not a fan, either. It trips me up every time.

>=20
> Sashiko raises something:
> https://sashiko.dev/#/patchset/20261007021250.1665929-1-riel%40surriel.co=
m
>=20
> Although feels like it is exaggerating.

I suppose if we switch the two lines around, doing
the increment on migratetype before decrementing
buddy_mt we could avoid that transient underflow?

>=20
> My concern is for systems with a high diff between MAX_PAGE_ORDER and
> pageblock_order. So on arm64 systems with 64K pagesize but pageblock
> size as 2M (and PMD size 512M), the pageblock order is 5. We use this
> configuration to reliably get TLB optimization from contpte size
> mappings.
>=20
> Will we then repeatedly overflow the pcpu counter into the zone
> counter,
> regressing stuff?

The per_cpu_pages struct does not seem to keep
counts on a per migratetype basis at all. It
has per migratetype lists, but only one
pcp->count.

Also doesn't the pcp only carry order zero
pages currently?

I don't really understand your worry.

>=20
> Perhaps I am overthinking. Your approach is clean, but perhaps we
> could
> also do:
>=20
> void account_freepages_move(zone, order, buddy_mt, mt)
>=20
> 	/* PCP-types do not have per-migratetype free counts. */
> 	if (likely (buddy_mt < MIGRATE_PCPTYPES && mt <
> MIGRATE_PCPTYPES))
> 		return;

Wouldn't that throw off the counts when we merge
e.g. a MIGRATE_UNMOVABLE page with a MIGRATE_MOVABLE
buddy?

With your test we would only ever do the free count
adjustment for mismatched types if one of the pages
was HIGHATOMIC or CMA. That leaves the common case
without coverage.

--=20
All Rights Reversed.

