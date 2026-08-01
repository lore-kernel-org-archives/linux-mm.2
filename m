Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 430E7C5516F
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 01:00:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC2F6B0088; Fri, 31 Jul 2026 21:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AC936B008A; Fri, 31 Jul 2026 21:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F040C6B0092; Fri, 31 Jul 2026 21:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9566E6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:00:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F181801D6
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 01:00:02 +0000 (UTC)
X-FDA: 85050893844.16.703BA9B
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3D04A40008
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 01:00:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AdIqergR;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785546000;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1kBDM70IBvvYkk/+MFqrnirdBa212qXnM+40/RiAlg=;
	b=7797LIZoL52NnZunSYUpp7HT71cwjpJdRZHMwcXhG6a/xSbK2fG/yo3sChIG+18UuxPITT
	cQ+NL9t1G1mVpQEmCJmuxaiyzyUD+VJWuGVrq9xteyiO1sbn2epVHxjxk0s5HTsfnFuNC+
	0zOBLHOzuW5FEU6fCRlxPhkjmxcqjyQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AdIqergR;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785546000;
	b=y+rGGVazket1vf5dXjYVuhI5DfEoiyKpTCMsoCk7Tn/uPtj6ArKCb/1kgk63zVer46vbnf
	gT5oehHcNFAi4tKlncYxC5yDFxEcgp6xM6YfWuF6PKE4EQdJIfEnr0Ha88dG74liDAIRZt
	/GgdW3pvghdsb7WNlnEgfJsKcUzW8ZU=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-698acd36d67so2865885a12.0
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785545999; x=1786150799; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=a1kBDM70IBvvYkk/+MFqrnirdBa212qXnM+40/RiAlg=;
        b=AdIqergRj+0C9LeX9OOT8a6kRIToGx73RpNYxpIDq3owkDTtfJLpuOZQyDEjRjfHuS
         Ej17frZIm37qG10RhaYTfVFjczOb2mIH8An+X01/xWuKyIXmeu3ihIQvqav57ONnSvcr
         pi5UhvNogYFlkBRk5nr2hHb6tW9YRlXvKg78oZelHiteBIT0ZVnoWIlXMIJXYLKtfuP2
         KmKiT2a6P7YChnnRLCLfVJFTSZFAOIpwf1KTFBdxJn6yn6noDhYO3f8u9elRfYb0WrsX
         6awtoY0jlfJrwCvPV9C2b4Ny04r+o2WUYbIlb+DgEg5HF2yxu/5qNZh5pT2FffDzWWFa
         eN8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785545999; x=1786150799;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:reply-to:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=a1kBDM70IBvvYkk/+MFqrnirdBa212qXnM+40/RiAlg=;
        b=X380L4rE8ZCWlhsDpJFkcsyzcL0VoXqo5J5zBhOtIs7klFVOr9+tgVVT7SITIoFeu6
         I0iSEZ9pQonXfRjCh5CsD1Qi4S4uM81YPehBCqtZUemfwzc5D6k6oXEV1dC6mGR0Y/6U
         gusWBN6F3lIgGmD8w1guNbv6M3xbkpb1eNDJg+1Egg6G4Z7oRBVKgm35yLol6ouDvSkT
         8o8jJ8FK+/nEVHPqZH2GB1puWTzgqneO5Jnmj4osAPQrQjfnlBbhwbkK7TBzz5dUk4zp
         1OXB1ym9j+pRVcy/NKl7KUEDoBjGxRbOJibqAhokwKuYxc1wdYm2JjhdlzAP+7UXS21p
         vBrA==
X-Forwarded-Encrypted: i=1; AHgh+Ro/nL/7z4CYJnd2PajXHWcv9BUpsrjT2N9Amv5eJ70IBKnZQVFyP68IsC+T1MWoPEq0QkHPSHsW7A==@kvack.org
X-Gm-Message-State: AOJu0YzurapbDGAMkHA0odsXVK2VZf9VaplQn6GFTx3qxtESUy4VkE/x
	QY/iXCVJLhGZ+J9FC1KDQ4/elLJayYOAIhumIvdeagmdFOozFXtbiAUY
