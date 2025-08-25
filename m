Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2BBECA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 322218E0036; Mon, 25 Aug 2025 10:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D3AF8E0001; Mon, 25 Aug 2025 10:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C1C98E0036; Mon, 25 Aug 2025 10:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06DA18E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A3ACBC0439
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:59 +0000 (UTC)
X-FDA: 83815584678.29.9B8806E
Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	by imf01.hostedemail.com (Postfix) with ESMTP id B5D6F40013
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gS3gzIH2;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oaQVHpJSfD6iISTq4Fs9qiBmXO38S9TJM+RHgKSb1U=;
	b=c0w/85beRwMw7NOCS32QQnEKtUrlV1cGvfP+BkeUhCmPu5hG1P/FlX17jAoD96LXRIoCpo
	W4ue9+mvu/C/vDKAwdKF7v5NyCJ1BFcXw6B98C401bZflUdIF0CjLeUpp5dlkN8aYV1UP+
	/PvPQrAXUCtGTYAswdztGS8jGSkJI4c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=gS3gzIH2;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf01.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.193 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133877; a=rsa-sha256;
	cv=none;
	b=RKtu/i7b4pXPnkkcr3ihQjCkSwCHqTsrFvHcIhKq7t0vB/DDOcklI7PdecYa+kdzTQ84rn
	yf04H+m8XkOsCPduFa8DtgeBMLstlOT+ocHjImYEuMXO3kHh9gM904olw3B+YwkpRsEQVQ
	IEjpzkPcZBN5zl/TxaUr81xBKD3RiMY=
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-76e434a0118so5252444b3a.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133876; x=1756738676; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8oaQVHpJSfD6iISTq4Fs9qiBmXO38S9TJM+RHgKSb1U=;
        b=gS3gzIH297Jio1LoDUcX7aBp0TOczoqQmsvdLGdPRMJgnE6VT7ev6wCz7Es8jGodWC
         MgGCutklEQBeLNyf1OGYkpJjG21bbnQHoz6UKYf8PRiK4q+vbcjAuJ7NBSSjqywDVcxW
         0cMJc9ZGgSm0EvncGrZmGmnl6w++qjyv3eYbvnyYs3Uru/LQ12qQNICVaTz9WdUp8Oyl
         h3aClk32FzZaThz7H7xAZ1OTxSCytqDFNizZgQ1UeYCZvorumweTOdNOwsld3yaXLIsz
         0ZmNjsD9maMeoBVXGAohQwRW3ina/hboBElcdoX2W3i5CE9vpfD+OtnGMpF8nGNqeTD+
         BXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133877; x=1756738677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8oaQVHpJSfD6iISTq4Fs9qiBmXO38S9TJM+RHgKSb1U=;
        b=I1oQnRf7wM+99u0TgoUdPalh8jKJI5KTDS7xWpHm+veRj5qLYMxWYIXrCNNNygGBS9
         K6AebYCM0OBnRbZ2/0bBCC9onywM8MZNu0mEqXzGGzBY/ekJczxQ9fx+cNy9WFD+OFJ2
         uol6rlMSlXBueJUApw4X6GiJJAyTabNHqP6HL/wXbu/0FRByMq1UJasXBgFyQGO2gTBB
         YHCBPkAX30v5R7jFKztsBbJmyJ6aeSbOJNQoc3yfkt3FYu6DX5Jk0abCmPH6miinKPt4
         9QTOrqH7/tbcAWSJDoxXKX1t7yNRIc1cln7C5lnIHVLzdyIR70PUIk8gjmt2yyO/JMuP
         cA6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVp2bhVTcXVW1iKm58piQ98agBFl7E/EiiQzoa+vZaoxBBweSaPanl0RLrsEnKpoaZJIjUobx0i1w==@kvack.org
X-Gm-Message-State: AOJu0YyVz8y5k3OoMhEDCEhtqUZFcInPHG3i5WAP3MWR5A/+B7/tB5eV
	EOkYg3SFqAbaujXqPHqrBqiyRCrcFRB5nogcMHa8Apf6p7GhaIxdOMiBUUd/HBKtUqs=
