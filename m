Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75DDCEB3659
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 02:36:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59576B00BC; Mon,  2 Mar 2026 21:36:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B072B6B00BD; Mon,  2 Mar 2026 21:36:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8416B00BF; Mon,  2 Mar 2026 21:36:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD8B6B00BC
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 21:36:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE6361B811E
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:36:45 +0000 (UTC)
X-FDA: 84503188770.30.BF67A7B
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf06.hostedemail.com (Postfix) with ESMTP id D524318000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 02:36:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sohoYlEv;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772505404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2mEdKwaynOPWZlFY7lYmhYDunrC0D6Hhh7ZFnGQH84=;
	b=e6I5xloSJBq338q1zClLxc6HHHjEdiW9faySseoYkNS4XWm7nIS8AFMJi8a2Ry6pWuPn1A
	jU2zNp+hITv9gFP4xhZ61XWvA9So7rzqA9260xxeejtooYdgNRndBWpCQ3/3M1EQjQ2Vj7
	Rkm6j/xjFzSDovTuFuqZPUZw+wwuBYA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=sohoYlEv;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772505404; a=rsa-sha256;
	cv=none;
	b=NJELiEmeaneExkyUyoLdkm4Yq2QAmNAZSt/oWaYS5ectdSqJFC09jwaZrfRxtQj0sId09g
	ECxGZTP4TrcopUIKoglli6Czn/PH+DFIneSI/EiqJgpu1POfL03sXZ/8e8k/4qHhVlsfKM
	yP4yW2WwF+8VBDGT1iCiZBriqN9cGIM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772505399; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+2mEdKwaynOPWZlFY7lYmhYDunrC0D6Hhh7ZFnGQH84=;
	b=sohoYlEvdPsxyMYsY6AE3UXGYCitoiSHYQrN0MGYPtU1tu38b/WdYcxNZbwFXSJTBS37xqgQDO7S8yM2DweDhy87dLUfbmnOGPF7AJvoDwFL25+U9C32O2GAIiRbmwb3D4wf6qwfqWs4lRjCNxvg1gULTSPWihkuvNRAl5QN4ko=
Received: from 30.74.144.119(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-89.pD_1772505397 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 03 Mar 2026 10:36:38 +0800
Message-ID: <7b4266c8-f885-44fb-b39b-aee38625980c@linux.alibaba.com>
Date: Tue, 3 Mar 2026 10:36:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/6] mm: add a batched helper to clear the young flag
 for large folios
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
 <589d743f4e048dc749002a7e1a1aec5d511c406b.1772185080.git.baolin.wang@linux.alibaba.com>
 <be90d12e-304a-4c26-984d-2410a8850293@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <be90d12e-304a-4c26-984d-2410a8850293@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D524318000D
