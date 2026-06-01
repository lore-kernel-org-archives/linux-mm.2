Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C19D2CD6E4C
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 08:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35EFE6B02C5; Mon,  1 Jun 2026 04:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3106C6B02C7; Mon,  1 Jun 2026 04:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24E1F6B02C8; Mon,  1 Jun 2026 04:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 14E826B02C5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 04:35:12 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B81EB1A05BD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:35:11 +0000 (UTC)
X-FDA: 84830684022.13.89D8F61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C713180005
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 08:35:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VuqXDHST;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780302910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9lDbQeKLavZFIEOh/CkUOUIvMQqnzPuvTdfWQRXAjQY=;
	b=RaYkI2gQ6FEDuW8wUpRX0+t4Vg8h4Y5XXuVyguxZ5DtElxVgp4lD6QtLs/k+8RQ8oZV4Pg
	dvBtptKexT28a9uiMMNSAZPoinU4SEAb/qdOs3A3F/I5Cmmu8o9IcrnLgXSEBFDMQG5OL9
	VyncV9NmH1zMzsLI4ra7pyW8bp/mQSM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VuqXDHST;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780302910; a=rsa-sha256;
	cv=none;
	b=l3+Hm8qJk8G+nadgZPGXhA4+WdOype8EwpdWutVfKWO4UWEzMg/qsho+bS5ntpikjfl0uZ
	hegw5yY0W+ZAECN2IlL2RATWmXmGJosqQuLehkOZJpimkCaF9C3pAJl4fu87j8gd/Am0HH
	H5V6GMA7qpQLCZj5z6EYyzMAHTcvBSE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CABB60098;
	Mon,  1 Jun 2026 08:35:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6C01F00893;
	Mon,  1 Jun 2026 08:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780302909;
	bh=9lDbQeKLavZFIEOh/CkUOUIvMQqnzPuvTdfWQRXAjQY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VuqXDHSTvMpQFKI7KSl1aqVO8mINRprGN9VK5lUG2VU8Ww3vKfBDSmWFtvv6k21sD
	 TaxevY6IVRKCqJsGi7U3D+UvH2idaNRUj6mqc9Uq/x/vnnJEhntZNT8CEOSe/NjDrd
	 0tbukliX6py74YT/0bsXvRAcipY7vwFycxesA4iNJRMPcxH3WIAcWrXO4J3xnWJOvK
	 5nJFQpjt7ankRRWAyAVnYgK4xCpXkHH15zu1sqCAwWrClnvu88KdV0qyZDKNdwq+b7
	 ms3vkIZD2ZEX4qo2drY08GUi6G9clbW7rHWN3mTok83U3ARC9Lfthrv2DVl2ZfhHlK
	 iVcOSRuSLzvDw==
Date: Mon, 1 Jun 2026 09:35:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Balbir Singh <balbirs@nvidia.com>, akpm@linux-foundation.org, 
	liam@infradead.org, jgg@ziepe.ca, leon@kernel.org, david@kernel.org, 
	shuah@kernel.org, vbabka@kernel.org, jannh@google.com, pfalcato@suse.de, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-kselftest@vger.kernel.org, usama.arif@linux.dev, ryan.roberts@arm.com, 
	anshuman.khandual@arm.com
Subject: Re: [PATCH v2 2/2] selftests/mm/hmm-tests: test pagemap reads of PMD
 device-private entries
Message-ID: <ah1EI_JfZYop7VF8@lucifer>
References: <20260530085413.1270139-1-dev.jain@arm.com>
 <20260530085413.1270139-3-dev.jain@arm.com>
 <9d8bffb5-bb07-4cde-8a20-8b9b9996f8cf@nvidia.com>
 <7750de96-44c6-47b0-b0a9-dd948fca2e90@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7750de96-44c6-47b0-b0a9-dd948fca2e90@arm.com>
