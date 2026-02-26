Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBCBFCE087
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 14:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81A0B6B00AE; Thu, 26 Feb 2026 09:18:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C43C6B00AF; Thu, 26 Feb 2026 09:18:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C6F76B00B0; Thu, 26 Feb 2026 09:18:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5ADCD6B00AE
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:18:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1B66F5692D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:18:14 +0000 (UTC)
X-FDA: 84486812508.09.406F4EB
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44D99A0011
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 14:18:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=po36kGLd;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf25.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772115492; a=rsa-sha256;
	cv=none;
	b=XyRCqUjLrNrntI2Ybrdh5uVuBNGZK+WAUynaDlowQfeVV7TU/Th5sTOCIFy3M8pJLdH9Xu
	Ogb4JAp3X/UjG0ByMLlIUcGb9Keo7RLdtFBFLJAIxy4qsAGnMfQ/URhf+XS5mysWGSL28i
	5rKKryDxt2rtSogH1zJxBSvCDsGjPp4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=po36kGLd;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf25.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.169 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772115492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dXXHPkuaOyT/Lkk4V58fFeap91QST2S+bcIMS7/ydUs=;
	b=b1/p5TJWL5wkuG60ASuyLSNbqJx6XCNdGhJYWKHd/affaP0V/DDTERyey/UVynbYNK/Rmp
	g5UIBsZKhxZa3SHmNa7G90XYR9l7sffV6Q6MiGhE8RrcLzmz3V9ddp8McalLAHHdZeWB3Q
	GjfXf3BAFu5UGIdmQ8b0AQLA/EnD3IQ=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2adff872068so3854585ad.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1772115491; x=1772720291; darn=kvack.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dXXHPkuaOyT/Lkk4V58fFeap91QST2S+bcIMS7/ydUs=;
        b=po36kGLdg0hdVIc0TMZOGVC6n7z3lYnloDgmpzkmqkctGqg3yza+Ei1BsATHZ/uSJ/
         SzBBX+5ZAhsMJC61jeUNTMJnbsBZW4H1fdqRpTVtYlbHuYqeqN2gyk7Qb8rED/xA0ND2
         v1TWtLcFjtCCWDGXZVpuN7Lo01WyqPGdUWc+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772115491; x=1772720291;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXXHPkuaOyT/Lkk4V58fFeap91QST2S+bcIMS7/ydUs=;
        b=uEdKiFIfYt0XUqj5YFdjjON4edUlI/dyPDdh/mpRTz2tj21Tz00iy6ZF3QjGz4+AGd
         MvCvb4pwv3pjFXskJKrwVparMqa9Ow7AlpdUCS/+LDEPjH32m1b79AFLpKHO5nyKy4wr
         XA/O0UheD+GCfI1w2MAGH+9LEWNnbq3iBstdr6PalOQDD6sFO//J3gMaDT/IQELlajO2
         hHzgoKlmFsuJLJI1whOpjUYS4MBMoBRuhDVwygd3Vq5x9lTRD3HmRwr/IZrZnVmkGgsA
         +q7CcT7yuPYKJqFHWhViZUeHt6hk1s/s2t6m9pV/qGGukImjrMj6pGP0iXHgjUHeVmxo
         zIcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmj7gMoPMdQUH6uvA6TV7d3hJHh8xgZrKYuZR/GN07YAesMwWFBVtcfUFIdwbh4N4k5+br9JqpZw==@kvack.org
X-Gm-Message-State: AOJu0Yw8w7Q+fd1D2xlNMMaD0GtwkFZEw0XADmRGkeZ2wjcb6hYn3YOL
	0pZ3IUqI/j5649msXsB/p/OdHSsu0BBeLT2jHa6hACLMP2tcW0COguYCjc49yL9Sypw=
X-Gm-Gg: ATEYQzwtoZyPJutkc00aJkx+MMQkTC3rbX1LtH3FTY4Uwd+pF4IQVu9IVGq2Z0W9hgK
	KJNRmPMhcWc3fDmorhE1SHtc5xOXl63SUzUoexbRZw92J3P+RQe/DkBUOVEc575x10ItnHqTrzu
	vDaJPR7lX3FEYqdvRo5xS2CBBTirGSK/Ip9hiYU69DeqXjXGA6PoQQx02iNSuWw3hUlsEvyVwK7
	0vFfb12AjUF4OI16swqIYO2HliQ/0wum1YWYmid1uRnZPqOQ3W1vGznStxnb0QrCcEVI1I6Tboh
	FJ/vIb5v/IUDTHk9Tt3PujNsDIbNDUh6bl3AM4g82dtIcpRH097FW8ETECZTxsJOn88gDwx+Vw2
	YL0ixDHNmUc8+1YkW6Ed1QO727JrF9vojuFpLhkXSrJVM9XZgq8uBel0khPBViKQdaaklR8GASj
	83LKjDPWmJu/1m/2XADg==
