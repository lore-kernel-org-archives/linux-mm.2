Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3155CC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:58:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DA586B009F; Wed, 14 Oct 2026 13:58:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7641F6B00A0; Wed, 14 Oct 2026 13:58:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58EFE6B00A1; Wed, 14 Oct 2026 13:58:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F73E6B009F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:58:18 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B15EA16077A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:17 +0000 (UTC)
X-FDA: 85321991034.08.A94F4CD
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id CA01D18000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:58:15 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QdBm3xXN;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792000695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B4y6AvoDjRL3MjFRJLFGO2/ddqJNiHaVlDDXEV/4hBQ=;
	b=gm3dhqPyuRVpq69CfDocDgr58Ogz5grAcC21LYNwJXTGoOwNPfC3vHTmq3Vobk7AvtQElV
	mtcXqf9cMDVeWTF8ai3AnxTbc63LwxJjVYbYlcxSd9ONqL6HY/9sguKlWZfncXzdcRIqlc
	NTnmTPKrVWxJQt0aLMUYZrnDcbyhzoY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QdBm3xXN;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.45 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792000695;
	b=UzK5eRDcWwR9EpLdLZzacTInf6KhzVTM+x4up42hsl9WRO0QCuAcX9BP8KCLjl9FWxDiq+
	QfTf0Ww6AYD4u5Raj7ha91f6ywOYFX6YXZlPmbhe9Ur/cAKt/Qtbm1MEOSM+JYX7M6c8yz
	/atPgHPbzM8gv2/swkYxRvprImgF4wY=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-917c04630c2so56179286d6.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792000695; x=1792605495; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B4y6AvoDjRL3MjFRJLFGO2/ddqJNiHaVlDDXEV/4hBQ=;
        b=QdBm3xXNnM4mHeJHG7N5hDYmQOmtwA/fDFpiEnqOvbHf0Y7MHx7zFHq74XNsaIcyKa
         x4iPE/sxdcaxt47gKmyiyNhCOLK9Z6Obz9mekDvyJOLHvsZQ1tNwhzZb8ESoCKf0xEIQ
         4dtUvkKBaFYDTQ5PevchiDrsyGBrC1m6Th78GzpNalsMohE9nL3cGFqnZQFggjIInHZ1
         H+qxL9AF1bJ5iZAs7sKV7y3CgZH6By1MURqLlYeSipgvVMk7LOgIAIiyzAabKATVQ4jF
         TNQOL2N4ygCvTc5aGunfAgFWkHWYT+z5sW2LR3M67Xpbv4pfgU0pMI9Ao66GnrKmcSXw
         1TfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792000695; x=1792605495;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B4y6AvoDjRL3MjFRJLFGO2/ddqJNiHaVlDDXEV/4hBQ=;
        b=p3BoFwBkkctW7vGOGA9abAiTzomE3j6Vz9nY/sF+dFIRjiTzBy1KFqMUcLEYv8MgO3
         lrQGdqAd3uoyKSRgSLOzojMgUPaIwAVaoSjFBGgo3Dg84JJQsBVVLukTGX6Or+2dfach
         pxsP1/gwvBtMRUFhwSnetD3MHr6Rkqg5L9EwjhV1FJGMtYGIXO1vTKn+wJXgnhzj4KX+
         cF3iHgJTDQAbc3h0la32zxqwBnHv+xIKcxUkxzIuR7Hs/Vi88C8/xWp2ZWyRtjBEoHP1
         chmWmKZpvxEeVtjsHulDrRG3fNBXmbDNdwPYgmme55uoqxwlzwLzu/zofPmoTw+cHnM4
         A2LQ==
X-Forwarded-Encrypted: i=1; AKwUvBzcG5NUsalx4yl8Tg4ujtF65PYRXle1VvIsJrUUbvixUwKu2ghoSxGMbrWoxyESPhqleMuBH7H0fQ==@kvack.org
X-Gm-Message-State: AFq9FYKXCgGCzyS5W1Jc7v/GScsM/2lxbxhRt/EdKlPYhOgAjP03dm5X
	J5WHONBzPicPzn9lBywq6RqoLjpcEj9NaGc2XgGrzrheCCAqBu+dV9QYZYcpDLT8s5mNWcyVLdO
	ckZ5fYOQ=
