Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6C40C55162
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 06:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28726B007B; Mon,  3 Aug 2026 02:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED9026B008A; Mon,  3 Aug 2026 02:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF0396B0092; Mon,  3 Aug 2026 02:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF4AA6B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 02:46:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53D0B140632
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:46:44 +0000 (UTC)
X-FDA: 85059025128.15.4FECFE1
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C79540003
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 06:46:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P2oSw2dU;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785739602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UmJFN8HW2e7z7J1Q30SN59Y3ChlpGFjfWu2UBe0079g=;
	b=lf0RC1oQLsKV+B6QeEpHmH2Sx5T4exMyz1yzuLR1k4r1AJpy+UWXwUhnUSF2peUmvQGyVQ
	U4ahJRmE443kzzAIy6dvMeVNZIHOB9g6yD6Bj2T13SyMg3CrVMmKPNX6/pUDls2bPUVeqD
	IA+icc5j1tRwwCfw8aLcZm/o41jdm08=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P2oSw2dU;
	spf=pass (imf04.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785739602;
	b=5vvW/LxVcqJw51CfDse4KYpzE5A4bxsF84Ohe6y1V7N6kNuMrvausEElYIulgkD/GWhLtT
	LQkmH3cRq/lqz7OinBu7ItlrKarTrPd2DkA/TIGhrwPFAjazDccgoSlO8hs+dvQ7Rw94lZ
	TQgVYmlagEruzFmGRMPtsgwKJWHzdkU=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785739599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UmJFN8HW2e7z7J1Q30SN59Y3ChlpGFjfWu2UBe0079g=;
	b=P2oSw2dUQu9uGbTRjarEu8AV0+4aQVTiU9fcPvIOr06lAFspuSL2Jt+/d2+TbXxim1KHE/
	UhyAHtrSVFKq46YQo/wfu7sjattm+lTcumzjpsCLYqg/czVqwPHO5HSvut6YBZqkobnL2C
	vF39VbsfssqGE9Eb89JXaoRhC1zpnEk=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <anA3Z9XH-tuiwnNu@kernel.org>
Date: Mon, 3 Aug 2026 14:45:55 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4FB096F3-80EC-4FD3-B859-4AF3162AABB2@linux.dev>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-4-songmuchun@bytedance.com>
 <5005C7D3-B3ED-4C62-B611-8465D2BC69FD@linux.dev>
 <178540851830.2154539.6359871825839331816.b4-reply@b4>
 <3FCC8989-95DB-450F-95C3-183787DF4D08@linux.dev>
 <amtgdZ0U_UIbx_hI@kernel.org>
 <89878C33-9BCD-4FD7-92A0-884CF682CBF3@linux.dev>
 <anA3Z9XH-tuiwnNu@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C79540003
X-Stat-Signature: 4kmfsdq8u3g3fwzc61ky9jy1bpxrs8bk
X-HE-Tag: 1785739602-181427
X-HE-Meta: U2FsdGVkX1+mzv2l3L59Ev0ssWuTKPS4PR5yVi8SmZspxmYMFMwsAOAUTIw8pkraD/D1NLXEFWr7L1aOnV4xcKtbJLHTII6Mmj/Je4bp58xOtlKilYJFrQwyOnIa34Xc64NqsE9rLo4/4bs0x+ie1UeopLZgLM6QLMozunf5yqAqNWfZVa3AXUAD6w5oAwTzjo/toI/KQ+04A5Er0WKzkuLuCTiSJpb2j7j7o2iq2MRFjjZUKrraMUaN1teuhJoMg/qEHCDpdb74FgvqRDjzFGuGI6VzzrzpsIiCcOmFDZjgbJXOwSeKB+pX6RaPWSp4xsrWhyxMEkRGCnBIcrXYdLNPo7vsSoiN/FK6ONcxIvwL4lBWYUH3ehMf/QFHLVUnWlWZKmcBZ5tUTqWIMqueQikyodcc+QM1Fj4MvtD1j3nFL5RHcZk6fVtqhSd89YZIfIFNoGeCrZ5NwgeTu5zJ/3z77HJ9mtPFHjS9ykmFrf3rbvkBqPicu41oxPheHlP5lyugbiPT6HOqDuz9bbG5iAaxg/MwvYwD9z65IeqKWE6kjWPWx5B/YfYXKv7Y710sIdL90PWU+2MyzQmB8aYXPnewqsQvhHcFqrhMBe3gPS51a61Nx3IOWe9SCpARvSEredT0rlmTFrFZLQhxAUGT1otjfyCb88ooGdvuO+vJ2FQH7f6KgQ6adxELYZ5B0h2MPOhBuTX9GTJ9+iCCW+PVYjpYVockKoqrOkT+8IIwpvW7P0SJa7R+UGaJg7vQiT9QYCRyRLMWMi6jKnUtEc4hipU6acb1tXWcIq9NhSFy2ZUVtIzr6aLsaAFEmOERXjGcQzt6cXKbyuq4Wm2rm8Q1EnS0pC+trMQDIvWeOiQmGEDi9qqDupgHnLbrBxZD5QBZjsUi/+W5H3juA1o6DbiTL3GzhrD8jm93H0JURiEOj+Ilsd9f1KIx379vcG9jQpCk6DHlLDkHM39vKWBV1lm
 qXf3oenE
 Sg/RLXdJ5J2qHHnWXdkgH99wRhLuirshCK70uXmPsmv0/Vt3hhEfn44UdSo67ccRpxj4ZvxmtX8+XF3ZCdeA7yDw/deNgZ+PscrNhkccvUYuB+T4WGoCmct8YrQ1772xQIu3bLJsVBrj8bl8r+SVL7Kz9fb6EGoIunGQ2i600NqiYqemQkKby80pU33swrmzamcOPaypbcIQwX0EqLCvT9K2BeDxDCyXCHL2gjDsRizhIlC8l3ZdvsVlxDRN2GyXF1Y41TdPK4ZWmGgEffY+xZADWX8+4Ek446uI29+4Dspi8j+rfopQd4vIsHdHR1+eExe+EWZ5nqoXUggp6voQImegT2/01wPg7Oug+zxcYdT+p/HMz4xeJ3onKlHyY6L0zjGy8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Aug 3, 2026, at 14:38, Mike Rapoport <rppt@kernel.org> wrote:
>=20
> On Fri, Jul 31, 2026 at 10:13:43AM +0800, Muchun Song wrote:
>>> On Jul 30, 2026, at 22:32, Mike Rapoport <rppt@kernel.org> wrote:
>>>>=20
>>>> Since we also use __pfn_to_section in the patch 14 in this series =
for
>>>> !SPARSEMEM, we need to make corresponding =
adjustments=E2=80=94specifically, by using
>>>> pfn_to_section_order to determine whether the vmemmap of a given =
section is
>>>> optimizable. This new helper will be called from several places, so =
I'm afraid
>>>> its introduction is unavoidable.
>>>=20
>>> Do you mean that section_vmemmap_optimizable() will receive pfn as a
>>> parameter and use pfn_to_section_order() internally?
>>=20
>> I was originally planning to go with the this approach, but now I've =
come across
>> something that feels a bit unusual to me: a function whose name =
starts with section
>> takes a pfn as its argument instead of a mem_section.
>>=20
>> So I started thinking about an alternative. How about we keep =
section_vmemmap_optimizable()
>> as it is, but introduce a new helper like this:
>>=20
>> static inline bool order_vmemmap_optimizable(unsigned int order)
>> {
>> 	return order >=3D OPTIMIZABLE_FOLIO_MIN_ORDER;
>> }
>=20
> Maybe name it vmemmap_optimizable_order() so it'll belong to vmemmap
> namespace, order_ can be really a lot of things.

Make sense.

>=20
> I think it makes sense. Let's see how it fits in the end in the new
> version :)

I'll update it as soon as possible.

Muchun,
Thanks.

>=20
> --=20
> Sincerely yours,
> Mike.


