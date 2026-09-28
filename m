Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6907ECA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC7C6B009D; Mon, 28 Sep 2026 07:11:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8596B009E; Mon, 28 Sep 2026 07:11:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA5A6B009F; Mon, 28 Sep 2026 07:11:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26E4C6B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:11:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0BA3A010A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:11:04 +0000 (UTC)
X-FDA: 85262904048.12.9123AA7
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf01.hostedemail.com (Postfix) with ESMTP id EDB7540004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:11:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SP1cdk+m;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Gr6RdF6V1I6p9W/aP+8aNb8DjQUp/6U5Pbv2mZN+P3w=;
	b=kPIwbGKgXqEkyDB0hYQMa0sc+Qu+x0Jd5XW2bPvqCmU4C/AsnBZ8DhXrkzjmQ6IfUMjs3Z
	BZY2ZD9sYGRZAqcIRvuWs5782UbUTzRdlsvRIHVWv9FeZ4TI/dNzd9fwMmQjjYSj7BWE4W
	BNNHu693qB2m2Z/zoHoNE/JKokFh+Io=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=SP1cdk+m;
	spf=pass (imf01.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=azpijr@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593862;
	b=bK3pDBl0ZBi30cM8XnhG6h6iXfNXjvmGt6IJjoAY/1LUVGwV9WnHwa++WVgTRaizY0WbOP
	/Tqj2yvFblxIwOLxyuq0/gJ1/IaopZbi8gaJi4dccneUjOLMJkXk1gyHxMsMl+AUItpMAz
	lYkFYRRdKLeOp3K0BozLYlYlfFx3wrY=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-486e1a044c5so2434425f8f.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790593862; x=1791198662; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gr6RdF6V1I6p9W/aP+8aNb8DjQUp/6U5Pbv2mZN+P3w=;
        b=SP1cdk+mE2fknvmOWiRhPeC2th1skcpTi19VYjHShYWC5uQ//VD3lt2ZUprz6L9HXQ
         WB4Rhno4JXXw77WYdannm5hvJN9WR/avgByheR2Y1jicbIi28lfvTSHaS8RO9I/IfLay
         oYQQTs+PDqhiZynKkVBwAIp5C+YL1kpApOT4Gz6PGB8wUFf4oIJ6sIjxVNRmcKC7hkkZ
         jNs5pTFWIzGthS+0+WpHcIcWTbJCeuXVQnYcr7/QldR9QUXz71gev4HtAWSC4DDnxoUG
         m2Kik1lRgdnb9wMuhX3evjUF6FApMPr87zkV/PzwOCIijFiTunn10z+kYb3a43FGzmzd
         hSbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790593862; x=1791198662;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gr6RdF6V1I6p9W/aP+8aNb8DjQUp/6U5Pbv2mZN+P3w=;
        b=qa0gEffW8QLcIk0OVmKZZKZvhfr0klSEtFW5VEfTEbRAcesAqwXgm8tMaGpvR4AUmB
         jSLxRJkS9yFvqchfPZkSHtXcI9xfHKRwr2k8WILqFpB5CLECEiLQvVSCAvHBaVOrGfqY
         GMmOeE80nNH6deCsTC71ex5MMuG+9uCpXHJolQqXHt/WFSphENz4aiVfVxGhx3zT5N6l
         FFpaqe6c3thFos1tLJ7nExY5B5/UIYp2PaPpYkjnvMOC87CMgNU7l1gFlSmr3go5bRS7
         uOHAlJy9/yS+xCWavwjhhyJKQicehl620sALCpjRkVNQ7QnFmt5n/c6T27se2WvDnBv/
         7DNw==
X-Forwarded-Encrypted: i=1; AKwUvByFyhcc4MJa0Q6lyiBttrQJgMc4h72Z4PpsnVF3cRAjcDR3WLRjb8hyZ4wOXdRuwZoT/WXpxhnq2Q==@kvack.org
X-Gm-Message-State: AFq9FYIOGIKG7lhCLacqYiXhYs7eWBTGVuEtQLKyB19TXJx4i7nddUMi
	JcuCCzGsK6MxakAPTb1gwDbnRQ8qK2r7g6xHn1cC+HvxXvsubMkVh4qs
X-Gm-Gg: AYBFou3BDsYM9aqv2xmr/0KUdilb8nUGeDWGMp6GzDEZkRYIK1O6gRZ261rTjOX5T50
	6FokKD78vrLPKVG+Nf9f+gPUIwHs+fV8b6B8RIT7E69b/vjiyS0jNLUshaDupKAXoXwqrpbIlHk
	Vu8qqz/rOJ6i0YOJSGAl5ft/tQKbk38YIULgl9eisCK87vTP/lEdfImk2iQle2fCJux7+9lxkCq
	BVN7FxDQV/7Pq1xjdmmqU70bjeY4VZfi0gS2Blg1P490FOUtV8hD/rNtgqJu7gJQCB9Ew4ucD5a
	cTanLGhWpwlONfe+hF0WHtWKQrdeR7yw0xb30nXWovV3diQrSm+C03JkumIka1RdNuVzZ7uf/b5
	vBnP8gcBSKsX4RKjgve4SCfYmQ6nPhDzMJTPSk71bXquatWo6ygM7mFG/VPUVgtJS1St3W6Ognf
	X8ew++37c2031tZe+15jSl/1ckvv2y34bxlvWs8SIJ+43UX2PTAe0D+ZI=
X-Received: by 2002:a05:6000:2204:b0:487:2387:7c9 with SMTP id ffacd0b85a97d-488717202f9mr23496795f8f.14.1790593861393;
        Mon, 28 Sep 2026 04:11:01 -0700 (PDT)
Received: from nobara ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4887a64ed6esm29371081f8f.29.2026.09.28.04.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 04:11:00 -0700 (PDT)
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Cc: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: check MREMAP_DONTUNMAP mlock accounting
Date: Mon, 28 Sep 2026 13:10:42 +0200
Message-ID: <20260928111055.482136-1-azpijr@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EDB7540004
X-Rspam-User: 
X-Stat-Signature: 5mfpk6ej7ang7oy4kshkcms1wbt6qa6c
X-HE-Tag: 1790593862-765236
X-HE-Meta: U2FsdGVkX19MvV/hCdx7SOFYJW0drRgXqX40IIP91rWxHzoLrnFQgMG3y3M4k1NS5vQSU0kTG53cxN2bcfQ/LXBm7lSsHRy4QqUqS+GcJO7Rsy/z5XEtrH+3+BVGdhEXtDNhtRZCzmwmJveQsBalxI/vcWPYR4Ez2z+tupi9tRCbOWWeGUGaaM0MRykkbTfYh6pZyAmQFOcrzGFvvs7C6+MXZltMBwjxy//Qv2iGnq3JtCKpeS4StrmfkJB6JvwTd3Ck79mXD0xOZsMT12xrGsLsaFf+9TPX5MGCLPI/5CPSE2fY/RUZdzhWAdVHHyiOSZWfLrjsfdF4uKkjW/5WvkEQN2mEnqe2sEY0qJ10I8TvUzq5pH1AC8sBFrNDSfyuRXV2VL72L1zLjHdegLVjOTOiLnUT38eXcM2FRZSKfNP5Kdyh4+3XNkQccM3ajXSptiIbCuJtnrfKSVwy8kD+Zyp6VbJCQiT1VYXDLJoJww1iHFOcj7naIisLVyGgUa4JC6JP1ejsfzXAxdWVKAjRKAVj360VOwEbwMIN/BNjfGJJimu50suISWY5JiJfsW1+O+stGufTbcmCBEYMZnnzm8IG0rqlOq3eEyjRxSfH8oD27j/cxPdjaYYtasleCsy/LpfdCQA6qPZL8pVnqQmb0T+aqck2s23Iyf0uziKH0LdGehTIczH5WLFF0ENpOmRbvrH3tCAwlTx9CyBp8QPLkoSRdIrFfR7Y/ES2yMopYKLZpbictFdeLe00UpfXlhnUrD7YJ6cnt3FAfkvCJrT/Qq23ZUDcwnpm6a41mGTTuqE18SC1myI2LeLg5yn5sEqdpcSViwqOeGtWwKxeMZuL4YmpPHgFbWUh/4YuFcL9vh3c+rmy03bEBB/jcnkQMrMSPoamsipCv5bOvnbh/+ZY3/DnPF9lPyZRThtOwIxZemR+NqdT0j9UtbZ74Svx+hNfcZVT2VRZVofuJLllxjZ
 qa2RVADk
 AkSXGZH3jytBHSzjgJzCbQb/tB+OC/YWzThbWxfthE+4vH4ZONb7L5QlZ2Q6+aDSlLoyF1mjlPnnK3KQU3JV6SzBD/+NeftCeBBXK3NQDKeuNdvtR9hdkVKl6F+DFbUr8rukrvI4OA4AKZogJk3tHlEW/9h7kYxV+bEEytXkSHjxndFSpXS2+AdYhkW92Nwai21zhzhams9wQhlQOjBUIHZ+Z6lvF1/tgMyfklp560M69682Mb0eE8p0dIM4fANM9wjjoyY+venWYPAcZgSdQpITDOE8gjKFfnnjDNHd4DZ3bZeFLqhLteF9RkmnpyI5dSTWFrQN8XRq/O9p5FD8nQ+85A+y0HqTPyqjcMdx0hHuxDlpQsviQzsQsF3Zr5LTMysV1DjUMJHUiVGyc99/gf43QYJpbkDsyKIdKjUgPpQF/gvZLhwXY+rB2hJTwbUxIdO6/ELvlHyzwn1Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

MREMAP_DONTUNMAP keeps the source VMA in place, but clears its mlock flags
for the whole VMA while setting them on the destination VMA.  Two cases
leak mm->locked_vm as a result:

 - an unfaulted mlock-on-fault VMA moved behind itself self-merges, so the
   single resulting VMA loses the flags without the accounting being
   dropped;

 - a partial mremap() moves only part of the range, leaving the pages which
   are not moved accounted as locked in a VMA whose flags were cleared.

Add three cases to the MREMAP_DONTUNMAP selftest which mlock() the source
VMA, with and without MLOCK_ONFAULT, perform the operation and check that
VmLck comes back to zero once everything is unmapped.  Each case runs in
its own process, so it starts from a clean mm with VmLck at zero and a
failure cannot propagate to the cases which follow.

Verified on x86_64: the three cases fail on v7.3-rc5 and pass on
mm-unstable with the fixes from the "mm/mremap: fix two issues with
MREMAP_DONTUNMAP" series applied.

Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
---
 tools/testing/selftests/mm/mremap_dontunmap.c | 273 +++++++++++++++++-
 1 file changed, 272 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/mremap_dontunmap.c b/tools/testing/selftests/mm/mremap_dontunmap.c
index 96ba537facf7..2ec58b6cdc9f 100644
--- a/tools/testing/selftests/mm/mremap_dontunmap.c
+++ b/tools/testing/selftests/mm/mremap_dontunmap.c
@@ -7,6 +7,8 @@
  */
 #define _GNU_SOURCE
 #include <sys/mman.h>
+#include <sys/syscall.h>
+#include <sys/wait.h>
 #include <linux/mman.h>
 #include <errno.h>
 #include <stdio.h>
@@ -37,6 +39,61 @@ static void dump_maps(void)
 		}								\
 	} while (0)

