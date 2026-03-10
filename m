Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 898ABFCC9B2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:36:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A58266B0089; Mon,  9 Mar 2026 23:36:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A05A26B008A; Mon,  9 Mar 2026 23:36:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93BEE6B0093; Mon,  9 Mar 2026 23:36:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 816026B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:36:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 11E26139E41
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:36:39 +0000 (UTC)
X-FDA: 84528741318.30.CA3CF82
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf14.hostedemail.com (Postfix) with ESMTP id 76EF3100007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:36:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="u/Y5l5+N";
	spf=pass (imf14.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773113797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ot5C4phsn/D5HCjzZ0Ig3HqX6b1yZe2wL22xhQfLHmg=;
	b=IFSXXL9T8AzAs3tVxgHQkUtSisyovwlfGElmicOyrmXnV7cl0qxqAGnYUkBISLGlGSZWI4
	fuYdlaVBjMP8ckRqLQkGtgAKViQ89sY+gmwk9pa2+99BReDoE4So6AApSnwwjXDJoz63iV
	taanGKSENZPyB+0lOvCg+W1csybQdPA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773113797; a=rsa-sha256;
	cv=none;
	b=nAKWyAlhm0yo8LTS/2GqYtvwQZAbwJRxVMCyTGoVCVcdGOZ4c79kQaCH6JitYqaaH4U2eB
	f49XaF9wju+2bvK1TNSXYc8CG5v9uxDOb0+VJDEUTtnBvmRb+OnAGijno7i+oVDOHRK5qu
	0IL2SYzWPc2I+c4mnPudVC90uiPEDZo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="u/Y5l5+N";
	spf=pass (imf14.hostedemail.com: domain of yintirui@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ot5C4phsn/D5HCjzZ0Ig3HqX6b1yZe2wL22xhQfLHmg=;
	b=u/Y5l5+N4i469pymJs6TizNMRhaXRY3XQYDkxsFl8M0qt2iPo/czlg6L4roHgwf6Ip1oXoqm1
	ascKg5gs8YVj2fROA1QIFoKpqalvRjzL7LS7HXslvZjro8o1K1ud6Vkerhap9qLy7VjeW+0w97x
	UGB+091hZnHHBRVLz06b+qk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fVKCg5mZDz12LCw;
	Tue, 10 Mar 2026 11:30:55 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id F058D40538;
	Tue, 10 Mar 2026 11:36:31 +0800 (CST)
Received: from [10.174.179.248] (10.174.179.248) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 10 Mar 2026 11:36:29 +0800
Message-ID: <0dc36f64-3e6c-4e4b-bdd1-6e364babb0bc@huawei.com>
Date: Tue, 10 Mar 2026 11:36:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 2/4] mm/pgtable: Make pfn_pte() filter out huge
 page attributes
To: Matthew Wilcox <willy@infradead.org>
CC: =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <david@kernel.org>,
	<catalin.marinas@arm.com>, <will@kernel.org>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<anshuman.khandual@arm.com>, <rmclure@linux.ibm.com>,
	<kevin.brodsky@arm.com>, <apopple@nvidia.com>, <ajd@linux.ibm.com>,
	<pasha.tatashin@soleen.com>, <bhe@redhat.com>, <thuth@redhat.com>,
	<coxu@redhat.com>, <dan.j.williams@intel.com>, <yu-cheng.yu@intel.com>,
	<baolu.lu@linux.intel.com>, <conor.dooley@microchip.com>,
	<Jonathan.Cameron@huawei.com>, <riel@surriel.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-3-yintirui@huawei.com>
 <5eaf3846-01db-471e-9903-b0b239d7838d@suse.com>
 <e8d5ba16-3071-4b4a-b6a1-d492cc46e8c2@huawei.com>
 <aapXRN4KjWtUUJ0g@casper.infradead.org>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <aapXRN4KjWtUUJ0g@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.248]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Stat-Signature: k1z6ttwuchrgoa6uphdyrua5wm3jtkhh
