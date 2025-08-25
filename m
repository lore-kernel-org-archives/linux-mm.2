Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67913CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6258E003B; Mon, 25 Aug 2025 10:58:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A5A8E0038; Mon, 25 Aug 2025 10:58:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D468E003B; Mon, 25 Aug 2025 10:58:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7ECFE8E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0BED258481
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:19 +0000 (UTC)
X-FDA: 83815585518.18.9D445A9
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03CA8180006
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dEjk3YAl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133897; a=rsa-sha256;
	cv=none;
	b=xMJ+bxA1GdT2qpue7MQPolNf+gRZB6TAosrr2NMnBUfK3XfaZm5EBuumGb8U77pg+mOnDM
	y8rXjF7rh78Ht8DD0R5cqZO6DrgchDv72t+gHDPSTFQXAbnzKbqyvwx6RcvHgLkxZFTShI
	BZ+RrEoaVR2+mSwIYKh4upS8Ue04X3I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dEjk3YAl;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf16.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+3wX2qQorY9HjJTcapV+Fc+oMOTnn7HyjyOkt8jkGk=;
	b=q51S7043VcmjH45bcTUoqs5HgC0vS5qF6hhAwJEOtZV4u5UJggSHUwzuxeDkbJ5CcP3N4l
	IDr3YC4cUHz3bBpO6wzSlpNyzVojswhr2zBzfpEPnqGbe88V1p4EBsFSLNPwbBrrjAHWYe
	oSPk18feuQhIEAi56f9EQsVUAu3QDtI=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-76e2eb6d07bso3776211b3a.3
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133896; x=1756738696; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+3wX2qQorY9HjJTcapV+Fc+oMOTnn7HyjyOkt8jkGk=;
        b=dEjk3YAlwJdmumklgPvbefb3BCdg4o8iZv4zi57H4ZHFI97omZf+YSVgAn+teH9/wh
         g8N57Ud3GU/1FAXRVY0sUwMIjXlmuE/mh3qLK6jtFsCx6/anjuYmP3sZEyIkXY3jZA33
         n5hKnKt5uOrFoi8GUFJk5SLecPt0LezbEFF+Vg8wBSkWipEgaXS9ldGVYNKOI4NlowSK
         H9R/Sc6Lg9ORLl/pNnUcoa8HcSSbzqPFLLNR3c4UfbD8WWmwijOuWxmqqc8pDXOnU4MS
         PckxYe92l43/U2bXleFv5DzZzleWlAmxcj7zCEKGB6ZRcMN26iUakWuDITCUatG3GA16
         1THg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133896; x=1756738696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e+3wX2qQorY9HjJTcapV+Fc+oMOTnn7HyjyOkt8jkGk=;
        b=A0ZTgZjvYgkCOJvZD1+XpLPB/SmC6C0yeKFqnBKyhaJJ/QppXqXG1xLx5wWlf/E1Aw
         ub2cdfQF5j2E1SlT+icztIGbl6/lX8J/guN7TbCfF0eUBWkd8qN3c1qbM8S7uC+CgkzC
         xQ9LveNYk3dqG3W6y/Z/8N1x0wsx5ywZRGTWrTiAUNt4zggc11qGKKupEoEXJDxR6Ait
         ctUBOxxlCOmMInlRYRYvHbqmu8ZFmLH1Q7+UGMnogRHbO0nq5gzwwjVywmrcTyB+bN0T
         xFwoCF+9K7Z8L4Ax0CXjWqU+J1M1pKQ7XMgzundXI+cCcJJZa20IPXK6dm5gqxaaxDiJ
         DNBQ==
X-Forwarded-Encrypted: i=1; AJvYcCULtiJnn4yg3VbEkj88kbJO6288XfpQquLSwkWv1Spu0C+LyTaRNktRZyhf7rXWFL/BgXATJanPmg==@kvack.org
X-Gm-Message-State: AOJu0YxvFMD/h3pgdtFTWFCQCoG4SUxcERNFXMEh9x1a4JyRRqwXfl62
	n+XCaWmWJlUpO7sMcCEWpk/KrGM0enu9y4CjYzPI1ozA9EV6AYVFfCkn+ZgZmgLbPVQ=
