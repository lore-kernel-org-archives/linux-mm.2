Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AC51E606A329
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CPhiYY/V
Received: by kanga.kvack.org (Postfix)
	id A42F76B05BF; Tue, 17 Nov 2026 02:06:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F3616B05C0; Tue, 17 Nov 2026 02:06:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90B196B05C1; Tue, 17 Nov 2026 02:06:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64ED56B05BF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:57 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BCC59140319
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:56 +0000 (UTC)
X-FDA: 85443728832.14.85CFB64
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0AE06140007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="CPhiYY/V";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5lu26Bt2eDNFvp6cstc3Xl7/hEM7htfAhlohX2GmX/g=;
	b=yb2XKcqGBuuZTRFAHm6UIXvPB4LuxDsJMUmxSVeY3f/nz0kBYFoEKjbHO1rSr7D6SDzDtb
	NVj20r9wg2nYp9Fy1HqqnTYxJ7FlISBfV7DyNxCCxEUKUxBZlo0Rg+oyHcRJ5toUTEVyTA
	hnnIsAiO6bBXangM4VJe4P2p6MQgDk8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="CPhiYY/V";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899215;
	b=jhqE0QjTpDaug8cTAtSId8eY9bfr1zh4Qx0DIspEvHKT2y2CQwv44oNetywtO3G8zSEkWn
	QJjXV93VZHAMa1cvGL2RuLcIhsrSfR5bV932PJhnNiGN6ebgp6b58KSyQoe5MEAUXy+P5m
	unNjuRUCp99gIKvauJaZErGb9uY4klo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43C781682;
	Mon, 16 Nov 2026 23:06:51 -0800 (PST)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B6F7E3F763;
	Mon, 16 Nov 2026 23:06:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899214; bh=37zKrLpxA2dCRmPleyeQ7VCQicsitLgl6s35S11J8D4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CPhiYY/VeBxfA5FgTuKfVU3lDlJHHcJNrwLU0csIRCJUyg027aZZ0ieaS7USQoPS/
	 lQxkrCAi2Swy4jFEKg5BYpXH+U+hr7ZG7+7LG7yLhSfEnZ5COpEFM/pWVO8F7ycEaJ
	 BSjicGNIQOpuxcgKSXPhmZ8Q/DiYOsbGFTXsurUY=
Message-ID: <0fc496fa-8b5d-4067-a21e-c8dae707b95e@arm.com>
Date: Tue, 17 Nov 2026 12:36:46 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] selftests/mm: replace transhuge-stress with a THP
 compaction selftest
To: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>,
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
 <acbbc219-0b6a-4ec5-8047-af4b4b695212@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <acbbc219-0b6a-4ec5-8047-af4b4b695212@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0AE06140007
X-Rspam-User: 
X-Stat-Signature: mwr4rxzczzukcxjtnbhbdwceyki9i8h3
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794899214-686893
X-HE-Meta: U2FsdGVkX1/wrVQz8HWhcvExmE9cmrKuu84Egbfsy0ECneHR+pk9oGqrJcBmlXOQMOzx1C3n0ItnKEJRFlAAnTjQkz5Z6lEXl6kZI0jEcvcZ0Um6GfmN5LS00NluzRX/c8oUo/dXUrFH6qhY1/7ZIARZrOBBl9cIsBjhBZhPjOaGHWYeWfuCOPdmhAB5ynZcYchNO7WkFDiSUDdnzECyW89OvHX95qS4duSdJUmb9zZUa/f03YfFCeVtSyCTxcN/INF4Bx+Iq8XZD912eiRzO+R0jz2h6uZ1cTz9kh4G+zqI2GT6X34DpsZ+an1hzL23qvY4rfFrzh9B4TyDdtgorFJZMBCZ5L0YVBAiXSkx+oSLnMVa2wO1JwRzPRv6LLwpSyfUhSMdQNzhPB07S92PszmaIfwapMyssI7ZVHp73knnOTMsNm42CRjQARaKur5EZTqbdbDtX0j45IWLGZ3iwmDmMvH7KKyWABl/rAoODH1wu14XpjDdj2ykJ9OPbXFFWL4fO2WyO1TORGTI7xjFPn4h2K/9NSbsFEhBVOVIfRwtzr2jiJIRuHoFbnP6XNbB4QzY8f63AxHYiL92YKEteVjn01L86oPOxwWS5c20/fV9bP/3VbBRf6mI1GOe9LCb2+Fzju5yuN6cLenMSvM7CWy7Xu0Jg88lRgWBM/f72ebvD1jH7/T8KGx3X7unkF+gSJTxxNmtLUgNwmuGorqyACTglk9usINSZUBSOWSkcQntJ5kxQ1RDshI+KfzkEHfpw0UJjKoPTP1yyLuR6SmTwlGYyKpxNrAbCjMdX25iL0s04kutuWlT0sjay3iswW2TczzCLSwZVHzC2vwjDoEeILSlvg4INWiCXmxEnQhK4nryg3LbMfZiN054j9DNMI1QYp5ska0RcwIEVXy/gn6PYj9cPMMV5S3qIh2BMWo4gvmgvE+A1K+Lug9cW3KHRCdmn9KAnSzexMwTap4LGbE
 18EPcfZP
 n3gAeUS9hqsEyzb5jRf4tCTRwgdWPxRMSc3VgW6vjJv5/hvIgyR/BQ647rEs8KLLJ71+kCn4Ffxk1E2EHtsTezomkv96KLMDJIZix9KDlKUlp9SGEXE06hnVT3Z8NaAg3DSu3xCQ7HTpVj29/SERZw3UGkzhvGaYF9wIZQgr/PxjliBx5gsE7zQKAKSaYDF9L655hYQpeavto1XX8Ak9jyiJqPdzxfp6DWAGanD6Xn3/tWv9vjHeBeaVUBG8A3ghq2umX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Dev!

