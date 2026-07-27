Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64AFBC531F9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 03:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 267486B007B; Sun, 26 Jul 2026 23:44:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0E06B0088; Sun, 26 Jul 2026 23:44:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8C06B008A; Sun, 26 Jul 2026 23:44:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35926B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 23:43:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2EDA1403FF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:43:58 +0000 (UTC)
X-FDA: 85033162956.14.0ACC793
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7099B10000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:43:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aRf46QzB;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785123837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJ8JOsuNS9FMz8gDaGLvGpLiuqBJLsoGeu7gSP3kDic=;
	b=HY4ntaVpf3qeQvHX5cn2NGXxdnCFajQ3pYCXtXPDlG9sCk7VdfIq3T5m7F6X4u281qQaLm
	FTNPhw61dLzUKpXF2E4MthEJgr0zYzSo7/dRGMeJwJt72sdVJyCccg+glOVc1zuRbvivMb
	GEv1SSSkmI7nAcqFU5rzdA+4gp8tT0s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785123837;
	b=Koi+CIUNgnHzw0fEgDIwvssDYZpjdVhbq2ojaYfBkHsQq30rgFvbr33zZNzJxbDf/tPrJv
	/xW2Xj9IKwvLswA2ypOV9/WFgmTUUpN+m+gMiDpjeYnRzmDw4ruXqBXKsNLdVGLwzlaPhQ
	kUlIsMxYGUWZ2mKpryhD6zkQ2HH3odU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aRf46QzB;
	spf=pass (imf05.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785123834;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TJ8JOsuNS9FMz8gDaGLvGpLiuqBJLsoGeu7gSP3kDic=;
	b=aRf46QzBuKyHK/EkkiGdLyqu3uYLO/+lJA2GEDL1PfdcBnFNIg1VpQoyyJOnJaFRz3YSba
	fkneCqeuAliZ5vn0sVTXpPF6Y5NRRSVUsjamfFhcO/DMRsPftOu9WOtC8Cx77uIWmet/RB
	TdRx9ZazWk2gsfdKm7lB6eFaIox1tuo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4 16/21] mm/mm_init: simplify deferred_free_pages()
 migratetype init
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260726202522.e55861cc87fc3e0c6d030e1f@linux-foundation.org>
Date: Mon, 27 Jul 2026 11:43:31 +0800
Cc: Mike Rapoport <rppt@kernel.org>,
 Pratyush Yadav <pratyush@kernel.org>,
 David Hildenbrand <david@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Alexander Graf <graf@amazon.com>,
 Oscar Salvador <osalvador@suse.de>,
 Jason Miu <jasonmiu@google.com>,
 Jork Loeser <jloeser@linux.microsoft.com>,
 kexec@lists.infradead.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <92E24479-07A8-4998-9607-87420A8BE04E@linux.dev>
References: <20260725172133.4018491-1-pratyush@kernel.org>
 <20260725172133.4018491-17-pratyush@kernel.org> <amXelr2DcRRyZDY4@kernel.org>
 <20260726202522.e55861cc87fc3e0c6d030e1f@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7099B10000A
