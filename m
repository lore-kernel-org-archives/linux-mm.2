Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA7D0CCF9E3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 11:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A758E01BF; Thu, 30 Oct 2025 07:51:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 412458E007D; Thu, 30 Oct 2025 07:51:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34EBC8E01BF; Thu, 30 Oct 2025 07:51:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 205F68E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 07:51:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA7DA13C0C9
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:51:53 +0000 (UTC)
X-FDA: 84054616506.06.9306936
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10764A000E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 11:51:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vfrNgpMm;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761825112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nh5loDZHBR2aksoB6uCQ/lMUHV6h0uNP+3aSbia5tGc=;
	b=BA6fbNWL9nmXaVvrRqN9/HZCHnVgfZ5/3+USLALLt8lcYCBcS/cXop4OUIiHKdFIY6QLDJ
	pHVuw+3spddBLJKIiSTVeCA1ZYxNNfkF9ispk0XRqeZMkW8pv/+C5jEIK3vkpbFoabb5A3
	nLdeun5G7FhGdKa572I34RFYgGRc6Zw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761825112; a=rsa-sha256;
	cv=none;
	b=oS8Hu1t1BzteMmQ4SLnynbZ6HbxcJTar19NeErgrhMBoxvpw/FnBs3uT/ulQsEvHcA5qaL
	LVUQjzdkPSoCuQIM3yvffI+jg3RGHVVlrrKvVHYsxVKCMV68jChcrI7uyxPz85cUEfWhos
	X81eQ1OsmB3n/wG+ZWJhwfRZ9MjjWsc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vfrNgpMm;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf25.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Nh5loDZHBR2aksoB6uCQ/lMUHV6h0uNP+3aSbia5tGc=;
	b=vfrNgpMmkXgqbSYfXZ3V1v/bCK4I7My7du3Bzz5TlGXy1XzzpH2MFNVJMJI3OCgPBKhBVZXdF
	nlp7F4g3hndm89KyhSUDGx5XXHusPtS018Vd17K1Jk5ywxYCb+JSNtpA7AUQBgCiyB1MLrmRNTx
	dV10jOoc4Slzkv8KnnJCCn8=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4cy2WP21CYzRhRF;
	Thu, 30 Oct 2025 19:51:13 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 1B70B147B7D;
	Thu, 30 Oct 2025 19:51:43 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 19:51:38 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 30 Oct 2025 19:51:36 +0800
Subject: Re: [RFC PATCH v1 0/3] Userspace MFR Policy via memfd
To: Harry Yoo <harry.yoo@oracle.com>, Jiaqi Yan <jiaqiyan@google.com>
CC: =?UTF-8?Q?=e2=80=9cWilliam_Roche?= <william.roche@oracle.com>, "Ackerley
 Tng" <ackerleytng@google.com>, <jgg@nvidia.com>, <akpm@linux-foundation.org>,
	<ankita@nvidia.com>, <dave.hansen@linux.intel.com>, <david@redhat.com>,
	<duenwen@google.com>, <jane.chu@oracle.com>, <jthoughton@google.com>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <muchun.song@linux.dev>, <nao.horiguchi@gmail.com>,
	<osalvador@suse.de>, <peterx@redhat.com>, <rientjes@google.com>,
	<sidhartha.kumar@oracle.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <willy@infradead.org>
References: <20250118231549.1652825-1-jiaqiyan@google.com>
 <20250919155832.1084091-1-william.roche@oracle.com>
 <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com>
 <aPjXdP63T1yYtvkq@hyeyoo>
 <CACw3F50As2jPzy1rRjzpm3uKOALjX_9WmKxMPGnQcok96OfQkA@mail.gmail.com>
 <aQBqGupCN_v8ysMX@hyeyoo>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d3d35586-c63f-c1be-c95e-fbd7aafd43f3@huawei.com>
