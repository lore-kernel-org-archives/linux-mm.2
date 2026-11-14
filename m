Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFFB9606A880
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 12:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ii+NLzoq
Received: by kanga.kvack.org (Postfix)
	id DA3066B05B1; Sat, 14 Nov 2026 07:43:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2CCD6B05B2; Sat, 14 Nov 2026 07:43:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8166B05B3; Sat, 14 Nov 2026 07:43:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97C686B05B1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:43:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4EDDA0278
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:43:12 +0000 (UTC)
X-FDA: 85433689824.05.D8928F3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0F0C040007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 12:43:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ii+NLzoq;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794660191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLUYkZP6o3sE/c6t39+tiUT1HGJzvTdIPDTkJDNa1dk=;
	b=gwecoa2kO7Sr6lX3HncpLPvsuardZsLlj+HsG42yoPH8JcDwYiIFEB4a4OnlRCEwjncWWr
	dwA4Bir/YTQhhwo2J7ZjRVcq8m7N8nWMzJpcw69wfBodE6dGX20+WNyN0SZFhFAx4QFwYk
	2iVxgAHY0TCgBI7gAW8dOkkALk5emi4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794660191;
	b=nvpoRbSB8fBsdCJyTUCrdPOZuQqvGLLPtUdfyZrQ7AZbhuxxgso6WP1xiq2fi/mYUTiCvj
	NU2PtQIlZww87YHA1ScbV6WWbzjh6uXjyld+u5xr5L0pDK6cwa4d48xE5p5uY/0u9b1Hni
	k2ym4YsyAjphhtqL5f+npqNM1m6zb6M=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ii+NLzoq;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F0171516;
	Sat, 14 Nov 2026 04:43:07 -0800 (PST)
Received: from [10.163.159.227] (unknown [10.163.159.227])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 710D83F632;
	Sat, 14 Nov 2026 04:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794660190; bh=UwozEJCLQAVoo0F8fItA/0T+tAX/hvIaLGcjA9Tmh10=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ii+NLzoqD8TWzkMaJ2vfWwCsnMLk/rchkW0O6KzWRKMDiXNGOjgpdl7+w/qnG84kO
	 Irl9yb3tWZrzUFOcZ+3zjZeuZWkeaauZrDFVu+J1/en8ohB+gCiZCDOy10ir3R9IpY
	 SRBHhLHb9B1wMIU18DhxaC02Cu28LnoCGTSiweJc=
