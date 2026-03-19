Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC86A109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:07:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EBC76B052A; Thu, 19 Mar 2026 12:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2BE6B052C; Thu, 19 Mar 2026 12:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D9446B052D; Thu, 19 Mar 2026 12:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B1A76B052A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:07:46 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B72A81606C7
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:45 +0000 (UTC)
X-FDA: 84563293290.10.73EF810
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id CDF0E180017
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ePJFi7ww;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m14eZlieSHU0U3GZgc7YUIvhhsIX8Oki0rAROpoPAiw=;
	b=XVoQHDU0N/yImtnuQgqSNvrFAUy2MtkFxcYp37YUvop+emeCF7P7L8YSt1X1em3+jgio5d
	9Wu9UQEXUZZOXn2xiGgc2Bb5fuCd7/K8U/SCo4X1O6FgxUdAuPc4m+mH5SSjQg9o/QUzyW
	7Ac9E68QbEa2OPbe1A+Zd0Aa/BvrjzE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ePJFi7ww;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936463; a=rsa-sha256;
	cv=none;
	b=Vb77N21UTJwwvyxwpzHms9IL0dKQsWBcW99honC9K4yOlA7MYT6TowRjZaiLhT7zS1fx75
	0O8CKYQaCwNGXxRhNvDmmd3HLMX03xqfxsRv4zM3Qzy+l7v+LzcGu4iubp4hbK9NdKbBhO
	31n0tWmV9ivnAz4FxB/y8wHfRHsHa/I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773936463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m14eZlieSHU0U3GZgc7YUIvhhsIX8Oki0rAROpoPAiw=;
	b=ePJFi7wwphbIKb21ZReAIVSyMV4nctqniKB2fxCLTSpCLfsC2dTx4dOaLMyahDh91fvcjn
	zkntqbul5wQQ9BLTg+zApRfxce+o+ocmJ0y9V9HYE6SBL6Z7hyqoN1dGU2iYsP1pXHJ6p2
	vMsVqQ36S+BD6LENiYm6VZLUd0BuL+s=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-644-mB9W2BwHN9-P0j-nC7uCPQ-1; Thu,
 19 Mar 2026 12:07:39 -0400
X-MC-Unique: mB9W2BwHN9-P0j-nC7uCPQ-1
X-Mimecast-MFC-AGG-ID: mB9W2BwHN9-P0j-nC7uCPQ_1773936456
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BF8FE180060D;
	Thu, 19 Mar 2026 16:07:35 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0616A30002DF;
	Thu, 19 Mar 2026 16:07:27 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com
