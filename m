Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E3ADCCD183
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 02:52:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D6058E0046; Mon, 13 Oct 2025 22:52:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AD5F8E0007; Mon, 13 Oct 2025 22:52:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E9D78E0046; Mon, 13 Oct 2025 22:52:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0C48E0007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 22:52:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A11313B90A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:52:42 +0000 (UTC)
X-FDA: 83995196964.28.AE6DB54
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id A8ADA140007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 02:52:40 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf26.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760410360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Y3iEGPjTEMq28H494G3le/PpjY1d/gXwokrnXwTr0EA=;
	b=DPfPtloDlMGgSx8SxYO9T9acUFLeJMvZD78PsSW5D+LZ2PkfJIPdcyIVq+HmhoDQp7pXCb
	abpPWebogXbg0B/B4HdTtQNe/2w1T7bQs0iEExKVRtnbOkm3JQcPAAkj6/sFtqxW3Y2Gve
	ab0t783sWKfoS74t/mGKWkay8jtlCqM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf26.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760410360; a=rsa-sha256;
	cv=none;
	b=SHNerv5XWVp1UmLMOZQxTRklhwrdnY2liTNsd1D0aGn7PA2eoolDWGmasWIf+DTr5LEDt5
	5Hj1HBac31Qi3QZ0jLq1s4MMNINNQ6UGDPWCrJEVpXUzG5E0EQ87xTjn3Jefn4/OQNVXNw
	9Nr5b9Ddn3u+UfBA0L2pkUWU/qF5hAc=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-28e8c5d64d8so44477635ad.1
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:52:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760410359; x=1761015159;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y3iEGPjTEMq28H494G3le/PpjY1d/gXwokrnXwTr0EA=;
        b=EB/mtbw9jYq+waBQSWLYGLMtZMotYgLIEO7zSFmYa1hnYB2ZFJOy6L7iUz7CTrnFC6
         q/j3eapRZNuW+dhZX549ArnmAfLN6Rb4LjdI99hRZhekuW5wWzMdmTB9xIZQklmNVS4F
         kewBRO5QnD1ZAJe4ApH9t9f1s1z6my/ejjIJ4gNiKn8ts1s+SDLQWxnJLrEG2hMjg5HY
         uPwLAoZ7Oa5RUpoRvE8YGclfZbPtC4cifO7QPKfT97vuvKV3l9N1ZtJSfOtNJ7s35gTi
         L1mH1N1vs5x35Xo81DVIz93+kCFS4Fq5EYJvRCfakrZL8HKXagkt0vr5vRWX8L9ofSnG
         oY4Q==
X-Gm-Message-State: AOJu0Yxv44BrAau1vpkSApml0OvpNx4kcS9fteJQl7BqAgfOuh8SeHPr
	63OqvfQo3xQ1Q7OXn2t7eS50O2Tks64iVI6MvkHn91u6CNH/8yJ4KgA/
X-Gm-Gg: ASbGncvV4xWDlw5Z/Xe9tgdjidbdflh5yrS7onAeFehcRvUHXaOIWG071c5ghv7s9nL
	fk6LGYQsBgw2NHmAjT1nDX5j1WwbxEFlx7tnV3uHMzjZWh6IpYgETA1pYhY0dr55KCWErDK55cQ
	W7jJ+E2tjyfZLkfpV1D9+C9JYOy+dtHKqKDFs+VvM6DsFYBDJeMd6rN9QcMMYq4zBeFTyMVAcVk
	BXP7+3xabw+4CzEHBafYwf785s+FnPyCkUgfUteQcaRSVmivSDD+uT7hjSQKyEhFqVeC3GWRNrn
	uEArsvzHSY8BbNUdE4HvsgNkzQ2z2fdz6fCR3H2Hm3KMsKxTeLcdkMEhcB77dQu7BPqzGdb/QHb
	Ve7Ylw7jqMCC7Uc7wKOO5RpGKFdE/9BepND7J3VWHIPfVgGVN9zH9
X-Google-Smtp-Source: AGHT+IFJaPeb2N4JPYVpNkhASYoC4H+gIGNfYkAiyOPGfA7gyXdUEpvFwcG64zzIIMcO+f5GlwBDFA==
X-Received: by 2002:a17:903:8c8:b0:264:a34c:c7f with SMTP id d9443c01a7336-290273568famr335713285ad.7.1760410359395;
        Mon, 13 Oct 2025 19:52:39 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a11:3:200::202c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034f4ae6csm147933885ad.108.2025.10.13.19.52.34
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 19:52:38 -0700 (PDT)
From: Lance Yang <lance.yang@linux.dev>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Shuah Khan <shuah@kernel.org>,
	Gabriel Krisman Bertazi <krisman@collabora.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6.y 1/1] selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
