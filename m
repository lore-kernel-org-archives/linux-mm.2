Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 996B5CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:06:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28048E0010; Fri, 19 Sep 2025 09:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB1F68E0001; Fri, 19 Sep 2025 09:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA1978E0010; Fri, 19 Sep 2025 09:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C152F8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:06:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8E1E51DD6DE
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:57 +0000 (UTC)
X-FDA: 83906024874.15.D792A59
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9AD8E2001E
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:55 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FQ1LdzFZ;
	spf=pass (imf03.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5GkofW6KtUkwUdgZb+yZah5ECJQKBkU1k3qjUK5RSSQ=;
	b=cOoj0EK9d0HCN3jq95T6qvJIHyEspQjakkmcj2u3r4uE1iDKV9112DWIIm+dAIEtahfdiU
	2O5d6QiHYKR0/z8rdxmIeYa3HkCZn0VCIXu6hyyROJRD+geiWUETBRS6MuYlfGOAcF2bLF
	yRK+Q5FEr7bZJDpUVO9aLR4fgok5tBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287215; a=rsa-sha256;
	cv=none;
	b=Xq35o0G7PxQU7P3MCrqrMevSlNw01Ry324NFjAKO/4lMb8dYuRAGxpXeydPa0ojXRnVAKW
	7vw82pOV2rXVFNHC1w6PHOwwLUIvbHUJH4dGyq8soTEBtL5YfY7UpimVmniEToM0F++Low
	mjbBJMiyuc68BnJOAj16xrhTtWXowng=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=FQ1LdzFZ;
	spf=pass (imf03.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24456ce0b96so23955895ad.0
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758287214; x=1758892014; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5GkofW6KtUkwUdgZb+yZah5ECJQKBkU1k3qjUK5RSSQ=;
        b=FQ1LdzFZap4PPkqErPI3PHcelkDbgO7WIciBy2VNj6t1ce37SxWwneyw6T2EKTfu+W
         aqdMhSJC9UwpCYZ2FGici+mVbky6awzvCD9Q/o3pr01SRZkSCp4qJE8sQp7l7QiOVy+L
         cP05eVOJ6VQc+fRv1PzkL2NeKJ9Yf7lTaG82c4J1xmh5MMcKg7FrXGOv1HyBFG2PrUjV
         i/MO9av/f/xIz74VlkSejh0jlztPlyc7RAf+kLUYYCft6PJEh/NRKEcOI0iRjtj1Uivc
         k5LDtLbqaWPdJq0ASzYiAgzr8qqW+/o5Dwf03cHeNuLk6I9brsB21MYV9/FxQzYV6vEI
         N04Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287214; x=1758892014;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5GkofW6KtUkwUdgZb+yZah5ECJQKBkU1k3qjUK5RSSQ=;
        b=Sen77rPOgO4y2EQsQ2CbKQActu/LuBZRgL7stfMtZN5m7TJ9wEk6Ucu7+pXTt/nbpX
         LOIR0438Kby2VABZjr2gjadqeDWe/xLuu7G8XFNtxZ/pEVia/TXTIxWVCaUdPDL+Hnjp
         9yHP7zzmQOyEbDpo4o/i9hZ3OB7DKDcQo6E6jW+rAxvdeFIB1YDecnrITmwiBjwksNI8
         nkAMaMj0dnbcztByNH9Sm/dhsx4mrO3nvWom0pGo+xW6W3lV3e7bNuOwg/8vtVteHGke
         91vuKAyyYndvc0zZK/ZmdOAj/ZnA4bIA5RBVoniFjzcGsH3xNTw1rPmVbPHJV3E6hbZP
         U38A==
X-Forwarded-Encrypted: i=1; AJvYcCX3cxyZlny+D9kCNqnYBuuHcLEDMRlYY/ywYWWUf1D9IEA36mcuwarF49re/WyeaA8WGJxUCgFOnw==@kvack.org
X-Gm-Message-State: AOJu0YxRvzab7EKKTv1y8Aq3hED2aXjfxMze5Tls7IkcwmjQkt2D/DqH
	ueVot7eKvo/FA32SWVlSdAUMDADUe1eo8e/nQpjIIoUHA8p9EmpBwxBN7fteRz8oWwg=
X-Gm-Gg: ASbGnctpDE0oRgnosegILS+Uz6lsRJ5+X8BJm7NO7ljKIB4frmHLRZB3UirdPDBj1oJ
	yv6KGmhE0QGbVxu9wv49whFZWte261NYOa+wGI/YdQ4FWNLNHa+OecwZimULkC/dguslD9UHd0i
	brQVmwE9IWOv1XrjEgYFJgS4S5NNbGegPskjbCipUi11YKwThRAzRctRyKrkU0yjfKByhEGFIV3
	eSANa76aRHL+DAyt2e1uvY0zvw7X9MZEDsJjLPAaU8hEwfAVpzwt2are1gYLk+IbcmB7afJ8EWU
	5SQ+qeggCHiKLSsHTuYsMV7gD0KZt4yERNFUt9BwkdqfVua9bP/V2B5pq68JA8/23i5ykp7OEQK
	AK0tK8AYnNJanUd0KVsu5d2OpSyqVko2h8240aR55458q1Bc=
X-Google-Smtp-Source: AGHT+IHr5sMr/zdX7WDbCbAlnraq6nlmulLXz9ca/DHI8paZd8/0/Lo0LvgEROpUt8AfOZfHDDWsjg==
X-Received: by 2002:a17:902:cf01:b0:24c:e9de:ee11 with SMTP id d9443c01a7336-269b8ef73b0mr50156855ad.17.1758287214209;
        Fri, 19 Sep 2025 06:06:54 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000::d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802e00b3sm54732065ad.90.2025.09.19.06.06.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 06:06:53 -0700 (PDT)
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
Subject: [PATCH V2 7/8] mshare: selftests: Add test case to demostrate the swapping of mshare memory
Date: Fri, 19 Sep 2025 21:06:19 +0800
Message-Id: <20250919130620.56518-7-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250919130620.56518-1-linyongting@bytedance.com>
References: <20250919130620.56518-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9AD8E2001E
X-Stat-Signature: dpr5q8994phxw73be4t7339oytaytd6i
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758287215-656886
X-HE-Meta: U2FsdGVkX19izQlO0uIajhYIMJk/f2lrXnuxn85koE0KhRh75PnPBsy7iciHEKFZNoqv9NE/DyTHYJiE0e7afGWC0WnDNG5j7qFJ1ulfKcfuAT2WA9vTwcwT/zffenODXf6p8yHMU26H2J571C8z8N7xw7gqvQu08sMOUxaWnh+D2kl4CTt4l3eKypiqP34AiUvHNw7DWU5G0LNYRB7oRmetQQC8GVZZWUrFOUD3NCCCUF9lX9L5Y5G0EIrAawzxsq9m839yQ/i29YXLBzaO3VO6lTX/9cfIeTbzxwL59AKKuTKOzU3kZkB1TdkBNqTeyVLP7n5/9E4DKE/Ke6q59duUaLH5xbKe+5cnxcKfZjOKxOeZKuj6+XjUNKm539DfFf8PlfqgmNL4NrqdDWQuAeJTC1mkh0PG1K5Z0S6HouryqUuGL2iwkapL8+wUshXpZ+Cqwwsvgg/l3bGEFfBXY+mUNSTVYNm83sXhINDzrYR44Gboug06gDLOIUIWr1X6MbnXEKm4qolaIN2E3tckBlQR95FSJZvbsnJxudD3XHKXAqCR0kyu0fKWprQSm8SSaYTh0DnPGzX0KY+jKTFS/IS3IvQnryvJec/vCqxQ+sLLbq2sW3ytLzS1LTO02uCZ1xaSTRJDLIbWAJtKZ+DgInv753d4VIKGxgcaVZWhJfIUW4KliXLJ83YKYCobJNBzuzZgAeHNuZtM7Tb91vUKI/qOz7XchgUHLASqI8oLCILwHMFxWWAiY54Lc5ZrxypRD6TCznFSBMweq+7NWaDZ9svbNL0QlychbuxGwsflLOrY/he/7oaDfOzwk6js3tLfbL1Dd5tPxrRIxCbCIHTYPy8OEY6dtH/WlRBvxlFHPr8T9VyqYWFjXmM9uQsX/qep3XNpgaJT+OJCtVkgznZiFnum1fYGyCGsk3pD5T2+6nlbSOoQJFOaAtT18MGVNhoRlj255X3bJ2cHRWuFEM2
 edVQgwCq
 A+6dEZuDIx+HfKuLb0dqXE3dkvgVcGLJ3Qgzv9d08cCajt28Iu5jDywNDsesDXzsSXEBczReBm4XqHoxYfWBI7cbwF4IweOCEfQdqhmOgp6Qolcs+gGyDrhIB6xFm6qgfZ/7PAi5G3iimZ/VSk0ew4QR2qCfZvovs7pHQOD2W/iaw6DEETGeQ35qBZrihT+iHxghPuOxcCFzONwSFI0WDrgnnidD/RonpiWeRodFJqN6vHKRJ0z1X9DAdAyXdCs63CbFYyME6tP3RzP55S3CBJNpex/0xQqsuciRMJkPfd7Yb77GxKNgfpVucJ+eD3iV0f9qr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This case is quit simple by using madvise(MADV_PAGEOUT), but for verifying
the memory size of being swappd, we need to setup the memcg and attach test
process to this memcg before perform the test.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/.gitignore |  1 +
 tools/testing/selftests/mshare/Makefile   |  2 +-
 tools/testing/selftests/mshare/memory.c   | 71 +++++++++++++++++++++++
 3 files changed, 73 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/mshare/memory.c

diff --git a/tools/testing/selftests/mshare/.gitignore b/tools/testing/selftests/mshare/.gitignore
index 406f31bd432c..116774fa2b82 100644
--- a/tools/testing/selftests/mshare/.gitignore
+++ b/tools/testing/selftests/mshare/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 basic
+memory
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
index 000000000000..4bb0d22b9c03
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
+FIXTURE(memory)
+{
+	char filename[128];
+	int fd;
+
+	char cgroup[128];
+
+	void *addr;
+	size_t align_size;
+};
+
+FIXTURE_SETUP(memory)
+{
+	ASSERT_NE(create_mshare_test_cgroup(self->cgroup, sizeof(self->cgroup)), -1);
+
+	attach_to_cgroup(self->cgroup);
+
+	self->align_size = mshare_get_info();
+	self->fd = create_mshare_file(self->filename, sizeof(self->filename));
+	ASSERT_NE(self->fd, -1);
+	ASSERT_NE(ftruncate(self->fd, self->align_size), -1);
+
+	ASSERT_NE(mshare_ioctl_mapping(self->fd, MB(2),
+				MAP_ANONYMOUS | MAP_SHARED | MAP_FIXED),
+			-1);
+	self->addr = mmap(NULL, self->align_size, PROT_READ | PROT_WRITE,
+						MAP_SHARED, self->fd, 0);
+	ASSERT_NE(self->addr, MAP_FAILED);
+}
+
+FIXTURE_TEARDOWN(memory)
+{
+	ASSERT_NE(munmap(self->addr, self->align_size), -1);
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
+	/* fill physical memory */
+	memset(self->addr, 0x01, MB(2));
+
+	/* force to reclaim the memory of mshare */
+	ASSERT_NE(madvise(self->addr, MB(2), MADV_PAGEOUT), -1);
+
+	swap_size = read_swap_from_cgroup(self->cgroup);
+	ASSERT_NE(swap_size, -1);
+
+	/* convert to bytes */
+	swap_size *= 4096;
+
+	ksft_print_msg("Tip: Please configure swap space before running this test.\n");
+
+	/* allow an error of 10% */
+	ASSERT_GT(swap_size, MB(2) * 9 / 10);
+}
+
+TEST_HARNESS_MAIN
-- 
2.20.1


