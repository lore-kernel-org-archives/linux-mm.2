Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F6ACCAC58E
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 00:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4528B8E0002; Thu, 11 Sep 2025 20:29:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42A1F8E0001; Thu, 11 Sep 2025 20:29:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318838E0002; Thu, 11 Sep 2025 20:29:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFE18E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 20:29:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BFD7A86D32
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:28:59 +0000 (UTC)
X-FDA: 83878713198.17.02481A7
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf09.hostedemail.com (Postfix) with ESMTP id B53B014000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 00:28:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PZabL3YH;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757636937;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASdPZSSSXAdXjHSoSiY28vR4LCE2ELnT4FVMhx13pKY=;
	b=b5XotPfZ2DmW2V8WdoJBhGzG+YFGzOX9ypfGmCNmX3QllxxFoke/5vGjr3x+I7HTcsI12x
	9k8a3axGm3UwEH+rTu3U64Uh7YtigRH9g9ZcZ1/5JIeAJ8kMaUeEv/Kimbh6gWj1vNHmpT
	rKCoyJFGBOskY2BkPLvNlzCe0WlSTpM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757636937; a=rsa-sha256;
	cv=none;
	b=L5UTTYw02CEGIFAY4xmnryT+FsMmtJe23MghSjHdlyDR+wuVvSjj7OQ5gLgDfDA2fSxAyt
	YOrdfWggIriOkIy4EGs7hFCk2Zyw8Cpg6MA4UKuaWQmiN8WZO5/1fiLVTWZL/sUMQNoZRm
	8j4PGDVy5pHTCri4OxKUdk4hd0rTwFM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PZabL3YH;
	spf=pass (imf09.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-62ec7fe6e35so2368043a12.0
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 17:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757636936; x=1758241736; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ASdPZSSSXAdXjHSoSiY28vR4LCE2ELnT4FVMhx13pKY=;
        b=PZabL3YHdhoVFs4eTneLSjQqfoobiSblAdYNrZwaNW4Z++yalHDv/vXPaHsJS1XH4T
         06zhYuJDL7lW0w/HJd1zKi995pZ1vRewq1a4QZgE4ZF5gkkasepOHBNkdP9RHPIQ2yti
         yx7144w0820dhn50UC73KEtKipQiIPRRVjo8rLWyXyaekp3XAk6kPVCHGwi2n0lSylcc
         uTCSC9L5CrDvWke8KjDhjcGsDtKzjlsiEMy8+m6ZqntnpdhhaAGd252mxXIHP29B5/0k
         YX9cIPBNKMvA57v88U/yPM86tAlQd509czn1bjMOLGqJTBWHmqVlwcVTlkyawQg1kc/B
         BrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757636936; x=1758241736;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ASdPZSSSXAdXjHSoSiY28vR4LCE2ELnT4FVMhx13pKY=;
        b=n7hXfnoQ2tbN6B+Vwn0u+KvcRO0bU4CjBSaXohcF+NijVzIYHnYpOm5hJRWu9ao01l
         fx9tBn/zquFUIeXnV7XcXnXWpRBGPP/sDJkvHKPgs+wqsaq9Rrv3wjz/BSH5J33OPGnC
         hbBXZ/h9x5WlhWwKeWqXQnaoS2MkXfGXBJShpe0++T0eMbvDwmLVVOjZqopVDTcbmxtl
         kmEYGuxLZXhQoOVaeIlVhAGLy9N6yNYX8eY/iwx0xExjKYWbY/rVbATFzXhHYEl1zrNE
         gzDosMAd+JTm33Cw4Je93ff1OsDXdwqkZ+8vq5XlqbYezgG9g3QwGJftK0O2wmwJzUMQ
         nPcg==
X-Forwarded-Encrypted: i=1; AJvYcCU4aG0tgebZM5KlkT2HF08y9gVfXNGVmVEqj93+khosLGHcTistmPD8NJ4X1gXsN7REgCyPMRuxBQ==@kvack.org
X-Gm-Message-State: AOJu0YwYCe8RTQwGd4utmGEYjIS7Ipg0F2ftBSM5bli59/PxZRb6Gxef
	1hnJnvI+A7a0oLC2sHCepoJv4rUlczHq0WZD0dROygT6yRV5PiJfWlvj
X-Gm-Gg: ASbGncuao67n+mpOggmBoSrYrMNh9brptx6ap+nsM6XTenDyKChMZL/pS4cfDoc/t4d
	5yqQLrujn/f2XhtsI9+XVXJAHb7/JAiYLCvvAhD0Jjb9UD2CEhrdagLN5WS1Y2/SvzcWEDIJUUt
	762CJN9d3CoTbXjqS80LxueyoRplc+G1LkFtIN4TtY1CODjV9GUnDKUwS7Vpuiu0PmRzrJIMPh5
	fexvamVqjEUx+WNPNTUNZja15UsTLNnElykRBnnwdeBNsW7ruZO+eVXaE6Figns17wd3SINtL2D
	9oV49jeq7uT+QfAfMH+7HAaYugDPFmhywq5yNTowJ/VrU3n9L1uw0Q25oUcPMhH3bIPmapyCMFY
	Ndyozsmgc9Nm1wGTk6n9o7YfKns8auCp4eO7x
X-Google-Smtp-Source: AGHT+IFi2FY351hze3vPhPcLZZaHjPrNG+mH5MMCCUmJBntlvXiBAh0dcPEDPnIrYwXB+v1WXDTKTQ==
X-Received: by 2002:a05:6402:5114:b0:62c:6a07:97d7 with SMTP id 4fb4d7f45d1cf-62ed82c4019mr1286645a12.34.1757636935849;
        Thu, 11 Sep 2025 17:28:55 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-62ec33ac2c7sm2003030a12.13.2025.09.11.17.28.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Sep 2025 17:28:55 -0700 (PDT)
Date: Fri, 12 Sep 2025 00:28:54 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, wangkefeng.wang@huawei.com,
	linux-mm@kvack.org, Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH] mm/compaction: fix low_pfn advance on isolating hugetlb
