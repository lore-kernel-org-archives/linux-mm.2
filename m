Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B69ACAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 14:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ADFB8E000C; Fri, 19 Sep 2025 10:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 684AE8E0001; Fri, 19 Sep 2025 10:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 599FE8E000C; Fri, 19 Sep 2025 10:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4628E8E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 10:58:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D457F1A06A5
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:02 +0000 (UTC)
X-FDA: 83906304804.14.B41AEB5
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf02.hostedemail.com (Postfix) with ESMTP id E85548000D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 14:58:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dcsa07Tw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758293881; a=rsa-sha256;
	cv=none;
	b=3kCL9GxEIpzGFDakLRoW7DTH1KG5kCIthMmsh4GCJISwvJm08qTcurYEOjD69tvp4Wg6i9
	+tdF38/gGUVD5ITAqZvW4Bd+hzdYAxMWCjxi8L4ZNuaVlOZFUdwMpH4mzUVtHfMm9x74pn
	icacZJNGr1UbCTbin/W4mep9Z97VG9Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dcsa07Tw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.53 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758293881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=gkRYzWYSGqW8b5cMZYzB+a2FlxSRz9tBtPdwTZuG88Q=;
	b=qE8oVx8Q+7XLqrfo7KJXYjjFKe0VkFuVZHj/zfpRq5hY8Hgd9bm6atWqczlaOUX/xr7HMb
	ChvgxNeqEIaD+WZVAXvLEAeHmdI6dT7OUAcRuVDm0vcqbMjJMwivT7EcfcmnVPsq+ueAGS
	TeL0soJZm4KNfr7D0ouFtc+5DloiiYE=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-3ee64bc6b85so946424f8f.3
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 07:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758293879; x=1758898679; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gkRYzWYSGqW8b5cMZYzB+a2FlxSRz9tBtPdwTZuG88Q=;
        b=Dcsa07TwKLkkf/8gYPomEaSbcqgQxCAZMpyKkh6gwqAPcBw8XJzf2eb9gRIHUZSGN9
         kplxLNGua/8S5Wx9OAcwOk74SseKYwjXw2npzQRcCAfAXPuGvJTRFRY06Prc2auqoCdV
         eep3RS4zM+KLWTDKiUq87YWIj9vB8RbTc7eroVoHGUaIPUtiwGkkl81zE2MEN6agrErN
         qUce59zJrdLLQHykTXnxQuBkoEOYvQ36RPGU+Cr+zvzwBq9xbzMYI4rsiIRCFE4pwFyH
         /55uUA7R34CbiicyObW3xuDl5rg+TiU5qxN2SHV32Vch2doC3f0D4agebYLKX1skmTfG
         8/xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758293879; x=1758898679;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gkRYzWYSGqW8b5cMZYzB+a2FlxSRz9tBtPdwTZuG88Q=;
        b=tfeS/iy5bNWlvU/bJgQ37n3SXRsB3nDpeaXdCiWImm6W77ywEKPnFUr5bfa2BJCTgs
         xm9zq+Erb3h9G7zEbFZy7/EaA2sUvmoNagDBt8AbaIpC78WQcl8AMPxz6FijvmNscV9a
         aNSN6bQ6yFeGJMyrO3qQ8o1UCFft85x+cOF4h6udRyORdnUVVzQPvk628AQRU49RrzUO
         XMYd+LNFk0X/DDWeDSCcyQmMc+/UhB2SWEB8N94TUe4DXRPxofqLJnXYuAZe4jZu0RkC
         HYnv4qGYcDrQcRUjrGyKTXw1YKfy+8ooWITe/tUVCC+ongIavhQ8g1XdTZV6dM7CI2Ah
         k59A==
X-Forwarded-Encrypted: i=1; AJvYcCXXLAM0RvgbLaHS5flvZ7/i78pKrI/rE3mgrfDNgG3yVaGrb6Bg2mFAWU63eQbu0S1ClwHajN9bIw==@kvack.org
X-Gm-Message-State: AOJu0YzMz/3OWXqXcm+1m0QwyriJzfsc682bRzv35kn9+0voiv6QBdv9
	GJB1Hf6NWAIIk8KJe1XT/D+BPxekIwu+gLRHaLARIzhJOUxMnZbasVI+
