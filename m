Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78F2606EE8C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oJDOSGrv
Received: by kanga.kvack.org (Postfix)
	id 0BB7A6B05B5; Tue,  3 Nov 2026 11:15:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093C96B05B9; Tue,  3 Nov 2026 11:15:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB776B05BA; Tue,  3 Nov 2026 11:15:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C91B66B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 11:15:36 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64BA4A04C7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:15:36 +0000 (UTC)
X-FDA: 85394308272.25.51626DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A1D0F18000F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:15:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJDOSGrv;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793722534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q8NpD8k/9WAc6vNVaSkHz5kodBio95Wiqomk8+JsUrs=;
	b=dXxKqflkaoHbYseP8oc+EIK6HrYl/1JFOgSD76+J8rp1I0kBQ1OCIPDh2xfwRDeU0bE52b
	smGgX8dKAfoWhG89uvy+fPM44pgYNehO8/UbvNHAlZjFoHnuhEDYPvUxqRMl4N5Fhygpyw
	BmmZot2uvIubUD4lRC7J0Ai8sEYXyIo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793722534;
	b=4DBlfneMrLEPciFdTZZN3OeNLb/p6UFzGsnz6WTxJ8c4gIk5mXxfhZA1N0cOQ/FR8zBDa+
	teVdRfLBLn71q0/70trNe9i0SdW2RXvkFV84NzlXqb3B4FgH9ACcdSjj890d4KyhdahAtR
	N5MJBB8FacBJpMlpFvYYYc6PfnUAyJM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oJDOSGrv;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07AE0601FF;
	Tue,  3 Nov 2026 16:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4961F000C1;
	Tue,  3 Nov 2026 16:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793722533;
	bh=Q8NpD8k/9WAc6vNVaSkHz5kodBio95Wiqomk8+JsUrs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oJDOSGrvzCc1+rWbOgTy5e+i1jHcwIL3bwsFqFsaeNRT2AeMbOjiMGmU2Zp9yZYD+
	 BB3Xg4+eY8aOy7I0aMRe5fsGeJJkPwOHUFCPUyn9xvYcGjhYSBKWtl2eayNstgQ62Y
	 SGhueBZmnf5RztTpF/FAXD58SI4QhZ879sJeq6nVA8eI2gnZxSLWONU4B6gZbrHeFF
	 MZReR1zKTML/5QWFVA2ELxwckl2cXDn2ltSzWE8DQDfpUKcnYl6zlGYEluXM+hRwpb
	 vnqM3E1TiCwqt/9ed28XSL/lm6F+gTJMRY2GLuUYop91BaL19zfbB5ZgxQsYu2gtZq
	 /nOW/h12ZY3JQ==
Message-ID: <61f8a583-5ea5-4fcc-bf30-ea9cafe94d65@kernel.org>
Date: Tue, 3 Nov 2026 17:15:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory: use pmdp_get_lockless() for the pmd read in
 do_fault_around()
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20261103014749.96764-1-hui.zhu@linux.dev>
 <aumfvNWiemmuyooP@gremlin>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aumfvNWiemmuyooP@gremlin>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: qf6amtpkeizpnhx8uiun19xj4thju6uu
