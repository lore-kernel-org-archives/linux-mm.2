Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B40C9C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 13:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EB8F6B009F; Fri, 18 Sep 2026 09:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99C156B00A0; Fri, 18 Sep 2026 09:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 863236B00A1; Fri, 18 Sep 2026 09:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5070D6B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:56:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C387914067C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:56:31 +0000 (UTC)
X-FDA: 85227032982.13.5C4DA59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1865AA0007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:56:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4sAr6dP;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZuINOgIYdXZ7CoiI7b9VU6AZ0chpvWCI88yL/yx55g=;
	b=TSmNauyPaoxh/SfBZdFfiIxFzABOLHd9AGjUTIH/2DlYLQhI0tnSNURPwi/hAiJrP+gsY5
	5ZzTxjgse4SWchWuxG14u6MViQYTkSPhJGrCekseBTux1oBJMRV/y6sCt+8wEUC4dzipbo
	PbmgPno4nRidcw8FFHOzi5KdX6Sgvwk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739790;
	b=oSRCCcmQo7cw5jl7ZGtejZ4XGFZ4PKxn+LutVOMT1ggjnwD7/Y2vLaRaK3eSTf3DF2pXo1
	pQH7gQaNTRRAdxEsbKKTZDJKWuga8EFIOL4GlRA36xd0rfdWYz4OM1GSfwt2ik4XyVpUWr
	I5uJ038s+R2K2gbiF9FKz/SQgt1FmIY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k4sAr6dP;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8716F601EF;
	Fri, 18 Sep 2026 13:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B271F000FF;
	Fri, 18 Sep 2026 13:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739789;
	bh=0ZuINOgIYdXZ7CoiI7b9VU6AZ0chpvWCI88yL/yx55g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k4sAr6dPsqiyTk0/15pahtsBHBjcocBzXe5pKOeFdRacaUJ6of152qfOnqPw2kqMJ
	 Ark3QNerW0do1ParE4qyXNXDkxmYNiPCt4SW4PWJwHOmjgo/V9jCPmxfq3rnLuJxoh
	 9e4Mj0fu0Ss3JthALME7WPuYcrSy7AKGW+Fo/dmgPcUrNdzTuCHqd+NjJCayX6F5y3
	 fq8LstdKeCCiDbxrw+F9pR80i770n4jyDfbGziPy8B05cggK4ysqobocbzDMYon+Ad
	 gc4K6J/PsmeA6TbOX12K2mhwh8pnK6i6uteHToeV4x/syx+OHoKfutWQ+8LP+SS/z+
	 1PJ1IeFloXSog==
Message-ID: <97dbf242-fe4c-43a2-81dd-80a747831a8a@kernel.org>
Date: Fri, 18 Sep 2026 15:56:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] mm: support promotion-only NUMA hinting scans
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
 hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-2-gourry@gourry.net>
 <9b5e1573-6fd8-48a5-a274-a6e7ff83d2fe@kernel.org>
 <aq08OIJ5mCnDVIfs@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aq08OIJ5mCnDVIfs@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 38y11s6s4w3ckpho9cydbr9ks9szqd5o
