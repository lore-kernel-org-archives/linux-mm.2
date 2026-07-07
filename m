Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFFDFC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:47:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3F76B009F; Tue,  7 Jul 2026 08:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 864936B00A0; Tue,  7 Jul 2026 08:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 755526B00A1; Tue,  7 Jul 2026 08:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49AF26B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:47:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C78628DF42
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:47:09 +0000 (UTC)
X-FDA: 84961955778.14.BF8CAD9
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf06.hostedemail.com (Postfix) with ESMTP id 591F7180006
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:47:06 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TALjfW1B;
	spf=pass (imf06.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783428428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GQRdIed9FxvGoM8zGNvZRyfwCPAFp/XYSbDPrPh4wGc=;
	b=8eIa2j774r+iOcHwyR/C1iD6WH+w7AiYrGhIRcOR9tvN1qNHu/6hARUTa8BJ7HZ5GPSFGN
	H+EuwxqIKVloIsBYQH5wzwD2y8H2twpiPKja2R0SCdF4bgpmkwRlAw45uKSNPaCC6wQ1Y2
	PEjFrFoCqi6fR/pfmqkOTlZ6GWHf3kk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TALjfW1B;
	spf=pass (imf06.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783428428;
	b=g3PR9kmcIQ8nQASRFk6WY4+WLQoJK77y8GjWfxG8mSqOuMzF7KKz+lJDK2vOaq04Qv3z15
	9Fq8bXTGq2gitxhb5tigERQDTRvzBKu0TLqB2JP3kiKYP68sKM95ui0UZPLvXjGnp4qlTX
	nfIr4fIdwSbOAV8MtisfbNf100OFb6g=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GQRdIed9FxvGoM8zGNvZRyfwCPAFp/XYSbDPrPh4wGc=;
	b=TALjfW1BXCDsVYIOhNk3xDerpRvOXDdd+5Jf3kCiH8Uud7hxIQjKLAouoCMgWOFAF91eJ47Ui
	FyYb89uMNUwkVanzjvQIlVXVF0N+AAggbf5hAK1QLB0zclikUafxeTFm16aMADo6qN3kOlRNEA9
	gcyU6AJ7Dx7CgTwpSGADeuE=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gvgkQ55rmz12LDB;
	Tue,  7 Jul 2026 20:38:22 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id 6223340579;
	Tue,  7 Jul 2026 20:47:02 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 7 Jul 2026 20:47:01 +0800
Message-ID: <5d00c0d4-89ab-40eb-ba50-6eafe4957f50@huawei.com>
Date: Tue, 7 Jul 2026 20:47:00 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] ARM: mm: fix use-after-free in __do_user_fault()
 under CONFIG_DEBUG_USER
To: Russell King <linux@armlinux.org.uk>
CC: Xie Yuanbin <xieyuanbin1@huawei.com>, <akpm@linux-foundation.org>,
	<david@kernel.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <linusw@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<sunnanyong@huawei.com>, <linux-mm@kvack.org>, <lilinjie8@huawei.com>,
	<liaohua4@huawei.com>
References: <20260626073048.3595106-2-xiqi2@huawei.com>
 <20260706133247.145485-1-xieyuanbin1@huawei.com>
 <c11452a3-b918-4d4c-afd7-a835a1d0a3bc@huawei.com>
 <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <akzpuerKqOY7qfFi@shell.armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.56]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 591F7180006
