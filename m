Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F6DCCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 06:53:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39EF8E0016; Wed, 22 Oct 2025 02:53:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEAA28E0002; Wed, 22 Oct 2025 02:53:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADA0A8E0016; Wed, 22 Oct 2025 02:53:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1698E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 02:53:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F3D688B42
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:53:23 +0000 (UTC)
X-FDA: 84024833886.02.4C974E2
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 01E88180007
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:53:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FTwnnr0N;
	spf=pass (imf24.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761116001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQL6SeVGx4c1D991//YZKaa0cyRKwryW27KFK0xeilY=;
	b=r+tBb0atvOVyoudONWm4xLjhN0LqnhcKCMOk5BKizGguEt6H0p8Jjg3NtRiczazbHvyKO0
	U8Rknw/WUAJz3oKLdlBdfzFREnjc8qsmsRLWEi+hKVQNqjj0/58hna+5xEMC41OOJ7h6ZJ
	X+/iFGufSThwZFYfcic2iqbKmDwnugU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FTwnnr0N;
	spf=pass (imf24.hostedemail.com: domain of xueshuai@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=xueshuai@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761116001; a=rsa-sha256;
	cv=none;
	b=RJg/Ds8/jSHpKBdnvgHbNLUc5xX+vhjJDOV3XT6zARCRZJgPXAljPEL0mrZGOj2RRmRyAo
	reos8XkSwuxh8BaLAV/jy/rkuGYj0wrQOsVKDgzEi9FKxKmL7ZBYgVgtLkBQPqnDsmX4wn
	v6GvFqNfjIrVGSBSslZrglURuUlOPqI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761115995; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=lQL6SeVGx4c1D991//YZKaa0cyRKwryW27KFK0xeilY=;
	b=FTwnnr0N+YHQ/tBs+S2lYWBtSpcJnr6LuoLAShI4lBmq5lkFgBSl80WWxUegvi+GazI3oEmVWPqY0ko+eEjvcZkSdpmWwnY9aXHGxTY/SArSdPzcCEt2cIvWDM+GTAGmXD4vsoZEs2ktnFkTw9tyBFS/k9XFA9K3hxvIDnzbXcg=
Received: from 30.246.161.241(mailfrom:xueshuai@linux.alibaba.com fp:SMTPD_---0Wqlkw1q_1761115990 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 14:53:12 +0800
Message-ID: <81b1f1c6-4308-41bb-9f65-f158d30f27bd@linux.alibaba.com>
Date: Wed, 22 Oct 2025 14:53:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: Change ghes code to allow poison of non-struct
 pfn
To: "Luck, Tony" <tony.luck@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>,
 "ankita@nvidia.com" <ankita@nvidia.com>,
 "aniketa@nvidia.com" <aniketa@nvidia.com>, "Sethi, Vikram"
 <vsethi@nvidia.com>, "jgg@nvidia.com" <jgg@nvidia.com>,
 "mochs@nvidia.com" <mochs@nvidia.com>,
 "skolothumtho@nvidia.com" <skolothumtho@nvidia.com>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "nao.horiguchi@gmail.com" <nao.horiguchi@gmail.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "david@redhat.com" <david@redhat.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "bp@alien8.de" <bp@alien8.de>,
 "rafael@kernel.org" <rafael@kernel.org>,
 "guohanjun@huawei.com" <guohanjun@huawei.com>,
 "mchehab@kernel.org" <mchehab@kernel.org>, "lenb@kernel.org"
 <lenb@kernel.org>, "Tian, Kevin" <kevin.tian@intel.com>,
 "alex@shazbot.org" <alex@shazbot.org>
Cc: "cjia@nvidia.com" <cjia@nvidia.com>,
 "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
 "targupta@nvidia.com" <targupta@nvidia.com>,
 "zhiw@nvidia.com" <zhiw@nvidia.com>, "dnigam@nvidia.com"
 <dnigam@nvidia.com>, "kjaju@nvidia.com" <kjaju@nvidia.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "Smita.KoralahalliChannabasappa@amd.com"
 <Smita.KoralahalliChannabasappa@amd.com>,
 "u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <20251021102327.199099-1-ankita@nvidia.com>
 <20251021102327.199099-3-ankita@nvidia.com>
 <68f7bf2d6d591_1668f310061@iweiny-mobl.notmuch>
 <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
From: Shuai Xue <xueshuai@linux.alibaba.com>
In-Reply-To: <SJ1PR11MB6083BF0885BC19E715C1A96EFCF2A@SJ1PR11MB6083.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 01E88180007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: frrq8uw1gpykisnbhr7q1g48po7hkzx1
X-HE-Tag: 1761115999-42749
X-HE-Meta: U2FsdGVkX1/DuWcS+aov7+TJjhbbLyGKKjztBYEZNfqqlSbTit+q/495rivH2dOMXgwBpjYO2EhpPM7jEesDLmpJPBc9MU2pW9bKuAG/HYkV5yItVpoVQt2WfB6DSJIH0K1AJEw0uc33MgpwrklbSAXKWXkOpqHdykOwMD+TWP7ZcBHApApx43YbRi0OqGvN2pnW/LryhlJ4aK5YGnPV4fIsYpTU3vBuAwp0FHnt+PPFFD50cHnyunDMRcftmBj6FU3BmihUBIW3Eq/OSE89qOouf5HDNajiJgWuFtxEMZVjEX5il0MV48WS07FiJlp8/IzQv5NNdioxLtmgYc7A7jkdMcIKwbKqfj10pgW8ewTUeld9ivgAZh6pTEm4n41nUkm9Fm72gKBBkKsRvI5ZvRmmFx4RJEvE3aD7KahBP4aEv1kzOHUxtTmQFBFvxol6VIj4eZZD2qs9sug2keARxLWvizftnaNfznhjhiTHtxlKvaObO7+FPxeceX7QxZXkM4BQMs8AoWzVYTBiJdaEJES8Hl17PglTx3Tbg9eaEjLIY+iuwug1UUrZPqEclfH0KP1Pw3HMDOSgYNu1gw9S+oVxFHVzjrfrCZp3wl3Cdiz0bSv4HSIShtOLQrl0Q08uHQPbx98iSRi72z9q7jLd0oJG5YGi4MAnVhnIoncjli14mLrAXF9cZ3Jiz4yeSazJI0hH5PlHfkogmdMCNfOYVEw8dCnITc0K4GGkkRBTpEaIAf2aH663IgaOW+n3DqouE7eGAA4SKCa8M+rTUcBI2bOVw1JyNidgZYVC8BYhGLolOtWPUo73AcuPr8ByHqfyHCAHhXLLV+xR6J+5xHB2vInwMtSPWxPya5cvtctkeHPyoPD4oC297is0V5fvzudgImBNPM59aHZG+q+bGyXGhfdjHMgBt7rNo/r13k+yNmTj/D3jltpINmUZxwLXJALUBLWjidqEPQFEFbI/7PL
 TICQWG7u
 aYCx/R2TivU8AqGJAB2wZRc7Y4m/RsDVOTmWvvavlLPGGGkWJZAcMsRc0QeAGYkGQ5xhGktwIbOi3M41COB6Y+uPs0oyi3+gUdMdxkFy9e6FghtqydqrmBg1vYwbtJyK8ZowbiiEBCNZiOyWC0mNuXJY+AdX6qeG2SpzBhuHZBXnrFhrpxlr+wepooiOLq81k+y2FFYeGdWTHtDyyx/5ZM5lHtwef9Iwo7j+M7qEe8mtiRQ8oz0zsDP2XOjylBmasda3EI7eiu545B8o+veH5eZ/+piNwWV++hE+M3mltjjReqnyIqMNNK2TsJ0nWlFYxnUgCHNFspdYk5WZNXBE7uXiWtlGisrXS6y1UGqI6IWgPjm2eOh9OYIcSHFDoKRzEFkndv8VAvJ9HayIgB9VOy4VlDPltegfAGsXtUzOkhb1mM/9eC1UCDGVQ2HlSDao2Jy6aa3PCRXyodnQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2025/10/22 01:19, Luck, Tony 写道:
>>>      pfn = PHYS_PFN(physical_addr);
>>> -   if (!pfn_valid(pfn) && !arch_is_platform_page(physical_addr)) {
>>
>> Tony,
>>
>> I'm not an SGX expert but does this break SGX by removing
>> arch_is_platform_page()?
>>
>> See:
>>
>> 40e0e7843e23 ("x86/sgx: Add infrastructure to identify SGX EPC pages")
>> Cc: Tony Luck <tony.luck@intel.com>
>>
> Ira,
> 
> I think this deletion makes the GHES code always call memory_failure()
> instead of bailing out here on "bad" page frame numbers.
> 
> That centralizes the checks for different types of memory into
> memory_failure().
> 
> -Tony

Hi, Tony, Ankit and Ira,

Finally, we're seeing other use cases that need to handle errors for
non-struct page PFNs :)

IMHO, non-struct page PFNs are common in production environments.
Besides NVIDIA Grace GPU device memory, we also use reserved DRAM memory
managed by a separate VMEM allocator. This VMEM allocator is designed
for virtual machine memory allocation, significantly reducing kernel
memory management overhead by minimizing page table maintenance.

To enable hardware error isolation for these memory pages, we've already
removed this sanity check internally. This change makes memory_failure()
the central point for handling all memory types, which is a much cleaner
architecture.

Reviewed-by: Shuai Xue <xueshuai@linux.alibaba.com>

Thanks.
Shuai