X-Gm-Gg: AYBFou1Khqa4L4TZK039HUkhmkQnyDCvgycqGkMLYTLbMRpKJWUQBLWH00LZwBxXyhU
	LnKQlQMLgvYic+hRg6q42SQrCCnxiIxbx8RYJ+ishX+sSKvTC9Mh43qKDjQ1m+YR61Gdyrywrwu
	x6+E388Db3hZ1cBQkSsy1LgCBXe+99nqh3HQTJj5arviNQCwIJCqBmb7olOS7Bzky52tTrATH2T
	Zj6DmCTNYuWS2847wxTP3jBjI/89N1O4ta+osA9vp18JS3WtUTH1GVx8/yqA2Rl28P2cHN8+6eV
	xehaQ4NZ3MYn/ZSASSNQj5Dm6e5c7s9TYVRP4tOJ+hBnLR6bQfmoCYobayaHw63RVMnqFNmbzpy
	AaP2dII+DT9xy4uqqvk4cMo5CYXOL1MNIbCxqZZ8GyIHFlDsWOaS+47NeCOoAObUPwJ9ppoXj9l
	hYYsiWOuuaiNvPmwb7JdMCzv5I6EOlK4luuNqnnVTTuTbPtoOxQPI4NF7a10MnvCEV57DUOh/bM
	80Nq6qZRxg4jSgM4b8Qt1BtoJ9YSyS2I1QiZnuPGT2LhaYZL98KOoCqLEWd
X-Received: by 2002:a05:6214:2469:b0:91b:9441:131a with SMTP id 6a1803df08f44-91b9441155dmr124063136d6.2.1792000694921;
        Wed, 14 Oct 2026 10:58:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91b97b95847sm58498006d6.32.2026.10.14.10.58.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 10:58:14 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Subject: [PATCH 7/8] selftests/mm: check MADV_PAGEOUT file permissions
Date: Wed, 14 Oct 2026 13:57:55 -0400
Message-ID: <20261014175756.2035176-8-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261014175756.2035176-1-gourry@gourry.net>
References: <20261014175756.2035176-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA01D18000A
X-Stat-Signature: 1ifycjz4tyq8sx44jt57fjbacmqmtcgo
X-HE-Tag: 1792000695-134534
X-HE-Meta: U2FsdGVkX1/R3jCkHsjZhdMsACWnYYHGsltbE8UVSHIwv6gt8bPzNu/XptwWizfyQbjj7kboNRamevSqSnbLWebKLUrProaHdbVVbJaKJ6ErxNV9Kb0EV9j9AIpiIayuXf8hRXmtZ+rYqKMRYICxI3aXFLAhDaXdsA0Vo75jH2UK3rDSIUQOCon1Gv9Zwp8pITT5i/SoFI1hfrjB5+wzuyiel8Y2XjDokhJYWGdTNERbGkjAJnOTCDy+irk9qdkOrSrVS2jzKHIEqLAoKRSA+6f6xujI7CUQ7Hazq/UoribfyI4NadGVbzJAqMdeQ9ESiqTe6w0doaP1Wc4MSeUjZ7hs+Lh8DmzNAcexz5Roo9mhMSNc4QBHblwu/vh7eWgN46qOzVHp4uQD4p+DXVT6fcS5g7CibFwZ8MNRGT55eiWR/2vik7W4DiVZu4bPemk3pFr7ksbva8wLCPwOhwRTF10dOmwVhpdo7QCXsFmBm0WYTUWwwqwW2RMJghtbDCqNQH6mir/BU4tieczpzC9vTvaQuQBdxEP3hwB2WegWBKJPo5glhjvBQzR8LexS+21Dpi0r0OWoqbnZ0AgiruQjsMzo2IoYpiL131u/BoLUzPWMujhQn13QNr4vJVjMHXN/T/ahh/mdMw0zp2WNA+o0OvibEMW03Br9UceH0t+zNVFQpvVyeX1ngDmKtdvoPbEGxO07n5Dtt961cG0ISPyVLC4Mk3IwLV9rAtoVOPOkIwbHO4arVroh1e9zrfXy1hibi1onVyjBzUOkWXVyzHzJJ2PT54jBmZCOQwKqF2bn7ytUvX51mzUycA5kJ3N1QWS0Pd9SRXy+VKcEqyTP9xvWlg3BL5q6xLMjxArTZML5luYB8r/UIxPgAiYVltJ3LOZz/NIcNPR8Q5ZY8IeGfsNH2auHRGqGbsvIYagj+yHIKzyV48KH3r29V4POqjXTt0muNvwdGAH/GJPV9yzrOt/
 WNe2Deiy
 UyyRQrPf2CQXcQTJzZ7OpmVLrcl1likc2+scZ/vxOnF+MxPcwDM77RyI63H3OIFnJGGWLi5iFmGTvBw7GdiiKf44rOVEQp9Z+RiE3+O9hk3C2C8z7xoayTFDjhmtVgjH+EtPtf5rdWf8Zjhd9lY4WHm+Rdd44qRhvvu3AQId1SYTfon2skilDbQIoWE4pPecewP9eopL4n8NfQjbFhPHQYAE4KopKnZH4IH30sU+zfjt8pW6bULFVmA8qnE0S5X7GmDlYT4eoikzjWv5frpkyOhUCFZchRVym1tgAou8OEUN4hWs31CPut/zVF/eako4zDWi7wQzABkfYKgrse2aNniqBUgS/pHABaFgO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MADV_PAGEOUT only pages out file pages for a caller that owns the file or
