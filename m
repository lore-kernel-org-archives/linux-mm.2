Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E109CCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 06:17:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C15786B008A; Wed, 14 Oct 2026 02:17:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECD36B0092; Wed, 14 Oct 2026 02:17:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B02DC6B0096; Wed, 14 Oct 2026 02:17:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 544FE6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:17:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C9BAF16045E
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:17:11 +0000 (UTC)
X-FDA: 85320224262.06.2E716DB
Received: from va-1-112.ptr.blmpb.com (va-1-112.ptr.blmpb.com [209.127.230.112])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8F167100004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:17:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EU2qgfXX;
	spf=pass (imf05.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791958630;
	b=a9wLk9G/qsPYOqjF3MmtVlih1fkvXacdmsbpu/6741wewkfJJeD035YAtfLXTc+1hR6/9z
	jEEup0kHow7kkzJZg+4hX79SqhOVuqxu+dacsAUj2eluPqZk/Gn5Xk0blh+x1eKi32XMcn
	mZpJA8BZkij27HS7YDaP693ano6N1zY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=EU2qgfXX;
	spf=pass (imf05.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.112 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791958630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUTyn0Rq67njZaj55ehmyaxuhFuRO8R3sEs8oQB0l2k=;
	b=mNsINkwF3GpV2CvGs/PJg56yaEcKCyAAV+3YYTJUmnayIDQ7zy2nhi/3gBQLq9PwrcgyTo
	k4KFamvgyQTZitdVu3QeKURcPPQj4ZKESTDCJr6B3hNagiIX10t/VD8q9J+S2grcFhjaVE
	en4StGXRO/Jch7N5YBxlgEs5kBEMs44=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791958621; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=XUTyn0Rq67njZaj55ehmyaxuhFuRO8R3sEs8oQB0l2k=;
 b=EU2qgfXX0wf5f0pu4zP9tupA6E/sHVifia7MxsYY11jEgYynNYMGwko+u4trx7ByIZnSOP
 pVhtc5weRGd7ZAKIoOgC/hCeYGDEUFmT4Sv/rkszmEL9yvlNODPTLqUg4MCNUAw69nDBn5
 OpMnhK1wVxHhcS33UV0oMjlZ5igBt0TNefEEoPm+M8FnaJ1aT6KFKEeN8Uv/64Lny9yCId
 +qqcWbx8aiCFlDddTMyjf2o+swqecx2rr2zUSY7JiyhCqZcpjydJZkLoskWh1QYpveS3z7
 qxCHkWYe08w3xPcBkGdpqFG/wq54bD97so2gZrMPa5y27YK40iqaoyuvbuH2SA==
Cc: <ryan.roberts@arm.com>, <baolin.wang@linux.alibaba.com>, 
	<lance.yang@linux.dev>, <mark.rutland@arm.com>, 
	<akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>, 
	<surenb@google.com>, <mhocko@suse.com>, 
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Message-Id: <24f01ac6-4935-4702-b6e8-52beff5feea0@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
User-Agent: Mozilla Thunderbird
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Content-Type: text/plain; charset=UTF-8
References: <20261013093600.54995-1-zhaogongyi@bytedance.com> <6a10b61f-5c4f-4d04-9742-97a358147c39@arm.com>
To: "Dev Jain" <dev.jain@arm.com>, <catalin.marinas@arm.com>, 
	<will@kernel.org>
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid PTEs
Content-Transfer-Encoding: 7bit
Date: Wed, 14 Oct 2026 14:16:33 +0800
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26acf1e5b+e7369d+kvack.org+zhaogongyi@bytedance.com>
In-Reply-To: <6a10b61f-5c4f-4d04-9742-97a358147c39@arm.com>
X-Stat-Signature: 7e5cwn7kh8fxy576drs3664p7u8zqgiz
X-Rspamd-Queue-Id: 8F167100004
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791958628-453207
X-HE-Meta: U2FsdGVkX1+iIktQXktUY27QMNVDVK8XjuljT5t/e3ddGJ55XGgF0BkI/BtoIcaW8uHzPaX86T4qjepf0oOD3cSYLWKARwItokoyMKG0//0QhxRdkgrYbTXKnEkTS7TLBA9ptLs4ZHxuNTHIj9DQwGSEFK5H5H6CvSK5CZ7jEyGUMs3KsfHWDlosGEq4dOmowXSknmIDAtTEOA39MUOZ0JcNUwBg4Ve4ReuVrM+mtDKAVymEXJQmNcDKPMhnJzdACzL5qCQjcGIJytubGEzxkdtYb/0FZfBeufKHpb98MCfDujntkFIl73KgdUE7FqFhbdNXSV8RHJJ3Ev+9Kfd4Ys+el/oSDVrO71bdTCc9qVTGRxp8mnNwu/drcKgHceQOtv0F67apetCsjkNCm8du1IgDAPV8c+LAagr4gC7W4V5/vrOPB5TD7w8g0yH3LI1YOrhlid7cHzX/k9wcKpNvZbqOZz+NZg66Srgsm3tMX7l5m33pjwItPMqhmGTmMnYTfMlPxPCHaUmZeLHMrumK6dlxAaSb/1tQWzcSy2r+7D9yY6n+oLi0NmytaPelKygpl8QiPagaEKBlYl+YAuStOwB0mX3n6KUX1Tuv2BXC57PMVVWhqof+/ZJMd7cIm0dhZmt0J+ixycIZSBiOUBWTsctQZc15M/zAXsG4hMZ1o0uz6m+L3E/3wmKNPlFQF0aMciD1EI77o4sNbK9Ozx0puPhFOo4Xz0thUVbYeM6yDPYtdWWLv1s+OBLK7GXOThv9I6XIlUfVRTQT2rgu0nWpxGu2NbYIbWCMyJa8O0r8OW2VffwC2u1nTtU5frsTG1D3IrOdI5PCov/bchpU8pw3QrHfwLAzd5ikdhGXg5NLp/yTAY1/lr8avHNocLBDkbqPyPUHM3CyJnzhSJcMf52O1be/EjA4Tsn2ort95lGQgHzfU0yEG8f5iIv30zqdavW+6GpTr31TT5464BcURBh
 CfYRfE5y
 6zhleM1oTEFqENzZu84xv1wPTDCwZhuCxiRX4L/rqb2xi3oZ3KR/RBImjAD8Pxk5ouWbYYtIwvn5t3qhoP8RJDii7Kkn/BK+xIFpO3Suf+Ov5J8teIb0bVv8Lf4J3uRwDUASs15tFH8HsNU5ypUc1JhsYvL4X2XJL0yO+40b6neJdYZSnf2TflC1qs10Y/n4hzdLAYUC08mqzBvfHSrRS80lFHyD3iCLage+/Hw6vkYsAW12FHyDuZ+NosTr1VNus1niYWIJa8tl3FQHx5ltxwQFc/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/10/13 18:13, Dev Jain wrote:
> 
> 
> Thanks, could you please give the code of the reproducer. That will
> save us some time.
> 
> 

Hi Dev,

Sure, sorry for not including it in the first mail.

The standalone reproducer I used is below. It assumes an arm64 kernel 
with CONFIG_ARM64_CONTPTE=y and a CONT_PTE_SIZE anonymous mTHP order 
available. When run as root, it tries to enable THP and the matching 
mTHP order through sysfs. These sysfs writes are best-effort; if the 
matching order is not available or cannot be enabled, the reproducer
may not hit the issue.

On a 4K-page kernel, CONT_PTE_SIZE is 64KB.

Compile and run:

       gcc -O2 -Wall contpte_guard_repro.c -o contpte_guard_repro
       ./contpte_guard_repro 100

On my unfixed KASAN kernel with panic_on_warn=1, the first iteration hit
the bad swap entry / swap_put_entries_direct() warning. With this patch,
100 iterations completed without warnings.

Here is the reproducer:

   #define _GNU_SOURCE
   #include <errno.h>
   #include <fcntl.h>
   #include <stdio.h>
   #include <stdlib.h>
   #include <string.h>
   #include <sys/mman.h>
   #include <unistd.h>

   #ifndef MADV_HUGEPAGE
   #define MADV_HUGEPAGE 14
   #endif
   #ifndef MADV_POPULATE_WRITE
   #define MADV_POPULATE_WRITE 23
   #endif
   #ifndef MADV_GUARD_INSTALL
   #define MADV_GUARD_INSTALL 102
   #endif
   #ifndef MADV_GUARD_REMOVE
   #define MADV_GUARD_REMOVE 103
   #endif

   static void write_file(const char *path, const char *val)
   {
       int fd = open(path, O_WRONLY | O_CLOEXEC);

       if (fd < 0)
           return;
       (void)write(fd, val, strlen(val));
       close(fd);
   }

   static void write_clear_refs(void)
   {
       int fd = open("/proc/self/clear_refs", O_WRONLY | O_CLOEXEC);

       if (fd < 0) {
           perror("open clear_refs");
           exit(1);
       }
       if (write(fd, "1", 1) != 1) {
           perror("write clear_refs");
           exit(1);
       }
       close(fd);
   }

   static unsigned long contpte_size(unsigned long page_size)
   {
       if (page_size == 4096)
           return 64 * 1024;
       if (page_size == 16384 || page_size == 65536)
           return 2 * 1024 * 1024;

       fprintf(stderr, "unsupported page size %lu\n", page_size);
       exit(1);
   }

   static void enable_mthp(unsigned long size)
   {
       char path[256];

       write_file("/sys/kernel/mm/transparent_hugepage/enabled", 
"always\n");
       write_file("/sys/kernel/mm/transparent_hugepage/defrag", "always\n");

       snprintf(path, sizeof(path),
            "/sys/kernel/mm/transparent_hugepage/hugepages-%lukB/enabled",
            size / 1024);
       write_file(path, "always\n");
   }

   static void touch_range(char *p, unsigned long len, unsigned long 
page_size)
   {
       for (unsigned long off = 0; off < len; off += page_size)
           p[off] = (char)off;
   }

   int main(int argc, char **argv)
   {
       const int loops = argc > 1 ? atoi(argv[1]) : 1;
       const unsigned long page_size = sysconf(_SC_PAGESIZE);
       const unsigned long csize = contpte_size(page_size);
       const unsigned long nr_pages = 2 * csize / page_size;
       const unsigned long len = nr_pages * page_size;
       const unsigned long map_len = len + csize;
       const unsigned long guard_idx = csize / page_size - 3;

       enable_mthp(csize);

       for (int i = 0; i < loops; i++) {
           char *map, *p;

           map = mmap(NULL, map_len, PROT_READ | PROT_WRITE,
                  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
           if (map == MAP_FAILED) {
               perror("mmap");
               return 1;
           }

           p = (char *)(((unsigned long)map + csize - 1) & ~(csize - 1));

           if (madvise(p, len, MADV_HUGEPAGE))
               perror("madvise MADV_HUGEPAGE");
           if (madvise(p, len, MADV_POPULATE_WRITE))
               perror("madvise MADV_POPULATE_WRITE");

           touch_range(p, len, page_size);

           if (mprotect(p, len, PROT_NONE)) {
               perror("mprotect PROT_NONE");
               return 1;
           }
           if (madvise(p + guard_idx * page_size, page_size,
                   MADV_GUARD_INSTALL)) {
               perror("madvise MADV_GUARD_INSTALL");
               return 1;
           }

           write_clear_refs();

           if (munmap(map, map_len)) {
               perror("munmap");
               return 1;
           }
       }

       return 0;
   }


Thanks,
Zhao

