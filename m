Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0753FCD0A7
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 04:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382776B00E3; Wed, 18 Mar 2026 00:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333826B00E5; Wed, 18 Mar 2026 00:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248FF6B00E6; Wed, 18 Mar 2026 00:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 13DDF6B00E3
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 00:18:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 97BB11A0503
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:18:17 +0000 (UTC)
X-FDA: 84557876634.28.27C98C8
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id AB45B20005
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:18:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=QdzJvDXq;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773807495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3O/0uI2fOT2z8JCTJP8YkN4bS7/cK07tAt5pbKhSODY=;
	b=NKpNPG41blhP0KUX+hxwUOdqaxo3T4bnAabrJD5xH4v35t/W0iQVEJ/IOIxEv3u5uxeBWM
	IurRY/A4t5bWQVovcWFZc3zGvdQ4xe2cfyUz0blaTpn1ltjsoLd30LoviHsFkQ1W4oayJi
	onK6sFSaDVXNZoKiOQxgDEy58OsWlew=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=QdzJvDXq;
	spf=pass (imf13.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.179 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773807495; a=rsa-sha256;
	cv=none;
	b=XqEoyfCBeziNKv47t30dv1rzSCIzQXawj4V6qB6Y6QlYbLoPjx9tUwtJV/pp+S9pNedE/m
	jzwFeL03zstKVb4xy3902t+vIXz245zgPKbpZOu2zcneLjV9vuQIzX61F1UnxS8+/FuZlQ
	oeXWBAsqJ9+l90/5K6+9+3ypyK6fPIE=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2ad617d5b80so2103245ad.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 21:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1773807494; x=1774412294; darn=kvack.org;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3O/0uI2fOT2z8JCTJP8YkN4bS7/cK07tAt5pbKhSODY=;
        b=QdzJvDXq/lEXS/2wpJfewMzEUgPoIv6PFAUy48bYa84/3smKs4+tHOzZLr8/zCBWWn
         /Z/yJwZG/E5/9G2tVNnTJjl7ISSHHJ80jjUeRL+IqUw4i3+fK78BgUeJYeKrZvA8dxTK
         Hkcp5xJ9d9sZaRXU1mDLEnY4CFwsf1IPUu/4Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773807494; x=1774412294;
        h=user-agent:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3O/0uI2fOT2z8JCTJP8YkN4bS7/cK07tAt5pbKhSODY=;
        b=ZB8mK3yRVoUtvqfisA7tTt/BYOx30IpSnkqh5DpHS6oHAV1AAdRZjI4W6WKH2uHcYE
         b2o9QE4+LHr1EdclAj/Keg5ZaCHtr9IiVrzMUD8IyhXaUH9i3XYFwHl+V2cdF1SRZnnv
         zBLHlVA2X/FpSeRDJ7A8n/1tmtTkuYQcaTB6hzw+80ANlN13MUy6X/9XxfUyZusvTqSz
         gBfouTTRXBjQC3VLAo33rsDE66G4nLD5SVN055+xeHiUfjEgalHLMIT3Ip8+SfqZTF9+
         FP4i81P+mo4XN7WSNFj85zUXIzke6YuE+jN+Vc5lEvPs48R2RSyX/dPX7YoWq9KAnCs1
         0hrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXSiT3LYfIRyokY4onbXq3r2M4Fzi8A4CEex0s3BC2BesMdbYJvXGcAsTVWRG9LB4QB4dEbePHdxg==@kvack.org
X-Gm-Message-State: AOJu0Yznj/oOJzVquLpRatcWxgip+KK1omBpZAXn5PhjLqYxwu8lCEXy
	hY5SYozJMvL1bkL1qklPcKy2vjqXAVrZLuBTV7KNEMybOvkqY494iESu3JH/54ZAxog=
X-Gm-Gg: ATEYQzxzbHr3ztqr9gpYZR7y0XwxqP2X4pYL50J6aaBIwogymn6u+/auDRsAj+Zx6My
	CaiPOJFD6CtDbUHp519zVPwq17ps6ZLW5mwIo+oVl8UeCD39TyvObbmc6/wXrTI1juOy3+x51fj
	a1F64tfXrX9q1dJi5sK2nA9llyjvNOo+eCGoBbVzCik57DdPpT271rwV40wscFcD+L9Bu/omls/
	P9tbzuxiw+7nM9o09HS9qZgpNxrXdQw4UrbvlB9mnxhCBVz2NN4wlQPbnTpzSQAos9ISEqFkZPY
	LYUE1+FEn4wac51fYUU/i1VXFkTQ8MEt1eyOXCQwoH5H7/4Mwf3K0PqB2n4wE2J0jg3yMRzbjmb
	9mSarhJTpA2iG5A2OBtHAyvx4p+xQEx20Dh6oCjgBw7XkihjlJXn3gvpELVXIZ4Sy5/TT+r5vdh
	P4sbUGK9lhD9/1UQEyW/9x
X-Received: by 2002:a17:903:1666:b0:2ae:3afc:eb42 with SMTP id d9443c01a7336-2b06e3f7ce6mr19434655ad.38.1773807494369;
        Tue, 17 Mar 2026 21:18:14 -0700 (PDT)
Received: from localhost ([116.86.198.140])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b06e632418sm12962395ad.81.2026.03.17.21.18.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 21:18:13 -0700 (PDT)
Date: Wed, 18 Mar 2026 12:18:11 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] selftests/mm: Add UFFDIO_MOVE huge zeropage PMD
 regression test
