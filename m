Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5679C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 01:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 052BF6B00C9; Wed,  5 Aug 2026 21:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1E636B00CC; Wed,  5 Aug 2026 21:30:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5EAE6B00CD; Wed,  5 Aug 2026 21:30:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88D836B00C9
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:30:23 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C3BA160633
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:30:22 +0000 (UTC)
X-FDA: 85069114284.08.9B01302
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5672B100005
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:30:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fdLy2lh3;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785979821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IyxeyywyanPFlbyo+b+/1dTM4zZGbGAIjDiWbCcAXnw=;
	b=jwZFGamhTsydeUxU7X7JO4RTp1XoDPIHahX5Vqv4FkOtpJDoW4tssnH9PdPjcjlbeZ7SRp
	aiCj3yYkZ8Gn6/TKxMh/n8G5vIPAMb2Y+Aa7YTmWYyYjoxn4QBERg9ULLXpejz5EzKDj3I
	ZvvmFodGzcFk/KuWjWM7oGxk4F0XHio=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785979821;
	b=T7GMI0A1s9EwBN1yL67Of8Vp9OgAyjQBtgeDh1LMAgZ4LBwm1Sh4dWIG29kLnSJlzSFil/
	PbdZ5sQ6BREQ+IgXLpI5cgMi7k2r6m65bYdxKMP5RwrC8xQ1tPNmMeklfZLs452aE/FPDU
	f73fSJ9WrmHsgI5pDU8iv12c34n06fk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fdLy2lh3;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785979816; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=IyxeyywyanPFlbyo+b+/1dTM4zZGbGAIjDiWbCcAXnw=;
	b=fdLy2lh3CZVveS4D1h+RCkoQ9gSo6luBXnJMKMCJFEZT/NYMp2Nv11/if+XkLEglv64P3o5KyBIylYlwQxsgH5Fa+fusxs3Re/gYOcBKsuEDenJb4ttkz+WGcU6i9vbBH0GqMygtbZ/Ic33qx9K9QBL+bVfAotr2BhAz6quKWi0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X8SLPHI_1785979813;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SLPHI_1785979813 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 09:30:14 +0800
Message-ID: <e17f9ee5-6606-46a4-a756-9d7a5462cd45@linux.alibaba.com>
Date: Thu, 6 Aug 2026 09:30:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] selftests: mm: add mTHP collapse test cases
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <dd8013c1ddada90913876e3bd912c07e613fba8d.1785564857.git.baolin.wang@linux.alibaba.com>
 <DKH5VECNN2LF.M3RGFY0NORWI@nvidia.com>
 <8551bb7d-945c-4be8-b7dc-01ff15fdbc76@linux.alibaba.com>
 <E5080E9F-980C-4445-9C19-9C792270A751@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <E5080E9F-980C-4445-9C19-9C792270A751@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5672B100005
