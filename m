Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5533ACD8CB9
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 07:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6EF86B008C; Thu, 11 Jun 2026 03:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B46C36B0092; Thu, 11 Jun 2026 03:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5BCD6B0093; Thu, 11 Jun 2026 03:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 94D9F6B008C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:37:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 400FD1A04B6
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:37:02 +0000 (UTC)
X-FDA: 84866825484.08.727F82A
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3AE8C0002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:36:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FbyhTcOl;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781163420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3AwSpmAyexIe5/Db7iwJL52b3STFgxTdFMQJ+7fKUQ=;
	b=wWmOl8GbyLEBvlOJMTUrHJaisj5U0d+6EJiowFDlgWYONZhl1srzsTwS30Tdef6y6lxFZv
	K5KwlkTsOJaUR1LJ50rT7ufD9WzrMi/icd+hxzqxZQoWsqbuVbWnhBJe7DZ981ThLBSzW8
	Be/DzjA6oIwlLwDF1MxL/BQuD5msrbI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=FbyhTcOl;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781163420;
	b=apqg+82XzmFFcyAWOt8bfPElEHeV329xjyIeFdhRNe/+dGgExJqCM8aFVIpnwioWZ/OfAD
	TtsjqStAi9cO6lGdbyln4Sh2aQEkH22hjP3TGyKhrapSpCHU6qkEhii4b6lM/8ewA0d9XI
	hKDYiFhwmVL+/xvHREBYtbO6/bKNnlA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=z3AwSpmAyexIe5/Db7iwJL52b3STFgxTdFMQJ+7fKUQ=;
	b=FbyhTcOl1WDL/+TI82yK6yD+vD9shhF+l9g/OwiYfZAZlJaoyLaVPY4ZlNXrnBaybsUl6mf97
	TOSjo+S/Cftg+CAoxQs7D1wIpyfKG6YduCYNn2jKZ5NYFOSl0a/ygf8bpBqkDZMEd6ahKks7HUU
	1KbD+tZvFkjjHLgiQ/qpHpo=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gbZ5N41ljz1cyR0;
	Thu, 11 Jun 2026 15:28:56 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 257D340563;
	Thu, 11 Jun 2026 15:36:50 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 15:36:49 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 15:36:46 +0800
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
	Jason Wang <jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?Q?Eugenio_P=c3=a9rez?= <eperezma@redhat.com>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Lorenzo Stoakes
	<ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka
	<vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Baolin Wang
	<baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins
	<hughd@google.com>, Matthew Brost <matthew.brost@intel.com>, Joshua Hahn
	<joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park
	<byungchul@sk.com>, Gregory Price <gourry@gourry.net>, Ying Huang
	<ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, Kairui Song
	<kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham
	<nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	<virtualization@lists.linux.dev>, <linux-mm@kvack.org>, Andrea Arcangeli
	<aarcange@redhat.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>
References: <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
 <20260609162437-mutt-send-email-mst@kernel.org>
 <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
 <20260609165829-mutt-send-email-mst@kernel.org>
 <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
 <20260610171646-mutt-send-email-mst@kernel.org>
 <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
 <20260611013644-mutt-send-email-mst@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <1b5676ab-0dc5-ef33-9d79-a2bd6090a62d@huawei.com>
