Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05D29111224E
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:46:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 638E16B0092; Wed,  1 Apr 2026 21:46:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6109F6B0093; Wed,  1 Apr 2026 21:46:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 526FF6B0095; Wed,  1 Apr 2026 21:46:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3CDC86B0092
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:46:33 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4CF1B8292
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:32 +0000 (UTC)
X-FDA: 84611926224.21.5723A4D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21EC9C000A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B8u2yBrU;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775094391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tZowJL8GjFLSw4sIge6Gujv1KBlMa1KFIvCe3PwXUI=;
	b=gmsbeaYGvcT3ZpD08RymGyJypYPOHTGQYhR96EZNZWMFlP2M2cgqgSGGW5HTicNx+BGmek
	BI7KowKUQusv+LsNWWsujVGWwhCQM9sBGk0QVuHnAayFONyGhZWYLMkjrPrrrJVhcS43Ij
	7+vdkqk6qGnoCnXthyacFtVE3rkWa6s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=B8u2yBrU;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775094391; a=rsa-sha256;
	cv=none;
	b=N6ccPpBwjHP0lK75UZnNvn9KqyrtJLyT5IlzPzFogkPqnNxvZjBtfGbz+Jfmk2fbY6Ke6I
	+qnlqYPmi0iSAmt6F/rvMEpOEVwdwvwlizfPSPvmsuLQcVvdAX0KPHtcQM5uqSvihk+7Yl
	t1f79jWRNunq7g8x/grv2g0c9vZAsso=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775094390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9tZowJL8GjFLSw4sIge6Gujv1KBlMa1KFIvCe3PwXUI=;
	b=B8u2yBrUniFWoUF91KgXl6UqaojZCe3tlq2BBNo+S50ecA9K1b+u8REXAF2RuwgSOrjeAn
	j53FHIE+rKCHfgxRbblIdTBoBWNLUY8qIrJkkxygjKyINwhGCmKngOMRecyANQK6DhQ6gK
	8c4rZpP5JHIWKrsnDWTA0/8hRaViwEY=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-486-CrXok06gMk2u5HjxF2_H3g-1; Wed,
 01 Apr 2026 21:46:26 -0400
X-MC-Unique: CrXok06gMk2u5HjxF2_H3g-1
X-Mimecast-MFC-AGG-ID: CrXok06gMk2u5HjxF2_H3g_1775094383
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 70A4F1956065;
	Thu,  2 Apr 2026 01:46:23 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 774CB1955F25;
	Thu,  2 Apr 2026 01:46:15 +0000 (UTC)
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
Subject: [PATCH v8 3/6] selftests/mm: move write_file helper to vm_util
Date: Thu,  2 Apr 2026 09:45:40 +0800
Message-ID: <20260402014543.1671131-4-chuhu@redhat.com>
In-Reply-To: <20260402014543.1671131-1-chuhu@redhat.com>
References: <20260402014543.1671131-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: 6G03JMuY0n1BYws9HOTfuWx268r9LfJDcQpIAz2X8iM_1775094383
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 21EC9C000A
X-Stat-Signature: momy7qug3rfbshechmiop4jr4wzfeskg
X-Rspamd-Server: rspam06
X-HE-Tag: 1775094391-964524
X-HE-Meta: U2FsdGVkX1/b5j1P16n0Fsv7nJVy/Ajlcshyun43NvpChuWumg+udtBl1dFxjg0suFKPm9FhYL7yjDznHi745KhE6SCxN3aUBu0cW1T4gIoOcbHtaNmbIW7QkKOrQlupMpXI5ksIJ0alk48U7Pz5dpJizJa1oyFiA1odGFoQwSIwECTc1d51MqGJLnw+n7ZfMbIRXo01mr+dBPZveCDRp3TEQqxJAj/jUd9kE9EO0plzOhQ5m3WrR+458s03gfl1jLvVXN53vyQdd7w3QUmECx7Ee9tUobKh5xH3OeAxxgtLXel+wMer8f1kXUHCtvLPIYPxTtcGCvoawZoYP5nmBa8s9nK/BQJ87leMEJMpzsArqV0XALVVpec8QzdIxpJQd0KtR4wdcD6UCsRo1GUd24YHdsI6t+6pvh9yOYcAffp3brQyapbf1ZfXZXpi9jDYskl8xW2iD9hutWz2WQ5ylzbwJL4nXeRAsDQ6d3KnDv0HyOPzltElE96D+ErsehUcQKhhsCc2YnWuqvgadSgia1VQNJEQUQ4/35OLb5jKVBc+TQvc1ySzKglfMRSupg1DJ77TfvKoXVTHyhn09jY6qisp6Pref/sXb8DmxL/7qYQ+zgKwTC6eA2O3phfhDb17yiWqH1iCgTnl+1FWKlAMIDHTiBvO5+/TC4mrFLt4gbKt93X2+yQKuZq56qIsEqqY9vvU9Uo+cB0TEeeFEZ6A3WGU1TmYkMpWlOK73TpsAkazzAF+QAGtLVnGwGS+XQq+vXGwnU2Ei47obf197YH76mQmbDwgoy+FeA1bWg4ufQ41zLmQ8SUFKUdIh56PU7NT9SYrin8Z+xL7pdl1/QHWrGsZsujc0GLTYPgephwFovxJupnXXbbHwdS4FLMQC7NC3zfjtfG64tyDP/fp9VuqofOXmSSHfFZRJqu+aPyBVFYo4428rHwb/FTuc6kk7YvrBD9GYp9XKcruPUqYiSs
 Zf2mVG1A
 Mnl8wb5SxijrpgQmRWghfE+1xzlsRsUj3wyqfTA6u9XRg8+CEDCtsD540rNvqAgnhr/oiRF1lQFy313YLmV5iENSiPp3dfiZ5m8rE0+UotitTaNh/yTWR8UflBprCRFpg2oLhxrR2WvnsaTR02Y6qPrJ7ojil+gmWzNl3PNp4JaIImnDE+tgSXMZFXuP4RwWoH72gWmgpn8Fp5kzGBiV5tXvSZtYlvnAWn7vZQgIXbaFlxF70NGRYx685R+hJFaJ7SkYTt0zThp3IvG83t3Ni7lhieMF50Hjwu/pG+KCkiSzOuMMbssTNQKUxXOdF/9l+Hx/BodLDOT59ehJZpQ/UNRaWj3am8JKxQ1miba06fWPwAl0JPF9UaOygKeWWduT5IL0MWAIs2qrnd60MJJphLC2zV+W9cauAyJGgys9685iA6qRar7hw5WjeqA==
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

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v6:
  - add reviewed-by from Lorenzo
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


