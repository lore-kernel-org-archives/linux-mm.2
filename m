Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1310E91289
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 07:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A69226B0005; Thu,  5 Feb 2026 02:29:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40BD6B0089; Thu,  5 Feb 2026 02:29:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915F06B0092; Thu,  5 Feb 2026 02:29:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6D36B0005
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 02:29:03 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 200F5160458
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:29:03 +0000 (UTC)
X-FDA: 84409576566.30.46AB2AD
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4178C180009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 07:28:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4EpXynxz;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770276541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9gE+wocAEYGAhpH+Qx7f17X+XfuZxkf0I1SRp2D88Ss=;
	b=SgF+uDtjIcTZjCJ/eRJJWifpDzo+HqODUclhERuvI+/Cxsat77KBruQoIOXPOgTUMiWfw6
	ReaZTxBkE08vloNe/PQXJOD/XHlX9/YdgyPTeW9fodOPBtvK6Ch45ODUspV59eocb9rB3O
	CXrmXcKcFo6Hw3Fr7Rub5Upp7ffGgyM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=4EpXynxz;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770276541; a=rsa-sha256;
	cv=none;
	b=nT1AvEqpLKQpn4/4uOn7sbOHoWR7USLyj4YQOf+uW7huOsv394SHgdLBuBiFZtS8CXM15X
	Wi8xqLfysRhVfqoqBwNdMsS0NhP+/ZW3y1alTgucR60w9/A8TCJWT2SHh5pU6K4I+x0Cy8
	G34NTHJMsBKQdcDnpJo674oDbaCF7RQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9gE+wocAEYGAhpH+Qx7f17X+XfuZxkf0I1SRp2D88Ss=;
	b=4EpXynxzOMmyGsO+mz1AV4zK9QxsASNxG3WgHKFUWAKKgH7TXVu+uqq28/0gvmzW1RySs69SW
	W0//IlhBtx304X3nXsCZtvfswyZXNHObTWYbBOlZ4PeRgvnRnc8HZkv4hPnXSWqVwC521dEOSkg
	QtuNW+SLojLNNglXYbViLVs=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4f67lM5w00z12LDJ;
	Thu,  5 Feb 2026 15:14:55 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 7C9554056E;
	Thu,  5 Feb 2026 15:18:45 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 15:18:45 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 15:18:44 +0800
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: Zi Yan <ziy@nvidia.com>, <jane.chu@oracle.com>
CC: "David Hildenbrand (arm)" <david@kernel.org>, =?UTF-8?B?5piv5Y+C5beu?=
	<shicenci@gmail.com>, <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
	<linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
 <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
 <48978612-6933-4897-85DD-6740B6C8570B@nvidia.com>
 <25CA4D90-A24E-49C6-92D2-08080EC81466@nvidia.com>
 <032058DC-CD8D-406A-B986-740E41C834B2@nvidia.com>
 <e97d5c0c-b8ec-4da4-b838-7a308f8a6327@kernel.org>
 <61BBEF63-20D6-4671-B7F7-F015D49B2080@nvidia.com>
 <1bfc9e64-2961-4d2c-a6c3-fb123f66e6cc@kernel.org>
 <94DAA11B-597F-4F8F-AFFF-9D7626A7C091@nvidia.com>
 <7d5754dd-8cf5-41f3-a767-271b28b1f63c@oracle.com>
 <c5206f67-1e9e-d487-3514-8867f00cc626@huawei.com>
 <85CB7DEA-79EE-43EE-BA9B-C2AC81F6FA02@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <225f0193-e27d-bad7-56ec-09cdaed64f71@huawei.com>