X-Gm-Gg: ASbGncsYL+F1Dh0vuvXDY/FviZm14jqgTYthuMM1BfyV53kbkmNgFHfBrk5hXm1AV1b
	QHNgAsJ2QYnszhGj42NIOiSZWhblV/BOxT8UbjJ+2I75cor96K+6VAqkZFxillluGsS+kurD3yd
	yJPJbbqfpB4mrCetxYeTSRYNwYbkjLkENoGhWqqGeSze1TosMXVYF7jBcOg4jFcEO2PFXc7bjdm
	bMSGZEKWkA9mYTJXhgdwJ31k1dauFUCt9aK6PWuBJTjhHMqpz21ukV9futDVsGBZ2jvmCVmtbgH
	Bj6hWxOzLny4B0ySIKLLB1PiGbDjKpBuUP5K8eh3KpKIgHAW5Ejt71ViCjUGag2edXXXVAcwQJ4
	2jKOu7scvBziKuSI7j5a2FpvYSRT+fUNRnDS1vq0Am8C8WpwW45awn2th6qZY
X-Google-Smtp-Source: AGHT+IEJgruw8paBQDNIopG839sPtxHYbVWhGydUTRYfwwhqmDIT8wYlFvzCj4LXmvnvNxNKmNvDrA==
X-Received: by 2002:a05:6a00:3d96:b0:770:3d67:82b1 with SMTP id d2e1a72fcca58-7703d678890mr13756054b3a.32.1756133876538;
        Mon, 25 Aug 2025 07:57:56 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:56 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 7/8] mshare: selftests: Add test case to demostrate the swaping of mshare memory
Date: Mon, 25 Aug 2025 22:57:10 +0800
Message-Id: <20250825145719.29455-8-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5D6F40013
X-Stat-Signature: 4iqz3ccegsyuf47fw3m4fmrtbxbi4fg5
X-Rspam-User: 
X-HE-Tag: 1756133877-513679
X-HE-Meta: U2FsdGVkX19sAN04zt5gWdR2K60Fl/soW5DWvxsYz8o4DVbT7qsKY5WYob5xiL2zzxg8YWniCob1nydR+gD5pw5/n7ge0wiG/qMfnw89/BoTMGIvSkNEkSzNOvsWZOYMzIIU0m4SRrim6kEAK3fksrr/QWCIHgwNiWHuqueu89fuIXzbiETwfti0Me7wi8oiMnpW0X+lrxFRf7tWW1CA5LqVoNw8wq+4cFf+9sRXVGod1vz5jjQ8tvge4EBttRHxR4fbUP8JhQlTnaD57ig0PHC2cIxjgACNP191Sx1HnSa+MZ93Y+i77c+04ZRZmg/zV+oFxxxtGw98sPhGwJE+r2X0Y2PxCfhKGLwgnYdfNBWUg5224YYaVpAZf9xHLNf8P6PPCuf+avHZ4qoon9xIV8JGpfPsGn3RjkNpAJgFZAri7/j+zszjhowfdytKeWa4Z3fNZ/IDvulrEn5jfL1DsEFc4la0vxO12YeiE0o48Yt9DI6fvUWkXG9JvCAqn1WDE58qbP/Yi12zlfSTFMok44B9U4GSdg6u6y7g/sw5wEXTvCnWXBNJP9qOdqDjTEIHSDQPcuVRcEBAqGjaaB6a7yUWEq13IzOm6B+7BvIFD5JFq2zN+tw0SJhrpLkxzSg8GE698sokq2xp/6vMrdoGuciP1XctOVeb/7YjUnPTMqLTKH6cOeRp1dPpEYzUAmyWKQqLiPsvwoawokMnwUaQplHxF7z3QUxJh42RprH0oX20mo74BqUFGaY57HfR71Tf/VKrBrvhAvmzk8PuUg+zHNqEk17CZE/4LsUBdamrdPrC3BDNJJnRouncT/bv/4bHDryqZ22Bief8P1kZ4iIMJbf8Ez9y/jpEGVTlSZQ9shBbFIxdDM8bkvyzyD4ECmxx+OPFgQTjP+dI9IJWHt3CxrcpsRPXnv7S0DTTlGCjsWwREKc2W2Ynb+eERXhbRqOYoIeMq8GeRugji2/RPCM
 P+FleVTx
 DzJuJKX9PdEhpNYe22WVYJIJmcZ1dxCcuBiwVerL/F8r6SxJgcYCOZ2M3d+t6uvPxCus/9wpIFCJW33YnodWHSkHYq1hwGMXmR21NC5qR7mmS9EgCD/9RIX2SBvIOBRG5poM6rWk2LXGRWSV+5ssUV8nMbk8De9gjU9iaAmEmb09UeYjbTQSqvjQuUjW2JtQP+nihwSoxkj5tktQwjv7Z4v3EWikcTijQrbXKbBDyRSwSaXaYL65JQNiAp/HrM1QFEBCsgQ/eUPsD5vbbTmF/FWm6kP2//3jNlIy0gYNcELPITj8CVs6Mq2rWYfxwLn6Ft+uhHUQmoOoJaI7i638L6fjXN+IfzPwqIchSlau0lL5WaiTnA9ywHAYPx6wM3K4U5+BcauYMj8bNnrrKeNzvis4KDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This case is quit simple by using madvise(MADV_PAGEOUT), but for verifying
