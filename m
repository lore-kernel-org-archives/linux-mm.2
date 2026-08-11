Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 103ADC5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:28:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE6B6B0098; Tue, 11 Aug 2026 11:28:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5C76B00AF; Tue, 11 Aug 2026 11:28:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B4CB6B00B1; Tue, 11 Aug 2026 11:28:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D50D36B0098
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:28:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 63E931C135F
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:27 +0000 (UTC)
X-FDA: 85089370254.07.3F00F51
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 973CD14000B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:28:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csZT+OQW;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kMay+L1AYU36nG7IEiQytwVomvHtiRva+AboZzfmtms=;
	b=Koa2sHCYh51aLLr8sy6ef0ObS868ZWm7uccp1RFPwbnpBl9Cm38o+2R054150Jj/LZYkM2
	CKYqC5BDEZ7rnw9QhcGR1cCTRkKcHx/2hSZAHfc76Fb1qhCsDYkdTrY38EH+aud7UA67w4
	f2f/GC5BQDMeKjuLIB0iCwVvpPGPRsQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462105;
	b=WaQIl4ksVWGos+jKkfUY5+hIYzZgRupS75ECsbt1xQ0l6m+p3BH2r7CWJ9SZ3eyo5jMJgs
	d2rjaEh/QgOd2Ea9ZQtS0xY143Ileq6bSxREmSa1iCUIBsXdZCxqmPmFNQJ+/1lQUYb3dm
	Gf+d4zFF6z/H32LOhjl8rLWRqbJrqHU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=csZT+OQW;
	spf=pass (imf23.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDFE642A6F;
	Tue, 11 Aug 2026 15:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA58B1F00A3A;
	Tue, 11 Aug 2026 15:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786462104;
	bh=kMay+L1AYU36nG7IEiQytwVomvHtiRva+AboZzfmtms=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=csZT+OQWAYEJS5WyvDG1We6a4cCdwoH64dANf9Lmk5/fDy08lbGxdLJm5bmxyELDL
	 DRUCJBXmDCirZ6GpBzUOE4wo38tH2IAeIQC2NJojo4roqBwbZMsHW6lmQNzozvuKx3
	 YQqOx/i+K6v3+f22p79LdD30SUiUjHPpb7TGaBNamopHfNLmRbnAb81B4pkcju9VwQ
	 FkrC3Ui+Nr5mXX0xroSo/v7rYboxAKb6bUfc6y0k2Owwilsr08l9krTqsShrLMyE79
	 K+Yg62EnfiuBTbyqVa+SpfbwUQvYKqqKy3p/y+2MfPV1PrQFep8l3aTw743QZJjWZO
	 CksEYuWvHa9Ew==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 11 Aug 2026 17:27:32 +0200
Subject: [PATCH 11/11] selftests/coredump: test COREDUMP_HEADER and
 COREDUMP_SPARSE
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260811-work-coredump-sparse-v1-11-cd3e8b1e356d@kernel.org>
References: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
In-Reply-To: <20260811-work-coredump-sparse-v1-0-cd3e8b1e356d@kernel.org>
To: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Omar Sandoval <osandov@osandov.com>, 
 Jacob Lalonde <jalalonde@fb.com>, Shuah Khan <shuah@kernel.org>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-362b8
X-Developer-Signature: v=1; a=openpgp-sha256; l=18037; i=brauner@kernel.org;
 h=from:subject:message-id; bh=CamofIBhXFoXZcBJPLKpcNj976NXj8B3BDgiDN4BT1k=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRV2yeetO6a95m95uCVgubPZe/DY/63OHyde0rmTP2uO
 uPOU88qO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACbSMJuR4deZwPVPjPPnPhdu
 /ftdq+OZg83s+kdntsxcfdVfMW+XymqGf8p+qRO813Ikm0y7w/3x1d5ynpt7e43275f5/HTVo5v
 zf3MDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ftoskawsknpbzeseesih4hs33ywgtrrr
X-Rspamd-Queue-Id: 973CD14000B
X-HE-Tag: 1786462105-180463
X-HE-Meta: U2FsdGVkX1+3ioZ61pOgzT92NUf5x7Yc4aKiR8z2cO8URD+KmQ4H18y8/Ax2Sq8Jo76OVhFazieVzNF62uQnkbCbFfRFRQ8yqnTwjZwfC0oPpRfLDod4zBPphkaGkkY/Pj/y9lmBFhxOWeJy1/Uot3ICJfR0y+ezLJeqywx9LhNu045u0tmXGC33q8z7dG7cqaEO00O2b02Yv1yh32/AOmT/K09YEucIvTjJOSEIxzywq5sIc7DdVaBn6xLoFrGWlkCYYITOJ+ehjQwh/+TsXS90I4gKzcF0RNL1daQRiosAAClKGKy+9ydpXvVz+H1ghpwK4QEXIVQ/RogY2C2zbrMyD3EfO/tTFhL+9fXtCebCtSE5FGgevGXjPVj8yCnlLSnKRVHVRmtPmaVqlOP11bUAEKSIJT0mz9vvl5/QDcsCpYACFfFB1O2cgEJK99XUVD6r3+YbZxl3NdethFiyQzHI2omdAXiU4V65DJqZRXvPwzBGaJSix3xtgqytH3sv7bNu+QO3wmi5XQavBVyGWiifkj7UxJvfjJ/SchuH19WxTxZOZwbAi/7k5lUzRMKqt3z0vos+zpw6ub/Y1snrKye6aX28tPLOzrXRLUE+E/+ReMzOoXUY/jyusq+02qGJqm2fwM8zMclNKd6jEGVSXm31YkdSos4+YvSP5cyXnogdZBZ0g/pmNWM1utpndn1KeON43xeUgcGjiMEwMo4I21Suz3uYdGOAgAuK1O411e99rXytMnJre/KlByELV++mVP0q+o6tZce7lE8XHPew1UL4B+ohW87JW57CpfUp0yV/uIts6k6o/Y2dhS7wBgwBGEp4vPTOq0ZKtrnWeV/+xnqavELGHZ4qYj8/9/nLsMyTrB3yalARRMcIjMJeRYW/UbOyeKqzZgW9YQRos+rpkQGGb7Yc6gC50tOC/3vyLnEQ4udZzXEzv2fZwsjBUnHvTMPLt0gl4FdJrekKPGC
 7VQ/+ji6
 J3vSkUOWkK+faxQAbEzioKHK+7yvjbvn5OpM/Xw0Dqj8H6rE0Sg1QBgaGQlezuVOPCQJ45IhzKVcMNw+9C4+KCGZKSW4y0G8qrQwGcabO8o9VoRx+eZPUjd8LdLoqND/YZkottXhOF68X2kiIG4Jpa7NfS44gAdXrikqursf8TZYVF2aS5p8+GWtpDBjvKNy5+ZB9SXjnk2vZwxAGdMeMgs5KKMIYZdXq5IGZd0jLkqkAslGwFu+KoFtB20HT9R7AG7uxLHtmi/BbcjZhTfocQZoLjNGgrzNs4tva49oJ4FoI9rI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Test the new COREDUMP_HEADER and COREDUMP_SPARSE flags.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 379 +++++++++++++++++++++
 tools/testing/selftests/coredump/coredump_test.h   |   6 +
 .../selftests/coredump/coredump_test_helpers.c     | 156 ++++++++-
 3 files changed, 540 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index 60a357e628eb..ef36e787a529 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -1,5 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
+#include <elf.h>
 #include <sys/stat.h>
 #include <sys/epoll.h>
 #include <sys/socket.h>
@@ -1573,4 +1574,382 @@ TEST_F_TIMEOUT(coredump, socket_multiple_crashing_coredumps_epoll_workers, 500)
 	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
 }
 
