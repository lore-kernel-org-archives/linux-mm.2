Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53892FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 19:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3DA6B0005; Tue, 28 Apr 2026 15:31:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254716B008A; Tue, 28 Apr 2026 15:31:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A786B008C; Tue, 28 Apr 2026 15:31:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 036066B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 15:31:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C4721B7F03
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:31:09 +0000 (UTC)
X-FDA: 84708957858.06.66F952E
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id ADCD620015
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:31:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TGq74CHL;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777404667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAI8x2/bEv74FJXz3oAJzkvQVs+0CkcEMU6FT3AZkn4=;
	b=5Uj6TIVlQ7cLPNo2PAVu3uJb3HDENd0RnrZy0wV4wWI0D2IoSRbDwpp7335JKCQcpvaC3o
	/gwIIv5bTqMs58+OfSZE7hYM6+BT0P9QyyPwBuMcIt6YzmPFk0RtC/huTF1Vvcyj9eGFDp
	3XSv0XzQnSEWU9h8k6TiTrV1SP/EQek=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TGq74CHL;
	spf=pass (imf13.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777404667; a=rsa-sha256;
	cv=none;
	b=2X1CxPvkg8hV+fKaqsQLTyf5WpgMMEZEaAfRNLaGBc/KOHXecJ7xAf7PsTmRqDanyDjGPi
	1dzX9l4El7mFOutmC9lGqS1pGsTBY//DD+74kvvU76MBfHvs6KPwG+2qGdj+adLj7Q1w4M
	kSrvEeW22VnnvigvkB5j6mQ00R1ECzw=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cbc593a67aso1071117585a.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 12:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777404667; x=1778009467; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SAI8x2/bEv74FJXz3oAJzkvQVs+0CkcEMU6FT3AZkn4=;
        b=TGq74CHL9dQvMzkMe3qG7ZadrBKCeIldp8qkqMl1ESPukAg8trALRNv64YE0FFfjRU
         Cz+/T4cxIUeuU7ASXQ6vRPcKHuLomHfbceTVgJjUgbYucGbC8eftLPwcsFdP/KyMPWIl
         u2DHuFn7rklDW9v/M+47rZP+Ai3pvbseBfMxnHNGdPIdGJ8pl5h+mzUSjWV1VpbiPih0
         T7PhQor1RcwyKPqfSs7BDcRKdBhl4LlmY++vJ3TPghxAhlmIfFtAKRp0Qml0+80Y6mIj
         OrphnmriWDcx5Hf+vFpnq1ISvRYND1raebC+cODdFqqwOuzdusLu6Ae5imfmyC6/atpV
         +hLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777404667; x=1778009467;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SAI8x2/bEv74FJXz3oAJzkvQVs+0CkcEMU6FT3AZkn4=;
        b=MCvY/5GC6WOSnurD+W/O2lah/BSu6ONfr0olH2rCuexniHEJcLsWZ8abWXuU5Uhfog
         md1WnF2je6H4J1tzA37l1NfnG0+Otscs7U57pmf9Bb8S7kRgzt4LdR9Y3l+bNWZEB0nr
         9CLXg/mAAhRQiOBxTxJaK+G59wLLUKnKmPj8e0fuGATuPM8wk9HQpZPZxzONptXEJLC0
         l0xsE4Y3w93cpetJMF74cJR5XHiAm0lmfivJ1pw5C7pp7c2DLSmnaxsegixg+vUpLVLt
         CH94aHR0IeVFcl+Vx3Smz9MGeH9xt123M+kYMIGrTPx6QTRMc0ovSzteyGe6oEBN0Ylv
         8hYw==
X-Forwarded-Encrypted: i=1; AFNElJ/Yjsx1OetZYP96zeKUQ4CYgAzfFiuCPksWKPcXriLv3NtZMpCcTbDynAtHtnNcfJCXm5NEHfQTnA==@kvack.org
X-Gm-Message-State: AOJu0YymXL6jEHQ/65j35z8+0QSVWV5I4H0py32tA3aQ/DF3Bh0GMtvU
	vFEvYPFYzADCUvu+x09vIUbjrg2ca+N6jMXHXu78d1TOpxCIMf562TULh0d4ciRXZuw=
X-Gm-Gg: AeBDietTN/JRbd1cpl8vVrDh1mbdjA5qrSse6Bsz0CHsIF4PQAFa0eIFFRs08vB6UYc
	7u7BOmEupll/XbKc8T41nHJyEI2f/puM1x0P3/UorzfdWoQumkwEP419iK5zFDKaULOhRFwpuAC
	L58zGp+G4amwNjFReJ1ikUpcwA4o0KdsCcNE2yHdgL6ynz5qVvwj7BMrIlSYbK8alsYp9c9K4sv
	S5jQ5/XXBxI6tpcP7fNuZ0P2m2xg9gjuoHqUSJYRoq+BtqL38s/eXIHOtZ7dovGAjWyJbhiQYoT
	BzWLXcISTaiUH+QR1cuIb18HVpWZ0MBUjZrOQm/cO41k+tko/D0s+Y5BglLEl59GFBEQMTxwRBi
	ZOwUvOZSbi43zgffWc/5gb5VHhXQ27f9lEEYHSbaoCisvVd+TkcTETtwEGTHcWCgOhSSPAdV5KA
	0XalEtnt4QN+iaq89wMJwSp3ixappZgILTUslvNxkljESnWQ0egclVzN8M8E6TSg==
X-Received: by 2002:a05:620a:46a2:b0:8cf:d62a:c81d with SMTP id af79cd13be357-8f7d9201d94mr664574885a.29.1777404666489;
        Tue, 28 Apr 2026 12:31:06 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8f7c85a8eb1sm260640585a.41.2026.04.28.12.31.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 12:31:05 -0700 (PDT)
Date: Tue, 28 Apr 2026 19:31:04 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/6] selftests/liveupdate: add memfd tests
Message-ID: <afEKfQ0GUNVJ76a1@plex>
References: <20260404102452.4091740-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260404102452.4091740-1-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ADCD620015
X-Stat-Signature: z35aoeju5ecoprmtmkk8tq9oqjatqs3e
X-HE-Tag: 1777404667-601507
X-HE-Meta: U2FsdGVkX19/9o4V8F8z+XZrWua52UJU6ST7sTnNfn0UBgd4/r1QQG3izGgMdULej4gJJm8XsAWCUV+X/5naBq4+n64t/CD2QhCOL1rrXbDtU1x3XvUbOd48ItRPLPRrfb1srBKxCRt8Sr9+Mk+2JOjsGdUak2Zw9X1y/15Jmfj5M7o4qGjNJ2scm5xlMAmG8KmJQJPbLZNAiJYCbVrBHfabe/6GPnzaYfJMooIc1/0ry1FRqvtTXXWoGfjQNYwVEM4gis7s6t7OiEDs7E0FNO04FSD3QnNoeRKGhrPe1K5hbMGmeBPVTFMPgzsj85pR1+LwwQZUYokY/yEeGHGTr8PiHqMwnZmMnbps0QCF1lgv3ucPwDwBBo4Bd70YqW5Ym8ATnMloNbl5kT1b3s3u3or6VW9+zlk4SdvGpBoJnKRH3dX2emRi638tT9ZGXRhuJop1kkZfi68Q9FkGOdX0oQEpCVDdOAEiLAORAk4Y8B8A58gwyx8oFsG3L1ZN/LGOcSlir8qowq6+uP3DXoB/TCfFdwYuhuhJaKIp9nskMh5tKezGJKYHVGIzGnLXBGGvGmtcp3N1yAQoBL7lCSrgC6paZ11jUUL8TNcUTffTnEqUXX6BybsGkiwa88hNHzvKBgpMFNlg7eiqelv9dhWPXZYDMPuheKMF5LSPW+nVVRkVLXfuCExg5NLyqPXi78C85jOTW/Hq3zN5jQs0rxP2mle3B0WziQxNfw7IuU4G5kKXSszZizPyR101Udm0bKHIsUH4Ow8tNZ/R+uTTl6+tvIzIdmnNXNdYKSOedZMVhJApRNRMv04z9hIOFhOx9DxV8NnxIOrVM4ZL4TGToWlfcVpBZ2u6FcbmXnOF5r0RTMeWkfk6exD5uSgk63NoeAaHklSnORRMK4WOzwnvZwQKdJ7bNBZYIxfitw3bY7odEDCNfMpIBLhjM/CkxlB5/Ibnv1RJRkV6ut1RpJ5GD4W
 +P8yga35
 k/TLZplSempjJVhx6BapZxRtWXy1bxmtFWIg+WleXVjpyl+WueQGn1n2K2daQeu58RkOSN32mQFLhFzN7FiJiw1bmnDkD4/IlL1FRmqHhVua6opK+MdXQKDEqq6jM3CXSteejlRfpTPERpCBBYC10FLsz99r3vdqMXLYJ3CFCKCwlXM4Bp85QbXZqAGfrTxPXf4wGzE5R6X8XS0YZO3b+9GM7fVcrahoCDEne/UAruOqo2w347MotPz5G1DITLyoWt36AXIGmrhWLaIbH0xJy6TUaguq53F9PbWa/JjYiJ0RS2hPAZE9WnTGnAmWQPYGBssBfrEAvHIt/26Ck7uG46lKh5hZCAb7hp1d+yDrDAgOQPy/AiKTHqo88WMIPqaXo/wAehiPCSxM2QkU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-04 10:24, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Hi,
