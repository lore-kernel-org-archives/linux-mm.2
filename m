Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C3CCCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 10:42:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0458E0017; Fri, 10 Oct 2025 06:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C8108E0016; Fri, 10 Oct 2025 06:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504A28E0017; Fri, 10 Oct 2025 06:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2388E0016
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:42:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B676119314
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:42:25 +0000 (UTC)
X-FDA: 83981865450.06.D7F390B
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3BFC040006
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 10:42:22 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Cslbs//z";
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760092943;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F/2MWyCrDxrhI4+1rtpNAxA+OW+hGmrTRFH+Isw9N58=;
	b=fByWixJTbaByPc3iAJ2yvXSun3ssji9wZ27gOJcxh2CPts1684E3WisDzEemz4AE49JmQb
	4D8m05XiVdvoStEIqXxJudz0/biRYbqu1+4/2QH1/z6ILbOWjbp0BUTnD8cib9Nw8/D1Mb
	F/OhjyOOdipXwLbfK8bjiZNNyfsyEs8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Cslbs//z";
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760092943; a=rsa-sha256;
	cv=none;
	b=38uqk4mMyeErPHHXsTfuHBhM9j3RqHK3fmTB3w0/rL5mNbQ1li8GsvhkVsI6MMo+xTfPz3
	/mMB5bwQRDq9riVqDWUxKltHSmqw60goaVSLcHw5kUezXQEy/MqxJzMADTuGhtXtvsYNfb
	fjYHpsX8SIPz5HhqjQhAXXgB7HTiB0Q=
Message-ID: <6eee7e44-cdf6-45c6-8114-b62c57a2a4e3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760092940;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F/2MWyCrDxrhI4+1rtpNAxA+OW+hGmrTRFH+Isw9N58=;
	b=Cslbs//z93t0gMKiCEWHXID71xt7lvfMI0M3fFC5xhYuiQsVeF3TJ0NUp9y/b43gWcDphY
	MW0ggVSJrMRxCNTvfmHKPrhNOzBTr8zt4tqd/760Z3641Xyg60wpZgYKSC0hfaHYxISH7o
	UPpkXfhV/UFG75lh0+GHaWreE282Xvk=
Date: Fri, 10 Oct 2025 18:42:13 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, david@redhat.com, richard.weiyang@gmail.com,
 lorenzo.stoakes@oracle.com, linux-kernel@vger.kernel.org,
 akpm@linux-foundation.org, linux-mm@kvack.org
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-4-lance.yang@linux.dev>
 <ce95ab8a-70dc-4159-b38b-dd9f3ffc9aa1@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ce95ab8a-70dc-4159-b38b-dd9f3ffc9aa1@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BFC040006
X-Stat-Signature: jx6dh5nkejb9bk6bu8czmpmz96qskx84
X-Rspam-User: 
X-HE-Tag: 1760092942-852123
X-HE-Meta: U2FsdGVkX19hITYD0islj8psQwvzEj/yiU8UVwv9SC5DveJ49Dky2OaLnl7Us7RImLFmfgAqUTgVMu6qZCAo4IMEX5fU0y+tql7akP/nl5GII7X1bMBebrANK7Navsozc2RIYCIOz8sG6CU62vERDafZCZIbbAUZYyJ87Icv09RXEopUeOOlrF7X+2sJG4mFHRwrwSa9ccKFWtuxIIWoHJY+EuA0hk0tR7pVKNuJwVVrjF3kDX1ESg6XQ+DHV7gdlZjZCUIBW54HMGsGmU4FFGc1weAripdsUWn7yOKPfxGvMJpr1S3YyEpkIg4twJpG1hMyLmj2zHRDL0qP+d7yihZqcvsTSU16CUgalLfhKWSfnyEMpvMhuvC3SESbbEev9P10+awH/Y94D0flnUekA3P9Z6NzahC2BUGS5p+K35h85XF7d0SplIkEdwflsrWiZ33YxPfmNVQcZaAozozThruSPEsf7ZDeaeM5/xaPUPefJORhxDtKmDFadyGCIuMCaD+ouPkvqAg7Ixq+jDzYITih53lgXf8C3EEuqNzpIDyltHBYQ+pjwOte8X20+vRvd4tVn7ml1RLbs3ce36ETANuILYMIBrtBG7MD7/X4NxCbX+EadYxgHe6n3bLBozRekkX49NtZGz5LdeYuikPRJrOhV0T+LD37Yb35IuceiDTWLl/y4o2FDKnnq/F45CoBtmFangMdu9MRyMHhfCfm1ymXZStVgcH+npvQy3C0AUcZg4zDV3AgBQ+lCx3FW6x0WcDvgJoCfXAeEZZ1RgpfYXBoFNVoHsuYB+JabfhQPW7iq5FBVIYxhi0/XBEs9lVqyg/ZPDsDPaxm5LahvTCuAGR17N0j0nzHpe06jf0c+EXx29eFoOV6OCBBYQ6Qkex18tTY7B2L5Er6EYhyq/88EJuZVhcyv7Gi46y4pfqgJFtDiIy/eAuCnBBWFsq/rfLw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/10 17:10, Dev Jain wrote:
> 
> On 08/10/25 10:07 am, Lance Yang wrote:
>>   	}
>>   }
>>   
>> +/*
>> + * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
>> + * @pte:           The PTE to check
>> + * @vma:           The VMA the PTE belongs to
>> + * @addr:          The virtual address corresponding to this PTE
>> + * @foliop:        On success, used to return a pointer to the folio
>> + *                 Must be non-NULL
>> + * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
>> + * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
>> + * @shared:        Counter for shared pages. Must be non-NULL
>> + * @scan_result:   Used to return the failure reason (SCAN_*) on a
>> + *                 PTE_CHECK_FAIL return. Must be non-NULL
>> + * @cc:            Collapse control settings
>> + *
>> + * Returns:
>> + *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
>> + *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
>> + *   PTE_CHECK_FAIL     - Abort collapse scan
>> + */
>> +static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
>> +		unsigned long addr, struct folio **foliop, int *none_or_zero,
>> +		int *unmapped, int *shared, int *scan_result,
>> +		struct collapse_control *cc)
>> +{
>> +	struct folio *folio = NULL;
> 
> I think initialization is not needed here?Otherwise, LGTM. Reviewed-by: Dev Jain <dev.jain@arm.com>

Yep. It's a minor thing, so I'll fold that in if a new version is 
needed. Thanks!

