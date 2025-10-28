Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0EBFCCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 10:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2CC780135; Tue, 28 Oct 2025 06:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD4680131; Tue, 28 Oct 2025 06:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA45280135; Tue, 28 Oct 2025 06:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B53BF80131
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 06:09:54 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BCDE14032D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:09:54 +0000 (UTC)
X-FDA: 84047101908.02.8C0FE4D
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf17.hostedemail.com (Postfix) with ESMTP id 063A14000D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:09:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LmHqZsio;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761646192; a=rsa-sha256;
	cv=none;
	b=qRCG3ErYYV+g6slmXCwYynhjspKNv+QpED2TgPAlcrgejcWL6+LjelDyKq1elVcv77LeSM
	NdaMFBOPUbe0bQfnAhdivS8ALW8iUWf1hp2MOoUzuAPhf4efsFQpBDdQwhiFh3kS11YEkq
	PuK4cc3kmPUoiZ9Bg2mGIgmIdTw7row=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LmHqZsio;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761646192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1ryY5baZqSqiYaszWAZLXVQIoYi/aODofY8GTd3HL8=;
	b=X2A6xrDH0yyVzxKuO5aEjxn6FMr5plNrL4PymsVbcNt7aSTUGev8V7TqyE3cfbwZH3smEu
	xmzcBqmQuNVWHqrZQMb2a7UtddjxGrJmqWVu6PpDHoS4jxM3w9U6oFXgkeAhEi2ZiJ6+GM
	FbuhmEzZ/qbRvT3HaTTLDZaaGsoAyAM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761646187; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=D1ryY5baZqSqiYaszWAZLXVQIoYi/aODofY8GTd3HL8=;
	b=LmHqZsio4ScuDC8HoUt3WmJLAE9p7urcQcY8O2yU3lGGO9woHpAC3SKoSENiaakWRZzje97DK0bUpEe/lDwDNQWDVmQCZG4KdT1ydy0SrLFwJ6N6jEAPGCEfDQS51nnimwRC+XzHUQvEqOkaGBw+g32chbEOpFaytQck1dMBtL8=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WrBnYT2_1761646184 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 28 Oct 2025 18:09:45 +0800
Message-ID: <063f8369-96c7-4345-ab28-7265ed7214cb@linux.alibaba.com>
Date: Tue, 28 Oct 2025 18:09:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 mm-new 06/15] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, david@redhat.com,
 ziy@nvidia.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com,
 dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-7-npache@redhat.com>
 <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <5f8c69c1-d07b-4957-b671-b37fccf729f1@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 063A14000D
X-Stat-Signature: f9usbiaynpa4jm8qdcqu4jmpkyfarbbd
X-HE-Tag: 1761646190-709510
X-HE-Meta: U2FsdGVkX1/RUWE3xXotjbtZ8UqVqe3r5vSs74wyuiQT9wGoSciyoVhyER3W2FaVKsoXhES6PauHLftqSzb0DD4lq/xfnWkAY/BQK68b8NwC+A1E0HrNOmAH82W+r8a5pDLDvwmmXY9lg8p/72TRKyVamIw9vVeSKiGmi1AJoQE6uZC8TpzdUM+2YHov3gyvQgJFAcOFhE8ZU+hdFHL0mSwQz+ZloXR1fLodSQ7SPBx9iuvVPg4na+itR2RGnrfsFWjNtE6K8SQLScQ4puDH9Co5yU2gMn4e901AaE8m00rha+bfmJWk2xnFUO0XiN1fTr39Uk+On5qdIbdbmUuQ+wJjsFovghK8pPwTHqJBpZHdIaKJ4e7AMgiCeB5E63f04Sohx4o9yDsfyNIPIiQVA2giNyabKDGIBvJ4V2qcoRfAcO0sebl+Fr74CNRmNglsX7/uUrBXCXAyyK2xlPtKwPV2HMgZyFzCbG41u0ONQpwa7R55jJh1OckIVrkEk5veLkggxk5XpjyfkpktfXKkKvRdLGcGk9cJK+XM2BNeBbfOLhy/M6+UrzvV4QSZv6cRkmS0isFCJlJJPBCfHHqGZUK9aY1mHUl9ZujKR0cC266zKhRe6o2+43OrI9o5GiU0W66oP4FDsP8x37jeY/I+uFDmnA6EfqohvKEurNWW/RutxvZwZoNpN1ljfh+a12cEnwOx+pOnXKhX4ZIEc2E9sqiuANa04ZLlnX/MQV+tOy4DOLz7sVg1kYdkMh4dauHX3gL5nTzS5SI0nWoFwZXs//yN8DfMc84nYP1MXvHqFFl8htZ9xOUmQFQ1b+qNsmvWebXaxAbN+ZFg5BHGrluUI/L0/UelSpT8NXPywM90lf8iA0cnnfMBiQZNOHGe5d5Bc05psx6VcyozkCWD3h5+7qD1GmG3D7d24x9SJNit+2wzP24xkWxA+Da7XsBaQ7huhTxGObuxrcJl2G11CjY
 bsH+ZBEx
 9e+JFJkDhvfs0yOon1PObE9OlHLXS/IW9O3jb1UGGN01xubpwnIFFQlL6tffTPL4e3o0cfCgXnL2cRKCkuFdRmEMDEoOKXegbSEnNyPVPmEaeNfXqXGW35oR/z0fasjLC0X5aEr5Q4GNwDt3PeVaZ+EAysRC5d753MiWnppAIpopYCQqRznRk6Kzpd9kvLDxptkXzjR/egN92ot2tk8kKrvY1ItCTEvK9vjoAlLVFpxH45ce1DuRcgr9ujE3ZbxnaW4nfJYephTApqL/ROG1kz0DYtAfx4u8/5bbUq+W1mLGekYbC3ocD/H8bIxSVAUTrG1AIrhmaU/tAgpS7NhzJaOYMoJf/Ld7T+7SHX0KwHOowFoa4ymNWEeDEPbgozHjtTX3aGMhUdGkSt6DUPCFNpnUXLF6M9Liwg8d6cPB1YpXfEAIEvMk2CDrvbgWLWI33WHOXF+K3dyGvk2I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/28 01:53, Lorenzo Stoakes wrote:
