Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26E30EB28F4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 08:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CF786B0089; Fri,  6 Feb 2026 03:55:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47CB06B0092; Fri,  6 Feb 2026 03:55:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E526B0093; Fri,  6 Feb 2026 03:55:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 268A26B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:55:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C1B211A077B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:55:44 +0000 (UTC)
X-FDA: 84413423808.10.C50313E
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id BF29CC0004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 08:55:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nfQ7bbch;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770368143; a=rsa-sha256;
	cv=none;
	b=CMLOa0fDTmzWAZHFNUhJR4P6gAOH0vmSqmk4XQkUqeCgZr89e6iL/u4F0GZdvrtVI46Axs
	fVcr3rXldj65TyZu/ZUV8DA/DRRRsfG+GalvhtD173IDq9HQ3sLyq5ciOzquMLEy15cP2Q
	ZZ+8x8RvEUIfc2wM3cb+POUOe+6H5tM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nfQ7bbch;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770368143;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wp7Qazz8xwMa3br3OGB1GRZNlhrigjBZUeslfFenub0=;
	b=CdEYKjHVCBhnsgng8WOxpAw3MQDOnMgY8L8uu5x/5WPLmf71nujkej5QgbTeQlse5aGpHc
	JfboDRNzvb4pGz3U2wHvwaorNINmRveaRSc0qrylX9CPckNOOhsXyvQ+J0g9AY1nS4LzlQ
	RbCo7R2XPXwGHu0IQbbl0T9bWdIRAyk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770368137; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Wp7Qazz8xwMa3br3OGB1GRZNlhrigjBZUeslfFenub0=;
	b=nfQ7bbch5z907Fy86dwYu3w9EX19oKQO/GgCUvbgqV0q2O/ID5b3gr2tmH6l+A04YXk2NTOYlPmYMTLjmFw+sibQRCXLKgM6zwfLLYiEeiAIkg6ZB/aSq6+gL5QJPg0g+d+WaifJyHUat4Krcl4IB333+YOEYhvcJgOqsBFJvuM=
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wye899q_1770368136 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Feb 2026 16:55:37 +0800
Message-ID: <70ed2de7-3e66-4a23-85bb-e0a4c5b61088@linux.alibaba.com>
Date: Fri, 6 Feb 2026 16:55:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
 <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
 <1179320d-6bab-40a4-a7ac-dbcfbab24623@linux.alibaba.com>
 <c225864f-192c-4cf0-a5fb-411de8c22eec@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <c225864f-192c-4cf0-a5fb-411de8c22eec@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BF29CC0004
