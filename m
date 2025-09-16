Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10836CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 09:01:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EFDA8E0003; Tue, 16 Sep 2025 05:01:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C73D8E0001; Tue, 16 Sep 2025 05:01:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD3E8E0003; Tue, 16 Sep 2025 05:01:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 087AD8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 05:01:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7700713BC5B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:22 +0000 (UTC)
X-FDA: 83894519604.21.FC27FF2
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id 978051C0008
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:01:20 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fFdIzly/";
	spf=pass (imf21.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758013280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=upMhvQF//L2bSGTsud4VXsSZCTKFm60OzLUP07Pokt0=;
	b=CJa6YAj0IDSJt5HfBsg7l36g6rPe/KsoSxiynYUjoinjVuE10EPupJmI+/qFs5igAGlolV
	FHIxIvx6j2jt9eRmPsUaZU9tfbJmzPgFPZyJ+HRXvATUH2dAOiIpPVYMYZm66pW96fe3X0
	jt+1Ida0VSZQEExTMQYI6TTJ0nOz/Nc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="fFdIzly/";
	spf=pass (imf21.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758013280; a=rsa-sha256;
	cv=none;
	b=uNtq1+Wy7gJJ0vZZbgtkmZqCdhSGJY1uOsKL5wka8zc4hvvJS5prd74qqiaLLrr+i8lJNu
	Uupo4cmDpJhs+xfhG5dL9JDuY45HXAIyDHXRg0dhKaNkutD5lVyIDNCUXUsZiLkIzBXNdr
	HlkqFHjc3fu/THFyDjyMHCahkfqncxo=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45f2c4c3853so10529885e9.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 02:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758013279; x=1758618079; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=upMhvQF//L2bSGTsud4VXsSZCTKFm60OzLUP07Pokt0=;
        b=fFdIzly/aueUpnMdz3rsUQ9kYlSb7nqHP6vNOYFCc8I53NSEeFiqZsl7ZJGfXUVxfa
         qF4JzT8od+4JkBMEJQjPxn5CfynslBieFWD8Xz1evIw5SjYjhGMkAMkCHPoPtKRGEDjk
         jtBgygnyDD7wPYgZSL/rZ11nn0O9v3agMvnv6n/5SXAeTKD7K9/RWHzvUfHTXVxwwExd
         v+Dg+hpx6Jmqx6R+VbyESan3qf7scDjeItBBezS9YtWaKTRItc2T677OiOUXtNQdDp5q
         pVhYwArhzMdD1s1rEXBCOaE1xu/OUOprUCIRPZWqPQjMuSA85oswKjMz8GBQUXPIQvoe
         JlyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758013279; x=1758618079;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=upMhvQF//L2bSGTsud4VXsSZCTKFm60OzLUP07Pokt0=;
        b=Ys4lhQS5OpG7uiiqfz19D2NiPvHLX+hMxK3uYxRUTb4xGp3a+Gh2Ba3GwhNvTx/pBM
         jrbFv6KFya7v4unSj6GjOH7UYd4WszH6L8pxLeBLOuaJR9uDuCihJ0H7koN2iWdgegTR
         l8uL5dzHhF18CIGusmAJQMGXfVGmqhSTGQj7DCqE+rr3cyZsqryIh0HiCBsG+9qPQOEK
         2m54T+mHXZ5SnjRUcA3hKLxwJzmfjd6oWm0gEoR9sBloblCY2pu9/9PXXwwYloZvtG8r
         XLsijmgjp4x0Y4jAxc7rD1PSQSDn2PPEvOwM77rcGdvva7AXFEIwwyL+drEkwNDtbP4x
         Lnww==
X-Forwarded-Encrypted: i=1; AJvYcCUZ9BFJI00y/OrEcpSPBnEnaEwBZp5MYC1n1NJPaPHbaEOHnA8ZCy2jUuop1/UQWp1bbmkzUGk3Qg==@kvack.org
X-Gm-Message-State: AOJu0YyXxEKEavPLiaLVoYd2gIcKhm+lZ6QqT9K8oHNiOXuRN9qMo/bS
	sV1h1NRHU4NvYMMQf6v6xWXgaLcyBJ3uUb69WNWZ4HViS9hlVAxfuN+4
X-Gm-Gg: ASbGncsmqPX8bmJUTNhSXrTJpIfPqA2RM1Z3xq8sq8PfmD5nIeRa0sNsufMjFpieRwA
	y4uehb3HvVlU3u7smAqblX99IqXrtvoiKMs8E8aY4hdfF6c+/DKPjlrkHbfqkPBTG6J0mgDKll9
	MZC6o9ExuHi4jigHO7Gq0m2HjBtX4ox+fTTqzgFVB1sM33lVS5025E1plxjayy3eyRXF9s3vsoz
	aKqvrP6YvHdYedMRyu4Y7jjIfRP0kR1XzwRTyRTgZ10MT45gsTvbI9SRLyqW5iKtCXg7qUhF2gq
	yEPPHWAn1SFyfakSMtPhbdxtZUZPx6kUr1PiOzPde8AYSormrPp1AB1lwfUQ0vFs0ESTsLg6zJR
	cLJher8LW9y4Q6ky1Srfi9TLz9kfUv5YV+i3RWNLOQaGjqgfAVW0mATKyKD8okZisGgOI7J+2gf
	BUo0ZXQkweo4C6WU4A/gd/vTY=
X-Google-Smtp-Source: AGHT+IFclWAKbjGgLv2K4m6q+aAL6mre53m9qB7bPaj17wvwDzoWsbTz12D9JPu/yEQ6xkF20lstyw==
X-Received: by 2002:a05:600c:a0b:b0:45b:74fc:d6ec with SMTP id 5b1f17b1804b1-45f211ca9dbmr161780395e9.8.1758013278551;
        Tue, 16 Sep 2025 02:01:18 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (42.16.79.34.bc.googleusercontent.com. [34.79.16.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45e037186e5sm212975035e9.5.2025.09.16.02.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Sep 2025 02:01:17 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
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
	tarasmadan@google.com
Subject: [PATCH v1 0/10] KFuzzTest: a new kernel fuzzing framework
Date: Tue, 16 Sep 2025 09:00:59 +0000
Message-ID: <20250916090109.91132-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 978051C0008
X-Stat-Signature: 47wmrx3yc1btwfweehsi81hutgq5hgzn
X-HE-Tag: 1758013280-72253
X-HE-Meta: U2FsdGVkX18hqqnmUjUAHDmaSIbud6q7iL1XjXezGR0yNf+YdOv+5ksRfMZGzu5rd0gu3EWf3gcg8XjHLZVLDbChrABW54Cay2LHg3US1DPTerJvP3idDda7zhiBLyxr2KlEtMzll8Jy6O15a1qe8mM2iJzs7z6B4e6e+uYQXMH9hPNUJuQM5VXYGDRF44qhT/+EHgK8RDTdS7SxSyfPBXOP5fziiUWc9DYQD8bpBrdWWpSINsYuqQbyDqTiXQmSVw93pV++jy2tTzeC0Y/cSch767gA1ibdds6c1ugxCA8Vb2JGuBhvJx1uNoZ9SP88fFV3rxhGY86a5lplQKuB3qG9kyP5hNqWDycfkiGb9Ikdb97Cvpe4HKLb0Id+pEreDRoDB83tI6ICXjan3mAyqJZe+JtWBTFGGakHeeKShIxaPuqYq97SALhT1fWJo84pT6CBN2h5HCLM3X7DLK+OY3RULb8iDlJRLM+5PRGpLAuc0PK8jclbfH4lehOsPts6jugB1LFX3PLIWSraYjCdLbqyL47NHFuEbRRMNo3SBGrdVFH6FMTarUDfc1wrpus2QMc/SWNWJiGBbF7tjsYzL0IaT3aynNXYtXGTF7jqn4tJycIhkLXF8R54RMfs0BTt6wh/L5fMrHiTTT7EqBVRJZeR/UxFBWeNiqM3CisKkw+NmzE8f8sLB8jONjJACg5cNDbEL35175EONoEtaKRQBmYHEZP998mteRSteKpiCKvnh7n7xnXYjWQkYN2P7BBSiFSjyr51onVkM6JtJ6FkXdlG4lzuDDpPnWXZN7FesfKcahQW/UOE5WBMwncfE/bY6a54BBfzfxtbFh8Bn2LmeUWFZ1yC1gcO9tpbuYLfLq3MCUBjJw+/gOXgtForBmKiP5BRK3cZhtGMCId87ssKBKhw18epngnJQ/lGh9sNskpN8DHNWk5A1YE04aKarm3Zo+0tnnoQT8oW4C0SgsM
 TFzqgs54
 0qQiI0yivyUJPYT2mW0HNLKrqRQvqkf9CTo0yeghFPZVNDsPbYUaoyQ1hcAr14R1Zaa7Cgg1DjYIxgAK6M7zXJBshq5VhVq15x6HdM/57e7Yz9lv8cTnlVOWFpYFsgdYJebAAbzWwFl98BruJIiT7wiAD0ZUt/6GKLyESjSgMVbfUxE27wzBiCnoH6Rnv3/AZCvmWXjYVnFjd4WtWDJRCj+xtRvPkE/AYBb6z7sj8wnvIX7EDP9w8ShIjJrZSD8eXyGrbxTudlRb20nD08K6e/3elPulns+gZhp1So3Nk4DZU6/huNxOjDwhHMxxWxGevjJ1xb1GCNBZ2t4dLnq2fKI//A4szQLcZoAhVBLpUUO+hXuVGEziOvJQMAwcoyZ7pBqHWlNioIkMr4h0T9u/8D3bvIlgLNClobWFAD2weHdaPVJvtBSIyu7N5yn9R75+meuYP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

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
1. A `FUZZ_TEST(name, struct_type)` macro that allows developers to
   easily define a fuzz test.
2. A binary input format that allows a userspace fuzzer to serialize
   complex, pointer-rich C structures into a single buffer.
3. Metadata for test targets, constraints, and annotations, which is
   emitted into dedicated ELF sections to allow for discovery and
   inspection by userspace tools. These are found in
   ".kfuzztest_{targets, constraints, annotations}".

To demonstrate this framework's viability, support for KFuzzTest has been
prototyped in a development fork of syzkaller, enabling coverage-guided
fuzzing. To validate its end-to-end effectiveness, we performed an
experiment by manually introducing an off-by-one buffer over-read into
pkcs7_parse_message, like so:

- ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
+ ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);

A syzkaller instance fuzzing the new test_pkcs7_parse_message target
introduced in patch 7 successfully triggered the bug inside of
asn1_ber_decoder in under 30 seconds from a cold start. Similar
experiements on the other new fuzz targets (patches 8-9) also
successfully identified injected bugs, proving that KFuzzTest is
effective when paired with a coverage-guided fuzzing engine.

A note on build system integration: several new fuzz targets (patches
7-9) are included by conditionally importing a .c file when
CONFIG_KFUZZTEST=y. While this may seem unusual, it follows a pattern
used by some KUnit tests (e.g., in /fs/binfmt_elf.c). We considered
defining macros like VISIBLE_IF_KFUZZTEST, but believe the final
integration approach is best decided by subsystem maintainers. This
avoids creating a one-size-fits-all abstraction prematurely.

The patch series is structured as follows:
- Patch 1 adds and exposes kasan_poison_range for poisoning memory
  ranges with an unaligned start address and KASAN_GRANULE_SIZE aligned
  end address.
- Patch 2 introduces the core KFuzzTest API and data structures.
- Patch 3 adds the runtime implementation for the framework.
- Patch 4 adds a tool for sending structured inputs into a fuzz target.
- Patch 5 adds documentation.
- Patch 6 provides sample fuzz targets.
- Patch 7 defines fuzz targets for several functions in /crypto.
- Patch 8 defines a fuzz target for parse_xy in /drivers/auxdisplay.
- Patch 9 defines a fuzz target for load_script in /fs.
- Patch 10 adds maintainer information for KFuzzTest.

Changes since RFC v2:
- Per feedback from Ignat Korchagin a fuzz target has been defined for
  the load_script function in binfmt_script.c, and all fuzz targets are
  built with CONFIG_KFUZZTEST=y rather than a specialized configuration
  option per module.
- Per feedback from David Gow and Alexander Potapenko, KFuzzTest linkage
  definitions have been moved into the generic linkage header so that
  the framework isn't bound to x86_64.

Ethan Graham (10):
  mm/kasan: implement kasan_poison_range
  kfuzztest: add user-facing API and data structures
  kfuzztest: implement core module and input processing
  tools: add kfuzztest-bridge utility
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
  drivers/auxdisplay: add a KFuzzTest for parse_xy()
  fs/binfmt_script: add KFuzzTest target for load_script
  MAINTAINERS: add maintainer information for KFuzzTest

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 385 ++++++++++++++
 MAINTAINERS                                   |   8 +
 crypto/asymmetric_keys/Makefile               |   2 +
 crypto/asymmetric_keys/tests/Makefile         |   2 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  22 +
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  38 ++
 drivers/auxdisplay/charlcd.c                  |   8 +
 drivers/auxdisplay/tests/charlcd_kfuzz.c      |  20 +
 fs/binfmt_script.c                            |   8 +
 fs/tests/binfmt_script_kfuzz.c                |  51 ++
 include/asm-generic/vmlinux.lds.h             |  22 +-
 include/linux/kasan.h                         |  11 +
 include/linux/kfuzztest.h                     | 498 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 240 +++++++++
 lib/kfuzztest/parse.c                         | 204 +++++++
 mm/kasan/shadow.c                             |  34 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  71 +++
 samples/kfuzztest/underflow_on_buffer.c       |  59 +++
 tools/Makefile                                |  15 +-
 tools/kfuzztest-bridge/.gitignore             |   2 +
 tools/kfuzztest-bridge/Build                  |   6 +
 tools/kfuzztest-bridge/Makefile               |  48 ++
 tools/kfuzztest-bridge/bridge.c               | 103 ++++
 tools/kfuzztest-bridge/byte_buffer.c          |  87 +++
 tools/kfuzztest-bridge/byte_buffer.h          |  31 ++
 tools/kfuzztest-bridge/encoder.c              | 391 ++++++++++++++
 tools/kfuzztest-bridge/encoder.h              |  16 +
 tools/kfuzztest-bridge/input_lexer.c          | 242 +++++++++
 tools/kfuzztest-bridge/input_lexer.h          |  57 ++
 tools/kfuzztest-bridge/input_parser.c         | 397 ++++++++++++++
 tools/kfuzztest-bridge/input_parser.h         |  81 +++
 tools/kfuzztest-bridge/rand_stream.c          |  77 +++
 tools/kfuzztest-bridge/rand_stream.h          |  57 ++
 41 files changed, 3325 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
 create mode 100644 drivers/auxdisplay/tests/charlcd_kfuzz.c
 create mode 100644 fs/tests/binfmt_script_kfuzz.c
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/main.c
 create mode 100644 lib/kfuzztest/parse.c
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c
 create mode 100644 tools/kfuzztest-bridge/.gitignore
 create mode 100644 tools/kfuzztest-bridge/Build
 create mode 100644 tools/kfuzztest-bridge/Makefile
 create mode 100644 tools/kfuzztest-bridge/bridge.c
 create mode 100644 tools/kfuzztest-bridge/byte_buffer.c
 create mode 100644 tools/kfuzztest-bridge/byte_buffer.h
 create mode 100644 tools/kfuzztest-bridge/encoder.c
 create mode 100644 tools/kfuzztest-bridge/encoder.h
 create mode 100644 tools/kfuzztest-bridge/input_lexer.c
 create mode 100644 tools/kfuzztest-bridge/input_lexer.h
 create mode 100644 tools/kfuzztest-bridge/input_parser.c
 create mode 100644 tools/kfuzztest-bridge/input_parser.h
 create mode 100644 tools/kfuzztest-bridge/rand_stream.c
 create mode 100644 tools/kfuzztest-bridge/rand_stream.h

-- 
2.51.0.384.g4c02a37b29-goog


