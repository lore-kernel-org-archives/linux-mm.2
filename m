Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4669A606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 03:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=163.com header.i=@163.com header.a=rsa-sha256 header.s=s110527 header.b=J8q9LXeV
Received: by kanga.kvack.org (Postfix)
	id 489956B05B1; Wed, 11 Nov 2026 22:19:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 439BB6B05B2; Wed, 11 Nov 2026 22:19:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F9E6B05B3; Wed, 11 Nov 2026 22:19:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 076386B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:19:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 73766C04B4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:19:02 +0000 (UTC)
X-FDA: 85425010524.17.A1F5B85
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf25.hostedemail.com (Postfix) with ESMTP id ED389A0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:18:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=J8q9LXeV;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=evers_chen@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794453540;
	b=LIufzrks/bdZAxf56J1LoQb8tleszdxHUSXfbQOyS+XscxdG98bC3jFSac6SwDPL8gPw1i
	9OJd5v9kkF3uqlSDDesb7GyNg5bTehuWhCcGy+VjypzvpKVQpcKtkJ8BtORUTncclm/NPu
	qNfdQelBX4obRf/v2kvctGYkdbjZVt0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794453540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OAJSZeu5S+BGy7vQFCxiIgP/IXx1ATwnYQxbK6vospE=;
	b=sJITpBy9qaCUB+b5s0cL/l1ZZ7MEYCGikhTCiVxooumqNxEj5kiPVvaKlNDyRHMdhR6811
	l6b9Xls0mRE8KsuQIsK1qCWBbZdWW2NFUusLXVl8YmrCsAb2hn23LQ3g8qXsjhlAScZMHS
	+pvL4ZB10gXoRFW76EX2Y0Man08rJnw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=J8q9LXeV;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf25.hostedemail.com: domain of evers_chen@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=evers_chen@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=OA
	JSZeu5S+BGy7vQFCxiIgP/IXx1ATwnYQxbK6vospE=; b=J8q9LXeVwUeilZTDiw
	SwlVJGeycGVnVK3XJqd93QTe0PwTpKW3fXyBPJ3b0Ef2tfgDlUO8aTWtgIrvg0bS
	LFLqRubPPuKxfXOlV+VRNsH3X8KZHD5FLmgI9KBJ6o8kUMDpIR3J1a+lTIrEONe+
	YNUPP5YSGNsxrfSrL6851St7M=
