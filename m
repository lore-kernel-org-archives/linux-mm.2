Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 426B0CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:32:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5A36B010A; Mon, 11 May 2026 12:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65116B010C; Mon, 11 May 2026 12:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97B0E6B010D; Mon, 11 May 2026 12:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 817896B010A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:32:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42B08C0D9D
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:02 +0000 (UTC)
X-FDA: 84755680884.14.EC63405
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 84BF1180011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:32:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SlFYrPwM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pV5WA6pNleO3ZacWwKIaHU6NvvkCqFrxHw1X8T+FL+k=;
	b=u/uS4OahntCGsx4Pi1JFUeu4klzIJeXmmXYbr9fKtrn4VHIIaK7QsZQZjOP2/LLL1z0nfo
	TnAWNCXsgIEJXw7mQksJoieWKcA/muFc96xpjdkXHP+5jjnuUdUSrUOJ3bCU3J+WspK9H8
	AFt+phRe8IQ+MgSp6itaVgq6zdiTMdo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517120; a=rsa-sha256;
	cv=none;
	b=CcdazIz3B9iAbbCOvN9Mu0XdiNWh00SKiIUHS6sIzcbZgjquwOKfdKxskmB/jpRvYLggmZ
	JtWv0JWUuqMXeX82VpIT5zEt9zGrzOKfg2aOBqFqSe/MznS1BR6jaRJDcfupLdgRh//FgY
	MqsCiXFwp4NWud7eZCOUMGLRwV0hfWc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SlFYrPwM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1B4D43227;
	Mon, 11 May 2026 16:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C47C2BCB0;
	Mon, 11 May 2026 16:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778517119;
	bh=rmP5e2hdK4hiT4tsRu7QEXhstLJKWL/WS7omafjwqSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlFYrPwMR6CMDzRKHDRgD1ICHWASJeFSJRYxma//rVMZoO5SYUjSc339zsmZcjewj
	 FO/8ofCvq/4fESWzoUkv5b40Ipnxnt/6zS01Zh2VjmCfky+ts/KfcVmYWk5ixoQIND
	 RvNvotFZxZpn9cpUSLh9Gotka63yEEB/4iJiRv4WRK4aHlOvSiJCmOMhRIJ03R0wEg
	 UcGfND29NPQPDIFK6cXzSNmdOGvoXlcKiqg3Z4EY204wZGWAYYwCeiel9nivwDn7eY
	 WUf0Qdo8qxSfJhkgsr67UtLCn2tnSP1e3VVOpAfaUEtFT8cmnj0fLeAugA5jGg9J6L
	 RKC9G06Q4XtZw==
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
	Li Wang <li.wang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v4 29/55] selftests/mm: move read_file(), read_num() and write_num() to vm_util
Date: Mon, 11 May 2026 19:28:13 +0300
Message-ID: <20260511162840.375890-30-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 84BF1180011
X-Stat-Signature: zc3ut5ywkdf6x41b1x8sc8nxn9ymf9mi
X-Rspam-User: 
X-HE-Tag: 1778517120-192907
X-HE-Meta: U2FsdGVkX1/auofAUJCR91Yxw/jIzvi/X0vgWTZCj/qX0vcDagSZqi1kA7ZsgqalvvrAB2LbqXbKPcQUoe2+lI4X+TMOeVbBmClhRgrBnibKzIKw2G3qsp1Ag0CWm/keNOrJe4X+A+nfKlFLKLjzEc77Wdt121LTnYzXPx5UYF08uJBuZRttobH7pX793vt71fc7YskuDmCZ2h6+L3zUWJrVslOoIy9/QvYsvT1KSOvsE3aUAYvJKK7EdrSd8YO5YNZuelRZ56LDdsBzRilqkLbcuK7L6BWA9u6y5Anfqo8dOqFGEpbjXt7I3Ha71yCfB9MeFcvIZqufWipNezV4qC95Qs3WC5HALkUCd+70RFr1x/TpuPeQ7kCnelKpi7SotYWrr8KX5vQnXu/nmusfUS+MlgutxY4AV2jJQZrKkSkpr7cyo7BSNA7WKDpYqTFhMcioKoK/KVQ+zDWFcv7E7VZ6a0KfQVNonnkn/Uv05a3UqAhQ6NbRXZKm44nBeeNYI7y7Tyyk3Hyk4yQosIc8VR6G9CIEl0wQTHbAzrsArOr/q92IZeIGKQNJJT7tHKfWLsH0hdrqJFhvJCfgqVL+vTwS0ptsGn4FovdJiuPdfVg2r4ng/WGQyZkoteMbACRjLrwcqKX2ugZUr7CaFwAQ4nd86C/rSDrJT7fDoXHDMIyhJFrvtXtaQQMhd1rFpW931eAv4t/VSzshTT7Y2Zs4TlyR67p/hgsgnmR/fTNkdAy02ms5q/XiL9BW911CEKAx0fPcKnlEvMMlUYLoxC9LYM9StVzPB4rUMoTf4fWV8D+yS5d27YFq3qPIS0/ekX9tSXMfkIKJzcfHL5Ixl8inGM27X1q0uKhd2QkjKgxaix5C6+5OYub8oVfv6CxYc7UugZIeMCYvV5jNyL3zhPMC1HPOwgTuAb5d9kpl2Zjs+8WdRT9YM1c7E82Bv8d9G8V/yiubxeRKLeCnHd7eLtd
 zfoVVkE7
 wFiTZAA2CF5/gOR3JVa/1O/8uXMDWOcgMYsOe7YxA84ybQhZlZSi6n4Gk61sQmH+x5ahC/7SC5oRlf4lBmuYOR8E+wzArq/R972YZVAqe/RFFGWyOPls9VGC4tGqFdo5M1nveX7GPrHkxi0Pk8QBk/Pi/qAvhA1w+jITMzlMtgSBcv8g54ZF6bPe53uptIsgxayrXKr6zuqqzcUu3CqZsdDdUr50EJtzWbcqTSr24vnag/tIRE4GKnmGZEcwHj6SAGhAjOOM3ZQ9TKP1yYipcSSVv9Ud9MFsJJDT5glQpw1ctWmeqnybeOzsC9avcRXI4YH6fAMfHr3kOKFfqUCeEVy4HNW7B32JJwrXIxAxRpzg5PbM=
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

Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 .../testing/selftests/mm/hugepage_settings.c  | 41 -------------------
 .../testing/selftests/mm/hugepage_settings.h  |  4 --
 tools/testing/selftests/mm/vm_util.c          | 39 ++++++++++++++++++
 tools/testing/selftests/mm/vm_util.h          |  3 ++
 4 files changed, 42 insertions(+), 45 deletions(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c b/tools/testing/selftests/mm/hugepage_settings.c
index 01a557f372d1..2eab2110ac6a 100644
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
index c07722b7f102..726c73c43c05 100644
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
index 412e980cce9a..9256bbbe38ea 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -698,6 +698,27 @@ int unpoison_memory(unsigned long pfn)
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
@@ -721,3 +742,21 @@ void write_file(const char *path, const char *buf, size_t buflen)
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