could open it for writing, per can_do_file_pageout(). Any other caller
gets nothing from a shared file mapping, and only the anonymous COW pages
from a private one.

Check that the owner of a read-only file can evict a clean page of it,
once a writable file page shows that file pages can be paged out at all.
That test runs as an unprivileged owner even when started as root, so
that capabilities cannot stand in for ownership.

Also check that an unauthorized caller leaves a shared file page resident,
and that it pages out the COW page of a private mapping but not the file
page next to it. These need root to change credentials, and skip if that
fails.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 tools/testing/selftests/mm/madvise.c | 105 +++++++++++++++++++++++++--
 1 file changed, 100 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/madvise.c b/tools/testing/selftests/mm/madvise.c
index 8822991eae4a..74202fed2d04 100644
--- a/tools/testing/selftests/mm/madvise.c
+++ b/tools/testing/selftests/mm/madvise.c
@@ -5,6 +5,7 @@
 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
+#include <grp.h>
 #include <sched.h>
 #include <stdbool.h>
 #include <stdint.h>
@@ -12,6 +13,7 @@
 #include <sys/ipc.h>
 #include <sys/mman.h>
 #include <sys/shm.h>
+#include <sys/stat.h>
 #include <unistd.h>
 
 #include "kselftest_harness.h"
@@ -208,8 +210,9 @@ static bool page_is_present(int pagemap_fd, char *addr)
 	return pagemap_get_entry(pagemap_fd, addr) & PM_PRESENT;
 }
 
-/* Map a shared mapping of an unlinked, zero-filled temporary file. */
-static char *map_temp_file(struct __test_metadata *_metadata, size_t size)
+/* Map an unlinked, zero-filled temporary file with the given permissions. */
+static char *map_temp_file(struct __test_metadata *_metadata, size_t size,
+			   int flags, mode_t mode)
 {
 	char template[] = "/tmp/madvise-pageout-XXXXXX";
 	char *mapping;
@@ -219,14 +222,21 @@ static char *map_temp_file(struct __test_metadata *_metadata, size_t size)
 	ASSERT_GE(fd, 0);
 	ASSERT_EQ(unlink(template), 0);
 	ASSERT_EQ(ftruncate(fd, size), 0);
+	ASSERT_EQ(fchmod(fd, mode), 0);
 
-	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
+	mapping = mmap(NULL, size, PROT_READ | PROT_WRITE, flags, fd, 0);
 	ASSERT_NE(mapping, MAP_FAILED);
 	close(fd);
 
 	return mapping;
 }
 
