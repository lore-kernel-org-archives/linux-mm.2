Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA53EF48DC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 07:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1214C6B0093; Fri, 13 Feb 2026 02:24:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E24F6B0095; Fri, 13 Feb 2026 02:24:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 022926B0096; Fri, 13 Feb 2026 02:24:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E8B986B0093
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 02:24:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B890B8DDA
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:24:23 +0000 (UTC)
X-FDA: 84438595206.07.684C355
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id C0BC9A0009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 07:24:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AxOI7my/";
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770967461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E55JfgQKp+ZEiIAnBu3r9GQXW9g+xnXnuS4C381ry3Y=;
	b=fIc0xf4eSRy7nEp780bEd5E1aRW6Mr5KbvYd8lzEuT1OFYnWk6BlWHZQ+ew5smiWrkJvTt
	rKzM13p+2Vcou5sWhdtY+NtsdIdCy7UA3Sq6kMjlKO8DBCdVpKscGuqhsE48BxXzBQ5Y82
	PzlzZYvqDRsMDTd7Cjfs493/9D6Jaqs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="AxOI7my/";
	spf=pass (imf15.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770967461; a=rsa-sha256;
	cv=none;
	b=xfFntlMKD+Br9lWFnw05V9ULovtgrGlcAHbe/Xt4GLfwviFojs4IYSilanUrq46YIBOgSy
	fG3Rx2SsPrtCcvfSvPBD7xzQgSv/bHiED5knJA+7wbBe/eRLwcnsqiC8XHcZN5zCrJy3TX
	NGrQFI0W9aWjwaDNaLtGrJwoxhXzY1E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770967460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E55JfgQKp+ZEiIAnBu3r9GQXW9g+xnXnuS4C381ry3Y=;
	b=AxOI7my/78Mr4e23DAMG8qSm8RywqTJoU/wugb08PyinUbE2c+4BRDnDNkUbmTScXCCZBZ
	hBlp4yETtJ+NjBdDb+TczClhFhU6q1d8Ub0jqbhpQLyaIC9CxgzlOwAhiaPifXtNr33Zye
	CeoaKYGftGe+eQ3I9FNd48m6bPHv0Xg=
From: Hui Zhu <hui.zhu@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Martin KaFai Lau <martin.lau@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Song Liu <song@kernel.org>,
	Yonghong Song <yonghong.song@linux.dev>,
	John Fastabend <john.fastabend@gmail.com>,
	KP Singh <kpsingh@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Hao Luo <haoluo@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Hui Zhu <zhuhui@kylinos.cn>,
	JP Kobryn <inwardvessel@gmail.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next v2 3/3] bpf: selftests: Skip kmem test when cgroup.memory=nokmem is set
