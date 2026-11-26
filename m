Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D632606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ojF7bNFN
Received: by kanga.kvack.org (Postfix)
	id BFD0B6B05B0; Thu, 26 Nov 2026 00:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6156B05B1; Thu, 26 Nov 2026 00:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3A76B05B2; Thu, 26 Nov 2026 00:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3F36B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 00:05:04 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6C171A02ED
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:05:03 +0000 (UTC)
X-FDA: 85476080886.30.5670091
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id A2F5C1C0003
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 05:05:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ojF7bNFN;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795669502;
	b=Q9NyEvVo5mUVFE6uXbKShMG9jyyjxJnmlsb3micJdLbTi755Sq8IZJzI1BD/mkT7kdJBAs
	5dfDZzwZ029B9rgloyg5e/HXP41XxcnchCZiF+dD6nfGTUOXQ75sFG9t5v94ejXxCJZDIo
	qqP6XUsMJIgOi6Z0Sr3/r2YoQTT9ZXs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795669502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64KL/KFbpUyHcPj5QRcpND3tqWtW+aDzEoNTUEv5lcQ=;
	b=uBxUybmlduUH2pvhmUa0rJZMqVUxYXjSg1PdOnuMcONY0pc1SIoGGDH2GZQNqltW2OHbBA
	WsdQCL64n1BmaLzbKdfuS6bkKzS1rj5kxjUcA4en0OhmM8/HyZXqs5ycm6PE7tbBefTh5R
	FztR1gpdc2pPM6/QO4+xPu/Ba8w/Ki4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ojF7bNFN;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 853462F;
	Wed, 25 Nov 2026 21:04:57 -0800 (PST)
Received: from [10.164.19.73] (unknown [10.164.19.73])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D400B3F632;
	Wed, 25 Nov 2026 21:04:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795669500; bh=AWAl92CdwflShhxtxbzvVO8xOtkxsr5N7S7TvV7IWjE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ojF7bNFNDUpKMZgKqLkNNjqmYApZvP260KZxtqTrPDCC/Qx6xWxa2VtTMvFQ3WCkq
	 1POo9OWwjxUUBQGhzckJwp5L3x5eTt0/tDH2Xg2zIBFjL/nE9+IxdrOCsYxD326KxA
	 esRtsQdXdejA0xiScw4jfa605pFcrErDZX7CsfqA=
Message-ID: <f0d1b03f-22e7-4009-aded-1e121172b245@arm.com>
Date: Thu, 26 Nov 2026 10:34:51 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/8] Optimize anonymous swapbacked large folio
 unmapping
To: "Garg, Shivank" <shivankg@amd.com>, "chrisl@kernel.org"
 <chrisl@kernel.org>, "david@kernel.org" <david@kernel.org>,
 "ljs@kernel.org" <ljs@kernel.org>, "hughd@google.com" <hughd@google.com>,
 "kasong@tencent.com" <kasong@tencent.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: "baohua@kernel.org" <baohua@kernel.org>, "rppt@kernel.org"
 <rppt@kernel.org>, "nphamcs@gmail.com" <nphamcs@gmail.com>,
 "shikemeng@huaweicloud.com" <shikemeng@huaweicloud.com>,
 "vbabka@kernel.org" <vbabka@kernel.org>, "harry@kernel.org"
 <harry@kernel.org>, "riel@surriel.com" <riel@surriel.com>,
 "anshuman.khandual@arm.com" <anshuman.khandual@arm.com>,
 "surenb@google.com" <surenb@google.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "youngjun.park@lge.com" <youngjun.park@lge.com>,
 "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jannh@google.com" <jannh@google.com>,
 "liam@infradead.org" <liam@infradead.org>, "mhocko@suse.com"
 <mhocko@suse.com>, "lance.yang@linux.dev" <lance.yang@linux.dev>,
 "baolin.wang@linux.alibaba.com" <baolin.wang@linux.alibaba.com>,
 "baoquan.he@linux.dev" <baoquan.he@linux.dev>,
 "pfalcato@suse.de" <pfalcato@suse.de>
