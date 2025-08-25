Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29549CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A6058E003D; Mon, 25 Aug 2025 10:58:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6566C8E0038; Mon, 25 Aug 2025 10:58:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E0F8E003D; Mon, 25 Aug 2025 10:58:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C4858E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E05731DDA78
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:26 +0000 (UTC)
X-FDA: 83815585812.15.E2C91DE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id C6B5E40007
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:24 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NNpG+9iE;
	spf=pass (imf01.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frobiiF+V7JXOVqxsCpLilnhoxfx3g4fKn8gApXFwiY=;
	b=JVsYD9cO0LoasIlHXVPdrwk92/ZkEdA7fhtbDc0nAYf7qxnxkyBIBrt5AaY6Slv4bbEhUI
	XSFRI2VuKsJG4JvRQu7jTfM5nDFyG7gg/QLXmxItk6KEOwRtK+sCuJKAjt63txXdlsM4q2
	FZAyaT2G44pNbK5hRgZTbqe4dQsW5gQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NNpG+9iE;
	spf=pass (imf01.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133904; a=rsa-sha256;
	cv=none;
	b=Jk1ADuGK94Sx6ioRh6Zr2KbLxmckhnykRCoCAddyfRwb2XaWrFt4C1//9T0cgnRFIM/hF4
	wpfACZKlPiKfsFD+WLPEjBGdzQK6v0a92/kCK7flXzKhO0KVQWRKYnjHdA1SkSL3PhSHAc
	RsJ1w8ARs3uquc/qrf6c1aaq/p05GgM=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-770530175a6so906793b3a.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133904; x=1756738704; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frobiiF+V7JXOVqxsCpLilnhoxfx3g4fKn8gApXFwiY=;
        b=NNpG+9iE8SXbVj9Dg4I6ucvm2aAZp+TuZPOVNoRnrQ8t8VUntf0BnbGg8m3Mr4H2qv
         RVmjPZWMThw3DFG5zWcfOaIqpkUDYcnST2JzleYxUSNBPEV1dDvPh358CJjV3urHPDT8
         xcBRBeg91NFfGCJgxik9MEEnP8E9sJ5KtIIQz1iTzpqB2q6UFk/GpMkqI6UKqO+MUQyS
         6jpQw9e3mLX4yTY9jn87JnnIAalwRTOLz1tLHNMHrwyh5Asx/hnufDiSDmjsdaqshhX9
         GJ8k3pbhK8HhX7mk+0mp5KXIdyBf4Un5xVNf5dFifJwKRbjXeH3mRC0EfxIcIBBLL2yr
         28+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133904; x=1756738704;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=frobiiF+V7JXOVqxsCpLilnhoxfx3g4fKn8gApXFwiY=;
        b=Ff0NLXCSHoltn51jXrZCobXfazTe94xVgzNNNj3nKmktooKONQjIDn/TgLTNU1WnGu
         W33VV2OF/pTT/ci/R8afzkEiqywdUjBXpEitCUAB26SMhWnVZB4L4PQgp3BgITdvMaUU
         ICMOGUHDdzvc+fwcui67koVRfbv/VOLDDciqO6DyBOVH56qlj0XtDU+j+y0KL3u5erPu
         xNKoeh1Pp15plQQOGTolbfq66qlMxY5mWVHTHpMDc9fMrOGKBfWjekpN5yEUw3xNorLw
         13LIjsIhIEr9B+TkEClWFkiSEG3kXhcINxGrX2duLhETyc/bhcKnzuIqW9Ua+gXjUpGa
         0R5g==
X-Forwarded-Encrypted: i=1; AJvYcCWkgzK3eGSicEJhxHFoO+/QukD58S5A0DHQRVIpJD9xdrpHqR7wa+OX734GMryqtET6GuRO60zqvg==@kvack.org
X-Gm-Message-State: AOJu0YwCa6J/Dm/ZkbfuYCOUv/JJO0MbmkxOonr5Z4+Ksiv4rp3VZMLS
	KK+U8KMUR/rPptJYa4Rg/+6h3gW7Fl91EZwY+Uzr7rt07g+rsfnTYAJYcf5B97W+oVw=
X-Gm-Gg: ASbGncsGGJvXWEhxJu9fvQDXlEVvuuXNty0une39isazsr8T0J5fCHSkbBH4S7HhwoD
	NOO+T9PdQZQk+eibURfj+PDZruCo5yLIW32r2+4afcHaXhKazJ9rGYkoAQBu1nusVFDEyOkG2Z4
	J5xiRyJKyrmsyh5YCFzfF0msr1xdpBw5d3kjlHMReYo1snUYaTgKM8ZgemPHSBPb+3xXdMZFF7d
	0nqEQHmqL5gQ4Q7oJp3OIKCBMajcnYj49vLmJjDmD0K554DxuJjfIHMIwRXtpbGWWURnI2GgJG0
	rWKq2yEZsqGBhAghTwpV/oG/hnbirGhLZLJXMrYI/aRN1BfaLQ7UNvKSDCaY+5bYc+y2DXgKxZd
	r8oBs0blizxKqSRwYRcnU1zsC2oCM/k8q6MfIe7keRRrz2WgvPw8rm5tkwhIT
X-Google-Smtp-Source: AGHT+IG7Oofc5Cp5x58qIccTW/mt1D9LGI3RCFnvY/URUYZhtnINl3UlS8zIeItcw+B6/b2CMeUqrg==
X-Received: by 2002:a05:6a20:3942:b0:240:d14:c7e3 with SMTP id adf61e73a8af0-24340c1475emr19568752637.24.1756133903397;
        Mon, 25 Aug 2025 07:58:23 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.58.20
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:58:23 -0700 (PDT)
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
Date: Mon, 25 Aug 2025 22:57:17 +0800
Message-Id: <20250825145719.29455-15-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C6B5E40007
X-Stat-Signature: ic5whna3ytsi1e7ef7sor8rzdzmcaaf4
X-Rspam-User: 
X-HE-Tag: 1756133904-870437
X-HE-Meta: U2FsdGVkX1+KqQ71D/JXQk8fifYV42QjhjYORPunKztEbXzf/+bSghMZ1y00mJUHTyF1hU8DAIn1njulJ1kUQ2tNlg2THapl0KR1Tuy00ZAMvm7krE0WWd1R/xhxPeDEWFrcol2a9MdJnjsvlIG69FweluMzSQKjCSA+w2VarGx666QVdRd7IZVfuNKLA2Lg+WiLftzy0b+MfZCHj1HwbOCTJmLH55UfL9Edkrd2SYLynmmcgakJNOasQdHnX/vJIJ+fsVa8iplv1rVd+sDsJTomIYOMOVSBLfOMFji7U+3J5PunGE4gb/SO/jPr6i/+bSk7T2gtOvq4KXLllo41Pwc/4zJofMZJogh9N3ZP5KVEzJGRWdRurnnRRLMq7NNLVqopLMwvuNnU7g5lrd6d/zP7PMIQA5W2QaGbpfeCJDHthXbTN8nDJUVa3IRGw+Ls+DLCJoTRvlYgGmZK4h2b+kK3UQnt8xSMxFpC74q7ld45TCYCjNhido39witD2P0DRxkGQiCBdxdaq/16M9bjLo+FTqiaBlXS0MAV9K9LYuT7HnaSWs45KrGPleIu4gd5xg7/0Uvvnlmn3KSYqdYoyKRePlpWIGiSDaFmR2/a0GkQIwEJzhGFmehP/JwElyPdCjC3kxZe0IW3iB6a1aqabEZLL41RMie6cgHMq1lZ0xxI8GvJXuOIShRuD3gsoPaT0YLPFAlz6SiPXUTD0eYPA3TXseAwTM1+cVTOXelYGLi0Gylt4Bb+PrzjfgXX7UKgHxFezHV/1ZlnO2b08JobpfgTIVb2y2S5zVUKjhkWamDFAQS2oLSipETdLM45twldOKU1gciXIWrFRp5r7JIQTfWW8JJcywjGzt0mPm2Kcj+eoZEXHu7GW/d6e1DUaj4WPVzybZWDELR5DB/yoZmtVUuITF5Wlek6SrA4/9Yq2VzvABLqamHIrbjOuZV2MH8O+1v14+SrKZsklVMa9B4
 lAvT9GGr
 MZwzJt4LkwvpXw5+GlnFV+kiCgC47WFuGkaS3uFAydaVJXfWlcQmRUpSk9bsDJIOBktPo4hmWB27tSz9Skxq/y/eiNEzLl2S3nm9e0f/PpOT1BYhCer6ZpmUAcPsVXcRPgDIc9IcZ4kWaOK5Iy1H1wUEoG+WqEnlag0a4tmL1P/g7W/nhHr63pTk68wmD/WIKd9xR6vUhD19F01vBDibGxqgZVsIFoj9omhLY+hSviMavoQRmZb9qRkgbjNIwDrOhz2IlwdL3Y4jOyS+c52OIrv9Qoe1xGI8/M9LoeFOz3wt3+hLRC6LtePIySQ==
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