Received: from 5219-2604 (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDnl6oRMPVqpjyfFQ--.50271S2;
	Thu, 12 Nov 2026 11:18:46 +0800 (CST)
From: Xionggui Chen <evers_chen@163.com>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shuah Khan <shuah@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chenxionggui@lanxincomputing.com
Subject: [PATCH] selftests/mm: Handle implicit read permissions in madv_populate
Date: Thu, 12 Nov 2026 03:18:11 +0000
Message-ID: <20261112031811.56500-1-evers_chen@163.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDnl6oRMPVqpjyfFQ--.50271S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCw4DtFWxuw1DGw4xAr45Awb_yoWrJr1kpF
	yDJas0vF4rt3ZrA3yxAF17Xrn0yryIyayxXw1xJ3s0vwnxK345Kr47Ka48tFy8JFZ7Xw15
	Ca98ZasFkw4DJaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jFnm_UUUUU=
X-CM-SenderInfo: xhyh22pbfkv0i6rwjhhfrp/xtbC7BYpM2r1MBYfnQAA3b
X-Rspamd-Queue-Id: ED389A0003
X-Rspamd-Server: rspam12
X-Stat-Signature: b4o1tjcsjd3cwohi75r1e1yuthm1xuba
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794453537-316610
X-HE-Meta: U2FsdGVkX1+yrcX431bDHdiKQ4QAFbIogk+VqB5YfM6VeuNl1bZ3rC9JgAEZROBWldRiIfPGsFIGAu0ELRxE2s94Y5Ti7MGXoIZlCAiH3E781g3mhUMFyHz+KsS9AwdWnwtTr2upyAuNRweK9GsWrFE8Ttf0QTHCENm+NBVvh/q99LWhVMu83H+1G3+OCVA/r8iRAJNN/IZYYSqWj2wFh0suzxbGvYUsKlchPXRzwlr6gs1kh/6Fla5bp5mXOnTx4zfg55bIsmsDD2gMlZ5EIMc/O0toRZO3vVjxlnWmEKLVCaZumEuLGST5hnE1tfe2rTNtuhywD6K13WjEwq6av6bHJJctCJygnKyiJtGZfhaO9ptSrVUlW/KT7QSAzeF0cnP1lZbakOjNhp7pvcOvsB3yK/gFP4WhCevMXBvIqWn5hYtdeMsnz6fD7s+a2B1Od9cNE+/Z38GkZi7KBn1ycWCJ2J6Etfw0dn9633Rgieoak1P4Pqfq3J6y4+D171I6WIPTTXH7m37Cq48EK5f5kH66hpN0GZtDwqsl9p1J5M6cuZgmB4gmH/2KB5n57nPGVtllaCBKuGhs9F9n/6/DAX1NLj37ll51R4cel0NXRIKbsszaF9j6XuJ354PHDAAmbTcocKqThnZvvx1kzi9FSQAVo0xl8fg3sMKvESpoojxRlY3iWZTJg0meNYupC29DOR+761trHLfW4aarX73NQxSGLzMdIcxxrvtO9W6A6rYe9fQK8ddAdXEgazzwAbAuC0hM/H2Hb9Rv0Fx7C0VZNpdwgRfUswxtrq/9z9hVl9+P2e05famD7icyJTIpJtRz/wRZ7ww5hDzl9IqTkHtanZ6Nkaskrc3yzCSszbbBPZyNrV2Ythdigo9MYiPNof65Snb6Y+v8lsxlXJxatTsV0mlgkFrtTy7WsaXrmB6/YHx48/a1ZuOC9gBrglycb/Dc0elKMeMg0BIGmIzyIJw
 DpvyLZQS
 /rph2jeWoxdYFHzBWJBFsMLgEJ8TjVtYXqKlq7WKkUtyUPr8JUaRI+NWPYiaVTyw9wGQ3qHlEX2NfQ0Br2mR2tIcZ2nZJ4l5P4V409DautxlptV9Il9MMedYeqFsgSo5kTFnYOJeIEnvJ4pnhlB3BkRim5CRSrgZuAcBLu05xsCfeUR629x5XY16tgEnBkeyhPOAnYn6XwgEpXR1k8PjwjXSs3mHwFRKzl7pyXjJsobwCaxnW26SIpVpRcfnla0lnCARaaYhnPZYMAFhwJr69GQuqF9BrjrqKPWu9EfIAcnhJF3k2DhNaLWNJywMlAN3UnzefPUBBi5HYMc0RKpMjopLKLLC/UNr9KZZukFcXrqt5cK9O9kjxxPEfzFaru5g4FoYB51DKTeC+gSYgL+YzrDeqavy4aR7O5W/V4atuMr2JLsgNpstsUzzdtbNZQSIgUFkirRXc+wGaI2wVpYmUMYY5P/PjCtivyutm3BaRx7huQo5mbKLrfDjTkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xionggui Chen <chenxionggui@lanxincomputing.com>

The madv_populate selftest assumes that a mapping created with
PROT_WRITE cannot be read, and expects MADV_POPULATE_READ to fail
with EINVAL.

However, some architectures, including RISC-V, may implicitly grant
read permission to PROT_WRITE mappings. On such architectures,
MADV_POPULATE_READ succeeds, causing the test to fail incorrectly.

Check the actual VMA permissions through /proc/self/maps and adjust
the expected result accordingly.

Add a PROT_NONE test to verify that MADV_POPULATE_READ still fails
with EINVAL for mappings without read permission.

On RISC-V with Linux 7.2.0, the original test fails 1 out of 16
tests, while the updated test passes all 17 tests.

Signed-off-by: Xionggui Chen <chenxionggui@lanxincomputing.com>
---
 tools/testing/selftests/mm/madv_populate.c | 67 ++++++++++++++++++++--
 1 file changed, 63 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/testing/selftests/mm/madv_populate.c
index 7fce5d0b622b..818f99ee2004 100644
--- a/tools/testing/selftests/mm/madv_populate.c
+++ b/tools/testing/selftests/mm/madv_populate.c
@@ -69,10 +69,38 @@ static void test_prot_read(void)
 	munmap(addr, SIZE);
 }
 
