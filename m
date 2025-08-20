Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BA40CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 07:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3108E0027; Wed, 20 Aug 2025 03:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8643F8E0011; Wed, 20 Aug 2025 03:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 779E18E0027; Wed, 20 Aug 2025 03:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 668A78E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 03:12:52 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01D661384F8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:12:51 +0000 (UTC)
X-FDA: 83796268584.12.35A854F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id E6BFD40013
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 07:12:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755673970; a=rsa-sha256;
	cv=none;
	b=ALxOEdX/AiLM50kRbzEdrSkXrQzE2bIzwvXDktbPDYjfq8fRuRk8jWvtGvClHeI7ukYsnp
	viaDTZHV7JeyPIJMqa79QmGnD6+p92w5vELDiYtBn9TS3kjGt7vTxwKqN+m/DE4zNFtcXm
	srqKJ0Mrufzj6WKZaLo6vvJ0QBWqhSQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf27.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755673970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=85/+YiMW/jNPE6Ecxn705UrLwZ8ZaKSJ5XDM52Fxyfs=;
	b=Dm3XHZEwjdU2eUbF+rd1vp7pWSbGajVTSfKTfelsejB4Hd4yD1DajfRw6xF8Sj06DiT6+y
	sf2YdXlWZjh+TFn1M/cJdBI9ODFxrsY1xVoErdqXmWri1XmukBuGFnoubzHRAKcAwD7imM
	S3M2tnD8Chkl0lDmLmSKjr7hvyYiBRU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C3F94106F;
	Wed, 20 Aug 2025 00:12:40 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 19E3F3F58B;
	Wed, 20 Aug 2025 00:12:44 -0700 (PDT)
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
Subject: [PATCH v5 0/2] introduce kasan.write_only option in hw-tags
Date: Wed, 20 Aug 2025 08:12:41 +0100
Message-Id: <20250820071243.1567338-1-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: E6BFD40013
X-Stat-Signature: r4ycwjphb1rafuue65yd4xpj1octkkq4
X-HE-Tag: 1755673969-929699
X-HE-Meta: U2FsdGVkX19R9222kHCOdvWMvEoCglLWoEMUMxpj5B9bcF4RME7jBRwFBMC39lOICvlCr7nJl9uizr4LabDtQs4QA5AKZikib5tPh/aJlbZaviDPLgil2WfHuRZVBJPlzxFUAS6NbPGQrfpzhuSe7UdgQ0AorIPOM6RI2mLhzdNvPLGq0W7XDbR6spxu52nP4fr+ucAATidVMLycRxGtO4crSdRe6SsU8gHbV5pJWtd8YtbtfaCCvRrxWf0yp89sYoUN7y0rMrdXF9OdjbyoONAHx1PTletLb3qbWzv0U6dq5js+jUVGml4B0AuSlforHzEjX0UqzH6L5ErR7AnT4YMGR3Iv1seHLDwPrv5lS9FigNJ8+yGyNpjY5mqHZLD3ythoDgglaYaHPl4AjhHkrIDFZTHJVMKuSsRjJ6FXuIDNvkOYX4t/bc1yl1ZEKSfxFqMGru9P1hiwSR+ZlPYbUO+nQ3llT5Mwmuzyr0DWDu0uRCrmzNiHIeiuaquvaj7NA++9Mb4jZivZlHN18YcrIN7BwiWdBvH7UhZQl4fzr91ZLaOyJVigNSLclUee3W3sENwRpAwynf3T7qZmatWZ+IAcQn9mHa9AnFdl/yisRlGfJGoUtDPEYCiQ1bO/AIoTei7jvGx4t4nVwhL2sJ5DkyU2n7WQywDs098st4BU/9NkCXPYZySWcf5Cj7jJbHg5EIuuf4YjP+ZfRPLzJfHABZOyKQ1xZQHmqLTGDc+bZFaVEHMbl3D4ZLp5FL8UlhHlyZsWtjnUJpUPR07qXqwJGQkS6SoUXK2jOiad15Z+J3Cww79BGaKLshCnB9oDiKbkiw589Un1AzWBVEEYooRW+B6Yb/s+Uesh1Mp6stzPDhhO2PxEg4pvWNk7uPuK1b3Sv2IYg0fp7AkO43xr/u3047b22hVOqQ5mOesuRiopMQ0fNBu8vHAXCpzSUk+AiRw4nMsH9IY6hDhqanCQDeB
 T3PskUli
 X0IUmv3u82c4tY9yJUzAzSEt1+r1jd364eA9+QGyRIf8XbqC09pdqCQxkokcNLFSTpR3IAwJaSPYwNo45q+PUGqYgaiqLHTCjnnG63i/4Lb3dr5kNaqS3D7TPPU4nNBrPWl14czgXBsQZwMdPWWGxPOXwzWIhBjkLpU8VvkyAxnD/ZLlJs0JO6NVGuWLBMcm2Nh6fs8IHGDrNDpKuDgPhOG9HocfVACbYYzuFRzG1ilSL07EZ7uVCurwxtGz69/x9w/yIP9U0Tkpbk2uVZTXLkKkMyzc3EnkS+wMdtD0ZynQRugo=
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
from v4 to v5:
  - fix wrong allocation
  - add small comments
  - https://lore.kernel.org/all/20250818075051.996764-1-yeoreum.yun@arm.com/

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
 mm/kasan/hw_tags.c                 |  70 ++++++++-
 mm/kasan/kasan.h                   |   7 +
 mm/kasan/kasan_test_c.c            | 237 ++++++++++++++++++++---------
 8 files changed, 266 insertions(+), 78 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


