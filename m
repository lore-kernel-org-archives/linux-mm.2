Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EC68CCA46C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:51:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D17B6B011D; Mon, 19 Oct 2026 00:51:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45BA46B011E; Mon, 19 Oct 2026 00:51:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323256B011F; Mon, 19 Oct 2026 00:51:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC656B011D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:51:49 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DBDD405C8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:51:48 +0000 (UTC)
X-FDA: 85338153096.22.E0D5724
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6AC7820002
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:51:46 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iG9JOxw4;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792385506;
	b=rB/5xn7LAClm4GR4WO91Ex+XJwCWv+LOOyZ9FyCbFJDFVrYhLumaIl3la6ZcCE87bN2gJe
	yiEWjGFHuks6p3YKSkRDqRGvOiZ73o2oaQA+7VAKtdgXyY8DBTRKCcms0Jt327MDnPiPUo
	6hW9eOsm3Z8Z5rrvjaGzOWZ5ChC+tic=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iG9JOxw4;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792385506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9b2PR9KF0sMc6WkyedWjiZYS77RD8axd1cemRg7tAlM=;
	b=h7AhmT3KL6LeYttCCwaGi/RbVYfyoxqp1VP8WOPP8zSrM+Nmn22w+SSswI+s1aAqLlgxIk
	aVOPUagw5l3vBtDZZsNhhxp+VKp1SxtU6Ni3RLOZFkP/cha+fDpZ0i+e+oTCtcZftb94za
	qhCzlIvA8M6gVEvlqfV4RAk8H/Jfc/g=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 082BC1476;
	Sun, 18 Oct 2026 21:51:42 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FF973F673;
	Sun, 18 Oct 2026 21:51:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792385505; bh=5WEYiF0irBJpRs6F1IhKzRhrLDDCuuESsN66/V4Jl08=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iG9JOxw4rscU6r/UL82N8mypUm+ghnV4mG+JArN39f2sj4gp6w0JICTrXUnkJUUj7
	 88zLUmGtHEFeyM5Ki14JCXsPA+zOXuv7FY5DjyvGsesvrDrfNjbHLVgP6Lpc7HEQLY
	 YP+OUOlHmUsQ5qt6fgLmaB1/DJhAGbIRKi2XN3TA=
Message-ID: <db446de6-bd87-44b6-b9db-c4533ee047fa@arm.com>
Date: Mon, 19 Oct 2026 10:21:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] selftests/mm: check MADV_PAGEOUT file permissions
To: Gregory Price <gourry@gourry.net>
Cc: linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-8-gourry@gourry.net>
 <cba2a01d-630c-42d3-b6e4-b498f10c4b45@arm.com>
 <atImwW1ONQQ9Hv7p@gourry-fedora-PF4VCD3F>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <atImwW1ONQQ9Hv7p@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6AC7820002
X-Stat-Signature: jdgu1rcdpi7tc76y7yamd9aaxjtcrwny
X-Rspam-User: 
X-HE-Tag: 1792385506-683883
X-HE-Meta: U2FsdGVkX19hGe11m1QLplHirFg8GhQIUqAWortwft4OuD/+MGQQXEJ+1o8Nm1+xpwzsYjdqunTSgDlFaJkhnbkFTPc/Y8SJsbSkw0WPZsJOa7wo+CNxXAxwXUAr8Qpcpsn6IElZK5MZ3HjHnDyvb3jKLdFbz8HSOV0jpXVnSYGLHvBZ7dLi15TGwIOiLpZ7bsIlobRx8pSxBNEwVswScalbfWz59OPzznHIyBjeOpXTF41/OpzTvZmWOmrTsc2ir8pALG9BHIdcI42iZS2olPQo/pZ9I57gUsGv2AkSgKMB6YGfgNSCwMpzcQkKQKMBVUKigLdpajjolunhgFVYfq5n6hIZ0ZjddKJ7YuNKO9gyphfjblSxg0kQgKKChckGje4tiFdqdp48u9SQMza6WPsBNn3Yk4ww9SEiK82x8s9BRfSiFhFNrsqWzTTDc85w5uTb4oxPUOCmRnFz1yMNoSC9Fe5tiC1hhPr8V2qW6dUmBBSHagWbdOUYH/favaVg+OqIlxCi/ZQ7ZfVxTyeXSdi79fttLxrwX4uUGAL1enExYwoMRbEg4yx2dGWO/9jqXV5D1hryiLDxhefDV9BUgH76a3KNlHtr6z5v3EGkoX0xcv0nYx0BDkZZhXcEHu8nhchskzltP52c8rYiPYDioN4BDgRaNv+558OvJOA9omj6KKgtLWP5CYvPTzPya60H5uisYS6CQZjUFDkR5g2AuqZ+qN1qf+34n83uaF+aIMduG518+R7aQ1Ay74pn4GZwto/1tVkLkT2mXEGKevBEncu6Ml8sa1g8KeIMhFsuWRMpyjD3R3CJzQeXSGDUu8QCpmAAL8Yc7KB/uVgVUyRepizF3ERQRq83nTqoPsSF3ycIFWwB+6D5z/wsNmBro51o4FRnTVT5iEiblEpWnQ5V1AZVKES8c26MpZK1Qi7kpXsQKd1v4mTBPw7kq/aul2vcTAch2l4PTMvIcfKBSlh
 kHp5l6Ap
 XbLdEGVh+eDCDuvx8A5xmSh6MQPTRg1Yqw4nBvlOP+mUgRV3yQn3jowUSWbxggYDkoe0HE2CezU4JyKK3ULkLSIcjE181/kU+wzY9ldnSdftKTJazHmYEIs+92VzeZ7dPKmpuhFHyoutQex0RyAn8wjGv8vwWqkwo35FSw3fog4Hv3Wx3tHh6TY0zVsHBp0xvi5puEUlg9UQj4OEdF73O1yBC01rfLz+odKLWMLO16O4rfQVH/LB06WmdKszNN0OuRXs872phkLqzwy0/ko/DrJ3Cw2w3qds60rKv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/16/26 7:18 PM, Gregory Price wrote:
> On Fri, Oct 16, 2026 at 05:48:11PM +0530, Sarthak Sharma wrote:
>>> +/*
>>> + * The owner of a file may page out its clean page-cache pages. Run as an
>>> + * unprivileged owner, so that capabilities cannot stand in for ownership.
>>> + */
>>> +TEST_F(madvise, pageout_evicts_owned_file_page)
>>> +{
>>> +   char *mapping, *control;
>>> +
>>> +   if (!geteuid() && !drop_privileges())
>>> +      SKIP(return, "could not drop privileges");
>>> +   pin_to_current_cpu(_metadata);
>>
>> Is there a reason why we are pinning to the current CPU here and not in
>> the next two tests?
> 
> Oversight on my part.  I added it where i got a failure, but didn't
> carry it forward to the other tests.
> 
>>> +   ASSERT_EQ(mapping[0], 0);
>>> +   ASSERT_EQ(mapping[page_size], 0);
>>> +   mapping[0] = 1;
>>
>> If both pages are on CPU 1's per CPU LRU batch here and then hte task
>> migrates to CPU 2 here
>>
>>> +
>>> +   ASSERT_EQ(madvise(mapping, 2 * page_size, MADV_PAGEOUT), 0);
>>
>> Then this can cause lru_add_drain() on CPU 2, and therefore both pages
>> do not reach the main LRU list. Thus they won't be reclaimed and the
>> test can skip here since the CoW page wasn't swapped.
> 
> I think there are other corner cases here as well. So yes i'll set up
> thei pinning - probably worth it to just pin the entire suite of tests.

Yup, that would be better.

> 
> My original set had a bunch of this tested more explicitly, but this is
> really implementation details that are not worth the additional test
> complexity.  I think we can just rid ourselves of that and just pin
> every test and make sure it does what we expect in that case.
> 
>>
>>> +   ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd,
>>> +                mapping + page_size));
>>> +   swapped = pagemap_is_swapped(self->pagemap_fd, mapping);
>>> +   ASSERT_EQ(mapping[0], 1);
>>> +   ASSERT_EQ(mapping[page_size], 0);
>>> +   if (!swapped)
>>> +      SKIP(return, "MADV_PAGEOUT did not swap the COW page");
>>
>> Also, here we skip if we couldn't swap out the CoW page. Won't it make
>> more sense to check with pageout_until_swapped() first if pages can be
>> skipped, and then fail here if the CoW page wasn't skipped after all the
>> retries, similar to how some other tests implement it?
>>
> 
> Ah yeah good catch.  I'll adjust like this:
> 
>    /* Ensure pageout-swap actually works first with a control page */
>    control[0] = 1;
>    if (!pageout_until_swapped(_metadata, control, page_size,
>                               self->pagemap_fd))
>       SKIP(return, "MADV_PAGEOUT did not swap the control page");
> 
>    /* Run the actual test */
>    ASSERT_EQ(mapping[0], 0);  
>    ASSERT_EQ(mapping[page_size], 0);
>    mapping[0] = 1;
> 
>    ASSERT_TRUE(pageout_until_swapped(_metadata, mapping, 2 * page_size,
>                                      self->pagemap_fd));
>    ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd,
>                                     mapping + page_size));
>    ASSERT_EQ(mapping[0], 1);         
>    ASSERT_EQ(mapping[page_size], 0);

Yes, that looks good. Thanks!


