Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAABDCEACCC
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 21:41:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291CD8E001A; Fri, 14 Nov 2025 16:41:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 269898E0005; Fri, 14 Nov 2025 16:41:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6A98E001A; Fri, 14 Nov 2025 16:41:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 043908E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:41:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B263140566
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:41:22 +0000 (UTC)
X-FDA: 84110534004.07.DEBE5E6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E1D1C2000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 21:41:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QdXrkXUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763156480; a=rsa-sha256;
	cv=none;
	b=QcQWnP4NzLxJm4Onh7VzZ+g+xceeYkJak+c81ZC1xVjl4Uyoig6s/0ciiATbrmBXyMJ8on
	ehhkIm8LMAKuMChAypEBQWXwVLzNhzr/CRLMvg++e1pYoAgXTD6bGWI3qBa8iqy4fGtbEL
	UDqmNQstRfszt6IUqponGU0h18DU6V8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QdXrkXUT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763156480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uPYJ8qsEtJVDpsjr/O63qAYlg/B8kiHxfFFA36wGMTA=;
	b=jpm+RUp3xcsvzD6JxKODgUbe3B80Kho2kA3119GHciJlzMwpl3Cmodfnr//Jp3TZ7GTYp8
	yB+9g9zYaZvcFqNGIl8MO0hKypE4kWWF/Xudja6dVyc7f6KFsKR9fqypNITSEWjdSCNM8g
	RbE9dfGCsz71bDBZXV+MvvGM+p1h1Gk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45ABA60192;
	Fri, 14 Nov 2025 21:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D5C6C4CEF8;
	Fri, 14 Nov 2025 21:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763156480;
	bh=r/3bQC+Fa/Fl2KnhgQsGNYnj9x+ETYs0SgCfPzMeYmE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=QdXrkXUTFiJSyLN4SHcg0P/gy8sF6UNTHdASril5X6uMgNJyr6adWwNUgis72mojo
	 Cp9Un/q/K/PAMM30CS4hdqKAYz/ZhetnWR6AiDiE88X0IWP+3wnKIUlAGUvtRXZj7b
	 0vFJysyhKzkn4kty44Sw1yxFoSDJ1IZ8tCrlHl0swyYBrWnINxNVsjviuDT4AGaQ6E
	 olg4nGOzna/Ie8r8BCXQDpFWbgZ2wy4I/7nRYUVKfvtMnvdajZKe1sSB/aAb7gKn4d
	 WennIqwg3ZfIMKy93u6ydUPTRPn96cNKzUsvmQr2yJNM0gTTlzAL/Gps5g8e6Yq6JB
	 i9sanebc/LKug==
Message-ID: <8fd2def3-addd-4abb-976a-857611871d1d@kernel.org>
Date: Fri, 14 Nov 2025 22:41:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] Fix the source file annotation information for the
 "FOLL_WRITE" macro copied.
To: John Hubbard <jhubbard@nvidia.com>, peng8420.li@gmail.com,
 linux-mm@kvack.org, akpm@linux-foundation.org
Cc: osalvador@suse.de, jgg@ziepe.ca, peterx@redhat.com,
 linux-kernel@vger.kernel.org, dan.j.williams@intel.com
References: <20251114161127.193707-1-peng8420.li@gmail.com>
 <20251114161127.193707-2-peng8420.li@gmail.com>
 <70d7ef58-8556-4aa4-86c8-b7ed79505471@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <70d7ef58-8556-4aa4-86c8-b7ed79505471@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E1D1C2000C
