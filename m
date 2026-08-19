Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E46C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:05:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7CAD6B0098; Wed, 19 Aug 2026 12:05:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53C86B009B; Wed, 19 Aug 2026 12:05:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969816B009D; Wed, 19 Aug 2026 12:05:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9766B0098
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:05:15 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC2691A03AE
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:05:14 +0000 (UTC)
X-FDA: 85118493348.09.25C69A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2FF96140014
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:05:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6Lxkks2;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787155513;
	b=aiHcXXnrpjN35m6O2A+xfFg7QgKE10XSv03IdBZyRDHC0CU1l6V1/uWjNOl6jzwARWN+/j
	ozbD8cVTrlewhKRAHU2s20jZ5qLgZJusZFPY+A8TjERmddral/EXf9oLIO4nCizmrD6rLZ
	uv1KrVqZf+rAFxU4we12PhABAGaePao=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6Lxkks2;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787155513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R85xF4D1BuRCoFPUxtg/qJKAxquv1npSxGp2v2dm8Hk=;
	b=XgzgIofDwqK9SsoIcRXcPzaRsOvuMe2v7aleW/C1di0pO/BgSoecG3QT9ooGa4ttSmT3/F
	Vt/ulBnr7wzs4GtuvXfwdUWtUAanwzBaNqrP8iQxSq35AeVM1YpwpzWttT4hcVL4IpDJnu
	InjNidPt/m6VljQQWUF60IEmFDGVsaI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE2AF6136E;
	Wed, 19 Aug 2026 16:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26ACE1F000E9;
	Wed, 19 Aug 2026 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787155512;
	bh=R85xF4D1BuRCoFPUxtg/qJKAxquv1npSxGp2v2dm8Hk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=d6Lxkks2zUoLukzc2cnaWfMl+qPp8snEE3TqRxdYda8Suke/gdRp/v2IDYh6nZrIt
	 f62oD6W8TgliRFEbSVq9nivzFY9ZVOib/XyD7iuxexcdXZCC37OVtumFhbKZ0ajJdB
	 ePrKxBh//YU5HEcwpb7vQqlNKecMBRyIxaN9dogQ+wm+esHRZEHGGXVNKLL2qmJUIX
	 ivkxBdEn4p6RdBP+RX/H6BuVJv1mXeCWn8bTcO2fV0RW22qFydfeS3jJ6/NRJAWRVx
	 T+RQvEmvfDyXD00meXdXPwWOAJ+U4WL/cMGngLpx4IoWPJqnfloG3un0e0cEYbQM58
	 z9vhv1dDs9Q7Q==
Message-ID: <e06cb912-efcc-4a61-bae0-df29f81e3ed9@kernel.org>
Date: Wed, 19 Aug 2026 18:05:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 03/12] mm: add PMD swap entry splitting support
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, chrisl@kernel.org,
 kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com, linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260818131202.494754-1-usama.arif@linux.dev>
 <20260818131202.494754-4-usama.arif@linux.dev>
 <a5c3a93d-fcc5-4fc1-a764-726ca1d0185a@kernel.org>
 <4300a9b5-4423-4299-af54-e88bcca5432d@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4300a9b5-4423-4299-af54-e88bcca5432d@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2FF96140014
X-Rspam-User: 
X-Stat-Signature: 1g97n1qb8pdpnen88fuf6fq66nk63m5w
X-Rspamd-Server: rspam06
X-HE-Tag: 1787155513-871915
X-HE-Meta: U2FsdGVkX19zszDF1sxpqONn8JW5NiZ4tFQ9idQ8rmujNSsWscaQZs+ucvp0a+Y0g4k+smD9DqofY5iRj8krNUIhZJR3z9Xjf1WLeg3Ptd6Oo2R4L1H5il3uBcrtIzHo/xX8P7uGxYzEV/yx/Qk3IstOavKYcq0C3GWVoUMl98dge/trn8iJZP1BmX1eUJr0analX6v06mJPVeFb5wIAAB7FC2K6DP4YRmk7Gxko5EC7MfOxYQ0rW+t6bFOdsZ2PGuoPq64f3T4T7/ZNkjGancHQMtSVVdIzyexP2J1lSVFQU8QAKQlHflg3QTFmd/t25N17I2+vDHTAXNxXVhg+5Et+F6lxsNdU0iwyqErOQnS82ot5Hcrl4/vJXfYyIYNV95DSBH6kOKen5sUfbKI4LaNS5uH0vOfoTSu4KK8qyg+DQrPvBGHvneXLiv8AyxXL7rrEoupB+xfXhfUwaxMUvCIX/id6ujWLrZNcVMUrvwrb+3ED2dcxlkQAyUgdEvNIXyRMoIoBo83b+wYkOGeYcOJ2JU+gXR3xlZT/P4DA0VPvoChNha/8aQwTsnKH/0U8EOB9tymjZHwW+lq4h5ar7eznx1vEoosBgbdk//6MHALSlsww4klsQsrpnaCtRd2nTMaiMAgpKRBHqwplBTvTmVyiu4F7ApA8xskQvpSeQi1HzskZI7qPW3ymZoZR9g2jVFt4sGLTA4f9MAASjnjk6ViU47RS+/YQRAhUYgKsR7tijNz/xcbSgy2qkcYJsSgx45CNS0os969HcDkk68rOR7wJ+xQrsbQegHM4vGvnXjJ5SYwdqG0fbqjLLtWWDlq4HndIY+aeg93yXlX/P3CEeoFLGNOtWZ4B0jjDJvWynfIlrZsoFZZIXEGM7YK7lsTrSd0624+SSx1r3mrNfq6JaFuagY+yWhAaa+zmZ81fSKt52GF2yUCl5TpYgQivmUAB0xbxwHsCqgGuv0j6ez9
 vgymsMyB
 xY/7MO+0s/K2w3R3Bi7zW8H3+Ji2dQa4OByyE8k8l3emW+zsHWDLlGpuHmgoJS7gHbf/sGfE7KKwKjt9kUDK7aNFSmz5FuEzefkWdvxkexXpg4Cx+0hTvJCFnFQSWzH1xAtX8apuEbSyi4EjOb/gXlBayLctqHxoMHM5GcYSYG3pS/BTs+zcheHsbi1+g5OAqMQZkv2ceEGC1A2MWJzyCevJ3UU3MN7gs+ZU5fniujNX1mXilR+YUNLx/rARsJ1jxNOlB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> m
>>
>>
>>> +		old_pmd = *pmd;
>>> +		soft_dirty = pmd_swp_soft_dirty(old_pmd);
>>> +		uffd_wp = pmd_swp_uffd(old_pmd);
>>> +		anon_exclusive = pmd_swp_exclusive(old_pmd);
>>>  	} else {
>>>  		/*
>>>  		 * Up to this point the pmd is present and huge and userland has
>>> @@ -3388,6 +3396,25 @@ static void __split_huge_pmd_locked(struct vm_area_struct *vma, pmd_t *pmd,
>>>  			VM_WARN_ON(!pte_none(ptep_get(pte + i)));
>>>  			set_pte_at(mm, addr, pte + i, entry);
>>>  		}
>>> +	} else if (pmd_is_swap_entry(old_pmd)) {
>>> +		softleaf_t sl_entry = softleaf_from_pmd(old_pmd);
>>
>> No existing code uses "sl_entry". Maybe just call it "pmd_swp_entry"/"swp_entry"
>> and below "pte_swp_entry".
>>
> 
> Thanks! Will do in next revision
Thanks, that will improve the code :)

-- 
Cheers,

David

