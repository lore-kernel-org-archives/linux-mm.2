Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59E22CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 07:24:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C38C86B008A; Wed, 10 Jun 2026 03:24:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C846B008C; Wed, 10 Jun 2026 03:24:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F836B0093; Wed, 10 Jun 2026 03:24:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88CC26B008A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 03:24:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B6E5165159
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:24:44 +0000 (UTC)
X-FDA: 84863165688.14.491AEA1
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf17.hostedemail.com (Postfix) with ESMTP id A984F40002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:24:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pUAcpUCX;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781076282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=crRRLRHMwOqSlZxpvEgm0rohsPbYMLQzjHRhzUhnKk4=;
	b=uSg3mWJ3Znd6vaK44WSjB7y4saBSTX3lyXKfJmMTTthsPEAhhDoc7uvVVWcdA/OJcrOyKu
	roWGiXFgjYK329/xDHY5o3lSnf1smP5l1KjonajG9qaz2jpNYXVFi3Fl6HMLCo7b7RSFYo
	juqHrSjQEkcGJg6HVkGPTcMP2lzSEMU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pUAcpUCX;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf17.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781076282;
	b=cYyzckszbU7g8mU9zsALCAneWyVi6Bym4RiQZyHooCTaTb74iBy+FvuiMijMof+MBL0dUN
	SeHhGX5ZzAgb6JINAUZamGMXQcAgmdpeAaxyDjoIZDungu8PsgtdOCHHcfHSlPkttxS5EU
	qTjxLOcBCdtDNYARORLGM0OLWeJqm5c=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=crRRLRHMwOqSlZxpvEgm0rohsPbYMLQzjHRhzUhnKk4=;
	b=pUAcpUCXcIbmjmTiSx3U5UTBV/3/rMsFIK5zjYAueWsPFLJehR3ItKMetYHDKTwv8ZOEcC+mq
	7fOTCLSG5LPNHSiJlrZIYT9xa2sisxyjsFhiQ6iSHrPv7xClMP8PmlHnq2fWYf3JTIZVClsGMhe
	yYfoS9ENJsp5sdYL/OjOC3w=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gZxsh0nwQzLlY6;
	Wed, 10 Jun 2026 15:16:40 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id DCF44402AB;
	Wed, 10 Jun 2026 15:24:33 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Jun 2026 15:24:33 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Jun 2026 15:24:30 +0800
Subject: Re: [PATCH splitout] mm: memory-failure: serialize
 TestSetPageHWPoison with zone->lock
To: "Michael S. Tsirkin" <mst@redhat.com>, Zi Yan <ziy@nvidia.com>
CC: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>, Jason Wang
	<jasowang@redhat.com>, Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
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
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <dd8d89be-9c73-8ff7-7d44-9705bddeda4d@huawei.com>
Date: Wed, 10 Jun 2026 15:24:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260609165829-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: A984F40002
X-Rspam-User: 
X-Stat-Signature: h4hehqb88dwkaiigumwqpt6c3uu9ru6z
X-Rspamd-Server: rspam09
X-HE-Tag: 1781076280-25006
X-HE-Meta: U2FsdGVkX18RSpF1qbo78oG1jKQc5ylMSpdnHjGb3qckCt5Nnh9oby/+f8W085Tu7dYV7J5cXP9YAPbKswgqOiU7mjh2cjXDe1I5LenR0olvD+ZAjLQNTbkjwgwk6ZGQn1AixoIOQTFItJGkC7aFFsn72v8x4QAvKe6ihvJD7rf7RGvjk9Y24eYZFoFY59zuPVCarbX4YWY+XQMxme0UoKmcssyJGjvFOj/a3geycTAR7jbl43Pglnca8y/SjCk2dQYOp6viKg+BJO5P0Ppwrx31wbvninS/tWx162JaD1KAUo3B2OClEFN+vvDvqVFbmVBEV5MkYM3cEnvbTc7GRetoHvhZGM+Rt8CPH+cCU1LcwI5VergZoHTvKcQ6dKMZfZtaX4nlhDkYkToPIY/aJEUrapbk8eNJraecNBTmzU07MFg75iYQvhN/5AkFUtTIHrWrkdSb6GxBU16ZcBqrwc8qY4JFEpNwGJQT/bBh3iPc6qUo/bYP/q4IS6KyS+gL9wQ0xvnzt7lvKPvMycJDpsk+59nrZiFHHJO8r+rKS9G2N9ftMWj0vqOJb7pz8kl+bh115r0hTPNHosRGfU3pbt3gmUiVZXrCmbHkLk3OQcHxx4f+6E/Na9qw9Ot859uuUOnIWjmB1/DaihoC/V8DryNk8q6hbg3z3WZObOy0BqR2BkpTdFlbTZpM6PjUTxALu3spnX7hxJBvNh8y55gag/i8+nseubGRkv1MPpf1jeZCqMknNc+dRIgAKrwWjPx1ume6m2ZMTq7w9zy+MCx0AGMPNe0esiWf6wDPvRdyrti914G1pmVNDaY9yjmS4vLB+/S38g0SzYuon3L3qVGSK9EW/9gzHn4sTaTFf4hPEVh3JQU0z8QUtUF83bnzxajax+47hbbbDo00S1F27rH9SJwVvj2PuIiAeZDWe7JAEOGnpJuCj3M4Q9Pki2xLkhDW9sFwiAorvf7mRaD3jrT
 GrdbGIkH
 Ad9ax+iI9ZwpZb/1tYqw7Xo9S1jD92JxOzXXSifDRThKCT8Hfup76vDVTQwI8zoQi91cvJdMzyAHtVYiePfOjqBH3gIBhDwLnVnOPQtMf887w4rcJtEECyUwAhS7ayl9mNuixiqNXd9GgRGjyTn9zAnYzXLwIf6oM1fRTJMewZ0CrDlV+lbWbVw4/6xw13xzbRmBB8PPL+ShJD/dHpX8SL2PpuUib4VtmulojXk/ieH5sHo/Po4s6MzsXr5ThKQaj1mHBWn2XrjnjXsHhEzC0YaclB/rDK1Y/fRypZ2FYU9P5d0IsnY0743dQu/10x6g7VMOAd6v+nKZAWIkoARNL1pFT+eHKQq1QqKEhmGGkKoGl17Y/3WS6PWziIYTYFA/x5cs0FsFtnpAN+rXCvZ9ZbYVzIClZ5PiJ1sCYBE69osTYjR7BprE8YRErnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/6/10 5:00, Michael S. Tsirkin wrote:
> On Tue, Jun 09, 2026 at 04:54:01PM -0400, Zi Yan wrote:
>> On 9 Jun 2026, at 16:34, Michael S. Tsirkin wrote:
>>
>>> On Tue, Jun 09, 2026 at 02:52:47PM -0400, Zi Yan wrote:
>>>> On 9 Jun 2026, at 14:39, Zi Yan wrote:
>>>>
>>>>> On 9 Jun 2026, at 14:38, David Hildenbrand (Arm) wrote:
>>>>>
>>>>>> On 6/9/26 20:10, Andrew Morton wrote:
>>>>>>> On Tue, 9 Jun 2026 06:12:49 -0400 "Michael S. Tsirkin" <mst@redhat.com> wrote:
>>>>>>>
>>>>>>>> TestSetPageHWPoison() is called without zone->lock, so its atomic
>>>>>>>> update to page->flags can race with non-atomic flag operations
>>>>>>>> that run under zone->lock in the buddy allocator.
>>>>>>>>
>>>>>>>> In particular, __free_pages_prepare() does:
>>>>>>>>
>>>>>>>>     page->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
>>>>>>>>
>>>>>>>> This non-atomic read-modify-write, while correctly excluding
>>>>>>>> __PG_HWPOISON from the mask, can still lose a concurrent
>>>>>>>> TestSetPageHWPoison if the read happens before the poison bit
>>>>>>>> is set and the write happens after.  Will only get worse if/when
>>>>>>>> we add more non-atomic flag operations.
>>>>>>>>
>>>>>>>> Fix by acquiring zone->lock around TestSetPageHWPoison and
>>>>>>>> around ClearPageHWPoison in the retry path.  This
>>>>>>>> serializes with all buddy flag manipulation.  The cost is
>>>>>>>> negligible: one lock/unlock in an extremely rare path
>>>>>>>> (hardware memory errors).
>>>>>>>>
>>>>>>>> Note: SetPageHWPoison and TestClearPageHWPoison calls elsewhere
>>>>>>>> in this file operate on pages already removed from the buddy
>>>>>>>> allocator or on non-buddy pages (DAX, hugetlb), so they do not
>>>>>>>> need zone->lock protection.
>>>>>>>
>>>>>>> Sashiko is saying this doesn't do anything "Because
>>>>>>> __free_pages_prepare() executes entirely locklessly".  Did it goof?
>>>>>>>
>>>>>>> https://sashiko.dev/#/patchset/df06b66fe4ff8e925ee0714955abc2183a727b90.1780998980.git.mst@redhat.com
>>>>>>
>>>>>> Battle of the bots: it's right.
>>>>>
>>>>> Yep, __free_pages_prepare() changes the page flag without holding
>>>>> zone->lock.
>>>>
>>>> __free_pages_prepare() works on frozen pages and assumes no one else
>>>> touches the input page. To avoid this race, memory_failure() might
>>>> want to try_get_page() before TestClearPageHWPoison(), but I am not
>>>> sure if that works along with memory failure flow.
>>>>
>>>> Best Regards,
>>>> Yan, Zi
>>>
>>>
>>>
>>> Actually memory failure already plays with this down the road no?
>>>
>>> So maybe it's enough to just SetPageHWPoison afterwards again?
>>>
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index ee42d4361309..4758fea94a96 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -2415,6 +2415,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>  	if (!res) {
>>>  		if (is_free_buddy_page(p)) {
>>>  			if (take_page_off_buddy(p)) {
>>> +				SetPageHWPoison(p);
>>>  				page_ref_inc(p);
>>>  				res = MF_RECOVERED;
>>>  			} else {
>>>
>>>
>>> and maybe in a bunch of other places in there?
>>
>> You mean for fear of losing HWPoison flag in the earlier TestSetPageHWPoison(),
>> just set it again here?
> 
> Yea.
> 
>> Why not do it after get_hwpoison_page(), since that
>> is the expected page flag?
> 
> It's still in the buddy at that point right? I'm worried buddy might
> poke at flags.

Since __free_pages_prepare() executes entirely locklessly, the only way to ensure
HWPoison flag won't be lost might be only set hwpoison flag iff we can make sure
pages are not on the way to buddy...

Thanks.
.

