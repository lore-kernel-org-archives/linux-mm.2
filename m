Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EB9ECA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7915B6B0005; Thu, 28 Aug 2025 03:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 741FA8E0001; Thu, 28 Aug 2025 03:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6306F6B0089; Thu, 28 Aug 2025 03:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BCA66B0005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:34:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9BEE13A4FD
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:11 +0000 (UTC)
X-FDA: 83825352702.16.E5082C1
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id EF9C4180007
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:34:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aPsAFc7L;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=j+wvbIZSOArG9eklWNCAJ/EwS6c50oTh0cISY2nYyU4=;
	b=KH4loShlbnHrr3xFv8vtazaFKB2vRc+tNxVa3Jvin61x/tGnglVUPd0R+evABY/GPyIJKA
	bvS5JLdKnn1aUWaHrWS1xNI4Fdi5+XfanZp92MSxYxlQKSnNiunN6j9+cvExg4kZkcyXkz
	sGHCEfXI3tbrjkV3zfq+n0aasmJ3588=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aPsAFc7L;
	spf=pass (imf06.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366450; a=rsa-sha256;
	cv=none;
	b=fXfYaYxdvyTG5XhMeQk57gvJBwbGbGFZsFBGSpdOhzgz6jtQkjeCFGunKj2+oKxP/JTD/3
	siilgC/MmUZNPB0SVI9aHbet2est4oICKzyrKGL0mAW7FnpifbzKoAXtqp/KjnlT3ONyaK
	g12Ea3gX4Uq2U3ZYFK35BZ/Qge8X/6A=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7720c7cbcabso486363b3a.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366449; x=1756971249; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=j+wvbIZSOArG9eklWNCAJ/EwS6c50oTh0cISY2nYyU4=;
        b=aPsAFc7Lt5EyXRsdXuxJL7uH/quGrB280U4ZNfo6OJgkZKDay+reGwNgGNCyE+rbAa
         XWwKWQJB4lnkiWlDWyjLY0ekd0s20kMtPfmoxwXyaEw4PVFStsBZuxbVkGka9h9zOZdc
         RfXad6FyQPW1zIM9VBnDT9bknpmoQGpQmn0c7VrwQAGi3/Ag97bCFRP2i5/xEsH2DORo
         3RZdJKi6yMZKVPFfE0/+XuZL8XlDTZ6ZiTA2g2oWkFEHgAZyXMDFXCSK4kSUgTAObtcG
         uhKEk1jpJwXQKXM5qHBwk1OuqguBetATrfO5cX80aXCPH0L3x6juJ39T2ehl0HjVbn6M
         ZUZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366449; x=1756971249;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j+wvbIZSOArG9eklWNCAJ/EwS6c50oTh0cISY2nYyU4=;
        b=FljhtNSafTC2KmZ36pXovXcSFUR2C7/An8OBgFFUqozNUTwgl4epmdgxXB60xiwZyk
         hoOZuKKajTuiiG+toZCBUOlTC3t3PkRIwhW46rLouKfEwKSPYz1XKEY/81jO7GBVEOSa
         JPfEOc7Bt9OLBSFEhHmqqV546spaFmd1PqtUT/2RJ9toha4CSMHTwFEqhU5EmzRPtgOr
         Ke+5418MMeEOa9kmPTdWa8pAXduENWC5ir5QWYfBmAfodQ8nspeFoceiPUJwIh8OVzPA
         1SyQBLU1k2FZD6bx9TZXRErNlDq0xnKhTBAQDGTCCP3PjJIh8b9aWxjZpkmniQmLtGPP
         z5dg==
X-Forwarded-Encrypted: i=1; AJvYcCWg313gbT+S5ENsdyQw2LzuTJvNPPWPcim0BIKVEnGIPPzUy3GvSnrly+knMJevm745Ex90Lh3ILA==@kvack.org
X-Gm-Message-State: AOJu0YwTgIPDQZ7Wl8ILNN+k6aLkJ/p6GSMN0X5Mu4wjGepXIu6OBIGt
	bimlUYz+E9VZDGJm6p74tXCiT03IGDLk2l0uAFQTkoxn9dG8IWfLqZUT
X-Gm-Gg: ASbGncveEMAyMi60B2ANj5RzuDsvgNDeywWvckW4Pr8gMJCeSjl5g32kQ9G48e/ThXq
	75RfvbghFlbm69+KnwtqZb7qlVew+JXoJn/8PQdqom7rTHG5JCeESl9s8vWuawMkyx5HiOn7NLA
	GiL17A1jwvOJxNk4F2PzMKk7CufAVbX2A/pwwnxFUxzblUG0YFy0s01wajKup8y3gDJ0U8xElq4
	dY+1nRpdcVX9ZP3noiUYhGyyDcf3zTdaCwAtvtFUAZqvXm/b6CKxBLhCFXzunTqT1iwGnBGYasE
	1eVfNcPbyVHg3tZGgZJjj4jQLWieowrWYmtek6+ejBjOyc4V0m232L2gZIOH/Cp6/aTHjxgJSJx
	3UYfNE6vw0Bqry1Ns9anREb2g7AJLp77/shu4XGL+KPpDWmIGQA==
X-Google-Smtp-Source: AGHT+IE0Bj834whDXotueWX71WpNaH0hF1RPeXxQmdcXuHEqPvv59XyUYnfM+JaBPoGK6bm6cgZ0lA==
X-Received: by 2002:a05:6a20:7d9a:b0:234:3932:2958 with SMTP id adf61e73a8af0-24340c47a88mr31770311637.20.1756366448736;
        Thu, 28 Aug 2025 00:34:08 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:34:08 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 00/17] mm/ksw: Introduce real-time Kernel Stack Watch debugging tool
