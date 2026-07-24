Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0055C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 11:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E42586B008A; Fri, 24 Jul 2026 07:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3396B008C; Fri, 24 Jul 2026 07:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE4DF6B0092; Fri, 24 Jul 2026 07:46:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A37086B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 07:46:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1980B16034E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:46:59 +0000 (UTC)
X-FDA: 85023493758.21.692FC09
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7F871100009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:46:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pvXRp5bk;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784893617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ru3rrWvMYi1AWyNrj0oS41aDmbGe1xbIC7iXqG16q0=;
	b=Jz2XrPNiEzAvkGQIFoJKNQvaHRKzqa6Fu+yZZqmloJFsToUbnGjS3Q7gIDNNaXluOj4UK3
	DE1n/hFrgUXDHkZtj7Tkgoi9t6lnjiTcGzt1VDPznq6OefoJGkvbaFuADAxk4uMRXcyBEb
	rQIXR1AFkjTho2xa759rRzGVyqMBCgc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784893617;
	b=XjnhVI36sAIt28kb5pw4Em0YYZpgj9ua1aZun0eJLasFxs8tF9VfgUiT2MIXSOiSWI7QBL
	V5vtUzuStPJJHCFYDyW3kdeUgolU6NSALYHVK0zAyxK+kcJQrriSOV5nFFoV2MAXz6X/Q9
	6mVzSp9UmtMTG24Sk1p19dxsW70M1Bk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=pvXRp5bk;
	spf=pass (imf05.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4C1551477;
	Fri, 24 Jul 2026 04:46:50 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 862AC3F59E;
	Fri, 24 Jul 2026 04:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784893614; bh=pevkwXY6/+oZfqQlj9LQ9x6fIBIFzqxqXzMJxYGU0B8=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=pvXRp5bkiBA24zMTHT+OrGNmHWP/oqFZdHIxUWVQ6fY+pYnh22FioXInDtKWDAbyY
	 reOMYS7ciZR5IRc9/9bauW85kJ6+1pAGOkikkethsTyAhzaZ6ktpLQwo9E1o7C5T00
	 qJux4yfg6wZSrsqkhqtuLEtyv9tFLmLISaRZ8FI4=
Message-ID: <15111e85-4143-476a-830e-9f7d47cc236e@arm.com>
Date: Fri, 24 Jul 2026 17:16:45 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] selftests/mm: retry migration failures for the
 full runtime
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 sarthak.sharma@arm.com
References: <20260724102431.1199519-1-usama.anjum@arm.com>
 <20260724102431.1199519-6-usama.anjum@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260724102431.1199519-6-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7F871100009
X-Stat-Signature: wwr76sp67a9r4p41b6r7eg85x6ryac9d
X-Rspam-User: 
X-HE-Tag: 1784893616-913348
X-HE-Meta: U2FsdGVkX19ZHkAXm2aElfAcOHqTVxoRVUZ1KQp3wnNwhLG2+0EqEhmekNzHkpujIBu//q8T28mr3j0eOyXkkgJNbDZi8zvt33p2gOEu1mB3RBR5VzyyRERBjEdC6LY4oJ9u7PT6gruIcjxLclVg55MKGjT0h8DpV9OYngwCsyRrHTWdYQYig9zauW1NXGNOmQ9LjZmS2/mh0V/wxB+XTI8Lev9LxOmLejjzTQoveKo4TJXmJBoOWiIkHl5y4/ymN8AC2lvibW02WBaJRYNGi3dLSeJ5aNU14lDUONwFDSz8ReTqocaDdMsDY4F9StFz8iAlnNwcqXiL3/CT1OWvvANpKM8ZhBGZBqbDuRi8lNU/Og/GiOVUBrH5KBWWmWtgc5VP/0h4RwnFh8jhg4EtYwrhIK5le1nG2nTA3BX7G9ZS5L5xtAqtSOu+w3IkIgXNrcTY35O6sn772mtkRH2yaQWBPTR/EMbjXCTT8mbsKy4Ujjy3+j/caKbra+mmBzF8GA6vZDgsegEM/0xtg55kZPTtcrCW8bYFRCexgSBZnKAIjmPNwxU+uV3s4jg0NU3GXo0Y7Ig/YQ08v1ZG3Q+IBLdmtHc/6nFUqf+X/Pj0PQCpO3oDez9+xMEpNycTHHPP4c1MvT07bN09ILmu7COC1Q1bNMG+E6HKLBnlNLedDWi4OSVaAGd/BxW3F1mTlWs6Yd+dBiAY45FhE2SsnZfRzxEbTo1l3unJw7K5okGL0DzLm0E4GU9QBEe8GqpDNs8Iov1Ym4kIUjc16wFlzZ7jhjyaQuPpAcBqj9QgDVsDroP7qsypdAQ8eglYVFCLbuVtm+QHDTNXBFBEIEoshiDk6ZOVUzzWzMQKdwiUk9+sst3w971P1IOYeaUOuKdiiwBa9RGsvbS8gIJwJtcPH9nku90Ydbvzn227M3A+yBX1mmZAISl+SJ/6ub54xB2T2SdVNBc1En366HWN7ICkJja
 4G9Gzncs
 QxrrhNJrWyyFY8+fncA+ZljdhZixRw5RSmkd5uwlmcDl8yZRRLr0+dXRwGR3vKOaTnVPLFKaB6wVvYKgSHTC3F0WpEv1lilSYvB3g6S6qOtHK4uoTJ1J7R/WqDoQZaHFb0yuYWwFgzaTyFoD0iqw6V0xmdUynPUxQZsEbwzgV6fW9K5NWb54p1lyG4nCIm0Xd6X1owkeYuRdwybJ5ucUh+G2nVSiRpSLq0FPvzmY5+BguyTy02N62RSqS+dk+nxvw0hedLAGz7d1thMFx3Cv0y4LKBT3l3/wRo7fMVFkOyLPQK0Pq9fqZPRIzd2SADSFrefL7yr28fFaRbsMa9E5nRz4mCKvDHZIOAq8nvbQQazw01tKYQsAHVHRoqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/26 3:54 pm, Muhammad Usama Anjum wrote:
