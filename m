Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3076EBFD10
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5410C6B0092; Mon, 13 Apr 2026 03:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1B56B0093; Mon, 13 Apr 2026 03:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1136B0095; Mon, 13 Apr 2026 03:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8A56B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:38:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFD6013C1F4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:38:13 +0000 (UTC)
X-FDA: 84652729266.20.FFB8A19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DF98B180004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:38:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sQDH5ZEM;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776065892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WxOKvmzfsSLk7IzJLUMe/GY6jGxgSCgPMGNOI8A132A=;
	b=xM3kOec5mUIm+FiAIVhXdCYAQZAGm/cwvU+/RwYJSXyp3NV/tVD4SoTQENVdpvjWjfKxyr
	BgWdV+z/Z4kSpwFjbg8oCbSpISIwMama0jqndqrehE9j9oapOm7y9C0KO5DhzagFghUcE1
	ZXNxjQlSWOyCz8S/X7jOFO+HAtKYihk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776065892; a=rsa-sha256;
	cv=none;
	b=3By44eJ9KmcDhcUzNXa5L+yBmJpEUBZLmmrlsU3lLOVhO2yB2twM5w3Bvtrz63t9FCel/H
	5i5BqFagAYb0maWvhcRWsoS0lLSyYrZkhtDy9OMNFb+9Xx0TXQTfgx8zEGYyK3+qPFk8Vq
	wiQielE4m/YXBkZ8zUf2aKGdYBxo/Ec=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sQDH5ZEM;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73FC044175;
	Mon, 13 Apr 2026 07:38:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40598C116C6;
	Mon, 13 Apr 2026 07:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776065890;
	bh=kfHbKcE+7O56hLMmTCV+tl21Hg7z0932/rDESON9yEQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sQDH5ZEMeaGsZ0xpIfLrJWKdCEwlD0IZWgIRRwmZ0UiFIbCzhilp4pEkhdjc91qX9
	 jhhby5L/HIWRcvHXT9EhsKiKEtLGzkhsL2tkDwrlOEsgAA7OS11fKOzj0o9SXkURLJ
	 DUEoKIubJbc+/swSeSpYh4K0gmkW1lp5yzYPn50xpOQHadIEt7V8i1udQfX5yfOkYh
	 B18Rfo3vQWi+oFrw/0Teh47Db16fllaRKeXIdrqJk6Oq2ApCXdGdNzZhS2g9qORLpm
	 borhS0eUSee0GLZ13N7XyNAs74TXnV56mjc0ZzUP/1Kj8QnCRk8eCkW+maTH7yZnx0
	 NSubKZWlk6xfQ==
Message-ID: <11e01f34-d042-4938-b7c5-328e08f17192@kernel.org>
Date: Mon, 13 Apr 2026 09:37:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 06/13] mm/khugepaged: skip collapsing mTHP
 to smaller orders
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com,
 lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032445.233437-1-npache@redhat.com>
 <94290ad5-f63d-4fa7-a898-dcfe6cd9998b@kernel.org>
 <CAA1CXcDnz_7+16sDVbGJ2ZZPWxs7ta_Z0YU6x1dUe7yiSJ3OKg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcDnz_7+16sDVbGJ2ZZPWxs7ta_Z0YU6x1dUe7yiSJ3OKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 4ot6y3s84erukr33qusf7uxtiapefxox
