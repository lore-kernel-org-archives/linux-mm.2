Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91DF606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=iampxN5t
Received: by kanga.kvack.org (Postfix)
	id 05B336B05B4; Sun, 22 Nov 2026 22:45:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27106B05B5; Sun, 22 Nov 2026 22:45:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D706B05B6; Sun, 22 Nov 2026 22:45:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BFBA86B05B4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:45:49 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E3186C07E0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:45:48 +0000 (UTC)
X-FDA: 85464994776.23.28EC5D2
Received: from mta1.migadu.com (out-215.mta1.migadu.com [95.215.58.215])
	by imf15.hostedemail.com (Postfix) with ESMTP id 61087A0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:45:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iampxN5t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795405547;
	b=xuNCRc+KauyGr74M635ShEneRN54tj6/AW6/HKqfoTTKrXMZw6CL4mC3/h8A1JE00a1XaZ
	xhiD1qYTh+DloVSDW1OzKnQ42XY3a9svXZT/Jp/UdKD+xmgVHYzkeJyMnSEOnYP5WgmfKb
	ilfze1PvAgh/UPtnJmZWaKhBe8B/6W8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795405547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=htJ+G2m31J9SRlk7O48P5yvgT1ieAXPqPN86Pmytgdo=;
	b=E7h9BE7enx8vdUGwjQO8oJPSu1FgekXfm19fCOo5oLlbaqJhdF5rA2TtXsFl/dVIuHYekl
	lj/2DNr3SakN6KG3KWnZnWPjj+qEqyzniFveqBGsLrQZbGsrTHW97Qna7SVobMzZPZr4+e
	XGBEK1vM3cHMcBd4RMCkEM3tZV7lJIs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iampxN5t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.215 as permitted sender) smtp.mailfrom=xu.xin@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=AjGuHxKPho2+lTUWKKgkjdNmlALln6KLBsfucJzafsI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795405542; v=1; x=1796010342;
 b=iampxN5tRwt8Jt0+JUf7XqHmjXfTDzr9pzLiB1c91Ee+hYZQ8re+GvnFmQrA1ezYSjZjvzGv
 f+Ba+fbDbg9B/kV6vyWdS9ON5iEY8frgB1r19U36+eonmk+dbKjVbRNkfqRRKSYjSgg+jvQojDc
 k0hVpQZjwuFX5P3807OrPw7w=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 7f0750ea786c6782;
	Mon, 23 Nov 2026 03:45:26 +0000
X-Mizu-Trace-ID: 7f0750ea786c6782
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	david@kernel.org,
	donettom@linux.ibm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH v3 2/3] selftests/mm: fix false-positive and racy KSM fork test
