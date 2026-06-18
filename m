Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63F8CCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE546B0088; Thu, 18 Jun 2026 10:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A6996B008A; Thu, 18 Jun 2026 10:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 196766B008C; Thu, 18 Jun 2026 10:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA37A6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:05:52 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7024D1C011E
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:05:52 +0000 (UTC)
X-FDA: 84893206944.16.E2947E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A9AFD140013
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:05:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=guRgYMnh;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781791550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tVAxdJW7jC5jS/EGdsY03Ok8EVfqupezCmX7jIRIDTo=;
	b=GYWSTbw5L4yZcMxXYBqqAH20T3eZ56dypPajvfFFeBEsSLXHFHhAfA7SvncYCVKYJB+d+y
	R/OynU05ooCTS/t5TADfDuut2e01cYojmmq0om6wJEKycYXLwyzoVABRdQIQP2mAHVJpCV
	t8xE9kGOTUrlHz5KItJiI9rLIpYUYXY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781791550;
	b=coB+U3FvF7AqGacxeUO91fcMGYhKAAL6lbAvbAMxmCVymITN3zdS0d8/zEWy5rOfkTtYc1
	kwCgf6EAp21oNPPsTjZWj1wF+LHsMDAoamzQJAESbZbKUYyg6s2eRaSTdUgmdu6w+mVsgl
	MgRuwQW+0fKnHXeUzIAajVTQiBvGVq8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=guRgYMnh;
	spf=pass (imf09.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 10C4160008;
	Thu, 18 Jun 2026 14:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2409E1F000E9;
	Thu, 18 Jun 2026 14:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781791549;
	bh=tVAxdJW7jC5jS/EGdsY03Ok8EVfqupezCmX7jIRIDTo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=guRgYMnh8lVzlhkg5QOvp9HmCWhWuAtur1nhXuuAxmi6OyIatGXW/4AAMLdpMjQZ1
	 BuGWAcPIdh4D25J9fv4Shd3xBjt3f8rffxUrUvc9J/ZnbB2f7lgqId/h2fm1RM/uL0
	 g8VGGkSgiqmlL1jFWg468nX031Kwq6ZlSCQ5LfUfSZ8/stVkSvSFM4Tqe1gYl5N6Mp
	 dg/VYKXQiT3K05iCarleYoF4Pmr61oApqv8o7lJKdF7Ryl6YiVZ6HerRjgVQgjfpQS
	 SypMSRxtr5kFuPKLlZgazCm+kz//yoP5XVt+o4fkAcCQgpWwLZCY6wsKabtoZnhzIQ
	 rasK12Ot6W1Bw==
Message-ID: <2a7d21fa-28c1-446c-97f5-2513f29157d3@kernel.org>
Date: Thu, 18 Jun 2026 23:05:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
From: Harry Yoo <harry@kernel.org>
To: Dev Jain <dev.jain@arm.com>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net
Cc: glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org, catalin.marinas@arm.com
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
Content-Language: en-US
In-Reply-To: <b1502a60-09a1-4699-886b-93d041de7023@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A9AFD140013
X-Rspam-User: 
X-Stat-Signature: jt5jdoeysdx75ekish74yaoc134dh975
X-HE-Tag: 1781791550-711892
X-HE-Meta: U2FsdGVkX1/30IDNL1yTJNvxjZlZsmEqecZ8SORn+7EOXdybCJNQw/4sHJ+crUhwd0KLnRu1TXVonV/HKQCcFQYQd+qSBXFF9UiTjjK1oLiMz8VwiQJWQCDh1Yn4xfqrp99I6NpUApWPsFyPY9r9jhnRbMzGMhoUI1M0oEobrHqWOFWgxBtO1/uR6Z3v03Cuf8+ol06I0jnlN16qXZ4oYRgozk1QIdoAlSKpEKuy7sYrGeHwAP6Q4bihBqyLS10ku+euShXN4iOl3HWIhZ+pYZj2OC2UpyNR3koaTJlYkZqA8Pig6WgNe7v6DZgvQBwKFzSVaL7zinzuWzwkndBAysVvsv9DbSOAF4Kn943yA6XScbsWJZKu/xxuCfer1lElEde3eedFnGPn/58LIwJIvvRi30JobnnUmjyZLT5rdxkW4efZjIznviWC/mmn4r4hwTJn7fpIPxRyo3l+C6aLlRDQz1/txGHgesrLYPpoAebi2ibW6gdvCTUx5leUCKoU4GZEfBIXvHEwJBT5NiwXm+uXLc3T8O2xq+5corI3zHQX9jZdwkOCmvSbM1wk0yUptBxs60fUe7LGHstNu028UumH1fp9mQHly7zbbXckn6ma3Ok/EhPLsxkgaal2q8EJ59avJqvgMcynPOQY1h81m8kPapAFTGC4NIiomgOzSZ0pVpuJcGgXa9uUB8J1zeYkrealA21rgxza7IYTqCLVugU0qm+L7XiryIkEa6zf+fKWNQtosxt69qfMHvYyeJfLkOpBCplRIhi4A+pm16Kn84en+HaITxIgeoPnphDoNJt2IsxPA3V9V3aqfx1zjg7qRNlFIaLcKm4+TUxzAI1PMgRlarucX0Iek73aeOG0Acy9RFUegv0oyi6RJgYTjTXkZ3X1m2nEgRZqdZTAkqloOqvalZtpAB1L4n68KSaMLhHVV99N3+xDNkIS/dakKeLIfUgucUvuhdrK1ReKQAG
 jGT/Thvg
 uvPgkHk235XOSNSezbvTy65c9PFY4el9OAwaDSpTT4bnEK2LQI028BPQy6zqimSZpHo2HX82U4cnKwcU4G6R0R91dCiJjPWMEmcECRr/IFZ3slXFQiLRMUBDw2aKkT8rT8Ru2pNHfZ1wz6Iw4POSiChFHLkJ8JiCn/Y42B9wcBn3XVCegDGWGQMB3JAYOyLlaxzG1WZfimjFQHvSlsQWsUaKu7xKHvWy3o/bevdqn9s+CMpamNWrYs2vL1fC0sibhoZF+qyjp20S67r/Md2XIJxQhJerFxI+C3tqT5en/dowRWVwYyf9o6BtY5sNy68ahOxoBf1BTlHUoiE/PNew5cqWjSHPXoidyYHl06OzDEPy9GM0K43+QYe9dgeYA/ORN0/in
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/26 10:35 PM, Harry Yoo wrote:
>=20
> Hi Dev,
>=20
> On 6/12/26 1:44 PM, Dev Jain wrote:
>> Introduce a boot option to tag only at allocation time of the objects.=
 This
>> reduces KASAN MTE overhead, the tradeoff being reduced ability of
>> catching bugs.
>=20
> I think most of overhead when enabling MTE comes from loading and
> validing tags for every memory access (either in SYNC or ASYNC mode),
> rather than from storing tags.

Is there any reason not to use STGM instead of STG + DC GVA when
setting/clearing tags for large sizes when we know they are properly
aligned?

>> Now, when a memory object will be freed, it will retain the random tag=
 it
>> had at allocation time. This compromises on catching UAF bugs, till th=
e
>> time the object is not reallocated, at which point it will have a new
>> random tag.
>>
>> Hence, not catching "use-after-free-before-reallocation" and not catch=
ing
>> "double-free" will be the compromise for reduced KASAN overhead.
>=20
> I doubt users who care about security enough to enable HW_TAGS KASAN
> are willing to compromise on security just to save a few instructions
> to store tags in the free path.
>=20
> To me, it looks like too much of a compromise on security for little
> performance gain.
>=20
>> This is an RFC because we are not clear about the performance benefit.=

>>
>> Android folks, please help with testing!
>>
>> ---
>> Applies on Linus master (9716c086c8e8).
>>
>> Dev Jain (2):
>>   kasan: hw_tags: Use KASAN_PAGE_REDZONE for vmalloc redzoning
>>   kasan: hw_tags: Add boot option to elide free time poisoning
>>
>>  Documentation/dev-tools/kasan.rst |  4 +++
>>  mm/kasan/hw_tags.c                | 45 +++++++++++++++++++++++++++++-=
-
>>  mm/kasan/kasan.h                  | 23 +++++++++++++++-
>>  3 files changed, 69 insertions(+), 3 deletions(-)
>>
>=20

--=20
Cheers,
Harry / Hyeonggon


