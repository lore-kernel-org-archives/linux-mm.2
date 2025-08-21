Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 655CBCA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 01:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA2DF6B00E2; Wed, 20 Aug 2025 21:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7A706B00EA; Wed, 20 Aug 2025 21:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB7486B00EC; Wed, 20 Aug 2025 21:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CB32A6B00E2
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:09:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 686741DB1CC
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:09:57 +0000 (UTC)
X-FDA: 83798982834.06.485A951
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf17.hostedemail.com (Postfix) with ESMTP id 475D440009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 01:09:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=E6KP8aXi;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755738595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ugai3oMT+pd1xA9AQN1G7wC+lJHlwcdm3P9RGa1xruM=;
	b=xe5/lwsiFNOYZ3S372FotXUpTpgfI6SPy9+BUd199XtM9C2fD8xmSd4JNAbfuvm/ChiAgP
	u/x51VGeDiQOHovgNbxQ9Mxq765INH5R2HcN2hDJKip5xjI9e6EET3Oa44jNuBLt8rat6W
	MXTsGdY1hHT40cwdzxPw37uKJvJJk14=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=E6KP8aXi;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755738595; a=rsa-sha256;
	cv=none;
	b=WQayYlaiH2tS/aCIbY2o5rjJlH2GH/aUhZMNBq3ySBTuW6kPon0MJ5AD84G76A2AS2W/JE
	4ypb04RoVG+7KtSmJaD6OKKRaQOvL2Ew1lD061F6Jb/VDL0QNKOg7moAPv0ajPNahjp7yx
	Hij/Z6zzeZLpN/tISg7GId0KsmfwCTM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755738590; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Ugai3oMT+pd1xA9AQN1G7wC+lJHlwcdm3P9RGa1xruM=;
	b=E6KP8aXiRiJPyRRObBbi20D5GVzCQQDw2mECLsm/sgSD7FPD/t3m0sOAoicsJLsqe98x3KTZNnrYoA9hnBCsQvu6gTsWU1C+ByDAQYetCEUev34ENMwcaSGyBlI7R/g2vJ8IP5SoT+z9/loaI8InvBdqd1FIA6i0pa+hnFl0KT4=
Received: from 30.74.144.114(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmDtqcc_1755738588 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 21 Aug 2025 09:09:48 +0800
Message-ID: <d735a408-1bf8-4c43-94fc-6e3fa1068bab@linux.alibaba.com>
Date: Thu, 21 Aug 2025 09:09:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 01/11] mm: khugepaged: add khugepaged_max_ptes_none
 check in collapse_file()
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, hughd@google.com,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
 <aa2db6af6bb2124ef59ad5665951e47806c00a6e.1755677674.git.baolin.wang@linux.alibaba.com>
 <9e816c30-8ce9-46dd-99c0-e747df445be9@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <9e816c30-8ce9-46dd-99c0-e747df445be9@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tepro9iytyndez4747wmzj7tkzcdocpy
