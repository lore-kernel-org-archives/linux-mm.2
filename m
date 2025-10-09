Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3317DCCA471
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 03:39:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6609A8E0034; Wed,  8 Oct 2025 23:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 611958E0002; Wed,  8 Oct 2025 23:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527328E0034; Wed,  8 Oct 2025 23:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6DB8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 23:39:28 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E14E746579
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:39:27 +0000 (UTC)
X-FDA: 83977170774.29.52998B4
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf13.hostedemail.com (Postfix) with ESMTP id E539920004
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:39:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bjsb8+PG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759981166;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wsdI8cG89c1VD56QwkMkMGy8C09bhMx9HRR8XsqBXAo=;
	b=xvvuxuBRkBR9zE8yyCafWdVPQIF9/cBGEZ9td+me+yTlZJp8kl69UmpxFsplEJrV1ZHu4S
	X/i8eHWXrgs+rbVfg24CWVNzR143G/cNUIW1x6RAoLBLOwX7SubyAqQtM6IBBvmnUnfBOP
	9BgxWXJY0cfTsg2Qf8Q0aBDY7aZpZJo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Bjsb8+PG;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759981166; a=rsa-sha256;
	cv=none;
	b=ypTmdqUfGunb2+lErerWl2Gk5+eUcdwnQT4ixD7AHAJYO7gbdcmOTlw9LzM5OlflcGk34v
	/SSj7qOMQqawS3LJMPgGHHbrn4ovSP57jL9v/3SG4QPR//kfe+4NkZcasoPoBUGodHNKrZ
	YIOzkmFzYvUjFhmhTIaLNiSIS/TnqjU=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b4736e043f9so71622166b.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 20:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759981164; x=1760585964; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wsdI8cG89c1VD56QwkMkMGy8C09bhMx9HRR8XsqBXAo=;
        b=Bjsb8+PGTBVwgDGywP8TautTxSk6gjBqMoFHC5ISJAnBw+wLaMmI29ttQKZJdC+xOj
         3Dx17Lsn+8gIi1p7wvrEWNWYYwWDBgPCD9WhVLO91kB2R0o/1ZxyttoDOZWU0GIYwhFv
         dIGKOW2E0w8XqubQ6+8jamFVHpv83m5Jt3QH1oBDmopdcIrkFhIoYFP57ask/bzpEp4D
         /o2EmiHRLNSyyaxKm+2hL8cAJZ5/5G6LbGT/5HkE21nTLK/dAYKe2C9UXOrfYrh2tGhW
         M+DMjVcU4pSy5RnfjK/v4kCzV0TyFPT9F83PluEVAvPx+nkDWwutq+CnyuVqOnrdTCY6
         yaCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759981164; x=1760585964;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wsdI8cG89c1VD56QwkMkMGy8C09bhMx9HRR8XsqBXAo=;
        b=uUJm1PaLHfZkVgUWF3at1KMtVu+Ep0ZqXf25nFCj0xJvPaAjwkQKrZX3fBEucx3ccw
         sB1243WPyiWh4VnbQKNrVv125oPRaSNBv5KQMAokV0SU1w3OMzYoJ8+/156PpJ2DeMnE
         FBTMf2fJpr17DH7WtpcylGitryHNza7hjeueyWBOlPpHX0rcEdU9p/JS4mrFxFKtGrwy
         njKjBPapLFZDnyBO5+Vieu96oYU2Ig+hVz77AjkWgz0pOrhoupNsLAAEQBCze+GcNPJC
         gf/L9hgpcwV7G7Nsn9BQK9DkbT846QhKuEwe6R7bFpwH5h6jUOvTtD27Z+QPw/CvVQy8
         ze7A==
X-Forwarded-Encrypted: i=1; AJvYcCVazM/3+WtDv6Tx5rl8LKTbYT5y8nej2ySAwS5IT4p5jXOIQLxLn1vA7pSoMZsVqQEN3U6CfS8Vtw==@kvack.org
X-Gm-Message-State: AOJu0YwYrFboP1aVvf133GzGWplFR/JOfFfJm2JJftela6CPkVqFn5jS
	/lcaArqAflSwBDvF+qd+dQ/NsIrpTzfoZYgLOV50KNAymwjxIEjTKVF+
X-Gm-Gg: ASbGncvCPWkOK50FTcjcPKOfmDi5rfNumBWLH4544fZkEd8Mc9vbCGNSUXKyQ/B5oty
	zqf8EgHhCnNUQ7wAXIARxpFGhHiLBqP8cGeN9jqNgmzBEj5vWSZ3mdoOWpY9vC04HeqQJHTxyQB
	1ecQcG4aL1LRnA3Z9v1B4OnLoQZjomUcBwekq/WzbEwGU89P+JJ8RHl4Kc1dEu6DdFVK+cqLjCC
	0rNy4QpKtjKrtpgCkYdonb72Mha1RnSYaPXgOFzEH7rMfWBG6+gjP7y0gOoC4peEw76fx7NfqtY
	uspV3Jv96qlG2CqOUmAljT0FH6ay2kKoZCdnAcSQ3c1Wxw21UtAVM1W+rZi6x1XitLNu6hFoIaR
	WVvx2Ob+aQnsIqCMdsaUnVTSPT9OCGO6bfMa+XJ3rYIugAg==
