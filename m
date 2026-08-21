Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19E49C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 318616B00B1; Fri, 21 Aug 2026 14:58:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A23D6B00B2; Fri, 21 Aug 2026 14:58:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11EF66B00B3; Fri, 21 Aug 2026 14:58:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D71616B00B1
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:25 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5486A40228
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:25 +0000 (UTC)
X-FDA: 85126187370.10.F894246
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0D7A7160002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ba1UZMam;
	spf=pass (imf08.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7YiByawknR2bKXyMMS9faTlbP3TdC6Smi6Eshk/hFk=;
	b=IkJvk7gt7gyfXR96sW4T1yB78G2eIAYuceyzi7OctA52R88Lua3zbjitLUIjWlc3SZ+FiX
	ejDa5WwHWVJAri7MNZDMLvc7qvq88nrtR1XZ18Emv4lT1q4QB/LABb0urT5ipSqHXVnUJj
	20zoOpBTrNnBsNEYKm0Ha90ZEtC7voQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ba1UZMam;
	spf=pass (imf08.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338703;
	b=k1T+i/j8cZBuX41dTASYBNZXsfk3z7TA+eEMZmhMud3XOPe+QTKp9FyzoGgxvgAV9CMWVm
	04k5ESahq7YI/PeEbEMeZyW59BRSeaFzvy22BqXF6f7gRO1B8QaNy5eCVhlDQY2EmpWkwC
	ZzHrT3xK8exGBDaFpNyGnDNP50Q6UbA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=s7YiByawknR2bKXyMMS9faTlbP3TdC6Smi6Eshk/hFk=;
	b=ba1UZMamFJKdHyf2LTZ4R+au7yUpwEIFOw0QjDRKlhQCcdr2LElmjbdxblCxiXaOvzGQAT
	WeTS1CI0Hc2OXFlpMIzihQK0/PRzy0zy2ft34VYZzVhsFWu4CH2oG+8+TlFtSFI25v6TWI
	sz5oHXOdnSVI8c36FlOutt9kKNiyYNY=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-jsiDAuuxObmNUPudGuSQYQ-1; Fri, 21 Aug 2026 14:58:16 -0400
X-MC-Unique: jsiDAuuxObmNUPudGuSQYQ-1
X-Mimecast-MFC-AGG-ID: jsiDAuuxObmNUPudGuSQYQ_1787338696
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90c8d271ac9so7444296d6.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:58:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338696; x=1787943496;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s7YiByawknR2bKXyMMS9faTlbP3TdC6Smi6Eshk/hFk=;
        b=adytJf3i/WCGPwI9whAQhpbeocho25HgiMRyu/4hu3vyd+qPQz/ABwhff2DkpSo2lB
         Z6eAOZNqj9DvToWCw6uKMujRAiogWYwlzDSQ0fIUniwxdK+uNGnIeLH82/MAlRAXsDAP
         Qn7iSqlv5UPPQcsNdVrPGiYWdo+53HZ2gSPp/qEDl1SOFimdPjxxhN9HR7WaynbYj8qj
         aAGPCpiGtuFZ1el0G5mybeAM6wJ+oajd4CqcvaGHRnOG/xGDJ1mHS6FCyYxgZqB59BHd
         Ayx3PrBnUyXfbxPeABx4Cr9gyWZIWIjjrlSN5+w2syYdYdG6upRHxzBayCjXX50d7B1E
         YoJQ==
X-Gm-Message-State: AFuF++k94vWH001mTK1RIusON3GMR8msG8p1Yd4mraKCNDyORePC3BpE
	EBam/xihJdUrmiKpuKg+ahuEIXt/mE2VYNMal2pOmpkiTpLPc1Ud2xLU7tX2wBSQihVBCSfVuoP
	LX1Ce94ur0IwTvSWMyLYeEE+cjHj+P8a0wowTsc1UlkBJfaN40UVG
X-Gm-Gg: AR+sD12xekN/QhPFMShc0YyfZQ3Acx9BAqrnWjZUfybsJxPeL6zpuQ18hB+QD/gEfqJ
	bSyTBNNbhlG8GAsNd9hh78HHYnZefJ5Bbn5qdtuj7rTX35364Ji1IHodKFDhNt8akHjGfG3fimB
	ONnIQ5/ELGtuVODu4EYPcoE9AxaNjgvGbM+r3fcGn3t8wMWczYoluNVkBMlSwBbr+tFqyVqX0Y3
	V9Q8zMxrBzFJlArbll8/s0z9AazdjraEwV2tR0ML33Hcqb6fUP+iGKo7k0G+VwsA8qt4fSYHXaw
	K7tiG84RXv4UXQWbdlOpLTNx9p4j2ad0SUjhAtCst7qtZMa3oQSZAJ1ERKyqQJyO5FzCqmEnTXm
	7YcN8ZtKRCAXA4/WbaLL20Kvl8U3EEFSbuvvQVTYV2Hmi
X-Received: by 2002:a05:6214:3114:b0:8de:25f7:98bc with SMTP id 6a1803df08f44-90c8fa2ace7mr7854726d6.22.1787338695760;
        Fri, 21 Aug 2026 11:58:15 -0700 (PDT)
X-Received: by 2002:a05:6214:3114:b0:8de:25f7:98bc with SMTP id 6a1803df08f44-90c8fa2ace7mr7854186d6.22.1787338695297;
        Fri, 21 Aug 2026 11:58:15 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c6b42455dsm51197756d6.37.2026.08.21.11.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:58:11 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:57:02 -0400
Subject: [PATCH 10/11] selftests: cgroup: add memcg hugetlb_cma tests
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-10-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: iPC_xnc5uF6kDwE0nVsvP9RXj-T0hIOC1EwbJ5jlDWk_1787338696
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dcki3qtmdp8y6hrf67sm8bgnj9r6ymc5
X-Rspamd-Queue-Id: 0D7A7160002
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787338702-526362
X-HE-Meta: U2FsdGVkX18590tcACSTRFgLz+DM/9nNpZeQNGqdpaLI+36FWEnW5Jq3BKdQ2FbIftRkC9NITVM4r0zZv7sQ6YsaUlovqL7/F3mV5dWDuwo17VJFDShA8LwUFZATlNYto6DcEejSZWfmTqCbZmP4q7WdejSmRlN8iVclwJLytg4zKxav43F89p0+V8fDICjCSJNNv+/vBAvBXjwRZVYfcXqWZhFw3vhyoNdGLxmbACQanfJlu/yYCsdjstAe5ulT6D+n+2t/Qm3cvNyAFMt1lvOwhEFtOpJWKpW17g+0j8ycYrnZIAt8YTuVygm4NmwOTilM7xufrlTZ+bbrz+6pjzIOSblOsjtpPB01pzYlt8xCbdv11K50wiHDjjtq56Ysv/bfANmJePcmPzic5GhNv9Jqpj/tCdMDRMTfcYTnuRedHrB1gSOVEXidCHO6cC3D1h0nYF9JfyQDJQEaZDrEYeAVpZhwzF+2USUeSHl3jh9INykad2Luw4ZoLHjAZnCs5dQ+oP8gFgG3gINomfygwBTWmwVPR5GdyTtLAW23Rgu7+LUfWw53qjd4fip1MVnIcMTqftgX1KCrBCjKLUX75odSG/X/u0sqF6quax1dx8eeDYfK3sBeje+iZDN8MpNqQMZeJjJXG6Vfg6/rGY1CDVdyGoK+rvRDY6owhEUWkcF/0UZeKP4bIR1kmcKr3PhtRNXSd1g4KddogtHL6EHw5oAkn3PPaD7O2KA40y7BVOPsFg40sZG64Zeqbb8H4/QSqPfSAUjuO+YtlFh1+xraLLrZ0mIgmc3HWcDKunj8SvKMopwZbzUmjsll3jkWa86oG8Hmull0Rket/1yqL4Li7H8XgZ9tzsOfW1kQ1+l3MdfuiGhMXMthm2qH5zbGc699f9HskMoN+i928tn2l3j5dsRuXloJZ3uWwsuYjFFY4NWgzoXhYFNyYGNKjKYgMz1iZmN8BWr4EFsFncJexHf
 eUlR3i4F
 O2IZbme2VAxoB6op04BSqPxiVYRIsUF/o/ppZJ3uTuSmTR9wc623xr27/atiz60zKuWoFvuZc2T0qiNdCcvWgBqIxG+hDLiI1w9RyuyEsiWSxjUbcVbl0BZ4NfxvfHoEVDPrxCk+wCseYwBACmtUaqzVRqbhsdiNhdD95OcZeFfmrUS6saTKO38d/AIXU3ZPcT7mOyZ560KIKxqzKdGC9o2xy+wvPfGWCImytLkzmmS1KFSkyu6MemBb7mv/tIYcAqkMfWgbFeSkcL9RYm61E8JJNdT90Q/bFCBRRzyNeYtuRMzzDzPspMmWe2ZHnZ/0h5OqoaTLh2MTldCtb35k5OGS5xiu97OnCaeigrAl4K7qunbMUeZEVSPC1bcN80q6B5SvrlOd2IHvsxbrnd87UuCXJQYu3YljxJnIZrpEVlOPl0E4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_hugetlb_cma_charge gets a hugepage by incrementing nr_hugepages,
confirms memory.cma.hugetlb0.current increased as expected, then
releases it and checks the counter returns to its initial value.

test_hugetlb_cma_limit sets memory.cma.hugetlb0.max to 0, tries to
allocate a hugepage and verifies it fails.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 tools/testing/selftests/cgroup/test_cma_memcg.c | 209 ++++++++++++++++++++++++
 1 file changed, 209 insertions(+)

diff --git a/tools/testing/selftests/cgroup/test_cma_memcg.c b/tools/testing/selftests/cgroup/test_cma_memcg.c
index b5b5ea140518..9bd41d9a6177 100644
--- a/tools/testing/selftests/cgroup/test_cma_memcg.c
+++ b/tools/testing/selftests/cgroup/test_cma_memcg.c
@@ -4,7 +4,9 @@
 #include <linux/limits.h>
 #include <sys/mman.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
+#include <dirent.h>
 #include <fcntl.h>
 #include <linux/dma-heap.h>
 #include <sys/ioctl.h>
@@ -15,6 +17,10 @@
 #define CMA_RESERVED_CURRENT	"memory.cma.reserved.current"
 #define CMA_RESERVED_MAX	"memory.cma.reserved.max"
 
+#define HUGETLB_CMA_CURRENT	"memory.cma.hugetlb0.current"
+#define HUGETLB_CMA_MAX	"memory.cma.hugetlb0.max"
+#define HUGEPAGES_DIR		"/sys/kernel/mm/hugepages"
+
 static int cma_heap_alloc(int heap_fd, size_t size)
 {
 	struct dma_heap_allocation_data data = {
@@ -145,6 +151,207 @@ static int test_cma_limit(const char *root)
 	return rc;
 }
 
+static long find_largest_hugepage_size_kb(void)
+{
+	DIR *dir;
+	struct dirent *entry;
+	long max_size = 0;
+
+	dir = opendir(HUGEPAGES_DIR);
+	if (!dir)
+		return -1;
+
+	while ((entry = readdir(dir)) != NULL) {
+		long size;
+
+		if (sscanf(entry->d_name, "hugepages-%ldkB", &size) == 1) {
+			if (size > max_size)
+				max_size = size;
+		}
+	}
+	closedir(dir);
+
+	return max_size > 0 ? max_size : -1;
+}
+
+static long read_sysfs_long(const char *path)
+{
+	FILE *f;
+	long val = -1;
+
+	f = fopen(path, "r");
+	if (!f)
+		return -1;
+	if (fscanf(f, "%ld", &val) != 1)
+		val = -1;
+	fclose(f);
+	return val;
+}
+
+static int write_sysfs_long(const char *path, long val)
+{
+	FILE *f;
+	int rc;
+
+	f = fopen(path, "w");
+	if (!f)
+		return -1;
+	rc = fprintf(f, "%ld", val);
+	fclose(f);
+	return rc < 0 ? -1 : 0;
+}
+
+static int test_hugetlb_cma_charge(const char *root)
+{
+	int rc = KSFT_SKIP, in_cg = 0;
+	long hpage_size_kb, hpage_size_bytes;
+	long orig_nr = -1, new_nr, before, after;
+	char nr_path[PATH_MAX];
+	char *cg;
+
+	hpage_size_kb = find_largest_hugepage_size_kb();
+	if (hpage_size_kb < 0) {
+		ksft_print_msg("no hugepage size found\n");
+		return KSFT_SKIP;
+	}
+	hpage_size_bytes = hpage_size_kb * 1024;
+
+	snprintf(nr_path, sizeof(nr_path),
+		 HUGEPAGES_DIR "/hugepages-%ldkB/nr_hugepages", hpage_size_kb);
+
+	cg = cg_name(root, "memcg_hugetlb_cma_charge");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_enter_current(cg))
+		goto cleanup;
+	in_cg = 1;
+
+	if (cg_read_long(cg, HUGETLB_CMA_CURRENT) < 0) {
+		ksft_print_msg("hugetlb CMA counters not available\n");
+		goto cleanup;
+	}
+
+	orig_nr = read_sysfs_long(nr_path);
+	if (orig_nr < 0) {
+		ksft_print_msg("cannot read %s\n", nr_path);
+		goto cleanup;
+	}
+
+	before = cg_read_long(cg, HUGETLB_CMA_CURRENT);
+
+	if (write_sysfs_long(nr_path, orig_nr + 1)) {
+		ksft_print_msg("cannot write %s\n", nr_path);
+		goto cleanup;
+	}
+
+	new_nr = read_sysfs_long(nr_path);
+	if (new_nr <= orig_nr) {
+		ksft_print_msg("failed to allocate a hugepage\n");
+		goto cleanup;
+	}
+
+	rc = KSFT_FAIL;
+	after = cg_read_long(cg, HUGETLB_CMA_CURRENT);
+
+	if (after - before < hpage_size_bytes) {
+		ksft_print_msg(
+			"hugetlb CMA counter not charged: before=%ld after=%ld expected +%ld\n",
+			before, after, hpage_size_bytes);
+		goto cleanup;
+	}
+
+	write_sysfs_long(nr_path, orig_nr);
+
+	after = cg_read_long(cg, HUGETLB_CMA_CURRENT);
+	if (!values_close(before, after, 3)) {
+		ksft_print_msg(
+			"hugetlb CMA counter not uncharged: before=%ld after=%ld\n",
+			before, after);
+		goto cleanup;
+	}
+
+	rc = KSFT_PASS;
+
+cleanup:
+	if (orig_nr >= 0)
+		write_sysfs_long(nr_path, orig_nr);
+
+	if (in_cg)
+		cg_enter_current(root);
+	cg_destroy(cg);
+	free(cg);
+
+	return rc;
+}
+
+static int test_hugetlb_cma_limit(const char *root)
+{
+	int rc = KSFT_SKIP, in_cg = 0;
+	long hpage_size_kb;
+	long orig_nr, new_nr;
+	char nr_path[PATH_MAX];
+	char *cg;
+
+	hpage_size_kb = find_largest_hugepage_size_kb();
+	if (hpage_size_kb < 0) {
+		ksft_print_msg("no hugepage size found\n");
+		return KSFT_SKIP;
+	}
+
+	snprintf(nr_path, sizeof(nr_path),
+		 HUGEPAGES_DIR "/hugepages-%ldkB/nr_hugepages", hpage_size_kb);
+
+	cg = cg_name(root, "memcg_hugetlb_cma_limit");
+	if (!cg)
+		goto cleanup;
+
+	if (cg_create(cg))
+		goto cleanup;
+
+	if (cg_enter_current(cg))
+		goto cleanup;
+	in_cg = 1;
+
+	if (cg_read_long(cg, HUGETLB_CMA_MAX) < 0) {
+		ksft_print_msg("hugetlb CMA counters not available\n");
+		goto cleanup;
+	}
+
+	if (cg_write(cg, HUGETLB_CMA_MAX, "0")) {
+		ksft_print_msg("cannot set hugetlb CMA limit\n");
+		goto cleanup;
+	}
+
+	orig_nr = read_sysfs_long(nr_path);
+	if (orig_nr < 0) {
+		ksft_print_msg("cannot read %s\n", nr_path);
+		goto cleanup;
+	}
+
+	write_sysfs_long(nr_path, orig_nr + 1);
+	new_nr = read_sysfs_long(nr_path);
+
+	rc = KSFT_FAIL;
+	if (new_nr > orig_nr) {
+		ksft_print_msg("hugetlb CMA limit not enforced\n");
+		write_sysfs_long(nr_path, orig_nr);
+	} else {
+		rc = KSFT_PASS;
+	}
+
+cleanup:
+	if (in_cg)
+		cg_enter_current(root);
+	cg_destroy(cg);
+	free(cg);
+
+	return rc;
+}
+
 #define T(x) { x, #x }
 struct cma_memcg_tests {
 	int (*fn)(const char *root);
@@ -152,6 +359,8 @@ struct cma_memcg_tests {
 } tests[] = {
 	T(test_cma_charge),
 	T(test_cma_limit),
+	T(test_hugetlb_cma_charge),
+	T(test_hugetlb_cma_limit),
 };
 #undef T
 

-- 
2.53.0


