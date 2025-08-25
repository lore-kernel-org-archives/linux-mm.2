Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30474CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769158E003A; Mon, 25 Aug 2025 10:58:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719448E0038; Mon, 25 Aug 2025 10:58:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608C68E003A; Mon, 25 Aug 2025 10:58:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C5388E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14F9D1A0467
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:15 +0000 (UTC)
X-FDA: 83815585350.08.6242C12
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2A6CC2000B
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W6WKlvTn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133893; a=rsa-sha256;
	cv=none;
	b=LAcz1P2LM9EI0ti7XvStwOfYz2p2L89y1l+n+19aEVYYadz2gkLob5bZP+4kSZlAjGRmmu
	eNPx1d9QlqqEBKll0HtJc/5owQx+hxziapJfzeMGd+g74HnkDl++W43XF7LdJYWOj7NGdA
	6FnE33P8VL98N0sOzE9RWNlWohLHdNI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=W6WKlvTn;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf13.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPfCdUbCeDFsUsPpoXasJyGte3SUGn6gCviPu/g9Nmk=;
	b=TO2seI1ySJ9H8/yxAxVAszsi7O6XuOYYtrYRps1yD6SuNSJCkA8lAOBYIyjR2XQCEHm8X9
	dyxT2QUJ/fwPaN7QYlvMvMZw2W+24X/d5lUX4TGYAdlXv3D8ZNSm+1wnuL5iZlbuDcfi0y
	uUDbYZoHU+tYeHp8G4L1QnPGXQBI9Ko=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-770530175b2so1157997b3a.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133892; x=1756738692; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jPfCdUbCeDFsUsPpoXasJyGte3SUGn6gCviPu/g9Nmk=;
        b=W6WKlvTn06R+41M9YEETO4g+9hFhL0X4Xn7SqwNRlpzwcTkTxAdfQRMM+ruq+CrX/i
         1zf4dQx0dl06itoj9wBWofURXAO++KC9bqFpU/4yZnsSKXjT7/BJMW0VCfB8CjGJoy5F
         0rfl1UcJM48/xWnS8S91miuMDvAYpYHaaNphbmCGCkHG5yfpNZM0KqnmgE0kWoSSRTFQ
         Au5LuVK/Y3i6zGyGk4/p4iBpRFadxk8SByTG/AQpYmjOst09NYHPvvGsBxw2V7iHfIB1
         636mwxap9EI5xaFDCSnBT1mc1hmhXllF8jrR1gtQa/HRFTqsOtCHGUOMEC1GLKX7+fMG
         IMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133892; x=1756738692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jPfCdUbCeDFsUsPpoXasJyGte3SUGn6gCviPu/g9Nmk=;
        b=aFN2D1m1BDZJH6bfBvse3WH8WP9sGle75sKvyuRx4sK8Mc8nv928lYl2XBdyj7zalg
         3SiGYqRD361wdPwNl83DFQOh32nBz+RKBCvsHi4zMV1ylYyjXErL5F2RPzFBDDu9YgZF
         W74EAIp4Xae7Un+gkEcM2Rt9k52SuCddHKRhjk4h+gJH4rEEHF94ugIp9P/ng8xikhKO
         pzPg6To8dfFFO11a+1uk7zsEmvQG8s2SrOyJ8TjbqR7UA1qgcWUWiSvWsNp5H9vjkS/J
         Hcd3aZtUW0MnIOkVQuwdZHpAWVaIxa58ca6FacCt9wau7odEflxBBUCxhJ+evlShZ0yb
         kh4g==
X-Forwarded-Encrypted: i=1; AJvYcCUN9SOWQdwJv9sgQNjwOl1R9KO/+SR5cT5KS4/HPJle5NPOHw3puhGNcN/3QMgNvw4hYdZbFtF6OA==@kvack.org
X-Gm-Message-State: AOJu0YwWaDt2CI4L0+y1HrycwTIl6oxijSJj477K2fO/bfiHFHpo2D3d
	G0x7x2mFfUdCPznORx9Ok5jP8EHfhRfltRSnVX2/OL/2DcxhswUnbBh16wGgza0ZCiE=
