Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8EFC1099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:40:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D7666B00AE; Fri, 20 Mar 2026 14:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AE556B00B4; Fri, 20 Mar 2026 14:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C4C26B00B5; Fri, 20 Mar 2026 14:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C6866B00AE
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:40:37 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD5FE13A898
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:36 +0000 (UTC)
X-FDA: 84567307272.01.DB5F601
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id E075B40007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:40:34 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RwJM0zyZ;
	spf=pass (imf27.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774032035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6scTfZdpNdLDWYVNA+QDpQesm+T9ccRyDBvKNA1+6k8=;
	b=U6CBmA0r3Gs9MMoktYv/ujgKh97Q6dTI7RCihXP0hZl6YXR7QJhIS9d74TbkDbgdR7w0YI
	Vg0kNDPk/ofoPY0axnI+ukxrbRMSpNPV9tTz0xK393h1TzZX7+3FKaZg0bIbGQ0NqKFB6y
	xvooiY5saiCZCp8GszpkqCOYNmLCFr4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774032035; a=rsa-sha256;
	cv=none;
	b=qJHz9BGL7eNf+r4eYrlmB7kKPRbi/D8Syb93j7ioUBDAAL8be8yrdj05Fy5+PFk7GwzkXw
	3uJAIkalEOXL291FsSIHuGaRgdiWZNWsbGKucuB/UUoE2A4UequiJVcDpP7C9EzxtFermr
	ZN8uaPGV5+VBYy2N03xG1BVnifMdDns=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RwJM0zyZ;
	spf=pass (imf27.hostedemail.com: domain of audra@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=audra@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774032034;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6scTfZdpNdLDWYVNA+QDpQesm+T9ccRyDBvKNA1+6k8=;
	b=RwJM0zyZVJeknxpXS+wtU8qfRgE/XLSljMRG3WPkKC9/INOYMifMOxJlg2HL+wMeFPzssf
	e1Q45XC3hG8AfwVQageugV2XRWQRh6TwWHkGvEc0GXt5AYmwYfixFa5m5xekH4eebK9s0O
	+IbnZ7BNuKC0QDMAyuVimnIvoYwNTDA=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-605-5SC89gtyOjGTIYdEmEjR1A-1; Fri,
 20 Mar 2026 14:40:28 -0400
X-MC-Unique: 5SC89gtyOjGTIYdEmEjR1A-1
X-Mimecast-MFC-AGG-ID: 5SC89gtyOjGTIYdEmEjR1A_1774032026
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 847B21955F6A;
	Fri, 20 Mar 2026 18:40:26 +0000 (UTC)
Received: from fedora.redhat.com (unknown [10.22.80.202])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 204B81953944;
	Fri, 20 Mar 2026 18:40:23 +0000 (UTC)
From: Audra Mitchell <audra@redhat.com>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	usama.anjum@collabora.com,
	colin.i.king@gmail.com,
	avagin@google.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
Date: Fri, 20 Mar 2026 14:39:15 -0400
Message-ID: <20260320184010.759461-2-audra@redhat.com>
In-Reply-To: <20260320184010.759461-1-audra@redhat.com>
References: <f7fef55d-4334-4d1d-b6c6-b409fea7e2a1@kernel.org>
 <20260320184010.759461-1-audra@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: HZQbYMhKSi6XOGelqUH1SEqMTdpS5hyz5o1pp-GucS8_1774032026
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E075B40007
X-Stat-Signature: edp1c1tbayybj1owdw5o499wt6argh7e
X-HE-Tag: 1774032034-201898
X-HE-Meta: U2FsdGVkX1+Kh7NqRP9A2wZD4yWZr+ATWZGCj8mljP3WRnababZCbIQrLmZasQiwPuFmUFcfp9ralJbfnnO5w98ly13bQSvL9a4oG+X8voGRwovWKorqL/5oKneOSFzyNMewD9LRoYXl++DDLpXvtZeSTMJmzYzhpHvLeP9Je4rgHCIjeo7f7zrQ2BZgbLyiGmOCmj1PAWWSFEv0UErGeisHNbPUUEufSbKvjvvsl2vDQpjYieYAVpqYqDnZOFSK1kRGJXyt8fmCDO0+6FPew4XCBlwNSbE4m5aL/USAU0SyAzuOYcn/nxj5EyLTwec5KwgFQc654vDg5v11kYm4LDk5HPO1+1PubOaUmUHGzO/ARz6WExnE6kSWY7G47aYDmX/K1nxH1hBszfzuFvMPU8VXzVnb9I7xLlgsemTpBwvsEpVDDfG+6Zk5KWUk/xnqfPl5/b84fMAGNZ3k+uMmFsrShiWOelXCNedvpXHDqw9mhOTQ/iHztzK5HO5SGHnexnFyh5gUH32AWN72sQF5J2/c1eK2jUw1L2Fq/YSXp+fm3YBxhhk+gWYc5oDqEanVdNsUIiBT+cmgKH8HxbWuHIt7xa0OGqhYioVBJzuuReH+Gov51/X0M44bY51bBIbKd972AmxAnS5cnKKZ0aCnxs9huTRqJY+gSXrn/4d7yQm7NeGvk03L2IEmSynyYk6FLY/OnwBZJgSEaoPYp8acK37ZQI9ItvRsVBq4dJYDZ44KPPfmsSnGnrbY5yIADoOCPO24sJ9bf6oaA+ND/qHuf8KgdFpu2j18FcE858zhjprQdEO0wK33j9OcCaEZ/vfK+QGfVO6tNt9kn204Nnwq3CwYuoe8P+7Epf6mAZ2s3bX/o+c65F79QHjTc7iDG+3GaRIcoFCvkHkyKzbK1BSK201AvNq2aUx3uoodQEMKnHsQrA1KZEPEOkLBhtE3xk+3NzmvFfl9SNTsrp9OZZP
 Qf4+g5fK
 xvXyZrngDkvNgVlwyc0K4gSu8drA9M/LBYrWQAnFs/TKOwb0XG4o99lgrPJwQ9d2FAGnF76S6rEf4Ww1pNgfh0PwHBssHYIj6ip2qS05XHyH6fSinvnzHaNaijByJvnUM2qZrLqBLij4Urd5jRdxZfa/H4V0gK9TkeFj3VSTwCz9CTzI4LUN2nh3r2FBH61BAhNQz8fnA4gnEhxFFxMol8uctErOh+J13lXHy+9A3isSeShBG23pfvzaP0rRS5lbPtVqFz92YGAAsCZqgNlArYnxyC+96MqswOcFKpm42hnh2W5/Z0JkWeo6cUWZZUs965akB8m8BXejGfiaAwxFNj5VjVYNtaqgBlQ0NDwBnJMGyEq9vOSMETIoGFc8POphrCabYBZLHWeCe0YCeMgVbPSzCTpO7UPtT9693
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On architectures with separate user address space, such as s390 or
those without an MMU, the soft-dirty kselftest may fail when checking
to see if the feature is supported.

  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..15
  # Bail out! PAGEMAP_SCAN succeeded unexpectedly
  # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
  # [FAIL]
  not ok 1 soft-dirty # exit=1
  # SUMMARY: PASS=0 SKIP=0 FAIL=1

The soft-dirty test will initate an ioctl with the PAGEMAP_SCAN flag with
an invalid address for the page_region. This is done intentionally to
have the ioctl return with an expected EFAULT and with the correct
categories returned.

However, on architectures with separate user address space, such as s390 or
those without an MMU, the call to __access_ok (used to validate the
variables provided with the ioctl) will always return true and we will not
fail as expected.

        if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
            !IS_ENABLED(CONFIG_MMU))
                return true;

Let's simplify the check for PAGEMAP_SCAN and provide a valid page_region
address so that we get a non-errno return if it is supported.

Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")

Signed-off-by: Audra Mitchell <audra@redhat.com>
---
 tools/testing/selftests/mm/vm_util.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index a6d4ff7dfdc0..82998406b335 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -67,20 +67,26 @@ static uint64_t pagemap_scan_get_categories(int fd, char *start)
 }
 
 /* `start` is any valid address. */
-static bool pagemap_scan_supported(int fd, char *start)
+static bool pagemap_scan_supported(int fd)
 {
+	const size_t pagesize = getpagesize();
 	static int supported = -1;
-	int ret;
+	struct page_region r;
+	void *test_area;
 
 	if (supported != -1)
 		return supported;
 
-	/* Provide an invalid address in order to trigger EFAULT. */
-	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
-	if (ret == 0)
-		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
-
-	supported = errno == EFAULT;
+	test_area = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+			MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (test_area == MAP_FAILED) {
+		ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
+		supported = 0;
+	} else {
+		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
+		ksft_print_msg("errno: %d\n", errno);
+		munmap(test_area, pagesize);
+	}
 
 	return supported;
 }
@@ -90,7 +96,7 @@ static bool page_entry_is(int fd, char *start, char *desc,
 {
 	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
 
-	if (pagemap_scan_supported(fd, start)) {
+	if (pagemap_scan_supported(fd)) {
 		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
 
 		if (m == s)
-- 
2.52.0