Message-ID: <20250912002854.plq5uhy432xq6puv@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250910092240.3981-1-richard.weiyang@gmail.com>
 <20250911012521.4p7kmxv46kwz5fz5@master>
 <5F7DCC9D-4CA2-4BA2-9EA8-F04C3883E289@nvidia.com>
 <EBF646E5-8A7D-4115-808D-E13033240659@nvidia.com>
 <2A28BE8E-E62D-4ED2-8A35-759BFAE4C52C@nvidia.com>
 <20250911033413.qcs74q4n6n6767zj@master>
 <20250911063034.uafc5mmnf7k4d7km@master>
 <EBA618FC-889E-48A1-AC02-9A18F6B5943E@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <EBA618FC-889E-48A1-AC02-9A18F6B5943E@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: B53B014000A
X-Stat-Signature: n8q981tkb46rymmdygt6oi8998fmhqdm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757636937-89845
X-HE-Meta: U2FsdGVkX1/5f9VnQS9v1EmWDEFXXPsEoVGnQYBox4qXDC4tqUj2syP6EU+CdxOm65M/8Sqq+Jz5aD2G72nN7iOXfMTUlV60/4+Cvg0MXOqCcpjoDGgRin1fgrbC3ZeY0y4JLYzM70Vrfc8FPfs9J+rC44U0s0tH41er7WyaI3P/TSwqtG1dSaPkJ4KvMBfQndoIc5AeZtmfkNs38ATqN8yrgJPvI6fG7wvVi3QhUwus3FN7YWHZfl0+c7veg4H1GzOsjaJA/+Xxj15M4f5Hv0tnm7Qb27pQ/8xtTyVWL1o1Z8NiMXAM+b/DQ9ICXUm9dmcobc++TFGxCWzztVaVxf/+E4tZtst7DSwNi1W5zqlX/6CsfeA8QW68pzlRQS9Je2+7VHm9C0lrXZIpkZmh5KQ2RZSBa3NYPelW0DZzW9xwLUF1GTTbAkjhiVXEg5L06asejxW4UHKr9WjJbtv5/Kkmzy/uLqBqnUksfvz7eeeJ5Z8yzypzB7uyGRMmtQ8A+eACcETE9bCmWXGCHRRZ5MEeQymxaj+YNvMfG/ajTYP8Oqrpjly3+Z7bfHSG8ywR4rO0sMiQ5l0H/2vTm0/ZHbnms/qvkBzxf4oy/lkAzH7ztBPfu/cft3Uso9jRg7Yunib/vcoac26PH9jJ1f2Vs82dk34O7HYML+4Ng/1bdClrFiv7aPM3F5ntz1VFyzXbGlHB/kDMI/6TJ43uBc7K7FMPgLKYDNOeA+/4eOwkr+tAtyboyQAACWy/uJmkKLTGp0ch2peyH9X7tCbGurwAC7Ul/Cf+ChVNVf8Bg4SDFoduf6wjqxCi4uE8nhlmaCQUGX2p3gRzXl0UM1e2RyTrMLwTPcsXl3Uu1GVeewE0roxnSPJxFIMTOe2pUItjJwgd84ho3BGam6dSnaGKAfp8Vb+YPxbWT5ZWwzbIf99S51bhMTzFr3OwpRXkUKBhHRob/X6E1JOtJsU0Tbcqbae
 Ucx4ZP0x
 oFbQH6549eQw4pdWq1VbVHivC3ikT3Zb99SH4YLLtM41dSenXr40Fa1vv6EvGf/9Ix/kb1e6dMxEK7rB9gFtVcZzqhOu2u3bERcBDmQCVUhWzOXE4axtJ+1yxIEbAM1Wco+mYDXJQUvQrLAInl39r+LSZNbGPhjD6xYvzaz4y2LhqkEBXj8OGuHWeHPxu5X79QhYcrkK2e3AoHSVP9rLHw4LTMBqPOzDwcaGq0ReqkXSPurcO6onVPi+cCO3Dz01Db5GLBo6fyEkBXYORsKi7VUTMbKdIeL6SuwjbY0qKqHdB1D/4P2ofAQXxrxifhgwqj3bSQssAFSGtsheZJZm89UezexVjhFpyjWGHnFn5sB6NcRuKWNyuiT+RFV7YmXJ1Alek9vsu8ew4GOnBONUtGuIVMu4U7qJApXSw01fn75PXS49quYBGEKNsEKbfxggqWxNXEJ4sBjbiSdGQTqp5RyqUQg6MZL9cK3LNiBhh8xQi0iEjzrwn+y8jFKL2bvV/oukFL6RoDfLNQkcmKdLSrvhn3D0aPQuPm7nYLOQVMQPIyGFbSmdi7TM+83xp3mAkH7PlwGTdwUloO1TsAQOgp7LRsUQPeIe2PLRn+zl2tWn+cR1/8/VFZSXY+b+IttG1hrDxHsrgJs4VY1X3Z7Kd+UIgn1wHnxZnv1MRen2hD2xqzg9V7AfiTK1H56e+kTJ0BY+C4IJEMEMCJMQuI6zaCxzVNSI0grL6DicQ/4PLqZayqYgys/CTN7nt194dWm5N49qpYt4Tbvjqc3o9ueZ4jW8yUgGi5Xda/b+UTMnA52pDg39A+YXbqmc2/W3m+eyz6VqCloOZA6HeWjtJp9nyFN6uFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 12:28:24PM -0400, Zi Yan wrote:
