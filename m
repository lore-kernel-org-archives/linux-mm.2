Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47205FA0C38
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75EC86B0092; Wed, 15 Apr 2026 04:35:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 736766B0093; Wed, 15 Apr 2026 04:35:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674896B0095; Wed, 15 Apr 2026 04:35:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5687A6B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:35:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 07D59160408
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:35:19 +0000 (UTC)
X-FDA: 84660130758.23.12EA0C4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD7754000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:35:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ghv78G0w;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776242117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kao9rAwy1WwSrz1E69Dg314QlkhYtlMDsW0KIetomxk=;
	b=cSXokVoXsu+BtrN3JPBjMuT3gGM509Ft4UluA1pmT1pmJ579jBynxgHAUfbROZhVJTuBnK
	yvrg8k2mO8t1VCt3JskOd107PYkRCI8APqkIAfK+OdJjSLN6FhRDtvl99p3adND7acfhB5
	sIL+ofup93s3vfXAw2IBXTMKhmJslN4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ghv78G0w;
	spf=pass (imf11.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776242117; a=rsa-sha256;
	cv=none;
	b=7PMIEl3fKpGvhaBSMhxNzIt6lPpZfVME4Cu+LYFgU/xrW8KU9a9PQ03FZdno3KHL4kB50v
	EwUcFRV6yYMoueZrRs9QQJ32qx1vCJjmiaqIVXbQknOnwEAxs4iLQ88OaL7xBz15GnFFKZ
	o6boyojR8Vo59CnFx/l9OhKjr9o/G5A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0946D4FBA;
	Wed, 15 Apr 2026 01:35:10 -0700 (PDT)
Received: from [10.164.148.46] (MacBook-Pro.blr.arm.com [10.164.148.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D44233F86F;
	Wed, 15 Apr 2026 01:35:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776242115; bh=wqq1jxfb037jdTdgNzItw0yzIyAC7MxkmAXbXkvvQVo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ghv78G0w0VxXymddvIAQe/GYkOoBW2u+eNE+Z+KEpDpD0TeyUFyfrNwpeGdbDnTBu
	 P96PJ+u86gXFeE2pmbjUPnoZAJV9/JwiSXylZIEjYjyuxFAdsP7Y9BdE6yMi6YT4bV
	 OG+wbMatZn8FPMQ+/fnqx05q8vD6nsBaMpnWKojc=
Message-ID: <57b5d0f9-3e56-4f96-9e3a-2f475a78a8eb@arm.com>
Date: Wed, 15 Apr 2026 14:05:01 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260415044509.579428-1-dev.jain@arm.com>
 <2e34b619-085f-4a9c-bb41-bc024fd40dd7@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <2e34b619-085f-4a9c-bb41-bc024fd40dd7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BD7754000B
X-Stat-Signature: 9a4znhrpaj45zh41ps4e18ia5y739qh6
X-HE-Tag: 1776242116-377944
X-HE-Meta: U2FsdGVkX18V/soxaj8ZCtAd/3SIBl0aZHt4kmc73eWDks+Febf84nZ4JwFR14K/duJX4UgTLANftnJqCv2ZGmu+VfkmDrkNpe5rphi0FluMGEgXXmN7X3Znn31fsdVfA9YQsmLWhVhGAj3izDKXrJslGCcFaA60i9tQJHFhYGU84q9nRErbG+Fthb8Pw3OVlQHi20OHxjfE0TM0f59E69QFcTl3lQYhCugZjB7pldMjfKZW/aFzH697kO/WlVFRd8EnEJAAuwftvlCbZJCMjdOk5uRed49Pd4Rlm56s1QcyqECGLUZgufUTU/jyYBFJGz02z6a6EKb4ph3S4OapimNwNhP4dXzsu524yarqdVH7G8i33VYuLZn7Vhe44bL7F6GQq8syCdg+MMzw3Vhx8TqkVlA2rqHJEEiRvasst/2GWILDstleVRWbn5e2Hgo1uam5eI0uiCrxEcp2LyCVzfUnkpoOkRFBECsIQBOyvZbjEaam+MKj7MOg5dDVBxfTOSROeZevfDQMWqI3WbNaGmDgwitlOpS14VKsDm3BuO1p/PZp6uwYUrBNCrUgaNHb45eQR5mn3nHGjWImARGUrVZdY15PSk360/kz9bArPJtCUSiULbgcX0b+qdgMEgkz8dTC75Dq9Jpr+BvNW2yiDdS38oBx694JpoHk+jA691dEsxDt/ryFg3lkdxjAH0Vl8rl0fRbLr5cjBt6IyjB/3xrjK+u6MuqiU1WpqYzazijUiOBH/u0WPMsSFocd6Z2Qc/jQ3ye3KqPVOOwPBVTbpoc+lsBRmBlP7kBi9JncPKyhqAYA6MDBp1FiZohDY1aidEURbalYCPLG6rrqHja92AGFJHDTbnPzQiExoYQvTkXHGdheYqJJcGGMI+7Ji6i+BOvQIxX0h1fkSIXwnP9EzfnO4oKay6+Gnh/BlpxOJSDqSlPERMUU76t4e7dcqP4a0RiH3G3QMiHfOjKuoYg
 J5h8upCz
 GxwS8GqiuhyyTZN6lykLBYCPJ+brBDUJ/mbYPUWxpyHWZAb6QGihCKquN7nN2YJS+9/LCpuTaKYJQ0JFmtJr4UQVJJdqu4hK6xq8hbcKTEqMChV/vkZC1Qfy4q+zYrH6xO+HQO0FN3yu9zt7brz7ORcNAsGRvuNdjIbp2y7NJHBslewMlhYxgAd3gvgW8WtdkIotHXLrxkOdz4qu7xY1tL8lsri74FV6Pmma4oX++kHGZUxznjiKTVAxrJoptQg+Ikq2Pbu101UnRiFWYI9a4UrxbpPNvViC6B6Zlr9FNH7sQWNfaXzCp1ZM+dN6UlbGyR2XJ2xfQ6pbnmgfPWCwX2cw29A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/04/26 1:18 pm, David Hildenbrand (Arm) wrote:
> On 4/15/26 06:45, Dev Jain wrote:
>> The original version of mremap_test (7df666253f26: "kselftests: vm: add
>> mremap tests") validated remapped contents byte-by-byte and printed a
>> mismatch index in case the bytes streams didn't match. That was rather
>> inefficient, especially also if the test passed.
>>
>> Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
>> execution time from minutes to seconds using chunkwise memcmp") used
>> memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
>> the problematic index only if it discovered a problem.
>>
>> However, the implementation is overly complicated (e.g., get_sqrt() is
>> currently not optimal) and we don't really have to report the exact
>> index: whoever debugs the failing test can figure that out.
>>
>> Let's simplify by just comparing both byte streams with memcmp() and not
>> detecting the exact failed index.
>>
>> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>> ---
> 
> I'll note something interesting: before 7033c6cc9620, we would check
> random bytes in the stream. With 7033c6cc9620 we only check the first
> threshold bytes IIUC.

Before 7033c6cc9620, the block of code was:

	/* Verify byte pattern after remapping */
	srand(pattern_seed);
	for (t = 0; t < threshold; t++) {
		char c = (char) rand();

		if (((char *) dest_addr)[t] != c) {
			ksft_print_msg("Data after remap doesn't match at offset %llu\n",
				       t);
			ksft_print_msg("Expected: %#x\t Got: %#x\n", c & 0xff,
					((char *) dest_addr)[t] & 0xff);
			ret = -1;
			goto clean_up_dest;
		}
	}

which is still checking the first threshold bytes only. Note that
pattern_seed remains constant at runtime, so 7033c6cc9620 just replaces
this with a buffer filled with the rand() stream.

> 
> That means, that we are not actually verifying most of the area at all
> anymore?
> 
> 
> The whole test options are extremely questionable:
> 
> $ ./mremap_test --help
> ./mremap_test: invalid option -- '-'
> Usage: ./mremap_test [[-t <threshold_mb>] [-p <pattern_seed>]]
> -t       only validate threshold_mb of the remapped region
>          if 0 is supplied no threshold is used; all tests
>          are run and remapped regions validated fully.
>          The default threshold used is 4MB.
> -p       provide a seed to generate the random pattern for
>          validating the remapped region.
> 
> Nobody will ever set these parameters, really. And tests that test
> different things each time they are run are not particularly helpful.
> 
> We should just remove all that and do something reasonable internally.
> 
> That is
> 
> a) Remove all the perf crap (ehm sorry, "advanced tests that don't
>    belong here and that nobody ever runs") from this functional test

Hmm... perhaps this is useful, we can keep this by default so we can
detect if a bug comes up in PMD/PUD mremap? If the test takes too long
we know we have messed up something there. Although "test taking too
long" is not a nice way to know that there is a bug ...

and test won't even take long perhaps since memcmp on 1G will be fairly
fast. In case we mess up PMD/PUD mremap real bug reports will come sooner
than anyone detecting this from mremap_test.

So I'll remove this.

> 
> b) Remove all options from the test. Nobody ever uses them. They are
>    stupid.

Agreed.

> 
> c) Remove any randomization from the test. There is no need for random
>    patterns, just fill pages with increasing numbers.

Agreed.

> 
> d) Just always verify the whole regions. Without the rand() magic this
>    will probably be just ... fairly fast?

Yeah we are doing a simple memcmp() so it is fine.

I'll implement these changes.

> 


