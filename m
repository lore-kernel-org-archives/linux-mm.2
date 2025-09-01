Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A424CA0FFF
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 16:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81AAA8E0003; Mon,  1 Sep 2025 12:43:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F2458E0002; Mon,  1 Sep 2025 12:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708788E0003; Mon,  1 Sep 2025 12:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5D68F8E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 12:43:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03FF85BF36
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:11 +0000 (UTC)
X-FDA: 83841251424.18.86DF0DC
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26631C000E
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 16:43:09 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bLgq3POk;
	spf=pass (imf10.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756744990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ElLDxS3ISbpc9W3XX626CI0E8tPaybmhnhLj5C8PR/U=;
	b=0hD9I31UgKuNkfiRBpr1sk3tJTqVEiibpVmo3tE+nasuY+VGM0ij3QGyeTqJjsayT2eE0w
	xicc9M8CLRJVQuHUogIJwBQc0uQTdi4T0arbyKAq7UdQmU+yjIrDcMzv+lRq3LpvTmPYrr
	yi1gNWWu8ft8voYfkBJlsOEaKvuR7ZY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bLgq3POk;
	spf=pass (imf10.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756744990; a=rsa-sha256;
	cv=none;
	b=7hTGNDgfcV+MW18+AuclFzdwqbQnnQNET/SThT58ErxmXX4oB4TBLP4dMJhtWku85o1UQR
	aqwXCKVTYxL35iBIjI5dYi/+5bMpLVgn8ejjTTazN58DK11GeAjxUfSWYDuH5Z1h+MSXpU
	LPD1UxJwJ1MVzDziXK3K/e5PzGJM7/E=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3c68ac7e18aso2905535f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 09:43:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756744988; x=1757349788; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ElLDxS3ISbpc9W3XX626CI0E8tPaybmhnhLj5C8PR/U=;
        b=bLgq3POkdiuvb4I/VrrmraTrOVsbjWT4fMkroSjNF54FbPgT5Z7kS9Zwq5LLuYdYdO
         AHLBjBp9z2UJ2uIzony/XX6VBWqHY4ZKzhBeUPpo/+RbrSbSArKV9yoFEJ/tx8rLF1of
         XHyu51n+TR7Sgpx6eAWrk8U3JH4QUrTTMlicsnqDwC5jTPeQaIfQfOEeZRTJWw812uvq
         jhRJeL2pKDohRAvfCnvju3n3mZDGZXKx+Tn6aQJ8Zd2V3HyqhYsaTK5pco+u0zosmCgz
         4USTutKqe+wwDPAWyGyFqPZLLEKfd+5e0wStvCTq/juUxGJRJX/UCbZSs/XRVFVTJ1sD
         vDCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756744988; x=1757349788;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElLDxS3ISbpc9W3XX626CI0E8tPaybmhnhLj5C8PR/U=;
        b=O8/11RTM3el/05fqJBlhxnlgVzdb4XYlnrp+IaIS0UAwH1ALfsSp4dA4C6CEVCkG9/
         oogw0ewx/m/DUfkUdCTDezgPvQXPSQ5EOnvWAPPcn8orwiJMBu/UXUmPcuWS5fGdgMmJ
         3gAA/SFyXQYstlWPovdHKtAZ6WrwkRLIWBqRXKM9zfzKqEGrT1mnqHjWC43e/mwCHIZM
         2sQaCs3Mtr519EXYaCrvCfcJOTAFEkNcBfaXMLYvmKGSYen5WuRsmYsFUIAcpJoQNgZc
         166IIOggiAW0ccgWvlN3ZlZ26G7n4XiqTJNfW1MCYfdzi0rze/5IooyFqBxWx4W9Cl9T
         s0Og==
X-Forwarded-Encrypted: i=1; AJvYcCWmbptVzDRIuqzpNKFdHBN7/fwa50utn7Qzk5EfXFVIZl9QlLf1IxbjN5+Zq1txG3qvN0jsVVq7AQ==@kvack.org
X-Gm-Message-State: AOJu0YxvArqdwx5j/nmJAlA13CYrTFxb/pBRcPX9SB3OJ+TBnwXLEJu9
	8ShzqzTq4g19CgXQEDV2bBn0wLEf7dligtic5ZcBNk90CP71OdjzisTK
X-Gm-Gg: ASbGncvVTLTo05pBbj3/S2AvKny7fSVDYYpdKHaH+1ZiYbxykbzx1OnQPaGmyIuMngi
	fpXqFQJYbNQIlpniKuVXq5qlKF1pV3KDuDndW5QZ6o8QchXU/E7nDL64o0/uPEUGxbaJ+H4z4gN
	zw/OGftgpwARMzKcCYKZzj+2wO1lW7Abt/3lzLnrbHhvsNDf+9+7cstMP733Cf/AXdjAjg1Aorj
	EOPOJ19S0RUZjv+n8aJpVxoQU8OkJtN5oughpIFwqkKvaptuvrVDDTHkZ379KEuS15dUarMxAX4
	G0dIzKuN7lzoF8sXIft0RPbXlYFofouNmBfa4vx+mYfua+0VTW4elhTZqbuuwsg2H3p82fnGmeV
	//uabUixU6y6IC2kls0FaTRg5FOOGio3ICNrkXaUVzHqT8U3fKE5O66Fd18w1ODHFqzijyU+f9p
	hc1WM0CTUAibU9pOC8bg==
X-Google-Smtp-Source: AGHT+IHOSulzpXxvv8O/HIyZfodfZK0vimfSFP+L4jhbIEF86uvWEaupB/ivpnTlnTthHjg4SBGoAg==
X-Received: by 2002:a5d:5f50:0:b0:3b7:8da6:1bb4 with SMTP id ffacd0b85a97d-3d1df53be89mr6492296f8f.58.1756744988266;
        Mon, 01 Sep 2025 09:43:08 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (140.225.77.34.bc.googleusercontent.com. [34.77.225.140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf274dde69sm15955362f8f.14.2025.09.01.09.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Sep 2025 09:43:07 -0700 (PDT)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethangraham@google.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	brendan.higgins@linux.dev,
	davidgow@google.com,
	dvyukov@google.com,
	jannh@google.com,
	elver@google.com,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com,
	kasan-dev@googlegroups.com,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	dhowells@redhat.com,
	lukas@wunner.de,
	ignat@cloudflare.com,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org
Subject: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
Date: Mon,  1 Sep 2025 16:42:05 +0000
Message-ID: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.318.gd7df087d1a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26631C000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: d1a7b35oxjo43xyu787gjuon33jg6urg
X-HE-Tag: 1756744989-918277
X-HE-Meta: U2FsdGVkX1+E0556pL1a4bckKgormL4FJE/yGzbZRBWJHgwdocBUwlaHjL7EEY92AQISrBtVaKLFKZ5Q1UQ2Wd1lsdtytDFE9r5axyAVfQFfJ0/4SiTeLBlgzKivmn9E0Okly61C/6FkY2ymmziEI1d5Mvk+exODtJxhnRklAtk1SzHF64b5Z8+eSdr+nHKeiO1e1t7ExHWjWZWF7543bO0QlrWicJmSzgmT4qZ41U8weZSdLg1guGhJzY0K8DOMJL9lPnC+B5GEsXQlmfkiEUA0KgkMTmvo++xJLr4U8TrCNOvvyXlTqozRdxja+9okRrb/d+Eh+9bq3E1zE+els/BLExpdNE1Kzlb+pocfkjB3LLPnb5nPyQHFBLAtQWuA9tNOnBqaUUR52PwGhfv2pXK4bnXQdCqhxJKPGFisKzEA3eXLge9k/M8TXMo8zgwFk3Nk0pxUk2k5MR7zmWDQFOjBYIE79g1itu4QL94LGPz64ZprBeOTaYayRnEZMjuapPZ/wD5cKUI4VKIA9PilAyZ/KAJlhi1j+huggI9XJV6qalOWjpb7lDzw+/eKsAmMXW2d/JhuIpjGezFN3ttuTLSAuKuU/ehgOaJ3w9MNOih1+vPmdFO3tZsfka+5YmnGbPkh/IhGztkY3MFM8pxfSMH6oS5oXPdOEk3yUI/zo0RaBkOYaVKhSEFUtYlSgYbf0p3LeOZVUcejjyxx5YGp7zlqqZcrekjTflTF2WQyIMDVnYE0ZkvblIz1I1yO+njv7GfPjSPPIXCixbp5LjWoGRgv8S1Wdy4Yk9OMgHamEuviCrO/VwN/U3YOaWMuIOKVjgxJAdttORulmdZK/eikXrabAINwNKQHupWHUZarBMZDzcJu6HaWcAJfEXpKiiLV58f9QorD9MvFTHCTpX1q8Macvm7LTd+8dQ7sQk/fgMZoQLPGqoFDQw4LWQnSfRnyfgIrhgIUG1O/H76iXkr
 6hKkzbYo
 ZGGYPD12x/zredU4uYhNRHKY/YXkMfKRvGJhWhy3PPhtLwN7rf3hr4KWqSuIu+YfZxJGxU5iaslf8OHlKqWhafwyufiuw8lefDS2QKnOH3yyocczvh/Z8P+fukUCwOyIJz0z8UYUTkRj4vgZqoUgE5kxPjvKtGos9er/TKqf2p4jpHCANNtFvCV02Sm18W8Lg0WA3qUC/VYNEdp/4c27rhRydrS2kebY6+o5wJzL4sG5T7zuZEr3Ss9msdgaFl98wftdjrNjwvTtFMezDa0Z/PsuXjMdLVQ8917fosMONBZrXTLm6YqA4ShnmIfY1Ghm/Ye+k8FzebRLqNrE87EzsCU7br6K/B0wRO9a+qUdyOjYCDxIXn7mZx1Hj/x764fPDO6sdq+fzrTbyJBO//LmD9YScp/RgWZq0F5fXGr/hRXoFy0/pXNq/O6BlyECo6IC5IgH9
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

-ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen);
+ret = asn1_ber_decoder(&pkcs7_decoder, ctx, data, datalen + 1);

A syzkaller instance fuzzing the new test_pkcs7_parse_message target
introduced in patch 7 successfully triggered the bug inside of
asn1_ber_decoder in under a 30 seconds from a cold start.

This RFC continues to seek feedback on the overall design of KFuzzTest
and the minor changes made in V2. We are particularly interested in
comments on:
- The ergonomics of the API for defining fuzz targets.
- The overall workflow and usability for a developer adding and running
  a new in-kernel fuzz target.
- The high-level architecture.

The patch series is structured as follows:
- Patch 1 adds and exposes a new KASAN function needed by KFuzzTest.
- Patch 2 introduces the core KFuzzTest API and data structures.
- Patch 3 adds the runtime implementation for the framework.
- Patch 4 adds a tool for sending structured inputs into a fuzz target.
- Patch 5 adds documentation.
- Patch 6 provides example fuzz targets.
- Patch 7 defines fuzz targets for real kernel functions.

Changes in v2:
- Per feedback from Eric Biggers and Ignat Korchagin, move the /crypto
  fuzz target samples into a new /crypto/tests directory to separate
  them from the functional source code.
- Per feedback from David Gow and Marco Elver, add the kfuzztest-bridge
  tool to generate structured inputs for fuzz targets. The tool can
  populate parts of the input structure with data from a file, enabling
  both simple randomized fuzzing (e.g, using /dev/urandom) and
  targeted testing with file-based inputs.

We would like to thank David Gow for his detailed feedback regarding the
potential integration with KUnit. The v1 discussion highlighted three
potential paths: making KFuzzTests a special case of KUnit tests, sharing
implementation details in a common library, or keeping the frameworks
separate while ensuring API familiarity.

Following a productive conversation with David, we are moving forward
with the third option for now. While tighter integration is an
attractive long-term goal, we believe the most practical first step is
to establish KFuzzTest as a valuable, standalone framework. This avoids
premature abstraction (e.g., creating a shared library with only one
user) and allows KFuzzTest's design to stabilize based on its specific
focus: fuzzing with complex, structured inputs.

Ethan Graham (7):
  mm/kasan: implement kasan_poison_range
  kfuzztest: add user-facing API and data structures
  kfuzztest: implement core module and input processing
  tools: add kfuzztest-bridge utility
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 371 +++++++++++++
 arch/x86/kernel/vmlinux.lds.S                 |  22 +
 crypto/asymmetric_keys/Kconfig                |  15 +
 crypto/asymmetric_keys/Makefile               |   2 +
 crypto/asymmetric_keys/tests/Makefile         |   2 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  22 +
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  38 ++
 include/linux/kasan.h                         |  16 +
 include/linux/kfuzztest.h                     | 508 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 163 ++++++
 lib/kfuzztest/parse.c                         | 208 +++++++
 mm/kasan/shadow.c                             |  31 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  52 ++
 samples/kfuzztest/underflow_on_buffer.c       |  41 ++
 tools/Makefile                                |  15 +-
 tools/kfuzztest-bridge/.gitignore             |   2 +
 tools/kfuzztest-bridge/Build                  |   6 +
 tools/kfuzztest-bridge/Makefile               |  48 ++
 tools/kfuzztest-bridge/bridge.c               |  93 ++++
 tools/kfuzztest-bridge/byte_buffer.c          |  87 +++
 tools/kfuzztest-bridge/byte_buffer.h          |  31 ++
 tools/kfuzztest-bridge/encoder.c              | 356 ++++++++++++
 tools/kfuzztest-bridge/encoder.h              |  16 +
 tools/kfuzztest-bridge/input_lexer.c          | 243 +++++++++
 tools/kfuzztest-bridge/input_lexer.h          |  57 ++
 tools/kfuzztest-bridge/input_parser.c         | 373 +++++++++++++
 tools/kfuzztest-bridge/input_parser.h         |  79 +++
 tools/kfuzztest-bridge/rand_stream.c          |  61 +++
 tools/kfuzztest-bridge/rand_stream.h          |  46 ++
 37 files changed, 3037 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
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
2.51.0.318.gd7df087d1a-goog


