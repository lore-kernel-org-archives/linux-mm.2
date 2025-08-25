Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1956CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03C968E0033; Mon, 25 Aug 2025 10:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FD28E0001; Mon, 25 Aug 2025 10:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1DF28E0033; Mon, 25 Aug 2025 10:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CDD668E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:57:48 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5DD651187FF
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:48 +0000 (UTC)
X-FDA: 83815584216.04.C305BFD
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6F36B1C000C
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:57:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SntQcJpR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+3wX2qQorY9HjJTcapV+Fc+oMOTnn7HyjyOkt8jkGk=;
	b=GzrNFOxI3TZI8M3ElFhTeRS+ROFUfHSQHCuK/3+kWIXOC175kgJ1kokjf2awdoZ8vHlnGU
	Ujo27OYuq9AIs3NRN7QdmhxwrnwTbC9bYvI8ovX+LATNJmgOLIPELste5oI255chKKuRTf
	LiCeHpAmTULMyy2hAZXhzC2UM7Of/WU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=SntQcJpR;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf18.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.174 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133866; a=rsa-sha256;
	cv=none;
	b=yJYVzs7+pkrLWGxnMrumTbvu3VXtelfKHcXTFzaV+3iGpwqQdWNQQlJxJ2JnwLBx8O6mhm
	SHkI6BErj6KJDolCbIzMHIxiJn3NFGLEwyCBbIpyptS7kxIfwxke2eOe2L+M3tmslmdzhK
	csA/YUbELoldWh2Kv3HgS3neaDqoAak=
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e7af160f1so3076234b3a.1
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133865; x=1756738665; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+3wX2qQorY9HjJTcapV+Fc+oMOTnn7HyjyOkt8jkGk=;
        b=SntQcJpR2pw6AbV9ahF9ZdecQ7JrJkN2PdNvrhDR8K84abxj4DcDPAXbqdZqaZkknB
         VYXe+x4sc7u65eTm0z7eWoEqHrBZjZUHSQPSaiQL0GufzSEnrLhI3v+CUTWDVWSYCnb9
         Wk+OXUGuU0cAuTr5VcM5MxN6MsKgkDFWkod81gwKJjJZFgOzwHOHCB3VusvyTFb2Qvx/
         j/94/nURWuKUZBx9dKjw4bfAYGAWLtNcA1RTAaDH6mnJOVE1mNjDlBOFg5BuPjiFZpcX
         g88c1BdEaemIVphiYJz0AjuRycuZCbKXeGkEBeiSDTCowl1FcAIN6PORT2paQjtW1t8G
         Vdzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133865; x=1756738665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+3wX2qQorY9HjJTcapV+Fc+oMOTnn7HyjyOkt8jkGk=;
        b=cqjOhrYUVZQ1KEowfMvBj7tKn9Dx6X+V575tu0MCrEhtrC2P299D6XEg17GhMItegq
         NdVQJX0Yyt8ncGMbsOlN3bNm6V4BH2k/gaIIQPjNHFs2EMLL0KJKBVXZpuSFjVuNVh3L
         Skk3oc1seod2FYkVdfCuxiSoMdQIwJ2KjjoXz27+Emh4UJfSZC4IAOSFj+EVBTxJvXaR
         5SpVRMvCI/IjQR9jejS+Kl5NoUvXg3shHAokT8PC4cA1e2cr9GtTveCeyuWoAZBX3zfY
         Ol0RR3Yih97XpfSUyy8bJ99YiMhxjE/2Wgtqr/6AyPoIWlqECQIZA6s/WbmW2JcD9QqB
         MjfA==
X-Forwarded-Encrypted: i=1; AJvYcCWvTH65q03FVaRsy6G2DPy5gkgkDdqEOuPMEdYv1PSEB+EtLwogwDi4/SfjuTtX5P9TKaIp+LDOzg==@kvack.org
X-Gm-Message-State: AOJu0YzcuWzYB46yvAk+umIF6c7c8ZefxizHju7k5GvhA8WFJbqIJ/tP
	SBxqMGctDs6fBL8SM4Ly0VEz86zOWYLDGeFABcxZfvf1XN5duEOab3Vvimud71Kay5g=
