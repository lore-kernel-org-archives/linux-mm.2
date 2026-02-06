Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF5EFEB28C1
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 05:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE0656B0089; Fri,  6 Feb 2026 00:13:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8DAC6B0092; Fri,  6 Feb 2026 00:13:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC09F6B0093; Fri,  6 Feb 2026 00:13:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9AA56B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 00:13:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 649231607BB
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:13:06 +0000 (UTC)
X-FDA: 84412862772.15.FF3721B
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf25.hostedemail.com (Postfix) with ESMTP id 960D7A0004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:13:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=m32LZaxm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770354784; a=rsa-sha256;
	cv=none;
	b=sSvTvSGEe7Q4l94lSv+qxx+Z7G8wSpeG1wU3L+gdHAQC0Vaj+3aCHT0WENQ/dZU5BbvZbC
	JH+yjznTxM/gqu0N/n4ci+K4c1Nu95BREEDwRM9Q+TY2es/0VWtOVDNiNiOMZgszASmPRs
	S3fjEn2KVg7uzgxqZsvYtfG2koGiq3w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=m32LZaxm;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770354784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l3AhZNM4Q5k2W3T5e95C5Di+O3vwziEW75l5gal323E=;
	b=D7B7Y5qr+UR5PE7R/Re25kdXhPUc6skHZbS4aYmgPyT94kF2TFjGNyGP/8tYdKG+XFhcFK
	5C0BVyYtwRHDqo1bYKUxlN2G/Mrdy3UnBq+wC2loTvoivgf4MAPpo8znKy+2NOzMiu/Gss
	VvxS7FvOO0j59rNf1O/n+F1Wl5MHCBI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770354778; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=l3AhZNM4Q5k2W3T5e95C5Di+O3vwziEW75l5gal323E=;
	b=m32LZaxmGmL+mZ1zoGN+ySCbVZcxmpHEI9H/QvqGIJ0hAOuBbx3q3+oZi3MnbE+e+MH+fTSbOMhGRPaKsmsLEgXavzRU3bF7O7b9LFn/IhsoFdr2F4xyFoPi54Pls8h0hG7TwDoK4NbayqzgSQ4m5nDd6CuCn91AtPKTGPgVPhc=
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WydO178_1770354776 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Feb 2026 13:12:57 +0800
Message-ID: <1179320d-6bab-40a4-a7ac-dbcfbab24623@linux.alibaba.com>
Date: Fri, 6 Feb 2026 13:12:56 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
 <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
 <jujsgu5ed3srhetch2pbpdrt4tnf2alodrk4nfo7idxmhsq772@lirvj7ftvxgv>
 <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <h3bbxn4omwe2jv32vyjou34me73x5nwg6ai57goqo2qlntq73y@ra75spa3tlzr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 960D7A0004
