Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD28CD58B22
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 04:44:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8526B0111; Mon, 16 Mar 2026 00:44:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B32B6B0113; Mon, 16 Mar 2026 00:44:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B5A66B0114; Mon, 16 Mar 2026 00:44:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AA1D6B0111
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:44:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C17D81D806
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:26 +0000 (UTC)
X-FDA: 84550684932.14.9E1BAC3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D775F80008
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h5/huHRN";
	spf=pass (imf02.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773636264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f0kOdSCeg55Ok0Trt0Fwz3GMewBTQG5BCQViHUjgEfw=;
	b=f03sSTXGByvRs7BcJrBqIcmg2lrsjtB1kPWR26iMwWp5Duf2/XRGr3bvI1o1Eg6cHPhihW
	jivdYEcLY9bAZ9g5K3WmjMgI0g0T9rxBS1MQoGgMxzTha4BAzEaPJGtM6/qISORBloXesP
	hLZuoJDdBj0KZ2lsI9/B9gCGcp+uTT0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="h5/huHRN";
	spf=pass (imf02.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773636264; a=rsa-sha256;
	cv=none;
	b=5XmvrhQWYv8S74H0B1EGX+BOnRR5As4zOn+nQf888/RpC9USbqF/VKPYVIse7BNU+5odBY
	5I+CsAzoebOeABoTqDx/KfNBihEPhIn8IYFFUHWwQHXJ57Fb3cKBhfmuVpoXAp8YQCt1t/
	usfVyte2DUhhsHjUvmD/VSGZURgiOQE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773636264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f0kOdSCeg55Ok0Trt0Fwz3GMewBTQG5BCQViHUjgEfw=;
	b=h5/huHRNlnO21vKyi5Tf8UjyXdDCp1vqNUXdvFBF1BtY7DJUhWZZj9uJCm5j7Ns2nKko5C
	YbDSaueLVrExU4YtTRPuwBlcLDVk7cbYEwQ15BPhrAGpFr3wck9+TzM2Qdlbfy0cmezGw+
	CeppjAGNbmIWkxJQNTlmx5HNwhnsBFQ=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-12-u9wUhbjxMVecISbYFoBuJA-1; Mon,
 16 Mar 2026 00:44:19 -0400
X-MC-Unique: u9wUhbjxMVecISbYFoBuJA-1
X-Mimecast-MFC-AGG-ID: u9wUhbjxMVecISbYFoBuJA_1773636257
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E867E19373D8;
	Mon, 16 Mar 2026 04:44:16 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4748319560B7;
	Mon, 16 Mar 2026 04:44:08 +0000 (UTC)
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
Subject: [PATCH v2 3/5] selftests/mm: move write_file helper to vm_util
Date: Mon, 16 Mar 2026 12:43:33 +0800
Message-ID: <20260316044335.1390608-4-chuhu@redhat.com>
In-Reply-To: <20260316044335.1390608-1-chuhu@redhat.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: O7sKyTm1Ou4mLfRvixGipNEchdaJ0Q6jYjRUALgvun4_1773636257
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D775F80008
X-Stat-Signature: n13pzdj34tm15wy4pfgr4z5141q53p4p
X-Rspam-User: 
X-HE-Tag: 1773636264-782774
X-HE-Meta: U2FsdGVkX19R0BAiRpOrUK+gZg9VnQxKnAQ74qxuxe89AmH1e3/LRXEbi9P/efTn313lFAOUCdPfZl5HFQDuRedIedHJNkgEXIZuyhKQ3LJhLDgTu5pI+UbT4w2ofKUdWMzfLZi1u55wp3tAApGD6d5foDe4BexxchNe/jOTwo9eWyJk9Mk3zrZ3OA1i65cmMTyCb2TnePVJgq5HHvdHr6pwZ3fro02Vraz3jHEgWToztZvCbz8DHuYyiHgL8rDcagjRL9MnPBsU2yIWFgPCsSIX1QlAW7V0W3JIkbbE/fofXPpT13pOvp/hcX8h6cl/AqsgAPPUW5SnxJenPqKWTatwIkKaFzBU5CDRdQ6kVv2NqKRsaTl/SDt5m6O/NVUOxYi/IqtPc93zRnlf2+rLA8GknT3TmGI4zEJmAO8Bi4Et2tyeZccbK8mZwpROPn7MmpVWwiDyPcwejf99kQUV2vld67tqLy3+REKPVV/P0hjR0U57zArkCGbvREiSYgMNL91q4hXNl5VDQuhGSujh+4ZP1StI7MedNTbxoyYpUNU/25/GDuFozm0+wMDYEoPSAB1DXJwLJaBivVXDL4sk6GzguWptk0ooA1SRi8u1kGtokv7bjAzfCJGMHZRCpf0uksulXbZTl+p0w4WLN1EH+YIE/BF2AX96JZ3IesQjDWHhQ0/2rfYxKSPs0ly2xTBF30PW7lBlv1ClzHsjJaymSofxa9h3/UCKdybYq05FscRU/7rYGrquo54m8+duYxY/xoxZ7DaFr0RQWSrVnggGrAeasj0rneiXFz97iHMODv5/NDClvRQXQvU3GPMHcyfZfb8s6OEedeANkp9Ht80SSXf/ZkqxlR0vxc7xBRbRro3VcZDGivbNZw5jOCOwhr2No+RijaFEbJmkdCpbffiBrTfeId0+u35JPDTC979gIiM44KSoCF8lX61nwEq9bvHudV4jtZYVtiwvLH4zUYe
 xW8HJoTd
 c7EOxTpopCbKX8sIWalbtSVpLMJ5U9ZD1csLaCsqyBbv7tmKa4ZEZusijabugIlo4JKJOxfRFO8xz4XBkMSo2CyH+lXe2WT4EUQlLnsbAsE92FLIszwcMzbJi8+xRLeq9G5nnbIGbxRkvmQuabzq4tq5zHFWDd87GGqK3gE/Rwq1Qe6lW0c3zBT+4pWyw+oWn+J2FfRIQ8WIbCm3MZy//ScvbpyBXJR1bsIM+JLYeW3IuiZN3z6jnRe+eb4B6IYv2Y5pjeRZ56NF210pXRgbhmtxFmfKYunkZ0UyTB13KRQ9qCJNjZ/lRXwBlne/bS5zEzhWDV21FbjARlg42Mr6D4aFvnNgC1DIRpEv1QOKDtWlcoTUXy4EscupAEwhLRRooe4v59WUHESUUzwi5TbMtCvnOte9RM2TLtfFP
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

So here just leave one version of write_file, and move it into the vm_util.
This make it easy to maitain and user could just include one vm_util.h when
then don't need thp setting helpers. Keep the prototype of returning the
written bytes num.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v2:
  new patch from v2
---
 .../selftests/mm/split_huge_page_test.c       | 15 ------------
 tools/testing/selftests/mm/thp_settings.c     | 24 +------------------
 tools/testing/selftests/mm/thp_settings.h     |  1 -
 tools/testing/selftests/mm/vm_util.c          | 16 +++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  2 ++
 5 files changed, 19 insertions(+), 39 deletions(-)

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
index 574bd0f8ae48..02de28ecf31a 100644
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
index a6d4ff7dfdc0..b4b3b48f8dc9 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -764,3 +764,19 @@ int unpoison_memory(unsigned long pfn)
 
 	return ret > 0 ? 0 : -errno;
 }
+
+unsigned int write_file(const char *path, const char *buf, size_t buflen)
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
+	return (unsigned int) numwritten;
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index e9c4e24769c1..22c8805e0d7a 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -166,3 +166,5 @@ int unpoison_memory(unsigned long pfn);
 
 #define PAGEMAP_PRESENT(ent)	(((ent) & (1ull << 63)) != 0)
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
+
+unsigned int write_file(const char *path, const char *buf, size_t buflen);
-- 
2.53.0


