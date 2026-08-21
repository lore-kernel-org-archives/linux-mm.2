Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04FC2C5DF91
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:52:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECEC06B00A4; Fri, 21 Aug 2026 07:52:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E580B6B00A5; Fri, 21 Aug 2026 07:52:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D470B6B00A6; Fri, 21 Aug 2026 07:52:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 989A26B00A4
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:52:51 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1683014040E
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:51 +0000 (UTC)
X-FDA: 85125114942.07.D6F1E37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4A72BC0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:52:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EWdO4SES;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787313169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tt1d/IA89t7ad2oqUEehN9UR2bac+o3dmB6BIZ/bhKY=;
	b=0lPJG7/Q9wmVQARnC9BOr6y6hrmbFWiQhmAOAMmi8HT9ZNy4ly4z3J3U+vIpb80XP0853b
	VAhaPfB33kc1oKQNe/rZeY/EqX/uTd6YUOx+Ubc1WC16hpcnntXx2vFiJfEV7xGByJ4jFA
	CVZhrXS9Nu4rMuAI7a1Mx4r4wyoRhq4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EWdO4SES;
	spf=pass (imf22.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787313169;
	b=uQCP1BiynCiztXsWtPrxsyXcYu4XFh/5WVI311dTSvLNoWMH6wieclioFvf9ljLwKyWllc
	jG+FIJxtRdzbD/pNVnVXX3VNbbK1wV2eS/RT3liDmRLP88BnOGJIa0ajrtYXMweyfjHthE
	BCr4SZxnGEXJIPD8vbhDjenNc5y8YEc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8203643B3A;
	Fri, 21 Aug 2026 11:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF961F00A3E;
	Fri, 21 Aug 2026 11:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787313168;
	bh=Tt1d/IA89t7ad2oqUEehN9UR2bac+o3dmB6BIZ/bhKY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EWdO4SES6essD0JG1zlfU8O7uNui7x3kWHGpLGElgEAwBfrVkR2ch22Par/hVXjlv
	 ukOA/Z+alv9Ub7JIA861etyGgNclPY92sdpF9y0HRZr4UbxI5H+/agR1Qh/I2o5Nwe
	 +52rDChrU3hUY11sELmlUpANullX4rvzzVNGOKazcG6jrcDk9U+PaiwVdE/VPa2QdX
	 xKggvYLQG/ZOmxrb4L3LpP5NYLpzUj2ToO6/UjStBMsnyiGo8Nhz+baQvZcVj5xwwe
	 iMftru1Tvc3HYlOV5KZQXTSUlX9mVEkeuyNjpvxSP/M0LlhNPdcL5IKc/FLuzEGbU6
	 fuNB6ZQkuHFLg==
From: Christian Brauner <brauner@kernel.org>
Date: Fri, 21 Aug 2026 13:52:06 +0200
Subject: [PATCH 5/6] selftests/coredump: improve coredump size negotiation
 tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-work-coredump-filter-v1-5-91f9a73ef03e@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=11283; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Ph9cVYPWQKviUVd2sgQm4e/YWk7Nwx52QQ2y8/kNEcs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWR1WH/KKrsk/Pjfms1KGZ+j7d4VCO1JuOscu17N9qVh/
 r/UG785O0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACayZybDf4dtyR16MaF7PTtv
 L27zULF75LDtzQcHkRq+mz8u/PjV9Y/hf/6Z/vrlycvPP+8+4OCTZFR4OjAyeWdy9uFIPYeq93o
 3WAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4A72BC0004
X-Stat-Signature: fidyxs67fqmt8d1ztyggb7zxqn9jntq1
X-Rspam-User: 
X-HE-Tag: 1787313169-698204
X-HE-Meta: U2FsdGVkX19nyyZE5HWMyInYVfWLmUsYmByzk/5a0/3lH/fE4z2ajA3IrcNNFNFrjqgy1E5i1veB5tBjGtM8b+E3Ch6/84cpie1FonYD9gTFVgQhKLlcYXlse/1WkmsjwsEoXtk/N+JFLgt0ME96fa+s86ACT11+tmLhVX2nsO1IB65e2fNxzF6zHXIArJ/2a67qA/AK/8GHNWkP36zLIIjp/e1/W+g9ywTVFryLbg+ZfoNhMdmjXKubZkErLB8L9Re5gLL4ZgPuS3V2JtW2kZf3pCwGRFh3Ch9I944pfN8OcfrreVvsVdlkhiI13vY9pEVMShu/Aw3ArPojjXB4nOzyrPLbzI2sa3O4NR7PL7W+PklQrTPNj4zjSwIbpF/OI3IN+NJsoc/33uS9SZP9TefdU4p0/DcN2p3P7i/ejN2l3RAgvpenCKyy72y1xyhNB9PmqqaZQDSENEI+DLEobjmX7Pcp5nLtiEoO7KS7BtQIbKrOuTW9QQ413duHadgZLfVwi/ThphwoQKihRThet4v5jvMlGD+Vp4ZCYjkmVYKmSCH+1GanzzLdGiquNiNhIh+bW58fUO3dYM5VpQgEQwYhevFZEBhVshNQwrI3qtNeYkHNRGxROSj4mcXIIUkHc0Wruch5S+S20Af6aMCOvu4W0n3AYZKb5uJJG30/H/FxLnronY8S+WlWaBjFFIHuIkDnDRH4adeRJ9SwhYepgQa8pbJDjQXCSLuOt8irHUNH/Hu/EKwm51+yoyIO90vA/ptgyzrXh/vN4qC/BnCRBqp1/fMGFpCx8A+B1YJQd6bIfqO8oaRQPxxxh0zm7f0n/bNVugbZ3GhMnX1V2aebobHqafzdZLjLUsp7jBeJx1reshma5gnhnCgbJeFM9dA8msaW3JTvEtHImrOAYHJfK9Jl2BmwwmDxqNWWp+JQpmCHOrMeoM1FDFRPXxUsdVR0XZHEqEM8J5dUiE+fSzS
 9FovI5mX
 Zhi1P7Tg16F0EBUj1GjNw9V4NXZsTuuX20kB1vm+zk6HpgRpOSEG6jPdzSwpr4UBFN/E5Es7J241I7VVd+Y9RoLUMWDlKvmp1Z00Qo4pGAbfziXHaQFwD2kr8AiJ5gW8Xw7XTsPLhVFDkxBaxyy1EAyYiB+nYhK78HGbdAMX4FyL090J/ewfndG8KscRLhdceWrNrJ6zhLtVeTffwVu6q/WZ8pjGQHLtv/jAy59Rn6H7RlGwDwLKSWf2DxQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Improve the size handling tests when negotiating a coredump through req
and ack.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../coredump/coredump_socket_protocol_test.c       | 158 +++++++++++++++++++--
 .../selftests/coredump/coredump_test_helpers.c     |  17 ++-
 .../selftests/coredump/coredump_test_helpers.h     |   1 +
 3 files changed, 155 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
index 6dcd6c15a565..6c7327832d44 100644
--- a/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
+++ b/tools/testing/selftests/coredump/coredump_socket_protocol_test.c
@@ -1932,11 +1932,74 @@ TEST_F(coredump, socket_request_stream_choice_large)
 	ASSERT_LT(choice.received, choice.size / 8);
 }
 