X-Rspam-User: 
X-Stat-Signature: 6hp3p8bykwkn3hqiajcfa6qks5ofmexy
X-HE-Tag: 1785979818-970011
X-HE-Meta: U2FsdGVkX18Hp970stK0q0MkbLI/mOf+TkTMdRbk3kareV/poUx0nvceDDdXclGgQTbQjPVOuwkS105I5VlEn0BQfJSfUe1fuKG/f9ZxZJkw7eM1SRjKL1T3L+0AhND+LZp2/sRdrvQ5INQ6dQ4m/E91pQFUjPRZfNufO6c7064v0pN4Lerh04vyTv3dUOfNuC65N/9JSvXJJZWwrMO9MSPj/qm/4Vtvx6GkeDm5tysycHqIeGn3IUc21jVp89fWVcDqlQXPld1Du9B5RxXdkywgDyQZnQM9xIL31Ww0nqsSXsLEtjiZ32oRO7e9tvxMylRr+N0EfB9RvIr3f8vS/dgfA0c9M+O1psL0l1ctolXWgrvtI4rfgh3hEBN2NYBSz4HxJGCCp/RXJK1SM/eK7475mGcCjrD+Ox+YVD5KD2lpOP7rgGyuERcDrbY/jAHDU9Uh1q46ZEdDhLcRbFAmkXF+p0HJQE5TwtC0vzHvIqkVlZAI9Q5kzIyAfFaK3nfyuIHExwMMboFiIyVmzqz/I957blwtyBFt6EjEQEx5TReuYnRYXRxw6sFiuSN0LQ0m8uf+TUNn+2EQUYCnoWzIEVLvcHQpnVjsh/2GdwfKoxURrpo6ejjQr7PmGiWOO0rlq0uu1kDX8plU5gXPOS5kqkhGFDahqez7YRzhlAh2Q/lslEaLHcHoxaYwoQckb8ayUU5PrHOvau2xml8e3mflE62k9yCk4FvcK2q69A4LPUo4cuD6hXEERMS61XylzT/kcY5QG3yEouMJdd6T703BySFL1JPDV6inJwxIysNJ6LAHBd579m/IkroX1CX2ZHppYqQbVHICkABpdoJOs/fy3w3HlastfhHfOKZTR/DBnQhPSQuW4eSGesPb+UmGaYgWwzUNf1FmS5QRUmcZSOpOdpdvv0FORK0URy2B095zxfIb9/21U8jSmfAT5U1baPtPLCDDjhQg98WleDwDzp6
 lki+S6oX
 +V+CVQyK9aFfMlgeFbXMO0nalETaTqobr6EACnid718RtAtRw3vGs7RCMaP5C6BmsW+MqBBZAbltP8EeixdsIlha+QXD2F9jLCb10ZVdM8TZCmOEgIpXFUGTeOiB0WCufEx/0EkAH5sdpOXRw9l+KFgKSeOJA2k4Mlg9aXS+W71+55JL0ejkNNmk0hVHh0wA81AAoDQgkkmssn7VGG4dL7+cLnzZyT51yi70o7b9REGy7tUBW/WuKL3/kDyT3kJll5mH8Ep0xreeW4jF1ZNe1CsbgWcvqgLiE0LYE4DCCzY6GwfZe16eC7JVIuq2UlaKT7mnrtHv4ebbSQ9Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/26 9:25 AM, Zi Yan wrote:
> On 5 Aug 2026, at 21:17, Baolin Wang wrote:
> 
>> On 8/6/26 12:46 AM, Zi Yan wrote:
>>> On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
>>>> Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '-c'
>>>> parameter to specify the collapse order. Additionally, added mTHP collapse
>>>> test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mthp'
>>>> for anonymous folios. All khugepaged test cases passed.
>>>>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>    tools/testing/selftests/mm/khugepaged.c   | 130 ++++++++++++++++++----
>>>>    tools/testing/selftests/mm/run_vmtests.sh |   2 +
>>>>    2 files changed, 113 insertions(+), 19 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>>>> index f69be6be0ecd..64d6da6aa90d 100644
>>>> --- a/tools/testing/selftests/mm/khugepaged.c
>>>> +++ b/tools/testing/selftests/mm/khugepaged.c
>>>> @@ -26,9 +26,11 @@
>>>>     #define BASE_ADDR ((void *)(1UL << 30))
>>>>    static unsigned long hpage_pmd_size;
>>>> +static int hpage_pmd_order;
>>>>    static unsigned long page_size;
>>>>    static int hpage_pmd_nr;
>>>>    static int anon_order;
>>>> +static int collapse_order;
>>>
>>> <snip>
>>>
>>>>   diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>>>> index 687d115e3bd8..d09f9f6a384e 100755
>>>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>>>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>>>> @@ -410,6 +410,8 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
>>>>     CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
>>>>   +CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
>>>
>>> Why only testing collapse_order == 4? It is more useful to test all
>>> possible mTHP orders. -c can accept common separated order and a range.
>>
>> This also follows the previous '-s' parameter configuration, which is used to specify the mTHP order allocation.
>>
>> I think specifying a single order size already tests the overall mTHP collapse
> 
> Got it. If a single order covers the flow, I am fine with it.
> 
>> flow, so I'm not sure whether testing all orders is worthwhile. Maybe I can add a few more orders?
>> ./khugepaged -c 2 mthp_khugepaged:anon
>> ./khugepaged -c 4 mthp_khugepaged:anon
>> ./khugepaged -c 8 mthp_khugepaged:anon
>>
>>> Why only testing mthp_khugepaged:anon? IIRC, file and shmem are not
>>> supported, so khugepaged should reject them, right?
>>
>> Currently, I have not added test cases for shmem mTHP collapse, so adding file or shmem would be no-ops and might mislead others. I will add the shmem/file mTHP collapse feature and test cases in a following patchset.
> 
> Right. I mean when one specifies ./khugepaged mthp_khugepaged:file/shmem, the
> program should show some error like “file/shmem not supported”.

Yes, that works too. I still prefer to add the corresponding test cases 
after I add shmem mTHP collapse support:)

But if you have a strong opinion on this, I can also add a "not 
supported" message first.