Date: Fri, 13 Feb 2026 15:23:41 +0800
Message-ID: <447797edc394ab8a8b2484bb6c92b56115254e27.1770965805.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770965805.git.zhuhui@kylinos.cn>
References: <cover.1770965805.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: fwc1y5bizz3ikchk9ks5gkmkbdfx4t5z
X-Rspam-User: 
X-Rspamd-Queue-Id: C0BC9A0009
X-HE-Tag: 1770967461-729799
X-HE-Meta: U2FsdGVkX19T8Y/IVpI6yEiqNWWyGlLsFiNdPUJ4IivaHGnW44fgatH6LDXGlX8gKHKfkDe1EoO5ylUm0dDkgtEhpMQASqBxXvIfC3K+qwoYNkpfvPBd4y3ZYf5xG0NbeOqYMP33yAmPGo33G3NgxBaR5T1LZNhFs2uMv6th26podCQ0RWV1JQkYlxzg5ukwkiBxQ3Qi6o1uqMUR21yNYzR8atiG+ve7tW4aRHbaG9xnLNa4MOxiQxGnPPeNZslwUn70YBJHSyy2wHpd5dBomJ0kshViH/vSwDH0X6lTxVXiIuJJWxMaJ+8e/1mcNzGNbtY3Zarn0PckwyXOPhw3FiO9Ma+aFOhf+YU+/Vx7B3Apamtzkwhpt9ZCH6IiNRZ3nyOmsBWSzfJOGTuQE+QUgMh9XVRHbFonoWmpkqId32DJTk+f9rRi1rE9XYveueUQk7FaBFl20Nn7bVjFSKZTI946gM0StuqEqVF6/aWwokQqrj3+PF7R1IfHfkJRW8nspA1pmfqbjlVJ/+RESzICKZsgGF4rLjg1TROXzg3U2JrpLEpCAmga4Oq0S6MUe9Com14HGvwyuM54fFQu0FJQnnepvaRmyTMqpcK/2+I4Yqi0SyOB9J5zIjnM5C0DkUGdNa/NavXtmmO3h2r+KiV98CmCBOU6hL85j76Bfgj8GltkV72pCiwK96JHjMz1y8oHPqh13bgv/dtXYQ2Xd8+kw261sC8Fi+oWLl+BlunF1MvrvmvykEx9vwD8QSHNe4wzw/o5pAUSFqSGzL9E4+XguSWByoh+xBs6uX4d85T8wn/KynQXOLWXYd6pWYpGnvckrPlpgcLBmceOxNQGgP3KjJSv+gqb1xYcJlmFNIp1qSEuqiWwqnn3Nd+YdL+xMFxRhjqDjT3hZAJrco96KohsV4vbgBIRQ+4G2Xu6SV+9YrzCbGkrUzvCrxLSYRh6INs0ZBST0ebbAGfBcaLvtiT
 NSBuFfs1
 tyAKn7pGsKm1kJSCeQ4LKyuaUxlhXNWeRyFYfxqTI+TygucTPQT5pYrZGpxKyg+s6VL8XIgWBesg/gpPYSRZ0FihgyEJhp5NO9wtj0bvKTfqV3RdGxlxc9O6nyDlNSYbJOdyC/2b3rtrw4eoinGSn4McW/6SmmlKaNNWRm7Yie3z3TBVclvSTDdAmlVWCNBVPpA6niN3/A+Q0wx0nR2Q45uQCcBSLMQO9MgJP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

When cgroup.memory=nokmem is set in the kernel command line, kmem
accounting is disabled. This causes the test_kmem subtest in
cgroup_iter_memcg to fail because it expects non-zero kmem values.

Fix this by checking /proc/cmdline for the nokmem parameter. If
found, verify that kmem value is zero and return early, skipping
the pipe creation test that would otherwise fail.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
index 897b17b58df3..2b9c148cebf0 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -134,11 +134,41 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
 	shm_unlink("/tmp_shmem");
 }
 
+static bool cmdline_has(const char *arg)
+{
+	char cmdline[4096];
+	int fd;
+	ssize_t len;
+	bool ret = false;
+
+	fd = open("/proc/cmdline", O_RDONLY);
+	if (fd < 0)
+		return false;
+
+	len = read(fd, cmdline, sizeof(cmdline) - 1);
+	close(fd);
+	if (len < 0)
+		return false;
+
+	cmdline[len] = '\0';
+	if (strstr(cmdline, arg))
+		ret = true;
+
+	return ret;
+}
+
 #define NR_PIPES 64
 static void test_kmem(struct bpf_link *link, struct memcg_query *memcg_query)
 {
 	int fds[NR_PIPES][2], i;
 
+	if (cmdline_has("cgroup.memory=nokmem")) {
+		if (!ASSERT_OK(read_stats(link), "read stats"))
+			return;
+		ASSERT_EQ(memcg_query->memcg_kmem, 0, "kmem value");
+		return;
+	}
+
 	/*
 	 * Increase kmem value by creating pipes which will allocate some
 	 * kernel buffers.
-- 
2.43.0


