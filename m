Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C28A0C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C81CB6B00A1; Wed, 19 Aug 2026 19:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C32A96B00A2; Wed, 19 Aug 2026 19:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B20D56B00A3; Wed, 19 Aug 2026 19:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 717B36B00A1
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:10:27 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C9531405D6
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:26 +0000 (UTC)
X-FDA: 85119564852.17.67527F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64844160009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:10:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=idyv5wfo;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mn//jld94IflaVCOAy9GNpJdqgXUD79h4mfVzAad5s8=;
	b=W9j9Wtz/8CAXfwPPTFnEgjAd2jNymFPPdot7wtcMXuz45eLtHkcyq7cI7ZYVUecZZU4em1
	sauIdPAb2PxRK3Ea74f9TDBDfhQB7cfT4yTvDMoQwpYlZA1gpYeDjx16zUX70A6Vqlj97/
	0JCJAClExpE/Q2S7FvO5usceTzAkBwU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=idyv5wfo;
	spf=pass (imf08.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181024;
	b=QyPYNVZqLLOwsGxChGAkH+vI2bvozOhe6cyana37S35Xp/p0ASDfZ4fXeH+EzHqLgrt+Pp
	P2MhnwxrdXpyiwFFDp4XNXUkMTp5JOiYDO4t5Fv5GBcPqiwm7KjOsKrMcIWX8JxKWwvEEH
	wYjT1D6xrdFqN6wLOHlrAnatwKIk88g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B20FF40524;
	Wed, 19 Aug 2026 23:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66891F00A3A;
	Wed, 19 Aug 2026 23:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181023;
	bh=Mn//jld94IflaVCOAy9GNpJdqgXUD79h4mfVzAad5s8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=idyv5wfo9Pmww74TbNZCqGyPDb7RpSVAboVaSmhSgyUpAlIUJN+LwzMf2o14VvrT4
	 MeeJtOWMMRLoOdr8xhdnor7vsCKMraQBXUdlQJccWLbBHFQNEKqekfu8lOV7IuoA8P
	 EWy8NWlYPDKAKgcynwhK8e1kBWbqtcNfTucMqjC+i6qX6V9gSVj5h/QyIa/is4+GtX
	 /tkKBSCHk+tvF4zqwTBhe8NceRWyprrE5mSouQVN6rGR3+Y1lHMHqO7ekJbkoNPTZ6
	 SUDIJONYkaDVQFzJPNJTkxbm28ODEsWtor+i2czbma9svlM5bYoB3AEKK+F8fOvH/a
	 KMkCwUbiK1CWw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:22 +0200
Subject: [PATCH v2 05/22] selftests/coredump: collapse the expected request
 check into the helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-5-ba32dd718c51@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=8202; i=brauner@kernel.org;
 h=from:subject:message-id; bh=1cIdjFnIkK2Pl9ULrDuU5PzmspGiS0xBl42KkhmV1jU=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me+rPfDayTDxeJdF4lJTG4nfFi07W19NzlRcYGooH
 Hdl0vf9HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABOR02H4H1U1Wzv8wS2Dnw5S
 J3d+CZkae/KzsCyHQhXD/ZyKEKWrzowMkxed3GB5getIw2HjV6su3v/AGtISwLawZP1nZXn9mqK
 PnAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64844160009
X-Stat-Signature: yk8bwanud8jefj86esi9jtdwu7zic6de
X-Rspam-User: 
X-HE-Tag: 1787181024-8981
X-HE-Meta: U2FsdGVkX18rhHajIn+9lyMHV416Iah69ZdEGkaO4tQEZmlfR9mbMFG/L5ZrZdtfR5i5OquJv8s6D3FsCh7Ze15ljbYOTJ+woqUjWxwYyoO1ei5ngVXsgkW1hoc/TKkUSr49tq8ctiKuAE8ipeDerbyibwWY38TPJBz0QKZ+EUNTxz5Ye73LBdRRSerPg55qi2ccOmAFGNcaJJFcol5DSQBPZA5Sa61Du9KyjEqtUiOjr8pYfVoFnqs5uN+6R5H/ao9Oegv+DKm1hdUHVbXQGpzyBG9hEqC8na3B4776G6cLW9gGxfPuR9RtzsCbBWmwUxPviy1ub66FZeoj/2P8gx8Kd/alhoKmJsdgR5mn5nl63NbvKu3cG5VbrYGTQbK7L82yGVLNhCqQKNx0Zrq7n3Gkb22xfOUqUEUnE81kl13jfAjvhWxYN1pgsON3GIFCxL/sj9HBO3hdCgVRrcInWE4XWoCgRZn84SUFn77re6LW6Rqscv/gPna3MtwnFzVP2BH0W4wiO5IJXj6eNjLPqzdHwprNYgpVwJuW/1SDIcab+fdg3Wg1XapO4s702tRtdXijicsO9UyxieQ2n7kSQINHLcH98QQywCngEwq7vzCyqq5gLyB8pY1VUJzHWvktdZgYO11B2SCDpp6kEJyPZsv8UUiOuzEOhLhmbFcfR0xftlNtbpYMQ2bO1rGAHt5d8Y7UkbHhgfRe/wthUXCqQOg1cMV4c4gaQMIzcA6SamAQrykQr64Wa3G1YqEIV0LKGHg5dz9sYWur4H97a6ttVllR813giyzaN7EcB2gsE+OyzHCMbNoqua0H6SL7ukNBtXBWpkyUP4xT2Bf5nu441P+t+NWVKLJsRjwWYwyMG1NPkcJlJy4i3t/9KvNFI6Ps6Ab82P3q1mSDqUXFSxLlSpqymE99LGGK2i2eoG+qbNtUUzeY2q/RzSTsnqKpEDZSNhHLdIYgNuu21sjGtZV
 fPt40BuZ
 6Bq6ZX5p4dJQ2jNbwtdDK+ls5p82/65SuH7MSZVEKJzo+GK7pig51Cm+qd3eoIOWnLnSyl+kQfag/ERrdSPfUmbw1XPuuesmVDv7t6MCgIoAyi0ngXZN12tfzIBP3l9/XDHlKGVOJnLySWS44ddSnRW6/HRu6pXQaF25uf9x09ZfHujXI9y8fFmfIezeiCGbj6ZpFFNUuSfPSPdYc5ktYcfFRZMm7xiZMqxFG3AgzhxOnayQlM76amwr8XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All nine callers spell the expected flags. So every new feature bit the
kernel learns has to be cargo culted.

The callers also all pass COREDUMP_ACK_SIZE_VER0 as the minimum request
size although what is being validated is coredump_req->size. And
read_coredump_req() makes the same mixup twice more.

Clean this all up.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 36 ++++++----------------
 tools/testing/selftests/coredump/coredump_test.h   |  3 +-
 .../selftests/coredump/coredump_test_helpers.c     | 35 +++++++++++++--------
 3 files changed, 32 insertions(+), 42 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index d9fa6239b5a9..60a357e628eb 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -151,9 +151,7 @@ TEST_F(coredump, socket_request_kernel)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_kernel: check_coredump_req failed\n");
 			goto out;
 		}
