Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9862D74965
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DAFF6B0088; Fri, 19 Dec 2025 03:56:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B22D6B0089; Fri, 19 Dec 2025 03:56:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8F36B008A; Fri, 19 Dec 2025 03:56:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F35A36B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:56:04 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5F36600D6
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:56:04 +0000 (UTC)
X-FDA: 84235613448.12.8E94753
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0CEFFC0004
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:56:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=riRT1xQP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766134563; a=rsa-sha256;
	cv=none;
	b=QNcacxU0WeLcaOxLXrJfYDVyRGXzqIk8lwyWCPo3rkefRQqWfkOQ3SOKj5iX2LWXZZ2JMz
	WvisZS1xd7v5lpqscc+ETu9kxOWRTAVCrmr2OQQvdRMn/4p1E5CftOG3JImAu1zmM0wtvR
	ndQzoL/fXgTKBIGBNP+TMDYr+YOVFWY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=riRT1xQP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766134563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4a7L3FSTZVaSCzuECgE9d16CQIb9zGAU66cxFRoZyJ4=;
	b=mgpV+NMMUl+2LVgV4u9XCXn5RvxAyGyHCmNeL2CXBdD7vIQV/I6Jov+7sfbhlpCHIsSAwM
	M+6+u6FtVVh5dMPZ06ScgRWvV6CBNIatPl7C89Z05tUQhh8YpP4fSBAXkZrlkxszXpIljB
	RjpuTWUKhovbUWMCDbQT9GKDNcy/91k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D0B760018;
	Fri, 19 Dec 2025 08:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA41C4CEF1;
	Fri, 19 Dec 2025 08:55:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766134562;
	bh=TPE5OS05vI0tJdNvhgg9vrKHc5kLwjyEu0iLvyC1V7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=riRT1xQPLrYDVyFN4+gJRO8GnwpqwsepD4GrOnhnTkDfu2yo7Tru/Eqy6S3c8pqhg
	 Yb8uitMooT2OwotTnY+5Nwv+I6KWlomj9jHp8ZQiKhyXf3s2X4st9s9Wc4TslGKaaU
	 M4++FD6dcfRUS247JlqI/qmp+GAvHvpED/763jsvFmuwIdAiIRofnxed8crhEoWNf9
	 aaGDUQolapPeS9inoOSerbZ7fG0jO+lF3uTeMJMJ9CO7+pl2LHpTcIEz3r0cGruklE
	 3Cm6gKnD3FZLt5S/lvlREwCkmPmtEM6qwb8EtW7cOembXQDczDdGnTim5plb+S+ml/
	 yA7pVwnJ7VShQ==
Message-ID: <adaffa11-c0a8-484e-9de3-e15eeddcf922@kernel.org>
Date: Fri, 19 Dec 2025 09:55:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
To: Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
 <djh6xaia56grmgxdok23kp6ly3oe3ugsinxdp6jie3k2tzwaml@57gbrcr75jng>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <djh6xaia56grmgxdok23kp6ly3oe3ugsinxdp6jie3k2tzwaml@57gbrcr75jng>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0CEFFC0004
