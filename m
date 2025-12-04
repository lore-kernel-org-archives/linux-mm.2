Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED214D206A8
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55F3D6B0010; Thu,  4 Dec 2025 09:13:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 536476B0096; Thu,  4 Dec 2025 09:13:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B106B0010; Thu,  4 Dec 2025 09:13:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F99E6B0010
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:13:06 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 01B851A01BF
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:05 +0000 (UTC)
X-FDA: 84181980372.01.0DB7551
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id 10D444000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZCwRpm0N;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857584; a=rsa-sha256;
	cv=none;
	b=sQxRneYfjoj3Ue+VMQAUWLaRr3vkhiohVenSf7OhS0cJ/ZLqs/OuhKY6EiPkvqG33zbNc1
	Nu4N4CTgy9F4W4fn79HJiRJTgGNUmSnWsYeN1Tus1b9KJ88wn6jEBwcuAvE5wDEE5sXbrJ
	Db0m4H7lsZevg0V/OA2rl8JaaKs5YAA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZCwRpm0N;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Zml3KS+UsrvHkR8m+pYaf5EprirpHcFq08V4fzn955Y=;
	b=FupxNCrb57RYhKOlwj/ayYcGtCAuP+JTUN1H3xaVRRwTDOhxpycg+PUaHo9LlvxZ72iWpd
	jJQ3WFMrpR796GPLZ5Q5ws8MmcjE90aJfqcM3QWIf1aRwO130ndb/3jBRIfqJqMiXD3X1b
	sTnSGaXeJ0aFKZHlzZfWETn/LYaowow=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42e2e50c233so461937f8f.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857582; x=1765462382; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zml3KS+UsrvHkR8m+pYaf5EprirpHcFq08V4fzn955Y=;
        b=ZCwRpm0NUsd/ieuxG3A91HHQjctz8VF/4s6CTUM2QKq3eb72DD7h5F2m6V/IsjzmNV
         sTnuJ8ytsDbB63vFTvqpJqxLLcURnGEOdN5c8Eqef/GKFPTAnyhj8OdW571R6N2DGgcx
         hkODlWuyaUJsLNZTIeuHuTJzR0AxDcjWK0sZrgQEDOuDm9gKe9ammqSezsOtAbEiUafx
         t5GAGgAK+qqWyJ1mtlq2vdATFf0HNr2pJIp4yc6NzbMk0bGv2x3hfSBxkxy1OTXq+Mvm
         FUTwp2Yx5dEwVU/HusrgZ6jWhS5/eJT39m64tkfIN/XvbTzEzT8RwXA/444wmJlPeQ/p
         kCsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857582; x=1765462382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zml3KS+UsrvHkR8m+pYaf5EprirpHcFq08V4fzn955Y=;
        b=acBA6BALtZveYL7kKH0KT3ZEa3B1GoVZK9ZTh1GBW2EjOts6kHrLocRdb2mXZM07nj
         Lw/wy48XIFcmPHZK+lxeF2QESsb3cwAyfyXX8t6CT2Pg86+122iXZTbfU8ijQUDTA5dy
         PtZrhyxZnxsIJI6hZbszxKI5L3MOLdArrFeXzbkf71BEfKHuzNTBAW+vWwPO+ONm0Dft
         SobjADBHR+i9Y3k2HGJbQj5WBFlZ4jguXuJBdOlTr0cxI/kCp12JaUbi8RXeW6NkdPUC
         WobDlfiLdhmGi/R42mIxagHZXaZ32oPdZhXlHtoVIwQrATIu+mtOHgmiiUPIdVLAhauZ
         hZHg==
X-Forwarded-Encrypted: i=1; AJvYcCXcuhj22g087mThJ2pd/1TucoLb97s0DMvJyPG6RslWtjK1xXjumD7uwsUTS7gkSU8KAah+nmgZzQ==@kvack.org
X-Gm-Message-State: AOJu0YxcUKKhwJhjIHTxEi/DNqARO2KICsOCXF7+Sx5JpJ4tvRJCwCBO
	TS2/irSE96DGLvL1jyXs4kh7Nxt/PoPtCAfZ2AyMDrNadN+10RbdOW8C