X-Gm-Gg: AR+sD11eJGocXio6wZMMd84lr4ItnlWJKbllDNn472DO2niofQoRtQjJryjgFKsfxt8
	cnI+2jJ1UzXZPAKBnnKjMHyS+dnBifkESW8tLB4RRnQIqES02ZkrYaCRETn0shJTF9aMeZUPShz
	fst4QRPM6zEQANx1D81zPX9nTm4W6nUfkivY7/jNSX7LMqeskLhlW+NrgG4jRWyX5z0pwY7ILji
	SX5NHSnlZstZ2xgynfHyWxQeLGDapIDqqE0Sj103u78nW1ATQ2jSwbBkyWa/f64uT/42Ar0sndl
	SIikHem7M29yGYHQX4Sn95J8KykexXQQYHKD1f6k0Lrx1G34NaOf02yUlAZEoXwECJv+UQrldfz
	fkEcrM9pvH24yAYjkO5+y7YV6VqxzM8jg3d8fNDyP0wtYp3B64jRV0pcxVUGbRWZFpK/Y/7QeNL
	lxNJKSjCzYJUvSDGAAmQB5ljAqMlPQ30JRVZ/GI8arID4TSIjJknowQeeAxH0=
X-Received: by 2002:a17:906:6bc8:b0:c15:f4aa:f30e with SMTP id a640c23a62f3a-c1fe816e548mr71943466b.37.1785545998452;
        Fri, 31 Jul 2026 17:59:58 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd455ab7dsm270629066b.58.2026.07.31.17.59.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Jul 2026 17:59:57 -0700 (PDT)
Date: Sat, 1 Aug 2026 00:59:56 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Liu, Yuan1" <yuan1.liu@intel.com>
Cc: Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"Zou, Nanhai" <nanhai.zou@intel.com>,
	"Deng, Pan" <pan.deng@intel.com>,
	"Li, Tianyou" <tianyou.li@intel.com>,
	Chen Zhang <zhangchen.kidd@jd.com>,
	"Zeng, Jason" <jason.zeng@intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
 subsection boundary checks
Message-ID: <20260801005956.6twsbk6cergenv57@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-3-yuan1.liu@intel.com>
 <20260725024952.65lfm2s676obpoue@master>
 <MW4PR11MB6936598686BD5FA7B2FE9181A3CC2@MW4PR11MB6936.namprd11.prod.outlook.com>
 <20260730023614.fasdjzfl5wz4tsfr@master>
 <MW4PR11MB693678FB9ACF5B0014F32803A3C92@MW4PR11MB6936.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MW4PR11MB693678FB9ACF5B0014F32803A3C92@MW4PR11MB6936.namprd11.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3D04A40008
