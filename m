Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58092C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 13:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5C7190006F; Wed, 13 Aug 2025 09:38:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0CF5900044; Wed, 13 Aug 2025 09:38:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C22C090006F; Wed, 13 Aug 2025 09:38:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF667900044
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 09:38:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B8271A0397
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:42 +0000 (UTC)
X-FDA: 83771839284.27.AB267BE
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9EA14140004
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:38:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PlQx4CqA;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755092320;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0Nw3bTX6xGGMKWExTDEEfa2WPWmKzMn7BL7inlmF4mY=;
	b=LZzxyVT5rnyCNIIqDTRHBbCS9JuEWFUwzSqm/yoZSW14llLZLCJUUTMfa5CgZPOgmFTSxO
	ICs9ODrl4mPUB+1nIhajqc60OAKy70ot9QsfmrT5XUMgknEX1LawD4ZXHSDuwR1vpK2trh
	o4S2x9cqN7h9X46M0JAcMb59qLF7788=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PlQx4CqA;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755092320; a=rsa-sha256;
	cv=none;
	b=RCjzr/ZoNt4cL6ZERBjWLrlEqTQRzvlbOYFkrkpfFOZR8LVvm7Dki5e5a9hQuEscnYIAHw
	tmZD6l/WMY24VbNi1DCLN3/XbgmqxjP04OKP4nkzh22hkINwnuwsTpmPg1NXPNsmsI7izS
	eKOXJegIY4eYnDX7X4exkpSgCBGvumQ=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3b7825e2775so6050423f8f.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 06:38:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755092319; x=1755697119; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Nw3bTX6xGGMKWExTDEEfa2WPWmKzMn7BL7inlmF4mY=;
        b=PlQx4CqA4k/vvE/FRSyzMyhTF67BUKIIJOmHad9Cu2jh12F2CKK1I55lzCEM1yz8L6
         1heCkC4+BO8wTrn3+xM9F4a250fyvtvu8DB520/sZ/d5V8nyQN5a1QJnBuN5m/5z6d/P
         gCotWIdRTggUCjCl0DUEPMUx5joDVnkMGjNbf99UWmsC2ol5a44rDRORJxbUI6V7FvdK
         /ecqNK0fYuW0hF2fRXdvIQAjXLJeI8BQT0BvM3+x4A3ewWNlF+1q4PakIcPdc0uVsMv7
         y5NQsikp0NxZv/DEmCraLEUGQdCmKqpxLO/QeeUivaPwFaRM8XijryqJoA0wTZmaj/lT
         ZKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755092319; x=1755697119;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Nw3bTX6xGGMKWExTDEEfa2WPWmKzMn7BL7inlmF4mY=;
        b=QzYAfw6dIdCPk7u9aBylT+8jPHPRXmwTBv2Tb6hep/uG43hM6gSB4BqMFK9SkF03Zi
         xi5s10npPu39xwX2l1YIRKODW6/Z7svOWbrqjXvDyKPTvhxFyPNoJId33YwAjQkQG4pB
         eTipm6HOvFy0VWKZdFwkg7x5ao0sbkC89rCf3jtIULCrvdQCSKB1MXpRX9LPMcivtucK
         1j/rsoccUP+EdV3XSCP/3ets6G5xyQi3Xijc9Oq/LjijymoTGpX72ASUwIewkcSjhJgC
         9Jaqlc0F9CjwYr7ASe8DFQP3r80ba7lt773d5d3JP0k8LzEtoT9bqF6aptzgNwcSLE3x
         qO2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWMPGJFxPc8dc/L88xwwKnUJ0P3CpBznDCxx9/cW7+GhsqHbdHmTAsvxdwA0dHeJckJ+dx/aJMuVg==@kvack.org
X-Gm-Message-State: AOJu0YybzZOP/+Sot8f6aYu+S5b4FYHOC55//qelXqypuwRIDcE2BNwZ
	hTlBCZVFvRqgX5o0RgHpaNi4d86/ABjFeBlAWqmHcb6fu767NZmFxJMz
