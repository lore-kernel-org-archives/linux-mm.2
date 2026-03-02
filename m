Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00E4DEB3626
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 17:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463206B0089; Mon,  2 Mar 2026 12:39:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44AA46B008A; Mon,  2 Mar 2026 12:39:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361206B0092; Mon,  2 Mar 2026 12:39:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 210E36B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 12:39:19 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAB091C1B7
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:39:18 +0000 (UTC)
X-FDA: 84501834396.18.D51AFC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 593F28000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:39:17 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BjOZhIS1;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772473157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M5LTMoF4KMrqf/CGd745vvekKKpL7OsO1+1zUQfeN/I=;
	b=MeXzqDkEz7cHlCMtMJLVwWI/Ovcr8/dUS5o6jWpRff22ss3Sbq30lCmLB+00husk8xuUjY
	5SXUasEyYpGPzU+Z7F8NzS7vZAbnbrk1lqSt6XCtQOo65uPBprARxZFlOzcGQ8dIE6609T
	XlsmSPalu7MM3HIdoCUNWdKCnSwzVR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772473157; a=rsa-sha256;
	cv=none;
	b=bXMnU9EL1c22A8q5Bd3PABj2jFlJBTb+5Md9HgqARSBi1movUZ+G7d348lTt0yPECslvaA
	dmtPlFO2xee2mdeapXX5cwuylS+DtMGVcyty0cih7/EHLd6tKz7zrjr6mJTcyldpAEZbEr
	D3jMZqKS0enVlSuXD3Ht8na7qHAbJQ4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BjOZhIS1;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9DEDA600AE;
	Mon,  2 Mar 2026 17:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E44DC19423;
	Mon,  2 Mar 2026 17:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772473156;
	bh=J8SlytO19KJ8aK5m93CHmbOOhXWaxaJUlrp7HsS4cTs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BjOZhIS1yc20H42TEcja7V1LtLcQtD/sowaDcRoB8M5YN0JULXjrFHrcG5WiOLMSB
	 oeOIiOgu98Xk4+j7XkTkXIgDPkagca7mE6OBA8PlHIKSrtVc5a098iX302zu47G6AL
	 if4cluD/VCnpuV26h3fvt4ZlwXfHc6Qx9tZS4WSSvwciTCKAPIT9WnvK6iLOkKTAZf
	 kfQRQZ0ExBqYaEN77Rff6MQezyvJk+oT4O+O9nqgwhhqmHe5gwDgWuZpDGnr9Rc6i3
	 M+l4ItAtm9Q5tRDbFyE3uEGKDDRBeWlNL+N4w3wM0NwkDpAzDfIo97Bw1Ow8vfIxmN
	 xko9/C7T0oleQ==
Message-ID: <334fd7f2-1054-441d-84b9-d0f94eddc43f@kernel.org>
Date: Mon, 2 Mar 2026 18:39:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
References: <aaBVg6nPQz-WvyzT@chrisdown.name>
 <27c260d2-796f-48a6-8b1c-751ab172d480@lucifer.local>
 <b6096c06-9fbe-48a5-9efe-ae611a2e650b@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b6096c06-9fbe-48a5-9efe-ae611a2e650b@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: sce6di3b8yhi9jcccg7qawwzqwg5cwzp
X-Rspam-User: 
X-Rspamd-Queue-Id: 593F28000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772473157-940350
X-HE-Meta: U2FsdGVkX19O7J5Kkxrz4YTOeFN5M8vO9OpQF2+Y3TcPEaWY3p3LbeuHiEUKAXYfKMMyWGBjCo5xoeNEFuqQ2qfWPiqnOD0VdGhYaGZfX7dT970Jg6OgB3AJV27ync23ZsxlHcogu5mTSmTl+dI0nwKdx/zFdDL+7Nu8qctORV+ThgCzcbN/a61ycPJ02Wrt1rbX2EbqMMjK+Dzig8YoVw03v4dEYrUrFivFZBpRf3Mq53hXelcX2gy78UqeKI4Rq+zToTobr1Fy5UgXceEg9gCTB2w3vVL0P8V7ilgovS+bDLzTf797XB/vi6Avuh4F9LYa+IcrUBVLUng/raMoCL9/LDhgVENRP2lfrWOBduHebwHSwFrGlys+uT/cIaWNvayGNMYrsZ8X0cS7TdbPtqXgZTTAoVpnvW6LcSwjVVz43EmzOI/UdPb/6lSZaC91XhjCbKSJQdD9th6WTYPS+QEaDQoFX6kzzRt1urjmBQh1z3LRW+0uiznkA0hDwZW/qksXIk1ylu2+KvfIMjnEQUymSceROLYiAAaXdn8+iXyo5U2U/47zmwq2kCvm7cjdAfSbPCPcVwTjP5DKIH/81JqHrk0/tI5wHPfDHrOLL2J4LGJefkVT9eY+xYw9+sJSWBKqqkq77/IoShP+sgeY5kQ1O4t25uaXXg+vCtbzd9+dH+rqZnkzmPsonzbb40fscmBOAImEXBem1QhRSFIXP6v7rcFqfvxvru35Dz7TX4prnLOwxKzyvpkHbJmUzGwhbSJ1isZl97VINeYrFRTKXRChLFy9DMhUjIkb+CXm5SqArscE4AMiZSh/95aD3pUiTAomr5TKgY1JwIlAEY1npqpUsdSU9V0hsA4vvbrbh3UmxVCUpK5+Dupwrq+TVxx0C1vY7r2zNEGKEf+fIqoWaaNLj5cvjUdm7hI3IN+A3+zIGCk4gQzrrlmPJdwVEcYwZTedRr2V05ocG4SRf+f
 36hRQMP8
 h3qmp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 18:36, Lorenzo Stoakes wrote:
> On Mon, Mar 02, 2026 at 05:23:30PM +0000, Lorenzo Stoakes wrote:
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 44ff8a648afd..fed57951a7cd 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -2794,7 +2794,7 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>>>  		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>>>  	} else {
>>>  		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
>>> -		_dst_pmd = folio_mk_pmd(src_folio, dst_vma->vm_page_prot);
>>> +		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
>>
>> I prefer my version at [0].
>>
>> Cleaner to actually pull out the zero_folio into a local variable, and also we
>> should mark it special to be consistent with other codepaths.
>>
>> [0]:https://lore.kernel.org/all/20260302170619.867056-1-lorenzo.stoakes@oracle.com/
> 
> OK ignore me, I saw David's comment and agree with him, as I said to you in the
> 2/3, let's just take that as the patch and mark that fixes e3981db444a0.
> 
> Assuming you agree David?

Yes, that's what I suggested I think.

But if Chris is not able to get it done in a timely fashion, maybe you
can take care of it.

I asked something similar in reply to v1:

"Chris, do you have time to follow up, or should I look into it? The
issue looks quite bad, so we should tackle it ASAP."

https://lore.kernel.org/linux-mm/7da49940-e1a4-4018-9db1-208411598e77@kernel.org/

-- 
Cheers,

David