+/* What a coredump server was built with. */
+struct server_build {
+	/* sizeof(struct coredump_req) and sizeof(struct coredump_ack) back then. */
+	size_t req_size;
+	size_t ack_size;
+	/* The features it raises if the kernel offers them. */
+	__u64 wants;
+	/* Its policy: what it drops from and adds to the task's selection. */
+	__u64 drop;
+	__u64 add;
+};
+
+/* A server from when the structs were first published: kernel-written dumps. */
+static const struct server_build server_build_ver0 = {
+	.req_size	= COREDUMP_REQ_SIZE_VER0,
+	.ack_size	= COREDUMP_ACK_SIZE_VER0,
+	.wants		= COREDUMP_KERNEL,
+};
+
+/* A server built against this header: no shared memory, always the ELF headers. */
+static const struct server_build server_build_ver1 = {
+	.req_size	= sizeof(struct coredump_req),
+	.ack_size	= sizeof(struct coredump_ack),
+	.wants		= COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_SPARSE |
+			  COREDUMP_MEMORY_TYPES,
+	.drop		= COREDUMP_MEMORY_ANON_SHARED | COREDUMP_MEMORY_FILE_SHARED,
+	.add		= COREDUMP_MEMORY_ELF_HEADERS,
+};
+
+/*
+ * Build the ack the way a server does: from what the kernel offers, what
+ * this build implements, and what fits in the ack the kernel accepts.
+ * Fields the build never read are zero and never consulted.
+ */
+static void negotiate(const struct coredump_req *req,
+		      const struct server_build *build,
+		      struct coredump_ack *ack)
+{
+	__u64 offered = req->mask & build->wants;
+
+	memset(ack, 0, sizeof(*ack));
+	ack->size = build->ack_size < req->size_ack ? build->ack_size : req->size_ack;
+	/* These builds only ever have the kernel write the coredump. */
+	ack->mask = COREDUMP_KERNEL;
+
+	/* Sparse needs records, records need the kernel to write. */
+	if (offered & COREDUMP_RECORDS) {
+		ack->mask |= COREDUMP_RECORDS;
+		if (offered & COREDUMP_SPARSE)
+			ack->mask |= COREDUMP_SPARSE;
+	}
+
+	/* The memory types need an ack that carries them. */
+	if ((offered & COREDUMP_MEMORY_TYPES) && ack->size >= COREDUMP_ACK_SIZE_VER1) {
+		ack->mask |= COREDUMP_MEMORY_TYPES;
+		/* Start from the task's selection; only advertised types pass. */
+		ack->memory_types = (req->memory_types & ~build->drop) | build->add;
+		ack->memory_types &= req->memory_types_mask;
+	}
+}
+
 /* What a memory types test asks of the kernel and what it expects back. */
 struct memory_choice {
 	/* Memory types the crashing child selects, or FILTER_TASK_INHERIT. */
 	__u64 task_filter;
-	/* The ack. */
+	/* Negotiate the ack as this server build, NULL to send it as given. */
+	const struct server_build *build;
+	/* The ack, or what the negotiation must arrive at. */
 	__u64 mask;
 	__u64 memory_types;
 	size_t size_ack;
@@ -1976,6 +2039,13 @@ static void check_memory_dump(struct __test_metadata *const _metadata,
 		int fd_file = -1;
 		int exit_code = EXIT_FAILURE;
 		struct coredump_req req = {};
+		struct coredump_ack ack = {
+			.size = choice->size_ack,
+			.mask = choice->mask,
+			.memory_types = choice->memory_types,
+		};
+		/* How much of the request this server reads. */
+		size_t req_size = choice->build ? choice->build->req_size : sizeof(req);
 		__u64 task_filter;
 		ElfW(Phdr) segment;
 		ssize_t received;
@@ -2006,21 +2076,24 @@ static void check_memory_dump(struct __test_metadata *const _metadata,
 		if (fd_file < 0)
 			goto out;
 
-		if (!read_coredump_req(fd_coredump, &req))
-			goto out;
-
-		if (!check_coredump_req(&req))
+		if (!read_coredump_req_sized(fd_coredump, &req, req_size))
 			goto out;
 
-		/* The request reports the memory types the task selected. */
 		if (!peer_coredump_filter(fd_peer_pidfd, &task_filter))
 			goto out;
 
-		if (req.memory_types != task_filter) {
-			fprintf(stderr, "Request reports 0x%llx, task selected 0x%llx\n",
-				(unsigned long long)req.memory_types,
-				(unsigned long long)task_filter);
-			goto out;
+		/* A build from before the memory types never read that far. */
+		if (req_size >= COREDUMP_REQ_SIZE_VER1) {
+			if (!check_coredump_req(&req))
+				goto out;
+
+			/* The request reports the memory types the task selected. */
+			if (req.memory_types != task_filter) {
+				fprintf(stderr, "Request reports 0x%llx, task selected 0x%llx\n",
+					(unsigned long long)req.memory_types,
+					(unsigned long long)task_filter);
+				goto out;
+			}
 		}
 
 		if (choice->task_filter != FILTER_TASK_INHERIT &&
@@ -2035,15 +2108,28 @@ static void check_memory_dump(struct __test_metadata *const _metadata,
 		if (read_nointr(addr_pipe[0], &addr, sizeof(addr)) != sizeof(addr))
 			goto out;
 
-		if (!send_coredump_ack_types(fd_coredump, &req, choice->mask,
-					      choice->memory_types,
-					      choice->size_ack))
+		/* A server build negotiates its ack and must arrive at the choice. */
+		if (choice->build) {
+			negotiate(&req, choice->build, &ack);
+
+			if (ack.size != choice->size_ack || ack.mask != choice->mask ||
+			    ack.memory_types != choice->memory_types) {
+				fprintf(stderr,
+					"Negotiated %u bytes, mask 0x%llx, types 0x%llx\n",
+					ack.size, (unsigned long long)ack.mask,
+					(unsigned long long)ack.memory_types);
+				goto out;
+			}
+		}
+
+		if (!send_coredump_ack_types(fd_coredump, &req, ack.mask,
+					      ack.memory_types, ack.size))
 			goto out;
 
 		if (!read_marker(fd_coredump, COREDUMP_MARK_REQACK))
 			goto out;
 
-		if (choice->mask & COREDUMP_RECORDS)
+		if (ack.mask & COREDUMP_RECORDS)
 			received = recv_coredump_records(fd_coredump, fd_file,
 							 &size, NULL, -1);
 		else
@@ -2281,4 +2367,46 @@ TEST_F(coredump, socket_request_memory_types_without_kernel)
 	check_conflicting_ack(_metadata, self, COREDUMP_USERSPACE | COREDUMP_MEMORY_TYPES);
 }
 
+/*
+ * A server built with the first structs reads the request it knows,
+ * discards the rest and acks with the ack it knows. It raises nothing
+ * it wasn't built for and the kernel dumps what the task selected.
+ */
+TEST_F(coredump, socket_request_negotiate_ver0)
+{
+	struct memory_choice choice = {
+		.task_filter = COREDUMP_MEMORY_ANON_PRIVATE |
+			       COREDUMP_MEMORY_ANON_SHARED,
+		.build = &server_build_ver0,
+		.mask = COREDUMP_KERNEL,
+		.memory_types = 0,
+		.size_ack = COREDUMP_ACK_SIZE_VER0,
+		.shared_dumped = true,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
+/*
+ * A server built against this header takes every feature the kernel
+ * offers, drops shared memory from what the task selected and adds the
+ * ELF headers.
+ */
+TEST_F(coredump, socket_request_negotiate_ver1)
+{
+	struct memory_choice choice = {
+		.task_filter = COREDUMP_MEMORY_ANON_PRIVATE |
+			       COREDUMP_MEMORY_ANON_SHARED,
+		.build = &server_build_ver1,
+		.mask = COREDUMP_KERNEL | COREDUMP_RECORDS | COREDUMP_SPARSE |
+			COREDUMP_MEMORY_TYPES,
+		.memory_types = COREDUMP_MEMORY_ANON_PRIVATE |
+				 COREDUMP_MEMORY_ELF_HEADERS,
+		.size_ack = COREDUMP_ACK_SIZE_VER1,
+		.shared_dumped = false,
+	};
+
+	check_memory_dump(_metadata, self, &choice);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.c b/tools/testing/selftests/coredump/coredump_test_helpers.c
index 7ae0c6c458aa..ab94c45cd8be 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.c
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.c
@@ -1467,10 +1467,11 @@ bool read_marker(int fd, enum coredump_mark mark)
 	return ret == mark;
 }
 
-bool read_coredump_req(int fd, struct coredump_req *req)
+/* Read the request as a server built with a @user_size byte struct does. */
+bool read_coredump_req_sized(int fd, struct coredump_req *req, size_t user_size)
 {
 	ssize_t ret;
-	size_t field_size, user_size, known_size, kernel_size, remaining_size;
+	size_t field_size, known_size, kernel_size, remaining_size;
 
 	memset(req, 0, sizeof(*req));
 	field_size = sizeof(req->size);
@@ -1478,25 +1479,24 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	/* Peek the size of the coredump request. */
 	ret = recv(fd, req, field_size, MSG_PEEK | MSG_WAITALL);
 	if (ret != field_size) {
-		fprintf(stderr, "read_coredump_req: peek failed (got %zd, expected %zu): %m\n",
+		fprintf(stderr, "%s: peek failed (got %zd, expected %zu): %m\n", __func__,
 			ret, field_size);
 		return false;
 	}
 	kernel_size = req->size;
 
 	if (kernel_size < COREDUMP_REQ_SIZE_VER0) {
-		fprintf(stderr, "read_coredump_req: kernel_size %zu < min %d\n",
+		fprintf(stderr, "%s: kernel_size %zu < min %d\n", __func__,
 			kernel_size, COREDUMP_REQ_SIZE_VER0);
 		return false;
 	}
 	if (kernel_size >= PAGE_SIZE) {
-		fprintf(stderr, "read_coredump_req: kernel_size %zu >= PAGE_SIZE %d\n",
+		fprintf(stderr, "%s: kernel_size %zu >= PAGE_SIZE %d\n", __func__,
 			kernel_size, PAGE_SIZE);
 		return false;
 	}
 
 	/* Consume as much of the request as we know about. */
-	user_size = sizeof(struct coredump_req);
 	known_size = user_size < kernel_size ? user_size : kernel_size;
 	ret = recv(fd, req, known_size, MSG_WAITALL);
 	if (ret != known_size)
@@ -1529,6 +1529,11 @@ bool read_coredump_req(int fd, struct coredump_req *req)
 	return true;
 }
 
+bool read_coredump_req(int fd, struct coredump_req *req)
+{
+	return read_coredump_req_sized(fd, req, sizeof(*req));
+}
+
 /* Send @len bytes of @ack as they are, more than the struct if asked to. */
 bool send_coredump_ack_bytes(int fd, const struct coredump_ack *ack, size_t len)
 {
diff --git a/tools/testing/selftests/coredump/coredump_test_helpers.h b/tools/testing/selftests/coredump/coredump_test_helpers.h
index fc21b8620359..8e0187645c93 100644
--- a/tools/testing/selftests/coredump/coredump_test_helpers.h
+++ b/tools/testing/selftests/coredump/coredump_test_helpers.h
@@ -65,6 +65,7 @@ bool get_pidfd_info(int fd_peer_pidfd, struct pidfd_info *info);
 ssize_t recv_marker(int fd);
 bool read_marker(int fd, enum coredump_mark mark);
 bool read_coredump_req(int fd, struct coredump_req *req);
+bool read_coredump_req_sized(int fd, struct coredump_req *req, size_t user_size);
 bool send_coredump_ack(int fd, const struct coredump_req *req,
 		       __u64 mask, size_t size_ack);
 bool send_coredump_ack_types(int fd, const struct coredump_req *req,

-- 
2.53.0


