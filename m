Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94CCEFF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 02:12:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D1846B0088; Mon, 27 Apr 2026 22:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 981FD6B008A; Mon, 27 Apr 2026 22:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897986B008C; Mon, 27 Apr 2026 22:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79D576B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 22:12:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C2D5A0308
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:12:19 +0000 (UTC)
X-FDA: 84706339998.12.684FADC
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf23.hostedemail.com (Postfix) with ESMTP id 643C3140008
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 02:12:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pbhsaEsB;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777342337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Enox5Vkt8tF4CpqLalAd+r2y+h4+O++GHfXO/5f5xo=;
	b=mEjvhrZ2A2MGQaV4Az3UmLOhGR8WOoQJU5ibzYkJIKbRKXhVhMod3ml37+lePHRi1a4Wqt
	Nk7kVITYyFkOHE/GPFry3+KdK3q8/KTiTOVfeh7KmobhybGh8YJEEiMN0niv8ocAgbIcx9
	kqxGg0DM9DhcFQ5HGw8ZA7x2WGwHEyY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777342337; a=rsa-sha256;
	cv=none;
	b=tgn8hsVeDfWs7pvbLEiPJQ+qx6E7S8fcl24HikGdOjZTa7JEte1pX4A1AF0EELx5Eyb3Mj
	JlmenJOrgyjZH6Nquph+vyfXe/niIj24dO9seiFCqeKk3Apxv+qA9rUM2l0pmNg12FtfP/
	UWjJjzpiXjWpCYOVhr/s3Mnc6GtF6SM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=pbhsaEsB;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4Enox5Vkt8tF4CpqLalAd+r2y+h4+O++GHfXO/5f5xo=;
	b=pbhsaEsBxaon9RY0edAUzYstgxT54awUbXe9sgCZOPKcscpO2JfAyWiqfZnzKo3XpuCBU20Mm
	I2TCUPDQCKcWU4/uK6cdDVuLNRJvRIPXu9I1ST+WY7KrQXzFPiqdc3bQIf7CcXs/dEjNaH2URGy
	+hr2pdb8Y2C8v7hsdr5yvyA=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4g4P0w6dntz1T4JS;
	Tue, 28 Apr 2026 10:05:52 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 78D6940561;
	Tue, 28 Apr 2026 10:12:11 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 10:12:11 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 10:12:10 +0800
Subject: Re: [PATCH v4 2/3] mm/memory-failure: add panic option for
 unrecoverable pages
To: Breno Leitao <leitao@debian.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <kernel-team@meta.com>, Naoya Horiguchi
	<nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
References: <20260415-ecc_panic-v4-0-2d0277f8f601@debian.org>
 <20260415-ecc_panic-v4-2-2d0277f8f601@debian.org>
 <6b505601-747a-0812-7544-63a8ab3cffce@huawei.com>
 <aejlg62nxcF_5g2v@gmail.com>
 <c1517ad3-91d1-2ea1-efa7-0f29415d513d@huawei.com>
 <aeta8Ifvmqi6-E8w@gmail.com>
 <5e05384e-740e-b374-2370-01f96d1dac9f@huawei.com>
 <ae93PTScNGzxo7aR@gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <a39ff9fd-74d2-86bd-fd44-e6c2de16d249@huawei.com>
