Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25DEFCD98C5
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 06:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5117E6B0092; Mon, 15 Jun 2026 02:51:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1F46B0093; Mon, 15 Jun 2026 02:51:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D8076B0095; Mon, 15 Jun 2026 02:51:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2376B0092
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 02:51:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B871CC3325
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:51:24 +0000 (UTC)
X-FDA: 84881225688.07.20BCD20
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6416810000C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 06:51:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U6lYtNM4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781506282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hrkz43e0CktTxobQYWEmQydCF6benCwIbJSIRVKApEE=;
	b=mERVp2VQkTFQ385O/wKsCdv6V2sZBs/RAD/eYNJjhA1E6iSCrPqJeGlX1LIXdINzhGgmhZ
	ppOMbsxK6Z07UtoDA2wXkpbLDVHLjDi1Z2nEtu161UuioPeW10ItYrKimU59JY7bZnderm
	3ShVln+Io3E+yvRNFR6+NyS6QaXlv7s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=U6lYtNM4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781506282;
	b=jmFiFvVn/Ki+pETn8eiQACDxGUpCiRuvao4wqvk+OWU/FKoyDy9RzztxJpvVw59VsLFh8e
	YLOZNFIbw+PKARqzFqXtByi7oeRirxWCRoK42Dp4HN0dRWZ4H/3WLyoXtN8cwtcwYidR0D
	mK7huq+a2m2RrWcjQAPnzGzrKtNdLBQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781506277; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=hrkz43e0CktTxobQYWEmQydCF6benCwIbJSIRVKApEE=;
	b=U6lYtNM4VHS82osL29XiVYCc0oxmVAruMefgCJnAnERFVTsDkRF9CAEfqbIdEdjBsYSncY5Km3fIBxMtDg6P8K6plWpBBTKAiJDQb6UtsUq64Qcp7TkF1Vo5a5bBnjJDxQVT1gXMf4CNr+SGFQuTbkQ3+tN0TzRN4J5ASiy9UAw=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4qX61x_1781506274;
Received: from 30.74.144.140(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4qX61x_1781506274 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 15 Jun 2026 14:51:15 +0800
Message-ID: <01b9caf7-241a-4140-a05c-826756611e7b@linux.alibaba.com>
Date: Mon, 15 Jun 2026 14:51:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 08/11] selftests: mm: extend the check_huge() to
 support mTHP check
To: Nico Pache <npache@redhat.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
 <bbedc5afc56b0f7b2073324a3551159ed9cf5f9c.1781083630.git.baolin.wang@linux.alibaba.com>
 <9c424084-2223-4d69-87b9-cd21c443b396@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <9c424084-2223-4d69-87b9-cd21c443b396@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6416810000C
