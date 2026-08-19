Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1648C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 23:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4CC6B00C2; Wed, 19 Aug 2026 19:12:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECF8B6B00C3; Wed, 19 Aug 2026 19:12:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE2196B00C4; Wed, 19 Aug 2026 19:12:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF0296B00C2
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 19:12:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B8258049B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:12:04 +0000 (UTC)
X-FDA: 85119568968.17.F8D448B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 809CD2000D
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 23:12:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0iKfg6K;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787181122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w4AvipAumrUj6tt8+b68TknDL7kakICVCGPDUl5T7kI=;
	b=kpaJQoUFLOcYV8RArfuqD7SPiKpahBM1/fE+GuhptiI9hzVsdz340uGeh8MPLzBaAP1IP3
	6QphnRlhRADMMB1uYjy1jJgT/m5ojvgwJTVoe9tdr1lLtoKe+irqWKHSgevR15M6eurgDT
	rXxDP/G0lgDlDx1RCPfWjnBOkJDN+cY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787181122;
	b=GR1UXJ2OGmsMQVqwlBkrJdiWO8wYw11PRHz1Pn3PZHRCgIg+CP30/KRg/RWTcVindMDzd/
	xl0ziMxksM24oCtU0ybbe5pg//3xz/PHwx42g05NZYd6a+lJPddyMCu9RiUzNu1RqlK2aU
	Zhjuj9NDXiAWQFtePxyilLEgHUpIzTk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0iKfg6K;
	spf=pass (imf13.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA17E40876;
	Wed, 19 Aug 2026 23:12:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6DB71F00A3A;
	Wed, 19 Aug 2026 23:11:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787181121;
	bh=w4AvipAumrUj6tt8+b68TknDL7kakICVCGPDUl5T7kI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M0iKfg6K7/fZrJ2RzgV1D5gxg51lTem8oVA4Z4JFFPP9IEAXff8sYu/KFIVxpI6zZ
	 TCV4EZputenm31sJqi7KB5oBGqaxirqg+6KJse21ypDt3a/Z7Oay+ASQJwo6GgViI9
	 LFzd4IzQ4p3s/GGYraJABL4CgB8rX3Sp2dhF16f9FbTULCED5dbYgFQUGh5QajkRj+
	 LOudzXiBBa2f8O0aCk3XGDuBEZrrqJiY6TV08wBttnbNiqhIsIyaYdtiEPFw0HeSxO
	 hzbUOoGtLAiA2s9CYpVCjCpSnng68PFOqBEeAXjkOKivfuyBLAFEpos2goe6M7GNVf
	 JfZnpMVB2PwNw==
From: Christian Brauner <brauner@kernel.org>
Date: Thu, 20 Aug 2026 01:09:39 +0200
Subject: [PATCH v2 22/22] selftests/coredump: show how to inspect the task
 to decide how the coredump should be sent
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260820-work-coredump-sparse-v2-22-ba32dd718c51@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10058; i=brauner@kernel.org;
 h=from:subject:message-id; bh=cXNV3PX4efu0YjQqQgjmqr8KTIFSZPBeMO3+YmoGrgY=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS1me8XZN58bv3up5t2NjtPtBVL8Try5xZvv+/3VOnti
 jzsZg6XOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbiJcnI8MLvUugpTYZHxas+
 iFRKHVPw/Ni8k1FcchK/7HkVlhCjvwz/lJdN6F9+MT5spYsTl3WCxeoHXCZeXxtSaryc7ndXvGX
 iAAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: jk1b3i9cbfzobo9nhjko9gx5dki3ckx9
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 809CD2000D
X-HE-Tag: 1787181122-686238
X-HE-Meta: U2FsdGVkX1+kgYvZK1OBKS0+V4g/tPcMeKaXbZNs4wsyr28MboN+st7UXanRTrbzdnfIIWcbqT2LctDC9hURkI3xftKibLZwrSsg1X78+7eGsAZKAKy7Qpq2/bor/3sEqyhlibdAH9ZFbIMNseHHopnJZ7h8fx9jeXrgEj9re5w77R/O09ucZ40toROzAXOtYXAhLNuK74DcwGajg6A5DCFQfOzpe9MJUNuY/Uf/8k1xFCn1czTKU0L34eGiVBynFnuaoC4sfq1MTpwkMKeomDdluZ6n4pqadtL9yx3VTJPX6OobmO3IyBwVS+IPR6m5fu9c/ayJmKyRFihGPMHx+zBH6na17B9mPOrvD32R9Z52Iesj13apyByLV+jh884CpXHF7SOBmUAVzHCoV/K+xykRmHTS6+ge+p/5cGNZwRbQYDmqS58hMCBGa5LKpwElblY/WA5gTve8XBUvAhI0S3xYgWHQW/Q8Mbt8OxyBlh23P1YpiAEW7saa4MlPE0+QtljxlBdQRcQacsx95bPMnraK6pLOcl3KyCSi3iW8h5SQ4c0dGJizvKWyzcVP/c8tuqS93YGNdnt+VNkdICVDFTu2N5f0x/P8vcstGftkakuJ9b2ZQ+GXJtr6YknzeFSRD+ABaHozisX0zjByaPKkxGy0Tav0haVVapJOFBL818mgbP7D3Qu4/sFTYKeWCBh8U2kIaPLWtnRrEnV//hbUp+LlkHnfoQCs8lR72OVQ+Ao0Joye/qTH2h0iRa6V9Kb4YWToE/bZM2dIl7x1P082q7WNTUfrSGDLJuymYGhR57A7Q0E08Z1MftVDsU5UauxmXzZ8xyGqovqa0deHaxbysW8d97LXbOLhx7/AJ6sQb4rcbnIM/nuH2l0yxfhLd+6mRjzVycOTiNSZRm8HGiZbLX0ZzN0VhGgKfP6q5UXqycxmEB7k+5XprOFX0ZytGyV/wezuQmIluRzTNIP9MuO
 58axTpqe
 GRnOeX6MIaVfktPIyWvOB9u97kU7rktsl/PCdBvxfpdlf9v16T7xQ+WNkTbC3KbZ458Ctk5os7yhcHj1yllxLTgcuxyI8ZQW8EawLklqTHBk7lVq53k9708qzs9x4gshsMXUqHIwThJFk7RzdrmZvtzDmEiniZbCJI/bko5ghNKSnUS6d5c2d3CnqF358F8egPhO9kEdUJh2dESeAZW9l82oezkKsjFd4yGa/+qD9W64f2zo1CI1L/Adwl+DogbU4anXURMQ4vF71bzwmoN9DEEe6Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kernel blocks in the coredump req until the coredump ack is sent by
the coredump server. This allows the coredump server to decide how the
kernel is supposed to send the coredump.

Let's show how that can work:

- a task that has a large memory mapping gets sent as a sparse record
  stream

- a task with a trivial memory mapping gets sent as a plain byte stream

Since the threads are parked in coredump_task_exit() with their mm
around we can look at /proc/<pid>/statm to figure out what the task has
mapped.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 184 +++++++++++++++++++++
 .../selftests/coredump/coredump_test_helpers.c     |  58 +++++++
 .../selftests/coredump/coredump_test_helpers.h     |   7 +-
 3 files changed, 248 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index f33eaf2fa93d..daff908232a2 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -2136,4 +2136,188 @@ TEST_F(coredump, socket_request_sparse_without_records)
 	check_conflicting_ack(_metadata, self, COREDUMP_KERNEL | COREDUMP_SPARSE);
 }
 
