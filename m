Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D29CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 09:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A247390011E; Thu, 14 Aug 2025 05:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D496900088; Thu, 14 Aug 2025 05:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA7490011E; Thu, 14 Aug 2025 05:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD63900088
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 05:16:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0230D1177F9
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:16:51 +0000 (UTC)
X-FDA: 83774808264.24.3876D7F
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id E502680009
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:16:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CIBQYbD1;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755163010;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=maL8ja7snbyxSg/aB0udz/2XPVl8dYyS2NvjcHhRBsU=;
	b=q00JzzcrbVgWsEp5c5JQ8j3kP69U+5tf9PyGBjfzh4jOkGfnPHssd4einZaDlOOLgYPwGB
	m/QBY4r1NZmxVxJV171T5+JDjzTuZAQX1WprcN0sfScxDmdVp9OfDG2/ykqEtVF2dwAd20
	8njd0g+P2596GHmYQokUFLK3C3SAspk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=CIBQYbD1;
	spf=pass (imf02.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755163010; a=rsa-sha256;
	cv=none;
	b=TYtPOLNoyZr4rUD4MXz95EgK5l61GVZGb8F7VUKoTL5h9zl3xS9iQ4upBkNO0GTlRyd244
	EjZP81X1VucCx6M0QRN58IVejyAxvaMs3IIQA8zyZqTsFZn6XeR6P6027yPQDR35bjrIlV
	ldaXVXR+UjZ25NZeV/hx57NqQ5PB/sI=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6188b70abdfso994256a12.2
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 02:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755163008; x=1755767808; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=maL8ja7snbyxSg/aB0udz/2XPVl8dYyS2NvjcHhRBsU=;
        b=CIBQYbD1uQspsNpbjmuzbPjD2YqjncUK1zMFTSBF3jsK/eoC6nImOZh0ymWEO2n6KX
         sQXFTPXOjwlYFbJSstpHM+LtDzOvxEUQvcUpcCa9UZmcPU/NDsFNOlfiP4jOl8ydhrco
         05xbnU2ao7UC+oF1ARtxSLmSXuBvvraaqtIj5gzweuEOk/QG5Az74sLPzlIKC7YwMshn
         JKE/0Zksu1SoQcM+StsHXaWWh+dorUamKDKTIjo2vkTNeOXvmN/a21qanS+yRe8khNxf
         8FUnsfocySlXwDQoYBYReS046af67lFWrrFFoeGVMrybhW8N+GpwqW3+USzp50VovnbE
         bvoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755163008; x=1755767808;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=maL8ja7snbyxSg/aB0udz/2XPVl8dYyS2NvjcHhRBsU=;
        b=DGS+j5mASEGIAOz4WU1m+xVWhieXD3Jb0MwAjaM+IvlIlzJuKqCW4xLXvQyFeo54cd
         nXrh18BtldMM0iSQTKy+5DqFBZWkxYr8nEhxB9Xhr+vnUihfsZ83alBPBYFrjVKKOBWO
         Tem4BQZy6oZf+tTHBT72FRxgtPNl7iqIrVYIIkhUtEAdcZ5E/K3m0qlBbewjXVcMTLem
         pMVHH/IO5jxDSn3iyfY1K0YrL98XwwIE40mtP5AW2wjQkQPmFuZjLTwvvxDL4td0EuO0
         b4JBYk4s+C4+QJttnU8z0zIUdegmQ8/v9q2WKDOgL99J6IV95eKJHqyrkGTujs+uaplx
         JJvA==
X-Forwarded-Encrypted: i=1; AJvYcCVZzeJAOu2g72PmQbFnsxMUShEZuRxf1tBlzfyU01uLeDYiqiuGSst2c0WYgCtfGRN4+xdcgj1Xqg==@kvack.org
X-Gm-Message-State: AOJu0YzInc/b/oIz8TBxYiv+kpNFVRsWvLc2tgX/20sGOGi7jRh5htjQ
	dA2hZdzMDXNQCmB418oAQwm+XER9yN7Q4DldEvxeGf45norbKwS1fNLv
X-Gm-Gg: ASbGncsxaUlil+okN8RJlsxu6FrQyhPIl47CKdCV2/drBxbL3t1uepuzSxhjC3QQlMr
	JANBBpeui3/eUrNWOL9/noT2wl8DrSfapLwgAQL1RyGcDnsw6NzS32giFdEMGmllp8nCVkcS3bL
	LcuVrx/8uCakWIwTttQpvWcvmlMcyuR/84qLYKmXYv8tXuctTECxtaJOKlRLHpMPaVnWhJ9VlKb
	OS3lpiJ6qTSs0loRw8KK9fjgczX9a3ZqNhRPTP9brTlOEaXXJqDCi42K5KVcHGf1GDr1thZYTgh
	oXIMyfDA9ZtvLkJskM3BmoYXf/sGS/4Qqwyp4y5DzTScnT0Jqi2ASXhKNE6ra6QGWOm50LWDXZU
	jNSUFKCZxzvR14uYptKhV5A==
X-Google-Smtp-Source: AGHT+IE13oXUtnMs/Hs8gStTap5qVhOyy5FFDOfkTObdSMHP/qfsbCsjE7ChNeDnKH/AZiw3TDdy+Q==
X-Received: by 2002:a05:6402:90c:b0:618:2011:cad4 with SMTP id 4fb4d7f45d1cf-6188b92f8camr2177926a12.15.1755163007905;
        Thu, 14 Aug 2025 02:16:47 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-615a8f245c1sm23289384a12.22.2025.08.14.02.16.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Aug 2025 02:16:47 -0700 (PDT)
Date: Thu, 14 Aug 2025 09:16:47 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>, g@master.kvack.org
Cc: Wei Yang <richard.weiyang@gmail.com>, wang lian <lianux.mm@gmail.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 4/4] selftests/mm: check after-split folio orders in
 split_huge_page_test.
