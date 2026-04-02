Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E05CC6B16
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 07:31:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1D426B0088; Thu,  2 Apr 2026 03:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECCC46B0089; Thu,  2 Apr 2026 03:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC896B008A; Thu,  2 Apr 2026 03:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C63B66B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 03:31:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 74D521A0549
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:31:29 +0000 (UTC)
X-FDA: 84612795498.07.A7EA2F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BA6F44000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 07:31:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tMPIrBvK;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775115087; a=rsa-sha256;
	cv=none;
	b=jqKfBAeao8cN2x6dR5dxaB+BHqh0MVPKNfGCySSEoa0wD2Fy+PuZIfLdJGFzxRtzQScNTW
	ZTUaNmFqSSapopb90W46fAThY+Llh5ovHQdw/B2XOC9bqpjZ1FKNNdUJs2JJ1NiVSxBUy9
	12+oA79o9Qc/xLw4DUcQB0TEy8Dphqc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775115087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YCN81ehzXnR+NC3CjQc2Em9uv+d5aiIjzDl8gH8+Ews=;
	b=uWJ6mG1x8dzAVT3XcexTPARg3E09xCfaag21OgkKxm03cNz3N+octKFPtS6IYzX29o4qSo
	k5p8tlz70ktSIDSrKeFyFU9BjPhOSzGaz6T4SXiFVppcjwMy2mTtDBQrW+F5BT/cKr5edm
	txKa6D6ZHNJyfvZKWJZCQ8cJbyav+I8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tMPIrBvK;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 04E1A61861;
	Thu,  2 Apr 2026 07:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B54AC19423;
	Thu,  2 Apr 2026 07:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775115086;
	bh=LB/+oqKlI4VRU5D1rjvBo04nLr5ECYtn29znNNozBBs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tMPIrBvKTo40byCvRHv/28b+KqoC03TZRGKKrgRpkMzvXCSuJUdMY/EoIx48skJE1
	 pAkwb80w8EdBKR3zTVIxlc4RdsMGGm2DgW/R+Me9bVea1VDevoQHRqZOcdF/XGR7Pf
	 i/KHLYGmyG9qPEVVvgFkKWzdYXCXIP5Jzw+IxQ2PCrsAlDc27p0EAWkb/bPvMB+oyj
	 ny5NhcJ8nexHxMXECxD0WVtcyHBRSIx61acnotLrQcc5fFiedg95GQOcVvdq9M3bBE
	 Lszm77bdUctMVWYUQx3IK7mZYZDY757Tv5MuRoh5MrT/0+Z2a9S4zLaqfIq6KT/yfP
	 J8rwI4BZG+lXA==
Message-ID: <a1527067-0d49-48dd-85c5-06b628471424@kernel.org>
Date: Thu, 2 Apr 2026 09:31:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/13] selftest/mm: register existing mapping with
 userfaultfd in hugepage-mremap
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <b3a1760e4583340e767d4045b90784ee41c8773e.1774591179.git.sayalip@linux.ibm.com>
 <142f8c68-43c7-4a6a-bd2c-1c5ebda09b27@kernel.org>
 <7b6652f3-c994-4ef4-87a4-5473cd1254b7@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7b6652f3-c994-4ef4-87a4-5473cd1254b7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA6F44000A