+/* What the server reports back about the coredump it decided to take. */
+struct stream_choice {
+	bool sparse;
+	ssize_t received;
+	off_t size;
+	ssize_t vm_size;
+};
+
+/*
+ * The kernel blocks in the coredump request until the ack arrives, so a
+ * coredump server gets to look at the task before it commits to a
+ * stream. Take the record stream only for a task whose mappings are
+ * worth it and the plain byte stream for everything else.
+ */
+static void check_stream_choice(struct __test_metadata *const _metadata,
+				FIXTURE_DATA(coredump) *self, bool big,
+				struct stream_choice *choice)
+{
+	int pidfd, status;
+	pid_t pid, pid_coredump_server;
+	struct pidfd_info info = {};
+	int ipc_sockets[2];
+	int pipefds[2];
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
+		int fd_file = -1;
+		int exit_code = EXIT_FAILURE;
+		struct coredump_req req = {};
+		struct stream_choice got = {};
+		__u64 mask;
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
+		/*
+		 * The reassembled coredump is bigger than the mapping the
+		 * child made, so keep it on the detached tmpfs and sparse.
+		 */
+		fd_file = open_coredump_tmpfile(self->fd_tmpfs_detached);
+		if (fd_file < 0)
+			goto out;
+
+		if (!read_coredump_req(fd_coredump, &req))
+			goto out;
+
+		if (!check_coredump_req(&req))
+			goto out;
+
+		/*
+		 * Nothing is on the wire yet and the kernel is waiting for
+		 * the ack, so there is all the time in the world to look at
+		 * the task and decide what to ask it for.
+		 */
+		got.vm_size = peer_vm_size(fd_peer_pidfd);
+		if (got.vm_size < 0)
+			goto out;
+		got.sparse = got.vm_size >= SPARSE_STREAM_THRESHOLD;
+
+		fprintf(stderr, "Peer maps %zd bytes, asking for %s\n",
+			got.vm_size,
+			got.sparse ? "a sparse record stream" : "a byte stream");
+
+		mask = COREDUMP_KERNEL | COREDUMP_WAIT;
+		if (got.sparse)
+			mask |= COREDUMP_RECORDS | COREDUMP_SPARSE;
+
+		if (!send_coredump_ack(fd_coredump, &req, mask, 0))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
+			goto out;
+
+		if (got.sparse) {
+			got.received = recv_coredump_records(fd_coredump, fd_file,
+							     &got.size, NULL, -1);
+		} else {
+			got.received = recv_coredump_bytes(fd_coredump, fd_file);
+			got.size = got.received;
+		}
+		if (got.received < 0)
+			goto out;
+
+		/* Either way a debugger has to see an ordinary core file. */
+		if (!is_elf_core(fd_file))
+			goto out;
+
+		if (write_nointr(pipefds[1], &got, sizeof(got)) != sizeof(got))
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
+		close(pipefds[1]);
+		if (fd_file >= 0)
+			close(fd_file);
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
+		crashing_child_sparse(big ? SPARSE_MAPPING_SIZE : PAGE_SIZE);
+
+	pidfd = sys_pidfd_open(pid, 0);
+	ASSERT_GE(pidfd, 0);
+
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_TRUE(WCOREDUMP(status));
+
+	ASSERT_EQ(read_nointr(pipefds[0], choice, sizeof(*choice)),
+		  sizeof(*choice));
+	EXPECT_EQ(close(pipefds[0]), 0);
+
+	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
+	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
+	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+}
+
+/* A task with little mapped isn't worth a record stream. */
+TEST_F(coredump, socket_request_stream_choice_small)
+{
+	struct stream_choice choice = {};
+
+	check_stream_choice(_metadata, self, false, &choice);
+
+	ASSERT_LT(choice.vm_size, (ssize_t)SPARSE_STREAM_THRESHOLD);
+	ASSERT_FALSE(choice.sparse);
+	ASSERT_GT(choice.received, 0);
+}
+
+/* A task sitting on a big mapping is. */
+TEST_F(coredump, socket_request_stream_choice_large)
+{
+	struct stream_choice choice = {};
+
+	check_stream_choice(_metadata, self, true, &choice);
+
+	ASSERT_GE(choice.vm_size, (ssize_t)SPARSE_STREAM_THRESHOLD);
+	ASSERT_TRUE(choice.sparse);
+	ASSERT_GT(choice.size, (off_t)SPARSE_MAPPING_SIZE);
+
+	/* The holes didn't have to go over the socket. */
+	ASSERT_LT(choice.received, choice.size / 8);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 9346b8f688e2..d7cc448eeaf4 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -1095,6 +1095,33 @@ int check_compact_coredump(int fd_object, int fd_reference)
 	return ret;
 }
 