X-Stat-Signature: dwfdb4g4mq958fujj6q348pritdtmwe5
X-HE-Tag: 1781506280-114728
X-HE-Meta: U2FsdGVkX1/bldVkToWbTCd0R8a/9lfjpZs6wOuXufaeJBZkn4AaRoKEMcwQKFwDYQtWwwdmkgyfWZ852C7GrD3xu5vz0X82FT5Xy9B6YRHgw+i0dGs1xk04OO/BNCln6fRiIBiw5yNs0yvlJRpdXRhP9k3KY9v43+sF30ntbcVaInhNnrQU0DTR49FVwr2d1NI1T7gHuDyCV6KVn2EmTVFAoXhqL6LJtAhmSeGw/8gzCOT0iODyALmhLX5ldhRvDA3auF+hhF7SXj9eR15qipwko/p4evrYJrZhaTma8DnJ6aqNEW7wYNqaHtDhs909/6NsDA9GfXH0VEqChJGEB5my6Rajosd1fPxeDe3BzjTctrkFJfq4IpGdL+GnP9FRHQRJw6Exo7/AdoKcoixMVT9FvpZzvr0qFwejlplJ56+vMbi4x5Wz+PZEzfuRokH8+8talxlt2695nrKg9/BST17V9AD7hc+noU82y1S1wyf15IEQKmqp5oiNFSUYhWBeDzdjVRrqVRExALli+yCQBgjWOk4/uR8Gh/IusdHqEFyQCxaDWbyfZNgyAVmUMxijnWFMeMPyMh2cMnUqydge+hjPw0K4GVuvgCm9RlYd+FWx/0XBa49mFZ1Q/3J8mIegH1rJI2KyRW6968X+mgLiTiPs2g5BlnmDUwBBTm/79rSjG3mWuikLav7CU57L5+6hu3t1GhfEXW2qzBfDOzHOpR8j/h4d6LL4iRKpOBpNAa4CvcbldqeIETcgH/8C0UnXgT1as/JcmmpcPr3W2N1gYDuBlCctM7EJihNVpIsD763bQB44FvvXdv0+vcvRIIYPVCd2Q/Vs+H91Bx1wNaXmdD4o2iafc0esHYkZ+5ZAGeviBIQlVTBX03A4m3XlTClkDJtYTt0Lo5XyyF3sCp8wHLFO5DhANFohqUJSa1U6J08Qx+PdzSlx8H1ITUYCcpBRfixmn0O50sDEnc+u9qx
 UECnZ7fU
 xhvvwucNGDm8a0LO9htollziWj28/1jaqeKylPEQdIGBp5qJRdsrHADBLHkGKPU0cl8e0n0my+jolkUxqGwIjzBNiBQRjVJB66TdhO4hUiNQiij8/ldPMUf0KQ/7WTrkl5yTeYiBZC99MvdVgLmkFlIIy89aZN7jY1kR1GReLsdhEheImbYZT4nrqrabUrCWLk9zj/Uj5XqnrBwNWWK1OnxKQB/ndQYvOduGzALAQh022eWa6vKx8UoPk6ruOzMTouuUUGoWNdP6Ykx+s4d64Qdue+ynm38gla9iWgwEJ6KaXmT7DlbWPu7F8z8cIFx1Z70fqrvOTHJoU+lrbqrHQppWMRqVsxhn5+j9W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/12/26 6:32 PM, Nico Pache wrote:
> 
> 
> On 6/10/26 4:29 AM, Baolin Wang wrote:
>> To support checking for various sized mTHPs during mTHP collapse, extend the
>> check_huge() function prototype to accept two new parameters specifying the
>> address range and mTHP size, in preparation for the following patches.
>>
>> No functional changes.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   .../selftests/mm/folio_split_race_test.c      |  2 +-
>>   tools/testing/selftests/mm/khugepaged.c       | 66 ++++++++++---------
>>   .../testing/selftests/mm/prctl_thp_disable.c  |  2 +-
>>   tools/testing/selftests/mm/soft-dirty.c       |  2 +-
>>   .../selftests/mm/split_huge_page_test.c       | 14 ++--
>>   tools/testing/selftests/mm/uffd-common.c      |  4 +-
>>   tools/testing/selftests/mm/vm_util.c          |  6 +-
>>   tools/testing/selftests/mm/vm_util.h          |  6 +-
>>   8 files changed, 55 insertions(+), 47 deletions(-)
>>

[snip]

>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
>> index 311fc5b4513e..b43adfa92116 100644
>> --- a/tools/testing/selftests/mm/vm_util.c
>> +++ b/tools/testing/selftests/mm/vm_util.c
>> @@ -247,17 +247,17 @@ bool __check_huge(void *addr, char *pattern, int nr_hpages,
>>   	return thp == (nr_hpages * (hpage_size >> 10));
>>   }
>>   
>> -bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size)
>> +bool check_huge_anon(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
> 
> Whats the purpose of adding 'size' here?
> 
>>   {
>>   	return __check_huge(addr, "AnonHugePages: ", nr_hpages, hpage_size);
>>   }
>>   
>> -bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size)
>> +bool check_huge_file(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
>>   {
>>   	return __check_huge(addr, "FilePmdMapped:", nr_hpages, hpage_size);
> 
> Same?
> 
>>   }
>>   
>> -bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
>> +bool check_huge_shmem(void *addr, unsigned long size, int nr_hpages, uint64_t hpage_size)
>>   {
>>   	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
> 
> And here?
> 
> Perhaps I find out in the next patch :)

This is to specify the address range, so that when calling 
gather_folio_orders(), it can count the number of hugepages within that 
range.

