Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1283EC61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:05:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A6AA6B008A; Tue, 25 Aug 2026 05:05:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257F96B008C; Tue, 25 Aug 2026 05:05:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1469F6B0092; Tue, 25 Aug 2026 05:05:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E29A06B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:05:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D1FDAC0351
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:05:17 +0000 (UTC)
X-FDA: 85139207874.02.9D48DAA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id E068C4000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:05:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j4O/fy9I";
	spf=pass (imf12.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787648716;
	b=lrEvUBJ2Qm7J32mQNwIvpPc63b6CwLtvldTdO+VQ/6MOitS/htBhyLys1J9FRiu+ZZB8Li
	ZaFPR1KVLABWHs50OD1sycNFoTqIFAGINEY0yjB+kvaQjFa8IQgWNSRcGy3jdkx69Mj4CY
	gFYZ/4Z3aS/1OD1KxfDyXnV7b/HqWZ4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j4O/fy9I";
	spf=pass (imf12.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787648716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//wkWol9/qz5Sg8Qaccg3IRIcPlETPhBtTWYuUxnbF4=;
	b=r3mUTJyr9H5cxCrCznb0CaI1pk8nQjSJcVxbkgfIIOK2iVponCzfcJXUwR8u7XVxIAbZ1t
	pX/ZTPoPWzbaFb1TrOn/yF4fuc9lsrYUzDEXQO5MqUH8VLZynGejfQtOS2EzTHJvUIoqdl
	6g0XByi69u8+XMThLfePpEm2ULUgx6k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9C321D13;
	Tue, 25 Aug 2026 02:05:10 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46F1D3F66F;
	Tue, 25 Aug 2026 02:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1787648714; bh=VVA5b3Sxn3jAB87yPqIx2puxbJ9K3S8Qelt3HRI7aIQ=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=j4O/fy9I+ygjtNreY+klv5AoJtgbDvbBWTvWDbq1W3RKg4P7VH3WAlzSHP3c5jEYN
	 d8FrvNpaER9MQETbZk6BDkIIFoNCVlvNex+W4FBxTtEs3aqkAUhF5UHpnA5KGCeACh
	 zF575a7ktuq01hSAcHAz3fpywlSEFxovuUoSkoIo=
Message-ID: <2d81928a-3463-493f-bfa6-71869882489e@arm.com>
Date: Tue, 25 Aug 2026 10:05:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Subject: Re: [PATCH v7 1/6] selftests/mm: make file helpers return errors
To: Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-2-sarthak.sharma@arm.com>
From: Usama Anjum <usama.anjum@arm.com>
Content-Language: en-US
In-Reply-To: <20260813181230.483746-2-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E068C4000A
X-Stat-Signature: t48q11998ns1jztwupopf7oytgr6dait
X-HE-Tag: 1787648715-51382
X-HE-Meta: U2FsdGVkX1+Oe++UG1SjteaRoamPkYr4zKbefjEJcSbnLascuxocpPZ820OcX31LGgJHCpctK5xJ6MLrN6YZ/UXSEc8ZpS5K0DznwAIBwz4MniGf+8GkAgzgGuj2QZEr2T7swNHJKfwCPZaRWOfKt+vNOZ8MWbcDRFQhHOcYa3Uasjv9UwCrjoujBuOdwcwSI1xpXZcsvVlNvvibT1kxpcoFkegd/VpZ7uLISZdWKi1pe7pDcydsz01YXUbr4asmKR8GuS4b1bX9zcw1zr7TeeXOO9y2yX52mdtkRGsPFf1IgqHbugFvKM7BlfoDwCcwFk645l17jbi9cJflZoXOSfVHWnNN3rL+9L39je1yy4BbwunDQXFYupw6i6+B71AQ0uDavZd4x/h4g3qSRRlmnj++5/5oHV8xDxx6KZNeVVG9crg+CEIqQX2bCy/FTEiClA7kuOW33f3JOShUZB0GiXXGmmu12pzq+46P98XqlF+MWMF4mc5gGDrQopnANZyUG2ZJefAQXEr6HukoAmCHuty4DYoagMPLlwOY1QXy/id2IW4p3mbzWzUtjmRcKPoWU+Wi7DGpd670kcrrWa+oj2LFfVe/TIy/aSEMpXeW8/GUugbXLx6HQC4Kb58k9XJYB+yZbitWTmeLEtJF54WQBokBLTk1fRoykQcu99Hthay+AjXafCsYrW+cnaK6SfKbGO82Imk7Py0S3pQeJ24/3nR3DJReWiSZcGzPfGPTOYjaaL7T6REA/uTEjhFe1QJMswCR2jb166p0OAdsfFiGGSa0DRk2K2yXVdrvr5ND7l30UuXUrPQhJbEfqWJ4I7ocMb8tdGX6TjSiE2wvjdwrNxQgJ15yYhs7EPeZMmKdmAz3u22xHTIqFFEw3cuqmuoeJDfjl6S/Th4aWtl+8CJ5iYXFZk7HOKwlFPE8S0NWyDAcv3l/+rpekv47MtFJDpiQrs20oU+/6g3hgRcCGUK
 ifcl1pV/
 EmZC10t3XRYRlCnYj/PmTJmDACrKCByPaBYnBXjurKhdyWLpRBkfXEpCAKRlnqKyXTftWGeS4QN2R9g23uE5k5ngzx093+X7Kmp/z+B8LoLP6dLfodz7w6supJ8J0Y5PeFaBYCEpFo9q3y7BbIabnupDYCUQ0C29P8QSsynMiNbJfQOAu1NOBRRvLVgCn0XtIpATPqjgv5vE9SXF2QDc+2mWXibtJXkijKDrvuJz3fKDEljeDclraG8O4VKAjQkCMNmazHgvOLHNf3eqFR0nsezqiW5I4gj77u7HK9l/Hhgxht/8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13/08/2026 7:12 pm, Sarthak Sharma wrote:
> Change read_file(), write_file(), read_num(), write_num() and
> write_num_ignore_einval() in vm_util.c to report failures to callers
> instead of exiting from the helper.
> 
> Make read_file() return a negative errno on failure and 0 on success, so
> callers can distinguish a successful read from an I/O error. Also make
> read_num() reject negative and malformed values.
> 
> Keep write_num_ignore_einval() silent for -EINVAL while returning other
> errors to its caller.
> 
> Update callers to print diagnostics and fail wherever required. Also add
> a helper print_file_access_error() in hugepage_settings.c to print
> TAP-compatible errors without a kselftest dependency. This prepares the
> helpers to be moved to tools/lib/mm without a kselftest dependency.
> 
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
>  .../testing/selftests/mm/hugepage_settings.c  |  98 +++++++++++---
>  tools/testing/selftests/mm/khugepaged.c       |  14 +-
>  .../selftests/mm/split_huge_page_test.c       |   5 +-
>  tools/testing/selftests/mm/vm_util.c          | 120 ++++++++++++------
>  tools/testing/selftests/mm/vm_util.h          |   8 +-
>  5 files changed, 178 insertions(+), 67 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
> index d7917dce3aba..5bcda01ac4f6 100644
> --- a/tools/testing/selftests/mm/hugepage_settings.c
> +++ b/tools/testing/selftests/mm/hugepage_settings.c
> @@ -8,6 +8,7 @@
>  #include <stdlib.h>
>  #include <string.h>
>  #include <unistd.h>
> +#include <errno.h>
>  
>  #include "vm_util.h"
>  #include "hugepage_settings.h"
> @@ -48,6 +49,11 @@ static const char * const shmem_enabled_strings[] = {
>  	NULL
>  };
>  
> +static void print_file_access_error(const char *path, int ret)
> +{
> +	printf("# %s: %s (%d)\n", path, strerror(-ret), -ret);
ksft_print_msg() is what you want here. It adds # by default.

...

Thanks,
Usama