+/* Become an unprivileged user without capabilities. */
+static bool drop_privileges(void)
+{
+	return !setgroups(0, NULL) && !setgid(65534) && !setuid(65534);
+}
+
 /*
  * Both hints are best effort, so these tests check what userspace can rely
  * on: which mappings are accepted, which pages must never be reclaimed, and
@@ -432,7 +442,7 @@ TEST_F(madvise, cold_preserves_dirty_shared_file_page)
 {
 	char *mapping;
 
-	mapping = map_temp_file(_metadata, page_size);
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0600);
 	mapping[0] = 1;
 
 	ASSERT_EQ(madvise(mapping, page_size, MADV_COLD), 0);
@@ -449,7 +459,7 @@ TEST_F(madvise, pageout_preserves_dirty_shared_file_page)
 {
 	char *mapping;
 
-	mapping = map_temp_file(_metadata, page_size);
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0600);
 	mapping[0] = 1;
 
 	if (!pageout_until_evicted(_metadata, mapping, page_size,
@@ -639,4 +649,89 @@ TEST_F(madvise, cold_preserves_half_of_pte_mapped_thp)
 	ASSERT_EQ(munmap(mapping, pmd_size), 0);
 }
 
+/*
+ * The owner of a file may page out its clean page-cache pages. Run as an
+ * unprivileged owner, so that capabilities cannot stand in for ownership.
+ */
+TEST_F(madvise, pageout_evicts_owned_file_page)
+{
+	char *mapping, *control;
+
+	if (!geteuid() && !drop_privileges())
+		SKIP(return, "could not drop privileges");
+	pin_to_current_cpu(_metadata);
+
+	/* Make sure a writable file page can be paged out at all. */
+	control = map_temp_file(_metadata, page_size, MAP_PRIVATE, 0600);
+	ASSERT_EQ(control[0], 0);
+	if (!pageout_until_evicted(_metadata, control, page_size,
+				   self->pagemap_fd))
+		SKIP(return, "MADV_PAGEOUT did not evict a file page");
+
+	mapping = map_temp_file(_metadata, page_size, MAP_PRIVATE, 0400);
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_TRUE(pageout_until_evicted(_metadata, mapping, page_size,
+					  self->pagemap_fd));
+	ASSERT_EQ(mapping[0], 0);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+	ASSERT_EQ(munmap(control, page_size), 0);
+}
+
+/*
+ * A caller that neither owns nor may write a file must not page out its
+ * shared mappings. MADV_PAGEOUT succeeds but leaves the page resident.
+ */
+TEST_F(madvise, pageout_skips_unauthorized_shared_file)
+{
+	char *mapping;
+
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	mapping = map_temp_file(_metadata, page_size, MAP_SHARED, 0400);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd, mapping));
+	ASSERT_EQ(madvise(mapping, page_size, MADV_PAGEOUT), 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd, mapping));
+	ASSERT_EQ(mapping[0], 0);
+
+	ASSERT_EQ(munmap(mapping, page_size), 0);
+}
+
+/*
+ * A caller that neither owns nor may write a file may page out the anonymous
+ * COW pages of a private mapping of it, but must leave the file pages
+ * resident.
+ */
+TEST_F(madvise, pageout_private_file_reclaims_only_cow)
+{
+	char *mapping;
+	bool swapped;
+
+	if (geteuid())
+		SKIP(return, "requires root to change credentials");
+	mapping = map_temp_file(_metadata, 2 * page_size, MAP_PRIVATE,
+				0400);
+	if (!drop_privileges())
+		SKIP(return, "could not drop privileges");
+
+	ASSERT_EQ(mapping[0], 0);
+	ASSERT_EQ(mapping[page_size], 0);
+	mapping[0] = 1;
+
+	ASSERT_EQ(madvise(mapping, 2 * page_size, MADV_PAGEOUT), 0);
+	ASSERT_TRUE(pagemap_is_populated(self->pagemap_fd,
+					 mapping + page_size));
+	swapped = pagemap_is_swapped(self->pagemap_fd, mapping);
+	ASSERT_EQ(mapping[0], 1);
+	ASSERT_EQ(mapping[page_size], 0);
+	if (!swapped)
+		SKIP(return, "MADV_PAGEOUT did not swap the COW page");
+
+	ASSERT_EQ(munmap(mapping, 2 * page_size), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0


