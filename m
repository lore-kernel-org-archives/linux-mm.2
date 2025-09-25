Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E16CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 01:43:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21958E000F; Wed, 24 Sep 2025 21:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F9398E0001; Wed, 24 Sep 2025 21:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936628E000F; Wed, 24 Sep 2025 21:43:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 869B68E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:43:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 294EBB6E9F
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:43:47 +0000 (UTC)
X-FDA: 83926076094.26.C11E2E7
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf11.hostedemail.com (Postfix) with ESMTP id B796740003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 01:43:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758764625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ynf+6JVe8qx70BIJa2YsOoJZFjYIQqVWH6WDtkKuWb0=;
	b=fDNyJdrC0mC5vD1E779Y8AulIwxzKikb4PWILljOJYLJg6GHDQsEX+gcz1ObUH9tq9e7rT
	suu1usPbSEcTaPIvlN0l6pENIQwuEfyJKOQqUYFJ/9/KJxUKKh4VTV2wb9wmXdxX1aIqiy
	+8Ap+BDfiNjC96ud0jPjhaK9+YneDfc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yintirui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758764625; a=rsa-sha256;
	cv=none;
	b=xY1qlURQAEtXfxwY3zMdMPNZ/ysAOPo+iMITlkHVAN+lrFCaSDmY8V8Z0qhSwCQnlReDYm
	jNldjp1s8WhKKiYOe/8ARD4MAdeYwwtoYTN9tevl5HLNH0MnjaZWIFv0vzYjWTVU265V/7
	h6Ag8EN4JDqOBtQYcXrI1p16jlJJB+Y=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4cXGb80jBLzddVk;
	Thu, 25 Sep 2025 09:39:00 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 2D3111401E9;
	Thu, 25 Sep 2025 09:43:39 +0800 (CST)
Received: from [10.174.179.35] (10.174.179.35) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 25 Sep 2025 09:43:37 +0800
Message-ID: <8313b0c1-bf62-4257-951c-fd7e29193ae2@huawei.com>
Date: Thu, 25 Sep 2025 09:43:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] mm: add PMD-level huge page support for
 remap_pfn_range()
To: David Hildenbrand <david@redhat.com>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <npache@redhat.com>, <ryan.roberts@arm.com>,
	<dev.jain@arm.com>, <baohua@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <paul.walmsley@sifive.com>, <palmer@dabbelt.com>,
	<aou@eecs.berkeley.edu>, <alex@ghiti.fr>, <anshuman.khandual@arm.com>,
	<yangyicong@hisilicon.com>, <ardb@kernel.org>, <willy@infradead.org>,
	<apopple@nvidia.com>, <samuel.holland@sifive.com>,
	<luxu.kernel@bytedance.com>, <abrestic@rivosinc.com>,
	<yongxuan.wang@sifive.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-riscv@lists.infradead.org>
CC: <wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
References: <20250923133104.926672-1-yintirui@huawei.com>
 <20250923133104.926672-3-yintirui@huawei.com>
 <f8571506-30c0-4dc8-9995-41a6469f8fc7@redhat.com>
From: Yin Tirui <yintirui@huawei.com>
In-Reply-To: <f8571506-30c0-4dc8-9995-41a6469f8fc7@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.35]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: B796740003
X-Rspamd-Server: rspam05
X-Stat-Signature: 543pmtqyw51nb3zorhuk5esokka4gmwk
X-Rspam-User: 
X-HE-Tag: 1758764624-918733
X-HE-Meta: U2FsdGVkX19iarsCnyXDjMObWaozehyR2fdVYkEXoiaAyoWvhNU9/cz4gTSRGk33vURZw9SHACRDT0uHPTcLuKktbYmlF/Yb80u6RNXoxny+Wr7AvZqNOp8q/Buo0ojEBqKEdL3D2bAFSU4ELwd4NfbxRGQIHk8+cL7tHnJVoBvPIG3Fof7Xy/nU/CRiu6Icm17+u/U+SlB+g1csiMkOrIls/hEXgsgl4D3Anm/W5RVXssdy1ZiqQzVdvbJXLNNKSPcicoN5HXnZRyENugX10Q/rBqrtUkMDXLHdO5Ugb6UdrwmdY2iHEzlKznMr5atwADw7C5zx26MfDIWn+nTgGzTA5i0FumTu1qoqJW2o9FTOPa30joqDVDXy01AicZM3j7lMPdiurzhYHP7ZsGJPXrBJqmvLQRTHZt4z07JLDpYNQnrTTpuiAGglvD4N7Gus3IP5E6MsoQkX2b9l/YrVAKuUXNEtBMhYlBdl3d4uVzhJxOd+6G3FsQ22xvGFeyXw+KY5mwMs/6VDE+78TgKkLa2uGHbWJEy69QH/1dFktfde7V72UiBYLZghSNaoZDKOjv6Qhjw9Lbc5cRH6s3fmWXG5KhrbtI5kj9UxSrINFP8znfDh9i3EC+/OVFR7vtcnnHtAbLpUFtTSDNNEu4OrSmhzqfSFgGGTVQU9TQqlrYMJ7BUILLdhiYdkBJe5EFy7mkJO1MfzxfGkNPlQrkSCjut9It227tSHGCto4i0s7KtO3UfjJ+8G1+RI1wYAdVJij+bVnTS3G9BKPmVHIF4ggP0DL6oR4szbbdaVliR5Dl/xH/Hrrg6UeH0t1BY+//d6bCmd2fMSlfqFuL/BgzOyrKyLadKokYYb2HP64tiPUAuM7NUlhPhwNARsFFGsV+MUp2Gn4GOqBuyHY3h3+JvVs3s6iFVpA1PLemww9yk/Sld00TXSUrDccmxoDGEkSgTSlJZ9KGSln0VGeJRz4lr
 lOaUW67B
 BocPNloidSh9wjEt9/KYqLC4m5yX1AjkN0epLnG8ltS7yFyUQTM6YF2xTjzGbyvXY+wv3uAzgQdkLDPBb59csgMfLXSs+WuU5JzaUPTKosJKJORdptD+PBiDLjh9E20eC/rmP8soEOBks+0NuN6k8mNzJ0d9WObp6BguIk0UexAE1V/Zpb9YlAk9sN5+lCduleo2Nlxu5FBq5EZ9qaa5vSEMamdKvbq7WeSDNwyzkJE7PM/p+2+aME998aHschtUeCf/Vq7K0a1Sz9eI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/24/2025 5:50 PM, David Hildenbrand wrote:
>> Introduce pfnmap_max_page_shift parameter to control maximum page
>> size and "nohugepfnmap" boot option to disable huge pfnmap entirely.
> 
> Why? If an arch supports it we should just do it. Or what's the reason 
> behind that?
> 
There's no specific reason for this - it was just intended to provide an 
additional option. I'll remove it in the next version.

...
> Are you sure we can just entirely remove this block for ! 
> vma_is_anonymous(vma)?
>
Thank you for pointing this out!
There is definitely a problem with removing this block entirely for 
non-anonymous VMAs. I've also found some other problems. I'll fix all of 
them in the next version.

-- 
Best regards,
Yin Tirui