X-Received: by 2002:a17:903:1986:b0:2ad:edc4:1796 with SMTP id d9443c01a7336-2adedc422demr36518595ad.39.1772115491093;
        Thu, 26 Feb 2026 06:18:11 -0800 (PST)
Received: from localhost ([154.47.23.70])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5c1fa8sm29415725ad.26.2026.02.26.06.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 06:18:10 -0800 (PST)
Date: Thu, 26 Feb 2026 22:18:03 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] selftests/mm: Add UFFDIO_MOVE huge zeropage PMD
 regression test
Message-ID: <aaBWG4fajXXbjpVN@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.2.15 (2b349c5e) (2025-10-02)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 44D99A0011
X-Stat-Signature: 84udtdepue4ddjqgybs6kksicmakx8rp
X-HE-Tag: 1772115492-878855
X-HE-Meta: U2FsdGVkX19LXr44SPBZVyEGyB3gpdB7Co96KG8fF9LznooJb3Ful+tyQgumtfrSBAnl+uWhyZkoLElanCXhrVvoMuQQlChRfWEVURJDh1uLrLGfkkOmFKVPDTovXEZk4WGC4iDadrqpc7+8JXzpZ1sQurZGYuA61xYyMeNBg4ZJHLhjEYo2Y++XP7nr09y7Ju1CkxFEIqsz0BE1QSe0FGM6LjosxpJwQHYJ4szB6e+ijIiY6G97uwAg9PyBM+kaEuruCAH1z+WxXOFjQgyaBQTGQUYjQUn6kD6jiD/6ZWxjXF5wHEiLxEgUJ8yy+oDvI8V2HusZHGuvvRqe22lDzKTCEEygVJsRMtABm5rVqpIZaCWPd/SU8GxI2dRqtAdn4t4r18+kZqxktdHCU6f3WwSH1SQlaVlbDZhdrf5+zeJrfhBeAwgG9C8Nb3MN2viLp+29ePE81Eh792idI047hc9NVye/Ps3E6gHNC1MlgrX0+szjhEJD0thO3Eb4PjcFcEzm2SnBXHsgQ3Tv1lnH4Lbg+l+wx3m48lfgBtM15z4STv0A8HwuEwIHgVwXEW7CzbCyKfOPzH1MfY76Y7OCHdHKRrVnz7jlqSsNb9CFJ5qLgvP2cXIs6UXjHvP0aek7Sr/mYK/Gp1DVz3LtWrNs2o898pKloxA0devHwO1Yw6TF8dhN1kjJMkK/zORa6nhV2F3dajfVcFzmaS8HVOEAk/KsE2InAG/6nvFJsI/X950hzrM4jFENAYd0oHHl6Te+xzvScFUO823H7CBzafd0s9UPlhEIpqyEIVTjHpwg/9ojL8l7iypZnH4vaeK49nuxwjdzDI+6p4NNDooWusZIZSb9Zy30cYj+M6eDGDvgR7tohDScQ/GSMGTL8101Z6IjzX+vJH5ntzlovs89zKJJV7FAiala3GTRd1JfJyo10Rsk6aiTGCWbBTyi04bTrFjsIqx++SgRv9u4CMOpsT6
 g5GVX1YX
 m6ssX/8OdFzCzI8JAzSyp+KO2rGaeyrQd4pHZFdJIONKJJ5iFeosuRoyJxqxcgmDFnX6h33JGvZ1A4bKYnnW1ecLNn5RqHY6nQigYyCTrZTGvGTXzXIVKoDTv++k62eIFCiIvjJ8/mpaK/06zvBaCGSbV2Gr8JxKJud35kK7EGEc+O8q3qu0jYGuo2/a65dtSXzkrZAXIz+2EqAef2K5v/xGavhLSFRglmnB0nX5DapaUjvWWwU3A+2dBm/queTJzSR+UfyXgIaVJzhmWjEtm+QX2vHrSAKG2cw+V8KnFDgwb+S08VC8uK0RX5eaOB2qv1kiHEUgMjim4ae9lmsDBbyR2E/56Z4IcLFtE7HzVWo/NdiGtm8E1Ry4zqt+SO8flUxQ860SPBPlc9086If6Xe4Bv00SKognaoqCH3fbJsxaMmJi0XP8Ioa5tVMdroNJWvt3fdvJoIdpM6Rw4wNG/qK2dtcvlKpSfBhaJNtlCgD33eDZ6i3K+sJ3trzWUh2l7lzPiKACSfVfAoOw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing uffd-unit-tests move-pmd coverage exercises PMD-sized