X-Stat-Signature: ntf6nmtge9yh7ufa7cn6rxgayyy1kdzs
X-HE-Tag: 1775115087-569391
X-HE-Meta: U2FsdGVkX19GkmXRQgdsKwLEOOcxOhAQAn5go3gY+JAt9ggk7Wlvf4/prbClAdfdl43neho6mb/IYdUllPjrzn9SszxKRrC8pNIuMNN6HDhTmy+4UA6Z/oNAoNgCPUpgmjh1EtfvYAEuU6ZKChxeF9YaNHAe0QAn/XNRPiZ2O2pyCh/zPl95PHCt/6+LmXAcllgkR8rBkJ4FlRytOULe0gBeufR9Iq3cjGYahbv5bcyHTBJliZj1fHc2WHEvUEyEBLcX0WoJ8asGKG0JwvIbQNM3dG3avAmtF3s+V3hWkxNP8rmjKSI3+jN03c/bnxqfyAo/BmeE6Fl4Sp8klefytChvLfDMJEndKb/zlgYOhHvVLh4wBCBvRJF15GGqWjMemqEt3z/RB9yCSg4fmmnSzM7S7mKJrOW6pQkD62UbA6AJCLjmbwzKIhBAXTLu4apNa1H9nwxp3tCpkHjRT3aB3sHggW2ozefRtfl0gBR1KsVsgHE0vdZB/O5YkFjsmAk2RNKfZ9Q7Fru/6/f+DJfm2PRsLmNFuS3xSGqIo8mIaSNE326bkhq9KsdjFKDBM+vT587rGBWfia28NJhBQ4kEXYKhcSm0vEwQtrr5eAPZS5/NVtQ4KI0THyEfIenQUTwF1ffl1ZTgch6kbZJ6RgLjd4uq/O1iUzJcwKUqxB8A8fmfJ50ebp5MM5CbA/zZ2Ab3ytGj4bmWAeWvVAsG2g5u8Yfx6KxPGKtAAR726mxWKHwSJxM41B+Iu5o/fUwBdKlBzs1QWXuikbfyxX3JkmwGQp7tgKc9GUNI8uveDQrG2vUsvU84rKoYn0qZ0LnBcdkfUoImPB/rSwG0ErwIL9dzETf3zoQtfwMnUlT1eLS66y/zgX+i0ciXQ5s3rHjEb7aShaSEkAkVIly+UZmwRC/GWGXFQp085nAK59lAUsMz6l+qFVFtVFSUTNT7Z1aOc/n4wjaldjXEQfczCFvr3+r
 3Irok1lw
 fFETbn/socpRJWfKZN3rggrOvP4+pyNPxxDgcco/4AckWm4bhBXMh06olwiGmU/sKtQ8vO1Cepg4blB3SYEmezXKPahVEaWwd4UYpB3QbdxHPOoi0X3FVz6sU1HJtZSyQFZWOOkYk9+1g7q1/EMYtQvHM+r9kI0DFgbAqsB0l3wVTvjiSWmE17/8CeusVpQclmXdaNWA2PZpwSl7JiEAzd/kDPC02qELgMCLQK61+M5NRnS2SJdXenVnOoOxWTiE8wkVZ1Hul62CyZ1nl+44gtHahwryBWkFHOYHxl6QUCtdWPikc0qhQVp4fZPcM+y5o3slN9+S1sIEhs6yhfCaz4AfWWZt10K2Ql4oZ69o4CB8b+uOAoZ4uph3puw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 16:43, Sayali Patil wrote:
> 
> On 01/04/26 19:48, David Hildenbrand (Arm) wrote:
>> On 3/27/26 08:16, Sayali Patil wrote:
>>> Previously, register_region_with_uffd() created a new anonymous
>>> mapping and overwrote the address supplied by the caller before
>>> registering the range with userfaultfd.
>>>
>>> As a result, userfaultfd was applied to an unrelated anonymous mapping
>>> instead of the hugetlb region used by the test.
>>>
>>> Remove the extra mmap() and register the caller-provided address range
>>> directly using UFFDIO_REGISTER_MODE_MISSING, so that faults are
>>> generated for the hugetlb mapping used by the test.
>>>
>>> This ensures userfaultfd operates on the actual hugetlb test region and
>>> validates the expected fault handling.
>>>
>>> Before patch:
>>>  running ./hugepage-mremap
>>>  -------------------------
>>>  TAP version 13
>>>  1..1
>>>   Map haddr: Returned address is 0x7eaa40000000
>>>   Map daddr: Returned address is 0x7daa40000000
>>>   Map vaddr: Returned address is 0x7faa40000000
>>>   Address returned by mmap() = 0x7fff9d000000
>>>   Mremap: Returned address is 0x7faa40000000
>>>   First hex is 0
>>>   First hex is 3020100
>>>  ok 1 Read same data
>>>  Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>  [PASS]
>>>  ok 1 hugepage-mremap
>>>
>>> After patch:
>>>  running ./hugepage-mremap
>>>  -------------------------
>>>  TAP version 13
>>>  1..1
>>>   Map haddr: Returned address is 0x7eaa40000000
>>>   Map daddr: Returned address is 0x7daa40000000
>>>   Map vaddr: Returned address is 0x7faa40000000
>>>   Registered memory at address 0x7eaa40000000 with userfaultfd
>>>   Mremap: Returned address is 0x7faa40000000
>>>   First hex is 0
>>>   First hex is 3020100
>>>  ok 1 Read same data
>>>  Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>>  [PASS]
>>>  ok 1 hugepage-mremap
>> Okay, so we tested mremap() of something that is not even hugetlb.
>>
>>> Fixes: 12b613206474 ("mm, hugepages: add hugetlb vma mremap() test")
>>> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>>> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
>>> ---
>>>  tools/testing/selftests/mm/hugepage-mremap.c | 21 +++++---------------
>>>  1 file changed, 5 insertions(+), 16 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/hugepage-mremap.c b/tools/testing/selftests/mm/hugepage-mremap.c
>>> index b8f7d92e5a35..e611249080d6 100644
>>> --- a/tools/testing/selftests/mm/hugepage-mremap.c
>>> +++ b/tools/testing/selftests/mm/hugepage-mremap.c
>>> @@ -85,25 +85,14 @@ static void register_region_with_uffd(char *addr, size_t len)
>>>  	if (ioctl(uffd, UFFDIO_API, &uffdio_api) == -1)
>>>  		ksft_exit_fail_msg("ioctl-UFFDIO_API: %s\n", strerror(errno));
>>>  
>>> -	/* Create a private anonymous mapping. The memory will be
>>> -	 * demand-zero paged--that is, not yet allocated. When we
>>> -	 * actually touch the memory, it will be allocated via
>>> -	 * the userfaultfd.
>>> -	 */
>>> -
>>> -	addr = mmap(NULL, len, PROT_READ | PROT_WRITE,
>>> -		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>> -	if (addr == MAP_FAILED)
>>> -		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
>>> -
>>> -	ksft_print_msg("Address returned by mmap() = %p\n", addr);
>>> -
>>> -	/* Register the memory range of the mapping we just created for
>>> -	 * handling by the userfaultfd object. In mode, we request to track
>>> -	 * missing pages (i.e., pages that have not yet been faulted in).
>>> +	/* Register the passed memory range for handling by the userfaultfd object.
>> /*
>>  * ...
>>
>> While at it.
>>
>>> +	 * In mode, we request to track missing pages
>>> +	 * (i.e., pages that have not yet been faulted in).
>>>  	 */
>>>  	if (uffd_register(uffd, addr, len, true, false, false))
>>>  		ksft_exit_fail_msg("ioctl-UFFDIO_REGISTER: %s\n", strerror(errno));
>>> +
>>> +	ksft_print_msg("Registered memory at address %p with userfaultfd\n", addr);
>>>  }
>>>  
>>>  int main(int argc, char *argv[])
>> Yes, that code is extremely weird. I wonder if this was some
>> copy-and-paste from other uffd test code.
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>
>>
> Hi David,
> 
> Yes, the test operates on hugetlb mappings created with
> |MAP_HUGETLB | MAP_POPULATE|and sets up userfaultfd. Consequently,
> registering it with |UFFDIO_REGISTER_MODE_MISSING| does not result in
> any userfaults.
> 
> Originally, the helper function created a separate anonymous mapping and
> registered it with userfaultfd instead of the address supplied by the
> caller. However, the test operates on hugetlb mappings, and the registered
> anonymous mapping is never used in the |mremap()| path being exercised.
> 
> Would it be better to remove userfaultfd registration entirely from this
> test, since that path is not actually being tested?

If it's tested with your change now (which I think that's what
happenes), this is fine.

It was just very weird before, because it tested something fairly unrelated.

-- 
Cheers,

David

