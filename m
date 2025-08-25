Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78AC5CA0FE7
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 14:58:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFC378E0001; Mon, 25 Aug 2025 10:58:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAD8A8E0038; Mon, 25 Aug 2025 10:58:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99AE8E0001; Mon, 25 Aug 2025 10:58:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9140E8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 10:58:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E67058FC3
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:07 +0000 (UTC)
X-FDA: 83815585014.28.B79F43E
Received: from mail-pg1-f194.google.com (mail-pg1-f194.google.com [209.85.215.194])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7BBC280008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 14:58:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="B/TKKkg+";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756133885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SS8UElWYPBKNDeTRQOyijx7AjeTpgm/xr/2yY07TeYU=;
	b=y6KOWbJZ1lJ9ytHieQ9RlGj1OCRoUzeU7Tw/9YF5XlGJ6xgxWJaaC5q4grXi/kBws4JVmQ
	RxiGLXvhVPg2UYrIB93cYq4zJ2KxmPuc/MGnb46owaePbkyeEsK2fmfU3UfV/GRAkLp3+b
	heeKIN8fwQmVwyuwz33/P4GwUQQJ7Fc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="B/TKKkg+";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf30.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.215.194 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756133885; a=rsa-sha256;
	cv=none;
	b=S+aXodJ19yIJykX+gUqfQpmiq7Hvdx80KkbdOibjnImaKJP5l4wzin//z9521medWC8fd1
	LH0Om3wwtBJ9iu9MU1LORllNFdeDFc1RHeW4mvcJ1a4lcU2I4fwknKwvKP9U9xE92M2Tun
	RYvTQtjF1iauaNCIeqLFsLWJhNPKckw=
Received: by mail-pg1-f194.google.com with SMTP id 41be03b00d2f7-b49c1c130c9so2194126a12.0
        for <linux-mm@kvack.org>; Mon, 25 Aug 2025 07:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1756133884; x=1756738684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SS8UElWYPBKNDeTRQOyijx7AjeTpgm/xr/2yY07TeYU=;
        b=B/TKKkg+3qYZMTl5ymQC7jai5mDBii7Hzt8i0hHDz4eIZnvF58/hDtQ94Gpoep/t4/
         Ro5BvOYcY1LSLsk0m8ZpKEb9GYfYI6XSTNj3KOuOGswCGe9izafYdiqVjR5KW1adCYuo
         9zIHSWY35Xzpzeo6YIFfiRLVq9hAc63+3fx8gKXxfbPHGeSZ+h0x4nbJFzIzYce2Dpew
         wQF9owiZH0dHh9cXlxe4Hsvfutw8co8fKgykuZBNNJWBrmG9rcBXRerAboCcb+oJ+LrU
         hTtV6RjMza66vUEX6K6Sj3rP87Crb/yp7id45vwHT3KrB/Do7asvb81Q6PoIVc5D2wa6
         E/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756133884; x=1756738684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SS8UElWYPBKNDeTRQOyijx7AjeTpgm/xr/2yY07TeYU=;
        b=QLvFaha8cUstbpo609KaI5KtMpkhedEW3V2nQSWaeUCabZS2AuIm9VsHbZBJgBXgrL
         pVVA59BiSg3/YsU0+HTRSN8PAzLk300zuevJNfbZO8M9XUV3QB/JCulO/ESestxtHafm
         f4j4GlsMZtRWAxPrtj/5L4w/B0hg5kfpQTt6IOHc+eRbNB/BAe0d4JJn8AADL71iTKs3
         o2KLuh83cZ8a35rzgSPNquTeHScC9W4ihTQ6WKlVQkFrvTVxNO7nHqz7AS2SXaQ+LUoP
         wC0nXI7r4cZ3CdSe42vh6pmoghNQUKRZ1NQokLxhi+RSyH3j+rxtSlfDx2Dku6B9afv+
         FHLg==