X-Stat-Signature: x545ko4g59ha7szxu471p1szoyjgtprd
X-Rspam-User: 
X-HE-Tag: 1766134562-875633
X-HE-Meta: U2FsdGVkX18UNj41VX0wxOPf43yD2QY1pUqzsICayNtTPcyzr64/+clOea6BwcJqP1CRPz/EjvscFO62mQDe8oADCSeXeu1CvSPuPERM9Zgb+om8HrwVa4MJym65ktvEZVOzZMCdzueU+kpVqhOgkRfNEwKSTC3JZ7ekUWXQPXt+hJxEdXI+1LutHZXsGb7kNgP1Zzud+6nKFMh3ldSSZSmSIU8+xRV/m9pPZj0FsZ4/XgpUd4YOgLh9+1JFVt3LnxoZBvxGLgdWTSIafslzq7iU7slh/iLTE1YNi8GkRmKZORPdGJEyWglvMc7971SSSdLh6zcFyMyQUkAsii0bdYA3LmzcItnOXmRfoAeB8llAftUmKucP8FIXuHf872WlKxxek/vfVfOAefWQqsaWjL65cn3uWGszB40srMwxap0E4mwZOGJRmqwO3vgrXApQEwgB/Q23kNpRlU7acImuvz6hXHtH6/mBAOJF7fLeMEAZ/ybTF9XY24kXcthPfdFb0NwP+f1v2BEv2AMa8YpuDdkW49VWxVLxZIznYs3V1nUipaAyFEy6DuhsBTLxHIn/i7YEZUmF8p3ZMJNPwjPEuk9K3xjYQ9pMTNyZpyGbGstkn41fc8NnLjVjahzmd+h9hQETwaSVlUV95ZwAnJ3GcaswumwqImgtFZJ/3FypTNDvr69omGZKYwRWgcwg3csalVTVwGrWKBbuNytUzJ+0/QW/+zS2AMCynpr1ArS3B/Wy9q6uOEVkKuIH3hQGJKOByo8jz7pW6jvqX2bPyM1Rp3PB2oqMGLEYq0XJJmIF1lXyq2vuNOWOaEIZPtEnDGjWX4K4RmLXtPK18th5bPePdt2oU63vzCcQn5kzoOEN08CcU9z3gephfV2ind3W7I/7Iklazmt9jS22H6FoINEpTwwbpJrFeQO5TRMDE0L3wDT7A6XGt82VNzZg42D9eMThJcBEWmFhxHtFtCXbUNn
 Pk3VPpFN
 AF8YvPg0adrbZjoAK6wXajefFVR0zDcxndlclqxYJD7Vb5mG+hUHeN+f7An7yI27po5utwewii49F6Eu78fqxjnXYS7zUooBNon2WmgwliWQCHl5oWmcsS3HJVlDTiAB/e4FVTEeI2nW3jPWkIJ2yseeSmK7uah4qx3CI2YElOjM5Ovklv38tTdKGdC5OWymvgqwfj3HJ9m7bv5LW7ERGqYRM0ypQ+iFSBAUP46Z4id1/bbm0crM9f74lDGs2VFHYnlXw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/25 09:35, Vernon Yang wrote:
> On Thu, Dec 18, 2025 at 10:29:18AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/15/25 10:04, Vernon Yang wrote:
>>> The following data is traced by bpftrace on a desktop system. After
>>> the system has been left idle for 10 minutes upon booting, a lot of
>>> SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
>>> khugepaged.
>>>
>>> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
>>> @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
>>> @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
>>> total progress size: 701 MB
>>> Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
>>>
>>> The khugepaged_scan list save all task that support collapse into hugepage,
>>> as long as the take is not destroyed, khugepaged will not remove it from
>>> the khugepaged_scan list. This exist a phenomenon where task has already
>>> collapsed all memory regions into hugepage, but khugepaged continues to
>>> scan it, which wastes CPU time and invalid, and due to
>>> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>>> scanning a large number of invalid task, so scanning really valid task
>>> is later.
>>>
>>> After applying this patch, when all memory is either SCAN_PMD_MAPPED or
>>> SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
>>> list. If the page fault or MADV_HUGEPAGE again, it is added back to
>>> khugepaged.
>>
>> I don't like that, as it assumes that memory within such a process would be
>> rather static, which is easily not the case (e.g., allocators just doing
>> MADV_DONTNEED to free memory).
>>
>> If most stuff is collapsed to PMDs already, can't we just skip over these
>> regions a bit faster?
> 
> I have a flash of inspiration and came up with a good idea.
> 
> If these regions have already been collapsed into hugepage, rechecking
> them would be very fast. Due to the khugepaged_pages_to_scan can also
> represent the number of VMAs to skip, we can extend its semantics as
> follows:
> 
> 	/*
> 	 * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> 	 * every 10 second.
> 	 */
> 	static unsigned int khugepaged_pages_to_scan __read_mostly;
> 
> 	switch (*result) {
> 	case SCAN_NO_PTE_TABLE:
> 	case SCAN_PMD_MAPPED:
> 	case SCAN_PTE_MAPPED_HUGEPAGE:
> 		progress++; // here
> 		break;
> 	case SCAN_SUCCEED:
> 		++khugepaged_pages_collapsed;
> 		fallthrough;
> 	default:
> 		progress += HPAGE_PMD_NR;
> 	}
> 
> This way can achieve our goal. David, do you like it?

I'd have to see the full patch, but IMHO we should rather focus on on 
"how many pte/pmd entries did we check" and not "how many PMD areas did 
we check".

Maybe there is a history to this, but conceptually I think we wanted to 
limit the work we do in one operation to something reasonable. Reading a 
single PMD is obviously faster than 512 PTEs.

-- 
Cheers

David

