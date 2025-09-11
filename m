Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7340CCAC58D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 03:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9BD8E0002; Wed, 10 Sep 2025 23:34:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C33AF8E0001; Wed, 10 Sep 2025 23:34:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFB5D8E0002; Wed, 10 Sep 2025 23:34:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A4DF8E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 23:34:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E83613A0A5
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:34:19 +0000 (UTC)
X-FDA: 83875551438.13.87FBA29
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 164AAC0009
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 03:34:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WtrzBK5U;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757561657;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rb0zJe0vJovhUfqqGUrfQ+NuRLiwkWtTgruKAWt/R7E=;
	b=AS8QD596Dsyslp6LCydSU1ZuBWWsHvDucooMie7r1cv6l+Sv/pwmlF0wN3lfNniQZ7c6l7
	QTYVfsKuhfibfRsxt+ZDA1xcp8cy3owg6IlwQmrFoMG40xx3LYjHdP21wG7GSfi+h8Bvcp
	OQksVJYcN5zVL9rMlg/dFQJZa4GIwxw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WtrzBK5U;
	spf=pass (imf10.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757561657; a=rsa-sha256;
	cv=none;
	b=cqnUkJ/jNe+NPc5aTQ+S0I2tKlC2zswFfN4ZLoDkopE2horFRRllj/fvVP7RgU5QybE0rb
	PSky6CoppLwHhHJTsbQwAjRvuN/1Ssy0y6RScwiA7Bh245PlgAIeFh/MdZz4IJKeYjxnu7
	jNatWtx5Gq1aerfwJ+GsbAKtjfDubJk=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6188b5ad4f0so394685a12.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757561655; x=1758166455; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Rb0zJe0vJovhUfqqGUrfQ+NuRLiwkWtTgruKAWt/R7E=;
        b=WtrzBK5Uq/LP798908+H+aHLiI808haqEYUXlidrkINSOlMJNDufWpgqqjuB6F064n
         0FZUjSaVmUKyET1bwV8ODJzxAwWRccxYRArXp5Kh6mH87GSaT2pwqxsa6uSGcslN79fy
         NmEd+C+hWGzo870RsKvYBi85eFB+sXaV/0aty5yDffSXHIP3GzalTvPjvEYzg93Z3ujL
         WLaU9iyOiOoqGNNv+LvViCbCEy3SzGIoiNgJR593VeWsLtXgzG1zUKJHsgA/CejNt6Bv
         K39Cwo5MD09CSQsjXKIQ7JY/afRkN13CXDnc0fxhi1iDhYvEH8EENoeGY1/vEAHpzosd
         EkWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757561655; x=1758166455;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rb0zJe0vJovhUfqqGUrfQ+NuRLiwkWtTgruKAWt/R7E=;
        b=ZMW+3bfWp1sVwJ9HdQubOTuiPmvHnP9wE0TNzfulsrMX187Z8fTK58OTKZFNx60YB1
         KCkkSeWzXLiIamvedJF3zAVLLtmxWGSJK3O8zWTfBHBM5bH6qY8P+Xuxlx0QmVmCV/Qg
         m5Zy39dx7IeIrexzkTsJeqH48sbpm6HYLWTjMjFOPsLGj2J2Txbps+7j5PUo8l6liR2P
         EZU2spdcCOT4TdXcFBVxR7ozB4u2LLtO+0DLfBYMkTzWhPTwKBKMKR6I4WnEN5bV1rAx
         szyzcjNmgKTysCf6o0+YsYM2zPw9UldAgozd0ou0s2ZF5V6jEgulkvmm3gdaR5556u7G
         3G+g==
X-Forwarded-Encrypted: i=1; AJvYcCWwkVLqqy35IO2FIT3wyejopjFSrbQtGhEYi08VFW77cx+si8ogkfQki6VVh2P4ZQd5/cufsr4VCQ==@kvack.org
X-Gm-Message-State: AOJu0Yxrf/gZT7D5jnCjApyJaVCls3OQlZEmUqN+ywHsSjIMd6n//UW7
	/xmoUVpjY2BK6QJg1Z2g0LMJ69cwXotTA8/zkkBl3T5StznckWTwR4cN
X-Gm-Gg: ASbGncvpRdhJlrNz2EDGDhOonD6xpSCPrvukTn/i6MZw95XDf8OZfAwVC6gqvX5j7t2
	C/eg9CiGNtTysHVj5eu1AAvbr59WGq4Z56ovs894umpeR0mwSDllIx2agduHgRem1Cp5vbkbvuQ
	JLTjW8qH/1EhpC4Nxs9YHe0nuLudy2LA3FK+WvfQDaOlFCZH61XlmsrZU+eP4fcGPdSSNah9VJh
	6VJsWwtxSc6eA+e8QHKM0bkgc9yhOY+7dP0rs1mJtnCnUjKlKNUXcHsVm/ZHrcBfRYN6AECg8Xv
	5aYgF7NZpZmviwil5Fd4j6T1vriy1J+pkPBCfWxhOUesC/AvN0xyyHvn7kueu18ETijTDmiAOnK
	v2MvqrMPNPhWEVEN7CBHKeCobUcy4EFcxnCX4
X-Google-Smtp-Source: AGHT+IEgEI1co129t0NP0gGmZcpuvztTGELhXYnY0Yi4dG3fo9NbgSR8Zyhugd51js9iGkUB5hFDOQ==
X-Received: by 2002:a05:6402:42cf:b0:617:eb8d:283b with SMTP id 4fb4d7f45d1cf-6237f943f04mr19449812a12.26.1757561655451;
        Wed, 10 Sep 2025 20:34:15 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ec3410ee7sm287337a12.50.2025.09.10.20.34.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Sep 2025 20:34:14 -0700 (PDT)
Date: Thu, 11 Sep 2025 03:34:13 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, wangkefeng.wang@huawei.com,
	linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <20250911033413.qcs74q4n6n6767zj@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
 <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 164AAC0009
X-Rspamd-Server: rspam05
X-Stat-Signature: zikfgxowdqanydfuaegy3zoxkmkjtcej
X-Rspam-User: 
X-HE-Tag: 1757561656-144256
X-HE-Meta: U2FsdGVkX1+7i9jUdg3jiDa2R7g2Zi58hF+4dHNu3uBQT79cGgtZXSjOjx68rFbXXj5uYRQb9WZpiJSn8xdWXFpu6YpcAN4vOdQhii3rRvl1AswN2cO9v5q5DFN7FLj2knadqD+/Kn6Cbc1IdASVl77UNbB0c2TAf/GY4FkK17WlkNtomoQC+q5f3OOTZpQBvb7q54F5xy7JnzdUCQ3mjVHmDF6ZLbk00Dtbk0vWRnViJWQwzwmIWIS6kPXGBvyeTL0l5/DblCo9acSGxVHWva4UO2WgYPcBGeD/rRM7jRoD0kiim1gkjK1MlwvCykGnPFEd58mbVAjVqbkHD9qqIIOHcyl9f/O7Nje3c8qq5BNP+afhfvWwV/mnHOlH4EqaqzBeSNCTh/qH2XvQW/591PAZZtypjl1O9REqJ2oBS5fX7K1JHyfnCk7hSAq8jdOFZjBeOJdN7lQAAQ7H2fMFbn3YsD7LBvvtdSJpyzTLzAhKqS4OuIRjEYvVMmUs/DIML9AXt7Ao0zy2w31XEfS920dTcdSdli42kn67NUw1WW13SNGSb+/dhtjfTvcw+JULfjvUafuWOPbjOhkCIYsZR9LuheCG1gebvg/SOPeMZzo/bS63w3OxiWoKvy+EQekzmIE6MIWK5ddGqcJAO3Y4Cy61VTZk338AcwnVg+iP5weAJz3vD+hVbxO9xoYYQ6IfXBT4slC7vFSUsKwiBQUJd/4g7xE+tAOsJLda69WZjynlWD9gKb/SfP7nFO/kbKtKrUsMXyqqFRVA8Tz5uUQPc1+6lU9I/QXUTxnORIts1ykTslzCl93cFgFu/E2usoDOoMhfBBUDX+iz4L8H2MuErSgMfBXnuN15QBIyLCCrwN5+L3o1QjufXf03mOegcfIc0hoDm0ko6gzECsnvIZqO3dXeLzpUlWVReSU6G5C3DNET0xu0kAg/bal/lOXV+nHv0WN8KPYLJZbgYZ7yZOy
 KOWug1B7
 kMi477XR+n8FfcAS0Mfsp6PCvz0oAepo09v3Zz+b8IXIgOS/WMGBKDVwQZlXyNzGDF0uGIQ9iKXdDd1nG+cWfw8cmrWjqT/sVBhLrvobVquVBAN5tTvc2NiZTQFEhIgTDzsFzM9Arv6DHt79nhDCeWi/UeqGMYQJnlvc80QFrEMrfumjuXQCbi7YxR2GgdejBtAZmusyZ4TD/fu3tuoG05aX6mG5NTT6JiakBonjGtub75V7I8PeDAmPJtWSpO4yC9r2kLYVR7ZzPx/WVDScc7DVcelS7+siGrn/hc+mtqIZ2qaQ0dG7TO4vY/TROhcuHhJkes8+1JTSq5t9cEnhTzMgUSode8nCYJGycJO+EbFXJAvRaj7FjgekAF5vfSnY7ig3A2kDj/4VA/lRmg5+KuJZMspDEj4r5XV5ZqgPwQK9LLo4TPfPscihlD+s9iqP2Z4mQIINlWdXcNEBrPAxyKkDGJd3wYNOCL6ujd77gwC8/eudcNt2bChtclAt1luN5aQyXTPvO69zkck73QdonkgTU6ox9aYoIIqGpjM2XYTbH+5hMOszyCBdGm704wupKIAHEaXEa6UPTrz8Jo4w2K89k0RbLbJ1ppqz1TIdKnsjCco9klt8Z27Q8tdphTejQ5Pv/Ue7zaFG3z+LRnPuXnui+Fu2HFAirjKpwofXHCUYbvXLoWVd5FLDqnfff3lyvxYU7oEZI4MWORreFDT8fZgkcCOvHUcmu9Czo9Eciej41HQJ6g/0t87QdDxg/JwHzwohz3MLHrMpojVyOJPAS/JJ4CcwW3Q94KWJ97X7gZ9KVsqvvXGzQGk5C/C0+bdGhy6jVnDXpDUCe31J/Uk4hSgjU2w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 09:50:09PM -0400, Zi Yan wrote:
>On 10 Sep 2025, at 21:38, Zi Yan wrote:
>
>> On 10 Sep 2025, at 21:35, Zi Yan wrote:
>>
>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>>
>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>>> isolate_migratepages_block()") converts api from page to folio. But the
>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
>>>>> to head page.
>>>>>
>>>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>>>> which means low_pfn only advance one in next iteration. After the
>>>>> change, low_pfn would advance more than the hugetlb range, since
>>>>> folio_nr_pages() always return total number of the large page. This
>>>>> results in skipping some range to isolate and then to migrate.
>>>>>
>>>>> The worst case for alloc_contig is it does all the isolation and
>>>>> migration, but finally find some range is still not isolated. And then
>>>>> undo all the work and try a new range.
>>>>>
>>>>> Advance low_pfn to the end of hugetlb.
>>>>>
>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
>
>This behavior seems to be introduced by commit 369fa227c219 ("mm: make
>alloc_contig_range handle free hugetlb pages”). The related change is:
>
>+               if (PageHuge(page) && cc->alloc_contig) {
>+                       ret = isolate_or_dissolve_huge_page(page);
>+
>+                       /*
>+                        * Fail isolation in case isolate_or_dissolve_huge_page()
>+                        * reports an error. In case of -ENOMEM, abort right away.
>+                        */
>+                       if (ret < 0) {
>+                                /* Do not report -EBUSY down the chain */
>+                               if (ret == -EBUSY)
>+                                       ret = 0;
>+                               low_pfn += (1UL << compound_order(page)) - 1;

The compound_order(page) return 1 for a tail page.

See below.

>+                               goto isolate_fail;
>+                       }
>+
>+                       /*
>+                        * Ok, the hugepage was dissolved. Now these pages are
>+                        * Buddy and cannot be re-allocated because they are
>+                        * isolated. Fall-through as the check below handles
>+                        * Buddy pages.
>+                        */
>+               }
>+
>
>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>
>>>> Forgot to cc stable.
>>>>
>>>> Cc: <stable@vger.kernel.org>
>>>
>>> Is there any bug report to justify the backport? Since it is more likely
>>> to be a performance issue instead of a correctness issue.
>>>
>>>>
>>>>> ---
>>>>> mm/compaction.c | 2 +-
>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>>> --- a/mm/compaction.c
>>>>> +++ b/mm/compaction.c
>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>>>> 				 * Hugepage was successfully isolated and placed
>>>>> 				 * on the cc->migratepages list.
>>>>> 				 */
>>>>> -				low_pfn += folio_nr_pages(folio) - 1;
>>>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
>>>>
>>>> One question is why we advance compound_nr() in original version.
>>>>
>>>> Yes, there are several places advancing compound_nr(), but it seems to iterate
>>>> on the same large page and do the same thing and advance 1 again.
>>>>
>>>> Not sure which part story I missed.
>>>
>>> isolate_migratepages_block() starts from the beginning of a pageblock.
>>> How likely the code hit in the middle of a hugetlb?
>>>
>>
>> In addition, there are two other “low_pfn += (1UL << order) - 1”
>> in the if (PageHuge(page)), why not change them too if you think
>> page can point to the middle of a hugetlb?
>>

The order here is get from compound_order(page), which is 1 for a tail page.

So it looks right. Maybe I misunderstand it?

>> Best Regards,
>> Yan, Zi
>
>
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

