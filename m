Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 966BCC5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6496B00BF; Wed, 19 Aug 2026 19:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAD8E6B00C0; Wed, 19 Aug 2026 19:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C3B06B00C1; Wed, 19 Aug 2026 19:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7366B00BF
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:11:59 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EDAD6A0692
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:58 +0000 (UTC)
X-FDA: 85119568716.16.76AB266
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 325F7180006
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:11:57 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdmK1nVR;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uz/hCCZUEbNBkvLVWgRR2B46lC9+EzmzxwQb7OwOCew=;
	b=u5Cd36veL0WhzqKRlj4W4W83MgJ/HWCgBM6fzDU2j228rdGvPBmAjMU6U6Sni2C7C+P5wd
	z8NRSlYNnsCB2waJbLRmSicDY8h9Nj8Zwzp2qebowlW3yGJBWDO6TBj/S4FkRhEA/OKWeB
	OBcU4xzDHBvai6SvePTb1wVALIrN3aM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdmK1nVR;
	spf=pass (imf06.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181117;
	b=jr8cZKm8prxAI8IaXzTZOuM+xSRHNhelM3mm5YulbV71uRNQpijeGg8ZmChVCUrikTqgTc
	F9uTc7aYPPLaJ7g9ZHVpy/ImM7bIZ5FzLEEaEtSletLpQrzQlU9hgWx8iEBE5Kdehc/pBT
	1dOMh/XNbgFTCJAAtvSnggcBUd160KA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC6CB61892;
	Wed, 19 Aug 2026 23:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAA21F000E9;
	Wed, 19 Aug 2026 23:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181116;
	bh=uz/hCCZUEbNBkvLVWgRR2B46lC9+EzmzxwQb7OwOCew=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OdmK1nVRcyzdLfJ3DaTLXvjT5/tLTDyDHe68b/3eFIJajF48Vg/xN3WSoddwjWEWw
	 YsYGp7cDFBvStU4lBAjPAJ4S7EOYi19pmHBokVar3apDGw9ZJFZ5d/P1MnONgeDFaC
	 GYVan2w5KGSWDmoa3FkSbS+tAHaMIUCh8RytjUs8YvPTlsuWhrFd5ZnOrpSOiEDTl8
	 wsjzJNJcuFnmEeBbCPJzA7XC/0NfoJv93wXuopcHFFl7F99ZwmBiOzFzleGZoCEqtA
	 6zWKIsg670RnpAQvSzG+pV9jDSA0VaQWGdPbHQ/4UOgSshs590Q/RZ9N7rt2BllrDT
	 2/CY6q4LFdnEg==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:38 +0200
Subject: [PATCH v2 21/22] selftests/coredump: simulate a blob store
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-21-ba32dd718c51@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=27940; i=brauner@kernel.org;
 h=from:subject:message-id; bh=5NEcdsz3zXkHI7elAnF+r10fYVs6EY86aumEE//1PaE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me/fv8q54rvdX8V3XculHZ57rJHMfqf8UoHXxZwz/
 qYQ46v3HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpADf5E8NfqX8Xo6qbhOM8Mmbw
 6SV07pdP/hjgUts86/L0grIDEU6/GRkOZQUcaGG2yFqWyXNy4TP/1Tcvuu6arLtSNMEta4skx10
 2AA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 325F7180006
X-Stat-Signature: e4jqimk8dfgjaf6zjzbbd61dxg7wyaxt
X-Rspam-User: 
X-HE-Tag: 1787181116-853310
X-HE-Meta: U2FsdGVkX18CAowT6idXnbYZekgDBa66tsobnYx3+TAd4WBhQivsB/8qYJlXBFEBjN+sqxmEkZ9WrQH7H4xGX7J9sTc4+MZCs3QYOgbyA+N1Hr2lfPlu+ArM7qDzo5qL2fLA9meeyCVYWgxzeNClVFrIYkrM1mYe60Yk4J5VD2oS/vIY7btNKvdS3llZPQpGAWa7WCgklqUVVj9AOGC+RHWIRcXADHfBV4X4w7m5j0Xny2aXlE4GgM7TQIxjgPXONDFOeM6YiZEFqWfuq3jvZwQVXv6l9VW3O8YPW/ck2o+RB+1o6oHTEOOXZtbuEOU4rvc9Wz3jZjrUfm985vELc2ITrYK98voH28R67D0pOCpVXcclJrmmUNHfkaWBgv43HvW5EHJpRslvAU4i0/nZWN/kOumTvrXwXVMlbXSaO0uN5Xvj15mmSHSajUWBS8iMrTIuZ8Rg6mowYMLLBxXIvMQIx2HbxouS4frBrGV0dLNpXoI4HwpCa5N10IhUMs5GSB2unN13zSutLK0cJO4jnt9bY8VcM8zza47pvcSUvFywg66asjvK9eYckgYO3xvM/EXL/ZAvAqfFn8bjJKparWb7wSh+xj8YLKTJOtEeexHt8ZNf9DG0mwzg7rAgf1PCZLMDdzuSNkVLmRph7RVYgwWz5mO+J+/GLJdZLVH/nTJabQNGPicDBO2wnFVIqt0yx4NGAY2QopVdGrm45tHvWGTQSJDm4WtkRl/9AIMjXT94wS42zARjygG5wR/8lEPC4L7o+SICdiTkjy9w/X+wRnKsY1Ob3vrjUXz5ZNL0gqg76hsCGCgAUseOk8hTQo/w/mr2kSj4VGRJ2bznebo2QxKuuQihmQJgjGicG16rtlE9EAYkUcRznHhMtUbsTS7krJKF4t2AxElw/ZUnaOWbm3+IqnxQx522jhQSsAS0K6rSuYU7p1l+DyGHOsS5+3FCdICMVEeC92GzwoX48oY
 beAHbW4u
 gClRADFungct4O5Ov5E3qpzoQ/X0D0r+ORflTWwnTHRqn6Rl/VuHhqWx4YmhSSLMa0OnA5fCjM/dA4+d0wnx3aTNRr9Cph4jcp0SqAq+Qn4TGEDIAx7NsS0Mhmbzvs30cB8qwsmL1fRnJguBgHGFmglw6+tKmjhgjia07JQ72Lh0288cuMHUkTYzmNpxIRzUX2ED92VKQvFTwae/CsNfhcY16g5+3VQym66sd3cHy5ZKmYWi6LeEOOl/dQYkwFfnfyFX7bCX2KX8GBPHjzPv/fDgRPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A coredump server that uploads to a blob store must redescribe the
coredump and fixup the phdr.

A segment is split wherever a hole was left out and everything a segment
covers past p_filesz is zeroes anyway. So the blob store ends up with an
ordinary ELF core file that is missing nothing but holes. Nothing
downstream of the server has to learn a container format.

The coredump with its holes still in it is reassembled alongside the
object so the two can be compared.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 156 +++++
 .../selftests/coredump/coredump_test_helpers.c     | 765 +++++++++++++++++++++
 .../selftests/coredump/coredump_test_helpers.h     |   3 +
 3 files changed, 924 insertions(+)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index abf6e2c4c354..f33eaf2fa93d 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -1882,6 +1882,162 @@ TEST_F(coredump, socket_request_records_truncated)
 	ASSERT_GT(received, 0);
 }
 
