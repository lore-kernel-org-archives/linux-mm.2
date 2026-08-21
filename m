Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30B5EC5DF8E
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59416B00A2; Fri, 21 Aug 2026 07:52:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0A046B00A3; Fri, 21 Aug 2026 07:52:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAA956B00A4; Fri, 21 Aug 2026 07:52:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 93C296B00A2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:52:47 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F17C4C041C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:46 +0000 (UTC)
X-FDA: 85125114732.04.37BCD1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3DBFE2000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVCaMbB7;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787313165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXWvtvXGxO35Vl+XPRwRngoM6ZHn7SszfzwfWqJDWm8=;
	b=tqnhgLmkpPZCpyvGWgDMWPgEZZ/nvivRKTlyeXGXLmQYsNjXZM4TvlntHf3RS8FdvzzXSD
	zLUIakl8kB1B3vpVFZrc/I38EwJ8vZyEeDl725pHYoDK8KuoovHAsecJgeANm8jA6AIXUg
	/jAIZEeN+yk748ks5yCK1B7x1a4tjcs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787313165;
	b=GoAESWF2HXuPZUdOjvz+MzC2NGM0a6n6e7vJyrhAF+ySvvUG/GUgBSae+8Im1grX/ys1B1
	MP/idTzWkDk71xpwwZ5BTF+yyuaHh2yBGLGraPpWUN4cQYWKLQAKb6DIwz+QVtiUnjYgN/
	159gc+Of/PgomGI0+9ft6V2O5U0/l/Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVCaMbB7;
	spf=pass (imf03.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C24CE60A69;
	Fri, 21 Aug 2026 11:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1BC1F000E9;
	Fri, 21 Aug 2026 11:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313163;
	bh=IXWvtvXGxO35Vl+XPRwRngoM6ZHn7SszfzwfWqJDWm8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mVCaMbB7CE2NzEOGSYdqSB3igKF9RdTYZJ3eQJIlJjye2JsJaekvX2ONxsBQLd5+E
	 sbRUiHheOmnT8c+egfz4PZZtibnPWXX2blx580W6acwF9JFk0jjFlmnRxn86R4+8p7
	 dtPDPXthM7ltDun1fVLZbeHkUF2hhUIQ6Vt+SrI9T0dkcVFH3RnFGBQ+imUde3O3g6
	 HHUBG6gYlZgXIx7POCvVQqa0b49ZcWyWU7vyRu+NvdNT80ZrHVouC9nL1pLhMJz37I
	 LjhKRmlzCjoDwkHYVTU2wHNrbFar2Prytfd0mZ1shro2Xyhg3o2j+XZ7yVTf51IP3g
	 YNOyXr5BkicZQ==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 21 Aug 2026 13:52:05 +0200
Subject: [PATCH 4/6] selftests/coredump: test COREDUMP_MEMORY_TYPES
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-work-coredump-filter-v1-4-91f9a73ef03e@kernel.org>
References: <20260821-work-coredump-filter-v1-0-91f9a73ef03e@kernel.org>
In-Reply-To: <20260821-work-coredump-filter-v1-0-91f9a73ef03e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=21458; i=brauner@kernel.org;
 h=from:subject:message-id; bh=fYr0VtUEwUQZyccXtSK8IkCIjeBFvShqL35/3wejwiI=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR1WH9kYRXJ9dlnnb6Xac+1+0Gh+1j42x/NmfnX91HQF
 qu24KmnOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYyYxojwyzXtVMCG/ZPfp15
 NCmIp/VYpHnVq4sLjMq3bXv97qXj7imMDCv/BZzWjmdXVVWYfefW1l0nN+eEx032vd07/ffT3on
 avVwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Stat-Signature: i15mnpkf1rhmu7pbggrqam8bieyo7s7u
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3DBFE2000A
X-HE-Tag: 1787313165-305156
X-HE-Meta: U2FsdGVkX1+8Rzygo7M49XNyQhpaVsplU5dE/LdQAviaDiowks6eJiEI1ww5iM2ncuhXxE4nZ5Dwm+7ram0gqNmUU4+wYCMYKtgOSW4JfoS16lC++WtcR5o08KEHG3LgN0gZzgd7l72g9Ndam6GHH+4AULWfkJ+5d5A3igYztBzgO78MTRnw/8a/vI1eRmpKNPT4u5QGkSUsrTYVtuSh55dfAu/YWxY5WLmF+YJ7Y40IOzHilOloAQEJxQQOLpGO1vKvjoq6ewRfqdkt3dFfizQh/DTksACklkTTC8AEspW5r0rfUnqOVX2xi/c+uoFWD82wYEYqL9rXmPVMajwLnXRL9af7VTEgWpOeUZUVx+5Y1Wy1MCFGEUJOP9aVULr4BHE89W3uXhH/BMmwFbAWZAo9iBxuVRRwYwk+Qo+7Cc53MDiG4sbWa0mzrxdm/JyiPKx3iOqOdhLdEtrvSFvUHtISEGG7Ha2/LVp9LSC6bQHsld3YddNS5zrvCOKk6t6tRBCUNSIRPYITMx2ARSiOrxz6lvFmTYTuK6EWn4xmOQ3RRXA7W1e0cQmciHcpmrT/44wqO0EjaDWTpcIDs9wzjpnOIZU27qyes/4AFLk4t65yupyudDMZ57OdP6oBv88gRdLIeeaU0OYb596GXdQA9OLzctGX8OrpLA0D1bfFXJMN5nMZH/sCFp9pVx7aHKlL0ABH0/nMWJPFpAcoIQchjfDQmtav9GlgHAHkrfwGrE5/1YG1Y4QWHcUSiIg/YNzlqXR8LDe6IZkp8GfoHIDk0KfbsUcFKUHL+pV+ZLlVmRu4jPCyM80Ow/yBRInkB4YGiLW+IgDeZjH5J/MnWp0xQl3Z+Qt1MUaeTmSPRCKXauPxJE6o0wkG1cmdO7K9aVisZ3zlFRrZe6h2IHB0tcWVJHYmuxNoSiFCLsPwje/2ALSoVXHE9sita/13BOelT6qSR6Yo9TQbLIHg7TtZJ/Z
 JlvHsSXk
 xnRsy5QfjxRmrwFV24U9xP6UGxI+weiWJc+oXKxZIF3JmxLhZ/qvz+sBgMSsakraVdn3bA4aHJelSuKbuBDhjgCv+xysUBY3EluqfDw0t9m+Dirrgi83BapRdJxnw4rCLoZo7UNOMw8XN0ILC3ZL9VN4Kfw5SbvnWei9la9ZmvRVX1HqKPkYAIxfAg6WyLPMTbO0L8cZVu86gHMOkuiGVWoPJxEi38akUidYEcsaxHfHLnE23vbNVH6cT1Djc0zfltU/LMC3aKGOsPAULQx5HxAA/s6dZSpGRiq5S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the new COREDUMP_MEMORY_TYPES flag.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 349 +++++++++++++++++++++
 .../selftests/coredump/coredump_test_helpers.c     | 203 +++++++++++-
 .../selftests/coredump/coredump_test_helpers.h     |  23 ++
 3 files changed, 568 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index a07546e79651..6dcd6c15a565 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -1932,4 +1932,353 @@ TEST_F(coredump, socket_request_stream_choice_large)
 	ASSERT_LT(choice.received, choice.size / 8);
 }
 
