Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 536AE606A325
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=oYm3bLyz
Received: by kanga.kvack.org (Postfix)
	id 0ED4D6B05BA; Mon,  9 Nov 2026 22:30:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C51B6B05BB; Mon,  9 Nov 2026 22:30:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF6396B05BC; Mon,  9 Nov 2026 22:30:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B93836B05BA
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:30:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 37666140863
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:30:26 +0000 (UTC)
X-FDA: 85417781652.19.96530D9
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 55AB8180004
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:30:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oYm3bLyz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794281424;
	b=wnAFTQSxUJk6NWDIN0Pllc6a/Lbk+UPu/d02uw/b0Rqu5BLKJYmvvTGfmBThzYhSIjk6+D
	5W7Qkwojbylfn6ceHelmy3cWV/2Gy30vYvow1HceBRKIAnw2Myg1Ee0Akp0kM6D+UcLFyH
	/QCWWl1xlBzLuxBhQK+VxWVzrIk+XCE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxdjfkE2u6hMgUrERKs9IK41dx8VvemjPSvlkCJqFUU=;
	b=WC1+I67rys5TQAZX+XCA2781R54utStGJD1JCayjT+ggEiACHSUjmlim7ghwM4C9frvf+k
	kObvFzdNGJLkYNl0hpTio4LSPLjjmhyqDFR/dXXLX9LFTYRsygKaxL82C6Iwb9wYZm/xvQ
	HXPyW80IcZjxjyZ/Reg2ZprdO7dZH2E=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=oYm3bLyz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-8b6399ebb41so1400822b3a.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:30:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281423; x=1794886223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gxdjfkE2u6hMgUrERKs9IK41dx8VvemjPSvlkCJqFUU=;
        b=oYm3bLyz+Xf3crCXqnznUloacUY2WLsdOgHodC9IHsWJ1OQMRLQ7YWQH50CCZKGoqb
         aqv7qS1RfVIMpX1opcxbAm5MEWXxVIyfuih630P6hCaLL5JgO83Ed5skk0na/tS7rzm9
         zrPX14irmIW/6S/gjzsHbxSKKcXIoQcf2aHL3DXyE8kFC3QAETlePVrRFhNQSX8QWxGI
         ipqryoUtECZgfcXJbJxk7MICO1kIxWdpX/0ZU6CQVQWJbWB+tr7vupFriNGGWfVPlz9o
         7AE9OZLcc4eYJ/vwICMe0FahLiq49l1lQSunicH8NsV8axj6dHFZGj0KVBMQI0UX4r22
         vvxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281423; x=1794886223;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gxdjfkE2u6hMgUrERKs9IK41dx8VvemjPSvlkCJqFUU=;
        b=ZGpDYw5bq34p7oH4L7XGlwYK6Ws5rJ1x07WFJBaWf8rVOQpMwsxjEabcjjAOnNVqER
         a6m+JEJuMYMh3iHEMUckfobSorstFPKjZBEop2DF6aKcLjH0WcVXBsFuW8AQgQc+nJlQ
         9qpq845Nsju2GNr5zH/PCeHebsMn8n05g4F2hgmfdXV1/VYhNY+EoBzZm1LnihZhkdR7
         S8Syn0XFX3qvzEVG9aC7CO09cu7cw6WBOLEsayMz+CV4hDphsMYRaoiXzLBg2usTO5du
         juYM63SRtIX3VCJmO50MbTpXSv2UteryS29evEjoG0USCbMUNuejMd6MxV/v3+G6gAI5
         RWCw==
X-Forwarded-Encrypted: i=1; AL+hErEdcA68opX/nBcU7ldkPzmPRtdxkHKveGQPo/kVflMNxssw21iUSQ/OAPea6XYdcsie20glawppaQ==@kvack.org
X-Gm-Message-State: APuU4Z+HPV+sKg0FMKIQdqfK5uadRTAU8da9Vjdb2+n1B6jYSK+8hn8j
	5JdZlBoLv9Il6qzCn//bqVMU96sWhyJvBAQxsZ0hxfmHFpsHTHARnmBr
