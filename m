Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FC47606A334
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OU7844Pu
Received: by kanga.kvack.org (Postfix)
	id 95C496B05B3; Sun,  8 Nov 2026 22:11:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933776B05B4; Sun,  8 Nov 2026 22:11:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84A676B05BA; Sun,  8 Nov 2026 22:11:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3EE6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:11:09 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DDBB9805CB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:11:08 +0000 (UTC)
X-FDA: 85414104216.21.8A6BCE2
Received: from mta1.migadu.com (out-83.mta1.migadu.com [95.215.58.83])
	by imf12.hostedemail.com (Postfix) with ESMTP id D75F540005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:11:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OU7844Pu;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794193867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMGfPTTtDg5EzJ91P2PF2WwXNpU6yv+yBoe1TBxGD/c=;
	b=5rV5igSUS+59lm2u4iRSEbTEQq5/RIHvTVoRQ3SCO992uHxSPtW9dW8b37QaDlrcDJFe+l
	RQnfjll3ujI9BYFrYD2lKl5mwckTzKUgP87YpYv3aojHxPBLmIVUsVL86A2uHwI9JbwOkP
	WOeJg1nRw1FqHagNLpsmOrJ/50lG888=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794193867;
	b=F/7eeBNSgx8PuqxGPPxr0uZArCPxQLTjBUD1Lx7148l+1na42SC6o+NFXrVjZ/tvCWihvM
	veWElcjEPtISgY7ahqw6ChRVi7yV4VLUaC808ZrZPYMpa7JNiAEAvEFvY0e7qtFlYebWCW
	cUzz0BxSJ/Z7TyMT86f/SnbckPt7Khg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OU7844Pu;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.83 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=397/iKYYDV9/c98+8Zdk/ANop6jNsXxFQVhqLErzJm4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794193865; v=1; x=1794798665;
 b=OU7844PuvsVN8vQIztiQ9rON4du1bLDFAfDyXgSS5uVLT+YX2SyGMUm2N/z5LpGw34RpEMLz
 tJ5e7k1UCBJPwNSeJPZd13yR3AXUqbnY0szt2ziU+Ldagp4nZ/knIHAOVaQTIt7/VhfilaW/XGa
 MPC4M1oP0OFNmoMq0UfBgSfU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8422819e0d5f8816;
	Mon, 09 Nov 2026 03:11:05 +0000
X-Mizu-Trace-ID: 8422819e0d5f8816
X-Migadu-Flow: FLOW_OUT
Message-ID: <c266ecbe-167e-4a99-9e40-ea4740eda7c8@linux.dev>
Date: Mon, 9 Nov 2026 11:10:56 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm: hugetlb: fix GFP mask propagation to CMA
To: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
 akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <61ee04513d6cac32347ebec9b295025b8a1f07ca.1794046188.git.zhengqi.arch@bytedance.com>
 <au9ZvQObSY3y2s2c@localhost.localdomain>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <au9ZvQObSY3y2s2c@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: iuxc7cyuazpm97k1bodmoacfc84sqxqf
