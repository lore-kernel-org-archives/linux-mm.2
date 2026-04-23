Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D1FF9936C
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 10:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2D916B0005; Thu, 23 Apr 2026 06:41:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDDD86B0092; Thu, 23 Apr 2026 06:41:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF42F6B0093; Thu, 23 Apr 2026 06:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AF8916B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 06:41:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49A08C205D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:41:13 +0000 (UTC)
X-FDA: 84689478426.21.385346F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7214BC000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:41:11 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R1nFHnWF;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776940871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wrWFeAqappEvsHyHiM1opcwy4+CKVvlf8ke7UyR6S5A=;
	b=mBf7KpgilvbKx9NMGfQ2WinHZhkl03vVDuUM51B4dgNnd5H63n5kCT+QAVNrDnp0YRrlNM
	K9RIIA42N+yFJ5ds8P/j5WTTzjmECQQLZVufqnvNNL/yuy1Ho+qidC8m5R1m+ATjaDzz3D
	mm9BUYwPTU/eZoBYXGou1Uqq2/f2biI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R1nFHnWF;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776940871; a=rsa-sha256;
	cv=none;
	b=vrGDsFE33YhQ5q17+8nZTLN4FuLyF2du9yuxkHhQz498ngEZXEIkLwXUPyVnCfdJqSMBne
	OdX57FT6Av/H1cuwGFw8BYSMvygKVYk2fJcWJ7YWm2P5IuineBLOaZJt5pUbbzjYXE7QQL
	1FXqDCcnYxs120RJc7um0q22/Gb2C4s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FEF243526;
	Thu, 23 Apr 2026 10:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7380BC2BCAF;
	Thu, 23 Apr 2026 10:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776940870;
	bh=Bi0JKllmc8EsuTFVoWIS7hebjAew4hxnm0zhHQlaF5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=R1nFHnWFi6JiIUWL60faGZIP3/hDO1R12xZ/Ub/HIJvhp/ZLJJUndzXe2l7oIfkW8
	 DvcvPzHs0epRiENLhVmIskMbigjGQb0fHjj9lOstZ7yjPNALz/upNHJr9ZHkAULqNZ
	 oT3gpMlowjJJXYzmJ41Ij7ozC3fH+U7nMhgdQxOVfULIrMN7DwP1Mjltu+lcwNHyBv
	 OSXsNgJp21t5QSzfuHps/eKej/w7rizHW6mVIRf8q2LD6ByrBNPov/KoAZrFRSlUgY
	 6IKlIulIuumqCaaQbH8WO525fzDWT08ktKSzpd0Xpngv/3HVXZgUVHp4ljy450u/eD
	 /nht8rOBJcuTg==
Message-ID: <2483c24d-8674-422a-82a0-5c839f72e82d@kernel.org>
Date: Thu, 23 Apr 2026 12:41:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 v5 5/6] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
 <20260423071911.1962859-6-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260423071911.1962859-6-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i7n97b58qyr1mj7eoehccu1mr484j71m
X-Rspamd-Queue-Id: 7214BC000A
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776940871-784514
X-HE-Meta: U2FsdGVkX1/G9i+vlG/tEx9nK8fo5d302H9wNwA70K8CIsWcres7aA97TdaDQ065hxut+iy8tfKskzFL1poT47oar+ea2M5iHFNijhwfpsbZu7mChOFSEGEIGP6w9s0XUBA9/Y7J/MONzm16Et3XPP3Ss1OTijsm93hy8RzCm9LBujtOhVXidLRMmHCclFRpLm31tsTESezELOj0SrFx43R3U0Vv2JP441RGu7iDGbrimpppxKkDjcMz1VAiSaKvbmOVs16lPncydFgNkNXm4kX4h6XkO9y6MeTWsvA6fL4F4gum/A6M8MqjUyrhwn8m4idLnL+tXGMQKLIw0UzsVRpPSXHZ6eNcg+9vpIPwR1ISeopGTrFXhtf76n16ZoYntfr1Irzncy5QF+rVQAWm3QU6ZEAdb8hjcq5A9Iyb8KbicLcz3v09vZ237B7+3+umDYi4udHJPc8s02t/ji4qJVoRospbqRNNWG5AwvpVBMx0oOiuEn0OuP4UpUTWhCqUxZGBH4whciR5AIFb0BnYeKsRhLru8TposDEVqjxJRIg3aSZ6wQ1NLHxz+Jn8kpVKnLNWTAMcWOy+u/JxCeYhVeqlC2qZAM0pGgRLE70/cp3nRDFd05E/AORf4yDCztI70yoKrZmx83XeE0t3t5xTD7ofsC5dgiR1uaBOdNZTHSzVbt6MsLVkrThwix9gJi9DVLEfvtdkmUEAl/h5bf+Pvz53oFECZw06MxUORlThYJmR4glfCUr197Wl7qF70WX55WlS4jp3gtlhswiLCSkF+2oTTeHBOG263AWYJ8OfC0tuT4gf8+OnXBaqcu5UgA1NlzaokwpeGUTA1WieM2BC5RFgezoTJyJtZPhczS9UT1IhvHUebJPIsOf8eiP163cr5jSutibqBTS+bWsiyn97prQ/aqpjia/xEqMqJ7L3C6vF2heA6/N/eX1MalPZckNY/5IW9JYeT/zbfG8jmsS
 oJHczOVL
 CauE00FLNSix+f2u2qEOKJluPrLi1/QUuDFQMGhfKeiXGjcWlz8zydYfmV1tZ5Kbal66FrTxwziWrn5ctYOdVBooXjqIHl0ohrNvkE8TFXSdtv4ZZan+NLN5E1wnBDZzxGqdwz4ZQ0UP/8Cn+/HrspFj3ujTWnOjKZRzH4C52P46/+WMSaKuv26IS5Pg2mOOT9JOa8SzlWntymOVuhYz/eC7pHWg5E1kDLJBsy4nrP8WYN1Zk9ByJZRQ74qP94PbXCE8+ZT+U3csmQzAsbVL2g7eete2v5n8s1puHRGYokocFY6NVdpzi7FpgTjDH2uTO0SlAbMJOj4qnJ4VOo+PJt1L/VBgfPAjwL0/8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 09:19, Muchun Song wrote:
> The memmap_init_zone_device() function only initializes the migratetype
> of the first pageblock of a compound page. If the compound page size
> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
> subsequent pageblocks in the compound page remain uninitialized.
> 
> Move the migratetype initialization out of __init_zone_device_page()
> and into a separate pageblock_migratetype_init_range() function. This
> iterates over the entire PFN range of the memory, ensuring that all
> pageblocks are correctly initialized.
> 
> Also remove the stale confusing comment about MEMINIT_HOTPLUG above
> the migratetype setting since it is an obsolete relic from commit
> 966cf44f637e ("mm: defer ZONE_DEVICE page initialization to the point
> where we init pgmap") and no longer makes sense here.
> 
> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

