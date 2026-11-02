Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B4E7608B7C1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iLU4JDSA
Received: by kanga.kvack.org (Postfix)
	id 641F26B0657; Mon,  2 Nov 2026 10:37:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F3AD6B0658; Mon,  2 Nov 2026 10:37:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4949A6B0659; Mon,  2 Nov 2026 10:37:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD556B0657
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7A434017C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:26 +0000 (UTC)
X-FDA: 85390583292.16.21EB783
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf31.hostedemail.com (Postfix) with ESMTP id EE3022000B
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iLU4JDSA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3M67oagcKCJAF2927C108805y.w86527EH-664Fuw4.8B0@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3M67oagcKCJAF2927C108805y.w86527EH-664Fuw4.8B0@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9juNA68D1pfuFQpRVNDQa7dR4Pnf/xhC+K8NWgBMU/E=;
	b=FIDc0KYCr2UbfTach/jx+8Twq01AfS9yNoYV1bVHTf39icUckoTJzpf/O6vLv092vmhplX
	oyOZ72U9vSmRyCw+JEMUSLqS9V/4rem6mIkoFbxZDXsgQF6BzpfNRgRPQfB4cp5d0ZgRv8
	qufis2IefHPCj167IU5H7qC+hYFlHco=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iLU4JDSA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf31.hostedemail.com: domain of 3M67oagcKCJAF2927C108805y.w86527EH-664Fuw4.8B0@flex--vipinsh.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=3M67oagcKCJAF2927C108805y.w86527EH-664Fuw4.8B0@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633844;
	b=Za1zSX9zsx9a7/7bKwL8LZ/exDkEh6RXOUkzz54I/o108LXZ+C7g1jP3hGVX51FHJxYF+W
	1RYLCu3gvEdZ1nellCsZE1Wj6O7YenMdK75yfQg7waFn48NTnR2EYKShGMeuBw2qxP8hgT
	Ddaj6WF672+oYQe+kpY9TQDfH3jUzkg=
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2e601800e58so51290715ad.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633844; x=1794238644; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9juNA68D1pfuFQpRVNDQa7dR4Pnf/xhC+K8NWgBMU/E=;
        b=iLU4JDSACn81vPfsc/G/fkrslDhq8L5Hpe4WU6j0IV9VcJq9x9eaPoVBBgMBuhVIF0
         R4zLVHV9Ml75QiAiBVWUMb4DF4Cq12zgI6RNPXkudJvlIkjvcxIEXCRv893vfgPSq4e4
         1omqxvRBe6G5yhmFGkgeN1RkZIQzmtopOJ0UeO4q6kuddblo3szE6m/qLNR0lY3vlEKk
         sXSweUfpwtDQoW+rAoim4u9JJHxBEzhwkc91rsaGoYsWJFDqoVoFjy595QLzmbgb+pjY
         29LSTnwdXj22omkOeQBFn3eaJWe5MF1CeLinPCs+IKMFvKHZPxmVZ64P0N0a/Z3GBhGh
         6H2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633844; x=1794238644;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9juNA68D1pfuFQpRVNDQa7dR4Pnf/xhC+K8NWgBMU/E=;
        b=iwKJI+xo+id8b8w3YduOw4mzAtKs8NVwKAn2r0JVyJap0uW1hxrmqNHlPsvODl6K/P
         CpHx2DfPElsxeWMXG5fW/mAFqDi3sviayMsa4AKvQ1tVJTk6prHf1r5OxnZ6ZR8A58pu
         ytT6y6oriZ+BACyyctUgNVuOYGxCQ1XvcelAU/9b4EwP4rwVnEMTEyYHxgWnSsTb+ACM
         O9GqDD6f6FX8lsXpMxFK2inDKZzi8yFCl7OchAEritpUkN2ZbzMXdeYGjIBvu+xIfQZP
         CoTzivtn4S8nQW5/tuEkyCqLJhiyJWKHmC/hhqFOnhSHIkvgJZTUVwPP85g+E1vlE2Wh
         gYTQ==
