Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7EFE606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=OTL6oIKM
Received: by kanga.kvack.org (Postfix)
	id 1DF486B06AF; Tue, 24 Nov 2026 08:03:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7696B06B1; Tue, 24 Nov 2026 08:03:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07E576B06B2; Tue, 24 Nov 2026 08:03:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9DB16B06AF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:03:41 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4FBAE1A0B16
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:03:40 +0000 (UTC)
X-FDA: 85470029400.07.CD76204
Received: from mta0.migadu.com (out-5.mta0.migadu.com [91.218.175.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4083010000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:03:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OTL6oIKM;
	spf=pass (imf14.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525418;
	b=O5DHDGZJKJ0fCopiz34d3vxnfXHFQTlJMECUrhI9tQHNLwdz2DIeTwqrcK9UA3h2KDu5fc
	iit6x+gCMJjm4bOvocqXjXIDS4/K41lyxMFRgR30EyPHF+cVX/Z+IEgqMviREialS4cMNl
	nVUpcXAswEO1pa0WqpatOiNSpuIYuME=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzaOSH6wDU86KLn8UnvDUyV5JshCNmIFXfq+s5ulUe8=;
	b=0YGy86VsLI3Ehgbav5xtlek6HbmPv9qHuFvgBdhGLZk/OEfUKlEmKH7ZvMIMUIUPraZFDU
	QH0SNlvOzqPiPzs0Fg92albY+aGRLD76tuv+RbdChJf9xIEnEZwMYMB2WCKwVB1DL5W0j1
	2Q5f1mO8PwuIJC8SB3KOLTXNz6Mr0FM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OTL6oIKM;
	spf=pass (imf14.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.5 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=JmTzUrRmL1kCP/GnAND4zD3C4FlayfF4aT4rwA6Hr/c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795525416; v=1; x=1796130216;
 b=OTL6oIKMuYw8CPCylKclk36Gxwv0ZZ407gdrXvZquLFl9tntlPyQeRhvw7sCtQZ8LSjZw6Qt
 xNPJZENHh9dAcBXnk/zHyqyrk8FrzCgxzphPcOIMrjAagp+yHoUyrK9EPLdVZPgWVsfKjHjWdSm
 YdUoAwHGrWtzfWRYI9LZFFKE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3fed72913207e595;
	Tue, 24 Nov 2026 13:03:36 +0000
X-Mizu-Trace-ID: 3fed72913207e595
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
Subject: [PATCH v4 2/3] selftests/mm: fix false-positive and racy KSM fork test
Date: Tue, 24 Nov 2026 21:03:27 +0800
Message-Id: <20261124130327.131410-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261124130143.128411-1-xu.xin@linux.dev>
References: <20261124130143.128411-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rxw9gpu95fn5trye9xd3d59xqx514pin
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4083010000C
X-HE-Tag: 1795525417-648340
X-HE-Meta: U2FsdGVkX18iR5aF0Va1HIwqb6n+SEay1pWkwGs8cmhSwTN7QvSW5tIK4x0wZUyyeBGLRnPeTZiKu2fdhAO9eN191H7OtBGu/etNIslr/v3OcZ1xuHS5VTRZKOvC3p8FfRYfgCcVYaUMkY5Yr1aZb/kP+SnGMfBDax0CUIKbcllvTHaLa6htJM5bfVExhT9PPMYPoIB/bSkadzo1mANbChgl9bFV5BjI3zXZrnV05dVSFt8P6iqACXtc/boEGIrKNgfbpTCNE6H1nQE+M55spToCXxHLTdEaD1OTdGRfVHgyMJLtIsMbdvk+NQ2niJlYjRIhrq5frZVd6CoTKBRO5Sfe7vlrIXETO4B22ZQWn5uEtoiinbay22bJ2tt1/cOS8m7Q/HpY57lBD+91ZTlZ3xGnx8VNs0hMWrI42sHmAz5Deo0E9WXqMTrvFbENvKyGofXk8sfedQmldVgQYCoTWlM/NTyPGRCPNMJCnKay6DR48DgK+ZuHcIj7+PPEhzyuSZasvfTDeb8Ozr/bnEgD3cSPNzrVRfQCYZBRtZDPMl7NE+NuddgeTefcxsINdD7XpPkaY25RTy6oqxTEhGVBCiOOOl2p+bqzJItv3rjEs68wLY6K4C/UdkT2muMihf9GVmh8OySNVSRbuRKmZxn10fOovtnFAbvN5/NDjIQ9qZ2ckn7DLHM6Bk4XGIeEoaIotGb9anyc4XJ/E9hMtVWdBJPpIE+rfonRy7friBqSkmBgU3DA0pxnGnvnTfLS3sUQGqVV5/JmISEzYahlIv9LaOMEdEuivm/uAp3P2zsbW4CFp0kvp3TKjNYB1ipY13uTzwZl0iGsdiBxFLZGd7qJfFrHr0EYBdI7bc9w1XIyUIYUspGSorjMKGCvD3tTGwzdCz7P2w/wW1jEhs/s8Hgy3vUkSoqyH4NkjB39avy+4LJh1zxB4CN7Og80jr8DHp2zhtnp4A73UL77bpxrs8G
 yu8KJwbv
 rsTNvStnzuAQTdo+CNwgYnDHAJ0WM5hNzlNG68rtTIN+BFJh3h1fKaVaiyQv+KbnquPr/ISUlOVQk8t71b1xb+hY8AAnO58r0k64x3Gnfz/x2mBmfDQCSs5IGMTCH654fmnTmTPEpgdu9VOXASOyqYb0ab14zSxQmGYmlxX8Ina/IywDHhu0xqZMkhbTOfMRBLEosTTNRRFsDjbGsAOe+DKorYYHkKVcAWif+1ibwj/W2Ud1CPxpiIm+C6ofKzB/F1101yvUTeLJUdK+TBgUbFUHpmnij1EpS/Q4YoTXqg+77GkhpVzDeZMrl2cua7pOcX13zZBpMsP1Bjp09BN8Nw2OJ8C4Gk0bw8nqHhCbln6iVrKJIoGWburGsxretLvtRkx81QY0R/SQbY5bTF0PJ3YBJUdknQNIoL6s+ruWoS04UAXn5/9LL+YeLrdOkgEiqcG38A+/7/n1CTN+fBfWdmjdIng==
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
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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


