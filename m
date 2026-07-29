Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 249C2C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:32:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384B26B00DF; Wed, 29 Jul 2026 10:32:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334F66B00E6; Wed, 29 Jul 2026 10:32:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22AFA6B00E7; Wed, 29 Jul 2026 10:32:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F243A6B00DF
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:32:52 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 76AE1120613
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:43:54 +0000 (UTC)
X-FDA: 85041327588.14.6B4A55F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id B4F1F160008
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:43:52 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mWhzC5Id;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785318232;
	b=o6Z7oEWiFRR0YSxoNKFiQzziQA/UheM6n//oTchqy93SHrVGrmAOlclrMtjqS/KO3lydX4
	zA+rVdRzkf4kR+7e6pWQlSz8kYEXs9xBzxFh/c/aK2hkdLndA1GdbkmL2OL31z6qZs3/6I
	Bci9/YteG1n3rakGAtDqI3eIGlNqcrQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mWhzC5Id;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785318232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAEi3Z1dwCJXNJ/KIIOh+i3wdcLco65Gi/CuVy28haM=;
	b=CJ1M6+3kp1HNetz0m7uJL3QwzlctMfljBiFNrcNAG2MauSatBMEftwWqwa4roTRkCZVwLk
	OqOp+2eu5qTl013ObVupQytQVAmY/l+H3uYQeIn/9sDKZoJeXCrPXdYC1jy1DcUgJSkS90
	bvnOvfcwWuRpoYF/NRcLh1Igih5BEEo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42AB2600B1;
	Wed, 29 Jul 2026 09:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E61F1F000E9;
	Wed, 29 Jul 2026 09:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785318232;
	bh=MAEi3Z1dwCJXNJ/KIIOh+i3wdcLco65Gi/CuVy28haM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mWhzC5IdDiT58NlD2Vh4bt5BFi4dGdB4i+wsOq0ftOchFTEETbGx7ZYyfcmeRWoVS
	 fti/GCNrbf2Na1PUvyiHFV98p0rY0g74/iFL3oebvAFfjQAgzDg7ZrUn4x7MAZ+MQA
	 anyQsAi+l4hw4nBXIBetWSkFoAXp13r/Bp6B5+W/Rokm8wqccDbEqtTDEdj4/vhHu2
	 fOjScexvDSmdskZ6DjKLHDShwPmgzJajmoVuB/oVQ5pvpc1acH2mE4Abto7VQg9DQZ
	 IS6nLgemTUyixum1CwqPnH58GaV/pntaJecnLIp9Sr8r3fkrWE0AcMeZo0HFPOgFTl
	 ZGb9Wbicp2ioQ==
