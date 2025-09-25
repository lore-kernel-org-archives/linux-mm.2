Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F19CAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 02:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95F3B8E0005; Wed, 24 Sep 2025 22:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FC38E0001; Wed, 24 Sep 2025 22:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FE718E0005; Wed, 24 Sep 2025 22:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD6C8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 22:17:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12DB1160217
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:17:41 +0000 (UTC)
X-FDA: 83926161522.16.229A4AF
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id 32A98100005
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 02:17:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758766659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M+MrvNjbNMU5UdkWxgeYFdNRdUNRe55IPsqP6XzkkQw=;
	b=ONzekv2aMvd/G6ebPRy/zag//IPFl3I3Er921oH2KFF9sNdKKLkPRLlrzK8eshPPKRmCTy
	iB5ivSUPc5JPNtq6Xk1aDKD13fECyIO7TtDH+wdlgWcstK506OEN/nwWDna1fNmlzrvCSg
	lJz4uO6nEBNW3KuYfdVl7iph2XnQ5a0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758766659; a=rsa-sha256;
	cv=none;
	b=YATln6isU13qTSOOx8VosgsCXzbF5wrO2fR6WHatv+egH32DXgqMSBkM3uBdflY/TGFwpB
	zbEnUwOZ6Xv0/LneWe74wPQjBF+aroB6Nr6NJVeRe1PQt/qTn7HrkJ+RTzG85nAxSvkXVa
	YD9EDkjpKcapWBsFGJWHnkFxoMy01/I=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cXHLG6dwBzTh3F;
	Thu, 25 Sep 2025 10:12:54 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 7EA3B180B63;
	Thu, 25 Sep 2025 10:17:33 +0800 (CST)
Received: from [10.174.179.35] (10.174.179.35) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Sep 2025 10:17:31 +0800
Message-ID: <620d202a-6078-4b5d-a42a-8a52543bc14a@huawei.com>
Date: Thu, 25 Sep 2025 10:17:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] mm: add PMD-level huge page support for
 remap_pfn_range()
To: Matthew Wilcox <willy@infradead.org>
CC: <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <anshuman.khandual@arm.com>,
	<yangyicong@hisilicon.com>, <ardb@kernel.org>, <apopple@nvidia.com>,
	<samuel.holland@sifive.com>, <luxu.kernel@bytedance.com>,
	<abrestic@rivosinc.com>, <yongxuan.wang@sifive.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>, <wangkefeng.wang@huawei.com>,
	<chenjun102@huawei.com>
References: <20250923133104.926672-1-yintirui@huawei.com>
 <20250923133104.926672-3-yintirui@huawei.com>
 <aNMhiZ4FiEE1Rk_T@casper.infradead.org>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <aNMhiZ4FiEE1Rk_T@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.35]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 32A98100005
