Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11899C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0476B009E; Thu, 10 Sep 2026 08:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C8A86B009F; Thu, 10 Sep 2026 08:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE4D6B00A0; Thu, 10 Sep 2026 08:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9FF56B009E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:25:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B9641A046F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:25:52 +0000 (UTC)
X-FDA: 85197774144.05.C003733
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 944D140005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:25:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7jrZ0Ki;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W7jrZ0Ki;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789043150;
	b=BjR2xVAz2covAJ9N91zDTMGf+4vuirk0fyl12P/gPLycDAlpqP16YNOaanFOeQVk11NNiI
	rofCzSw/P8ExNG7lhm1vVgxVHOC+s7kq2fwJMeI/MyKWyhAlu+GDSpVxVaL7ZHzhdbd6wX
	7c50Uf+6SfYlFTUvoHE+QGXvMmdbQQg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789043150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcY5aAJKfRkyYPIjb0gh7z3qil202KhtkYgA2Q2nJIk=;
	b=YPchX8MWibTwzi0hCMJXGnHI7beD1b9Pv5LJ0ZDgnF5C1kNW2MPBNyQkyb1E4zSAMr8RI3
	CF5XcN/OT5OJTJdZAwAfMLkaPYhwlBMXwlFjgiAREGumZ2wFr452CAbUHf1B/my4MlaM9z
	1KV1voTAdtHeoqeSh9hyS8bdz8m5ZSM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1136260200;
	Thu, 10 Sep 2026 12:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D001F00893;
	Thu, 10 Sep 2026 12:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789043149;
	bh=kcY5aAJKfRkyYPIjb0gh7z3qil202KhtkYgA2Q2nJIk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=W7jrZ0KiUslcrcZAsoxUXdNWZedOCdeL8f5cQxxwc1/hjSOggsKVKb1j3s5wWBfHV
	 rxn3uhWlGA261dtpQj57VQf0l63oQM4lMLWGfvdHey3/c8FRyVAC6f/RsZU5dY2tCR
	 ekhqk1+UdERiYX37T5KCX26QOisMPv8zpgoQHwdupnf62whh15BYk8hKsy8oF9js9v
	 XsDuGSEICcBlqzcEv+IKqoXuoN8i6xYs7KiQK6G/rAUgo7xWGKi3oH2S6w11/VaaPc
	 GEPQRssD77FLa2hy9GADgpb4pjqlBkvAvqZnot7ndQazNqYdlBL+Y+ZHZbKnmtCa/c
	 lSP4CMhGSInqA==
Message-ID: <11a36d52-89a0-4f43-8a51-a4930e171ba0@kernel.org>
Date: Thu, 10 Sep 2026 14:25:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce alloc_isolated_mem()
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260907-fix_split-v5-0-822b810458bc@arm.com>
 <20260907-fix_split-v5-3-822b810458bc@arm.com>
 <5c05b620-7a2f-453d-9725-fed4f536a019@kernel.org>
 <aqKOVGECsCNtSMIV@e129823.arm.com>
 <d0b3ea99-e20b-4883-8fa3-67fdbf5b1ee4@kernel.org>
 <aqKS7CP67X4h6NiM@e129823.arm.com>
 <31418d0e-9745-4e8d-bc02-dbbd5cb9e193@kernel.org>
 <aqKU0-Gm4yh78F3V@e129823.arm.com>
 <d6f2e6b2-9dc9-4f02-be37-14329c1a6798@kernel.org>
 <aqKfjqa6ye2AOU5k@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqKfjqa6ye2AOU5k@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 944D140005