> 
> This series adds some tests for memfd preservation across a live update.
> Currently memfd is only tested indirectly via luo_kexec_simple or
> luo_multi_session. Add a dedicated test suite for it.
> 
> Patches 1 and 2 are preparatory, adding base framework and helpers, and
> the other patches each add a test. Some of the code is taken from the
> libluo patches [0] I sent a while ago.
> 
> [0] https://lore.kernel.org/linux-mm/20250723144649.1696299-33-pasha.tatashin@soleen.com/

Here are few observations that I noticed when I tried to run your tests:

1. The '-h' tells you nothing about --stage argument:

root@liveupdate-vm:~/liveupdate# ./luo_memfd -h
Usage: ./luo_memfd [-h|-l|-d] [-t|-T|-v|-V|-f|-F|-r name]
	-h       print help
	-l       list all tests
	-d       enable debug prints

	-t name  include test
	-T name  exclude test
	-v name  include variant
	-V name  exclude variant
	-f name  include fixture
	-F name  exclude fixture
	-r name  run specified test
	...

2. '-l' does not work after you run stage1, do you keep /dev/liveupdate 
open? That is not needed, we only need to keep session open.

root@liveupdate-vm:~/liveupdate# ./luo_memfd -l
1..0 # SKIP Failed to open /dev/liveupdate (Device or resource busy) device. Is LUO enabled?

