Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E77C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 08:28:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D9C6B0088; Sun, 13 Sep 2026 04:28:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CEA96B008C; Sun, 13 Sep 2026 04:28:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89A086B0092; Sun, 13 Sep 2026 04:28:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 54A306B0088
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 04:28:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 289E31A0636
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:28:23 +0000 (UTC)
X-FDA: 85208062086.24.AEA33B3
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3820C100004
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 08:28:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b="N+mTLB/K";
	dmarc=pass (policy=quarantine) header.from=nebusec.ai;
	spf=pass (imf14.hostedemail.com: domain of yuant@nebusec.ai designates 74.125.227.140 as permitted sender) smtp.mailfrom=yuant@nebusec.ai
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=nebusec.ai header.s=google header.b="N+mTLB/K";
	dmarc=pass (policy=quarantine) header.from=nebusec.ai;
	spf=pass (imf14.hostedemail.com: domain of yuant@nebusec.ai designates 74.125.227.140 as permitted sender) smtp.mailfrom=yuant@nebusec.ai
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789288101;
	b=HrYbY2QaDYx6pxbFsExh071dqDBNp2ufBe7csqsVq0TA4j+KjxJMUVsy6MuaQ3tZy6pH/B
	NanEq+5/3Epo5IbaWVT2lwJnigrttd3VuJ81Viw1W0ToKnUpN5PkT57s+s8wohImlxzqT8
	UG966OkB9U8sNEaOpwr0yl7IjCYaBm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789288101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v3Wg1/T7qs9s38umMK8pE+I+NucDQhuBS/OGkDGwop4=;
	b=7Kt0cNQNUZe5dbkcfPq6TfTlsJqBJrtIo0971UDEry7aftzofhV66neWfJsSPpaSh/bMXQ
	Zps8VlsST8DB9AmcHTnXLSOuxQ9/p2T1MGz0NoZznarEPDqgbGsVQGIP0EI5Xxom8Gl/0a
	FgUcEJVtyN91/SRqgk7LKwW4Ri18N0s=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d747eb79fbso5901305ad.3
        for <linux-mm@kvack.org>; Sun, 13 Sep 2026 01:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nebusec.ai; s=google; t=1789288100; x=1789892900; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=v3Wg1/T7qs9s38umMK8pE+I+NucDQhuBS/OGkDGwop4=;
        b=N+mTLB/KVasP3DecHhK99IHCF8frSF9B//+waBTcPXsavXWxbBw3y5vzUPL3gdJfj2
         pnCgmPn8vqYJhfAqC0HZWNkWvb4EDPbt8kH7Zq5EormqOKET1N1Wp6EgrjUPDACXo4WY
         RSnrrooLcmIVQ642vOnRiaywR3QzUaMbnVN0ZBEUYwVWBWddQ0EOheW44d3iS7iDxbOu
         tf5aiiGzi771JyCAoqaMRw18UYUtidG3jNEiLKOKJTnIKmUMBh0dUl2849WJIXMZ3Hpo
         0Ed8JR82WTH+cMMi7s+Vmt332THQRuEVkNwy9nMRMHbqBxKBHobeUaRV26mVptMjRpFV
         bKug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789288100; x=1789892900;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v3Wg1/T7qs9s38umMK8pE+I+NucDQhuBS/OGkDGwop4=;
        b=akQsdXyAnkZUVi6pNhZnAEytxl3bDxGTbh/cOy18VxCOK/fNG9NBhPpsF33eAcz2FR
         xR85WZW6LMD0PTAYAQy+XdhAYPzUjI3fy1w7h8gDt6huNrh91Qu5WY8hGcx0iOLn9+ZE
         B5Su96pBrfmoOPT8OZUdoBHpXeFUJ8zQUeJ9cOOSNSuCuIM4y7q0wbsvgF/TI5mBIAzx
         cxRQizKb6wDOccWQSJpZXdv1BVPWEslBn/gysl8S77P5yXwF4XzMwYivqmwD8CV7NW9o
         RM0RZeTDbCiKN1eOiQiAmyHzMZDM4awmBd9TRvVtUQsNhMbZ17pqJgKhnjF3lZaP8+B0
         n4qQ==
X-Gm-Message-State: AFuF++kTcRWofI9lRszit6bzbFV+qzNdjjiFxbjuujMSZPtEBX8p/ja4
	C92LSk8G8QMKateW0lxH/hCISJLK29v/zFX2+0gkOCgLsAkIYWYmjnHAxB48Kr5ecXNAh5jFo2Y
	axsB+dwcZ
