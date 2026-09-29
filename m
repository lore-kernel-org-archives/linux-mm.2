Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FCEACA5FAE
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5887C6B0098; Tue, 29 Sep 2026 04:43:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53A256B009E; Tue, 29 Sep 2026 04:43:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 477526B00A0; Tue, 29 Sep 2026 04:43:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21DF86B0098
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:43:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D5FC1A042A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:43:48 +0000 (UTC)
X-FDA: 85266161736.08.3686E93
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf04.hostedemail.com (Postfix) with ESMTP id 47A704000D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:43:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="TRgo/oq3";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guDeg6QqGfbRrydExIA2ThsV8UFr57TVsH4IDbNkF3k=;
	b=uW8fxNGhWO0U6UAwvuQ7GKSoSRV0B0HYOl8V5b266wFo6/iUsQANnwR1B8FpnGDsUpjndK
	Wqe7sNCkdhSJNotZJh8nnZN+ppg6Bu8myWxgzVtnrgMx2ONo3iJxrF03oTFqvaCF947Mxp
	kc19obGHhdYCfbz3RGbjIoZf4KULiBI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="TRgo/oq3";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671426;
	b=TR+osIhDVdwD4Or/hpOug1x84K8wJxvvVmeEmI3w3xfdQA15BZoxbISoGDsWHk7xlZDcO/
	cKC1HA+5KFs4cOb1TSrnHBnS/7UT1Q55E6sF+pj+79EHOyPBoODecQ94twmOY4URyQbxNY
	jtIjc/oBytsmTJL2PGwtN4yQndSoBDY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790671422; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=guDeg6QqGfbRrydExIA2ThsV8UFr57TVsH4IDbNkF3k=;
	b=TRgo/oq3+qjF7Tmm0JWbZwdwF9SzGmI/5c0iAVtP/B7V1NKx77zZDPqbEZOOIT3uZfX30zN4EHYkGp7PhlzwcVbArePldwHz1UbjSSl1oSXSYUSg2iT/TXRiVoaDfcnGFxTmFRMNpzTL8QPi7QjbKE7gf0EsoBNtz5Mn310rC7g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XBscwvt_1790671420;
Received: from 30.74.144.142(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBscwvt_1790671420 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 29 Sep 2026 16:43:41 +0800
Message-ID: <84d3a9f5-4bfb-4f5e-86ad-ac8fb896d885@linux.alibaba.com>
Date: Tue, 29 Sep 2026 16:43:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] kselftest: mm: fix intermittent failure khugepaged
 test
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>
References: <20260923-fix_khugepagd_fail-v3-0-b387e92fe1a9@arm.com>
 <20260923-fix_khugepagd_fail-v3-2-b387e92fe1a9@arm.com>
 <447e0be9-836d-4324-9a36-77f8a0cbecf9@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <447e0be9-836d-4324-9a36-77f8a0cbecf9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cd5esxpnnzrdboptgni1wdgfxs5aofbx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47A704000D