+/*
+ * Same as mlock2.h's, plus an ENOSYS fallback for libc headers without
+ * __NR_mlock2.  It is not taken from the header because that also defines
+ * seek_to_smaps_entry(), which nothing here uses and which then warns
+ * (-Wunused-function).
+ */
+static int mlock2_(void *start, size_t len, int flags)
+{
+#ifdef __NR_mlock2
+	return syscall(__NR_mlock2, start, len, flags);
+#else
+	errno = ENOSYS;
+	return -1;
+#endif
+}
+
+/*
+ * Locked memory size in kB, as reported by /proc/self/status, which is
+ * mm->locked_vm accounted in kB.  Used to check that the mlock() accounting
+ * balances across a MREMAP_DONTUNMAP operation.
+ *
+ * Returns LOCKED_VM_UNKNOWN if it cannot be read: the callers run in a child
+ * whose exit status is the test result, so this must not exit the process or
+ * print anything the TAP output parser would act on.
+ */
+#define LOCKED_VM_UNKNOWN	((unsigned long)-1)
+
+static unsigned long get_proc_locked_vm_size(void)
+{
+	unsigned long lock_size;
+	char *line = NULL;
+	size_t size = 0;
+	FILE *f;
+
+	f = fopen("/proc/self/status", "r");
+	if (!f) {
+		fprintf(stderr, "cannot open /proc/self/status: %s\n",
+			strerror(errno));
+		return LOCKED_VM_UNKNOWN;
+	}
+
+	while (getline(&line, &size, f) != -1) {
+		if (sscanf(line, "VmLck:\t%8lu kB", &lock_size) == 1) {
+			free(line);
+			fclose(f);
+			return lock_size;
+		}
+	}
+
+	free(line);
+	fclose(f);
+	fprintf(stderr, "cannot parse VmLck in /proc/self/status\n");
+	return LOCKED_VM_UNKNOWN;
+}
+
 // Try a simple operation for to "test" for kernel support this prevents
 // reporting tests as failed when it's run on an older kernel.
 static int kernel_support_for_mremap_dontunmap()
