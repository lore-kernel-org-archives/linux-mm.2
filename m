Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF10C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 07:43:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5036B0005; Tue, 14 Jul 2026 03:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C56866B0088; Tue, 14 Jul 2026 03:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46E66B008A; Tue, 14 Jul 2026 03:43:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 898366B0005
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 03:43:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F0AF61602C7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:43:16 +0000 (UTC)
X-FDA: 84986591592.06.F4D56D3
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id D03AD1C0003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 07:43:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hT0bmfKP;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784014995;
	b=Gw+pFtoUGzvJFlVR7RH1xsh1hERcKc1jBn7R7MNYfwdm4La6ydqIfNNz+3hfilnidxA9Xa
	//6+X2522d/tpUrbWY/kDB+0VlIfbI5LPwHnNz2gmHsgZAHuO1PLRwqwTPlvc8h3iMoofJ
	bZZDltev1XnfZj/DEr4Xo2mR4pRt5Tg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hT0bmfKP;
	spf=pass (imf18.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784014995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0I0BJ125x0ILzpKQzbAIfOkMzFcIP5uJz7O94Fnv8U=;
	b=FKTs7Md0rS+VK8zyDcq1qdEJA2YQuwndWIZh5JSy6hz4lrawVBie26zaXCP3tX6g7piEGF
	5vrVqP4crLxmSCPhj8lf3DSO7G2pKs+wTIIkpr4VcqBVZMTBeWVqGfvwLm20I4n9dz3dgz
	+wZ3r8m2Uvxs2oJFZAak2EnU0wBdV7s=
Message-ID: <0545ee70-b0a0-4a93-ac2c-3e84ff504e5a@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784014992;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f0I0BJ125x0ILzpKQzbAIfOkMzFcIP5uJz7O94Fnv8U=;
	b=hT0bmfKPqQc9pDzFwsqCmtPPFoWQhN08bP7XCztt6T6O9I/sjqP6TCj1HVTvHABehMC/sC
	D5UK+iM2oYcDiV2UGmsSH4Db3ghqh9VfT3omemPDv4Yqjxh37MZa9Q3ToX9mJG0B4UETN7
	atCNfg0O9qKFcAuPjlda6yCvqWeDXv4=
Date: Tue, 14 Jul 2026 15:42:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev>
 <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
 <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev>
 <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
 <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D03AD1C0003
X-Stat-Signature: rtjkkdfndyzq3114yq74hiqzf6khic4h
X-HE-Tag: 1784014994-247182
X-HE-Meta: U2FsdGVkX19voK/7pqLtSFHtMcN4IteAdTY8EBWXFRGX3iIYrDhao5VdQf6g36WxvPWktPzfNHldM5iGfNcwnsWVfQw1b1N0XrEk6UfSpHSd/hfQa+Pzy5OxLP03K4/oAbYeRhtsBxq5d9nxyYbWvk8WPsh2KytCcaFQsySjdbDX8K91HdxYUppQZjY9WxRq7K4Ue8OKyJq0fQy3uvNBjrfMKgxtxBfBQaVVHvmlby4hZBoOqrAqckg2FcCJhQUAVFBoX70aLRZBiQHn3fL/Kl3H+8DfvxhsGZPEGCgMsIU9jQ6xSZsWLVB6PLQsJD5yus3bsdW+VCIICvBMXNd81h6G7ZfLeBWK76g3CrWUdXElq3PgEJuDG3E2SSeXt/naPcU3UWjVLS1jvKq6xGEyYCTsuZEr7sWHMKOLn/dVXdxB9MvnvWDI9Rg369InXMcNU65y9yk+lEEz5PmWwUJOmesiGlJ/BKuaxWDFFI/osC8LRNGqNNR6oRXMsTfssXNCEyXEQWe1C5py+Tg78k5/BtVBjZQQhcZ+5SQ+Ybgw5cs61LPlzxFb2dK3c9qfCpBQUMPCpWIGIOLk0YL/3pg0tSsmzD2S8x60GmEIJI6ghDO++ysJHZ927Pfz2YmaBKM9XXQPeL6dDMj4j7JA6xwR00Klg4yd8WGX+xEuwIAwnRnVFjbgOkEjq7nZX95/8TkoB4Eb93Lr2+M2IMcfpzRqmYLQjF/Iog1QkPReQEH6UEgt8b9wAPXvBQEX+cF4j9WHExV0qK3iW+ifvZVr92AHA/aCYY0twSqMYiBPwMTn0YfrkzrG6YScWBscOnBPnqVVBQAws5hI/jNnUsQX6tqQClbls4f3wtBh+rHoTD8tZ/chkFX0+WqovVnZSFgmXlOzxrTBYHo0AtBXHHVEEPkLgSO52Quf16dD2y5VdiXbKdDQEr1Z5R+5YIxIHZeCN9eiPL3FOiX+NA8FDxBxFK2
 gtGbGiKH
 1VwlW+JSgy1zwTZudFAWErykM0YtYlttnxPmV+7xujQOzc3Z/M+G+WpZ8UsnZVqyb9y1SCmIYDbv08QbC6OLrI/S9UMMxwtuhe9M9D4/26j6guDTiftWcRHXfqX/VLsZ/kajweBqmo3qcMpYSl6/E11oYMLjw3XQh8dwEl9+DXevS0C7DtkPTieD/ws9IBgiXYOXHpn1s4yWHtvn45yfd+v7S5dZnLdV2RfbJWVttwELT/C4BzVeu3cJQ8Zliv56oOdmDLHS6jGUU/D7ErCF57m999uyT60YHhHGuEE2u1kJxLbeD7T3LQ22C8nLAmTqf6msP606hyXzRg5HcD/LFG4MJ1xgh3VlD9KTaM15QGouiGVIyMM8hovk9T1wjOpK7OyfrL5D5CT0Ab1rNBU3c7BYoCGH0PtZ19EgR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/14/2026 9:48 AM, Barry Song wrote:
> On Tue, Jul 14, 2026 at 9:43 AM Barry Song <baohua@kernel.org> wrote:
>>
>> On Tue, Jul 14, 2026 at 9:20 AM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>
>>>
>>>
>>> On 7/13/2026 11:08 PM, Barry Song wrote:
>>>> On Sat, Jul 11, 2026 at 5:12 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>>>>
>>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>>
>>>>> The per-memcg swappiness knob is v1-only; v2 always uses global
>>>>> vm_swappiness and ignores the per-cgroup field.
>>>>>
>>>>> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
>>>>> to memcontrol.h where it belongs.
>>>>>
>>>>> No functional change for v1; v2-only kernels drop the unused field.
>>>>>
>>>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>
>>>> Reviewed-by: Barry Song <baohua@kernel.org>
>>>>
>>>> With some nits.
>>>>
>>>>> ---
>>>> [...]
>>>>>           struct mem_cgroup_per_node *nodeinfo[];
>>>>> @@ -365,6 +366,9 @@ enum objext_flags {
>>>>>
>>>>>    #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
>>>>>
>>>>> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
>>>>> +extern int vm_swappiness;
>>>>
>>>> This is a bit unusual. I'm not sure whether mm/swap.h would be
>>>> a more appropriate place for this.
>>>>
>>> Thank you for your reply.
>>>
>>> The vm_swappiness variable is not utilized within mm/swap.c.
>>> Furthermore, since memcontrol.h does not include swap.h, retaining the
>>> extern int vm_swappiness declaration in mm/swap.h will result in a
>>> compilation failure.
>>
>> If this is the case, it still seems better to keep
>> extern int vm_swappiness in include/linux/swap.h.
>>
>> Then we don't need the comment:
>> /* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
>>
>> It also makes it clearer that vm_swappiness is an extern variable
>> belonging to the swap module, rather than the memcontrol module.
> 
> BTW, if mem_c_group_swappiness() and vm_swappiness are only used
> within mm/, could all of these be moved to mm/swap.h and
> mm/internal.h instead?
> 
> We are making a big effort to move many unrelated things out of
> include/linux/swap.h recently. Could you check?
> 
> https://lore.kernel.org/linux-mm/20260708-ch-swap-series-plus-folio-lru-cleanup-v9-0-2bc72b4f8730@gmail.com/

Good suggestion. Moving them to mm/internal.h makes sense. Will update 
in the next version.

-- 
Best regards
Ridong


