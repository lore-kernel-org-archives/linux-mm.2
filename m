Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A0D9CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 07:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFD8D6B00F4; Mon, 18 Aug 2025 03:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED51D6B00F5; Mon, 18 Aug 2025 03:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11F56B00F6; Mon, 18 Aug 2025 03:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFA236B00F4
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 03:51:01 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 82EFD83E86
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:51:01 +0000 (UTC)
X-FDA: 83789107122.08.4A89284
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id ED9F2C0002
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 07:50:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755503460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LzlhayvUx39iJ+7QhG9gpaKkV1t5aRSU+oJ/ZcslHk8=;
	b=ZA5L5Mr0Vb7iYMfh3FXMVuGprSyjeMvY57NTcZffrckQDTDL/XmliUCMBkVwctWmPwPsKP
	7gqa4gwUfVMjxtY5AMsNxmuTiufwYxDXVIYULqUNVyxDKF5VBLt14IUnoD9xMDcMRkF7i7
	KpwWUV/kwByLy7zFDJazmC73g4YTOU0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755503460; a=rsa-sha256;
	cv=none;
	b=vq2tO+4bgIWyrLhFjkpySX6ZwPdNUHri6IM3Uetc9RXBhQRUqsbeWgxGthUAVq6DyUCSft
	FGZLkUHym1UUcFx/QOQuGSc5/NNPIqg4aRd/fut5WS7Kg+t57hyJGEnO3If3D5Ixa0yj12
	podXlx+iThThJkgi45MaDbsF6Bdo+1U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A088C1762;
	Mon, 18 Aug 2025 00:50:50 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E2CF43F58B;
	Mon, 18 Aug 2025 00:50:54 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	corbet@lwn.net,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	scott@os.amperecomputing.com,
	jhubbard@nvidia.com,
	pankaj.gupta@amd.com,
	leitao@debian.org,
	kaleshsingh@google.com,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	james.morse@arm.com,
	ardb@kernel.org,
	hardevsinh.palaniya@siliconsignals.io,
	david@redhat.com,
	yang@os.amperecomputing.com
Cc: kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH v4 0/2] introduce kasan.write_only option in hw-tags
Date: Mon, 18 Aug 2025 08:50:49 +0100
Message-Id: <20250818075051.996764-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1kzidcrnjtqqxruy6mdaxr8q47mgdihd
X-Rspam-User: 
X-Rspamd-Queue-Id: ED9F2C0002
X-Rspamd-Server: rspam01
X-HE-Tag: 1755503459-229292
X-HE-Meta: U2FsdGVkX18NhyMQZCQ0Efz2mWwAqecflQmGo9npqRNevCW0tc3mmpEkIX2t2mNI/dp4/gONKAhMqCOKHRldQZDWZjMys2ybfyAZdE2quPTY1yUGy0HcV6SCA+WJoEa4hbHf4wgK50pMxnMdQTdJQR8lqaRio1eKRBQNRZZZ4zR2YzP7NYZiCRyNriuERB142pY7SujU3Z7Kili3HnfpPc7Zfr7e4Gf7t/4nIcj7hkNpc9q4P6EMLHwBKY26pAeeJHXjwIr5V0cGMu2vca74NSwzI6gttxSG5i5dvM3iFVyudOqp92P5akvbcPFCyTTmDEKb42GeCYJHob57okGkXv2o0bwUw5P7jqnn+Sqr4iZFW0l8DQqWPR2m8EapaWTvUBqEWUCtn+7B1HQ+TolarmxlZlgTsCPZ+DdV4LK7jdZ2VX1F0C7YTf9RuxnAPeagh8gOQQdwzVkxe6lSzwc03iTqbu0KbaWok+87Ghob8SUIKABo5Q2UU9pdKUZH9MclBUkxI5h+IIB+8JW7uLzS8OoC1DIGo1NXyOSxbZxtPVGSOWsEE0l1WALtJZ4XRyz4G5nR7+y2fMJP9VnHYmtl4tz1Wo3ofpdHp/ku0a6fCDRCBVeawXin96V9AjxxzRre4ra57HXBZyLqutR4Wh28y1KY5BIxB0Y+0rQx/Ib8uBogvnXWHMRg4dEUkHyadBhepuwRp3hhLJkg7MsAPskC8oGKzBKjkj2uHKXj7jEu+V8s5bCFo7MSlHX9SQd6jWyiPtv6E/7TvP0e2YWzRqH+OP1Ek0f+5Ojz1wZBBzLxVlj/wTSjvRpXud4dFFQpHgU0NB+cYEK2dzsI7y9pe0zpvi4ynERQqW/KJdEIUyTpfTD3zXGoshoWDXmT/1sRpxORqQikCgcIaiiqYrJXLzElyMFHOZqnL6vGRXQzJ087cLuLvzHlnci+ggig+T3tPLDsimhgfSDbXrdw8yQAEa7
 s/en5OTK
 lKzfLPcsIFpiaGJI1KWjw03qkFaK2fgf46LqfkrvPJGwHcwKrZApGB0la9X4OFAY/0GyBxDuOe15zOqgOYxNNiOGP719gdlQrV90IvqaRTFy7gKbHf82mRz06yV6kiL1jDhpiegVPKNCoLmai2pgqnpp5ekZ5CnsWZV9r+QXJbYkw7OhllzJP/sKpqu890JqI3oKaUzQU6tQ/Z3FmFF1wrAOIOYVEJObsPQ9D0mO8RJ2PEDwcPxe52R1DCeHBlJZxK/jruP+6g7hZreugWpBjQv7ZSNFkqxIHkZaqZS6QDy2XRtY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hardware tag based KASAN is implemented using the Memory Tagging Extension