Date: Thu, 28 Aug 2025 15:32:33 +0800
Message-ID: <20250828073311.1116593-1-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EF9C4180007
X-Rspam-User: 
X-Stat-Signature: pxrp3g1ds43d7he34hqos96kucosg3jt
X-Rspamd-Server: rspam09
X-HE-Tag: 1756366449-539271
X-HE-Meta: U2FsdGVkX18X6T5w6wtwHSuN4wSr5EWVO8/bsd3mVmvm2jdH8Rmj5aIb9CO5fIZveLGFpP52dhLot/jWTnEpy5QsIE0XUs1jcbzszIs9YK8DUcTGS3nRrpZbYTOeDHa/2XL3Og1tluv933Fw7sV/VjzgGXTO3s7CMTgAjeKR1yiUiCI/+7yb1ljpUSo+a6UQW97ScPqeniZbU6ZYWspHOR6lF0feQmr2N1vlLhkX/ViHYwhEyAxSQUBT/D/kb6FBqBCzFFRzYACwVYpyNTzd+IY4/cLa1PzO6TWsjiyvCnV6t1FvYt9sJB0/YVsxX21nzzCyu8/5QT4pxkF7KphJ5GmoO/BCpLhHXuvGqMEq+Ob4j4GS39lJXuY5hh5GSXe7xQVudm1XB3aL9gtwgmEW8Zk/QtsgJHrGyC7kpWQMQSQcu+G12AV9zAK5a329Xo/D/p0jndjwi5wwPpB4A113vdP5hbY5ckaBr0SruFgSTChz4u+IvAl0POhOF7+Xsiv2dJCGVXFfVw+GzYp+YjmX6bQkF1iXjTDXa/8VDHn30klWm5YuVYC1zdWzVN9PaPAvhZ0mxbw1Glb0TXt9saMSlxNnBocSyBfcbkaZv+9WncgFf7lUUQB5qLvXptVbbfBNpczgXmw8w91UTv+RbaO4r7kiDCbNtSf2Sro2xRsbdIXyN66BcASPx6KViBuhL4oppZkL0fIX2M3pm0aFs6Z+QH1V5Jf6698tKuV2SAZnzMN1Cq6GzR/5e6Ymxgr52f5n0eKaYw//lYZsgxMrcasxj804q61BoNpztGl/iRym3jDSsdl8zSd7eropcUCbrULnkRxsgmkJnqUIFGf6QhEK2khKv7Bav4FBomtSkgDKE1vJciMGylxVMqVic+brE9PnEfFUFarU95M5vBoPGd0/E2fKMYtzw6020LA3qMP58E0FbmPA4DtMhrXdtg9FfsNPh09YUyoIcnId8LD0WCj
 t0fa7PtW
 5Qf4C+Pb8AZcSq17Vz3fuXakn8KiJFnDng9z8486TMcgY4cFltnnkklw4/ttre0y2pDZHO/ctI8ilTyuNB8dKExbi8VqGdVsF2hYr9Qom/mMboaFLrFOhg3MhtOsN2UNHqJF4NEM1npYkc0FVm+OHMCJmBBtgQydb/RA7FCQcMJ3QvP98QGZBBTiIhCaoSB6iBns7bwciGwhNfyvXXhOApP39OEBHTovRCz0+c1sx3ixirMjwnGB8nkzHbt2I2uVQc9iRZQrK7iJJAJ5sYzy5Vu1g7m2iL5OQpwKocPZhPxCR1ZPd8KbpQH0CWixTbgL2sNj8tjSpZ/ax0LwhboiY7ifP0dGrD25fTKwBcpkcfCAEnR3k7qB91QPi9NGNnuIKSTtyEx45bVKqEc/1F0C+AHxyC+/7+ezp+3SXwO8fKOscgLSI1j7Vda5zhJuvu1nB+WywS4KCmJGCQWJKBoPYBh0lYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces **KStackWatch**, a lightweight kernel debugging tool 
