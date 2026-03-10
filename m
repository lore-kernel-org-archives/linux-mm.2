Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44061FCC9AD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 395C16B008A; Mon,  9 Mar 2026 23:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343A26B008C; Mon,  9 Mar 2026 23:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246006B0096; Mon,  9 Mar 2026 23:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 110EB6B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:23:46 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B58F7C1AFB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:23:45 +0000 (UTC)
X-FDA: 84528708810.13.886C9CE
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf01.hostedemail.com (Postfix) with ESMTP id ED63440005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:23:42 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KTohcUNo;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773113023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9aCjyy9Ivp4IuGzOf68ouXeTqJVl/1CRtfxbUD2mUY=;
	b=FK4ZueKoWaaTSsmPjIBCtX9lB8DXkGZJ3ErT7aPKQEnZcWSkdesTT5stB6qbf0XYsdqaeV
	AgS56lmB9xWaTX1SHi3FebRYl493bFXZIu1ZbLSAx2PObX6xwtu569bV+Z8v0iaPb5iElS
	GUdIsZ/m9y7Rmk9XiJD9mkLYplkjpN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773113023; a=rsa-sha256;
	cv=none;
	b=tYtQr5hNXTPZUBau2YQU1ZzQ2ysjdAN5PdhAye8K/6T1BdfXaOB9Kwzr+iEzNuRM25ISo1
	5Mq3KzOXTJL0kwBwodQOsMfHU5NudwsDkV6BxW2ci9vOfheYR5MVMQiM4hh1qsCy0XLupB
	g0/QxWnO7TOo468hkYFwuWQV4aUSXhc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KTohcUNo;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf01.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=yintirui@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=l9aCjyy9Ivp4IuGzOf68ouXeTqJVl/1CRtfxbUD2mUY=;
	b=KTohcUNo5yPnpBwxWNsiG0U2ABQUIN+6YMbTKUL9F0hOHqWYPe6XTb3uVVGTwpaSdRC9wnNRX
	LoeD4efi4BqwN+J8YRKKo63ISlpCFMYEuPrxVwbDIs6mO5+IgrzSSvmq4bCyo94ZiqWHF66/w91
	SajYWi4QM9z3Z+u8+/ug3ZE=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fVJxY6sKnz1prKR;
	Tue, 10 Mar 2026 11:18:41 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id CEFF720104;
	Tue, 10 Mar 2026 11:23:38 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 11:23:36 +0800
Message-ID: <c62b1584-5ce7-44fe-81d6-b3eb2df942b8@huawei.com>
Date: Tue, 10 Mar 2026 11:23:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 1/4] x86/mm: Use proper page table helpers for huge
 page generation
To: Jonathan Cameron <jonathan.cameron@huawei.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <willy@infradead.org>,
	<david@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<tglx@kernel.org>, <mingo@redhat.com>, <bp@alien8.de>,
	<dave.hansen@linux.intel.com>, <hpa@zytor.com>, <luto@kernel.org>,
	<peterz@infradead.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<yangyicong@hisilicon.com>, <baolu.lu@linux.intel.com>, <jgross@suse.com>,
	<conor.dooley@microchip.com>, <riel@surriel.com>,
	<wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-2-yintirui@huawei.com>
 <20260306092903.0000268f@huawei.com>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <20260306092903.0000268f@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ED63440005
X-Stat-Signature: 8t5p387hpuatwkkhnb3ctc54yjpjmyuj
X-Rspam-User: 
X-HE-Tag: 1773113022-595733
X-HE-Meta: U2FsdGVkX1+gO2qSI6j7qSq3Tw5qP7rIdJJ+hvBUs+GU+7KzCWPNe8+hWG7W/4qXvX4LYfvy4L8qS99Suabtmrzu09oOKVpEKJULED2BWNusEeEXAk+zhd6kazFAPHqXbUIxOBNEvNWdgZKG2IXuBVlx271nuuEkoCXiNgorF0dW7VNlTRuyTZgkBBsLfQEau2nKWiWSGZMx+TaxIxtJYEvmF3NhPXIl9/dgLwFA3TKgsDbYVB9pT+d6H5M0HeV2gxSCZUqzDCs6j6vcFqipPvUKLCu5RnwTSWc5aRgJpmud+AyKxDKPbnRYxnFLMwhej+wrWykp2sjpmDaIkjR7YFCp5unwXpa40rK8TIg960k42RBqbAcQVkMVdkIgIz+Hu/5trliW3SBTVTTF5s/CFCr7h2rCrxvr/3UG7urHuvKzCu0PBBEqbtN4Wm81eRC96LSycHlf2FzCOFYhT5xJwEXTkSO3vVkW45R14zmrKPvgwp69W689wuMQHPydKDk6jwUJE4X5SN42gUxgbRUj5fYvI+L6/HPr3lZhyVNTFP2l5CVYzLjMlOOwQb56NdIeu98aIufYb+ug19HC8yYXTxjhCaY/G8Sf9e0qFgroBhGD7HLBk/4GOcSR+P5Wkrc1L0O/D7T337L+Pah/ZEi6KvwdgAo4akfDeDwC40p2CFWSNSJ/mRWTV6LcTKQhqlXglo80TxveNxVzXl8qFqLtrlhAviirxvcp/hnKTL2RpbgMhcqNtmbLe4CTkwG7T05XjFNDSpfPJzvYKD0oEQCey0UWCzUeBaqFLCjvGdXgfBb0Rp1RUu+miWEr4FMywjzTSO0bv32xtReHSGOwJJgPbpHHIeA6q6hKbu1kGdcWRowULKK8lqscvJul5LbsPNHEoOXnQIlYUbkI+scbaXrpsN9kVcVdBvIOBs8g1/7DOaS+oC4OgblydBp0tlFzgCWxuL6cFAajj/w8xUec3ue
 Axu3/mQj
 FTjjPNyRXnFuA6Txhe8dYA/UVjzZ3keviagSaMkGFdfSTEiwETxKGnJcK7d5vf33DeD4beAbE3G0lKiHWG5UMElyD7W2uH9peuDOq0YlX/sbrWT5jMO3YNaQvKRsgh2W1pBuj998TCKSE1gBcvCaU85DnMKsvv/awCK6YAus7w4EgUlPb3b6Nesp2y4sxHxbqa5x6mwdL2dCDauZY3j9UYannNiktgtysuG0NABuJxyJnt8AxbUWCmyel3H6SPoF3UKqKORhwVfnaedWuBCJjI9KXycwOxCY9pM138oaAGipqbUBmu+0JdCg1zncTZLmUbCqt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/6/2026 5:29 PM, Jonathan Cameron wrote:
> Whilst you are here, can we make that a one liner.
> 	entry = pfn_pmd(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL_LARGE);
> 
> Could even do
> 
> 	pmd_t entry = pfn_pmd(__pa(p) >> PAGE_SHIFT, PAGE_KERNEL_LARGE);
> but that's more of a question of taste.
Hi Jonathan,

Thanks for the suggestion, I will fold this one-liner cleanup into the 
next respin.

-- 
Yin Tirui


