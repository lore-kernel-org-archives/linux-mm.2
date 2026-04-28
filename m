Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DD62FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5366B00C9; Tue, 28 Apr 2026 16:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9C3A6B00CA; Tue, 28 Apr 2026 16:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2306B00CB; Tue, 28 Apr 2026 16:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BC60C6B00C9
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:45:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C4551B88EB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:58 +0000 (UTC)
X-FDA: 84709146396.23.C8A9BEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id BBFCA1A000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:45:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXAX8Zde;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MnG0RCpwZ2n3ZG7h/8XnCCbLoKFE/IRVPfFaCildiK4=;
	b=ij+MMgpNWF/ZzpBtstGYPH0/7O+msZWayAS75OaG6NVsBq240MB+d483p0IuNsOUR0DHyd
	lN7VN/ppf6sw6CNNZShtdb9KW2mNsNx22Jutl+qgiQpQirXEUo6Rdyi4fP5qzaviaHBJFv
	4Av0FxWtWXDYEyYuuIc+kc3wTOX4gOQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409156; a=rsa-sha256;
	cv=none;
	b=wGOtfTPcbTmEc9r+smL93AT6YZKjcSHMtKrVQnmub5lxJ78Xb9D0NtMme0LDcy2L1EQVas
	g1PoZjdk/+jB8IHuvohZ7QwMpY8ieiq14y08d49ixsVGa2NMSTPc4N1xxF4lVSwWD2Ke7N
	xFZKKGhFfMT3HK/z58Dbkd+kijAHnR8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SXAX8Zde;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAEF140056;
	Tue, 28 Apr 2026 20:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF0B7C2BCAF;
	Tue, 28 Apr 2026 20:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409155;
	bh=gpSR6Q48MYhV0thDfaQc0u3uDky+1QVh/9VDybETiJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SXAX8ZdeY0TzLzh/4N6hGDybK1UkN0xYH7D0pq4KuLPf6Jiu0cR1w0SoTuounRAFK
	 iL3XykeSo3R0SjXZV/6gpIw0eOClOQwg/JkmgAIJdyJi49fuf/+/pqB82a/aJFFadF
	 8Xvwl7MEt67qVx1MxGisg3npyZ42rophkfR8ZLbKBkcmPnhmTYvRNb/divay4JN0fB
	 ca6PZG1Fg0Ed8Gr26IEiAEz+DUG4YA2zlhyPvexHrHTW6NbldhUel/lp8xHrXyRuOc
	 GAk28wSvVHfnUf9vjRmqdIDzT6VI2yqHcSdgzSOFxKTQacorIUyRwH0nZSfZ1DruPP
	 i4iBdSAXtQt9w==
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
Subject: [PATCH v3 28/54] selftests/mm: move read_file(), read_num() and write_num() to vm_util
Date: Tue, 28 Apr 2026 23:42:14 +0300
Message-ID: <20260428204240.1924129-29-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BBFCA1A000C
X-Stat-Signature: xze34pqo8b6n55g3ft6wxsizdbhh695h
X-Rspam-User: 
X-HE-Tag: 1777409156-356473
X-HE-Meta: U2FsdGVkX18s+nefPqBW8/tcWTZ1P2si49i0hxgcvHuZjlpU5x3PlqwyHnmi1MWrg+yvfj0DEvAl/oxxpubp+fo7V+Z6y/A5wVK3olm/4Bl0cyWtj5ZT1j7B8/B29hmsoMvHNpVQP9DNN5EdvDlwiDIYSV00dIG6tLTJiI/Sf+71aTe6l3jzaGciZ2CMWHUjfvOYqPg0G98PbkR4CZxzlMXBdXUEYEeL0mSqQKzVFid5VUL0LD/R2/kP6Tms4Z7quMIq+tiPGlnUw33z7rmoC2TMF4k2VGOVY3+vNQecZxJh4llWhCqSXcJFfFeNIiOmFEb5+K9RKPYjPjnparE/NiNP1OOCoyHdttRioIWEkPvkMAx/gpOIVo3hnmgsyjoxFOSKP2lJ8JOHK0fzyXrjvWm/52uYFkYEdQFMUnfc0sSRGKsgfe6Xn1agO9psPzKWNe12RVQKL4ksyCCJUV3Su7RrgCfFQ0+qtXXb502vYUWPmAkfcDOKZpXP0cNu4+tLOpi9Q7l+gDdbDGPVnDfue7TJF/VF9xTx+Cgu2yOKCh2DEm0xwIzD52OiVsiKPmW5Gxr0Oy03u3VVppPUuJJqp0X6fQ67zQ1vYi9cj4qnaCE2t4TMp7FUD4oy5gO7yagAnQYoLEZS8fqfp7iMD/I0inkLWBZMKLfVGyCskhv4A9p95TZELguCg7cHIL5+WJKgkKlBkOXdWAOkwDjrgH2EqaLXh9hwhXEHe67dxotX64NgyEJjh01G37slRaEf2dti/GO/PCgtDsTN8fegPHHH9S3OT8oSuezZgYCaT8jvzi0zIYC6DQ7fvBhmAKc0X4CoXw9aE/2t0jp004FU3YtgPWmd8+3BX4KQYku9waAKUBOCbOB0Zhs3SRjFdByuhldMYP9SVMyExiGvw4bWF0WDFhaIviV9ugFgX6feSx17xy4iGfwqNuLsdGq6CFOnSJkDGaDEWhQ2pcZ2ljVFUio
 BrZl7fWv
 ew8OFzrQuffBrS7JYPJPUM+e3P0g9kI3MrqiXwJjOJIhJZzK/DqDyFHSpnddOqPjpneXRUDHeNmq2VMMMA359zBNcrzH5J5IiUFZMBJS1zxbwfiwWKGmACDfXypyChk5tiPXLY3NwBTGngjXWZPzSI+FeFaNlJ4lu8/DxPYPZYnjGAS3LqEAi/nrnv4CfkEhcyqwx7aL9sxF6nsaYkVzkeYnX8iD4A2uIj60G9udfj+U3EUaWxstCb5okSEGEP7b3hS0xWpuuy1TMaC87I6QrlX2l/KPpuA2Y5Anc
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
index 9d31b53dbc67..097ba085f423 100644
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


