Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5F50C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 03:32:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EDE16B008A; Sun, 12 Jul 2026 23:32:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F3C6B008C; Sun, 12 Jul 2026 23:32:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868F36B0092; Sun, 12 Jul 2026 23:32:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FB7A6B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 23:32:42 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C60B11C42F4
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:32:41 +0000 (UTC)
X-FDA: 84982331322.05.3AECE3E
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf29.hostedemail.com (Postfix) with ESMTP id 84BA4120005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:32:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783913559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=f2x015T2H+YJjTUmm0Remu0gi0Jt/8vERX5OMG8Eqi0=;
	b=Ois7o3iJqWKejiwPbvS20MJr1+2lXo5IkAnKeYv4ag+SAJ+i362nrQ8C2e3xvXesCIEjQQ
	+QHdwBcwVk3tyYv1nw/gpJI7dKByblxU6i/qofr7xY6/aqKonR2qHyQhKjJmHLRE6AN858
	9ddpfN+LzAn2kaOwCopaNk7LpEN/flo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of lihongfu@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lihongfu@kylinos.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783913559;
	b=B4x+xs3cQAHhHuoUx4kr966FXFkVM1/SjxkK0Oy5+t8z87gfgajzhLNXdOEgzaP7h6/AJg
	R5p7+DuK/5eOB+S1PdZwYcDagRYFw3PdcauCDHQHpda0ta8Zb5u/jaDOmCWkmf0zvfU/YP
	4qhepEBn+ys5ATYDazCS/Hbzkf8Fp0c=
X-UUID: 7938cf247e6b11f1aa26b74ffac11d73-20260713
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM, HR_SJ_PHRASE
	HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT, HR_TO_NO_NAME
	IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED, SA_EXISTED
	SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS
	CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.12,REQID:fd3d6d66-f4e1-4f96-af51-d6206ca05e0e,IP:10,
	URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:10
X-CID-INFO: VERSION:1.3.12,REQID:fd3d6d66-f4e1-4f96-af51-d6206ca05e0e,IP:10,UR
	L:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:10
X-CID-META: VersionHash:e7bac3a,CLOUDID:0378ea0926e0eb69057a3bd9c4a7f702,BulkI
	D:26071311323113UJW878,BulkQuantity:0,Recheck:0,SF:10|38|66|78|102|127|850
	|865|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:ni
	l,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE
	:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 7938cf247e6b11f1aa26b74ffac11d73-20260713
