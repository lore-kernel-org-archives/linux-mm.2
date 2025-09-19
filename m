Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2972FCAC5A0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 02:53:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C50A8E00C3; Thu, 18 Sep 2025 22:53:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575348E0008; Thu, 18 Sep 2025 22:53:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1FF8E00C3; Thu, 18 Sep 2025 22:53:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1508E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:53:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA12385D22
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:52:59 +0000 (UTC)
X-FDA: 83904477678.09.A43F1C7
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf07.hostedemail.com (Postfix) with ESMTP id A6F1440006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:52:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kVXCRY7A;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758250378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVFSgUKKAuFnEqSEgabfcIAa5Tbls2E1LiZ7DjuSkOM=;
	b=ZmVVk2/QI+WmMEaFuxWqZdcxEsb2AI+On7344LhKfJNmWudtLoL2LHFlSTlFujG0ToKAJ+
	ut4CVVjTw07tychpMb4ISARQRERf+mYPd1zzabjS5YASM6Owoucv0a2CNOQnwU/MCLN2MN
	1FYZ5dAHYN4LjtFcz4ZrFB6vSLfRRWk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758250378; a=rsa-sha256;
	cv=none;
	b=T1Wd5ui/3EoYRaVIbr621KyBCZhYurpKiMq6wlAXosqMESXDmYsogFiAMIZM9b6hpjsZen
	LBJToUA4eNmrJGPB83/3KIYLuoSnyx5gCkyQog8jI/Oq+7XH7xnmZriZtAByVlNUESm6nN
	o1juPr4YhtzkctJbmf7rPprD/axygTo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kVXCRY7A;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758250371; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gVFSgUKKAuFnEqSEgabfcIAa5Tbls2E1LiZ7DjuSkOM=;
	b=kVXCRY7AIKLY4tecMy7k2SK9NKPkGqFsu3tPl7A7YLSq8NItuw+15JoMP97pQfxocPi+T1RLJtOoIFYYfsT2rdrQrTCMlh5AtxYIVXq1rmOoIQyyqGdxwXCiBE+oNjtGQdDMXbBt1FU8vJ/X2S57LOyFNJjIB1+GCsPRS9x20j8=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoIF0kP_1758250369 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Sep 2025 10:52:50 +0800
Message-ID: <a06fb734-cd3d-42c8-9b06-4b2427d3030b@linux.alibaba.com>
Date: Fri, 19 Sep 2025 10:52:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/fault: Try to map the entire file folio in
 finish_fault()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 David Hildenbrand <david@redhat.com>
Cc: kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>,
 Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>, "hughd@google.com" <hughd@google.com>
References: <20250918112157.410172-1-kirill@shutemov.name>
 <20250918112157.410172-2-kirill@shutemov.name>
 <6e6f596a-1817-45d6-b674-04e8aefde6d4@redhat.com>
 <962c9c49-8603-4a57-ba07-36e395eb48a5@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <962c9c49-8603-4a57-ba07-36e395eb48a5@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q4wakwjsd5581acmib59uwh9astronj8
X-Rspamd-Queue-Id: A6F1440006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758250375-801519
X-HE-Meta: U2FsdGVkX1+Of9VOUw9U/rUytBGPKCPyxeA5TKXliahNpLf07rM89c5o1coe9t+Wn3+F7C9wJ+z+mhxkkuMaHpxXux99wsTH0sXFGruxH23xJg4uAK5Dh+8KZcF6Ra4zyIEYyBwZEoTAxmqMy2CbbZojDkK4+HldqTSysAYlwVbm11FJc0uj+a/Ekf25wHWLtt5ai7VYeqx8nkh7wpYzeRHRJcH/g2PWSoRi2JOM19tPPYsfArwd6Lv943mvXEBZmOpWG5ylDoiBVGI1OYH+wskYJTa+mZ7MINCreYzcj/oSdBQV608roqb36pS2Kf9a62zRiiPdGsmRLu8B9FLoib0ZgyiqQb4jhKMv7EVLel1NGRBxTAUIP5A3pzkwEl+oI7a4si2pGMHWLkHt5Ov0zuBrM53PptKfg+3s8qwAsW5t92h7rZ7BZtq7EGW/k8TMD5lJRrDfEMojNq09xs5wpY3q0MQzwbunT1Uf+1+Uwo06bkYdgN7uy9u+odw+TLM7KLMmg8F6xv1Z3YcF7yZokck3OMexZx8EOJfpY5h+mVsbXygd5bmS90xcUm8BqrtBeMewpHyrIfWhx+MwE2ioctIFRLiIyw2tjJThbSR4sINNJnvB2r5veWD5+AjVOm/aS+1qHxf+hE/t8f54cN+6OSqKSikedBaVtuDOXSJ/GZmz88ywJiXLk88GFFS3y8BTuvChm223oOQ/WjFomZG/zH2p9vO3kfUq78znbfREWiJ/YdLUNOxBXLfyJPXYr95MTG609iN1YVqTWUPBkxsH5r8P4I5WiZ5TE+w7yfxvtcb/gofoLN1nRuFT0Nmd+KV8mXSlkLYTx4fJtq+aA4Q5iNuNLe3MZ8r/cwEVHp6PIh5pfpgF8a3VAi4PIQxSOf+VfNKrXzaJpsqD+7jaoAfElSKj4QlNI3nEn5SQgY7omPj2rz4hhPITFrAuoc921rbq2G3+Tm5mhORBfzGvPiS
 Vns6N0aq
 w5U09CAZQd0S23s0RteQuWI3AxzmgBxiL7iWzbFUjCpOQrGHmhhFA6/XX/CxigufXKJhejIHF2/1me5VYqbsS0pUYnm1HtmSmgUBYxCnudDEGh7UI3ObJGDve2r+fiQFijXEJu8hA79VynneiUlwhpm3GfRranePsDZk5JrMqiZEYx+SoJdSf8iP1PMLV8pBLTmLKPYu0eU4L6Q/eFLLIE1lRDIGSrA1a52QmtgzPXkJiRuIQ9YJXaEkj9pluJiPyhb93VcOOUxw12J4ei9jeqbGFywDzE6YbvWSunIZnVqEa37y138lahRrODuCKr/ogzkTtZr558qMx5aKGPp2DwYAG7znNqlhSSCu1jl+KzTJn5OlkUc/lvqTwJLsZIjncdh4Jqhn+hlMiTLY6JgXy3vDEHkL9Dx8BYaxE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/18 21:13, Lorenzo Stoakes wrote:
> On Thu, Sep 18, 2025 at 01:30:32PM +0200, David Hildenbrand wrote:
>> On 18.09.25 13:21, kirill@shutemov.name wrote:
>>> From: Kiryl Shutsemau <kas@kernel.org>
>>>
>>> The finish_fault() function uses per-page fault for file folios. This
>>> only occurs for file folios smaller than PMD_SIZE.
>>>
>>> The comment suggests that this approach prevents RSS inflation.
>>> However, it only prevents RSS accounting. The folio is still mapped to
>>> the process, and the fact that it is mapped by a single PTE does not
>>> affect memory pressure. Additionally, the kernel's ability to map
>>> large folios as PMD if they are large enough does not support this
>>> argument.
>>>
>>> When possible, map large folios in one shot. This reduces the number of
>>> minor page faults and allows for TLB coalescing.
>>>
>>> Mapping large folios at once will allow the rmap code to mlock it on
>>> add, as it will recognize that it is fully mapped and mlocking is safe.
>>>
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> ---
>>>    mm/memory.c | 9 ++-------
>>>    1 file changed, 2 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/mm/memory.c b/mm/memory.c
>>> index 0ba4f6b71847..812a7d9f6531 100644
>>> --- a/mm/memory.c
>>> +++ b/mm/memory.c
>>> @@ -5386,13 +5386,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>>>    	nr_pages = folio_nr_pages(folio);
>>> -	/*
>>> -	 * Using per-page fault to maintain the uffd semantics, and same
>>> -	 * approach also applies to non shmem/tmpfs faults to avoid
>>> -	 * inflating the RSS of the process.
>>> -	 */
>>> -	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
>>> -	    unlikely(needs_fallback)) {
>>> +	/* Using per-page fault to maintain the uffd semantics */
>>> +	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
>>>    		nr_pages = 1;
>>>    	} else if (nr_pages > 1) {
>>>    		pgoff_t idx = folio_page_idx(folio, page);
>>
>> I could have sworn that we recently discussed that.
>>
>> Ah yes, there it is
>>
>> https://lkml.kernel.org/r/a1c9ba0f-544d-4204-ad3b-60fe1be2ab32@linux.alibaba.com
>>
>> CCing Baolin as he wanted to look into this.
>>
>> --
>> Cheers
>>
>> David / dhildenb
>>
> 
> Yeah Baolin already did work here [0] so let's get his input first I think! :)
> 
> [0]:https://lore.kernel.org/linux-mm/440940e78aeb7430c5cc8b6d2088ae98265b9809.1751599072.git.baolin.wang@linux.alibaba.com/

Thanks CCing me. Also CCing Hugh.

Hugh previously suggested adding restrictions to the mapping of file 
folios (using fault_around_bytes). However, personally, I am not 
inclined to use fault_around_bytes to control, because:

1. This doesn't cause serious write amplification issues.
2. It will inflate the RSS of the process, but does it matter? It seems 
not very important.
3. The default configuration for 'fault_around_bytes' is 65536 (16 
pages), which is too small for mapping large file folios.
4. We could try adjusting 'fault_around_bytes' to a larger value, but 
we've found in real customer environments that 'fault_around_bytes' can 
lead to more aggressive readahead, impacting performance. So if 
'fault_around_bytes' controls more, it will bring more different 
intersecting factors into play.

Therefore, I personally prefer Kiryl's patch (it's what I intended to 
do, but I haven't had the time:().

