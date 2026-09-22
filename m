Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B35C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:35:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9456B00A1; Tue, 22 Sep 2026 08:35:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 631FF6B00A2; Tue, 22 Sep 2026 08:35:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521106B00A4; Tue, 22 Sep 2026 08:35:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E94F96B00A1
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:35:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9088DA4AD6
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:35:11 +0000 (UTC)
X-FDA: 85241343222.03.24345EE
Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6088A40006
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:35:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cwU8b8G2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790080509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UooEYY3XSUXc5Zv1HmaYpLhPrMN8hkGySW7d8Ioqs6A=;
	b=ChQaa5rBwaTmSpdpIp9+DxCBPRmkHiPA0GahcHI3E9aPkNCaWjMjTncfbAvIK5TmXLgIsb
	6E/qd1ZwOzY8wQqr1TKxj3WlQ6aEsnV0vu3VWyz03WBB68ewDCcRtZ6YtKJyR4o8xj7pRG
	sdYa2pXBrnSp7qZIzCwHQt998Ki4lho=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cwU8b8G2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790080509;
	b=jKvj+tbml7tAvu6+7EoRNZWsC64KBUaibUl2Ym0lQ6fW4ylKy4eBdgm3/qr9I03Qq/GQsw
	N6ZQoo0GLXmGkbMmnSLfIlw2HQ9gnK5WFAFDIWG5qpjWvdNxHO2unc3Q6yiX52/dc4TGmw
	hjupPM+ElpUjCWYV2oOjPDk1ymEqnW8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Xwtckas4LnrLCXkCKb5n3gLZW22/ubZm4385L/A1/Us=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790080507; v=1; x=1790685307;
 b=cwU8b8G2j89LJqxIjxBtNYWYqjPo1PayZjH83zRHeqVgP6VfEri3Wf9IKp0tt6KmP4wI0xZN
 hb2CW7siSn7YnPGfiVFzdDT/X60o4CFcNtpju2LGGRLnAkd098QFrtxO0eGrlRmbeMoydTw+Vki
 T50i5J46t+verlulVm31rdoU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 887b51e9a353e5f0;
	Tue, 22 Sep 2026 12:35:06 +0000