X-Gm-Gg: ASbGncsjgfCh088+MOdkcX+TkOBjxf0vz/EFprJ0fHoQGUF4MrJ8K3yDeNrbvvPsEVY
	yEYj4MLurpmgyi8gMpT3T97VOrnUMpXU7XoYNGOf4ynHM+MVtktNL9XasynYIVRqdYhYo6RtqTA
	tRWQa5mdLw2pQnGuQNuaeI/ANm+78u7Fk83HE+d7yAdCXllMXvZx02TDNAMinwOOXqhA8rLK4rI
	TOodlxtrglOUWXov5BYbqiHzBCfKrzr15lKwe/2SdyitXVuU7BSXN8Tt+eaIGW33ofwRrycGSJd
	nV0kgDEAFouBI8vri+ZzgT4k5l4yZx1549J2ywuICXlkZOl60EluBFqEtLuVuwrnG+/a9H6Jknz
	QCY7IEYeRsNB7p+FzfYZqg0UE8hqDd7FEuEczIsN/YvhG40TUxEYuKiNemjNrhz2f9lAYWDdWzj
	uEqEZ77rIuIwe00m9pEPFgyMD4cA==
X-Google-Smtp-Source: AGHT+IE6zoV9XOpaBmQyCC834tm7Md5Dm0cgWxqTRi9Ac7HS3234LXrNY+vyp2Hs43MmMgcvyJI53w==
X-Received: by 2002:a05:6000:188e:b0:3a3:6e85:a529 with SMTP id ffacd0b85a97d-3b917edcf84mr2417374f8f.51.1755092318802;
        Wed, 13 Aug 2025 06:38:38 -0700 (PDT)
Received: from xl-nested.c.googlers.com.com (87.220.76.34.bc.googleusercontent.com. [34.76.220.87])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b8f8b1bc81sm25677444f8f.69.2025.08.13.06.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:38:38 -0700 (PDT)
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
	linux-mm@kvack.org
