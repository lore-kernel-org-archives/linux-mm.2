Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EEE3C5B56A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 12:23:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6596A6B007B; Tue, 11 Aug 2026 08:23:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E28A6B008C; Tue, 11 Aug 2026 08:23:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA3A6B0092; Tue, 11 Aug 2026 08:23:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3196B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:23:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E45A2403FB
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:23:26 +0000 (UTC)
X-FDA: 85088904012.29.A56FBB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 379321A000F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 12:23:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HISixaP+;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786451004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=io/KtamoJ2U8IcpfdYH6Lz63cdY0XnNwSLtsC8XuWNc=;
	b=H/zranz0IQzrNeAcKhEbjtxePPDZ5myeYBDhMGqbDic1QgQsmwSsQtu0eIcWQ102gYDZr6
	lOU9qN/j7a4MavIXXa/H8EFJNf/7X/LHCKwUb741h1bfyxa15I35/L85iq/j7bKz+SMZeV
	8FU0ln8/QopjpErjPWVLijb+xGpyVvk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HISixaP+;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786451004;
	b=ZxsllGmq4DfL/csc3OE5eBBMSlmM3wwAy7t3OWTGzPIdDLQPnisgqE2uOkIKI/v0kIPK9X
	4ZUOLXHv780E/JqHMfezBfXaDzaTwLRiqzastVAHhik033LCM7qOQXMTf6dd1EpPNwZ9Bf
	SJAr4rstkKKNyvMvNZ0jKAQz5MkRN+s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CC21600BB;
	Tue, 11 Aug 2026 12:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BFCC1F000E9;
	Tue, 11 Aug 2026 12:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786451003;
	bh=io/KtamoJ2U8IcpfdYH6Lz63cdY0XnNwSLtsC8XuWNc=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=HISixaP+3dJjYZpRGTLwWs5c4DeZQ5UuzQMDDSF4z8+Wh5yUWazwJSmKxDZvD7b5+
	 IJe0VuDrlYeWL3SsNaKKHjC7ZRg4VhAEXREF1v9UUq7pJ/zAxiQ/TOS3nN7p7W2Btb
	 2afTp2Ydfl63D2uH66cwors28CTK44qcJKpY2iQI5cvv1L/u0mjWcSSk8E1NtqakEr
	 T08GCvpIk/KutIWSj9h3xzWDo7b5WPjL5ypwMk+3NLjF97DVLRhhMVWl4jeNzckEPB
	 MbeL9lVSClWrLiPrKx1ED/+z12AhvA6nuGxhkS6bjrRLmxiJvBugLpTEd3vdySIT/i
	 HLnjhZD6v5kNg==
Message-ID: <01795519-54e8-4ed8-a94e-2b77780abc3a@kernel.org>
Date: Tue, 11 Aug 2026 14:23:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
 <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
 <MW4PR11MB6936594CC6B15968AAB781DCA3D22@MW4PR11MB6936.namprd11.prod.outlook.com>
 <0b02ef3e-363f-4b49-a208-54cdfea56c75@kernel.org>
 <MW4PR11MB69363CCE15647FD7D85542B6A3D12@MW4PR11MB6936.namprd11.prod.outlook.com>
 <f0593f56-870e-4e79-8552-1760fad255bc@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f0593f56-870e-4e79-8552-1760fad255bc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 379321A000F
