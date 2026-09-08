Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C571C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 05:56:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 642456B008A; Tue,  8 Sep 2026 01:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F2986B008C; Tue,  8 Sep 2026 01:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 508D66B0092; Tue,  8 Sep 2026 01:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 225876B008A
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:56:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7B1CC03AC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:56:32 +0000 (UTC)
X-FDA: 85189535424.23.19F0E70
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id C517E1C0002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:56:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LQfxyU3G;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788846991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ArlPOUciAu0NaRxeTiL/N1bM2SL1B47wDPGIMJE/C6E=;
	b=MA5pt9MxCIizJ9DASdv3BEoFcUOhXfs+j6okRSW1s3DMBM9Nnyph4KhBWW8bgBIraXkQP3
	sNpVUf8DIguyriyPqYQSJpvFXpIIux9EP00N1m1ARaHXXqIfqiLNP3OhNcVGOc8w0JN952
	cICeH29zJYtJu2nLs88ViqObIr5V6HM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788846991;
	b=u4ggyVx5ObgQL8jkslUgKd9JPlzp+hvjf8pMJ10QQg6XfMu916nwI66gMOSVLnOCqtevCR
	wEpSHA0n3B8OrrL9ewe4iAeo5jRdSVq9S5c3ivKAtf6diuMVDc9y95qoQO2TH+fP5WM0ny
	ddUDszWqzcY2H9bMtJR4zcLffQsL1dg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LQfxyU3G;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3797C1476;
	Mon,  7 Sep 2026 22:56:26 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5CA43F86C;
	Mon,  7 Sep 2026 22:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788846989; bh=sOMZfPSSdTLgfz3hBoUNe6ytFxzY7bCG8cECAo6gYNw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LQfxyU3GO+oro+24KrwqJMvyeWaO8TlfaE7lFJ2A4gY5+v1rxELR+J40yu2uH8l9o
	 /0Zco3/HVf9IsN0KEncrt8Zd8afwYgrX/5YPDmALdrC8oKYnPczHvzVlC1Y73PNHHe
	 pr7B26aAMm/GeInAJJemqJ96LuoWLYgHy7cBfX0c=
Message-ID: <5e0b9365-cbac-4f2d-b915-85edf3093508@arm.com>
Date: Tue, 8 Sep 2026 11:26:19 +0530
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
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <b0400430-c3b6-40d5-b476-49189b1cc292@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uxjar9x6wzkj9cskdiddat1h1qa34tb6
X-Rspamd-Queue-Id: C517E1C0002
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788846990-262752
X-HE-Meta: U2FsdGVkX18TaTbLEpFeD/V0XF5Oy0nCtbV1MrqPdky/lYRmoIwJImUnmaFXCwcR6KbTp1pHpsC2GOCSmxanYsyq7yW00/McL2dGzFL759GK+4FOxSasqCxlSSgTWW9b4RIz6FF16ICeIuXy7Tj+cd74h+tYxpWdKXEx/vbxZG2hOjXgdP47O66Qk6PO0yY8VxwYuY/K8mWWZNxmiMfr4kG0slSbuefMHO2tK8e5ozuA25Gj0O+R0ZiY+6S6KK9kGq5TjJGb1zlHOEl+6oXI4DZFg166DgdStS60el/+hX/1r/eBWoWi56VUmGbJScq4gR7SaSu9V80h1wjUeuHmUBXGvnziDYrdmkuTK5BIwRXgbS9pvMbKMqSP0OUYiCtKH2G5Ef4I8XG/Gp7lQs4s3k0lfPFzrhxQfgBiUmKKNRKdhMXM47+3mgcG/677WbzuI9ZPl1fqpPtW2yTTwxenQv6D3F11zwoGyC6nuhwuZl2l6nYfVSPFHsIWJ9y89gt8edDrrC0YHSSJArQI55pJeckrbMDmb7hs1Vod1LsJHSnTWuQfoCJzAG2y3OGTfGD7JlhouUQBxSxO/u+fcs9P/J9UXyw++GesFQUX8FIWrIGVaTGNYpwwEvLk0fjhmzGJRHJtHsM3TDuCK9WFK9s7Ybx/uREMISzE5ZlIqrFq7TpOSw0tAjVzcn5fu0GMov9Po37/TShO6yFcXWgf98r+RxbuRkwajD72Yw0t1KsEb+USz2zVtmvWJeh0Ynsdue2nbwj4EiVBo/NReJOBhJBea4C1n8JnQ3R+P5iGpKbzUPhjytOqQ9ukF7W/JzvoxaTnG8QZdhzaiJZ5S8p+Hsi3T2GPwrjhJHZByOrwqYd3xR8F3wQYKSyxBAWqAytdMqyI9iTHLMfyUVD8drcvsALALBegYhiUkT6twC6rxuJ3SkcjH1P6OFiX4BMg3FKvCICH92Aif8n/MSMSToEZwUk
 9X51rwL7
 o1mdmVRwTXCnW8Bhj/VnZ1qr4R+eFCLUR8Cujx2kDdvNHhrDmGyUbrtJLApMx5Fx96skh/yzyE1vfMS+yBjOj1rW3mB5Iso0YiCEUPKk2UtjyA03x5vcPv690DRU7fs/Vef5q3GpLt1/qcQstznM/HQhlVm8lXfWUd2RLYymT6DjR9mHp3EQvi15FShWe4u8iAaOLB6jOcJ0oYZra0jGOV6M4BE7WbFvZpQ7Gk/XLuecJtpFInZJdgL0qbfuzJx/rlSA0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 9/7/26 8:45 PM, David Hildenbrand (Arm) wrote:
> On 9/4/26 14:36, Sarthak Sharma wrote:
>> Add a new GUP selftest which uses kselftest_harness.h. Cover
>> 12 mapping configurations: THP enabled, THP disabled and
>> HugeTLB, each across private/shared mappings and with/without
>> FOLL_WRITE. Run 5 test cases for every variant: get_user_pages,
>> get_user_pages_fast, pin_user_pages, pin_user_pages_fast and
>> pin_user_pages_longterm.
>>
>> Choose the number of default hugeTLB pages using a 256 MiB target,
>> with a minimum of 1 page and derive the mapping size from that
>> number. This avoids reserving excess memory when the hugeTLB page
>> size is too large and retains 128 pages for the most common case
>> of 2MiB hugeTLB pages.
>>
>> Sweep four nr_pages_per_call values for each test: 1, 512, 123 and
>> all pages. This preserves the coverage previously provided by
>> run_gup_matrix(): 12 mapping combinations x 5 GUP/PUP operations x 4
>> batch sizes. In total the selftest reports 60 TAP cases and issues
>> 240 ioctls.

[...]

> 
> 
> BTW, I was wondering what it would take to:
> 
> 1) Turn mm/gup_test.o into an OOT module (would we need more EXPORT_SYMBOL_GPL?
> EXPORT_SYMBOL_FOOR_MODULE ?)
> 
> 2) Move it to tools/mm/modules or sth like that.
> 
> 3) Build it with the selftests etc
> 
> 4) Remove GUP_TEST
> 
> 5) Try insmod'ing it from the tools+selftests that need it.

This is an interesting change. We can keep this open for discussion
here. If required, I can work on this in the future.

> 
> [...]
> 
>> +int main(int argc, char **argv)
>> +{
>> +	char *file = "/dev/zero";
>> +	int fd;
>> +
>> +	fd = open(file, O_RDWR);
>> +	if (fd < 0) {
>> +		ksft_print_header();
>> +		ksft_exit_fail_msg("Unable to open %s: %s\n", file, strerror(errno));
>> +	}
>> +	close(fd);
> 
> 
> I'm confused. Why do we have to open+close /dev/zero?

This is a pre requisite check. Every test opens and closes /dev/zero and
/sys/kernel/debug/gup_test of its own. So I wanted to check before
running the harness if these two are available, so that we don't have
setup failures for 60 test cases.

> 
>> +
>> +	fd = open(GUP_TEST_FILE, O_RDWR);
>> +	if (fd == -1) {
>> +		ksft_print_header();
>> +		if (errno == EACCES)
>> +			ksft_exit_skip("Please run this test as root\n");
> 
> Wouldn't we want to fail here?

mm selftests normally skip if the test is not run as root. So I tried
keeping the same thing here. Do you think I should change it to fail?

> 
>> +		if (errno == ENOENT) {
>> +			DIR *debugfs = opendir("/sys/kernel/debug");
>> +
>> +			if (!debugfs) {
>> +				ksft_exit_skip("Mount debugfs at /sys/kernel/debug\n");
>> +			} else {
>> +				closedir(debugfs);
>> +				ksft_exit_skip("Check CONFIG_GUP_TEST in kernel config\n");
>> +			}
> 
> You can remove the } else { part as you skip on !debugfs.

Agreed

> 
>> +		}
>> +		ksft_exit_fail_msg("Failed to open %s: %s\n", GUP_TEST_FILE, strerror(errno));
>> +	}
>> +	close(fd);
>> +
>> +	hp_size = default_huge_page_size();
>> +	if (hp_size) {
>> +		nr_huge_pages = HUGETLB_TARGET_SIZE / hp_size;
>> +		if (!nr_huge_pages)
>> +			nr_huge_pages = 1;
>> +
>> +		hugetlb_setup_succeeded = hugetlb_setup_default(nr_huge_pages);
>> +	}
> 
> BTW, why are we using HUGETLB_TARGET_SIZE instead of just using the
> default_huge_page_size()?

HUGETLB_TARGET_SIZE is the target mapping size and
default_huge_page_size() gives the size of a single hugetlb page.

Using default_huge_page_size() would reduce coverage for 2MB hugetlb
pages. The old test set self->size to be 256 MB for the hugetlb case.

Now it was discussed in a previous version of this patchset that we can
derive the self->size for hugetlb case by fixing the nr_hugepages and
multiplying by hugetlb size, and thought 128 would be a good number for
nr_hugepages [1].

But in case the hugetlb pages are very large, eg we can have 1 GB
hugepages as well, reserving 128 GB is not a good idea. So I tried to
keep the target size of the mapping as 256 MB, as it was before in the
old gup test. If the hugetlb pages are larger than this, we'll reserve
only one of them. Else, we'll reserve (256 MB /
default_huge_page_size()) hugetlb pages, which comes out to be 128 for
the case of 2MB hugetlb pages.

[1] https://lore.kernel.org/all/anGyXt_PDImUglIN@kernel.org/

> 
>> +
>> +	return test_harness_run(argc, argv);
>> +}
>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>> index 8f1e828e4f39..ae0ab5efabae 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -251,6 +251,7 @@ fi
>>  
>>  CATEGORY="mmap" run_test ./map_fixed_noreplace
>>  
>> +CATEGORY="gup_test" run_test ./gup
>>  CATEGORY="gup_test" run_test ./gup_longterm
> 
> Nice

:)

> 