X-Stat-Signature: 7h6ydkwifppiq8wwurzyi4c4m83tymws
X-HE-Tag: 1785123836-394572
X-HE-Meta: U2FsdGVkX1/ojul2aEcAEg1lp5beAgN0Tt+ledly9MPF94MzMRzqv2dpHhvux4tjhGqG6bQbW8aHJML4w7kUWDf1Lk3vYhksslKtolJp9/wVzSUC4Z8pqbkY8ae55YVKvS5Cd37WXPFnPO7oITrcfFOCo8TDtdkdsGjJN/RyN86FtvJYXdVnkCJRuVc1snut0M/jP5Nn/+CK7dgJKxVEPedt1uU7OLDEYml9ftIKZqLlJVEARbeFUsFFBFbnmpZoFgvVARE5dD6VQPz3cPN8wu+gKOsumR/IMBqHRTKI7dq8k9/uSFnl7+6bWDOZ5dM30jkn0vrVCxGdVZAYpUniiSmCi1ocv98Yj31um0MbE0WMhVgnZdjw+niPRtDrSMchbVN5QOuQThUjxzJSngBDzr0t8jB37XLlYjroRH0/t10G/KO4JyqIFCbMc+6OOnq836O0AI801+qMXzZUPDBVPrJNGVPabjC2mecjlFFuU68luBUhhtZIk0T1OjCw568lf0h6/n9xeoIX0b4vcMEWglTbnJCGSRiw336TBgg9OCieUl0BXAU/MvlVuKW8chCH5ftGB023pgH7jtzjRkf3jHuX/9/UvqgS/triYykiuGvikoW9ez7axy2dOwgUbub+HxGOVGRVx5iYVE4kW3LFUjFrNU8Ovh9qBzWqNaAah64El3XLheRHHbjKHTWmb++q8rJMRFTSJf6CgXiz12DVH7KsbtGyIjgsveBH0aJ0D0ZygBny145IEiBH0qQhdZ2EEhRRVzE4dlpY4S9z31hjwEqQknIYYV3tWM/yn86a2xFxY80s2GS/qjEE4+mBiCQ9WbhFs+nzJ1DNRgidaOoAZMl4D7MZeYvb5RucpPQ398/APHsCYpNHKWfX2LrPOSZInalyRGkWVkTc/t8E2LE8d+8QjjfQjteXiaBl9eHJPudIW6KbJRaL4FUs8qdtnMsLtm+zwmjfZt5OCX9l3s4
 eXXerVEK
 U4/3+ETZX2O7OlVJBlo9mt6l3EvDjEB1DgXo0WaIQISmx6PshOXNxnJyvD9640ryqAHcqUJAwBPeOD6lZ822khtEuRDwsxjYPIYRK9WvzXgPOGQ3l3uY78pIXp/XAfp2NNm5Qn8yazRDAtlh7bJJy4Y6fszUEPm3AT6jLPaf/cVDkjaL4PzrqwL8ZieiHrqWptJ79fbmEEbp9HBSrQbpzNFWFtioFYuqv+57JK5XejZX2yKtnYhSOH5v1c4ZSaWTadctKd/XTRbOCbrld10GhoWOuII60xscwcwcUhANhml83AsBgro7wRNph+mi64FYWSxyq65q8cOi+jhbkm6zxFgD8AJgNKEF4k9K2bb7fk21LnIk4LXXSxKpMYqrepnmzKIQNHqosQulNv3s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 27, 2026, at 11:25, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Sun, 26 Jul 2026 13:16:54 +0300 Mike Rapoport <rppt@kernel.org> =
wrote:
>=20
>> On Sat, Jul 25, 2026 at 07:21:16PM +0200, Pratyush Yadav wrote:
>>> From: Muchun Song <songmuchun@bytedance.com>
>>>=20
>>> deferred_free_pages() open-codes two loops to initialize the =
pageblock
>>> migratetype for a range of pages.
>>>=20
>>> Replace them with pageblock_migratetype_init_range() to remove the
>>> duplication and make the code clearer (Note that =
deferred_free_pages() may
>>> be called from atomic context).
>>>=20
>>> Link: =
https://lore.kernel.org/20260612035903.2468601-6-songmuchun@bytedance.com
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Acked-by: Oscar Salvador <osalvador@suse.de>
>>> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>>> ---
>>>=20
>>> Notes:
>>>    This patch is taken from Muchun's series [0]. The patch as of =
today is
>>>    in mm-unstable.
>>=20
>> @Andrew,
>>=20
>> It looks like it'll take some time for this patch to get into =
mm-stable so
>> we can't base this work on a branch in the mm tree :(
>=20
> I didn't know anyone was using mm-stable :(
>=20
> Series is adequately reviewed and is near head-of-queue so I can move
> it into mm-stable a few days hence if that helps?
>=20
>> I'd like to expose the KHO scratch extension to linux-next ASAP so =
I'm
>> inclined to take this patch as a part of this series and live for a =
while
>> with a duplicated commit in linux-next. Once this patch would be in
>> mm-stable we can rebase kho-scratch work on top of mm-stable and =
hopefully
>> there will be enough time for it to live in linux-next so that Linus =
won't
>> get angry at us :)=20
>>=20
>> How does that sound to you?
>=20
> That's fine - let me know what you choose to do and I'll adapt to it.
>=20
> An unknown (to me) is whether Muchun's series "mm: Refactor bootmem
> gigantic hugepage allocation, v4" still works with this patch removed. =
 Everything
> applies OK for what that's worth.

Hi Andrew,

I'd like to confirm that this is a completely independent cleanup patch,
so it can be merged on its own.

Thanks.