Message-ID: <20250814091647.6prozsywma7qlugm@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250812155512.926011-1-ziy@nvidia.com>
 <20250812155512.926011-5-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250812155512.926011-5-ziy@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Queue-Id: E502680009
X-Rspamd-Server: rspam06
X-Stat-Signature: srs31w67xgaprb7fup7ssui3xqf3jzdh
X-HE-Tag: 1755163009-273031
X-HE-Meta: U2FsdGVkX18t4+KALXf0kJrTa6mTK4QmItosh4uvtwNgyHd7dv6Aeds7kcMwnt4fVEOnBJUOxoZc57bYHYyuxvXaUsj2Lj3ji+LZDrp0M5fl/ujSADU8iK2MnIfaTFa2FEciMYwMallGLHQkFdetybhU/716kKyXCPr7kF9J2TMNaXoVkUv9Sx2xQ5fInOBd1ritipCOzigb+ikUz+7wyIvXpuwj4pmtwfYDSSyyuOyDkVVQMHYs/6L5U02EOBrmOyDgzsyWXKZK4qqkDAxAqGaX2WoUQPN4juTn2k8koZs6CBgA3s20tSMzpwWRp0u6VxFpimzogsb4H2oMylOCIQnQF+/76CXjqmvXqihICnMC2a7XyA+tiFx2zAICD1XlgSNVsxCFsDLRspkUn5Fxb3uq/pG+GLEtJ+hC2o2sIv5fcWnwblvKPYgFedJrW6kTkvx6gm2CNzxZsvbolO+Cm2wt47VWdrwxa4k49cxOR4AE02U9uSmcCxLg2FTXWBO7fZ5oANN+h5WnzdYUE6POU6ElB15J9MrD2lX3GVYD2zcJ6fNEuJd35XW4v3GxHPIBsnbSQ3xovR4NwIAHjJpwL7jOAga0l6XvmrobfgI4fkr2Gf9m+1kMazNWRzKEbx1Cwu/vhICrqqmUjq/aw6ZG364avCFg9ZXx3x+NS44xklKG/dgfBPAn/LQrhmorimDfYVes5h/ZqBC927pahx60mZtrOz4JSz3RY86KL0KcQ9PW2dVV5s8+c7t5xjK+oudKQ13Y+vxD5INibSydNCPTylcIysGrcgdu2RF5Km8zLZcQRXX0Hxv5jxbtmzeI/Nx0RiSajrymqlqcObgZvpRWj8PQvzo78AIcduJtGkwD2fj0p7UcbEU3AhysuFjSdRkzVd0q1kCzGE0c2t6yj7GIlD9izn7m75AMSZcFd2dNpL94DbMb/ERcqi0dpOXMbj2kwuQEOwEwp2bxG+LQu9B
 gy9Yr5ll
 gySbBdP5eBKWlb+pJBSlpYj8hP5Zw512CReHhP6v+NQFz9NFd87ILOHT8BEc/KN9U1f7c2yYua0Pzwjso8HFEz2EFdD613MU9zdhbcJKgTxWWGDaW4iS9jWUwBRVKwj/+aGk6OlNMufeO2GW5AOE8rQ1KKYzcE3wqbK9826rp3d8rIaznO9jGlP9hBt5m3PCSZHTKuDvHsPP9LYLrKE3UMGL7Fl51X9KU5jiQ4QYrEFjfAGSv03J13nWgAB+m4C/K7EkNk6Ny7Y699ZE7QzbqTykiBWoL45ASuUi2uHY1hVQAHNGyxG1Pxb7Rek86UoyUWa5pEznqRyYodmlFoffcmVTiaN7O99wfPCqXbKtzcux4XSuAWaOcEwPg1ltqtw5h8VOCxIJRSFfBal4GBDPzxdWfm20HGgZrxspOxyTzMmX/8XNv2F/4ObGYMXelV8Vhp07e0zqEXpk+KECQiReB2WpbNV8eExle6DG4tho3FOtyLc/HGfp9qwLJhGB8T0X89QD3eiG/O2LcJSGpj9IO+U0bN7/GSpUQDNKcC1MLMRnoKhKuXSX2U+/naj7Yt6HaE53qQGkKQUrVoy8ivbxx53GZ4yAyG8FnhxvW5zZ2SvpWZjfeU7fqZmANTb1xLOYndk562FS8SKddpCOKnLK1wH1BfPrCvdFDjPoXEnmXzseh3QeBwaaR20jAOYwZ2ix0ei5KpnzFdH1vcWZpmpuICoLpw52zc255xHFam8EJtK5gvvnIZaOytCXZQnnpXTaSGsVnIK2xCl655dZntPyUH1Ifxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 12, 2025 at 11:55:12AM -0400, Zi Yan wrote:
>Instead of just checking the existence of PMD folios before and after folio
>split tests, use check_folio_orders() to check after-split folio orders.
>
>The following tests are not changed:
>1. split_pte_mapped_thp: the test already uses kpageflags to check;
>2. split_file_backed_thp: no vaddr available.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>---
> .../selftests/mm/split_huge_page_test.c       | 85 +++++++++++++------
> 1 file changed, 61 insertions(+), 24 deletions(-)
>
>diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>index 3aaf783f339f..1ea2c7f22962 100644
>--- a/tools/testing/selftests/mm/split_huge_page_test.c
>+++ b/tools/testing/selftests/mm/split_huge_page_test.c
>@@ -26,6 +26,7 @@ uint64_t pagesize;
> unsigned int pageshift;
> uint64_t pmd_pagesize;
> unsigned int pmd_order;
>+int *expected_orders;
> 
> #define SPLIT_DEBUGFS "/sys/kernel/debug/split_huge_pages"
> #define SMAP_PATH "/proc/self/smaps"
>@@ -37,6 +38,11 @@ unsigned int pmd_order;
> 
> #define GET_ORDER(nr_pages)    (31 - __builtin_clz(nr_pages))
> 
>+const char *pagemap_proc = "/proc/self/pagemap";
>+const char *kpageflags_proc = "/proc/kpageflags";
>+int pagemap_fd;
>+int kpageflags_fd;
>+
> int is_backed_by_folio(char *vaddr, int order, int pagemap_fd, int kpageflags_fd)
> {
> 	unsigned long pfn_head;
>@@ -49,18 +55,21 @@ int is_backed_by_folio(char *vaddr, int order, int pagemap_fd, int kpageflags_fd
> 
> 	pfn = pagemap_get_pfn(pagemap_fd, vaddr);
> 
>+	/* non present page */
> 	if (pfn == -1UL)
> 		return 0;
> 
> 	if (get_pfn_flags(pfn, kpageflags_fd, &pfn_flags))
> 		return 0;
> 
>+	/* check for order-0 pages */
> 	if (!order) {
> 		if (pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD | KPF_COMPOUND_TAIL))
> 			return 0;
> 		return 1;
> 	}
> 
>+	/* non THP folio */
> 	if (!(pfn_flags & KPF_THP))
> 		return 0;
> 
>@@ -69,9 +78,11 @@ int is_backed_by_folio(char *vaddr, int order, int pagemap_fd, int kpageflags_fd
> 	if (get_pfn_flags(pfn_head, kpageflags_fd, &pfn_flags))
> 		return 0;
> 
>+	/* head PFN has no compound_head flag set */
> 	if (!(pfn_flags & (KPF_THP | KPF_COMPOUND_HEAD)))
> 		return 0;
> 
>+	/* check all tail PFN flags */
> 	for (i = 1; i < (1UL << order) - 1; i++) {
> 		if (get_pfn_flags(pfn_head + i, kpageflags_fd, &pfn_flags))
> 			return 0;

The comment in is_backed_by_folio() is more proper to be in previous patch?

>@@ -198,6 +209,12 @@ void split_pmd_thp_to_order(int order)
> 		if (one_page[i] != (char)i)
> 			ksft_exit_fail_msg("%ld byte corrupted\n", i);
> 
>+	memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));
>+	expected_orders[order] = 4 << (pmd_order - order);
>+
>+	if (check_folio_orders(one_page, len, pagemap_fd, kpageflags_fd,
>+			       expected_orders, (pmd_order + 1)))
>+		ksft_exit_fail_msg("Unexpected THP split\n");
> 
> 	if (!check_huge_anon(one_page, 0, pmd_pagesize))
> 		ksft_exit_fail_msg("Still AnonHugePages not split\n");
>@@ -212,22 +229,6 @@ void split_pte_mapped_thp(void)
> 	size_t len = 4 * pmd_pagesize;
> 	uint64_t thp_size;
> 	size_t i;
>-	const char *pagemap_template = "/proc/%d/pagemap";
>-	const char *kpageflags_proc = "/proc/kpageflags";
>-	char pagemap_proc[255];
>-	int pagemap_fd;
>-	int kpageflags_fd;
>-
>-	if (snprintf(pagemap_proc, 255, pagemap_template, getpid()) < 0)
>-		ksft_exit_fail_msg("get pagemap proc error: %s\n", strerror(errno));
>-
>-	pagemap_fd = open(pagemap_proc, O_RDONLY);
>-	if (pagemap_fd == -1)
>-		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
>-
>-	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
>-	if (kpageflags_fd == -1)
>-		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
> 
> 	one_page = mmap((void *)(1UL << 30), len, PROT_READ | PROT_WRITE,
> 			MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
>@@ -285,8 +286,6 @@ void split_pte_mapped_thp(void)
> 
> 	ksft_test_result_pass("Split PTE-mapped huge pages successful\n");
> 	munmap(one_page, len);
>-	close(pagemap_fd);
>-	close(kpageflags_fd);
> }
> 
> void split_file_backed_thp(int order)
>@@ -489,6 +488,7 @@ void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
> 		int order, int offset)
> {
> 	int fd;
>+	char *split_addr;
> 	char *addr;
> 	size_t i;
> 	char testfile[INPUT_MAX];
>@@ -502,14 +502,27 @@ void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
> 	err = create_pagecache_thp_and_fd(testfile, fd_size, &fd, &addr);
> 	if (err)
> 		return;
>+
> 	err = 0;
> 
>-	if (offset == -1)
>-		write_debugfs(PID_FMT, getpid(), (uint64_t)addr,
>-			      (uint64_t)addr + fd_size, order);
>-	else
>-		write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)addr,
>-			      (uint64_t)addr + fd_size, order, offset);
>+	memset(expected_orders, 0, sizeof(int) * (pmd_order + 1));

