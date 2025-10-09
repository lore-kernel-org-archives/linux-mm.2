Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FE1CCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 737B98E0023; Wed,  8 Oct 2025 21:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6A78E0002; Wed,  8 Oct 2025 21:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6558E0023; Wed,  8 Oct 2025 21:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 491938E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:49:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 02120160910
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:49:22 +0000 (UTC)
X-FDA: 83976893406.01.7D7D48A
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6D77A4000E
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:49:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kOEckLtO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759974561; a=rsa-sha256;
	cv=none;
	b=SD735c7C9g7iyeQrcQOktgqcpsjQ33TyRcz/Y215kslSEjpsaC3reIC5qDpOjboN26UD+2
	HPT38f+V0MET1yi8+fU2yIhO8T8ORI4Pv895vbucpaRRZQLxpAL0bWl7BQkPcfzQ/MZQPl
	p1etHbrf4vbdWUdIYwvQ3y0XtC1AiT8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kOEckLtO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759974561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gmbfo1v3pnUVofferszWtiV8RrDISxuLm2FSoyEqKmM=;
	b=EibNrAZSsWy55NsM0wK2ah8rNixmyWotE5jxip9AcYlcVnLlvO8++CjyZOFQ5KHEVl89gS
	CqSXKs8bsR4Q+tdVdC8KtUYXIjdjfr79j8IRI7CAKpk/bPkRlALoY32GVLVnbkH/WjPNte
	74aPwBWqcNeo8eHGb6r5i9GHC3nxeys=
Message-ID: <2ddaaf80-f16d-44be-9032-974f7e501e36@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759974557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Gmbfo1v3pnUVofferszWtiV8RrDISxuLm2FSoyEqKmM=;
	b=kOEckLtOeUsZQWf1SUasgVpDk7DgTsgPid27oYpunbvpT54dOsfvmrNhbfM4b9yPwfFKf2
	ffL0R1SkMSQ1DAezJ60yzZiDpJ210td/RTCNjeNq0c1t/jnxRv+uuGzrGqOGlgDOjizX1H
	ptlJVp+AMz3Oq+SkjxsEDD0F2sPWByA=
Date: Thu, 9 Oct 2025 09:49:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-4-lance.yang@linux.dev>
 <20251008180744.008424134fbc29e9616899ad@linux-foundation.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251008180744.008424134fbc29e9616899ad@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6D77A4000E
X-Stat-Signature: 8676sofomdwdnsqriz3dqj5ydfbjht91
X-HE-Tag: 1759974559-935775
X-HE-Meta: U2FsdGVkX1+dExArPx1JN/mm3kRIqlkjyWRtpk8RsAWrDSCLip45bRSTeEmzITvZB6bw9m4yFyUsdiv23amyN0BkWhmlDp+/AVxPKX9OzymNhKMF5oB7g2eD6OjBjVy8tQS3WScdPH/T+A8/AKhnKIXltcMWu82ju7ior7f+o35HEir8CMjPwR/Xv7YgAWcsSj2URRYgnN103bN42HVOkett6BTJfXaqK8ruQDJWuqPesbUSdfYOY3LGOmHne8NXyOPJCaoH8dTEhpowZH2ZA+/vUid2frUDcj85iO3yamYuykBFuoJhR+HEzHabb3CgnV2GtL13Oce/vTZ1QiOdq6DmQPSOR0HkM5OT2yjg4dIg5+9zhu5bMfEvlGVz0iQr3KvzVG6YbA/7TIIdsI5xU50cd9awKZencY6gpY/DCStlOq4OpsmpJCvubUkkf7MM8ShAT6CBWMgtHcMkhHk/wVSwwSGzk/l+hwdfxtFtw9x/qL25+LkCGgQzzEHghi8yv9LkDbz8ycGK81Xi6xduKafXEG0I/UMFAbJfWpoIPMnOVY4sohWrf+QHC1zF4Q1nO7NonMbgr6d6INhEnu51VN5HX80ET61KrbLvZ4ayCQoCyHoenp4Hq0/VpfCY09xurdIQdXOWiSr7xSWwR9YlWJ/deHWZU/PglGAw6dqnHSClBCmIZh++0bBblPcmDrfmklR7NI8DEjGYqoDYxDxkZbd167MyZ+TH9vb0fb1DwIbiGwAH3WK6VkEn/pwVEO58HbcZruKnsoaPfVr1aTo2kRDXJCpo2OVceOyfhS2iXl1HTSc7vx3HfMjAuKVmWLwWT8Ab/CovfnoERncjbBLe915+O8khipY/jAbAVvta2JhrpP3GG4TvCdFPU5MBglrUh6dJkBXGFfplO+FlaeccgbEnJG6Hd6KOet6bfe3t1++0zPtRx20ls/B8JCXVbSVKh6XFPmjSewWklu58ieo
 JUpi19f6
 9EXjXmRmXJH6j/UUQ9egyfDrIOyUK+cPrlYfGnn+bjiobMhhIrVK8SRI5tfupoqxm8gJzJguxTj3mMy1wEgGHuBKzqR8IsvqMztviGhBebVYPzEhksF7mMhuMALsR0m+MbqdIX5vymyJWOYCFb2MkTyqkmGdIz0ktjF5aQ4stvowFLKUd8bAELHHtYORyS9Od/Q7dRMq/C0/WLJ+xUTvx6Lo4IRreqGwNkc7+PTS1DHaTld1yEpfqzv5stmyiJn7tvhRvC/8LoOJarD0EzS7ueHyaMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/9 09:07, Andrew Morton wrote:
> On Wed,  8 Oct 2025 12:37:48 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> 
>> +		if (!cc->is_khugepaged ||
>> +		    *unmapped <= khugepaged_max_ptes_swap) {
>> +			/*
>> +			 * Always be strict with uffd-wp enabled swap
>> +			 * entries. Please see comment below for
>> +			 * pte_uffd_wp().
>> +			 */
>> +			if (pte_swp_uffd_wp(pte)) {
>> +				*scan_result = SCAN_PTE_UFFD_WP;
>> +				return PTE_CHECK_FAIL;
>> +			}
>> +			return PTE_CHECK_CONTINUE;
>> +		} else {
>> +			*scan_result = SCAN_EXCEED_SWAP_PTE;
>> +			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>> +			return PTE_CHECK_FAIL;
>> +		}
> 
> I'm inclined to agree with checkpatch here.

Thanks!

> 
> WARNING: else is not generally useful after a break or return
> #81: FILE: mm/khugepaged.c:574:
> +			return PTE_CHECK_CONTINUE;
> +		} else {
> 
> did you see this and disagree or did you forget to run checkpatch?

Yes, I saw the warning. I kept the original style because this is just a 
code move ...

> 
> --- a/mm/khugepaged.c~mm-khugepaged-merge-pte-scanning-logic-into-a-new-helper-checkpatch-fixes
> +++ a/mm/khugepaged.c
> @@ -571,11 +571,10 @@ static inline int thp_collapse_check_pte
>   		    (!cc->is_khugepaged ||
>   		     *none_or_zero <= khugepaged_max_ptes_none)) {
>   			return PTE_CHECK_CONTINUE;
> -		} else {
> -			*scan_result = SCAN_EXCEED_NONE_PTE;
> -			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -			return PTE_CHECK_FAIL;
>   		}
> +		*scan_result = SCAN_EXCEED_NONE_PTE;
> +		count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +		return PTE_CHECK_FAIL;
>   	} else if (!pte_present(pte)) {
>   		if (!unmapped) {
>   			*scan_result = SCAN_PTE_NON_PRESENT;
> @@ -600,11 +599,10 @@ static inline int thp_collapse_check_pte
>   				return PTE_CHECK_FAIL;
>   			}
>   			return PTE_CHECK_CONTINUE;
> -		} else {
> -			*scan_result = SCAN_EXCEED_SWAP_PTE;
> -			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> -			return PTE_CHECK_FAIL;
>   		}
> +		*scan_result = SCAN_EXCEED_SWAP_PTE;
> +		count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
> +		return PTE_CHECK_FAIL;
>   	} else if (pte_uffd_wp(pte)) {
>   		/*
>   		 * Don't collapse the page if any of the small PTEs are
> _
> 


