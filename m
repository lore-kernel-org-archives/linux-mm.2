Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC5E4CA0FE1
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 07:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A2B6B0096; Mon, 25 Aug 2025 03:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A3FB6B0099; Mon, 25 Aug 2025 03:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06BAB6B009A; Mon, 25 Aug 2025 03:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4BBE6B0096
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 03:15:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 05B7111828F
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:15:04 +0000 (UTC)
X-FDA: 83814418128.11.D2B6006
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id 24A841C000A
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:15:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kK2qjz9J;
	spf=pass (imf20.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756106102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bt12uJ3R+VPfoKnsBt+E5M880rvbJ4uyE/4wyV20PgE=;
	b=YYBfEJMpftPpnl5+b54PfCAqddYhtwaKaS07V8R6A2utF1Y1OF+ki10Kvknf3S8Y3d8JA1
	5WSOFt9DNy/fZA47s/JYd4L3lr7t3o6jXmBsGIqsaZY2zEnpXTrVwWXLjz1XGC/1yTM67r
	HX8l0F7tOIsa4MZKpb7wNxbNf2GJVWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756106102; a=rsa-sha256;
	cv=none;
	b=u5g6rwfYHC4nvw5DnFsMEN/jSWvETBtp2kFk2M604LNCDmj65JVMMbTF3KSxeV9mB6Xa1n
	Ax0UfDgcArd3ySJTLFCe25ii9fBmjAWplu+U3s/t9oBsc9sxdhKo+/IePhGRkan3CZIEXp
	RFe81Yo3ZuMFA5tHwuiyQZPwFty+7/g=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=kK2qjz9J;
	spf=pass (imf20.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1756106099;
	bh=eMGy4y29o/Xaojr66YRlL+mqETiAilNKbdnWyHcteLs=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=kK2qjz9JmVvoqJbD+9Z2wBdusaJYnGDPmASxy0tVLx+dYO/BpufQRmUxwhZILWCGY
	 XU7mzb/j2AgGn1PT4XVSPU+WLEmogXtQTIhUHJeQTMSGvGOW693yIzmaJ8fLbcQ2Zf
	 TtLcR1DvxIjOI25VfZOtzLhyh5PbZpRcJmPZA0J5UYkPteGoxeZ11nGAd3eblYsxGn
	 CDxzTf7MJZlv465pIZzrgFXb+3uRDM3YhN8OyMms1PvrN27kVTFD9rtaPOTLuGQWYG
	 GHZjSthrN1HEe05yGba1hjLeFocUYqA1NAs9tDD3OFNtWA2AqIzacsZK0dwrzg9e4S
	 3xOUmfKuPc9oQ==
Received: from [192.168.100.175] (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 08E4B17E110D;
	Mon, 25 Aug 2025 09:14:53 +0200 (CEST)
Message-ID: <a3928ec4-8c2f-4f04-bab4-9ef5c87c57de@collabora.com>
Date: Mon, 25 Aug 2025 12:14:52 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@collabora.com, Shuah Khan <shuah@kernel.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, kevin.brodsky@arm.com, kernel@collabora.com
Subject: Re: [PATCH v3 0/8] selftests/mm: Add compiler flags and fix found
 warnings
To: Andrew Morton <akpm@linux-foundation.org>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
 <20250822174259.bf4ed76a0da7d0d6f80ba2c1@linux-foundation.org>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <20250822174259.bf4ed76a0da7d0d6f80ba2c1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24A841C000A
X-Stat-Signature: 3z9h9etrw96z6zkboqhw6udcfhauwcan
X-Rspam-User: 
X-HE-Tag: 1756106101-850199
X-HE-Meta: U2FsdGVkX18H45A0tawYhaswQJpY4Ypb3mEMNxGpcEeLhYfQBeXBTq2+wxSWZ5wZvyvtD67Z+/sU5NNuoLgH+bASCn14ZOwEWDkk2jeb6vyUN1tgnFLIyD+rYIIjkOd2BATOrYol4e1eHkgO7stPcr0ZViXKHOEdjBhi+6H3rVcp0BcgDmf7HQwYQQ14vpCnZiAumdQdL6dZpoS1LfbqdXgaOJYcoZ0xfm0vwYPYcv0J5wEOhxDoJHJRH6HIrEc1J1maO5mhmX1iDGMwxalq/EEBpmUsOejTTqqrIWI8NSa9u6gSeJ2uiYRx7zvQWsCDe5vK6e1HUEraeY+BJx1uKeo1V74HAWSK0Vvc2/brL7k0Oh7SuCXu4LYdG9X3NopWzidNc51Vzirr5T4T08rRsLBO0eFi/bnozCz/B0Cl66va8M2Q03JiK8ZxXWlXIDXjdrQZ98ElSdj8ZrNdhw2Ln5vf0AOQ02PuR13TUxAXWOYdbYrxPeR3H6tYQQl0jXpX0AqYVkrVqNgDiND9rrWYSHFZpJu6l+dtphL6RlUEnPOO2BfyNbUsD0OMvwTlkjyWXzHVgNyJCJfRJymVuQIslWzbCTBBa59yVo37neaF9gxQwCLziDnuL3QDg04yxlnIvZemwJf105POsizUAoCLiX3ft7lw7Rpf4RaIeZkkKs24G1nli1FGTykzNOhUtltnLnO8ljcH4K9SMcrxeqUg4vYBtPQhtsYx7WExrW38HYA6TSNQBsOOT8Qlh1ma/g3aercM5HwSotrmf270TpPSpALgFtU4U+FnofLOnSIoyvH94ht5UHjo+g8CPlPrTM2TL7z15BjTIF9yqqZhQqJWVtnRuOPd3iS4WWtyqFvmS7OossquMnePP5KrRsC6k+IeHw2qcE0CDpfKH56hjlVXBYs6JcpnT/jYJZ0QSmNRR3+5lw/hRWcOGjsWXMAdgzUMVuXBzyJ6EutR15IxTVd
 zCASKFsB
 P11TEfhJFlEyIOR+W/Y7Fl0WXOQ4fMzw7ybYBdXomZqgvGI3ibBzVf673k80uewb3aqiM7fyq/gGGW0vOwQfpxVMhb8qDgid7e2egLLZESzCvAoMKaz6OW951hha5Bn+uEVan1s2lgIgJguuUQ0VYcmWvhzDjwQZM/gVQbcBCwS+Gz0dPxhmYu8tPLtZAdiewNsSM1xf5Fk7b47qQARe7WmIydpb9cTwN/NcBCeOmIoiqCPv6riUfrpaeHwM8TlGZ3Ml4h7ePyA3gUOLHsULJOTg8UPR2rEjU0N09HNco0pFnRfdMMXUvkJWkP4InT5WWKlpzfbHK4yC25weB+cF5Eu/FAhyrIvGSet3VOFBKPMv54HQ0MDJwfNYp2g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/23/25 5:42 AM, Andrew Morton wrote:
> On Fri, 22 Aug 2025 13:20:57 +0500 Muhammad Usama Anjum <usama.anjum@collabora.com> wrote:
> 
>> Recently, I reviewed a patch on the mm/kselftest mailing list about a
>> test which had obvious type mismatch fix in it. It was strange why that
>> wasn't caught during development and when patch was accepted. This led
>> me to discover that those extra compiler options to catch these warnings
>> aren't being used. When I added them, I found tens of warnings in just
>> mm suite.
>>
>> In this series, I'm adding these flags and fixing those warnings. In the
>> last try several months ago [1], I'd patches for individual tests. I've
>> made patches better by grouping the same type of fixes together. Hence
>> there is no changelog for individual patches.
> 
> I think it would be best to avoid adding warnings to selftests which
> aren't present in the main kernel code.  If only to avoid surprising
> people over what isn't permissible in selftests/.
> 
> In particular, there's an expectation that we can do
> 
> #else
> static inline int some_stub(type1 arg1, type2 arg2)
> {
> }
> #endif
> 
> without warning.  We do this extensively.

I'm only adding -Wunreachable-code -Wunused flags now. The above shouldn't
cause any warnings. I'll double check again in next series.

> 
> Also, please be aware that there's already a patch in mm-new which
> centralizes selftests' __maybe_unused definition.
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-centralise-maybe-unused-definition-in-kselftesth.patch
I'll rebase on top of it and send again.


-- 
---
Thanks,
Usama

