Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77711F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:20:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B1E6B00C9; Mon,  6 Apr 2026 10:20:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDC156B00CB; Mon,  6 Apr 2026 10:20:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19526B00CC; Mon,  6 Apr 2026 10:20:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C09976B00C9
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:20:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8280214043C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:25 +0000 (UTC)
X-FDA: 84628341210.04.28FCDC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C39571C0003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:20:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6vHFPRT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485224; a=rsa-sha256;
	cv=none;
	b=j0XxBkk7oQSAzm0DEeaLc65ustYnT7a+LnnLPMWKMGwFMjFiSFvswYFUxpOpYnhI5DsREX
	ryukB0iRgRqnaKIDqvExYJLQTdPBlQWI78Snz938X3U6HhshjHRiW/s4exSVrXkUiyIBl7
	RCW52tsVC6ZHE1gPevWOLeOAqhBBOWY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e6vHFPRT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKcX5XuWIjhpMVLPmhhfog+G5o/vN2IuIb3sSnT75aw=;
	b=6CEC6z4xFUGiD7IUoGE8XP60wQ4kh4yfqghG/XGsQYN+fsftzRnMjSDxxZOgl7Y/PQkSE7
	cAgB+ybvJTDQ8Bz0BOeRdB1/XbTSmO3WD+K2op6cOv+jL603zPEvCSlD2mbHy5ghrmNTMd
	dU9ZgYjwsLT9dzv9U+hnr1MHQnqcfZo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E680740BF4;
	Mon,  6 Apr 2026 14:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F93C4CEF7;
	Mon,  6 Apr 2026 14:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485222;
	bh=R/W5pZYTUPbeFRpIiJm6n8WLPptkA9w+3mZt5IDX8BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6vHFPRTbwOhOPl/alglbws9iwwub5pqUgDyGZ/2xxJOmb/eULHZ5c6uM0OJrQ732
	 YJCqNf+S14p4OA1PP74A1tGBTSJQERtAHG2p1IpDxZb62ViZLqGaeXd+c7j7Ze2Nfz
	 WkOacirHsCokvNz9FmfAYc0DwuvhdL7XvBV/EDeDnQVT+75MrKCTMCT6ZxdA2izz0C
	 rMo6sG3Se1zFLkr4fv/7ExXcGeBDnlr+bK4yQjoIo23l28H88/rITX8lKt+1+LiDv4
	 Vs9QujcUUVxrC4ff/F6rU7Nkq6ERu4iV/CRWzCrbduXWx2UnlLu77VKTVoAwTd/4x8
	 C3mP34pt6V/tw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 27/53] selftests/mm: move read_file(), read_num() and write_num() to vm_util
Date: Mon,  6 Apr 2026 17:17:09 +0300
Message-ID: <20260406141735.2179309-28-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fqn9g17rzfhwpcmtrjrbmgyz4x9meaqo
X-Rspamd-Queue-Id: C39571C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775485223-679251
X-HE-Meta: U2FsdGVkX18Wt+5VM1LCCafFM23h3KjVvJSAfyWOuJwDqbcS7Mu2YPQj5A05JTuNpiIljcLUBGI5jDvlB7S0NyWefrtPVqAsPwgjyNmFkCGHRO1s0HnAJ5gLbpTMRYVbq71xfpwYxOEvN3DwYfmmmnUYw+v65Q5H8i+bV0qn352v9o9Fo1iN1KVDnzpLQFGpTLMJ6puZl6zAdi7ykWUDyfFhsfWFg52dQZSOWotwDiX7bjeFjGtZTsXTXLBHehqXTk4kuSEaQMj2tN+Bt5UDFYmnQpX85iFVQgrlLfiKT6BeILPX369CLWZmwoeS0UH/kk0CIn+MYtr/iD2BS6bwfSFukhzIjYtKG0Vgtsvfz9xeSx0PXlvWDOtz3mks+wxnvjjm0ziO/vE/wgp+T4TMKlpgs8uBx0iRLzgy9jN2Y+eSAIJBEiZU3tZFTWVrcA6+tqIaMhh/MXd+63DHLzXC2y5aVHAU/EEKMUqT0ruNr7F/niO7jKQ/wQFzFygYeAtvu/j0VsLe/c/joUXSFqyIHKgDEaEB4LExsR/ilghqFqRc3Tts7GkaAKfQjYyQ6u9zQI4KeF+H6ePSuFaMwzzCubFoTENjYnPLxV4H3daLrOoA75iBjt2qtx26w1PiuJMcaGetp6l3134gjU3uPz9m6kBR3Sm62dXiwbvp00DpUnI6QEo6ul3WHGXVWrMckP8EP4v1REI/uE7PArr3p5jycMzuzXLcremTT0+G65NJ3jSPLYWDUnDLB9HEdgmfDa7NL7bu139pvWk+yXRrNTgaTonLkvBCh2nYcZK+KeYzvVvQdxik+RUNCZdpEbPaCI4ZEhPhiaxv/jClPv51S6WevBc4DAwZiF6MzXSA5tWqq/q1MKX9kocXcgdxY/JA/9ZgJcg1V6WBO4v2+rMk/rkiEJMnRjMrnF7rTqF4fBWt9JwnK/AY3Z6gASuPT1ZGhg1XTlI+h5lyw9U5UJs1+cc
 pcTOhgqh
 e428UtXOxMfkQN7RDSefhMWjWwSsFhY90wA1puujdKovtDmxua3xRJ71E0BJ18uZtg57cjCApOO8k0kK8synEmvL9sX3NJFtolT56OVt+HULXLGQwyRspnH/tJu17jCYpV/hb8+M35i8DgxUAUMQy+oPAeevmu5TeVzh3V8M98bLeORMjgB/0EfcbffuhwWbBDb/OOGadduX/Tf6cH+HKQSdC3YejwPp3oqDdjeaxc+EWclZw34Pk/94P2I0KHXL/s9VdaUU1vJ896/y4okV+rMF1MVfqOwqwUN1s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

