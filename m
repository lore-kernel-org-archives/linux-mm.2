Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D07A8CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 06:20:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223088E000B; Mon, 22 Sep 2025 02:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ACCE8E0001; Mon, 22 Sep 2025 02:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09BD88E000B; Mon, 22 Sep 2025 02:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E338F8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:20:00 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 782F613B385
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:20:00 +0000 (UTC)
X-FDA: 83915885760.28.47D49DE
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id 240F7100002
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:19:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wuyifeng10@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758521998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=tWQ/09yobdvjzyUNYCpvkrefVYXvF7uLQAQxfVrK8Ds=;
	b=kWEDNJJVii/3Tum4e0Rk75Nn4dDf8Ke5ei1wDtUVHau0kcR7l+B7VsZTy+av76jjh7WNal
	OBAkTyYxXmYdWtbbGxQv3Rxt6UN03g6q4DtwMYNN0t+RXH8Bx17jVrg71HliT4t0LHk+J9
	S5WPWwmSYSqnjbAEIo2PcZ5NXhG0D1c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of wuyifeng10@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wuyifeng10@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758521998; a=rsa-sha256;
	cv=none;
	b=j7CtlLogVaRBJuGw7CLz51ulU3vscIGQ3wIDWev0ZHtYJVnUblDoak9dEy5cvB/VclecZr
	miwJXmbNRwn3F33YHfSNkISbxQYzHpEhBZFlJ7PWCcLfGXeoi3VznPqBx5Nn9CrOXfSVUY
	vd8xLl0E9GhDxESi9kJ5H/UpZ5g3UJM=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cVXsG1Fp7zQkM3;
	Mon, 22 Sep 2025 14:15:14 +0800 (CST)
Received: from kwepemr200005.china.huawei.com (unknown [7.202.195.182])
	by mail.maildlp.com (Postfix) with ESMTPS id 67089140137;
	Mon, 22 Sep 2025 14:19:52 +0800 (CST)
Received: from [10.174.184.156] (10.174.184.156) by
 kwepemr200005.china.huawei.com (7.202.195.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Sep 2025 14:19:51 +0800
Message-ID: <17ad24e5-9ee0-4d94-be5f-3c28bd57460a@huawei.com>
Date: Mon, 22 Sep 2025 14:19:51 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "wuyifeng (C)" <wuyifeng10@huawei.com>
Subject: [RFC] mm: MAP_POPULATE on writable anonymous mappings marks pte dirty
 is necessarily?
To: <david@redhat.com>, <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.156]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr200005.china.huawei.com (7.202.195.182)
X-Rspamd-Queue-Id: 240F7100002
X-Rspamd-Server: rspam05
X-Stat-Signature: j1dfnt3jhsxawiqpecipy8z3nmqizwgw
X-Rspam-User: 
X-HE-Tag: 1758521996-823366
X-HE-Meta: U2FsdGVkX1/dWomuR5qM4lXKQ3uN+0enE1Y2Fh0Gvujdm80LIOuWWIGQGZVgy3SqVo93ItQlpRsO5G0m/Ia7GxeSQPHpCDZ3614VkfMudxSUhz0SI8I8Jbwt6ofIZuFd2o3IMy5lzrWZpXkalTtrpdFMmeeXHCz/26vLq8IeV2dI6tkv5+Df1ZZ+IFyILfZUHEr349lgSskYQwOOYf5xu/4IvD29B8yYgb9bStfnaG/MoXz6VMtQl95DkzTs1SEhEqoRcf/Jdq8gWEwNR9qCq6UUT06u4KeAN0gPQ2AyKgqe2bhVuI98wt7Ts3STkvwC40sPJG8HwtzlZw5435vbYEKHdQ/Q9RkJ0LNpg+RwF5Anwfh4au2Ktx9pvFXurSieRh1jX19ZP8YgoO64k2gzyG3wS2am4aumk01WjOR6hrnqUTg1cFVfmQIiE95MUwcBncvF7j3y2d+biDOnj3Rt7hQ+ZUJRMrz5rXDRmfavqg5sraggUC8R9jE1vZHoeRIC760vUyszTAGiRoWDKAAzcRR6v1q0r8fn4SfypVtHpkAFj43WGaD5f7kjK3JxpQ5aZRnb1KrqaqFbzY1dxo/2k6/k/BGvbQvJzs2PvP7xyDd6TgevyH0wLBRd/gFA5nRjAORqHJQf7t9rKSAfxn38gjKzl59dWIFAzz2STEomlnT1EdI17Avfi2tNOHCsJ3vJCubzri+8FfBqIFSCecpbWiOxpoB8L9LA3FIyGT7pLblViw5Y180mZHwPW+/xYKJKv6M81R0VaMO3Fm2jpjXwa53SQSbl8jyRlG+6VYmqzKtRUihKyr2APL3K7WAc2dwdv8iEgRyLBFETW9zffu5TQ9eqbpZV7MW+p54vaDpaEfE+akuvMEbbZdz1L8R8uOmDkk7Gj8zrtU7UZ31rUx+fnZ1eB45Nx7m58DAlzUJXNJ8pJCutOW+GxD1EKBxucc4BvaBjgE33fOCOlkZizfS
 gVxWb4JL
 e9Thlg/CKnPxrKBFL2KZOGWiXPVPOZA7g3ShUadYJRExkTz0dOMHOPR17a/8tiVKBtVhhYIUmVFObZlvkmwPt0Q18Wx3ZPg1G1e6K0O5Qjlt9JLMl4lgh3EScR991ZQ0MuXqwTidKbbIANmB/nDJhv3Gl4V7f/IxNJ93TcVm0gbLhrsvwv/ZKw6vMs3rHmPoHzHbcqu/Qq8ivrdZeNbPZpWeJPt4efzYPjItSqHKziAdyggn8wsfwMqOz8yhlYqNKQ5xp6aSBe56aWAapUtjqbDFZybDh9nk40dvrB7Fgc4H/T+s1R/zBVijcwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all, While reviewing the memory management code, I noticed a
