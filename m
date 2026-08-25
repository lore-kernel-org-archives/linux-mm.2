Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252D3C5DF94
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 09:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9BF6B0088; Tue, 25 Aug 2026 05:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2645D6B0096; Tue, 25 Aug 2026 05:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 152896B0098; Tue, 25 Aug 2026 05:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D899D6B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 05:12:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A6191203C1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:12:23 +0000 (UTC)
X-FDA: 85139225766.27.B5337F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 819FC40002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:12:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwAeAWnt;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787649141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRKeXVgFI9gpHj5d1PdfWXdzukNPCSsx5hEFTj+qg00=;
	b=KczRqTffbkZFmyZjm3IfQ3XVNNe4CyGiv7Hm5f4x+74J8RuMsFBJa64h+qTz4MHAhOt0ow
	2je78SAbVmx8QBfhVSYNiYnflH9EOSIRM3tSEBd+0sWyer3tLFvBqt7maQeY+lZukDzbpS
	+dk0Sa95BOthhrIzw1IMMbHcPWCd5TE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cwAeAWnt;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787649141;
	b=lAJ0sR8L4SZ/uwu3mxfBVzvEbKkdU3SUBBSHmduG8fEL5jntlmBYvgGQY/NZoJ7kh+WwGn
	ejduYoRUw1/tOgLL5Ua747h9YBNPG9+7D/Ndk4deMGjZr2adshK20WzmxYdRv/yGHVDunz
	cIWfkmu37kgoUfluc08/TEAX75JBqds=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75BDC41B43;
	Tue, 25 Aug 2026 09:12:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647681F000E9;
	Tue, 25 Aug 2026 09:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787649140;
	bh=wRKeXVgFI9gpHj5d1PdfWXdzukNPCSsx5hEFTj+qg00=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=cwAeAWntEG4CSkXdakORQrZmDCaGBhA2yzBSXui1Jn+QpYsrVqRU4IK93rLQxeLEi
	 n5CAAP8MVGubNvAxoscmtT5mJY5mVT8gOKcs1Lbm7ks3C1DlA2cSsB7WhNaJ6aNEw9
	 fMvtZ28zcVhB8+wM3OstJTnTS7kMM+/3qnnIbFBnrlnvNACa3SZh+2P0MlxWpv0+c+
	 mC+tI2P9X8daW9JxY1vU1NS/SSDoLFp4okxMNLjDzcAnOh3spsc/1td1hp88Bb3jDN
	 DjszjD5QLFC4cxa7OIc/ul+mnqTp8zXLu27KN+ctXxx+1X+gJnkx9upe9tTCqrk1ar
	 oGS43jdW29CdA==
Message-ID: <a7789b90-8dc5-4a66-8c51-705cdfe9856e@kernel.org>
Date: Tue, 25 Aug 2026 11:12:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 1/6] selftests/mm: make file helpers return errors
To: Usama Anjum <usama.anjum@arm.com>, Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 Leon Romanovsky <leon@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20260813181230.483746-1-sarthak.sharma@arm.com>
 <20260813181230.483746-2-sarthak.sharma@arm.com>
 <2d81928a-3463-493f-bfa6-71869882489e@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <2d81928a-3463-493f-bfa6-71869882489e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 819FC40002
