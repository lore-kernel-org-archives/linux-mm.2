Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D79B4C5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E4A6B00A3; Wed, 19 Aug 2026 19:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8E96B00A4; Wed, 19 Aug 2026 19:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4A46B00A5; Wed, 19 Aug 2026 19:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE5D6B00A3
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:32 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 778571A066B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:31 +0000 (UTC)
X-FDA: 85119565062.02.FD44099
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id B25AA2000B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:29 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QyZeAj5g;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181029;
	b=OsMgb9Zp/EBSWFWt6RqO8UyvrgXB11lP5txeKldegNH68+E1h4zoEy13lxVk63LPcxaC3W
	FHqWUB1h4U5KYfdd0YX2qCkY7vXcHQiQJiD47f0KtDEapa/vylm+2a9jdQDCE2Z1vHdcQ2
	fvL2UqzP9mB5pP6FaukA+wcOJcIeJ1o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QyZeAj5g;
	spf=pass (imf31.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YdXiWhIfB4/T9Skkykrd3/nKKqeoThgdVH++ESCo2VU=;
	b=ZzaR3PYixBEWXKAeamVUpyPXzsLE5zAI3DdMaZgiXvnfUAmD6rOIsdlxWSqpuYHQWDx+0C
	8n7LgnVWyQ85F2k+bOud+Emal13p3KrVez34InR9QMG9zzL7zFIctb7KdYCx797sdUe7so
	nzbfGHueMjEK7GOQsclbY0zEPR2tZpY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B53E44016;
	Wed, 19 Aug 2026 23:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170201F000E9;
	Wed, 19 Aug 2026 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181028;
	bh=YdXiWhIfB4/T9Skkykrd3/nKKqeoThgdVH++ESCo2VU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QyZeAj5glCUzDjsxZE4JmbH5umochvY1cH28IICIMq+PVSNqs9f6uqzC3leCeKYeB
	 rfl/IBBdVwxU7IoZVCZk5U9aoMplnYPpsIRtSkZukDs9OzsIxCLpUdPh0RvEOuVohi
	 aPrB8VGlKZcBGkxy+NdZblHbunV0YNE0LJJngP4XBwkFXWjRgVDsk++j9VDR4YCUIP
	 F3a5HrJBM/Q/lJcKDMFOf5fWOe2ji9o/OeX3mhG8bepd2E0y5DVtZ2ONC5k+5VT52i
	 MDtcev4gHFqi35z6p3F3Ciy87B0Vi5vrvLU9DBq2wPALAkbyuovP9CBjRVq7gdXamp
	 /jf8Dukonc+rA==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:23 +0200
Subject: [PATCH v2 06/22] selftests/coredump: add a separate helper header
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-6-ba32dd718c51@kernel.org>
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
In-Reply-To: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>, 
 Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=4984; i=brauner@kernel.org;
 h=from:subject:message-id; bh=nsuGWse/lAGPONW5/zPiRodF4aWWrgZOlUZ3HMqmnYU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me+7qZKzWDv62wNhQ4FbqkVrA5z2f2iLbmV44Hffz
 2jyP3O/jlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInIpjAyLPfN5Nk1U+fxDK+7
 ldo5fxJlvIJ871syHZ0lp/tU/In3E0aG3SmJPrszs04dFfu1f//hXI2t9wwsN1ir/97jk/ticbE
 KLwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: B25AA2000B
X-Rspam-User: 
X-Stat-Signature: wihcsj6r9wtk5jq4ad67fjjmt6hn8akd
X-Rspamd-Server: rspam06
X-HE-Tag: 1787181029-675629
X-HE-Meta: U2FsdGVkX19f9+/QVSIyzCtfJteqOqrFIAsYy/7ejb6jUkbAyRaFZDUrqZ+TWE8vpLgZNzHjEqwTyU815l59+hICx+ctczgf4ZE0xS2Jr/E7j02T6MYv7kL6ePnIjzmYYqV/MxvYTQwLDzfvUdO7VUzs+ksL8tROk18e4zlrT1Ksf8QzdhMh/D+ekr9HC7s2OXOOyHO4LKzjqAq20h6jPKFNij3hT1WsC5RvLxx6LOZoZ+2BX6HUG4BT3TljMvbRKuuoa6GSiHKI6+z+7F1TlABcDqIcIlgyPuOFr9XStbHqdgu7ZjWrfKv2LYZqWL1wsdYrBltVsr3s0uUnG4uVl0P8Bk2m1BXVou7Rg9z0l+iXVKLp0Os+WS3U2p8fslTMGdN49MhkZeeUJotd7AVAnRSGUU+TGbVcs7RPFlYLqXUyV3HAkzLJCq2Ra34IbMvN20W7dC2pidDKtGt9z1i+604gAH+jtisUMebr8NIR/i69ZuF0wQ3giOBpLQ4YgD+0vpvD14r6O0wKjJ7Ct4bDK30FP3KMeErK8ar9GwKtao+uQqjSBGfgmO4OE8G/HzXvD2IsR47XgZyzlqbwMsY6q9EArQRTUTBjo8Eet1/KI6FAdtnMmpV0dgu10SBPfA5linpZ3z31xiXqGdmbDpWVhHugHkTMOcN2Wk9bkmoMiD1jmpVjon6Ypsu/S1+epypkfOy0OhrvUETMSrnUoeO/HOvxJffD4grsJV+/ZCwsQ5lGXezMYt74lb9hKHkTt5rQU+CJLlzAqkGc7AcbnbY8EUaN2Q6jMnBYjMiJYkaOJWasjd1Q5LNLyoOO+rkNWDWvSfp8FRfZepDGaO0WA9VglaCc7LW8NxQ3ZBTYe4LDF7rnZoFl6iMNFkwDQGQXuikMnROrsTDaqklS6B/wzOKzdalGVnS2oVTotnBYeE0MLuf/fx96TjcF4O+J/CWBSh5ygWk/Q1v4Elr/1zUYz3D
 CQ5KikvB
 IIa7Kx44BF56E7Li2T7CdQAc72tYWPt9aoQckpffiqAFnq82eAvcRCbE/iy1CtTwOEC+ZoLtxyjLT84pqExJBP90+ZJtG6Z79lyVDXUjEWpvxXGOED1cwKfObvy+z8LLIInZm7DlYgVo0dyrUp6U7IIIpa1Q3i4JaaJYH/OHt0xo3WDOEwOJ/21cEfiVhyaKN4CwHm+At/3KZfa6u5sW4/ZlObHWdhqlTNwjZikJzHZVB6B/FDlKCjyT64wDpUr7P7b7vdqdjRvfmVoAsAbEW20sSeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Right now we have coredump_test.h which pulls in the test harness.
So it can't be included in coredump_test_helpers.c and it hand-rolls a
bunch of stuff that is not needed.

Instead of this mess, split everything out into a separate
coredump_test_helpers.h header and make both coredump_test.h and
coredump_test_helpers.c include it.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 tools/testing/selftests/coredump/coredump_test.h   | 30 +-----------------
 .../selftests/coredump/coredump_test_helpers.c     | 17 +---------
 .../selftests/coredump/coredump_test_helpers.h     | 37 ++++++++++++++++++++++
 3 files changed, 39 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_test.h b/tools/testing/selftests/coredump/coredump_test.h
index a02809145e2d..8d99b5cb2f12 100644
--- a/tools/testing/selftests/coredump/coredump_test.h
+++ b/tools/testing/selftests/coredump/coredump_test.h
@@ -3,18 +3,9 @@
 #ifndef __COREDUMP_TEST_H
 #define __COREDUMP_TEST_H
 
-#include <stdbool.h>
-#include <sys/types.h>
-#include <linux/coredump.h>
-
 #include "../kselftest_harness.h"
-#include "../pidfd/pidfd.h"
-
-#ifndef PAGE_SIZE
-#define PAGE_SIZE 4096
-#endif
 
-#define NUM_THREAD_SPAWN 128
+#include "coredump_test_helpers.h"
 
 /* Coredump fixture */
 FIXTURE(coredump)
@@ -24,15 +15,6 @@ FIXTURE(coredump)
 	int fd_tmpfs_detached;
 };
 
