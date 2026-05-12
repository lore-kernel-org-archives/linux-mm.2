Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BE64CD4F35
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 11:16:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFC26B008A; Tue, 12 May 2026 07:16:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 989726B008C; Tue, 12 May 2026 07:16:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8504D6B0092; Tue, 12 May 2026 07:16:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 709976B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:16:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 359B91C0E51
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:16:43 +0000 (UTC)
X-FDA: 84758515086.22.373F5E8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C66C120002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 11:16:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gTgGCIUq;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778584601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i5y7BqIdpjMLDIAKqjRmJlhJjsGfrnVRzUYGVCILauA=;
	b=u/vPb79wvqBGRPpBJAw3SEdIxWT7rY3/V/mb2if0wDWjSIUlrq386JIFTrGlkWGM7Re96J
	/7yPpG511z94kRNMtsZfXtZR95DSSB4Q3uBsX+6rsArqLksaaeOxEZiv0U5VogtB0pO5bn
	dQoG4r3+DUcZMr5W6EjfjlblIsi4OZA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gTgGCIUq;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778584601; a=rsa-sha256;
	cv=none;
	b=AEnE5LbXDmAqiNFVmeY7NbrT2fJvARW/t137ZfcHlp89y4iA6TyL8ys5wlN5JSKxB3v6id
	hEDhB51hCJTxLT6+tc++5qB180wbbHq6+yvNZP6OuLXOVcHqkThLre72pd/aZBbT8bV4Ir
	PltXvZdDQNRM8l7F7iJWK2SHoxSPxR0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 420F61691;
	Tue, 12 May 2026 04:16:35 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 856343F85F;
	Tue, 12 May 2026 04:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778584600; bh=hgCDbnTRCx+Udp7UIfgW7Diqp3Wh2KQASaWwC26wC5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gTgGCIUqBJujlz8i4H2jC4Nt+pzbTtnCH64ZXIRg8m5x3tl6kKdy7/ei2JD75XbMR
	 ZVl9WmVFvA1QHwWKXTRHcAJnz9OMtfS4lIJBGrpe2r8Mc6WjwxwDUpi/TDr4E2CMF4
	 y3CO3QcZNDLe8Clu87WCtHilN8qIwZRdvyuS9e0s=
Message-ID: <b2471e5c-46fa-4f7a-a51d-c874c4a911dd@arm.com>
Date: Tue, 12 May 2026 16:46:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/9] mm/rmap: initialize nr_pages to 1 at loop start in
 try_to_unmap_one
To: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org,
 ljs@kernel.org, hughd@google.com, chrisl@kernel.org, kasong@tencent.com
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-2-dev.jain@arm.com>
 <de2f992c-dc93-4b79-b841-11f47511dcfe@kernel.org>
 <06029485-9e85-4d2d-a324-abba918eecf3@arm.com>
 <771a8ee7-0a7c-4d70-9e7a-cc08abebd4aa@kernel.org>
 <2a749617-d70a-4931-9aa3-c9b680783b82@arm.com>
 <575f7210-b325-489e-9937-afccf29753a3@kernel.org>
 <3a25e7fd-84a7-49a6-92a3-96492fe5d2cc@arm.com>
 <241fb6c4-c29a-4b61-9c4e-0b8d84715a74@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <241fb6c4-c29a-4b61-9c4e-0b8d84715a74@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6C66C120002
