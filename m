Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDF4CCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:17:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF9726B0093; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AE26B0095; Mon, 18 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89BE96B0098; Mon, 18 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 61DEF6B0096
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E1F693178
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:49 +0000 (UTC)
X-FDA: 84781349058.06.82CC7DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id E7BA820010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m6wbsmLV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128267;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpTQ3WgfgWsAi+QnnLUnMbB4waLdvOEXsxP5IriPrbs=;
	b=bgoWzMrZf6kNwP6nBJj5WlszrPIgEmH/g+yNDo5nvBRtnd7T8tjtA4VhUMQiBWEDCM6yB7
	1240n30CEQ5Ob+gBUpMJEqvi3cwYpbf6FzbDyzaJCCZ6QAjazTCOGpfQOrY2OMR3DbRoIY
	+OAv+FzzX/ZTUYcFD3TecqytcXPGVcc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779128267; a=rsa-sha256;
	cv=none;
	b=gCZuF79VSUsUzd88FCxqFBfJ2QqvyF7DCXPHwCGos7sdc66kfwjkPkbUOb/mNVLNjdk5o0
	xC5VM3EP7g4ajYMdbkRIzzdmWikQqtGX9gQDUchgvyF+bXjNnn20PntjVvgPXeyIpWoXWz
	gqhP1QxEf/ln97lgp+DIzwVjmScGEQI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m6wbsmLV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D8D08444F7;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B429BC2BCF6;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779128265;
	bh=PykAxIkeN0jFfz1Zn2ciq+xbGylYcs6mwYJtCuA0HUY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m6wbsmLVMwi7Upb11/kQFX/HyNxuFSFY5SFBz3UwQGuxUi6FhGgQdqJzoy+cKeH4e
	 tPCPwU3YB9c0o/BtYlHeeE1y8JDE5FJgOCUCI9FtUrjk6G6w78UaQvNQRyOh6/55OD
	 fsF89KiQ/a1iuU/ofksPPU8aGKV+eimTBJI/nDuEuGfxH95OM+jnxqa2822dryZy1S
	 uEWYjfBUp9WW4IXR7DUzpfAk9TQ6P2Ap1eIQ/X43JtueojXeaNwdt0ma4n5AaojQnc
	 jE73+KyKYR/T42Jrpt6NOcmrQM7GCGV9z6mTERsBad6YvRUdTSzqf0OpMm2a66budD
	 7LrtB4FhSfwxQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7EB3CD4F58;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 11:17:35 -0700
Subject: [PATCH RFC 3/5] mm: selftests: Refactor hugepage-mmap to use
 kselftest harness
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-port-hugetlb-selftests-v1-3-d64ba3a785fe@google.com>
References: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
In-Reply-To: <20260518-port-hugetlb-selftests-v1-0-d64ba3a785fe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
 muchun.song@linux.dev, osalvador@suse.de
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779128265; l=2847;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+iX/sXuCWZ7Cvdfn9EiGTfuvG8jGBSzvIKiil83JdTo=;
 b=cCP3PNDbEeViZeHLywrqRCI3U02IjNAxaY6JYUaLkxHKd7lXQu1aRkOkIki96+D7u+Eg7seg3
 Ck69Pd15PnTCJdoyr6CcFCDPFOqZ+N4TulPvxistfAsTOhpiopVYqat
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7BA820010
X-Stat-Signature: 1zagqcy53ciehahwbummqxtudw3t3nzb
X-Rspam-User: 
X-HE-Tag: 1779128266-611920
X-HE-Meta: U2FsdGVkX18a71d9XKzs76QVzlvCuXyYUA6l4fSNMTCRzcvBWAbamDetk6NFCpQBYfnubGdNP2F87vo/0YY8SeuXfgxWlg3Kl06IWOTRlDn1ywLbQkM/7eR+msmLnFaHHjKurLpIA7GtV4vV7VZXuamQ6d6CGH70lHKlEaIk4QqJE8TNYu0WvkYiiSOtQ2ViBYuAitRWuh6gvjk6q5PumSsD6siaUdXr/rerWzERXR/CpDnhs5t0zB5ZiPa13qlwza9YwKNHhpMDn5Y0Pif+DM3GMRZNX9zfHgjelARTtsAuav6qU4EgajauOtwnR+YCxTtPgy+LYlkNPiz+TMWeOXSz7TNJSVAmOtLDwQbx1EdOu6l42cm8nL/cv8analXwbnwC+TEXVTEhYDA06AxTV5cAKZJLhw1e4V19eabhTmX6GEmdh3CZVtyMirsrt1f9jumLAYUX85kKKlp/H/s1zsGBK63zYtqwwCCb/iSGMvTeCXRVD4TfHAiBgp4J5q0u6NVUba9WtXa9fIHXaAy/7yV9U/hitzG4kwL5bhvEL/Q6+lPeiq18Q+gc94D2Z1/d6tJ5ozPuEh4iOHXZywrH8q2UnZKUC5t7eyNlFEGjiSvw5TtfiZCAS9BVy6lFyzbdcNk5C1zZzrGp5edxMrfEp2WdflGfTXDDs0tH57KJZc/PEK8xTBulnbASs3DRN0YXOjUEz98re/qUXwfiINril2N+rTj+spaJq8WHOlUNqz8LV/2geq6NPxFCAPbjJXAkfo+hRXime8ZO3GWjlXoMOiPYfepCINC0pteBO6fea/DJqYwbQEF3ROJBRrdyc/16R/w1pumarH/vF+MPFycGmGO8TrIT1TKJkua/i96kRM9VnUg0p0ySQsuhAiZ0Ps/rcyjz0m0m4i2PSkDTQ1ro2AVJB2LI1PTcybJhTHNHURvxFQKkddaLy/UvZf2lugp8EbS5EPwU1RXBzne5ViF
 Si8aa8r7
 eICd4ZE/iWrq2l0WUaxTYQ/xS9dQwusxchSF2Y373TQJ2A4a0Fg4MCWbinwab/dad70Zo9ekERjy5poq5jfpE3uJCz5ICZkDJPdaA3XqRHIUYlEyde4pHDGBHpje6mLXKpysrtgbWwD74uckrMYk1YNSaj9H1D1Mt0ZSGv5+dt2xa8c13pvqcKZF6IXO3xMqlPqhi8Ecu20ztuFfXmbfY9pt5rUCW8drfEsMdbt01RjArQFREUqYIm/cVT/C75gxyZ+hqHvgh0zYeROKjSbF3RouZ8NVc3tlXqF7BlGxzVz9daXml3WTKD1JVKCdlK+DfWI65M3HENvQ0A2dQlSyu4HyLsn8wbRT6nIJ06O91cn+GFgjDY7z8Cv6KGXbhwo9T5kowCEyZLCHquiC0ldBv2WS2tiMZN3OdYRNe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Refactor hugepage-mmap.c to use the kselftest harness so that a later patch
