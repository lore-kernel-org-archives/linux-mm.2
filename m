Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FCB7CAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 07:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2498E0007; Fri, 26 Sep 2025 03:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BF838E0001; Fri, 26 Sep 2025 03:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6B48E0007; Fri, 26 Sep 2025 03:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7FC678E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 03:39:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38FD61A05DF
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:39:13 +0000 (UTC)
X-FDA: 83930600586.03.B34977F
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id BFCB240004
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 07:39:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wuyifeng10@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758872351; a=rsa-sha256;
	cv=none;
	b=jO0cCbSXIpfRp9lO8/m8M00pHk0qqIJYkOWm47XFezHKuKhELuedSW7AyyiZDPN0riq5jY
	p27NnqqLMZPlI7zpTFul5VuRK4IQvKsRiRND7cpBgFjpSKxym8cIgiBOTdo4SQrO9dqVDx
	0F6oPeJM98AxCP9hxl9ZQrrtjNHuGU8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of wuyifeng10@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758872351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=JbgAme6ObxkTUVR2gmH94z4Gmxuqumfs37BWXPMkisY=;
	b=FrYWVPWhswUio4LsFod5/v3Y+TIaRpTO54AWKUUcgFv6BzQTwrtnG4XX/PvbUukYXJ7Qi/
	AwgwtEXzojgQzN6xdu+TmNWQ2KVNmbkiU+bxbRzCkVgljJF8Qa/yBYAApLAzn82eHuyvFL
	FLL/i1dic2MhIeZi7sqDMX0mtILHI9I=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cY2Qp1hSpzRkCR;
	Fri, 26 Sep 2025 15:34:26 +0800 (CST)
Received: from kwepemr200005.china.huawei.com (unknown [7.202.195.182])
	by mail.maildlp.com (Postfix) with ESMTPS id 0764B180B69;
	Fri, 26 Sep 2025 15:39:05 +0800 (CST)
Received: from [10.174.184.156] (10.174.184.156) by
 kwepemr200005.china.huawei.com (7.202.195.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 26 Sep 2025 15:39:04 +0800
Message-ID: <4343116e-03d2-45dc-8ad4-12835477537e@huawei.com>
Date: Fri, 26 Sep 2025 15:39:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: <david@redhat.com>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>
CC: <linux-mm@kvack.org>
From: "wuyifeng (C)" <wuyifeng10@huawei.com>
Subject: [Question] Is flush_cache_page() in wp_page_reuse() really necessary?
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.156]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr200005.china.huawei.com (7.202.195.182)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFCB240004
X-Stat-Signature: 88x6urw98c5n49xgjxb8ykeae9itoad8
X-Rspam-User: 
X-HE-Tag: 1758872349-942334
X-HE-Meta: U2FsdGVkX19jHRXszRrkuFaedfN7BZwppF5rgEguLd/sNhqipcNjd5IC9EwQajLUgXPvMqTESFDpqd1raSdeWnV8+5UFnRXfD1JTft0OL3IXJv5fsf+siBIxLoq3RZ9ZUcwMKu67P5YxLJkdtBiIYcgY9EnA3K2BxVQBBXSh+uG9OPOYO/plZauRjm0/sIP635578cT9SEwEdHM8CrJj6sxvQE+Hx5JokAIuV+lZi9vNDxYj1fMXom3RUR9ET/+BmaPfoTNEZcj4PacAXkrr+RCxphhrQFLalr0+OqbYYZ4MZKXVEAQbz+l/UdlUAGI5NVry2Qlu0OX/JrKsAywpLcEznsZG0b7dmGJfgLSEGg83oE27jwvwwvja8zJy9Q9BUCSH9Yh46pFtMCZINiFxC/mj8J9W6BKlXbY7KLZww6AdvmOSfYyUD0fTlzJw8hABT54dLMnjrMPxzbKS7e/dXBwHK7QOeIronVUF/qb8k+dS4i50WILIww2FLJAgV5B+ylA7ELJ1lWKRMQSLkpPjSEFzCX2kDdKxtCaBQTtymwgF3iWz7Rq/AIB7/rQ9lR7T3Qm6czeRQIZvUAlb7wEeXyWkfX94QAgfdHi7IDbkmrZre0+tne9w7SenNqQ63WGWOs5ehQwWX/NS0W2LlMGnK7xiMhj/lMWQy8VT7Qku1pa6zDlwtfr/LlapEKYk6fathLYQBy1i1YEvRghQ/5YbcQkfADsMvx3BMf7amcXoB0KoWrIjucnY1CD54W8Tk8O+JUHhvjrVoPEwE0d2G9kB9+dna6GY/NoH3LHu8f6SX/MCOZbyr29NSxXd7NYa/Ir0wg3BO8ViYrymnLNgu3HxdJQRfmYvL2GQDf8bfxwOM/aA+OPkoEr7v4zIFNQIU5U3b/Y4zxXEuUEwv0RLq7PNylOl9k7tbJKKH4C1lL2HrgrCI7OCEg6no4VYCt1CkPRIvyA+ysFPJaAa2YgOis/
 RPhOBstN
 EquDpbJ3R+UwtHLKP+bZLjLYnhhv1MFMVsPmOsK6fu4LDcBzDSG2Yeh79cYhuqOeNBgNiVQn0aieLGc/zOPQWq3S+cIPtUqiy1oiC/D1RuJLJkRpo1s2AKcirkhCr8ww9SVmdw48SuPeNuyxq/xvYWrI5YN0h7BNm5UqvDw011mUfqRvEaA8/qUkCBBc4dw18UqxbEC5vRYEOvqpdUgxd8AwU5i5H2qBK6iDEQn7m/Oe71Es3yrXttUonafC0krweTScN3cTkbmCpBPD9/gn37wohoVmj77UyNLsfPGAG8tIjht4WHxFshXRcuGsIFXRMglE7aIQQ92WFDclHDww7CVkxnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linux MM developers,

