Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BF32C9830D
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6684B6B0096; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 579BD6B008C; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28D1A6B008C; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0FC826B0089
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C76A058388
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:42 +0000 (UTC)
X-FDA: 84339819564.16.E7AA274
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 026521C0007
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j7GLeKDj;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768615661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHIE/NL9AR26aBl4c6DABAj2qn0SSL1YWzRGVn1SkM0=;
	b=SGxN4bD7xvDLXCJvMU2gGYPsBZ33h7eEh1tkhNPeWVbLh3Tr+NxpkmbVMASaaEPnF5uAWH
	u0mzBQooS06or8eOIwrhzA+CFLsCWQucH3P24Y/j+mnB00d8kH+QqUeSiwTO0+LOv/jti8
	gqrfe45C6wpzw6rL6CDFWroz0MjIue8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768615661; a=rsa-sha256;
	cv=none;
	b=P4gXOGeuR/YBZsixDljD4AIXYitvIzHHQYAE3IUxWcJ5VgFs3mjBehHoxFCytRXcaCxm7T
	89QySiThdvDdzBlRwelE04zS8OKfLJFfV2eJDtAP1+iONzvukUNiDCZBaTY2QXYm0CUGJf
	MgdRRKpEz/3A3gdBScI23Nvd9IKsleM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j7GLeKDj;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0521A444CF;
	Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE44BC4AF0B;
	Sat, 17 Jan 2026 02:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768615659;
	bh=KPSyHpwr1RZ1sL9zrIc+8C+fgY9V82SnKK8ITdn75rs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7GLeKDjUJJag3xHYuo20Q9Oy/4IhpeJCwFSEsIEGhkJM4UAHZMtMrpDLcX7K4DU5
	 YvAv2YJEt6QyQmWxut7nZLrZe1Y+ClVlt7RlSET69B8PIq05SLwghW3kkb0Ir4VB1W
	 mXI0rwNWHK8nJqReNPQquSZo9W/iW89hWsM5rZR3lgakkdQBdUmSTl7eNmRjX7M6iH
	 g1Bi06uJVvP7tjK5tt9m4+WFC+MBU8ZpCCmX/PmnYTDjSK2Y9WO8ovN2v0JByO9btG
	 8BvDnVDYG1cyzjZTSSFWgxGq0rvUUqC9i25b5L6XAE2gwcJruZHChbLVaq4x6l5B2P
	 6Genz80mDUS9g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/5] selftests/damon/access_memory: add repeat mode