Date: Thu, 30 Oct 2025 19:51:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <aQBqGupCN_v8ysMX@hyeyoo>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam01
X-Stat-Signature: k98qf64tnbfez5r333jnmq3g7cy6s4rr
X-Rspam-User: 
X-Rspamd-Queue-Id: 10764A000E
X-HE-Tag: 1761825109-150270
X-HE-Meta: U2FsdGVkX18vtc2E68IKc0db93EAlRP8sInJL68AaSu665Fyh5RXLpmSoDNj+lsSlVH52F/gSAGernvpN7dDHakc9KuSPaTZ/HHCm46S2qz+RUCq5UhCraGvE0ZW1eGPsnrcd5Ij6fud3nXGaAAYMJAagdyW0a5WzHrgiPTIWxZPGf5x/p56ZrIwrJnWSIy0OVFog8Q2j4esfO5yHMzJ+IdXCO6ctTkXyJwLAcTvIoyA8WVxo0TMI+6dhd/eSxWjJkPzJsZdBJN8I4mKEtQpyQIcRbcJPotJzIEi3ZmNKSPP8M5Cn6Y6xBKyXBLNeMoG1hPHL3oCraDjxwFxX5MXA/8XOcdheR+hPu+EwvwWVvy03yM93zbyAGTes7EmOKTvUWT8F2J/Eo/ETPZ02bBCi0R07uvZLXFfkWQ65+9gF03gaWCnYlMyr3PHNNOQp/DQ8yr9r920/yPVH27QT3UVnfj3s1TqHpQA7lAmURZoPrarjNxdR0o7HIvKLeJK+kpGZTzsJFJKIU0RXCc0HERqjl/F5pzicUyZTGvg1I8RGDUm3s9nKqpflg3Pr83dyPV7aC1GUN5GSAoyFIkBTk7Vzw/kphLVJ2+xCP2jbIU9AQ5xHNGRjYppWSmi8Dibb2+bN4xrf8rA3ajxIxdeAss63b9Ts1MOQc3+TAG2zGdk6L8HmO2wYtXDAoyLQwyfipodsu58EsFI0vH7DL/2DthFUOAzpIqUGEBDrlNxQLJFK+KrPrEz/EbmtODG2dz8wUUy/lnXn91uudUq9bq5EYqlZ2FWxBykJus2nfCC6XHe/rwWOsvNjiihgW2SADD5Qw69yn3JqGgQiq+G3AQvduen4PP+H7ZJ6J25bNvbQb47TyqPYldZVDiSps2TQknjQ6HKmCyU58PZU+Fdi47uXmGEp9wTnUN6I1yOCjiJ5hGg/QU7G5C06U7UngPxxJN94HqhlT0mgj8+yFctwij7ATZ
 PfkGEH+Y
 TZsIZ5TlnNaJuAiZGw2inmiYPusNrmnwOKdShOlbYubG/9rKt6WP/yEgLLGmJjVMrtBtysQxHXuCQ29J4Y5cPU0S1aQBjyI9E+CHbP7dzOqoeiBDJeFH5mJU4bpDnLKY/yGkhHcniSfjkg31FxmuEMc7uW3yniGSeWK3V32vJCRhxNhHVl4MyVzBWk2Vl46mo//pCPYd1/dj00OhuzQExfUEDkpScztCGbqaxg/lbJd9zxQscKijQA1c9XS4c2wpttwWoJwDoTDaVCEBCZKVqvAEdoSuhBKo1zzZhK5IxVq+UBqZHrgBm6x916oDXD3y4TlUpumY2mnMQ97XXTzHJsOcPZYEvv5cDuaEKVTeYpsotEnspIDHlKHbe0cbIsIWarIdDzfARsIvakzn/UnzIUaEXt5Zkjnt05Pv6QmUue2bkB08=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/28 15:00, Harry Yoo wrote:
