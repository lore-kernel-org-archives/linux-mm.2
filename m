Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57171D6406F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 03:11:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFBB86B0005; Tue, 16 Dec 2025 22:11:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC9906B0089; Tue, 16 Dec 2025 22:11:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE386B008A; Tue, 16 Dec 2025 22:11:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C3856B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 22:11:43 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 43CCABB8BB
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:11:43 +0000 (UTC)
X-FDA: 84227488086.14.113DC86
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf10.hostedemail.com (Postfix) with ESMTP id BC205C0008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:11:40 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ImpItil6;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765941101; a=rsa-sha256;
	cv=none;
	b=UiQxA1fp3r+onxhG7p48JlsBZHG6vRbpWCmxrzRNyNneK5IIIoENuQPltTtHQzCab4tnth
	h6Jwo6Psejv7CYKsuHVcpdAM1EGU3HcugOoxlyTuy35htpwvZDP5cXmLwifS/vuJhUcO81
	xtCwQAVWQY31we/dHKbQ88UJw5PcFcg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ImpItil6;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765941101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nu6UK8a/ziMCsyb+RknHP8PTrL524RR3T22QKWM72Zk=;
	b=11ShCaQDPWenO9JtYx+7fusZeEnsZqElVZ5HzBtyBZubM9Ykxxt9sgY9FwwulJlyd+2pX7
	3An7A7GqHiIpVhDLDhe6ahvmTOJIHtma2GbBVzYsb6X9Eiwq1L7sXg+U0AORH3/HVj8ZLT
	KZsA3zMRfsf344dG9tIxkZGSJFT2aec=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1765941097; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Nu6UK8a/ziMCsyb+RknHP8PTrL524RR3T22QKWM72Zk=;
	b=ImpItil6G3hWJVCbd3i8tE1QJSz9GrF9Y0HICLelQ0bavFlm3EZl/LdcX3TUkENnWNoVEGT2FRXTM++6h8EmgguY4ZkO2psOTzRrB05JsoAqtLPeIjZZ30gno6h4oi/lwj9zoLHWXcALcXFELBz/lwxcRLoBXQ8ChcxBZfDrsos=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wv1ZCXw_1765941096 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 17 Dec 2025 11:11:37 +0800
Message-ID: <8bfcae1c-74a0-43e8-807b-fff22a770241@linux.alibaba.com>
Date: Wed, 17 Dec 2025 11:11:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: rmap: support batched unmapping for file large
 folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
References: <cover.1765439380.git.baolin.wang@linux.alibaba.com>
 <af330c9ea188bd0f28189b1e6e5803f6de9d2abe.1765439381.git.baolin.wang@linux.alibaba.com>
 <70d1dedc-b4fc-4eb6-baf6-9e54b6a62249@lucifer.local>
 <eb871ca2-47c8-4b10-a61d-321716f6c147@linux.alibaba.com>
 <CAGsJ_4xp40A3u=N5_mw00Eo6bPmFvctD3j=1Qmy3vOo2EmX3hA@mail.gmail.com>
 <9e038290-70ff-458d-b46d-bc512c3442be@linux.alibaba.com>
 <e718cfdd-a39f-48f6-98c8-f17683f29bcf@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <e718cfdd-a39f-48f6-98c8-f17683f29bcf@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BC205C0008