X-Stat-Signature: y861ac8pyejtfntqm7j6pniixh1i4thd
X-HE-Tag: 1785546000-368391
X-HE-Meta: U2FsdGVkX1+Oqr9zMWVqhXnd6Q3fOp7dTabENjUF7d8jEIe4D2GQ7k/IYaagprHlaWQTHhqp6H3Hu6vcYURiehkTZHgtmW5o7urj4xZr7KX/axgWXRq1ANvlSr/alGghPx9I1mvkZFwl1VMpT4LxzOdivq7C1upZQfa8PaO6AAA+YhsGDyeP2dBPTg+xO9joxXDsgArHpav8gb2uRpZzkd3dtHhQj3Sam3E/NnCnBBdjGF6I9GJ0EoquA8qKJBcpYNXrRzI4ld5tovvjfb7+VbDl+d+G+CKWwc4p9f8L+O1d4R5gPTvuVrDTyM9W+U3FvUzuNf2CMPXAgqsEatSuzUAgkHTGsIE085azUvClm5BLv1x7RelduQU0/WZ+aC8OCWsGYW5vGE4hmVCSYt+hg6U4hI07nIXsfp/Kah9S1qRW6WQNfcjUpTKV1MWJfK2u9C5kMGUpH4jwTH/eS0TY7uOTtcdvWjv+Yel0AtlZNVUSDN5G1eR+fhqvpR7aWl5OeWQDM2xN7wYzL8+68Sf9Oh6NUv6eNJFmhp2BIAUKb3nH1V3qAjnI6IHipxLCAcMwWlXHbhxNl6cu+tf0RfbLXfIHTrYDQzhYm/7iYznVQvJAbLIJWypWvRzJ3oMqiFRqkfayzA0Q/IRCCl+bfp19Icy+BMWXcVo0aWbVWw2nndaJdZdaHJerFrhS1KkxokA2xlJCtbf4mI7UBsNaRp5aPXwos+QaUJCrBNkBEXOqJ7uh/ni/nhL0L2Wywhke6+MYW1ei6QBLAUSqNQLgY4D7z7rmRh703QBAH3f8X9uUj/YnqNjiUUu4ntSAsqDufgYyEURA15SCGC0K+nyfWOj/P9nvtoxfvU7a6+/W9ZmuqyhqQ5OtiNgcFKMgFZ83oCDML66JSIrD5GmHPbLFdwK8gmRSneofjKb7EGCybpt84K2Kfj1cnucswMM3DRjFGrbMPSMdj6M3FJIxh2v97V2
 WkajyBOb
 ClFwQBUbLL541KZ/yDiuLGc3rG/OPMsTMSbTLY1s+rs96K4BDCBZ6RaDYP+pztUs7/i8pZOkFAQpebSZMctA/yQFhBJZTLkwvacXQcwwaWGHUp1zwMmqyB+wfCPTyLLf0e96xbG70TqwfDiVbBX0HxjMJVKFRASh5sw1tGEYOyDSagTPII6vNh4Vz/robKzCWidZBSsqFHIAxNgghPSxI0ZNImJROgwI8XpqSzrLdJsSzON7GeJFWcovqgvyra0g409A7TP0QV8IBimoy7ykSXsF3Vo9Eu8SARH5Vlt6sUlohPHaspnd/wYj7BJmnM31ctnzQwecHNSSD0b5bObCOEPXbLAppoZ+yHOD8GH/K6guSuiT+w3VfADnwN7Qn3r7y6R/04RXY140DWGBmeR4udAU/JrUU+Ncl2+Nc8yKhVha+EpEJqxmny32iprN2FYOX0OxyzB2CNqzKdCV/rxgbeA0k+5fzgY4AfZZiwcOhT4XPDI6M6s5bwlFdI1G0DIlpINg2cuWVGoekAGQhC98Q6o+3id4Ms9WANyi12xwENeVfZp7nIUgIQTisZUaC79Uc5i7nBgN1eAahCaQvu1TysPx6uL+kHKS3CzZY9b5fqAxBBVQvcNh30SG6X+fWoteUytUTRkNQTAkWCcn6Q72iJMhgj5W0FnxG2eQ8FABxWQzDjrnYlOcu9Wbzm9x+oF0fRT0f93bDuilnHlLuy/+1RlipPd1HZJ5pEioiYoS3lNcSjs2by1bbMA8z6jyACtdPLQ9cPTwJEKRS+n8wC+Vu8xJnDvZEGwkvgrj+VMfHoQ/viGOpMMvTXm8IVSWv5rc4LYQ6Wb7lHxP79Ix+Kwa9DT7cD/q/flHOnRDQlBnZ+vxDUzPm4nEO9aXI67U2cbIjSBU7yt7Fj+OyLBmGfXzdcbOHmUqPh81tDP77Kzl6Wl89k8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 07:57:13AM +0000, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: Wei Yang <richard.weiyang@gmail.com>