X-Stat-Signature: bmb6wxmhxzbirwa7aphc3r5dpmqqmwy9
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758766657-45712
X-HE-Meta: U2FsdGVkX18cXhUxVrl+Qqzy3DLMrmczEhjFP1Nc62OobKTYLTp1j2nMPKFxrPTXM2FEKCj4k+Go3z+RV2NGtrYZLPaP/7b4PFFWYadOvZYWmuXYRAkbbHwikHog66nB4+IZOQ1Gtk49gHZkSaa5cnQW2uUMHU38xCrzIa4E3ziCP3XXGruFLOrFTpIuG52hX7x8hXlMKerDwqS3i2REP/MAx8UFm67q6KFx3ZN8mcZqJ29O1XRv+1HFhzJnJ+IsflsUZG74REjrYXPTZQIG0Oda8iUsbOfLje9cF+slzb0uyVJUJyf00R8XikRfpPjwRdudgXCj4I4nrMYg+xcYDp95bGu9h/9JYzBJDYdJEMY63yIHApmb6DGvY2wa6aXbgIzPMsoSNJDWnWlFrl0yFnxSxI1slZKRV7BcuO1uzRnxFXgSkg3g9tVnnPY7kPS9RdCnigukzqf9VctEkq7wPzxyYq1Mjveibx6zpfShRR3CGzPXTpfJZCFl6HxMXbND8KC6mzOBpTEoVDVEt0YH4/eF/w1JeqF8dkSWOsHfj00xfQxM6TFUMjEyYmN1PbF/mpSV+eU2MKAHQm/8xcdWd+6yvsSculEq10hghrX/AEtQ39DYQ4WeIws00Au5bbHJVquOkTV+STuRwuu8FwFqxX98UJQt+MYbS51OLXBJN+WFUnlG7Uaja1UO+h25r3Dcy/sHhGxY93TFgu4GfBcBE8ufNIzbmpUqHOM8DhGhHtuuzW1j0Sa8Pb5LclaxwwMuzFN5kQohm0WijuC07VX5+XRvO446Ro7obmDgJq9quw0N6HQo7qbquMGy+ZoyRNBsPYfEXRkmoAq/gnbhDTgcf4CyroKcOtuQufhWocDHFlGYitL0qNSdnEKIHHTPt28tm+BSCiQTPuyc7YzBy3SDN/jWyDu2YJyp2XO3ugAlKW7XMZvARdwgylBNRVpygWx6bz1sSdBfxPxmn0CgUpo
 i1Klc2Gb
 TB+njPYhYLopj3beVGn5zsQP7u2j1BFHZP+mIAJSX9V6Hv0bpAXJDZuTGU7Qg1u5ku2aMDD79KqPRXUtKCwjSM+PbTbaj7VkAOOH2YdC6xoooVXafVBo/h3IOR9L90Kv9viYfeOQF8ObHb6pw+xGyEltGQtX0hbbxli0kPhNY7aWUcO6Mm0n/+G9vEE5RU+u38GV5oPTu9EIqLDVPpUYB+J60YfBtaaYVNSqvvGrFdYKdT39e6+AB9CeIFbWnQAjCLgsk9P/fD0X1lPFaQ3NEmvVFhMh6uaOnWUodZsCNauQF7kEsaDIgyvd05QgrdITkXi2O0uFi+jxRcyJ+RXPmDdUGzEMgks5eP/Ua
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/24/2025 6:39 AM, Matthew Wilcox wrote:
> On Tue, Sep 23, 2025 at 09:31:04PM +0800, Yin Tirui wrote:
>> +			entry = pte_clrhuge(pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd)));
> 
> This doesn't make sense.  And I'm not saying you got this wrong; I
> suspect in terms of how things work today it's actually necessary.
> But the way we handle this stuff is so insane.

Thank you for pointing this out and the broader context.

> 
> pte_clrhuge() should not exist.  If we have a PTE, it can't have the
> huge bit set, by definition (don't anybody mention hugetlbfs because
> that is an entirely separate pile of broken horrors).  I understand what
> you're trying to do here.  You want to construct a PTE that points to
> the same address as the first page of the PMD and has the same
> permissions.  But that *should* be written as:
> 
> 	entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd)));
> 
> right?  Now, pmd_pgprot() might or might not want to return the huge bit
> set.  I'm not sure.  Perhaps you could have a look through and figure it

I've tested this on arm64, and pmd_pgprot() does return the huge bit 
set, which is exactly why I added pte_clrhuge().

> out.  But pfn_pte() should never return a PTE with the huge bit set.
> So if it is set in the pgorot on entry, it should filter it out.
> 
> There are going to be consequences to this.  Maybe there's code
> somewhere that relies on pfn_pte() returning a PTE with the huge bit
> set.  Perhaps it's hugetlbfs.

I'll try to refactor pfn_pte() and related functions to filter out the 
huge bit set and test its impact on hugetlbfs.

> 
> But we have to start cleaning this garbage up.  I did some work with
> e3981db444a0 and the commits leading up to that.  See
> https://lkml.kernel.org/r/20250402181709.2386022-12-willy@infradead.org
> 
> I'd like pte_clrhuge() to be deleted from x86, not added to arm and
> riscv.
> 
I completely agree with the goal of deleting pte_clrhuge() rather than 
expanding it. I'll study your referenced work and align my approach with 
your efforts.

Would you recommend I address the pfn_pte() and related function 
refactoring as part of this patch series, or should I submit it as a 
separate patch series?

-- 
Best regards,
Yin Tirui


