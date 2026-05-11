Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F4DCCD37BE
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:54:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C7696B0099; Mon, 11 May 2026 08:54:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776D96B00A4; Mon, 11 May 2026 08:54:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68DC66B00A8; Mon, 11 May 2026 08:54:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 58C7E6B0099
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:54:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07B4A16071F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:54:42 +0000 (UTC)
X-FDA: 84755133204.14.F96DAD6
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id E684D180005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:54:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sbpqbv2C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778504080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yU4WyVP1Mc1o29qOhDo9PXkBl2LW5fnvyjnZvXOiIOw=;
	b=VW+L5UIsFVKXOivPBVcCZKDEyjSZrhwg/G5IHPfWE5dyaAj4ukv3iyEDwHmpSVsSDwK4r+
	AGOCpX7lIW+f9OXlZkJOXjlb/8SbbaR+4y7YpOJYKDaLphI1Y2DW05W0+NI8fNqV0H4gFw
	OVQP4fOpQfIjH5+dr0hgQRT9QwMp5i0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778504080; a=rsa-sha256;
	cv=none;
	b=CP9H3rbp/cESG99i3LGriy26/HxhXacOzwZzzuCLjqs31gfdHVaXdxMq9l2yX8FhhnnFsn
	sUvWS5/w5JQeQqJOQxZQjhc5KBnS2YR+pSxv6UxX/UDqhDniqToqoRY2t93QNuLjoTQPer
	hcT+GfXq/xXu5La1OWJaBgjg+5Xcl9A=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sbpqbv2C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778504077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yU4WyVP1Mc1o29qOhDo9PXkBl2LW5fnvyjnZvXOiIOw=;
	b=sbpqbv2ClrNkenLof3b/K8Xm89e1ShzTAaIfv0wK1jWc3QJ5YghHk4dpAwaILFARP5zrLW
	vaoat63FrYTYxVbkC+5RlEFHs/NDJkii+HE0cOwHg2uTGl8SD8znKycZKfzsFgIaur5KqU
	e0mFOGJ2BAJBvHnjSPPPlPxvd6o9Kh0=
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] mm/page_alloc: Fix zone reserve update serialization
Date: Mon, 11 May 2026 20:53:56 +0800
Message-Id: <53EC8695-885F-4C47-A9E9-89CCF963F0F3@linux.dev>
References: <agHMhEBAz9sol3TP@tiehlicka>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 zihan zhou <15645113830zzh@gmail.com>, yaowenchao <yaowenchao@jd.com>,
 linux-kernel@vger.kernel.org
In-Reply-To: <agHMhEBAz9sol3TP@tiehlicka>
To: Michal Hocko <mhocko@suse.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E684D180005
X-Stat-Signature: mqke31yp8bryoh8gowjkjqoocbu9c91o
X-Rspam-User: 
X-HE-Tag: 1778504079-649003
X-HE-Meta: U2FsdGVkX1/7d75OcUgcXA5gFw6a+KWEMALpSLjmPpBmSSeHTykCv4HLjNjGlDIbaMu/xbQKKRbxPJzvrqo6QT2DBK+WwNOdN+URGqdcV27PzgYtcOucjBr5E4y/lIOR+uoZOclu0pIl0b5TKDE7IdFAUELcLaD+eKUnt6IWnOAZcQV6mWvL/UaF4RpGY07uqQQzEbeqZf7/JdJXrbhI936uFOcoMekUQu+ULZH3EHgO8IvNhN3JcEu2BcnYoXsl6zmwa80DEnxKNWV/nFB5z4MquExGYmHRuvX8WEWYWaelHyepxduAuYp02V8MD0IC6dR94xbIRevGAeZP9HbSeByBpePLjRVIWsNESMcoSwsWjaZMbALS8NUofRr3lRz15OqGw4rr3N/BEpcY0I2h56Df3IUyPeUZuDfspJ+KA+HjdW4farZcxgn6Xqt81H31/EhjM1mRNrHLqIApxeorAoPNxku+E3gDqh7FEtRR+eKaSrm2XvyeCXDthpec9ZG6/0ikYgcBCvuty3b1O+1heiz6H4vIF5PJ2Rkt9fG5PBuc0WhbFb4fiYsPA3WftQ31b1CI4lY8fce3WRPxxYZbCuV/3uBfPRtQyGykG/35tO/k0+F9pRezL9wT9RjIX5BcJ06k1S3TsrgbUVvyYjUVmqaYfhBbapflSEjwNyvWoH/SFlaAArE6NV1OMxP/yeMGexAFOc40oQDrTKiLyvQGdklUByxW0YUFpKf/E5AMRHO0zVZ/kHy+wfOWdsDiAtg/NSpCw12ibpi99V/2DVeh5t2PgzRTJxHLluldTOK3aNZAvp8tGsjWMeBEFZxEyPyjFNhgsZD9eyu6MQbZ9VLr0/Rd7yaLquiNY9Y2tnsNFooi27Hde0F1ddeegs9hd6fdRQykmU3nXHygTTMEkX9RoMVZCtHb7957BoyiRRsGl4mIyLLKAY0H7ZzJuAdYuWqmobVE3zUSouKWgTnZHKu
 YYrl24yj
 90jgBWoz1HLdh4+7BwQV3OD4oLOLizQ3J+aCDo07TuohOBrxmtUe29dnbUjopbBg/edPrywlJE9dgcT1I3wR8jB5ioWlKglEBFJj7jX9ZTUENyF4dhz18JKR7IcAzVTglcGXX0wzIA/8hVOjooFJ+Ql+H9/k8ice4K0GqMieG4lz1i8FakNkXyz+SU31tGTFA1P3kUuOfTETB8w0+Is2neHftlcs1TRfhIKSoGR6ldZyqDZYHJHa8RKsyAFjMglAY8kVT5WkpShaONZeIXUln/uYnffkjKRaY2ew4Fc+d50BrjmmVR8ZXLoxSUAAQQFJ0XoC8jWWUlRkDvC0FmaAROijhPToy6cafgaO2YvCK3NXB3ik=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On May 11, 2026, at 20:33, Michal Hocko <mhocko@suse.com> wrote:
>=20
> =EF=BB=BFOn Mon 11-05-26 20:04:09, Muchun Song wrote:
>> Serialize lowmem reserve and watermark updates with the same lock so
>> calculate_totalreserve_pages() cannot observe partially updated zone
>> reserve state.
>=20
> Could you describe the problem you are facing?

To be more precise, commit 9726891fe753 moved=20
the call to setup_per_zone_lowmem_reserve into=20
adjust_managed_page_count. Since adjust_managed_page_count
can be executed concurrently across multiple CPUs=20
(especially during memory hotplug or parallel initialization),
I am concerned that this might lead to inconsistent updates for
the following counters:

    zone->lowmem_reserve
    pgdat->totalreserve_pages
    The global totalreserve_pages

If these updates are not atomic or properly synchronized,
the resulting values could be inaccurate. This inconsistency
might cause issues for other kernel subsystems that rely on
these reserve counts for memory allocation and reclamation
decisions.

Just to clarify, I noticed this potential issue while reviewing
the source code; it is not a bug I have encountered in a production
environment yet.

Thanks,
Muchun
>=20
>> Fixes: 9726891fe753 ("mm: page_alloc: fix missed updates of lowmem_reserv=
e in adjust_managed_page_count")
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/page_alloc.c | 10 ++++++----
>> 1 file changed, 6 insertions(+), 4 deletions(-)
>>=20
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 3a56825a7fc5..0989067da588 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -6384,6 +6384,8 @@ static void calculate_totalreserve_pages(void)
>>    trace_mm_calculate_totalreserve_pages(totalreserve_pages);
>> }
>>=20
>> +static DEFINE_SPINLOCK(zone_reserve_lock);
>> +
>> /*
>>  * setup_per_zone_lowmem_reserve - called whenever
>>  *    sysctl_lowmem_reserve_ratio changes.  Ensures that each zone
>> @@ -6394,6 +6396,8 @@ static void setup_per_zone_lowmem_reserve(void)
>> {
>>    struct pglist_data *pgdat;
>>    enum zone_type i, j;
>> +
>> +    guard(spinlock_irqsave)(&zone_reserve_lock);
>>    /*
>>     * For a given zone node_zones[i], lowmem_reserve[j] (j > i)
>>     * represents how many pages in zone i must effectively be kept
>> @@ -6509,11 +6513,9 @@ static void __setup_per_zone_wmarks(void)
>> void setup_per_zone_wmarks(void)
>> {
>>    struct zone *zone;
>> -    static DEFINE_SPINLOCK(lock);
>>=20
>> -    spin_lock(&lock);
>> -    __setup_per_zone_wmarks();
>> -    spin_unlock(&lock);
>> +    scoped_guard(spinlock_irqsave, &zone_reserve_lock)
>> +        __setup_per_zone_wmarks();
>>=20
>>    /*
>>     * The watermark size have changed so update the pcpu batch
>>=20
>> base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
>> --
>> 2.54.0
>=20
> --
> Michal Hocko
> SUSE Labs