X-Gm-Gg: ASbGncuBAXcyymdR6buI4oWFZLjfN9hFyTQRdCiLt8vXqwdUUvEJhvOQU9qyOchNnio
	Ni4elVb9H0vV7MZbOtVLGtKzuuir9ysF4wlQVhxCH2pej8cIO+eVZ0npgpkkuIzC/WtefPWX+Eu
	inuv2rHzGInxSP2qk0ZzkcDmFr8CGC5LnXdhmMhWCfjTaa+AX8kz+D+qszi+HbDdMFbUTubW12w
	5sMO1uTHyWWe4sTa6MaBJuvQLq0BneUZqWd8SaFBbOTLmzI8GiOQcMdhJZy+ca1BAeFi3KXaHYX
	TSYCHw59gkvvHYtdnpQK3b8mVVbUkSqdbJcGKJu++D0/WY9TxFse0VYe7PhBsGzup1iS1Zh7301
	KZYxcAUfff3hIs6fnuFLif1X7nREx7aP00IFM6GHrrY5siPNSVIaouOdG+UxB
X-Google-Smtp-Source: AGHT+IGSZCY+q8MGo/Jnr4rtyaAqqyD29rBoj9ScLH5hoteOddGdtmlulcvDapltGRS/9Os/f0IGgw==
X-Received: by 2002:a05:6a00:4b04:b0:76e:885a:c333 with SMTP id d2e1a72fcca58-7702fae24c4mr16042177b3a.25.1756133895786;
        Mon, 25 Aug 2025 07:58:15 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.58.12
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:58:15 -0700 (PDT)
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
Date: Mon, 25 Aug 2025 22:57:15 +0800
Message-Id: <20250825145719.29455-13-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 03CA8180006
X-Stat-Signature: 4n85z8znyru9i6ia46p1jb9omsor9ugk
X-HE-Tag: 1756133896-296465
X-HE-Meta: U2FsdGVkX18OUEgJueuEt3f1QU0OhU+FcFnmp3WsQ9Z50lR8D5TLGXzC/DDfJRWaVhsfyVNluxpup4Nnkv/XkxNEW6Uaw9pt2S3odrCP0b3qC3RYT/Su33oA7R3s3AY2Ed4zjmK9NT+e+WTeIWKjOp/nBPwZ7XSrYWb2tABJUNIQexFaO0RriOAXV+LHolk9p9LOReIC5jKvC7n2dAaqutYmBVu0uEYGd8MZ9t0w/MDjSBKGQtQZTFKinV3898X+88fzZHgHIELM8g89t5liACxiF6y3hTRIZRZ4V5y6JdbVan/y2ef0xw9HiWwqzZUzw3sLEKoxBkjVKZ5pGxclG+oPhqeJyH2vhUN2zgFT92KR9ia2gIhH++STLYkjb8Q+nfJg1s9LtZL1Grvt/YwB4HbFJbNddiFyLc9BSTr59hGeHRRuvOtBoKvDfJBCkdWaWhu3stLdPX7Cm7qpLkBu28/LKzcp0J70ijWadce1d+CRieQDlhsQu26rZdqLSgCWiEsb93ktpqE5m0dSGHEze2zgRpao0HT9dlhSu1D9wEFjQukCZ+GXPch54BDkYcDZBZOoT4/hQFeDjrjotMDamk7XBj3m5Ci4kfNty1nwGbiF5uv3BPVy+fWs0bZxSKp99gYeGYdZREK8DZ5sIRoxbr+z7iOwm6N/a1z1peYn9+GT2fO3lwuHJ4kgphQe5ncvfHrjZA7gDXCD/Xf/tYVUZgikVmq9XiwUQYg+Ev99PHqXkhheZghLK9lIoAXWX4jCVKpM8Kz/KnPi935m/9yf6qYhhxUQitU9StioNcZBoRHGfalRtXHw8dR4JWmuxe6T2TAvk0T6FllgLwi+uOWBKd9gKOmNoWo11iDU1Vc8Grhbmiu7kUyBBhs4WKBiBSYSxrWCwuTDDqgkCVP8Nd2ENxJzazzgOgPWCQPE5UaFngrG/gzzCMXTjFT/zoZGIbDHUKxizLf5AsF97OHF69R
 ViKLIdgh
 LQ5YmXJSCxQdT73oy9vQku3Co+AbANPjwkG/9cuNu4JQ3n1X9Z4JJKnchdzUSMtdpiIwAf1giReUCRJV2aSZc8cOVmrvfOn4lUgR0+5IJNwbbt9VsPbqCxzPEQ8BNT/kfFxBPdYtEvPBFzU2t9bajNq4aB1m8Fe0gjZnEkYsm8iUq7BPjUcQY6WTnPglFWpfGCJcorEKmqcP33MjLMLywDzziqPQmEBPOz4k0ef3hH7sxNeRPcTE1tn4Uli1bRFQs2fh4F/yZ/z+LY7QbgXEGFu5i8hpqrVBDRQuwGGXXpMNucM0Opt9BjkwgjA==
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