X-Gm-Gg: AYBFou1MdH7WJkaK+M1uW8xffhHBvGmItw3Ov8rB7Vxn0x/0gWPdJthBxo8yzRUthT0
	3VH+syUn0d+suDV48DVuh2nfeSi+MRJyoSR/SlLtOCOI3wYE8msTijeRaxVknpcSIdFA7kEIEwi
	DC3AMkFdlDX+XIPUMBdqKC3WIVRO0mKW9Nv5V52q3gQ/ZnXZcS9JnKe068/EfQAMsRMTK7g6ZF4
	kZiDn/10/oIPr2Yya44hVV/Bk7Nyr2dEbT237q7Z4Rs2jzJZPqmBMSaeHiTQwvNmEIUA0df6IZo
	fEFJo0VAicK5+qgGTAZyBlB4cd74Yn+NB9LzFUKiPQfXu5UfzJAm/kcNro2rHgG3asCdyLax+A8
	rUHYWppdJVY6I/uhInQ/n1rZyGyitQfdVkozWddXemxdMGP0QyeIbvNl5K9yWgkasHPxL0Er5Th
	MSp1QS+qJsYX7dX/49ijUI8ufnTB7oCPQ0r7iycVCu5jSSUF+mV/idgCIRj4oDD/LPGSdp1xgnV
	tMGCe3szlbsGDPaMjGKS9mqWNGYLzQTjRzWg716FJTtbQH5JEXOQadqM21v8kIRYsufIqeV1UnE
	5Y5GUnyY1OIm0cis/WtRJ0gye841Nl3ikh9itFTavY793th6xLkhAb2/3DaFl4Fux2C1pDliSfi
	uWXYPQuKqcIlGLBKH+7ODNdm4
X-Received: by 2002:a05:6a21:2013:b0:3e2:a9cc:3ece with SMTP id adf61e73a8af0-3f18e8c5cb6mr1040170637.23.1794281423096;
        Mon, 09 Nov 2026 19:30:23 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.30.11
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:30:22 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com,
	ziy@nvidia.com,
	mgorman@suse.de
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v4 4/4] selftests/bpf: add tests for the numab kfuncs
Date: Tue, 10 Nov 2026 11:29:13 +0800
Message-ID: <20261110032913.71974-5-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261110032913.71974-1-laoar.shao@gmail.com>
References: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 55AB8180004
X-Rspamd-Server: rspam12
X-Stat-Signature: jy66819sxyc1u1ewj3sdytgr9484ec77
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794281424-162012
X-HE-Meta: U2FsdGVkX1+ib8X3vl2cptatkkxjdRoE2dM6RgGHGkODVDTMF5xVcmPhlppCYR7p5vTeVhlMsVDZKvj/XtcXQx+J+lo69TFygvR6Rk8IW1drdC260e/vuV8ddaYf0FD7NnL2P5ynA1OwxFCtaWF3ZBsTtUQ1Zedox4rfu4SZCuHsjbhf8D+5/Vf1ago5QHRmhnlX8Dearug/+Bz8NJP3BegjaolpT70XonqVptt2RgBiZILzwbWNIAlM+ZV/X1WykGX9HPd1onNKDn/2SfTmR1sfMJwkbhtG0KKLQFAIFBb+ivvsNMeVzvepfxIlme38fNk9T1BzEEmDExuA/vTff5yWFJTvkPxCzcBWq7QQDpiLUPgSh1CQlq0RQjHCNNov9YjN2eurVlbIAu7lpTVsmYW/yGaRMYvQvVthqFWcNjO2zT4DA6KXKmtzTdcumvFlJ6FlzHAkAazU2M3zIvrzhM6OWl/1lKfiWFo6Df2/R9iZ5hdhhwCfAz3fX0JwnzJPw1slSwrqGroXS7Q2Sjqn14q7r04fnFJ3ruXOyLUux1MaoUgUsB1wkrMYAV8I+me3gXeYEbURFseAVdvsMH/t0dHH5LknDRwTAYsrlXJoBF32BFEfBGiv2Psc09bBUobcVQl4E3JkRFa+AL2CWn6cAF73X3WQ6phAXihEbgNUdAKrCWY4k2jZrkxm8dnFCZGTmOnNuKFSvySfh75dM2j2aOahLwCqS9S+MGOzk9kLx69/X0Ytyljz7KPAsdF7MUt4eDajLJcpi4Or+2W5a4+1F54vClRNGBRVTzHeWpR8NQGbkdKoTU9rZ1J30UE0Q0BCwDQIQkPkYdPJ4VhG55esPQAUw5dGN3ayBSQLilf3Qy7BXvmni2/te5O1WUjNkxtQ4IR8XfbhE+D4uavUz3S+5rBtK80ON8Dmb6NlpurRLGI/UEbddj4KCTiG9UpYPTXLTXJQtrT4OpGIuJIE775
 zvk5WSoI
 sSWoLOr+7AxDRzZHNi9SXeLWeUBcgDUxhQmKpfEXPyIvpyQUvfJZsAKUcdka8qGpwvzJaZuH/bn2PGJUPJlqsj85U+jXzdgnm44PeGj2xc4rX7ldoMwgoJFBlyUkct3JUkl/4f0nonXL9cLpHZcsCtFds9LAG3PkmtQi2v32lokGyqtZbuaOWQ3f56vER4J3vmr9t7EYa7ODzx5P8F7qFvqeebWhstOnBEIEXqapkeaGQyjxkslltKYnexkFe9hus3tS1W2R/HoDDKulKvJ2j4Nq0qXChhF1xkwBUcs6nS1vcq2WLaytBmwS36wNk47KObvpKMqw7xUNSHflNe9RBrtAtNUz6QjnA4wXbDjWi2ZZrKzrnIRtk/V6XbhjIdLNGSxohPft9xXGH6usS9nFwBkTCtIqU0qj4BHMIW9naHGXkGldLP35fpxpopDmjysPMekedXCIOIqqzNp3ZpYUjufWcG0H7+VVqEFs4RfLefPt/l4JRwkcZQPRfjx+q1MwQdyw3YsmkLDWIGHAQvkwr0wKIXbdx9dMuLz6+3aVe5hk0AmxFQY8Uehdz9nauPPpKr8hgXPJ3AOfbQPjQpoHD3bKI+va2cqRqAiZruI0MosErGkc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Exercise the bpf_numab_set_mode() and bpf_numab_get_mode() kfuncs
