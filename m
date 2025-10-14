Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C538CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 04:59:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4D88E00A3; Tue, 14 Oct 2025 00:59:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C87958E0005; Tue, 14 Oct 2025 00:59:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B618E00A3; Tue, 14 Oct 2025 00:59:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A692F8E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 00:59:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4513511AB76
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:59:49 +0000 (UTC)
X-FDA: 83995517298.04.11D0BB0
Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5977F1C0006
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:59:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf20.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760417987; a=rsa-sha256;
	cv=none;
	b=vc9++wA9V6Uhm6F0y3onYvRLJbuwrTTQgS8o35nKIiKEgJ3aSGkRjDhxoUWRxRrUwhNE7l
	TE7ugZN43qVGhyZeyKDijPB1dZ829XKoM5QTzeBWrcEAsFyYWKlUGBxatYK4lPBbIoWZ0A
	dpfluL3yZa9ryatcmEmVUCMr+JAit4U=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=linux.dev (policy=none);
	spf=pass (imf20.hostedemail.com: domain of ioworker0@gmail.com designates 209.85.215.178 as permitted sender) smtp.mailfrom=ioworker0@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760417987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j7IUlAhB88E0TndW9aY0W3O4BbLrJPatp6viH0im4zM=;
	b=AlDhEZTm5BnyJe7sA7CIUwKgJn/hPQs6ZRCyJIvdT6oOUbpDWUZfSy0pA0UWrmIq1FK9hw
	tQiy/gPZO5w6HhruuzPfXY3I7TRQ82VlZR4pBTvGVDH6aR/+vrALB3Mz5aTGWWTqQFJWQU
	4thNml1xVgseOI7HUDvWjtT/tBWeTpM=
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-b6271ea39f4so3303697a12.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:59:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760417986; x=1761022786;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=j7IUlAhB88E0TndW9aY0W3O4BbLrJPatp6viH0im4zM=;
        b=BPliNFGsk/hLwNX0ZV6dJkwf/IOjX22VKNLSwF6LA7fQ/Wedujx9HSOwasr2igV6wx
         GhLfMqOygFLs6yabUKvJoExRXjN54sVE3NddjZa8TsBXH91qFzYcBW5QxTatjRCbnMnG
         ZJRaq6DDDYu9MgxcCD2YGSbU7A0eFLMQbn03Bzymopu1MxzPs+1W+RpxwuoT/AVMZjHY
         nY/fyLvLCQJIZWn5NaqB7Px5a5TG+gu9x1biW0kUTjIZZ+OzT76IVsgIsGYnpYuDj7gk
         CPUDx8sErpWCElEoS16mz1Ef3zAWQfOMdj3h53zA2xtu7Sl6vKFMiPvvb8a8UZ2D6uAt
         FreA==
X-Gm-Message-State: AOJu0YzebBkWBdl6rrEpt0aH4p8aHSn7wDmdux9Ll2m3c4Bi/Hc28y41
	SfuqqKLolTbDV493PWf58t377xIjamLQpvMvBzFNOQ81yXSKkxwZwPsK
X-Gm-Gg: ASbGncvEMACGbWAOwsf3ie5OOao6QtCHbQNQrfBaNH8/Q32Mk0KwzfLLiXk1ddj54XR
	+ZGqsDnTbNjQeIJk0Vfaj8P9M2h3zAjM1u8WdsmSJZMG9ou+1oijN1ETzq5mZkEt/0RWDDAu+TP
	jGtEK/IKt5FzMDoL3KnXoF08eRQRlNY9vmjRLx/Qjy9009kVy9FdwRpmBw+m9LY2LQFk7rXD5Vh
	uCxlBIiUQQJyoe8VXNUjH5aD2NCXmL/ftiXAjRoIdpWV0VPAmfsugvVi+sDgqnMrWpPGBzYz0gI
	9WnoOb8tU46snDiG45lbSL7yF9LwRoPVjruc4e2LRIR9AlZYXgz7eDTuzFDq1guGsosSoNuEE9S
	MoNcjiJ6eaTsGzWw1zUtIp1XnRv616W5B78WGKWiJ
