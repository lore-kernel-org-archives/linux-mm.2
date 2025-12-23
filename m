Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8827E6F079
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 11:19:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471F16B0005; Tue, 23 Dec 2025 06:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4200F6B0089; Tue, 23 Dec 2025 06:19:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32B546B008A; Tue, 23 Dec 2025 06:19:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 202E36B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:19:07 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CAEA6B696C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:19:06 +0000 (UTC)
X-FDA: 84250489092.01.17EA850
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id A040A1A000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:19:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766488745; a=rsa-sha256;
	cv=none;
	b=m12fCrE+N3Bp3TCI3GjBcYsHPVdq5Mo3bzewn9LYUnKUvMtpYTKB7aZ/wrWPR87BZ3oSMt
	gt340Q3fARcQ09/qCmZzOKlwDp/Ud8a8+UrxdppmEgqDM1OhPIKWxJDPnRcpL5b0dlx1Oh
	LYVysOnEWGdRZtmv+1x30pSYZ/R2IB0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766488745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bKcuo2GcTp7LREkDHUsW33FuykSOoX2zBgKzmmcaLZU=;
	b=1XzmwrwOxKq03ygkeVsB6kAZCZFwFljILqpaXPcNAp3lcuVo4gwbm5ws8JHLb5GrIT+Ynj
	Ah/t11p3Yg755HN4Jv4xdvoeT8VI+5rTFrAX0dgQI0nR+4p2JP0alWlVkGIvUaAIxGkteQ
	OHV1cyLp0faLDJIpH2B6eyyMFxccCrU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AA305339;
	Tue, 23 Dec 2025 03:18:56 -0800 (PST)
Received: from [10.164.18.59] (MacBook-Pro.blr.arm.com [10.164.18.59])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DCA03F694;
	Tue, 23 Dec 2025 03:19:00 -0800 (PST)
Message-ID: <52174c05-e9ed-4049-ac05-d0d0b3228f2a@arm.com>
Date: Tue, 23 Dec 2025 16:48:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
To: Vernon Yang <vernon2gm@gmail.com>,
 "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
 <djh6xaia56grmgxdok23kp6ly3oe3ugsinxdp6jie3k2tzwaml@57gbrcr75jng>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <djh6xaia56grmgxdok23kp6ly3oe3ugsinxdp6jie3k2tzwaml@57gbrcr75jng>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A040A1A000C
X-Stat-Signature: jgp4roio869phsz5nhm81gt8optbeecd
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766488744-889365
X-HE-Meta: U2FsdGVkX18VtiL/lkIujeLWJcC15nhTGl5Uy+0toHb3wRADYyPLd3CJkO0Wd3v1ZO5CQ5yWhIQ/QUuEwQQkIGWtxiVCJAVnAFH8jcBLpmAw2wbdaiqpyXAlH6SYxpQGJ3L9FHkSuQrDetywsFzRL3iFFVWhksZWSF1+xVq5s9agqqJfWt6+gc+Nazzd+iJw0bOfcaCGvsQUsHmL9o6RI8je1chSRFq2oKKGR+PzcRofSa5kKV6mFSoQL/DYhkRBl8RTOT2bnGqe4MYnkWXdCjcvv4yVYp0f5GpI0MqZC65ZM7Vz86mSIecWDEgT/njyVwoqz5NIl3kmKkxD8Eqg64VuFFISLgX4DrbeOmIPlqgfeQ93SslFSGPkbiNxHQThlF53ARVMvca0oDf91cMEUBOhpngRQp3Bt+CLrOfqNfrKOkp3kCgTVoU3b5ywpcySspINb1J7sJmnfgbncWqSooiDOhmPBnNiQ1Gz9pZRXQpBWGjijzW3xI509vc04N5D3qYzIw3beO0R/FAVtzPuLtDNushH0PzhoZNvMYRfhRvYPptAzpJYqWDRTozllnCeuFT/j2X4OdfLBu/dj49wTcRvKi6XjY7ZJb+iRPmo+YI5o6D7Kj2WX/D50s7k7HinILbXX1Qo4iF1dL4f73JdbKwyDGhdJ3CUG/pFINvvAsXt6ZjT7FUaWFM7SJWIq4Abu6oYISVBZLBrIO1SBjc81MLsafVMOvTVvpLn6sg6WFk0H/XhCRHifQK6Jj9Q3Dxi3ARB5NoTyVeyDY4QHp3+jQlLYUuJSu99dLQB1cpMf9f5xCp4aCm9uI7jfBtmC3vArLpqZHsLH25cD6eIKKcX7kRU+lZaq2qu/IqOGz80c747nYd0xmmFRyHdJzlhSy1QxxZyVE6iCHENgomORvyeyiyaWt9ekOtM4nNKOj9tv6BSV1axdCyzvKxKkbbPOt9PGZkNetVM/vdaKBYVe58
 t3nIPVdg
 DpZRBSIK3j7iCn40U0tt936NnH+2X3siNqyO0ASiH8uWRdRLtxkjCuHjbtpnXIQob4b7HFTMkkOoRxGlVIud4zR0UliW7qCnGesmyOIW+o67wybWSVXerecZTFha6BbtiqDnyirQ8dN8/ASQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/12/25 2:05 pm, Vernon Yang wrote:
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
>> I don't like that, as it assumes that memory within such a process would be
>> rather static, which is easily not the case (e.g., allocators just doing
>> MADV_DONTNEED to free memory).
>>
>> If most stuff is collapsed to PMDs already, can't we just skip over these
>> regions a bit faster?
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

This looks good, can you formally test this and see if it comes close to the optimizations
yielded by the current version of the patchset?

>
>> --
>> Cheers
>>
>> David
> --
> Thanks,
> Vernon
>