@@ -335,6 +392,216 @@ static void mremap_dontunmap_partial_mapping_overwrite(void)
 	ksft_test_result_pass("%s\n", __func__);
 }

+/*
+ * Child exit codes for the accounting cases: any other exit code, and any
+ * signal, is reported as an error rather than mistaken for a leak.
+ */
+#define CASE_LEAK		2
+#define CASE_SKIP		77
+#define CASE_SKIP_ENOSYS	78
+#define CASE_SETUP_ERROR	79
+
+/* Report a setup failure from a case: the child's exit status carries it back. */
+static int case_failed(const char *where, const char *what)
+{
+	fprintf(stderr, "%s: %s: %s\n", where, what, strerror(errno));
+	return CASE_SETUP_ERROR;
+}
+
+/* Report a check which failed for a reason errno does not describe. */
+static int case_unexpected(const char *where, const char *what)
+{
+	fprintf(stderr, "%s: unexpected %s\n", where, what);
+	return CASE_SETUP_ERROR;
+}
+
+/*
+ * Only EPERM/ENOMEM are expected with a small RLIMIT_MEMLOCK, and ENOSYS means
+ * the kernel has no mlock2(); anything else is a genuine setup failure.
+ */
+static int lock_failed(const char *where, const char *call)
+{
+	if (errno == EPERM || errno == ENOMEM)
+		return CASE_SKIP;
+	if (errno == ENOSYS)
+		return CASE_SKIP_ENOSYS;
+
+	return case_failed(where, call);
+}
+
+/*
+ * Run one accounting case in a child, so that it starts with a clean mm and an
+ * empty VmLck, and report its outcome.
+ */
+static void run_locked_case(const char *label, int (*fn)(void))
+{
+	int status;
+	pid_t pid;
+
+	/* do not let the child flush a copy of our TAP output */
+	fflush(NULL);
+
+	pid = fork();
+	if (pid < 0) {
+		ksft_test_result_error("%s: fork: %s\n", label,
+				       strerror(errno));
+		return;
+	}
+	if (!pid)
+		_exit(fn());
+
+	if (waitpid(pid, &status, 0) == -1) {
+		ksft_test_result_error("%s: waitpid: %s\n", label,
+				       strerror(errno));
+		return;
+	}
+
+	if (WIFSIGNALED(status)) {
+		ksft_test_result_error("%s: killed by signal %d\n", label,
+				       WTERMSIG(status));
+		return;
+	}
+
+	if (!WIFEXITED(status)) {
+		ksft_test_result_error("%s: child did not exit\n", label);
+		return;
+	}
+
+	switch (WEXITSTATUS(status)) {
+	case 0:
+		ksft_test_result_pass("%s: locked memory released\n", label);
+		break;
+	case CASE_LEAK:
+		ksft_test_result_fail("%s: locked memory leaked\n", label);
+		break;
+	case CASE_SKIP:
+		ksft_test_result_skip("%s: mlock not permitted\n", label);
+		break;
+	case CASE_SKIP_ENOSYS:
+		ksft_test_result_skip("%s: mlock2 not supported\n", label);
+		break;
+	default:
+		ksft_test_result_error("%s: child exited with %d (see stderr)\n",
+				       label, WEXITSTATUS(status));
+		break;
+	}
+}
+
+/*
+ * An unfaulted mlock-on-fault VMA moved behind itself: the source and
+ * destination VMAs are adjacent and mergeable, and merging them clears the
+ * mlock flags of the single resulting VMA, leaking mm->locked_vm.
+ */
+static int case_mlock_onfault_self_merge(void)
+{
+	unsigned long locked;
+	void *source, *dest, *reserve;
+
+	/*
+	 * Two adjacent pages: the source VMA goes in the first, the
+	 * destination in the second, so the two are mergeable.
+	 */
+	reserve = mmap(NULL, 2 * page_size, PROT_NONE,
+		       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (reserve == MAP_FAILED)
+		return case_failed(__func__, "mmap reserve");
+	if (munmap(reserve, 2 * page_size) == -1)
+		return case_failed(__func__, "munmap reserve");
+
+	source = mmap(reserve, page_size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
+	if (source != reserve)
+		return case_unexpected(__func__, "source address");
+
+	/* Locked on fault, but deliberately left unfaulted. */
+	if (mlock2_(source, page_size, MLOCK_ONFAULT))
+		return lock_failed(__func__, "mlock2");
+
+	dest = mremap(source, page_size, page_size,
+		      MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED,
+		      source + page_size);
+	if (dest == MAP_FAILED)
+		return case_failed(__func__, "mremap");
+
+	if (munmap(dest, page_size) == -1)
+		return case_failed(__func__, "munmap destination");
+	if (munmap(source, page_size) == -1)
+		return case_failed(__func__, "munmap source");
+
+	locked = get_proc_locked_vm_size();
+	if (locked == LOCKED_VM_UNKNOWN)
+		return CASE_SETUP_ERROR;
+
+	return locked ? CASE_LEAK : 0;
+}
+
+/*
+ * A partial MREMAP_DONTUNMAP of a locked VMA: all but the last page is moved,
+ * leaving the source VMA mapped.  Both the moved pages and the VMA left
+ * behind must give up their mlock accounting.
+ *
+ * The destination goes into a window with a guard page on either side, so that
+ * it is not adjacent to and cannot merge with the source VMA: this case must
+ * exercise the partial-copy accounting on its own.  The window's hole is
+ * smaller than the source mapping, so the source cannot land in it.
+ */
+static int case_locked_partial(int onfault)
+{
+	unsigned long num_pages = 3;
+	unsigned long span = (num_pages - 1) * page_size;
+	unsigned long locked;
+	void *source, *guard, *dest, *moved;
+
+	guard = mmap(NULL, span + 2 * page_size, PROT_NONE,
+		     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (guard == MAP_FAILED)
+		return case_failed(__func__, "mmap guard");
+	dest = guard + page_size;
+	if (munmap(dest, span) == -1)
+		return case_failed(__func__, "munmap destination window");
+
+	source = mmap(NULL, num_pages * page_size, PROT_READ | PROT_WRITE,
+		      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (source == MAP_FAILED)
+		return case_failed(__func__, "mmap");
+
+	if (onfault) {
+		if (mlock2_(source, num_pages * page_size, MLOCK_ONFAULT))
+			return lock_failed(__func__, "mlock2");
+	} else if (mlock(source, num_pages * page_size)) {
+		return lock_failed(__func__, "mlock");
+	}
+
+	/* Move all but the last page, leaving the source partially mapped. */
+	moved = mremap(source, span, span,
+		       MREMAP_DONTUNMAP | MREMAP_MAYMOVE | MREMAP_FIXED, dest);
+	if (moved == MAP_FAILED)
+		return case_failed(__func__, "mremap");
+	if (moved != dest)
+		return case_unexpected(__func__, "destination address");
+
+	if (munmap(dest, span) == -1)
+		return case_failed(__func__, "munmap destination");
+	if (munmap(source, num_pages * page_size) == -1)
+		return case_failed(__func__, "munmap source");
+
+	locked = get_proc_locked_vm_size();
+	if (locked == LOCKED_VM_UNKNOWN)
+		return CASE_SETUP_ERROR;
+
+	return locked ? CASE_LEAK : 0;
+}
+
+static int case_locked_partial_mlock(void)
+{
+	return case_locked_partial(0);
+}
+
+static int case_locked_partial_onfault(void)
+{
+	return case_locked_partial(1);
+}
+
 int main(void)
 {
 	ksft_print_header();
@@ -348,7 +615,7 @@ int main(void)
 		ksft_finished();
 	}

-	ksft_set_plan(5);
+	ksft_set_plan(8);

 	// Keep a page sized buffer around for when we need it.
 	page_buffer =
@@ -361,6 +628,10 @@ int main(void)
 	mremap_dontunmap_simple_fixed();
 	mremap_dontunmap_partial_mapping();
 	mremap_dontunmap_partial_mapping_overwrite();
+	run_locked_case("mlock-onfault self-merge",
+			case_mlock_onfault_self_merge);
+	run_locked_case("mlock partial", case_locked_partial_mlock);
+	run_locked_case("mlock2 onfault partial", case_locked_partial_onfault);

 	BUG_ON(munmap(page_buffer, page_size) == -1,
 	       "unable to unmap page buffer");
--
2.55.0