potential inefficiency related to MAP_POPULATE used on writable
anonymous mappings.I verified the behavior on the mainline kernel
and wanted to share it for discussion.

Test Environment:
Kernel version: 6.17.0-rc4-00083-gb9a10f876409
Architecture: aarch64

Background:
For anonymous mappings with PROT_WRITE | PROT_READ, using MAP_POPULATE
is intended to pre-fault pages, so that subsequent accesses do not
trigger page faults. However,I observed that when MAP_POPULATE is used
on writable anonymous mappings, all pre-faulted pages are immediately
marked as dirty, even though the user program has not written to them.

Minimal Reproduction:

#define _GNU_SOURCE
#include <sys/mman.h>
#include <unistd.h>
#include <stdio.h>

int main() {
    size_t len = 100*1024*1024; // 100MB
    void *p = mmap(NULL, len, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_POPULATE, -1, 0);
    if (p == MAP_FAILED) {
        perror("mmap");
        return 1;
    }
    pause();
    return 0;
}

Observed Output (/proc/<pid>/smaps):
ffff7a600000-ffff80a00000 rw-p 00000000 00:00 0
Size:             102400 kB
KernelPageSize:        4 kB
MMUPageSize:           4 kB
Rss:              102400 kB
Pss:              102400 kB
Pss_Dirty:        102400 kB
Shared_Clean:          0 kB
Shared_Dirty:          0 kB
Private_Clean:         0 kB
Private_Dirty:    102400 kB
Referenced:       102400 kB
Anonymous:        102400 kB
KSM:                   0 kB
LazyFree:              0 kB
AnonHugePages:    102400 kB
ShmemPmdMapped:        0 kB
FilePmdMapped:         0 kB
Shared_Hugetlb:        0 kB
Private_Hugetlb:       0 kB
Swap:                  0 kB
SwapPss:               0 kB
Locked:                0 kB
THPeligible:           1
VmFlags: rd wr mr mw me ac

Code Path Analysis:
The behavior can be traced through the following kernel code path:
populate_vma_page_range() is invoked to pre-fault pages for the VMA.
Inside it:

if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
        gup_flags |= FOLL_WRITE;

This sets FOLL_WRITE for writable anonymous VMAs.

Later, in faultin_page():

if (*flags & FOLL_WRITE)
        fault_flags |= FAULT_FLAG_WRITE;

This effectively marks the page fault as a write.
Finally, in do_anonymous_page():

if (vma->vm_flags & VM_WRITE)
        entry = pte_mkwrite(pte_mkdirty(entry), vma);

Here, the PTE is updated to writable and immediately marked dirty.
As a result, all pre-faulted pages are marked dirty, even though the
user program has not performed any writes.
For large anonymous mappings, this can trigger unnecessary swap-out
writebacks, generating avoidable I/O.

Discussion:
Would it be possible to optimize this behavior: for example, by
populate pte as writable, but deferring the dirty bit until the user
actually writes to the page?

Thanks, [wuyifeng]