Date: Mon, 23 Nov 2026 11:45:17 +0800
Message-Id: <20261123034517.236914-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261123034136.209410-1-xu.xin@linux.dev>
References: <20261123034136.209410-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 61087A0005
X-Stat-Signature: ek7eqhhhxcc3hzpppbupszagpfyfpj7o
X-HE-Tag: 1795405545-806166
X-HE-Meta: U2FsdGVkX1+rGPFkue702VTwFERrex+lDXJh8lAA7Wp3rgIBLKTt/F9HRuJ6+p3G3TskpfVmUf/SUkixXhyFXTWJ0dBJjAGT86Wk+n3spn0xRTQOMxXPBKKNZ0uZtxut7K5o5jVOzRGOJ6mUiQAeLEHPWfvwHi25bKzrMpLTCpCPHNf9FXRk+fOQD4u/rJw9kpf37ei+h8g5t6yd3u5qt2M3JxAklH7ETUrhr7UJ1pYd9dxbtn3gWwm6PaFMci7Uhlco++n8cEh2Ai7VHJt+07qtlRpSg1g3x50Emom0ao1xGZdlyd7nYLUu7m078TS4/LqAQJTpAGNo+RWx3DKTnPamHAEtmqFlU1S3rE4OHUAGqkXZ2KWp7lEXHxJkXDMDqHpqqEhaByA4k34OPNdXS8kiJ/hyTcZyhuZJiG+wvdpjO6qOUf4pHWrwlX8w9lpXeEpTKYgmWCSjtIeTxhhU3xj1e9SP3ivSRmzy7AlpgUHiAsJoNmNJnsd0T7AU45tE0NrIT8759cm0N5PAzZdglQTyZK7FNSY4TaYBWh0XVW91Sbrj/fR70FdbcFvo/bUt5KH20EmIwh9TIbUbiZFoutjXACDsWepS4ENKbxao7uMOsMWJp4ua52rIZsIdx5gYoZUIHo9yiY2Fzr+2ivFjkRGN1Hom2ZZv0Ak4hl7LMkGGxWid24pTDrsqhPCS6bThFqxscsOdL2PYOVoKWCpMxVnRUM0U9fsDWkPAW+Epeq5Y6pcEWOBTxbHPpIR/FSKVNv0C2s29Lk6UdDJ1DgBBh4V8kIbMRkTZSK2E4B1j/291o/JMkjjPb260Ir5uYIOSYvmpy0bdXA/Qct1vzBQuC0cp9QNYaI0g/C4F7v7vH4qgpSMRS9OHeEYae8iK4cRJnAdI86GDftjsR0SJQe0mjRmzCn/lGM+7nT+yh59SHFdJf1pD9fouhNwnQ1ATyETjBYK7MipOuDdRhgI8bBm
 C5clu9/o
 5b8z4TB/Kj0HWiTfOzMf6jC+Jj9LkD7dxgqxPsh3W0EdLr9vZse2LOFqGwX8+nUn2vUqVobuDLlxyhL1wnrlmMW18hnn6P/TvlXaDeHNRQjhYdjHoI5+dNLtzqqTE8TLn1IJmaXmbRTFEW7s04E3cFXdrxcD/lmS28iec7lxXJYEmJnnWm8hu8nsZ/G4B/r9Zc90VtQQROtZDh8CjwtfQMoBz2u8PFiMhpc6cq+SF4JfpF/UeMLnDzaco5VaE5wOPyQaJICMcF84200L20AAtYcVhG/xmdhUsj0fPKbyZjJm24myC2eFBEaA+Zud3kplC9BGfdqGGJ1Xd+Nlx+sqB//sA6fXPdUvctPycmJ1aJcnOfMyLAOqvf37nAhqzk0Ca8x7xQP1MekQuiwlRg8LlegE6mHAI1li5FxV6dKH8vLo/TRBS2zHu10IGLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, test_fork_ksm_merging_page_count() passes wrongly even if
fork() fails to reset mm->ksm_merging_pages, because the child process
calls init_global_file_handles() -> ksm_stop(), which unmerges all KSM
pages across the system before reading its counters.

Fix three issues in test_fork_ksm_merging_page_count():

- Drop init_global_file_handles() in the child process so it does not
  call ksm_stop() and mutate global KSM sysfs state (unmerging all KSM
  pages across the system) before reading its counters.

- Use '!!' in exit(!!ksm_get_self_merging_pages()) to avoid 8-bit exit
  status truncation (e.g., 512 pages on 4 KiB systems truncating to 0).

- Introduce ksm_pause() to pause ksmd (write "0" to /sys/kernel/mm/ksm/run)
  before fork(), preventing ksmd from scanning the child and incrementing
  its counter before it is read.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
---
 .../testing/selftests/mm/ksm_functional_tests.c  |  8 ++++++--
 tools/testing/selftests/mm/vm_util.c             | 16 ++++++++++++++++
 tools/testing/selftests/mm/vm_util.h             |  1 +
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 135191f99962..b871d5656688 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -668,10 +668,14 @@ static void test_fork_ksm_merging_page_count(void)
 	if (map == MAP_FAILED)
 		return;
 
+	if (ksm_pause() < 0) {
+		ksft_test_result_fail("Stop ksmd from running failed\n");
+		goto unmap;
+	}
+
 	child_pid = fork();
 	if (!child_pid) {
-		init_global_file_handles();
-		exit(ksm_get_self_merging_pages());
+		exit(!!ksm_get_self_merging_pages());
 	} else if (child_pid < 0) {
 		ksft_test_result_fail("fork() failed\n");
 		goto unmap;
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index f26f9e4bfdbe..e638475543e6 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -1080,6 +1080,22 @@ int ksm_stop(void)
 	return ret == 1 ? 0 : -EIO;
 }
 
+int ksm_pause(void)
+{
+	int ksm_fd;
+	ssize_t ret;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	ret = write(ksm_fd, "0", 1);
+	close(ksm_fd);
+	if (ret < 0)
+		return -errno;
+	return ret == 1 ? 0 : -EIO;
+}
+
 int get_hardware_corrupted_size(unsigned long *val)
 {
 	unsigned long size;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index ab1325dc6580..df16973d108a 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -168,6 +168,7 @@ int ksm_set_smart_scan(bool enable);
 int ksm_use_zero_pages(void);
 int ksm_start(void);
 int ksm_stop(void);
+int ksm_pause(void);
 int get_hardware_corrupted_size(unsigned long *val);
 int unpoison_memory(unsigned long pfn);
 
-- 
2.34.1


