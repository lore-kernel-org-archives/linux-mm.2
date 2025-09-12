Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B2DCAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 01:07:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56CD86B000D; Thu, 11 Sep 2025 21:07:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 544CA6B000E; Thu, 11 Sep 2025 21:07:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 484CA6B0010; Thu, 11 Sep 2025 21:07:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3864A6B000D
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 21:07:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B5AFF11A88B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:07:25 +0000 (UTC)
X-FDA: 83878810050.12.FA406FF
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id B07991C000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 01:07:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZwL0E8ej;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757639243;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uHivPvs6L+lxHuAEDSb0Agy4ORGS06sc6+rnMHaQc78=;
	b=Q4BS8Ddyh8uxz7gI7jUusAd5vtbhoOyGSb0lJYJYSMVyNpJ5gaqrGB4m42RV0UqrzRV6Gp
	Gw8rh+t95XZGsek0nnj+wK6lN2xEiBcnY4tMUx41NkYK9SsJCha1xluGvSoPWdPpaAwaRF
	5xomuZdx4jamCKqXXRfiG2bVufLBm3I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757639243; a=rsa-sha256;
	cv=none;
	b=xv9QHsuqbdOexfIdZn2uzNhxQYglTvgSael+OWCMNXHwFl9XajohV5SwXlCd8w3uywBM5r
	+Ev+6Yd81hFHVL7MZtFF77M8NmKJIXkrYYA4v2vYgMj2F/tJmZtuSVfPHf+ZJkd4wzf6ix
	m/HBU4lxYDAChWkeoQHIVix8tEWL8dI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZwL0E8ej;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b042eb09948so284853466b.3
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757639242; x=1758244042; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uHivPvs6L+lxHuAEDSb0Agy4ORGS06sc6+rnMHaQc78=;
        b=ZwL0E8ejqup+FcoP81sxTLreB3WoWKQjLGrF0BgXvneEB+Dsw1k/Qk2EGo8uN9gPrq
         Mdjzn/ZYNz0JgBXGWit46xrlzjtgxda/QwXiJ/qn8SJFvax1g9Ckst1N8eEJLTlKcM8J
         QK8FDkKvgvQ86aqSDq375VySU8Uk0TKkWxq5Ty17eRk65ZFNObtlW+YP31b+7va86pbU
         l573xbY6ZmZKzE7PFj0a44AsH0ZfFJ1AYTog96RMcn5SadU4GEGXze2Y+XGJ2xSf7TMD
         WedCC1JftqWCQ09wFtGRPvt2ECf+GuR5l5UszjE/Q5x8A6VuUiMtsDDuZ1Tv7xOmoHCW
         HY0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757639242; x=1758244042;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uHivPvs6L+lxHuAEDSb0Agy4ORGS06sc6+rnMHaQc78=;
        b=VtcCat1um9pMWL19wyN2D9jZ19y2ars0PA7XRNUN+xdjkHcFZVVRSvu+aQCoV1AFzH
         PtQDPl5vv6bmJykEHWjT434+cV8HA+1Iq5IlnyiGBoxJA/tELOgJW/9ZozCmHrrwFFpA
         dHhDpFzGfAFmBop5p3fvJpRIgHXGJU6N7WFx2itl/deFuJ67dtzxpF1UK6Busow18e53
         JjWw5snpiU/MN0XW96EJs0ySebH/Sw6cDxdZaMVRN/w+/FNWIB27P8/7t2LclnIpl5Pj
         VQwSKvrgo4guetUwEj8iD+N7IKj+L+yE7JtpR3Amf1EhGJEom2JQ/sySmzB5E8KRuLlm
         PhkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLTMlvzptCxcL6YlWfC0xb1ojbOieErdNcq1BX6bh9vp3nSQF0zlGYHe2NKoD5HPDa5dHAp9F15A==@kvack.org
X-Gm-Message-State: AOJu0Yw+dkEjKMRgJF7V2/vhYwA94h+uqEBl0tEXYLpLJ0Oyc87NvYkx
	f8hsi4//ifn6fqTK2MpVWL8rpram6hkVf6jEVLS7+VxSpZlcyZtFAos8
X-Gm-Gg: ASbGncvm3KStaI35wQW/3zoQbtGBayttw5+G5ZUDPZK4sA3hgMvBJMsIfE6EGSEUk+B
	RZn4PiA8GQ+cIsnwNCqRxhItcmKEeEKEigNwdJ0oryR0rh6fbH1ytCePMYkRR5IWpuURdu9W00p
	k7IrxRBehM52gX5/cusOzGvkVzRKz9IWz+3U/YxzWRAARMmYhE6jDCMqY0LYtX2j9bq6E4W4Vfm
	jQ3zQStzJcPD2GLgbOtFMkJ0Oz4VLldJA7R5UD3e8VmZOfVD89V1282pOv+uH+/0uSAsblHhH/N
	Szvs2LvHDkc0/NvzDAhT0O9KVnn84xN3cdgvTgrNGrEF/T/5qdYxAvFb71sLaxZTdFKTWOXStbZ
	kObfbA63WTIBdA1KD6GEaWNllag==
