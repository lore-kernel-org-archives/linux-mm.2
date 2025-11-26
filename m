Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01152CCF9F5
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 21:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590046B0008; Wed, 26 Nov 2025 16:59:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568486B000A; Wed, 26 Nov 2025 16:59:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D936B000D; Wed, 26 Nov 2025 16:59:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 327FC6B0008
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 16:59:47 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE0EA1607D2
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:59:46 +0000 (UTC)
X-FDA: 84154125972.10.8EAD1FB
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2EC7120006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:59:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=X+sJ48Zd;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764194385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9FkhvCudArfrRpOQTQrvflMO5v8bBNDfSZLO51b6y/4=;
	b=79EQAK6EkURJQ/GVWtdHzkuVz3EorEV1SoXTx4cYp4nltXT79K5sPAlU0hu8TsXOqWExV1
	lwV2mhrIozrBJRHfkLkz5F9ZffFAirycwSns7DJv69iSMw3mI4qEjHXxZhABnKFMBj+UBL
	H6c6KNZ14Tdcc2MQyb6jTI5jduCuzu8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=X+sJ48Zd;
	spf=pass (imf13.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764194385; a=rsa-sha256;
	cv=none;
	b=gOlcH3g8Dt8Bu3wG4tsrMu8FEsrnOiU8q9BfsB2MkHpSmFpPeruUZpWDXfrlw4alTPFxth
	VPzNPKCNMHnXLilcQ61p+vXXwUKJOYwZ3u6D3VMAKzJIMq2DjCDp1LyztOL5YFsht3SAI9
	+PcrcWV3nHoAwwfRjD16mKDDbMZBE2s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9FkhvCudArfrRpOQTQrvflMO5v8bBNDfSZLO51b6y/4=; b=X+sJ48ZdNlCAogjTztyAKRLy1R
	U6d3zWP1hhP+nH0fjM+6qWJzElDwkNFcq7JjNku8WJKhsp5199ORO2EgqWHvVsjwmRxWtBvpoCT/9
	dMZ2I1QkPDsq6nbXm5rC1Q/SgpEDrs6IlEXuHAkxTW8+oDZ0mJpYwnB+BLaLLM0/SltB4Iu1hE/JH
	gIYgbl2JuQHsaoFegLZ10eIm6INB4DqgKOvWW0gjnfNmVH9gzF/a35//lS+UjTanJuIYGbmyVdOgr
	dsMnqcCLtGCov64WmFRCv1+EvAn9MsSANjSj51GhrDXJrZqQdbLLqaIIrBJ5vSHEW6OFdx/oKgzVl
	vB31dKQQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vONXL-000000000Ge-03qW;
	Wed, 26 Nov 2025 16:58:56 -0500
Message-ID: <3e90ccb0a3fd20e9b2d6e2cf19db9590394f7edc.camel@surriel.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton	
 <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi	
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He	
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Chengming Zhou	
 <chengming.zhou@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, 	pratmal@google.com, sweettea@google.com,
 gthelen@google.com, weixugc@google.com
Date: Wed, 26 Nov 2025 16:58:56 -0500
In-Reply-To: <CACePvbUB8wjEH1rsaRs+LwX4RKGrjLFSGzjhgrdS3e7Lcz6BeQ@mail.gmail.com>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
	 <20251121114011.GA71307@cmpxchg.org>
	 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
	 <20251124172717.GA476776@cmpxchg.org>
	 <2a8fd7bd35939b9aa4a7267c93e1fda995137966@linux.dev>
	 <CACePvbUB8wjEH1rsaRs+LwX4RKGrjLFSGzjhgrdS3e7Lcz6BeQ@mail.gmail.com>
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
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2EC7120006
X-Stat-Signature: 6skw6yq1r36q9kt61upz958babiyijyq
X-Rspam-User: 
X-HE-Tag: 1764194385-992587
X-HE-Meta: U2FsdGVkX19OB3bJNyPQpom8VAPwEK8JgmWKFUlBeCUvCWtbPkTd8Oz3fEzDyWcMddGV4ffPKv41fYQ9iRxdV8lufronYPvFemWOLe0SS/mAJoT04KBbpViN3iRL5Z2W8YcijJqfMtjHOuSKTZKpFMaJa19s19pQ13TR3pw2BKG7kXNiOWzIDoXKnSxJTg1kDyCxli1UkUOfGYHNgj0jtc7MEGN4qj0/qS7AtrQbksApefC6whr5o3kDVzAQ8sRJFqS+fs9tTOAhtTNf+0P9fNaUjER+j58HSpPTragShjaZO/8D1xltXaV8YE2AGNhWgoMWw4aksccf4BjLPFIiHNsTTFjFAwd8RRuCSmGMEKG7FE/MmztLHRGEDLrpq57s8SK8n9a3/s5Pn6FXiFWvR/cGBqZg3qUN8G7LqzwfiLY2rT9eZ29pk8a83o/zP2gxZPHgHwXhpkLU/XzE7ScUebanzhy4JisxBQPjn+kVh1pEjV0k8kzm1Em7PsgJftWooZ4Kq5oyDHx8I3RcJtGBu4JnX6vslcvyb2WVBI48QhbTX9E8Xwt0kSMo/Z7t4suVttwpmntKzn0eSSJjR+SZovyvJL3f55GrkToO9s1TYNFLC6htuSbhQfrn1yMPGEurtMUAwl3AfMOarq3o+9+OxIKLvX1d+mZqKUhK4QkuJQw2GOJHWICE5+MfsctwLN/fFWpZPZIeF9UhsR1Z0aRfoWPkwEZ9V71n5cZmas0Uelx+uTTSRaUvXBz80eb86nr9a+Vf8DfK0SA55Wwiv/+q9BvESE3hdBaFZzAACclThUJuqwsj8HxcFW3XXfq2rUaI2nTxhXJRtngSh1h4pSvUIC73vuO0NnpCGCqmsvuf2GAZV6C/AjFWJaPz3NKRINXLOHaX19M6KcWkhkmG72KttRiHfaBVfAkAQKMKsjqm7q853hST0UVJonFm3/mR8cjVoijkFWCfIJ6f2+5yGL0
 CuOETE5A
 ETkCb74OO9GCTg3HQC73FI4+IpfxrQ0sVQtvTPHk3GJ8dqHQffNlhPqxk2K6e1mzbHm1Gv8423DKsYISM/eYucNqaCa6lNb7kxKqsS62p8IY/N2bNgxLjAyMRPNY2gAu/WLKN+DWtOwTRUZvP7ZwTtbhFAg/BFPgOxyQfLPVyLki3bt9fAFL2ksOjyt3po4vtr6NKVrQfLvl3K9H+NzyJEjdWzGkfjHMes0oa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2025-11-25 at 22:50 +0400, Chris Li wrote:
>=20
> > - We still cannot do swapoff efficiently as we need to walk the
> > page
> > =C2=A0 tables (and some swap tables) to find and swapin all entries in =
a
> > =C2=A0 swapfile. Not as important as other things, but worth mentioning=
.
>=20
> That need rmap for swap entries. It It is an independent issue.
>=20

Wouldn't rmap for swap entries be more expensive than
simply always having indirection for swap entries that
are in use?

With indirection, swapoff can just move pages from
the being-swapoffed device into the swap cache, and
if needed the memory can then be moved to another
swap device, without ever needing to find the page
tables.

This sounds like an uncommon scenario, but it is
functionally identical to what is done to pages
during zswap writeback, where the page table entries
stay unchanged, and the swap page is simply moved
to another backend location.

Why implement two things, when we can have one
thing that does both, with no extra complexity
over what zswap writeback needs?

--=20
All Rights Reversed.