X-Stat-Signature: m6awk46xw5mxcqpfhx3c8rnzuk7e9mgz
X-HE-Tag: 1770354781-995266
X-HE-Meta: U2FsdGVkX1/kBfXDvhAu2VuCTVHAf42VIXMQyWSfK8SpexCHlvkuNo7Dc2fY4y15pwMAT5+Zw1lB6G37xg2awvfBMSxW/jrJCvD2t155XOfMqFCfUiVbWML3iPTNUak8hJJG7j9ACMqf3kUOQ//v2dhkB700WIoAsz9l8MI2+baKgE5dUuYWiR9EBJyeOI3CXFLTKEg7t/39Xh0TlKAPKsvl1Q5y6oEDfHg1Tf0fE6IUFtfn0DOwUi28pdrceRvjSknNzsOHMbqh8j5lBy8iabRiGjEt19f4UiSk1wIFtLz+Rm7CMPo8+6ey7h19dcVIRANiBcOEEWKjWmuL5vZkI9pQqGDVJ2dnHspVB5uM4i6WU4o43jqPmuF+bri+YtKaUku2izUA60oLAmBwd0vaRv8v6cf8p8fXWF8tpJZq3NFuOh0rpFzvV3WHmEf+QVRy/1xw+gfgWjeiXtRgwiVz7uvgwz1OAK07l0USW+YQa1A1o1xZmX90utGwYFBzSbHY3o0lceSkVq/tF3iWvkpw1CoYHYfy0dju/yC4xkKi165lXK2IMtb0pQ2mz75QLrZ8CmFV/Z5/rYOdeya8eB19tm+hZRFdnH7b/+HHnuxj2ZxKsQ7DvQDGx4XoKps6fyCOQQf05xQC7pwY1ofmeZDCHnhG+Ju+IF9oc6RfB7vWO70aFkDD/m26ud0yCnwu+J3IOCjG8MY3L5wSDElkKKzdEbNzzteytGiEBtBecemMObWMEyo0gBqmTI8N4qw1af8wJrA8+bkh25xXU3Fd53bPzuRQPadlaMJjPAWOsjWs91RVAcQwLXtLyScf5NcBAxdKO5lOXUlgfTHsRUv4smR+FcBCmkJWxnjltUWPl77B/znoaYj5h43DOCpkYVAqfbivj9fK2fnaY9VU1npkWpCl/qpS5edln2Wiw+WoNd4TvQFAl3uhum9hkRPnkJO17ju4i5+jGfDgFzx22hZbePq
 TbMbrkzL
 3948haH8BZjx8pJk2S19CJfaFdxFUVjVFNYOgQXCNmgIA2qm8EADGuggrV3rFpdwkaiMaW5RXBHtnxYu5ap42odGhNvLrrWYl8Nx4F4muZVfk1gpoPtPgA+uSL5BBBGyQ3ofH0sCeWfhLj9xpyCiMr3bCVCFyo/0PMUawxKSZhI456Fv2EXf0QQBOtZw1ADK3DmZP1qpToFCgfKSl3uLyuHAZUK3qgNdIqey9YFeWechFDJ6wla9dCkD+/9k1W/xWEIMdwJ32VBrCSTEAJi3hlUYpgEU8Zn7dIGNuHu5X2cWXFUdUOFc/52aaVd5cpC0jo9NtEuEJ0e5uuw3GvKGb1mUaN9gVzB2kSQyFwAZPWJneQ5tfqpjTmpL/9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/6/26 12:31 PM, Sergey Senozhatsky wrote:
> On (26/02/06 12:38), Sergey Senozhatsky wrote:
> [..]
>>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>>> index eff9e3061925..fa6a018b20a8 100644
>>>> --- a/mm/khugepaged.c
>>>> +++ b/mm/khugepaged.c
>>>> @@ -1894,6 +1894,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>>>>    		xas_set(&xas, index);
>>>>    		folio = xas_load(&xas);
>>>> +		if (try_to_freeze())
>>>> +			goto xa_unlocked;
>>>> +
>>>>    		VM_BUG_ON(index != xas.xa_index);
>>>>    		if (is_shmem) {
>>>>    			if (!folio) {
>>>
>>> Your analysis is reasonable. When the system is freezing, khugepaged is
>>> still trying to swap-in shmem to collapse, which prevents the system from
>>> entering suspend state. However, it’s not only shmem that will swap in,
>>> collapsing anonymous folios may also trigger swap-in operations.
>>
>> Right, I thought about it but wasn't sure.  Could the inner loop (e.g.
>> collapse_file() in this particular case) loop long enough to fail suspend
>> w/o ever giving the outer loop (khugepaged_do_scan()) a chance to freeze?

Yes, that’s possible. However, if we add a try_to_freeze() check in the 
inner loop, we need to consider various scenarios (such as anonymous 
folio swap-in and other potential cases?), which feels too hacky to me.

> For inner loops I wondered if cond_resched() could be an indicator of
> where try_to_freeze() should be placed.  Those cond_resched() calls
> are there for a reason, after all.   E.g. something like:
> 
> ---
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fa6a018b20a8..cee08466a069 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2431,6 +2431,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>   		unsigned long hstart, hend;
>   
>   		cond_resched();
> +		if (try_to_freeze())
> +			break;
> +
>   		if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
>   			progress++;
>   			break;
> @@ -2453,6 +2456,9 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, enum scan_result
>   			bool mmap_locked = true;
>   
>   			cond_resched();
> +			if (try_to_freeze())
> +				goto breakouterloop;
> +
>   			if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>   				goto breakouterloop;

This looks better than the previous version. Let’s also wait to see if 
others have any better suggestions.