X-Mizu-Trace-ID: 887b51e9a353e5f0
X-Migadu-Flow: FLOW_OUT
Message-ID: <93e71e27-86d7-4853-bbd2-756ac137a925@linux.dev>
Date: Tue, 22 Sep 2026 13:34:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 02/29] arm64: mm: add PMD swap-exclusive helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914122950.3283997-3-usama.arif@linux.dev>
 <35e42ccc-df8f-4703-b10d-f7c96b263e98@kernel.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <35e42ccc-df8f-4703-b10d-f7c96b263e98@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nyoq6jppndpcabtfdh987yhftx7w4c65
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6088A40006
X-HE-Tag: 1790080509-902549
X-HE-Meta: U2FsdGVkX1+ruKsif58f8RtbRR/xMd9P9MmVWO3YwiP/MwlfQWQ+V8rDPzaqjwR2pM1EoFZAYfWHrHHjN5EARLvxIaLdYjdb2bLxcp2xy0NuoYcGZXDhGVzkX2sb2YUcYGRPQmCK5PThGt8YMqqDA02vACjAcNkF6Mt5EnEfekOuNRWpMnTAS1qRgtPXjoQl28zQgP1cTgASkYAIhJ3BtG8fBnmUqwUToevJF+DSmHm8arlZHC0s3s5/iAK7/4mgCyuahb+OwEYivlrcVdvCerIn2mWJmQSKnAe+dI0Lrv+m6+MkoZQ2ct/x1hkJ+oBuwQhhZdMSxzjUS5uUttS9z5cX8sLQz6mKTWVXPa5+izgrKsSaU7kDdYQZOV2anaK0VQLaokeYODR0sy7EIxYhHlQhs4KxtgEfNYVR95QcvCjJvUdvGIqBnfOF+9qqB5IbpNK6lruUWI3C1M+47hs0b3HncX+Ys5INybMYxjkE5dDwQ0cmW+GHKI8xx3vDFaVhgFG6Ec45963KC98TOAMmyUpYG2DRVkPVUJX8C34ndXcBWQNjChMViA4OyoSqTKyFK7wSBFEQiN9RWvaXv6h1C14fAoZa1Cgv3p7oJsQzJ8pSKAPACWiJu9e/kzjdVoh0ww6l/pkyY48cfIJcb325H5l9NAAKmA7E7Zb+IRxpZdr636KUrd84+zDmMSYst4lSxNsg5yVNQsKkp0xHvy96b/RWEObBRWGOws1tVg0YEkJZrFsAoWqrRBStQ/Q0SfHeCL14vo5Q5bmtbq0iaa/OJsMLXBEvZ8uLayTRIkJYGvhqPXZym/by7GYNTDs6ui496R7kypHF2+Ih2KlQ7yyiHy7AlJIiZ+il/xVWmDqQFYFFzOUYmg5fVIbd1m4j3ZFjkl2lqkMY1WbwXGYzXqohx693r1iYWm2kpA8ESlOj7Dcn23oNWbPrZjX9+AEqR6DG40+i2Olf87aYq1tIgRF
 6+GFZ3pi
 RQac8kR7F4rhPxjNC3ktzcB1e8SjDCy925Axu8XN9/o6fgLGCmK/ZD/s818YUjUIwLyzJF0v8Bs3TQ4HrHMST6oCvErV9ddG1ndz7ndgietLGZRmTyx8Fbfzm2uIS0ZrQforc5GvR2xj9LftxYBqZ2soeRESHD+Wznb1CNkITuhBSIZLQICehjmWh2LvNksetR64UlXmCfQxUzXpYcRMya09P2Hc08c/lziaOwWrrWd4Gp2ZK1RN8Sj1cby9jh4LEnv/paOKgJGhrutZSLGRCG3X3yOvrn4Pe6q9HXhDueA3Uzn0VG2EI3dzs06m/txQ6T+RMcWlN+NqrQGKKzpIMCgnS6tOVCT1A1HdQDXYgA4pWldA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/2026 22:11, David Hildenbrand (Arm) wrote:
> On 9/14/26 14:27, Usama Arif wrote:
>> A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
>> swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
>> not just in a swap PTE.
>>
>> arm64 encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
>> the PTE ones and reuse PTE_SWP_EXCLUSIVE.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  arch/arm64/include/asm/pgtable.h | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index e89ec5f4787b4..d3f53a601aed3 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -599,6 +599,12 @@ static inline int pmd_protnone(pmd_t pmd)
>>  #define pmd_swp_clear_uffd(pmd) \
>>  				pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)))
>>  #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
>> +#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
>> +#define pmd_swp_exclusive(pmd)	pte_swp_exclusive(pmd_pte(pmd))
>> +#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
>> +#define pmd_swp_clear_exclusive(pmd) \
>> +				pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
>> +#endif
> 
> Why do we #ifdef that here, but not the uffd-wp swp PMD helper?
> 

uffd-wp is gated on CONFIG_HAVE_ARCH_USERFAULTFD_WP.

If I removed the CONFIG_ARCH_HAS_PMD_SOFTLEAVES guards above, when THP=n, arm64
will use the generic macro which is wrong.

I tried building uffd-wp swp with just ARCH_HAS_PMD_SOFTLEAVES guard and I got
the build error 

  mm/page_table_check.c:232:20: error: implicit declaration of
  function 'pmd_swp_uffd'

we will probably need a separate patch like:

  #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
  static inline bool pmd_softleaf_uffd(pmd_t pmd)
  {
          return pmd_swp_uffd(pmd);
  }
  #else
  static inline bool pmd_softleaf_uffd(pmd_t pmd)
  {
          return false;
  }
  #endif


to avoid the above build error.