X-Stat-Signature: ptu5749ybf5mdqx83k1sc1g6cynaugnz
X-HE-Tag: 1763156480-63452
X-HE-Meta: U2FsdGVkX1879V9Hdl77wTXqLcV9LEO6+9bnPRq0m9uTnh19Qre5FmIpPIhIz0lS7kApbEQexT4bwLGpG91gpNehU8bAIbKDvvHg3ttkZ8zLBDKQxlgXlJgKehVCm0gJzxbcw0XJvrOrKv83hecY0t2gXjZry1wapeCVFsfDX9TcEjr1Xw0I+3d/2znlaxLWmXJzPu/YWYSVoGizB6S6QIvx+d/c90whRi8+EduDhqyaiEvRQd/6URN3fOtKz/cQLUDxPtCpITQXLMvHZBQK/6jJk/UGBOdPsDRoKVDYFDOSIRftX49FhWcea4auLkf0MLawTCQqjRWK0YXYgtdzePl5No0SsNZyZZrfpYw/KtFSG5ImM3ePDLJsMl6iFcl6GurHWLIHFF84L3qmZqmVA/KkGboN/NpDcQOCD+te3TTpQDg9m0oIFgH8ZF6Ryg+SJntiK/aRoxhl9pHOvD+uKTkEjTsPwpSnTifqC810JXMX8BH7SAICcaxQz5GKdp5XfXUkqjGuX57LUmhay5+eJ8Qdlb18KR5UBgaxJ8kvVlq9ItwX7Q6j1iq91EUFrh6U7nrc0HivYdGVnSiNoLHSDMrAqrkGiPz0HYEHERL65Gp5uDN/JqEPrhIwtxqhtnm4MbDaWzRneZ+Yh+rQontn3Aud+2KR5eARexfMPYZiUQuvIBa30Lf4RF6silKRWiN8kR69e+upjHxu25K4C160SD7nc4d96fx8Wd8kgHn+f56BKf5XYPeonxx8Cbs9URHM9wWLla3y40XEX8rApdTYTpLC+pBVec6VfmZWrmnCSjBfFnJ+IB0R8VPZVeIq5792jIZra4dNxVAY62k8PRJx9jHqKSdk3EXwaXOiaWNDugJEISSUcFmrrZWszP7CDxLleVOeF8oGcCRrNoLz+qlFmJY+bdr92GMMCDZuipkVCNzeukkEFHZbD9s+fY6EAICzpgRzMMtH0WM+M28dj6Y
 qkSy+OCq
 mLlDapc3CfWMfpcuKwwufYBCPpg9VDaMur/yk5Ox56og888dm8gJkC046uUAbV+PVCXb0NNXVVt/NFDQ870DGEAqsXSy0gmJoi0oyQgLLrO/VanKvTGvv3pRwn8Q7OzXL0YSmsIHRs9KUphqFZ3nLrsKiRgEbhujY8eZszGQEMtj5FYTT6yLx68Jtr4G9HEbaXR5fBUWerqr4nO9p0q8SBaLh1lUCn0fXmEOz9Hz7FPk98tzIpC/qJPw95mDIFzWafG3RT/0rjTLRk5HbrMpPLW8I2o21BLPqCHBqK9fM9QqkGb1XB5AxdaFRrve1I6TJ81ws8sB8zU0Et2K2rYY5K3yJtDl0e4xAFrLdxlOfNy9xHgjJrweiBGFMDggTte+YvqWecdkuySFdkPO16EwgU9zelmBbTljoMf+4FDkUNglyMN0+ge9JHHpV6lVgGiAQQHtA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 21:26, John Hubbard wrote:
> On 11/14/25 8:11 AM, peng8420.li@gmail.com wrote:
>> From: "peng8420.li" <peng8420.li@gmail.com>
> 
> Please see my reply to patch 1/1, about the real name, and the
> From: item too.
> 
>>
>> The 'FOLL_RITE' of the copied source is located in mm_types. h of mm, not mm. h, so fix it.
> 
> "FOLL_WRITE"
> 
> Also, please wrap to 72 columns.
> 
>>
>> Suggested-by: "David Hildenbrand (Red Hat)" <david@kernel.org>
>> Signed-off-by: peng8420.li <peng8420.li@gmail.com>
>> ---
>>   tools/testing/selftests/mm/gup_test.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/gup_test.c b/tools/testing/selftests/mm/gup_test.c
>> index 75f7134d529d..40c1538a17b4 100644
>> --- a/tools/testing/selftests/mm/gup_test.c
>> +++ b/tools/testing/selftests/mm/gup_test.c
>> @@ -17,7 +17,7 @@
>>   
>>   #define MB (1UL << 20)
>>   
>> -/* Just the flags we need, copied from mm.h: */
>> +/* Just the flags we need, copied from the kernel internals. */
>>   #define FOLL_WRITE	0x01	/* check pte is writable */
>>   
>>   #define GUP_TEST_FILE "/sys/kernel/debug/gup_test"
> 
> With the commit log fixed up, please feel free to add:
> 
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>

And here the subject should likely be:

"selftests/mm: gup_test: fix comment regarding origin of FOLL_WRITE"

It's usually a good idea to take a look at "git log -s $FILE" to see
how previous commits came up with a subject.


-- 
Cheers

David