X-Rspam-User: 
X-Stat-Signature: fei7shbjhute1was8j3q9wy8o1f3de7y
X-HE-Tag: 1778584601-558289
X-HE-Meta: U2FsdGVkX1/Yu3fKC/agbZJt7241MB50yXiblHEbR+dKQr7qhJQ5acr/iYovqLP1xofjNOx1Xrj4mnnXn4ofWLjeXvVMbXnWg2cvcRUUsPU7pxZh1Zft0Jq7lKA2p83Q+TJ/wb9TSb82561sKJApPp8E5qDxQjfabQG5nvlEriQbI0YO8DbpJiAtGF+yCvvn5bZKOgSWUf5qj1dg05AKYKLpX+aslzZ6iqp/n8SqTkewrKibq9av7WAfKFIhUZ7w0n183kdIdPSkedwDb883CorPwL3YZlqbh3I7J6fzC3bxAkXJGCGVcEBp8NYQOCLpSntxIICHEtog8UwiJ/25OtwgwcTJjuuLMaLXf3dQSKUH3LvrZPYE/IJYubiZs5q8I2w+MMJcnBku2b/hmGTImEMQuseBoYcYUwoR7mZsQiZhseB8dwscVde4scH9pJHcF1QkSRXx3KcFQzzB+Xdl/0Xqu1Dxhj6BK257TiCvxHhboZvW9EHg7tua03jWNJqjbOZU7jXfJG3/WosxOM8fpRaJzKW2xuwerLCIqf5o+5f2mlOdRxbIBPfQ/5tlrk6Nhee3UHzXuQOUqhVlMdyMCfU+9UYM5uboVe6OUUe+KwzPRxSuxbv4/xr8SBrdMfo3k1+WeEyIRenAUKLWnAvm4ljG8Lk+a7+IMrhHF7N13MZ48d1mlHcjNUF8vmR8RwZ+Cb0CIed6ooupzq6sVt/iYOFwuVV4Ct3Owb8grNJ7/i446BWZyghvGS8Nu9dGnNlxomBZwSCLdWvrOfEljSN06oFyi1Nf/PILnJ06MjE2tkHQtbURPo52D9wq5wFnKfB7U9TltkPpZ00r7cRoAyAIZ6RXPMsLnd8syoMIJLJnXZU1smiYFI/1k8V3JvDFjfvsIJgwpvnr/67GB8XpeIsfVHjbRkMJ2nL5G8eu6t4Omdp89fI6HuT7jOCtiG0sukocNbRuHJO5Txh3yfbOW3u
 IS8WXtv1
 x+jzrUWnFypPRCTS6TCviITlEripIk9YDtuOUtfq+w8qYe+FzZxV72aXUE2Dzb1v4P9InxdkxFYnQz/kpjbIQf6C/4Edj558o0XsbrXrB1Pja7ceNSVsoBa2qmgHzQmkNOjxnkQaW57GIvzUN6dnyNZXrNeuEqGOz7DehYw0f9KVmpOstRo83HksRqhlJyQvB+38KO5vs77MyHfMif0EFpj84rVtca8S4ZqbJB+ziaJMJWIqOTJ6aiZFNSb5Junf3x7PfGZYraBWoaIsNXGqvhZU0NU0N9iYGG6YGPpaNzo6wRA/qReaLJQAeLwvO/tqkEE92EOnXSBxC6o0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/05/26 4:31 pm, David Hildenbrand (Arm) wrote:
> On 5/12/26 12:49, Dev Jain wrote:
>>
>>
>> On 12/05/26 1:47 pm, David Hildenbrand (Arm) wrote:
>>> On 5/12/26 10:14, Dev Jain wrote:
>>>>
>>>>
>>>>
>>>> You are correct.
>>>>
>>>> I did some changes in hmm-tests.c, to mmap and fault in 64K folios,
>>>> MADV_FREE them, then trigger make_device_exclusive() via hmm_dmirror_cmd()
>>>> on the last 4K part of the mapping, then trigger reclaim. I get:
>>>>
>>>>
>>>> [   96.896674] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x800030000 0x800040000)
>>>> [   96.897857] added new 256 MB chunk (total 1 chunks, 256 MB) PFNs [0x800020000 0x800030000)
>>>> [   96.898181] HMM test module loaded. This is only for testing HMM.
>>>> [   97.136132] page: refcount:17 mapcount:1 mapping:0000000000000000 index:0xfffff7bf0 pfn:0xc1a00
>>>> [   97.136160] head: order:4 mapcount:16 entire_mapcount:0 nr_pages_mapped:16 pincount:0
>>>> [   97.136211] memcg:ffff00019d433040
>>>> [   97.136219] anon flags: 0x1ffff000000085d(locked|referenced|uptodate|dirty|owner_2|head|node=0|zone=0|lastcpupid=0x1ffff|kasantag=0x0)
>>>> [   97.136264] raw: 01ffff000000085d dead000000000100 dead000000000122 ffff0000030f8781
>>>> [   97.136391] raw: 0000000fffff7bf0 0000000000000000 0000001100000000 ffff00019d433040
>>>> [   97.136587] head: 01ffff000000085d dead000000000100 dead000000000122 ffff0000030f8781
>>>> [   97.136828] head: 0000000fffff7bf0 0000000000000000 0000001100000000 ffff00019d433040
>>>> [   97.137083] head: 01ffff0000000a04 fffffdffc2068001 000000100000000f 00000000ffffffff
>>>> [   97.137090] head: ffffffff0000000f 0000000000000021 0000000000000000 0000000000000010
>>>> [   97.137096] page dumped because: VM_WARN_ON_FOLIO(!((!!(((pte).pte) & (((pteval_t)(1)) << 0))) || ((((pte).pte) & ((((pteval_t)(1)) << 0) |
>>>> ((((pteval_t)(1)) << 11)))) == ((((pteval_t)(1)) << 11)))))
>>>> [   97.137122] ------------[ cut here ]------------
>>>> [   97.137125] WARNING: mm/internal.h:346 at folio_pte_batch+0x54/0x360, CPU#4: hmm-tests/2283
>>>> [   97.137206] Modules linked in: test_hmm
>>>> [   97.137234] CPU: 4 UID: 0 PID: 2283 Comm: hmm-tests Not tainted 7.1.0-rc1+ #17 PREEMPT
>>>> [   97.137237] Hardware name: linux,dummy-virt (DT)
>>>> [   97.137238] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
>>>> [   97.137247] pc : folio_pte_batch+0x54/0x360
>>>> [   97.137253] lr : folio_pte_batch+0x54/0x360
>>>> [   97.137254] sp : ffff80008e7a3490
>>>> [   97.137263] x29: ffff80008e7a3490 x28: 0000000000000001 x27: 0000fffff7dff000
>>>> [   97.137266] x26: ffff0000451ceff0 x25: ffff000040fcaf00 x24: 00000000c1a0f780
>>>> [   97.137269] x23: 0000000000001000 x22: fffffdffc2068000 x21: fffffdffc2068000
>>>> [   97.137272] x20: ffff0000451ceff8 x19: 0000000000000001 x18: 0000000000000010
>>>> [   97.137274] x17: 3030303030303020 x16: 3030303030303030 x15: 5f6c617665747028
>>>> [   97.137276] x14: 282828207c202930 x13: 29312829745f6c61 x12: 7665747028282828
>>>> [   97.137277] x11: 2929292929313120 x10: ffff8000838feb80 x9 : ffff800080287cb8
>>>> [   97.137280] x8 : 3fffffffffffefff x7 : ffff8000838feb80 x6 : 0000000000000000
>>>> [   97.137281] x5 : ffff0002fe74a0c8 x4 : 0000000000000000 x3 : 0000000000000000
>>>> [   97.137282] x2 : 0000000000000000 x1 : ffff00014e120000 x0 : 00000000000000bb
>>>> [   97.137284] Call trace:
>>>> [   97.137285]  folio_pte_batch+0x54/0x360 (P)
>>>> [   97.137288]  folio_referenced_one+0x398/0x638
>>>> [   97.137295]  rmap_walk_anon+0x100/0x250
>>>> [   97.137296]  folio_referenced+0x17c/0x248
>>>> [   97.137297]  shrink_folio_list+0xf38/0x1968
>>>> [   97.137307]  shrink_lruvec+0x610/0xae8
>>>> [   97.137311]  shrink_node+0x218/0x888
>>>> [   97.137314]  __node_reclaim.constprop.0+0x98/0x328
>>>> [   97.137318]  user_proactive_reclaim+0x2b0/0x350
>>>> [   97.137320]  reclaim_store+0x3c/0x60
>>>> [   97.137321]  dev_attr_store+0x20/0x40
>>>> [   97.137338]  sysfs_kf_write+0x84/0xa8
>>>> [   97.137351]  kernfs_fop_write_iter+0x130/0x1c8
>>>> [   97.137352]  vfs_write+0x2c0/0x370
>>>> [   97.137360]  ksys_write+0x74/0x118
>>>> [   97.137362]  __arm64_sys_write+0x24/0x38
>>>> [   97.137363]  invoke_syscall+0x5c/0x120
>>>> [   97.137374]  el0_svc_common.constprop.0+0x48/0xf8
>>>> [   97.137376]  do_el0_svc+0x28/0x40
>>>> [   97.137377]  el0_svc+0x38/0x168
>>>> [   97.137396]  el0t_64_sync_handler+0xa0/0xe8
>>>> [   97.137398]  el0t_64_sync+0x1a4/0x1a8
>>>> [   97.137400] ---[ end trace 0000000000000000 ]---
>>>>
>>>> the warning happens in folio_referenced_one -> folio_pte_batch -> !pte_present().
>>>> Not sure why it happens in folio_referenced_one instead of try_to_unmap_one.
>>>>
>>>> I set nr_pages = 1 at the start of the pvmw walk in try_to_unmap_one and this
>>>> goes away.
>>>>
>>>> Will send this as a separate fix patch.
>>>
>>> Awesome, thanks! (CC stable)
>>
>> Okay I think there is another bug. In folio_referenced_one,
>>
>> 	if (folio_test_large(folio)) {
>> 		unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
>> 		unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
>> 		pte_t pteval = ptep_get(pvmw.pte);
>>
>> 		nr = folio_pte_batch(folio, pvmw.pte,
>> 				     pteval, max_nr);
>> 	}
>>
>> There is no pte_present(pteval) check here. We will encounter a non-present
>> entry in folio_pte_batch(), giving the trace above.
> 
> clear_flush_young_ptes_notify() should also only get called for present PTEs.
> 
> See damon_ptep_mkold(), where we trigger mmu notifiers separately to handle
> exactly that.
> 
> I recall that I looked at that code in context of
> 
> 	https://lore.kernel.org/all/20250210193801.781278-16-david@redhat.com/T/#mf98677cb5a9419a5d695b2ed5427fdd75ed08dcb
> 
> And assumed that it would not be required in folio_referenced_one().
> 
> If only I could remember why I thought it would be ok ...