for detecting kernel stack corruption in real time.

The motivation comes from scenarios where corruption occurs silently in one function 
but manifests later as a crash in another. Using KASAN may not reproduce the issue due
to its heavy overhead. with no direct call trace linking the two. Such bugs are often
extremely hard to debug with existing tools.
I demonstrate this scenario in **test2 (silent corruption test)**.

KStackWatch works by combining a hardware breakpoint with kprobe and fprobe.
It can watch a stack canary or a selected local variable and detects the moment the 
corruption actually occurs. This allows developers to pinpoint the real source rather 
than only observing the final crash.

Key features include:

  - Lightweight overhead with minimal impact on bug reproducibility  
  - Real-time detection of stack corruption  
  - Simple configuration through `/proc/kstackwatch`  
  - Support for recursive depth filter  

To validate the approach, the patch includes a test module and a test script.

---
This series builds on the previously proposed RFC[1] and incorporates feedback. The
changes are as follows:

Core Implementation

  *   Replaced kretprobe with fprobe for function exit hooking, as suggested
      by Masami Hiramatsu.
  *   Introduced per-task depth logic to track recursion across scheduling
  *   Removed the use of workqueue for a more efficient corruption check
  *   Reordered patches for better logical flow
  *   Simplified and improved commit messages throughout the series
  *   Removed initial archcheck which should be improved later


Testing and Architecture

  *   Replaced the multiple-thread test with silent corruption test
  *   Split self-tests into a separate patch to improve clarity.

Maintenance
  *   Added a new entry for KStackWatch to the MAINTAINERS file.

[1] https://lore.kernel.org/lkml/20250818122720.434981-1-wangjinchao600@gmail.com/
---

The series is structured as follows:
Jinchao Wang (17):
  mm/ksw: add build system support
  mm/ksw: add ksw_config struct and parser
  mm/ksw: add /proc/kstackwatch interface
  mm/ksw: add HWBP pre-allocation support
  x86/HWBP: introduce arch_reinstall_hw_breakpoint() for atomic context
  mm/ksw: add atomic watch on/off operations
  mm/ksw: add stack probe support
  mm/ksw: implement stack canary and local var resolution logic
  mm/ksw: add per-task recursion depth tracking
  mm/ksw: coordinate watch and stack for full functionality
  mm/ksw: add self-debug functions for kstackwatch watch
  mm/ksw: add test module
  mm/ksw: add stack overflow test
  mm/ksw: add simplified silent corruption test
  mm/ksw: add recursive corruption test
  tools/kstackwatch: add interactive test script for KStackWatch
  MAINTAINERS: add entry for KStackWatch (Kernel Stack Watch)

 MAINTAINERS                           |   6 +
 arch/x86/include/asm/hw_breakpoint.h  |   1 +
 arch/x86/kernel/hw_breakpoint.c       |  50 +++++
 mm/Kconfig.debug                      |  20 ++
 mm/Makefile                           |   1 +
 mm/kstackwatch/Makefile               |   8 +
 mm/kstackwatch/kernel.c               | 260 +++++++++++++++++++++++
 mm/kstackwatch/kstackwatch.h          |  53 +++++
 mm/kstackwatch/kstackwatch_test.c     | 261 +++++++++++++++++++++++
 mm/kstackwatch/stack.c                | 289 ++++++++++++++++++++++++++
 mm/kstackwatch/watch.c                | 177 ++++++++++++++++
 tools/kstackwatch/kstackwatch_test.sh | 118 +++++++++++
 12 files changed, 1244 insertions(+)
 create mode 100644 mm/kstackwatch/Makefile
 create mode 100644 mm/kstackwatch/kernel.c
 create mode 100644 mm/kstackwatch/kstackwatch.h
 create mode 100644 mm/kstackwatch/kstackwatch_test.c
 create mode 100644 mm/kstackwatch/stack.c
 create mode 100644 mm/kstackwatch/watch.c
 create mode 100644 tools/kstackwatch/kstackwatch_test.sh

-- 
2.43.0