X-Stat-Signature: btqd3pjctct1k1o8xhhz19ww5e7ro1cx
X-Rspamd-Server: rspam01
X-HE-Tag: 1789043150-628620
X-HE-Meta: U2FsdGVkX1/SdGxZpaPD/b3sEDiRfafVgfGcIkf8c7IBVmRPYaSbYf14SbTiCm3adfuqca0276I9q3LSsLnvmyBpyvie0NTeqGGdybAfIi05EAYQtWMNcpgyghj1aiGs0+d+nOLWmKntScWXtyFIb/0DPXRxAqJmO78i5az1AnSPbjGtDwgiiDaWY25c0Z+ohtcjVVo0/JlcjZTMQNI/9Cnx9M9GchWCztzzp332jJYEUwtvr6WqeUDkMCl343G9uN430YaHy5F3Wimld0ik+jeTd6OGBX+xegyMT09mFqLxVsVyrCqtTuAyUxDx4vMmy2bj8BAkz6phfXr8r8gq5Ya1QFVxLQ5N1rxSDQuww/rQuYatw9DKmXRNKc0nmVMTBztikyUFCW7uKU/MW+0ZAYncU29y4kUKQg8LbgwYjfW2cOxgNDaeRIpziKDd9OuJ7kjrXM2FftQU11/fGBOKqdMKx0yYxMlWE947B7UwtRF0lY7+NgYQNeDHBSQ8+O/xR8SOyy7AXSg0VFHrxYnNe2K9lIK4yJj72KdYBeQa0ZSoqwAnvRQ51lrKIk905IfttRY+ljsuNk+gYzhw/wTHSTpNeE/G3w42/qx4msBY/mTG1DWUJE36lOjl8NUCxmfFmlrMyZ2lD07OhzRcyIGPY566CBvTwZ5WQKTfBSyCCLz5TZM+jhdwUeL5MDRm3nQ0mUO1MyLkisPwBknATlp40L7O/LvImFoXYKMZGdxf8CLNwW8UQSfrxp5fQAMT/yIhHYhqobfq6e1vTjJ1a8+KTR+WA1LTQhrXWn4wgFACsX6Y+sMXrwOBlLfdwCo14dIyEZgXCKqnANVmSwK5fjQlY09YLq9/VNomxxajVpzY11XzflXX7H+ZS9cqihsup04rZ3QDkRsN4OW4x7WVGUnZg1XzfWJX7aTE0n+j4LEkajmCqnn2+nR+2mh8N1QCvbXsM/EsrznwDFqbGW/3KH7
 rRK4SXuT
 dOMuXWlLbukxXnkWRCJax9Ml063FrlOLNeqK9RlYjLSLT6OkjmDBPiEbSBmIobaCY6y9rkCLxJwEI72VhvEMCTpI64W0wLNYw2wIQxTJtu8M37XyLmkomnnZlvonzrWJmLyA226jAZ9fEjStFzOS8O+aZgZD0qqiQ5dTm6B8chX8WTG7gzIyNRx5BBpeQ+hjAlWtLxJcBrQU5e7xHYfD2SfsyqDzRvnSZmWv1q8DA0a5qGQqIGYPqYRWhw6kWUHh31IisnGBt4CKTV93FtZ4bU6eZ0lMbrF9R/5oEMd7wEO1YygstHdD3izPTZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 14:16, Yeoreum Yun wrote:
>> On 9/10/26 13:30, Yeoreum Yun wrote:
>>>
>>> Yes. so if we remove ASSERT_FALSE(check_vmflag_guard(ptr)), TBH
>>> we don't need this patch unless other usage comes up to prevent unwanted
>>> VMA merge.
>>>
>>> Would it be better to drop ASSERT_FALSE(check_vmflag_guard(ptr)) in
>>> guard test?
>>
>> I guess there is value in asserting that not all VMAs by accident start
>> with an over-indication of maybe having guard pages, which is why Lorenzo
>> added that check :)
>>
>> But I think even alloc_isolated_mem() is wrong in that regard: if the
>> original VMA gets merged, we could inherit the guard-marker, no?
> 
> True. I overlooked guard bit is sticky.
> 
>>
>> Maybe the following would be good enough?
>>
>> diff --git a/tools/testing/selftests/mm/guard-regions.c b/tools/testing/selftests/mm/guard-regions.c
>> index 5c8ec3ca75d7d..791bf6a68b9e6 100644
>> --- a/tools/testing/selftests/mm/guard-regions.c
>> +++ b/tools/testing/selftests/mm/guard-regions.c
>> @@ -2257,10 +2257,20 @@ TEST_F(guard_regions, smaps)
>>         char *ptr, *ptr2;
>>         int i;
>>
>> -       /* Map a region. */
>> -       ptr = mmap_(self, variant, NULL, 10 * page_size, PROT_READ | PROT_WRITE, 0, 0);
>> +       /* Reserve a 10 page region with 1 page space to both sides. */
>> +       ptr = mmap_(self, variant, NULL, 12 * page_size, PROT_NONE, 0, 0);
>>         ASSERT_NE(ptr, MAP_FAILED);
>>
>> +       /* Map a new region that is guaranteed to not get merged in any way. */
>> +       ptr = mmap_(self, variant | MAP_FIXED, ptr + pagesize, 10 * page_size,
>> +                   PROT_READ | PROT_WRITE, 0, 0);
>> +       ASSERT_EQ(ptr, ptr + pagesize);
>> +
>> +       /* Clean up the excess pages left and right. */
>> +       munmap(ptr, pagesize);
>> +       munmap(ptr + 11, pagesize);
>> +       ptr + = pagesize;
>> +
>>         /* We shouldn't yet see a guard flag. */
>>         ASSERT_FALSE(check_vmflag_guard(ptr));
>>
>> -- 
>> Cheers,
> 
> It's enough but alloc_isolated_mem() could be modified to allocate with
> PROT_NONE first and then change the prot.
> 
> It seems whether make a helper or testcase should write the code
> properly in case of unwanted VMA merge.
> 
> IMHO, instead of testcase write them all

So far I am aware of exactly one test case, which others do absolutely need this?


-- 
Cheers,

David

