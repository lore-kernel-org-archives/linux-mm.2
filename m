Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78F99606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 21:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h1Wo+EHs
Received: by kanga.kvack.org (Postfix)
	id 1F1D96B05B1; Tue,  3 Nov 2026 16:28:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A30C6B05B2; Tue,  3 Nov 2026 16:28:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091286B05B3; Tue,  3 Nov 2026 16:28:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C2FCE6B05B1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 16:28:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9ADC1805A0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:28:10 +0000 (UTC)
X-FDA: 85395095940.29.6F10A2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1E4D120002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:28:09 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h1Wo+EHs;
	spf=pass (imf31.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793741289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5SQtuzh3F5B6ZYWHIhQ+SnNhZsxSWtRRLkjCgwfX95o=;
	b=CCFpAJ0Ee6ryYZzUAErtIF93mOxqUR824Akv5FKmzsOvJVlW3vFKUWJgPOvGPJBiWjX7Hu
	H2Fysh1+2LMnUb5JgHSc3l1wK4hvf6ymRWNF1rkKYdqAW/vIgskp23haM5epWgibkxFC7Q
	5cBBAH2oYh8TmCgLzPS/Y/1/BNH2gOA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793741289;
	b=3Zf9boJQLsZx5P92sTnzFzkmpObqFFl0/ZKws61Xy5wJaQxPSkt7I6YKqdt0AbR+KHKjhM
	3/BbtjRXkSJkF6WQH6D+p1pXu/qrKIWJuTE+yWLGdda4Lr6153Z1Ikfq0nCgXY1wh4Hh90
	gdNOhVrfjjmGsiTzR6NFKfCW8tnpKtE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h1Wo+EHs;
	spf=pass (imf31.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2BA3A40E01;
	Tue,  3 Nov 2026 21:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793DC1F000C1;
	Tue,  3 Nov 2026 21:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793741288;
	bh=5SQtuzh3F5B6ZYWHIhQ+SnNhZsxSWtRRLkjCgwfX95o=;
	h=From:To:Cc:Subject:Date;
	b=h1Wo+EHsefNjiJAc82BWuGo0JYFEuInjYZrVDluR+NLnU/lyUf5e/3abdnWdT+na/
	 gyUkeLSYQ2AeC2uwzhRHtM/E2EfLUGcyijyIP00o+YZDIajq6jS5OPEoRtERTem6gR
	 Lc8NzwfgQ6vYaF9LyzMhzk6HLGWSrivvNtNJzYdH/NBBcYeO4vZceVvdn+YeFw4ZJK
	 7A2ua5mYLxDSUBPVPGeU4Nd69xFYy4yiLiupbGg/GUJaP8w1nFr+kNw+x0TvL57ymv
	 XUJ48JYt6j1v4ftkeLVmTe4zZqMhx8mWiumZjG2vLGx1GH0haHGsFhvji6WigVE2UG
	 Xue/CeMymwzvA==
From: Sasha Levin <sashal@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] selftests/mm: fix pointer width warnings on 32-bit architectures
Date: Tue,  3 Nov 2026 16:28:05 -0500
Message-ID: <20261103212805.1537354-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1E4D120002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fajj7jah57nysqks964xdjc1xwqgmtmz
X-Rspam-User: 
X-HE-Tag: 1793741289-46679
X-HE-Meta: U2FsdGVkX1+/eEoJMmoX60juii7H2lcWr4zwFoW80bLqqhTFcCq2Vto/nBLZNJbgEklH8DYGQOYSKyepkFu2fsLUomqialkrRf1JhyX9cgsw0wfDFOmUimkiglZudujETyDzrlmJi2zqarMpgEQfyq5SuG4YtkShvS6wvQst7XPjjptuiJBOGVwPMOG/eMAT7AJ5fVtClcbDoY1EsaIFay0AWSUhGT5fHSlo7oUlSoekIWfXIl8Mu2+5GIYF64UuCQo+UnXMRfHCPkxs4GHfklmNDh5hKBYTpZ17kFpM4QMx+bv0Y8+pqwecyeIKOH+rAhWhsy5iLfNO8QyuNNTzBoid1FpZ1eIhjNdmvnU1CKhXxP2nwl9Vk62HNOfR+7XowLp7XBcLznRTTeVEhwfZkfb7PUc1bTg63EphBOuV5zAycfMJDz658QtogGsuPS8FtvNMmd/YsWXVpLgLMbqmXKBhahz9XIA0r7Dyud7FEVgJXsgLji5jykEdkg1znv+Nm2o54dE6NnCStTurdfhBiJ62Qocd7sVnODd7X8SIcDRHrUFF8Uze2yLZMODZiAfzZ2Q/TuOjUbdobQJq+uyTlf1rkzNSBSgF8E8MI3yz9OF5UENzoK7aH5wtXXTvJXCnr4VnxBRqwXaVDKmTuCQXLDdYEBKkkDdI5XMNgaR5MBCg/YDpfGtVIEJSoO8peOWNL/yLetxrR3kj57Q/qe5i9Jyh6cLSiK7LNc+Am0v6SiPqopgEoahYbvo9Zphet1HmzLBD+ea66sdoyuAudfvEo5Q7/5fJbevvFq+ALNu6KURt8eYly38YZAs0vfIIu5EYFgRD8kkcGMS5Avj2NpiVHLTJSJCJ09C5Wgwj8jpF1FChD1cZtVJZIysprgTdvfxR3DDo95PmMf69JrNtcStgZOCygJ5eAjEoamS8w2HEkejWfCs2gHDwV6TgR0hGf3bBgOnMxqtrHJunJUTlMIf
 lFE72st2
 NCA0n5c0O6AvNOcTL/XvbN8uieUIvNKw+7xsFtQGVynaX7ULZs88hoWPx7ETrFozNu7slQ/hMvCojp41Q3Pi9wIlMetJNPjy6BCmsA1PXVqdUKMb0iZt+y4Hitx2jsDsO+ZHGOAWjLh9Oh8qexYOwjODRHPMMDUQ+YdZLAnJl/j2z+k+Ic/x8yjgDeeStaFxapRsedlneq2sON40eJHBjuaDCmfaUoPOOp98HheQ/aPTPNpTgD2X+RerAOfxpVT59Ua5TchppVoDv2YI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Several mm tests convert between pointers and 64-bit integers with a
plain cast, which warns on 32-bit architectures, and hugetlb-mremap
passes 47-bit mmap() hints that don't fit in an unsigned long:

  uffd-unit-tests.c:344:31: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Add ptr_to_u64() and u64_to_ptr() to vm_util.h, which cast through
uintptr_t, and use them where pointers meet the 64-bit UAPI fields and
the 64-bit address arithmetic in mremap_test. The hugetlb-mremap hints
don't fit in a 32-bit address space, so only pass them when long is 64
bits.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
v2: add ptr_to_u64() and u64_to_ptr() to vm_util.h instead of
open-coding the casts (Lorenzo).
v1: https://lore.kernel.org/r/20261103163907.640667-1-sashal@kernel.org

Found with 32-bit builds of the selftests (gcc 16 and clang 21 with
-m32, with and without -D_TIME_BITS=64 -D_FILE_OFFSET_BITS=64);
KernelCI's 32-bit arm builds show the same warnings. The changed files
build without them now, and the x86_64 builds don't change.

 tools/testing/selftests/mm/hmm-tests.c       |  4 +-
 tools/testing/selftests/mm/hugetlb-mremap.c  | 17 ++++---
 tools/testing/selftests/mm/migration.c       |  4 +-
 tools/testing/selftests/mm/mremap_test.c     | 13 +++---
 tools/testing/selftests/mm/uffd-common.c     |  2 +-
 tools/testing/selftests/mm/uffd-unit-tests.c | 48 ++++++++++----------
 tools/testing/selftests/mm/vm_util.h         | 10 ++++
 7 files changed, 57 insertions(+), 41 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e5f273ca84c10..d4283c9c9d3ae 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -196,8 +196,8 @@ static int hmm_dmirror_cmd(int fd,
 	int ret;
 
 	/* Simulate a device reading system memory. */
-	cmd.addr = (__u64)buffer->ptr;
-	cmd.ptr = (__u64)buffer->mirror;
+	cmd.addr = ptr_to_u64(buffer->ptr);
+	cmd.ptr = ptr_to_u64(buffer->mirror);
 	cmd.npages = npages;
 
 	for (;;) {
diff --git a/tools/testing/selftests/mm/hugetlb-mremap.c b/tools/testing/selftests/mm/hugetlb-mremap.c
index 9b724af66e938..d5a4cef51ad35 100644
--- a/tools/testing/selftests/mm/hugetlb-mremap.c
+++ b/tools/testing/selftests/mm/hugetlb-mremap.c
@@ -33,6 +33,11 @@
 #define PROTECTION (PROT_READ | PROT_WRITE | PROT_EXEC)
 #define FLAGS (MAP_HUGETLB | MAP_SHARED)
 
+static void *addr_hint(unsigned long long addr)
+{
+	return sizeof(long) == 8 ? u64_to_ptr(addr) : NULL;
+}
+
 static void check_bytes(char *addr)
 {
 	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
@@ -130,21 +135,21 @@ int main(int argc, char *argv[])
 		ksft_exit_fail_msg("Open failed: %s\n", strerror(errno));
 
 	/* mmap to a PUD aligned address to hopefully trigger pmd sharing. */
-	unsigned long suggested_addr = 0x7eaa40000000;
-	void *haddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
+	void *haddr = mmap(addr_hint(0x7eaa40000000ULL), length, PROTECTION, FLAGS,
+			   fd, 0);
 	ksft_print_msg("Map haddr: Returned address is %p\n", haddr);
 	if (haddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap1: %s\n", strerror(errno));
 
 	/* mmap again to a dummy address to hopefully trigger pmd sharing. */
-	suggested_addr = 0x7daa40000000;
-	void *daddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
+	void *daddr = mmap(addr_hint(0x7daa40000000ULL), length, PROTECTION, FLAGS,
+			   fd, 0);
 	ksft_print_msg("Map daddr: Returned address is %p\n", daddr);
 	if (daddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap3: %s\n", strerror(errno));
 
-	suggested_addr = 0x7faa40000000;
-	void *vaddr = mmap((void *)suggested_addr, length, PROTECTION, FLAGS, fd, 0);
+	void *vaddr = mmap(addr_hint(0x7faa40000000ULL), length, PROTECTION, FLAGS,
+			   fd, 0);
 	ksft_print_msg("Map vaddr: Returned address is %p\n", vaddr);
 	if (vaddr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap2: %s\n", strerror(errno));
diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
index d1d0989ed2cad..b033db478b13f 100644
--- a/tools/testing/selftests/mm/migration.c
+++ b/tools/testing/selftests/mm/migration.c
@@ -236,7 +236,7 @@ TEST_F_TIMEOUT(migration, private_anon_thp, 2*RUNTIME)
 		MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
+	ptr = u64_to_ptr(ALIGN((uintptr_t) ptr, pmdsize));
 	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 	memset(ptr, 0xde, pmdsize);
 	for (i = 0; i < self->nthreads; i++)
@@ -270,7 +270,7 @@ TEST_F_TIMEOUT(migration, shared_anon_thp, 2*RUNTIME)
 		MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	ASSERT_NE(ptr, MAP_FAILED);
 
-	ptr = (uint64_t *) ALIGN((uintptr_t) ptr, pmdsize);
+	ptr = u64_to_ptr(ALIGN((uintptr_t) ptr, pmdsize));
 	ASSERT_EQ(madvise(ptr, pmdsize, MADV_HUGEPAGE), 0);
 
 	memset(ptr, 0xde, pmdsize);
diff --git a/tools/testing/selftests/mm/mremap_test.c b/tools/testing/selftests/mm/mremap_test.c
index 31b484517bda6..c6590f3384716 100644
--- a/tools/testing/selftests/mm/mremap_test.c
+++ b/tools/testing/selftests/mm/mremap_test.c
@@ -17,6 +17,7 @@
 #include <stdbool.h>
 
 #include "kselftest.h"
+#include "vm_util.h"
 
 #define EXPECT_SUCCESS 0
 #define EXPECT_FAILURE 1
@@ -190,7 +191,7 @@ static void *get_source_mapping(struct config c)
 	if (addr < mmap_min_addr)
 		goto retry;
 
-	src_addr = mmap((void *) addr, c.region_size, PROT_READ | PROT_WRITE,
+	src_addr = mmap(u64_to_ptr(addr), c.region_size, PROT_READ | PROT_WRITE,
 					MAP_FIXED_NOREPLACE | MAP_ANONYMOUS | MAP_SHARED,
 					-1, 0);
 	if (src_addr == MAP_FAILED) {
@@ -206,8 +207,8 @@ static void *get_source_mapping(struct config c)
 	 * requested alignment of 2MB. This is done to reduce coincidental
 	 * alignment in the tests.
 	 */
-	if (((unsigned long long) src_addr & (c.src_alignment - 1)) ||
-			!((unsigned long long) src_addr & c.src_alignment)) {
+	if ((ptr_to_u64(src_addr) & (c.src_alignment - 1)) ||
+			!(ptr_to_u64(src_addr) & c.src_alignment)) {
 		munmap(src_addr, c.region_size);
 		goto retry;
 	}
@@ -996,15 +997,15 @@ static long long remap_region(struct config c, unsigned int threshold_mb,
 	align_mask = ~(c.dest_alignment - 1);
 	/* Offset of destination address from the end of the source region */
 	offset = (c.overlapping) ? -c.dest_alignment : c.dest_alignment;
-	addr = (void *) (((unsigned long long) src_addr + c.region_size
+	addr = u64_to_ptr((ptr_to_u64(src_addr) + c.region_size
 			  + offset) & align_mask);
 
 	/* Remap after the destination block preamble. */
 	addr += c.dest_preamble_size;
 
 	/* See comment in get_source_mapping() */
-	if (!((unsigned long long) addr & c.dest_alignment))
-		addr = (void *) ((unsigned long long) addr | c.dest_alignment);
+	if (!(ptr_to_u64(addr) & c.dest_alignment))
+		addr = u64_to_ptr(ptr_to_u64(addr) | c.dest_alignment);
 
 	/* Don't destroy existing mappings unless expected to overlap. */
 	while (!is_remap_region_valid(addr - c.dest_preamble_size,
diff --git a/tools/testing/selftests/mm/uffd-common.c b/tools/testing/selftests/mm/uffd-common.c
index a76851aced4d0..3db9bdeccd0df 100644
--- a/tools/testing/selftests/mm/uffd-common.c
+++ b/tools/testing/selftests/mm/uffd-common.c
@@ -488,7 +488,7 @@ void uffd_handle_page_fault(uffd_global_test_opts_t *gopts, struct uffd_msg *msg
 		 */
 
 		area = (uint8_t *)(gopts->area_dst +
-		       ((char *)msg->arg.pagefault.address -
+		       ((char *)u64_to_ptr(msg->arg.pagefault.address) -
 		       gopts->area_dst_alias));
 		for (b = 0; b < gopts->page_size; ++b)
 			area[b] = ~area[b];
diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 2a97ba1d6feb1..44fbad5e73e68 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -341,17 +341,17 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
 	pagemap_fd = pagemap_open();
 
 	/* Test applying pte marker to anon unpopulated */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
 	pagemap_check_wp(value, true);
 
 	/* Test unprotect on anon pte marker */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, false);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, false);
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
 	pagemap_check_wp(value, false);
 
 	/* Test zap on anon marker */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 	if (madvise(gopts->area_dst, gopts->page_size, MADV_DONTNEED))
 		err("madvise(MADV_DONTNEED) failed");
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
@@ -366,7 +366,7 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
 		err("madvise(MADV_DONTNEED) failed");
 
 	/* Test read-zero-page upon pte marker */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 	*(volatile char *)gopts->area_dst;
 	/* Drop it to make pte none again */
 	if (madvise(gopts->area_dst, gopts->page_size, MADV_DONTNEED))
@@ -389,7 +389,7 @@ static void uffd_wp_fork_test_common(uffd_global_test_opts_t *gopts, uffd_test_a
 
 	/* Touch the page */
 	*gopts->area_dst = 1;
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
 	pagemap_check_wp(value, true);
 	if (pagemap_test_fork(gopts, with_event, false)) {
@@ -430,7 +430,7 @@ static void uffd_wp_fork_test_common(uffd_global_test_opts_t *gopts, uffd_test_a
 	}
 
 	/* Unprotect; this tests swap pte modifications */
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, false);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, false);
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
 	pagemap_check_wp(value, false);
 
@@ -469,7 +469,7 @@ static void uffd_wp_fork_pin_test_common(uffd_global_test_opts_t *gopts,
 
 	/* Touch the page */
 	*gopts->area_dst = 1;
-	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	wp_range(gopts->uffd, ptr_to_u64(gopts->area_dst), gopts->page_size, true);
 
 	/*
 	 * 1. First pin, then fork().  This tests fork() special path when
@@ -675,7 +675,7 @@ static void uffd_rwp_async_test(uffd_global_test_opts_t *gopts,
 		err("register failure");
 
 	/* RW-protect all pages (sets protnone) */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	/* Access all pages — should auto-resolve, no faults */
@@ -739,7 +739,7 @@ static void uffd_rwp_sync_test(uffd_global_test_opts_t *gopts,
 		err("register failure");
 
 	/* RW-protect all pages */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	/* Start fault handler thread */
@@ -816,7 +816,7 @@ static void uffd_rwp_pagemap_test(uffd_global_test_opts_t *gopts,
 			  nr_pages * page_size))
 		err("register failure");
 
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	/* Touch first half of pages to re-activate them (async auto-resolve) */
@@ -825,7 +825,7 @@ static void uffd_rwp_pagemap_test(uffd_global_test_opts_t *gopts,
 		(void)*page;
 	}
 
-	uint64_t start = (uint64_t)gopts->area_dst;
+	uint64_t start = ptr_to_u64(gopts->area_dst);
 	uint64_t boundary = start + (nr_pages / 2) * page_size;
 	uint64_t end = start + nr_pages * page_size;
 
@@ -844,7 +844,7 @@ static void uffd_rwp_pagemap_test(uffd_global_test_opts_t *gopts,
 	pm_arg.size = sizeof(pm_arg);
 	pm_arg.start = start;
 	pm_arg.end = end;
-	pm_arg.vec = (uint64_t)regions;
+	pm_arg.vec = ptr_to_u64(regions);
 	pm_arg.vec_len = ARRAY_SIZE(regions);
 	pm_arg.category_mask = PAGE_IS_ACCESSED;
 	pm_arg.return_mask = PAGE_IS_ACCESSED;
@@ -897,7 +897,7 @@ static void uffd_rwp_mprotect_test(uffd_global_test_opts_t *gopts,
 	if (uffd_register_rwp(gopts->uffd, gopts->area_dst,
 			      nr_pages * page_size))
 		err("register failure");
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			nr_pages * page_size, true);
 
 	/* Round-trip mprotect(): PROT_NONE -> PROT_READ|PROT_WRITE */
@@ -937,9 +937,9 @@ static void uffd_rwp_mprotect_test(uffd_global_test_opts_t *gopts,
 
 	memset(&pm_arg, 0, sizeof(pm_arg));
 	pm_arg.size = sizeof(pm_arg);
-	pm_arg.start = (uint64_t)gopts->area_dst;
-	pm_arg.end = (uint64_t)gopts->area_dst + nr_pages * page_size;
-	pm_arg.vec = (uint64_t)regions;
+	pm_arg.start = ptr_to_u64(gopts->area_dst);
+	pm_arg.end = ptr_to_u64(gopts->area_dst) + nr_pages * page_size;
+	pm_arg.vec = ptr_to_u64(regions);
 	pm_arg.vec_len = ARRAY_SIZE(regions);
 	pm_arg.category_mask = PAGE_IS_ACCESSED;
 	pm_arg.category_inverted = PAGE_IS_ACCESSED;
@@ -982,7 +982,7 @@ static void uffd_rwp_gup_test(uffd_global_test_opts_t *gopts,
 	if (uffd_register_rwp(gopts->uffd, gopts->area_dst, gopts->page_size))
 		err("register failure");
 
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			gopts->page_size, true);
 
 	if (pipe(pipefd))
@@ -1045,7 +1045,7 @@ static void uffd_rwp_async_toggle_test(uffd_global_test_opts_t *gopts,
 		err("register failure");
 
 	/* Phase 1: async detection — RW-protect, access first half */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	for (p = 0; p < nr_pages / 2; p++) {
@@ -1092,7 +1092,7 @@ static void uffd_rwp_async_toggle_test(uffd_global_test_opts_t *gopts,
 	set_async_mode(gopts->uffd, true);
 
 	/* RW-protect and access again — should auto-resolve */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	for (p = 0; p < nr_pages; p++) {
@@ -1127,7 +1127,7 @@ static void uffd_rwp_close_test(uffd_global_test_opts_t *gopts,
 			  nr_pages * page_size))
 		err("register failure");
 
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			 nr_pages * page_size, true);
 
 	/* Close uffd — should restore protnone PTEs */
@@ -1169,7 +1169,7 @@ static void uffd_rwp_fork_test(uffd_global_test_opts_t *gopts,
 
 	/* Populate + RWP-protect */
 	*gopts->area_dst = 1;
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst,
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst),
 			page_size, true);
 
 	/* Parent: verify uffd-wp bit is set before fork */
@@ -1223,7 +1223,7 @@ static void uffd_rwp_fork_pin_test(uffd_global_test_opts_t *gopts,
 	}
 
 	/* RWP-protect: PTE is now PAGE_NONE + uffd bit. */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst), page_size, true);
 
 	pagemap_fd = pagemap_open();
 	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
@@ -1332,7 +1332,7 @@ static void uffd_rwp_swap_cow_test(uffd_global_test_opts_t *gopts,
 	*gopts->area_dst = 0x11;
 
 	/* RWP-protect: PTE becomes PAGE_NONE + uffd bit (still exclusive). */
-	rwprotect_range(gopts->uffd, (uint64_t)gopts->area_dst, page_size, true);
+	rwprotect_range(gopts->uffd, ptr_to_u64(gopts->area_dst), page_size, true);
 
 	/*
 	 * Swap the page out while it is still exclusive: a shared (forked)
@@ -1498,7 +1498,7 @@ static int faulting_process(uffd_global_test_opts_t *gopts, int signal_test, boo
 						/* This is a WP request */
 						assert(steps == 2);
 						wp_range(gopts->uffd,
-							 (__u64)gopts->area_dst +
+							 ptr_to_u64(gopts->area_dst) +
 							 offset,
 							 gopts->page_size, false);
 					}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index b5d59729d4327..f6e82ee839283 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -59,6 +59,16 @@ static inline unsigned int pshift(void)
 	return __page_shift;
 }
 
+static inline uint64_t ptr_to_u64(const void *ptr)
+{
+	return (uintptr_t)ptr;
+}
+
+static inline void *u64_to_ptr(uint64_t val)
+{
+	return (void *)(uintptr_t)val;
+}
+
 static inline void force_read_pages(char *addr, unsigned int nr_pages,
 				    size_t pagesize)
 {
-- 
2.53.0


