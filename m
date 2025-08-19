Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39313CA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:01:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9186B010D; Tue, 19 Aug 2025 04:01:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A9E56B010F; Tue, 19 Aug 2025 04:01:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5996D6B0110; Tue, 19 Aug 2025 04:01:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D2516B010D
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:01:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0D5D51602DF
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:26 +0000 (UTC)
X-FDA: 83792762172.01.4F20463
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 36E8440006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:01:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nOFQvZAf;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755590484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=dUEjiJUWp4amXqR33SO/yGjIcZw0D6rrcyNI4+UM1tw=;
	b=iTVJ4lB0G2pe9bxEdN1sz7YoY1K5vBK9duX1TTTzb5oza1XlV5bSI3Kn9D1ogMMFUi2jFW
	cnr3lvu69Yp7xCwew0ZaBdAe8JBwBuDlLJHb7t9tTvbZgQRxVHHtBzLN2MICzgkte55uXi
	Be/vCC6JlmyZD6O3rLsKQPou4IOhEWo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nOFQvZAf;
	spf=pass (imf11.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755590484; a=rsa-sha256;
	cv=none;
	b=UEap9drlWMFDRs7TDQlckIg6o1csNzrE8Wiy/dXZm/63P9BPI5EkTLSrO61HJW0dHRJQ/p
	Yu+Eg8HCLQJsqfq14k3YXVz1vZHogj3u85bYcF5LMBuA6atEd/HCzmUCvfcQEzH4uMsMqG
	3ChsQYd0tJHNc49briy7lTVStMcQU3w=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61a2a5b06cdso4147780a12.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 01:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755590483; x=1756195283; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dUEjiJUWp4amXqR33SO/yGjIcZw0D6rrcyNI4+UM1tw=;
        b=nOFQvZAfFlIXT9SqpQAJyOA4ma+57h2G7F+J2fzLIey5p3xe+6Tw6Iu5Yi6wYfY49S
         sSzW6U1bMHcY4z3V0RyaAmVT0yJb6tys4SDI5UU7aQEevoLaohBXkZn1vcFHg8X5Kw8t
         La86sH+Vuzu0hIlpkwDwnE+wtUKSFuDWZj2v4BUHRFr1eFBw0ryzuJXpozaosIVbELQZ
         weF8qL+DQQ58OUkNzqU4F+XR1RbG4LRqhUAwq5zq3vgbAxky08phEpY4L6+8mpIuSKon
         Q5TeG7QfRBZcOGOqIaaHTzUwgJSCLBmIM5V0oMwVSWLezQ5sM7+WT970NvUOCi2A1fMl
         LuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755590483; x=1756195283;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dUEjiJUWp4amXqR33SO/yGjIcZw0D6rrcyNI4+UM1tw=;
        b=HsglfCniPTvfnDiQbBsnLnx+5SxIed2x7VZAGag1YrweHRXjhZhtH58vw963FHqUGS
         hW6/4QLMWIRBDiYRR7YEPmlURWUCZ6OiNeQrlcE7O+iJfkzZCbdU5FPAhWpQ2mqKNlnT
         kYFKgW7RdURieZwWsOE46wJIfFT4mAIBSP//yvP4R1mXEckZ+t5xf/yI3EoO3s6Dr+SV
         Q3JAcrE053eM2dVceNLiU1BFL0XmfDt27mwt1qSu0LiuxJBFg84urEpd6UeYIhMOGyqC
         lzfrKx65Fp0sUTThUtfGXciWolu0Ohul2uIUt+H0HKWMVISaZVXgywtiif2wQXQt6DnG
         sj/w==
X-Gm-Message-State: AOJu0Yze/1vLDsRTWyAs0uT9ri5yz8Gprj13qHFiSusUPvngwdu77rms
	ZYGmZw2aZkidPHTCxW1vUJ0gdJ8nkTg8bEkWpbt3jtcPCQJtnbaIM4+n
X-Gm-Gg: ASbGncsF3jKtXtJCRDNh1x/4OaBYsMCOMzrmReEE3a5JUzTpk5SQYT2EZhwZtIDqn+7
	xg9lfwdlE0QO1dI7/ISK9mW++xSaFd1lpas5Fn1esfgc8bHsGWCfBAOypJBo5+ik2rmBzmE+OEo
	qwJsTpvmsMkqLPlAebHUbPCKrGE8sjhWHIoe64PkIVfx1/mbIVLujtL+KB7x+dWZNeI5Ds9sjVq
	8Xkwa7h7yh2Uwylwl1mxYL3PGI6fB6Zn7omE/OG+vnPtueumyTJu5bUb+JV9Jn3MK7ouo/a47Xw
	ygO2b9Bfarc/iOOHZ2AvHRFM9Qj/SfRsBFVSPgxovDg8YPLVgyJnaw7ZYZK/2mRSdqugQiMQsfA
	8i+qbFAD3Ro//LM/L119vEw==
X-Google-Smtp-Source: AGHT+IGYH+GLozlliCz8dnrxRkcTHgLAbXUdWUKiAaB10MSZj3LcUE83TSctDVhucTKREa1Od/TXKg==
X-Received: by 2002:a17:906:c145:b0:ae0:686a:870f with SMTP id a640c23a62f3a-afddcbd9064mr173580066b.15.1755590482159;
        Tue, 19 Aug 2025 01:01:22 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce72dbdsm987263766b.43.2025.08.19.01.01.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Aug 2025 01:01:21 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	riel@surriel.com,
	harry.yoo@oracle.com
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v4 1/2] selftests/mm: put general ksm operation into vm_util
Date: Tue, 19 Aug 2025 08:00:46 +0000
Message-Id: <20250819080047.10063-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20250819080047.10063-1-richard.weiyang@gmail.com>
References: <20250819080047.10063-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 36E8440006
X-Stat-Signature: kfxo7fs3h9wip74hoa4te81i5djt6ubw
X-Rspam-User: 
X-HE-Tag: 1755590483-509399
X-HE-Meta: U2FsdGVkX182wiWnjy3f7qBI7Vc/r69eCnAP+tciNZSVdGgsK9QxUOuQOnqVg67i++z0ev95LNh3X8qqsmipO/QdbJ2tTjxn7c7AVgmL/4Ifk9Pv4n6HL6cYucudEKrmTQfS/EDsTioXyNUmhECchhXdmybwMYx8LaqkQv1GxGZ4N6pO4og3WCBs5+r/yhsauBfY9fiO4h1mjtfHmO78SsUT3L6iHkQIJZ9Tcg45TNSuiLFXgPQUXdz2Eo1pOqu1q54uQaWokGkrYRndI1apbphiCYyE1m20I2yDD3T/fJV0/sQqcpn/PNWKvsOB6b1jv0t8CyHYlLoEiloz9wt1JHYpaqIVCtu4680EXiLjxIIIiSyZFMCQmjwGtY4Dk0UMtr4An9Gy0F1t73/nxTjZPnL89X61OXOYZJLaJEYhDDSIsz9jWbxHDsDXIzDLA526jcy4LIl4OpqSYLu1v5lsL6yWDL67nZXL5quiGf03e5nyf/BxINQjNQ0Z3MIXvd7myDcmFjdp1v9ricAl2+N/FL9zgwUnZ89ZgsNMapJEAY97Ser9DBCGr/ZulodTqqcC/YGIRcMjdotHDJ4GoI8KLjAurYRCl+lgD1KbfLXoQtWyILdZqEB7uWS64224d+1A6juESQnZ3JlEiWTZmD0sEZK3smx0CeNMD7gIRK58YldhRmUEkgiX7HuW9wHEiI7WlPZ5cyrq/HZqBihMH5MLhR1VM0Igd1t52/JLmKX0ENK3V4QnIKbBFFlN1o9Kl8brPrryrUqL4KAZ8Ie2VZWtcyEiYYQV7aTP5m8Hl4IPqtGET0a0GTMAzkYQnu1OSpRavcrzg4WuQ6g+G1yD4tLHPgb4WWB5InMzQclw7x5YaPDtSBJpdwGj5e8HYHrMGGYP/fkfW4jGaJmW+0lmKG5CASxhHVMyIxM5/2BqD+YdlSHohYs068PPFYrYCMdXvwx/uQZwD+96L7OA1zrg+kx
 KbMyd2RG
 xAQCMqHvWhJSsUsWfzuOZS1xZ6Cl1bV4WUaJwaXwWwjm33d1bhDI/JSBsvkdJzb2dRW7TC0KI1S5C6VL0xfOBr5TZ8y3/A0gu//DWsomLtqtZ3iDGg+0o7gVP87ze/Tr5npKu5gp6m1T82MZCq7YHr2y6zDxIIILapPvR0uP8c9bCAdm/Qyw29RnRKSvgTGQJXYaEiFeVGf5wfQaiPxDCwIOaqqe/H9+Wpn2cjzsEkLkBez7dVx7MOhy7CC3aDfJrTxuY2s7T0eRzfykW/qnFTROKwo2tsD965o5VaMCEGPUQJrn1irAoANIC0BKUSF35Z9biiuxdR70KNIfQJfFWDUfCG8DRDCx85hGTuzseE8NUy+QxaKHTba3fxwF+XzcKjnSks/F7MowzAkJK0RbR48/DkKEgfSI0e+J1QPam3dNoRDitdOzQggdwTxTbZx7bt5NU3ssuMoVNjFQmAA7sdgak4yIhkyWusJhy5QXZ1Xhuy4HrjFs16CU3qLrXUyjiMOrv7jCSQR+fAGOwQxCHOXfuZrPt2An4ZmFtzgckuhVdzT/bw1A8HecpEZsNn8C7sV411yfrgh5qfjzSbW4cyR0ici4Geh0Z63FKaAF2qnM1/FAs+LrKTL2tI8GlTxJKJ1ySPEz739Mvx39O6sa/NItGSh/iZhgYXf8ZUvqkDKxaHh4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are some general ksm operations could be used by other related