X-Rspam-User: 
X-Rspamd-Queue-Id: 475D440009
X-Rspamd-Server: rspam05
X-HE-Tag: 1755738593-573937
X-HE-Meta: U2FsdGVkX1/J7TRBWBHhv5suOkJAyUn3C+8gN+ZejdYsbKOgCVxqD/p6P9R0he2JAhFPYoCiwtCVqEw13Pll55kM2QEuflMX69VTFaMheyxMqCA7MuOtId5hsaIZ/FHKhiJuc6/GYjO+CBEGgttft1JFQvnYSN7dYChtXnJm17kHwXJDaR7NgpaPI0hpCEYVs6X9cXDU0LNx/kkncDB1ZrQw33nKW6w7iqMDtiQRgmdjaZraXHcDoJPHbVJLOFB0qV8s81S6OjCrXvCLA8YvQk0R7DAQH0Sdmt3HWwS0eY0vqdCE/cGy/IWVNDpa/hY/gLoXDFCJWnlXvya7ee/Rsih59Vwy6KeKZGgwi6TsFetfXMSMRfjBitSb2jcViITISW0fP16A7lsDShPSFnEiS0LO9bpbMczhIdq4mutKxzOIYEXcPt6xzdWHNKXzCLCu6dezdi9Mfv1J1Vbfj7nRLxR8buw0Fyp4DJMaylFj+Rwc3ix18MhfxBQnUw0qGTIfv/c5aUOmba2Hga0v4YoNUEVVPxprOHGnecE6tPyEqJWOf7JGE+HxpgVWysVrc6SJ1XX4aRwfRhfDXCPpUu+ZBY+nQnla+LVc93cVCyJSmUcBuwkumgFQSprf64ndguEmeXkcXd4Zw3g9FlnmFVcfnOQEdFZBDArVex0GSI7qMhYJiKRqqwqyeenAgJd3zaDTHADQip6aQxRPl5PYXLmBheb+Og2QwWIN0qdkytYL+0/NuelwTqJBc0TF9STaGMvQO+aYEqJ8dARaILPIKB4h8Vb7HDTcA9nZkGIkL8HCtIK1z4GQTnBbzjuzpNSmFPsgS425ruFttrbs3w/wAEnC46lXzCWfgLEw0T0twuYHWj9IUMPzaWm5kHddqW/o7UtNruEVyPXUnEn1E6z6QtkLsr5EexCvpC1uGWH4Km6KIoGvqozC+k9M02H3Umjsm5FRpIz0Ih106kGYekVS8Pf
 n3xPxshz
 c7Foi7aE+upuB7RQQIcI6kYJqSgvZTCVLjchfVPQ5pbcyPPh2qAv7Z1FpRaK6QESjjvvM7Chnxi9NO1IoESEotwM9NANn9wS0QtdVhVb9dOXMr2dOmUppr+BC5iUfhTCNWPIJPRhyHT+XvfXd2RGJ7hXu3cZ2J/ptkHwPvowZ9X8fPAgGLhxV88tqsI5e/fXlpM3sBbPTXPz9Nvo6FiwSS5DZNDEksYBLK5LJEvYIzAdF5a90IgU9HcnX3wt9tNmY3y0lct+1x7wWNGji7fLZb/y7wNUKNngS4GbBU0XSbYLpqPfnzW8kbuo1ZhvqMrZirOIiAAHqWdo9bxS3JBHCXsNXRJFo9g0YYSKoESt90RvW9+1Mc1IJZ9L6cdgsxqLN63msP05U/xBe1ePkXcLi6vOpmQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/20 18:13, Dev Jain wrote:
> 
> On 20/08/25 2:37 pm, Baolin Wang wrote:
>> Similar to the anonymous folios collapse, we should also check the 
>> 'khugepaged_max_ptes_none'
>> when trying to collapse shmem/file folios.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   mm/khugepaged.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 5a3386043f39..5d4493b77f3c 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -2125,6 +2125,13 @@ static int collapse_file(struct mm_struct *mm, 
>> unsigned long addr,
>>                       }
>>                   }
>>                   nr_none++;
>> +
>> +                if (cc->is_khugepaged && nr_none > 
>> khugepaged_max_ptes_none) {
>> +                    result = SCAN_EXCEED_NONE_PTE;
>> +                    count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>> +                    goto xa_locked;
>> +                }
>> +
>>                   index++;
>>                   continue;
>>               }
> 
> Isn't this already being checked in collapse_scan_file(), in the block
> if (cc->is_khugepaged && present < HPAGE_PMD_NR - 
> khugepaged_max_ptes_none)?

Yes, as I said in the commit message, this follows the same behavior as 
for anonymous folios, by checking the folio’s present state again before 
isolating it, since the folio's present state could change after the 
check in collapse_scan_file().

In addition, and importantly, this prepares for the mTHP collapse check, 
see patch 4.

