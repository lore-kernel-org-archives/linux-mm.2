Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0D13C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 11:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FA1A6B008A; Tue, 14 Jul 2026 07:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AA716B008C; Tue, 14 Jul 2026 07:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C2DA6B0092; Tue, 14 Jul 2026 07:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 415D26B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:17:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C45631C0314
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:17:42 +0000 (UTC)
X-FDA: 84987131964.07.4F81B79
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id C21074000B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:17:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=evQYv6xu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784027861;
	b=TEQWVnNMNXGOsbPMgD8A92rwES0CL5Xq/RCK+6DzEVbgxt3lfKDTKOeLYspKPLeTNSWpTU
	b7g5/OC4efaigQlbsp1w2ffuO3kmWPMCD5kJb+QP7fXzSJmWcS/eUAeHGJ9lOKwGGUlGlA
	HpjvTATUQxn3q7AmWMY4HxQe6ewrKLM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=evQYv6xu;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784027861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zat05qqxvwp6PrsaOLc8teu3wR1nzZI50WFld5IE94E=;
	b=mvWWAXvWrSKavFz2rqKlOIxXeKdLSEyfzuobrJlM6rUpkVOM2CBihc/0HD5n/JmjnIOm2G
	ywQ8dPnZHJHGGinZWaana1qISfrbgWw8yiIu5n0443PC4lLH0ybdyWyswESoBllpK/I5i2
	pz0kcmSw5+etHprYhmuAp16/YTHWdRo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60221497;
	Tue, 14 Jul 2026 04:17:35 -0700 (PDT)
