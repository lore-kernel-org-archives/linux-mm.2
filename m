Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF17CA9ED1
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 04:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1F3A6B0088; Mon, 12 Oct 2026 00:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCFF66B008A; Mon, 12 Oct 2026 00:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE56B6B008C; Mon, 12 Oct 2026 00:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0A36B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 00:50:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 78D451C4371
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:50:55 +0000 (UTC)
X-FDA: 85312749270.02.5839334
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4ACFF1C0002
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 04:50:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AYXMvyrK;
	spf=pass (imf21.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791780653;
	b=oqM8pAeXaKqJkQFp6+6Pq11R/a1LCNHicFs6tlYbL568DCO0VsxNmNdMPi37EnwOmSRAoI
	BpzyrwYzXVtvX3LiomkcILkilQ1Q8yTsCzBWUrTS/qYqzceYhorAVbYtTOyMQzIVkVV576
	QJ1UQbon5xVBfbqvgeuj7ktdy1pTJPY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=AYXMvyrK;
	spf=pass (imf21.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791780653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1Q3fm5JYej9AjqUufcPPGBasZqd7x2tArUNDPhsC9F4=;
	b=pfMzltjsgbvye4XMizklHPzMjk0EozGZ5NyS6qkurhAhF7z++QoBSa5wHh5IipS3P6y2SY
	vEfNm2Vyd/hJw7HT73KuTOFBq3AsHNGlnspcaOWYo8VmL/ExFe1NmbnENv9qgSBfzcAcpY
	dSPwKmLZMIEbkP9uqNoYGTnFq9jbjyM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA7EB1655;
	Sun, 11 Oct 2026 21:50:48 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DA163F66F;
	Sun, 11 Oct 2026 21:50:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791780652; bh=FEORMkWV+LnpnKU8/SJTAtz/HqigUBNwPx9HlqlR0bI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AYXMvyrKhr5Zj0P28YCOLqmo8ytyuBDkbpk3gtbZAtI6nU4R10S+rUjM508pvVH6N
	 seUQ6f5BOKSHaKAoiv5viWr0ulK+vKgbebp09HDBYPg8Gagv6FBLoZ8oA1p8c+sqXy
	 9Qp55iOsUA9A8u1ubIds4WOMmRIjmVNEmRzi0l1c=
Message-ID: <3a0673a6-744b-45a1-80fd-737a366fafc4@arm.com>
Date: Mon, 12 Oct 2026 10:20:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 00/12] selftests/mm: improve mremap_test
To: akpm@linux-foundation.org, david@kernel.org
Cc: ljs@kernel.org, liam@infradead.org, vbabka@suse.com, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, shuah@kernel.org, jhubbard@nvidia.com,
 kaleshsingh@google.com, anshuman.khandual@arm.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261006092511.145776-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261006092511.145776-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4ACFF1C0002
X-Rspam-User: 
X-Stat-Signature: bcmagoqfa459guxbrjiwzck57q8hhmnf
X-HE-Tag: 1791780653-678032
X-HE-Meta: U2FsdGVkX1+XAAINpg2KjjKs6lYAjaSiqWYK2qDZhHo8iltK2PwRrtl8heKqwnnrROwW2eTbbDTzwyhbqbiuI9rHRdjbrH/uRwlBkFhVV8JOrZguanjGArFXpS54LtcFUCP8PtZ8HGfD0X1A6Fwg+0VMnoqYukuLgv3KO5t9CQd+10RluP2+TmfeQj39bk9bXVCmx8Cgpy4j8pTCWhh8oPbQW8f55U9g3UMNZJxcKGRwMbSG6jMmelibcyRFZZn9MCDr8XK6IX9PLhApSL1HeolIOxiVxwyKZNmmeOaPtR13NE8/gY3mno0sHvj8+SnNkZ5kW+G4rJCG7KlWRkoBf+gLT24SF01KYQIGVITPqwNVuMF7TzB4TnItwARnv48UFWPtSUT6UZNUQnB/xBmCSnW4olFP+7UZJs6t9EhADqsAkTWmBfVxyr/zMclSip56HTUzdRfBJb1H4ovPCtltBXM/u0Sf1ay/O4MBihvqLYOXnuCbZ2JBrA8tuwSyAvjRiElXKUyBjryYYisQZn3rDM24ExvZKh17HVNmVci7rU4hfldj5YhlVCwy8wo0Yj29ZI18TlJ2QszBRlidP2TTo6NPrGWctOd0zgny8OAdkISSs9bh5uGRl90LNUVr/GZNQTEtFGnx3raMg/ODien1B7lWz1crmtNqhiJBDVkOLV2fyHqTQVyUqB9/+DuryvtzBerjBmvXKwsCKZHHw0IgbfQU7v5UWl+l87MfXP/z7d7/k2uTmA/5RH7ma/QOR35u2QcVYhG0IFhullX6lz8GiUT+QuxGIkPfBW/C/EFosyEYF8/Us8TI/DU46Ni0CaCg34JJWdgIYU+8CQxjaHS+TuQpCXlz6bjTtZeyRB62bPFQm0CbaS24dDgl2HcR54YXh6dK+Q+iXUI05Jloyjll6MoyxWuDa+LWyZLhXjSO6trnI7LTNBsOqzxLwLYkpwMI2rLyk9I2B6XHI+ohRQl
 YHljbxi3
 D8RyVcUccdRf5aaMUOSgOs9QwnedmigH3mFJGRa+NWrJhdZFu/M+2EJdsCUzSx/ic+oMzdbrBy8mn+tDTGo7e9c5J2fnA9Q7jNvgtdhnqFg3uPtsXhn64x9zLtVX8YBRQakGd2q32/rVJqlj46JKciy/6p7U1/yUV5x0HX32L2ZGvSy8trDLfwBRa34+2kN+wggmxBreXbNkx1BjPJ8Y6tG61wmrviIHTFln5g3Hr3s2W+oyIpALkGNfJAdVTpjSKtDJgJp1vfNUF7DF8k/FQZa3HR/F2brZQyQcDMBj8hcP3X5TYGn6UhPViNLaJXUZ9kjqJ5MAoM0LmgvNlLvxeJVJ8tsyT/lKys6AD2rAVh4o7DuxMRDnJnNL0WkTUfgaj7iqJg7E5bIGmMjqcLh0F1h2nb0P7/Nh3XsCWcqq5bNNPaDg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/6/26 2:54 PM, Sarthak Sharma wrote:
> This series fixes correctness issues in mremap_test, simplifies its
> test infrastructure and strengthens validation of remapped mappings.
> 
> Patches 1-3 remove unused command line handling, unnecessary cleanup
> checks and redundant errno handling. Patch 4 converts the test to use
> kselftest helpers and removes manual failure tracking.
> 
> Patches 5-8 fix handling of unavailable userfaultfd support, unexpected
> mremap() successes, data-corruption failures and cleanup after mmap()
> failures. Patch 9 removes perf tests and timing infrastructure.
> 
> Patches 10 and 11 replace threshold-based random-data validation with
> sampled validation and a deterministic data pattern. Patch 12
> strengthens multi VMA validation by also checking the mapping state
> of holes after remapping.

[...]

> ---
> Sarthak Sharma (12):
>   selftests/mm: mremap_test: remove command line options
>   selftests/mm: mremap_test: drop munmap() checks from cleanup paths
>   selftests/mm: mremap_test: simplify errno handling
>   selftests/mm: mremap_test: use kselftest helpers
>   selftests/mm: mremap_test: skip test when userfaultfd is unavailable
>   selftests/mm: mremap_test: fail unexpected mremap successes
>   selftests/mm: mremap_test: fail on data corruption
>   selftests/mm: mremap_test: handle cleanup after mmap failures
>   selftests/mm: mremap_test: remove perf tests and timing
>   selftests/mm: mremap_test: replace validation threshold with sampled
>     checks
>   selftests/mm: mremap_test: replace random data with deterministic
>     pattern
>   selftests/mm: mremap_test: strengthen multi VMA validation
> 
>  tools/testing/selftests/mm/mremap_test.c | 701 ++++++++++-------------
>  1 file changed, 291 insertions(+), 410 deletions(-)
> 

I wanted to address the concern Sashiko has over this patch series [1].
It says that mremap(..., MAP_FIXED) over a range containing multiple
VMAs should unmap the whole range first and then map the VMAs.

But this is not the case, as was discussed on the list earlier as well.
We iterate over the VMAs in the range and only unmap and then map the
region that the VMAs occupy. IOW, as quoted by Lorenzo [2], "the
sematics are such that gaps are not propagated (i.e. it is as if you
mremap()'d each individually)". So if we remap over an existing mapping,
the mapping region on which a hole is remapped should not be affected at
all. So this is a false positive.

While here, requesting for some feedback on this series, if anyone has
had a chance to look at it :).

[1]
https://sashiko.dev/#/patchset/20261006092511.145776-1-sarthak.sharma%40arm.com

[2] https://lore.kernel.org/linux-mm/agH1ZSdX_7QF8P_I@lucifer/