> move_pages() is best effort and can temporarily fail when concurrent
> faults race with page unmapping. A busy shared-anon workload can exhaust
> the current 100 retries long before the intended 20-second runtime and
> produce a false failure.
> 
> Use the full runtime as the retry window. Since the initial page location
> is unknown, require it to reach both alternating NUMA targets to confirm
> that cross-node migration made progress despite transient contention.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---

Makes sense, but see below.


> Changes since v1:
> - Retry per-page failures for the full runtime
> - Verify that both alternating NUMA targets are reached
> ---
>  tools/testing/selftests/mm/migration.c | 39 ++++++++++++++------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
> index 29f7492453d43..4d55a424058a9 100644
> --- a/tools/testing/selftests/mm/migration.c
> +++ b/tools/testing/selftests/mm/migration.c
> @@ -7,7 +7,7 @@
>  #include "kselftest_harness.h"
>  #include "hugepage_settings.h"
>  
> -#include <strings.h>
> +#include <string.h>
>  #include <pthread.h>
>  #include <numa.h>
>  #include <numaif.h>
> @@ -20,7 +20,6 @@
>  
>  #define TWOMEG		(2<<20)
>  #define RUNTIME		(20)
> -#define MAX_RETRIES	100
>  #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
>  
>  HUGETLB_SETUP_DEFAULT_PAGES(1)
> @@ -110,7 +109,7 @@ int migrate(uint64_t *ptr, int n1, int n2)
>  	int ret, tmp;
>  	int status = 0;
>  	struct timespec ts1, ts2;
> -	int failures = 0;
> +	int success = 0;
>  
>  	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
>  		return -1;
> @@ -119,29 +118,33 @@ int migrate(uint64_t *ptr, int n1, int n2)
>  		if (clock_gettime(CLOCK_MONOTONIC, &ts2))
>  			return -1;
>  
> -		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME)
> -			return 0;
> +		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME) {
> +			/* Reaching both targets verifies a cross-node move. */
> +			if (success >= 2)
> +				return 0;
> +			else
> +				return -2;
> +		}
>  
>  		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
>  				MPOL_MF_MOVE_ALL);
> -		if (ret) {
> -			if (ret > 0) {
> -				/* Migration is best effort; try again */
> -				if (++failures < MAX_RETRIES)
> -					continue;
> -				printf("Didn't migrate %d pages\n", ret);
> -			}
> -			else
> -				perror("Couldn't migrate pages");
> -			return -2;
> +		if (ret < 0) {
> +			perror("Couldn't migrate pages");
> +			return ret;
>  		}
> -		failures = 0;
> +		/* Migration is best effort. Try again */
> +		if (ret > 0 || status < 0)

old code wasn't using status, so why now?

> +			continue;
> +		if (status != n2) {
> +			printf("Page is on node %d instead of target node %d\n",
> +			       status, n2);
> +			return status;
> +		}
> +		success++;
>  		tmp = n2;
>  		n2 = n1;
>  		n1 = tmp;
>  	}
> -
> -	return 0;
>  }
>  
>  void *access_mem(void *ptr)