Message-ID: <acbbc219-0b6a-4ec5-8047-af4b4b695212@arm.com>
Date: Sat, 14 Nov 2026 18:13:00 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] selftests/mm: replace transhuge-stress with a THP
 compaction selftest
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261112090250.334344-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261112090250.334344-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: uhzsk9jxfiqhmffz8jmxgr9i9qnzyxqe
X-Rspamd-Queue-Id: 0F0C040007
X-Rspam-User: 
X-HE-Tag: 1794660190-914389
X-HE-Meta: U2FsdGVkX18V6G/bbz+pItBw4c3wbEBjPt48XeT+nJ89VyKiQwAOLc7HvXK8imrShTHSKL0oBdDa5FxP5oxDzsJ4LmkIj7bsWpB3qU7LSYtbhp+6EhuV8xQT7J4hYIqMqFMpvvth651BhiCEb/FQsMGWAP5vxMNwOg4j9rfM32fzpRYUHH5+EIp+iiPbX6Mfh1lc96VMSNI4dY+nLLnR5RgCyjwmfO/tv/rZluJJ0k+BLoU8MAeybF4nG/SkVojhKgTT9BliGRN5OK2inFV89c7DWs7F/e4QNRJg90dfI+oxqDnNJSlVai0eISuMtnNROPbD2rLpIkuAlzktslqf/JtXGgFs2A7BpG7l/hINbdUSZGUEf2EcFhUkCFw+4GGpfjQw7k+b7ecWROe1Q5wyg/O2lL4ZPU6jDan3w0NL/ltigAy4t8NG+y39sSm5sTAuXYm2Wglax944i9KjxpmozaQB/ZraOHtiysybXJPde1MR6tHd1mAFF2hMz12mZEwSi7E82IJUTEEjCPekzTutlnySlq9HPsaXeEkALZpm7tP8rkH1dUm1L/gO33LmPqeE9hYHyAPfnbPnpDW8adKNtn0KQjcgP5kfdFdEWbIDVhS7xcJEP0MjtG5kps+vTRhkyRWFoC7hmhOc26KUWl/QX5n4LHZoxFB21MCufx5JwY+4eIetJdQ2iRdmFC0dQqTlVRfyuaxoyA5fwtPwhJAw69A8SPpyvPkM5gtOf8qzy8bMFo/xC51fgyUGYrWVcqaAOq85qPZdjaIuqYeO0OypiSK4WbKUeaK7ofQAX+fktaa7nQ2eVm6N4tkkSH5T2XOtufNAA7wJQdgVkW8ahAopHZ7Ev6MVrPmLQpiQN0gc7XFJfAlwJkpQNMpDYO6WYAvfm2l0kREkXz1KRBtLN5TzwecFS67+t7AdDMb9KfyxhVMiNDdqS9L7e/bgKuWagzPf4rcajDTF73T+kwZHJM4
 YG9mMHUK
 8+neZL2Gbdv/K6H5d4HlTW8kpEqBY/yx7a5DS43+a6P/RfGpZ+Eyhe29Gj5yGLx6j8s2mndANEwTJmdoucu5H2qXw9MEIdSYzmlcwalZKmJWZqUhRs7Df2dkYDygzbkMwEPbxxUdrM5VapmRfu3Ycu7pZQCxaDuUjeuQQPV28M9U9uBcHN9LSzjVy9yuaLirtay71HU97d1FBTD/rpcc7GDMu5hKb0ECxi9Y52UFbLGsWV1PC9ZiiRBqqe1msgsY+kv9/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 12/11/26 2:32 pm, Sarthak Sharma wrote:
> transhuge-stress is a stressor tool that repeatedly
> allocates and splits THPs till a specified duration. If the
> duration elapses, the test passes and fails only if a setup or
> system call fails.
> 
> This is not how a test residing in selftests/mm is supposed to
> behave. So remove it and add a new functional test called
> thp-compaction.c, that allocates THPs as much as it can,
> splits those THPs keeping one page retained and discarding
> others, and then retries allocating THPs, which will test
> if THP compaction is working fine. If we are able to recover
> more than half of the initial THPs, the test passes. Otherwise
> it fails.
> 
> This was suggested by David earlier [1].
> 

Isn't compaction_test.c already sort-of doing what you are trying to
do here?


> Patch 1 removes the current transhuge-stress. Patch 2 adds a check to see
> if PFNs are being masked due to no CAP_SYS_ADMIN in the initial user namespace.
> Patch 3 factors out THP split helpers from split_huge_page_test.c to vm_util.c.
> Patch 4 adds the
> new test.
> 
> [1] https://lore.kernel.org/all/94ace42d-8d60-4475-953e-74fb3dc23774@kernel.org/
> 
> Sarthak Sharma (4):
>   selftests/mm: remove transhuge-stress
>   selftests/mm: detect masked PFNs in allocate_transhuge()
>   selftests/mm: factor out THP split helpers
>   selftests/mm: add a THP compaction selftest
> 
>  MAINTAINERS                                   |   2 +-
>  tools/testing/selftests/mm/Makefile           |   2 +-
>  tools/testing/selftests/mm/ksm_tests.c        |  26 ++-
>  tools/testing/selftests/mm/run_vmtests.sh     |   2 +-
>  .../selftests/mm/split_huge_page_test.c       |  45 +---
>  tools/testing/selftests/mm/thp-compaction.c   | 215 ++++++++++++++++++
>  tools/testing/selftests/mm/transhuge-stress.c | 146 ------------
>  tools/testing/selftests/mm/vm_util.c          |  65 ++++++
>  tools/testing/selftests/mm/vm_util.h          |   6 +
>  9 files changed, 313 insertions(+), 196 deletions(-)
>  create mode 100644 tools/testing/selftests/mm/thp-compaction.c
>  delete mode 100644 tools/testing/selftests/mm/transhuge-stress.c
> 


