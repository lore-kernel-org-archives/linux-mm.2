Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C00DCC5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE6156B00A5; Fri, 21 Aug 2026 07:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20196B00A6; Fri, 21 Aug 2026 07:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE9336B00A7; Fri, 21 Aug 2026 07:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 841C56B00A5
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:52:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1228803E9
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:55 +0000 (UTC)
X-FDA: 85125115110.07.5346D49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1062C120002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EDtfU9WF;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787313174;
	b=SBwtl7/45hq2T5zdiPc4sYBxHc1bYIPWpiGNvPMyxaZQQXLyvsd3cnyVGzi+F1VHcl2X94
	oJFFvZyUDeTSAvGCsaX2iH9w+eymidOv0Y9S5Hgu7TDWRcjAJ140H+RvWJhJm5uFearuhS
	7bvuhEhTg182Yp0YTxQgJ5b1UAS0Ods=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EDtfU9WF;
	spf=pass (imf29.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787313174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XUvMki9m/n9mnXIoNrow9G6Ne0BI+Fmg+IK7F3pcUQ0=;
	b=jZCkHYv4hsm+qL++mwILx/MpfkSb7LrC7XXeEEzVS4SdBbQpI7asEP+eUy7bhK8/Xe+U7k
	YKc/BQpuHFv6yMbeqVULe//yzDet9H5T0U4Dsps+1O1sKK6V+VAzK0059lTmOPMrbQKHdP
	LYKCWjm88fKMtFB9F5pEmH9F/fcQysM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8860660A5D;
	Fri, 21 Aug 2026 11:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D813C1F00A3A;
	Fri, 21 Aug 2026 11:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313173;
	bh=XUvMki9m/n9mnXIoNrow9G6Ne0BI+Fmg+IK7F3pcUQ0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EDtfU9WFrQJejZ4Gfa4ik8goltf/h5R3Cv0xAeeUNU896PGnHVhZq+ASga0q0tr2f
	 9g1iST2ILqLD2BavPuZogK8bgL9ae7SAWTD2ko0O9RpNQ5Sh01lyhGYJMkIvM4JE3n
	 nznmUlt0Bjnga3MosI0Rr4xMJPN74QQzAiynqu1TrY+nviimP1PIeNTi9+/+5k+xAI
	 SKfG4QM9LtgRSs4bfw6zLqSgbGX0SVZfXGVpOtjhPU66vHuRcLB0oyZVG3zaq61shw
	 wwC6dFGUDSoXwmhLSHCcfknrsvdbp7hOw/lPtYXiRAL3LeCwLPfKnsSFC0II/gpAun
	 xEazeaq185+UA==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 21 Aug 2026 13:52:07 +0200
Subject: [PATCH 6/6] selftests/coredump: test failed handshakes
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-work-coredump-filter-v1-6-91f9a73ef03e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10782; i=brauner@kernel.org;
 h=from:subject:message-id; bh=gflqvyy8GsQt6vi9g8lYVed8NcgSJKxEEcrfowOAsrE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR1WH866733mM75Q0a9H58f3zxviqyapQLLhvvJhzf+3
 vrRvD40r6OUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiB/0ZGc75X9zeWiC1yyOL
 ecNpkQeGpfsPnjYtXM/+W31zb7FLkhDDP+Nr27tnX91WJnBqvXxM7PT+bclbUj8yPGGTaJu8Pmh
 +IxcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 1062C120002
X-Stat-Signature: yj6r1jo4z86ctheij8r3x66wkg3ifpgd
X-HE-Tag: 1787313173-720353
X-HE-Meta: U2FsdGVkX192gIyE1X9sO3aH4IcrbnxPYEKaS31/Bf+JVMGcreF4CbIPvTtAcFbkdQ8TGUfzuSBZpb5rEEjnJvQLRmXhJMuTSpBLn36EA+/G8jwmo69yswiwT6gmXaVrv6BbHd108IdjmgloKUcepRxmIZO7ElNhygzy0ExdEbDG4xnn836yMJIXriBDqpGEm2UwUKpPMTltLZyoOFAL250EEQuwjnpjP2mSW2j1U6bNvQwoM2y7Ad8YyYnvc5IQwvchyijLVUeRnzdJUvJ06vIwTs1oMIU5SJ51/BjaXdq7KHux7mmCB+x8uBuhMWtByduS9vWaS2QVg9ut6P+D3hTZrKEQXlsG7pMO9UMuaNSFbs1l7i7E/IaM6SIoi+vaJb88K1ChksXVxCbg3jemM9/lLcaGwBEZqZKUwVX3NOMd/uSJ38S1Y0zRGtDMA2olH24L54e8JYrbtOGGCwG+bqt7ZfxKiUyL85DyNJ9aoLlxvMYYBfcBEhObJayTZcVCaaPhjvn/w1/MSMKN+++Ms71JOvqmHk4FLh39ucRYCfOMLXyYvjm48/YK0oAHBrMOq40/vmTexiwmZsltVkLkaTWhFjooWHxCr316zIkDT/KsRwr4WvIfvnBTUPzBlWqpOGhGYrUy6BLiHr322aFnG61g6psyaCkwX0W7rlu003w0pDQr+RRNRcplY6/V70Y3wLzi+SMgJXaRJGa55SWhtY2NdpbqwyFDINiVv/ANO70/+FFsdhdLv/N13fMTR4Uez5mD0acqb4G6mqmYXl2wCwfEp/OxFGLO+Wk1Oj9qp1Jb3MDCRXfrO3Am93ABfyvWL893nI+893aXI1uy+9YaD6CNtDO+z28OKHCrjrcCNgYmYfhvjj9aF0qkkVk4T7Ai/uk3fpNEIDi+OgPbfdiLdqQKoIBK5fKhWPcMuAVFuGBIQyxgVwKmb4uZBqdY07dpgx42UXLJq+63VExgbqF
 dtsELTI+
 Zp+2A0tModlQ/doVdlJEyhskobZLhX+MUk/icR2mZ25qFzdCVcYP67JMkrWjpX5fm2kRAIYXM+MXwmVb0anWogtYSQtsIjtlIVH0XHSJbv4bIBmcJNQATFLDOsSwBh/wST4S0++PlZr2H5p5TE9XCY1vpfFIHO31TTm3L9wzIfLUChcmKOLVTzLHzwFGN+PYbfO9V9QxkK0J74MzJsuaZq57FSUSM1XNvJGw/Oy1EdfSzxs41QE8YANpQuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add more coredump refusal tests.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 211 ++++++++++++++++++++-
 .../selftests/coredump/coredump_test_helpers.c     |  32 +++-
 .../selftests/coredump/coredump_test_helpers.h     |   1 +
 3 files changed, 238 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index 6c7327832d44..f5c9bad87546 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -510,14 +510,15 @@ TEST_F(coredump, socket_request_reject)
 
 /* An ack the kernel must refuse and how. */
 struct refused_ack {
-	/* The ack and how many bytes of it the server sends. */
+	/* The ack, and how many bytes of it the server sends before it hangs up. */
 	struct coredump_ack ack;
 	size_t bytes;
-	/* The marker the kernel answers with. */
+	/* The marker the kernel answers with, or none if @no_marker. */
 	enum coredump_mark mark;
+	bool no_marker;
 };
 
-/* Send @refused, expect the kernel to refuse it with the marker. */
+/* Send @refused, expect the kernel to refuse it and hang up. */
 static void check_refused_ack(struct __test_metadata *const _metadata,
 			      FIXTURE_DATA(coredump) *self,
 			      const struct refused_ack *refused)
@@ -577,7 +578,16 @@ static void check_refused_ack(struct __test_metadata *const _metadata,
 					     refused->bytes))
 			goto out;
 