X-Google-Smtp-Source: AGHT+IFjFdZHGXT/x9wuBsdsKcMSUOCZEq1MwGHaq7Dd+Jdf9jADzgCkgSMal9VmF64Wpt1ilzESQw==
X-Received: by 2002:a17:902:da8e:b0:26a:589b:cf11 with SMTP id d9443c01a7336-29027402d24mr340881805ad.43.1760417986016;
        Mon, 13 Oct 2025 21:59:46 -0700 (PDT)
Received: from EBJ9932692.tcent.cn ([2a11:3:200::202c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034e39727sm149783765ad.51.2025.10.13.21.59.40
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 13 Oct 2025 21:59:45 -0700 (PDT)
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
Subject: [PATCH 6.1.y 1/1] selftests/mm: skip soft-dirty tests when CONFIG_MEM_SOFT_DIRTY is disabled
Date: Tue, 14 Oct 2025 12:59:31 +0800
Message-ID: <20251014045931.86386-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <2025101330-hemstitch-crimson-1681@gregkh>
References: <2025101330-hemstitch-crimson-1681@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5977F1C0006
X-Stat-Signature: 4ugd6grzcuhwt5brk3a335sy36t9mb5t
X-HE-Tag: 1760417987-337058
X-HE-Meta: U2FsdGVkX1+c+XfjgRoFLbRjHO0vkG1YDRQMraHh2HhWSVza3ZRWNX6Z/Iyufat88iyFBfhO/Tq8kfmCyek7DH4e0PlOnSvTW+zQZuh1oOu5WEmgtTHzB29v3Xxq+4sFMRP7TXxcoa6hbOt69p9l2Q0Gu1PDLLo2kFOuXRD6jMmF/2rw6ov8IrAUiuoEs/giAjKsUPUsDqglLbZvrqKtPbYI5JzW5rBzpilnI5hjV9vqvRujVh7FiaWNTWkpsZgCcFgr3LdztEcJdpoysVKZwJbViAkfjlLDCcKlCb0TAnwtAvhOOjxqNkKqyQvNBAkh23XLFP8C+Oyco7StHW6V3CI2stxXD1kTET1doJThQCxyrZMtljsN50/CoGISaUG1NSqbI9+D2JULApvYuphM9ONA/RxlESgZpP6S0cP1oqQ+0F5MqrfUhtvsRPtc1upOX64DiAK3+dZzjqo8EQrPLWOB+LRNLupPipS/egvoY4zd/qA0QmE9pmRQCeI8VtzRCS6NfQGHsZMAJRmRVkw/Bt1WZnfsw0AXK77ZeTdTpQwng7FkvqXL+jktoC6hEXYD22LYsKH3uea3WClb8WQqCt+xDw7khjDfs1nmpQqMsT/wynp2eRF8Fftsb2ds8pRIsoORjZUFs1iVTebS9vkqdLgmOf/yKy84tx5SXYQDzQODPhp2og7Z4WvgzwMAq/Mm0F8+XI135/tGvp1UksBACkRl6vnEHZVDjts5eyVZYMJruBcmIv9+dApbj4PE3YaibdcyG1Er5VZgk0Z8pZYLqSP3xEtPlejMelZQXPZ/EbUUiDWdyZXgLeIupuf+/8blFg7kSCtB4bPAE6ywQR2S7VP+2Pig6kAOmSxhjI85a8NC8noT9uiqVLBS870GYH57r0uS4y2cgjNEPAXzWzXloA78mCAHFiEnLLicFQ/Iuqf9rFJac3e7Dwf9mcQ2fDXbRhb9F+hN7f/+0arAYBg
 tps11lmD
 K67heAUaTfY+FMMQs3Mxbf13c9r1TiWZATiU6S5YmR84NzrEUICsUCtyZrh1hjSbMirA7tsrw8XvIAJDERx9tTE6P3z3o7jR3YEFu9CrMi88i42d/iN4czfW3Y1P90JPP3IlH9NHGYDV8neh9KtNd0njB+C6Z2okJRtnWDKa8yy5CsU8tfkDVV5eSvBY4xwGuXZe1Ybwb1zMn5u5kIlybOId4cQvb3kS/PHfS8OetkGSFBUoQ5LW0q9ogCc5+Xgq4gN3ZPev5XPSEsdsdCwvYlFxrUIW+RG4YfR5CdeEkZs1AcEggupHlMX1LPyp9KzjzGi+Lx6KrfBHmnB4LIzUhqfQF/7+7XC/6BnSU+nwE03s/KRup7taVrEZnOWqvgF7RciPcCZsHaMwuZL8sixbHj3ZnI/yjsYNVhUTCKNFLXDrz/Imq3l7EqTtnWYu4LY5M5iF+/J2HUKh9yVS5T4DAOQjtxbLtJudKlaRzOFMR/gzm6R0iiU32X+rz7mgV/BJapCRkRMgYGJ/ZKxBFyOzASzzGdaICMjLAcaojZmMUCedPgaAZ11eLOPqGhhWGz8HWGcIZvxTmC1LzOAFqh5BU8KAuwGE77swzoYHfdzls5m2dpoSKV3cPIP42Cq79xZLZbondY3ix3F2JBiFX0H6y7gNGtAbkgMfOBkk9IHQR+YKpBdIya6T/lgFNPw==
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
 tools/testing/selftests/vm/madv_populate.c |  9 ++-
 tools/testing/selftests/vm/soft-dirty.c    |  5 +-
 tools/testing/selftests/vm/vm_util.c       | 77 ++++++++++++++++++++++
 tools/testing/selftests/vm/vm_util.h       |  2 +
 4 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vm/madv_populate.c b/tools/testing/selftests/vm/madv_populate.c
index 715a42e8e2cd..f37bda59c18c 100644
--- a/tools/testing/selftests/vm/madv_populate.c
+++ b/tools/testing/selftests/vm/madv_populate.c
@@ -274,12 +274,16 @@ static void test_softdirty(void)
 
 int main(int argc, char **argv)
 {
+	int nr_tests = 16;
 	int err;
 
 	pagesize = getpagesize();
 
+	if (softdirty_supported())
+		nr_tests += 5;
+
 	ksft_print_header();
-	ksft_set_plan(21);
+	ksft_set_plan(nr_tests);
 
 	sense_support();
 	test_prot_read();
@@ -287,7 +291,8 @@ int main(int argc, char **argv)
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-	test_softdirty();
+	if (softdirty_supported())
+		test_softdirty();
 
 	err = ksft_get_fail_cnt();
 	if (err)
diff --git a/tools/testing/selftests/vm/soft-dirty.c b/tools/testing/selftests/vm/soft-dirty.c
index 21d8830c5f24..615ab2d204ef 100644
--- a/tools/testing/selftests/vm/soft-dirty.c
+++ b/tools/testing/selftests/vm/soft-dirty.c
@@ -190,8 +190,11 @@ int main(int argc, char **argv)
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
diff --git a/tools/testing/selftests/vm/vm_util.c b/tools/testing/selftests/vm/vm_util.c
index f11f8adda521..fc5743bc1283 100644
--- a/tools/testing/selftests/vm/vm_util.c
+++ b/tools/testing/selftests/vm/vm_util.c
@@ -72,6 +72,42 @@ uint64_t read_pmd_pagesize(void)
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
@@ -124,3 +160,44 @@ bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size)
 {
 	return __check_huge(addr, "ShmemPmdMapped:", nr_hpages, hpage_size);
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
diff --git a/tools/testing/selftests/vm/vm_util.h b/tools/testing/selftests/vm/vm_util.h
index 5c35de454e08..470f85fe9594 100644
--- a/tools/testing/selftests/vm/vm_util.h
+++ b/tools/testing/selftests/vm/vm_util.h
@@ -1,6 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 #include <stdint.h>
 #include <stdbool.h>
+#include <sys/mman.h>
 
 uint64_t pagemap_get_entry(int fd, char *start);
 bool pagemap_is_softdirty(int fd, char *start);
@@ -10,3 +11,4 @@ uint64_t read_pmd_pagesize(void);
 bool check_huge_anon(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_file(void *addr, int nr_hpages, uint64_t hpage_size);
 bool check_huge_shmem(void *addr, int nr_hpages, uint64_t hpage_size);
+bool softdirty_supported(void);
-- 
2.49.0