3. Stage 1 has proper [STAGE 1] prefix, but no [STAGE 2] prefix for 
stage 2:
# Starting 4 tests from 1 test cases.
#  RUN           global.memfd_data ...
# [STAGE 1] Forking persistent child to hold sessions...
# [STAGE 1] Child PID: 245. Resources are pinned.
# [STAGE 1] You may now perform kexec reboot.
#            OK  global.memfd_data
ok 1 global.memfd_data
#  RUN           global.zero_memfd ...
# [STAGE 1] Forking persistent child to hold sessions...
# [STAGE 1] Child PID: 247. Resources are pinned.
# [STAGE 1] You may now perform kexec reboot.
#            OK  global.zero_memfd
ok 2 global.zero_memfd
#  RUN           global.preserved_ops ...
#            OK  global.preserved_ops
ok 3 global.preserved_ops
#  RUN           global.fallocate_memfd ...
# [STAGE 1] Forking persistent child to hold sessions...
# [STAGE 1] Child PID: 250. Resources are pinned.
# [STAGE 1] You may now perform kexec reboot.
#            OK  global.fallocate_memfd
ok 4 global.fallocate_memfd
# PASSED: 4 / 4 tests passed.
# Totals: pass:4 fail:0 xfail:0 xpass:0 skip:0 error:0

