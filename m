Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0829D109E535
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 01:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ACEA6B0089; Wed, 25 Mar 2026 21:48:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636726B008C; Wed, 25 Mar 2026 21:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525096B0092; Wed, 25 Mar 2026 21:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4202F6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 21:48:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EFE1013C028
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:48:02 +0000 (UTC)
X-FDA: 84586528404.09.876D3AE
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf08.hostedemail.com (Postfix) with ESMTP id BBBFA160003
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:47:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EF3koCnK;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=EF3koCnK;
	spf=pass (imf08.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774489681; a=rsa-sha256;
	cv=none;
	b=0OQYi33yT6JtTgX+lFobYwoYoKP08OiOD4ZI5y6uvdE4S/C9EXbjbJa5CMwnGcygByjd8r
	83kDOf0E4yv/8/TtsXNNfEFnRJAu/G1wMmz5ttWf0MqBrh19O0tLHlldiNOB02xgGbvIxq
	j4pi5nOFvE4baohm48CSZOl4r6BDrcY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774489681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8uD3fXoJUVKVQlQPb1UgplQm2Umx6AyBtREGpInkaM=;
	b=JLcVNVZvs8QT9j4opBGBHT5daQUzoeUswLLHvx6Ip0Xx26ChwfvjORzx0ZQR7e22SsmnGL
	Kh6Mbg1c1VkO/7Pri9tZgP7F4XKIfwdm0iGdkuke39bMH8PmlyuEFcdlN6QLv4dsVVpzgI
	GeHFf6NCGhkLvq0LiYTupD6zv0Y4CS0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774489674; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=H8uD3fXoJUVKVQlQPb1UgplQm2Umx6AyBtREGpInkaM=;
	b=EF3koCnKfebTyiOrU7IFleaG4W9jjVjbGQmJDFXmKOkOzcWNcRTOlbdk9tP4DejgcWMD3/aIJnpTjElLxoEF4wTDGQFxaaF5SJUL2q1qPVo+kQRnHpcFnYVNtryhjDA64kQIc8ot3HDG5cGERsupr2Lsex7yJNg24mT+JuBf95o=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0X.jfTBI_1774489671;
Received: from 30.74.144.123(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.jfTBI_1774489671 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 26 Mar 2026 09:47:52 +0800
Message-ID: <bfd282b1-523d-4945-97a0-ec30fe1df577@linux.alibaba.com>
Date: Thu, 26 Mar 2026 09:47:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 dev.jain@arm.com, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com>
 <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com>
 <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
 <86f611cb-1292-44e4-b629-6503135d33ca@kernel.org>
 <e5cb474a-a84d-4edc-8289-d68378feee7d@lucifer.local>
 <e3e374cc-ddf2-4112-b063-6cb1839ea566@kernel.org>
 <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <e227a7f7-0186-4d10-b7b4-c84ca8424bdd@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BBBFA160003
X-Stat-Signature: 59robdcg91dsb7brm9hxcjp8rt98d4yp
X-Rspam-User: 
X-HE-Tag: 1774489678-834326
X-HE-Meta: U2FsdGVkX1+iEoq1EcfMFOxuBkXnWbuz4QAwX/+d7tWd5u2/hbazFQ37xDlLaUR9xY3dYLQK6ij6/fS7HyUOFqGy/i3xrYy1iFJ8GSxY6reoRizp7/Z2Y2eWNCBYvrUk+emhwciHKmNtXhYHvgrL277O8xh98kVl1NY908Vv3bZgNaZphGFCIoEFntRtRIgUrb7YyPavFwwyQEEs8Ldt8bFNlbE/BgLovQw92nSMXZWYkGYADHlM6k25QNlm/+hyBi/HOSGF0orgHj6LiEd1dx13KxuEUyKGLvVgVYJGkPgKrGPZwdm3RYMQUyKkXQR3JOqMmbw5kGUpYr8uPK1JHSge11O3cNrxgz7/s7P3b7ZcnhBV2zQYvz2V5eKb9pPYBUM/OhDbgA4wn4gyVIZV6b5JrVv/W+BmrnRqwKDzzwH4O/b8X7qhiPi8g27ndM5MkgKmSFzn4gQkCHCshTQnzncVYGS9f7Xh7QYxqQciHwKAm3AjrNP5JZzGUJphpwL/hAzmf3H56uYCRA+1oy/a3HlDUN8YDljQ/UUiEZRH7Qw4lkYF/HcaH4opnCJY+3LUxspCs+aYyWuKHZxlvC8rFc/3n6ALiCqAEa8bfcsAOWhmmzu1vYQT2KsOC2X1+m7CGJJHT5JvT8um6rjTr/Jd+YPrBGWAbrmLiiLiOVVagaHQwNF8UWBj1ITUk4V9NobdoGq3RFj8/v0lW2Krq7O33mLku2UyYBwwmsRyEDTourov/EPetqctXrzTRb8YWoYjHiZvUNztGXq5Zr8gUu+XafBGC0WKlF+fS8sGQRdMredq3lHdG4afKQ0BpRcxE8AamSM8vhEvvbdimFQHtcwNrWYeNYYOVqxkBibD5HfdWa9PEErzqh3Acd531EYVQEhY2D6TKOXRWDn0ogDGRGBiNZtH3ucNvB/oJMKnvISLh8ORJphD45jVQm7jNvcyHHSg4PXxB7f8HgbLdGONAeI
 KBhTDkwr
 kqqxg+WhXAZ1GdLyy2W5cbLXG12AxOOu0stwhI7YchmTNsayCjCA7jvtFBEj5POFJhPVVxZf/wN5S95bTqQLPIIOFdXisbNa+GZEb1RCL7UdOYd2Fm8haqsLJdvJ/gIF/BziXAXiRqfx4pKaM0jaxaBli+jGmXPKLaN9Nu65DdeM83K4yklQK+p5EpnsWSkxwFvFpzlwjiA6jrPaLj2gJLFlcgZhfP1qXXMMh8whRzBK/cT6H8CetlOhPqIewzhVcrJ3/Efmqeg31A5VvwEqbpyP9Z8XU9LC9Kgt6Fe8FVt5xYYli8cxNDfcKltifROscOW+dLeGRehZIPp3yvuNAGRb7lr2QTrgvgSVNwP6GYEPpt3pFRvUbkgB57kZd20kcK9Pj3/R7P7GB65I2I7pJyS/sz46rt5LqKK3FEdTXyxEJyDBKtxHs+PU+PQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/25/26 11:06 PM, Lorenzo Stoakes (Oracle) wrote:
> On Wed, Mar 25, 2026 at 03:58:36PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/25/26 15:36, Lorenzo Stoakes (Oracle) wrote:
>>> On Mon, Mar 16, 2026 at 03:15:18PM +0100, David Hildenbrand (Arm) wrote:
>>>> On 3/16/26 07:25, Baolin Wang wrote:
>>>>>
>>>>>
>>>>>
>>>>> Sure. However, after investigating RISC‑V and x86, I found that
>>>>> ptep_clear_flush_young() does not flush the TLB on these architectures:
>>>>>
>>>>> int ptep_clear_flush_young(struct vm_area_struct *vma,
>>>>>                 unsigned long address, pte_t *ptep)
>>>>> {
>>>>>      /*
>>>>>       * On x86 CPUs, clearing the accessed bit without a TLB flush
>>>>>       * doesn't cause data corruption. [ It could cause incorrect
>>>>>       * page aging and the (mistaken) reclaim of hot pages, but the
>>>>>       * chance of that should be relatively low. ]
>>>>>       *
>>>>>       * So as a performance optimization don't flush the TLB when
>>>>>       * clearing the accessed bit, it will eventually be flushed by
>>>>>       * a context switch or a VM operation anyway. [ In the rare
>>>>>       * event of it not getting flushed for a long time the delay
>>>>>       * shouldn't really matter because there's no real memory
>>>>>       * pressure for swapout to react to. ]
>>>>>       */
>>>>>      return ptep_test_and_clear_young(vma, address, ptep);
>>>>> }
>>>>
>>>> You'd probably want an arch helper then, that tells you whether
>>>> a flush_tlb_range() after ptep_test_and_clear_young() is required.
>>>>
>>>> Or some special flush_tlb_range() helper.
>>>>
>>>> I agree that it requires more work.

(Sorry, David. I forgot to reply to your email because I've had a lot to 
sort out recently.)

Rather than adding more arch helpers (we already have plenty for the 
young flag check), I think we should try removing the TLB flush, as I 
mentioned to Barry[1]. MGLRU reclaim already skips the TLB flush, and it 
seems to work fine. What do you think?

Here are our previous attempts to remove the TLB flush:

My patch: https://lkml.org/lkml/2023/10/24/533
Barry's patch:
https://lore.kernel.org/lkml/20220617070555.344368-1-21cnbao@gmail.com/

[1] 
https://lore.kernel.org/all/6bdc4b03-9631-4717-a3fa-2785a7930aba@linux.alibaba.com/

>>> Sorry unclear here - does the series need more work or does a follow up patch
>>> need more work?
>>
>> Follow up!
> 
> Ok good as in mm-stable now. Sadly means I don't get to review it but there we
> go.

Actually this patchset has already been merged upstream:)

