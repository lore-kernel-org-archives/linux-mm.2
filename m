Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C1E9606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:41:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bnc/bhRw
Received: by kanga.kvack.org (Postfix)
	id A5FFF6B00EF; Tue, 17 Nov 2026 16:41:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A38406B05B1; Tue, 17 Nov 2026 16:41:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94E316B05B3; Tue, 17 Nov 2026 16:41:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 741626B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:41:31 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 022D7C0575
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:41:30 +0000 (UTC)
X-FDA: 85445932782.07.E9D03A1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 409F7140003
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:41:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bnc/bhRw";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794951689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGk+DFVe9G3lrZK0q6FM5QjUlw6oOxXtR4uzvN0+csw=;
	b=SsKnfkIO5f0J2OoVBklcVwc3zHGYp36W5JqNrVCu1IEH+ItJqhb3mnpSdrldsT76G1bGkm
	lW3DRjybZRNNVy7Y8tSvM4SgUM6/ID2JRGBoOyhoEjR+FeCzau+6lijnxMUJ/QzBnAk+Rh
	1WfLO1qgLPyW60cW0LFfLviwIgD1ffc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794951689;
	b=r71SAibM8NIlCY0gGR49TjdoTpAvMM8RcBrDyZODmYQbOqYlJmq17qUOVGpUTys/fgNRdn
	V/mSvH7+6A0hmMBhl/s20x/2K81MdTetbRA4LfAGxD6FReakT59aoNKeQtw3IxzxeqzxgM
	Htw7w50yyxuPLLX3uSDND4dWwH+0C9M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="bnc/bhRw";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8964F612D8;
	Tue, 17 Nov 2026 21:41:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB5E1F000C6;
	Tue, 17 Nov 2026 21:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794951688;
	bh=wGk+DFVe9G3lrZK0q6FM5QjUlw6oOxXtR4uzvN0+csw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bnc/bhRw5E0IDRCFeDwlKJ8EwQHTrX8og3jwM66r7QFpKAXb0fNGURcTEpQiHCm8N
	 JB7GL+O3Zx97ebeTC+1wgYKvrWxXQXdmZ6UMqnN1VazH5fSzdVE+DmbuSgdW3a4dky
	 gnpemLLi8mWk1mMt9g009N+E3oBJfDbBKjtWErEVdZK5xiSyrYPZldfiIGhU1cC65n
	 k7dhPZ92nbelkVG4yI1rpLXmd1JL+EDgFoN0Z72UK8ullhMOUBoDbe/8DEAWitgWQA
	 nWfafAY6gefsZqLWHg+F0WaYN5qoiRVDVSGw747Rt+nRGN9fG526d5MpPgDmV2S0oq
	 vr2djMHgdJpaQ==
Message-ID: <fffbb241-222c-4e39-8421-cb5468039e7d@kernel.org>
Date: Tue, 17 Nov 2026 22:41:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/highmem: refuse to copy hwpoisoned folios in the
 !copy_mc fallbacks
To: sashiko-reviews@lists.linux.dev, Yuanhe Shu <xiangzao@linux.alibaba.com>,
 akpm@linux-foundation.org
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Kaitao Cheng <kaitao.cheng@linux.dev>, "Garg, Shivank" <shivankg@amd.com>,
 vbabka@kernel.org, ljs@kernel.org, liam@infradead.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org