X-Forwarded-Encrypted: i=1; AKwUvBxrCZbR5BAEOP4jWrwjXWizbkLaCVL/CMKcozTqdENoU1oopqs/oAOhhlV5Kxt2hnJ7XLPSMzyyOg==@kvack.org
X-Gm-Message-State: APuU4Z8vYtMHm9saGcmG8gSLjuj73b9ZElyZObAGW+JrxVHeEEn2+rkk
	/gp+pZlk8rFb7UCu10nI+DeF5pvd8nGI+Kb+vmMIdtN1d/acl+WkYXPK8Wc4+VhcVwDfGCsCUMK
	5ag3rWxioqg==
X-Received: from plkz4.prod.google.com ([2002:a17:902:7084:b0:2eb:4f47:5748])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:f642:b0:2e9:5772:9ab2
 with SMTP id d9443c01a7336-2eb364ec93fmr97906535ad.41.1793633843417; Mon, 02
 Nov 2026 07:37:23 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:51 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-23-vipinsh@google.com>
Subject: [PATCH v6 22/27] vfio: selftests: Add helpers for Live Update DMA
 memory and sysfs state
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EE3022000B
X-Stat-Signature: 6kde5mxhwhkg14eaaadnh4yp6jmjtuoq
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793633845-164278
X-HE-Meta: U2FsdGVkX190SEhrRXRUmQyPtUV5QdOsKR9HTqNn4TtdMnN5bI3aaeJbMwpeD6ZsPz/Qjr/YWCUDMs5dwTGody4rtvU5tUkFsiYhXaxo6c4NLT1aC5EfZlMc7sNibnQWbcrcI0dOCkHuUwEAWkNZjhLP7AN3A/cHnMmOcg6kymxRZIQ0MaoXrkmN3KC/C9vaSrVLgUgauBVDYoZAKPukwFT2z5jiFZDQ2sSPHkvZLxIfE5s18Ga9cbgolGUjoKqvxgHfaIlwE2ArOTqHFyI2SZ/+oCaS1349PJvIToaMZeY51DgjHbIUo44y/hDMkHDy6IjxK+pcnm1ExaXQssdh5rTMt2/OaUjUcYRhWxSPtfb5fTQhUwUHbCGopeav9l0AJ5P1yzUXyYqYkNC06n+YQXgJLMXZKXEgtYEooPq12zCaY9E4qLnZJnWP/D+FF+YEmg+vLFGfbGFTLGnaPfQPz0r7ISUWKNVdklNh+yfYxuPLNKPLAjVGPy0Onh1ebD6brj+NlBPUJoy6cY0uxiPLlsT1tdIaSLl3u8UaMKEIc2CKPjOGkE2DwOFOHNAuoAJbycd8sIokc3Q2Nhgrqql9XNfWvrrOtJTRFtCYvtZptOxwR2eODlCULFUONW2rr6lszxqBmTiveSmkxlRJ1K9ztdz5BhpqZRQLjEu63jEO3xpEZWuL6RX2nK00MK/H8GZcBy+JQ4OZ21xjIYoVsVOBgjJvvVMawUB9AyrQSFSaZazC+QSZHOlnwpbbnJwWhWHinR+0i7w1LzeUC6LL819C/cqRJnWk1sswS/c7ofDq1oEO16LlQuCD98oucvREXqmuL5YAr3cPwQBY7V+EeYtnDX+E0NU+u1Rq3FJ5nq448s2MnFV8KVud/v13cpMnfnzbydXayiUbYPr0IACvvUBSw2V+Q0p2EgYEl70XrTSpeKlmeW20DK19Jkcx40senZOrr+Er6xhB93pSBX9ZTIw
 C9msZP6O
 +QYXcdgUmtRhD6zBNiUPJevhCpHRgmS5usI9FlRco0m+hPZAUAOpoutcA5q5QfYlLkx4dR/e4+a+i0rQMPDfsbTQytlkSesyxCbrM4GIbQ9LblNe1hFu1SLL/k7QEKXYjCkHu7p9c1X0PnK7D9n+hnHJDhLH1G891eyB1ykfjOQihVx4cpVmu9TO2wakCVfZDxav8xeOc2YOw4NsXXrdpQ11mStJWbHNpHaSl9JtwO5XfI1IApM/yPZ6U4i4LER1Asyx6gg75zKwKX6HqNjasN4QXhpV9za8AkIiLYSW79KXuf7IGobUSD0McuxYXd80xlDuEMU+fl/SGOrVbBOK2ohuyYhziF38h7NUq1bj01lZMMKYUc6CQ/xdWNJZCDfkeVtgx53AuGeJDGtLRj68/4ytLRHc0mpQco4rd9WwAlNaW16ooEwuldxTSKFARATDjTUWZmZe/t+7KFqHAFQ7J/Srbsxmz0QdlXCUnqBdLFyWJN1ND94qfdEntsGuTaWlt7SKM3rO2ZtL7DG1YUHG4+Zvm6LggrLg1eDzjjCcFVjHWzOwcEz135iMPl8+qi+Dq3ZkHS/rOADPr2jDlBTyI/bpCgQqOu5oCfbo4x6Dpv47barLIlzpIB7rMvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add shared libvfio helpers used by the Live Update kexec selftest:

 - vfio_thp_memfd_alloc() and vfio_memfd_mmap_aligned() to allocate a
   shmem memfd, map it at a 2MB-aligned virtual address, and back it
   with 2MB THP folios via MADV_HUGEPAGE, write-fault population, and
   MADV_COLLAPSE.
 - __sysfs_iommu_group_get(), a variant of sysfs_iommu_group_get() that
   returns an error instead of asserting when the device has no IOMMU
   group.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/vfio/lib/include/libvfio.h      |  3 ++
 .../vfio/lib/include/libvfio/sysfs.h          |  1 +
 tools/testing/selftests/vfio/lib/libvfio.c    | 54 +++++++++++++++++++
 tools/testing/selftests/vfio/lib/sysfs.c      | 22 ++++++--
 4 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio.h b/tools/testing/selftests/vfio/lib/include/libvfio.h