+/*
+ * A coredump server that uploads to a blob store can't upload a sparse
+ * file. It doesn't have to: it streams the data records into the object
+ * as they arrive, leaves the holes out, and uploads the corrected
+ * program header table last. What it ends up with is an ordinary ELF
+ * core file that describes the same memory as the coredump the records
+ * came from, minus the holes.
+ */
+TEST_F(coredump, socket_request_sparse_blob_upload)
+{
+	int fd_core_file, pidfd, status;
+	pid_t pid, pid_coredump_server;
+	struct pidfd_info info = {};
+	off_t coredump_size = 0;
+	ssize_t received = 0;
+	int ipc_sockets[2];
+	int pipefds[2];
+	struct stat st;
+	char c;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
+	ASSERT_EQ(pipe(pipefds), 0);
+	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
+		int fd_object = -1, fd_reference = -1;
+		int exit_code = EXIT_FAILURE;
+		struct coredump_req req = {};
+		off_t size = 0;
+		ssize_t ret;
+
+		close(ipc_sockets[0]);
+		close(pipefds[0]);
+
+		fd_server = create_and_listen_unix_socket("/tmp/coredump.socket");
+		if (fd_server < 0)
+			goto out;
+
+		if (write_nointr(ipc_sockets[1], "1", 1) < 0)
+			goto out;
+
+		close(ipc_sockets[1]);
+
+		fd_coredump = accept4(fd_server, NULL, NULL, SOCK_CLOEXEC);
+		if (fd_coredump < 0)
+			goto out;
+
+		fd_peer_pidfd = get_peer_pidfd(fd_coredump);
+		if (fd_peer_pidfd < 0)
+			goto out;
+
+		/* The object is a plain file. It never sees a hole. */
+		fd_object = open("/tmp/coredump.file",
+				 O_RDWR | O_CREAT | O_TRUNC | O_CLOEXEC, 0600);
+		if (fd_object < 0)
+			goto out;
+
+		/*
+		 * The coredump with its holes still in it is bigger than
+		 * the mapping the child made, so keep it on the detached
+		 * tmpfs and sparse.
+		 */
+		fd_reference = open_coredump_tmpfile(self->fd_tmpfs_detached);
+		if (fd_reference < 0)
+			goto out;
+
+		if (!read_coredump_req(fd_coredump, &req))
+			goto out;
+
+		if (!check_coredump_req(&req))
+			goto out;
+
+		if (!send_coredump_ack(fd_coredump, &req,
+				       COREDUMP_KERNEL | COREDUMP_RECORDS |
+				       COREDUMP_SPARSE | COREDUMP_WAIT, 0))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
+			goto out;
+
+		ret = recv_coredump_compact(fd_coredump, fd_object,
+					    fd_reference, &size);
+		if (ret < 0)
+			goto out;
+
+		if (check_compact_coredump(fd_object, fd_reference))
+			goto out;
+
+		if (write_nointr(pipefds[1], &ret, sizeof(ret)) != sizeof(ret))
+			goto out;
+		if (write_nointr(pipefds[1], &size, sizeof(size)) != sizeof(size))
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
+		close(pipefds[1]);
+		if (fd_reference >= 0)
+			close(fd_reference);
+		if (fd_object >= 0)
+			close(fd_object);
+		if (fd_peer_pidfd >= 0)
+			close(fd_peer_pidfd);
+		if (fd_coredump >= 0)
+			close(fd_coredump);
+		if (fd_server >= 0)
+			close(fd_server);
+		_exit(exit_code);
+	}
+	self->pid_coredump_server = pid_coredump_server;
+
+	EXPECT_EQ(close(ipc_sockets[1]), 0);
+	EXPECT_EQ(close(pipefds[1]), 0);
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child_sparse(SPARSE_MAPPING_SIZE);
+
+	pidfd = sys_pidfd_open(pid, 0);
+	ASSERT_GE(pidfd, 0);
+
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_TRUE(WCOREDUMP(status));
+
+	ASSERT_EQ(read_nointr(pipefds[0], &received, sizeof(received)),
+		  sizeof(received));
+	ASSERT_EQ(read_nointr(pipefds[0], &coredump_size, sizeof(coredump_size)),
+		  sizeof(coredump_size));
+	EXPECT_EQ(close(pipefds[0]), 0);
+
+	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
+	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
+	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+
+	/* The mapping is in the coredump, holes included. */
+	ASSERT_GT(coredump_size, (off_t)SPARSE_MAPPING_SIZE);
+
+	/* The object isn't sparse and doesn't carry them. */
+	ASSERT_EQ(stat("/tmp/coredump.file", &st), 0);
+	ASSERT_LT(st.st_size, coredump_size / 8);
+
+	/* And a debugger still sees an ordinary ELF core file. */
+	fd_core_file = open("/tmp/coredump.file", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(fd_core_file, 0);
+	ASSERT_TRUE(is_elf_core(fd_core_file));
+	EXPECT_EQ(close(fd_core_file), 0);
+}
+
 /* Ack @ack_mask, expect the kernel to refuse it as conflicting. */
 static void check_conflicting_ack(struct __test_metadata *const _metadata,
 				  FIXTURE_DATA(coredump) *self, __u64 ack_mask)
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 89f3954c5607..9346b8f688e2 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -330,6 +330,771 @@ bool is_elf_core(int fd)
 	return true;
 }
 
