Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87B64606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ii6tuDpX
Received: by kanga.kvack.org (Postfix)
	id A9ABE6B05B6; Thu,  5 Nov 2026 05:24:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4B226B05B7; Thu,  5 Nov 2026 05:24:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D4A6B05B8; Thu,  5 Nov 2026 05:24:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71B286B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:24:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03685140637
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:20 +0000 (UTC)
X-FDA: 85400680722.16.8C31085
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6FE014000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:24:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ii6tuDpX;
	spf=pass (imf11.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xV1KC5XMmr66m/ozn9Fco/AFVjAIHwFhnqj+MBTymY4=;
	b=j3Mqnql5s1VmZVFmggQ562BBU12g9h3w5j2U9YWFYKOtTlXHcCteuavNanNnG/KuKzw63O
	ZvopmWQslnX50ZMRL5QHMzvtoUOZHNuzbfktGvPNL2KPmIl1rVmCTXjfmJWW5Pse8mYN2z
	9kQFuolLyEKC6KrdoKNTsDBONlKm9ds=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874259;
	b=P3kvmanFHRoE7ixmw+vYrJwNDPt43wrrkSf9ohA0bhhDmFi85Ly1dU9un4zqixsaz94/Ym
	muNcrqtvTAi5a+4NefzyoABnGfSsN37Iuc/xn1aylQ9mnebMwmw1h5Xfz72xzfeFrIFGQ6
	UXeVaSQLAyjIP3oF56keuMYTc3UZ27E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ii6tuDpX;
	spf=pass (imf11.hostedemail.com: domain of jolsa@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jolsa@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02547601DE;
	Thu,  5 Nov 2026 10:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFEDF1F000C1;
	Thu,  5 Nov 2026 10:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874258;
	bh=xV1KC5XMmr66m/ozn9Fco/AFVjAIHwFhnqj+MBTymY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ii6tuDpXcWq4yvkOqWEK/7HkjiTAUpKxwdk3rbGF6tBrVZ4bw526MgwZBqFyMyyP1
	 NAickvNlNTsnuY/vxkk2IUKmowjXtYzXYV2QOuGpZ0MEd7WN8qdMDVKrwjkv2ko6Sc
	 U1RfUHPAf15eZJqkF5BNkAqo66xYRWPUq2NWF0IbGWEyxGru8ZWWl76xX7qegQetm4
	 GF3ydG5NIPAL+PclyvyCbpbOd+meBw6o2n7BiTy8ipLK4/qyDLpvzA+H2900hRIwF7
	 FETEDxaolYmUZRpYvn5ZwUZgROHsI7P9lcIfyyHbZTdTkzAVgeGgiyYjJJdE2Sb9cE
	 pS3V7oaxB2s7A==
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
Subject: [PATCHv3 bpf-next 3/8] selftests/bpf: Add get_procmap_info helper
Date: Thu,  5 Nov 2026 11:23:37 +0100
Message-ID: <20261105102343.311331-4-jolsa@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261105102343.311331-1-jolsa@kernel.org>
References: <20261105102343.311331-1-jolsa@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6FE014000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bhw4hqbodz7aemkiczxmdcusr8qjs3cg
X-Rspam-User: 
X-HE-Tag: 1793874259-414441
X-HE-Meta: U2FsdGVkX181TzhbqlZTbpVfYPdBklr45M7+LJaHMf5eYrGhto3cwfcWWm+A/k0vT7WMq8UqxuFs0LoVAbBPejFD7wh8ZTMTdeK8d2frflL4NU9Yct6fY/uMsRkY+0OKK1vDO6TvvW1DaIz3aQZm9QYi6wlSTQkDRrWpPgskJW3th3BRLUnYJd39M8klJi7zzXAQObvu44H+vjB1suIxxSvBnvjiaeGC0VrmVLRdVfuGqisjQ3Iy27zMVJBqT5MX25CyH1XJNWF/iBl6c1WA4JDOHU20FwVxhokcGfSGjRRozsvLZ0ErZn5SjeSMsvkSx3dOqFQLc6SfQ0wrZgixowjSjwarESJhbAewRsXexSde4k+otJ7iakfViCsvfWRjyrddscsoi5ZsHYjJfWhJHF26EP4NlGW7Q3OefCvkR14lsDfq0E4a2QWHU2FYISiTPTn9swozMHdbycr+2PXeNFRRLO35PJ9tpajjVAmRwIbWVu+t47siCVpiTj48zHe1k2rQT+hGZGWZCC7futLHcxCEVd2RnMM4cyYw5SHznQpswsUpBQY01URNx50gWU4zZM5JeNeRR2/sIylHs5F7wt2V/mUIregehVLFrWCwfOpQaGkXWr8Y8i1Kv5tGWdyVTJzUcqxuQGBF5pD9EIyym8JTkHfB8NxUnw+3eB9xWX4WfSgLI2VKelALjzY810tlv+fR/g457BqsToReOjkd1pZLJOE+dDuG5HSdtldhdrm70lVUW3r1y3YmalAzMmGs+C5Ng9rx9NrD37CqXmKqQmKV5aHhfFR5hiv7UFAFsVw6M+CHrdVT2QoQQZdFwgya8LND8d9XAB1+pRrX9zcutx+fqRbHoCrtfkPrasHJqSnMf2k395wDJZTuLyaM9ONmIEa/U+dfzvImJpYWXZKu8nE5gMKEBYP8MEvyjkK2n5gmjmQTExAjlBEN6hd0jWOaMoGifO0t1c76SM7JyFY
 h84YW8U5
 xn6sBv84AjsywrWVUStBy3CH0QoSzi46dG88IcH4GfOzk+GkEYRiiuOqTJ20/z8JpY/VCGThOJxkWk/I9+0Yk2nKwwr9NdgkPLsKNGZjM/J0meFMAKDfYFz9PA4bp+wo0/drtjpJQrbsK/Bga8EQ3ZGX9hsjKVrHIkSmvbAXBIX+bRCZPP5+XZYlaNrnV/nRP5sx5K9j/exwehUYnNWXFyHS/kgISzE/g9er7t8ooBWttd5GjmctDCyI8pE1z0E1oyh7ALKvxKjOh5f2V9LpSJF1GcARwlOIhNirFhDrbE8B0rPcWtCNC29ddA3fV6LiN3TgHYBeRYV49RcqizofQx/+TY5go1mzKH6rq
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
index 6d7a4b8c4ab8..e871a26b991d 100644
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
+	int flags, err;
+	size_t offset;
+	FILE *f;
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


