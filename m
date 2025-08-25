Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062C7CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483038E0035; Mon, 25 Aug 2025 10:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 432278E0001; Mon, 25 Aug 2025 10:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 321468E0035; Mon, 25 Aug 2025 10:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8358E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:57:56 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D451F160423
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:55 +0000 (UTC)
X-FDA: 83815584510.10.01D3ECD
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8B36A0010
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=F7Ptlajb;
	spf=pass (imf25.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133874; a=rsa-sha256;
	cv=none;
	b=yzLo682D2HjiaKT25xtf04jq+GD6c6X8Q8Fxz4oslXpJf1lGHo7+GdmMuE+H/Py3hPg/cL
	iWWN+mDwgxHECATURrE+OdGoF/Ss/YLveFvtv2Nk4kml7xERWb8Vrbld5YJwJWUW1LENiS
	qBRbXiDW3dr5l3zU6wYipoXrc3BkVYM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=F7Ptlajb;
	spf=pass (imf25.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frobiiF+V7JXOVqxsCpLilnhoxfx3g4fKn8gApXFwiY=;
	b=E5235OHACCeRZpnOGxQThE+RyNHl3jcn9kr4AMRdP7GzACen9B6IoegHGjjx8ivFCxlYwz
	oK2tmntmCtF6AVvYbFoyEKQxHfuZRcK3jYvAZRm8igTC8vHNGutb/10qe+bvnRAXnwPsiN
	mvyDolWpvcahNu1RsjAIihzouHFosXg=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e6cbb991aso3869991b3a.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133873; x=1756738673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frobiiF+V7JXOVqxsCpLilnhoxfx3g4fKn8gApXFwiY=;
        b=F7Ptlajb+COcSr7B6p6Ai14FsMzNNgThyCLxxEJnXJaQiOWaqWlBIix9PF5z85HE4t
         mdyE/xf+mr0EwLAVrSY82KsjT/5L2xPL0uw7AmmdJZWvLZUmvu07g44DT/b5lXmStovJ
         bkfb8WCTOTRwfnSMKOahVZRGTkJk4N6boV27sk2LUyCHDIGKrmYY1RUkfn/ZNKg3ngcW
         5g17cdpj/Ep29jePNfsV2ecwzxZJPmzToODR8rss92xKc72iRj7bhQuqyxGykIZi9z7A
         GFxNCFfM91yC6F+ThD9096sO6vlNeXO7wjLdG7k9gOG0fGKAIKkkpJ2G+PrsjUxYSmg7
         fwVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133873; x=1756738673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frobiiF+V7JXOVqxsCpLilnhoxfx3g4fKn8gApXFwiY=;
        b=ek9wS7Z96+CB/Xx1LjJtVICeED8edlbcHmebMgPh3U/SB7zg3rZcFdbyx/coMlnDsI
         RZcauSJTz4hM3N8ObKsr0AG6zUbWKkbX+gd0P76MRGIsOuG77JI2r4fSCrCEBz/3APoL
         hgfnmUNtjWi9QbuJJr8x6i5/i85OwiK25FQ2qk90zBJdhExKDURXkoVp7ky+H0SuJIZj
         F2wU9aoaP0vftFfD+pC9HiZdD95SbynA2zVeiScfXd8SyhMaD690cFSxMQOMGt19PFt5
         ToczjFI0DVzqm80DHUx4kH6WjXXpgE31rTu1iym1L31bAhg8vyMH1pEkmoy710QUHr9q
         YI+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXHwfljKWB/MD/eaPyuAt4IyjERF3U1qL3Y11/8LdrMSeS1QISpR9tSBAO7IJSSQlODXeJ5bLPTow==@kvack.org
X-Gm-Message-State: AOJu0YyCr43D97eU/pfAcsbKGtqhFVGTUKBwmOdh9SVHCTD0oZRS3M4B
	SKCCvLUnb9MUUyKOmAdYjKgoOb5ieCsebfCXK9PBqqZPpa8E50+0WuhwpfFuZb0Tvfs=
X-Gm-Gg: ASbGncvvGb8ggqq4MUh4JLFPA9IG0y2zgBWy8+KHbp6uluzkbMkc9PMrpDYt5B0c+Ny
	4NhcNyful863WBAakfpzZc3Vp0VBpILSBAUT2ZYYb84NOYHsJ+P6AEFWgB+0JeTgmuw69Ubm2eg
	bbkrPfTg6w1tAKqTWfvOW2Ulm1av7ZQV9s0OuxKmyIXvLqJPz1D8KbgNCoPCzAweoxutiFW002K
	lLQr96Vmz6QAFQoicRZcKkfpzOMlA6AZY/Hu+wVKYhC4f1iPaV6Ip7EjtGq4K1ThyjDjDsuARbC
	ZLqMBUg/BeUPRKAQHTDLYZDzLiVz4yQb6psm0/dsQvpFpcHnEWhB9mgCddJxxYapEjZNgBz5hsV
	ogMhxIfvtE6Qc3LePCcXIuG5tnvthSEvz/44K5S+i8nan4jMvzPELkelGjS0CwEOnWZdEJT8=
X-Google-Smtp-Source: AGHT+IFN3XgZGUydfFw4/mbd3YmT+QXstnE6CrDDlxBYxDb55CdCB22fpDRPMIk2g4/sSsJBoMDeZg==
X-Received: by 2002:a05:6a20:734c:b0:240:1ad8:1821 with SMTP id adf61e73a8af0-24340b5e298mr17551742637.19.1756133872732;
        Mon, 25 Aug 2025 07:57:52 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.49
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:52 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 6/8] mshare: selftests: Add some helper functions for reading and controlling cgroup
Date: Mon, 25 Aug 2025 22:57:09 +0800
Message-Id: <20250825145719.29455-7-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8B36A0010
X-Stat-Signature: ic5whna3ytsi1e7ef7sor8rzdzmcaaf4
X-Rspam-User: 
X-HE-Tag: 1756133873-460263
X-HE-Meta: U2FsdGVkX1+CSIVJFJMTeOMolUN0ALdFPHmyYDYpvEOegq2X3wf9X0HHXt2Qn2TSOs9shYPcjWSYhR5UYhOr/oFH9wK/EcVizAwGyRLBGGnlPXomSeYGyYLI0ToAlkGLLp3iwk3Dn8tcaYtZtRI2hTZvTryGRWtoYjK7+bP3bZzmyXQj1iwvay+EB/VgW9c2jDjPlcb2TsIS1K6V4QHnIGwxXlCmG2Q8f6yk7n1OuVMzZOykfqw6KtR4DNE8NlkPPFdiWP23+X03LXf4ghJJR6CgG034v2HnC5XHA7SZDhnJDMUVk6kHOWkFo02SkElD97x4+6wfmuXy9x6TdbHUOR/c7oDInysGPXVrzHyJMi9xe9KMXQ1+KXZm1/MA7Qj6znYWZ0tP1dm2U3PByyWgCWFr5Pq3hc6gZg/GhzxI6vt9iSQMnjwDBrmZuIO3VMf61dHXy0q2cOg3ZIsclOOeYBswAzieP5qjReUqLxmzoLAqiL1E5RmKiu98rBLW/8OxzFA2k4QbqfvAf6ucFCRbojCz1TvIi5WbcVrILWi2QRgSt+K3M5SM3qcPF3nFlZgZTltEMlSg7aa2h4CGh6k+7ZcfJHMBZiZsVRkEInvFvYuDSYKJDetqohvnuNhQAQnK52tUSa4Djf1MR+HPxbFEMe5bytQrDxtj1esorJmTtiXXC5OyFRP5DinomouNLNwNmhDP3E55kzICY93/6fboFdGjQfRjV4oaRcioyviTn7v0Iah0IvoURMP7cbln8Fn0UqlvHuvYAZXMSvpNfHP11e/R0QZwDFUA9AOGD2f2sXyRP4FZQNZn+DiMQAnj9p2VozN/T6UsRAZZ2wFJ+nK4qW2F9FuXqRHTe8+YgOCGmAeQUx5FN07YsxSFGrFFouCUwQiNW4k2XUsYhIK+a+9zhRN4AyXeVO15tWfgkJROL4TbvqQdYD3ZQ1gUzNgeEYWEgps7DiDq4ExxVq/2eRN
 6AgUhNxM
 frrSbawQf4UOk0d2yynprc8PJgQFmSh5Gloo3+x3ZH/X8Rq47HXADKGPJKXb7FmlFIRqQy/hL9pyMk3sSISX8KP3Ngae4vb0kNT/NJOTUj13JiiWpmPVNMnIiBF2efdSRjEKNY/tBBWDBNIrejd3fc+pk3bAKrHVJlGXHRkxsdtI3ycYs7m6ZGwuYPqjdeDuzXryBiaFZqZTl/yl8JeMgFj+Ad8ZZ/pooGzPzNVvRAN9BcixFDQ+BP74Yi5HvHI8vwsvRGOyA2s4KOU4jNfxhRYqK6LPqUGDU/SC5mhuD4Z2Xj+0yrmgH91LgHA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before verify some complicated memory functionalities such as swap memory
and THP, we need add some helper functions to controlling the cgroup
(specifically, memcg).

These helper functions consist:
  Create and destroy individual cgroup for test cases
  attach and dettach the test process to specified cgroup
  Read swap size and thp size from testing cgroup

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/util.c | 128 ++++++++++++++++++++++++++
 1 file changed, 128 insertions(+)

diff --git a/tools/testing/selftests/mshare/util.c b/tools/testing/selftests/mshare/util.c
index 75f6ff25aa2c..94fddaea2c56 100644
--- a/tools/testing/selftests/mshare/util.c
+++ b/tools/testing/selftests/mshare/util.c
@@ -121,3 +121,131 @@ int mshare_ioctl_munmap(int fd, size_t size)
 
 	return ioctl(fd, MSHAREFS_UNMAP, &munmap);
 }