+/* Read a plain coredump byte stream to end-of-file. */
+ssize_t recv_coredump_bytes(int fd_coredump, int fd_core_file)
+{
+	ssize_t received = 0;
+
+	for (;;) {
+		char buffer[PAGE_SIZE];
+		ssize_t ret = read_nointr(fd_coredump, buffer, sizeof(buffer));
+
+		if (ret < 0) {
+			fprintf(stderr, "%s: read failed: %m\n", __func__);
+			return -1;
+		}
+		if (ret == 0)
+			break;
+
+		if (write_nointr(fd_core_file, buffer, ret) != ret) {
+			fprintf(stderr, "%s: write failed: %m\n", __func__);
+			return -1;
+		}
+		received += ret;
+	}
+
+	fprintf(stderr, "Received %zd bytes of coredump\n", received);
+	return received;
+}
+
 int create_detached_tmpfs(void)
 {
 	int fd_context, fd_tmpfs;
@@ -1190,6 +1217,37 @@ bool get_pidfd_info(int fd_peer_pidfd, struct pidfd_info *info)
 	return true;
 }
 
+/*
+ * How much the peer has mapped. The task is parked in the coredump
+ * handshake, so its mm is still there to be looked at.
+ */
+ssize_t peer_vm_size(int fd_peer_pidfd)
+{
+	struct pidfd_info info = {};
+	unsigned long pages;
+	char path[64];
+	FILE *f;
+
+	if (!get_pidfd_info(fd_peer_pidfd, &info))
+		return -1;
+
+	snprintf(path, sizeof(path), "/proc/%d/statm", info.pid);
+	f = fopen(path, "r");
+	if (!f) {
+		fprintf(stderr, "%s: %s: %m\n", __func__, path);
+		return -1;
+	}
+
+	if (fscanf(f, "%lu", &pages) != 1) {
+		fprintf(stderr, "%s: %s: no size\n", __func__, path);
+		fclose(f);
+		return -1;
+	}
+	fclose(f);
+
+	return (ssize_t)pages * sysconf(_SC_PAGESIZE);
+}
+
 /* Protocol helper functions */
 
 ssize_t recv_marker(int fd)
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
index 00d695b67b3f..97ad5cfeae92 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.h
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
@@ -18,6 +18,9 @@
 /* Size of the mostly unpopulated mapping the sparse coredump test maps. */
 #define SPARSE_MAPPING_SIZE (256 * 1024 * 1024)
 
+/* A task mapping at least this much is worth a record stream. */
+#define SPARSE_STREAM_THRESHOLD (SPARSE_MAPPING_SIZE / 2)
+
 /* Shared helper function declarations */
 void *do_nothing(void *arg);
 void crashing_child(void);
@@ -25,9 +28,11 @@ void crashing_child_sparse(size_t size);
 ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
 			      off_t *coredump_size, bool *truncated,
 			      int fd_peer_pidfd);
-bool is_elf_core(int fd);
 ssize_t recv_coredump_compact(int fd_coredump, int fd_object, int fd_reference,
 			      off_t *coredump_size);
+ssize_t recv_coredump_bytes(int fd_coredump, int fd_core_file);
+ssize_t peer_vm_size(int fd_peer_pidfd);
+bool is_elf_core(int fd);
 int check_compact_coredump(int fd_object, int fd_reference);
 int create_detached_tmpfs(void);
 int create_and_listen_unix_socket(const char *path);

-- 
2.53.0


