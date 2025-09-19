Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA955CAC59A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A8A18E000A; Fri, 19 Sep 2025 09:06:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 059948E0001; Fri, 19 Sep 2025 09:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8A6B8E000A; Fri, 19 Sep 2025 09:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF2B88E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:06:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 75EA5160273
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:36 +0000 (UTC)
X-FDA: 83906023992.13.1E6F248
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf07.hostedemail.com (Postfix) with ESMTP id A98F64000F
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fqAQOuVh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287194; a=rsa-sha256;
	cv=none;
	b=n1yilLRjpqDT7FX/KK+8KuniitPxcaD6hcaPhNkgE23/ks9PTZfaxENQdJpfVzU9xgCPOj
	z9mzZ62QzmH1hgM5IfwUQT2SvAdVuUyHq4lEczEi+KzFwPDbUT6rJYGE2IWMzOMf8TcZ3r
	I7pRjiFCsdhw4/v3IjFWtm3DKhprOVc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=fqAQOuVh;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QM3z2LyJW+bazyfIUJsU26vcVsKZ5Gd2BUVcAs3sFgA=;
	b=agWvNtBmci8AnP6Q3qN6FefxVH6Vvk67QnpMdaNleSRqkzSLDSYB7UnwOk4hl1I/a+oygP
	YGl4nhdCfPqS1oDUijE5cq8fGdcylbpW1NMG1OMSKwOkdMqTzZmmYievyMpJhb+uIHXqiz
	aa0l0gRuQYKh1lX6BstBuiPCcZUKh74=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-26799bf6a2eso21627835ad.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758287193; x=1758891993; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QM3z2LyJW+bazyfIUJsU26vcVsKZ5Gd2BUVcAs3sFgA=;
        b=fqAQOuVhhRCcU2b5y9+tLkt6U7WoGcw1uQ8andFgO5Tq8OD2RHL2anZom8l6IIy4ZD
         +3vco/kk3IkeEZ+suM+ezNKjbn1YVjJg+hl+PeIHem39VGUEw0fg5278kuKdgABONnup
         +rcWT87WgJ5Qn8svpfmRMqBkCgNVz8Var3bIB51PFUpwQ5nE3naWV3t+5iLT7FEZxFp0
         RYia9DSoKeYh3gxrDFiWCnrQpz8NeqDu88+qZnwvIFUhzXSrmD89YeiwXhabWbbmWCrZ
         Y22pUfBzMoj18+XpMH0k2bYL67PDJvu4VUAv8Bvs8hD6a1MSwfLOsVA0X7TbbvK8KmLV
         VYgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287193; x=1758891993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QM3z2LyJW+bazyfIUJsU26vcVsKZ5Gd2BUVcAs3sFgA=;
        b=MBFfgUSwxIFZ3iBYKO9rz4lUt3zh5aT2Vi4QLjqQHFQpBeR7/Kw6944o2QCOuh3fRF
         h/dgsPNnt/nlT3snnvT3hFX271SwAhwGrxTnr8V58k1m3ck0a0QJSmwb7o35Rpa/MNrn
         VkxOcR6wnReF72M4EVrP+6/Z6sfAzRIBmdcCJVPfZhpkYhmAIWdueazAreCDmedKCZ1N
         ZV7KZXDNlmPgRz/E3UgYMEhhJPwWbGO++LRSyzbtQiFxM2vFm1NCSHkfXXdAX6Tilp3H
         HnDClsig1Le6psW3AJsTJYfd4tmFQ9Oi9YO6CpiePtQWLVQA9xufvnWoKW/2Lel5tD99
         PRuw==
X-Forwarded-Encrypted: i=1; AJvYcCV7j6go2ifAPELk4GGlGp0gUUadf75c6w8iPAGYHKpk/8CQWJaoktYM3fzLV72Ir7FiX4LLk3WqHA==@kvack.org
X-Gm-Message-State: AOJu0Yy8ArLfiWzFNtIMjPZtDY/FCNOYIONYUjn5Ual6vU9fmW1oECYw
	5jzel4Ni+HgEUxCmijkrT47KxWVTATZ5ZL9ramX6fEnGKAu3lE64HhLBtkIE0lXhgZI=