I am reviewing the page fault handling code in the memory management
subsystem and came across a point that puzzled me regarding the use of
flush_cache_page().

When I referred to Documentation/core-api/cachetlb.rst, it describes a
typical sequence in a page fault scenario:

flush_cache_page(vma, addr, pfn);
set_pte(pte_pointer, new_pte_val);
flush_tlb_page(vma, addr);


That is, first the CPU cache is flushed, then the PTE is updated, and
finally the TLB is flushed for the corresponding virtual address. This
makes sense: when the virtual-to-physical mapping changes, flushing the
CPU cache is necessary to prevent stale or corrupted cache from affecting
the new mapping.

However, in wp_page_reuse(), the virtual-to-physical mapping does
not change. The function looks like this:

static inline void wp_page_reuse(struct vm_fault *vmf)
{
    struct vm_area_struct *vma = vmf->vma;
    struct page *page = vmf->page;
    pte_t entry;

    if (page)
        page_cpupid_xchg_last(page, (1 << LAST_CPUPID_SHIFT) - 1);

    flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
    entry = pte_mkyoung(vmf->orig_pte);
    entry = maybe_mkwrite(pte_mkdirty(entry), vma);
    if (ptep_set_access_flags(vma, vmf->address, vmf->pte, entry, 1))
        update_mmu_cache(vma, vmf->address, vmf->pte);
}


Since the mapping itself does not change, I am puzzled whether this
flush_cache_page() call is actually necessary.

A similar situation appears in do_huge_pmd_wp_page(), which handles
huge pages. When the system reaches the reuse branch after the relevant
checks, the code looks like this:

reuse:
	entry = pmd_mkyoung(orig_pmd);
	entry = maybe_pmd_mkwrite(pmd_mkdirty(entry), vma);
	if (pmdp_set_access_flags(vma, haddr, vmf->pmd, entry, 1))
		update_mmu_cache_pmd(vma, vmf->address, vmf->pmd);


Here, flush_cache_page() is not called. Instead, the code relies on
updating PMD access flags and calling update_mmu_cache_pmd() to refresh
the TLB.

So my questions are:

Is the flush_cache_page() call in wp_page_reuse() actually
necessary?

If it is necessary, why is flush_cache_page() not required in the
reuse branch of do_huge_pmd_wp_page() for huge pages?

I would greatly appreciate your reply. Thank you very much!

Best regards,
[wuyifeng]

