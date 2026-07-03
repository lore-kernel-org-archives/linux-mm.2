Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C40AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 08:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0C26B00B6; Fri,  3 Jul 2026 04:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B85B6B00B7; Fri,  3 Jul 2026 04:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A7F36B00B8; Fri,  3 Jul 2026 04:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E453E6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 04:36:00 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 746181A04A4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:36:00 +0000 (UTC)
X-FDA: 84946807680.06.ECD903F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6DCEF40005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:35:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SQ89YjgR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=hare@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783067758;
	b=VHIYGouSdw7+jgVLMfHP5UnGsP5NXpwPtYkR/iRH1niEqdZjsEMOt4c+0vOj6SCMluRmhH
	3yE6UWxfFFikTFXuSpaliZhdOXzK9dXm/OiDYI/fmWCrCOwJPrDOfwnpTwXLr22meJPXal
	q9bxt6TTNeVdgrbzwJgx4nFvviH189o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783067758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7WAbGtIrI1EcfzFik+M+qn8x7M7ZtMBRYdePiOvKmF8=;
	b=MnG1AKJYog3uAAJ7pH4DMueq5kphLw+L/tWsKx8x8aD0FkL7ULCcjksvlQaBgfMNA80DrB
	iV179+2CXMBWEPtp4aY9WFHOetItiyWkgcMCKEVdZOhAWNfsDaaOctC9XKv2R5MwOvoN++
	WPLkraGlIUh6SZbMXTLRauBDDM/j6wg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=SQ89YjgR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=hare@suse.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so1872165e9.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 01:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783067757; x=1783672557; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7WAbGtIrI1EcfzFik+M+qn8x7M7ZtMBRYdePiOvKmF8=;
        b=SQ89YjgRISX39MBA2JCZbYlvkj8SKFeuC0h61A769m6NkujVSNJalLeXvGSSIMC6AB
         CexHIK0jUnSkKM/3MyVjrjHa1lQCODVd7YHC7xnJHSqSKteSoYYbrxvobYx7eGYfsE9s
         6a4QWlVQ1EjXSybyTUK3+jBMFAp8ijOumNqYpJj5sU3rUzq++wNc3RiGy3cp/2JSTfPQ
         r0SCp6Gk1mcGMMsKSraLjYmUIAKyC+COmRbLy1sZCHn3HqUm8Jg+bJj6B5nvKyuIBYXH
         g+SDkUohZqNZY3MSVVwqHllFf3oFeF/bT1SPr8DY6Pqs46DS8tS6HlOA3ZXNeNYGGvUe
         hSZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783067757; x=1783672557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7WAbGtIrI1EcfzFik+M+qn8x7M7ZtMBRYdePiOvKmF8=;
        b=cr47DmbioL09A6N7ZX4TaeHWy5+/8/o9U/4MWM79K+taHN0Kkjco2fvkgfv/GzuBFM
         Pe3VmMWClQJrKUOE8jCaMDXOtos2evkOpL/QtNQMnm8B63h8zjUciuwT5rbs5j/T3aD9
         2mJVJTHIUECoYxO8TCTAf2xNhVShgIkGBn/UQt9KqfkAAd6erJvE/kswllMKxF29bnE5
         bV2iKDZq2NavDhTyJ6hObAAQQXTcCOQIU1uDhbLBBX1QiFVZgXQBGkOe/rML+77JP+kJ
         A7YE2qc71gUR9I8677Q3T2HCFVy8vQxz9dnnmY39oRi/u2mIhWMbTwHl5uDXHoB3ixum
         rYpw==
X-Forwarded-Encrypted: i=1; AFNElJ8llzR3c+yN3HsQ3aIXFJSKlWGTxYngX28cNcEw+4tXX3fyFtvBJWEDquEVvqgsgC1VYbWDBUV2ZQ==@kvack.org
X-Gm-Message-State: AOJu0Yw4MA3TAR9cUPR0z2Rlx98y581+/d6jyHf3d2lmO7qkhRMQAFAZ
	D1jjYlChhiWm4kvAXon6/r1+6WTuQkRHSWrOgO3CPLGndynbahyDn3X1FSaoQpkLkWI=
X-Gm-Gg: AfdE7cnvsBMkUtxJ5KHKZLa2/G4U+bCOvNcB+1WZcn948qliZMTx7jmrGF5DUE1uiVW
	KyyGcdptfVo34kb+YUGaeF0sQi/4JPbuTcI+FJtLoDX3EsGs42UvD1zMA0Kr5obWJb7n/+OqoOX
	dT6rLGiipjiP++xDRit6LPv7VhH5/RloaIAIUEibzKOvG0L5PesiOmr2iRKfPnPmiCiMmurjokR
	WU/Q9WnRs3tHL0z+M42wHF7le0/qrzKi+e5oRasU04CuMzKD359noD2yWGDHeRCC16HixCmOmEC
	ZNEzunhSx61ybGEeJoAUzsNyX6Ah3X2VqhcLUQnNGVIpgXvEKFm8ajJ0F2d3pVHL80Gur53XgqM
	XBRHhszOL6YhEP8N34+netlfcbK2+lkBQ0G2lhNuh5UpmHwd5P1CfILrUidNOzI99nEVDYXdtd1
	0wp5M6sh31cwjIX/jGg3WHSCDKt1LgECQks2orG7v7jcNdey8GvYqKuU8l5w==