Date: Thu, 11 Jun 2026 15:36:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260611013644-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: p9m58o6kozon81bemothhd7y7i4fi8j6
X-Rspamd-Queue-Id: A3AE8C0002
X-HE-Tag: 1781163418-847059
X-HE-Meta: U2FsdGVkX1/7PjXlkzVZhPZs32oXo0COZxRf++t96TbFdO4F9rpD4inDz3sYhtF6pVuZ6+GPQ97JH09JLJ9bkNmLM0ivYnhzIccg+wJfj49BN5TReq8kJyZGiz5iZ/DHUa2qYNg3Bq0jcndodqAyFtESzDpQZGnHHCUK9KGuLwes+Yu1AdJ0LgQ60mPn++xH7Jkut7T84UgOLi5v4yLyAw8iDGYFSyvpIUX7i+3l9M5guojwTNuXBuHZatm15ZTdvLLJri7DrVbjwbSpvtQVqGJ1FAvaMqPc6wz65z9nvZGWN3sOms/FRK0vNFOA2GKpj7aSeFx+QxaF5JgoVHu/7httSdLQup/6MpF9GfAJW5UvqGeEhGnyFS/llJCY/BojLKX8n3XJoRZq8T8zXyX4cf3zNMnBJIyanU/c6vxdbWbQJ5eZoLNE8C5ZW1SKeQoHNlJor207F3i2m8djCNQz48YVHpGJzeuICBo+1kpMAGfz+JR/bPqQIvxAyy+0B5exQUyfg+F75+SGc24Vfrh8ChUxk04AGtaZx+3+R60Xdr7ie9Jc4f2vKOcyrD0Q0Uf3ibpvhSxFvESh5oYgVc2ck9S6/TPmziyRy2MuNv3Iasm9JaTZlFrtvYvAkUh3tgNwtPqazIITCROCJbckk/ViBoZXdbCsslSl8RmJnwjtrlylIguBTFOlLt66DvZChpXtUrcr53gFY0+icdHwqTYrsx4LClgFCJCN1xKUX2c9HzW/c0sxwScMgerbueV5EhOrdYStMHAoOD+VVBJmtlFbj1xLfRW30/SK15vvtBu9vrRjOepg3l+ox8TXLSPzdX9kGPKfZvVeLcVWdplNrgzr6q1oodSdaRV+tMuDhJBW234TEn0aY5lBRDemyBEpaXujHsdoEoplR7etfYMgTxMW1Axp0CmszaBqHm5M29vCP2QztUn588z2Sw5g/FTz+J6MyLGmW8RI3Ub7fRKKPAA
 2jLfSrz3
 +D3GCr73h6Hyc+/EqbwHe9FbkWt6w/rTg5uakm4nlgUHf5mYB8vnLXNPPGRm8i0gCcz3tGaCap05maNr97Mk42/adeqPuqlzDZPO2RpUlK5D/0CPhN3v3t2RUKEebTXOa8PoL9ACY9Dv1vcs+tUWRXB/sFyJDQj46u6lrWspvmb24p36uW0OlpPC9yw1LHUgEYR4u8/+y8QpY9R5rrGjbc6uWDw/P1h6XMt3/bpvTpFdd1ae6YBYld6YRlaWzvCvjIfsuyvGVI3TDt3ry1nWdFBTCXfTsKR2GYEe/Pqtyoqkb8W+AMP9CjwjHB6bG2mfSXdHbHT4AAv56S5KByVgMfDRTTM57ogsSQV4qxTvyg32jsJl0RH1mZqT2qTWj2RI1S69payp35BH2E9FzWFAotamffVzJGY14cQROHB+X+0eHTJQJZjFrZyBWQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/11 13:43, Michael S. Tsirkin wrote:
> On Thu, Jun 11, 2026 at 11:35:36AM +0800, Miaohe Lin wrote:
>> On 2026/6/11 5:18, Michael S. Tsirkin wrote:
>>> On Wed, Jun 10, 2026 at 03:24:30PM +0800, Miaohe Lin wrote:
>>>> On 2026/6/10 5:00, Michael S. Tsirkin wrote:
>>>>> On Tue, Jun 09, 2026 at 04:54:01PM -0400, Zi Yan wrote:
>>>>>> On 9 Jun 2026, at 16:34, Michael S. Tsirkin wrote:
>>>>>>
>>>>>>> On Tue, Jun 09, 2026 at 02:52:47PM -0400, Zi Yan wrote:
>>>>>>>> On 9 Jun 2026, at 14:39, Zi Yan wrote:
>>>>>>>>
>>>>>>>>> On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:
>>>>>>>>>
>>>>>>>>>> On 6/9/26 20:10, Andrew Morton wrote:
>>>>>>>>>>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>>>>>>>>>>
>>>>>>>>>>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
>>>>>>>>>>>> update to page->flags can race with non-atomic flag operations
>>>>>>>>>>>> that run under zone->lock in the buddy allocator.
>>>>>>>>>>>>
>>>>>>>>>>>> In particular, __free_pages_prepare() does:
>>>>>>>>>>>>
>>>>>>>>>>>>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>>>>>>>>>>>
>>>>>>>>>>>> This non-atomic read-modify-write, while correctly excluding
>>>>>>>>>>>> __PG_HWPOISON from the mask, can still lose a concurrent
>>>>>>>>>>>> TestSetPageHWPoison if the read happens before the poison bit
>>>>>>>>>>>> is set and the write happens after.  Will only get worse if/when
>>>>>>>>>>>> we add more non-atomic flag operations.
>>>>>>>>>>>>
>>>>>>>>>>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
>>>>>>>>>>>> around ClearPageHWPoison in the retry path.  This
>>>>>>>>>>>> serializes with all buddy flag manipulation.  The cost is
>>>>>>>>>>>> negligible: one lock/unlock in an extremely rare path
>>>>>>>>>>>> (hardware memory errors).
>>>>>>>>>>>>
>>>>>>>>>>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
>>>>>>>>>>>> in this file operate on pages already removed from the buddy
>>>>>>>>>>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
>>>>>>>>>>>> need zone->lock protection.
>>>>>>>>>>>
>>>>>>>>>>> Sashiko is saying this doesn't do anything "Because
>>>>>>>>>>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
>>>>>>>>>>>
>>>>>>>>>>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
>>>>>>>>>>
>>>>>>>>>> Battle of the bots: it's right.
>>>>>>>>>
>>>>>>>>> Yep, __free_pages_prepare() changes the page flag without holding
>>>>>>>>> zone->lock.
>>>>>>>>
>>>>>>>> __free_pages_prepare() works on frozen pages and assumes no one else
>>>>>>>> touches the input page. To avoid this race, memory_failure() might
>>>>>>>> want to try_get_page() before TestClearPageHWPoison(), but I am not
>>>>>>>> sure if that works along with memory failure flow.
>>>>>>>>
>>>>>>>> Best Regards,
>>>>>>>> Yan, Zi
>>>>>>>
>>>>>>>
>>>>>>>
>>>>>>> Actually memory failure already plays with this down the road no?
>>>>>>>
>>>>>>> So maybe it's enough to just SetPageHWPoison afterwards again?
>>>>>>>
>>>>>>>
>>>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>>>>> index ee42d4361309..4758fea94a96 100644
>>>>>>> --- a/mm/memory-failure.c
>>>>>>> +++ b/mm/memory-failure.c
>>>>>>> @@ -2415,6 +2415,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>>>  	if (!res) {
>>>>>>>  		if (is_free_buddy_page(p)) {
>>>>>>>  			if (take_page_off_buddy(p)) {
>>>>>>> +				SetPageHWPoison(p);
>>>>>>>  				page_ref_inc(p);
>>>>>>>  				res = MF_RECOVERED;
>>>>>>>  			} else {
>>>>>>>
>>>>>>>
>>>>>>> and maybe in a bunch of other places in there?
>>>>>>
>>>>>> You mean for fear of losing HWPoison flag in the earlier TestSetPageHWPoison(),
>>>>>> just set it again here?
>>>>>
>>>>> Yea.
>>>>>
>>>>>> Why not do it after get_hwpoison_page(), since that
>>>>>> is the expected page flag?
>>>>>
>>>>> It's still in the buddy at that point right? I'm worried buddy might
>>>>> poke at flags.
>>>>
>>>> Since __free_pages_prepare() executes entirely locklessly, the only way to ensure
>>>> HWPoison flag won't be lost might be only set hwpoison flag iff we can make sure
>>>> pages are not on the way to buddy...
>>>>
>>>> Thanks.
>>>> .
>>>
>>>
>>> To clarify do you not agree repeating SetPageHWPoison is enough for
>>> this? And if not, do you have suggestions on how to fix this race?
>>
>> Do you mean repeating SetPageHWPoison on every branch?
> 
> Right.
> 
>> Is it possible
>> to make __free_pages_prepare changes page->flags atomically or this race
>> is specified to memory_failure?
>>
>> Thanks.
>> .
> 
> 
> Adding an atomic op on every fast path page allocation is, I am
> guessing, going to slow down Linux measureably.
> 
> Doing it for the benefit of memory_failure, which is the slowest of
> slow paths, seems unpalatable, to me.

Agree, it's not worth to do so.

> 
> Neither am I sure it's the only racy place -
> grep for __SetPage and __ClearPage - all these have the same issue, I
> suspect.
> 
> At the same time, I'm not an mm maintainer. If you disagree, try to
> upstream a change converting all non atomics in mm to atomics, and see
> what others say.

Since memory_failure might be the only place, this change would be unacceptable.
We should come up with a better solution. Maybe we can try repeating SetPageHWPoison
and ClearPageHWPoison at a first attempt though it looks somewhat weird to me and makes
code more complicated. But it's already complicated. :)

Thanks.
.