X-Stat-Signature: o75dw4h6ekkkhf5niw4t8b5xc5hdkn4w
X-Rspam-User: 
X-HE-Tag: 1787649141-399084
X-HE-Meta: U2FsdGVkX1860MISQ1RUi6VWvPMwmTEMNuhejvsVRcM5d1fEhYbwp3I+FAeDqnsmsnBQ6MN5jzh3Lx/1fci4S8NvDAfbb5ecJAZp7W+XMytKfh+PeKeM1krNCmc98SnEq4jStQx0Ec9hq0VQMWETYxBSbw/md/Bynzb38qG5AJLzUcww1dSWf3vQmNPAYtpA/siHHlTAQQs82RK7FH6PgVgdMAa8TfBs36iX1GsDhWl6PaQLwBKkGmdkeB1or7qynqYKcAEj8f+v6scUSISXdV13nlj+S31b4bApxtVWQWf0Kc3TLgMh9qCpYI0ukZ9XVDnB30PqYrAs6ZkhkkoH3k9Bw8u2T1rcIvvDWLdS3T/IWMN0ymK/IRNjwnstLcTPLr89TR5eH3/UaknYtI05K5SyFUQfQLBCHOgvPS/JwmhdbaELM2pxrldzRYDfAUqKQOliWMOLqRgMC94ay6NHl35Mq+2yea7eAxouORDIkrr1CjHv2bv8cB3eerOJn2sTwaX61nFqi/bR4NiqQhRdnd/iO4eyAjxVgDzXWpByOBsBsK//6e/8g827m+IkEoJ+VeCstAGb+9Cohhme06xdBGIfIk37/erPjZvo6cgsdBJrx7aJvXSkTVL+a1bhdNa13LSBBUkKh0T0DBirf33jIYW0nSoF1/3a4tRT4IBxX9NTjt7WcFwSqjO9ahOc/x5DJE0Krs9ZOoePFiyFkefSQ0fmsCIjR3gH/N1XDZSSBETVJ5dORBXluXYu/x9Bd/o5NsDCDYaxdkit+bn9oaSAk5adMdic8r06aOtusXUVxekVVHdj8yghuG0thhwVB7yiH3+Y2ox7YdtG08sYOuE2JNmP3ka778+PtPv/AgQebQaD6TBxDAfEk6K1iUHIFBeOn8/NxwzZMkf7ZRmC4v4SI4XlKJOa347OJKmQZNjrGVR5YH755ZRzb6ZVfFxunsHlsYH+58R0Du4GAc5Phdy
 96twexT0
 BOEJs7Nxe4vs01bA9ghu63Uo4qk5j3idrE03Q+0YUZ13UeslW7RsZfzCnQHiTHcpOSBj7Zq3iQxV3J5I1lUWZsPuihKSNno6cKzXDWuRwDj5izCddXhEjVXENwFosQgzBDCHBNjf+AqxjZEJde8t1m/q5asvjUb9OGqYJcqDkNXJ+f7p1Sk3EE3J5qFG7l0DS7S3UohCXyn839ii+ThrG6aV9J/7ml8EuuKtgvg6+dQ0pBJS+nwEVn4Jbm6np4XZY5YE8vryCTp1lAKAxxqR1f1z1DG/CgXp4uSOG2y1NVa5VN+tj7RfkhnTgC35eRatyVDPi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 11:05, Usama Anjum wrote:
> On 13/08/2026 7:12 pm, Sarthak Sharma wrote:
>> Change read_file(), write_file(), read_num(), write_num() and
>> write_num_ignore_einval() in vm_util.c to report failures to callers
>> instead of exiting from the helper.
>>
>> Make read_file() return a negative errno on failure and 0 on success, so
>> callers can distinguish a successful read from an I/O error. Also make
>> read_num() reject negative and malformed values.
>>
>> Keep write_num_ignore_einval() silent for -EINVAL while returning other
>> errors to its caller.
>>
>> Update callers to print diagnostics and fail wherever required. Also add
>> a helper print_file_access_error() in hugepage_settings.c to print
>> TAP-compatible errors without a kselftest dependency. This prepares the
>> helpers to be moved to tools/lib/mm without a kselftest dependency.
>>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  .../testing/selftests/mm/hugepage_settings.c  |  98 +++++++++++---
>>  tools/testing/selftests/mm/khugepaged.c       |  14 +-
>>  .../selftests/mm/split_huge_page_test.c       |   5 +-
>>  tools/testing/selftests/mm/vm_util.c          | 120 ++++++++++++------
>>  tools/testing/selftests/mm/vm_util.h          |   8 +-
>>  5 files changed, 178 insertions(+), 67 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
>> index d7917dce3aba..5bcda01ac4f6 100644
>> --- a/tools/testing/selftests/mm/hugepage_settings.c
>> +++ b/tools/testing/selftests/mm/hugepage_settings.c
>> @@ -8,6 +8,7 @@
>>  #include <stdlib.h>
>>  #include <string.h>
>>  #include <unistd.h>
>> +#include <errno.h>
>>  
>>  #include "vm_util.h"
>>  #include "hugepage_settings.h"
>> @@ -48,6 +49,11 @@ static const char * const shmem_enabled_strings[] = {
>>  	NULL
>>  };
>>  
>> +static void print_file_access_error(const char *path, int ret)
>> +{
>> +	printf("# %s: %s (%d)\n", path, strerror(-ret), -ret);
> ksft_print_msg() is what you want here. It adds # by default.

That code is getting moved out of tools/testing/selftests/mm in a later commit.

(see "This prepares the helpers to be moved to tools/lib/mm without a kselftest
dependency.") above.

-- 
Cheers,

David

