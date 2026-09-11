Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545A0C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:19:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BE136B008A; Fri, 11 Sep 2026 04:19:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66FA26B0093; Fri, 11 Sep 2026 04:19:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5876C6B0095; Fri, 11 Sep 2026 04:19:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3555F6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:19:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C071616013E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:19:38 +0000 (UTC)
X-FDA: 85200782436.17.C8D9373
Received: from out28-49.mail.aliyun.com (out28-49.mail.aliyun.com [115.124.28.49])
	by imf23.hostedemail.com (Postfix) with ESMTP id 2D635140008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:19:35 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of yehuaisheng@open-hieco.net designates 115.124.28.49 as permitted sender) smtp.mailfrom=yehuaisheng@open-hieco.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789114777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l5RjTQA3VqnQ3mpEdc0lqlIW62Nn7cAMNqLX6GzFz1g=;
	b=VzOWCvF71ssZia840ehL8zF7d+xn7SIrH47bDsQMDHLnSwCtJfosbBurGDkK8Z081idmvn
	D0Thb8EbNl8BVAGyldQ83amI16hNtK5K0yH0a4XhJJLHlYR4fMBvHcaVcvnCEpE8UnzZxg
	MQ+oFqw746TeOlIS5sMGDaMrns9WVnE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789114777;
	b=cv+2zaGD5JuoIss4OaIGlDWImktegNw/vhiKhrpTZPrzWYaaEmQz0fV9GOsj3ZsVPRtDp4
	hD6JYUxXWhE0pkLYyKLJvtyPMKhe5iL39Wbu1yR8CAdV4eAKqRWnW0bUDHxSIHu+Jsa7Ih
	ubRRahUwksksTDiYwY4sldWXs0BIt6M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of yehuaisheng@open-hieco.net designates 115.124.28.49 as permitted sender) smtp.mailfrom=yehuaisheng@open-hieco.net
X-Alimail-AntiSpam:AC=CONTINUE;BC=0.09209158|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0787936-0.000257506-0.920949;FP=7864596658906816633|0|0|0|0|-1|-1|-1;HT=maildocker-contentspam033040074035;MF=yehuaisheng@open-hieco.net;NM=1;PH=DS;RN=7;RT=7;SR=0;TI=SMTPD_---.jB9h8rm_1789114770;
Received: from 172.18.22.180(mailfrom:yehuaisheng@open-hieco.net fp:SMTPD_---.jB9h8rm_1789114770 cluster:ay29)
          by smtp.aliyun-inc.com;
          Fri, 11 Sep 2026 16:19:31 +0800
Message-ID: <17ebffd9-1ec3-4a34-85b5-fa00eb516478@open-hieco.net>
Date: Fri, 11 Sep 2026 16:19:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: account for allowed nodes when gathering
 surplus pages
To: Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: osalvador@suse.de, linux-mm@kvack.org, david@kernel.org,
 linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
References: <20260909074642.7308-1-yehuaisheng@open-hieco.net>
 <8A0F6014-4E2C-4F07-9732-2DF32418B986@linux.dev>
 <20260910152026.5bcf5c5d7f1ecdcb0147ceaf@linux-foundation.org>
 <35D58CFB-BC97-4245-A387-DB3077E395C3@linux.dev>