Date: Thu, 5 Feb 2026 15:18:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <85CB7DEA-79EE-43EE-BA9B-C2AC81F6FA02@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4178C180009
X-Stat-Signature: cwtqgaaopbf48odu3uqa9kmwy57pr998
X-Rspam-User: 
X-HE-Tag: 1770276539-920062
X-HE-Meta: U2FsdGVkX18kbcrt85FXooCfVZuIdhGduEmNVZsOoO8gwWkaWYPzwOWbbxS5q+LsX23KKI4z1LSOtxnHTsYDyLZi87SxBce5QLZ98zFNkT2gixvlE3XONYkd04leY2cnXLgu5ZFDu6pRTXOc/2MCOpOPIirNQGvz7wGWf8oNcENj4XXkfwkr5pdMZwHtV4lAt1FR2pU5bqKccb8sZqs4mwwJkyR4P2qc5mB4INDdKXdRIJVJhXi9Ag49p8RTtZ8qRCIUFn9Airt6UMSZ8Hk0BRmlnl58G3Otxv3N3/Lu7yjIQKpjE+Fr1jRbWuuE8UvV/c42LQwNC/AQavRdl0SM+00mIP9Uyrsnm90L0QJ9UMhcxS+xj3Na9ZbXuMtGA/EP5eETwAeVCj9aTiUyi0q8xVCQv+PgRSkgmJU49FSaLnykfBoJMIHPCH7+A5afggspx9C8yGCtMVbPcfhzceKo9ITRU1tgL/4XzSel4SaSIeWZ7XHS3akfd1iNkJeG6/fCz02Ar95kIj5hJDlF2LWVZ0JV/dwzu4nF3EbAiBFniiUXJ8UspW4SPV45hKwkCZStZr8a5CMTujyxrjilmomP/+BsdXLKSAsb9wcTYVrCRjDqwTdRtcIZ4KSFIMde5/aDmwuZHA+zRqUcDWCyql2MFIaZutfrzURjvEsX73qrgwOdQLcxlam1/x29co1NRp1LKYtOfZO1P2VNAqg+cq6SMGWwO40arOFwgTz802dIK2dCug3dtpo/R2bDvfVpcpyX4WWZ8W81XyXYGR0E3/qXcZG6iiJE5ZLIEwZRu6kj81zLVmB7Ck7fq+d4XpYg55lsAdC200sn+fn6L/QZQyDarTFWKo9T+KXjFq/Mw3+FkXhPTREWVKxtP/0yAeHOwq+MWZ7Wac7ai4KPo3AK1z4qDTjn4e43lWyNPnjkaxhJTBBD02DmkOn+/HhxPyYkkI2zfZN7pJeb5AHhbLBOwNJ
 jSIYn882
 zz2b3Lyq6OMzaB5aBUBlXTb3cshPcZo+kKc7vaOH0ofIg0ClnO8xfX72uyyFGHBgr1aJXmoboxdnQksHFhLebvUrPjXwDqeHgPjGBeV8sTu6unbOrFEMvMgMJUwJ9zZgdnctc8c9Rvjogjc6liPMITaX1uMs5rMt9+KtO3a3Y22KJyE/6qOQBm2nS7Eh8IgAsO810UMUXKH3IOcOw3H/4txWeAH2xRgxP3NtETBt5OfSWMXVBiPd+cQOZxu3UX2LM8H6Z9w+V5UHAX3WBcp0ZyZWISceEvOCbgf4L0/x9l5S+qOHdX7TSN1lXaPnGt7FhTLfmN+7gnqELKHb/8aLNbDbUqrxb/JJyEByWOPwTSlr+ERzBAH81APYeicNhDM60/tmj1uMh3Qxarq8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/5 11:53, Zi Yan wrote:
> On 4 Feb 2026, at 22:21, Miaohe Lin wrote:
> 
>> On 2026/2/5 10:00, jane.chu@oracle.com wrote:
>>>
>>>
>>> On 2/4/2026 1:41 PM, Zi Yan wrote:
>>>> On 4 Feb 2026, at 16:37, David Hildenbrand (arm) wrote:
>>>>
>>>>> On 2/4/26 22:08, Zi Yan wrote:
>>>>>> On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:
>>>>>>
>>>>>>> On 2/4/26 18:41, Zi Yan wrote:
>>>>>>>>
>>>>>>>>
>>>>>>>> More details:
>>>>>>>> later at sg_vma_fault(), the driver just handles a page fault by supplying
>>>>>>>> a subpage from a pre-allocated compound page[3]. We then get a large folio
>>>>>>>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>>>>>>>
>>>>>>> We can identify such non-folio (but compound) things by looking at PG_large_rmappable IIRC.
>>>>>>
>>>>>> OK, back to the issue. The patch below should fix the issue?
>>>>>>
>>>>>> Hi 是参差,
>>>>>>
>>>>>> Can you test it?
>>>>>>
>>>>
>>>> <snip>
>>>>> I think you have to test for folio_test_large() before testing folio_test_large_rmappable().
>>>>
>>>> Oh, forgot that. Thanks.
>>>>
>>>>
>>>>  From 8dda4bba9964890462eca3ef3cce57bb4fab8313 Mon Sep 17 00:00:00 2001
>>>> From: Zi Yan <ziy@nvidia.com>
>>>> Date: Wed, 4 Feb 2026 16:04:19 -0500
>>>> Subject: [PATCH] mm/memory_failure: reject unsupported non-folio compound page
>>>>
>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>> ---
>>>>   mm/memory-failure.c | 8 ++++++--
>>>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>> index 825c706ac576..137c67fda57e 100644
>>>> --- a/mm/memory-failure.c
>>>> +++ b/mm/memory-failure.c
>>>> @@ -2440,9 +2440,13 @@ int memory_failure(unsigned long pfn, int flags)
>>>>
>>>>       folio = page_folio(p);
>>>>
>>>> -    /* filter pages that are protected from hwpoison test by users */
>>>> +    /*
>>>> +     * filter pages that are protected from hwpoison test by users
>>>> +     * or unsupported non folio compound pages
>>>> +     */
>>>>       folio_lock(folio);
>>>> -    if (hwpoison_filter(p)) {
>>>> +    if (hwpoison_filter(p) ||
>>>> +        (folio_test_large(folio) && !folio_test_large_rmappable(folio))) {
>>>
>>> Just curious, would this filter out pte-mapped THP/mTHP folios?
> 
> No. All folios (including pre-mapped/mTHP ones) are large_rmappable.
> 
>>
>> Thanks all.
>>
>> memory_failure() can meet various types of folios. So in get_hwpoison_page(),
>> HWPoisonHandlable() and PageHuge() are used to check whether the folio can
>> be handled. But in madvise(MADV_HWPOISON) scene, MF_COUNT_INCREASED is set in
>> flag, so this check is skipped and warning triggered. Might HWPoisonHandlable()
>> check be always used to make sure the folio is in sane types? Something like
>> below (i.e. remove the MF_COUNT_INCREASED check before calling get_hwpoison_page):
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 825c706ac576..ba4231858a36 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2411,31 +2411,29 @@ int memory_failure(unsigned long pfn, int flags)
>>          * In fact it's dangerous to directly bump up page count from 0,
>>          * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
>>          */
>> -       if (!(flags & MF_COUNT_INCREASED)) {
>> -               res = get_hwpoison_page(p, flags);
>> -               if (!res) {
>> -                       if (is_free_buddy_page(p)) {
>> -                               if (take_page_off_buddy(p)) {
>> -                                       page_ref_inc(p);
>> -                                       res = MF_RECOVERED;
>> -                               } else {
>> -                                       /* We lost the race, try again */
>> -                                       if (retry) {
>> -                                               ClearPageHWPoison(p);
>> -                                               retry = false;
>> -                                               goto try_again;
>> -                                       }
>> -                                       res = MF_FAILED;
>> -                               }
>> -                               res = action_result(pfn, MF_MSG_BUDDY, res);
>> +       res = get_hwpoison_page(p, flags);
>> +       if (!res) {
>> +               if (is_free_buddy_page(p)) {
>> +                       if (take_page_off_buddy(p)) {
>> +                               page_ref_inc(p);
>> +                               res = MF_RECOVERED;
>>                         } else {
>> -                               res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
>> +                               /* We lost the race, try again */
>> +                               if (retry) {
>> +                                       ClearPageHWPoison(p);
>> +                                       retry = false;
>> +                                       goto try_again;
>> +                               }
>> +                               res = MF_FAILED;
>>                         }
>> -                       goto unlock_mutex;
>> -               } else if (res < 0) {
>> -                       res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>> -                       goto unlock_mutex;
>> +                       res = action_result(pfn, MF_MSG_BUDDY, res);
>> +               } else {
>> +                       res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
>>                 }
>> +               goto unlock_mutex;
>> +       } else if (res < 0) {
>> +               res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
>> +               goto unlock_mutex;
>>         }
>>
>>         folio = page_folio(p);
>>
>> Thanks.
>> .
> 
> This makes sense to me. And it gets rid of the warning as well.
> 
> Can you send a proper patch of this?
> 
> Feel free to add
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Zi Yan <ziy@nvidia.com>

Sure. Thanks for all of your work. :)