./do_kexec

root@liveupdate-vm:~/liveupdate# ./luo_memfd
TAP version 13
1..4
# Starting 4 tests from 1 test cases.
#  RUN           global.memfd_data ...
#            OK  global.memfd_data
ok 1 global.memfd_data
#  RUN           global.zero_memfd ...
#            OK  global.zero_memfd
ok 2 global.zero_memfd
#  RUN           global.preserved_ops ...
#      SKIP      test only expected to run on stage 1
#            OK  global.preserved_ops
ok 3 global.preserved_ops # SKIP test only expected to run on stage 1
#  RUN           global.fallocate_memfd ...
#            OK  global.fallocate_memfd
ok 4 global.fallocate_memfd
# PASSED: 4 / 4 tests passed.
# 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
# Totals: pass:3 fail:0 xfail:0 xpass:0 skip:1 error:0

4. I also do not like that we now have duplicated stage parsing code in  
luo_test(), perhaps we should add our own  test_harness_run() variant 
that depends on stage, and use it in both current tests, and the new 
memfd tests.

Pasha

> 
> Changes in v3:
> - Retry on EINTR instead of giving up in read_size() and write_size().
> - Use O_TRUNC in save_test_data().
> - Return the value of write_size() directly in create_random_memfd(). No
>   need to check errno since write_size() already returns -errno.
> - Save errno before calling close() in create_random_memfd() to avoid
>   overwriting the value.
> - Use memcmp() instead of open-coding the comparison loop.
> - Return value of test_harness_run() from main().
> 
> Changes in v2:
> - Drop LIVEUPDATE_DEV since it isn't used.
> - Split luo_fd and stage declaration on separate lines.
> - Split all 2-stage tests into helper function for each test.
> - Fix wording and argument order when LUO_DEVICE fails to open.
> - Rename verify_fd_content() to verify_fd_content_read().
> - Advance buffer pointer in {read,write}_size().
> - Add a check to make sure current working directory is not on a tmpfs
>   mount. If so, skip the tests since saved data files will be lost.
> - Rename RANDOM_DATA_FILE and RANDOM_DATA_FILE_FALLOCATE to
>   MEMFD_DATA_FS_COPY and FALLOCATE_DATA_FS_COPY respectively. Also
>   update the file names to reflect this naming convention.
> - Collect R-bys.
> 
> Regards,
> Pratyush Yadav
> 
> Pratyush Yadav (Google) (6):
>   selftests/liveupdate: add framework for memfd tests
>   selftests/liveupdate: add helper functions for memfd tests
>   selftests/liveupdate: add test for memfd content preservation
>   selftests/liveupdate: add test for zero-size memfd preservation
>   selftests/liveupdate: add test for operations on a preserved memfd
>   selftests/liveupdate: add fallocate test for memfd
> 
>  tools/testing/selftests/liveupdate/Makefile   |   2 +
>  .../testing/selftests/liveupdate/luo_memfd.c  | 355 ++++++++++++++++++
>  .../selftests/liveupdate/luo_test_utils.c     | 191 +++++++++-
>  .../selftests/liveupdate/luo_test_utils.h     |  10 +
>  4 files changed, 557 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/liveupdate/luo_memfd.c
> 
> 
> base-commit: 98ddd87f9704ef2fc837ec2ca38877c364d8dada
> -- 
> 2.53.0.1213.gd9a14994de-goog
> 

