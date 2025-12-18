Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B666D68BE8
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A31406B0095; Thu, 18 Dec 2025 02:21:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DBE16B0096; Thu, 18 Dec 2025 02:21:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DE4F6B0098; Thu, 18 Dec 2025 02:21:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C5216B0095
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:21:55 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0EBF3C0517
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:21:55 +0000 (UTC)
X-FDA: 84231747390.15.15F8297
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7A746140007
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:21:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MztbfNo8;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of linyunsheng@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linyunsheng@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766042513; a=rsa-sha256;
	cv=none;
	b=Y27eBP4flND4YPqdmm3awvdivQsMkgyifWW1M/UBXapSqrdCVCdxy1x3atLA+mqh0oneBt
	5FoDGdJHsCjpPf8klAdcREb1gFRSWkyXb+QIshtiuXGY+x6h7P9R8OmQ+s+amnc+o5mfND
	m4x53Ptjrgts8v7PJPg71vJpCgka15k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MztbfNo8;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf23.hostedemail.com: domain of linyunsheng@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=linyunsheng@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766042513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+pWCPz6K3Acb14sjvlVNRJs4ZVun+zx5u6e9fTe4Lk=;
	b=4upCqMTYmroZQjJVdol2brnRzQI+HN8hr7Oli6L5SHsCKdE7WI+Yak5WiB/JVMe3JeS5Rz
	ol+jE9Bf9j2EDFJq0Gw/KK2fk7FMA1rWW+x8dx29uDY4I+8u2/VTjWuI42yLfFcrd2tbFA
	bpkFAC9S0OWAgpT0sS9VeDLO5ZkD8eA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=U+pWCPz6K3Acb14sjvlVNRJs4ZVun+zx5u6e9fTe4Lk=;
	b=MztbfNo89mGT3RHiobzc/2N0VthipG6Fjx58mIbkg3d0MLPOkfJTNyTu77XFE4uo0kHEV662v
	koj9fUNXYKQrmypmkPiiUbNJURj3mR2EJ79mVPm01GtYjv0mHMcziDTJ+Y5FrlMEI+T+l66hXyl
	2/NlYTHLGDBkOL2LqrUeWAM=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4dX28D0vr2z1cyPb;
	Thu, 18 Dec 2025 15:18:36 +0800 (CST)
Received: from dggpemf200006.china.huawei.com (unknown [7.185.36.61])
	by mail.maildlp.com (Postfix) with ESMTPS id D3FF81A0188;
	Thu, 18 Dec 2025 15:21:38 +0800 (CST)
Received: from [10.67.112.40] (10.67.112.40) by dggpemf200006.china.huawei.com
 (7.185.36.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 18 Dec
 2025 15:21:38 +0800
Message-ID: <1f87565f-46e5-4281-a3af-64c6a8235848@huawei.com>
Date: Thu, 18 Dec 2025 15:21:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] selftests/mm: remove flaky header check
To: Kevin Brodsky <kevin.brodsky@arm.com>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, Mark Brown <broonie@kernel.org>, Ryan Roberts
	<ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-2-kevin.brodsky@arm.com>
 <b62c18a2-7036-4cca-a3e6-8a873a2ca832@huawei.com>
 <c59eb8d7-c6bb-4618-b7d4-2ce5df88b5f1@arm.com>
