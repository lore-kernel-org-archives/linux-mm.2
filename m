Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD907C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 11:48:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81266B009D; Tue,  7 Jul 2026 07:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B58106B009E; Tue,  7 Jul 2026 07:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A713D6B009F; Tue,  7 Jul 2026 07:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 829EF6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:48:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 10F681C724F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:48:27 +0000 (UTC)
X-FDA: 84961807854.08.9D28840
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9D68640004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 11:48:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Lp9/IJDW";
	spf=pass (imf12.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783424905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQ0mvywMk1VYYOPBF5PvfJak/QAKIBpitC3KAeG7XY0=;
	b=oQQJ7MLx5mR1RsnRbMlKG5tsD+yXQZ6ZFvdnJ90jI4LJxcrtvTirHgYNTKaFYwQK1ZY2HV
	6Qm0IZYKDiK37cvBbBHV9eu97wEnbXXMPeq0/2YKnnWmbhu4YXu4ige3GjNzMnzq/fRcMM
	xF00UofZmNoYnsiQsP1DbYvpf7lPHUY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783424905;
	b=t5xZKYIwnyL0tc8XG8V6WjyXzlfxaPfi0A8b3VIexhbf0REljda+wi1bm6ljiljFqiparf
	oA2kP6JmT03bH2a7fP1YFxWtFNt+V1aNtQcy9ubu6hX2mx3zyZ3QiMCpKyQlkkwH1iGFLc
	bfsCUz4SCuYE81pXArW0AsJ4az1YsxA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="Lp9/IJDW";
	spf=pass (imf12.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GQ0mvywMk1VYYOPBF5PvfJak/QAKIBpitC3KAeG7XY0=;
	b=Lp9/IJDW0+fMhUe2D2c7Pxs+psR2xzhuJBRSozphimRGSOx/peqUwYuBnRGHBZfVoaMu6L4iC
	UkKTve2BKsVhZCC8/8/OQMn1T4wsjMlaJjcR8BQtbUdmD72ShTagpcLqBR53ClUDZZDnYgZAG9k
	6LYz4Th35zqYGoyXSpwTTqc=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gvfQb0MvzzpStg;
	Tue,  7 Jul 2026 19:39:35 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id A17B440575;
	Tue,  7 Jul 2026 19:48:13 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 7 Jul 2026 19:48:12 +0800
Message-ID: <c11452a3-b918-4d4c-afd7-a835a1d0a3bc@huawei.com>
Date: Tue, 7 Jul 2026 19:48:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
To: Xie Yuanbin <xieyuanbin1@huawei.com>, <akpm@linux-foundation.org>,
	<linux@armlinux.org.uk>, <david@kernel.org>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linusw@kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<sunnanyong@huawei.com>, <linux-mm@kvack.org>, <lilinjie8@huawei.com>,
	<liaohua4@huawei.com>
References: <20260626073048.3595106-2-xiqi2@huawei.com>
 <20260706133247.145485-1-xieyuanbin1@huawei.com>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <20260706133247.145485-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.56]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9D68640004
X-Stat-Signature: 7x8qs6gbg8q86533zr7orj55xiztnkny
X-HE-Tag: 1783424903-109113
X-HE-Meta: U2FsdGVkX1+UeVFXtSWgZrUf2ZKJteGvyigN88kKPNtA2g9AXqEQF+1grhFplI1c2JvBr3ra0gPrYUfNr2FWGGP8GGoakJXu8kRUvsWtAZ9wcuw3tP1zZ7P5c6V8qM1FUOx4/8JSyPklQzHe9Y/Hyq8M+Ma6hFFPpugIR8dBeV9uFUrbRrb9sHxiXXj7NT7lXoKaqdtvm0OXWdkfubZtP+RjR2+yK5n3UBlFSfZcWjfzzOvW9LUG7VI7inXAWn1EdGv9I7MCD34yFnsYxbCox6hIuFcg/sVQO0mvD1WWe8+DmV/oSiU2WlLyD6Ve1UP7RmQf0gnb7NGBgLgca2vEedmW1JJWH7Y16N6niMksGxqfO3/llyl7KmdwCs4R0z6AQZAZA3w1+tc3ywEqXLg1CRKd+EMyKJkKnT9g3mfbwXt1UwTNKSITDFWnVl7XMPoatT0+gB9WNODONncm+xFLj+2yyjsJ3xuaMLHLKNlMhcoI/3witvGOduCSENgxNdlCQVRfxtYKZ45glmsjJu1Mqhj2iyR+vun1AHN9n3BhCcGhEc4XEM/9Liyf+M97a+XiR+oeuqH8p9R9VProoSRVxHK2fmt8CnEsufZQVfseWIcl58z/cgI+6Aj7Ri70f8l0VeOfT9fBqqhRoWRy3QdbzYfJkwD4pl21IoEAgiIc/wM2efvLokXeqiHop+43SkGny0VU4nNyhlOYyos8Dd9QpU7mCnhabQXiCIR8XyOZfQ4xzPqLOfmaYZ6MEHCDVgXOX+3GcCo1PrnuKmx6/RDx6aOdCW7HYhRiHjo64X0c0NvmQTsJYwjDI2U5qEe5bxAkoBaknX6QxEQ3tY3pujG0ZFZEdUDW1dtp7RaBXBChHCdRB8hIP+9UcxRoo5axGqtiGRma/ou9fSHPiZJffnVDIaL2AtKEh2DjdjHvqQ7Br4ra2/EYoX40EIXoEHoEOmCScsNKYAExNtN7pMMIW9X
 fA/jeQN8
 zIEJeWiGiRp0J4aJRKv9KR/NuH5K6Pw7bevQHN6IDNmvrqFjl0DJsAIgXZ5friD6dA6ME7E5bsOz/qQlz/U6avjbSm6B2rvngVCfR/EBE24C24EEaHCDAmIrK4U7MYR4cjQgA0Y50SCYlOCSzRGOSd/QsOGkeC9kwDEdPnmtwDdqvps0Nu/hMWPmQOstIJK5FWktSv0B3QcsL7xp5LXTgAmJmfi8yr8hw3ymMM4i2DCeF50dBwdPu7qPt5Uy+Uz/5i9BkyI0Pa6w1ku1gqAyfq767rpqvPkCDzLds4OWb50yWtv1K45i92jYzIM8PD5Jef3IP1N8MXaazWey4vOQdO0U6qWsIWEDZJJHjIpHvO4wLvKCKnQCkVTjfI3hT3w2WbW/mdT7IQ/VEP1UZ27K6YV8St/v4gFmf9gpgqjUPXhOOH4roIUPWRzLtGLgCeM+thQSZtblZ2teLNh25GwQYHQqmIFyYzMK6IBSH03H+rGSNwLC2cq5iU7ydBinTKpFE3lsfo5dFPYmfjzJOaULYylSg5rYuuQIqkElIhhEepNBPGNE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/07/2026 21:32, Xie Yuanbin wrote:
> On Fri, 26 Jun 2026 15:30:47 +0800, Qi Xi wrote:
>> @@ -181,7 +181,9 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
>>   		pr_err("8<--- cut here ---\n");
>>   		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
>>   		       tsk->comm, sig, addr, fsr);
>> +		mmap_read_lock(tsk->mm);
>>   		show_pte(KERN_ERR, tsk->mm, addr);
>> +		mmap_read_unlock(tsk->mm);
>>   		show_regs(regs);
>>   	}
>>   #endif
> I found that this fix does not completely solve the problem. For a user
> fault, the addr could also be a kernel address. For arm32/x86, the kernel
> address space and user address space share the same pgd page table,
> but the kernel address space's page table is not protected by
> current->mm->mmap_lock.
>
> I have written a use case to construct and verify this point. When A user
> program accesses a kernel address and triggers __do_user_fault(),
> show_pte() will directly print the kernel page table.
>
> So, I suggest that:
> ```c
> 	if (user_mode(regs)) {
> 		struct mm_struct *const pt_mm = addr >= TASK_SIZE ?
> 			&init_mm : current->mm;
>
> 		mmap_read_lock(pt_mm);
> 		show_pte(KERN_ALERT, pt_mm, addr);
> 		mmap_read_unlock(pt_mm);
> 	} else {
> 		// .. keep nothing change
> 		show_pte(KERN_ALERT, current->mm, addr);
> 	}
> ```
>
> I have read this article:
> Link: https://docs.kernel.org/mm/process_addrs.html
> `mmap_read_lock(&init_mm)` should be able to ensure that the kernel
> address's page tables can be traversed. But I'm not quite sure if
> `mmap_read_lock(&current->mm)` provides protection for user-space non-VMA
> addresses?
You're right. And I think the fix is to simply skip show_pte() for 
kernel addresses.
For do_DataAbort() fallback:

	if (user_mode(regs)) {
		if (addr < TASK_SIZE) {
			mmap_read_lock(current->mm);
			show_pte(KERN_ALERT, current->mm, addr);
			mmap_read_unlock(current->mm);
		}
	} else {
		show_pte(KERN_ALERT, current->mm, addr);
	}

For a user-mode fault on a kernel address, printing kernel page tables via
show_pte() does not help. And The fault address is already printed above.
So it's safe and reasonable to skip it.

Same pattern applies to __do_user_fault().

> Also cc to mm maintainers:
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Lorenzo Stoakes <ljs@kernel.org>
> Cc: Liam R. Howlett <liam@infradead.org>
> Cc: Vlastimil Babka <vbabka@kernel.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Linus Walleij <linusw@kernel.org>