X-Gm-Gg: ASbGncvvCvgZD7KL6Y8KZLyVn9gOWav5qA5ecVUmglF9jtBPjVrwV4ga0A1/ScTPGzR
	dYpPR+fFYf0OWuS4U0HcLwj/WCbiVApx52YDnyYwR5qwABMVOnuYrsl8dKf8OCd1ymjAxF/qVS5
	sSPn79Sgg37I9j92KtyI/b1I97Cg+/JW7eWC6xr3iIpCbJaeNbMN8eDFINzMW0iI3Pye2aKkOl+
	iTy0aQ7vTLZQNEmoZpHRysUVFSjKtckSy02B7hr/Q0Yivh0JL58aZuHtIrwOBK71EYcdpE6c0rh
	qKc9LrvcB3GxgEsqU2fUGnw3fmp3gRC6sD8w/WZQhDozSmMHKy3XVvcgvXaeoVUqPAfTzzNwPo7
	egjcXpueYnYJH2/67trErL+FrlCQRkfLjP5p11vuiRQjfGLSRM0jmN2K9elmVB/I1RbT/Okc=
X-Google-Smtp-Source: AGHT+IGf78VLrhzAmAq66Bf02kLMtH0Tbf7x+AP9+PSfFDcxdQBxs5I/UoUt+CpNFiVAJcIVaIt3dg==
X-Received: by 2002:a05:6a00:13aa:b0:771:edda:1b9c with SMTP id d2e1a72fcca58-771edda1de7mr1932159b3a.14.1756133891940;
        Mon, 25 Aug 2025 07:58:11 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.58.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:58:11 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 3/8] mshare: selftests: Add some helper function for mshare filesystem
Date: Mon, 25 Aug 2025 22:57:14 +0800
Message-Id: <20250825145719.29455-12-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2A6CC2000B
X-Stat-Signature: sj8mj4583cik5egn7qdmruh3idum6wze
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756133892-649531
X-HE-Meta: U2FsdGVkX1/l2z7bjmIo98ec1uMCieWs2/PrheXZyUvYo0adVX0guPB+zCUZYm81geK8Ee2FYzBzyzUgYS4vTxyJzJIWRUfSMRDceXbLaKEz9LuHSkg5JXYkSgn9tkF93JYWctSaqwVgIEm6cvNsr87HbthRGr6yCK8Mpo6qFlSeVZkCQQKgMZ1HwA3Wi1nZ390xYfqHVC5hp6xuabgGKUb1AILq0GJnVEvJFGv2u5gUaAUg2QxGd5mnoCJoJ+7OcpHdXkvVrCu3MLr6cg2gvIHh7/kJMo2Q1WMiOXnHgUXdh8d3j5u/ndXSaRc+t+5m8U/Zvtg4thATyxkQWR2oLEuhw0+fn7c8FowQNWRRL7TLw4mmngM5K1LI2YSlfQ9Hx4jU0XncwmhSl7GJoXqUsLO4z1Td3EgQlO102CZ/vCYXC5Y5yPY2/SiqKj7bGVt8z6sXCCBlWCBrCgcQMrxmLwOKoVFtRs2P8NZapf1ZSNVqmr0DjpEpzID+Laeoqe0Z1QdHzymZQzWqlayiTD4YIIx/J4AKT7cZynTcIshqac2voFk0KVcsrjTrqbrL4zCSt4AP8EJgPt6U137mZ15o6AwiChcOlJInlB9UBsQi+ChdzYIEU3+D6UdN6BBkTIP1k7a9GT0JgJmfplSjHUo3QXR67LZhOYU9Q1ex9koSR77w8KRnbcp/wD2zItg9D8ohllM5nrYIteOzDIxWVMGit8BVav3x2xR3EsCoPM9hHhaRPqo4Wlmi0NkxKFNDlZtvZJDIJCkO/CIhPwYKCcZkVw9Kdqt8R3cWQndiwZfWDSEGb6QNct8hbrdLULcadUiv6yu47o5Px6N13hD+HlPCjX+SNfYXciKhEqS+ZKP9OaEDqAA0uqpjOi0PxXvpYKj8a2+F7UgOsRhHdgZBbgJ648r0UW+TfipTYjkvskN9SKBE54Pf5B19IpF61kE48oNGrl69O2t11rtaZbhhCGC
 3q35w3ZS
 61y92HFof3ThjvsmNDX0VoukSb4vMVABVm/RGy8p2dkakj+3MMJcT931EbFJBd0c2pWs74x/yaDL2Tlbzh0f7tS6HwIh3RCJegSQLGDQXkIRZFGrXOHcMTGu5n7zoytBcKsw9Z8dqmx4eIXYI+I+L+j3h3vxvlFikIZo8yYhB27QAzkg3c81zOVDhWK6PVz2G8Ny22W72xnsMLNsqzGSLCfHPsDLcXutVTDZoErgDohbSbocDXzgzMu9vWqDl/79yb2aXlq1VUHik9ZTD5/kTDP69s15LfBfyH66B8+O8Vu++EgrTRK4jmlw9uk/ZVR93oXpCGU++k3VH9S2IBtH5d0YeJQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Before create basic test cases, we need to have some helper functions