Date: Tue, 14 Oct 2025 10:52:26 +0800
Message-ID: <20251014025226.35257-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <2025101329-unplanted-language-2cc7@gregkh>
References: <2025101329-unplanted-language-2cc7@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8huf7tigme3pyjw5481rqtkffq8u8gjo
X-Rspamd-Queue-Id: A8ADA140007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760410360-675204
X-HE-Meta: U2FsdGVkX18fgqOJZK8EXwZaG85FrmrCoCWWwfJFPerOZCm4rkZCgq6NlwSLTBRNkF0L/UeoZtGcBvT4sCVJV/fgW5iF9gTdaJPSqTyj592dRdf8S5jNLmQBqSnDIBf9K8zRcRDlZ+nywtRy+JJvpYPnXpDsvV0zM8b1rv+mQOIXL/NKCQ5VtcoAp03PzQpz49PGtBMuRUByY1kaHOiudwGhNwWCGOMZHOqqDoUwfnQXYNdcCGmN9ylDM7RDjjX6bxnttQ2IaeWo5bjy/+4FIFmugP7I5/Nk/CfUEdu564Eq/sTGVxGtVth24BwePbEgBSXGx6sPXDGiQULlcKLrmr+ebotK1YihDr7X+dSefISiFvWznHj3FETrqH40vA/ij0D27/rw0lHV4UiN8nmG0f4F96QsIZddvDjwv1NuK3oFe6YayCUDuaLer1s193qFcPrK3mwt98DW1dXNrtTsk2RthXvDkvkoWSLr6Eo9Iznvy1NLHQzOGj7xSMMDd75jUGUruvgwDiY0vGrBf5eMJ068XHkYSe9ZKhTdbS9FI+HHL8fh0OA1NfWFZtFK9HB81wHVjHjQpkNLpri8TX4gR7vQJDpwleQLfWLuB9dhZvOFUqkd868YK0a7Xz2HX4Kq8CUVkuZQ7RO+9OID8Yq/4X/6enEWJKKxKIUM9D+R5vZu6smHYt4UZlxB56ov/8GFt6RxEi1OHEZN3AJV8Sgtb7Lv/H5jp2nM/oKJ5+HJgL93vyWjrJnNaNDi2vG/6OKvAUGAGW9HIvcJ2LktmHHA+P+R2Y6wtFCOulyi5Q+On1X+1B1wyrlkGQpZCARFYvAdD/CG7yVirNj90DUQOlQ7aGPSMnZeNqr9NjR/BGfjnSoDQ/NWVxZ3WqYeb6fjrcWk8U/9PPfz+ti1xertqESuFs3yLMOtRc6unvc8CD/E9e9Qiqjl7gl3VoABDdIXH18hIybgViF+hpQMzl6vJb/
 c7iG9pni
 tUyqLRikiVuLAWC9KqA15QHulevfC74sqc8v/SbtvhLWlzw9xYw+tGA+Qn5T2s1XIwuZULzdyZbT9IIYC2LnjrJ9OZUUM9bhJvmj9DZaUJatbcyqFJDqvLS54FHGdQBNzK5QxxJJvEgr18PN3YmdFstqX+wetnCffM9GOBBBFlc3FcXhQ+eMs0wGzxWgAgaEguK2A1JOvYuPAHzzL86dFOD9cg8BsPvUIrb9c3aTt+qKWa364pQqOeS6VTmFZA//0ChjiQng4RIAm7ws464krUDkVF/PBi0jZ3BH4j3hkURlmSbNQvuX61yF0gBe5ecl/X7ZVBj19tjbWbWNzvUThiucitptr7jR6VpBXmCH4N8WCeN0XasdZTIBa9ZOKx6Yyq9H+M0h2VdywnxawiqCn7bEAGgLXL8a0G6XlnVyjFWR+uByiGIHol5ewF3GCFr9mENHivUCtA9aUffbc+VrHvCEJ7mImUOd/VTQt+4vU0dDpb2SzpgAMtmTC+MHI8kXCZ5nLgnTCIy/77mLjuLvzrNA0+56umFNxhZcploC4frPqbW0x/NszgpyD6d7uyiQeiou6tjyitkzJpretb8i03gRXoO5ufxmlgTqBVR2MBKxkKsIApm+lYxK+bEZrpLaTX4pyOvi/D+nNKtLNrSfd/VNTYQqiOdSPV1NnBfW+cYA2SiV91AUIJHYckQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

The madv_populate and soft-dirty kselftests currently fail on systems
where CONFIG_MEM_SOFT_DIRTY is disabled.

Introduce a new helper softdirty_supported() into vm_util.c/h to ensure
tests are properly skipped when the feature is not enabled.

Link: https://lkml.kernel.org/r/20250917133137.62802-1-lance.yang@linux.dev
Fixes: 9f3265db6ae8 ("selftests: vm: add test for Soft-Dirty PTE bit")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 0389c305ef56cbadca4cbef44affc0ec3213ed30)
---
 tools/testing/selftests/mm/madv_populate.c | 21 +-----
 tools/testing/selftests/mm/soft-dirty.c    |  5 +-
 tools/testing/selftests/mm/vm_util.c       | 77 ++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h       |  1 +
 4 files changed, 84 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index 17bcb07f19f3..7278623acf8c 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -264,23 +264,6 @@ static void test_softdirty(void)
 	munmap(addr, SIZE);
 }
 