Content-Language: en-US
From: Yunsheng Lin <linyunsheng@huawei.com>
In-Reply-To: <c59eb8d7-c6bb-4618-b7d4-2ce5df88b5f1@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.112.40]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200006.china.huawei.com (7.185.36.61)
X-Rspamd-Queue-Id: 7A746140007
X-Rspamd-Server: rspam03
X-Stat-Signature: zb54dnkb11mborpe4qz5cg74tg4fdcta
X-Rspam-User: 
X-HE-Tag: 1766042511-942252
X-HE-Meta: U2FsdGVkX1/i2Da23G6YT7SjP0cyiIebPtLWjp6h0C3zKwsVgqo1QqVdTeOzb2PzIxEYGe5/Ogy32KniJH7OjJRyl8h3aJyEDdzK+H6kbMPAk3GXoiBAbfDdNN5zmzGblujIh8mKNK6m0c6dqe4SAHkwyBWVVSCgkOsFCOFkTLXVFT3Wzt2CcxWBC0EaorQJmrwg8qCO26UJsHm4ofxLkwf/wdMReZltOhB4J9B5wmjIDqOWEVaYfD7X7DeqXIPAYQASFYG50op+OmqYxH9f2z6a+JM+cwgubNjqubJnodkX3Z7bjX7zk5Ccc85XeA7TEOE7dl7n0BiRkSSYrYboeLlJwWp+VIYvSlRz3ExGxp9ZkTgKJzZ0obur+wb+LCmI+CobnZx8iczPONBKvnLmT92/d2OdlJhNRD7B9DYwTMXKx/trF1eq7hrqrnSzGAofhRldphdmyCi1tcK3Nz1EEmY7diGaMMZ0JXIY9CggX6NNw2qvol06phFXCIoVCp+W6W4k1C3KTfvaMV0aYZaNRbEhy+RNEzK9Y7tMDx4nq2zTbYM8VKO6Hp5/Gua+BDJomEqucpjuuQKHBTeIVMndDd07vI6U8Ggi5t0pXchcT05t58d7ZEub1XZp15fa9vdJe0pEPQMJM+C2xDsHIcElxORZtENqrjl1QxAD94hLFKPY/CSbx0/Bor7JGT/OPLuXPeiXyJdoBWEFZfDV0N3bSiVdZUu38INeXYFFTtaRQuKH8faE54DEcsrbVWqfz8tIfNZ6FUlq1CfojOjnThxM5mtgBIBOC2+nM8rlf2bzKxxZKjJxxuxIIWcNEhOlfVYU1eWhDPnSFM++9K3s5GS7Ttlb5t4yMikiSSc+xpCFQVEoVZuU2B0A6HrnZ9oQbWDhZRF/M2Xk6gKW6mw98HuyzE5VaB6j77jJ2VGWm6e/xwCdzeWb5nQfDKh86Tqto3GSaAbqKVEJKqgB483dA3d
 s5SgSM70
 AkFPDHAY7mf3h66nbuH4sopsP8eHOnI0BqSaFKlFEnhqhX8CFmqhPOGM96FWBMakOA/qjaH6e4KEP5I5irYPj9b6Ck3IuwwzXwY/WitHZMiD5PafGD1vhQUrWGSc3RILMji9aBpUBN7wGUpkVwS4/luD8KFZSx0y5arsfQlbWpDkS0nT/2JmjRFH375SzR6NLfpZ85kTod7DwZylBayN5GZCz7bwTvljh9F/KDQaqI5bRH5yqoi620EnwyaUmn6qH2i3qP3zdrpVmYf83s8MNlgG629FE8ZQD6vhDClmf2D72G7hKYJH2v6BGEefVNYdLGUff
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/12/17 17:58, Kevin Brodsky wrote:
> On 17/12/2025 04:18, Yunsheng Lin wrote:
>> On 2025/12/16 22:26, Kevin Brodsky wrote:
>>> Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel
>>> is not compiled") introduced a check to avoid attempting to build
>>> the page_frag module if <linux/page_frag_cache.h> is missing.
>>>
>>> Unfortunately this check only works if KDIR points to
>>> /lib/modules/... or an in-tree kernel build. It always fails if KDIR
>>> points to an out-of-tree build (i.e. when the kernel was built with
>>> O=$KDIR make) because only generated headers are present under
>>> $KDIR/include/ in that case.
>>>
>>> <linux/page_frag_cache.h> was added more than a year ago (v6.13) so
>>> we can probably live without that check.
>> As some commercial OS still uses v6.6, I am wondering if we need that
> 
> Fair point, I hadn't considered that kselftests are supposed to be
> buildable against older stable kernels.
> 
>> check for a little longer, is it possible to do something like below to
>> avoid the flaky check?
>>
>> @@ -46,7 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
>>
>>  KDIR ?= /lib/modules/$(shell uname -r)/build
>>  ifneq (,$(wildcard $(KDIR)/Module.symvers))
>> -ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
>> +KSRC := $(shell readlink -f $(KDIR)/source 2>/dev/null || echo $(KDIR))
>> +ifneq (,$(wildcard $(KSRC)/include/linux/page_frag_cache.h))
>>  TEST_GEN_MODS_DIR := page_frag
>>  else
>>  PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"
> 
> That seems reasonable, and it works for my out-of-tree setup.
> 
> Will do that in v2, shall I add your Suggested-by, or maybe Co-developed-by?

Yes if you want to go that direction.