I am not familiar with split, you change it to split on each pmd_pagesize from
4 pmd_pagesize. Is there any difference?

>+	if (offset == -1) {
>+		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
>+			write_debugfs(PID_FMT, getpid(), (uint64_t)split_addr,
>+				      (uint64_t)split_addr + pagesize, order);

                                                ^--- here should be vaddr_end

Curious why not (uint64_t)split_addr + pmd_pagesize?

>+
>+		expected_orders[order] = fd_size / (pagesize << order);
>+	} else {
>+		int times = fd_size / pmd_pagesize;
>+
>+		for (split_addr = addr; split_addr < addr + fd_size; split_addr += pmd_pagesize)
>+			write_debugfs(PID_FMT_OFFSET, getpid(), (uint64_t)split_addr,
>+				      (uint64_t)split_addr + pagesize, order, offset);

As above.

>+
>+		for (i = order + 1; i < pmd_order; i++)
>+			expected_orders[i] = times;
>+		expected_orders[order] = 2 * times;
>+	}
> 
> 	for (i = 0; i < fd_size; i++)
> 		if (*(addr + i) != (char)i) {
>@@ -518,6 +531,13 @@ void split_thp_in_pagecache_to_order_at(size_t fd_size, const char *fs_loc,
> 			goto out;
> 		}
> 
>+	if (check_folio_orders(addr, fd_size, pagemap_fd, kpageflags_fd,
>+			       expected_orders, (pmd_order + 1))) {
>+		ksft_print_msg("Unexpected THP split\n");
>+		err = 1;
>+		goto out;
>+	}
>+
> 	if (!check_huge_file(addr, 0, pmd_pagesize)) {
> 		ksft_print_msg("Still FilePmdMapped not split\n");
> 		err = EXIT_FAILURE;
>@@ -569,9 +589,22 @@ int main(int argc, char **argv)
> 
> 	nr_pages = pmd_pagesize / pagesize;
> 	pmd_order = GET_ORDER(nr_pages);
>+
>+	expected_orders = (int *)malloc(sizeof(int) * (pmd_order + 1));
>+	if (!expected_orders)
>+		ksft_exit_fail_msg("Fail to allocate memory: %s\n", strerror(errno));
>+
> 	tests = 2 + (pmd_order - 1) + (2 * pmd_order) + (pmd_order - 1) * 4 + 2;
> 	ksft_set_plan(tests);
> 
>+	pagemap_fd = open(pagemap_proc, O_RDONLY);
>+	if (pagemap_fd == -1)
>+		ksft_exit_fail_msg("read pagemap: %s\n", strerror(errno));
>+
>+	kpageflags_fd = open(kpageflags_proc, O_RDONLY);
>+	if (kpageflags_fd == -1)
>+		ksft_exit_fail_msg("read kpageflags: %s\n", strerror(errno));
>+
> 	fd_size = 2 * pmd_pagesize;
> 
> 	split_pmd_zero_pages();
>@@ -596,6 +629,10 @@ int main(int argc, char **argv)
> 			split_thp_in_pagecache_to_order_at(fd_size, fs_loc, i, offset);
> 	cleanup_thp_fs(fs_loc, created_tmp);
> 
>+	close(pagemap_fd);
>+	close(kpageflags_fd);
>+	free(expected_orders);
>+
> 	ksft_finished();
> 
> 	return 0;
>-- 
>2.47.2

-- 
Wei Yang
Help you, Help me

