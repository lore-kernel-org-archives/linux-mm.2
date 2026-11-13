Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA059606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 11:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wZqYZCGj
Received: by kanga.kvack.org (Postfix)
	id CD3466B05BD; Fri, 13 Nov 2026 06:55:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3A86B05C2; Fri, 13 Nov 2026 06:55:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE09F6B05E0; Fri, 13 Nov 2026 06:55:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9CBCE6B05BD
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:55:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B7235160198
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:55:00 +0000 (UTC)
X-FDA: 85429939560.24.0D85462
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4669B80007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:54:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wZqYZCGj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794570898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jqJ295QKfxdTGGYRv7XqY6kexSmTE646xCDgSnYdGuY=;
	b=NdV9eGYjWanouUg9ounHszU/DycZy2/6adobUZy3KoMfXIfOKa/R//eX6wMYsLN9xPEQRj
	xEMi0hfpWKOKndgUxQ0LPM4hHxrkaZXqXe3+gX84/4xUd1M76wk9FkdsfLHt9ur9gTRKg1
	Gh6V0SeR86r4UTdFvFYSgolromST2f4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794570898;
	b=15j8h2DMuuN7sO6hmMNSh8ht24g1L4EEU3qYG4FWTuLFhWb13q1ZjjbfUL7+RXNhb7I99n
	wFXmBvJXVOJRaDj/osYPeMSWd8/VU785PGRAYfGthzxFpuMzko8kPFEyihVDaN6ItkSH+7
	WXfRDf9V/ILyiEMNALJeFTgeT7Zprik=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wZqYZCGj;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794570893; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jqJ295QKfxdTGGYRv7XqY6kexSmTE646xCDgSnYdGuY=;
	b=wZqYZCGjBs3wlm+CD/qwKq802ER9X5tq1N+i5kD2YRG+dKQv2G+CAht93jFF2oGbESgnEL0tRXuSX6quVu63b9DJfX6u1b3nFRqkFmI6cmAiKhEMpcgmJWCxqi/mbHdgs6189y5os8kHKlG/1YzeXM/q79VYhMSmT+W+DyJgUoY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEezp1N_1794570891;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEezp1N_1794570891 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 13 Nov 2026 19:54:51 +0800
Message-ID: <9f0d2468-b086-457a-ad3b-a452020305f0@linux.alibaba.com>
Date: Fri, 13 Nov 2026 19:54:50 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: mglru: use pte_table_clamped_end() helper to
 calculate the end
To: sashiko-reviews@lists.linux.dev, akpm@linux-foundation.org,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com
Cc: baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, baoquan.he@linux.dev, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, mhocko@kernel.org, linux-mm@kvack.org
References: <b2386c5da61f9a15e60daa421b033bc1e0bcdd41.1794481498.git.baolin.wang@linux.alibaba.com>
 <sashiko-outbox-212685@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <sashiko-outbox-212685@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3u6arweze6x9b7wa3xcy9uqknorjjx4m
X-Rspam-User: 
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4669B80007
X-HE-Tag: 1794570896-486167
X-HE-Meta: U2FsdGVkX1+wDon8R7jQQ3ATQd6Uo+pwDvPKKYXjcHxFP8o9bT/J1aPib2UwUgTgOwKmJbIhynv4m2T+BxsIxpn5wQFZyrLi3NM4305utR7zMAGA3WyBsJnBqWKgBKbj/nUO9HqCfo8ShLz4RIFQAGWFm2LtCgDh03nhE4JjA/byFwaB2yAlet/65Uk5mXpRMRIWgJW0l8PYrOQH5uquLcH/n6X73R0LSzxy/vi+xsGZPJpwMFsvHEFK6+cqWHncZjPYAKbxwAjDuy8ethG1Mxg1pQkKUPELRF41kEvHoAA+LTOa38ZDZG+x05w3Kw4wQ7QUTHnOlAkvrIIO/9W4rASW9EW/HviI2IZX/8+jTwkOXWuXT3WrOlu0h4MxN2indBR4Eao6yORelr5Uq6JWVehD7aSfo/owbmamQLrJ8Be5DtjSYwrH9DQwv7phErxkuKFBoaZmekkn8VJfQNDeEl18cPoE4jZBH87EkTkXGW7W2pynJEH2DoBM+I5ByqCHTGQMFoa8/C4ekaIgIsGeSMU1LehGD6dCOKZ0uF7aJbpzPOE1PqFNFoksn1DLeUOkGiyRw8clrHxMAPlt6lTUhwJzRT6Py20poADZjcR3YXHi/WoJlU5Gh+IEv02jSoLvCa1KkJNQ6u0lZGQgyCizkglsRQ3oPJQ9Dqa+U1y8wT93/mvKi4Yg5Au7GdG1i5Ia6eQ0I7zYYma80CcsGThGvBZDvXcjrWfpHJOPPB3Saz/Zs5w/YltCiNeQpNnRd3TMviO9hSTqHr0uOw6xqRimynhtrv3SYcDflF7NBWvwVOLwgmMDr8m/OTdwDlaip648gj6vV/1tMn1CgNOwqcdnjwB87fFub27XzK632LWze6YNi2tyav3cs+3m3X8k7LaZOgaE3hqPGnYjx/n2tH0RhuAKBhk4xmWZprVRNYo3KvHGFuKyBDZLDoe0um2NgwuiC54f3bkA1f498lUx7gq
 ysQO9Ds0
 5T0C4ZjNQIFpdK7XgNQSwO8CuIIOhM9AGdbOp6o1dm5GsNTHEy41GIe2XvXIo2azl3tsJI9AznPgkqDqKHmo4ue67dMJAtWQszYpXhwU/y6klJsT2/3Tak266qx5HvKw2stXpZmnLI3kGljA0FnrE5y4mAk5qX/00Cb58mj7thf7H5CLklzW4NdfX0I7L+ZNfHR+ml1C4WNUeshVmvCceGNjqhT+234bkY2iomaN1ZPOuZxcpgYOkGHQ+LIxqfPRXVvbi6gs7lOZflRgLbHESTv73FgBBl5BIRa8VcDSH9ct/Q6ZZSORccf8VSOVaYtwGEDCGqXh4aZGSBDLtlH4I6t7lN0MsyvTgmRFuFrTV3bAOHb+ZUB7W3s/Umw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/26 7:13 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [High] mm: mglru: call to undeclared pte_table_clamped_end() in
>    lru_gen_look_around()
> --
> 
> commit 921adf1dcfd3cc8b15e0745e6085a76a09ac3fb5
> Author: Baolin Wang <baolin.wang@linux.alibaba.com>
> 
> mm: mglru: use pte_table_clamped_end() helper to calculate the end
> 
> This commit replaces the open-coded PTE table and VMA end address
> calculation in lru_gen_look_around() with pte_table_clamped_end().
> 
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 25a224746c36d..cb8635e41a38a 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -4340,7 +4340,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
>>   	walk = current->reclaim_state ? current->reclaim_state->mm_walk : NULL;
>>   
>>   	start = max(addr & PMD_MASK, vma->vm_start);
>> -	end = min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
>> +	end = pte_table_clamped_end(addr, vma->vm_end);
> 
> [Severity: High]
> Does this break the build when CONFIG_LRU_GEN is enabled?
> pte_table_clamped_end() is not declared or defined anywhere in the tree,
> so compiling mm/vmscan.c fails with an implicit function declaration
> error.

No. Because you applied the patch to the wrong tree (mm/mm-new). The 
helper has already been picked up in David's mm/core.git tree.

