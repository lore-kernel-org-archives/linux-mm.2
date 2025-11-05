Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3457CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 08:11:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59D308E000D; Wed,  5 Nov 2025 03:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 574B88E0002; Wed,  5 Nov 2025 03:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48AD58E000D; Wed,  5 Nov 2025 03:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 34C2D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 03:11:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E93155797C
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:11:22 +0000 (UTC)
X-FDA: 84075833604.14.AA30FEC
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5168940010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 08:11:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762330281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v1TTb+l5MyF0rnv3WNsIm2oFonXOmodunK7YwMHmUWo=;
	b=lShRtj2p4TP/ytJF2ldpBv/kJ5zpnjN1cDA/QRADfSyGvIiy69TKxzi8P3XJXcHx9aOX3C
	TyJu4ODwRBz2lfxZR8OHslLMHhBfpYWayDGEbScKrdvPNFsOVvH2BDGfniPqicrmfI+aiC
	a7FW86RQ8n8zHsfq8Wct9ngRy8/HqoQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762330281; a=rsa-sha256;
	cv=none;
	b=J49nOowMyuFXnlFn+a8aU6Koy95yOFWTgvs4xVZPyoGfn7EW08xMpb6eACb71wT2aoUfNm
	0+R7zqju/dCXLiy6RTYeI1Tyw2vQv5hMXaCcSBn1UuZDEJBWI1mcdWg70FTCDY4pbJm9Lp
	wpz83mVXUmfK2h63IKPvHJ6TajAQGoo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4d1dLd5lQ5zKHMhp
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:11:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C21DA1A0359
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:11:12 +0800 (CST)
Received: from [10.174.178.254] (unknown [10.174.178.254])
	by APP2 (Coremail) with SMTP id Syh0CgAnyECcBgtpLFwXCw--.5S3;
	Wed, 05 Nov 2025 16:11:10 +0800 (CST)
Message-ID: <65a2097d-f23d-4018-abce-ee2936848e4b@huaweicloud.com>
Date: Wed, 5 Nov 2025 16:11:08 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: don't warn about large allocations with
 __GFP_NOFAIL
Content-Language: en-GB
To: Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 willy@infradead.org, shakeel.butt@linux.dev, jack@suse.cz,
 yi.zhang@huawei.com, yangerkun@huawei.com, libaokun1@huawei.com
References: <20251105074106.3508870-1-libaokun@huaweicloud.com>
 <aQsFLn6VDFOXuvxv@tiehlicka>