through BPF_PROG_TYPE_SYSCALL programs: the set/get roundtrip, the
mode domain (NUMAB_FOLLOW_SYSTEM and the NUMA_BALANCING_* bitmasks
accepted, anything else rejected with -EINVAL), unknown cgroup ids
rejected with -ENOENT, and the hierarchy combination the memcg walk
produces (inheritance, OR-ing, and an opt-out winning over every
request in the chain). Also verify the memory-controller requirement:
setting on a cgroup without a memcg is rejected with -EOPNOTSUPP,
while bpf_numab_get_mode() resolves it to the nearest ancestor memcg.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/bpf_numab.c      | 273 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_numab.c |  32 ++
 3 files changed, 307 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c

diff --git a/tools/testing/selftests/bpf/config b/tools/testing/selftests/bpf/config
index 49dfe939467c..e56c8872e51a 100644
--- a/tools/testing/selftests/bpf/config
+++ b/tools/testing/selftests/bpf/config
@@ -7,6 +7,7 @@ CONFIG_BPF_JIT=y
 CONFIG_BPF_KPROBE_OVERRIDE=y
 CONFIG_BPF_LIRC_MODE2=y
 CONFIG_BPF_LSM=y
+CONFIG_BPF_NUMAB=y
 CONFIG_BPF_STREAM_PARSER=y
 CONFIG_BPF_SYSCALL=y
 # CONFIG_BPF_UNPRIV_DEFAULT_OFF is not set
@@ -78,6 +79,7 @@ CONFIG_NET_CLS_FLOWER=y
 CONFIG_NET_CLS_MATCHALL=y
 CONFIG_NET_FOU=y
 CONFIG_NET_FOU_IP_TUNNELS=y
+CONFIG_NUMA_BALANCING=y
 CONFIG_NET_IPGRE=y
 CONFIG_NET_IPGRE_DEMUX=y
 CONFIG_NET_IPIP=y