X-Forwarded-Encrypted: i=1; AJvYcCX50m/fzf3Wl6mvufihLo/YUMwbsGho5Y1PdgBs3zn/8ttj0ZdYyZStWPn7+JAETb36X8jkOVRnnQ==@kvack.org
X-Gm-Message-State: AOJu0YzMLeGhjLee+VUeV0frtbtxkhXG+VdVPY7tVHs7vEv+nsSOG8At
	5AvMSOzISuQ3E4H13cHuLUTdP8T+/2O1YNokHX5Oeugf49TME8ELAYu4CBBYfL6FLK4=
X-Gm-Gg: ASbGnctoleUhTY1/1aCSJ3NjOLPKWu7fjGvCcGFHS7iZ1AS+qbaDzzVcBWzMZVRE7XH
	kRmLr6lL98wCw91MrhTKVYPq4z3ihpUJl+I3bJpMNqsgkGwoR8YOun9J6qi5S6tJc/kcaN6uipE
	qcAatJhmF9EHjIX5Nw23BF5Wz2ZK8VH3Jf2ZGtfhPRtzIkgJ86/RY/ly+GxA2s1DCOhYGusaFrV
	aUwl1eip6Pj1HGRaCJBQ64YWAYZPuUbzjUXLz4msp2maIQRK4OfNBTMx+msjs38edht9xSzfa+H
	qHl4M/LfVXCWoNUOS9rgLC/2cqqYWz1hS/6eO0+g23TMq6fzFiVxnknchf+e+Id/4oP0+MithX/
	nt1Gx7y+SHH6LB51Ia7U8dYXLHBTblxLYYVe9TJNBnRTL1cE/UbBBC/wqliyI
X-Google-Smtp-Source: AGHT+IHCWW/ShQpQHuPFTA6y+zNShKRdJnkteX326IPoMfo05QiaIWxdBNx+Yt2H9gYmCzshpIHnBQ==
X-Received: by 2002:a17:90a:d60d:b0:31e:3d06:739c with SMTP id 98e67ed59e1d1-32517d1988fmr15265101a91.31.1756133884241;
        Mon, 25 Aug 2025 07:58:04 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([203.208.189.7])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-770401b190asm7803436b3a.74.2025.08.25.07.58.00
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 Aug 2025 07:58:03 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com,
	khalid@kernel.org,
	shuah@kernel.org,
	linyongting@bytedance.com
