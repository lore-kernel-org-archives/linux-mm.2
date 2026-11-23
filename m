Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E54F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PAENAZh1
Received: by kanga.kvack.org (Postfix)
	id 5844A6B05B0; Sun, 22 Nov 2026 22:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 535216B05B1; Sun, 22 Nov 2026 22:42:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424BE6B05B2; Sun, 22 Nov 2026 22:42:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2336B05B0
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:42:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CF14A8427
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:42:01 +0000 (UTC)
X-FDA: 85464985242.24.7AB246A
Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf28.hostedemail.com (Postfix) with ESMTP id 96ACDC0003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:41:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PAENAZh1;
	spf=pass (imf28.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795405320;
	b=umkWEJBIQcKzzqfa7t8iyPa+AJx5p9lbroLU2rPI6RN4yV8m8BPoIKABtW5acJSHCsK4E8
	q3PVqUzC4HxJBTCz3hHhn8V+J7OC6Fy0Lj1ZvkWKwF9P7lV4HY8Q30ibYiXbRejm7tFdXd
	sqLDmgKiuf1OM8qPtXktFHsuz5CkSbA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795405320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Dh1feaCWNPCzI3ZTC+VWOZAtNmxgTq2L6B7MJWElwiw=;
	b=ZrIlx730xeVbeJNMseBI+ijVPlnr30s4rhw9mPjaoj7DL34cOjauHk0KncpxP6sD1MAQVK
	5j1uIYyqe03FuYHmSRiUnl8ofFCRP/DS3croiRNOIvdbhKWPW6SGnJdch/u2YYByqvHOxw
	Q0Rz/LLxyJe5ahqTwoVMzp6ez4LPjOU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PAENAZh1;
	spf=pass (imf28.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LbvXmZsFJJ0KApBfSklAegm2ypvSM8utExD74OIXo2Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795405318; v=1; x=1796010118;
 b=PAENAZh1oW50MKFjN2afLxN09iQJ7rfA2bIMFqhREF3fF8KSiXX/OfGuKQIjs2xecS7btDS+
 A2acdpl/nw+5cQ25spfRBpTjobxCjsXKmaHhPSfXID9iBbw5wqF236pX2gd/QJ0n7662FdmgCLI
 AGIYlkdb5LCjlbtpuLDcAWNE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8d10001b3924a972;
	Mon, 23 Nov 2026 03:41:57 +0000
X-Mizu-Trace-ID: 8d10001b3924a972
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: David Hildenbrand <david@kernel.org>
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	xu.xin@linux.dev,
	linux-kernel@vger.kernel.org,
	donettom@linux.ibm.com
Subject: [PATCH v3 0/3] mm/ksm: fix ksm_zero_pages accounting on fork
Date: Mon, 23 Nov 2026 11:41:36 +0800
Message-Id: <20261123034136.209410-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 96ACDC0003
X-Stat-Signature: 1aoek1p5t71k6fut8co19rkz3rjjkjpg
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795405319-960901
X-HE-Meta: U2FsdGVkX19SKR2BiRUoQtPEy+z40ICeqLZwCdzRQhHQQwjBWQev+5+g/x5oalH1IZWmKgtHOohk2UvfiL07VrKsjDcDL0U3WuKV+RCkLIu923MkYsSWwZS5PFs3tyPdSa+Ef1kSvVoBORxeK4J13mwcpjDocegbOVDPnJeZEB1jPkq8HYsw+/6c361iXU2wPRVXSDShFlv33i6lZGTfFr9FZ75LM4ZwJagzRm78SOCJMRRjHaga8xDLMMEpaPtsPOOU26wLHB/hs0uwEYn/3+U45sh4ji5WMGDF/pDMUbm+NkWsTFUPsgca3OtdiIHEmoGJw/hj25mF3oBFq0WE/7SrK41Z8OhpzrpH0UlGW9DF2Xg4cWd98x3sttmwwRVgXupDj/yRAukjXtD8pY53L9C09sXrLRdjcIbFPA4m+sUwgUOpNAwE+hBFnnhHLwqQKQzdfROwPemKkAWWKc81Bfo0FAKVOuGaZLh32gYjb40J8QVDzGzZ9qkXqrnLNXvMGdNaAMB1csFVItGvUDOTcGelMsd6oEc4r6ylrdHEapVEEVlaJXi3gRub6bc+AVuRbUX1NtRwfjgbDjLm2Rl4Wovi/B65R7mlXyPuOxUb0ZpW9j+u8wUuAKo/KXX6FD26AIH+Z4+M33V10V60z/v1pVjxWeMf7wdQZR+qXByNvrY9BO26YSwMQ2HnyBoTjq+5N4ns5gd71AkrYkUCPUbXZ0aZkkDFz5gtf+ZSvMa9gabXmwnPAJaEkv06IqKlJ9hLzme4WhUPSWFjnaXuMPqBU178zibCwFK5uPq/yNB9bOMrCYxge843EUm2Zyl694YxaysPPFZJZlGKj2Gha9GQ8M4TQU5Vtdd9zsf5EpcAIYCc2Lw0OE9Mt94QUbep83OCgcEzZwG7JuL01PCoUM0NNxS6oSo2ZqdiRJupZQLyvFBcmsWlihZS1FGTPI97sFpCgtOqRkCU7HCrOyY2UhE
 TQOpYO76
 Rf4l7Q5v4gRwOMFFrIqWVhNbQJvm1Z1ObzfHVMEOsNJdTFFGUpiMBUC0s/ymmZz0/YYRrhSXnNZ/No4BTP3rOaBq27TV+NbgQX46c0R2Bv6zRVEo7wMuHgUBXlVYUAXlNIpLA2CWoRbNgA2X9oJHN7lf+kdcUx4UZggmSKLveouJREBx9a8xEqHiKB8D63GjAhNlqt9coTO1JtUivo9L7NzuxAu+DQuG/O99Lrad8fU3P9kJpbgU1eUXalheRMQyMGwgVVIku8bke2SR7F2PiGcH2naJhw6qLirR4WlRIWqBuc1PbHHUdNYQxzmdpOtY+A+UNw4bABjlfOGLSwzt9w1Ts2UcJfM8OnH0c87S1mHOg6ZR7sLCvIgp5sRG0gXG9v+aA3ZVAYONhGMvISup4snewACX8/O59QQKNQjNpzgee8wRtybF1hckFrSahrBqaRb/a27aCoPWnbfqAVdUB0+Ig/wKzYBkkrp1sbzEh8jszfrE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, fork() wrongly inherits the parent's ksm_zero_pages counter
and keeps the KSM dirty-bit marker on zero-page PTEs, inflating both the
child's per-mm counter and the global ksm_zero_pages counter.

Patch 1 fixes this by resetting the child's mm->ksm_zero_pages to 0 in
ksm_fork() and clearing the KSM zero-page marker when copying present
PTEs, and documents the behavior.

Patch 2 fixes false-positive and racy bugs in the existing KSM fork
selftest by dropping init_global_file_handles() in the child, avoiding
8-bit exit status truncation, and pausing ksmd before fork().

Patch 3 extends the selftest to verify that neither ksm_merging_pages
nor ksm_zero_pages is inherited across fork().

---
Changes in v3:
- Rename might_clear_ksm_zero_pte() to ksm_fork_pte() and refactor the
  PTE marker check and comments (David Hildenbrand).

- Add Tested-by tag from Karl Mehltretter to patch 1/3.

- Refine exit status handling and add ksm_pause() in patch 2/3 and patch
  3/3 to prevent races and 8-bit truncation (Sashiko AI).

Changes in v2:
- Encapsulate zero-page PTE marker clearing into a dedicated helper and document ksm_zero_pages fork behavior (David).
- Fix compilation error for !CONFIG_KSM and address initial KSM fork selftest bug fixes.

Xu Xin (vivo) (3):
  mm/ksm: do not inherit ksm_zero_pages counter or PTE markers on fork
  selftests/mm: fix false-positive and racy KSM fork test
  selftests/mm: verify ksm_zero_pages is not inherited on fork

 Documentation/admin-guide/mm/ksm.rst          |  7 ++-
 include/linux/ksm.h                           | 22 +++++++--
 mm/memory.c                                   |  5 +-
 .../selftests/mm/ksm_functional_tests.c       | 48 +++++++++++++++----
 tools/testing/selftests/mm/vm_util.c          | 16 +++++++
 tools/testing/selftests/mm/vm_util.h          |  1 +
 6 files changed, 85 insertions(+), 14 deletions(-)

-- 
2.34.1


