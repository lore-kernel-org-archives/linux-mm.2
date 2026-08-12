Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E176FC5B567
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 05:09:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81FF26B0088; Wed, 12 Aug 2026 01:09:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D08D6B008A; Wed, 12 Aug 2026 01:09:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C05F6B0092; Wed, 12 Aug 2026 01:09:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4486A6B0088
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:09:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A78481402ED
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:09:10 +0000 (UTC)
X-FDA: 85091438460.21.C6ADECB
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf31.hostedemail.com (Postfix) with ESMTP id 0BEF020005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:09:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eCCWqKWX;
	spf=pass (imf31.hostedemail.com: domain of 38_97agcKCD41kjqnujlttlqj.htrqnsz2-rrp0fhp.twl@flex--wfelipe.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=38_97agcKCD41kjqnujlttlqj.htrqnsz2-rrp0fhp.twl@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786511349;
	b=Z/qNf2sqj4E0LvnIg7MJXSfUNNx4ZANqUAjWX2yn6/p+keAk/KUmJMRCUKfZw/P6wdWVbQ
	zZApS8HFu8jUSlL8DkGLyJi2cCJZq71Hs6nWRKaz5kLdjJjLJAgI0LSNUiYH89sJ8uUy5y
	vmemgljA1VaSvZYVi0nyBTGqKXz6z9U=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=eCCWqKWX;
	spf=pass (imf31.hostedemail.com: domain of 38_97agcKCD41kjqnujlttlqj.htrqnsz2-rrp0fhp.twl@flex--wfelipe.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=38_97agcKCD41kjqnujlttlqj.htrqnsz2-rrp0fhp.twl@flex--wfelipe.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786511349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Thn+HKkCXc42d+b79Pai7lKi10VN8wTMXKW37O027s0=;
	b=FUNZdpdQJU4f5McKHm0frAgauNVwvqRSmL2DqdAstJfMJscaH8b92mW2oVbLlg7oOJ+HCo
	ic3FyMhHw2ntMhVRCp4EVivTpmXRFThpShv2Zn8CNoxCUXt1FdEE2WvK5Wdpu5gezTWaqV
	DVv81NrR9Xv06oPwCzx9UIrMgTqDffs=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38ea32e57e2so1014641a91.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 22:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786511348; x=1787116148; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Thn+HKkCXc42d+b79Pai7lKi10VN8wTMXKW37O027s0=;
        b=eCCWqKWXLM0DDILo37JDWS+MkIWvg65X3QfBNx4M5vj3ZPqD7HrabFEpezIrgB1TGy
         zEai6cDDE9NPKznZdm/DioWhozOJS6m5JVYDlr0LzGgeu2GSt80LmTwKKovfRQ2SrM/w
         RyCq0zndvpMF/oAc2MuacrklEu4O8hhvEisvce13fvbZQsdnQ6Zv398kKg0W4mIW7RHi
         b/alRXHBhkCAK7vxIeZGVKqr/TDFcYc44T0u5r4JciUoM790TElvbWBAGrIR0tiOH0P1
         uraCnZRmKa3Cq/+B13gkIvFtR2UjtkUXX9s44ogXKfOi8ArWlfsJD9uG1WUZ+aRp9JA3
         67Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786511348; x=1787116148;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Thn+HKkCXc42d+b79Pai7lKi10VN8wTMXKW37O027s0=;
        b=Nkeu8vjEvakYoF0K6ZesG5SHIbxFNwWGruRqYfYeSRz5O8HW4jTmpoPn3/FVtEDmqY
         UJi5EViqs1IyqVPaaHp8exx+1dowHn/8BsLNm6/VmSgIBUilqOGctmr76zdtFPwgmGIS
         r5lT/37qK4vOJMWHkD+UaJY+KiP/WDvPoZ97nYp0ZiMSgQ8FcxxXPmPDVRu1hx23O94d
         NR1gUjw5L0MaAvhWgiRphtbX2ttErrALqIYU2iwnriY6bKgq4v/zq0yxV7gW8+cAEnkp
         s03kyfuqB6d6SjRXEwdn4n8OgnSmwz/dINE+vlc5ms95GJpQhcfDED3a/zj2R/iM4ZVv
         RoEQ==
X-Forwarded-Encrypted: i=1; AHgh+RoD9fZMmH9Jd3Ni+zKmxCGSXaTPjUEw75MsGN5Hzybl2RMgd9x7OFiSVRjsKLRvt6vJ8JR5w4Di+A==@kvack.org
X-Gm-Message-State: AOJu0YwwK4fd6D+ybRoHbOWOWzInaFNx7n1UJioffZmxIAMzWWvaq7Z1
	bhC3CpGISxu2u3FfM7fOAXCh9EhJ3r95hnmLXZAzvShpozbILHYNwCtP0kUS64Xa2bsjijaYgLA
	n8h1kaJmIUw==
X-Received: from pjgg14.prod.google.com ([2002:a17:90b:57ce:b0:380:f969:825e])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:2ecb:b0:36a:5d1f:7b6
 with SMTP id 98e67ed59e1d1-39301252d62mr2984597a91.2.1786511347564; Tue, 11
 Aug 2026 22:09:07 -0700 (PDT)
Date: Wed, 12 Aug 2026 05:07:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.679.g6767b8d81c-goog
Message-ID: <20260812050848.848882-1-wfelipe@google.com>
Subject: [PATCH v3] selftests/cgroup: test_zswap: skip test_no_kmem_bypass if
 debugfs is unavailable
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, SJ Park <sj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, "=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0BEF020005
X-Stat-Signature: rhf6h9q74atzsdy4q5pwncjhhwfz54pc
X-HE-Tag: 1786511348-161796
X-HE-Meta: U2FsdGVkX1+Qb2V+QoLViy/lvZO5cObxGTZ/8KfBh76PGPc2Junsuiu3jAafpe81z6BZdjNQpsmg4SA7/cFcAkzx2OtYMXPzeI8r05t0cFBreZV3jIoP+y3lH5Cxm8arChUuHDUr+kITThxvDZWGGtOyMrfAi1yMFWRb40bUcIP44ujmejpsTqYvI7aYE6D4eNwudSH9uoUp6GTbUIICFnpwbga8bHzjoWKZ8roVpdYsuxTZNJMZrjTr5Uw8lVl5V3X09O8ZLsrlT/3GeROk2OP4Ur+wQoU+hlUds1gX5LqoNxkdAlyLSJlrRbKFdFILkbWbm9Feck/HsH3FMCTw01NKQFqG0zL2Dd0WdUfUoHjTXYT9Q6jbi4E4g76lYWGbeECCx2YmfopKoe6okVYrUVGdko3XtdlCE5QeE99yrgQ9lGNH2MwO2t1Qj0HamRxOD961jdmeLOiA8Ei9wm2h76wJPRsA0tJqAAwlnWWqz3tDAved1JqHuh35Ve0bnyXKS8BFeQRVMwTP3lhoSI9Ua59rk4y0ds+xpoGMIjbrhzNJ48J+qmeYBd5gmaxS4AnezcPr+JBywHOteem8MzvGvMQW8eXfMqug72kvRfbSV6LNuvQzQFhla90USlSq7kpo5LwwrPSE4WSdYBQVh+z+qFZnmEsjNn8LoQYS9kYIoP1+1fRCSjgn+MLalotn/AK5LplTiFml6CbFiTNWmkN2TtGF31Tk/z7vgRKRHJoYiO85xfNqcJX3ZE9yV+74u8ibVWq1FjITqrvuL4Es1abGP/IbJ30euQ5YFUmqcSX8AopGHMTJ1q4UAKHKoN3ajRKlYxMVI+2fdek+PhhXHs1JWz61Xk0mZ6dRW3cLTzB/zg2NR7QqkHJnhNhkNH/jYIyMEOLZOoF57QmvTf6g83pxsNFw3vqSydiT4RyrtPV9g7wSVDNtUiIOLpqJPkxNd6RR672GrJGjSmeIZ/Rhcmd
 30xARafV
 GYbZI781pnIuGXTzYfU9cbjJFCPcHp+OoyrbYL/WP9Rd3Y/oL1Jm7Jc64D5Yk/VELFQaV0hj0RhZCOec5LbNiVtoZ0pgf2dOEh+LIa01JlFEQlVy8zvG1MIMGCtILSovLzIYFygIuctGqdA5h2tl/J2FOSeq9RogTQE0EpZCNhxSsOwPVOVZJYNh/FLm+O7zhu2HXgTEwVXuCTK1jUsc8cLQ7gdTgBU1MTQRiHl0znWSS04Ehhoemj33CXXYmOO+haKj1eSejbTPncrrXPESklNGMygqT83353CVyGBC1vNeBNCFPm0/qJG931y40R+LA4hi4+jpDp6PHR36qPSVf+ETGOPKno0ZgBR/2MglHRTe4VCEMmDaQT6DYLzutx0BZyJexmZlPL62NTtezcmm07+Pl66yiQFHqyFzT7fA3Mb2V92pkAXOsMN2OrWtoj1HK1IWFH7cMem6TbK1z2MOfS1o8xUQcrMZ+6meH6G7NL5KjQUvWTrea/oma46rQxaeF+3tgWcWIU9waXxYFiXvNr1OdLvCdcnoevOHSTXH6VVgofP9ngLJcLSMceDD8NRYWsIS1PQWVobntmAH5zGGUgw+ryMtRGiEwPeQSkFDhfd2YKbFaGvUYykUnSemC3GCd3HJRkrY3VoTt/5TNf0HR/392AWRbFLlM57uEzcwj7QwzZpd1TduTo+6rDy8AuvWsj6knglfPXFV8P85HMODH0fU9WnApnUg71pnpU3rW7FbI5E8=
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
Acked-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
v2 -> v3:
  - Update debugfs print message to be more clear (Andrew Morton).
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
v2: https://lore.kernel.org/all/20260811051434.3805648-1-wfelipe@google.com/

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
index 49b36ee791606..f7b4c4370db63 100644
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
+		ksft_print_msg("debugfs not mounted at /sys/kernel/debug\n");
+		return KSFT_SKIP;
+	}
 	values = mmap(0, sizeof(struct no_kmem_bypass_child_args), PROT_READ |
 			PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
 	if (values == MAP_FAILED)
--
2.55.0.679.g6767b8d81c-goog