Cc: linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org
Subject: [PATCH 1/8] mshare: Add selftests
Date: Mon, 25 Aug 2025 22:57:12 +0800
Message-Id: <20250825145719.29455-10-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250825145719.29455-1-linyongting@bytedance.com>
References: <20250825145719.29455-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7BBC280008
X-Stat-Signature: c7taa9errs4ozypkabj5cqnnbsi3btxt
X-Rspam-User: 
X-HE-Tag: 1756133885-223248
X-HE-Meta: U2FsdGVkX1+BPXwb6DPuLHTOPNeNzHaOKD25Or/nrCdX7LyLlwIbRPbjmU81GjDlpk3IGtdSzQ9iCVNNVZgUCjZyzxElnYLwGAtFqtoUMFwvg/nWCXt6weIht3Wp60uAS7TsQbjyNk0okB7BysNnXHhr98gD1R70DJTXwld83Te2yMViU9qhqy+SNlcA42KYCfiNxJfL+SFo1KQgOClP5iYrX6KEddXDq5oTCUFIh1htnxpFiG7kDD7vd8aXJ73uY6HgllCbu9WX8xR1XQ1PrIM/PLd3mTt0YCch0JWHaCgk3p0D1POHXp3pOTpPv2u24FHKeqGqwGmLYBAb6T5lV9TUzNFaVu1A0TFFZXqBKfP5wYOcLZBNCOiW/PQ5IyLd6u8Epws9dE8DUrxqHJu4A3XY7S8UkmaiW265wCRM1AIYyWluOcPD1ARsc6qb8rINI4yJTwrL4Mch6PlXoam75FtqHIonyO4V+DmWxjua1nL0uiOj60AEQSQJw+dOMOLvY5Z6fgDJj9AXlsUbz8wJsAPCkTeApxkmwFs4++Zed69HeWY8gUlG6/jVECQwsuZ/PxSWq7dp/jmUPTRQEe8Be8F6NLNh62l4ka3M2kn1MnR8mmOJZlUbs6I0nDbLPPDR7fA+RtjOfPSIecDW1rGeMcU+GB5w2o4FKK4YYDCT0mjKXPiXPzUl3MUcW5udj2epQ78RYUbdNn5iZ3BBL2PztSOgYVGMWoGDc8AcPpYW90N2WY06QAMA71WYOfmR2h2bv9LPrnLQlkKejYU+tAwGk7IC/DxcBajGr5TGByFuQTVfEcK0Iulmcx9sdo6JlTb+6T4nJ93Ibr3Of9j2QaIFqLeN1vQk6Lkt6ULaJQWo9HAnSJSRzlTvmIbJkr6MedTPuklDbWcY/ig0PQOEmfCvhBiClwtv2pJ7fH+kXtkU4iFVx6Uae06JevG61pBGOcQVzZwGrw8RWxqlkIA6Vpk
 aO1XAm9p
 Mgh9Vi31lbssrgrs2e0Nhc0pXMsZxdALh7888Szzf/PTywCFoH8iRa5qh8ATE6I5wSfWY2zA4t9Uilc/CTDJxsJKRM2V8ASVN8AUo1dVuUE+dLAwk9D0raFaXvZSepD/oj24+xqNUQXoCLJXZ1lze+EbK+BmTi8y9ljkfwcH+bAXz2vnQ3wagE+wXWCVKc440qCGyhZqoROqa2Vtvs21bV6RVSthSIxykbHNw0OL7gO2lVMZfH+q0M6TwJOacpUy81+f2cPrPCtQuZbbr5tqa+zyBvblAC9+9c2cRDNJUpJ5blw06Du3lUdljQ1F9IlWeOKrim9jqzA/wBi/3caUf8qMW6InPWXtM9z3zifgclvp11+jaWd/6g5FkiMme5P8JyjiDPI5HWlNnu3jFSiDqKmC61A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.032468, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch sets up the selftests project for mshare and add a
'hello world' to project.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/.gitignore |  3 +++
 tools/testing/selftests/mshare/Makefile   |  7 +++++++
 tools/testing/selftests/mshare/basic.c    | 10 ++++++++++
 3 files changed, 20 insertions(+)
 create mode 100644 tools/testing/selftests/mshare/.gitignore
 create mode 100644 tools/testing/selftests/mshare/Makefile
 create mode 100644 tools/testing/selftests/mshare/basic.c

diff --git a/tools/testing/selftests/mshare/.gitignore b/tools/testing/selftests/mshare/.gitignore
new file mode 100644
index 000000000000..406f31bd432c
--- /dev/null
+++ b/tools/testing/selftests/mshare/.gitignore
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+
+basic
diff --git a/tools/testing/selftests/mshare/Makefile b/tools/testing/selftests/mshare/Makefile
new file mode 100644
index 000000000000..651658d091c5
--- /dev/null
+++ b/tools/testing/selftests/mshare/Makefile
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+CFLAGS = $(KHDR_INCLUDES) -Wall -g -O2
+
+TEST_GEN_PROGS := basic
+
+include ../lib.mk
diff --git a/tools/testing/selftests/mshare/basic.c b/tools/testing/selftests/mshare/basic.c
new file mode 100644
index 000000000000..482af948878d
--- /dev/null
+++ b/tools/testing/selftests/mshare/basic.c
@@ -0,0 +1,10 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include "../kselftest_harness.h"
+
+TEST(basic)
+{
+	printf("Hello mshare\n");
+}
+
+TEST_HARNESS_MAIN
-- 
2.20.1


