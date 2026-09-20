Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D1DC982DA
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 19:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155196B00BB; Sun, 20 Sep 2026 15:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12D056B00BC; Sun, 20 Sep 2026 15:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BC56B00BD; Sun, 20 Sep 2026 15:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BECF36B00BB
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 15:39:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 40BD4A04CC
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:39:01 +0000 (UTC)
X-FDA: 85235153682.27.51399A7
Received: from mail-yx2-f13.google.com (mail-yx2-f13.google.com [74.125.224.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 736E71C0008
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 19:38:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g4p8vjFc;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789933139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYr/9NMKeUZAYHni34Sv6tdHvQS74uTyy8Pha66A4FI=;
	b=FS8NVnZ7gak0JmY45NpgG6cZAfYWOreVK3Exl0xniMIWQV6ESDlwZnAjaDFuASTzIIQviN
	w5X5rA1LreFEh0UGNYM4mROvvedg+v46iG/+2gBoRlpqCY4fpBId8NXzLZt8JaQH+Qp8pZ
	53KR2YOPwsMW757G+IuK9rRbbg8WtJQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789933139;
	b=gzPIkgBm9ZFc5aSzkTRx+DSfI4N+fo2+tnEO8DC7mxaMf1uulQe/GChI3LBIew9P4qkJUC
	tlXuFWRaeozVCJ7D7WZs++qbfqK//aWlFRpK0U0JfvV39U/IPECPWf/tX8Gprp/brnP4y8
	hcfWoIW983MuH4A0Pa5wa5QegGpwylM=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=g4p8vjFc;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.141 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx2-f13.google.com with SMTP id 00721157ae682-85e68bdbcc1so14817397b3.2
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 12:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1789933138; x=1790537938; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=pYr/9NMKeUZAYHni34Sv6tdHvQS74uTyy8Pha66A4FI=;
        b=g4p8vjFctXJjQ4zg4xjAz1LqiIpfUyhDXrcOXkC4ietFlzhwRLN4bRD2i1QhwNm7vQ
         7lQVZG0nLSKAw8pq47dgaQWtdV2Q3nrFfR/eynm/hWPHW1tMrOUKBeysh5ZYxzrV618m
         xxYjSBxPHxbxuECWBMDzuTOngcEyCqz4GlSjKrZ+5RmV9O1Ezl04Ko2AW61rk/+nCGkB
         Ss9av/0CxOz6ADLBh+XhaJaOifuqSculOkIYLzDUzPR7bZTsOOPKbUGq00ZWLi4H8sah
         +lwUivePE8NrvDurAXBK7Xmi+NR3FqVo5oKskYWe/NGuV9wo1c0+NAq+q56FapgePo6v
         JWqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789933138; x=1790537938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=pYr/9NMKeUZAYHni34Sv6tdHvQS74uTyy8Pha66A4FI=;
        b=JphFt3dFLkP7+u3Fx6FJydWXJebXx2JdWBBxjVt82rhIIEFWXD5B2eKCo0el2esxt8
         LbpqzFZjtKrkWRyK7PwJyLJ6o4+rKqJtUX69CHa5PaMRVQFNKL7xfvy0a3itjYeoignQ
         /yzzBadoqWwH4hI3dEfUhIMDox+wbI59NnjPt/qxAOCfKB/nIGettG/GhOoy9P+5zGZs
         /iXSpYWbVSF99iauy8XTm4aAOIlkan4pOTz+/7G9MENxrWlJuyplNn5P+5ab92FUlNRS
         b1sQ4mzNUYXVgLM79i6dwECMYeQRBS1Meyk9k8vcMNfUbpUlnGgsC4FWrAgSJxcxzLoI
         BSrg==
X-Forwarded-Encrypted: i=1; AKwUvBx2MGT9dn8VoisJn+/aw0MyKfP9CIf8o8iXQA9vXy082nVaD/EGrs1CxJOYOcePbXP/Oc2StEl4qg==@kvack.org
X-Gm-Message-State: AFuF++m72QOQu0ganp8G1NdMlDguEU2Pas7Iveb9bN5+4CvNWWJer2+g
	x3TsZdLCOe6SHcVeP2GLCuv8a01rNy1salz7cBaNLaVnYjzSo8hyUVsZloqpdFApkNc=
X-Gm-Gg: AYBFou2kMdRv39sHPCjyS5AYoW0deE8jctGSENuzlkkgKgykAqb5SGP8XmF/f1T5xrO
	NKyRHzUoBzzLDXF2NOi6EVkvC6LPUjGWYFgWvRSiypGv2KGaG/BQM15Kb/QQrNVx4vnHXerCOkJ
	z91kULh+0NRFhtd6GvVYlIB7ndjF1HpIyqzcj1elDjp92Gl4KxApWSpT4gjcl6rYhcuF6k9zrac
	tlRSjJcTDdw2B3oBz84DsR6xehIIF8MgDiWKWpn4vqI6EKXP1/Y5MXy0e425LiR4/aonL/9jz7J
	xG/FC1fv4N1cLEm9BcmCnuwI4Rb1ZJsf8P+G3RfwLzbhgFDtVNZ5BhE9yMOJ1FKwF4okQI48JVB
	oE/Epe3gvJO5fi/6YbJ/4B+FJjxnDHUmSc/QekYSIMFqGa7uXPNsdbR22qbD2gKa1/10MtcwCpM
	1ijN20hR5lqlIyfe2EbVBDW5+dZ4WZfIzKUxRlLgp96paOw7F9P74MlSASJnB13lZFuCcizfkAw
	2pTThDAYC/0dlBbJQAJ+C1PFNqNa5Bq2uF1ijh3oy10EDmWV8aSmCGYxqBNf6fMy+B215oSJ8AM
	5CvGQiLlZMKapDjLk/4=
X-Received: by 2002:a05:690c:e196:20b0:89a:63da:cbe9 with SMTP id 00721157ae682-89a63daccb1mr15163787b3.47.1789933138554;
        Sun, 20 Sep 2026 12:38:58 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-89a482d3648sm18568067b3.39.2026.09.20.12.38.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 12:38:58 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	legion@kernel.org,
	kees@kernel.org,
	will@kernel.org,
	ruanjinjie@huawei.com,
	atomlin@atomlin.com,
	rppt@kernel.org,
	jani.nikula@intel.com,
	hamzamahfooz@linux.microsoft.com,
	joey.gouly@arm.com,
	tglx@kernel.org,
	nsc@kernel.org,
	alexandre.chartre@oracle.com,
	james.morse@arm.com,
	dianders@chromium.org,
	bp@alien8.de,
	jpoimboe@kernel.org,
	shuah@kernel.org,
	catalin.marinas@arm.com,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvmarm@lists.linux.dev,
	jaredwhite@microsoft.com,
	johan@kernel.org,
	pbonzini@redhat.com,
	mingo@redhat.com,
	linux-mm@kvack.org,
	seanjc@google.com,
	mark.rutland@arm.com,
	vdonnefort@google.com,
	tarunsahu@google.com,
	gshan@redhat.com,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	xur@google.com,
	djbw@kernel.org,
	oupton@kernel.org,
	nogikh@google.com,
	sumitg@nvidia.com,
	linux-kernel@vger.kernel.org,
	zengheng4@huawei.com,
	peterz@infradead.org,
	corbet@lwn.net,
	suzuki.poulose@arm.com,
	luto@kernel.org,
	hpa@zytor.com,
	zhangpengjie2@huawei.com,
	x86@kernel.org,
	yuzenghui@huawei.com,
	jic23@kernel.org,
	ardb@kernel.org,
	pasha.tatashin@soleen.com,
	petr.pavlu@suse.com,
	ryan.roberts@arm.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rdunlap@infradead.org,
	kvm@vger.kernel.org,
	fuad.tabba@linux.dev,
	maz@kernel.org,
	mbenes@suse.cz,
	jgross@suse.com,
	seiden@linux.ibm.com,
	pierre.gondois@arm.com,
	song@kernel.org,
	nathan@kernel.org,
	pmladek@suse.com,
	graf@amazon.com,
	chao.gao@intel.com,
	zhenglifeng1@huawei.com,
	arnd@arndb.de,
	sidnayyar@google.com,
	linux-arm-kernel@lists.infradead.org,
	vladimir.murzin@arm.com,
	kas@kernel.org
Subject: [RFC PATCH 21/46] selftests: liveupdate: Add physical CPU preservation unit tests
Date: Sun, 20 Sep 2026 15:36:25 -0400
Message-ID: <20260920193650.3373435-22-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
In-Reply-To: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
References: <20260920193650.3373435-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 736E71C0008
X-Stat-Signature: z33s6jjg8rsbrj1z3h53qmk611p8oem8
X-Rspam-User: 
X-HE-Tag: 1789933139-11425
X-HE-Meta: U2FsdGVkX1+WwAItLGBw2bR7VKNKq1Bsds7H7MfByhk0WgjzFd2zQlw31gTsxrAJNUaF8/d12RGih+r1B9Dw6mDcltUgfj5X8W79C1SRSwIK8XTnM0P43Sl16eEadpFsReLWBSU0NjplPWeWQdCi3rTOHn7FWp6uD+mPTWj8SiSAOq96P5q377IHydWG8mgzQCjvjaRkabAwMLeS87KJqmwmY8inQzo6pVXFiLykD295rp19NuKwXKTIr3fqzhT1P16WbRVkvvCE57854y6b/NkZ3oMRT3Ya5CfqgLUdilAJz0aVL5hgjCULYndjuDf1WfeCexgtjfbkYelVKkwO3MfSfkalnnIOX1u+kbTnGvwCFbPeTdH9aR4eB9n7RNsHLFd4zdz7D/X6o1ViOJRDN4iqVD7fms2juBYR0OYppQpW5UNWaMqNq8xqpR9g+pssWbZYNXdalFdJHmJXGHD//MHDNae5TYwrPJb9XtGBaon6hBIqtPUzKG4riRop62zueCiUH7zkj4HsRr2tdYxu/LjbjslU36TO82s3D0Ezfpf0gpixmYelWnvrKyG8RkTprHgeDNawqcdhp/o3AUzQUxbn+JGienwmrmomiDRIvuC6dhfEy/WGNDzlIv5sjrOG/Lj9sS/EseAXLd2nZyJppszYpNt2+cCkTsAE2dhfOEWLLmAKhFD8F2qPDaY70N1Ze6zOMhTpdNx37IRmgWOOwBUpEUtSHyxyxfNroLhCKiWsR3D3i+3QDuOe+XdVASynFj8B7riDuiLWWNLb7o64Dj8f1VwTVkXtIvPbXHM3NS3+aggx/qR7HWsWEyMpE0xJ440a23Q5feiv/iVG4rTwxsAB+fq8Ovn09f6Hjad970GVgveXWAKxRsc+YtffTbR5v/niOiYiOvyOfU/MLn9Z28JAhuzoC0tBMbWZXN4hw5bAPFYKQIWGNhtvrEs0Eis/ASBgq5+RbkQembd0uJL
 0HIAU8lb
 WY80PlgbJkL0iEnXJWHVHTPZLhX/DTPLxvg6SJ61TJq22GQ+BOMqD7ijAtgAgzsfHgxxgPLQ6sABmlBJ4kM0E4nxbtxWKcuRBVr12IDgO9f4QUAGNG90udo5I3XSohIIn1tkahZfSPlibThbcnEbrk8816kikOSc7TvMohgvYhC7Olm2GuqtSDXGiVFBRsCnP2t6w+DihtK86k+97gx+S5r4FH6AxhosKWYwtDY6UcD/I3fPlrdQI2WaW1yLYI7kIllu7gex29qwiUnpQOaofNo5+lBi4KZq+E2sfvpC0++vzeDNBHN0yiKZQjtzW0PWaXPa1NnPTYxm0hnI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add unit tests exercising CPU preservation sysfs interface:
- Verify /sys/devices/system/cpu/cpu<N>/preserve operations.
- Test CPU offline and preserve sequencing.
- Verify status reporting and error handling.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 tools/testing/selftests/liveupdate/config     |   6 +
 .../testing/selftests/liveupdate/liveupdate.c | 251 ++++++++++++++++++
 2 files changed, 257 insertions(+)

diff --git a/tools/testing/selftests/liveupdate/config b/tools/testing/selftests/liveupdate/config
index 016d009dba13..9458b9c70eeb 100644
--- a/tools/testing/selftests/liveupdate/config
+++ b/tools/testing/selftests/liveupdate/config
@@ -5,8 +5,14 @@ CONFIG_KEXEC_HANDOVER=y
 CONFIG_KEXEC_HANDOVER_ENABLE_DEFAULT=y
 CONFIG_KEXEC_HANDOVER_DEBUGFS=y
 CONFIG_KEXEC_HANDOVER_DEBUG=y
+CONFIG_SMP=y
+CONFIG_HOTPLUG_CPU=y
 CONFIG_LIVEUPDATE=y
 CONFIG_LIVEUPDATE_TEST=y
+CONFIG_LIVEUPDATE_CPU=y
+CONFIG_ACPI=y
+CONFIG_ACPI_PROCESSOR=y
+CONFIG_ACPI_HOTPLUG_CPU=y
 CONFIG_MEMFD_CREATE=y
 CONFIG_TMPFS=y
 CONFIG_SHMEM=y
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 2dedd5fc2534..b3c9cd7ea653 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -530,4 +530,255 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+static int find_hotplug_cpu(void)
+{
+	char path[128];
+	int cpu;
+
+	for (cpu = 1; cpu < 256; cpu++) {
+		snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/preserve", cpu);
+		if (access(path, R_OK) == 0) {
+			snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/online", cpu);
+			if (access(path, R_OK) == 0)
+				return cpu;
+		}
+	}
+	return -1;
+}
+
+static int read_cpu_online(int cpu)
+{
+	char path[128], buf[16];
+	int fd, val;
+
+	snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/online", cpu);
+	fd = open(path, O_RDONLY);
+	if (fd < 0)
+		return -1;
+	memset(buf, 0, sizeof(buf));
+	if (read(fd, buf, sizeof(buf) - 1) <= 0) {
+		close(fd);
+		return -1;
+	}
+	close(fd);
+	val = atoi(buf);
+	return val;
+}
+
+static int write_cpu_online(int cpu, int val)
+{
+	char path[128], buf[16];
+	int fd, ret;
+
+	snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/online", cpu);
+	fd = open(path, O_WRONLY);
+	if (fd < 0)
+		return -errno;
+	snprintf(buf, sizeof(buf), "%d\n", val);
+	ret = write(fd, buf, strlen(buf));
+	if (ret < 0) {
+		ret = -errno;
+		close(fd);
+		return ret;
+	}
+	close(fd);
+	return 0;
+}
+
+/*
+ * Test Case: CPU Preservation Basic
+ *
+ * Verifies that a CPU preserve sysfs file descriptor can be preserved in a
+ * LUO session, offlining the CPU from scheduler and returning it online upon
+ * session teardown.
+ */
+TEST_F(liveupdate_device, cpu_preserve_basic)
+{
+	char path[128];
+	int target_cpu;
+	int session_fd, cpu_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	target_cpu = find_hotplug_cpu();
+	if (target_cpu < 0)
+		SKIP(return, "No hotpluggable CPU with preserve attribute found");
+
+	snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/preserve", target_cpu);
+	cpu_fd = open(path, O_RDONLY);
+	ASSERT_GE(cpu_fd, 0);
+
+	session_fd = luo_create_session(self->fd1, "cpu-preserve-test");
+	ASSERT_GE(session_fd, 0);
+
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, cpu_fd, 0x42), 0);
+	close(cpu_fd);
+
+	/* Verify target CPU is now offline */
+	ASSERT_EQ(read_cpu_online(target_cpu), 0);
+
+	/* Closing session unpreserves and brings CPU back online */
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(read_cpu_online(target_cpu), 1);
+}
+
+/*
+ * Test Case: CPU Preservation Sysfs Online/Offline Rejection
+ *
+ * Verifies that while a CPU is preserved, attempting to bring it online
+ * via sysfs fails with -EBUSY. After session closure, normal online/offline
+ * hotplug operations succeed.
+ */
+TEST_F(liveupdate_device, cpu_preserve_sysfs_online_offline)
+{
+	char path[128];
+	int target_cpu;
+	int session_fd, cpu_fd;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	target_cpu = find_hotplug_cpu();
+	if (target_cpu < 0)
+		SKIP(return, "No hotpluggable CPU with preserve attribute found");
+
+	snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/preserve", target_cpu);
+	cpu_fd = open(path, O_RDONLY);
+	ASSERT_GE(cpu_fd, 0);
+
+	session_fd = luo_create_session(self->fd1, "cpu-preserve-sysfs");
+	ASSERT_GE(session_fd, 0);
+
+	ASSERT_EQ(luo_session_preserve_fd(session_fd, cpu_fd, 0x100), 0);
+	close(cpu_fd);
+
+	/* Target CPU is offline while preserved */
+	ASSERT_EQ(read_cpu_online(target_cpu), 0);
+
+	/* Attempting to bring the preserved CPU online via sysfs must fail with EBUSY */
+	EXPECT_EQ(write_cpu_online(target_cpu, 1), -EBUSY);
+	ASSERT_EQ(read_cpu_online(target_cpu), 0);
+
+	/* Writing 0 to online (offline) should succeed since it is already offline */
+	EXPECT_EQ(write_cpu_online(target_cpu, 0), 0);
+
+	/* Close session -> unpreserve and restore online */
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(read_cpu_online(target_cpu), 1);
+
+	/* Verify normal offline and online now succeed */
+	ASSERT_EQ(write_cpu_online(target_cpu, 0), 0);
+	ASSERT_EQ(read_cpu_online(target_cpu), 0);
+	ASSERT_EQ(write_cpu_online(target_cpu, 1), 0);
+	ASSERT_EQ(read_cpu_online(target_cpu), 1);
+}
+
+/*
+ * Test Case: Prevent Double CPU Preservation
+ *
+ * Verifies that a CPU cannot be preserved twice across the same or different
+ * sessions simultaneously.
+ */
+TEST_F(liveupdate_device, cpu_preserve_prevent_double)
+{
+	char path[128];
+	int target_cpu;
+	int session_fd1, session_fd2, cpu_fd1, cpu_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	target_cpu = find_hotplug_cpu();
+	if (target_cpu < 0)
+		SKIP(return, "No hotpluggable CPU with preserve attribute found");
+
+	session_fd1 = luo_create_session(self->fd1, "cpu-double-1");
+	ASSERT_GE(session_fd1, 0);
+	session_fd2 = luo_create_session(self->fd1, "cpu-double-2");
+	ASSERT_GE(session_fd2, 0);
+
+	snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/preserve", target_cpu);
+	cpu_fd1 = open(path, O_RDONLY);
+	ASSERT_GE(cpu_fd1, 0);
+
+	ASSERT_EQ(luo_session_preserve_fd(session_fd1, cpu_fd1, 0x10), 0);
+	close(cpu_fd1);
+
+	/* Attempting to preserve the same CPU in session2 must fail with -EBUSY */
+	cpu_fd2 = open(path, O_RDONLY);
+	ASSERT_GE(cpu_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd2, cpu_fd2, 0x20), -EBUSY);
+	close(cpu_fd2);
+
+	/* Attempting to preserve again in session1 must also fail with -EBUSY */
+	cpu_fd2 = open(path, O_RDONLY);
+	ASSERT_GE(cpu_fd2, 0);
+	EXPECT_EQ(luo_session_preserve_fd(session_fd1, cpu_fd2, 0x30), -EBUSY);
+	close(cpu_fd2);
+
+	ASSERT_EQ(close(session_fd1), 0);
+	ASSERT_EQ(close(session_fd2), 0);
+	ASSERT_EQ(read_cpu_online(target_cpu), 1);
+}
+
+/*
+ * Test Case: Multiple Preserved CPUs
+ *
+ * Verifies preserving multiple distinct CPUs simultaneously in the same session.
+ */
+TEST_F(liveupdate_device, cpu_preserve_multiple_cpus)
+{
+	char path[128];
+	int target_cpus[8];
+	int num_targets = 0;
+	int session_fd, cpu_fd, cpu, i;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	for (cpu = 1; cpu < 256 && num_targets < 8; cpu++) {
+		snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/preserve", cpu);
+		if (access(path, R_OK) == 0) {
+			snprintf(path, sizeof(path), "/sys/devices/system/cpu/cpu%d/online", cpu);
+			if (access(path, R_OK) == 0)
+				target_cpus[num_targets++] = cpu;
+		}
+	}
+
+	if (num_targets < 2)
+		SKIP(return, "Need at least 2 hotpluggable CPUs for multiple CPU preserve test");
+
+	session_fd = luo_create_session(self->fd1, "multi-cpu-preserve");
+	ASSERT_GE(session_fd, 0);
+
+	for (i = 0; i < num_targets; i++) {
+		snprintf(path, sizeof(path),
+			 "/sys/devices/system/cpu/cpu%d/preserve", target_cpus[i]);
+		cpu_fd = open(path, O_RDONLY);
+		ASSERT_GE(cpu_fd, 0);
+		ASSERT_EQ(luo_session_preserve_fd(session_fd, cpu_fd, 0x1000 + i), 0);
+		close(cpu_fd);
+	}
+
+	/* Verify all targets are offline and reject sysfs online */
+	for (i = 0; i < num_targets; i++) {
+		ASSERT_EQ(read_cpu_online(target_cpus[i]), 0);
+		EXPECT_EQ(write_cpu_online(target_cpus[i], 1), -EBUSY);
+	}
+
+	/* Close session and verify all targets return online */
+	ASSERT_EQ(close(session_fd), 0);
+	for (i = 0; i < num_targets; i++)
+		ASSERT_EQ(read_cpu_online(target_cpus[i]), 1);
+}
+
 TEST_HARNESS_MAIN
-- 
2.55.0.1082.g2b9226bbc0-goog


