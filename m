Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3694C606A33B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 14:03:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=loi3I3vF
Received: by kanga.kvack.org (Postfix)
	id 586DE6B05C0; Sun, 15 Nov 2026 09:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510AB6B05C1; Sun, 15 Nov 2026 09:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364846B05C2; Sun, 15 Nov 2026 09:02:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F30E26B05C0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 09:02:54 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6816C1406FE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:54 +0000 (UTC)
X-FDA: 85437519468.13.BE18801
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B0EBF1C0014
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 14:02:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=loi3I3vF;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794751372;
	b=Zw/DKL1+yG7sPa1lG6TewJzVtOsc28kMnpDruGyomtfHWvcPPua1B1jj1xAD5vLULb2APr
	Uo3dxj7NVWO4sf53mqIQsiU64INuIweUdLfgtS+B1kzH1GpLCUzhTaCPu7NdeQsaIrUN0R
	zrsG5ebzQX7+RFOyaLvcGlkANvUEPkM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=loi3I3vF;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794751372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yN6Rkl1L43xto0GNjrkTF/h2UW8ZoyBlI4+dV6PL+Zk=;
	b=2xyaKsX0yhxbpQ/H3w4hHmNqEql/3IJSQmW1U4s9J+H/MLjUb8kQ0j4vsW1WepEPyynRcr
	zHhZkmL+aDNKpGKI4CSUcZMXje9B0oudUg03ZOGCOrkBBsvghaunRj92g49a6GzXUwO2m9
	7AhAboQJ/TAkwd//661427K+sSTxXl0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 519CE61341;
	Sun, 15 Nov 2026 14:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F81F000D0;
	Sun, 15 Nov 2026 14:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794751372;
	bh=yN6Rkl1L43xto0GNjrkTF/h2UW8ZoyBlI4+dV6PL+Zk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=loi3I3vFq+MyTChzl8YT0jBGhMXooxkatMOHR86+J+u++wcuW7IIzsnDM3JjhuP0R
	 EwHZUaxyqnPmAQ8fVGccDau0JxuuXn1NIvb8aeUlLf8GALcRJadoYipeGyJC768sT+
	 r+n94ZI/eou3KAW12cBOezTA4fMdBkNF29M24p56GarMJvaSKjv3tJz1PEJJUbEx6L
	 QM4XEnIh6veBo2MPetAikOA5Jko9ugwSblmYiFPM8wCcVpk+pSAuQ1Q0a9IV516ifU
	 jdtlk2fw2YHQMB3ZprPsJ63AUAlbKK21hmI8gUY7Nk5kqARKErvDe4EmFxP0Y8JAC2
	 Ga6XCuraqzT0g==
From: Christian Brauner <brauner@kernel.org>
Date: Sun, 15 Nov 2026 15:01:43 +0100
Subject: [PATCH 13/13] selftests/bpf: add uprobe_multi test on overlayfs
 without data
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-work-ovl-d_real-v1-13-ca155efbcb2e@kernel.org>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5550; i=brauner@kernel.org;
 h=from:subject:message-id; bh=s/2BR6vApkMwUflb/E75PK0IMgv+kNCBTrkxznLRTiM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT93B3HtVQj9M+7kF7d2o8Wv34t5J/z5q2u4bWgrefVJ
 v1UzYz81FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR218Y/pelXXPurtlcsa0l
 u2tR1xMmvjQNNoaFvZUPNFkW3s6dsZXhf8LC/R77J0dVLGKdPetqkeyeX3wCL2feWvcnrW5TjHn
 cSTYA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B0EBF1C0014