X-Stat-Signature: pqhfujhukjp9qkomdttn4xfzokr9meia
X-Rspam-User: 
X-HE-Tag: 1772505402-45091
X-HE-Meta: U2FsdGVkX18xnzouWjvd7LDe4D0ZZhckXc+O4+yVs35iuCcTyD6NzJX3pLJY9BthBmPO9xgmy9JXX51Iu1/fYz0gPNneFe7rEPQBSm+u/3jh82q6eQ/PfRviHj5m+5NI/3XeMkNaUyfqk2oR3diUDHUgwFLPZUwk1KRgRqB8QGfW9166J8PUSipHevimdfOmbZIAa+ktq+lDiSnTI2CWoEUHQaYOE4xcJOGDEaZ/di5dg2rF23/xWzz4wP4PPf27Q5zRsmRUja4xS8KovIsZfNUd+NmLWw5iOYiJ1iB99C3cB/iJVW9mMha3IpWWlijR3aFCLHRWIOaN8lnL6SLHdnEhMb9/lyXciGFBqDxNHl5PVD7hJEPKKYGUtleGRPPy3fBIHpeW16/2X0HhsNIPWQrMIo5SU6PAK6m2VaWNnU34WAu7lCMMnhTY2HIgKMRqAjIbblJ89sRLMLlKiQ1A/e9gImStLoVxecjh0stCb+p9y+Yet7WznesveoIa1NddjAtpnkod650obMmXE+2pMTayRzVhbpU5oSeGosrZKdGa5OQdXVGE9tIpls0H5G0hvV6yKTdM7Bsip5N7qGRvcnMNaYsCErW7z05QfT1KE3XeYtowBMsRFay/FrBwyj4dHdshO3JS6gTeM1JBA7G4Oiq6hxNB1iFI1tPI5qkdRG5BpBcSrBQldOm2q7BIO/MSVOgNDaiIWP7T9v/oBTXppW8Ilsg0wvkzNO7UBv3flMyRgnqdxK1Dc0kLwJkfagHnhxtTIlK+U24n60thzmdIRMIcifh1qLwug4o0sIqqePCYuhSAQASqwed/+uvE0LUHdf8qgVrXiilxzGQR27maR0e+rAAS3o9dKuNDNfQiiRyrksvCsEd+JKIdluULytZPPvPXlLereoL6bsRcbBzNoi2ltry/BWdPltW2L+ZEPNxclLD7x8Il1MI6gngv3+hkaoFOi0CGfCTXftfsBcd
 KHqLpKuB
 6BmbWGyyTV991q5kkLw+wRgRMZBGm2fWIw+skNP3/sd5EoZw0nGVTgOwHbwHgahlX3oVbi3V1X/tCEzWUXPrySs8PpLIg63ye5oJe2AxMbsDPeT5U3l6kgS1r+gZiJ2KoYkQ0fqPp/gCvpVNFSQxRfVdj1yCEW1rc+SzyPRsYrpduZn8m/aeZobzioodGxnY+2egQksppE1nzf+11ZYWeKu6wJQtB6apxaqOc5l3Kk1I+W9cDqaxsEgQGohBaz9xQE7GgOXzK/tHDe9N7uqN05g6x3dbg+j6VXxzP6VK54ic1fGAvg523bkeXrRaL4Ol3RYL2JpXmY8e3yegOXt5pIia/rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/2/26 5:07 PM, David Hildenbrand (Arm) wrote:
> On 2/27/26 10:44, Baolin Wang wrote:
>> Currently, MGLRU will call ptep_test_and_clear_young_notify() to check and
>> clear the young flag for each PTE sequentially, which is inefficient for
>> large folios reclamation.
>>
>> Moreover, on Arm64 architecture, which supports contiguous PTEs, the Arm64-
>> specific ptep_test_and_clear_young() already implements an optimization to
>> clear the young flags for PTEs within a contiguous range. However, this is not
>> sufficient. Similar to the Arm64 specific clear_flush_young_ptes(), we can
>> extend this to perform batched operations for the entire large folio (which
>> might exceed the contiguous range: CONT_PTE_SIZE).
>>
>> Thus, we can introduce a new batched helper: test_and_clear_young_ptes() and
>> its wrapper test_and_clear_young_ptes_notify() which are consistent with the
>> existing functions, to perform batched checking of the young flags for large
>> folios, which can help improve performance during large folio reclamation when
>> MGLRU is enabled. And it will be overridden by the architecture that implements
>> a more efficient batch operation in the following patches.
>>
>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> ---
>>   include/linux/pgtable.h | 38 ++++++++++++++++++++++++++++++++++++++
>>   mm/internal.h           | 16 +++++++++++-----
>>   2 files changed, 49 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index 776993d4567b..29bd9fd04e1e 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -1103,6 +1103,44 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>>   }
>>   #endif
>>   
>> +#ifndef test_and_clear_young_ptes
>> +/**
>> + * test_and_clear_young_ptes - Mark PTEs that map consecutive pages of the same
>> + *			       folio as old
>> + * @vma: The virtual memory area the pages are mapped into.
>> + * @addr: Address the first page is mapped at.
>> + * @ptep: Page table pointer for the first entry.
>> + * @nr: Number of entries to clear access bit.
>> + *
>> + * May be overridden by the architecture; otherwise, implemented as a simple
>> + * loop over ptep_test_and_clear_young().
>> + *
>> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
>> + * some PTEs might be write-protected.
>> + *
>> + * Context: The caller holds the page table lock.  The PTEs map consecutive
>> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
>> + *
>> + * Returns: whether any PTE was young.
>> + */
>> +static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
>> +					    unsigned long addr, pte_t *ptep,
>> +					    unsigned int nr)
> 
> Two tabs ...

Ah, yes, not sure why I missed this one :(

> What happened to using a boolen as return type and for "int young"?
As I replied to you previously [1], I’d like to do this in a follow-up 
patchset that converts all functions that check the young flag. Does 
that sound OK to you?

[1] 
https://lore.kernel.org/all/32c538ce-6af8-48a8-86fc-d26ee253af54@linux.alibaba.com/

