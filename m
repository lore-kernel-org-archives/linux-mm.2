Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89F64606A894
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 09:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gz8eoV6Y
Received: by kanga.kvack.org (Postfix)
	id 6675C6B05C2; Mon, 16 Nov 2026 04:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA1C6B05C3; Mon, 16 Nov 2026 04:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CD06B05C4; Mon, 16 Nov 2026 04:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1342E6B05C2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:45:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D6ED140862
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:22 +0000 (UTC)
X-FDA: 85440499284.21.4E228E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B583440003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:45:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gz8eoV6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794822320;
	b=aTx6HQNESRHPmGvP1H3+xOCCCo41A4HvuV1rCUw1LcNaOGt+43W/bL2IgAGxeOJDZstQqd
	pae0yOUEVmFQyM1/syFCDFSqXKYxexNt0Ms0+VA+BRQwE8+WoM6TYJmryvV6h7R75p5VPJ
	G4osGuTKORCTEkGchP6ohDpt/753Uok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794822320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/l3wrD/sWDhXRv0LQzu5/sHZR8Vsh2zvw5R7QRa76hU=;
	b=okj3Nct9ZUP39kyObKUSX+5cQGQGQg5wmzjOkgaJVhR0xKM+SdNuZ0S8HeyUBr3RwiiQos
	yv4KduIYbPeiDbArlqgQj46Mb4euJQVsTcf6DuYeWo2TWrYWJLjDENYGsSTcFNrvjrxr4W
	FqrVYUJIjCGvhpZ9Os4t/T4zJqi5Qws=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gz8eoV6Y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CF0043DD6;
	Mon, 16 Nov 2026 09:45:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0538D1F000C7;
	Mon, 16 Nov 2026 09:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794822319;
	bh=/l3wrD/sWDhXRv0LQzu5/sHZR8Vsh2zvw5R7QRa76hU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gz8eoV6Y9MAefhnBoHZMFry/jnxuQaUMcc8nIlincbrMpsWZ05ewOvSEEG0unvdHQ
	 rA8zFrAh2qG9YJ5a0JG4C2Gv0TtdpHW0pbL7WT0Fxc5d/3m//lBVFBXaC+yG7asmAQ
	 tCZjvq7dfJgf7GoxJYHdShJD/bAQWCSwwMbc2We+hHblqdMGzr7qlERASw9/MDX9fs
	 JYXK6/bfwALC1GMzii7oyTtfAhBLXHNW+T/LL+zoYxok5patcyQL45vR/8wxgOTpK3
	 CoXjeRcwcqr2nLNBYtMfXNERQRBfBDEiuHmhKctb8MVodQf+6tmACsA1o7BFJvyjei
	 YiN+2naWVh/gA==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 16 Nov 2026 10:44:10 +0100
Subject: [PATCH v2 13/13] selftests/bpf: add uprobe_multi test on overlayfs
 without data
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-work-ovl-d_real-v2-13-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
In-Reply-To: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, 
 linux-mm@kvack.org, "Christian Brauner (Amutable)" <brauner@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>
X-Mailer: b4 0.17-dev-ce4c1
X-Developer-Signature: v=1; a=openpgp-sha256; l=5597; i=brauner@kernel.org;
 h=from:subject:message-id; bh=qW+IVpAshqYKDlsPZh1xKU+cmKhqy7Nn1OmcQDblCwk=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWT9ulA7m3/RnPV77TsX3zyov+7TArE0yX0Klb35Xf/nz
 UiqXL96c0cpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEDigx/K/IKtl+/vPP0P6P
 vLN0vth+t55x46hQXuq6w6+lSmN2FZ1iZPj9KaHqUIKgnIrVEpWoVws8nj7/ltFZ/0th2WvmP8x
 +nTwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Queue-Id: B583440003
X-Rspamd-Server: rspam12
X-Stat-Signature: p594h43pjfiaqansmwydj6eeacx3edox
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794822320-626044
X-HE-Meta: U2FsdGVkX18DBQedACcc0T+nMrqYV9Gtrms4f0Avo0CWrbsxEwEROzqtJGmWotduaPicPBD5Be39HQCOd/GfQHMBnUcG2xf8Dvp80RU2um+0gtYPB9b3NNMj8GDMhtkQBi/PN9QRmsGRPp42RhBP6p60akqoQNWHvHTrqVsADOuTpLczPVA/1x14Qc6XVZJa2TafkYBVIn8tIkoMJR5qQeNLM09H7fnw2tbRFpzm5GbQXWIJBtgN69fvdAuPSg+3cX7U/YZcnSK3snAc/qmBPekmfwTDI498SOX8vlirA2HdGhTN8dDorlTEmqPtRvIIYWkSCf6qf3ma/VRl/WLkAL94EmbEb4N916msIw9w28FIfS59OZnHzXkrZ46xOflcBf44BRB3TXS9ojl/v1NJXkDkTIEQUfOuQNEenB8vhG/mabqDFVRlS2EFFf9VUuVLxMU0ixOPrxnGrJOxnViwIiSIScdDlnW/5uYtQ6W9scvkDtOjTOjot0VtTTc/S6B4R1EWcqc6B8DJrEyYWsjWXyVLdGVG+4mm98SDj9LkwoCFI6muMf623PqdtyPX+JiPjAU/4u6d/0kiZzKxQQ41VO4c7+d56KUal4nFL7vm81HVq3t3rRLSzaPraQekBArEFJZhRLpwJBFbupt6gFL455n5oHVTaQOnZkINs1SAuJ+zYBV4VH/UQjD+cO0NpKeUk2+Cd+yyoy5AE90yvUhz6jSYKBAFgK4m1e7Di1z1TZ+/bB4l5IM43XKL7Fft4i30OpHd6xavHcsusnND2SxC7+g8tlWm0vHS7IE4c0gWgKjfKBqTzJwiAoeCtX/QMILY0ErSgSxk2Q+QQPS7/cUW9Aft2flcpqiwNrvCoeBe8uRMbXK0u/Z/iE8JtmSSxJ9KUgId52TM0BOOsh6lwbkclnjwtb1JAz9q3DQCHykctLCbMUxyWgn5kFryYEbQQwfpeqluFprk5UFhPca/eZJ
 V7qNBAqB
 mJmb0P4P11Xh6VkUjD0QCHv/dDbpaIJTVgEs/hMXo2eOuiYPeYppwbpULc9C3t4kqsKJfXoV3GhMoU+8T/bhWLy5V+UA67gpMpaqUwbNhmWJVGzWWwIAdTIYc2ud4enHaCnbLNOZmnwQB5Hyx5PBdOkUe6L9r2kEcTfC/nfA+tslOdB74vhNX6oH+jjQj+suiyN5O7XaNQ4TIMtI1ABCQ7vIXw7NVJNxQBX5CCODFW056Av33I6ZoqDNCxux+87L3QZwzVV1bjjA/OjnPG+sIwftgB1Ov6XqQ2zrPC9XPdKRQsng8NmEAzzQ9Gvst1JnEVjFnGQMeC6F45EvgRa4E1WigiJwyFxJUCW/sUJ3ECuIjw3ToCe43HYTtAftyQhPxSJWl8hoa5l52msHD3CFp/BeaI9Xi5sO29zHuRKMX7SSM5KdXfkFdcpaogeqm4ADPYGnA
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

Acked-by: Alexei Starovoitov <ast@kernel.org>
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


