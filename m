Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D9DEDF057
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1CA6B008C; Thu, 12 Feb 2026 03:24:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059EF6B0092; Thu, 12 Feb 2026 03:24:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF566B0093; Thu, 12 Feb 2026 03:24:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DEF696B008C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:24:06 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A40A3160741
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:24:06 +0000 (UTC)
X-FDA: 84435116892.23.25D5A2A
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf29.hostedemail.com (Postfix) with ESMTP id 061A5120010
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:24:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mtLG1Cj7;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770884645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qa7yRxcpGL3PnKF4R1l2meMqj6ZYK13/0dyEKREpmhI=;
	b=cJXSa44MkepvlDjSsLYlSZ4eweibv8dqxjF6LAvaQrARsdUFV2RAQY/8cr6GiHEM/92u1O
	2Be296fJpqJl2ZRap0YqlytdmfaOogZcJbkN+oIpHA3F0yqHEdxKhB4acT8oNNuJPdJBj9
	7olsc+eg1SEDVbHtD4fEdhfRfksX/hg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mtLG1Cj7;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770884645; a=rsa-sha256;
	cv=none;
	b=1a89hfHbA+1JhlJeM1Zzgm0en5doSeUV8LerlByYep3KJsnfWWDKX29v7elI5M8BtYGWC9
	ec/Y+0DKfbPgLfqsHyj3NFGWie2lnXTzawqyaqyvRgrJHUlzRQ9pzaSk7TqScry+hDtJm4
	fcmRWLnmbNeXxoV4TiLEPDsOurVAOPY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770884643;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qa7yRxcpGL3PnKF4R1l2meMqj6ZYK13/0dyEKREpmhI=;
	b=mtLG1Cj7F/NN0pQvl1k5tAmMqtzQ0Q7TM4SCVi9GMjgpIDSLSvRuNgxNUBKEWiMccVbj7z
	K8W4rDks82e97Z8KcgkhM8a3y1wY/HTQgqGjhSAkMrndvzi66dbkI4Pxi7c8hQrM0ljZR8
	mAMheL03KE5ojdB75JZXNKsapNcnw0A=
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
Subject: [PATCH bpf-next 3/3] selftests/bpf: Skip test_kmem when cgroup.memory=nokmem
Date: Thu, 12 Feb 2026 16:23:16 +0800
Message-ID: <2f6ee1db173b67a636b2caa85744cb4ce8114e64.1770883926.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1770883926.git.zhuhui@kylinos.cn>
References: <cover.1770883926.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 061A5120010
X-Stat-Signature: qc1wg6wap9kqxk78un8885d3wke454ka
X-Rspam-User: 
X-HE-Tag: 1770884644-453826
X-HE-Meta: U2FsdGVkX1/tRN2dFhhwbxinzsLyjwLNs8AQvqsqMtmbL4Bqsb9Sh7p/NTdyF7M0ObED0ModXZgKRtAsCaAWM1OzgECTLjnCXbrNohQRec2/T2Buw7p8KuSqHJktcZE+XwerjEJ34RCPJiYAFNbYPV3N0pzCpHS6JqhJj12tKrO/At+Wp8OxW/+e7H9ft9hk61w4ElwYYpaoYPCgyMK5CSusWHYgI90wVtNh8Y1xBes9e8wEfYTg5WKn29nSsnryZ9Q1apMi8BoOVemqsDasqYiWSM4bQTDOo/Mar3C75IZhkoe8pVFzsZ6/mvf+8YyWnxjrz3qQY/bXaOl2w+I+uxU3ZjUA0xaUJkIaPVYZii3ZJur2lt829JNUFQo14SfljF4sfg772iM5+7bxmktpe545xgzkeW1NWbNZIC1ibYZyEE77CdJtOruZjVsUf0qwTenLyVZBHkl3gh80bTwfkWY+nJWHzVyNFB72eUuBNszn1r/gydO9zAAALQBY0v1xAMphnWtXz7QfYrW8+e9n5HkeYlTAi47YUmMbayQlN8y+YQH2nV34VQogmV5lJIeNMSiar8dSCa+7e1dCwnJmrSrpwRRr6kQLCfgkIFhqfcotjLUJP9r7n/CghEWaXn6zmrG1fgT7t6oJrKdGiVRdrmylRALgdWmvt6uokpbEvfBIDo0ES3nVUzev8tYJJFbm79odH0g7PMSb4pXbk0LJmwA3oy6Fh8LjeAxVkyt+liR8ZkJ0S1r09ZB/34Fj7xEDh59TvSZVlUhg4o7cYQZ59RXRwtXj/BKbHdKOJqiNQ4CT/mpgtXIaWH25GUli1ROT2R/htoL00cl8H97I2bXj+84UBrfzHKnvIAMVz33j6m2VgXSfbHVp9thnGADM2Jf1aMwQNVoH8MzP1Bbq94hUnAXUBxIJNcvYHOOCbHBjP+lwFMV1pX4TJoKh4kLDcoBk6YP1xH71/z4kofcIgpu
 imI9Vf+0
 0qE/YDnUvE3uGmqivgvviaz/1zNuOMI8MnKF6YuJuPumZBRNtVHjCW+EtZLNpAAg+iMiKkD2jUhOLchqsCv8K0bspu+c/FA5TQO6jtx/bABlKiNYNCRKRYDK2jIoumME6Hr8LveqU8Sd8nkmnuj3kYr+dbP4nK+y7k+De477fqCV8S744uSkw7SqNxUC5Qce5EzUDoLXkPw1FCOknlcrRbBvQxLk45j+w2Uvt07xvnMsxXSwe7YndaT+99nW0igCpwOIGEGDy3HceD0Detp8/1ME9OA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

When cgroup.memory=nokmem is set in kernel command line, kmem
accounting is disabled and the test_kmem subtest will fail.

Add a check to skip this test when the parameter is present.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 28 +++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
index 13b299512429..203e6b091a21 100644
--- a/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
+++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
@@ -134,11 +134,39 @@ static void test_shmem(struct bpf_link *link, struct memcg_query *memcg_query)
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
+		test__skip();
+		return;
+	}
+
 	/*
 	 * Increase kmem value by creating pipes which will allocate some
 	 * kernel buffers.
-- 
2.43.0