From: Baokun Li <libaokun@huaweicloud.com>
In-Reply-To: <aQsFLn6VDFOXuvxv@tiehlicka>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgAnyECcBgtpLFwXCw--.5S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJw1ruw1fuw1DXF47AFWkWFg_yoW5WF17pa
	yxC3WDZF1Fqr48Zan7Aa1ayFyFqw4rGF47GrySq34ruFy3u3WI9r17ur4Y9F18ZrykCa40
	yFs3XFn2yr98Z3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8
	ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1
	7KsUUUUUU==
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAQADBWkJ0jVblwAFsJ
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5168940010
X-Stat-Signature: knhrqhe7yupenr3mdrmj65uj7kb56n8f
X-HE-Tag: 1762330276-918344
X-HE-Meta: U2FsdGVkX19aLQ4+MM6ock1MkXcW1++konpA+HiwnH/cXXB8ydDuHH49aFWc2ovpdDUtERFdGMGS4DlVwcJqJ40tlwUWQrDyEWbpckuz7S+dU504Sc5Ibhbkjs2YJJrslrKpgi6kGSoaw6jnmsxJ2Ya7PY0FkbPetftNraD4zKud2OHC8wo1yuRi/QFM8wPrYZgxBtjsdxRDU63bdPBcpcFu2LjGoxQdiXycV8vP4Wyn/AXGAuSZ4yHcdMN1LMnRSAl0WIxyD15UR5LcTR+JiT9lNVU6xrA9DwZb6HGjT++eiT2pMW0D7CYvYMJoMSpfhToqkCciqVlJT42BUxjoLarhbhEu6FIqsCukkn6oBAt35/boxtGY+hlmWfUAy7suRn0cqQveGvxnNmfs7b8tenyKoz0zLhRGdAYPaY/oNL3SJ0SWpDlmrCkgfpf+ssWyLtAYp1CO75iIvJLyzq5l37gNY3+Eyuk8Vf69TgAKunAEScDpq7wtzwIrvGS15X3O/hXJu4pmwGMOMW3A5/XThxAgkaQQf3qQy7sd5QV3fbBnZ5NNHyB0LZT51C+NmkHWwFGwPHL2JggOM3oAMzN92vurtKNwf/N6MYmyJ9jT29KNY5x1q4ud/rbPH/QOhioSY7X+LWcW4eNfJZNzunH11lCoOa2OkMePJZLvXwQr6zBV7qzXYQIMycT2rII29Mnuu6gq8Dihu0GAlUSu2uL/1kyIBbHZxFLSUxu6V4+lOKfdBdtm7I1mtU5Pry6PJjUWzyv3P38GkF2UTq0xY5bIgwrRaiRIzIrnF95B4XZ2MdjwU7YCwrz/PDgaCwVKxj26Ms0tKEtsQkzKZ8wbQv8ASAkNy+TxQUqKgT19hIWYuE1hGIQ6zSp7CA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025-11-05 16:05, Michal Hocko wrote:
> On Wed 05-11-25 15:41:06, libaokun@huaweicloud.com wrote:
>> From: Baokun Li <libaokun1@huawei.com>
>>
>> Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
>> reads at critical points, since they cannot afford to go read-only,
>> shut down, or enter an inconsistent state due to memory pressure.
>>
>> Currently, attempting to allocate page units greater than order-1 with
>> the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
>> However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
>> can easily require allocations larger than order-1.
>>
>> As Matthew Wilcox noted, if we have a filesystem with 64KiB sectors, there
>> will be many clean folios in the page cache that are 64KiB or larger.
>>
>> With gfp flags and order already included in the OOM report, both
>> Vlastimil Babka and Michal Hocko suggested that we can take the risk of
>> removing this warning first and then observe whether a large number of
>> related OOM reports appear.
>>
>> If that happens, we can consider adding special handling in other places.
>>
>> Suggested-by: Matthew Wilcox <willy@infradead.org>
>> Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org
>> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
>> Link: https://lore.kernel.org/all/188a95ba-6384-4319-bb74-c0d9ec6c4079@suse.cz
>> Suggested-by: Michal Hocko <mhocko@suse.com>
>> Link: https://lore.kernel.org/all/aQotQBjnDDeL_wHx@tiehlicka
>> Signed-off-by: Baokun Li <libaokun1@huawei.com>
> Thanks for referencing above links which are providing a useful insight
> for future reference. I would just add a link to Matthew explanation why
> kvmalloc is not an option
> Link: https://lore.kernel.org/all/aQTHMI3t5mNXp0M1@casper.infradead.org/T/#u
> Acked-by: Michal Hocko <mhocko@suse.com>
Okay, I will add the link in the next version.

Thanks for your review!


Cheers,
Baokun

>> ---
>>
>> RFC: https://lore.kernel.org/all/20251031061350.2052509-1-libaokun@huaweicloud.com
>>
>>  mm/page_alloc.c | 5 -----
>>  1 file changed, 5 deletions(-)
>>
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index fb91c566327c..e4efda1158b2 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4683,11 +4683,6 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  	int reserve_flags;
>>  
>>  	if (unlikely(nofail)) {
>> -		/*
>> -		 * We most definitely don't want callers attempting to
>> -		 * allocate greater than order-1 page units with __GFP_NOFAIL.
>> -		 */
>> -		WARN_ON_ONCE(order > 1);
>>  		/*
>>  		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>>  		 * otherwise, we may result in lockup.
>> -- 
>> 2.46.1

-- 
With Best Regards,
Baokun Li