UFFDIO_MOVE on anonymous THPs, but it does not force the huge zeropage
PMD path in move_pages_huge_pmd().

Add a dedicated anonymous UFFDIO_MOVE PMD test that exercises this
relatively comprehensively.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 176 +++++++++++++++++++
 1 file changed, 176 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 6f5e404a446c..372619e3906d 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -203,6 +203,62 @@ static int pagemap_open(void)
 	return fd;
 }
 
+static long uffd_pagemap_scan_get_categories_raw(int fd, char *start,
+						 struct page_region *r)
+{
+	struct pm_scan_arg arg = { 0 };
+
+	arg.start = (uintptr_t)start;
+	arg.end = (uintptr_t)(start + psize());
+	arg.vec = (uintptr_t)r;
+	arg.vec_len = 1;
+	arg.flags = 0;
+	arg.size = sizeof(struct pm_scan_arg);
+	arg.max_pages = 0;
+	arg.category_inverted = 0;
+	arg.category_mask = 0;
+	arg.category_anyof_mask = PAGE_IS_WPALLOWED | PAGE_IS_WRITTEN |
+				  PAGE_IS_FILE | PAGE_IS_PRESENT |
+				  PAGE_IS_SWAPPED | PAGE_IS_PFNZERO |
+				  PAGE_IS_HUGE | PAGE_IS_SOFT_DIRTY;
+	arg.return_mask = arg.category_anyof_mask;
+
+	return ioctl(fd, PAGEMAP_SCAN, &arg);
+}
+
+static bool uffd_pagemap_scan_supported(int fd, char *start)
+{
+	static int supported = -1;
+	int ret;
+
+	if (supported != -1)
+		return supported;
+
+	ret = uffd_pagemap_scan_get_categories_raw(fd, start,
+						   (struct page_region *)~0UL);
+	if (ret == 0)
+		err("PAGEMAP_SCAN succeeded unexpectedly");
+
+	supported = errno == EFAULT;
+	return supported;
+}
+
+static bool uffd_pagemap_scan_get_categories(int fd, char *start, uint64_t *categories)
+{
+	struct page_region r = { 0 };
+	long ret;
+
+	if (!uffd_pagemap_scan_supported(fd, start))
+		return false;
+
+	ret = uffd_pagemap_scan_get_categories_raw(fd, start, &r);
+	if (ret < 0)
+		err("PAGEMAP_SCAN failed: %s", strerror(errno));
+
+	*categories = ret ? r.categories : 0;
+	return true;
+}
+
 /* This macro let __LINE__ works in err() */
 #define  pagemap_check_wp(value, wp) do {				\
 		if (!!(value & PM_UFFD_WP) != wp)			\
@@ -1227,6 +1283,119 @@ static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t
 			      uffd_move_pmd_handle_fault);
 }
 
