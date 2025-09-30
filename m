Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66F24CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:31:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B268E8E002B; Tue, 30 Sep 2025 02:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFDEB8E0002; Tue, 30 Sep 2025 02:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A14398E002B; Tue, 30 Sep 2025 02:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 908F18E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:31:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58116C05B4
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:31:46 +0000 (UTC)
X-FDA: 83944945812.02.8BAB9BC
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf07.hostedemail.com (Postfix) with ESMTP id 16CA640004
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:31:42 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yLrGcdBX;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759213904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUCA7eVrP/zVqrhbttxDcCsaHz85pF/bBDpoThnF+xc=;
	b=xGEQPXWFcl96Uvl6vISsl4DsQitN9CKNv8EcwS5SdtVvOp2SlvuCeFzDcht9HpJqHlTrFN
	irqNssFd9vdUbdLUXHsIi4jTjN9u7+Kz1C6LhOM8I2CtagR4JEKRNT7YZT+jZYVE4vW1zf
	BZ2TG0h5BtiiHqTMOZ84M7d3Tb9RlnI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759213904; a=rsa-sha256;
	cv=none;
	b=2J3CsSkMBZX1ptfu6oHLLrziPecopHBG6VeQpeLetkiTT96KhmnstXnokkFPG5hgNUw5Zy
	ZcL2Biowluu8+A7EuwKx9PddInfjaITjylUgOHxOM1fqKqIw2IoI8na2h0W4aiFO2817kU
	K9Pbo7lCF914Tmp9RDu1FOySzecUEi0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=yLrGcdBX;
	spf=pass (imf07.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=uUCA7eVrP/zVqrhbttxDcCsaHz85pF/bBDpoThnF+xc=;
	b=yLrGcdBX+ePJr6aOloP5qw0PA3hSv1zBPQ4LN+kMhgLIk/O/f8e6/5fUbSpj1xWW/mp15U9d2
	tLPsemmNezgfiu9EKmCGT4KE05SVs3JTbKbzl6VraNE6jShFj/ykz1eKPNA0OgTpuJVRWh1tEDt
	2v6OZdVDnuqPvCgpAzQ9dJQ=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4cbSrf6GCtz12LDF;
	Tue, 30 Sep 2025 14:31:46 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 1F2D91800B1;
	Tue, 30 Sep 2025 14:31:38 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Sep 2025 14:31:37 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Sep 2025 14:31:36 +0800
Subject: Re: [syzbot] [mm?] WARNING in memory_failure
To: <jane.chu@oracle.com>
CC: David Hildenbrand <david@redhat.com>, Luis Chamberlain
	<mcgrof@kernel.org>, syzbot
	<syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
	<akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <nao.horiguchi@gmail.com>,
	<syzkaller-bugs@googlegroups.com>, "Pankaj Raghav (Samsung)"
	<kernel@pankajraghav.com>, Zi Yan <ziy@nvidia.com>
References: <68d2c943.a70a0220.1b52b.02b3.GAE@google.com>
 <ce93b55c-75a7-4b4d-a68b-9d80baf1578b@redhat.com>
 <DB0E39CD-36A9-4929-BCC6-33F27E387AEA@nvidia.com>
 <70522abd-c03a-43a9-a882-76f59f33404d@redhat.com>
 <B0781266-D168-4DCB-BFCE-3EA01F43F184@nvidia.com>
 <cad74ef8-3543-4fc5-a175-8fc23a88776a@redhat.com>
 <E82638DD-9E5D-4C69-AA0F-7DDC0E3D109B@nvidia.com>
 <fzfcprayhtwbyuauld5geudyzzrslcb3luaneejq4hyq2aqm3l@iwpn2n33gi3m>
 <80D4F8CE-FCFF-44F9-8846-6098FAC76082@nvidia.com>
 <w2kwxcd6br6h4tdn6xigtuf73qklt6jhxvhtcwp7idugycgxlv@vqjx26vrnwu5>
 <594350a0-f35d-472b-9261-96ce2715d402@oracle.com>
 <7577871f-06be-492d-b6d7-8404d7a045e0@oracle.com>
 <c61ca94b-5b19-4c69-b2a1-d11a5301c6bb@oracle.com>
 <d15fec58-58ad-fd20-7130-9c480df43d15@huawei.com>
 <8d39b975-b85f-42f2-8be4-0b7adee09dd6@oracle.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <c97dedf5-0f45-5082-64b6-ef0772dc33a3@huawei.com>
Date: Tue, 30 Sep 2025 14:31:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <8d39b975-b85f-42f2-8be4-0b7adee09dd6@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 16CA640004
X-Stat-Signature: qg8irwfxmppnbqe3jt8jhr3bbwb8mxiy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759213902-116725
X-HE-Meta: U2FsdGVkX19GQJeZIrhkcheHhsHRLYZr9oTp7YI4CezsCc0SbW2Z233eGBmv87GGghudLcpQzeVy7jviQP3zeOTZBTlmK1rPD5IjHUPLBs7YMR7hlFJldxvYtEZYJoKDuYH9zO3WJwFvHjOccNl1hKyqeTcIudiBBo6ufCGDRqe9fZbRLqGUQ75tSsYTunBIc1mVo86rR12xAb67h9aKio+JVsoefki3h/DR/PDY5EBmbUtrFIZmD2LQYcUHkU0QPQ3LJJM+gpdXpuHCn7F+odcpKRAdFLOvHk6Id78hEwVJD4cQx7gLlwan0nKSnAGs+AKwV+/uxm5gHc8F9xoz1eeIEc4zeWEhpD1yYl6JE82M3wM+hXKDGh6HRyQyYWiIXbYSuwmBEbPvfylIvD7xXP9anuAOPCzw/gkyI4d2YUGKk72WQWGrEZYlzz/sw0FqT1rDIEUTHJXL14Ir3AaaNC4ZUG93bYyFBSd9FPPnddkARopWfzUteJfP9RbZGKUo8uCSLkOfEJbeU+6+Bjw9PITGPLvdqbaFUY+iQTvpwNRc0RhMMYD5sFkhHyYUeeuLAsgIsdNWPyigprbbX+Y6pO2299XUsIOYs9G7f8itWAgzcwKSw6ytrvL8j6Y3aoAfuvaeW80Pa16qlAYehvNQaaXLJJe3LIoaYZnmaVNg5OFkYViDBc32dPo67/EftnUndj/ZWeus6Zd6SWH+9ZsQhC+DbPrGUeVsxO0OkducsVcvV1tQX4cPVMxYCrVV1qzAtXXfugV9VKIoCUODGw3EyLmxfrWl8Xj0nB1VK4HKGKMFh5dxfZrwJ/4kbU6rUpmFiBIPyciG40Lf85ENMFuDVoM7p1BPRcBTcy3yIxLsFDuNbAmtm2SDidLb8fRKttLVbhGiIjmjdwJttY6fhRm72RNANlA3bvjOQz3KI3xzxJbVO1p4oTDCbrwe4GvX+fVBUnxOmLBux6SOYrMzSpe
 kxfK9NQ5
 dLRAT5W20fscF82FUZLuFa97q/diHoEgzKgsF8uexrUFAkkiNBwnFqlrIZc1X8y3/E7KorE+VbGFs695DgIXdr+wt+qWTfzBddffsS83BMrjN9rKormwpH/yzwNxGMcv3xvb/ZXerA15OcQLZDtSNbKUhWs+fDzNOF6ldc9RA+TgAD/gl6b7MT1viO5sl0Y+dtUyP5vFCpYhwjRUTMgr1Lk70YjSFvcfCdLuMO56gJ+l2RPcBnc8rh6IAt0qBQ/H147WRQ2cYPGv+3+k8VvMKYFt3TKjAeZwOS7VTuzhNJRBPRzPmsqqqbXLnRCZ34W8pjOrgAX0kB/qt56bX9IZBr2cnx8YSwBya6tjGL0OojD/VfEYunrNZEKSKWwG5iLJVsskUeK1sD5zjgtB6b34dbcM/6HKY6TGYRXnT9/hfSBazp80c39TcAnvZWD3YeP5IBwRasY1FD/CpRGb0GX/RhNz1fwJ1SFvPZuvGsBestAzox5R3TjP8II1Y7HwVndA4Vsl5l2iCPh87A6F1E13ZvwVARG5I32oXrvTiokNgxQzfwJmXoZNIgxD1s3zl2zbo1Bd2IWFJJS6bA4dpgyoeveKibrC+Ushh/29boFDQF5vYDXPoTpgm91YXnuSjLBq7s4cNj3FCmDbhDy0LKCfRkrL11OBvl7/HG5VP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/30 12:35, jane.chu@oracle.com wrote:
> 
> 
> On 9/29/2025 7:51 PM, Miaohe Lin wrote:
>> On 2025/9/30 2:23, jane.chu@oracle.com wrote:
>>>
>>>
>>> On 9/29/2025 10:49 AM, jane.chu@oracle.com wrote:
>>>>
>>>> On 9/29/2025 10:29 AM, jane.chu@oracle.com wrote:
>>>>>
>>>>> On 9/29/2025 4:08 AM, Pankaj Raghav (Samsung) wrote:
>>>>>>>
>>>>>>> I want to change all the split functions in huge_mm.h and provide
>>>>>>> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_folio().
>>>>>>>
>>>>>>> Something like below:
>>>>>>>
>>>>>>> 1. no split function will change the given order;
>>>>>>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
>>>>>>> is smaller than mapping_min_folio_order().
>>>>>>>
>>>>>>> In this way, for an LBS folio that cannot be split to order 0, split
>>>>>>> functions will return -EINVAL to tell caller that the folio cannot
>>>>>>> be split. The caller is supposed to handle the split failure.
>>>>>>
>>>>>> IIUC, we will remove warn on once but just return -EINVAL in __folio_split()
>>>>>> function if new_order < min_order like this:
>>>>>> ...
>>>>>>          min_order = mapping_min_folio_order(folio->mapping);
>>>>>>          if (new_order < min_order) {
>>>>>> -            VM_WARN_ONCE(1, "Cannot split mapped folio below min- order: %u",
>>>>>> -                     min_order);
>>>>>>              ret = -EINVAL;
>>>>>>              goto out;
>>>>>>          }
>>>>>> ...
>>>>>
>>>>> Then the user process will get a SIGBUS indicting the entire huge page at higher order -
>>>>>                   folio_set_has_hwpoisoned(folio);
>>>>>                   if (try_to_split_thp_page(p, false) < 0) {
>>>>>                           res = -EHWPOISON;
>>>>>                           kill_procs_now(p, pfn, flags, folio);
>>>>>                           put_page(p);
>>>>>                           action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
>>>>>                           goto unlock_mutex;
>>>>>                   }
>>>>>                   VM_BUG_ON_PAGE(!page_count(p), p);
>>>>>                   folio = page_folio(p);
>>>>>
>>>>> the huge page is not usable any way, kind of similar to the hugetlb page situation: since the page cannot be splitted, the entire page is marked unusable.
>>>>>
>>>>> How about keep the current huge page split code as is, but change the M- F code to recognize that in a successful splitting case, the poisoned page might just be in a lower folio order, and thus, deliver the SIGBUS ?
>>>>>
>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>>> index a24806bb8e82..342c81edcdd9 100644
>>>>> --- a/mm/memory-failure.c
>>>>> +++ b/mm/memory-failure.c
>>>>> @@ -2291,7 +2291,9 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>                    * page is a valid handlable page.
>>>>>                    */
>>>>>                   folio_set_has_hwpoisoned(folio);
>>>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>>>> +               ret = try_to_split_thp_page(p, false);
>>>>> +               folio = page_folio(p);
>>>>> +               if (ret < 0 || folio_test_large(folio)) {
>>>>>                           res = -EHWPOISON;
>>>>>                           kill_procs_now(p, pfn, flags, folio);
>>>>>                           put_page(p);
>>>>> @@ -2299,7 +2301,6 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>                           goto unlock_mutex;
>>>>>                   }
>>>>>                   VM_BUG_ON_PAGE(!page_count(p), p);
>>>>> -               folio = page_folio(p);
>>>>>           }
>>>>>
>>>>> thanks,
>>>>> -jane
>>>>
>>>> Maybe this is better, in case there are other reason for split_huge_page() to return -EINVAL.
>>>>
>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>> index a24806bb8e82..2bfa05acae65 100644
>>>> --- a/mm/memory-failure.c
>>>> +++ b/mm/memory-failure.c
>>>> @@ -1659,9 +1659,10 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>>>>    static int try_to_split_thp_page(struct page *page, bool release)
>>>>    {
>>>>           int ret;
>>>> +       int new_order = min_order_for_split(page_folio(page));
>>>>
>>>>           lock_page(page);
>>>> -       ret = split_huge_page(page);
>>>> +       ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>>>>           unlock_page(page);
>>>>
>>>>           if (ret && release)
>>>> @@ -2277,6 +2278,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>>           folio_unlock(folio);
>>>>
>>>>           if (folio_test_large(folio)) {
>>>> +               int ret;
>>>>                   /*
>>>>                    * The flag must be set after the refcount is bumped
>>>>                    * otherwise it may race with THP split.
>>>> @@ -2291,7 +2293,9 @@ int memory_failure(unsigned long pfn, int flags)
>>>>                    * page is a valid handlable page.
>>>>                    */
>>>>                   folio_set_has_hwpoisoned(folio);
>>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>>> +               ret = try_to_split_thp_page(p, false);
>>>> +               folio = page_folio(p);
>>>> +               if (ret < 0 || folio_test_large(folio)) {
>>>>                           res = -EHWPOISON;
>>>>                           kill_procs_now(p, pfn, flags, folio);
>>>>                           put_page(p);
>>>> @@ -2299,7 +2303,6 @@ int memory_failure(unsigned long pfn, int flags)
>>>>                           goto unlock_mutex;
>>>>                   }
>>>>                   VM_BUG_ON_PAGE(!page_count(p), p);
>>>> -               folio = page_folio(p);
>>>>           }
>>>>
>>>>           /*
>>>> @@ -2618,7 +2621,8 @@ static int soft_offline_in_use_page(struct page *page)
>>>>           };
>>>>
>>>>           if (!huge && folio_test_large(folio)) {
>>>> -               if (try_to_split_thp_page(page, true)) {
>>>> +               if ((try_to_split_thp_page(page, true)) ||
>>>> +                       folio_test_large(page_folio(page))) {
>>>>                           pr_info("%#lx: thp split failed\n", pfn);
>>>>                           return -EBUSY;
>>>>                   }
>>>
>>> In soft offline, better to check if (min_order_for_split > 0), no need to split, just return for now ...
>>
>> I might be miss something but why we have to split it? Could we migrate the whole thp or folio with min_order instead?
> 
> The soft offline code was originally written with the assumption that only 1 base page will be offlined.

Yes, only page corresponding to parameter @pfn of soft_offline_page() will be offlined.

>
> With the recent introduction of min_order, it might quietly offline multiple pages, is that a desirable thing? 

I don't think so. Even if try_to_split_thp_page splits folio into smaller one with min_order, page_handle_poison()
will put back the folio into buddy after migrate_pages, set the hwpoisoned flag to raw error page and hold the extra
refcnt. So only raw error page will be offlined while other sub-pages will be put back into buddy.
Or am I miss something?

Thanks.
.

