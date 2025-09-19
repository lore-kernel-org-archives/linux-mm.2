Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF76CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 04:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5BC68E00C3; Fri, 19 Sep 2025 00:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33E18E0008; Fri, 19 Sep 2025 00:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949638E00C3; Fri, 19 Sep 2025 00:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 833C58E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 00:21:15 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2AE29160427
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:21:15 +0000 (UTC)
X-FDA: 83904700110.17.F8301B6
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id DC3F01C0006
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:21:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YWJX1e45
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758255673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FB08AkPogpZ1CN2MlqSj5xJDBZIBAXihl92UEHxatuk=;
	b=Kx+HvB4zQrVvyk95SzEAoMezp/kQNlqha+hlt59oU212S03u6ZghpBGKKmu9WauoUw3dwt
	8AiUbMkURTVwX34m4gI6410wqvk292BxiBkl64l27BNyew6GI3kvxm5nZjOlg2lmF/U0HY
	ZoxsEDg+V/YrXQDcnVhKIJR4HnlNqTU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=YWJX1e45;
	spf=none (imf20.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758255673; a=rsa-sha256;
	cv=none;
	b=3KDWwjsJQMNUelqFUSGDe0u7AL3JaopyHJYWwvgD/SwfbxCQsibYNR/k3ReoOR2j8IzPed
	sfpqz+jW6SwRvsIP8tbdUwDGhCfwuQKLcY5hx69HDWCe4s8vLofqX2kX6Voum+ErCvfCqG
	86WytJRchCEDZqYTrl9+dfowYXqYJg4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=FB08AkPogpZ1CN2MlqSj5xJDBZIBAXihl92UEHxatuk=; b=YWJX1e45aZk9c0QoynCO28tYH5
	76Yz7I0s8OL3PfQN8LzEOWKTWI/PTt/zNzfzd2LNvXT7j815SVBCEsp/Tcf2a1K8Ymg6wECq/x+Cg
	Af7HcuRGfNw1V1RtM3JNfOglPDuadUxMCPr73NadCEnEhTYZ4oOmMXJ3yIk7FhOPqnoMEJ3RSuurC
	CiLnNN09YwN8jRoMeRtfupRw9DVzI2mWX15sP5x1WQWtHdPkXj38A+KNTxFly8tSq0ZoROBdMrrzT
	kLg/zDRcRKAomJlF7egMKhMILytUZ8dxI4UKj1wTeJSOWssa7MDNrm0daF3U3HS37wwCGlz8bRut3
	mUyZh/cA==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uzScK-00000001nWD-1vvj;
	Fri, 19 Sep 2025 04:21:04 +0000
Message-ID: <4e76b94d-9c32-4ec1-b2ec-fc989f1a23ad@infradead.org>
Date: Thu, 18 Sep 2025 21:20:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] fixup: alloc_tag: mark inaccurate allocation counters
 in /proc/allocinfo output
To: Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, kent.overstreet@linux.dev,
 vbabka@suse.cz, hannes@cmpxchg.org, rientjes@google.com,
 roman.gushchin@linux.dev, harry.yoo@oracle.com, shakeel.butt@linux.dev,
 00107082@163.com, pyyjason@gmail.com, pasha.tatashin@soleen.com,
 souravpanda@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250916160110.266190-1-surenb@google.com>
 <4c4e97c1-7f93-4c09-a235-ab169a998ef0@gmail.com>
 <20250916175639.2368772636d5e543faa5b13b@linux-foundation.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250916175639.2368772636d5e543faa5b13b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC3F01C0006