X-User: lihongfu@kylinos.cn
Received: from localhost.localdomain [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <lihongfu@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 375960602; Mon, 13 Jul 2026 11:32:28 +0800
From: Hongfu Li <lihongfu@kylinos.cn>
To: jgg@ziepe.ca,
	leon@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/mm: Factor out hmm_buffer_alloc() to consolidate buffer setup
Date: Mon, 13 Jul 2026 11:32:09 +0800
Message-Id: <20260713033209.280435-1-lihongfu@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 84BA4120005
X-Stat-Signature: i8xwaxmor9z6xzktujsrkn6gsaz3hbo7
X-Rspam-User: 
X-HE-Tag: 1783913558-716800
X-HE-Meta: U2FsdGVkX18WM013V2RmkQuPKe34CW9yVJCv8BxPwi+R7dLHpja7Okz6ss4R1gggVHUeIlVv2GL5uj9/XHVpqL0IqE/M7ll7zHVMHJAaehMSxeFHtmAyzgFNcS7dWa8D+aLD3A03jhPYOfjdBw/tL0H7XMJ1P0VPBQL5BYFv/va79XnTWGNmxc7CQ7+QIJQ/++266hYRX01t08+gSaQVYTZ7fvUJFYNW6CozFYIwPo8kSGh1/xMED2az83+2uthcmb/TqJGDaZ6M18gEObeOMiB8cnZA06jKelrnItSRr2+h6Zf6EuAB8OE+aMgDrfClCW6BiUzgKOxMhqkqC81NoRyg1eOTaeaPvsuLFN1yGJ0LHptCvTWJPPCJ+SWNvfbx4F+hBbLFjmWcIXGE8UTyMdrLNUX3rkNsxq/1c+gO/4rVHb022zTZ83Tp4qN4XCBHzDnLY8SR53zVFE+9gQwZgTiAkG+Vr5SpLmvvdql8dqaKbwfoM3MmOI2hI3GReBubffqb857lFUdTBDCS3pLa/mHMAM53Q8GPcERcRxK43CbR0am0P21S6DiJwFF6LN7d2Z+fOwKYEGK6kHf583QAIXZFOy7fXxT0Yk8FU84KpYBvGVT+B1LvRB7TZf0zIVNmWJ/iz/h5JphkiUh/Gcqs213mPBiDQEYQZkoQhFdma9DQNTe2AQryUN0sWv0lgVAPVQyP6bVl4CKs/6m5Aow9fEVgIdSlDYAw74bFkKoErzWKTJfVK/ZDEAWq/uDLvqW/HQrgdoMHpvD8p4iciaNTjzPRQ8r2dZ/2/EfxdcmLEiWD9k2Y4z7HwzuIG6EK/TSDPPSCu+3ERlTA2LW+XsEBnrl86AA9ehI+4uptVbIyL4EhvrF9shO5BwHixiRt320Tx2EjO7r+qgFGjTNQZK1lfApdWZ+0hf+ukQOGx01jYHpzr+A9QiH+MID8DZA+5SPNmEWftdyjh01dGQyWZFq
 sL2b2udu
 QMzqAabLwwWfbFdCSB03SsAJNr4q34/RFjeGGb2awxtwtOCecSoA86yn+7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each HMM test open-codes the same buffer initialization sequence:
allocate main buffer, assign file descriptor and size, allocate mirror
buffer, then perform mmap mapping. Factor out this repeated logic into
a standalone hmm_buffer_alloc() helper to eliminate ~35 open-coded
copies.

The new helper supports distinct mmap_size and mirror_size parameters
to fit scenarios with THP alignment padding or per-page snapshot flags.
It also exposes prot, flags and fd arguments, enabling support for
MAP_SHARED, MAP_HUGETLB and file-backed mappings.

Eliminates ~360 lines of redundant boilerplate code. Fixes a missing
NULL pointer check bug in the hmm_buffer_alloc() previously used only
by the migration benchmark, now subsumed by this new unified helper.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/hmm-tests.c | 625 +++++++------------------
 1 file changed, 165 insertions(+), 460 deletions(-)

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index 402c6f6f5f09..b9388ef4de59 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -223,6 +223,53 @@ static void hmm_buffer_free(struct hmm_buffer *buffer)
 	free(buffer);
 }
 
+/*
+ * Allocate a buffer structure with memory mapping and mirror.
+ *
+ * @mmap_size:   total size of the mmap region (may differ from @mirror_size
+ *               for alignment padding in THP tests).
+ * @mirror_size: size of the mirror data buffer (the actual working set).
+ * @prot:        protection flags for the mmap (e.g. PROT_READ | PROT_WRITE).
+ * @flags:       flags for the mmap (e.g. MAP_PRIVATE, MAP_SHARED,
+ *               MAP_ANONYMOUS, MAP_HUGETLB).
+ * @fd:          file descriptor for the mmap; pass -1 for MAP_ANONYMOUS.
+ *
+ * All internal allocations are checked; returns NULL and cleans up on any
+ * failure. Caller must ASSERT_NE or otherwise check the return value.
+ */
+static struct hmm_buffer *hmm_buffer_alloc(unsigned long mmap_size,
+						unsigned long mirror_size,
+						int prot, int flags,
+						int fd)
+{
+	struct hmm_buffer *buffer;
+
+	buffer = malloc(sizeof(*buffer));
+	if (!buffer) {
+		perror("malloc buffer");
+		return NULL;
+	}
+
+	buffer->fd = fd;
+	buffer->size = mmap_size;
+	buffer->mirror = malloc(mirror_size);
+	if (!buffer->mirror) {
+		perror("malloc mirror");
+		free(buffer);
+		return NULL;
+	}
+
+	buffer->ptr = mmap(NULL, mmap_size, prot, flags, fd, 0);
+	if (buffer->ptr == MAP_FAILED) {
+		perror("mmap");
+		free(buffer->mirror);
+		free(buffer);
+		return NULL;
+	}
+
+	return buffer;
+}
+
 /*
  * Create a temporary file that will be deleted on close.
  */