test cases. Put them into vm_util for common use.

This is a preparation patch for later use.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>

---
v4:
  * rebase on mm-new(dd1510cefdfe)
v3:
  * rebase on latest mm-unstable
v2:
  * do check on file opening in init_global_file_handlers()
  * factor out ksm_merge() and ksm_unmerge() instead of partial of it
  * align the return value of helpers: 0 on success, -errno on error
v1: open/close fd in function itself instead of pass as parameter
---
 .../selftests/mm/ksm_functional_tests.c       | 142 +++---------------
 tools/testing/selftests/mm/vm_util.c          | 123 +++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |   7 +
 3 files changed, 154 insertions(+), 118 deletions(-)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index 534aa405cac7..712f43c87736 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -38,11 +38,6 @@ enum ksm_merge_mode {
 };
 
 static int mem_fd;
-static int ksm_fd;
-static int ksm_full_scans_fd;
-static int proc_self_ksm_stat_fd;
-static int proc_self_ksm_merging_pages_fd;
-static int ksm_use_zero_pages_fd;
 static int pagemap_fd;
 static size_t pagesize;
 
@@ -75,88 +70,6 @@ static bool range_maps_duplicates(char *addr, unsigned long size)
 	return false;
 }
 
-static long get_my_ksm_zero_pages(void)
-{
-	char buf[200];
-	char *substr_ksm_zero;
-	size_t value_pos;
-	ssize_t read_size;
-	unsigned long my_ksm_zero_pages;
-
-	if (!proc_self_ksm_stat_fd)
-		return 0;
-
-	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
-	if (read_size < 0)
-		return -errno;
-
-	buf[read_size] = 0;
-
-	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
-	if (!substr_ksm_zero)
-		return 0;
-
-	value_pos = strcspn(substr_ksm_zero, "0123456789");
-	my_ksm_zero_pages = strtol(substr_ksm_zero + value_pos, NULL, 10);
-
-	return my_ksm_zero_pages;
-}
-
-static long get_my_merging_pages(void)
-{
-	char buf[10];
-	ssize_t ret;
-
-	if (proc_self_ksm_merging_pages_fd < 0)
-		return proc_self_ksm_merging_pages_fd;
-
-	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
-	if (ret <= 0)
-		return -errno;
-	buf[ret] = 0;
-
-	return strtol(buf, NULL, 10);
-}
-
-static long ksm_get_full_scans(void)
-{
-	char buf[10];
-	ssize_t ret;
-
-	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
-	if (ret <= 0)
-		return -errno;
-	buf[ret] = 0;
-
-	return strtol(buf, NULL, 10);
-}
-
-static int ksm_merge(void)
-{
-	long start_scans, end_scans;
-
-	/* Wait for two full scans such that any possible merging happened. */
-	start_scans = ksm_get_full_scans();
-	if (start_scans < 0)
-		return start_scans;
-	if (write(ksm_fd, "1", 1) != 1)
-		return -errno;
-	do {
-		end_scans = ksm_get_full_scans();
-		if (end_scans < 0)
-			return end_scans;
-	} while (end_scans < start_scans + 2);
-
-	return 0;
-}
-
-static int ksm_unmerge(void)
-{
-	if (write(ksm_fd, "2", 1) != 1)
-		return -errno;
-	return 0;
-}
-
 static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 				  enum ksm_merge_mode mode)
 {
@@ -165,12 +78,12 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	int ret;
 
 	/* Stabilize accounting by disabling KSM completely. */
-	if (ksm_unmerge()) {
+	if (ksm_stop() < 0) {
 		ksft_print_msg("Disabling (unmerging) KSM failed\n");
 		return err_map;
 	}
 
-	if (get_my_merging_pages() > 0) {
+	if (ksm_get_self_merging_pages() > 0) {
 		ksft_print_msg("Still pages merged\n");
 		return err_map;
 	}
@@ -220,7 +133,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	}
 
 	/* Run KSM to trigger merging and wait. */
-	if (ksm_merge()) {
+	if (ksm_start() < 0) {
 		ksft_print_msg("Running KSM failed\n");
 		goto unmap;
 	}
@@ -229,7 +142,7 @@ static char *__mmap_and_merge_range(char val, unsigned long size, int prot,
 	 * Check if anything was merged at all. Ignore the zero page that is
 	 * accounted differently (depending on kernel support).
 	 */
-	if (val && !get_my_merging_pages()) {
+	if (val && !ksm_get_self_merging_pages()) {
 		ksft_print_msg("No pages got merged\n");
 		goto unmap;
 	}
@@ -276,7 +189,7 @@ static void test_unmerge(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
-	ksm_unmerge();
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -289,15 +202,12 @@ static void test_unmerge_zero_pages(void)
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
-	if (proc_self_ksm_stat_fd < 0) {
-		ksft_test_result_skip("open(\"/proc/self/ksm_stat\") failed\n");
-		return;
-	}
-	if (ksm_use_zero_pages_fd < 0) {
-		ksft_test_result_skip("open \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
+	if (ksm_get_self_zero_pages() < 0) {
+		ksft_test_result_skip("accessing \"/proc/self/ksm_stat\" failed\n");
 		return;
 	}
-	if (write(ksm_use_zero_pages_fd, "1", 1) != 1) {
+
+	if (ksm_use_zero_pages() < 0) {
 		ksft_test_result_skip("write \"/sys/kernel/mm/ksm/use_zero_pages\" failed\n");
 		return;
 	}
@@ -309,7 +219,7 @@ static void test_unmerge_zero_pages(void)
 
 	/* Check if ksm_zero_pages is updated correctly after KSM merging */
 	pages_expected = size / pagesize;
-	if (pages_expected != get_my_ksm_zero_pages()) {
+	if (pages_expected != ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after merging\n");
 		goto unmap;
 	}
@@ -322,7 +232,7 @@ static void test_unmerge_zero_pages(void)
 
 	/* Check if ksm_zero_pages is updated correctly after unmerging */
 	pages_expected /= 2;
-	if (pages_expected != get_my_ksm_zero_pages()) {
+	if (pages_expected != ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after unmerging\n");
 		goto unmap;
 	}
@@ -332,7 +242,7 @@ static void test_unmerge_zero_pages(void)
 		*((unsigned int *)&map[offs]) = offs;
 
 	/* Now we should have no zeropages remaining. */
-	if (get_my_ksm_zero_pages()) {
+	if (ksm_get_self_zero_pages()) {
 		ksft_test_result_fail("'ksm_zero_pages' updated after write fault\n");
 		goto unmap;
 	}
@@ -341,7 +251,7 @@ static void test_unmerge_zero_pages(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			"KSM zero pages were unmerged\n");
 unmap:
-	ksm_unmerge();
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -370,7 +280,7 @@ static void test_unmerge_discarded(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
-	ksm_unmerge();
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -457,7 +367,7 @@ static void test_unmerge_uffd_wp(void)
 close_uffd:
 	close(uffd);
 unmap:
-	ksm_unmerge();
+	ksm_stop();
 	munmap(map, size);
 }
 #endif
@@ -521,7 +431,7 @@ static int test_child_ksm(void)
 	else if (map == MAP_MERGE_SKIP)
 		return 3;
 
-	ksm_unmerge();
+	ksm_stop();
 	munmap(map, size);
 	return 0;
 }
@@ -654,7 +564,7 @@ static void test_prctl_unmerge(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
-	ksm_unmerge();
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -688,7 +598,7 @@ static void test_prot_none(void)
 	ksft_test_result(!range_maps_duplicates(map, size),
 			 "Pages were unmerged\n");
 unmap:
-	ksm_unmerge();
+	ksm_stop();
 	munmap(map, size);
 }
 
@@ -697,19 +607,15 @@ static void init_global_file_handles(void)
 	mem_fd = open("/proc/self/mem", O_RDWR);
 	if (mem_fd < 0)
 		ksft_exit_fail_msg("opening /proc/self/mem failed\n");
-	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
-	if (ksm_fd < 0)
-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/run\") failed\n");
-	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
-	if (ksm_full_scans_fd < 0)
-		ksft_exit_skip("open(\"/sys/kernel/mm/ksm/full_scans\") failed\n");
+	if (ksm_stop() < 0)
+		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/run\") failed\n");
+	if (ksm_get_full_scans() < 0)
+		ksft_exit_skip("accessing \"/sys/kernel/mm/ksm/full_scans\") failed\n");
 	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
-	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
-	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
-						O_RDONLY);
-	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+	if (ksm_get_self_merging_pages() < 0)
+		ksft_exit_skip("accessing \"/proc/self/ksm_merging_pages\") failed\n");
 }
 
 int main(int argc, char **argv)
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 6a239aa413e2..ab7271ed5ff3 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -565,3 +565,126 @@ bool detect_huge_zeropage(void)
 	close(fd);
 	return enabled;
 }
+
+long ksm_get_self_zero_pages(void)
+{
+	int proc_self_ksm_stat_fd;
+	char buf[200];
+	char *substr_ksm_zero;
+	size_t value_pos;
+	ssize_t read_size;
+
+	proc_self_ksm_stat_fd = open("/proc/self/ksm_stat", O_RDONLY);
+	if (proc_self_ksm_stat_fd < 0)
+		return -errno;
+
+	read_size = pread(proc_self_ksm_stat_fd, buf, sizeof(buf) - 1, 0);
+	close(proc_self_ksm_stat_fd);
+	if (read_size < 0)
+		return -errno;
+
+	buf[read_size] = 0;
+
+	substr_ksm_zero = strstr(buf, "ksm_zero_pages");
+	if (!substr_ksm_zero)
+		return 0;
+
+	value_pos = strcspn(substr_ksm_zero, "0123456789");
+	return strtol(substr_ksm_zero + value_pos, NULL, 10);
+}
+
+long ksm_get_self_merging_pages(void)
+{
+	int proc_self_ksm_merging_pages_fd;
+	char buf[10];
+	ssize_t ret;
+
+	proc_self_ksm_merging_pages_fd = open("/proc/self/ksm_merging_pages",
+						O_RDONLY);
+	if (proc_self_ksm_merging_pages_fd < 0)
+		return -errno;
+
+	ret = pread(proc_self_ksm_merging_pages_fd, buf, sizeof(buf) - 1, 0);
+	close(proc_self_ksm_merging_pages_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+long ksm_get_full_scans(void)
+{
+	int ksm_full_scans_fd;
+	char buf[10];
+	ssize_t ret;
+
+	ksm_full_scans_fd = open("/sys/kernel/mm/ksm/full_scans", O_RDONLY);
+	if (ksm_full_scans_fd < 0)
+		return -errno;
+
+	ret = pread(ksm_full_scans_fd, buf, sizeof(buf) - 1, 0);
+	close(ksm_full_scans_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+int ksm_use_zero_pages(void)
+{
+	int ksm_use_zero_pages_fd;
+	ssize_t ret;
+
+	ksm_use_zero_pages_fd = open("/sys/kernel/mm/ksm/use_zero_pages", O_RDWR);
+	if (ksm_use_zero_pages_fd < 0)
+		return -errno;
+
+	ret = write(ksm_use_zero_pages_fd, "1", 1);
+	close(ksm_use_zero_pages_fd);
+	return ret == 1 ? 0 : -errno;
+}
+
+int ksm_start(void)
+{
+	int ksm_fd;
+	ssize_t ret;
+	long start_scans, end_scans;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	/* Wait for two full scans such that any possible merging happened. */
+	start_scans = ksm_get_full_scans();
+	if (start_scans < 0) {
+		close(ksm_fd);
+		return start_scans;
+	}
+	ret = write(ksm_fd, "1", 1);
+	close(ksm_fd);
+	if (ret != 1)
+		return -errno;
+	do {
+		end_scans = ksm_get_full_scans();
+		if (end_scans < 0)
+			return end_scans;
+	} while (end_scans < start_scans + 2);
+
+	return 0;
+}
+
+int ksm_stop(void)
+{
+	int ksm_fd;
+	ssize_t ret;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	ret = write(ksm_fd, "2", 1);
+	close(ksm_fd);
+	return ret == 1 ? 0 : -errno;
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 3da56feeb944..1f9a90668758 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -135,6 +135,13 @@ static inline int sz2ord(size_t size, size_t pagesize)
 void *sys_mremap(void *old_address, unsigned long old_size,
 		 unsigned long new_size, int flags, void *new_address);
 
+long ksm_get_self_zero_pages(void);
+long ksm_get_self_merging_pages(void);
+long ksm_get_full_scans(void);
+int ksm_use_zero_pages(void);
+int ksm_start(void);
+int ksm_stop(void);
+
 /*
  * On ppc64 this will only work with radix 2M hugepage size
  */
-- 
2.34.1