X-Gm-Gg: AYBFou10K9CmWQ6t5/r+OnpTNTatbuN4/bUQWHdhsF8vJZWL4Oc5zqCjtioz16oV5Dw
	54VoqQFo/qmAo2Es13YCT2Xse6UkGcuBlWlq+ASkQURfUm7t6+0XfFfBRxTLs6yOk3EV2wqtJ7D
	qZZWZO7xglmRAl6t6ui3z/m5GHTBh1gE8LPRnBmtyM6qVxrqIaxPDPG+tGMO/uft1OVwxSVO1FO
	KwTedB85/gWIVM9Mi7C2UFMxbIVG3wFY3zFh7IodnRgwkJ4wkhqb1I9TH9XB6bJX22wboGbxp9i
	UU6R4BV3G5YFkhgLgh84Oa5Ok+BMaUTUWXQaS1ALt5WSE0mfNnLcCOLRMGOWslbFr9oksHPcnwS
	05xc0SjqHr2gAIsfIXEYqQ34lv+JxJ5pCaLkQVCp1GwV1jUuqq8FUs+UKkQY7gnrK4+4lnxwFGb
	xWEeD4QVCl5MNgs8hY6nUV8titUYo/KhjXiSHXFt2eLgTljpabF1YNNcMITCPxZBIofMTHcHN7/
	0omTGj7A9GpWKfGty29YJLZ9BpRn78ufp7qyQvi08yvxPmg0IP0
X-Received: by 2002:a17:902:c951:b0:2cf:afe8:b722 with SMTP id d9443c01a7336-2dd2a34b1d8mr214674955ad.11.1789288099951;
        Sun, 13 Sep 2026 01:28:19 -0700 (PDT)
Received: from [192.168.4.59] (c-73-93-246-205.hsd1.ca.comcast.net. [73.93.246.205])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33baf0ea9a1sm16630372eec.8.2026.09.13.01.28.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 01:28:19 -0700 (PDT)
Message-ID: <1146fc8a-94c8-4e28-aa38-cd0322bea9a4@nebusec.ai>
Date: Sun, 13 Sep 2026 01:28:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] mm/memory: constrain generic_access_phys() to page
 boundary
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, david@kernel.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 notasas@gmail.com, rakukuip@gmail.com, david@kernel.org,
 Ren Wei <weir@nebusec.ai>
References: <cover.1788842306.git.rakukuip@gmail.com>
 <e06e28a46c2a176238f03b5740df0913e57c2861.1788842306.git.rakukuip@gmail.com>
 <20260909231815.bcb1ca6091ae0ba1b5ba54e1@linux-foundation.org>
Content-Language: en-US
From: Yuan Tan <yuant@nebusec.ai>
In-Reply-To: <20260909231815.bcb1ca6091ae0ba1b5ba54e1@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3820C100004
X-Stat-Signature: miewet84kskodctkr9c6ojkpuc836sdo
X-Rspamd-Server: rspam01
X-HE-Tag: 1789288101-932185
X-HE-Meta: U2FsdGVkX1/s7LEdVBeiSgfX5e7DSowOOhpi7+uF20ptMa+RsMD1Y+5S6/wU2r51ixgD87oiljrq5wl4H0oinoUwHE/dk/gPC3VhWBffjLkmYFsjD2XxY07/W9JpzZGX97lzyVEw4z23soXU+ixUrJgF+QVDhXpTi3ugEBuqBJ2igAhJxUYo3tKdd9T75fAnRtZRu1scd+rBwUps3SN8cIrF+xowzbdmTmM58Ghrrme8Bb3ZYEVwjpXEjPWEkwpURyHJPPRXdlW9Pn+8gvfkfYV6a8HYxtLEzbc81TBFvxIAwQWMyj3/eYXLDKIxdZEI6VxxLKyuwJP770om35HkTtTkwR1L7kt31rHJzO4E/MaK1L2wIwGxvXI9Wr6cARyin13/oYtq59iSX8UOab85p693aGHEhR8V1GArifU3zPjEbGWydGSzmMbmkXYcMgi3BHsrGlJ2k/d/yW2nEAzFszltNdh4nehw1Va/3eeTF4xVjYErGAvx5bwhQAVdb0qJK/1vBPxTPZ7DqPlfbm8QS0gx4Jb+LR0XtdgMpI5+PwcjXqaRyGVJ4HtqRud/sQTnG0UrFeOqkXgYcvuR2SaZvgOp4f5jGph73UFZOIvt3eXaA3F+Cvatr79M91NUYT4Zh+V/l3uZ3UI/6ZSrbbtTT/ZU22QwI61j/lPJ6PvhgRQgDVkRt5/gzQ+KwULMAldbrfmu9stz5AEXbKNznvFl4cdj1DaEjn4HjHemaUbW3h/yPoyW6decRMPDItT9u7UOdz+h+7GVgkfZsSQYZtqFwJjHzKOAGWBHjZAZUeNYiOjfDHc8ZByCiIRA42NWXn+zBxFqabZCQZ2zL6TUR7VSyj9COkFcIICTpLHNYw8ZX0pSfEwieMpH7vx6Cn2jKf6pWB8z4wGvl9jVpo6QVKWW1uWplrw3W/k6bts6jhgjXr3F40qgNBty6+9HxljMKWk/DdQeZG8pwYv5E4vjj/N
 wYvl56jE
 wTUQx6E7bKxxyYjlrz8a5ILU49YPp0DXHY6LpsmMPxCGJ8wyLZ4kc2KzXFCI7dsG24nAbSFzhNcsFzIYMP5zrXWUI+fIjbbtxkOrNnkuDNts3XK0WFjy5Wew7eWQSztTJNa8Vb4gjKiQCXb/5aWK7EmerGHml79Nkmxqi6ZZa5DEkB89OQks5FHZYmMG1yBl23J1EX5X8mJ/XIaR6vv1EsvCipEr1XShW9UkZhjuAMLwXck+YOZMUjnrJ4cM9yKdJzIb1PgS+KjRCSzotKxUSjn35riB6R22epRUGyp3Q6JSrce6gSIlAT6Ix9EqueGPxmYAzkwHYthojjFxilzwSR9RRtvHEXsoH4LYgHZZjaOJj30qrHX1Xl7cxR0d53GuNgxFKgSCmSIfSUpVJHMIcwCF5foBqL2pIGTiGwoanYjjtwJcNGKYWH0nULDWUms+qH+KEB0gwZNY6EFPkxkOyP5y8Tw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/9/26 23:18, Andrew Morton wrote:
> On Thu, 10 Sep 2026 11:42:50 +0800 Ren Wei <weir@nebusec.ai> wrote:
>
>> From: Luxiao Xu <rakukuip@gmail.com>
>>
>> generic_access_phys() improperly validates the memory access range: it
>> only validates the start address using follow_pfnmap_start() and passes
>> PAGE_ALIGN(len + offset) to ioremap_prot().
>>
>> This poses two problems:
>> 1. In PFNMAP VMAs, consecutive virtual pages are not guaranteed to be
>>    physically contiguous, and individual PTEs may have different access
>>    permissions or writability.
>> 2. The mapping may cross VMA boundaries if len extends beyond vma->vm_end.
>>
>> Constrain the access in generic_access_phys() to at most the current page
>> boundary (PAGE_SIZE - offset) and map only a single PAGE_SIZE via
>> ioremap_prot(). Since the caller __access_remote_vm() already loops over
>> the requested length and handles partial transfers, it will naturally
>> iterate over the remaining pages.
>>
>> Also add a missing (resource_size_t) cast during PFN re-validation to avoid
>> truncation on 32-bit PAE systems.
> Thanks.
>
> When fixing a bug, please ensure that the changelog always clearly
> describes the userspace-visible runtime effects of that bug.
>
>> Fixes: 9cb12d7b4cca ("mm/memory.c: actually remap enough memory")
>> Cc: stable@vger.kernel.org
> Especially when proposing a backport.
>
> The cover letter tells us a bit more:
>
>   This patch addresses an issue in generic_access_phys() where
>   accessing memory across page boundaries in PFNMAP VMAs assumes
>   physical pages are contiguous, which can lead to accessing unintended
>   physical memory or exceeding VMA boundaries.
>
> But how does this manifest?  What does the user see?  Has it ever
> happened?  Is there a Closes:?  Any reproducer?
>
>> Reported-by: Vega <vega@nebusec.ai>
>> Assisted-by: LLM
> Please update your LLM prompts with my above sentence "When fixing...".
> Let's get this fixed for the future.
>
>> +	len = min_t(int, len, PAGE_SIZE - offset);
>> -	    (phys_addr != (args.pfn << PAGE_SHIFT)) ||
>> +	    (phys_addr != ((resource_size_t)args.pfn << PAGE_SHIFT)) ||
> hoo boy we've made a mess of the types in there, but I don't see a
> feasible improvement in the context of this patch.
>
> Also, a [0/N] isn't needed or desirable when N==1!  I'll consolidate
> both into a singleton patch.

Hi,


Luxiao is helping us fix some of the bugs found by our bug finding tool. 


Normally, our patch series includes a reproducer in the cover letter, so
we usually send these patches with a cover letter. I believe Luxiao
simply forgot to include the reproducer in this version. The reproducer
for this bug can be found here:
https://lore.kernel.org/all/cover.1784428532.git.rakukuip@gmail.com/ 


For future patches, if we are sending a single patch without a cover
letter, what would be the preferred way to include the reproducer?
Should we put it directly in the commit message, or place it below the
--- separator so that the reproducer itself does not become part of the
permanent git history? 


Also, I have been collecting the bug report by llm into a syzbot-like
tracking system[1].
The tracker aggregates bug reports from multiple sources, including
Sashiko, and then attempts to validate the reports and generate
reproducers to make sure it is not a false positive . It also
automatically tracks whether a bug has been fixed. 


For the networking side, I have already imported the Sashiko reports
into the bug tracker and shared it with the net maintainers. I am
planning to do the same for mm, but haven't gotten to it yet. There are
already a few mm bugs in the tracker that were found by our own tool,
and none of them seem to have security implications.

If you have a chance, I'd be interested to hear what you think. Any
suggestions on how to make it more useful for mm maintainers would be
very welcome.


Thanks,

Yuan


 [1]
https://lore.kernel.org/all/20260830115546.3942129-1-yuantan098@gmail.com/