+/*
+ * Reassemble a framed coredump and check that what comes out is an ELF
+ * core file. The frames themselves are validated by recv_coredump_frames().
+ */
+TEST_F(coredump, socket_request_sparse)
+{
+	unsigned char ehdr[EI_NIDENT + sizeof(Elf64_Half)];
+	int fd_core_file, pidfd, status;
+	pid_t pid, pid_coredump_server;
+	struct pidfd_info info = {};
+	int ipc_sockets[2];
+	Elf64_Half e_type;
+	struct stat st;
+	char c;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
+	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
+		int fd_file = -1;
+		int exit_code = EXIT_FAILURE;
+		struct coredump_req req = {};
+
+		close(ipc_sockets[0]);
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
+		fd_file = creat("/tmp/coredump.file", 0644);
+		if (fd_file < 0)
+			goto out;
+
+		if (!read_coredump_req(fd_coredump, &req))
+			goto out;
+
+		if (!check_coredump_req(&req))
+			goto out;
+
+		if (!send_coredump_ack(fd_coredump, &req,
+				       COREDUMP_KERNEL | COREDUMP_HEADER |
+				       COREDUMP_SPARSE | COREDUMP_WAIT, 0))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
+			goto out;
+
+		if (recv_coredump_frames(fd_coredump, fd_file, NULL) < 0)
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
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
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child();
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
+
+	ASSERT_EQ(stat("/tmp/coredump.file", &st), 0);
+	ASSERT_GT(st.st_size, (off_t)sizeof(ehdr));
+
+	/* What the frames reassemble into has to be an ELF core file. */
+	fd_core_file = open("/tmp/coredump.file", O_RDONLY | O_CLOEXEC);
+	ASSERT_GE(fd_core_file, 0);
+	ASSERT_EQ(read_nointr(fd_core_file, ehdr, sizeof(ehdr)), sizeof(ehdr));
+	EXPECT_EQ(close(fd_core_file), 0);
+
+	/* e_type sits right behind e_ident in both ELF32 and ELF64. */
+	ASSERT_EQ(memcmp(ehdr, ELFMAG, SELFMAG), 0);
+	memcpy(&e_type, ehdr + EI_NIDENT, sizeof(e_type));
+	ASSERT_EQ(e_type, ET_CORE);
+}
+
+/*
+ * Crash a child with a mostly-unpopulated mapping and reassemble its
+ * framed coredump, reporting what crossed the socket and the coredump
+ * size the frames describe.
+ */
+static void test_framed_hole(struct __test_metadata *const _metadata,
+			     FIXTURE_DATA(coredump) *self, __u64 ack_mask,
+			     ssize_t *received, off_t *coredump_size)
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
+		if (!send_coredump_ack(fd_coredump, &req, ack_mask, 0))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
+			goto out;
+
+		ret = recv_coredump_frames(fd_coredump, fd_file, &size);
+		if (ret < 0)
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
+		crashing_child_sparse(SPARSE_MAPPING_SIZE);
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
+	ASSERT_EQ(read_nointr(pipefds[0], received, sizeof(*received)),
+		  sizeof(*received));
+	ASSERT_EQ(read_nointr(pipefds[0], coredump_size, sizeof(*coredump_size)),
+		  sizeof(*coredump_size));
+	EXPECT_EQ(close(pipefds[0]), 0);
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+
+	/* The mapping is in the coredump, holes included. */
+	ASSERT_GT(*coredump_size, (off_t)SPARSE_MAPPING_SIZE);
+}
+
+/*
+ * A mapping that has been written to is dumped whole, including the parts
+ * of it that were never faulted in. With COREDUMP_SPARSE the holes stay
+ * off the wire.
+ */
+TEST_F(coredump, socket_request_sparse_hole)
+{
+	off_t coredump_size = 0;
+	ssize_t received = 0;
+
+	test_framed_hole(_metadata, self,
+			 COREDUMP_KERNEL | COREDUMP_HEADER |
+			 COREDUMP_SPARSE | COREDUMP_WAIT,
+			 &received, &coredump_size);
+
+	/* The holes didn't have to go over the socket. */
+	ASSERT_LT(received, coredump_size / 8);
+}
+
+/*
+ * COREDUMP_HEADER alone frames the stream but elides nothing: the holes
+ * cross the socket as data frames.
+ */
+TEST_F(coredump, socket_request_header_hole)
+{
+	off_t coredump_size = 0;
+	ssize_t received = 0;
+
+	test_framed_hole(_metadata, self,
+			 COREDUMP_KERNEL | COREDUMP_HEADER | COREDUMP_WAIT,
+			 &received, &coredump_size);
+
+	/* Framing alone elides nothing, so everything crossed the socket. */
+	ASSERT_GT(received, coredump_size);
+}
+
+/* Ack @ack_mask, expect the kernel to refuse it as conflicting. */
+static void test_conflicting_ack(struct __test_metadata *const _metadata,
+				 FIXTURE_DATA(coredump) *self, __u64 ack_mask)
+{
+	int pidfd, status;
+	pid_t pid, pid_coredump_server;
+	struct pidfd_info info = {};
+	int ipc_sockets[2];
+	char c;
+
+	ASSERT_EQ(socketpair(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0, ipc_sockets), 0);
+	ASSERT_TRUE(set_core_pattern("@@/tmp/coredump.socket"));
+
+	pid_coredump_server = fork();
+	ASSERT_GE(pid_coredump_server, 0);
+	if (pid_coredump_server == 0) {
+		int fd_server = -1, fd_coredump = -1, fd_peer_pidfd = -1;
+		int exit_code = EXIT_FAILURE;
+		struct coredump_req req = {};
+
+		close(ipc_sockets[0]);
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
+		if (!read_coredump_req(fd_coredump, &req))
+			goto out;
+
+		if (!check_coredump_req(&req))
+			goto out;
+
+		if (!send_coredump_ack(fd_coredump, &req, ack_mask, 0))
+			goto out;
+
+		if (!read_marker(fd_coredump, COREDUMP_MARK_CONFLICTING))
+			goto out;
+
+		exit_code = EXIT_SUCCESS;
+out:
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
+	ASSERT_EQ(read_nointr(ipc_sockets[0], &c, 1), 1);
+	EXPECT_EQ(close(ipc_sockets[0]), 0);
+
+	pid = fork();
+	ASSERT_GE(pid, 0);
+	if (pid == 0)
+		crashing_child();
+
+	pidfd = sys_pidfd_open(pid, 0);
+	ASSERT_GE(pidfd, 0);
+
+	waitpid(pid, &status, 0);
+	ASSERT_TRUE(WIFSIGNALED(status));
+	ASSERT_FALSE(WCOREDUMP(status));
+
+	ASSERT_TRUE(get_pidfd_info(pidfd, &info));
+	ASSERT_GT((info.mask & PIDFD_INFO_COREDUMP), 0);
+	ASSERT_GT((info.coredump_mask & PIDFD_COREDUMPED), 0);
+
+	wait_and_check_coredump_server(pid_coredump_server, _metadata, self);
+}
+
+/* COREDUMP_HEADER frames a coredump the kernel writes, nothing else. */
+TEST_F(coredump, socket_request_header_without_kernel)
+{
+	test_conflicting_ack(_metadata, self, COREDUMP_USERSPACE | COREDUMP_HEADER);
+}
+
+/* A zero frame can't exist outside a framed stream. */
+TEST_F(coredump, socket_request_sparse_without_header)
+{
+	test_conflicting_ack(_metadata, self, COREDUMP_KERNEL | COREDUMP_SPARSE);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/coredump/coredump_test.h b/tools/testing/selftests/coredump/coredump_test.h
index a02809145e2d..ae1751298aaf 100644
--- a/tools/testing/selftests/coredump/coredump_test.h
+++ b/tools/testing/selftests/coredump/coredump_test.h
@@ -16,6 +16,9 @@
 
 #define NUM_THREAD_SPAWN 128
 
+/* Size of the mostly unpopulated mapping the sparse coredump test maps. */
+#define SPARSE_MAPPING_SIZE (256 * 1024 * 1024)
+
 /* Coredump fixture */
 FIXTURE(coredump)
 {
@@ -27,6 +30,9 @@ FIXTURE(coredump)
 /* Shared helper function declarations */
 void *do_nothing(void *arg);
 void crashing_child(void);
+void crashing_child_sparse(size_t size);
+ssize_t recv_coredump_frames(int fd_coredump, int fd_core_file,
+			     off_t *coredump_size);
 int create_detached_tmpfs(void);
 int create_and_listen_unix_socket(const char *path);
 bool set_core_pattern(const char *pattern);
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index ee669969605b..dececebe15cb 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <sys/epoll.h>
 #include <sys/ioctl.h>
+#include <sys/mman.h>
 #include <sys/socket.h>
 #include <sys/types.h>
 #include <sys/un.h>
@@ -59,6 +60,156 @@ void crashing_child(void)
 	i = *(volatile int *)NULL;
 }
 
+void crashing_child_sparse(size_t size)
+{
+	char *p;
+
+	/*
+	 * Touch the first page only. The whole mapping is dumped because
+	 * it has been written to, but all of it save that one page is a
+	 * hole.
+	 */
+	p = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		 MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1, 0);
+	if (p != MAP_FAILED)
+		p[0] = 'x';
+
+	/* crash on purpose */
+	*(volatile int *)NULL = 0;
+}
+
+/* Read @len bytes off the socket, writing them at @offset if @fd_out >= 0. */
+static ssize_t recv_frame_bytes(int fd_coredump, __u64 len, int fd_out,
+				off_t offset)
+{
+	ssize_t received = 0;
+
+	while (len) {
+		char buffer[PAGE_SIZE];
+		size_t chunk = len < sizeof(buffer) ? len : sizeof(buffer);
+		ssize_t ret;
+
+		ret = recv(fd_coredump, buffer, chunk, MSG_WAITALL);
+		if (ret <= 0) {
+			fprintf(stderr, "%s: short read %zd: %m\n",
+				__func__, ret);
+			return -1;
+		}
+
+		if (fd_out >= 0 &&
+		    pwrite(fd_out, buffer, ret, offset + received) != ret) {
+			fprintf(stderr, "%s: pwrite failed: %m\n", __func__);
+			return -1;
+		}
+
+		received += ret;
+		len -= ret;
+	}
+
+	return received;
+}
+
+ssize_t recv_coredump_frames(int fd_coredump, int fd_core_file,
+			     off_t *coredump_size)
+{
+	ssize_t received = 0;
+	off_t size = 0;
+
+	for (;;) {
+		struct coredump_frame_header frame = {};
+		size_t known;
+		ssize_t ret;
+
+		/* Peek the header size the way read_coredump_req() does. */
+		ret = recv(fd_coredump, &frame, sizeof(frame.size),
+			   MSG_PEEK | MSG_WAITALL);
+		if (ret == 0)
+			break;
+		if (ret != sizeof(frame.size)) {
+			fprintf(stderr, "%s: short frame peek %zd: %m\n",
+				__func__, ret);
+			return -1;
+		}
+
+		if (frame.size < COREDUMP_FRAME_HEADER_SIZE_VER0) {
+			fprintf(stderr, "%s: header size %u below minimum %u\n",
+				__func__, frame.size,
+				COREDUMP_FRAME_HEADER_SIZE_VER0);
+			return -1;
+		}
+
+		/* Consume as much of the header as we know about. */
+		known = frame.size < sizeof(frame) ? frame.size : sizeof(frame);
+		ret = recv(fd_coredump, &frame, known, MSG_WAITALL);
+		if (ret != (ssize_t)known) {
+			fprintf(stderr, "%s: short frame read %zd: %m\n",
+				__func__, ret);
+			return -1;
+		}
+		received += ret;
+
+		/*
+		 * A flag changes what the frame means, so refuse one we
+		 * don't know rather than guess.
+		 */
+		if (frame.flags) {
+			fprintf(stderr, "%s: unknown header flags 0x%llx\n",
+				__func__, (unsigned long long)frame.flags);
+			return -1;
+		}
+
+		/* Discard any part of the header we have no use for. */
+		ret = recv_frame_bytes(fd_coredump, frame.size - known, -1, 0);
+		if (ret < 0)
+			return -1;
+		received += ret;
+
+		/* Frames are sent in order and they don't leave gaps. */
+		if (frame.offset != (__u64)size) {
+			fprintf(stderr, "%s: frame at %llu, expected %llu\n",
+				__func__, (unsigned long long)frame.offset,
+				(unsigned long long)size);
+			return -1;
+		}
+
+		switch (frame.type) {
+		case COREDUMP_FRAME_ZERO:
+			/* A hole. It comes with no data and needs none. */
+			break;
+		case COREDUMP_FRAME_DATA:
+			ret = recv_frame_bytes(fd_coredump, frame.len,
+					       fd_core_file, size);
+			if (ret < 0)
+				return -1;
+			received += ret;
+			break;
+		default:
+			fprintf(stderr, "%s: unknown frame type %u\n",
+				__func__, frame.type);
+			return -1;
+		}
+
+		size += frame.len;
+	}
+
+	/*
+	 * Nothing is written for a hole, so grow the file to the size the
+	 * frames describe in case the coredump ended in one.
+	 */
+	if (ftruncate(fd_core_file, size) < 0) {
+		fprintf(stderr, "%s: ftruncate to %llu failed: %m\n",
+			__func__, (unsigned long long)size);
+		return -1;
+	}
+
+	if (coredump_size)
+		*coredump_size = size;
+
+	fprintf(stderr, "Received %zd bytes for a coredump of %llu bytes\n",
+		received, (unsigned long long)size);
+	return received;
+}
+
 int create_detached_tmpfs(void)
 {
 	int fd_context, fd_tmpfs;
@@ -101,6 +252,7 @@ int create_and_listen_unix_socket(const char *path)
 	return fd;
 
 out:
+	fprintf(stderr, "%s: %s: %m\n", __func__, path);
 	if (fd >= 0)
 		close(fd);
 	return -1;
@@ -279,8 +431,10 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
 	large_ack.ack.mask = mask;
 	large_ack.ack.size = size_ack;
 	ret = send(fd, &large_ack, size_ack, MSG_NOSIGNAL);
-	if (ret != size_ack)
+	if (ret != size_ack) {
+		fprintf(stderr, "%s: short send %zd: %m\n", __func__, ret);
 		return false;
+	}
 
 	fprintf(stderr, "Sent coredump ack with size %zu and mask 0x%llx\n",
 		size_ack, (unsigned long long)mask);

-- 
2.53.0