X-Stat-Signature: k8ku5bynk8xafoe3aqgxmcwriadhp8pa
X-Rspam-User: 
X-HE-Tag: 1794751372-742154
X-HE-Meta: U2FsdGVkX1+7Cesf/pvry6mEe+t3M29C0qi3i1Y/M5YW0akc92lxeAzBsA93v+UNlM5onub6a3OfaKnWcw0exc5xE/IBdbOgfaB/GA7/TErxJz7mWpYdJTnmb//ffB7zKFjglSw/Q+5zXTFVrzOLz/YbiqkE5oFxtW2W9JyLZt73YKIWraQPlmu5WyGZlW8B71x/0EOBu8wisCe5t36W9Fw9wPeDwDEQhAwaSApiJjqWKdfPXZi7LG0pg8zGfeGwi5mG/g42m6X9RgLK5hf+e9f6qxJuLtrDcWlKLokb9Z03fK5bxmG9XsrB7nDeQ2KOZHbDAnZyXz2hh9dyhu2TkvI7BYGUQRmDauOxNME9jtROK9t/2d9fRQ9EoQczKNB41TtzWWW3vHwW8w/9Rwpph4LiY4atAi7Yh7BDRQ5CcN4GChQalKbWpIS0IvEZh32KQxGBI4fenk1fj4IrdkRAHm1aNtgqh1u1SudOywvXzlk16fLnlCPvmjIMH/bMEG2CGlx563z9L3ZP9tKbSkrrET43gmWGDEKbyCifNlt8rkBT89EIAppgtzdmbKlpm9OEpfWLHE3dgwPx7n1skj8QnDb0CfoZNQwX71WJuW1LYm1A/V4W2pSRuc2PdtD9Wmoh6wTD9wqQPcJ9YsmmiBZR/w9R+CoQigSa++9oLRnhItv3QN24rYzcePPXTayZELIgnC1Rua7w0Lz7tX+DW0K/4Jg88XjdghWPxNpei8/SLU2UmBYayxUH6LeMQjJb9Tk2Vi1iW9tq92HWUQ3exTEiyELYB9ayFyDPRgLJfahp6efALofjyFfHPZ5mexEvJHMzaRdKhGLee72t4+dvINeRWfIBjuYi+tDMCBOL3pHqNS1yiW5bphImL06SylXzT989z09UNC9YEaSxbDyZqG7SY9pthgYRgiaNJtQuFxOmTyL5fIRxujSp5fB74nDBXr92qMR9xi0QaFQBtc9H2jV
 4EFLDd7R
 6UscG5yjZpt5OT+URiqrm7HumsK3DCMbM2HmXVb5k0sElXjAj4kUVfy4wBKhQ6I9A+8cfMOMxkoMSBtUb3roAyrw2FTmNSVv44VS+vx9xaY6V5XyB+nKQ7Xn4/HaD0n6r8VHCHqqZ65qTJx6eaxc59zp6EpUdbbDmsLF1KYnJj4cgVV9Wm5DXlgKNmi/FlQr/mAAFxKnK6MtBjpI6Onx6nCZO3C6V3BD6kt/f9JeUTBr7JHOOpb85+6mTJUlhk69dnrsE1QfLWyj3IT9QuBgSgDNwoI3iggbRFhoM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a uprobe_multi test that attaches to a metacopy file on overlayfs
whose redirect into a data-only layer points at nothing:

- the overlayfs is set up in a child in its own mount namespace

- BPF_LINK_CREATE must fail with ENOENT from the lazy lowerdata lookup

- skip if overlayfs with data-only layers isn't available

Before d_real() could fail this got an EIO from uprobe_register().

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/bpf/prog_tests/uprobe_multi_test.c   | 141 +++++++++++++++++++++
 1 file changed, 141 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
index 7fbcfddc3cc36..907d8c6d5ec93 100644
--- a/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/uprobe_multi_test.c
@@ -3,6 +3,10 @@
 #include <unistd.h>
 #include <pthread.h>
 #include <fcntl.h>
+#include <sched.h>
+#include <sys/mount.h>
+#include <sys/stat.h>
+#include <sys/xattr.h>
 #include <test_progs.h>
 #include "uprobe_multi.skel.h"
 #include "uprobe_multi_bench.skel.h"
@@ -575,6 +579,141 @@ static void test_attach_api_fails(void)
 	uprobe_multi__destroy(skel);
 }
 
