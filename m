Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B564CD5BC0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 04:39:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5D016B0093; Mon, 25 May 2026 00:39:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A34446B0095; Mon, 25 May 2026 00:39:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9713D6B0096; Mon, 25 May 2026 00:39:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 853506B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 00:39:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1B52F120162
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:39:50 +0000 (UTC)
X-FDA: 84804689340.25.A7B6FCB
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6011B80005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 04:39:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of wang.yaxin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=wang.yaxin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779683988; a=rsa-sha256;
	cv=none;
	b=o8fw+fbdi2p9c7ieGBBeFcrfXIM/nzTH/aAolft41b6e38k798XafYTTvvnVJ2Mj0lcNgF
	nNhlyBEFl+INmGoSZgIB2I4wNseWbVbNGiA125JQf/ZdAPEzbBPtZ4elUiXPffR2HUlStG
	H33b/rPQm4P/42jp0wZIftTa6e2L5Kk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of wang.yaxin@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=wang.yaxin@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779683988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=5ytrhBzcTWrwrfWgOdPFu9DCAn0mFEblPZaAuZ7mDhk=;
	b=3XYGNO8bpgX4rRuevdxDBbowy1ZQqmDlUFwa2XJUyO1vCY/iChmCZaZP2QCDDlDIYRDbPl
	RTpy+4X9XOVYePbQxf3LVihHD0DvNDYFW+ZjdwKfh3Y5p6hWCDy/TCSYSvLokYdjZuxC8g
	y9De3DA0e6HRLXLV0NZmw/6MTe3UDF8=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gP37x6hfLz8Xrr9;
	Mon, 25 May 2026 12:39:41 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 64P4dcfO091434;
	Mon, 25 May 2026 12:39:38 +0800 (+08)
	(envelope-from wang.yaxin@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 25 May 2026 12:39:38 +0800 (CST)
X-Zmail-TransId: 2afa6a13d28aa9d-bf2e5
X-Mailer: Zmail v1.0
Message-ID: <20260525123938427-2LRlh6S2Ew79m61xNh6S@zte.com.cn>
Date: Mon, 25 May 2026 12:39:38 +0800 (CST)
Mime-Version: 1.0
From: <wang.yaxin@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ziy@nvidia.com>,
        <matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>,
        <rakie.kim@sk.com>, <byungchul@sk.com>, <gourry@gourry.net>,
        <ying.huang@linux.alibaba.com>, <apopple@nvidia.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Cc: <xu.xin16@zte.com.cn>, <chen.junlin@zte.com.cn>, <wang.yaxin@zte.com.cn>,
        <jiang.kun2@zte.com.cn>, <tu.qiang35@zte.com.cn>,
        <ran.xiaokai@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHN0YWJsZSA1LjEwXSBtbTogbnVtYTogcHJlc2VydmUgUE1EIHdyaXRlIHBlcm1pc3Npb25zIGluIG1pZ3JhdGVfbWlzcGxhY2VkX3RyYW5zaHVnZV9wYWdl?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64P4dcfO091434
X-TLS: YES
X-ENVELOPE-SENDER: wang.yaxin@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 25 May 2026 12:39:41 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A13D28D.001/4gP37x6hfLz8Xrr9
X-Rspam-User: 
X-Rspamd-Queue-Id: 6011B80005
X-Rspamd-Server: rspam03
X-Stat-Signature: 48i6ngoe575utkyokrbm8u4dbi1jqq1a
X-HE-Tag: 1779683987-226997
X-HE-Meta: U2FsdGVkX19sxf1Nv3BexLU+STnR8/rlRTLwdvWSWdmm21TZsAVDw6GI0IQaCGqcrIRErSuE/TWaysHWHZnDobwb/2v5AtNO5hCg+GxKl+gmnE1UCLXMgXMnAoZttpjshDRsYDu2msy9UrrK2S6pcI9d/lL28O2CUGLuOjtZ17W2du6HvXHhtZAuyC/BoCxXonUqi1S0W+8275g3oYXCPhxSUCFyPIzCIAoBJnX/nWVGGOV1NzZhStfYnHSHGsZqx5Bf2ENWUR8BMkX96worRzc7AmvDlEx2zCzKOa3c4WYzxL5tuofkwszqOAR38qthT3xZtPTdaDZ9/pTSIJnXUFVHetWKXZQ7nPzdVS1BQH7S8KpGwAHnZ4ntfFoKp9hKFKM5fQLfZBfpzlmPTlTKMzHHpl8IlVOzThEGcwGZLZCe8W3j2+qdlLaCxTvgFRujWOHPrQqJhb3afsjnQDmV+ucUaC1wYav4LaMy/Vn/gidgiS1vpkN7bFQipEvTXzvGMcf99ETW4J9ZWRWQF6RBWk8NoQHZFn4j3nmOPsFlYdzssGxM9iTHlJBBBMXBaDtJChJ1C+E3RbV2ENSLqVWYw/dgM3QCKPeQzIY49QHNqTtt/3Ll4JCFfDvMLsnricVx3XqMH73JfQ/DKkr339hxbPTBLqFX9qa8MFUaqtXhkDdzt1ZMjFBo72pNk/v1Q1SqBNF5dP7glrc96jPSAjFW3T3+d9kwc70gTj3fSm5jfzpwG9oGJnd5Gp7dsLDKSVnuaRnFLEQXwSKihTPmwHl9YexpwNpS/9PYuXCxPh1UEHTjIOyi9M8HsKo7XbDLGv1Xo10juz2YRV7d49SqcKrEP9gfYQW1bg3g42K+nUfvL2lt/4kI8y6cTFfuxVye7hjxfdFay8cc8kWAAKF2l2i9xdtOfW9ulBPyF8FuvoCbZ/uET7qfPEFYfc/Vn6RankSFULcJ6rohGmFX1Je55GZ
 PAmNQHFJ
 VfTlp06YCBvukF2VEbgyqewXwhBdDV4MJfu1B1shqBv5n5+wCZbAVuZTm0zX3KbFrqnIQcpWsFzkNpv4CiS5Fbi6UzKODkczwsO4BswaGfcGc2mroPNbgoxOhjybPNTCMeXd7x/lbkrG+dvj3fiTOclwPdt14AkAAoSGfRGI1aR8x4r9/1S2P54MoAEpTVdMuRMr/8dA+2x0SLILGmUMydMTdk1MfbgpPbPpjsHx0l+1Dg7W34avj3Gnpc1sCaLFv2L4/0vJOg3t6X9FXU5rRcHe8CIYR3gzzPPcr81EKHPkDV+1AqXUjVKxeeJEY2/Fq5ylTWTbLCohBl+dkTG4u7uJ11+1BneMQBbQ2yqFri5mM2qBWypmbApSMS+roeRS5Y1K+R9rWBb4d9VZLFcPO0yVdfDhRt7MFbExs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chen Junlin <chen.junlin@zte.com.cn>

When a process allocates a transparent huge page in its address space, and
then enters the kernel driver via an ioctl system call, a driver (eg.
ib_uverbs) calls the pin_user_pages_fast function to pin the process’s
virtual addresses to physical pages. Subsequently, when the process
accesses this pinned memory across NUMA nodes, triggering the system’s
NUMA balancing capability, a page fault occurs and the kernel enters
do_huge_pmd_numa_page, then it calls migrate_misplaced_transhuge_page to
migrate the transparent huge page. However, because the memory within the
huge page has been pinned by pin_user_pages_fast, numamigrate_isolate_page
returns 0. migrate_misplaced_transhuge_page proceeds to the out_fail path,
where it changes the PMD page table entry to write-protected by pte_modify.
If the process then performs a fork operation, copy_huge_pmd is invoked.
Due to the pinned memory, __split_huge_pmd is called to split the PMD page
table entry into PTE page table entries. These PTEs are also set to
write-protected. Finally, when the process writes to this memory region, a
copy-on-write (COW) operation takes place, allocating a new physical
memory page. This breaks the binding between the process’s virtual
address and the pinned physical memory.

Here is my test code in userspace.The /dev/test_gup is provided by a
simple kerenl mod, it just help us calls pin_user_pages_fast in kernel by
passing va to ioctl, so I do not provides code of kernel mod.

The test code runs on an x86 QEMU-KVM virtual machine with a specification
of 64 cores and 2 NUMA nodes (0-31:node0, 32-63:node1).
Kernel is 5.10.256, numa balancing para is
kernel.numa_balancing = 1
kernel.numa_balancing_scan_delay_ms = 1000
kernel.numa_balancing_scan_period_max_ms = 60000
kernel.numa_balancing_scan_period_min_ms = 1000
kernel.numa_balancing_scan_size_mb = 256
/sys/kernel/mm/transparent_hugepage/enabled is always

===
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include <sys/mman.h>
 #include <errno.h>
 #include <sched.h>
 #include <fcntl.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
 #include <signal.h>
 #include <linux/ioctl.h>
 #include <linux/types.h>

 #define HUGE_PAGE_SIZE (2 * 1024 * 1024)
 #define ALIGNMENT HUGE_PAGE_SIZE
 #define MEMORY_SIZE (HUGE_PAGE_SIZE * 16)
 #define TEST_GUP_IOC_MAGIC 'G'
 #define TEST_GUP_IOCTL_PIN_PAGES \ 
         _IOWR(TEST_GUP_IOC_MAGIC, 1, struct test_gup_request)
 #define TEST_GUP_IOCTL_UNPIN_PAGES \
         _IOW(TEST_GUP_IOC_MAGIC, 2, struct test_gup_request)

struct test_gup_request {
        __u64 user_addr;
        __u64 size;
        __u64 page_count;
        __u32 flags;
};

void touch_memory(void *addr, size_t length, int write)
{
        volatile char *ptr = (volatile char *)addr;
        char tmp;
        size_t page_size = getpagesize();
        for (size_t i = 0; i < length; i += page_size) {
                if (write)
                        ptr[i] = (char)(i % 256);
                else
                        tmp = ptr[i];
        }
}

void init_sigchld()
{
        struct sigaction sa;
        sa.sa_handler = SIG_IGN;
        sigemptyset(&sa.sa_mask);
        sa.sa_flags = 0;
        sigaction(SIGCHLD, &sa, NULL);
}

int main()
{
        init_sigchld();
        int fd;
        struct test_gup_request req;
        int ret;
        pid_t pid = getpid();
        int cpu = sched_getcpu();
        int cpu_af = 63;
        int i;

        void *memory = mmap(NULL, MEMORY_SIZE, PROT_READ | PROT_WRITE,
                            MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        touch_memory(memory, MEMORY_SIZE, 1);

        if (cpu > 31)
                cpu_af = 0;
        cpu_set_t mask;
        CPU_ZERO(&mask);
        CPU_SET(cpu_af, &mask);
        sched_setaffinity(0, sizeof(mask), &mask);

        // /dev/test_gup here is provide by a test mod
        fd = open("/dev/test_gup", O_RDWR);
        memset(&req, 0, sizeof(req));
        req.user_addr = (__u64) memory;
        req.size = 4096 * 9;
        // ioctl just call pin_user_pages_fast in kenrel
        ret = ioctl(fd, TEST_GUP_IOCTL_PIN_PAGES, &req);
        if (ret < 0) {
                printf("IOCTL pin pages failed: %s\n", strerror(errno));
        } else {
                printf("Successfully pinned %lu pages at pid %d %lx\n",
                       req.page_count, pid, req.user_addr);
        }
        getchar();
        // here you can see the original va <-> pa binding in crash by vtop

        i = 0;
        while (i < 100000) {
                touch_memory(memory, MEMORY_SIZE, 0);
                i++;
        }
        printf("numa balance done\n");
        getchar(); // pmd was write-protected

        pid_t t_pid = fork();
        if (t_pid == 0)
                _exit(0);
        sleep(1);
        printf("fork done\n");
        getchar(); // pte was write-protected

        memset((void *)req.user_addr, 9, 1);
        printf("write pinned mem done\n");
        getchar(); // cow was done, the binding of va <-> pa was broken

        return 0;
}
===

commit b191f9b106ea ("mm: numa: preserve PTE write permissions across a
NUMA hinting fault") added write permission recovery in
do_huge_pmd_numa_page, but did not add the same recovery in
migrate_misplaced_transhuge_page. Later, commit d042035eaf5f ("mm/thp:
Split huge pmds/puds if they're pinned when fork()") enforced that
transparent huge pages with pinned memory must have their PMD page
tables split into PTE page tables in copy_huge_pmd. After that, this
issue started to appear.

So, the simplest way to fix this issue is to also perform the
corresponding write permission recovery in the out_fail code path of
migrate_misplaced_transhuge_page.

Signed-off-by: Chen Junlin <chen.junlin@zte.com.cn>
---
 mm/migrate.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/migrate.c b/mm/migrate.c
index bf59b09455ad..126b6ad675ce 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2143,6 +2143,7 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	struct page *new_page = NULL;
 	int page_lru = page_is_file_lru(page);
 	unsigned long start = address & HPAGE_PMD_MASK;
+	bool was_writable;

 	new_page = alloc_pages_node(node,
 		(GFP_TRANSHUGE_LIGHT | __GFP_THISNODE),
@@ -2247,7 +2248,10 @@ int migrate_misplaced_transhuge_page(struct mm_struct *mm,
 	count_vm_events(PGMIGRATE_FAIL, HPAGE_PMD_NR);
 	ptl = pmd_lock(mm, pmd);
 	if (pmd_same(*pmd, entry)) {
+		was_writable = pmd_savedwrite(entry);
 		entry = pmd_modify(entry, vma->vm_page_prot);
+		if (was_writable)
+			entry = pmd_mkwrite(entry);
 		set_pmd_at(mm, start, pmd, entry);
 		update_mmu_cache_pmd(vma, address, &entry);
 	}
--
2.27.0

