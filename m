Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8026ACF45C5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 19:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E97986B0088; Mon, 12 Jan 2026 14:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6EF26B0089; Mon, 12 Jan 2026 14:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6EA16B008C; Mon, 12 Jan 2026 14:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C73516B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 14:28:43 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95D6B1AEC2C
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:43 +0000 (UTC)
X-FDA: 84324298926.25.857B61D
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id B44C2100011
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 19:28:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E2ZfJTM/";
	spf=pass (imf14.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768246121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a8RC3/jOXChgUFu7fWCHeysuCImlO6A97UJW0JalKx0=;
	b=YX5uq7ygB4OMXaEc25WrKsM5rY3OHQYdwShArk5j4AE8vDLdEcHJYRMGlyKGwP2Pxcfdn3
	3CVirpolYNe5BZ65QfBglogE8yE2/r1SyzlMw3xSyd0Lv9C2An1ex+VGerCt71VcUl80Ng
	sdMbA5EW4JKMfiwy45fQNKDFs2Pt8d0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="E2ZfJTM/";
	spf=pass (imf14.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768246121; a=rsa-sha256;
	cv=none;
	b=01WjRPIjeRQ8sirfnPofjoDlpyHPkB2lXmetScZ9l/a/ToZY0cLCEHx5sEO7/4MmLxWI6Q
	6MgE++VvucMnMORDGBDFksl/75fQ/WWpUZ+TVnmIxiEvg+gnKW5Sn5wd34XN3IhXvXVDaV
	auWpoNQwCnMoCL08RbxRJTBzK7Xd2zE=
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-650854c473fso1930414a12.1
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:28:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768246120; x=1768850920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a8RC3/jOXChgUFu7fWCHeysuCImlO6A97UJW0JalKx0=;
        b=E2ZfJTM/Owpey8nKNRlM8HJBUZCfrrlKQouAdCPVkpym+4AJBy0xRKcR4vEm8OdS2G
         eCCsWTLV6YiSCBl6hMUapHnbl0aYivqG2mv5jmLIiTm80K+aNn/rX73+UKtTTuvu94FW
         jEej8bL+BOHKRtz200rSwH2Xcz1BPf7IUqmsKqOuruydjp+Nwt11R4vAU3FSXKm4duRm
         XBZ7EHbitQLwIXPY5cwu4bYJK8OYqk5zGI2UPKEP4wHake0QbuB4dI+rkRLqv3K6z8Gi
         jiifun/T3EqggUrpQf4SaBKREqYqj8kejmNBPOO+5ijuzmpeUPuyEtdU1fZmWgt2Kc8W
         gG9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768246120; x=1768850920;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a8RC3/jOXChgUFu7fWCHeysuCImlO6A97UJW0JalKx0=;
        b=ccH1fGUFJa+7IySYKOPtfPTCtQG/5KB8CB2qC4Z4Vub5cKxPDIMFqjgZXNIj+lQW6n
         /BhD5WX0Ii0vwR2DI4g5QYtVYVpQc8zRMhf3PqluWhY8+th5kh0uZukJN5vWDkFcvKke
         I4r3hbZCA0KGSOaERTMsZchLknBiynqWfX4yyn3D87QvtJXDX9hQ9ZGtCjbFKK5BEA75
         bpOFUsiM6sNdcBwISaprKzgWCf5WxsVhQAGfAFT+HlujngtmDIWcI0PqAuZhTh3U3pva
         gNb0yRrnpFfK/R7RFFLTkaCqh4IHdD2+VnivV4VrFJyaMksju6TSKWPGiir+yj05pSw5
         RPZg==
X-Forwarded-Encrypted: i=1; AJvYcCUneq+JVqneR+ZBp8+zeFzLogylMSNyXjLbx8E1v1GTO1xCWT1/I6i80/Cks8ZMpJeKajaRtPL6ng==@kvack.org
X-Gm-Message-State: AOJu0YwrUXSC3QJG+TEwFMfc7rq3geklgoE0AnIodrnYFP7kyLNRFdWY
	bDeq7g23XhJ9pAXc5Q8oFLVUUVpgoNiprzo0juKtoFCWNaDX9lhfe2/L
X-Gm-Gg: AY/fxX60HnoNIYU767KZQJEdLbWOaAMOJ6LaK1oHpVDgdQilTavJQ0LQ78PjOOFYeec
	mN/6S0P5MeZkmpyJ4OmzrdGXKsjpG8ezZ0BW2YhTCw4HNXZ7YF149qXWUykoFqeh14NKlDLOgMz
	lXuVvAjBdH62jSRw6szLfPKNG/4QKPCPqumrIzWqrV/zWeu+qKRZ3a7iuhkM7taBwoyxOUY5bAV
	s8tGoPZbRkF1hUzwENVzOcV9/ANmAUDFrsEuy9TB5SNpgVC1Na8BHJxZYlJ7IKjw9F7OrrFo83o
	G+yqNgtpoz3sd6txiCs2ZnCGfDsNdz3YvbqtTWZYCVvYQ0q1crcKdJrsVaqFHFshtqzqUU5HFFK
	aDN3NhjTpBxSXiukGRx0a7EL8S7I1cOkW3uneMn3VkCDp9y01PWq9JHU3+k126tPBGKl952zH4P
	PDw5FvAsFsEGjF8cAeMVTOqqQmYOK+WMb2HLQ5PkrKOILLKFqE7w==
X-Received: by 2002:a05:6402:326:b0:641:88ff:10ad with SMTP id 4fb4d7f45d1cf-652e58769e9mr330944a12.14.1768246119781;
        Mon, 12 Jan 2026 11:28:39 -0800 (PST)
Received: from ethan-tp (xdsl-31-164-106-179.adslplus.ch. [31.164.106.179])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6507bf667fcsm18108959a12.29.2026.01.12.11.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 11:28:38 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	ebiggers@kernel.org,
	elver@google.com,
	gregkh@linuxfoundation.org,
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
	mcgrof@kernel.org,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	skhan@linuxfoundation.org,
	tarasmadan@google.com,
	wentaoz5@illinois.edu
Subject: [PATCH v4 0/6] KFuzzTest: a new kernel fuzzing framework 
Date: Mon, 12 Jan 2026 20:28:21 +0100
Message-ID: <20260112192827.25989-1-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B44C2100011
X-Stat-Signature: eke8dazgywjchqu6d3ngp1zwjx96srs6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768246121-189726
X-HE-Meta: U2FsdGVkX19xBkPn2FMR6e2bqov2QaCncySSvFZjETsge/Py+76e9UGvDwB9Qha5wQF1jbPQdbEzE51cLruBpsYjAa9rS6K3/bYr6/KQurRKvMSoSDHcR385z3+edMa6Vgws+4/DPJDIC+VgIXb7zxF2Cksa2MvYvywJmoBFXdllaPKSP8q/hyRaA3KQ2j2LOX5H8biQvmOjNy63GzDtTECEKNh341RQlVxyxj4FhdkKvazTKUUzXuchF5TY4NQp0XLQo1TM5kWZTqrfKc5zX7ERsj08C428z8PmpoVCucj0LckScRJexjbERhkh663YhCW2cgyQf3u70JoS0R60cvJumY6MeSmX7HjfPAEyxtaNDS8I7nw5Fz0zLp0HyzozwxUXP11uCtF+cUwopCdGRWEbHwYRPHa7MYKN7CUK9QLOiqjylmLdKB0JIhEnLLKntF4KH4XPAa3xvzjXuPc9pN+DRZyLQ6Lb4GdHXNBBh3U6VDWOlKgGBL7sOGtczqtvoZKw6ldiUpFTJeoFmPqZZwgng4cJHfy8ET1kxG7HQLlhHK5lZZ48nMhXkeB7M4atkcYGRrfpc4URPrxplKJXXiOOoykC6qnPp1q43HsozFKP+kUCBLme8Oh6u9sHr1Cj887Co1kAJQGoGjgTgqE5yJVNrN+EkX8GWrPxzpjq81GUYu0trQZYE6RKHISBBEYH60uKcKAmssoNdD34/pZHzzrUpSoMs6IkgvbMgfNq9p/Ke6bsy4A9OjURJNyToPPpffyOhPrmXMeaDtOCBYIL53Mq0BaIEwR5wZSirLmFWHWrhErIjxNXUwWM9kcI4yYdDGbtSRj+gZBuJDhTuHC1XWecbbI1poWeCNWYR/KGQjrATv2ppquiEu9q9GtqzP01ReTdc79L5nPyAtDAGNT7DLefwpkIirLG/sqyvZZpyoeXqN323eGZqffx+SjscZL15pVLLEVuYmdvoGAvDKb
 Zq49ROnF
 AH3vzE/LcaRAHoFFMGoIwCfBFJ/buNazZYR84ilDO416tgLoRIMCM1KoN1YDuplMR24e6lTXLNJXmmoIv7aAiMWk+Jw1DTdBxrQW1wM5a8iZ/DvFIUC4E+t8RMhrVjqt8fb1XLrxoYYh4S9CVvwe1tIf0mc6LVjZrLBn+1NjuF5CsnMbhv9STWEeqhdgT0bbVikTfB+8ejtnjNfJaIP4wwKKHSUevfFmP/ftt2Z3imWzV4wi5SLNGNf7k/SvzMn5dNC3a+uP8iJQFGSZhO/rCvKblyNt7EePkWrw6b+Wgz2sn9wzDIMgvs3NMatfbTvaPDGj9RBO2/7xizgCnRfFF4uhB7g1gKmKSfBrjPZHXZRLZwrWObM/st7M8Visvviooaq2GTH+DAABXmQu3JLbB8o6rrcxwzCDsudZ8UrC6edrUpKPgvaoow4hU6IrpuyPmt/OAJiFUl3Rk3uYnwnb3chyNadvqUply3koMRnvQbPVAxObf/5Z/hWezwrBufU1kxLe77ZxrBUu+ZnyMU+S5iL4vbCYvT/eH5r0swDpGvkdwUB70l9gpoK5hLyNalhrs6sGBeesBi1XJ+3SyttwRyznzGhGgPlvLE0bEgtXnSdFbGEqGzR3EEUhGGA==
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
dependencies be stubbed out.

Following feedback from the Linux Plumbers Conference and mailing list
discussions, this version of the framework has been significantly
simplified. It now focuses exclusively on handling raw binary inputs,
removing the complexity of the custom serialization format and DWARF
parsing found in previous iterations.

The core design consists of two main parts:
1. The `FUZZ_TEST_SIMPLE(name)` macro, which allows developers to define
   a fuzz test that accepts a buffer and its length.
2. A simplified debugfs interface that allows userspace fuzzers (or
   simple command-line tools) to pass raw binary blobs directly to the
   target function.

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

This patch series is structured as follows:
- Patch 1 introduces the core KFuzzTest API, including the main
  FUZZ_TEST_SIMPLE macro.
- Patch 2 adds the runtime implementation for the framework
- Patch 3 adds documentation.
- Patch 4 provides sample fuzz targets.
- Patch 5 defines fuzz targets for several functions in crypto/.
- Patch 6 adds maintainer information for KFuzzTest.

Changes since PR v3:
- Major simplification of the architecture, removing the complex
  `FUZZ_TEST` macro, the custom serialization format, domain
  constraints, annotations, and associated DWARF metadata regions.
- The framework now only supports `FUZZ_TEST_SIMPLE` targets, which
  accept raw binary data.
- Removed the userspace bridge tool as it is no longer required for
  serializing inputs.
- Updated documentation and samples to reflect the "simple-only"
  approach.

Ethan Graham (6):
  kfuzztest: add user-facing API and data structures
  kfuzztest: implement core module and input processing
  kfuzztest: add ReST documentation
  kfuzztest: add KFuzzTest sample fuzz targets
  crypto: implement KFuzzTest targets for PKCS7 and RSA parsing
  MAINTAINERS: add maintainer information for KFuzzTest

 Documentation/dev-tools/index.rst             |   1 +
 Documentation/dev-tools/kfuzztest.rst         | 152 ++++++++++++++++++
 MAINTAINERS                                   |   7 +
 crypto/asymmetric_keys/Makefile               |   2 +
 crypto/asymmetric_keys/tests/Makefile         |   4 +
 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c    |  18 +++
 .../asymmetric_keys/tests/rsa_helper_kfuzz.c  |  24 +++
 include/asm-generic/vmlinux.lds.h             |  14 +-
 include/linux/kfuzztest.h                     |  90 +++++++++++
 lib/Kconfig.debug                             |   1 +
 lib/Makefile                                  |   2 +
 lib/kfuzztest/Kconfig                         |  16 ++
 lib/kfuzztest/Makefile                        |   4 +
 lib/kfuzztest/input.c                         |  47 ++++++
 lib/kfuzztest/main.c                          | 142 ++++++++++++++++
 samples/Kconfig                               |   7 +
 samples/Makefile                              |   1 +
 samples/kfuzztest/Makefile                    |   3 +
 samples/kfuzztest/underflow_on_buffer.c       |  52 ++++++
 19 files changed, 586 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/dev-tools/kfuzztest.rst
 create mode 100644 crypto/asymmetric_keys/tests/Makefile
 create mode 100644 crypto/asymmetric_keys/tests/pkcs7_kfuzz.c
 create mode 100644 crypto/asymmetric_keys/tests/rsa_helper_kfuzz.c
 create mode 100644 include/linux/kfuzztest.h
 create mode 100644 lib/kfuzztest/Kconfig
 create mode 100644 lib/kfuzztest/Makefile
 create mode 100644 lib/kfuzztest/input.c
 create mode 100644 lib/kfuzztest/main.c
 create mode 100644 samples/kfuzztest/Makefile
 create mode 100644 samples/kfuzztest/underflow_on_buffer.c

-- 
2.51.0