> On Wed, Oct 22, 2025 at 12:37:08PM -0600, Nico Pache wrote:
>> The current mechanism for determining mTHP collapse scales the
>> khugepaged_max_ptes_none value based on the target order. This
>> introduces an undesirable feedback loop, or "creep", when max_ptes_none
>> is set to a value greater than HPAGE_PMD_NR / 2.
>>
>> With this configuration, a successful collapse to order N will populate
>> enough pages to satisfy the collapse condition on order N+1 on the next
>> scan. This leads to unnecessary work and memory churn.
>>
>> To fix this issue introduce a helper function that caps the max_ptes_none
>> to HPAGE_PMD_NR / 2 - 1 (255 on 4k page size). The function also scales
>> the max_ptes_none number by the (PMD_ORDER - target collapse order).
>>
>> The limits can be ignored by passing full_scan=true, this is useful for
>> madvise_collapse (which ignores limits), or in the case of
>> collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
>> collapse is available.
>>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>> ---
>>   mm/khugepaged.c | 35 ++++++++++++++++++++++++++++++++++-
>>   1 file changed, 34 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4ccebf5dda97..286c3a7afdee 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -459,6 +459,39 @@ void __khugepaged_enter(struct mm_struct *mm)
>>   		wake_up_interruptible(&khugepaged_wait);
>>   }
>>
>> +/**
>> + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for collapse
>> + * @order: The folio order being collapsed to
>> + * @full_scan: Whether this is a full scan (ignore limits)
>> + *
>> + * For madvise-triggered collapses (full_scan=true), all limits are bypassed
>> + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
>> + *
>> + * For PMD-sized collapses (order == HPAGE_PMD_ORDER), use the configured
>> + * khugepaged_max_ptes_none value.
>> + *
>> + * For mTHP collapses, scale down the max_ptes_none proportionally to the folio
>> + * order, but caps it at HPAGE_PMD_NR/2-1 to prevent a collapse feedback loop.
>> + *
>> + * Return: Maximum number of empty PTEs allowed for the collapse operation
>> + */
>> +static unsigned int collapse_max_ptes_none(unsigned int order, bool full_scan)
>> +{
>> +	unsigned int max_ptes_none;
>> +
>> +	/* ignore max_ptes_none limits */
>> +	if (full_scan)
>> +		return HPAGE_PMD_NR - 1;
>> +
>> +	if (order == HPAGE_PMD_ORDER)
>> +		return khugepaged_max_ptes_none;
>> +
>> +	max_ptes_none = min(khugepaged_max_ptes_none, HPAGE_PMD_NR/2 - 1);
> 
> I mean not to beat a dead horse re: v11 commentary, but I thought we were going
> to implement David's idea re: the new 'eagerness' tunable, and again we're now just
> implementing the capping at HPAGE_PMD_NR/2 - 1 thing again?
> 
> I'm still really quite uncomfortable with us silently capping this value.
> 
> If we're putting forward theoretical ideas that are to be later built upon, this
> series should be an RFC.
> 
> But if we really intend to silently ignore user input the problem is that then
> becomes established uAPI.
> 
> I think it's _sensible_ to avoid this mTHP escalation problem, but the issue is
> visibility I think.
> 
> I think people are going to find it odd that you set it to something, but then
> get something else.
> 
> As an alternative we could have a new sysfs field:
> 
> /sys/kernel/mm/transparent_hugepage/khugepaged/max_mthp_ptes_none
> 
> That shows the cap clearly.
> 
> In fact, it could be read-only... and just expose it to the user. That reduces
> complexity.
> 
> We can then bring in eagerness later and have the same situation of
> max_ptes_none being a parameter that exists (plus this additional read-only
> parameter).

We all know that ultimately using David's suggestion to add the 
'eagerness' tunable parameter is the best approach, but for now, we need 
an initial version to support mTHP collapse (as we've already discussed 
extensively here:)).

I don't like the idea of adding another and potentially confusing 
'max_mthp_ptes_none' interface, which might make it more difficult to 
accommodate the 'eagerness' parameter in the future.

If Nico's current proposal still doesn't satisfy everyone, I personally 
lean towards David's earlier simplified approach:
	max_ptes_none == 511 -> collapse mTHP always
	max_ptes_none != 511 -> collapse mTHP only if all PTEs are non-none/zero

Let's first have an initial approach in place, which will also simplify 
the following addition of the 'eagerness' tunable parameter.

Nico, Lorenzo, and David, what do you think?

Code should be:
static unsigned int collapse_max_ptes_none(unsigned int order, bool 
full_scan)
{
         unsigned int max_ptes_none;

         /* ignore max_ptes_none limits */
         if (full_scan)
                 return HPAGE_PMD_NR - 1;

         if (order == HPAGE_PMD_ORDER)
                 return khugepaged_max_ptes_none;

         /*
          * For mTHP collapse, we can simplify the logic:
          * max_ptes_none == 511 -> collapse mTHP always
          * max_ptes_none != 511 -> collapse mTHP only if we all PTEs 
are non-none/zero
          */
         if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
                 return khugepaged_max_ptes_none >> (HPAGE_PMD_ORDER - 
order);

         return 0;
}

