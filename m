Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C04F8CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 13:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85FFC8E000E; Tue,  7 Oct 2025 09:11:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810928E0005; Tue,  7 Oct 2025 09:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726B18E000E; Tue,  7 Oct 2025 09:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B1118E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 09:11:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF3571DCE99
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:11:53 +0000 (UTC)
X-FDA: 83971355706.16.A48E708
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id CE86A1C0011
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 13:11:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759842712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HsnjIEpg+WFxBPVBaFpvOv9FLnmBcNhuPtI8pxBAck=;
	b=sD8jTOCLJYDsVL9qaBJItzN80EeSuLr/Dt3DUBd1AG5Nww4UjUKmGTbkUVl662g2AfjKAq
	aXlzXCexWcqhkI7kFpMBfPyEnZlDHgworVvqpsuobC1DkNh/zNQ6QQFQlPAfmj5IiWVIlV
	wwrSLdpif2RduX0in2O1hCio8E3utaA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759842712; a=rsa-sha256;
	cv=none;
	b=Sj8mWT2IRmIm1nIiyQJgFkxntp3sullr2qiBvfbbGgC3ICgKx51DIb0gG4jJuFEUdjiVbG
	B9OUrD2uJBHTYEONKNrfikKRZeszrZViNgqSiNhD2Becxau08jMix+TYcGUHDD88hAxOJT
	TnSaDtR/cy2IVpa1Y0Scb4XcFdowVSc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAF521424;
	Tue,  7 Oct 2025 06:11:42 -0700 (PDT)