@@ -301,9 +299,7 @@ TEST_F(coredump, socket_request_userspace)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_userspace: check_coredump_req failed\n");
 			goto out;
 		}
@@ -441,9 +437,7 @@ TEST_F(coredump, socket_request_reject)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_reject: check_coredump_req failed\n");
 			goto out;
 		}
@@ -581,9 +575,7 @@ TEST_F(coredump, socket_request_invalid_flag_combination)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_invalid_flag_combination: check_coredump_req failed\n");
 			goto out;
 		}
@@ -702,9 +694,7 @@ TEST_F(coredump, socket_request_unknown_flag)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_unknown_flag: check_coredump_req failed\n");
 			goto out;
 		}
@@ -822,9 +812,7 @@ TEST_F(coredump, socket_request_invalid_size_small)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_invalid_size_small: check_coredump_req failed\n");
 			goto out;
 		}
@@ -944,9 +932,7 @@ TEST_F(coredump, socket_request_invalid_size_large)
 			goto out;
 		}
 
-		if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-					COREDUMP_KERNEL | COREDUMP_USERSPACE |
-					COREDUMP_REJECT | COREDUMP_WAIT)) {
+		if (!check_coredump_req(&req)) {
 			fprintf(stderr, "socket_request_invalid_size_large: check_coredump_req failed\n");
 			goto out;
 		}
@@ -1355,9 +1341,7 @@ TEST_F_TIMEOUT(coredump, socket_multiple_crashing_coredumps, 500)
 				goto out;
 			}
 
-			if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-						COREDUMP_KERNEL | COREDUMP_USERSPACE |
-						COREDUMP_REJECT | COREDUMP_WAIT)) {
+			if (!check_coredump_req(&req)) {
 				fprintf(stderr, "check_coredump_req failed for fd %d\n", fd_coredump);
 				goto out;
 			}
@@ -1509,9 +1493,7 @@ TEST_F_TIMEOUT(coredump, socket_multiple_crashing_coredumps_epoll_workers, 500)
 				fprintf(stderr, "socket_multiple_crashing_coredumps_epoll_workers: read_coredump_req failed\n");
 				goto out;
 			}