X-Stat-Signature: ehtjiqpjrtgb6pqg8thr4dqckpppaa9d
X-HE-Tag: 1770368141-132800
X-HE-Meta: U2FsdGVkX1/QCjSVFPO/vjZc7dMI/sPPssMDhaZX8MIZA5aa3mP1Rtz1wRSgkcK+PSSSa24PPO4dqTvjBxP/IscaqJGEJPGTEh5Qqc6L8/kC/naQ/uOxphdWtHlYHYeWBPmWQu0ueTt2JVLgA1wYuTEnQNpIXU7i+5aeUnKUOLkXsD9v0RtSaCb//e5vUcKb5MY+hmpYK4yOPgiEWTjhaKsGxXUEviJGXNK8H5Td0WRzZqY9pgxtuf9SuqUhsUCjOjKMxs28WEkw3u3y9hOXRYXiVLkXRn9bAYvJOzxlfo0Wlhd9Sfghm4cqvJzXFDK2VnS0H/xOquPqnBqCRHnQldPWLI1X94JgpkDjDetdNo/ugjx8rzK+P9AyrAGXjWx/SGcyR+rvfwKvdPl4PqcYU9iItnGTTYfyyt0OtTJxYp2bOyDoiXWzaRRdj6G4/EJ74Yq2k8yNxqawBkU2rsbyJDPDB+NxxeT/PkGGBU/sBgWY/R2boomxIGTz6dBp/6StxoYEqDA+VpYWHYNEiH87k+ySUn9+81IXX9oMJVWppqRkhkSqbYxBT+4fhkdwq0JTJGfjUi6xZlUzj+fv4VQP3rlBV0kCM2jzKJffXzK/itgn3Skv0hLU1XQ54jk+9yre+zBx6nmaO6QTd63rPpK0nLsAhqpOn8gvzD4E3pUOIX60TVlKUUNQzUHor48e27Y1NxCbVZgUb8znbz9gchUEV5xn3gi/qufX/Y6icZm59RsGfMSOfB2SaN9axB69CJP8ArFsPyaq7hKjlmr+m/vJXB8wbITuibINfaCWLoO7FcPBPHRsNZnAweOA34pHxfYJj3Q5KjCfASw5q6ZMtfeyUI1vdz5GNIi/BnxvH0vaPqqH2esXqRWz9fzKR/W6QRYdID93oxrox63BbeizP82Bmg0FGfYrl/wq/QTEG19DDpxlHtlURFE0/RFgh2Qhzf/RrxNnAO6+Onu9yOLNmuT
 zAdmR6J8
 XKPosSZ0uYreEqM3Bla/8Hqy1fms6DL+Zvyqz0JjTVHldD2YduALgVP3Ud7rkMUstEM6oCG5s7P5dZEMNMyBXvBMRRKGlwQixc28Ps3odsLidnIxdAqN3luUHDcWdSTsLSpupGOn/1VPdn75woTIEGTsv+4LMW42RAjo+eit0pthVkHs3Ru7i+aZkMpMIr/6xrKHmXbF+aBug2t39zo8hoOsi1c1/X7l+8/M+44C50YAhTbPGyS81f53bC5P/7gMX+A6klJeeMz3gnfyqOae1pKmMz2wXtOqmr/fznSQZUoP9Z+s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/6/26 4:36 PM, David Hildenbrand (Arm) wrote:
> On 2/6/26 06:12, Baolin Wang wrote:
>>
>>
>> On 2/6/26 12:31 PM, Sergey Senozhatsky wrote:
>>> On (26/02/06 12:38), Sergey Senozhatsky wrote:
>>> [..]
>>>>
>>>> Right, I thought about it but wasn't sure.  Could the inner loop (e.g.
>>>> collapse_file() in this particular case) loop long enough to fail 
>>>> suspend
>>>> w/o ever giving the outer loop (khugepaged_do_scan()) a chance to 
>>>> freeze?
>>
>> Yes, that’s possible. However, if we add a try_to_freeze() check in 
>> the inner loop, we need to consider various scenarios (such as 
>> anonymous folio swap-in and other potential cases?), which feels too 
>> hacky to me.
>>
>>> For inner loops I wondered if cond_resched() could be an indicator of
>>> where try_to_freeze() should be placed.  Those cond_resched() calls
>>> are there for a reason, after all.   E.g. something like:
>>>
>>> ---
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index fa6a018b20a8..cee08466a069 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -2431,6 +2431,9 @@ static unsigned int 
>>> khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>           unsigned long hstart, hend;
>>>           cond_resched();
>>> +        if (try_to_freeze())
>>> +            break;
>>> +
>>>           if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
>>>               progress++;
>>>               break;
>>> @@ -2453,6 +2456,9 @@ static unsigned int 
>>> khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>>>               bool mmap_locked = true;
>>>               cond_resched();
>>> +            if (try_to_freeze())
>>> +                goto breakouterloop;
>>> +
>>>               if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>>>                   goto breakouterloop;
>>
>> This looks better than the previous version. Let’s also wait to see if 
>> others have any better suggestions.
> 
> What prevents other callpaths (faults, read(), write(), etc) from 
> similarly triggering swapin?

Usually it’s just a userspace process triggering one page fault to swap 
a page in, then will return to userspace. There aren’t other kernel 
threads like khugepaged continuously do swap-in in a loop.

> I recall that there is a notifier when the system is preparing to sleep 
> (pm notifier or something). Could we simply hook into that to tell 
> khugepaged to suspend+resume?

Do you mean “struct dev_pm_ops”, which is used to register PM callbacks 
for devices? However, I don’t know how to use it with a kernel thread.

Also look at how kswapd does it, kswapd also uses 
kthread_freezable_should_stop() to check the freeze state.


> Essentially, making hpage_collapse_test_exit_or_disable() break our for us.

Ah, yes, even better:)

