Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69CA8CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 09:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EA626B0092; Tue, 29 Sep 2026 05:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C23A6B0099; Tue, 29 Sep 2026 05:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEF86B009B; Tue, 29 Sep 2026 05:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0F06B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 05:17:59 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C232D1A0441
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:17:58 +0000 (UTC)
X-FDA: 85266247836.28.668B028
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id AF0F580005
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:17:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=q8KFZd3B;
	spf=pass (imf02.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790673477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIkLs8Lre027DxI25z4j8VsEXz4zyZK/rBShGxIBDCo=;
	b=L9k1cUzAHVcTAR6RCY63cvmt3Xnx1v4yyhWtaFScNnEscopWSNViphDUoiGAUASd2ffYQ/
	dDDIn9YuR6g0fYhFpoc/SCh+xV0sYjTv5d3PZ3TLiSSduavxyVnQ++FiWhkL537XDvaiJ4
	HnczcLEg36PhOoD02OHx/3WTd99ngaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790673477;
	b=1VZDGtH9mjndHpmoJVv//mHE0awJO3R2vtMkUxrlYx+oB+GRKBGtJdZMBLRVPgB6Sq3f1t
	kX+ddFIfIuzw4i7nlWT/cuDqx5SS06niUJ9MUyUWzt11iRm2SsZlo8Wcq7pS1x7/ZTyGT1
	0VUutLskgfhAQLG7ceHSG7kY8hdDA2A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=q8KFZd3B;
	spf=pass (imf02.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CC601516;
	Tue, 29 Sep 2026 02:17:52 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 60D093F85F;
	Tue, 29 Sep 2026 02:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790673475; bh=nOSEEl79eSk48PAKP3/2NBE1Ft2bwBsVgVFfWHWUJic=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=q8KFZd3BBRBMJlgeMlWCKTfZDXQpc/UYxzhqcGtJ3aV/FDT5ME+QXAg3YCkZlL6Rq
	 AUMJUmTWDbftCUh2+hDIII0FpkYzmhCqwziZkSilBbPkuW4/3qguitLTadWAhQdEYx
	 Y3ll8F4B24bnf4hQfC8CHD0dtxvi5f0VmKw/xEmo=
Message-ID: <62fc6a5b-2eaf-462b-af90-ecdc52673f4a@arm.com>
Date: Tue, 29 Sep 2026 14:47:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 2/9] selftests/mm: mremap_test: skip test when
 userfaultfd is unavailable
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-3-sarthak.sharma@arm.com>
 <49b0b8c5-4605-41af-9a83-26ec6a07bb96@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <49b0b8c5-4605-41af-9a83-26ec6a07bb96@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AF0F580005
X-Stat-Signature: ctcyqcnkzb5r9mo45uknqrxexrx14x65
X-Rspam-User: 
X-HE-Tag: 1790673476-821808
X-HE-Meta: U2FsdGVkX1+LTjNiMTrVQS5aYxQx6T3rYHmMVQCGxjTbU2VcuW35Rj2A+FETQYjaAcKAsEoxFHoj1xQmSNRqHsLQeD6czOUUokX0VuSD/oMK6kIFFuTYxmknvYeRHIIXJ8rn8C7hNDT3PJp0Fq4vu+Cfj+xQGqqePSXQ3rtIeUiHJdf/j/HN5awRtC5mG0h1/0zPkgdwWd0atZZlHndot+HYmb3Gdf7EE5H49qfI6zJs5cUuTa6bNG/S1dpL8XrhlYQkdtLkkJKV+kb0M7ocHAin9h0TnsW7BLr35pXBeIo0LiAPcYmjlpxF60glTBvFPKlQ9bCX68oxJtDjy2ai+ECmCE5dqNlMWZTF+lGGSATDKxT/69k8iZokaSDDCE+U2BXStwup4yS3fCDpTeoUAGBL8aRWRaFfOsG4b3hsGUDvTdyWH3yzPy8S+K9cHdkISb/oTTeBHcX2m9Y1h57+pLWeIk73m9TBNFRS+GEdSQli33zTQROvQ+pNCUL5cKqrxTbXXV+6DC9emoAG2OJ6XzCFFH0nejHwcFUv6mMSLyV8vfGZu96uFSAG/NTVWzQrcb7Eg4NfMxkpxSqJ8SPI3e2oGF3FcDwKnXPgAbuGbt3uhAFrEqmKiBhIfSDVGYFN+kAYIQo5AHAo5Nrare64MUtN27LBbY7IFrEIuLa5+eXZrQNE/ZhJaOVyFGaie+PHunURFq45+Qvip/V9yNPgLn7AaXu/168uG5yeNgc3dj7hf0NYLl1tM/rxAOEiowFMO6nvlI0t8hcqS4pqU9SBtA4tsS8r6AiP8Y3MvqoMqInu+/KspsRUKzNSj5KzxIbB76Z1Vad5rcBXp7qvgtPDs7ox/zWmWOB7jbsHmPgzhJZ4ovGZgaRV32MHIZyvUpfugHfvVdS0uVag//q7SWjw7OlQRrJ9xcNSByPevAZmAc5L2L09EHrLtk5oTgzMpa2JUC6rl+2W2jsfZNp5kqU
 0j8PwHOS
 CQl0FBNb2yLUXZkbxX1J+ZXPT5QU/D1UO5ToOWSoKMyzmHDkTw2kRJ1AwtSX4j9GnFBFDrp+9EIvF6X+y/8vsLKVf+4tPhm/wt/U6Cq0X8P8t7OE032U/G0d0u7z/vW+2JG1K2QRMxaKS1DSTW4MdpVW4fOH0JUXmWGCG9MejCVev4pM08K7jg7eZLBX198MNv1eof2ZyrahaFD4eRQL5DufWXGEONC3N/uCHL1U86OKVLFkCz4B4Q9PpqqkfHKCmsyFxUD5HpKGt0PAj6FbhEf4LDYrwYyeptgfBWQe9qN3RxQoVmmqHbDJ0LSfdXgwh/+JjAVd7vvDocqpmrhgVkEQNUxXq7l5KJAyHGsIvnlhMH6fTAe2ZMcgwug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 9/29/26 1:30 PM, David Hildenbrand (Arm) wrote:
> On 9/24/26 07:00, Sarthak Sharma wrote:
>> The userfaultfd syscall can return ENOSYS even when __NR_userfaultfd is
>> defined by the architecture headers, for example when the kernel is
>> built without CONFIG_USERFAULTFD. The test currently skips for EPERM
>> when the caller lacks permission to use userfaultfd but treats
>> ENOSYS as a failure.
>>
>> Handle ENOSYS like EPERM and skip the mremap_move_multi_invalid_vmas()
>> test when userfaultfd syscall is not implemented.
>>
>> Fixes: 742d3663a577 ("selftests/mm: add test for invalid multi VMA operations")
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  tools/testing/selftests/mm/mremap_test.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
>> index 5532d3151ed0..a5813a5e8f5b 100644
>> --- a/tools/testing/selftests/mm/mremap_test.c
>> +++ b/tools/testing/selftests/mm/mremap_test.c
>> @@ -721,7 +721,7 @@ static void mremap_move_multi_invalid_vmas(FILE *maps_fp,
>>  	if (uffd == -1) {
>>  		err = errno;
>>  		ksft_perror("userfaultfd");
> 
> Should we rather move that below the if? Doesn't quite make sense to print the
> error if we are skipping and printing a proper message.

Yes, I'll put it below the if block.

> 
> Maybe that should go into the previous patch?

Yes, will include in the ksft conversion patch.

> 
>> -		if (err == EPERM) {
>> +		if (err == EPERM || err == ENOSYS) {
>>  			ksft_test_result_skip("%s - missing uffd\n", test_name);
>>  			return;
>>  		}
> 
> Apart from that LGTM.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!