For your benefit, here is the reproducer. Replace the current
TEST_F(hmm, exclusive) segment with the following:

void write_to_reclaim() {
    const char *path = "/sys/devices/system/node/node0/reclaim";
    const char *value = "409600000000";
    int fd = open(path, O_WRONLY);
    if (fd == -1) {
        perror("open");
        exit(EXIT_FAILURE);
    }

    if (write(fd, value, sizeof("409600000000") - 1) == -1) {
        perror("write");
        close(fd);
        exit(EXIT_FAILURE);
    }

    printf("Successfully wrote %s to %s\n", value, path);
    close(fd);
}

/*
 * Basic check of exclusive faulting.
 */
TEST_F(hmm, exclusive)
{
	struct hmm_buffer buffer = {};
	unsigned long huge_size;
	unsigned long npages = 1;
	unsigned long i;
	unsigned char *mapping;
	void *raw_mapping;
	unsigned char *ptr;
	int ret;

	huge_size = 2 * 1024 * 1024;
	ASSERT_GE(huge_size, self->page_size * 2);

	buffer.fd = -1;
	buffer.size = self->page_size;
	buffer.mirror = malloc(buffer.size);
	ASSERT_NE(buffer.mirror, NULL);

	raw_mapping = mmap(NULL, 2 * huge_size, PROT_READ | PROT_WRITE,
			   MAP_PRIVATE | MAP_ANONYMOUS, buffer.fd, 0);
	ASSERT_NE(raw_mapping, MAP_FAILED);
	mapping = (unsigned char *)ALIGN((uintptr_t)raw_mapping, huge_size);

	memset(mapping, 0xab, huge_size);


	ret = madvise(mapping, huge_size, MADV_FREE);
	ASSERT_EQ(ret, 0);

	/*
	 * Exercise device-exclusive conversion on a single 4K page inside a
	 * lazyfree PMD-sized mapping, not on the whole mapping.
	 */
	buffer.ptr = mapping + huge_size - self->page_size;


	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_EXCLUSIVE, &buffer, npages);
	ASSERT_EQ(ret, 0);
	ASSERT_EQ(buffer.cpages, npages);

	write_to_reclaim();

	/* Give the lazyfree folio a chance to be reclaimed after exclusive conversion. */
	sleep(100);

	/* Check what the device read. */
	for (i = 0, ptr = buffer.mirror; i < buffer.size; ++i)
		ASSERT_EQ(ptr[i], 0xab);

	/* Fault the exclusive page back to system memory. */
	ptr = buffer.ptr;
	for (i = 0; i < buffer.size; ++i)
		ASSERT_EQ(ptr[i], 0xab);
	ptr[0] = 0xcd;

	/* Check atomic access revoked */
	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_CHECK_EXCLUSIVE, &buffer,
			      npages);
	ASSERT_EQ(ret, 0);

	ASSERT_EQ(munmap(raw_mapping, 2 * huge_size), 0);
	free(buffer.mirror);
}


Then, patch test_hmm.sh with

-       $(dirname "${BASH_SOURCE[0]}")/hmm-tests
+       $(dirname "${BASH_SOURCE[0]}")/hmm-tests \
+       -r hmm.hmm_device_private.exclusive


Set 2M thp to never and 64K thp to always.

> 


