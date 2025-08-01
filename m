Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E54C87FCA
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 12:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8AFC6B0095; Fri,  1 Aug 2025 08:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3A636B0096; Fri,  1 Aug 2025 08:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50136B0098; Fri,  1 Aug 2025 08:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B684A6B0095
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:02:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C2D7BB9E1
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:02:42 +0000 (UTC)
X-FDA: 83728051764.14.498A36C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id EC8B3100015
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 12:02:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754049761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=tIgHmUWD8+nFQPu2B5WM+mFSv+KskxpOdza9tHpomR0=;
	b=vt29jcNAuNcTsfBVUxICPMKzWE1816ZC/ekh9JqQdyRf9dJYVakrwnuiCSPRPBjDcDqKmn
	giJekxIFsLeF1Hia4P1dYpbDfiGr4YbjX2A2J5y+4kXcse+h2BlWn6uTtWHAozo9ev++uA
	w2senfzebSQoaGJUxfv0f8D7Bx8W4T4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754049761; a=rsa-sha256;
	cv=none;
	b=PFE2t2CliCRIxPmWF8m8znwoAeJltC1iagyA+e+cbzFxZsxl/Xnv/ebdEndQT7/YIJLI5j
	Ei0aarWIHxxevJcVV9JhSUBm2WML+kZqmewK2NmOwB4JB0wzY88BVOckts/X91yH49MZsQ
	L0ZmJF1cbpvVm820Cj03otCjklV4Pl4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5FAB1516;
	Fri,  1 Aug 2025 05:02:31 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4CEF43F673;
	Fri,  1 Aug 2025 05:02:38 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: thomas.weissschuh@linutronix.de,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	akpm@linux-foundation.org
Cc: kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v3] kunit: kasan_test: disable fortify string checker on kasan_strings() test
Date: Fri,  1 Aug 2025 13:02:36 +0100
Message-Id: <20250801120236.2962642-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hdq6tpazuhqwpzy41yd6d3jjngaybxdy
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC8B3100015
X-Rspam-User: 
X-HE-Tag: 1754049760-943764
X-HE-Meta: U2FsdGVkX198dwWhi1Y8c1rb7syaR47fQ/rmeZcrCjXRmrpixduO80YC7J9eKtPMOYwwQDFFyLUAaeWK/MvHBvZiKa/1mt+MyCvAfnZFYHD0wKAWF8y6EHz8xpunSzvZpb+/xiTPpr1POyXhwVePoC5Ine6iLZWvU6DuuaBBDxGuQ3y2+Lg9UH8VIAV6QYZfWILshdQh4cY+sj1F65X32WQFSZi7ECRCEeyoIWh59cMl66RlsLA/HB2BneIkjegk/mvp2qDXAta/fI1CMyjt9qSibaWBKuX6MBSIcgAFMlnLFLoK8XecfaYSHjqVu7sF6a8QZm0QORUCkW/WzGO8u0B6Q30NIE3P6LoU8Fx2hfBvtQr+XBgbVR01HO5jmmkbv0EDeoy58/LfEncaTANldcC/NlkIzx8vF65CyfkOw1Df33cs/rPpnD0v6+R4pz6UXu5P/2wgPVyRPIK69vp0ykLDiC+QRUbhNS1ZrFJDnXeUutKriir3jKWX1KC8tSu3cu/yob++Lq9ihYHoO+yGyOJzqKD9+ilWnN6avCcYMB9C8kToA0Dvx26aEa++MiKx90Bq2RLx6NvFbQxjJP4I/RXyrlFwtB5Zjfz+nCPylkoW72QtYy1SnAwvjzCFEA/mJ9g1xKJu4GpbAt1ZOszp2YglDXx9+mCzlEYN6QnMDeMFtYIDoaK6R1Cndlon8rbGNcAjDxnqP8pg55/rGINXsf1uhJhtFVotMRvSyVPQyWngadLhV68oCGgrkta77FtEUhtoEJd6UGT4Lj8uW8bsJzzM9QNltGiVj3rptMlagR/QNawxR1rdi95sYVSRvEXUSc8D0GA5jZAlBlXpHtKg8u5MPMxRuogCoJM9mDQ5qBJCSXW/Kd4+FfKgDT1hxBdGYtxLd0AZBM649Kbgnlz7r32X2rGPUFn7kkl12jvYva9uOmwSalhJ2VulsYGWsZCdc/4/mwA644i0F44Xll4
 lzLAfGmp
 8J/q42+BXyR37tydb9paG/JToHaxKL78E+IKnUZj0FY0j727f+ubKzF/VerbpITci74LYkikL6LXzB0CC/Hj7nnhvbVPqGsKU7/9br+PfERNOeJsJGeEnmDb0isYbIWGV1EAB2Xjs1gepUVf9TGOCfEdxcLFnQjArcF9SlDfhqqkOmbl018y+MBuF3dcqScRbh4HLECpXyXiSY9QS8yRGWfzpb8GNkKDXq0b3JGYvVwZr+3qdadc0tHfHEMAPut3luEju
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to commit 09c6304e38e4 ("kasan: test: fix compatibility with
FORTIFY_SOURCE") the kernel is panicing in kasan_string().

This is due to the `src` and `ptr` not being hidden from the optimizer
which would disable the runtime fortify string checker.

Call trace:
  __fortify_panic+0x10/0x20 (P)
  kasan_strings+0x980/0x9b0
  kunit_try_run_case+0x68/0x190
  kunit_generic_run_threadfn_adapter+0x34/0x68
  kthread+0x1c4/0x228
  ret_from_fork+0x10/0x20
 Code: d503233f a9bf7bfd 910003fd 9424b243 (d4210000)
 ---[ end trace 0000000000000000 ]---
 note: kunit_try_catch[128] exited with irqs disabled
 note: kunit_try_catch[128] exited with preempt_count 1
     # kasan_strings: try faulted: last
** replaying previous printk message **
     # kasan_strings: try faulted: last line seen mm/kasan/kasan_test_c.c:1600
     # kasan_strings: internal error occurred preventing test case from running: -4

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
Patch History
=============
from v2 to v3:
  - rewrite commit message.
  - Using OPTIMIZER_HIDE_VAR() instead of __NO_FORTIFY
  - https://lore.kernel.org/all/20250801092805.2602490-1-yeoreum.yun@arm.com/

from v1 to v2:
  - Using __NO_FORTIFY instead of skipping kasan_strings() when
    CONFIG_FORTIFY_SOURCE is enabled.
  - https://lore.kernel.org/all/aIs4rwZ1o53iTuP%2F@e129823.arm.com/
---
 mm/kasan/kasan_test_c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 5f922dd38ffa..a1a0e60645da 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -1578,9 +1578,11 @@ static void kasan_strings(struct kunit *test)

 	ptr = kmalloc(size, GFP_KERNEL | __GFP_ZERO);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ptr);
+	OPTIMIZER_HIDE_VAR(ptr);

 	src = kmalloc(KASAN_GRANULE_SIZE, GFP_KERNEL | __GFP_ZERO);
 	strscpy(src, "f0cacc1a0000000", KASAN_GRANULE_SIZE);
+	OPTIMIZER_HIDE_VAR(src);

 	/*
 	 * Make sure that strscpy() does not trigger KASAN if it overreads into
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


