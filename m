Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345C4CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 02:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 790868E0039; Mon, 29 Sep 2025 22:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 740F98E0002; Mon, 29 Sep 2025 22:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630878E0039; Mon, 29 Sep 2025 22:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50CEA8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 22:51:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 07BFC13B458
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:51:47 +0000 (UTC)
X-FDA: 83944391454.03.97B4DF1
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf12.hostedemail.com (Postfix) with ESMTP id D3BB440006
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:51:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iAbSmT09;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759200705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0cNtQr4557jtEaOFawLvfNZk92gUobA2ObLkEl8z4I=;
	b=AHgbCNB1RlPzOD/yenWoDizVO7ABV7JNNyEg9AnaSNTZhfJq9PXAkI3ieMexwv2ZjN5+44
	E7WZCXJI1+GFIoxmlySPygUL3P6VsJjvSvuiv1vEWxdpKhPWb3Izzqm1CQD6wODWyEdeAK
	CyDaFSONe/ksygadz1KfZZPDAU4a0Ew=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=iAbSmT09;
	spf=pass (imf12.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759200705; a=rsa-sha256;
	cv=none;
	b=59LYLIJ5++QajUDyHGG8Dk/bL6J4pbClaoQvvO81SfFV5sCoY1pLwMIEnRCwUhQTk2+zzi
	mO1ra8c7jaCDTf8oyP3wTs76lErvBb8vGeMBnmyXWcGWYhosBi0a4NnwC/cdHhhzZ9Z3ki
	UUpcEu3icQ2vd2oVBB57XncyOZMA3tY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=g0cNtQr4557jtEaOFawLvfNZk92gUobA2ObLkEl8z4I=;
	b=iAbSmT09ClD693sektscQaIBj7LE992j94gJB8RmPZDaxrPDUOy3EZfMudN5iTlCNINe8GBIS
	BfXIG9Ho7/lboCOmi9IZI6n6oCyZhebGrccd/f4cNW3Swubn0izNVPtLymL+RByg4ovg/fn1CvL
	xpNoK5ANLCNzlt1ennBpxdw=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4cbMyC2wwsz1T4Ln;
	Tue, 30 Sep 2025 10:51:15 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id C9CE21402ED;
	Tue, 30 Sep 2025 10:51:38 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Sep 2025 10:51:26 +0800
Received: from [10.173.125.236] (10.173.125.236) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 30 Sep 2025 10:51:25 +0800
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
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d15fec58-58ad-fd20-7130-9c480df43d15@huawei.com>
Date: Tue, 30 Sep 2025 10:51:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <c61ca94b-5b19-4c69-b2a1-d11a5301c6bb@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.236]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Queue-Id: D3BB440006
X-Stat-Signature: 6hrj7j9djji64tzxds9i4ii3ipjgms8q
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759200703-590942
X-HE-Meta: U2FsdGVkX18gwbGz10wWnPMTfwDUztS0J/tVPVNVCDmTe041YwEIvVWBdb37/QUPZEHs0rt7znevx4o9EMlOC7wSgyQ9rlVjXdLjmLj78VJlbEP2cnSCvj/xwmv8iTz2rDwiXMHGTFBNG2dCt9tJZhywUyD+gdocL9lji11Gr99QYaamMp/Z5una6JI8gjTwA2wgM+SmgED7QEGwPvC4OSC/HW1r1cyG2Mt2MwbXS80BJipLFv608zeS6Y3dJzT9HurUrJ9WTjPOnziy0sKMsSuxR5cRBONl220wHPQkdXTqCn7GDnSQFMPNlcppg3foZao0enXvceq0kaOQ8qIyIpPqL1NrKaEWaLWJTcG8nXmiaZhk3QHJIJY1JrM0r2/XqWhbfhABM3QYne3v3ITGQXlhFsyOS7txCud9fnGqFJZaepqHXGJRCy6fIJx6yRAykCcGVccnvP2P7uX13vmE3Nwu//uW/zQpdqPD2T1xzWnShdmH3FpdQG2PS9ltbmuZKggbzOje+0Np09O+y9LzkHYokEuVO4gZOtpdF4QHFuRY1KNuYkSULIm17h518RkqsTKX1CeicjYMmsiHQ8oCdTZeYlR5MZyMqxml/N0CYfKbL7NMfVMQYuUDKUMe3FNAhF/BXlYosWgy8tA3GKQYXDa39xAY2Fy13b6M4Qxel7eIQEzu1y07clc9IScdVVu/B9h6NB3vzglAeFiu7crPP3lWR8mkXdT19K+VaFaqYnGzRd893vag+TyIf7iZKOv3kTV7soyhphM8FaatEfQ/cCWrQs0Fmop8N6IxAaG7tRe6xaSf7mRSux6J39oLJgYjtyEDf4pq80lIz7tKLFTkscqZQNtpmZdPBD5nsYy5EEmVsPm06cZezyXi9yHXedUEMMTs0i9qpuLUaadb44qfvy+4Q7IUyv3OA6lzMZvu7TTXG49Pi4RulRE4f5CFsWUi4aOCQBQqEINl9WgR2yL
 xphc2TmF
 Kz3jwnGUmJ5KNpcytZuLcmT0GsoqT40kgwbfW6HeqKhM5d6hI74b9lW4cYZhQOZ8JhYioNVdSsjQheG6c62MwQulLjrIvjIqwsP6XcF21yr1DH78zapxUm8H52vO+ZM9R125GLf1kLc2vFmTw+yvbtc67WpZRFFtD/FNWDFEEWJrCJuM6bfznHWgCT9g7iM6DWcULkUDILvxlyUhaIhhrjpHYUWyLhPd7Dy5AESGbTqlugQoojsRjexVLU5FPrXVp1DWE5GXD0pqy/3ApI8gjkZIOaaKo9/wL0xYazrlWYSd/vtMlTh7Ha3FXnvyCdMi+iE86JKxdU6gfQhOCXDxLQbupr891gUvmubf6CXFhPhmaN4N7ILNgwsIYbUn0bi5O4lXqLo2VaXk6WnnItJUi+NwBh+1pBdj/A+wF3rzQPpW50YUSZiPClYyEa7PxgeExj3TqcoyFhD5kqMZ4jujStv8V9kCU9MA4bVft1xtPfhWVM3gr5p7eXHiW9jT9cjHPNKCnv4eaykvCZmiWAq8/HBwu7pOQ2HxYKZDp+N3XAXjAdH4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/30 2:23, jane.chu@oracle.com wrote:
> 
> 
> On 9/29/2025 10:49 AM, jane.chu@oracle.com wrote:
>>
>> On 9/29/2025 10:29 AM, jane.chu@oracle.com wrote:
>>>
>>> On 9/29/2025 4:08 AM, Pankaj Raghav (Samsung) wrote:
>>>>>
>>>>> I want to change all the split functions in huge_mm.h and provide
>>>>> mapping_min_folio_order() to try_folio_split() in truncate_inode_partial_folio().
>>>>>
>>>>> Something like below:
>>>>>
>>>>> 1. no split function will change the given order;
>>>>> 2. __folio_split() will no longer give VM_WARN_ONCE when provided new_order
>>>>> is smaller than mapping_min_folio_order().
>>>>>
>>>>> In this way, for an LBS folio that cannot be split to order 0, split
>>>>> functions will return -EINVAL to tell caller that the folio cannot
>>>>> be split. The caller is supposed to handle the split failure.
>>>>
>>>> IIUC, we will remove warn on once but just return -EINVAL in __folio_split()
>>>> function if new_order < min_order like this:
>>>> ...
>>>>         min_order = mapping_min_folio_order(folio->mapping);
>>>>         if (new_order < min_order) {
>>>> -            VM_WARN_ONCE(1, "Cannot split mapped folio below min- order: %u",
>>>> -                     min_order);
>>>>             ret = -EINVAL;
>>>>             goto out;
>>>>         }
>>>> ...
>>>
>>> Then the user process will get a SIGBUS indicting the entire huge page at higher order -
>>>                  folio_set_has_hwpoisoned(folio);
>>>                  if (try_to_split_thp_page(p, false) < 0) {
>>>                          res = -EHWPOISON;
>>>                          kill_procs_now(p, pfn, flags, folio);
>>>                          put_page(p);
>>>                          action_result(pfn, MF_MSG_UNSPLIT_THP, MF_FAILED);
>>>                          goto unlock_mutex;
>>>                  }
>>>                  VM_BUG_ON_PAGE(!page_count(p), p);
>>>                  folio = page_folio(p);
>>>
>>> the huge page is not usable any way, kind of similar to the hugetlb page situation: since the page cannot be splitted, the entire page is marked unusable.
>>>
>>> How about keep the current huge page split code as is, but change the M- F code to recognize that in a successful splitting case, the poisoned page might just be in a lower folio order, and thus, deliver the SIGBUS ?
>>>
>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>> index a24806bb8e82..342c81edcdd9 100644
>>> --- a/mm/memory-failure.c
>>> +++ b/mm/memory-failure.c
>>> @@ -2291,7 +2291,9 @@ int memory_failure(unsigned long pfn, int flags)
>>>                   * page is a valid handlable page.
>>>                   */
>>>                  folio_set_has_hwpoisoned(folio);
>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>> +               ret = try_to_split_thp_page(p, false);
>>> +               folio = page_folio(p);
>>> +               if (ret < 0 || folio_test_large(folio)) {
>>>                          res = -EHWPOISON;
>>>                          kill_procs_now(p, pfn, flags, folio);
>>>                          put_page(p);
>>> @@ -2299,7 +2301,6 @@ int memory_failure(unsigned long pfn, int flags)
>>>                          goto unlock_mutex;
>>>                  }
>>>                  VM_BUG_ON_PAGE(!page_count(p), p);
>>> -               folio = page_folio(p);
>>>          }
>>>
>>> thanks,
>>> -jane
>>
>> Maybe this is better, in case there are other reason for split_huge_page() to return -EINVAL.
>>
>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>> index a24806bb8e82..2bfa05acae65 100644
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>> @@ -1659,9 +1659,10 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>>   static int try_to_split_thp_page(struct page *page, bool release)
>>   {
>>          int ret;
>> +       int new_order = min_order_for_split(page_folio(page));
>>
>>          lock_page(page);
>> -       ret = split_huge_page(page);
>> +       ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>>          unlock_page(page);
>>
>>          if (ret && release)
>> @@ -2277,6 +2278,7 @@ int memory_failure(unsigned long pfn, int flags)
>>          folio_unlock(folio);
>>
>>          if (folio_test_large(folio)) {
>> +               int ret;
>>                  /*
>>                   * The flag must be set after the refcount is bumped
>>                   * otherwise it may race with THP split.
>> @@ -2291,7 +2293,9 @@ int memory_failure(unsigned long pfn, int flags)
>>                   * page is a valid handlable page.
>>                   */
>>                  folio_set_has_hwpoisoned(folio);
>> -               if (try_to_split_thp_page(p, false) < 0) {
>> +               ret = try_to_split_thp_page(p, false);
>> +               folio = page_folio(p);
>> +               if (ret < 0 || folio_test_large(folio)) {
>>                          res = -EHWPOISON;
>>                          kill_procs_now(p, pfn, flags, folio);
>>                          put_page(p);
>> @@ -2299,7 +2303,6 @@ int memory_failure(unsigned long pfn, int flags)
>>                          goto unlock_mutex;
>>                  }
>>                  VM_BUG_ON_PAGE(!page_count(p), p);
>> -               folio = page_folio(p);
>>          }
>>
>>          /*
>> @@ -2618,7 +2621,8 @@ static int soft_offline_in_use_page(struct page *page)
>>          };
>>
>>          if (!huge && folio_test_large(folio)) {
>> -               if (try_to_split_thp_page(page, true)) {
>> +               if ((try_to_split_thp_page(page, true)) ||
>> +                       folio_test_large(page_folio(page))) {
>>                          pr_info("%#lx: thp split failed\n", pfn);
>>                          return -EBUSY;
>>                  }
> 
> In soft offline, better to check if (min_order_for_split > 0), no need to split, just return for now ...

I might be miss something but why we have to split it? Could we migrate the whole thp or folio with min_order instead?

Thanks.
.