Subject: [PATCH v1 RFC 0/6] kfuzztest: a new kernel fuzzing framework
Date: Wed, 13 Aug 2025 13:38:06 +0000
Message-ID: <20250813133812.926145-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0.rc0.205.g4a044479a3-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4iponc6cwkrme1wa44ykkzcnswy5imuz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EA14140004
X-Rspamd-Server: rspam05
X-HE-Tag: 1755092320-967816
X-HE-Meta: U2FsdGVkX1+d706DTbRvHzAJHbQqT1uBw4irD+jVB9o5r7lmnaL5nf9Y6OOQ8OSi2LZVZqNQ5BaaPbgVdpLInW50ZrsYdAOoTYU/kbrVxF5qAiNRzMeiaaQdZjo16GtActnNEOUQ154bzj8X1pSq9SLnGWkXGX+V/7QPu+0pafKrlZITErBXMKm9lqsrChAGhdbL06pN6PIpeDk3qJqyOulf/29KEUNREFdt4Y4BFegLDMNiwow9oUdHhYFKW5be8lJMPqLv9dnnxoQ4Ix2mKE1AVXrDZDL9Ok2IqMZAj0FmW1OWwAScD0/04hgdcL0XpwO8o+EGsFtuTZ4OIZLWT38wjvQ7r7KandEBRjiikH7CLaxishiQMxZwk/L5LGIj+s+RCKLR1Xo/QGT4LjTAhzvTF1x5Lu0aYmkOLJlCLE0eIAZMFvlgFhyo2QNGhdMTfxYEbYzZb86fgGiFdaRyLDezRhvqoCkPYNZLH7NnSco1S65Gr8FbHLvwO75tvHg/nqhL0N6ioEnd4sR0HjmBcTcQJOgqM8UYFoXL9vSgXkNeLEbNqAPNekIUaKkVqCawR1ERzZPgiJpQ1jjL7pyQES7RpW+VWW97cHotkFoVRw2dGUVGJmKpVfQNNv+N+MB80ppBTmgWdh3sQXPxPltDuu4du9FsoxxqRnrUJDb2OpQyVNOz78RyFVIKOsuPzqVUPB2XWcnTt1GaBfsMB27ASQGMP6CoUh5dCRqyi2HWd713ZN+M6G4xLmgKMc5RBgfuz576C0E7qOgyILdRPXp1Nix0i25BiD6KvE30cnQEV2Wx9zJbZienos3Yrko14ij905MuwOn/tIOPbcj3t98MrJOqkESIQwCsOwJ4BaTCw1Rd9Dlg+yAqDBevEeumvcZqz5epr1rWU16lLFJGw3gSE0WTKdpw2lq8MpoILyEoU3wTTj+2Qvw4XVcfpyAmeqz48mbNC5lCDuhwZrk2kd+
 i3O1MDua
 7mw+hUdTNunJsAqT+rrfPT2jkr2KGkZMV2lDNGQ/e6vQxRUo9ObiQYbDeig2XoU8lp01B+BE/agYHm9ZRdBFf/qsyBLoNw7f4CK3ep3Aalaa079EMM/xgaLjtMt+RCKUtJYJS6tRtSDn97h3NCXAf+gRFxWNuwoIH3Lm++ImpVlwNC527WckMSK10Th2ezrt0RNiZDPj0FWzpgqGO7uvIu1jIBRu6EbbPfcHD0eq5s8JKlewFiTXbF7uqKMFTC8z94TYklayMO/HQCLGphDx7Y2OhdtcH1UhP1/Eu0mKR0LoK816tQfEPQyRhGAg11jQP2H1hiB0YaCIOLdtDkc6sgCh9Uac0Qd1sS51Ze1qla980Tard+GyQ3C64wfQueYesbRNax6pktrjIM326ZZ8WMJSv9N072envxw603WeyHDVTu3XwauHrN0ilumJxzJ7CDx9F
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
introduced in patch 6 successfully triggered the bug inside of
asn1_ber_decoder in under a 30 seconds from a cold start.

This series is an RFC to gather early feedback on the overall design and
approach. We are particularly interested in feedback on:
- The general utility of such a framework.
- The design of the binary serialization format.
- The use of ELF sections for metadata and discovery.

The patch series is structured as follows:
- Patch 1 adds and exposes a new KASAN function needed by KFuzzTest.
- Patch 2 introduces the core KFuzzTest API and data structures.
- Patch 3 adds the runtime implementation for the framework.
- Patch 4 adds documentation.
- Patch 5 provides example fuzz targets.
- Patch 6 defines fuzz targets for real kernel functions.

Ethan Graham (6):
  mm/kasan: implement kasan_poison_range
  kfuzztest: add user-facing API and data structures
  kfuzztest: implement core module and input processing
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 279 ++++++++++
 arch/x86/kernel/vmlinux.lds.S                 |  22 +
 crypto/asymmetric_keys/pkcs7_parser.c         |  15 +
 crypto/rsa_helper.c                           |  29 +
 include/linux/kasan.h                         |  16 +
 include/linux/kfuzztest.h                     | 508 ++++++++++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  20 +
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/main.c                          | 161 ++++++
 lib/kfuzztest/parse.c                         | 208 +++++++
 mm/kasan/shadow.c                             |  31 ++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/overflow_on_nested_buffer.c |  52 ++
 samples/kfuzztest/underflow_on_buffer.c       |  41 ++
 19 files changed, 1401 insertions(+)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/main.c
 create mode 100644 lib/kfuzztest/parse.c
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/overflow_on_nested_buffer.c
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

-- 
2.51.0.rc0.205.g4a044479a3-goog


