Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EF64C88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 04:32:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADCBD6B008A; Fri, 11 Sep 2026 00:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4186B008C; Fri, 11 Sep 2026 00:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F16E6B0092; Fri, 11 Sep 2026 00:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6251E6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:32:35 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 44B261206D4
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:32:32 +0000 (UTC)
X-FDA: 85200210144.28.70824B3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4025840002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:32:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xmrwydqh;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789101150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Q1/NUVZn+jCPysogxCzsbc//x4mJlPJQE8FNV+lHlI=;
	b=qOcXipzSoY0w26Bc2jUf5srbymU2/0lGIsAL3nm35FPXoZV62XQwdl8bN4YN9ngleTI4Kp
	nCA9A0B9WZUGfjiJ12oKkkAqQIINZMkQAu5xTgieuKGD0OsPd09jgqsUJ7UznsvHBtq1HH
	0dIy5yIkw3FY8ymCNktf/vjcw7ygQYQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789101150;
	b=SdUHqvqTCbg3GhOij+Rc+ONy9YLUoaQXPdnbIf2Xg9UgWIIDYl+UK4/CbzfVMru8Gy92FK
	MDenLpu3xBmxKHV9Uapw2RhN5w470x3DFqDqg1e7KfLWjgAIVr4OKj5ZTGFnq4oxajRjCX
	nVSmNAWfOya2IEbh7Z57+OI/xxvOFj8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xmrwydqh;
	spf=pass (imf12.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 75BDC1BCA;
	Thu, 10 Sep 2026 21:32:25 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F2D773F7B4;
	Thu, 10 Sep 2026 21:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789101149; bh=6nIY7vDGZl1HSYvtDHEzSpFXJFmf/2f+RPP48FA6xjQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XmrwydqhBZ/vf1ECBYZqTArXWHBOiLel894SB9CwN4Xy7DofCaJ+zOog4ySBEP7Hz
	 4KhKGUpFRrxfJZ2ULqbeOunH7b0q2UHOnOjSo+TkHoCHono2PP0xtQpCYja39Rnbls
	 4gcwvzdWSOE2J6vNY9m5bsFQyw5Lpa2MPLdctktg=
Message-ID: <f7416ebc-f897-4c9b-8266-6aa7c9fd5473@arm.com>
Date: Fri, 11 Sep 2026 10:02:19 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 6/6] selftests/mm: add a GUP selftest
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260904123631.198697-1-sarthak.sharma@arm.com>
 <20260904123631.198697-7-sarthak.sharma@arm.com>
 <b0400430-c3b6-40d5-b476-49189b1cc292@kernel.org>
 <5e0b9365-cbac-4f2d-b915-85edf3093508@arm.com>
 <fadb8870-37f8-46f4-aefb-c21bc3a31e5b@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <fadb8870-37f8-46f4-aefb-c21bc3a31e5b@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: kixj5hrjgz1d3a9isb37eyig7wsbnrrk
X-Rspam-User: 
X-Rspamd-Queue-Id: 4025840002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789101150-41892
X-HE-Meta: U2FsdGVkX1/mzXVT/WzPDFOMoGdtZhgWoYJADKHqxABRlkF7tkQw4IH4B1IZ+oE2P1V6jVHc7sSQVQDLQpf8WjGTqCkOK14l5BB7138Ls0M6ErjuWLnBKZhn0+Nl3TYf97UZYVvm+dSKfKaWdvFLeARKWDMfzNGBc9etygtprIqMbsCalXmN513s8eyWqKmg3pzj9hEyS4Egxku1PCco77hcFuBpdk9jobEwOSMD8r09bZotxKLsmJmPAS5pV4vQbZNP4N3c74IQESTtqvD0Vy7v4lPoiTBE4tlrV/23GjpxBEETaxlQdi12v/1l6msnYAgMaQj2Zo9DzkgV6T9YKMUlGSF14LVXSmA32YNISuwvFsfQrn3PjpsdpcwFdQBz780rUchH5Tb8oGB+85zfS6wwULAipKqyewyVypQYrSk175SM3EBdTJ9Bfp6Wv8N878YSP89ruJ+cudRZoLCwexBIZ+Nv3Lhle6Km4SikROjJNWwxac3HbhIj7VfYMKT2Qrg0EjMIH1vDciijxgtF3TSpjtAE2+WrpDprGhSHCirDdhmzhfgoaEnZD+7WEZjQpZQ7QaCCJZEel6e9ZyPl48HbozTKh1Yru0DkPoLM/VBR4UuY5Un8NVSredINbg0/aq89up43rwtuStxwnuUhQyE7jRNszrEGu7VdXLd9lHRyOQ8VZQTGtBrWMIEN5XYvknc9tbiF4v16tOc02Jd4Pi2d8ssZALrY9QBRoLTP2lypZVwf20579p7x09YHzntlTak6ea0VHHMbJHE4pNtzJ1NgyEm+JLfpN49X5QAsV70nK1wAeO19c9FGgHWrkewIE9IbJDRPD6SXpDdzVVfXowl9PJPUWTzu8zz95S8HBl822YvEc2703xpeJapvFiz8ooToELpNEBFZXhJ9Ptus2U3TIblWvS+8HcXCIZSgl9/X8dJfq6aXqTHpANiBNpr6eU7TXT6iq7qTvvw8IH/
 1m2feG32
 pHSCF6ib+3P5Ou1Xex5qEveNYzogOS8d8KhAhq2A4t/tdkTjybjMh6DMYxqpC6djgPdkPFPh6H6LFaUyQCblUiYd3C0p7r0bf4Jd2hwNhri1mRdz9XyEkiyAOgTs9w8+JGws/iinDGbLWVT2Ue953eQvYmftaFvS2cEDoybPC7m0SKeSw4PjvRWyQbQvVQxCWp/PZzacRaaxIkNqbP88xjNfW9cbzoTRag22QfeYEt7WCVXA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 9/9/26 10:33 PM, David Hildenbrand (Arm) wrote:
>>> BTW, I was wondering what it would take to:
>>>
>>> 1) Turn mm/gup_test.o into an OOT module (would we need more EXPORT_SYMBOL_GPL?
>>> EXPORT_SYMBOL_FOOR_MODULE ?)
>>>
>>> 2) Move it to tools/mm/modules or sth like that.
>>>
>>> 3) Build it with the selftests etc
>>>
>>> 4) Remove GUP_TEST
>>>
>>> 5) Try insmod'ing it from the tools+selftests that need it.
>>
>> This is an interesting change. We can keep this open for discussion
>> here. If required, I can work on this in the future.
> 
> Yes, we should in general try moving all test modules out of the core.
> 
>>>
>>>> +int main(int argc, char **argv)
>>>> +{
>>>> +	char *file = "/dev/zero";
>>>> +	int fd;
>>>> +
>>>> +	fd = open(file, O_RDWR);
>>>> +	if (fd < 0) {
>>>> +		ksft_print_header();
>>>> +		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
>>>> +	}
>>>> +	close(fd);
>>>
>>>
>>> I'm confused. Why do we have to open+close /dev/zero?
>>
>> This is a pre requisite check. Every test opens and closes /dev/zero and
>> /sys/kernel/debug/gup_test of its own. So I wanted to check before
>> running the harness if these two are available, so that we don't have
>> setup failures for 60 test cases.
> 
> But why /dev/zero? We should understand why that would possibly be required.

This was carried over from the old test, where /dev/zero was the default
backing for mmap unless the user selected another file to back the
mapping. Now since we don't support file backed mappings, we can
directly use MAP_ANONYMOUS here. Thanks for pointing it out, I'll remove
it from this patch.

> 
>>
>>>
>>>> +
>>>> +	fd = open(GUP_TEST_FILE, O_RDWR);
>>>> +	if (fd == -1) {
>>>> +		ksft_print_header();
>>>> +		if (errno == EACCES)
>>>> +			ksft_exit_skip("Please run this test as root\n");
>>>
>>> Wouldn't we want to fail here?
>>
>> mm selftests normally skip if the test is not run as root. So I tried
>> keeping the same thing here. Do you think I should change it to fail?
> 
> If other tests do that, it's fine!
> 
> [...]
> 
>>>
>>> BTW, why are we using HUGETLB_TARGET_SIZE instead of just using the
>>> default_huge_page_size()?
>>
>> HUGETLB_TARGET_SIZE is the target mapping size and
>> default_huge_page_size() gives the size of a single hugetlb page.
>>
>> Using default_huge_page_size() would reduce coverage for 2MB hugetlb
>> pages. The old test set self->size to be 256 MB for the hugetlb case.
>>
>> Now it was discussed in a previous version of this patchset that we can
>> derive the self->size for hugetlb case by fixing the nr_hugepages and
>> multiplying by hugetlb size, and thought 128 would be a good number for
>> nr_hugepages [1].
>>
>> But in case the hugetlb pages are very large, eg we can have 1 GB
>> hugepages as well, reserving 128 GB is not a good idea. So I tried to
>> keep the target size of the mapping as 256 MB, as it was before in the
>> old gup test. If the hugetlb pages are larger than this, we'll reserve
>> only one of them. Else, we'll reserve (256 MB /
>> default_huge_page_size()) hugetlb pages, which comes out to be 128 for
>> the case of 2MB hugetlb pages.
> It's odd that 2M gets better test coverage than 512M or 1G.
> 
> Is there really a lot of value in testing 128 2M pages? Would, like, 2 already
> be good enough?

Yup, seems like keeping 128 pages is not adding an extra value. I'll go
with 2 hugetlb pages to test both pinning within a hugetlb page and
across the hugetlb boundary. This would make things a lot simpler.

