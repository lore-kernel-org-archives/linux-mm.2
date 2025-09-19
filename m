Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C586BCAC5AC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 13:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2575D8E0011; Fri, 19 Sep 2025 09:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DFC18E0001; Fri, 19 Sep 2025 09:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8178E0011; Fri, 19 Sep 2025 09:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB44C8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 09:07:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B8BE9592F0
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:07:01 +0000 (UTC)
X-FDA: 83906025042.14.BBE9493
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1BDF18000B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 13:06:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TFq1fVYy;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758287219; a=rsa-sha256;
	cv=none;
	b=NWc+os7SZJhh+UAW1gZVB492Djc/M7L4ewEZ7OObrMIrYBiixh/vUlk+/CaOY2lWbDLO/Q
	nAcLPwF+tfIgUwmQdmP/+rYwBf+l5IM5Bt5BY1EloXTvQwp6gOh2/DjSGVecqhMXP8UK+e
	3wIUsf6Fw3WOK+stEWeHr05HSrBLJdA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TFq1fVYy;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf06.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=linyongting@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758287219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Urmko1apH8CcrUCNE6fCIsulid4np4tADfs+rqxRds4=;
	b=bY/sKYDcUPJwokH+6ufAcdENcNDgsO41fH9aX5o0O6O4ppaonPr7xE60fuGoWBwaFidwQD
	FuihxZBK3XjEdidEWuKB/atljg1lz7Z5MCPMTD4z8Nxdl4XpfBu1B3Y2JnDYSCOsKe7AW5
	OWkb9J5PzfKHm8NUva5MUBn3YVgN8Tg=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b5516ee0b0bso705829a12.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 06:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1758287218; x=1758892018; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Urmko1apH8CcrUCNE6fCIsulid4np4tADfs+rqxRds4=;
        b=TFq1fVYyZkBUnNvE+JliVqgrChv1AjLXgzyDT859enRqGff8q5ewKrefg9KzM4Ez09
         +CQUcxbPPrwtBq3wt/Az/yZwJ4QrILkxFPg7zZ0NSqKSYazt3RJoKpRZqLZpAgD8Wn72
         8928H0ymFXLsgnmvG5qanfm7aS5R2/5DwRa2U8hwCMGrEIzXhzEfPWxkUM90Lnu8xIej
         sm4+3z7fHEvtT70gTMDIZwfTS74/5/v25iTwKEJVr4uw969mBPYW91UX6Pds2p2GeYq4
         xTkgTWFFjHtd7e0OSGfyqvd2TfAOMEUIwf/IYezdEfd2SBvYdhc1a0Fv5IPQOJSqzt6o
         AiGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758287218; x=1758892018;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Urmko1apH8CcrUCNE6fCIsulid4np4tADfs+rqxRds4=;
        b=D18nbcv7GIoKjwa8oN1N+b8rAL0ub+hveKF1lz6kck8ykMu+yXB+ZS7xPz2cBW7Pl9
         xNzaE6gGbHXJ8/aC13FDZmSwl/SEomPRdZW3YBvqKvYUSn2+Iz54v69CnbA0Fq7Yd2Pg
         u8J2wsz/qe7dDnQsrWoRAzEQKjnOUNUKQz7k/kR6e/nFHTiNyR1bnZk10+NXEAoFbA7V
         e1kjYLUOl6JC4X6P6EBtmQZ1LhJmFCkMIFJA3snOAE/zwrDyMhzUSqynoXVuYiLoN0fg
         EgJuLFCqxNX3XYDoadzbcsb6vIlHYkiCftFupazLauBDX1pBPFlzYWZBv6eCFsAU0GHa
         yHtA==
X-Forwarded-Encrypted: i=1; AJvYcCXVg79t056uC3cemavBOd7JC1hzeGl/lLdM7jsgcdFmnHkhFo6a2RGwP3Mcmor6QWv6fL/uvdo5kA==@kvack.org
X-Gm-Message-State: AOJu0YyIqxQHdWMoiTxVj7u/bTn9tIpBAmaGTbH5sT7M5Wpd3dlTrynq
	JzYTknbLn1z+fY6e2wCXNseW9wrxg3WrCqWfEoOVY0FY2rNjlYWBEWCQVHntz6eLR3kod5cMPlZ
	To8Dd
X-Gm-Gg: ASbGncslfVMw+YbgC6MF6wtb3lRlIx79i7Cy0n7F/mJE38kvEUbf7NmIODoHbXVXuIH
	CcOXeJtyYLO4wuBO+jT+tNfBndi1UTJ+EOMCdrDLuHXQrHsSwptC51UbD6+W6pjC3hN8UG1x9EG
	eT4wOzgpLV6K3KNv2iQNKk4ZMBEQFCvY7vzF9bE2EhD4zype6QDHvZMs7j7hnSDeUt28GpWGEW+
	aY2qKYux2FPHjovDS1XRjYtK2jKgzXiXF9+O3p8xuL2Ci0+qve9B6rAv25qj2ACZiD4ulHLgwAK
	X2W8rqP5czmfHgVwoHi+ckl4JTB41tzgdjXmtRaE+z7YrIJy7g2oV3Gujp5Yz4essyxtdfnLjqn
	jmhxYGf/Yh1YmIATnPYU1EkLN2ilCOZ6wkwPvEugURG8gGQitgmHjpCgWHA==
