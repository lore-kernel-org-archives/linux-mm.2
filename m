Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 571B9606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=bl5uhVOo
Received: by kanga.kvack.org (Postfix)
	id 841B46B05B0; Wed, 11 Nov 2026 06:25:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A8F6B05B1; Wed, 11 Nov 2026 06:25:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7564D6B05B3; Wed, 11 Nov 2026 06:25:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 541676B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:25:02 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E4A1D120271
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:25:01 +0000 (UTC)
X-FDA: 85422606402.20.EF99722
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4C07940004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:24:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bl5uhVOo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794396300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NVdfdUf+zfYeCBjYOT/U/HtbAWZ/RAxAIgf7+f5fEIo=;
	b=xvW08sj7bisvd6GWjbH3UZL1r0hA0erBnmnK6k5TQBNxwnzgoMBkQzQMmp+FBc6wlE062O
	Lj8rL6bR1WHNSXiKo58NasUe8yGFRkEG0+wVGLc1AmfaPA2B2XZx7ledWLNQaxp0dheL89
	ikLGNu8iDB1gOirf0Z5Zhtoj4SWmDLs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794396300;
	b=gZCcMvfBQl3Nrv6h+qcC9oCeKkgRnhlSsJ92k5s0j56Vkl/ZOhuTJ/DfHEpXSwCjqdIu3h
	WdxkRsvNHn6hsDcMb9euXY+tvLDgQLbUi6BTvrS52LprnI1HtVUcwlke6oe7rp5ZCjxHl9
	5Um/tl1zFVE1xPSsfSD2SKoJUB7qns4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=bl5uhVOo;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf12.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794396292; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=NVdfdUf+zfYeCBjYOT/U/HtbAWZ/RAxAIgf7+f5fEIo=;
 b=bl5uhVOoos64AzgvqPNRcE9nkGzyKPkB4Nw1A4ZqYOZqn51XaCTYG7WTe5kLq7AjiwwF92
 5dVkUuNX3xkPeox4hUzpdLhtLW3up+r7Vd9FaVCz6ilmVPWbxOTkInR3PCdjlz61qYYXeK
 4e3kHtL96iL2vxTaOpLuTAKJp7PQI+r8MUvB3gZk3zXlYXdIJ58Jdszahxk9FSPnhqISml
 /5powAz86rxub69+6Pp0zDZ/8dP6EdMp0/5EBLV0EopxUMrEqr0b1I3eyZWNnRYK/IpMLR
 mYed++T0ymgb94exuxERGkCWt09kODXsn7a0IvPizy+Bk3TsOBAaic7gqqY3ow==
To: "Mike Rapoport" <rppt@kernel.org>, "Muchun Song" <muchun.song@linux.dev>
Message-Id: <016ed325-2b5c-4170-b545-47b766d7f8e8@bytedance.com>
References: <20261110114859.76343-1-lizhe.67@bytedance.com> <avQjbt-QUp-W3_9v@kernel.org>
In-Reply-To: <avQjbt-QUp-W3_9v@kernel.org>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <balbirs@nvidia.com>, 
	<david@kernel.org>, <osalvador@suse.de>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Subject: Re: [PATCH v2 0/2] mm: optimize HugeTLB bootmem hugepage init
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 11 Nov 2026 19:24:33 +0800
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26af45082+88a098+kvack.org+lizhe.67@bytedance.com>
X-Stat-Signature: ut53tx8kfgrf48qyxjz41fwcgecnomii
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C07940004
X-HE-Tag: 1794396298-235339
X-HE-Meta: U2FsdGVkX19gH3NUtfjhIZvxvIZANLC46l6RhZM+VUWdc/u5dToudoAS75CMRALPmVtnMrNfkxsNlwADhvk1wnSUTMJDopUXmXVcj31RlDHRI1F1yuBAk6pqauxjBGQnvqfxO2jnTOrruTMJUBJ1gBn8G1RZQtC6wHMajJ5rmiGKKYfYQNpAqNiPANAnbS9uoU7x+RrDHG/1OJjeViLOzv2sQvVX+jg4JU/vQfYxhHBtP51wPszDKitDaTNSqi0dLN9L5QnB8H7QBobPrgEg+3gTSlBapP4m5LGHP7N4OFWU2z3OUe+lQfC7QAgqJe39FAtI7L51O4+D+Jr1F1ApJKtSHNKkRq+teRsKT3E1CyA8X/tVPZmA2HrWzo/RgzHujuyLv4/4WTCbmZo9nzaJEK+lNbOKCZgoVvGwb/zRs3rtFFHUhN7M3LVGndse8J/3BIGlgU5k6Of3dgequwO7VXhfKWmAaQKXrIGJIs3iklXv2E5Yn0TJkJ3QusF67IWKnKOPhrj8m2hcfZPObxPWavEbvCKeP2Si/kWp29+ne0YdrOwqqUVcDsTjWbJn4SCSJ1sjXrxVzLxLxZfxtjp0HobtmHqGS4uR3lFRL74HPWDN6axbbsXWpqVjXqTnAIjwVPHO/GWJuk6uYPXl+i0rFt9ScaleABisdK+OepFum/SbF4OQfcwTYH6ZdjBkRBh3g/YnwhwNI41oyNf74gB541bwHUETA55Nqdueou2vmyFPU1ldPCl9Ttm0e0oN057NERAfDr33kdoH866RM6f0Cm3Z/8ATAQEtsXZB/xYnvdiTa0uBGTuuXNFvv8jIrBcRGLOQvgLAVeSpDEr+DIo9EM2RlKxdTDhoZK97gj6jF4m6LtGNnt3fuf3CarZFs2BNfVU/QFLNh8eGUU3ra+42wIxgv77pY1U6P6bEAmf8znA11uHOY1g6ye3hfLe1Uwe4BSJUg9kKUlx2sKxA82r
 1I6FR2YR
 trRyKw6w7gDZxAMqDm9zYukHX4RZIS38ES6bjZMrHcB0pyz2WLK3GfBBp+ZwIvbO+TSjLjDWqqmsRyOEL8YnOxonbRDZxbiiPtCE7VeoABx4t4iAxWZrsWx0pcYaGFY98Bl4xU39n9NZkFXa+PD44BY23XsEr7Mq5lo67vGycXBR6jAFTlpbbRMgFSiotZgpQi01goe+wubpd9PB8PU1rAFB2v5jDck0bvVftokvz8H7ZLJSmr7QqOwkEvBpxbmPglBWj31lL5Ee2TyRt2IV2DJP0z3wezdt9ffs1Qy3bNrnAXKaaW3CDk9izlZB6UycR5mNE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 4:12 PM, Mike Rapoport wrote:
> Hi,
>
> On Tue, Nov 10, 2026 at 07:48:57PM +0800, Li Zhe wrote:
>> This series speeds up the fallback initialization path for HugeTLB tail
>> struct pages during boot-time hugepage allocation, when HugeTLB vmemmap
>> optimization (HVO) is unavailable or fails.
>>
>> Patch 1 factors the existing ZONE_DEVICE template-copy operation into
>> memmap_init_page_from_template().
>>
>> Patch 2 reuses that helper in hugetlb_folio_init_tail_vmemmap():
>> initialize the first tail page normally, copy it into a local template,
>> then initialize the remaining tail pages by refreshing only PFN-dependent
>> fields before copying the template.
>>
>> In the earlier discussion, Mike asked whether the same kind of
>> template-based initialization also helps the ordinary struct page
>> initialization path:
>>
>> https://lore.kernel.org/all/akfB6Qe-jKDEMUxz@kernel.org/
>>
>> I tested that direction as well, but did not see a measurable benefit
>> for ordinary struct page initialization. The measurable improvement I
>> could find is in the HugeTLB bootmem hugepage tail path, where gigantic
>> pages can require initializing a large number of tail struct pages when
>> HVO does not cover the allocation.
>>
>> Tested on an arm64 QEMU/KVM guest with 4K base pages and 64 boot-time 1G
>> hugepages. HVO is unavailable on arm64 in v7.4-rc1, so the fallback tail
>> initialization path is exercised.
>>
>> Results averaged over five boots, measured with a temporary
>> jiffies-based printk:
>>
>>    base (v7.4-rc1):  318.4 ms
>>    with this patch:  202.4 ms
> Are there numbers for x86 without HVO as well?
> We need to be sure this does not regress that use case.


Thanks for the feedback.

I did some additional x86 testing today, but the result was different
from the similar x86 test I did earlier on linux-7.2-rc1. After
replacing memcpy_nontemporal() with regular memcpy(), the result looked
better. I need to re-check the old test code, since I may have mixed up
which copy primitive was used there.

Muchun, could you please hold off folding this series into your patchset
until I send v3?

Thanks,
Zhe

>   
>> This is a 36.43% reduction in the measured fallback tail initialization
>> time. The temporary measurement instrumentation is not part of this
>> series.
>>
>> Li Zhe (2):
>>    mm/mm_init: factor out memmap_init_page_from_template()
>>    mm/hugetlb: optimize bootmem hugepage tail vmemmap init
>>
>>   mm/hugetlb.c | 20 +++++++++++++++-----
>>   mm/mm_init.c | 34 ++++++++++++++++++++--------------
>>   mm/mm_init.h |  2 ++
>>   3 files changed, 37 insertions(+), 19 deletions(-)
>>
>> ---
>> v1: https://lore.kernel.org/all/20261105120615.16817-1-lizhe.67@bytedance.com/#t
>>
>> Changes in v2:
>> - Add a comment for the template-before-copy ordering, as suggested by
>>    Muchun Song.
>> - Drop the empty-range guard in hugetlb_folio_init_tail_vmemmap()
>>    as suggested by Balbir Singh and Mike Rapoport; current callers are
>>    expected to pass a non-empty range.
>>
>> -- 
>> 2.20.1