Received: from [10.163.65.24] (unknown [10.163.65.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 372683F66E;
	Tue,  7 Oct 2025 06:11:44 -0700 (PDT)
Message-ID: <b2a474e3-58a0-45f1-8015-46b30c2d0660@arm.com>
Date: Tue, 7 Oct 2025 18:41:40 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] mm/khugepaged: unify pmd folio installation with
 map_anon_folio_pmd()
To: Lance Yang <lance.yang@linux.dev>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, Usama Arif <usamaarif642@gmail.com>,
 baolin.wang@linux.alibaba.com, Matthew Wilcox <willy@infradead.org>,
 david@redhat.com, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
 npache@redhat.com, baohua@kernel.org, Liam.Howlett@oracle.com,
 ziy@nvidia.com, akpm@linux-foundation.org,
 Wei Yang <richard.weiyang@gmail.com>
References: <20251007005022.24413-1-richard.weiyang@gmail.com>
 <ed17533d-912c-46a1-8407-29fd989f22b3@arm.com>
 <6253b463-bdbf-4c79-b1a7-65860b76beb4@arm.com>
 <e0566f96-09f7-406a-8c7f-da6dc476cd60@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <e0566f96-09f7-406a-8c7f-da6dc476cd60@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE86A1C0011
X-Rspamd-Server: rspam02
X-Stat-Signature: 6eygna98uctmwe5fsdfn85f1xq38wjmr
X-HE-Tag: 1759842711-926098
X-HE-Meta: U2FsdGVkX1/kd0QwzTiwxCa0U8yoR31Sb1T7RbAdqK3rQp4MzoI3YCCRnTuVmk04Rdz78tic6nZS92ZETnpjHtTE+kqH4cv3heKipagrpeKSS5UmX6iddfPgyEb5HeYmYGSFtV8aybqfMHXbt+TSgvKzquzq5bAdieD7UZObjSgxOlZydMzLEm9jTe7BZbEKfeoq6sE+5PdiybSTgH+bcf5gJBRy0DDviA/01ltrZ9GIL1b5+rwT0a1eie0gqHD9/Kae504iV7YU8o2wTssewZ0aLeBRqpl9oV1GDtSa8aqkfVDziGX836CADsV3231ti3/md/cw8pO1z4cx7+3HAbHpaFpmAPbgk9NeGb1iLNd7zTYBtpBcCTK5xMtbuBswwSuGJkTXRXC8v7AH2Q7GBx9Se5/0XvyLU30OJ3NEvSdSiifrhu2RWgLpSiJS2O1WtsUOaBdAELlDwB995uDVUTl/IfQOtT1yv1x0Vyax68mu/cBpcKaZlToVrx3FkHmOiBVqLgKg9geVTn+CbjovAghYJz6L3FUgRTKnr3yw7a07c/E7nuOwAzA/HqDdMUQhikfib1ggHDoYMrnExOk5hcn7edHxXgUxuVWSta4qroXMHkwP6tiuangw4DrM33j/UdMEK7jMrjZpHVqNnXva8Q0OrJZbtQhcgVDfTE7Vq8IEyub1VsE5PaB7tUIwhFQojmMNS1smlyHnn6EIOeCyZ+5gm8qgJzDldctEUY1uj+44mgZpzJufMPCnxbgVzyYok+ha1O0B0TBrcPjRedwVll20jt/PkheWxiD2E7u7s5upSmj9M0MmqDyMu5yH4gsGqqjOTTbnTqzcXKWJjZne1wLVeS9i/deMCtb2Mjwf6r5adVRLgWqm56pj6usG/LWmIfqp/qxEWStPHnllUYFXJA8ETTyrGAblQZ5Ma76Jtyf+hIU/EqDnIno/HzzxVydz7RniEBH8l28YfNGXJC6
 Wwkiqms/
 oXLGFwrSoJcIp+emi77KqvHDo/YUCpeP0lKBQOvH+CLwHyGzIGpdTZLMusd8AfDX79RTAkoTCWOhiH65qw1dCi7VNX8pHh86aq7EADTS7LaEZ6GaQgQMTCSQYAjIMSZZn9um50kYPWd/lvuGhzAM8FNKpwbwwYfXUXNoKCBw2tk1HIGqO7prCJ5No98IhybCvCTcLB7YxVDfjJ9LeWss9WSSQiBSxTG9RPnx3u8+fUPuYPqtxNGGUCx+Oy4y3VYKF8DSqW8XOVKiqkVbyV/0E9h+LWrGq6m2SW+mOQdYWsYpg0Z8CWnIQuo4dsMZeqyvJdl4JIb2jvisd8959uJQUmSNmuFsDUQhpnMrfO/a4KGZFbkyeAI7PqiChi2seRBSVz7zUNfJ908gP17XQzq4lfljVAykhXcBfEL6RQrRNE3Db0MDtnKQ3dkeSCCNYXA1b1xoi2jniVIZYLihCq54exX5rU5gqmoMhU3DiX75Myrx5AD8vc7TFVDsvOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/10/25 5:54 pm, Lance Yang wrote:
>
>
> On 2025/10/7 17:54, Dev Jain wrote:
>>
>> On 07/10/25 9:36 am, Anshuman Khandual wrote:
>>>
>>> On 07/10/25 6:20 AM, Wei Yang wrote:
>>>> Currently we install pmd folio with map_anon_folio_pmd() in
>>>> __do_huge_pmd_anonymous_page() and do_huge_zero_wp_pmd(). While in
>>>> collapse_huge_page(), it is done with identical code except statistics
>>>> adjustment.
>>>>
>>>> Unify the process with map_anon_folio_pmd() to install pmd folio. 
>>>> Split
>>>> it to map_anon_folio_pmd_pf() and map_anon_folio_pmd_nopf() to be used
>>>> in page fault or not respectively.
>>>>
>>>> No functional change is intended.
>>>>
>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>> Cc: David Hildenbrand <david@redhat.com>
>>>> Cc: Lance Yang <lance.yang@linux.dev>
>>>> Cc: Dev Jain <dev.jain@arm.com>
>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>> Cc: Usama Arif <usamaarif642@gmail.com>
>>>> Cc: Matthew Wilcox <willy@infradead.org>
>>>>
>>>> ---
>>>> v2:
>>>>    * split to map_anon_folio_pmd_[no]pf() suggested by Matthew
>>> On which branch this patch applies against ?
>>
>> +1, does not apply on mm-new for me. There have been multiple patches
>> changing the same file so it will be beneficial to say what commit
>> it applies against.
>
> I think this patch applies on top of the patch[1], which is based on 
> mm-new.
>
> [1] 
> https://lore.kernel.org/linux-mm/20251002013825.20448-1-richard.weiyang@gmail.com 
>

Thanks, but this is not yet in mm-new. There are some unaddressed 
comments there.

Wei, please resend this patch based on mm-new. I would urge you to hold 
off sending

multiple patches all of which change the same file and have close 
dependency, till the

first one gets merged.

>
>