+static void uffd_move_pmd_huge_zeropage_test(uffd_global_test_opts_t *gopts,
+					     uffd_test_args_t *targs)
+{
+	unsigned long pmd_size = read_pmd_pagesize();
+	unsigned long pmd_pages;
+	unsigned long bytes = gopts->nr_pages * gopts->page_size;
+	char *orig_area_src = gopts->area_src, *orig_area_dst = gopts->area_dst;
+	char *aligned_src, *aligned_dst;
+	unsigned long src_offs, dst_offs, max_offs;
+	pthread_t uffd_mon;
+	struct uffd_args args = { 0 };
+	char c = '\0';
+	int pagemap_fd;
+	uint64_t categories;
+	unsigned long i;
+
+	if (pmd_size <= gopts->page_size) {
+		uffd_test_skip("huge page size is 0, feature missing?");
+		return;
+	}
+	if (!detect_huge_zeropage()) {
+		uffd_test_skip("transparent huge zeropage disabled");
+		return;
+	}
+
+	pmd_pages = pmd_size / gopts->page_size;
+	if (bytes < pmd_size) {
+		uffd_test_skip("not enough pages for one PMD-sized move");
+		return;
+	}
+
+	aligned_src = ALIGN_UP(orig_area_src, pmd_size);
+	aligned_dst = ALIGN_UP(orig_area_dst, pmd_size);
+	src_offs = (aligned_src - orig_area_src) / gopts->page_size;
+	dst_offs = (aligned_dst - orig_area_dst) / gopts->page_size;
+	max_offs = src_offs > dst_offs ? src_offs : dst_offs;
+	if (max_offs + pmd_pages > gopts->nr_pages) {
+		uffd_test_skip("could not find aligned PMD-sized src/dst window");
+		return;
+	}
+
+	if (madvise(orig_area_dst, bytes, MADV_HUGEPAGE))
+		err("madvise(MADV_HUGEPAGE) failure");
+	if (madvise(orig_area_src, bytes, MADV_DONTFORK))
+		err("madvise(MADV_DONTFORK) failure");
+	if (madvise(aligned_src, pmd_size, MADV_DONTNEED))
+		err("madvise(MADV_DONTNEED) failure");
+
+	/* Materialise a PMD-sized huge zeropage mapping in the source. */
+	force_read_pages(aligned_src, pmd_pages, gopts->page_size);
+
+	pagemap_fd = pagemap_open();
+	if (!uffd_pagemap_scan_get_categories(pagemap_fd, aligned_src, &categories)) {
+		close(pagemap_fd);
+		uffd_test_skip("PAGEMAP_SCAN unsupported");
+		return;
+	}
+	if ((categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) !=
+	    (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) {
+		close(pagemap_fd);
+		uffd_test_skip("could not materialise a huge zeropage PMD mapping");
+		return;
+	}
+	gopts->area_src = aligned_src;
+	gopts->area_dst = aligned_dst;
+
+	if (uffd_register(gopts->uffd, gopts->area_dst, pmd_size, true, false, false))
+		err("register failure");
+
+	args.gopts = gopts;
+	args.handle_fault = uffd_move_pmd_handle_fault;
+	if (pthread_create(&uffd_mon, NULL, uffd_poll_thread, &args))
+		err("uffd_poll_thread create");
+
+	/*
+	 * One fault on dst should trigger a single PMD-sized UFFDIO_MOVE from
+	 * the huge zeropage PMD we populated in the source.
+	 */
+	force_read_pages(gopts->area_dst, pmd_pages, gopts->page_size);
+
+	if (write(gopts->pipefd[1], &c, sizeof(c)) != sizeof(c))
+		err("pipe write");
+	if (pthread_join(uffd_mon, NULL))
+		err("join() failed");
+
+	if (args.missing_faults != 1 || args.minor_faults != 0) {
+		uffd_test_fail("stats check error");
+	} else if (!uffd_pagemap_scan_get_categories(pagemap_fd, gopts->area_dst,
+						     &categories)) {
+		uffd_test_fail("PAGEMAP_SCAN unsupported");
+	} else if ((categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO |
+				  PAGE_IS_HUGE)) !=
+			(PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) {
+		uffd_test_fail("moved destination is not a huge zeropage PMD");
+	} else if (!check_huge_anon(gopts->area_dst, 0, pmd_size)) {
+		/* vm_normal_page_pmd() must continue to treat the moved PMD as special. */
+		uffd_test_fail("moved huge zeropage PMD counted as AnonHugePages");
+	} else {
+		for (i = 0; i < pmd_size; i++) {
+			if (gopts->area_dst[i]) {
+				uffd_test_fail("moved huge zeropage PMD data is not zero");
+				goto out_restore;
+			}
+		}
+		uffd_test_pass();
+	}
+
+out_restore:
+	gopts->area_src = orig_area_src;
+	gopts->area_dst = orig_area_dst;
+	close(pagemap_fd);
+}
+
 static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
@@ -1550,6 +1719,13 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required = UFFD_FEATURE_MOVE,
 		.test_case_ops = &uffd_move_test_pmd_case_ops,
 	},
+	{
+		.name = "move-pmd-huge-zeropage",
+		.uffd_fn = uffd_move_pmd_huge_zeropage_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE,
+		.test_case_ops = &uffd_move_test_pmd_case_ops,
+	},
 	{
 		.name = "move-pmd-split",
 		.uffd_fn = uffd_move_pmd_split_test,
-- 
2.51.2


