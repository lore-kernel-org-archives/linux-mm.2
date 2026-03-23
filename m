Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 798A3F4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53106B0093; Mon, 23 Mar 2026 11:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A456B0095; Mon, 23 Mar 2026 11:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D67B76B0096; Mon, 23 Mar 2026 11:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C74F06B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:18:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7C739140949
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:43 +0000 (UTC)
X-FDA: 84577684926.06.96A8A4A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9A452140002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:18:41 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YOTuWdey;
	spf=pass (imf09.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YOTuWdey;
	spf=pass (imf09.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774279121; a=rsa-sha256;
	cv=none;
	b=KTZ7K81962/YMi1chXu7X639s+jUETimX5gtqTVBeYHkMDx6wtzR6crQhV8tuEBspbjK0b
	eZDtozIOtdqWzUSPGdILgJwg/8WQQb+/HZSopRXM2mhBzU2W80qlaeOrjMV1Sot6+Q9sKt
	ShUdG8e0xavwuT34KDu2kisuu5CZwik=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774279121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9yceaFKZVBDF6JEZ2vLeDlRB6dW1GshHGmSjH6pnVzE=;
	b=sw49J2gtlL8MOP3x1rsLeyjufNM+fCfzUJStARO4kCZQKzNiWl1n8lAQGfhfcPwLNDNTvE
	ovP0sZydi5nVKQiwZNUVf215QLFru+fTsq31Yet71QngFxrwgiu+uzjwGLF2H8V0e3au18
	0YBU8jijZWhYymb7bUojwb3sezC1vlQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774279120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9yceaFKZVBDF6JEZ2vLeDlRB6dW1GshHGmSjH6pnVzE=;
	b=YOTuWdeyMZ8avnDvAWzpJLwIvQs4JuE8AciwRJohTZuK0F+P0t0kg7DlY22Eln7lh41WCw
	t5ChKFpoaSVVd9EZ+4AnVulkuQUxOC6b9xXX9E9a24YgzKxhfS+z74ZH6umk+YfyKvAuHV
	T54Vk3Emi+CNSuZmrjhLfUqCRXrpMqw=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-466-xBrg_OwWNa2nq4sZM98mmw-1; Mon,
 23 Mar 2026 11:18:36 -0400
X-MC-Unique: xBrg_OwWNa2nq4sZM98mmw-1
X-Mimecast-MFC-AGG-ID: xBrg_OwWNa2nq4sZM98mmw_1774279114
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E084919560A1;
	Mon, 23 Mar 2026 15:18:33 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 13DD71955D71;
	Mon, 23 Mar 2026 15:18:25 +0000 (UTC)
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
Subject: [PATCH v5 3/6] selftests/mm: move write_file helper to vm_util
Date: Mon, 23 Mar 2026 23:17:50 +0800
Message-ID: <20260323151753.2576137-4-chuhu@redhat.com>
In-Reply-To: <20260323151753.2576137-1-chuhu@redhat.com>
References: <20260323151753.2576137-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: S6EBVTgxFoqLZ6wfITblh5RpOCacBcmjgn-GcC_Fnco_1774279114
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A452140002
X-Stat-Signature: hgmdd9ing734eikgrrrugnmhngzumy4x
X-Rspam-User: 
X-HE-Tag: 1774279121-517171
X-HE-Meta: U2FsdGVkX18PzW82RsYd9O8ceeLKT9c2TtndGbJmNi3rNE2gDSoLHm01DcFdw22sAFIprurLQjQzwqePHS2Utc3w2Xrz8v58RsUbbjwiB42R6cMFfBzGgmhMR8LuCdnmzAC4j+81XpnKsbMQtiOrynnwDVo9Bf4z0EuWveVUopYmHP5Hkrqzt46im8QFX4v9dC7XEGMkr5ptVbONFGrIYP5uz2sAH/KuIw1wvEVUGZU3Z9j0OdOw/nUw2b7N6jucMReR/3LW599tSS5sFPJnYCxJCLqnwj+IEP3wQLtn2w2B0x3cPwhMPTOu5Yqqt21kFjjlwHDJhgabmzL25FDm4kkArFe3ynJa1NX6KFUpsAWvui7vpvea3D+EauZnQi4/V/qeqNGSIoNOyDLN+AMvsgu5B2riyHqHfQ4/3vTu+IU7055iIQlr5nG5/SpBaOEsJUsPCo/XIjAFyi2hBKfMYXu/24M0nMUXqmy0aP9/RZDVHpY51rAzG0evF7aal0luyh0oobownoP9z2VI4EXu6OCHefNLrftSA94g6XhQH9iW+OZl5zcqx0SWIf5A2sE0KWPBar7Y3ywbe6GQWwtKkQS/9qgy9ZQAI+yKqresjVBGGSf7TUXhtIKOr7SUCxBlxTZpU8j5NqquiX/ZGlqRa9X1vtlHKJytbvMVAYeYGRsCmae8b29Eai+GMMAT1RYsFfywIqdK9Gyh2voAsZyghVNpEQnEVzHXpQSswsltPgbt+HdSzIRNja/V/+1P51dfIHh6oWRbeL0YTMvAWUB23yhSAnKWgm3Nm+AcC6AT6LzF6RRKPNtw5FVp//lGkkMONmVfsxXqXOS8BrGo3HYeMzhB+Qu7CieLnF3olqf5SLti588iHW4mTgUWp8TQgY2U9tAoGvCEZic5QhomZ9C9Xsiib/DpkqkNL5k/87oHBw6R/Jj4wmT41LOU0AjDZlqjYKLVweBUytN/kjgMQ7i
 Z1nLSNqw
 f8ItEHbfTHzak8N3+gltbbbMl2OBcocc9gJp4NgX9hI6trZ7fwRUvciZclyx1WHce2NkqRn369/sgUixxUXgECDh8jc0X0rL98L/rAXgmfSd8YxNXdCOOqYH57j22edSk9j5usDG2MaUVDvwHGouGhmFt5FJfrpmO3hslIJ4EtLUviaVlp+IWCGPZ+7Uqe+9cQo8OrU+9rKwRUDPfCHKbuPaiN2hLO2jqULfKaNVv7wy3bBP66NF6iQjUxBnX5almCdFbnbk8y8Fuh4RpmRLqzlRGAYucNAs6QfY1OVwP/c3gr5mcmUPY6r0/yhf1m7CXnATr778duf08FZrBNOOh0fiWXD+QGV5bK07NpZxXa9biRI2DvoQoszbfwwR2a9+rDW8bmDqd+m2aurvRqmRaVkcZunXxM5jkzqz8jqkdrA3q7VYWBTYloECrww==
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

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v5:
  - updated acked-by and reviewed-by
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