X-Received: by 2002:a05:600c:8590:b0:492:4363:e7eb with SMTP id 5b1f17b1804b1-493c2ba4f75mr109823175e9.32.1783067756702;
        Fri, 03 Jul 2026 01:35:56 -0700 (PDT)
Received: from [192.168.178.47] (aftr-62-216-205-241.dynamic.mnet-online.de. [62.216.205.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493ccd9d620sm33431275e9.1.2026.07.03.01.35.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 01:35:56 -0700 (PDT)
Message-ID: <5b03b1d4-c094-437c-8934-64b94bd37138@suse.com>
Date: Fri, 3 Jul 2026 10:35:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] scsi: ipr: use kmalloc() to allocate IPR dump buffer
 memory
To: Mike Rapoport <rppt@kernel.org>, Brian King <brking@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
 Brian King <brking@us.ibm.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, wenxiong@linux.ibm.com
References: <20260630-b4-scsi-v1-0-494fb37ebe7b@kernel.org>
 <20260630-b4-scsi-v1-3-494fb37ebe7b@kernel.org>
 <7c8f0e70-f49c-4614-af95-002fb2be11ba@suse.com> <akTjQVQQNdeO9M28@kernel.org>
 <d92f22b9-9a4d-42f2-ba67-0371f85fedd3@linux.vnet.ibm.com>
 <akYLdBME5kgyi8Rw@kernel.org> <akdpddKBt7gV6po5@kernel.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <akdpddKBt7gV6po5@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6DCEF40005
X-Stat-Signature: ppgfkm1rrp7wcj99nohs8gftwon5dkux
X-Rspam-User: 
X-HE-Tag: 1783067758-353600
X-HE-Meta: U2FsdGVkX18s+KyO7VoLH0UuAoykxJHVFO26jzACvmWMe2fCg2kWp8MMyGBwel2VB/3p956eHApurmbBxOCStE8rJmSZqaIm8vjUIttxF5YcWXYu23kuQUoyzrSjp7HdRCvB+AJROP6bE7h4HRp4IhkxcaGsX7TChVok+RCBuIdFEeiv8xSxZTnphqBXP2GEQ0RoNO0ZIBtLJdA5HeYR3a2n958RDgJOCE9CxbUmFwjb7t0tkk/+ub7fbJiJZ8e8hlJ26fllAIbIHHajQgL5cfO3I3xh0Aena0jvic2NA17On0sNv/zS4jBvNx6qUNG3uTQxlYQOOpITfBgZttKj09w+1Ty5XhCFE6kdC8jR6ziWJn+qaxhy7NcnecokCNZ9jytEk0PaugQF99kNG7o6PJ+Mjiuf3bNTIYA6yRmbN3/BaKwGmGVbPzjN+vEaAchJ4fUOQXd/88bcIAaQmSOHeWMJbUHbdn8SjOKED7RCm5/rfFvaLxLvVAlaQJ0RYa5DhyMbBg63/QAWi6iotCnNbTUa6pybM0ebE+E4wQQGJUmrTdzQek96Xvkl8mD+lLqgxE5xfutN5oGg4gvIKBCk4+TBOpn4l33DuaShRcL/gcbUnvpDMmAamdnIFLrg5zKtCpqA8RgOOZdF3/0RRRSEhlbiqUm3H97Ylfl4CIfjmFxFFtbjGXe6S/e6vhst0ZFCZOmMFmO/Cz2RueYgQiVjLmwIMD957JvvHqOcG5eWj9cFQZreria35Yqx6urqeKa9bsZNa/Ne+Hw4Anri5nmxboxhhVz2kpkfTFCZ+KPlLj/Rb1viFWZWRvPGZ/LyKWznFeJ8awPs3EsK4vYoW+JSJp2HImZiK9kGConXzv4bw5BjPlsPdLisOapCt3b7Ic8klvwfxUUxBEtfiKofIOHzA7WQutJj9/AkQzsjIJAbqw9ceovIzaOc3AsmtIbcXOoGUdfR8uKRRA6cHxYPGT8
 ZSvW8EP2
 d+Yy4YC9lUBg6SZR43tdHr8M/AJKVV3dDYlLM/H7bx0az1ZK7FSn9CdhAdcG0k68HuQKooM3HvDu078piMEfbnJMv5FHuaS/lbc0/tlH0VRBEwR3PnL1fhbfzz0csTl8SIxhVIaztvwPfal3lic+tdtgzOpposbtEU7ZxTl1/3Xw3/CWIMRI3UjUoxVCefqPTreW6efH9GaLQBPt5WrJsPye+yf2DK2pSylA9zXK3q2qphXqPZFadYqPDKI6e0MfIFUEPkGeX/nEFwxa8rmht+K9gW1THb4qS59YrTe6OtRKqPd5qdhIdZ5hYAwpa+xGEaV8vos2fkhaGkKUA0e4Y+kVZMR+FZ35wnNUPrhmFEimk6VYzsacWSXJCwSqychP3gKia3U/snxjzrk3pJnQt3NNrB/Dae2MkJ8IspdDIwcnSp5wYp4ItELajHOZxO9PniMd8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/3/26 9:49 AM, Mike Rapoport wrote:
> On Thu, Jul 02, 2026 at 09:55:56AM +0300, Mike Rapoport wrote:
>> On Wed, Jul 01, 2026 at 04:03:48PM -0500, Brian King wrote:
>>> On 7/1/26 4:52 AM, Mike Rapoport wrote:
>>>> On Wed, Jul 01, 2026 at 09:03:06AM +0200, Hannes Reinecke wrote:
>>>>> On 6/30/26 12:54 PM, Mike Rapoport (Microsoft) wrote:
>>>>>> IPR dump machinery allocates memory to save adapter's crash dump using
>>>>>> __get_free_page().
>>>>>>
>>>>>> This memory can be allocated with kmalloc() as there's nothing special
>>>>>> about it to go directly to the page allocator.
>>>>>>
>>>>>> kmalloc() provides a better API that does not require ugly casts and
>>>>>> kfree() does not need to know the size of the freed object.
>>>>>>
>>>>>> Replace use of __get_free_page() with kmalloc().
>>>>>>
>>>>>> Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
>>>>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>>>>> ---
>>>>>>    drivers/scsi/ipr.c | 4 ++--
>>>>>>    1 file changed, 2 insertions(+), 2 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
>>>>>> index d207e5e81afe..5a212bfdeec2 100644
>>>>>> --- a/drivers/scsi/ipr.c
>>>>>> +++ b/drivers/scsi/ipr.c
>>>>>> @@ -2893,7 +2893,7 @@ static int ipr_sdt_copy(struct ipr_ioa_cfg *ioa_cfg,
>>>>>>    	       (ioa_dump->hdr.len + bytes_copied) < max_dump_size) {
>>>>>>    		if (ioa_dump->page_offset >= PAGE_SIZE ||
>>>>>>    		    ioa_dump->page_offset == 0) {
>>>>>> -			page = (__be32 *)__get_free_page(GFP_ATOMIC);
>>>>>> +			page = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>>>>>>    			if (!page) {
>>>>>>    				ipr_trace;
>>>>>> @@ -3226,7 +3226,7 @@ static void ipr_release_dump(struct kref *kref)
>>>>>>    	spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
>>>>>>    	for (i = 0; i < dump->ioa_dump.next_page_index; i++)
>>>>>> -		free_page((unsigned long) dump->ioa_dump.ioa_data[i]);
>>>>>> +		kfree(dump->ioa_dump.ioa_data[i]);
>>>>>>    	vfree(dump->ioa_dump.ioa_data);
>>>>>>    	kfree(dump);
>>>>>>
>>>>>
>>>>> I _think_ we can replace this with kvmalloc, and allocate the entire
>>>>> dump buffer in one go. Once switched to kmalloc() it's kinda pointless
>>>>> to allocate separate page-sized buffers here.
>>>>
>>>> kmalloc() performance is on par with __get_free_page(), but kvmalloc()
>>>> would be slower if it falls back to vmalloc().
>>>>
>>>> I'm not familiar with the driver to say if this could be an issue here.
>>>
>>> This code only runs when the adapter has hit a fatal error, so should be
>>> extremely rare. The memory is getting allocated while the storage adapter
>>> is in a failed state, so anything running on the system at the time could
>>> be stalled until recovery is completed. This memory is allocated and should
>>> be freed soon after the adapter recovers. In order for this code to
>>> run, the iprdump daemon must be running, which will then read out the dump
>>> after the adapter is recovered, and write it to disk, after which time, the
>>> ipr driver will free the kernel memory.
>>
>> Thanks for the explanation!
>>
>> So the allocation is not on the hot path and it seems to me that
>> performance differences between kmalloc() and slower vmalloc() won't move a
>> needle relatively to the entire dump procedure.
> 
> I looked more closely at the code. Currently the dump continues as long as
> it can allocate memory and even if memory for the entire buffer is not
> available there still will be some data in the dump.
> 
> With a single allocation that may be as large as 80M
> (IPR_FMT3_MAX_IOA_DUMP_SIZE), an allocation failure would mean no data
> would be dumped at all.
> 
> I think the current model is better than using a single kvmalloc()
> allocation for the entire buffer.
> 
> I'm going to send v2 that keeps kmalloc() and only changes GFP_ATOMIC to
> GFP_NOIO if there are no objections.
> 

Fair point.

You can add:

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

