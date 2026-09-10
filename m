Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14ED7C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068816B0093; Thu, 10 Sep 2026 02:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EDD6B0095; Thu, 10 Sep 2026 02:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF5C6B0096; Thu, 10 Sep 2026 02:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C91E06B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:08:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9360A045E
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:08:12 +0000 (UTC)
X-FDA: 85196822424.22.9BC5C7A
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4712520004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:08:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YZMnar3d;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789020488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jePTnUgwFYrx1QtqJ0i+l+Bh+bnpi4s/zBah6ITg4fg=;
	b=AcRbYw24Qyojd/+i/mSur7PWzRvM+lUGg+cuLjWCsGyWhjVDqfu6p+0puJLfkplIAvv8BQ
	OM02DNlUatFO4jwJ9C+H8CyvOdsn8fd3Duw7Tb4QKO4bh4oylAQp9qoolkcB0QSTu1NzfH
	4OeyLJGRbqekMWX8SNyPtuvYHf+dIkI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789020488;
	b=VJsr8vs6wDh9ywj7imQlrNYsaCf8exA2v+yv+aXTO8vDARLL44vK5A8jrDyGQbMq95vmra
	Kk2uSflcBnIcO6XU5Ie4L+5QoUq/mCxxAWKDlNloqTVYBIHFWbuT2NdbpGk+k7LA6K9SB1
	CLoXYXn/LsNN58mXAnMWWJMUbVjSue0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=YZMnar3d;
	spf=pass (imf31.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789020482; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=jePTnUgwFYrx1QtqJ0i+l+Bh+bnpi4s/zBah6ITg4fg=;
	b=YZMnar3d5DizmJ6qAxdhzYbWDOqKPyd4eS3OOtnzII1xrmnzkye/IpUOqot11CqH8h6UQ6nxzCIOiCpgW0blHlHwKRJtdj26wHCqSy/aiZI3VKEERbbRtbNUQUPX/IdJlh5K1+Io9wFnwvLwzjP8dB/nmcKlmEPBq3HQ4sVbCO4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R711e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0XAgdFcD_1789020480;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAgdFcD_1789020480 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 10 Sep 2026 14:08:01 +0800
Message-ID: <e611ca08-1952-457d-ba45-8c8854020a74@linux.alibaba.com>
Date: Thu, 10 Sep 2026 14:07:59 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 14/19] selftests/mm: run every supported collapse order
 by default
To: Kiryl Shutsemau <kirill@shutemov.name>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, rppt@kernel.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, usama.anjum@arm.com, usama.arif@linux.dev,
 nico.pache@linux.dev, ziy@nvidia.com, baohua@kernel.org, dev.jain@arm.com,
 hughd@google.com, lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com,
 ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com,
 vbabka@kernel.org, agordeev@linux.ibm.com, jgg@ziepe.ca, leon@kernel.org,
 kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20260908125105.1510704-1-kirill@shutemov.name>
 <20260908125105.1510704-15-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260908125105.1510704-15-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4712520004
X-Stat-Signature: 9rxkqdg583ozz9uxcsrbsaebodjh3p4a
X-Rspam-User: 
X-HE-Tag: 1789020486-874656
X-HE-Meta: U2FsdGVkX19RTOCz8AaYjhZPA5lJGAaniXcHTvPIokXwiL/VtEqL590auccJZnR1CnOTPU2Xfq6ARU8XFCpdMZYc0Dr10624wuT86rz8hAipLIsBszgsR/YGodRn9mqLLMRdAhLuAeShPUCVrbfe6m+SFtimVbAm9EV0FXowa4r/e//4cIo5Mh9rcYsoMmNjY8WJndPr7XdDyfiAYPn4VPBVmKYhz+MV5rzbp6lvzv0CNoTXFuXxm8h3PW40MOyuGW7VT3drS9dpEKp9mLfBO2x43ZynzH1F1KymxQKXkkym8aWn7Rh326tLFco4kaLIWWA5nc1unEZfbzb0UNluTvjg2TOzqEaN4SA1GzE8jgWOri4AxF13dB6VSnduPijUdzBiqvnJi0XdgRGeL8p6dKUfoFSYVJVgVb0otsmUsEQwKL1RLziCpHXiM8IbW3Hg4L4ECXBlhNHLxlUnq7UqdE1cHyS2HQnpuUenuKf9Do3KX3kprSxQxVmfoPOAwKgIrp5KdfVWyN6LUTeYhVqb9SDwout5X437JxsP62nVH58iPoabQLXGCEWDZPy5mmVerW8zwT0aIkfznmije+F06PV6YqwN+CdhiH2I1sXEqkwqPoqnJyjRptOIMx/Rw8SJ0rFB8SAGb6SYCiji1O3aIzBbj0CecdwE8ImAlfmadPQ8f7Gs/YeU5/oFqOgJhEnL06Vd0kuKflQVQwFIVvLis1pzf1NW3/i0J52LJ0DY3WoyslvLz6VOF1c5BvPxA6KM4tiRL+7I9ac9Hpb15qS4vgLv9rA8oxm98R65JR3JbgfQcz8ERSBXDxQRM1NP7BBpbAZ0QYs1lj2OivTeeaWD09vQdwH2GYZ7wL7a+i/chatpxECm1btravvhce6m1leACCSjWVigrjQ5LefDl9dilaZjsK9KUcKZOXhZh+IA5xja0b2E/X3EY7sSiA/2ExxOXFF/0jylc1rhDwad6mw
 RRaRGwCO
 rF92FAWNwhfUNG0/CNzr5EI0k5iwd/q74Ezl5G8S1bRmgqm9CA2bzuQHHSglCFyx/gXceAFGlPXLqSLtIyigUAvhwecbO3mMaPCnKKWVckOC9h2Q/xpMUHKUCbKQf/tgVLTBwpqpR99ndE5RKtN2Wd21uxJQv70ttneZy3+B7YFQnWBiekc8YwkRWzJL0CjCQGXFD+cJZjDnG1QpjLWe3tyLMqc7WmJ7QW1Cd3bY5q7q50moE6TzXnoW4i3v94oHxVdwLbzojTF8wG6shqdIkgmz9zLdn33ltttZ2TSi8KtwAgh9oq2ft65HbI/E0sLcWMLq4J404cYfi81aZ73DY01SQvd8wOleNvEE28DITgRY7tg3IPRHl8EM7DeMW6gDp0nHD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 8:51 PM, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> The mTHP collapse cases only run when the caller names both the context
> and an order, so a plain ./khugepaged covers the PMD contexts on anon and
> nothing else.  run_vmtests.sh pinned order 4 and covered no other.
> 
> Run the mTHP cases once per supported anon THP order below the PMD when
> -c is absent, and pull that context into both the no-argument invocation
> and "all".  Also:
> 
>    - -c still pins one order, and now says what is wrong instead of
>      printing the usage text.  An order at or below the -s source order is
>      skipped: the sources would already be the size being asked for.
> 
>    - Both orders end up as array indices and shift counts, so -s and -c
>      are range-checked before they get there.
> 
>    - The mTHP context has only anon cases, so a run that names a different
>      mem_type -- "all:shmem", say -- drops it again rather than refusing
>      to start.  Naming both explicitly still refuses.
> 
>    - A case carries the order it was registered at, so a result names it:
> 
>        # Run test: collapse_single_mthp (mthp_khugepaged:anon, order 6)
> 
> On x86-64 with 4K pages that is orders 2 through 8, and ./khugepaged goes
> from 29 results in 17 seconds to 77 in 29, so run_vmtests.sh can drop its
> pinned order-4 line.
> 
> Assisted-by: LLM
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>