+/* What a memory types test asks of the kernel and what it expects back. */
+struct memory_choice {
+	/* Memory types the crashing child selects, or FILTER_TASK_INHERIT. */
+	__u64 task_filter;
+	/* The ack. */
+	__u64 mask;
+	__u64 memory_types;
+	size_t size_ack;
+	/* The shared mapping is in the coredump with all of its memory. */
+	bool shared_dumped;
+	/* No memory at all. Pull a page from /proc/<pid>/mem instead. */
+	bool skeleton;
+};
+
+/* A skeleton still carries the vdso and friends, nothing bigger. */
+#define SKELETON_DATA_PAGES 16
+
+/*
+ * The crashing child maps shared anonymous memory and tells the server
+ * where. The server acks with @choice and checks whether that mapping's
+ * segment in the coredump carries its memory.
+ */
+static void check_memory_dump(struct __test_metadata *const _metadata,
+			      FIXTURE_DATA(coredump) *self,
+			      const struct memory_choice *choice)
+{
+	int pidfd, status;
+	pid_t pid, pid_coredump_server;
+	struct pidfd_info info = {};
+	int ipc_sockets[2];
+	int addr_pipe[2];
+	char c;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
+	ASSERT_EQ(pipe(addr_pipe), 0);
+	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
+		int fd_file = -1;
+		int exit_code = EXIT_FAILURE;
+		struct coredump_req req = {};
+		__u64 task_filter;
+		ElfW(Phdr) segment;
+		ssize_t received;
+		off_t size;
+		char *addr;
+
+		close(ipc_sockets[0]);
+		close(addr_pipe[1]);
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
+		/* The request reports the memory types the task selected. */
+		if (!peer_coredump_filter(fd_peer_pidfd, &task_filter))
+			goto out;
+
+		if (req.memory_types != task_filter) {
+			fprintf(stderr, "Request reports 0x%llx, task selected 0x%llx\n",
+				(unsigned long long)req.memory_types,
+				(unsigned long long)task_filter);
+			goto out;
+		}
+
+		if (choice->task_filter != FILTER_TASK_INHERIT &&
+		    task_filter != choice->task_filter) {
+			fprintf(stderr, "Task selected 0x%llx, child asked for 0x%llx\n",
+				(unsigned long long)task_filter,
+				(unsigned long long)choice->task_filter);
+			goto out;
+		}
+
+		/* The child sent the address of its mapping before it crashed. */
+		if (read_nointr(addr_pipe[0], &addr, sizeof(addr)) != sizeof(addr))
+			goto out;
+
+		if (!send_coredump_ack_types(fd_coredump, &req, choice->mask,
+					      choice->memory_types,
+					      choice->size_ack))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
+			goto out;
+
+		if (choice->mask & COREDUMP_RECORDS)
+			received = recv_coredump_records(fd_coredump, fd_file,
+							 &size, NULL, -1);
+		else
+			received = recv_coredump_bytes(fd_coredump, fd_file);
+		if (received < 0)
+			goto out;
+
+		if (!is_elf_core(fd_file))
+			goto out;
+
+		/* A dump ending in holes or empty segments must still be whole. */
+		if (!check_coredump_extent(fd_file))
+			goto out;
+
+		if (!find_coredump_segment(fd_file, (__u64)(uintptr_t)addr, &segment))
+			goto out;
+
+		if (segment.p_memsz != MEMORY_MAPPING_SIZE) {
+			fprintf(stderr, "Segment spans %llu bytes, the mapping %u\n",
+				(unsigned long long)segment.p_memsz,
+				MEMORY_MAPPING_SIZE);
+			goto out;
+		}
+
+		if (segment.p_filesz != (choice->shared_dumped ? segment.p_memsz : 0)) {
+			fprintf(stderr, "Segment carries %llu bytes, expected %s of them\n",
+				(unsigned long long)segment.p_filesz,
+				choice->shared_dumped ? "all" : "none");
+			goto out;
+		}
+
+		if (choice->skeleton) {
+			__u64 data, notes, data_max;
+			char buf[PAGE_SIZE];
+
+			if (!sum_coredump_segments(fd_file, &data, &notes))
+				goto out;
+
+			data_max = SKELETON_DATA_PAGES * sysconf(_SC_PAGESIZE);
+			if (!notes || data > data_max) {
+				fprintf(stderr, "Skeleton has %llu note and %llu memory bytes\n",
+					(unsigned long long)notes,
+					(unsigned long long)data);
+				goto out;
+			}
+
+			/* The task is parked in COREDUMP_WAIT with its memory. */
+			if (peer_read_mem(fd_peer_pidfd, (__u64)(uintptr_t)addr,
+					  buf, sizeof(buf)) != sizeof(buf))
+				goto out;
+
+			if (buf[0] != 'x') {
+				fprintf(stderr, "Pulled memory lacks the child's mark\n");
+				goto out;
+			}
+
+			fprintf(stderr, "Skeleton of %zd bytes, pulled %zu bytes of memory\n",
+				received, sizeof(buf));
+		}
+
+		exit_code = EXIT_SUCCESS;
+out:
+		close(addr_pipe[0]);
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
+	EXPECT_EQ(close(addr_pipe[0]), 0);
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child_memory(choice->task_filter, addr_pipe[1]);
+	EXPECT_EQ(close(addr_pipe[1]), 0);
+
+	pidfd = sys_pidfd_open(pid, 0);
+	ASSERT_GE(pidfd, 0);
+
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_TRUE(WCOREDUMP(status));
+
+	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
+	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
+	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+}
+
+/* Without COREDUMP_MEMORY_TYPES the task's own selection decides. */
+TEST_F(coredump, socket_request_memory_types_task_includes)
+{
+	struct memory_choice choice = {
+		.task_filter = COREDUMP_MEMORY_ANON_PRIVATE |
+			       COREDUMP_MEMORY_ANON_SHARED,
+		.mask = COREDUMP_KERNEL,
+		.shared_dumped = true,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
+TEST_F(coredump, socket_request_memory_types_task_excludes)
+{
+	struct memory_choice choice = {
+		.task_filter = 0,
+		.mask = COREDUMP_KERNEL,
+		.shared_dumped = false,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
+/* The server drops a memory type the task would have dumped. */
+TEST_F(coredump, socket_request_memory_types_restricts)
+{
+	struct memory_choice choice = {
+		.task_filter = COREDUMP_MEMORY_ANON_PRIVATE |
+			       COREDUMP_MEMORY_ANON_SHARED,
+		.mask = COREDUMP_KERNEL | COREDUMP_MEMORY_TYPES,
+		.memory_types = COREDUMP_MEMORY_ANON_PRIVATE,
+		.shared_dumped = false,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
+/* The server adds a memory type the task had excluded. */
+TEST_F(coredump, socket_request_memory_types_widens)
+{
+	struct memory_choice choice = {
+		.task_filter = 0,
+		.mask = COREDUMP_KERNEL | COREDUMP_MEMORY_TYPES,
+		.memory_types = COREDUMP_MEMORY_ANON_PRIVATE |
+			  COREDUMP_MEMORY_ANON_SHARED,
+		.shared_dumped = true,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
+/* The memory types decide what goes into a record stream just the same. */
+TEST_F(coredump, socket_request_memory_types_records)
+{
+	struct memory_choice choice = {
+		.task_filter = FILTER_TASK_INHERIT,
+		.mask = COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_SPARSE |
+			COREDUMP_MEMORY_TYPES,
+		.memory_types = COREDUMP_MEMORY_ANON_PRIVATE,
+		.shared_dumped = false,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
+/*
+ * An empty selection leaves a skeleton: every program header and every note
+ * but no memory. A server that wants to pick the memory itself reads it
+ * from /proc/<pid>/mem while the task waits for it to finish.
+ */
+TEST_F(coredump, socket_request_memory_types_skeleton)
+{
+	struct memory_choice choice = {
+		.task_filter = FILTER_TASK_INHERIT,
+		.mask = COREDUMP_KERNEL | COREDUMP_WAIT | COREDUMP_MEMORY_TYPES,
+		.memory_types = 0,
+		.shared_dumped = false,
+		.skeleton = true,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
+/* A memory type the kernel didn't advertise in memory_types_mask. */
+TEST_F(coredump, socket_request_memory_types_unknown_bit)
+{
+	struct refused_ack refused = {
+		.ack = {
+			.size = sizeof(struct coredump_ack),
+			.mask = COREDUMP_KERNEL | COREDUMP_MEMORY_TYPES,
+			.memory_types = 1ULL << 63,
+		},
+		.bytes = sizeof(struct coredump_ack),
+		.mark = COREDUMP_MARK_UNSUPPORTED,
+	};
+
+	check_refused_ack(_metadata, self, &refused);
+}
+
+/* The memory types must be zero unless COREDUMP_MEMORY_TYPES is raised. */
+TEST_F(coredump, socket_request_memory_types_stale_field)
+{
+	struct refused_ack refused = {
+		.ack = {
+			.size = sizeof(struct coredump_ack),
+			.mask = COREDUMP_KERNEL,
+			.memory_types = COREDUMP_MEMORY_ANON_PRIVATE,
+		},
+		.bytes = sizeof(struct coredump_ack),
+		.mark = COREDUMP_MARK_UNSUPPORTED,
+	};
+
+	check_refused_ack(_metadata, self, &refused);
+}
+
+/* COREDUMP_MEMORY_TYPES needs an ack that has the memory types. */
+TEST_F(coredump, socket_request_memory_types_short_ack)
+{
+	struct refused_ack refused = {
+		.ack = {
+			.size = COREDUMP_ACK_SIZE_VER0,
+			.mask = COREDUMP_KERNEL | COREDUMP_MEMORY_TYPES,
+		},
+		.bytes = COREDUMP_ACK_SIZE_VER0,
+		.mark = COREDUMP_MARK_MINSIZE,
+	};
+
+	check_refused_ack(_metadata, self, &refused);
+}
+
+/* The memory types select what the kernel writes, nothing else. */
+TEST_F(coredump, socket_request_memory_types_without_kernel)
+{
+	check_conflicting_ack(_metadata, self, COREDUMP_USERSPACE | COREDUMP_MEMORY_TYPES);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 9aa901e14f02..7ae0c6c458aa 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -17,6 +17,7 @@
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/socket.h>
+#include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/un.h>
 #include <sys/wait.h>
@@ -73,6 +74,48 @@ void crashing_child_sparse(size_t size)
 	*(volatile int *)NULL = 0;
 }
 
+/* Select @types through the caller's own /proc/self/coredump_filter. */
+static bool set_coredump_filter(__u64 types)
+{
+	char buf[32];
+	int fd, len;
+	bool ok;
+
+	fd = open("/proc/self/coredump_filter", O_WRONLY | O_CLOEXEC);
+	if (fd < 0)
+		return false;
+
+	len = snprintf(buf, sizeof(buf), "0x%llx", (unsigned long long)types);
+	ok = write_nointr(fd, buf, len) == len;
+	close(fd);
+	return ok;
+}
+
+/*
+ * Map shared anonymous memory, touch it, tell the server where it is and
+ * crash. A @task_filter other than FILTER_TASK_INHERIT is selected first.
+ */
+void crashing_child_memory(__u64 task_filter, int fd_addr)
+{
+	char *p;
+
+	if (task_filter != FILTER_TASK_INHERIT && !set_coredump_filter(task_filter))
+		_exit(EXIT_FAILURE);
+
+	p = mmap(NULL, MEMORY_MAPPING_SIZE, PROT_READ | PROT_WRITE,
+		 MAP_SHARED | MAP_ANONYMOUS, -1, 0);
+	if (p == MAP_FAILED)
+		_exit(EXIT_FAILURE);
+	p[0] = 'x';
+
+	if (write_nointr(fd_addr, &p, sizeof(p)) != sizeof(p))
+		_exit(EXIT_FAILURE);
+	close(fd_addr);
+
+	/* crash on purpose */
+	*(volatile int *)NULL = 0;
+}
+
 /* Sink a reassembled record stream is handed to, record by record. */
 struct coredump_record_sink {
 	/* @len bytes of coredump data that belong at @offset. */
@@ -916,6 +959,82 @@ static const ElfW(Phdr) *find_segment(const ElfW(Phdr) *phdr, size_t nr,
 	return NULL;
 }
 
+/* The PT_LOAD segment @vaddr falls into. */
+bool find_coredump_segment(int fd, __u64 vaddr, ElfW(Phdr) *segment)
+{
+	const ElfW(Phdr) *found;
+	ElfW(Phdr) *phdr;
+	size_t nr;
+
+	phdr = read_phdrs(fd, &nr);
+	if (!phdr)
+		return false;
+
+	found = find_segment(phdr, nr, vaddr);
+	if (found)
+		*segment = *found;
+	else
+		fprintf(stderr, "%s: no segment for 0x%llx\n", __func__,
+			(unsigned long long)vaddr);
+
+	free(phdr);
+	return found;
+}
+
+/* How many bytes the PT_LOAD and the PT_NOTE segments of @fd carry. */
+bool sum_coredump_segments(int fd, __u64 *data, __u64 *notes)
+{
+	ElfW(Phdr) *phdr;
+	size_t nr, i;
+
+	phdr = read_phdrs(fd, &nr);
+	if (!phdr)
+		return false;
+
+	*data = 0;
+	*notes = 0;
+	for (i = 0; i < nr; i++) {
+		if (phdr[i].p_type == PT_LOAD)
+			*data += phdr[i].p_filesz;
+		else if (phdr[i].p_type == PT_NOTE)
+			*notes += phdr[i].p_filesz;
+	}
+
+	free(phdr);
+	return true;
+}
+
+/* The coredump in @fd is at least as long as every segment it declares. */
+bool check_coredump_extent(int fd)
+{
+	ElfW(Phdr) *phdr;
+	struct stat st;
+	size_t nr, i;
+	bool ok = true;
+
+	if (fstat(fd, &st)) {
+		fprintf(stderr, "%s: fstat: %m\n", __func__);
+		return false;
+	}
+
+	phdr = read_phdrs(fd, &nr);
+	if (!phdr)
+		return false;
+
+	for (i = 0; i < nr; i++) {
+		if (phdr[i].p_offset + phdr[i].p_filesz <= (__u64)st.st_size)
+			continue;
+		fprintf(stderr, "%s: segment %zu ends at %llu, the coredump at %llu\n",
+			__func__, i,
+			(unsigned long long)(phdr[i].p_offset + phdr[i].p_filesz),
+			(unsigned long long)st.st_size);
+		ok = false;
+	}
+
+	free(phdr);
+	return ok;
+}
+
 /* The next stretch of memory the segments cover, split ones merged back. */
 static bool next_range(const ElfW(Phdr) *phdr, size_t nr, size_t *i,
 		       __u64 *start, __u64 *end)
@@ -1250,6 +1369,62 @@ ssize_t peer_vm_size(int fd_peer_pidfd)
 
 /* Protocol helper functions */
 
+/* The peer's /proc/<pid>/coredump_filter, which is in memory types. */
+bool peer_coredump_filter(int fd_peer_pidfd, __u64 *memory_types)
+{
+	struct pidfd_info info = {};
+	unsigned long value;
+	char path[64];
+	FILE *f;
+	int ret;
+
+	if (!get_pidfd_info(fd_peer_pidfd, &info))
+		return false;
+
+	snprintf(path, sizeof(path), "/proc/%d/coredump_filter", info.pid);
+	f = fopen(path, "r");
+	if (!f) {
+		fprintf(stderr, "%s: %s: %m\n", __func__, path);
+		return false;
+	}
+
+	ret = fscanf(f, "%lx", &value);
+	fclose(f);
+	if (ret != 1) {
+		fprintf(stderr, "%s: %s: no value\n", __func__, path);
+		return false;
+	}
+
+	*memory_types = value;
+	return true;
+}
+
+/* Read @len bytes at @addr from the peer's /proc/<pid>/mem. */
+ssize_t peer_read_mem(int fd_peer_pidfd, __u64 addr, void *buf, size_t len)
+{
+	struct pidfd_info info = {};
+	char path[64];
+	ssize_t ret;
+	int fd;
+
+	if (!get_pidfd_info(fd_peer_pidfd, &info))
+		return -1;
+
+	snprintf(path, sizeof(path), "/proc/%d/mem", info.pid);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
+	if (fd < 0) {
+		fprintf(stderr, "%s: %s: %m\n", __func__, path);
+		return -1;
+	}
+
+	ret = pread(fd, buf, len, addr);
+	if (ret < 0)
+		fprintf(stderr, "%s: %s at 0x%llx: %m\n", __func__, path,
+			(unsigned long long)addr);
+	close(fd);
+	return ret;
+}
+
 ssize_t recv_marker(int fd)
 {
 	enum coredump_mark mark = COREDUMP_MARK_REQACK;
@@ -1377,16 +1552,18 @@ bool send_coredump_ack_bytes(int fd, const struct coredump_ack *ack, size_t len)
 		return false;
 	}
 
-	fprintf(stderr, "Sent %zu bytes of coredump ack: size %u, mask 0x%llx\n",
-		len, ack->size, (unsigned long long)ack->mask);
+	fprintf(stderr, "Sent %zu bytes of coredump ack: size %u, mask 0x%llx, types 0x%llx\n",
+		len, ack->size, (unsigned long long)ack->mask,
+		(unsigned long long)ack->memory_types);
 	return true;
 }
 
-bool send_coredump_ack(int fd, const struct coredump_req *req,
-		       __u64 mask, size_t size_ack)
+bool send_coredump_ack_types(int fd, const struct coredump_req *req,
+			      __u64 mask, __u64 memory_types, size_t size_ack)
 {
 	struct coredump_ack ack = {
 		.mask = mask,
+		.memory_types = memory_types,
 	};
 
 	if (!size_ack)
@@ -1397,17 +1574,23 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
 	return send_coredump_ack_bytes(fd, &ack, size_ack);
 }
 
+bool send_coredump_ack(int fd, const struct coredump_req *req,
+		       __u64 mask, size_t size_ack)
+{
+	return send_coredump_ack_types(fd, req, mask, 0, size_ack);
+}
+
 /* Every option the kernel is expected to advertise in coredump_req->mask. */
 #define TEST_REQ_MASK_ALL					\
 	(COREDUMP_KERNEL | COREDUMP_USERSPACE |			\
 	 COREDUMP_REJECT | COREDUMP_WAIT |			\
-	 COREDUMP_RECORDS | COREDUMP_SPARSE)
+	 COREDUMP_RECORDS | COREDUMP_SPARSE | COREDUMP_MEMORY_TYPES)
 
 bool check_coredump_req(const struct coredump_req *req)
 {
-	if (req->size < COREDUMP_REQ_SIZE_VER0) {
+	if (req->size < COREDUMP_REQ_SIZE_VER1) {
 		fprintf(stderr, "%s: size %u below minimum %d\n",
-			__func__, req->size, COREDUMP_REQ_SIZE_VER0);
+			__func__, req->size, COREDUMP_REQ_SIZE_VER1);
 		return false;
 	}
 	if (req->mask != TEST_REQ_MASK_ALL) {
@@ -1416,6 +1599,12 @@ bool check_coredump_req(const struct coredump_req *req)
 			(unsigned long long)TEST_REQ_MASK_ALL);
 		return false;
 	}
+	if (req->memory_types_mask != TEST_MEMORY_ALL) {
+		fprintf(stderr, "%s: memory_types_mask 0x%llx, expected 0x%llx\n",
+			__func__, (unsigned long long)req->memory_types_mask,
+			(unsigned long long)TEST_MEMORY_ALL);
+		return false;
+	}
 	return true;
 }
 
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
index 0970d3550fc1..fc21b8620359 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.h
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
@@ -3,6 +3,7 @@
 #ifndef __COREDUMP_TEST_HELPERS_H
 #define __COREDUMP_TEST_HELPERS_H
 
+#include <link.h>
 #include <stdbool.h>
 #include <sys/types.h>
 #include <linux/coredump.h>
@@ -21,10 +22,30 @@
 /* A task mapping at least this much is worth a record stream. */
 #define SPARSE_STREAM_THRESHOLD (SPARSE_MAPPING_SIZE / 2)
 
+/* Size of the shared anonymous mapping the memory types tests map. */
+#define MEMORY_MAPPING_SIZE (4 * 1024 * 1024)
+
+/* Leave the coredump_filter the crashing child inherited alone. */
+#define FILTER_TASK_INHERIT ((__u64)-1)
+
+/* Every memory type the kernel is expected to advertise. */
+#define TEST_MEMORY_ALL						\
+	(COREDUMP_MEMORY_ANON_PRIVATE | COREDUMP_MEMORY_ANON_SHARED |	\
+	 COREDUMP_MEMORY_FILE_PRIVATE | COREDUMP_MEMORY_FILE_SHARED |	\
+	 COREDUMP_MEMORY_ELF_HEADERS |					\
+	 COREDUMP_MEMORY_HUGETLB_PRIVATE | COREDUMP_MEMORY_HUGETLB_SHARED | \
+	 COREDUMP_MEMORY_DAX_PRIVATE | COREDUMP_MEMORY_DAX_SHARED)
+
 /* Shared helper function declarations */
 void *do_nothing(void *arg);
 void crashing_child(void);
 void crashing_child_sparse(size_t size);
+void crashing_child_memory(__u64 task_filter, int fd_addr);
+bool find_coredump_segment(int fd, __u64 vaddr, ElfW(Phdr) *segment);
+bool sum_coredump_segments(int fd, __u64 *data, __u64 *notes);
+bool check_coredump_extent(int fd);
+bool peer_coredump_filter(int fd_peer_pidfd, __u64 *memory_types);
+ssize_t peer_read_mem(int fd_peer_pidfd, __u64 addr, void *buf, size_t len);
 ssize_t recv_coredump_records(int fd_coredump, int fd_core_file,
 			      off_t *coredump_size, bool *truncated,
 			      int fd_peer_pidfd);
@@ -46,6 +67,8 @@ bool read_marker(int fd, enum coredump_mark mark);
 bool read_coredump_req(int fd, struct coredump_req *req);
 bool send_coredump_ack(int fd, const struct coredump_req *req,
 		       __u64 mask, size_t size_ack);
+bool send_coredump_ack_types(int fd, const struct coredump_req *req,
+			      __u64 mask, __u64 memory_types, size_t size_ack);
 bool send_coredump_ack_bytes(int fd, const struct coredump_ack *ack, size_t len);
 bool check_coredump_req(const struct coredump_req *req);
 int open_coredump_tmpfile(int fd_tmpfs_detached);

-- 
2.53.0