(MTE) feature.

MTE is built on top of the ARMv8.0 virtual address tagging TBI
(Top Byte Ignore) feature and allows software to access a 4-bit
allocation tag for each 16-byte granule in the physical address space.
A logical tag is derived from bits 59-56 of the virtual
address used for the memory access. A CPU with MTE enabled will compare
the logical tag against the allocation tag and potentially raise an
tag check fault on mismatch, subject to system registers configuration.

Since ARMv8.9, FEAT_MTE_STORE_ONLY can be used to restrict raise of tag
check fault on store operation only.

Using this feature (FEAT_MTE_STORE_ONLY), introduce KASAN write-only mode
which restricts KASAN check write (store) operation only.
This mode omits KASAN check for read (fetch/load) operation.
Therefore, it might be used not only debugging purpose but also in
normal environment.

This patch is based on v6.17-rc1.

Patch History
=============
from v3 to v4:
  - fix wrong condition
  - https://lore.kernel.org/all/20250816110018.4055617-1-yeoreum.yun@arm.com/

from v2 to v3:
  - change MET_STORE_ONLY feature as BOOT_CPU_FEATURE
  - change store_only to write_only
  - move write_only setup into the place other option's setup place
  - change static key of kasan_flag_write_only to static boolean.
  - change macro KUNIT_EXPECT_KASAN_SUCCESS to KUNIT_EXPECT_KASAN_FAIL_READ.
  - https://lore.kernel.org/all/20250813175335.3980268-1-yeoreum.yun@arm.com/

from v1 to v2:
  - change cryptic name -- stonly to store_only
  - remove some TCF check with store which can make memory courruption.
  - https://lore.kernel.org/all/20250811173626.1878783-1-yeoreum.yun@arm.com/


Yeoreum Yun (2):
  kasan/hw-tags: introduce kasan.write_only option
  kasan: apply write-only mode in kasan kunit testcases

 Documentation/dev-tools/kasan.rst  |   3 +
 arch/arm64/include/asm/memory.h    |   1 +
 arch/arm64/include/asm/mte-kasan.h |   6 +
 arch/arm64/kernel/cpufeature.c     |   2 +-
 arch/arm64/kernel/mte.c            |  18 +++
 mm/kasan/hw_tags.c                 |  54 ++++++-
 mm/kasan/kasan.h                   |   7 +
 mm/kasan/kasan_test_c.c            | 237 ++++++++++++++++++++---------
 8 files changed, 250 insertions(+), 78 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


