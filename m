Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3951F532C6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A58B6B0096; Mon, 23 Mar 2026 21:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655906B0098; Mon, 23 Mar 2026 21:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544536B0099; Mon, 23 Mar 2026 21:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FBD16B0096
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:34:09 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1C5C1610E7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:34:08 +0000 (UTC)
X-FDA: 84579235776.27.25E23AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id D8160C0010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:34:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="C/cDyZpa";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774316046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tZowJL8GjFLSw4sIge6Gujv1KBlMa1KFIvCe3PwXUI=;
	b=om2l0uGjg4VwY1rxrFar7EL8Dz/tcJIvF9+VpmeAtMk3bl6+YghdpOlJOMi8TjOkXG89Ke
	UIUWLXZ/69ixajT3QhURZzg53KlAWNGlVEG+IE3tCJOouebQFH9IsH9Id66KejYiokkU0m
	RvvxC/41wpzeHXiW97aIwH4nU15jE2E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774316046; a=rsa-sha256;
	cv=none;
	b=a+5QqOcTI1SL6AYAoTFBBlBl6ZzM6RWDYa9mfPo48uKSfw38kzF+cBqy12W6fD0q8oeXQo
	U6B52D/XKVHJhlsML48urt7tpW59jmOKoy8nFDLfMhGMpS/hM6yfL5mXfwXK2FPaetCdzw
	KSmULSSo/rTAmvlLTNqbvVOtoxM+/nI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="C/cDyZpa";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf10.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774316046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9tZowJL8GjFLSw4sIge6Gujv1KBlMa1KFIvCe3PwXUI=;
	b=C/cDyZpaOSLYK5sgl9IIipnh1ghne7rcHGega+atmKS8ZqeaaW4tnY87W5Xg3usSAfvoXJ
	wV06Ov/i174i9yv1+QVVyIRbkpx7phdRvOlAyF/GkBEmCXXQCqdkvjgwibhUNTKPpN/gqo
	fb6z4/WuEuvgdl8u3mGDOifEyQ2XL0E=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-Hj1lqTauN96GlmV4GQS9Gw-1; Mon,
 23 Mar 2026 21:34:00 -0400
X-MC-Unique: Hj1lqTauN96GlmV4GQS9Gw-1
X-Mimecast-MFC-AGG-ID: Hj1lqTauN96GlmV4GQS9Gw_1774316037
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9CEF119560B4;
	Tue, 24 Mar 2026 01:33:57 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CC8C31800594;
	Tue, 24 Mar 2026 01:33:49 +0000 (UTC)
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
Subject: [PATCH v6 3/6] selftests/mm: move write_file helper to vm_util
Date: Tue, 24 Mar 2026 09:33:13 +0800
Message-ID: <20260324013316.2590422-4-chuhu@redhat.com>
In-Reply-To: <20260324013316.2590422-1-chuhu@redhat.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: PnG8D0WWeuMh8AZpaGJyXu84VONzkWnArG3G2hP4_CE_1774316037
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: D8160C0010
X-Stat-Signature: xg9jenfdjdkekusarw34ymtfhcy1embx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774316046-122427
X-HE-Meta: U2FsdGVkX185A7J8lPmkMKUiAQ9rl06mb1YP9flcKM4P2CJji5I2JbZBXqLcJJLoDtC/knwpKd7gn3Yf9SY0ME30CN6oWrDIowVFoYBNNL5mThtKPSZHy+cfp+KojKwohwB8Fb0oWK/s/YCMEQNjFymecrhnTstbxaBVSzc2xUF1uexrOL5o8ytwpBsag6bsPKZs+G0XK5FvqQ4o0q+pI0b+XlUH971lf5aS9GDPTLd58RQtWCjPaZVfpaoLJeAW0m3sAZ47MCKA168neSqaanfn2V+/gw65MApe+bbT4IC1V/1KmTHINjjuTZngL3Rb8WKRi0+5XHZMIc6pRO85hB9h1UxDrf3clLHb6K556cDnwBAe6NtZK6CY2GMwyCVNoTUU1X0Yu4EocDDybmxsUcLcu9TaYJ2ssSqsFGuuaOCEAhgt5RnoC5SRVSHCOqTfBjswkTSYYVZiwwYsaM+jYgIgobL0NiUZySPQhxA92YTBAUF4qq4SJB4I0Y2B7aPeoJA3iL/0UP/BoCJ3RdMJZsITbIb8sqjuZneTfR7tpb9UbMLKkhTawPH08Gi+LQgzDCUFsHNcuCgKSmzW88XorRz77lx/flxOueECK8iSLDe+veQhNEOX+wYo47WoaBC1jx0/sRf1jbPjjjK/G+t6Yx51uulRvrBS2PU9xDjJ3HBSh8Bqk3zWSV3dkHRhXiblKkyflK8zGUSSJF9f3HYNAkN0lkIs8eat34KE1LNy6BIdRYHlkbiSizLq7lSqgrIbhhfxRib2j0ew3yNGL0Jpxcxbiz1f68+CbJU3aM4MO0cA0zGr1kuKa+nAISi7tVuqIyCDcJMfSWyYCarq9LoVjiLSLJgpooYKtIoQXwMQjAKAIZNcAa1DJjqOaMSSh0+9ql3GqqHyZLak9QQEdbg0aA5N1kLWjVS6FH3aeGdS0dYiR5h2jW2mkTz0byJg2+KP+hCzvOeos2w/HzDwig/
 YpRusq4i
 hXyaAcHCj3uUuU0KvKemylbaghdCcPILQx8BbAjXm/LZ0TuyIFNeXyzsTiaJGJHXgvqJPnZO3CvvvjcwZKeSkywTQLZU/TimXq7/7+wsqQ+acawun71tRObmgw/2wSsQUqsuq4Rp1wqchrsUu67vFK5qqc1JIQgoVTzHoz918qckwsfBx+poWduGnWptJ6JxmJ89YFGtXpUYn+byOH5SwpGyRQlEEGUWSXX3wmdgUbjgHW6jPV9jH0k4MXP9+yYXj7as71YN1G8RUIF0MKowIbQR1/cEmjTXOYqPIbNmYcxtNWnxuh3Mmhn5BlDSevQW7d1rXAV8L7qrdlcKmFlROVVMSC1HbAR++lW9yN8S+xHTxehV0UJCwA+ekIdZMOTMJyCzMfb+Shj/TSplKt+hIZve0LHlqrfo05tvwhFs7wP6yaYA+Z1DHpT/+Cg==
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


