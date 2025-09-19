Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FCCECAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:06:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C910F8E000F; Fri, 19 Sep 2025 09:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40038E0001; Fri, 19 Sep 2025 09:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B07E58E000F; Fri, 19 Sep 2025 09:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 994908E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:06:53 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5E1BA11AB37
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:53 +0000 (UTC)
X-FDA: 83906024706.15.6CC7FB4
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 530212001B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DFKXGt+F;
	spf=pass (imf13.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wqd2OsumqXvM1qmIAqFhFCxL6bjWOH+kistJRYcEtxM=;
	b=Jbif2XlK0qrECdZL2wXqmeJOyMn3mIKgS2eg28ZYCMtyE/G59Lhr7AlDf5NVoiEnDYEnir
	w9vk+BMTQEYCWIVsVRPi+qGza42n3E2v/1EyAKg/603QilFXMhy+02ifwLl8+SPjZAO99A
	EDM3fyuEMNSNpD6POsaNg3BmOO7zCYI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DFKXGt+F;
	spf=pass (imf13.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.215.181 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287211; a=rsa-sha256;
	cv=none;
	b=pYCIVz6FpGzPbF4IsUks+A0r3GlOFCIIhML6lPBCnUBzj1g62/+OWq+0RNVr3NIf/cU+IO
	BNmqwqquNfNjRD0Hn8WGRzfx+x50zjuAROgS4rhe6dBJELQvAeg9bvX0/1zQw5k+a+bi0/
	yWr6uhCfxpb/9Sz4YLd6kC5vN56Sot8=
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-b552590d8cdso349057a12.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758287210; x=1758892010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wqd2OsumqXvM1qmIAqFhFCxL6bjWOH+kistJRYcEtxM=;
        b=DFKXGt+FS05fK/FlaB/3eBPtd2ElqSoWMN8ZBzhzwVCaZSQiwkB5XYgxZj4j1NdqKJ
         i+CAoHfUb0Bw+0vOnH6CSW6jn4lyBHU9ONuaT+c+tMYoSIU7RugglOYkKMNyDtrR+q/4
         dUV0SJ97Bwy0OEpZbg8inp1vNz0FdDSCqlAs4jjXKNpjDh5DXxy6+r2dVse3Vie2wU1P
         wD9zczOQilwQs5edApcJoBzi+RMqhHDEEqg19bSOF0b4+Th8XDLqOFFR+pYsE4Xhr7ba
         6lGsAwa4fTB2GszbGhdcZR4O6ofcUiZ1oH4thc3UFN+uOqwzgQ/qu34i2396b5Mj4FXk
         EuaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287210; x=1758892010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wqd2OsumqXvM1qmIAqFhFCxL6bjWOH+kistJRYcEtxM=;
        b=bgkd89CaDMkxC92tQEEbz2c14kMDlqByOfQYSTkM81ENqiWK6r2zJBqxTx5YUDgbXl
         kw1kVeb2151c7mK2KW2M0Sm/FRn160ZZxUNLWzwx17fYSD2UvENze9CNlYMQbfPmLpqd
         fLnpMXxD8i16iwN7U7VR+B080dG5mJtBEEGDZAPRExQZKsqYfsKtKQ06gBc9HuoMKw01
         dctPoiqU+MRH+KIZjcJxcKvxbiCNmzookL3L8gE2AiEP+8VK9KuwvSLL9PBrZ4XQ92R0
         +9FQH4NX3BDCmicx9RykjrFvYLEvG7tficyB/F757Tw2iXoiXAV56b0H1xMa0dl7ldFu
         lm9g==
X-Forwarded-Encrypted: i=1; AJvYcCWIuFOG+lt0AISfaGOxFHV7iD6Gk8tnaMzVqwjMQgfsYn9RcLArCqVdi8ZxN6ZPjjTzS36pEVKbWA==@kvack.org
X-Gm-Message-State: AOJu0YzyUIej74RW87kQWgFCnUhKyBNLvJeFg5bLdR1GAK79F3l+JYsN
	p7hnNBrFKRsVETcrZAOXC1Def1Tl3WU5MyKaym7IxJHv+9T7s/3iVKhjqF01wqkPEFY=
X-Gm-Gg: ASbGnctVZZM03NycZXnYKx4f+tzLDOX/qNY0GKks7snyvctfdElHZAuz2QfZjoI1Gkw
	t0XMm1OL0Ta4LgOwK8IFyw1bhG5T8Fk/uFgcKM/5gAiSWQJyNrYz1F5a2UMyqxERAL6A7clQl3M
	xsRE18Vknd5JUH2SwN5XOfld9EN20i6rbVkjcFafytL5UEAxgEBV5xVrrYAe2P/Y+2QYqwYJQUY
	xTUcn8ewYNX1claxczeU4QPBydB6kjR50DkWHZsyZcnFdFiZdkAix3UFiMOuby1LhWgEPt+ZyxU
	IWqIUR+J25DORzKR4+ncO2EE08w8wpifKYcgWg7UCBXwjCKwv3i+vvFD3sBtD8L7/8we9oN1wXv
	vCzkAGY/A7ZzalFQv1SazIf59pzV34cmj9cFUYQtePXfiiy2LYspk8dQuDA==
X-Google-Smtp-Source: AGHT+IGsQX4qqfvNoPwWJFUjplN/lur0/YcnCiwcw0BLRN5WPXUAW75RvKgSRYlc7901m8WomTeIKw==
X-Received: by 2002:a17:902:e946:b0:24b:4a9a:703a with SMTP id d9443c01a7336-269ba42b2a8mr46562425ad.17.1758287210016;
        Fri, 19 Sep 2025 06:06:50 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000::d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802e00b3sm54732065ad.90.2025.09.19.06.06.46
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 06:06:49 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	libo.gcs85@bytedance.com,
	Yongting Lin <linyongting@bytedance.com>
Subject: [PATCH V2 6/8] mshare: selftests: Add some helper functions for configuring and retrieving cgroup
Date: Fri, 19 Sep 2025 21:06:18 +0800
Message-Id: <20250919130620.56518-6-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250919130620.56518-1-linyongting@bytedance.com>
References: <20250919130620.56518-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 530212001B
X-Stat-Signature: me6gyacu9mxpzrsfmr65yayc8jiehg1s
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758287211-190714
X-HE-Meta: U2FsdGVkX19OZqnM2xjXjgJr2gSdbaH7duYk71Uwpu9GbLjdGgyiU8QvWKGi3cGIR4Ow+cyTl+ZQrf/XDBvWv3ZiVBuboO7MhFVMUQ8pSX3VpiPFM3nLzkq/BuKEoCcODCITOrSicotHxrbqvZqbJ+TfcIGct0Ifz59PoYPtAlYG5iaZWrQZ9Yt0A1SbIDAcmVbrgV4KJRmHGEUXZijhSLV9O57+NuKzkrwOdzQK1/6W6Rkl4rRiI9+P83toCl298ks5ZlK6XgcQJ3b/prH3ZfR+DDkCponHqKEMY+6o8pGWanEYA4VfFE1RdvYz9HL/NpjHWVG8wBl51VssnPQfbhcBCZ4+AdXvds1xtul47/S9TWRdsCIs/iWGvFkP0kByJsa/EFvN6+bz9XYguQcLp65iE9DDlxEEm17bjnrcZc6/CK67hY/uoOdfduLiqiCsLwnkU0V7vomUTUqERd/dXzTkFJMLxGrYI8JIyeNFHw7xcIo1q+FWpoeHRT2piK+4CPxjaylJBo5Fbe5hTyEiUjEI8UutHV3egFknJ+LCXBcyDLxyP9o/HI1PXoq6swqc9cr+pQECzGoa+Rvzo4+3eS7XYRsV/fmSGdwcZPSU8BJvrQYDpF2k7IFzuvlCpUMwEcGHGZrXjAZd5QVw7hhrPIjd56sPMLp6sxI6hOcgNnrEG07h1HvhlOSq0zKpLy/UFnuhx6sICJGhImsLEAF70FA7exXwTdnyWSPdJMET8UFsefVjCaUN0WSjVSD9XbOVgV6NkJDYB7R4pYvUjIHqiaObXB0m2jIDc5diDXyIJ2BCY2cnMoMf3xCENsO2nDhGSV/Fh9FGjuau1RG+3UaFdAYFriMFMSNjg/2Vqo9+IfWJbtv0GuSJzvlKZvFRZfs6h36fDeWaogZjvFOfCIjVV2O15XEVPbKtCvdSEa66R1DARo0mIBCaepv/4R4jmJOlo5h6Vm5Tv1siuqkKTPM
 yadU9RHY
 x37w1PPPksO5/o8ZlDvwRT93PNdygDyMaaWKdd8mGeLgkhB2/xdiIOyDWAHyCZNXPahPnhpjtBRS88K22zf6FYMQiIhlfC4Kf3P+uFXxPXyptN42LzCG73nicork/I5rq2RKKQh+1zRL4p58yg4EPydDjXSKLx0S2flFuNNnzS5ndbldUky3MeHJNTKNdSyhlaVro5aFax5/IfNWa9cDfYlynXqjPw0vxWZ6vn9mlT6q+0+X31lzqd/vgWLTWmVrmY5tm1ryYBB8GMaGX0v/eDhjzEG4OQ+Rua3LAffS4LqUJcm9oIrUzjH2UtuyESoLMRbD0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before verify some complicated memory functionalities such as swap memory
and THP, we need add some helper functions to configure and retrieve cgroups
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
index a3c3896bd507..f1db4eb3cd8f 100644
--- a/tools/testing/selftests/mshare/util.c
+++ b/tools/testing/selftests/mshare/util.c
@@ -124,3 +124,131 @@ int mshare_ioctl_munmap(int fd, size_t size)
 
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


