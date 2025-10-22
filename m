Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2C1ACCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 06:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1945A8E0015; Wed, 22 Oct 2025 02:39:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16B428E0002; Wed, 22 Oct 2025 02:39:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A88C8E0015; Wed, 22 Oct 2025 02:39:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EDE788E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:39:39 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 64D1913BB93
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:39:39 +0000 (UTC)
X-FDA: 84024799278.12.ED57B07
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf04.hostedemail.com (Postfix) with ESMTP id 91B884000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:39:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fEux8RY7;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761115177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9YszbItFa8+6g0CApeKe+tj/OKRQ7kdza/2EO8OVt+k=;
	b=R0gXMZ1b4pe64PGlTR3Em3sytUO6PbzDKLPp07eGDX+xaSQ4iEdMnYjny3m28kSyUBfQSg
	YFGp+4ZeWg4KResBIYjZbj3XOTkQtX08SYy8oJfjjl7KnEnm3FEaGM16/r3XYqtAcw7Pwu
	35bgQuPzFHVg3+4dOA2psnldH5AbDs4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=fEux8RY7;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761115177; a=rsa-sha256;
	cv=none;
	b=AGUDsrzmLC8F0ofFxrB9ubY5+ufOSR9TjZL0gfoumCRlj6O6kyLy5Zif7l7G2CWC44peSf
	gT+aWusC6H5o9bHZf6oOHLKJCcfh3ffItpAJBdyVXSYM4+sJ/YxT5p5WJCQBl8yXttRWtl
	5zbNlXfQnxne4BcES385slbUsa7rhcc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=9YszbItFa8+6g0CApeKe+tj/OKRQ7kdza/2EO8OVt+k=;
	b=fEux8RY7JKOtPA/+t8JeDlCiLLgkFsovxTzM67kKnEdmP/wob1n3bYU478R/SJGfbOzsmmjqN
	T0Uv28VcXq3y4Oql5YG1S8wtyy9lGKg4k1rh6o3jJG8NS+pkPB5F/E11kHVet3z3pjxYmUAcNJZ
	c1+wpfATD92Jsum/pf4f8EE=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4crzyz20FrzKm6d;
	Wed, 22 Oct 2025 14:39:07 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id A829A1800CF;
	Wed, 22 Oct 2025 14:39:31 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 14:39:28 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 22 Oct 2025 14:39:26 +0800
Subject: Re: [PATCH v2 2/3] mm/memory-failure: improve large block size folio
 handling.
To: Zi Yan <ziy@nvidia.com>
CC: <david@redhat.com>, <kernel@pankajraghav.com>,
	<syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>, <akpm@linux-foundation.org>,
	<mcgrof@kernel.org>, <nao.horiguchi@gmail.com>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, Wei Yang <richard.weiyang@gmail.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, Yang Shi <shy828301@gmail.com>, <jane.chu@oracle.com>
References: <20251016033452.125479-1-ziy@nvidia.com>
 <20251016033452.125479-3-ziy@nvidia.com>
 <CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com>
 <5EE26793-2CD4-4776-B13C-AA5984D53C04@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <4238c5ed-f8ee-724e-606b-54bc1259fdd7@huawei.com>
Date: Wed, 22 Oct 2025 14:39:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <5EE26793-2CD4-4776-B13C-AA5984D53C04@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 91B884000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: itb3khk97ouda8h75rkbpg7iufmiwrdx
X-HE-Tag: 1761115176-504958
X-HE-Meta: U2FsdGVkX1/bwLJ6lOUepsYROYoVLwCMrJMOh6V9/nGLBjYjwdrKZMkObAmne1dBy+XBcVhrNTH8VbqKdyGJRpJ2Xv57bkDAnk183+g7hD3ExYU6om/BPqBjWgJXmvI4Qz0n2Mv5w4IHdYfC2EVQbs0/elEDPy48lbz5KnahX9iDDDWnF/3t3AVGEMQOXxqV9gri3elYlXxo6W0zMFIRd6k1qXFBcfF4OzEaHc9ZjEeAWQoRUixpLJAqHQc9e2MT0EmS38Ve7T9eNMW7/lq85/Vl6kluoYNHF0O8mMNu2SbO/fYXXZGArYpqt9XPFhPNQnb0HnCON7p3Nu2IXWnXuisPZ2+HpcSx19OeaI0DbG3bO9RpcFouNk0CJpigF55E5efFXa8TnaMvonunh/Ddcl2dpJhQKgp5BUNqPvksq596eJPKnY14o2fVIVvzaUmzQKYUpuPrMQfhzTMhrxz4DCyfwFPkGKJZm8FNw2V5Z+QS3c6hiJkpIUDm+YEXMUsbOv6xif57MO5oX3/lxlehi4cTjG06lMiaJomfm6UDxJijKESUeDTwmoOUItKlOokerB8kY95Ppu+zEm+BsHXDhw1lnnyubpOJ6WkWshX2DENCrO5fLuEnqVcvxTyIKXuW2e4aq/0Hnv9Z6jsXoGclNSdAUM1MXQeQInwXI3ze9NNCqMiDXIBxrYro8A7FzY5z5BGzMDJpJam+9ZnBVrotSr+T936Lmh41LY1llxTdOBYr6Tx4z4BQxJS9npJCgiD51IoR/K8b+1JRFv7Oj/hlHHQyvmmMvBMcV5atXMxcHTBt83me2uv5M5wJdi/2uNvw5F9Tby9Q//zgb8LYsjWnR6FaWcSG1iUHdMTVG22efqFzDCWEHKS6tWwzEcBsUqGybr9fLqcxzyNUicy2TNMSiJHDjioa4yGmSrMIAXMXWFs1URl63ZONGsA+YmD7pQy0bL/yAHI2gK8tXscwOr9
 VUpVcoo+
 jT2fGA49q7xZbDwwptyhag64CRS2e8Acel4ipwP43H9D/owkhWoQzSqx7uTVGiK0bpUAqvcoQm/WneTRAFenDRVDI1vCSicBhunCK8MVf9ePWMCLJvIsdPUoQKdeaWe7ZYW98FYV0S5pehYmQWhIhXhaieLeMpMbRx2G4JrWWfZF0A5fvMhzuGDFszoLqZ/p5KTQIRaCn8uN7UerZo+SFUHnK/Fc1Ii7uf7SZdqStnaX1/RwGYvJhJ46JLQJ7IA9gRIR3y4dn4xWCX+2m7Y2jeucWt3wbdWGKDQdQOX+p7Jli0OJLJTlAfefRm9jKH9+ekk9fZGgR2Fi5F5DYexrN3thONxRm1l1RjDGi3iLXbqE2fXd1YGo0AQ6/tBMN9Vke+j3EqH9AVdPLG98ZYNLgONfXk7j7ksoFDx60snLbqncc/FhUl+jQq2BjOZZv5uFbPndm8ZOJOrxndJjMfEiQuiBTj5FLaZd6kkMdDV4MLzJRpoMR3J5AGH//MZEi2M0Cv4KZwbCfKVqKivw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/21 3:46, Zi Yan wrote:
