Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CF1E606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 21:26:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aeK2et/i
Received: by kanga.kvack.org (Postfix)
	id 7AB546B05B5; Thu, 29 Oct 2026 17:26:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 781D46B05BA; Thu, 29 Oct 2026 17:26:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6982D6B05BB; Thu, 29 Oct 2026 17:26:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42A7D6B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 17:26:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 595C3C0541
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:29 +0000 (UTC)
X-FDA: 85376947698.26.FBC6C5D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B009980002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 21:26:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aeK2et/i";
	spf=pass (imf02.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793309187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N9mCBJUUCqs6IT2F5T2oWyZqbwvi6Ucfb+HOwsiw6Ho=;
	b=Vs4z6/fQCsXHIYqOPCDCiNfqjmfhhv9BWTDxdVjDiZdD6qWjDauNMqoeoKehudA0hk4z4L
	fRPexQ2IHxQvqruKjM+J+TC5es1IUDOiVIE+jzZyCo1TzXGCFpId7ayxydoEV15l6qCvbQ
	hMTqGMsNFWuCFv2eOVamsBsmkwL+9Bk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793309187;
	b=k3Lzgjawipi2YIoIYNl9Sy9KdXel+/N5c632n56ozQlOZsKTVH4xEXr+OTQAYARawgQBmm
	7VS2OQCqaoVaYXTNgpk1zko/Z0eNxTwMznCkw7TdUkabjqOtYtLG7z6nMAw4N8PHAwHA78
	GGn1aWXHE+OnPn9hB8A+1kwuUVC5334=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aeK2et/i";
	spf=pass (imf02.hostedemail.com: domain of jolsa@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F273240483;
	Thu, 29 Oct 2026 21:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4471F01816;
	Thu, 29 Oct 2026 21:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793309186;
	bh=N9mCBJUUCqs6IT2F5T2oWyZqbwvi6Ucfb+HOwsiw6Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aeK2et/ioxvUdQdQI8JkeqiV15qJC8AdzGa7lYdRlpe2+NjG0LieAd699w0CLASvl
	 QzmbRNotAYc0wp4mLn6SpbwpXcT/uD3gy9/Gs+oFl0za96lCAZ/Q6TA9qFI+fuLua9
	 aBuKPBOh5jpPx0LkBeaUz3MpRh4dGOkZ/NnTSrFslgrU9Uh3kYnBuKcvFi2yJwG1TA
	 Y27GoHTapanIpRQce38JH+qYs2ulBMK309Y5nb/IXLfkQpVXAS9ILaSVu7rnV/kDFa
	 5uSvDy4VZqiwLgekenCa6aaq25z/xNuy3rT/JHZagEhJySY/O3GTovibuBeLTfkJTx
	 V6UvWlqo+FTzw==
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
Subject: [PATCH bpf-next 3/8] selftests/bpf: Add get_procmap_info helper
Date: Thu, 29 Oct 2026 22:25:46 +0100
Message-ID: <20261029212551.56964-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029212551.56964-1-jolsa@kernel.org>
References: <20261029212551.56964-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B009980002
X-Stat-Signature: 4yz3fhmpna1bm47iordnm1s8xq78j4s7
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793309187-837029
X-HE-Meta: U2FsdGVkX19LhWK5UCUyWQCLeiyhRl0GApFlaiKnSDDU3MWbC+3LBbqfjQ4xyfdUQKFh8+kXHmm1pxLMzsO5u83CrPM/iZZX1n53cQFVvj7KJhGlAEInA/JDI1Ahh/sxlzWcA43QQS5V5ixuVWOrQr+zzctpzvzpiGUUz54g0MYVSWu2xiBJyqCG/Ex2N9XbT5hbnx66q2abIVXZD6hDLilDAZG0+ujHv7ljvR5bba7RkNO+v7pOZrLnf3oB7UzkGzkevPMulFcIy/j/TcrkcpERAcv5LWQkgQvIS61oeDh08qNdiLMO40i2eDQ47R7bHb3osl3k3kadbp/OuOfsuoAzhNYyWKmbdx4jCmezOclNz0GMvPh0gBZe6ENbdpiG477kOJRkTL5ABzS4Nz4H5oNsNk3v7Fp7B7lXk0JuxiV9bC8NG9xN2M6KncbYWMXbCouXQYMuGjNRBWGD8s+yGzM5U3kPi3oicKX7C7w/g4SHKGUjPVA37XLROs5+h4D8Icj9s76664HrusjnfTdEFuagQ1kGg6t/kiWR5z0UlZBSb4ts63yZgxGXKibxjBC++96jtNk2UPYJrSo4KnvBYpWSv0MPmlqYv4sNBT8NJ/QAgAFKhnSC4c6dVPQC6BvFSp1A1lu4vOq+HwF8JZItPL3Mdt+TzK/sxYGxJpRYIjn9kD9MMZood3b0U7FDDSZmDdQAyPbGPUzyMzKT++onqzajPktaK506lqhNtMMk9cnSGBRZ7RphEqkb8N3xVwNC43ccwaHJ1fJj2OH9eoZW+etUuLP2hpROrpPj2Mnt3zYoQvWQo0yeuRD9YomN4BpxLWkFUKtGGawGFnFEMkpz7wy2o9dlfag64RU0t8fYOj0x3x0fWP8RPuap0Q0cseYonERUB0tzBHq12a8rVjn9umtLrXoNrVBDP+1a10CMFIwtTpxD29Gv2W7EJXthrmB3aKX5k5infjrrzpaPmaZ
 /cmK+O+4
 19DO59G0ZvDy0tA7q5U/v5gDPbjjLemdwrBsbfL2qPbPNU+zHn/gHS5kpHrUtXS0mSY+Y7jqPYQbSAG9axGC67uEGBXIZkWn4o5+ZnZ1VgXYATYI6ySaxJa1uVfy7/s9zSLVPk76jhLdIZko4rcnKVUvjhJ5JqfqugRZgfIKMGv7lDSH47Lkclj8cHyCWE/bokBLLPdgR2z0jMysyyePrg4GwPlok6FvzzC/TyNtNW4ikiZS/JWwSMNR8dSXTzCFc4qTh+xRWZZrwwCASU5q5iXgxiY03SpeXtRp0xMChCJOPo3Rhl3WuOeB0+pbd+JWse6ThupLuAUbCxHHkJgCFQzlVQRJA6hEeo0p//IoG6GhWCCs=
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
2.54.0


