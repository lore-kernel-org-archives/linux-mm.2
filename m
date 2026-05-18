Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DCCCD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 18:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1DE56B0092; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1E5C6B0098; Mon, 18 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB086B0092; Mon, 18 May 2026 14:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 73B0E6B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 14:17:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 369B5C2ADD
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:49 +0000 (UTC)
X-FDA: 84781349058.16.34F8727
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 067DD8000B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 18:17:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f1CzrJ4Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779128267;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3VHnK3s6VXbSGYuDii2HxLtz9AYe7gcbxOwMtbDuMv8=;
	b=UqaPUiqzMpllDaXst3vymNbrS7fGDQW6+QrjSCgbWYrtIqJEsyibXlq1c6BFGZcud9babj
	5a276mXFF8EL8bYwQFc0m7VxGa9ZtDYrKVKuIdReY5BEYJgGqvf9DdP6ENjaeY6QhPIvL5
	Mt0qDB77+Wb4m1qObgpJz+VFKF+8O6Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779128267; a=rsa-sha256;
	cv=none;
	b=nUWQZ0QOu6T4617c1QSdsJazjrv/linNlnaIo5Vju993UiNqZ6RjPeuDhDO18Lqf0zlPen
	l5LHM8VFNq6WtrmHKjIX4xyr2f27ZZIMFccfq0h4CiYE6TDWNfT6dW+S4Jr+7Y10lvQKnJ
	2FVTT+HVvHxCeYVy+NbtwmSiluzibLA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f1CzrJ4Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E9DC34454A;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C42C9C4AF13;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779128265;
	bh=JHk3R6g816OuqB1Hgt1l1LwWqhgjH6v3Sfs+FGIL2jU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=f1CzrJ4Yqo95t6yHU0KmyGCBnjXUxXIbLF0XKmEgnPj3QDd8hfz31iQj29DUC66yG
	 LdF9lVGvLdHoF/sUkrp8RZt5iD1L1l61bY+3TxtOuwXSU0FvdR4Cq/gYsXDvqLepmq
	 XsvrnkmqZ59yXphWF/RX/Vdem0JYu/U6cZo1frf6iVwu1wyX/qTFBoV4cr/LZmG2/D
	 sf4B1gL3QCWDW8rrSzd+8UDmUVesy/lDXVtpYMX9XjOMGyybi7pe/cKb9Qj5qVwmik
	 rOkP4uEc+5+QQD20ApwmBkbyE3bX+Yqtg9KEeGLScDfvUnOXNmi9oMmEezi/SOGy7d
	 APim1AMvT0muw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB958CD4F57;
	Mon, 18 May 2026 18:17:45 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Mon, 18 May 2026 11:17:36 -0700
Subject: [PATCH RFC 4/5] mm: selftests: Update hugepage-mmap to support
 hugetlbfs mount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260518-port-hugetlb-selftests-v1-4-d64ba3a785fe@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779128265; l=3375;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=UohDzF0IDPJpVfS8tMj24WgpCofY5vpUdRHF24vk2iU=;
 b=5uxe5mBqfzQ1SIKIcquQms4vhqqdYB3BUyQSZlrS81kmhC9iHur6Z1P4KUT/FsGZeEPqSznpj
 duVeqsyGbkjAeZx/X2wU4RhXQfpUX9wLvfFv9lFXFBOjzJc+o3dh6gl
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 067DD8000B
X-Stat-Signature: 8gpun7axgwws6cb3cfwc9pamstzdsj5a
X-Rspam-User: 
X-HE-Tag: 1779128266-868712
X-HE-Meta: U2FsdGVkX1+Y4M1uw4m9712cnpMmVCRAvVVmHG3codAe5yOzRlaeiFssY2HIY7X67eEkNES53+j+tAt2gJNX4RZrjwp4T1ZlklxIiMWeIC/hAIlYUxQI57KnT3p3JzCYM2YA2vabO1H4D4tEOrlVbtzDv2DllO6JTJkPxQvPPQB1uFBURlgYKE1hjvdr6lJVV3K7Veb4FRpxT2zPNKayLQWbi2W+hwXBpE8Wy70/ZOmwQ8AmzQuateMKzDjDzeV3IdLg90ogQaYme9+1pE/ja0mFEbozdzvhbBgk2N5KzwuU5t9MLg+hWxMfkI4NcPezRC2w22PnzWj5hMlzgjeSLLBQDlsgGmCIRx1Z4G/lyL38yC9bOKqw4kVOm/5x8X/1b8zZm5WlrKAIgFEdjdhhxkYElIIISyJicu1+wLwh7oLuET11R4a2O9FjXikaqRpAZKyoWRfmHqMoL+k+v8tc1FjtAHrKeZBJBgx8k0qTmfNG1FVm37VYSUnbSpdpb73ffIdLgqcErU13CHrh6ghH+DDURwc12dh3jHtFlCfb1tIgJkh3uGAGQCC/YsmOoPMJkBsGdjo9rdipZkzz9VUmlmb/Ku7xxA7s2AdJrqNqp67/uov60YvhZFEdHzgkwF10cRMrWtjMimAKHgB2g5m0lxrfBfL6KY+shNS8/3VOP1k1uBJ2DGJOWzxMnoYQBSbPJ5A817FMzpVT5HlKAQxZXDC65axjeGJrrbRuaf46ChziK7MhjDEdVTkGeCDfllAenTFosfrlJxycYFo9TgwIlUVFkuHXONt8CCl4SXmbjwjx6DdXfLGI5DmTz+5nkvud3fFeRM9zE9ocziGT6hxxdfBS8nuodCFq2fUG5Aiq32TVGyfMwQhagbgKEfbXeh9nOCowrYPPeza5vGPkTOcQ/tCgtFbl4X9zm4Rcq5NJKHCWsUxLrEig70SU+vxc77sA2pCushucGUC5XMe6KrC
 BcAluNnD
 /Dk6foeQfrxMPD6cd3BSStFXaR1RKveJUjOPsHMXxRHlfzzskOAWqiBnQl9e6UVT0DxyINK2jeI+R/OHWBXOjxKY2cN5/QViqTzCzSsWM5znOU6HW0i0M25jBlVPmasZu3ve/XKbReakSSfdYgtWiR5WXYtMiOK+0JeQdydTWLtvO56sX701Ae9b6rrYA31GqaMTA5dR899OYxFzmm4/yLC5bWiQq//NwrTxTpMLlTx9MSesU5F07EP+8JgtKX96ekbInsTQSFpx0VmuaLxCV9sXnt1iEK3YzB3cy+x/HKncYiqWjtzhgU9WdZd+gA/vUWJArxeklI41en10VyJyvYUxUapTQJseoIvB9+RYZTHrobau/i7P5x7PWM7q6xuivwfcXTmnUIq9N9XHC/AfhuIvEj43cY3MydO6t
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Run the same write/read test for a file on a hugetlbfs mount, in addition
to a memfd.

