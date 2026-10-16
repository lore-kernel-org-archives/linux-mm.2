Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB58CCA46C
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 14:35:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C907B6B0099; Fri, 16 Oct 2026 10:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67BF6B009B; Fri, 16 Oct 2026 10:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D9A6B009D; Fri, 16 Oct 2026 10:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8ECA66B0099
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 10:35:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F88E1A0480
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:35:24 +0000 (UTC)
X-FDA: 85328737368.17.1279DCB
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf11.hostedemail.com (Postfix) with ESMTP id B961840012
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:35:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HDNusMyX;
	spf=pass (imf11.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792161322;
	b=yjZbR7uHUbjSUJ74hlJhLRicBkaznPM9Xm7b9T9JTMkV7RKXsUvBuWQnbUz2Q5uMswtvWp
	FyeOFuSrM3R8pY+vnlTNGvB4DM5TucxqGoDgWXmSLD/hqOF8H0R8HLwrvFuZEiil7ymlxm
	Cqi+oKbUwjh8XgPK5z2GoaGH8S0aTHo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HDNusMyX;
	spf=pass (imf11.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792161322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G6Q8gG4c/qnKlMaH5pfvOOdUUEduyYXPZR3420tP37o=;
	b=Vfr7w1JiaDtMFgQoZ0NHmptaTVIfahdtHZKeS+FdaNwHzM/gSO9NCGFDn6kYn5gCz22LOr
	gnLgzPztbNpqrDXNFcaIc2twqWyrT2cB9RGab4yB3k+wGYv2vnkYkOnctUOT5C9qf75zXI
	TWIWYt70cXYGQqiji8IHD67C6YVrpW8=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35c76e9614aso4997860eec.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:35:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792161322; x=1792766122; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=G6Q8gG4c/qnKlMaH5pfvOOdUUEduyYXPZR3420tP37o=;
        b=HDNusMyX1HWhH5hmESx7EUWeff8IkbL1a4f7QvWIVJe4Cp1gbrv7PWnHyrf2X0Tqzv
         0zBkDl3vdRi409KVDFLXRBzCMwsOdA3QvCjMWhrOWnJqoT3GCnygCfPPdCINu2R2MQG6
         VeepXc7XmblpFDQMmPMlBB41OsXXosNHsOdZvrQeefTTBMHuv7gNug7tk91zKymZjKhI
         Pyrk8NQex9k7GdNO8H/7uMqkj0NyzReBzoUQCxr6xKsNvVfZEAQ7KRQv8DNnqzBd/2dT
         DVhZ64rB7xIyKgTNF5TuAmbBH2HQgA+OAxbnVQqvB+kFG1bMr6sVLxvlg5M7b7l/ZhKk
         HfRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792161322; x=1792766122;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G6Q8gG4c/qnKlMaH5pfvOOdUUEduyYXPZR3420tP37o=;
        b=Zlw+ZTn7Ax5RhqO71ExVBQ/PuLQBG1o47+kpnAp7rTYYEJ+WUPAF6a6umO9BUs26xJ
         23CoVEYoIjS64Y7zenrMFQPOQlUi2mxMQODtYHVHMn3jTEQRv0JxaMXErCa59GZm8kO0
         I5w4NgiCMdkIre8GE+lf74wESV1qogbQ9HOKRSdvXN9mxQlWjfd6YgFEGhyps/kfWD0C
         bEIRz9/sW5o6zjKfGRuGl0yW+PkZ3Q5AC5+P/+1qWtMk3RA+eXBFLVOwCAjs8GOeRay+
         Oo0s2sQp4om+ebqtkpm/fv1Yu8LW7Dh5VJncgdNSkeZxYc5EGs1gS4965AbLeExzqeZe
         dKKA==
X-Gm-Message-State: AFq9FYKr9r8nwU3n+5fun8UB/zjcDCSx8D+qgGMGUfLuM/VNcfNT2xF7
	Sivdq6L769xT5YdFUHSkITyz/4eYgHoypN5ZpB45nuq+kRjRYyDtM+c6
X-Gm-Gg: AYBFou3kLyQ6FN/y9ddE7zG0gKXeoesViT5mjIIz4TV3Oid5romWVCzI7azshuZQdbU
	rYSztI4L0oXgkPvwkpyDupc2+yeUWYtHCboLisU2HbVJ97RsUngX68lIC/cC9ewwdp7A4/tyJru
	J7dCOM1NKFBOWCjt0HNj3nDhJn4eB6eKMT3GfO9rOVUuzPvz/LJ2qYG5LgHA/jcUN6YrIw37R9H
	RUq1bmFtBb6WlY5k8z5nYSDpog8arYj+l8VbWii9Y4XFu9O8jEjUE4xjMF9yXBRWNNMfkFwoqvh
	Bzp5FgQVS1nwWTfI1XsQ2Dt+a/2MPWxpzm2UdytSez3X+UKp6U6+ECwENcW7sUY0izH8SfbNoEO
	wcBYbr/qL+NnMctvp7bLc5N+Y9MT7HNDuMzd4GwG1Wa5u2z8+KZ+cY2uhQdywO9fIbkFQ7hoDqW
	enVvht4ARVBcQSTUOObMplyNt3LbVY6sx9xEZ9uQX5NjBXQbNBbYJ1Z7sYb82I3qn3Mw==
X-Received: by 2002:a05:7301:da84:b0:35d:3370:d8e7 with SMTP id 5a478bee46e88-3619ed12158mr57587eec.2.1792161318630;
        Fri, 16 Oct 2026 07:35:18 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3608297f4f7sm7611812eec.23.2026.10.16.07.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 07:35:18 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Fri, 16 Oct 2026 22:34:57 +0800
Subject: [PATCH 2/2] selftests/mm: cover merging KSM pages aged by smart
 scan
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-bug-mm-ksm-smart-scan-align-skips-v1-2-2f91d76416be@gmail.com>
References: <20261016-bug-mm-ksm-smart-scan-align-skips-v1-0-2f91d76416be@gmail.com>
In-Reply-To: <20261016-bug-mm-ksm-smart-scan-align-skips-v1-0-2f91d76416be@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, Stefan Roesch <shr@devkernel.io>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B961840012
X-Rspam-User: 
X-Stat-Signature: ebreb7sqs3xgtwqaga7rnoooppr61hbr
X-HE-Tag: 1792161322-739953
X-HE-Meta: U2FsdGVkX1/6KDnJMEuocI46QObSThFnNFJl5Aw74ipNQa4sbPGf8CL5n97RkCMO2el4qSIUZppb9aT/bI++z1Kac00tI8ZleGnT6JteMfXPqu2Nq9WrTixC/XnaJuLawE7qoMLTdpJZNJKRwKUsYRBjOywKHeNGXNxsGvg6p1BAkPrmJAndvw5FCV9jtVoau3EEq47Ll2vTz+yu7XYHiyloCBJIy6K9jcV6jViw8kcED5F7vyYtvbkTq2k2ngRQhtLfkjBpplG5qa9FRouIB2I2P9bAh5kLgNEJAEchK9HkC0IsmcFZC5yq0XDFpw0oRy/FElOsXfoqOc7olVKie1/IIMaz0kEntUpmvH0vD9ABwyka1rLfzFpZsr5O1xRRVRqLMl7QAU9s/6Y8Jp76h+b1DtoyR+nqGSylIB6dV7w5lX9Bw4YDmIDUAMykJYH3wb7ef8b2GRm0hS79G3MzBuPntp6Wo0FAi4rH2Y7ePsjd6c/ryV2Yb/W/5dijn93EButQUxIB4U2g5LBReICA3Lxy8Uj4mJFKY0ZS0zS0iJF6nI4ChA6t91dzlYr3q5sBI5dKCnh2+BT0T8yWbPofvj1cMEahjX0PaICGbZdeSAmoc8hhx6/iSpAo+xwCtUKtUB61VFUIlX/GSo87AJf7T6axH6qX2JNkHv2QyrdNrBSqo07EeYBvvuhtYie4U0W/1FSBPJLv8b1ZkFw8Ftfrv1DvE5LJDJTDKADdVsHQlg5SuWbSiWh46hKzUWt9c0+xbmzMsS3HZKI+UyFXODaZkt+DTOlqTX3yl0166C76gIYwhDSbTw2opWCQL138uZOyjjd0tLZKViTMG0pceRxzmAnjI5Vm3N6qFtUQ9/vQiKCQmepcBeKi2Fa/SVasqQ3uKW7kRzM5nUevR8jgmJvrKvnAYDVrtlfnufK6DVJ5XCgxU48U3KaAoN6Bw//1hfkV5CIytXnk/oGIHzglsL/
 5reYoStb
 eZAWhwiYjuio6UIJbFeJSzBLeak7YNcHhnql7VNG3XVFoN4P90bDkJebO8iy1jWe+ODuy3Phz9yvXIH9olOv9A+OxCIA857kQyexyqkemImkos2AHN+lxZ1MH2Af6Gm3NWm7fREsinkJnlMXuZNMYnHcONKsUONlCSAda3zndzJaqTToSEaA93bT4vuDWvbm51BKeDKM/X+HzE/wTjnyTs1gz28JNm2zDX//O8vZ4UUfDlaswPGgFhZlRa4eijoGVlrLjttwsbVQDWsPzVmTLVMqprFDzLYv8OdzyXJV/iBN2WdU8PHao7IrgcNZTHmEM0i7O9/Phw2IiOGtu11CdChGg0ylVdrAZF1/zLbx3tgyfGVq5ciSjy9A5NqdV5ocjPxFWpKMjlsuGMuKFgI9lKm7aLHjxK+b+7A20prU9VQ3s8cTFm0Aa5xTGWqkQIwH1FrmolX7jWbsFQllmtZksiK139Mvmoi8J1LH+MM93EcfSuobK3GFoSGEOEgmn7OacAk5EUf/JeWT+wOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ksm_functional_tests checks merging and unmerging with ksmd's default
settings, but nothing there exercises smart scan, which skips pages KSM
has failed to merge for a while.

Smart scan used to time those skips per page, so two identical pages
that became mergeable some scans apart could end up never being looked
at in the same scan, and were never merged. "mm/ksm: align smart scan
skips with the scan number" fixed that.

Add a case that lets sixteen unique pages age for a dozen scans, then
makes a duplicate of each mergeable one scan apart, and expects every
pair to be merged 32 scans later:

  kernel               failures
  before the fix       20/20
  with the fix          0/20

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
 tools/testing/selftests/mm/ksm_functional_tests.c | 108 +++++++++++++++++++++-
 1 file changed, 107 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 31c06c72203fd..71d9b3cbdb8c1 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -695,6 +695,111 @@ static void test_fork_ksm_merging_page_count(void)
 	munmap(map, size);
 }
 
+static int ksm_wait_full_scans(long nr)
+{
+	long start, cur;
+
+	start = ksm_get_full_scans();
+	if (start < 0)
+		return start;
+	do {
+		cur = ksm_get_full_scans();
+		if (cur < 0)
+			return cur;
+	} while (cur < start + nr);
+
+	return 0;
+}
+
+static void test_merge_aged_pairs(void)
+{
+	const unsigned int pairs = 16;
+	const unsigned long size = 2 * pairs * pagesize;
+	char *map, old_smart_scan = '1';
+	int smart_scan_fd;
+	unsigned int i;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	smart_scan_fd = open("/sys/kernel/mm/ksm/smart_scan", O_RDWR);
+	if (smart_scan_fd < 0) {
+		ksft_test_result_skip("smart_scan not supported\n");
+		return;
+	}
+	if (pread(smart_scan_fd, &old_smart_scan, 1, 0) != 1 ||
+	    pwrite(smart_scan_fd, "1", 1, 0) != 1) {
+		ksft_test_result_fail("Enabling smart_scan failed\n");
+		goto close_fd;
+	}
+
+	if (ksm_stop() < 0) {
+		ksft_test_result_fail("Disabling (unmerging) KSM failed\n");
+		goto restore;
+	}
+
+	map = mmap(NULL, size, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (map == MAP_FAILED) {
+		ksft_test_result_fail("mmap() failed\n");
+		goto restore;
+	}
+	if (madvise(map, size, MADV_NOHUGEPAGE) && errno != EINVAL) {
+		ksft_test_result_fail("MADV_NOHUGEPAGE failed\n");
+		goto unmap;
+	}
+
+	/*
+	 * Page i of the first half and page i of the second half form a
+	 * pair with content no other page shares.
+	 */
+	for (i = 0; i < pairs; i++) {
+		memset(map + i * pagesize, i + 1, pagesize);
+		memset(map + (pairs + i) * pagesize, i + 1, pagesize);
+	}
+
+	/* Let the first page of each pair age without a duplicate. */
+	if (madvise(map, size / 2, MADV_MERGEABLE)) {
+		ksft_test_result_fail("MADV_MERGEABLE failed\n");
+		goto unmap;
+	}
+	if (ksm_start() < 0 || ksm_wait_full_scans(12) < 0) {
+		ksft_test_result_fail("Running KSM failed\n");
+		goto unmap;
+	}
+
+	/*
+	 * Make the duplicates mergeable one scan apart so that each pair
+	 * starts out with a different distance in scans.
+	 */
+	for (i = 0; i < pairs; i++) {
+		if (madvise(map + (pairs + i) * pagesize, pagesize,
+			    MADV_MERGEABLE)) {
+			ksft_test_result_fail("MADV_MERGEABLE failed\n");
+			goto unmap;
+		}
+		if (ksm_wait_full_scans(1) < 0) {
+			ksft_test_result_fail("Running KSM failed\n");
+			goto unmap;
+		}
+	}
+
+	if (ksm_wait_full_scans(32) < 0) {
+		ksft_test_result_fail("Running KSM failed\n");
+		goto unmap;
+	}
+
+	ksft_test_result(ksm_get_self_merging_pages() == 2 * pairs,
+			 "Pages aged by smart scan got merged\n");
+unmap:
+	ksm_stop();
+	munmap(map, size);
+restore:
+	if (pwrite(smart_scan_fd, &old_smart_scan, 1, 0) != 1)
+		ksft_print_msg("Restoring smart_scan failed\n");
+close_fd:
+	close(smart_scan_fd);
+}
+
 static void init_global_file_handles(void)
 {
 	mem_fd = open("/proc/self/mem", O_RDWR);
@@ -720,7 +825,7 @@ static void init_global_file_handles(void)
 
 int main(int argc, char **argv)
 {
-	unsigned int tests = 9;
+	unsigned int tests = 10;
 	int err;
 
 	if (argc > 1 && !strcmp(argv[1], FORK_EXEC_CHILD_PRG_NAME)) {
@@ -753,6 +858,7 @@ int main(int argc, char **argv)
 	test_prctl_fork_exec();
 	test_prctl_unmerge();
 	test_fork_ksm_merging_page_count();
+	test_merge_aged_pairs();
 
 	err = ksft_get_fail_cnt();
 	if (err)

-- 
2.43.0