> On Mon, Oct 27, 2025 at 09:17:31PM -0700, Jiaqi Yan wrote:
>> On Wed, Oct 22, 2025 at 6:09 AM Harry Yoo <harry.yoo@oracle.com> wrote:
>>>
>>> On Mon, Oct 13, 2025 at 03:14:32PM -0700, Jiaqi Yan wrote:
>>>> On Fri, Sep 19, 2025 at 8:58 AM “William Roche <william.roche@oracle.com> wrote:
>>>>>
>>>>> From: William Roche <william.roche@oracle.com>
>>>>>
>>>>> Hello,
>>>>>
>>>>> The possibility to keep a VM using large hugetlbfs pages running after a memory
>>>>> error is very important, and the possibility described here could be a good
>>>>> candidate to address this issue.
>>>>
>>>> Thanks for expressing interest, William, and sorry for getting back to
>>>> you so late.
>>>>
>>>>>
>>>>> So I would like to provide my feedback after testing this code with the
>>>>> introduction of persistent errors in the address space: My tests used a VM
>>>>> running a kernel able to provide MFD_MF_KEEP_UE_MAPPED memfd segments to the
>>>>> test program provided with this project. But instead of injecting the errors
>>>>> with madvise calls from this program, I get the guest physical address of a
>>>>> location and inject the error from the hypervisor into the VM, so that any
>>>>> subsequent access to the location is prevented directly from the hypervisor
>>>>> level.
>>>>
>>>> This is exactly what VMM should do: when it owns or manages the VM
>>>> memory with MFD_MF_KEEP_UE_MAPPED, it is then VMM's responsibility to
>>>> isolate guest/VCPUs from poisoned memory pages, e.g. by intercepting
>>>> such memory accesses.
>>>>
>>>>>
>>>>> Using this framework, I realized that the code provided here has a problem:
>>>>> When the error impacts a large folio, the release of this folio doesn't isolate
>>>>> the sub-page(s) actually impacted by the poison. __rmqueue_pcplist() can return
>>>>> a known poisoned page to get_page_from_freelist().
>>>>
>>>> Just curious, how exactly you can repro this leaking of a known poison
>>>> page? It may help me debug my patch.
>>>>
>>>>>
>>>>> This revealed some mm limitations, as I would have expected that the
>>>>> check_new_pages() mechanism used by the __rmqueue functions would filter these
>>>>> pages out, but I noticed that this has been disabled by default in 2023 with:
>>>>> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
>>>>> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>>>>
>>>> Thanks for the reference. I did turned on CONFIG_DEBUG_VM=y during dev
>>>> and testing but didn't notice any WARNING on "bad page"; It is very
>>>> likely I was just lucky.
>>>>
>>>>>
>>>>>
>>>>> This problem seems to be avoided if we call take_page_off_buddy(page) in the
>>>>> filemap_offline_hwpoison_folio_hugetlb() function without testing if
>>>>> PageBuddy(page) is true first.
>>>>
>>>> Oh, I think you are right, filemap_offline_hwpoison_folio_hugetlb
>>>> shouldn't call take_page_off_buddy(page) depend on PageBuddy(page) or
>>>> not. take_page_off_buddy will check PageBuddy or not, on the page_head
>>>> of different page orders. So maybe somehow a known poisoned page is
>>>> not taken off from buddy allocator due to this?
>>>
>>> Maybe it's the case where the poisoned page is merged to a larger page,
>>> and the PGTY_buddy flag is set on its buddy of the poisoned page, so
>>> PageBuddy() returns false?:
>>>
>>>   [ free page A ][ free page B (poisoned) ]
>>>
>>> When these two are merged, then we set PGTY_buddy on page A but not on B.
>>
>> Thanks Harry!
>>
>> It is indeed this case. I validate by adding some debug prints in
>> take_page_off_buddy:
>>
>> [ 193.029423] Memory failure: 0x2800200: [yjq] PageBuddy=0 after drain_all_pages
>> [ 193.029426] 0x2800200: [yjq] order=0, page_order=0, PageBuddy(page_head)=0
>> [ 193.029428] 0x2800200: [yjq] order=1, page_order=0, PageBuddy(page_head)=0
>> [ 193.029429] 0x2800200: [yjq] order=2, page_order=0, PageBuddy(page_head)=0
>> [ 193.029430] 0x2800200: [yjq] order=3, page_order=0, PageBuddy(page_head)=0
>> [ 193.029431] 0x2800200: [yjq] order=4, page_order=0, PageBuddy(page_head)=0
>> [ 193.029432] 0x2800200: [yjq] order=5, page_order=0, PageBuddy(page_head)=0
>> [ 193.029434] 0x2800200: [yjq] order=6, page_order=0, PageBuddy(page_head)=0
>> [ 193.029435] 0x2800200: [yjq] order=7, page_order=0, PageBuddy(page_head)=0
>> [ 193.029436] 0x2800200: [yjq] order=8, page_order=0, PageBuddy(page_head)=0
>> [ 193.029437] 0x2800200: [yjq] order=9, page_order=0, PageBuddy(page_head)=0
>> [ 193.029438] 0x2800200: [yjq] order=10, page_order=10, PageBuddy(page_head)=1
>>
>> In this case, page for 0x2800200 is hwpoisoned, and its buddy page is
>> 0x2800000 with order 10.
> 
> Woohoo, I got it right!
> 
>>> But even after fixing that we need to fix the race condition.
>>
>> What exactly is the race condition you are referring to?
> 
> When you free a high-order page, the buddy allocator doesn't not check
> PageHWPoison() on the page and its subpages. It checks PageHWPoison()
> only when you free a base (order-0) page, see free_pages_prepare().

I think we might could check PageHWPoison() for subpages as what free_page_is_bad()
does. If any subpage has HWPoisoned flag set, simply drop the folio. Even we could
do it better -- Split the folio and let healthy subpages join the buddy while reject
the hwpoisoned one.

> 
> AFAICT there is nothing that prevents the poisoned page to be
> allocated back to users because the buddy doesn't check PageHWPoison()
> on allocation as well (by default).
> 
> So rather than freeing the high-order page as-is in
> dissolve_free_hugetlb_folio(), I think we have to split it to base pages
> and then free them one by one.

It might not be worth to do that as this would significantly increase the overhead
of the function while memory failure event is really rare.

Thanks both.
.

> 
> That way, free_pages_prepare() will catch that it's poisoned and won't
> add it back to the freelist. Otherwise there will always be a window
> where the poisoned page can be allocated to users - before it's taken
> off from the buddy.
> 