References: <20261110112641.1196786-1-xiangzao@linux.alibaba.com>
 <sashiko-outbox-208876@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <sashiko-outbox-208876@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 409F7140003
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gncwezjpwqed68njs7s6kzdwtwotnp9o
X-HE-Tag: 1794951689-465341
X-HE-Meta: U2FsdGVkX1/Jc8WTaIFc/ApfpcxEel128Z05VcaJ0N4iY8ICnWJelQ5MA7UBuzEoyx0OTT8pUrByxJkPFPTH59fLMfIX+MQ8mb9+I3CXKQ11PdDVcMvwHEkqjfZYFYlHYbK0JLI7FpLBMr7sWPa+Df7n5icI5j1pDiml7EdjkOzk7yjRV8bfhPkK7SEtHdNkcktUiOHg6yqi9crEaST77XAK8u3yIb2k2m2YHeZMXn3GqWjoiLbNHlGajbeXuWh31xiY625FkEkIvCKUpJW25aRf9xzZKIFt/Jd+Ew+50lv0f6tAUQ5fYb8soG3psH2HGNENvyQ0R4g5qTTIBKgZLtHV6bld4BUA8xMTC5pjA1YkHk8PForxo+ZuCD9awbf1gxISnQXWMDk986ihVBmyA7p+GQESdOpj+3EL0azmI9gNTPSJ1kbZB+aIgPvbggsseUfRRnBlxVbPCIHBwfVC8nVH4reOvbPblGxsZYcQE25egQU4Lri6s3NrAUF6LJUcS/32sW5bIDhnilKEYY5LbswnG7JvhHcBO/755exKgPnAKJnirVL6FETWmsd9dN3ie2K1A4gwMR4DCdjGuJFEviNswyhnMCkyNuH5Wd37FnGR9KVnn7CHYI+0jiizVUDxirNXPOdzxAXM5hz+kulaTCjw9SzfMrsiSSU2o+DOlYyY4LxAkv3yjfpAYz53a3612Zx9Dl9FvUc2gSy2XDWSDZPNCRE8BlEDPOH+vxCRHXCQz4sc8nuLSRB3WIjJ0K7a2quRcNfTDq3bYGTdXE+K0tNGj1vaA1CqwY6BD7yCclqxrShLg6nc6DxBl70WduOBta3H0RZQbKIO1747CnwyM68JkT3Dk2ZKW+RLyeqWIxIQuY11Hl5cUhZDCi043J6PNo88MrXD86T9Uvxf8yN8a5G3M7gxWfa7MLE0Ux4ok5fc/RTUn35k2wlpe4MMOejhWMxLqQhA1bauB1uJ3vE
 gJN8gSao
 Pq9dQaik547ZSO/HHlsocw0S0DjGQ9ndHRT6g7npRviGVHE26CCORFX0QOmIhzyrbLjgC9U6BsKpTCyh4dFR3TSMJzs36+UitIJkFXPCX8U3vn/JJDPCofLyafrHgNSCCzu6w7bO2k9a8xE4Uu0XFBRRliW+5LwxD91cgJF3dtU2NupGgNzXp7Y1I52RGWH7WV/PaGwI3gQ688oWNVxlc1KOWw8r1YleHeOXbo4dJc1rkCjel6Jyd+L3OYIQtKUtoHXYiswXMH/xbw3g1miOq1uIOwGfR7LzzKcksvqqB999KBn4FPYsJCrEouPbewgPFG0vejMgRcoLZoliLWQj01aWwM46eR4e15EgnDNq5SA6s9UIF6X8Fh0Dkt2S264T82/jTciS63m4ir866wsOxQGwOUYnGWCf8wZ/IMQJMwZGNJ2QpmBoQHmC9lrnYBn1OmttT2Qpe2cTA4VkyszjnIIg7Dw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 12:27, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/highmem: missing is_page_hwpoison() check in
>   copy_mc_to_kernel branch
> --
> 
> commit 5b18d6f721e579b691687c6c8c6355f1e1a00b17
> Author: Yuanhe Shu <xiangzao@linux.alibaba.com>
> 
> mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
> 
> This commit checks is_page_hwpoison(from) in the !copy_mc_to_kernel
> fallback implementations of copy_mc_user_highpage() and copy_mc_highpage()
> and returns PAGE_SIZE when the source page is marked hwpoisoned.
> 
> Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
> 
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index d7aac9de1c8a4..c3240f70471d5 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -473,12 +473,18 @@ static inline int copy_mc_highpage(struct page *to, struct page *from)
>>  static inline int copy_mc_user_highpage(struct page *to, struct page *from,
>>  					unsigned long vaddr, struct vm_area_struct *vma)
>>  {
>> +	/* Don't touch data that is already marked poisoned. */
>> +	if (is_page_hwpoison(from))
>> +		return PAGE_SIZE;
>>  	copy_user_highpage(to, from, vaddr, vma);
>>  	return 0;
>>  }
>>  
>>  static inline int copy_mc_highpage(struct page *to, struct page *from)
>>  {
>> +	/* Don't touch data that is already marked poisoned. */
>> +	if (is_page_hwpoison(from))
>> +		return PAGE_SIZE;
>>  	copy_highpage(to, from);
>>  	return 0;
>>  }
> 
> [Severity: Medium]
> Should the #ifdef copy_mc_to_kernel implementations of
> copy_mc_user_highpage() and copy_mc_highpage() also check
> is_page_hwpoison(from) before mapping and copying the source page?
> 
> copy_mc_to_kernel() only catches hardware exceptions raised during the
> memory read and never inspects page flags. 

I'd leave that out for now. This commit is explicitly about fallbacks.

-- 
Cheers,

David

