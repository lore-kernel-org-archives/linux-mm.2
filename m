Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80643C55ABA
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 02:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CDF46B00AD; Wed,  5 Aug 2026 22:09:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87F126B00AE; Wed,  5 Aug 2026 22:09:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795546B00B0; Wed,  5 Aug 2026 22:09:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E05F46B00AD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 22:09:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E8441A1F2B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:09:26 +0000 (UTC)
X-FDA: 85069212732.30.047A2E7
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf29.hostedemail.com (Postfix) with ESMTP id A8A68120003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 02:09:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kEXEZaV8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785982165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KS3/u0KLCKkqSSDwGn2Vc1BlCUjN8EyDD6wTU52hM6I=;
	b=KL3cDvtIcK5o/jqBMF0lhbG3bfR1AKHuOfBDEL3sbVba6aG4EsqpNKAsMr/JNDGlIud0lS
	8EFjp0WPBIUAWwhzE144X5gSbTyM0Od51sKPJF25o7xCHeMgU1dU8nl/++/ZfTYaxqSAcl
	BMMgmHZ6PnXemlbClAkvIfAUY7fLzTQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=kEXEZaV8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf29.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785982165;
	b=qqUfxed57teou9TEg95vqzoP9KDqZNpt/t5FB+ZHSlKzdHzEQ1pa3DB6OnNvzkMTmPVdBL
	x0CG6w2Cx84k/L1IanyOFl5F7xFcoCWAsKMPpQ1t+dakk/GLXEBHFx80mOxhHT0xj+l/c2
	UgdUMpbKlWyggxfCQ0sFsmI13asnGsk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785982158; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KS3/u0KLCKkqSSDwGn2Vc1BlCUjN8EyDD6wTU52hM6I=;
	b=kEXEZaV8Jpqnh+Af1Xd2I4Jf7VVr/QQ7BerMpjo1NYXW5Xf1zEuFVTDnI/gmL90W9JXPiK8mhq6x29PFf4HaVgk1YLQfRX6eNMAeiMmbZGTZN6xaxhMvKRiNvB6smCaWmo8gNNfAmaZEL3BiGrjw6qx/3qXrynaV40wrrXZKIqo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0X8SUsvH_1785982156;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X8SUsvH_1785982156 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 06 Aug 2026 10:09:17 +0800
Message-ID: <3839ab40-da16-4085-94a5-0fa78e6052df@linux.alibaba.com>
Date: Thu, 6 Aug 2026 10:09:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] selftests: mm: add mTHP collapse test cases
To: Zi Yan <ziy@nvidia.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, nico.pache@linux.dev, dev.jain@arm.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <cover.1785564857.git.baolin.wang@linux.alibaba.com>
 <dd8013c1ddada90913876e3bd912c07e613fba8d.1785564857.git.baolin.wang@linux.alibaba.com>
 <DKH5VECNN2LF.M3RGFY0NORWI@nvidia.com>
 <8551bb7d-945c-4be8-b7dc-01ff15fdbc76@linux.alibaba.com>
 <E5080E9F-980C-4445-9C19-9C792270A751@nvidia.com>
 <e17f9ee5-6606-46a4-a756-9d7a5462cd45@linux.alibaba.com>
 <C9F48004-554F-4264-ACD7-E514360D73AE@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <C9F48004-554F-4264-ACD7-E514360D73AE@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: 1ui1dfocxaq3zsdxr58rqk6618k84odh
X-Rspamd-Queue-Id: A8A68120003
X-HE-Tag: 1785982162-310502
X-HE-Meta: U2FsdGVkX18EtLFiZBKnk+8AjQAI931ixvA+ekQzXCzDaKY/+9s480iJvj5KmFsb199QJRfq0zg+FtnRqgtbB8XVo1rsz29Vmvpt1mtyC3mShSCz8qFizf+Wo3P5CmoAGXAaM2Rfb0kcAErnSKLIqoMdCERVoLqePxbefW0w+6XP3ZerTpTarohjDu/uZcoWWuSnGrkP7KuZ7fE7CrgYrwJ1WLkQCFa+OMm3CwOHktBZOFc5ooi3ChDMXo4uNRi2h/HPHHFI2q7rxM8ymIK3Rdj7mf3DfDzxhm8miDZP9JES9GtpsGJxcb1V4v0xRY09PmtDluOuDNOllSW9FPul1r7cD5x/FFZv/lYHJK5MS3AoxsKUSMWMB6JIfMzZf0hY7e/6QPK0ZD4fWyFObbSh+Xk6+NtvJxvjjQpDSuM12tMJL3htq5kxBTvpFQJp9IYdcBupfrVbrTk55eaaHhh68ckuH0O7YoXuETMKgLEfIAQ/5OzXJSJAemhnm7T3CHARU+yDlG5heGYtSJotL1TjAqBA9UZasv5e7BptEigNs4zbmvzljG2Wv6bFecUiOPupTwZzIyh0Qt1h93+eNU0VGkQYgH2K7/G3Rxrno9hw65WFfSgYe48vOk6TmNl3BCA3yL5RtBKP/pWgTXWV7NDhqXqL9mGIN9sYKRV5Jja+Z58vOl7ROX+gthUie98QqZbp/2mhCHOsMxwz2zmk6WZWfCxtycYwQScob9X77xVvaAZagRM7ce/W58H0iEKeAaQ2angAmdiVQd85jwxp4SlMmA66Zre1Osi809/M7Mf03iGR4BDWLsvjaMFV+7wLGsBGeeRElDtXnUKuWgMS5gQQcd3n/nCH9JvddvdYCvch7TrjliWmBOlOxb/CBHtuh+dNrk2K+1Ick3VIxOc3wjXGBG99m0yxU/xvZlafjoJBEW7SZRiuoh8IH34fgFbMQh1vn7+t5XzaYfJ++UWaDLJ
 qzADmOiy
 L8d+DBrHBy8gITqlXvGyP1zFQ7V5JqsQyxkeb3pAPlx/HaFzU7cIKETiYg0xdXS2sz0DPWNmFBGGa8wN6vRBIHDtb7MQAd395a1qCU+kda7XtcADat3YMA5kWHmbupYtmSm8wzBol8Lwz29tfDTfu0fDyg/lLnkNorzVmbtDOVJjr1DRt/RX5BplTi49XiFRnfRj/Yg/rCy+fdMLEqGSK0OW+uUPBOP+HfSTDftQLGd158nuN4jeQ4m4MvcHA6G5xj2LAEVOLNjLmY26BuxPsI3FKzfZ8cQwU5rXILtVk3ai/X1j+gP5Cx0kaTNoE5rxIx6xejez0VBJHrjE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/6/26 10:04 AM, Zi Yan wrote:
> On 5 Aug 2026, at 21:30, Baolin Wang wrote:
> 
>> On 8/6/26 9:25 AM, Zi Yan wrote:
>>> On 5 Aug 2026, at 21:17, Baolin Wang wrote:
>>>
>>>> On 8/6/26 12:46 AM, Zi Yan wrote:
>>>>> On Sat Aug 1, 2026 at 2:26 AM EDT, Baolin Wang wrote:
>>>>>> Added a new command 'mthp_khugepaged' for mTHP collapse, along with the '-c'
>>>>>> parameter to specify the collapse order. Additionally, added mTHP collapse
>>>>>> test cases for 'collapse_full', 'collapse_empty', and 'collapse_single_mthp'
>>>>>> for anonymous folios. All khugepaged test cases passed.
>>>>>>
>>>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>> ---
>>>>>>     tools/testing/selftests/mm/khugepaged.c   | 130 ++++++++++++++++++----
>>>>>>     tools/testing/selftests/mm/run_vmtests.sh |   2 +
>>>>>>     2 files changed, 113 insertions(+), 19 deletions(-)
>>>>>>
>>>>>> diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
>>>>>> index f69be6be0ecd..64d6da6aa90d 100644
>>>>>> --- a/tools/testing/selftests/mm/khugepaged.c
>>>>>> +++ b/tools/testing/selftests/mm/khugepaged.c
>>>>>> @@ -26,9 +26,11 @@
>>>>>>      #define BASE_ADDR ((void *)(1UL << 30))
>>>>>>     static unsigned long hpage_pmd_size;
>>>>>> +static int hpage_pmd_order;
>>>>>>     static unsigned long page_size;
>>>>>>     static int hpage_pmd_nr;
>>>>>>     static int anon_order;
>>>>>> +static int collapse_order;
>>>>>
>>>>> <snip>
>>>>>
>>>>>>    diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>>>>>> index 687d115e3bd8..d09f9f6a384e 100755
>>>>>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>>>>>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>>>>>> @@ -410,6 +410,8 @@ CATEGORY="thp" run_test ./khugepaged all:shmem
>>>>>>      CATEGORY="thp" run_test ./khugepaged -s 4 all:shmem
>>>>>>    +CATEGORY="thp" run_test ./khugepaged -c 4 mthp_khugepaged:anon
>>>>>
>>>>> Why only testing collapse_order == 4? It is more useful to test all
>>>>> possible mTHP orders. -c can accept common separated order and a range.
>>>>
>>>> This also follows the previous '-s' parameter configuration, which is used to specify the mTHP order allocation.
>>>>
>>>> I think specifying a single order size already tests the overall mTHP collapse
>>>
>>> Got it. If a single order covers the flow, I am fine with it.
>>>
>>>> flow, so I'm not sure whether testing all orders is worthwhile. Maybe I can add a few more orders?
>>>> ./khugepaged -c 2 mthp_khugepaged:anon
>>>> ./khugepaged -c 4 mthp_khugepaged:anon
>>>> ./khugepaged -c 8 mthp_khugepaged:anon
>>>>
>>>>> Why only testing mthp_khugepaged:anon? IIRC, file and shmem are not
>>>>> supported, so khugepaged should reject them, right?
>>>>
>>>> Currently, I have not added test cases for shmem mTHP collapse, so adding file or shmem would be no-ops and might mislead others. I will add the shmem/file mTHP collapse feature and test cases in a following patchset.
>>>
>>> Right. I mean when one specifies ./khugepaged mthp_khugepaged:file/shmem, the
>>> program should show some error like “file/shmem not supported”.
>>
>> Yes, that works too. I still prefer to add the corresponding test cases after I add shmem mTHP collapse support:)
> 
> Sure. Or update usage() to print “mthp_khugepaged only supports anon”. You
> can remove that after you add other support types.

Ack. Thanks for all your valuable input:)