X-Gm-Gg: ASbGncsOFvNB4XFLwShVnOTwq2WO7Zlx+dl+iM8LY5cdYl3Ut995o4u6O2j4TjkJNx9
	ZwreMCF77ghDinWJlKdKQfnjW4xxhFWj1oSj+tEa3y63VACBAayPXo+opawY5UvCljJMwGS0Vod
	BV63ba4KKUsU0zRQSTHt7W8wEfrPIiwo8rvwhq7Mhop58NX2ITopGzMiOLm7i3SoPG4Z6xRhWHL
	Ieq/eicGN6u23QKwAkQMwUKtynn60VdRq1bUju+X1XF5JnTxeqU2xLgkOu5iLF0VsvAX6FiaoOG
	KdP+u0JMfcnOOxEIyrNqBlmgd7ouW+XolfLOv331rfPwWQUmLJgYQ4wdBhktnctzLGjn/5qokAf
	vTZzzoAi7WTQPXyOp9qclFnSpxOMQPnZ5MSIiH08+B2h959Fe43+NHZh0itJ+jAiTEgmrY3WBA6
	WLzRm17trXq0u5aX2vzNiZUvobvpT1Gf8Dj1xk0la/OSO7Ug0XbY0L5xqyZEEpiPEsBw==
X-Google-Smtp-Source: AGHT+IFIh69RdA1vnCTw0PcitJb0iveYoA93ksIeD56K8ycLMTPv0k8+6CuwPbzV5nMxBZQhq5bF+A==
X-Received: by 2002:a05:6000:2507:b0:42b:3e0a:64af with SMTP id ffacd0b85a97d-42f7317205bmr6670197f8f.11.1764857582226;
        Thu, 04 Dec 2025 06:13:02 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:01 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v3 00/10] KFuzzTest: a new kernel fuzzing framework
Date: Thu,  4 Dec 2025 15:12:39 +0100
Message-ID: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 10D444000B
X-Stat-Signature: 9jmbq1zyw9mkotcg5iws31ihj14fw5ye
X-Rspam-User: 
X-HE-Tag: 1764857583-831128
X-HE-Meta: U2FsdGVkX19Gphy+xOIf6P6ZKlV9B/u6k/fUAyGPNGyeU0kN4ed8opo3z7GrYEEEP8YfAxhJyDzU6COpk5UxoSy0apcv19Bq9jmKKqStXxMO5ph0p6h3Y5tXPenVZGmxSRfYRAqtmTunDiwE/jIr3YS4cOg3o3W8TUog23ToGCO0Ro4sWtlVABlhml0TUXG10Pp5Dr/cBS81JEuM9p1rxIiv3HpWJ5DakAslW/czKuaKzTvcVKMxVUO+N1YQ4gnZpW3svGHFjKClL/paBa9zGx9idrTvf1veZqT2V9HoCPOUMy0rXLjJ8oH66Sg5y3bddSG9jlORNcf/YHxw51Ym4xiA5d1soYKAgFmT6BcPa16aFU0vAraAx6gtIQ/gZArj3XTHHJRxJUTySWf61tyRlUpFvUZ/q3Ygc74drJ8n9myxYSMArC4oe8EmCbnCb35CGgr42A1/9MplFWsZ2twzDj3fbmiWT9louNKvyw27zVlx7gRzAKRQaS9rMbIlhFrt+rridPp5UyYY5se1MMQ0wtqcLlx3o9YCjU8c/bgT7Afpoe6TgEfUL/ROgwGSEZTT/FWY9mHbalMQ6JblNIPpnIN6O9uk0zzQGQE2nhHhxmFIzqK663ZMUqDQ/7LM16063V/oVX4j905B19j9Tmpga8MXv9p69AHGWG+UiIdLB89RVtP5Y138OEy5Q2/MDrzX+SReXLl6cMz7QiUmBrPvVBCnlp9vTaqjn2+9Qohv1CpsIV+ZjK7S2IP12dHk69p6Y/70o2//gOf1u9Na+hjRj4N1LO0pEqtqcT0TJHtnpx1Z/AQXEhzDTddE0kZWSJzcPgsPpeA/CC2nRcFNCTfARmHqudSXpM/ugABIjEQMaxusJIsDL/uq1JSYGChIckr/BX+4nAO699CV2rTXL2uA1UwkBjdQD0BzRYuDZgn2dvOwU02wj3KWV9fyQDrGn2upj+bhCXl92092EV9MfFx
 NnAhIfEW
 jr25TRP2jxxmAQCtD/TOOqRw9JTqynZbj4N5rYPio79Gpw6if2H2z+zLswQ0FHipu5ZCjF6H8GJpgXl/FgYpjlIZRZ4Zb0lsaktWlX/u9Mj2bD5VaV4Ydz3tXP2YrHpsYap00YMFVLic4JTx7a5IlOnTF+uWcZ05sdzGcmsEIGIZhYD026iypqZ0lQ8+ougcsv75jIkkyDm//53nEMQkToI2/pT4a4rBThqw6V1GqArPSv7iCb9/dp1wGvbRisoWm4fvjph+az9D645ISfM7CkbiCAFrjnffNQjcS1mbmxhg4y3WqxYVPkxUB12D7vVCwc6goGEyUvx7BvIxlb0n8m5Y+FhqofS7McV7GglUP1Jyi++ZL+4VfvNGFQseDdm1r2zOyB8aYTZI/Ya2zGwm3zNvrGh9k/z/g773ItbUXVjMFZ95v3DrJ7bEZeyK1KiWcJmPlDDw3kEmq8D71JBRG306Fnrq85GjsBJAJ12pEPvRws73sFy0L9kJp4nkiqkFlqM1t4jALdcN0aUawtD6qeW+2oN6KPcvfRatcUISUBwBAu3wtJo2QuOJRya1X8YE3E+G8JGeif2YE07eFtf8cf286SAq04wK2rSN+yLsUMbEeFktg3YmO3+zQcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series introduces KFuzzTest, a lightweight framework for
