Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDFABFC97F3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C8FA6B0095; Mon, 30 Mar 2026 11:15:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F7F6B009B; Mon, 30 Mar 2026 11:15:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B58C6B009D; Mon, 30 Mar 2026 11:15:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 165D36B0095
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:15:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 48A7A1B8ABE
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:52 +0000 (UTC)
X-FDA: 84603079344.29.4B2BD7F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2FCBA4001A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q8oZCNYC;
	spf=pass (imf27.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tZowJL8GjFLSw4sIge6Gujv1KBlMa1KFIvCe3PwXUI=;
	b=paKggz7bPOOrJ53eSCBHNT9lsgP5WShs9ONi0CCEj63QLLdAZ8AsMfAo6L4VYpfTYsriyI
	w1EWWWciVFkmh5ZJA9LKojbcrXdpg7OGqTDtixcy8jB5HRevhXpc207YsFGw6UNanhZyir
	ey0lVF+rNjc9mnJqkN7/G0R+UbUqvbw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883750; a=rsa-sha256;
	cv=none;
	b=kRTKHIIWrLrEsgk8HknmQu3FPNM6XsxW1GhI74Pt+zh5fNsygwEThQrmITQSwA1qDxLkYv
	urYPIXOdm7omD0Tz94Mf8R6JgGFiRWILqvgxFoOD4P6EBDm1y5h1npd1lck9JRH2r0Bw43
	qEAl/QbpMs+SYCN5fAwIAB5XJ2sJH4U=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Q8oZCNYC;
	spf=pass (imf27.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9tZowJL8GjFLSw4sIge6Gujv1KBlMa1KFIvCe3PwXUI=;
	b=Q8oZCNYC/1Zpa63DGL3mDicLowSlyohya//gZNgUF41OuRbcqtFKClmxJizjyaVPsZh/ub
	P5wQ1adbyEGUErub94uo7szNlLwIyIkmu6t/8qhshgtyXRWKOWz/XVXc9GsTMAu1ta52y1
	syLmi5CH/B2D0AaS+jRzi4siHQScVa8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-259-WqB3mokyMN2jyXfg3LuyRQ-1; Mon,
 30 Mar 2026 11:15:45 -0400
X-MC-Unique: WqB3mokyMN2jyXfg3LuyRQ-1
X-Mimecast-MFC-AGG-ID: WqB3mokyMN2jyXfg3LuyRQ_1774883743
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4165A18005B3;
	Mon, 30 Mar 2026 15:15:43 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 600BC19560AB;
	Mon, 30 Mar 2026 15:15:34 +0000 (UTC)
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
Subject: [PATCH v7 3/7] selftests/mm: move write_file helper to vm_util
Date: Mon, 30 Mar 2026 23:14:59 +0800
Message-ID: <20260330151503.670415-4-chuhu@redhat.com>
In-Reply-To: <20260330151503.670415-1-chuhu@redhat.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: z1cuU4nccDY_RB51Ymc4677F1fXw0IFW4ywkGZe1Amk_1774883743
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 2FCBA4001A
X-Stat-Signature: 1kiu1hwkqfjsy4d1xwqcgd9zirah1i7i
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774883750-957614
X-HE-Meta: U2FsdGVkX18GrZD33SvY8J+g7J/Z6Qmyc8OgspIUGHQt9ZT4JTdrlicoEDShHQKK2aR3jURe8zpDceT4AeYh+ZaxnPFHdYpJTxZK+HODBcUaQwdk0SddqqskvhUur8PHYdRRe0eCIBpx2H0DR6ryHF7XIclyhIY8tPhSAntYlb8GlP8+HxYlKBUyEER0XYb+oCAvmD/EMIuB8Y+HdfklfKXy/qwQUOT3AZefy7qcny8NWJkKfejzUCfXFRXNytayGSoQY2e7/K1h0epuuxr3lMPI62MiUSOK4C/hwcS6kirKkZ3DVX8Z8FvTAQjz56wlalBYQYPobtYRdpg+x9am1wt8bQDn7HpqzRfnDSWJ9hWZ4EMYVCtCyRwyplJUF1ZQmg41OSw4QJ8hdNUbT08FxOzO5pnkp52SgJW2Iaz7ZMYJWy6doRqIbUUsXVvVCV3hi4iWj0IHMtpAtYPLKzFbBBuWZogcVppbICO2HT13ibBIKopngQkNTHK7guDoTKHNGR6UXfI6Ut9U+tz+RpH4njWViwM2pKmDFAJPn/828ETnpzY5xcMfRjN/p9dmPza3RW14UUJwyih5gzA6qULXDX2OvmtCxIKAIfONRv1/5Rp2urtZRAPgwcXdjcF9qjHa9DBdi2iL1meoCc4ltZkF3egvm941eTIM1SmhwAWeYHgd5XaXmaCXY7lMgC+EmPUJUOvAeSl7Lx3jHGpeEsBJaeOjgCzBNwMMVPe63NV27Nz3Mjmm+rK/e9nhaJHQMhSXaS0kZs5tJxNlf/RcwmQpbOxdpQMo8/hssw05E8AaGOZakGwIS8kwqS2Oy4TG/57qTCCAWVaKZlvQE+DiZQx0z+JHwNaXVdPdDikJWL3dCRKTB9ZCtqNcJVgsQa/8UvrnqrgWubZyaT3POzhd8v8Q7KZkN07tUgn73+RJhaiqIdsS1nPqLd2mbResbv7ypLgf0gmj/9vNKyOnGHgzn0Z
 zalgseaw
 Npib3ogAS7Cx8mH6gggXo4w1Hzwxr3+KH5wDKrp+jg0/WCkGE/p1qFTyBxFkg7vU7VllJpzuj4/1MRQwLeeiKCNOPCFDm0NNRZduzOzqVG2aYBPvd+dzh7flo5s0r7jzwVm8X0ImEG1TG9K7w+hQrjkvnNCCQ2y4o7mE8cs/WVyEPVNy3mBQFDOIjfD48OU3bjUpF1B4LvFVQax9g8RCzaXjVdj0naWfq+gDU9JmsQhwKW+HEEbGAj9LnmMYPOkIRd5gMaCqLklyy+RVXcA5tfCWD+XvLhCDAtxQ9vd8J7z7xG/DT6lLF1VSYukV7TezUOuhlcEyrsvGiNR1JFIjKu+jwaoyy3D11JPz4K1FbR0qyIHToND+94/DPmHmSHKx/3k5/JLqQ/gjzLypD6KcksNv1meaf8X9y/oqvVT2MktO4dSAcpBeHUnNdDA==
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