X-Rspamd-Queue-Id: 76EF3100007
X-Rspamd-Server: rspam03
X-HE-Tag: 1773113796-647174
X-HE-Meta: U2FsdGVkX19c5Xi/CBeEVb37WMAZCAPHzN5CFFO/Obif56jaZdY13vINZCEGA3uWVwXlbFJjSevuEt4jMWoHysm7SK05HDC8U7s0Gx8fopcWwfCUYzkTqIaMfI4Qe5Q93i19COcgqdWNanBWe1jeiGYWbfXscXgYztOOnwQiGVrLs6HZIBwCj7aPVNChY0UUQGc4jb6gavfDb5iIyirirIRfPYNvxjksuZQMsr4MDUeL1428UURh0u8SyW3ykUi7sM5pqc/BLBuHS0nZaqb3dhkGSGgznCFsAtY3wmqhLGijhA+11VIRh8RDhAUeNWBsTdS6QNrviz+htoQ3x95Eyo2NrjyjxMVfw4yGHVWyAilrAHpod0AiJD1VvfUzPbW/ezlFOg4+B/a7AGBom3WsuEcU9dchuSo3YeecccYOBZJwPP52uB+k3nx8QjLQhJ7RU9NK4uh5uF1WOJ0OCGwXOZdoyUobdZCZwwbGPsNFQKjhUq4W4oMvKg5K0TqsyO60NFgt8mCl67q77XGcOfhZ4mDbz6p7FBWy+vmUVvUQ4+nlGqQ4BBQzGDvjyAKXH4Y4/zm+LD05Qt1JVV+ShjzS5l4kRDXPF66Cp4CA2C44Z9r3dgS57R16jCnhwTZbAeVO1UMASYTHNNki94dEvu096Di/WkH9Hq+vsimmSRWFcYgTU4BB7+ntFnqRJx9SH4ffv0EoOF0k2a305RMKoE44h1yVCyiWDPIY+V8gVTrYhFHVVrIEifjpDrim746aPD4TqWt/epDuLnFVzJEgnHvLrDsglSDaS274aSp/fGhCI1zdEvk1pCwjH1LW7XKqECt1Eoaz827GIaKoRANn55pmg2RyiEXqOShhZepQOfIPoaF0TSlnT8DRJIELQWSwqDgezJR4KAXRpNRTkdIHviMcpYFfCb507IUNhLLE1tV8ZuD6tHIuCWnAZz6S96F1WerdSLTDa0vE8hFegFLJoHX
 raSdpQlQ
 rNdhabQY9pZWmOq/+pRvy9jPI+bRdFEVwW9VyZDHHDgcCMRhQPELrZbz+h0ftK5yFCGS4gAv2n8DYwwTmK04XD7E54zUI76qGWwF85YmbzsMzU/ytvSVXm3hqHvUHlsx7OH/ZWMzUb065hO+21cgFe8qQ73i5/PePgnGlF+douJkKwcEZLsowIegdAblkfBovBk8BlszMgMxFdSAwQCoikrYNLxiQBn7WPx1hypK2hW0KLp00ryyw4KX+ru+QdJmDXOwmSqbFlacK0uiWqGV7/Y3w6VhKmMceWT3nYuHFOJrSRaCQ22rDLKBUYwvE/Z3eJTB3+l1P7UyRcPw/i6LwiOtFgMRd+vBmMmTAvdA0f+cpEEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/6/2026 12:25 PM, Matthew Wilcox wrote:
> 
> I don't think we should have pgprot_large_2_4k().  Or rather, I think it
> should be embedded in pmd_pgprot() / pud_pgprot().  That is, we should
> have an 'ideal' pgprot which, on x86, perhaps matches that used by the
> 4k level.  pfn_pmd() should be converting from the ideal pgprot to
> that actually used by PMDs (and setting _PAGE_PSE?)
> 

Hi Willy,

I will take this route and implement the embedded approach for the v4 
respin.

-- 
Yin Tirui


