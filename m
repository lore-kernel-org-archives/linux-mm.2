Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DCEACDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C986B008A; Tue, 23 Jun 2026 06:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14C66B0092; Tue, 23 Jun 2026 06:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AA56B0095; Tue, 23 Jun 2026 06:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8711A6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:55:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D1FD120468
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:55:03 +0000 (UTC)
X-FDA: 84910870086.22.D27E3CD
Received: from out203-205-221-155.mail.qq.com (out203-205-221-155.mail.qq.com [203.205.221.155])
	by imf17.hostedemail.com (Postfix) with ESMTP id E4FFF4000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:54:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=mwgiGPDg;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf17.hostedemail.com: domain of xiaowu.417@qq.com designates 203.205.221.155 as permitted sender) smtp.mailfrom=xiaowu.417@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782212101;
	b=YZiURChT2mKzdJ8n0XSR/+phoWC7UZziBD8FOCwdkFVbST7sxPsupHFfMoq9ooMbm79DqK
	hQiEdek4Fwf4kFThmOqwYbGZn1XveU1Buul8VoC1JUTa0PPjLYxObmK3XKL0YhF8szChNZ
	JqHUtl15ht2PlyfFKclTZft1EKtgeBo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782212101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4q88+ttZMviWZpntI44EOp6qd5JvFg5Bi7R2f2PE/as=;
	b=tsbPRZi2CwI/VEmiiioUBWHVMmN2rBS3ZEl4f2vo9brJe/fYN0hXs2cB4dUWNLOLiunNj2
	hdwMeX9WQPrGn7xBLuirDTj/sfAoVTkMkUomPDQt7RNn2BMgxspUZftOSlCO1+wnRac+YH
	zTGwx1mo/1NgI983ck0sjCh+sZAYiV0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=mwgiGPDg;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf17.hostedemail.com: domain of xiaowu.417@qq.com designates 203.205.221.155 as permitted sender) smtp.mailfrom=xiaowu.417@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1782212095; bh=4q88+ttZMviWZpntI44EOp6qd5JvFg5Bi7R2f2PE/as=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mwgiGPDgEyICWYsAjjQ2IFXcPh64q/rnAkz9W60L4x9IEBiNsvHooZaj+m1AI0ic4
	 DLv6lqycCj3mP1S0Zi7LCh6SzZ/Cg96HtzwY5GlRaqF7Z6FV3+YV6xyQpdQWg+ZALV
	 sBku/OqHWaiXDbTxmhvMx1hnHNMdYPxYUeG66Vcc=
Received: from [192.168.3.157] ([115.156.144.140])
	by newxmesmtplogicsvrszc56-0.qq.com (NewEsmtp) with SMTP
	id DB30CEEF; Tue, 23 Jun 2026 18:54:51 +0800
X-QQ-mid: xmsmtpt1782212091tn5pm9rfd
Message-ID: <tencent_222F50A4CB8E790B93AB90E5109DE13E1A09@qq.com>
X-QQ-XMAILINFO: OKOirRU4nj6hMqiv/M7N7uFPSUU+cUH9KafDvKjAUKlgZ/b860U6gUDxBB+MhG
	 V1b989M8wuAge71fRcW+pMYJgmrduR7t73knpWxcCaV/VtDg4qNJV9s0WyECUcSJPlNhY81wJhqu
	 +cB1ziQb3pWXyfiCHN4trXzZ69/9poI3JZmSKyyH6I3emdJPz6XpzmvI7SKiUDSAr3btNxYJqZkE
	 lHpEjdYROVZ1gQx4jSe2QBbRIkLWaaqS7WZyM8gwl/PQ15OLGa/m17rEvXWApOwaLLAJrX1JN6oJ
	 oOkM6FCvdrMqa2/d3slO2X2p3xIBmTI3uKCtU4RgSyLOfYBm9mS5p9r0uFtOEuRvlIaqqxyiwWaV
	 luD+ujQisVcfjTR3rCyeXFlRwqeWvvGtOdTeAzsT14jbOve2bAPSQZv5J/R3MMpVbdh15FfTlMQO
	 opXIF8Bt2YsxbumHN8M7pQdvHkrafX4pe+MfzmHRor20tYChUhWHzc4TC7odjuIG3SWp1crwfdPg
	 AEl9yLXKR/yzKAJeSMwnHgJKpGqNzX3pX6tIb2N76NAOHZQhkSIwn8JwJmIbOF7Qv24vu+CkIl5W
	 4kcslfQ5uvcb/5e6s9FW2JuD1F6k25OKxDZq424lYnANNaWmzQxKreXCqGmnf63QR9J3FtrtCcy1
	 J6brugBsWZ1xDjk9UmBAdi5x/rogr+30zFGNnICT8DBYW61KS249/nlHoZi7Kq0LBtc6gesYaYHS
	 cp2ktfOSQrW+dRoCMUbYWmCn0SswbiUH6oIiYqTzAONEF6hIgMW9iaU3kOWc+V0mbwGuJ4YRjYhS
	 5GCYszNpwE7XpHZUGnu6/pvsHu8BDIELeb8iwmpSYGTOzPTTtOFntyesl+P27KCyphowN4lpGh8v
	 A/QC7thBlqWknwwnNppkGvj3zt0h0fcjgtebR16e3XWCwZZau4LEU11jbldnJHTo+mcYSvvdU2+o
	 KHJTNFRxbDWCJnUe4xvL6G8/wvE9Hi2eRf3OAk9d6GGAILRY4RWwUppubsHeXvf8HxwMkX336OOL
	 vgeYnRhsQhZsUnuFrlT3sv0KtdByCIPpHZ3zPweQRxl6OPOccqgVbTzYolDfhhhImj1zgjvRyJxD
	 Y0yvbDj+j5ciqtq50EaTx6YuRj/w==
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-OQ-MSGID: <ce01e205-4129-4c97-8b2a-ab129cebf5e3@qq.com>
Date: Tue, 23 Jun 2026 18:54:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/11] hugetlb: Convert the vmf->pgoff to PAGE_SIZE
 granularity