to help setup the tests.

These helper functions consist of:
  Mount and unmount the mshare filesystem
  Create a temporary file which be performed test on it later
  Map and unmap mshare region via the ioctl syscall

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/basic.c |   1 +
 tools/testing/selftests/mshare/util.c  | 123 +++++++++++++++++++++++++
 2 files changed, 124 insertions(+)
 create mode 100644 tools/testing/selftests/mshare/util.c

diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
index 482af948878d..35739b1133f7 100644
--- a/tools/testing/selftests/mshare/basic.c
+++ b/tools/testing/selftests/mshare/basic.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include "../kselftest_harness.h"
+#include "util.c"
 
 TEST(basic)
 {
diff --git a/tools/testing/selftests/mshare/util.c b/tools/testing/selftests/mshare/util.c
new file mode 100644
index 000000000000..75f6ff25aa2c
--- /dev/null
+++ b/tools/testing/selftests/mshare/util.c
@@ -0,0 +1,123 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/msharefs.h>
+#include <stdio.h>
+#include <mntent.h>
+#include <sys/mount.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+/*
+ *  Helper functions for mounting msharefs
+ */
+
+#define MOUNT_POINT "/sys/fs/mshare"
+#define FS_TYPE     "msharefs"
+
+bool is_msharefs_mounted(void)
+{
+	FILE *fp;
+	struct mntent *ent;
+	bool found = false;
+
+	fp = setmntent("/proc/mounts", "r");
+	if (!fp) {
+		perror("setmntent");
+		exit(1);
+	}
+
+	while ((ent = getmntent(fp)) != NULL) {
+		if (strcmp(ent->mnt_dir, MOUNT_POINT) == 0 &&
+			strcmp(ent->mnt_type, FS_TYPE) == 0) {
+			found = true;
+			break;
+		}
+	}
+
+	endmntent(fp);
+	return found;
+}
+
+bool msharefs_premounted;
+
+__attribute__((constructor))
+void mount_sharefs(void)
+{
+	msharefs_premounted = is_msharefs_mounted();
+	if (msharefs_premounted)
+		return;
+
+	if (mount(FS_TYPE, MOUNT_POINT, FS_TYPE, 0, NULL) != 0) {
+		perror("mount");
+		exit(1);
+	}
+}
+
+__attribute__((destructor))
+void umount_sharefs(void)
+{
+	if (!msharefs_premounted && umount(MOUNT_POINT) != 0) {
+		perror("umount");
+		exit(1);
+	}
+}
+
+/*
+ *  Helper functions for mshare files
+ */
+
+#define MSHARE_INFO MOUNT_POINT "/mshare_info"
+#define MSHARE_TEST MOUNT_POINT "/mshare-test-XXXXXX"
+
+size_t mshare_get_info(void)
+{
+	char req[128];
+	size_t size;
+	int fd;
+
+	fd = open(MSHARE_INFO, O_RDONLY);
+	if (fd == -1)
+		return -1;
+
+	read(fd, req, sizeof(req));
+	size = atoll(req);
+	close(fd);
+
+	return size;
+}
+
+int create_mshare_file(char *filename, size_t len)
+{
+	int fd;
+
+	strncpy(filename, MSHARE_TEST, len - 1);
+	fd = mkstemp(filename);
+
+	return fd;
+}
+
+
+int mshare_ioctl_mapping(int fd, size_t size, int flags)
+{
+	struct mshare_create mcreate;
+
+	mcreate.region_offset = 0;
+	mcreate.size = size;
+	mcreate.offset = 0;
+	mcreate.prot = PROT_READ | PROT_WRITE;
+	mcreate.flags = flags;
+	mcreate.fd = -1;
+
+	return ioctl(fd, MSHAREFS_CREATE_MAPPING, &mcreate);
+}
+
+int mshare_ioctl_munmap(int fd, size_t size)
+{
+	struct mshare_unmap munmap;
+
+	munmap.region_offset = 0;
+	munmap.size = size;
+
+	return ioctl(fd, MSHAREFS_UNMAP, &munmap);
+}
-- 
2.20.1