+/*
+ * A coredump server that uploads to a blob store can't upload a sparse
+ * file and can't seek in the object it is uploading. It streams the data
+ * records into the object as they arrive, remembers the holes it left
+ * out, and uploads the program header table that describes the result
+ * last. What comes out is an ordinary ELF core file without the holes.
+ */
+
+/* A run of the coredump the object doesn't carry. */
+struct compact_hole {
+	__u64 offset;
+	__u64 len;
+};
+
+/* A program header of the object and where its bytes sat in the coredump. */
+struct compact_piece {
+	ElfW(Phdr) phdr;
+	__u64 src;
+};
+
+struct compact_ctx {
+	int fd_body;			/* the object's payload, append only */
+	int fd_reference;		/* the coredump with its holes, for the test */
+	unsigned char *head;		/* everything ahead of the segment data */
+	size_t head_len;
+	size_t head_cap;
+	__u64 data_offset;		/* where the segment data starts, 0 while unknown */
+	struct compact_hole *holes;
+	size_t nr_holes;
+	size_t holes_cap;
+	__u64 body_len;
+};
+
+/* Write @len bytes out, short writes and all. */
+static int compact_write(int fd, const void *buf, size_t len)
+{
+	const unsigned char *pos = buf;
+
+	while (len) {
+		ssize_t ret = write(fd, pos, len);
+
+		if (ret <= 0) {
+			fprintf(stderr, "%s: write failed: %m\n", __func__);
+			return -1;
+		}
+
+		pos += ret;
+		len -= ret;
+	}
+
+	return 0;
+}
+
+/* Keep @len bytes of the head, or @len zeroes if @buf is NULL. */
+static int compact_head_append(struct compact_ctx *ctx, const void *buf,
+			       size_t len)
+{
+	if (ctx->head_len + len > ctx->head_cap) {
+		size_t cap = ctx->head_cap ? ctx->head_cap : PAGE_SIZE;
+		unsigned char *head;
+
+		while (cap < ctx->head_len + len)
+			cap *= 2;
+
+		head = realloc(ctx->head, cap);
+		if (!head) {
+			fprintf(stderr, "%s: out of memory\n", __func__);
+			return -1;
+		}
+		ctx->head = head;
+		ctx->head_cap = cap;
+	}
+
+	if (buf)
+		memcpy(ctx->head + ctx->head_len, buf, len);
+	else
+		memset(ctx->head + ctx->head_len, 0, len);
+	ctx->head_len += len;
+
+	return 0;
+}
+
+/* Remember a hole so the program header table can account for it later. */
+static int compact_keep_hole(struct compact_ctx *ctx, __u64 offset, __u64 len)
+{
+	if (ctx->nr_holes == ctx->holes_cap) {
+		size_t cap = ctx->holes_cap ? ctx->holes_cap * 2 : 64;
+		struct compact_hole *holes;
+
+		holes = realloc(ctx->holes, cap * sizeof(*holes));
+		if (!holes) {
+			fprintf(stderr, "%s: out of memory\n", __func__);
+			return -1;
+		}
+		ctx->holes = holes;
+		ctx->holes_cap = cap;
+	}
+
+	ctx->holes[ctx->nr_holes].offset = offset;
+	ctx->holes[ctx->nr_holes].len = len;
+	ctx->nr_holes++;
+
+	return 0;
+}
+
+/* The segment data starts where the first PT_LOAD points. */
+static int compact_probe(struct compact_ctx *ctx)
+{
+	const ElfW(Ehdr) *ehdr = (const ElfW(Ehdr) *)ctx->head;
+	const ElfW(Phdr) *phdr;
+	size_t i;
+
+	if (ctx->data_offset || ctx->head_len < sizeof(*ehdr))
+		return 0;
+
+	if (!is_core_ehdr(ehdr)) {
+		fprintf(stderr, "%s: not an ELF core file\n", __func__);
+		return -1;
+	}
+
+	if (ehdr->e_phoff != sizeof(*ehdr) ||
+	    ehdr->e_phentsize != sizeof(ElfW(Phdr)) ||
+	    ehdr->e_phnum == 0 || ehdr->e_phnum == PN_XNUM) {
+		fprintf(stderr, "%s: unhandled program header table\n", __func__);
+		return -1;
+	}
+
+	if (ctx->head_len < ehdr->e_phoff +
+			    (size_t)ehdr->e_phnum * ehdr->e_phentsize)
+		return 0;
+
+	phdr = (const ElfW(Phdr) *)(ctx->head + ehdr->e_phoff);
+	for (i = 0; i < ehdr->e_phnum; i++) {
+		if (phdr[i].p_type != PT_LOAD)
+			continue;
+		if (!ctx->data_offset || phdr[i].p_offset < ctx->data_offset)
+			ctx->data_offset = phdr[i].p_offset;
+	}
+
+	if (!ctx->data_offset) {
+		fprintf(stderr, "%s: coredump without a single segment\n",
+			__func__);
+		return -1;
+	}
+
+	return 0;
+}
+
+/*
+ * Take whatever of [@offset, @offset + @len) still belongs to the head.
+ * @buf is NULL for a hole. Returns how much was taken.
+ */
+static ssize_t compact_head_take(struct compact_ctx *ctx, const void *buf,
+				 __u64 offset, __u64 len)
+{
+	__u64 chunk;
+
+	if (!len || (ctx->data_offset && offset >= ctx->data_offset))
+		return 0;
+
+	chunk = len;
+	if (ctx->data_offset && offset + chunk > ctx->data_offset)
+		chunk = ctx->data_offset - offset;
+
+	if (offset != ctx->head_len) {
+		fprintf(stderr, "%s: head has a gap at %llu\n", __func__,
+			(unsigned long long)offset);
+		return -1;
+	}
+
+	if (compact_head_append(ctx, buf, chunk))
+		return -1;
+
+	return chunk;
+}
+
+static int compact_data(void *arg, const void *buf, size_t len, __u64 offset)
+{
+	struct compact_ctx *ctx = arg;
+	const unsigned char *pos = buf;
+	ssize_t head;
+
+	/* Only the test needs a coredump with the holes still in it. */
+	if (pwrite(ctx->fd_reference, pos, len, offset) != (ssize_t)len) {
+		fprintf(stderr, "%s: pwrite failed: %m\n", __func__);
+		return -1;
+	}
+
+	/* The head has to be rewritten at the end, so hold on to it. */
+	head = compact_head_take(ctx, pos, offset, len);
+	if (head < 0)
+		return -1;
+	if (head && compact_probe(ctx))
+		return -1;
+
+	pos += head;
+	len -= head;
+	if (!len)
+		return 0;
+
+	/* Everything else goes into the object as it arrives. */
+	if (compact_write(ctx->fd_body, pos, len))
+		return -1;
+	ctx->body_len += len;
+
+	return 0;
+}
+
+static int compact_zero(void *arg, __u64 offset, __u64 len)
+{
+	struct compact_ctx *ctx = arg;
+	ssize_t head;
+
+	/* A hole in the head is alignment padding. Write it out. */
+	head = compact_head_take(ctx, NULL, offset, len);
+	if (head < 0)
+		return -1;
+
+	offset += head;
+	len -= head;
+	if (!len)
+		return 0;
+
+	/* This is what the object doesn't have to carry. */
+	return compact_keep_hole(ctx, offset, len);
+}
+
+/* Where @offset ends up in the object once the holes ahead of it are gone. */
+static __u64 compact_offset(const struct compact_ctx *ctx, __u64 body_start,
+			    __u64 offset)
+{
+	__u64 elided = 0;
+	size_t i;
+
+	for (i = 0; i < ctx->nr_holes; i++) {
+		__u64 len = ctx->holes[i].len;
+
+		if (ctx->holes[i].offset >= offset)
+			break;
+		if (ctx->holes[i].offset + len > offset)
+			len = offset - ctx->holes[i].offset;
+		elided += len;
+	}
+
+	return body_start + (offset - ctx->data_offset) - elided;
+}
+
+/* A run of segment data that made it into the object. */
+static void compact_add_data(struct compact_piece *pieces, size_t *nr,
+			     const ElfW(Phdr) *phdr, __u64 start, __u64 end)
+{
+	struct compact_piece *piece = &pieces[(*nr)++];
+
+	piece->phdr = *phdr;
+	piece->phdr.p_vaddr = phdr->p_vaddr + (start - phdr->p_offset);
+	piece->phdr.p_paddr = 0;
+	piece->phdr.p_filesz = end - start;
+	piece->phdr.p_memsz = end - start;
+	piece->src = start;
+}
+
+/*
+ * A run of @len bytes the object doesn't carry. It grows the piece in
+ * front of it if this segment already has one, because everything a
+ * segment covers past p_filesz is zeroes anyway.
+ */
+static void compact_add_zero(struct compact_piece *pieces, size_t *nr,
+			     size_t first, const ElfW(Phdr) *phdr, __u64 vaddr,
+			     __u64 len)
+{
+	struct compact_piece *piece;
+
+	if (*nr > first) {
+		pieces[*nr - 1].phdr.p_memsz += len;
+		return;
+	}
+
+	piece = &pieces[(*nr)++];
+	piece->phdr = *phdr;
+	piece->phdr.p_vaddr = vaddr;
+	piece->phdr.p_paddr = 0;
+	piece->phdr.p_filesz = 0;
+	piece->phdr.p_memsz = len;
+	piece->src = 0;
+}
+
+/* Split the segments at the holes and write out what the object became. */
+static int compact_build(struct compact_ctx *ctx, int fd_object)
+{
+	__u64 note_offset = 0, note_len = 0, note_new;
+	__u64 align = 0, head_len, body_start, pos;
+	size_t nr_old, nr_new = 0, note_piece = 0, i;
+	struct compact_piece *pieces;
+	char buffer[PAGE_SIZE];
+	const ElfW(Phdr) *old;
+	ElfW(Ehdr) ehdr;
+	int ret = -1;
+
+	if (!ctx->data_offset) {
+		fprintf(stderr, "%s: coredump without segment data\n", __func__);
+		return -1;
+	}
+
+	memcpy(&ehdr, ctx->head, sizeof(ehdr));
+	if (ehdr.e_shoff) {
+		fprintf(stderr, "%s: section headers are not handled\n",
+			__func__);
+		return -1;
+	}
+
+	old = (const ElfW(Phdr) *)(ctx->head + ehdr.e_phoff);
+	nr_old = ehdr.e_phnum;
+
+	pieces = calloc(nr_old + 2 * ctx->nr_holes + 1, sizeof(*pieces));
+	if (!pieces) {
+		fprintf(stderr, "%s: out of memory\n", __func__);
+		return -1;
+	}
+
+	for (i = 0; i < nr_old; i++) {
+		ElfW(Phdr) phdr = old[i];
+		__u64 end = phdr.p_offset + phdr.p_filesz;
+		__u64 cur = phdr.p_offset;
+		size_t first = nr_new, h;
+
+		/* The notes move because the table in front of them grows. */
+		if (phdr.p_type == PT_NOTE) {
+			if (note_len) {
+				fprintf(stderr, "%s: more than one note segment\n",
+					__func__);
+				goto out;
+			}
+			note_offset = phdr.p_offset;
+			note_len = phdr.p_filesz;
+			note_piece = nr_new;
+			pieces[nr_new].phdr = phdr;
+			pieces[nr_new++].src = 0;
+			continue;
+		}
+
+		if (phdr.p_type != PT_LOAD) {
+			if (phdr.p_filesz && phdr.p_offset < ctx->data_offset) {
+				fprintf(stderr, "%s: segment %zu is in the head\n",
+					__func__, i);
+				goto out;
+			}
+			pieces[nr_new].phdr = phdr;
+			pieces[nr_new++].src = phdr.p_offset;
+			continue;
+		}
+
+		if (!align)
+			align = phdr.p_align;
+
+		for (h = 0; h < ctx->nr_holes && cur < end; h++) {
+			__u64 start = ctx->holes[h].offset;
+			__u64 stop = start + ctx->holes[h].len;
+
+			if (stop <= cur)
+				continue;
+			if (start >= end)
+				break;
+
+			/* A hole can span more than this one segment. */
+			if (start < cur)
+				start = cur;
+			if (stop > end)
+				stop = end;
+
+			if (start > cur) {
+				compact_add_data(pieces, &nr_new, &phdr, cur,
+						 start);
+				cur = start;
+			}
+			compact_add_zero(pieces, &nr_new, first, &phdr,
+					 phdr.p_vaddr + (cur - phdr.p_offset),
+					 stop - cur);
+			cur = stop;
+		}
+
+		if (cur < end)
+			compact_add_data(pieces, &nr_new, &phdr, cur, end);
+
+		/* Whatever the kernel didn't dump of this mapping. */
+		if (phdr.p_memsz > phdr.p_filesz)
+			compact_add_zero(pieces, &nr_new, first, &phdr,
+					 phdr.p_vaddr + phdr.p_filesz,
+					 phdr.p_memsz - phdr.p_filesz);
+	}
+
+	if (!note_len || note_offset + note_len > ctx->head_len) {
+		fprintf(stderr, "%s: notes aren't where they should be\n",
+			__func__);
+		goto out;
+	}
+
+	if (nr_new >= PN_XNUM) {
+		fprintf(stderr, "%s: %zu program headers don't fit\n", __func__,
+			nr_new);
+		goto out;
+	}
+
+	if (!align || (align & (align - 1)))
+		align = sysconf(_SC_PAGESIZE);
+
+	note_new = sizeof(ehdr) + (__u64)nr_new * sizeof(ElfW(Phdr));
+	head_len = note_new + note_len;
+	body_start = (head_len + align - 1) & ~(align - 1);
+
+	for (i = 0; i < nr_new; i++) {
+		struct compact_piece *piece = &pieces[i];
+
+		if (i == note_piece)
+			piece->phdr.p_offset = note_new;
+		else if (piece->phdr.p_filesz)
+			piece->phdr.p_offset = compact_offset(ctx, body_start,
+							      piece->src);
+		else
+			piece->phdr.p_offset = 0;
+	}
+
+	/* Only now is the head known. That's why it is uploaded last. */
+	ehdr.e_phnum = nr_new;
+	if (compact_write(fd_object, &ehdr, sizeof(ehdr)))
+		goto out;
+
+	for (i = 0; i < nr_new; i++)
+		if (compact_write(fd_object, &pieces[i].phdr,
+				  sizeof(pieces[i].phdr)))
+			goto out;
+
+	if (compact_write(fd_object, ctx->head + note_offset, note_len))
+		goto out;
+
+	/* Keep the segments aligned the way a debugger expects them. */
+	memset(buffer, 0, sizeof(buffer));
+	for (pos = head_len; pos < body_start; ) {
+		__u64 chunk = body_start - pos;
+
+		if (chunk > sizeof(buffer))
+			chunk = sizeof(buffer);
+		if (compact_write(fd_object, buffer, chunk))
+			goto out;
+		pos += chunk;
+	}
+
+	/* Putting the parts together is the blob store's job. Do it here. */
+	for (pos = 0; pos < ctx->body_len; ) {
+		ssize_t chunk = pread(ctx->fd_body, buffer, sizeof(buffer), pos);
+
+		if (chunk <= 0) {
+			fprintf(stderr, "%s: short read %zd: %m\n", __func__,
+				chunk);
+			goto out;
+		}
+		if (compact_write(fd_object, buffer, chunk))
+			goto out;
+		pos += chunk;
+	}
+
+	fprintf(stderr, "Object is %llu bytes in %zu program headers, %zu holes left out\n",
+		(unsigned long long)(body_start + ctx->body_len), nr_new,
+		ctx->nr_holes);
+	ret = 0;
+out:
+	free(pieces);
+	return ret;
+}
+
+/*
+ * Reassemble a record stream into an ELF core file that has no holes in
+ * it, the way a coredump server that uploads to a blob store has to. If
+ * @fd_reference is valid it gets the coredump the records describe,
+ * holes and all, so the test can compare the two.
+ */
+ssize_t recv_coredump_compact(int fd_coredump, int fd_object, int fd_reference,
+			      off_t *coredump_size)
+{
+	struct compact_ctx ctx = {
+		.fd_body	= -1,
+		.fd_reference	= fd_reference,
+	};
+	struct coredump_record_sink sink = {
+		.data	= compact_data,
+		.zero	= compact_zero,
+		.ctx	= &ctx,
+	};
+	ssize_t received;
+	off_t size = 0;
+	FILE *body;
+
+	body = tmpfile();
+	if (!body) {
+		fprintf(stderr, "%s: tmpfile failed: %m\n", __func__);
+		return -1;
+	}
+	ctx.fd_body = fileno(body);
+
+	/* An upload is appended to. Make sure nothing here can seek. */
+	if (fcntl(ctx.fd_body, F_SETFL, O_APPEND)) {
+		fprintf(stderr, "%s: F_SETFL failed: %m\n", __func__);
+		received = -1;
+		goto out;
+	}
+
+	received = __recv_coredump_records(fd_coredump, &sink, &size, NULL, -1);
+	if (received < 0)
+		goto out;
+
+	/*
+	 * Nothing is written for a hole, so grow the reference to the size
+	 * the records describe in case the coredump ended in one.
+	 */
+	if (ftruncate(fd_reference, size) < 0) {
+		fprintf(stderr, "%s: ftruncate to %llu failed: %m\n",
+			__func__, (unsigned long long)size);
+		received = -1;
+		goto out;
+	}
+
+	if (compact_build(&ctx, fd_object)) {
+		received = -1;
+		goto out;
+	}
+
+	if (coredump_size)
+		*coredump_size = size;
+out:
+	fclose(body);
+	free(ctx.head);
+	free(ctx.holes);
+	return received;
+}
+
+/* Read the ELF header and the program header table of @fd. */
+static ElfW(Phdr) *read_phdrs(int fd, size_t *nr)
+{
+	ElfW(Ehdr) ehdr;
+	ElfW(Phdr) *phdr;
+	size_t size;
+
+	if (pread(fd, &ehdr, sizeof(ehdr), 0) != sizeof(ehdr)) {
+		fprintf(stderr, "%s: no ELF header: %m\n", __func__);
+		return NULL;
+	}
+
+	if (!is_core_ehdr(&ehdr) || !ehdr.e_phnum ||
+	    ehdr.e_phentsize != sizeof(*phdr)) {
+		fprintf(stderr, "%s: not an ELF core file\n", __func__);
+		return NULL;
+	}
+
+	size = (size_t)ehdr.e_phnum * ehdr.e_phentsize;
+	phdr = malloc(size);
+	if (!phdr) {
+		fprintf(stderr, "%s: out of memory\n", __func__);
+		return NULL;
+	}
+
+	if (pread(fd, phdr, size, ehdr.e_phoff) != (ssize_t)size) {
+		fprintf(stderr, "%s: short program header table: %m\n", __func__);
+		free(phdr);
+		return NULL;
+	}
+
+	*nr = ehdr.e_phnum;
+	return phdr;
+}
+
+/* The segment @vaddr falls into. */
+static const ElfW(Phdr) *find_segment(const ElfW(Phdr) *phdr, size_t nr,
+				      __u64 vaddr)
+{
+	size_t i;
+
+	for (i = 0; i < nr; i++) {
+		if (phdr[i].p_type != PT_LOAD)
+			continue;
+		if (vaddr >= phdr[i].p_vaddr &&
+		    vaddr < phdr[i].p_vaddr + phdr[i].p_memsz)
+			return &phdr[i];
+	}
+
+	return NULL;
+}
+
+/* The next stretch of memory the segments cover, split ones merged back. */
+static bool next_range(const ElfW(Phdr) *phdr, size_t nr, size_t *i,
+		       __u64 *start, __u64 *end)
+{
+	while (*i < nr && phdr[*i].p_type != PT_LOAD)
+		(*i)++;
+
+	if (*i >= nr)
+		return false;
+
+	*start = phdr[*i].p_vaddr;
+	*end = phdr[*i].p_vaddr + phdr[*i].p_memsz;
+	(*i)++;
+
+	while (*i < nr) {
+		if (phdr[*i].p_type != PT_LOAD) {
+			(*i)++;
+			continue;
+		}
+		if (phdr[*i].p_vaddr != *end)
+			break;
+		*end = phdr[*i].p_vaddr + phdr[*i].p_memsz;
+		(*i)++;
+	}
+
+	return true;
+}
+
+/* Compare @len bytes at @offset against @len bytes at @offset_ref. */
+static int compare_range(int fd, __u64 offset, int fd_ref, __u64 offset_ref,
+			 __u64 len)
+{
+	char buffer[PAGE_SIZE], buffer_ref[PAGE_SIZE];
+
+	while (len) {
+		size_t chunk = len < sizeof(buffer) ? len : sizeof(buffer);
+
+		if (pread(fd, buffer, chunk, offset) != (ssize_t)chunk ||
+		    pread(fd_ref, buffer_ref, chunk, offset_ref) != (ssize_t)chunk) {
+			fprintf(stderr, "%s: short read at %llu: %m\n",
+				__func__, (unsigned long long)offset);
+			return -1;
+		}
+
+		if (memcmp(buffer, buffer_ref, chunk)) {
+			fprintf(stderr, "%s: %llu differs from %llu\n", __func__,
+				(unsigned long long)offset,
+				(unsigned long long)offset_ref);
+			return -1;
+		}
+
+		offset += chunk;
+		offset_ref += chunk;
+		len -= chunk;
+	}
+
+	return 0;
+}
+
+/* The @len bytes at @offset the object left out have to have been zeroes. */
+static int check_zero_range(int fd, __u64 offset, __u64 len)
+{
+	static const char zeroes[PAGE_SIZE];
+	char buffer[PAGE_SIZE];
+
+	while (len) {
+		size_t chunk = len < sizeof(buffer) ? len : sizeof(buffer);
+
+		if (pread(fd, buffer, chunk, offset) != (ssize_t)chunk) {
+			fprintf(stderr, "%s: short read at %llu: %m\n",
+				__func__, (unsigned long long)offset);
+			return -1;
+		}
+
+		if (memcmp(buffer, zeroes, chunk)) {
+			fprintf(stderr, "%s: %llu isn't a hole\n", __func__,
+				(unsigned long long)offset);
+			return -1;
+		}
+
+		offset += chunk;
+		len -= chunk;
+	}
+
+	return 0;
+}
+
+/*
+ * The object has to describe the same memory as the coredump it was built
+ * from, and it has to describe it correctly.
+ */
+int check_compact_coredump(int fd_object, int fd_reference)
+{
+	ElfW(Phdr) *object = NULL, *reference = NULL;
+	size_t nr_object, nr_reference, i;
+	size_t io = 0, ir = 0;
+	int ret = -1;
+
+	object = read_phdrs(fd_object, &nr_object);
+	reference = read_phdrs(fd_reference, &nr_reference);
+	if (!object || !reference)
+		goto out;
+
+	/* Nothing may have been dropped and nothing may have been added. */
+	for (;;) {
+		__u64 start = 0, end = 0, start_ref = 0, end_ref = 0;
+		bool has, has_ref;
+
+		has = next_range(object, nr_object, &io, &start, &end);
+		has_ref = next_range(reference, nr_reference, &ir, &start_ref,
+				     &end_ref);
+		if (!has && !has_ref)
+			break;
+
+		if (has != has_ref || start != start_ref || end != end_ref) {
+			fprintf(stderr, "%s: object covers 0x%llx-0x%llx, coredump 0x%llx-0x%llx\n",
+				__func__, (unsigned long long)start,
+				(unsigned long long)end,
+				(unsigned long long)start_ref,
+				(unsigned long long)end_ref);
+			goto out;
+		}
+	}
+
+	for (i = 0; i < nr_object; i++) {
+		const ElfW(Phdr) *segment;
+		__u64 offset, dumped;
+
+		if (object[i].p_type != PT_LOAD || !object[i].p_memsz)
+			continue;
+
+		segment = find_segment(reference, nr_reference,
+				       object[i].p_vaddr);
+		if (!segment) {
+			fprintf(stderr, "%s: 0x%llx isn't in the coredump\n",
+				__func__,
+				(unsigned long long)object[i].p_vaddr);
+			goto out;
+		}
+
+		offset = object[i].p_vaddr - segment->p_vaddr;
+		dumped = offset < segment->p_filesz ?
+				 segment->p_filesz - offset : 0;
+
+		/* What the object carries is what the coredump had. */
+		if (object[i].p_filesz > dumped) {
+			fprintf(stderr, "%s: object carries %llu bytes the coredump doesn't have\n",
+				__func__,
+				(unsigned long long)(object[i].p_filesz - dumped));
+			goto out;
+		}
+
+		if (compare_range(fd_object, object[i].p_offset, fd_reference,
+				  segment->p_offset + offset,
+				  object[i].p_filesz))
+			goto out;
+
+		/* And what it left out was a hole. */
+		if (object[i].p_memsz > object[i].p_filesz &&
+		    dumped > object[i].p_filesz) {
+			__u64 left_out = dumped - object[i].p_filesz;
+
+			if (left_out > object[i].p_memsz - object[i].p_filesz)
+				left_out = object[i].p_memsz - object[i].p_filesz;
+
+			if (check_zero_range(fd_reference,
+					     segment->p_offset + offset +
+					     object[i].p_filesz, left_out))
+				goto out;
+		}
+	}
+
+	ret = 0;
+out:
+	free(object);
+	free(reference);
+	return ret;
+}
+
 int create_detached_tmpfs(void)
 {
 	int fd_context, fd_tmpfs;
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
index fe0a88a71b05..00d695b67b3f 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.h
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
@@ -26,6 +26,9 @@ ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
 			      off_t *coredump_size, bool *truncated,
 			      int fd_peer_pidfd);
 bool is_elf_core(int fd);
+ssize_t recv_coredump_compact(int fd_coredump, int fd_object, int fd_reference,
+			      off_t *coredump_size);
+int check_compact_coredump(int fd_object, int fd_reference);
 int create_detached_tmpfs(void);
 int create_and_listen_unix_socket(const char *path);
 bool set_core_pattern(const char *pattern);

-- 
2.53.0