To: Jane Chu <jane.chu@oracle.com>, akpm@linux-foundation.org
Cc: willy@infradead.org, jack@suse.cz, viro@zeniv.linux.org.uk,
 brauner@kernel.org, muchun.song@linux.dev, osalvador@suse.de,
 david@kernel.org, hughd@google.com, baolin.wang@linux.alibaba.com,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, lorenzo@kernel.org,
 rppt@kernel.org, peterx@redhat.com, corbet@lwn.net,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260617172534.1740152-1-jane.chu@oracle.com>
 <20260617172534.1740152-6-jane.chu@oracle.com>
From: XIAO WU <xiaowu.417@qq.com>
In-Reply-To: <20260617172534.1740152-6-jane.chu@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E4FFF4000B
X-Rspam-User: 
X-Stat-Signature: hemswpyyubn9kog1yeysz3zmtdberg4q
X-HE-Tag: 1782212099-361230
X-HE-Meta: U2FsdGVkX1/m8IqtlXRujVV0+fOHZVhfV0w1wP83qa7yDEoH+QccJnePtXtDxS7GuuTVX34pR7rncpwbR44SUlgNi1cARXmr3J970PeOItrgNckwTMIYPP4WUWjxOqDrY2FsHHMq8zZkEaxJIFULSd7dV1pGYkIKdDsSghEd4uLm2xFORMZGmcVP59+UdjmTxUYegAgDzHZ+iGaOuC1sljXWN/Fpy+YwVyaFpHxoypArnXSVBFL7w3/DZ6V020PRK2EdWaQsESkQLupG47B1p2FyA3eALVx3qYMSLwgu4oOQ2ZnH+uKs8ZnnH/e0tKERLk84ukMBMMeELX6b231ne6iAPCy4q4wiSeHcLGY2YgUI/VKrG5d5lVM8RRAFo/PcrY+gegcZxKsFI17cBPKgTfwaPLpadWw6Ht0mSdysFFvTNakvmjgpmugJSDTeerXlfLBlV5fnwM5vNhgnsL9pyVy+l+fZPuuSd9Qc3PxdAANbDpX+gQH1ahWmB2SgcikAxakuCRnAMmzaCznog3Do1eSHdQSP18CsuHWM+Pnf0/zo/uex1CDbzoZo+zOGvMQXTc8b47gvJy7sG4khgeCPbummfwqVVxkllpMk8RRbgdLamnvrOVBdMyvAK8UIxMKQyoCADPnoUSisB+53uluBzSXokUxHxKjDPxHY1BSGhi6enkWioFGax2gA8CyPo2ZgUi9erfgynAWvM83qgFtA9gWoiiasZVMvyaBo06f8DtBnbxDX03qN/ooxyksKyjb3MN4V9oo3drjttQTO25oYUh3p6ZybzfNMLA/UPxYWOv0pGedYSK0ROVdL9dq7aVR+F0cwwlgY63qeP0L2mznuuG01DH8DR6ReqrszGy7wE8RGnDAcv6fpzqPXVcO8WiXZw3G5H8McCbuF1soukytlem2WXf0nZfyCHm0JvmGbQiTConEESoao6YwGD3ePtw0qwtQxsbtkhkIpN9dJCUf
 RI8+Gctt
 f6oH6x/oZqQQN39EP3/1YXXU6dqz1dN3w9/4OM1cEFN0pE+V9u6OdGrx4lJzDoM0X26gCR/2I5ivLF3Z4ny5zfoqG6sqpRJO6CGVN7dWJnXTOyUe9rViD1wsh4m4L9vmIS18HPvq3I2MZjlY5EGj7tkg1tmo+qN5pxmxFnkEo8O29P/Vbhg9RmjgRdxdy6M25wSDHQCNLEIhL85zaeqytf6DfNeNXDsH7Kyi1mO7lTxqlNu2qsq+GQtQnF4MGbk1r/Rg7OY7OvOwOzBoKTJBVZ55ez/BsMKjsdi/lziQrevhuoWB9qtYcI/DRatuakyWVYPxM4AZ565hdqTeRXinjm4IWGY1FsqUtzDwmgyBtbfkN4sPEPe2WkU1MN7RznpeAbzXQf8OYTYA6XkMeFOkoD4RaPAmjHP5XGPg9Aqim1ox+pm7fuMskZonvcT51d6rcyMLXhcFJT/gePCH/57rSJ5pNPMgvZcksFIX2bMn6eBF5+AS7TdlDBOidp7jePjrVeCApwYxeQk9IeCMdCcu/jMc/tuJBoHKM8qW4FjVm98H9h1FUoSGfHQQZuq1+ajjgIfw6xJM9So8nTs8EUL0EjQ0mIA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jane,