Date: Tue, 28 Apr 2026 10:12:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <ae93PTScNGzxo7aR@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: 643C3140008
X-Rspamd-Server: rspam04
X-Stat-Signature: oxawo181r8sasyyaj69iqj9hxpk9pdu3
X-HE-Tag: 1777342336-259662
X-HE-Meta: U2FsdGVkX1+yxKHv5g1WyuhHO9qlwBdYSS9eifpTTnQgR/gYmef3AGJvLIK1UNb80lr6LB87MD9oSzyonFdKKxls6QUd21nnipSfWZFYu6AsEt1OYE63h2cb+AqpNJecHbTiagP5VaEm9qKZfMm71GfohjRgTiP4q0XSSEiWh1FnpnTAjnJTFU7D5Isvc/eptSNmo7T6ZC143a8O0Y3GcEAkzNDU4z7LnQcy9kz0lw+ECpNHuHrISIuWyiXAgHBOY3UTGIvqeCDK6hxvxV0L9/Eayjldi0l3gAthiIYCtOhgLQEA5bYXz7kC2/O9XM6IybcbT18CO8+OXjO6eFiONM1WYzr9T/hj80zrLVwl0DGapq+kcjSkIlZRxBBMe89EcV8nHS8Q2LjwidrTVdNv/EVNJWgiZFIDSjrB8FCwvIhCoKgXGxUvEuglk7iRt0Okvdce2YVU0qjmmwViWrWyoaV9eONKTJOvM/pKs7YE1OzkyPdiZUBAb5gCzM8NKloreI5L1tBrC70bsJfJqj0+xglnrdD4JICM5d8ohQs0/bL6xeqreezQ/kR4QSiQe7+daU59QtKnKK1U12roCeaQNLBHjh+oNCXbDcVCKq0IdIBBP98uaYlMcpIdOhHIn7HvkCqZCxGjhKUN5DEzUIh18vsFhKUb8uCoNvwMTTycMP2KP/9fAZTY1NJ9KfyXBuvxDPY9PujaZ5uqvRRIP0/Qqqz0d5DuX+4lMI4yNWtsoqJZxinuTLATJhBkRhFbQSU8kYL8+n8XhkNh7CgAeWJwe2ji+yvOpyBeoL01TnOKBDXSdevqoRdAExHD5HTZGZ5Syjg44Gv3bpuySxkYzWicKzQZqgRMuzSh6un7t+N50hY1wpIZHHUetYVn5vGSIUsLePxnYfoukzjwm7KZjC94G1SAZoP04IJOS0OYNP3kWhQEZpMIjPImFue0hHGkzQQaf/3jCOglc/xaGvsvFFG
 N2NnU/FP
 7j7V6YCLKqgn8AOrTk+kjykgNRVcOGx/QHHGIvSYTVjgrnH5v8zNHHL2DKCc8mIRq7ztikwpPjfUoQKPHprezeKTi5BES5sYAbE0I/eSzWlUVTlww/BAvSsqc8P8674aKX/+2Qn0lIP8/CfbcLWmPh8qh7cOExsN9EvNcLB4OOwm0iZ05DIyPboJvbyq8+Zh7MIYknPcqfEcA3S/FRkMHt9s1LcF0mHHws1P1qrVL2GdQ+kv2kGDYO+P+FO/mM66aTixLzi9eDGUQBGa6KHGfuOcYy42/PLy/nStcGd6QlL5x/FDFLn3OEoBPx5IpfhBjUhfpsh3OCEjAN0in+2BfmemuPhI8z1OOsBdeUqE1ZVKNaRqHv18cJ/JJZw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/4/27 22:49, Breno Leitao wrote:
> On Mon, Apr 27, 2026 at 10:44:55AM +0800, Miaohe Lin wrote:
>> On 2026/4/24 20:01, Breno Leitao wrote:
>>> On Thu, Apr 23, 2026 at 10:38:19AM +0800, Miaohe Lin wrote:
>>>>> are you suggesting I drop MF_MSG_KERNEL_HIGH_ORDER from here, or, document this
>>>>> will not hit userspace pages?
>>>>
>>>> No, maybe we should rule out or document above rare case if I'm not miss something.
>>>
>>> Good catch. A buddy page being concurrently allocated to userspace can
>>> briefly satisfy get_hwpoison_page() == 0 && !is_free_buddy_page(), and
>>> that page is recoverable via the standard SIGBUS path — panicking on
>>> it would be wrong.
>>>
>>> The page allocator can't filter it out either.
>>>
>>> check_new_pages() is gated by is_check_pages_enabled() and is a no-op
>>> when CONFIG_DEBUG_VM=n.
>>>
>>> For v6 I'll try to rule out the race inside panic_on_unrecoverable_mf() so
>>> action_result() stays unchanged:
>>>
>>> 	case MF_MSG_KERNEL_HIGH_ORDER:
>>> 	p = pfn_to_online_page(pfn);
>>> 	if (!p)
>>> 		return true;
>>> 	cpu_relax();
>>> 	return page_count(p) == 0 &&
>>> 		!PageLRU(p) &&
>>> 		!page_mapped(p) &&
>>> 		!page_folio(p)->mapping &&
>>> 		!is_free_buddy_page(p);
>>>
>>>
>>> A buddy page being allocated must transit rmqueue() → prep_new_page() →
>>> post_alloc_hook() before the caller can use it. Each step either bumps
>>> _refcount or sets state we can observe (PageLRU, ->mapping). cpu_relax()
>>> lets that remote-CPU progress become visible before we resample.
>>>
>>> A genuine non-buddy high-order kernel tail page stays unowned across the
>>> recheck, so the panic still fires on the case this series targets.
>>>
>>> The window is much narrowed now, not eliminated — I'll say so in the changelog.
>>>
>>> I also added a selftest that enables the sysctl, injects MADV_HWPOISON
>>> on a userspace anon page in a forked child, and asserts SIGBUS (not a
>>> panic). I've been running this in a loop for hours, and I haven't seen any
>>> false positive.
>>
>> The userspace anon pages are already allocated. Those pages are in a stable state.
>> So your selftest cannot test above window. Or am I miss something?
> 
> You're right, the test doesn't directly hit the race window. By the time
> madvise(MADV_HWPOISON) runs the page is fully owned by the process and goes
> through the steady-state SIGBUS path; the buddy→user transition that the
> recheck guards is already over.
> 
> What the test actually proves is the negative: the recheck didn't break the
> common, non-racing path — i.e. a normal recoverable userspace page still
> returns SIGBUS instead of panicking. It's a smoke test against gross
> regressions of the recheck logic, not a reproducer of the original race.

Got it. It would be really helpful to have a selftest guard against sysctl_panic_on_unrecoverable_mf.

Thanks.
.