X-Gm-Gg: ASbGncv5zBy1slCEODRi3Q8LsG4q1hCweF7otiLZCgUZjkWBBqy7BU1A8ap5gsKEq6+
	uU7jz8NfpUcbq0anRUaLAEnJ+cxN9gWxj5GTSlYfY6iMfIjHiNjUaV5KNYReRFotsZ5r7YWTZ4F
	Bru+Lw5PXpvZPKdoq9x2ltxxSq8VNu4tcrscwaQLlzSoCIKwogkYcPj68JIVzPFHLHb2wfLdRTP
	xclO02/JadtMdn5r8vi8R21vuuRgjxh0OJ9J9UIzc8KO9jvTjZFd5j/RhbSygauWwftSwsOdgl7
	q0vsed6ZXfeUrDoyEq7TIN2uGtUwyCz/0kCl/GmydfgKXp/BGSxeW+DUpX4SYa3MLfbHFOYpitk
	lnb9sQuCPX2Z4j1DhpCttCUb8qDP65j0PamfncDjljf4pSyS7Sj9JayXTBzc3
X-Google-Smtp-Source: AGHT+IG029ngLH0Z0VBrJyvV3C0TtjVJCx48xckH0n599Ds5K4PkyEQjVQ5nnkIfx/oH8gYOcLg5pw==
X-Received: by 2002:a05:6a21:3391:b0:243:78a:827f with SMTP id adf61e73a8af0-24340dbe653mr17737819637.55.1756133865176;
        Mon, 25 Aug 2025 07:57:45 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.57.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:57:44 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 4/8] mshare: selftests: Add test case shared memory
Date: Mon, 25 Aug 2025 22:57:07 +0800
Message-Id: <20250825145719.29455-5-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6F36B1C000C
X-Stat-Signature: 4n85z8znyru9i6ia46p1jb9omsor9ugk
X-Rspam-User: 
X-HE-Tag: 1756133866-715912
X-HE-Meta: U2FsdGVkX1/6iU5mxOv6c3k2CBPbgQtIH61MvgfgnFg+JfPz+nczBaVaQsyTbrNwFoXpiW6QwP09zcA9e1iOlzSc6NvCC2xL5BzrjLPKklG50W9I1iJ3cpaLKXmXjgIo1gryK/Hk4L0ry1cqO+oL2jHs4U4iyTbdplRw840FJzKjiWpEBh6hNraL8yU7aKFI3fpQqZNU1z+5JuUdGUu7PgRQSfBt4L0w9eZPEWEIBpT4bGSK+LsfBjIRpqopu8lw6fHcGL3X+EX/6Euh/qekgDGPubX0Jxug4ktdPiF9OnTlZWJUzlWG74PVQ5mRTPgC+Eqbq6Xu5Nqba7zuKjWu9G3SffZYMb5Dg46bBT52bqB8h5FVXnVQnJX+0cqclKPQA9X9wi8QdRvMSBYkU1rMraQ6gK4tksa9UgSrrvp3zsKshH/YGp1WK7emmURC21/0EEiofTiFvosdp8ZnRodZAq+3iPKD87zuWhA183qxNT7QmrMdPFN37SCO+N29bwmbcLntJ900gU8tZ5X20kVDckE4KPXtTJmPCeKITYwvU9dBeO/Nmtxe5k4k0q4iQdxCjkKT+uxSidAxbEFu3Ooq4diVzpx2NpYHTl4no2epB58zKYf2jolIZfxOd2l2ss4OXqtcyq0i07Mszca7WHu93/KjE4nfIWZ+iV3NUGvZUbpOMi7e5kQ3dNpHeT5hSVoLr3m4wbwftDoWpDeA3Xl1Jtht9Yfere6RTPAQeJpjuHoU9IGUv1DrSHcJs00J6njVtfNarUcnz7e3TFPNkaXSUu+LuIbDDAX/ET0D2j2cXneQEGUP4oZMZGD9RXmrOBA3RYkzgGh8pBp8kkI0BB2LgMj9uckKIoHI73Ve9ApCbu6MkbluLe/DdxwIgGhyO6Fj4G3bdyhr+bXUwrliiIZICIxG/1MErd6jg+31QOOLPrvFO6gPMkp8sXyBOt8Yy+VAeeG4r2atJG1qujXGm9b
 E2G8HaLH
 n7KPyi/BLw0KHihGl1HlkrUAdycCCu8l7HeZy7+EoqtCDuGACHAVj958B4tbEoXY9VJuuy8eER4pteVgJyA6VRsCLDxHRUjYKU+P9vCdRl3HefM/764ouoE1ICR4eXEtQWdoHMlLgJ8CUyWLgBhkCr66yAoyTwwciwhbpwtlSvViMAtyGW9vL0b+m3fp/VfQUDRxXrbUVMTvPHQqf3Me9AXG2gUaB5TySyiAxryBhgpFPUAfokPy/Y7foIm3FmCX7/TB+0rNPst3pHdogN8bzlwyMr5IcwIdWPlk6qhLx6xtX6C0MCMwyUcDMQQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This test case aims to verify the basic functionalities of mshare.