index 07862b470777..1c245962525b 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio.h
@@ -33,4 +33,7 @@ char **vfio_selftests_get_bdfs(int *argc, char *argv[], int *nr_bdfs);
  */
 void *mmap_reserve(size_t size, size_t align, size_t offset);
 
+int vfio_thp_memfd_alloc(size_t size, void **vaddr_out);
+void *vfio_memfd_mmap_aligned(int fd, size_t size, size_t align);
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_H */
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
index c9ab1ea8f5a9..b9d6f6f69f88 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/sysfs.h
@@ -6,6 +6,7 @@ int sysfs_sriov_totalvfs_get(const char *bdf);
 int sysfs_sriov_numvfs_get(const char *bdf);
 void sysfs_sriov_numvfs_set(const char *bdf, int numvfs);
 char *sysfs_sriov_vf_bdf_get(const char *pf_bdf, int i);
+int __sysfs_iommu_group_get(const char *bdf, int *group);
 int sysfs_iommu_group_get(const char *bdf);
 char *sysfs_driver_get(const char *bdf);
 
diff --git a/tools/testing/selftests/vfio/lib/libvfio.c b/tools/testing/selftests/vfio/lib/libvfio.c
index 3a3d1ed635c1..00369fe7d074 100644
--- a/tools/testing/selftests/vfio/lib/libvfio.c
+++ b/tools/testing/selftests/vfio/lib/libvfio.c
@@ -1,14 +1,23 @@
 // SPDX-License-Identifier: GPL-2.0-only
 