Message-ID: <1886019f-62f7-4662-a2b8-07f035fb0a73@kernel.org>
Date: Wed, 29 Jul 2026 11:43:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/7] mm/khugepaged: introduce a count_collapse_event()
 helper
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Usama Arif <usama.arif@linux.dev>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
References: <20260715025941.1571316-1-npache@redhat.com>
 <20260715025941.1571316-4-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260715025941.1571316-4-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5cn5bmh8m6mb4j7m8o7b7346t8zueab6
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B4F1F160008
X-Rspam-User: 
X-HE-Tag: 1785318232-368913
X-HE-Meta: U2FsdGVkX19YY3I4AoG19Um3YTUpsQHAGIm6H45aQyaUzZkj4DoNHy0tHgOumWKsDrfQ8Rt28OWfgXK4VUZSYk+OI+pwmu/qip38Imo7NLY0guirk3JdEPumy+tr5/jhsLV+WdkaI67W9tYv1P0VO730dFxIK8D82urEhKZN9rRVWyaNuKWq108fMiVsJB/1onbIsX5kdRUJSdsqbJupPi24mh3mLQ0uKQxvAkOO1P7EtrybJKkj9Nio+3RG7uKr+v5wSGiGELZl0dNAj3paH7puWgHyPOnqwB5pKelX0X9eanIe4E40rsBJ3Xe8zKlDZelqvW/n12tsmhjWwZV0uTe98d8Qw+/HUcz/DvoBT1+2jGqq004R3Bk3RLQ6HwwH2VEnRvccrEE6n7suuhvODCMgHztFG5dTpWtYWCZGFtrABTwrkonEtkzfS1nppDinh5OOhFEhb2xqmQuOWC+Eq/+RZXLurojA8hb3BlsyhEOs4k9+9BRJRDBS5Leu1DdlJD9r473HD8PoqtLET8l27tZQMY60nB5dupucdHGp+QCFSROHgXLhLrX2GGTDzYdv0v70uPygLQ6ti3VSGfu4Ld1Ltsl0K4gyoZSJumFgmDvpAKzJMsTKsL1mRxaAD2320JJg6AwuIeJ5d1jo0GFohKHlZqx4u5skyAf4pqitDG2z9xQ+pwJXxnugQBhF4/sSkQuZwpPy4AJ9r9bqtIDXmhK//SbMboDLOxTXMpMkgdPpWsXbO9D+IH8S9oScg7/yMNiDSpZhBaa/DjcjCOIiyqD1Mzc1COpAxIIyZUnERd1T3SR4aXqcBu0BHqjo8RTIvUdI/u6MdyphJlRtXx1bE1F4kh3B1lD9lf9+Rnhod+q+96bdE4syefiDu7arB80OD6jrcz93LKekHBG5h8CUJ1p4H7++O3X5H65gIwIZNMmjvRBuF6XusYRJu1udakuikBkxVczM29A9htzwlX0
 TiTGb7NA
 dF7BzgjI2pjWEGmwEwJvPrSe64W2cajQbwS4rWwopOIEztYC52yAc1AAXwgeY3HCIIQ5HixW1tpznslCIEmyGTK+SoKiNwh7Ut9IlI7JiUkXDNzeyt9uzuL1icLrvuuO4AXtYBFypVaXxjoesV9leOKMypV/2T8tS5LkBs239s22NFp0hYqjl+9GNeMXR+zTdkFfC2ll8SG3nefg2PYoi//MvcNg5yFUAGQLVI4FmVCbGrd3F1ITuZUsoC5+pZr271iY5Jizq/v0wbiPm375ui6p38a/Mw1hoOVSaWoF/PzN2EoNB4o1U4IleFidyrYNj+7f6rEil9F2HWsJLUwZIqyWgUKKHtMN16/M9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/15/26 04:59, Nico Pache wrote:
> Provide a simple helper function to help reduce a often used, and
> duplicate pattern across the khugepaged code.
> 
> When collapsing to a PMD we need to record a vm_event and the mTHP_stat
> event. When doing mTHP collapse we only update the mTHP stat.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---
>  mm/khugepaged.c | 36 ++++++++++++++++++------------------
>  1 file changed, 18 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e92e2b928f17..f65bbe2051b3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -689,6 +689,14 @@ static inline bool collapse_is_referenced(struct collapse_control *cc, pte_t pte
>  		mmu_notifier_test_young(vma->vm_mm, addr));
>  }
>  
> +static void count_collapse_event(unsigned int order, enum vm_event_item vm_event,
> +		enum mthp_stat_item mthp_event)
> +{
> +	if (is_pmd_order(order))
> +		count_vm_event(vm_event);
> +	count_mthp_stat(order, mthp_event);
> +}
> +
>  static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		unsigned long start_addr, pte_t *pte, struct collapse_control *cc,
>  		unsigned int order, struct list_head *compound_pagelist)
> @@ -709,9 +717,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		if (pte_none_or_zero(pteval)) {
>  			if (++none_or_zero > max_ptes_none) {
>  				result = SCAN_EXCEED_NONE_PTE;
> -				if (is_pmd_order(order))
> -					count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				count_mthp_stat(order, MTHP_STAT_COLLAPSE_EXCEED_NONE);
> +				count_collapse_event(order, THP_SCAN_EXCEED_NONE_PTE,
> +						MTHP_STAT_COLLAPSE_EXCEED_NONE);

That's not how we indent parameters here. Unless my mail client displays it in a
weird way (doubt).

Same applies to all other cases.

Apart from that LGTM.

-- 
Cheers,

David

