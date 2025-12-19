Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96393D78770
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 19:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05A7D6B0005; Fri, 19 Dec 2025 14:09:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F18E76B0088; Fri, 19 Dec 2025 14:09:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E24466B0089; Fri, 19 Dec 2025 14:09:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF57E6B0005
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 14:09:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 73E4D140191
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:09:10 +0000 (UTC)
X-FDA: 84237158460.04.6F3BAF9
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6A1CA40017
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 19:09:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766171348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=08Aap5rVeLDcoJSPxOKGigxMNJ0jHQYrF80x237zxZo=;
	b=AedIM5cV8yiVlhPSb/x26y4gHEpYYU4dapM5gBJtYJTjxrRjScTzED/jFoimJGo/26jZWO
	5G6VfrTQ8q/A4heRfTmDNNcDIJw5+l4nUc+31X1St5YP7b76ZL0urz5DAesVdUycbYMtEy
	SgOg21jxQPhWr5Cwx5GmbnyyAzd/+3w=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766171348; a=rsa-sha256;
	cv=none;
	b=0nef8UspQ0bHRT7FhJBhILuNhQr8takSqNr/KOSgBiMIzIQ1HyZXmVVfvXhgLr1sIgnLyi
	vsACu5NQEVwNjet1ZG4asVX+8vZbl7xoFBYho7M4HHR7flk/kQeoxz9eHKoy4WhCHCbEF8
	pUHLn8c4A2N2LpbW+c7rmmOH5ftl12o=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dXxrt3QF2zHnGf4;
	Sat, 20 Dec 2025 03:08:30 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 1F0EA40569;
	Sat, 20 Dec 2025 03:09:00 +0800 (CST)
Received: from [10.123.123.67] (10.123.123.67) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 19 Dec 2025 22:08:56 +0300
Message-ID: <ed1dcc5d-1e80-44ad-b050-e37460d3dac7@h-partners.com>
Date: Fri, 19 Dec 2025 22:08:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/2] mm: implement page refcount locking via dedicated
 bit
To: Kiryl Shutsemau <kirill@shutemov.name>
CC: <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<alexander.grubnikov@huawei.com>, <gorbunov.ivan@h-partners.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>, <yuzhao@google.com>,
	<baolin.wang@linux.alibaba.com>, <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
 <81e3c45f49bdac231e831ec7ba09ef42fbb77930.1766145604.git.gladyshev.ilya1@h-partners.com>
 <iv7m5rmuwssltl6yzwuop3ry5s4l653lykyvrmmy6qdbyyuoew@th5xuev3mwus>
 <9822c658-c2f0-4b1c-9eef-9ffa865e44f7@h-partners.com>
 <ans3mrfqd6jv5hfarbx5bzsl2ugtatbfyjw2vlv5ybuhevjc4i@46f45fdds5m7>
Content-Language: en-US
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
In-Reply-To: <ans3mrfqd6jv5hfarbx5bzsl2ugtatbfyjw2vlv5ybuhevjc4i@46f45fdds5m7>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.67]
X-ClientProxiedBy: lhrpeml500012.china.huawei.com (7.191.174.4) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: 9pno4jbyxrtqkbdoa4df4e16f5469x66
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A1CA40017
X-HE-Tag: 1766171347-288003
X-HE-Meta: U2FsdGVkX1/gqngrWvyelLZXRgocBjB3k6cwGEv/jNAqj2kUng+xdarRRmCAUOqkeHjsgSMeyDLZXpZMdpgM3ltjMsMOrmVxttnI90QRNnByweLEaJzgy3dBAwGbfikP0VfSRLEwMZKjvXtbB1+Ok7hq30RCp7jAcyW7in3LT/zAE9s9LH3/slMMzBUD7/UAhP2YEGokAObKEMYSWQEL+JCixB+WLdfo8+KyGh6hpScUYGeRmsU9EFwnGZvV5K28GMzbiQEuMAiknQGxmVKgWtDGGOZKad0T5a43txedD6GxvBgB9sFCmo9HhgmhBh+lKdkzeWlItPQAyXu0gSaXB/U2ixhI2tPN+wsOqL46cbT0uUjBSY1ZZ11vRB8wL6x1lCNt/8UZ616q8QFLv6iotbffmLJpVsDc+DlDdOcH2ItSv8wifuC9B9/Wb5z+ZlyCzSoyjM+oKsWg5jij5gdhHvxezoSnWItNHv/a4vGWFtUo3pBVHelu48E8wVx+DWaSrBXJuVHJB61Sg0fWVZsjdhBcpelkL9V67Uk4B7wFDEehJq7Adgv42jKbiMAyiGZ8JeGr31TAtdrQCTvUSTLKC6K06iuszxZlWNcdHiEG5FmLC3itKhIvRXELeiSnoq7Z/+ZjOPMpICSI/K6bmzyI7/xAykD9h2urixlA+kg3RdzO5coRKE6+uCeqDhKYNAfkizbYrpAh3sokEx62eZCR3rlq/MpIjfZozXEWmaEMSxibwguxTeEMHVtG9KPBbOopGlAXuFegxdfju2Gye1d5RuPAOE2q90zzFuJ+MlkBzw3knSjjVcunbNNAzYnNNNQge3LUZNEZru26+SxwXn1dch9dlX5LhMDtiKKbDOrx1+UsFEjqqEYUAF0m3eAmpd1VesWGZvGXIlm47Le8WdT7pT1/FCIrsSXVuvixlbUWf898JvItwKJKYGyqxIWnWeBcy2ReRV4klIiQTLhJC26
 azxbSRXo
 9Q3gzoKz+lJtO6r2e01A5qI3Om5CzbRyWILoahX9+bm2uufE4gMMacTR3NzwEpTooiCE3Z6duk7iUWHCgnlpgn0wY4CU0pBgDLN7CgzWs5y2Ua8lH/BN96xsu42vrx43QIaOL1UIgwL7RZLs/4odU+z7dy5IZnLHIlm3rFcFwmn3J9zcFTIyIGTAtnSTa0NXKv3R5z7358xc0mZedL4BLXYllxtKnGjVGEgIw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/19/2025 8:46 PM, Kiryl Shutsemau wrote:
> On Fri, Dec 19, 2025 at 07:18:53PM +0300, Gladyshev Ilya wrote:
>> On 12/19/2025 5:50 PM, Kiryl Shutsemau wrote:
>>> On Fri, Dec 19, 2025 at 12:46:39PM +0000, Gladyshev Ilya wrote:
>>>> The current atomic-based page refcount implementation treats zero
>>>> counter as dead and requires a compare-and-swap loop in folio_try_get()
>>>> to prevent incrementing a dead refcount. This CAS loop acts as a
>>>> serialization point and can become a significant bottleneck during
>>>> high-frequency file read operations.
>>>>
>>>> This patch introduces FOLIO_LOCKED_BIT to distinguish between a
>>>
>>> s/FOLIO_LOCKED_BIT/PAGEREF_LOCKED_BIT/
>> Ack, thanks
>>
>>>> (temporary) zero refcount and a locked (dead/frozen) state. Because now
>>>> incrementing counter doesn't affect it's locked/unlocked state, it is
>>>> possible to use an optimistic atomic_fetch_add() in
>>>> page_ref_add_unless_zero() that operates independently of the locked bit.
>>>> The locked state is handled after the increment attempt, eliminating the
>>>> need for the CAS loop.
>>>
>>> I don't think I follow.
>>>
>>> Your trick with the PAGEREF_LOCKED_BIT helps with serialization against
>>> page_ref_freeze(), but I don't think it does anything to serialize
>>> against freeing the page under you.
>>>
>>> Like, if the page in the process of freeing, page allocator sets its
>>> refcount to zero and your version of page_ref_add_unless_zero()
>>> successfully acquirees reference for the freed page.
>>>
>>> How is it safe?
>>
>> Page is freed only after a successful page_ref_dec_and_test() call, which
>> will set LOCKED_BIT. This bit will persist until set_page_count(1) is called
>> somewhere in the allocation path [alloc_pages()], and effectively block any
>> "use after free" users.
> 
> Okay, fair enough.
> 
> But what prevent the following scenario?
> 
> 		CPU0					CPU1
> page_ref_dec_and_test()
>    atomic_dec_and_test() // refcount=0
> 					page_ref_add_unless_zero()
> 					  atomic_add_return() // refcount=1, no LOCKED_BIT
> 					page_ref_dec_and_test()
> 					  atomic_dec_and_test() // refcount=0
> 					  atomic_cmpxchg(0, LOCKED_BIT) // succeeds
>    atomic_cmpxchg(0, LOCKED_BIT) // fails
>    // return false to caller
> // Use-after-free: BOOM!
> 
But you can't trust that the page is safe to use after 
page_ref_dec_and_test() returns false, if I understood your example 
correctly. For example, current implementation can also lead to this 
'bug' if you slightly change the order of atomic ops in your example:

Initial refcount value: 1 from CPU 0
        CPU 0                                CPU 1
page_ref_and_dec()               page_ref_add_unless_zero()
                                     atomic_add_return() [1 -> 2]
    atomic_dec_and_test() [2 -> 1]
                                  page_ref_dec_and_test()
                                     atomic_dec_and_test() [1 -> 0]
                                  /* page is logically freed here */
    return false [cause 1!=0]
// Caller with use after free?