+enum ovl_no_data_stage {
+	OVL_NO_DATA_SETUP,
+	OVL_NO_DATA_MOUNT,
+	OVL_NO_DATA_ATTACH,
+};
+
+struct ovl_no_data_result {
+	enum ovl_no_data_stage stage;
+	int err;
+};
+
+/*
+ * Runs in a child in its own mount namespace. Create an overlayfs with a
+ * metacopy file whose redirect into a data-only layer points at nothing
+ * and try to attach to it.
+ */
+static void ovl_no_data_child(int prog_fd, const char *dir, int wfd)
+{
+	struct ovl_no_data_result res = { .stage = OVL_NO_DATA_SETUP };
+	LIBBPF_OPTS(bpf_link_create_opts, opts);
+	char path[PATH_MAX], data[PATH_MAX * 2 + 32];
+	unsigned long offset = 0;
+	int fd;
+
+	if (unshare(CLONE_NEWNS) ||
+	    mount(NULL, "/", NULL, MS_REC | MS_PRIVATE, NULL) ||
+	    mount("tmpfs", dir, "tmpfs", 0, NULL))
+		goto out_errno;
+
+	snprintf(path, sizeof(path), "%s/lower", dir);
+	if (mkdir(path, 0755))
+		goto out_errno;
+	snprintf(path, sizeof(path), "%s/data", dir);
+	if (mkdir(path, 0755))
+		goto out_errno;
+	snprintf(path, sizeof(path), "%s/merged", dir);
+	if (mkdir(path, 0755))
+		goto out_errno;
+
+	snprintf(path, sizeof(path), "%s/lower/f", dir);
+	fd = open(path, O_CREAT | O_WRONLY, 0755);
+	if (fd < 0)
+		goto out_errno;
+	close(fd);
+	if (setxattr(path, "trusted.overlay.metacopy", "", 0, 0) ||
+	    setxattr(path, "trusted.overlay.redirect", "/missing",
+		     strlen("/missing"), 0))
+		goto out_errno;
+
+	res.stage = OVL_NO_DATA_MOUNT;
+	snprintf(data, sizeof(data), "lowerdir=%s/lower::%s/data", dir, dir);
+	snprintf(path, sizeof(path), "%s/merged", dir);
+	if (mount("overlay", path, "overlay", 0, data))
+		goto out_errno;
+
+	res.stage = OVL_NO_DATA_ATTACH;
+	snprintf(path, sizeof(path), "%s/merged/f", dir);
+	opts.uprobe_multi.path = path;
+	opts.uprobe_multi.offsets = &offset;
+	opts.uprobe_multi.cnt = 1;
+	res.err = bpf_link_create(prog_fd, 0, BPF_TRACE_UPROBE_MULTI, &opts);
+	if (res.err >= 0)
+		close(res.err);
+	goto out;
+
+out_errno:
+	res.err = -errno;
+out:
+	if (write(wfd, &res, sizeof(res)) != sizeof(res))
+		_exit(1);
+	_exit(0);
+}
+
+/*
+ * The data of a metacopy file in an overlayfs data-only layer is looked up
+ * lazily. If it can't be found attaching must fail with the error from the
+ * lookup.
+ */
+static void test_attach_api_fails_ovl_no_data(void)
+{
+	struct ovl_no_data_result res = {};
+	char dir[] = "/tmp/uprobe_multi_ovl.XXXXXX";
+	struct uprobe_multi *skel = NULL;
+	int pipefd[2] = { -1, -1 };
+	int status, prog_fd;
+	ssize_t n;
+	pid_t pid;
+
+	skel = uprobe_multi__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "uprobe_multi__open_and_load"))
+		return;
+	prog_fd = bpf_program__fd(skel->progs.uprobe_extra);
+
+	if (!ASSERT_OK_PTR(mkdtemp(dir), "mkdtemp"))
+		goto cleanup;
+	if (!ASSERT_OK(pipe(pipefd), "pipe"))
+		goto cleanup_dir;
+
+	pid = fork();
+	if (!ASSERT_GE(pid, 0, "fork"))
+		goto cleanup_pipe;
+	if (pid == 0) {
+		close(pipefd[0]);
+		ovl_no_data_child(prog_fd, dir, pipefd[1]);
+	}
+
+	close(pipefd[1]);
+	pipefd[1] = -1;
+	n = read(pipefd[0], &res, sizeof(res));
+	if (!ASSERT_EQ(waitpid(pid, &status, 0), pid, "waitpid"))
+		goto cleanup_pipe;
+	if (!ASSERT_EQ(n, sizeof(res), "read result"))
+		goto cleanup_pipe;
+
+	if (res.stage == OVL_NO_DATA_MOUNT) {
+		printf("%s:SKIP: overlayfs with data-only layers not available (%d)\n",
+		       __func__, res.err);
+		test__skip();
+		goto cleanup_pipe;
+	}
+	if (!ASSERT_EQ(res.stage, OVL_NO_DATA_ATTACH, "setup"))
+		goto cleanup_pipe;
+	ASSERT_EQ(res.err, -ENOENT, "link_create");
+
+cleanup_pipe:
+	if (pipefd[0] >= 0)
+		close(pipefd[0]);
+	if (pipefd[1] >= 0)
+		close(pipefd[1]);
+cleanup_dir:
+	rmdir(dir);
+cleanup:
+	uprobe_multi__destroy(skel);
+}
+
 #ifdef __x86_64__
 noinline void uprobe_multi_error_func(void)
 {
@@ -1452,6 +1591,8 @@ void test_uprobe_multi_test(void)
 		test_bench_attach_usdt();
 	if (test__start_subtest("attach_api_fails"))
 		test_attach_api_fails();
+	if (test__start_subtest("attach_api_fails_ovl_no_data"))
+		test_attach_api_fails_ovl_no_data();
 	if (test__start_subtest("attach_uprobe_fails"))
 		test_attach_uprobe_fails();
 	if (test__start_subtest("consumers"))

-- 
2.53.0