-/* Shared helper function declarations */
-void *do_nothing(void *arg);
-void crashing_child(void);
-int create_detached_tmpfs(void);
-int create_and_listen_unix_socket(const char *path);
-bool set_core_pattern(const char *pattern);
-int get_peer_pidfd(int fd);
-bool get_pidfd_info(int fd_peer_pidfd, struct pidfd_info *info);
-
 /* Inline helper that uses harness types */
 static inline void wait_and_check_coredump_server(pid_t pid_coredump_server,
 						   struct __test_metadata *const _metadata,
@@ -45,14 +27,4 @@ static inline void wait_and_check_coredump_server(pid_t pid_coredump_server,
 	ASSERT_EQ(WEXITSTATUS(status), 0);
 }
 
-/* Protocol helper function declarations */
-ssize_t recv_marker(int fd);
-bool read_marker(int fd, enum coredump_mark mark);
-bool read_coredump_req(int fd, struct coredump_req *req);
-bool send_coredump_ack(int fd, const struct coredump_req *req,
-		       __u64 mask, size_t size_ack);
-bool check_coredump_req(const struct coredump_req *req);
-int open_coredump_tmpfile(int fd_tmpfs_detached);
-void process_coredump_worker(int fd_coredump, int fd_peer_pidfd, int fd_core_file);
-
 #endif /* __COREDUMP_TEST_H */
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 306711e1b24d..570fc2e005c2 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -20,23 +20,8 @@
 #include <unistd.h>
 
 #include "../filesystems/wrappers.h"
-#include "../pidfd/pidfd.h"
 
-/* Forward declarations to avoid including harness header */
-struct __test_metadata;
-
-/* Match the fixture definition from coredump_test.h */
-struct _fixture_coredump_data {
-	char original_core_pattern[256];
-	pid_t pid_coredump_server;
-	int fd_tmpfs_detached;
-};
-
-#ifndef PAGE_SIZE
-#define PAGE_SIZE 4096
-#endif
-
-#define NUM_THREAD_SPAWN 128
+#include "coredump_test_helpers.h"
 
 void *do_nothing(void *arg)
 {
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
new file mode 100644
index 000000000000..45904bd177b8
--- /dev/null
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __COREDUMP_TEST_HELPERS_H
+#define __COREDUMP_TEST_HELPERS_H
+
+#include <stdbool.h>
+#include <sys/types.h>
+#include <linux/coredump.h>
+
+#include "../pidfd/pidfd.h"
+
+#ifndef PAGE_SIZE
+#define PAGE_SIZE 4096
+#endif
+
+#define NUM_THREAD_SPAWN 128
+
+/* Shared helper function declarations */
+void *do_nothing(void *arg);
+void crashing_child(void);
+int create_detached_tmpfs(void);
+int create_and_listen_unix_socket(const char *path);
+bool set_core_pattern(const char *pattern);
+int get_peer_pidfd(int fd);
+bool get_pidfd_info(int fd_peer_pidfd, struct pidfd_info *info);
+
+/* Protocol helper function declarations */
+ssize_t recv_marker(int fd);
+bool read_marker(int fd, enum coredump_mark mark);
+bool read_coredump_req(int fd, struct coredump_req *req);
+bool send_coredump_ack(int fd, const struct coredump_req *req,
+		       __u64 mask, size_t size_ack);
+bool check_coredump_req(const struct coredump_req *req);
+int open_coredump_tmpfile(int fd_tmpfs_detached);
+void process_coredump_worker(int fd_coredump, int fd_peer_pidfd, int fd_core_file);
+
+#endif /* __COREDUMP_TEST_HELPERS_H */

-- 
2.53.0