X-Google-Smtp-Source: AGHT+IGQm2BwTZf4DiWqvF+5ZIqZW3gwljLzK2HSeWpzsuqCCgPkWpl1dn6miiJgWhzknn4pwOCtSg==
X-Received: by 2002:a17:903:17cf:b0:264:567b:dd92 with SMTP id d9443c01a7336-269ba55253fmr48189625ad.52.1758287218434;
        Fri, 19 Sep 2025 06:06:58 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000::d])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269802e00b3sm54732065ad.90.2025.09.19.06.06.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 19 Sep 2025 06:06:58 -0700 (PDT)
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
Subject: [PATCH V2 8/8] mshare: selftests: Add test case to demostrate that mshare partly supports THP
Date: Fri, 19 Sep 2025 21:06:20 +0800
Message-Id: <20250919130620.56518-8-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250919130620.56518-1-linyongting@bytedance.com>
References: <20250919130620.56518-1-linyongting@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C1BDF18000B
X-Stat-Signature: tzc3ogq11pobs9husncicgqasnpmyh6w
X-Rspam-User: 
X-HE-Tag: 1758287219-875013
X-HE-Meta: U2FsdGVkX19DcWPMj0q2sIQIaTdhUq3vGFB/uVgNguPA9h1HonaXViMzambM15YGMLzpBzRzXBawy5QDxHruZF/IZMEHRpibZmvex17NPHTiVGHpwOCYegKQzdZ0mL8h0Hx+UA1zp6wW+5l653TIo/8KtnGYnDpUEDMcW8bTPnfSHB05OOUr9UvvFwCiUzQIPI8w+nEpLOli0vq2yNRIB5ktYS4nblfcd7+XcvyAps4R5nvtfogdt+msNirzscHQ7vCKZJGi3Tl63HsFp1LLBq/N5Qu0zQEcJLGIqX5PjMjUwyqVZ5iEec8tIghScUIopxZ6SIHP7WfUanKePhMFX/1cVR7tYqAeGOI3p3BE4tR4CpOdy6tU/KNJH1hZx1imzx2pib7kom9F+iuNYAyotdceR4z9FUnIRyLqsSSpCTf3T12vEapRVA/1IGayBlvHtpVXArdekQSGQ6NLCpqDcW1LMDvQt3fQcXJDT0gE+UVhTcbWapwLgVZVJZKOc/RbJcFMnGCKpbYjxnNQdLt7Fwz70+nhmL6Yc28ae4YamKQ/L6DZpm7cp91X5gBD1IrR2p5OS5ojuC180k2NSZwwqHrof4jM2iu8TD0RYtC0FP01gP7c3GTdyinw1RVT66yHceNr6jeuuhDSdFmEmjxYtUEFNeVn1M7TDFUm5eKmUMyBECEKZk1pA0vhLLtk142kgcBbalVMpdFsCBkNaCeIF30Tk5wB+hRTnRvElY0TPfOH6VeBZ+j5MJKAG7cTeTxs4EwQz/Zs8dvxkHq7N6/A5x7iFNbN+k8krq1DE2qWE0mrLnLz+xXy/XTiohwcyyEm3j7k/4lWuM4K1bKgkrHF88GDg3Ltoxv4GtRhsYda+8pnVXNSrK+Sza+kHoRAwA+B+l2+CBzk0iQz9gIGOH/uRrULsHwczDu5rfXjERQvF0g8T3U5nlHB29suD9Pzz4JF5HR7bEbBnKmHe6FMLC7
 LUIIsgx2
 IeUQcjY3L/kSqQpaUcNjEA7G4iOas9QSI67GvOkzONpzW5og2RWbWsQ1D1u5Xe1w5U1ggFLlxSnVgOCP7u8jpYFqV+YwcvLOhQMkIebfpfhm6H/IaXxA/JMjllifPf3xDJsX5eac0HmCcxNpJci3b7EdHGtSrq+hQkhvL5iemmbtTV4FFGBhUaxcT7O2shDFXcp0NGIAYcvpSvi95L4h63CquvXy/VC057w4ub0yBiL6nmmQqxFa68d2zZ1Ptvi+hoqO4qKFtLftAcR0I321g8TvsHD5pZHRKAXI8lhd4FAeBUETO65Kjekt8YaxXg+OS+5lM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, mshare doesn't support madvise(MADV_HUGEPAGE) to make pages
become THP page.

Thus we need to set /sys/kernel/mm/transparent_hugepage/shmem_enabled
to 'always', enabling mshare to acquire THP pages in a best effort way.

This case is quit simple that set up a mshare memory with 2MB size,
than use memset to fill the physical memory and verify whether THP
was allocated by reading memory.stat.

Signed-off-by: Yongting Lin <linyongting@bytedance.com>
---
 tools/testing/selftests/mshare/memory.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/selftests/mshare/memory.c b/tools/testing/selftests/mshare/memory.c
index 4bb0d22b9c03..5132210b1465 100644
--- a/tools/testing/selftests/mshare/memory.c
+++ b/tools/testing/selftests/mshare/memory.c
@@ -68,4 +68,22 @@ TEST_F(memory, swap)
 	ASSERT_GT(swap_size, MB(2) * 9 / 10);
 }
 
+TEST_F(memory, thp)
+{
+	/* fill physical memory */
+	memset(self->addr, 0x01, MB(2));
+
+	size_t huge = read_huge_from_cgroup(self->cgroup);
+
+	/*
+	 * mshare only allocate in the best effort way, and
+	 * don't support madvise(MADV_HUGEPAGE) to change pages
+	 * into THP or khuged to replace pages with THP.
+	 */
+	ksft_print_msg("Tip: Please enable transparent hugepages for shmem before running this test.\n"
+			"For example: echo always > /sys/kernel/mm/transparent_hugepage/shmem_enabled\n");
+
+	ASSERT_GE(huge, MB(2));
+}
+
 TEST_HARNESS_MAIN
-- 
2.20.1


