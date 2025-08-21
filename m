Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E1B2CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 06:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA02A8E0015; Thu, 21 Aug 2025 02:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76488E0002; Thu, 21 Aug 2025 02:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C1E8E0015; Thu, 21 Aug 2025 02:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A59DD8E0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 02:19:31 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BEAA1DBE88
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:19:31 +0000 (UTC)
X-FDA: 83799762942.13.4B2BCB9
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id 41313180005
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:19:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qJYDM3g5;
	spf=pass (imf24.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755757169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hlCimOWmVNcNutaMxR1L4yVEDOntt3HAB7gKbGV25Fw=;
	b=n/cVpJYbM+TtLpWLkVCocYkaMSDkfPrvTkU3Zh84EfbaWY1n0V8ijIkcKRfr8WtGM7/DeT
	rdmWNDfbx7SqywQ8GgNr8ZhKMc8Z4xXPoonpN9RJ4rHttD7sIpfky5HooOMgrtUYbV3h4U
	IaO3biBQinhRnO7vXuWJzskwQ1v7i5I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755757169; a=rsa-sha256;
	cv=none;
	b=G5/cIrXPlGfe6V8Z3mMg3IOzfUFHVuFJximjI2MhC4O0NhP6cpnKykdODC4meAgFut92AB
	mBB0ieQI2jWO7mKF3zWQbSDBW78PKbm4muuPMoZoOBq/+ReYhUvyADjN/n2z/tn2dnnySp
	5wner5UrQ0ZN7rjtePijwJELxdkablQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=qJYDM3g5;
	spf=pass (imf24.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755757166;
	bh=I4zrmHfo3KUrLNPHF7/jdsoSqAbmt4bHTj4T59OIe/w=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=qJYDM3g5NXoL0QCYPIMItwhZAY7s/w47WqfLvieaC0s4EC2hPZ+XScMGvi1G6NxWM
	 FYEDZeHOND36YeFiwA08wY/hu3sM6Zgpau/MZloXBUJAKXmJCNsgX9/CAgjiu9cn2q
	 Z7aN1qLnPUFlGy3CMcCZaoIslFGSiLmrwRXyqxK+RFUdcs6CkOKY4C50XGlqbbn8CC
	 nG8K9/SakCWfA3yyKOcw9CoAAR6HHfO9giUxaXK+uK+qgHezpIO6LfsyMR7/1E9I0C
	 9zoSuhJnacA1Idu3dDuyeSxJ03mlbh7AijE75W3/Ik9J+zXsSuKLjYhMz5oVjqpR6B
	 64EbxkdmLlX9Q==
Received: from [192.168.100.175] (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 845C617E0071;
	Thu, 21 Aug 2025 08:19:21 +0200 (CEST)
Message-ID: <46dce2ac-adb5-4a6b-8847-fe214c1599a7@collabora.com>
Date: Thu, 21 Aug 2025 11:19:20 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@collabora.com, kernel@collabora.com
Subject: Re: [PATCH v2 1/8] selftests/mm: Add -Wunreachable-code and fix
 warnings
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Shuah Khan <shuah@kernel.org>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
 <20250731160132.1795351-2-usama.anjum@collabora.com>
 <c09a2a13-8571-44e5-b780-c704598df764@arm.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <c09a2a13-8571-44e5-b780-c704598df764@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 41313180005
X-Stat-Signature: zr4cj4xmp777egse44gxcw1c56st5kiq
X-HE-Tag: 1755757168-601327
X-HE-Meta: U2FsdGVkX18ByCai+hMTTjzvJyhb5znItbTZcOY0Uq/OkoiRSYNErw3YplXs83n9NRwoZqzMMwo6uyeu9JdY4Uvu0+FQWHLRyj0mNpGiI6ozxXVL4OdIKfjv80gyUUDgD2O1a8KP8UvRNDmXGett6bB49AwF1QNwi+7/mbaGI/gdECvtXc9fPYiwk/HySz8/R0K+eYLyNjVL6ZiFJ3x02avOcI36N1MLmIqP2NJA9kY9ZcEl6zB7qjRQy1Bi65lpv6iZCLGGseFOhBUJW02qb3jKQtOvebtvMjDwXSrPIvnDyWtP8qOJDN1a3CuwKiauhICLRZoBNH0GYCQfPE7jbvJmgJq9tQh+ZsgniL0KyE/YZSDwRLaL6r51Lwnr8bX4OH2bfsoIuOvTIMOsymMmu61ty63/6rxN6UJzJo5GVOt94s91nYEprGYouytbEcLsb8uxEdpNy2nu8yCXRkL6ku59YLEzYGJiDpEAbIQoD3fx1bspiS8gUpv9RQ1CsBJbRPm0yFamjnWDe5eZwr1wfb2AKiNEPZI0f8okQSrjxHaOPXEdHqqRlndqlFypz+WQ43nJlfT7FwKkGutsY4MLbBT9NdVHR2FIVC+Fv6QGYDcXk+0F6U2tRrmIgrHOI+9nli+LJlzlTFHMdaS8gdHtd9APqKFYiFALyivRhKqJazMoR5bxJZDT628OVS+BjEjr3nLZKxYIMnAvktZxViM1m1S+hmJR8H1XRnvr4vk69SsArhgf7lqgf2Ez0wYgqgzS62oRB1mSW+gnpYrYDca3T4MSRMKruFLn9u+8X++Lt4mi2ac4kL12KbkdDTn9LYJIewuN1qvA4qa/gboVaw2DwSBWhHmOw6gZG2GNTy+BQ5pyr7rmyti+O5JySnFpqaw6JIv4q//hvS3UqHRpVpk92gJF9bu2mY40UEGNdVQrS9Kuet/bFuue7N1OD/yox90Qb1xAJgWrCu6rMor/rn4
 vYe0LyND
 g1pfYv0fIMpy4PrNRlKZl2VQH4neYih+4qmtPodZU952BljxajJs8SqxE7ViK+OBhOrxxNvrHhkTXZjkqyyJTIeXW3ANRKYXC9WdF8hvOYWCfCTpd7FdM2JT0B47csK89ItfEZm/Kdo0WhuNQBvA6rOc2IzLSNIl2JAsRiTCKnVbBHYDdG7osIA/0P+CSgVuGS6azfXw18FmDW1V+fh2Srzt9YMkTWqHakY8HlCyDmwgVGaxr8CQQsJjoX69jysARfJZb5Q+KNbzePNfs2W7DI11UJ+ui1F4r3hDWSo6IL3Fi9f0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/25 1:10 PM, Kevin Brodsky wrote:
> On 31/07/2025 18:01, Muhammad Usama Anjum wrote:
>> [...]
>>
>> diff --git a/tools/testing/selftests/mm/pkey_sighandler_tests.c b/tools/testing/selftests/mm/pkey_sighandler_tests.c
>> index b5e076a564c95..302fef54049c8 100644
>> --- a/tools/testing/selftests/mm/pkey_sighandler_tests.c
>> +++ b/tools/testing/selftests/mm/pkey_sighandler_tests.c
>> @@ -41,7 +41,7 @@ static siginfo_t siginfo = {0};
>>   * syscall will attempt to access the PLT in order to call a library function
>>   * which is protected by MPK 0 which we don't have access to.
>>   */
>> -static inline __always_inline
>> +static __always_inline
> 
> Thanks for this, I had this fix locally but never got to post it!
> 
>>  long syscall_raw(long n, long a1, long a2, long a3, long a4, long a5, long a6)
>>  {
>>  	unsigned long ret;
>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>> index 05de1fc0005b7..a85b2e393e4e8 100644
>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>> @@ -296,10 +296,8 @@ void split_file_backed_thp(int order)
>>  		ksft_exit_fail_msg("Unable to create a tmpfs for testing\n");
>>  
>>  	status = snprintf(testfile, INPUT_MAX, "%s/thp_file", tmpfs_loc);
>> -	if (status >= INPUT_MAX) {
>> +	if (status >= INPUT_MAX)
>>  		ksft_exit_fail_msg("Fail to create file-backed THP split testing file\n");
>> -		goto cleanup;
> 
> At that point the mount() call has succeeded so I think we do want to
> keep the goto and just print the error message instead of calling
> replace ksft_exit_fail_msg().
The cleanup tag does cleanup and then calls ksft_exit_fail_msg() without printing the
actual reason of failure. So current flow seems good where information about the error
is being printed.

> 
> - Kevin
> 
>> -	}
>>  
>>  	fd = open(testfile, O_CREAT|O_RDWR, 0664);
>>  	if (fd == -1) {


-- 
---
Thanks,
Usama