From: Huaisheng Ye <yehuaisheng@open-hieco.net>
In-Reply-To: <35D58CFB-BC97-4245-A387-DB3077E395C3@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2D635140008
X-Stat-Signature: b4w37wmpcysq5q1stfk6thcsc17jhowj
X-HE-Tag: 1789114775-256005
X-HE-Meta: U2FsdGVkX1+62FFOsceJEP3I8rSi5lV+7o/3bVl1fUFE8EQXeu9gHSjQtZH8ESwPFN/RWcnkr0hDQLkQHfdxoOvYTCTFu+Sew/hYvft1Se0w19xLoXOKc6aferB5x/YuOnm4KgvgAeXHBs5zdCzpua9RpYI3ZQBvBmXcLCoRM0L2q2gV3K2uqo5Vtqfv6ck70UVdfbHVejjCEn8mdrQ8B9OVgzv/C1PLtCFvZJx+WbNHz+u02SQr1PKTxyd377nUOSs2KgESCKIWeKs6ZSA44KHIzW7cK+bG0kZi77Sw3lZYw+Z+UENYgcWRPJ1MMo1KFaoonCylzObj+fDx6xBhKsNGd2jR+2fpdCcPmIHPRj8B6vWumi3dPjSybZYU9izaspd9oYm+8mnqrxkh6kWt6D3iUGdTcuqNovNIMVc8YTyGjgSHanKDQU5ptTWcoW+vSrlT85u8UiEu68zpdRsAyW0Oxbyx3MzQkVwwM5QZcXIove5KH2mtnXLHHpoX9m8SXWP8rttocfMhhppe10aDQBYSFe+5joLzaehoHl7+QHn9yGERKt821B400mHMQyswAwwTkbRlFKnFswqNYfc6r/Gk9nQXBKOk42HF/m6B6YUmBxwUxcFcQd63VhnUkoMU9KgjSFAf/CJOR40QizvwcK6D6q73g5y8HcR7yZx5w8Oh5ll+RFCntl5SDu1nUqn78ccQ4r76Gkw9dTPhA3ZAz6TlzjQISinm8mJl2y5paJVqRjkfBM12RydWoIZtA6OyO5r/w9RDVQMgtpzVqXgLy+f3dzG+1kzfXbGyxmgSkvNGMYxWbrY2FobR5TcX2CoB+zolTSlwCTk0SJCo9Pn2ME+brjcbfcGO0I4y2ixqX5EOtbiUtRzESzuZow3Iewe/6w4Zpcz82AMSHYNuEk3m6zCGvpo7RP6rYrPVRiS2lay2nwlG1vhp6dM75arjM6s8PzZtezZHMpJeniFb2Wl
 HYIP2n0K
 3MfF901cUYERusVt/Zib4qU29LaUZvsBnu75HlwKUmKQDKEgTfQ3lRdcw50+qSiMteJaL5te0hmML3PmOwiLCv/dozWXKuYkmjui1fb3aTbTj8DOjIgXA77mIqC8CQVG33PW3ypwotX3wZhpDckjai5cuw4le3NnX7C1nWCnYwHZ569oDqMZeb/dGstXanUVFaoBVc2LKnyPfnrl4rC7//AJD77/NGPiza0krIHQYpFszRPbc7gCv6OTaw6cortZgeMsCk5dlmn6H2Sd2HA9qTrEL0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/11/2026 10:41, Muchun Song wrote:
>
>> On Sep 11, 2026, at 06:20, Andrew Morton <akpm@linux-foundation.org> wrote:
>>
>> On Thu, 10 Sep 2026 16:48:56 +0800 Muchun Song <muchun.song@linux.dev> wrote:
>>
>>>> This fixes hugetlb mappings when, for example, a task runs with
>>>> MPOL_BIND on Node 1 while the existing free huge pages are on Node 0.
>>>>
>>>> Similar issue also could be found in ltp if the free pages of global pool
>>>> reside outside the nodes allowed by the application.
>>>> # cd ltp/testcases/kernel/mem/hugetlb/hugemmap/
>>>> # numactl --cpunodebind=0 --membind=1 ./hugemmap10
>>>>
>>>> Signed-off-by: Huaisheng Ye <yehuaisheng@open-hieco.net>
>>> Acked-by: Muchun Song <muchun.song@linux.dev>
>> Should we backport this?
>>
>> If so, a Fixes: target would be helpful.
> I believe the fix should be e4e574b767ba ("hugetlb: Try to grow hugetlb
> pool for MAP_SHARED mappings"). This commit was introduced back in 2007.
> Regarding the impact of this issue, I consulted an AI:
>
> Severity: Medium
> Impact: valid HugeTLB mappings can be rejected with ENOMEM
> Scope: NUMA + cpuset/MPOL_BIND + nr_overcommit_hugepages
> Risk: availability/configuration failure, no data corruption
>
>
> The fact that it has only been triggered after such a long time also
> precisely shows how uncommon its configuration is. I expect that
> backporting may encounter some conflicts. In the absence of clear user
> feedback, I personally suggest not doing a backport.
>
> Of course, as the author of this patch, you could also provide more
> information, for example, whether it was discovered as a real issue
> in a production environment, so as to decide whether to proceed with
> a backport.
We found this defect when doing the hugemmap10 test of LTP, it appears
with a certain probability (5%) in scenarios involving multiple NUMA nodes.
After debugging, I believe its occurrence is related to the location of
the regular huge page pool and the MPOL_BIND strategy used for allocating 
surplus pages.
So I moved to hugetlb-mmap with some simple setup steps to make it reproduce stably.

A more realistic scenario I have in mind is this, user uses huge pages in memory
pooling solutions like CXL memory expander or others, if there are already some 
regular
huge pages locates on the local node, but user wants to restrict application to use
surplus pages from remote nodes — and that's when the failure occurs.

CC linux-cxl.

BRs,
Huaisheng Ye


