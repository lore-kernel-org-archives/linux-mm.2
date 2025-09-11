Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C7FCCA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 06:30:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E7C8E0003; Thu, 11 Sep 2025 02:30:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E69C8E0001; Thu, 11 Sep 2025 02:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC278E0003; Thu, 11 Sep 2025 02:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 301DE8E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:30:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3513B908F
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:30:39 +0000 (UTC)
X-FDA: 83875995798.20.2F839D5
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id BCD16A0011
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:30:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AMV5WXx1;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757572237;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXEYcjZIAtbprlQLt6w5w3s/MIH7MOGVjxguPzaQ920=;
	b=zDqpXeqNa/LXWGpWRTGkwEgeM7VmzkR1W2OBgmUKM/Fi6zy2Iz68v5Tkn90NHvjAp6+bDZ
	XcQW87Ltty9x5nM8K8vpWClWrLKqj/Yijcj8XKIzJKXbSFdp0lgCgBzxPnnUeOYOx9BMIs
	ysmkXm4kbQqnZGpbAREQ4uaZv28mMbI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AMV5WXx1;
	spf=pass (imf15.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757572237; a=rsa-sha256;
	cv=none;
	b=tWrI5hDiZE77p3cE83IrFu8RhXnu7GZsMpWCiZTw0SFP09EqYeMGIrZNU1TDnRfGmNrnJ7
	+Qnoz1UUWHpDFJlfo67vF99mdr7txaybuyDXCOUEgBsn+u9PPMdnu/N3HBEi27s+q7dCE9
	wSs7EjsKI6EnMG8v7Pb2CawCeeDpsvg=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-b0411b83aafso48585266b.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757572236; x=1758177036; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RXEYcjZIAtbprlQLt6w5w3s/MIH7MOGVjxguPzaQ920=;
        b=AMV5WXx1kZvunfYdxDQXLET85VSMNnu70MT+Wxaxg/ARA+Z2VPYXCrskhG2tVTWzVz
         holgCtC/+YUYah2MS5pKx/RWIrJqyr4JYpvz5gOVDRynm6v0/1/wHEfl8PK/qr4zZnqg
         dcDPor/vTwY/j1kFh5rw0yPbZOcSOnBxHFbbk3de8N8+lHvHdEXg0bk1NoN4ySi4GAd4
         jOfVhCFKa3fdAoI9Yvzl7ur2NpkAkzf9dBhNzdTg0WPvlooFEJ0qqg6McwwXxp/9k/Sl
         4/DoeRX07TaAf95a4ELD/+UV8kmhUhKZrPW+oKzr132XOL7Yi5oAYhi8V1a3xNwChwyZ
         0ZNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757572236; x=1758177036;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RXEYcjZIAtbprlQLt6w5w3s/MIH7MOGVjxguPzaQ920=;
        b=KdIaO1dGan042qyJq/pr6HeszKWcpFB4j1dzfTFHtiPvK9JM5RTuvg3mtubs7gC29h
         cMymU6o1XNMT8B3wrqpnPy/7mvUdzoe5zUrunfclZaWZ4rFcTIFpO5JtjMrIMCz8TeyH
         Nc7MzJmuDq3yuCSaq2eQYHKWrkS0pgedoP0JOfmVvG7LoTcQ6iJh/jBSEvzWLt+rwzM7
         5R7TIpJnCnBhuGUUb2XcAhgGagJp6KFB8aRCD2WzJGQpB4aeR/GVSYYom38Nyj65OSEL
         jqV0aBflojseGI3WWUICMHDReHm61QyICUWaU4hfsAJoy7BUH2AxUX9m9eReGt60UMdE
         meWg==
X-Forwarded-Encrypted: i=1; AJvYcCUHOagymN9hbd1fURC5LuxIuT8gPVu4wTlIE4tHCJToTgurHsRiZLYtrXdyYFnSoCnGs5UeRCO9sg==@kvack.org
X-Gm-Message-State: AOJu0YwhaX2ZHdC+tCMhEUPsmyyYdFKZKBRvoYlBI5VPiGb/J8OKMIV1
	VU/QQImmaNiytOXcHejHDZas0RyB7UuHVfh6OzTvtWuuv7UqQ87adEC6
X-Gm-Gg: ASbGncs3g0xTpGA2gte88d2LADeLNXF2t9TOWtcRIScvSbzIRg/oEUt/i0yn+Xf6Rgq
	QvDkG4D8VylvZuui223tDZC0QgO2k0Y4ah2A9a1djRn7tUlbkj4pBDEbSGmwaLXI0qrEG23UweB
	MYBRJO9I9jX6e9dW6vxloMHrcBaQwLCYwXXAHAWZdo9mt8R/jQ261w3fo+qqmd/bP6KHGxX/lgU
	8p/2QpE49PbSO73uibT9ro2Hunt3i6CxcxZwxRWAxBR3pv0ZS5FaPwyuqw+c+sRUIdqv8lBgump
	EHtcizDok79IV+s+slwMwnPJqVx/mDeAydRHj0KfXP+dsLI7zNZKe4Oc3A0xWukHNSeQRP8M4Vz
	Vf5LB/N8EOqHadmc+aQfl1P7J9w==
X-Google-Smtp-Source: AGHT+IHZ9ZWi7XlMCg3ZcgfQhWuoIso34skiXBN5z48byGqxjy303yHncziQQ9pcqTDJOEpVfuXEOg==
X-Received: by 2002:a17:906:d555:b0:b03:bc9c:ee9b with SMTP id a640c23a62f3a-b04b14aec03mr1692318166b.26.1757572235825;
        Wed, 10 Sep 2025 23:30:35 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b3171560sm60372366b.47.2025.09.10.23.30.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Sep 2025 23:30:35 -0700 (PDT)
Date: Thu, 11 Sep 2025 06:30:34 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, akpm@linux-foundation.org, vbabka@suse.cz,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, wangkefeng.wang@huawei.com, linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <20250911063034.uafc5mmnf7k4d7km@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
 <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
 <20250911033413.qcs74q4n6n6767zj@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250911033413.qcs74q4n6n6767zj@master>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: BCD16A0011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: rg3ddr3r1pt9e55hfhn3siifam6nx33b
X-HE-Tag: 1757572237-210050
X-HE-Meta: U2FsdGVkX1/Md4oEaiVqZdRYoxK682+pWFuHNZSYvcKdqiqEKaRm15xqHOazMYsXTgcKg08f+uft8lfJ1Tz0OiuijhSxZkFA9wx5x7KmiT0xASbIOZm22NhEl74rKmN8dNCEfCOoD+CITyn+1PcXxTW0AXzQsN8o//Oky8giT043fU6qi4JeQyckWE7Wg6MfPdN+HSbQHn7oJ/ApcqHBxSYakZqSEqblmt/c+0fj9++Depaw4rpS4rIOnNBiWLHWjcRgAT8CL5Xvv8AOzMrgIxDpBoz650wG0EdP1hi3ipGdIhMnt0tmrsfrRBlOXYshDRc97GzKfbTZg1flEmXqU0291g5D9d95Aw1kbINfcn/mz72FNWJnR4yIoV7MuL4JGe0seW/w5AIvjDmsbMQfxtfyXDLrsnEpGCU9MKtFuPBaPVgI9XHTHa+0T+uHe1uafgsvcoameoTjA7jzFOrNYQXXbUMa/q8EDH1jgGeFbHzPwy0c8UrETiLjXFLLv6KHOAUvON4rJT8AL7oOmWQHHc9MWJvAQrtLVRpFbt2zniU8LbWfi636aLlLk1DnsMjSAtJ0erTyMBLFecCKXMgQFj0ruooSV/hUGYkm5dpRJ2zY6HCqIAaPUg++P4ttXhYn0I7BnuGqpCikHuOt0Z/bCKxlEKGCRCuLqu/fI55Vfad0NrdRr1QHXx5JATcPJGAn3nvlQHtCoIv2ByNhcicSQmxtPiQYDA6zjSG7vxXNt81c3jL7SpEXqCayVyIdG+sGgkooSGZi3b4JSmSHPScHZ77FCuzUF3DDP2nFH4FISB8xOA6X8D4cTBdMVHOFH2Y8Awwptv8qdxXTLXLnvj8TghxiC3WnrbmhXyV4TBAMrjzhbYirQEpCncxy9SHcxBW5vd0ubMWl0udeX5hes3Nvolcnl5ZwBPrUay+sf8J5O7/KSrfX6DpcG89hyJMRI8pzCgvuG2W2dtAOODuTHjG
 HK5TthiY
 EUVZgrZH847CzuaasCzhzHunngaNm5tYGgU1Gsn0Mu9DbNzz1DbkNn54ATOqoOO7IBdgXrIDY2v36L6N8AKFAMbILh4pml4ukrbz7jB8O689rZ7wpAWATaUqq8cVo9C0yz4/wlCmUFUehqZrBXui+tZ0xAjRaTtfMmq701gU53TFzZ/4IqGmtbfxUJwJ/jF9hz3ivZLz0fooG6+7vbWJPdSxH9K+G3UguLouFb/Q+38NwXnsICVpVE7Ukoy7WPF5Uulk+q7rTKMW6SKl63bYpRh/dCc6hlo1xgft8AnClZ/X0d0lvgtv+Vv/cvl7HREM6tvm4vdnjt6etxHz/4RDuhsfvKgGhF+lcmhzTzuQkMHZK8XQOZtf5ZBV5HKqOuIRRnek+Y5AWPu8grv54DIwmKtbHHurnYbyW8dnk1ZUc0ZwdYyjOhoeIjipkWeWqJh7f7WBlxJWJ7iYooMFoTeTpP4Y3ycXWDfmaPZlA4nFMMnL5bZbQJPp6r1IsjcVhJZu664hUnDP/ObZxF2sgMG+1CKSzt+i19Wi0y8PZaHybDpxfkDGiWhqH2fqJ3IlCP+yhf8V2bKMPv+l3E49keSgcDsIBdjhDE8riuaC3jtnFc1CITHIsp6XzsWIa7IBgTC/dL++gWmIOS1H3abrmt7rsBwFgrwvtlqaJNdQkPeMMmFL26paCpwhlLER40886eODUGs2BmkxQsfXk9H+N5xPfnVeiBgoIbI4BvWeHIcjnWHHmjkrnA9EueRPW7bBzri3pRK8yp7KRK++omqszQIRkbM0iQ54TVxCCFdS923f73NC7sIqghRxAVQhWfRtgkvFy1THMeGROTfGbV4D53SW2BnTEdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 03:34:13AM +0000, Wei Yang wrote:
>On Wed, Sep 10, 2025 at 09:50:09PM -0400, Zi Yan wrote:
>>On 10 Sep 2025, at 21:38, Zi Yan wrote:
>>
>>> On 10 Sep 2025, at 21:35, Zi Yan wrote:
>>>
>>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>>>
>>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>>>> isolate_migratepages_block()") converts api from page to folio. But the
>>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
>>>>>> to head page.
>>>>>>
>>>>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>>>>> which means low_pfn only advance one in next iteration. After the
>>>>>> change, low_pfn would advance more than the hugetlb range, since
>>>>>> folio_nr_pages() always return total number of the large page. This
>>>>>> results in skipping some range to isolate and then to migrate.
>>>>>>
>>>>>> The worst case for alloc_contig is it does all the isolation and
>>>>>> migration, but finally find some range is still not isolated. And then
>>>>>> undo all the work and try a new range.
>>>>>>
>>>>>> Advance low_pfn to the end of hugetlb.
>>>>>>
>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
>>
>>This behavior seems to be introduced by commit 369fa227c219 ("mm: make
>>alloc_contig_range handle free hugetlb pages”). The related change is:
>>
>>+               if (PageHuge(page) && cc->alloc_contig) {
>>+                       ret = isolate_or_dissolve_huge_page(page);
>>+
>>+                       /*
>>+                        * Fail isolation in case isolate_or_dissolve_huge_page()
>>+                        * reports an error. In case of -ENOMEM, abort right away.
>>+                        */
>>+                       if (ret < 0) {
>>+                                /* Do not report -EBUSY down the chain */
>>+                               if (ret == -EBUSY)
>>+                                       ret = 0;
>>+                               low_pfn += (1UL << compound_order(page)) - 1;
>
>The compound_order(page) return 1 for a tail page.
>
>See below.
>
>>+                               goto isolate_fail;
>>+                       }
>>+
>>+                       /*
>>+                        * Ok, the hugepage was dissolved. Now these pages are
>>+                        * Buddy and cannot be re-allocated because they are
>>+                        * isolated. Fall-through as the check below handles
>>+                        * Buddy pages.
>>+                        */
>>+               }
>>+
>>
>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>
>>>>> Forgot to cc stable.
>>>>>
>>>>> Cc: <stable@vger.kernel.org>
>>>>
>>>> Is there any bug report to justify the backport? Since it is more likely
>>>> to be a performance issue instead of a correctness issue.
>>>>
>>>>>
>>>>>> ---
>>>>>> mm/compaction.c | 2 +-
>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>
>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>>>> --- a/mm/compaction.c
>>>>>> +++ b/mm/compaction.c
>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>>>>> 				 * Hugepage was successfully isolated and placed
>>>>>> 				 * on the cc->migratepages list.
>>>>>> 				 */
>>>>>> -				low_pfn += folio_nr_pages(folio) - 1;
>>>>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
>>>>>
>>>>> One question is why we advance compound_nr() in original version.
>>>>>
>>>>> Yes, there are several places advancing compound_nr(), but it seems to iterate
>>>>> on the same large page and do the same thing and advance 1 again.
>>>>>
>>>>> Not sure which part story I missed.
>>>>
>>>> isolate_migratepages_block() starts from the beginning of a pageblock.
>>>> How likely the code hit in the middle of a hugetlb?
>>>>
>>>
>>> In addition, there are two other “low_pfn += (1UL << order) - 1”
>>> in the if (PageHuge(page)), why not change them too if you think
>>> page can point to the middle of a hugetlb?
>>>
>
>The order here is get from compound_order(page), which is 1 for a tail page.
>
>So it looks right. Maybe I misunderstand it?

Oops, compound_order(page) returns 0 for tail page.

What I want to say is low_pfn advance by 1 for tail page. Sorry for the
misleading.

-- 
Wei Yang
Help you, Help me