-static int system_has_softdirty(void)
-{
-	/*
-	 * There is no way to check if the kernel supports soft-dirty, other
-	 * than by writing to a page and seeing if the bit was set. But the
-	 * tests are intended to check that the bit gets set when it should, so
-	 * doing that check would turn a potentially legitimate fail into a
-	 * skip. Fortunately, we know for sure that arm64 does not support
-	 * soft-dirty. So for now, let's just use the arch as a corse guide.
-	 */
-#if defined(__aarch64__)
-	return 0;
-#else
-	return 1;
-#endif
-}
-
 int main(int argc, char **argv)
 {
 	int nr_tests = 16;
@@ -288,7 +271,7 @@ int main(int argc, char **argv)
 
 	pagesize = getpagesize();
 
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		nr_tests += 5;
 
 	ksft_print_header();
@@ -300,7 +283,7 @@ int main(int argc, char **argv)
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-	if (system_has_softdirty())
+	if (softdirty_supported())
 		test_softdirty();
 
 	err = ksft_get_fail_cnt();
diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 7dbfa53d93a0..7095b95d19ae 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -193,8 +193,11 @@ int main(int argc, char **argv)
 	int pagesize;
 
 	ksft_print_header();
-	ksft_set_plan(15);
 
+	if (!softdirty_supported())
+		ksft_exit_skip("soft-dirty is not support\n");
+
+	ksft_set_plan(15);
 	pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 558c9cd8901c..b2af70d75711 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -97,6 +97,42 @@ uint64_t read_pmd_pagesize(void)
 	return strtoul(buf, NULL, 10);
 }
 
+char *__get_smap_entry(void *addr, const char *pattern, char *buf, size_t len)
+{
+	int ret;
+	FILE *fp;
+	char *entry = NULL;
+	char addr_pattern[MAX_LINE_LENGTH];
+
+	ret = snprintf(addr_pattern, MAX_LINE_LENGTH, "%08lx-",
+		       (unsigned long)addr);
+	if (ret >= MAX_LINE_LENGTH)
+		ksft_exit_fail_msg("%s: Pattern is too long\n", __func__);
+
+	fp = fopen(SMAP_FILE_PATH, "r");
+	if (!fp)
+		ksft_exit_fail_msg("%s: Failed to open file %s\n", __func__,
+				   SMAP_FILE_PATH);
+
+	if (!check_for_pattern(fp, addr_pattern, buf, len))
+		goto err_out;
+
+	/* Fetch the pattern in the same block */
+	if (!check_for_pattern(fp, pattern, buf, len))
+		goto err_out;
+
+	/* Trim trailing newline */
+	entry = strchr(buf, '\n');
+	if (entry)
+		*entry = '\0';
+
+	entry = buf + strlen(pattern);
+
+err_out:
+	fclose(fp);
+	return entry;
+}
+
 bool __check_huge(void *addr, char *pattern, int nr_hpages,
 		  uint64_t hpage_size)
 {
@@ -269,3 +305,44 @@ int uffd_unregister(int uffd, void *addr, uint64_t len)
 
 	return ret;
 }
+
+static bool check_vmflag(void *addr, const char *flag)
+{
+	char buffer[MAX_LINE_LENGTH];
+	const char *flags;
+	size_t flaglen;
+
+	flags = __get_smap_entry(addr, "VmFlags:", buffer, sizeof(buffer));
+	if (!flags)
+		ksft_exit_fail_msg("%s: No VmFlags for %p\n", __func__, addr);
+
+	while (true) {
+		flags += strspn(flags, " ");
+
+		flaglen = strcspn(flags, " ");
+		if (!flaglen)
+			return false;
+
+		if (flaglen == strlen(flag) && !memcmp(flags, flag, flaglen))
+			return true;
+
+		flags += flaglen;
+	}
+}
+
+bool softdirty_supported(void)
+{
+	char *addr;
+	bool supported = false;
+	const size_t pagesize = getpagesize();
+
+	/* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */
+	addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (!addr)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	supported = check_vmflag(addr, "sd");
+	munmap(addr, pagesize);
+	return supported;
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 0c603bec5e20..9816d6e9bce6 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -51,6 +51,7 @@ int uffd_register(int uffd, void *addr, uint64_t len,
 int uffd_unregister(int uffd, void *addr, uint64_t len);
 int uffd_register_with_ioctls(int uffd, void *addr, uint64_t len,
 			      bool miss, bool wp, bool minor, uint64_t *ioctls);
+bool softdirty_supported(void);
 
 /*
  * On ppc64 this will only work with radix 2M hugepage size
-- 
2.49.0


