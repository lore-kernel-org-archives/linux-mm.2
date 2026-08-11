Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4857CC5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 05:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136516B007B; Tue, 11 Aug 2026 01:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E2F6B008A; Tue, 11 Aug 2026 01:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023D36B008C; Tue, 11 Aug 2026 01:14:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CC7AF6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 01:14:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4DFFF40346
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:14:50 +0000 (UTC)
X-FDA: 85087823940.17.E0DF0E3
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf09.hostedemail.com (Postfix) with ESMTP id A8CD0140003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 05:14:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ssVsG7B1;
	spf=pass (imf09.hostedemail.com: domain of 3x696agcKCGwgPOVSZOQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wfelipe.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3x696agcKCGwgPOVSZOQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786425288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=pKQ5y3/WZDtJVgzNVhjxBkStuBbcXc8sEx+vbwtqdLY=;
	b=oEQXoTcnelJeT/ZqTyVWwopmsbOWr13dTHuIVjB3npdZAJwJXAcv1+q0EpmeVJ69LgBr/w
	YgfURFW9ioJZg4BqdufETs1WAu1uofu5xB2USwynizywVscRKZBQYqHkDz75h8EAGdvuB5
	/jrG8VGM1y+pwLF1r7SAjivAcvZfrB0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786425288;
	b=gCNjAoa+iBxlYGjs4U6bC4ZFqmX+wUH5r6iYeLF+c8WTg+4GMt/HsxDIHXbQ/M3Nt5kOeB
	HblTP4D//GZc4ykkhQYvO1lAoTvJHCqodNU7i4ftc5r+RBgdCrqfMRG48pY67VBzEGlg/r
	G94arITvVpDHrwpiAuUuTpnDLIMKZXg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ssVsG7B1;
	spf=pass (imf09.hostedemail.com: domain of 3x696agcKCGwgPOVSZOQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wfelipe.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3x696agcKCGwgPOVSZOQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-84e13b57b2cso446162b3a.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 22:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786425287; x=1787030087; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pKQ5y3/WZDtJVgzNVhjxBkStuBbcXc8sEx+vbwtqdLY=;
        b=ssVsG7B1wGBZ7/kNcRzJKvrbY33/OU3tuB8j5TG8RJB3bmi61XggC7+FaNETqp0yiF
         NN7O0+0mqa/MuShP/MBBbHR4X4CuGgTu1fXXTCO6rH+MOOlboW9/cR2jp5rJJc5OCLZL
         9Pqs44XwFAs8zFbA4+dzd1g05d0qGXuwKXjYQy+ftd+UFkNW2W+mIg12Vq/pr51yPL7k
         MfsRRi/roT7d266o2zz5pPY4NEZQIyW4EMAQM+6FM6OOnEZzkHyH4OLdZQv6IEbfo4M+
         5+Fzqz+cUNzSzEeL5zaMmC2GPw7sTVA/BRgI3sZpc64McUbyBldpwTc3Uedfg49VbFbg
         0Ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786425287; x=1787030087;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pKQ5y3/WZDtJVgzNVhjxBkStuBbcXc8sEx+vbwtqdLY=;
        b=pt+Vs6cDgw2ZZLDiVSQj23g7csjvZasSanGtCuMRSr9xerO5ghQOp0T9dzUUtz14qe
         WFHbwQ8d5BhnAKUHG9Ud+m9/Oq4ssf2p9bdG1OPbStyr18LA7SMMcjc/xT1F23bW9Cpp
         eXZRjpKhJswCy/TOkFHB+xlf0wi4s1nx33GoNN/xtEDZq1wl+qNZwd0ivrgJtZTd8eQI
         DG/ipVQ/OEVcZ8fq6l++GxkpU8/Sj3pL1VvaCpHMf5R+CoF1rafdbDEth5bn4BKuLL+z
         ctG8CH5NXXljB99Z8HQp8NIbfogppKZzhKKkxFZr4j9XMG5hFcf3ZfOq6ebcK4eJDOOK
         +xaA==
X-Forwarded-Encrypted: i=1; AHgh+RrlV2b6TEMKoR8v8alctxDSKQfBYn2pjy2P+jLe04XSVH35pKtW1ZxJnMzNZod1kQQcLVEgPAP3dg==@kvack.org
X-Gm-Message-State: AOJu0Ywz4qjkB/iFkZ+pvlDMFr/QitXy0Z3UfwRdKmu7wKyAPfUHpNJR
	l3VGmKgculZ7njfSHxU1gVJeeomSjEff11/FliBUHvf23rgC9/0gpjZw7jwAslxB2/ngxpAXAMu
	7C6jplzSZ0w==
X-Received: from pgjf16.prod.google.com ([2002:a63:dc50:0:b0:cbb:9724:677e])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:4396:b0:845:c7f1:29fa
 with SMTP id d2e1a72fcca58-84fa8925a45mr581713b3a.30.1786425287210; Mon, 10
 Aug 2026 22:14:47 -0700 (PDT)
Date: Tue, 11 Aug 2026 05:14:11 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260811051434.3805648-1-wfelipe@google.com>
Subject: [PATCH v2] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if
 debugfs is unavailable
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Tejun Heo <tj@kernel.org>, "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A8CD0140003
X-Stat-Signature: qmk4uhwbwwm1ng6434kssyjjiye7yxor
X-HE-Tag: 1786425288-576707
X-HE-Meta: U2FsdGVkX19bWciMz4A8NhIql7pBQKtvV5G5xhb0Ed+yV2zULgREO0qEkmBuj1Jen6Q10Eg/L8hjmjp5/O8xX7x5Im0od4jw+D1vhuGhP6HHl2VzehKemdrKff30BdAIzMgkBMwt/0Yq/oFyqRjZl8EXQlkUig0/kPzxrOJzQRlXlu6UfecTgBDLvGq1M0nrdQAZqSa9iyIu5IAhYyYxAu/Pnm9cxQK+WThKmgSpGytwWtRfLaYxDZX4nk60MJQ25YeaOmA824Nj0/uTLeGBvm3y4BbeG71hAQzo4H7MSsHe3LdkLpnL62kc8NHvnUg8wEcfBAtxr6lnBbpZEhpQHjrnKz5C/WQubecQbQU+ZuMuKTCQ3VdCskUKNaf8xdFWhiC77B+/8pN17lc5eDpFeFqV3q4ruajIPdkCR5qJdMNsMmCqEinWrOG/Byk1cHN9/+lEVoWX0WTbcXUBHmTzJOgNZP9aDzOSrsxO7pAW0o7srqD7IEqnH2qKWEDzAJF0K5tfcLsQKXV8DjQ26Bg5xFd6vgYLdb8MElkCJ3Ptscxddazh6aWdy7KP4loI1hx85TnRM/cv4cr1ZzE5OrS6ydswLz+Rzu5ulIQGlHMQipJ9LMgpG4Lwr522MzGRd5wnAxeOpqdb18rAdCZsofKJtLVk/yiC6Uedf58ZUTdod2pID95vaJYrU+7L4CKmlP1b+KXtEMg8q9rbhQ6er4etfxv1O8FJ6iFmA06UmYpcCP8UDUFCljvESkEAILE4E3ueQhCTW6DCvqK6BxGqxSjII78J6f5WT5liGv+MFuPVDjH48gNG1unFegMqlU4S9iAZNQKF3tiAb3VHlsg1MbN2SIXNw6XpAvnCG8ere69AtY8xYJ3reef4UOQHwh8iL7mZDpGzEoud1WhXF7bZLM9OJsq9QF6nC9Uym8FpDauFGhQp5BPw2pn+Iz7vwOXaDVOTvwEekAevEtFM20Ag+Nf
 ZelOnci5
 8yZKVqdkC3C4F1hDviv0rLd8DCX3OFia0DuIKPSn6QDZOGgz83cxNspMNrMhBz7kKj9DaIAsw28EIY7WLEBk4b6ugyKgKTKWHEeRFwVfsZinOfxsNC9CypaIIgTDos5oiImfrI/ijdpvHKpT8a2kzGMLHz6knnKc85J69vZ2TLI5FCXhUGaK08s6gXmkLWW2cR3ECPB9O5P13U6yP8WWDq6n54sEd4bRGExIzmK6jL5N0Ig/98p9uDbvIRkbcHLSKXvITIUiaMnducIgOTgS5gpbriLvuLApt7+62UG2Kqgpswc6o9edt7rpX2AU2np3+r9vgjup0/nsSNA4BqAxH8tO9Vh94hHIcZH7amWTLbZy3mD29igqIumBSQ00P1iI764wJT4ADv3kMXgYuywpu97/WIDR+U7nX5awrLGVcqAIUsH+viKz2clvhk3pqzEgVp94vyZ+Jm1eokk0lH8OTojanks8seJIOWRNJNScClyDCCtW86foe92OxhXIfXu6jkUox5a+5+8m2bZKj+YBCSDX85rD4LM+zqC/08ROiciAk5ed9e1Q1zW608no+DkmC+XIZ2Ndnz3I4/nKd4t4IC7U3KS43xfbPKfoJ7HaQP5O1fgvkSTh+AE+HUFn9+YxS9TBc/rk9XvsFVqitH0HzYLB0Sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_no_kmem_bypass() needs to read
/sys/kernel/debug/zswap/stored_pages via get_zswap_stored_pages() to
verify that compressed pages are charged to the memcg.

When running in an environment where debugfs is not mounted or
CONFIG_DEBUG_FS is disabled, get_zswap_stored_pages() fails, causing the
loop to terminate early and report a false negative (KSFT_FAIL).

Selftests should not fail if debugfs is unavailable, and it should print
a message when it is skipped.

While I'm here, also add a warning message if the test is being skipped
due to totalram size and make the check for totalram more readable.

Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
v1 -> v2:
  - Check for debugfs availability using access("/sys/kernel/debug/zswap/stored_pages", R_OK)
    instead of calling get_zswap_stored_pages() (Yosry Ahmed).
  - Update debugfs print message to exactly match gup_test.c (Anshuman Khandual).
  - Add GB(x) macro to cgroup_util.h (Yosry Ahmed). Cast to unsigned long long
    to prevent 32-bit truncation without altering existing MB(x) signedness.
  - Update RAM check to GB(4) to match comments and format totalram output
    with 1 decimal place (%.1fGB) (Yosry Ahmed).
  - Fix commit message typo (Yosry Ahmed).
  - Moved stored_pages back inside the for loop.

v1: https://lore.kernel.org/all/20260801041255.752039-1-wfelipe@google.com/

 .../selftests/cgroup/lib/include/cgroup_util.h      |  1 +
 tools/testing/selftests/cgroup/test_zswap.c         | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
index febc1723d0903..c0f07226b222f 100644
--- a/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
+++ b/tools/testing/selftests/cgroup/lib/include/cgroup_util.h
@@ -7,6 +7,7 @@
 #endif

 #define MB(x) (x << 20)
+#define GB(x) ((unsigned long long)(x) << 30)

 #define USEC_PER_SEC	1000000L
 #define NSEC_PER_SEC	1000000000L
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee791606..a836337440040 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -20,6 +20,7 @@ static int page_size;

 #define PATH_ZSWAP "/sys/module/zswap"
 #define PATH_ZSWAP_ENABLED "/sys/module/zswap/parameters/enabled"
+#define PATH_ZSWAP_STORED_PAGES "/sys/kernel/debug/zswap/stored_pages"

 static int read_int(const char *path, size_t *value)
 {
@@ -55,7 +56,7 @@ static int read_min_free_kb(size_t *value)

 static int get_zswap_stored_pages(size_t *value)
 {
-	return read_int("/sys/kernel/debug/zswap/stored_pages", value);
+	return read_int(PATH_ZSWAP_STORED_PAGES, value);
 }

 static long get_cg_wb_count(const char *cg)
@@ -570,8 +571,16 @@ static int test_no_kmem_bypass(const char *root)
 	/* Read sys info and compute test values accordingly */
 	if (sysinfo(&sys_info) != 0)
 		return KSFT_FAIL;
-	if (sys_info.totalram > 5000000000)
+	if (sys_info.totalram > GB(4)) {
+		ksft_print_msg(
+			"requires less than 4GB total ram, sys_info.totalram: %.1fGB\n",
+			(double)sys_info.totalram / GB(1));
 		return KSFT_SKIP;
+	}
+	if (access(PATH_ZSWAP_STORED_PAGES, R_OK)) {
+		ksft_print_msg("mount debugfs at /sys/kernel/debug\n");
+		return KSFT_SKIP;
+	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
 			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (values == MAP_FAILED)
--
2.55.0.679.g6767b8d81c-goog