Create a mshare file and use ioctl to create mapping for host mm
with supportive flags, then create two processes to map mshare file
to their memory spaces, and eventually verify the correctiness
of sharing memory.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/basic.c | 81 +++++++++++++++++++++++++-
 1 file changed, 79 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
index 35739b1133f7..2347d30adfee 100644
--- a/tools/testing/selftests/mshare/basic.c
+++ b/tools/testing/selftests/mshare/basic.c
@@ -3,9 +3,86 @@
 #include "../kselftest_harness.h"
 #include "util.c"
 
-TEST(basic)
+#define STRING "I am Msharefs"
+
+FIXTURE(basic)
+{
+	char filename[128];
+	size_t align_size;
+	size_t allocate_size;
+};
+
+FIXTURE_VARIANT(basic) {
+	/* decide the time of real mapping size besed on align_size */
+	size_t map_size_time;
+	/* flags for ioctl */
+	int map_flags;
+};
+
+FIXTURE_VARIANT_ADD(basic, ANON_512G) {
+	.map_size_time = 1,
+	.map_flags = MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED,
+};
+
+FIXTURE_VARIANT_ADD(basic, HUGETLB_512G) {
+	.map_size_time = 1,
+	.map_flags = MAP_ANONYMOUS | MAP_HUGETLB | MAP_SHARED | MAP_FIXED,
+};
+
+FIXTURE_VARIANT_ADD(basic, ANON_1T) {
+	.map_size_time = 2,
+	.map_flags = MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED,
+};
+
+FIXTURE_VARIANT_ADD(basic, HUGETLB_1T) {
+	.map_size_time = 2,
+	.map_flags = MAP_ANONYMOUS | MAP_HUGETLB | MAP_SHARED | MAP_FIXED,
+};
+
+FIXTURE_SETUP(basic)
 {
-	printf("Hello mshare\n");
+	int fd;
+
+	self->align_size = mshare_get_info();
+	self->allocate_size = self->align_size * variant->map_size_time;
+
+	fd = create_mshare_file(self->filename, sizeof(self->filename));
+	ftruncate(fd, self->allocate_size);
+
+	ASSERT_EQ(mshare_ioctl_mapping(fd, self->allocate_size, variant->map_flags), 0);
+	close(fd);
+}
+
+FIXTURE_TEARDOWN(basic)
+{
+	ASSERT_EQ(unlink(self->filename), 0);
+}
+
+TEST_F(basic, shared_mem)
+{
+	int fd;
+	void *addr;
+	pid_t pid = fork();
+
+	ASSERT_NE(pid, -1);
+
+	fd = open(self->filename, O_RDWR, 0600);
+	ASSERT_NE(fd, -1);
+
+	addr = mmap(NULL, self->allocate_size, PROT_READ | PROT_WRITE,
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


