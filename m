Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9775606A31B
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 02:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=kmPoq6RL
Received: by kanga.kvack.org (Postfix)
	id 990CE6B05B6; Thu,  5 Nov 2026 21:54:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940B56B05B7; Thu,  5 Nov 2026 21:54:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8308E6B05B8; Thu,  5 Nov 2026 21:54:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 436566B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:54:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BFF17A06D2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:54:13 +0000 (UTC)
X-FDA: 85403175186.28.C1204F4
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 83DE0120006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:54:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kmPoq6RL;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793933651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xAvnfgdYn02gy1CmYaw8G14nazz/ElOEY3XPVZ3GfBY=;
	b=7ZEiH29ABN5dRbPcSoS+OaKi/KKtkyvw0YH0ccemgaFtC0q0mkIbea0wecBj8abq9ZoEzm
	kFOdSiyaUQy/yj9j2oHYjkEdTQFHqWfL+yIwAQsjXOobjv1F2oZH1qdBR6lDVxuwouuvin
	QJ3SOT7OLkK7UAyW+YEUPAVke7IRCjY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kmPoq6RL;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793933651;
	b=IDGrq/l9pXawYODtc1KwF/36MfPuQgpwsAl1AWYRMNa9tYaGhnDr+IRdL/KlCFXS4y6NMJ
	noVa3k7gRaWW8ohVrDIo2KZqol+0zxGPXWC2rjYOYOp6cH43NBfbZ5+Rmzq3i09tgfb9P/
	/ECjuTuZ0rYSpTE9yc1YAV4x20lYmdk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793933647; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xAvnfgdYn02gy1CmYaw8G14nazz/ElOEY3XPVZ3GfBY=;
	b=kmPoq6RL4e3MZ7qSc8fXq5S/IQmTVi43UmT38ZAphsVyTEFC4aF/QujAAT37CFGfqc8Gtx7QWvAzQgIjtpuBEG0p4S3VHwYN7A5T7hJUPGAD9b1hVto8mSjgZV3/DE0mb5dbqfqCdT1lFIrwfg5LUa3YXOm4BT5+tzAM7hdxZLk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XEA9APb_1793933645;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEA9APb_1793933645 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 10:54:06 +0800