Received: from [10.164.19.52] (unknown [10.164.19.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C36883F93E;
	Tue, 14 Jul 2026 04:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784027859; bh=R2SemUfGDaxIvvuhVsUSqWTCbeV4a24xddbL8Y2wUhU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=evQYv6xufZcgX7C01IfbaWPF1KL5BXIRm6RemT40GvFByo89ShBnyYxaRdbWtgdR4
	 6uwMLKuHrePOTAGGp16GO0SYsIj2itt6cgaLOmrIB935g9LczD611XLlLKDioQB509
	 0k+am8MDEo3T9w7WyLpdalRhKIQAUOmt0DWnvppE=
Message-ID: <a08e2a7b-2ab8-4429-8d4d-9c13b6a2a77b@arm.com>
Date: Tue, 14 Jul 2026 16:47:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Anshuman Khandual <anshuman.khandual@arm.com>,
 Wen Jiang <jiangwenxiaomi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 Wen Jiang <jiangwen6@xiaomi.com>
References: <20260709073823.6643-1-jiangwen6@xiaomi.com>
 <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
 <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
 <929dedc2-eea3-4153-be6d-d2dd727fed89@arm.com>
From: Dev Jain <dev.jain@arm.com>
Content-Language: en-US
In-Reply-To: <929dedc2-eea3-4153-be6d-d2dd727fed89@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C21074000B
X-Rspam-User: 
X-Stat-Signature: ame6ox5dpenh7nfmj7ff3i85k8oa36xm
X-Rspamd-Server: rspam03
X-HE-Tag: 1784027860-731848
X-HE-Meta: U2FsdGVkX19rKcwVpxRB8zKX1eDvir6LKIe7LQBCLhGOEAEYqVXX3dvVlu4joVm76jnh4Q3ullycNU/eJG4i2JZgW9wfHuwEQlVYw4o9C//WyINR0gvNY9TRDWdmxM4QFdsUXxODKdXit2SD2zqvw+ni6/7DZ3060rmSwYLp+rk7da2ZGKtcvGq0QGsnAAVmyx+yb64MKJduTaOFW034ss9wkH1M2VBYv7ITjKdyJqzi3dzpOqvOaNdA8F3wA/ODXLNyCkTvhjECM+UiVEVKr8TEamerfQ2L6hE8LTWCJ332PszXgpLSKTIpqWMbRzh9wb6oHciHUOTDANy6n6xMCTMLdr05Olg4h/HzLQEMaqwNxoSxkMp9Pyvy5n46tkY7Or4V7cxL3zBf+jDFY/PEzyjkHoQxLlS4Ypn5JQZFHvbo1BfxTvgJ+4g5rdVvk2zGur9YNn3DTZNfoBu2smF3BqmbHML5w7/DGyv5tcFzzfrkOlenlwRn66pJgaUjEhYXnb4WOhwAh3FCWR+4dilVQ4WSXmkE8jlETL6qMcltI9TGXyrPWrirBB9iMDyGRP9SDCyv/rKwuaF/kd+H6VjAl07jtXpW+8MBIc8qyisFr/gIqEI7Fc3GCzrgunctjR7NGK6pYIswEVQwSgGZeZHBpgelRHgDrc+gQ1usIOChD6i6Np8z2qDTJXDAgGf5mT2br/m6F7Nxggo2RZNVTt+tu7r1zUkC8qbfe08ldTZryNT6lb38o2vSmEfwcfvmiJ4nrGtuDrFA0QtLHl0RaCjnsadNtuJ5ychrCQLRDaDvjK6xDeRg/eT+7MlkigbHMQZBhYDXgfxNMlvU9Fc46Kv1fJcCVXOl+huulM/i8RRWCh2QOuvI8fAiKt+Ev4FcInaRiFZELkiXkNvUd8qqOa0t6oCQbt8wWHLaHH7sx0Fg5cg2ZqW1ZDR7ARih2xlh8R0WQMCoxSSFq0fMdqO3pYA
 Xp8tc7TT
 tuf9mNBRSpwX3fUKUo8/ClQXDHhXf+3FjKrMQEzAbMKBRf7+NrkEzV/hDB/8irvRc/pdzWexTvifvMleJ7D3c21D1YxEBbyt6HZIAg+3HSCrpc0FQ97m/e7jZQPDS/3fsuqFM/jop7NeOQsObs16FTGJxJjiXpXpFodTU3nhFKZHPT9LUdg1Pio8KMzN2VM6CwOqApCD9MzZUTkqfN0c7Fw5kV2ZBDQXdSQSF/RodZbTz07hTqmB7MO+d3Z90IKvGQtCy5bw9hUeBh5pTxZQ/3Q+3EqPYm13fva644EFi/yuFd50NZmF51ewOlVXKHSU95nU2XoguQH8HuPvcJKLyrVoMzlqHM0WaZEuZhxpgsbqG3sjhjD78SnXrBgWQtZl098eZiQ7IDXeh2pkHINLfQ15ii53DlmBUJAd8NnY/fai/elofdnoiB5KqO+OpOsMsFO0gJYdolaZD4n5xAR09s1BR1C+zPDpWJJ7E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/07/26 2:06 pm, Anshuman Khandual wrote:
> 
> 
> On 10/07/26 2:24 PM, Wen Jiang wrote:
>> On Fri, 10 Jul 2026 at 07:08, Andrew Morton <akpm@linux-foundation.org> wrote:
>>>
>>> On Thu,  9 Jul 2026 15:38:17 +0800 Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>>>
>>>> This patchset accelerates ioremap, vmalloc, and vmap when the memory
>>>> is physically fully or partially contiguous.
>>>
>>> Thanks, I added this to mm.git's mm-new branch for wider testing.
>>>
>>> AI review asked some questions, and some of them are new since the v5
>>> series:
>>>         https://sashiko.dev/#/patchset/20260709073823.6643-1-jiangwen6@xiaomi.com
>>
>> Hi Andrew,
>>
>> I've gone through the Sashiko findings:
>>
>> - Patch 1 (find_num_contig): Over-interpretation. No new hugetlbfs hstate
>>   is added. The extra sizes are only used by init_mm kernel mappings via.
> 
> But not sure if that is a right approach. If these multi CONT_PTE
> sized mappings need to be supported in vmalloc() but without adding
> corresponding HugeTLB sizes, probably these required helpers could
> just be factored outside HugeTLB.

The problem is that the existing vmalloc-huge code reuses the hugetlb helpers
because it is easier that way.

If you really look at it, num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte()
do not have anything to do with hugetlbfs, but with huge mappings. It is unfortunate
that these helpers are sitting in hugetlbpage.c . Really these functions should be
pulled out of CONFIG_HUGETLBFS and put into some common header - but I can't think
of a clean solution to this.

So I think for this series, the least we can do is add a comment to clarify that these
helpers can be used by non-hugetlbfs mm code to set multiple huge mappings at the PTE level.


>>
>> - Patch 5/6 (NULL page): Invalid input. vmap() expects a fully populated
>>     array of valid struct page pointers.
>>
>> - Patch 6 (32-bit count << PAGE_SHIFT overflow): Pre-existing. This was
>>     already discussed in the V3 thread, and a separate fix was proposed
>>     there.
>>
>> Thanks,
>> Wen
> 