Date: Fri, 16 Jan 2026 18:07:26 -0800
Message-ID: <20260117020731.226785-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117020731.226785-1-sj@kernel.org>
References: <20260117020731.226785-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 026521C0007
X-Rspam-User: 
X-Stat-Signature: jaryhwyqyrp5u9ifkonwimxc4cp41wu8
X-HE-Tag: 1768615660-909193
X-HE-Meta: U2FsdGVkX1+jVIoBARR7LxYiEHrn8weB4YsPioEmjKq1PsyhLRa/WG4rLMPjA2s1g7xrzI3huD6EVp5FDwgyyGzpWTgLHdnFFTBKvBzgLQoX3jvcusmvO06aSQLoPlmukcVSTgAZUFGELVCSsW9BrWoSixx4wAg8YrVfCAHsu1yKhRzpBCFqm05F5r8dnh6m5UWRtkJeibO50lt9x+I/9NMk+LmYy0ZPAZqmgrd8PPVE3Cjuq8OYIe4C5OuMo5IFFptq3rAeid/pIumigcQdKdLdorDyki8dq1fGsKVb/3gVmUIbfu2g6H4IuXH+YS3F4VKAXiq+fIOALtgA/WK8lOvQmh7HS4ner6aHqY0wKZTkvmNFdvhuQJoHHtpBBKervOlkxET2PIlA9u4CQQpKKq6Socgcjvn/8Kre58W3dYe0dmV8H5ekteTC4mzzYWFF0Wl/0zy/XNoqDFE0rG3ty9wYpDIFnlLyKpvv+SeNX8cNZRt3J+iUPpC8NqIDXaM6f+3BRcmKiavpLeDqFq0q46TNcqyNrnVp1btBW8aHgkppIq40/lg20nSS5GiU1/RMsflhtAu+3qTp95mYn3azjIvodyWsUP8pc1iwArAWCQXs+dk7dKrK9yXM82UkzcbD4yhJloBMLByfBhqmnw9avM/0do47USasMMajPulMr7yvqGSCtOfnmflSO1Sxecvg5cHTN8d5x4tBQajq6KJ1OpaW2sIeYDhtbNrnGMh/cqfH0Ma0168x3ND9aD/TtXtf7Xsbek+HY31gMWoL0vJm+AWC3MsLDQlIbFytDySa4fPZH5y0vTEVIabNhND+2xI8bDBT20CU9PEesfV4NZXxWDosAR0kMIBckW2aek3BwlHpveO2ihPSIZW7auv97YxTfkCuv1pAK8TTBBdbUk/0FB9SuLrwnLSBaK5IPRYudZ152M9je+m29LfAqBNz8nVW13TTccu4ZQsWsKdrohE
 1Q6UzyJ6
 IFsihFRxnIXjRmenEf0G2RKaAyM9eFj3fAz6Z/QsrJwNSDeP/8+FxeUyMGgmWPPF44UvViORcafO9ez3v2zn69k0aIEDmQoLDtfAIJf9N8WdsrIE0zoJ5e6U7ll+P4M58hon8Mgy+GwHkR1deU8pDmzwL1iKMSdf0Ptq/ltTXvkH+TnSkJ9nkRIq1p1VHbLvXxE7UtcMZrZLWl8gGncDiZbtRcvcQBc3JXAZCpbHbJ/tTkJEK/6jvIzUX0cwi7pvWKUldooAMiUwE7VFURYxHaNYIP6DQEaW1/9KO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'access_memory' is an artificial memory access generator program that is
used for a few DAMON selftests.  It accesses a given number of regions
one by one only once, and exits.  Depending on systems, the test
workload may exit faster than expected, making the tests unreliable.
For reliable control of the artificial memory access pattern, add a mode
to make it repeat running.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/access_memory.c | 29 ++++++++++++++-----
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/damon/access_memory.c b/tools/testing/selftests/damon/access_memory.c
index 56b17e8fe1be..567793b11107 100644
--- a/tools/testing/selftests/damon/access_memory.c
+++ b/tools/testing/selftests/damon/access_memory.c
@@ -8,6 +8,11 @@
 #include <string.h>
 #include <time.h>
 
+enum access_mode {
+	ACCESS_MODE_ONCE,
+	ACCESS_MODE_REPEAT,
+};
+
 int main(int argc, char *argv[])
 {
 	char **regions;
@@ -15,10 +20,12 @@ int main(int argc, char *argv[])
 	int nr_regions;
 	int sz_region;
 	int access_time_ms;
+	enum access_mode mode = ACCESS_MODE_ONCE;
+
 	int i;
 
-	if (argc != 4) {
-		printf("Usage: %s <number> <size (bytes)> <time (ms)>\n",
+	if (argc < 4) {
+		printf("Usage: %s <number> <size (bytes)> <time (ms)> [mode]\n",
 				argv[0]);
 		return -1;
 	}
@@ -27,15 +34,21 @@ int main(int argc, char *argv[])
 	sz_region = atoi(argv[2]);
 	access_time_ms = atoi(argv[3]);
 
+	if (argc > 4 && !strcmp(argv[4], "repeat"))
+		mode = ACCESS_MODE_REPEAT;
+
 	regions = malloc(sizeof(*regions) * nr_regions);
 	for (i = 0; i < nr_regions; i++)
 		regions[i] = malloc(sz_region);
 
-	for (i = 0; i < nr_regions; i++) {
-		start_clock = clock();
-		while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC <
-				access_time_ms)
-			memset(regions[i], i, sz_region);
-	}
+	do {
+		for (i = 0; i < nr_regions; i++) {
+			start_clock = clock();
+			while ((clock() - start_clock) * 1000 / CLOCKS_PER_SEC
+					< access_time_ms)
+				memset(regions[i], i, sz_region);
+		}
+	} while (mode == ACCESS_MODE_REPEAT);
+
 	return 0;
 }
-- 
2.47.3