On 11/14/26 6:13 PM, Dev Jain wrote:
> 
> 
> On 12/11/26 2:32 pm, Sarthak Sharma wrote:
>> transhuge-stress is a stressor tool that repeatedly
>> allocates and splits THPs till a specified duration. If the
>> duration elapses, the test passes and fails only if a setup or
>> system call fails.
>>
>> This is not how a test residing in selftests/mm is supposed to
>> behave. So remove it and add a new functional test called
>> thp-compaction.c, that allocates THPs as much as it can,
>> splits those THPs keeping one page retained and discarding
>> others, and then retries allocating THPs, which will test
>> if THP compaction is working fine. If we are able to recover
>> more than half of the initial THPs, the test passes. Otherwise
>> it fails.
>>
>> This was suggested by David earlier [1].
>>
> 
> Isn't compaction_test.c already sort-of doing what you are trying to
> do here?

Yup, but compaction_test.c is for hugetlb pages. Maybe we can rename 
compaction_test.c to something like hugetlb_compaction or something for 
clarity.

> 
> 
>> Patch 1 removes the current transhuge-stress. Patch 2 adds a check to see
>> if PFNs are being masked due to no CAP_SYS_ADMIN in the initial user namespace.
>> Patch 3 factors out THP split helpers from split_huge_page_test.c to vm_util.c.
>> Patch 4 adds the
>> new test.
>>
>> [1] https://lore.kernel.org/all/94ace42d-8d60-4475-953e-74fb3dc23774@kernel.org/
>>
>> Sarthak Sharma (4):
>>    selftests/mm: remove transhuge-stress
>>    selftests/mm: detect masked PFNs in allocate_transhuge()
>>    selftests/mm: factor out THP split helpers
>>    selftests/mm: add a THP compaction selftest
>>
>>   MAINTAINERS                                   |   2 +-
>>   tools/testing/selftests/mm/Makefile           |   2 +-
>>   tools/testing/selftests/mm/ksm_tests.c        |  26 ++-
>>   tools/testing/selftests/mm/run_vmtests.sh     |   2 +-
>>   .../selftests/mm/split_huge_page_test.c       |  45 +---
>>   tools/testing/selftests/mm/thp-compaction.c   | 215 ++++++++++++++++++
>>   tools/testing/selftests/mm/transhuge-stress.c | 146 ------------
>>   tools/testing/selftests/mm/vm_util.c          |  65 ++++++
>>   tools/testing/selftests/mm/vm_util.h          |   6 +
>>   9 files changed, 313 insertions(+), 196 deletions(-)
>>   create mode 100644 tools/testing/selftests/mm/thp-compaction.c
>>   delete mode 100644 tools/testing/selftests/mm/transhuge-stress.c
>>
> 