can add a different setup flow.

Use a fixture for managing the hugetlbfs-backed memfd lifecycle (setup and
teardown).

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/mm/hugepage-mmap.c | 67 ++++++++++++++++--------------
 1 file changed, 36 insertions(+), 31 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
index 64f7d28a97fdf..9c8a0638d04b8 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugepage-mmap.c
@@ -15,49 +15,54 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
-#include "kselftest.h"
+#include "kselftest_harness.h"
 
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
-int main(void)
+FIXTURE(hugepage_mmap)
 {
-	void *addr;
-	int fd, ret = 0;
-	unsigned long i;
-
-	ksft_print_header();
-	ksft_set_plan(1);
+	int fd;
+	char *addr;
+};
 
-	fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
-	if (fd < 0)
-		ksft_exit_fail_msg("memfd_create() failed: %s\n", strerror(errno));
+FIXTURE_SETUP(hugepage_mmap)
+{
+	self->fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
+	ASSERT_GE(self->fd, 0) {
+		TH_LOG("memfd_create() failed: %s", strerror(errno));
+	}
 
-	addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, fd, 0);
-	if (addr == MAP_FAILED) {
-		close(fd);
-		ksft_exit_fail_msg("mmap(): %s\n", strerror(errno));
+	self->addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, self->fd, 0);
+	ASSERT_NE(MAP_FAILED, self->addr) {
+		TH_LOG("mmap(): %s", strerror(errno));
+		close(self->fd);
 	}
+	TH_LOG("Returned address is %p", self->addr);
+}
 
-	ksft_print_msg("Returned address is %p\n", addr);
-	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
+FIXTURE_TEARDOWN(hugepage_mmap)
+{
+	munmap(self->addr, LENGTH);
+	close(self->fd);
+}
 
-	for (i = 0; i < LENGTH; i++)
-		*(char *)(addr + i) = (char)i;
+TEST_F(hugepage_mmap, read_write)
+{
+	unsigned long i;
 
-	ksft_print_msg("First hex is %x\n", *((unsigned int *)addr));
-	for (i = 0; i < LENGTH; i++) {
-		if (*(char *)(addr + i) != (char)i) {
-			ksft_print_msg("Error: Mismatch at %lu\n", i);
-			ret = 1;
-			break;
-		}
-	}
+	TH_LOG("First hex is %x", *((unsigned int *)self->addr));
 
-	munmap(addr, LENGTH);
-	close(fd);
+	for (i = 0; i < LENGTH; i++)
+		self->addr[i] = (char)i;
 
-	ksft_test_result(!ret, "Read same data\n");
+	TH_LOG("First hex is %x", *((unsigned int *)self->addr));
 
-	ksft_exit(!ret);
+	for (i = 0; i < LENGTH; i++) {
+		ASSERT_EQ(self->addr[i], (char)i) {
+			TH_LOG("Error: Mismatch at %lu\n", i);
+		};
+	}
 }
+
+TEST_HARNESS_MAIN

-- 
2.54.0.563.g4f69b47b94-goog



