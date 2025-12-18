Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38BEAD68BCA
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 00:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED7B6B0088; Wed, 17 Dec 2025 19:59:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A51F6B0089; Wed, 17 Dec 2025 19:59:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8596B008A; Wed, 17 Dec 2025 19:59:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2DA6B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:59:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF6751609AA
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:59:01 +0000 (UTC)
X-FDA: 84230782482.02.A52D15F
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0BFFFA0008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:58:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m/yKrYt5";
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766019540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FLWdrmcOXEsn7JZI2AfrrHLsKmuHiuoeH/04si3RGkU=;
	b=JY/tvo2xVENy6P+iEIJ6oYPuwuQmvF8IECb9QuFTdXkUM2kpC/diwuUcNFJ49rVQv7s0aF
	0s/yQ99sq92RA96YhgzfH01IdpEhvw45WaB9cufJV625azqoqKgog7HbDWErGmRhaD1tu6
	G7UbIUPfkGGsSRg2rhMCpSfgGN/n9wk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766019540; a=rsa-sha256;
	cv=none;
	b=qK/SBQ9U5wewiYibCoCU09GpInWv19uQU5T7Gag+cUFWjdEnuLFetDCocOikbjod2ikNvD
	XAb8PNeoXNQWWnDCCNBePK2wZJ2U8/kmKGGv9bnJFUpjVUD1pVaZN2C5nTdwGSyEtpGGjv
	wo6VuUiPCa8tsO62vvp7zNi3J/TLaqQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="m/yKrYt5";
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766019537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FLWdrmcOXEsn7JZI2AfrrHLsKmuHiuoeH/04si3RGkU=;
	b=m/yKrYt5HoWNtJeA+j0Hu6aLAMgMu5AjYG/IguQGaktUvPC9JVFLH5YTW/m41v4Hw1xukx
	+aY+Y1OcgfnlcYm7X4kxfHQ8JEeRiheY9gAK4XdGIq8wJsz/y+03u4JQdkVV61P4CctyzD
	thnzVrGb6eGQf7nMKPFxWbONYzedpgY=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrii Nakryiko <andrii@kernel.org>
Cc: Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Meta kernel team <kernel-team@meta.com>,
	bpf@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: [PATCH] lib/buildid: use __kernel_read() for sleepable context
Date: Wed, 17 Dec 2025 16:58:18 -0800
Message-ID: <20251218005818.614819-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 374f5i4oyn4hbotpg4xqq8xm7mac1rd7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0BFFFA0008
X-Rspam-User: 
X-HE-Tag: 1766019539-852294
X-HE-Meta: U2FsdGVkX18Q6hpNVEKhyimn9P5juKRcO/8DJnxbfSaLqQsiuNJvtqIIlHprx0TR7YxN7PmCQ+/cVsJRPtOHGH2Ak92Fg+3+iHZ8U32ln3/UPHpt+oYOWJYTz9k19hMUvREygOUwMXLdPKEgxnPw2LkVDFd9Z39vZ4OsaFlA/ciPXRp+Doxu0bgb7JobIgyvrUIznSvbrLG1/RN8p7+xVTp9f/LMAzwhX6e98mSF6xqQzzUvY/c8kdnvTGeUqKDWj8OYK7W9XBldCa4iKcauOGL7Ks2Wae9BR1OK9s84bxhx8Iu/he3x8OkNhiBlx5l1xUX31pU9LzCGEhQEq/PSU7QmghedxMFpLhO+i1GtEBwZBrodUhLFE/69f4/hmMjOI6fwRJ2FkOWmb4gwwK+RkzbnAu3G9g13x6bi70qzrPN0/q0zQAhx47vsdIb3vdpaLPbV4s0v41gGmriMNxcR3ydJ64nJ5SSxko8unyapPxv7F59RFUHOK9T7BGrLvGWen4fLiRxcdJbSb3mHwJ6BuXeAt4PdcNaqqsCvKHnBjbW81Z5OYw+TEbR1f/nFivNlcxxqta9V69DgKjY2Dq5MpfG8OjyQqrJgT+9hJ/crWPcn5GL/Nm6zeGbgHbTlTGh3hc/jFI/H5uDhGHdI4jeE81ADGwOiVJXoB9YtEHraursZsHx6fY3HMNIPN6WNBLPwFKTG7Ws7CYIamf90tx7nES+XWFiMEFvh2HxKYi+QkEc17Z+Dc13oXurlcxa27nf1Qbz+ZLzLEuYjWL0gKQv6aoTU4NlccVIrVHHHXfBjchhcddQN0wA5RvJ5fKbb9qPhaWG/S5VLa2T7l3+xZDZ+AIAQUd6MJ9fJi50XN09diRX08IEUDY1/3aBVVdF9bfryS3eU94By7WOGsz+ffr00IaYtnpJqn+sbArzivDXKuYbkSRt36CoPwfMdW0Bmr9f3bZT8XzWSrtl4HuqksoL
 TN7HwrjY
 Txo9TNMBRkhqioGtAiCrMy5R4a35EbwB6DwXPRWOTIYO+vgYkC1/sudECa/z+Bt853x0rKVcWRAEOccVcHBR5gFOlKWvXbpdDzASnJprq/Os31uI4FFqJw8fYCUv2EhthUZts43vJwbjQvfWYi1B9xsyYnWl6dn32zt0rwa141aPz2tb/aLEIi/eM1ViiaW3LwNNkVbeGXfCMa26iXu7MkQai6VxSBIuHfnCuJs3qXihSdOB94Hl5T2hKThInYYAMTY/Lgc1fQoz3qCZE8kihsN2VVMjuiZ2AEQxna90jaw50k5rxExdGTsdXNbbQLgICagE/Zglz798LZaFTqQF39IcuYGYAFndFMfKOZhdX62w3mPf2RKPkYsvwNqmh+TFdnlVt0zovifz7bQuZf+R4FhMcaPQxkxJMobj3fa39PW+qwbHBf9JhLOHqnYi377PZBCYInezR3fZt9oZRbhEdNAeNag==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the sleepable context, convert freader to use __kernel_read()