+static int mapping_is_readable(void *addr)
+{
+	FILE *maps;
+	char line[256];
+	unsigned long start, end;
+	char perms[5];
+	int readable = -1;
+
+	maps = fopen("/proc/self/maps", "r");
+	if (!maps)
+		return -1;
+
+	while (fgets(line, sizeof(line), maps)) {
+		if (sscanf(line, "%lx-%lx %4s",
+			   &start, &end, perms) != 3)
+			continue;
+
+		if (start <= (unsigned long)addr &&
+		    (unsigned long)addr < end) {
+			readable = perms[0] == 'r';
+			break;
+		}
+	}
+
+	fclose(maps);
+	return readable;
+}
+
 static void test_prot_write(void)
 {
 	char *addr;
-	int ret;
+	int ret, readable;
 
 	ksft_print_msg("[RUN] %s\n", __func__);
 
@@ -80,9 +108,19 @@ static void test_prot_write(void)
 	if (addr == MAP_FAILED)
 		ksft_exit_fail_msg("mmap failed\n");
 
+	readable = mapping_is_readable(addr);
+	if (readable < 0)
+		ksft_exit_fail_msg("Cannot determine VMA permissions\n");
+
+	errno = 0;
 	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
-	ksft_test_result(ret == -1 && errno == EINVAL,
-			 "MADV_POPULATE_READ with PROT_WRITE\n");
+
+	if (readable)
+		ksft_test_result(ret == 0,
+				 "MADV_POPULATE_READ with readable PROT_WRITE mapping\n");
+	else
+		ksft_test_result(ret == -1 && errno == EINVAL,
+				 "MADV_POPULATE_READ with write-only mapping\n");
 
 	ret = madvise(addr, SIZE, MADV_POPULATE_WRITE);
 	ksft_test_result(!ret, "MADV_POPULATE_WRITE with PROT_WRITE\n");
@@ -90,6 +128,26 @@ static void test_prot_write(void)
 	munmap(addr, SIZE);
 }
 
+static void test_prot_none(void)
+{
+	char *addr;
+	int ret;
+
+	ksft_print_msg("[RUN] %s\n", __func__);
+
+	addr = mmap(0, SIZE, PROT_NONE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed\n");
+
+	errno = 0;
+	ret = madvise(addr, SIZE, MADV_POPULATE_READ);
+	ksft_test_result(ret == -1 && errno == EINVAL,
+			 "MADV_POPULATE_READ with PROT_NONE\n");
+
+	munmap(addr, SIZE);
+}
+
 static void test_holes(void)
 {
 	char *addr;
@@ -266,7 +324,7 @@ static void test_softdirty(void)
 
 int main(int argc, char **argv)
 {
-	int nr_tests = 16;
+	int nr_tests = 17;
 	int err;
 
 	pagesize = getpagesize();
@@ -280,6 +338,7 @@ int main(int argc, char **argv)
 	sense_support();
 	test_prot_read();
 	test_prot_write();
+	test_prot_none();
 	test_holes();
 	test_populate_read();
 	test_populate_write();
-- 
2.53.0


