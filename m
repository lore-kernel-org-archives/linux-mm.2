Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA58DF3C265
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BB286B00A7; Mon,  9 Mar 2026 09:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 065396B00A8; Mon,  9 Mar 2026 09:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA036B00A9; Mon,  9 Mar 2026 09:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DD7D66B00A7
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:47:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A5D5F139322
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:47:11 +0000 (UTC)
X-FDA: 84526651062.04.E2C2EA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id F2D3C40007
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:47:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KqlTf+Xu;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773064030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fuazgn5HJvq9KCmsOuAjco2sO0LoAGAhBZEoDoRj4V8=;
	b=mipqDvO+hvLbTZqpVIeYtbH9pYpVG+n74DauGitvzON0Xe+6X329hBrYmGVHoYWt3Wn9DA
	42R9kOgo91ovtLhuSA4de642byT4+r9sOb0R6YuGbB/Xc7muIgyqwa9EUDlZ+v3TouCuLE
	Enz50Y8QWhsCsbIXJG+w2qIfv8VcUf8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773064030; a=rsa-sha256;
	cv=none;
	b=tHvF5c0SVL8Yy5XRvFoDTg2oH9l++SbxpLaNHOI9ZaCAJztTyyEiB7CZyYGxU+i5KxRMg+
	j/th29KWisO5G7LnZWVfIN0BJaufa1cdDSFvBdnJwMw5X+cAfhBp7mzvYuzSPcmXvGPLCa
	p8vytbIHqBxBDR9LC6koYjN2KqFNsEA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KqlTf+Xu;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 732C960133;
	Mon,  9 Mar 2026 13:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA80EC4CEF7;
	Mon,  9 Mar 2026 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773064029;
	bh=7piKZHhsIBIfKAmz0YNkAHG2fwGgdi8QiNaH5QjGJ3c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KqlTf+XuTDsfWF7nxx244vtdTmqtYiab/znRgfKYMAUmCHQpbMwn6npnKqw2qh9lm
	 HPnBESsOgkY/l/oTJtCXVwQWx94HqSQkEaQMsoH08XCOrtDJfjJKWZDFwrxHVo2St4
	 gttIAV8tZ1AGzulO9MnmQa7oA343ki4adG9EULbpJyMge2+P4cKFM78JVsCHiLM0BP
	 0qh/3QNTDs09ZBooa2Wz30AIE/YR6hfjsbibHEiXhQVGlehE53bjbNGXNa0BqLUMWl
	 D4BAYZ+FTNJOz/oL1fcQh59A6Ll7GPj5pxHx3X+G1tBdVqa78XdsBQ6yuVgmeqCazr
	 TtenKHTchw+HA==
Message-ID: <edd058dc-9d94-4c5d-a2b1-245a04b54eb0@kernel.org>
Date: Mon, 9 Mar 2026 14:47:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/4] mm: move vma_kernel_pagesize() from hugetlb to
 mm.h
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 Dan Williams <dan.j.williams@intel.com>
References: <20260306101600.57355-1-david@kernel.org>
 <20260306101600.57355-2-david@kernel.org>
 <833950ef-e01d-4914-b5f9-bc1f6261b184@lucifer.local>
 <729e14d4-6949-4d46-9380-12331b5ad363@kernel.org>
 <d8cdf99b-3139-49b5-bc4f-dda139856021@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <d8cdf99b-3139-49b5-bc4f-dda139856021@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F2D3C40007
