Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67133CDB47C
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2B356B0092; Tue, 23 Jun 2026 04:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8E6E6B0093; Tue, 23 Jun 2026 04:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A44116B0095; Tue, 23 Jun 2026 04:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 76DA06B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:43:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EA803C1DDD
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:42:59 +0000 (UTC)
X-FDA: 84910537278.21.588813E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0152D180009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:42:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G549Fzeu;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782204178;
	b=BImGv8blHnv/gH0612Am0JX3X1iBf2kkqneMpUJiaONB9CGArbni1ur6Rs32GESGN94fsW
	gsIrt0JMxEVDi7cvsSL2bSbTaE0UeT2nwXTHQ8rlrYpAfcjEIF44ENnVGGhCwf0EZ6JK+T
	DqjomZp4EgsHtIKILYZCOJuNDHELARc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782204178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UiErUWPgXUYEKMOiubM0+y4JVVhXhHFXLKptNThNeiw=;
	b=h3v/aLaqQKKOOK5+LffpkCxsf5h06phOw/xGAhDdk1xE6cANAkiCrdkfjciO6OE+ivxuVE
	Wx9fOOnrqrkdPROlIcDfpsWOVxLj/uMoEIZk68QZwN9xaZJ9tkzXN5Umcgv539w31zQg4U
	jV6E6CEyodicJQyXAiz6/9lsenhB3j4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G549Fzeu;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44EDC1A25;
	Tue, 23 Jun 2026 01:42:52 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28FF13F632;
	Tue, 23 Jun 2026 01:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782204176; bh=apcyADjqiE8fk9NSJLQOIEwwZsOqAW2rHJXWbblmtUc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G549Fzeu52BzvudWHBhxRkDR214H/0uxNE6OXRIold2m/bYzwYxocXNWqAmUZHy02
	 wUw7nMEDNKVsvbszcz5sHDzBdd2TbjBRLM41Ttcvs+b45MgNRNZBOBFwkCqqgjWbQT
	 B4Y3hrKfaBbwh2AUXi86Wyky/2mAhQ6pJ0bHOlZ8=
Message-ID: <dbe63454-6ee8-49f9-b956-f5a211785aec@arm.com>
Date: Tue, 23 Jun 2026 14:12:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/12] mm/rmap: refactor some code around lazyfree
 folio unmapping
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, chrisl@kernel.org, kasong@tencent.com, hughd@google.com,
 liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-4-dev.jain@arm.com>
 <dcfcc52e-7e1c-4940-944a-faf0c02672e0@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <dcfcc52e-7e1c-4940-944a-faf0c02672e0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0152D180009
X-Rspam-User: 
X-Stat-Signature: 95mgecunh975yo4sn6etupx8pzq5izy5
X-HE-Tag: 1782204177-27455
X-HE-Meta: U2FsdGVkX1856jhb+2gcDWgtxXtXO7PblIwvugHAWJGWhpzMDgJBPZAIAPUAzAS5CryAFbi8K3yykxPbCQkw7lQii+yBkt5uCS+XqOmyBnmWLeQUnqjCNqRVIu4jgmZUXXJ84wYs+w9WWEH7W/s6J2mIdSvvVgj6NLtCr01t8/0PQrYiaLOxeoegeC1jqMnToSy5rG+JfXZK6sEYlhQkFGsskPU/1val9oLcUMKD02am4IYClaCZ1o65U/QoqWO6lUxS76/tARo1kayb4zuzDJAJiChSqTIUrXx4mOuxv4tuNXRGkPvxYSX8aENqyKmFXL4zix5EIrFINVs0U2jICUSX41Gn14+zJyCN2vqaBdoXaNCT3k/IlJcqHhiapgtJXYWCWvdtiF/LOUNrMeQKOW/iV5OdZxtGpKIbo+diPriqRXo/jUeJHadB7x6o3tQpVmhoGnRRyHYTIoHFsMmK0rbyJWkiEaLF5TLeCv20hfMbRwy8b+/VKhQ5mmB2Q/+EpySwXCIbNgrc7690sK+K8w7mcO0RmF0zXA3tcCgWakuJ22U8b8V8nmIQtGVcaTID0ELM+qeGRJ37kHA5OUbG7NIvbAGmAZlXolzQWJKOTiq120fz1/buBjoyxPGPqxcURy9ayCq7Z9JKIENX/9jYsrXcXt6FD+5oqcNriX3SnaQYjEW0Fhq3vDEOXltUyynyy4xBuF906H2/4LJ63AdIQtTsbDGgsdTpt7xpyKwbJ4MjkH0ammtpvHldqOmT9yrThhrC+d3wlC+sGuQxLRc1tnSI3prJeRvHwYIZ97pFx8TH3f7kBSB2cKKKfadXrbVXwZDZEw+san85OS3mLsehg480DKRUjq3gszO4JPszP789NGJ1NCr3jPg85QmqGeC/Ii0Xxk56VFlkuq/2V3jV9/O0ar6D4Fbj+3ANFETpOEjMwf88nPzgmrxM8sbSSZKM724oGLucvEMX/5Xc/xo
 e2H7n5tz
 95bpx5aHRoOLrgotjemIJYFuZyTRYs0u+9HUW6PTP3BYfbt2fBsS7a1hTry0hRy1invK5pMdHCcDd+wvHt4qpZ9AX+/pLqdUs3qIUg8MsbrSdLyiKx6Et6AXfW2ASAVYVasrt5owO2ZnduiFnFmg0PigY6CDXiaLACANHsGwbfJS/wjdF3FDQP6Vg6lfbcptIANCpCUM0Tncz/zkIK3T17shP5A+fjgGbdn+y3aBUPRnlNkSb0KBasCjzYp21cS6Kbmog/e9fOCcBrsz+0DY3bF60gDzEEOdHSONXrG8S+nEnTLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 09/06/26 7:50 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> For lazyfree folio unmapping, after clearing the ptes we must abort the
>> operation if the folio got dirtied or it has unexpected references.
>>
>> Refactor this logic into a function which will return whether we need
>> to abort or not.
>>
>> If we abort, we restore the ptes and bail out of try_to_unmap_one.
>> Otherwise adjust the rss stats of the mm and jump to a label.
>>
>> Also rename that label from "discard" to "finish_unmap"; the former
>> is appropriate in the lazyfree context, but the code following the label
>> is executed for other successful unmap code paths too, so 'discard' does
>> not sound correct for them.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/rmap.c | 88 +++++++++++++++++++++++++++++++------------------------
>>  1 file changed, 50 insertions(+), 38 deletions(-)
>>
>> diff --git a/mm/rmap.c b/mm/rmap.c
>> index 06ab1158d4cd1..12bbee57f20da 100644
>> --- a/mm/rmap.c
>> +++ b/mm/rmap.c
>> @@ -2093,6 +2093,52 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
>>  	return ret;
>>  }
>>  
>> +static inline bool ttu_lazyfree_folio(struct vm_area_struct *vma,
>> +		struct folio *folio)
> 
> Nitty, but I wonder whether we want to return an int with 0 vs. -EBUSY instead.
> 
> Reading "!ttu_lazyfree_folio" naturally makes me assume that this would be a
> success path (which it is not).

You have a point but if you don't have a strong opinion I'll prefer to keep as is.
-EBUSY won't be consumed by the callers anyways : )
> 
> 
> Apart from that LGTM.
> 