X-Rspamd-Server: rspam03
X-Stat-Signature: 7hnrec3uqixs7hyxrhz47mbxff7bkzwb
X-Rspam-User: 
X-HE-Tag: 1765941100-705793
X-HE-Meta: U2FsdGVkX1+5FP5/vF5gYZ+/SrDasS9cWQWSKwNy6/Nw9Bz25tdR34sLORBpqIgZmdY0pGMY8YA/p/LtRc9hTxIWBTuP9gV1wFLBPnVt6BW8AlmgfIpvn+t/RYnIhnnp2CTZMM6VvQ67NwPkwuoiuRyE0iEcP2A/2plwADHsrjFzWkmOavomaffx6eZpaqGs5b3EXDOzlhXHGWS4c1T+3c7ZN8brvVq+fkQ5XVU3Dsd5gEkxzCkMsTHkNrbNLfCW6coTqYMh67zKZn7iSIdVk9vIG3kf4apDDU2GkfszyKAyh2ACWdrDynA9TH7/g9uVegDay2FJqw+D58JTUwry8rK9YywWCjjl699sOUzp9t/r8rfE9tLwzXvg08NEB8+nRfooJNB744aO0QHPkNWONz43nCieKcQ13fdMR4UJ3dcbUYHSlhpUkObNXMJnqP3n+9KBjul1G49YUhs0h6VjeXcjWwXLTOrQbaK6DvWw01Nadl3urMhnzrIhUDC3uYNHtJnMiu4oqppUOWNlKidmvuvtmJeovtQppTfDMjQoTeh4x/kz/X/BFLlAidXyNhf0VzHU9ZadKjROfv5/g7oFyUk5bbwpNbZuYg9tiZM5Oy39fmMbYa1RuZjStwAlhw/LlK1vkLG6JVSn7bxFVcYl8FJs2db6ZRzULoaROLRRiOT4M+HuoC8klE9CYcie4kBVfgp4tvwSc3KoBNOPJMN+VBI3ExlivbF05t/Ptk5NyvO1zOrPg4tgXzR2LeLOJX6CPQBjcZssIb8235dg1qX24J3iWnml4DGStbWFmrejvkxEPk4QfTfZ9tWQij1hfLWQrNep7iMoEwvFv3A9SOsIYJ6iF33qvpHyOZ+7AOHKnX9anIY+9SU+ea9B3FpnnF3z/rn/ujC8/A7dMd8r+p+uEoZ3y4QMGVz8wAfrRmT0/valmZO4tmO33dztHV43VgPcmvimfzfv1jYq5lRSrbL
 nSIlInih
 QJGBmuizOlyUQzMCzyY2Yqw+W4b5imc3qBroJqM4YrBWXP3+iK+JOKyHACMGq0kkcXBCgtG4zfBOgwcfVHD9gL3jWKJ4uWm3l1mQHuykmtfIR96gpkC8jDJvMuwJ03d/chSln7d7ed5/7BS5T1ddXulzrSkT8sreLpCfl3bsczGx5N12AypQ6/iCbPBtGN2rH6VdxOBBDq9o5+fiQk0waMHHqxvS+QFaLZqPEgKasGk8Wbck2fgnEJP+kg022Vz7K+F2V+bb73P5xWhaLbWjDzKGZ/WXpWARD1AcrN/pSskO6yI8gzFgaR6f8FW95ovzRopSeHDGqXtndouJirsUmRPH+hg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/16 18:54, Lorenzo Stoakes wrote:
> On Tue, Dec 16, 2025 at 02:22:11PM +0800, Baolin Wang wrote:
>>
>>
>> On 2025/12/16 14:13, Barry Song wrote:
>>>>>>
>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>> index ec232165c47d..4c9d5777c8da 100644
>>>>>> --- a/mm/rmap.c
>>>>>> +++ b/mm/rmap.c
>>>>>> @@ -1855,9 +1855,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>>>>>>        end_addr = pmd_addr_end(addr, vma->vm_end);
>>>>>>        max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>>>>
>>>>>> -    /* We only support lazyfree batching for now ... */
>>>>>> -    if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>>>>>> +    /* We only support lazyfree or file folios batching for now ... */
>>>>>> +    if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>>>>>
>>>>> Why is it now ok to support file-backed batched unmapping when it wasn't in
>>>>> Barry's series (see [0])? You don't seem to be justifying this?
>>>>
>>>> Barry's series[0] is merely aimed at optimizing lazyfree anonymous large
>>>> folios and does not continue to optimize anonymous large folios or
>>>> file-backed large folios at that point.
>>>
>>> Yep. At that time, I didn’t have an Android machine with a filesystem
>>> that supported large folios, so I focused on lazyfree. But I
>>> agree that lazyfree anon folios and file folios are quite
>>> similar.
>>>
>>>>
>>>> Subsequently, Barry sent out a new patch (see [1]) to optimize anonymous
>>>> large folios. As for file-backed large folios, the batched unmapping
>>>> support is relatively simple, since we only need to clear the PTE
>>>> entries for file-backed large folios.
>>>
>>> Yep. It is actually quite straightforward to go from lazyfree
>>> anon folios to file folios. Swap-backed anon folios are much
>>> more tricky, though.
>>
>> Agree. Thanks Barry for reviewing and confirming.
> 
> OK that makes me less concerned, but you do need to put some more justification
> in the commit message.

Sure. Will do.