X-Stat-Signature: c6c6dt5sea1n3jxjuuiegpi8sbijtuip
X-Rspam-User: 
X-HE-Tag: 1773064029-952426
X-HE-Meta: U2FsdGVkX18EvltVfFioyJcUy+tB0w+ajf8Jtl0PPzkGqEmudHqGWNdRnUcdAniC7sl78F3tlO/By44rKmnjIE3CP/T0RtbJyNjdQ2yAHFUNyLQHqgfDxuA49vPpHvagYLg+9KvoZcavZxAQZJzqnGkg+hnx/3W92qvt9yXn+XN7I9mKQSlIDYOQmOCtBk9huHhuYwj4v77oalIO/eNhGTYjvNxvKbGPK2OFMoAE/0l3+LosXrqTFdKzszrFNKw+mkeTH9MEIrAZ3TsRT1pqGzjed1ozXVMoSNDqPcmGU7vlMJqsBQvxaW8Yz0zXlNZKKF3DtM/gkzOBeSqfnHbi0r9Fx/wK7zlIFamCSXQujw1osRCUIqbJARJwhYBOLqhDPotWz2ZxWnF7BGZ64nfR2NdyeIT8iBe/68U+fazfnPvLMUg8ziLE8xeIZ1kzniFDCzbJQ6O0x1eBzyRrrzTCesuywQDg60nkUpzJ5WU9N56BnztZjkhQQ/+7g+uBzJWYsO1mYY/l2POncKinQJjJWv2gZ6RKEEuV4/bw1y7QJEUQvnKurR7Ggur/5UqhK5SYxKX3fh7FVSmjqPzlLQVE3FpGMKdnBZYiY4E15BInyBBdVRJ1qs5Cz90SWGQFcrf36HdhaAJ9jxX5AIDMfRtrNj/KgmJUgcCEExoFLdm7GJp7Ux5/m51E8igPRsUk9/+H9lQ1KDVeM0ud4RDvnePWcjaRvjgZQZpEvIsnUj47ea7JAMLm4r5CeuLiUhB5PpUqZFch6gtQbF0rbvMokOSe1GcXEdinvYYGWx5Kzg0d+GWE25W8TyJOjqUGmVxpOcD42ZRASk3DEVOhOHfTLcKoWYO+EDcr/gYh9o2BvYo6AR+oUwddUIMcAcI3VKr3B1vudPX6jvTHQoCYIvnvqGirrXMs9TqRSZPofasjlOwpuQD6BrUD1geGGc84NmQJd51yTIlg/HDsoBqTQSDvpZf
 f8NsC3fn
 FnsV0TYab5mi7blnECeiL04mzIg2zru3UALhjnV3fnKGlCW3HCsYbLts5NXa/uqpGWPqTHGA2ROEOpRtC0RO0J3l2z8hihl+yqklcuPUhDN35kJWSHZBwaiVXJUK9pNF4J3QeKs8CKydClxbvsmIV2f2TyYVRy0lyNvEM5VTn80jCG6/gbVKlUTM4r5dacVR9LtXBdv4HOq5iXk49CKUaqlf1zofSFI8yEzR/CRLKihkeliNHTiTJydXFNQ1fbpqqPFRrwLX8/2hNPYt2GB+yUcxo8yeZXT86SEVUs0Nf2w42Fh3WJnN940Jlyshyd56/Xd3Te5CAiI2Z4/4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 14:41, Lorenzo Stoakes (Oracle) wrote:
> On Fri, Mar 06, 2026 at 02:25:51PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/6/26 12:07, Lorenzo Stoakes (Oracle) wrote:
>>>
>>> LGTM, but you need to fix up VMA tests, I attach a patch below to do this. Will
>>> this resolved:
>>
>> Thanks!
>>
>> I assume that should go into patch #2 instead?
>>
>>>
>>> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>
>>
>> [...]
>>
>>> ---
>>>  tools/testing/vma/include/dup.h | 7 +++++++
>>>  1 file changed, 7 insertions(+)
>>>
>>> diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
>>> index 3078ff1487d3..65b1030a7fdf 100644
>>> --- a/tools/testing/vma/include/dup.h
>>> +++ b/tools/testing/vma/include/dup.h
>>> @@ -1318,3 +1318,10 @@ static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
>>>  	swap(vma->vm_file, file);
>>>  	fput(file);
>>>  }
>>> +
>>> +static inline unsigned long vma_kernel_pagesize(struct vm_area_struct *vma)
>>> +{
>>> +	if (unlikely(vma->vm_ops && vma->vm_ops->pagesize))
>>> +		return vma->vm_ops->pagesize(vma);
>>> +	return PAGE_SIZE;
>>
>> Should we just KIS and use PAGE_SIZE for the test?
> 
> Yeah that's fine, but then should go in tools/testing/vma/include/custom.h :>)

I'll place it in there, then, thanks.

-- 
Cheers,

David