X-Google-Smtp-Source: AGHT+IG4IwXsZX8n6wBnSrjbmUgmmVU/613Ps17XSKmU6MrThVquX+mXQCvtpmgmYHDYer2HiXbrYQ==
X-Received: by 2002:a17:907:2da2:b0:b04:2212:4211 with SMTP id a640c23a62f3a-b07c356d88emr106120866b.16.1757639242080;
        Thu, 11 Sep 2025 18:07:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b30da542sm255413466b.2.2025.09.11.18.07.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Sep 2025 18:07:21 -0700 (PDT)
Date: Fri, 12 Sep 2025 01:07:21 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org,
	wangkefeng.wang@huawei.com, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <20250912010721.zd67xbfdava2u26e@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <20250911032751.khtgvdhcqzyf3rgr@master>
 <3DE28F4B-ACB1-468F-89B9-D7750D24BE4E@nvidia.com>
 <aMMGbPX9uUj7TfoG@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aMMGbPX9uUj7TfoG@fedora>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: izuj9jqro6c55mx16k63bh8x86wn4swh
X-Rspamd-Queue-Id: B07991C000A
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757639243-560355
X-HE-Meta: U2FsdGVkX19QWgotf23733YHZrXE0u1L1RQ6T7zVUayquSW2aCKtjfCV3lgZuPl6QoQiDQDe0mBcs7BmUSoTuxRKSGBpGmru7tUEWWZq/SOlpQOWaNApxqRQB6jY3wKJK4ErsQUTMGc3/LpjfdOvPJLBBO8eDykBDMIx6iex+ybkGWpc0FJhxOJgTkQXHIud5G7yHwW6QcvFU5qPAUHSnMfuRQs9SWosebWyVh7H/VTJBmBPOsv4tpfsOYgHGA2mutlUkd+NUEopG4T0widgOLGt1WejnAfWrQojqcJgvwtCGBzFr6UufW/mswowCaydmNyhXaSzSDowW8jG5GRqOQqH6esXYwhzZyKDxT7m2kKFxvkc5nbUzqKF8NuvtbifOMG3KV17swJrm6EMVPj8LNMcPr1hZ7HNKowIoku+k8iPzJ1RuY4RJ2cuJ6Z163Coojl6eW3DUs2vjVXH7fLKz9qkagb4I24WRi20tvCc3naxIe37GGm4U1Yk9xds7nq982D+3FHfficLMjONz1O9w81+Y8mjZUztJAVXYAnesRCMDYZuVim+rq1pZAQH0QAu9U4448fnnmQl85hmdklWubFzls68AWOY7+ev/0bcpT682JlOc/cDbJ/9JJ2Z8BUxXnz2DLriatbZcOpenDDmyQUWFOxGOxF8Uv8gw8M143T2Yq8ddjhuzkP8a5aZDyVpl+5IFwMmVOIljequgKsaW9t6YfsBRI4GghhkwVq4bj4/Msml3cCUMWn6caCb9GQB2YayUp2rsuRgKc7kV6A3ygFEIUkbLfFNMF9I54+V+rcczvXU3pBkU6r2ok2u/1SofoE7DfcGEQV3Yit20CwAPX6P5SOFHTqETwxJnQoGQyL3rW3zndLGbL+8vBO/uC9ur887iKBGoB6K9DIO4vHZ4dFxZHu/L+Iy3hBVLNpXO3uE3DV3Jma1JVsm5LXBzzjywRfJnDiKFlhDycx5sz7
 /51eUkrv
 flTdyp5MeaIO1FU2oI1/EJRR3NVqVB7lS5n7z6mCNSVJD/Anx2D2kOwYk87xjvznrGrwPtTq2zLb5DCGjsQuahhlnoHScnwm17OoNRVb74kpHBZ+SvGXs6eMspaa3mXaBR9dRuRlEyljiDxewtJOeSAuWCZoo3gkoUBQ0APPeRhlbdC2MraKmmIwIwNDT0+c4l3cM2bIDT3o/EHiGKIw+ujZRHhYi/mD88foQg/jxUHsB+2uqpr4CXKvayDAzSK3Y7Yc3BycFSDagDvHZ5MeTz05MHZD+XW38K8ExdE/sdtRKCTPtHoPCINK3LOL8fyea1AtzR3O1mNoP9X0h9GuAI1TrOc6wzzFpkrDUtaeDJJSZ+K4YBQ4phkwe1B7tMjtcfwIKgmtbb5OaOShpFxCFfHSZ4nVqsBhFuke3o7ik/ciWEwKER2dr3q0Ftl0ozGf6k58WYH5oab98/5E16gaX+adrAhgtf9+4ZpI6tXtjIQS8syT7aGdPwBLDkpafjDeaIdjVA1HUBk56jgmwJcJBpqTXm3CDeKvO+J8/rz5exlq2n4DGrhg97HXRpvWfCrOhO0Rf6LCmJI38bQ0sKtlHjWzUJ/K7GUw8A1zIWuQ/lUpht7y0Daxx1OaNeKkjfCLhIrdzoOzRSuJq/ti4lgeNZT1qcCimwxkBLtz5ZyBPOaV6RpFQUFILb0a2gWoaPgRm6Jv5Rq3rUaq/7Lasbk49SAtFMuGMekmu9Kyl+SeNmg/x8ucdZYEoBg+JbFv3mgKfIBNJXIUQIKBOPq2PofEf+ODbAqrbgavuk8HGlFUmcjgHTYrLKQ3JePWUgBju0raUj+EK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 10:27:08AM -0700, Vishal Moola (Oracle) wrote:
>On Thu, Sep 11, 2025 at 12:19:34PM -0400, Zi Yan wrote:
>> On 10 Sep 2025, at 23:27, Wei Yang wrote:
>> 
>> > On Wed, Sep 10, 2025 at 09:35:53PM -0400, Zi Yan wrote:
>> >> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>> >>
>> >>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>> >>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>> >>>> isolate_migratepages_block()") converts api from page to folio. But the
>> >>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
>> >>>> to head page.
>> >>>>
>> >>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>> >>>> which means low_pfn only advance one in next iteration. After the
>> >>>> change, low_pfn would advance more than the hugetlb range, since
>> >>>> folio_nr_pages() always return total number of the large page. This
>> >>>> results in skipping some range to isolate and then to migrate.
>> >>>>
>> >>>> The worst case for alloc_contig is it does all the isolation and
>> >>>> migration, but finally find some range is still not isolated. And then
>> >>>> undo all the work and try a new range.
>> >>>>
>> >>>> Advance low_pfn to the end of hugetlb.
>> >>>>
>> >>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> >>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
>> >>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> >>>> Cc: Oscar Salvador <osalvador@suse.de>
>> >>>
>> >>> Forgot to cc stable.
>> >>>
>> >>> Cc: <stable@vger.kernel.org>
>> >>
>> >> Is there any bug report to justify the backport? Since it is more likely
>> >> to be a performance issue instead of a correctness issue.
>> >>
>> >
>> > OK, I thought cc-stable is paired with fixes tag.
>> >
>> > If not, please drop it.
>> >
>> >>>
>> >>>> ---
>> >>>> mm/compaction.c | 2 +-
>> >>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> >>>>
>> >>>> diff --git a/mm/compaction.c b/mm/compaction.c
>> >>>> index bf021b31c7ec..1e8f8eca318c 100644
>> >>>> --- a/mm/compaction.c
>> >>>> +++ b/mm/compaction.c
>> >>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>> >>>> 				 * Hugepage was successfully isolated and placed
>> >>>> 				 * on the cc->migratepages list.
>> >>>> 				 */
>> >>>> -				low_pfn += folio_nr_pages(folio) - 1;
>> >>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
>> >>>
>> >>> One question is why we advance compound_nr() in original version.
>> >>>
>> >>> Yes, there are several places advancing compound_nr(), but it seems to iterate
>> >>> on the same large page and do the same thing and advance 1 again.
>> >>>
>> >>> Not sure which part story I missed.
>> >>
>> >> isolate_migratepages_block() starts from the beginning of a pageblock.
>> >> How likely the code hit in the middle of a hugetlb?
>> >>
>> >
>> > OK, this is a kind of optimization based on the knowledge it is not likely to
>> > be a tail page?
>> 
>> No, it might be that most of the time page is the head, or people assume so.
>
>For compound pages, we will always have tail pfn < head pfn, so we should
>always find the head page first.
>

I think you want to say tail pfn > head pfn?

>If you did find a case where we somehow encounter a tail page here, I'd
>love to see it. And then you'd also want to make sure the other compaction
>trackers are appropriately accounted for.

I may not follow you here, below is the call flow for
isolate_migratepages_block() invoked during __alloc_contig_pages().

__alloc_contig_pages(nr_pages, ..);
    start = ALIGN(zone->zone_start_pfn, nr_pages);
    alloc_contig_range_noprof(start, ..);
        __alloc_contig_migrate_range(.., start, ..);
            pfn = start;
            isolate_migratepages_range(.., pfn, ..);
                isolate_migratepages_block(.., pfn, ..);
                    page = pfn_to_page(pfn);
    start += nr_pages;

In the loop of __alloc_contig_pages(), it iterate on each nr_pages range. And
nr_pages seems could be any positive number, so it looks the first pfn checked
by isolate_migratepages_block() could be not aligned with page order or less
than MAX_PAGE_ORDER. This mean it could be a tail page per my understanding.

Maybe I missed some point here?

-- 
Wei Yang
Help you, Help me