Message-ID: <abongwF3X0G8xY1I@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3 (50e3b1f3) (2026-01-25)
X-Rspamd-Queue-Id: AB45B20005
X-Stat-Signature: 7df8bo3ic5rjqx39u89ae3f6re3snw3k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773807495-47609
X-HE-Meta: U2FsdGVkX1/BxcXfQhHJe+VsZ1kQyMeAAgm5rh+XfASnlvejdxPghDu0p53UO8aZFPuT62eawVxH7xppA9Q7QWBH7ACihuAbtpHeJLrZbsWwwY+1/Uub9wW0/IqEySJ3im67GoB/d3FTgOlfALAQcbm9GalUsQGQ9XEY07fy1iESbI6MMS5Drlt+SBenfv3JTaDCVbx9cdohdbsVXn9IRl6YHmGcfvDCysCryHFyXd86NTq+r2m9byTcjOxNu7ueW6HrcxZ0QptHiXlqBaLfOvV01kmq4axylf1VxMUhPr/2Ij762h4nxhALlhmVBWEPBA6mc9pdPsJw905ar26j40e/NSe8IW33JCdHOnt+mv+GgLC2N51FTazjn7GGeQUY3WKoX1i6/fxdBcUMbx9PEpSzreIoCJjircuEixLqPQu20QNweluO4aXt9QexZfvvZ8/3D1DHlx8i0lXjufKt4N40TzP1Le1or3+bPzvF0o7CWud/JUEAm4oT9Ii/BYp6iQdb9Ta/oAmkIjJxsMLtTCip7Yn9tU8dGPjAa/2rq5tnftD3A02GXRnOD2tOptA/EUqvuGGD/D054VpLSEhZdJniggLvVLgO34+WbpdL4Cp/WsSaqx3VLd64D0okA4CjGoJN/iAcV1QwDh7X/LFx7ctxOExpEaktkQyXDi7LAbVb3Z9ObSVakRZpGuBKcA6ZPjBMexSboX/WKP4Mh+FGxl6M1kY7hJYf2G1nTGWoBW7FT03OlIk22op17sZomHxTHWEoBtZEm284DHryB4oY+G0IFmJbMlTFHcRxBOiO2tns4V5zPm/t9kiqURCw30wjWfX+hNjKjKWMhkdG85D/eeLIP9YX8fo0KSWeipqwzOvJ2L/xZBv/VO0MIODuc6e+42YYclmnktOmbQMyvFwTY7fW9X3sxUtyZXNyjes4auR5fPMej9d1wBGZpArgD1qOmYKgRjqY6KAofNzl/0X
 MRSWsY7P
 yvnc7xRVAAaF8l0BblvkSO6PtPl0q8uIzKUaDPSXuW624yd4q53zl3RM3GSs7FSlDl3sNmXkcflXDYgJh7Sr3d8kLcRhoxzyVWRy/Gre/IWoPZS++QDEz+VPQe8Esx2YoFZEqXqPOhIFgVU1+KRwf8gWEUeEKX6MYB4CChZ2sNHmPHmGxDKiIvEx+W1wzrMgUYPIqmftJAJpMTM8A1GVPLVclKXpnzDD7oeOiEfdSjD6bfEV4dXJk3XjzsulymPf0TbTUAYsGS3rryl66uFpcWgHIaT/wwcxa0Wclj47AAA6/an3jU/BcSMT4M/vMBy2ecEgBYZrjqC8ff1FASVNfotR8QeX/nSbdoD3H3aSOt2CEH52BTG2frOiLKFQOXGblh0l/OctIbcshwLnC/QlGRVhXR4E5mBviXiPY7N4QyKstEN6WV2IpPX9NfmlLgcL8fSyVDpVSfR/nGUDVFp0OgexkQpt2kMAeuywubv9hic/dXpqWXgjWGcuNqx5c1Td5gq8459J5rZQRjGE=
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
 tools/testing/selftests/mm/uffd-unit-tests.c | 100 +++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c         |  12 +++
 tools/testing/selftests/mm/vm_util.h         |   1 +
 3 files changed, 113 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 6f5e404a446c..9cc4cbab9a23 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1227,6 +1227,99 @@ static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t
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
+	/* Fault in a PMD-sized huge zeropage mapping in the source. */
+	force_read_pages(aligned_src, pmd_pages, gopts->page_size);
+
+	pagemap_fd = pagemap_open();
+	if (!pagemap_is_huge_zero(pagemap_fd, aligned_src)) {
+		close(pagemap_fd);
+		uffd_test_skip("could not fault in the huge zeropage");
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
+	} else if (!pagemap_is_huge_zero(pagemap_fd, gopts->area_dst)) {
+		uffd_test_fail("moved destination is not a huge zeropage PMD");
+	} else if (!check_huge_anon(gopts->area_dst, 0, pmd_size)) {
+		/* vm_normal_page_pmd() must continue to treat the moved PMD as special. */
+		uffd_test_fail("moved huge zeropage PMD counted as AnonHugePages");
+	} else {
+		uffd_test_pass();
+	}
+
+	gopts->area_src = orig_area_src;
+	gopts->area_dst = orig_area_dst;
+	close(pagemap_fd);
+}
+
 static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
 {
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
@@ -1550,6 +1643,13 @@ uffd_test_case_t uffd_tests[] = {
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
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index a6d4ff7dfdc0..55cc4cc058a2 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -120,6 +120,18 @@ bool pagemap_is_populated(int fd, char *start)
 				PAGE_IS_PRESENT | PAGE_IS_SWAPPED);
 }
 
+bool pagemap_is_huge_zero(int fd, char *start)
+{
+	uint64_t categories;
+
+	if (!pagemap_scan_supported(fd, start))
+		return false;
+
+	categories = pagemap_scan_get_categories(fd, start);
+	return (categories & (PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE)) ==
+		(PAGE_IS_PRESENT | PAGE_IS_PFNZERO | PAGE_IS_HUGE);
+}
+
 unsigned long pagemap_get_pfn(int fd, char *start)
 {
 	uint64_t entry = pagemap_get_entry(fd, start);
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index e9c4e24769c1..e0b6ae1b12f5 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -85,6 +85,7 @@ uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
 bool pagemap_is_swapped(int fd, char *start);
 bool pagemap_is_populated(int fd, char *start);
+bool pagemap_is_huge_zero(int fd, char *start);
 unsigned long pagemap_get_pfn(int fd, char *start);
 void clear_softdirty(void);
 bool check_for_pattern(FILE *fp, const char *pattern, char *buf, size_t len);

base-commit: f0caa1d49cc07b30a7e2f104d3853ec6dc1c3cad
-- 
2.53.0


