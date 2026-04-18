Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F387F99C7C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 10:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3A146B026A; Sat, 18 Apr 2026 06:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEB496B026C; Sat, 18 Apr 2026 06:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDA8B6B026D; Sat, 18 Apr 2026 06:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9FCC6B026A
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 06:58:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7E9AB13B07E
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:37 +0000 (UTC)
X-FDA: 84671378274.24.EC3E2DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id C86DF4000B
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 10:58:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HWS9fPfZ;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776509915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DKcX5XuWIjhpMVLPmhhfog+G5o/vN2IuIb3sSnT75aw=;
	b=CneouGz7khkUty1u10gJYG1g7JIDri7TRdQMD2WCDxk7nRgUGbjjl9NrXIVjtml9GAlYNE
	/4TgcYwZqCJkynO162S6K3SbQ/Vdmq83F8mm7KHHZie8yOzMidFyLyC+k4hVysjKQlAr5g
	nF62ZJ8eDCSHhekWsjo22HKQ8tQvUd4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HWS9fPfZ;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776509916; a=rsa-sha256;
	cv=none;
	b=OtU83RXmEF4N9u8YfvjYDpUmpiDCipXoqla2+Wy/r+n28srpp6ARVcNJTw7yKta0LvwTfd
	kHsH5h0x1F1pFmJ2ufstPa1JcskMlK5UQRdrKUgojZ4X3zw1O/0lY2pc4TRsr+Y3Urxid9
	DFSSoh4n9MuGD4sH9mhMM/mqs8j7ukg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CEC6F41970;
	Sat, 18 Apr 2026 10:58:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 129B9C19424;
	Sat, 18 Apr 2026 10:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776509914;
	bh=R/W5pZYTUPbeFRpIiJm6n8WLPptkA9w+3mZt5IDX8BM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWS9fPfZgAB83Q3WLGcrzm56Q2LQmXQ3nVOOJU+QAQ2YafPksiiNDtom38u/IwW4m
	 VPA8h59loEBIeMryRtQUaeGelMlhTiosSUA4MGeRhBVqzg9IHyvxZEX6qv889M7jNE
	 zaBqDtvyfEKXj8d16rEZl5hMyXDJRH/j2YcpBql/1yoPNtODsfDWCUbpwx9v7SxLyi
	 7KXG/YxSmdIwYeRjS4XMpk4arhHiQZ92QTg4S8X3uw7BP7BBdYLQQjGiz3PnFOvYo2
	 z4RBar7H4d/r9H2wMxcqRtyTZ8fPbboiW4L05xZZ4Fo01VY+HZl8vfgTothWBi1QTF
	 6f8VEXT1Nz+kg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
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
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 27/53] selftests/mm: move read_file(), read_num() and write_num() to vm_util
Date: Sat, 18 Apr 2026 13:55:12 +0300
Message-ID: <20260418105539.1261536-28-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z7c5zwcnf9uy8ap3ci191khq7fnf75hg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C86DF4000B
X-HE-Tag: 1776509915-145994
X-HE-Meta: U2FsdGVkX1/Wz/c6YWRsUu8NbwMXCuGtfYHhTWA7e7Es9KW+fTkomQeHzYQFKIY1dw8adkyViIEjkfa/L5m/PUhfAME2VGpWLUDYJ9rrFdZ2Pxo0jX6eYu0ew/bAwxKXmR6R1cLXdH5xI0vDpE2yClRKRS0ysT6sH0OBNUiUwUt6F49fgguEU+DMVK+MhrR8KLBy04xZrXER7evhCosFEomcexW2wlXf03VpljtQAcAnuj9RVooe98Xsi/HWorswhO4Wy2sAGDBq3v/0tnuNCujAQZzU/KKolrtZHHGcRT3iF3bnBxRCf2Vwpp8NDieTLXHX9WND5nEEjXFHAeIDsQ821U1+dVTRisA0NftQzrrcgrZPsl6wSl3k3/KQrmJVQSAaWbQfvY+5wBEw4n0c02WOGXWTGCdI5QaSWrPKXefkAy7fXaNI4ujanDbqldSBaC5JFZyaylDTHlAVeFLxZuK1H3Rqb/TCPGRMRiIKfbxbU4A9+U/QgtGtavez7+RF2u12UeShh15/kOJbikXm4GtSDBsEVQ387C6jJ3ck1YXqcLvY1navXqitmDSauqLzMDI6Zr7aVWPDvEHRlCsxxX2uTT3AYMqlt+WWaybSH//VT1bobDWrQbmPFSAu1DzEOM6BbYRJHsOU3sl7PXr95VDIUusFYnvp7zyYhPG+9w5Cpk8FUXg/1eEnxHGsI0vnoUuk8nmvHQ8xFGS9eo/B2hqrSSmIvr3eAObgU0LVCry4BrDMLDhp5h7fLrBPfIfVwfkt389+JuLP58fAQuFAS9Or4muKTitpxAQg9zyLkSikJv6J+Pt020hYnerQtwkLNj/6dyhOwC278XBxL+mmyuR4btovysiJovlc6rB4XfdYvi/Y8uZI6FR+HioPJeWzw1icMXPhw3XIQohwhM0+PXcdUM+Ei97Hh0AsxbtHLS+wRD7bVqeHp6mSA1DM34i8oia3RAlGEYKTH3HI4vs
 0O3fiNbV
 MK5SLInejMNYgp5/NOn61ptokqHoaW3OkZsQo/Ws1pn6OHV5BpzV5QcCJMW7cSgiLfRQD7KpawZtMuyUyoUoRvBBuD53XYxnXbicq4HUvQRbg8qH1gyLqYXQpgko3DCLzysVwVpRgjVamSFJbyCVCWtQYro9OZwi6bep8qT/q/10XFBs3jyppBdKrul5agphvzbUr9eox+FrU+frCJoxMb8i1SFXJZtpXVcBikbpZqLzp60JfLWEtXzGNBHMqz49NnqP54R/N3PBvzIZlrn/uRmI8H2ugmiuUd+wN
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