diff --git a/tools/testing/selftests/bpf/prog_tests/bpf_numab.c b/tools/testing/selftests/bpf/prog_tests/bpf_numab.c
new file mode 100644
index 000000000000..6fb6a4d9f291
--- /dev/null
+++ b/tools/testing/selftests/bpf/prog_tests/bpf_numab.c
@@ -0,0 +1,273 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <test_progs.h>
+#include "cgroup_helpers.h"
+#include "bpf_numab.skel.h"
+
+#define CGROUP_PATH	"/bpf_numab"
+#define CHILD_PATH	CGROUP_PATH "/child"
+#define HIER_PATH	"/bpf_numab_hier"
+#define HIER_CHILD_PATH	HIER_PATH "/child"
+#define NOMEM_PATH	"/bpf_numab_nomem"
+#define NOMEM_CHILD_PATH NOMEM_PATH "/child"
+
+/* The per-cgroup request domain, mirroring the kernel constants. */
+#define NUMAB_FOLLOW_SYSTEM	(-1)
+#define NUMAB_DISABLED		0
+#define NUMAB_NORMAL		1
+#define NUMAB_TIERING		2
+#define NUMAB_NORMAL_TIERING	3
+
+static int numab_set(struct bpf_numab *skel, u64 cgid,
+		     long mode)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	int ret;
+
+	skel->bss->set_cgid = cgid;
+	skel->bss->set_mode = mode;
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.numab_set),
+				     &opts);
+	if (!ASSERT_OK(ret, "set run"))
+		return -1;
+	return skel->bss->set_ret;
+}
+
+static long numab_get(struct bpf_numab *skel, u64 cgid)
+{
+	LIBBPF_OPTS(bpf_test_run_opts, opts);
+	int ret;
+
+	skel->bss->get_cgid = cgid;
+	ret = bpf_prog_test_run_opts(bpf_program__fd(skel->progs.numab_get),
+				     &opts);
+	if (!ASSERT_OK(ret, "get run"))
+		return -EIO;
+	return skel->bss->get_mode;
+}
+
+static void test_set_get(void)
+{
+	struct bpf_numab *skel;
+	int cgroup_fd;
+	u64 cgid;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	cgid = get_cgroup_id(CGROUP_PATH);
+	if (!ASSERT_GT(cgid, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_NORMAL), 0, "set normal");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_NORMAL, "get normal");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_TIERING), 0, "set tiering");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_TIERING, "get tiering");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_NORMAL_TIERING), 0, "set both");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_NORMAL_TIERING, "get both");
+
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_DISABLED), 0, "set disabled");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_DISABLED, "get disabled");
+
+	/* Back to the system setting. */
+	ASSERT_EQ(numab_set(skel, cgid, NUMAB_FOLLOW_SYSTEM), 0, "unset");
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_FOLLOW_SYSTEM, "get unset");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(cgroup_fd);
+}
+
+static void test_invalid_mode(void)
+{
+	struct bpf_numab *skel;
+	int cgroup_fd;
+	u64 cgid;
+
+	cgroup_fd = test__join_cgroup(CGROUP_PATH);
+	if (!ASSERT_GE(cgroup_fd, 0, "join_cgroup"))
+		return;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	cgid = get_cgroup_id(CGROUP_PATH);
+	if (!ASSERT_GT(cgid, 0, "get_cgroup_id"))
+		goto cleanup;
+
+	ASSERT_EQ(numab_set(skel, cgid, -2), -EINVAL, "set below domain");
+	ASSERT_EQ(numab_set(skel, cgid, 4), -EINVAL, "set above domain");
+	ASSERT_EQ(numab_set(skel, cgid, 0x1000), -EINVAL, "set far above");
+
+	/* The rejected requests must not have stuck. */
+	ASSERT_EQ(numab_get(skel, cgid), NUMAB_FOLLOW_SYSTEM, "get unchanged");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(cgroup_fd);
+}
+
+static void test_bad_cgid(void)
+{
+	struct bpf_numab *skel;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		return;
+
+	ASSERT_EQ(numab_set(skel, 0, NUMAB_NORMAL), -ENOENT, "set cgid 0");
+	ASSERT_EQ(numab_get(skel, 0), -ENOENT, "get cgid 0");
+	ASSERT_EQ(numab_set(skel, 0xdeadbeef, NUMAB_NORMAL), -ENOENT,
+		  "set bad cgid");
+	ASSERT_EQ(numab_get(skel, 0xdeadbeef), -ENOENT, "get bad cgid");
+
+	bpf_numab__destroy(skel);
+}
+
+static void test_hierarchy(void)
+{
+	u64 parent_cgid, child_cgid;
+	int runner_fd, parent_fd, child_fd;
+	struct bpf_numab *skel;
+
+	runner_fd = test__join_cgroup("/bpf_numab_runner");
+	if (!ASSERT_GE(runner_fd, 0, "join_runner_cgroup"))
+		return;
+
+	parent_fd = create_and_get_cgroup(HIER_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "create_parent_cgroup"))
+		goto cleanup_runner;
+
+	if (!ASSERT_OK(enable_controllers(HIER_PATH, "memory"),
+		       "enable_memory_controller"))
+		goto cleanup_parent;
+
+	child_fd = create_and_get_cgroup(HIER_CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_child_cgroup"))
+		goto cleanup_parent;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	parent_cgid = get_cgroup_id(HIER_PATH);
+	child_cgid = get_cgroup_id(HIER_CHILD_PATH);
+	if (!ASSERT_GT(parent_cgid, 0, "get_parent_cgid") ||
+	    !ASSERT_GT(child_cgid, 0, "get_child_cgid"))
+		goto cleanup;
+
+	/* The child inherits an ancestor's request untouched. */
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_TIERING), 0,
+		  "set parent tiering");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_TIERING,
+		  "child inherits");
+
+	/* A request ORs with the ancestor's; NORMAL does not undo TIERING. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_NORMAL), 0,
+		  "set child normal");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_NORMAL_TIERING,
+		  "or both");
+
+	/* The child's own opt-out wins. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_DISABLED), 0,
+		  "set child disabled");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_DISABLED,
+		  "own opt-out wins");
+
+	/* So does an ancestor's: a task is never forced into balancing. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_TIERING), 0,
+		  "set child tiering");
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_DISABLED), 0,
+		  "set parent disabled");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_DISABLED,
+		  "ancestor opt-out wins");
+
+	/* Unsetting the parent re-exposes the child's own request. */
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_FOLLOW_SYSTEM), 0,
+		  "unset parent");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_TIERING,
+		  "child request again");
+
+	/* Unsetting the child leaves the chain with no request. */
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_FOLLOW_SYSTEM), 0,
+		  "unset child");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_FOLLOW_SYSTEM,
+		  "no request");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(child_fd);
+	remove_cgroup(HIER_CHILD_PATH);
+cleanup_parent:
+	close(parent_fd);
+	remove_cgroup(HIER_PATH);
+cleanup_runner:
+	close(runner_fd);
+}
+
+static void test_no_memcg(void)
+{
+	struct bpf_numab *skel;
+	int parent_fd, child_fd;
+	u64 parent_cgid, child_cgid;
+
+	parent_fd = test__join_cgroup(NOMEM_PATH);
+	if (!ASSERT_GE(parent_fd, 0, "join_nomem_parent"))
+		return;
+
+	child_fd = create_and_get_cgroup(NOMEM_CHILD_PATH);
+	if (!ASSERT_GE(child_fd, 0, "create_nomem_child"))
+		goto cleanup_parent;
+
+	skel = bpf_numab__open_and_load();
+	if (!ASSERT_OK_PTR(skel, "open_and_load"))
+		goto cleanup;
+
+	parent_cgid = get_cgroup_id(NOMEM_PATH);
+	child_cgid = get_cgroup_id(NOMEM_CHILD_PATH);
+	if (!ASSERT_GT(parent_cgid, 0, "get_nomem_parent_cgid") ||
+	    !ASSERT_GT(child_cgid, 0, "get_nomem_child_cgid"))
+		goto cleanup;
+
+	/*
+	 * The parent has a memcg; the child was created without enabling
+	 * the memory controller in the parent's subtree, so it has none.
+	 */
+	ASSERT_EQ(numab_set(skel, parent_cgid, NUMAB_NORMAL), 0,
+		  "set parent normal");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_NORMAL,
+		  "child resolves to parent memcg");
+	ASSERT_EQ(numab_set(skel, child_cgid, NUMAB_TIERING), -EOPNOTSUPP,
+		  "child set rejected");
+	ASSERT_EQ(numab_get(skel, child_cgid), NUMAB_NORMAL,
+		  "child get unchanged");
+
+cleanup:
+	bpf_numab__destroy(skel);
+	close(child_fd);
+	remove_cgroup(NOMEM_CHILD_PATH);
+cleanup_parent:
+	close(parent_fd);
+}
+
+void test_bpf_numab(void)
+{
+	if (test__start_subtest("set_get"))
+		test_set_get();
+	if (test__start_subtest("invalid_mode"))
+		test_invalid_mode();
+	if (test__start_subtest("bad_cgid"))
+		test_bad_cgid();
+	if (test__start_subtest("hierarchy"))
+		test_hierarchy();
+	if (test__start_subtest("no_memcg"))
+		test_no_memcg();
+}
diff --git a/tools/testing/selftests/bpf/progs/bpf_numab.c b/tools/testing/selftests/bpf/progs/bpf_numab.c
new file mode 100644
index 000000000000..25da97bce82f
--- /dev/null
+++ b/tools/testing/selftests/bpf/progs/bpf_numab.c
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <vmlinux.h>
+#include <bpf/bpf_helpers.h>
+
+/* Inputs, set from userspace before each run. */
+u64 set_cgid;
+long set_mode;
+u64 get_cgid;
+
+/* Results, read back after each run. */
+long set_ret;
+long get_mode;
+
+extern int bpf_numab_set_mode(u64 cgid, enum numab_mode mode) __ksym;
+extern s64 bpf_numab_get_mode(u64 cgid) __ksym;
+
+SEC("syscall")
+int numab_set(void *ctx)
+{
+	set_ret = bpf_numab_set_mode(set_cgid, (enum numab_mode)set_mode);
+	return 0;
+}
+
+SEC("syscall")
+int numab_get(void *ctx)
+{
+	get_mode = bpf_numab_get_mode(get_cgid);
+	return 0;
+}
+
+char _license[] SEC("license") = "GPL";
-- 
2.52.0