-			if (!check_coredump_req(&req, COREDUMP_ACK_SIZE_VER0,
-						COREDUMP_KERNEL | COREDUMP_USERSPACE |
-						COREDUMP_REJECT | COREDUMP_WAIT)) {
+			if (!check_coredump_req(&req)) {
 				fprintf(stderr, "socket_multiple_crashing_coredumps_epoll_workers: check_coredump_req failed\n");
 				goto out;
 			}
diff --git a/tools/testing/selftests/coredump/coredump_test.h b/tools/testing/selftests/coredump/coredump_test.h
index ed47f01fa53c..a02809145e2d 100644
--- a/tools/testing/selftests/coredump/coredump_test.h
+++ b/tools/testing/selftests/coredump/coredump_test.h
@@ -51,8 +51,7 @@ bool read_marker(int fd, enum coredump_mark mark);
 bool read_coredump_req(int fd, struct coredump_req *req);
 bool send_coredump_ack(int fd, const struct coredump_req *req,
 		       __u64 mask, size_t size_ack);
-bool check_coredump_req(const struct coredump_req *req, size_t min_size,
-			__u64 required_mask);
+bool check_coredump_req(const struct coredump_req *req);
 int open_coredump_tmpfile(int fd_tmpfs_detached);
 void process_coredump_worker(int fd_coredump, int fd_peer_pidfd, int fd_core_file);
 
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 524fa5370593..306711e1b24d 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -200,7 +200,7 @@ bool read_marker(int fd, enum coredump_mark mark)
 bool read_coredump_req(int fd, struct coredump_req *req)
 {
 	ssize_t ret;
-	size_t field_size, user_size, ack_size, kernel_size, remaining_size;
+	size_t field_size, user_size, known_size, kernel_size, remaining_size;
 
 	memset(req, 0, sizeof(*req));
 	field_size = sizeof(req->size);
@@ -214,9 +214,9 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	}
 	kernel_size = req->size;
 
-	if (kernel_size < COREDUMP_ACK_SIZE_VER0) {
+	if (kernel_size < COREDUMP_REQ_SIZE_VER0) {
 		fprintf(stderr, "read_coredump_req: kernel_size %zu < min %d\n",
-			kernel_size, COREDUMP_ACK_SIZE_VER0);
+			kernel_size, COREDUMP_REQ_SIZE_VER0);
 		return false;
 	}
 	if (kernel_size >= PAGE_SIZE) {
@@ -225,11 +225,11 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 		return false;
 	}
 
-	/* Use the minimum of user and kernel size to read the full request. */
+	/* Consume as much of the request as we know about. */
 	user_size = sizeof(struct coredump_req);
-	ack_size = user_size < kernel_size ? user_size : kernel_size;
-	ret = recv(fd, req, ack_size, MSG_WAITALL);
-	if (ret != ack_size)
+	known_size = user_size < kernel_size ? user_size : kernel_size;
+	ret = recv(fd, req, known_size, MSG_WAITALL);
+	if (ret != known_size)
 		return false;
 
 	fprintf(stderr, "Read coredump request with size %u and mask 0x%llx\n",
@@ -287,15 +287,24 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
 	return true;
 }
 
-bool check_coredump_req(const struct coredump_req *req, size_t min_size,
-			__u64 required_mask)
+/* Every option the kernel is expected to advertise in coredump_req->mask. */
+#define TEST_REQ_MASK_ALL					\
+	(COREDUMP_KERNEL | COREDUMP_USERSPACE |			\
+	 COREDUMP_REJECT | COREDUMP_WAIT)
+
+bool check_coredump_req(const struct coredump_req *req)
 {
-	if (req->size < min_size)
-		return false;
-	if ((req->mask & required_mask) != required_mask)
+	if (req->size < COREDUMP_REQ_SIZE_VER0) {
+		fprintf(stderr, "%s: size %u below minimum %d\n",
+			__func__, req->size, COREDUMP_REQ_SIZE_VER0);
 		return false;
-	if (req->mask & ~required_mask)
+	}
+	if (req->mask != TEST_REQ_MASK_ALL) {
+		fprintf(stderr, "%s: mask 0x%llx, expected 0x%llx\n",
+			__func__, (unsigned long long)req->mask,
+			(unsigned long long)TEST_REQ_MASK_ALL);
 		return false;
+	}
 	return true;
 }
 

-- 
2.53.0