creating in-kernel fuzz targets for internal kernel functions.

The primary motivation for KFuzzTest is to simplify the fuzzing of
low-level, relatively stateless functions (e.g., data parsers, format
converters) that are difficult to exercise effectively from the syscall
boundary. It is intended for in-situ fuzzing of kernel code without
requiring that it be built as a separate userspace library or that its
dependencies be stubbed out. Using a simple macro-based API, developers
can add a new fuzz target with minimal boilerplate code.

The core design consists of three main parts:
1. The `FUZZ_TEST(name, struct_type)` and `FUZZ_TEST_SIMPLE(name)`
   macros that allow developers to easily define a fuzz test.
2. A binary input format that allows a userspace fuzzer to serialize
   complex, pointer-rich C structures into a single buffer.
3. Metadata for test targets, constraints, and annotations, which is
   emitted into dedicated ELF sections to allow for discovery and
   inspection by userspace tools. These are found in
   ".kfuzztest_{targets, constraints, annotations}".

As of September 2025, syzkaller supports KFuzzTest targets out of the
box, and without requiring any hand-written descriptions - the fuzz
target and its constraints + annotations are the sole source of truth.

To validate the framework's end-to-end effectiveness, we performed an
experiment by manually introducing an off-by-one buffer over-read into
pkcs7_parse_message, like so:

- ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
+ ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);

A syzkaller instance fuzzing the new test_pkcs7_parse_message target
introduced in patch 7 successfully triggered the bug inside of
asn1_ber_decoder in under 30 seconds from a cold start. Similar
experiments on the other new fuzz targets (patches 8-9) also
successfully identified injected bugs, proving that KFuzzTest is
effective when paired with a coverage-guided fuzzing engine.


The patch series is structured as follows:
- Patch 1 adds and exposes kasan_poison_range for poisoning memory
  ranges with an unaligned start address and KASAN_GRANULE_SIZE aligned
  end address.
- Patch 2 introduces the core KFuzzTest API and data structures.
- Patch 3 introduces the FUZZ_TEST_SIMPLE API for blob-based fuzzing.
- Patch 4 adds the runtime implementation for the framework.
- Patch 5 adds a tool for sending structured inputs into a fuzz target.
- Patch 6 adds documentation.
- Patch 7 provides sample fuzz targets.
- Patch 8 defines fuzz targets for several functions in /crypto.
- Patch 9 defines a fuzz target for parse_xy in /drivers/auxdisplay.
- Patch 10 adds maintainer information for KFuzzTest.

Changes since PR v2:
- Introduce the FUZZ_TEST_SIMPLE macro (patch 3) for blob-based fuzzing,
  and update the module code (now patch 4) to initialize an input_simple
  debugfs file for such targets. While not explicitly requested by
  Johannes Berg, this was developed to address his concerns of the
  serialization format representing a hard barrier for entry.