X-Gm-Gg: ASbGnctiYtB3ft0rVBTJ45k3B0+ysdLXgVla5sGnLLN5npKG93yyHDCrszLa0c1HClF
	QvTucc5XyBJC5fQYQbycpIRi/Cau64MK6xUSx3W4BWL2o8KSqJWuN2w07y8eq0MsLMZAxou4jeP
	+VEoOMQvXsZagr5b3vrlibHzW8nByYNgD430GdmBQDpIQDxSIoGB8u/7dIrPJ6w0uEVn4RmpQLG
	aQGu75obohLwwNS9LhOZFMNXk004cc3toZHnN2UGpcTBj8oYYAk8/OVENhbCsjbSMuhAZ4O+XJT
	ylMscfm89fsMwPCQiuJbWS7Ug6Xq+iJlSL3u75drfjWx0zy+WzixGcrk3YjE6QOZU052W4+/Hz4
	tapJpOtdInGujYWd7Li+WONHtIUEFhwcibDYmni54bwOIUS6Paq2YXPXN1wfhStZ6EQTV1Kw1ec
	/VeI6DBxWxTXKOeuY=
X-Google-Smtp-Source: AGHT+IEdudVdUm6YZvrWF2hjwiXm8E9sMaoH4gzwvAVRyn4SxIgwEo9osEfanV2V+L8caLBnEhd6kw==
X-Received: by 2002:a05:6000:605:b0:3ec:db87:e908 with SMTP id ffacd0b85a97d-3ee7da56fbdmr3112750f8f.7.1758293878859;
        Fri, 19 Sep 2025 07:57:58 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (124.62.78.34.bc.googleusercontent.com. [34.78.62.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbc7188sm8551386f8f.37.2025.09.19.07.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 07:57:58 -0700 (PDT)
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
	sj@kernel.org,
	tarasmadan@google.com
Subject: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
Date: Fri, 19 Sep 2025 14:57:40 +0000
Message-ID: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.470.ga7dc726c21-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E85548000D
X-Stat-Signature: mpzubbyao168ptoew3nczks6iyx3q19g
X-Rspam-User: 
X-HE-Tag: 1758293880-474682
X-HE-Meta: U2FsdGVkX19aMChEoPCdQgeqJdfBKEUkTF75nDSEcTqzGNquVA42sL12jxEWKjpUMwWriiVOAVcpRknx4/TXW9sZbRaA8qKRJJr9AqF/9l2OK0PjiApf1wXQjOd7J1s6MwGJ+Gq/8r0BnQLUWAfsGXKE2jkBrD5fxr2TpJMYPn/vlMG+M+rEsV8oLN6kLsfOnrEJffRDYp6no8JpHdG3t8LzvJbfkGfYjRpixUyc4CzTIzZyHayy1WjeOtNY+tI4Fus7jlZaxAIzy5HEnNlWHGg3QF57Lb90h+8iM39LxOtyqxw5AgMFzro90wnqk8nSEgawo0WRgMvKHqt5WNQs5OrKMf5Cw+I8Y1BBCcDT07YPWJ9fJqP21oluv78X69yPqtDhutuZQ2A9Fo7tgBFYyUitDm5jD4W3A8HggjQH0IIm1S8nZuY2cV3dqtO5MMbdakoR95w0dem5BgJC539+4n+IUgcFeD2VPjT0nsIBPnN7aSz4WV1I/nM62CJv654bVb3sINwldTSu/FxJfZVoDy8vs/acbIqY+DqaQKEA/ROH8qo9Hw2vwZmS7irOWDXY+nEC1ywBu/Jejc75U7OsDcqKy1U5bDfeszFkaAE5mO+bNrg7Q+J0oIv8wDsqzUoUteNe9NxJ01z5g7oIximFAdwTAP8rbUAUK3gs8uAzhwFvzBKioEWha2l+Ehk7QnqrGwNJOdWHbf02H3KQlMfSQEOMberkD6X42YkzJ90g+TaE0th/syIuOHoELh+tdwaFk7keeqHgwx/E/xckL4kJ7fffxopMWcZiLH+tN3rAaPgutil2YPJbozLDji2YN/pVS1SOCGAYyQ4hUG8sQkfPq84Z4+32Ikig5smQR7H5TtYGz65DxM2BR7dGmTSque29DqvPXUYJjhnBPBnX6l6K4j+GcdzEFUCH38WhAcVNIio7u1iAjC+tW8LFkTR+iyLNO4fqihZqpkFuR4JCdgX
 ZrVtcVmq
 gAFZRMiemv5LzlhUc893fbUAGiWsTOfWigQik1zcd7gl/Temaog43hKiBQxsO1osa00x5DxxuDTumZMCbIiN/0I1ROg26rURhjenvniau7BJKxlOlvh75v7C8LsrGEnqTCkrVZ817/H4C2zyu0HlWvccO+mQrEg+4vQXBz56AtfHODN0kbRBF8IHXvh6OK3Dfn/K7b4GtrEpLwZWgXHY2rUtdAxwOjPJEJzVpFIreJWYMT9BnqFtKrIbvIwBYUR40GGmY0j+oi3TyN8VhrJyIuHOZ0W+a5eVUKwlfg1LNKL2m0EUQgyY5xkwZA8QnVw2zZoUl72l3DJsJ8tsVthcy21DjAueCDhbOH1E/AJqpk8BIXnZ0EYowVWh8oepN4tvcUAR+haDa7J3+aykwDl9+p81UA2GONzCMsvM/slPg5CBwkL7bvWUIMRIzRUe5Apdq8NFNgEOJDDslshWIeqv5C3uCXL+kIosJEW6V
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

Changes since PR v1:
- Per feedback from SeongJae Park, move kfuzztest-bridge into the
  testing/tools directory, and update the Makefile accordingly.
- Per review from Alexander Potapenko, address some cleanup issues and
  nits.
- Fix build issues identified by the kernel test robot <lkp@intel.com>.

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
 crypto/asymmetric_keys/tests/Makefile         |   4 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  26 +
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  38 ++
 drivers/auxdisplay/charlcd.c                  |   8 +
 drivers/auxdisplay/tests/charlcd_kfuzz.c      |  20 +
 fs/binfmt_script.c                            |   8 +
 fs/tests/binfmt_script_kfuzz.c                |  58 ++
 include/asm-generic/vmlinux.lds.h             |  22 +-
 include/linux/kasan.h                         |  11 +
 include/linux/kfuzztest.h                     | 497 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 242 +++++++++
 lib/kfuzztest/parse.c                         | 204 +++++++
 mm/kasan/shadow.c                             |  34 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  71 +++
 samples/kfuzztest/underflow_on_buffer.c       |  59 +++
 tools/Makefile                                |  18 +-
 tools/testing/kfuzztest-bridge/.gitignore     |   2 +
 tools/testing/kfuzztest-bridge/Build          |   6 +
 tools/testing/kfuzztest-bridge/Makefile       |  49 ++
 tools/testing/kfuzztest-bridge/bridge.c       | 115 ++++
 tools/testing/kfuzztest-bridge/byte_buffer.c  |  85 +++
 tools/testing/kfuzztest-bridge/byte_buffer.h  |  31 ++
 tools/testing/kfuzztest-bridge/encoder.c      | 390 ++++++++++++++
 tools/testing/kfuzztest-bridge/encoder.h      |  16 +
 tools/testing/kfuzztest-bridge/input_lexer.c  | 256 +++++++++
 tools/testing/kfuzztest-bridge/input_lexer.h  |  58 ++
 tools/testing/kfuzztest-bridge/input_parser.c | 425 +++++++++++++++
 tools/testing/kfuzztest-bridge/input_parser.h |  82 +++
 tools/testing/kfuzztest-bridge/rand_stream.c  |  77 +++
 tools/testing/kfuzztest-bridge/rand_stream.h  |  57 ++
 41 files changed, 3399 insertions(+), 4 deletions(-)
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
 create mode 100644 tools/testing/kfuzztest-bridge/rand_stream.c
 create mode 100644 tools/testing/kfuzztest-bridge/rand_stream.h

-- 
2.51.0.470.ga7dc726c21-goog