+#include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
 #include <sys/mman.h>
 
 #include <linux/align.h>
+#include <linux/mman.h>
+#include <linux/sizes.h>
 
 #include "../../../kselftest.h"
 #include <libvfio.h>
 
+#ifndef MADV_COLLAPSE
+#define MADV_COLLAPSE 25
+#endif
+
 static bool is_bdf(const char *str)
 {
 	unsigned int s, b, d, f;
@@ -101,3 +110,48 @@ void *mmap_reserve(size_t size, size_t align, size_t offset)
 
 	return map_align;
 }
+
+void *vfio_memfd_mmap_aligned(int fd, size_t size, size_t align)
+{
+	void *vaddr;
+
+	vaddr = mmap_reserve(size, align, 0);
+	vaddr = mmap(vaddr, size, PROT_READ | PROT_WRITE,
+		     MAP_SHARED | MAP_FIXED, fd, 0);
+	VFIO_ASSERT_NE(vaddr, MAP_FAILED);
+
+	return vaddr;
+}
+
+int vfio_thp_memfd_alloc(size_t size, void **vaddr_out)
+{
+	void *vaddr;
+	int fd;
+
+	VFIO_ASSERT_TRUE(IS_ALIGNED(size, SZ_2M));
+
+	fd = memfd_create("vfio-lu-dma", 0);
+	VFIO_ASSERT_GE(fd, 0);
+
+	VFIO_ASSERT_EQ(ftruncate(fd, size), 0);
+
+	vaddr = vfio_memfd_mmap_aligned(fd, size, SZ_2M);
+
+	if (madvise(vaddr, size, MADV_HUGEPAGE))
+		ksft_exit_skip("madvise(MADV_HUGEPAGE) failed: %s\n",
+			       strerror(errno));
+
+	/*
+	 * Write-fault the mapping rather than using fallocate() so that shmem
+	 * allocates PMD-sized THP folios when shmem_enabled is always,
+	 * within_size, or advise, then collapse in case shmem_enabled is never.
+	 */
+	memset(vaddr, 0, size);
+
+	if (madvise(vaddr, size, MADV_COLLAPSE))
+		ksft_exit_skip("madvise(MADV_COLLAPSE) failed: %s\n",
+			       strerror(errno));
+
+	*vaddr_out = vaddr;
+	return fd;
+}
diff --git a/tools/testing/selftests/vfio/lib/sysfs.c b/tools/testing/selftests/vfio/lib/sysfs.c
index 98a46a2543cd..219db6aaa101 100644
--- a/tools/testing/selftests/vfio/lib/sysfs.c
+++ b/tools/testing/selftests/vfio/lib/sysfs.c
@@ -115,14 +115,30 @@ char *sysfs_sriov_vf_bdf_get(const char *pf_bdf, int i)
 	return out_vf_bdf;
 }
 
-int sysfs_iommu_group_get(const char *bdf)
+int __sysfs_iommu_group_get(const char *bdf, int *group)
 {
+	char rl_path[PATH_MAX];
 	char path[PATH_MAX];
-	int group;
+	char *end;
+	int ret;
 
 	snprintf_assert(path, PATH_MAX, "/sys/bus/pci/devices/%s/iommu_group", bdf);
-	readlink_base(path, "%d", &group);
+	ret = readlink_safe(path, rl_path);
+	if (ret == -1)
+		return -errno;
+
+	errno = 0;
+	*group = strtol(basename(rl_path), &end, 10);
+	VFIO_ASSERT_EQ(errno, 0);
+	VFIO_ASSERT_EQ(*end, '\0');
+	return 0;
+}
+
+int sysfs_iommu_group_get(const char *bdf)
+{
+	int group;
 
+	VFIO_ASSERT_EQ(__sysfs_iommu_group_get(bdf, &group), 0);
 	return group;
 }
 
-- 
2.56.0.317.g454f8302e1-goog