- Update the crypto/ fuzz targets to use the FUZZ_TEST_SIMPLE macro.
- Per feedback from Kees Cook, the fuzz target for binfmt_load_script
  (previously patch 9/10) has been dropped as it is trivial to fuzz from
  userspace and therefore not a good example of KFuzzTest in action.
- Per feedback from Andrey Konovalov, introduce some WARN_ONs and remove
  redundant checks from kasan_poison_range.
- Per feedback from Andrey Konovalov, move kasan_poison_range's
  implementation into mm/kasan/common.c so that it is built with HW_TAGS
  mode enabled.
- Per feedback from Andy Shevchenko and Lukas Wunner, address the build
  system concerns.

Ethan Graham (10):
  mm/kasan: implement kasan_poison_range
  kfuzztest: add user-facing API and data structures
  kfuzztest: introduce the FUZZ_TEST_SIMPLE macro
  kfuzztest: implement core module and input processing
  tools: add kfuzztest-bridge utility
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
  drivers/auxdisplay: add a KFuzzTest for parse_xy()
  MAINTAINERS: add maintainer information for KFuzzTest

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 491 +++++++++++++++
 MAINTAINERS                                   |   8 +
 crypto/asymmetric_keys/Makefile               |   2 +
 crypto/asymmetric_keys/tests/Makefile         |   4 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  17 +
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  20 +
 drivers/auxdisplay/Makefile                   |   3 +
 drivers/auxdisplay/tests/charlcd_kfuzz.c      |  22 +
 include/asm-generic/vmlinux.lds.h             |  26 +-
 include/linux/kasan.h                         |  11 +
 include/linux/kfuzztest.h                     | 573 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 278 +++++++++
 lib/kfuzztest/parse.c                         | 236 ++++++++
 mm/kasan/common.c                             |  37 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  71 +++
 samples/kfuzztest/underflow_on_buffer.c       |  51 ++
 tools/Makefile                                |  18 +-
 tools/testing/kfuzztest-bridge/.gitignore     |   2 +
 tools/testing/kfuzztest-bridge/Build          |   6 +
 tools/testing/kfuzztest-bridge/Makefile       |  49 ++
 tools/testing/kfuzztest-bridge/bridge.c       | 115 ++++
 tools/testing/kfuzztest-bridge/byte_buffer.c  |  85 +++
 tools/testing/kfuzztest-bridge/byte_buffer.h  |  31 +
 tools/testing/kfuzztest-bridge/encoder.c      | 390 ++++++++++++
 tools/testing/kfuzztest-bridge/encoder.h      |  16 +
 tools/testing/kfuzztest-bridge/input_lexer.c  | 256 ++++++++
 tools/testing/kfuzztest-bridge/input_lexer.h  |  58 ++
 tools/testing/kfuzztest-bridge/input_parser.c | 425 +++++++++++++
 tools/testing/kfuzztest-bridge/input_parser.h |  82 +++
 .../testing/kfuzztest-bridge/kfuzztest-bridge | Bin 0 -> 911160 bytes
 tools/testing/kfuzztest-bridge/rand_stream.c  |  77 +++
 tools/testing/kfuzztest-bridge/rand_stream.h  |  57 ++
 40 files changed, 3552 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/main.c
 create mode 100644 lib/kfuzztest/parse.c
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c
 create mode 100644 tools/testing/kfuzztest-bridge/.gitignore
 create mode 100644 tools/testing/kfuzztest-bridge/Build
 create mode 100644 tools/testing/kfuzztest-bridge/Makefile
 create mode 100644 tools/testing/kfuzztest-bridge/bridge.c
 create mode 100644 tools/testing/kfuzztest-bridge/byte_buffer.c
 create mode 100644 tools/testing/kfuzztest-bridge/byte_buffer.h
 create mode 100644 tools/testing/kfuzztest-bridge/encoder.c
 create mode 100644 tools/testing/kfuzztest-bridge/encoder.h
 create mode 100644 tools/testing/kfuzztest-bridge/input_lexer.c
 create mode 100644 tools/testing/kfuzztest-bridge/input_lexer.h
 create mode 100644 tools/testing/kfuzztest-bridge/input_parser.c
 create mode 100644 tools/testing/kfuzztest-bridge/input_parser.h
 create mode 100755 tools/testing/kfuzztest-bridge/kfuzztest-bridge
 create mode 100644 tools/testing/kfuzztest-bridge/rand_stream.c
 create mode 100644 tools/testing/kfuzztest-bridge/rand_stream.h

-- 
2.51.0