@@ -313,20 +360,11 @@ TEST_F(hmm, anon_read)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/*
 	 * Initialize buffer in system memory but leave the first two pages
 	 * zero (pte_none and pfn_zero).
@@ -376,20 +414,11 @@ TEST_F(hmm, anon_read_prot)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -435,20 +464,11 @@ TEST_F(hmm, anon_write)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize data that the device will write to buffer->ptr. */
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -483,20 +503,11 @@ TEST_F(hmm, anon_write_prot)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Simulate a device reading a zero page of memory. */
 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_READ, buffer, 1);
 	ASSERT_EQ(ret, 0);
@@ -558,20 +569,10 @@ TEST_F(hmm, anon_write_child)
 			ASSERT_NE(npages, 0);
 			size = npages << self->page_shift;
 
-			buffer = malloc(sizeof(*buffer));
+			buffer = hmm_buffer_alloc(size * 2, size,
+						  PROT_READ | PROT_WRITE,
+						  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 			ASSERT_NE(buffer, NULL);
-
-			buffer->fd = -1;
-			buffer->size = size * 2;
-			buffer->mirror = malloc(size);
-			ASSERT_NE(buffer->mirror, NULL);
-
-			buffer->ptr = mmap(NULL, size * 2,
-					   PROT_READ | PROT_WRITE,
-					   MAP_PRIVATE | MAP_ANONYMOUS,
-					   buffer->fd, 0);
-			ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 			old_ptr = buffer->ptr;
 			if (use_thp) {
 				map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
@@ -660,20 +661,11 @@ TEST_F(hmm, anon_write_child_shared)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_SHARED | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_SHARED | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer->ptr so we can tell if it is written. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -735,20 +727,10 @@ TEST_F(hmm, anon_write_huge)
 
 	size = 2 * read_pmd_pagesize();
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	size /= 2;
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
@@ -794,22 +776,11 @@ TEST_F(hmm, anon_write_hugetlbfs)
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
-	ASSERT_NE(buffer, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-				   PROT_READ | PROT_WRITE,
-				   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
-				   -1, 0);
-	if (buffer->ptr == MAP_FAILED) {
-		free(buffer);
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1);
+	if (!buffer)
 		SKIP(return, "Huge page could not be allocated");
-	}
-
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
 
 	/* Initialize data that the device will write to buffer->ptr. */
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
@@ -851,14 +822,11 @@ TEST_F(hmm, file_read)
 	fd = hmm_create_file(size);
 	ASSERT_GE(fd, 0);
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ,
+				  MAP_SHARED, fd);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = fd;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
 	/* Write initial contents of the file. */
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -866,12 +834,6 @@ TEST_F(hmm, file_read)
 	ASSERT_EQ(len, size);
 	memset(buffer->mirror, 0, size);
 
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ,
-			   MAP_SHARED,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Simulate a device reading system memory. */
 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_READ, buffer, npages);
 	ASSERT_EQ(ret, 0);
@@ -906,20 +868,11 @@ TEST_F(hmm, file_write)
 	fd = hmm_create_file(size);
 	ASSERT_GE(fd, 0);
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_SHARED, fd);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = fd;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_SHARED,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize data that the device will write to buffer->ptr. */
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -959,20 +912,11 @@ TEST_F(hmm, migrate)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -1009,20 +953,11 @@ TEST_F(hmm, migrate_file_private)
 	fd = hmm_create_file(size);
 	ASSERT_GE(fd, 0);
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE, fd);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = fd;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -1057,20 +992,11 @@ TEST_F(hmm, migrate_fault)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -1113,18 +1039,11 @@ TEST_F(hmm, migrate_release)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size, PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -1163,20 +1082,11 @@ TEST_F(hmm, migrate_shared)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_SHARED | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_SHARED | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Migrate memory to device. */
 	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
 	ASSERT_EQ(ret, -ENOENT);