Use FIXTURE_VARIANT for parametrized testing. Use an unlinked fd to make
save cleanup steps later.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/mm/hugepage-mmap.c | 85 ++++++++++++++++++++++++++++--
 1 file changed, 80 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage-mmap.c b/tools/testing/selftests/mm/hugepage-mmap.c
index 9c8a0638d04b8..dd9fccb209b10 100644
--- a/tools/testing/selftests/mm/hugepage-mmap.c
+++ b/tools/testing/selftests/mm/hugepage-mmap.c
@@ -15,36 +15,111 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <limits.h>
 #include "kselftest_harness.h"
 
+static int hugetlbfs_unlinked_fd(const char *mount)
+{
+	char path[PATH_MAX];
+	int fd;
+
+	snprintf(path, sizeof(path), "%s/hugepage-mmap-XXXXXX", mount);
+	fd = mkstemp(path);
+	if (fd < 0)
+		return fd;
+
+	unlink(path);
+	return fd;
+}
+
 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
 
+enum fd_kind {
+	MEMFD,
+	HUGETLBFS_FD,
+};
+
 FIXTURE(hugepage_mmap)
 {
 	int fd;
 	char *addr;
+	char mount_dir[PATH_MAX];
+};
+
+static int fd_create(struct __test_metadata *_metadata,
+		FIXTURE_DATA(hugepage_mmap) *self, enum fd_kind fd_kind)
+{
+	switch (fd_kind) {
+	case MEMFD:
+		return memfd_create("hugepage-mmap", MFD_HUGETLB);
+	case HUGETLBFS_FD: {
+		snprintf(self->mount_dir, sizeof(self->mount_dir),
+			 "/tmp/hugepage-mmap-XXXXXX");
+		ASSERT_NE(NULL, mkdtemp(self->mount_dir))
+		{
+			TH_LOG("mkdtemp() failed: %s", strerror(errno));
+		}
+		ASSERT_EQ(0, mount("none", self->mount_dir, "hugetlbfs", 0,
+				   "pagesize=2M"))
+		{
+			TH_LOG("mount() failed: %s", strerror(errno));
+		}
+		return hugetlbfs_unlinked_fd(self->mount_dir);
+	}
+	default:
+		return -1;
+	};
+}
+
+FIXTURE_VARIANT(hugepage_mmap)
+{
+	enum fd_kind fd_kind;
+};
+
+FIXTURE_VARIANT_ADD(hugepage_mmap, memfd)
+{
+	.fd_kind = MEMFD,
+};
+
+FIXTURE_VARIANT_ADD(hugepage_mmap, hugetlbfs_fd)
+{
+	.fd_kind = HUGETLBFS_FD,
 };
 
 FIXTURE_SETUP(hugepage_mmap)
 {
-	self->fd = memfd_create("hugepage-mmap", MFD_HUGETLB);
+	self->fd = -1;
+	self->addr = MAP_FAILED;
+	self->mount_dir[0] = '\0';
+	/* Enable teardown to cleanup on any assertions in FIXTURE_SETUP(). */
+	*_metadata->no_teardown = false;
+
+	self->fd = fd_create(_metadata, self, variant->fd_kind);
 	ASSERT_GE(self->fd, 0) {
-		TH_LOG("memfd_create() failed: %s", strerror(errno));
+		TH_LOG("fd creation failed: %s", strerror(errno));
 	}
 
 	self->addr = mmap(NULL, LENGTH, PROTECTION, MAP_SHARED, self->fd, 0);
 	ASSERT_NE(MAP_FAILED, self->addr) {
 		TH_LOG("mmap(): %s", strerror(errno));
-		close(self->fd);
 	}
 	TH_LOG("Returned address is %p", self->addr);
 }
 
 FIXTURE_TEARDOWN(hugepage_mmap)
 {
-	munmap(self->addr, LENGTH);
-	close(self->fd);
+	if (self->addr != MAP_FAILED)
+		munmap(self->addr, LENGTH);
+	if (self->fd >= 0)
+		close(self->fd);
+
+	if (variant->fd_kind == HUGETLBFS_FD && self->mount_dir[0]) {
+		umount(self->mount_dir);
+		rmdir(self->mount_dir);
+	}
 }
 
 TEST_F(hugepage_mmap, read_write)

-- 
2.54.0.563.g4f69b47b94-goog