X-Google-Smtp-Source: AGHT+IH9O2/6TfYX6HVBsTmvZjtdMD3UT7IyMVPmpoc03qd35nHBhxIkccCpVZ0birILXHXd6xvtTQ==
X-Received: by 2002:a17:907:c28:b0:b46:3f98:6ba5 with SMTP id a640c23a62f3a-b50aa48e3a6mr712895466b.11.1759981164128;
        Wed, 08 Oct 2025 20:39:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b48652aa040sm1791141266b.20.2025.10.08.20.39.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Oct 2025 20:39:23 -0700 (PDT)
Date: Thu, 9 Oct 2025 03:39:23 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, iamjoonsoo.kim@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 2/2] mm/compaction: fix the range to
 pageblock_pfn_to_page()
Message-ID: <20251009033923.dtljnazdega3ukh2@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251002033140.24462-1-richard.weiyang@gmail.com>
 <20251002033140.24462-3-richard.weiyang@gmail.com>
 <3ec7d5c9-27c4-4395-b859-8931eed72272@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ec7d5c9-27c4-4395-b859-8931eed72272@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: E539920004
X-Rspamd-Server: rspam03
X-Stat-Signature: pi451y5yossseodrpoxi5ex5asobhued
X-HE-Tag: 1759981165-704517
X-HE-Meta: U2FsdGVkX1+LlPIeGEH8v7M/ReKpGvKavphozy618sNpvrwoq2x85num7uGNhdiKBK874SlxFYnQm8fykNaS7SQq2cmMPSsvdxG2X/Dg80Xe8Tjoq8WocMqfW+TVh6JTSz1StFUZHCwH3yaXi7ZUN0xzGEgoxqUg/7AA2zui/WbJs4YUyWpf64iM5Cw+J4RArp0Tp+80LBXW7raSyDnRHxlXGcuYEGOxWVBDcpNIhh82zkjJvFApepUbvn6VZmjFX2cD2VYz+/7w3/Np1sU85Kvpwikg6Lh+tn3PH1HJWd/rOTlpDB9N4Y1Zc8+3BA241O7lR1erqdJYw3MCHibJ7Gvv0ura9SkQxOyXIWevXgHWsNkUBkUZ4e1SstGhs4kUVsqDsXJbt4YmzL25yCuAiEnqHKDPyPoVtBL7gawrAlH+Pnm/t1S2RrHhB+uxxhRkZKtaKMcEORbtq77evx+IfafcLpdS4Z3VRK/MdtJx2RrAZQpP80qNatyuaUDp/2AdIl9Zv88bLKX4z4wXZtpw3G270BkZjtv+qxxg5SH+NT3lNjvfkbTM+4Shc22cteqXhqcMLZs7/MiwM1K9RE+5xdfn7ziAmyhpV8MaRLXrbB6Jvt6yS9ghKs3AT/O9jXuZeows/fEaFWAkzShgRhaLge0hClaaIDUtaA1iZL7Dww2Re++q85pfnolskv5gXz+h9FBf3UDnmSN7cY4TY5YUlCk8KlBoJyRK2VDY/KzPZFr/92hNvYivoI+Jvj2uYugct/R02oghZChQ+QmsOEaQynUv9dMfixZvsPJMxNUs8nnbockyE/Fhe8SS1MKpAEblgIKnTSS5OkCUmuCFYti7msQCQ8xe+5giKghD14y+x0LovzHQq9fTkryunZu8D4spOjhz4Os09sSMAyoKamwadJhIIUeVB9isoRUc8uyyNZCtIzpU10bPwZFH+ue1+DMKhuuk9cqgByFhzOZzKfI
 9ysHNC1b
 jeg35rlepfRHJWo5GB+yZ3V8BFzDDlhg0JqujsFkwOIqivSIFOUwnHYkJUufg4FpIs3Iop9maMS2R0d+owW10yjKMFfzvSjdsDCuB33SRNBN6o+Iji/iiQBuHODI/qMH8anAFg1w/yldXZti1Hb/dwghIPzwBjWdilN8mqlwrB6Ed67iOPK5ebgpxkgLeNual6TR7S87w3D9dUZCrHlAiwpezEJZUPLdG+r/bhxTcpqikZxQkB14xjyQK6rwLN/u6NTeSrCW6Rj1Qpbg+quabnYVdDD3yywjFQckXFzSgnIM9uzr1KBEsSTHPbvGN6ypkz1LwqZR/B5BxX1zUT1sA1W+ZweUp8K64JgUAmzSYasBRw+bUVr8hbOugq+r0ZN4Yt3jXESWJwwQHJ67PQQl22Rm+JVogONZDXVD674o/wj63Hd65mh+otiwm1tgYnkROu4mm2fx2cW25yUYDZg0wombPH0992O8H5X+e1p7UPlJOSIZsNDRgVW+EhwPTfIn0w1YOZfWHtI5nBVX21r6pOo6UbwsHWYRisJJZySym0jRM3Cy+AwgPEZhi+u/MREVGAgBvpX3oBMxhpVi7jU2Z9ILtzxV5XVnutykiAi+dqlnqJu+kY4KZ/0wvAdPK0X5JaU96EMGRIsoebn3UKNzIHc7fajVoteczldn+md4nHkTcy0QqTWFo5+ffi+WAAmyF4EGR0vq06bgNoJsmf4Zp+hszWlU5194zuzSOHnqtDXEe+CdHrYdJz6yQEdrO4oZMUO3gAJGBk7h72ENMPZCRyV+7CReblMDINxwDqi8BTJLY1fpNy52/EOl6HEU+r/IyXOdbv0cstxY7EJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 12:17:29PM +0200, David Hildenbrand wrote:
>On 02.10.25 05:31, Wei Yang wrote:
>> Current code may skip some part of the range to
>> pageblock_pfn_to_page() to check whether the range is in the same zone.
>> 
>> Function pageblock_pfn_to_page() is first introduced by commit 7d49d8868336
>> ("mm, compaction: reduce zone checking frequency in the migration scanner"),
>> in which it checks and isolates on the same range [pfn, block_end_pfn].
>> 
>> While after commit e1409c325fdc ("mm/compaction: pass only pageblock
>> aligned range to pageblock_pfn_to_page"), we operate on two different
>> ranges for check and isolation.
>> 
>>    * [block_start_pfn, block_end_pfn] to check it is in the same zone
>>    * [pfn, block_end_pfn] to do isolation
>> 
>> It miss some range to check when start_pfn and zone->zone_start_pfn is
>> in the same pageblock but (start_pfn < zone->zone_start_pfn). The range
>> before zone_start_pfn is missed.
>> 
>>           start_pfn     zone_start_pfn
>>      +----+-------------+-------------------+
>>      block_start_pfn                        block_end_pfn
>> 
>> This leads to the range check is passed, but it will isolate a range in
>> two different zones.
>
>Can that actually happen? I recall that a zone always spans full pageblocks.
>

I have asked myself the same question. Here is what I found from history.

1. From the very beginning, there is this commit.

   commit dc9086004b3d5db75997a645b3fe08d9138b7ad0
   Author: Mel Gorman <mgorman@suse.de>
   Date:   Wed Feb 8 17:13:38 2012 -0800
   
       mm: compaction: check for overlapping nodes during isolation for migration

This one add a check on (page_zone(page) != zone) in isolate_migratepages(),
for overlapping nodes.

And the range to be checked is within one pageblock.

This sounds there is possibility of two zones in one pageblock.

2. Then there was code refactor.

   commit 2fe86e0004076128f05d5a774b5c9c03d9dc3de2
   Author: Michal Nazarewicz <mina86@mina86.com>
   Date:   Mon Jan 30 13:16:26 2012 +0100
   
       mm: compaction: introduce isolate_migratepages_range()

This introduce a wrapper to isolate_migratepages()

    commit edc2ca61249679298c1f343cd9c549964b8df4b4
    Author: Vlastimil Babka <vbabka@suse.cz>
    Date:   Thu Oct 9 15:27:09 2014 -0700
    
        mm, compaction: move pageblock checks up from isolate_migratepages_range()

This move up the check, but still keep the form (page_zone(page) != zone).

3. Introduce pageblock_pfn_to_page()

    commit 7d49d8868336bbf4f68714d8282ca5fd65e387ed
    Author: Vlastimil Babka <vbabka@suse.cz>
    Date:   Thu Oct 9 15:27:11 2014 -0700
    
        mm, compaction: reduce zone checking frequency in the migration scanner

Instead of do (page_zone(page) != page) check in loop, it does the check
before do real job, e.g. isolation.

PS: it looks a little behavioral change.

4. Current state

    commit e1409c325fdc1fef7b3d8025c51892355f065d15
    Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
    Date:   Tue Mar 15 14:57:48 2016 -0700
    
        mm/compaction: pass only pageblock aligned range to pageblock_pfn_to_page

    commit 7cf91a98e607c2f935dbcc177d70011e95b8faff
    Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
    Date:   Tue Mar 15 14:57:51 2016 -0700
    
        mm/compaction: speed up pageblock_pfn_to_page() when zone is contiguous

This did some optimization, which seems break something from commit 7d49d8868336.


All in all, if my understanding is correct. All the change comes down from
commit dc9086004b3d5. This means we do have possibility to have two different
zones in on pageblock?

Or this case vanished now?

-- 
Wei Yang
Help you, Help me

