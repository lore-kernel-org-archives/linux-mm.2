Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E197F606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 07:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SHFeiPcQ
Received: by kanga.kvack.org (Postfix)
	id F26ED6B05B6; Tue,  3 Nov 2026 02:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFE706B05B7; Tue,  3 Nov 2026 02:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3C026B05B8; Tue,  3 Nov 2026 02:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0CC26B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:59:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F89080149
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:59:53 +0000 (UTC)
X-FDA: 85393059066.24.BAF5293
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D5CAA0009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 07:59:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SHFeiPcQ;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692791;
	b=tb7EVcRyJyL++5ntIdOMFhic55dLtfsvv65NhcTpA1AEzoytnmv2EVXsqVd2O22SVkOybx
	YEuUqcHxP7lri5pM7bT3SmKinQms+pECxlmVYYCKUP7HtIXtSw3HzcIhPxK3hukk2/xa2Z
	8Ry9CtlZDJjOQJ6Xtbc427FlhYfj9PI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjipW30n5WfXiCHIuo/tN0yoEdsPNYs9uCjpwtKDyuw=;
	b=ZIC9sHou5Q6KdPGEYA/w6Llf+j42lzH383kSGCgvQza98wgAQaKo4JyMBS2WOsRSvJjLG0
	LHZ5OCVap4HcCH4Tx/pRo4OFSGgmIbzeQhsj1JgcGFGoH4Kt+oo28DzKh/lG0Dx5wEVHV5
	8shKFeRZYoUj1Ea6QSXVzVf6ftDwt34=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SHFeiPcQ;
	spf=pass (imf15.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3704F60008;
	Tue,  3 Nov 2026 07:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF501F000C1;
	Tue,  3 Nov 2026 07:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793692790;
	bh=tjipW30n5WfXiCHIuo/tN0yoEdsPNYs9uCjpwtKDyuw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SHFeiPcQQW/94MTxexMAYrUW9Dyut4aq1JgGRW7bzCtKowXs88bTOQLOOwkAmjREi
	 +Ot1cEToqtExLUQonQP5Sorjb9jMK0QkuyD8VClVuA3Gz1IRmteHZT4vpvZ8Tdc++H
	 hdJSQMYfoH9YqsmH1n1DTUjSsO+eQANHI1op1JmW97+y6eD3pzABQEVaXQRRkwc/xg
	 +sNhns7OeXVPbXrsmVir2YaI039WN5gedz2vPSrupYJLMMEVGBvSpkbIjX8zJ1QWzI
	 p3IRoPcf8dxWG/a3YM5+baiH89cWQ1LALEk91SN2dUZE0DivZyx36nwdW3VioRp/eW
	 vO1AwEOp+7ZWg==
From: Jiri Olsa <jolsa@kernel.org>
To: Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Federico Di Pierro <nierro92@gmail.com>
Subject: [PATCHv2 bpf-next 3/8] selftests/bpf: Add get_procmap_info helper
Date: Tue,  3 Nov 2026 08:59:10 +0100
Message-ID: <20261103075916.100050-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103075916.100050-1-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: zzfw3ntgw3znn99365s65xgoycqj7g13
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9D5CAA0009
X-HE-Tag: 1793692791-115107
X-HE-Meta: U2FsdGVkX1+ZMu4UtGQuq40+kflYfoePfWghrg+A8gzWjMz65sq4pwPqFuIbcz43A4OgBLIZDhrPO21Egl5nOKxQiiCIKeMI1rZcGD7xj6FPfwl86xP8qpRjrf480UIBj0WSzwRuENbLYYGjDp3wPuHKO+taYOdxdUzfIer8BiKSCbeqRNOr+n74wrAtYfiQXxof9UYZRxTIrkyhR5G6HAdzFIDYGlp7TySOWMZpY0T1rFJFGZCEysIWW6MXCdK1luvcFO3Ou11ydpaYMsIHwEfX0WXAR06qIx6OYhYD9ttcK1xqMqydMEAMIb6lZwU8tCAPe52fFy5Zdywv7lsQmoZgYRRi53cj9jwqG7tW5CF0PbHKTvFHgQxKbcwDejA4HC1GoFfhL+BbjzaUKO94m5rDevgPqXI6+hME0zTupkJJ6cSiTKJzx21F99Ihut8qja4HbQ0s2tcNvw8FfiPoQ3PO0OVrbXiyLov8jwGralLU3/O1cypu9drx47+GJ1A+IRxswi5MFXqCwVSzq/FhBjiYfGc5TgU6fLW1pYUhJHd/pYwwbZrl30sw6v9VdQ7eQ740ERrl9yn17y2AgtOpDY72plTrxePLcyZ44o+bc6gvcAhnuomRKwQ1TSwUJ/ydDeQnNBYt4PQAIgcBQgwLiK1l1BjOt1jD/AJx9dFNM1qVssH74d5Iy4ZaniuXhYYM8IB9nPI+A82kETmKqG1flO4LdOxhnD1id9nzjEppi5ObpWo8wDD3ssqtk9bBJM0HwhVOnFdeQ/2NRJV5aFgQXFV760JwkVic+2OjH8+rwE1zAn1P/tKER8sTQOpwJ0OdBgaijGHf7bRnRh7w7V/8hnZrZZPzF5owJGzy2oSkHezpn+Wv9lSVKOlaFOodhJFlwParMhmGUoFldqq7y8kBA1zOqydX/9/JRiEQAcc8by5elTb1JvGS/bFnBMCSrndXpMp8JG+dcg5U9w2KP8X
 Yb8yT5do
 aNsKwhe/qN9Tyh3QXhpwUB1AdAb/SJWNtEc8sCpugzgxGovpT8+hVmeZSNCVSBvjipFkiT5Gamo4sU3uqn7HthQIjC3Q2hBP57lu0NfxTnwZiztHV/156oo8YHQ53mh3L0dtyaQkZJTiZQ1c/LuNUl81TD5mYHb6jTZxMZFtxALLsTWa0UcNJiVsViCOQZjhB6jhrdVwn5oejvIHEs6HBzbI77TB1qzA+u8yYMyfFNDMGCL2casizJxCTAt+PFFr8wFHdSAQ6a1EPRkB4KGFvTR/zuEGeu61ZmXMS8Qmh1IgNj5N9FhPcElo1pVTyk50uIOKwIv7QbiKoaqb5o/k4JNoOZcWaO9RK+p27AUB0vTegXPGRH0+NUuPTnHwefxgP+tNfK1ZUTfB6RVpNZ3go8yKl0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Adding get_procmap_info that queries the current process VMA range
and permissions through PROCMAP_QUERY. Extend procmap_query to return
the VMA end address and update its callers.

I don't think we need the search fallback, the PROCMAP api is merged
for some time now.

Assisted-by: Codex:GPT-6
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 38 ++++++++++++++++++---
 tools/testing/selftests/bpf/trace_helpers.h |  1 +
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 6d7a4b8c4ab8..d2b2ff0ec2a4 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -286,7 +286,8 @@ unsigned long long module_get_base_addr_sec(const char *module, const char *sec)
 #ifdef PROCMAP_QUERY
 int env_verbosity __weak = 0;
 
-static int procmap_query(int fd, const void *addr, __u32 query_flags, size_t *start, size_t *offset, int *flags)
+static int procmap_query(int fd, const void *addr, __u32 query_flags,
+		 size_t *start, size_t *end, size_t *offset, int *flags)
 {
 	char path_buf[PATH_MAX], build_id_buf[20];
 	struct procmap_query q;
@@ -325,6 +326,7 @@ static int procmap_query(int fd, const void *addr, __u32 query_flags, size_t *st
 	}
 
 	*start = q.vma_start;
+	*end = q.vma_end;
 	*offset = q.vma_offset;
 	*flags = q.vma_flags;
 	return 0;
@@ -333,13 +335,37 @@ static int procmap_query(int fd, const void *addr, __u32 query_flags, size_t *st
 # ifndef PROCMAP_QUERY_VMA_EXECUTABLE
 #  define PROCMAP_QUERY_VMA_EXECUTABLE 0x04
 # endif
-
-static int procmap_query(int fd, const void *addr, __u32 query_flags, size_t *start, size_t *offset, int *flags)
+static int procmap_query(int fd, const void *addr, __u32 query_flags,
+		 size_t *start, size_t *end, size_t *offset, int *flags)
 {
 	return -EOPNOTSUPP;
 }
 #endif
 
+int get_procmap_info(const void *addr, size_t *start, size_t *end, char perms[5])
+{
+	FILE *f;
+	size_t offset;
+	int flags, err;
+
+	f = fopen("/proc/self/maps", "r");
+	if (!f)
+		return -errno;
+
+	err = procmap_query(fileno(f), addr, 0, start, end, &offset, &flags);
+#ifdef PROCMAP_QUERY
+	if (!err && perms) {
+		snprintf(perms, 5, "%c%c%c%c",
+			 (flags & PROCMAP_QUERY_VMA_READABLE) ? 'r' : '-',
+			 (flags & PROCMAP_QUERY_VMA_WRITABLE) ? 'w' : '-',
+			 (flags & PROCMAP_QUERY_VMA_EXECUTABLE) ? 'x' : '-',
+			 (flags & PROCMAP_QUERY_VMA_SHARED) ? 's' : 'p');
+	}
+#endif
+	fclose(f);
+	return err;
+}
+
 ssize_t get_uprobe_offset(const void *addr)
 {
 	size_t start, base, end;
@@ -352,7 +378,8 @@ ssize_t get_uprobe_offset(const void *addr)
 		return -errno;
 
 	/* requested executable VMA only */
-	err = procmap_query(fileno(f), addr, PROCMAP_QUERY_VMA_EXECUTABLE, &start, &base, &flags);
+	err = procmap_query(fileno(f), addr, PROCMAP_QUERY_VMA_EXECUTABLE,
+			    &start, &end, &base, &flags);
 	if (err == -EOPNOTSUPP) {
 		bool found = false;
 
@@ -418,7 +445,8 @@ ssize_t get_rel_offset(uintptr_t addr)
 	if (!f)
 		return -errno;
 
-	err = procmap_query(fileno(f), (const void *)addr, 0, &start, &offset, &flags);
+	err = procmap_query(fileno(f), (const void *)addr, 0,
+			    &start, &end, &offset, &flags);
 	if (err == 0) {
 		fclose(f);
 		return (size_t)addr - start + offset;
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
index 0f8d99746084..85b8f8e30232 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -59,6 +59,7 @@ int read_trace_pipe_iter(void (*cb)(const char *str, void *data),
 
 ssize_t get_uprobe_offset(const void *addr);
 ssize_t get_rel_offset(uintptr_t addr);
+int get_procmap_info(const void *addr, size_t *start, size_t *end, char perms[5]);
 
 int read_build_id(const char *path, char *build_id, size_t size);
 
-- 
2.43.0


