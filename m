Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F01F1606FE9B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 01:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=wsUQPzVj
Received: by kanga.kvack.org (Postfix)
	id 077DD6B05BA; Sun,  8 Nov 2026 20:23:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FA16B05BB; Sun,  8 Nov 2026 20:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA73B6B05BC; Sun,  8 Nov 2026 20:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B27576B05BA
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:23:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B3EEEA819B
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:26 +0000 (UTC)
X-FDA: 85413832812.11.889ACF2
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id C775A40002
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 01:23:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wsUQPzVj;
	spf=pass (imf17.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794187404;
	b=aMANurPCbi2CNSxdELd23L7RyJOR92iL44XXwAeEWl+lCuzEAM3udAul51Cw/tuNR/8U6y
	bwiqcbAeZdl6Xyalc8bOU2NIY9sYj4321BYw3FprOcIbNfZ8SEMgYosPKBkuYIiXHaKrb6
	3w4dZr7QOk4btOBz9J40HKpfYkRuc+k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=wsUQPzVj;
	spf=pass (imf17.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794187404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+5Pg2U7Z4p+e4Io+dyFSik/G65dnfD3gKTCmkaS9qY8=;
	b=eRRrc+a/z8Yr7T5Bbdar34H29/sURB/1nNvHo8YCJhQ/pR0MRVbVjrcw3s/ahnaMRkHjpM
	R/UUwRViliTeN7S7ABISOOwJCSD75l09W146uypFRvZ7cquKbotA62IKJB0Z/0DXQpc+xt
	fgIfBVYHj5CkhKGhXsNTlXRsnk9J9oQ=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-1ae18eb9ad0so351516c88.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 17:23:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794187404; x=1794792204; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+5Pg2U7Z4p+e4Io+dyFSik/G65dnfD3gKTCmkaS9qY8=;
        b=wsUQPzVjpygaDNoKh5k4hDnlOiC4BibZUcgRHf4kevjWtHix91y0pEB6pQyJpPvlq6
         OSQd7w17rrkhBvXFcELIDC8+lREHmbCEXjC8ktVdFyDRW3ZWFtaiIpgJG4zJWDRdhqce
         YUJPdQGs6hR2653gNYCm+l2S2W4HnH5uX99CBetuif2xT4W288v47s3KEp7pxqOP/zoo
         foatMWG6EMvQ50+qm9wHWv1t1BlX4Jl3cD9SR4XbFBm8gEROjfTofY73jejcP493z1kS
         fM/dXNvJWIZ9UF1yWpxwFuUsAFLDq0UBFtS1yZLqsHle6tJFYwmPO79TQRWs4srAkJkJ
         IcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794187404; x=1794792204;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+5Pg2U7Z4p+e4Io+dyFSik/G65dnfD3gKTCmkaS9qY8=;
        b=sD13IiQTuBMDMmTCzyMp6pxFEyLW+wYY+PjgBOedGlnY9i4/+JaFjnUv1EcYA72fde
         /8rU77Zl52o60VzB6jQF0hGc94aXB5FzlaChLb62oRndQOGhwI0cjvM4BzF+Qh8UsPCg
         yUZ3B/1HSXPLWV9EpBl/Vogs0kUXWh+K3SAWqAoOO1895YuPQ5U2sCDrtqj6HLVv/21g
         UFEk5lfMpFwOWw1CqLNYrZk9vR3xQI2qoM2HsO0t+mQzAA/7q/mVjGVOXKCH1X1Wd5Ji
         2oHaaWmSnAYafNtovlRPbQAc1mnI2Wev84SzBLUM0PM4lQJveqI4JDVxqq0V8YaS55QV
         dOcA==
X-Gm-Message-State: APuU4Z8dP7ytfAIlEBnaoiHIYNOSoqT11N7PDqiBk9fJf03/0AXf3fLu
	9HcLkR9ZCO9OmhINr8OX81qzQc7g/D0LIpvURDakn0Z5o/UpJ5r1wcOV
X-Gm-Gg: AYBFou00NaDxchMH6RN/P7+WYyeLZ/lLJIm+IYH8tyKHtPbblEGTma4RYfhrUo+2+tR
	UbUOQeJkjcP66eawRuMJ/3wlWCJDS+Cg0xpM5xx5Zh0ngGKaJUPaq8A4HKtr3fPGQU4HZKjXMpH
	bWD0lrYtDmi7WJKSwcVdnU7gafEM2xQECAXdzsf7bsBOLN8Sgzuk2fGVLq1n/eGdB9/fOiL5iGL
	FKOJFHR7rqjqXIrSE+Qmm2GjUOrxdzbyHaXb6AGdsbD4x8mszgUmI0GueJxtnc8JRTOyCLTMt/M
	tozVnTBt5XZY0QThqWdTsGZYSoFVxoSqe1yCxTb869eLupmS6KtNQ6xSOA/5R/6MQ0CL2Pus3bo
	sQbH2mRbH5gijzvtgRgricgDTGo2NFRJlAd7XsUPL9Ucr+b9QDShKtjwSECqd/ND6nxWLx5AGNs
	H29s0k8ETacRn2XgyzZaHsi/kbgZnOonzSHB9L3KtELftDT6pigmxm+ViYEUEH1/sJH/C2kv/xr
	CZy/KvgowqvCYzKjl3N+NkP7R84mN1OPbkuoQbehyONNd+ybbSfEFyX0s7DLr1MmHnh6hhZg+hG
	2mnGAcwGoMrn1GQaDM2wTQG6
X-Received: by 2002:a05:701b:2505:b0:185:fd0c:4585 with SMTP id a92af1059eb24-1b39febb929mr4053527c88.33.1794187403575;
        Sun, 08 Nov 2026 17:23:23 -0800 (PST)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b3771ea85bsm9428226c88.18.2026.11.08.17.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 17:23:23 -0800 (PST)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Sun, 08 Nov 2026 20:22:54 -0500
Subject: [PATCH v4 5/5] selftests/mm: cover merging KSM pages aged by smart
 scan
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-5-86be8fe77e7a@gmail.com>
References: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
In-Reply-To: <20261108-bug-mm-ksm-smart-scan-align-skips-v4-0-86be8fe77e7a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: 6c9feczikox8c6ppq9ktxgzozc4tbm4a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C775A40002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794187404-580991
X-HE-Meta: U2FsdGVkX19sgHZi0ttve/FEBOzDuelbix9fP81ZuDkqqYEWB/I2MbHYqRAv3zUeagAgyrFrdLYnegaYvhkreYnM/5n0jErSoYtyv5nJSgwluD4WV+nL9B02zM0MJe8zl5hQ/xkK+n+EA4n+P5+aCa4Td7QS4U7qmIAn6LeH6GzDaKJyxYMfAo+OZNhIoHYq8lUPSwvsnrpU/7V02sl3btqrpdyVg4cAXbU29uPGq+mYwVtSCsRF0Lpz/KRUvIcgNnCPHzVsqjBL1ZJzi/d6ppbxl0vPuCGNDUZCuKDf+hvBL26vqukXPP29uB90/MJhUTxpUzBl6S43pULTisNyydpjJIZdePA1GxAG1QyU1ziGhjAcW5OGKDc2nzY2ZGYctjGHp6WbHzbfOTXNdW5CZHdjQJEEev2+vGflDg0vojy6fh+sd7MV9jyRUPsPcwwOkcv5XWSrmfWvs2bgqpW/W7pjN0sGJQW0XxuRg0kLYYy9nIO/YOaDoek7hy+pTuAMXF0ugkUYgWvzQb/oIZ2u+6UYwpN/XYqruBKYw0G9xKHzuGo1TobBb2mc+ox8yb5HbmfjVar72omOqQkH6JAGLaxFRqr9MrqizecY5kdG7+s9Pn6M9A3NK2D2T+y3yAE7eDYN7DfHX2bSDGg3lVYm5rrKgr4SdUcwkQKYwDumW4vVCwLmVeduR66zXCJIsmqeMFtZtkunW67PuCJKGh2S5y9Er0flhvtbirSWTK9hzYVNvN6DVzTDZUWV6SPnpfGOVFlGUUUMzJqnl+oOe8qwcrltjC0d2CwLU4+KqkRoc/IIGBFbm8SYcPehCGPgHDsheUflU0J77jXT1HcAgNxd5d9FLKIcQsAqpm4P0HTIe9hNkrNyGOLD98+eu8tF0bXl5Y6uGL04EfeheJH/L8xUis0/eX/ZnT4E7tfCTKMMeeLUsqaGkF4vrQn81q284fqN6KvbopOMd/VbVuI4EV7
 aN1v+I9h
 ucJ+vLqQ/3jN7Ob62RxAHqu5pINac4CsoR45B9ubD81AB4cTmHCacxW8Z2begTEuIoQ69c8w/0F5deLMrnYtml6hGwFF1eWRfiVScB51S8If3qiFd9xHOBcy/twfZ68Uj12419BQ5mmyZDVfm9ze6PgUXY65a7htw5qk0nXQUaUulxIqIFlb6Jf57hPJdukf1sXgVE8bZQgbSygYMuQYCZenLNV+1NYOsVZppI/aQDQ3E/BJqWjxgXDjDj7W+38FVPge8ixHHXAPajja7e63sIOf/XxiqvnIkmuF33MlPxQvwJ0Bcn7Ccsh21027bO9tBM1szGaMIhLj5NLDyFD40N/pzhmrLIZLZlJRz2WkfintiPoHoSbBcPPRSEDtSAlF1VWF4whM+6UNIz82SJ/G9Su2ZiFJjDX5sfqe3+TLe6HB2/jdSDwEFMu9SoRIJs57oBcyK06DJGFwp6PT8Ca2mHbEM7MYqgerdFceBEwOfpSroXZ7zTYQy6Ok/bfs5PrEY0WMMCub9p9fpSp9yywHro3cSJ5MeIv+iRRuoIwWCWSnTwyOssSbAPDUZC0IhuKEO7pBkMk2kYHNztSRZJv/7UbEvyT4bzn+Hiqbs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

ksm_functional_tests checks merging and unmerging with ksmd's default
settings, but nothing there exercises smart scan, which skips pages KSM
has failed to merge for a while.

Smart scan used to time those skips per page, so two identical pages
that became mergeable some scans apart could end up never being looked
at in the same scan, and were never merged. "mm/ksm: align smart scan
skips with the scan number" fixed that.

Add ksm_get_smart_scan() and ksm_set_smart_scan() to vm_util, and a
case that enables smart scan, lets sixteen unique pages age for a dozen
scans, then makes a duplicate of each mergeable one scan apart, and
expects every pair to be merged 32 scans later:

  kernel               failures, two boots
  before the fix       20/20, 20/20
  with the fix          0/20,  0/20

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 tools/testing/selftests/mm/ksm_functional_tests.c | 89 ++++++++++++++++++++++-
 tools/testing/selftests/mm/vm_util.c              | 36 +++++++++
 tools/testing/selftests/mm/vm_util.h              |  2 +
 3 files changed, 126 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 31c06c72203fd..135191f99962d 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -695,6 +695,92 @@ static void test_fork_ksm_merging_page_count(void)
 	munmap(map, size);
 }
 
+static void test_merge_aged_pairs(void)
+{
+	const unsigned int pairs = 16;
+	const unsigned long size = 2 * pairs * pagesize;
+	int old_smart_scan;
+	unsigned int i;
+	char *map;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	old_smart_scan = ksm_get_smart_scan();
+	if (old_smart_scan < 0) {
+		ksft_test_result_skip("smart_scan not supported\n");
+		return;
+	}
+	if (ksm_set_smart_scan(true) < 0) {
+		ksft_test_result_fail("Enabling smart_scan failed\n");
+		return;
+	}
+
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
+	if (madvise(map, size, MADV_NOHUGEPAGE) && errno != EINVAL) {
+		ksft_test_result_fail("MADV_NOHUGEPAGE failed\n");
+		goto unmap;
+	}
+
+	/*
+	 * Page i of the first half and page i of the second half form a
+	 * pair with content no other page shares.
+	 */
+	for (i = 0; i < pairs; i++) {
+		memset(map + i * pagesize, i + 1, pagesize);
+		memset(map + (pairs + i) * pagesize, i + 1, pagesize);
+	}
+
+	/* Let the first page of each pair age without a duplicate. */
+	if (madvise(map, size / 2, MADV_MERGEABLE)) {
+		ksft_test_result_fail("MADV_MERGEABLE failed\n");
+		goto unmap;
+	}
+	if (ksm_start() < 0 || ksm_wait_full_scans(12) < 0) {
+		ksft_test_result_fail("Running KSM failed\n");
+		goto unmap;
+	}
+
+	/*
+	 * Make the duplicates mergeable one scan apart so that each pair
+	 * starts out with a different distance in scans.
+	 */
+	for (i = 0; i < pairs; i++) {
+		if (madvise(map + (pairs + i) * pagesize, pagesize,
+			    MADV_MERGEABLE)) {
+			ksft_test_result_fail("MADV_MERGEABLE failed\n");
+			goto unmap;
+		}
+		if (ksm_wait_full_scans(1) < 0) {
+			ksft_test_result_fail("Running KSM failed\n");
+			goto unmap;
+		}
+	}
+
+	if (ksm_wait_full_scans(32) < 0) {
+		ksft_test_result_fail("Running KSM failed\n");
+		goto unmap;
+	}
+
+	ksft_test_result(ksm_get_self_merging_pages() == 2 * pairs,
+			 "Pages aged by smart scan got merged\n");
+unmap:
+	ksm_stop();
+	munmap(map, size);
+restore:
+	if (ksm_set_smart_scan(old_smart_scan) < 0)
+		ksft_print_msg("Restoring smart_scan failed\n");
+}
+
 static void init_global_file_handles(void)
 {
 	mem_fd = open("/proc/self/mem", O_RDWR);
@@ -720,7 +806,7 @@ static void init_global_file_handles(void)
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 9;
+	unsigned int tests = 10;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -753,6 +839,7 @@ int main(int argc, char **argv)
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
 	test_fork_ksm_merging_page_count();
+	test_merge_aged_pairs();
 
 	err = ksft_get_fail_cnt();
 	if (err)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 8184691211acc..f26f9e4bfdbe9 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -992,6 +992,42 @@ int ksm_use_zero_pages(void)
 	return ret == 1 ? 0 : -EIO;
 }
 
+int ksm_get_smart_scan(void)
+{
+	int smart_scan_fd;
+	char buf;
+	ssize_t ret;
+
+	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_RDONLY);
+	if (smart_scan_fd < 0)
+		return -errno;
+
+	ret = pread(smart_scan_fd, &buf, 1, 0);
+	close(smart_scan_fd);
+	if (ret < 0)
+		return -errno;
+	if (ret != 1)
+		return -EIO;
+
+	return buf == '1';
+}
+
+int ksm_set_smart_scan(bool enable)
+{
+	int smart_scan_fd;
+	ssize_t ret;
+
+	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_WRONLY);
+	if (smart_scan_fd < 0)
+		return -errno;
+
+	ret = write(smart_scan_fd, enable ? "1" : "0", 1);
+	close(smart_scan_fd);
+	if (ret < 0)
+		return -errno;
+	return ret == 1 ? 0 : -EIO;
+}
+
 int ksm_wait_full_scans(long nr)
 {
 	long start_scans, end_scans;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 7e00030077d2f..ab1325dc65800 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -163,6 +163,8 @@ long ksm_get_self_zero_pages(void);
 long ksm_get_self_merging_pages(void);
 long ksm_get_full_scans(void);
 int ksm_wait_full_scans(long nr);
+int ksm_get_smart_scan(void);
+int ksm_set_smart_scan(bool enable);
 int ksm_use_zero_pages(void);
 int ksm_start(void);
 int ksm_stop(void);

-- 
2.43.0