-		if (!read_marker(fd_coredump, refused->mark))
+		/* Nothing more to say. A server that died looks the same. */
+		if (shutdown(fd_coredump, SHUT_WR))
+			goto out;
+
+		if (!refused->no_marker &&
+		    !read_marker(fd_coredump, refused->mark))
+			goto out;
+
+		/* The kernel hangs up after a refusal, marker or not. */
+		if (!read_hangup(fd_coredump))
 			goto out;
 
 		exit_code = EXIT_SUCCESS;
@@ -2409,4 +2419,197 @@ TEST_F(coredump, socket_request_negotiate_ver1)
 	check_memory_dump(_metadata, self, &choice);
 }
 
+/* An ack that picks none of KERNEL, USERSPACE and REJECT. */
+TEST_F(coredump, socket_request_no_mode)
+{
+	struct refused_ack refused = {
+		.ack = {
+			.size = sizeof(struct coredump_ack),
+			.mask = COREDUMP_WAIT,
+		},
+		.bytes = sizeof(struct coredump_ack),
+		.mark = COREDUMP_MARK_CONFLICTING,
+	};
+
+	check_refused_ack(_metadata, self, &refused);
+}
+
+/* @spare must be zero, like every field that isn't in use. */
+TEST_F(coredump, socket_request_spare)
+{
+	struct refused_ack refused = {
+		.ack = {
+			.size = sizeof(struct coredump_ack),
+			.spare = 1,
+			.mask = COREDUMP_KERNEL,
+		},
+		.bytes = sizeof(struct coredump_ack),
+		.mark = COREDUMP_MARK_UNSUPPORTED,
+	};
+
+	check_refused_ack(_metadata, self, &refused);
+}
+
+/* An ack size is a byte count. One that ends inside a field is valid. */
+#define ACK_SIZE_BETWEEN (COREDUMP_ACK_SIZE_VER0 + sizeof(__u32))
+
+/* Any size from VER0 up to what the kernel accepts works without memory types. */
+TEST_F(coredump, socket_request_ack_size_between)
+{
+	struct memory_choice choice = {
+		.task_filter = COREDUMP_MEMORY_ANON_PRIVATE |
+			       COREDUMP_MEMORY_ANON_SHARED,
+		.mask = COREDUMP_KERNEL,
+		.size_ack = ACK_SIZE_BETWEEN,
+		.shared_dumped = true,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
+/* The memory types need the whole field, not the part that happens to fit. */
+TEST_F(coredump, socket_request_memory_types_ack_size_between)
+{
+	struct refused_ack refused = {
+		.ack = {
+			.size = ACK_SIZE_BETWEEN,
+			.mask = COREDUMP_KERNEL | COREDUMP_MEMORY_TYPES,
+		},
+		.bytes = ACK_SIZE_BETWEEN,
+		.mark = COREDUMP_MARK_MINSIZE,
+	};
+
+	check_refused_ack(_metadata, self, &refused);
+}
+
+/* A server that hangs up without acking gets no marker and no coredump. */
+TEST_F(coredump, socket_request_server_hangs_up)
+{
+	struct refused_ack refused = {
+		.bytes = 0,
+		.no_marker = true,
+	};
+
+	check_refused_ack(_metadata, self, &refused);
+}
+
+/* A server that hangs up in the middle of its ack looks the same. */
+TEST_F(coredump, socket_request_ack_truncated)
+{
+	struct refused_ack refused = {
+		.ack = {
+			.size = COREDUMP_ACK_SIZE_VER0,
+			.mask = COREDUMP_KERNEL,
+		},
+		.bytes = COREDUMP_ACK_SIZE_VER0 / 2,
+		.no_marker = true,
+	};
+
+	check_refused_ack(_metadata, self, &refused);
+}
+
+/*
+ * The kernels a server built against this header can't meet here:
+ * negotiate() against their requests, no coredump involved.
+ */
+
+/* The request of a kernel with the first structs and features. */
+static const struct coredump_req req_ver0 = {
+	.size			= COREDUMP_REQ_SIZE_VER0,
+	.size_ack		= COREDUMP_ACK_SIZE_VER0,
+	.mask			= COREDUMP_KERNEL | COREDUMP_USERSPACE |
+				  COREDUMP_REJECT | COREDUMP_WAIT,
+};
+
+/* The request of this kernel. */
+static const struct coredump_req req_ver1 = {
+	.size			= COREDUMP_REQ_SIZE_VER1,
+	.size_ack		= COREDUMP_ACK_SIZE_VER1,
+	.mask			= COREDUMP_KERNEL | COREDUMP_USERSPACE |
+				  COREDUMP_REJECT | COREDUMP_WAIT |
+				  COREDUMP_RECORDS | COREDUMP_SPARSE |
+				  COREDUMP_MEMORY_TYPES,
+	.memory_types		= COREDUMP_MEMORY_ANON_PRIVATE |
+				  COREDUMP_MEMORY_ANON_SHARED,
+	.memory_types_mask	= TEST_MEMORY_ALL,
+};
+
+/* A kernel with the first structs gets the first ack and nothing newer. */
+TEST(negotiate_ver0_kernel)
+{
+	struct coredump_ack ack;
+
+	negotiate(&req_ver0, &server_build_ver1, &ack);
+	ASSERT_EQ(ack.size, COREDUMP_ACK_SIZE_VER0);
+	ASSERT_EQ(ack.mask, COREDUMP_KERNEL);
+	ASSERT_EQ(ack.memory_types, 0);
+}
+
+/* A kernel with records and sparse but the first structs: both, no types. */
+TEST(negotiate_sparse_kernel)
+{
+	struct coredump_req req = req_ver0;
+	struct coredump_ack ack;
+
+	req.mask |= COREDUMP_RECORDS | COREDUMP_SPARSE;
+	negotiate(&req, &server_build_ver1, &ack);
+	ASSERT_EQ(ack.size, COREDUMP_ACK_SIZE_VER0);
+	ASSERT_EQ(ack.mask, COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_SPARSE);
+	ASSERT_EQ(ack.memory_types, 0);
+}
+
+/* Records without sparse: sparse isn't raised on its own. */
+TEST(negotiate_records_without_sparse)
+{
+	struct coredump_req req = req_ver0;
+	struct coredump_ack ack;
+
+	req.mask |= COREDUMP_RECORDS;
+	negotiate(&req, &server_build_ver1, &ack);
+	ASSERT_EQ(ack.mask, COREDUMP_KERNEL | COREDUMP_RECORDS);
+}
+
+/*
+ * A feature whose ack field lies past what the kernel accepts can't be
+ * raised. No kernel offers the memory types without the room for them, so a
+ * request that does stands in for a feature newer than this header.
+ */
+TEST(negotiate_types_need_room)
+{
+	struct coredump_req req = req_ver0;
+	struct coredump_ack ack;
+
+	req.mask |= COREDUMP_MEMORY_TYPES;
+	negotiate(&req, &server_build_ver1, &ack);
+	ASSERT_EQ(ack.size, COREDUMP_ACK_SIZE_VER0);
+	ASSERT_EQ(ack.mask, COREDUMP_KERNEL);
+	ASSERT_EQ(ack.memory_types, 0);
+}
+
+/* This kernel: the policy applied to the task's selection. */
+TEST(negotiate_ver1_kernel)
+{
+	struct coredump_ack ack;
+
+	negotiate(&req_ver1, &server_build_ver1, &ack);
+	ASSERT_EQ(ack.size, COREDUMP_ACK_SIZE_VER1);
+	ASSERT_EQ(ack.mask, COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_SPARSE |
+			    COREDUMP_MEMORY_TYPES);
+	ASSERT_EQ(ack.memory_types, COREDUMP_MEMORY_ANON_PRIVATE |
+				     COREDUMP_MEMORY_ELF_HEADERS);
+}
+
+/* A kernel that doesn't know a type the policy adds isn't asked for it. */
+TEST(negotiate_unknown_type)
+{
+	struct coredump_req req = req_ver1;
+	struct coredump_ack ack;
+
+	req.memory_types_mask &= ~(__u64)COREDUMP_MEMORY_ELF_HEADERS;
+	negotiate(&req, &server_build_ver1, &ack);
+	ASSERT_EQ(ack.mask, COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_SPARSE |
+			    COREDUMP_MEMORY_TYPES);
+	ASSERT_EQ(ack.memory_types, COREDUMP_MEMORY_ANON_PRIVATE);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index ab94c45cd8be..4e36e3e4fb78 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -1467,6 +1467,29 @@ bool read_marker(int fd, enum coredump_mark mark)
 	return ret == mark;
 }
 
+/*
+ * The kernel hung up without sending anything more: end of stream, or a
+ * reset if it refused the ack on its peeked size and never read it.
+ */
+bool read_hangup(int fd)
+{
+	ssize_t ret;
+	char c;
+
+	ret = recv(fd, &c, sizeof(c), MSG_WAITALL);
+	if (ret == 0) {
+		fprintf(stderr, "Kernel closed the connection\n");
+		return true;
+	}
+	if (ret < 0 && errno == ECONNRESET) {
+		fprintf(stderr, "Kernel closed the connection with the ack unread\n");
+		return true;
+	}
+
+	fprintf(stderr, "%s: expected a hangup, got %zd: %m\n", __func__, ret);
+	return false;
+}
+
 /* Read the request as a server built with a @user_size byte struct does. */
 bool read_coredump_req_sized(int fd, struct coredump_req *req, size_t user_size)
 {
@@ -1593,11 +1616,16 @@ bool send_coredump_ack(int fd, const struct coredump_req *req,
 
 bool check_coredump_req(const struct coredump_req *req)
 {
-	if (req->size < COREDUMP_REQ_SIZE_VER1) {
-		fprintf(stderr, "%s: size %u below minimum %d\n",
+	if (req->size != COREDUMP_REQ_SIZE_VER1) {
+		fprintf(stderr, "%s: size %u, expected %d\n",
 			__func__, req->size, COREDUMP_REQ_SIZE_VER1);
 		return false;
 	}
+	if (req->size_ack != COREDUMP_ACK_SIZE_VER1) {
+		fprintf(stderr, "%s: size_ack %u, expected %d\n",
+			__func__, req->size_ack, COREDUMP_ACK_SIZE_VER1);
+		return false;
+	}
 	if (req->mask != TEST_REQ_MASK_ALL) {
 		fprintf(stderr, "%s: mask 0x%llx, expected 0x%llx\n",
 			__func__, (unsigned long long)req->mask,
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
index 8e0187645c93..3f2f87837558 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.h
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
@@ -64,6 +64,7 @@ bool get_pidfd_info(int fd_peer_pidfd, struct pidfd_info *info);
 /* Protocol helper function declarations */
 ssize_t recv_marker(int fd);
 bool read_marker(int fd, enum coredump_mark mark);
+bool read_hangup(int fd);
 bool read_coredump_req(int fd, struct coredump_req *req);
 bool read_coredump_req_sized(int fd, struct coredump_req *req, size_t user_size);
 bool send_coredump_ack(int fd, const struct coredump_req *req,

-- 
2.53.0


