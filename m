Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F2B5EA7945
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 03:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C2646B0089; Wed,  4 Feb 2026 22:21:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 769136B0092; Wed,  4 Feb 2026 22:21:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D506B0093; Wed,  4 Feb 2026 22:21:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C52C6B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 22:21:20 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAD8A1C103
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:21:19 +0000 (UTC)
X-FDA: 84408952278.08.241F8C2
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0538F12000A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 03:21:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s4LUiWGC;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770261678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyyA1PPt7lfcB8CKs4wjIz9KHF1gMnrJMFjQaE0YHQ8=;
	b=x74LQrXggjlXHv2z9HznUoFi285htKexZT1B1POBBM3UiNML+RCHPoi0vr9/o0vh5GeT6e
	x2fy0WDBSml/PBjn/7hXAXmWjz5AyLj1H/dFz106EyTmM0EmUh3A1dxdblCOz3FCIA1bFb
	IVrsIEGAn5eIRZ9Y39TWdPSRg437BSU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s4LUiWGC;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770261678; a=rsa-sha256;
	cv=none;
	b=FYrGxMZ00zh58pX7xsQY7BGVmDl4jYZfCao+DHcvFZ6w/RL14/q+Zc0G9SEXZiC5TdCOFY
	jXQUeLHiocUJaSroaiLp167MG1fLaVvGAnWT0bHit0wQaJIZejAhIDYIMUeXbHsLEs30Wf
	gT/VlCTeVjrcM1gPO+Or4c6PJ+lYSDM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LyyA1PPt7lfcB8CKs4wjIz9KHF1gMnrJMFjQaE0YHQ8=;
	b=s4LUiWGCqQZAkW0B6mOkXEBOqMMP0TCbhQLWY/7IMJcNDgk9KFb0gC83uJb/+Cdq8eesSLyWj
	RQxyp6eSVPhZ08RLr/bLU56Wgoj7kL/ny3J5YlqlUF6Ennup2KtfLY0A6b9SxlYLRT8iGNiYeo1
	PBZffgnj1gjijaIDWK29Pho=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4f62Sb6T8Dz1T4Gw;
	Thu,  5 Feb 2026 11:16:47 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 5C02A40561;
	Thu,  5 Feb 2026 11:21:11 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 11:21:11 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 5 Feb 2026 11:21:10 +0800
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
To: <jane.chu@oracle.com>, Zi Yan <ziy@nvidia.com>, "David Hildenbrand (arm)"
	<david@kernel.org>, =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>
CC: <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
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
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <c5206f67-1e9e-d487-3514-8867f00cc626@huawei.com>
Date: Thu, 5 Feb 2026 11:21:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <7d5754dd-8cf5-41f3-a767-271b28b1f63c@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0538F12000A
X-Stat-Signature: tg37z5c6nxwwwmgnnwxb5r3tcc38k8ep
X-Rspam-User: 
X-HE-Tag: 1770261675-47595
X-HE-Meta: U2FsdGVkX19TJAbF0HkpOiPlYNSiEdOOE9d/ylzw7/hoyzLys00kibDtcUfE6miZ/mLWsO6fPR8LPE20lxIpV2p1A0AHEUquhTDqSngmG54SV9TSV0cRjBSLE+Gm6bWeuSnjUSxx/gIxCcW04StQEO2mUfRlkELQjSIoa+/ia/TN5X6StmZkHdjjBu6q7OECwz5vgFr9i3TYk8l/6ec2WiaETeEZP3o6Ga6yfQ2JEIpHxCowozIYyVHdNxuGJ27XktWg5bDJUlvEhDEU/kcviQDtTjXjZit/PWy59bNzo16qTB1DGqRIdQxKn+HRYJkxeQF3Bf8uk+Qo3ddsoT2VvORGMbGEwhnRsvI4sZtAdHfp/WEN5DsnpWAH+L41T/MReiNgwIevhDpJjRLpp041P2Mju84uxHUFee5KShzPBjCfX3wo4/qlFNJg/ahtKCrSVd8vKJc+EZqwEkfHfIft+gDl9+5H5JtMW7RSVNjLRt4meogpwjqajYdsHvXej5UGMM51KngUMvqO7mLYo/bySru/zi2HIkTbSyatQiE0JRuOxyc2USW+T7f0nXQ5U/cRpU/WCb0KNPNPCQfNWJSBMEnnVCPSFUjJdfzZcO8hv7kowI7aJmJqSCxJBIHrz2mUMX4vin8yraEOxKWD4dHLG17QYRpea1jCD7HSjmi5m8Ho6cZKohQbo0CVIH4kkxGzAbWP7pBRXvzxvajgle0LzBE5WQgRsxTc1qFwfzok2jakoKByXVLL1XtqQ0RWR5enz8B+m843x3jKPpgaCz+nb3t3Y1gV0Lehyr4hISw/HmVpp4UskaIMB8ITXdKxJqZfluUvE9RXy2Y6NhwJRQrBFiWgfYipZSZDh5zLarLZICPDGb+sRftQ/dovQTTNhJsfDU2tIqGEed/OHX78dsUj9my1INDMEQACK8HvsDx+IXev3lWCS3jmRyXAHMgSZXMm1hj4IFtscG20Om2H/5f
 YipwiN8b
 aPks1w9odmtSRI8zVwIn+IKgzkDOyBU3eiGzGMIPTN7OqN8Hu0mdkzHAFArjInWsYVsp9LSa8OfS0ul+pQKC9yiIZMzERzMfQR/LEVXM7+kX4klGLmU1MdkkwAisFEYdsbA/DLKcWUNjJtnwNg9qwRSEqqVyoLySYjTvSQeftXuKKrM7tIWqin/ATKT3RWzxPfSufJLJI1mEI+OdctTbhynXEXsizc3RD+/EBTLv5UOTpe8edLJcGm6PXpMi67FTA7YlBNsQjE1REDEKmXz2D02raS9HhAkH4d5ZLfWgBj5LpVeE/CaKwd/hG8OEO0KvtDgTUUh9FI2yETCdc3JK9zW8tySDeRG51iSAUuYWOQ98xeudAPyesNWj1KNxuTTglXM8DmEMgeFYw2B0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/5 10:00, jane.chu@oracle.com wrote:
> 
> 
> On 2/4/2026 1:41 PM, Zi Yan wrote:
>> On 4 Feb 2026, at 16:37, David Hildenbrand (arm) wrote:
>>
>>> On 2/4/26 22:08, Zi Yan wrote:
>>>> On 4 Feb 2026, at 14:18, David Hildenbrand (arm) wrote:
>>>>
>>>>> On 2/4/26 18:41, Zi Yan wrote:
>>>>>>
>>>>>>
>>>>>> More details:
>>>>>> later at sg_vma_fault(), the driver just handles a page fault by supplying
>>>>>> a subpage from a pre-allocated compound page[3]. We then get a large folio
>>>>>> without !CONFIG_TRANSPARENT_HUGEPAGE.
>>>>>
>>>>> We can identify such non-folio (but compound) things by looking at PG_large_rmappable IIRC.
>>>>
>>>> OK, back to the issue. The patch below should fix the issue?
>>>>
>>>> Hi 是参差,
>>>>
>>>> Can you test it?
>>>>
>>
>> <snip>
>>> I think you have to test for folio_test_large() before testing folio_test_large_rmappable().
>>
>> Oh, forgot that. Thanks.
>>
>>
>>  From 8dda4bba9964890462eca3ef3cce57bb4fab8313 Mon Sep 17 00:00:00 2001
>> From: Zi Yan <ziy@nvidia.com>
>> Date: Wed, 4 Feb 2026 16:04:19 -0500
>> Subject: [PATCH] mm/memory_failure: reject unsupported non-folio compound page
>>
>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>> ---
>>   mm/memory-failure.c | 8 ++++++--
>>   1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index 825c706ac576..137c67fda57e 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -2440,9 +2440,13 @@ int memory_failure(unsigned long pfn, int flags)
>>
>>       folio = page_folio(p);
>>
>> -    /* filter pages that are protected from hwpoison test by users */
>> +    /*
>> +     * filter pages that are protected from hwpoison test by users
>> +     * or unsupported non folio compound pages
>> +     */
>>       folio_lock(folio);
>> -    if (hwpoison_filter(p)) {
>> +    if (hwpoison_filter(p) ||
>> +        (folio_test_large(folio) && !folio_test_large_rmappable(folio))) {
> 
> Just curious, would this filter out pte-mapped THP/mTHP folios?

Thanks all.

memory_failure() can meet various types of folios. So in get_hwpoison_page(),
HWPoisonHandlable() and PageHuge() are used to check whether the folio can
be handled. But in madvise(MADV_HWPOISON) scene, MF_COUNT_INCREASED is set in
flag, so this check is skipped and warning triggered. Might HWPoisonHandlable()
check be always used to make sure the folio is in sane types? Something like
below (i.e. remove the MF_COUNT_INCREASED check before calling get_hwpoison_page):

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 825c706ac576..ba4231858a36 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2411,31 +2411,29 @@ int memory_failure(unsigned long pfn, int flags)
         * In fact it's dangerous to directly bump up page count from 0,
         * that may make page_ref_freeze()/page_ref_unfreeze() mismatch.
         */
-       if (!(flags & MF_COUNT_INCREASED)) {
-               res = get_hwpoison_page(p, flags);
-               if (!res) {
-                       if (is_free_buddy_page(p)) {
-                               if (take_page_off_buddy(p)) {
-                                       page_ref_inc(p);
-                                       res = MF_RECOVERED;
-                               } else {
-                                       /* We lost the race, try again */
-                                       if (retry) {
-                                               ClearPageHWPoison(p);
-                                               retry = false;
-                                               goto try_again;
-                                       }
-                                       res = MF_FAILED;
-                               }
-                               res = action_result(pfn, MF_MSG_BUDDY, res);
+       res = get_hwpoison_page(p, flags);
+       if (!res) {
+               if (is_free_buddy_page(p)) {
+                       if (take_page_off_buddy(p)) {
+                               page_ref_inc(p);
+                               res = MF_RECOVERED;
                        } else {
-                               res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
+                               /* We lost the race, try again */
+                               if (retry) {
+                                       ClearPageHWPoison(p);
+                                       retry = false;
+                                       goto try_again;
+                               }
+                               res = MF_FAILED;
                        }
-                       goto unlock_mutex;
-               } else if (res < 0) {
-                       res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
-                       goto unlock_mutex;
+                       res = action_result(pfn, MF_MSG_BUDDY, res);
+               } else {
+                       res = action_result(pfn, MF_MSG_KERNEL_HIGH_ORDER, MF_IGNORED);
                }
+               goto unlock_mutex;
+       } else if (res < 0) {
+               res = action_result(pfn, MF_MSG_GET_HWPOISON, MF_IGNORED);
+               goto unlock_mutex;
        }

        folio = page_folio(p);

Thanks.
.