>> Sent: Thursday, July 30, 2026 10:36 AM
>> To: Liu, Yuan1 <yuan1.liu@intel.com>
>> Cc: Wei Yang <richard.weiyang@gmail.com>; David Hildenbrand
>> <david@kernel.org>; Oscar Salvador <osalvador@suse.de>; Mike Rapoport
>> <rppt@kernel.org>; linux-mm@kvack.org; Zou, Nanhai <nanhai.zou@intel.com>;
>> Deng, Pan <pan.deng@intel.com>; Li, Tianyou <tianyou.li@intel.com>; Chen
>> Zhang <zhangchen.kidd@jd.com>; Zeng, Jason <jason.zeng@intel.com>; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve shrink_zone_span()
>> subsection boundary checks
>> 
>> On Mon, Jul 27, 2026 at 09:49:39AM +0000, Liu, Yuan1 wrote:
>> >> -----Original Message-----
>> >> From: Wei Yang <richard.weiyang@gmail.com>
>> >> Sent: Saturday, July 25, 2026 10:50 AM
>> >> To: Liu, Yuan1 <yuan1.liu@intel.com>
>> >> Cc: David Hildenbrand <david@kernel.org>; Oscar Salvador
>> >> <osalvador@suse.de>; Mike Rapoport <rppt@kernel.org>; Wei Yang
>> >> <richard.weiyang@gmail.com>; linux-mm@kvack.org; Zou, Nanhai
>> >> <nanhai.zou@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
>> >> <tianyou.li@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; Zeng, Jason
>> >> <jason.zeng@intel.com>; linux-kernel@vger.kernel.org
>> >> Subject: Re: [PATCH v6 2/2] mm/memory_hotplug: improve
>> shrink_zone_span()
>> >> subsection boundary checks
>> >>
>> >> On Thu, Jul 23, 2026 at 04:49:46AM -0400, Yuan Liu wrote:
>> >> >When shrinking a zone span after removing a PFN range,
>> >> >find_smallest_section_pfn() and find_biggest_section_pfn()
>> >> >only checked one edge PFN in each subsection for nid/zone matching.
>> >> >
>> >> >If a memory or hole boundary falls in the middle of a subsection,
>> >> >that edge PFN may belong to a different nid/zone, causing the helpers
>> >> >to miss a valid PFN within that subsection.
>> >> >
>> >> >Fix this by checking both subsection edge PFNs for nid/zone matching.
>> >> >Keep a single pfn_to_online_page() check per subsection, since online
>> >> >state is the same for all PFNs in a subsection.
>> >> >
>> >> >Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>> >> >Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> >> >---
>> >> > mm/memory_hotplug.c | 42 +++++++++++++++++++++++++++---------------
>> >> > 1 file changed, 27 insertions(+), 15 deletions(-)
>> >> >
>> >> >diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> >> >index 4c699fd9c479..3a281d595207 100644
>> >> >--- a/mm/memory_hotplug.c
>> >> >+++ b/mm/memory_hotplug.c
>> >> >@@ -427,17 +427,24 @@ static unsigned long
>> find_smallest_section_pfn(int
>> >> nid, struct zone *zone,
>> >> > 				     unsigned long start_pfn,
>> >> > 				     unsigned long end_pfn)
>> >> > {
>> >> >-	for (; start_pfn < end_pfn; start_pfn += PAGES_PER_SUBSECTION) {
>> >> >-		if (unlikely(!pfn_to_online_page(start_pfn)))
>> >> >-			continue;
>> >> >+	unsigned long next_pfn;
>> >> >
>> >> >-		if (unlikely(pfn_to_nid(start_pfn) != nid))
>> >> >-			continue;
>> >> >+	for (; start_pfn < end_pfn; start_pfn = next_pfn) {
>> >> >+		unsigned long tail_pfn;
>> >> >
>> >> >-		if (zone != page_zone(pfn_to_page(start_pfn)))
>> >> >+		next_pfn = start_pfn + PAGES_PER_SUBSECTION;
>> >> >+		tail_pfn = next_pfn - 1;
>> >> >+
>> >> >+		if (unlikely(!pfn_to_online_page(start_pfn)))
>> >> > 			continue;
>> >> >
>> >> >-		return start_pfn;
>> >> >+		if (likely(pfn_to_nid(start_pfn) == nid) &&
>> >> >+		    zone == page_zone(pfn_to_page(start_pfn)))
>> >> >+			return start_pfn;
>> >> >+
>> >> >+		if (likely(pfn_to_nid(tail_pfn) == nid) &&
>> >> >+		    zone == page_zone(pfn_to_page(tail_pfn)))
>> >> >+			return start_pfn;
>> >>
>> >> Here we are checking range [start_pfn, tail_pfn]. When we come here, it
>> >> means
>> >> start_pfn's nid or zone doesn't match our expectation. But if tail_pfn
>> >> does,
>> >> why it still return start_pfn?
>> >
>> >Hi Wei
>> >
>> >If start_pfn falls into a hole while tail_pfn still belongs to a valid
>> >memblock in this zone, skipping the subsection would cause
>> >shrink_zone_span() to shrink the zone span too aggressively, excluding
>> >valid PFNs from the zone.
>> >
>> >Since init_unavailable_range() initializes hole pages with the correct
>> >zone/nid, the start_pfn check always succeeds here, making the tail_pfn
>> >check redundant today.
>> >
>> >That said, I wonder if it is still worth keeping this check so that
>> >shrink_zone_span() does not depend on how hole pages are initialized.
>> >
>> 
>> Looks reasonable.
>> 
>> I search the discussion history, and found David suggest this fix in [1]
>> with
>> following statement.
>> 
>>   Well, unless we have an odd case where the hole+memory starts in the
>>   middle of a "PAGES_PER_SUBSECTION". That would already be problematic if
>>   memory starts/ends in the middle of a PAGES_PER_SUBSECTION chunk. I
>>   don't such a case exists.
>> 
>>   We could improve shrink_zone_span() to let
>>   find_smallest_section_pfn/find_biggest_section_pfn test the pfn_to_nid()
>>   and page_zone() not on;y on the smallest/highest pfn, but also on the
>>   highest/smallest PFN in a PAGES_PER_SUBSECTION chunk.
>> 
>> I am trying to understand the exact case David described, but not fully
>> get
>> it. Would you mind describing more, so we would make sure not missing the
>> point.
>> 
>> [1]: https://lore.kernel.org/all/e86fee84-08d8-4563-8596-
>> e40d8e196799@kernel.org/T/#u
>
>I am not sure whether this scenario can occur on real systems, but
>from reading the current code it seems there may be a corner case.
>
>For example, consider a zone whose tail ends with a single-PFN hole.
>init_unavailable_range() initializes this hole page and assigns its
>nid/zone to the adjacent next zone, since the PFN itself belongs outside 
>the current zone.
>
>When memory is hot-added after this hole, the hotplug granularity
>(PAGES_PER_SUBSECTION) extends the zone span to include the entire
>subsection containing the hole.
>

IIUC, for memory hotplug, the alignment is guaranteed by
check_hotplug_memory_range() with min block size which is section aligned.

>Later, when the hot-added memory is removed,
>find_biggest_section_pfn() examines the hole page first. Because its
>nid/zone belongs to the adjacent next zone, the boundary subsection may 
>be considered removable even though it still contains boot memory pages.
>
>This appears to be asymmetric between the zone head and the zone tail.
>
>At the zone head (find_smallest_section_pfn()), the boundary subsection
>has a hole + memory layout. The hole pages belong to the current zone,
>so the subsection is retained.
>
>At the zone tail (find_biggest_section_pfn()), the boundary subsection
>has a memory + hole layout. The trailing hole pages belong to the
>adjacent next zone, so the subsection may be discarded.
>

I am trying to see what the real case it would be.

Hmm.. First I don't expect there would be memory hotplug happens between zones
or nodes. So the new added memory range always sits after boot memory(early
sections).

Then let's assume below memory layout after bootup.

  |< Zone Normal  >|     |< Zone Movable >|
  +----------------+.....+----------------+.....+
  |                |hole1|                |hole2|
  +----------------+.....+----------------+.....+

Both hole is less than subsection size, and the hole2 expand to section
aligned address. According to the init_unavailable_range() during
memmap_init(), both holes are init to Zone Movable.

Then we can hot-add next section and hot-online it to:

  1) Zone Movable
  2) Zone Normal

For case 1), if we offline this section, we run into
find_biggest_section_pfn() for Zone Movable. It test the last pfn in hole2,
and see it meets the condition. So Zone Movable results in spanning hole2,
which is larger than original value. This is not that accurate, but still
could work.