X-Gm-Gg: ASbGncsn/KAGD4cypksccJovGp4p2RHGENnn5IHQ00R34XQpqbbtkYJ17Qyn1kFlkTV
	cOADabMyBFjk5ETMDMp3OKe9sqy3jQ/MwXCaOrcoUE8z2WzEtPwGnieC528Hq51lvgNWBaHZLUS
	VUV9ATNdAz4b2aJ13xHT5bajQVdtKJYiX002tD+gUB7m5/Rz4KtiVXX276ty5ndMERLcZqi6XST
	e0KYstiMs1oQpVq+eIGp9XHhCzgM7QBaKcV6zMGi2hAK23FpSc1klpeJAdzPHDArrIT5Nj2Bp1g
	/7Cb/fgkFIs2351T6r82p7nRh/oQhMiazo6qHw4jBr5tYote6sszB2ERKWE/HwPWnRCBNPKwqTh
	R654ItpwTrHtAfoD0Xdp3ReA5z/QXHVy0UqYZtxDQ+75CXYs=
X-Google-Smtp-Source: AGHT+IGbrf3KBw1E9vOkt5rEaC3g4HQJ3sGafywJShI64TnAWeeXbrI8TdW5u7TwWDUuix9UTIPH4w==
X-Received: by 2002:a17:903:3c2f:b0:235:e8da:8d1 with SMTP id d9443c01a7336-269ba40e0ebmr37928995ad.8.1758287193223;
        Fri, 19 Sep 2025 06:06:33 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000::d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802e00b3sm54732065ad.90.2025.09.19.06.06.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 06:06:32 -0700 (PDT)
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
Subject: [PATCH V2 1/8] mshare: Add selftests
Date: Fri, 19 Sep 2025 21:06:14 +0800
Message-Id: <20250919130620.56518-2-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250919130620.56518-1-linyongting@bytedance.com>
References: <20250919130620.56518-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A98F64000F
X-Stat-Signature: 6ny6p4hw7pfb6fsb35ywnfatsfgd5647
X-Rspam-User: 
X-HE-Tag: 1758287194-269122
X-HE-Meta: U2FsdGVkX1+7NsVRHe/eN4u9Mlmvzhcm+EAoFzmVaXr7FHbpbBP1dVJVSxGaSFI8HMBI1v9Ffe2kiZAFDax0/Wy0jcU9iaB65QKcubawBU+sPOROmxSf2ilVj43vzk5QVvfb3DPWjP0psckdUdGZRnoL7+hnn/q0RcrGcgxccmiGUPXjvqk2Qeh6QxpowNbqUxp7kodSVMz7xkSSVL4GKsxOcL8zUAv8BoLtegn+YQpXCUtA5vwbDmL0eN732BJHXzJvZQtHwdPBtpzb8+iHVrtfcf9Jxyb66eZDqTEZ6Kjs4kb1+YhjdbHMoHC6C7hfbW2+lOwtwNmS8yFj9ydmZrvce1/EoE39gHTH0h2EsZxi8GdbdClsUuf2nAGvJgE6ibXrBCgGtrMEe1WHK14cNYqZuxNt54oRi9s/iBJB/W8pRUpGvK953feSbb2iQ3ELSXfx1yawSXdup1kEkZtC94IrScDqoeJnjnDnRP9ZCCwo5WKO4m7dh0qP8f29jZHcGEPvUYRRzhiAFAtX4fyJDiCQVJn57C39GZSeU/cONYBv6CNKIWSJuiqs05YssVF8jf4WY8S1itY6n30vwsXnVQuZWXAU8HsGifyh/p2PQ9WV5UuSrCOczT5P9Mu5iYrmXatR71i5WJ8PBa1uZNADsT+RIuP7SWrXgg+cLr3/PzNSJsiSj9eslVjrSl9cR1nU3fQRxchdGG87eAtFQ3uc77u296ShRvM9QdQP4/EOK7qGaRHz34FTiFAX9aHcwspA7+sS60LvPfR1p2Sd2GXPY7wTdI8GCcmKKFcdk5AP6rAdKh+cWSJ91MSq9xCh75pF4DYgK0C0tfjbSDzndVqGkR0RR3zY6DAiY8Gvh8J5lgQCcXTyWH0prMuEsgBIwKgNPgyAXH9+vFCLYUC69NYzzsxuxiNdKw2rX1EzEeyu2S47bYUJedjggDlfjNiAdpmit+Ejec4ciHtIC4FU6x9
 XhkxnXmP
 w0iWgsGNXkG684vslaEQjiTt8Fe9hby7E9XAr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch setup the selftests project for mshare and add a
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