X-Rspamd-Queue-Id: D75F540005
X-Rspam-User: 
X-HE-Tag: 1794193866-935474
X-HE-Meta: U2FsdGVkX1+GhMs3Au/Lzb6uViPH0t4eonPN6pe4VVbO3t6eZtHudwwyr32bwqwP5jlns3m4DHrAa2MQ6y4Q8P9V53CRfSk3ZsQ/NT7b2MMvBMl3rIg0D8eLyPWZy5EwJhZ1ufOwS0WX7pprem3LKHGxfcTDZ5s8MEeDNVKJZb4rwV2hQhwO2wKuLbqhWWr3I61zTDrxkitn0qaVdcwAWL+uF65Jc0mvZnCFJ2Ka3MQUQipZ1ZirN1xxcTVNAOd+3X/fHZ5yzRlPX9kNXHwnceINjiIikjb3MtVRIrwKgSYFfqnolSkuIqS12EDrXyxDc0tMylEFaSLNNBIqK0ar/BWBISUl4XjkNvFLrCecYOA0jwqed/IbmeJi1qdFuyxOCkRBt+npL4BWltDaOjI10yBxmu0zqJr9h/riP62i4jLZ+QPcjWQ4BIjCXODo4E/n9lF0mBiLMue7c29AxyhiYMEcic3gFEAdrji0ecOBSpmu2H/XFVhjJpj3gm/8WBrEsmlyr8LxU54mPB1aJCnzalgXqNfXCxMRKrT2a0ss+D2l2cif3S0WvszmVDYgJnBpdfzPHRui6T0DhgCBDXrJpWJ2O+poUv85H4ETPNYDL/nX0Ze+JwaOc/N6f6vN5fEONAWT5/TYEP2IJHNDmOby67M+KRQZv7e1motFM23mlpdEQ1iBpDX3wrcmui+/8KkceRvkcHrdBMYvlWYsWxj52E4tNUUVxdKraVaPgTtSZr3wl88fn5pl0ht0vd76uwzqKee93nViqEB9dhcFsOTwVB2zYzTWJbE5Wkl515kbWTBL/dsz0r/iPAFdb7VpVw15qLtIeEGyDnke7pHA9g4UskPOHSQaQHrVRW0x82bOi1tjnx7GVtosypbtyWR6+xVH1lUepSNhDyHNyNjx4NM66dR6TiS1tWK5cz6Xqhc94ogK9T3mlI7By6S8EtUYiLUPygCxY1A41RHWnQUlr46
 OtDF0fQF
 QWE8vxfmzix+wipv6xbNCM2JhWMV7/FEMSd7O2+7fHaIhWsgdC1tiQ0ST5maELCZvqrfaXpW8nTaCnsyDW4zj2KOQEXReXfHsKUuh288712JeitLnR2Tql7ZJ6F6nDdhW1z5XDceA43p6bTbqlMGy+ES76lko2u2jrJ59QaCsPaGPoAHoY+OMIzEC7McJDODTd0iAMKibFwL6W2Y+SpLf6tehO5nWpe9Aaupdlk0wvBUM+MkqMLCoQ6aSgwHNGGWdTzI7mK+y0Ddg1zlUevR4vmTg+hbEMOH78zvXyIOT9qVszZM72ICX5uR35M7EgqewFLOeg2k96ZvWS/wMggbmYcEoXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/8/26 1:02 AM, Oscar Salvador (SUSE) wrote:
> On Sat, Nov 07, 2026 at 06:30:47PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
>> during the first MPOL_PREFERRED_MANY allocation attempt even though
>> the caller clears __GFP_DIRECT_RECLAIM.
>>
>> Pass the caller's GFP mask through the helper so CMA respects its
>> reclaim constraints when trying the preferred nodes.
>>
>> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
> 
> Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
> 
> A comment below:
> 
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -933,9 +933,10 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
>>   	return __cma_alloc_frozen(cma, count, align, gfp);
>>   }
>>   
>> -struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
>> +struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
>>   {
>> -	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
>> +	if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
>> +		return NULL;
> 
> I think this needs a comment explaining why we are checking for __GFP_COMP,
> because it might not be obvious to the casual reader.
> Something like:
> 
>   "The only caller of cma_alloc_frozen_compound() is hugetlb, and hugetlb
>    constructs its gfp mask via htlb_alloc_mask(), which already sets
>    __GFP_COMP. Check here for usecases bypassing htlb_alloc_mask()."

OK, will add this comment.

Thanks,
Qi

> 
> 
> Maybe in the future we do have some other users of this function which are outside
> of the hugetlb realm, but if we are propagating the gfp mask down the chain to this
> point, we do have to check that those users are also setting __GFP_COMP.
>    
>   
> 