Thanks for this series — the conversion to PAGE-granularity indexing is a
nice cleanup.

I came across a Sashiko AI review of this patch series, which flagged
several issues, one of which I was able to confirm triggers a real kernel
crash:

https://sashiko.dev/#/patchset/20260617172534.1740152-1-jane.chu@oracle.com

 > +++ b/mm/hugetlb.c
 > @@ -5952,8 +5955,7 @@ vm_fault_t hugetlb_fault(struct mm_struct *mm, 
struct vm_area_struct *vma,
 >          .address = address & huge_page_mask(h),
 >          .real_address = address,
 >          .flags = flags,
 > -        .pgoff = vma_hugecache_offset(h, vma,
 > -                address & huge_page_mask(h)),
 > +        .pgoff = linear_page_index(vma, address),

This change sets vmf.pgoff to linear_page_index(vma, address), but
`address` here is the raw unaligned fault address, not the huge-page-aligned
address.  Previously, vma_hugecache_offset() used `address & 
huge_page_mask(h)`
which produced a huge-page-aligned index.

When a page fault occurs at a non-huge-page-aligned address within a hugetlb
mapping (e.g., vm_start + 0x1000 for a 2MB page), the resulting pgoff is not
a multiple of pages_per_huge_page (512 for 2MB).  This unaligned index
propagates through:

   hugetlb_fault() → hugetlb_no_page() → hugetlb_add_to_page_cache()
   → __filemap_add_folio()

where this assertion fires (mm/filemap.c:862):

   VM_BUG_ON_FOLIO(index & (folio_nr_pages(folio) - 1), folio);

With CONFIG_DEBUG_VM=y, this becomes a BUG() and panics the kernel.

I was able to reproduce this in a QEMU VM.  The fix should be trivial:
pass the aligned address to linear_page_index().

=== Reproduction ===

Kernel: 7.1.0-rc5-g7ba451f8a24f #1 SMP PREEMPT_DYNAMIC x86_64
Config: CONFIG_HUGETLBFS=y, CONFIG_DEBUG_VM=y, CONFIG_KASAN=y

Trigger: mmap a hugetlbfs file, then access an address at offset 0x1000
(one 4K page) into the mapping, which is unaligned relative to the 2MB
huge page boundary.

=== Full PoC ===

Compile with: gcc -o poc poc.c -static

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <fcntl.h>
#include <errno.h>

#ifndef MAP_HUGETLB
#define MAP_HUGETLB 0x40000
#endif
#ifndef MAP_HUGE_SHIFT
#define MAP_HUGE_SHIFT 26
#endif

/*
  * Bug: hugetlb_fault() sets vmf.pgoff = linear_page_index(vma, address)
  * using the raw unaligned fault address.  This unaligned pgoff reaches
  * __filemap_add_folio() which VM_BUG_ON_FOLIO's on it.
  */

static long get_hugepage_size(void)
{
     FILE *f;
     char line[256];
     long size = 2 * 1024 * 1024;

     f = fopen("/proc/meminfo", "r");
     if (!f)
         return size;
     while (fgets(line, sizeof(line), f)) {
         if (sscanf(line, "Hugepagesize: %ld kB", &size) == 1)
             size *= 1024;
     }
     fclose(f);
     return size;
}

int main(void)
{
     void *addr;
     size_t hpage_size;
     const char *hugetlbfs_path = "/mnt/huge/testfile";
     int fd;
     int ret;

     hpage_size = get_hugepage_size();
     printf("[+] Huge page size: %zu bytes\n", hpage_size);

     /* Mount hugetlbfs */
     mkdir("/mnt/huge", 0755);
     ret = syscall(__NR_mount, "hugetlbfs", "/mnt/huge", "hugetlbfs", 0, 
NULL);
     if (ret < 0 && errno != EBUSY && errno != ENOENT)
         perror("mount hugetlbfs");

     /* Reserve 1 huge page */
     {
         FILE *f = fopen("/proc/sys/vm/nr_hugepages", "w");
         if (f) { fprintf(f, "1"); fclose(f); }
     }

     /* Create hugetlbfs file and mmap it */
     fd = open(hugetlbfs_path, O_CREAT | O_RDWR, 0644);
     if (fd < 0) {
         perror("open hugetlbfs");
         printf("[!] Trying anonymous MAP_HUGETLB\n");
         addr = mmap(NULL, hpage_size, PROT_READ | PROT_WRITE,
                 MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
         if (addr == MAP_FAILED) {
             perror("mmap MAP_HUGETLB");
             return 1;
         }
     } else {
         ftruncate(fd, hpage_size);
         addr = mmap(NULL, hpage_size, PROT_READ | PROT_WRITE,
                 MAP_SHARED, fd, 0);
         close(fd);
         if (addr == MAP_FAILED) {
             perror("mmap hugetlbfs file");
             return 1;
         }
     }
     printf("[+] Mapping at %p\n", addr);

     /*
      * Trigger: access address at offset 0x1000 into the huge page.
      * vm_start is huge-page-aligned, but vm_start + 0x1000 is not.
      * hugetlb_fault() sets vmf.pgoff = linear_page_index(vma, address)
      * with the unaligned address, producing an unaligned pgoff.
      */
     printf("[+] Triggering fault at unaligned offset (%p + 
0x1000)...\n", addr);
     fflush(stdout);
     volatile char *trigger = (volatile char *)addr + 0x1000;
     *trigger = 0x41;

     printf("[+] Survived: value = 0x%02x\n", *trigger);
     return 0;
}

=== Crash Log ===

Linux syzkaller 7.1.0-rc5-g7ba451f8a24f #1 SMP PREEMPT_DYNAMIC x86_64

[  527.288433][ T9873] page dumped because: VM_BUG_ON_FOLIO(index & 
(folio_nr_pages(folio) - 1))
[  527.300642][ T9873] kernel BUG at mm/filemap.c:862!
[  527.301090][ T9873] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
[  527.301640][ T9873] CPU: 0 UID: 0 PID: 9873 Comm: poc Not tainted
[  527.303803][ T9873] RIP: 0010:__filemap_add_folio+0xf39/0x1200
[  527.311913][ T9873] Call Trace:
[  527.312345][ T9873]  <TASK>
[  527.312676][ T9873]  hugetlb_add_to_page_cache+0xe3/0x240
[  527.313414][ T9873]  hugetlb_no_page+0x1301/0x21b0
[  527.314402][ T9873]  hugetlb_fault+0x531/0x1570
[  527.315259][ T9873]  handle_mm_fault+0x970/0xaf0
[  527.316565][ T9873]  do_user_addr_fault+0x60b/0x14c0
[  527.317434][ T9873]  asm_exc_page_fault+0x26/0x30
[  527.318733][ T9873] RIP: 0033:0x401fa2
[  527.326921][ T9873]  <TASK>
[  527.327245][ T9873] RIP: 0010:__filemap_add_folio+0xf39/0x1200
[  527.335300][ T9873] Kernel panic - not syncing: Fatal exception

The Sashiko review also flagged a few other pre-existing issues in
this series that I haven't verified yet:

1. [Critical] remove_inode_hugepages() in patch 9: passing folio->index
    (base-page index) to hugetlb_unmap_file_folio() which multiplies by
    pages_per_huge_page(h), effectively squaring the offset and causing
    the interval tree search to miss VMAs (potential UAF).

2. [High] hugetlbfs_zero_partial_page() in patch 7: Usama already
    pointed out the start >> PAGE_SHIFT question — `start` is a byte
    offset but filemap_lock_folio() expects a page index.

3. [Critical] filemap_get_pages() in patch 4: the `if (is_hugetlbfs)
    goto done` path returns 0 with an empty batch, which could cause
    filemap_read() to loop forever when reading a hole in a hugetlbfs
    file.

Thanks,
Xiao