X-Rspamd-Queue-Id: DF98B180004
X-Rspam-User: 
X-HE-Tag: 1776065891-442057
X-HE-Meta: U2FsdGVkX1+2Dlo/ifhnWMqJmGOanZgweC3Nb4o/g8wpjMUGeWyinaS4fqdjuEi+9E9aCzjRHFAFhFi7cfgOhQb3PMB7QfM3x1h73WkIuo7PlknMlJEM7VIDOGqcyanB+luL7I2C40D90DATvu81pLi32OwIs7KAV/XtsL03N3WFPsIFRcKGkfp49Y+xZCquHfy7uyMYWTBLoOU8mXjL9GeOC2tqh0YgY6/wVDU9LAw7tOxiTD5ZiLo6BbhJPG9q2JmYoezOPodGNse3USM2MdJVwUwOd+JjVESjVsjWBmPSFtjd4xu9Bz2M4jEE6wsgO7TNsg3Cb5xqfrvzRl9kk8O0Z70RQeIv/JnsCvNWf6B/XB7iAaBw6bRRceiAkxxKqYy3NG90aGCr3qdTZMms5ZI9JXTAcZ83D8ONj3wIvL/a+xwj18Qbit8OtX52/K58asq5cN2wAaOFbKC+vPWVvWRdAB1bH4kFh9PFU5Akfz4TKQH/adIFYpC0izd0Q/OQaTsTF8f3WfoEJ5xowUR+xfHXTMZCEm9JcFfHyPzAXXzwov1GKAiG4ofPKFKWhsgNVyJyuGo0ombDajjRB5ohMzjdkmFbt6/xD4BhmtMpmdaqEmviB8BD3s59ul2l3o2bIOxoHKuaXPn+xuwtbCld5vR7X2F1CvfBgy9Z0ThDkHVq76dBS02/eoYTJepUm+vkrQ1c1d9Eb1Vurp4eVPmp+uv1ht0wuMAJDdQ2BxBi/sm4+XvygFsOrs9Ax19nytR4ELDopd7UdeD/uKfMzyKmsiPfBgM0na3ET+1WHlE3zzdyi8mCr/nDEiu4+3MfA+QopdDnM8NJ92kjhpI3ho1IcMzcjV7iqc4/MCaLccEnA4MWRVHYqtOz4BmL7MgwdZGyex6mnHSEumaJi5isFCB8bXrPMjur0xk9+O3TW1rM9g1WDdPmzS46WHtSepVBSYSpJNgVzMqczLOqWohJUdv
 OW/MHDUP
 Dfy5ebPIuVndaslrfLgwEFTCr8VEtHlrwMCTY28Kg8FMQIKT47tlUGu21suK+boeHL7AIgi0J4wxVralTyVNIcO4OxkVLYzGd2D5cK3n4OqMqGCP973UFAVSpFPgPG+25dGYu6VbVfMmnMITVPIJh/LQP6yZU0COaae6p/KgWeSjqoR+VtndnGRLIowj3cMDQss3PgebUJKLQ+ZwjxN8Vp6qdlXWZEOrewOm/3bYTig4GyYsSyeShx1sVxAAIqLbuNLMl4WA7kInk0W6LKdTgS+SoEYGV+xaLQsE4cdDxRoyLh1xC8Srk08Q32wbuxARy5/5YMAAQQ42xKOTvp4rPEEBd9NcETVb8k6L8hjK0734CmL3UtaGNrk2XQ8j61sujvLXEeLdx/n0xNxpW1ffHIztBvI4n+sqMWK9FCnQTD5OVu9nZZV34D8Ma0ijWXaXnqrwPzr6brKQkZ8+mcXOQEswlxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 03:38, Nico Pache wrote:
> On Thu, Mar 12, 2026 at 3:00 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
>>
>> On 2/26/26 04:24, Nico Pache wrote:
>>> khugepaged may try to collapse a mTHP to a smaller mTHP, resulting in
>>> some pages being unmapped. Skip these cases until we have a way to check
>>> if its ok to collapse to a smaller mTHP size (like in the case of a
>>> partially mapped folio).
>>>
>>> This patch is inspired by Dev Jain's work on khugepaged mTHP support [1].
>>>
>>> [1] https://lore.kernel.org/lkml/20241216165105.56185-11-dev.jain@arm.com/
>>>
>>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Co-developed-by: Dev Jain <dev.jain@arm.com>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>> Signed-off-by: Nico Pache <npache@redhat.com>
>>> ---
>>>  mm/khugepaged.c | 8 ++++++++
>>>  1 file changed, 8 insertions(+)
>>>
>>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>>> index fb3ba8fe5a6c..c739f26dd61e 100644
>>> --- a/mm/khugepaged.c
>>> +++ b/mm/khugepaged.c
>>> @@ -638,6 +638,14 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
>>>                               goto out;
>>>                       }
>>>               }
>>> +             /*
>>> +              * TODO: In some cases of partially-mapped folios, we'd actually
>>> +              * want to collapse.
>>> +              */
>>> +             if (!is_pmd_order(order) && folio_order(folio) >= order) {
>>> +                     result = SCAN_PTE_MAPPED_HUGEPAGE;
>>> +                     goto out;
>>> +             }
>>>
>>>               if (folio_test_large(folio)) {
>>>                       struct folio *f;
>>
>> Why aren't we doing the same in hpage_collapse_scan_pmd() ?
> 
> We can't do this in the scan phase because we are not yet aware of the
> order we want to collapse to.

Yes, realized that myself later. It's confusing, try documenting that in
the patch description.

-- 
Cheers,

David