X-Stat-Signature: qsrm4rmangz9z83yksqq9xzykqqfxpfz
X-HE-Tag: 1783428426-107476
X-HE-Meta: U2FsdGVkX1/zQ8qlrTyTPlDJLzqY+UuRj4MG4MXXTjU6WuIzb/QWKje1Ae22sbkc1Lc7NrzjAZiVUheQsiMqyLI+sF9thRdVUiI2Ks6i+yMeQm9jRUCOA4qGpZgvUt6F+tVzwrj8Qpd60HJnSIR5xNgRq+TmcX0OOCAP+hACF8pN4UMKspNHZaqIPD9bJA36Yu4jtlLAb/PhLs1kVgWj+ZziPvWp9L22RjUqeXmtRvYR10l4DKLvhUti/TSNhtCFvAaCpDsVkDgyTSTNdbXOT3lpTOvTwPwdO8xJ8yAV5y5UqSwNqL95OS2QfuyKBWmaYNEOwfyAXuSGtoaD3Sa0jfFaNOzburi2rb2jJK5kKJx13jLQePx4FHY03e+4Z1Hrr1QBJ+XaBTA7psamMc+nLe4CSvv+kChYpwly5Np64KXAJUmoauwzPDMTMv6nSBS5FbQVYrJKkJ0To7VkeE6hf+9QZZiKEa1DbKsa1GpL5A4Yj9bPrpbFTnoUtW3sAFXjuoZkc95/F82Mp5DP6s5ignGu7sRHLZjM1Nn0SSAIchgqbKLKjj/xGG+4teO7rXgYvpVUN8WZwpwQMrfOEAIp3XQE7iBaXeWw/TN/0P8Hekh3PBQD3oqckS4zkMNCWuaikfT/ZU9XnRv3D74c1I6VkZJ7RCX7q9/eBzFYDZ8tI3jwf9KsHTE2tqVMIx/b3fuXbYjrXpxMsBzKh0AqrUIKujLyLnNWC2uEKVAFSHcs5Jy01hifnt93ti0LG+hr76766kKsOJLxoWO7+7aPigIxWBhhWaSQWLsPOZmxc10r+SHA1nQc1VGyZFqv8PYgrptL+RJbfhrRuabdVEnVDa+lc/FT+q6mFkofV5GVSaZ1liokFYZJag5bd8WQcimVJP+aSSpasOuNJSTbFjr83SIA9I/x7C4FygmSpqi1rE5YCCDTswBlK6sHecjj4ENtYqaWnxKxa7P6C6Gzop3kVCp
 uw5oNT52
 rKifpQuuZ2LOZVeKd9guPDuMQJ6OS6PQEVaZLccvu3+pmyaGKvYlrKqOwx7Nw0W6kYpMeR70wA3GtkmWsdrNQXB4ahtkQvbDcbKy8TydVhMh9OGfAy4fPHI3XyBVW5o8PnF4BUAsj/djm03wU2/LFOGJzTkeYlPC38MmtQgtdlEYccHRBhRSlWiob5Lbi3l/inQ4AHmun4bHK/kfrVPE/yGs9GMt3DmnYu42QjDcIf+kBIm+tSteqwuIhz6LL/V6tV3ktlLCpSQNkLzAF0wQahVZUdz94pBz+IdXpTTOmzz4qjDC//4bT7NIzk9pYOwt7n+FXWrnma4GvVsKQAmjNsLjZft94B2UISTYolGVvR1eSqsITzZUOilUXzIm47pawxWOsI2MDknPLpTmZ9/9MpCzDiPntC/wXNsqv6Wnagei4or5nUslMR8ULJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/07/2026 19:57, Russell King wrote:
> On Tue, Jul 07, 2026 at 07:48:12PM +0800, Qi Xi wrote:
>>
>> On 06/07/2026 21:32, Xie Yuanbin wrote:
>>> On Fri, 26 Jun 2026 15:30:47 +0800, Qi Xi wrote:
>>>> @@ -181,7 +181,9 @@ __do_user_fault(unsigned long addr, unsigned int fsr, unsigned int sig,
>>>>    		pr_err("8<--- cut here ---\n");
>>>>    		pr_err("%s: unhandled page fault (%d) at 0x%08lx, code 0x%03x\n",
>>>>    		       tsk->comm, sig, addr, fsr);
>>>> +		mmap_read_lock(tsk->mm);
>>>>    		show_pte(KERN_ERR, tsk->mm, addr);
>>>> +		mmap_read_unlock(tsk->mm);
>>>>    		show_regs(regs);
>>>>    	}
>>>>    #endif
>>> I found that this fix does not completely solve the problem. For a user
>>> fault, the addr could also be a kernel address. For arm32/x86, the kernel
>>> address space and user address space share the same pgd page table,
>>> but the kernel address space's page table is not protected by
>>> current->mm->mmap_lock.
>>>
>>> I have written a use case to construct and verify this point. When A user
>>> program accesses a kernel address and triggers __do_user_fault(),
>>> show_pte() will directly print the kernel page table.
>>>
>>> So, I suggest that:
>>> ```c
>>> 	if (user_mode(regs)) {
>>> 		struct mm_struct *const pt_mm = addr >= TASK_SIZE ?
>>> 			&init_mm : current->mm;
>>>
>>> 		mmap_read_lock(pt_mm);
>>> 		show_pte(KERN_ALERT, pt_mm, addr);
>>> 		mmap_read_unlock(pt_mm);
>>> 	} else {
>>> 		// .. keep nothing change
>>> 		show_pte(KERN_ALERT, current->mm, addr);
>>> 	}
>>> ```
>>>
>>> I have read this article:
>>> Link: https://docs.kernel.org/mm/process_addrs.html
>>> `mmap_read_lock(&init_mm)` should be able to ensure that the kernel
>>> address's page tables can be traversed. But I'm not quite sure if
>>> `mmap_read_lock(&current->mm)` provides protection for user-space non-VMA
>>> addresses?
>> You're right. And I think the fix is to simply skip show_pte() for kernel
>> addresses.
> No. This information is useful debug for kernel oops.
>
For addr >= TASK_SIZE, concurrent munmap cannot free the kernel page tables.
So there is no uaf risk, and show_pte() is still called without the lock 
as before.

Does the following change look acceptable?
if (user_mode(regs) && addr < TASK_SIZE) {
mmap_read_lock(current->mm);
show_pte(KERN_ALERT, current->mm, addr);
mmap_read_unlock(current->mm);
} else {
// .. keep nothing change
show_pte(KERN_ALERT, current->mm, addr);
}

