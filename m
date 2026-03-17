Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A9DDF33824
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75F446B0096; Tue, 17 Mar 2026 05:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7370C6B0098; Tue, 17 Mar 2026 05:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CFF6B0099; Tue, 17 Mar 2026 05:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 517146B0096
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:45:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0465A1B841A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:45:09 +0000 (UTC)
X-FDA: 84555071580.15.7F7B200
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 14B3840005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:45:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UVSudpSX;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m14eZlieSHU0U3GZgc7YUIvhhsIX8Oki0rAROpoPAiw=;
	b=ZtxLifmfbCiCHBOYamCIhd9hi72pVIf6oXRIEh8IC+jGcbAdvV08dk2AlAlRKWEkgX7IL/
	6tNL5JmFdVgp5Xvvatj42cuIL34vO9DOpjxJljXp30+LUU387djvAhb0kwE4yaoyb/aMO9
	gwB+D5lXP/7FcyL+ITWCn1oNcmZMqDM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740708; a=rsa-sha256;
	cv=none;
	b=ww5zBZ4jFKQPgzqhu8NwPxosRHrUkcviJtlNNQNHfwlrMJi5u1SNj0QUd1z9/4ZLYRvdnn
	vSP0HI+LpZsNaQI15J0xJbrSeDs3oH65azd/Libxc+Ci6EXoSxsC+LMOUN2kON346Mkq6v
	sRUm2SnauOzuSICG+Zre6paCiDLRmN0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UVSudpSX;
	spf=pass (imf12.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773740707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m14eZlieSHU0U3GZgc7YUIvhhsIX8Oki0rAROpoPAiw=;
	b=UVSudpSXm6bTdrsck1oFX14rguaswalTyMvRI/w7Mc+bFDfJQ3adU5QbnYrgzJ/0gR6rj1
	1MZOSz8x7iHTypB4LrhNb2BRKPZ/IBLN7gpZXp8OqOzV8g5CnDPTh59YS7P5c/rsbFR9Ou
	65TlbMP9O6Z46acfGtEORodTbxhZ8ls=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-111-GYbXuR_-OfSXQGCzbuK7-w-1; Tue,
 17 Mar 2026 05:45:02 -0400
X-MC-Unique: GYbXuR_-OfSXQGCzbuK7-w-1
X-Mimecast-MFC-AGG-ID: GYbXuR_-OfSXQGCzbuK7-w_1773740700
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5CAD418005B8;
	Tue, 17 Mar 2026 09:45:00 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2EB303000223;
	Tue, 17 Mar 2026 09:44:51 +0000 (UTC)
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
Subject: [PATCH v3 3/5] selftests/mm: move write_file helper to vm_util
Date: Tue, 17 Mar 2026 17:44:17 +0800
Message-ID: <20260317094419.1429259-4-chuhu@redhat.com>
In-Reply-To: <20260317094419.1429259-1-chuhu@redhat.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: BC7aeS2bqkW0zaGTstwGgJtfQiiV7iASyyvA0R1rk00_1773740700
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 14B3840005
X-Stat-Signature: o6966p1s6gbjamn67frtba9uw6n4xdgr
X-Rspam-User: 
X-HE-Tag: 1773740707-300442
X-HE-Meta: U2FsdGVkX19opRAkqW1e+VxCmLRF8wmssyRaLUvHgvpjYnvVheBz1t+b+cZuBmxMrK2eEvv2hU9fWf+pd37Ri51cm3TzycDXfq0Xg40I+ykfY0EU4iRPSZfYLFa0ZTCVWcEz0Zw8+5pzd24aVD2oSiCKJkbTA3LUnwCEIQKtLW7r3Y5B7XJ845c9o0R2UEvS+d2Mj38H9ufhPP4TWQuygc1GP5beoxn7h5KVTfT1httQqXcNUTlYplz6L84LROY5f//J7gjBXaVNVL+5IJApNCC6ivZlNTUBXJN7s3PmzMkev4xUsxY+2goGSuC0YEC+BNhRuOwALbMWlqR/8IjKkAEqLqLItZ9Gjvnyl/Z4P8ReoPZMP1IfwVvpisDLd/5ucncgKv96lV6x7q9lAc6V+ssGYjTHU91ivmtmyOYry0aljE1LkstipchxZxO1Ammg+lIF46QLPOy9ejqdKwgreo3h2IBDlBLQjmGxt+JMsoMx6S2JY5iJx/pYc325CBzFUEUHblQsKYp4TSYMxTLJHLKOQgXweeMaQZUkjCWatyeFfCvRQeuioXZD2ZE5dwzoSvXLTG82t7Lrqn8Hw5lsI8CW/Ujwlk3zLBL504A9LaAzBQVMNtkNYiGwNWRp/PvDyD2wILFz86WJCcGDIpj2U8AxC1XfXhcrGBB4pLXk8uruxV14af3J4l5r0ZtInc/beXTEu91VgUPsX46kj+2Pn/Ix5FjZ3ckndlvlF2yItQvg2kYUTgDfkb0p0p3z0116Vre+++hiMRGSUyH2QPb/olxkW7EOSjL1QTMOr7iQ4v0aGlnid3ivNUC+8Bl5Kx7XQMmHTrSrNwLJvP7D/v66BVwTOCytRxaBBdQ3EGNkxmv+p12nQGYrVfgFTKf2ff/A5odBR9WZiz+ZSZBC/nUf2wwQcQrMqMNGSODp6Lzgb53ioNKnmZHfYL0aSzSBCBNfblwOPIo6UmHneUYzvAP
 1loSg+BD
 +RenMmjuklAkdSIjO8gs7TZWzwlbzsBY3aeDatD7neYu49UgN/xVXaQRVwG63DLhDZZoEl+1BORz8QDDgTeeMiTieQ5d8Ho410uqL5JJLao2Xsb8mFGbd4KOVy18u/y8nONQguWl/Jc7XybFkKN4TneXb8K0FWTfX3brUREkQfupnRSeNJ1QaF2+FF7EM5KgHs8+I5gLC60tqa7fLTKrCaJjqrUUiLrgAmk3EM9Z47cUeTx8MaaLAbr+xFgSrLF/UOtyRiyqIUHryN5IUePsiii+M5uKwk++LduHb7+Gx/kXZJOsuOzZ1ei8BtTsq7grzLEmqVJ2K8OALsd9yzWOlhGQO54uKnoQaVccDXjgn9di87S/2xnMi+Tf1jEtBsgixmsxEOq8enLQYH7UF+LlMhthQzF+PJ7W3rdw/
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