X-Rspamd-Queue-Id: A1D0F18000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793722534-286708
X-HE-Meta: U2FsdGVkX19WFrvfHKKKxErKyrc3ffjHoKjoNlQS3vw37azFS5lCCVP2RM4PCDFOz6ZpIg2yPChykuQESFsFYvdcfJkT7CPNx/BPNMsoFJ4NKict4Be3dJnyO+Gx7LHuZ/JhCOOpXIEMIyo5q4+mv3xzvlWZdztPKu9nsoioJauHxXFW94ZxxhZueO5fajaWjztZf0XSIZfDvrd9pragNOGAAsG/cbDDNm/djLnYnGr9/Ck8qJzI9mLT2u67MPk9Xw3kdnRRTo7ul2Z1ElmVRnUGWH/rH587j9gvsoSkh6FdH1d4Z4Ue46wuD3sU7V3Vr4Z4uFFdwPFPBhtptfrgS5o2pBuUW8UI6W64D4iKr1ejfJh3TFKuv/jfgBaj7cOBPEkeFIm/7mAv+2VtlvFks1oqp4Bz7JIQbBCWaCZiFCi1nZNYbfuNK0MXQgruj2w0rufJY3eTyRhRHQAFkKPuDSMZp/ZC7mOZH1N+2BZFyn+Xzb15RRh3IK6XjWXqBQyTOCsEHUsPcYHgSsZhjgbOwENrEwMR3xMVpHo9aIHQYMcIHMeMsohaXSsYLP+W+u0YvCZDhDUXLQ0vHN4RMT3SNSs7Nkqwwql1XvNXx9k/mxNGsNngSBrzK6phChcXMTqM5EAu+dtw9jp5uCmpiy3m6bN1uoorh387/lOvi6maaCKAwLtPfxLVUj3Qb04RHIcRemHMEf9ugR6CiC3WBDbwDBV8YhT3+fxH1dswB+561n0sFNLy4nyARtZ1tF1A7K6nV1/oNSX3A+37AONdWFX6pWLLi3+3+Cj4xOzvKtxr0+G56QuSrM/KWMeU3GrW/q3C5IJNEGsKrojdEVRXu3OEpmIbzAJqnsV946i8HqaBfBnIhLi5Exo2baTcYIsiTwe/BrMLP049dyA2EdAs2Hva46xGMfu+0E2KdJv9NckntWcSZAYB4TDJ7/cBn1/EnXVHTLXQ9QoWhIMK+thhTWS
 zpq0BbDu
 Btaec317shDJUSJbbNtbf1z4NNP5mj1pug44rJRnGQ4KEE+o97i4oAWYLZ8IRRFUTg/gREdgYuoO4rdGki1ablaHg3SP4BSHKjNbkN0DdNhCN6QguWSPJyfoiAxOr0SHSSqy5t54cZrhwSvqesQQVl+SMp8b6krOy8hRyQxF/qZitCFK6QZbLt16Uz/A647R3nVuouS03AFPBx9h1MnQrByD6nWwZEU8wCd7DbT9EGcyn+VLrYZoiey6XM7u7FCf3xC6PZCxV+d/uifRJlPzGvvKsgVNCRWtKxKZx20CIAi8ab1EcP1ocVVD57A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


>> +++ b/mm/memory.c
>> @@ -6017,7 +6017,8 @@ static vm_fault_t do_fault_around(struct vm_fault *vmf)
>>  	to_pte = min3(from_pte + nr_pages, (pgoff_t)PTRS_PER_PTE,
>>  		      pte_off + vma_pages(vmf->vma) - vma_off) - 1;
>>
>> -	if (pmd_none(*vmf->pmd)) {
> 
> This pattern is definitely bad I think, we have it in many other places so
> should probably convert those to pmdp_get() at least?

Usama is working on this as part of separating HW and SW PMDs (he only sent out
the PTE part so far).

> 
>> +	/* pmd_install() rechecks pmd_none() under the pmd lock. */
>> +	if (pmd_none(pmdp_get_lockless(vmf->pmd))) {
> 
> It definitely seems right to use at least pmdp_get() here, but I wonder
> about the need for pmdp_get_lockless() here.

Whenever we're not holding the page table lock we should be using
pmdp_get_lockless().

Even if they are semantically equivalent for most cases, it serves as a good
reminder that there are no guarantees.

And that you have to look again under PT lock.

> 
> pmd_none() only checks the lower word, so a torn 64-bit word on 32-bit
> (i.e. the PAE style cases we are worried about) makes no difference:
> 
> From x86 pmd_none():
> 
> 	/* Only check low word on 32-bit platforms, since it might be
> 	   out of sync with upper half. */
> 
> And anyway I guess there is no valid PMD in such systems that would have
> the lower word cleared and upper word not cleared.
> 

I don't understand the discussion really.

No PT lock -> use the lockless variant.

Until we can remove the lockless variant.

Are we consistent with that? Likely not.

But that's all independent of this patch here.

-- 
Cheers,

David