X-Stat-Signature: nz5tg9sqbayzap99ncs7is8jjjpsk46u
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2C713180005
X-Rspam-User: 
X-HE-Tag: 1780302910-901113
X-HE-Meta: U2FsdGVkX18Gbax4/qlSDK6u6vnR4Vs41L0b3/IsdgRjOpuKo79RrxTrLDFGr/0bK96v9tbnjXPhT5AqzfEBer+tPgh06A3At58UYqhqslK4M5O9MKI1oi6R7TZMjm/CJHh6aDQr/opW0Bn8eZPuYtBtifQEiK3CArj/DJLVpj3bAvqljHNvLo7+V7QzC6Dzgk8Lj4mJ81f4md/ghAGtNrf0P1RSTj4V7v22gZ5F2xbGjIlzaz99euuwEkWQxafq0bjYxw635Jyj1dqFDqHHjzLM0MmcVk4fAR5h3Ju9w4vpveXS/hYxIS61u1t4q1kUanKjrCWwDiprh713V7Sf7QHRwBNAT21Lmwg6gMcPPKxMiEQ4Wmyc/WImjwTp4kajUzpHt3TI8+lp9pHkcMUR/ntTfuMmNSZWgHSLIakf0EcTzYhbzMtmDX0osOQfL7idXX33vJ7rala8PhWq28KTECT++rxKVvSxTUHoBXmlgK4QdAsKq4NfJOKL67d5NmZBAYY4ilfZStVGBmAp2QNtQpyfggDMjUnkRYKkrTd4iG64sDMgJ2pXGhEtBaWZDOIJy8jzCUUxXtfIqDo5VCMnvyE45nwvxgraJTEMDuSYm64eJFc+UB8hSJqP4m5MvJNdg1uG6cCEpLM6adxuD5vF1myVfDQclSmA5REuUPdcK02ffkqXTlQhYD5pM/e/cBi4xxOISYsccyWhYOS/pa9loUvxUsHRlA6SD2WL82NPzC+Th0/JSZB62RSKn5iztiMvoeYli1W6fIajMrn5DWhndooHUE9gNY7c2c8RBi+hqaoz44zrJLwLLFe8ERC3ddbFJV+5zJON+shEeKntSbaR9bdWvnS/opm7Clc18P7AXpG/gU10TR0U2f4V5yMBTfkpQcl2AHuS/XQZBZZ6yRrGCQZzRJaVS4aM8xSTUenaE2diOnOnSOaO2tNhqbjoEqtH2oxKI/kVIQ4wpfuwg2M
 LHR7NsOL
 kUtz3lxMP9xRqJ623PWsVvlqSkX7Aw2mTaXKQMnERXCS01Gy7LjTZg5BSw/iTSqNxhz3DOWVDzH+FRTdzWaQAwvVQUjRy1HKSs+YAIvNNpc2lN0BRcdRld7FC/LXqI4bbfEErkcfb8IX0JTjUQ4oZMHZKxzoTJzUYjpMlgtAeG74uIHr6yOYMr0whQ3gWkt61KuwyUFGjkboJ5oNr6zQcc1BoqCZ8kjeku0hsy6mPlqhC2hVLINPn2t+sxFQ4U1HFIsNnpzlzVsAszjAyC/y1WDgtIkQEvynkrj9QtVOzfdpBuhsjJD4mIz70DKspfedAlatGvEtxrMBrcnuVeZpHofnmCb37S1vIjA/H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 10:40:48AM +0530, Dev Jain wrote:
>
>
> On 01/06/26 5:39 am, Balbir Singh wrote:
> > On 5/30/26 18:54, Dev Jain wrote:
> >> To cover pagemap paths scanning PMD entries, add assertions to check
> >> whether a device-private PMD entry has the correct pagemap information -
> >> the PM_SWAP bit must be on in the pagemap entry. Before that, we must
> >> assert through HMM_DMIRROR_SNAPSHOT snapshot that the leaf entry is
> >> at PMD level and not PTE level.
> >>
> >> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >> ---
> >>  tools/testing/selftests/mm/hmm-tests.c | 29 ++++++++++++++++++++++++++
> >>  1 file changed, 29 insertions(+)
> >>
> >> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> >> index e1c8a679a4cf3..d09d4a9081de1 100644
> >> --- a/tools/testing/selftests/mm/hmm-tests.c
> >> +++ b/tools/testing/selftests/mm/hmm-tests.c
> >> @@ -2276,8 +2276,11 @@ TEST_F(hmm, migrate_anon_huge_fault)
> >>  	unsigned long npages;
> >>  	unsigned long size;
> >>  	unsigned long i;
> >> +	unsigned char *m;
> >> +	uint64_t entry;
> >>  	void *old_ptr;
> >>  	void *map;
> >> +	int pagemap_fd;
> >>  	int *ptr;
> >>  	int ret;
> >>
> >> @@ -2318,6 +2321,32 @@ TEST_F(hmm, migrate_anon_huge_fault)
> >>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
> >>  		ASSERT_EQ(ptr[i], i);
> >>
> >> +	if (!hmm_is_coherent_type(variant->device_number)) {
> >> +		ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT,
> >> +				      buffer, npages);
> >> +		ASSERT_EQ(ret, 0);
> >> +		ASSERT_EQ(buffer->cpages, npages);
> >> +
> >> +		m = buffer->mirror;
> >> +		for (i = 0; i < npages; ++i)
> >> +			ASSERT_EQ(m[i], HMM_DMIRROR_PROT_DEV_PRIVATE_LOCAL |
> >> +					HMM_DMIRROR_PROT_WRITE |
> >> +					HMM_DMIRROR_PROT_PMD);
> >
> > madvise(..., MADV_HUGEPAGE) is not sufficient to guarantee that the allocation
> > was indeed converted to THP. Might be worth using the kpageflags interface (but that
> > requires elevated privileges) and then KPF_THP? Otherwise the HMM_DMIRROR_PROT_PMD
> > can be a miss from time to time. One other option is not to assert, but to check
> > and inform?
>
> I'll then use the existing check_huge_anon() to assert that a PMD THP got allocated.

Would MADV_COLLAPSE work here?

>
> >
> >> +
> >> +		pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
> >> +		ASSERT_GE(pagemap_fd, 0);
> >> +
> >> +		for (i = 0; i < npages; ++i) {
> >> +			entry = pagemap_get_entry(pagemap_fd,
> >> +					(char *)buffer->ptr + i * self->page_size);
> >> +
> >
> > If this is a THP entry, do we have valid pagemap entries for offset of i * page_size?
>
> Yep we do, see the populate_pagemap label in pagemap_pmd_range_thp.
>
> >
> >> +			ASSERT_NE(entry & PM_SWAP, 0);
> >> +			ASSERT_EQ(entry & PM_PRESENT, 0);
> >
> > Nit: You can use PAGEMAP_PRESENT()
>
> Okay.
>
> >
> >> +		}
> >> +
> >> +		close(pagemap_fd);
> >> +	}
> >> +
> >>  	/* Fault pages back to system memory and check them. */
> >>  	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
> >>  		ASSERT_EQ(ptr[i], i);
> >
> > Balbir Singh
>

Cheers, Lorenzo

