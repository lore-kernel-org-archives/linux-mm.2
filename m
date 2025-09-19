Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CAD7CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8511A8E000D; Fri, 19 Sep 2025 09:06:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D3668E0001; Fri, 19 Sep 2025 09:06:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 626C48E000D; Fri, 19 Sep 2025 09:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4CADD8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:06:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1A51C11AB0C
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:45 +0000 (UTC)
X-FDA: 83906024370.17.64BF506
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2B0DD40005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=A2qsL6hx;
	spf=pass (imf27.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w5qgH2nc8AqvE/lFKBkchQmBG3HVN139FltrQBIQhUQ=;
	b=3UY+fx9hPEthjtS5vsQhNaBjGQM+HjcH/PvgMN8ooLCE98xOep93FXyPDCrQLVCe0jxylZ
	3gBMUEx6bZYvCJBxVtJzehqxZTSGOc8J6+Mt/HEGcrHJzJPXk6oFoeAyn3NWiHc1v+hZGA
	YG2vgXH3pAmKDvrQpyKkexD28aa3itw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=A2qsL6hx;
	spf=pass (imf27.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287203; a=rsa-sha256;
	cv=none;
	b=q0rAcuyqbUt/SpABgkXYlNgKsFoToPgJP1A9Cle5nO+hW6U+ES8q8P9zjT3VQ0lZQR43uV
	8Mrid6HC5X33JFnA/u5FNubg8h6uoT2Ey1ndVT22jMu085ivwAraqrACmmgCYl8rFF1ypp
	rTl3pmVN1NishUGFkZTtwyaFN0x9CYg=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2445824dc27so22215155ad.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758287202; x=1758892002; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5qgH2nc8AqvE/lFKBkchQmBG3HVN139FltrQBIQhUQ=;
        b=A2qsL6hxtBV1FF9DV3yB8fZLdESjZ60bk0YWQH5UJaUi8hs9vfGXdiRSAo552E4CTh
         WGgUo5IcNNyJYt4IUGqAvnDfNxbniufb0zjP8HPGW/UD3/pcMGEmTQ8UPOzAZLk13kK1
         K0Fgencd1JgwIQ2lJ/0Ww7he+DnKhg2qZRGFz7QnAYc4BdDabvAn2VtikSzkH3PWnCRy
         nAjhE/q40BV3pafVHmkXY53jMmOOWyixWcxpxXxZbrRrYxJ6kMJC49sHGZGymMlZcGcv
         JmOQ50RPuAWljtSAm4+4lG8XUmdcNqw3ztU2alU3t1iAho1TnxhD4wq+VG9TAWqKF4cv
         pnwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287202; x=1758892002;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5qgH2nc8AqvE/lFKBkchQmBG3HVN139FltrQBIQhUQ=;
        b=gO3HvZKDXpiCgWszLfZsf8m5xrvYFqVGpt1FAg27PgBV/uMSUCcKk+IdL1LsgIucB+
         JZ4mwxoU3qi+dhmBQ/RlQIRDniunV8hAP4qGSCPHpaVNRcZP+f9k1If4J/zbQ8Z2wWSs
         IGpwuxRtxjsLmccUeon5+Wk8c6m/X4JRtx+FymVP0Q1pumUnLCa/w1SrXlt8tbh8eUgt
         8Wa3BRW/4qf+s6ZuCD9Q3xjX8EdDyYp1qhNXCRUkZyGWJr0h7KDFt3HcPiTWr8ieLZCW
         PlpSp9Pd4d4lDIQULSESlWRb2d6ZEdHPBny80fK3J9TwWn2hwtttZPGMh9J7kScqRneW
         1htA==
X-Forwarded-Encrypted: i=1; AJvYcCU99Eun174WOr7TZpb9dojytL6+hpi413YM9t1vvuRLo5I7KjibjclVa41ID3ArPj+kNCokwG5WnA==@kvack.org
X-Gm-Message-State: AOJu0YxBmIXsFMhWc+x83Cd0g54YIdATHPDraw8LH+Ma+h4B66bx7FGi
	73zeMWyGlmPKQYsP9srWpl8G8XGFZP5tLHV9Y3beTzaDD9tRXB8H9RAvhLZODnHEoeA=
X-Gm-Gg: ASbGncuZr9iPR6RMFSNxGhHnXXkh/XomUwvW+LXBj89ziT08YFjVv0V9nUoB0pDTDVf
	Fp8g1rGKP1MHSUBUyCU53Iws9DIAxHw0hy/ehp6vrVW1PIcixBWk9uYywcdvsrZ3yBaauuATikK
	9iYWV+k9CAMbDENazDDW403fcZmvNvXumaE+mNbJWdxAR8u7mWmcTvdBZIUkFuvQiCHVvjnSEUZ
	FEy5p/IOyHNZDhGqDUsr4PJnrIASX3KwwAQX1Y99rKBFPJcN1t4osFzdvLG6czLoRQB5uZjwx+L
	/cwvhIxeNDCPvfTEr3boJmVa5S5RmrrI+ZRBZfZeMW2ZSAxS1quH1xZTZ4R8gbV5G4ZCseMeSdY
	92wG9uheoIJ3ba5eqjAanfh5/g9gY8V3fyOQOrZVfbXdpYLMHsQnHuty5Rg==
X-Google-Smtp-Source: AGHT+IETDD2d4OAR9jhdP9S0YCuERWs+SfZaIxhjukdFizllZQ8yfT5HmxT8Qc7dOByRbeeQsSjHOg==
X-Received: by 2002:a17:903:1b68:b0:269:b6c4:1005 with SMTP id d9443c01a7336-269ba552560mr39859765ad.55.1758287201584;
        Fri, 19 Sep 2025 06:06:41 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000::d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802e00b3sm54732065ad.90.2025.09.19.06.06.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 06:06:41 -0700 (PDT)
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
Subject: [PATCH V2 4/8] mshare: selftests: Add test case shared memory
Date: Fri, 19 Sep 2025 21:06:16 +0800
Message-Id: <20250919130620.56518-4-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250919130620.56518-1-linyongting@bytedance.com>
References: <20250919130620.56518-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2B0DD40005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6cg4mp18j4aa1dbj9gewros69rw5suox
X-HE-Tag: 1758287202-504662
X-HE-Meta: U2FsdGVkX1+KL3Y2emRLltI07N7MEninWrBkIOX2/NnTk7Yy8a5euy3opb7pAdQsXw+bOHaDzv1sqtiXsnr5gWmWwakftFroFNdQNOTzlioXbivhOrTvqJyUSRjxFKjjV6o+XKZx4ZMhbNt6mwoYH7JA2u9/SUYLs6slQmC099HFFW2BGL9kXCdGOcJR+yT9PcpPnuTXoQWW3kAsrrL1aMQtsoZvhxSmNOkNXOfDp0Lg4VNDJmmMC3/ADFXk1rqy9TtS32aP+BGIAoSBwvu0TaBjypgUPDbo9rkcKlxuNKs1UsLaYC+QDYeTDn2+dxpSKRDEGkQHKjHzGkBrnMoNg5+PkPsg8NmB+TSIncOWDtUbj/DZyvaFCn3vZ274puhcWiZGLuugK3MoKJdJ2kVfm7ND7doSA7Odd2ta75mdZK/h5MPovc6chjKhfGt/bLhKszfYdXUbv9rfNDnN15OJj/Dpr6JBwqmvTOqxc7ncUbcPDUi5jXNzTg7Q00cd4vM1OKvZ49A1Y0O9dToZSdh+dIQnH5922nJKbgYsRgKoViL5Zri0hDPq6nTYF6lzuQZx6u69d4nFVpiN6betTaLLGXyx829jA7J+j6nZKOJ/uRjI5PdTDpv11WzcIpwlgaHERu9hhGELPAr0xJQz8mAOdz4FQNPPpkPm5M2/RCz/zxW3Qtc03INrprABpgk07dGB30Zz4NdYExfF8HGIJiC0VMRFiaDRgmUGhwqIom9xlhNWNbQBAuDZ1LPt43nJll2//SZShdAgrl9HkC52a24LvT7uNd36+Hvkj2HqI0DatcSZJd6aWTFhs2dJ/fcm+7vp89qOAxcAdhWGvBWLziVa1AQ7fIdvn1FOyHPMrKx0suLt7lmH4xMgg7L4QggVfVfQ2a9cFMXV23pAHmbGjjBtGPL61FKNgItBmPpV1K0IBSD0Mh44GjtFnoWFTn12hZYr5KoDAy+/6/FKkXMxzVB
 LJyp1LcV
 C6AW/xf938awHBtn2+1SMlXGGx/I/RmxPbpS2Ktnw6hFiBC/u5jfLc3ujsriTjMcAg7ZwO/5wUr8eEmcgT2Ca8VPXIPEhZaO4Ktq6UNVKp4e3JUAHp69LFiUPhcJPXbcoF3MvgMtV0L2I7CI8ruEqvCjYERkXMY8cGBUS+vZQMBtB8TIwLejU/jJZrIorf31ZBJZpacpig2JKZPLg9o6ByrsqQBbcIKQmNo2NqSWwpmA4Gvjr46fibO2MOm8GD6alyoKyrAzSDVKQTb2KpqaKV7lsSv3w17EsMR5336ox/a7YmFd97L7FEUSQXfvkO0IgKeV1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case aims to verify the basic functionalities of mshare.

Create a mshare file and use ioctl to create mapping for host mm
with supportive flags, then create processes to map mshare file
to their memory space, and eventually verify the correctiness
of sharing memory.

To ensure these tests can run on any server or device with minimal memory
usage, we follow the steps below:

1. The ftruncate size must be a multiple of the alignment size.
2. In the ioctl(MSHAREFS_CREATE_MAPPING) syscall, which determines the
   memory size occupied by an mshare instance, we use 4K/8K for normal
   pages and 2M/4M for hugetlb pages.
3. The size used in the mmap syscall must match the ftruncate size.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/basic.c | 82 +++++++++++++++++++++++++-
 1 file changed, 80 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
index 35739b1133f7..54a132a8116c 100644
--- a/tools/testing/selftests/mshare/basic.c
+++ b/tools/testing/selftests/mshare/basic.c
@@ -3,9 +3,87 @@
 #include "../kselftest_harness.h"
 #include "util.c"
 
-TEST(basic)
+#define STRING "I am Msharefs"
+
+FIXTURE(basic)
+{
+	char filename[128];
+	size_t align_size;
+};
+
+FIXTURE_VARIANT(basic) {
+	size_t allocate_size;
+	/* flags for ioctl */
+	int map_flags;
+};
+
+FIXTURE_VARIANT_ADD(basic, ANON_4k) {
+	.allocate_size = KB(4),
+	.map_flags = MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED,
+};
+
+FIXTURE_VARIANT_ADD(basic, HUGETLB_2m) {
+	.allocate_size = MB(2),
+	.map_flags = MAP_ANONYMOUS | MAP_HUGETLB | MAP_SHARED | MAP_FIXED,
+};
+
+FIXTURE_VARIANT_ADD(basic, ANON_8k) {
+	.allocate_size = KB(8),
+	.map_flags = MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED,
+};
+
+FIXTURE_VARIANT_ADD(basic, HUGETLB_4m) {
+	.allocate_size = MB(4),
+	.map_flags = MAP_ANONYMOUS | MAP_HUGETLB | MAP_SHARED | MAP_FIXED,
+};
+
+FIXTURE_SETUP(basic)
+{
+	int fd;
+
+	self->align_size = mshare_get_info();
+
+	fd = create_mshare_file(self->filename, sizeof(self->filename));
+	ftruncate(fd, self->align_size);
+
+	if (variant->map_flags & MAP_HUGETLB)
+		ksft_print_msg("Tip: Please enable hugepages before running this test.\n"
+					"For example: sysctl -w vm.nr_hugepages=2\n");
+
+	ASSERT_EQ(mshare_ioctl_mapping(fd, variant->allocate_size, variant->map_flags), 0);
+	close(fd);
+}
+
+FIXTURE_TEARDOWN(basic)
+{
+	ASSERT_EQ(unlink(self->filename), 0);
+}
+
+TEST_F(basic, shared_mem)
 {
-	printf("Hello mshare\n");
+	int fd;
+	void *addr;
+	pid_t pid = fork();
+
+	ASSERT_NE(pid, -1);
+
+	fd = open(self->filename, O_RDWR, 0600);
+	ASSERT_NE(fd, -1);
+
+	addr = mmap(NULL, self->align_size, PROT_READ | PROT_WRITE,
+		       MAP_SHARED, fd, 0);
+	ASSERT_NE(addr, MAP_FAILED);
+
+	if (pid == 0) {
+		/* Child process write date the shared memory */
+		memcpy(addr, STRING, sizeof(STRING));
+		exit(0);
+	}
+
+	ASSERT_NE(waitpid(pid, NULL, 0), -1);
+
+	/* Parent process should retrieve the data from the shared memory */
+	ASSERT_EQ(memcmp(addr, STRING, sizeof(STRING)), 0);
 }
 
 TEST_HARNESS_MAIN
-- 
2.20.1


