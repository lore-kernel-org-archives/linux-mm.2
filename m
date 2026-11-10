Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A76560A6F6E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CGkBLCdy
Received: by kanga.kvack.org (Postfix)
	id A9CA26B05BE; Tue, 10 Nov 2026 02:45:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A743D6B05BF; Tue, 10 Nov 2026 02:45:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A1C6B05C0; Tue, 10 Nov 2026 02:45:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3166B05BE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:45:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D12AC07E8
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:54 +0000 (UTC)
X-FDA: 85418425428.29.A6CA951
Received: from mta1.migadu.com (out-109.mta1.migadu.com [95.215.58.109])
	by imf26.hostedemail.com (Postfix) with ESMTP id 16095140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CGkBLCdy;
	spf=pass (imf26.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794296752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97mnfbHxocAhpCaQIusVnq6M8kRtn24K9aSi/cKW7BI=;
	b=1V+B+8WdZrNeusbUtgO5XuJdJ3SRn821GC0RXOcqEkrW40lyki5UOfCozMnj+/DqiYrMVD
	m4beYEKzooSU5encEeIZT8Vxln7qsq+6ebk3poLthknfWVmxTq80F3wME8g2Sb+ZilHv/l
	l4LTofL0iRUpGJmMl+2e6o3jof0lsTk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794296752;
	b=TcHI7ATc77KCYWOk0Dgichmxy8+kLhQUnr2EmzGaMRcmCaKdIx3stgyhnRL5BLlcoKD4ys
	lutWslkcafKHXAHCUMfYXPg3sdxcxPGpzA9EbPiwaUEe9C9Lnk0ZtQomCN5pw3fkag0XCf
	StKcSqK8Q6UZoBqrtwrqKOLScWSjJCE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CGkBLCdy;
	spf=pass (imf26.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.109 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1opsdpS+bzNavYjufxeQTvMtfH316Seppf9uslprEeo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794296750; v=1; x=1794901550;
 b=CGkBLCdyeAdmRQaMpYwOsFXQLR9CJ6tNn0SgokvVmqCHlrJNmlAeu0kPYyUKT7nJ2O+nRkEN
 xbm8PFIKoHAso4/v468DBUq8GxVQhz8qFDOOVXo3k9ax9eBrq9KLzP8HiPX/P9BE2cf80gcQ2b2
 3Mye2KctND06Vm86NdcDvAP0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8b40bb022d5288ba;
	Tue, 10 Nov 2026 07:45:50 +0000
X-Mizu-Trace-ID: 8b40bb022d5288ba
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	david@kernel.org,
	link@vivo.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	odys.yuan@gmail.com,
	rppt@kernel.org,
	surenb@google.com,
	tujinjiang@huawei.com,
	vbabka@kernel.org,
	xiao.wang@vivo.com
Subject: [PATCH 4/4] selftests/ksm: add test for only_merge_zero_pages
Date: Tue, 10 Nov 2026 15:44:51 +0800
Message-Id: <20261110074451.220524-4-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110074451.220524-1-xu.xin@linux.dev>
References: <20261110074312.219847-1-xu.xin@linux.dev>
 <20261110074451.220524-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: pjcjrjadj7rkuthuq6firm3tyy44xhit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 16095140007
X-Rspam-User: 
X-HE-Tag: 1794296751-215354
X-HE-Meta: U2FsdGVkX180Pi0W6m9dnPjWQXeWO62F/dtdwLrtMjuaubPmMcH9re6XOcXJ1mEOTsH0xIFX1zrGb/jmU6pWyw13Vwmz46e7vJzK1E2uCpjdezFCFs1iAw52FReACW83p38Ks8whK4IbZl6tlk8ucTkUe/vd4Ja8rqE0uK3n3vV6OFBZVu7a/BOAdLwIyTRdew25QGkwzIHw7zRB1k1dE5JxNkBeo40TXDM/RJw3if7JsCld/jf4zYFM6LDBSH3C3pVLDhd7yQDdetGnvAwvTHvWgeGxiZa6sRM/C6hStRRK1j3t/6AG/SZOZ8MRvmXNqHbRPYB/xIOntDkrZVL8ZiKQtMXWzKcN+Tt45pK58fzg8gle80AXrhyiTIFdK9iz0NZfC9M2Ym+VLV5YWh8sIaAcAOgn33bRFhF5cv02G2fVxBJl7cXUu/AuTPeM/rQdPPgzbh7W+9lA7XV4CIHTigDLVLaz0itlEysztU12gcJlM12h4Q+a8c0Z0lFeTuse6rrBaI1c1Bg6uPwfgmc2+9kNAebRpM5yMmTTeeRXK1J+x/ZS+eoFhvDoKNLH40SUUauOk7KOdc9ey9R9Ai/wfYKVfBrBv9oo+DfKFyF5oL/4YyFVJ8fHZ3lIBlwKhL6rQl71OMCL+qg/Lu0iVADomhZjestN6rFcoBQp2kbxq8Kj6OEafRKCmrXswBTescGa96UYRyTwnd29k8GzLUpDAAYlDdtnfEhq5BPOtIxqoJqQqJVWmyD5qFIFcysDbyR/5v8jGUcaZT6OSxge3pKcXCe+4xD7LQfFrlCjEQbUoUCAwmrTvVbdnztrtemM/cCC+fdCNwzFqMGNrgmv93R222ZhGQaSJut7F70c501LquYlGJA9ePYjeWMR+5G/pAoZSjHPz8KHIO8Wb8W9xfrq7Z/Pb6o4Ne3Nznz6JTMYvQofFPy9DGECRWsMduK38qeGA/DP9S3tky/t94NJfdR
 3H+/WsvA
 GMaRO5L3A7PeMBKKXr+baCPr+V2HmmTwcYlqTQ+dfU8+jnQVsMEoJv32q+V/Mrq4vyVCQ7ufkyi+cnGQzYGZ0fGJwESkGO4hTy53Xil8UKpZG+wiry4WNXXxfSkTbJ3O0w7qYkEdKFNuUrIcPEgCTKavO2iVLjsBxOAEZNALyz2Vwi9Xfz0llRI++oQiQ5zoaY30io8qyNp+HwZHOyt1rwSq0qljf/MR4uxu1ebOlYR4LZl7yhMk0qtmy5RJxRMGFfqnDDH+j8V9b32oBK6HDTO4RktY12GI4hzSSrzUBBtFCNb1O4Pr5pJMve89vN8lPRCPqWpsv40CuBrGdWLbaqwneqS7+Gi6S2CFP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a functional test that enables use_zero_pages and
only_merge_zero_pages, maps a 2 MiB region with the first half filled
with non-zero data and the second half with zeroes, and verifies that
after KSM scanning reaches steady state:

  - ksm_zero_pages equals the zero half (merged with the kernel zero
    page)
  - ksm_merging_pages is 0 (non-zero pages never reach the stable tree)
  - ksm_rmap_items is 0 (non-zero pages are skipped before rmap_item
    allocation, and the zero pages' rmap_items are freed once a scan
    finds the merged pages are no longer anonymous)

The test skips if the only_merge_zero_pages attribute is absent.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
 .../selftests/mm/ksm_functional_tests.c       | 117 ++++++++++++++++++
 1 file changed, 117 insertions(+)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 2ffb97ae3120..764ead3425cb 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -257,6 +257,122 @@ static void test_unmerge_zero_pages(void)
 	munmap(map, size);
 }
 
+/*
+ * Enable or disable /sys/kernel/mm/ksm/only_merge_zero_pages. Returns 0 on
+ * success, -errno on failure.
+ */
+static int ksm_set_only_merge_zero_pages(int enable)
+{
+	int fd;
+	ssize_t ret;
+
+	fd = open("/sys/kernel/mm/ksm/only_merge_zero_pages", O_RDWR);
+	if (fd < 0)
+		return -errno;
+
+	ret = write(fd, enable ? "1" : "0", 1);
+	close(fd);
+	return ret == 1 ? 0 : -errno;
+}
+
+static void test_only_merge_zero_pages(void)
+{
+	const unsigned int size = 2 * MiB;
+	const unsigned int half = size / 2;
+	const unsigned int half_pages = half / pagesize;
+	char *map;
+	int i;
+	long zero_pages, merging_pages, rmap_items;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	if (ksm_use_zero_pages() < 0) {
+		ksft_test_result_skip("write /sys/kernel/mm/ksm/use_zero_pages failed\n");
+		return;
+	}
+	if (ksm_set_only_merge_zero_pages(1) < 0) {
+		ksft_test_result_skip("write /sys/kernel/mm/ksm/only_merge_zero_pages failed\n");
+		return;
+	}
+
+	/* Stabilize accounting by disabling KSM completely. */
+	if (ksm_stop() < 0) {
+		ksft_test_result_fail("Disabling (unmerging) KSM failed\n");
+		goto restore;
+	}
+
+	map = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (map == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto restore;
+	}
+
+	/* Don't use THP. Ignore if THP are not around on a kernel. */
+	if (madvise(map, size, MADV_NOHUGEPAGE) && errno != EINVAL) {
+		ksft_test_result_fail("MADV_NOHUGEPAGE failed\n");
+		goto unmap;
+	}
+
+	/*
+	 * Fill the first half with non-zero data (all 0x01) and the second
+	 * half with zeroes. Under only_merge_zero_pages the zero half should
+	 * be merged with the kernel zero page, while the non-zero half must be
+	 * skipped entirely (no rmap_item allocated, no stable-tree insertion).
+	 */
+	memset(map, 0x01, half);
+	memset(map + half, 0x00, half);
+
+	if (madvise(map, size, MADV_MERGEABLE)) {
+		ksft_test_result_fail("MADV_MERGEABLE failed\n");
+		goto unmap;
+	}
+
+	/*
+	 * Run KSM until steady state. Each ksm_start() waits for two full
+	 * scans: the first records the checksums, the second merges the zero
+	 * half with the kernel zero page. The second ksm_start() waits for
+	 * more scans so that the rmap_items of the (now merged, no longer
+	 * anonymous) zero pages are freed and ksm_rmap_items settles at 0.
+	 */
+	for (i = 0; i < 2; i++) {
+		if (ksm_start() < 0) {
+			ksft_test_result_fail("Running KSM failed\n");
+			goto unmap;
+		}
+	}
+
+	/*
+	 * Expected results (steady state):
+	 *  - ksm_zero_pages: the zero half (size/2 pages) is merged with the
+	 *    kernel zero page.
+	 *  - ksm_merging_pages: 0, because the non-zero half is skipped before
+	 *    it can reach the stable tree, and zero pages are accounted in
+	 *    ksm_zero_pages, not ksm_merging_pages.
+	 *  - ksm_rmap_items: 0. The non-zero half is skipped before
+	 *    get_next_rmap_item(), so it never allocates an rmap_item; and the
+	 *    zero half's rmap_items are freed once a scan finds the (now
+	 *    merged) pages are no longer anonymous.
+	 */
+	zero_pages = ksm_get_self_stat("ksm_zero_pages");
+	merging_pages = ksm_get_self_stat("ksm_merging_pages");
+	rmap_items = ksm_get_self_stat("ksm_rmap_items");
+
+	ksft_print_msg("ksm_zero_pages=%ld ksm_merging_pages=%ld ksm_rmap_items=%ld"
+		       " (expected %u/0/0)\n", zero_pages, merging_pages, rmap_items,
+		       half_pages);
+
+	ksft_test_result(zero_pages == half_pages && merging_pages == 0 &&
+			 rmap_items == 0, "only_merge_zero_pages: zero half merged, "
+			 "non-zero half skipped\n");
+
+unmap:
+	ksm_stop();
+	munmap(map, size);
+restore:
+	ksm_set_only_merge_zero_pages(0);
+}
+
 static void test_unmerge_discarded(void)
 {
 	const unsigned int size = 2 * MiB;
@@ -827,6 +943,7 @@ int main(int argc, char **argv)
 
 	test_unmerge();
 	test_unmerge_zero_pages();
+	test_only_merge_zero_pages();
 	test_unmerge_discarded();
 #ifdef __NR_userfaultfd
 	test_unmerge_uffd_wp();
-- 
2.34.1