+
+/*
+ * Helper functions for cgroup
+ */
+
+#define CGROUP_BASE "/sys/fs/cgroup/"
+#define CGROUP_TEST "mshare-test-XXXXXX"
+
+bool is_cgroup_v2;
+
+__attribute__((constructor))
+void get_cgroup_version(void)
+{
+	if (access(CGROUP_BASE "cgroup.controllers", F_OK) == 0)
+		is_cgroup_v2 = true;
+}
+
+int create_mshare_test_cgroup(char *cgroup, size_t len)
+{
+	if (is_cgroup_v2)
+		snprintf(cgroup, len, "%s/%s", CGROUP_BASE, CGROUP_TEST);
+	else
+		snprintf(cgroup, len, "%s/memory/%s", CGROUP_BASE, CGROUP_TEST);
+
+	char *path = mkdtemp(cgroup);
+
+	if (!path) {
+		perror("mkdtemp");
+		return -1;
+	}
+
+	return 0;
+}
+
+int remove_cgroup(char *cgroup)
+{
+	return rmdir(cgroup);
+}
+
+int write_data_to_cgroup(char *cgroup, char *file, char *data)
+{
+	char filename[128];
+	int fd;
+	int ret;
+
+	snprintf(filename, sizeof(filename), "%s/%s", cgroup, file);
+	fd = open(filename, O_RDWR);
+
+	if (fd == -1)
+		return -1;
+
+	ret = write(fd, data, strlen(data));
+	close(fd);
+
+	return ret;
+}
+
+int attach_to_cgroup(char *cgroup)
+{
+	char pid_str[32];
+
+	snprintf(pid_str, sizeof(pid_str), "%d", getpid());
+	return write_data_to_cgroup(cgroup, "cgroup.procs", pid_str);
+}
+
+/*
+ * Simplely, just move the pid to root memcg as avoid
+ * complicated consideration.
+ */
+int dettach_from_cgroup(char *cgroup)
+{
+	char pid_str[32];
+	char *root_memcg;
+
+	if (is_cgroup_v2)
+		root_memcg = CGROUP_BASE;
+	else
+		root_memcg = CGROUP_BASE "memory";
+
+	snprintf(pid_str, sizeof(pid_str), "%d", getpid());
+	return write_data_to_cgroup(root_memcg, "cgroup.procs", pid_str);
+}
+
+size_t read_data_from_cgroup(char *cgroup, char *file, char *field)
+{
+	char filename[128];
+	FILE *fp;
+	char line[80];
+	size_t size = -1;
+
+	snprintf(filename, sizeof(filename), "%s/%s", cgroup, file);
+	fp = fopen(filename, "r");
+	if (!fp) {
+		perror("fopen");
+		return -1;
+	}
+
+	while (fgets(line, sizeof(line), fp)) {
+		if (!strncmp(line, field, strlen(field))) {
+			char *value = line + strlen(field) + 1;
+
+			size = atol(value);
+			break;
+		}
+	}
+
+	fclose(fp);
+
+	return size;
+}
+
+size_t read_swap_from_cgroup(char *cgroup)
+{
+	if (is_cgroup_v2)
+		return read_data_from_cgroup(cgroup, "memory.stat", "pswpout");
+	else
+		return read_data_from_cgroup(cgroup, "memory.stat", "swap");
+}
+
+size_t read_huge_from_cgroup(char *cgroup)
+{
+	if (is_cgroup_v2)
+		return read_data_from_cgroup(cgroup, "memory.stat", "file_thp")
+		     + read_data_from_cgroup(cgroup, "memory.stat", "anon_thp")
+		     + read_data_from_cgroup(cgroup, "memory.stat", "shmem_thp");
+	else
+		return read_data_from_cgroup(cgroup, "memory.stat", "rss_huge");
+}
-- 
2.20.1


