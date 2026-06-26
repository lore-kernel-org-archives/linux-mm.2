Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AA4AC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 12:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4DE36B00BB; Fri, 26 Jun 2026 08:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFF886B00BF; Fri, 26 Jun 2026 08:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B146D6B00C0; Fri, 26 Jun 2026 08:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88E276B00BB
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 08:59:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C7AC40474
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:59:23 +0000 (UTC)
X-FDA: 84922069806.10.4844FEB
Received: from va-2-115.ptr.blmpb.com (va-2-115.ptr.blmpb.com [209.127.231.115])
	by imf26.hostedemail.com (Postfix) with ESMTP id 72CCA140003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:59:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=cXV2aLWt;
	spf=pass (imf26.hostedemail.com: domain of wangyijia.yeah@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=wangyijia.yeah@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782478761;
	b=3JCmmknY7PYkJDL4/b+DKKSXRAjA0PPUjJy7NNsgsVS2xKAQvDkJAoUM1qnaSmw1lUsKNF
	DmRPvEwjrx0gUkUgx6gUFWWuiDtX7H8JyTuLs/rJt5QeA8LOBCoTbLoi/2riElbSJkYz1i
	FUtLEE7QMNm65F6lLNT3l6GlpKamg2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782478761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AL6ByXhQdtUtH0hlRBpSnP6WApmmsj9bwOb+UcTFFBE=;
	b=r2JX9yEoCFQaEjm8yJm+dBJw5Vzzqg2zwemvjYnaF7AqCSTZLwJ4gmm9kWsgsXDqMvtQqU
	y3KxFAb1UZBnQQICNkdjVBQ3dCPAk9st3R5cbKYK5P1uzH7fnd3nIx8Ji44Ry+NLZ3+DlY
	Yvzw41KqPQSk5y1u+B4I/3WjM3Sy1Y4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=cXV2aLWt;
	spf=pass (imf26.hostedemail.com: domain of wangyijia.yeah@bytedance.com designates 209.127.231.115 as permitted sender) smtp.mailfrom=wangyijia.yeah@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1782478753; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=AL6ByXhQdtUtH0hlRBpSnP6WApmmsj9bwOb+UcTFFBE=;
 b=cXV2aLWtGSdMFkqfvPa9DJuV9Ru0iFpapq/VaMDvMGuPRRmTHDOihyCyWRjK8zOlr5I61+
 R+7NktbvmC6+YD3tsNorBkh5EWk2TZR7IPoxyvn9hHf4m/psk7g+zTmmZBoH2ZJTsNTPfk
 FRDwIfT16xWq8vBwpK6csTMZPe27H6nrhjX/H7nziES/JuCDFhyJjPw3yTQsXE3SugfDX+
 vBAna8ZgHLQZehENGe1kGiKNNzRMtxrM0h9LkLq9aM+yOnNOdivUGyUlzDCW7XqcLoAMan
 zTDd1FjdFNJbDvc6oIr0iNacnzqagWv/LrRY70TpZKcL5bM3mZ1KcbjmSTpJMg==
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <shuah@kernel.org>, 
	"Yijia Wang" <wangyijia.yeah@bytedance.com>
Date: Fri, 26 Jun 2026 20:59:02 +0800
X-B4-Tracking: v=1; b=H4sIAJV3PmoC/x2MQQqAIBAAvyJ7bsGsPPSV6KC21R7SUKhA/HvWc QZmMiSKTAlGkSHSxYmDr9A2Atxu/EbIS2VQUmmplUbb48HehUh4fgHdqAxJ1y16INtCDatf+fm n01zKC08V+qVkAAAA
Content-Transfer-Encoding: 7bit
From: "Yijia Wang" <wangyijia.yeah@bytedance.com>
Subject: [PATCH] selftests: mincore: use default huge page size for hugetlb test
Message-Id: <20260626-b4-mincore-preview-v1-1-5f07aa02ab32@bytedance.com>
X-Lms-Return-Path: <lba+26a3e779f+bc767a+kvack.org+wangyijia.yeah@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Mailer: b4 0.13.0
To: <linux-kselftest@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yijia Wang <wangyijia.yeah@bytedance.com>
X-Stat-Signature: 8wh6c8bxq44g5oa1kkm5jxdzwb47r9zf
X-Rspam-User: 
X-Rspamd-Queue-Id: 72CCA140003
X-Rspamd-Server: rspam02
X-HE-Tag: 1782478760-506736
X-HE-Meta: U2FsdGVkX19idylOuPWDUU8DXEkbYx2U/WQwUDYzVXfEzewDFZsWgtIDK1KSpTUr1RsHdh9C9P5e8nWI4S+kTFNalY89VQGQOaZW+6dasEDSuTbUzgVMn8y3vWwMiTjLujjt0zdu5oRyYY8UVw+42VY90x1iHeO6BvuZVkJRvEF51KKU3sp55PGnpaap5KFZNCTjzf488UopW9kOy6p6WE0kJwtcbGiwKJEst2QWxsZZOMRPBCZoR3UWsmQRV+nol4+e+jAWwJg/1qQXhzl2oxzp0zfC8/EwXEAq+bxZ/UWgq8fUHksRXUKpFWu2xrQtr2sk1LMf6fcVAqUhhc18VNXu77ULZHVlFgOqe0kmeYbIXfQV40xU8EV8rq5QwrY+OXE/t61i2Rhi3rwPxnyGzdPGoJxewZSEYLZUKGTFlrqzqi3wFSS2QYjiNwzgCeuys+aLbxpQv4JjJXBKExRHXNcB+OnYhWmwjx3LmIzRv5ilPnw0nHE4PNWHL4COQ+aLrokS4F5PRrkXERqwFcJHsbXA7o4QiuNx2uJJJgGvA22SdIX7bASTeEIyROskpG4TdXwBnuN91kFxEizswr563cmhLqAsJR/TwXi/FrPQMt+IymOoIF5/OL1Ob46DxiHeR1izo7JkiLdGf7FnUrzGggN0kPaGWA98z3fEbjXBuC3hPl/sGlsPQmKvXLmKzJisbEQIkWU9qz13eDOM0OdVpzdC5T9ggvqUpJDg3U45z7vFCrkfYjXg3sm+hANs0QUv5nI542YBniHfcz/eyJjl9cZQ+/MvygNxdFFNpCn/eTH62zK2JTRd1jGUaEIEdTErZnfVRG2OS0+qdVqmPj9gM5p8wMlGXvORaJbRNxQ5XR6niyns6buqaObiads0FITzQVIhZvjGgW2RnhRzC9bHhr8/OWRmgCrckOAX6555NUm/k3zaauwtgEL8/pjuGE6XAYszh/LjpXp21TTta1g
 Ufngg9SK
 vXiDHNnL5pSwK5T9AXfQHIbPf6rfs2aR/yvirhQxF7Mnah8xhe9mP/BBOZEe2U+5Pyh+HfTtppo55JuCayI1wE8nmqaBzwyC3ZEq1Aj6Vh8mmCLP7KynYcouNUAByG4EAHZtmRpRm86m7P7NBo8L47BkelNh38P/TQafqQtYIPVXMZ2QtTbRNIW5270e68RsC0Mv4hfDXP85RQkCzYhJwEoA33iag6KLr8wgfChsZ4f5wGy6E/PCjsZbY8J15UKCZ14bb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb mincore test passes the base page size as the MAP_HUGETLB
mapping length.  This works on systems where the default huge page size
is the same as the base page size, but mmap() can fail with EINVAL before
mincore() is exercised when the default huge page size is larger, such as
on arm64 systems with 64K base pages and 2M huge pages.

Use the default huge page size from /proc/meminfo for the hugetlb mapping
and unmap length.  Keep the mincore() check scoped to one base page since
the test only needs to verify the residency state before and after the
mapping is touched.  This also avoids changing the mincore() length to the
whole huge page, which would require a larger residency vector because
mincore() reports one byte per base page.

Signed-off-by: Yijia Wang <wangyijia.yeah@bytedance.com>
---
 tools/testing/selftests/mincore/mincore_selftest.c | 29 ++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mincore/mincore_selftest.c b/tools/testing/selftests/mincore/mincore_selftest.c
index cdd022c1c..cd51420d5 100644
--- a/tools/testing/selftests/mincore/mincore_selftest.c
+++ b/tools/testing/selftests/mincore/mincore_selftest.c
@@ -22,6 +22,27 @@
 #define MB (1UL << 20)
 #define FILE_SIZE (4 * MB)
 
+static unsigned long default_huge_page_size(void)
+{
+	FILE *f = fopen("/proc/meminfo", "r");
+	unsigned long hps = 0;
+	size_t linelen = 0;
+	char *line = NULL;
+
+	if (!f)
+		return 0;
+	while (getline(&line, &linelen, f) > 0) {
+		if (sscanf(line, "Hugepagesize:       %lu kB", &hps) == 1) {
+			hps <<= 10;
+			break;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	return hps;
+}
+
 
 /*
  * Tests the user interface. This test triggers most of the documented
@@ -139,14 +160,18 @@ TEST(check_anonymous_locked_pages)
 TEST(check_huge_pages)
 {
 	unsigned char vec[1];
+	unsigned long hpage_size;
 	char *addr;
 	int retval;
 	int page_size;
 
 	page_size = sysconf(_SC_PAGESIZE);
+	hpage_size = default_huge_page_size();
+	if (!hpage_size)
+		hpage_size = page_size;
 
 	errno = 0;
-	addr = mmap(NULL, page_size, PROT_READ | PROT_WRITE,
+	addr = mmap(NULL, hpage_size, PROT_READ | PROT_WRITE,
 		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB,
 		-1, 0);
 	if (addr == MAP_FAILED) {
@@ -170,7 +195,7 @@ TEST(check_huge_pages)
 	}
 
 	munlock(addr, page_size);
-	munmap(addr, page_size);
+	munmap(addr, hpage_size);
 }
 
 

---
base-commit: 1d5dcaa3bd65f2e8c9baa14a393d3a2dc5db7524
change-id: 20260626-b4-mincore-preview-2ae0c3d65eb1

Best regards,
-- 
Yijia Wang <wangyijia.yeah@bytedance.com>