Subject: [PATCH v4 3/5] selftests/mm: move write_file helper to vm_util
Date: Fri, 20 Mar 2026 00:06:54 +0800
Message-ID: <20260319160656.1480279-4-chuhu@redhat.com>
In-Reply-To: <20260319160656.1480279-1-chuhu@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: drx_vj-A-sDYXuSLFGFB9iUSEX2NRQLltNDXlJKCINo_1773936456
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CDF0E180017
X-Stat-Signature: ctx6cc8r36s8fyook53oob56z3qjxdyh
X-Rspam-User: 
X-HE-Tag: 1773936463-713464
X-HE-Meta: U2FsdGVkX1961jsB04dt+xhV6GwSL2qoCiKCprZNsE6XZjvcQPBitsQapvhuXfUsGgKbeJH7U6jJblcv36ZCud56gen67N9Sd89YUvXqoReeOsInEaBiYk4hp0wswsXS62iuFkcbnAUOqHn9EkQ1MMVvY2jVGI6ah9pCj4BhygP9yJMBnkpr4QeFODypv0SyCLuvaBs1iUp8lpacq6ndaVIt8fOmWuSVTuE+jazZ5XHRandq0RcajVXNbBfuLKLbQfFnavjmrF4eosYZoWu3q1mi9cnOCZXIiyYJrLLk4NoTLJ9A4Hvk1TkwaAC7ETMJWHv1zPf9d0E4KWVR/qT4b+vImEZt0lVauiT3h/G9r3wi6pEJ0lIkrR/j4CJ2XOAl8iNkgQiYspsXs99dIfOgDeKEbJmnEHSK+UC58rIcN8QFvCTsuDG2KtR4B5pA1bFk8UE/IR4apuerr6hdneaGcCzyWe9QGZP4v6f+4vinE5jRTYJbgBIIvCmA8Zmj895tMIYx3JpF5bV8kK2h/12hFwWwRhQMAUBUwEaZGMBQdBqHuP14Ghht0TIfwMwIUN/lfDDg6DAqQXSSJl4jv0VYDAL7nUg4fG7tthk6CA6echkAmR58qxdoLp8QdxeAfdb9+bnf+1xFivik7RpIcQmB0woGrffKjOa77tB0M7hOCRGPtAj0d3UqTZpMTiUvGjHh/rDo8vV+ctSBKOaesojNYZ/qZs3vPc0Xvtbc5t/7nvSRzZrFC/cqUmEZfGTqRIMH4dcCf/JlNv1E4EF5C4ed6w6C4+6XKMkL734iCpDTRPtguWgAwViIVO2y/t2VScFctJsyZtLWis4eBtniluOtuSsxQayjbBySgVUHXAmedj6NjTC8umAPgm5KA/2LGHxHKuEyRP1Hbvmje96HCSLeFq7GJhoBcPmSZuLRoKzOd80HDRlIeDViIWKvmYIhPNki4ERAQf18+BL4JIACv5L
 neHinYj5
 jGqWQlvRUCZ8hJ3xGwy7q/bJpjFKPIxj/uIEat/5VwxbOeBF6TFEigGYhX0U7VWRJrApcM29bsawluyPuJLEtc41or4jrQhIne+yWIgRaK1DBntD1LJLISrY1Hp50y/gmtucU01EK4BnUBtClalrudNnGS6TdV+UJitlMT1dd0YmDnQoEfBGV+T7Jau/XmBnpr3xqXvv6P/iIXCtkKuZUgrYLa6khWG8vOYua70bVa1P3xWotd3zxUdXkpEN1KUM0MfUYzVvuMx1Zkmcqv1tGWYxdDjzqMeIKfZ7Opnz2S+C3JEL+YmlMRqpOOeIL8dSp7kF9vUiPDquXMS/ehUQwrYbZYeDQn7+m6yWhpSmUdYqy6BD6Zsuf8k+EnF/FkMAWWJVHpC9e5QL73Y1jMqxLUEcP/uCyGuulpz8w
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

thp_settings provides write_file() helper for safely writing to a file and
exit when write failure happens. It's a very low level helper and many sub
tests need such a helper, not only thp tests.

split_huge_page_test also defines a write_file locally. The two have minior
differences in return type and used exit api. And there would be conflicts
if split_huge_page_test wanted to include thp_settings.h because of
different prototype, making it less convenient.

It's possisble to merge the two, although some tests don't use the
kselftest infrastrucutre for testing. It would also work when using the
ksft_exit_msg() to exit in my test, as the counters are all zero. Output
will be like:

  TAP version 13
  1..62
  Bail out! /proc/sys/vm/drop_caches1 open failed: No such file or directory
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0

So here we just keep the version in split_huge_page_test, and move it into
the vm_util. This makes it easy to maitain and user could just include one
vm_util.h when they don't need thp setting helpers. Keep the prototype of
void return as the function will exit on any error, return value is not
necessary, and will simply the callers like write_num() and write_string().

Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v3:
  - make the write_file void return
Changes in v2:
  new patch from v2
---
 .../selftests/mm/split_huge_page_test.c       | 15 --------
 tools/testing/selftests/mm/thp_settings.c     | 35 ++-----------------
 tools/testing/selftests/mm/thp_settings.h     |  1 -
 tools/testing/selftests/mm/vm_util.c          | 15 ++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 ++
 5 files changed, 20 insertions(+), 48 deletions(-)

diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
index e0167111bdd1..93f205327b84 100644
--- a/tools/testing/selftests/mm/split_huge_page_test.c
+++ b/tools/testing/selftests/mm/split_huge_page_test.c
@@ -255,21 +255,6 @@ static int check_after_split_folio_orders(char *vaddr_start, size_t len,
 	return status;
 }
 