X-HE-Tag: 1790671424-736980
X-HE-Meta: U2FsdGVkX1/1uQC/b+VA71w7AWK/bhzSFyVhMADA9kCs9n9zIMNoPDBHY/9YAQ5g7/9fWyUOLGXNW08WdA3HURBCVIfhRAaBnz4KH3w60iLg83LBsmI+31FypV1lpdfCdlpAn+/SELvPI/kGJoZnq9GiuIoMWujT5Y2NxXz1Qk8tgiSDUIRWi5/40Hs6fBxBzUvo5CpelMHhmrTVC+jMnVbRx//gApxjGxxw0r4DebC4kFmmV6JQwNK3GmHJKRw7CCqzHq948wV7k8acdQJMZIs0HUtkgcd7SBef8nOJ6mf+oxQJxTQU2kN7NMZArD7jw+U1Rg770X0fFbHc5SMO167XJVWyErbo/lp4mfn2EWclx1WJyJzl2aW0IAmawCHy6GPL1G+zZUSWDPkuNpo4zarHrIfUXMEYWZkyHw7+eS+D0/8/ZSVUQFmNx5SMdcjTltS1SW9lwgYcU+nZHS/NUCy/lr+/2laa2RzOLKgHMQuggsk9qdr2V5TPBqn4UpGCiR3ggFwC+se3Dklu+Hnu/dMseonZccEqul0c9yOeUnCNWQwFjLk+0HUkNI8DAy8wEAizQ/Jlbf6YzpTmnaWJPD9D7Jo19KfysDxwbaxCxg9BT9LEXZgndBMjasod7neRxVhQl+TconxEboNTihYmoyqmdYfDsaUimBw6mLGhC3DG80EtHZX/tBBP+rMP7X8PCGlwgV+gclr+8HyLMV+UgZaaG6Y554AWi5Dn3JfIl9+5iX1w0X9Tsl4DK/a4PFSKex3RFU+fVIRDXNVbgl3THwSZ6GlaVQE0LIK3O0eTd4CTBxOJBwrbn6cu+HDtcieqJ6VMY67RHw4s1MRjdxJwt4dpp+ebD3KiqAcXF4NVH2XNOFIHgDJKDUbEa9c5HicquRQE2D/P+sXuTgCNr51hTTDDO8GutHYCDGzJmXcSyMB6dgzMhOJfzBDPRNn4sZAxLNZD1TMSbHee1Ydn3eW
 F8styrOP
 VH5wW270xA4uW5umF31k1vAvJc+W/dc5YwRsPSaC43fOHL8YaMEXrYw+jpbor5jbN1J4seE/FZKSBloAR3x2g/56o225AaRW8Zzr5DzB9+Xy0g+i5fNdZMXV6Go22J4pCxBaKPUDUpgZcweK38tVX/aVQZDbUlzRtwwVGQViwt+1Xl/VchpfcF2AVcxOGdP3xkFp0cohep5JD+BEs/T1mA1wORvL5gViw0KEtydZMB3sYKJSqePFgmh0MoWoB+g0Gbk53QrrFDqk27ezdzfl5LnifDm4q4QBn/mKvVXF2YGz4MmgpXUc1bwcTD7w3hyvVGUgTWVQVIgWL/n6XaHOiVdtbTMarrnGwy5dnPGwJlKcD/j7z8KkWiw7EMzKTW6baT6a0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/29/26 4:38 PM, David Hildenbrand (Arm) wrote:
> On 9/23/26 17:29, Yeoreum Yun wrote:
>> There are intermittent failures in collapse_max_ptes_swap() and
>> collapse_max_ptes_shared() when using the khugepaged_context:
>>
>>    // while running ./khugepaged -s 2
>>
>>    # Run test: collapse_max_ptes_shared (khugepaged:anon)
>>    # Allocate huge page... OK
>>    # Share huge page over fork()... OK
>>    # Trigger CoW on page 1023 of 2048... OK
>>    # Maybe collapse with max_ptes_shared exceeded.... OK
>>    # Trigger CoW on page 1024 of 2048... Fail
>>    Bail out! Unexpected huge page
>>    # Planned tests != run tests (26 != 23)
>>    # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0
>>
>>    # Run test: collapse_max_ptes_swap (khugepaged:anon)
>>    # Swapout 257 of 2048 pages... OK
>>    # Maybe collapse with max_ptes_swap exceeded.... OK
>>    # Swapout 256 of 2048 pages... OK
>>    Bail out! Unexpected huge page
>>    # Planned tests != run tests (26 != 17)
>>    # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0
>>
>> This happens because khugepaged may collapse the pages before wait_for_scan()
>> is called, causing a sanity check that expects uncollapsed pages to fail.
>>
>> For example, in collapse_max_ptes_swap(), after faulting the pages back in
>> and paging out up to max_ptes_swap pages, khugepaged may collapse them again
>> before c->collapse() is called.
>>
>> To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
>> collapsed by wait_for_scan() for anon. This prevents khugepaged from
>> collapsing it again before c->collapse() is called.
>>
>> This failure was observed on NVIDIA Spark with 16KB page.
>>
>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> ---
>>   tools/testing/selftests/mm/khugepaged.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>> index 2aa7c9197158..b0cb02bf1a73 100644
>> --- a/tools/testing/selftests/mm/khugepaged.c
>> +++ b/tools/testing/selftests/mm/khugepaged.c
>> @@ -618,6 +618,9 @@ static bool wait_for_scan(const char *msg, char *p, size_t len,
>>   		usleep(TICK);
>>   	}
>>   
>> +	if (is_anon(ops))
>> +		madvise(p, len, MADV_NOHUGEPAGE);
>> +
> 
> Any reason we just do that unconditionally?

Although it's a bit messy, as I mentioned before [1], unconditionally 
setting MADV_NOHUGEPAGE will break shmem testing. Maybe add some comments.

[1] 
https://lore.kernel.org/all/24690e82-3aab-4f2d-95a7-3bba332ca5bc@linux.alibaba.com/

