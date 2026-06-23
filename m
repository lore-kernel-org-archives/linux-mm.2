Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F09ECDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE966B008A; Tue, 23 Jun 2026 07:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AFF76B008C; Tue, 23 Jun 2026 07:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ED556B0092; Tue, 23 Jun 2026 07:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F146E6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:03:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B742165AF6
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:03:00 +0000 (UTC)
X-FDA: 84910890120.14.00243FF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id B3FDAA0011
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:02:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dlyVYc7G;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782212578;
	b=BJ8DPPPNTrA1sn1KxHbWRwIrz69oUeau1rA/KIxFrnozGRTMBs7iZ+awALjn/1bT7gsolK
	Qcy5UuSQvyAktyi212lDEpaVkl4uU09J3sofuZ5ctB1hZkznnxy252pp/E/WvZ7/m3e8ks
	3u2E+/MRWQog3agO16Ih8mRd04QFV1A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782212578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d/ElG25trDLXT4uWjPEZOjtfFQm7and7DsyLONax6iQ=;
	b=S8I+9o94qC0BgC9t8a1a/UES+beSZaP2H/E2qceKBsF9VwFJ4YzofZoMO4KRKuGbKsUROB
	qE0kvUBsMOMlnMFs1NHElY2jeHMs+Yhwx04fLjDsOrwwK5BsD4FYp2WRkfCvll/47t+Idh
	TjIOuQEmIEHQAqrLgyvahDE8CD8Y9Ak=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dlyVYc7G;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 54CFE1A25;
	Tue, 23 Jun 2026 04:02:53 -0700 (PDT)
Received: from [10.164.148.38] (unknown [10.164.148.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7A95C3F632;
	Tue, 23 Jun 2026 04:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782212577; bh=gGjnqReNbED3UDwNUKA/bNOxEnxJjqfSBvAvUFwdl1g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dlyVYc7GDR+VoWyQTKZhpk7itUHypD9D3TGNIaLEKmykY+7rMKI7tS9NhvJwa6h4i
	 lmUmPU0COJwk3mx6g597g0JvK1FqqwexCOoPMz6Ourm837ktIHoFYuLjwm7ZQDMnpY
	 wp6wHbkIWdtdKMWIYFqaPo5LsngC8VmPqfcq94s0=
Message-ID: <6847a972-65d9-47ff-b971-c79544d53957@arm.com>
Date: Tue, 23 Jun 2026 16:32:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 11/12] mm/mprotect: drop 'sub' from
 page_anon_exclusive_sub_batch
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
 <20260526063635.61721-12-dev.jain@arm.com>
 <bce8698c-ae4d-4e87-ab6b-5f4059617a69@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <bce8698c-ae4d-4e87-ab6b-5f4059617a69@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: h8c4dp48fhpta8tjntxoc33n6e7j5j1b
X-Rspamd-Queue-Id: B3FDAA0011
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782212578-540836
X-HE-Meta: U2FsdGVkX1+wF6Y2yNPLfFMLtbUQj44rBrbqZ/Ti1EJIlzn7IRa45LPkabxQd3q4zmQnOk9KsMjHmvHwiJ7+0QfdBhLh3DyAQZ1j15x+50cL4tncbB8vJCLuQ8M9l2VL0h62Kmlwya0gjHPcvxEIT0k7BfcENc7wGfPzwnh1R6kHFb0sEEAbixryP7eeJAB35pJ7ijcvT9zlO8/eUJZDmEP+HPGK39DE6RTiDKmRtArLDC40nhfVL7+O9BP0lbCl1Bp0LHvU66M5WwjL05Kcgt5Lk463/miCyPhdL+5jYw1U5ouHzNWGgNbD+yEyuHR6eJyYKAJgAjoHugHPNKlQO1dmBk21ucuBLIJNiIsmfsd/587FDJog8iSMxrhfTdAxKI/YogYdsPA8Cl30Z39udSyKRSAyDYAEqbeZvKgQPEryVdPHU93jlUKP5sv/BLyC2YoFz1OzMR+yHjWL05MKq1QKIRs4wY/RxAAXboLp3hE3RIgMEzSVQBesJyl9SOFmaZZdHrOgHGKqXpIuOIkIKeGg5+CvKYlWScQSyTojABCSrvqT4wck1pDRQmyHTJuWfyyojRAStYuVExeX8ux6ZE9Hw3xGoziECOg/QJ5hmLrGHRXxx2kIgcTwKIqYddjanAyeNkiw7H5TWa4jhCXkDm4kSCNvRHae24lawuXF6wDpMiwIe4fi2abdCyRNTmtY4JY+psXSnMeFbR7IMBSbtOIUYztPGw+kk0tO9SkbNLqkgVqPM5JC5tYsWlgAgJXJqPhRsXfzB3ivXV5mA59TacV5V8/wR88dK/oF/zu23L2GGoXOJRepsSuDRAm3NoqcLeVLGuNHLDzQ+FOg28QChjPv+gsDgj5ryKaS3H8GNmbmluXKP/cq3AS6fow/RwUSpPS5o886fszeI7AaRMpZ7rcCQS/LFEVj/hTQiAslVw17x15I9RwGHvnic679TQkMEJ/p2kQ/hIeXWHb2Hqb
 coPzY7ft
 pW8DdGBXDuqGKfAtdP2X53BX3paJI6Y0MEQIJ9tJ294gfyuHqz/l52+DSq3ypKIWsRYAE1DMSUhWKrn3r/t3XrhZ/SRVxuf2Xi552zExZaMZdsPqNkAV6fOsxoEGxWk6F7vsXLglZtBZNIJUNvl5Sn/ZdUpebP0a/zE/3COthgK32hGDL1thtbmRc0tNwB08v7h2Np0YMPLeJHUUS88nS8bOiDXNAE6ii/CRh/FW0eyckp2/zk/gc2JRAo6eiAtn5L2FtDbvnOWZDqaIhhjFPpKtpTlyEVDTJNFdLwwLzCYZQBUlq9rqUtBJxvFOXp0WwQ3Rkl310fGNTj1rXhoVfOw5H2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/06/26 7:42 pm, David Hildenbrand (Arm) wrote:
> On 5/26/26 08:36, Dev Jain wrote:
>> Shorten the function name by dropping the "sub-batch" context - the
>> function itself doesn't need this context.
> 
> What about "sub_batch_idx" ?

I'll change that.

> 
> This function is rather independent of the rest, so best to send that as a
> cleanup separately.

Okay.

> 
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
>>  mm/mprotect.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 9cbf932b028cf..3357058672016 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -143,7 +143,7 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
>>   * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
>>   * that the ptes point to consecutive pages of the same anon large folio.
>>   */
>> -static __always_inline int page_anon_exclusive_sub_batch(int start_idx, int max_len,
>> +static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
>>  		struct page *first_page, bool expected_anon_exclusive)
>>  {
>>  	int idx;
>> @@ -179,7 +179,7 @@ static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>>  
>>  	while (nr_ptes) {
>>  		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
>> -		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
>> +		len = page_anon_exclusive_batch(sub_batch_idx, nr_ptes,
>>  					first_page, expected_anon_exclusive);
>>  		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, len,
>>  				       sub_batch_idx, expected_anon_exclusive, tlb);
> 
> 


