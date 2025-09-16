Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54649CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 01:36:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F6F8E0008; Mon, 15 Sep 2025 21:36:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7148E0001; Mon, 15 Sep 2025 21:36:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923BC8E0008; Mon, 15 Sep 2025 21:36:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 808998E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 21:36:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 090F686CC3
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:36:14 +0000 (UTC)
X-FDA: 83893397868.23.53DEB0E
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf04.hostedemail.com (Postfix) with ESMTP id 15C5740003
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 01:36:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C7VvoLJd;
	spf=pass (imf04.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757986572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iO9IyLuu+6VJGjLqKGfdYZOIt/8+8VRDHAroqFcBXb8=;
	b=0gAaiEWEnBlP2Ukut8/Z675iiVdx7l6Wk5h3cAEgJKsnGW09pDWwM+mK617llNZELfVGGt
	QlQNAGQOUrg8k6BkZU6ryLqjG3dAQinQaQvM52ZBMvinDftFjTsCtK3u8r1j67dp7PAZsd
	/Rx6mEFmhcVZvaGB8ekuaQLKww98B1g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=C7VvoLJd;
	spf=pass (imf04.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757986572; a=rsa-sha256;
	cv=none;
	b=oxSTUl4qAi843zC8kJHToSSF2BmjgVhVZKL63vr8/KKv3ud6IK2oWxck5J3sRE+iqtcL7C
	I31L5Jj1ZyA5XhAjcacBGfPGNGB/oFo1VH48VFrk0ShnJ4eUTMbCDImx7Q222mP0cNkyYj
	I5Ri/13e5NuFWRD8SkacTkT0bVOLpjs=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757986568; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=iO9IyLuu+6VJGjLqKGfdYZOIt/8+8VRDHAroqFcBXb8=;
	b=C7VvoLJdP/9/F6aCbRQPn0x7onZzwChbaqsAlMUyvIusaqrosTaZ/3K/nu3vZ5tWlbtDUsD85WSYbwSU+pEDt4p6FW0lyFdskf5whrVB6cx3w6BEdsqU2b+ja21v5nd+NOGQaXBGxIRGlVklIwrd74ld7Le2HJGDXCK5ZKIwTx8=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0Wo6JU5v_1757986565 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 16 Sep 2025 09:36:06 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: David Hildenbrand <david@redhat.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon
 <will@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>,  Vlastimil Babka <vbabka@suse.cz>,
  Zi Yan <ziy@nvidia.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,
  Ryan Roberts <ryan.roberts@arm.com>,  Yang Shi
 <yang@os.amperecomputing.com>,  "Christoph Lameter (Ampere)"
 <cl@gentwo.org>,  Dev Jain <dev.jain@arm.com>,  Barry Song
 <baohua@kernel.org>,  Anshuman Khandual <anshuman.khandual@arm.com>,
  Yicong Yang <yangyicong@hisilicon.com>,  Kefeng Wang
 <wangkefeng.wang@huawei.com>,  Kevin Brodsky <kevin.brodsky@arm.com>,  Yin
 Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [RFC PATCH 1/2] mm: add spurious fault fixing support for huge pmd
In-Reply-To: <8c51da7a-7370-4678-96a3-7cd6eaf0db62@redhat.com> (David
	Hildenbrand's message of "Mon, 15 Sep 2025 13:08:09 +0200")
References: <20250915032946.33203-1-ying.huang@linux.alibaba.com>
	<20250915032946.33203-2-ying.huang@linux.alibaba.com>
	<8c51da7a-7370-4678-96a3-7cd6eaf0db62@redhat.com>
Date: Tue, 16 Sep 2025 09:36:03 +0800
Message-ID: <87frcn6uws.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 15C5740003
X-Stat-Signature: wwn4zffwsqksi6ut9744on4ayx1wwjoy
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757986570-666694
X-HE-Meta: U2FsdGVkX18qjUGH9o+bf3WdKC8mObLnKssdFBIiRt920kyenrEcB4VBXCDOw5e1iRoDyPAsuFsuELsIUYmrAcBh1W2g1gFmf12STStiLZ1PXeOQuqdvxaAEoCgzXQoInd1WSBo3IqZtpiJ9rpWKjeYOyI2m+HYFDc8ckh6zz4OupI5ZQLfseEOcpn4XgiEOf9gugk3CuKEENhdzswlkChOLnqIlCN3NTTNYYwVjjOVyAqp0peXIdPxU2cJuY1ss1ewg7qh2qKM3PvqV42r5lzSdYjLpZH6G51/as/7jNLK9MKfHsIPDVWZjXHmCoo2uTWyjjw11u0lYj6NQg/yVWJtTpkUErur5mntiNhDi0NhTSUg9wj1omnnkyMdm4ZoaznOXkSzgJb3P3hw1huSpfzv2BcqyCI775iUMOejutX9tZFBGCErzUOTMZUjzxro7+BuuLhNbx+KE7WyKqRvJLZDGKDvfEk62YUtw206nF5UGVEYXyQc4u1Nj9UNFo1pju/H9tsmlICFW4eO6k1p8l4jF3Cr1lBNY3FX3XXVAucqOaqrgrxYghdFCpeSZCo33jR5eduBTpdQNQvtwmm90204aS+XnzZsjLx2/PB5KVSN2YgT7weReGt8yJ63W4PZK4fkWu5iUXPL7RII5mypUmIie6pbZ+5yfPE8oKeMciNBcFEtrFXHwNs7ENStOCOqIqe3OiQGAhiQw+krSTYO80E+ARRQdU5l2EC1JxTurNwntgRKjB72uMxJ08qJ/uEGj2M1xd+4BfQxgkQfy93kNOBfPPIGSdsnKVXC/mivpT+L77bQsFoqjUZsoDfBMLhpEdupPZt1gTRIrnVYEUUJaClOBGMRQthD/szsKGbcSobG62z0kKDujxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, David,

Thanks for review!

David Hildenbrand <david@redhat.com> writes:

> On 15.09.25 05:29, Huang Ying wrote:
>> In the current kernel, there is spurious fault fixing support for pte,
>> but not for huge pmd because no architectures need it. But in the
>> next patch in the series, we will change the write protection fault
>> handling logic on arm64, so that some stale huge pmd entries may
>> remain in the TLB. These entries need to be flushed via the huge pmd
>> spurious fault fixing mechanism.
>> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: David Hildenbrand <david@redhat.com>
>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Cc: Vlastimil Babka <vbabka@suse.cz>
>> Cc: Zi Yan <ziy@nvidia.com>
>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Yang Shi <yang@os.amperecomputing.com>
>> Cc: "Christoph Lameter (Ampere)" <cl@gentwo.org>
>> Cc: Dev Jain <dev.jain@arm.com>
>> Cc: Barry Song <baohua@kernel.org>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Yicong Yang <yangyicong@hisilicon.com>
>> Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
>> Cc: Kevin Brodsky <kevin.brodsky@arm.com>
>> Cc: Yin Fengwei <fengwei_yin@linux.alibaba.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: linux-mm@kvack.org
>> ---
>
> [...]
>
>>     int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct
>> *src_mm,
>> @@ -1857,7 +1861,20 @@ void huge_pmd_set_accessed(struct vm_fault *vmf)
>>   	if (unlikely(!pmd_same(*vmf->pmd, vmf->orig_pmd)))
>>   		goto unlock;
>>   -	touch_pmd(vmf->vma, vmf->address, vmf->pmd, write);
>> +	if (!touch_pmd(vmf->vma, vmf->address, vmf->pmd, write)) {
>> +		/* Skip spurious TLB flush for retried page fault */
>> +		if (vmf->flags & FAULT_FLAG_TRIED)
>> +			goto unlock;
>> +		/*
>> +		 * This is needed only for protection faults but the arch code
>> +		 * is not yet telling us if this is a protection fault or not.
>> +		 * This still avoids useless tlb flushes for .text page faults
>> +		 * with threads.
>> +		 */
>
> Can we instead just remove these comments and simplly say "see
> handle_pte_fault()"

Sure.

>> +		if (vmf->flags & FAULT_FLAG_WRITE)
>> +			flush_tlb_fix_spurious_fault_pmd(vmf->vma, vmf->address,
>> +							 vmf->pmd);
>> +	}
>
> Okay, In the PTE case, we call flush_tlb_fix_spurious_fault() during
> write faults if ptep_set_access_flags() returned "0".
>
> You are calling flush_tlb_fix_spurious_fault_pmd() during a write
> fault when pmdp_set_access_flags() returned "0" as well.
>
> In general, LGTM, but I would just let touch_pmd() return the value of
> pmdp_set_access_flags() instead and add a quick comment for
> touch_pmd() what the return value means.

Sure.

---
Best Regards,
Huang, Ying

