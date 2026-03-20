Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C15C11093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 01:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFBFD6B042D; Thu, 19 Mar 2026 21:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAD8E6B042E; Thu, 19 Mar 2026 21:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2F76B042F; Thu, 19 Mar 2026 21:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AAFBB6B042D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:52:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 60E9E1E01A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:52:52 +0000 (UTC)
X-FDA: 84564767784.03.4C4CF19
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf17.hostedemail.com (Postfix) with ESMTP id D14A84000A
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 01:52:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6T07PN7I;
	spf=pass (imf17.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773971570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=khMgynY7/xecNfOI6fD4x8ErywNL4uqHecS6sJA2D6c=;
	b=O/ajHegtqKKz2ln31DYTL/AtcaZ8sa9PxCTCB1LGpx13AZaFpxFtEAnUYHRa5JCjZrefMt
	TKuoXjwNDiELSl61Y9K2EQiXOidC0JOgwLFkwWteLQ0VqBcAdOn313fyzeMT5DJ6HfQO/s
	NDNP8LAiTpTzZr6DZDdkyiCS4TCXOKw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=6T07PN7I;
	spf=pass (imf17.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773971570; a=rsa-sha256;
	cv=none;
	b=74Tb181Kr/A5vbnfDuJij9Hevione7b4Y2qz7PvDbFpjzaEfTRxP38vBuKlFrbWOxRpHxa
	zJhCB4R6+3XSQFsmEqJUEtqCKEV00dLt2sggNapRyzRkzsbardZEDUAgr29b52tOrxmD0f
	1xvIOm2OOs66fCHOiXs6/nL3g1ditaQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=khMgynY7/xecNfOI6fD4x8ErywNL4uqHecS6sJA2D6c=;
	b=6T07PN7IH+DNuwd8ZRtkzGl9iRmkSr/x5flU1mpnHu3Wr/PBOOkxc0x2dIW38MXuUQsbPQDoS
	VRR3Cbmw+yIP1+q1goNahK8eI97WXbwu+DlOczXQAI2eztXwGa55gmpOEAWaaPZae5GAu7m72El
	vFvSvXrBlVw2JaW2uVgbzc0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fcQRP2RmdznTVg;
	Fri, 20 Mar 2026 09:47:13 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 15E0D40565;
	Fri, 20 Mar 2026 09:52:44 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 20 Mar
 2026 09:52:43 +0800
Message-ID: <d9d50263-a69f-4a16-b409-caeec93c423a@huawei.com>
Date: Fri, 20 Mar 2026 09:52:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: Andrew Morton <akpm@linux-foundation.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <baohua@kernel.org>,
	<ryan.roberts@arm.com>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>
References: <20260319012541.4158561-1-tujinjiang@huawei.com>
 <20260319155101.f7a62c04a7bcfc838b63824c@linux-foundation.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260319155101.f7a62c04a7bcfc838b63824c@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: D14A84000A
X-Rspamd-Server: rspam07
X-Stat-Signature: yhmqe7samzhzrdpf6p51jmr37i96sadg
X-Rspam-User: 
X-HE-Tag: 1773971568-94423
X-HE-Meta: U2FsdGVkX188cz4+8BmyKtlOMiFopJE1kVlXXrALhd4hrfG9cUv1VqYFeZYByU/kn9JdHwC8v5VidjrRoBxhM2BYH6wvaQ5tN8II+5vg7D1+VyY1a/8eg7zK1eT8Z1IHl5iZDbWbjT4JZlZi6S5eqbpKqV/blDhCkLBW/SvbLgFUMda2lx8v6xm9+m7Z01Bo+Fr4HrkEzhucr29kNEYW0FX0IxAgSJoYt7uZY59UDab1QLjOBUkhXo0KKmhcS1jHWkAf1ZsqdXLgXvrOxvmhOwJ51FgdPUI5TBa6olyjr0jba/iQhjEnAwImN6yYdOo64FHRCQxxTN0SuWU8ztcdmv1LItg1EUy8biev5rh47d4J/RulquPVbWTD+GnHR53cDTASDNbjAJH2+ymzXXSNiahSmKVJGZgIrL1IkmTc2ZkODn8fUHZRd3635MrhmJDLfXCOAwDY3V+McKQmdLnL+eQHYOfWoA7+Xwd0WCClg0+/fE8Q49L1+8UXfnO1XPstZCnkalWRVFFmdqfRgpZ2vFd4N9XCv0H3wEwYnS+0m/iNkSj2A3YtocLDo1roZecHXfWGQQoPcFqle2ZfTAn7nV7+ZAu0mrO4nMcTJx0LRxPbRbzvSdJRHBbXTuAv26oCFGFKQwavF4nBCrfz1feWHWAMG4Aos1BXKvIWj33V6gtl19J6RawVG2S6VSTe0kSacFxIu9pLseOCZ+ZE5+rhcJKmHv0vrReR4ihNkaQtkz+q+FM2qGxlnmRCecaBkUwLbNL7qAU0TdiubtfuY73yXsDCYZK3ToSyUuP4061XOUWNmP0eIsGJmJJewJnEKIzIhmqmSWBjcVKtvgOmPXneAOuVkjaBgP3Q+4o7ZxdxV5yTCivER76zE7bZciFlSm3L4UOiWInKFHihMEeFw1dT0VuqAMG0i+kSjkgyMfh9Nf7Zj2zK5l7V3v8H5z8yHGqL2u9pfb24vXnubYyHhfL
 Tjniy9f3
 XaOx3/L4hJpJfUClhGVQxRy6GMYOAWXOD+FyGmyYCPy5HmT80sYVLVZqBzvxJlzBaIMaB+cgJzvkvaIlWsqZqMwOjgLlDAm5Z7Mbw+UdsXAoPSDwd7E06KDyJicbAsMfHHHzImOpOGa7crbMi1B8YRo0EtutChw05I2B/TqrYw1kvtfryJx8t7F9UyVev3vnD3D5PnyA3rsdfpURyMt03plDwD7Nstrd1pnQL8LBMTbOaKb7jErBBKsuSQIDhGBz96sQFVTVcjgYClwD0wnnvltYCfZJ2l0+y5e/ZvRNomuPZelYhxEZ8lBgS02b6lXiMxxJluE+SSohBZNksgl6kXM9PPNl9PVOeRQyVfpRyhlQvkGPV6MPDnKmU9Cl9GwH1uaPQOY9MnqfYNeQwj//vAFeB/QwmOvYIUZfK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/20 6:51, Andrew Morton 写道:
> On Thu, 19 Mar 2026 09:25:41 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
>
>> On arm64 server, we found folio that get from migration entry isn't locked
>> in softleaf_to_folio(). This issue triggers when mTHP splitting and
>> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
>> in softleaf_to_folio(). The race is as follows:
>>
>> 	CPU0                                             CPU1
>>
>> deferred_split_scan()                              zap_nonpresent_ptes()
>>    lock folio
>>    split_folio()
>>      unmap_folio()
>>        change ptes to migration entries
>>      __split_folio_to_order()                         softleaf_to_folio()
>>        set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>>        smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>>        prep_compound_page() for tail pages
>>
>> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
>> are visible before the tail page becomes non-compound. smp_wmb() should
>> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
>> result, if zap_nonpresent_ptes() accesses migration entry that stores
>> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
>> page before page->flags.
> Please describe the userspace-visible runtime effects of this bug.

This issue will trigger VM_WARN_ON_ONCE() in pfn_swap_entry_folio().

This is a BUG_ON() before commit 93976a20345b ("mm: eliminate further swapops predicates"),
which in merged in v6.19-rc1.

>
>> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
>> in softleaf_to_folio() and softleaf_to_page().
>>
>> Fixes: e9b61f19858a ("thp: reintroduce split_huge_page()")
> So we know whether a -stable backport is needed.  Thanks.
>
>