-static void write_file(const char *path, const char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numwritten;
-
-	fd = open(path, O_WRONLY);
-	if (fd == -1)
-		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
-
-	numwritten = write(fd, buf, buflen - 1);
-	close(fd);
-	if (numwritten < 1)
-		ksft_exit_fail_msg("Write failed\n");
-}
-
 static void write_debugfs(const char *fmt, ...)
 {
 	char input[INPUT_MAX];
diff --git a/tools/testing/selftests/mm/thp_settings.c b/tools/testing/selftests/mm/thp_settings.c
index 574bd0f8ae48..e748ebfb3d4e 100644
--- a/tools/testing/selftests/mm/thp_settings.c
+++ b/tools/testing/selftests/mm/thp_settings.c
@@ -6,6 +6,7 @@
 #include <string.h>
 #include <unistd.h>
 
+#include "vm_util.h"
 #include "thp_settings.h"
 
 #define THP_SYSFS "/sys/kernel/mm/transparent_hugepage/"
@@ -64,29 +65,6 @@ int read_file(const char *path, char *buf, size_t buflen)
 	return (unsigned int) numread;
 }
 
-int write_file(const char *path, const char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numwritten;
-
-	fd = open(path, O_WRONLY);
-	if (fd == -1) {
-		printf("open(%s)\n", path);
-		exit(EXIT_FAILURE);
-		return 0;
-	}
-
-	numwritten = write(fd, buf, buflen - 1);
-	close(fd);
-	if (numwritten < 1) {
-		printf("write(%s)\n", buf);
-		exit(EXIT_FAILURE);
-		return 0;
-	}
-
-	return (unsigned int) numwritten;
-}
-
 unsigned long read_num(const char *path)
 {
 	char buf[21];
@@ -104,10 +82,7 @@ void write_num(const char *path, unsigned long num)
 	char buf[21];
 
 	sprintf(buf, "%ld", num);
-	if (!write_file(path, buf, strlen(buf) + 1)) {
-		perror(path);
-		exit(EXIT_FAILURE);
-	}
+	write_file(path, buf, strlen(buf) + 1);
 }
 
 int thp_read_string(const char *name, const char * const strings[])
@@ -165,11 +140,7 @@ void thp_write_string(const char *name, const char *val)
 		printf("%s: Pathname is too long\n", __func__);
 		exit(EXIT_FAILURE);
 	}
-
-	if (!write_file(path, val, strlen(val) + 1)) {
-		perror(path);
-		exit(EXIT_FAILURE);
-	}
+	write_file(path, val, strlen(val) + 1);
 }
 
 unsigned long thp_read_num(const char *name)
diff --git a/tools/testing/selftests/mm/thp_settings.h b/tools/testing/selftests/mm/thp_settings.h
index 76eeb712e5f1..7748a9009191 100644
--- a/tools/testing/selftests/mm/thp_settings.h
+++ b/tools/testing/selftests/mm/thp_settings.h
@@ -63,7 +63,6 @@ struct thp_settings {
 };
 
 int read_file(const char *path, char *buf, size_t buflen);
-int write_file(const char *path, const char *buf, size_t buflen);
 unsigned long read_num(const char *path);
 void write_num(const char *path, unsigned long num);
 
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index a6d4ff7dfdc0..ad96d19d1b85 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -764,3 +764,18 @@ int unpoison_memory(unsigned long pfn)
 
 	return ret > 0 ? 0 : -errno;
 }
+
+void write_file(const char *path, const char *buf, size_t buflen)
+{
+	int fd;
+	ssize_t numwritten;
+
+	fd = open(path, O_WRONLY);
+	if (fd == -1)
+		ksft_exit_fail_msg("%s open failed: %s\n", path, strerror(errno));
+
+	numwritten = write(fd, buf, buflen - 1);
+	close(fd);
+	if (numwritten < 1)
+		ksft_exit_fail_msg("Write failed\n");
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index e9c4e24769c1..1a07305ceff4 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -166,3 +166,5 @@ int unpoison_memory(unsigned long pfn);
 
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
+
+void write_file(const char *path, const char *buf, size_t buflen);
-- 
2.53.0