> On 17 Oct 2025, at 15:11, Yang Shi wrote:
> 
>> On Wed, Oct 15, 2025 at 8:38 PM Zi Yan <ziy@nvidia.com> wrote:
>>>
>>> Large block size (LBS) folios cannot be split to order-0 folios but
>>> min_order_for_folio(). Current split fails directly, but that is not
>>> optimal. Split the folio to min_order_for_folio(), so that, after split,
>>> only the folio containing the poisoned page becomes unusable instead.
>>>
>>> For soft offline, do not split the large folio if it cannot be split to
>>> order-0. Since the folio is still accessible from userspace and premature
>>> split might lead to potential performance loss.
>>>
>>> Suggested-by: Jane Chu <jane.chu@oracle.com>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>>> ---
>>>  mm/memory-failure.c | 25 +++++++++++++++++++++----
>>>  1 file changed, 21 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index f698df156bf8..443df9581c24 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>>>   * there is still more to do, hence the page refcount we took earlier
>>>   * is still needed.
>>>   */
>>> -static int try_to_split_thp_page(struct page *page, bool release)
>>> +static int try_to_split_thp_page(struct page *page, unsigned int new_order,
>>> +               bool release)
>>>  {
>>>         int ret;
>>>
>>>         lock_page(page);
>>> -       ret = split_huge_page(page);
>>> +       ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>>>         unlock_page(page);
>>>
>>>         if (ret && release)
>>> @@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>         folio_unlock(folio);
>>>
>>>         if (folio_test_large(folio)) {
>>> +               int new_order = min_order_for_split(folio);
>>>                 /*
>>>                  * The flag must be set after the refcount is bumped
>>>                  * otherwise it may race with THP split.
>>> @@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int flags)
>>>                  * page is a valid handlable page.
>>>                  */
>>>                 folio_set_has_hwpoisoned(folio);
>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>> +               /*
>>> +                * If the folio cannot be split to order-0, kill the process,
>>> +                * but split the folio anyway to minimize the amount of unusable
>>> +                * pages.
>>> +                */
>>> +               if (try_to_split_thp_page(p, new_order, false) || new_order) {
>>
>> folio split will clear PG_has_hwpoisoned flag. It is ok for splitting
>> to order-0 folios because the PG_hwpoisoned flag is set on the
>> poisoned page. But if you split the folio to some smaller order large
>> folios, it seems you need to keep PG_has_hwpoisoned flag on the
>> poisoned folio.
> 
> OK, this means all pages in a folio with folio_test_has_hwpoisoned() should be
> checked to be able to set after-split folio's flag properly. Current folio
> split code does not do that. I am thinking about whether that causes any
> issue. Probably not, because:
> 
> 1. before Patch 1 is applied, large after-split folios are already causing
> a warning in memory_failure(). That kinda masks this issue.
> 2. after Patch 1 is applied, no large after-split folios will appear,
> since the split will fail.
> 
> @Miaohe and @Jane, please let me know if my above reasoning makes sense or not.
> 
> To make this patch right, folio's has_hwpoisoned flag needs to be preserved
> like what Yang described above. My current plan is to move
> folio_clear_has_hwpoisoned(folio) into __split_folio_to_order() and
> scan every page in the folio if the folio's has_hwpoisoned is set.
> There will be redundant scans in non uniform split case, since a has_hwpoisoned
> folio can be split multiple times (leading to multiple page scans), unless
> the scan result is stored.
> 
> @Miaohe and @Jane, is it possible to have multiple HW poisoned pages in
> a folio? Is the memory failure process like 1) page access causing MCE,
> 2) memory_failure() is used to handle it and split the large folio containing
> it? Or multiple MCEs can be received and multiple pages in a folio are marked
> then a split would happen?
memory_failure() is called with mf_mutex held. So I think even if multiple pages
in a folio trigger multiple MCEs at the same time, only one page will have HWPoison
flag set when splitting folio. If folio is successfully split, things look fine.
But if it fails to split folio due to e.g. extra refcnt held by others, the following
pages will see that there are already multiple pages in a folio are marked as HWPoison.
This is the scenario I can think of at the moment.

Thanks.
.