References: <20261123053543.295467-1-dev.jain@arm.com>
 <3cee4b04dc7364321e1e8f8a98cfddd7f0082f03.camel@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <3cee4b04dc7364321e1e8f8a98cfddd7f0082f03.camel@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A2F5C1C0003
X-Stat-Signature: 4swzqwf5dnykz8aezdjq6s8qd763ej7c
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795669501-559841
X-HE-Meta: U2FsdGVkX19zKeTzoodtuCbP0SvOC3/u5XB5u+0vchDlPFTGiO/WaBxakyp2EC/1tMc//Dyo1WI5+gZQPpsvC/L0+ukCzlTqQUv0Xc0TeLMFadhhG0KjiyhWVDqywpPr4nqVLh4M6342tLwH3CQdPChuUhqO0C0IWddDDbiKjmtj799kNvTXkY/Uwp57AHVdYuUv8H8MGph4Bh5lqHtrarZ+s+etpWZJWfP90mdpThgxIdy7H0/UVnHtmw0ulUCtiuIayePtIQS072st4ydOvmeczX7mxAWGMmzlnlwuE3HvRVqfHDZBqPweQrysu+uIoieTvSg1BR7q5pyVWF/+Ur6TwODLOZACbZBhg2/amHSO3SF9sj4AFQorjkA0xM48z59EZz26G22ZvXY8hIYBVvwN91bF6V2NmJI4LkY+tDKpsxYAbghS9jn59/SWygpSGD+HEESx9C9LpqkprcxT8BGeqtg+SnzUn/bTM0mBjkEzRQfJWdiW/nqaq/xCKFlydBecQpzET1viBxBuCH7m6/QLBk/VFjR/Cd0dyUvYpgVI54j7gnPdVccHscKnI/hBDS0JpwQQ9PbQ3ljDGt/pQLa00cV1xDYYsmYecTJ2xdMIWe/Bmp7Mq1uqppygSTaMqB/zTsitMSUnnQqBlFng+PUcQqWlygz+uDf/qICYSqhoyYroZeFDIdCw0gDTHms0O4j0suvWb53cdvuH0silvo/XbxNmMp4Y33srodW0rBlRgdOh9qbuTuPqndRoeoz7u3dbpRXISg62yBeOS+zHHsXwLr7T7oBAGCOiZSmyagXY/JwoCm++6HVvWNP77DdI3lAwaAtOkJ0GtQCSueJ19XTDdSPDmPMCkOrSlDLbWpR49QqW8QFsBA0C++BN2SVitxCKP93plWKBeS1KoDjJ1jiTT9pYG1KsDQKsK+T7xfs9ldZ1yQTDeNMpfIlXYwrDbDNKJmF3rcVJeokM/NW
 a1Y34vcL
 POpl17i8Np6nagYeAyxeFvkCVNFGRo1yqAwsLoJ+JkccVAB1FFRIvuTrgJUZu6DI62KicPLTssqDZ9VGrdjzV0g8sAugu853ZqYBEbbInqurY1VNXqUwRjqZaNL22dxcZoZyv5XkwpxDYBhfcfZLqsHcXeTr6oZVaK/mx3+vvaG+QFT40+MxgkPJzIGOY20/sI+h5ITFb8hoo2LhTb3kn4i4duLZqQUzMQIicvOUfWKITnRJoTzKIcQ/8eRaged59DtvncQfn1GRqRF78QiXUCS2WC/rq5XEL6CvJ3/1elfgJjrpYq2d0s6O1VJ//PEnMfM2yT8sJgHNlXFRr/GoeWv9zEOdJGUxPr5hlUXPwqtIKGkGyKPK244S8qBON+ISXrUaSuHYXfeZTASc46WFXRDH8IvDiqinsyR6hqI4FFAxqVH7hglPHaoW8JzXL84BnY+x2rswovnGJQYISI/4/mLwTeKcOyCTDNrOo6dzEMM4sGRP6uZpV/nTcogDT2cK/ua+5O9FH3UocRiBrSO3J9FiMm5F2koBFB7OLUAIljd2ZUuM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 25/11/26 11:28 pm, Garg, Shivank wrote:
> On Mon, 2026-11-23 at 05:35 +0000, Dev Jain wrote:
>> Speed up unmapping of anonymous swapbacked large folios by clearing
>> the ptes, and setting swap ptes, in one go.
>>
>> The following benchmark (stolen from Barry) is used to measure the
>> time taken to swapout 256M worth of memory backed by 64K large folios:
>>
>>  #define _GNU_SOURCE
>>  #include <stdio.h>
>>  #include <stdlib.h>
>>  #include <sys/mman.h>
>>  #include <string.h>
>>  #include <time.h>
>>  #include <unistd.h>
>>  #include <errno.h>
>>
>>  #define SIZE_MB 256
>>  #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
>>
>>  int main() {
>>      void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>>      if (addr == MAP_FAILED) {
>>          perror("mmap failed");
>>          return 1;
>>      }
>>
>>      memset(addr, 0, SIZE_BYTES);
>>
>>      struct timespec start, end;
>>      clock_gettime(CLOCK_MONOTONIC, &start);
>>
>>      if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>>          perror("madvise(MADV_PAGEOUT) failed");
>>          munmap(addr, SIZE_BYTES);
>>          return 1;
>>      }
>>
>>      clock_gettime(CLOCK_MONOTONIC, &end);
>>
>>      long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>>                         (end.tv_nsec - start.tv_nsec);
>>      printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>>             duration_ns, duration_ns / 1e6);
>>
>>      munmap(addr, SIZE_BYTES);
>>      return 0;
>>  }
>>
>> Performance as measured on a Linux VM on Apple M3 (arm64):
>>
>> Vanilla - Mean: 37401913 ns, std dev: 12%
>> Patched - Mean: 17420282 ns, std dev: 11%
>>
>> resulting in more than 2x speedup.
>>
>> No regression observed on 4K folios.
>>
>> Performance as measured on bare metal x86:
>>
>> Vanilla - mean: 54986286 ns, std dev: 1.5%
>> Patched - mean: 51930795 ns, std dev: 3%
>>
>> I tried magnifying the difference on x86 by using 1M large folios, but
>> can't spot an obvious improvement (looks like my system is too fast to
>> benefit from batched atomic operations!), hinting that the benefit lies
>> mainly in the reduction of ptep_get() calls and the reduction of TLB
>> flushes during contpte-unfolding, on arm64.
>>
>> No regression is observed on 4K folios on x86 too.
> 
> 
> I ran this on bare-metal AMD EPYC Zen5 (2 sockets)
> swapping to zram, MADV_PAGEOUT of 256MiB, with
> zero-filled and with non-zero data.
> 
> Mean of 20 runs, (in ms):
> 
> mthp        base     v5      delta       base     v5      delta
>             zero     zero                data     data
>   4K        63.6     61.1    noise       128.1    126.2   noise
>   16K       37.1     32.6    -12%         93.3     89.2   -4%
>   64K       27.3     21.8    -20%         74.5     68.8   -8%
>   256K      23.4     14.9    -36%         70.9     62.5   -12%
>   1M        23.2     14.6    -37%         69.4     60.4   -13%
> 
> 
> I'm seeing good improvements with this series on x86 :)

Thanks Shivank! Much appreciated.


> 
> Can you check with vmstat on what's happening on your system?

Yeah I'll investigate next week what's happening on my system.


> 
> Functionally, my swap/migration stress suite and concurrent race test
> pass on Zen5 and in a KASAN + PAGE_TABLE_CHECK VM with no warnings, and
> the mm selftests pass with this.
> 
> The only difference I see is soft-dirty:
> with patch 8, swp_pte_prepare() takes soft-dirty from the PTE returned by
> get_and_clear_ptes(), which merges the dirty bits with pte_mkdirty()
> and so also sets soft-dirty on x86.
> 
> After clear_refs and MADV_PAGEOUT, 8192 of 10922 unwritten pages in 64MiB
> are reported soft-dirty with 16K mTHP (10880 with 1M), where base reports
> none. mprotect() over-indicates the same way upstream, and David said that
> is fine [1], so I don't have any concern on this.
> 
> [1] https://lore.kernel.org/all/380e029a-2d9a-43ee-9048-c4b490c11f41@kernel.org
> 
> Tested-by: Shivank Garg <shivankg@amd.com>
> 
> Thanks,
> Shivank