instead of direct page cache access via read_cache_folio(). This
simplifies the faultable code path by using the standard kernel file
reading interface which handles all the complexity of reading file data.

At the moment we are not changing the code for non-sleepable context
which uses filemap_get_folio() and only succeeds if the target folios
are already in memory and up-to-date. The reason is to keep the patch
simple and easier to backport to stable kernels.

Syzbot repro does not crash the kernel anymore and the selftests run
successfully.

In the follow up we will make __kernel_read() with IOCB_NOWAIT work for
non-sleepable contexts. In addition, I would like to replace the
secretmem check with a more generic approach and will add fstest for the
buildid code.

Reported-by: syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=09b7d050e4806540153d
Fixes: ad41251c290d ("lib/buildid: implement sleepable build_id_parse() API")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 lib/buildid.c | 47 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 35 insertions(+), 12 deletions(-)

diff --git a/lib/buildid.c b/lib/buildid.c
index aaf61dfc0919..e7e258532720 100644
--- a/lib/buildid.c
+++ b/lib/buildid.c
@@ -5,6 +5,7 @@
 #include <linux/elf.h>
 #include <linux/kernel.h>
 #include <linux/pagemap.h>
+#include <linux/fs.h>
 #include <linux/secretmem.h>
 
 #define BUILD_ID 3
@@ -37,6 +38,29 @@ static void freader_put_folio(struct freader *r)
 	r->folio = NULL;
 }
 
+/*
+ * Data is read directly into r->buf. Returns pointer to the buffer
+ * on success, NULL on failure with r->err set.
+ */
+static const void *freader_fetch_sync(struct freader *r, loff_t file_off, size_t sz)
+{
+	ssize_t ret;
+	loff_t pos = file_off;
+	char *buf = r->buf;
+
+	do {
+		ret = __kernel_read(r->file, r->buf, sz, &pos);
+		if (ret <= 0) {
+			r->err = ret ?: -EIO;
+			return NULL;
+		}
+		buf += ret;
+		sz -= ret;
+	} while (sz > 0);
+
+	return r->buf;
+}
+
 static int freader_get_folio(struct freader *r, loff_t file_off)
 {
 	/* check if we can just reuse current folio */
@@ -46,20 +70,9 @@ static int freader_get_folio(struct freader *r, loff_t file_off)
 
 	freader_put_folio(r);
 
-	/* reject secretmem folios created with memfd_secret() */
-	if (secretmem_mapping(r->file->f_mapping))
-		return -EFAULT;
-
+	/* only use page cache lookup - fail if not already cached */
 	r->folio = filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT);
 
-	/* if sleeping is allowed, wait for the page, if necessary */
-	if (r->may_fault && (IS_ERR(r->folio) || !folio_test_uptodate(r->folio))) {
-		filemap_invalidate_lock_shared(r->file->f_mapping);
-		r->folio = read_cache_folio(r->file->f_mapping, file_off >> PAGE_SHIFT,
-					    NULL, r->file);
-		filemap_invalidate_unlock_shared(r->file->f_mapping);
-	}
-
 	if (IS_ERR(r->folio) || !folio_test_uptodate(r->folio)) {
 		if (!IS_ERR(r->folio))
 			folio_put(r->folio);
@@ -97,6 +110,16 @@ const void *freader_fetch(struct freader *r, loff_t file_off, size_t sz)
 		return r->data + file_off;
 	}
 
+	/* reject secretmem folios created with memfd_secret() */
+	if (secretmem_mapping(r->file->f_mapping)) {
+		r->err = -EFAULT;
+		return NULL;
+	}
+
+	/* use __kernel_read() for sleepable context */
+	if (r->may_fault)
+		return freader_fetch_sync(r, file_off, sz);
+
 	/* fetch or reuse folio for given file offset */
 	r->err = freader_get_folio(r, file_off);
 	if (r->err)
-- 
2.47.3


