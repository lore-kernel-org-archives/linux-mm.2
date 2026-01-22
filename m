Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F66D3EE92
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 17:02:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13C676B02C6; Thu, 22 Jan 2026 12:02:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF6F6B02C9; Thu, 22 Jan 2026 12:02:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF7AC6B02C6; Thu, 22 Jan 2026 12:02:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D9C0A6B02C6
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 12:02:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 880E457D13
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:48 +0000 (UTC)
X-FDA: 84360219216.04.86DA6F0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E745C40007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:02:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769101367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jOnp+NnLby8vCQCRgossxSzkhcD0iaWyWZdZQuZv984=;
	b=qUsxxbb5wV/YAKo+l+egAPWvawGm2+Ru20L58RALz8Oki9JZLIfiC9BWuNLW7WPkWnbTxm
	BA7QhuR9H1vfeOU07ZlLTT/N2gS5vnn3JFTHVXnroe6+++UDkrzc386dfF9tuRBxLiL6/w
	BVz/w58fNIyapzRG95uodGukPeIU3L0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769101367; a=rsa-sha256;
	cv=none;
	b=AQ6C/CB+ZNVNpXgq2QG+24XPlG9K/WJRppfIclR/qopVzYZ+SxKLafXoAm8CijVfOBEl/V
	v+tltosAUm5ygga+SMcEP9sVOGpHdE6OuEQ9sEnzf5c2hOmWZLsJXJ4Azt+XqiMm8LXbD8
	rFiFyHCFd0eGJBAah/2YqDoR9vnll04=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C25DC1515;
	Thu, 22 Jan 2026 09:02:39 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DE9423F632;
	Thu, 22 Jan 2026 09:02:44 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Usama Anjum <Usama.Anjum@arm.com>
Subject: [PATCH v3 7/9] selftests/mm: fix faulting-in code in pagemap_ioctl test
Date: Thu, 22 Jan 2026 17:02:22 +0000
Message-ID: <20260122170224.4056513-8-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260122170224.4056513-1-kevin.brodsky@arm.com>
References: <20260122170224.4056513-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E745C40007
X-Stat-Signature: jsyzfm1cix6tdy913ohm4zia9rmi8phy
X-Rspam-User: 
X-HE-Tag: 1769101366-207294
X-HE-Meta: U2FsdGVkX1/yKc1ci54EsKRe30NNAPTYaLaUkoK8Xd9JUz4t2qb7i0u0358xyUWYtBcaiCeMkB++THmBt0iOwpTz5PZ9hCBx1suh/znsGJBGLaX0m2YDI0xlYCClK02oyj7OrYyKGyHvobC3C1tx4YcGs5OfFUGCqdQG7/QhIRh2vdP1XLLLQs12lSubxS+K8Uz41/elSAG5qYjCCOhtE1J9LBwGyN4To8UoDHxMUGTZSfZft0L5+ooBRSu9hX3hleUstuBAMz5L2eUry1TOf/KklGOjHqhK6UxScX+oNm55N9oD3Um7QW4NEVVbEBQqWCCzgu9fV69+KNSqHRQQy8moeqsmF01zOhBw88MmXujTzl4ZnoDQ6c4E0jpZ4SMBYQWP4UrXFJyaUgBJNya0Bal/GnBspxHrwEbfb5ZtcTZbDXqY4pjQGI7dKfzv3j4OCwA0nelD3OdXJqFAF7ZDZ/WqTgdeExRwsS7gnGL+10rql+r34F/iTJhduYX1lFulNLZyL/QNgiNy7Hjw0aKM5BMKgSx/VSgtMV/whOEZvXs8EBULKc8JUc4EOrzOUtd9pJfToi+thcwg0ZcXrDQclczmPk42Kx6cNEXEmhJooI8MSMUKcF6v975DRVkQR513c/yI4ByTsmRCCO8x2zpkwhstICtZHIVp7eksoh8T6RvF+TLskLPhNoE+hxgkyeAeFGRtC9bkraCe8atBxtrUgeT1sacsSf4hLyYN7/P+wX1XQaaLU5ne0KSNbW0+8WPGjoanj5uZX+a+8CWRlYchlldXWmZd48ZkcyIWIS+ALII/EJuJB1ktdICUI6lb64MBHftAkr2wIhabCMh85XwtZJgBd5rfBo0kN4ZNN1gWlZ8zC2F98F+DhjSNnZcYDL8tSodXdtzPmwaDZzEXuhYc1mKRH4RZEKlYGLAm/IVGrmSmRP6t2uWlGNoyS5Zy6wN6sttDcdnAUdgWG0IzUVA
 12xmIqM+
 MFQ+u7/GE4kFmPl60LgpGYIh/4yAH2BMH06noRFYJ/qhUwPpLNqSENO27U3JdK5JhGFSLxzKCsczWSgE5+FPDBvm85EQcPvMW/QGRZnT+rmYCDLyyIqg6v74pds/yKuzlh1Gf9buP6QKEn9e337TYHkg01qH387wCJY+QG5hDc+JRJM8mlgZB4EbgAJSWWM2dTeHnk6lZ0ZhLHCkaHmCDQhMNtLAlujlwcyKE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One of the pagemap_ioctl tests attempts to fault in pages by
memcpy()'ing them to an unused buffer. This probably worked
originally, but since commit 46036188ea1f ("selftests/mm: build with
-O2") the compiler is free to optimise away that unused buffer and
the memcpy() with it. As a result there might not be any resident
page in the mapping and the test may fail.

We don't need to copy all that memory anyway. Just fault in every
page.

While at it also make sure to compute the number of pages once using
simple integer arithmetic instead of ceilf() and implicit
conversions.

Fixes: 46036188ea1f ("selftests/mm: build with -O2")
Cc: Usama Anjum <Usama.Anjum@arm.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index 2cb5441f29c7..1896c7d4f72e 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1052,11 +1052,10 @@ static void test_simple(void)
 int sanity_tests(void)
 {
 	unsigned long long mem_size, vec_size;
-	long ret, fd, i, buf_size;
+	long ret, fd, i, buf_size, nr_pages;
 	struct page_region *vec;
 	char *mem, *fmem;
 	struct stat sbuf;
-	char *tmp_buf;
 
 	/* 1. wrong operation */
 	mem_size = 10 * page_size;
@@ -1167,14 +1166,14 @@ int sanity_tests(void)
 	if (fmem == MAP_FAILED)
 		ksft_exit_fail_msg("error nomem %d %s\n", errno, strerror(errno));
 
-	tmp_buf = malloc(sbuf.st_size);
-	memcpy(tmp_buf, fmem, sbuf.st_size);
+	nr_pages = (sbuf.st_size + page_size - 1) / page_size;
+	force_read_pages(fmem, nr_pages, page_size);
 
 	ret = pagemap_ioctl(fmem, sbuf.st_size, vec, vec_size, 0, 0,
 			    0, PAGEMAP_NON_WRITTEN_BITS, 0, PAGEMAP_NON_WRITTEN_BITS);
 
 	ksft_test_result(ret >= 0 && vec[0].start == (uintptr_t)fmem &&
-			 LEN(vec[0]) == ceilf((float)sbuf.st_size/page_size) &&
+			 LEN(vec[0]) == nr_pages &&
 			 (vec[0].categories & PAGE_IS_FILE),
 			 "%s Memory mapped file\n", __func__);
 
-- 
2.51.2