the memory size of being swaped, we need to setup the memcg and attach test
process to this memcg before perform the test.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/Makefile |  2 +-
 tools/testing/selftests/mshare/memory.c | 71 +++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mshare/memory.c

diff --git a/tools/testing/selftests/mshare/Makefile b/tools/testing/selftests/mshare/Makefile
index 651658d091c5..b0418b8c30f2 100644
--- a/tools/testing/selftests/mshare/Makefile
+++ b/tools/testing/selftests/mshare/Makefile
@@ -2,6 +2,6 @@
 
 CFLAGS = $(KHDR_INCLUDES) -Wall -g -O2
 
-TEST_GEN_PROGS := basic
+TEST_GEN_PROGS := basic memory
 
 include ../lib.mk
diff --git a/tools/testing/selftests/mshare/memory.c b/tools/testing/selftests/mshare/memory.c
new file mode 100644
index 000000000000..7754c0e33506
--- /dev/null
+++ b/tools/testing/selftests/mshare/memory.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/mman.h>
+
+#include "../kselftest_harness.h"
+#include "util.c"
+
+#define GB(x) ((x) * (1UL << 30))
+
+FIXTURE(memory)
+{
+	char filename[128];
+	int fd;
+
+	char cgroup[128];
+
+	void *addr;
+	size_t allocate_size;
+};
+
+FIXTURE_SETUP(memory)
+{
+	ASSERT_NE(create_mshare_test_cgroup(self->cgroup, sizeof(self->cgroup)), -1);
+
+	attach_to_cgroup(self->cgroup);
+
+	self->allocate_size = mshare_get_info();
+	self->fd = create_mshare_file(self->filename, sizeof(self->filename));
+	ASSERT_NE(self->fd, -1);
+	ASSERT_NE(ftruncate(self->fd, self->allocate_size), -1);
+
+	ASSERT_NE(mshare_ioctl_mapping(self->fd, self->allocate_size,
+				MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED),
+			-1);
+	self->addr = mmap(NULL, self->allocate_size, PROT_READ | PROT_WRITE,
+						MAP_SHARED, self->fd, 0);
+	ASSERT_NE(self->addr, MAP_FAILED);
+}
+
+FIXTURE_TEARDOWN(memory)
+{
+	ASSERT_NE(munmap(self->addr, self->allocate_size), -1);
+	close(self->fd);
+
+	ASSERT_NE(unlink(self->filename), -1);
+	dettach_from_cgroup(self->cgroup);
+
+	ASSERT_NE(remove_cgroup(self->cgroup), -1);
+}
+
+TEST_F(memory, swap)
+{
+	size_t swap_size;
+
+	/* touch 1G memory */
+	memset(self->addr, 0x01, GB(1));
+
+	/* force to reclaim the memory of mshare */
+	ASSERT_NE(madvise(self->addr, GB(1), MADV_PAGEOUT), -1);
+
+	swap_size = read_swap_from_cgroup(self->cgroup);
+	ASSERT_NE(swap_size, -1);
+
+	/* convert to bytes */
+	swap_size *= 4096;
+
+	/* allow an error of 10% */
+	ASSERT_GT(swap_size, GB(1) * 9 / 10);
+}
+
+TEST_HARNESS_MAIN
-- 
2.20.1