X-Rspam-User: 
X-Rspamd-Queue-Id: 1865AA0007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789739789-958155
X-HE-Meta: U2FsdGVkX1+5arqpMWXQ08Vxe1/V1MzN4ZyfPM2CstS+mY6po+qnHpHilCErYLXnuP1azy+DvdtXqPgWQelJvOMGdx9urKBOCYETA+9d6T17Zd4/lf8AeEk1q+ow9NwMny4GhtLQ9oQMhY2CnUtHmckVQpNZ9fcF37qvpPRaIYpcIfbhtqiweqtG6+7AZm3hOi0nxvhnMJg3B1PD4b6GPCdjQxiHAwFFzRRIwATe9V0Uxx2tMH3gud0V9w27IJCCTjDxnN5pabV0i2Cn8FhQPPUKPxAUXNOA2cZqb9l/lUEJT9ssRdugbrsrfVHJuuQgDWGiepbrvzqnyY0MjNTKAhEr5yRCf+73WokdqLXsdzqMw0xovbNgDRO7sdw3VWaNBYLm1woX/vuH8EbxZS5CdWTO1/YbuezjBfbMvVzQpRFoAZkEmnoKu1YndUFa6tTpDc9guN1QAv8C3aca7/ztXGVSM/rBOgm8RVisr7AsZAhmzgvDrDu9HON/T62KwDOuPe/eK7Yd6GX2hHlNcInSZaHmdl4Tu2z8WuaEhxRDFUUGNUMjW+a48R4zsAmgUkIpnikkF870Q1GEIdpH/semOxHkDrPo4eVuk41BmKIkAlGEINYiab9RdkkBVcoVV5ug/943hkgGUfb47TCeB+Srk7hOdBEE1eob/D+HkKE62ynhYdYUkZHEeVzolCO6enwnxPeOeSoV2biLLGTOEcOQiyzU4IhBs0vVHvXa3VIaotNvg5vKsmDil2aUhIrKRB+rgJj9fGw8cqsfKw1hi6ykyIy/ibVS206zZlLDUMHtdtf12kggE4GDPJYWSu9C5kJZp9RqXcd9mxygoIATRtHwdGN8YNSQ36ZWBk0KywtKlon3CnWVpD/QCzvABj6p8sZKI9fBL1dpUltXN/uGlTsY5TFpQ5SifAF+VCzqyuFf963a5cROS2GVUa2dFEuAb4+5GRBG+Y1C6w4FjQKDvn5
 HkbRIywb
 TiM0a7URe9/oGqkNuDn2sfi8Xfg9kIyNoaZ9OwkgVw8lSxvRaLXT25ERWmMtBKhilWSUidUUR714nKEukfu0iL4goTUHC38E7f1M8Qn9S6NdtCNvIKc+IAEL6QxyVCRneAlRty1XIOIggCHC5yZtpDzeDsQTtxIxsuT5cot/w2mIn4rDV3sZ1PrXxp29m42pD3nzDYr1K/15Eif+WnmMWviOD+y2MAPHoa/j8WilWPY3SwqHcgp53oJyt7BGwq5YkXiHOnPa6mFc/C6WHCS08HDQWP7aCue5klaf9xIymuX2T6pBRhZBUUQemJJz6VlEJtu7CPySIFrPZRGw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 15:46, Gregory Price wrote:
> On Fri, Sep 18, 2026 at 02:37:52PM +0200, David Hildenbrand (Arm) wrote:
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 969594074fd2..2d1b59a27629 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -3408,6 +3408,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
>>>  #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
>>>  #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
>>>  					    MM_CP_UFFD_RWP_RESOLVE)
>>> +/* Whether a MM_CP_PROT_NUMA change is for promotion only */
>>> +#define  MM_CP_PROT_NUMA_PROMO_ONLY        (1UL << 6)
>>
>> BTW, shouldn't we just be using BIT()?
>>
> 
> I originally had a 5th patch to convert it, but i dropped it while
> making multiple attempts to avoid a CP bit at all.
> 
> I can add it back to the end of the series if you like.

Should be a nice and simple cleanup.

> 
>>> +		promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);
>>
>> bool promo_only = !(numab_mode & NUMA_BALANCING_NORMAL);
>>
>>
>> and in the later patch
>>
>> if (vma_is_ro_file(vma))
>> 	promo_only = true;
>>
>> ?
> 
> Yeah this is confusing, but it is correct.
> 
> 1) If we're in the code at all, balancing was on at some point.
> 
> 2) If !NORMAL - then TIERING must have been set - so always true
>    (promo_only says: only PROT_NONE low-tier folios)
> 
> 3) In (NORMAL | TIERING) mode.  promo_only = !NORMAL = false
>    (so in numab=3 - we PROT_NONE top-tier folios)
> 
> 4) But this causes socket-to-socket bouncing when (NORMAL) is set
>    so we retain the "no R/O file" filter by checking it and setting
>    the promo_only filter back it.
> 
> It is, decidedly, quite awful.
> 
> But the problem isn't the fix - the introduction of the R/O filter broke
> TIERING first.  The problem is that these filters never took both modes
> (NORMAL, TIERING) into account in the first place.  They optimized for
> NORMAL and broke TIERING.
> 
>>
>> Stupid question: why can't/shouldn't change_prot_numa() query
>> sysctl_numa_balancing_mode? Why do we have to query this outside of the function
>> and forward it?
>>
> 
> We need to calculate it anyway for patch #4 to track when the last full
> vma scan occurred in numab=3 mode.

Given that that code is rather messy, I wonder if it can be cleaned up in a way
that would require us to avoid this.

> 
> We certainly can, but then we calculate it twice in the stack and it can
> change out from under us.  I didn't want to have to think about that
> split-state problem, so I err'd on the side of calculate-once and do the
> whole operation based on that state.

Maybe forwarding whether the VMA was accessed could end up cleaner. But yeah, it
depends on how patch #4 will end up.

> 
> I'll need to pull up some investigation notes, but I also remember there
> being a situation where checking it underneath this caused more scanning
> work - didn't want to regress anyone. This might be resolved by patch #4.
> 
>> I mean, change_prot_numa() gets the vma and can query
>> sysctl_numa_balancing_mode. Why not move that into the function and avoid the
>> boolean parameter?
-- 
Cheers,

David