For case 2), if we offline this section, we run into
find_biggest_section_pfn() for Zone Normal. Here we also have two cases based
on the location of the hole:

  a) hole starts at the beginning of subsection (hole + memory)
  b) hole ends at the end of subsection (memory + hole)

  For a), it looks good, because the subsection hole is treated as Zone
  Movable, and Zone Normal is correctly sized.
  
  For b), it seems not right, as we only test subsection's last pfn. As it
  belongs to Zone Movable we would skip the subsection and set Normal Zone
  span to previous subsection. Even some of the pfn belongs to Zone Normal.
  
  Hmm... I guess this is the case David mentioned.
  
  And with your patch, it checks head_pfn of this subsection, so it fixes this
  by extend Zone Normal to just ahead Zone Movable. This works something like
  a), but make Zone Normal span to some pfn initialized to Zone Movable.

Based on above analysis, let's see when find_smallest_section_pfn() will have
trouble.

The case in my mind is like below:

  |< Zone Normal  >|< Zone Movable                        >|
  +----------------+----------------+.....+----------------+
  |                |                |hole |                |
  +----------------+----------------+.....+----------------+

Hole should sits at the beginning of a section, otherwise offline_pages()
would prevent offline the range.  Then when offline those beginning Movable
memory, find_smallest_section_pfn() is triggered. But as hole is init to Zone
Movable, it looks good.

On summary:

  * find_biggest_section_pfn() may truncate zone span range if there is a
    hole less than subsection sits at the end of subsection
  * find_smallest_section_pfn() looks good even there is a hole less than
    subsection

Above is my understanding about the possible cases when re-sizing zone. In
case missing some point, just let me know :-)

-- 
Wei Yang
Help you, Help me