X-Stat-Signature: f3hm7xscqh3zpagkimkjaeoik6uqmchf
X-HE-Tag: 1758255671-365631
X-HE-Meta: U2FsdGVkX182sa0gZL5p29B41CQmWEwFVyXmbl3UF7PEcK9M5UAFBWsnofpL6T5tlhYDiCXMEAFUO4up2kgSpPI+GgWjgDDgmXV2VJq3qvu7+MfBkYjSWtyPSrbcE1OzJaXm/Xv12X2UvDl2dum5AZ7azvlXf3Uu7hWU/qnj8g6u311vRsotmRgozxwWioK5LtZ6+Pa6v6ecsJR2acjTIOdF1iu707FRwnJFa9vmC/eGMpwSwDW9z8RrYfE1AglWjWpIxrwuPR3S2TB5G/3v8N+r03OuFYjg1nx7J+DV3JlHcVb+x1gMF0y3BBvKeV/8id/0ah7e9C2QJlqg3hfayHTOe3ZrNNLVTSJRiG/lco7eE3teTHFJ83yHYf8BmxmwvNNQyJgsZSxTYL+DDbmWNd9LX7hrn+SRa1PekTUrwNvyGO/QjC8fT/QpDH6wsRTXFzCAyLlKbb7x2wmiP0czdRi/uBLC92VUNz0K2MrWR20m0A1wfuAWUk2YEqry5Xvfo7KLmOkM62sh16SR8KDTTtduQWL9z5T/jtQnueGN3xsIdlXnpq8P6pD1FjKwCmXypO8nJomcwgydI1vZc5AimfN4pse9ATIbLAP+UMyUpksfrpRCrnRxInu6XEVym4RJ9e6TvGFk0JaoLHWUjicmOgoozB4hJPXNVBWBMWVDzq6txztYfqMXrxIHht4hl3kh+95iKtpoz2MNXss32CDKy/bXg7+ivr4PyWVch5KkbCGGNtHbq+2Yshy3qqVJ62bKnhiHZ5n9JcdVsdi6flCiUyyV9p6cKFycWgdkIH0uQxxG8GHn2LuPzp6Op+c3BqPJHpqteMRh7pjgRvS2Fn+Hx8LffVkSMDFqh8U9XmS492xyEKsO+tWWGKG8uTvANkeatotS/tHCvdSNHEYEGvsu95MtBp7yu6pLnRApiclAevHqYDbNJY2cUclcAZDGKvncMFsULbuRkA94hGm89U+
 +YiRdY4K
 tWQHnGRR9asHQvFZQdCdAXBhJL6EJUiCmYEwq+wpEAh+MT3ByA4k/jFLwb7S2FHbPhyuB3g70S8j/Wny1ag9ZQHOhIfXVklej1O6BLhXxy1xwkFuESf+8WlOoAe3/KfWalEeEkKusIu+q3anuJdLU7yNqZ9YrJMT1a52jhxxWOrerUsLIuSvOW5rHrNLeY/QHqGJzxECX+R2X0d3aqYyBHJpZ9nacVm02dIp9dTgYzcshnsGkXEQVcpOVkDd0hGsBMYazf2RIp5cuGhbC9L+ACRE9keEnMKLEUrS+H3TBugRQM9kmmyRUBp9EW3/nljtFq5IGZRgeUve56/3SL+5QVj91p/JEU2FvEUiYwRwFwt3G4XNtQ0sqAylkrTuMHt3EBt7Ym1cUL6xdA+BXKq4PPhY/GCJWFev96Ifvmkr0aLjQyA9lkCiJ/e/w9Ad8oc5yq5j2isxmhpkmwAvY1fsVUTmdnUKpD0QoXtzWVBpKJf1IL1gUBuhP3MxJ9dYhSNK9naLfRA1sxpmI3Jk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew,

On 9/16/25 5:56 PM, Andrew Morton wrote:
> On Tue, 16 Sep 2025 21:50:51 +0100 Usama Arif <usamaarif642@gmail.com> wrote:
> 
>>
>>
>> On 16/09/2025 17:01, Suren Baghdasaryan wrote:
>>> Document new "accurate:no" marker.
>>>
>>> Fixes: 39d117e04d15 ("alloc_tag: mark inaccurate allocation counters in /proc/allocinfo output")
>>> Suggested-by: Andrew Morton <akpm@linux-foundation.org>
>>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>>> ---
>>> Based on mm-new
>>>
>>>  Documentation/filesystems/proc.rst | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>>> index 1776a06571c2..17668f82ff1c 100644
>>> --- a/Documentation/filesystems/proc.rst
>>> +++ b/Documentation/filesystems/proc.rst
>>> @@ -1014,6 +1014,14 @@ If file version is 2.0 or higher then each line may contain additional
>>>  For example if the counters are not accurate, the line will be appended with
>>>  "accurate:no" pair.
>>>  
>>> +Supported markers in v2:
>>> +accurate:no
>>> +              Absolute values of the counters in this line are not
>>
>> s/values/value/ maybe? :)
> 
> That's OK as-is.
> 
>> +              accurate because of the failure to allocate storage required
>>
>> s/storage required/memory/
> 
> Sure.
> 
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix
> Date: Tue Sep 16 05:53:33 PM PDT 2025
> 
> simplification per Usama, reflow text
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: David Wang <00107082@163.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Kent Overstreet <kent.overstreet@linux.dev>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Sourav Panda <souravpanda@google.com>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  Documentation/filesystems/proc.rst |   10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> --- a/Documentation/filesystems/proc.rst~alloc_tag-mark-inaccurate-allocation-counters-in-proc-allocinfo-output-fix-fix
> +++ a/Documentation/filesystems/proc.rst
> @@ -1016,11 +1016,11 @@ For example if the counters are not accu
>  
>  Supported markers in v2:
>  accurate:no

Please insert a blank line here to prevent a docs warning:

linux-next-20250918/Documentation/filesystems/proc.rst:998: ERROR: Unexpected indentation. [docutils]

Thanks.

> -              Absolute values of the counters in this line are not
> -              accurate because of the failure to allocate storage required
> -              to track some of the allocations made at this location.
> -              Deltas in these counters are accurate, therefore counters
> -              can be used to track allocation size and count changes.
> +              Absolute values of the counters in this line are not accurate
> +              because of the failure to allocate memory to track some of the
> +              allocations made at this location.  Deltas in these counters are
> +              accurate, therefore counters can be used to track allocation size
> +              and count changes.
>  
>  Example output.
>  
> _

-- 
~Randy