@@ -1200,20 +1110,10 @@ TEST_F(hmm2, migrate_mixed)
 	npages = 6;
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_NONE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	/* Reserve a range of addresses. */
-	buffer->ptr = mmap(NULL, size,
-			   PROT_NONE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
 	p = buffer->ptr;
 
 	/* Migrating a protected area should be an error. */
@@ -1294,20 +1194,11 @@ TEST_F(hmm, migrate_multiple)
 	size = npages << self->page_shift;
 
 	for (c = 0; c < NTIMES; c++) {
-		buffer = malloc(sizeof(*buffer));
+		buffer = hmm_buffer_alloc(size, size,
+					  PROT_READ | PROT_WRITE,
+					  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 		ASSERT_NE(buffer, NULL);
 
-		buffer->fd = -1;
-		buffer->size = size;
-		buffer->mirror = malloc(size);
-		ASSERT_NE(buffer->mirror, NULL);
-
-		buffer->ptr = mmap(NULL, size,
-				   PROT_READ | PROT_WRITE,
-				   MAP_PRIVATE | MAP_ANONYMOUS,
-				   buffer->fd, 0);
-		ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 		/* Initialize buffer in system memory. */
 		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 			ptr[i] = i;
@@ -1353,20 +1244,11 @@ TEST_F(hmm, anon_read_multiple)
 	size = npages << self->page_shift;
 
 	for (c = 0; c < NTIMES; c++) {
-		buffer = malloc(sizeof(*buffer));
+		buffer = hmm_buffer_alloc(size, size,
+					  PROT_READ | PROT_WRITE,
+					  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 		ASSERT_NE(buffer, NULL);
 
-		buffer->fd = -1;
-		buffer->size = size;
-		buffer->mirror = malloc(size);
-		ASSERT_NE(buffer->mirror, NULL);
-
-		buffer->ptr = mmap(NULL, size,
-				   PROT_READ | PROT_WRITE,
-				   MAP_PRIVATE | MAP_ANONYMOUS,
-				   buffer->fd, 0);
-		ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 		/* Initialize buffer in system memory. */
 		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 			ptr[i] = i + c;
@@ -1419,20 +1301,11 @@ TEST_F(hmm, anon_teardown)
 		int *ptr;
 		int rc;
 
-		buffer = malloc(sizeof(*buffer));
+		buffer = hmm_buffer_alloc(size, size,
+					  PROT_READ | PROT_WRITE,
+					  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 		ASSERT_NE(buffer, NULL);
 
-		buffer->fd = -1;
-		buffer->size = size;
-		buffer->mirror = malloc(size);
-		ASSERT_NE(buffer->mirror, NULL);
-
-		buffer->ptr = mmap(NULL, size,
-				   PROT_READ | PROT_WRITE,
-				   MAP_PRIVATE | MAP_ANONYMOUS,
-				   buffer->fd, 0);
-		ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 		/* Initialize buffer in system memory. */
 		for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 			ptr[i] = i + c;
@@ -1473,22 +1346,11 @@ TEST_F(hmm, mixedmap)
 	npages = 1;
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, npages,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE, self->fd);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(npages);
-	ASSERT_NE(buffer->mirror, NULL);
-
-
-	/* Reserve a range of addresses. */
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE,
-			   self->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Simulate a device snapshotting CPU pagetables. */
 	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_SNAPSHOT, buffer, npages);
 	ASSERT_EQ(ret, 0);
@@ -1518,20 +1380,10 @@ TEST_F(hmm2, snapshot)
 	npages = 7;
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, npages,
+				  PROT_NONE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(npages);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	/* Reserve a range of addresses. */
-	buffer->ptr = mmap(NULL, size,
-			   PROT_NONE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
 	p = buffer->ptr;
 
 	/* Punch a hole after the first page address. */
@@ -1625,21 +1477,11 @@ TEST_F(hmm, compound)
 	size = ALIGN(TWOMEG, default_hsize);
 	npages = size >> self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
-	ASSERT_NE(buffer, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-				   PROT_READ | PROT_WRITE,
-				   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
-				   -1, 0);
-	if (buffer->ptr == MAP_FAILED) {
-		free(buffer);
-		return;
-	}
-
-	buffer->size = size;
-	buffer->mirror = malloc(npages);
-	ASSERT_NE(buffer->mirror, NULL);
+	buffer = hmm_buffer_alloc(size, npages,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1);
+	if (!buffer)
+		SKIP(return, "Huge page could not be allocated");
 
 	/* Initialize the pages the device will snapshot in buffer->ptr. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
@@ -1706,21 +1548,11 @@ TEST_F(hmm2, double_map)
 	npages = 6;
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	/* Reserve a range of addresses. */
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -1782,20 +1614,11 @@ TEST_F(hmm, exclusive)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -1836,20 +1659,11 @@ TEST_F(hmm, exclusive_mprotect)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -1891,20 +1705,11 @@ TEST_F(hmm, exclusive_cow)
 	ASSERT_NE(npages, 0);
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -1992,20 +1797,11 @@ TEST_F(hmm, hmm_gup_test)
 	npages = 4;
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -2078,20 +1874,11 @@ TEST_F(hmm, hmm_cow_in_device)
 	npages = 4;
 	size = npages << self->page_shift;
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
 
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
-
-	buffer->ptr = mmap(NULL, size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	/* Initialize buffer in system memory. */
 	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
 		ptr[i] = i;
@@ -2151,21 +1938,12 @@ TEST_F(hmm, migrate_anon_huge_empty)
 
 	size = read_pmd_pagesize();
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(2 * size, size,
+				  PROT_READ,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = 2 * size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
 	memset(buffer->mirror, 0xFF, size);
 
-	buffer->ptr = mmap(NULL, 2 * size,
-			   PROT_READ,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
 	ret = madvise(map, size, MADV_HUGEPAGE);
@@ -2203,21 +1981,12 @@ TEST_F(hmm, migrate_anon_huge_zero)
 
 	size = read_pmd_pagesize();
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(2 * size, size,
+				  PROT_READ,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = 2 * size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
 	memset(buffer->mirror, 0xFF, size);
 
-	buffer->ptr = mmap(NULL, 2 * size,
-			   PROT_READ,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
 	ret = madvise(map, size, MADV_HUGEPAGE);
@@ -2266,21 +2035,12 @@ TEST_F(hmm, migrate_anon_huge_free)
 
 	size = read_pmd_pagesize();
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(2 * size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = 2 * size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
 	memset(buffer->mirror, 0xFF, size);
 
-	buffer->ptr = mmap(NULL, 2 * size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
 	ret = madvise(map, size, MADV_HUGEPAGE);
@@ -2328,21 +2088,12 @@ TEST_F(hmm, migrate_anon_huge_fault)
 
 	size = read_pmd_pagesize();
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(2 * size, size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = 2 * size;
-	buffer->mirror = malloc(size);
-	ASSERT_NE(buffer->mirror, NULL);
 	memset(buffer->mirror, 0xFF, size);
 
-	buffer->ptr = mmap(NULL, 2 * size,
-			   PROT_READ | PROT_WRITE,
-			   MAP_PRIVATE | MAP_ANONYMOUS,
-			   buffer->fd, 0);
-	ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
 	old_ptr = buffer->ptr;
@@ -2424,21 +2175,11 @@ TEST_F(hmm, migrate_partial_unmap_fault)
 
 	for (use_thp = 0; use_thp < 2; ++use_thp) {
 		for (j = 0; j < ARRAY_SIZE(offsets); ++j) {
-			buffer = malloc(sizeof(*buffer));
+			buffer = hmm_buffer_alloc(2 * size, size,
+						  PROT_READ | PROT_WRITE,
+						  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 			ASSERT_NE(buffer, NULL);
-
-			buffer->fd = -1;
-			buffer->size = 2 * size;
-			buffer->mirror = malloc(size);
-			ASSERT_NE(buffer->mirror, NULL);
 			memset(buffer->mirror, 0xFF, size);
-
-			buffer->ptr = mmap(NULL, 2 * size,
-					   PROT_READ | PROT_WRITE,
-					   MAP_PRIVATE | MAP_ANONYMOUS,
-					   buffer->fd, 0);
-			ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 			npages = size >> self->page_shift;
 			map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
 			if (use_thp)
@@ -2504,21 +2245,11 @@ TEST_F(hmm, migrate_remap_fault)
 					if (dont_unmap)
 						flags |= MREMAP_DONTUNMAP;
 
-					buffer = malloc(sizeof(*buffer));
+					buffer = hmm_buffer_alloc(8 * size, size,
+								  PROT_READ | PROT_WRITE,
+								  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 					ASSERT_NE(buffer, NULL);
-
-					buffer->fd = -1;
-					buffer->size = 8 * size;
-					buffer->mirror = malloc(size);
-					ASSERT_NE(buffer->mirror, NULL);
 					memset(buffer->mirror, 0xFF, size);
-
-					buffer->ptr = mmap(NULL, buffer->size,
-							   PROT_READ | PROT_WRITE,
-							   MAP_PRIVATE | MAP_ANONYMOUS,
-							   buffer->fd, 0);
-					ASSERT_NE(buffer->ptr, MAP_FAILED);
-
 					npages = size >> self->page_shift;
 					map = (void *)ALIGN((uintptr_t)buffer->ptr, size);
 					if (use_thp)
@@ -2589,18 +2320,13 @@ TEST_F(hmm, migrate_anon_huge_err)
 
 	size = read_pmd_pagesize();
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(2 * size, 2 * size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = 2 * size;
-	buffer->mirror = malloc(2 * size);
-	ASSERT_NE(buffer->mirror, NULL);
 	memset(buffer->mirror, 0xFF, 2 * size);
 
-	old_ptr = mmap(NULL, 2 * size, PROT_READ | PROT_WRITE,
-			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
-	ASSERT_NE(old_ptr, MAP_FAILED);
+	old_ptr = buffer->ptr;
 
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)old_ptr, size);
@@ -2684,18 +2410,13 @@ TEST_F(hmm, migrate_anon_huge_zero_err)
 
 	size = read_pmd_pagesize();
 
-	buffer = malloc(sizeof(*buffer));
+	buffer = hmm_buffer_alloc(2 * size, 2 * size,
+				  PROT_READ,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
 	ASSERT_NE(buffer, NULL);
-
-	buffer->fd = -1;
-	buffer->size = 2 * size;
-	buffer->mirror = malloc(2 * size);
-	ASSERT_NE(buffer->mirror, NULL);
 	memset(buffer->mirror, 0xFF, 2 * size);
 
-	old_ptr = mmap(NULL, 2 * size, PROT_READ,
-			MAP_PRIVATE | MAP_ANONYMOUS, buffer->fd, 0);
-	ASSERT_NE(old_ptr, MAP_FAILED);
+	old_ptr = buffer->ptr;
 
 	npages = size >> self->page_shift;
 	map = (void *)ALIGN((uintptr_t)old_ptr, size);
@@ -2765,19 +2486,6 @@ static double get_time_ms(void)
 	return (tv.tv_sec * 1000.0) + (tv.tv_usec / 1000.0);
 }
 
-static inline struct hmm_buffer *hmm_buffer_alloc(unsigned long size)
-{
-	struct hmm_buffer *buffer;
-
-	buffer = malloc(sizeof(*buffer));
-
-	buffer->fd = -1;
-	buffer->size = size;
-	buffer->mirror = malloc(size);
-	memset(buffer->mirror, 0xFF, size);
-	return buffer;
-}
-
 static void print_benchmark_results(const char *test_name, size_t buffer_size,
 				     struct benchmark_results *thp,
 				     struct benchmark_results *regular)
@@ -2822,17 +2530,14 @@ static inline int run_migration_benchmark(int fd, int use_thp, size_t buffer_siz
 	int ret, i;
 	int *ptr;
 
-	buffer = hmm_buffer_alloc(buffer_size);
-
-	/* Map memory */
-	buffer->ptr = mmap(NULL, buffer_size, PROT_READ | PROT_WRITE,
-			  MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
-
-	if (buffer->ptr == MAP_FAILED) {
-		buffer->ptr = NULL;
+	buffer = hmm_buffer_alloc(buffer_size, buffer_size,
+				  PROT_READ | PROT_WRITE,
+				  MAP_PRIVATE | MAP_ANONYMOUS, -1);
+	if (!buffer) {
 		ret = -1;
 		goto cleanup;
 	}
+	memset(buffer->mirror, 0xFF, buffer_size);
 
 	/* Apply THP hint if requested */
 	if (use_thp)
-- 
2.25.1


