Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A36CD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:35:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2894C6B0005; Wed, 10 Jun 2026 23:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212FE6B0088; Wed, 10 Jun 2026 23:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DB3A6B008C; Wed, 10 Jun 2026 23:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ECCAE6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:35:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7029340367
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:35:49 +0000 (UTC)
X-FDA: 84866217618.29.CE1ACBF
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id 8DC9C180005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:35:45 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s2c+zISf;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781148947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=udMeqyjo/ojhmjQo8mZa5UnxqjBW6Epo1JZrcj9cKSA=;
	b=cVOmISod7td96XQ3kbywQ9lbEJXJUekE/OSQpHW5fIZwC+rKV/WqVEdJb8NsJtlqgajH/z
	qKFLFGiqdcw/fFfnZ0138+9PBRw04i79bcYicSjlIXMaD/LgfCx1n1Ve2q3x/upZXkdBW5
	wlTzrGiWNOHkGJtb6HB2r7f23rW5Tmg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=s2c+zISf;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781148947;
	b=6LZOIlpFf9cTlimP9qm4w0fbQQbmeD9zK3OiyUwU/uismFWu+HOiwxyt2ljompyrxsoAG3
	wcE89RlI5JTMhqvr9XTc9OEiB77dfY7LVYf9y7u9X7Xgha7wRZEOzRCON+Vl3bUcOOHo3o
	7IybO/PKj4m7DHnnoIYELqG704PWvGs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=udMeqyjo/ojhmjQo8mZa5UnxqjBW6Epo1JZrcj9cKSA=;
	b=s2c+zISfurUf+7wHGhsy/XXdBPiaMlR76c5w9vuixp2j4ufSD7YkhbbMqmcA6nYSWqiVEZgCX
	7cilsr4IvqF9dZLLKRrzXrHlOVa1pb7agG1XD3kT0IpQg+CmRSPXLMOYDY1ipE5+t6CjtiVeV1e
	6pOdEuOY+qXKfiy7xjmEpLE=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gbSkk71zszcb1Y;
	Thu, 11 Jun 2026 11:27:26 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 4BF6140577;
	Thu, 11 Jun 2026 11:35:40 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 11:35:40 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Jun 2026 11:35:37 +0800
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
References: <df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com>
 <20260609111020.e88f51a7b6ebc37360d66fdc@linux-foundation.org>
 <8c1f468e-b50a-487a-a267-8d1ea5a61c87@kernel.org>
 <FB250C43-790E-4AB0-BD40-74665FC601A0@nvidia.com>
 <38C84F23-E881-4DB2-86BA-93F39D44AE1B@nvidia.com>
 <20260609162437-mutt-send-email-mst@kernel.org>
 <4BA276D9-9EB9-4E2A-8A05-657ACACFF227@nvidia.com>
 <20260609165829-mutt-send-email-mst@kernel.org>
 <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
 <20260610171646-mutt-send-email-mst@kernel.org>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <14537566-94d9-eac5-2636-35f925a9d159@huawei.com>
Date: Thu, 11 Jun 2026 11:35:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260610171646-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: 8DC9C180005
X-Rspam-User: 
X-Stat-Signature: tpkctwcoityjb595733ejp196zdw1oto
X-Rspamd-Server: rspam09
X-HE-Tag: 1781148945-201394
X-HE-Meta: U2FsdGVkX19Aw6EG/4kY6qa3vYPOh5eQ8zzgGzeA1Y0G9y0cGlk/MspBgV/DE1jqE6T8z8hSgazRHzrGU13O5lH3849I6fiuNNjAc/d7Ms9lpGzlFRFCLYI3ixHafDGrc4eWkMoGDoaaGq2WEKDHAdD+dUQy6C1V0UBdOmpf0XCdCzN4WDHdypL35AaOwHkHs/J7nHveDNFr6Pow558vrSHXQaAkOEnWTw55gfZ8Adza+PQrJ60CwUFilJM499RU/oy7qsZquOVXVPQu+S7vlStWiLsviK09+M5d2JBmO/C6ZBl5m4OXm0ZUz6MrlK80ANE9nAu/eBdVaJWXz764NPiRRgYXLIDemHuPcba0iDkVdCQv5vkDW0QZLEHbomkoxkmeXk7/Kr0kdETVlf6xXUUrbP9smbzCzljp+17jWuaonIWiUlA4knceSO5GJWu7HMY5yopj8BhGyvfT5GAoioI1KmQRMr8GtZe4Ou8vVSkLqGWK32PXnFIXCzYQmsMW2KM9MyqssFh3PEIAiSEVy5SZiNM6crFfDfaqIgeTQKOL3lPpWuPT4bpYDEo0EW+eeXeNlHMQsgEpaVRF5Z0qP9Ee3RDtt3aLU+AT+zCWT4Rw4qvckuVZx5fMs5PDQzma/h4oRv3Vasr21sZ+0/KV0xN4IeNWqiak+C1eIR6PZjjvsp2/xhMx3CvTP7dUwzGViQUPsV6BrO6uh2i8SvpOFuOpvzo5EtFi5wzfAxNvIsOVdAs6/WqNZmb37FFLmz+pG5VdZ9L+4wSOYCCKzTa1l8jQHbOQg69IyVeHvnFyWK8zcvcXRUk9J0FGEz3QjWxEJfSv7ZHJur9HYqiPZP9noF6NDdQAHRb3zuWe5YT4YF4fIXql3OuVnjQjTcX/bVZ5jjby3+ptVI9a/M9WPlKXk/0nDFvyoLZ2s++vqjNiuz6nqyAtNLcUt8C6X4aAi39HeB2LHbR8TKkf6+pYgHF
 aTAgpZvx
 mE3JSxN7XuTMBriIH/ji39kYFV9WiF7vRVSBpOMK+lJGd5+NSFwI/KlysO5yPDPVtfSX0oLbzP8sXXeS4OMCyWuuyp2lA4lUXZObNdC3/+zjURYC1LEY51+3L+Yc800oj7iuxHM2D1t8JcZ1N2ZnWGzq5bKIEO3CpkTf95h9ImDjnEo8ISoEghU8aMQkDGvKGb5maaYBiuK3yOVOHsd64t+6//DqGLKV1JpwzvcyO0xhyamuxa4kfDAMJwlMq6NZ3Bs2m0weUw9oct6FOzv4ngaS08XSnwtpm3sbFYTbHzYy4g3LOGhbru1d0UHzf3k+rygVnKDYuIhcnlu1xf0JgA4Dk4FceAVPrPBKOVouoymN8YOD0OUMPhrhLH6at73S0VGZ4McpHVoO4ZKx0FJWBrg3Ph1wlzaM26etSsU0ti4qODfBYyoyDOeaF2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/11 5:18, Michael S. Tsirkin wrote:
> On Wed, Jun 10, 2026 at 03:24:30PM +0800, Miaohe Lin wrote:
>> On 2026/6/10 5:00, Michael S. Tsirkin wrote:
>>> On Tue, Jun 09, 2026 at 04:54:01PM -0400, Zi Yan wrote:
>>>> On 9 Jun 2026, at 16:34, Michael S. Tsirkin wrote:
>>>>
>>>>> On Tue, Jun 09, 2026 at 02:52:47PM -0400, Zi Yan wrote:
>>>>>> On 9 Jun 2026, at 14:39, Zi Yan wrote:
>>>>>>
>>>>>>> On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:
>>>>>>>
>>>>>>>> On 6/9/26 20:10, Andrew Morton wrote:
>>>>>>>>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>>>>>>>>
>>>>>>>>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
>>>>>>>>>> update to page->flags can race with non-atomic flag operations
>>>>>>>>>> that run under zone->lock in the buddy allocator.
>>>>>>>>>>
>>>>>>>>>> In particular, __free_pages_prepare() does:
>>>>>>>>>>
>>>>>>>>>>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>>>>>>>>>
>>>>>>>>>> This non-atomic read-modify-write, while correctly excluding
>>>>>>>>>> __PG_HWPOISON from the mask, can still lose a concurrent
>>>>>>>>>> TestSetPageHWPoison if the read happens before the poison bit
>>>>>>>>>> is set and the write happens after.  Will only get worse if/when
>>>>>>>>>> we add more non-atomic flag operations.
>>>>>>>>>>
>>>>>>>>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
>>>>>>>>>> around ClearPageHWPoison in the retry path.  This
>>>>>>>>>> serializes with all buddy flag manipulation.  The cost is
>>>>>>>>>> negligible: one lock/unlock in an extremely rare path
>>>>>>>>>> (hardware memory errors).
>>>>>>>>>>
>>>>>>>>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
>>>>>>>>>> in this file operate on pages already removed from the buddy
>>>>>>>>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
>>>>>>>>>> need zone->lock protection.
>>>>>>>>>
>>>>>>>>> Sashiko is saying this doesn't do anything "Because
>>>>>>>>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
>>>>>>>>>
>>>>>>>>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
>>>>>>>>
>>>>>>>> Battle of the bots: it's right.
>>>>>>>
>>>>>>> Yep, __free_pages_prepare() changes the page flag without holding
>>>>>>> zone->lock.
>>>>>>
>>>>>> __free_pages_prepare() works on frozen pages and assumes no one else
>>>>>> touches the input page. To avoid this race, memory_failure() might
>>>>>> want to try_get_page() before TestClearPageHWPoison(), but I am not
>>>>>> sure if that works along with memory failure flow.
>>>>>>
>>>>>> Best Regards,
>>>>>> Yan, Zi
>>>>>
>>>>>
>>>>>
>>>>> Actually memory failure already plays with this down the road no?
>>>>>
>>>>> So maybe it's enough to just SetPageHWPoison afterwards again?
>>>>>
>>>>>
>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>>> index ee42d4361309..4758fea94a96 100644
>>>>> --- a/mm/memory-failure.c
>>>>> +++ b/mm/memory-failure.c
>>>>> @@ -2415,6 +2415,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>  	if (!res) {
>>>>>  		if (is_free_buddy_page(p)) {
>>>>>  			if (take_page_off_buddy(p)) {
>>>>> +				SetPageHWPoison(p);
>>>>>  				page_ref_inc(p);
>>>>>  				res = MF_RECOVERED;
>>>>>  			} else {
>>>>>
>>>>>
>>>>> and maybe in a bunch of other places in there?
>>>>
>>>> You mean for fear of losing HWPoison flag in the earlier TestSetPageHWPoison(),
>>>> just set it again here?
>>>
>>> Yea.
>>>
>>>> Why not do it after get_hwpoison_page(), since that
>>>> is the expected page flag?
>>>
>>> It's still in the buddy at that point right? I'm worried buddy might
>>> poke at flags.
>>
>> Since __free_pages_prepare() executes entirely locklessly, the only way to ensure
>> HWPoison flag won't be lost might be only set hwpoison flag iff we can make sure
>> pages are not on the way to buddy...
>>
>> Thanks.
>> .
> 
> 
> To clarify do you not agree repeating SetPageHWPoison is enough for
> this? And if not, do you have suggestions on how to fix this race?

Do you mean repeating SetPageHWPoison on every branch? Is it possible
to make __free_pages_prepare changes page->flags atomically or this race
is specified to memory_failure?

Thanks.
.