Message-ID: <9916bea5-3b53-43a0-8f65-cc33995adb23@linux.alibaba.com>
Date: Fri, 6 Nov 2026 10:54:05 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Lance Yang <lance.yang@linux.dev>, david@kernel.org
Cc: baohua@kernel.org, akpm@linux-foundation.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, qi.zheng@linux.dev, pfalcato@suse.de, ayushr@modal.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <f06d2004-f3c5-46b0-b708-780ffd6727ce@linux.alibaba.com>
 <20261106023326.10838-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261106023326.10838-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nhpcsf59yk996fr4exp6wkgtx8k9an11
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-14.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 83DE0120006
X-HE-Tag: 1793933650-568843
X-HE-Meta: U2FsdGVkX1+VQt8jGC6wuPse/rGMS32XVSR5ybPBtUn/v3s8mmspqRKZkAR32EHZLnDD18ekUpwFDCO6oYl8CXw+GQovCOM5+McCfqhrn74F509jot3TNQE1zFrkGAxT5irHyVCGoDEsEE7UtvHE4itzBZbsIUInz35rXw1pFBdNGD6W8u6hCyCjtVoJ7XezW366HGXjmCqCGDtr5R5nxd57X7ocd0uOLfXqazvC4tUxNijZv3nvuqMa9c/IZfUA6O7mEJkTboo3xNm0fzsDsN8itLbpiW0t1QwlwyFLP5RZSonStJ483UT2Cl75Xwo+njRrqHGBjQzl2LcygRtQeLiOO3lggWghEecOT1yZahnG2Dxxs5ny1Lh6kz1jVXx3Nm29YkFz2zo+l/GXQWobcrU9Acgx/N2lk4kq3Gyi18Djh7tUeug/TQEOxGpJs7NdChxlb4fOWKlEjPLH2E3NO32GiXbFZx+oFDDCjE0F+mLT7jlfoo3QCu/kdFmb+10YYtxsm8OZpvzdLKpPr/hHCEi9s1ajQdnWVp2yhr57ahox/ciHpMLaMZY88L0QvFlaa/fbKDBu7DevEodAvOw/9s6+vfbsu9xEiYkWuoW/+iHWuF1QWu+pYQxM6oMMml42Xr30oRCwoLd08P0V6hDw0Kj6JwGg1lFb61ZrVim/v+9r/bmAq2OzQmLRh9SHDWlZKGOGP808SVmtP+WgViL4E5eAfa2Huy2us/imheT89/R46/95hapoczHI1AL3Dcfs4BC9+9jsA6XS5+LLFij9DYvOhROBI1ePo4RJgux3/t6rYAHT2PxzTgZifo14yOyzTZMb+QgohI76rIRe0Uo4klnPNWMpmm23ZJ0eRY6Ffdq3xjF10a6+1/ltfZEVLkF8r2oCqCEZ2nacLpRCLXZZW6IHVddeBP3Z7m8sWaHo5WbvI0/jvDTsaUQAIX1nZg0/oTKOKsQqCyY9RAB4c6v
 PWoH6k7k
 dNNw+rqsw8BXAMTEQnIFINjIq3Hvay6KhKGdaSx50i3IKncUdoW/QOXtSMJkf53pbxIMKMJ0KC9UdYzf4fAzOHrH/cMxQ9ekgXzDpMlIJSmJ19D2obkgmSeQQkVmzNeY9EfZO2OOZAD3OrSJTL+p8PyUWA+0zkfrDr5Pz9UsuSxXVUmCE0vArbT8XIWxAleLsH0vcgR/uxBtxALGWFuQhyiouenMB0nZI+VsgfYf7DUDNJZXkEYBRbFdGDGdVvBXH5x9EeZXjlDT2Y0cATBsBwaK5qS2qUI6xDwyq7hKoxRAsBRvSvoyV3gfQh5vTqBBpyBbWzTAth+iSOUddfmV0O7wyd8yZcur5tdAQjKV/OE1zb3Cw6+Y0NBWvx+btWXoLeXR0/yNDW1IBrT4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/6/26 10:33 AM, Lance Yang wrote:
> 
> On Fri, Nov 06, 2026 at 09:57:47AM +0800, Baolin Wang wrote:
>>
>>
>> On 11/5/26 9:22 PM, Lance Yang wrote:
>>>
>>> On Thu, Nov 05, 2026 at 11:06:29AM +0100, David Hildenbrand (Arm) wrote:
>>>> On 11/5/26 10:00, Baolin Wang wrote:
>>>>> CC Barry, who added the TTU_SYNC in shrink_folio_list().
>>>>>
>>>>> On 11/5/26 1:48 PM, Lance Yang wrote:
>>>>>>
>>>>>>
>>>>>> On 2026/11/5 12:54, Lance Yang wrote:
>>>>>>>
>>>>>>>
>>>>>>> Good catch!
>>>>>>>
>>>>>>>
>>>>>>> Right. Whether the folio can be PMD-mapped doesn't tell us whether its
>>>>>>> PTE table can be reclaimed, so those extra checks can skip synchronization
>>>>>>> that the caller explicitly asked for ;)
>>>>>>
>>>>>> Ouch ... one thing I missed ... what about order-0 reclaim?
>>>>>>
>>>>>> shrink_folio_list() only sets TTU_SYNC for large folio, so can't we still
>>>>>> hit the same race there?
>>>>>
>>>>> Thanks Lance. But this matches the purpose of the TTU_SYNC flag, which is used
>>>>> to avoid racy checks with PVMW_SYNC. If no TTU_SYNC flag is set, it means the
>>>>> caller can tolerate some racy checks.
>>>>>
>>>>> For this case, I think we should set TTU_SYNC unconditionally in
>>>>> shrink_folio_list(). Barry, what do you think?
>>>>
>>>> That makes sense. I hope this doesn't throw a big wrench into our reclaim
>>>> performance numbers.
>>>>
>>>> Can someone benchmark this?
>>>>
>>>> But maybe we should really follow-up with the folio-size based optimization in
>>>> sync_with_folio_pmd_zap(), where we only need a memory barrier (and sufficient
>>>> documentation why something that cannot be PMD-mapped can get away cheaper).
>>>
>>> Dug into the history a bit :D
>>>
>>> TTU_SYNC goes back to Hugh's THP splitting fix [1]. A racing zap could
>>> clear the PTE/PMD before updating mapcount, so the walker could skip the
>>> lock and return before the accounting caught up.
>>>
>>> Barry later enabled it for large-folio reclaim [2], to avoid skipping
>>> temporarily cleared PTEs and ending up with a partially unmapped folio.
>>> He mentioned that small folios had the same race, but with just one PTE,
>>> they couldn't be partially unmapped. That's where the large-folio check
>>> in shrink_folio_list() came from.
>>>
>>> Then PTE table reclaim [3] added another way to end up with an empty PMD,
>>> even for a folio that can't be PMD-mapped. The truncation fix [4] moved
>>> the rmap flush before the PMD clear and extended synchronization in
>>> zap_pmd_range() to cover those folios too.
>>>
>>> Looking back at the truncation discussion [5], you also pointed out that
>>> page_vma_mapped_walk() needed checking, and suggested a possible
>>> folio-size based optimization in the helper.
>>
>> Thanks.
> 
> Cheers!
> 
>>> [1] https://lore.kernel.org/all/c1e95853-8bcd-d8fd-55fa-e7f2488e78f@google.com/
>>> [2] https://lore.kernel.org/all/20240306095219.71086-1-21cnbao@gmail.com/
>>> [3] https://lore.kernel.org/all/92aba2b319a734913f18ba41e7d86a265f0b84e2.1733305182.git.zhengqi.arch@bytedance.com/
>>> [4] https://lore.kernel.org/all/14ebbd556cc4941f0ebc43da59fa6a2fdca25dc8.1793148609.git.baolin.wang@linux.alibaba.com/
>>> [5] https://lore.kernel.org/all/08a0907f-8e3a-4071-a2e4-fd1411c446f3@kernel.org/
>>>
>>> So, how about starting with order-0 folios?

.......

>>>
>>> atomic_add_negative() provides full ordering for mapcount updates. With
>>> 243cf1f67b36, rmap removal completes before clearing PMD, including when
>>> another CPU reclaims an empty table under PTE lock. So smp_rmb() is enough
>>> here, without an extra writer-side barrier.
>>
>> I'm afraid the memory barrier here is subtle. __folio_remove_rmap() is
>> complex, and in the CONFIG_NO_PAGE_MAPCOUNT branch,
>> folio_sub_return_large_mapcount() doesn't provide full ordering, so we
>> may still need smp_wmb().
> 
> Yeah, agreed for large folios. In the diff above, only order-0 folios
> use smp_rmb().
> 
> Note that order-0 folios take the fully ordered atomic_add_negative()
> branch and skip the CONFIG_NO_PAGE_MAPCOUNT branch entirely.

Yes.

> static __always_inline void __folio_remove_rmap(struct folio *folio,
> 		struct page *page, int nr_pages, struct vm_area_struct *vma,
> 		enum pgtable_level level)
> {
> 	...
> 	switch (level) {
> 	case PGTABLE_LEVEL_PTE:
> 		if (!folio_test_large(folio)) {
> 			nr = atomic_add_negative(-1, &folio->_mapcount);
> 			break;
> 		}
> 
> 		if (IS_ENABLED(CONFIG_NO_PAGE_MAPCOUNT)) {
> 			nr = folio_sub_return_large_mapcount(folio, nr_pages, vma);
> 			...
> 		}
> 		...
> 	}
> 	...
> }
> 
> And large folios still take the PMD lock :D

IIUC, the memory barrier optimization targets all non-PMD-sized folios 
(including large folios). That is, for PMD-sized large folios we still 
use the original PMD lock, while for other non-PMD-sized folios we can 
use memory barriers to sync.