>On 11 Sep 2025, at 2:30, Wei Yang wrote:
>
>> On Thu, Sep 11, 2025 at 03:34:13AM +0000, Wei Yang wrote:
>>> On Wed, Sep 10, 2025 at 09:50:09PM -0400, Zi Yan wrote:
>>>> On 10 Sep 2025, at 21:38, Zi Yan wrote:
>>>>
>>>>> On 10 Sep 2025, at 21:35, Zi Yan wrote:
>>>>>
>>>>>> On 10 Sep 2025, at 21:25, Wei Yang wrote:
>>>>>>
>>>>>>> On Wed, Sep 10, 2025 at 09:22:40AM +0000, Wei Yang wrote:
>>>>>>>> Commit 56ae0bb349b4 ("mm: compaction: convert to use a folio in
>>>>>>>> isolate_migratepages_block()") converts api from page to folio. But the
>>>>>>>> low_pfn advance for hugetlb page seems wrong when low_pfn doesn't point
>>>>>>>> to head page.
>>>>>>>>
>>>>>>>> Originally, if page is a hugetlb tail page, compound_nr() return 1,
>>>>>>>> which means low_pfn only advance one in next iteration. After the
>>>>>>>> change, low_pfn would advance more than the hugetlb range, since
>>>>>>>> folio_nr_pages() always return total number of the large page. This
>>>>>>>> results in skipping some range to isolate and then to migrate.
>>>>>>>>
>>>>>>>> The worst case for alloc_contig is it does all the isolation and
>>>>>>>> migration, but finally find some range is still not isolated. And then
>>>>>>>> undo all the work and try a new range.
>>>>>>>>
>>>>>>>> Advance low_pfn to the end of hugetlb.
>>>>>>>>
>>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>>> Fixes: 56ae0bb349b4 ("mm: compaction: convert to use a folio in isolate_migratepages_block()")
>>>>
>>>> This behavior seems to be introduced by commit 369fa227c219 ("mm: make
>>>> alloc_contig_range handle free hugetlb pages”). The related change is:
>>>>
>>>> +               if (PageHuge(page) && cc->alloc_contig) {
>>>> +                       ret = isolate_or_dissolve_huge_page(page);
>>>> +
>>>> +                       /*
>>>> +                        * Fail isolation in case isolate_or_dissolve_huge_page()
>>>> +                        * reports an error. In case of -ENOMEM, abort right away.
>>>> +                        */
>>>> +                       if (ret < 0) {
>>>> +                                /* Do not report -EBUSY down the chain */
>>>> +                               if (ret == -EBUSY)
>>>> +                                       ret = 0;
>>>> +                               low_pfn += (1UL << compound_order(page)) - 1;
>>>
>>> The compound_order(page) return 1 for a tail page.
>>>
>>> See below.
>>>
>>>> +                               goto isolate_fail;
>>>> +                       }
>>>> +
>>>> +                       /*
>>>> +                        * Ok, the hugepage was dissolved. Now these pages are
>>>> +                        * Buddy and cannot be re-allocated because they are
>>>> +                        * isolated. Fall-through as the check below handles
>>>> +                        * Buddy pages.
>>>> +                        */
>>>> +               }
>>>> +
>>>>
>>>>>>>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>>>> Cc: Oscar Salvador <osalvador@suse.de>
>>>>>>>
>>>>>>> Forgot to cc stable.
>>>>>>>
>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>
>>>>>> Is there any bug report to justify the backport? Since it is more likely
>>>>>> to be a performance issue instead of a correctness issue.
>>>>>>
>>>>>>>
>>>>>>>> ---
>>>>>>>> mm/compaction.c | 2 +-
>>>>>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/compaction.c b/mm/compaction.c
>>>>>>>> index bf021b31c7ec..1e8f8eca318c 100644
>>>>>>>> --- a/mm/compaction.c
>>>>>>>> +++ b/mm/compaction.c
>>>>>>>> @@ -989,7 +989,7 @@ isolate_migratepages_block(struct compact_control *cc, unsigned long low_pfn,
>>>>>>>> 				 * Hugepage was successfully isolated and placed
>>>>>>>> 				 * on the cc->migratepages list.
>>>>>>>> 				 */
>>>>>>>> -				low_pfn += folio_nr_pages(folio) - 1;
>>>>>>>> +				low_pfn += folio_nr_pages(folio) - folio_page_idx(folio, page) - 1;
>>>>>>>
>>>>>>> One question is why we advance compound_nr() in original version.
>>>>>>>
>>>>>>> Yes, there are several places advancing compound_nr(), but it seems to iterate
>>>>>>> on the same large page and do the same thing and advance 1 again.
>>>>>>>
>>>>>>> Not sure which part story I missed.
>>>>>>
>>>>>> isolate_migratepages_block() starts from the beginning of a pageblock.
>>>>>> How likely the code hit in the middle of a hugetlb?
>>>>>>
>>>>>
>>>>> In addition, there are two other “low_pfn += (1UL << order) - 1”
>>>>> in the if (PageHuge(page)), why not change them too if you think
>>>>> page can point to the middle of a hugetlb?
>>>>>
>>>
>>> The order here is get from compound_order(page), which is 1 for a tail page.
>>>
>>> So it looks right. Maybe I misunderstand it?
>>
>> Oops, compound_order(page) returns 0 for tail page.
>>
>> What I want to say is low_pfn advance by 1 for tail page. Sorry for the
>> misleading.
>
>OK, that sounds inefficient and inconsistent with your fix.
>
>While at it, can you also change two “low_pfn += (1UL << order) - 1” to skip
>the rest of hugetlb?
>

Sure, glad to.

You prefer do the fix in one patch or have a separate one?

>--
>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