X-Stat-Signature: 5w3ci1xmwb7761dsoyftc9qes536n7gb
X-HE-Tag: 1786451004-108695
X-HE-Meta: U2FsdGVkX1/ELhmX669rQ2NbLcepgbTNlAvYB/2RRRrFfaFHVF+Lx9e86GRv5kC2fJLYvClQpTkdIBZ2drYm7lHacQXeTp0PburyVjZRMmgzSOr45F88GTLvHrwtCnIXn7+HCGAW9ltoLYi5LcpCK0bgcs5PaOJOJAvIDXCkT6wXKmz3AK2jeRey4vn7OBSkje1uVghmQi2QwyRrVKGCSI/fNKD9VI/jDEWIXPoiUfoHy/P2AMtPvFACJteUf3mjV20ulmJcIKKh2X7iWhAR0VfMZBMuZPBcCGovtkbmU0lJXBxoOB545kOrm+GL2uNJAto7SZdA6yfrUxuVgM8TODuhfk0NwKqWof2mk9kPPLajkTa3EXuwYMmuT4c7+uRefdAIk8nRvFVGC9vOBoxx+TMxLSCLcDAKClRgNIvjjjnssZZKd+1oqIpNGuTgHZ5fH32DUbr6Uj52myJHkv42hoTMYnU07dkFVGJ0pQk9XcHx2N5BcJshfakObqgen8ByEvbH6yrFR7XsRNB3SCDgV8n6qiW4/EApnSD7vWGKoPwwkq2d2dnc4ie3/srxrHnC5Y0yPtftES1Pc+ma4gRjG4kJsNFo5E8ugvqncR+GXv7PRFMBbvRPMQPnOLzzOwdbRqOi/ITFxVfGVafRJXVnq7EHwbPIwvrPy5lS6nVZHwE/435mwCko2vSvDIlUifnRVsZnEerOVhKHe3UvjYX9e32YzBwKHBXBQEskwVQFoonSfdeR6geqXPYVTTsMmTzuHK+yPDttld1fNDinEfaySBSbMnIun7gxDXor2aUL+CAW/6u88+g91j3EtXIfIf/FTD5uy60LfZitCgDZ3wAGS3kSFZeb31cqpJENCzFljog2XQF/ZzxZSFTksnCm2uso8Jel9zDhnLntKQaIf/5QlXMV1/ApWrDqwlUgecqS/SxM04KTnOUA3JLJFIROX++MCyTVwiEeZZmyS1sw1Gz
 OsTwr5du
 XLUZpFlIt2dduZPDHnQtnjuo6FJ7ExY49eknku8nBpKT12gFAd0cK+xmorY0ToW6v3K41XEUGNFyixPPQLRJ1DV0LzmMCu+v1HC4LiqSN1GdY6euNYpiAw9Dmhuchm4xhnX5b96bBD2EvXb8zmuR4QUUqt6PJPNAOYdYHnyV00a/rprz7IxB2GODR/t58yGpv+nM5PiiaN8haoQtDnTp4qDgW7bv3XJOUmmM2dr2k8MOU7Qzl/8CftoGiBJLbK5WHhSgc/lHLChuAZraWOgA1lU43teQgiogL2w05CVavgu6svsfZhtCNHat9W+E4OLZ+xye4ar7ysuFyiyqjp3z954BrVB2fOBvnOF5ZBebR3PsLC9jXwiSY6UIxKZWt3VGAb2iZmxnFZHeop6GSlIhO5SSTAJSs4dz6aGXTQFodNVEZC1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/10/26 16:04, David Hildenbrand (Arm) wrote:
>>
>> Hi David
>>
>> My understanding is that init_unavailable_range() initializes all
>> PFNs that satisfy pfn_valid(), but not all of them satisfy
>> pfn_to_online_page(), since some PFNs belong to subsections that are
>> not online.
> 
> Thanks for reminding me. I think the right direction is to finally clean up the
> pfn_valid() handling.
> 
>>
>> You previously mentioned:
>>
>>   pfn_valid() says early sections always have a full memmap, so even invalid
>>   subsections have a memmap. pfn_to_online_page() says an invalid subsection
>>   cannot be online and its content must be stale. for_each_valid_pfn() follows
>>   pfn_valid() semantics, and we use it to initialize memmap that is not going
>>   to be online and account it as pages_with_online_memmap, which is wrong.
>>
>>   The cleanest approach is to avoid allocating memmap for subsections, which
>>   also removes the special early-section handling from pfn_valid() and
>>   for_each_valid_pfn().
>>
>> I also share the concerns raised by Sashiko in the analysis below [1]:
>>
>>   Scanners like isolate_migratepages_block() will then blindly iterate through
>>   the pageblock and access the completely uninitialized struct pages of the hole,
>>   leading to functional errors or kernel panics when reading these zero-filled
>>   structures via macros like PageHuge() or page_zone().
>>
>> That's why we went with the current approach in v6 instead of your
>> earlier suggestion. I'd really appreciate your guidance on which
>> direction you think would be more appropriate.
> Let me take a stab at just having pfn_valid() / for_each_valid_pfn() respecting
> the subsection map.

... and that turns complicated very quickly. The problem is that we have some users,
in particular the buddy, that just assumes that MAX_PAGE_ORDER regions are fully
accessible.

The fun begins once we have MAX_PAGE_ORDER span multiple subsections. So we'd actually
want to initialize the memmap.

The pfn_valid() vs. pfn_to_online_page() inconsistency is really nasty :(

I mean, in init_unavailable_range() we could actually figure out fairly easily
whether we are dealing with holes where pfn_to_online_page() would succeed.

diff --git a/mm/mm_init.c b/mm/mm_init.c
index e9c4204b73adb..54e71e17f2c3c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -843,11 +843,13 @@ static void __init init_unavailable_range(unsigned long spfn,
                                          int zone, int node)
 {
        unsigned long pfn;
-       u64 pgcnt = 0;
+       u64 pgcnt = 0, online_pgcnt = 0;
 
        for_each_valid_pfn(pfn, spfn, epfn) {
                __init_single_page(pfn_to_page(pfn), pfn, zone, node);
                __SetPageReserved(pfn_to_page(pfn));
+               if (pfn_to_online_page(pfn))
+                       online_pgcnt++;
                pgcnt++;
        }

If it's a problem performance-wise, we can always try optimizing by skipping
checks within the same (sub)section.


-- 
Cheers,

David