These are useful helpers for writing and reading sysfs and proc files.

Make them available to the tests that don't use thp_settings.

While on it make write_num() use "%lu" instead of "%ld" to match
'unsigned long num' argument type.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 41 -------------------
 .../testing/selftests/mm/hugepage_settings.h  |  4 --
 tools/testing/selftests/mm/vm_util.c          | 39 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  3 ++
 4 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 3eef87e812ba..339802ecc8e4 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -48,47 +48,6 @@ static const char * const shmem_enabled_strings[] = {
 	NULL
 };
 
-int read_file(const char *path, char *buf, size_t buflen)
-{
-	int fd;
-	ssize_t numread;
-
-	fd = open(path, O_RDONLY);
-	if (fd == -1)
-		return 0;
-
-	numread = read(fd, buf, buflen - 1);
-	if (numread < 1) {
-		close(fd);
-		return 0;
-	}
-
-	buf[numread] = '\0';
-	close(fd);
-
-	return (unsigned int) numread;
-}
-
-unsigned long read_num(const char *path)
-{
-	char buf[21];
-
-	if (read_file(path, buf, sizeof(buf)) < 0) {
-		perror("read_file()");
-		exit(EXIT_FAILURE);
-	}
-
-	return strtoul(buf, NULL, 10);
-}
-
-void write_num(const char *path, unsigned long num)
-{
-	char buf[21];
-
-	sprintf(buf, "%ld", num);
-	write_file(path, buf, strlen(buf) + 1);
-}
-
 int thp_read_string(const char *name, const char * const strings[])
 {
 	char path[PATH_MAX];
diff --git a/tools/testing/selftests/mm/hugepage_settings.h b/tools/testing/selftests/mm/hugepage_settings.h
index d6a1b4e5f734..3d1a4f18be30 100644
--- a/tools/testing/selftests/mm/hugepage_settings.h
+++ b/tools/testing/selftests/mm/hugepage_settings.h
@@ -66,10 +66,6 @@ struct thp_settings {
 	struct shmem_hugepages_settings shmem_hugepages[NR_ORDERS];
 };
 
-int read_file(const char *path, char *buf, size_t buflen);
-unsigned long read_num(const char *path);
-void write_num(const char *path, unsigned long num);
-
 int thp_read_string(const char *name, const char * const strings[]);
 void thp_write_string(const char *name, const char *val);
 unsigned long thp_read_num(const char *name);
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index e62e2a473123..752566f75c0b 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -699,6 +699,27 @@ int unpoison_memory(unsigned long pfn)
 	return ret > 0 ? 0 : -errno;
 }
 
+int read_file(const char *path, char *buf, size_t buflen)
+{
+	int fd;
+	ssize_t numread;
+
+	fd = open(path, O_RDONLY);
+	if (fd == -1)
+		return 0;
+
+	numread = read(fd, buf, buflen - 1);
+	if (numread < 1) {
+		close(fd);
+		return 0;
+	}
+
+	buf[numread] = '\0';
+	close(fd);
+
+	return (unsigned int) numread;
+}
+
 void write_file(const char *path, const char *buf, size_t buflen)
 {
 	int fd, saved_errno;
@@ -722,3 +743,21 @@ void write_file(const char *path, const char *buf, size_t buflen)
 		ksft_exit_fail_msg("%s write(%.*s) is truncated, expected %zu bytes, got %zd bytes\n",
 				path, (int)(buflen - 1), buf, buflen - 1, numwritten);
 }
+
+unsigned long read_num(const char *path)
+{
+	char buf[21];
+
+	if (read_file(path, buf, sizeof(buf)) < 0)
+		ksft_exit_fail_perror("read_file()");
+
+	return strtoul(buf, NULL, 10);
+}
+
+void write_num(const char *path, unsigned long num)
+{
+	char buf[21];
+
+	sprintf(buf, "%lu", num);
+	write_file(path, buf, strlen(buf) + 1);
+}
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 195bf2e26792..5fc9707f6b9a 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -165,3 +165,6 @@ int unpoison_memory(unsigned long pfn);
 #define PAGEMAP_PFN(ent)	((ent) & ((1ull << 55) - 1))
 
 void write_file(const char *path, const char *buf, size_t buflen);
+int read_file(const char *path, char *buf, size_t buflen);
+unsigned long read_num(const char *path);
+void write_num(const char *path, unsigned long num);
-- 
2.53.0


